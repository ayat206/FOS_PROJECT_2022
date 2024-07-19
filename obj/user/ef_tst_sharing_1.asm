
obj/user/ef_tst_sharing_1:     file format elf32-i386


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
  800031:	e8 64 03 00 00       	call   80039a <libmain>
1:      jmp 1b
  800036:	eb fe                	jmp    800036 <args_exist+0x5>

00800038 <_main>:
// Test the creation of shared variables (create_shared_memory)
#include <inc/lib.h>

void
_main(void)
{
  800038:	55                   	push   %ebp
  800039:	89 e5                	mov    %esp,%ebp
  80003b:	53                   	push   %ebx
  80003c:	83 ec 34             	sub    $0x34,%esp
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
_main(void)
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
  80008d:	68 20 33 80 00       	push   $0x803320
  800092:	6a 12                	push   $0x12
  800094:	68 3c 33 80 00       	push   $0x80333c
  800099:	e8 38 04 00 00       	call   8004d6 <_panic>
	}

	uint32 *x, *y, *z ;
	cprintf("STEP A: checking the creation of shared variables... \n");
  80009e:	83 ec 0c             	sub    $0xc,%esp
  8000a1:	68 54 33 80 00       	push   $0x803354
  8000a6:	e8 df 06 00 00       	call   80078a <cprintf>
  8000ab:	83 c4 10             	add    $0x10,%esp
	{
		int freeFrames = sys_calculate_free_frames() ;
  8000ae:	e8 75 1a 00 00       	call   801b28 <sys_calculate_free_frames>
  8000b3:	89 45 e8             	mov    %eax,-0x18(%ebp)
		x = smalloc("x", PAGE_SIZE, 1);
  8000b6:	83 ec 04             	sub    $0x4,%esp
  8000b9:	6a 01                	push   $0x1
  8000bb:	68 00 10 00 00       	push   $0x1000
  8000c0:	68 8b 33 80 00       	push   $0x80338b
  8000c5:	e8 9a 17 00 00       	call   801864 <smalloc>
  8000ca:	83 c4 10             	add    $0x10,%esp
  8000cd:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		if (x != (uint32*)USER_HEAP_START) panic("Returned address is not correct. check the setting of it and/or the updating of the shared_mem_free_address");
  8000d0:	81 7d e4 00 00 00 80 	cmpl   $0x80000000,-0x1c(%ebp)
  8000d7:	74 14                	je     8000ed <_main+0xb5>
  8000d9:	83 ec 04             	sub    $0x4,%esp
  8000dc:	68 90 33 80 00       	push   $0x803390
  8000e1:	6a 1a                	push   $0x1a
  8000e3:	68 3c 33 80 00       	push   $0x80333c
  8000e8:	e8 e9 03 00 00       	call   8004d6 <_panic>
		if ((freeFrames - sys_calculate_free_frames()) !=  1+1+2) panic("Wrong allocation: make sure that you allocate the required space in the user environment and add its frames to frames_storage %d %d %d", freeFrames, sys_calculate_free_frames(), freeFrames - sys_calculate_free_frames());
  8000ed:	8b 5d e8             	mov    -0x18(%ebp),%ebx
  8000f0:	e8 33 1a 00 00       	call   801b28 <sys_calculate_free_frames>
  8000f5:	29 c3                	sub    %eax,%ebx
  8000f7:	89 d8                	mov    %ebx,%eax
  8000f9:	83 f8 04             	cmp    $0x4,%eax
  8000fc:	74 28                	je     800126 <_main+0xee>
  8000fe:	8b 5d e8             	mov    -0x18(%ebp),%ebx
  800101:	e8 22 1a 00 00       	call   801b28 <sys_calculate_free_frames>
  800106:	29 c3                	sub    %eax,%ebx
  800108:	e8 1b 1a 00 00       	call   801b28 <sys_calculate_free_frames>
  80010d:	83 ec 08             	sub    $0x8,%esp
  800110:	53                   	push   %ebx
  800111:	50                   	push   %eax
  800112:	ff 75 e8             	pushl  -0x18(%ebp)
  800115:	68 fc 33 80 00       	push   $0x8033fc
  80011a:	6a 1b                	push   $0x1b
  80011c:	68 3c 33 80 00       	push   $0x80333c
  800121:	e8 b0 03 00 00       	call   8004d6 <_panic>

		freeFrames = sys_calculate_free_frames() ;
  800126:	e8 fd 19 00 00       	call   801b28 <sys_calculate_free_frames>
  80012b:	89 45 e8             	mov    %eax,-0x18(%ebp)
		z = smalloc("y", PAGE_SIZE + 4, 1);
  80012e:	83 ec 04             	sub    $0x4,%esp
  800131:	6a 01                	push   $0x1
  800133:	68 04 10 00 00       	push   $0x1004
  800138:	68 83 34 80 00       	push   $0x803483
  80013d:	e8 22 17 00 00       	call   801864 <smalloc>
  800142:	83 c4 10             	add    $0x10,%esp
  800145:	89 45 e0             	mov    %eax,-0x20(%ebp)
		if (z != (uint32*)(USER_HEAP_START + 1 * PAGE_SIZE)) panic("Returned address is not correct. check the setting of it and/or the updating of the shared_mem_free_address");
  800148:	81 7d e0 00 10 00 80 	cmpl   $0x80001000,-0x20(%ebp)
  80014f:	74 14                	je     800165 <_main+0x12d>
  800151:	83 ec 04             	sub    $0x4,%esp
  800154:	68 90 33 80 00       	push   $0x803390
  800159:	6a 1f                	push   $0x1f
  80015b:	68 3c 33 80 00       	push   $0x80333c
  800160:	e8 71 03 00 00       	call   8004d6 <_panic>

		if ((freeFrames - sys_calculate_free_frames()) !=  2+0+2) panic("Wrong allocation: make sure that you allocate the required space in the user environment and add its frames to frames_storage %d %d %d", freeFrames, sys_calculate_free_frames(), freeFrames - sys_calculate_free_frames());
  800165:	8b 5d e8             	mov    -0x18(%ebp),%ebx
  800168:	e8 bb 19 00 00       	call   801b28 <sys_calculate_free_frames>
  80016d:	29 c3                	sub    %eax,%ebx
  80016f:	89 d8                	mov    %ebx,%eax
  800171:	83 f8 04             	cmp    $0x4,%eax
  800174:	74 28                	je     80019e <_main+0x166>
  800176:	8b 5d e8             	mov    -0x18(%ebp),%ebx
  800179:	e8 aa 19 00 00       	call   801b28 <sys_calculate_free_frames>
  80017e:	29 c3                	sub    %eax,%ebx
  800180:	e8 a3 19 00 00       	call   801b28 <sys_calculate_free_frames>
  800185:	83 ec 08             	sub    $0x8,%esp
  800188:	53                   	push   %ebx
  800189:	50                   	push   %eax
  80018a:	ff 75 e8             	pushl  -0x18(%ebp)
  80018d:	68 fc 33 80 00       	push   $0x8033fc
  800192:	6a 21                	push   $0x21
  800194:	68 3c 33 80 00       	push   $0x80333c
  800199:	e8 38 03 00 00       	call   8004d6 <_panic>

		freeFrames = sys_calculate_free_frames() ;
  80019e:	e8 85 19 00 00       	call   801b28 <sys_calculate_free_frames>
  8001a3:	89 45 e8             	mov    %eax,-0x18(%ebp)
		y = smalloc("z", 4, 1);
  8001a6:	83 ec 04             	sub    $0x4,%esp
  8001a9:	6a 01                	push   $0x1
  8001ab:	6a 04                	push   $0x4
  8001ad:	68 85 34 80 00       	push   $0x803485
  8001b2:	e8 ad 16 00 00       	call   801864 <smalloc>
  8001b7:	83 c4 10             	add    $0x10,%esp
  8001ba:	89 45 dc             	mov    %eax,-0x24(%ebp)
		if (y != (uint32*)(USER_HEAP_START + 3 * PAGE_SIZE)) panic("Returned address is not correct. check the setting of it and/or the updating of the shared_mem_free_address");
  8001bd:	81 7d dc 00 30 00 80 	cmpl   $0x80003000,-0x24(%ebp)
  8001c4:	74 14                	je     8001da <_main+0x1a2>
  8001c6:	83 ec 04             	sub    $0x4,%esp
  8001c9:	68 90 33 80 00       	push   $0x803390
  8001ce:	6a 25                	push   $0x25
  8001d0:	68 3c 33 80 00       	push   $0x80333c
  8001d5:	e8 fc 02 00 00       	call   8004d6 <_panic>
		if ((freeFrames - sys_calculate_free_frames()) !=  1+0+2) panic("Wrong allocation: make sure that you allocate the required space in the user environment and add its frames to frames_storage");
  8001da:	8b 5d e8             	mov    -0x18(%ebp),%ebx
  8001dd:	e8 46 19 00 00       	call   801b28 <sys_calculate_free_frames>
  8001e2:	29 c3                	sub    %eax,%ebx
  8001e4:	89 d8                	mov    %ebx,%eax
  8001e6:	83 f8 03             	cmp    $0x3,%eax
  8001e9:	74 14                	je     8001ff <_main+0x1c7>
  8001eb:	83 ec 04             	sub    $0x4,%esp
  8001ee:	68 88 34 80 00       	push   $0x803488
  8001f3:	6a 26                	push   $0x26
  8001f5:	68 3c 33 80 00       	push   $0x80333c
  8001fa:	e8 d7 02 00 00       	call   8004d6 <_panic>
	}
	cprintf("Step A is completed successfully!!\n\n\n");
  8001ff:	83 ec 0c             	sub    $0xc,%esp
  800202:	68 08 35 80 00       	push   $0x803508
  800207:	e8 7e 05 00 00       	call   80078a <cprintf>
  80020c:	83 c4 10             	add    $0x10,%esp


	cprintf("STEP B: checking reading & writing... \n");
  80020f:	83 ec 0c             	sub    $0xc,%esp
  800212:	68 30 35 80 00       	push   $0x803530
  800217:	e8 6e 05 00 00       	call   80078a <cprintf>
  80021c:	83 c4 10             	add    $0x10,%esp
	{
		int i=0;
  80021f:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for(;i<PAGE_SIZE/4;i++)
  800226:	eb 2d                	jmp    800255 <_main+0x21d>
		{
			x[i] = -1;
  800228:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80022b:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800232:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800235:	01 d0                	add    %edx,%eax
  800237:	c7 00 ff ff ff ff    	movl   $0xffffffff,(%eax)
			y[i] = -1;
  80023d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800240:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800247:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80024a:	01 d0                	add    %edx,%eax
  80024c:	c7 00 ff ff ff ff    	movl   $0xffffffff,(%eax)


	cprintf("STEP B: checking reading & writing... \n");
	{
		int i=0;
		for(;i<PAGE_SIZE/4;i++)
  800252:	ff 45 ec             	incl   -0x14(%ebp)
  800255:	81 7d ec ff 03 00 00 	cmpl   $0x3ff,-0x14(%ebp)
  80025c:	7e ca                	jle    800228 <_main+0x1f0>
		{
			x[i] = -1;
			y[i] = -1;
		}

		i=0;
  80025e:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for(;i<2*PAGE_SIZE/4;i++)
  800265:	eb 18                	jmp    80027f <_main+0x247>
		{
			z[i] = -1;
  800267:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80026a:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800271:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800274:	01 d0                	add    %edx,%eax
  800276:	c7 00 ff ff ff ff    	movl   $0xffffffff,(%eax)
			x[i] = -1;
			y[i] = -1;
		}

		i=0;
		for(;i<2*PAGE_SIZE/4;i++)
  80027c:	ff 45 ec             	incl   -0x14(%ebp)
  80027f:	81 7d ec ff 07 00 00 	cmpl   $0x7ff,-0x14(%ebp)
  800286:	7e df                	jle    800267 <_main+0x22f>
		{
			z[i] = -1;
		}

		if( x[0] !=  -1)  					panic("Reading/Writing of shared object is failed");
  800288:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80028b:	8b 00                	mov    (%eax),%eax
  80028d:	83 f8 ff             	cmp    $0xffffffff,%eax
  800290:	74 14                	je     8002a6 <_main+0x26e>
  800292:	83 ec 04             	sub    $0x4,%esp
  800295:	68 58 35 80 00       	push   $0x803558
  80029a:	6a 3a                	push   $0x3a
  80029c:	68 3c 33 80 00       	push   $0x80333c
  8002a1:	e8 30 02 00 00       	call   8004d6 <_panic>
		if( x[PAGE_SIZE/4 - 1] !=  -1)  	panic("Reading/Writing of shared object is failed");
  8002a6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8002a9:	05 fc 0f 00 00       	add    $0xffc,%eax
  8002ae:	8b 00                	mov    (%eax),%eax
  8002b0:	83 f8 ff             	cmp    $0xffffffff,%eax
  8002b3:	74 14                	je     8002c9 <_main+0x291>
  8002b5:	83 ec 04             	sub    $0x4,%esp
  8002b8:	68 58 35 80 00       	push   $0x803558
  8002bd:	6a 3b                	push   $0x3b
  8002bf:	68 3c 33 80 00       	push   $0x80333c
  8002c4:	e8 0d 02 00 00       	call   8004d6 <_panic>

		if( y[0] !=  -1)  					panic("Reading/Writing of shared object is failed");
  8002c9:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8002cc:	8b 00                	mov    (%eax),%eax
  8002ce:	83 f8 ff             	cmp    $0xffffffff,%eax
  8002d1:	74 14                	je     8002e7 <_main+0x2af>
  8002d3:	83 ec 04             	sub    $0x4,%esp
  8002d6:	68 58 35 80 00       	push   $0x803558
  8002db:	6a 3d                	push   $0x3d
  8002dd:	68 3c 33 80 00       	push   $0x80333c
  8002e2:	e8 ef 01 00 00       	call   8004d6 <_panic>
		if( y[PAGE_SIZE/4 - 1] !=  -1)  	panic("Reading/Writing of shared object is failed");
  8002e7:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8002ea:	05 fc 0f 00 00       	add    $0xffc,%eax
  8002ef:	8b 00                	mov    (%eax),%eax
  8002f1:	83 f8 ff             	cmp    $0xffffffff,%eax
  8002f4:	74 14                	je     80030a <_main+0x2d2>
  8002f6:	83 ec 04             	sub    $0x4,%esp
  8002f9:	68 58 35 80 00       	push   $0x803558
  8002fe:	6a 3e                	push   $0x3e
  800300:	68 3c 33 80 00       	push   $0x80333c
  800305:	e8 cc 01 00 00       	call   8004d6 <_panic>

		if( z[0] !=  -1)  					panic("Reading/Writing of shared object is failed");
  80030a:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80030d:	8b 00                	mov    (%eax),%eax
  80030f:	83 f8 ff             	cmp    $0xffffffff,%eax
  800312:	74 14                	je     800328 <_main+0x2f0>
  800314:	83 ec 04             	sub    $0x4,%esp
  800317:	68 58 35 80 00       	push   $0x803558
  80031c:	6a 40                	push   $0x40
  80031e:	68 3c 33 80 00       	push   $0x80333c
  800323:	e8 ae 01 00 00       	call   8004d6 <_panic>
		if( z[2*PAGE_SIZE/4 - 1] !=  -1)  	panic("Reading/Writing of shared object is failed");
  800328:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80032b:	05 fc 1f 00 00       	add    $0x1ffc,%eax
  800330:	8b 00                	mov    (%eax),%eax
  800332:	83 f8 ff             	cmp    $0xffffffff,%eax
  800335:	74 14                	je     80034b <_main+0x313>
  800337:	83 ec 04             	sub    $0x4,%esp
  80033a:	68 58 35 80 00       	push   $0x803558
  80033f:	6a 41                	push   $0x41
  800341:	68 3c 33 80 00       	push   $0x80333c
  800346:	e8 8b 01 00 00       	call   8004d6 <_panic>
	}

	cprintf("Congratulations!! Test of Shared Variables [Create] [1] completed successfully!!\n\n\n");
  80034b:	83 ec 0c             	sub    $0xc,%esp
  80034e:	68 84 35 80 00       	push   $0x803584
  800353:	e8 32 04 00 00       	call   80078a <cprintf>
  800358:	83 c4 10             	add    $0x10,%esp

	int32 parentenvID = sys_getparentenvid();
  80035b:	e8 c1 1a 00 00       	call   801e21 <sys_getparentenvid>
  800360:	89 45 d8             	mov    %eax,-0x28(%ebp)
	if(parentenvID > 0)
  800363:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  800367:	7e 2b                	jle    800394 <_main+0x35c>
	{
		//Get the check-finishing counter
		int *finishedCount = NULL;
  800369:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
		finishedCount = sget(parentenvID, "finishedCount") ;
  800370:	83 ec 08             	sub    $0x8,%esp
  800373:	68 d8 35 80 00       	push   $0x8035d8
  800378:	ff 75 d8             	pushl  -0x28(%ebp)
  80037b:	e8 94 15 00 00       	call   801914 <sget>
  800380:	83 c4 10             	add    $0x10,%esp
  800383:	89 45 d4             	mov    %eax,-0x2c(%ebp)
		(*finishedCount)++ ;
  800386:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  800389:	8b 00                	mov    (%eax),%eax
  80038b:	8d 50 01             	lea    0x1(%eax),%edx
  80038e:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  800391:	89 10                	mov    %edx,(%eax)
	}

	return;
  800393:	90                   	nop
  800394:	90                   	nop
}
  800395:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800398:	c9                   	leave  
  800399:	c3                   	ret    

0080039a <libmain>:
volatile struct Env *myEnv = NULL;
volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";

void
libmain(int argc, char **argv)
{
  80039a:	55                   	push   %ebp
  80039b:	89 e5                	mov    %esp,%ebp
  80039d:	83 ec 18             	sub    $0x18,%esp
	int envIndex = sys_getenvindex();
  8003a0:	e8 63 1a 00 00       	call   801e08 <sys_getenvindex>
  8003a5:	89 45 f4             	mov    %eax,-0xc(%ebp)
	myEnv = &(envs[envIndex]);
  8003a8:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8003ab:	89 d0                	mov    %edx,%eax
  8003ad:	c1 e0 03             	shl    $0x3,%eax
  8003b0:	01 d0                	add    %edx,%eax
  8003b2:	01 c0                	add    %eax,%eax
  8003b4:	01 d0                	add    %edx,%eax
  8003b6:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8003bd:	01 d0                	add    %edx,%eax
  8003bf:	c1 e0 04             	shl    $0x4,%eax
  8003c2:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  8003c7:	a3 20 40 80 00       	mov    %eax,0x804020

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  8003cc:	a1 20 40 80 00       	mov    0x804020,%eax
  8003d1:	8a 80 5c 05 00 00    	mov    0x55c(%eax),%al
  8003d7:	84 c0                	test   %al,%al
  8003d9:	74 0f                	je     8003ea <libmain+0x50>
		binaryname = myEnv->prog_name;
  8003db:	a1 20 40 80 00       	mov    0x804020,%eax
  8003e0:	05 5c 05 00 00       	add    $0x55c,%eax
  8003e5:	a3 00 40 80 00       	mov    %eax,0x804000

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  8003ea:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8003ee:	7e 0a                	jle    8003fa <libmain+0x60>
		binaryname = argv[0];
  8003f0:	8b 45 0c             	mov    0xc(%ebp),%eax
  8003f3:	8b 00                	mov    (%eax),%eax
  8003f5:	a3 00 40 80 00       	mov    %eax,0x804000

	// call user main routine
	_main(argc, argv);
  8003fa:	83 ec 08             	sub    $0x8,%esp
  8003fd:	ff 75 0c             	pushl  0xc(%ebp)
  800400:	ff 75 08             	pushl  0x8(%ebp)
  800403:	e8 30 fc ff ff       	call   800038 <_main>
  800408:	83 c4 10             	add    $0x10,%esp



	sys_disable_interrupt();
  80040b:	e8 05 18 00 00       	call   801c15 <sys_disable_interrupt>
	cprintf("**************************************\n");
  800410:	83 ec 0c             	sub    $0xc,%esp
  800413:	68 00 36 80 00       	push   $0x803600
  800418:	e8 6d 03 00 00       	call   80078a <cprintf>
  80041d:	83 c4 10             	add    $0x10,%esp
	cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  800420:	a1 20 40 80 00       	mov    0x804020,%eax
  800425:	8b 90 44 05 00 00    	mov    0x544(%eax),%edx
  80042b:	a1 20 40 80 00       	mov    0x804020,%eax
  800430:	8b 80 34 05 00 00    	mov    0x534(%eax),%eax
  800436:	83 ec 04             	sub    $0x4,%esp
  800439:	52                   	push   %edx
  80043a:	50                   	push   %eax
  80043b:	68 28 36 80 00       	push   $0x803628
  800440:	e8 45 03 00 00       	call   80078a <cprintf>
  800445:	83 c4 10             	add    $0x10,%esp
	cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  800448:	a1 20 40 80 00       	mov    0x804020,%eax
  80044d:	8b 88 54 05 00 00    	mov    0x554(%eax),%ecx
  800453:	a1 20 40 80 00       	mov    0x804020,%eax
  800458:	8b 90 50 05 00 00    	mov    0x550(%eax),%edx
  80045e:	a1 20 40 80 00       	mov    0x804020,%eax
  800463:	8b 80 4c 05 00 00    	mov    0x54c(%eax),%eax
  800469:	51                   	push   %ecx
  80046a:	52                   	push   %edx
  80046b:	50                   	push   %eax
  80046c:	68 50 36 80 00       	push   $0x803650
  800471:	e8 14 03 00 00       	call   80078a <cprintf>
  800476:	83 c4 10             	add    $0x10,%esp
	//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
	cprintf("Num of clocks = %d\n", myEnv->nClocks);
  800479:	a1 20 40 80 00       	mov    0x804020,%eax
  80047e:	8b 80 a4 05 00 00    	mov    0x5a4(%eax),%eax
  800484:	83 ec 08             	sub    $0x8,%esp
  800487:	50                   	push   %eax
  800488:	68 a8 36 80 00       	push   $0x8036a8
  80048d:	e8 f8 02 00 00       	call   80078a <cprintf>
  800492:	83 c4 10             	add    $0x10,%esp
	cprintf("**************************************\n");
  800495:	83 ec 0c             	sub    $0xc,%esp
  800498:	68 00 36 80 00       	push   $0x803600
  80049d:	e8 e8 02 00 00       	call   80078a <cprintf>
  8004a2:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  8004a5:	e8 85 17 00 00       	call   801c2f <sys_enable_interrupt>

	// exit gracefully
	exit();
  8004aa:	e8 19 00 00 00       	call   8004c8 <exit>
}
  8004af:	90                   	nop
  8004b0:	c9                   	leave  
  8004b1:	c3                   	ret    

008004b2 <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  8004b2:	55                   	push   %ebp
  8004b3:	89 e5                	mov    %esp,%ebp
  8004b5:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  8004b8:	83 ec 0c             	sub    $0xc,%esp
  8004bb:	6a 00                	push   $0x0
  8004bd:	e8 12 19 00 00       	call   801dd4 <sys_destroy_env>
  8004c2:	83 c4 10             	add    $0x10,%esp
}
  8004c5:	90                   	nop
  8004c6:	c9                   	leave  
  8004c7:	c3                   	ret    

008004c8 <exit>:

void
exit(void)
{
  8004c8:	55                   	push   %ebp
  8004c9:	89 e5                	mov    %esp,%ebp
  8004cb:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  8004ce:	e8 67 19 00 00       	call   801e3a <sys_exit_env>
}
  8004d3:	90                   	nop
  8004d4:	c9                   	leave  
  8004d5:	c3                   	ret    

008004d6 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  8004d6:	55                   	push   %ebp
  8004d7:	89 e5                	mov    %esp,%ebp
  8004d9:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  8004dc:	8d 45 10             	lea    0x10(%ebp),%eax
  8004df:	83 c0 04             	add    $0x4,%eax
  8004e2:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  8004e5:	a1 5c 41 80 00       	mov    0x80415c,%eax
  8004ea:	85 c0                	test   %eax,%eax
  8004ec:	74 16                	je     800504 <_panic+0x2e>
		cprintf("%s: ", argv0);
  8004ee:	a1 5c 41 80 00       	mov    0x80415c,%eax
  8004f3:	83 ec 08             	sub    $0x8,%esp
  8004f6:	50                   	push   %eax
  8004f7:	68 bc 36 80 00       	push   $0x8036bc
  8004fc:	e8 89 02 00 00       	call   80078a <cprintf>
  800501:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  800504:	a1 00 40 80 00       	mov    0x804000,%eax
  800509:	ff 75 0c             	pushl  0xc(%ebp)
  80050c:	ff 75 08             	pushl  0x8(%ebp)
  80050f:	50                   	push   %eax
  800510:	68 c1 36 80 00       	push   $0x8036c1
  800515:	e8 70 02 00 00       	call   80078a <cprintf>
  80051a:	83 c4 10             	add    $0x10,%esp
	vcprintf(fmt, ap);
  80051d:	8b 45 10             	mov    0x10(%ebp),%eax
  800520:	83 ec 08             	sub    $0x8,%esp
  800523:	ff 75 f4             	pushl  -0xc(%ebp)
  800526:	50                   	push   %eax
  800527:	e8 f3 01 00 00       	call   80071f <vcprintf>
  80052c:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  80052f:	83 ec 08             	sub    $0x8,%esp
  800532:	6a 00                	push   $0x0
  800534:	68 dd 36 80 00       	push   $0x8036dd
  800539:	e8 e1 01 00 00       	call   80071f <vcprintf>
  80053e:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  800541:	e8 82 ff ff ff       	call   8004c8 <exit>

	// should not return here
	while (1) ;
  800546:	eb fe                	jmp    800546 <_panic+0x70>

00800548 <CheckWSWithoutLastIndex>:
}

void CheckWSWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  800548:	55                   	push   %ebp
  800549:	89 e5                	mov    %esp,%ebp
  80054b:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  80054e:	a1 20 40 80 00       	mov    0x804020,%eax
  800553:	8b 50 74             	mov    0x74(%eax),%edx
  800556:	8b 45 0c             	mov    0xc(%ebp),%eax
  800559:	39 c2                	cmp    %eax,%edx
  80055b:	74 14                	je     800571 <CheckWSWithoutLastIndex+0x29>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  80055d:	83 ec 04             	sub    $0x4,%esp
  800560:	68 e0 36 80 00       	push   $0x8036e0
  800565:	6a 26                	push   $0x26
  800567:	68 2c 37 80 00       	push   $0x80372c
  80056c:	e8 65 ff ff ff       	call   8004d6 <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  800571:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  800578:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  80057f:	e9 c2 00 00 00       	jmp    800646 <CheckWSWithoutLastIndex+0xfe>
		if (expectedPages[e] == 0) {
  800584:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800587:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80058e:	8b 45 08             	mov    0x8(%ebp),%eax
  800591:	01 d0                	add    %edx,%eax
  800593:	8b 00                	mov    (%eax),%eax
  800595:	85 c0                	test   %eax,%eax
  800597:	75 08                	jne    8005a1 <CheckWSWithoutLastIndex+0x59>
			expectedNumOfEmptyLocs++;
  800599:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  80059c:	e9 a2 00 00 00       	jmp    800643 <CheckWSWithoutLastIndex+0xfb>
		}
		int found = 0;
  8005a1:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8005a8:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  8005af:	eb 69                	jmp    80061a <CheckWSWithoutLastIndex+0xd2>
			if (myEnv->__uptr_pws[w].empty == 0) {
  8005b1:	a1 20 40 80 00       	mov    0x804020,%eax
  8005b6:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  8005bc:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8005bf:	89 d0                	mov    %edx,%eax
  8005c1:	01 c0                	add    %eax,%eax
  8005c3:	01 d0                	add    %edx,%eax
  8005c5:	c1 e0 03             	shl    $0x3,%eax
  8005c8:	01 c8                	add    %ecx,%eax
  8005ca:	8a 40 04             	mov    0x4(%eax),%al
  8005cd:	84 c0                	test   %al,%al
  8005cf:	75 46                	jne    800617 <CheckWSWithoutLastIndex+0xcf>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  8005d1:	a1 20 40 80 00       	mov    0x804020,%eax
  8005d6:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  8005dc:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8005df:	89 d0                	mov    %edx,%eax
  8005e1:	01 c0                	add    %eax,%eax
  8005e3:	01 d0                	add    %edx,%eax
  8005e5:	c1 e0 03             	shl    $0x3,%eax
  8005e8:	01 c8                	add    %ecx,%eax
  8005ea:	8b 00                	mov    (%eax),%eax
  8005ec:	89 45 dc             	mov    %eax,-0x24(%ebp)
  8005ef:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8005f2:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8005f7:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  8005f9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8005fc:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  800603:	8b 45 08             	mov    0x8(%ebp),%eax
  800606:	01 c8                	add    %ecx,%eax
  800608:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  80060a:	39 c2                	cmp    %eax,%edx
  80060c:	75 09                	jne    800617 <CheckWSWithoutLastIndex+0xcf>
						== expectedPages[e]) {
					found = 1;
  80060e:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  800615:	eb 12                	jmp    800629 <CheckWSWithoutLastIndex+0xe1>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800617:	ff 45 e8             	incl   -0x18(%ebp)
  80061a:	a1 20 40 80 00       	mov    0x804020,%eax
  80061f:	8b 50 74             	mov    0x74(%eax),%edx
  800622:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800625:	39 c2                	cmp    %eax,%edx
  800627:	77 88                	ja     8005b1 <CheckWSWithoutLastIndex+0x69>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  800629:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  80062d:	75 14                	jne    800643 <CheckWSWithoutLastIndex+0xfb>
			panic(
  80062f:	83 ec 04             	sub    $0x4,%esp
  800632:	68 38 37 80 00       	push   $0x803738
  800637:	6a 3a                	push   $0x3a
  800639:	68 2c 37 80 00       	push   $0x80372c
  80063e:	e8 93 fe ff ff       	call   8004d6 <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  800643:	ff 45 f0             	incl   -0x10(%ebp)
  800646:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800649:	3b 45 0c             	cmp    0xc(%ebp),%eax
  80064c:	0f 8c 32 ff ff ff    	jl     800584 <CheckWSWithoutLastIndex+0x3c>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  800652:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800659:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  800660:	eb 26                	jmp    800688 <CheckWSWithoutLastIndex+0x140>
		if (myEnv->__uptr_pws[w].empty == 1) {
  800662:	a1 20 40 80 00       	mov    0x804020,%eax
  800667:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  80066d:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800670:	89 d0                	mov    %edx,%eax
  800672:	01 c0                	add    %eax,%eax
  800674:	01 d0                	add    %edx,%eax
  800676:	c1 e0 03             	shl    $0x3,%eax
  800679:	01 c8                	add    %ecx,%eax
  80067b:	8a 40 04             	mov    0x4(%eax),%al
  80067e:	3c 01                	cmp    $0x1,%al
  800680:	75 03                	jne    800685 <CheckWSWithoutLastIndex+0x13d>
			actualNumOfEmptyLocs++;
  800682:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800685:	ff 45 e0             	incl   -0x20(%ebp)
  800688:	a1 20 40 80 00       	mov    0x804020,%eax
  80068d:	8b 50 74             	mov    0x74(%eax),%edx
  800690:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800693:	39 c2                	cmp    %eax,%edx
  800695:	77 cb                	ja     800662 <CheckWSWithoutLastIndex+0x11a>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  800697:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80069a:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  80069d:	74 14                	je     8006b3 <CheckWSWithoutLastIndex+0x16b>
		panic(
  80069f:	83 ec 04             	sub    $0x4,%esp
  8006a2:	68 8c 37 80 00       	push   $0x80378c
  8006a7:	6a 44                	push   $0x44
  8006a9:	68 2c 37 80 00       	push   $0x80372c
  8006ae:	e8 23 fe ff ff       	call   8004d6 <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  8006b3:	90                   	nop
  8006b4:	c9                   	leave  
  8006b5:	c3                   	ret    

008006b6 <putch>:
};

//2017:
uint8 printProgName = 0;

static void putch(int ch, struct printbuf *b) {
  8006b6:	55                   	push   %ebp
  8006b7:	89 e5                	mov    %esp,%ebp
  8006b9:	83 ec 08             	sub    $0x8,%esp
	b->buf[b->idx++] = ch;
  8006bc:	8b 45 0c             	mov    0xc(%ebp),%eax
  8006bf:	8b 00                	mov    (%eax),%eax
  8006c1:	8d 48 01             	lea    0x1(%eax),%ecx
  8006c4:	8b 55 0c             	mov    0xc(%ebp),%edx
  8006c7:	89 0a                	mov    %ecx,(%edx)
  8006c9:	8b 55 08             	mov    0x8(%ebp),%edx
  8006cc:	88 d1                	mov    %dl,%cl
  8006ce:	8b 55 0c             	mov    0xc(%ebp),%edx
  8006d1:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  8006d5:	8b 45 0c             	mov    0xc(%ebp),%eax
  8006d8:	8b 00                	mov    (%eax),%eax
  8006da:	3d ff 00 00 00       	cmp    $0xff,%eax
  8006df:	75 2c                	jne    80070d <putch+0x57>
		sys_cputs(b->buf, b->idx, printProgName);
  8006e1:	a0 24 40 80 00       	mov    0x804024,%al
  8006e6:	0f b6 c0             	movzbl %al,%eax
  8006e9:	8b 55 0c             	mov    0xc(%ebp),%edx
  8006ec:	8b 12                	mov    (%edx),%edx
  8006ee:	89 d1                	mov    %edx,%ecx
  8006f0:	8b 55 0c             	mov    0xc(%ebp),%edx
  8006f3:	83 c2 08             	add    $0x8,%edx
  8006f6:	83 ec 04             	sub    $0x4,%esp
  8006f9:	50                   	push   %eax
  8006fa:	51                   	push   %ecx
  8006fb:	52                   	push   %edx
  8006fc:	e8 66 13 00 00       	call   801a67 <sys_cputs>
  800701:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  800704:	8b 45 0c             	mov    0xc(%ebp),%eax
  800707:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  80070d:	8b 45 0c             	mov    0xc(%ebp),%eax
  800710:	8b 40 04             	mov    0x4(%eax),%eax
  800713:	8d 50 01             	lea    0x1(%eax),%edx
  800716:	8b 45 0c             	mov    0xc(%ebp),%eax
  800719:	89 50 04             	mov    %edx,0x4(%eax)
}
  80071c:	90                   	nop
  80071d:	c9                   	leave  
  80071e:	c3                   	ret    

0080071f <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  80071f:	55                   	push   %ebp
  800720:	89 e5                	mov    %esp,%ebp
  800722:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  800728:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  80072f:	00 00 00 
	b.cnt = 0;
  800732:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  800739:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  80073c:	ff 75 0c             	pushl  0xc(%ebp)
  80073f:	ff 75 08             	pushl  0x8(%ebp)
  800742:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800748:	50                   	push   %eax
  800749:	68 b6 06 80 00       	push   $0x8006b6
  80074e:	e8 11 02 00 00       	call   800964 <vprintfmt>
  800753:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName);
  800756:	a0 24 40 80 00       	mov    0x804024,%al
  80075b:	0f b6 c0             	movzbl %al,%eax
  80075e:	8b 95 f0 fe ff ff    	mov    -0x110(%ebp),%edx
  800764:	83 ec 04             	sub    $0x4,%esp
  800767:	50                   	push   %eax
  800768:	52                   	push   %edx
  800769:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  80076f:	83 c0 08             	add    $0x8,%eax
  800772:	50                   	push   %eax
  800773:	e8 ef 12 00 00       	call   801a67 <sys_cputs>
  800778:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  80077b:	c6 05 24 40 80 00 00 	movb   $0x0,0x804024
	return b.cnt;
  800782:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  800788:	c9                   	leave  
  800789:	c3                   	ret    

0080078a <cprintf>:

int cprintf(const char *fmt, ...) {
  80078a:	55                   	push   %ebp
  80078b:	89 e5                	mov    %esp,%ebp
  80078d:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  800790:	c6 05 24 40 80 00 01 	movb   $0x1,0x804024
	va_start(ap, fmt);
  800797:	8d 45 0c             	lea    0xc(%ebp),%eax
  80079a:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  80079d:	8b 45 08             	mov    0x8(%ebp),%eax
  8007a0:	83 ec 08             	sub    $0x8,%esp
  8007a3:	ff 75 f4             	pushl  -0xc(%ebp)
  8007a6:	50                   	push   %eax
  8007a7:	e8 73 ff ff ff       	call   80071f <vcprintf>
  8007ac:	83 c4 10             	add    $0x10,%esp
  8007af:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  8007b2:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8007b5:	c9                   	leave  
  8007b6:	c3                   	ret    

008007b7 <atomic_cprintf>:

int atomic_cprintf(const char *fmt, ...) {
  8007b7:	55                   	push   %ebp
  8007b8:	89 e5                	mov    %esp,%ebp
  8007ba:	83 ec 18             	sub    $0x18,%esp
	sys_disable_interrupt();
  8007bd:	e8 53 14 00 00       	call   801c15 <sys_disable_interrupt>
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  8007c2:	8d 45 0c             	lea    0xc(%ebp),%eax
  8007c5:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  8007c8:	8b 45 08             	mov    0x8(%ebp),%eax
  8007cb:	83 ec 08             	sub    $0x8,%esp
  8007ce:	ff 75 f4             	pushl  -0xc(%ebp)
  8007d1:	50                   	push   %eax
  8007d2:	e8 48 ff ff ff       	call   80071f <vcprintf>
  8007d7:	83 c4 10             	add    $0x10,%esp
  8007da:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	sys_enable_interrupt();
  8007dd:	e8 4d 14 00 00       	call   801c2f <sys_enable_interrupt>
	return cnt;
  8007e2:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8007e5:	c9                   	leave  
  8007e6:	c3                   	ret    

008007e7 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  8007e7:	55                   	push   %ebp
  8007e8:	89 e5                	mov    %esp,%ebp
  8007ea:	53                   	push   %ebx
  8007eb:	83 ec 14             	sub    $0x14,%esp
  8007ee:	8b 45 10             	mov    0x10(%ebp),%eax
  8007f1:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8007f4:	8b 45 14             	mov    0x14(%ebp),%eax
  8007f7:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  8007fa:	8b 45 18             	mov    0x18(%ebp),%eax
  8007fd:	ba 00 00 00 00       	mov    $0x0,%edx
  800802:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800805:	77 55                	ja     80085c <printnum+0x75>
  800807:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  80080a:	72 05                	jb     800811 <printnum+0x2a>
  80080c:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  80080f:	77 4b                	ja     80085c <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800811:	8b 45 1c             	mov    0x1c(%ebp),%eax
  800814:	8d 58 ff             	lea    -0x1(%eax),%ebx
  800817:	8b 45 18             	mov    0x18(%ebp),%eax
  80081a:	ba 00 00 00 00       	mov    $0x0,%edx
  80081f:	52                   	push   %edx
  800820:	50                   	push   %eax
  800821:	ff 75 f4             	pushl  -0xc(%ebp)
  800824:	ff 75 f0             	pushl  -0x10(%ebp)
  800827:	e8 84 28 00 00       	call   8030b0 <__udivdi3>
  80082c:	83 c4 10             	add    $0x10,%esp
  80082f:	83 ec 04             	sub    $0x4,%esp
  800832:	ff 75 20             	pushl  0x20(%ebp)
  800835:	53                   	push   %ebx
  800836:	ff 75 18             	pushl  0x18(%ebp)
  800839:	52                   	push   %edx
  80083a:	50                   	push   %eax
  80083b:	ff 75 0c             	pushl  0xc(%ebp)
  80083e:	ff 75 08             	pushl  0x8(%ebp)
  800841:	e8 a1 ff ff ff       	call   8007e7 <printnum>
  800846:	83 c4 20             	add    $0x20,%esp
  800849:	eb 1a                	jmp    800865 <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  80084b:	83 ec 08             	sub    $0x8,%esp
  80084e:	ff 75 0c             	pushl  0xc(%ebp)
  800851:	ff 75 20             	pushl  0x20(%ebp)
  800854:	8b 45 08             	mov    0x8(%ebp),%eax
  800857:	ff d0                	call   *%eax
  800859:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  80085c:	ff 4d 1c             	decl   0x1c(%ebp)
  80085f:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  800863:	7f e6                	jg     80084b <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800865:	8b 4d 18             	mov    0x18(%ebp),%ecx
  800868:	bb 00 00 00 00       	mov    $0x0,%ebx
  80086d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800870:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800873:	53                   	push   %ebx
  800874:	51                   	push   %ecx
  800875:	52                   	push   %edx
  800876:	50                   	push   %eax
  800877:	e8 44 29 00 00       	call   8031c0 <__umoddi3>
  80087c:	83 c4 10             	add    $0x10,%esp
  80087f:	05 f4 39 80 00       	add    $0x8039f4,%eax
  800884:	8a 00                	mov    (%eax),%al
  800886:	0f be c0             	movsbl %al,%eax
  800889:	83 ec 08             	sub    $0x8,%esp
  80088c:	ff 75 0c             	pushl  0xc(%ebp)
  80088f:	50                   	push   %eax
  800890:	8b 45 08             	mov    0x8(%ebp),%eax
  800893:	ff d0                	call   *%eax
  800895:	83 c4 10             	add    $0x10,%esp
}
  800898:	90                   	nop
  800899:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80089c:	c9                   	leave  
  80089d:	c3                   	ret    

0080089e <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  80089e:	55                   	push   %ebp
  80089f:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  8008a1:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  8008a5:	7e 1c                	jle    8008c3 <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  8008a7:	8b 45 08             	mov    0x8(%ebp),%eax
  8008aa:	8b 00                	mov    (%eax),%eax
  8008ac:	8d 50 08             	lea    0x8(%eax),%edx
  8008af:	8b 45 08             	mov    0x8(%ebp),%eax
  8008b2:	89 10                	mov    %edx,(%eax)
  8008b4:	8b 45 08             	mov    0x8(%ebp),%eax
  8008b7:	8b 00                	mov    (%eax),%eax
  8008b9:	83 e8 08             	sub    $0x8,%eax
  8008bc:	8b 50 04             	mov    0x4(%eax),%edx
  8008bf:	8b 00                	mov    (%eax),%eax
  8008c1:	eb 40                	jmp    800903 <getuint+0x65>
	else if (lflag)
  8008c3:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8008c7:	74 1e                	je     8008e7 <getuint+0x49>
		return va_arg(*ap, unsigned long);
  8008c9:	8b 45 08             	mov    0x8(%ebp),%eax
  8008cc:	8b 00                	mov    (%eax),%eax
  8008ce:	8d 50 04             	lea    0x4(%eax),%edx
  8008d1:	8b 45 08             	mov    0x8(%ebp),%eax
  8008d4:	89 10                	mov    %edx,(%eax)
  8008d6:	8b 45 08             	mov    0x8(%ebp),%eax
  8008d9:	8b 00                	mov    (%eax),%eax
  8008db:	83 e8 04             	sub    $0x4,%eax
  8008de:	8b 00                	mov    (%eax),%eax
  8008e0:	ba 00 00 00 00       	mov    $0x0,%edx
  8008e5:	eb 1c                	jmp    800903 <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  8008e7:	8b 45 08             	mov    0x8(%ebp),%eax
  8008ea:	8b 00                	mov    (%eax),%eax
  8008ec:	8d 50 04             	lea    0x4(%eax),%edx
  8008ef:	8b 45 08             	mov    0x8(%ebp),%eax
  8008f2:	89 10                	mov    %edx,(%eax)
  8008f4:	8b 45 08             	mov    0x8(%ebp),%eax
  8008f7:	8b 00                	mov    (%eax),%eax
  8008f9:	83 e8 04             	sub    $0x4,%eax
  8008fc:	8b 00                	mov    (%eax),%eax
  8008fe:	ba 00 00 00 00       	mov    $0x0,%edx
}
  800903:	5d                   	pop    %ebp
  800904:	c3                   	ret    

00800905 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  800905:	55                   	push   %ebp
  800906:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800908:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  80090c:	7e 1c                	jle    80092a <getint+0x25>
		return va_arg(*ap, long long);
  80090e:	8b 45 08             	mov    0x8(%ebp),%eax
  800911:	8b 00                	mov    (%eax),%eax
  800913:	8d 50 08             	lea    0x8(%eax),%edx
  800916:	8b 45 08             	mov    0x8(%ebp),%eax
  800919:	89 10                	mov    %edx,(%eax)
  80091b:	8b 45 08             	mov    0x8(%ebp),%eax
  80091e:	8b 00                	mov    (%eax),%eax
  800920:	83 e8 08             	sub    $0x8,%eax
  800923:	8b 50 04             	mov    0x4(%eax),%edx
  800926:	8b 00                	mov    (%eax),%eax
  800928:	eb 38                	jmp    800962 <getint+0x5d>
	else if (lflag)
  80092a:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80092e:	74 1a                	je     80094a <getint+0x45>
		return va_arg(*ap, long);
  800930:	8b 45 08             	mov    0x8(%ebp),%eax
  800933:	8b 00                	mov    (%eax),%eax
  800935:	8d 50 04             	lea    0x4(%eax),%edx
  800938:	8b 45 08             	mov    0x8(%ebp),%eax
  80093b:	89 10                	mov    %edx,(%eax)
  80093d:	8b 45 08             	mov    0x8(%ebp),%eax
  800940:	8b 00                	mov    (%eax),%eax
  800942:	83 e8 04             	sub    $0x4,%eax
  800945:	8b 00                	mov    (%eax),%eax
  800947:	99                   	cltd   
  800948:	eb 18                	jmp    800962 <getint+0x5d>
	else
		return va_arg(*ap, int);
  80094a:	8b 45 08             	mov    0x8(%ebp),%eax
  80094d:	8b 00                	mov    (%eax),%eax
  80094f:	8d 50 04             	lea    0x4(%eax),%edx
  800952:	8b 45 08             	mov    0x8(%ebp),%eax
  800955:	89 10                	mov    %edx,(%eax)
  800957:	8b 45 08             	mov    0x8(%ebp),%eax
  80095a:	8b 00                	mov    (%eax),%eax
  80095c:	83 e8 04             	sub    $0x4,%eax
  80095f:	8b 00                	mov    (%eax),%eax
  800961:	99                   	cltd   
}
  800962:	5d                   	pop    %ebp
  800963:	c3                   	ret    

00800964 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  800964:	55                   	push   %ebp
  800965:	89 e5                	mov    %esp,%ebp
  800967:	56                   	push   %esi
  800968:	53                   	push   %ebx
  800969:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  80096c:	eb 17                	jmp    800985 <vprintfmt+0x21>
			if (ch == '\0')
  80096e:	85 db                	test   %ebx,%ebx
  800970:	0f 84 af 03 00 00    	je     800d25 <vprintfmt+0x3c1>
				return;
			putch(ch, putdat);
  800976:	83 ec 08             	sub    $0x8,%esp
  800979:	ff 75 0c             	pushl  0xc(%ebp)
  80097c:	53                   	push   %ebx
  80097d:	8b 45 08             	mov    0x8(%ebp),%eax
  800980:	ff d0                	call   *%eax
  800982:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800985:	8b 45 10             	mov    0x10(%ebp),%eax
  800988:	8d 50 01             	lea    0x1(%eax),%edx
  80098b:	89 55 10             	mov    %edx,0x10(%ebp)
  80098e:	8a 00                	mov    (%eax),%al
  800990:	0f b6 d8             	movzbl %al,%ebx
  800993:	83 fb 25             	cmp    $0x25,%ebx
  800996:	75 d6                	jne    80096e <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  800998:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  80099c:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  8009a3:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  8009aa:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  8009b1:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8009b8:	8b 45 10             	mov    0x10(%ebp),%eax
  8009bb:	8d 50 01             	lea    0x1(%eax),%edx
  8009be:	89 55 10             	mov    %edx,0x10(%ebp)
  8009c1:	8a 00                	mov    (%eax),%al
  8009c3:	0f b6 d8             	movzbl %al,%ebx
  8009c6:	8d 43 dd             	lea    -0x23(%ebx),%eax
  8009c9:	83 f8 55             	cmp    $0x55,%eax
  8009cc:	0f 87 2b 03 00 00    	ja     800cfd <vprintfmt+0x399>
  8009d2:	8b 04 85 18 3a 80 00 	mov    0x803a18(,%eax,4),%eax
  8009d9:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  8009db:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  8009df:	eb d7                	jmp    8009b8 <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  8009e1:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  8009e5:	eb d1                	jmp    8009b8 <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8009e7:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  8009ee:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8009f1:	89 d0                	mov    %edx,%eax
  8009f3:	c1 e0 02             	shl    $0x2,%eax
  8009f6:	01 d0                	add    %edx,%eax
  8009f8:	01 c0                	add    %eax,%eax
  8009fa:	01 d8                	add    %ebx,%eax
  8009fc:	83 e8 30             	sub    $0x30,%eax
  8009ff:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  800a02:	8b 45 10             	mov    0x10(%ebp),%eax
  800a05:	8a 00                	mov    (%eax),%al
  800a07:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  800a0a:	83 fb 2f             	cmp    $0x2f,%ebx
  800a0d:	7e 3e                	jle    800a4d <vprintfmt+0xe9>
  800a0f:	83 fb 39             	cmp    $0x39,%ebx
  800a12:	7f 39                	jg     800a4d <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800a14:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  800a17:	eb d5                	jmp    8009ee <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  800a19:	8b 45 14             	mov    0x14(%ebp),%eax
  800a1c:	83 c0 04             	add    $0x4,%eax
  800a1f:	89 45 14             	mov    %eax,0x14(%ebp)
  800a22:	8b 45 14             	mov    0x14(%ebp),%eax
  800a25:	83 e8 04             	sub    $0x4,%eax
  800a28:	8b 00                	mov    (%eax),%eax
  800a2a:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  800a2d:	eb 1f                	jmp    800a4e <vprintfmt+0xea>

		case '.':
			if (width < 0)
  800a2f:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800a33:	79 83                	jns    8009b8 <vprintfmt+0x54>
				width = 0;
  800a35:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  800a3c:	e9 77 ff ff ff       	jmp    8009b8 <vprintfmt+0x54>

		case '#':
			altflag = 1;
  800a41:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  800a48:	e9 6b ff ff ff       	jmp    8009b8 <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  800a4d:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  800a4e:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800a52:	0f 89 60 ff ff ff    	jns    8009b8 <vprintfmt+0x54>
				width = precision, precision = -1;
  800a58:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800a5b:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800a5e:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  800a65:	e9 4e ff ff ff       	jmp    8009b8 <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  800a6a:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  800a6d:	e9 46 ff ff ff       	jmp    8009b8 <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  800a72:	8b 45 14             	mov    0x14(%ebp),%eax
  800a75:	83 c0 04             	add    $0x4,%eax
  800a78:	89 45 14             	mov    %eax,0x14(%ebp)
  800a7b:	8b 45 14             	mov    0x14(%ebp),%eax
  800a7e:	83 e8 04             	sub    $0x4,%eax
  800a81:	8b 00                	mov    (%eax),%eax
  800a83:	83 ec 08             	sub    $0x8,%esp
  800a86:	ff 75 0c             	pushl  0xc(%ebp)
  800a89:	50                   	push   %eax
  800a8a:	8b 45 08             	mov    0x8(%ebp),%eax
  800a8d:	ff d0                	call   *%eax
  800a8f:	83 c4 10             	add    $0x10,%esp
			break;
  800a92:	e9 89 02 00 00       	jmp    800d20 <vprintfmt+0x3bc>

		// error message
		case 'e':
			err = va_arg(ap, int);
  800a97:	8b 45 14             	mov    0x14(%ebp),%eax
  800a9a:	83 c0 04             	add    $0x4,%eax
  800a9d:	89 45 14             	mov    %eax,0x14(%ebp)
  800aa0:	8b 45 14             	mov    0x14(%ebp),%eax
  800aa3:	83 e8 04             	sub    $0x4,%eax
  800aa6:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  800aa8:	85 db                	test   %ebx,%ebx
  800aaa:	79 02                	jns    800aae <vprintfmt+0x14a>
				err = -err;
  800aac:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  800aae:	83 fb 64             	cmp    $0x64,%ebx
  800ab1:	7f 0b                	jg     800abe <vprintfmt+0x15a>
  800ab3:	8b 34 9d 60 38 80 00 	mov    0x803860(,%ebx,4),%esi
  800aba:	85 f6                	test   %esi,%esi
  800abc:	75 19                	jne    800ad7 <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  800abe:	53                   	push   %ebx
  800abf:	68 05 3a 80 00       	push   $0x803a05
  800ac4:	ff 75 0c             	pushl  0xc(%ebp)
  800ac7:	ff 75 08             	pushl  0x8(%ebp)
  800aca:	e8 5e 02 00 00       	call   800d2d <printfmt>
  800acf:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  800ad2:	e9 49 02 00 00       	jmp    800d20 <vprintfmt+0x3bc>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  800ad7:	56                   	push   %esi
  800ad8:	68 0e 3a 80 00       	push   $0x803a0e
  800add:	ff 75 0c             	pushl  0xc(%ebp)
  800ae0:	ff 75 08             	pushl  0x8(%ebp)
  800ae3:	e8 45 02 00 00       	call   800d2d <printfmt>
  800ae8:	83 c4 10             	add    $0x10,%esp
			break;
  800aeb:	e9 30 02 00 00       	jmp    800d20 <vprintfmt+0x3bc>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  800af0:	8b 45 14             	mov    0x14(%ebp),%eax
  800af3:	83 c0 04             	add    $0x4,%eax
  800af6:	89 45 14             	mov    %eax,0x14(%ebp)
  800af9:	8b 45 14             	mov    0x14(%ebp),%eax
  800afc:	83 e8 04             	sub    $0x4,%eax
  800aff:	8b 30                	mov    (%eax),%esi
  800b01:	85 f6                	test   %esi,%esi
  800b03:	75 05                	jne    800b0a <vprintfmt+0x1a6>
				p = "(null)";
  800b05:	be 11 3a 80 00       	mov    $0x803a11,%esi
			if (width > 0 && padc != '-')
  800b0a:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800b0e:	7e 6d                	jle    800b7d <vprintfmt+0x219>
  800b10:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  800b14:	74 67                	je     800b7d <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  800b16:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800b19:	83 ec 08             	sub    $0x8,%esp
  800b1c:	50                   	push   %eax
  800b1d:	56                   	push   %esi
  800b1e:	e8 0c 03 00 00       	call   800e2f <strnlen>
  800b23:	83 c4 10             	add    $0x10,%esp
  800b26:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  800b29:	eb 16                	jmp    800b41 <vprintfmt+0x1dd>
					putch(padc, putdat);
  800b2b:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  800b2f:	83 ec 08             	sub    $0x8,%esp
  800b32:	ff 75 0c             	pushl  0xc(%ebp)
  800b35:	50                   	push   %eax
  800b36:	8b 45 08             	mov    0x8(%ebp),%eax
  800b39:	ff d0                	call   *%eax
  800b3b:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800b3e:	ff 4d e4             	decl   -0x1c(%ebp)
  800b41:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800b45:	7f e4                	jg     800b2b <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800b47:	eb 34                	jmp    800b7d <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  800b49:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  800b4d:	74 1c                	je     800b6b <vprintfmt+0x207>
  800b4f:	83 fb 1f             	cmp    $0x1f,%ebx
  800b52:	7e 05                	jle    800b59 <vprintfmt+0x1f5>
  800b54:	83 fb 7e             	cmp    $0x7e,%ebx
  800b57:	7e 12                	jle    800b6b <vprintfmt+0x207>
					putch('?', putdat);
  800b59:	83 ec 08             	sub    $0x8,%esp
  800b5c:	ff 75 0c             	pushl  0xc(%ebp)
  800b5f:	6a 3f                	push   $0x3f
  800b61:	8b 45 08             	mov    0x8(%ebp),%eax
  800b64:	ff d0                	call   *%eax
  800b66:	83 c4 10             	add    $0x10,%esp
  800b69:	eb 0f                	jmp    800b7a <vprintfmt+0x216>
				else
					putch(ch, putdat);
  800b6b:	83 ec 08             	sub    $0x8,%esp
  800b6e:	ff 75 0c             	pushl  0xc(%ebp)
  800b71:	53                   	push   %ebx
  800b72:	8b 45 08             	mov    0x8(%ebp),%eax
  800b75:	ff d0                	call   *%eax
  800b77:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800b7a:	ff 4d e4             	decl   -0x1c(%ebp)
  800b7d:	89 f0                	mov    %esi,%eax
  800b7f:	8d 70 01             	lea    0x1(%eax),%esi
  800b82:	8a 00                	mov    (%eax),%al
  800b84:	0f be d8             	movsbl %al,%ebx
  800b87:	85 db                	test   %ebx,%ebx
  800b89:	74 24                	je     800baf <vprintfmt+0x24b>
  800b8b:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800b8f:	78 b8                	js     800b49 <vprintfmt+0x1e5>
  800b91:	ff 4d e0             	decl   -0x20(%ebp)
  800b94:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800b98:	79 af                	jns    800b49 <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800b9a:	eb 13                	jmp    800baf <vprintfmt+0x24b>
				putch(' ', putdat);
  800b9c:	83 ec 08             	sub    $0x8,%esp
  800b9f:	ff 75 0c             	pushl  0xc(%ebp)
  800ba2:	6a 20                	push   $0x20
  800ba4:	8b 45 08             	mov    0x8(%ebp),%eax
  800ba7:	ff d0                	call   *%eax
  800ba9:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800bac:	ff 4d e4             	decl   -0x1c(%ebp)
  800baf:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800bb3:	7f e7                	jg     800b9c <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  800bb5:	e9 66 01 00 00       	jmp    800d20 <vprintfmt+0x3bc>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  800bba:	83 ec 08             	sub    $0x8,%esp
  800bbd:	ff 75 e8             	pushl  -0x18(%ebp)
  800bc0:	8d 45 14             	lea    0x14(%ebp),%eax
  800bc3:	50                   	push   %eax
  800bc4:	e8 3c fd ff ff       	call   800905 <getint>
  800bc9:	83 c4 10             	add    $0x10,%esp
  800bcc:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800bcf:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  800bd2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800bd5:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800bd8:	85 d2                	test   %edx,%edx
  800bda:	79 23                	jns    800bff <vprintfmt+0x29b>
				putch('-', putdat);
  800bdc:	83 ec 08             	sub    $0x8,%esp
  800bdf:	ff 75 0c             	pushl  0xc(%ebp)
  800be2:	6a 2d                	push   $0x2d
  800be4:	8b 45 08             	mov    0x8(%ebp),%eax
  800be7:	ff d0                	call   *%eax
  800be9:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  800bec:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800bef:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800bf2:	f7 d8                	neg    %eax
  800bf4:	83 d2 00             	adc    $0x0,%edx
  800bf7:	f7 da                	neg    %edx
  800bf9:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800bfc:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  800bff:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800c06:	e9 bc 00 00 00       	jmp    800cc7 <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  800c0b:	83 ec 08             	sub    $0x8,%esp
  800c0e:	ff 75 e8             	pushl  -0x18(%ebp)
  800c11:	8d 45 14             	lea    0x14(%ebp),%eax
  800c14:	50                   	push   %eax
  800c15:	e8 84 fc ff ff       	call   80089e <getuint>
  800c1a:	83 c4 10             	add    $0x10,%esp
  800c1d:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800c20:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  800c23:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800c2a:	e9 98 00 00 00       	jmp    800cc7 <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  800c2f:	83 ec 08             	sub    $0x8,%esp
  800c32:	ff 75 0c             	pushl  0xc(%ebp)
  800c35:	6a 58                	push   $0x58
  800c37:	8b 45 08             	mov    0x8(%ebp),%eax
  800c3a:	ff d0                	call   *%eax
  800c3c:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800c3f:	83 ec 08             	sub    $0x8,%esp
  800c42:	ff 75 0c             	pushl  0xc(%ebp)
  800c45:	6a 58                	push   $0x58
  800c47:	8b 45 08             	mov    0x8(%ebp),%eax
  800c4a:	ff d0                	call   *%eax
  800c4c:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800c4f:	83 ec 08             	sub    $0x8,%esp
  800c52:	ff 75 0c             	pushl  0xc(%ebp)
  800c55:	6a 58                	push   $0x58
  800c57:	8b 45 08             	mov    0x8(%ebp),%eax
  800c5a:	ff d0                	call   *%eax
  800c5c:	83 c4 10             	add    $0x10,%esp
			break;
  800c5f:	e9 bc 00 00 00       	jmp    800d20 <vprintfmt+0x3bc>

		// pointer
		case 'p':
			putch('0', putdat);
  800c64:	83 ec 08             	sub    $0x8,%esp
  800c67:	ff 75 0c             	pushl  0xc(%ebp)
  800c6a:	6a 30                	push   $0x30
  800c6c:	8b 45 08             	mov    0x8(%ebp),%eax
  800c6f:	ff d0                	call   *%eax
  800c71:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  800c74:	83 ec 08             	sub    $0x8,%esp
  800c77:	ff 75 0c             	pushl  0xc(%ebp)
  800c7a:	6a 78                	push   $0x78
  800c7c:	8b 45 08             	mov    0x8(%ebp),%eax
  800c7f:	ff d0                	call   *%eax
  800c81:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  800c84:	8b 45 14             	mov    0x14(%ebp),%eax
  800c87:	83 c0 04             	add    $0x4,%eax
  800c8a:	89 45 14             	mov    %eax,0x14(%ebp)
  800c8d:	8b 45 14             	mov    0x14(%ebp),%eax
  800c90:	83 e8 04             	sub    $0x4,%eax
  800c93:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800c95:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800c98:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  800c9f:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  800ca6:	eb 1f                	jmp    800cc7 <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  800ca8:	83 ec 08             	sub    $0x8,%esp
  800cab:	ff 75 e8             	pushl  -0x18(%ebp)
  800cae:	8d 45 14             	lea    0x14(%ebp),%eax
  800cb1:	50                   	push   %eax
  800cb2:	e8 e7 fb ff ff       	call   80089e <getuint>
  800cb7:	83 c4 10             	add    $0x10,%esp
  800cba:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800cbd:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  800cc0:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800cc7:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  800ccb:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800cce:	83 ec 04             	sub    $0x4,%esp
  800cd1:	52                   	push   %edx
  800cd2:	ff 75 e4             	pushl  -0x1c(%ebp)
  800cd5:	50                   	push   %eax
  800cd6:	ff 75 f4             	pushl  -0xc(%ebp)
  800cd9:	ff 75 f0             	pushl  -0x10(%ebp)
  800cdc:	ff 75 0c             	pushl  0xc(%ebp)
  800cdf:	ff 75 08             	pushl  0x8(%ebp)
  800ce2:	e8 00 fb ff ff       	call   8007e7 <printnum>
  800ce7:	83 c4 20             	add    $0x20,%esp
			break;
  800cea:	eb 34                	jmp    800d20 <vprintfmt+0x3bc>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  800cec:	83 ec 08             	sub    $0x8,%esp
  800cef:	ff 75 0c             	pushl  0xc(%ebp)
  800cf2:	53                   	push   %ebx
  800cf3:	8b 45 08             	mov    0x8(%ebp),%eax
  800cf6:	ff d0                	call   *%eax
  800cf8:	83 c4 10             	add    $0x10,%esp
			break;
  800cfb:	eb 23                	jmp    800d20 <vprintfmt+0x3bc>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800cfd:	83 ec 08             	sub    $0x8,%esp
  800d00:	ff 75 0c             	pushl  0xc(%ebp)
  800d03:	6a 25                	push   $0x25
  800d05:	8b 45 08             	mov    0x8(%ebp),%eax
  800d08:	ff d0                	call   *%eax
  800d0a:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  800d0d:	ff 4d 10             	decl   0x10(%ebp)
  800d10:	eb 03                	jmp    800d15 <vprintfmt+0x3b1>
  800d12:	ff 4d 10             	decl   0x10(%ebp)
  800d15:	8b 45 10             	mov    0x10(%ebp),%eax
  800d18:	48                   	dec    %eax
  800d19:	8a 00                	mov    (%eax),%al
  800d1b:	3c 25                	cmp    $0x25,%al
  800d1d:	75 f3                	jne    800d12 <vprintfmt+0x3ae>
				/* do nothing */;
			break;
  800d1f:	90                   	nop
		}
	}
  800d20:	e9 47 fc ff ff       	jmp    80096c <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  800d25:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  800d26:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800d29:	5b                   	pop    %ebx
  800d2a:	5e                   	pop    %esi
  800d2b:	5d                   	pop    %ebp
  800d2c:	c3                   	ret    

00800d2d <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800d2d:	55                   	push   %ebp
  800d2e:	89 e5                	mov    %esp,%ebp
  800d30:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  800d33:	8d 45 10             	lea    0x10(%ebp),%eax
  800d36:	83 c0 04             	add    $0x4,%eax
  800d39:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  800d3c:	8b 45 10             	mov    0x10(%ebp),%eax
  800d3f:	ff 75 f4             	pushl  -0xc(%ebp)
  800d42:	50                   	push   %eax
  800d43:	ff 75 0c             	pushl  0xc(%ebp)
  800d46:	ff 75 08             	pushl  0x8(%ebp)
  800d49:	e8 16 fc ff ff       	call   800964 <vprintfmt>
  800d4e:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  800d51:	90                   	nop
  800d52:	c9                   	leave  
  800d53:	c3                   	ret    

00800d54 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800d54:	55                   	push   %ebp
  800d55:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  800d57:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d5a:	8b 40 08             	mov    0x8(%eax),%eax
  800d5d:	8d 50 01             	lea    0x1(%eax),%edx
  800d60:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d63:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  800d66:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d69:	8b 10                	mov    (%eax),%edx
  800d6b:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d6e:	8b 40 04             	mov    0x4(%eax),%eax
  800d71:	39 c2                	cmp    %eax,%edx
  800d73:	73 12                	jae    800d87 <sprintputch+0x33>
		*b->buf++ = ch;
  800d75:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d78:	8b 00                	mov    (%eax),%eax
  800d7a:	8d 48 01             	lea    0x1(%eax),%ecx
  800d7d:	8b 55 0c             	mov    0xc(%ebp),%edx
  800d80:	89 0a                	mov    %ecx,(%edx)
  800d82:	8b 55 08             	mov    0x8(%ebp),%edx
  800d85:	88 10                	mov    %dl,(%eax)
}
  800d87:	90                   	nop
  800d88:	5d                   	pop    %ebp
  800d89:	c3                   	ret    

00800d8a <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800d8a:	55                   	push   %ebp
  800d8b:	89 e5                	mov    %esp,%ebp
  800d8d:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  800d90:	8b 45 08             	mov    0x8(%ebp),%eax
  800d93:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800d96:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d99:	8d 50 ff             	lea    -0x1(%eax),%edx
  800d9c:	8b 45 08             	mov    0x8(%ebp),%eax
  800d9f:	01 d0                	add    %edx,%eax
  800da1:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800da4:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800dab:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800daf:	74 06                	je     800db7 <vsnprintf+0x2d>
  800db1:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800db5:	7f 07                	jg     800dbe <vsnprintf+0x34>
		return -E_INVAL;
  800db7:	b8 03 00 00 00       	mov    $0x3,%eax
  800dbc:	eb 20                	jmp    800dde <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800dbe:	ff 75 14             	pushl  0x14(%ebp)
  800dc1:	ff 75 10             	pushl  0x10(%ebp)
  800dc4:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800dc7:	50                   	push   %eax
  800dc8:	68 54 0d 80 00       	push   $0x800d54
  800dcd:	e8 92 fb ff ff       	call   800964 <vprintfmt>
  800dd2:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  800dd5:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800dd8:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800ddb:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  800dde:	c9                   	leave  
  800ddf:	c3                   	ret    

