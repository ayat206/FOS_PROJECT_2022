
obj/user/tst_sharing_4:     file format elf32-i386


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
  800031:	e8 41 05 00 00       	call   800577 <libmain>
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
  80008d:	68 00 35 80 00       	push   $0x803500
  800092:	6a 12                	push   $0x12
  800094:	68 1c 35 80 00       	push   $0x80351c
  800099:	e8 15 06 00 00       	call   8006b3 <_panic>
	}
	/*Dummy malloc to enforce the UHEAP initializations*/
	malloc(0);
  80009e:	83 ec 0c             	sub    $0xc,%esp
  8000a1:	6a 00                	push   $0x0
  8000a3:	e8 51 18 00 00       	call   8018f9 <malloc>
  8000a8:	83 c4 10             	add    $0x10,%esp
	/*=================================================*/

	cprintf("************************************************\n");
  8000ab:	83 ec 0c             	sub    $0xc,%esp
  8000ae:	68 34 35 80 00       	push   $0x803534
  8000b3:	e8 af 08 00 00       	call   800967 <cprintf>
  8000b8:	83 c4 10             	add    $0x10,%esp
	cprintf("MAKE SURE to have a FRESH RUN for this test\n(i.e. don't run any program/test before it)\n");
  8000bb:	83 ec 0c             	sub    $0xc,%esp
  8000be:	68 68 35 80 00       	push   $0x803568
  8000c3:	e8 9f 08 00 00       	call   800967 <cprintf>
  8000c8:	83 c4 10             	add    $0x10,%esp
	cprintf("************************************************\n\n\n");
  8000cb:	83 ec 0c             	sub    $0xc,%esp
  8000ce:	68 c4 35 80 00       	push   $0x8035c4
  8000d3:	e8 8f 08 00 00       	call   800967 <cprintf>
  8000d8:	83 c4 10             	add    $0x10,%esp

	int Mega = 1024*1024;
  8000db:	c7 45 ec 00 00 10 00 	movl   $0x100000,-0x14(%ebp)
	int kilo = 1024;
  8000e2:	c7 45 e8 00 04 00 00 	movl   $0x400,-0x18(%ebp)
	int envID = sys_getenvid();
  8000e9:	e8 de 1e 00 00       	call   801fcc <sys_getenvid>
  8000ee:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	cprintf("STEP A: checking free of a shared object ... \n");
  8000f1:	83 ec 0c             	sub    $0xc,%esp
  8000f4:	68 f8 35 80 00       	push   $0x8035f8
  8000f9:	e8 69 08 00 00       	call   800967 <cprintf>
  8000fe:	83 c4 10             	add    $0x10,%esp
	{
		uint32 *x;
		int freeFrames = sys_calculate_free_frames() ;
  800101:	e8 ff 1b 00 00       	call   801d05 <sys_calculate_free_frames>
  800106:	89 45 e0             	mov    %eax,-0x20(%ebp)
		x = smalloc("x", PAGE_SIZE, 1);
  800109:	83 ec 04             	sub    $0x4,%esp
  80010c:	6a 01                	push   $0x1
  80010e:	68 00 10 00 00       	push   $0x1000
  800113:	68 27 36 80 00       	push   $0x803627
  800118:	e8 24 19 00 00       	call   801a41 <smalloc>
  80011d:	83 c4 10             	add    $0x10,%esp
  800120:	89 45 dc             	mov    %eax,-0x24(%ebp)
		if (x != (uint32*)USER_HEAP_START) panic("Returned address is not correct. check the setting of it and/or the updating of the shared_mem_free_address");
  800123:	81 7d dc 00 00 00 80 	cmpl   $0x80000000,-0x24(%ebp)
  80012a:	74 14                	je     800140 <_main+0x108>
  80012c:	83 ec 04             	sub    $0x4,%esp
  80012f:	68 2c 36 80 00       	push   $0x80362c
  800134:	6a 24                	push   $0x24
  800136:	68 1c 35 80 00       	push   $0x80351c
  80013b:	e8 73 05 00 00       	call   8006b3 <_panic>
		if ((freeFrames - sys_calculate_free_frames()) !=  1+1+2) panic("Wrong allocation: make sure that you allocate the required space in the user environment and add its frames to frames_storage");
  800140:	8b 5d e0             	mov    -0x20(%ebp),%ebx
  800143:	e8 bd 1b 00 00       	call   801d05 <sys_calculate_free_frames>
  800148:	29 c3                	sub    %eax,%ebx
  80014a:	89 d8                	mov    %ebx,%eax
  80014c:	83 f8 04             	cmp    $0x4,%eax
  80014f:	74 14                	je     800165 <_main+0x12d>
  800151:	83 ec 04             	sub    $0x4,%esp
  800154:	68 98 36 80 00       	push   $0x803698
  800159:	6a 25                	push   $0x25
  80015b:	68 1c 35 80 00       	push   $0x80351c
  800160:	e8 4e 05 00 00       	call   8006b3 <_panic>

		sfree(x);
  800165:	83 ec 0c             	sub    $0xc,%esp
  800168:	ff 75 dc             	pushl  -0x24(%ebp)
  80016b:	e8 35 1a 00 00       	call   801ba5 <sfree>
  800170:	83 c4 10             	add    $0x10,%esp
		if ((freeFrames - sys_calculate_free_frames()) ==  0+0+2) panic("Wrong free: make sure that you free the shared object by calling free_share_object()");
  800173:	8b 5d e0             	mov    -0x20(%ebp),%ebx
  800176:	e8 8a 1b 00 00       	call   801d05 <sys_calculate_free_frames>
  80017b:	29 c3                	sub    %eax,%ebx
  80017d:	89 d8                	mov    %ebx,%eax
  80017f:	83 f8 02             	cmp    $0x2,%eax
  800182:	75 14                	jne    800198 <_main+0x160>
  800184:	83 ec 04             	sub    $0x4,%esp
  800187:	68 18 37 80 00       	push   $0x803718
  80018c:	6a 28                	push   $0x28
  80018e:	68 1c 35 80 00       	push   $0x80351c
  800193:	e8 1b 05 00 00       	call   8006b3 <_panic>
		else if ((freeFrames - sys_calculate_free_frames()) !=  0) panic("Wrong free: revise your freeSharedObject logic");
  800198:	e8 68 1b 00 00       	call   801d05 <sys_calculate_free_frames>
  80019d:	89 c2                	mov    %eax,%edx
  80019f:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8001a2:	39 c2                	cmp    %eax,%edx
  8001a4:	74 14                	je     8001ba <_main+0x182>
  8001a6:	83 ec 04             	sub    $0x4,%esp
  8001a9:	68 70 37 80 00       	push   $0x803770
  8001ae:	6a 29                	push   $0x29
  8001b0:	68 1c 35 80 00       	push   $0x80351c
  8001b5:	e8 f9 04 00 00       	call   8006b3 <_panic>
	}
	cprintf("Step A completed successfully!!\n\n\n");
  8001ba:	83 ec 0c             	sub    $0xc,%esp
  8001bd:	68 a0 37 80 00       	push   $0x8037a0
  8001c2:	e8 a0 07 00 00       	call   800967 <cprintf>
  8001c7:	83 c4 10             	add    $0x10,%esp


	cprintf("STEP B: checking free of 2 shared objects ... \n");
  8001ca:	83 ec 0c             	sub    $0xc,%esp
  8001cd:	68 c4 37 80 00       	push   $0x8037c4
  8001d2:	e8 90 07 00 00       	call   800967 <cprintf>
  8001d7:	83 c4 10             	add    $0x10,%esp
	{
		uint32 *x, *z ;
		int freeFrames = sys_calculate_free_frames() ;
  8001da:	e8 26 1b 00 00       	call   801d05 <sys_calculate_free_frames>
  8001df:	89 45 d8             	mov    %eax,-0x28(%ebp)
		z = smalloc("z", PAGE_SIZE, 1);
  8001e2:	83 ec 04             	sub    $0x4,%esp
  8001e5:	6a 01                	push   $0x1
  8001e7:	68 00 10 00 00       	push   $0x1000
  8001ec:	68 f4 37 80 00       	push   $0x8037f4
  8001f1:	e8 4b 18 00 00       	call   801a41 <smalloc>
  8001f6:	83 c4 10             	add    $0x10,%esp
  8001f9:	89 45 d4             	mov    %eax,-0x2c(%ebp)
		x = smalloc("x", PAGE_SIZE, 1);
  8001fc:	83 ec 04             	sub    $0x4,%esp
  8001ff:	6a 01                	push   $0x1
  800201:	68 00 10 00 00       	push   $0x1000
  800206:	68 27 36 80 00       	push   $0x803627
  80020b:	e8 31 18 00 00       	call   801a41 <smalloc>
  800210:	83 c4 10             	add    $0x10,%esp
  800213:	89 45 d0             	mov    %eax,-0x30(%ebp)

		if(x == NULL) panic("Wrong free: make sure that you free the shared object by calling free_share_object()");
  800216:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
  80021a:	75 14                	jne    800230 <_main+0x1f8>
  80021c:	83 ec 04             	sub    $0x4,%esp
  80021f:	68 18 37 80 00       	push   $0x803718
  800224:	6a 35                	push   $0x35
  800226:	68 1c 35 80 00       	push   $0x80351c
  80022b:	e8 83 04 00 00       	call   8006b3 <_panic>

		if ((freeFrames - sys_calculate_free_frames()) !=  2+1+4) panic("Wrong previous free: make sure that you correctly free shared object before (Step A)");
  800230:	8b 5d d8             	mov    -0x28(%ebp),%ebx
  800233:	e8 cd 1a 00 00       	call   801d05 <sys_calculate_free_frames>
  800238:	29 c3                	sub    %eax,%ebx
  80023a:	89 d8                	mov    %ebx,%eax
  80023c:	83 f8 07             	cmp    $0x7,%eax
  80023f:	74 14                	je     800255 <_main+0x21d>
  800241:	83 ec 04             	sub    $0x4,%esp
  800244:	68 f8 37 80 00       	push   $0x8037f8
  800249:	6a 37                	push   $0x37
  80024b:	68 1c 35 80 00       	push   $0x80351c
  800250:	e8 5e 04 00 00       	call   8006b3 <_panic>

		sfree(z);
  800255:	83 ec 0c             	sub    $0xc,%esp
  800258:	ff 75 d4             	pushl  -0x2c(%ebp)
  80025b:	e8 45 19 00 00       	call   801ba5 <sfree>
  800260:	83 c4 10             	add    $0x10,%esp
		if ((freeFrames - sys_calculate_free_frames()) !=  1+1+2) panic("Wrong free: check your logic");
  800263:	8b 5d d8             	mov    -0x28(%ebp),%ebx
  800266:	e8 9a 1a 00 00       	call   801d05 <sys_calculate_free_frames>
  80026b:	29 c3                	sub    %eax,%ebx
  80026d:	89 d8                	mov    %ebx,%eax
  80026f:	83 f8 04             	cmp    $0x4,%eax
  800272:	74 14                	je     800288 <_main+0x250>
  800274:	83 ec 04             	sub    $0x4,%esp
  800277:	68 4d 38 80 00       	push   $0x80384d
  80027c:	6a 3a                	push   $0x3a
  80027e:	68 1c 35 80 00       	push   $0x80351c
  800283:	e8 2b 04 00 00       	call   8006b3 <_panic>

		sfree(x);
  800288:	83 ec 0c             	sub    $0xc,%esp
  80028b:	ff 75 d0             	pushl  -0x30(%ebp)
  80028e:	e8 12 19 00 00       	call   801ba5 <sfree>
  800293:	83 c4 10             	add    $0x10,%esp
		if ((freeFrames - sys_calculate_free_frames()) !=  0) panic("Wrong free: check your logic");
  800296:	e8 6a 1a 00 00       	call   801d05 <sys_calculate_free_frames>
  80029b:	89 c2                	mov    %eax,%edx
  80029d:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8002a0:	39 c2                	cmp    %eax,%edx
  8002a2:	74 14                	je     8002b8 <_main+0x280>
  8002a4:	83 ec 04             	sub    $0x4,%esp
  8002a7:	68 4d 38 80 00       	push   $0x80384d
  8002ac:	6a 3d                	push   $0x3d
  8002ae:	68 1c 35 80 00       	push   $0x80351c
  8002b3:	e8 fb 03 00 00       	call   8006b3 <_panic>

	}
	cprintf("Step B completed successfully!!\n\n\n");
  8002b8:	83 ec 0c             	sub    $0xc,%esp
  8002bb:	68 6c 38 80 00       	push   $0x80386c
  8002c0:	e8 a2 06 00 00       	call   800967 <cprintf>
  8002c5:	83 c4 10             	add    $0x10,%esp

	cprintf("STEP C: checking range of loop during free... \n");
  8002c8:	83 ec 0c             	sub    $0xc,%esp
  8002cb:	68 90 38 80 00       	push   $0x803890
  8002d0:	e8 92 06 00 00       	call   800967 <cprintf>
  8002d5:	83 c4 10             	add    $0x10,%esp
	{
		uint32 *w, *u;
		int freeFrames = sys_calculate_free_frames() ;
  8002d8:	e8 28 1a 00 00       	call   801d05 <sys_calculate_free_frames>
  8002dd:	89 45 cc             	mov    %eax,-0x34(%ebp)
		w = smalloc("w", 3 * PAGE_SIZE+1, 1);
  8002e0:	83 ec 04             	sub    $0x4,%esp
  8002e3:	6a 01                	push   $0x1
  8002e5:	68 01 30 00 00       	push   $0x3001
  8002ea:	68 c0 38 80 00       	push   $0x8038c0
  8002ef:	e8 4d 17 00 00       	call   801a41 <smalloc>
  8002f4:	83 c4 10             	add    $0x10,%esp
  8002f7:	89 45 c8             	mov    %eax,-0x38(%ebp)
		u = smalloc("u", PAGE_SIZE, 1);
  8002fa:	83 ec 04             	sub    $0x4,%esp
  8002fd:	6a 01                	push   $0x1
  8002ff:	68 00 10 00 00       	push   $0x1000
  800304:	68 c2 38 80 00       	push   $0x8038c2
  800309:	e8 33 17 00 00       	call   801a41 <smalloc>
  80030e:	83 c4 10             	add    $0x10,%esp
  800311:	89 45 c4             	mov    %eax,-0x3c(%ebp)
		if ((freeFrames - sys_calculate_free_frames()) != 5+1+4) panic("Wrong allocation: make sure that you allocate the required space in the user environment and add its frames to frames_storage");
  800314:	8b 5d cc             	mov    -0x34(%ebp),%ebx
  800317:	e8 e9 19 00 00       	call   801d05 <sys_calculate_free_frames>
  80031c:	29 c3                	sub    %eax,%ebx
  80031e:	89 d8                	mov    %ebx,%eax
  800320:	83 f8 0a             	cmp    $0xa,%eax
  800323:	74 14                	je     800339 <_main+0x301>
  800325:	83 ec 04             	sub    $0x4,%esp
  800328:	68 98 36 80 00       	push   $0x803698
  80032d:	6a 48                	push   $0x48
  80032f:	68 1c 35 80 00       	push   $0x80351c
  800334:	e8 7a 03 00 00       	call   8006b3 <_panic>

		sfree(w);
  800339:	83 ec 0c             	sub    $0xc,%esp
  80033c:	ff 75 c8             	pushl  -0x38(%ebp)
  80033f:	e8 61 18 00 00       	call   801ba5 <sfree>
  800344:	83 c4 10             	add    $0x10,%esp
		if ((freeFrames - sys_calculate_free_frames()) !=  1+1+2) panic("Wrong free: check your logic");
  800347:	8b 5d cc             	mov    -0x34(%ebp),%ebx
  80034a:	e8 b6 19 00 00       	call   801d05 <sys_calculate_free_frames>
  80034f:	29 c3                	sub    %eax,%ebx
  800351:	89 d8                	mov    %ebx,%eax
  800353:	83 f8 04             	cmp    $0x4,%eax
  800356:	74 14                	je     80036c <_main+0x334>
  800358:	83 ec 04             	sub    $0x4,%esp
  80035b:	68 4d 38 80 00       	push   $0x80384d
  800360:	6a 4b                	push   $0x4b
  800362:	68 1c 35 80 00       	push   $0x80351c
  800367:	e8 47 03 00 00       	call   8006b3 <_panic>

		uint32 *o;

		o = smalloc("o", 2 * PAGE_SIZE-1,1);
  80036c:	83 ec 04             	sub    $0x4,%esp
  80036f:	6a 01                	push   $0x1
  800371:	68 ff 1f 00 00       	push   $0x1fff
  800376:	68 c4 38 80 00       	push   $0x8038c4
  80037b:	e8 c1 16 00 00       	call   801a41 <smalloc>
  800380:	83 c4 10             	add    $0x10,%esp
  800383:	89 45 c0             	mov    %eax,-0x40(%ebp)

		cprintf("2\n");
  800386:	83 ec 0c             	sub    $0xc,%esp
  800389:	68 c6 38 80 00       	push   $0x8038c6
  80038e:	e8 d4 05 00 00       	call   800967 <cprintf>
  800393:	83 c4 10             	add    $0x10,%esp
		if ((freeFrames - sys_calculate_free_frames()) != 3+1+4) panic("Wrong allocation: make sure that you allocate the required space in the user environment and add its frames to frames_storage");
  800396:	8b 5d cc             	mov    -0x34(%ebp),%ebx
  800399:	e8 67 19 00 00       	call   801d05 <sys_calculate_free_frames>
  80039e:	29 c3                	sub    %eax,%ebx
  8003a0:	89 d8                	mov    %ebx,%eax
  8003a2:	83 f8 08             	cmp    $0x8,%eax
  8003a5:	74 14                	je     8003bb <_main+0x383>
  8003a7:	83 ec 04             	sub    $0x4,%esp
  8003aa:	68 98 36 80 00       	push   $0x803698
  8003af:	6a 52                	push   $0x52
  8003b1:	68 1c 35 80 00       	push   $0x80351c
  8003b6:	e8 f8 02 00 00       	call   8006b3 <_panic>

		sfree(o);
  8003bb:	83 ec 0c             	sub    $0xc,%esp
  8003be:	ff 75 c0             	pushl  -0x40(%ebp)
  8003c1:	e8 df 17 00 00       	call   801ba5 <sfree>
  8003c6:	83 c4 10             	add    $0x10,%esp
		if ((freeFrames - sys_calculate_free_frames()) !=  1+1+2) panic("Wrong free: check your logic");
  8003c9:	8b 5d cc             	mov    -0x34(%ebp),%ebx
  8003cc:	e8 34 19 00 00       	call   801d05 <sys_calculate_free_frames>
  8003d1:	29 c3                	sub    %eax,%ebx
  8003d3:	89 d8                	mov    %ebx,%eax
  8003d5:	83 f8 04             	cmp    $0x4,%eax
  8003d8:	74 14                	je     8003ee <_main+0x3b6>
  8003da:	83 ec 04             	sub    $0x4,%esp
  8003dd:	68 4d 38 80 00       	push   $0x80384d
  8003e2:	6a 55                	push   $0x55
  8003e4:	68 1c 35 80 00       	push   $0x80351c
  8003e9:	e8 c5 02 00 00       	call   8006b3 <_panic>

		sfree(u);
  8003ee:	83 ec 0c             	sub    $0xc,%esp
  8003f1:	ff 75 c4             	pushl  -0x3c(%ebp)
  8003f4:	e8 ac 17 00 00       	call   801ba5 <sfree>
  8003f9:	83 c4 10             	add    $0x10,%esp
		if ((freeFrames - sys_calculate_free_frames()) !=  0) panic("Wrong free: check your logic");
  8003fc:	e8 04 19 00 00       	call   801d05 <sys_calculate_free_frames>
  800401:	89 c2                	mov    %eax,%edx
  800403:	8b 45 cc             	mov    -0x34(%ebp),%eax
  800406:	39 c2                	cmp    %eax,%edx
  800408:	74 14                	je     80041e <_main+0x3e6>
  80040a:	83 ec 04             	sub    $0x4,%esp
  80040d:	68 4d 38 80 00       	push   $0x80384d
  800412:	6a 58                	push   $0x58
  800414:	68 1c 35 80 00       	push   $0x80351c
  800419:	e8 95 02 00 00       	call   8006b3 <_panic>


		//Checking boundaries of page tables
		freeFrames = sys_calculate_free_frames() ;
  80041e:	e8 e2 18 00 00       	call   801d05 <sys_calculate_free_frames>
  800423:	89 45 cc             	mov    %eax,-0x34(%ebp)
		w = smalloc("w", 3 * Mega - 1*kilo, 1);
  800426:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800429:	89 c2                	mov    %eax,%edx
  80042b:	01 d2                	add    %edx,%edx
  80042d:	01 d0                	add    %edx,%eax
  80042f:	2b 45 e8             	sub    -0x18(%ebp),%eax
  800432:	83 ec 04             	sub    $0x4,%esp
  800435:	6a 01                	push   $0x1
  800437:	50                   	push   %eax
  800438:	68 c0 38 80 00       	push   $0x8038c0
  80043d:	e8 ff 15 00 00       	call   801a41 <smalloc>
  800442:	83 c4 10             	add    $0x10,%esp
  800445:	89 45 c8             	mov    %eax,-0x38(%ebp)
		u = smalloc("u", 7 * Mega - 1*kilo, 1);
  800448:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80044b:	89 d0                	mov    %edx,%eax
  80044d:	01 c0                	add    %eax,%eax
  80044f:	01 d0                	add    %edx,%eax
  800451:	01 c0                	add    %eax,%eax
  800453:	01 d0                	add    %edx,%eax
  800455:	2b 45 e8             	sub    -0x18(%ebp),%eax
  800458:	83 ec 04             	sub    $0x4,%esp
  80045b:	6a 01                	push   $0x1
  80045d:	50                   	push   %eax
  80045e:	68 c2 38 80 00       	push   $0x8038c2
  800463:	e8 d9 15 00 00       	call   801a41 <smalloc>
  800468:	83 c4 10             	add    $0x10,%esp
  80046b:	89 45 c4             	mov    %eax,-0x3c(%ebp)
		o = smalloc("o", 2 * Mega + 1*kilo, 1);
  80046e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800471:	01 c0                	add    %eax,%eax
  800473:	89 c2                	mov    %eax,%edx
  800475:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800478:	01 d0                	add    %edx,%eax
  80047a:	83 ec 04             	sub    $0x4,%esp
  80047d:	6a 01                	push   $0x1
  80047f:	50                   	push   %eax
  800480:	68 c4 38 80 00       	push   $0x8038c4
  800485:	e8 b7 15 00 00       	call   801a41 <smalloc>
  80048a:	83 c4 10             	add    $0x10,%esp
  80048d:	89 45 c0             	mov    %eax,-0x40(%ebp)

		if ((freeFrames - sys_calculate_free_frames()) != 3073+4+7) panic("Wrong allocation: make sure that you allocate the required space in the user environment and add its frames to frames_storage");
  800490:	8b 5d cc             	mov    -0x34(%ebp),%ebx
  800493:	e8 6d 18 00 00       	call   801d05 <sys_calculate_free_frames>
  800498:	29 c3                	sub    %eax,%ebx
  80049a:	89 d8                	mov    %ebx,%eax
  80049c:	3d 0c 0c 00 00       	cmp    $0xc0c,%eax
  8004a1:	74 14                	je     8004b7 <_main+0x47f>
  8004a3:	83 ec 04             	sub    $0x4,%esp
  8004a6:	68 98 36 80 00       	push   $0x803698
  8004ab:	6a 61                	push   $0x61
  8004ad:	68 1c 35 80 00       	push   $0x80351c
  8004b2:	e8 fc 01 00 00       	call   8006b3 <_panic>

		sfree(o);
  8004b7:	83 ec 0c             	sub    $0xc,%esp
  8004ba:	ff 75 c0             	pushl  -0x40(%ebp)
  8004bd:	e8 e3 16 00 00       	call   801ba5 <sfree>
  8004c2:	83 c4 10             	add    $0x10,%esp
		if ((freeFrames - sys_calculate_free_frames()) !=  2560+3+5) panic("Wrong free: check your logic");
  8004c5:	8b 5d cc             	mov    -0x34(%ebp),%ebx
  8004c8:	e8 38 18 00 00       	call   801d05 <sys_calculate_free_frames>
  8004cd:	29 c3                	sub    %eax,%ebx
  8004cf:	89 d8                	mov    %ebx,%eax
  8004d1:	3d 08 0a 00 00       	cmp    $0xa08,%eax
  8004d6:	74 14                	je     8004ec <_main+0x4b4>
  8004d8:	83 ec 04             	sub    $0x4,%esp
  8004db:	68 4d 38 80 00       	push   $0x80384d
  8004e0:	6a 64                	push   $0x64
  8004e2:	68 1c 35 80 00       	push   $0x80351c
  8004e7:	e8 c7 01 00 00       	call   8006b3 <_panic>

		sfree(w);
  8004ec:	83 ec 0c             	sub    $0xc,%esp
  8004ef:	ff 75 c8             	pushl  -0x38(%ebp)
  8004f2:	e8 ae 16 00 00       	call   801ba5 <sfree>
  8004f7:	83 c4 10             	add    $0x10,%esp
		if ((freeFrames - sys_calculate_free_frames()) !=  1792+3+3) panic("Wrong free: check your logic");
  8004fa:	8b 5d cc             	mov    -0x34(%ebp),%ebx
  8004fd:	e8 03 18 00 00       	call   801d05 <sys_calculate_free_frames>
  800502:	29 c3                	sub    %eax,%ebx
  800504:	89 d8                	mov    %ebx,%eax
  800506:	3d 06 07 00 00       	cmp    $0x706,%eax
  80050b:	74 14                	je     800521 <_main+0x4e9>
  80050d:	83 ec 04             	sub    $0x4,%esp
  800510:	68 4d 38 80 00       	push   $0x80384d
  800515:	6a 67                	push   $0x67
  800517:	68 1c 35 80 00       	push   $0x80351c
  80051c:	e8 92 01 00 00       	call   8006b3 <_panic>

		sfree(u);
  800521:	83 ec 0c             	sub    $0xc,%esp
  800524:	ff 75 c4             	pushl  -0x3c(%ebp)
  800527:	e8 79 16 00 00       	call   801ba5 <sfree>
  80052c:	83 c4 10             	add    $0x10,%esp
		if ((freeFrames - sys_calculate_free_frames()) !=  0) panic("Wrong free: check your logic");
  80052f:	e8 d1 17 00 00       	call   801d05 <sys_calculate_free_frames>
  800534:	89 c2                	mov    %eax,%edx
  800536:	8b 45 cc             	mov    -0x34(%ebp),%eax
  800539:	39 c2                	cmp    %eax,%edx
  80053b:	74 14                	je     800551 <_main+0x519>
  80053d:	83 ec 04             	sub    $0x4,%esp
  800540:	68 4d 38 80 00       	push   $0x80384d
  800545:	6a 6a                	push   $0x6a
  800547:	68 1c 35 80 00       	push   $0x80351c
  80054c:	e8 62 01 00 00       	call   8006b3 <_panic>
	}
	cprintf("Step C completed successfully!!\n\n\n");
  800551:	83 ec 0c             	sub    $0xc,%esp
  800554:	68 cc 38 80 00       	push   $0x8038cc
  800559:	e8 09 04 00 00       	call   800967 <cprintf>
  80055e:	83 c4 10             	add    $0x10,%esp

	cprintf("Congratulations!! Test of freeSharedObjects [4] completed successfully!!\n\n\n");
  800561:	83 ec 0c             	sub    $0xc,%esp
  800564:	68 f0 38 80 00       	push   $0x8038f0
  800569:	e8 f9 03 00 00       	call   800967 <cprintf>
  80056e:	83 c4 10             	add    $0x10,%esp

	return;
  800571:	90                   	nop
}
  800572:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800575:	c9                   	leave  
  800576:	c3                   	ret    

00800577 <libmain>:
volatile struct Env *myEnv = NULL;
volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";

void
libmain(int argc, char **argv)
{
  800577:	55                   	push   %ebp
  800578:	89 e5                	mov    %esp,%ebp
  80057a:	83 ec 18             	sub    $0x18,%esp
	int envIndex = sys_getenvindex();
  80057d:	e8 63 1a 00 00       	call   801fe5 <sys_getenvindex>
  800582:	89 45 f4             	mov    %eax,-0xc(%ebp)
	myEnv = &(envs[envIndex]);
  800585:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800588:	89 d0                	mov    %edx,%eax
  80058a:	c1 e0 03             	shl    $0x3,%eax
  80058d:	01 d0                	add    %edx,%eax
  80058f:	01 c0                	add    %eax,%eax
  800591:	01 d0                	add    %edx,%eax
  800593:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80059a:	01 d0                	add    %edx,%eax
  80059c:	c1 e0 04             	shl    $0x4,%eax
  80059f:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  8005a4:	a3 20 50 80 00       	mov    %eax,0x805020

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  8005a9:	a1 20 50 80 00       	mov    0x805020,%eax
  8005ae:	8a 80 5c 05 00 00    	mov    0x55c(%eax),%al
  8005b4:	84 c0                	test   %al,%al
  8005b6:	74 0f                	je     8005c7 <libmain+0x50>
		binaryname = myEnv->prog_name;
  8005b8:	a1 20 50 80 00       	mov    0x805020,%eax
  8005bd:	05 5c 05 00 00       	add    $0x55c,%eax
  8005c2:	a3 00 50 80 00       	mov    %eax,0x805000

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  8005c7:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8005cb:	7e 0a                	jle    8005d7 <libmain+0x60>
		binaryname = argv[0];
  8005cd:	8b 45 0c             	mov    0xc(%ebp),%eax
  8005d0:	8b 00                	mov    (%eax),%eax
  8005d2:	a3 00 50 80 00       	mov    %eax,0x805000

	// call user main routine
	_main(argc, argv);
  8005d7:	83 ec 08             	sub    $0x8,%esp
  8005da:	ff 75 0c             	pushl  0xc(%ebp)
  8005dd:	ff 75 08             	pushl  0x8(%ebp)
  8005e0:	e8 53 fa ff ff       	call   800038 <_main>
  8005e5:	83 c4 10             	add    $0x10,%esp



	sys_disable_interrupt();
  8005e8:	e8 05 18 00 00       	call   801df2 <sys_disable_interrupt>
	cprintf("**************************************\n");
  8005ed:	83 ec 0c             	sub    $0xc,%esp
  8005f0:	68 54 39 80 00       	push   $0x803954
  8005f5:	e8 6d 03 00 00       	call   800967 <cprintf>
  8005fa:	83 c4 10             	add    $0x10,%esp
	cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  8005fd:	a1 20 50 80 00       	mov    0x805020,%eax
  800602:	8b 90 44 05 00 00    	mov    0x544(%eax),%edx
  800608:	a1 20 50 80 00       	mov    0x805020,%eax
  80060d:	8b 80 34 05 00 00    	mov    0x534(%eax),%eax
  800613:	83 ec 04             	sub    $0x4,%esp
  800616:	52                   	push   %edx
  800617:	50                   	push   %eax
  800618:	68 7c 39 80 00       	push   $0x80397c
  80061d:	e8 45 03 00 00       	call   800967 <cprintf>
  800622:	83 c4 10             	add    $0x10,%esp
	cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  800625:	a1 20 50 80 00       	mov    0x805020,%eax
  80062a:	8b 88 54 05 00 00    	mov    0x554(%eax),%ecx
  800630:	a1 20 50 80 00       	mov    0x805020,%eax
  800635:	8b 90 50 05 00 00    	mov    0x550(%eax),%edx
  80063b:	a1 20 50 80 00       	mov    0x805020,%eax
  800640:	8b 80 4c 05 00 00    	mov    0x54c(%eax),%eax
  800646:	51                   	push   %ecx
  800647:	52                   	push   %edx
  800648:	50                   	push   %eax
  800649:	68 a4 39 80 00       	push   $0x8039a4
  80064e:	e8 14 03 00 00       	call   800967 <cprintf>
  800653:	83 c4 10             	add    $0x10,%esp
	//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
	cprintf("Num of clocks = %d\n", myEnv->nClocks);
  800656:	a1 20 50 80 00       	mov    0x805020,%eax
  80065b:	8b 80 a4 05 00 00    	mov    0x5a4(%eax),%eax
  800661:	83 ec 08             	sub    $0x8,%esp
  800664:	50                   	push   %eax
  800665:	68 fc 39 80 00       	push   $0x8039fc
  80066a:	e8 f8 02 00 00       	call   800967 <cprintf>
  80066f:	83 c4 10             	add    $0x10,%esp
	cprintf("**************************************\n");
  800672:	83 ec 0c             	sub    $0xc,%esp
  800675:	68 54 39 80 00       	push   $0x803954
  80067a:	e8 e8 02 00 00       	call   800967 <cprintf>
  80067f:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  800682:	e8 85 17 00 00       	call   801e0c <sys_enable_interrupt>

	// exit gracefully
	exit();
  800687:	e8 19 00 00 00       	call   8006a5 <exit>
}
  80068c:	90                   	nop
  80068d:	c9                   	leave  
  80068e:	c3                   	ret    

0080068f <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  80068f:	55                   	push   %ebp
  800690:	89 e5                	mov    %esp,%ebp
  800692:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  800695:	83 ec 0c             	sub    $0xc,%esp
  800698:	6a 00                	push   $0x0
  80069a:	e8 12 19 00 00       	call   801fb1 <sys_destroy_env>
  80069f:	83 c4 10             	add    $0x10,%esp
}
  8006a2:	90                   	nop
  8006a3:	c9                   	leave  
  8006a4:	c3                   	ret    

008006a5 <exit>:

void
exit(void)
{
  8006a5:	55                   	push   %ebp
  8006a6:	89 e5                	mov    %esp,%ebp
  8006a8:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  8006ab:	e8 67 19 00 00       	call   802017 <sys_exit_env>
}
  8006b0:	90                   	nop
  8006b1:	c9                   	leave  
  8006b2:	c3                   	ret    

008006b3 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  8006b3:	55                   	push   %ebp
  8006b4:	89 e5                	mov    %esp,%ebp
  8006b6:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  8006b9:	8d 45 10             	lea    0x10(%ebp),%eax
  8006bc:	83 c0 04             	add    $0x4,%eax
  8006bf:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  8006c2:	a1 5c 51 80 00       	mov    0x80515c,%eax
  8006c7:	85 c0                	test   %eax,%eax
  8006c9:	74 16                	je     8006e1 <_panic+0x2e>
		cprintf("%s: ", argv0);
  8006cb:	a1 5c 51 80 00       	mov    0x80515c,%eax
  8006d0:	83 ec 08             	sub    $0x8,%esp
  8006d3:	50                   	push   %eax
  8006d4:	68 10 3a 80 00       	push   $0x803a10
  8006d9:	e8 89 02 00 00       	call   800967 <cprintf>
  8006de:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  8006e1:	a1 00 50 80 00       	mov    0x805000,%eax
  8006e6:	ff 75 0c             	pushl  0xc(%ebp)
  8006e9:	ff 75 08             	pushl  0x8(%ebp)
  8006ec:	50                   	push   %eax
  8006ed:	68 15 3a 80 00       	push   $0x803a15
  8006f2:	e8 70 02 00 00       	call   800967 <cprintf>
  8006f7:	83 c4 10             	add    $0x10,%esp
	vcprintf(fmt, ap);
  8006fa:	8b 45 10             	mov    0x10(%ebp),%eax
  8006fd:	83 ec 08             	sub    $0x8,%esp
  800700:	ff 75 f4             	pushl  -0xc(%ebp)
  800703:	50                   	push   %eax
  800704:	e8 f3 01 00 00       	call   8008fc <vcprintf>
  800709:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  80070c:	83 ec 08             	sub    $0x8,%esp
  80070f:	6a 00                	push   $0x0
  800711:	68 31 3a 80 00       	push   $0x803a31
  800716:	e8 e1 01 00 00       	call   8008fc <vcprintf>
  80071b:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  80071e:	e8 82 ff ff ff       	call   8006a5 <exit>

	// should not return here
	while (1) ;
  800723:	eb fe                	jmp    800723 <_panic+0x70>

