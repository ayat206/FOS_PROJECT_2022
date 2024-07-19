
obj/user/ef_tst_sharing_4:     file format elf32-i386


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
  800031:	e8 5d 05 00 00       	call   800593 <libmain>
1:      jmp 1b
  800036:	eb fe                	jmp    800036 <args_exist+0x5>

00800038 <_main>:
// Test the free of shared variables (create_shared_memory)
#include <inc/lib.h>

void
_main(void)
{
  800038:	55                   	push   %ebp
  800039:	89 e5                	mov    %esp,%ebp
  80003b:	53                   	push   %ebx
  80003c:	83 ec 44             	sub    $0x44,%esp
	//Initial test to ensure it works on "PLACEMENT" not "REPLACEMENT"
	{
		uint8 fullWS = 1;
  80003f:	c6 45 f7 01          	movb   $0x1,-0x9(%ebp)
		for (int i = 0; i < myEnv->page_WS_max_size; ++i)
  800043:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  80004a:	eb 29                	jmp    800075 <_main+0x3d>
		{
			if (myEnv->__uptr_pws[i].empty)
  80004c:	a1 20 50 80 00       	mov    0x805020,%eax
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
_main(void)
{
	//Initial test to ensure it works on "PLACEMENT" not "REPLACEMENT"
	{
		uint8 fullWS = 1;
		for (int i = 0; i < myEnv->page_WS_max_size; ++i)
  800072:	ff 45 f0             	incl   -0x10(%ebp)
  800075:	a1 20 50 80 00       	mov    0x805020,%eax
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
  800092:	6a 12                	push   $0x12
  800094:	68 3c 35 80 00       	push   $0x80353c
  800099:	e8 31 06 00 00       	call   8006cf <_panic>
	}

	cprintf("************************************************\n");
  80009e:	83 ec 0c             	sub    $0xc,%esp
  8000a1:	68 54 35 80 00       	push   $0x803554
  8000a6:	e8 d8 08 00 00       	call   800983 <cprintf>
  8000ab:	83 c4 10             	add    $0x10,%esp
	cprintf("MAKE SURE to have a FRESH RUN for this test\n(i.e. don't run any program/test before it)\n");
  8000ae:	83 ec 0c             	sub    $0xc,%esp
  8000b1:	68 88 35 80 00       	push   $0x803588
  8000b6:	e8 c8 08 00 00       	call   800983 <cprintf>
  8000bb:	83 c4 10             	add    $0x10,%esp
	cprintf("************************************************\n\n\n");
  8000be:	83 ec 0c             	sub    $0xc,%esp
  8000c1:	68 e4 35 80 00       	push   $0x8035e4
  8000c6:	e8 b8 08 00 00       	call   800983 <cprintf>
  8000cb:	83 c4 10             	add    $0x10,%esp

	int Mega = 1024*1024;
  8000ce:	c7 45 ec 00 00 10 00 	movl   $0x100000,-0x14(%ebp)
	int kilo = 1024;
  8000d5:	c7 45 e8 00 04 00 00 	movl   $0x400,-0x18(%ebp)
	int envID = sys_getenvid();
  8000dc:	e8 07 1f 00 00       	call   801fe8 <sys_getenvid>
  8000e1:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	cprintf("STEP A: checking free of a shared object ... \n");
  8000e4:	83 ec 0c             	sub    $0xc,%esp
  8000e7:	68 18 36 80 00       	push   $0x803618
  8000ec:	e8 92 08 00 00       	call   800983 <cprintf>
  8000f1:	83 c4 10             	add    $0x10,%esp
	{
		uint32 *x;
		int freeFrames = sys_calculate_free_frames() ;
  8000f4:	e8 28 1c 00 00       	call   801d21 <sys_calculate_free_frames>
  8000f9:	89 45 e0             	mov    %eax,-0x20(%ebp)
		x = smalloc("x", PAGE_SIZE, 1);
  8000fc:	83 ec 04             	sub    $0x4,%esp
  8000ff:	6a 01                	push   $0x1
  800101:	68 00 10 00 00       	push   $0x1000
  800106:	68 47 36 80 00       	push   $0x803647
  80010b:	e8 4d 19 00 00       	call   801a5d <smalloc>
  800110:	83 c4 10             	add    $0x10,%esp
  800113:	89 45 dc             	mov    %eax,-0x24(%ebp)
		if (x != (uint32*)USER_HEAP_START) panic("Returned address is not correct. check the setting of it and/or the updating of the shared_mem_free_address");
  800116:	81 7d dc 00 00 00 80 	cmpl   $0x80000000,-0x24(%ebp)
  80011d:	74 14                	je     800133 <_main+0xfb>
  80011f:	83 ec 04             	sub    $0x4,%esp
  800122:	68 4c 36 80 00       	push   $0x80364c
  800127:	6a 21                	push   $0x21
  800129:	68 3c 35 80 00       	push   $0x80353c
  80012e:	e8 9c 05 00 00       	call   8006cf <_panic>
		if ((freeFrames - sys_calculate_free_frames()) !=  1+1+2) panic("Wrong allocation: make sure that you allocate the required space in the user environment and add its frames to frames_storage");
  800133:	8b 5d e0             	mov    -0x20(%ebp),%ebx
  800136:	e8 e6 1b 00 00       	call   801d21 <sys_calculate_free_frames>
  80013b:	29 c3                	sub    %eax,%ebx
  80013d:	89 d8                	mov    %ebx,%eax
  80013f:	83 f8 04             	cmp    $0x4,%eax
  800142:	74 14                	je     800158 <_main+0x120>
  800144:	83 ec 04             	sub    $0x4,%esp
  800147:	68 b8 36 80 00       	push   $0x8036b8
  80014c:	6a 22                	push   $0x22
  80014e:	68 3c 35 80 00       	push   $0x80353c
  800153:	e8 77 05 00 00       	call   8006cf <_panic>

		sfree(x);
  800158:	83 ec 0c             	sub    $0xc,%esp
  80015b:	ff 75 dc             	pushl  -0x24(%ebp)
  80015e:	e8 5e 1a 00 00       	call   801bc1 <sfree>
  800163:	83 c4 10             	add    $0x10,%esp
		if ((freeFrames - sys_calculate_free_frames()) ==  0+0+2) panic("Wrong free: make sure that you free the shared object by calling free_share_object()");
  800166:	8b 5d e0             	mov    -0x20(%ebp),%ebx
  800169:	e8 b3 1b 00 00       	call   801d21 <sys_calculate_free_frames>
  80016e:	29 c3                	sub    %eax,%ebx
  800170:	89 d8                	mov    %ebx,%eax
  800172:	83 f8 02             	cmp    $0x2,%eax
  800175:	75 14                	jne    80018b <_main+0x153>
  800177:	83 ec 04             	sub    $0x4,%esp
  80017a:	68 38 37 80 00       	push   $0x803738
  80017f:	6a 25                	push   $0x25
  800181:	68 3c 35 80 00       	push   $0x80353c
  800186:	e8 44 05 00 00       	call   8006cf <_panic>
		else if ((freeFrames - sys_calculate_free_frames()) !=  0) panic("Wrong free: revise your freeSharedObject logic");
  80018b:	e8 91 1b 00 00       	call   801d21 <sys_calculate_free_frames>
  800190:	89 c2                	mov    %eax,%edx
  800192:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800195:	39 c2                	cmp    %eax,%edx
  800197:	74 14                	je     8001ad <_main+0x175>
  800199:	83 ec 04             	sub    $0x4,%esp
  80019c:	68 90 37 80 00       	push   $0x803790
  8001a1:	6a 26                	push   $0x26
  8001a3:	68 3c 35 80 00       	push   $0x80353c
  8001a8:	e8 22 05 00 00       	call   8006cf <_panic>
	}
	cprintf("Step A completed successfully!!\n\n\n");
  8001ad:	83 ec 0c             	sub    $0xc,%esp
  8001b0:	68 c0 37 80 00       	push   $0x8037c0
  8001b5:	e8 c9 07 00 00       	call   800983 <cprintf>
  8001ba:	83 c4 10             	add    $0x10,%esp


	cprintf("STEP B: checking free of 2 shared objects ... \n");
  8001bd:	83 ec 0c             	sub    $0xc,%esp
  8001c0:	68 e4 37 80 00       	push   $0x8037e4
  8001c5:	e8 b9 07 00 00       	call   800983 <cprintf>
  8001ca:	83 c4 10             	add    $0x10,%esp
	{
		uint32 *x, *z ;
		int freeFrames = sys_calculate_free_frames() ;
  8001cd:	e8 4f 1b 00 00       	call   801d21 <sys_calculate_free_frames>
  8001d2:	89 45 d8             	mov    %eax,-0x28(%ebp)
		z = smalloc("z", PAGE_SIZE, 1);
  8001d5:	83 ec 04             	sub    $0x4,%esp
  8001d8:	6a 01                	push   $0x1
  8001da:	68 00 10 00 00       	push   $0x1000
  8001df:	68 14 38 80 00       	push   $0x803814
  8001e4:	e8 74 18 00 00       	call   801a5d <smalloc>
  8001e9:	83 c4 10             	add    $0x10,%esp
  8001ec:	89 45 d4             	mov    %eax,-0x2c(%ebp)
		x = smalloc("x", PAGE_SIZE, 1);
  8001ef:	83 ec 04             	sub    $0x4,%esp
  8001f2:	6a 01                	push   $0x1
  8001f4:	68 00 10 00 00       	push   $0x1000
  8001f9:	68 47 36 80 00       	push   $0x803647
  8001fe:	e8 5a 18 00 00       	call   801a5d <smalloc>
  800203:	83 c4 10             	add    $0x10,%esp
  800206:	89 45 d0             	mov    %eax,-0x30(%ebp)

		if(x == NULL) panic("Wrong free: make sure that you free the shared object by calling free_share_object()");
  800209:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
  80020d:	75 14                	jne    800223 <_main+0x1eb>
  80020f:	83 ec 04             	sub    $0x4,%esp
  800212:	68 38 37 80 00       	push   $0x803738
  800217:	6a 32                	push   $0x32
  800219:	68 3c 35 80 00       	push   $0x80353c
  80021e:	e8 ac 04 00 00       	call   8006cf <_panic>

		if ((freeFrames - sys_calculate_free_frames()) !=  2+1+4) panic("Wrong previous free: make sure that you correctly free shared object before (Step A)");
  800223:	8b 5d d8             	mov    -0x28(%ebp),%ebx
  800226:	e8 f6 1a 00 00       	call   801d21 <sys_calculate_free_frames>
  80022b:	29 c3                	sub    %eax,%ebx
  80022d:	89 d8                	mov    %ebx,%eax
  80022f:	83 f8 07             	cmp    $0x7,%eax
  800232:	74 14                	je     800248 <_main+0x210>
  800234:	83 ec 04             	sub    $0x4,%esp
  800237:	68 18 38 80 00       	push   $0x803818
  80023c:	6a 34                	push   $0x34
  80023e:	68 3c 35 80 00       	push   $0x80353c
  800243:	e8 87 04 00 00       	call   8006cf <_panic>

		sfree(z);
  800248:	83 ec 0c             	sub    $0xc,%esp
  80024b:	ff 75 d4             	pushl  -0x2c(%ebp)
  80024e:	e8 6e 19 00 00       	call   801bc1 <sfree>
  800253:	83 c4 10             	add    $0x10,%esp
		if ((freeFrames - sys_calculate_free_frames()) !=  1+1+2) panic("Wrong free: check your logic");
  800256:	8b 5d d8             	mov    -0x28(%ebp),%ebx
  800259:	e8 c3 1a 00 00       	call   801d21 <sys_calculate_free_frames>
  80025e:	29 c3                	sub    %eax,%ebx
  800260:	89 d8                	mov    %ebx,%eax
  800262:	83 f8 04             	cmp    $0x4,%eax
  800265:	74 14                	je     80027b <_main+0x243>
  800267:	83 ec 04             	sub    $0x4,%esp
  80026a:	68 6d 38 80 00       	push   $0x80386d
  80026f:	6a 37                	push   $0x37
  800271:	68 3c 35 80 00       	push   $0x80353c
  800276:	e8 54 04 00 00       	call   8006cf <_panic>

		sfree(x);
  80027b:	83 ec 0c             	sub    $0xc,%esp
  80027e:	ff 75 d0             	pushl  -0x30(%ebp)
  800281:	e8 3b 19 00 00       	call   801bc1 <sfree>
  800286:	83 c4 10             	add    $0x10,%esp
		if ((freeFrames - sys_calculate_free_frames()) !=  0) panic("Wrong free: check your logic");
  800289:	e8 93 1a 00 00       	call   801d21 <sys_calculate_free_frames>
  80028e:	89 c2                	mov    %eax,%edx
  800290:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800293:	39 c2                	cmp    %eax,%edx
  800295:	74 14                	je     8002ab <_main+0x273>
  800297:	83 ec 04             	sub    $0x4,%esp
  80029a:	68 6d 38 80 00       	push   $0x80386d
  80029f:	6a 3a                	push   $0x3a
  8002a1:	68 3c 35 80 00       	push   $0x80353c
  8002a6:	e8 24 04 00 00       	call   8006cf <_panic>

	}
	cprintf("Step B completed successfully!!\n\n\n");
  8002ab:	83 ec 0c             	sub    $0xc,%esp
  8002ae:	68 8c 38 80 00       	push   $0x80388c
  8002b3:	e8 cb 06 00 00       	call   800983 <cprintf>
  8002b8:	83 c4 10             	add    $0x10,%esp

	cprintf("STEP C: checking range of loop during free... \n");
  8002bb:	83 ec 0c             	sub    $0xc,%esp
  8002be:	68 b0 38 80 00       	push   $0x8038b0
  8002c3:	e8 bb 06 00 00       	call   800983 <cprintf>
  8002c8:	83 c4 10             	add    $0x10,%esp
	{
		uint32 *w, *u;
		int freeFrames = sys_calculate_free_frames() ;
  8002cb:	e8 51 1a 00 00       	call   801d21 <sys_calculate_free_frames>
  8002d0:	89 45 cc             	mov    %eax,-0x34(%ebp)
		w = smalloc("w", 3 * PAGE_SIZE+1, 1);
  8002d3:	83 ec 04             	sub    $0x4,%esp
  8002d6:	6a 01                	push   $0x1
  8002d8:	68 01 30 00 00       	push   $0x3001
  8002dd:	68 e0 38 80 00       	push   $0x8038e0
  8002e2:	e8 76 17 00 00       	call   801a5d <smalloc>
  8002e7:	83 c4 10             	add    $0x10,%esp
  8002ea:	89 45 c8             	mov    %eax,-0x38(%ebp)
		u = smalloc("u", PAGE_SIZE, 1);
  8002ed:	83 ec 04             	sub    $0x4,%esp
  8002f0:	6a 01                	push   $0x1
  8002f2:	68 00 10 00 00       	push   $0x1000
  8002f7:	68 e2 38 80 00       	push   $0x8038e2
  8002fc:	e8 5c 17 00 00       	call   801a5d <smalloc>
  800301:	83 c4 10             	add    $0x10,%esp
  800304:	89 45 c4             	mov    %eax,-0x3c(%ebp)

		if ((freeFrames - sys_calculate_free_frames()) != 5+1+4) panic("Wrong allocation: make sure that you allocate the required space in the user environment and add its frames to frames_storage");
  800307:	8b 5d cc             	mov    -0x34(%ebp),%ebx
  80030a:	e8 12 1a 00 00       	call   801d21 <sys_calculate_free_frames>
  80030f:	29 c3                	sub    %eax,%ebx
  800311:	89 d8                	mov    %ebx,%eax
  800313:	83 f8 0a             	cmp    $0xa,%eax
  800316:	74 14                	je     80032c <_main+0x2f4>
  800318:	83 ec 04             	sub    $0x4,%esp
  80031b:	68 b8 36 80 00       	push   $0x8036b8
  800320:	6a 46                	push   $0x46
  800322:	68 3c 35 80 00       	push   $0x80353c
  800327:	e8 a3 03 00 00       	call   8006cf <_panic>

		sfree(w);
  80032c:	83 ec 0c             	sub    $0xc,%esp
  80032f:	ff 75 c8             	pushl  -0x38(%ebp)
  800332:	e8 8a 18 00 00       	call   801bc1 <sfree>
  800337:	83 c4 10             	add    $0x10,%esp
		if ((freeFrames - sys_calculate_free_frames()) !=  1+1+2) panic("Wrong free: check your logic");
  80033a:	8b 5d cc             	mov    -0x34(%ebp),%ebx
  80033d:	e8 df 19 00 00       	call   801d21 <sys_calculate_free_frames>
  800342:	29 c3                	sub    %eax,%ebx
  800344:	89 d8                	mov    %ebx,%eax
  800346:	83 f8 04             	cmp    $0x4,%eax
  800349:	74 14                	je     80035f <_main+0x327>
  80034b:	83 ec 04             	sub    $0x4,%esp
  80034e:	68 6d 38 80 00       	push   $0x80386d
  800353:	6a 49                	push   $0x49
  800355:	68 3c 35 80 00       	push   $0x80353c
  80035a:	e8 70 03 00 00       	call   8006cf <_panic>

		uint32 *o;
		o = smalloc("o", 2 * PAGE_SIZE-1,1);
  80035f:	83 ec 04             	sub    $0x4,%esp
  800362:	6a 01                	push   $0x1
  800364:	68 ff 1f 00 00       	push   $0x1fff
  800369:	68 e4 38 80 00       	push   $0x8038e4
  80036e:	e8 ea 16 00 00       	call   801a5d <smalloc>
  800373:	83 c4 10             	add    $0x10,%esp
  800376:	89 45 c0             	mov    %eax,-0x40(%ebp)

		if ((freeFrames - sys_calculate_free_frames()) != 3+1+4) panic("Wrong allocation: make sure that you allocate the required space in the user environment and add its frames to frames_storage");
  800379:	8b 5d cc             	mov    -0x34(%ebp),%ebx
  80037c:	e8 a0 19 00 00       	call   801d21 <sys_calculate_free_frames>
  800381:	29 c3                	sub    %eax,%ebx
  800383:	89 d8                	mov    %ebx,%eax
  800385:	83 f8 08             	cmp    $0x8,%eax
  800388:	74 14                	je     80039e <_main+0x366>
  80038a:	83 ec 04             	sub    $0x4,%esp
  80038d:	68 b8 36 80 00       	push   $0x8036b8
  800392:	6a 4e                	push   $0x4e
  800394:	68 3c 35 80 00       	push   $0x80353c
  800399:	e8 31 03 00 00       	call   8006cf <_panic>

		sfree(o);
  80039e:	83 ec 0c             	sub    $0xc,%esp
  8003a1:	ff 75 c0             	pushl  -0x40(%ebp)
  8003a4:	e8 18 18 00 00       	call   801bc1 <sfree>
  8003a9:	83 c4 10             	add    $0x10,%esp
		if ((freeFrames - sys_calculate_free_frames()) !=  1+1+2) panic("Wrong free: check your logic");
  8003ac:	8b 5d cc             	mov    -0x34(%ebp),%ebx
  8003af:	e8 6d 19 00 00       	call   801d21 <sys_calculate_free_frames>
  8003b4:	29 c3                	sub    %eax,%ebx
  8003b6:	89 d8                	mov    %ebx,%eax
  8003b8:	83 f8 04             	cmp    $0x4,%eax
  8003bb:	74 14                	je     8003d1 <_main+0x399>
  8003bd:	83 ec 04             	sub    $0x4,%esp
  8003c0:	68 6d 38 80 00       	push   $0x80386d
  8003c5:	6a 51                	push   $0x51
  8003c7:	68 3c 35 80 00       	push   $0x80353c
  8003cc:	e8 fe 02 00 00       	call   8006cf <_panic>

		sfree(u);
  8003d1:	83 ec 0c             	sub    $0xc,%esp
  8003d4:	ff 75 c4             	pushl  -0x3c(%ebp)
  8003d7:	e8 e5 17 00 00       	call   801bc1 <sfree>
  8003dc:	83 c4 10             	add    $0x10,%esp
		if ((freeFrames - sys_calculate_free_frames()) !=  0) panic("Wrong free: check your logic");
  8003df:	e8 3d 19 00 00       	call   801d21 <sys_calculate_free_frames>
  8003e4:	89 c2                	mov    %eax,%edx
  8003e6:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8003e9:	39 c2                	cmp    %eax,%edx
  8003eb:	74 14                	je     800401 <_main+0x3c9>
  8003ed:	83 ec 04             	sub    $0x4,%esp
  8003f0:	68 6d 38 80 00       	push   $0x80386d
  8003f5:	6a 54                	push   $0x54
  8003f7:	68 3c 35 80 00       	push   $0x80353c
  8003fc:	e8 ce 02 00 00       	call   8006cf <_panic>


		//Checking boundaries of page tables
		freeFrames = sys_calculate_free_frames() ;
  800401:	e8 1b 19 00 00       	call   801d21 <sys_calculate_free_frames>
  800406:	89 45 cc             	mov    %eax,-0x34(%ebp)
		w = smalloc("w", 3 * Mega - 1*kilo, 1);
  800409:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80040c:	89 c2                	mov    %eax,%edx
  80040e:	01 d2                	add    %edx,%edx
  800410:	01 d0                	add    %edx,%eax
  800412:	2b 45 e8             	sub    -0x18(%ebp),%eax
  800415:	83 ec 04             	sub    $0x4,%esp
  800418:	6a 01                	push   $0x1
  80041a:	50                   	push   %eax
  80041b:	68 e0 38 80 00       	push   $0x8038e0
  800420:	e8 38 16 00 00       	call   801a5d <smalloc>
  800425:	83 c4 10             	add    $0x10,%esp
  800428:	89 45 c8             	mov    %eax,-0x38(%ebp)
		u = smalloc("u", 7 * Mega - 1*kilo, 1);
  80042b:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80042e:	89 d0                	mov    %edx,%eax
  800430:	01 c0                	add    %eax,%eax
  800432:	01 d0                	add    %edx,%eax
  800434:	01 c0                	add    %eax,%eax
  800436:	01 d0                	add    %edx,%eax
  800438:	2b 45 e8             	sub    -0x18(%ebp),%eax
  80043b:	83 ec 04             	sub    $0x4,%esp
  80043e:	6a 01                	push   $0x1
  800440:	50                   	push   %eax
  800441:	68 e2 38 80 00       	push   $0x8038e2
  800446:	e8 12 16 00 00       	call   801a5d <smalloc>
  80044b:	83 c4 10             	add    $0x10,%esp
  80044e:	89 45 c4             	mov    %eax,-0x3c(%ebp)
		o = smalloc("o", 2 * Mega + 1*kilo, 1);
  800451:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800454:	01 c0                	add    %eax,%eax
  800456:	89 c2                	mov    %eax,%edx
  800458:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80045b:	01 d0                	add    %edx,%eax
  80045d:	83 ec 04             	sub    $0x4,%esp
  800460:	6a 01                	push   $0x1
  800462:	50                   	push   %eax
  800463:	68 e4 38 80 00       	push   $0x8038e4
  800468:	e8 f0 15 00 00       	call   801a5d <smalloc>
  80046d:	83 c4 10             	add    $0x10,%esp
  800470:	89 45 c0             	mov    %eax,-0x40(%ebp)

		if ((freeFrames - sys_calculate_free_frames()) != 3073+4+7) panic("Wrong allocation: make sure that you allocate the required space in the user environment and add its frames to frames_storage");
  800473:	8b 5d cc             	mov    -0x34(%ebp),%ebx
  800476:	e8 a6 18 00 00       	call   801d21 <sys_calculate_free_frames>
  80047b:	29 c3                	sub    %eax,%ebx
  80047d:	89 d8                	mov    %ebx,%eax
  80047f:	3d 0c 0c 00 00       	cmp    $0xc0c,%eax
  800484:	74 14                	je     80049a <_main+0x462>
  800486:	83 ec 04             	sub    $0x4,%esp
  800489:	68 b8 36 80 00       	push   $0x8036b8
  80048e:	6a 5d                	push   $0x5d
  800490:	68 3c 35 80 00       	push   $0x80353c
  800495:	e8 35 02 00 00       	call   8006cf <_panic>

		sfree(o);
  80049a:	83 ec 0c             	sub    $0xc,%esp
  80049d:	ff 75 c0             	pushl  -0x40(%ebp)
  8004a0:	e8 1c 17 00 00       	call   801bc1 <sfree>
  8004a5:	83 c4 10             	add    $0x10,%esp
		if ((freeFrames - sys_calculate_free_frames()) !=  2560+3+5) panic("Wrong free: check your logic");
  8004a8:	8b 5d cc             	mov    -0x34(%ebp),%ebx
  8004ab:	e8 71 18 00 00       	call   801d21 <sys_calculate_free_frames>
  8004b0:	29 c3                	sub    %eax,%ebx
  8004b2:	89 d8                	mov    %ebx,%eax
  8004b4:	3d 08 0a 00 00       	cmp    $0xa08,%eax
  8004b9:	74 14                	je     8004cf <_main+0x497>
  8004bb:	83 ec 04             	sub    $0x4,%esp
  8004be:	68 6d 38 80 00       	push   $0x80386d
  8004c3:	6a 60                	push   $0x60
  8004c5:	68 3c 35 80 00       	push   $0x80353c
  8004ca:	e8 00 02 00 00       	call   8006cf <_panic>

		sfree(w);
  8004cf:	83 ec 0c             	sub    $0xc,%esp
  8004d2:	ff 75 c8             	pushl  -0x38(%ebp)
  8004d5:	e8 e7 16 00 00       	call   801bc1 <sfree>
  8004da:	83 c4 10             	add    $0x10,%esp
		if ((freeFrames - sys_calculate_free_frames()) !=  1792+3+3) panic("Wrong free: check your logic");
  8004dd:	8b 5d cc             	mov    -0x34(%ebp),%ebx
  8004e0:	e8 3c 18 00 00       	call   801d21 <sys_calculate_free_frames>
  8004e5:	29 c3                	sub    %eax,%ebx
  8004e7:	89 d8                	mov    %ebx,%eax
  8004e9:	3d 06 07 00 00       	cmp    $0x706,%eax
  8004ee:	74 14                	je     800504 <_main+0x4cc>
  8004f0:	83 ec 04             	sub    $0x4,%esp
  8004f3:	68 6d 38 80 00       	push   $0x80386d
  8004f8:	6a 63                	push   $0x63
  8004fa:	68 3c 35 80 00       	push   $0x80353c
  8004ff:	e8 cb 01 00 00       	call   8006cf <_panic>

		sfree(u);
  800504:	83 ec 0c             	sub    $0xc,%esp
  800507:	ff 75 c4             	pushl  -0x3c(%ebp)
  80050a:	e8 b2 16 00 00       	call   801bc1 <sfree>
  80050f:	83 c4 10             	add    $0x10,%esp
		if ((freeFrames - sys_calculate_free_frames()) !=  0) panic("Wrong free: check your logic");
  800512:	e8 0a 18 00 00       	call   801d21 <sys_calculate_free_frames>
  800517:	89 c2                	mov    %eax,%edx
  800519:	8b 45 cc             	mov    -0x34(%ebp),%eax
  80051c:	39 c2                	cmp    %eax,%edx
  80051e:	74 14                	je     800534 <_main+0x4fc>
  800520:	83 ec 04             	sub    $0x4,%esp
  800523:	68 6d 38 80 00       	push   $0x80386d
  800528:	6a 66                	push   $0x66
  80052a:	68 3c 35 80 00       	push   $0x80353c
  80052f:	e8 9b 01 00 00       	call   8006cf <_panic>
	}
	cprintf("Step C completed successfully!!\n\n\n");
  800534:	83 ec 0c             	sub    $0xc,%esp
  800537:	68 e8 38 80 00       	push   $0x8038e8
  80053c:	e8 42 04 00 00       	call   800983 <cprintf>
  800541:	83 c4 10             	add    $0x10,%esp

	cprintf("Congratulations!! Test of freeSharedObjects [4] completed successfully!!\n\n\n");
  800544:	83 ec 0c             	sub    $0xc,%esp
  800547:	68 0c 39 80 00       	push   $0x80390c
  80054c:	e8 32 04 00 00       	call   800983 <cprintf>
  800551:	83 c4 10             	add    $0x10,%esp

	int32 parentenvID = sys_getparentenvid();
  800554:	e8 c1 1a 00 00       	call   80201a <sys_getparentenvid>
  800559:	89 45 bc             	mov    %eax,-0x44(%ebp)
	if(parentenvID > 0)
  80055c:	83 7d bc 00          	cmpl   $0x0,-0x44(%ebp)
  800560:	7e 2b                	jle    80058d <_main+0x555>
	{
		//Get the check-finishing counter
		int *finishedCount = NULL;
  800562:	c7 45 b8 00 00 00 00 	movl   $0x0,-0x48(%ebp)
		finishedCount = sget(parentenvID, "finishedCount") ;
  800569:	83 ec 08             	sub    $0x8,%esp
  80056c:	68 58 39 80 00       	push   $0x803958
  800571:	ff 75 bc             	pushl  -0x44(%ebp)
  800574:	e8 94 15 00 00       	call   801b0d <sget>
  800579:	83 c4 10             	add    $0x10,%esp
  80057c:	89 45 b8             	mov    %eax,-0x48(%ebp)
		(*finishedCount)++ ;
  80057f:	8b 45 b8             	mov    -0x48(%ebp),%eax
  800582:	8b 00                	mov    (%eax),%eax
  800584:	8d 50 01             	lea    0x1(%eax),%edx
  800587:	8b 45 b8             	mov    -0x48(%ebp),%eax
  80058a:	89 10                	mov    %edx,(%eax)
	}
	return;
  80058c:	90                   	nop
  80058d:	90                   	nop
}
  80058e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800591:	c9                   	leave  
  800592:	c3                   	ret    

00800593 <libmain>:
volatile struct Env *myEnv = NULL;
volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";

void
libmain(int argc, char **argv)
{
  800593:	55                   	push   %ebp
  800594:	89 e5                	mov    %esp,%ebp
  800596:	83 ec 18             	sub    $0x18,%esp
	int envIndex = sys_getenvindex();
  800599:	e8 63 1a 00 00       	call   802001 <sys_getenvindex>
  80059e:	89 45 f4             	mov    %eax,-0xc(%ebp)
	myEnv = &(envs[envIndex]);
  8005a1:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8005a4:	89 d0                	mov    %edx,%eax
  8005a6:	c1 e0 03             	shl    $0x3,%eax
  8005a9:	01 d0                	add    %edx,%eax
  8005ab:	01 c0                	add    %eax,%eax
  8005ad:	01 d0                	add    %edx,%eax
  8005af:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8005b6:	01 d0                	add    %edx,%eax
  8005b8:	c1 e0 04             	shl    $0x4,%eax
  8005bb:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  8005c0:	a3 20 50 80 00       	mov    %eax,0x805020

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  8005c5:	a1 20 50 80 00       	mov    0x805020,%eax
  8005ca:	8a 80 5c 05 00 00    	mov    0x55c(%eax),%al
  8005d0:	84 c0                	test   %al,%al
  8005d2:	74 0f                	je     8005e3 <libmain+0x50>
		binaryname = myEnv->prog_name;
  8005d4:	a1 20 50 80 00       	mov    0x805020,%eax
  8005d9:	05 5c 05 00 00       	add    $0x55c,%eax
  8005de:	a3 00 50 80 00       	mov    %eax,0x805000

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  8005e3:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8005e7:	7e 0a                	jle    8005f3 <libmain+0x60>
		binaryname = argv[0];
  8005e9:	8b 45 0c             	mov    0xc(%ebp),%eax
  8005ec:	8b 00                	mov    (%eax),%eax
  8005ee:	a3 00 50 80 00       	mov    %eax,0x805000

	// call user main routine
	_main(argc, argv);
  8005f3:	83 ec 08             	sub    $0x8,%esp
  8005f6:	ff 75 0c             	pushl  0xc(%ebp)
  8005f9:	ff 75 08             	pushl  0x8(%ebp)
  8005fc:	e8 37 fa ff ff       	call   800038 <_main>
  800601:	83 c4 10             	add    $0x10,%esp



	sys_disable_interrupt();
  800604:	e8 05 18 00 00       	call   801e0e <sys_disable_interrupt>
	cprintf("**************************************\n");
  800609:	83 ec 0c             	sub    $0xc,%esp
  80060c:	68 80 39 80 00       	push   $0x803980
  800611:	e8 6d 03 00 00       	call   800983 <cprintf>
  800616:	83 c4 10             	add    $0x10,%esp
	cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  800619:	a1 20 50 80 00       	mov    0x805020,%eax
  80061e:	8b 90 44 05 00 00    	mov    0x544(%eax),%edx
  800624:	a1 20 50 80 00       	mov    0x805020,%eax
  800629:	8b 80 34 05 00 00    	mov    0x534(%eax),%eax
  80062f:	83 ec 04             	sub    $0x4,%esp
  800632:	52                   	push   %edx
  800633:	50                   	push   %eax
  800634:	68 a8 39 80 00       	push   $0x8039a8
  800639:	e8 45 03 00 00       	call   800983 <cprintf>
  80063e:	83 c4 10             	add    $0x10,%esp
	cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  800641:	a1 20 50 80 00       	mov    0x805020,%eax
  800646:	8b 88 54 05 00 00    	mov    0x554(%eax),%ecx
  80064c:	a1 20 50 80 00       	mov    0x805020,%eax
  800651:	8b 90 50 05 00 00    	mov    0x550(%eax),%edx
  800657:	a1 20 50 80 00       	mov    0x805020,%eax
  80065c:	8b 80 4c 05 00 00    	mov    0x54c(%eax),%eax
  800662:	51                   	push   %ecx
  800663:	52                   	push   %edx
  800664:	50                   	push   %eax
  800665:	68 d0 39 80 00       	push   $0x8039d0
  80066a:	e8 14 03 00 00       	call   800983 <cprintf>
  80066f:	83 c4 10             	add    $0x10,%esp
	//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
	cprintf("Num of clocks = %d\n", myEnv->nClocks);
  800672:	a1 20 50 80 00       	mov    0x805020,%eax
  800677:	8b 80 a4 05 00 00    	mov    0x5a4(%eax),%eax
  80067d:	83 ec 08             	sub    $0x8,%esp
  800680:	50                   	push   %eax
  800681:	68 28 3a 80 00       	push   $0x803a28
  800686:	e8 f8 02 00 00       	call   800983 <cprintf>
  80068b:	83 c4 10             	add    $0x10,%esp
	cprintf("**************************************\n");
  80068e:	83 ec 0c             	sub    $0xc,%esp
  800691:	68 80 39 80 00       	push   $0x803980
  800696:	e8 e8 02 00 00       	call   800983 <cprintf>
  80069b:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  80069e:	e8 85 17 00 00       	call   801e28 <sys_enable_interrupt>

	// exit gracefully
	exit();
  8006a3:	e8 19 00 00 00       	call   8006c1 <exit>
}
  8006a8:	90                   	nop
  8006a9:	c9                   	leave  
  8006aa:	c3                   	ret    

008006ab <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  8006ab:	55                   	push   %ebp
  8006ac:	89 e5                	mov    %esp,%ebp
  8006ae:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  8006b1:	83 ec 0c             	sub    $0xc,%esp
  8006b4:	6a 00                	push   $0x0
  8006b6:	e8 12 19 00 00       	call   801fcd <sys_destroy_env>
  8006bb:	83 c4 10             	add    $0x10,%esp
}
  8006be:	90                   	nop
  8006bf:	c9                   	leave  
  8006c0:	c3                   	ret    

008006c1 <exit>:

void
exit(void)
{
  8006c1:	55                   	push   %ebp
  8006c2:	89 e5                	mov    %esp,%ebp
  8006c4:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  8006c7:	e8 67 19 00 00       	call   802033 <sys_exit_env>
}
  8006cc:	90                   	nop
  8006cd:	c9                   	leave  
  8006ce:	c3                   	ret    

008006cf <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  8006cf:	55                   	push   %ebp
  8006d0:	89 e5                	mov    %esp,%ebp
  8006d2:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  8006d5:	8d 45 10             	lea    0x10(%ebp),%eax
  8006d8:	83 c0 04             	add    $0x4,%eax
  8006db:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  8006de:	a1 5c 51 80 00       	mov    0x80515c,%eax
  8006e3:	85 c0                	test   %eax,%eax
  8006e5:	74 16                	je     8006fd <_panic+0x2e>
		cprintf("%s: ", argv0);
  8006e7:	a1 5c 51 80 00       	mov    0x80515c,%eax
  8006ec:	83 ec 08             	sub    $0x8,%esp
  8006ef:	50                   	push   %eax
  8006f0:	68 3c 3a 80 00       	push   $0x803a3c
  8006f5:	e8 89 02 00 00       	call   800983 <cprintf>
  8006fa:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  8006fd:	a1 00 50 80 00       	mov    0x805000,%eax
  800702:	ff 75 0c             	pushl  0xc(%ebp)
  800705:	ff 75 08             	pushl  0x8(%ebp)
  800708:	50                   	push   %eax
  800709:	68 41 3a 80 00       	push   $0x803a41
  80070e:	e8 70 02 00 00       	call   800983 <cprintf>
  800713:	83 c4 10             	add    $0x10,%esp
	vcprintf(fmt, ap);
  800716:	8b 45 10             	mov    0x10(%ebp),%eax
  800719:	83 ec 08             	sub    $0x8,%esp
  80071c:	ff 75 f4             	pushl  -0xc(%ebp)
  80071f:	50                   	push   %eax
  800720:	e8 f3 01 00 00       	call   800918 <vcprintf>
  800725:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  800728:	83 ec 08             	sub    $0x8,%esp
  80072b:	6a 00                	push   $0x0
  80072d:	68 5d 3a 80 00       	push   $0x803a5d
  800732:	e8 e1 01 00 00       	call   800918 <vcprintf>
  800737:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  80073a:	e8 82 ff ff ff       	call   8006c1 <exit>

	// should not return here
	while (1) ;
  80073f:	eb fe                	jmp    80073f <_panic+0x70>

00800741 <CheckWSWithoutLastIndex>:
}

void CheckWSWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  800741:	55                   	push   %ebp
  800742:	89 e5                	mov    %esp,%ebp
  800744:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  800747:	a1 20 50 80 00       	mov    0x805020,%eax
  80074c:	8b 50 74             	mov    0x74(%eax),%edx
  80074f:	8b 45 0c             	mov    0xc(%ebp),%eax
  800752:	39 c2                	cmp    %eax,%edx
  800754:	74 14                	je     80076a <CheckWSWithoutLastIndex+0x29>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  800756:	83 ec 04             	sub    $0x4,%esp
  800759:	68 60 3a 80 00       	push   $0x803a60
  80075e:	6a 26                	push   $0x26
  800760:	68 ac 3a 80 00       	push   $0x803aac
  800765:	e8 65 ff ff ff       	call   8006cf <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  80076a:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  800771:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800778:	e9 c2 00 00 00       	jmp    80083f <CheckWSWithoutLastIndex+0xfe>
		if (expectedPages[e] == 0) {
  80077d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800780:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800787:	8b 45 08             	mov    0x8(%ebp),%eax
  80078a:	01 d0                	add    %edx,%eax
  80078c:	8b 00                	mov    (%eax),%eax
  80078e:	85 c0                	test   %eax,%eax
  800790:	75 08                	jne    80079a <CheckWSWithoutLastIndex+0x59>
			expectedNumOfEmptyLocs++;
  800792:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  800795:	e9 a2 00 00 00       	jmp    80083c <CheckWSWithoutLastIndex+0xfb>
		}
		int found = 0;
  80079a:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8007a1:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  8007a8:	eb 69                	jmp    800813 <CheckWSWithoutLastIndex+0xd2>
			if (myEnv->__uptr_pws[w].empty == 0) {
  8007aa:	a1 20 50 80 00       	mov    0x805020,%eax
  8007af:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  8007b5:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8007b8:	89 d0                	mov    %edx,%eax
  8007ba:	01 c0                	add    %eax,%eax
  8007bc:	01 d0                	add    %edx,%eax
  8007be:	c1 e0 03             	shl    $0x3,%eax
  8007c1:	01 c8                	add    %ecx,%eax
  8007c3:	8a 40 04             	mov    0x4(%eax),%al
  8007c6:	84 c0                	test   %al,%al
  8007c8:	75 46                	jne    800810 <CheckWSWithoutLastIndex+0xcf>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  8007ca:	a1 20 50 80 00       	mov    0x805020,%eax
  8007cf:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  8007d5:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8007d8:	89 d0                	mov    %edx,%eax
  8007da:	01 c0                	add    %eax,%eax
  8007dc:	01 d0                	add    %edx,%eax
  8007de:	c1 e0 03             	shl    $0x3,%eax
  8007e1:	01 c8                	add    %ecx,%eax
  8007e3:	8b 00                	mov    (%eax),%eax
  8007e5:	89 45 dc             	mov    %eax,-0x24(%ebp)
  8007e8:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8007eb:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8007f0:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  8007f2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8007f5:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  8007fc:	8b 45 08             	mov    0x8(%ebp),%eax
  8007ff:	01 c8                	add    %ecx,%eax
  800801:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  800803:	39 c2                	cmp    %eax,%edx
  800805:	75 09                	jne    800810 <CheckWSWithoutLastIndex+0xcf>
						== expectedPages[e]) {
					found = 1;
  800807:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  80080e:	eb 12                	jmp    800822 <CheckWSWithoutLastIndex+0xe1>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800810:	ff 45 e8             	incl   -0x18(%ebp)
  800813:	a1 20 50 80 00       	mov    0x805020,%eax
  800818:	8b 50 74             	mov    0x74(%eax),%edx
  80081b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80081e:	39 c2                	cmp    %eax,%edx
  800820:	77 88                	ja     8007aa <CheckWSWithoutLastIndex+0x69>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  800822:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  800826:	75 14                	jne    80083c <CheckWSWithoutLastIndex+0xfb>
			panic(
  800828:	83 ec 04             	sub    $0x4,%esp
  80082b:	68 b8 3a 80 00       	push   $0x803ab8
  800830:	6a 3a                	push   $0x3a
  800832:	68 ac 3a 80 00       	push   $0x803aac
  800837:	e8 93 fe ff ff       	call   8006cf <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  80083c:	ff 45 f0             	incl   -0x10(%ebp)
  80083f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800842:	3b 45 0c             	cmp    0xc(%ebp),%eax
  800845:	0f 8c 32 ff ff ff    	jl     80077d <CheckWSWithoutLastIndex+0x3c>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  80084b:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800852:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  800859:	eb 26                	jmp    800881 <CheckWSWithoutLastIndex+0x140>
		if (myEnv->__uptr_pws[w].empty == 1) {
  80085b:	a1 20 50 80 00       	mov    0x805020,%eax
  800860:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  800866:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800869:	89 d0                	mov    %edx,%eax
  80086b:	01 c0                	add    %eax,%eax
  80086d:	01 d0                	add    %edx,%eax
  80086f:	c1 e0 03             	shl    $0x3,%eax
  800872:	01 c8                	add    %ecx,%eax
  800874:	8a 40 04             	mov    0x4(%eax),%al
  800877:	3c 01                	cmp    $0x1,%al
  800879:	75 03                	jne    80087e <CheckWSWithoutLastIndex+0x13d>
			actualNumOfEmptyLocs++;
  80087b:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  80087e:	ff 45 e0             	incl   -0x20(%ebp)
  800881:	a1 20 50 80 00       	mov    0x805020,%eax
  800886:	8b 50 74             	mov    0x74(%eax),%edx
  800889:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80088c:	39 c2                	cmp    %eax,%edx
  80088e:	77 cb                	ja     80085b <CheckWSWithoutLastIndex+0x11a>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  800890:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800893:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  800896:	74 14                	je     8008ac <CheckWSWithoutLastIndex+0x16b>
		panic(
  800898:	83 ec 04             	sub    $0x4,%esp
  80089b:	68 0c 3b 80 00       	push   $0x803b0c
  8008a0:	6a 44                	push   $0x44
  8008a2:	68 ac 3a 80 00       	push   $0x803aac
  8008a7:	e8 23 fe ff ff       	call   8006cf <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  8008ac:	90                   	nop
  8008ad:	c9                   	leave  
  8008ae:	c3                   	ret    

008008af <putch>:
};

//2017:
uint8 printProgName = 0;

static void putch(int ch, struct printbuf *b) {
  8008af:	55                   	push   %ebp
  8008b0:	89 e5                	mov    %esp,%ebp
  8008b2:	83 ec 08             	sub    $0x8,%esp
	b->buf[b->idx++] = ch;
  8008b5:	8b 45 0c             	mov    0xc(%ebp),%eax
  8008b8:	8b 00                	mov    (%eax),%eax
  8008ba:	8d 48 01             	lea    0x1(%eax),%ecx
  8008bd:	8b 55 0c             	mov    0xc(%ebp),%edx
  8008c0:	89 0a                	mov    %ecx,(%edx)
  8008c2:	8b 55 08             	mov    0x8(%ebp),%edx
  8008c5:	88 d1                	mov    %dl,%cl
  8008c7:	8b 55 0c             	mov    0xc(%ebp),%edx
  8008ca:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  8008ce:	8b 45 0c             	mov    0xc(%ebp),%eax
  8008d1:	8b 00                	mov    (%eax),%eax
  8008d3:	3d ff 00 00 00       	cmp    $0xff,%eax
  8008d8:	75 2c                	jne    800906 <putch+0x57>
		sys_cputs(b->buf, b->idx, printProgName);
  8008da:	a0 24 50 80 00       	mov    0x805024,%al
  8008df:	0f b6 c0             	movzbl %al,%eax
  8008e2:	8b 55 0c             	mov    0xc(%ebp),%edx
  8008e5:	8b 12                	mov    (%edx),%edx
  8008e7:	89 d1                	mov    %edx,%ecx
  8008e9:	8b 55 0c             	mov    0xc(%ebp),%edx
  8008ec:	83 c2 08             	add    $0x8,%edx
  8008ef:	83 ec 04             	sub    $0x4,%esp
  8008f2:	50                   	push   %eax
  8008f3:	51                   	push   %ecx
  8008f4:	52                   	push   %edx
  8008f5:	e8 66 13 00 00       	call   801c60 <sys_cputs>
  8008fa:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  8008fd:	8b 45 0c             	mov    0xc(%ebp),%eax
  800900:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  800906:	8b 45 0c             	mov    0xc(%ebp),%eax
  800909:	8b 40 04             	mov    0x4(%eax),%eax
  80090c:	8d 50 01             	lea    0x1(%eax),%edx
  80090f:	8b 45 0c             	mov    0xc(%ebp),%eax
  800912:	89 50 04             	mov    %edx,0x4(%eax)
}
  800915:	90                   	nop
  800916:	c9                   	leave  
  800917:	c3                   	ret    

00800918 <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  800918:	55                   	push   %ebp
  800919:	89 e5                	mov    %esp,%ebp
  80091b:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  800921:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  800928:	00 00 00 
	b.cnt = 0;
  80092b:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  800932:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  800935:	ff 75 0c             	pushl  0xc(%ebp)
  800938:	ff 75 08             	pushl  0x8(%ebp)
  80093b:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800941:	50                   	push   %eax
  800942:	68 af 08 80 00       	push   $0x8008af
  800947:	e8 11 02 00 00       	call   800b5d <vprintfmt>
  80094c:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName);
  80094f:	a0 24 50 80 00       	mov    0x805024,%al
  800954:	0f b6 c0             	movzbl %al,%eax
  800957:	8b 95 f0 fe ff ff    	mov    -0x110(%ebp),%edx
  80095d:	83 ec 04             	sub    $0x4,%esp
  800960:	50                   	push   %eax
  800961:	52                   	push   %edx
  800962:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800968:	83 c0 08             	add    $0x8,%eax
  80096b:	50                   	push   %eax
  80096c:	e8 ef 12 00 00       	call   801c60 <sys_cputs>
  800971:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  800974:	c6 05 24 50 80 00 00 	movb   $0x0,0x805024
	return b.cnt;
  80097b:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  800981:	c9                   	leave  
  800982:	c3                   	ret    

00800983 <cprintf>:

int cprintf(const char *fmt, ...) {
  800983:	55                   	push   %ebp
  800984:	89 e5                	mov    %esp,%ebp
  800986:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  800989:	c6 05 24 50 80 00 01 	movb   $0x1,0x805024
	va_start(ap, fmt);
  800990:	8d 45 0c             	lea    0xc(%ebp),%eax
  800993:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800996:	8b 45 08             	mov    0x8(%ebp),%eax
  800999:	83 ec 08             	sub    $0x8,%esp
  80099c:	ff 75 f4             	pushl  -0xc(%ebp)
  80099f:	50                   	push   %eax
  8009a0:	e8 73 ff ff ff       	call   800918 <vcprintf>
  8009a5:	83 c4 10             	add    $0x10,%esp
  8009a8:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  8009ab:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8009ae:	c9                   	leave  
  8009af:	c3                   	ret    

008009b0 <atomic_cprintf>:

int atomic_cprintf(const char *fmt, ...) {
  8009b0:	55                   	push   %ebp
  8009b1:	89 e5                	mov    %esp,%ebp
  8009b3:	83 ec 18             	sub    $0x18,%esp
	sys_disable_interrupt();
  8009b6:	e8 53 14 00 00       	call   801e0e <sys_disable_interrupt>
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  8009bb:	8d 45 0c             	lea    0xc(%ebp),%eax
  8009be:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  8009c1:	8b 45 08             	mov    0x8(%ebp),%eax
  8009c4:	83 ec 08             	sub    $0x8,%esp
  8009c7:	ff 75 f4             	pushl  -0xc(%ebp)
  8009ca:	50                   	push   %eax
  8009cb:	e8 48 ff ff ff       	call   800918 <vcprintf>
  8009d0:	83 c4 10             	add    $0x10,%esp
  8009d3:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	sys_enable_interrupt();
  8009d6:	e8 4d 14 00 00       	call   801e28 <sys_enable_interrupt>
	return cnt;
  8009db:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8009de:	c9                   	leave  
  8009df:	c3                   	ret    

008009e0 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  8009e0:	55                   	push   %ebp
  8009e1:	89 e5                	mov    %esp,%ebp
  8009e3:	53                   	push   %ebx
  8009e4:	83 ec 14             	sub    $0x14,%esp
  8009e7:	8b 45 10             	mov    0x10(%ebp),%eax
  8009ea:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8009ed:	8b 45 14             	mov    0x14(%ebp),%eax
  8009f0:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  8009f3:	8b 45 18             	mov    0x18(%ebp),%eax
  8009f6:	ba 00 00 00 00       	mov    $0x0,%edx
  8009fb:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  8009fe:	77 55                	ja     800a55 <printnum+0x75>
  800a00:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800a03:	72 05                	jb     800a0a <printnum+0x2a>
  800a05:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  800a08:	77 4b                	ja     800a55 <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800a0a:	8b 45 1c             	mov    0x1c(%ebp),%eax
  800a0d:	8d 58 ff             	lea    -0x1(%eax),%ebx
  800a10:	8b 45 18             	mov    0x18(%ebp),%eax
  800a13:	ba 00 00 00 00       	mov    $0x0,%edx
  800a18:	52                   	push   %edx
  800a19:	50                   	push   %eax
  800a1a:	ff 75 f4             	pushl  -0xc(%ebp)
  800a1d:	ff 75 f0             	pushl  -0x10(%ebp)
  800a20:	e8 87 28 00 00       	call   8032ac <__udivdi3>
  800a25:	83 c4 10             	add    $0x10,%esp
  800a28:	83 ec 04             	sub    $0x4,%esp
  800a2b:	ff 75 20             	pushl  0x20(%ebp)
  800a2e:	53                   	push   %ebx
  800a2f:	ff 75 18             	pushl  0x18(%ebp)
  800a32:	52                   	push   %edx
  800a33:	50                   	push   %eax
  800a34:	ff 75 0c             	pushl  0xc(%ebp)
  800a37:	ff 75 08             	pushl  0x8(%ebp)
  800a3a:	e8 a1 ff ff ff       	call   8009e0 <printnum>
  800a3f:	83 c4 20             	add    $0x20,%esp
  800a42:	eb 1a                	jmp    800a5e <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  800a44:	83 ec 08             	sub    $0x8,%esp
  800a47:	ff 75 0c             	pushl  0xc(%ebp)
  800a4a:	ff 75 20             	pushl  0x20(%ebp)
  800a4d:	8b 45 08             	mov    0x8(%ebp),%eax
  800a50:	ff d0                	call   *%eax
  800a52:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800a55:	ff 4d 1c             	decl   0x1c(%ebp)
  800a58:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  800a5c:	7f e6                	jg     800a44 <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800a5e:	8b 4d 18             	mov    0x18(%ebp),%ecx
  800a61:	bb 00 00 00 00       	mov    $0x0,%ebx
  800a66:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800a69:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800a6c:	53                   	push   %ebx
  800a6d:	51                   	push   %ecx
  800a6e:	52                   	push   %edx
  800a6f:	50                   	push   %eax
  800a70:	e8 47 29 00 00       	call   8033bc <__umoddi3>
  800a75:	83 c4 10             	add    $0x10,%esp
  800a78:	05 74 3d 80 00       	add    $0x803d74,%eax
  800a7d:	8a 00                	mov    (%eax),%al
  800a7f:	0f be c0             	movsbl %al,%eax
  800a82:	83 ec 08             	sub    $0x8,%esp
  800a85:	ff 75 0c             	pushl  0xc(%ebp)
  800a88:	50                   	push   %eax
  800a89:	8b 45 08             	mov    0x8(%ebp),%eax
  800a8c:	ff d0                	call   *%eax
  800a8e:	83 c4 10             	add    $0x10,%esp
}
  800a91:	90                   	nop
  800a92:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800a95:	c9                   	leave  
  800a96:	c3                   	ret    

00800a97 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  800a97:	55                   	push   %ebp
  800a98:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800a9a:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800a9e:	7e 1c                	jle    800abc <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  800aa0:	8b 45 08             	mov    0x8(%ebp),%eax
  800aa3:	8b 00                	mov    (%eax),%eax
  800aa5:	8d 50 08             	lea    0x8(%eax),%edx
  800aa8:	8b 45 08             	mov    0x8(%ebp),%eax
  800aab:	89 10                	mov    %edx,(%eax)
  800aad:	8b 45 08             	mov    0x8(%ebp),%eax
  800ab0:	8b 00                	mov    (%eax),%eax
  800ab2:	83 e8 08             	sub    $0x8,%eax
  800ab5:	8b 50 04             	mov    0x4(%eax),%edx
  800ab8:	8b 00                	mov    (%eax),%eax
  800aba:	eb 40                	jmp    800afc <getuint+0x65>
	else if (lflag)
  800abc:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800ac0:	74 1e                	je     800ae0 <getuint+0x49>
		return va_arg(*ap, unsigned long);
  800ac2:	8b 45 08             	mov    0x8(%ebp),%eax
  800ac5:	8b 00                	mov    (%eax),%eax
  800ac7:	8d 50 04             	lea    0x4(%eax),%edx
  800aca:	8b 45 08             	mov    0x8(%ebp),%eax
  800acd:	89 10                	mov    %edx,(%eax)
  800acf:	8b 45 08             	mov    0x8(%ebp),%eax
  800ad2:	8b 00                	mov    (%eax),%eax
  800ad4:	83 e8 04             	sub    $0x4,%eax
  800ad7:	8b 00                	mov    (%eax),%eax
  800ad9:	ba 00 00 00 00       	mov    $0x0,%edx
  800ade:	eb 1c                	jmp    800afc <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  800ae0:	8b 45 08             	mov    0x8(%ebp),%eax
  800ae3:	8b 00                	mov    (%eax),%eax
  800ae5:	8d 50 04             	lea    0x4(%eax),%edx
  800ae8:	8b 45 08             	mov    0x8(%ebp),%eax
  800aeb:	89 10                	mov    %edx,(%eax)
  800aed:	8b 45 08             	mov    0x8(%ebp),%eax
  800af0:	8b 00                	mov    (%eax),%eax
  800af2:	83 e8 04             	sub    $0x4,%eax
  800af5:	8b 00                	mov    (%eax),%eax
  800af7:	ba 00 00 00 00       	mov    $0x0,%edx
}
  800afc:	5d                   	pop    %ebp
  800afd:	c3                   	ret    

00800afe <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  800afe:	55                   	push   %ebp
  800aff:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800b01:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800b05:	7e 1c                	jle    800b23 <getint+0x25>
		return va_arg(*ap, long long);
  800b07:	8b 45 08             	mov    0x8(%ebp),%eax
  800b0a:	8b 00                	mov    (%eax),%eax
  800b0c:	8d 50 08             	lea    0x8(%eax),%edx
  800b0f:	8b 45 08             	mov    0x8(%ebp),%eax
  800b12:	89 10                	mov    %edx,(%eax)
  800b14:	8b 45 08             	mov    0x8(%ebp),%eax
  800b17:	8b 00                	mov    (%eax),%eax
  800b19:	83 e8 08             	sub    $0x8,%eax
  800b1c:	8b 50 04             	mov    0x4(%eax),%edx
  800b1f:	8b 00                	mov    (%eax),%eax
  800b21:	eb 38                	jmp    800b5b <getint+0x5d>
	else if (lflag)
  800b23:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800b27:	74 1a                	je     800b43 <getint+0x45>
		return va_arg(*ap, long);
  800b29:	8b 45 08             	mov    0x8(%ebp),%eax
  800b2c:	8b 00                	mov    (%eax),%eax
  800b2e:	8d 50 04             	lea    0x4(%eax),%edx
  800b31:	8b 45 08             	mov    0x8(%ebp),%eax
  800b34:	89 10                	mov    %edx,(%eax)
  800b36:	8b 45 08             	mov    0x8(%ebp),%eax
  800b39:	8b 00                	mov    (%eax),%eax
  800b3b:	83 e8 04             	sub    $0x4,%eax
  800b3e:	8b 00                	mov    (%eax),%eax
  800b40:	99                   	cltd   
  800b41:	eb 18                	jmp    800b5b <getint+0x5d>
	else
		return va_arg(*ap, int);
  800b43:	8b 45 08             	mov    0x8(%ebp),%eax
  800b46:	8b 00                	mov    (%eax),%eax
  800b48:	8d 50 04             	lea    0x4(%eax),%edx
  800b4b:	8b 45 08             	mov    0x8(%ebp),%eax
  800b4e:	89 10                	mov    %edx,(%eax)
  800b50:	8b 45 08             	mov    0x8(%ebp),%eax
  800b53:	8b 00                	mov    (%eax),%eax
  800b55:	83 e8 04             	sub    $0x4,%eax
  800b58:	8b 00                	mov    (%eax),%eax
  800b5a:	99                   	cltd   
}
  800b5b:	5d                   	pop    %ebp
  800b5c:	c3                   	ret    

00800b5d <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  800b5d:	55                   	push   %ebp
  800b5e:	89 e5                	mov    %esp,%ebp
  800b60:	56                   	push   %esi
  800b61:	53                   	push   %ebx
  800b62:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800b65:	eb 17                	jmp    800b7e <vprintfmt+0x21>
			if (ch == '\0')
  800b67:	85 db                	test   %ebx,%ebx
  800b69:	0f 84 af 03 00 00    	je     800f1e <vprintfmt+0x3c1>
				return;
			putch(ch, putdat);
  800b6f:	83 ec 08             	sub    $0x8,%esp
  800b72:	ff 75 0c             	pushl  0xc(%ebp)
  800b75:	53                   	push   %ebx
  800b76:	8b 45 08             	mov    0x8(%ebp),%eax
  800b79:	ff d0                	call   *%eax
  800b7b:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800b7e:	8b 45 10             	mov    0x10(%ebp),%eax
  800b81:	8d 50 01             	lea    0x1(%eax),%edx
  800b84:	89 55 10             	mov    %edx,0x10(%ebp)
  800b87:	8a 00                	mov    (%eax),%al
  800b89:	0f b6 d8             	movzbl %al,%ebx
  800b8c:	83 fb 25             	cmp    $0x25,%ebx
  800b8f:	75 d6                	jne    800b67 <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  800b91:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  800b95:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  800b9c:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  800ba3:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  800baa:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800bb1:	8b 45 10             	mov    0x10(%ebp),%eax
  800bb4:	8d 50 01             	lea    0x1(%eax),%edx
  800bb7:	89 55 10             	mov    %edx,0x10(%ebp)
  800bba:	8a 00                	mov    (%eax),%al
  800bbc:	0f b6 d8             	movzbl %al,%ebx
  800bbf:	8d 43 dd             	lea    -0x23(%ebx),%eax
  800bc2:	83 f8 55             	cmp    $0x55,%eax
  800bc5:	0f 87 2b 03 00 00    	ja     800ef6 <vprintfmt+0x399>
  800bcb:	8b 04 85 98 3d 80 00 	mov    0x803d98(,%eax,4),%eax
  800bd2:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  800bd4:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  800bd8:	eb d7                	jmp    800bb1 <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  800bda:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  800bde:	eb d1                	jmp    800bb1 <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800be0:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  800be7:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800bea:	89 d0                	mov    %edx,%eax
  800bec:	c1 e0 02             	shl    $0x2,%eax
  800bef:	01 d0                	add    %edx,%eax
  800bf1:	01 c0                	add    %eax,%eax
  800bf3:	01 d8                	add    %ebx,%eax
  800bf5:	83 e8 30             	sub    $0x30,%eax
  800bf8:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  800bfb:	8b 45 10             	mov    0x10(%ebp),%eax
  800bfe:	8a 00                	mov    (%eax),%al
  800c00:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  800c03:	83 fb 2f             	cmp    $0x2f,%ebx
  800c06:	7e 3e                	jle    800c46 <vprintfmt+0xe9>
  800c08:	83 fb 39             	cmp    $0x39,%ebx
  800c0b:	7f 39                	jg     800c46 <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800c0d:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  800c10:	eb d5                	jmp    800be7 <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  800c12:	8b 45 14             	mov    0x14(%ebp),%eax
  800c15:	83 c0 04             	add    $0x4,%eax
  800c18:	89 45 14             	mov    %eax,0x14(%ebp)
  800c1b:	8b 45 14             	mov    0x14(%ebp),%eax
  800c1e:	83 e8 04             	sub    $0x4,%eax
  800c21:	8b 00                	mov    (%eax),%eax
  800c23:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  800c26:	eb 1f                	jmp    800c47 <vprintfmt+0xea>

		case '.':
			if (width < 0)
  800c28:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800c2c:	79 83                	jns    800bb1 <vprintfmt+0x54>
				width = 0;
  800c2e:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  800c35:	e9 77 ff ff ff       	jmp    800bb1 <vprintfmt+0x54>

		case '#':
			altflag = 1;
  800c3a:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  800c41:	e9 6b ff ff ff       	jmp    800bb1 <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  800c46:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  800c47:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800c4b:	0f 89 60 ff ff ff    	jns    800bb1 <vprintfmt+0x54>
				width = precision, precision = -1;
  800c51:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800c54:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800c57:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  800c5e:	e9 4e ff ff ff       	jmp    800bb1 <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  800c63:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  800c66:	e9 46 ff ff ff       	jmp    800bb1 <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  800c6b:	8b 45 14             	mov    0x14(%ebp),%eax
  800c6e:	83 c0 04             	add    $0x4,%eax
  800c71:	89 45 14             	mov    %eax,0x14(%ebp)
  800c74:	8b 45 14             	mov    0x14(%ebp),%eax
  800c77:	83 e8 04             	sub    $0x4,%eax
  800c7a:	8b 00                	mov    (%eax),%eax
  800c7c:	83 ec 08             	sub    $0x8,%esp
  800c7f:	ff 75 0c             	pushl  0xc(%ebp)
  800c82:	50                   	push   %eax
  800c83:	8b 45 08             	mov    0x8(%ebp),%eax
  800c86:	ff d0                	call   *%eax
  800c88:	83 c4 10             	add    $0x10,%esp
			break;
  800c8b:	e9 89 02 00 00       	jmp    800f19 <vprintfmt+0x3bc>

		// error message
		case 'e':
			err = va_arg(ap, int);
  800c90:	8b 45 14             	mov    0x14(%ebp),%eax
  800c93:	83 c0 04             	add    $0x4,%eax
  800c96:	89 45 14             	mov    %eax,0x14(%ebp)
  800c99:	8b 45 14             	mov    0x14(%ebp),%eax
  800c9c:	83 e8 04             	sub    $0x4,%eax
  800c9f:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  800ca1:	85 db                	test   %ebx,%ebx
  800ca3:	79 02                	jns    800ca7 <vprintfmt+0x14a>
				err = -err;
  800ca5:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  800ca7:	83 fb 64             	cmp    $0x64,%ebx
  800caa:	7f 0b                	jg     800cb7 <vprintfmt+0x15a>
  800cac:	8b 34 9d e0 3b 80 00 	mov    0x803be0(,%ebx,4),%esi
  800cb3:	85 f6                	test   %esi,%esi
  800cb5:	75 19                	jne    800cd0 <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  800cb7:	53                   	push   %ebx
  800cb8:	68 85 3d 80 00       	push   $0x803d85
  800cbd:	ff 75 0c             	pushl  0xc(%ebp)
  800cc0:	ff 75 08             	pushl  0x8(%ebp)
  800cc3:	e8 5e 02 00 00       	call   800f26 <printfmt>
  800cc8:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  800ccb:	e9 49 02 00 00       	jmp    800f19 <vprintfmt+0x3bc>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  800cd0:	56                   	push   %esi
  800cd1:	68 8e 3d 80 00       	push   $0x803d8e
  800cd6:	ff 75 0c             	pushl  0xc(%ebp)
  800cd9:	ff 75 08             	pushl  0x8(%ebp)
  800cdc:	e8 45 02 00 00       	call   800f26 <printfmt>
  800ce1:	83 c4 10             	add    $0x10,%esp
			break;
  800ce4:	e9 30 02 00 00       	jmp    800f19 <vprintfmt+0x3bc>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  800ce9:	8b 45 14             	mov    0x14(%ebp),%eax
  800cec:	83 c0 04             	add    $0x4,%eax
  800cef:	89 45 14             	mov    %eax,0x14(%ebp)
  800cf2:	8b 45 14             	mov    0x14(%ebp),%eax
  800cf5:	83 e8 04             	sub    $0x4,%eax
  800cf8:	8b 30                	mov    (%eax),%esi
  800cfa:	85 f6                	test   %esi,%esi
  800cfc:	75 05                	jne    800d03 <vprintfmt+0x1a6>
				p = "(null)";
  800cfe:	be 91 3d 80 00       	mov    $0x803d91,%esi
			if (width > 0 && padc != '-')
  800d03:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800d07:	7e 6d                	jle    800d76 <vprintfmt+0x219>
  800d09:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  800d0d:	74 67                	je     800d76 <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  800d0f:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800d12:	83 ec 08             	sub    $0x8,%esp
  800d15:	50                   	push   %eax
  800d16:	56                   	push   %esi
  800d17:	e8 0c 03 00 00       	call   801028 <strnlen>
  800d1c:	83 c4 10             	add    $0x10,%esp
  800d1f:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  800d22:	eb 16                	jmp    800d3a <vprintfmt+0x1dd>
					putch(padc, putdat);
  800d24:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  800d28:	83 ec 08             	sub    $0x8,%esp
  800d2b:	ff 75 0c             	pushl  0xc(%ebp)
  800d2e:	50                   	push   %eax
  800d2f:	8b 45 08             	mov    0x8(%ebp),%eax
  800d32:	ff d0                	call   *%eax
  800d34:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800d37:	ff 4d e4             	decl   -0x1c(%ebp)
  800d3a:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800d3e:	7f e4                	jg     800d24 <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800d40:	eb 34                	jmp    800d76 <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  800d42:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  800d46:	74 1c                	je     800d64 <vprintfmt+0x207>
  800d48:	83 fb 1f             	cmp    $0x1f,%ebx
  800d4b:	7e 05                	jle    800d52 <vprintfmt+0x1f5>
  800d4d:	83 fb 7e             	cmp    $0x7e,%ebx
  800d50:	7e 12                	jle    800d64 <vprintfmt+0x207>
					putch('?', putdat);
  800d52:	83 ec 08             	sub    $0x8,%esp
  800d55:	ff 75 0c             	pushl  0xc(%ebp)
  800d58:	6a 3f                	push   $0x3f
  800d5a:	8b 45 08             	mov    0x8(%ebp),%eax
  800d5d:	ff d0                	call   *%eax
  800d5f:	83 c4 10             	add    $0x10,%esp
  800d62:	eb 0f                	jmp    800d73 <vprintfmt+0x216>
				else
					putch(ch, putdat);
  800d64:	83 ec 08             	sub    $0x8,%esp
  800d67:	ff 75 0c             	pushl  0xc(%ebp)
  800d6a:	53                   	push   %ebx
  800d6b:	8b 45 08             	mov    0x8(%ebp),%eax
  800d6e:	ff d0                	call   *%eax
  800d70:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800d73:	ff 4d e4             	decl   -0x1c(%ebp)
  800d76:	89 f0                	mov    %esi,%eax
  800d78:	8d 70 01             	lea    0x1(%eax),%esi
  800d7b:	8a 00                	mov    (%eax),%al
  800d7d:	0f be d8             	movsbl %al,%ebx
  800d80:	85 db                	test   %ebx,%ebx
  800d82:	74 24                	je     800da8 <vprintfmt+0x24b>
  800d84:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800d88:	78 b8                	js     800d42 <vprintfmt+0x1e5>
  800d8a:	ff 4d e0             	decl   -0x20(%ebp)
  800d8d:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800d91:	79 af                	jns    800d42 <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800d93:	eb 13                	jmp    800da8 <vprintfmt+0x24b>
				putch(' ', putdat);
  800d95:	83 ec 08             	sub    $0x8,%esp
  800d98:	ff 75 0c             	pushl  0xc(%ebp)
  800d9b:	6a 20                	push   $0x20
  800d9d:	8b 45 08             	mov    0x8(%ebp),%eax
  800da0:	ff d0                	call   *%eax
  800da2:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800da5:	ff 4d e4             	decl   -0x1c(%ebp)
  800da8:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800dac:	7f e7                	jg     800d95 <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  800dae:	e9 66 01 00 00       	jmp    800f19 <vprintfmt+0x3bc>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  800db3:	83 ec 08             	sub    $0x8,%esp
  800db6:	ff 75 e8             	pushl  -0x18(%ebp)
  800db9:	8d 45 14             	lea    0x14(%ebp),%eax
  800dbc:	50                   	push   %eax
  800dbd:	e8 3c fd ff ff       	call   800afe <getint>
  800dc2:	83 c4 10             	add    $0x10,%esp
  800dc5:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800dc8:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  800dcb:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800dce:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800dd1:	85 d2                	test   %edx,%edx
  800dd3:	79 23                	jns    800df8 <vprintfmt+0x29b>
				putch('-', putdat);
  800dd5:	83 ec 08             	sub    $0x8,%esp
  800dd8:	ff 75 0c             	pushl  0xc(%ebp)
  800ddb:	6a 2d                	push   $0x2d
  800ddd:	8b 45 08             	mov    0x8(%ebp),%eax
  800de0:	ff d0                	call   *%eax
  800de2:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  800de5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800de8:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800deb:	f7 d8                	neg    %eax
  800ded:	83 d2 00             	adc    $0x0,%edx
  800df0:	f7 da                	neg    %edx
  800df2:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800df5:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  800df8:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800dff:	e9 bc 00 00 00       	jmp    800ec0 <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  800e04:	83 ec 08             	sub    $0x8,%esp
  800e07:	ff 75 e8             	pushl  -0x18(%ebp)
  800e0a:	8d 45 14             	lea    0x14(%ebp),%eax
  800e0d:	50                   	push   %eax
  800e0e:	e8 84 fc ff ff       	call   800a97 <getuint>
  800e13:	83 c4 10             	add    $0x10,%esp
  800e16:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800e19:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  800e1c:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800e23:	e9 98 00 00 00       	jmp    800ec0 <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  800e28:	83 ec 08             	sub    $0x8,%esp
  800e2b:	ff 75 0c             	pushl  0xc(%ebp)
  800e2e:	6a 58                	push   $0x58
  800e30:	8b 45 08             	mov    0x8(%ebp),%eax
  800e33:	ff d0                	call   *%eax
  800e35:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800e38:	83 ec 08             	sub    $0x8,%esp
  800e3b:	ff 75 0c             	pushl  0xc(%ebp)
  800e3e:	6a 58                	push   $0x58
  800e40:	8b 45 08             	mov    0x8(%ebp),%eax
  800e43:	ff d0                	call   *%eax
  800e45:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800e48:	83 ec 08             	sub    $0x8,%esp
  800e4b:	ff 75 0c             	pushl  0xc(%ebp)
  800e4e:	6a 58                	push   $0x58
  800e50:	8b 45 08             	mov    0x8(%ebp),%eax
  800e53:	ff d0                	call   *%eax
  800e55:	83 c4 10             	add    $0x10,%esp
			break;
  800e58:	e9 bc 00 00 00       	jmp    800f19 <vprintfmt+0x3bc>

		// pointer
		case 'p':
			putch('0', putdat);
  800e5d:	83 ec 08             	sub    $0x8,%esp
  800e60:	ff 75 0c             	pushl  0xc(%ebp)
  800e63:	6a 30                	push   $0x30
  800e65:	8b 45 08             	mov    0x8(%ebp),%eax
  800e68:	ff d0                	call   *%eax
  800e6a:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  800e6d:	83 ec 08             	sub    $0x8,%esp
  800e70:	ff 75 0c             	pushl  0xc(%ebp)
  800e73:	6a 78                	push   $0x78
  800e75:	8b 45 08             	mov    0x8(%ebp),%eax
  800e78:	ff d0                	call   *%eax
  800e7a:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  800e7d:	8b 45 14             	mov    0x14(%ebp),%eax
  800e80:	83 c0 04             	add    $0x4,%eax
  800e83:	89 45 14             	mov    %eax,0x14(%ebp)
  800e86:	8b 45 14             	mov    0x14(%ebp),%eax
  800e89:	83 e8 04             	sub    $0x4,%eax
  800e8c:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800e8e:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800e91:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  800e98:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  800e9f:	eb 1f                	jmp    800ec0 <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  800ea1:	83 ec 08             	sub    $0x8,%esp
  800ea4:	ff 75 e8             	pushl  -0x18(%ebp)
  800ea7:	8d 45 14             	lea    0x14(%ebp),%eax
  800eaa:	50                   	push   %eax
  800eab:	e8 e7 fb ff ff       	call   800a97 <getuint>
  800eb0:	83 c4 10             	add    $0x10,%esp
  800eb3:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800eb6:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  800eb9:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800ec0:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  800ec4:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800ec7:	83 ec 04             	sub    $0x4,%esp
  800eca:	52                   	push   %edx
  800ecb:	ff 75 e4             	pushl  -0x1c(%ebp)
  800ece:	50                   	push   %eax
  800ecf:	ff 75 f4             	pushl  -0xc(%ebp)
  800ed2:	ff 75 f0             	pushl  -0x10(%ebp)
  800ed5:	ff 75 0c             	pushl  0xc(%ebp)
  800ed8:	ff 75 08             	pushl  0x8(%ebp)
  800edb:	e8 00 fb ff ff       	call   8009e0 <printnum>
  800ee0:	83 c4 20             	add    $0x20,%esp
			break;
  800ee3:	eb 34                	jmp    800f19 <vprintfmt+0x3bc>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  800ee5:	83 ec 08             	sub    $0x8,%esp
  800ee8:	ff 75 0c             	pushl  0xc(%ebp)
  800eeb:	53                   	push   %ebx
  800eec:	8b 45 08             	mov    0x8(%ebp),%eax
  800eef:	ff d0                	call   *%eax
  800ef1:	83 c4 10             	add    $0x10,%esp
			break;
  800ef4:	eb 23                	jmp    800f19 <vprintfmt+0x3bc>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800ef6:	83 ec 08             	sub    $0x8,%esp
  800ef9:	ff 75 0c             	pushl  0xc(%ebp)
  800efc:	6a 25                	push   $0x25
  800efe:	8b 45 08             	mov    0x8(%ebp),%eax
  800f01:	ff d0                	call   *%eax
  800f03:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  800f06:	ff 4d 10             	decl   0x10(%ebp)
  800f09:	eb 03                	jmp    800f0e <vprintfmt+0x3b1>
  800f0b:	ff 4d 10             	decl   0x10(%ebp)
  800f0e:	8b 45 10             	mov    0x10(%ebp),%eax
  800f11:	48                   	dec    %eax
  800f12:	8a 00                	mov    (%eax),%al
  800f14:	3c 25                	cmp    $0x25,%al
  800f16:	75 f3                	jne    800f0b <vprintfmt+0x3ae>
				/* do nothing */;
			break;
  800f18:	90                   	nop
		}
	}
  800f19:	e9 47 fc ff ff       	jmp    800b65 <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  800f1e:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  800f1f:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800f22:	5b                   	pop    %ebx
  800f23:	5e                   	pop    %esi
  800f24:	5d                   	pop    %ebp
  800f25:	c3                   	ret    