00800de0 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800de0:	55                   	push   %ebp
  800de1:	89 e5                	mov    %esp,%ebp
  800de3:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800de6:	8d 45 10             	lea    0x10(%ebp),%eax
  800de9:	83 c0 04             	add    $0x4,%eax
  800dec:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  800def:	8b 45 10             	mov    0x10(%ebp),%eax
  800df2:	ff 75 f4             	pushl  -0xc(%ebp)
  800df5:	50                   	push   %eax
  800df6:	ff 75 0c             	pushl  0xc(%ebp)
  800df9:	ff 75 08             	pushl  0x8(%ebp)
  800dfc:	e8 89 ff ff ff       	call   800d8a <vsnprintf>
  800e01:	83 c4 10             	add    $0x10,%esp
  800e04:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  800e07:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800e0a:	c9                   	leave  
  800e0b:	c3                   	ret    

00800e0c <strlen>:

#include <inc/string.h>

int
strlen(const char *s)
{
  800e0c:	55                   	push   %ebp
  800e0d:	89 e5                	mov    %esp,%ebp
  800e0f:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  800e12:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800e19:	eb 06                	jmp    800e21 <strlen+0x15>
		n++;
  800e1b:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  800e1e:	ff 45 08             	incl   0x8(%ebp)
  800e21:	8b 45 08             	mov    0x8(%ebp),%eax
  800e24:	8a 00                	mov    (%eax),%al
  800e26:	84 c0                	test   %al,%al
  800e28:	75 f1                	jne    800e1b <strlen+0xf>
		n++;
	return n;
  800e2a:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800e2d:	c9                   	leave  
  800e2e:	c3                   	ret    

00800e2f <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  800e2f:	55                   	push   %ebp
  800e30:	89 e5                	mov    %esp,%ebp
  800e32:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800e35:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800e3c:	eb 09                	jmp    800e47 <strnlen+0x18>
		n++;
  800e3e:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800e41:	ff 45 08             	incl   0x8(%ebp)
  800e44:	ff 4d 0c             	decl   0xc(%ebp)
  800e47:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800e4b:	74 09                	je     800e56 <strnlen+0x27>
  800e4d:	8b 45 08             	mov    0x8(%ebp),%eax
  800e50:	8a 00                	mov    (%eax),%al
  800e52:	84 c0                	test   %al,%al
  800e54:	75 e8                	jne    800e3e <strnlen+0xf>
		n++;
	return n;
  800e56:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800e59:	c9                   	leave  
  800e5a:	c3                   	ret    

00800e5b <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800e5b:	55                   	push   %ebp
  800e5c:	89 e5                	mov    %esp,%ebp
  800e5e:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  800e61:	8b 45 08             	mov    0x8(%ebp),%eax
  800e64:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  800e67:	90                   	nop
  800e68:	8b 45 08             	mov    0x8(%ebp),%eax
  800e6b:	8d 50 01             	lea    0x1(%eax),%edx
  800e6e:	89 55 08             	mov    %edx,0x8(%ebp)
  800e71:	8b 55 0c             	mov    0xc(%ebp),%edx
  800e74:	8d 4a 01             	lea    0x1(%edx),%ecx
  800e77:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800e7a:	8a 12                	mov    (%edx),%dl
  800e7c:	88 10                	mov    %dl,(%eax)
  800e7e:	8a 00                	mov    (%eax),%al
  800e80:	84 c0                	test   %al,%al
  800e82:	75 e4                	jne    800e68 <strcpy+0xd>
		/* do nothing */;
	return ret;
  800e84:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800e87:	c9                   	leave  
  800e88:	c3                   	ret    

00800e89 <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  800e89:	55                   	push   %ebp
  800e8a:	89 e5                	mov    %esp,%ebp
  800e8c:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  800e8f:	8b 45 08             	mov    0x8(%ebp),%eax
  800e92:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  800e95:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800e9c:	eb 1f                	jmp    800ebd <strncpy+0x34>
		*dst++ = *src;
  800e9e:	8b 45 08             	mov    0x8(%ebp),%eax
  800ea1:	8d 50 01             	lea    0x1(%eax),%edx
  800ea4:	89 55 08             	mov    %edx,0x8(%ebp)
  800ea7:	8b 55 0c             	mov    0xc(%ebp),%edx
  800eaa:	8a 12                	mov    (%edx),%dl
  800eac:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  800eae:	8b 45 0c             	mov    0xc(%ebp),%eax
  800eb1:	8a 00                	mov    (%eax),%al
  800eb3:	84 c0                	test   %al,%al
  800eb5:	74 03                	je     800eba <strncpy+0x31>
			src++;
  800eb7:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800eba:	ff 45 fc             	incl   -0x4(%ebp)
  800ebd:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800ec0:	3b 45 10             	cmp    0x10(%ebp),%eax
  800ec3:	72 d9                	jb     800e9e <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  800ec5:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  800ec8:	c9                   	leave  
  800ec9:	c3                   	ret    

00800eca <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  800eca:	55                   	push   %ebp
  800ecb:	89 e5                	mov    %esp,%ebp
  800ecd:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  800ed0:	8b 45 08             	mov    0x8(%ebp),%eax
  800ed3:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  800ed6:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800eda:	74 30                	je     800f0c <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  800edc:	eb 16                	jmp    800ef4 <strlcpy+0x2a>
			*dst++ = *src++;
  800ede:	8b 45 08             	mov    0x8(%ebp),%eax
  800ee1:	8d 50 01             	lea    0x1(%eax),%edx
  800ee4:	89 55 08             	mov    %edx,0x8(%ebp)
  800ee7:	8b 55 0c             	mov    0xc(%ebp),%edx
  800eea:	8d 4a 01             	lea    0x1(%edx),%ecx
  800eed:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800ef0:	8a 12                	mov    (%edx),%dl
  800ef2:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  800ef4:	ff 4d 10             	decl   0x10(%ebp)
  800ef7:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800efb:	74 09                	je     800f06 <strlcpy+0x3c>
  800efd:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f00:	8a 00                	mov    (%eax),%al
  800f02:	84 c0                	test   %al,%al
  800f04:	75 d8                	jne    800ede <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  800f06:	8b 45 08             	mov    0x8(%ebp),%eax
  800f09:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800f0c:	8b 55 08             	mov    0x8(%ebp),%edx
  800f0f:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800f12:	29 c2                	sub    %eax,%edx
  800f14:	89 d0                	mov    %edx,%eax
}
  800f16:	c9                   	leave  
  800f17:	c3                   	ret    

00800f18 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800f18:	55                   	push   %ebp
  800f19:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  800f1b:	eb 06                	jmp    800f23 <strcmp+0xb>
		p++, q++;
  800f1d:	ff 45 08             	incl   0x8(%ebp)
  800f20:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  800f23:	8b 45 08             	mov    0x8(%ebp),%eax
  800f26:	8a 00                	mov    (%eax),%al
  800f28:	84 c0                	test   %al,%al
  800f2a:	74 0e                	je     800f3a <strcmp+0x22>
  800f2c:	8b 45 08             	mov    0x8(%ebp),%eax
  800f2f:	8a 10                	mov    (%eax),%dl
  800f31:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f34:	8a 00                	mov    (%eax),%al
  800f36:	38 c2                	cmp    %al,%dl
  800f38:	74 e3                	je     800f1d <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800f3a:	8b 45 08             	mov    0x8(%ebp),%eax
  800f3d:	8a 00                	mov    (%eax),%al
  800f3f:	0f b6 d0             	movzbl %al,%edx
  800f42:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f45:	8a 00                	mov    (%eax),%al
  800f47:	0f b6 c0             	movzbl %al,%eax
  800f4a:	29 c2                	sub    %eax,%edx
  800f4c:	89 d0                	mov    %edx,%eax
}
  800f4e:	5d                   	pop    %ebp
  800f4f:	c3                   	ret    

00800f50 <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  800f50:	55                   	push   %ebp
  800f51:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  800f53:	eb 09                	jmp    800f5e <strncmp+0xe>
		n--, p++, q++;
  800f55:	ff 4d 10             	decl   0x10(%ebp)
  800f58:	ff 45 08             	incl   0x8(%ebp)
  800f5b:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  800f5e:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800f62:	74 17                	je     800f7b <strncmp+0x2b>
  800f64:	8b 45 08             	mov    0x8(%ebp),%eax
  800f67:	8a 00                	mov    (%eax),%al
  800f69:	84 c0                	test   %al,%al
  800f6b:	74 0e                	je     800f7b <strncmp+0x2b>
  800f6d:	8b 45 08             	mov    0x8(%ebp),%eax
  800f70:	8a 10                	mov    (%eax),%dl
  800f72:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f75:	8a 00                	mov    (%eax),%al
  800f77:	38 c2                	cmp    %al,%dl
  800f79:	74 da                	je     800f55 <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  800f7b:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800f7f:	75 07                	jne    800f88 <strncmp+0x38>
		return 0;
  800f81:	b8 00 00 00 00       	mov    $0x0,%eax
  800f86:	eb 14                	jmp    800f9c <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800f88:	8b 45 08             	mov    0x8(%ebp),%eax
  800f8b:	8a 00                	mov    (%eax),%al
  800f8d:	0f b6 d0             	movzbl %al,%edx
  800f90:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f93:	8a 00                	mov    (%eax),%al
  800f95:	0f b6 c0             	movzbl %al,%eax
  800f98:	29 c2                	sub    %eax,%edx
  800f9a:	89 d0                	mov    %edx,%eax
}
  800f9c:	5d                   	pop    %ebp
  800f9d:	c3                   	ret    

00800f9e <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800f9e:	55                   	push   %ebp
  800f9f:	89 e5                	mov    %esp,%ebp
  800fa1:	83 ec 04             	sub    $0x4,%esp
  800fa4:	8b 45 0c             	mov    0xc(%ebp),%eax
  800fa7:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800faa:	eb 12                	jmp    800fbe <strchr+0x20>
		if (*s == c)
  800fac:	8b 45 08             	mov    0x8(%ebp),%eax
  800faf:	8a 00                	mov    (%eax),%al
  800fb1:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800fb4:	75 05                	jne    800fbb <strchr+0x1d>
			return (char *) s;
  800fb6:	8b 45 08             	mov    0x8(%ebp),%eax
  800fb9:	eb 11                	jmp    800fcc <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  800fbb:	ff 45 08             	incl   0x8(%ebp)
  800fbe:	8b 45 08             	mov    0x8(%ebp),%eax
  800fc1:	8a 00                	mov    (%eax),%al
  800fc3:	84 c0                	test   %al,%al
  800fc5:	75 e5                	jne    800fac <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  800fc7:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800fcc:	c9                   	leave  
  800fcd:	c3                   	ret    

00800fce <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800fce:	55                   	push   %ebp
  800fcf:	89 e5                	mov    %esp,%ebp
  800fd1:	83 ec 04             	sub    $0x4,%esp
  800fd4:	8b 45 0c             	mov    0xc(%ebp),%eax
  800fd7:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800fda:	eb 0d                	jmp    800fe9 <strfind+0x1b>
		if (*s == c)
  800fdc:	8b 45 08             	mov    0x8(%ebp),%eax
  800fdf:	8a 00                	mov    (%eax),%al
  800fe1:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800fe4:	74 0e                	je     800ff4 <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  800fe6:	ff 45 08             	incl   0x8(%ebp)
  800fe9:	8b 45 08             	mov    0x8(%ebp),%eax
  800fec:	8a 00                	mov    (%eax),%al
  800fee:	84 c0                	test   %al,%al
  800ff0:	75 ea                	jne    800fdc <strfind+0xe>
  800ff2:	eb 01                	jmp    800ff5 <strfind+0x27>
		if (*s == c)
			break;
  800ff4:	90                   	nop
	return (char *) s;
  800ff5:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800ff8:	c9                   	leave  
  800ff9:	c3                   	ret    

00800ffa <memset>:


void *
memset(void *v, int c, uint32 n)
{
  800ffa:	55                   	push   %ebp
  800ffb:	89 e5                	mov    %esp,%ebp
  800ffd:	83 ec 10             	sub    $0x10,%esp
	char *p;
	int m;

	p = v;
  801000:	8b 45 08             	mov    0x8(%ebp),%eax
  801003:	89 45 fc             	mov    %eax,-0x4(%ebp)
	m = n;
  801006:	8b 45 10             	mov    0x10(%ebp),%eax
  801009:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (--m >= 0)
  80100c:	eb 0e                	jmp    80101c <memset+0x22>
		*p++ = c;
  80100e:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801011:	8d 50 01             	lea    0x1(%eax),%edx
  801014:	89 55 fc             	mov    %edx,-0x4(%ebp)
  801017:	8b 55 0c             	mov    0xc(%ebp),%edx
  80101a:	88 10                	mov    %dl,(%eax)
	char *p;
	int m;

	p = v;
	m = n;
	while (--m >= 0)
  80101c:	ff 4d f8             	decl   -0x8(%ebp)
  80101f:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
  801023:	79 e9                	jns    80100e <memset+0x14>
		*p++ = c;

	return v;
  801025:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801028:	c9                   	leave  
  801029:	c3                   	ret    

0080102a <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  80102a:	55                   	push   %ebp
  80102b:	89 e5                	mov    %esp,%ebp
  80102d:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  801030:	8b 45 0c             	mov    0xc(%ebp),%eax
  801033:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  801036:	8b 45 08             	mov    0x8(%ebp),%eax
  801039:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (n-- > 0)
  80103c:	eb 16                	jmp    801054 <memcpy+0x2a>
		*d++ = *s++;
  80103e:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801041:	8d 50 01             	lea    0x1(%eax),%edx
  801044:	89 55 f8             	mov    %edx,-0x8(%ebp)
  801047:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80104a:	8d 4a 01             	lea    0x1(%edx),%ecx
  80104d:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  801050:	8a 12                	mov    (%edx),%dl
  801052:	88 10                	mov    %dl,(%eax)
	const char *s;
	char *d;

	s = src;
	d = dst;
	while (n-- > 0)
  801054:	8b 45 10             	mov    0x10(%ebp),%eax
  801057:	8d 50 ff             	lea    -0x1(%eax),%edx
  80105a:	89 55 10             	mov    %edx,0x10(%ebp)
  80105d:	85 c0                	test   %eax,%eax
  80105f:	75 dd                	jne    80103e <memcpy+0x14>
		*d++ = *s++;

	return dst;
  801061:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801064:	c9                   	leave  
  801065:	c3                   	ret    

00801066 <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  801066:	55                   	push   %ebp
  801067:	89 e5                	mov    %esp,%ebp
  801069:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  80106c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80106f:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  801072:	8b 45 08             	mov    0x8(%ebp),%eax
  801075:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  801078:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80107b:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  80107e:	73 50                	jae    8010d0 <memmove+0x6a>
  801080:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801083:	8b 45 10             	mov    0x10(%ebp),%eax
  801086:	01 d0                	add    %edx,%eax
  801088:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  80108b:	76 43                	jbe    8010d0 <memmove+0x6a>
		s += n;
  80108d:	8b 45 10             	mov    0x10(%ebp),%eax
  801090:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  801093:	8b 45 10             	mov    0x10(%ebp),%eax
  801096:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  801099:	eb 10                	jmp    8010ab <memmove+0x45>
			*--d = *--s;
  80109b:	ff 4d f8             	decl   -0x8(%ebp)
  80109e:	ff 4d fc             	decl   -0x4(%ebp)
  8010a1:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8010a4:	8a 10                	mov    (%eax),%dl
  8010a6:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8010a9:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  8010ab:	8b 45 10             	mov    0x10(%ebp),%eax
  8010ae:	8d 50 ff             	lea    -0x1(%eax),%edx
  8010b1:	89 55 10             	mov    %edx,0x10(%ebp)
  8010b4:	85 c0                	test   %eax,%eax
  8010b6:	75 e3                	jne    80109b <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  8010b8:	eb 23                	jmp    8010dd <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  8010ba:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8010bd:	8d 50 01             	lea    0x1(%eax),%edx
  8010c0:	89 55 f8             	mov    %edx,-0x8(%ebp)
  8010c3:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8010c6:	8d 4a 01             	lea    0x1(%edx),%ecx
  8010c9:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  8010cc:	8a 12                	mov    (%edx),%dl
  8010ce:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  8010d0:	8b 45 10             	mov    0x10(%ebp),%eax
  8010d3:	8d 50 ff             	lea    -0x1(%eax),%edx
  8010d6:	89 55 10             	mov    %edx,0x10(%ebp)
  8010d9:	85 c0                	test   %eax,%eax
  8010db:	75 dd                	jne    8010ba <memmove+0x54>
			*d++ = *s++;

	return dst;
  8010dd:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8010e0:	c9                   	leave  
  8010e1:	c3                   	ret    

008010e2 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  8010e2:	55                   	push   %ebp
  8010e3:	89 e5                	mov    %esp,%ebp
  8010e5:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  8010e8:	8b 45 08             	mov    0x8(%ebp),%eax
  8010eb:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  8010ee:	8b 45 0c             	mov    0xc(%ebp),%eax
  8010f1:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  8010f4:	eb 2a                	jmp    801120 <memcmp+0x3e>
		if (*s1 != *s2)
  8010f6:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8010f9:	8a 10                	mov    (%eax),%dl
  8010fb:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8010fe:	8a 00                	mov    (%eax),%al
  801100:	38 c2                	cmp    %al,%dl
  801102:	74 16                	je     80111a <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  801104:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801107:	8a 00                	mov    (%eax),%al
  801109:	0f b6 d0             	movzbl %al,%edx
  80110c:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80110f:	8a 00                	mov    (%eax),%al
  801111:	0f b6 c0             	movzbl %al,%eax
  801114:	29 c2                	sub    %eax,%edx
  801116:	89 d0                	mov    %edx,%eax
  801118:	eb 18                	jmp    801132 <memcmp+0x50>
		s1++, s2++;
  80111a:	ff 45 fc             	incl   -0x4(%ebp)
  80111d:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  801120:	8b 45 10             	mov    0x10(%ebp),%eax
  801123:	8d 50 ff             	lea    -0x1(%eax),%edx
  801126:	89 55 10             	mov    %edx,0x10(%ebp)
  801129:	85 c0                	test   %eax,%eax
  80112b:	75 c9                	jne    8010f6 <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  80112d:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801132:	c9                   	leave  
  801133:	c3                   	ret    

00801134 <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  801134:	55                   	push   %ebp
  801135:	89 e5                	mov    %esp,%ebp
  801137:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  80113a:	8b 55 08             	mov    0x8(%ebp),%edx
  80113d:	8b 45 10             	mov    0x10(%ebp),%eax
  801140:	01 d0                	add    %edx,%eax
  801142:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  801145:	eb 15                	jmp    80115c <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  801147:	8b 45 08             	mov    0x8(%ebp),%eax
  80114a:	8a 00                	mov    (%eax),%al
  80114c:	0f b6 d0             	movzbl %al,%edx
  80114f:	8b 45 0c             	mov    0xc(%ebp),%eax
  801152:	0f b6 c0             	movzbl %al,%eax
  801155:	39 c2                	cmp    %eax,%edx
  801157:	74 0d                	je     801166 <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  801159:	ff 45 08             	incl   0x8(%ebp)
  80115c:	8b 45 08             	mov    0x8(%ebp),%eax
  80115f:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  801162:	72 e3                	jb     801147 <memfind+0x13>
  801164:	eb 01                	jmp    801167 <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  801166:	90                   	nop
	return (void *) s;
  801167:	8b 45 08             	mov    0x8(%ebp),%eax
}
  80116a:	c9                   	leave  
  80116b:	c3                   	ret    

0080116c <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  80116c:	55                   	push   %ebp
  80116d:	89 e5                	mov    %esp,%ebp
  80116f:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  801172:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  801179:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801180:	eb 03                	jmp    801185 <strtol+0x19>
		s++;
  801182:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801185:	8b 45 08             	mov    0x8(%ebp),%eax
  801188:	8a 00                	mov    (%eax),%al
  80118a:	3c 20                	cmp    $0x20,%al
  80118c:	74 f4                	je     801182 <strtol+0x16>
  80118e:	8b 45 08             	mov    0x8(%ebp),%eax
  801191:	8a 00                	mov    (%eax),%al
  801193:	3c 09                	cmp    $0x9,%al
  801195:	74 eb                	je     801182 <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  801197:	8b 45 08             	mov    0x8(%ebp),%eax
  80119a:	8a 00                	mov    (%eax),%al
  80119c:	3c 2b                	cmp    $0x2b,%al
  80119e:	75 05                	jne    8011a5 <strtol+0x39>
		s++;
  8011a0:	ff 45 08             	incl   0x8(%ebp)
  8011a3:	eb 13                	jmp    8011b8 <strtol+0x4c>
	else if (*s == '-')
  8011a5:	8b 45 08             	mov    0x8(%ebp),%eax
  8011a8:	8a 00                	mov    (%eax),%al
  8011aa:	3c 2d                	cmp    $0x2d,%al
  8011ac:	75 0a                	jne    8011b8 <strtol+0x4c>
		s++, neg = 1;
  8011ae:	ff 45 08             	incl   0x8(%ebp)
  8011b1:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  8011b8:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8011bc:	74 06                	je     8011c4 <strtol+0x58>
  8011be:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  8011c2:	75 20                	jne    8011e4 <strtol+0x78>
  8011c4:	8b 45 08             	mov    0x8(%ebp),%eax
  8011c7:	8a 00                	mov    (%eax),%al
  8011c9:	3c 30                	cmp    $0x30,%al
  8011cb:	75 17                	jne    8011e4 <strtol+0x78>
  8011cd:	8b 45 08             	mov    0x8(%ebp),%eax
  8011d0:	40                   	inc    %eax
  8011d1:	8a 00                	mov    (%eax),%al
  8011d3:	3c 78                	cmp    $0x78,%al
  8011d5:	75 0d                	jne    8011e4 <strtol+0x78>
		s += 2, base = 16;
  8011d7:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  8011db:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  8011e2:	eb 28                	jmp    80120c <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  8011e4:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8011e8:	75 15                	jne    8011ff <strtol+0x93>
  8011ea:	8b 45 08             	mov    0x8(%ebp),%eax
  8011ed:	8a 00                	mov    (%eax),%al
  8011ef:	3c 30                	cmp    $0x30,%al
  8011f1:	75 0c                	jne    8011ff <strtol+0x93>
		s++, base = 8;
  8011f3:	ff 45 08             	incl   0x8(%ebp)
  8011f6:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  8011fd:	eb 0d                	jmp    80120c <strtol+0xa0>
	else if (base == 0)
  8011ff:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801203:	75 07                	jne    80120c <strtol+0xa0>
		base = 10;
  801205:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  80120c:	8b 45 08             	mov    0x8(%ebp),%eax
  80120f:	8a 00                	mov    (%eax),%al
  801211:	3c 2f                	cmp    $0x2f,%al
  801213:	7e 19                	jle    80122e <strtol+0xc2>
  801215:	8b 45 08             	mov    0x8(%ebp),%eax
  801218:	8a 00                	mov    (%eax),%al
  80121a:	3c 39                	cmp    $0x39,%al
  80121c:	7f 10                	jg     80122e <strtol+0xc2>
			dig = *s - '0';
  80121e:	8b 45 08             	mov    0x8(%ebp),%eax
  801221:	8a 00                	mov    (%eax),%al
  801223:	0f be c0             	movsbl %al,%eax
  801226:	83 e8 30             	sub    $0x30,%eax
  801229:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80122c:	eb 42                	jmp    801270 <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  80122e:	8b 45 08             	mov    0x8(%ebp),%eax
  801231:	8a 00                	mov    (%eax),%al
  801233:	3c 60                	cmp    $0x60,%al
  801235:	7e 19                	jle    801250 <strtol+0xe4>
  801237:	8b 45 08             	mov    0x8(%ebp),%eax
  80123a:	8a 00                	mov    (%eax),%al
  80123c:	3c 7a                	cmp    $0x7a,%al
  80123e:	7f 10                	jg     801250 <strtol+0xe4>
			dig = *s - 'a' + 10;
  801240:	8b 45 08             	mov    0x8(%ebp),%eax
  801243:	8a 00                	mov    (%eax),%al
  801245:	0f be c0             	movsbl %al,%eax
  801248:	83 e8 57             	sub    $0x57,%eax
  80124b:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80124e:	eb 20                	jmp    801270 <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  801250:	8b 45 08             	mov    0x8(%ebp),%eax
  801253:	8a 00                	mov    (%eax),%al
  801255:	3c 40                	cmp    $0x40,%al
  801257:	7e 39                	jle    801292 <strtol+0x126>
  801259:	8b 45 08             	mov    0x8(%ebp),%eax
  80125c:	8a 00                	mov    (%eax),%al
  80125e:	3c 5a                	cmp    $0x5a,%al
  801260:	7f 30                	jg     801292 <strtol+0x126>
			dig = *s - 'A' + 10;
  801262:	8b 45 08             	mov    0x8(%ebp),%eax
  801265:	8a 00                	mov    (%eax),%al
  801267:	0f be c0             	movsbl %al,%eax
  80126a:	83 e8 37             	sub    $0x37,%eax
  80126d:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  801270:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801273:	3b 45 10             	cmp    0x10(%ebp),%eax
  801276:	7d 19                	jge    801291 <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  801278:	ff 45 08             	incl   0x8(%ebp)
  80127b:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80127e:	0f af 45 10          	imul   0x10(%ebp),%eax
  801282:	89 c2                	mov    %eax,%edx
  801284:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801287:	01 d0                	add    %edx,%eax
  801289:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  80128c:	e9 7b ff ff ff       	jmp    80120c <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  801291:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  801292:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801296:	74 08                	je     8012a0 <strtol+0x134>
		*endptr = (char *) s;
  801298:	8b 45 0c             	mov    0xc(%ebp),%eax
  80129b:	8b 55 08             	mov    0x8(%ebp),%edx
  80129e:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  8012a0:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  8012a4:	74 07                	je     8012ad <strtol+0x141>
  8012a6:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8012a9:	f7 d8                	neg    %eax
  8012ab:	eb 03                	jmp    8012b0 <strtol+0x144>
  8012ad:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  8012b0:	c9                   	leave  
  8012b1:	c3                   	ret    

008012b2 <ltostr>:

void
ltostr(long value, char *str)
{
  8012b2:	55                   	push   %ebp
  8012b3:	89 e5                	mov    %esp,%ebp
  8012b5:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  8012b8:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  8012bf:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  8012c6:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8012ca:	79 13                	jns    8012df <ltostr+0x2d>
	{
		neg = 1;
  8012cc:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  8012d3:	8b 45 0c             	mov    0xc(%ebp),%eax
  8012d6:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  8012d9:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  8012dc:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  8012df:	8b 45 08             	mov    0x8(%ebp),%eax
  8012e2:	b9 0a 00 00 00       	mov    $0xa,%ecx
  8012e7:	99                   	cltd   
  8012e8:	f7 f9                	idiv   %ecx
  8012ea:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  8012ed:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8012f0:	8d 50 01             	lea    0x1(%eax),%edx
  8012f3:	89 55 f8             	mov    %edx,-0x8(%ebp)
  8012f6:	89 c2                	mov    %eax,%edx
  8012f8:	8b 45 0c             	mov    0xc(%ebp),%eax
  8012fb:	01 d0                	add    %edx,%eax
  8012fd:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801300:	83 c2 30             	add    $0x30,%edx
  801303:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  801305:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801308:	b8 67 66 66 66       	mov    $0x66666667,%eax
  80130d:	f7 e9                	imul   %ecx
  80130f:	c1 fa 02             	sar    $0x2,%edx
  801312:	89 c8                	mov    %ecx,%eax
  801314:	c1 f8 1f             	sar    $0x1f,%eax
  801317:	29 c2                	sub    %eax,%edx
  801319:	89 d0                	mov    %edx,%eax
  80131b:	89 45 08             	mov    %eax,0x8(%ebp)
	} while (value % 10 != 0);
  80131e:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801321:	b8 67 66 66 66       	mov    $0x66666667,%eax
  801326:	f7 e9                	imul   %ecx
  801328:	c1 fa 02             	sar    $0x2,%edx
  80132b:	89 c8                	mov    %ecx,%eax
  80132d:	c1 f8 1f             	sar    $0x1f,%eax
  801330:	29 c2                	sub    %eax,%edx
  801332:	89 d0                	mov    %edx,%eax
  801334:	c1 e0 02             	shl    $0x2,%eax
  801337:	01 d0                	add    %edx,%eax
  801339:	01 c0                	add    %eax,%eax
  80133b:	29 c1                	sub    %eax,%ecx
  80133d:	89 ca                	mov    %ecx,%edx
  80133f:	85 d2                	test   %edx,%edx
  801341:	75 9c                	jne    8012df <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  801343:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  80134a:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80134d:	48                   	dec    %eax
  80134e:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  801351:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801355:	74 3d                	je     801394 <ltostr+0xe2>
		start = 1 ;
  801357:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  80135e:	eb 34                	jmp    801394 <ltostr+0xe2>
	{
		char tmp = str[start] ;
  801360:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801363:	8b 45 0c             	mov    0xc(%ebp),%eax
  801366:	01 d0                	add    %edx,%eax
  801368:	8a 00                	mov    (%eax),%al
  80136a:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  80136d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801370:	8b 45 0c             	mov    0xc(%ebp),%eax
  801373:	01 c2                	add    %eax,%edx
  801375:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  801378:	8b 45 0c             	mov    0xc(%ebp),%eax
  80137b:	01 c8                	add    %ecx,%eax
  80137d:	8a 00                	mov    (%eax),%al
  80137f:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  801381:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801384:	8b 45 0c             	mov    0xc(%ebp),%eax
  801387:	01 c2                	add    %eax,%edx
  801389:	8a 45 eb             	mov    -0x15(%ebp),%al
  80138c:	88 02                	mov    %al,(%edx)
		start++ ;
  80138e:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  801391:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  801394:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801397:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  80139a:	7c c4                	jl     801360 <ltostr+0xae>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  80139c:	8b 55 f8             	mov    -0x8(%ebp),%edx
  80139f:	8b 45 0c             	mov    0xc(%ebp),%eax
  8013a2:	01 d0                	add    %edx,%eax
  8013a4:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  8013a7:	90                   	nop
  8013a8:	c9                   	leave  
  8013a9:	c3                   	ret    

008013aa <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  8013aa:	55                   	push   %ebp
  8013ab:	89 e5                	mov    %esp,%ebp
  8013ad:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  8013b0:	ff 75 08             	pushl  0x8(%ebp)
  8013b3:	e8 54 fa ff ff       	call   800e0c <strlen>
  8013b8:	83 c4 04             	add    $0x4,%esp
  8013bb:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  8013be:	ff 75 0c             	pushl  0xc(%ebp)
  8013c1:	e8 46 fa ff ff       	call   800e0c <strlen>
  8013c6:	83 c4 04             	add    $0x4,%esp
  8013c9:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  8013cc:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  8013d3:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8013da:	eb 17                	jmp    8013f3 <strcconcat+0x49>
		final[s] = str1[s] ;
  8013dc:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8013df:	8b 45 10             	mov    0x10(%ebp),%eax
  8013e2:	01 c2                	add    %eax,%edx
  8013e4:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  8013e7:	8b 45 08             	mov    0x8(%ebp),%eax
  8013ea:	01 c8                	add    %ecx,%eax
  8013ec:	8a 00                	mov    (%eax),%al
  8013ee:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  8013f0:	ff 45 fc             	incl   -0x4(%ebp)
  8013f3:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8013f6:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  8013f9:	7c e1                	jl     8013dc <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  8013fb:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  801402:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  801409:	eb 1f                	jmp    80142a <strcconcat+0x80>
		final[s++] = str2[i] ;
  80140b:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80140e:	8d 50 01             	lea    0x1(%eax),%edx
  801411:	89 55 fc             	mov    %edx,-0x4(%ebp)
  801414:	89 c2                	mov    %eax,%edx
  801416:	8b 45 10             	mov    0x10(%ebp),%eax
  801419:	01 c2                	add    %eax,%edx
  80141b:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  80141e:	8b 45 0c             	mov    0xc(%ebp),%eax
  801421:	01 c8                	add    %ecx,%eax
  801423:	8a 00                	mov    (%eax),%al
  801425:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  801427:	ff 45 f8             	incl   -0x8(%ebp)
  80142a:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80142d:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801430:	7c d9                	jl     80140b <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  801432:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801435:	8b 45 10             	mov    0x10(%ebp),%eax
  801438:	01 d0                	add    %edx,%eax
  80143a:	c6 00 00             	movb   $0x0,(%eax)
}
  80143d:	90                   	nop
  80143e:	c9                   	leave  
  80143f:	c3                   	ret    

00801440 <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  801440:	55                   	push   %ebp
  801441:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  801443:	8b 45 14             	mov    0x14(%ebp),%eax
  801446:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  80144c:	8b 45 14             	mov    0x14(%ebp),%eax
  80144f:	8b 00                	mov    (%eax),%eax
  801451:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801458:	8b 45 10             	mov    0x10(%ebp),%eax
  80145b:	01 d0                	add    %edx,%eax
  80145d:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801463:	eb 0c                	jmp    801471 <strsplit+0x31>
			*string++ = 0;
  801465:	8b 45 08             	mov    0x8(%ebp),%eax
  801468:	8d 50 01             	lea    0x1(%eax),%edx
  80146b:	89 55 08             	mov    %edx,0x8(%ebp)
  80146e:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801471:	8b 45 08             	mov    0x8(%ebp),%eax
  801474:	8a 00                	mov    (%eax),%al
  801476:	84 c0                	test   %al,%al
  801478:	74 18                	je     801492 <strsplit+0x52>
  80147a:	8b 45 08             	mov    0x8(%ebp),%eax
  80147d:	8a 00                	mov    (%eax),%al
  80147f:	0f be c0             	movsbl %al,%eax
  801482:	50                   	push   %eax
  801483:	ff 75 0c             	pushl  0xc(%ebp)
  801486:	e8 13 fb ff ff       	call   800f9e <strchr>
  80148b:	83 c4 08             	add    $0x8,%esp
  80148e:	85 c0                	test   %eax,%eax
  801490:	75 d3                	jne    801465 <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  801492:	8b 45 08             	mov    0x8(%ebp),%eax
  801495:	8a 00                	mov    (%eax),%al
  801497:	84 c0                	test   %al,%al
  801499:	74 5a                	je     8014f5 <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  80149b:	8b 45 14             	mov    0x14(%ebp),%eax
  80149e:	8b 00                	mov    (%eax),%eax
  8014a0:	83 f8 0f             	cmp    $0xf,%eax
  8014a3:	75 07                	jne    8014ac <strsplit+0x6c>
		{
			return 0;
  8014a5:	b8 00 00 00 00       	mov    $0x0,%eax
  8014aa:	eb 66                	jmp    801512 <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  8014ac:	8b 45 14             	mov    0x14(%ebp),%eax
  8014af:	8b 00                	mov    (%eax),%eax
  8014b1:	8d 48 01             	lea    0x1(%eax),%ecx
  8014b4:	8b 55 14             	mov    0x14(%ebp),%edx
  8014b7:	89 0a                	mov    %ecx,(%edx)
  8014b9:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8014c0:	8b 45 10             	mov    0x10(%ebp),%eax
  8014c3:	01 c2                	add    %eax,%edx
  8014c5:	8b 45 08             	mov    0x8(%ebp),%eax
  8014c8:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  8014ca:	eb 03                	jmp    8014cf <strsplit+0x8f>
			string++;
  8014cc:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  8014cf:	8b 45 08             	mov    0x8(%ebp),%eax
  8014d2:	8a 00                	mov    (%eax),%al
  8014d4:	84 c0                	test   %al,%al
  8014d6:	74 8b                	je     801463 <strsplit+0x23>
  8014d8:	8b 45 08             	mov    0x8(%ebp),%eax
  8014db:	8a 00                	mov    (%eax),%al
  8014dd:	0f be c0             	movsbl %al,%eax
  8014e0:	50                   	push   %eax
  8014e1:	ff 75 0c             	pushl  0xc(%ebp)
  8014e4:	e8 b5 fa ff ff       	call   800f9e <strchr>
  8014e9:	83 c4 08             	add    $0x8,%esp
  8014ec:	85 c0                	test   %eax,%eax
  8014ee:	74 dc                	je     8014cc <strsplit+0x8c>
			string++;
	}
  8014f0:	e9 6e ff ff ff       	jmp    801463 <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  8014f5:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  8014f6:	8b 45 14             	mov    0x14(%ebp),%eax
  8014f9:	8b 00                	mov    (%eax),%eax
  8014fb:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801502:	8b 45 10             	mov    0x10(%ebp),%eax
  801505:	01 d0                	add    %edx,%eax
  801507:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  80150d:	b8 01 00 00 00       	mov    $0x1,%eax
}
  801512:	c9                   	leave  
  801513:	c3                   	ret    