00800725 <CheckWSWithoutLastIndex>:
}

void CheckWSWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  800725:	55                   	push   %ebp
  800726:	89 e5                	mov    %esp,%ebp
  800728:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  80072b:	a1 20 50 80 00       	mov    0x805020,%eax
  800730:	8b 50 74             	mov    0x74(%eax),%edx
  800733:	8b 45 0c             	mov    0xc(%ebp),%eax
  800736:	39 c2                	cmp    %eax,%edx
  800738:	74 14                	je     80074e <CheckWSWithoutLastIndex+0x29>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  80073a:	83 ec 04             	sub    $0x4,%esp
  80073d:	68 34 3a 80 00       	push   $0x803a34
  800742:	6a 26                	push   $0x26
  800744:	68 80 3a 80 00       	push   $0x803a80
  800749:	e8 65 ff ff ff       	call   8006b3 <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  80074e:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  800755:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  80075c:	e9 c2 00 00 00       	jmp    800823 <CheckWSWithoutLastIndex+0xfe>
		if (expectedPages[e] == 0) {
  800761:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800764:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80076b:	8b 45 08             	mov    0x8(%ebp),%eax
  80076e:	01 d0                	add    %edx,%eax
  800770:	8b 00                	mov    (%eax),%eax
  800772:	85 c0                	test   %eax,%eax
  800774:	75 08                	jne    80077e <CheckWSWithoutLastIndex+0x59>
			expectedNumOfEmptyLocs++;
  800776:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  800779:	e9 a2 00 00 00       	jmp    800820 <CheckWSWithoutLastIndex+0xfb>
		}
		int found = 0;
  80077e:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800785:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  80078c:	eb 69                	jmp    8007f7 <CheckWSWithoutLastIndex+0xd2>
			if (myEnv->__uptr_pws[w].empty == 0) {
  80078e:	a1 20 50 80 00       	mov    0x805020,%eax
  800793:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  800799:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80079c:	89 d0                	mov    %edx,%eax
  80079e:	01 c0                	add    %eax,%eax
  8007a0:	01 d0                	add    %edx,%eax
  8007a2:	c1 e0 03             	shl    $0x3,%eax
  8007a5:	01 c8                	add    %ecx,%eax
  8007a7:	8a 40 04             	mov    0x4(%eax),%al
  8007aa:	84 c0                	test   %al,%al
  8007ac:	75 46                	jne    8007f4 <CheckWSWithoutLastIndex+0xcf>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  8007ae:	a1 20 50 80 00       	mov    0x805020,%eax
  8007b3:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  8007b9:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8007bc:	89 d0                	mov    %edx,%eax
  8007be:	01 c0                	add    %eax,%eax
  8007c0:	01 d0                	add    %edx,%eax
  8007c2:	c1 e0 03             	shl    $0x3,%eax
  8007c5:	01 c8                	add    %ecx,%eax
  8007c7:	8b 00                	mov    (%eax),%eax
  8007c9:	89 45 dc             	mov    %eax,-0x24(%ebp)
  8007cc:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8007cf:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8007d4:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  8007d6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8007d9:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  8007e0:	8b 45 08             	mov    0x8(%ebp),%eax
  8007e3:	01 c8                	add    %ecx,%eax
  8007e5:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  8007e7:	39 c2                	cmp    %eax,%edx
  8007e9:	75 09                	jne    8007f4 <CheckWSWithoutLastIndex+0xcf>
						== expectedPages[e]) {
					found = 1;
  8007eb:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  8007f2:	eb 12                	jmp    800806 <CheckWSWithoutLastIndex+0xe1>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8007f4:	ff 45 e8             	incl   -0x18(%ebp)
  8007f7:	a1 20 50 80 00       	mov    0x805020,%eax
  8007fc:	8b 50 74             	mov    0x74(%eax),%edx
  8007ff:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800802:	39 c2                	cmp    %eax,%edx
  800804:	77 88                	ja     80078e <CheckWSWithoutLastIndex+0x69>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  800806:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  80080a:	75 14                	jne    800820 <CheckWSWithoutLastIndex+0xfb>
			panic(
  80080c:	83 ec 04             	sub    $0x4,%esp
  80080f:	68 8c 3a 80 00       	push   $0x803a8c
  800814:	6a 3a                	push   $0x3a
  800816:	68 80 3a 80 00       	push   $0x803a80
  80081b:	e8 93 fe ff ff       	call   8006b3 <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  800820:	ff 45 f0             	incl   -0x10(%ebp)
  800823:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800826:	3b 45 0c             	cmp    0xc(%ebp),%eax
  800829:	0f 8c 32 ff ff ff    	jl     800761 <CheckWSWithoutLastIndex+0x3c>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  80082f:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800836:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  80083d:	eb 26                	jmp    800865 <CheckWSWithoutLastIndex+0x140>
		if (myEnv->__uptr_pws[w].empty == 1) {
  80083f:	a1 20 50 80 00       	mov    0x805020,%eax
  800844:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  80084a:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80084d:	89 d0                	mov    %edx,%eax
  80084f:	01 c0                	add    %eax,%eax
  800851:	01 d0                	add    %edx,%eax
  800853:	c1 e0 03             	shl    $0x3,%eax
  800856:	01 c8                	add    %ecx,%eax
  800858:	8a 40 04             	mov    0x4(%eax),%al
  80085b:	3c 01                	cmp    $0x1,%al
  80085d:	75 03                	jne    800862 <CheckWSWithoutLastIndex+0x13d>
			actualNumOfEmptyLocs++;
  80085f:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800862:	ff 45 e0             	incl   -0x20(%ebp)
  800865:	a1 20 50 80 00       	mov    0x805020,%eax
  80086a:	8b 50 74             	mov    0x74(%eax),%edx
  80086d:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800870:	39 c2                	cmp    %eax,%edx
  800872:	77 cb                	ja     80083f <CheckWSWithoutLastIndex+0x11a>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  800874:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800877:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  80087a:	74 14                	je     800890 <CheckWSWithoutLastIndex+0x16b>
		panic(
  80087c:	83 ec 04             	sub    $0x4,%esp
  80087f:	68 e0 3a 80 00       	push   $0x803ae0
  800884:	6a 44                	push   $0x44
  800886:	68 80 3a 80 00       	push   $0x803a80
  80088b:	e8 23 fe ff ff       	call   8006b3 <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  800890:	90                   	nop
  800891:	c9                   	leave  
  800892:	c3                   	ret    

00800893 <putch>:
};

//2017:
uint8 printProgName = 0;

static void putch(int ch, struct printbuf *b) {
  800893:	55                   	push   %ebp
  800894:	89 e5                	mov    %esp,%ebp
  800896:	83 ec 08             	sub    $0x8,%esp
	b->buf[b->idx++] = ch;
  800899:	8b 45 0c             	mov    0xc(%ebp),%eax
  80089c:	8b 00                	mov    (%eax),%eax
  80089e:	8d 48 01             	lea    0x1(%eax),%ecx
  8008a1:	8b 55 0c             	mov    0xc(%ebp),%edx
  8008a4:	89 0a                	mov    %ecx,(%edx)
  8008a6:	8b 55 08             	mov    0x8(%ebp),%edx
  8008a9:	88 d1                	mov    %dl,%cl
  8008ab:	8b 55 0c             	mov    0xc(%ebp),%edx
  8008ae:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  8008b2:	8b 45 0c             	mov    0xc(%ebp),%eax
  8008b5:	8b 00                	mov    (%eax),%eax
  8008b7:	3d ff 00 00 00       	cmp    $0xff,%eax
  8008bc:	75 2c                	jne    8008ea <putch+0x57>
		sys_cputs(b->buf, b->idx, printProgName);
  8008be:	a0 24 50 80 00       	mov    0x805024,%al
  8008c3:	0f b6 c0             	movzbl %al,%eax
  8008c6:	8b 55 0c             	mov    0xc(%ebp),%edx
  8008c9:	8b 12                	mov    (%edx),%edx
  8008cb:	89 d1                	mov    %edx,%ecx
  8008cd:	8b 55 0c             	mov    0xc(%ebp),%edx
  8008d0:	83 c2 08             	add    $0x8,%edx
  8008d3:	83 ec 04             	sub    $0x4,%esp
  8008d6:	50                   	push   %eax
  8008d7:	51                   	push   %ecx
  8008d8:	52                   	push   %edx
  8008d9:	e8 66 13 00 00       	call   801c44 <sys_cputs>
  8008de:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  8008e1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8008e4:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  8008ea:	8b 45 0c             	mov    0xc(%ebp),%eax
  8008ed:	8b 40 04             	mov    0x4(%eax),%eax
  8008f0:	8d 50 01             	lea    0x1(%eax),%edx
  8008f3:	8b 45 0c             	mov    0xc(%ebp),%eax
  8008f6:	89 50 04             	mov    %edx,0x4(%eax)
}
  8008f9:	90                   	nop
  8008fa:	c9                   	leave  
  8008fb:	c3                   	ret    

008008fc <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  8008fc:	55                   	push   %ebp
  8008fd:	89 e5                	mov    %esp,%ebp
  8008ff:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  800905:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  80090c:	00 00 00 
	b.cnt = 0;
  80090f:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  800916:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  800919:	ff 75 0c             	pushl  0xc(%ebp)
  80091c:	ff 75 08             	pushl  0x8(%ebp)
  80091f:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800925:	50                   	push   %eax
  800926:	68 93 08 80 00       	push   $0x800893
  80092b:	e8 11 02 00 00       	call   800b41 <vprintfmt>
  800930:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName);
  800933:	a0 24 50 80 00       	mov    0x805024,%al
  800938:	0f b6 c0             	movzbl %al,%eax
  80093b:	8b 95 f0 fe ff ff    	mov    -0x110(%ebp),%edx
  800941:	83 ec 04             	sub    $0x4,%esp
  800944:	50                   	push   %eax
  800945:	52                   	push   %edx
  800946:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  80094c:	83 c0 08             	add    $0x8,%eax
  80094f:	50                   	push   %eax
  800950:	e8 ef 12 00 00       	call   801c44 <sys_cputs>
  800955:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  800958:	c6 05 24 50 80 00 00 	movb   $0x0,0x805024
	return b.cnt;
  80095f:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  800965:	c9                   	leave  
  800966:	c3                   	ret    

00800967 <cprintf>:

int cprintf(const char *fmt, ...) {
  800967:	55                   	push   %ebp
  800968:	89 e5                	mov    %esp,%ebp
  80096a:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  80096d:	c6 05 24 50 80 00 01 	movb   $0x1,0x805024
	va_start(ap, fmt);
  800974:	8d 45 0c             	lea    0xc(%ebp),%eax
  800977:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  80097a:	8b 45 08             	mov    0x8(%ebp),%eax
  80097d:	83 ec 08             	sub    $0x8,%esp
  800980:	ff 75 f4             	pushl  -0xc(%ebp)
  800983:	50                   	push   %eax
  800984:	e8 73 ff ff ff       	call   8008fc <vcprintf>
  800989:	83 c4 10             	add    $0x10,%esp
  80098c:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  80098f:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800992:	c9                   	leave  
  800993:	c3                   	ret    

00800994 <atomic_cprintf>:

int atomic_cprintf(const char *fmt, ...) {
  800994:	55                   	push   %ebp
  800995:	89 e5                	mov    %esp,%ebp
  800997:	83 ec 18             	sub    $0x18,%esp
	sys_disable_interrupt();
  80099a:	e8 53 14 00 00       	call   801df2 <sys_disable_interrupt>
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  80099f:	8d 45 0c             	lea    0xc(%ebp),%eax
  8009a2:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  8009a5:	8b 45 08             	mov    0x8(%ebp),%eax
  8009a8:	83 ec 08             	sub    $0x8,%esp
  8009ab:	ff 75 f4             	pushl  -0xc(%ebp)
  8009ae:	50                   	push   %eax
  8009af:	e8 48 ff ff ff       	call   8008fc <vcprintf>
  8009b4:	83 c4 10             	add    $0x10,%esp
  8009b7:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	sys_enable_interrupt();
  8009ba:	e8 4d 14 00 00       	call   801e0c <sys_enable_interrupt>
	return cnt;
  8009bf:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8009c2:	c9                   	leave  
  8009c3:	c3                   	ret    

008009c4 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  8009c4:	55                   	push   %ebp
  8009c5:	89 e5                	mov    %esp,%ebp
  8009c7:	53                   	push   %ebx
  8009c8:	83 ec 14             	sub    $0x14,%esp
  8009cb:	8b 45 10             	mov    0x10(%ebp),%eax
  8009ce:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8009d1:	8b 45 14             	mov    0x14(%ebp),%eax
  8009d4:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  8009d7:	8b 45 18             	mov    0x18(%ebp),%eax
  8009da:	ba 00 00 00 00       	mov    $0x0,%edx
  8009df:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  8009e2:	77 55                	ja     800a39 <printnum+0x75>
  8009e4:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  8009e7:	72 05                	jb     8009ee <printnum+0x2a>
  8009e9:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8009ec:	77 4b                	ja     800a39 <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  8009ee:	8b 45 1c             	mov    0x1c(%ebp),%eax
  8009f1:	8d 58 ff             	lea    -0x1(%eax),%ebx
  8009f4:	8b 45 18             	mov    0x18(%ebp),%eax
  8009f7:	ba 00 00 00 00       	mov    $0x0,%edx
  8009fc:	52                   	push   %edx
  8009fd:	50                   	push   %eax
  8009fe:	ff 75 f4             	pushl  -0xc(%ebp)
  800a01:	ff 75 f0             	pushl  -0x10(%ebp)
  800a04:	e8 87 28 00 00       	call   803290 <__udivdi3>
  800a09:	83 c4 10             	add    $0x10,%esp
  800a0c:	83 ec 04             	sub    $0x4,%esp
  800a0f:	ff 75 20             	pushl  0x20(%ebp)
  800a12:	53                   	push   %ebx
  800a13:	ff 75 18             	pushl  0x18(%ebp)
  800a16:	52                   	push   %edx
  800a17:	50                   	push   %eax
  800a18:	ff 75 0c             	pushl  0xc(%ebp)
  800a1b:	ff 75 08             	pushl  0x8(%ebp)
  800a1e:	e8 a1 ff ff ff       	call   8009c4 <printnum>
  800a23:	83 c4 20             	add    $0x20,%esp
  800a26:	eb 1a                	jmp    800a42 <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  800a28:	83 ec 08             	sub    $0x8,%esp
  800a2b:	ff 75 0c             	pushl  0xc(%ebp)
  800a2e:	ff 75 20             	pushl  0x20(%ebp)
  800a31:	8b 45 08             	mov    0x8(%ebp),%eax
  800a34:	ff d0                	call   *%eax
  800a36:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800a39:	ff 4d 1c             	decl   0x1c(%ebp)
  800a3c:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  800a40:	7f e6                	jg     800a28 <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800a42:	8b 4d 18             	mov    0x18(%ebp),%ecx
  800a45:	bb 00 00 00 00       	mov    $0x0,%ebx
  800a4a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800a4d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800a50:	53                   	push   %ebx
  800a51:	51                   	push   %ecx
  800a52:	52                   	push   %edx
  800a53:	50                   	push   %eax
  800a54:	e8 47 29 00 00       	call   8033a0 <__umoddi3>
  800a59:	83 c4 10             	add    $0x10,%esp
  800a5c:	05 54 3d 80 00       	add    $0x803d54,%eax
  800a61:	8a 00                	mov    (%eax),%al
  800a63:	0f be c0             	movsbl %al,%eax
  800a66:	83 ec 08             	sub    $0x8,%esp
  800a69:	ff 75 0c             	pushl  0xc(%ebp)
  800a6c:	50                   	push   %eax
  800a6d:	8b 45 08             	mov    0x8(%ebp),%eax
  800a70:	ff d0                	call   *%eax
  800a72:	83 c4 10             	add    $0x10,%esp
}
  800a75:	90                   	nop
  800a76:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800a79:	c9                   	leave  
  800a7a:	c3                   	ret    

00800a7b <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  800a7b:	55                   	push   %ebp
  800a7c:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800a7e:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800a82:	7e 1c                	jle    800aa0 <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  800a84:	8b 45 08             	mov    0x8(%ebp),%eax
  800a87:	8b 00                	mov    (%eax),%eax
  800a89:	8d 50 08             	lea    0x8(%eax),%edx
  800a8c:	8b 45 08             	mov    0x8(%ebp),%eax
  800a8f:	89 10                	mov    %edx,(%eax)
  800a91:	8b 45 08             	mov    0x8(%ebp),%eax
  800a94:	8b 00                	mov    (%eax),%eax
  800a96:	83 e8 08             	sub    $0x8,%eax
  800a99:	8b 50 04             	mov    0x4(%eax),%edx
  800a9c:	8b 00                	mov    (%eax),%eax
  800a9e:	eb 40                	jmp    800ae0 <getuint+0x65>
	else if (lflag)
  800aa0:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800aa4:	74 1e                	je     800ac4 <getuint+0x49>
		return va_arg(*ap, unsigned long);
  800aa6:	8b 45 08             	mov    0x8(%ebp),%eax
  800aa9:	8b 00                	mov    (%eax),%eax
  800aab:	8d 50 04             	lea    0x4(%eax),%edx
  800aae:	8b 45 08             	mov    0x8(%ebp),%eax
  800ab1:	89 10                	mov    %edx,(%eax)
  800ab3:	8b 45 08             	mov    0x8(%ebp),%eax
  800ab6:	8b 00                	mov    (%eax),%eax
  800ab8:	83 e8 04             	sub    $0x4,%eax
  800abb:	8b 00                	mov    (%eax),%eax
  800abd:	ba 00 00 00 00       	mov    $0x0,%edx
  800ac2:	eb 1c                	jmp    800ae0 <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  800ac4:	8b 45 08             	mov    0x8(%ebp),%eax
  800ac7:	8b 00                	mov    (%eax),%eax
  800ac9:	8d 50 04             	lea    0x4(%eax),%edx
  800acc:	8b 45 08             	mov    0x8(%ebp),%eax
  800acf:	89 10                	mov    %edx,(%eax)
  800ad1:	8b 45 08             	mov    0x8(%ebp),%eax
  800ad4:	8b 00                	mov    (%eax),%eax
  800ad6:	83 e8 04             	sub    $0x4,%eax
  800ad9:	8b 00                	mov    (%eax),%eax
  800adb:	ba 00 00 00 00       	mov    $0x0,%edx
}
  800ae0:	5d                   	pop    %ebp
  800ae1:	c3                   	ret    

00800ae2 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  800ae2:	55                   	push   %ebp
  800ae3:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800ae5:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800ae9:	7e 1c                	jle    800b07 <getint+0x25>
		return va_arg(*ap, long long);
  800aeb:	8b 45 08             	mov    0x8(%ebp),%eax
  800aee:	8b 00                	mov    (%eax),%eax
  800af0:	8d 50 08             	lea    0x8(%eax),%edx
  800af3:	8b 45 08             	mov    0x8(%ebp),%eax
  800af6:	89 10                	mov    %edx,(%eax)
  800af8:	8b 45 08             	mov    0x8(%ebp),%eax
  800afb:	8b 00                	mov    (%eax),%eax
  800afd:	83 e8 08             	sub    $0x8,%eax
  800b00:	8b 50 04             	mov    0x4(%eax),%edx
  800b03:	8b 00                	mov    (%eax),%eax
  800b05:	eb 38                	jmp    800b3f <getint+0x5d>
	else if (lflag)
  800b07:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800b0b:	74 1a                	je     800b27 <getint+0x45>
		return va_arg(*ap, long);
  800b0d:	8b 45 08             	mov    0x8(%ebp),%eax
  800b10:	8b 00                	mov    (%eax),%eax
  800b12:	8d 50 04             	lea    0x4(%eax),%edx
  800b15:	8b 45 08             	mov    0x8(%ebp),%eax
  800b18:	89 10                	mov    %edx,(%eax)
  800b1a:	8b 45 08             	mov    0x8(%ebp),%eax
  800b1d:	8b 00                	mov    (%eax),%eax
  800b1f:	83 e8 04             	sub    $0x4,%eax
  800b22:	8b 00                	mov    (%eax),%eax
  800b24:	99                   	cltd   
  800b25:	eb 18                	jmp    800b3f <getint+0x5d>
	else
		return va_arg(*ap, int);
  800b27:	8b 45 08             	mov    0x8(%ebp),%eax
  800b2a:	8b 00                	mov    (%eax),%eax
  800b2c:	8d 50 04             	lea    0x4(%eax),%edx
  800b2f:	8b 45 08             	mov    0x8(%ebp),%eax
  800b32:	89 10                	mov    %edx,(%eax)
  800b34:	8b 45 08             	mov    0x8(%ebp),%eax
  800b37:	8b 00                	mov    (%eax),%eax
  800b39:	83 e8 04             	sub    $0x4,%eax
  800b3c:	8b 00                	mov    (%eax),%eax
  800b3e:	99                   	cltd   
}
  800b3f:	5d                   	pop    %ebp
  800b40:	c3                   	ret    

00800b41 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  800b41:	55                   	push   %ebp
  800b42:	89 e5                	mov    %esp,%ebp
  800b44:	56                   	push   %esi
  800b45:	53                   	push   %ebx
  800b46:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800b49:	eb 17                	jmp    800b62 <vprintfmt+0x21>
			if (ch == '\0')
  800b4b:	85 db                	test   %ebx,%ebx
  800b4d:	0f 84 af 03 00 00    	je     800f02 <vprintfmt+0x3c1>
				return;
			putch(ch, putdat);
  800b53:	83 ec 08             	sub    $0x8,%esp
  800b56:	ff 75 0c             	pushl  0xc(%ebp)
  800b59:	53                   	push   %ebx
  800b5a:	8b 45 08             	mov    0x8(%ebp),%eax
  800b5d:	ff d0                	call   *%eax
  800b5f:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800b62:	8b 45 10             	mov    0x10(%ebp),%eax
  800b65:	8d 50 01             	lea    0x1(%eax),%edx
  800b68:	89 55 10             	mov    %edx,0x10(%ebp)
  800b6b:	8a 00                	mov    (%eax),%al
  800b6d:	0f b6 d8             	movzbl %al,%ebx
  800b70:	83 fb 25             	cmp    $0x25,%ebx
  800b73:	75 d6                	jne    800b4b <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  800b75:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  800b79:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  800b80:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  800b87:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  800b8e:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800b95:	8b 45 10             	mov    0x10(%ebp),%eax
  800b98:	8d 50 01             	lea    0x1(%eax),%edx
  800b9b:	89 55 10             	mov    %edx,0x10(%ebp)
  800b9e:	8a 00                	mov    (%eax),%al
  800ba0:	0f b6 d8             	movzbl %al,%ebx
  800ba3:	8d 43 dd             	lea    -0x23(%ebx),%eax
  800ba6:	83 f8 55             	cmp    $0x55,%eax
  800ba9:	0f 87 2b 03 00 00    	ja     800eda <vprintfmt+0x399>
  800baf:	8b 04 85 78 3d 80 00 	mov    0x803d78(,%eax,4),%eax
  800bb6:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  800bb8:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  800bbc:	eb d7                	jmp    800b95 <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  800bbe:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  800bc2:	eb d1                	jmp    800b95 <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800bc4:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  800bcb:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800bce:	89 d0                	mov    %edx,%eax
  800bd0:	c1 e0 02             	shl    $0x2,%eax
  800bd3:	01 d0                	add    %edx,%eax
  800bd5:	01 c0                	add    %eax,%eax
  800bd7:	01 d8                	add    %ebx,%eax
  800bd9:	83 e8 30             	sub    $0x30,%eax
  800bdc:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  800bdf:	8b 45 10             	mov    0x10(%ebp),%eax
  800be2:	8a 00                	mov    (%eax),%al
  800be4:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  800be7:	83 fb 2f             	cmp    $0x2f,%ebx
  800bea:	7e 3e                	jle    800c2a <vprintfmt+0xe9>
  800bec:	83 fb 39             	cmp    $0x39,%ebx
  800bef:	7f 39                	jg     800c2a <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800bf1:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  800bf4:	eb d5                	jmp    800bcb <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  800bf6:	8b 45 14             	mov    0x14(%ebp),%eax
  800bf9:	83 c0 04             	add    $0x4,%eax
  800bfc:	89 45 14             	mov    %eax,0x14(%ebp)
  800bff:	8b 45 14             	mov    0x14(%ebp),%eax
  800c02:	83 e8 04             	sub    $0x4,%eax
  800c05:	8b 00                	mov    (%eax),%eax
  800c07:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  800c0a:	eb 1f                	jmp    800c2b <vprintfmt+0xea>

		case '.':
			if (width < 0)
  800c0c:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800c10:	79 83                	jns    800b95 <vprintfmt+0x54>
				width = 0;
  800c12:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  800c19:	e9 77 ff ff ff       	jmp    800b95 <vprintfmt+0x54>

		case '#':
			altflag = 1;
  800c1e:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  800c25:	e9 6b ff ff ff       	jmp    800b95 <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  800c2a:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  800c2b:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800c2f:	0f 89 60 ff ff ff    	jns    800b95 <vprintfmt+0x54>
				width = precision, precision = -1;
  800c35:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800c38:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800c3b:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  800c42:	e9 4e ff ff ff       	jmp    800b95 <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  800c47:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  800c4a:	e9 46 ff ff ff       	jmp    800b95 <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  800c4f:	8b 45 14             	mov    0x14(%ebp),%eax
  800c52:	83 c0 04             	add    $0x4,%eax
  800c55:	89 45 14             	mov    %eax,0x14(%ebp)
  800c58:	8b 45 14             	mov    0x14(%ebp),%eax
  800c5b:	83 e8 04             	sub    $0x4,%eax
  800c5e:	8b 00                	mov    (%eax),%eax
  800c60:	83 ec 08             	sub    $0x8,%esp
  800c63:	ff 75 0c             	pushl  0xc(%ebp)
  800c66:	50                   	push   %eax
  800c67:	8b 45 08             	mov    0x8(%ebp),%eax
  800c6a:	ff d0                	call   *%eax
  800c6c:	83 c4 10             	add    $0x10,%esp
			break;
  800c6f:	e9 89 02 00 00       	jmp    800efd <vprintfmt+0x3bc>

		// error message
		case 'e':
			err = va_arg(ap, int);
  800c74:	8b 45 14             	mov    0x14(%ebp),%eax
  800c77:	83 c0 04             	add    $0x4,%eax
  800c7a:	89 45 14             	mov    %eax,0x14(%ebp)
  800c7d:	8b 45 14             	mov    0x14(%ebp),%eax
  800c80:	83 e8 04             	sub    $0x4,%eax
  800c83:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  800c85:	85 db                	test   %ebx,%ebx
  800c87:	79 02                	jns    800c8b <vprintfmt+0x14a>
				err = -err;
  800c89:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  800c8b:	83 fb 64             	cmp    $0x64,%ebx
  800c8e:	7f 0b                	jg     800c9b <vprintfmt+0x15a>
  800c90:	8b 34 9d c0 3b 80 00 	mov    0x803bc0(,%ebx,4),%esi
  800c97:	85 f6                	test   %esi,%esi
  800c99:	75 19                	jne    800cb4 <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  800c9b:	53                   	push   %ebx
  800c9c:	68 65 3d 80 00       	push   $0x803d65
  800ca1:	ff 75 0c             	pushl  0xc(%ebp)
  800ca4:	ff 75 08             	pushl  0x8(%ebp)
  800ca7:	e8 5e 02 00 00       	call   800f0a <printfmt>
  800cac:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  800caf:	e9 49 02 00 00       	jmp    800efd <vprintfmt+0x3bc>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  800cb4:	56                   	push   %esi
  800cb5:	68 6e 3d 80 00       	push   $0x803d6e
  800cba:	ff 75 0c             	pushl  0xc(%ebp)
  800cbd:	ff 75 08             	pushl  0x8(%ebp)
  800cc0:	e8 45 02 00 00       	call   800f0a <printfmt>
  800cc5:	83 c4 10             	add    $0x10,%esp
			break;
  800cc8:	e9 30 02 00 00       	jmp    800efd <vprintfmt+0x3bc>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  800ccd:	8b 45 14             	mov    0x14(%ebp),%eax
  800cd0:	83 c0 04             	add    $0x4,%eax
  800cd3:	89 45 14             	mov    %eax,0x14(%ebp)
  800cd6:	8b 45 14             	mov    0x14(%ebp),%eax
  800cd9:	83 e8 04             	sub    $0x4,%eax
  800cdc:	8b 30                	mov    (%eax),%esi
  800cde:	85 f6                	test   %esi,%esi
  800ce0:	75 05                	jne    800ce7 <vprintfmt+0x1a6>
				p = "(null)";
  800ce2:	be 71 3d 80 00       	mov    $0x803d71,%esi
			if (width > 0 && padc != '-')
  800ce7:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800ceb:	7e 6d                	jle    800d5a <vprintfmt+0x219>
  800ced:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  800cf1:	74 67                	je     800d5a <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  800cf3:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800cf6:	83 ec 08             	sub    $0x8,%esp
  800cf9:	50                   	push   %eax
  800cfa:	56                   	push   %esi
  800cfb:	e8 0c 03 00 00       	call   80100c <strnlen>
  800d00:	83 c4 10             	add    $0x10,%esp
  800d03:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  800d06:	eb 16                	jmp    800d1e <vprintfmt+0x1dd>
					putch(padc, putdat);
  800d08:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  800d0c:	83 ec 08             	sub    $0x8,%esp
  800d0f:	ff 75 0c             	pushl  0xc(%ebp)
  800d12:	50                   	push   %eax
  800d13:	8b 45 08             	mov    0x8(%ebp),%eax
  800d16:	ff d0                	call   *%eax
  800d18:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800d1b:	ff 4d e4             	decl   -0x1c(%ebp)
  800d1e:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800d22:	7f e4                	jg     800d08 <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800d24:	eb 34                	jmp    800d5a <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  800d26:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  800d2a:	74 1c                	je     800d48 <vprintfmt+0x207>
  800d2c:	83 fb 1f             	cmp    $0x1f,%ebx
  800d2f:	7e 05                	jle    800d36 <vprintfmt+0x1f5>
  800d31:	83 fb 7e             	cmp    $0x7e,%ebx
  800d34:	7e 12                	jle    800d48 <vprintfmt+0x207>
					putch('?', putdat);
  800d36:	83 ec 08             	sub    $0x8,%esp
  800d39:	ff 75 0c             	pushl  0xc(%ebp)
  800d3c:	6a 3f                	push   $0x3f
  800d3e:	8b 45 08             	mov    0x8(%ebp),%eax
  800d41:	ff d0                	call   *%eax
  800d43:	83 c4 10             	add    $0x10,%esp
  800d46:	eb 0f                	jmp    800d57 <vprintfmt+0x216>
				else
					putch(ch, putdat);
  800d48:	83 ec 08             	sub    $0x8,%esp
  800d4b:	ff 75 0c             	pushl  0xc(%ebp)
  800d4e:	53                   	push   %ebx
  800d4f:	8b 45 08             	mov    0x8(%ebp),%eax
  800d52:	ff d0                	call   *%eax
  800d54:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800d57:	ff 4d e4             	decl   -0x1c(%ebp)
  800d5a:	89 f0                	mov    %esi,%eax
  800d5c:	8d 70 01             	lea    0x1(%eax),%esi
  800d5f:	8a 00                	mov    (%eax),%al
  800d61:	0f be d8             	movsbl %al,%ebx
  800d64:	85 db                	test   %ebx,%ebx
  800d66:	74 24                	je     800d8c <vprintfmt+0x24b>
  800d68:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800d6c:	78 b8                	js     800d26 <vprintfmt+0x1e5>
  800d6e:	ff 4d e0             	decl   -0x20(%ebp)
  800d71:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800d75:	79 af                	jns    800d26 <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800d77:	eb 13                	jmp    800d8c <vprintfmt+0x24b>
				putch(' ', putdat);
  800d79:	83 ec 08             	sub    $0x8,%esp
  800d7c:	ff 75 0c             	pushl  0xc(%ebp)
  800d7f:	6a 20                	push   $0x20
  800d81:	8b 45 08             	mov    0x8(%ebp),%eax
  800d84:	ff d0                	call   *%eax
  800d86:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800d89:	ff 4d e4             	decl   -0x1c(%ebp)
  800d8c:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800d90:	7f e7                	jg     800d79 <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  800d92:	e9 66 01 00 00       	jmp    800efd <vprintfmt+0x3bc>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  800d97:	83 ec 08             	sub    $0x8,%esp
  800d9a:	ff 75 e8             	pushl  -0x18(%ebp)
  800d9d:	8d 45 14             	lea    0x14(%ebp),%eax
  800da0:	50                   	push   %eax
  800da1:	e8 3c fd ff ff       	call   800ae2 <getint>
  800da6:	83 c4 10             	add    $0x10,%esp
  800da9:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800dac:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  800daf:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800db2:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800db5:	85 d2                	test   %edx,%edx
  800db7:	79 23                	jns    800ddc <vprintfmt+0x29b>
				putch('-', putdat);
  800db9:	83 ec 08             	sub    $0x8,%esp
  800dbc:	ff 75 0c             	pushl  0xc(%ebp)
  800dbf:	6a 2d                	push   $0x2d
  800dc1:	8b 45 08             	mov    0x8(%ebp),%eax
  800dc4:	ff d0                	call   *%eax
  800dc6:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  800dc9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800dcc:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800dcf:	f7 d8                	neg    %eax
  800dd1:	83 d2 00             	adc    $0x0,%edx
  800dd4:	f7 da                	neg    %edx
  800dd6:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800dd9:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  800ddc:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800de3:	e9 bc 00 00 00       	jmp    800ea4 <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  800de8:	83 ec 08             	sub    $0x8,%esp
  800deb:	ff 75 e8             	pushl  -0x18(%ebp)
  800dee:	8d 45 14             	lea    0x14(%ebp),%eax
  800df1:	50                   	push   %eax
  800df2:	e8 84 fc ff ff       	call   800a7b <getuint>
  800df7:	83 c4 10             	add    $0x10,%esp
  800dfa:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800dfd:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  800e00:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800e07:	e9 98 00 00 00       	jmp    800ea4 <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  800e0c:	83 ec 08             	sub    $0x8,%esp
  800e0f:	ff 75 0c             	pushl  0xc(%ebp)
  800e12:	6a 58                	push   $0x58
  800e14:	8b 45 08             	mov    0x8(%ebp),%eax
  800e17:	ff d0                	call   *%eax
  800e19:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800e1c:	83 ec 08             	sub    $0x8,%esp
  800e1f:	ff 75 0c             	pushl  0xc(%ebp)
  800e22:	6a 58                	push   $0x58
  800e24:	8b 45 08             	mov    0x8(%ebp),%eax
  800e27:	ff d0                	call   *%eax
  800e29:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800e2c:	83 ec 08             	sub    $0x8,%esp
  800e2f:	ff 75 0c             	pushl  0xc(%ebp)
  800e32:	6a 58                	push   $0x58
  800e34:	8b 45 08             	mov    0x8(%ebp),%eax
  800e37:	ff d0                	call   *%eax
  800e39:	83 c4 10             	add    $0x10,%esp
			break;
  800e3c:	e9 bc 00 00 00       	jmp    800efd <vprintfmt+0x3bc>

		// pointer
		case 'p':
			putch('0', putdat);
  800e41:	83 ec 08             	sub    $0x8,%esp
  800e44:	ff 75 0c             	pushl  0xc(%ebp)
  800e47:	6a 30                	push   $0x30
  800e49:	8b 45 08             	mov    0x8(%ebp),%eax
  800e4c:	ff d0                	call   *%eax
  800e4e:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  800e51:	83 ec 08             	sub    $0x8,%esp
  800e54:	ff 75 0c             	pushl  0xc(%ebp)
  800e57:	6a 78                	push   $0x78
  800e59:	8b 45 08             	mov    0x8(%ebp),%eax
  800e5c:	ff d0                	call   *%eax
  800e5e:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  800e61:	8b 45 14             	mov    0x14(%ebp),%eax
  800e64:	83 c0 04             	add    $0x4,%eax
  800e67:	89 45 14             	mov    %eax,0x14(%ebp)
  800e6a:	8b 45 14             	mov    0x14(%ebp),%eax
  800e6d:	83 e8 04             	sub    $0x4,%eax
  800e70:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800e72:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800e75:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  800e7c:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  800e83:	eb 1f                	jmp    800ea4 <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  800e85:	83 ec 08             	sub    $0x8,%esp
  800e88:	ff 75 e8             	pushl  -0x18(%ebp)
  800e8b:	8d 45 14             	lea    0x14(%ebp),%eax
  800e8e:	50                   	push   %eax
  800e8f:	e8 e7 fb ff ff       	call   800a7b <getuint>
  800e94:	83 c4 10             	add    $0x10,%esp
  800e97:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800e9a:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  800e9d:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800ea4:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  800ea8:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800eab:	83 ec 04             	sub    $0x4,%esp
  800eae:	52                   	push   %edx
  800eaf:	ff 75 e4             	pushl  -0x1c(%ebp)
  800eb2:	50                   	push   %eax
  800eb3:	ff 75 f4             	pushl  -0xc(%ebp)
  800eb6:	ff 75 f0             	pushl  -0x10(%ebp)
  800eb9:	ff 75 0c             	pushl  0xc(%ebp)
  800ebc:	ff 75 08             	pushl  0x8(%ebp)
  800ebf:	e8 00 fb ff ff       	call   8009c4 <printnum>
  800ec4:	83 c4 20             	add    $0x20,%esp
			break;
  800ec7:	eb 34                	jmp    800efd <vprintfmt+0x3bc>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  800ec9:	83 ec 08             	sub    $0x8,%esp
  800ecc:	ff 75 0c             	pushl  0xc(%ebp)
  800ecf:	53                   	push   %ebx
  800ed0:	8b 45 08             	mov    0x8(%ebp),%eax
  800ed3:	ff d0                	call   *%eax
  800ed5:	83 c4 10             	add    $0x10,%esp
			break;
  800ed8:	eb 23                	jmp    800efd <vprintfmt+0x3bc>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800eda:	83 ec 08             	sub    $0x8,%esp
  800edd:	ff 75 0c             	pushl  0xc(%ebp)
  800ee0:	6a 25                	push   $0x25
  800ee2:	8b 45 08             	mov    0x8(%ebp),%eax
  800ee5:	ff d0                	call   *%eax
  800ee7:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  800eea:	ff 4d 10             	decl   0x10(%ebp)
  800eed:	eb 03                	jmp    800ef2 <vprintfmt+0x3b1>
  800eef:	ff 4d 10             	decl   0x10(%ebp)
  800ef2:	8b 45 10             	mov    0x10(%ebp),%eax
  800ef5:	48                   	dec    %eax
  800ef6:	8a 00                	mov    (%eax),%al
  800ef8:	3c 25                	cmp    $0x25,%al
  800efa:	75 f3                	jne    800eef <vprintfmt+0x3ae>
				/* do nothing */;
			break;
  800efc:	90                   	nop
		}
	}
  800efd:	e9 47 fc ff ff       	jmp    800b49 <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  800f02:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  800f03:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800f06:	5b                   	pop    %ebx
  800f07:	5e                   	pop    %esi
  800f08:	5d                   	pop    %ebp
  800f09:	c3                   	ret    