00800f26 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800f26:	55                   	push   %ebp
  800f27:	89 e5                	mov    %esp,%ebp
  800f29:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  800f2c:	8d 45 10             	lea    0x10(%ebp),%eax
  800f2f:	83 c0 04             	add    $0x4,%eax
  800f32:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  800f35:	8b 45 10             	mov    0x10(%ebp),%eax
  800f38:	ff 75 f4             	pushl  -0xc(%ebp)
  800f3b:	50                   	push   %eax
  800f3c:	ff 75 0c             	pushl  0xc(%ebp)
  800f3f:	ff 75 08             	pushl  0x8(%ebp)
  800f42:	e8 16 fc ff ff       	call   800b5d <vprintfmt>
  800f47:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  800f4a:	90                   	nop
  800f4b:	c9                   	leave  
  800f4c:	c3                   	ret    

00800f4d <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800f4d:	55                   	push   %ebp
  800f4e:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  800f50:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f53:	8b 40 08             	mov    0x8(%eax),%eax
  800f56:	8d 50 01             	lea    0x1(%eax),%edx
  800f59:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f5c:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  800f5f:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f62:	8b 10                	mov    (%eax),%edx
  800f64:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f67:	8b 40 04             	mov    0x4(%eax),%eax
  800f6a:	39 c2                	cmp    %eax,%edx
  800f6c:	73 12                	jae    800f80 <sprintputch+0x33>
		*b->buf++ = ch;
  800f6e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f71:	8b 00                	mov    (%eax),%eax
  800f73:	8d 48 01             	lea    0x1(%eax),%ecx
  800f76:	8b 55 0c             	mov    0xc(%ebp),%edx
  800f79:	89 0a                	mov    %ecx,(%edx)
  800f7b:	8b 55 08             	mov    0x8(%ebp),%edx
  800f7e:	88 10                	mov    %dl,(%eax)
}
  800f80:	90                   	nop
  800f81:	5d                   	pop    %ebp
  800f82:	c3                   	ret    