00801514 <InitializeUHeap>:
//============================== GIVEN FUNCTIONS ===================================//
//==================================================================================//

int FirstTimeFlag = 1;
void InitializeUHeap()
{
  801514:	55                   	push   %ebp
  801515:	89 e5                	mov    %esp,%ebp
  801517:	83 ec 08             	sub    $0x8,%esp
	if(FirstTimeFlag)
  80151a:	a1 04 40 80 00       	mov    0x804004,%eax
  80151f:	85 c0                	test   %eax,%eax
  801521:	74 1f                	je     801542 <InitializeUHeap+0x2e>
	{
		initialize_dyn_block_system();
  801523:	e8 1d 00 00 00       	call   801545 <initialize_dyn_block_system>
		cprintf("DYNAMIC BLOCK SYSTEM IS INITIALIZED\n");
  801528:	83 ec 0c             	sub    $0xc,%esp
  80152b:	68 70 3b 80 00       	push   $0x803b70
  801530:	e8 55 f2 ff ff       	call   80078a <cprintf>
  801535:	83 c4 10             	add    $0x10,%esp
#if UHP_USE_BUDDY
		initialize_buddy();
		cprintf("BUDDY SYSTEM IS INITIALIZED\n");
#endif
		FirstTimeFlag = 0;
  801538:	c7 05 04 40 80 00 00 	movl   $0x0,0x804004
  80153f:	00 00 00 
	}
}
  801542:	90                   	nop
  801543:	c9                   	leave  
  801544:	c3                   	ret    

00801545 <initialize_dyn_block_system>:

//=================================
// [1] INITIALIZE DYNAMIC ALLOCATOR:
//=================================
void initialize_dyn_block_system()
{
  801545:	55                   	push   %ebp
  801546:	89 e5                	mov    %esp,%ebp
  801548:	83 ec 28             	sub    $0x28,%esp
	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] initialize_dyn_block_system
	// your code is here, remove the panic and write your code
	//panic("initialize_dyn_block_system() is not implemented yet...!!");

	LIST_INIT(&AllocMemBlocksList);
  80154b:	c7 05 40 40 80 00 00 	movl   $0x0,0x804040
  801552:	00 00 00 
  801555:	c7 05 44 40 80 00 00 	movl   $0x0,0x804044
  80155c:	00 00 00 
  80155f:	c7 05 4c 40 80 00 00 	movl   $0x0,0x80404c
  801566:	00 00 00 
	LIST_INIT(&FreeMemBlocksList);
  801569:	c7 05 38 41 80 00 00 	movl   $0x0,0x804138
  801570:	00 00 00 
  801573:	c7 05 3c 41 80 00 00 	movl   $0x0,0x80413c
  80157a:	00 00 00 
  80157d:	c7 05 44 41 80 00 00 	movl   $0x0,0x804144
  801584:	00 00 00 
	MAX_MEM_BLOCK_CNT = NUM_OF_UHEAP_PAGES;
  801587:	c7 05 20 41 80 00 00 	movl   $0x20000,0x804120
  80158e:	00 02 00 
	MemBlockNodes = (void*)USER_DYN_BLKS_ARRAY;
  801591:	c7 45 f4 00 00 e0 7f 	movl   $0x7fe00000,-0xc(%ebp)
  801598:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80159b:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8015a0:	2d 00 10 00 00       	sub    $0x1000,%eax
  8015a5:	a3 50 40 80 00       	mov    %eax,0x804050
	int size_of_block = sizeof(struct MemBlock);
  8015aa:	c7 45 f0 10 00 00 00 	movl   $0x10,-0x10(%ebp)
	int size_all_struct = size_of_block*MAX_MEM_BLOCK_CNT;
  8015b1:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8015b4:	a1 20 41 80 00       	mov    0x804120,%eax
  8015b9:	0f af c2             	imul   %edx,%eax
  8015bc:	89 45 ec             	mov    %eax,-0x14(%ebp)
	size_all_struct = ROUNDUP(size_all_struct, PAGE_SIZE);
  8015bf:	c7 45 e8 00 10 00 00 	movl   $0x1000,-0x18(%ebp)
  8015c6:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8015c9:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8015cc:	01 d0                	add    %edx,%eax
  8015ce:	48                   	dec    %eax
  8015cf:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8015d2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8015d5:	ba 00 00 00 00       	mov    $0x0,%edx
  8015da:	f7 75 e8             	divl   -0x18(%ebp)
  8015dd:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8015e0:	29 d0                	sub    %edx,%eax
  8015e2:	89 45 ec             	mov    %eax,-0x14(%ebp)
	sys_allocate_chunk(USER_DYN_BLKS_ARRAY, size_all_struct,PERM_USER| PERM_WRITEABLE);
  8015e5:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8015e8:	c7 45 e0 00 00 e0 7f 	movl   $0x7fe00000,-0x20(%ebp)
  8015ef:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8015f2:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
  8015f8:	81 ea 00 10 00 00    	sub    $0x1000,%edx
  8015fe:	83 ec 04             	sub    $0x4,%esp
  801601:	6a 06                	push   $0x6
  801603:	50                   	push   %eax
  801604:	52                   	push   %edx
  801605:	e8 a1 05 00 00       	call   801bab <sys_allocate_chunk>
  80160a:	83 c4 10             	add    $0x10,%esp
	initialize_MemBlocksList(MAX_MEM_BLOCK_CNT);
  80160d:	a1 20 41 80 00       	mov    0x804120,%eax
  801612:	83 ec 0c             	sub    $0xc,%esp
  801615:	50                   	push   %eax
  801616:	e8 16 0c 00 00       	call   802231 <initialize_MemBlocksList>
  80161b:	83 c4 10             	add    $0x10,%esp
	struct MemBlock* ourBlock =LIST_LAST(&AvailableMemBlocksList);
  80161e:	a1 4c 41 80 00       	mov    0x80414c,%eax
  801623:	89 45 dc             	mov    %eax,-0x24(%ebp)
	LIST_REMOVE(&AvailableMemBlocksList,ourBlock);
  801626:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  80162a:	75 14                	jne    801640 <initialize_dyn_block_system+0xfb>
  80162c:	83 ec 04             	sub    $0x4,%esp
  80162f:	68 95 3b 80 00       	push   $0x803b95
  801634:	6a 2d                	push   $0x2d
  801636:	68 b3 3b 80 00       	push   $0x803bb3
  80163b:	e8 96 ee ff ff       	call   8004d6 <_panic>
  801640:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801643:	8b 00                	mov    (%eax),%eax
  801645:	85 c0                	test   %eax,%eax
  801647:	74 10                	je     801659 <initialize_dyn_block_system+0x114>
  801649:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80164c:	8b 00                	mov    (%eax),%eax
  80164e:	8b 55 dc             	mov    -0x24(%ebp),%edx
  801651:	8b 52 04             	mov    0x4(%edx),%edx
  801654:	89 50 04             	mov    %edx,0x4(%eax)
  801657:	eb 0b                	jmp    801664 <initialize_dyn_block_system+0x11f>
  801659:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80165c:	8b 40 04             	mov    0x4(%eax),%eax
  80165f:	a3 4c 41 80 00       	mov    %eax,0x80414c
  801664:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801667:	8b 40 04             	mov    0x4(%eax),%eax
  80166a:	85 c0                	test   %eax,%eax
  80166c:	74 0f                	je     80167d <initialize_dyn_block_system+0x138>
  80166e:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801671:	8b 40 04             	mov    0x4(%eax),%eax
  801674:	8b 55 dc             	mov    -0x24(%ebp),%edx
  801677:	8b 12                	mov    (%edx),%edx
  801679:	89 10                	mov    %edx,(%eax)
  80167b:	eb 0a                	jmp    801687 <initialize_dyn_block_system+0x142>
  80167d:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801680:	8b 00                	mov    (%eax),%eax
  801682:	a3 48 41 80 00       	mov    %eax,0x804148
  801687:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80168a:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  801690:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801693:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80169a:	a1 54 41 80 00       	mov    0x804154,%eax
  80169f:	48                   	dec    %eax
  8016a0:	a3 54 41 80 00       	mov    %eax,0x804154
	ourBlock->size = USER_HEAP_MAX-USER_HEAP_START;
  8016a5:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8016a8:	c7 40 0c 00 00 00 20 	movl   $0x20000000,0xc(%eax)
	ourBlock->sva=USER_HEAP_START;
  8016af:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8016b2:	c7 40 08 00 00 00 80 	movl   $0x80000000,0x8(%eax)
	LIST_INSERT_TAIL(&FreeMemBlocksList, ourBlock);
  8016b9:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  8016bd:	75 14                	jne    8016d3 <initialize_dyn_block_system+0x18e>
  8016bf:	83 ec 04             	sub    $0x4,%esp
  8016c2:	68 c0 3b 80 00       	push   $0x803bc0
  8016c7:	6a 30                	push   $0x30
  8016c9:	68 b3 3b 80 00       	push   $0x803bb3
  8016ce:	e8 03 ee ff ff       	call   8004d6 <_panic>
  8016d3:	8b 15 3c 41 80 00    	mov    0x80413c,%edx
  8016d9:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8016dc:	89 50 04             	mov    %edx,0x4(%eax)
  8016df:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8016e2:	8b 40 04             	mov    0x4(%eax),%eax
  8016e5:	85 c0                	test   %eax,%eax
  8016e7:	74 0c                	je     8016f5 <initialize_dyn_block_system+0x1b0>
  8016e9:	a1 3c 41 80 00       	mov    0x80413c,%eax
  8016ee:	8b 55 dc             	mov    -0x24(%ebp),%edx
  8016f1:	89 10                	mov    %edx,(%eax)
  8016f3:	eb 08                	jmp    8016fd <initialize_dyn_block_system+0x1b8>
  8016f5:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8016f8:	a3 38 41 80 00       	mov    %eax,0x804138
  8016fd:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801700:	a3 3c 41 80 00       	mov    %eax,0x80413c
  801705:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801708:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80170e:	a1 44 41 80 00       	mov    0x804144,%eax
  801713:	40                   	inc    %eax
  801714:	a3 44 41 80 00       	mov    %eax,0x804144
	//[1] Initialize two lists (AllocMemBlocksList & FreeMemBlocksList) [Hint: use LIST_INIT()]
	//[2] Dynamically allocate the array of MemBlockNodes at VA USER_DYN_BLKS_ARRAY
	//	  (remember to set MAX_MEM_BLOCK_CNT with the chosen size of the array)
	//[3] Initialize AvailableMemBlocksList by filling it with the MemBlockNodes
	//[4] Insert a new MemBlock with the heap size into the FreeMemBlocksList
}
  801719:	90                   	nop
  80171a:	c9                   	leave  
  80171b:	c3                   	ret    

0080171c <malloc>:
//=================================
// [2] ALLOCATE SPACE IN USER HEAP:
//=================================

void* malloc(uint32 size)
{
  80171c:	55                   	push   %ebp
  80171d:	89 e5                	mov    %esp,%ebp
  80171f:	83 ec 18             	sub    $0x18,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801722:	e8 ed fd ff ff       	call   801514 <InitializeUHeap>
	if (size == 0) return NULL ;
  801727:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80172b:	75 07                	jne    801734 <malloc+0x18>
  80172d:	b8 00 00 00 00       	mov    $0x0,%eax
  801732:	eb 67                	jmp    80179b <malloc+0x7f>

	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] malloc
	// your code is here, remove the panic and write your code
	//panic("malloc() is not implemented yet...!!");

	size = ROUNDUP(size, PAGE_SIZE);
  801734:	c7 45 f4 00 10 00 00 	movl   $0x1000,-0xc(%ebp)
  80173b:	8b 55 08             	mov    0x8(%ebp),%edx
  80173e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801741:	01 d0                	add    %edx,%eax
  801743:	48                   	dec    %eax
  801744:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801747:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80174a:	ba 00 00 00 00       	mov    $0x0,%edx
  80174f:	f7 75 f4             	divl   -0xc(%ebp)
  801752:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801755:	29 d0                	sub    %edx,%eax
  801757:	89 45 08             	mov    %eax,0x8(%ebp)
	if(sys_isUHeapPlacementStrategyFIRSTFIT())
  80175a:	e8 1a 08 00 00       	call   801f79 <sys_isUHeapPlacementStrategyFIRSTFIT>
  80175f:	85 c0                	test   %eax,%eax
  801761:	74 33                	je     801796 <malloc+0x7a>
	{
		struct MemBlock * myBlock = alloc_block_FF(size);
  801763:	83 ec 0c             	sub    $0xc,%esp
  801766:	ff 75 08             	pushl  0x8(%ebp)
  801769:	e8 0c 0e 00 00       	call   80257a <alloc_block_FF>
  80176e:	83 c4 10             	add    $0x10,%esp
  801771:	89 45 ec             	mov    %eax,-0x14(%ebp)
		if(myBlock != NULL)
  801774:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  801778:	74 1c                	je     801796 <malloc+0x7a>
		{
			insert_sorted_allocList(myBlock);
  80177a:	83 ec 0c             	sub    $0xc,%esp
  80177d:	ff 75 ec             	pushl  -0x14(%ebp)
  801780:	e8 07 0c 00 00       	call   80238c <insert_sorted_allocList>
  801785:	83 c4 10             	add    $0x10,%esp
			uint32 ptr = myBlock->sva;
  801788:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80178b:	8b 40 08             	mov    0x8(%eax),%eax
  80178e:	89 45 e8             	mov    %eax,-0x18(%ebp)
			return (void *)ptr;
  801791:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801794:	eb 05                	jmp    80179b <malloc+0x7f>
		}
	}
	return NULL;
  801796:	b8 00 00 00 00       	mov    $0x0,%eax
	//		to the required allocation size (space should be on 4 KB BOUNDARY)
	//	2) if no suitable space found, return NULL
	// 	3) Return pointer containing the virtual address of allocated space,
	//
	//Use sys_isUHeapPlacementStrategyFIRSTFIT()... to check the current strategy
}
  80179b:	c9                   	leave  
  80179c:	c3                   	ret    

0080179d <free>:
//	We can use sys_free_user_mem(uint32 virtual_address, uint32 size); which
//		switches to the kernel mode, calls free_user_mem() in
//		"kern/mem/chunk_operations.c", then switch back to the user mode here
//	the free_user_mem function is empty, make sure to implement it.
void free(void* virtual_address)
{
  80179d:	55                   	push   %ebp
  80179e:	89 e5                	mov    %esp,%ebp
  8017a0:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] free
	// your code is here, remove the panic and write your code
	//panic("free() is not implemented yet...!!");

	uint32 virtualAddress = (uint32 )(virtual_address);
  8017a3:	8b 45 08             	mov    0x8(%ebp),%eax
  8017a6:	89 45 f4             	mov    %eax,-0xc(%ebp)
//	virtualAddress = ROUNDDOWN(virtualAddress, PAGE_SIZE);
	struct MemBlock * myBlock = find_block(&AllocMemBlocksList, virtualAddress);
  8017a9:	83 ec 08             	sub    $0x8,%esp
  8017ac:	ff 75 f4             	pushl  -0xc(%ebp)
  8017af:	68 40 40 80 00       	push   $0x804040
  8017b4:	e8 5b 0b 00 00       	call   802314 <find_block>
  8017b9:	83 c4 10             	add    $0x10,%esp
  8017bc:	89 45 f0             	mov    %eax,-0x10(%ebp)
//	cprintf ("ptr sva at free user side = %x \n", myBlock->sva);
	sys_free_user_mem(virtualAddress, myBlock->size);
  8017bf:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8017c2:	8b 40 0c             	mov    0xc(%eax),%eax
  8017c5:	83 ec 08             	sub    $0x8,%esp
  8017c8:	50                   	push   %eax
  8017c9:	ff 75 f4             	pushl  -0xc(%ebp)
  8017cc:	e8 a2 03 00 00       	call   801b73 <sys_free_user_mem>
  8017d1:	83 c4 10             	add    $0x10,%esp
	LIST_REMOVE(&AllocMemBlocksList, myBlock);
  8017d4:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8017d8:	75 14                	jne    8017ee <free+0x51>
  8017da:	83 ec 04             	sub    $0x4,%esp
  8017dd:	68 95 3b 80 00       	push   $0x803b95
  8017e2:	6a 76                	push   $0x76
  8017e4:	68 b3 3b 80 00       	push   $0x803bb3
  8017e9:	e8 e8 ec ff ff       	call   8004d6 <_panic>
  8017ee:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8017f1:	8b 00                	mov    (%eax),%eax
  8017f3:	85 c0                	test   %eax,%eax
  8017f5:	74 10                	je     801807 <free+0x6a>
  8017f7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8017fa:	8b 00                	mov    (%eax),%eax
  8017fc:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8017ff:	8b 52 04             	mov    0x4(%edx),%edx
  801802:	89 50 04             	mov    %edx,0x4(%eax)
  801805:	eb 0b                	jmp    801812 <free+0x75>
  801807:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80180a:	8b 40 04             	mov    0x4(%eax),%eax
  80180d:	a3 44 40 80 00       	mov    %eax,0x804044
  801812:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801815:	8b 40 04             	mov    0x4(%eax),%eax
  801818:	85 c0                	test   %eax,%eax
  80181a:	74 0f                	je     80182b <free+0x8e>
  80181c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80181f:	8b 40 04             	mov    0x4(%eax),%eax
  801822:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801825:	8b 12                	mov    (%edx),%edx
  801827:	89 10                	mov    %edx,(%eax)
  801829:	eb 0a                	jmp    801835 <free+0x98>
  80182b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80182e:	8b 00                	mov    (%eax),%eax
  801830:	a3 40 40 80 00       	mov    %eax,0x804040
  801835:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801838:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80183e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801841:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  801848:	a1 4c 40 80 00       	mov    0x80404c,%eax
  80184d:	48                   	dec    %eax
  80184e:	a3 4c 40 80 00       	mov    %eax,0x80404c
	insert_sorted_with_merge_freeList(myBlock);
  801853:	83 ec 0c             	sub    $0xc,%esp
  801856:	ff 75 f0             	pushl  -0x10(%ebp)
  801859:	e8 0b 14 00 00       	call   802c69 <insert_sorted_with_merge_freeList>
  80185e:	83 c4 10             	add    $0x10,%esp

	//you should get the size of the given allocation using its address
	//you need to call sys_free_user_mem()
	//refer to the project presentation and documentation for details
}
  801861:	90                   	nop
  801862:	c9                   	leave  
  801863:	c3                   	ret    

00801864 <smalloc>:

//=================================
// [4] ALLOCATE SHARED VARIABLE:
//=================================
void* smalloc(char *sharedVarName, uint32 size, uint8 isWritable)
{
  801864:	55                   	push   %ebp
  801865:	89 e5                	mov    %esp,%ebp
  801867:	83 ec 28             	sub    $0x28,%esp
  80186a:	8b 45 10             	mov    0x10(%ebp),%eax
  80186d:	88 45 e4             	mov    %al,-0x1c(%ebp)
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801870:	e8 9f fc ff ff       	call   801514 <InitializeUHeap>
	if (size == 0) return NULL ;
  801875:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801879:	75 0a                	jne    801885 <smalloc+0x21>
  80187b:	b8 00 00 00 00       	mov    $0x0,%eax
  801880:	e9 8d 00 00 00       	jmp    801912 <smalloc+0xae>

	//This function should find the space of the required range
	// * ON 4KB BOUNDARY **** //
	//Use sys_isUHeapPlacementStrategyFIRSTFIT() to check the current strategy

	size = ROUNDUP(size, PAGE_SIZE);
  801885:	c7 45 f4 00 10 00 00 	movl   $0x1000,-0xc(%ebp)
  80188c:	8b 55 0c             	mov    0xc(%ebp),%edx
  80188f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801892:	01 d0                	add    %edx,%eax
  801894:	48                   	dec    %eax
  801895:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801898:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80189b:	ba 00 00 00 00       	mov    $0x0,%edx
  8018a0:	f7 75 f4             	divl   -0xc(%ebp)
  8018a3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8018a6:	29 d0                	sub    %edx,%eax
  8018a8:	89 45 0c             	mov    %eax,0xc(%ebp)
		if(sys_isUHeapPlacementStrategyFIRSTFIT())
  8018ab:	e8 c9 06 00 00       	call   801f79 <sys_isUHeapPlacementStrategyFIRSTFIT>
  8018b0:	85 c0                	test   %eax,%eax
  8018b2:	74 59                	je     80190d <smalloc+0xa9>
		{
			struct MemBlock * v1=NULL;
  8018b4:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
			v1= alloc_block_FF(size);
  8018bb:	83 ec 0c             	sub    $0xc,%esp
  8018be:	ff 75 0c             	pushl  0xc(%ebp)
  8018c1:	e8 b4 0c 00 00       	call   80257a <alloc_block_FF>
  8018c6:	83 c4 10             	add    $0x10,%esp
  8018c9:	89 45 ec             	mov    %eax,-0x14(%ebp)
			if(v1==NULL)
  8018cc:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8018d0:	75 07                	jne    8018d9 <smalloc+0x75>
			{
				return NULL;
  8018d2:	b8 00 00 00 00       	mov    $0x0,%eax
  8018d7:	eb 39                	jmp    801912 <smalloc+0xae>
			}
			else
			{
				int ret=sys_createSharedObject(sharedVarName,  size,  isWritable,(void*)v1->sva);
  8018d9:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8018dc:	8b 40 08             	mov    0x8(%eax),%eax
  8018df:	89 c2                	mov    %eax,%edx
  8018e1:	0f b6 45 e4          	movzbl -0x1c(%ebp),%eax
  8018e5:	52                   	push   %edx
  8018e6:	50                   	push   %eax
  8018e7:	ff 75 0c             	pushl  0xc(%ebp)
  8018ea:	ff 75 08             	pushl  0x8(%ebp)
  8018ed:	e8 0c 04 00 00       	call   801cfe <sys_createSharedObject>
  8018f2:	83 c4 10             	add    $0x10,%esp
  8018f5:	89 45 e8             	mov    %eax,-0x18(%ebp)
				if(ret>=0)
  8018f8:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  8018fc:	78 08                	js     801906 <smalloc+0xa2>
				{
					return (void*)v1->sva;
  8018fe:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801901:	8b 40 08             	mov    0x8(%eax),%eax
  801904:	eb 0c                	jmp    801912 <smalloc+0xae>
				}
				else
				{
					return NULL;
  801906:	b8 00 00 00 00       	mov    $0x0,%eax
  80190b:	eb 05                	jmp    801912 <smalloc+0xae>
				}
			}

		}
		return NULL;
  80190d:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801912:	c9                   	leave  
  801913:	c3                   	ret    

00801914 <sget>:

//========================================
// [5] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
  801914:	55                   	push   %ebp
  801915:	89 e5                	mov    %esp,%ebp
  801917:	83 ec 18             	sub    $0x18,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  80191a:	e8 f5 fb ff ff       	call   801514 <InitializeUHeap>

	//This function should find the space for sharing the variable
	// *** ON 4KB BOUNDARY ******** //

	//Use sys_isUHeapPlacementStrategyFIRSTFIT() to check the current strategy
	int ret=sys_getSizeOfSharedObject(ownerEnvID,sharedVarName);
  80191f:	83 ec 08             	sub    $0x8,%esp
  801922:	ff 75 0c             	pushl  0xc(%ebp)
  801925:	ff 75 08             	pushl  0x8(%ebp)
  801928:	e8 fb 03 00 00       	call   801d28 <sys_getSizeOfSharedObject>
  80192d:	83 c4 10             	add    $0x10,%esp
  801930:	89 45 f4             	mov    %eax,-0xc(%ebp)
	if(ret==0)
  801933:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801937:	75 07                	jne    801940 <sget+0x2c>
	{
		return NULL;
  801939:	b8 00 00 00 00       	mov    $0x0,%eax
  80193e:	eb 64                	jmp    8019a4 <sget+0x90>
	}
	if(sys_isUHeapPlacementStrategyFIRSTFIT())
  801940:	e8 34 06 00 00       	call   801f79 <sys_isUHeapPlacementStrategyFIRSTFIT>
  801945:	85 c0                	test   %eax,%eax
  801947:	74 56                	je     80199f <sget+0x8b>
	{
		struct MemBlock * v1=NULL;
  801949:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
		v1= alloc_block_FF(ret);
  801950:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801953:	83 ec 0c             	sub    $0xc,%esp
  801956:	50                   	push   %eax
  801957:	e8 1e 0c 00 00       	call   80257a <alloc_block_FF>
  80195c:	83 c4 10             	add    $0x10,%esp
  80195f:	89 45 f0             	mov    %eax,-0x10(%ebp)
		if(v1==NULL)
  801962:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801966:	75 07                	jne    80196f <sget+0x5b>
		{
		return NULL;
  801968:	b8 00 00 00 00       	mov    $0x0,%eax
  80196d:	eb 35                	jmp    8019a4 <sget+0x90>
	    }
		else
		{
			int ret1=sys_getSharedObject(ownerEnvID,sharedVarName,(void*)v1->sva);
  80196f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801972:	8b 40 08             	mov    0x8(%eax),%eax
  801975:	83 ec 04             	sub    $0x4,%esp
  801978:	50                   	push   %eax
  801979:	ff 75 0c             	pushl  0xc(%ebp)
  80197c:	ff 75 08             	pushl  0x8(%ebp)
  80197f:	e8 c1 03 00 00       	call   801d45 <sys_getSharedObject>
  801984:	83 c4 10             	add    $0x10,%esp
  801987:	89 45 ec             	mov    %eax,-0x14(%ebp)
			if(ret1>=0)
  80198a:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  80198e:	78 08                	js     801998 <sget+0x84>
			{
				return (void*)v1->sva;
  801990:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801993:	8b 40 08             	mov    0x8(%eax),%eax
  801996:	eb 0c                	jmp    8019a4 <sget+0x90>
			}
			else
			{
				return NULL;
  801998:	b8 00 00 00 00       	mov    $0x0,%eax
  80199d:	eb 05                	jmp    8019a4 <sget+0x90>
			}
		}
	}
  return NULL;
  80199f:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8019a4:	c9                   	leave  
  8019a5:	c3                   	ret    

008019a6 <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  8019a6:	55                   	push   %ebp
  8019a7:	89 e5                	mov    %esp,%ebp
  8019a9:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  8019ac:	e8 63 fb ff ff       	call   801514 <InitializeUHeap>
	//==============================================================
	// [USER HEAP - USER SIDE] realloc
	// Write your code here, remove the panic and write your code
	panic("realloc() is not implemented yet...!!");
  8019b1:	83 ec 04             	sub    $0x4,%esp
  8019b4:	68 e4 3b 80 00       	push   $0x803be4
  8019b9:	68 0e 01 00 00       	push   $0x10e
  8019be:	68 b3 3b 80 00       	push   $0x803bb3
  8019c3:	e8 0e eb ff ff       	call   8004d6 <_panic>

008019c8 <sfree>:
//	use sys_freeSharedObject(...); which switches to the kernel mode,
//	calls freeSharedObject(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the freeSharedObject() function is empty, make sure to implement it.

void sfree(void* virtual_address)
{
  8019c8:	55                   	push   %ebp
  8019c9:	89 e5                	mov    %esp,%ebp
  8019cb:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT MS3 - BONUS] [SHARING - USER SIDE] sfree()

	// Write your code here, remove the panic and write your code
	panic("sfree() is not implemented yet...!!");
  8019ce:	83 ec 04             	sub    $0x4,%esp
  8019d1:	68 0c 3c 80 00       	push   $0x803c0c
  8019d6:	68 22 01 00 00       	push   $0x122
  8019db:	68 b3 3b 80 00       	push   $0x803bb3
  8019e0:	e8 f1 ea ff ff       	call   8004d6 <_panic>

008019e5 <expand>:

//==================================================================================//
//========================== MODIFICATION FUNCTIONS ================================//
//==================================================================================//
void expand(uint32 newSize)
{
  8019e5:	55                   	push   %ebp
  8019e6:	89 e5                	mov    %esp,%ebp
  8019e8:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  8019eb:	83 ec 04             	sub    $0x4,%esp
  8019ee:	68 30 3c 80 00       	push   $0x803c30
  8019f3:	68 2d 01 00 00       	push   $0x12d
  8019f8:	68 b3 3b 80 00       	push   $0x803bb3
  8019fd:	e8 d4 ea ff ff       	call   8004d6 <_panic>

00801a02 <shrink>:

}
void shrink(uint32 newSize)
{
  801a02:	55                   	push   %ebp
  801a03:	89 e5                	mov    %esp,%ebp
  801a05:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801a08:	83 ec 04             	sub    $0x4,%esp
  801a0b:	68 30 3c 80 00       	push   $0x803c30
  801a10:	68 32 01 00 00       	push   $0x132
  801a15:	68 b3 3b 80 00       	push   $0x803bb3
  801a1a:	e8 b7 ea ff ff       	call   8004d6 <_panic>

00801a1f <freeHeap>:

}
void freeHeap(void* virtual_address)
{
  801a1f:	55                   	push   %ebp
  801a20:	89 e5                	mov    %esp,%ebp
  801a22:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801a25:	83 ec 04             	sub    $0x4,%esp
  801a28:	68 30 3c 80 00       	push   $0x803c30
  801a2d:	68 37 01 00 00       	push   $0x137
  801a32:	68 b3 3b 80 00       	push   $0x803bb3
  801a37:	e8 9a ea ff ff       	call   8004d6 <_panic>

00801a3c <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  801a3c:	55                   	push   %ebp
  801a3d:	89 e5                	mov    %esp,%ebp
  801a3f:	57                   	push   %edi
  801a40:	56                   	push   %esi
  801a41:	53                   	push   %ebx
  801a42:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801a45:	8b 45 08             	mov    0x8(%ebp),%eax
  801a48:	8b 55 0c             	mov    0xc(%ebp),%edx
  801a4b:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801a4e:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801a51:	8b 7d 18             	mov    0x18(%ebp),%edi
  801a54:	8b 75 1c             	mov    0x1c(%ebp),%esi
  801a57:	cd 30                	int    $0x30
  801a59:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  801a5c:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801a5f:	83 c4 10             	add    $0x10,%esp
  801a62:	5b                   	pop    %ebx
  801a63:	5e                   	pop    %esi
  801a64:	5f                   	pop    %edi
  801a65:	5d                   	pop    %ebp
  801a66:	c3                   	ret    

00801a67 <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  801a67:	55                   	push   %ebp
  801a68:	89 e5                	mov    %esp,%ebp
  801a6a:	83 ec 04             	sub    $0x4,%esp
  801a6d:	8b 45 10             	mov    0x10(%ebp),%eax
  801a70:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  801a73:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801a77:	8b 45 08             	mov    0x8(%ebp),%eax
  801a7a:	6a 00                	push   $0x0
  801a7c:	6a 00                	push   $0x0
  801a7e:	52                   	push   %edx
  801a7f:	ff 75 0c             	pushl  0xc(%ebp)
  801a82:	50                   	push   %eax
  801a83:	6a 00                	push   $0x0
  801a85:	e8 b2 ff ff ff       	call   801a3c <syscall>
  801a8a:	83 c4 18             	add    $0x18,%esp
}
  801a8d:	90                   	nop
  801a8e:	c9                   	leave  
  801a8f:	c3                   	ret    

00801a90 <sys_cgetc>:

int
sys_cgetc(void)
{
  801a90:	55                   	push   %ebp
  801a91:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  801a93:	6a 00                	push   $0x0
  801a95:	6a 00                	push   $0x0
  801a97:	6a 00                	push   $0x0
  801a99:	6a 00                	push   $0x0
  801a9b:	6a 00                	push   $0x0
  801a9d:	6a 01                	push   $0x1
  801a9f:	e8 98 ff ff ff       	call   801a3c <syscall>
  801aa4:	83 c4 18             	add    $0x18,%esp
}
  801aa7:	c9                   	leave  
  801aa8:	c3                   	ret    

00801aa9 <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  801aa9:	55                   	push   %ebp
  801aaa:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  801aac:	8b 55 0c             	mov    0xc(%ebp),%edx
  801aaf:	8b 45 08             	mov    0x8(%ebp),%eax
  801ab2:	6a 00                	push   $0x0
  801ab4:	6a 00                	push   $0x0
  801ab6:	6a 00                	push   $0x0
  801ab8:	52                   	push   %edx
  801ab9:	50                   	push   %eax
  801aba:	6a 05                	push   $0x5
  801abc:	e8 7b ff ff ff       	call   801a3c <syscall>
  801ac1:	83 c4 18             	add    $0x18,%esp
}
  801ac4:	c9                   	leave  
  801ac5:	c3                   	ret    