00800f0a <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800f0a:	55                   	push   %ebp
  800f0b:	89 e5                	mov    %esp,%ebp
  800f0d:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  800f10:	8d 45 10             	lea    0x10(%ebp),%eax
  800f13:	83 c0 04             	add    $0x4,%eax
  800f16:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  800f19:	8b 45 10             	mov    0x10(%ebp),%eax
  800f1c:	ff 75 f4             	pushl  -0xc(%ebp)
  800f1f:	50                   	push   %eax
  800f20:	ff 75 0c             	pushl  0xc(%ebp)
  800f23:	ff 75 08             	pushl  0x8(%ebp)
  800f26:	e8 16 fc ff ff       	call   800b41 <vprintfmt>
  800f2b:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  800f2e:	90                   	nop
  800f2f:	c9                   	leave  
  800f30:	c3                   	ret    

00800f31 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800f31:	55                   	push   %ebp
  800f32:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  800f34:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f37:	8b 40 08             	mov    0x8(%eax),%eax
  800f3a:	8d 50 01             	lea    0x1(%eax),%edx
  800f3d:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f40:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  800f43:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f46:	8b 10                	mov    (%eax),%edx
  800f48:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f4b:	8b 40 04             	mov    0x4(%eax),%eax
  800f4e:	39 c2                	cmp    %eax,%edx
  800f50:	73 12                	jae    800f64 <sprintputch+0x33>
		*b->buf++ = ch;
  800f52:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f55:	8b 00                	mov    (%eax),%eax
  800f57:	8d 48 01             	lea    0x1(%eax),%ecx
  800f5a:	8b 55 0c             	mov    0xc(%ebp),%edx
  800f5d:	89 0a                	mov    %ecx,(%edx)
  800f5f:	8b 55 08             	mov    0x8(%ebp),%edx
  800f62:	88 10                	mov    %dl,(%eax)
}
  800f64:	90                   	nop
  800f65:	5d                   	pop    %ebp
  800f66:	c3                   	ret    

00800f67 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800f67:	55                   	push   %ebp
  800f68:	89 e5                	mov    %esp,%ebp
  800f6a:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  800f6d:	8b 45 08             	mov    0x8(%ebp),%eax
  800f70:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800f73:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f76:	8d 50 ff             	lea    -0x1(%eax),%edx
  800f79:	8b 45 08             	mov    0x8(%ebp),%eax
  800f7c:	01 d0                	add    %edx,%eax
  800f7e:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800f81:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800f88:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800f8c:	74 06                	je     800f94 <vsnprintf+0x2d>
  800f8e:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800f92:	7f 07                	jg     800f9b <vsnprintf+0x34>
		return -E_INVAL;
  800f94:	b8 03 00 00 00       	mov    $0x3,%eax
  800f99:	eb 20                	jmp    800fbb <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800f9b:	ff 75 14             	pushl  0x14(%ebp)
  800f9e:	ff 75 10             	pushl  0x10(%ebp)
  800fa1:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800fa4:	50                   	push   %eax
  800fa5:	68 31 0f 80 00       	push   $0x800f31
  800faa:	e8 92 fb ff ff       	call   800b41 <vprintfmt>
  800faf:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  800fb2:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800fb5:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800fb8:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  800fbb:	c9                   	leave  
  800fbc:	c3                   	ret    

00800fbd <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800fbd:	55                   	push   %ebp
  800fbe:	89 e5                	mov    %esp,%ebp
  800fc0:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800fc3:	8d 45 10             	lea    0x10(%ebp),%eax
  800fc6:	83 c0 04             	add    $0x4,%eax
  800fc9:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  800fcc:	8b 45 10             	mov    0x10(%ebp),%eax
  800fcf:	ff 75 f4             	pushl  -0xc(%ebp)
  800fd2:	50                   	push   %eax
  800fd3:	ff 75 0c             	pushl  0xc(%ebp)
  800fd6:	ff 75 08             	pushl  0x8(%ebp)
  800fd9:	e8 89 ff ff ff       	call   800f67 <vsnprintf>
  800fde:	83 c4 10             	add    $0x10,%esp
  800fe1:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  800fe4:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800fe7:	c9                   	leave  
  800fe8:	c3                   	ret    

00800fe9 <strlen>:

#include <inc/string.h>

int
strlen(const char *s)
{
  800fe9:	55                   	push   %ebp
  800fea:	89 e5                	mov    %esp,%ebp
  800fec:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  800fef:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800ff6:	eb 06                	jmp    800ffe <strlen+0x15>
		n++;
  800ff8:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  800ffb:	ff 45 08             	incl   0x8(%ebp)
  800ffe:	8b 45 08             	mov    0x8(%ebp),%eax
  801001:	8a 00                	mov    (%eax),%al
  801003:	84 c0                	test   %al,%al
  801005:	75 f1                	jne    800ff8 <strlen+0xf>
		n++;
	return n;
  801007:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  80100a:	c9                   	leave  
  80100b:	c3                   	ret    

0080100c <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  80100c:	55                   	push   %ebp
  80100d:	89 e5                	mov    %esp,%ebp
  80100f:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  801012:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801019:	eb 09                	jmp    801024 <strnlen+0x18>
		n++;
  80101b:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  80101e:	ff 45 08             	incl   0x8(%ebp)
  801021:	ff 4d 0c             	decl   0xc(%ebp)
  801024:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801028:	74 09                	je     801033 <strnlen+0x27>
  80102a:	8b 45 08             	mov    0x8(%ebp),%eax
  80102d:	8a 00                	mov    (%eax),%al
  80102f:	84 c0                	test   %al,%al
  801031:	75 e8                	jne    80101b <strnlen+0xf>
		n++;
	return n;
  801033:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  801036:	c9                   	leave  
  801037:	c3                   	ret    

00801038 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  801038:	55                   	push   %ebp
  801039:	89 e5                	mov    %esp,%ebp
  80103b:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  80103e:	8b 45 08             	mov    0x8(%ebp),%eax
  801041:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  801044:	90                   	nop
  801045:	8b 45 08             	mov    0x8(%ebp),%eax
  801048:	8d 50 01             	lea    0x1(%eax),%edx
  80104b:	89 55 08             	mov    %edx,0x8(%ebp)
  80104e:	8b 55 0c             	mov    0xc(%ebp),%edx
  801051:	8d 4a 01             	lea    0x1(%edx),%ecx
  801054:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  801057:	8a 12                	mov    (%edx),%dl
  801059:	88 10                	mov    %dl,(%eax)
  80105b:	8a 00                	mov    (%eax),%al
  80105d:	84 c0                	test   %al,%al
  80105f:	75 e4                	jne    801045 <strcpy+0xd>
		/* do nothing */;
	return ret;
  801061:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  801064:	c9                   	leave  
  801065:	c3                   	ret    

00801066 <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  801066:	55                   	push   %ebp
  801067:	89 e5                	mov    %esp,%ebp
  801069:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  80106c:	8b 45 08             	mov    0x8(%ebp),%eax
  80106f:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  801072:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801079:	eb 1f                	jmp    80109a <strncpy+0x34>
		*dst++ = *src;
  80107b:	8b 45 08             	mov    0x8(%ebp),%eax
  80107e:	8d 50 01             	lea    0x1(%eax),%edx
  801081:	89 55 08             	mov    %edx,0x8(%ebp)
  801084:	8b 55 0c             	mov    0xc(%ebp),%edx
  801087:	8a 12                	mov    (%edx),%dl
  801089:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  80108b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80108e:	8a 00                	mov    (%eax),%al
  801090:	84 c0                	test   %al,%al
  801092:	74 03                	je     801097 <strncpy+0x31>
			src++;
  801094:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  801097:	ff 45 fc             	incl   -0x4(%ebp)
  80109a:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80109d:	3b 45 10             	cmp    0x10(%ebp),%eax
  8010a0:	72 d9                	jb     80107b <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  8010a2:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  8010a5:	c9                   	leave  
  8010a6:	c3                   	ret    

008010a7 <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  8010a7:	55                   	push   %ebp
  8010a8:	89 e5                	mov    %esp,%ebp
  8010aa:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  8010ad:	8b 45 08             	mov    0x8(%ebp),%eax
  8010b0:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  8010b3:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8010b7:	74 30                	je     8010e9 <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  8010b9:	eb 16                	jmp    8010d1 <strlcpy+0x2a>
			*dst++ = *src++;
  8010bb:	8b 45 08             	mov    0x8(%ebp),%eax
  8010be:	8d 50 01             	lea    0x1(%eax),%edx
  8010c1:	89 55 08             	mov    %edx,0x8(%ebp)
  8010c4:	8b 55 0c             	mov    0xc(%ebp),%edx
  8010c7:	8d 4a 01             	lea    0x1(%edx),%ecx
  8010ca:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  8010cd:	8a 12                	mov    (%edx),%dl
  8010cf:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  8010d1:	ff 4d 10             	decl   0x10(%ebp)
  8010d4:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8010d8:	74 09                	je     8010e3 <strlcpy+0x3c>
  8010da:	8b 45 0c             	mov    0xc(%ebp),%eax
  8010dd:	8a 00                	mov    (%eax),%al
  8010df:	84 c0                	test   %al,%al
  8010e1:	75 d8                	jne    8010bb <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  8010e3:	8b 45 08             	mov    0x8(%ebp),%eax
  8010e6:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  8010e9:	8b 55 08             	mov    0x8(%ebp),%edx
  8010ec:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8010ef:	29 c2                	sub    %eax,%edx
  8010f1:	89 d0                	mov    %edx,%eax
}
  8010f3:	c9                   	leave  
  8010f4:	c3                   	ret    

008010f5 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  8010f5:	55                   	push   %ebp
  8010f6:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  8010f8:	eb 06                	jmp    801100 <strcmp+0xb>
		p++, q++;
  8010fa:	ff 45 08             	incl   0x8(%ebp)
  8010fd:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  801100:	8b 45 08             	mov    0x8(%ebp),%eax
  801103:	8a 00                	mov    (%eax),%al
  801105:	84 c0                	test   %al,%al
  801107:	74 0e                	je     801117 <strcmp+0x22>
  801109:	8b 45 08             	mov    0x8(%ebp),%eax
  80110c:	8a 10                	mov    (%eax),%dl
  80110e:	8b 45 0c             	mov    0xc(%ebp),%eax
  801111:	8a 00                	mov    (%eax),%al
  801113:	38 c2                	cmp    %al,%dl
  801115:	74 e3                	je     8010fa <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  801117:	8b 45 08             	mov    0x8(%ebp),%eax
  80111a:	8a 00                	mov    (%eax),%al
  80111c:	0f b6 d0             	movzbl %al,%edx
  80111f:	8b 45 0c             	mov    0xc(%ebp),%eax
  801122:	8a 00                	mov    (%eax),%al
  801124:	0f b6 c0             	movzbl %al,%eax
  801127:	29 c2                	sub    %eax,%edx
  801129:	89 d0                	mov    %edx,%eax
}
  80112b:	5d                   	pop    %ebp
  80112c:	c3                   	ret    

0080112d <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  80112d:	55                   	push   %ebp
  80112e:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  801130:	eb 09                	jmp    80113b <strncmp+0xe>
		n--, p++, q++;
  801132:	ff 4d 10             	decl   0x10(%ebp)
  801135:	ff 45 08             	incl   0x8(%ebp)
  801138:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  80113b:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80113f:	74 17                	je     801158 <strncmp+0x2b>
  801141:	8b 45 08             	mov    0x8(%ebp),%eax
  801144:	8a 00                	mov    (%eax),%al
  801146:	84 c0                	test   %al,%al
  801148:	74 0e                	je     801158 <strncmp+0x2b>
  80114a:	8b 45 08             	mov    0x8(%ebp),%eax
  80114d:	8a 10                	mov    (%eax),%dl
  80114f:	8b 45 0c             	mov    0xc(%ebp),%eax
  801152:	8a 00                	mov    (%eax),%al
  801154:	38 c2                	cmp    %al,%dl
  801156:	74 da                	je     801132 <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  801158:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80115c:	75 07                	jne    801165 <strncmp+0x38>
		return 0;
  80115e:	b8 00 00 00 00       	mov    $0x0,%eax
  801163:	eb 14                	jmp    801179 <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  801165:	8b 45 08             	mov    0x8(%ebp),%eax
  801168:	8a 00                	mov    (%eax),%al
  80116a:	0f b6 d0             	movzbl %al,%edx
  80116d:	8b 45 0c             	mov    0xc(%ebp),%eax
  801170:	8a 00                	mov    (%eax),%al
  801172:	0f b6 c0             	movzbl %al,%eax
  801175:	29 c2                	sub    %eax,%edx
  801177:	89 d0                	mov    %edx,%eax
}
  801179:	5d                   	pop    %ebp
  80117a:	c3                   	ret    

0080117b <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  80117b:	55                   	push   %ebp
  80117c:	89 e5                	mov    %esp,%ebp
  80117e:	83 ec 04             	sub    $0x4,%esp
  801181:	8b 45 0c             	mov    0xc(%ebp),%eax
  801184:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  801187:	eb 12                	jmp    80119b <strchr+0x20>
		if (*s == c)
  801189:	8b 45 08             	mov    0x8(%ebp),%eax
  80118c:	8a 00                	mov    (%eax),%al
  80118e:	3a 45 fc             	cmp    -0x4(%ebp),%al
  801191:	75 05                	jne    801198 <strchr+0x1d>
			return (char *) s;
  801193:	8b 45 08             	mov    0x8(%ebp),%eax
  801196:	eb 11                	jmp    8011a9 <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  801198:	ff 45 08             	incl   0x8(%ebp)
  80119b:	8b 45 08             	mov    0x8(%ebp),%eax
  80119e:	8a 00                	mov    (%eax),%al
  8011a0:	84 c0                	test   %al,%al
  8011a2:	75 e5                	jne    801189 <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  8011a4:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8011a9:	c9                   	leave  
  8011aa:	c3                   	ret    

008011ab <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  8011ab:	55                   	push   %ebp
  8011ac:	89 e5                	mov    %esp,%ebp
  8011ae:	83 ec 04             	sub    $0x4,%esp
  8011b1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011b4:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  8011b7:	eb 0d                	jmp    8011c6 <strfind+0x1b>
		if (*s == c)
  8011b9:	8b 45 08             	mov    0x8(%ebp),%eax
  8011bc:	8a 00                	mov    (%eax),%al
  8011be:	3a 45 fc             	cmp    -0x4(%ebp),%al
  8011c1:	74 0e                	je     8011d1 <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  8011c3:	ff 45 08             	incl   0x8(%ebp)
  8011c6:	8b 45 08             	mov    0x8(%ebp),%eax
  8011c9:	8a 00                	mov    (%eax),%al
  8011cb:	84 c0                	test   %al,%al
  8011cd:	75 ea                	jne    8011b9 <strfind+0xe>
  8011cf:	eb 01                	jmp    8011d2 <strfind+0x27>
		if (*s == c)
			break;
  8011d1:	90                   	nop
	return (char *) s;
  8011d2:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8011d5:	c9                   	leave  
  8011d6:	c3                   	ret    

008011d7 <memset>:


void *
memset(void *v, int c, uint32 n)
{
  8011d7:	55                   	push   %ebp
  8011d8:	89 e5                	mov    %esp,%ebp
  8011da:	83 ec 10             	sub    $0x10,%esp
	char *p;
	int m;

	p = v;
  8011dd:	8b 45 08             	mov    0x8(%ebp),%eax
  8011e0:	89 45 fc             	mov    %eax,-0x4(%ebp)
	m = n;
  8011e3:	8b 45 10             	mov    0x10(%ebp),%eax
  8011e6:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (--m >= 0)
  8011e9:	eb 0e                	jmp    8011f9 <memset+0x22>
		*p++ = c;
  8011eb:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8011ee:	8d 50 01             	lea    0x1(%eax),%edx
  8011f1:	89 55 fc             	mov    %edx,-0x4(%ebp)
  8011f4:	8b 55 0c             	mov    0xc(%ebp),%edx
  8011f7:	88 10                	mov    %dl,(%eax)
	char *p;
	int m;

	p = v;
	m = n;
	while (--m >= 0)
  8011f9:	ff 4d f8             	decl   -0x8(%ebp)
  8011fc:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
  801200:	79 e9                	jns    8011eb <memset+0x14>
		*p++ = c;

	return v;
  801202:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801205:	c9                   	leave  
  801206:	c3                   	ret    

00801207 <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  801207:	55                   	push   %ebp
  801208:	89 e5                	mov    %esp,%ebp
  80120a:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  80120d:	8b 45 0c             	mov    0xc(%ebp),%eax
  801210:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  801213:	8b 45 08             	mov    0x8(%ebp),%eax
  801216:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (n-- > 0)
  801219:	eb 16                	jmp    801231 <memcpy+0x2a>
		*d++ = *s++;
  80121b:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80121e:	8d 50 01             	lea    0x1(%eax),%edx
  801221:	89 55 f8             	mov    %edx,-0x8(%ebp)
  801224:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801227:	8d 4a 01             	lea    0x1(%edx),%ecx
  80122a:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  80122d:	8a 12                	mov    (%edx),%dl
  80122f:	88 10                	mov    %dl,(%eax)
	const char *s;
	char *d;

	s = src;
	d = dst;
	while (n-- > 0)
  801231:	8b 45 10             	mov    0x10(%ebp),%eax
  801234:	8d 50 ff             	lea    -0x1(%eax),%edx
  801237:	89 55 10             	mov    %edx,0x10(%ebp)
  80123a:	85 c0                	test   %eax,%eax
  80123c:	75 dd                	jne    80121b <memcpy+0x14>
		*d++ = *s++;

	return dst;
  80123e:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801241:	c9                   	leave  
  801242:	c3                   	ret    

00801243 <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  801243:	55                   	push   %ebp
  801244:	89 e5                	mov    %esp,%ebp
  801246:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  801249:	8b 45 0c             	mov    0xc(%ebp),%eax
  80124c:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  80124f:	8b 45 08             	mov    0x8(%ebp),%eax
  801252:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  801255:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801258:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  80125b:	73 50                	jae    8012ad <memmove+0x6a>
  80125d:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801260:	8b 45 10             	mov    0x10(%ebp),%eax
  801263:	01 d0                	add    %edx,%eax
  801265:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  801268:	76 43                	jbe    8012ad <memmove+0x6a>
		s += n;
  80126a:	8b 45 10             	mov    0x10(%ebp),%eax
  80126d:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  801270:	8b 45 10             	mov    0x10(%ebp),%eax
  801273:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  801276:	eb 10                	jmp    801288 <memmove+0x45>
			*--d = *--s;
  801278:	ff 4d f8             	decl   -0x8(%ebp)
  80127b:	ff 4d fc             	decl   -0x4(%ebp)
  80127e:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801281:	8a 10                	mov    (%eax),%dl
  801283:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801286:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  801288:	8b 45 10             	mov    0x10(%ebp),%eax
  80128b:	8d 50 ff             	lea    -0x1(%eax),%edx
  80128e:	89 55 10             	mov    %edx,0x10(%ebp)
  801291:	85 c0                	test   %eax,%eax
  801293:	75 e3                	jne    801278 <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  801295:	eb 23                	jmp    8012ba <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  801297:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80129a:	8d 50 01             	lea    0x1(%eax),%edx
  80129d:	89 55 f8             	mov    %edx,-0x8(%ebp)
  8012a0:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8012a3:	8d 4a 01             	lea    0x1(%edx),%ecx
  8012a6:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  8012a9:	8a 12                	mov    (%edx),%dl
  8012ab:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  8012ad:	8b 45 10             	mov    0x10(%ebp),%eax
  8012b0:	8d 50 ff             	lea    -0x1(%eax),%edx
  8012b3:	89 55 10             	mov    %edx,0x10(%ebp)
  8012b6:	85 c0                	test   %eax,%eax
  8012b8:	75 dd                	jne    801297 <memmove+0x54>
			*d++ = *s++;

	return dst;
  8012ba:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8012bd:	c9                   	leave  
  8012be:	c3                   	ret    

008012bf <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  8012bf:	55                   	push   %ebp
  8012c0:	89 e5                	mov    %esp,%ebp
  8012c2:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  8012c5:	8b 45 08             	mov    0x8(%ebp),%eax
  8012c8:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  8012cb:	8b 45 0c             	mov    0xc(%ebp),%eax
  8012ce:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  8012d1:	eb 2a                	jmp    8012fd <memcmp+0x3e>
		if (*s1 != *s2)
  8012d3:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8012d6:	8a 10                	mov    (%eax),%dl
  8012d8:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8012db:	8a 00                	mov    (%eax),%al
  8012dd:	38 c2                	cmp    %al,%dl
  8012df:	74 16                	je     8012f7 <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  8012e1:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8012e4:	8a 00                	mov    (%eax),%al
  8012e6:	0f b6 d0             	movzbl %al,%edx
  8012e9:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8012ec:	8a 00                	mov    (%eax),%al
  8012ee:	0f b6 c0             	movzbl %al,%eax
  8012f1:	29 c2                	sub    %eax,%edx
  8012f3:	89 d0                	mov    %edx,%eax
  8012f5:	eb 18                	jmp    80130f <memcmp+0x50>
		s1++, s2++;
  8012f7:	ff 45 fc             	incl   -0x4(%ebp)
  8012fa:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  8012fd:	8b 45 10             	mov    0x10(%ebp),%eax
  801300:	8d 50 ff             	lea    -0x1(%eax),%edx
  801303:	89 55 10             	mov    %edx,0x10(%ebp)
  801306:	85 c0                	test   %eax,%eax
  801308:	75 c9                	jne    8012d3 <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  80130a:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80130f:	c9                   	leave  
  801310:	c3                   	ret    

00801311 <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  801311:	55                   	push   %ebp
  801312:	89 e5                	mov    %esp,%ebp
  801314:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  801317:	8b 55 08             	mov    0x8(%ebp),%edx
  80131a:	8b 45 10             	mov    0x10(%ebp),%eax
  80131d:	01 d0                	add    %edx,%eax
  80131f:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  801322:	eb 15                	jmp    801339 <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  801324:	8b 45 08             	mov    0x8(%ebp),%eax
  801327:	8a 00                	mov    (%eax),%al
  801329:	0f b6 d0             	movzbl %al,%edx
  80132c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80132f:	0f b6 c0             	movzbl %al,%eax
  801332:	39 c2                	cmp    %eax,%edx
  801334:	74 0d                	je     801343 <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  801336:	ff 45 08             	incl   0x8(%ebp)
  801339:	8b 45 08             	mov    0x8(%ebp),%eax
  80133c:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  80133f:	72 e3                	jb     801324 <memfind+0x13>
  801341:	eb 01                	jmp    801344 <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  801343:	90                   	nop
	return (void *) s;
  801344:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801347:	c9                   	leave  
  801348:	c3                   	ret    

00801349 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  801349:	55                   	push   %ebp
  80134a:	89 e5                	mov    %esp,%ebp
  80134c:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  80134f:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  801356:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  80135d:	eb 03                	jmp    801362 <strtol+0x19>
		s++;
  80135f:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801362:	8b 45 08             	mov    0x8(%ebp),%eax
  801365:	8a 00                	mov    (%eax),%al
  801367:	3c 20                	cmp    $0x20,%al
  801369:	74 f4                	je     80135f <strtol+0x16>
  80136b:	8b 45 08             	mov    0x8(%ebp),%eax
  80136e:	8a 00                	mov    (%eax),%al
  801370:	3c 09                	cmp    $0x9,%al
  801372:	74 eb                	je     80135f <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  801374:	8b 45 08             	mov    0x8(%ebp),%eax
  801377:	8a 00                	mov    (%eax),%al
  801379:	3c 2b                	cmp    $0x2b,%al
  80137b:	75 05                	jne    801382 <strtol+0x39>
		s++;
  80137d:	ff 45 08             	incl   0x8(%ebp)
  801380:	eb 13                	jmp    801395 <strtol+0x4c>
	else if (*s == '-')
  801382:	8b 45 08             	mov    0x8(%ebp),%eax
  801385:	8a 00                	mov    (%eax),%al
  801387:	3c 2d                	cmp    $0x2d,%al
  801389:	75 0a                	jne    801395 <strtol+0x4c>
		s++, neg = 1;
  80138b:	ff 45 08             	incl   0x8(%ebp)
  80138e:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  801395:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801399:	74 06                	je     8013a1 <strtol+0x58>
  80139b:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  80139f:	75 20                	jne    8013c1 <strtol+0x78>
  8013a1:	8b 45 08             	mov    0x8(%ebp),%eax
  8013a4:	8a 00                	mov    (%eax),%al
  8013a6:	3c 30                	cmp    $0x30,%al
  8013a8:	75 17                	jne    8013c1 <strtol+0x78>
  8013aa:	8b 45 08             	mov    0x8(%ebp),%eax
  8013ad:	40                   	inc    %eax
  8013ae:	8a 00                	mov    (%eax),%al
  8013b0:	3c 78                	cmp    $0x78,%al
  8013b2:	75 0d                	jne    8013c1 <strtol+0x78>
		s += 2, base = 16;
  8013b4:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  8013b8:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  8013bf:	eb 28                	jmp    8013e9 <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  8013c1:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8013c5:	75 15                	jne    8013dc <strtol+0x93>
  8013c7:	8b 45 08             	mov    0x8(%ebp),%eax
  8013ca:	8a 00                	mov    (%eax),%al
  8013cc:	3c 30                	cmp    $0x30,%al
  8013ce:	75 0c                	jne    8013dc <strtol+0x93>
		s++, base = 8;
  8013d0:	ff 45 08             	incl   0x8(%ebp)
  8013d3:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  8013da:	eb 0d                	jmp    8013e9 <strtol+0xa0>
	else if (base == 0)
  8013dc:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8013e0:	75 07                	jne    8013e9 <strtol+0xa0>
		base = 10;
  8013e2:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  8013e9:	8b 45 08             	mov    0x8(%ebp),%eax
  8013ec:	8a 00                	mov    (%eax),%al
  8013ee:	3c 2f                	cmp    $0x2f,%al
  8013f0:	7e 19                	jle    80140b <strtol+0xc2>
  8013f2:	8b 45 08             	mov    0x8(%ebp),%eax
  8013f5:	8a 00                	mov    (%eax),%al
  8013f7:	3c 39                	cmp    $0x39,%al
  8013f9:	7f 10                	jg     80140b <strtol+0xc2>
			dig = *s - '0';
  8013fb:	8b 45 08             	mov    0x8(%ebp),%eax
  8013fe:	8a 00                	mov    (%eax),%al
  801400:	0f be c0             	movsbl %al,%eax
  801403:	83 e8 30             	sub    $0x30,%eax
  801406:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801409:	eb 42                	jmp    80144d <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  80140b:	8b 45 08             	mov    0x8(%ebp),%eax
  80140e:	8a 00                	mov    (%eax),%al
  801410:	3c 60                	cmp    $0x60,%al
  801412:	7e 19                	jle    80142d <strtol+0xe4>
  801414:	8b 45 08             	mov    0x8(%ebp),%eax
  801417:	8a 00                	mov    (%eax),%al
  801419:	3c 7a                	cmp    $0x7a,%al
  80141b:	7f 10                	jg     80142d <strtol+0xe4>
			dig = *s - 'a' + 10;
  80141d:	8b 45 08             	mov    0x8(%ebp),%eax
  801420:	8a 00                	mov    (%eax),%al
  801422:	0f be c0             	movsbl %al,%eax
  801425:	83 e8 57             	sub    $0x57,%eax
  801428:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80142b:	eb 20                	jmp    80144d <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  80142d:	8b 45 08             	mov    0x8(%ebp),%eax
  801430:	8a 00                	mov    (%eax),%al
  801432:	3c 40                	cmp    $0x40,%al
  801434:	7e 39                	jle    80146f <strtol+0x126>
  801436:	8b 45 08             	mov    0x8(%ebp),%eax
  801439:	8a 00                	mov    (%eax),%al
  80143b:	3c 5a                	cmp    $0x5a,%al
  80143d:	7f 30                	jg     80146f <strtol+0x126>
			dig = *s - 'A' + 10;
  80143f:	8b 45 08             	mov    0x8(%ebp),%eax
  801442:	8a 00                	mov    (%eax),%al
  801444:	0f be c0             	movsbl %al,%eax
  801447:	83 e8 37             	sub    $0x37,%eax
  80144a:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  80144d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801450:	3b 45 10             	cmp    0x10(%ebp),%eax
  801453:	7d 19                	jge    80146e <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  801455:	ff 45 08             	incl   0x8(%ebp)
  801458:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80145b:	0f af 45 10          	imul   0x10(%ebp),%eax
  80145f:	89 c2                	mov    %eax,%edx
  801461:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801464:	01 d0                	add    %edx,%eax
  801466:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  801469:	e9 7b ff ff ff       	jmp    8013e9 <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  80146e:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  80146f:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801473:	74 08                	je     80147d <strtol+0x134>
		*endptr = (char *) s;
  801475:	8b 45 0c             	mov    0xc(%ebp),%eax
  801478:	8b 55 08             	mov    0x8(%ebp),%edx
  80147b:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  80147d:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801481:	74 07                	je     80148a <strtol+0x141>
  801483:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801486:	f7 d8                	neg    %eax
  801488:	eb 03                	jmp    80148d <strtol+0x144>
  80148a:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  80148d:	c9                   	leave  
  80148e:	c3                   	ret    

0080148f <ltostr>:

void
ltostr(long value, char *str)
{
  80148f:	55                   	push   %ebp
  801490:	89 e5                	mov    %esp,%ebp
  801492:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  801495:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  80149c:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  8014a3:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8014a7:	79 13                	jns    8014bc <ltostr+0x2d>
	{
		neg = 1;
  8014a9:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  8014b0:	8b 45 0c             	mov    0xc(%ebp),%eax
  8014b3:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  8014b6:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  8014b9:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  8014bc:	8b 45 08             	mov    0x8(%ebp),%eax
  8014bf:	b9 0a 00 00 00       	mov    $0xa,%ecx
  8014c4:	99                   	cltd   
  8014c5:	f7 f9                	idiv   %ecx
  8014c7:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  8014ca:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8014cd:	8d 50 01             	lea    0x1(%eax),%edx
  8014d0:	89 55 f8             	mov    %edx,-0x8(%ebp)
  8014d3:	89 c2                	mov    %eax,%edx
  8014d5:	8b 45 0c             	mov    0xc(%ebp),%eax
  8014d8:	01 d0                	add    %edx,%eax
  8014da:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8014dd:	83 c2 30             	add    $0x30,%edx
  8014e0:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  8014e2:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8014e5:	b8 67 66 66 66       	mov    $0x66666667,%eax
  8014ea:	f7 e9                	imul   %ecx
  8014ec:	c1 fa 02             	sar    $0x2,%edx
  8014ef:	89 c8                	mov    %ecx,%eax
  8014f1:	c1 f8 1f             	sar    $0x1f,%eax
  8014f4:	29 c2                	sub    %eax,%edx
  8014f6:	89 d0                	mov    %edx,%eax
  8014f8:	89 45 08             	mov    %eax,0x8(%ebp)
	} while (value % 10 != 0);
  8014fb:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8014fe:	b8 67 66 66 66       	mov    $0x66666667,%eax
  801503:	f7 e9                	imul   %ecx
  801505:	c1 fa 02             	sar    $0x2,%edx
  801508:	89 c8                	mov    %ecx,%eax
  80150a:	c1 f8 1f             	sar    $0x1f,%eax
  80150d:	29 c2                	sub    %eax,%edx
  80150f:	89 d0                	mov    %edx,%eax
  801511:	c1 e0 02             	shl    $0x2,%eax
  801514:	01 d0                	add    %edx,%eax
  801516:	01 c0                	add    %eax,%eax
  801518:	29 c1                	sub    %eax,%ecx
  80151a:	89 ca                	mov    %ecx,%edx
  80151c:	85 d2                	test   %edx,%edx
  80151e:	75 9c                	jne    8014bc <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  801520:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  801527:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80152a:	48                   	dec    %eax
  80152b:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  80152e:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801532:	74 3d                	je     801571 <ltostr+0xe2>
		start = 1 ;
  801534:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  80153b:	eb 34                	jmp    801571 <ltostr+0xe2>
	{
		char tmp = str[start] ;
  80153d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801540:	8b 45 0c             	mov    0xc(%ebp),%eax
  801543:	01 d0                	add    %edx,%eax
  801545:	8a 00                	mov    (%eax),%al
  801547:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  80154a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80154d:	8b 45 0c             	mov    0xc(%ebp),%eax
  801550:	01 c2                	add    %eax,%edx
  801552:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  801555:	8b 45 0c             	mov    0xc(%ebp),%eax
  801558:	01 c8                	add    %ecx,%eax
  80155a:	8a 00                	mov    (%eax),%al
  80155c:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  80155e:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801561:	8b 45 0c             	mov    0xc(%ebp),%eax
  801564:	01 c2                	add    %eax,%edx
  801566:	8a 45 eb             	mov    -0x15(%ebp),%al
  801569:	88 02                	mov    %al,(%edx)
		start++ ;
  80156b:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  80156e:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  801571:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801574:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801577:	7c c4                	jl     80153d <ltostr+0xae>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  801579:	8b 55 f8             	mov    -0x8(%ebp),%edx
  80157c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80157f:	01 d0                	add    %edx,%eax
  801581:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  801584:	90                   	nop
  801585:	c9                   	leave  
  801586:	c3                   	ret    

00801587 <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  801587:	55                   	push   %ebp
  801588:	89 e5                	mov    %esp,%ebp
  80158a:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  80158d:	ff 75 08             	pushl  0x8(%ebp)
  801590:	e8 54 fa ff ff       	call   800fe9 <strlen>
  801595:	83 c4 04             	add    $0x4,%esp
  801598:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  80159b:	ff 75 0c             	pushl  0xc(%ebp)
  80159e:	e8 46 fa ff ff       	call   800fe9 <strlen>
  8015a3:	83 c4 04             	add    $0x4,%esp
  8015a6:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  8015a9:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  8015b0:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8015b7:	eb 17                	jmp    8015d0 <strcconcat+0x49>
		final[s] = str1[s] ;
  8015b9:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8015bc:	8b 45 10             	mov    0x10(%ebp),%eax
  8015bf:	01 c2                	add    %eax,%edx
  8015c1:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  8015c4:	8b 45 08             	mov    0x8(%ebp),%eax
  8015c7:	01 c8                	add    %ecx,%eax
  8015c9:	8a 00                	mov    (%eax),%al
  8015cb:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  8015cd:	ff 45 fc             	incl   -0x4(%ebp)
  8015d0:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8015d3:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  8015d6:	7c e1                	jl     8015b9 <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  8015d8:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  8015df:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  8015e6:	eb 1f                	jmp    801607 <strcconcat+0x80>
		final[s++] = str2[i] ;
  8015e8:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8015eb:	8d 50 01             	lea    0x1(%eax),%edx
  8015ee:	89 55 fc             	mov    %edx,-0x4(%ebp)
  8015f1:	89 c2                	mov    %eax,%edx
  8015f3:	8b 45 10             	mov    0x10(%ebp),%eax
  8015f6:	01 c2                	add    %eax,%edx
  8015f8:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  8015fb:	8b 45 0c             	mov    0xc(%ebp),%eax
  8015fe:	01 c8                	add    %ecx,%eax
  801600:	8a 00                	mov    (%eax),%al
  801602:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  801604:	ff 45 f8             	incl   -0x8(%ebp)
  801607:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80160a:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  80160d:	7c d9                	jl     8015e8 <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  80160f:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801612:	8b 45 10             	mov    0x10(%ebp),%eax
  801615:	01 d0                	add    %edx,%eax
  801617:	c6 00 00             	movb   $0x0,(%eax)
}
  80161a:	90                   	nop
  80161b:	c9                   	leave  
  80161c:	c3                   	ret    

0080161d <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  80161d:	55                   	push   %ebp
  80161e:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  801620:	8b 45 14             	mov    0x14(%ebp),%eax
  801623:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  801629:	8b 45 14             	mov    0x14(%ebp),%eax
  80162c:	8b 00                	mov    (%eax),%eax
  80162e:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801635:	8b 45 10             	mov    0x10(%ebp),%eax
  801638:	01 d0                	add    %edx,%eax
  80163a:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801640:	eb 0c                	jmp    80164e <strsplit+0x31>
			*string++ = 0;
  801642:	8b 45 08             	mov    0x8(%ebp),%eax
  801645:	8d 50 01             	lea    0x1(%eax),%edx
  801648:	89 55 08             	mov    %edx,0x8(%ebp)
  80164b:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  80164e:	8b 45 08             	mov    0x8(%ebp),%eax
  801651:	8a 00                	mov    (%eax),%al
  801653:	84 c0                	test   %al,%al
  801655:	74 18                	je     80166f <strsplit+0x52>
  801657:	8b 45 08             	mov    0x8(%ebp),%eax
  80165a:	8a 00                	mov    (%eax),%al
  80165c:	0f be c0             	movsbl %al,%eax
  80165f:	50                   	push   %eax
  801660:	ff 75 0c             	pushl  0xc(%ebp)
  801663:	e8 13 fb ff ff       	call   80117b <strchr>
  801668:	83 c4 08             	add    $0x8,%esp
  80166b:	85 c0                	test   %eax,%eax
  80166d:	75 d3                	jne    801642 <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  80166f:	8b 45 08             	mov    0x8(%ebp),%eax
  801672:	8a 00                	mov    (%eax),%al
  801674:	84 c0                	test   %al,%al
  801676:	74 5a                	je     8016d2 <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  801678:	8b 45 14             	mov    0x14(%ebp),%eax
  80167b:	8b 00                	mov    (%eax),%eax
  80167d:	83 f8 0f             	cmp    $0xf,%eax
  801680:	75 07                	jne    801689 <strsplit+0x6c>
		{
			return 0;
  801682:	b8 00 00 00 00       	mov    $0x0,%eax
  801687:	eb 66                	jmp    8016ef <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  801689:	8b 45 14             	mov    0x14(%ebp),%eax
  80168c:	8b 00                	mov    (%eax),%eax
  80168e:	8d 48 01             	lea    0x1(%eax),%ecx
  801691:	8b 55 14             	mov    0x14(%ebp),%edx
  801694:	89 0a                	mov    %ecx,(%edx)
  801696:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80169d:	8b 45 10             	mov    0x10(%ebp),%eax
  8016a0:	01 c2                	add    %eax,%edx
  8016a2:	8b 45 08             	mov    0x8(%ebp),%eax
  8016a5:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  8016a7:	eb 03                	jmp    8016ac <strsplit+0x8f>
			string++;
  8016a9:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  8016ac:	8b 45 08             	mov    0x8(%ebp),%eax
  8016af:	8a 00                	mov    (%eax),%al
  8016b1:	84 c0                	test   %al,%al
  8016b3:	74 8b                	je     801640 <strsplit+0x23>
  8016b5:	8b 45 08             	mov    0x8(%ebp),%eax
  8016b8:	8a 00                	mov    (%eax),%al
  8016ba:	0f be c0             	movsbl %al,%eax
  8016bd:	50                   	push   %eax
  8016be:	ff 75 0c             	pushl  0xc(%ebp)
  8016c1:	e8 b5 fa ff ff       	call   80117b <strchr>
  8016c6:	83 c4 08             	add    $0x8,%esp
  8016c9:	85 c0                	test   %eax,%eax
  8016cb:	74 dc                	je     8016a9 <strsplit+0x8c>
			string++;
	}
  8016cd:	e9 6e ff ff ff       	jmp    801640 <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  8016d2:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  8016d3:	8b 45 14             	mov    0x14(%ebp),%eax
  8016d6:	8b 00                	mov    (%eax),%eax
  8016d8:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8016df:	8b 45 10             	mov    0x10(%ebp),%eax
  8016e2:	01 d0                	add    %edx,%eax
  8016e4:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  8016ea:	b8 01 00 00 00       	mov    $0x1,%eax
}
  8016ef:	c9                   	leave  
  8016f0:	c3                   	ret    

008016f1 <InitializeUHeap>:
//============================== GIVEN FUNCTIONS ===================================//
//==================================================================================//

int FirstTimeFlag = 1;
void InitializeUHeap()
{
  8016f1:	55                   	push   %ebp
  8016f2:	89 e5                	mov    %esp,%ebp
  8016f4:	83 ec 08             	sub    $0x8,%esp
	if(FirstTimeFlag)
  8016f7:	a1 04 50 80 00       	mov    0x805004,%eax
  8016fc:	85 c0                	test   %eax,%eax
  8016fe:	74 1f                	je     80171f <InitializeUHeap+0x2e>
	{
		initialize_dyn_block_system();
  801700:	e8 1d 00 00 00       	call   801722 <initialize_dyn_block_system>
		cprintf("DYNAMIC BLOCK SYSTEM IS INITIALIZED\n");
  801705:	83 ec 0c             	sub    $0xc,%esp
  801708:	68 d0 3e 80 00       	push   $0x803ed0
  80170d:	e8 55 f2 ff ff       	call   800967 <cprintf>
  801712:	83 c4 10             	add    $0x10,%esp
#if UHP_USE_BUDDY
		initialize_buddy();
		cprintf("BUDDY SYSTEM IS INITIALIZED\n");
#endif
		FirstTimeFlag = 0;
  801715:	c7 05 04 50 80 00 00 	movl   $0x0,0x805004
  80171c:	00 00 00 
	}
}
  80171f:	90                   	nop
  801720:	c9                   	leave  
  801721:	c3                   	ret    

00801722 <initialize_dyn_block_system>:

//=================================
// [1] INITIALIZE DYNAMIC ALLOCATOR:
//=================================
void initialize_dyn_block_system()
{
  801722:	55                   	push   %ebp
  801723:	89 e5                	mov    %esp,%ebp
  801725:	83 ec 28             	sub    $0x28,%esp
	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] initialize_dyn_block_system
	// your code is here, remove the panic and write your code
	//panic("initialize_dyn_block_system() is not implemented yet...!!");

	LIST_INIT(&AllocMemBlocksList);
  801728:	c7 05 40 50 80 00 00 	movl   $0x0,0x805040
  80172f:	00 00 00 
  801732:	c7 05 44 50 80 00 00 	movl   $0x0,0x805044
  801739:	00 00 00 
  80173c:	c7 05 4c 50 80 00 00 	movl   $0x0,0x80504c
  801743:	00 00 00 
	LIST_INIT(&FreeMemBlocksList);
  801746:	c7 05 38 51 80 00 00 	movl   $0x0,0x805138
  80174d:	00 00 00 
  801750:	c7 05 3c 51 80 00 00 	movl   $0x0,0x80513c
  801757:	00 00 00 
  80175a:	c7 05 44 51 80 00 00 	movl   $0x0,0x805144
  801761:	00 00 00 
	MAX_MEM_BLOCK_CNT = NUM_OF_UHEAP_PAGES;
  801764:	c7 05 20 51 80 00 00 	movl   $0x20000,0x805120
  80176b:	00 02 00 
	MemBlockNodes = (void*)USER_DYN_BLKS_ARRAY;
  80176e:	c7 45 f4 00 00 e0 7f 	movl   $0x7fe00000,-0xc(%ebp)
  801775:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801778:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  80177d:	2d 00 10 00 00       	sub    $0x1000,%eax
  801782:	a3 50 50 80 00       	mov    %eax,0x805050
	int size_of_block = sizeof(struct MemBlock);
  801787:	c7 45 f0 10 00 00 00 	movl   $0x10,-0x10(%ebp)
	int size_all_struct = size_of_block*MAX_MEM_BLOCK_CNT;
  80178e:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801791:	a1 20 51 80 00       	mov    0x805120,%eax
  801796:	0f af c2             	imul   %edx,%eax
  801799:	89 45 ec             	mov    %eax,-0x14(%ebp)
	size_all_struct = ROUNDUP(size_all_struct, PAGE_SIZE);
  80179c:	c7 45 e8 00 10 00 00 	movl   $0x1000,-0x18(%ebp)
  8017a3:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8017a6:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8017a9:	01 d0                	add    %edx,%eax
  8017ab:	48                   	dec    %eax
  8017ac:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8017af:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8017b2:	ba 00 00 00 00       	mov    $0x0,%edx
  8017b7:	f7 75 e8             	divl   -0x18(%ebp)
  8017ba:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8017bd:	29 d0                	sub    %edx,%eax
  8017bf:	89 45 ec             	mov    %eax,-0x14(%ebp)
	sys_allocate_chunk(USER_DYN_BLKS_ARRAY, size_all_struct,PERM_USER| PERM_WRITEABLE);
  8017c2:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8017c5:	c7 45 e0 00 00 e0 7f 	movl   $0x7fe00000,-0x20(%ebp)
  8017cc:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8017cf:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
  8017d5:	81 ea 00 10 00 00    	sub    $0x1000,%edx
  8017db:	83 ec 04             	sub    $0x4,%esp
  8017de:	6a 06                	push   $0x6
  8017e0:	50                   	push   %eax
  8017e1:	52                   	push   %edx
  8017e2:	e8 a1 05 00 00       	call   801d88 <sys_allocate_chunk>
  8017e7:	83 c4 10             	add    $0x10,%esp
	initialize_MemBlocksList(MAX_MEM_BLOCK_CNT);
  8017ea:	a1 20 51 80 00       	mov    0x805120,%eax
  8017ef:	83 ec 0c             	sub    $0xc,%esp
  8017f2:	50                   	push   %eax
  8017f3:	e8 16 0c 00 00       	call   80240e <initialize_MemBlocksList>
  8017f8:	83 c4 10             	add    $0x10,%esp
	struct MemBlock* ourBlock =LIST_LAST(&AvailableMemBlocksList);
  8017fb:	a1 4c 51 80 00       	mov    0x80514c,%eax
  801800:	89 45 dc             	mov    %eax,-0x24(%ebp)
	LIST_REMOVE(&AvailableMemBlocksList,ourBlock);
  801803:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  801807:	75 14                	jne    80181d <initialize_dyn_block_system+0xfb>
  801809:	83 ec 04             	sub    $0x4,%esp
  80180c:	68 f5 3e 80 00       	push   $0x803ef5
  801811:	6a 2d                	push   $0x2d
  801813:	68 13 3f 80 00       	push   $0x803f13
  801818:	e8 96 ee ff ff       	call   8006b3 <_panic>
  80181d:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801820:	8b 00                	mov    (%eax),%eax
  801822:	85 c0                	test   %eax,%eax
  801824:	74 10                	je     801836 <initialize_dyn_block_system+0x114>
  801826:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801829:	8b 00                	mov    (%eax),%eax
  80182b:	8b 55 dc             	mov    -0x24(%ebp),%edx
  80182e:	8b 52 04             	mov    0x4(%edx),%edx
  801831:	89 50 04             	mov    %edx,0x4(%eax)
  801834:	eb 0b                	jmp    801841 <initialize_dyn_block_system+0x11f>
  801836:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801839:	8b 40 04             	mov    0x4(%eax),%eax
  80183c:	a3 4c 51 80 00       	mov    %eax,0x80514c
  801841:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801844:	8b 40 04             	mov    0x4(%eax),%eax
  801847:	85 c0                	test   %eax,%eax
  801849:	74 0f                	je     80185a <initialize_dyn_block_system+0x138>
  80184b:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80184e:	8b 40 04             	mov    0x4(%eax),%eax
  801851:	8b 55 dc             	mov    -0x24(%ebp),%edx
  801854:	8b 12                	mov    (%edx),%edx
  801856:	89 10                	mov    %edx,(%eax)
  801858:	eb 0a                	jmp    801864 <initialize_dyn_block_system+0x142>
  80185a:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80185d:	8b 00                	mov    (%eax),%eax
  80185f:	a3 48 51 80 00       	mov    %eax,0x805148
  801864:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801867:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80186d:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801870:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  801877:	a1 54 51 80 00       	mov    0x805154,%eax
  80187c:	48                   	dec    %eax
  80187d:	a3 54 51 80 00       	mov    %eax,0x805154
	ourBlock->size = USER_HEAP_MAX-USER_HEAP_START;
  801882:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801885:	c7 40 0c 00 00 00 20 	movl   $0x20000000,0xc(%eax)
	ourBlock->sva=USER_HEAP_START;
  80188c:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80188f:	c7 40 08 00 00 00 80 	movl   $0x80000000,0x8(%eax)
	LIST_INSERT_TAIL(&FreeMemBlocksList, ourBlock);
  801896:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  80189a:	75 14                	jne    8018b0 <initialize_dyn_block_system+0x18e>
  80189c:	83 ec 04             	sub    $0x4,%esp
  80189f:	68 20 3f 80 00       	push   $0x803f20
  8018a4:	6a 30                	push   $0x30
  8018a6:	68 13 3f 80 00       	push   $0x803f13
  8018ab:	e8 03 ee ff ff       	call   8006b3 <_panic>
  8018b0:	8b 15 3c 51 80 00    	mov    0x80513c,%edx
  8018b6:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8018b9:	89 50 04             	mov    %edx,0x4(%eax)
  8018bc:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8018bf:	8b 40 04             	mov    0x4(%eax),%eax
  8018c2:	85 c0                	test   %eax,%eax
  8018c4:	74 0c                	je     8018d2 <initialize_dyn_block_system+0x1b0>
  8018c6:	a1 3c 51 80 00       	mov    0x80513c,%eax
  8018cb:	8b 55 dc             	mov    -0x24(%ebp),%edx
  8018ce:	89 10                	mov    %edx,(%eax)
  8018d0:	eb 08                	jmp    8018da <initialize_dyn_block_system+0x1b8>
  8018d2:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8018d5:	a3 38 51 80 00       	mov    %eax,0x805138
  8018da:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8018dd:	a3 3c 51 80 00       	mov    %eax,0x80513c
  8018e2:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8018e5:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8018eb:	a1 44 51 80 00       	mov    0x805144,%eax
  8018f0:	40                   	inc    %eax
  8018f1:	a3 44 51 80 00       	mov    %eax,0x805144
	//[1] Initialize two lists (AllocMemBlocksList & FreeMemBlocksList) [Hint: use LIST_INIT()]
	//[2] Dynamically allocate the array of MemBlockNodes at VA USER_DYN_BLKS_ARRAY
	//	  (remember to set MAX_MEM_BLOCK_CNT with the chosen size of the array)
	//[3] Initialize AvailableMemBlocksList by filling it with the MemBlockNodes
	//[4] Insert a new MemBlock with the heap size into the FreeMemBlocksList
}
  8018f6:	90                   	nop
  8018f7:	c9                   	leave  
  8018f8:	c3                   	ret    

008018f9 <malloc>:
//=================================
// [2] ALLOCATE SPACE IN USER HEAP:
//=================================

void* malloc(uint32 size)
{
  8018f9:	55                   	push   %ebp
  8018fa:	89 e5                	mov    %esp,%ebp
  8018fc:	83 ec 18             	sub    $0x18,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  8018ff:	e8 ed fd ff ff       	call   8016f1 <InitializeUHeap>
	if (size == 0) return NULL ;
  801904:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801908:	75 07                	jne    801911 <malloc+0x18>
  80190a:	b8 00 00 00 00       	mov    $0x0,%eax
  80190f:	eb 67                	jmp    801978 <malloc+0x7f>

	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] malloc
	// your code is here, remove the panic and write your code
	//panic("malloc() is not implemented yet...!!");

	size = ROUNDUP(size, PAGE_SIZE);
  801911:	c7 45 f4 00 10 00 00 	movl   $0x1000,-0xc(%ebp)
  801918:	8b 55 08             	mov    0x8(%ebp),%edx
  80191b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80191e:	01 d0                	add    %edx,%eax
  801920:	48                   	dec    %eax
  801921:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801924:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801927:	ba 00 00 00 00       	mov    $0x0,%edx
  80192c:	f7 75 f4             	divl   -0xc(%ebp)
  80192f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801932:	29 d0                	sub    %edx,%eax
  801934:	89 45 08             	mov    %eax,0x8(%ebp)
	if(sys_isUHeapPlacementStrategyFIRSTFIT())
  801937:	e8 1a 08 00 00       	call   802156 <sys_isUHeapPlacementStrategyFIRSTFIT>
  80193c:	85 c0                	test   %eax,%eax
  80193e:	74 33                	je     801973 <malloc+0x7a>
	{
		struct MemBlock * myBlock = alloc_block_FF(size);
  801940:	83 ec 0c             	sub    $0xc,%esp
  801943:	ff 75 08             	pushl  0x8(%ebp)
  801946:	e8 0c 0e 00 00       	call   802757 <alloc_block_FF>
  80194b:	83 c4 10             	add    $0x10,%esp
  80194e:	89 45 ec             	mov    %eax,-0x14(%ebp)
		if(myBlock != NULL)
  801951:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  801955:	74 1c                	je     801973 <malloc+0x7a>
		{
			insert_sorted_allocList(myBlock);
  801957:	83 ec 0c             	sub    $0xc,%esp
  80195a:	ff 75 ec             	pushl  -0x14(%ebp)
  80195d:	e8 07 0c 00 00       	call   802569 <insert_sorted_allocList>
  801962:	83 c4 10             	add    $0x10,%esp
			uint32 ptr = myBlock->sva;
  801965:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801968:	8b 40 08             	mov    0x8(%eax),%eax
  80196b:	89 45 e8             	mov    %eax,-0x18(%ebp)
			return (void *)ptr;
  80196e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801971:	eb 05                	jmp    801978 <malloc+0x7f>
		}
	}
	return NULL;
  801973:	b8 00 00 00 00       	mov    $0x0,%eax
	//		to the required allocation size (space should be on 4 KB BOUNDARY)
	//	2) if no suitable space found, return NULL
	// 	3) Return pointer containing the virtual address of allocated space,
	//
	//Use sys_isUHeapPlacementStrategyFIRSTFIT()... to check the current strategy
}
  801978:	c9                   	leave  
  801979:	c3                   	ret    

0080197a <free>:
//	We can use sys_free_user_mem(uint32 virtual_address, uint32 size); which
//		switches to the kernel mode, calls free_user_mem() in
//		"kern/mem/chunk_operations.c", then switch back to the user mode here
//	the free_user_mem function is empty, make sure to implement it.
void free(void* virtual_address)
{
  80197a:	55                   	push   %ebp
  80197b:	89 e5                	mov    %esp,%ebp
  80197d:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] free
	// your code is here, remove the panic and write your code
	//panic("free() is not implemented yet...!!");

	uint32 virtualAddress = (uint32 )(virtual_address);
  801980:	8b 45 08             	mov    0x8(%ebp),%eax
  801983:	89 45 f4             	mov    %eax,-0xc(%ebp)
//	virtualAddress = ROUNDDOWN(virtualAddress, PAGE_SIZE);
	struct MemBlock * myBlock = find_block(&AllocMemBlocksList, virtualAddress);
  801986:	83 ec 08             	sub    $0x8,%esp
  801989:	ff 75 f4             	pushl  -0xc(%ebp)
  80198c:	68 40 50 80 00       	push   $0x805040
  801991:	e8 5b 0b 00 00       	call   8024f1 <find_block>
  801996:	83 c4 10             	add    $0x10,%esp
  801999:	89 45 f0             	mov    %eax,-0x10(%ebp)
//	cprintf ("ptr sva at free user side = %x \n", myBlock->sva);
	sys_free_user_mem(virtualAddress, myBlock->size);
  80199c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80199f:	8b 40 0c             	mov    0xc(%eax),%eax
  8019a2:	83 ec 08             	sub    $0x8,%esp
  8019a5:	50                   	push   %eax
  8019a6:	ff 75 f4             	pushl  -0xc(%ebp)
  8019a9:	e8 a2 03 00 00       	call   801d50 <sys_free_user_mem>
  8019ae:	83 c4 10             	add    $0x10,%esp
	LIST_REMOVE(&AllocMemBlocksList, myBlock);
  8019b1:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8019b5:	75 14                	jne    8019cb <free+0x51>
  8019b7:	83 ec 04             	sub    $0x4,%esp
  8019ba:	68 f5 3e 80 00       	push   $0x803ef5
  8019bf:	6a 76                	push   $0x76
  8019c1:	68 13 3f 80 00       	push   $0x803f13
  8019c6:	e8 e8 ec ff ff       	call   8006b3 <_panic>
  8019cb:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8019ce:	8b 00                	mov    (%eax),%eax
  8019d0:	85 c0                	test   %eax,%eax
  8019d2:	74 10                	je     8019e4 <free+0x6a>
  8019d4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8019d7:	8b 00                	mov    (%eax),%eax
  8019d9:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8019dc:	8b 52 04             	mov    0x4(%edx),%edx
  8019df:	89 50 04             	mov    %edx,0x4(%eax)
  8019e2:	eb 0b                	jmp    8019ef <free+0x75>
  8019e4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8019e7:	8b 40 04             	mov    0x4(%eax),%eax
  8019ea:	a3 44 50 80 00       	mov    %eax,0x805044
  8019ef:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8019f2:	8b 40 04             	mov    0x4(%eax),%eax
  8019f5:	85 c0                	test   %eax,%eax
  8019f7:	74 0f                	je     801a08 <free+0x8e>
  8019f9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8019fc:	8b 40 04             	mov    0x4(%eax),%eax
  8019ff:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801a02:	8b 12                	mov    (%edx),%edx
  801a04:	89 10                	mov    %edx,(%eax)
  801a06:	eb 0a                	jmp    801a12 <free+0x98>
  801a08:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801a0b:	8b 00                	mov    (%eax),%eax
  801a0d:	a3 40 50 80 00       	mov    %eax,0x805040
  801a12:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801a15:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  801a1b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801a1e:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  801a25:	a1 4c 50 80 00       	mov    0x80504c,%eax
  801a2a:	48                   	dec    %eax
  801a2b:	a3 4c 50 80 00       	mov    %eax,0x80504c
	insert_sorted_with_merge_freeList(myBlock);
  801a30:	83 ec 0c             	sub    $0xc,%esp
  801a33:	ff 75 f0             	pushl  -0x10(%ebp)
  801a36:	e8 0b 14 00 00       	call   802e46 <insert_sorted_with_merge_freeList>
  801a3b:	83 c4 10             	add    $0x10,%esp

	//you should get the size of the given allocation using its address
	//you need to call sys_free_user_mem()
	//refer to the project presentation and documentation for details
}
  801a3e:	90                   	nop
  801a3f:	c9                   	leave  
  801a40:	c3                   	ret    

00801a41 <smalloc>:

//=================================
// [4] ALLOCATE SHARED VARIABLE:
//=================================
void* smalloc(char *sharedVarName, uint32 size, uint8 isWritable)
{
  801a41:	55                   	push   %ebp
  801a42:	89 e5                	mov    %esp,%ebp
  801a44:	83 ec 28             	sub    $0x28,%esp
  801a47:	8b 45 10             	mov    0x10(%ebp),%eax
  801a4a:	88 45 e4             	mov    %al,-0x1c(%ebp)
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801a4d:	e8 9f fc ff ff       	call   8016f1 <InitializeUHeap>
	if (size == 0) return NULL ;
  801a52:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801a56:	75 0a                	jne    801a62 <smalloc+0x21>
  801a58:	b8 00 00 00 00       	mov    $0x0,%eax
  801a5d:	e9 8d 00 00 00       	jmp    801aef <smalloc+0xae>

	//This function should find the space of the required range
	// * ON 4KB BOUNDARY **** //
	//Use sys_isUHeapPlacementStrategyFIRSTFIT() to check the current strategy

	size = ROUNDUP(size, PAGE_SIZE);
  801a62:	c7 45 f4 00 10 00 00 	movl   $0x1000,-0xc(%ebp)
  801a69:	8b 55 0c             	mov    0xc(%ebp),%edx
  801a6c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801a6f:	01 d0                	add    %edx,%eax
  801a71:	48                   	dec    %eax
  801a72:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801a75:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801a78:	ba 00 00 00 00       	mov    $0x0,%edx
  801a7d:	f7 75 f4             	divl   -0xc(%ebp)
  801a80:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801a83:	29 d0                	sub    %edx,%eax
  801a85:	89 45 0c             	mov    %eax,0xc(%ebp)
		if(sys_isUHeapPlacementStrategyFIRSTFIT())
  801a88:	e8 c9 06 00 00       	call   802156 <sys_isUHeapPlacementStrategyFIRSTFIT>
  801a8d:	85 c0                	test   %eax,%eax
  801a8f:	74 59                	je     801aea <smalloc+0xa9>
		{
			struct MemBlock * v1=NULL;
  801a91:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
			v1= alloc_block_FF(size);
  801a98:	83 ec 0c             	sub    $0xc,%esp
  801a9b:	ff 75 0c             	pushl  0xc(%ebp)
  801a9e:	e8 b4 0c 00 00       	call   802757 <alloc_block_FF>
  801aa3:	83 c4 10             	add    $0x10,%esp
  801aa6:	89 45 ec             	mov    %eax,-0x14(%ebp)
			if(v1==NULL)
  801aa9:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  801aad:	75 07                	jne    801ab6 <smalloc+0x75>
			{
				return NULL;
  801aaf:	b8 00 00 00 00       	mov    $0x0,%eax
  801ab4:	eb 39                	jmp    801aef <smalloc+0xae>
			}
			else
			{
				int ret=sys_createSharedObject(sharedVarName,  size,  isWritable,(void*)v1->sva);
  801ab6:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801ab9:	8b 40 08             	mov    0x8(%eax),%eax
  801abc:	89 c2                	mov    %eax,%edx
  801abe:	0f b6 45 e4          	movzbl -0x1c(%ebp),%eax
  801ac2:	52                   	push   %edx
  801ac3:	50                   	push   %eax
  801ac4:	ff 75 0c             	pushl  0xc(%ebp)
  801ac7:	ff 75 08             	pushl  0x8(%ebp)
  801aca:	e8 0c 04 00 00       	call   801edb <sys_createSharedObject>
  801acf:	83 c4 10             	add    $0x10,%esp
  801ad2:	89 45 e8             	mov    %eax,-0x18(%ebp)
				if(ret>=0)
  801ad5:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  801ad9:	78 08                	js     801ae3 <smalloc+0xa2>
				{
					return (void*)v1->sva;
  801adb:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801ade:	8b 40 08             	mov    0x8(%eax),%eax
  801ae1:	eb 0c                	jmp    801aef <smalloc+0xae>
				}
				else
				{
					return NULL;
  801ae3:	b8 00 00 00 00       	mov    $0x0,%eax
  801ae8:	eb 05                	jmp    801aef <smalloc+0xae>
				}
			}

		}
		return NULL;
  801aea:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801aef:	c9                   	leave  
  801af0:	c3                   	ret    

00801af1 <sget>:

//========================================
// [5] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
  801af1:	55                   	push   %ebp
  801af2:	89 e5                	mov    %esp,%ebp
  801af4:	83 ec 18             	sub    $0x18,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801af7:	e8 f5 fb ff ff       	call   8016f1 <InitializeUHeap>

	//This function should find the space for sharing the variable
	// *** ON 4KB BOUNDARY ******** //

	//Use sys_isUHeapPlacementStrategyFIRSTFIT() to check the current strategy
	int ret=sys_getSizeOfSharedObject(ownerEnvID,sharedVarName);
  801afc:	83 ec 08             	sub    $0x8,%esp
  801aff:	ff 75 0c             	pushl  0xc(%ebp)
  801b02:	ff 75 08             	pushl  0x8(%ebp)
  801b05:	e8 fb 03 00 00       	call   801f05 <sys_getSizeOfSharedObject>
  801b0a:	83 c4 10             	add    $0x10,%esp
  801b0d:	89 45 f4             	mov    %eax,-0xc(%ebp)
	if(ret==0)
  801b10:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801b14:	75 07                	jne    801b1d <sget+0x2c>
	{
		return NULL;
  801b16:	b8 00 00 00 00       	mov    $0x0,%eax
  801b1b:	eb 64                	jmp    801b81 <sget+0x90>
	}
	if(sys_isUHeapPlacementStrategyFIRSTFIT())
  801b1d:	e8 34 06 00 00       	call   802156 <sys_isUHeapPlacementStrategyFIRSTFIT>
  801b22:	85 c0                	test   %eax,%eax
  801b24:	74 56                	je     801b7c <sget+0x8b>
	{
		struct MemBlock * v1=NULL;
  801b26:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
		v1= alloc_block_FF(ret);
  801b2d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801b30:	83 ec 0c             	sub    $0xc,%esp
  801b33:	50                   	push   %eax
  801b34:	e8 1e 0c 00 00       	call   802757 <alloc_block_FF>
  801b39:	83 c4 10             	add    $0x10,%esp
  801b3c:	89 45 f0             	mov    %eax,-0x10(%ebp)
		if(v1==NULL)
  801b3f:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801b43:	75 07                	jne    801b4c <sget+0x5b>
		{
		return NULL;
  801b45:	b8 00 00 00 00       	mov    $0x0,%eax
  801b4a:	eb 35                	jmp    801b81 <sget+0x90>
	    }
		else
		{
			int ret1=sys_getSharedObject(ownerEnvID,sharedVarName,(void*)v1->sva);
  801b4c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801b4f:	8b 40 08             	mov    0x8(%eax),%eax
  801b52:	83 ec 04             	sub    $0x4,%esp
  801b55:	50                   	push   %eax
  801b56:	ff 75 0c             	pushl  0xc(%ebp)
  801b59:	ff 75 08             	pushl  0x8(%ebp)
  801b5c:	e8 c1 03 00 00       	call   801f22 <sys_getSharedObject>
  801b61:	83 c4 10             	add    $0x10,%esp
  801b64:	89 45 ec             	mov    %eax,-0x14(%ebp)
			if(ret1>=0)
  801b67:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  801b6b:	78 08                	js     801b75 <sget+0x84>
			{
				return (void*)v1->sva;
  801b6d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801b70:	8b 40 08             	mov    0x8(%eax),%eax
  801b73:	eb 0c                	jmp    801b81 <sget+0x90>
			}
			else
			{
				return NULL;
  801b75:	b8 00 00 00 00       	mov    $0x0,%eax
  801b7a:	eb 05                	jmp    801b81 <sget+0x90>
			}
		}
	}
  return NULL;
  801b7c:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801b81:	c9                   	leave  
  801b82:	c3                   	ret    

00801b83 <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  801b83:	55                   	push   %ebp
  801b84:	89 e5                	mov    %esp,%ebp
  801b86:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801b89:	e8 63 fb ff ff       	call   8016f1 <InitializeUHeap>
	//==============================================================
	// [USER HEAP - USER SIDE] realloc
	// Write your code here, remove the panic and write your code
	panic("realloc() is not implemented yet...!!");
  801b8e:	83 ec 04             	sub    $0x4,%esp
  801b91:	68 44 3f 80 00       	push   $0x803f44
  801b96:	68 0e 01 00 00       	push   $0x10e
  801b9b:	68 13 3f 80 00       	push   $0x803f13
  801ba0:	e8 0e eb ff ff       	call   8006b3 <_panic>

00801ba5 <sfree>:
//	use sys_freeSharedObject(...); which switches to the kernel mode,
//	calls freeSharedObject(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the freeSharedObject() function is empty, make sure to implement it.

void sfree(void* virtual_address)
{
  801ba5:	55                   	push   %ebp
  801ba6:	89 e5                	mov    %esp,%ebp
  801ba8:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT MS3 - BONUS] [SHARING - USER SIDE] sfree()

	// Write your code here, remove the panic and write your code
	panic("sfree() is not implemented yet...!!");
  801bab:	83 ec 04             	sub    $0x4,%esp
  801bae:	68 6c 3f 80 00       	push   $0x803f6c
  801bb3:	68 22 01 00 00       	push   $0x122
  801bb8:	68 13 3f 80 00       	push   $0x803f13
  801bbd:	e8 f1 ea ff ff       	call   8006b3 <_panic>

00801bc2 <expand>:

//==================================================================================//
//========================== MODIFICATION FUNCTIONS ================================//
//==================================================================================//
void expand(uint32 newSize)
{
  801bc2:	55                   	push   %ebp
  801bc3:	89 e5                	mov    %esp,%ebp
  801bc5:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801bc8:	83 ec 04             	sub    $0x4,%esp
  801bcb:	68 90 3f 80 00       	push   $0x803f90
  801bd0:	68 2d 01 00 00       	push   $0x12d
  801bd5:	68 13 3f 80 00       	push   $0x803f13
  801bda:	e8 d4 ea ff ff       	call   8006b3 <_panic>

00801bdf <shrink>:

}
void shrink(uint32 newSize)
{
  801bdf:	55                   	push   %ebp
  801be0:	89 e5                	mov    %esp,%ebp
  801be2:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801be5:	83 ec 04             	sub    $0x4,%esp
  801be8:	68 90 3f 80 00       	push   $0x803f90
  801bed:	68 32 01 00 00       	push   $0x132
  801bf2:	68 13 3f 80 00       	push   $0x803f13
  801bf7:	e8 b7 ea ff ff       	call   8006b3 <_panic>

00801bfc <freeHeap>:

}
void freeHeap(void* virtual_address)
{
  801bfc:	55                   	push   %ebp
  801bfd:	89 e5                	mov    %esp,%ebp
  801bff:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801c02:	83 ec 04             	sub    $0x4,%esp
  801c05:	68 90 3f 80 00       	push   $0x803f90
  801c0a:	68 37 01 00 00       	push   $0x137
  801c0f:	68 13 3f 80 00       	push   $0x803f13
  801c14:	e8 9a ea ff ff       	call   8006b3 <_panic>

00801c19 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  801c19:	55                   	push   %ebp
  801c1a:	89 e5                	mov    %esp,%ebp
  801c1c:	57                   	push   %edi
  801c1d:	56                   	push   %esi
  801c1e:	53                   	push   %ebx
  801c1f:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801c22:	8b 45 08             	mov    0x8(%ebp),%eax
  801c25:	8b 55 0c             	mov    0xc(%ebp),%edx
  801c28:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801c2b:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801c2e:	8b 7d 18             	mov    0x18(%ebp),%edi
  801c31:	8b 75 1c             	mov    0x1c(%ebp),%esi
  801c34:	cd 30                	int    $0x30
  801c36:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  801c39:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801c3c:	83 c4 10             	add    $0x10,%esp
  801c3f:	5b                   	pop    %ebx
  801c40:	5e                   	pop    %esi
  801c41:	5f                   	pop    %edi
  801c42:	5d                   	pop    %ebp
  801c43:	c3                   	ret    

00801c44 <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  801c44:	55                   	push   %ebp
  801c45:	89 e5                	mov    %esp,%ebp
  801c47:	83 ec 04             	sub    $0x4,%esp
  801c4a:	8b 45 10             	mov    0x10(%ebp),%eax
  801c4d:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  801c50:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801c54:	8b 45 08             	mov    0x8(%ebp),%eax
  801c57:	6a 00                	push   $0x0
  801c59:	6a 00                	push   $0x0
  801c5b:	52                   	push   %edx
  801c5c:	ff 75 0c             	pushl  0xc(%ebp)
  801c5f:	50                   	push   %eax
  801c60:	6a 00                	push   $0x0
  801c62:	e8 b2 ff ff ff       	call   801c19 <syscall>
  801c67:	83 c4 18             	add    $0x18,%esp
}
  801c6a:	90                   	nop
  801c6b:	c9                   	leave  
  801c6c:	c3                   	ret    

00801c6d <sys_cgetc>:

int
sys_cgetc(void)
{
  801c6d:	55                   	push   %ebp
  801c6e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  801c70:	6a 00                	push   $0x0
  801c72:	6a 00                	push   $0x0
  801c74:	6a 00                	push   $0x0
  801c76:	6a 00                	push   $0x0
  801c78:	6a 00                	push   $0x0
  801c7a:	6a 01                	push   $0x1
  801c7c:	e8 98 ff ff ff       	call   801c19 <syscall>
  801c81:	83 c4 18             	add    $0x18,%esp
}
  801c84:	c9                   	leave  
  801c85:	c3                   	ret    

00801c86 <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  801c86:	55                   	push   %ebp
  801c87:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  801c89:	8b 55 0c             	mov    0xc(%ebp),%edx
  801c8c:	8b 45 08             	mov    0x8(%ebp),%eax
  801c8f:	6a 00                	push   $0x0
  801c91:	6a 00                	push   $0x0
  801c93:	6a 00                	push   $0x0
  801c95:	52                   	push   %edx
  801c96:	50                   	push   %eax
  801c97:	6a 05                	push   $0x5
  801c99:	e8 7b ff ff ff       	call   801c19 <syscall>
  801c9e:	83 c4 18             	add    $0x18,%esp
}
  801ca1:	c9                   	leave  
  801ca2:	c3                   	ret    