00800f83 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800f83:	55                   	push   %ebp
  800f84:	89 e5                	mov    %esp,%ebp
  800f86:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  800f89:	8b 45 08             	mov    0x8(%ebp),%eax
  800f8c:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800f8f:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f92:	8d 50 ff             	lea    -0x1(%eax),%edx
  800f95:	8b 45 08             	mov    0x8(%ebp),%eax
  800f98:	01 d0                	add    %edx,%eax
  800f9a:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800f9d:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800fa4:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800fa8:	74 06                	je     800fb0 <vsnprintf+0x2d>
  800faa:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800fae:	7f 07                	jg     800fb7 <vsnprintf+0x34>
		return -E_INVAL;
  800fb0:	b8 03 00 00 00       	mov    $0x3,%eax
  800fb5:	eb 20                	jmp    800fd7 <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800fb7:	ff 75 14             	pushl  0x14(%ebp)
  800fba:	ff 75 10             	pushl  0x10(%ebp)
  800fbd:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800fc0:	50                   	push   %eax
  800fc1:	68 4d 0f 80 00       	push   $0x800f4d
  800fc6:	e8 92 fb ff ff       	call   800b5d <vprintfmt>
  800fcb:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  800fce:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800fd1:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800fd4:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  800fd7:	c9                   	leave  
  800fd8:	c3                   	ret    

00800fd9 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800fd9:	55                   	push   %ebp
  800fda:	89 e5                	mov    %esp,%ebp
  800fdc:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800fdf:	8d 45 10             	lea    0x10(%ebp),%eax
  800fe2:	83 c0 04             	add    $0x4,%eax
  800fe5:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  800fe8:	8b 45 10             	mov    0x10(%ebp),%eax
  800feb:	ff 75 f4             	pushl  -0xc(%ebp)
  800fee:	50                   	push   %eax
  800fef:	ff 75 0c             	pushl  0xc(%ebp)
  800ff2:	ff 75 08             	pushl  0x8(%ebp)
  800ff5:	e8 89 ff ff ff       	call   800f83 <vsnprintf>
  800ffa:	83 c4 10             	add    $0x10,%esp
  800ffd:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  801000:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801003:	c9                   	leave  
  801004:	c3                   	ret    

00801005 <strlen>:

#include <inc/string.h>

int
strlen(const char *s)
{
  801005:	55                   	push   %ebp
  801006:	89 e5                	mov    %esp,%ebp
  801008:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  80100b:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801012:	eb 06                	jmp    80101a <strlen+0x15>
		n++;
  801014:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  801017:	ff 45 08             	incl   0x8(%ebp)
  80101a:	8b 45 08             	mov    0x8(%ebp),%eax
  80101d:	8a 00                	mov    (%eax),%al
  80101f:	84 c0                	test   %al,%al
  801021:	75 f1                	jne    801014 <strlen+0xf>
		n++;
	return n;
  801023:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  801026:	c9                   	leave  
  801027:	c3                   	ret    

00801028 <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  801028:	55                   	push   %ebp
  801029:	89 e5                	mov    %esp,%ebp
  80102b:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  80102e:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801035:	eb 09                	jmp    801040 <strnlen+0x18>
		n++;
  801037:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  80103a:	ff 45 08             	incl   0x8(%ebp)
  80103d:	ff 4d 0c             	decl   0xc(%ebp)
  801040:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801044:	74 09                	je     80104f <strnlen+0x27>
  801046:	8b 45 08             	mov    0x8(%ebp),%eax
  801049:	8a 00                	mov    (%eax),%al
  80104b:	84 c0                	test   %al,%al
  80104d:	75 e8                	jne    801037 <strnlen+0xf>
		n++;
	return n;
  80104f:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  801052:	c9                   	leave  
  801053:	c3                   	ret    

00801054 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  801054:	55                   	push   %ebp
  801055:	89 e5                	mov    %esp,%ebp
  801057:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  80105a:	8b 45 08             	mov    0x8(%ebp),%eax
  80105d:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  801060:	90                   	nop
  801061:	8b 45 08             	mov    0x8(%ebp),%eax
  801064:	8d 50 01             	lea    0x1(%eax),%edx
  801067:	89 55 08             	mov    %edx,0x8(%ebp)
  80106a:	8b 55 0c             	mov    0xc(%ebp),%edx
  80106d:	8d 4a 01             	lea    0x1(%edx),%ecx
  801070:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  801073:	8a 12                	mov    (%edx),%dl
  801075:	88 10                	mov    %dl,(%eax)
  801077:	8a 00                	mov    (%eax),%al
  801079:	84 c0                	test   %al,%al
  80107b:	75 e4                	jne    801061 <strcpy+0xd>
		/* do nothing */;
	return ret;
  80107d:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  801080:	c9                   	leave  
  801081:	c3                   	ret    

00801082 <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  801082:	55                   	push   %ebp
  801083:	89 e5                	mov    %esp,%ebp
  801085:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  801088:	8b 45 08             	mov    0x8(%ebp),%eax
  80108b:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  80108e:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801095:	eb 1f                	jmp    8010b6 <strncpy+0x34>
		*dst++ = *src;
  801097:	8b 45 08             	mov    0x8(%ebp),%eax
  80109a:	8d 50 01             	lea    0x1(%eax),%edx
  80109d:	89 55 08             	mov    %edx,0x8(%ebp)
  8010a0:	8b 55 0c             	mov    0xc(%ebp),%edx
  8010a3:	8a 12                	mov    (%edx),%dl
  8010a5:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  8010a7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8010aa:	8a 00                	mov    (%eax),%al
  8010ac:	84 c0                	test   %al,%al
  8010ae:	74 03                	je     8010b3 <strncpy+0x31>
			src++;
  8010b0:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  8010b3:	ff 45 fc             	incl   -0x4(%ebp)
  8010b6:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8010b9:	3b 45 10             	cmp    0x10(%ebp),%eax
  8010bc:	72 d9                	jb     801097 <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  8010be:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  8010c1:	c9                   	leave  
  8010c2:	c3                   	ret    

008010c3 <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  8010c3:	55                   	push   %ebp
  8010c4:	89 e5                	mov    %esp,%ebp
  8010c6:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  8010c9:	8b 45 08             	mov    0x8(%ebp),%eax
  8010cc:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  8010cf:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8010d3:	74 30                	je     801105 <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  8010d5:	eb 16                	jmp    8010ed <strlcpy+0x2a>
			*dst++ = *src++;
  8010d7:	8b 45 08             	mov    0x8(%ebp),%eax
  8010da:	8d 50 01             	lea    0x1(%eax),%edx
  8010dd:	89 55 08             	mov    %edx,0x8(%ebp)
  8010e0:	8b 55 0c             	mov    0xc(%ebp),%edx
  8010e3:	8d 4a 01             	lea    0x1(%edx),%ecx
  8010e6:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  8010e9:	8a 12                	mov    (%edx),%dl
  8010eb:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  8010ed:	ff 4d 10             	decl   0x10(%ebp)
  8010f0:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8010f4:	74 09                	je     8010ff <strlcpy+0x3c>
  8010f6:	8b 45 0c             	mov    0xc(%ebp),%eax
  8010f9:	8a 00                	mov    (%eax),%al
  8010fb:	84 c0                	test   %al,%al
  8010fd:	75 d8                	jne    8010d7 <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  8010ff:	8b 45 08             	mov    0x8(%ebp),%eax
  801102:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  801105:	8b 55 08             	mov    0x8(%ebp),%edx
  801108:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80110b:	29 c2                	sub    %eax,%edx
  80110d:	89 d0                	mov    %edx,%eax
}
  80110f:	c9                   	leave  
  801110:	c3                   	ret    

00801111 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  801111:	55                   	push   %ebp
  801112:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  801114:	eb 06                	jmp    80111c <strcmp+0xb>
		p++, q++;
  801116:	ff 45 08             	incl   0x8(%ebp)
  801119:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  80111c:	8b 45 08             	mov    0x8(%ebp),%eax
  80111f:	8a 00                	mov    (%eax),%al
  801121:	84 c0                	test   %al,%al
  801123:	74 0e                	je     801133 <strcmp+0x22>
  801125:	8b 45 08             	mov    0x8(%ebp),%eax
  801128:	8a 10                	mov    (%eax),%dl
  80112a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80112d:	8a 00                	mov    (%eax),%al
  80112f:	38 c2                	cmp    %al,%dl
  801131:	74 e3                	je     801116 <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  801133:	8b 45 08             	mov    0x8(%ebp),%eax
  801136:	8a 00                	mov    (%eax),%al
  801138:	0f b6 d0             	movzbl %al,%edx
  80113b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80113e:	8a 00                	mov    (%eax),%al
  801140:	0f b6 c0             	movzbl %al,%eax
  801143:	29 c2                	sub    %eax,%edx
  801145:	89 d0                	mov    %edx,%eax
}
  801147:	5d                   	pop    %ebp
  801148:	c3                   	ret    

00801149 <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  801149:	55                   	push   %ebp
  80114a:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  80114c:	eb 09                	jmp    801157 <strncmp+0xe>
		n--, p++, q++;
  80114e:	ff 4d 10             	decl   0x10(%ebp)
  801151:	ff 45 08             	incl   0x8(%ebp)
  801154:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  801157:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80115b:	74 17                	je     801174 <strncmp+0x2b>
  80115d:	8b 45 08             	mov    0x8(%ebp),%eax
  801160:	8a 00                	mov    (%eax),%al
  801162:	84 c0                	test   %al,%al
  801164:	74 0e                	je     801174 <strncmp+0x2b>
  801166:	8b 45 08             	mov    0x8(%ebp),%eax
  801169:	8a 10                	mov    (%eax),%dl
  80116b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80116e:	8a 00                	mov    (%eax),%al
  801170:	38 c2                	cmp    %al,%dl
  801172:	74 da                	je     80114e <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  801174:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801178:	75 07                	jne    801181 <strncmp+0x38>
		return 0;
  80117a:	b8 00 00 00 00       	mov    $0x0,%eax
  80117f:	eb 14                	jmp    801195 <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  801181:	8b 45 08             	mov    0x8(%ebp),%eax
  801184:	8a 00                	mov    (%eax),%al
  801186:	0f b6 d0             	movzbl %al,%edx
  801189:	8b 45 0c             	mov    0xc(%ebp),%eax
  80118c:	8a 00                	mov    (%eax),%al
  80118e:	0f b6 c0             	movzbl %al,%eax
  801191:	29 c2                	sub    %eax,%edx
  801193:	89 d0                	mov    %edx,%eax
}
  801195:	5d                   	pop    %ebp
  801196:	c3                   	ret    

00801197 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  801197:	55                   	push   %ebp
  801198:	89 e5                	mov    %esp,%ebp
  80119a:	83 ec 04             	sub    $0x4,%esp
  80119d:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011a0:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  8011a3:	eb 12                	jmp    8011b7 <strchr+0x20>
		if (*s == c)
  8011a5:	8b 45 08             	mov    0x8(%ebp),%eax
  8011a8:	8a 00                	mov    (%eax),%al
  8011aa:	3a 45 fc             	cmp    -0x4(%ebp),%al
  8011ad:	75 05                	jne    8011b4 <strchr+0x1d>
			return (char *) s;
  8011af:	8b 45 08             	mov    0x8(%ebp),%eax
  8011b2:	eb 11                	jmp    8011c5 <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  8011b4:	ff 45 08             	incl   0x8(%ebp)
  8011b7:	8b 45 08             	mov    0x8(%ebp),%eax
  8011ba:	8a 00                	mov    (%eax),%al
  8011bc:	84 c0                	test   %al,%al
  8011be:	75 e5                	jne    8011a5 <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  8011c0:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8011c5:	c9                   	leave  
  8011c6:	c3                   	ret    

008011c7 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  8011c7:	55                   	push   %ebp
  8011c8:	89 e5                	mov    %esp,%ebp
  8011ca:	83 ec 04             	sub    $0x4,%esp
  8011cd:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011d0:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  8011d3:	eb 0d                	jmp    8011e2 <strfind+0x1b>
		if (*s == c)
  8011d5:	8b 45 08             	mov    0x8(%ebp),%eax
  8011d8:	8a 00                	mov    (%eax),%al
  8011da:	3a 45 fc             	cmp    -0x4(%ebp),%al
  8011dd:	74 0e                	je     8011ed <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  8011df:	ff 45 08             	incl   0x8(%ebp)
  8011e2:	8b 45 08             	mov    0x8(%ebp),%eax
  8011e5:	8a 00                	mov    (%eax),%al
  8011e7:	84 c0                	test   %al,%al
  8011e9:	75 ea                	jne    8011d5 <strfind+0xe>
  8011eb:	eb 01                	jmp    8011ee <strfind+0x27>
		if (*s == c)
			break;
  8011ed:	90                   	nop
	return (char *) s;
  8011ee:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8011f1:	c9                   	leave  
  8011f2:	c3                   	ret    

008011f3 <memset>:


void *
memset(void *v, int c, uint32 n)
{
  8011f3:	55                   	push   %ebp
  8011f4:	89 e5                	mov    %esp,%ebp
  8011f6:	83 ec 10             	sub    $0x10,%esp
	char *p;
	int m;

	p = v;
  8011f9:	8b 45 08             	mov    0x8(%ebp),%eax
  8011fc:	89 45 fc             	mov    %eax,-0x4(%ebp)
	m = n;
  8011ff:	8b 45 10             	mov    0x10(%ebp),%eax
  801202:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (--m >= 0)
  801205:	eb 0e                	jmp    801215 <memset+0x22>
		*p++ = c;
  801207:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80120a:	8d 50 01             	lea    0x1(%eax),%edx
  80120d:	89 55 fc             	mov    %edx,-0x4(%ebp)
  801210:	8b 55 0c             	mov    0xc(%ebp),%edx
  801213:	88 10                	mov    %dl,(%eax)
	char *p;
	int m;

	p = v;
	m = n;
	while (--m >= 0)
  801215:	ff 4d f8             	decl   -0x8(%ebp)
  801218:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
  80121c:	79 e9                	jns    801207 <memset+0x14>
		*p++ = c;

	return v;
  80121e:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801221:	c9                   	leave  
  801222:	c3                   	ret    

00801223 <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  801223:	55                   	push   %ebp
  801224:	89 e5                	mov    %esp,%ebp
  801226:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  801229:	8b 45 0c             	mov    0xc(%ebp),%eax
  80122c:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  80122f:	8b 45 08             	mov    0x8(%ebp),%eax
  801232:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (n-- > 0)
  801235:	eb 16                	jmp    80124d <memcpy+0x2a>
		*d++ = *s++;
  801237:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80123a:	8d 50 01             	lea    0x1(%eax),%edx
  80123d:	89 55 f8             	mov    %edx,-0x8(%ebp)
  801240:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801243:	8d 4a 01             	lea    0x1(%edx),%ecx
  801246:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  801249:	8a 12                	mov    (%edx),%dl
  80124b:	88 10                	mov    %dl,(%eax)
	const char *s;
	char *d;

	s = src;
	d = dst;
	while (n-- > 0)
  80124d:	8b 45 10             	mov    0x10(%ebp),%eax
  801250:	8d 50 ff             	lea    -0x1(%eax),%edx
  801253:	89 55 10             	mov    %edx,0x10(%ebp)
  801256:	85 c0                	test   %eax,%eax
  801258:	75 dd                	jne    801237 <memcpy+0x14>
		*d++ = *s++;

	return dst;
  80125a:	8b 45 08             	mov    0x8(%ebp),%eax
}
  80125d:	c9                   	leave  
  80125e:	c3                   	ret    

0080125f <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  80125f:	55                   	push   %ebp
  801260:	89 e5                	mov    %esp,%ebp
  801262:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  801265:	8b 45 0c             	mov    0xc(%ebp),%eax
  801268:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  80126b:	8b 45 08             	mov    0x8(%ebp),%eax
  80126e:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  801271:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801274:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  801277:	73 50                	jae    8012c9 <memmove+0x6a>
  801279:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80127c:	8b 45 10             	mov    0x10(%ebp),%eax
  80127f:	01 d0                	add    %edx,%eax
  801281:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  801284:	76 43                	jbe    8012c9 <memmove+0x6a>
		s += n;
  801286:	8b 45 10             	mov    0x10(%ebp),%eax
  801289:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  80128c:	8b 45 10             	mov    0x10(%ebp),%eax
  80128f:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  801292:	eb 10                	jmp    8012a4 <memmove+0x45>
			*--d = *--s;
  801294:	ff 4d f8             	decl   -0x8(%ebp)
  801297:	ff 4d fc             	decl   -0x4(%ebp)
  80129a:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80129d:	8a 10                	mov    (%eax),%dl
  80129f:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8012a2:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  8012a4:	8b 45 10             	mov    0x10(%ebp),%eax
  8012a7:	8d 50 ff             	lea    -0x1(%eax),%edx
  8012aa:	89 55 10             	mov    %edx,0x10(%ebp)
  8012ad:	85 c0                	test   %eax,%eax
  8012af:	75 e3                	jne    801294 <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  8012b1:	eb 23                	jmp    8012d6 <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  8012b3:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8012b6:	8d 50 01             	lea    0x1(%eax),%edx
  8012b9:	89 55 f8             	mov    %edx,-0x8(%ebp)
  8012bc:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8012bf:	8d 4a 01             	lea    0x1(%edx),%ecx
  8012c2:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  8012c5:	8a 12                	mov    (%edx),%dl
  8012c7:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  8012c9:	8b 45 10             	mov    0x10(%ebp),%eax
  8012cc:	8d 50 ff             	lea    -0x1(%eax),%edx
  8012cf:	89 55 10             	mov    %edx,0x10(%ebp)
  8012d2:	85 c0                	test   %eax,%eax
  8012d4:	75 dd                	jne    8012b3 <memmove+0x54>
			*d++ = *s++;

	return dst;
  8012d6:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8012d9:	c9                   	leave  
  8012da:	c3                   	ret    

008012db <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  8012db:	55                   	push   %ebp
  8012dc:	89 e5                	mov    %esp,%ebp
  8012de:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  8012e1:	8b 45 08             	mov    0x8(%ebp),%eax
  8012e4:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  8012e7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8012ea:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  8012ed:	eb 2a                	jmp    801319 <memcmp+0x3e>
		if (*s1 != *s2)
  8012ef:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8012f2:	8a 10                	mov    (%eax),%dl
  8012f4:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8012f7:	8a 00                	mov    (%eax),%al
  8012f9:	38 c2                	cmp    %al,%dl
  8012fb:	74 16                	je     801313 <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  8012fd:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801300:	8a 00                	mov    (%eax),%al
  801302:	0f b6 d0             	movzbl %al,%edx
  801305:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801308:	8a 00                	mov    (%eax),%al
  80130a:	0f b6 c0             	movzbl %al,%eax
  80130d:	29 c2                	sub    %eax,%edx
  80130f:	89 d0                	mov    %edx,%eax
  801311:	eb 18                	jmp    80132b <memcmp+0x50>
		s1++, s2++;
  801313:	ff 45 fc             	incl   -0x4(%ebp)
  801316:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  801319:	8b 45 10             	mov    0x10(%ebp),%eax
  80131c:	8d 50 ff             	lea    -0x1(%eax),%edx
  80131f:	89 55 10             	mov    %edx,0x10(%ebp)
  801322:	85 c0                	test   %eax,%eax
  801324:	75 c9                	jne    8012ef <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  801326:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80132b:	c9                   	leave  
  80132c:	c3                   	ret    

0080132d <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  80132d:	55                   	push   %ebp
  80132e:	89 e5                	mov    %esp,%ebp
  801330:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  801333:	8b 55 08             	mov    0x8(%ebp),%edx
  801336:	8b 45 10             	mov    0x10(%ebp),%eax
  801339:	01 d0                	add    %edx,%eax
  80133b:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  80133e:	eb 15                	jmp    801355 <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  801340:	8b 45 08             	mov    0x8(%ebp),%eax
  801343:	8a 00                	mov    (%eax),%al
  801345:	0f b6 d0             	movzbl %al,%edx
  801348:	8b 45 0c             	mov    0xc(%ebp),%eax
  80134b:	0f b6 c0             	movzbl %al,%eax
  80134e:	39 c2                	cmp    %eax,%edx
  801350:	74 0d                	je     80135f <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  801352:	ff 45 08             	incl   0x8(%ebp)
  801355:	8b 45 08             	mov    0x8(%ebp),%eax
  801358:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  80135b:	72 e3                	jb     801340 <memfind+0x13>
  80135d:	eb 01                	jmp    801360 <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  80135f:	90                   	nop
	return (void *) s;
  801360:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801363:	c9                   	leave  
  801364:	c3                   	ret    

00801365 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  801365:	55                   	push   %ebp
  801366:	89 e5                	mov    %esp,%ebp
  801368:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  80136b:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  801372:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801379:	eb 03                	jmp    80137e <strtol+0x19>
		s++;
  80137b:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  80137e:	8b 45 08             	mov    0x8(%ebp),%eax
  801381:	8a 00                	mov    (%eax),%al
  801383:	3c 20                	cmp    $0x20,%al
  801385:	74 f4                	je     80137b <strtol+0x16>
  801387:	8b 45 08             	mov    0x8(%ebp),%eax
  80138a:	8a 00                	mov    (%eax),%al
  80138c:	3c 09                	cmp    $0x9,%al
  80138e:	74 eb                	je     80137b <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  801390:	8b 45 08             	mov    0x8(%ebp),%eax
  801393:	8a 00                	mov    (%eax),%al
  801395:	3c 2b                	cmp    $0x2b,%al
  801397:	75 05                	jne    80139e <strtol+0x39>
		s++;
  801399:	ff 45 08             	incl   0x8(%ebp)
  80139c:	eb 13                	jmp    8013b1 <strtol+0x4c>
	else if (*s == '-')
  80139e:	8b 45 08             	mov    0x8(%ebp),%eax
  8013a1:	8a 00                	mov    (%eax),%al
  8013a3:	3c 2d                	cmp    $0x2d,%al
  8013a5:	75 0a                	jne    8013b1 <strtol+0x4c>
		s++, neg = 1;
  8013a7:	ff 45 08             	incl   0x8(%ebp)
  8013aa:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  8013b1:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8013b5:	74 06                	je     8013bd <strtol+0x58>
  8013b7:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  8013bb:	75 20                	jne    8013dd <strtol+0x78>
  8013bd:	8b 45 08             	mov    0x8(%ebp),%eax
  8013c0:	8a 00                	mov    (%eax),%al
  8013c2:	3c 30                	cmp    $0x30,%al
  8013c4:	75 17                	jne    8013dd <strtol+0x78>
  8013c6:	8b 45 08             	mov    0x8(%ebp),%eax
  8013c9:	40                   	inc    %eax
  8013ca:	8a 00                	mov    (%eax),%al
  8013cc:	3c 78                	cmp    $0x78,%al
  8013ce:	75 0d                	jne    8013dd <strtol+0x78>
		s += 2, base = 16;
  8013d0:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  8013d4:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  8013db:	eb 28                	jmp    801405 <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  8013dd:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8013e1:	75 15                	jne    8013f8 <strtol+0x93>
  8013e3:	8b 45 08             	mov    0x8(%ebp),%eax
  8013e6:	8a 00                	mov    (%eax),%al
  8013e8:	3c 30                	cmp    $0x30,%al
  8013ea:	75 0c                	jne    8013f8 <strtol+0x93>
		s++, base = 8;
  8013ec:	ff 45 08             	incl   0x8(%ebp)
  8013ef:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  8013f6:	eb 0d                	jmp    801405 <strtol+0xa0>
	else if (base == 0)
  8013f8:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8013fc:	75 07                	jne    801405 <strtol+0xa0>
		base = 10;
  8013fe:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  801405:	8b 45 08             	mov    0x8(%ebp),%eax
  801408:	8a 00                	mov    (%eax),%al
  80140a:	3c 2f                	cmp    $0x2f,%al
  80140c:	7e 19                	jle    801427 <strtol+0xc2>
  80140e:	8b 45 08             	mov    0x8(%ebp),%eax
  801411:	8a 00                	mov    (%eax),%al
  801413:	3c 39                	cmp    $0x39,%al
  801415:	7f 10                	jg     801427 <strtol+0xc2>
			dig = *s - '0';
  801417:	8b 45 08             	mov    0x8(%ebp),%eax
  80141a:	8a 00                	mov    (%eax),%al
  80141c:	0f be c0             	movsbl %al,%eax
  80141f:	83 e8 30             	sub    $0x30,%eax
  801422:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801425:	eb 42                	jmp    801469 <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  801427:	8b 45 08             	mov    0x8(%ebp),%eax
  80142a:	8a 00                	mov    (%eax),%al
  80142c:	3c 60                	cmp    $0x60,%al
  80142e:	7e 19                	jle    801449 <strtol+0xe4>
  801430:	8b 45 08             	mov    0x8(%ebp),%eax
  801433:	8a 00                	mov    (%eax),%al
  801435:	3c 7a                	cmp    $0x7a,%al
  801437:	7f 10                	jg     801449 <strtol+0xe4>
			dig = *s - 'a' + 10;
  801439:	8b 45 08             	mov    0x8(%ebp),%eax
  80143c:	8a 00                	mov    (%eax),%al
  80143e:	0f be c0             	movsbl %al,%eax
  801441:	83 e8 57             	sub    $0x57,%eax
  801444:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801447:	eb 20                	jmp    801469 <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  801449:	8b 45 08             	mov    0x8(%ebp),%eax
  80144c:	8a 00                	mov    (%eax),%al
  80144e:	3c 40                	cmp    $0x40,%al
  801450:	7e 39                	jle    80148b <strtol+0x126>
  801452:	8b 45 08             	mov    0x8(%ebp),%eax
  801455:	8a 00                	mov    (%eax),%al
  801457:	3c 5a                	cmp    $0x5a,%al
  801459:	7f 30                	jg     80148b <strtol+0x126>
			dig = *s - 'A' + 10;
  80145b:	8b 45 08             	mov    0x8(%ebp),%eax
  80145e:	8a 00                	mov    (%eax),%al
  801460:	0f be c0             	movsbl %al,%eax
  801463:	83 e8 37             	sub    $0x37,%eax
  801466:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  801469:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80146c:	3b 45 10             	cmp    0x10(%ebp),%eax
  80146f:	7d 19                	jge    80148a <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  801471:	ff 45 08             	incl   0x8(%ebp)
  801474:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801477:	0f af 45 10          	imul   0x10(%ebp),%eax
  80147b:	89 c2                	mov    %eax,%edx
  80147d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801480:	01 d0                	add    %edx,%eax
  801482:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  801485:	e9 7b ff ff ff       	jmp    801405 <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  80148a:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  80148b:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80148f:	74 08                	je     801499 <strtol+0x134>
		*endptr = (char *) s;
  801491:	8b 45 0c             	mov    0xc(%ebp),%eax
  801494:	8b 55 08             	mov    0x8(%ebp),%edx
  801497:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  801499:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  80149d:	74 07                	je     8014a6 <strtol+0x141>
  80149f:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8014a2:	f7 d8                	neg    %eax
  8014a4:	eb 03                	jmp    8014a9 <strtol+0x144>
  8014a6:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  8014a9:	c9                   	leave  
  8014aa:	c3                   	ret    

008014ab <ltostr>:

void
ltostr(long value, char *str)
{
  8014ab:	55                   	push   %ebp
  8014ac:	89 e5                	mov    %esp,%ebp
  8014ae:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  8014b1:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  8014b8:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  8014bf:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8014c3:	79 13                	jns    8014d8 <ltostr+0x2d>
	{
		neg = 1;
  8014c5:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  8014cc:	8b 45 0c             	mov    0xc(%ebp),%eax
  8014cf:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  8014d2:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  8014d5:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  8014d8:	8b 45 08             	mov    0x8(%ebp),%eax
  8014db:	b9 0a 00 00 00       	mov    $0xa,%ecx
  8014e0:	99                   	cltd   
  8014e1:	f7 f9                	idiv   %ecx
  8014e3:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  8014e6:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8014e9:	8d 50 01             	lea    0x1(%eax),%edx
  8014ec:	89 55 f8             	mov    %edx,-0x8(%ebp)
  8014ef:	89 c2                	mov    %eax,%edx
  8014f1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8014f4:	01 d0                	add    %edx,%eax
  8014f6:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8014f9:	83 c2 30             	add    $0x30,%edx
  8014fc:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  8014fe:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801501:	b8 67 66 66 66       	mov    $0x66666667,%eax
  801506:	f7 e9                	imul   %ecx
  801508:	c1 fa 02             	sar    $0x2,%edx
  80150b:	89 c8                	mov    %ecx,%eax
  80150d:	c1 f8 1f             	sar    $0x1f,%eax
  801510:	29 c2                	sub    %eax,%edx
  801512:	89 d0                	mov    %edx,%eax
  801514:	89 45 08             	mov    %eax,0x8(%ebp)
	} while (value % 10 != 0);
  801517:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80151a:	b8 67 66 66 66       	mov    $0x66666667,%eax
  80151f:	f7 e9                	imul   %ecx
  801521:	c1 fa 02             	sar    $0x2,%edx
  801524:	89 c8                	mov    %ecx,%eax
  801526:	c1 f8 1f             	sar    $0x1f,%eax
  801529:	29 c2                	sub    %eax,%edx
  80152b:	89 d0                	mov    %edx,%eax
  80152d:	c1 e0 02             	shl    $0x2,%eax
  801530:	01 d0                	add    %edx,%eax
  801532:	01 c0                	add    %eax,%eax
  801534:	29 c1                	sub    %eax,%ecx
  801536:	89 ca                	mov    %ecx,%edx
  801538:	85 d2                	test   %edx,%edx
  80153a:	75 9c                	jne    8014d8 <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  80153c:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  801543:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801546:	48                   	dec    %eax
  801547:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  80154a:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  80154e:	74 3d                	je     80158d <ltostr+0xe2>
		start = 1 ;
  801550:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  801557:	eb 34                	jmp    80158d <ltostr+0xe2>
	{
		char tmp = str[start] ;
  801559:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80155c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80155f:	01 d0                	add    %edx,%eax
  801561:	8a 00                	mov    (%eax),%al
  801563:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  801566:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801569:	8b 45 0c             	mov    0xc(%ebp),%eax
  80156c:	01 c2                	add    %eax,%edx
  80156e:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  801571:	8b 45 0c             	mov    0xc(%ebp),%eax
  801574:	01 c8                	add    %ecx,%eax
  801576:	8a 00                	mov    (%eax),%al
  801578:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  80157a:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80157d:	8b 45 0c             	mov    0xc(%ebp),%eax
  801580:	01 c2                	add    %eax,%edx
  801582:	8a 45 eb             	mov    -0x15(%ebp),%al
  801585:	88 02                	mov    %al,(%edx)
		start++ ;
  801587:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  80158a:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  80158d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801590:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801593:	7c c4                	jl     801559 <ltostr+0xae>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  801595:	8b 55 f8             	mov    -0x8(%ebp),%edx
  801598:	8b 45 0c             	mov    0xc(%ebp),%eax
  80159b:	01 d0                	add    %edx,%eax
  80159d:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  8015a0:	90                   	nop
  8015a1:	c9                   	leave  
  8015a2:	c3                   	ret    

008015a3 <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  8015a3:	55                   	push   %ebp
  8015a4:	89 e5                	mov    %esp,%ebp
  8015a6:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  8015a9:	ff 75 08             	pushl  0x8(%ebp)
  8015ac:	e8 54 fa ff ff       	call   801005 <strlen>
  8015b1:	83 c4 04             	add    $0x4,%esp
  8015b4:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  8015b7:	ff 75 0c             	pushl  0xc(%ebp)
  8015ba:	e8 46 fa ff ff       	call   801005 <strlen>
  8015bf:	83 c4 04             	add    $0x4,%esp
  8015c2:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  8015c5:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  8015cc:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8015d3:	eb 17                	jmp    8015ec <strcconcat+0x49>
		final[s] = str1[s] ;
  8015d5:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8015d8:	8b 45 10             	mov    0x10(%ebp),%eax
  8015db:	01 c2                	add    %eax,%edx
  8015dd:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  8015e0:	8b 45 08             	mov    0x8(%ebp),%eax
  8015e3:	01 c8                	add    %ecx,%eax
  8015e5:	8a 00                	mov    (%eax),%al
  8015e7:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  8015e9:	ff 45 fc             	incl   -0x4(%ebp)
  8015ec:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8015ef:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  8015f2:	7c e1                	jl     8015d5 <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  8015f4:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  8015fb:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  801602:	eb 1f                	jmp    801623 <strcconcat+0x80>
		final[s++] = str2[i] ;
  801604:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801607:	8d 50 01             	lea    0x1(%eax),%edx
  80160a:	89 55 fc             	mov    %edx,-0x4(%ebp)
  80160d:	89 c2                	mov    %eax,%edx
  80160f:	8b 45 10             	mov    0x10(%ebp),%eax
  801612:	01 c2                	add    %eax,%edx
  801614:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  801617:	8b 45 0c             	mov    0xc(%ebp),%eax
  80161a:	01 c8                	add    %ecx,%eax
  80161c:	8a 00                	mov    (%eax),%al
  80161e:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  801620:	ff 45 f8             	incl   -0x8(%ebp)
  801623:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801626:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801629:	7c d9                	jl     801604 <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  80162b:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80162e:	8b 45 10             	mov    0x10(%ebp),%eax
  801631:	01 d0                	add    %edx,%eax
  801633:	c6 00 00             	movb   $0x0,(%eax)
}
  801636:	90                   	nop
  801637:	c9                   	leave  
  801638:	c3                   	ret    

00801639 <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  801639:	55                   	push   %ebp
  80163a:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  80163c:	8b 45 14             	mov    0x14(%ebp),%eax
  80163f:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  801645:	8b 45 14             	mov    0x14(%ebp),%eax
  801648:	8b 00                	mov    (%eax),%eax
  80164a:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801651:	8b 45 10             	mov    0x10(%ebp),%eax
  801654:	01 d0                	add    %edx,%eax
  801656:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  80165c:	eb 0c                	jmp    80166a <strsplit+0x31>
			*string++ = 0;
  80165e:	8b 45 08             	mov    0x8(%ebp),%eax
  801661:	8d 50 01             	lea    0x1(%eax),%edx
  801664:	89 55 08             	mov    %edx,0x8(%ebp)
  801667:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  80166a:	8b 45 08             	mov    0x8(%ebp),%eax
  80166d:	8a 00                	mov    (%eax),%al
  80166f:	84 c0                	test   %al,%al
  801671:	74 18                	je     80168b <strsplit+0x52>
  801673:	8b 45 08             	mov    0x8(%ebp),%eax
  801676:	8a 00                	mov    (%eax),%al
  801678:	0f be c0             	movsbl %al,%eax
  80167b:	50                   	push   %eax
  80167c:	ff 75 0c             	pushl  0xc(%ebp)
  80167f:	e8 13 fb ff ff       	call   801197 <strchr>
  801684:	83 c4 08             	add    $0x8,%esp
  801687:	85 c0                	test   %eax,%eax
  801689:	75 d3                	jne    80165e <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  80168b:	8b 45 08             	mov    0x8(%ebp),%eax
  80168e:	8a 00                	mov    (%eax),%al
  801690:	84 c0                	test   %al,%al
  801692:	74 5a                	je     8016ee <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  801694:	8b 45 14             	mov    0x14(%ebp),%eax
  801697:	8b 00                	mov    (%eax),%eax
  801699:	83 f8 0f             	cmp    $0xf,%eax
  80169c:	75 07                	jne    8016a5 <strsplit+0x6c>
		{
			return 0;
  80169e:	b8 00 00 00 00       	mov    $0x0,%eax
  8016a3:	eb 66                	jmp    80170b <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  8016a5:	8b 45 14             	mov    0x14(%ebp),%eax
  8016a8:	8b 00                	mov    (%eax),%eax
  8016aa:	8d 48 01             	lea    0x1(%eax),%ecx
  8016ad:	8b 55 14             	mov    0x14(%ebp),%edx
  8016b0:	89 0a                	mov    %ecx,(%edx)
  8016b2:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8016b9:	8b 45 10             	mov    0x10(%ebp),%eax
  8016bc:	01 c2                	add    %eax,%edx
  8016be:	8b 45 08             	mov    0x8(%ebp),%eax
  8016c1:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  8016c3:	eb 03                	jmp    8016c8 <strsplit+0x8f>
			string++;
  8016c5:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  8016c8:	8b 45 08             	mov    0x8(%ebp),%eax
  8016cb:	8a 00                	mov    (%eax),%al
  8016cd:	84 c0                	test   %al,%al
  8016cf:	74 8b                	je     80165c <strsplit+0x23>
  8016d1:	8b 45 08             	mov    0x8(%ebp),%eax
  8016d4:	8a 00                	mov    (%eax),%al
  8016d6:	0f be c0             	movsbl %al,%eax
  8016d9:	50                   	push   %eax
  8016da:	ff 75 0c             	pushl  0xc(%ebp)
  8016dd:	e8 b5 fa ff ff       	call   801197 <strchr>
  8016e2:	83 c4 08             	add    $0x8,%esp
  8016e5:	85 c0                	test   %eax,%eax
  8016e7:	74 dc                	je     8016c5 <strsplit+0x8c>
			string++;
	}
  8016e9:	e9 6e ff ff ff       	jmp    80165c <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  8016ee:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  8016ef:	8b 45 14             	mov    0x14(%ebp),%eax
  8016f2:	8b 00                	mov    (%eax),%eax
  8016f4:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8016fb:	8b 45 10             	mov    0x10(%ebp),%eax
  8016fe:	01 d0                	add    %edx,%eax
  801700:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  801706:	b8 01 00 00 00       	mov    $0x1,%eax
}
  80170b:	c9                   	leave  
  80170c:	c3                   	ret    

0080170d <InitializeUHeap>:
//============================== GIVEN FUNCTIONS ===================================//
//==================================================================================//

int FirstTimeFlag = 1;
void InitializeUHeap()
{
  80170d:	55                   	push   %ebp
  80170e:	89 e5                	mov    %esp,%ebp
  801710:	83 ec 08             	sub    $0x8,%esp
	if(FirstTimeFlag)
  801713:	a1 04 50 80 00       	mov    0x805004,%eax
  801718:	85 c0                	test   %eax,%eax
  80171a:	74 1f                	je     80173b <InitializeUHeap+0x2e>
	{
		initialize_dyn_block_system();
  80171c:	e8 1d 00 00 00       	call   80173e <initialize_dyn_block_system>
		cprintf("DYNAMIC BLOCK SYSTEM IS INITIALIZED\n");
  801721:	83 ec 0c             	sub    $0xc,%esp
  801724:	68 f0 3e 80 00       	push   $0x803ef0
  801729:	e8 55 f2 ff ff       	call   800983 <cprintf>
  80172e:	83 c4 10             	add    $0x10,%esp
#if UHP_USE_BUDDY
		initialize_buddy();
		cprintf("BUDDY SYSTEM IS INITIALIZED\n");
#endif
		FirstTimeFlag = 0;
  801731:	c7 05 04 50 80 00 00 	movl   $0x0,0x805004
  801738:	00 00 00 
	}
}
  80173b:	90                   	nop
  80173c:	c9                   	leave  
  80173d:	c3                   	ret    

0080173e <initialize_dyn_block_system>:

//=================================
// [1] INITIALIZE DYNAMIC ALLOCATOR:
//=================================
void initialize_dyn_block_system()
{
  80173e:	55                   	push   %ebp
  80173f:	89 e5                	mov    %esp,%ebp
  801741:	83 ec 28             	sub    $0x28,%esp
	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] initialize_dyn_block_system
	// your code is here, remove the panic and write your code
	//panic("initialize_dyn_block_system() is not implemented yet...!!");

	LIST_INIT(&AllocMemBlocksList);
  801744:	c7 05 40 50 80 00 00 	movl   $0x0,0x805040
  80174b:	00 00 00 
  80174e:	c7 05 44 50 80 00 00 	movl   $0x0,0x805044
  801755:	00 00 00 
  801758:	c7 05 4c 50 80 00 00 	movl   $0x0,0x80504c
  80175f:	00 00 00 
	LIST_INIT(&FreeMemBlocksList);
  801762:	c7 05 38 51 80 00 00 	movl   $0x0,0x805138
  801769:	00 00 00 
  80176c:	c7 05 3c 51 80 00 00 	movl   $0x0,0x80513c
  801773:	00 00 00 
  801776:	c7 05 44 51 80 00 00 	movl   $0x0,0x805144
  80177d:	00 00 00 
	MAX_MEM_BLOCK_CNT = NUM_OF_UHEAP_PAGES;
  801780:	c7 05 20 51 80 00 00 	movl   $0x20000,0x805120
  801787:	00 02 00 
	MemBlockNodes = (void*)USER_DYN_BLKS_ARRAY;
  80178a:	c7 45 f4 00 00 e0 7f 	movl   $0x7fe00000,-0xc(%ebp)
  801791:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801794:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801799:	2d 00 10 00 00       	sub    $0x1000,%eax
  80179e:	a3 50 50 80 00       	mov    %eax,0x805050
	int size_of_block = sizeof(struct MemBlock);
  8017a3:	c7 45 f0 10 00 00 00 	movl   $0x10,-0x10(%ebp)
	int size_all_struct = size_of_block*MAX_MEM_BLOCK_CNT;
  8017aa:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8017ad:	a1 20 51 80 00       	mov    0x805120,%eax
  8017b2:	0f af c2             	imul   %edx,%eax
  8017b5:	89 45 ec             	mov    %eax,-0x14(%ebp)
	size_all_struct = ROUNDUP(size_all_struct, PAGE_SIZE);
  8017b8:	c7 45 e8 00 10 00 00 	movl   $0x1000,-0x18(%ebp)
  8017bf:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8017c2:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8017c5:	01 d0                	add    %edx,%eax
  8017c7:	48                   	dec    %eax
  8017c8:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8017cb:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8017ce:	ba 00 00 00 00       	mov    $0x0,%edx
  8017d3:	f7 75 e8             	divl   -0x18(%ebp)
  8017d6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8017d9:	29 d0                	sub    %edx,%eax
  8017db:	89 45 ec             	mov    %eax,-0x14(%ebp)
	sys_allocate_chunk(USER_DYN_BLKS_ARRAY, size_all_struct,PERM_USER| PERM_WRITEABLE);
  8017de:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8017e1:	c7 45 e0 00 00 e0 7f 	movl   $0x7fe00000,-0x20(%ebp)
  8017e8:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8017eb:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
  8017f1:	81 ea 00 10 00 00    	sub    $0x1000,%edx
  8017f7:	83 ec 04             	sub    $0x4,%esp
  8017fa:	6a 06                	push   $0x6
  8017fc:	50                   	push   %eax
  8017fd:	52                   	push   %edx
  8017fe:	e8 a1 05 00 00       	call   801da4 <sys_allocate_chunk>
  801803:	83 c4 10             	add    $0x10,%esp
	initialize_MemBlocksList(MAX_MEM_BLOCK_CNT);
  801806:	a1 20 51 80 00       	mov    0x805120,%eax
  80180b:	83 ec 0c             	sub    $0xc,%esp
  80180e:	50                   	push   %eax
  80180f:	e8 16 0c 00 00       	call   80242a <initialize_MemBlocksList>
  801814:	83 c4 10             	add    $0x10,%esp
	struct MemBlock* ourBlock =LIST_LAST(&AvailableMemBlocksList);
  801817:	a1 4c 51 80 00       	mov    0x80514c,%eax
  80181c:	89 45 dc             	mov    %eax,-0x24(%ebp)
	LIST_REMOVE(&AvailableMemBlocksList,ourBlock);
  80181f:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  801823:	75 14                	jne    801839 <initialize_dyn_block_system+0xfb>
  801825:	83 ec 04             	sub    $0x4,%esp
  801828:	68 15 3f 80 00       	push   $0x803f15
  80182d:	6a 2d                	push   $0x2d
  80182f:	68 33 3f 80 00       	push   $0x803f33
  801834:	e8 96 ee ff ff       	call   8006cf <_panic>
  801839:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80183c:	8b 00                	mov    (%eax),%eax
  80183e:	85 c0                	test   %eax,%eax
  801840:	74 10                	je     801852 <initialize_dyn_block_system+0x114>
  801842:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801845:	8b 00                	mov    (%eax),%eax
  801847:	8b 55 dc             	mov    -0x24(%ebp),%edx
  80184a:	8b 52 04             	mov    0x4(%edx),%edx
  80184d:	89 50 04             	mov    %edx,0x4(%eax)
  801850:	eb 0b                	jmp    80185d <initialize_dyn_block_system+0x11f>
  801852:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801855:	8b 40 04             	mov    0x4(%eax),%eax
  801858:	a3 4c 51 80 00       	mov    %eax,0x80514c
  80185d:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801860:	8b 40 04             	mov    0x4(%eax),%eax
  801863:	85 c0                	test   %eax,%eax
  801865:	74 0f                	je     801876 <initialize_dyn_block_system+0x138>
  801867:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80186a:	8b 40 04             	mov    0x4(%eax),%eax
  80186d:	8b 55 dc             	mov    -0x24(%ebp),%edx
  801870:	8b 12                	mov    (%edx),%edx
  801872:	89 10                	mov    %edx,(%eax)
  801874:	eb 0a                	jmp    801880 <initialize_dyn_block_system+0x142>
  801876:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801879:	8b 00                	mov    (%eax),%eax
  80187b:	a3 48 51 80 00       	mov    %eax,0x805148
  801880:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801883:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  801889:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80188c:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  801893:	a1 54 51 80 00       	mov    0x805154,%eax
  801898:	48                   	dec    %eax
  801899:	a3 54 51 80 00       	mov    %eax,0x805154
	ourBlock->size = USER_HEAP_MAX-USER_HEAP_START;
  80189e:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8018a1:	c7 40 0c 00 00 00 20 	movl   $0x20000000,0xc(%eax)
	ourBlock->sva=USER_HEAP_START;
  8018a8:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8018ab:	c7 40 08 00 00 00 80 	movl   $0x80000000,0x8(%eax)
	LIST_INSERT_TAIL(&FreeMemBlocksList, ourBlock);
  8018b2:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  8018b6:	75 14                	jne    8018cc <initialize_dyn_block_system+0x18e>
  8018b8:	83 ec 04             	sub    $0x4,%esp
  8018bb:	68 40 3f 80 00       	push   $0x803f40
  8018c0:	6a 30                	push   $0x30
  8018c2:	68 33 3f 80 00       	push   $0x803f33
  8018c7:	e8 03 ee ff ff       	call   8006cf <_panic>
  8018cc:	8b 15 3c 51 80 00    	mov    0x80513c,%edx
  8018d2:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8018d5:	89 50 04             	mov    %edx,0x4(%eax)
  8018d8:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8018db:	8b 40 04             	mov    0x4(%eax),%eax
  8018de:	85 c0                	test   %eax,%eax
  8018e0:	74 0c                	je     8018ee <initialize_dyn_block_system+0x1b0>
  8018e2:	a1 3c 51 80 00       	mov    0x80513c,%eax
  8018e7:	8b 55 dc             	mov    -0x24(%ebp),%edx
  8018ea:	89 10                	mov    %edx,(%eax)
  8018ec:	eb 08                	jmp    8018f6 <initialize_dyn_block_system+0x1b8>
  8018ee:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8018f1:	a3 38 51 80 00       	mov    %eax,0x805138
  8018f6:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8018f9:	a3 3c 51 80 00       	mov    %eax,0x80513c
  8018fe:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801901:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  801907:	a1 44 51 80 00       	mov    0x805144,%eax
  80190c:	40                   	inc    %eax
  80190d:	a3 44 51 80 00       	mov    %eax,0x805144
	//[1] Initialize two lists (AllocMemBlocksList & FreeMemBlocksList) [Hint: use LIST_INIT()]
	//[2] Dynamically allocate the array of MemBlockNodes at VA USER_DYN_BLKS_ARRAY
	//	  (remember to set MAX_MEM_BLOCK_CNT with the chosen size of the array)
	//[3] Initialize AvailableMemBlocksList by filling it with the MemBlockNodes
	//[4] Insert a new MemBlock with the heap size into the FreeMemBlocksList
}
  801912:	90                   	nop
  801913:	c9                   	leave  
  801914:	c3                   	ret    

00801915 <malloc>:
//=================================
// [2] ALLOCATE SPACE IN USER HEAP:
//=================================

void* malloc(uint32 size)
{
  801915:	55                   	push   %ebp
  801916:	89 e5                	mov    %esp,%ebp
  801918:	83 ec 18             	sub    $0x18,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  80191b:	e8 ed fd ff ff       	call   80170d <InitializeUHeap>
	if (size == 0) return NULL ;
  801920:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801924:	75 07                	jne    80192d <malloc+0x18>
  801926:	b8 00 00 00 00       	mov    $0x0,%eax
  80192b:	eb 67                	jmp    801994 <malloc+0x7f>

	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] malloc
	// your code is here, remove the panic and write your code
	//panic("malloc() is not implemented yet...!!");

	size = ROUNDUP(size, PAGE_SIZE);
  80192d:	c7 45 f4 00 10 00 00 	movl   $0x1000,-0xc(%ebp)
  801934:	8b 55 08             	mov    0x8(%ebp),%edx
  801937:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80193a:	01 d0                	add    %edx,%eax
  80193c:	48                   	dec    %eax
  80193d:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801940:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801943:	ba 00 00 00 00       	mov    $0x0,%edx
  801948:	f7 75 f4             	divl   -0xc(%ebp)
  80194b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80194e:	29 d0                	sub    %edx,%eax
  801950:	89 45 08             	mov    %eax,0x8(%ebp)
	if(sys_isUHeapPlacementStrategyFIRSTFIT())
  801953:	e8 1a 08 00 00       	call   802172 <sys_isUHeapPlacementStrategyFIRSTFIT>
  801958:	85 c0                	test   %eax,%eax
  80195a:	74 33                	je     80198f <malloc+0x7a>
	{
		struct MemBlock * myBlock = alloc_block_FF(size);
  80195c:	83 ec 0c             	sub    $0xc,%esp
  80195f:	ff 75 08             	pushl  0x8(%ebp)
  801962:	e8 0c 0e 00 00       	call   802773 <alloc_block_FF>
  801967:	83 c4 10             	add    $0x10,%esp
  80196a:	89 45 ec             	mov    %eax,-0x14(%ebp)
		if(myBlock != NULL)
  80196d:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  801971:	74 1c                	je     80198f <malloc+0x7a>
		{
			insert_sorted_allocList(myBlock);
  801973:	83 ec 0c             	sub    $0xc,%esp
  801976:	ff 75 ec             	pushl  -0x14(%ebp)
  801979:	e8 07 0c 00 00       	call   802585 <insert_sorted_allocList>
  80197e:	83 c4 10             	add    $0x10,%esp
			uint32 ptr = myBlock->sva;
  801981:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801984:	8b 40 08             	mov    0x8(%eax),%eax
  801987:	89 45 e8             	mov    %eax,-0x18(%ebp)
			return (void *)ptr;
  80198a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80198d:	eb 05                	jmp    801994 <malloc+0x7f>
		}
	}
	return NULL;
  80198f:	b8 00 00 00 00       	mov    $0x0,%eax
	//		to the required allocation size (space should be on 4 KB BOUNDARY)
	//	2) if no suitable space found, return NULL
	// 	3) Return pointer containing the virtual address of allocated space,
	//
	//Use sys_isUHeapPlacementStrategyFIRSTFIT()... to check the current strategy
}
  801994:	c9                   	leave  
  801995:	c3                   	ret    

00801996 <free>:
//	We can use sys_free_user_mem(uint32 virtual_address, uint32 size); which
//		switches to the kernel mode, calls free_user_mem() in
//		"kern/mem/chunk_operations.c", then switch back to the user mode here
//	the free_user_mem function is empty, make sure to implement it.
void free(void* virtual_address)
{
  801996:	55                   	push   %ebp
  801997:	89 e5                	mov    %esp,%ebp
  801999:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] free
	// your code is here, remove the panic and write your code
	//panic("free() is not implemented yet...!!");

	uint32 virtualAddress = (uint32 )(virtual_address);
  80199c:	8b 45 08             	mov    0x8(%ebp),%eax
  80199f:	89 45 f4             	mov    %eax,-0xc(%ebp)
//	virtualAddress = ROUNDDOWN(virtualAddress, PAGE_SIZE);
	struct MemBlock * myBlock = find_block(&AllocMemBlocksList, virtualAddress);
  8019a2:	83 ec 08             	sub    $0x8,%esp
  8019a5:	ff 75 f4             	pushl  -0xc(%ebp)
  8019a8:	68 40 50 80 00       	push   $0x805040
  8019ad:	e8 5b 0b 00 00       	call   80250d <find_block>
  8019b2:	83 c4 10             	add    $0x10,%esp
  8019b5:	89 45 f0             	mov    %eax,-0x10(%ebp)
//	cprintf ("ptr sva at free user side = %x \n", myBlock->sva);
	sys_free_user_mem(virtualAddress, myBlock->size);
  8019b8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8019bb:	8b 40 0c             	mov    0xc(%eax),%eax
  8019be:	83 ec 08             	sub    $0x8,%esp
  8019c1:	50                   	push   %eax
  8019c2:	ff 75 f4             	pushl  -0xc(%ebp)
  8019c5:	e8 a2 03 00 00       	call   801d6c <sys_free_user_mem>
  8019ca:	83 c4 10             	add    $0x10,%esp
	LIST_REMOVE(&AllocMemBlocksList, myBlock);
  8019cd:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8019d1:	75 14                	jne    8019e7 <free+0x51>
  8019d3:	83 ec 04             	sub    $0x4,%esp
  8019d6:	68 15 3f 80 00       	push   $0x803f15
  8019db:	6a 76                	push   $0x76
  8019dd:	68 33 3f 80 00       	push   $0x803f33
  8019e2:	e8 e8 ec ff ff       	call   8006cf <_panic>
  8019e7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8019ea:	8b 00                	mov    (%eax),%eax
  8019ec:	85 c0                	test   %eax,%eax
  8019ee:	74 10                	je     801a00 <free+0x6a>
  8019f0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8019f3:	8b 00                	mov    (%eax),%eax
  8019f5:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8019f8:	8b 52 04             	mov    0x4(%edx),%edx
  8019fb:	89 50 04             	mov    %edx,0x4(%eax)
  8019fe:	eb 0b                	jmp    801a0b <free+0x75>
  801a00:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801a03:	8b 40 04             	mov    0x4(%eax),%eax
  801a06:	a3 44 50 80 00       	mov    %eax,0x805044
  801a0b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801a0e:	8b 40 04             	mov    0x4(%eax),%eax
  801a11:	85 c0                	test   %eax,%eax
  801a13:	74 0f                	je     801a24 <free+0x8e>
  801a15:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801a18:	8b 40 04             	mov    0x4(%eax),%eax
  801a1b:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801a1e:	8b 12                	mov    (%edx),%edx
  801a20:	89 10                	mov    %edx,(%eax)
  801a22:	eb 0a                	jmp    801a2e <free+0x98>
  801a24:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801a27:	8b 00                	mov    (%eax),%eax
  801a29:	a3 40 50 80 00       	mov    %eax,0x805040
  801a2e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801a31:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  801a37:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801a3a:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  801a41:	a1 4c 50 80 00       	mov    0x80504c,%eax
  801a46:	48                   	dec    %eax
  801a47:	a3 4c 50 80 00       	mov    %eax,0x80504c
	insert_sorted_with_merge_freeList(myBlock);
  801a4c:	83 ec 0c             	sub    $0xc,%esp
  801a4f:	ff 75 f0             	pushl  -0x10(%ebp)
  801a52:	e8 0b 14 00 00       	call   802e62 <insert_sorted_with_merge_freeList>
  801a57:	83 c4 10             	add    $0x10,%esp

	//you should get the size of the given allocation using its address
	//you need to call sys_free_user_mem()
	//refer to the project presentation and documentation for details
}
  801a5a:	90                   	nop
  801a5b:	c9                   	leave  
  801a5c:	c3                   	ret    

00801a5d <smalloc>:

//=================================
// [4] ALLOCATE SHARED VARIABLE:
//=================================
void* smalloc(char *sharedVarName, uint32 size, uint8 isWritable)
{
  801a5d:	55                   	push   %ebp
  801a5e:	89 e5                	mov    %esp,%ebp
  801a60:	83 ec 28             	sub    $0x28,%esp
  801a63:	8b 45 10             	mov    0x10(%ebp),%eax
  801a66:	88 45 e4             	mov    %al,-0x1c(%ebp)
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801a69:	e8 9f fc ff ff       	call   80170d <InitializeUHeap>
	if (size == 0) return NULL ;
  801a6e:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801a72:	75 0a                	jne    801a7e <smalloc+0x21>
  801a74:	b8 00 00 00 00       	mov    $0x0,%eax
  801a79:	e9 8d 00 00 00       	jmp    801b0b <smalloc+0xae>

	//This function should find the space of the required range
	// * ON 4KB BOUNDARY **** //
	//Use sys_isUHeapPlacementStrategyFIRSTFIT() to check the current strategy

	size = ROUNDUP(size, PAGE_SIZE);
  801a7e:	c7 45 f4 00 10 00 00 	movl   $0x1000,-0xc(%ebp)
  801a85:	8b 55 0c             	mov    0xc(%ebp),%edx
  801a88:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801a8b:	01 d0                	add    %edx,%eax
  801a8d:	48                   	dec    %eax
  801a8e:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801a91:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801a94:	ba 00 00 00 00       	mov    $0x0,%edx
  801a99:	f7 75 f4             	divl   -0xc(%ebp)
  801a9c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801a9f:	29 d0                	sub    %edx,%eax
  801aa1:	89 45 0c             	mov    %eax,0xc(%ebp)
		if(sys_isUHeapPlacementStrategyFIRSTFIT())
  801aa4:	e8 c9 06 00 00       	call   802172 <sys_isUHeapPlacementStrategyFIRSTFIT>
  801aa9:	85 c0                	test   %eax,%eax
  801aab:	74 59                	je     801b06 <smalloc+0xa9>
		{
			struct MemBlock * v1=NULL;
  801aad:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
			v1= alloc_block_FF(size);
  801ab4:	83 ec 0c             	sub    $0xc,%esp
  801ab7:	ff 75 0c             	pushl  0xc(%ebp)
  801aba:	e8 b4 0c 00 00       	call   802773 <alloc_block_FF>
  801abf:	83 c4 10             	add    $0x10,%esp
  801ac2:	89 45 ec             	mov    %eax,-0x14(%ebp)
			if(v1==NULL)
  801ac5:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  801ac9:	75 07                	jne    801ad2 <smalloc+0x75>
			{
				return NULL;
  801acb:	b8 00 00 00 00       	mov    $0x0,%eax
  801ad0:	eb 39                	jmp    801b0b <smalloc+0xae>
			}
			else
			{
				int ret=sys_createSharedObject(sharedVarName,  size,  isWritable,(void*)v1->sva);
  801ad2:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801ad5:	8b 40 08             	mov    0x8(%eax),%eax
  801ad8:	89 c2                	mov    %eax,%edx
  801ada:	0f b6 45 e4          	movzbl -0x1c(%ebp),%eax
  801ade:	52                   	push   %edx
  801adf:	50                   	push   %eax
  801ae0:	ff 75 0c             	pushl  0xc(%ebp)
  801ae3:	ff 75 08             	pushl  0x8(%ebp)
  801ae6:	e8 0c 04 00 00       	call   801ef7 <sys_createSharedObject>
  801aeb:	83 c4 10             	add    $0x10,%esp
  801aee:	89 45 e8             	mov    %eax,-0x18(%ebp)
				if(ret>=0)
  801af1:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  801af5:	78 08                	js     801aff <smalloc+0xa2>
				{
					return (void*)v1->sva;
  801af7:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801afa:	8b 40 08             	mov    0x8(%eax),%eax
  801afd:	eb 0c                	jmp    801b0b <smalloc+0xae>
				}
				else
				{
					return NULL;
  801aff:	b8 00 00 00 00       	mov    $0x0,%eax
  801b04:	eb 05                	jmp    801b0b <smalloc+0xae>
				}
			}

		}
		return NULL;
  801b06:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801b0b:	c9                   	leave  
  801b0c:	c3                   	ret    

00801b0d <sget>:

//========================================
// [5] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
  801b0d:	55                   	push   %ebp
  801b0e:	89 e5                	mov    %esp,%ebp
  801b10:	83 ec 18             	sub    $0x18,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801b13:	e8 f5 fb ff ff       	call   80170d <InitializeUHeap>

	//This function should find the space for sharing the variable
	// *** ON 4KB BOUNDARY ******** //

	//Use sys_isUHeapPlacementStrategyFIRSTFIT() to check the current strategy
	int ret=sys_getSizeOfSharedObject(ownerEnvID,sharedVarName);
  801b18:	83 ec 08             	sub    $0x8,%esp
  801b1b:	ff 75 0c             	pushl  0xc(%ebp)
  801b1e:	ff 75 08             	pushl  0x8(%ebp)
  801b21:	e8 fb 03 00 00       	call   801f21 <sys_getSizeOfSharedObject>
  801b26:	83 c4 10             	add    $0x10,%esp
  801b29:	89 45 f4             	mov    %eax,-0xc(%ebp)
	if(ret==0)
  801b2c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801b30:	75 07                	jne    801b39 <sget+0x2c>
	{
		return NULL;
  801b32:	b8 00 00 00 00       	mov    $0x0,%eax
  801b37:	eb 64                	jmp    801b9d <sget+0x90>
	}
	if(sys_isUHeapPlacementStrategyFIRSTFIT())
  801b39:	e8 34 06 00 00       	call   802172 <sys_isUHeapPlacementStrategyFIRSTFIT>
  801b3e:	85 c0                	test   %eax,%eax
  801b40:	74 56                	je     801b98 <sget+0x8b>
	{
		struct MemBlock * v1=NULL;
  801b42:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
		v1= alloc_block_FF(ret);
  801b49:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801b4c:	83 ec 0c             	sub    $0xc,%esp
  801b4f:	50                   	push   %eax
  801b50:	e8 1e 0c 00 00       	call   802773 <alloc_block_FF>
  801b55:	83 c4 10             	add    $0x10,%esp
  801b58:	89 45 f0             	mov    %eax,-0x10(%ebp)
		if(v1==NULL)
  801b5b:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801b5f:	75 07                	jne    801b68 <sget+0x5b>
		{
		return NULL;
  801b61:	b8 00 00 00 00       	mov    $0x0,%eax
  801b66:	eb 35                	jmp    801b9d <sget+0x90>
	    }
		else
		{
			int ret1=sys_getSharedObject(ownerEnvID,sharedVarName,(void*)v1->sva);
  801b68:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801b6b:	8b 40 08             	mov    0x8(%eax),%eax
  801b6e:	83 ec 04             	sub    $0x4,%esp
  801b71:	50                   	push   %eax
  801b72:	ff 75 0c             	pushl  0xc(%ebp)
  801b75:	ff 75 08             	pushl  0x8(%ebp)
  801b78:	e8 c1 03 00 00       	call   801f3e <sys_getSharedObject>
  801b7d:	83 c4 10             	add    $0x10,%esp
  801b80:	89 45 ec             	mov    %eax,-0x14(%ebp)
			if(ret1>=0)
  801b83:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  801b87:	78 08                	js     801b91 <sget+0x84>
			{
				return (void*)v1->sva;
  801b89:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801b8c:	8b 40 08             	mov    0x8(%eax),%eax
  801b8f:	eb 0c                	jmp    801b9d <sget+0x90>
			}
			else
			{
				return NULL;
  801b91:	b8 00 00 00 00       	mov    $0x0,%eax
  801b96:	eb 05                	jmp    801b9d <sget+0x90>
			}
		}
	}
  return NULL;
  801b98:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801b9d:	c9                   	leave  
  801b9e:	c3                   	ret    

00801b9f <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  801b9f:	55                   	push   %ebp
  801ba0:	89 e5                	mov    %esp,%ebp
  801ba2:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801ba5:	e8 63 fb ff ff       	call   80170d <InitializeUHeap>
	//==============================================================
	// [USER HEAP - USER SIDE] realloc
	// Write your code here, remove the panic and write your code
	panic("realloc() is not implemented yet...!!");
  801baa:	83 ec 04             	sub    $0x4,%esp
  801bad:	68 64 3f 80 00       	push   $0x803f64
  801bb2:	68 0e 01 00 00       	push   $0x10e
  801bb7:	68 33 3f 80 00       	push   $0x803f33
  801bbc:	e8 0e eb ff ff       	call   8006cf <_panic>

00801bc1 <sfree>:
//	use sys_freeSharedObject(...); which switches to the kernel mode,
//	calls freeSharedObject(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the freeSharedObject() function is empty, make sure to implement it.

void sfree(void* virtual_address)
{
  801bc1:	55                   	push   %ebp
  801bc2:	89 e5                	mov    %esp,%ebp
  801bc4:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT MS3 - BONUS] [SHARING - USER SIDE] sfree()

	// Write your code here, remove the panic and write your code
	panic("sfree() is not implemented yet...!!");
  801bc7:	83 ec 04             	sub    $0x4,%esp
  801bca:	68 8c 3f 80 00       	push   $0x803f8c
  801bcf:	68 22 01 00 00       	push   $0x122
  801bd4:	68 33 3f 80 00       	push   $0x803f33
  801bd9:	e8 f1 ea ff ff       	call   8006cf <_panic>

00801bde <expand>:

//==================================================================================//
//========================== MODIFICATION FUNCTIONS ================================//
//==================================================================================//
void expand(uint32 newSize)
{
  801bde:	55                   	push   %ebp
  801bdf:	89 e5                	mov    %esp,%ebp
  801be1:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801be4:	83 ec 04             	sub    $0x4,%esp
  801be7:	68 b0 3f 80 00       	push   $0x803fb0
  801bec:	68 2d 01 00 00       	push   $0x12d
  801bf1:	68 33 3f 80 00       	push   $0x803f33
  801bf6:	e8 d4 ea ff ff       	call   8006cf <_panic>

00801bfb <shrink>:

}
void shrink(uint32 newSize)
{
  801bfb:	55                   	push   %ebp
  801bfc:	89 e5                	mov    %esp,%ebp
  801bfe:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801c01:	83 ec 04             	sub    $0x4,%esp
  801c04:	68 b0 3f 80 00       	push   $0x803fb0
  801c09:	68 32 01 00 00       	push   $0x132
  801c0e:	68 33 3f 80 00       	push   $0x803f33
  801c13:	e8 b7 ea ff ff       	call   8006cf <_panic>

00801c18 <freeHeap>:

}
void freeHeap(void* virtual_address)
{
  801c18:	55                   	push   %ebp
  801c19:	89 e5                	mov    %esp,%ebp
  801c1b:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801c1e:	83 ec 04             	sub    $0x4,%esp
  801c21:	68 b0 3f 80 00       	push   $0x803fb0
  801c26:	68 37 01 00 00       	push   $0x137
  801c2b:	68 33 3f 80 00       	push   $0x803f33
  801c30:	e8 9a ea ff ff       	call   8006cf <_panic>

00801c35 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  801c35:	55                   	push   %ebp
  801c36:	89 e5                	mov    %esp,%ebp
  801c38:	57                   	push   %edi
  801c39:	56                   	push   %esi
  801c3a:	53                   	push   %ebx
  801c3b:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801c3e:	8b 45 08             	mov    0x8(%ebp),%eax
  801c41:	8b 55 0c             	mov    0xc(%ebp),%edx
  801c44:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801c47:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801c4a:	8b 7d 18             	mov    0x18(%ebp),%edi
  801c4d:	8b 75 1c             	mov    0x1c(%ebp),%esi
  801c50:	cd 30                	int    $0x30
  801c52:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  801c55:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801c58:	83 c4 10             	add    $0x10,%esp
  801c5b:	5b                   	pop    %ebx
  801c5c:	5e                   	pop    %esi
  801c5d:	5f                   	pop    %edi
  801c5e:	5d                   	pop    %ebp
  801c5f:	c3                   	ret    

00801c60 <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  801c60:	55                   	push   %ebp
  801c61:	89 e5                	mov    %esp,%ebp
  801c63:	83 ec 04             	sub    $0x4,%esp
  801c66:	8b 45 10             	mov    0x10(%ebp),%eax
  801c69:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  801c6c:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801c70:	8b 45 08             	mov    0x8(%ebp),%eax
  801c73:	6a 00                	push   $0x0
  801c75:	6a 00                	push   $0x0
  801c77:	52                   	push   %edx
  801c78:	ff 75 0c             	pushl  0xc(%ebp)
  801c7b:	50                   	push   %eax
  801c7c:	6a 00                	push   $0x0
  801c7e:	e8 b2 ff ff ff       	call   801c35 <syscall>
  801c83:	83 c4 18             	add    $0x18,%esp
}
  801c86:	90                   	nop
  801c87:	c9                   	leave  
  801c88:	c3                   	ret    

00801c89 <sys_cgetc>:

int
sys_cgetc(void)
{
  801c89:	55                   	push   %ebp
  801c8a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  801c8c:	6a 00                	push   $0x0
  801c8e:	6a 00                	push   $0x0
  801c90:	6a 00                	push   $0x0
  801c92:	6a 00                	push   $0x0
  801c94:	6a 00                	push   $0x0
  801c96:	6a 01                	push   $0x1
  801c98:	e8 98 ff ff ff       	call   801c35 <syscall>
  801c9d:	83 c4 18             	add    $0x18,%esp
}
  801ca0:	c9                   	leave  
  801ca1:	c3                   	ret    

00801ca2 <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  801ca2:	55                   	push   %ebp
  801ca3:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  801ca5:	8b 55 0c             	mov    0xc(%ebp),%edx
  801ca8:	8b 45 08             	mov    0x8(%ebp),%eax
  801cab:	6a 00                	push   $0x0
  801cad:	6a 00                	push   $0x0
  801caf:	6a 00                	push   $0x0
  801cb1:	52                   	push   %edx
  801cb2:	50                   	push   %eax
  801cb3:	6a 05                	push   $0x5
  801cb5:	e8 7b ff ff ff       	call   801c35 <syscall>
  801cba:	83 c4 18             	add    $0x18,%esp
}
  801cbd:	c9                   	leave  
  801cbe:	c3                   	ret    

00801cbf <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  801cbf:	55                   	push   %ebp
  801cc0:	89 e5                	mov    %esp,%ebp
  801cc2:	56                   	push   %esi
  801cc3:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  801cc4:	8b 75 18             	mov    0x18(%ebp),%esi
  801cc7:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801cca:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801ccd:	8b 55 0c             	mov    0xc(%ebp),%edx
  801cd0:	8b 45 08             	mov    0x8(%ebp),%eax
  801cd3:	56                   	push   %esi
  801cd4:	53                   	push   %ebx
  801cd5:	51                   	push   %ecx
  801cd6:	52                   	push   %edx
  801cd7:	50                   	push   %eax
  801cd8:	6a 06                	push   $0x6
  801cda:	e8 56 ff ff ff       	call   801c35 <syscall>
  801cdf:	83 c4 18             	add    $0x18,%esp
}
  801ce2:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801ce5:	5b                   	pop    %ebx
  801ce6:	5e                   	pop    %esi
  801ce7:	5d                   	pop    %ebp
  801ce8:	c3                   	ret    

00801ce9 <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  801ce9:	55                   	push   %ebp
  801cea:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  801cec:	8b 55 0c             	mov    0xc(%ebp),%edx
  801cef:	8b 45 08             	mov    0x8(%ebp),%eax
  801cf2:	6a 00                	push   $0x0
  801cf4:	6a 00                	push   $0x0
  801cf6:	6a 00                	push   $0x0
  801cf8:	52                   	push   %edx
  801cf9:	50                   	push   %eax
  801cfa:	6a 07                	push   $0x7
  801cfc:	e8 34 ff ff ff       	call   801c35 <syscall>
  801d01:	83 c4 18             	add    $0x18,%esp
}
  801d04:	c9                   	leave  
  801d05:	c3                   	ret    

00801d06 <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  801d06:	55                   	push   %ebp
  801d07:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  801d09:	6a 00                	push   $0x0
  801d0b:	6a 00                	push   $0x0
  801d0d:	6a 00                	push   $0x0
  801d0f:	ff 75 0c             	pushl  0xc(%ebp)
  801d12:	ff 75 08             	pushl  0x8(%ebp)
  801d15:	6a 08                	push   $0x8
  801d17:	e8 19 ff ff ff       	call   801c35 <syscall>
  801d1c:	83 c4 18             	add    $0x18,%esp
}
  801d1f:	c9                   	leave  
  801d20:	c3                   	ret    

00801d21 <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  801d21:	55                   	push   %ebp
  801d22:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  801d24:	6a 00                	push   $0x0
  801d26:	6a 00                	push   $0x0
  801d28:	6a 00                	push   $0x0
  801d2a:	6a 00                	push   $0x0
  801d2c:	6a 00                	push   $0x0
  801d2e:	6a 09                	push   $0x9
  801d30:	e8 00 ff ff ff       	call   801c35 <syscall>
  801d35:	83 c4 18             	add    $0x18,%esp
}
  801d38:	c9                   	leave  
  801d39:	c3                   	ret    

00801d3a <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  801d3a:	55                   	push   %ebp
  801d3b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  801d3d:	6a 00                	push   $0x0
  801d3f:	6a 00                	push   $0x0
  801d41:	6a 00                	push   $0x0
  801d43:	6a 00                	push   $0x0
  801d45:	6a 00                	push   $0x0
  801d47:	6a 0a                	push   $0xa
  801d49:	e8 e7 fe ff ff       	call   801c35 <syscall>
  801d4e:	83 c4 18             	add    $0x18,%esp
}
  801d51:	c9                   	leave  
  801d52:	c3                   	ret    

00801d53 <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  801d53:	55                   	push   %ebp
  801d54:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  801d56:	6a 00                	push   $0x0
  801d58:	6a 00                	push   $0x0
  801d5a:	6a 00                	push   $0x0
  801d5c:	6a 00                	push   $0x0
  801d5e:	6a 00                	push   $0x0
  801d60:	6a 0b                	push   $0xb
  801d62:	e8 ce fe ff ff       	call   801c35 <syscall>
  801d67:	83 c4 18             	add    $0x18,%esp
}
  801d6a:	c9                   	leave  
  801d6b:	c3                   	ret    

00801d6c <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  801d6c:	55                   	push   %ebp
  801d6d:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  801d6f:	6a 00                	push   $0x0
  801d71:	6a 00                	push   $0x0
  801d73:	6a 00                	push   $0x0
  801d75:	ff 75 0c             	pushl  0xc(%ebp)
  801d78:	ff 75 08             	pushl  0x8(%ebp)
  801d7b:	6a 0f                	push   $0xf
  801d7d:	e8 b3 fe ff ff       	call   801c35 <syscall>
  801d82:	83 c4 18             	add    $0x18,%esp
	return;
  801d85:	90                   	nop
}
  801d86:	c9                   	leave  
  801d87:	c3                   	ret    

00801d88 <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  801d88:	55                   	push   %ebp
  801d89:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  801d8b:	6a 00                	push   $0x0
  801d8d:	6a 00                	push   $0x0
  801d8f:	6a 00                	push   $0x0
  801d91:	ff 75 0c             	pushl  0xc(%ebp)
  801d94:	ff 75 08             	pushl  0x8(%ebp)
  801d97:	6a 10                	push   $0x10
  801d99:	e8 97 fe ff ff       	call   801c35 <syscall>
  801d9e:	83 c4 18             	add    $0x18,%esp
	return ;
  801da1:	90                   	nop
}
  801da2:	c9                   	leave  
  801da3:	c3                   	ret    

00801da4 <sys_allocate_chunk>:

void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  801da4:	55                   	push   %ebp
  801da5:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  801da7:	6a 00                	push   $0x0
  801da9:	6a 00                	push   $0x0
  801dab:	ff 75 10             	pushl  0x10(%ebp)
  801dae:	ff 75 0c             	pushl  0xc(%ebp)
  801db1:	ff 75 08             	pushl  0x8(%ebp)
  801db4:	6a 11                	push   $0x11
  801db6:	e8 7a fe ff ff       	call   801c35 <syscall>
  801dbb:	83 c4 18             	add    $0x18,%esp
	return ;
  801dbe:	90                   	nop
}
  801dbf:	c9                   	leave  
  801dc0:	c3                   	ret    

00801dc1 <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  801dc1:	55                   	push   %ebp
  801dc2:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  801dc4:	6a 00                	push   $0x0
  801dc6:	6a 00                	push   $0x0
  801dc8:	6a 00                	push   $0x0
  801dca:	6a 00                	push   $0x0
  801dcc:	6a 00                	push   $0x0
  801dce:	6a 0c                	push   $0xc
  801dd0:	e8 60 fe ff ff       	call   801c35 <syscall>
  801dd5:	83 c4 18             	add    $0x18,%esp
}
  801dd8:	c9                   	leave  
  801dd9:	c3                   	ret    

00801dda <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  801dda:	55                   	push   %ebp
  801ddb:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  801ddd:	6a 00                	push   $0x0
  801ddf:	6a 00                	push   $0x0
  801de1:	6a 00                	push   $0x0
  801de3:	6a 00                	push   $0x0
  801de5:	ff 75 08             	pushl  0x8(%ebp)
  801de8:	6a 0d                	push   $0xd
  801dea:	e8 46 fe ff ff       	call   801c35 <syscall>
  801def:	83 c4 18             	add    $0x18,%esp
}
  801df2:	c9                   	leave  
  801df3:	c3                   	ret    

00801df4 <sys_scarce_memory>:

void sys_scarce_memory()
{
  801df4:	55                   	push   %ebp
  801df5:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  801df7:	6a 00                	push   $0x0
  801df9:	6a 00                	push   $0x0
  801dfb:	6a 00                	push   $0x0
  801dfd:	6a 00                	push   $0x0
  801dff:	6a 00                	push   $0x0
  801e01:	6a 0e                	push   $0xe
  801e03:	e8 2d fe ff ff       	call   801c35 <syscall>
  801e08:	83 c4 18             	add    $0x18,%esp
}
  801e0b:	90                   	nop
  801e0c:	c9                   	leave  
  801e0d:	c3                   	ret    

00801e0e <sys_disable_interrupt>:

//NEW !! 2012...
void
sys_disable_interrupt()
{
  801e0e:	55                   	push   %ebp
  801e0f:	89 e5                	mov    %esp,%ebp
	syscall(SYS_disableINTR,0, 0, 0, 0, 0);
  801e11:	6a 00                	push   $0x0
  801e13:	6a 00                	push   $0x0
  801e15:	6a 00                	push   $0x0
  801e17:	6a 00                	push   $0x0
  801e19:	6a 00                	push   $0x0
  801e1b:	6a 13                	push   $0x13
  801e1d:	e8 13 fe ff ff       	call   801c35 <syscall>
  801e22:	83 c4 18             	add    $0x18,%esp
}
  801e25:	90                   	nop
  801e26:	c9                   	leave  
  801e27:	c3                   	ret    

00801e28 <sys_enable_interrupt>:


void
sys_enable_interrupt()
{
  801e28:	55                   	push   %ebp
  801e29:	89 e5                	mov    %esp,%ebp
	syscall(SYS_enableINTR,0, 0, 0, 0, 0);
  801e2b:	6a 00                	push   $0x0
  801e2d:	6a 00                	push   $0x0
  801e2f:	6a 00                	push   $0x0
  801e31:	6a 00                	push   $0x0
  801e33:	6a 00                	push   $0x0
  801e35:	6a 14                	push   $0x14
  801e37:	e8 f9 fd ff ff       	call   801c35 <syscall>
  801e3c:	83 c4 18             	add    $0x18,%esp
}
  801e3f:	90                   	nop
  801e40:	c9                   	leave  
  801e41:	c3                   	ret    

00801e42 <sys_cputc>:


void
sys_cputc(const char c)
{
  801e42:	55                   	push   %ebp
  801e43:	89 e5                	mov    %esp,%ebp
  801e45:	83 ec 04             	sub    $0x4,%esp
  801e48:	8b 45 08             	mov    0x8(%ebp),%eax
  801e4b:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  801e4e:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801e52:	6a 00                	push   $0x0
  801e54:	6a 00                	push   $0x0
  801e56:	6a 00                	push   $0x0
  801e58:	6a 00                	push   $0x0
  801e5a:	50                   	push   %eax
  801e5b:	6a 15                	push   $0x15
  801e5d:	e8 d3 fd ff ff       	call   801c35 <syscall>
  801e62:	83 c4 18             	add    $0x18,%esp
}
  801e65:	90                   	nop
  801e66:	c9                   	leave  
  801e67:	c3                   	ret    

00801e68 <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  801e68:	55                   	push   %ebp
  801e69:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  801e6b:	6a 00                	push   $0x0
  801e6d:	6a 00                	push   $0x0
  801e6f:	6a 00                	push   $0x0
  801e71:	6a 00                	push   $0x0
  801e73:	6a 00                	push   $0x0
  801e75:	6a 16                	push   $0x16
  801e77:	e8 b9 fd ff ff       	call   801c35 <syscall>
  801e7c:	83 c4 18             	add    $0x18,%esp
}
  801e7f:	90                   	nop
  801e80:	c9                   	leave  
  801e81:	c3                   	ret    

00801e82 <sys_createSemaphore>:

int
sys_createSemaphore(char* semaphoreName, uint32 initialValue)
{
  801e82:	55                   	push   %ebp
  801e83:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_semaphore,(uint32)semaphoreName, (uint32)initialValue, 0, 0, 0);
  801e85:	8b 45 08             	mov    0x8(%ebp),%eax
  801e88:	6a 00                	push   $0x0
  801e8a:	6a 00                	push   $0x0
  801e8c:	6a 00                	push   $0x0
  801e8e:	ff 75 0c             	pushl  0xc(%ebp)
  801e91:	50                   	push   %eax
  801e92:	6a 17                	push   $0x17
  801e94:	e8 9c fd ff ff       	call   801c35 <syscall>
  801e99:	83 c4 18             	add    $0x18,%esp
}
  801e9c:	c9                   	leave  
  801e9d:	c3                   	ret    

00801e9e <sys_getSemaphoreValue>:

int
sys_getSemaphoreValue(int32 ownerEnvID, char* semaphoreName)
{
  801e9e:	55                   	push   %ebp
  801e9f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_semaphore_value,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801ea1:	8b 55 0c             	mov    0xc(%ebp),%edx
  801ea4:	8b 45 08             	mov    0x8(%ebp),%eax
  801ea7:	6a 00                	push   $0x0
  801ea9:	6a 00                	push   $0x0
  801eab:	6a 00                	push   $0x0
  801ead:	52                   	push   %edx
  801eae:	50                   	push   %eax
  801eaf:	6a 1a                	push   $0x1a
  801eb1:	e8 7f fd ff ff       	call   801c35 <syscall>
  801eb6:	83 c4 18             	add    $0x18,%esp
}
  801eb9:	c9                   	leave  
  801eba:	c3                   	ret    

00801ebb <sys_waitSemaphore>:

void
sys_waitSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  801ebb:	55                   	push   %ebp
  801ebc:	89 e5                	mov    %esp,%ebp
	syscall(SYS_wait_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801ebe:	8b 55 0c             	mov    0xc(%ebp),%edx
  801ec1:	8b 45 08             	mov    0x8(%ebp),%eax
  801ec4:	6a 00                	push   $0x0
  801ec6:	6a 00                	push   $0x0
  801ec8:	6a 00                	push   $0x0
  801eca:	52                   	push   %edx
  801ecb:	50                   	push   %eax
  801ecc:	6a 18                	push   $0x18
  801ece:	e8 62 fd ff ff       	call   801c35 <syscall>
  801ed3:	83 c4 18             	add    $0x18,%esp
}
  801ed6:	90                   	nop
  801ed7:	c9                   	leave  
  801ed8:	c3                   	ret    

00801ed9 <sys_signalSemaphore>:

void
sys_signalSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  801ed9:	55                   	push   %ebp
  801eda:	89 e5                	mov    %esp,%ebp
	syscall(SYS_signal_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801edc:	8b 55 0c             	mov    0xc(%ebp),%edx
  801edf:	8b 45 08             	mov    0x8(%ebp),%eax
  801ee2:	6a 00                	push   $0x0
  801ee4:	6a 00                	push   $0x0
  801ee6:	6a 00                	push   $0x0
  801ee8:	52                   	push   %edx
  801ee9:	50                   	push   %eax
  801eea:	6a 19                	push   $0x19
  801eec:	e8 44 fd ff ff       	call   801c35 <syscall>
  801ef1:	83 c4 18             	add    $0x18,%esp
}
  801ef4:	90                   	nop
  801ef5:	c9                   	leave  
  801ef6:	c3                   	ret    

00801ef7 <sys_createSharedObject>:

int
sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  801ef7:	55                   	push   %ebp
  801ef8:	89 e5                	mov    %esp,%ebp
  801efa:	83 ec 04             	sub    $0x4,%esp
  801efd:	8b 45 10             	mov    0x10(%ebp),%eax
  801f00:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  801f03:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801f06:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801f0a:	8b 45 08             	mov    0x8(%ebp),%eax
  801f0d:	6a 00                	push   $0x0
  801f0f:	51                   	push   %ecx
  801f10:	52                   	push   %edx
  801f11:	ff 75 0c             	pushl  0xc(%ebp)
  801f14:	50                   	push   %eax
  801f15:	6a 1b                	push   $0x1b
  801f17:	e8 19 fd ff ff       	call   801c35 <syscall>
  801f1c:	83 c4 18             	add    $0x18,%esp
}
  801f1f:	c9                   	leave  
  801f20:	c3                   	ret    

00801f21 <sys_getSizeOfSharedObject>:

//2017:
int
sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  801f21:	55                   	push   %ebp
  801f22:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  801f24:	8b 55 0c             	mov    0xc(%ebp),%edx
  801f27:	8b 45 08             	mov    0x8(%ebp),%eax
  801f2a:	6a 00                	push   $0x0
  801f2c:	6a 00                	push   $0x0
  801f2e:	6a 00                	push   $0x0
  801f30:	52                   	push   %edx
  801f31:	50                   	push   %eax
  801f32:	6a 1c                	push   $0x1c
  801f34:	e8 fc fc ff ff       	call   801c35 <syscall>
  801f39:	83 c4 18             	add    $0x18,%esp
}
  801f3c:	c9                   	leave  
  801f3d:	c3                   	ret    

00801f3e <sys_getSharedObject>:
//==========

int
sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  801f3e:	55                   	push   %ebp
  801f3f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  801f41:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801f44:	8b 55 0c             	mov    0xc(%ebp),%edx
  801f47:	8b 45 08             	mov    0x8(%ebp),%eax
  801f4a:	6a 00                	push   $0x0
  801f4c:	6a 00                	push   $0x0
  801f4e:	51                   	push   %ecx
  801f4f:	52                   	push   %edx
  801f50:	50                   	push   %eax
  801f51:	6a 1d                	push   $0x1d
  801f53:	e8 dd fc ff ff       	call   801c35 <syscall>
  801f58:	83 c4 18             	add    $0x18,%esp
}
  801f5b:	c9                   	leave  
  801f5c:	c3                   	ret    

00801f5d <sys_freeSharedObject>:

int
sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  801f5d:	55                   	push   %ebp
  801f5e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  801f60:	8b 55 0c             	mov    0xc(%ebp),%edx
  801f63:	8b 45 08             	mov    0x8(%ebp),%eax
  801f66:	6a 00                	push   $0x0
  801f68:	6a 00                	push   $0x0
  801f6a:	6a 00                	push   $0x0
  801f6c:	52                   	push   %edx
  801f6d:	50                   	push   %eax
  801f6e:	6a 1e                	push   $0x1e
  801f70:	e8 c0 fc ff ff       	call   801c35 <syscall>
  801f75:	83 c4 18             	add    $0x18,%esp
}
  801f78:	c9                   	leave  
  801f79:	c3                   	ret    

00801f7a <sys_getMaxShares>:

uint32 	sys_getMaxShares()
{
  801f7a:	55                   	push   %ebp
  801f7b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_max_shares,0, 0, 0, 0, 0);
  801f7d:	6a 00                	push   $0x0
  801f7f:	6a 00                	push   $0x0
  801f81:	6a 00                	push   $0x0
  801f83:	6a 00                	push   $0x0
  801f85:	6a 00                	push   $0x0
  801f87:	6a 1f                	push   $0x1f
  801f89:	e8 a7 fc ff ff       	call   801c35 <syscall>
  801f8e:	83 c4 18             	add    $0x18,%esp
}
  801f91:	c9                   	leave  
  801f92:	c3                   	ret    

00801f93 <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  801f93:	55                   	push   %ebp
  801f94:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  801f96:	8b 45 08             	mov    0x8(%ebp),%eax
  801f99:	6a 00                	push   $0x0
  801f9b:	ff 75 14             	pushl  0x14(%ebp)
  801f9e:	ff 75 10             	pushl  0x10(%ebp)
  801fa1:	ff 75 0c             	pushl  0xc(%ebp)
  801fa4:	50                   	push   %eax
  801fa5:	6a 20                	push   $0x20
  801fa7:	e8 89 fc ff ff       	call   801c35 <syscall>
  801fac:	83 c4 18             	add    $0x18,%esp
}
  801faf:	c9                   	leave  
  801fb0:	c3                   	ret    

00801fb1 <sys_run_env>:

void
sys_run_env(int32 envId)
{
  801fb1:	55                   	push   %ebp
  801fb2:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  801fb4:	8b 45 08             	mov    0x8(%ebp),%eax
  801fb7:	6a 00                	push   $0x0
  801fb9:	6a 00                	push   $0x0
  801fbb:	6a 00                	push   $0x0
  801fbd:	6a 00                	push   $0x0
  801fbf:	50                   	push   %eax
  801fc0:	6a 21                	push   $0x21
  801fc2:	e8 6e fc ff ff       	call   801c35 <syscall>
  801fc7:	83 c4 18             	add    $0x18,%esp
}
  801fca:	90                   	nop
  801fcb:	c9                   	leave  
  801fcc:	c3                   	ret    

00801fcd <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  801fcd:	55                   	push   %ebp
  801fce:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  801fd0:	8b 45 08             	mov    0x8(%ebp),%eax
  801fd3:	6a 00                	push   $0x0
  801fd5:	6a 00                	push   $0x0
  801fd7:	6a 00                	push   $0x0
  801fd9:	6a 00                	push   $0x0
  801fdb:	50                   	push   %eax
  801fdc:	6a 22                	push   $0x22
  801fde:	e8 52 fc ff ff       	call   801c35 <syscall>
  801fe3:	83 c4 18             	add    $0x18,%esp
}
  801fe6:	c9                   	leave  
  801fe7:	c3                   	ret    

00801fe8 <sys_getenvid>:

int32 sys_getenvid(void)
{
  801fe8:	55                   	push   %ebp
  801fe9:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  801feb:	6a 00                	push   $0x0
  801fed:	6a 00                	push   $0x0
  801fef:	6a 00                	push   $0x0
  801ff1:	6a 00                	push   $0x0
  801ff3:	6a 00                	push   $0x0
  801ff5:	6a 02                	push   $0x2
  801ff7:	e8 39 fc ff ff       	call   801c35 <syscall>
  801ffc:	83 c4 18             	add    $0x18,%esp
}
  801fff:	c9                   	leave  
  802000:	c3                   	ret    

00802001 <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  802001:	55                   	push   %ebp
  802002:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  802004:	6a 00                	push   $0x0
  802006:	6a 00                	push   $0x0
  802008:	6a 00                	push   $0x0
  80200a:	6a 00                	push   $0x0
  80200c:	6a 00                	push   $0x0
  80200e:	6a 03                	push   $0x3
  802010:	e8 20 fc ff ff       	call   801c35 <syscall>
  802015:	83 c4 18             	add    $0x18,%esp
}
  802018:	c9                   	leave  
  802019:	c3                   	ret    

0080201a <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  80201a:	55                   	push   %ebp
  80201b:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  80201d:	6a 00                	push   $0x0
  80201f:	6a 00                	push   $0x0
  802021:	6a 00                	push   $0x0
  802023:	6a 00                	push   $0x0
  802025:	6a 00                	push   $0x0
  802027:	6a 04                	push   $0x4
  802029:	e8 07 fc ff ff       	call   801c35 <syscall>
  80202e:	83 c4 18             	add    $0x18,%esp
}
  802031:	c9                   	leave  
  802032:	c3                   	ret    

00802033 <sys_exit_env>:


void sys_exit_env(void)
{
  802033:	55                   	push   %ebp
  802034:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  802036:	6a 00                	push   $0x0
  802038:	6a 00                	push   $0x0
  80203a:	6a 00                	push   $0x0
  80203c:	6a 00                	push   $0x0
  80203e:	6a 00                	push   $0x0
  802040:	6a 23                	push   $0x23
  802042:	e8 ee fb ff ff       	call   801c35 <syscall>
  802047:	83 c4 18             	add    $0x18,%esp
}
  80204a:	90                   	nop
  80204b:	c9                   	leave  
  80204c:	c3                   	ret    

0080204d <sys_get_virtual_time>:


struct uint64
sys_get_virtual_time()
{
  80204d:	55                   	push   %ebp
  80204e:	89 e5                	mov    %esp,%ebp
  802050:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  802053:	8d 45 f8             	lea    -0x8(%ebp),%eax
  802056:	8d 50 04             	lea    0x4(%eax),%edx
  802059:	8d 45 f8             	lea    -0x8(%ebp),%eax
  80205c:	6a 00                	push   $0x0
  80205e:	6a 00                	push   $0x0
  802060:	6a 00                	push   $0x0
  802062:	52                   	push   %edx
  802063:	50                   	push   %eax
  802064:	6a 24                	push   $0x24
  802066:	e8 ca fb ff ff       	call   801c35 <syscall>
  80206b:	83 c4 18             	add    $0x18,%esp
	return result;
  80206e:	8b 4d 08             	mov    0x8(%ebp),%ecx
  802071:	8b 45 f8             	mov    -0x8(%ebp),%eax
  802074:	8b 55 fc             	mov    -0x4(%ebp),%edx
  802077:	89 01                	mov    %eax,(%ecx)
  802079:	89 51 04             	mov    %edx,0x4(%ecx)
}
  80207c:	8b 45 08             	mov    0x8(%ebp),%eax
  80207f:	c9                   	leave  
  802080:	c2 04 00             	ret    $0x4

00802083 <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  802083:	55                   	push   %ebp
  802084:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  802086:	6a 00                	push   $0x0
  802088:	6a 00                	push   $0x0
  80208a:	ff 75 10             	pushl  0x10(%ebp)
  80208d:	ff 75 0c             	pushl  0xc(%ebp)
  802090:	ff 75 08             	pushl  0x8(%ebp)
  802093:	6a 12                	push   $0x12
  802095:	e8 9b fb ff ff       	call   801c35 <syscall>
  80209a:	83 c4 18             	add    $0x18,%esp
	return ;
  80209d:	90                   	nop
}
  80209e:	c9                   	leave  
  80209f:	c3                   	ret    

008020a0 <sys_rcr2>:
uint32 sys_rcr2()
{
  8020a0:	55                   	push   %ebp
  8020a1:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  8020a3:	6a 00                	push   $0x0
  8020a5:	6a 00                	push   $0x0
  8020a7:	6a 00                	push   $0x0
  8020a9:	6a 00                	push   $0x0
  8020ab:	6a 00                	push   $0x0
  8020ad:	6a 25                	push   $0x25
  8020af:	e8 81 fb ff ff       	call   801c35 <syscall>
  8020b4:	83 c4 18             	add    $0x18,%esp
}
  8020b7:	c9                   	leave  
  8020b8:	c3                   	ret    

008020b9 <sys_bypassPageFault>:
void sys_bypassPageFault(uint8 instrLength)
{
  8020b9:	55                   	push   %ebp
  8020ba:	89 e5                	mov    %esp,%ebp
  8020bc:	83 ec 04             	sub    $0x4,%esp
  8020bf:	8b 45 08             	mov    0x8(%ebp),%eax
  8020c2:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  8020c5:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  8020c9:	6a 00                	push   $0x0
  8020cb:	6a 00                	push   $0x0
  8020cd:	6a 00                	push   $0x0
  8020cf:	6a 00                	push   $0x0
  8020d1:	50                   	push   %eax
  8020d2:	6a 26                	push   $0x26
  8020d4:	e8 5c fb ff ff       	call   801c35 <syscall>
  8020d9:	83 c4 18             	add    $0x18,%esp
	return ;
  8020dc:	90                   	nop
}
  8020dd:	c9                   	leave  
  8020de:	c3                   	ret    

008020df <rsttst>:
void rsttst()
{
  8020df:	55                   	push   %ebp
  8020e0:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  8020e2:	6a 00                	push   $0x0
  8020e4:	6a 00                	push   $0x0
  8020e6:	6a 00                	push   $0x0
  8020e8:	6a 00                	push   $0x0
  8020ea:	6a 00                	push   $0x0
  8020ec:	6a 28                	push   $0x28
  8020ee:	e8 42 fb ff ff       	call   801c35 <syscall>
  8020f3:	83 c4 18             	add    $0x18,%esp
	return ;
  8020f6:	90                   	nop
}
  8020f7:	c9                   	leave  
  8020f8:	c3                   	ret    

008020f9 <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  8020f9:	55                   	push   %ebp
  8020fa:	89 e5                	mov    %esp,%ebp
  8020fc:	83 ec 04             	sub    $0x4,%esp
  8020ff:	8b 45 14             	mov    0x14(%ebp),%eax
  802102:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  802105:	8b 55 18             	mov    0x18(%ebp),%edx
  802108:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  80210c:	52                   	push   %edx
  80210d:	50                   	push   %eax
  80210e:	ff 75 10             	pushl  0x10(%ebp)
  802111:	ff 75 0c             	pushl  0xc(%ebp)
  802114:	ff 75 08             	pushl  0x8(%ebp)
  802117:	6a 27                	push   $0x27
  802119:	e8 17 fb ff ff       	call   801c35 <syscall>
  80211e:	83 c4 18             	add    $0x18,%esp
	return ;
  802121:	90                   	nop
}
  802122:	c9                   	leave  
  802123:	c3                   	ret    