00801ac6 <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  801ac6:	55                   	push   %ebp
  801ac7:	89 e5                	mov    %esp,%ebp
  801ac9:	56                   	push   %esi
  801aca:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  801acb:	8b 75 18             	mov    0x18(%ebp),%esi
  801ace:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801ad1:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801ad4:	8b 55 0c             	mov    0xc(%ebp),%edx
  801ad7:	8b 45 08             	mov    0x8(%ebp),%eax
  801ada:	56                   	push   %esi
  801adb:	53                   	push   %ebx
  801adc:	51                   	push   %ecx
  801add:	52                   	push   %edx
  801ade:	50                   	push   %eax
  801adf:	6a 06                	push   $0x6
  801ae1:	e8 56 ff ff ff       	call   801a3c <syscall>
  801ae6:	83 c4 18             	add    $0x18,%esp
}
  801ae9:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801aec:	5b                   	pop    %ebx
  801aed:	5e                   	pop    %esi
  801aee:	5d                   	pop    %ebp
  801aef:	c3                   	ret    

00801af0 <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  801af0:	55                   	push   %ebp
  801af1:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  801af3:	8b 55 0c             	mov    0xc(%ebp),%edx
  801af6:	8b 45 08             	mov    0x8(%ebp),%eax
  801af9:	6a 00                	push   $0x0
  801afb:	6a 00                	push   $0x0
  801afd:	6a 00                	push   $0x0
  801aff:	52                   	push   %edx
  801b00:	50                   	push   %eax
  801b01:	6a 07                	push   $0x7
  801b03:	e8 34 ff ff ff       	call   801a3c <syscall>
  801b08:	83 c4 18             	add    $0x18,%esp
}
  801b0b:	c9                   	leave  
  801b0c:	c3                   	ret    

00801b0d <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  801b0d:	55                   	push   %ebp
  801b0e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  801b10:	6a 00                	push   $0x0
  801b12:	6a 00                	push   $0x0
  801b14:	6a 00                	push   $0x0
  801b16:	ff 75 0c             	pushl  0xc(%ebp)
  801b19:	ff 75 08             	pushl  0x8(%ebp)
  801b1c:	6a 08                	push   $0x8
  801b1e:	e8 19 ff ff ff       	call   801a3c <syscall>
  801b23:	83 c4 18             	add    $0x18,%esp
}
  801b26:	c9                   	leave  
  801b27:	c3                   	ret    

00801b28 <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  801b28:	55                   	push   %ebp
  801b29:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  801b2b:	6a 00                	push   $0x0
  801b2d:	6a 00                	push   $0x0
  801b2f:	6a 00                	push   $0x0
  801b31:	6a 00                	push   $0x0
  801b33:	6a 00                	push   $0x0
  801b35:	6a 09                	push   $0x9
  801b37:	e8 00 ff ff ff       	call   801a3c <syscall>
  801b3c:	83 c4 18             	add    $0x18,%esp
}
  801b3f:	c9                   	leave  
  801b40:	c3                   	ret    

00801b41 <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  801b41:	55                   	push   %ebp
  801b42:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  801b44:	6a 00                	push   $0x0
  801b46:	6a 00                	push   $0x0
  801b48:	6a 00                	push   $0x0
  801b4a:	6a 00                	push   $0x0
  801b4c:	6a 00                	push   $0x0
  801b4e:	6a 0a                	push   $0xa
  801b50:	e8 e7 fe ff ff       	call   801a3c <syscall>
  801b55:	83 c4 18             	add    $0x18,%esp
}
  801b58:	c9                   	leave  
  801b59:	c3                   	ret    

00801b5a <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  801b5a:	55                   	push   %ebp
  801b5b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  801b5d:	6a 00                	push   $0x0
  801b5f:	6a 00                	push   $0x0
  801b61:	6a 00                	push   $0x0
  801b63:	6a 00                	push   $0x0
  801b65:	6a 00                	push   $0x0
  801b67:	6a 0b                	push   $0xb
  801b69:	e8 ce fe ff ff       	call   801a3c <syscall>
  801b6e:	83 c4 18             	add    $0x18,%esp
}
  801b71:	c9                   	leave  
  801b72:	c3                   	ret    

00801b73 <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  801b73:	55                   	push   %ebp
  801b74:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  801b76:	6a 00                	push   $0x0
  801b78:	6a 00                	push   $0x0
  801b7a:	6a 00                	push   $0x0
  801b7c:	ff 75 0c             	pushl  0xc(%ebp)
  801b7f:	ff 75 08             	pushl  0x8(%ebp)
  801b82:	6a 0f                	push   $0xf
  801b84:	e8 b3 fe ff ff       	call   801a3c <syscall>
  801b89:	83 c4 18             	add    $0x18,%esp
	return;
  801b8c:	90                   	nop
}
  801b8d:	c9                   	leave  
  801b8e:	c3                   	ret    

00801b8f <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  801b8f:	55                   	push   %ebp
  801b90:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  801b92:	6a 00                	push   $0x0
  801b94:	6a 00                	push   $0x0
  801b96:	6a 00                	push   $0x0
  801b98:	ff 75 0c             	pushl  0xc(%ebp)
  801b9b:	ff 75 08             	pushl  0x8(%ebp)
  801b9e:	6a 10                	push   $0x10
  801ba0:	e8 97 fe ff ff       	call   801a3c <syscall>
  801ba5:	83 c4 18             	add    $0x18,%esp
	return ;
  801ba8:	90                   	nop
}
  801ba9:	c9                   	leave  
  801baa:	c3                   	ret    

00801bab <sys_allocate_chunk>:

void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  801bab:	55                   	push   %ebp
  801bac:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  801bae:	6a 00                	push   $0x0
  801bb0:	6a 00                	push   $0x0
  801bb2:	ff 75 10             	pushl  0x10(%ebp)
  801bb5:	ff 75 0c             	pushl  0xc(%ebp)
  801bb8:	ff 75 08             	pushl  0x8(%ebp)
  801bbb:	6a 11                	push   $0x11
  801bbd:	e8 7a fe ff ff       	call   801a3c <syscall>
  801bc2:	83 c4 18             	add    $0x18,%esp
	return ;
  801bc5:	90                   	nop
}
  801bc6:	c9                   	leave  
  801bc7:	c3                   	ret    

00801bc8 <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  801bc8:	55                   	push   %ebp
  801bc9:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  801bcb:	6a 00                	push   $0x0
  801bcd:	6a 00                	push   $0x0
  801bcf:	6a 00                	push   $0x0
  801bd1:	6a 00                	push   $0x0
  801bd3:	6a 00                	push   $0x0
  801bd5:	6a 0c                	push   $0xc
  801bd7:	e8 60 fe ff ff       	call   801a3c <syscall>
  801bdc:	83 c4 18             	add    $0x18,%esp
}
  801bdf:	c9                   	leave  
  801be0:	c3                   	ret    

00801be1 <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  801be1:	55                   	push   %ebp
  801be2:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  801be4:	6a 00                	push   $0x0
  801be6:	6a 00                	push   $0x0
  801be8:	6a 00                	push   $0x0
  801bea:	6a 00                	push   $0x0
  801bec:	ff 75 08             	pushl  0x8(%ebp)
  801bef:	6a 0d                	push   $0xd
  801bf1:	e8 46 fe ff ff       	call   801a3c <syscall>
  801bf6:	83 c4 18             	add    $0x18,%esp
}
  801bf9:	c9                   	leave  
  801bfa:	c3                   	ret    

00801bfb <sys_scarce_memory>:

void sys_scarce_memory()
{
  801bfb:	55                   	push   %ebp
  801bfc:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  801bfe:	6a 00                	push   $0x0
  801c00:	6a 00                	push   $0x0
  801c02:	6a 00                	push   $0x0
  801c04:	6a 00                	push   $0x0
  801c06:	6a 00                	push   $0x0
  801c08:	6a 0e                	push   $0xe
  801c0a:	e8 2d fe ff ff       	call   801a3c <syscall>
  801c0f:	83 c4 18             	add    $0x18,%esp
}
  801c12:	90                   	nop
  801c13:	c9                   	leave  
  801c14:	c3                   	ret    

00801c15 <sys_disable_interrupt>:

//NEW !! 2012...
void
sys_disable_interrupt()
{
  801c15:	55                   	push   %ebp
  801c16:	89 e5                	mov    %esp,%ebp
	syscall(SYS_disableINTR,0, 0, 0, 0, 0);
  801c18:	6a 00                	push   $0x0
  801c1a:	6a 00                	push   $0x0
  801c1c:	6a 00                	push   $0x0
  801c1e:	6a 00                	push   $0x0
  801c20:	6a 00                	push   $0x0
  801c22:	6a 13                	push   $0x13
  801c24:	e8 13 fe ff ff       	call   801a3c <syscall>
  801c29:	83 c4 18             	add    $0x18,%esp
}
  801c2c:	90                   	nop
  801c2d:	c9                   	leave  
  801c2e:	c3                   	ret    

00801c2f <sys_enable_interrupt>:


void
sys_enable_interrupt()
{
  801c2f:	55                   	push   %ebp
  801c30:	89 e5                	mov    %esp,%ebp
	syscall(SYS_enableINTR,0, 0, 0, 0, 0);
  801c32:	6a 00                	push   $0x0
  801c34:	6a 00                	push   $0x0
  801c36:	6a 00                	push   $0x0
  801c38:	6a 00                	push   $0x0
  801c3a:	6a 00                	push   $0x0
  801c3c:	6a 14                	push   $0x14
  801c3e:	e8 f9 fd ff ff       	call   801a3c <syscall>
  801c43:	83 c4 18             	add    $0x18,%esp
}
  801c46:	90                   	nop
  801c47:	c9                   	leave  
  801c48:	c3                   	ret    

00801c49 <sys_cputc>:


void
sys_cputc(const char c)
{
  801c49:	55                   	push   %ebp
  801c4a:	89 e5                	mov    %esp,%ebp
  801c4c:	83 ec 04             	sub    $0x4,%esp
  801c4f:	8b 45 08             	mov    0x8(%ebp),%eax
  801c52:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  801c55:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801c59:	6a 00                	push   $0x0
  801c5b:	6a 00                	push   $0x0
  801c5d:	6a 00                	push   $0x0
  801c5f:	6a 00                	push   $0x0
  801c61:	50                   	push   %eax
  801c62:	6a 15                	push   $0x15
  801c64:	e8 d3 fd ff ff       	call   801a3c <syscall>
  801c69:	83 c4 18             	add    $0x18,%esp
}
  801c6c:	90                   	nop
  801c6d:	c9                   	leave  
  801c6e:	c3                   	ret    

00801c6f <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  801c6f:	55                   	push   %ebp
  801c70:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  801c72:	6a 00                	push   $0x0
  801c74:	6a 00                	push   $0x0
  801c76:	6a 00                	push   $0x0
  801c78:	6a 00                	push   $0x0
  801c7a:	6a 00                	push   $0x0
  801c7c:	6a 16                	push   $0x16
  801c7e:	e8 b9 fd ff ff       	call   801a3c <syscall>
  801c83:	83 c4 18             	add    $0x18,%esp
}
  801c86:	90                   	nop
  801c87:	c9                   	leave  
  801c88:	c3                   	ret    

00801c89 <sys_createSemaphore>:

int
sys_createSemaphore(char* semaphoreName, uint32 initialValue)
{
  801c89:	55                   	push   %ebp
  801c8a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_semaphore,(uint32)semaphoreName, (uint32)initialValue, 0, 0, 0);
  801c8c:	8b 45 08             	mov    0x8(%ebp),%eax
  801c8f:	6a 00                	push   $0x0
  801c91:	6a 00                	push   $0x0
  801c93:	6a 00                	push   $0x0
  801c95:	ff 75 0c             	pushl  0xc(%ebp)
  801c98:	50                   	push   %eax
  801c99:	6a 17                	push   $0x17
  801c9b:	e8 9c fd ff ff       	call   801a3c <syscall>
  801ca0:	83 c4 18             	add    $0x18,%esp
}
  801ca3:	c9                   	leave  
  801ca4:	c3                   	ret    

00801ca5 <sys_getSemaphoreValue>:

int
sys_getSemaphoreValue(int32 ownerEnvID, char* semaphoreName)
{
  801ca5:	55                   	push   %ebp
  801ca6:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_semaphore_value,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801ca8:	8b 55 0c             	mov    0xc(%ebp),%edx
  801cab:	8b 45 08             	mov    0x8(%ebp),%eax
  801cae:	6a 00                	push   $0x0
  801cb0:	6a 00                	push   $0x0
  801cb2:	6a 00                	push   $0x0
  801cb4:	52                   	push   %edx
  801cb5:	50                   	push   %eax
  801cb6:	6a 1a                	push   $0x1a
  801cb8:	e8 7f fd ff ff       	call   801a3c <syscall>
  801cbd:	83 c4 18             	add    $0x18,%esp
}
  801cc0:	c9                   	leave  
  801cc1:	c3                   	ret    

00801cc2 <sys_waitSemaphore>:

void
sys_waitSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  801cc2:	55                   	push   %ebp
  801cc3:	89 e5                	mov    %esp,%ebp
	syscall(SYS_wait_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801cc5:	8b 55 0c             	mov    0xc(%ebp),%edx
  801cc8:	8b 45 08             	mov    0x8(%ebp),%eax
  801ccb:	6a 00                	push   $0x0
  801ccd:	6a 00                	push   $0x0
  801ccf:	6a 00                	push   $0x0
  801cd1:	52                   	push   %edx
  801cd2:	50                   	push   %eax
  801cd3:	6a 18                	push   $0x18
  801cd5:	e8 62 fd ff ff       	call   801a3c <syscall>
  801cda:	83 c4 18             	add    $0x18,%esp
}
  801cdd:	90                   	nop
  801cde:	c9                   	leave  
  801cdf:	c3                   	ret    

00801ce0 <sys_signalSemaphore>:

void
sys_signalSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  801ce0:	55                   	push   %ebp
  801ce1:	89 e5                	mov    %esp,%ebp
	syscall(SYS_signal_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801ce3:	8b 55 0c             	mov    0xc(%ebp),%edx
  801ce6:	8b 45 08             	mov    0x8(%ebp),%eax
  801ce9:	6a 00                	push   $0x0
  801ceb:	6a 00                	push   $0x0
  801ced:	6a 00                	push   $0x0
  801cef:	52                   	push   %edx
  801cf0:	50                   	push   %eax
  801cf1:	6a 19                	push   $0x19
  801cf3:	e8 44 fd ff ff       	call   801a3c <syscall>
  801cf8:	83 c4 18             	add    $0x18,%esp
}
  801cfb:	90                   	nop
  801cfc:	c9                   	leave  
  801cfd:	c3                   	ret    

00801cfe <sys_createSharedObject>:

int
sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  801cfe:	55                   	push   %ebp
  801cff:	89 e5                	mov    %esp,%ebp
  801d01:	83 ec 04             	sub    $0x4,%esp
  801d04:	8b 45 10             	mov    0x10(%ebp),%eax
  801d07:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  801d0a:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801d0d:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801d11:	8b 45 08             	mov    0x8(%ebp),%eax
  801d14:	6a 00                	push   $0x0
  801d16:	51                   	push   %ecx
  801d17:	52                   	push   %edx
  801d18:	ff 75 0c             	pushl  0xc(%ebp)
  801d1b:	50                   	push   %eax
  801d1c:	6a 1b                	push   $0x1b
  801d1e:	e8 19 fd ff ff       	call   801a3c <syscall>
  801d23:	83 c4 18             	add    $0x18,%esp
}
  801d26:	c9                   	leave  
  801d27:	c3                   	ret    

00801d28 <sys_getSizeOfSharedObject>:

//2017:
int
sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  801d28:	55                   	push   %ebp
  801d29:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  801d2b:	8b 55 0c             	mov    0xc(%ebp),%edx
  801d2e:	8b 45 08             	mov    0x8(%ebp),%eax
  801d31:	6a 00                	push   $0x0
  801d33:	6a 00                	push   $0x0
  801d35:	6a 00                	push   $0x0
  801d37:	52                   	push   %edx
  801d38:	50                   	push   %eax
  801d39:	6a 1c                	push   $0x1c
  801d3b:	e8 fc fc ff ff       	call   801a3c <syscall>
  801d40:	83 c4 18             	add    $0x18,%esp
}
  801d43:	c9                   	leave  
  801d44:	c3                   	ret    

00801d45 <sys_getSharedObject>:
//==========

int
sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  801d45:	55                   	push   %ebp
  801d46:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  801d48:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801d4b:	8b 55 0c             	mov    0xc(%ebp),%edx
  801d4e:	8b 45 08             	mov    0x8(%ebp),%eax
  801d51:	6a 00                	push   $0x0
  801d53:	6a 00                	push   $0x0
  801d55:	51                   	push   %ecx
  801d56:	52                   	push   %edx
  801d57:	50                   	push   %eax
  801d58:	6a 1d                	push   $0x1d
  801d5a:	e8 dd fc ff ff       	call   801a3c <syscall>
  801d5f:	83 c4 18             	add    $0x18,%esp
}
  801d62:	c9                   	leave  
  801d63:	c3                   	ret    

00801d64 <sys_freeSharedObject>:

int
sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  801d64:	55                   	push   %ebp
  801d65:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  801d67:	8b 55 0c             	mov    0xc(%ebp),%edx
  801d6a:	8b 45 08             	mov    0x8(%ebp),%eax
  801d6d:	6a 00                	push   $0x0
  801d6f:	6a 00                	push   $0x0
  801d71:	6a 00                	push   $0x0
  801d73:	52                   	push   %edx
  801d74:	50                   	push   %eax
  801d75:	6a 1e                	push   $0x1e
  801d77:	e8 c0 fc ff ff       	call   801a3c <syscall>
  801d7c:	83 c4 18             	add    $0x18,%esp
}
  801d7f:	c9                   	leave  
  801d80:	c3                   	ret    

00801d81 <sys_getMaxShares>:

uint32 	sys_getMaxShares()
{
  801d81:	55                   	push   %ebp
  801d82:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_max_shares,0, 0, 0, 0, 0);
  801d84:	6a 00                	push   $0x0
  801d86:	6a 00                	push   $0x0
  801d88:	6a 00                	push   $0x0
  801d8a:	6a 00                	push   $0x0
  801d8c:	6a 00                	push   $0x0
  801d8e:	6a 1f                	push   $0x1f
  801d90:	e8 a7 fc ff ff       	call   801a3c <syscall>
  801d95:	83 c4 18             	add    $0x18,%esp
}
  801d98:	c9                   	leave  
  801d99:	c3                   	ret    

00801d9a <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  801d9a:	55                   	push   %ebp
  801d9b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  801d9d:	8b 45 08             	mov    0x8(%ebp),%eax
  801da0:	6a 00                	push   $0x0
  801da2:	ff 75 14             	pushl  0x14(%ebp)
  801da5:	ff 75 10             	pushl  0x10(%ebp)
  801da8:	ff 75 0c             	pushl  0xc(%ebp)
  801dab:	50                   	push   %eax
  801dac:	6a 20                	push   $0x20
  801dae:	e8 89 fc ff ff       	call   801a3c <syscall>
  801db3:	83 c4 18             	add    $0x18,%esp
}
  801db6:	c9                   	leave  
  801db7:	c3                   	ret    

00801db8 <sys_run_env>:

void
sys_run_env(int32 envId)
{
  801db8:	55                   	push   %ebp
  801db9:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  801dbb:	8b 45 08             	mov    0x8(%ebp),%eax
  801dbe:	6a 00                	push   $0x0
  801dc0:	6a 00                	push   $0x0
  801dc2:	6a 00                	push   $0x0
  801dc4:	6a 00                	push   $0x0
  801dc6:	50                   	push   %eax
  801dc7:	6a 21                	push   $0x21
  801dc9:	e8 6e fc ff ff       	call   801a3c <syscall>
  801dce:	83 c4 18             	add    $0x18,%esp
}
  801dd1:	90                   	nop
  801dd2:	c9                   	leave  
  801dd3:	c3                   	ret    

00801dd4 <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  801dd4:	55                   	push   %ebp
  801dd5:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  801dd7:	8b 45 08             	mov    0x8(%ebp),%eax
  801dda:	6a 00                	push   $0x0
  801ddc:	6a 00                	push   $0x0
  801dde:	6a 00                	push   $0x0
  801de0:	6a 00                	push   $0x0
  801de2:	50                   	push   %eax
  801de3:	6a 22                	push   $0x22
  801de5:	e8 52 fc ff ff       	call   801a3c <syscall>
  801dea:	83 c4 18             	add    $0x18,%esp
}
  801ded:	c9                   	leave  
  801dee:	c3                   	ret    

00801def <sys_getenvid>:

int32 sys_getenvid(void)
{
  801def:	55                   	push   %ebp
  801df0:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  801df2:	6a 00                	push   $0x0
  801df4:	6a 00                	push   $0x0
  801df6:	6a 00                	push   $0x0
  801df8:	6a 00                	push   $0x0
  801dfa:	6a 00                	push   $0x0
  801dfc:	6a 02                	push   $0x2
  801dfe:	e8 39 fc ff ff       	call   801a3c <syscall>
  801e03:	83 c4 18             	add    $0x18,%esp
}
  801e06:	c9                   	leave  
  801e07:	c3                   	ret    

00801e08 <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  801e08:	55                   	push   %ebp
  801e09:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  801e0b:	6a 00                	push   $0x0
  801e0d:	6a 00                	push   $0x0
  801e0f:	6a 00                	push   $0x0
  801e11:	6a 00                	push   $0x0
  801e13:	6a 00                	push   $0x0
  801e15:	6a 03                	push   $0x3
  801e17:	e8 20 fc ff ff       	call   801a3c <syscall>
  801e1c:	83 c4 18             	add    $0x18,%esp
}
  801e1f:	c9                   	leave  
  801e20:	c3                   	ret    

00801e21 <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  801e21:	55                   	push   %ebp
  801e22:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  801e24:	6a 00                	push   $0x0
  801e26:	6a 00                	push   $0x0
  801e28:	6a 00                	push   $0x0
  801e2a:	6a 00                	push   $0x0
  801e2c:	6a 00                	push   $0x0
  801e2e:	6a 04                	push   $0x4
  801e30:	e8 07 fc ff ff       	call   801a3c <syscall>
  801e35:	83 c4 18             	add    $0x18,%esp
}
  801e38:	c9                   	leave  
  801e39:	c3                   	ret    

00801e3a <sys_exit_env>:


void sys_exit_env(void)
{
  801e3a:	55                   	push   %ebp
  801e3b:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  801e3d:	6a 00                	push   $0x0
  801e3f:	6a 00                	push   $0x0
  801e41:	6a 00                	push   $0x0
  801e43:	6a 00                	push   $0x0
  801e45:	6a 00                	push   $0x0
  801e47:	6a 23                	push   $0x23
  801e49:	e8 ee fb ff ff       	call   801a3c <syscall>
  801e4e:	83 c4 18             	add    $0x18,%esp
}
  801e51:	90                   	nop
  801e52:	c9                   	leave  
  801e53:	c3                   	ret    

00801e54 <sys_get_virtual_time>:


struct uint64
sys_get_virtual_time()
{
  801e54:	55                   	push   %ebp
  801e55:	89 e5                	mov    %esp,%ebp
  801e57:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  801e5a:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801e5d:	8d 50 04             	lea    0x4(%eax),%edx
  801e60:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801e63:	6a 00                	push   $0x0
  801e65:	6a 00                	push   $0x0
  801e67:	6a 00                	push   $0x0
  801e69:	52                   	push   %edx
  801e6a:	50                   	push   %eax
  801e6b:	6a 24                	push   $0x24
  801e6d:	e8 ca fb ff ff       	call   801a3c <syscall>
  801e72:	83 c4 18             	add    $0x18,%esp
	return result;
  801e75:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801e78:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801e7b:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801e7e:	89 01                	mov    %eax,(%ecx)
  801e80:	89 51 04             	mov    %edx,0x4(%ecx)
}
  801e83:	8b 45 08             	mov    0x8(%ebp),%eax
  801e86:	c9                   	leave  
  801e87:	c2 04 00             	ret    $0x4

00801e8a <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  801e8a:	55                   	push   %ebp
  801e8b:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  801e8d:	6a 00                	push   $0x0
  801e8f:	6a 00                	push   $0x0
  801e91:	ff 75 10             	pushl  0x10(%ebp)
  801e94:	ff 75 0c             	pushl  0xc(%ebp)
  801e97:	ff 75 08             	pushl  0x8(%ebp)
  801e9a:	6a 12                	push   $0x12
  801e9c:	e8 9b fb ff ff       	call   801a3c <syscall>
  801ea1:	83 c4 18             	add    $0x18,%esp
	return ;
  801ea4:	90                   	nop
}
  801ea5:	c9                   	leave  
  801ea6:	c3                   	ret    

00801ea7 <sys_rcr2>:
uint32 sys_rcr2()
{
  801ea7:	55                   	push   %ebp
  801ea8:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  801eaa:	6a 00                	push   $0x0
  801eac:	6a 00                	push   $0x0
  801eae:	6a 00                	push   $0x0
  801eb0:	6a 00                	push   $0x0
  801eb2:	6a 00                	push   $0x0
  801eb4:	6a 25                	push   $0x25
  801eb6:	e8 81 fb ff ff       	call   801a3c <syscall>
  801ebb:	83 c4 18             	add    $0x18,%esp
}
  801ebe:	c9                   	leave  
  801ebf:	c3                   	ret    

00801ec0 <sys_bypassPageFault>:
void sys_bypassPageFault(uint8 instrLength)
{
  801ec0:	55                   	push   %ebp
  801ec1:	89 e5                	mov    %esp,%ebp
  801ec3:	83 ec 04             	sub    $0x4,%esp
  801ec6:	8b 45 08             	mov    0x8(%ebp),%eax
  801ec9:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  801ecc:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  801ed0:	6a 00                	push   $0x0
  801ed2:	6a 00                	push   $0x0
  801ed4:	6a 00                	push   $0x0
  801ed6:	6a 00                	push   $0x0
  801ed8:	50                   	push   %eax
  801ed9:	6a 26                	push   $0x26
  801edb:	e8 5c fb ff ff       	call   801a3c <syscall>
  801ee0:	83 c4 18             	add    $0x18,%esp
	return ;
  801ee3:	90                   	nop
}
  801ee4:	c9                   	leave  
  801ee5:	c3                   	ret    

00801ee6 <rsttst>:
void rsttst()
{
  801ee6:	55                   	push   %ebp
  801ee7:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  801ee9:	6a 00                	push   $0x0
  801eeb:	6a 00                	push   $0x0
  801eed:	6a 00                	push   $0x0
  801eef:	6a 00                	push   $0x0
  801ef1:	6a 00                	push   $0x0
  801ef3:	6a 28                	push   $0x28
  801ef5:	e8 42 fb ff ff       	call   801a3c <syscall>
  801efa:	83 c4 18             	add    $0x18,%esp
	return ;
  801efd:	90                   	nop
}
  801efe:	c9                   	leave  
  801eff:	c3                   	ret    

00801f00 <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  801f00:	55                   	push   %ebp
  801f01:	89 e5                	mov    %esp,%ebp
  801f03:	83 ec 04             	sub    $0x4,%esp
  801f06:	8b 45 14             	mov    0x14(%ebp),%eax
  801f09:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  801f0c:	8b 55 18             	mov    0x18(%ebp),%edx
  801f0f:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801f13:	52                   	push   %edx
  801f14:	50                   	push   %eax
  801f15:	ff 75 10             	pushl  0x10(%ebp)
  801f18:	ff 75 0c             	pushl  0xc(%ebp)
  801f1b:	ff 75 08             	pushl  0x8(%ebp)
  801f1e:	6a 27                	push   $0x27
  801f20:	e8 17 fb ff ff       	call   801a3c <syscall>
  801f25:	83 c4 18             	add    $0x18,%esp
	return ;
  801f28:	90                   	nop
}
  801f29:	c9                   	leave  
  801f2a:	c3                   	ret    

00801f2b <chktst>:
void chktst(uint32 n)
{
  801f2b:	55                   	push   %ebp
  801f2c:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  801f2e:	6a 00                	push   $0x0
  801f30:	6a 00                	push   $0x0
  801f32:	6a 00                	push   $0x0
  801f34:	6a 00                	push   $0x0
  801f36:	ff 75 08             	pushl  0x8(%ebp)
  801f39:	6a 29                	push   $0x29
  801f3b:	e8 fc fa ff ff       	call   801a3c <syscall>
  801f40:	83 c4 18             	add    $0x18,%esp
	return ;
  801f43:	90                   	nop
}
  801f44:	c9                   	leave  
  801f45:	c3                   	ret    

00801f46 <inctst>:

void inctst()
{
  801f46:	55                   	push   %ebp
  801f47:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  801f49:	6a 00                	push   $0x0
  801f4b:	6a 00                	push   $0x0
  801f4d:	6a 00                	push   $0x0
  801f4f:	6a 00                	push   $0x0
  801f51:	6a 00                	push   $0x0
  801f53:	6a 2a                	push   $0x2a
  801f55:	e8 e2 fa ff ff       	call   801a3c <syscall>
  801f5a:	83 c4 18             	add    $0x18,%esp
	return ;
  801f5d:	90                   	nop
}
  801f5e:	c9                   	leave  
  801f5f:	c3                   	ret    

00801f60 <gettst>:
uint32 gettst()
{
  801f60:	55                   	push   %ebp
  801f61:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  801f63:	6a 00                	push   $0x0
  801f65:	6a 00                	push   $0x0
  801f67:	6a 00                	push   $0x0
  801f69:	6a 00                	push   $0x0
  801f6b:	6a 00                	push   $0x0
  801f6d:	6a 2b                	push   $0x2b
  801f6f:	e8 c8 fa ff ff       	call   801a3c <syscall>
  801f74:	83 c4 18             	add    $0x18,%esp
}
  801f77:	c9                   	leave  
  801f78:	c3                   	ret    

00801f79 <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  801f79:	55                   	push   %ebp
  801f7a:	89 e5                	mov    %esp,%ebp
  801f7c:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801f7f:	6a 00                	push   $0x0
  801f81:	6a 00                	push   $0x0
  801f83:	6a 00                	push   $0x0
  801f85:	6a 00                	push   $0x0
  801f87:	6a 00                	push   $0x0
  801f89:	6a 2c                	push   $0x2c
  801f8b:	e8 ac fa ff ff       	call   801a3c <syscall>
  801f90:	83 c4 18             	add    $0x18,%esp
  801f93:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  801f96:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  801f9a:	75 07                	jne    801fa3 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  801f9c:	b8 01 00 00 00       	mov    $0x1,%eax
  801fa1:	eb 05                	jmp    801fa8 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  801fa3:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801fa8:	c9                   	leave  
  801fa9:	c3                   	ret    

00801faa <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  801faa:	55                   	push   %ebp
  801fab:	89 e5                	mov    %esp,%ebp
  801fad:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801fb0:	6a 00                	push   $0x0
  801fb2:	6a 00                	push   $0x0
  801fb4:	6a 00                	push   $0x0
  801fb6:	6a 00                	push   $0x0
  801fb8:	6a 00                	push   $0x0
  801fba:	6a 2c                	push   $0x2c
  801fbc:	e8 7b fa ff ff       	call   801a3c <syscall>
  801fc1:	83 c4 18             	add    $0x18,%esp
  801fc4:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  801fc7:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  801fcb:	75 07                	jne    801fd4 <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  801fcd:	b8 01 00 00 00       	mov    $0x1,%eax
  801fd2:	eb 05                	jmp    801fd9 <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  801fd4:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801fd9:	c9                   	leave  
  801fda:	c3                   	ret    

00801fdb <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  801fdb:	55                   	push   %ebp
  801fdc:	89 e5                	mov    %esp,%ebp
  801fde:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801fe1:	6a 00                	push   $0x0
  801fe3:	6a 00                	push   $0x0
  801fe5:	6a 00                	push   $0x0
  801fe7:	6a 00                	push   $0x0
  801fe9:	6a 00                	push   $0x0
  801feb:	6a 2c                	push   $0x2c
  801fed:	e8 4a fa ff ff       	call   801a3c <syscall>
  801ff2:	83 c4 18             	add    $0x18,%esp
  801ff5:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  801ff8:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  801ffc:	75 07                	jne    802005 <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  801ffe:	b8 01 00 00 00       	mov    $0x1,%eax
  802003:	eb 05                	jmp    80200a <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  802005:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80200a:	c9                   	leave  
  80200b:	c3                   	ret    

0080200c <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  80200c:	55                   	push   %ebp
  80200d:	89 e5                	mov    %esp,%ebp
  80200f:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  802012:	6a 00                	push   $0x0
  802014:	6a 00                	push   $0x0
  802016:	6a 00                	push   $0x0
  802018:	6a 00                	push   $0x0
  80201a:	6a 00                	push   $0x0
  80201c:	6a 2c                	push   $0x2c
  80201e:	e8 19 fa ff ff       	call   801a3c <syscall>
  802023:	83 c4 18             	add    $0x18,%esp
  802026:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  802029:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  80202d:	75 07                	jne    802036 <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  80202f:	b8 01 00 00 00       	mov    $0x1,%eax
  802034:	eb 05                	jmp    80203b <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  802036:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80203b:	c9                   	leave  
  80203c:	c3                   	ret    