00801ca3 <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  801ca3:	55                   	push   %ebp
  801ca4:	89 e5                	mov    %esp,%ebp
  801ca6:	56                   	push   %esi
  801ca7:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  801ca8:	8b 75 18             	mov    0x18(%ebp),%esi
  801cab:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801cae:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801cb1:	8b 55 0c             	mov    0xc(%ebp),%edx
  801cb4:	8b 45 08             	mov    0x8(%ebp),%eax
  801cb7:	56                   	push   %esi
  801cb8:	53                   	push   %ebx
  801cb9:	51                   	push   %ecx
  801cba:	52                   	push   %edx
  801cbb:	50                   	push   %eax
  801cbc:	6a 06                	push   $0x6
  801cbe:	e8 56 ff ff ff       	call   801c19 <syscall>
  801cc3:	83 c4 18             	add    $0x18,%esp
}
  801cc6:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801cc9:	5b                   	pop    %ebx
  801cca:	5e                   	pop    %esi
  801ccb:	5d                   	pop    %ebp
  801ccc:	c3                   	ret    

00801ccd <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  801ccd:	55                   	push   %ebp
  801cce:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  801cd0:	8b 55 0c             	mov    0xc(%ebp),%edx
  801cd3:	8b 45 08             	mov    0x8(%ebp),%eax
  801cd6:	6a 00                	push   $0x0
  801cd8:	6a 00                	push   $0x0
  801cda:	6a 00                	push   $0x0
  801cdc:	52                   	push   %edx
  801cdd:	50                   	push   %eax
  801cde:	6a 07                	push   $0x7
  801ce0:	e8 34 ff ff ff       	call   801c19 <syscall>
  801ce5:	83 c4 18             	add    $0x18,%esp
}
  801ce8:	c9                   	leave  
  801ce9:	c3                   	ret    

00801cea <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  801cea:	55                   	push   %ebp
  801ceb:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  801ced:	6a 00                	push   $0x0
  801cef:	6a 00                	push   $0x0
  801cf1:	6a 00                	push   $0x0
  801cf3:	ff 75 0c             	pushl  0xc(%ebp)
  801cf6:	ff 75 08             	pushl  0x8(%ebp)
  801cf9:	6a 08                	push   $0x8
  801cfb:	e8 19 ff ff ff       	call   801c19 <syscall>
  801d00:	83 c4 18             	add    $0x18,%esp
}
  801d03:	c9                   	leave  
  801d04:	c3                   	ret    

00801d05 <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  801d05:	55                   	push   %ebp
  801d06:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  801d08:	6a 00                	push   $0x0
  801d0a:	6a 00                	push   $0x0
  801d0c:	6a 00                	push   $0x0
  801d0e:	6a 00                	push   $0x0
  801d10:	6a 00                	push   $0x0
  801d12:	6a 09                	push   $0x9
  801d14:	e8 00 ff ff ff       	call   801c19 <syscall>
  801d19:	83 c4 18             	add    $0x18,%esp
}
  801d1c:	c9                   	leave  
  801d1d:	c3                   	ret    

00801d1e <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  801d1e:	55                   	push   %ebp
  801d1f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  801d21:	6a 00                	push   $0x0
  801d23:	6a 00                	push   $0x0
  801d25:	6a 00                	push   $0x0
  801d27:	6a 00                	push   $0x0
  801d29:	6a 00                	push   $0x0
  801d2b:	6a 0a                	push   $0xa
  801d2d:	e8 e7 fe ff ff       	call   801c19 <syscall>
  801d32:	83 c4 18             	add    $0x18,%esp
}
  801d35:	c9                   	leave  
  801d36:	c3                   	ret    

00801d37 <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  801d37:	55                   	push   %ebp
  801d38:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  801d3a:	6a 00                	push   $0x0
  801d3c:	6a 00                	push   $0x0
  801d3e:	6a 00                	push   $0x0
  801d40:	6a 00                	push   $0x0
  801d42:	6a 00                	push   $0x0
  801d44:	6a 0b                	push   $0xb
  801d46:	e8 ce fe ff ff       	call   801c19 <syscall>
  801d4b:	83 c4 18             	add    $0x18,%esp
}
  801d4e:	c9                   	leave  
  801d4f:	c3                   	ret    

00801d50 <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  801d50:	55                   	push   %ebp
  801d51:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  801d53:	6a 00                	push   $0x0
  801d55:	6a 00                	push   $0x0
  801d57:	6a 00                	push   $0x0
  801d59:	ff 75 0c             	pushl  0xc(%ebp)
  801d5c:	ff 75 08             	pushl  0x8(%ebp)
  801d5f:	6a 0f                	push   $0xf
  801d61:	e8 b3 fe ff ff       	call   801c19 <syscall>
  801d66:	83 c4 18             	add    $0x18,%esp
	return;
  801d69:	90                   	nop
}
  801d6a:	c9                   	leave  
  801d6b:	c3                   	ret    

00801d6c <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  801d6c:	55                   	push   %ebp
  801d6d:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  801d6f:	6a 00                	push   $0x0
  801d71:	6a 00                	push   $0x0
  801d73:	6a 00                	push   $0x0
  801d75:	ff 75 0c             	pushl  0xc(%ebp)
  801d78:	ff 75 08             	pushl  0x8(%ebp)
  801d7b:	6a 10                	push   $0x10
  801d7d:	e8 97 fe ff ff       	call   801c19 <syscall>
  801d82:	83 c4 18             	add    $0x18,%esp
	return ;
  801d85:	90                   	nop
}
  801d86:	c9                   	leave  
  801d87:	c3                   	ret    

00801d88 <sys_allocate_chunk>:

void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  801d88:	55                   	push   %ebp
  801d89:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  801d8b:	6a 00                	push   $0x0
  801d8d:	6a 00                	push   $0x0
  801d8f:	ff 75 10             	pushl  0x10(%ebp)
  801d92:	ff 75 0c             	pushl  0xc(%ebp)
  801d95:	ff 75 08             	pushl  0x8(%ebp)
  801d98:	6a 11                	push   $0x11
  801d9a:	e8 7a fe ff ff       	call   801c19 <syscall>
  801d9f:	83 c4 18             	add    $0x18,%esp
	return ;
  801da2:	90                   	nop
}
  801da3:	c9                   	leave  
  801da4:	c3                   	ret    

00801da5 <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  801da5:	55                   	push   %ebp
  801da6:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  801da8:	6a 00                	push   $0x0
  801daa:	6a 00                	push   $0x0
  801dac:	6a 00                	push   $0x0
  801dae:	6a 00                	push   $0x0
  801db0:	6a 00                	push   $0x0
  801db2:	6a 0c                	push   $0xc
  801db4:	e8 60 fe ff ff       	call   801c19 <syscall>
  801db9:	83 c4 18             	add    $0x18,%esp
}
  801dbc:	c9                   	leave  
  801dbd:	c3                   	ret    

00801dbe <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  801dbe:	55                   	push   %ebp
  801dbf:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  801dc1:	6a 00                	push   $0x0
  801dc3:	6a 00                	push   $0x0
  801dc5:	6a 00                	push   $0x0
  801dc7:	6a 00                	push   $0x0
  801dc9:	ff 75 08             	pushl  0x8(%ebp)
  801dcc:	6a 0d                	push   $0xd
  801dce:	e8 46 fe ff ff       	call   801c19 <syscall>
  801dd3:	83 c4 18             	add    $0x18,%esp
}
  801dd6:	c9                   	leave  
  801dd7:	c3                   	ret    

00801dd8 <sys_scarce_memory>:

void sys_scarce_memory()
{
  801dd8:	55                   	push   %ebp
  801dd9:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  801ddb:	6a 00                	push   $0x0
  801ddd:	6a 00                	push   $0x0
  801ddf:	6a 00                	push   $0x0
  801de1:	6a 00                	push   $0x0
  801de3:	6a 00                	push   $0x0
  801de5:	6a 0e                	push   $0xe
  801de7:	e8 2d fe ff ff       	call   801c19 <syscall>
  801dec:	83 c4 18             	add    $0x18,%esp
}
  801def:	90                   	nop
  801df0:	c9                   	leave  
  801df1:	c3                   	ret    

00801df2 <sys_disable_interrupt>:

//NEW !! 2012...
void
sys_disable_interrupt()
{
  801df2:	55                   	push   %ebp
  801df3:	89 e5                	mov    %esp,%ebp
	syscall(SYS_disableINTR,0, 0, 0, 0, 0);
  801df5:	6a 00                	push   $0x0
  801df7:	6a 00                	push   $0x0
  801df9:	6a 00                	push   $0x0
  801dfb:	6a 00                	push   $0x0
  801dfd:	6a 00                	push   $0x0
  801dff:	6a 13                	push   $0x13
  801e01:	e8 13 fe ff ff       	call   801c19 <syscall>
  801e06:	83 c4 18             	add    $0x18,%esp
}
  801e09:	90                   	nop
  801e0a:	c9                   	leave  
  801e0b:	c3                   	ret    

00801e0c <sys_enable_interrupt>:


void
sys_enable_interrupt()
{
  801e0c:	55                   	push   %ebp
  801e0d:	89 e5                	mov    %esp,%ebp
	syscall(SYS_enableINTR,0, 0, 0, 0, 0);
  801e0f:	6a 00                	push   $0x0
  801e11:	6a 00                	push   $0x0
  801e13:	6a 00                	push   $0x0
  801e15:	6a 00                	push   $0x0
  801e17:	6a 00                	push   $0x0
  801e19:	6a 14                	push   $0x14
  801e1b:	e8 f9 fd ff ff       	call   801c19 <syscall>
  801e20:	83 c4 18             	add    $0x18,%esp
}
  801e23:	90                   	nop
  801e24:	c9                   	leave  
  801e25:	c3                   	ret    

00801e26 <sys_cputc>:


void
sys_cputc(const char c)
{
  801e26:	55                   	push   %ebp
  801e27:	89 e5                	mov    %esp,%ebp
  801e29:	83 ec 04             	sub    $0x4,%esp
  801e2c:	8b 45 08             	mov    0x8(%ebp),%eax
  801e2f:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  801e32:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801e36:	6a 00                	push   $0x0
  801e38:	6a 00                	push   $0x0
  801e3a:	6a 00                	push   $0x0
  801e3c:	6a 00                	push   $0x0
  801e3e:	50                   	push   %eax
  801e3f:	6a 15                	push   $0x15
  801e41:	e8 d3 fd ff ff       	call   801c19 <syscall>
  801e46:	83 c4 18             	add    $0x18,%esp
}
  801e49:	90                   	nop
  801e4a:	c9                   	leave  
  801e4b:	c3                   	ret    

00801e4c <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  801e4c:	55                   	push   %ebp
  801e4d:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  801e4f:	6a 00                	push   $0x0
  801e51:	6a 00                	push   $0x0
  801e53:	6a 00                	push   $0x0
  801e55:	6a 00                	push   $0x0
  801e57:	6a 00                	push   $0x0
  801e59:	6a 16                	push   $0x16
  801e5b:	e8 b9 fd ff ff       	call   801c19 <syscall>
  801e60:	83 c4 18             	add    $0x18,%esp
}
  801e63:	90                   	nop
  801e64:	c9                   	leave  
  801e65:	c3                   	ret    

00801e66 <sys_createSemaphore>:

int
sys_createSemaphore(char* semaphoreName, uint32 initialValue)
{
  801e66:	55                   	push   %ebp
  801e67:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_semaphore,(uint32)semaphoreName, (uint32)initialValue, 0, 0, 0);
  801e69:	8b 45 08             	mov    0x8(%ebp),%eax
  801e6c:	6a 00                	push   $0x0
  801e6e:	6a 00                	push   $0x0
  801e70:	6a 00                	push   $0x0
  801e72:	ff 75 0c             	pushl  0xc(%ebp)
  801e75:	50                   	push   %eax
  801e76:	6a 17                	push   $0x17
  801e78:	e8 9c fd ff ff       	call   801c19 <syscall>
  801e7d:	83 c4 18             	add    $0x18,%esp
}
  801e80:	c9                   	leave  
  801e81:	c3                   	ret    

00801e82 <sys_getSemaphoreValue>:

int
sys_getSemaphoreValue(int32 ownerEnvID, char* semaphoreName)
{
  801e82:	55                   	push   %ebp
  801e83:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_semaphore_value,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801e85:	8b 55 0c             	mov    0xc(%ebp),%edx
  801e88:	8b 45 08             	mov    0x8(%ebp),%eax
  801e8b:	6a 00                	push   $0x0
  801e8d:	6a 00                	push   $0x0
  801e8f:	6a 00                	push   $0x0
  801e91:	52                   	push   %edx
  801e92:	50                   	push   %eax
  801e93:	6a 1a                	push   $0x1a
  801e95:	e8 7f fd ff ff       	call   801c19 <syscall>
  801e9a:	83 c4 18             	add    $0x18,%esp
}
  801e9d:	c9                   	leave  
  801e9e:	c3                   	ret    

00801e9f <sys_waitSemaphore>:

void
sys_waitSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  801e9f:	55                   	push   %ebp
  801ea0:	89 e5                	mov    %esp,%ebp
	syscall(SYS_wait_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801ea2:	8b 55 0c             	mov    0xc(%ebp),%edx
  801ea5:	8b 45 08             	mov    0x8(%ebp),%eax
  801ea8:	6a 00                	push   $0x0
  801eaa:	6a 00                	push   $0x0
  801eac:	6a 00                	push   $0x0
  801eae:	52                   	push   %edx
  801eaf:	50                   	push   %eax
  801eb0:	6a 18                	push   $0x18
  801eb2:	e8 62 fd ff ff       	call   801c19 <syscall>
  801eb7:	83 c4 18             	add    $0x18,%esp
}
  801eba:	90                   	nop
  801ebb:	c9                   	leave  
  801ebc:	c3                   	ret    

00801ebd <sys_signalSemaphore>:

void
sys_signalSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  801ebd:	55                   	push   %ebp
  801ebe:	89 e5                	mov    %esp,%ebp
	syscall(SYS_signal_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801ec0:	8b 55 0c             	mov    0xc(%ebp),%edx
  801ec3:	8b 45 08             	mov    0x8(%ebp),%eax
  801ec6:	6a 00                	push   $0x0
  801ec8:	6a 00                	push   $0x0
  801eca:	6a 00                	push   $0x0
  801ecc:	52                   	push   %edx
  801ecd:	50                   	push   %eax
  801ece:	6a 19                	push   $0x19
  801ed0:	e8 44 fd ff ff       	call   801c19 <syscall>
  801ed5:	83 c4 18             	add    $0x18,%esp
}
  801ed8:	90                   	nop
  801ed9:	c9                   	leave  
  801eda:	c3                   	ret    

00801edb <sys_createSharedObject>:

int
sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  801edb:	55                   	push   %ebp
  801edc:	89 e5                	mov    %esp,%ebp
  801ede:	83 ec 04             	sub    $0x4,%esp
  801ee1:	8b 45 10             	mov    0x10(%ebp),%eax
  801ee4:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  801ee7:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801eea:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801eee:	8b 45 08             	mov    0x8(%ebp),%eax
  801ef1:	6a 00                	push   $0x0
  801ef3:	51                   	push   %ecx
  801ef4:	52                   	push   %edx
  801ef5:	ff 75 0c             	pushl  0xc(%ebp)
  801ef8:	50                   	push   %eax
  801ef9:	6a 1b                	push   $0x1b
  801efb:	e8 19 fd ff ff       	call   801c19 <syscall>
  801f00:	83 c4 18             	add    $0x18,%esp
}
  801f03:	c9                   	leave  
  801f04:	c3                   	ret    

00801f05 <sys_getSizeOfSharedObject>:

//2017:
int
sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  801f05:	55                   	push   %ebp
  801f06:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  801f08:	8b 55 0c             	mov    0xc(%ebp),%edx
  801f0b:	8b 45 08             	mov    0x8(%ebp),%eax
  801f0e:	6a 00                	push   $0x0
  801f10:	6a 00                	push   $0x0
  801f12:	6a 00                	push   $0x0
  801f14:	52                   	push   %edx
  801f15:	50                   	push   %eax
  801f16:	6a 1c                	push   $0x1c
  801f18:	e8 fc fc ff ff       	call   801c19 <syscall>
  801f1d:	83 c4 18             	add    $0x18,%esp
}
  801f20:	c9                   	leave  
  801f21:	c3                   	ret    

00801f22 <sys_getSharedObject>:
//==========

int
sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  801f22:	55                   	push   %ebp
  801f23:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  801f25:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801f28:	8b 55 0c             	mov    0xc(%ebp),%edx
  801f2b:	8b 45 08             	mov    0x8(%ebp),%eax
  801f2e:	6a 00                	push   $0x0
  801f30:	6a 00                	push   $0x0
  801f32:	51                   	push   %ecx
  801f33:	52                   	push   %edx
  801f34:	50                   	push   %eax
  801f35:	6a 1d                	push   $0x1d
  801f37:	e8 dd fc ff ff       	call   801c19 <syscall>
  801f3c:	83 c4 18             	add    $0x18,%esp
}
  801f3f:	c9                   	leave  
  801f40:	c3                   	ret    

00801f41 <sys_freeSharedObject>:

int
sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  801f41:	55                   	push   %ebp
  801f42:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  801f44:	8b 55 0c             	mov    0xc(%ebp),%edx
  801f47:	8b 45 08             	mov    0x8(%ebp),%eax
  801f4a:	6a 00                	push   $0x0
  801f4c:	6a 00                	push   $0x0
  801f4e:	6a 00                	push   $0x0
  801f50:	52                   	push   %edx
  801f51:	50                   	push   %eax
  801f52:	6a 1e                	push   $0x1e
  801f54:	e8 c0 fc ff ff       	call   801c19 <syscall>
  801f59:	83 c4 18             	add    $0x18,%esp
}
  801f5c:	c9                   	leave  
  801f5d:	c3                   	ret    

00801f5e <sys_getMaxShares>:

uint32 	sys_getMaxShares()
{
  801f5e:	55                   	push   %ebp
  801f5f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_max_shares,0, 0, 0, 0, 0);
  801f61:	6a 00                	push   $0x0
  801f63:	6a 00                	push   $0x0
  801f65:	6a 00                	push   $0x0
  801f67:	6a 00                	push   $0x0
  801f69:	6a 00                	push   $0x0
  801f6b:	6a 1f                	push   $0x1f
  801f6d:	e8 a7 fc ff ff       	call   801c19 <syscall>
  801f72:	83 c4 18             	add    $0x18,%esp
}
  801f75:	c9                   	leave  
  801f76:	c3                   	ret    

00801f77 <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  801f77:	55                   	push   %ebp
  801f78:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  801f7a:	8b 45 08             	mov    0x8(%ebp),%eax
  801f7d:	6a 00                	push   $0x0
  801f7f:	ff 75 14             	pushl  0x14(%ebp)
  801f82:	ff 75 10             	pushl  0x10(%ebp)
  801f85:	ff 75 0c             	pushl  0xc(%ebp)
  801f88:	50                   	push   %eax
  801f89:	6a 20                	push   $0x20
  801f8b:	e8 89 fc ff ff       	call   801c19 <syscall>
  801f90:	83 c4 18             	add    $0x18,%esp
}
  801f93:	c9                   	leave  
  801f94:	c3                   	ret    

00801f95 <sys_run_env>:

void
sys_run_env(int32 envId)
{
  801f95:	55                   	push   %ebp
  801f96:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  801f98:	8b 45 08             	mov    0x8(%ebp),%eax
  801f9b:	6a 00                	push   $0x0
  801f9d:	6a 00                	push   $0x0
  801f9f:	6a 00                	push   $0x0
  801fa1:	6a 00                	push   $0x0
  801fa3:	50                   	push   %eax
  801fa4:	6a 21                	push   $0x21
  801fa6:	e8 6e fc ff ff       	call   801c19 <syscall>
  801fab:	83 c4 18             	add    $0x18,%esp
}
  801fae:	90                   	nop
  801faf:	c9                   	leave  
  801fb0:	c3                   	ret    

00801fb1 <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  801fb1:	55                   	push   %ebp
  801fb2:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  801fb4:	8b 45 08             	mov    0x8(%ebp),%eax
  801fb7:	6a 00                	push   $0x0
  801fb9:	6a 00                	push   $0x0
  801fbb:	6a 00                	push   $0x0
  801fbd:	6a 00                	push   $0x0
  801fbf:	50                   	push   %eax
  801fc0:	6a 22                	push   $0x22
  801fc2:	e8 52 fc ff ff       	call   801c19 <syscall>
  801fc7:	83 c4 18             	add    $0x18,%esp
}
  801fca:	c9                   	leave  
  801fcb:	c3                   	ret    

00801fcc <sys_getenvid>:

int32 sys_getenvid(void)
{
  801fcc:	55                   	push   %ebp
  801fcd:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  801fcf:	6a 00                	push   $0x0
  801fd1:	6a 00                	push   $0x0
  801fd3:	6a 00                	push   $0x0
  801fd5:	6a 00                	push   $0x0
  801fd7:	6a 00                	push   $0x0
  801fd9:	6a 02                	push   $0x2
  801fdb:	e8 39 fc ff ff       	call   801c19 <syscall>
  801fe0:	83 c4 18             	add    $0x18,%esp
}
  801fe3:	c9                   	leave  
  801fe4:	c3                   	ret    

00801fe5 <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  801fe5:	55                   	push   %ebp
  801fe6:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  801fe8:	6a 00                	push   $0x0
  801fea:	6a 00                	push   $0x0
  801fec:	6a 00                	push   $0x0
  801fee:	6a 00                	push   $0x0
  801ff0:	6a 00                	push   $0x0
  801ff2:	6a 03                	push   $0x3
  801ff4:	e8 20 fc ff ff       	call   801c19 <syscall>
  801ff9:	83 c4 18             	add    $0x18,%esp
}
  801ffc:	c9                   	leave  
  801ffd:	c3                   	ret    

00801ffe <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  801ffe:	55                   	push   %ebp
  801fff:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  802001:	6a 00                	push   $0x0
  802003:	6a 00                	push   $0x0
  802005:	6a 00                	push   $0x0
  802007:	6a 00                	push   $0x0
  802009:	6a 00                	push   $0x0
  80200b:	6a 04                	push   $0x4
  80200d:	e8 07 fc ff ff       	call   801c19 <syscall>
  802012:	83 c4 18             	add    $0x18,%esp
}
  802015:	c9                   	leave  
  802016:	c3                   	ret    

00802017 <sys_exit_env>:


void sys_exit_env(void)
{
  802017:	55                   	push   %ebp
  802018:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  80201a:	6a 00                	push   $0x0
  80201c:	6a 00                	push   $0x0
  80201e:	6a 00                	push   $0x0
  802020:	6a 00                	push   $0x0
  802022:	6a 00                	push   $0x0
  802024:	6a 23                	push   $0x23
  802026:	e8 ee fb ff ff       	call   801c19 <syscall>
  80202b:	83 c4 18             	add    $0x18,%esp
}
  80202e:	90                   	nop
  80202f:	c9                   	leave  
  802030:	c3                   	ret    

00802031 <sys_get_virtual_time>:


struct uint64
sys_get_virtual_time()
{
  802031:	55                   	push   %ebp
  802032:	89 e5                	mov    %esp,%ebp
  802034:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  802037:	8d 45 f8             	lea    -0x8(%ebp),%eax
  80203a:	8d 50 04             	lea    0x4(%eax),%edx
  80203d:	8d 45 f8             	lea    -0x8(%ebp),%eax
  802040:	6a 00                	push   $0x0
  802042:	6a 00                	push   $0x0
  802044:	6a 00                	push   $0x0
  802046:	52                   	push   %edx
  802047:	50                   	push   %eax
  802048:	6a 24                	push   $0x24
  80204a:	e8 ca fb ff ff       	call   801c19 <syscall>
  80204f:	83 c4 18             	add    $0x18,%esp
	return result;
  802052:	8b 4d 08             	mov    0x8(%ebp),%ecx
  802055:	8b 45 f8             	mov    -0x8(%ebp),%eax
  802058:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80205b:	89 01                	mov    %eax,(%ecx)
  80205d:	89 51 04             	mov    %edx,0x4(%ecx)
}
  802060:	8b 45 08             	mov    0x8(%ebp),%eax
  802063:	c9                   	leave  
  802064:	c2 04 00             	ret    $0x4

00802067 <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  802067:	55                   	push   %ebp
  802068:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  80206a:	6a 00                	push   $0x0
  80206c:	6a 00                	push   $0x0
  80206e:	ff 75 10             	pushl  0x10(%ebp)
  802071:	ff 75 0c             	pushl  0xc(%ebp)
  802074:	ff 75 08             	pushl  0x8(%ebp)
  802077:	6a 12                	push   $0x12
  802079:	e8 9b fb ff ff       	call   801c19 <syscall>
  80207e:	83 c4 18             	add    $0x18,%esp
	return ;
  802081:	90                   	nop
}
  802082:	c9                   	leave  
  802083:	c3                   	ret    

00802084 <sys_rcr2>:
uint32 sys_rcr2()
{
  802084:	55                   	push   %ebp
  802085:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  802087:	6a 00                	push   $0x0
  802089:	6a 00                	push   $0x0
  80208b:	6a 00                	push   $0x0
  80208d:	6a 00                	push   $0x0
  80208f:	6a 00                	push   $0x0
  802091:	6a 25                	push   $0x25
  802093:	e8 81 fb ff ff       	call   801c19 <syscall>
  802098:	83 c4 18             	add    $0x18,%esp
}
  80209b:	c9                   	leave  
  80209c:	c3                   	ret    

0080209d <sys_bypassPageFault>:
void sys_bypassPageFault(uint8 instrLength)
{
  80209d:	55                   	push   %ebp
  80209e:	89 e5                	mov    %esp,%ebp
  8020a0:	83 ec 04             	sub    $0x4,%esp
  8020a3:	8b 45 08             	mov    0x8(%ebp),%eax
  8020a6:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  8020a9:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  8020ad:	6a 00                	push   $0x0
  8020af:	6a 00                	push   $0x0
  8020b1:	6a 00                	push   $0x0
  8020b3:	6a 00                	push   $0x0
  8020b5:	50                   	push   %eax
  8020b6:	6a 26                	push   $0x26
  8020b8:	e8 5c fb ff ff       	call   801c19 <syscall>
  8020bd:	83 c4 18             	add    $0x18,%esp
	return ;
  8020c0:	90                   	nop
}
  8020c1:	c9                   	leave  
  8020c2:	c3                   	ret    

008020c3 <rsttst>:
void rsttst()
{
  8020c3:	55                   	push   %ebp
  8020c4:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  8020c6:	6a 00                	push   $0x0
  8020c8:	6a 00                	push   $0x0
  8020ca:	6a 00                	push   $0x0
  8020cc:	6a 00                	push   $0x0
  8020ce:	6a 00                	push   $0x0
  8020d0:	6a 28                	push   $0x28
  8020d2:	e8 42 fb ff ff       	call   801c19 <syscall>
  8020d7:	83 c4 18             	add    $0x18,%esp
	return ;
  8020da:	90                   	nop
}
  8020db:	c9                   	leave  
  8020dc:	c3                   	ret    

008020dd <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  8020dd:	55                   	push   %ebp
  8020de:	89 e5                	mov    %esp,%ebp
  8020e0:	83 ec 04             	sub    $0x4,%esp
  8020e3:	8b 45 14             	mov    0x14(%ebp),%eax
  8020e6:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  8020e9:	8b 55 18             	mov    0x18(%ebp),%edx
  8020ec:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  8020f0:	52                   	push   %edx
  8020f1:	50                   	push   %eax
  8020f2:	ff 75 10             	pushl  0x10(%ebp)
  8020f5:	ff 75 0c             	pushl  0xc(%ebp)
  8020f8:	ff 75 08             	pushl  0x8(%ebp)
  8020fb:	6a 27                	push   $0x27
  8020fd:	e8 17 fb ff ff       	call   801c19 <syscall>
  802102:	83 c4 18             	add    $0x18,%esp
	return ;
  802105:	90                   	nop
}
  802106:	c9                   	leave  
  802107:	c3                   	ret    

00802108 <chktst>:
void chktst(uint32 n)
{
  802108:	55                   	push   %ebp
  802109:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  80210b:	6a 00                	push   $0x0
  80210d:	6a 00                	push   $0x0
  80210f:	6a 00                	push   $0x0
  802111:	6a 00                	push   $0x0
  802113:	ff 75 08             	pushl  0x8(%ebp)
  802116:	6a 29                	push   $0x29
  802118:	e8 fc fa ff ff       	call   801c19 <syscall>
  80211d:	83 c4 18             	add    $0x18,%esp
	return ;
  802120:	90                   	nop
}
  802121:	c9                   	leave  
  802122:	c3                   	ret    