00802124 <chktst>:
void chktst(uint32 n)
{
  802124:	55                   	push   %ebp
  802125:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  802127:	6a 00                	push   $0x0
  802129:	6a 00                	push   $0x0
  80212b:	6a 00                	push   $0x0
  80212d:	6a 00                	push   $0x0
  80212f:	ff 75 08             	pushl  0x8(%ebp)
  802132:	6a 29                	push   $0x29
  802134:	e8 fc fa ff ff       	call   801c35 <syscall>
  802139:	83 c4 18             	add    $0x18,%esp
	return ;
  80213c:	90                   	nop
}
  80213d:	c9                   	leave  
  80213e:	c3                   	ret    

0080213f <inctst>:

void inctst()
{
  80213f:	55                   	push   %ebp
  802140:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  802142:	6a 00                	push   $0x0
  802144:	6a 00                	push   $0x0
  802146:	6a 00                	push   $0x0
  802148:	6a 00                	push   $0x0
  80214a:	6a 00                	push   $0x0
  80214c:	6a 2a                	push   $0x2a
  80214e:	e8 e2 fa ff ff       	call   801c35 <syscall>
  802153:	83 c4 18             	add    $0x18,%esp
	return ;
  802156:	90                   	nop
}
  802157:	c9                   	leave  
  802158:	c3                   	ret    

00802159 <gettst>:
uint32 gettst()
{
  802159:	55                   	push   %ebp
  80215a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  80215c:	6a 00                	push   $0x0
  80215e:	6a 00                	push   $0x0
  802160:	6a 00                	push   $0x0
  802162:	6a 00                	push   $0x0
  802164:	6a 00                	push   $0x0
  802166:	6a 2b                	push   $0x2b
  802168:	e8 c8 fa ff ff       	call   801c35 <syscall>
  80216d:	83 c4 18             	add    $0x18,%esp
}
  802170:	c9                   	leave  
  802171:	c3                   	ret    

00802172 <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  802172:	55                   	push   %ebp
  802173:	89 e5                	mov    %esp,%ebp
  802175:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  802178:	6a 00                	push   $0x0
  80217a:	6a 00                	push   $0x0
  80217c:	6a 00                	push   $0x0
  80217e:	6a 00                	push   $0x0
  802180:	6a 00                	push   $0x0
  802182:	6a 2c                	push   $0x2c
  802184:	e8 ac fa ff ff       	call   801c35 <syscall>
  802189:	83 c4 18             	add    $0x18,%esp
  80218c:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  80218f:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  802193:	75 07                	jne    80219c <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  802195:	b8 01 00 00 00       	mov    $0x1,%eax
  80219a:	eb 05                	jmp    8021a1 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  80219c:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8021a1:	c9                   	leave  
  8021a2:	c3                   	ret    

008021a3 <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  8021a3:	55                   	push   %ebp
  8021a4:	89 e5                	mov    %esp,%ebp
  8021a6:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8021a9:	6a 00                	push   $0x0
  8021ab:	6a 00                	push   $0x0
  8021ad:	6a 00                	push   $0x0
  8021af:	6a 00                	push   $0x0
  8021b1:	6a 00                	push   $0x0
  8021b3:	6a 2c                	push   $0x2c
  8021b5:	e8 7b fa ff ff       	call   801c35 <syscall>
  8021ba:	83 c4 18             	add    $0x18,%esp
  8021bd:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  8021c0:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  8021c4:	75 07                	jne    8021cd <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  8021c6:	b8 01 00 00 00       	mov    $0x1,%eax
  8021cb:	eb 05                	jmp    8021d2 <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  8021cd:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8021d2:	c9                   	leave  
  8021d3:	c3                   	ret    

008021d4 <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  8021d4:	55                   	push   %ebp
  8021d5:	89 e5                	mov    %esp,%ebp
  8021d7:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8021da:	6a 00                	push   $0x0
  8021dc:	6a 00                	push   $0x0
  8021de:	6a 00                	push   $0x0
  8021e0:	6a 00                	push   $0x0
  8021e2:	6a 00                	push   $0x0
  8021e4:	6a 2c                	push   $0x2c
  8021e6:	e8 4a fa ff ff       	call   801c35 <syscall>
  8021eb:	83 c4 18             	add    $0x18,%esp
  8021ee:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  8021f1:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  8021f5:	75 07                	jne    8021fe <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  8021f7:	b8 01 00 00 00       	mov    $0x1,%eax
  8021fc:	eb 05                	jmp    802203 <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  8021fe:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802203:	c9                   	leave  
  802204:	c3                   	ret    

00802205 <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  802205:	55                   	push   %ebp
  802206:	89 e5                	mov    %esp,%ebp
  802208:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  80220b:	6a 00                	push   $0x0
  80220d:	6a 00                	push   $0x0
  80220f:	6a 00                	push   $0x0
  802211:	6a 00                	push   $0x0
  802213:	6a 00                	push   $0x0
  802215:	6a 2c                	push   $0x2c
  802217:	e8 19 fa ff ff       	call   801c35 <syscall>
  80221c:	83 c4 18             	add    $0x18,%esp
  80221f:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  802222:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  802226:	75 07                	jne    80222f <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  802228:	b8 01 00 00 00       	mov    $0x1,%eax
  80222d:	eb 05                	jmp    802234 <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  80222f:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802234:	c9                   	leave  
  802235:	c3                   	ret    

00802236 <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  802236:	55                   	push   %ebp
  802237:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  802239:	6a 00                	push   $0x0
  80223b:	6a 00                	push   $0x0
  80223d:	6a 00                	push   $0x0
  80223f:	6a 00                	push   $0x0
  802241:	ff 75 08             	pushl  0x8(%ebp)
  802244:	6a 2d                	push   $0x2d
  802246:	e8 ea f9 ff ff       	call   801c35 <syscall>
  80224b:	83 c4 18             	add    $0x18,%esp
	return ;
  80224e:	90                   	nop
}
  80224f:	c9                   	leave  
  802250:	c3                   	ret    

00802251 <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  802251:	55                   	push   %ebp
  802252:	89 e5                	mov    %esp,%ebp
  802254:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  802255:	8b 5d 14             	mov    0x14(%ebp),%ebx
  802258:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80225b:	8b 55 0c             	mov    0xc(%ebp),%edx
  80225e:	8b 45 08             	mov    0x8(%ebp),%eax
  802261:	6a 00                	push   $0x0
  802263:	53                   	push   %ebx
  802264:	51                   	push   %ecx
  802265:	52                   	push   %edx
  802266:	50                   	push   %eax
  802267:	6a 2e                	push   $0x2e
  802269:	e8 c7 f9 ff ff       	call   801c35 <syscall>
  80226e:	83 c4 18             	add    $0x18,%esp
}
  802271:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  802274:	c9                   	leave  
  802275:	c3                   	ret    

00802276 <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  802276:	55                   	push   %ebp
  802277:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  802279:	8b 55 0c             	mov    0xc(%ebp),%edx
  80227c:	8b 45 08             	mov    0x8(%ebp),%eax
  80227f:	6a 00                	push   $0x0
  802281:	6a 00                	push   $0x0
  802283:	6a 00                	push   $0x0
  802285:	52                   	push   %edx
  802286:	50                   	push   %eax
  802287:	6a 2f                	push   $0x2f
  802289:	e8 a7 f9 ff ff       	call   801c35 <syscall>
  80228e:	83 c4 18             	add    $0x18,%esp
}
  802291:	c9                   	leave  
  802292:	c3                   	ret    

00802293 <print_mem_block_lists>:
//===========================
// PRINT MEM BLOCK LISTS:
//===========================

void print_mem_block_lists()
{
  802293:	55                   	push   %ebp
  802294:	89 e5                	mov    %esp,%ebp
  802296:	83 ec 18             	sub    $0x18,%esp
	cprintf("\n=========================================\n");
  802299:	83 ec 0c             	sub    $0xc,%esp
  80229c:	68 c0 3f 80 00       	push   $0x803fc0
  8022a1:	e8 dd e6 ff ff       	call   800983 <cprintf>
  8022a6:	83 c4 10             	add    $0x10,%esp
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
  8022a9:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nFreeMemBlocksList:\n");
  8022b0:	83 ec 0c             	sub    $0xc,%esp
  8022b3:	68 ec 3f 80 00       	push   $0x803fec
  8022b8:	e8 c6 e6 ff ff       	call   800983 <cprintf>
  8022bd:	83 c4 10             	add    $0x10,%esp
	uint8 sorted = 1 ;
  8022c0:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &FreeMemBlocksList)
  8022c4:	a1 38 51 80 00       	mov    0x805138,%eax
  8022c9:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8022cc:	eb 56                	jmp    802324 <print_mem_block_lists+0x91>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  8022ce:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8022d2:	74 1c                	je     8022f0 <print_mem_block_lists+0x5d>
  8022d4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022d7:	8b 50 08             	mov    0x8(%eax),%edx
  8022da:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8022dd:	8b 48 08             	mov    0x8(%eax),%ecx
  8022e0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8022e3:	8b 40 0c             	mov    0xc(%eax),%eax
  8022e6:	01 c8                	add    %ecx,%eax
  8022e8:	39 c2                	cmp    %eax,%edx
  8022ea:	73 04                	jae    8022f0 <print_mem_block_lists+0x5d>
			sorted = 0 ;
  8022ec:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  8022f0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022f3:	8b 50 08             	mov    0x8(%eax),%edx
  8022f6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022f9:	8b 40 0c             	mov    0xc(%eax),%eax
  8022fc:	01 c2                	add    %eax,%edx
  8022fe:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802301:	8b 40 08             	mov    0x8(%eax),%eax
  802304:	83 ec 04             	sub    $0x4,%esp
  802307:	52                   	push   %edx
  802308:	50                   	push   %eax
  802309:	68 01 40 80 00       	push   $0x804001
  80230e:	e8 70 e6 ff ff       	call   800983 <cprintf>
  802313:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  802316:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802319:	89 45 f0             	mov    %eax,-0x10(%ebp)
	cprintf("\n=========================================\n");
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
	cprintf("\nFreeMemBlocksList:\n");
	uint8 sorted = 1 ;
	LIST_FOREACH(blk, &FreeMemBlocksList)
  80231c:	a1 40 51 80 00       	mov    0x805140,%eax
  802321:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802324:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802328:	74 07                	je     802331 <print_mem_block_lists+0x9e>
  80232a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80232d:	8b 00                	mov    (%eax),%eax
  80232f:	eb 05                	jmp    802336 <print_mem_block_lists+0xa3>
  802331:	b8 00 00 00 00       	mov    $0x0,%eax
  802336:	a3 40 51 80 00       	mov    %eax,0x805140
  80233b:	a1 40 51 80 00       	mov    0x805140,%eax
  802340:	85 c0                	test   %eax,%eax
  802342:	75 8a                	jne    8022ce <print_mem_block_lists+0x3b>
  802344:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802348:	75 84                	jne    8022ce <print_mem_block_lists+0x3b>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;
  80234a:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  80234e:	75 10                	jne    802360 <print_mem_block_lists+0xcd>
  802350:	83 ec 0c             	sub    $0xc,%esp
  802353:	68 10 40 80 00       	push   $0x804010
  802358:	e8 26 e6 ff ff       	call   800983 <cprintf>
  80235d:	83 c4 10             	add    $0x10,%esp

	lastBlk = NULL ;
  802360:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nAllocMemBlocksList:\n");
  802367:	83 ec 0c             	sub    $0xc,%esp
  80236a:	68 34 40 80 00       	push   $0x804034
  80236f:	e8 0f e6 ff ff       	call   800983 <cprintf>
  802374:	83 c4 10             	add    $0x10,%esp
	sorted = 1 ;
  802377:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &AllocMemBlocksList)
  80237b:	a1 40 50 80 00       	mov    0x805040,%eax
  802380:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802383:	eb 56                	jmp    8023db <print_mem_block_lists+0x148>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  802385:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802389:	74 1c                	je     8023a7 <print_mem_block_lists+0x114>
  80238b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80238e:	8b 50 08             	mov    0x8(%eax),%edx
  802391:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802394:	8b 48 08             	mov    0x8(%eax),%ecx
  802397:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80239a:	8b 40 0c             	mov    0xc(%eax),%eax
  80239d:	01 c8                	add    %ecx,%eax
  80239f:	39 c2                	cmp    %eax,%edx
  8023a1:	73 04                	jae    8023a7 <print_mem_block_lists+0x114>
			sorted = 0 ;
  8023a3:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  8023a7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023aa:	8b 50 08             	mov    0x8(%eax),%edx
  8023ad:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023b0:	8b 40 0c             	mov    0xc(%eax),%eax
  8023b3:	01 c2                	add    %eax,%edx
  8023b5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023b8:	8b 40 08             	mov    0x8(%eax),%eax
  8023bb:	83 ec 04             	sub    $0x4,%esp
  8023be:	52                   	push   %edx
  8023bf:	50                   	push   %eax
  8023c0:	68 01 40 80 00       	push   $0x804001
  8023c5:	e8 b9 e5 ff ff       	call   800983 <cprintf>
  8023ca:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  8023cd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023d0:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;

	lastBlk = NULL ;
	cprintf("\nAllocMemBlocksList:\n");
	sorted = 1 ;
	LIST_FOREACH(blk, &AllocMemBlocksList)
  8023d3:	a1 48 50 80 00       	mov    0x805048,%eax
  8023d8:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8023db:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8023df:	74 07                	je     8023e8 <print_mem_block_lists+0x155>
  8023e1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023e4:	8b 00                	mov    (%eax),%eax
  8023e6:	eb 05                	jmp    8023ed <print_mem_block_lists+0x15a>
  8023e8:	b8 00 00 00 00       	mov    $0x0,%eax
  8023ed:	a3 48 50 80 00       	mov    %eax,0x805048
  8023f2:	a1 48 50 80 00       	mov    0x805048,%eax
  8023f7:	85 c0                	test   %eax,%eax
  8023f9:	75 8a                	jne    802385 <print_mem_block_lists+0xf2>
  8023fb:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8023ff:	75 84                	jne    802385 <print_mem_block_lists+0xf2>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nAllocMemBlocksList is NOT SORTED!!\n") ;
  802401:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  802405:	75 10                	jne    802417 <print_mem_block_lists+0x184>
  802407:	83 ec 0c             	sub    $0xc,%esp
  80240a:	68 4c 40 80 00       	push   $0x80404c
  80240f:	e8 6f e5 ff ff       	call   800983 <cprintf>
  802414:	83 c4 10             	add    $0x10,%esp
	cprintf("\n=========================================\n");
  802417:	83 ec 0c             	sub    $0xc,%esp
  80241a:	68 c0 3f 80 00       	push   $0x803fc0
  80241f:	e8 5f e5 ff ff       	call   800983 <cprintf>
  802424:	83 c4 10             	add    $0x10,%esp

}
  802427:	90                   	nop
  802428:	c9                   	leave  
  802429:	c3                   	ret    

0080242a <initialize_MemBlocksList>:

//===============================
// [1] INITIALIZE AVAILABLE LIST:
//===============================
void initialize_MemBlocksList(uint32 numOfBlocks)
{
  80242a:	55                   	push   %ebp
  80242b:	89 e5                	mov    %esp,%ebp
  80242d:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] initialize_MemBlocksList
	// Write your code here, remove the panic and write your code
	//panic("initialize_MemBlocksList() is not implemented yet...!!");
	uint32 n = numOfBlocks;
  802430:	8b 45 08             	mov    0x8(%ebp),%eax
  802433:	89 45 f0             	mov    %eax,-0x10(%ebp)

	LIST_INIT(&AvailableMemBlocksList);
  802436:	c7 05 48 51 80 00 00 	movl   $0x0,0x805148
  80243d:	00 00 00 
  802440:	c7 05 4c 51 80 00 00 	movl   $0x0,0x80514c
  802447:	00 00 00 
  80244a:	c7 05 54 51 80 00 00 	movl   $0x0,0x805154
  802451:	00 00 00 
	for(int i = 0; i<n;i++)
  802454:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  80245b:	e9 9e 00 00 00       	jmp    8024fe <initialize_MemBlocksList+0xd4>
	{
		LIST_INSERT_HEAD(&AvailableMemBlocksList, &(MemBlockNodes[i]));
  802460:	a1 50 50 80 00       	mov    0x805050,%eax
  802465:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802468:	c1 e2 04             	shl    $0x4,%edx
  80246b:	01 d0                	add    %edx,%eax
  80246d:	85 c0                	test   %eax,%eax
  80246f:	75 14                	jne    802485 <initialize_MemBlocksList+0x5b>
  802471:	83 ec 04             	sub    $0x4,%esp
  802474:	68 74 40 80 00       	push   $0x804074
  802479:	6a 47                	push   $0x47
  80247b:	68 97 40 80 00       	push   $0x804097
  802480:	e8 4a e2 ff ff       	call   8006cf <_panic>
  802485:	a1 50 50 80 00       	mov    0x805050,%eax
  80248a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80248d:	c1 e2 04             	shl    $0x4,%edx
  802490:	01 d0                	add    %edx,%eax
  802492:	8b 15 48 51 80 00    	mov    0x805148,%edx
  802498:	89 10                	mov    %edx,(%eax)
  80249a:	8b 00                	mov    (%eax),%eax
  80249c:	85 c0                	test   %eax,%eax
  80249e:	74 18                	je     8024b8 <initialize_MemBlocksList+0x8e>
  8024a0:	a1 48 51 80 00       	mov    0x805148,%eax
  8024a5:	8b 15 50 50 80 00    	mov    0x805050,%edx
  8024ab:	8b 4d f4             	mov    -0xc(%ebp),%ecx
  8024ae:	c1 e1 04             	shl    $0x4,%ecx
  8024b1:	01 ca                	add    %ecx,%edx
  8024b3:	89 50 04             	mov    %edx,0x4(%eax)
  8024b6:	eb 12                	jmp    8024ca <initialize_MemBlocksList+0xa0>
  8024b8:	a1 50 50 80 00       	mov    0x805050,%eax
  8024bd:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8024c0:	c1 e2 04             	shl    $0x4,%edx
  8024c3:	01 d0                	add    %edx,%eax
  8024c5:	a3 4c 51 80 00       	mov    %eax,0x80514c
  8024ca:	a1 50 50 80 00       	mov    0x805050,%eax
  8024cf:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8024d2:	c1 e2 04             	shl    $0x4,%edx
  8024d5:	01 d0                	add    %edx,%eax
  8024d7:	a3 48 51 80 00       	mov    %eax,0x805148
  8024dc:	a1 50 50 80 00       	mov    0x805050,%eax
  8024e1:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8024e4:	c1 e2 04             	shl    $0x4,%edx
  8024e7:	01 d0                	add    %edx,%eax
  8024e9:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8024f0:	a1 54 51 80 00       	mov    0x805154,%eax
  8024f5:	40                   	inc    %eax
  8024f6:	a3 54 51 80 00       	mov    %eax,0x805154
	// Write your code here, remove the panic and write your code
	//panic("initialize_MemBlocksList() is not implemented yet...!!");
	uint32 n = numOfBlocks;

	LIST_INIT(&AvailableMemBlocksList);
	for(int i = 0; i<n;i++)
  8024fb:	ff 45 f4             	incl   -0xc(%ebp)
  8024fe:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802501:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  802504:	0f 82 56 ff ff ff    	jb     802460 <initialize_MemBlocksList+0x36>
	{
		LIST_INSERT_HEAD(&AvailableMemBlocksList, &(MemBlockNodes[i]));
	}
}
  80250a:	90                   	nop
  80250b:	c9                   	leave  
  80250c:	c3                   	ret    

0080250d <find_block>:

//===============================
// [2] FIND BLOCK:
//===============================
struct MemBlock *find_block(struct MemBlock_List *blockList, uint32 va)
{
  80250d:	55                   	push   %ebp
  80250e:	89 e5                	mov    %esp,%ebp
  802510:	83 ec 10             	sub    $0x10,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] find_block
	// Write your code here, remove the panic and write your code
	//panic("find_block() is not implemented yet...!!");
	uint32 virAddress = va;
  802513:	8b 45 0c             	mov    0xc(%ebp),%eax
  802516:	89 45 f4             	mov    %eax,-0xc(%ebp)
	struct MemBlock* blk;
	int found = 0;
  802519:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	LIST_FOREACH(blk, &(AllocMemBlocksList))
  802520:	a1 40 50 80 00       	mov    0x805040,%eax
  802525:	89 45 fc             	mov    %eax,-0x4(%ebp)
  802528:	eb 23                	jmp    80254d <find_block+0x40>
	{
		if(blk->sva == virAddress)
  80252a:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80252d:	8b 40 08             	mov    0x8(%eax),%eax
  802530:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  802533:	75 09                	jne    80253e <find_block+0x31>
		{
			found = 1;
  802535:	c7 45 f8 01 00 00 00 	movl   $0x1,-0x8(%ebp)
			break;
  80253c:	eb 35                	jmp    802573 <find_block+0x66>
		}
		else
		{
			found = 0;
  80253e:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	//panic("find_block() is not implemented yet...!!");
	uint32 virAddress = va;
	struct MemBlock* blk;
	int found = 0;

	LIST_FOREACH(blk, &(AllocMemBlocksList))
  802545:	a1 48 50 80 00       	mov    0x805048,%eax
  80254a:	89 45 fc             	mov    %eax,-0x4(%ebp)
  80254d:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  802551:	74 07                	je     80255a <find_block+0x4d>
  802553:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802556:	8b 00                	mov    (%eax),%eax
  802558:	eb 05                	jmp    80255f <find_block+0x52>
  80255a:	b8 00 00 00 00       	mov    $0x0,%eax
  80255f:	a3 48 50 80 00       	mov    %eax,0x805048
  802564:	a1 48 50 80 00       	mov    0x805048,%eax
  802569:	85 c0                	test   %eax,%eax
  80256b:	75 bd                	jne    80252a <find_block+0x1d>
  80256d:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  802571:	75 b7                	jne    80252a <find_block+0x1d>
		{
			found = 0;
			continue;
		}
	}
	if(found == 1)
  802573:	83 7d f8 01          	cmpl   $0x1,-0x8(%ebp)
  802577:	75 05                	jne    80257e <find_block+0x71>
	{
		return blk;
  802579:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80257c:	eb 05                	jmp    802583 <find_block+0x76>
	}
	else
	{
		return NULL;
  80257e:	b8 00 00 00 00       	mov    $0x0,%eax
	}
}
  802583:	c9                   	leave  
  802584:	c3                   	ret    

00802585 <insert_sorted_allocList>:

//=========================================
// [3] INSERT BLOCK IN ALLOC LIST [SORTED]:
//=========================================
void insert_sorted_allocList(struct MemBlock *blockToInsert)
{
  802585:	55                   	push   %ebp
  802586:	89 e5                	mov    %esp,%ebp
  802588:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] insert_sorted_allocList
	// Write your code here, remove the panic and write your code
	//panic("insert_sorted_allocList() is not implemented yet...!!");
	struct MemBlock* blk;
	struct MemBlock* newblk = blockToInsert;
  80258b:	8b 45 08             	mov    0x8(%ebp),%eax
  80258e:	89 45 f0             	mov    %eax,-0x10(%ebp)

	if((LIST_EMPTY(&AllocMemBlocksList)) || (newblk->sva < LIST_FIRST(&AllocMemBlocksList)->sva))
  802591:	a1 40 50 80 00       	mov    0x805040,%eax
  802596:	85 c0                	test   %eax,%eax
  802598:	74 12                	je     8025ac <insert_sorted_allocList+0x27>
  80259a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80259d:	8b 50 08             	mov    0x8(%eax),%edx
  8025a0:	a1 40 50 80 00       	mov    0x805040,%eax
  8025a5:	8b 40 08             	mov    0x8(%eax),%eax
  8025a8:	39 c2                	cmp    %eax,%edx
  8025aa:	73 65                	jae    802611 <insert_sorted_allocList+0x8c>
	{
		LIST_INSERT_HEAD(&(AllocMemBlocksList), newblk);
  8025ac:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8025b0:	75 14                	jne    8025c6 <insert_sorted_allocList+0x41>
  8025b2:	83 ec 04             	sub    $0x4,%esp
  8025b5:	68 74 40 80 00       	push   $0x804074
  8025ba:	6a 7b                	push   $0x7b
  8025bc:	68 97 40 80 00       	push   $0x804097
  8025c1:	e8 09 e1 ff ff       	call   8006cf <_panic>
  8025c6:	8b 15 40 50 80 00    	mov    0x805040,%edx
  8025cc:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8025cf:	89 10                	mov    %edx,(%eax)
  8025d1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8025d4:	8b 00                	mov    (%eax),%eax
  8025d6:	85 c0                	test   %eax,%eax
  8025d8:	74 0d                	je     8025e7 <insert_sorted_allocList+0x62>
  8025da:	a1 40 50 80 00       	mov    0x805040,%eax
  8025df:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8025e2:	89 50 04             	mov    %edx,0x4(%eax)
  8025e5:	eb 08                	jmp    8025ef <insert_sorted_allocList+0x6a>
  8025e7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8025ea:	a3 44 50 80 00       	mov    %eax,0x805044
  8025ef:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8025f2:	a3 40 50 80 00       	mov    %eax,0x805040
  8025f7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8025fa:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802601:	a1 4c 50 80 00       	mov    0x80504c,%eax
  802606:	40                   	inc    %eax
  802607:	a3 4c 50 80 00       	mov    %eax,0x80504c
  80260c:	e9 5f 01 00 00       	jmp    802770 <insert_sorted_allocList+0x1eb>
	}
	else if(newblk->sva > LIST_LAST(&AllocMemBlocksList)->sva)
  802611:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802614:	8b 50 08             	mov    0x8(%eax),%edx
  802617:	a1 44 50 80 00       	mov    0x805044,%eax
  80261c:	8b 40 08             	mov    0x8(%eax),%eax
  80261f:	39 c2                	cmp    %eax,%edx
  802621:	76 65                	jbe    802688 <insert_sorted_allocList+0x103>
	{
		LIST_INSERT_TAIL(&AllocMemBlocksList, newblk);
  802623:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802627:	75 14                	jne    80263d <insert_sorted_allocList+0xb8>
  802629:	83 ec 04             	sub    $0x4,%esp
  80262c:	68 b0 40 80 00       	push   $0x8040b0
  802631:	6a 7f                	push   $0x7f
  802633:	68 97 40 80 00       	push   $0x804097
  802638:	e8 92 e0 ff ff       	call   8006cf <_panic>
  80263d:	8b 15 44 50 80 00    	mov    0x805044,%edx
  802643:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802646:	89 50 04             	mov    %edx,0x4(%eax)
  802649:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80264c:	8b 40 04             	mov    0x4(%eax),%eax
  80264f:	85 c0                	test   %eax,%eax
  802651:	74 0c                	je     80265f <insert_sorted_allocList+0xda>
  802653:	a1 44 50 80 00       	mov    0x805044,%eax
  802658:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80265b:	89 10                	mov    %edx,(%eax)
  80265d:	eb 08                	jmp    802667 <insert_sorted_allocList+0xe2>
  80265f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802662:	a3 40 50 80 00       	mov    %eax,0x805040
  802667:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80266a:	a3 44 50 80 00       	mov    %eax,0x805044
  80266f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802672:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802678:	a1 4c 50 80 00       	mov    0x80504c,%eax
  80267d:	40                   	inc    %eax
  80267e:	a3 4c 50 80 00       	mov    %eax,0x80504c
				LIST_INSERT_AFTER(&AllocMemBlocksList, blk, newblk);
				break;
			}
		}
	}
}
  802683:	e9 e8 00 00 00       	jmp    802770 <insert_sorted_allocList+0x1eb>
	{
		LIST_INSERT_TAIL(&AllocMemBlocksList, newblk);
	}
	else
	{
		LIST_FOREACH(blk, &AllocMemBlocksList)
  802688:	a1 40 50 80 00       	mov    0x805040,%eax
  80268d:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802690:	e9 ab 00 00 00       	jmp    802740 <insert_sorted_allocList+0x1bb>
		{
			if(blk->prev_next_info.le_next != NULL && newblk->sva > blk->sva  && newblk->sva < blk->prev_next_info.le_next->sva)
  802695:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802698:	8b 00                	mov    (%eax),%eax
  80269a:	85 c0                	test   %eax,%eax
  80269c:	0f 84 96 00 00 00    	je     802738 <insert_sorted_allocList+0x1b3>
  8026a2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8026a5:	8b 50 08             	mov    0x8(%eax),%edx
  8026a8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026ab:	8b 40 08             	mov    0x8(%eax),%eax
  8026ae:	39 c2                	cmp    %eax,%edx
  8026b0:	0f 86 82 00 00 00    	jbe    802738 <insert_sorted_allocList+0x1b3>
  8026b6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8026b9:	8b 50 08             	mov    0x8(%eax),%edx
  8026bc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026bf:	8b 00                	mov    (%eax),%eax
  8026c1:	8b 40 08             	mov    0x8(%eax),%eax
  8026c4:	39 c2                	cmp    %eax,%edx
  8026c6:	73 70                	jae    802738 <insert_sorted_allocList+0x1b3>
			{
				LIST_INSERT_AFTER(&AllocMemBlocksList, blk, newblk);
  8026c8:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8026cc:	74 06                	je     8026d4 <insert_sorted_allocList+0x14f>
  8026ce:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8026d2:	75 17                	jne    8026eb <insert_sorted_allocList+0x166>
  8026d4:	83 ec 04             	sub    $0x4,%esp
  8026d7:	68 d4 40 80 00       	push   $0x8040d4
  8026dc:	68 87 00 00 00       	push   $0x87
  8026e1:	68 97 40 80 00       	push   $0x804097
  8026e6:	e8 e4 df ff ff       	call   8006cf <_panic>
  8026eb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026ee:	8b 10                	mov    (%eax),%edx
  8026f0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8026f3:	89 10                	mov    %edx,(%eax)
  8026f5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8026f8:	8b 00                	mov    (%eax),%eax
  8026fa:	85 c0                	test   %eax,%eax
  8026fc:	74 0b                	je     802709 <insert_sorted_allocList+0x184>
  8026fe:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802701:	8b 00                	mov    (%eax),%eax
  802703:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802706:	89 50 04             	mov    %edx,0x4(%eax)
  802709:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80270c:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80270f:	89 10                	mov    %edx,(%eax)
  802711:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802714:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802717:	89 50 04             	mov    %edx,0x4(%eax)
  80271a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80271d:	8b 00                	mov    (%eax),%eax
  80271f:	85 c0                	test   %eax,%eax
  802721:	75 08                	jne    80272b <insert_sorted_allocList+0x1a6>
  802723:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802726:	a3 44 50 80 00       	mov    %eax,0x805044
  80272b:	a1 4c 50 80 00       	mov    0x80504c,%eax
  802730:	40                   	inc    %eax
  802731:	a3 4c 50 80 00       	mov    %eax,0x80504c
				break;
  802736:	eb 38                	jmp    802770 <insert_sorted_allocList+0x1eb>
	{
		LIST_INSERT_TAIL(&AllocMemBlocksList, newblk);
	}
	else
	{
		LIST_FOREACH(blk, &AllocMemBlocksList)
  802738:	a1 48 50 80 00       	mov    0x805048,%eax
  80273d:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802740:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802744:	74 07                	je     80274d <insert_sorted_allocList+0x1c8>
  802746:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802749:	8b 00                	mov    (%eax),%eax
  80274b:	eb 05                	jmp    802752 <insert_sorted_allocList+0x1cd>
  80274d:	b8 00 00 00 00       	mov    $0x0,%eax
  802752:	a3 48 50 80 00       	mov    %eax,0x805048
  802757:	a1 48 50 80 00       	mov    0x805048,%eax
  80275c:	85 c0                	test   %eax,%eax
  80275e:	0f 85 31 ff ff ff    	jne    802695 <insert_sorted_allocList+0x110>
  802764:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802768:	0f 85 27 ff ff ff    	jne    802695 <insert_sorted_allocList+0x110>
				LIST_INSERT_AFTER(&AllocMemBlocksList, blk, newblk);
				break;
			}
		}
	}
}
  80276e:	eb 00                	jmp    802770 <insert_sorted_allocList+0x1eb>
  802770:	90                   	nop
  802771:	c9                   	leave  
  802772:	c3                   	ret    

00802773 <alloc_block_FF>:

//=========================================
// [4] ALLOCATE BLOCK BY FIRST FIT:
//=========================================
struct MemBlock *alloc_block_FF(uint32 size)
{
  802773:	55                   	push   %ebp
  802774:	89 e5                	mov    %esp,%ebp
  802776:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_FF
	// Write your code here, remove the panic and write your code
	//panic("alloc_block_FF() is not implemented yet...!!");
	uint32 versize = size;
  802779:	8b 45 08             	mov    0x8(%ebp),%eax
  80277c:	89 45 f0             	mov    %eax,-0x10(%ebp)
	struct MemBlock* blk;
	struct MemBlock* newblk = LIST_FIRST(&AvailableMemBlocksList);
  80277f:	a1 48 51 80 00       	mov    0x805148,%eax
  802784:	89 45 ec             	mov    %eax,-0x14(%ebp)