0080203d <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  80203d:	55                   	push   %ebp
  80203e:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  802040:	6a 00                	push   $0x0
  802042:	6a 00                	push   $0x0
  802044:	6a 00                	push   $0x0
  802046:	6a 00                	push   $0x0
  802048:	ff 75 08             	pushl  0x8(%ebp)
  80204b:	6a 2d                	push   $0x2d
  80204d:	e8 ea f9 ff ff       	call   801a3c <syscall>
  802052:	83 c4 18             	add    $0x18,%esp
	return ;
  802055:	90                   	nop
}
  802056:	c9                   	leave  
  802057:	c3                   	ret    

00802058 <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  802058:	55                   	push   %ebp
  802059:	89 e5                	mov    %esp,%ebp
  80205b:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  80205c:	8b 5d 14             	mov    0x14(%ebp),%ebx
  80205f:	8b 4d 10             	mov    0x10(%ebp),%ecx
  802062:	8b 55 0c             	mov    0xc(%ebp),%edx
  802065:	8b 45 08             	mov    0x8(%ebp),%eax
  802068:	6a 00                	push   $0x0
  80206a:	53                   	push   %ebx
  80206b:	51                   	push   %ecx
  80206c:	52                   	push   %edx
  80206d:	50                   	push   %eax
  80206e:	6a 2e                	push   $0x2e
  802070:	e8 c7 f9 ff ff       	call   801a3c <syscall>
  802075:	83 c4 18             	add    $0x18,%esp
}
  802078:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80207b:	c9                   	leave  
  80207c:	c3                   	ret    

0080207d <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  80207d:	55                   	push   %ebp
  80207e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  802080:	8b 55 0c             	mov    0xc(%ebp),%edx
  802083:	8b 45 08             	mov    0x8(%ebp),%eax
  802086:	6a 00                	push   $0x0
  802088:	6a 00                	push   $0x0
  80208a:	6a 00                	push   $0x0
  80208c:	52                   	push   %edx
  80208d:	50                   	push   %eax
  80208e:	6a 2f                	push   $0x2f
  802090:	e8 a7 f9 ff ff       	call   801a3c <syscall>
  802095:	83 c4 18             	add    $0x18,%esp
}
  802098:	c9                   	leave  
  802099:	c3                   	ret    

0080209a <print_mem_block_lists>:
//===========================
// PRINT MEM BLOCK LISTS:
//===========================

void print_mem_block_lists()
{
  80209a:	55                   	push   %ebp
  80209b:	89 e5                	mov    %esp,%ebp
  80209d:	83 ec 18             	sub    $0x18,%esp
	cprintf("\n=========================================\n");
  8020a0:	83 ec 0c             	sub    $0xc,%esp
  8020a3:	68 40 3c 80 00       	push   $0x803c40
  8020a8:	e8 dd e6 ff ff       	call   80078a <cprintf>
  8020ad:	83 c4 10             	add    $0x10,%esp
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
  8020b0:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nFreeMemBlocksList:\n");
  8020b7:	83 ec 0c             	sub    $0xc,%esp
  8020ba:	68 6c 3c 80 00       	push   $0x803c6c
  8020bf:	e8 c6 e6 ff ff       	call   80078a <cprintf>
  8020c4:	83 c4 10             	add    $0x10,%esp
	uint8 sorted = 1 ;
  8020c7:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &FreeMemBlocksList)
  8020cb:	a1 38 41 80 00       	mov    0x804138,%eax
  8020d0:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8020d3:	eb 56                	jmp    80212b <print_mem_block_lists+0x91>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  8020d5:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8020d9:	74 1c                	je     8020f7 <print_mem_block_lists+0x5d>
  8020db:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8020de:	8b 50 08             	mov    0x8(%eax),%edx
  8020e1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8020e4:	8b 48 08             	mov    0x8(%eax),%ecx
  8020e7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8020ea:	8b 40 0c             	mov    0xc(%eax),%eax
  8020ed:	01 c8                	add    %ecx,%eax
  8020ef:	39 c2                	cmp    %eax,%edx
  8020f1:	73 04                	jae    8020f7 <print_mem_block_lists+0x5d>
			sorted = 0 ;
  8020f3:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  8020f7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8020fa:	8b 50 08             	mov    0x8(%eax),%edx
  8020fd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802100:	8b 40 0c             	mov    0xc(%eax),%eax
  802103:	01 c2                	add    %eax,%edx
  802105:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802108:	8b 40 08             	mov    0x8(%eax),%eax
  80210b:	83 ec 04             	sub    $0x4,%esp
  80210e:	52                   	push   %edx
  80210f:	50                   	push   %eax
  802110:	68 81 3c 80 00       	push   $0x803c81
  802115:	e8 70 e6 ff ff       	call   80078a <cprintf>
  80211a:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  80211d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802120:	89 45 f0             	mov    %eax,-0x10(%ebp)
	cprintf("\n=========================================\n");
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
	cprintf("\nFreeMemBlocksList:\n");
	uint8 sorted = 1 ;
	LIST_FOREACH(blk, &FreeMemBlocksList)
  802123:	a1 40 41 80 00       	mov    0x804140,%eax
  802128:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80212b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80212f:	74 07                	je     802138 <print_mem_block_lists+0x9e>
  802131:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802134:	8b 00                	mov    (%eax),%eax
  802136:	eb 05                	jmp    80213d <print_mem_block_lists+0xa3>
  802138:	b8 00 00 00 00       	mov    $0x0,%eax
  80213d:	a3 40 41 80 00       	mov    %eax,0x804140
  802142:	a1 40 41 80 00       	mov    0x804140,%eax
  802147:	85 c0                	test   %eax,%eax
  802149:	75 8a                	jne    8020d5 <print_mem_block_lists+0x3b>
  80214b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80214f:	75 84                	jne    8020d5 <print_mem_block_lists+0x3b>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;
  802151:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  802155:	75 10                	jne    802167 <print_mem_block_lists+0xcd>
  802157:	83 ec 0c             	sub    $0xc,%esp
  80215a:	68 90 3c 80 00       	push   $0x803c90
  80215f:	e8 26 e6 ff ff       	call   80078a <cprintf>
  802164:	83 c4 10             	add    $0x10,%esp

	lastBlk = NULL ;
  802167:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nAllocMemBlocksList:\n");
  80216e:	83 ec 0c             	sub    $0xc,%esp
  802171:	68 b4 3c 80 00       	push   $0x803cb4
  802176:	e8 0f e6 ff ff       	call   80078a <cprintf>
  80217b:	83 c4 10             	add    $0x10,%esp
	sorted = 1 ;
  80217e:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &AllocMemBlocksList)
  802182:	a1 40 40 80 00       	mov    0x804040,%eax
  802187:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80218a:	eb 56                	jmp    8021e2 <print_mem_block_lists+0x148>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  80218c:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802190:	74 1c                	je     8021ae <print_mem_block_lists+0x114>
  802192:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802195:	8b 50 08             	mov    0x8(%eax),%edx
  802198:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80219b:	8b 48 08             	mov    0x8(%eax),%ecx
  80219e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8021a1:	8b 40 0c             	mov    0xc(%eax),%eax
  8021a4:	01 c8                	add    %ecx,%eax
  8021a6:	39 c2                	cmp    %eax,%edx
  8021a8:	73 04                	jae    8021ae <print_mem_block_lists+0x114>
			sorted = 0 ;
  8021aa:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  8021ae:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8021b1:	8b 50 08             	mov    0x8(%eax),%edx
  8021b4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8021b7:	8b 40 0c             	mov    0xc(%eax),%eax
  8021ba:	01 c2                	add    %eax,%edx
  8021bc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8021bf:	8b 40 08             	mov    0x8(%eax),%eax
  8021c2:	83 ec 04             	sub    $0x4,%esp
  8021c5:	52                   	push   %edx
  8021c6:	50                   	push   %eax
  8021c7:	68 81 3c 80 00       	push   $0x803c81
  8021cc:	e8 b9 e5 ff ff       	call   80078a <cprintf>
  8021d1:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  8021d4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8021d7:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;

	lastBlk = NULL ;
	cprintf("\nAllocMemBlocksList:\n");
	sorted = 1 ;
	LIST_FOREACH(blk, &AllocMemBlocksList)
  8021da:	a1 48 40 80 00       	mov    0x804048,%eax
  8021df:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8021e2:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8021e6:	74 07                	je     8021ef <print_mem_block_lists+0x155>
  8021e8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8021eb:	8b 00                	mov    (%eax),%eax
  8021ed:	eb 05                	jmp    8021f4 <print_mem_block_lists+0x15a>
  8021ef:	b8 00 00 00 00       	mov    $0x0,%eax
  8021f4:	a3 48 40 80 00       	mov    %eax,0x804048
  8021f9:	a1 48 40 80 00       	mov    0x804048,%eax
  8021fe:	85 c0                	test   %eax,%eax
  802200:	75 8a                	jne    80218c <print_mem_block_lists+0xf2>
  802202:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802206:	75 84                	jne    80218c <print_mem_block_lists+0xf2>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nAllocMemBlocksList is NOT SORTED!!\n") ;
  802208:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  80220c:	75 10                	jne    80221e <print_mem_block_lists+0x184>
  80220e:	83 ec 0c             	sub    $0xc,%esp
  802211:	68 cc 3c 80 00       	push   $0x803ccc
  802216:	e8 6f e5 ff ff       	call   80078a <cprintf>
  80221b:	83 c4 10             	add    $0x10,%esp
	cprintf("\n=========================================\n");
  80221e:	83 ec 0c             	sub    $0xc,%esp
  802221:	68 40 3c 80 00       	push   $0x803c40
  802226:	e8 5f e5 ff ff       	call   80078a <cprintf>
  80222b:	83 c4 10             	add    $0x10,%esp

}
  80222e:	90                   	nop
  80222f:	c9                   	leave  
  802230:	c3                   	ret    

00802231 <initialize_MemBlocksList>:

//===============================
// [1] INITIALIZE AVAILABLE LIST:
//===============================
void initialize_MemBlocksList(uint32 numOfBlocks)
{
  802231:	55                   	push   %ebp
  802232:	89 e5                	mov    %esp,%ebp
  802234:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] initialize_MemBlocksList
	// Write your code here, remove the panic and write your code
	//panic("initialize_MemBlocksList() is not implemented yet...!!");
	uint32 n = numOfBlocks;
  802237:	8b 45 08             	mov    0x8(%ebp),%eax
  80223a:	89 45 f0             	mov    %eax,-0x10(%ebp)

	LIST_INIT(&AvailableMemBlocksList);
  80223d:	c7 05 48 41 80 00 00 	movl   $0x0,0x804148
  802244:	00 00 00 
  802247:	c7 05 4c 41 80 00 00 	movl   $0x0,0x80414c
  80224e:	00 00 00 
  802251:	c7 05 54 41 80 00 00 	movl   $0x0,0x804154
  802258:	00 00 00 
	for(int i = 0; i<n;i++)
  80225b:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  802262:	e9 9e 00 00 00       	jmp    802305 <initialize_MemBlocksList+0xd4>
	{
		LIST_INSERT_HEAD(&AvailableMemBlocksList, &(MemBlockNodes[i]));
  802267:	a1 50 40 80 00       	mov    0x804050,%eax
  80226c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80226f:	c1 e2 04             	shl    $0x4,%edx
  802272:	01 d0                	add    %edx,%eax
  802274:	85 c0                	test   %eax,%eax
  802276:	75 14                	jne    80228c <initialize_MemBlocksList+0x5b>
  802278:	83 ec 04             	sub    $0x4,%esp
  80227b:	68 f4 3c 80 00       	push   $0x803cf4
  802280:	6a 47                	push   $0x47
  802282:	68 17 3d 80 00       	push   $0x803d17
  802287:	e8 4a e2 ff ff       	call   8004d6 <_panic>
  80228c:	a1 50 40 80 00       	mov    0x804050,%eax
  802291:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802294:	c1 e2 04             	shl    $0x4,%edx
  802297:	01 d0                	add    %edx,%eax
  802299:	8b 15 48 41 80 00    	mov    0x804148,%edx
  80229f:	89 10                	mov    %edx,(%eax)
  8022a1:	8b 00                	mov    (%eax),%eax
  8022a3:	85 c0                	test   %eax,%eax
  8022a5:	74 18                	je     8022bf <initialize_MemBlocksList+0x8e>
  8022a7:	a1 48 41 80 00       	mov    0x804148,%eax
  8022ac:	8b 15 50 40 80 00    	mov    0x804050,%edx
  8022b2:	8b 4d f4             	mov    -0xc(%ebp),%ecx
  8022b5:	c1 e1 04             	shl    $0x4,%ecx
  8022b8:	01 ca                	add    %ecx,%edx
  8022ba:	89 50 04             	mov    %edx,0x4(%eax)
  8022bd:	eb 12                	jmp    8022d1 <initialize_MemBlocksList+0xa0>
  8022bf:	a1 50 40 80 00       	mov    0x804050,%eax
  8022c4:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8022c7:	c1 e2 04             	shl    $0x4,%edx
  8022ca:	01 d0                	add    %edx,%eax
  8022cc:	a3 4c 41 80 00       	mov    %eax,0x80414c
  8022d1:	a1 50 40 80 00       	mov    0x804050,%eax
  8022d6:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8022d9:	c1 e2 04             	shl    $0x4,%edx
  8022dc:	01 d0                	add    %edx,%eax
  8022de:	a3 48 41 80 00       	mov    %eax,0x804148
  8022e3:	a1 50 40 80 00       	mov    0x804050,%eax
  8022e8:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8022eb:	c1 e2 04             	shl    $0x4,%edx
  8022ee:	01 d0                	add    %edx,%eax
  8022f0:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8022f7:	a1 54 41 80 00       	mov    0x804154,%eax
  8022fc:	40                   	inc    %eax
  8022fd:	a3 54 41 80 00       	mov    %eax,0x804154
	// Write your code here, remove the panic and write your code
	//panic("initialize_MemBlocksList() is not implemented yet...!!");
	uint32 n = numOfBlocks;

	LIST_INIT(&AvailableMemBlocksList);
	for(int i = 0; i<n;i++)
  802302:	ff 45 f4             	incl   -0xc(%ebp)
  802305:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802308:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  80230b:	0f 82 56 ff ff ff    	jb     802267 <initialize_MemBlocksList+0x36>
	{
		LIST_INSERT_HEAD(&AvailableMemBlocksList, &(MemBlockNodes[i]));
	}
}
  802311:	90                   	nop
  802312:	c9                   	leave  
  802313:	c3                   	ret    

00802314 <find_block>:

//===============================
// [2] FIND BLOCK:
//===============================
struct MemBlock *find_block(struct MemBlock_List *blockList, uint32 va)
{
  802314:	55                   	push   %ebp
  802315:	89 e5                	mov    %esp,%ebp
  802317:	83 ec 10             	sub    $0x10,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] find_block
	// Write your code here, remove the panic and write your code
	//panic("find_block() is not implemented yet...!!");
	uint32 virAddress = va;
  80231a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80231d:	89 45 f4             	mov    %eax,-0xc(%ebp)
	struct MemBlock* blk;
	int found = 0;
  802320:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	LIST_FOREACH(blk, &(AllocMemBlocksList))
  802327:	a1 40 40 80 00       	mov    0x804040,%eax
  80232c:	89 45 fc             	mov    %eax,-0x4(%ebp)
  80232f:	eb 23                	jmp    802354 <find_block+0x40>
	{
		if(blk->sva == virAddress)
  802331:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802334:	8b 40 08             	mov    0x8(%eax),%eax
  802337:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  80233a:	75 09                	jne    802345 <find_block+0x31>
		{
			found = 1;
  80233c:	c7 45 f8 01 00 00 00 	movl   $0x1,-0x8(%ebp)
			break;
  802343:	eb 35                	jmp    80237a <find_block+0x66>
		}
		else
		{
			found = 0;
  802345:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	//panic("find_block() is not implemented yet...!!");
	uint32 virAddress = va;
	struct MemBlock* blk;
	int found = 0;

	LIST_FOREACH(blk, &(AllocMemBlocksList))
  80234c:	a1 48 40 80 00       	mov    0x804048,%eax
  802351:	89 45 fc             	mov    %eax,-0x4(%ebp)
  802354:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  802358:	74 07                	je     802361 <find_block+0x4d>
  80235a:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80235d:	8b 00                	mov    (%eax),%eax
  80235f:	eb 05                	jmp    802366 <find_block+0x52>
  802361:	b8 00 00 00 00       	mov    $0x0,%eax
  802366:	a3 48 40 80 00       	mov    %eax,0x804048
  80236b:	a1 48 40 80 00       	mov    0x804048,%eax
  802370:	85 c0                	test   %eax,%eax
  802372:	75 bd                	jne    802331 <find_block+0x1d>
  802374:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  802378:	75 b7                	jne    802331 <find_block+0x1d>
		{
			found = 0;
			continue;
		}
	}
	if(found == 1)
  80237a:	83 7d f8 01          	cmpl   $0x1,-0x8(%ebp)
  80237e:	75 05                	jne    802385 <find_block+0x71>
	{
		return blk;
  802380:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802383:	eb 05                	jmp    80238a <find_block+0x76>
	}
	else
	{
		return NULL;
  802385:	b8 00 00 00 00       	mov    $0x0,%eax
	}
}
  80238a:	c9                   	leave  
  80238b:	c3                   	ret    

0080238c <insert_sorted_allocList>:

//=========================================
// [3] INSERT BLOCK IN ALLOC LIST [SORTED]:
//=========================================
void insert_sorted_allocList(struct MemBlock *blockToInsert)
{
  80238c:	55                   	push   %ebp
  80238d:	89 e5                	mov    %esp,%ebp
  80238f:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] insert_sorted_allocList
	// Write your code here, remove the panic and write your code
	//panic("insert_sorted_allocList() is not implemented yet...!!");
	struct MemBlock* blk;
	struct MemBlock* newblk = blockToInsert;
  802392:	8b 45 08             	mov    0x8(%ebp),%eax
  802395:	89 45 f0             	mov    %eax,-0x10(%ebp)

	if((LIST_EMPTY(&AllocMemBlocksList)) || (newblk->sva < LIST_FIRST(&AllocMemBlocksList)->sva))
  802398:	a1 40 40 80 00       	mov    0x804040,%eax
  80239d:	85 c0                	test   %eax,%eax
  80239f:	74 12                	je     8023b3 <insert_sorted_allocList+0x27>
  8023a1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8023a4:	8b 50 08             	mov    0x8(%eax),%edx
  8023a7:	a1 40 40 80 00       	mov    0x804040,%eax
  8023ac:	8b 40 08             	mov    0x8(%eax),%eax
  8023af:	39 c2                	cmp    %eax,%edx
  8023b1:	73 65                	jae    802418 <insert_sorted_allocList+0x8c>
	{
		LIST_INSERT_HEAD(&(AllocMemBlocksList), newblk);
  8023b3:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8023b7:	75 14                	jne    8023cd <insert_sorted_allocList+0x41>
  8023b9:	83 ec 04             	sub    $0x4,%esp
  8023bc:	68 f4 3c 80 00       	push   $0x803cf4
  8023c1:	6a 7b                	push   $0x7b
  8023c3:	68 17 3d 80 00       	push   $0x803d17
  8023c8:	e8 09 e1 ff ff       	call   8004d6 <_panic>
  8023cd:	8b 15 40 40 80 00    	mov    0x804040,%edx
  8023d3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8023d6:	89 10                	mov    %edx,(%eax)
  8023d8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8023db:	8b 00                	mov    (%eax),%eax
  8023dd:	85 c0                	test   %eax,%eax
  8023df:	74 0d                	je     8023ee <insert_sorted_allocList+0x62>
  8023e1:	a1 40 40 80 00       	mov    0x804040,%eax
  8023e6:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8023e9:	89 50 04             	mov    %edx,0x4(%eax)
  8023ec:	eb 08                	jmp    8023f6 <insert_sorted_allocList+0x6a>
  8023ee:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8023f1:	a3 44 40 80 00       	mov    %eax,0x804044
  8023f6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8023f9:	a3 40 40 80 00       	mov    %eax,0x804040
  8023fe:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802401:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802408:	a1 4c 40 80 00       	mov    0x80404c,%eax
  80240d:	40                   	inc    %eax
  80240e:	a3 4c 40 80 00       	mov    %eax,0x80404c
  802413:	e9 5f 01 00 00       	jmp    802577 <insert_sorted_allocList+0x1eb>
	}
	else if(newblk->sva > LIST_LAST(&AllocMemBlocksList)->sva)
  802418:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80241b:	8b 50 08             	mov    0x8(%eax),%edx
  80241e:	a1 44 40 80 00       	mov    0x804044,%eax
  802423:	8b 40 08             	mov    0x8(%eax),%eax
  802426:	39 c2                	cmp    %eax,%edx
  802428:	76 65                	jbe    80248f <insert_sorted_allocList+0x103>
	{
		LIST_INSERT_TAIL(&AllocMemBlocksList, newblk);
  80242a:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80242e:	75 14                	jne    802444 <insert_sorted_allocList+0xb8>
  802430:	83 ec 04             	sub    $0x4,%esp
  802433:	68 30 3d 80 00       	push   $0x803d30
  802438:	6a 7f                	push   $0x7f
  80243a:	68 17 3d 80 00       	push   $0x803d17
  80243f:	e8 92 e0 ff ff       	call   8004d6 <_panic>
  802444:	8b 15 44 40 80 00    	mov    0x804044,%edx
  80244a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80244d:	89 50 04             	mov    %edx,0x4(%eax)
  802450:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802453:	8b 40 04             	mov    0x4(%eax),%eax
  802456:	85 c0                	test   %eax,%eax
  802458:	74 0c                	je     802466 <insert_sorted_allocList+0xda>
  80245a:	a1 44 40 80 00       	mov    0x804044,%eax
  80245f:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802462:	89 10                	mov    %edx,(%eax)
  802464:	eb 08                	jmp    80246e <insert_sorted_allocList+0xe2>
  802466:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802469:	a3 40 40 80 00       	mov    %eax,0x804040
  80246e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802471:	a3 44 40 80 00       	mov    %eax,0x804044
  802476:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802479:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80247f:	a1 4c 40 80 00       	mov    0x80404c,%eax
  802484:	40                   	inc    %eax
  802485:	a3 4c 40 80 00       	mov    %eax,0x80404c
				LIST_INSERT_AFTER(&AllocMemBlocksList, blk, newblk);
				break;
			}
		}
	}
}
  80248a:	e9 e8 00 00 00       	jmp    802577 <insert_sorted_allocList+0x1eb>
	{
		LIST_INSERT_TAIL(&AllocMemBlocksList, newblk);
	}
	else
	{
		LIST_FOREACH(blk, &AllocMemBlocksList)
  80248f:	a1 40 40 80 00       	mov    0x804040,%eax
  802494:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802497:	e9 ab 00 00 00       	jmp    802547 <insert_sorted_allocList+0x1bb>
		{
			if(blk->prev_next_info.le_next != NULL && newblk->sva > blk->sva  && newblk->sva < blk->prev_next_info.le_next->sva)
  80249c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80249f:	8b 00                	mov    (%eax),%eax
  8024a1:	85 c0                	test   %eax,%eax
  8024a3:	0f 84 96 00 00 00    	je     80253f <insert_sorted_allocList+0x1b3>
  8024a9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8024ac:	8b 50 08             	mov    0x8(%eax),%edx
  8024af:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024b2:	8b 40 08             	mov    0x8(%eax),%eax
  8024b5:	39 c2                	cmp    %eax,%edx
  8024b7:	0f 86 82 00 00 00    	jbe    80253f <insert_sorted_allocList+0x1b3>
  8024bd:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8024c0:	8b 50 08             	mov    0x8(%eax),%edx
  8024c3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024c6:	8b 00                	mov    (%eax),%eax
  8024c8:	8b 40 08             	mov    0x8(%eax),%eax
  8024cb:	39 c2                	cmp    %eax,%edx
  8024cd:	73 70                	jae    80253f <insert_sorted_allocList+0x1b3>
			{
				LIST_INSERT_AFTER(&AllocMemBlocksList, blk, newblk);
  8024cf:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8024d3:	74 06                	je     8024db <insert_sorted_allocList+0x14f>
  8024d5:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8024d9:	75 17                	jne    8024f2 <insert_sorted_allocList+0x166>
  8024db:	83 ec 04             	sub    $0x4,%esp
  8024de:	68 54 3d 80 00       	push   $0x803d54
  8024e3:	68 87 00 00 00       	push   $0x87
  8024e8:	68 17 3d 80 00       	push   $0x803d17
  8024ed:	e8 e4 df ff ff       	call   8004d6 <_panic>
  8024f2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024f5:	8b 10                	mov    (%eax),%edx
  8024f7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8024fa:	89 10                	mov    %edx,(%eax)
  8024fc:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8024ff:	8b 00                	mov    (%eax),%eax
  802501:	85 c0                	test   %eax,%eax
  802503:	74 0b                	je     802510 <insert_sorted_allocList+0x184>
  802505:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802508:	8b 00                	mov    (%eax),%eax
  80250a:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80250d:	89 50 04             	mov    %edx,0x4(%eax)
  802510:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802513:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802516:	89 10                	mov    %edx,(%eax)
  802518:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80251b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80251e:	89 50 04             	mov    %edx,0x4(%eax)
  802521:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802524:	8b 00                	mov    (%eax),%eax
  802526:	85 c0                	test   %eax,%eax
  802528:	75 08                	jne    802532 <insert_sorted_allocList+0x1a6>
  80252a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80252d:	a3 44 40 80 00       	mov    %eax,0x804044
  802532:	a1 4c 40 80 00       	mov    0x80404c,%eax
  802537:	40                   	inc    %eax
  802538:	a3 4c 40 80 00       	mov    %eax,0x80404c
				break;
  80253d:	eb 38                	jmp    802577 <insert_sorted_allocList+0x1eb>
	{
		LIST_INSERT_TAIL(&AllocMemBlocksList, newblk);
	}
	else
	{
		LIST_FOREACH(blk, &AllocMemBlocksList)
  80253f:	a1 48 40 80 00       	mov    0x804048,%eax
  802544:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802547:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80254b:	74 07                	je     802554 <insert_sorted_allocList+0x1c8>
  80254d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802550:	8b 00                	mov    (%eax),%eax
  802552:	eb 05                	jmp    802559 <insert_sorted_allocList+0x1cd>
  802554:	b8 00 00 00 00       	mov    $0x0,%eax
  802559:	a3 48 40 80 00       	mov    %eax,0x804048
  80255e:	a1 48 40 80 00       	mov    0x804048,%eax
  802563:	85 c0                	test   %eax,%eax
  802565:	0f 85 31 ff ff ff    	jne    80249c <insert_sorted_allocList+0x110>
  80256b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80256f:	0f 85 27 ff ff ff    	jne    80249c <insert_sorted_allocList+0x110>
				LIST_INSERT_AFTER(&AllocMemBlocksList, blk, newblk);
				break;
			}
		}
	}
}
  802575:	eb 00                	jmp    802577 <insert_sorted_allocList+0x1eb>
  802577:	90                   	nop
  802578:	c9                   	leave  
  802579:	c3                   	ret    

0080257a <alloc_block_FF>:

//=========================================
// [4] ALLOCATE BLOCK BY FIRST FIT:
//=========================================
struct MemBlock *alloc_block_FF(uint32 size)
{
  80257a:	55                   	push   %ebp
  80257b:	89 e5                	mov    %esp,%ebp
  80257d:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_FF
	// Write your code here, remove the panic and write your code
	//panic("alloc_block_FF() is not implemented yet...!!");
	uint32 versize = size;
  802580:	8b 45 08             	mov    0x8(%ebp),%eax
  802583:	89 45 f0             	mov    %eax,-0x10(%ebp)
	struct MemBlock* blk;
	struct MemBlock* newblk = LIST_FIRST(&AvailableMemBlocksList);
  802586:	a1 48 41 80 00       	mov    0x804148,%eax
  80258b:	89 45 ec             	mov    %eax,-0x14(%ebp)

	LIST_FOREACH(blk,&FreeMemBlocksList)
  80258e:	a1 38 41 80 00       	mov    0x804138,%eax
  802593:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802596:	e9 77 01 00 00       	jmp    802712 <alloc_block_FF+0x198>
	{
		if(blk->size == versize)
  80259b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80259e:	8b 40 0c             	mov    0xc(%eax),%eax
  8025a1:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8025a4:	0f 85 8a 00 00 00    	jne    802634 <alloc_block_FF+0xba>
		{
			LIST_REMOVE(&FreeMemBlocksList,blk);
  8025aa:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8025ae:	75 17                	jne    8025c7 <alloc_block_FF+0x4d>
  8025b0:	83 ec 04             	sub    $0x4,%esp
  8025b3:	68 88 3d 80 00       	push   $0x803d88
  8025b8:	68 9e 00 00 00       	push   $0x9e
  8025bd:	68 17 3d 80 00       	push   $0x803d17
  8025c2:	e8 0f df ff ff       	call   8004d6 <_panic>
  8025c7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025ca:	8b 00                	mov    (%eax),%eax
  8025cc:	85 c0                	test   %eax,%eax
  8025ce:	74 10                	je     8025e0 <alloc_block_FF+0x66>
  8025d0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025d3:	8b 00                	mov    (%eax),%eax
  8025d5:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8025d8:	8b 52 04             	mov    0x4(%edx),%edx
  8025db:	89 50 04             	mov    %edx,0x4(%eax)
  8025de:	eb 0b                	jmp    8025eb <alloc_block_FF+0x71>
  8025e0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025e3:	8b 40 04             	mov    0x4(%eax),%eax
  8025e6:	a3 3c 41 80 00       	mov    %eax,0x80413c
  8025eb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025ee:	8b 40 04             	mov    0x4(%eax),%eax
  8025f1:	85 c0                	test   %eax,%eax
  8025f3:	74 0f                	je     802604 <alloc_block_FF+0x8a>
  8025f5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025f8:	8b 40 04             	mov    0x4(%eax),%eax
  8025fb:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8025fe:	8b 12                	mov    (%edx),%edx
  802600:	89 10                	mov    %edx,(%eax)
  802602:	eb 0a                	jmp    80260e <alloc_block_FF+0x94>
  802604:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802607:	8b 00                	mov    (%eax),%eax
  802609:	a3 38 41 80 00       	mov    %eax,0x804138
  80260e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802611:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802617:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80261a:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802621:	a1 44 41 80 00       	mov    0x804144,%eax
  802626:	48                   	dec    %eax
  802627:	a3 44 41 80 00       	mov    %eax,0x804144
			return blk;
  80262c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80262f:	e9 11 01 00 00       	jmp    802745 <alloc_block_FF+0x1cb>
		}
		else if(blk->size > versize)
  802634:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802637:	8b 40 0c             	mov    0xc(%eax),%eax
  80263a:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  80263d:	0f 86 c7 00 00 00    	jbe    80270a <alloc_block_FF+0x190>
		{
			LIST_REMOVE(&AvailableMemBlocksList,newblk);
  802643:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802647:	75 17                	jne    802660 <alloc_block_FF+0xe6>
  802649:	83 ec 04             	sub    $0x4,%esp
  80264c:	68 88 3d 80 00       	push   $0x803d88
  802651:	68 a3 00 00 00       	push   $0xa3
  802656:	68 17 3d 80 00       	push   $0x803d17
  80265b:	e8 76 de ff ff       	call   8004d6 <_panic>
  802660:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802663:	8b 00                	mov    (%eax),%eax
  802665:	85 c0                	test   %eax,%eax
  802667:	74 10                	je     802679 <alloc_block_FF+0xff>
  802669:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80266c:	8b 00                	mov    (%eax),%eax
  80266e:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802671:	8b 52 04             	mov    0x4(%edx),%edx
  802674:	89 50 04             	mov    %edx,0x4(%eax)
  802677:	eb 0b                	jmp    802684 <alloc_block_FF+0x10a>
  802679:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80267c:	8b 40 04             	mov    0x4(%eax),%eax
  80267f:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802684:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802687:	8b 40 04             	mov    0x4(%eax),%eax
  80268a:	85 c0                	test   %eax,%eax
  80268c:	74 0f                	je     80269d <alloc_block_FF+0x123>
  80268e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802691:	8b 40 04             	mov    0x4(%eax),%eax
  802694:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802697:	8b 12                	mov    (%edx),%edx
  802699:	89 10                	mov    %edx,(%eax)
  80269b:	eb 0a                	jmp    8026a7 <alloc_block_FF+0x12d>
  80269d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8026a0:	8b 00                	mov    (%eax),%eax
  8026a2:	a3 48 41 80 00       	mov    %eax,0x804148
  8026a7:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8026aa:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8026b0:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8026b3:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8026ba:	a1 54 41 80 00       	mov    0x804154,%eax
  8026bf:	48                   	dec    %eax
  8026c0:	a3 54 41 80 00       	mov    %eax,0x804154
			newblk->size = versize;
  8026c5:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8026c8:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8026cb:	89 50 0c             	mov    %edx,0xc(%eax)
			blk->size = blk->size-versize;
  8026ce:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026d1:	8b 40 0c             	mov    0xc(%eax),%eax
  8026d4:	2b 45 f0             	sub    -0x10(%ebp),%eax
  8026d7:	89 c2                	mov    %eax,%edx
  8026d9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026dc:	89 50 0c             	mov    %edx,0xc(%eax)
			uint32 newveradd = blk->sva;
  8026df:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026e2:	8b 40 08             	mov    0x8(%eax),%eax
  8026e5:	89 45 e8             	mov    %eax,-0x18(%ebp)
			blk->sva+=newblk->size;
  8026e8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026eb:	8b 50 08             	mov    0x8(%eax),%edx
  8026ee:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8026f1:	8b 40 0c             	mov    0xc(%eax),%eax
  8026f4:	01 c2                	add    %eax,%edx
  8026f6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026f9:	89 50 08             	mov    %edx,0x8(%eax)
			newblk->sva = newveradd;
  8026fc:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8026ff:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802702:	89 50 08             	mov    %edx,0x8(%eax)
			return newblk;
  802705:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802708:	eb 3b                	jmp    802745 <alloc_block_FF+0x1cb>
	//panic("alloc_block_FF() is not implemented yet...!!");
	uint32 versize = size;
	struct MemBlock* blk;
	struct MemBlock* newblk = LIST_FIRST(&AvailableMemBlocksList);

	LIST_FOREACH(blk,&FreeMemBlocksList)
  80270a:	a1 40 41 80 00       	mov    0x804140,%eax
  80270f:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802712:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802716:	74 07                	je     80271f <alloc_block_FF+0x1a5>
  802718:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80271b:	8b 00                	mov    (%eax),%eax
  80271d:	eb 05                	jmp    802724 <alloc_block_FF+0x1aa>
  80271f:	b8 00 00 00 00       	mov    $0x0,%eax
  802724:	a3 40 41 80 00       	mov    %eax,0x804140
  802729:	a1 40 41 80 00       	mov    0x804140,%eax
  80272e:	85 c0                	test   %eax,%eax
  802730:	0f 85 65 fe ff ff    	jne    80259b <alloc_block_FF+0x21>
  802736:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80273a:	0f 85 5b fe ff ff    	jne    80259b <alloc_block_FF+0x21>
			blk->sva+=newblk->size;
			newblk->sva = newveradd;
			return newblk;
		}
	}
	return NULL;
  802740:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802745:	c9                   	leave  
  802746:	c3                   	ret    

00802747 <alloc_block_BF>:

//=========================================
// [5] ALLOCATE BLOCK BY BEST FIT:
//=========================================
struct MemBlock *alloc_block_BF(uint32 size)
{
  802747:	55                   	push   %ebp
  802748:	89 e5                	mov    %esp,%ebp
  80274a:	83 ec 28             	sub    $0x28,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_BF
	// Write your code here, remove the panic and write your code
	//panic("alloc_block_BF() is not implemented yet...!!");
	uint32 versize=size;
  80274d:	8b 45 08             	mov    0x8(%ebp),%eax
  802750:	89 45 e8             	mov    %eax,-0x18(%ebp)
	struct MemBlock* blk;
	struct MemBlock* newblk=LIST_FIRST(&AvailableMemBlocksList);
  802753:	a1 48 41 80 00       	mov    0x804148,%eax
  802758:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	uint32 newveradd;
	uint32 newsize;
	int size_free = LIST_SIZE(&FreeMemBlocksList);
  80275b:	a1 44 41 80 00       	mov    0x804144,%eax
  802760:	89 45 e0             	mov    %eax,-0x20(%ebp)