00802123 <inctst>:

void inctst()
{
  802123:	55                   	push   %ebp
  802124:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  802126:	6a 00                	push   $0x0
  802128:	6a 00                	push   $0x0
  80212a:	6a 00                	push   $0x0
  80212c:	6a 00                	push   $0x0
  80212e:	6a 00                	push   $0x0
  802130:	6a 2a                	push   $0x2a
  802132:	e8 e2 fa ff ff       	call   801c19 <syscall>
  802137:	83 c4 18             	add    $0x18,%esp
	return ;
  80213a:	90                   	nop
}
  80213b:	c9                   	leave  
  80213c:	c3                   	ret    

0080213d <gettst>:
uint32 gettst()
{
  80213d:	55                   	push   %ebp
  80213e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  802140:	6a 00                	push   $0x0
  802142:	6a 00                	push   $0x0
  802144:	6a 00                	push   $0x0
  802146:	6a 00                	push   $0x0
  802148:	6a 00                	push   $0x0
  80214a:	6a 2b                	push   $0x2b
  80214c:	e8 c8 fa ff ff       	call   801c19 <syscall>
  802151:	83 c4 18             	add    $0x18,%esp
}
  802154:	c9                   	leave  
  802155:	c3                   	ret    

00802156 <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  802156:	55                   	push   %ebp
  802157:	89 e5                	mov    %esp,%ebp
  802159:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  80215c:	6a 00                	push   $0x0
  80215e:	6a 00                	push   $0x0
  802160:	6a 00                	push   $0x0
  802162:	6a 00                	push   $0x0
  802164:	6a 00                	push   $0x0
  802166:	6a 2c                	push   $0x2c
  802168:	e8 ac fa ff ff       	call   801c19 <syscall>
  80216d:	83 c4 18             	add    $0x18,%esp
  802170:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  802173:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  802177:	75 07                	jne    802180 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  802179:	b8 01 00 00 00       	mov    $0x1,%eax
  80217e:	eb 05                	jmp    802185 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  802180:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802185:	c9                   	leave  
  802186:	c3                   	ret    

00802187 <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  802187:	55                   	push   %ebp
  802188:	89 e5                	mov    %esp,%ebp
  80218a:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  80218d:	6a 00                	push   $0x0
  80218f:	6a 00                	push   $0x0
  802191:	6a 00                	push   $0x0
  802193:	6a 00                	push   $0x0
  802195:	6a 00                	push   $0x0
  802197:	6a 2c                	push   $0x2c
  802199:	e8 7b fa ff ff       	call   801c19 <syscall>
  80219e:	83 c4 18             	add    $0x18,%esp
  8021a1:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  8021a4:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  8021a8:	75 07                	jne    8021b1 <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  8021aa:	b8 01 00 00 00       	mov    $0x1,%eax
  8021af:	eb 05                	jmp    8021b6 <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  8021b1:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8021b6:	c9                   	leave  
  8021b7:	c3                   	ret    

008021b8 <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  8021b8:	55                   	push   %ebp
  8021b9:	89 e5                	mov    %esp,%ebp
  8021bb:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8021be:	6a 00                	push   $0x0
  8021c0:	6a 00                	push   $0x0
  8021c2:	6a 00                	push   $0x0
  8021c4:	6a 00                	push   $0x0
  8021c6:	6a 00                	push   $0x0
  8021c8:	6a 2c                	push   $0x2c
  8021ca:	e8 4a fa ff ff       	call   801c19 <syscall>
  8021cf:	83 c4 18             	add    $0x18,%esp
  8021d2:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  8021d5:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  8021d9:	75 07                	jne    8021e2 <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  8021db:	b8 01 00 00 00       	mov    $0x1,%eax
  8021e0:	eb 05                	jmp    8021e7 <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  8021e2:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8021e7:	c9                   	leave  
  8021e8:	c3                   	ret    

008021e9 <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  8021e9:	55                   	push   %ebp
  8021ea:	89 e5                	mov    %esp,%ebp
  8021ec:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8021ef:	6a 00                	push   $0x0
  8021f1:	6a 00                	push   $0x0
  8021f3:	6a 00                	push   $0x0
  8021f5:	6a 00                	push   $0x0
  8021f7:	6a 00                	push   $0x0
  8021f9:	6a 2c                	push   $0x2c
  8021fb:	e8 19 fa ff ff       	call   801c19 <syscall>
  802200:	83 c4 18             	add    $0x18,%esp
  802203:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  802206:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  80220a:	75 07                	jne    802213 <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  80220c:	b8 01 00 00 00       	mov    $0x1,%eax
  802211:	eb 05                	jmp    802218 <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  802213:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802218:	c9                   	leave  
  802219:	c3                   	ret    

0080221a <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  80221a:	55                   	push   %ebp
  80221b:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  80221d:	6a 00                	push   $0x0
  80221f:	6a 00                	push   $0x0
  802221:	6a 00                	push   $0x0
  802223:	6a 00                	push   $0x0
  802225:	ff 75 08             	pushl  0x8(%ebp)
  802228:	6a 2d                	push   $0x2d
  80222a:	e8 ea f9 ff ff       	call   801c19 <syscall>
  80222f:	83 c4 18             	add    $0x18,%esp
	return ;
  802232:	90                   	nop
}
  802233:	c9                   	leave  
  802234:	c3                   	ret    

00802235 <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  802235:	55                   	push   %ebp
  802236:	89 e5                	mov    %esp,%ebp
  802238:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  802239:	8b 5d 14             	mov    0x14(%ebp),%ebx
  80223c:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80223f:	8b 55 0c             	mov    0xc(%ebp),%edx
  802242:	8b 45 08             	mov    0x8(%ebp),%eax
  802245:	6a 00                	push   $0x0
  802247:	53                   	push   %ebx
  802248:	51                   	push   %ecx
  802249:	52                   	push   %edx
  80224a:	50                   	push   %eax
  80224b:	6a 2e                	push   $0x2e
  80224d:	e8 c7 f9 ff ff       	call   801c19 <syscall>
  802252:	83 c4 18             	add    $0x18,%esp
}
  802255:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  802258:	c9                   	leave  
  802259:	c3                   	ret    

0080225a <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  80225a:	55                   	push   %ebp
  80225b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  80225d:	8b 55 0c             	mov    0xc(%ebp),%edx
  802260:	8b 45 08             	mov    0x8(%ebp),%eax
  802263:	6a 00                	push   $0x0
  802265:	6a 00                	push   $0x0
  802267:	6a 00                	push   $0x0
  802269:	52                   	push   %edx
  80226a:	50                   	push   %eax
  80226b:	6a 2f                	push   $0x2f
  80226d:	e8 a7 f9 ff ff       	call   801c19 <syscall>
  802272:	83 c4 18             	add    $0x18,%esp
}
  802275:	c9                   	leave  
  802276:	c3                   	ret    

00802277 <print_mem_block_lists>:
//===========================
// PRINT MEM BLOCK LISTS:
//===========================

void print_mem_block_lists()
{
  802277:	55                   	push   %ebp
  802278:	89 e5                	mov    %esp,%ebp
  80227a:	83 ec 18             	sub    $0x18,%esp
	cprintf("\n=========================================\n");
  80227d:	83 ec 0c             	sub    $0xc,%esp
  802280:	68 a0 3f 80 00       	push   $0x803fa0
  802285:	e8 dd e6 ff ff       	call   800967 <cprintf>
  80228a:	83 c4 10             	add    $0x10,%esp
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
  80228d:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nFreeMemBlocksList:\n");
  802294:	83 ec 0c             	sub    $0xc,%esp
  802297:	68 cc 3f 80 00       	push   $0x803fcc
  80229c:	e8 c6 e6 ff ff       	call   800967 <cprintf>
  8022a1:	83 c4 10             	add    $0x10,%esp
	uint8 sorted = 1 ;
  8022a4:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &FreeMemBlocksList)
  8022a8:	a1 38 51 80 00       	mov    0x805138,%eax
  8022ad:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8022b0:	eb 56                	jmp    802308 <print_mem_block_lists+0x91>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  8022b2:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8022b6:	74 1c                	je     8022d4 <print_mem_block_lists+0x5d>
  8022b8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022bb:	8b 50 08             	mov    0x8(%eax),%edx
  8022be:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8022c1:	8b 48 08             	mov    0x8(%eax),%ecx
  8022c4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8022c7:	8b 40 0c             	mov    0xc(%eax),%eax
  8022ca:	01 c8                	add    %ecx,%eax
  8022cc:	39 c2                	cmp    %eax,%edx
  8022ce:	73 04                	jae    8022d4 <print_mem_block_lists+0x5d>
			sorted = 0 ;
  8022d0:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  8022d4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022d7:	8b 50 08             	mov    0x8(%eax),%edx
  8022da:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022dd:	8b 40 0c             	mov    0xc(%eax),%eax
  8022e0:	01 c2                	add    %eax,%edx
  8022e2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022e5:	8b 40 08             	mov    0x8(%eax),%eax
  8022e8:	83 ec 04             	sub    $0x4,%esp
  8022eb:	52                   	push   %edx
  8022ec:	50                   	push   %eax
  8022ed:	68 e1 3f 80 00       	push   $0x803fe1
  8022f2:	e8 70 e6 ff ff       	call   800967 <cprintf>
  8022f7:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  8022fa:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022fd:	89 45 f0             	mov    %eax,-0x10(%ebp)
	cprintf("\n=========================================\n");
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
	cprintf("\nFreeMemBlocksList:\n");
	uint8 sorted = 1 ;
	LIST_FOREACH(blk, &FreeMemBlocksList)
  802300:	a1 40 51 80 00       	mov    0x805140,%eax
  802305:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802308:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80230c:	74 07                	je     802315 <print_mem_block_lists+0x9e>
  80230e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802311:	8b 00                	mov    (%eax),%eax
  802313:	eb 05                	jmp    80231a <print_mem_block_lists+0xa3>
  802315:	b8 00 00 00 00       	mov    $0x0,%eax
  80231a:	a3 40 51 80 00       	mov    %eax,0x805140
  80231f:	a1 40 51 80 00       	mov    0x805140,%eax
  802324:	85 c0                	test   %eax,%eax
  802326:	75 8a                	jne    8022b2 <print_mem_block_lists+0x3b>
  802328:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80232c:	75 84                	jne    8022b2 <print_mem_block_lists+0x3b>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;
  80232e:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  802332:	75 10                	jne    802344 <print_mem_block_lists+0xcd>
  802334:	83 ec 0c             	sub    $0xc,%esp
  802337:	68 f0 3f 80 00       	push   $0x803ff0
  80233c:	e8 26 e6 ff ff       	call   800967 <cprintf>
  802341:	83 c4 10             	add    $0x10,%esp

	lastBlk = NULL ;
  802344:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nAllocMemBlocksList:\n");
  80234b:	83 ec 0c             	sub    $0xc,%esp
  80234e:	68 14 40 80 00       	push   $0x804014
  802353:	e8 0f e6 ff ff       	call   800967 <cprintf>
  802358:	83 c4 10             	add    $0x10,%esp
	sorted = 1 ;
  80235b:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &AllocMemBlocksList)
  80235f:	a1 40 50 80 00       	mov    0x805040,%eax
  802364:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802367:	eb 56                	jmp    8023bf <print_mem_block_lists+0x148>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  802369:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80236d:	74 1c                	je     80238b <print_mem_block_lists+0x114>
  80236f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802372:	8b 50 08             	mov    0x8(%eax),%edx
  802375:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802378:	8b 48 08             	mov    0x8(%eax),%ecx
  80237b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80237e:	8b 40 0c             	mov    0xc(%eax),%eax
  802381:	01 c8                	add    %ecx,%eax
  802383:	39 c2                	cmp    %eax,%edx
  802385:	73 04                	jae    80238b <print_mem_block_lists+0x114>
			sorted = 0 ;
  802387:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  80238b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80238e:	8b 50 08             	mov    0x8(%eax),%edx
  802391:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802394:	8b 40 0c             	mov    0xc(%eax),%eax
  802397:	01 c2                	add    %eax,%edx
  802399:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80239c:	8b 40 08             	mov    0x8(%eax),%eax
  80239f:	83 ec 04             	sub    $0x4,%esp
  8023a2:	52                   	push   %edx
  8023a3:	50                   	push   %eax
  8023a4:	68 e1 3f 80 00       	push   $0x803fe1
  8023a9:	e8 b9 e5 ff ff       	call   800967 <cprintf>
  8023ae:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  8023b1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023b4:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;

	lastBlk = NULL ;
	cprintf("\nAllocMemBlocksList:\n");
	sorted = 1 ;
	LIST_FOREACH(blk, &AllocMemBlocksList)
  8023b7:	a1 48 50 80 00       	mov    0x805048,%eax
  8023bc:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8023bf:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8023c3:	74 07                	je     8023cc <print_mem_block_lists+0x155>
  8023c5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023c8:	8b 00                	mov    (%eax),%eax
  8023ca:	eb 05                	jmp    8023d1 <print_mem_block_lists+0x15a>
  8023cc:	b8 00 00 00 00       	mov    $0x0,%eax
  8023d1:	a3 48 50 80 00       	mov    %eax,0x805048
  8023d6:	a1 48 50 80 00       	mov    0x805048,%eax
  8023db:	85 c0                	test   %eax,%eax
  8023dd:	75 8a                	jne    802369 <print_mem_block_lists+0xf2>
  8023df:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8023e3:	75 84                	jne    802369 <print_mem_block_lists+0xf2>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nAllocMemBlocksList is NOT SORTED!!\n") ;
  8023e5:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  8023e9:	75 10                	jne    8023fb <print_mem_block_lists+0x184>
  8023eb:	83 ec 0c             	sub    $0xc,%esp
  8023ee:	68 2c 40 80 00       	push   $0x80402c
  8023f3:	e8 6f e5 ff ff       	call   800967 <cprintf>
  8023f8:	83 c4 10             	add    $0x10,%esp
	cprintf("\n=========================================\n");
  8023fb:	83 ec 0c             	sub    $0xc,%esp
  8023fe:	68 a0 3f 80 00       	push   $0x803fa0
  802403:	e8 5f e5 ff ff       	call   800967 <cprintf>
  802408:	83 c4 10             	add    $0x10,%esp

}
  80240b:	90                   	nop
  80240c:	c9                   	leave  
  80240d:	c3                   	ret    

0080240e <initialize_MemBlocksList>:

//===============================
// [1] INITIALIZE AVAILABLE LIST:
//===============================
void initialize_MemBlocksList(uint32 numOfBlocks)
{
  80240e:	55                   	push   %ebp
  80240f:	89 e5                	mov    %esp,%ebp
  802411:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] initialize_MemBlocksList
	// Write your code here, remove the panic and write your code
	//panic("initialize_MemBlocksList() is not implemented yet...!!");
	uint32 n = numOfBlocks;
  802414:	8b 45 08             	mov    0x8(%ebp),%eax
  802417:	89 45 f0             	mov    %eax,-0x10(%ebp)

	LIST_INIT(&AvailableMemBlocksList);
  80241a:	c7 05 48 51 80 00 00 	movl   $0x0,0x805148
  802421:	00 00 00 
  802424:	c7 05 4c 51 80 00 00 	movl   $0x0,0x80514c
  80242b:	00 00 00 
  80242e:	c7 05 54 51 80 00 00 	movl   $0x0,0x805154
  802435:	00 00 00 
	for(int i = 0; i<n;i++)
  802438:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  80243f:	e9 9e 00 00 00       	jmp    8024e2 <initialize_MemBlocksList+0xd4>
	{
		LIST_INSERT_HEAD(&AvailableMemBlocksList, &(MemBlockNodes[i]));
  802444:	a1 50 50 80 00       	mov    0x805050,%eax
  802449:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80244c:	c1 e2 04             	shl    $0x4,%edx
  80244f:	01 d0                	add    %edx,%eax
  802451:	85 c0                	test   %eax,%eax
  802453:	75 14                	jne    802469 <initialize_MemBlocksList+0x5b>
  802455:	83 ec 04             	sub    $0x4,%esp
  802458:	68 54 40 80 00       	push   $0x804054
  80245d:	6a 47                	push   $0x47
  80245f:	68 77 40 80 00       	push   $0x804077
  802464:	e8 4a e2 ff ff       	call   8006b3 <_panic>
  802469:	a1 50 50 80 00       	mov    0x805050,%eax
  80246e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802471:	c1 e2 04             	shl    $0x4,%edx
  802474:	01 d0                	add    %edx,%eax
  802476:	8b 15 48 51 80 00    	mov    0x805148,%edx
  80247c:	89 10                	mov    %edx,(%eax)
  80247e:	8b 00                	mov    (%eax),%eax
  802480:	85 c0                	test   %eax,%eax
  802482:	74 18                	je     80249c <initialize_MemBlocksList+0x8e>
  802484:	a1 48 51 80 00       	mov    0x805148,%eax
  802489:	8b 15 50 50 80 00    	mov    0x805050,%edx
  80248f:	8b 4d f4             	mov    -0xc(%ebp),%ecx
  802492:	c1 e1 04             	shl    $0x4,%ecx
  802495:	01 ca                	add    %ecx,%edx
  802497:	89 50 04             	mov    %edx,0x4(%eax)
  80249a:	eb 12                	jmp    8024ae <initialize_MemBlocksList+0xa0>
  80249c:	a1 50 50 80 00       	mov    0x805050,%eax
  8024a1:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8024a4:	c1 e2 04             	shl    $0x4,%edx
  8024a7:	01 d0                	add    %edx,%eax
  8024a9:	a3 4c 51 80 00       	mov    %eax,0x80514c
  8024ae:	a1 50 50 80 00       	mov    0x805050,%eax
  8024b3:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8024b6:	c1 e2 04             	shl    $0x4,%edx
  8024b9:	01 d0                	add    %edx,%eax
  8024bb:	a3 48 51 80 00       	mov    %eax,0x805148
  8024c0:	a1 50 50 80 00       	mov    0x805050,%eax
  8024c5:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8024c8:	c1 e2 04             	shl    $0x4,%edx
  8024cb:	01 d0                	add    %edx,%eax
  8024cd:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8024d4:	a1 54 51 80 00       	mov    0x805154,%eax
  8024d9:	40                   	inc    %eax
  8024da:	a3 54 51 80 00       	mov    %eax,0x805154
	// Write your code here, remove the panic and write your code
	//panic("initialize_MemBlocksList() is not implemented yet...!!");
	uint32 n = numOfBlocks;

	LIST_INIT(&AvailableMemBlocksList);
	for(int i = 0; i<n;i++)
  8024df:	ff 45 f4             	incl   -0xc(%ebp)
  8024e2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024e5:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8024e8:	0f 82 56 ff ff ff    	jb     802444 <initialize_MemBlocksList+0x36>
	{
		LIST_INSERT_HEAD(&AvailableMemBlocksList, &(MemBlockNodes[i]));
	}
}
  8024ee:	90                   	nop
  8024ef:	c9                   	leave  
  8024f0:	c3                   	ret    

008024f1 <find_block>:

//===============================
// [2] FIND BLOCK:
//===============================
struct MemBlock *find_block(struct MemBlock_List *blockList, uint32 va)
{
  8024f1:	55                   	push   %ebp
  8024f2:	89 e5                	mov    %esp,%ebp
  8024f4:	83 ec 10             	sub    $0x10,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] find_block
	// Write your code here, remove the panic and write your code
	//panic("find_block() is not implemented yet...!!");
	uint32 virAddress = va;
  8024f7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8024fa:	89 45 f4             	mov    %eax,-0xc(%ebp)
	struct MemBlock* blk;
	int found = 0;
  8024fd:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	LIST_FOREACH(blk, &(AllocMemBlocksList))
  802504:	a1 40 50 80 00       	mov    0x805040,%eax
  802509:	89 45 fc             	mov    %eax,-0x4(%ebp)
  80250c:	eb 23                	jmp    802531 <find_block+0x40>
	{
		if(blk->sva == virAddress)
  80250e:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802511:	8b 40 08             	mov    0x8(%eax),%eax
  802514:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  802517:	75 09                	jne    802522 <find_block+0x31>
		{
			found = 1;
  802519:	c7 45 f8 01 00 00 00 	movl   $0x1,-0x8(%ebp)
			break;
  802520:	eb 35                	jmp    802557 <find_block+0x66>
		}
		else
		{
			found = 0;
  802522:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	//panic("find_block() is not implemented yet...!!");
	uint32 virAddress = va;
	struct MemBlock* blk;
	int found = 0;

	LIST_FOREACH(blk, &(AllocMemBlocksList))
  802529:	a1 48 50 80 00       	mov    0x805048,%eax
  80252e:	89 45 fc             	mov    %eax,-0x4(%ebp)
  802531:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  802535:	74 07                	je     80253e <find_block+0x4d>
  802537:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80253a:	8b 00                	mov    (%eax),%eax
  80253c:	eb 05                	jmp    802543 <find_block+0x52>
  80253e:	b8 00 00 00 00       	mov    $0x0,%eax
  802543:	a3 48 50 80 00       	mov    %eax,0x805048
  802548:	a1 48 50 80 00       	mov    0x805048,%eax
  80254d:	85 c0                	test   %eax,%eax
  80254f:	75 bd                	jne    80250e <find_block+0x1d>
  802551:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  802555:	75 b7                	jne    80250e <find_block+0x1d>
		{
			found = 0;
			continue;
		}
	}
	if(found == 1)
  802557:	83 7d f8 01          	cmpl   $0x1,-0x8(%ebp)
  80255b:	75 05                	jne    802562 <find_block+0x71>
	{
		return blk;
  80255d:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802560:	eb 05                	jmp    802567 <find_block+0x76>
	}
	else
	{
		return NULL;
  802562:	b8 00 00 00 00       	mov    $0x0,%eax
	}
}
  802567:	c9                   	leave  
  802568:	c3                   	ret    

00802569 <insert_sorted_allocList>:

//=========================================
// [3] INSERT BLOCK IN ALLOC LIST [SORTED]:
//=========================================
void insert_sorted_allocList(struct MemBlock *blockToInsert)
{
  802569:	55                   	push   %ebp
  80256a:	89 e5                	mov    %esp,%ebp
  80256c:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] insert_sorted_allocList
	// Write your code here, remove the panic and write your code
	//panic("insert_sorted_allocList() is not implemented yet...!!");
	struct MemBlock* blk;
	struct MemBlock* newblk = blockToInsert;
  80256f:	8b 45 08             	mov    0x8(%ebp),%eax
  802572:	89 45 f0             	mov    %eax,-0x10(%ebp)

	if((LIST_EMPTY(&AllocMemBlocksList)) || (newblk->sva < LIST_FIRST(&AllocMemBlocksList)->sva))
  802575:	a1 40 50 80 00       	mov    0x805040,%eax
  80257a:	85 c0                	test   %eax,%eax
  80257c:	74 12                	je     802590 <insert_sorted_allocList+0x27>
  80257e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802581:	8b 50 08             	mov    0x8(%eax),%edx
  802584:	a1 40 50 80 00       	mov    0x805040,%eax
  802589:	8b 40 08             	mov    0x8(%eax),%eax
  80258c:	39 c2                	cmp    %eax,%edx
  80258e:	73 65                	jae    8025f5 <insert_sorted_allocList+0x8c>
	{
		LIST_INSERT_HEAD(&(AllocMemBlocksList), newblk);
  802590:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802594:	75 14                	jne    8025aa <insert_sorted_allocList+0x41>
  802596:	83 ec 04             	sub    $0x4,%esp
  802599:	68 54 40 80 00       	push   $0x804054
  80259e:	6a 7b                	push   $0x7b
  8025a0:	68 77 40 80 00       	push   $0x804077
  8025a5:	e8 09 e1 ff ff       	call   8006b3 <_panic>
  8025aa:	8b 15 40 50 80 00    	mov    0x805040,%edx
  8025b0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8025b3:	89 10                	mov    %edx,(%eax)
  8025b5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8025b8:	8b 00                	mov    (%eax),%eax
  8025ba:	85 c0                	test   %eax,%eax
  8025bc:	74 0d                	je     8025cb <insert_sorted_allocList+0x62>
  8025be:	a1 40 50 80 00       	mov    0x805040,%eax
  8025c3:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8025c6:	89 50 04             	mov    %edx,0x4(%eax)
  8025c9:	eb 08                	jmp    8025d3 <insert_sorted_allocList+0x6a>
  8025cb:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8025ce:	a3 44 50 80 00       	mov    %eax,0x805044
  8025d3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8025d6:	a3 40 50 80 00       	mov    %eax,0x805040
  8025db:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8025de:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8025e5:	a1 4c 50 80 00       	mov    0x80504c,%eax
  8025ea:	40                   	inc    %eax
  8025eb:	a3 4c 50 80 00       	mov    %eax,0x80504c
  8025f0:	e9 5f 01 00 00       	jmp    802754 <insert_sorted_allocList+0x1eb>
	}
	else if(newblk->sva > LIST_LAST(&AllocMemBlocksList)->sva)
  8025f5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8025f8:	8b 50 08             	mov    0x8(%eax),%edx
  8025fb:	a1 44 50 80 00       	mov    0x805044,%eax
  802600:	8b 40 08             	mov    0x8(%eax),%eax
  802603:	39 c2                	cmp    %eax,%edx
  802605:	76 65                	jbe    80266c <insert_sorted_allocList+0x103>
	{
		LIST_INSERT_TAIL(&AllocMemBlocksList, newblk);
  802607:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80260b:	75 14                	jne    802621 <insert_sorted_allocList+0xb8>
  80260d:	83 ec 04             	sub    $0x4,%esp
  802610:	68 90 40 80 00       	push   $0x804090
  802615:	6a 7f                	push   $0x7f
  802617:	68 77 40 80 00       	push   $0x804077
  80261c:	e8 92 e0 ff ff       	call   8006b3 <_panic>
  802621:	8b 15 44 50 80 00    	mov    0x805044,%edx
  802627:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80262a:	89 50 04             	mov    %edx,0x4(%eax)
  80262d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802630:	8b 40 04             	mov    0x4(%eax),%eax
  802633:	85 c0                	test   %eax,%eax
  802635:	74 0c                	je     802643 <insert_sorted_allocList+0xda>
  802637:	a1 44 50 80 00       	mov    0x805044,%eax
  80263c:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80263f:	89 10                	mov    %edx,(%eax)
  802641:	eb 08                	jmp    80264b <insert_sorted_allocList+0xe2>
  802643:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802646:	a3 40 50 80 00       	mov    %eax,0x805040
  80264b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80264e:	a3 44 50 80 00       	mov    %eax,0x805044
  802653:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802656:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80265c:	a1 4c 50 80 00       	mov    0x80504c,%eax
  802661:	40                   	inc    %eax
  802662:	a3 4c 50 80 00       	mov    %eax,0x80504c
				LIST_INSERT_AFTER(&AllocMemBlocksList, blk, newblk);
				break;
			}
		}
	}
}
  802667:	e9 e8 00 00 00       	jmp    802754 <insert_sorted_allocList+0x1eb>
	{
		LIST_INSERT_TAIL(&AllocMemBlocksList, newblk);
	}
	else
	{
		LIST_FOREACH(blk, &AllocMemBlocksList)
  80266c:	a1 40 50 80 00       	mov    0x805040,%eax
  802671:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802674:	e9 ab 00 00 00       	jmp    802724 <insert_sorted_allocList+0x1bb>
		{
			if(blk->prev_next_info.le_next != NULL && newblk->sva > blk->sva  && newblk->sva < blk->prev_next_info.le_next->sva)
  802679:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80267c:	8b 00                	mov    (%eax),%eax
  80267e:	85 c0                	test   %eax,%eax
  802680:	0f 84 96 00 00 00    	je     80271c <insert_sorted_allocList+0x1b3>
  802686:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802689:	8b 50 08             	mov    0x8(%eax),%edx
  80268c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80268f:	8b 40 08             	mov    0x8(%eax),%eax
  802692:	39 c2                	cmp    %eax,%edx
  802694:	0f 86 82 00 00 00    	jbe    80271c <insert_sorted_allocList+0x1b3>
  80269a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80269d:	8b 50 08             	mov    0x8(%eax),%edx
  8026a0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026a3:	8b 00                	mov    (%eax),%eax
  8026a5:	8b 40 08             	mov    0x8(%eax),%eax
  8026a8:	39 c2                	cmp    %eax,%edx
  8026aa:	73 70                	jae    80271c <insert_sorted_allocList+0x1b3>
			{
				LIST_INSERT_AFTER(&AllocMemBlocksList, blk, newblk);
  8026ac:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8026b0:	74 06                	je     8026b8 <insert_sorted_allocList+0x14f>
  8026b2:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8026b6:	75 17                	jne    8026cf <insert_sorted_allocList+0x166>
  8026b8:	83 ec 04             	sub    $0x4,%esp
  8026bb:	68 b4 40 80 00       	push   $0x8040b4
  8026c0:	68 87 00 00 00       	push   $0x87
  8026c5:	68 77 40 80 00       	push   $0x804077
  8026ca:	e8 e4 df ff ff       	call   8006b3 <_panic>
  8026cf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026d2:	8b 10                	mov    (%eax),%edx
  8026d4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8026d7:	89 10                	mov    %edx,(%eax)
  8026d9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8026dc:	8b 00                	mov    (%eax),%eax
  8026de:	85 c0                	test   %eax,%eax
  8026e0:	74 0b                	je     8026ed <insert_sorted_allocList+0x184>
  8026e2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026e5:	8b 00                	mov    (%eax),%eax
  8026e7:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8026ea:	89 50 04             	mov    %edx,0x4(%eax)
  8026ed:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026f0:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8026f3:	89 10                	mov    %edx,(%eax)
  8026f5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8026f8:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8026fb:	89 50 04             	mov    %edx,0x4(%eax)
  8026fe:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802701:	8b 00                	mov    (%eax),%eax
  802703:	85 c0                	test   %eax,%eax
  802705:	75 08                	jne    80270f <insert_sorted_allocList+0x1a6>
  802707:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80270a:	a3 44 50 80 00       	mov    %eax,0x805044
  80270f:	a1 4c 50 80 00       	mov    0x80504c,%eax
  802714:	40                   	inc    %eax
  802715:	a3 4c 50 80 00       	mov    %eax,0x80504c
				break;
  80271a:	eb 38                	jmp    802754 <insert_sorted_allocList+0x1eb>
	{
		LIST_INSERT_TAIL(&AllocMemBlocksList, newblk);
	}
	else
	{
		LIST_FOREACH(blk, &AllocMemBlocksList)
  80271c:	a1 48 50 80 00       	mov    0x805048,%eax
  802721:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802724:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802728:	74 07                	je     802731 <insert_sorted_allocList+0x1c8>
  80272a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80272d:	8b 00                	mov    (%eax),%eax
  80272f:	eb 05                	jmp    802736 <insert_sorted_allocList+0x1cd>
  802731:	b8 00 00 00 00       	mov    $0x0,%eax
  802736:	a3 48 50 80 00       	mov    %eax,0x805048
  80273b:	a1 48 50 80 00       	mov    0x805048,%eax
  802740:	85 c0                	test   %eax,%eax
  802742:	0f 85 31 ff ff ff    	jne    802679 <insert_sorted_allocList+0x110>
  802748:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80274c:	0f 85 27 ff ff ff    	jne    802679 <insert_sorted_allocList+0x110>
				LIST_INSERT_AFTER(&AllocMemBlocksList, blk, newblk);
				break;
			}
		}
	}
}
  802752:	eb 00                	jmp    802754 <insert_sorted_allocList+0x1eb>
  802754:	90                   	nop
  802755:	c9                   	leave  
  802756:	c3                   	ret    

00802757 <alloc_block_FF>:

//=========================================
// [4] ALLOCATE BLOCK BY FIRST FIT:
//=========================================
struct MemBlock *alloc_block_FF(uint32 size)
{
  802757:	55                   	push   %ebp
  802758:	89 e5                	mov    %esp,%ebp
  80275a:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_FF
	// Write your code here, remove the panic and write your code
	//panic("alloc_block_FF() is not implemented yet...!!");
	uint32 versize = size;
  80275d:	8b 45 08             	mov    0x8(%ebp),%eax
  802760:	89 45 f0             	mov    %eax,-0x10(%ebp)
	struct MemBlock* blk;
	struct MemBlock* newblk = LIST_FIRST(&AvailableMemBlocksList);
  802763:	a1 48 51 80 00       	mov    0x805148,%eax
  802768:	89 45 ec             	mov    %eax,-0x14(%ebp)