	LIST_FOREACH(blk,&FreeMemBlocksList)
  802787:	a1 38 51 80 00       	mov    0x805138,%eax
  80278c:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80278f:	e9 77 01 00 00       	jmp    80290b <alloc_block_FF+0x198>
	{
		if(blk->size == versize)
  802794:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802797:	8b 40 0c             	mov    0xc(%eax),%eax
  80279a:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  80279d:	0f 85 8a 00 00 00    	jne    80282d <alloc_block_FF+0xba>
		{
			LIST_REMOVE(&FreeMemBlocksList,blk);
  8027a3:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8027a7:	75 17                	jne    8027c0 <alloc_block_FF+0x4d>
  8027a9:	83 ec 04             	sub    $0x4,%esp
  8027ac:	68 08 41 80 00       	push   $0x804108
  8027b1:	68 9e 00 00 00       	push   $0x9e
  8027b6:	68 97 40 80 00       	push   $0x804097
  8027bb:	e8 0f df ff ff       	call   8006cf <_panic>
  8027c0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027c3:	8b 00                	mov    (%eax),%eax
  8027c5:	85 c0                	test   %eax,%eax
  8027c7:	74 10                	je     8027d9 <alloc_block_FF+0x66>
  8027c9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027cc:	8b 00                	mov    (%eax),%eax
  8027ce:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8027d1:	8b 52 04             	mov    0x4(%edx),%edx
  8027d4:	89 50 04             	mov    %edx,0x4(%eax)
  8027d7:	eb 0b                	jmp    8027e4 <alloc_block_FF+0x71>
  8027d9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027dc:	8b 40 04             	mov    0x4(%eax),%eax
  8027df:	a3 3c 51 80 00       	mov    %eax,0x80513c
  8027e4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027e7:	8b 40 04             	mov    0x4(%eax),%eax
  8027ea:	85 c0                	test   %eax,%eax
  8027ec:	74 0f                	je     8027fd <alloc_block_FF+0x8a>
  8027ee:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027f1:	8b 40 04             	mov    0x4(%eax),%eax
  8027f4:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8027f7:	8b 12                	mov    (%edx),%edx
  8027f9:	89 10                	mov    %edx,(%eax)
  8027fb:	eb 0a                	jmp    802807 <alloc_block_FF+0x94>
  8027fd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802800:	8b 00                	mov    (%eax),%eax
  802802:	a3 38 51 80 00       	mov    %eax,0x805138
  802807:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80280a:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802810:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802813:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80281a:	a1 44 51 80 00       	mov    0x805144,%eax
  80281f:	48                   	dec    %eax
  802820:	a3 44 51 80 00       	mov    %eax,0x805144
			return blk;
  802825:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802828:	e9 11 01 00 00       	jmp    80293e <alloc_block_FF+0x1cb>
		}
		else if(blk->size > versize)
  80282d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802830:	8b 40 0c             	mov    0xc(%eax),%eax
  802833:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  802836:	0f 86 c7 00 00 00    	jbe    802903 <alloc_block_FF+0x190>
		{
			LIST_REMOVE(&AvailableMemBlocksList,newblk);
  80283c:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802840:	75 17                	jne    802859 <alloc_block_FF+0xe6>
  802842:	83 ec 04             	sub    $0x4,%esp
  802845:	68 08 41 80 00       	push   $0x804108
  80284a:	68 a3 00 00 00       	push   $0xa3
  80284f:	68 97 40 80 00       	push   $0x804097
  802854:	e8 76 de ff ff       	call   8006cf <_panic>
  802859:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80285c:	8b 00                	mov    (%eax),%eax
  80285e:	85 c0                	test   %eax,%eax
  802860:	74 10                	je     802872 <alloc_block_FF+0xff>
  802862:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802865:	8b 00                	mov    (%eax),%eax
  802867:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80286a:	8b 52 04             	mov    0x4(%edx),%edx
  80286d:	89 50 04             	mov    %edx,0x4(%eax)
  802870:	eb 0b                	jmp    80287d <alloc_block_FF+0x10a>
  802872:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802875:	8b 40 04             	mov    0x4(%eax),%eax
  802878:	a3 4c 51 80 00       	mov    %eax,0x80514c
  80287d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802880:	8b 40 04             	mov    0x4(%eax),%eax
  802883:	85 c0                	test   %eax,%eax
  802885:	74 0f                	je     802896 <alloc_block_FF+0x123>
  802887:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80288a:	8b 40 04             	mov    0x4(%eax),%eax
  80288d:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802890:	8b 12                	mov    (%edx),%edx
  802892:	89 10                	mov    %edx,(%eax)
  802894:	eb 0a                	jmp    8028a0 <alloc_block_FF+0x12d>
  802896:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802899:	8b 00                	mov    (%eax),%eax
  80289b:	a3 48 51 80 00       	mov    %eax,0x805148
  8028a0:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8028a3:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8028a9:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8028ac:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8028b3:	a1 54 51 80 00       	mov    0x805154,%eax
  8028b8:	48                   	dec    %eax
  8028b9:	a3 54 51 80 00       	mov    %eax,0x805154
			newblk->size = versize;
  8028be:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8028c1:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8028c4:	89 50 0c             	mov    %edx,0xc(%eax)
			blk->size = blk->size-versize;
  8028c7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028ca:	8b 40 0c             	mov    0xc(%eax),%eax
  8028cd:	2b 45 f0             	sub    -0x10(%ebp),%eax
  8028d0:	89 c2                	mov    %eax,%edx
  8028d2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028d5:	89 50 0c             	mov    %edx,0xc(%eax)
			uint32 newveradd = blk->sva;
  8028d8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028db:	8b 40 08             	mov    0x8(%eax),%eax
  8028de:	89 45 e8             	mov    %eax,-0x18(%ebp)
			blk->sva+=newblk->size;
  8028e1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028e4:	8b 50 08             	mov    0x8(%eax),%edx
  8028e7:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8028ea:	8b 40 0c             	mov    0xc(%eax),%eax
  8028ed:	01 c2                	add    %eax,%edx
  8028ef:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028f2:	89 50 08             	mov    %edx,0x8(%eax)
			newblk->sva = newveradd;
  8028f5:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8028f8:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8028fb:	89 50 08             	mov    %edx,0x8(%eax)
			return newblk;
  8028fe:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802901:	eb 3b                	jmp    80293e <alloc_block_FF+0x1cb>
	//panic("alloc_block_FF() is not implemented yet...!!");
	uint32 versize = size;
	struct MemBlock* blk;
	struct MemBlock* newblk = LIST_FIRST(&AvailableMemBlocksList);

	LIST_FOREACH(blk,&FreeMemBlocksList)
  802903:	a1 40 51 80 00       	mov    0x805140,%eax
  802908:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80290b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80290f:	74 07                	je     802918 <alloc_block_FF+0x1a5>
  802911:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802914:	8b 00                	mov    (%eax),%eax
  802916:	eb 05                	jmp    80291d <alloc_block_FF+0x1aa>
  802918:	b8 00 00 00 00       	mov    $0x0,%eax
  80291d:	a3 40 51 80 00       	mov    %eax,0x805140
  802922:	a1 40 51 80 00       	mov    0x805140,%eax
  802927:	85 c0                	test   %eax,%eax
  802929:	0f 85 65 fe ff ff    	jne    802794 <alloc_block_FF+0x21>
  80292f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802933:	0f 85 5b fe ff ff    	jne    802794 <alloc_block_FF+0x21>
			blk->sva+=newblk->size;
			newblk->sva = newveradd;
			return newblk;
		}
	}
	return NULL;
  802939:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80293e:	c9                   	leave  
  80293f:	c3                   	ret    

00802940 <alloc_block_BF>:

//=========================================
// [5] ALLOCATE BLOCK BY BEST FIT:
//=========================================
struct MemBlock *alloc_block_BF(uint32 size)
{
  802940:	55                   	push   %ebp
  802941:	89 e5                	mov    %esp,%ebp
  802943:	83 ec 28             	sub    $0x28,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_BF
	// Write your code here, remove the panic and write your code
	//panic("alloc_block_BF() is not implemented yet...!!");
	uint32 versize=size;
  802946:	8b 45 08             	mov    0x8(%ebp),%eax
  802949:	89 45 e8             	mov    %eax,-0x18(%ebp)
	struct MemBlock* blk;
	struct MemBlock* newblk=LIST_FIRST(&AvailableMemBlocksList);
  80294c:	a1 48 51 80 00       	mov    0x805148,%eax
  802951:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	uint32 newveradd;
	uint32 newsize;
	int size_free = LIST_SIZE(&FreeMemBlocksList);
  802954:	a1 44 51 80 00       	mov    0x805144,%eax
  802959:	89 45 e0             	mov    %eax,-0x20(%ebp)

	LIST_FOREACH(blk, &FreeMemBlocksList)
  80295c:	a1 38 51 80 00       	mov    0x805138,%eax
  802961:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802964:	e9 a1 00 00 00       	jmp    802a0a <alloc_block_BF+0xca>
	{
		if(blk->size == versize)
  802969:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80296c:	8b 40 0c             	mov    0xc(%eax),%eax
  80296f:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  802972:	0f 85 8a 00 00 00    	jne    802a02 <alloc_block_BF+0xc2>
		{
			LIST_REMOVE(&FreeMemBlocksList, blk);
  802978:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80297c:	75 17                	jne    802995 <alloc_block_BF+0x55>
  80297e:	83 ec 04             	sub    $0x4,%esp
  802981:	68 08 41 80 00       	push   $0x804108
  802986:	68 c2 00 00 00       	push   $0xc2
  80298b:	68 97 40 80 00       	push   $0x804097
  802990:	e8 3a dd ff ff       	call   8006cf <_panic>
  802995:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802998:	8b 00                	mov    (%eax),%eax
  80299a:	85 c0                	test   %eax,%eax
  80299c:	74 10                	je     8029ae <alloc_block_BF+0x6e>
  80299e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029a1:	8b 00                	mov    (%eax),%eax
  8029a3:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8029a6:	8b 52 04             	mov    0x4(%edx),%edx
  8029a9:	89 50 04             	mov    %edx,0x4(%eax)
  8029ac:	eb 0b                	jmp    8029b9 <alloc_block_BF+0x79>
  8029ae:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029b1:	8b 40 04             	mov    0x4(%eax),%eax
  8029b4:	a3 3c 51 80 00       	mov    %eax,0x80513c
  8029b9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029bc:	8b 40 04             	mov    0x4(%eax),%eax
  8029bf:	85 c0                	test   %eax,%eax
  8029c1:	74 0f                	je     8029d2 <alloc_block_BF+0x92>
  8029c3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029c6:	8b 40 04             	mov    0x4(%eax),%eax
  8029c9:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8029cc:	8b 12                	mov    (%edx),%edx
  8029ce:	89 10                	mov    %edx,(%eax)
  8029d0:	eb 0a                	jmp    8029dc <alloc_block_BF+0x9c>
  8029d2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029d5:	8b 00                	mov    (%eax),%eax
  8029d7:	a3 38 51 80 00       	mov    %eax,0x805138
  8029dc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029df:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8029e5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029e8:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8029ef:	a1 44 51 80 00       	mov    0x805144,%eax
  8029f4:	48                   	dec    %eax
  8029f5:	a3 44 51 80 00       	mov    %eax,0x805144
			return blk;
  8029fa:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029fd:	e9 11 02 00 00       	jmp    802c13 <alloc_block_BF+0x2d3>
	struct MemBlock* newblk=LIST_FIRST(&AvailableMemBlocksList);
	uint32 newveradd;
	uint32 newsize;
	int size_free = LIST_SIZE(&FreeMemBlocksList);

	LIST_FOREACH(blk, &FreeMemBlocksList)
  802a02:	a1 40 51 80 00       	mov    0x805140,%eax
  802a07:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802a0a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802a0e:	74 07                	je     802a17 <alloc_block_BF+0xd7>
  802a10:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a13:	8b 00                	mov    (%eax),%eax
  802a15:	eb 05                	jmp    802a1c <alloc_block_BF+0xdc>
  802a17:	b8 00 00 00 00       	mov    $0x0,%eax
  802a1c:	a3 40 51 80 00       	mov    %eax,0x805140
  802a21:	a1 40 51 80 00       	mov    0x805140,%eax
  802a26:	85 c0                	test   %eax,%eax
  802a28:	0f 85 3b ff ff ff    	jne    802969 <alloc_block_BF+0x29>
  802a2e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802a32:	0f 85 31 ff ff ff    	jne    802969 <alloc_block_BF+0x29>
		{
			LIST_REMOVE(&FreeMemBlocksList, blk);
			return blk;
		}
	}
	LIST_FOREACH(blk, &FreeMemBlocksList)
  802a38:	a1 38 51 80 00       	mov    0x805138,%eax
  802a3d:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802a40:	eb 27                	jmp    802a69 <alloc_block_BF+0x129>
	{
		if(blk->size > versize)
  802a42:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a45:	8b 40 0c             	mov    0xc(%eax),%eax
  802a48:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  802a4b:	76 14                	jbe    802a61 <alloc_block_BF+0x121>
		{
			newsize = blk->size;
  802a4d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a50:	8b 40 0c             	mov    0xc(%eax),%eax
  802a53:	89 45 ec             	mov    %eax,-0x14(%ebp)
			newveradd = blk->sva;
  802a56:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a59:	8b 40 08             	mov    0x8(%eax),%eax
  802a5c:	89 45 f0             	mov    %eax,-0x10(%ebp)
			break;
  802a5f:	eb 2e                	jmp    802a8f <alloc_block_BF+0x14f>
		{
			LIST_REMOVE(&FreeMemBlocksList, blk);
			return blk;
		}
	}
	LIST_FOREACH(blk, &FreeMemBlocksList)
  802a61:	a1 40 51 80 00       	mov    0x805140,%eax
  802a66:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802a69:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802a6d:	74 07                	je     802a76 <alloc_block_BF+0x136>
  802a6f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a72:	8b 00                	mov    (%eax),%eax
  802a74:	eb 05                	jmp    802a7b <alloc_block_BF+0x13b>
  802a76:	b8 00 00 00 00       	mov    $0x0,%eax
  802a7b:	a3 40 51 80 00       	mov    %eax,0x805140
  802a80:	a1 40 51 80 00       	mov    0x805140,%eax
  802a85:	85 c0                	test   %eax,%eax
  802a87:	75 b9                	jne    802a42 <alloc_block_BF+0x102>
  802a89:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802a8d:	75 b3                	jne    802a42 <alloc_block_BF+0x102>
			newsize = blk->size;
			newveradd = blk->sva;
			break;
		}
	}
	LIST_FOREACH(blk, &FreeMemBlocksList)
  802a8f:	a1 38 51 80 00       	mov    0x805138,%eax
  802a94:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802a97:	eb 30                	jmp    802ac9 <alloc_block_BF+0x189>
	{
		if(newsize > blk->size && blk->size > versize)
  802a99:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a9c:	8b 40 0c             	mov    0xc(%eax),%eax
  802a9f:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  802aa2:	73 1d                	jae    802ac1 <alloc_block_BF+0x181>
  802aa4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802aa7:	8b 40 0c             	mov    0xc(%eax),%eax
  802aaa:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  802aad:	76 12                	jbe    802ac1 <alloc_block_BF+0x181>
		{
	       newsize = blk->size;
  802aaf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ab2:	8b 40 0c             	mov    0xc(%eax),%eax
  802ab5:	89 45 ec             	mov    %eax,-0x14(%ebp)
		   newveradd = blk->sva;
  802ab8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802abb:	8b 40 08             	mov    0x8(%eax),%eax
  802abe:	89 45 f0             	mov    %eax,-0x10(%ebp)
			newsize = blk->size;
			newveradd = blk->sva;
			break;
		}
	}
	LIST_FOREACH(blk, &FreeMemBlocksList)
  802ac1:	a1 40 51 80 00       	mov    0x805140,%eax
  802ac6:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802ac9:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802acd:	74 07                	je     802ad6 <alloc_block_BF+0x196>
  802acf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ad2:	8b 00                	mov    (%eax),%eax
  802ad4:	eb 05                	jmp    802adb <alloc_block_BF+0x19b>
  802ad6:	b8 00 00 00 00       	mov    $0x0,%eax
  802adb:	a3 40 51 80 00       	mov    %eax,0x805140
  802ae0:	a1 40 51 80 00       	mov    0x805140,%eax
  802ae5:	85 c0                	test   %eax,%eax
  802ae7:	75 b0                	jne    802a99 <alloc_block_BF+0x159>
  802ae9:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802aed:	75 aa                	jne    802a99 <alloc_block_BF+0x159>
		{
	       newsize = blk->size;
		   newveradd = blk->sva;
		}
	}
	LIST_FOREACH(blk, &FreeMemBlocksList)
  802aef:	a1 38 51 80 00       	mov    0x805138,%eax
  802af4:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802af7:	e9 e4 00 00 00       	jmp    802be0 <alloc_block_BF+0x2a0>
	{
		if(blk->size == newsize && blk->sva == newveradd)
  802afc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802aff:	8b 40 0c             	mov    0xc(%eax),%eax
  802b02:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  802b05:	0f 85 cd 00 00 00    	jne    802bd8 <alloc_block_BF+0x298>
  802b0b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b0e:	8b 40 08             	mov    0x8(%eax),%eax
  802b11:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  802b14:	0f 85 be 00 00 00    	jne    802bd8 <alloc_block_BF+0x298>
		{
			LIST_REMOVE(&AvailableMemBlocksList, newblk);
  802b1a:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  802b1e:	75 17                	jne    802b37 <alloc_block_BF+0x1f7>
  802b20:	83 ec 04             	sub    $0x4,%esp
  802b23:	68 08 41 80 00       	push   $0x804108
  802b28:	68 db 00 00 00       	push   $0xdb
  802b2d:	68 97 40 80 00       	push   $0x804097
  802b32:	e8 98 db ff ff       	call   8006cf <_panic>
  802b37:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802b3a:	8b 00                	mov    (%eax),%eax
  802b3c:	85 c0                	test   %eax,%eax
  802b3e:	74 10                	je     802b50 <alloc_block_BF+0x210>
  802b40:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802b43:	8b 00                	mov    (%eax),%eax
  802b45:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802b48:	8b 52 04             	mov    0x4(%edx),%edx
  802b4b:	89 50 04             	mov    %edx,0x4(%eax)
  802b4e:	eb 0b                	jmp    802b5b <alloc_block_BF+0x21b>
  802b50:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802b53:	8b 40 04             	mov    0x4(%eax),%eax
  802b56:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802b5b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802b5e:	8b 40 04             	mov    0x4(%eax),%eax
  802b61:	85 c0                	test   %eax,%eax
  802b63:	74 0f                	je     802b74 <alloc_block_BF+0x234>
  802b65:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802b68:	8b 40 04             	mov    0x4(%eax),%eax
  802b6b:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802b6e:	8b 12                	mov    (%edx),%edx
  802b70:	89 10                	mov    %edx,(%eax)
  802b72:	eb 0a                	jmp    802b7e <alloc_block_BF+0x23e>
  802b74:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802b77:	8b 00                	mov    (%eax),%eax
  802b79:	a3 48 51 80 00       	mov    %eax,0x805148
  802b7e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802b81:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802b87:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802b8a:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802b91:	a1 54 51 80 00       	mov    0x805154,%eax
  802b96:	48                   	dec    %eax
  802b97:	a3 54 51 80 00       	mov    %eax,0x805154
			newblk->size = versize;
  802b9c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802b9f:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802ba2:	89 50 0c             	mov    %edx,0xc(%eax)
			newblk->sva = newveradd;
  802ba5:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802ba8:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802bab:	89 50 08             	mov    %edx,0x8(%eax)
			blk->size = blk->size - versize;
  802bae:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bb1:	8b 40 0c             	mov    0xc(%eax),%eax
  802bb4:	2b 45 e8             	sub    -0x18(%ebp),%eax
  802bb7:	89 c2                	mov    %eax,%edx
  802bb9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bbc:	89 50 0c             	mov    %edx,0xc(%eax)
			blk->sva+= newblk->size;
  802bbf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bc2:	8b 50 08             	mov    0x8(%eax),%edx
  802bc5:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802bc8:	8b 40 0c             	mov    0xc(%eax),%eax
  802bcb:	01 c2                	add    %eax,%edx
  802bcd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bd0:	89 50 08             	mov    %edx,0x8(%eax)
			return newblk;
  802bd3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802bd6:	eb 3b                	jmp    802c13 <alloc_block_BF+0x2d3>
		{
	       newsize = blk->size;
		   newveradd = blk->sva;
		}
	}
	LIST_FOREACH(blk, &FreeMemBlocksList)
  802bd8:	a1 40 51 80 00       	mov    0x805140,%eax
  802bdd:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802be0:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802be4:	74 07                	je     802bed <alloc_block_BF+0x2ad>
  802be6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802be9:	8b 00                	mov    (%eax),%eax
  802beb:	eb 05                	jmp    802bf2 <alloc_block_BF+0x2b2>
  802bed:	b8 00 00 00 00       	mov    $0x0,%eax
  802bf2:	a3 40 51 80 00       	mov    %eax,0x805140
  802bf7:	a1 40 51 80 00       	mov    0x805140,%eax
  802bfc:	85 c0                	test   %eax,%eax
  802bfe:	0f 85 f8 fe ff ff    	jne    802afc <alloc_block_BF+0x1bc>
  802c04:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802c08:	0f 85 ee fe ff ff    	jne    802afc <alloc_block_BF+0x1bc>
			blk->size = blk->size - versize;
			blk->sva+= newblk->size;
			return newblk;
		}
	}
	return NULL;
  802c0e:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802c13:	c9                   	leave  
  802c14:	c3                   	ret    

00802c15 <alloc_block_NF>:
//=========================================
// [7] ALLOCATE BLOCK BY NEXT FIT:
//=========================================
struct MemBlock *last_allocate;
struct MemBlock *alloc_block_NF(uint32 size)
{
  802c15:	55                   	push   %ebp
  802c16:	89 e5                	mov    %esp,%ebp
  802c18:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1 - BONUS] [DYNAMIC ALLOCATOR] alloc_block_NF
	// Write your code here, remove the panic and write your code
	//panic("alloc_block_NF() is not implemented yet...!!");
	uint32 versize = size;
  802c1b:	8b 45 08             	mov    0x8(%ebp),%eax
  802c1e:	89 45 f0             	mov    %eax,-0x10(%ebp)
	struct MemBlock* blk;
	struct MemBlock* newblk = LIST_FIRST(&AvailableMemBlocksList);
  802c21:	a1 48 51 80 00       	mov    0x805148,%eax
  802c26:	89 45 ec             	mov    %eax,-0x14(%ebp)

	LIST_FOREACH(blk,&FreeMemBlocksList)
  802c29:	a1 38 51 80 00       	mov    0x805138,%eax
  802c2e:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802c31:	e9 77 01 00 00       	jmp    802dad <alloc_block_NF+0x198>
	{
		if(blk->size == versize)
  802c36:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c39:	8b 40 0c             	mov    0xc(%eax),%eax
  802c3c:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  802c3f:	0f 85 8a 00 00 00    	jne    802ccf <alloc_block_NF+0xba>
		{
			LIST_REMOVE(&FreeMemBlocksList,blk);
  802c45:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802c49:	75 17                	jne    802c62 <alloc_block_NF+0x4d>
  802c4b:	83 ec 04             	sub    $0x4,%esp
  802c4e:	68 08 41 80 00       	push   $0x804108
  802c53:	68 f7 00 00 00       	push   $0xf7
  802c58:	68 97 40 80 00       	push   $0x804097
  802c5d:	e8 6d da ff ff       	call   8006cf <_panic>
  802c62:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c65:	8b 00                	mov    (%eax),%eax
  802c67:	85 c0                	test   %eax,%eax
  802c69:	74 10                	je     802c7b <alloc_block_NF+0x66>
  802c6b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c6e:	8b 00                	mov    (%eax),%eax
  802c70:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802c73:	8b 52 04             	mov    0x4(%edx),%edx
  802c76:	89 50 04             	mov    %edx,0x4(%eax)
  802c79:	eb 0b                	jmp    802c86 <alloc_block_NF+0x71>
  802c7b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c7e:	8b 40 04             	mov    0x4(%eax),%eax
  802c81:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802c86:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c89:	8b 40 04             	mov    0x4(%eax),%eax
  802c8c:	85 c0                	test   %eax,%eax
  802c8e:	74 0f                	je     802c9f <alloc_block_NF+0x8a>
  802c90:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c93:	8b 40 04             	mov    0x4(%eax),%eax
  802c96:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802c99:	8b 12                	mov    (%edx),%edx
  802c9b:	89 10                	mov    %edx,(%eax)
  802c9d:	eb 0a                	jmp    802ca9 <alloc_block_NF+0x94>
  802c9f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ca2:	8b 00                	mov    (%eax),%eax
  802ca4:	a3 38 51 80 00       	mov    %eax,0x805138
  802ca9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cac:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802cb2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cb5:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802cbc:	a1 44 51 80 00       	mov    0x805144,%eax
  802cc1:	48                   	dec    %eax
  802cc2:	a3 44 51 80 00       	mov    %eax,0x805144
			return blk;
  802cc7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cca:	e9 11 01 00 00       	jmp    802de0 <alloc_block_NF+0x1cb>
		}
		else if(blk->size > versize)
  802ccf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cd2:	8b 40 0c             	mov    0xc(%eax),%eax
  802cd5:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  802cd8:	0f 86 c7 00 00 00    	jbe    802da5 <alloc_block_NF+0x190>
		{
			LIST_REMOVE(&AvailableMemBlocksList,newblk);
  802cde:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802ce2:	75 17                	jne    802cfb <alloc_block_NF+0xe6>
  802ce4:	83 ec 04             	sub    $0x4,%esp
  802ce7:	68 08 41 80 00       	push   $0x804108
  802cec:	68 fc 00 00 00       	push   $0xfc
  802cf1:	68 97 40 80 00       	push   $0x804097
  802cf6:	e8 d4 d9 ff ff       	call   8006cf <_panic>
  802cfb:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802cfe:	8b 00                	mov    (%eax),%eax
  802d00:	85 c0                	test   %eax,%eax
  802d02:	74 10                	je     802d14 <alloc_block_NF+0xff>
  802d04:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802d07:	8b 00                	mov    (%eax),%eax
  802d09:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802d0c:	8b 52 04             	mov    0x4(%edx),%edx
  802d0f:	89 50 04             	mov    %edx,0x4(%eax)
  802d12:	eb 0b                	jmp    802d1f <alloc_block_NF+0x10a>
  802d14:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802d17:	8b 40 04             	mov    0x4(%eax),%eax
  802d1a:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802d1f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802d22:	8b 40 04             	mov    0x4(%eax),%eax
  802d25:	85 c0                	test   %eax,%eax
  802d27:	74 0f                	je     802d38 <alloc_block_NF+0x123>
  802d29:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802d2c:	8b 40 04             	mov    0x4(%eax),%eax
  802d2f:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802d32:	8b 12                	mov    (%edx),%edx
  802d34:	89 10                	mov    %edx,(%eax)
  802d36:	eb 0a                	jmp    802d42 <alloc_block_NF+0x12d>
  802d38:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802d3b:	8b 00                	mov    (%eax),%eax
  802d3d:	a3 48 51 80 00       	mov    %eax,0x805148
  802d42:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802d45:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802d4b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802d4e:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802d55:	a1 54 51 80 00       	mov    0x805154,%eax
  802d5a:	48                   	dec    %eax
  802d5b:	a3 54 51 80 00       	mov    %eax,0x805154
			newblk->size = versize;
  802d60:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802d63:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802d66:	89 50 0c             	mov    %edx,0xc(%eax)
			blk->size = blk->size-versize;
  802d69:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d6c:	8b 40 0c             	mov    0xc(%eax),%eax
  802d6f:	2b 45 f0             	sub    -0x10(%ebp),%eax
  802d72:	89 c2                	mov    %eax,%edx
  802d74:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d77:	89 50 0c             	mov    %edx,0xc(%eax)
			uint32 newveradd = blk->sva;
  802d7a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d7d:	8b 40 08             	mov    0x8(%eax),%eax
  802d80:	89 45 e8             	mov    %eax,-0x18(%ebp)
			blk->sva+=newblk->size;
  802d83:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d86:	8b 50 08             	mov    0x8(%eax),%edx
  802d89:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802d8c:	8b 40 0c             	mov    0xc(%eax),%eax
  802d8f:	01 c2                	add    %eax,%edx
  802d91:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d94:	89 50 08             	mov    %edx,0x8(%eax)
			newblk->sva = newveradd;
  802d97:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802d9a:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802d9d:	89 50 08             	mov    %edx,0x8(%eax)
			return newblk;
  802da0:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802da3:	eb 3b                	jmp    802de0 <alloc_block_NF+0x1cb>
	//panic("alloc_block_NF() is not implemented yet...!!");
	uint32 versize = size;
	struct MemBlock* blk;
	struct MemBlock* newblk = LIST_FIRST(&AvailableMemBlocksList);

	LIST_FOREACH(blk,&FreeMemBlocksList)
  802da5:	a1 40 51 80 00       	mov    0x805140,%eax
  802daa:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802dad:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802db1:	74 07                	je     802dba <alloc_block_NF+0x1a5>
  802db3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802db6:	8b 00                	mov    (%eax),%eax
  802db8:	eb 05                	jmp    802dbf <alloc_block_NF+0x1aa>
  802dba:	b8 00 00 00 00       	mov    $0x0,%eax
  802dbf:	a3 40 51 80 00       	mov    %eax,0x805140
  802dc4:	a1 40 51 80 00       	mov    0x805140,%eax
  802dc9:	85 c0                	test   %eax,%eax
  802dcb:	0f 85 65 fe ff ff    	jne    802c36 <alloc_block_NF+0x21>
  802dd1:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802dd5:	0f 85 5b fe ff ff    	jne    802c36 <alloc_block_NF+0x21>
			blk->sva+=newblk->size;
			newblk->sva = newveradd;
			return newblk;
		}
	}
	return NULL;
  802ddb:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802de0:	c9                   	leave  
  802de1:	c3                   	ret    

00802de2 <addToAvailMemBlocksList>:

//===================================================
// [8] INSERT BLOCK (SORTED WITH MERGE) IN FREE LIST:
//===================================================
void addToAvailMemBlocksList(struct MemBlock *blockToInsert)
{
  802de2:	55                   	push   %ebp
  802de3:	89 e5                	mov    %esp,%ebp
  802de5:	83 ec 08             	sub    $0x8,%esp
	blockToInsert->sva = 0;
  802de8:	8b 45 08             	mov    0x8(%ebp),%eax
  802deb:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
	blockToInsert->size = 0;
  802df2:	8b 45 08             	mov    0x8(%ebp),%eax
  802df5:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
	//add to avail
	LIST_INSERT_TAIL(&AvailableMemBlocksList, blockToInsert);
  802dfc:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802e00:	75 17                	jne    802e19 <addToAvailMemBlocksList+0x37>
  802e02:	83 ec 04             	sub    $0x4,%esp
  802e05:	68 b0 40 80 00       	push   $0x8040b0
  802e0a:	68 10 01 00 00       	push   $0x110
  802e0f:	68 97 40 80 00       	push   $0x804097
  802e14:	e8 b6 d8 ff ff       	call   8006cf <_panic>
  802e19:	8b 15 4c 51 80 00    	mov    0x80514c,%edx
  802e1f:	8b 45 08             	mov    0x8(%ebp),%eax
  802e22:	89 50 04             	mov    %edx,0x4(%eax)
  802e25:	8b 45 08             	mov    0x8(%ebp),%eax
  802e28:	8b 40 04             	mov    0x4(%eax),%eax
  802e2b:	85 c0                	test   %eax,%eax
  802e2d:	74 0c                	je     802e3b <addToAvailMemBlocksList+0x59>
  802e2f:	a1 4c 51 80 00       	mov    0x80514c,%eax
  802e34:	8b 55 08             	mov    0x8(%ebp),%edx
  802e37:	89 10                	mov    %edx,(%eax)
  802e39:	eb 08                	jmp    802e43 <addToAvailMemBlocksList+0x61>
  802e3b:	8b 45 08             	mov    0x8(%ebp),%eax
  802e3e:	a3 48 51 80 00       	mov    %eax,0x805148
  802e43:	8b 45 08             	mov    0x8(%ebp),%eax
  802e46:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802e4b:	8b 45 08             	mov    0x8(%ebp),%eax
  802e4e:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802e54:	a1 54 51 80 00       	mov    0x805154,%eax
  802e59:	40                   	inc    %eax
  802e5a:	a3 54 51 80 00       	mov    %eax,0x805154
}
  802e5f:	90                   	nop
  802e60:	c9                   	leave  
  802e61:	c3                   	ret    