	LIST_FOREACH(blk, &FreeMemBlocksList)
  802763:	a1 38 41 80 00       	mov    0x804138,%eax
  802768:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80276b:	e9 a1 00 00 00       	jmp    802811 <alloc_block_BF+0xca>
	{
		if(blk->size == versize)
  802770:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802773:	8b 40 0c             	mov    0xc(%eax),%eax
  802776:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  802779:	0f 85 8a 00 00 00    	jne    802809 <alloc_block_BF+0xc2>
		{
			LIST_REMOVE(&FreeMemBlocksList, blk);
  80277f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802783:	75 17                	jne    80279c <alloc_block_BF+0x55>
  802785:	83 ec 04             	sub    $0x4,%esp
  802788:	68 88 3d 80 00       	push   $0x803d88
  80278d:	68 c2 00 00 00       	push   $0xc2
  802792:	68 17 3d 80 00       	push   $0x803d17
  802797:	e8 3a dd ff ff       	call   8004d6 <_panic>
  80279c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80279f:	8b 00                	mov    (%eax),%eax
  8027a1:	85 c0                	test   %eax,%eax
  8027a3:	74 10                	je     8027b5 <alloc_block_BF+0x6e>
  8027a5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027a8:	8b 00                	mov    (%eax),%eax
  8027aa:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8027ad:	8b 52 04             	mov    0x4(%edx),%edx
  8027b0:	89 50 04             	mov    %edx,0x4(%eax)
  8027b3:	eb 0b                	jmp    8027c0 <alloc_block_BF+0x79>
  8027b5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027b8:	8b 40 04             	mov    0x4(%eax),%eax
  8027bb:	a3 3c 41 80 00       	mov    %eax,0x80413c
  8027c0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027c3:	8b 40 04             	mov    0x4(%eax),%eax
  8027c6:	85 c0                	test   %eax,%eax
  8027c8:	74 0f                	je     8027d9 <alloc_block_BF+0x92>
  8027ca:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027cd:	8b 40 04             	mov    0x4(%eax),%eax
  8027d0:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8027d3:	8b 12                	mov    (%edx),%edx
  8027d5:	89 10                	mov    %edx,(%eax)
  8027d7:	eb 0a                	jmp    8027e3 <alloc_block_BF+0x9c>
  8027d9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027dc:	8b 00                	mov    (%eax),%eax
  8027de:	a3 38 41 80 00       	mov    %eax,0x804138
  8027e3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027e6:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8027ec:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027ef:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8027f6:	a1 44 41 80 00       	mov    0x804144,%eax
  8027fb:	48                   	dec    %eax
  8027fc:	a3 44 41 80 00       	mov    %eax,0x804144
			return blk;
  802801:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802804:	e9 11 02 00 00       	jmp    802a1a <alloc_block_BF+0x2d3>
	struct MemBlock* newblk=LIST_FIRST(&AvailableMemBlocksList);
	uint32 newveradd;
	uint32 newsize;
	int size_free = LIST_SIZE(&FreeMemBlocksList);

	LIST_FOREACH(blk, &FreeMemBlocksList)
  802809:	a1 40 41 80 00       	mov    0x804140,%eax
  80280e:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802811:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802815:	74 07                	je     80281e <alloc_block_BF+0xd7>
  802817:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80281a:	8b 00                	mov    (%eax),%eax
  80281c:	eb 05                	jmp    802823 <alloc_block_BF+0xdc>
  80281e:	b8 00 00 00 00       	mov    $0x0,%eax
  802823:	a3 40 41 80 00       	mov    %eax,0x804140
  802828:	a1 40 41 80 00       	mov    0x804140,%eax
  80282d:	85 c0                	test   %eax,%eax
  80282f:	0f 85 3b ff ff ff    	jne    802770 <alloc_block_BF+0x29>
  802835:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802839:	0f 85 31 ff ff ff    	jne    802770 <alloc_block_BF+0x29>
		{
			LIST_REMOVE(&FreeMemBlocksList, blk);
			return blk;
		}
	}
	LIST_FOREACH(blk, &FreeMemBlocksList)
  80283f:	a1 38 41 80 00       	mov    0x804138,%eax
  802844:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802847:	eb 27                	jmp    802870 <alloc_block_BF+0x129>
	{
		if(blk->size > versize)
  802849:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80284c:	8b 40 0c             	mov    0xc(%eax),%eax
  80284f:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  802852:	76 14                	jbe    802868 <alloc_block_BF+0x121>
		{
			newsize = blk->size;
  802854:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802857:	8b 40 0c             	mov    0xc(%eax),%eax
  80285a:	89 45 ec             	mov    %eax,-0x14(%ebp)
			newveradd = blk->sva;
  80285d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802860:	8b 40 08             	mov    0x8(%eax),%eax
  802863:	89 45 f0             	mov    %eax,-0x10(%ebp)
			break;
  802866:	eb 2e                	jmp    802896 <alloc_block_BF+0x14f>
		{
			LIST_REMOVE(&FreeMemBlocksList, blk);
			return blk;
		}
	}
	LIST_FOREACH(blk, &FreeMemBlocksList)
  802868:	a1 40 41 80 00       	mov    0x804140,%eax
  80286d:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802870:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802874:	74 07                	je     80287d <alloc_block_BF+0x136>
  802876:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802879:	8b 00                	mov    (%eax),%eax
  80287b:	eb 05                	jmp    802882 <alloc_block_BF+0x13b>
  80287d:	b8 00 00 00 00       	mov    $0x0,%eax
  802882:	a3 40 41 80 00       	mov    %eax,0x804140
  802887:	a1 40 41 80 00       	mov    0x804140,%eax
  80288c:	85 c0                	test   %eax,%eax
  80288e:	75 b9                	jne    802849 <alloc_block_BF+0x102>
  802890:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802894:	75 b3                	jne    802849 <alloc_block_BF+0x102>
			newsize = blk->size;
			newveradd = blk->sva;
			break;
		}
	}
	LIST_FOREACH(blk, &FreeMemBlocksList)
  802896:	a1 38 41 80 00       	mov    0x804138,%eax
  80289b:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80289e:	eb 30                	jmp    8028d0 <alloc_block_BF+0x189>
	{
		if(newsize > blk->size && blk->size > versize)
  8028a0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028a3:	8b 40 0c             	mov    0xc(%eax),%eax
  8028a6:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  8028a9:	73 1d                	jae    8028c8 <alloc_block_BF+0x181>
  8028ab:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028ae:	8b 40 0c             	mov    0xc(%eax),%eax
  8028b1:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  8028b4:	76 12                	jbe    8028c8 <alloc_block_BF+0x181>
		{
	       newsize = blk->size;
  8028b6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028b9:	8b 40 0c             	mov    0xc(%eax),%eax
  8028bc:	89 45 ec             	mov    %eax,-0x14(%ebp)
		   newveradd = blk->sva;
  8028bf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028c2:	8b 40 08             	mov    0x8(%eax),%eax
  8028c5:	89 45 f0             	mov    %eax,-0x10(%ebp)
			newsize = blk->size;
			newveradd = blk->sva;
			break;
		}
	}
	LIST_FOREACH(blk, &FreeMemBlocksList)
  8028c8:	a1 40 41 80 00       	mov    0x804140,%eax
  8028cd:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8028d0:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8028d4:	74 07                	je     8028dd <alloc_block_BF+0x196>
  8028d6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028d9:	8b 00                	mov    (%eax),%eax
  8028db:	eb 05                	jmp    8028e2 <alloc_block_BF+0x19b>
  8028dd:	b8 00 00 00 00       	mov    $0x0,%eax
  8028e2:	a3 40 41 80 00       	mov    %eax,0x804140
  8028e7:	a1 40 41 80 00       	mov    0x804140,%eax
  8028ec:	85 c0                	test   %eax,%eax
  8028ee:	75 b0                	jne    8028a0 <alloc_block_BF+0x159>
  8028f0:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8028f4:	75 aa                	jne    8028a0 <alloc_block_BF+0x159>
		{
	       newsize = blk->size;
		   newveradd = blk->sva;
		}
	}
	LIST_FOREACH(blk, &FreeMemBlocksList)
  8028f6:	a1 38 41 80 00       	mov    0x804138,%eax
  8028fb:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8028fe:	e9 e4 00 00 00       	jmp    8029e7 <alloc_block_BF+0x2a0>
	{
		if(blk->size == newsize && blk->sva == newveradd)
  802903:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802906:	8b 40 0c             	mov    0xc(%eax),%eax
  802909:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  80290c:	0f 85 cd 00 00 00    	jne    8029df <alloc_block_BF+0x298>
  802912:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802915:	8b 40 08             	mov    0x8(%eax),%eax
  802918:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  80291b:	0f 85 be 00 00 00    	jne    8029df <alloc_block_BF+0x298>
		{
			LIST_REMOVE(&AvailableMemBlocksList, newblk);
  802921:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  802925:	75 17                	jne    80293e <alloc_block_BF+0x1f7>
  802927:	83 ec 04             	sub    $0x4,%esp
  80292a:	68 88 3d 80 00       	push   $0x803d88
  80292f:	68 db 00 00 00       	push   $0xdb
  802934:	68 17 3d 80 00       	push   $0x803d17
  802939:	e8 98 db ff ff       	call   8004d6 <_panic>
  80293e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802941:	8b 00                	mov    (%eax),%eax
  802943:	85 c0                	test   %eax,%eax
  802945:	74 10                	je     802957 <alloc_block_BF+0x210>
  802947:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80294a:	8b 00                	mov    (%eax),%eax
  80294c:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80294f:	8b 52 04             	mov    0x4(%edx),%edx
  802952:	89 50 04             	mov    %edx,0x4(%eax)
  802955:	eb 0b                	jmp    802962 <alloc_block_BF+0x21b>
  802957:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80295a:	8b 40 04             	mov    0x4(%eax),%eax
  80295d:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802962:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802965:	8b 40 04             	mov    0x4(%eax),%eax
  802968:	85 c0                	test   %eax,%eax
  80296a:	74 0f                	je     80297b <alloc_block_BF+0x234>
  80296c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80296f:	8b 40 04             	mov    0x4(%eax),%eax
  802972:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802975:	8b 12                	mov    (%edx),%edx
  802977:	89 10                	mov    %edx,(%eax)
  802979:	eb 0a                	jmp    802985 <alloc_block_BF+0x23e>
  80297b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80297e:	8b 00                	mov    (%eax),%eax
  802980:	a3 48 41 80 00       	mov    %eax,0x804148
  802985:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802988:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80298e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802991:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802998:	a1 54 41 80 00       	mov    0x804154,%eax
  80299d:	48                   	dec    %eax
  80299e:	a3 54 41 80 00       	mov    %eax,0x804154
			newblk->size = versize;
  8029a3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8029a6:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8029a9:	89 50 0c             	mov    %edx,0xc(%eax)
			newblk->sva = newveradd;
  8029ac:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8029af:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8029b2:	89 50 08             	mov    %edx,0x8(%eax)
			blk->size = blk->size - versize;
  8029b5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029b8:	8b 40 0c             	mov    0xc(%eax),%eax
  8029bb:	2b 45 e8             	sub    -0x18(%ebp),%eax
  8029be:	89 c2                	mov    %eax,%edx
  8029c0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029c3:	89 50 0c             	mov    %edx,0xc(%eax)
			blk->sva+= newblk->size;
  8029c6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029c9:	8b 50 08             	mov    0x8(%eax),%edx
  8029cc:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8029cf:	8b 40 0c             	mov    0xc(%eax),%eax
  8029d2:	01 c2                	add    %eax,%edx
  8029d4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029d7:	89 50 08             	mov    %edx,0x8(%eax)
			return newblk;
  8029da:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8029dd:	eb 3b                	jmp    802a1a <alloc_block_BF+0x2d3>
		{
	       newsize = blk->size;
		   newveradd = blk->sva;
		}
	}
	LIST_FOREACH(blk, &FreeMemBlocksList)
  8029df:	a1 40 41 80 00       	mov    0x804140,%eax
  8029e4:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8029e7:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8029eb:	74 07                	je     8029f4 <alloc_block_BF+0x2ad>
  8029ed:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029f0:	8b 00                	mov    (%eax),%eax
  8029f2:	eb 05                	jmp    8029f9 <alloc_block_BF+0x2b2>
  8029f4:	b8 00 00 00 00       	mov    $0x0,%eax
  8029f9:	a3 40 41 80 00       	mov    %eax,0x804140
  8029fe:	a1 40 41 80 00       	mov    0x804140,%eax
  802a03:	85 c0                	test   %eax,%eax
  802a05:	0f 85 f8 fe ff ff    	jne    802903 <alloc_block_BF+0x1bc>
  802a0b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802a0f:	0f 85 ee fe ff ff    	jne    802903 <alloc_block_BF+0x1bc>
			blk->size = blk->size - versize;
			blk->sva+= newblk->size;
			return newblk;
		}
	}
	return NULL;
  802a15:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802a1a:	c9                   	leave  
  802a1b:	c3                   	ret    

00802a1c <alloc_block_NF>:
//=========================================
// [7] ALLOCATE BLOCK BY NEXT FIT:
//=========================================
struct MemBlock *last_allocate;
struct MemBlock *alloc_block_NF(uint32 size)
{
  802a1c:	55                   	push   %ebp
  802a1d:	89 e5                	mov    %esp,%ebp
  802a1f:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1 - BONUS] [DYNAMIC ALLOCATOR] alloc_block_NF
	// Write your code here, remove the panic and write your code
	//panic("alloc_block_NF() is not implemented yet...!!");
	uint32 versize = size;
  802a22:	8b 45 08             	mov    0x8(%ebp),%eax
  802a25:	89 45 f0             	mov    %eax,-0x10(%ebp)
	struct MemBlock* blk;
	struct MemBlock* newblk = LIST_FIRST(&AvailableMemBlocksList);
  802a28:	a1 48 41 80 00       	mov    0x804148,%eax
  802a2d:	89 45 ec             	mov    %eax,-0x14(%ebp)

	LIST_FOREACH(blk,&FreeMemBlocksList)
  802a30:	a1 38 41 80 00       	mov    0x804138,%eax
  802a35:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802a38:	e9 77 01 00 00       	jmp    802bb4 <alloc_block_NF+0x198>
	{
		if(blk->size == versize)
  802a3d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a40:	8b 40 0c             	mov    0xc(%eax),%eax
  802a43:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  802a46:	0f 85 8a 00 00 00    	jne    802ad6 <alloc_block_NF+0xba>
		{
			LIST_REMOVE(&FreeMemBlocksList,blk);
  802a4c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802a50:	75 17                	jne    802a69 <alloc_block_NF+0x4d>
  802a52:	83 ec 04             	sub    $0x4,%esp
  802a55:	68 88 3d 80 00       	push   $0x803d88
  802a5a:	68 f7 00 00 00       	push   $0xf7
  802a5f:	68 17 3d 80 00       	push   $0x803d17
  802a64:	e8 6d da ff ff       	call   8004d6 <_panic>
  802a69:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a6c:	8b 00                	mov    (%eax),%eax
  802a6e:	85 c0                	test   %eax,%eax
  802a70:	74 10                	je     802a82 <alloc_block_NF+0x66>
  802a72:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a75:	8b 00                	mov    (%eax),%eax
  802a77:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802a7a:	8b 52 04             	mov    0x4(%edx),%edx
  802a7d:	89 50 04             	mov    %edx,0x4(%eax)
  802a80:	eb 0b                	jmp    802a8d <alloc_block_NF+0x71>
  802a82:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a85:	8b 40 04             	mov    0x4(%eax),%eax
  802a88:	a3 3c 41 80 00       	mov    %eax,0x80413c
  802a8d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a90:	8b 40 04             	mov    0x4(%eax),%eax
  802a93:	85 c0                	test   %eax,%eax
  802a95:	74 0f                	je     802aa6 <alloc_block_NF+0x8a>
  802a97:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a9a:	8b 40 04             	mov    0x4(%eax),%eax
  802a9d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802aa0:	8b 12                	mov    (%edx),%edx
  802aa2:	89 10                	mov    %edx,(%eax)
  802aa4:	eb 0a                	jmp    802ab0 <alloc_block_NF+0x94>
  802aa6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802aa9:	8b 00                	mov    (%eax),%eax
  802aab:	a3 38 41 80 00       	mov    %eax,0x804138
  802ab0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ab3:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802ab9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802abc:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802ac3:	a1 44 41 80 00       	mov    0x804144,%eax
  802ac8:	48                   	dec    %eax
  802ac9:	a3 44 41 80 00       	mov    %eax,0x804144
			return blk;
  802ace:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ad1:	e9 11 01 00 00       	jmp    802be7 <alloc_block_NF+0x1cb>
		}
		else if(blk->size > versize)
  802ad6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ad9:	8b 40 0c             	mov    0xc(%eax),%eax
  802adc:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  802adf:	0f 86 c7 00 00 00    	jbe    802bac <alloc_block_NF+0x190>
		{
			LIST_REMOVE(&AvailableMemBlocksList,newblk);
  802ae5:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802ae9:	75 17                	jne    802b02 <alloc_block_NF+0xe6>
  802aeb:	83 ec 04             	sub    $0x4,%esp
  802aee:	68 88 3d 80 00       	push   $0x803d88
  802af3:	68 fc 00 00 00       	push   $0xfc
  802af8:	68 17 3d 80 00       	push   $0x803d17
  802afd:	e8 d4 d9 ff ff       	call   8004d6 <_panic>
  802b02:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802b05:	8b 00                	mov    (%eax),%eax
  802b07:	85 c0                	test   %eax,%eax
  802b09:	74 10                	je     802b1b <alloc_block_NF+0xff>
  802b0b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802b0e:	8b 00                	mov    (%eax),%eax
  802b10:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802b13:	8b 52 04             	mov    0x4(%edx),%edx
  802b16:	89 50 04             	mov    %edx,0x4(%eax)
  802b19:	eb 0b                	jmp    802b26 <alloc_block_NF+0x10a>
  802b1b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802b1e:	8b 40 04             	mov    0x4(%eax),%eax
  802b21:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802b26:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802b29:	8b 40 04             	mov    0x4(%eax),%eax
  802b2c:	85 c0                	test   %eax,%eax
  802b2e:	74 0f                	je     802b3f <alloc_block_NF+0x123>
  802b30:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802b33:	8b 40 04             	mov    0x4(%eax),%eax
  802b36:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802b39:	8b 12                	mov    (%edx),%edx
  802b3b:	89 10                	mov    %edx,(%eax)
  802b3d:	eb 0a                	jmp    802b49 <alloc_block_NF+0x12d>
  802b3f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802b42:	8b 00                	mov    (%eax),%eax
  802b44:	a3 48 41 80 00       	mov    %eax,0x804148
  802b49:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802b4c:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802b52:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802b55:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802b5c:	a1 54 41 80 00       	mov    0x804154,%eax
  802b61:	48                   	dec    %eax
  802b62:	a3 54 41 80 00       	mov    %eax,0x804154
			newblk->size = versize;
  802b67:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802b6a:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802b6d:	89 50 0c             	mov    %edx,0xc(%eax)
			blk->size = blk->size-versize;
  802b70:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b73:	8b 40 0c             	mov    0xc(%eax),%eax
  802b76:	2b 45 f0             	sub    -0x10(%ebp),%eax
  802b79:	89 c2                	mov    %eax,%edx
  802b7b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b7e:	89 50 0c             	mov    %edx,0xc(%eax)
			uint32 newveradd = blk->sva;
  802b81:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b84:	8b 40 08             	mov    0x8(%eax),%eax
  802b87:	89 45 e8             	mov    %eax,-0x18(%ebp)
			blk->sva+=newblk->size;
  802b8a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b8d:	8b 50 08             	mov    0x8(%eax),%edx
  802b90:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802b93:	8b 40 0c             	mov    0xc(%eax),%eax
  802b96:	01 c2                	add    %eax,%edx
  802b98:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b9b:	89 50 08             	mov    %edx,0x8(%eax)
			newblk->sva = newveradd;
  802b9e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802ba1:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802ba4:	89 50 08             	mov    %edx,0x8(%eax)
			return newblk;
  802ba7:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802baa:	eb 3b                	jmp    802be7 <alloc_block_NF+0x1cb>
	//panic("alloc_block_NF() is not implemented yet...!!");
	uint32 versize = size;
	struct MemBlock* blk;
	struct MemBlock* newblk = LIST_FIRST(&AvailableMemBlocksList);

	LIST_FOREACH(blk,&FreeMemBlocksList)
  802bac:	a1 40 41 80 00       	mov    0x804140,%eax
  802bb1:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802bb4:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802bb8:	74 07                	je     802bc1 <alloc_block_NF+0x1a5>
  802bba:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bbd:	8b 00                	mov    (%eax),%eax
  802bbf:	eb 05                	jmp    802bc6 <alloc_block_NF+0x1aa>
  802bc1:	b8 00 00 00 00       	mov    $0x0,%eax
  802bc6:	a3 40 41 80 00       	mov    %eax,0x804140
  802bcb:	a1 40 41 80 00       	mov    0x804140,%eax
  802bd0:	85 c0                	test   %eax,%eax
  802bd2:	0f 85 65 fe ff ff    	jne    802a3d <alloc_block_NF+0x21>
  802bd8:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802bdc:	0f 85 5b fe ff ff    	jne    802a3d <alloc_block_NF+0x21>
			blk->sva+=newblk->size;
			newblk->sva = newveradd;
			return newblk;
		}
	}
	return NULL;
  802be2:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802be7:	c9                   	leave  
  802be8:	c3                   	ret    

00802be9 <addToAvailMemBlocksList>:

//===================================================
// [8] INSERT BLOCK (SORTED WITH MERGE) IN FREE LIST:
//===================================================
void addToAvailMemBlocksList(struct MemBlock *blockToInsert)
{
  802be9:	55                   	push   %ebp
  802bea:	89 e5                	mov    %esp,%ebp
  802bec:	83 ec 08             	sub    $0x8,%esp
	blockToInsert->sva = 0;
  802bef:	8b 45 08             	mov    0x8(%ebp),%eax
  802bf2:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
	blockToInsert->size = 0;
  802bf9:	8b 45 08             	mov    0x8(%ebp),%eax
  802bfc:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
	//add to avail
	LIST_INSERT_TAIL(&AvailableMemBlocksList, blockToInsert);
  802c03:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802c07:	75 17                	jne    802c20 <addToAvailMemBlocksList+0x37>
  802c09:	83 ec 04             	sub    $0x4,%esp
  802c0c:	68 30 3d 80 00       	push   $0x803d30
  802c11:	68 10 01 00 00       	push   $0x110
  802c16:	68 17 3d 80 00       	push   $0x803d17
  802c1b:	e8 b6 d8 ff ff       	call   8004d6 <_panic>
  802c20:	8b 15 4c 41 80 00    	mov    0x80414c,%edx
  802c26:	8b 45 08             	mov    0x8(%ebp),%eax
  802c29:	89 50 04             	mov    %edx,0x4(%eax)
  802c2c:	8b 45 08             	mov    0x8(%ebp),%eax
  802c2f:	8b 40 04             	mov    0x4(%eax),%eax
  802c32:	85 c0                	test   %eax,%eax
  802c34:	74 0c                	je     802c42 <addToAvailMemBlocksList+0x59>
  802c36:	a1 4c 41 80 00       	mov    0x80414c,%eax
  802c3b:	8b 55 08             	mov    0x8(%ebp),%edx
  802c3e:	89 10                	mov    %edx,(%eax)
  802c40:	eb 08                	jmp    802c4a <addToAvailMemBlocksList+0x61>
  802c42:	8b 45 08             	mov    0x8(%ebp),%eax
  802c45:	a3 48 41 80 00       	mov    %eax,0x804148
  802c4a:	8b 45 08             	mov    0x8(%ebp),%eax
  802c4d:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802c52:	8b 45 08             	mov    0x8(%ebp),%eax
  802c55:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802c5b:	a1 54 41 80 00       	mov    0x804154,%eax
  802c60:	40                   	inc    %eax
  802c61:	a3 54 41 80 00       	mov    %eax,0x804154
}
  802c66:	90                   	nop
  802c67:	c9                   	leave  
  802c68:	c3                   	ret    