	LIST_FOREACH(blk,&FreeMemBlocksList)
  80276b:	a1 38 51 80 00       	mov    0x805138,%eax
  802770:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802773:	e9 77 01 00 00       	jmp    8028ef <alloc_block_FF+0x198>
	{
		if(blk->size == versize)
  802778:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80277b:	8b 40 0c             	mov    0xc(%eax),%eax
  80277e:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  802781:	0f 85 8a 00 00 00    	jne    802811 <alloc_block_FF+0xba>
		{
			LIST_REMOVE(&FreeMemBlocksList,blk);
  802787:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80278b:	75 17                	jne    8027a4 <alloc_block_FF+0x4d>
  80278d:	83 ec 04             	sub    $0x4,%esp
  802790:	68 e8 40 80 00       	push   $0x8040e8
  802795:	68 9e 00 00 00       	push   $0x9e
  80279a:	68 77 40 80 00       	push   $0x804077
  80279f:	e8 0f df ff ff       	call   8006b3 <_panic>
  8027a4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027a7:	8b 00                	mov    (%eax),%eax
  8027a9:	85 c0                	test   %eax,%eax
  8027ab:	74 10                	je     8027bd <alloc_block_FF+0x66>
  8027ad:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027b0:	8b 00                	mov    (%eax),%eax
  8027b2:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8027b5:	8b 52 04             	mov    0x4(%edx),%edx
  8027b8:	89 50 04             	mov    %edx,0x4(%eax)
  8027bb:	eb 0b                	jmp    8027c8 <alloc_block_FF+0x71>
  8027bd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027c0:	8b 40 04             	mov    0x4(%eax),%eax
  8027c3:	a3 3c 51 80 00       	mov    %eax,0x80513c
  8027c8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027cb:	8b 40 04             	mov    0x4(%eax),%eax
  8027ce:	85 c0                	test   %eax,%eax
  8027d0:	74 0f                	je     8027e1 <alloc_block_FF+0x8a>
  8027d2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027d5:	8b 40 04             	mov    0x4(%eax),%eax
  8027d8:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8027db:	8b 12                	mov    (%edx),%edx
  8027dd:	89 10                	mov    %edx,(%eax)
  8027df:	eb 0a                	jmp    8027eb <alloc_block_FF+0x94>
  8027e1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027e4:	8b 00                	mov    (%eax),%eax
  8027e6:	a3 38 51 80 00       	mov    %eax,0x805138
  8027eb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027ee:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8027f4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027f7:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8027fe:	a1 44 51 80 00       	mov    0x805144,%eax
  802803:	48                   	dec    %eax
  802804:	a3 44 51 80 00       	mov    %eax,0x805144
			return blk;
  802809:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80280c:	e9 11 01 00 00       	jmp    802922 <alloc_block_FF+0x1cb>
		}
		else if(blk->size > versize)
  802811:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802814:	8b 40 0c             	mov    0xc(%eax),%eax
  802817:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  80281a:	0f 86 c7 00 00 00    	jbe    8028e7 <alloc_block_FF+0x190>
		{
			LIST_REMOVE(&AvailableMemBlocksList,newblk);
  802820:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802824:	75 17                	jne    80283d <alloc_block_FF+0xe6>
  802826:	83 ec 04             	sub    $0x4,%esp
  802829:	68 e8 40 80 00       	push   $0x8040e8
  80282e:	68 a3 00 00 00       	push   $0xa3
  802833:	68 77 40 80 00       	push   $0x804077
  802838:	e8 76 de ff ff       	call   8006b3 <_panic>
  80283d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802840:	8b 00                	mov    (%eax),%eax
  802842:	85 c0                	test   %eax,%eax
  802844:	74 10                	je     802856 <alloc_block_FF+0xff>
  802846:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802849:	8b 00                	mov    (%eax),%eax
  80284b:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80284e:	8b 52 04             	mov    0x4(%edx),%edx
  802851:	89 50 04             	mov    %edx,0x4(%eax)
  802854:	eb 0b                	jmp    802861 <alloc_block_FF+0x10a>
  802856:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802859:	8b 40 04             	mov    0x4(%eax),%eax
  80285c:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802861:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802864:	8b 40 04             	mov    0x4(%eax),%eax
  802867:	85 c0                	test   %eax,%eax
  802869:	74 0f                	je     80287a <alloc_block_FF+0x123>
  80286b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80286e:	8b 40 04             	mov    0x4(%eax),%eax
  802871:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802874:	8b 12                	mov    (%edx),%edx
  802876:	89 10                	mov    %edx,(%eax)
  802878:	eb 0a                	jmp    802884 <alloc_block_FF+0x12d>
  80287a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80287d:	8b 00                	mov    (%eax),%eax
  80287f:	a3 48 51 80 00       	mov    %eax,0x805148
  802884:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802887:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80288d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802890:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802897:	a1 54 51 80 00       	mov    0x805154,%eax
  80289c:	48                   	dec    %eax
  80289d:	a3 54 51 80 00       	mov    %eax,0x805154
			newblk->size = versize;
  8028a2:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8028a5:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8028a8:	89 50 0c             	mov    %edx,0xc(%eax)
			blk->size = blk->size-versize;
  8028ab:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028ae:	8b 40 0c             	mov    0xc(%eax),%eax
  8028b1:	2b 45 f0             	sub    -0x10(%ebp),%eax
  8028b4:	89 c2                	mov    %eax,%edx
  8028b6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028b9:	89 50 0c             	mov    %edx,0xc(%eax)
			uint32 newveradd = blk->sva;
  8028bc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028bf:	8b 40 08             	mov    0x8(%eax),%eax
  8028c2:	89 45 e8             	mov    %eax,-0x18(%ebp)
			blk->sva+=newblk->size;
  8028c5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028c8:	8b 50 08             	mov    0x8(%eax),%edx
  8028cb:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8028ce:	8b 40 0c             	mov    0xc(%eax),%eax
  8028d1:	01 c2                	add    %eax,%edx
  8028d3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028d6:	89 50 08             	mov    %edx,0x8(%eax)
			newblk->sva = newveradd;
  8028d9:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8028dc:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8028df:	89 50 08             	mov    %edx,0x8(%eax)
			return newblk;
  8028e2:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8028e5:	eb 3b                	jmp    802922 <alloc_block_FF+0x1cb>
	//panic("alloc_block_FF() is not implemented yet...!!");
	uint32 versize = size;
	struct MemBlock* blk;
	struct MemBlock* newblk = LIST_FIRST(&AvailableMemBlocksList);

	LIST_FOREACH(blk,&FreeMemBlocksList)
  8028e7:	a1 40 51 80 00       	mov    0x805140,%eax
  8028ec:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8028ef:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8028f3:	74 07                	je     8028fc <alloc_block_FF+0x1a5>
  8028f5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028f8:	8b 00                	mov    (%eax),%eax
  8028fa:	eb 05                	jmp    802901 <alloc_block_FF+0x1aa>
  8028fc:	b8 00 00 00 00       	mov    $0x0,%eax
  802901:	a3 40 51 80 00       	mov    %eax,0x805140
  802906:	a1 40 51 80 00       	mov    0x805140,%eax
  80290b:	85 c0                	test   %eax,%eax
  80290d:	0f 85 65 fe ff ff    	jne    802778 <alloc_block_FF+0x21>
  802913:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802917:	0f 85 5b fe ff ff    	jne    802778 <alloc_block_FF+0x21>
			blk->sva+=newblk->size;
			newblk->sva = newveradd;
			return newblk;
		}
	}
	return NULL;
  80291d:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802922:	c9                   	leave  
  802923:	c3                   	ret    

00802924 <alloc_block_BF>:

//=========================================
// [5] ALLOCATE BLOCK BY BEST FIT:
//=========================================
struct MemBlock *alloc_block_BF(uint32 size)
{
  802924:	55                   	push   %ebp
  802925:	89 e5                	mov    %esp,%ebp
  802927:	83 ec 28             	sub    $0x28,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_BF
	// Write your code here, remove the panic and write your code
	//panic("alloc_block_BF() is not implemented yet...!!");
	uint32 versize=size;
  80292a:	8b 45 08             	mov    0x8(%ebp),%eax
  80292d:	89 45 e8             	mov    %eax,-0x18(%ebp)
	struct MemBlock* blk;
	struct MemBlock* newblk=LIST_FIRST(&AvailableMemBlocksList);
  802930:	a1 48 51 80 00       	mov    0x805148,%eax
  802935:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	uint32 newveradd;
	uint32 newsize;
	int size_free = LIST_SIZE(&FreeMemBlocksList);
  802938:	a1 44 51 80 00       	mov    0x805144,%eax
  80293d:	89 45 e0             	mov    %eax,-0x20(%ebp)

	LIST_FOREACH(blk, &FreeMemBlocksList)
  802940:	a1 38 51 80 00       	mov    0x805138,%eax
  802945:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802948:	e9 a1 00 00 00       	jmp    8029ee <alloc_block_BF+0xca>
	{
		if(blk->size == versize)
  80294d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802950:	8b 40 0c             	mov    0xc(%eax),%eax
  802953:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  802956:	0f 85 8a 00 00 00    	jne    8029e6 <alloc_block_BF+0xc2>
		{
			LIST_REMOVE(&FreeMemBlocksList, blk);
  80295c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802960:	75 17                	jne    802979 <alloc_block_BF+0x55>
  802962:	83 ec 04             	sub    $0x4,%esp
  802965:	68 e8 40 80 00       	push   $0x8040e8
  80296a:	68 c2 00 00 00       	push   $0xc2
  80296f:	68 77 40 80 00       	push   $0x804077
  802974:	e8 3a dd ff ff       	call   8006b3 <_panic>
  802979:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80297c:	8b 00                	mov    (%eax),%eax
  80297e:	85 c0                	test   %eax,%eax
  802980:	74 10                	je     802992 <alloc_block_BF+0x6e>
  802982:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802985:	8b 00                	mov    (%eax),%eax
  802987:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80298a:	8b 52 04             	mov    0x4(%edx),%edx
  80298d:	89 50 04             	mov    %edx,0x4(%eax)
  802990:	eb 0b                	jmp    80299d <alloc_block_BF+0x79>
  802992:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802995:	8b 40 04             	mov    0x4(%eax),%eax
  802998:	a3 3c 51 80 00       	mov    %eax,0x80513c
  80299d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029a0:	8b 40 04             	mov    0x4(%eax),%eax
  8029a3:	85 c0                	test   %eax,%eax
  8029a5:	74 0f                	je     8029b6 <alloc_block_BF+0x92>
  8029a7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029aa:	8b 40 04             	mov    0x4(%eax),%eax
  8029ad:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8029b0:	8b 12                	mov    (%edx),%edx
  8029b2:	89 10                	mov    %edx,(%eax)
  8029b4:	eb 0a                	jmp    8029c0 <alloc_block_BF+0x9c>
  8029b6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029b9:	8b 00                	mov    (%eax),%eax
  8029bb:	a3 38 51 80 00       	mov    %eax,0x805138
  8029c0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029c3:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8029c9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029cc:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8029d3:	a1 44 51 80 00       	mov    0x805144,%eax
  8029d8:	48                   	dec    %eax
  8029d9:	a3 44 51 80 00       	mov    %eax,0x805144
			return blk;
  8029de:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029e1:	e9 11 02 00 00       	jmp    802bf7 <alloc_block_BF+0x2d3>
	struct MemBlock* newblk=LIST_FIRST(&AvailableMemBlocksList);
	uint32 newveradd;
	uint32 newsize;
	int size_free = LIST_SIZE(&FreeMemBlocksList);

	LIST_FOREACH(blk, &FreeMemBlocksList)
  8029e6:	a1 40 51 80 00       	mov    0x805140,%eax
  8029eb:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8029ee:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8029f2:	74 07                	je     8029fb <alloc_block_BF+0xd7>
  8029f4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029f7:	8b 00                	mov    (%eax),%eax
  8029f9:	eb 05                	jmp    802a00 <alloc_block_BF+0xdc>
  8029fb:	b8 00 00 00 00       	mov    $0x0,%eax
  802a00:	a3 40 51 80 00       	mov    %eax,0x805140
  802a05:	a1 40 51 80 00       	mov    0x805140,%eax
  802a0a:	85 c0                	test   %eax,%eax
  802a0c:	0f 85 3b ff ff ff    	jne    80294d <alloc_block_BF+0x29>
  802a12:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802a16:	0f 85 31 ff ff ff    	jne    80294d <alloc_block_BF+0x29>
		{
			LIST_REMOVE(&FreeMemBlocksList, blk);
			return blk;
		}
	}
	LIST_FOREACH(blk, &FreeMemBlocksList)
  802a1c:	a1 38 51 80 00       	mov    0x805138,%eax
  802a21:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802a24:	eb 27                	jmp    802a4d <alloc_block_BF+0x129>
	{
		if(blk->size > versize)
  802a26:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a29:	8b 40 0c             	mov    0xc(%eax),%eax
  802a2c:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  802a2f:	76 14                	jbe    802a45 <alloc_block_BF+0x121>
		{
			newsize = blk->size;
  802a31:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a34:	8b 40 0c             	mov    0xc(%eax),%eax
  802a37:	89 45 ec             	mov    %eax,-0x14(%ebp)
			newveradd = blk->sva;
  802a3a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a3d:	8b 40 08             	mov    0x8(%eax),%eax
  802a40:	89 45 f0             	mov    %eax,-0x10(%ebp)
			break;
  802a43:	eb 2e                	jmp    802a73 <alloc_block_BF+0x14f>
		{
			LIST_REMOVE(&FreeMemBlocksList, blk);
			return blk;
		}
	}
	LIST_FOREACH(blk, &FreeMemBlocksList)
  802a45:	a1 40 51 80 00       	mov    0x805140,%eax
  802a4a:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802a4d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802a51:	74 07                	je     802a5a <alloc_block_BF+0x136>
  802a53:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a56:	8b 00                	mov    (%eax),%eax
  802a58:	eb 05                	jmp    802a5f <alloc_block_BF+0x13b>
  802a5a:	b8 00 00 00 00       	mov    $0x0,%eax
  802a5f:	a3 40 51 80 00       	mov    %eax,0x805140
  802a64:	a1 40 51 80 00       	mov    0x805140,%eax
  802a69:	85 c0                	test   %eax,%eax
  802a6b:	75 b9                	jne    802a26 <alloc_block_BF+0x102>
  802a6d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802a71:	75 b3                	jne    802a26 <alloc_block_BF+0x102>
			newsize = blk->size;
			newveradd = blk->sva;
			break;
		}
	}
	LIST_FOREACH(blk, &FreeMemBlocksList)
  802a73:	a1 38 51 80 00       	mov    0x805138,%eax
  802a78:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802a7b:	eb 30                	jmp    802aad <alloc_block_BF+0x189>
	{
		if(newsize > blk->size && blk->size > versize)
  802a7d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a80:	8b 40 0c             	mov    0xc(%eax),%eax
  802a83:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  802a86:	73 1d                	jae    802aa5 <alloc_block_BF+0x181>
  802a88:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a8b:	8b 40 0c             	mov    0xc(%eax),%eax
  802a8e:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  802a91:	76 12                	jbe    802aa5 <alloc_block_BF+0x181>
		{
	       newsize = blk->size;
  802a93:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a96:	8b 40 0c             	mov    0xc(%eax),%eax
  802a99:	89 45 ec             	mov    %eax,-0x14(%ebp)
		   newveradd = blk->sva;
  802a9c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a9f:	8b 40 08             	mov    0x8(%eax),%eax
  802aa2:	89 45 f0             	mov    %eax,-0x10(%ebp)
			newsize = blk->size;
			newveradd = blk->sva;
			break;
		}
	}
	LIST_FOREACH(blk, &FreeMemBlocksList)
  802aa5:	a1 40 51 80 00       	mov    0x805140,%eax
  802aaa:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802aad:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802ab1:	74 07                	je     802aba <alloc_block_BF+0x196>
  802ab3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ab6:	8b 00                	mov    (%eax),%eax
  802ab8:	eb 05                	jmp    802abf <alloc_block_BF+0x19b>
  802aba:	b8 00 00 00 00       	mov    $0x0,%eax
  802abf:	a3 40 51 80 00       	mov    %eax,0x805140
  802ac4:	a1 40 51 80 00       	mov    0x805140,%eax
  802ac9:	85 c0                	test   %eax,%eax
  802acb:	75 b0                	jne    802a7d <alloc_block_BF+0x159>
  802acd:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802ad1:	75 aa                	jne    802a7d <alloc_block_BF+0x159>
		{
	       newsize = blk->size;
		   newveradd = blk->sva;
		}
	}
	LIST_FOREACH(blk, &FreeMemBlocksList)
  802ad3:	a1 38 51 80 00       	mov    0x805138,%eax
  802ad8:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802adb:	e9 e4 00 00 00       	jmp    802bc4 <alloc_block_BF+0x2a0>
	{
		if(blk->size == newsize && blk->sva == newveradd)
  802ae0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ae3:	8b 40 0c             	mov    0xc(%eax),%eax
  802ae6:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  802ae9:	0f 85 cd 00 00 00    	jne    802bbc <alloc_block_BF+0x298>
  802aef:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802af2:	8b 40 08             	mov    0x8(%eax),%eax
  802af5:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  802af8:	0f 85 be 00 00 00    	jne    802bbc <alloc_block_BF+0x298>
		{
			LIST_REMOVE(&AvailableMemBlocksList, newblk);
  802afe:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  802b02:	75 17                	jne    802b1b <alloc_block_BF+0x1f7>
  802b04:	83 ec 04             	sub    $0x4,%esp
  802b07:	68 e8 40 80 00       	push   $0x8040e8
  802b0c:	68 db 00 00 00       	push   $0xdb
  802b11:	68 77 40 80 00       	push   $0x804077
  802b16:	e8 98 db ff ff       	call   8006b3 <_panic>
  802b1b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802b1e:	8b 00                	mov    (%eax),%eax
  802b20:	85 c0                	test   %eax,%eax
  802b22:	74 10                	je     802b34 <alloc_block_BF+0x210>
  802b24:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802b27:	8b 00                	mov    (%eax),%eax
  802b29:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802b2c:	8b 52 04             	mov    0x4(%edx),%edx
  802b2f:	89 50 04             	mov    %edx,0x4(%eax)
  802b32:	eb 0b                	jmp    802b3f <alloc_block_BF+0x21b>
  802b34:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802b37:	8b 40 04             	mov    0x4(%eax),%eax
  802b3a:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802b3f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802b42:	8b 40 04             	mov    0x4(%eax),%eax
  802b45:	85 c0                	test   %eax,%eax
  802b47:	74 0f                	je     802b58 <alloc_block_BF+0x234>
  802b49:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802b4c:	8b 40 04             	mov    0x4(%eax),%eax
  802b4f:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802b52:	8b 12                	mov    (%edx),%edx
  802b54:	89 10                	mov    %edx,(%eax)
  802b56:	eb 0a                	jmp    802b62 <alloc_block_BF+0x23e>
  802b58:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802b5b:	8b 00                	mov    (%eax),%eax
  802b5d:	a3 48 51 80 00       	mov    %eax,0x805148
  802b62:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802b65:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802b6b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802b6e:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802b75:	a1 54 51 80 00       	mov    0x805154,%eax
  802b7a:	48                   	dec    %eax
  802b7b:	a3 54 51 80 00       	mov    %eax,0x805154
			newblk->size = versize;
  802b80:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802b83:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802b86:	89 50 0c             	mov    %edx,0xc(%eax)
			newblk->sva = newveradd;
  802b89:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802b8c:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802b8f:	89 50 08             	mov    %edx,0x8(%eax)
			blk->size = blk->size - versize;
  802b92:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b95:	8b 40 0c             	mov    0xc(%eax),%eax
  802b98:	2b 45 e8             	sub    -0x18(%ebp),%eax
  802b9b:	89 c2                	mov    %eax,%edx
  802b9d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ba0:	89 50 0c             	mov    %edx,0xc(%eax)
			blk->sva+= newblk->size;
  802ba3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ba6:	8b 50 08             	mov    0x8(%eax),%edx
  802ba9:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802bac:	8b 40 0c             	mov    0xc(%eax),%eax
  802baf:	01 c2                	add    %eax,%edx
  802bb1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bb4:	89 50 08             	mov    %edx,0x8(%eax)
			return newblk;
  802bb7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802bba:	eb 3b                	jmp    802bf7 <alloc_block_BF+0x2d3>
		{
	       newsize = blk->size;
		   newveradd = blk->sva;
		}
	}
	LIST_FOREACH(blk, &FreeMemBlocksList)
  802bbc:	a1 40 51 80 00       	mov    0x805140,%eax
  802bc1:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802bc4:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802bc8:	74 07                	je     802bd1 <alloc_block_BF+0x2ad>
  802bca:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bcd:	8b 00                	mov    (%eax),%eax
  802bcf:	eb 05                	jmp    802bd6 <alloc_block_BF+0x2b2>
  802bd1:	b8 00 00 00 00       	mov    $0x0,%eax
  802bd6:	a3 40 51 80 00       	mov    %eax,0x805140
  802bdb:	a1 40 51 80 00       	mov    0x805140,%eax
  802be0:	85 c0                	test   %eax,%eax
  802be2:	0f 85 f8 fe ff ff    	jne    802ae0 <alloc_block_BF+0x1bc>
  802be8:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802bec:	0f 85 ee fe ff ff    	jne    802ae0 <alloc_block_BF+0x1bc>
			blk->size = blk->size - versize;
			blk->sva+= newblk->size;
			return newblk;
		}
	}
	return NULL;
  802bf2:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802bf7:	c9                   	leave  
  802bf8:	c3                   	ret    

00802bf9 <alloc_block_NF>:
//=========================================
// [7] ALLOCATE BLOCK BY NEXT FIT:
//=========================================
struct MemBlock *last_allocate;
struct MemBlock *alloc_block_NF(uint32 size)
{
  802bf9:	55                   	push   %ebp
  802bfa:	89 e5                	mov    %esp,%ebp
  802bfc:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1 - BONUS] [DYNAMIC ALLOCATOR] alloc_block_NF
	// Write your code here, remove the panic and write your code
	//panic("alloc_block_NF() is not implemented yet...!!");
	uint32 versize = size;
  802bff:	8b 45 08             	mov    0x8(%ebp),%eax
  802c02:	89 45 f0             	mov    %eax,-0x10(%ebp)
	struct MemBlock* blk;
	struct MemBlock* newblk = LIST_FIRST(&AvailableMemBlocksList);
  802c05:	a1 48 51 80 00       	mov    0x805148,%eax
  802c0a:	89 45 ec             	mov    %eax,-0x14(%ebp)

	LIST_FOREACH(blk,&FreeMemBlocksList)
  802c0d:	a1 38 51 80 00       	mov    0x805138,%eax
  802c12:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802c15:	e9 77 01 00 00       	jmp    802d91 <alloc_block_NF+0x198>
	{
		if(blk->size == versize)
  802c1a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c1d:	8b 40 0c             	mov    0xc(%eax),%eax
  802c20:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  802c23:	0f 85 8a 00 00 00    	jne    802cb3 <alloc_block_NF+0xba>
		{
			LIST_REMOVE(&FreeMemBlocksList,blk);
  802c29:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802c2d:	75 17                	jne    802c46 <alloc_block_NF+0x4d>
  802c2f:	83 ec 04             	sub    $0x4,%esp
  802c32:	68 e8 40 80 00       	push   $0x8040e8
  802c37:	68 f7 00 00 00       	push   $0xf7
  802c3c:	68 77 40 80 00       	push   $0x804077
  802c41:	e8 6d da ff ff       	call   8006b3 <_panic>
  802c46:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c49:	8b 00                	mov    (%eax),%eax
  802c4b:	85 c0                	test   %eax,%eax
  802c4d:	74 10                	je     802c5f <alloc_block_NF+0x66>
  802c4f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c52:	8b 00                	mov    (%eax),%eax
  802c54:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802c57:	8b 52 04             	mov    0x4(%edx),%edx
  802c5a:	89 50 04             	mov    %edx,0x4(%eax)
  802c5d:	eb 0b                	jmp    802c6a <alloc_block_NF+0x71>
  802c5f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c62:	8b 40 04             	mov    0x4(%eax),%eax
  802c65:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802c6a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c6d:	8b 40 04             	mov    0x4(%eax),%eax
  802c70:	85 c0                	test   %eax,%eax
  802c72:	74 0f                	je     802c83 <alloc_block_NF+0x8a>
  802c74:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c77:	8b 40 04             	mov    0x4(%eax),%eax
  802c7a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802c7d:	8b 12                	mov    (%edx),%edx
  802c7f:	89 10                	mov    %edx,(%eax)
  802c81:	eb 0a                	jmp    802c8d <alloc_block_NF+0x94>
  802c83:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c86:	8b 00                	mov    (%eax),%eax
  802c88:	a3 38 51 80 00       	mov    %eax,0x805138
  802c8d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c90:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802c96:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c99:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802ca0:	a1 44 51 80 00       	mov    0x805144,%eax
  802ca5:	48                   	dec    %eax
  802ca6:	a3 44 51 80 00       	mov    %eax,0x805144
			return blk;
  802cab:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cae:	e9 11 01 00 00       	jmp    802dc4 <alloc_block_NF+0x1cb>
		}
		else if(blk->size > versize)
  802cb3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cb6:	8b 40 0c             	mov    0xc(%eax),%eax
  802cb9:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  802cbc:	0f 86 c7 00 00 00    	jbe    802d89 <alloc_block_NF+0x190>
		{
			LIST_REMOVE(&AvailableMemBlocksList,newblk);
  802cc2:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802cc6:	75 17                	jne    802cdf <alloc_block_NF+0xe6>
  802cc8:	83 ec 04             	sub    $0x4,%esp
  802ccb:	68 e8 40 80 00       	push   $0x8040e8
  802cd0:	68 fc 00 00 00       	push   $0xfc
  802cd5:	68 77 40 80 00       	push   $0x804077
  802cda:	e8 d4 d9 ff ff       	call   8006b3 <_panic>
  802cdf:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802ce2:	8b 00                	mov    (%eax),%eax
  802ce4:	85 c0                	test   %eax,%eax
  802ce6:	74 10                	je     802cf8 <alloc_block_NF+0xff>
  802ce8:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802ceb:	8b 00                	mov    (%eax),%eax
  802ced:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802cf0:	8b 52 04             	mov    0x4(%edx),%edx
  802cf3:	89 50 04             	mov    %edx,0x4(%eax)
  802cf6:	eb 0b                	jmp    802d03 <alloc_block_NF+0x10a>
  802cf8:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802cfb:	8b 40 04             	mov    0x4(%eax),%eax
  802cfe:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802d03:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802d06:	8b 40 04             	mov    0x4(%eax),%eax
  802d09:	85 c0                	test   %eax,%eax
  802d0b:	74 0f                	je     802d1c <alloc_block_NF+0x123>
  802d0d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802d10:	8b 40 04             	mov    0x4(%eax),%eax
  802d13:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802d16:	8b 12                	mov    (%edx),%edx
  802d18:	89 10                	mov    %edx,(%eax)
  802d1a:	eb 0a                	jmp    802d26 <alloc_block_NF+0x12d>
  802d1c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802d1f:	8b 00                	mov    (%eax),%eax
  802d21:	a3 48 51 80 00       	mov    %eax,0x805148
  802d26:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802d29:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802d2f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802d32:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802d39:	a1 54 51 80 00       	mov    0x805154,%eax
  802d3e:	48                   	dec    %eax
  802d3f:	a3 54 51 80 00       	mov    %eax,0x805154
			newblk->size = versize;
  802d44:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802d47:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802d4a:	89 50 0c             	mov    %edx,0xc(%eax)
			blk->size = blk->size-versize;
  802d4d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d50:	8b 40 0c             	mov    0xc(%eax),%eax
  802d53:	2b 45 f0             	sub    -0x10(%ebp),%eax
  802d56:	89 c2                	mov    %eax,%edx
  802d58:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d5b:	89 50 0c             	mov    %edx,0xc(%eax)
			uint32 newveradd = blk->sva;
  802d5e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d61:	8b 40 08             	mov    0x8(%eax),%eax
  802d64:	89 45 e8             	mov    %eax,-0x18(%ebp)
			blk->sva+=newblk->size;
  802d67:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d6a:	8b 50 08             	mov    0x8(%eax),%edx
  802d6d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802d70:	8b 40 0c             	mov    0xc(%eax),%eax
  802d73:	01 c2                	add    %eax,%edx
  802d75:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d78:	89 50 08             	mov    %edx,0x8(%eax)
			newblk->sva = newveradd;
  802d7b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802d7e:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802d81:	89 50 08             	mov    %edx,0x8(%eax)
			return newblk;
  802d84:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802d87:	eb 3b                	jmp    802dc4 <alloc_block_NF+0x1cb>
	//panic("alloc_block_NF() is not implemented yet...!!");
	uint32 versize = size;
	struct MemBlock* blk;
	struct MemBlock* newblk = LIST_FIRST(&AvailableMemBlocksList);

	LIST_FOREACH(blk,&FreeMemBlocksList)
  802d89:	a1 40 51 80 00       	mov    0x805140,%eax
  802d8e:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802d91:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802d95:	74 07                	je     802d9e <alloc_block_NF+0x1a5>
  802d97:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d9a:	8b 00                	mov    (%eax),%eax
  802d9c:	eb 05                	jmp    802da3 <alloc_block_NF+0x1aa>
  802d9e:	b8 00 00 00 00       	mov    $0x0,%eax
  802da3:	a3 40 51 80 00       	mov    %eax,0x805140
  802da8:	a1 40 51 80 00       	mov    0x805140,%eax
  802dad:	85 c0                	test   %eax,%eax
  802daf:	0f 85 65 fe ff ff    	jne    802c1a <alloc_block_NF+0x21>
  802db5:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802db9:	0f 85 5b fe ff ff    	jne    802c1a <alloc_block_NF+0x21>
			blk->sva+=newblk->size;
			newblk->sva = newveradd;
			return newblk;
		}
	}
	return NULL;
  802dbf:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802dc4:	c9                   	leave  
  802dc5:	c3                   	ret    

00802dc6 <addToAvailMemBlocksList>:

//===================================================
// [8] INSERT BLOCK (SORTED WITH MERGE) IN FREE LIST:
//===================================================
void addToAvailMemBlocksList(struct MemBlock *blockToInsert)
{
  802dc6:	55                   	push   %ebp
  802dc7:	89 e5                	mov    %esp,%ebp
  802dc9:	83 ec 08             	sub    $0x8,%esp
	blockToInsert->sva = 0;
  802dcc:	8b 45 08             	mov    0x8(%ebp),%eax
  802dcf:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
	blockToInsert->size = 0;
  802dd6:	8b 45 08             	mov    0x8(%ebp),%eax
  802dd9:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
	//add to avail
	LIST_INSERT_TAIL(&AvailableMemBlocksList, blockToInsert);
  802de0:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802de4:	75 17                	jne    802dfd <addToAvailMemBlocksList+0x37>
  802de6:	83 ec 04             	sub    $0x4,%esp
  802de9:	68 90 40 80 00       	push   $0x804090
  802dee:	68 10 01 00 00       	push   $0x110
  802df3:	68 77 40 80 00       	push   $0x804077
  802df8:	e8 b6 d8 ff ff       	call   8006b3 <_panic>
  802dfd:	8b 15 4c 51 80 00    	mov    0x80514c,%edx
  802e03:	8b 45 08             	mov    0x8(%ebp),%eax
  802e06:	89 50 04             	mov    %edx,0x4(%eax)
  802e09:	8b 45 08             	mov    0x8(%ebp),%eax
  802e0c:	8b 40 04             	mov    0x4(%eax),%eax
  802e0f:	85 c0                	test   %eax,%eax
  802e11:	74 0c                	je     802e1f <addToAvailMemBlocksList+0x59>
  802e13:	a1 4c 51 80 00       	mov    0x80514c,%eax
  802e18:	8b 55 08             	mov    0x8(%ebp),%edx
  802e1b:	89 10                	mov    %edx,(%eax)
  802e1d:	eb 08                	jmp    802e27 <addToAvailMemBlocksList+0x61>
  802e1f:	8b 45 08             	mov    0x8(%ebp),%eax
  802e22:	a3 48 51 80 00       	mov    %eax,0x805148
  802e27:	8b 45 08             	mov    0x8(%ebp),%eax
  802e2a:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802e2f:	8b 45 08             	mov    0x8(%ebp),%eax
  802e32:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802e38:	a1 54 51 80 00       	mov    0x805154,%eax
  802e3d:	40                   	inc    %eax
  802e3e:	a3 54 51 80 00       	mov    %eax,0x805154
}
  802e43:	90                   	nop
  802e44:	c9                   	leave  
  802e45:	c3                   	ret    