00802e62 <insert_sorted_with_merge_freeList>:
void insert_sorted_with_merge_freeList(struct MemBlock *blockToInsert)
{
  802e62:	55                   	push   %ebp
  802e63:	89 e5                	mov    %esp,%ebp
  802e65:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] insert_sorted_with_merge_freeList
	// Write your code here, remove the panic and write your code

	struct MemBlock* last = LIST_LAST(&FreeMemBlocksList);
  802e68:	a1 3c 51 80 00       	mov    0x80513c,%eax
  802e6d:	89 45 f0             	mov    %eax,-0x10(%ebp)
	//check if list empty
	if (LIST_SIZE(&(FreeMemBlocksList)) == 0)
  802e70:	a1 44 51 80 00       	mov    0x805144,%eax
  802e75:	85 c0                	test   %eax,%eax
  802e77:	75 68                	jne    802ee1 <insert_sorted_with_merge_freeList+0x7f>
		LIST_INSERT_HEAD(&FreeMemBlocksList, blockToInsert);
  802e79:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802e7d:	75 17                	jne    802e96 <insert_sorted_with_merge_freeList+0x34>
  802e7f:	83 ec 04             	sub    $0x4,%esp
  802e82:	68 74 40 80 00       	push   $0x804074
  802e87:	68 1a 01 00 00       	push   $0x11a
  802e8c:	68 97 40 80 00       	push   $0x804097
  802e91:	e8 39 d8 ff ff       	call   8006cf <_panic>
  802e96:	8b 15 38 51 80 00    	mov    0x805138,%edx
  802e9c:	8b 45 08             	mov    0x8(%ebp),%eax
  802e9f:	89 10                	mov    %edx,(%eax)
  802ea1:	8b 45 08             	mov    0x8(%ebp),%eax
  802ea4:	8b 00                	mov    (%eax),%eax
  802ea6:	85 c0                	test   %eax,%eax
  802ea8:	74 0d                	je     802eb7 <insert_sorted_with_merge_freeList+0x55>
  802eaa:	a1 38 51 80 00       	mov    0x805138,%eax
  802eaf:	8b 55 08             	mov    0x8(%ebp),%edx
  802eb2:	89 50 04             	mov    %edx,0x4(%eax)
  802eb5:	eb 08                	jmp    802ebf <insert_sorted_with_merge_freeList+0x5d>
  802eb7:	8b 45 08             	mov    0x8(%ebp),%eax
  802eba:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802ebf:	8b 45 08             	mov    0x8(%ebp),%eax
  802ec2:	a3 38 51 80 00       	mov    %eax,0x805138
  802ec7:	8b 45 08             	mov    0x8(%ebp),%eax
  802eca:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802ed1:	a1 44 51 80 00       	mov    0x805144,%eax
  802ed6:	40                   	inc    %eax
  802ed7:	a3 44 51 80 00       	mov    %eax,0x805144
		}
	}

	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  802edc:	e9 c5 03 00 00       	jmp    8032a6 <insert_sorted_with_merge_freeList+0x444>
	struct MemBlock* last = LIST_LAST(&FreeMemBlocksList);
	//check if list empty
	if (LIST_SIZE(&(FreeMemBlocksList)) == 0)
		LIST_INSERT_HEAD(&FreeMemBlocksList, blockToInsert);
	//check if it's position is at last
	else if (last->sva < blockToInsert->sva) {
  802ee1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802ee4:	8b 50 08             	mov    0x8(%eax),%edx
  802ee7:	8b 45 08             	mov    0x8(%ebp),%eax
  802eea:	8b 40 08             	mov    0x8(%eax),%eax
  802eed:	39 c2                	cmp    %eax,%edx
  802eef:	0f 83 b2 00 00 00    	jae    802fa7 <insert_sorted_with_merge_freeList+0x145>

		//if i have to merge
		if (last->sva + last->size == blockToInsert->sva) {
  802ef5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802ef8:	8b 50 08             	mov    0x8(%eax),%edx
  802efb:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802efe:	8b 40 0c             	mov    0xc(%eax),%eax
  802f01:	01 c2                	add    %eax,%edx
  802f03:	8b 45 08             	mov    0x8(%ebp),%eax
  802f06:	8b 40 08             	mov    0x8(%eax),%eax
  802f09:	39 c2                	cmp    %eax,%edx
  802f0b:	75 27                	jne    802f34 <insert_sorted_with_merge_freeList+0xd2>
			last->size = last->size + blockToInsert->size;
  802f0d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802f10:	8b 50 0c             	mov    0xc(%eax),%edx
  802f13:	8b 45 08             	mov    0x8(%ebp),%eax
  802f16:	8b 40 0c             	mov    0xc(%eax),%eax
  802f19:	01 c2                	add    %eax,%edx
  802f1b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802f1e:	89 50 0c             	mov    %edx,0xc(%eax)
			addToAvailMemBlocksList(blockToInsert);
  802f21:	83 ec 0c             	sub    $0xc,%esp
  802f24:	ff 75 08             	pushl  0x8(%ebp)
  802f27:	e8 b6 fe ff ff       	call   802de2 <addToAvailMemBlocksList>
  802f2c:	83 c4 10             	add    $0x10,%esp
		}
	}

	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  802f2f:	e9 72 03 00 00       	jmp    8032a6 <insert_sorted_with_merge_freeList+0x444>
		if (last->sva + last->size == blockToInsert->sva) {
			last->size = last->size + blockToInsert->size;
			addToAvailMemBlocksList(blockToInsert);

		} else {
			LIST_INSERT_AFTER(&FreeMemBlocksList, last, blockToInsert);
  802f34:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802f38:	74 06                	je     802f40 <insert_sorted_with_merge_freeList+0xde>
  802f3a:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802f3e:	75 17                	jne    802f57 <insert_sorted_with_merge_freeList+0xf5>
  802f40:	83 ec 04             	sub    $0x4,%esp
  802f43:	68 d4 40 80 00       	push   $0x8040d4
  802f48:	68 24 01 00 00       	push   $0x124
  802f4d:	68 97 40 80 00       	push   $0x804097
  802f52:	e8 78 d7 ff ff       	call   8006cf <_panic>
  802f57:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802f5a:	8b 10                	mov    (%eax),%edx
  802f5c:	8b 45 08             	mov    0x8(%ebp),%eax
  802f5f:	89 10                	mov    %edx,(%eax)
  802f61:	8b 45 08             	mov    0x8(%ebp),%eax
  802f64:	8b 00                	mov    (%eax),%eax
  802f66:	85 c0                	test   %eax,%eax
  802f68:	74 0b                	je     802f75 <insert_sorted_with_merge_freeList+0x113>
  802f6a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802f6d:	8b 00                	mov    (%eax),%eax
  802f6f:	8b 55 08             	mov    0x8(%ebp),%edx
  802f72:	89 50 04             	mov    %edx,0x4(%eax)
  802f75:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802f78:	8b 55 08             	mov    0x8(%ebp),%edx
  802f7b:	89 10                	mov    %edx,(%eax)
  802f7d:	8b 45 08             	mov    0x8(%ebp),%eax
  802f80:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802f83:	89 50 04             	mov    %edx,0x4(%eax)
  802f86:	8b 45 08             	mov    0x8(%ebp),%eax
  802f89:	8b 00                	mov    (%eax),%eax
  802f8b:	85 c0                	test   %eax,%eax
  802f8d:	75 08                	jne    802f97 <insert_sorted_with_merge_freeList+0x135>
  802f8f:	8b 45 08             	mov    0x8(%ebp),%eax
  802f92:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802f97:	a1 44 51 80 00       	mov    0x805144,%eax
  802f9c:	40                   	inc    %eax
  802f9d:	a3 44 51 80 00       	mov    %eax,0x805144
		}
	}

	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  802fa2:	e9 ff 02 00 00       	jmp    8032a6 <insert_sorted_with_merge_freeList+0x444>
		} else {
			LIST_INSERT_AFTER(&FreeMemBlocksList, last, blockToInsert);
		}
	} else {
		struct MemBlock *iterator;
		LIST_FOREACH(iterator, &(FreeMemBlocksList))
  802fa7:	a1 38 51 80 00       	mov    0x805138,%eax
  802fac:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802faf:	e9 c2 02 00 00       	jmp    803276 <insert_sorted_with_merge_freeList+0x414>
		{

			if (iterator->sva > blockToInsert->sva) {
  802fb4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802fb7:	8b 50 08             	mov    0x8(%eax),%edx
  802fba:	8b 45 08             	mov    0x8(%ebp),%eax
  802fbd:	8b 40 08             	mov    0x8(%eax),%eax
  802fc0:	39 c2                	cmp    %eax,%edx
  802fc2:	0f 86 a6 02 00 00    	jbe    80326e <insert_sorted_with_merge_freeList+0x40c>

				struct MemBlock* prev = LIST_PREV(iterator);
  802fc8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802fcb:	8b 40 04             	mov    0x4(%eax),%eax
  802fce:	89 45 ec             	mov    %eax,-0x14(%ebp)
				if (prev == NULL) {
  802fd1:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802fd5:	0f 85 ba 00 00 00    	jne    803095 <insert_sorted_with_merge_freeList+0x233>
					//check merge
					if (blockToInsert->size + blockToInsert->sva
  802fdb:	8b 45 08             	mov    0x8(%ebp),%eax
  802fde:	8b 50 0c             	mov    0xc(%eax),%edx
  802fe1:	8b 45 08             	mov    0x8(%ebp),%eax
  802fe4:	8b 40 08             	mov    0x8(%eax),%eax
  802fe7:	01 c2                	add    %eax,%edx
							== iterator->sva) {
  802fe9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802fec:	8b 40 08             	mov    0x8(%eax),%eax
			if (iterator->sva > blockToInsert->sva) {

				struct MemBlock* prev = LIST_PREV(iterator);
				if (prev == NULL) {
					//check merge
					if (blockToInsert->size + blockToInsert->sva
  802fef:	39 c2                	cmp    %eax,%edx
  802ff1:	75 33                	jne    803026 <insert_sorted_with_merge_freeList+0x1c4>
							== iterator->sva) {
						iterator->sva = blockToInsert->sva;
  802ff3:	8b 45 08             	mov    0x8(%ebp),%eax
  802ff6:	8b 50 08             	mov    0x8(%eax),%edx
  802ff9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ffc:	89 50 08             	mov    %edx,0x8(%eax)
						iterator->size = iterator->size + blockToInsert->size;
  802fff:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803002:	8b 50 0c             	mov    0xc(%eax),%edx
  803005:	8b 45 08             	mov    0x8(%ebp),%eax
  803008:	8b 40 0c             	mov    0xc(%eax),%eax
  80300b:	01 c2                	add    %eax,%edx
  80300d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803010:	89 50 0c             	mov    %edx,0xc(%eax)
						addToAvailMemBlocksList(blockToInsert);
  803013:	83 ec 0c             	sub    $0xc,%esp
  803016:	ff 75 08             	pushl  0x8(%ebp)
  803019:	e8 c4 fd ff ff       	call   802de2 <addToAvailMemBlocksList>
  80301e:	83 c4 10             	add    $0x10,%esp

					else {
						LIST_INSERT_BEFORE(&FreeMemBlocksList, iterator,
								blockToInsert);
					}
					break;
  803021:	e9 80 02 00 00       	jmp    8032a6 <insert_sorted_with_merge_freeList+0x444>
						addToAvailMemBlocksList(blockToInsert);

					}

					else {
						LIST_INSERT_BEFORE(&FreeMemBlocksList, iterator,
  803026:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80302a:	74 06                	je     803032 <insert_sorted_with_merge_freeList+0x1d0>
  80302c:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803030:	75 17                	jne    803049 <insert_sorted_with_merge_freeList+0x1e7>
  803032:	83 ec 04             	sub    $0x4,%esp
  803035:	68 28 41 80 00       	push   $0x804128
  80303a:	68 3a 01 00 00       	push   $0x13a
  80303f:	68 97 40 80 00       	push   $0x804097
  803044:	e8 86 d6 ff ff       	call   8006cf <_panic>
  803049:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80304c:	8b 50 04             	mov    0x4(%eax),%edx
  80304f:	8b 45 08             	mov    0x8(%ebp),%eax
  803052:	89 50 04             	mov    %edx,0x4(%eax)
  803055:	8b 45 08             	mov    0x8(%ebp),%eax
  803058:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80305b:	89 10                	mov    %edx,(%eax)
  80305d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803060:	8b 40 04             	mov    0x4(%eax),%eax
  803063:	85 c0                	test   %eax,%eax
  803065:	74 0d                	je     803074 <insert_sorted_with_merge_freeList+0x212>
  803067:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80306a:	8b 40 04             	mov    0x4(%eax),%eax
  80306d:	8b 55 08             	mov    0x8(%ebp),%edx
  803070:	89 10                	mov    %edx,(%eax)
  803072:	eb 08                	jmp    80307c <insert_sorted_with_merge_freeList+0x21a>
  803074:	8b 45 08             	mov    0x8(%ebp),%eax
  803077:	a3 38 51 80 00       	mov    %eax,0x805138
  80307c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80307f:	8b 55 08             	mov    0x8(%ebp),%edx
  803082:	89 50 04             	mov    %edx,0x4(%eax)
  803085:	a1 44 51 80 00       	mov    0x805144,%eax
  80308a:	40                   	inc    %eax
  80308b:	a3 44 51 80 00       	mov    %eax,0x805144
								blockToInsert);
					}
					break;
  803090:	e9 11 02 00 00       	jmp    8032a6 <insert_sorted_with_merge_freeList+0x444>
				} else {
					//prev and next merge
					if (prev->sva + prev->size + blockToInsert->size
  803095:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803098:	8b 50 08             	mov    0x8(%eax),%edx
  80309b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80309e:	8b 40 0c             	mov    0xc(%eax),%eax
  8030a1:	01 c2                	add    %eax,%edx
  8030a3:	8b 45 08             	mov    0x8(%ebp),%eax
  8030a6:	8b 40 0c             	mov    0xc(%eax),%eax
  8030a9:	01 c2                	add    %eax,%edx
							== iterator->sva) {
  8030ab:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030ae:	8b 40 08             	mov    0x8(%eax),%eax
								blockToInsert);
					}
					break;
				} else {
					//prev and next merge
					if (prev->sva + prev->size + blockToInsert->size
  8030b1:	39 c2                	cmp    %eax,%edx
  8030b3:	0f 85 bf 00 00 00    	jne    803178 <insert_sorted_with_merge_freeList+0x316>
							== iterator->sva) {
						prev->size = prev->size + blockToInsert->size
  8030b9:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8030bc:	8b 50 0c             	mov    0xc(%eax),%edx
  8030bf:	8b 45 08             	mov    0x8(%ebp),%eax
  8030c2:	8b 40 0c             	mov    0xc(%eax),%eax
  8030c5:	01 c2                	add    %eax,%edx
								+ iterator->size;
  8030c7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030ca:	8b 40 0c             	mov    0xc(%eax),%eax
  8030cd:	01 c2                	add    %eax,%edx
					break;
				} else {
					//prev and next merge
					if (prev->sva + prev->size + blockToInsert->size
							== iterator->sva) {
						prev->size = prev->size + blockToInsert->size
  8030cf:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8030d2:	89 50 0c             	mov    %edx,0xc(%eax)
								+ iterator->size;
						LIST_REMOVE(&FreeMemBlocksList, iterator);
  8030d5:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8030d9:	75 17                	jne    8030f2 <insert_sorted_with_merge_freeList+0x290>
  8030db:	83 ec 04             	sub    $0x4,%esp
  8030de:	68 08 41 80 00       	push   $0x804108
  8030e3:	68 43 01 00 00       	push   $0x143
  8030e8:	68 97 40 80 00       	push   $0x804097
  8030ed:	e8 dd d5 ff ff       	call   8006cf <_panic>
  8030f2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030f5:	8b 00                	mov    (%eax),%eax
  8030f7:	85 c0                	test   %eax,%eax
  8030f9:	74 10                	je     80310b <insert_sorted_with_merge_freeList+0x2a9>
  8030fb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030fe:	8b 00                	mov    (%eax),%eax
  803100:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803103:	8b 52 04             	mov    0x4(%edx),%edx
  803106:	89 50 04             	mov    %edx,0x4(%eax)
  803109:	eb 0b                	jmp    803116 <insert_sorted_with_merge_freeList+0x2b4>
  80310b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80310e:	8b 40 04             	mov    0x4(%eax),%eax
  803111:	a3 3c 51 80 00       	mov    %eax,0x80513c
  803116:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803119:	8b 40 04             	mov    0x4(%eax),%eax
  80311c:	85 c0                	test   %eax,%eax
  80311e:	74 0f                	je     80312f <insert_sorted_with_merge_freeList+0x2cd>
  803120:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803123:	8b 40 04             	mov    0x4(%eax),%eax
  803126:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803129:	8b 12                	mov    (%edx),%edx
  80312b:	89 10                	mov    %edx,(%eax)
  80312d:	eb 0a                	jmp    803139 <insert_sorted_with_merge_freeList+0x2d7>
  80312f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803132:	8b 00                	mov    (%eax),%eax
  803134:	a3 38 51 80 00       	mov    %eax,0x805138
  803139:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80313c:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803142:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803145:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80314c:	a1 44 51 80 00       	mov    0x805144,%eax
  803151:	48                   	dec    %eax
  803152:	a3 44 51 80 00       	mov    %eax,0x805144
						addToAvailMemBlocksList(blockToInsert);
  803157:	83 ec 0c             	sub    $0xc,%esp
  80315a:	ff 75 08             	pushl  0x8(%ebp)
  80315d:	e8 80 fc ff ff       	call   802de2 <addToAvailMemBlocksList>
  803162:	83 c4 10             	add    $0x10,%esp
						addToAvailMemBlocksList(iterator);
  803165:	83 ec 0c             	sub    $0xc,%esp
  803168:	ff 75 f4             	pushl  -0xc(%ebp)
  80316b:	e8 72 fc ff ff       	call   802de2 <addToAvailMemBlocksList>
  803170:	83 c4 10             	add    $0x10,%esp
					//Insert
					else {
						LIST_INSERT_BEFORE(&FreeMemBlocksList, iterator,
								blockToInsert);
					}
					break;
  803173:	e9 2e 01 00 00       	jmp    8032a6 <insert_sorted_with_merge_freeList+0x444>
						LIST_REMOVE(&FreeMemBlocksList, iterator);
						addToAvailMemBlocksList(blockToInsert);
						addToAvailMemBlocksList(iterator);
					}
					//previous merge
					else if (prev->sva + prev->size == blockToInsert->sva) {
  803178:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80317b:	8b 50 08             	mov    0x8(%eax),%edx
  80317e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803181:	8b 40 0c             	mov    0xc(%eax),%eax
  803184:	01 c2                	add    %eax,%edx
  803186:	8b 45 08             	mov    0x8(%ebp),%eax
  803189:	8b 40 08             	mov    0x8(%eax),%eax
  80318c:	39 c2                	cmp    %eax,%edx
  80318e:	75 27                	jne    8031b7 <insert_sorted_with_merge_freeList+0x355>
						prev->size = prev->size + blockToInsert->size;
  803190:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803193:	8b 50 0c             	mov    0xc(%eax),%edx
  803196:	8b 45 08             	mov    0x8(%ebp),%eax
  803199:	8b 40 0c             	mov    0xc(%eax),%eax
  80319c:	01 c2                	add    %eax,%edx
  80319e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8031a1:	89 50 0c             	mov    %edx,0xc(%eax)
						addToAvailMemBlocksList(blockToInsert);
  8031a4:	83 ec 0c             	sub    $0xc,%esp
  8031a7:	ff 75 08             	pushl  0x8(%ebp)
  8031aa:	e8 33 fc ff ff       	call   802de2 <addToAvailMemBlocksList>
  8031af:	83 c4 10             	add    $0x10,%esp
					//Insert
					else {
						LIST_INSERT_BEFORE(&FreeMemBlocksList, iterator,
								blockToInsert);
					}
					break;
  8031b2:	e9 ef 00 00 00       	jmp    8032a6 <insert_sorted_with_merge_freeList+0x444>
					else if (prev->sva + prev->size == blockToInsert->sva) {
						prev->size = prev->size + blockToInsert->size;
						addToAvailMemBlocksList(blockToInsert);
					}
					//next merge
					else if (blockToInsert->size + blockToInsert->sva
  8031b7:	8b 45 08             	mov    0x8(%ebp),%eax
  8031ba:	8b 50 0c             	mov    0xc(%eax),%edx
  8031bd:	8b 45 08             	mov    0x8(%ebp),%eax
  8031c0:	8b 40 08             	mov    0x8(%eax),%eax
  8031c3:	01 c2                	add    %eax,%edx
							== iterator->sva) {
  8031c5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8031c8:	8b 40 08             	mov    0x8(%eax),%eax
					else if (prev->sva + prev->size == blockToInsert->sva) {
						prev->size = prev->size + blockToInsert->size;
						addToAvailMemBlocksList(blockToInsert);
					}
					//next merge
					else if (blockToInsert->size + blockToInsert->sva
  8031cb:	39 c2                	cmp    %eax,%edx
  8031cd:	75 33                	jne    803202 <insert_sorted_with_merge_freeList+0x3a0>
							== iterator->sva) {
						iterator->sva = blockToInsert->sva;
  8031cf:	8b 45 08             	mov    0x8(%ebp),%eax
  8031d2:	8b 50 08             	mov    0x8(%eax),%edx
  8031d5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8031d8:	89 50 08             	mov    %edx,0x8(%eax)
						iterator->size = iterator->size + blockToInsert->size;
  8031db:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8031de:	8b 50 0c             	mov    0xc(%eax),%edx
  8031e1:	8b 45 08             	mov    0x8(%ebp),%eax
  8031e4:	8b 40 0c             	mov    0xc(%eax),%eax
  8031e7:	01 c2                	add    %eax,%edx
  8031e9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8031ec:	89 50 0c             	mov    %edx,0xc(%eax)
						addToAvailMemBlocksList(blockToInsert);
  8031ef:	83 ec 0c             	sub    $0xc,%esp
  8031f2:	ff 75 08             	pushl  0x8(%ebp)
  8031f5:	e8 e8 fb ff ff       	call   802de2 <addToAvailMemBlocksList>
  8031fa:	83 c4 10             	add    $0x10,%esp
					//Insert
					else {
						LIST_INSERT_BEFORE(&FreeMemBlocksList, iterator,
								blockToInsert);
					}
					break;
  8031fd:	e9 a4 00 00 00       	jmp    8032a6 <insert_sorted_with_merge_freeList+0x444>
						iterator->size = iterator->size + blockToInsert->size;
						addToAvailMemBlocksList(blockToInsert);
					}
					//Insert
					else {
						LIST_INSERT_BEFORE(&FreeMemBlocksList, iterator,
  803202:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803206:	74 06                	je     80320e <insert_sorted_with_merge_freeList+0x3ac>
  803208:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80320c:	75 17                	jne    803225 <insert_sorted_with_merge_freeList+0x3c3>
  80320e:	83 ec 04             	sub    $0x4,%esp
  803211:	68 28 41 80 00       	push   $0x804128
  803216:	68 56 01 00 00       	push   $0x156
  80321b:	68 97 40 80 00       	push   $0x804097
  803220:	e8 aa d4 ff ff       	call   8006cf <_panic>
  803225:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803228:	8b 50 04             	mov    0x4(%eax),%edx
  80322b:	8b 45 08             	mov    0x8(%ebp),%eax
  80322e:	89 50 04             	mov    %edx,0x4(%eax)
  803231:	8b 45 08             	mov    0x8(%ebp),%eax
  803234:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803237:	89 10                	mov    %edx,(%eax)
  803239:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80323c:	8b 40 04             	mov    0x4(%eax),%eax
  80323f:	85 c0                	test   %eax,%eax
  803241:	74 0d                	je     803250 <insert_sorted_with_merge_freeList+0x3ee>
  803243:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803246:	8b 40 04             	mov    0x4(%eax),%eax
  803249:	8b 55 08             	mov    0x8(%ebp),%edx
  80324c:	89 10                	mov    %edx,(%eax)
  80324e:	eb 08                	jmp    803258 <insert_sorted_with_merge_freeList+0x3f6>
  803250:	8b 45 08             	mov    0x8(%ebp),%eax
  803253:	a3 38 51 80 00       	mov    %eax,0x805138
  803258:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80325b:	8b 55 08             	mov    0x8(%ebp),%edx
  80325e:	89 50 04             	mov    %edx,0x4(%eax)
  803261:	a1 44 51 80 00       	mov    0x805144,%eax
  803266:	40                   	inc    %eax
  803267:	a3 44 51 80 00       	mov    %eax,0x805144
								blockToInsert);
					}
					break;
  80326c:	eb 38                	jmp    8032a6 <insert_sorted_with_merge_freeList+0x444>
		} else {
			LIST_INSERT_AFTER(&FreeMemBlocksList, last, blockToInsert);
		}
	} else {
		struct MemBlock *iterator;
		LIST_FOREACH(iterator, &(FreeMemBlocksList))
  80326e:	a1 40 51 80 00       	mov    0x805140,%eax
  803273:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803276:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80327a:	74 07                	je     803283 <insert_sorted_with_merge_freeList+0x421>
  80327c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80327f:	8b 00                	mov    (%eax),%eax
  803281:	eb 05                	jmp    803288 <insert_sorted_with_merge_freeList+0x426>
  803283:	b8 00 00 00 00       	mov    $0x0,%eax
  803288:	a3 40 51 80 00       	mov    %eax,0x805140
  80328d:	a1 40 51 80 00       	mov    0x805140,%eax
  803292:	85 c0                	test   %eax,%eax
  803294:	0f 85 1a fd ff ff    	jne    802fb4 <insert_sorted_with_merge_freeList+0x152>
  80329a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80329e:	0f 85 10 fd ff ff    	jne    802fb4 <insert_sorted_with_merge_freeList+0x152>
		}
	}

	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  8032a4:	eb 00                	jmp    8032a6 <insert_sorted_with_merge_freeList+0x444>
  8032a6:	90                   	nop
  8032a7:	c9                   	leave  
  8032a8:	c3                   	ret    
  8032a9:	66 90                	xchg   %ax,%ax
  8032ab:	90                   	nop

008032ac <__udivdi3>:
  8032ac:	55                   	push   %ebp
  8032ad:	57                   	push   %edi
  8032ae:	56                   	push   %esi
  8032af:	53                   	push   %ebx
  8032b0:	83 ec 1c             	sub    $0x1c,%esp
  8032b3:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  8032b7:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  8032bb:	8b 7c 24 38          	mov    0x38(%esp),%edi
  8032bf:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8032c3:	89 ca                	mov    %ecx,%edx
  8032c5:	89 f8                	mov    %edi,%eax
  8032c7:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  8032cb:	85 f6                	test   %esi,%esi
  8032cd:	75 2d                	jne    8032fc <__udivdi3+0x50>
  8032cf:	39 cf                	cmp    %ecx,%edi
  8032d1:	77 65                	ja     803338 <__udivdi3+0x8c>
  8032d3:	89 fd                	mov    %edi,%ebp
  8032d5:	85 ff                	test   %edi,%edi
  8032d7:	75 0b                	jne    8032e4 <__udivdi3+0x38>
  8032d9:	b8 01 00 00 00       	mov    $0x1,%eax
  8032de:	31 d2                	xor    %edx,%edx
  8032e0:	f7 f7                	div    %edi
  8032e2:	89 c5                	mov    %eax,%ebp
  8032e4:	31 d2                	xor    %edx,%edx
  8032e6:	89 c8                	mov    %ecx,%eax
  8032e8:	f7 f5                	div    %ebp
  8032ea:	89 c1                	mov    %eax,%ecx
  8032ec:	89 d8                	mov    %ebx,%eax
  8032ee:	f7 f5                	div    %ebp
  8032f0:	89 cf                	mov    %ecx,%edi
  8032f2:	89 fa                	mov    %edi,%edx
  8032f4:	83 c4 1c             	add    $0x1c,%esp
  8032f7:	5b                   	pop    %ebx
  8032f8:	5e                   	pop    %esi
  8032f9:	5f                   	pop    %edi
  8032fa:	5d                   	pop    %ebp
  8032fb:	c3                   	ret    
  8032fc:	39 ce                	cmp    %ecx,%esi
  8032fe:	77 28                	ja     803328 <__udivdi3+0x7c>
  803300:	0f bd fe             	bsr    %esi,%edi
  803303:	83 f7 1f             	xor    $0x1f,%edi
  803306:	75 40                	jne    803348 <__udivdi3+0x9c>
  803308:	39 ce                	cmp    %ecx,%esi
  80330a:	72 0a                	jb     803316 <__udivdi3+0x6a>
  80330c:	3b 44 24 08          	cmp    0x8(%esp),%eax
  803310:	0f 87 9e 00 00 00    	ja     8033b4 <__udivdi3+0x108>
  803316:	b8 01 00 00 00       	mov    $0x1,%eax
  80331b:	89 fa                	mov    %edi,%edx
  80331d:	83 c4 1c             	add    $0x1c,%esp
  803320:	5b                   	pop    %ebx
  803321:	5e                   	pop    %esi
  803322:	5f                   	pop    %edi
  803323:	5d                   	pop    %ebp
  803324:	c3                   	ret    
  803325:	8d 76 00             	lea    0x0(%esi),%esi
  803328:	31 ff                	xor    %edi,%edi
  80332a:	31 c0                	xor    %eax,%eax
  80332c:	89 fa                	mov    %edi,%edx
  80332e:	83 c4 1c             	add    $0x1c,%esp
  803331:	5b                   	pop    %ebx
  803332:	5e                   	pop    %esi
  803333:	5f                   	pop    %edi
  803334:	5d                   	pop    %ebp
  803335:	c3                   	ret    
  803336:	66 90                	xchg   %ax,%ax
  803338:	89 d8                	mov    %ebx,%eax
  80333a:	f7 f7                	div    %edi
  80333c:	31 ff                	xor    %edi,%edi
  80333e:	89 fa                	mov    %edi,%edx
  803340:	83 c4 1c             	add    $0x1c,%esp
  803343:	5b                   	pop    %ebx
  803344:	5e                   	pop    %esi
  803345:	5f                   	pop    %edi
  803346:	5d                   	pop    %ebp
  803347:	c3                   	ret    
  803348:	bd 20 00 00 00       	mov    $0x20,%ebp
  80334d:	89 eb                	mov    %ebp,%ebx
  80334f:	29 fb                	sub    %edi,%ebx
  803351:	89 f9                	mov    %edi,%ecx
  803353:	d3 e6                	shl    %cl,%esi
  803355:	89 c5                	mov    %eax,%ebp
  803357:	88 d9                	mov    %bl,%cl
  803359:	d3 ed                	shr    %cl,%ebp
  80335b:	89 e9                	mov    %ebp,%ecx
  80335d:	09 f1                	or     %esi,%ecx
  80335f:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  803363:	89 f9                	mov    %edi,%ecx
  803365:	d3 e0                	shl    %cl,%eax
  803367:	89 c5                	mov    %eax,%ebp
  803369:	89 d6                	mov    %edx,%esi
  80336b:	88 d9                	mov    %bl,%cl
  80336d:	d3 ee                	shr    %cl,%esi
  80336f:	89 f9                	mov    %edi,%ecx
  803371:	d3 e2                	shl    %cl,%edx
  803373:	8b 44 24 08          	mov    0x8(%esp),%eax
  803377:	88 d9                	mov    %bl,%cl
  803379:	d3 e8                	shr    %cl,%eax
  80337b:	09 c2                	or     %eax,%edx
  80337d:	89 d0                	mov    %edx,%eax
  80337f:	89 f2                	mov    %esi,%edx
  803381:	f7 74 24 0c          	divl   0xc(%esp)
  803385:	89 d6                	mov    %edx,%esi
  803387:	89 c3                	mov    %eax,%ebx
  803389:	f7 e5                	mul    %ebp
  80338b:	39 d6                	cmp    %edx,%esi
  80338d:	72 19                	jb     8033a8 <__udivdi3+0xfc>
  80338f:	74 0b                	je     80339c <__udivdi3+0xf0>
  803391:	89 d8                	mov    %ebx,%eax
  803393:	31 ff                	xor    %edi,%edi
  803395:	e9 58 ff ff ff       	jmp    8032f2 <__udivdi3+0x46>
  80339a:	66 90                	xchg   %ax,%ax
  80339c:	8b 54 24 08          	mov    0x8(%esp),%edx
  8033a0:	89 f9                	mov    %edi,%ecx
  8033a2:	d3 e2                	shl    %cl,%edx
  8033a4:	39 c2                	cmp    %eax,%edx
  8033a6:	73 e9                	jae    803391 <__udivdi3+0xe5>
  8033a8:	8d 43 ff             	lea    -0x1(%ebx),%eax
  8033ab:	31 ff                	xor    %edi,%edi
  8033ad:	e9 40 ff ff ff       	jmp    8032f2 <__udivdi3+0x46>
  8033b2:	66 90                	xchg   %ax,%ax
  8033b4:	31 c0                	xor    %eax,%eax
  8033b6:	e9 37 ff ff ff       	jmp    8032f2 <__udivdi3+0x46>
  8033bb:	90                   	nop

008033bc <__umoddi3>:
  8033bc:	55                   	push   %ebp
  8033bd:	57                   	push   %edi
  8033be:	56                   	push   %esi
  8033bf:	53                   	push   %ebx
  8033c0:	83 ec 1c             	sub    $0x1c,%esp
  8033c3:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  8033c7:	8b 74 24 34          	mov    0x34(%esp),%esi
  8033cb:	8b 7c 24 38          	mov    0x38(%esp),%edi
  8033cf:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  8033d3:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8033d7:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8033db:	89 f3                	mov    %esi,%ebx
  8033dd:	89 fa                	mov    %edi,%edx
  8033df:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8033e3:	89 34 24             	mov    %esi,(%esp)
  8033e6:	85 c0                	test   %eax,%eax
  8033e8:	75 1a                	jne    803404 <__umoddi3+0x48>
  8033ea:	39 f7                	cmp    %esi,%edi
  8033ec:	0f 86 a2 00 00 00    	jbe    803494 <__umoddi3+0xd8>
  8033f2:	89 c8                	mov    %ecx,%eax
  8033f4:	89 f2                	mov    %esi,%edx
  8033f6:	f7 f7                	div    %edi
  8033f8:	89 d0                	mov    %edx,%eax
  8033fa:	31 d2                	xor    %edx,%edx
  8033fc:	83 c4 1c             	add    $0x1c,%esp
  8033ff:	5b                   	pop    %ebx
  803400:	5e                   	pop    %esi
  803401:	5f                   	pop    %edi
  803402:	5d                   	pop    %ebp
  803403:	c3                   	ret    
  803404:	39 f0                	cmp    %esi,%eax
  803406:	0f 87 ac 00 00 00    	ja     8034b8 <__umoddi3+0xfc>
  80340c:	0f bd e8             	bsr    %eax,%ebp
  80340f:	83 f5 1f             	xor    $0x1f,%ebp
  803412:	0f 84 ac 00 00 00    	je     8034c4 <__umoddi3+0x108>
  803418:	bf 20 00 00 00       	mov    $0x20,%edi
  80341d:	29 ef                	sub    %ebp,%edi
  80341f:	89 fe                	mov    %edi,%esi
  803421:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  803425:	89 e9                	mov    %ebp,%ecx
  803427:	d3 e0                	shl    %cl,%eax
  803429:	89 d7                	mov    %edx,%edi
  80342b:	89 f1                	mov    %esi,%ecx
  80342d:	d3 ef                	shr    %cl,%edi
  80342f:	09 c7                	or     %eax,%edi
  803431:	89 e9                	mov    %ebp,%ecx
  803433:	d3 e2                	shl    %cl,%edx
  803435:	89 14 24             	mov    %edx,(%esp)
  803438:	89 d8                	mov    %ebx,%eax
  80343a:	d3 e0                	shl    %cl,%eax
  80343c:	89 c2                	mov    %eax,%edx
  80343e:	8b 44 24 08          	mov    0x8(%esp),%eax
  803442:	d3 e0                	shl    %cl,%eax
  803444:	89 44 24 04          	mov    %eax,0x4(%esp)
  803448:	8b 44 24 08          	mov    0x8(%esp),%eax
  80344c:	89 f1                	mov    %esi,%ecx
  80344e:	d3 e8                	shr    %cl,%eax
  803450:	09 d0                	or     %edx,%eax
  803452:	d3 eb                	shr    %cl,%ebx
  803454:	89 da                	mov    %ebx,%edx
  803456:	f7 f7                	div    %edi
  803458:	89 d3                	mov    %edx,%ebx
  80345a:	f7 24 24             	mull   (%esp)
  80345d:	89 c6                	mov    %eax,%esi
  80345f:	89 d1                	mov    %edx,%ecx
  803461:	39 d3                	cmp    %edx,%ebx
  803463:	0f 82 87 00 00 00    	jb     8034f0 <__umoddi3+0x134>
  803469:	0f 84 91 00 00 00    	je     803500 <__umoddi3+0x144>
  80346f:	8b 54 24 04          	mov    0x4(%esp),%edx
  803473:	29 f2                	sub    %esi,%edx
  803475:	19 cb                	sbb    %ecx,%ebx
  803477:	89 d8                	mov    %ebx,%eax
  803479:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  80347d:	d3 e0                	shl    %cl,%eax
  80347f:	89 e9                	mov    %ebp,%ecx
  803481:	d3 ea                	shr    %cl,%edx
  803483:	09 d0                	or     %edx,%eax
  803485:	89 e9                	mov    %ebp,%ecx
  803487:	d3 eb                	shr    %cl,%ebx
  803489:	89 da                	mov    %ebx,%edx
  80348b:	83 c4 1c             	add    $0x1c,%esp
  80348e:	5b                   	pop    %ebx
  80348f:	5e                   	pop    %esi
  803490:	5f                   	pop    %edi
  803491:	5d                   	pop    %ebp
  803492:	c3                   	ret    
  803493:	90                   	nop
  803494:	89 fd                	mov    %edi,%ebp
  803496:	85 ff                	test   %edi,%edi
  803498:	75 0b                	jne    8034a5 <__umoddi3+0xe9>
  80349a:	b8 01 00 00 00       	mov    $0x1,%eax
  80349f:	31 d2                	xor    %edx,%edx
  8034a1:	f7 f7                	div    %edi
  8034a3:	89 c5                	mov    %eax,%ebp
  8034a5:	89 f0                	mov    %esi,%eax
  8034a7:	31 d2                	xor    %edx,%edx
  8034a9:	f7 f5                	div    %ebp
  8034ab:	89 c8                	mov    %ecx,%eax
  8034ad:	f7 f5                	div    %ebp
  8034af:	89 d0                	mov    %edx,%eax
  8034b1:	e9 44 ff ff ff       	jmp    8033fa <__umoddi3+0x3e>
  8034b6:	66 90                	xchg   %ax,%ax
  8034b8:	89 c8                	mov    %ecx,%eax
  8034ba:	89 f2                	mov    %esi,%edx
  8034bc:	83 c4 1c             	add    $0x1c,%esp
  8034bf:	5b                   	pop    %ebx
  8034c0:	5e                   	pop    %esi
  8034c1:	5f                   	pop    %edi
  8034c2:	5d                   	pop    %ebp
  8034c3:	c3                   	ret    
  8034c4:	3b 04 24             	cmp    (%esp),%eax
  8034c7:	72 06                	jb     8034cf <__umoddi3+0x113>
  8034c9:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  8034cd:	77 0f                	ja     8034de <__umoddi3+0x122>
  8034cf:	89 f2                	mov    %esi,%edx
  8034d1:	29 f9                	sub    %edi,%ecx
  8034d3:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  8034d7:	89 14 24             	mov    %edx,(%esp)
  8034da:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8034de:	8b 44 24 04          	mov    0x4(%esp),%eax
  8034e2:	8b 14 24             	mov    (%esp),%edx
  8034e5:	83 c4 1c             	add    $0x1c,%esp
  8034e8:	5b                   	pop    %ebx
  8034e9:	5e                   	pop    %esi
  8034ea:	5f                   	pop    %edi
  8034eb:	5d                   	pop    %ebp
  8034ec:	c3                   	ret    
  8034ed:	8d 76 00             	lea    0x0(%esi),%esi
  8034f0:	2b 04 24             	sub    (%esp),%eax
  8034f3:	19 fa                	sbb    %edi,%edx
  8034f5:	89 d1                	mov    %edx,%ecx
  8034f7:	89 c6                	mov    %eax,%esi
  8034f9:	e9 71 ff ff ff       	jmp    80346f <__umoddi3+0xb3>
  8034fe:	66 90                	xchg   %ax,%ax
  803500:	39 44 24 04          	cmp    %eax,0x4(%esp)
  803504:	72 ea                	jb     8034f0 <__umoddi3+0x134>
  803506:	89 d9                	mov    %ebx,%ecx
  803508:	e9 62 ff ff ff       	jmp    80346f <__umoddi3+0xb3>