00802c69 <insert_sorted_with_merge_freeList>:
void insert_sorted_with_merge_freeList(struct MemBlock *blockToInsert)
{
  802c69:	55                   	push   %ebp
  802c6a:	89 e5                	mov    %esp,%ebp
  802c6c:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] insert_sorted_with_merge_freeList
	// Write your code here, remove the panic and write your code

	struct MemBlock* last = LIST_LAST(&FreeMemBlocksList);
  802c6f:	a1 3c 41 80 00       	mov    0x80413c,%eax
  802c74:	89 45 f0             	mov    %eax,-0x10(%ebp)
	//check if list empty
	if (LIST_SIZE(&(FreeMemBlocksList)) == 0)
  802c77:	a1 44 41 80 00       	mov    0x804144,%eax
  802c7c:	85 c0                	test   %eax,%eax
  802c7e:	75 68                	jne    802ce8 <insert_sorted_with_merge_freeList+0x7f>
		LIST_INSERT_HEAD(&FreeMemBlocksList, blockToInsert);
  802c80:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802c84:	75 17                	jne    802c9d <insert_sorted_with_merge_freeList+0x34>
  802c86:	83 ec 04             	sub    $0x4,%esp
  802c89:	68 f4 3c 80 00       	push   $0x803cf4
  802c8e:	68 1a 01 00 00       	push   $0x11a
  802c93:	68 17 3d 80 00       	push   $0x803d17
  802c98:	e8 39 d8 ff ff       	call   8004d6 <_panic>
  802c9d:	8b 15 38 41 80 00    	mov    0x804138,%edx
  802ca3:	8b 45 08             	mov    0x8(%ebp),%eax
  802ca6:	89 10                	mov    %edx,(%eax)
  802ca8:	8b 45 08             	mov    0x8(%ebp),%eax
  802cab:	8b 00                	mov    (%eax),%eax
  802cad:	85 c0                	test   %eax,%eax
  802caf:	74 0d                	je     802cbe <insert_sorted_with_merge_freeList+0x55>
  802cb1:	a1 38 41 80 00       	mov    0x804138,%eax
  802cb6:	8b 55 08             	mov    0x8(%ebp),%edx
  802cb9:	89 50 04             	mov    %edx,0x4(%eax)
  802cbc:	eb 08                	jmp    802cc6 <insert_sorted_with_merge_freeList+0x5d>
  802cbe:	8b 45 08             	mov    0x8(%ebp),%eax
  802cc1:	a3 3c 41 80 00       	mov    %eax,0x80413c
  802cc6:	8b 45 08             	mov    0x8(%ebp),%eax
  802cc9:	a3 38 41 80 00       	mov    %eax,0x804138
  802cce:	8b 45 08             	mov    0x8(%ebp),%eax
  802cd1:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802cd8:	a1 44 41 80 00       	mov    0x804144,%eax
  802cdd:	40                   	inc    %eax
  802cde:	a3 44 41 80 00       	mov    %eax,0x804144
		}
	}

	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  802ce3:	e9 c5 03 00 00       	jmp    8030ad <insert_sorted_with_merge_freeList+0x444>
	struct MemBlock* last = LIST_LAST(&FreeMemBlocksList);
	//check if list empty
	if (LIST_SIZE(&(FreeMemBlocksList)) == 0)
		LIST_INSERT_HEAD(&FreeMemBlocksList, blockToInsert);
	//check if it's position is at last
	else if (last->sva < blockToInsert->sva) {
  802ce8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802ceb:	8b 50 08             	mov    0x8(%eax),%edx
  802cee:	8b 45 08             	mov    0x8(%ebp),%eax
  802cf1:	8b 40 08             	mov    0x8(%eax),%eax
  802cf4:	39 c2                	cmp    %eax,%edx
  802cf6:	0f 83 b2 00 00 00    	jae    802dae <insert_sorted_with_merge_freeList+0x145>

		//if i have to merge
		if (last->sva + last->size == blockToInsert->sva) {
  802cfc:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802cff:	8b 50 08             	mov    0x8(%eax),%edx
  802d02:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d05:	8b 40 0c             	mov    0xc(%eax),%eax
  802d08:	01 c2                	add    %eax,%edx
  802d0a:	8b 45 08             	mov    0x8(%ebp),%eax
  802d0d:	8b 40 08             	mov    0x8(%eax),%eax
  802d10:	39 c2                	cmp    %eax,%edx
  802d12:	75 27                	jne    802d3b <insert_sorted_with_merge_freeList+0xd2>
			last->size = last->size + blockToInsert->size;
  802d14:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d17:	8b 50 0c             	mov    0xc(%eax),%edx
  802d1a:	8b 45 08             	mov    0x8(%ebp),%eax
  802d1d:	8b 40 0c             	mov    0xc(%eax),%eax
  802d20:	01 c2                	add    %eax,%edx
  802d22:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d25:	89 50 0c             	mov    %edx,0xc(%eax)
			addToAvailMemBlocksList(blockToInsert);
  802d28:	83 ec 0c             	sub    $0xc,%esp
  802d2b:	ff 75 08             	pushl  0x8(%ebp)
  802d2e:	e8 b6 fe ff ff       	call   802be9 <addToAvailMemBlocksList>
  802d33:	83 c4 10             	add    $0x10,%esp
		}
	}

	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  802d36:	e9 72 03 00 00       	jmp    8030ad <insert_sorted_with_merge_freeList+0x444>
		if (last->sva + last->size == blockToInsert->sva) {
			last->size = last->size + blockToInsert->size;
			addToAvailMemBlocksList(blockToInsert);

		} else {
			LIST_INSERT_AFTER(&FreeMemBlocksList, last, blockToInsert);
  802d3b:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802d3f:	74 06                	je     802d47 <insert_sorted_with_merge_freeList+0xde>
  802d41:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802d45:	75 17                	jne    802d5e <insert_sorted_with_merge_freeList+0xf5>
  802d47:	83 ec 04             	sub    $0x4,%esp
  802d4a:	68 54 3d 80 00       	push   $0x803d54
  802d4f:	68 24 01 00 00       	push   $0x124
  802d54:	68 17 3d 80 00       	push   $0x803d17
  802d59:	e8 78 d7 ff ff       	call   8004d6 <_panic>
  802d5e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d61:	8b 10                	mov    (%eax),%edx
  802d63:	8b 45 08             	mov    0x8(%ebp),%eax
  802d66:	89 10                	mov    %edx,(%eax)
  802d68:	8b 45 08             	mov    0x8(%ebp),%eax
  802d6b:	8b 00                	mov    (%eax),%eax
  802d6d:	85 c0                	test   %eax,%eax
  802d6f:	74 0b                	je     802d7c <insert_sorted_with_merge_freeList+0x113>
  802d71:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d74:	8b 00                	mov    (%eax),%eax
  802d76:	8b 55 08             	mov    0x8(%ebp),%edx
  802d79:	89 50 04             	mov    %edx,0x4(%eax)
  802d7c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d7f:	8b 55 08             	mov    0x8(%ebp),%edx
  802d82:	89 10                	mov    %edx,(%eax)
  802d84:	8b 45 08             	mov    0x8(%ebp),%eax
  802d87:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802d8a:	89 50 04             	mov    %edx,0x4(%eax)
  802d8d:	8b 45 08             	mov    0x8(%ebp),%eax
  802d90:	8b 00                	mov    (%eax),%eax
  802d92:	85 c0                	test   %eax,%eax
  802d94:	75 08                	jne    802d9e <insert_sorted_with_merge_freeList+0x135>
  802d96:	8b 45 08             	mov    0x8(%ebp),%eax
  802d99:	a3 3c 41 80 00       	mov    %eax,0x80413c
  802d9e:	a1 44 41 80 00       	mov    0x804144,%eax
  802da3:	40                   	inc    %eax
  802da4:	a3 44 41 80 00       	mov    %eax,0x804144
		}
	}

	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  802da9:	e9 ff 02 00 00       	jmp    8030ad <insert_sorted_with_merge_freeList+0x444>
		} else {
			LIST_INSERT_AFTER(&FreeMemBlocksList, last, blockToInsert);
		}
	} else {
		struct MemBlock *iterator;
		LIST_FOREACH(iterator, &(FreeMemBlocksList))
  802dae:	a1 38 41 80 00       	mov    0x804138,%eax
  802db3:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802db6:	e9 c2 02 00 00       	jmp    80307d <insert_sorted_with_merge_freeList+0x414>
		{

			if (iterator->sva > blockToInsert->sva) {
  802dbb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802dbe:	8b 50 08             	mov    0x8(%eax),%edx
  802dc1:	8b 45 08             	mov    0x8(%ebp),%eax
  802dc4:	8b 40 08             	mov    0x8(%eax),%eax
  802dc7:	39 c2                	cmp    %eax,%edx
  802dc9:	0f 86 a6 02 00 00    	jbe    803075 <insert_sorted_with_merge_freeList+0x40c>

				struct MemBlock* prev = LIST_PREV(iterator);
  802dcf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802dd2:	8b 40 04             	mov    0x4(%eax),%eax
  802dd5:	89 45 ec             	mov    %eax,-0x14(%ebp)
				if (prev == NULL) {
  802dd8:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802ddc:	0f 85 ba 00 00 00    	jne    802e9c <insert_sorted_with_merge_freeList+0x233>
					//check merge
					if (blockToInsert->size + blockToInsert->sva
  802de2:	8b 45 08             	mov    0x8(%ebp),%eax
  802de5:	8b 50 0c             	mov    0xc(%eax),%edx
  802de8:	8b 45 08             	mov    0x8(%ebp),%eax
  802deb:	8b 40 08             	mov    0x8(%eax),%eax
  802dee:	01 c2                	add    %eax,%edx
							== iterator->sva) {
  802df0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802df3:	8b 40 08             	mov    0x8(%eax),%eax
			if (iterator->sva > blockToInsert->sva) {

				struct MemBlock* prev = LIST_PREV(iterator);
				if (prev == NULL) {
					//check merge
					if (blockToInsert->size + blockToInsert->sva
  802df6:	39 c2                	cmp    %eax,%edx
  802df8:	75 33                	jne    802e2d <insert_sorted_with_merge_freeList+0x1c4>
							== iterator->sva) {
						iterator->sva = blockToInsert->sva;
  802dfa:	8b 45 08             	mov    0x8(%ebp),%eax
  802dfd:	8b 50 08             	mov    0x8(%eax),%edx
  802e00:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e03:	89 50 08             	mov    %edx,0x8(%eax)
						iterator->size = iterator->size + blockToInsert->size;
  802e06:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e09:	8b 50 0c             	mov    0xc(%eax),%edx
  802e0c:	8b 45 08             	mov    0x8(%ebp),%eax
  802e0f:	8b 40 0c             	mov    0xc(%eax),%eax
  802e12:	01 c2                	add    %eax,%edx
  802e14:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e17:	89 50 0c             	mov    %edx,0xc(%eax)
						addToAvailMemBlocksList(blockToInsert);
  802e1a:	83 ec 0c             	sub    $0xc,%esp
  802e1d:	ff 75 08             	pushl  0x8(%ebp)
  802e20:	e8 c4 fd ff ff       	call   802be9 <addToAvailMemBlocksList>
  802e25:	83 c4 10             	add    $0x10,%esp

					else {
						LIST_INSERT_BEFORE(&FreeMemBlocksList, iterator,
								blockToInsert);
					}
					break;
  802e28:	e9 80 02 00 00       	jmp    8030ad <insert_sorted_with_merge_freeList+0x444>
						addToAvailMemBlocksList(blockToInsert);

					}

					else {
						LIST_INSERT_BEFORE(&FreeMemBlocksList, iterator,
  802e2d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802e31:	74 06                	je     802e39 <insert_sorted_with_merge_freeList+0x1d0>
  802e33:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802e37:	75 17                	jne    802e50 <insert_sorted_with_merge_freeList+0x1e7>
  802e39:	83 ec 04             	sub    $0x4,%esp
  802e3c:	68 a8 3d 80 00       	push   $0x803da8
  802e41:	68 3a 01 00 00       	push   $0x13a
  802e46:	68 17 3d 80 00       	push   $0x803d17
  802e4b:	e8 86 d6 ff ff       	call   8004d6 <_panic>
  802e50:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e53:	8b 50 04             	mov    0x4(%eax),%edx
  802e56:	8b 45 08             	mov    0x8(%ebp),%eax
  802e59:	89 50 04             	mov    %edx,0x4(%eax)
  802e5c:	8b 45 08             	mov    0x8(%ebp),%eax
  802e5f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802e62:	89 10                	mov    %edx,(%eax)
  802e64:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e67:	8b 40 04             	mov    0x4(%eax),%eax
  802e6a:	85 c0                	test   %eax,%eax
  802e6c:	74 0d                	je     802e7b <insert_sorted_with_merge_freeList+0x212>
  802e6e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e71:	8b 40 04             	mov    0x4(%eax),%eax
  802e74:	8b 55 08             	mov    0x8(%ebp),%edx
  802e77:	89 10                	mov    %edx,(%eax)
  802e79:	eb 08                	jmp    802e83 <insert_sorted_with_merge_freeList+0x21a>
  802e7b:	8b 45 08             	mov    0x8(%ebp),%eax
  802e7e:	a3 38 41 80 00       	mov    %eax,0x804138
  802e83:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e86:	8b 55 08             	mov    0x8(%ebp),%edx
  802e89:	89 50 04             	mov    %edx,0x4(%eax)
  802e8c:	a1 44 41 80 00       	mov    0x804144,%eax
  802e91:	40                   	inc    %eax
  802e92:	a3 44 41 80 00       	mov    %eax,0x804144
								blockToInsert);
					}
					break;
  802e97:	e9 11 02 00 00       	jmp    8030ad <insert_sorted_with_merge_freeList+0x444>
				} else {
					//prev and next merge
					if (prev->sva + prev->size + blockToInsert->size
  802e9c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802e9f:	8b 50 08             	mov    0x8(%eax),%edx
  802ea2:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802ea5:	8b 40 0c             	mov    0xc(%eax),%eax
  802ea8:	01 c2                	add    %eax,%edx
  802eaa:	8b 45 08             	mov    0x8(%ebp),%eax
  802ead:	8b 40 0c             	mov    0xc(%eax),%eax
  802eb0:	01 c2                	add    %eax,%edx
							== iterator->sva) {
  802eb2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802eb5:	8b 40 08             	mov    0x8(%eax),%eax
								blockToInsert);
					}
					break;
				} else {
					//prev and next merge
					if (prev->sva + prev->size + blockToInsert->size
  802eb8:	39 c2                	cmp    %eax,%edx
  802eba:	0f 85 bf 00 00 00    	jne    802f7f <insert_sorted_with_merge_freeList+0x316>
							== iterator->sva) {
						prev->size = prev->size + blockToInsert->size
  802ec0:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802ec3:	8b 50 0c             	mov    0xc(%eax),%edx
  802ec6:	8b 45 08             	mov    0x8(%ebp),%eax
  802ec9:	8b 40 0c             	mov    0xc(%eax),%eax
  802ecc:	01 c2                	add    %eax,%edx
								+ iterator->size;
  802ece:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ed1:	8b 40 0c             	mov    0xc(%eax),%eax
  802ed4:	01 c2                	add    %eax,%edx
					break;
				} else {
					//prev and next merge
					if (prev->sva + prev->size + blockToInsert->size
							== iterator->sva) {
						prev->size = prev->size + blockToInsert->size
  802ed6:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802ed9:	89 50 0c             	mov    %edx,0xc(%eax)
								+ iterator->size;
						LIST_REMOVE(&FreeMemBlocksList, iterator);
  802edc:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802ee0:	75 17                	jne    802ef9 <insert_sorted_with_merge_freeList+0x290>
  802ee2:	83 ec 04             	sub    $0x4,%esp
  802ee5:	68 88 3d 80 00       	push   $0x803d88
  802eea:	68 43 01 00 00       	push   $0x143
  802eef:	68 17 3d 80 00       	push   $0x803d17
  802ef4:	e8 dd d5 ff ff       	call   8004d6 <_panic>
  802ef9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802efc:	8b 00                	mov    (%eax),%eax
  802efe:	85 c0                	test   %eax,%eax
  802f00:	74 10                	je     802f12 <insert_sorted_with_merge_freeList+0x2a9>
  802f02:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f05:	8b 00                	mov    (%eax),%eax
  802f07:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802f0a:	8b 52 04             	mov    0x4(%edx),%edx
  802f0d:	89 50 04             	mov    %edx,0x4(%eax)
  802f10:	eb 0b                	jmp    802f1d <insert_sorted_with_merge_freeList+0x2b4>
  802f12:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f15:	8b 40 04             	mov    0x4(%eax),%eax
  802f18:	a3 3c 41 80 00       	mov    %eax,0x80413c
  802f1d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f20:	8b 40 04             	mov    0x4(%eax),%eax
  802f23:	85 c0                	test   %eax,%eax
  802f25:	74 0f                	je     802f36 <insert_sorted_with_merge_freeList+0x2cd>
  802f27:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f2a:	8b 40 04             	mov    0x4(%eax),%eax
  802f2d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802f30:	8b 12                	mov    (%edx),%edx
  802f32:	89 10                	mov    %edx,(%eax)
  802f34:	eb 0a                	jmp    802f40 <insert_sorted_with_merge_freeList+0x2d7>
  802f36:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f39:	8b 00                	mov    (%eax),%eax
  802f3b:	a3 38 41 80 00       	mov    %eax,0x804138
  802f40:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f43:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802f49:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f4c:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802f53:	a1 44 41 80 00       	mov    0x804144,%eax
  802f58:	48                   	dec    %eax
  802f59:	a3 44 41 80 00       	mov    %eax,0x804144
						addToAvailMemBlocksList(blockToInsert);
  802f5e:	83 ec 0c             	sub    $0xc,%esp
  802f61:	ff 75 08             	pushl  0x8(%ebp)
  802f64:	e8 80 fc ff ff       	call   802be9 <addToAvailMemBlocksList>
  802f69:	83 c4 10             	add    $0x10,%esp
						addToAvailMemBlocksList(iterator);
  802f6c:	83 ec 0c             	sub    $0xc,%esp
  802f6f:	ff 75 f4             	pushl  -0xc(%ebp)
  802f72:	e8 72 fc ff ff       	call   802be9 <addToAvailMemBlocksList>
  802f77:	83 c4 10             	add    $0x10,%esp
					//Insert
					else {
						LIST_INSERT_BEFORE(&FreeMemBlocksList, iterator,
								blockToInsert);
					}
					break;
  802f7a:	e9 2e 01 00 00       	jmp    8030ad <insert_sorted_with_merge_freeList+0x444>
						LIST_REMOVE(&FreeMemBlocksList, iterator);
						addToAvailMemBlocksList(blockToInsert);
						addToAvailMemBlocksList(iterator);
					}
					//previous merge
					else if (prev->sva + prev->size == blockToInsert->sva) {
  802f7f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802f82:	8b 50 08             	mov    0x8(%eax),%edx
  802f85:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802f88:	8b 40 0c             	mov    0xc(%eax),%eax
  802f8b:	01 c2                	add    %eax,%edx
  802f8d:	8b 45 08             	mov    0x8(%ebp),%eax
  802f90:	8b 40 08             	mov    0x8(%eax),%eax
  802f93:	39 c2                	cmp    %eax,%edx
  802f95:	75 27                	jne    802fbe <insert_sorted_with_merge_freeList+0x355>
						prev->size = prev->size + blockToInsert->size;
  802f97:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802f9a:	8b 50 0c             	mov    0xc(%eax),%edx
  802f9d:	8b 45 08             	mov    0x8(%ebp),%eax
  802fa0:	8b 40 0c             	mov    0xc(%eax),%eax
  802fa3:	01 c2                	add    %eax,%edx
  802fa5:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802fa8:	89 50 0c             	mov    %edx,0xc(%eax)
						addToAvailMemBlocksList(blockToInsert);
  802fab:	83 ec 0c             	sub    $0xc,%esp
  802fae:	ff 75 08             	pushl  0x8(%ebp)
  802fb1:	e8 33 fc ff ff       	call   802be9 <addToAvailMemBlocksList>
  802fb6:	83 c4 10             	add    $0x10,%esp
					//Insert
					else {
						LIST_INSERT_BEFORE(&FreeMemBlocksList, iterator,
								blockToInsert);
					}
					break;
  802fb9:	e9 ef 00 00 00       	jmp    8030ad <insert_sorted_with_merge_freeList+0x444>
					else if (prev->sva + prev->size == blockToInsert->sva) {
						prev->size = prev->size + blockToInsert->size;
						addToAvailMemBlocksList(blockToInsert);
					}
					//next merge
					else if (blockToInsert->size + blockToInsert->sva
  802fbe:	8b 45 08             	mov    0x8(%ebp),%eax
  802fc1:	8b 50 0c             	mov    0xc(%eax),%edx
  802fc4:	8b 45 08             	mov    0x8(%ebp),%eax
  802fc7:	8b 40 08             	mov    0x8(%eax),%eax
  802fca:	01 c2                	add    %eax,%edx
							== iterator->sva) {
  802fcc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802fcf:	8b 40 08             	mov    0x8(%eax),%eax
					else if (prev->sva + prev->size == blockToInsert->sva) {
						prev->size = prev->size + blockToInsert->size;
						addToAvailMemBlocksList(blockToInsert);
					}
					//next merge
					else if (blockToInsert->size + blockToInsert->sva
  802fd2:	39 c2                	cmp    %eax,%edx
  802fd4:	75 33                	jne    803009 <insert_sorted_with_merge_freeList+0x3a0>
							== iterator->sva) {
						iterator->sva = blockToInsert->sva;
  802fd6:	8b 45 08             	mov    0x8(%ebp),%eax
  802fd9:	8b 50 08             	mov    0x8(%eax),%edx
  802fdc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802fdf:	89 50 08             	mov    %edx,0x8(%eax)
						iterator->size = iterator->size + blockToInsert->size;
  802fe2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802fe5:	8b 50 0c             	mov    0xc(%eax),%edx
  802fe8:	8b 45 08             	mov    0x8(%ebp),%eax
  802feb:	8b 40 0c             	mov    0xc(%eax),%eax
  802fee:	01 c2                	add    %eax,%edx
  802ff0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ff3:	89 50 0c             	mov    %edx,0xc(%eax)
						addToAvailMemBlocksList(blockToInsert);
  802ff6:	83 ec 0c             	sub    $0xc,%esp
  802ff9:	ff 75 08             	pushl  0x8(%ebp)
  802ffc:	e8 e8 fb ff ff       	call   802be9 <addToAvailMemBlocksList>
  803001:	83 c4 10             	add    $0x10,%esp
					//Insert
					else {
						LIST_INSERT_BEFORE(&FreeMemBlocksList, iterator,
								blockToInsert);
					}
					break;
  803004:	e9 a4 00 00 00       	jmp    8030ad <insert_sorted_with_merge_freeList+0x444>
						iterator->size = iterator->size + blockToInsert->size;
						addToAvailMemBlocksList(blockToInsert);
					}
					//Insert
					else {
						LIST_INSERT_BEFORE(&FreeMemBlocksList, iterator,
  803009:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80300d:	74 06                	je     803015 <insert_sorted_with_merge_freeList+0x3ac>
  80300f:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803013:	75 17                	jne    80302c <insert_sorted_with_merge_freeList+0x3c3>
  803015:	83 ec 04             	sub    $0x4,%esp
  803018:	68 a8 3d 80 00       	push   $0x803da8
  80301d:	68 56 01 00 00       	push   $0x156
  803022:	68 17 3d 80 00       	push   $0x803d17
  803027:	e8 aa d4 ff ff       	call   8004d6 <_panic>
  80302c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80302f:	8b 50 04             	mov    0x4(%eax),%edx
  803032:	8b 45 08             	mov    0x8(%ebp),%eax
  803035:	89 50 04             	mov    %edx,0x4(%eax)
  803038:	8b 45 08             	mov    0x8(%ebp),%eax
  80303b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80303e:	89 10                	mov    %edx,(%eax)
  803040:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803043:	8b 40 04             	mov    0x4(%eax),%eax
  803046:	85 c0                	test   %eax,%eax
  803048:	74 0d                	je     803057 <insert_sorted_with_merge_freeList+0x3ee>
  80304a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80304d:	8b 40 04             	mov    0x4(%eax),%eax
  803050:	8b 55 08             	mov    0x8(%ebp),%edx
  803053:	89 10                	mov    %edx,(%eax)
  803055:	eb 08                	jmp    80305f <insert_sorted_with_merge_freeList+0x3f6>
  803057:	8b 45 08             	mov    0x8(%ebp),%eax
  80305a:	a3 38 41 80 00       	mov    %eax,0x804138
  80305f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803062:	8b 55 08             	mov    0x8(%ebp),%edx
  803065:	89 50 04             	mov    %edx,0x4(%eax)
  803068:	a1 44 41 80 00       	mov    0x804144,%eax
  80306d:	40                   	inc    %eax
  80306e:	a3 44 41 80 00       	mov    %eax,0x804144
								blockToInsert);
					}
					break;
  803073:	eb 38                	jmp    8030ad <insert_sorted_with_merge_freeList+0x444>
		} else {
			LIST_INSERT_AFTER(&FreeMemBlocksList, last, blockToInsert);
		}
	} else {
		struct MemBlock *iterator;
		LIST_FOREACH(iterator, &(FreeMemBlocksList))
  803075:	a1 40 41 80 00       	mov    0x804140,%eax
  80307a:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80307d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803081:	74 07                	je     80308a <insert_sorted_with_merge_freeList+0x421>
  803083:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803086:	8b 00                	mov    (%eax),%eax
  803088:	eb 05                	jmp    80308f <insert_sorted_with_merge_freeList+0x426>
  80308a:	b8 00 00 00 00       	mov    $0x0,%eax
  80308f:	a3 40 41 80 00       	mov    %eax,0x804140
  803094:	a1 40 41 80 00       	mov    0x804140,%eax
  803099:	85 c0                	test   %eax,%eax
  80309b:	0f 85 1a fd ff ff    	jne    802dbb <insert_sorted_with_merge_freeList+0x152>
  8030a1:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8030a5:	0f 85 10 fd ff ff    	jne    802dbb <insert_sorted_with_merge_freeList+0x152>
		}
	}

	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  8030ab:	eb 00                	jmp    8030ad <insert_sorted_with_merge_freeList+0x444>
  8030ad:	90                   	nop
  8030ae:	c9                   	leave  
  8030af:	c3                   	ret    

008030b0 <__udivdi3>:
  8030b0:	55                   	push   %ebp
  8030b1:	57                   	push   %edi
  8030b2:	56                   	push   %esi
  8030b3:	53                   	push   %ebx
  8030b4:	83 ec 1c             	sub    $0x1c,%esp
  8030b7:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  8030bb:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  8030bf:	8b 7c 24 38          	mov    0x38(%esp),%edi
  8030c3:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8030c7:	89 ca                	mov    %ecx,%edx
  8030c9:	89 f8                	mov    %edi,%eax
  8030cb:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  8030cf:	85 f6                	test   %esi,%esi
  8030d1:	75 2d                	jne    803100 <__udivdi3+0x50>
  8030d3:	39 cf                	cmp    %ecx,%edi
  8030d5:	77 65                	ja     80313c <__udivdi3+0x8c>
  8030d7:	89 fd                	mov    %edi,%ebp
  8030d9:	85 ff                	test   %edi,%edi
  8030db:	75 0b                	jne    8030e8 <__udivdi3+0x38>
  8030dd:	b8 01 00 00 00       	mov    $0x1,%eax
  8030e2:	31 d2                	xor    %edx,%edx
  8030e4:	f7 f7                	div    %edi
  8030e6:	89 c5                	mov    %eax,%ebp
  8030e8:	31 d2                	xor    %edx,%edx
  8030ea:	89 c8                	mov    %ecx,%eax
  8030ec:	f7 f5                	div    %ebp
  8030ee:	89 c1                	mov    %eax,%ecx
  8030f0:	89 d8                	mov    %ebx,%eax
  8030f2:	f7 f5                	div    %ebp
  8030f4:	89 cf                	mov    %ecx,%edi
  8030f6:	89 fa                	mov    %edi,%edx
  8030f8:	83 c4 1c             	add    $0x1c,%esp
  8030fb:	5b                   	pop    %ebx
  8030fc:	5e                   	pop    %esi
  8030fd:	5f                   	pop    %edi
  8030fe:	5d                   	pop    %ebp
  8030ff:	c3                   	ret    
  803100:	39 ce                	cmp    %ecx,%esi
  803102:	77 28                	ja     80312c <__udivdi3+0x7c>
  803104:	0f bd fe             	bsr    %esi,%edi
  803107:	83 f7 1f             	xor    $0x1f,%edi
  80310a:	75 40                	jne    80314c <__udivdi3+0x9c>
  80310c:	39 ce                	cmp    %ecx,%esi
  80310e:	72 0a                	jb     80311a <__udivdi3+0x6a>
  803110:	3b 44 24 08          	cmp    0x8(%esp),%eax
  803114:	0f 87 9e 00 00 00    	ja     8031b8 <__udivdi3+0x108>
  80311a:	b8 01 00 00 00       	mov    $0x1,%eax
  80311f:	89 fa                	mov    %edi,%edx
  803121:	83 c4 1c             	add    $0x1c,%esp
  803124:	5b                   	pop    %ebx
  803125:	5e                   	pop    %esi
  803126:	5f                   	pop    %edi
  803127:	5d                   	pop    %ebp
  803128:	c3                   	ret    
  803129:	8d 76 00             	lea    0x0(%esi),%esi
  80312c:	31 ff                	xor    %edi,%edi
  80312e:	31 c0                	xor    %eax,%eax
  803130:	89 fa                	mov    %edi,%edx
  803132:	83 c4 1c             	add    $0x1c,%esp
  803135:	5b                   	pop    %ebx
  803136:	5e                   	pop    %esi
  803137:	5f                   	pop    %edi
  803138:	5d                   	pop    %ebp
  803139:	c3                   	ret    
  80313a:	66 90                	xchg   %ax,%ax
  80313c:	89 d8                	mov    %ebx,%eax
  80313e:	f7 f7                	div    %edi
  803140:	31 ff                	xor    %edi,%edi
  803142:	89 fa                	mov    %edi,%edx
  803144:	83 c4 1c             	add    $0x1c,%esp
  803147:	5b                   	pop    %ebx
  803148:	5e                   	pop    %esi
  803149:	5f                   	pop    %edi
  80314a:	5d                   	pop    %ebp
  80314b:	c3                   	ret    
  80314c:	bd 20 00 00 00       	mov    $0x20,%ebp
  803151:	89 eb                	mov    %ebp,%ebx
  803153:	29 fb                	sub    %edi,%ebx
  803155:	89 f9                	mov    %edi,%ecx
  803157:	d3 e6                	shl    %cl,%esi
  803159:	89 c5                	mov    %eax,%ebp
  80315b:	88 d9                	mov    %bl,%cl
  80315d:	d3 ed                	shr    %cl,%ebp
  80315f:	89 e9                	mov    %ebp,%ecx
  803161:	09 f1                	or     %esi,%ecx
  803163:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  803167:	89 f9                	mov    %edi,%ecx
  803169:	d3 e0                	shl    %cl,%eax
  80316b:	89 c5                	mov    %eax,%ebp
  80316d:	89 d6                	mov    %edx,%esi
  80316f:	88 d9                	mov    %bl,%cl
  803171:	d3 ee                	shr    %cl,%esi
  803173:	89 f9                	mov    %edi,%ecx
  803175:	d3 e2                	shl    %cl,%edx
  803177:	8b 44 24 08          	mov    0x8(%esp),%eax
  80317b:	88 d9                	mov    %bl,%cl
  80317d:	d3 e8                	shr    %cl,%eax
  80317f:	09 c2                	or     %eax,%edx
  803181:	89 d0                	mov    %edx,%eax
  803183:	89 f2                	mov    %esi,%edx
  803185:	f7 74 24 0c          	divl   0xc(%esp)
  803189:	89 d6                	mov    %edx,%esi
  80318b:	89 c3                	mov    %eax,%ebx
  80318d:	f7 e5                	mul    %ebp
  80318f:	39 d6                	cmp    %edx,%esi
  803191:	72 19                	jb     8031ac <__udivdi3+0xfc>
  803193:	74 0b                	je     8031a0 <__udivdi3+0xf0>
  803195:	89 d8                	mov    %ebx,%eax
  803197:	31 ff                	xor    %edi,%edi
  803199:	e9 58 ff ff ff       	jmp    8030f6 <__udivdi3+0x46>
  80319e:	66 90                	xchg   %ax,%ax
  8031a0:	8b 54 24 08          	mov    0x8(%esp),%edx
  8031a4:	89 f9                	mov    %edi,%ecx
  8031a6:	d3 e2                	shl    %cl,%edx
  8031a8:	39 c2                	cmp    %eax,%edx
  8031aa:	73 e9                	jae    803195 <__udivdi3+0xe5>
  8031ac:	8d 43 ff             	lea    -0x1(%ebx),%eax
  8031af:	31 ff                	xor    %edi,%edi
  8031b1:	e9 40 ff ff ff       	jmp    8030f6 <__udivdi3+0x46>
  8031b6:	66 90                	xchg   %ax,%ax
  8031b8:	31 c0                	xor    %eax,%eax
  8031ba:	e9 37 ff ff ff       	jmp    8030f6 <__udivdi3+0x46>
  8031bf:	90                   	nop

008031c0 <__umoddi3>:
  8031c0:	55                   	push   %ebp
  8031c1:	57                   	push   %edi
  8031c2:	56                   	push   %esi
  8031c3:	53                   	push   %ebx
  8031c4:	83 ec 1c             	sub    $0x1c,%esp
  8031c7:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  8031cb:	8b 74 24 34          	mov    0x34(%esp),%esi
  8031cf:	8b 7c 24 38          	mov    0x38(%esp),%edi
  8031d3:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  8031d7:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8031db:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8031df:	89 f3                	mov    %esi,%ebx
  8031e1:	89 fa                	mov    %edi,%edx
  8031e3:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8031e7:	89 34 24             	mov    %esi,(%esp)
  8031ea:	85 c0                	test   %eax,%eax
  8031ec:	75 1a                	jne    803208 <__umoddi3+0x48>
  8031ee:	39 f7                	cmp    %esi,%edi
  8031f0:	0f 86 a2 00 00 00    	jbe    803298 <__umoddi3+0xd8>
  8031f6:	89 c8                	mov    %ecx,%eax
  8031f8:	89 f2                	mov    %esi,%edx
  8031fa:	f7 f7                	div    %edi
  8031fc:	89 d0                	mov    %edx,%eax
  8031fe:	31 d2                	xor    %edx,%edx
  803200:	83 c4 1c             	add    $0x1c,%esp
  803203:	5b                   	pop    %ebx
  803204:	5e                   	pop    %esi
  803205:	5f                   	pop    %edi
  803206:	5d                   	pop    %ebp
  803207:	c3                   	ret    
  803208:	39 f0                	cmp    %esi,%eax
  80320a:	0f 87 ac 00 00 00    	ja     8032bc <__umoddi3+0xfc>
  803210:	0f bd e8             	bsr    %eax,%ebp
  803213:	83 f5 1f             	xor    $0x1f,%ebp
  803216:	0f 84 ac 00 00 00    	je     8032c8 <__umoddi3+0x108>
  80321c:	bf 20 00 00 00       	mov    $0x20,%edi
  803221:	29 ef                	sub    %ebp,%edi
  803223:	89 fe                	mov    %edi,%esi
  803225:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  803229:	89 e9                	mov    %ebp,%ecx
  80322b:	d3 e0                	shl    %cl,%eax
  80322d:	89 d7                	mov    %edx,%edi
  80322f:	89 f1                	mov    %esi,%ecx
  803231:	d3 ef                	shr    %cl,%edi
  803233:	09 c7                	or     %eax,%edi
  803235:	89 e9                	mov    %ebp,%ecx
  803237:	d3 e2                	shl    %cl,%edx
  803239:	89 14 24             	mov    %edx,(%esp)
  80323c:	89 d8                	mov    %ebx,%eax
  80323e:	d3 e0                	shl    %cl,%eax
  803240:	89 c2                	mov    %eax,%edx
  803242:	8b 44 24 08          	mov    0x8(%esp),%eax
  803246:	d3 e0                	shl    %cl,%eax
  803248:	89 44 24 04          	mov    %eax,0x4(%esp)
  80324c:	8b 44 24 08          	mov    0x8(%esp),%eax
  803250:	89 f1                	mov    %esi,%ecx
  803252:	d3 e8                	shr    %cl,%eax
  803254:	09 d0                	or     %edx,%eax
  803256:	d3 eb                	shr    %cl,%ebx
  803258:	89 da                	mov    %ebx,%edx
  80325a:	f7 f7                	div    %edi
  80325c:	89 d3                	mov    %edx,%ebx
  80325e:	f7 24 24             	mull   (%esp)
  803261:	89 c6                	mov    %eax,%esi
  803263:	89 d1                	mov    %edx,%ecx
  803265:	39 d3                	cmp    %edx,%ebx
  803267:	0f 82 87 00 00 00    	jb     8032f4 <__umoddi3+0x134>
  80326d:	0f 84 91 00 00 00    	je     803304 <__umoddi3+0x144>
  803273:	8b 54 24 04          	mov    0x4(%esp),%edx
  803277:	29 f2                	sub    %esi,%edx
  803279:	19 cb                	sbb    %ecx,%ebx
  80327b:	89 d8                	mov    %ebx,%eax
  80327d:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  803281:	d3 e0                	shl    %cl,%eax
  803283:	89 e9                	mov    %ebp,%ecx
  803285:	d3 ea                	shr    %cl,%edx
  803287:	09 d0                	or     %edx,%eax
  803289:	89 e9                	mov    %ebp,%ecx
  80328b:	d3 eb                	shr    %cl,%ebx
  80328d:	89 da                	mov    %ebx,%edx
  80328f:	83 c4 1c             	add    $0x1c,%esp
  803292:	5b                   	pop    %ebx
  803293:	5e                   	pop    %esi
  803294:	5f                   	pop    %edi
  803295:	5d                   	pop    %ebp
  803296:	c3                   	ret    
  803297:	90                   	nop
  803298:	89 fd                	mov    %edi,%ebp
  80329a:	85 ff                	test   %edi,%edi
  80329c:	75 0b                	jne    8032a9 <__umoddi3+0xe9>
  80329e:	b8 01 00 00 00       	mov    $0x1,%eax
  8032a3:	31 d2                	xor    %edx,%edx
  8032a5:	f7 f7                	div    %edi
  8032a7:	89 c5                	mov    %eax,%ebp
  8032a9:	89 f0                	mov    %esi,%eax
  8032ab:	31 d2                	xor    %edx,%edx
  8032ad:	f7 f5                	div    %ebp
  8032af:	89 c8                	mov    %ecx,%eax
  8032b1:	f7 f5                	div    %ebp
  8032b3:	89 d0                	mov    %edx,%eax
  8032b5:	e9 44 ff ff ff       	jmp    8031fe <__umoddi3+0x3e>
  8032ba:	66 90                	xchg   %ax,%ax
  8032bc:	89 c8                	mov    %ecx,%eax
  8032be:	89 f2                	mov    %esi,%edx
  8032c0:	83 c4 1c             	add    $0x1c,%esp
  8032c3:	5b                   	pop    %ebx
  8032c4:	5e                   	pop    %esi
  8032c5:	5f                   	pop    %edi
  8032c6:	5d                   	pop    %ebp
  8032c7:	c3                   	ret    
  8032c8:	3b 04 24             	cmp    (%esp),%eax
  8032cb:	72 06                	jb     8032d3 <__umoddi3+0x113>
  8032cd:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  8032d1:	77 0f                	ja     8032e2 <__umoddi3+0x122>
  8032d3:	89 f2                	mov    %esi,%edx
  8032d5:	29 f9                	sub    %edi,%ecx
  8032d7:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  8032db:	89 14 24             	mov    %edx,(%esp)
  8032de:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8032e2:	8b 44 24 04          	mov    0x4(%esp),%eax
  8032e6:	8b 14 24             	mov    (%esp),%edx
  8032e9:	83 c4 1c             	add    $0x1c,%esp
  8032ec:	5b                   	pop    %ebx
  8032ed:	5e                   	pop    %esi
  8032ee:	5f                   	pop    %edi
  8032ef:	5d                   	pop    %ebp
  8032f0:	c3                   	ret    
  8032f1:	8d 76 00             	lea    0x0(%esi),%esi
  8032f4:	2b 04 24             	sub    (%esp),%eax
  8032f7:	19 fa                	sbb    %edi,%edx
  8032f9:	89 d1                	mov    %edx,%ecx
  8032fb:	89 c6                	mov    %eax,%esi
  8032fd:	e9 71 ff ff ff       	jmp    803273 <__umoddi3+0xb3>
  803302:	66 90                	xchg   %ax,%ax
  803304:	39 44 24 04          	cmp    %eax,0x4(%esp)
  803308:	72 ea                	jb     8032f4 <__umoddi3+0x134>
  80330a:	89 d9                	mov    %ebx,%ecx
  80330c:	e9 62 ff ff ff       	jmp    803273 <__umoddi3+0xb3>