00802e46 <insert_sorted_with_merge_freeList>:
void insert_sorted_with_merge_freeList(struct MemBlock *blockToInsert)
{
  802e46:	55                   	push   %ebp
  802e47:	89 e5                	mov    %esp,%ebp
  802e49:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] insert_sorted_with_merge_freeList
	// Write your code here, remove the panic and write your code

	struct MemBlock* last = LIST_LAST(&FreeMemBlocksList);
  802e4c:	a1 3c 51 80 00       	mov    0x80513c,%eax
  802e51:	89 45 f0             	mov    %eax,-0x10(%ebp)
	//check if list empty
	if (LIST_SIZE(&(FreeMemBlocksList)) == 0)
  802e54:	a1 44 51 80 00       	mov    0x805144,%eax
  802e59:	85 c0                	test   %eax,%eax
  802e5b:	75 68                	jne    802ec5 <insert_sorted_with_merge_freeList+0x7f>
		LIST_INSERT_HEAD(&FreeMemBlocksList, blockToInsert);
  802e5d:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802e61:	75 17                	jne    802e7a <insert_sorted_with_merge_freeList+0x34>
  802e63:	83 ec 04             	sub    $0x4,%esp
  802e66:	68 54 40 80 00       	push   $0x804054
  802e6b:	68 1a 01 00 00       	push   $0x11a
  802e70:	68 77 40 80 00       	push   $0x804077
  802e75:	e8 39 d8 ff ff       	call   8006b3 <_panic>
  802e7a:	8b 15 38 51 80 00    	mov    0x805138,%edx
  802e80:	8b 45 08             	mov    0x8(%ebp),%eax
  802e83:	89 10                	mov    %edx,(%eax)
  802e85:	8b 45 08             	mov    0x8(%ebp),%eax
  802e88:	8b 00                	mov    (%eax),%eax
  802e8a:	85 c0                	test   %eax,%eax
  802e8c:	74 0d                	je     802e9b <insert_sorted_with_merge_freeList+0x55>
  802e8e:	a1 38 51 80 00       	mov    0x805138,%eax
  802e93:	8b 55 08             	mov    0x8(%ebp),%edx
  802e96:	89 50 04             	mov    %edx,0x4(%eax)
  802e99:	eb 08                	jmp    802ea3 <insert_sorted_with_merge_freeList+0x5d>
  802e9b:	8b 45 08             	mov    0x8(%ebp),%eax
  802e9e:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802ea3:	8b 45 08             	mov    0x8(%ebp),%eax
  802ea6:	a3 38 51 80 00       	mov    %eax,0x805138
  802eab:	8b 45 08             	mov    0x8(%ebp),%eax
  802eae:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802eb5:	a1 44 51 80 00       	mov    0x805144,%eax
  802eba:	40                   	inc    %eax
  802ebb:	a3 44 51 80 00       	mov    %eax,0x805144
		}
	}

	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  802ec0:	e9 c5 03 00 00       	jmp    80328a <insert_sorted_with_merge_freeList+0x444>
	struct MemBlock* last = LIST_LAST(&FreeMemBlocksList);
	//check if list empty
	if (LIST_SIZE(&(FreeMemBlocksList)) == 0)
		LIST_INSERT_HEAD(&FreeMemBlocksList, blockToInsert);
	//check if it's position is at last
	else if (last->sva < blockToInsert->sva) {
  802ec5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802ec8:	8b 50 08             	mov    0x8(%eax),%edx
  802ecb:	8b 45 08             	mov    0x8(%ebp),%eax
  802ece:	8b 40 08             	mov    0x8(%eax),%eax
  802ed1:	39 c2                	cmp    %eax,%edx
  802ed3:	0f 83 b2 00 00 00    	jae    802f8b <insert_sorted_with_merge_freeList+0x145>

		//if i have to merge
		if (last->sva + last->size == blockToInsert->sva) {
  802ed9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802edc:	8b 50 08             	mov    0x8(%eax),%edx
  802edf:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802ee2:	8b 40 0c             	mov    0xc(%eax),%eax
  802ee5:	01 c2                	add    %eax,%edx
  802ee7:	8b 45 08             	mov    0x8(%ebp),%eax
  802eea:	8b 40 08             	mov    0x8(%eax),%eax
  802eed:	39 c2                	cmp    %eax,%edx
  802eef:	75 27                	jne    802f18 <insert_sorted_with_merge_freeList+0xd2>
			last->size = last->size + blockToInsert->size;
  802ef1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802ef4:	8b 50 0c             	mov    0xc(%eax),%edx
  802ef7:	8b 45 08             	mov    0x8(%ebp),%eax
  802efa:	8b 40 0c             	mov    0xc(%eax),%eax
  802efd:	01 c2                	add    %eax,%edx
  802eff:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802f02:	89 50 0c             	mov    %edx,0xc(%eax)
			addToAvailMemBlocksList(blockToInsert);
  802f05:	83 ec 0c             	sub    $0xc,%esp
  802f08:	ff 75 08             	pushl  0x8(%ebp)
  802f0b:	e8 b6 fe ff ff       	call   802dc6 <addToAvailMemBlocksList>
  802f10:	83 c4 10             	add    $0x10,%esp
		}
	}

	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  802f13:	e9 72 03 00 00       	jmp    80328a <insert_sorted_with_merge_freeList+0x444>
		if (last->sva + last->size == blockToInsert->sva) {
			last->size = last->size + blockToInsert->size;
			addToAvailMemBlocksList(blockToInsert);

		} else {
			LIST_INSERT_AFTER(&FreeMemBlocksList, last, blockToInsert);
  802f18:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802f1c:	74 06                	je     802f24 <insert_sorted_with_merge_freeList+0xde>
  802f1e:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802f22:	75 17                	jne    802f3b <insert_sorted_with_merge_freeList+0xf5>
  802f24:	83 ec 04             	sub    $0x4,%esp
  802f27:	68 b4 40 80 00       	push   $0x8040b4
  802f2c:	68 24 01 00 00       	push   $0x124
  802f31:	68 77 40 80 00       	push   $0x804077
  802f36:	e8 78 d7 ff ff       	call   8006b3 <_panic>
  802f3b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802f3e:	8b 10                	mov    (%eax),%edx
  802f40:	8b 45 08             	mov    0x8(%ebp),%eax
  802f43:	89 10                	mov    %edx,(%eax)
  802f45:	8b 45 08             	mov    0x8(%ebp),%eax
  802f48:	8b 00                	mov    (%eax),%eax
  802f4a:	85 c0                	test   %eax,%eax
  802f4c:	74 0b                	je     802f59 <insert_sorted_with_merge_freeList+0x113>
  802f4e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802f51:	8b 00                	mov    (%eax),%eax
  802f53:	8b 55 08             	mov    0x8(%ebp),%edx
  802f56:	89 50 04             	mov    %edx,0x4(%eax)
  802f59:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802f5c:	8b 55 08             	mov    0x8(%ebp),%edx
  802f5f:	89 10                	mov    %edx,(%eax)
  802f61:	8b 45 08             	mov    0x8(%ebp),%eax
  802f64:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802f67:	89 50 04             	mov    %edx,0x4(%eax)
  802f6a:	8b 45 08             	mov    0x8(%ebp),%eax
  802f6d:	8b 00                	mov    (%eax),%eax
  802f6f:	85 c0                	test   %eax,%eax
  802f71:	75 08                	jne    802f7b <insert_sorted_with_merge_freeList+0x135>
  802f73:	8b 45 08             	mov    0x8(%ebp),%eax
  802f76:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802f7b:	a1 44 51 80 00       	mov    0x805144,%eax
  802f80:	40                   	inc    %eax
  802f81:	a3 44 51 80 00       	mov    %eax,0x805144
		}
	}

	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  802f86:	e9 ff 02 00 00       	jmp    80328a <insert_sorted_with_merge_freeList+0x444>
		} else {
			LIST_INSERT_AFTER(&FreeMemBlocksList, last, blockToInsert);
		}
	} else {
		struct MemBlock *iterator;
		LIST_FOREACH(iterator, &(FreeMemBlocksList))
  802f8b:	a1 38 51 80 00       	mov    0x805138,%eax
  802f90:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802f93:	e9 c2 02 00 00       	jmp    80325a <insert_sorted_with_merge_freeList+0x414>
		{

			if (iterator->sva > blockToInsert->sva) {
  802f98:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f9b:	8b 50 08             	mov    0x8(%eax),%edx
  802f9e:	8b 45 08             	mov    0x8(%ebp),%eax
  802fa1:	8b 40 08             	mov    0x8(%eax),%eax
  802fa4:	39 c2                	cmp    %eax,%edx
  802fa6:	0f 86 a6 02 00 00    	jbe    803252 <insert_sorted_with_merge_freeList+0x40c>

				struct MemBlock* prev = LIST_PREV(iterator);
  802fac:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802faf:	8b 40 04             	mov    0x4(%eax),%eax
  802fb2:	89 45 ec             	mov    %eax,-0x14(%ebp)
				if (prev == NULL) {
  802fb5:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802fb9:	0f 85 ba 00 00 00    	jne    803079 <insert_sorted_with_merge_freeList+0x233>
					//check merge
					if (blockToInsert->size + blockToInsert->sva
  802fbf:	8b 45 08             	mov    0x8(%ebp),%eax
  802fc2:	8b 50 0c             	mov    0xc(%eax),%edx
  802fc5:	8b 45 08             	mov    0x8(%ebp),%eax
  802fc8:	8b 40 08             	mov    0x8(%eax),%eax
  802fcb:	01 c2                	add    %eax,%edx
							== iterator->sva) {
  802fcd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802fd0:	8b 40 08             	mov    0x8(%eax),%eax
			if (iterator->sva > blockToInsert->sva) {

				struct MemBlock* prev = LIST_PREV(iterator);
				if (prev == NULL) {
					//check merge
					if (blockToInsert->size + blockToInsert->sva
  802fd3:	39 c2                	cmp    %eax,%edx
  802fd5:	75 33                	jne    80300a <insert_sorted_with_merge_freeList+0x1c4>
							== iterator->sva) {
						iterator->sva = blockToInsert->sva;
  802fd7:	8b 45 08             	mov    0x8(%ebp),%eax
  802fda:	8b 50 08             	mov    0x8(%eax),%edx
  802fdd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802fe0:	89 50 08             	mov    %edx,0x8(%eax)
						iterator->size = iterator->size + blockToInsert->size;
  802fe3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802fe6:	8b 50 0c             	mov    0xc(%eax),%edx
  802fe9:	8b 45 08             	mov    0x8(%ebp),%eax
  802fec:	8b 40 0c             	mov    0xc(%eax),%eax
  802fef:	01 c2                	add    %eax,%edx
  802ff1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ff4:	89 50 0c             	mov    %edx,0xc(%eax)
						addToAvailMemBlocksList(blockToInsert);
  802ff7:	83 ec 0c             	sub    $0xc,%esp
  802ffa:	ff 75 08             	pushl  0x8(%ebp)
  802ffd:	e8 c4 fd ff ff       	call   802dc6 <addToAvailMemBlocksList>
  803002:	83 c4 10             	add    $0x10,%esp

					else {
						LIST_INSERT_BEFORE(&FreeMemBlocksList, iterator,
								blockToInsert);
					}
					break;
  803005:	e9 80 02 00 00       	jmp    80328a <insert_sorted_with_merge_freeList+0x444>
						addToAvailMemBlocksList(blockToInsert);

					}

					else {
						LIST_INSERT_BEFORE(&FreeMemBlocksList, iterator,
  80300a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80300e:	74 06                	je     803016 <insert_sorted_with_merge_freeList+0x1d0>
  803010:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803014:	75 17                	jne    80302d <insert_sorted_with_merge_freeList+0x1e7>
  803016:	83 ec 04             	sub    $0x4,%esp
  803019:	68 08 41 80 00       	push   $0x804108
  80301e:	68 3a 01 00 00       	push   $0x13a
  803023:	68 77 40 80 00       	push   $0x804077
  803028:	e8 86 d6 ff ff       	call   8006b3 <_panic>
  80302d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803030:	8b 50 04             	mov    0x4(%eax),%edx
  803033:	8b 45 08             	mov    0x8(%ebp),%eax
  803036:	89 50 04             	mov    %edx,0x4(%eax)
  803039:	8b 45 08             	mov    0x8(%ebp),%eax
  80303c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80303f:	89 10                	mov    %edx,(%eax)
  803041:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803044:	8b 40 04             	mov    0x4(%eax),%eax
  803047:	85 c0                	test   %eax,%eax
  803049:	74 0d                	je     803058 <insert_sorted_with_merge_freeList+0x212>
  80304b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80304e:	8b 40 04             	mov    0x4(%eax),%eax
  803051:	8b 55 08             	mov    0x8(%ebp),%edx
  803054:	89 10                	mov    %edx,(%eax)
  803056:	eb 08                	jmp    803060 <insert_sorted_with_merge_freeList+0x21a>
  803058:	8b 45 08             	mov    0x8(%ebp),%eax
  80305b:	a3 38 51 80 00       	mov    %eax,0x805138
  803060:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803063:	8b 55 08             	mov    0x8(%ebp),%edx
  803066:	89 50 04             	mov    %edx,0x4(%eax)
  803069:	a1 44 51 80 00       	mov    0x805144,%eax
  80306e:	40                   	inc    %eax
  80306f:	a3 44 51 80 00       	mov    %eax,0x805144
								blockToInsert);
					}
					break;
  803074:	e9 11 02 00 00       	jmp    80328a <insert_sorted_with_merge_freeList+0x444>
				} else {
					//prev and next merge
					if (prev->sva + prev->size + blockToInsert->size
  803079:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80307c:	8b 50 08             	mov    0x8(%eax),%edx
  80307f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803082:	8b 40 0c             	mov    0xc(%eax),%eax
  803085:	01 c2                	add    %eax,%edx
  803087:	8b 45 08             	mov    0x8(%ebp),%eax
  80308a:	8b 40 0c             	mov    0xc(%eax),%eax
  80308d:	01 c2                	add    %eax,%edx
							== iterator->sva) {
  80308f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803092:	8b 40 08             	mov    0x8(%eax),%eax
								blockToInsert);
					}
					break;
				} else {
					//prev and next merge
					if (prev->sva + prev->size + blockToInsert->size
  803095:	39 c2                	cmp    %eax,%edx
  803097:	0f 85 bf 00 00 00    	jne    80315c <insert_sorted_with_merge_freeList+0x316>
							== iterator->sva) {
						prev->size = prev->size + blockToInsert->size
  80309d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8030a0:	8b 50 0c             	mov    0xc(%eax),%edx
  8030a3:	8b 45 08             	mov    0x8(%ebp),%eax
  8030a6:	8b 40 0c             	mov    0xc(%eax),%eax
  8030a9:	01 c2                	add    %eax,%edx
								+ iterator->size;
  8030ab:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030ae:	8b 40 0c             	mov    0xc(%eax),%eax
  8030b1:	01 c2                	add    %eax,%edx
					break;
				} else {
					//prev and next merge
					if (prev->sva + prev->size + blockToInsert->size
							== iterator->sva) {
						prev->size = prev->size + blockToInsert->size
  8030b3:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8030b6:	89 50 0c             	mov    %edx,0xc(%eax)
								+ iterator->size;
						LIST_REMOVE(&FreeMemBlocksList, iterator);
  8030b9:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8030bd:	75 17                	jne    8030d6 <insert_sorted_with_merge_freeList+0x290>
  8030bf:	83 ec 04             	sub    $0x4,%esp
  8030c2:	68 e8 40 80 00       	push   $0x8040e8
  8030c7:	68 43 01 00 00       	push   $0x143
  8030cc:	68 77 40 80 00       	push   $0x804077
  8030d1:	e8 dd d5 ff ff       	call   8006b3 <_panic>
  8030d6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030d9:	8b 00                	mov    (%eax),%eax
  8030db:	85 c0                	test   %eax,%eax
  8030dd:	74 10                	je     8030ef <insert_sorted_with_merge_freeList+0x2a9>
  8030df:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030e2:	8b 00                	mov    (%eax),%eax
  8030e4:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8030e7:	8b 52 04             	mov    0x4(%edx),%edx
  8030ea:	89 50 04             	mov    %edx,0x4(%eax)
  8030ed:	eb 0b                	jmp    8030fa <insert_sorted_with_merge_freeList+0x2b4>
  8030ef:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030f2:	8b 40 04             	mov    0x4(%eax),%eax
  8030f5:	a3 3c 51 80 00       	mov    %eax,0x80513c
  8030fa:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030fd:	8b 40 04             	mov    0x4(%eax),%eax
  803100:	85 c0                	test   %eax,%eax
  803102:	74 0f                	je     803113 <insert_sorted_with_merge_freeList+0x2cd>
  803104:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803107:	8b 40 04             	mov    0x4(%eax),%eax
  80310a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80310d:	8b 12                	mov    (%edx),%edx
  80310f:	89 10                	mov    %edx,(%eax)
  803111:	eb 0a                	jmp    80311d <insert_sorted_with_merge_freeList+0x2d7>
  803113:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803116:	8b 00                	mov    (%eax),%eax
  803118:	a3 38 51 80 00       	mov    %eax,0x805138
  80311d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803120:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803126:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803129:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803130:	a1 44 51 80 00       	mov    0x805144,%eax
  803135:	48                   	dec    %eax
  803136:	a3 44 51 80 00       	mov    %eax,0x805144
						addToAvailMemBlocksList(blockToInsert);
  80313b:	83 ec 0c             	sub    $0xc,%esp
  80313e:	ff 75 08             	pushl  0x8(%ebp)
  803141:	e8 80 fc ff ff       	call   802dc6 <addToAvailMemBlocksList>
  803146:	83 c4 10             	add    $0x10,%esp
						addToAvailMemBlocksList(iterator);
  803149:	83 ec 0c             	sub    $0xc,%esp
  80314c:	ff 75 f4             	pushl  -0xc(%ebp)
  80314f:	e8 72 fc ff ff       	call   802dc6 <addToAvailMemBlocksList>
  803154:	83 c4 10             	add    $0x10,%esp
					//Insert
					else {
						LIST_INSERT_BEFORE(&FreeMemBlocksList, iterator,
								blockToInsert);
					}
					break;
  803157:	e9 2e 01 00 00       	jmp    80328a <insert_sorted_with_merge_freeList+0x444>
						LIST_REMOVE(&FreeMemBlocksList, iterator);
						addToAvailMemBlocksList(blockToInsert);
						addToAvailMemBlocksList(iterator);
					}
					//previous merge
					else if (prev->sva + prev->size == blockToInsert->sva) {
  80315c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80315f:	8b 50 08             	mov    0x8(%eax),%edx
  803162:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803165:	8b 40 0c             	mov    0xc(%eax),%eax
  803168:	01 c2                	add    %eax,%edx
  80316a:	8b 45 08             	mov    0x8(%ebp),%eax
  80316d:	8b 40 08             	mov    0x8(%eax),%eax
  803170:	39 c2                	cmp    %eax,%edx
  803172:	75 27                	jne    80319b <insert_sorted_with_merge_freeList+0x355>
						prev->size = prev->size + blockToInsert->size;
  803174:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803177:	8b 50 0c             	mov    0xc(%eax),%edx
  80317a:	8b 45 08             	mov    0x8(%ebp),%eax
  80317d:	8b 40 0c             	mov    0xc(%eax),%eax
  803180:	01 c2                	add    %eax,%edx
  803182:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803185:	89 50 0c             	mov    %edx,0xc(%eax)
						addToAvailMemBlocksList(blockToInsert);
  803188:	83 ec 0c             	sub    $0xc,%esp
  80318b:	ff 75 08             	pushl  0x8(%ebp)
  80318e:	e8 33 fc ff ff       	call   802dc6 <addToAvailMemBlocksList>
  803193:	83 c4 10             	add    $0x10,%esp
					//Insert
					else {
						LIST_INSERT_BEFORE(&FreeMemBlocksList, iterator,
								blockToInsert);
					}
					break;
  803196:	e9 ef 00 00 00       	jmp    80328a <insert_sorted_with_merge_freeList+0x444>
					else if (prev->sva + prev->size == blockToInsert->sva) {
						prev->size = prev->size + blockToInsert->size;
						addToAvailMemBlocksList(blockToInsert);
					}
					//next merge
					else if (blockToInsert->size + blockToInsert->sva
  80319b:	8b 45 08             	mov    0x8(%ebp),%eax
  80319e:	8b 50 0c             	mov    0xc(%eax),%edx
  8031a1:	8b 45 08             	mov    0x8(%ebp),%eax
  8031a4:	8b 40 08             	mov    0x8(%eax),%eax
  8031a7:	01 c2                	add    %eax,%edx
							== iterator->sva) {
  8031a9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8031ac:	8b 40 08             	mov    0x8(%eax),%eax
					else if (prev->sva + prev->size == blockToInsert->sva) {
						prev->size = prev->size + blockToInsert->size;
						addToAvailMemBlocksList(blockToInsert);
					}
					//next merge
					else if (blockToInsert->size + blockToInsert->sva
  8031af:	39 c2                	cmp    %eax,%edx
  8031b1:	75 33                	jne    8031e6 <insert_sorted_with_merge_freeList+0x3a0>
							== iterator->sva) {
						iterator->sva = blockToInsert->sva;
  8031b3:	8b 45 08             	mov    0x8(%ebp),%eax
  8031b6:	8b 50 08             	mov    0x8(%eax),%edx
  8031b9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8031bc:	89 50 08             	mov    %edx,0x8(%eax)
						iterator->size = iterator->size + blockToInsert->size;
  8031bf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8031c2:	8b 50 0c             	mov    0xc(%eax),%edx
  8031c5:	8b 45 08             	mov    0x8(%ebp),%eax
  8031c8:	8b 40 0c             	mov    0xc(%eax),%eax
  8031cb:	01 c2                	add    %eax,%edx
  8031cd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8031d0:	89 50 0c             	mov    %edx,0xc(%eax)
						addToAvailMemBlocksList(blockToInsert);
  8031d3:	83 ec 0c             	sub    $0xc,%esp
  8031d6:	ff 75 08             	pushl  0x8(%ebp)
  8031d9:	e8 e8 fb ff ff       	call   802dc6 <addToAvailMemBlocksList>
  8031de:	83 c4 10             	add    $0x10,%esp
					//Insert
					else {
						LIST_INSERT_BEFORE(&FreeMemBlocksList, iterator,
								blockToInsert);
					}
					break;
  8031e1:	e9 a4 00 00 00       	jmp    80328a <insert_sorted_with_merge_freeList+0x444>
						iterator->size = iterator->size + blockToInsert->size;
						addToAvailMemBlocksList(blockToInsert);
					}
					//Insert
					else {
						LIST_INSERT_BEFORE(&FreeMemBlocksList, iterator,
  8031e6:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8031ea:	74 06                	je     8031f2 <insert_sorted_with_merge_freeList+0x3ac>
  8031ec:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8031f0:	75 17                	jne    803209 <insert_sorted_with_merge_freeList+0x3c3>
  8031f2:	83 ec 04             	sub    $0x4,%esp
  8031f5:	68 08 41 80 00       	push   $0x804108
  8031fa:	68 56 01 00 00       	push   $0x156
  8031ff:	68 77 40 80 00       	push   $0x804077
  803204:	e8 aa d4 ff ff       	call   8006b3 <_panic>
  803209:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80320c:	8b 50 04             	mov    0x4(%eax),%edx
  80320f:	8b 45 08             	mov    0x8(%ebp),%eax
  803212:	89 50 04             	mov    %edx,0x4(%eax)
  803215:	8b 45 08             	mov    0x8(%ebp),%eax
  803218:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80321b:	89 10                	mov    %edx,(%eax)
  80321d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803220:	8b 40 04             	mov    0x4(%eax),%eax
  803223:	85 c0                	test   %eax,%eax
  803225:	74 0d                	je     803234 <insert_sorted_with_merge_freeList+0x3ee>
  803227:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80322a:	8b 40 04             	mov    0x4(%eax),%eax
  80322d:	8b 55 08             	mov    0x8(%ebp),%edx
  803230:	89 10                	mov    %edx,(%eax)
  803232:	eb 08                	jmp    80323c <insert_sorted_with_merge_freeList+0x3f6>
  803234:	8b 45 08             	mov    0x8(%ebp),%eax
  803237:	a3 38 51 80 00       	mov    %eax,0x805138
  80323c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80323f:	8b 55 08             	mov    0x8(%ebp),%edx
  803242:	89 50 04             	mov    %edx,0x4(%eax)
  803245:	a1 44 51 80 00       	mov    0x805144,%eax
  80324a:	40                   	inc    %eax
  80324b:	a3 44 51 80 00       	mov    %eax,0x805144
								blockToInsert);
					}
					break;
  803250:	eb 38                	jmp    80328a <insert_sorted_with_merge_freeList+0x444>
		} else {
			LIST_INSERT_AFTER(&FreeMemBlocksList, last, blockToInsert);
		}
	} else {
		struct MemBlock *iterator;
		LIST_FOREACH(iterator, &(FreeMemBlocksList))
  803252:	a1 40 51 80 00       	mov    0x805140,%eax
  803257:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80325a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80325e:	74 07                	je     803267 <insert_sorted_with_merge_freeList+0x421>
  803260:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803263:	8b 00                	mov    (%eax),%eax
  803265:	eb 05                	jmp    80326c <insert_sorted_with_merge_freeList+0x426>
  803267:	b8 00 00 00 00       	mov    $0x0,%eax
  80326c:	a3 40 51 80 00       	mov    %eax,0x805140
  803271:	a1 40 51 80 00       	mov    0x805140,%eax
  803276:	85 c0                	test   %eax,%eax
  803278:	0f 85 1a fd ff ff    	jne    802f98 <insert_sorted_with_merge_freeList+0x152>
  80327e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803282:	0f 85 10 fd ff ff    	jne    802f98 <insert_sorted_with_merge_freeList+0x152>
		}
	}

	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  803288:	eb 00                	jmp    80328a <insert_sorted_with_merge_freeList+0x444>
  80328a:	90                   	nop
  80328b:	c9                   	leave  
  80328c:	c3                   	ret    
  80328d:	66 90                	xchg   %ax,%ax
  80328f:	90                   	nop

00803290 <__udivdi3>:
  803290:	55                   	push   %ebp
  803291:	57                   	push   %edi
  803292:	56                   	push   %esi
  803293:	53                   	push   %ebx
  803294:	83 ec 1c             	sub    $0x1c,%esp
  803297:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  80329b:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  80329f:	8b 7c 24 38          	mov    0x38(%esp),%edi
  8032a3:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8032a7:	89 ca                	mov    %ecx,%edx
  8032a9:	89 f8                	mov    %edi,%eax
  8032ab:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  8032af:	85 f6                	test   %esi,%esi
  8032b1:	75 2d                	jne    8032e0 <__udivdi3+0x50>
  8032b3:	39 cf                	cmp    %ecx,%edi
  8032b5:	77 65                	ja     80331c <__udivdi3+0x8c>
  8032b7:	89 fd                	mov    %edi,%ebp
  8032b9:	85 ff                	test   %edi,%edi
  8032bb:	75 0b                	jne    8032c8 <__udivdi3+0x38>
  8032bd:	b8 01 00 00 00       	mov    $0x1,%eax
  8032c2:	31 d2                	xor    %edx,%edx
  8032c4:	f7 f7                	div    %edi
  8032c6:	89 c5                	mov    %eax,%ebp
  8032c8:	31 d2                	xor    %edx,%edx
  8032ca:	89 c8                	mov    %ecx,%eax
  8032cc:	f7 f5                	div    %ebp
  8032ce:	89 c1                	mov    %eax,%ecx
  8032d0:	89 d8                	mov    %ebx,%eax
  8032d2:	f7 f5                	div    %ebp
  8032d4:	89 cf                	mov    %ecx,%edi
  8032d6:	89 fa                	mov    %edi,%edx
  8032d8:	83 c4 1c             	add    $0x1c,%esp
  8032db:	5b                   	pop    %ebx
  8032dc:	5e                   	pop    %esi
  8032dd:	5f                   	pop    %edi
  8032de:	5d                   	pop    %ebp
  8032df:	c3                   	ret    
  8032e0:	39 ce                	cmp    %ecx,%esi
  8032e2:	77 28                	ja     80330c <__udivdi3+0x7c>
  8032e4:	0f bd fe             	bsr    %esi,%edi
  8032e7:	83 f7 1f             	xor    $0x1f,%edi
  8032ea:	75 40                	jne    80332c <__udivdi3+0x9c>
  8032ec:	39 ce                	cmp    %ecx,%esi
  8032ee:	72 0a                	jb     8032fa <__udivdi3+0x6a>
  8032f0:	3b 44 24 08          	cmp    0x8(%esp),%eax
  8032f4:	0f 87 9e 00 00 00    	ja     803398 <__udivdi3+0x108>
  8032fa:	b8 01 00 00 00       	mov    $0x1,%eax
  8032ff:	89 fa                	mov    %edi,%edx
  803301:	83 c4 1c             	add    $0x1c,%esp
  803304:	5b                   	pop    %ebx
  803305:	5e                   	pop    %esi
  803306:	5f                   	pop    %edi
  803307:	5d                   	pop    %ebp
  803308:	c3                   	ret    
  803309:	8d 76 00             	lea    0x0(%esi),%esi
  80330c:	31 ff                	xor    %edi,%edi
  80330e:	31 c0                	xor    %eax,%eax
  803310:	89 fa                	mov    %edi,%edx
  803312:	83 c4 1c             	add    $0x1c,%esp
  803315:	5b                   	pop    %ebx
  803316:	5e                   	pop    %esi
  803317:	5f                   	pop    %edi
  803318:	5d                   	pop    %ebp
  803319:	c3                   	ret    
  80331a:	66 90                	xchg   %ax,%ax
  80331c:	89 d8                	mov    %ebx,%eax
  80331e:	f7 f7                	div    %edi
  803320:	31 ff                	xor    %edi,%edi
  803322:	89 fa                	mov    %edi,%edx
  803324:	83 c4 1c             	add    $0x1c,%esp
  803327:	5b                   	pop    %ebx
  803328:	5e                   	pop    %esi
  803329:	5f                   	pop    %edi
  80332a:	5d                   	pop    %ebp
  80332b:	c3                   	ret    
  80332c:	bd 20 00 00 00       	mov    $0x20,%ebp
  803331:	89 eb                	mov    %ebp,%ebx
  803333:	29 fb                	sub    %edi,%ebx
  803335:	89 f9                	mov    %edi,%ecx
  803337:	d3 e6                	shl    %cl,%esi
  803339:	89 c5                	mov    %eax,%ebp
  80333b:	88 d9                	mov    %bl,%cl
  80333d:	d3 ed                	shr    %cl,%ebp
  80333f:	89 e9                	mov    %ebp,%ecx
  803341:	09 f1                	or     %esi,%ecx
  803343:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  803347:	89 f9                	mov    %edi,%ecx
  803349:	d3 e0                	shl    %cl,%eax
  80334b:	89 c5                	mov    %eax,%ebp
  80334d:	89 d6                	mov    %edx,%esi
  80334f:	88 d9                	mov    %bl,%cl
  803351:	d3 ee                	shr    %cl,%esi
  803353:	89 f9                	mov    %edi,%ecx
  803355:	d3 e2                	shl    %cl,%edx
  803357:	8b 44 24 08          	mov    0x8(%esp),%eax
  80335b:	88 d9                	mov    %bl,%cl
  80335d:	d3 e8                	shr    %cl,%eax
  80335f:	09 c2                	or     %eax,%edx
  803361:	89 d0                	mov    %edx,%eax
  803363:	89 f2                	mov    %esi,%edx
  803365:	f7 74 24 0c          	divl   0xc(%esp)
  803369:	89 d6                	mov    %edx,%esi
  80336b:	89 c3                	mov    %eax,%ebx
  80336d:	f7 e5                	mul    %ebp
  80336f:	39 d6                	cmp    %edx,%esi
  803371:	72 19                	jb     80338c <__udivdi3+0xfc>
  803373:	74 0b                	je     803380 <__udivdi3+0xf0>
  803375:	89 d8                	mov    %ebx,%eax
  803377:	31 ff                	xor    %edi,%edi
  803379:	e9 58 ff ff ff       	jmp    8032d6 <__udivdi3+0x46>
  80337e:	66 90                	xchg   %ax,%ax
  803380:	8b 54 24 08          	mov    0x8(%esp),%edx
  803384:	89 f9                	mov    %edi,%ecx
  803386:	d3 e2                	shl    %cl,%edx
  803388:	39 c2                	cmp    %eax,%edx
  80338a:	73 e9                	jae    803375 <__udivdi3+0xe5>
  80338c:	8d 43 ff             	lea    -0x1(%ebx),%eax
  80338f:	31 ff                	xor    %edi,%edi
  803391:	e9 40 ff ff ff       	jmp    8032d6 <__udivdi3+0x46>
  803396:	66 90                	xchg   %ax,%ax
  803398:	31 c0                	xor    %eax,%eax
  80339a:	e9 37 ff ff ff       	jmp    8032d6 <__udivdi3+0x46>
  80339f:	90                   	nop

008033a0 <__umoddi3>:
  8033a0:	55                   	push   %ebp
  8033a1:	57                   	push   %edi
  8033a2:	56                   	push   %esi
  8033a3:	53                   	push   %ebx
  8033a4:	83 ec 1c             	sub    $0x1c,%esp
  8033a7:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  8033ab:	8b 74 24 34          	mov    0x34(%esp),%esi
  8033af:	8b 7c 24 38          	mov    0x38(%esp),%edi
  8033b3:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  8033b7:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8033bb:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8033bf:	89 f3                	mov    %esi,%ebx
  8033c1:	89 fa                	mov    %edi,%edx
  8033c3:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8033c7:	89 34 24             	mov    %esi,(%esp)
  8033ca:	85 c0                	test   %eax,%eax
  8033cc:	75 1a                	jne    8033e8 <__umoddi3+0x48>
  8033ce:	39 f7                	cmp    %esi,%edi
  8033d0:	0f 86 a2 00 00 00    	jbe    803478 <__umoddi3+0xd8>
  8033d6:	89 c8                	mov    %ecx,%eax
  8033d8:	89 f2                	mov    %esi,%edx
  8033da:	f7 f7                	div    %edi
  8033dc:	89 d0                	mov    %edx,%eax
  8033de:	31 d2                	xor    %edx,%edx
  8033e0:	83 c4 1c             	add    $0x1c,%esp
  8033e3:	5b                   	pop    %ebx
  8033e4:	5e                   	pop    %esi
  8033e5:	5f                   	pop    %edi
  8033e6:	5d                   	pop    %ebp
  8033e7:	c3                   	ret    
  8033e8:	39 f0                	cmp    %esi,%eax
  8033ea:	0f 87 ac 00 00 00    	ja     80349c <__umoddi3+0xfc>
  8033f0:	0f bd e8             	bsr    %eax,%ebp
  8033f3:	83 f5 1f             	xor    $0x1f,%ebp
  8033f6:	0f 84 ac 00 00 00    	je     8034a8 <__umoddi3+0x108>
  8033fc:	bf 20 00 00 00       	mov    $0x20,%edi
  803401:	29 ef                	sub    %ebp,%edi
  803403:	89 fe                	mov    %edi,%esi
  803405:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  803409:	89 e9                	mov    %ebp,%ecx
  80340b:	d3 e0                	shl    %cl,%eax
  80340d:	89 d7                	mov    %edx,%edi
  80340f:	89 f1                	mov    %esi,%ecx
  803411:	d3 ef                	shr    %cl,%edi
  803413:	09 c7                	or     %eax,%edi
  803415:	89 e9                	mov    %ebp,%ecx
  803417:	d3 e2                	shl    %cl,%edx
  803419:	89 14 24             	mov    %edx,(%esp)
  80341c:	89 d8                	mov    %ebx,%eax
  80341e:	d3 e0                	shl    %cl,%eax
  803420:	89 c2                	mov    %eax,%edx
  803422:	8b 44 24 08          	mov    0x8(%esp),%eax
  803426:	d3 e0                	shl    %cl,%eax
  803428:	89 44 24 04          	mov    %eax,0x4(%esp)
  80342c:	8b 44 24 08          	mov    0x8(%esp),%eax
  803430:	89 f1                	mov    %esi,%ecx
  803432:	d3 e8                	shr    %cl,%eax
  803434:	09 d0                	or     %edx,%eax
  803436:	d3 eb                	shr    %cl,%ebx
  803438:	89 da                	mov    %ebx,%edx
  80343a:	f7 f7                	div    %edi
  80343c:	89 d3                	mov    %edx,%ebx
  80343e:	f7 24 24             	mull   (%esp)
  803441:	89 c6                	mov    %eax,%esi
  803443:	89 d1                	mov    %edx,%ecx
  803445:	39 d3                	cmp    %edx,%ebx
  803447:	0f 82 87 00 00 00    	jb     8034d4 <__umoddi3+0x134>
  80344d:	0f 84 91 00 00 00    	je     8034e4 <__umoddi3+0x144>
  803453:	8b 54 24 04          	mov    0x4(%esp),%edx
  803457:	29 f2                	sub    %esi,%edx
  803459:	19 cb                	sbb    %ecx,%ebx
  80345b:	89 d8                	mov    %ebx,%eax
  80345d:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  803461:	d3 e0                	shl    %cl,%eax
  803463:	89 e9                	mov    %ebp,%ecx
  803465:	d3 ea                	shr    %cl,%edx
  803467:	09 d0                	or     %edx,%eax
  803469:	89 e9                	mov    %ebp,%ecx
  80346b:	d3 eb                	shr    %cl,%ebx
  80346d:	89 da                	mov    %ebx,%edx
  80346f:	83 c4 1c             	add    $0x1c,%esp
  803472:	5b                   	pop    %ebx
  803473:	5e                   	pop    %esi
  803474:	5f                   	pop    %edi
  803475:	5d                   	pop    %ebp
  803476:	c3                   	ret    
  803477:	90                   	nop
  803478:	89 fd                	mov    %edi,%ebp
  80347a:	85 ff                	test   %edi,%edi
  80347c:	75 0b                	jne    803489 <__umoddi3+0xe9>
  80347e:	b8 01 00 00 00       	mov    $0x1,%eax
  803483:	31 d2                	xor    %edx,%edx
  803485:	f7 f7                	div    %edi
  803487:	89 c5                	mov    %eax,%ebp
  803489:	89 f0                	mov    %esi,%eax
  80348b:	31 d2                	xor    %edx,%edx
  80348d:	f7 f5                	div    %ebp
  80348f:	89 c8                	mov    %ecx,%eax
  803491:	f7 f5                	div    %ebp
  803493:	89 d0                	mov    %edx,%eax
  803495:	e9 44 ff ff ff       	jmp    8033de <__umoddi3+0x3e>
  80349a:	66 90                	xchg   %ax,%ax
  80349c:	89 c8                	mov    %ecx,%eax
  80349e:	89 f2                	mov    %esi,%edx
  8034a0:	83 c4 1c             	add    $0x1c,%esp
  8034a3:	5b                   	pop    %ebx
  8034a4:	5e                   	pop    %esi
  8034a5:	5f                   	pop    %edi
  8034a6:	5d                   	pop    %ebp
  8034a7:	c3                   	ret    
  8034a8:	3b 04 24             	cmp    (%esp),%eax
  8034ab:	72 06                	jb     8034b3 <__umoddi3+0x113>
  8034ad:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  8034b1:	77 0f                	ja     8034c2 <__umoddi3+0x122>
  8034b3:	89 f2                	mov    %esi,%edx
  8034b5:	29 f9                	sub    %edi,%ecx
  8034b7:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  8034bb:	89 14 24             	mov    %edx,(%esp)
  8034be:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8034c2:	8b 44 24 04          	mov    0x4(%esp),%eax
  8034c6:	8b 14 24             	mov    (%esp),%edx
  8034c9:	83 c4 1c             	add    $0x1c,%esp
  8034cc:	5b                   	pop    %ebx
  8034cd:	5e                   	pop    %esi
  8034ce:	5f                   	pop    %edi
  8034cf:	5d                   	pop    %ebp
  8034d0:	c3                   	ret    
  8034d1:	8d 76 00             	lea    0x0(%esi),%esi
  8034d4:	2b 04 24             	sub    (%esp),%eax
  8034d7:	19 fa                	sbb    %edi,%edx
  8034d9:	89 d1                	mov    %edx,%ecx
  8034db:	89 c6                	mov    %eax,%esi
  8034dd:	e9 71 ff ff ff       	jmp    803453 <__umoddi3+0xb3>
  8034e2:	66 90                	xchg   %ax,%ax
  8034e4:	39 44 24 04          	cmp    %eax,0x4(%esp)
  8034e8:	72 ea                	jb     8034d4 <__umoddi3+0x134>
  8034ea:	89 d9                	mov    %ebx,%ecx
  8034ec:	e9 62 ff ff ff       	jmp    803453 <__umoddi3+0xb3>
