
obj/user/tst_sharing_1:     file format elf32-i386


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
  800031:	e8 27 03 00 00       	call   80035d <libmain>
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
  80003c:	83 ec 24             	sub    $0x24,%esp
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
  80008d:	68 e0 32 80 00       	push   $0x8032e0
  800092:	6a 12                	push   $0x12
  800094:	68 fc 32 80 00       	push   $0x8032fc
  800099:	e8 fb 03 00 00       	call   800499 <_panic>
	}
	/*Dummy malloc to enforce the UHEAP initializations*/
	malloc(0);
  80009e:	83 ec 0c             	sub    $0xc,%esp
  8000a1:	6a 00                	push   $0x0
  8000a3:	e8 37 16 00 00       	call   8016df <malloc>
  8000a8:	83 c4 10             	add    $0x10,%esp
	/*=================================================*/

	uint32 *x, *y, *z ;
	uint32 expected ;
	cprintf("STEP A: checking the creation of shared variables... \n");
  8000ab:	83 ec 0c             	sub    $0xc,%esp
  8000ae:	68 14 33 80 00       	push   $0x803314
  8000b3:	e8 95 06 00 00       	call   80074d <cprintf>
  8000b8:	83 c4 10             	add    $0x10,%esp
	{
		int freeFrames = sys_calculate_free_frames() ;
  8000bb:	e8 2b 1a 00 00       	call   801aeb <sys_calculate_free_frames>
  8000c0:	89 45 e8             	mov    %eax,-0x18(%ebp)
		x = smalloc("x", PAGE_SIZE, 1);
  8000c3:	83 ec 04             	sub    $0x4,%esp
  8000c6:	6a 01                	push   $0x1
  8000c8:	68 00 10 00 00       	push   $0x1000
  8000cd:	68 4b 33 80 00       	push   $0x80334b
  8000d2:	e8 50 17 00 00       	call   801827 <smalloc>
  8000d7:	83 c4 10             	add    $0x10,%esp
  8000da:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		if (x != (uint32*)USER_HEAP_START) panic("Returned address is not correct. check the setting of it and/or the updating of the shared_mem_free_address");
  8000dd:	81 7d e4 00 00 00 80 	cmpl   $0x80000000,-0x1c(%ebp)
  8000e4:	74 14                	je     8000fa <_main+0xc2>
  8000e6:	83 ec 04             	sub    $0x4,%esp
  8000e9:	68 50 33 80 00       	push   $0x803350
  8000ee:	6a 1e                	push   $0x1e
  8000f0:	68 fc 32 80 00       	push   $0x8032fc
  8000f5:	e8 9f 03 00 00       	call   800499 <_panic>
		expected = 1+1+2 ;
  8000fa:	c7 45 e0 04 00 00 00 	movl   $0x4,-0x20(%ebp)
		if ((freeFrames - sys_calculate_free_frames()) !=  expected) panic("Wrong allocation (current=%d, expected=%d): make sure that you allocate the required space in the user environment and add its frames to frames_storage", freeFrames - sys_calculate_free_frames(), expected);
  800101:	8b 5d e8             	mov    -0x18(%ebp),%ebx
  800104:	e8 e2 19 00 00       	call   801aeb <sys_calculate_free_frames>
  800109:	29 c3                	sub    %eax,%ebx
  80010b:	89 d8                	mov    %ebx,%eax
  80010d:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  800110:	74 24                	je     800136 <_main+0xfe>
  800112:	8b 5d e8             	mov    -0x18(%ebp),%ebx
  800115:	e8 d1 19 00 00       	call   801aeb <sys_calculate_free_frames>
  80011a:	29 c3                	sub    %eax,%ebx
  80011c:	89 d8                	mov    %ebx,%eax
  80011e:	83 ec 0c             	sub    $0xc,%esp
  800121:	ff 75 e0             	pushl  -0x20(%ebp)
  800124:	50                   	push   %eax
  800125:	68 bc 33 80 00       	push   $0x8033bc
  80012a:	6a 20                	push   $0x20
  80012c:	68 fc 32 80 00       	push   $0x8032fc
  800131:	e8 63 03 00 00       	call   800499 <_panic>

		freeFrames = sys_calculate_free_frames() ;
  800136:	e8 b0 19 00 00       	call   801aeb <sys_calculate_free_frames>
  80013b:	89 45 e8             	mov    %eax,-0x18(%ebp)
		z = smalloc("z", PAGE_SIZE + 4, 1);
  80013e:	83 ec 04             	sub    $0x4,%esp
  800141:	6a 01                	push   $0x1
  800143:	68 04 10 00 00       	push   $0x1004
  800148:	68 54 34 80 00       	push   $0x803454
  80014d:	e8 d5 16 00 00       	call   801827 <smalloc>
  800152:	83 c4 10             	add    $0x10,%esp
  800155:	89 45 dc             	mov    %eax,-0x24(%ebp)
		if (z != (uint32*)(USER_HEAP_START + 1 * PAGE_SIZE)) panic("Returned address is not correct. check the setting of it and/or the updating of the shared_mem_free_address");
  800158:	81 7d dc 00 10 00 80 	cmpl   $0x80001000,-0x24(%ebp)
  80015f:	74 14                	je     800175 <_main+0x13d>
  800161:	83 ec 04             	sub    $0x4,%esp
  800164:	68 50 33 80 00       	push   $0x803350
  800169:	6a 24                	push   $0x24
  80016b:	68 fc 32 80 00       	push   $0x8032fc
  800170:	e8 24 03 00 00       	call   800499 <_panic>
		if ((freeFrames - sys_calculate_free_frames()) !=  2+0+2) panic("Wrong allocation: make sure that you allocate the required space in the user environment and add its frames to frames_storage");
  800175:	8b 5d e8             	mov    -0x18(%ebp),%ebx
  800178:	e8 6e 19 00 00       	call   801aeb <sys_calculate_free_frames>
  80017d:	29 c3                	sub    %eax,%ebx
  80017f:	89 d8                	mov    %ebx,%eax
  800181:	83 f8 04             	cmp    $0x4,%eax
  800184:	74 14                	je     80019a <_main+0x162>
  800186:	83 ec 04             	sub    $0x4,%esp
  800189:	68 58 34 80 00       	push   $0x803458
  80018e:	6a 25                	push   $0x25
  800190:	68 fc 32 80 00       	push   $0x8032fc
  800195:	e8 ff 02 00 00       	call   800499 <_panic>

		freeFrames = sys_calculate_free_frames() ;
  80019a:	e8 4c 19 00 00       	call   801aeb <sys_calculate_free_frames>
  80019f:	89 45 e8             	mov    %eax,-0x18(%ebp)
		y = smalloc("y", 4, 1);
  8001a2:	83 ec 04             	sub    $0x4,%esp
  8001a5:	6a 01                	push   $0x1
  8001a7:	6a 04                	push   $0x4
  8001a9:	68 d6 34 80 00       	push   $0x8034d6
  8001ae:	e8 74 16 00 00       	call   801827 <smalloc>
  8001b3:	83 c4 10             	add    $0x10,%esp
  8001b6:	89 45 d8             	mov    %eax,-0x28(%ebp)
		if (y != (uint32*)(USER_HEAP_START + 3 * PAGE_SIZE)) panic("Returned address is not correct. check the setting of it and/or the updating of the shared_mem_free_address");
  8001b9:	81 7d d8 00 30 00 80 	cmpl   $0x80003000,-0x28(%ebp)
  8001c0:	74 14                	je     8001d6 <_main+0x19e>
  8001c2:	83 ec 04             	sub    $0x4,%esp
  8001c5:	68 50 33 80 00       	push   $0x803350
  8001ca:	6a 29                	push   $0x29
  8001cc:	68 fc 32 80 00       	push   $0x8032fc
  8001d1:	e8 c3 02 00 00       	call   800499 <_panic>
		if ((freeFrames - sys_calculate_free_frames()) !=  1+0+2) panic("Wrong allocation: make sure that you allocate the required space in the user environment and add its frames to frames_storage");
  8001d6:	8b 5d e8             	mov    -0x18(%ebp),%ebx
  8001d9:	e8 0d 19 00 00       	call   801aeb <sys_calculate_free_frames>
  8001de:	29 c3                	sub    %eax,%ebx
  8001e0:	89 d8                	mov    %ebx,%eax
  8001e2:	83 f8 03             	cmp    $0x3,%eax
  8001e5:	74 14                	je     8001fb <_main+0x1c3>
  8001e7:	83 ec 04             	sub    $0x4,%esp
  8001ea:	68 58 34 80 00       	push   $0x803458
  8001ef:	6a 2a                	push   $0x2a
  8001f1:	68 fc 32 80 00       	push   $0x8032fc
  8001f6:	e8 9e 02 00 00       	call   800499 <_panic>
	}
	cprintf("Step A is completed successfully!!\n\n\n");
  8001fb:	83 ec 0c             	sub    $0xc,%esp
  8001fe:	68 d8 34 80 00       	push   $0x8034d8
  800203:	e8 45 05 00 00       	call   80074d <cprintf>
  800208:	83 c4 10             	add    $0x10,%esp


	cprintf("STEP B: checking reading & writing... \n");
  80020b:	83 ec 0c             	sub    $0xc,%esp
  80020e:	68 00 35 80 00       	push   $0x803500
  800213:	e8 35 05 00 00       	call   80074d <cprintf>
  800218:	83 c4 10             	add    $0x10,%esp
	{
		int i=0;
  80021b:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for(;i<PAGE_SIZE/4;i++)
  800222:	eb 2d                	jmp    800251 <_main+0x219>
		{
			x[i] = -1;
  800224:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800227:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80022e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800231:	01 d0                	add    %edx,%eax
  800233:	c7 00 ff ff ff ff    	movl   $0xffffffff,(%eax)
			y[i] = -1;
  800239:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80023c:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800243:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800246:	01 d0                	add    %edx,%eax
  800248:	c7 00 ff ff ff ff    	movl   $0xffffffff,(%eax)


	cprintf("STEP B: checking reading & writing... \n");
	{
		int i=0;
		for(;i<PAGE_SIZE/4;i++)
  80024e:	ff 45 ec             	incl   -0x14(%ebp)
  800251:	81 7d ec ff 03 00 00 	cmpl   $0x3ff,-0x14(%ebp)
  800258:	7e ca                	jle    800224 <_main+0x1ec>
		{
			x[i] = -1;
			y[i] = -1;
		}

		i=0;
  80025a:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for(;i<2*PAGE_SIZE/4;i++)
  800261:	eb 18                	jmp    80027b <_main+0x243>
		{
			z[i] = -1;
  800263:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800266:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80026d:	8b 45 dc             	mov    -0x24(%ebp),%eax
  800270:	01 d0                	add    %edx,%eax
  800272:	c7 00 ff ff ff ff    	movl   $0xffffffff,(%eax)
			x[i] = -1;
			y[i] = -1;
		}

		i=0;
		for(;i<2*PAGE_SIZE/4;i++)
  800278:	ff 45 ec             	incl   -0x14(%ebp)
  80027b:	81 7d ec ff 07 00 00 	cmpl   $0x7ff,-0x14(%ebp)
  800282:	7e df                	jle    800263 <_main+0x22b>
		{
			z[i] = -1;
		}

		if( x[0] !=  -1)  					panic("Reading/Writing of shared object is failed");
  800284:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800287:	8b 00                	mov    (%eax),%eax
  800289:	83 f8 ff             	cmp    $0xffffffff,%eax
  80028c:	74 14                	je     8002a2 <_main+0x26a>
  80028e:	83 ec 04             	sub    $0x4,%esp
  800291:	68 28 35 80 00       	push   $0x803528
  800296:	6a 3e                	push   $0x3e
  800298:	68 fc 32 80 00       	push   $0x8032fc
  80029d:	e8 f7 01 00 00       	call   800499 <_panic>
		if( x[PAGE_SIZE/4 - 1] !=  -1)  	panic("Reading/Writing of shared object is failed");
  8002a2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8002a5:	05 fc 0f 00 00       	add    $0xffc,%eax
  8002aa:	8b 00                	mov    (%eax),%eax
  8002ac:	83 f8 ff             	cmp    $0xffffffff,%eax
  8002af:	74 14                	je     8002c5 <_main+0x28d>
  8002b1:	83 ec 04             	sub    $0x4,%esp
  8002b4:	68 28 35 80 00       	push   $0x803528
  8002b9:	6a 3f                	push   $0x3f
  8002bb:	68 fc 32 80 00       	push   $0x8032fc
  8002c0:	e8 d4 01 00 00       	call   800499 <_panic>

		if( y[0] !=  -1)  					panic("Reading/Writing of shared object is failed");
  8002c5:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8002c8:	8b 00                	mov    (%eax),%eax
  8002ca:	83 f8 ff             	cmp    $0xffffffff,%eax
  8002cd:	74 14                	je     8002e3 <_main+0x2ab>
  8002cf:	83 ec 04             	sub    $0x4,%esp
  8002d2:	68 28 35 80 00       	push   $0x803528
  8002d7:	6a 41                	push   $0x41
  8002d9:	68 fc 32 80 00       	push   $0x8032fc
  8002de:	e8 b6 01 00 00       	call   800499 <_panic>
		if( y[PAGE_SIZE/4 - 1] !=  -1)  	panic("Reading/Writing of shared object is failed");
  8002e3:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8002e6:	05 fc 0f 00 00       	add    $0xffc,%eax
  8002eb:	8b 00                	mov    (%eax),%eax
  8002ed:	83 f8 ff             	cmp    $0xffffffff,%eax
  8002f0:	74 14                	je     800306 <_main+0x2ce>
  8002f2:	83 ec 04             	sub    $0x4,%esp
  8002f5:	68 28 35 80 00       	push   $0x803528
  8002fa:	6a 42                	push   $0x42
  8002fc:	68 fc 32 80 00       	push   $0x8032fc
  800301:	e8 93 01 00 00       	call   800499 <_panic>

		if( z[0] !=  -1)  					panic("Reading/Writing of shared object is failed");
  800306:	8b 45 dc             	mov    -0x24(%ebp),%eax
  800309:	8b 00                	mov    (%eax),%eax
  80030b:	83 f8 ff             	cmp    $0xffffffff,%eax
  80030e:	74 14                	je     800324 <_main+0x2ec>
  800310:	83 ec 04             	sub    $0x4,%esp
  800313:	68 28 35 80 00       	push   $0x803528
  800318:	6a 44                	push   $0x44
  80031a:	68 fc 32 80 00       	push   $0x8032fc
  80031f:	e8 75 01 00 00       	call   800499 <_panic>
		if( z[2*PAGE_SIZE/4 - 1] !=  -1)  	panic("Reading/Writing of shared object is failed");
  800324:	8b 45 dc             	mov    -0x24(%ebp),%eax
  800327:	05 fc 1f 00 00       	add    $0x1ffc,%eax
  80032c:	8b 00                	mov    (%eax),%eax
  80032e:	83 f8 ff             	cmp    $0xffffffff,%eax
  800331:	74 14                	je     800347 <_main+0x30f>
  800333:	83 ec 04             	sub    $0x4,%esp
  800336:	68 28 35 80 00       	push   $0x803528
  80033b:	6a 45                	push   $0x45
  80033d:	68 fc 32 80 00       	push   $0x8032fc
  800342:	e8 52 01 00 00       	call   800499 <_panic>
	}

	cprintf("Congratulations!! Test of Shared Variables [Create] [1] completed successfully!!\n\n\n");
  800347:	83 ec 0c             	sub    $0xc,%esp
  80034a:	68 54 35 80 00       	push   $0x803554
  80034f:	e8 f9 03 00 00       	call   80074d <cprintf>
  800354:	83 c4 10             	add    $0x10,%esp

	return;
  800357:	90                   	nop
}
  800358:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80035b:	c9                   	leave  
  80035c:	c3                   	ret    

0080035d <libmain>:
volatile struct Env *myEnv = NULL;
volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";

void
libmain(int argc, char **argv)
{
  80035d:	55                   	push   %ebp
  80035e:	89 e5                	mov    %esp,%ebp
  800360:	83 ec 18             	sub    $0x18,%esp
	int envIndex = sys_getenvindex();
  800363:	e8 63 1a 00 00       	call   801dcb <sys_getenvindex>
  800368:	89 45 f4             	mov    %eax,-0xc(%ebp)
	myEnv = &(envs[envIndex]);
  80036b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80036e:	89 d0                	mov    %edx,%eax
  800370:	c1 e0 03             	shl    $0x3,%eax
  800373:	01 d0                	add    %edx,%eax
  800375:	01 c0                	add    %eax,%eax
  800377:	01 d0                	add    %edx,%eax
  800379:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800380:	01 d0                	add    %edx,%eax
  800382:	c1 e0 04             	shl    $0x4,%eax
  800385:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  80038a:	a3 20 40 80 00       	mov    %eax,0x804020

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  80038f:	a1 20 40 80 00       	mov    0x804020,%eax
  800394:	8a 80 5c 05 00 00    	mov    0x55c(%eax),%al
  80039a:	84 c0                	test   %al,%al
  80039c:	74 0f                	je     8003ad <libmain+0x50>
		binaryname = myEnv->prog_name;
  80039e:	a1 20 40 80 00       	mov    0x804020,%eax
  8003a3:	05 5c 05 00 00       	add    $0x55c,%eax
  8003a8:	a3 00 40 80 00       	mov    %eax,0x804000

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  8003ad:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8003b1:	7e 0a                	jle    8003bd <libmain+0x60>
		binaryname = argv[0];
  8003b3:	8b 45 0c             	mov    0xc(%ebp),%eax
  8003b6:	8b 00                	mov    (%eax),%eax
  8003b8:	a3 00 40 80 00       	mov    %eax,0x804000

	// call user main routine
	_main(argc, argv);
  8003bd:	83 ec 08             	sub    $0x8,%esp
  8003c0:	ff 75 0c             	pushl  0xc(%ebp)
  8003c3:	ff 75 08             	pushl  0x8(%ebp)
  8003c6:	e8 6d fc ff ff       	call   800038 <_main>
  8003cb:	83 c4 10             	add    $0x10,%esp



	sys_disable_interrupt();
  8003ce:	e8 05 18 00 00       	call   801bd8 <sys_disable_interrupt>
	cprintf("**************************************\n");
  8003d3:	83 ec 0c             	sub    $0xc,%esp
  8003d6:	68 c0 35 80 00       	push   $0x8035c0
  8003db:	e8 6d 03 00 00       	call   80074d <cprintf>
  8003e0:	83 c4 10             	add    $0x10,%esp
	cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  8003e3:	a1 20 40 80 00       	mov    0x804020,%eax
  8003e8:	8b 90 44 05 00 00    	mov    0x544(%eax),%edx
  8003ee:	a1 20 40 80 00       	mov    0x804020,%eax
  8003f3:	8b 80 34 05 00 00    	mov    0x534(%eax),%eax
  8003f9:	83 ec 04             	sub    $0x4,%esp
  8003fc:	52                   	push   %edx
  8003fd:	50                   	push   %eax
  8003fe:	68 e8 35 80 00       	push   $0x8035e8
  800403:	e8 45 03 00 00       	call   80074d <cprintf>
  800408:	83 c4 10             	add    $0x10,%esp
	cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  80040b:	a1 20 40 80 00       	mov    0x804020,%eax
  800410:	8b 88 54 05 00 00    	mov    0x554(%eax),%ecx
  800416:	a1 20 40 80 00       	mov    0x804020,%eax
  80041b:	8b 90 50 05 00 00    	mov    0x550(%eax),%edx
  800421:	a1 20 40 80 00       	mov    0x804020,%eax
  800426:	8b 80 4c 05 00 00    	mov    0x54c(%eax),%eax
  80042c:	51                   	push   %ecx
  80042d:	52                   	push   %edx
  80042e:	50                   	push   %eax
  80042f:	68 10 36 80 00       	push   $0x803610
  800434:	e8 14 03 00 00       	call   80074d <cprintf>
  800439:	83 c4 10             	add    $0x10,%esp
	//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
	cprintf("Num of clocks = %d\n", myEnv->nClocks);
  80043c:	a1 20 40 80 00       	mov    0x804020,%eax
  800441:	8b 80 a4 05 00 00    	mov    0x5a4(%eax),%eax
  800447:	83 ec 08             	sub    $0x8,%esp
  80044a:	50                   	push   %eax
  80044b:	68 68 36 80 00       	push   $0x803668
  800450:	e8 f8 02 00 00       	call   80074d <cprintf>
  800455:	83 c4 10             	add    $0x10,%esp
	cprintf("**************************************\n");
  800458:	83 ec 0c             	sub    $0xc,%esp
  80045b:	68 c0 35 80 00       	push   $0x8035c0
  800460:	e8 e8 02 00 00       	call   80074d <cprintf>
  800465:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  800468:	e8 85 17 00 00       	call   801bf2 <sys_enable_interrupt>

	// exit gracefully
	exit();
  80046d:	e8 19 00 00 00       	call   80048b <exit>
}
  800472:	90                   	nop
  800473:	c9                   	leave  
  800474:	c3                   	ret    

00800475 <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  800475:	55                   	push   %ebp
  800476:	89 e5                	mov    %esp,%ebp
  800478:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  80047b:	83 ec 0c             	sub    $0xc,%esp
  80047e:	6a 00                	push   $0x0
  800480:	e8 12 19 00 00       	call   801d97 <sys_destroy_env>
  800485:	83 c4 10             	add    $0x10,%esp
}
  800488:	90                   	nop
  800489:	c9                   	leave  
  80048a:	c3                   	ret    

0080048b <exit>:

void
exit(void)
{
  80048b:	55                   	push   %ebp
  80048c:	89 e5                	mov    %esp,%ebp
  80048e:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  800491:	e8 67 19 00 00       	call   801dfd <sys_exit_env>
}
  800496:	90                   	nop
  800497:	c9                   	leave  
  800498:	c3                   	ret    

00800499 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  800499:	55                   	push   %ebp
  80049a:	89 e5                	mov    %esp,%ebp
  80049c:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  80049f:	8d 45 10             	lea    0x10(%ebp),%eax
  8004a2:	83 c0 04             	add    $0x4,%eax
  8004a5:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  8004a8:	a1 5c 41 80 00       	mov    0x80415c,%eax
  8004ad:	85 c0                	test   %eax,%eax
  8004af:	74 16                	je     8004c7 <_panic+0x2e>
		cprintf("%s: ", argv0);
  8004b1:	a1 5c 41 80 00       	mov    0x80415c,%eax
  8004b6:	83 ec 08             	sub    $0x8,%esp
  8004b9:	50                   	push   %eax
  8004ba:	68 7c 36 80 00       	push   $0x80367c
  8004bf:	e8 89 02 00 00       	call   80074d <cprintf>
  8004c4:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  8004c7:	a1 00 40 80 00       	mov    0x804000,%eax
  8004cc:	ff 75 0c             	pushl  0xc(%ebp)
  8004cf:	ff 75 08             	pushl  0x8(%ebp)
  8004d2:	50                   	push   %eax
  8004d3:	68 81 36 80 00       	push   $0x803681
  8004d8:	e8 70 02 00 00       	call   80074d <cprintf>
  8004dd:	83 c4 10             	add    $0x10,%esp
	vcprintf(fmt, ap);
  8004e0:	8b 45 10             	mov    0x10(%ebp),%eax
  8004e3:	83 ec 08             	sub    $0x8,%esp
  8004e6:	ff 75 f4             	pushl  -0xc(%ebp)
  8004e9:	50                   	push   %eax
  8004ea:	e8 f3 01 00 00       	call   8006e2 <vcprintf>
  8004ef:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  8004f2:	83 ec 08             	sub    $0x8,%esp
  8004f5:	6a 00                	push   $0x0
  8004f7:	68 9d 36 80 00       	push   $0x80369d
  8004fc:	e8 e1 01 00 00       	call   8006e2 <vcprintf>
  800501:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  800504:	e8 82 ff ff ff       	call   80048b <exit>

	// should not return here
	while (1) ;
  800509:	eb fe                	jmp    800509 <_panic+0x70>

0080050b <CheckWSWithoutLastIndex>:
}

void CheckWSWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  80050b:	55                   	push   %ebp
  80050c:	89 e5                	mov    %esp,%ebp
  80050e:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  800511:	a1 20 40 80 00       	mov    0x804020,%eax
  800516:	8b 50 74             	mov    0x74(%eax),%edx
  800519:	8b 45 0c             	mov    0xc(%ebp),%eax
  80051c:	39 c2                	cmp    %eax,%edx
  80051e:	74 14                	je     800534 <CheckWSWithoutLastIndex+0x29>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  800520:	83 ec 04             	sub    $0x4,%esp
  800523:	68 a0 36 80 00       	push   $0x8036a0
  800528:	6a 26                	push   $0x26
  80052a:	68 ec 36 80 00       	push   $0x8036ec
  80052f:	e8 65 ff ff ff       	call   800499 <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  800534:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  80053b:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800542:	e9 c2 00 00 00       	jmp    800609 <CheckWSWithoutLastIndex+0xfe>
		if (expectedPages[e] == 0) {
  800547:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80054a:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800551:	8b 45 08             	mov    0x8(%ebp),%eax
  800554:	01 d0                	add    %edx,%eax
  800556:	8b 00                	mov    (%eax),%eax
  800558:	85 c0                	test   %eax,%eax
  80055a:	75 08                	jne    800564 <CheckWSWithoutLastIndex+0x59>
			expectedNumOfEmptyLocs++;
  80055c:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  80055f:	e9 a2 00 00 00       	jmp    800606 <CheckWSWithoutLastIndex+0xfb>
		}
		int found = 0;
  800564:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  80056b:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  800572:	eb 69                	jmp    8005dd <CheckWSWithoutLastIndex+0xd2>
			if (myEnv->__uptr_pws[w].empty == 0) {
  800574:	a1 20 40 80 00       	mov    0x804020,%eax
  800579:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  80057f:	8b 55 e8             	mov    -0x18(%ebp),%edx
  800582:	89 d0                	mov    %edx,%eax
  800584:	01 c0                	add    %eax,%eax
  800586:	01 d0                	add    %edx,%eax
  800588:	c1 e0 03             	shl    $0x3,%eax
  80058b:	01 c8                	add    %ecx,%eax
  80058d:	8a 40 04             	mov    0x4(%eax),%al
  800590:	84 c0                	test   %al,%al
  800592:	75 46                	jne    8005da <CheckWSWithoutLastIndex+0xcf>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  800594:	a1 20 40 80 00       	mov    0x804020,%eax
  800599:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  80059f:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8005a2:	89 d0                	mov    %edx,%eax
  8005a4:	01 c0                	add    %eax,%eax
  8005a6:	01 d0                	add    %edx,%eax
  8005a8:	c1 e0 03             	shl    $0x3,%eax
  8005ab:	01 c8                	add    %ecx,%eax
  8005ad:	8b 00                	mov    (%eax),%eax
  8005af:	89 45 dc             	mov    %eax,-0x24(%ebp)
  8005b2:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8005b5:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8005ba:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  8005bc:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8005bf:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  8005c6:	8b 45 08             	mov    0x8(%ebp),%eax
  8005c9:	01 c8                	add    %ecx,%eax
  8005cb:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  8005cd:	39 c2                	cmp    %eax,%edx
  8005cf:	75 09                	jne    8005da <CheckWSWithoutLastIndex+0xcf>
						== expectedPages[e]) {
					found = 1;
  8005d1:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  8005d8:	eb 12                	jmp    8005ec <CheckWSWithoutLastIndex+0xe1>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8005da:	ff 45 e8             	incl   -0x18(%ebp)
  8005dd:	a1 20 40 80 00       	mov    0x804020,%eax
  8005e2:	8b 50 74             	mov    0x74(%eax),%edx
  8005e5:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8005e8:	39 c2                	cmp    %eax,%edx
  8005ea:	77 88                	ja     800574 <CheckWSWithoutLastIndex+0x69>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  8005ec:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8005f0:	75 14                	jne    800606 <CheckWSWithoutLastIndex+0xfb>
			panic(
  8005f2:	83 ec 04             	sub    $0x4,%esp
  8005f5:	68 f8 36 80 00       	push   $0x8036f8
  8005fa:	6a 3a                	push   $0x3a
  8005fc:	68 ec 36 80 00       	push   $0x8036ec
  800601:	e8 93 fe ff ff       	call   800499 <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  800606:	ff 45 f0             	incl   -0x10(%ebp)
  800609:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80060c:	3b 45 0c             	cmp    0xc(%ebp),%eax
  80060f:	0f 8c 32 ff ff ff    	jl     800547 <CheckWSWithoutLastIndex+0x3c>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  800615:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  80061c:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  800623:	eb 26                	jmp    80064b <CheckWSWithoutLastIndex+0x140>
		if (myEnv->__uptr_pws[w].empty == 1) {
  800625:	a1 20 40 80 00       	mov    0x804020,%eax
  80062a:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  800630:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800633:	89 d0                	mov    %edx,%eax
  800635:	01 c0                	add    %eax,%eax
  800637:	01 d0                	add    %edx,%eax
  800639:	c1 e0 03             	shl    $0x3,%eax
  80063c:	01 c8                	add    %ecx,%eax
  80063e:	8a 40 04             	mov    0x4(%eax),%al
  800641:	3c 01                	cmp    $0x1,%al
  800643:	75 03                	jne    800648 <CheckWSWithoutLastIndex+0x13d>
			actualNumOfEmptyLocs++;
  800645:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800648:	ff 45 e0             	incl   -0x20(%ebp)
  80064b:	a1 20 40 80 00       	mov    0x804020,%eax
  800650:	8b 50 74             	mov    0x74(%eax),%edx
  800653:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800656:	39 c2                	cmp    %eax,%edx
  800658:	77 cb                	ja     800625 <CheckWSWithoutLastIndex+0x11a>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  80065a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80065d:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  800660:	74 14                	je     800676 <CheckWSWithoutLastIndex+0x16b>
		panic(
  800662:	83 ec 04             	sub    $0x4,%esp
  800665:	68 4c 37 80 00       	push   $0x80374c
  80066a:	6a 44                	push   $0x44
  80066c:	68 ec 36 80 00       	push   $0x8036ec
  800671:	e8 23 fe ff ff       	call   800499 <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  800676:	90                   	nop
  800677:	c9                   	leave  
  800678:	c3                   	ret    

00800679 <putch>:
};

//2017:
uint8 printProgName = 0;

static void putch(int ch, struct printbuf *b) {
  800679:	55                   	push   %ebp
  80067a:	89 e5                	mov    %esp,%ebp
  80067c:	83 ec 08             	sub    $0x8,%esp
	b->buf[b->idx++] = ch;
  80067f:	8b 45 0c             	mov    0xc(%ebp),%eax
  800682:	8b 00                	mov    (%eax),%eax
  800684:	8d 48 01             	lea    0x1(%eax),%ecx
  800687:	8b 55 0c             	mov    0xc(%ebp),%edx
  80068a:	89 0a                	mov    %ecx,(%edx)
  80068c:	8b 55 08             	mov    0x8(%ebp),%edx
  80068f:	88 d1                	mov    %dl,%cl
  800691:	8b 55 0c             	mov    0xc(%ebp),%edx
  800694:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  800698:	8b 45 0c             	mov    0xc(%ebp),%eax
  80069b:	8b 00                	mov    (%eax),%eax
  80069d:	3d ff 00 00 00       	cmp    $0xff,%eax
  8006a2:	75 2c                	jne    8006d0 <putch+0x57>
		sys_cputs(b->buf, b->idx, printProgName);
  8006a4:	a0 24 40 80 00       	mov    0x804024,%al
  8006a9:	0f b6 c0             	movzbl %al,%eax
  8006ac:	8b 55 0c             	mov    0xc(%ebp),%edx
  8006af:	8b 12                	mov    (%edx),%edx
  8006b1:	89 d1                	mov    %edx,%ecx
  8006b3:	8b 55 0c             	mov    0xc(%ebp),%edx
  8006b6:	83 c2 08             	add    $0x8,%edx
  8006b9:	83 ec 04             	sub    $0x4,%esp
  8006bc:	50                   	push   %eax
  8006bd:	51                   	push   %ecx
  8006be:	52                   	push   %edx
  8006bf:	e8 66 13 00 00       	call   801a2a <sys_cputs>
  8006c4:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  8006c7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8006ca:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  8006d0:	8b 45 0c             	mov    0xc(%ebp),%eax
  8006d3:	8b 40 04             	mov    0x4(%eax),%eax
  8006d6:	8d 50 01             	lea    0x1(%eax),%edx
  8006d9:	8b 45 0c             	mov    0xc(%ebp),%eax
  8006dc:	89 50 04             	mov    %edx,0x4(%eax)
}
  8006df:	90                   	nop
  8006e0:	c9                   	leave  
  8006e1:	c3                   	ret    

008006e2 <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  8006e2:	55                   	push   %ebp
  8006e3:	89 e5                	mov    %esp,%ebp
  8006e5:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  8006eb:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  8006f2:	00 00 00 
	b.cnt = 0;
  8006f5:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  8006fc:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  8006ff:	ff 75 0c             	pushl  0xc(%ebp)
  800702:	ff 75 08             	pushl  0x8(%ebp)
  800705:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  80070b:	50                   	push   %eax
  80070c:	68 79 06 80 00       	push   $0x800679
  800711:	e8 11 02 00 00       	call   800927 <vprintfmt>
  800716:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName);
  800719:	a0 24 40 80 00       	mov    0x804024,%al
  80071e:	0f b6 c0             	movzbl %al,%eax
  800721:	8b 95 f0 fe ff ff    	mov    -0x110(%ebp),%edx
  800727:	83 ec 04             	sub    $0x4,%esp
  80072a:	50                   	push   %eax
  80072b:	52                   	push   %edx
  80072c:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800732:	83 c0 08             	add    $0x8,%eax
  800735:	50                   	push   %eax
  800736:	e8 ef 12 00 00       	call   801a2a <sys_cputs>
  80073b:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  80073e:	c6 05 24 40 80 00 00 	movb   $0x0,0x804024
	return b.cnt;
  800745:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  80074b:	c9                   	leave  
  80074c:	c3                   	ret    

0080074d <cprintf>:

int cprintf(const char *fmt, ...) {
  80074d:	55                   	push   %ebp
  80074e:	89 e5                	mov    %esp,%ebp
  800750:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  800753:	c6 05 24 40 80 00 01 	movb   $0x1,0x804024
	va_start(ap, fmt);
  80075a:	8d 45 0c             	lea    0xc(%ebp),%eax
  80075d:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800760:	8b 45 08             	mov    0x8(%ebp),%eax
  800763:	83 ec 08             	sub    $0x8,%esp
  800766:	ff 75 f4             	pushl  -0xc(%ebp)
  800769:	50                   	push   %eax
  80076a:	e8 73 ff ff ff       	call   8006e2 <vcprintf>
  80076f:	83 c4 10             	add    $0x10,%esp
  800772:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  800775:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800778:	c9                   	leave  
  800779:	c3                   	ret    

0080077a <atomic_cprintf>:

int atomic_cprintf(const char *fmt, ...) {
  80077a:	55                   	push   %ebp
  80077b:	89 e5                	mov    %esp,%ebp
  80077d:	83 ec 18             	sub    $0x18,%esp
	sys_disable_interrupt();
  800780:	e8 53 14 00 00       	call   801bd8 <sys_disable_interrupt>
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  800785:	8d 45 0c             	lea    0xc(%ebp),%eax
  800788:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  80078b:	8b 45 08             	mov    0x8(%ebp),%eax
  80078e:	83 ec 08             	sub    $0x8,%esp
  800791:	ff 75 f4             	pushl  -0xc(%ebp)
  800794:	50                   	push   %eax
  800795:	e8 48 ff ff ff       	call   8006e2 <vcprintf>
  80079a:	83 c4 10             	add    $0x10,%esp
  80079d:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	sys_enable_interrupt();
  8007a0:	e8 4d 14 00 00       	call   801bf2 <sys_enable_interrupt>
	return cnt;
  8007a5:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8007a8:	c9                   	leave  
  8007a9:	c3                   	ret    

008007aa <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  8007aa:	55                   	push   %ebp
  8007ab:	89 e5                	mov    %esp,%ebp
  8007ad:	53                   	push   %ebx
  8007ae:	83 ec 14             	sub    $0x14,%esp
  8007b1:	8b 45 10             	mov    0x10(%ebp),%eax
  8007b4:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8007b7:	8b 45 14             	mov    0x14(%ebp),%eax
  8007ba:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  8007bd:	8b 45 18             	mov    0x18(%ebp),%eax
  8007c0:	ba 00 00 00 00       	mov    $0x0,%edx
  8007c5:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  8007c8:	77 55                	ja     80081f <printnum+0x75>
  8007ca:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  8007cd:	72 05                	jb     8007d4 <printnum+0x2a>
  8007cf:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8007d2:	77 4b                	ja     80081f <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  8007d4:	8b 45 1c             	mov    0x1c(%ebp),%eax
  8007d7:	8d 58 ff             	lea    -0x1(%eax),%ebx
  8007da:	8b 45 18             	mov    0x18(%ebp),%eax
  8007dd:	ba 00 00 00 00       	mov    $0x0,%edx
  8007e2:	52                   	push   %edx
  8007e3:	50                   	push   %eax
  8007e4:	ff 75 f4             	pushl  -0xc(%ebp)
  8007e7:	ff 75 f0             	pushl  -0x10(%ebp)
  8007ea:	e8 85 28 00 00       	call   803074 <__udivdi3>
  8007ef:	83 c4 10             	add    $0x10,%esp
  8007f2:	83 ec 04             	sub    $0x4,%esp
  8007f5:	ff 75 20             	pushl  0x20(%ebp)
  8007f8:	53                   	push   %ebx
  8007f9:	ff 75 18             	pushl  0x18(%ebp)
  8007fc:	52                   	push   %edx
  8007fd:	50                   	push   %eax
  8007fe:	ff 75 0c             	pushl  0xc(%ebp)
  800801:	ff 75 08             	pushl  0x8(%ebp)
  800804:	e8 a1 ff ff ff       	call   8007aa <printnum>
  800809:	83 c4 20             	add    $0x20,%esp
  80080c:	eb 1a                	jmp    800828 <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  80080e:	83 ec 08             	sub    $0x8,%esp
  800811:	ff 75 0c             	pushl  0xc(%ebp)
  800814:	ff 75 20             	pushl  0x20(%ebp)
  800817:	8b 45 08             	mov    0x8(%ebp),%eax
  80081a:	ff d0                	call   *%eax
  80081c:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  80081f:	ff 4d 1c             	decl   0x1c(%ebp)
  800822:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  800826:	7f e6                	jg     80080e <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800828:	8b 4d 18             	mov    0x18(%ebp),%ecx
  80082b:	bb 00 00 00 00       	mov    $0x0,%ebx
  800830:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800833:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800836:	53                   	push   %ebx
  800837:	51                   	push   %ecx
  800838:	52                   	push   %edx
  800839:	50                   	push   %eax
  80083a:	e8 45 29 00 00       	call   803184 <__umoddi3>
  80083f:	83 c4 10             	add    $0x10,%esp
  800842:	05 b4 39 80 00       	add    $0x8039b4,%eax
  800847:	8a 00                	mov    (%eax),%al
  800849:	0f be c0             	movsbl %al,%eax
  80084c:	83 ec 08             	sub    $0x8,%esp
  80084f:	ff 75 0c             	pushl  0xc(%ebp)
  800852:	50                   	push   %eax
  800853:	8b 45 08             	mov    0x8(%ebp),%eax
  800856:	ff d0                	call   *%eax
  800858:	83 c4 10             	add    $0x10,%esp
}
  80085b:	90                   	nop
  80085c:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80085f:	c9                   	leave  
  800860:	c3                   	ret    

00800861 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  800861:	55                   	push   %ebp
  800862:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800864:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800868:	7e 1c                	jle    800886 <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  80086a:	8b 45 08             	mov    0x8(%ebp),%eax
  80086d:	8b 00                	mov    (%eax),%eax
  80086f:	8d 50 08             	lea    0x8(%eax),%edx
  800872:	8b 45 08             	mov    0x8(%ebp),%eax
  800875:	89 10                	mov    %edx,(%eax)
  800877:	8b 45 08             	mov    0x8(%ebp),%eax
  80087a:	8b 00                	mov    (%eax),%eax
  80087c:	83 e8 08             	sub    $0x8,%eax
  80087f:	8b 50 04             	mov    0x4(%eax),%edx
  800882:	8b 00                	mov    (%eax),%eax
  800884:	eb 40                	jmp    8008c6 <getuint+0x65>
	else if (lflag)
  800886:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80088a:	74 1e                	je     8008aa <getuint+0x49>
		return va_arg(*ap, unsigned long);
  80088c:	8b 45 08             	mov    0x8(%ebp),%eax
  80088f:	8b 00                	mov    (%eax),%eax
  800891:	8d 50 04             	lea    0x4(%eax),%edx
  800894:	8b 45 08             	mov    0x8(%ebp),%eax
  800897:	89 10                	mov    %edx,(%eax)
  800899:	8b 45 08             	mov    0x8(%ebp),%eax
  80089c:	8b 00                	mov    (%eax),%eax
  80089e:	83 e8 04             	sub    $0x4,%eax
  8008a1:	8b 00                	mov    (%eax),%eax
  8008a3:	ba 00 00 00 00       	mov    $0x0,%edx
  8008a8:	eb 1c                	jmp    8008c6 <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  8008aa:	8b 45 08             	mov    0x8(%ebp),%eax
  8008ad:	8b 00                	mov    (%eax),%eax
  8008af:	8d 50 04             	lea    0x4(%eax),%edx
  8008b2:	8b 45 08             	mov    0x8(%ebp),%eax
  8008b5:	89 10                	mov    %edx,(%eax)
  8008b7:	8b 45 08             	mov    0x8(%ebp),%eax
  8008ba:	8b 00                	mov    (%eax),%eax
  8008bc:	83 e8 04             	sub    $0x4,%eax
  8008bf:	8b 00                	mov    (%eax),%eax
  8008c1:	ba 00 00 00 00       	mov    $0x0,%edx
}
  8008c6:	5d                   	pop    %ebp
  8008c7:	c3                   	ret    

008008c8 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  8008c8:	55                   	push   %ebp
  8008c9:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  8008cb:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  8008cf:	7e 1c                	jle    8008ed <getint+0x25>
		return va_arg(*ap, long long);
  8008d1:	8b 45 08             	mov    0x8(%ebp),%eax
  8008d4:	8b 00                	mov    (%eax),%eax
  8008d6:	8d 50 08             	lea    0x8(%eax),%edx
  8008d9:	8b 45 08             	mov    0x8(%ebp),%eax
  8008dc:	89 10                	mov    %edx,(%eax)
  8008de:	8b 45 08             	mov    0x8(%ebp),%eax
  8008e1:	8b 00                	mov    (%eax),%eax
  8008e3:	83 e8 08             	sub    $0x8,%eax
  8008e6:	8b 50 04             	mov    0x4(%eax),%edx
  8008e9:	8b 00                	mov    (%eax),%eax
  8008eb:	eb 38                	jmp    800925 <getint+0x5d>
	else if (lflag)
  8008ed:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8008f1:	74 1a                	je     80090d <getint+0x45>
		return va_arg(*ap, long);
  8008f3:	8b 45 08             	mov    0x8(%ebp),%eax
  8008f6:	8b 00                	mov    (%eax),%eax
  8008f8:	8d 50 04             	lea    0x4(%eax),%edx
  8008fb:	8b 45 08             	mov    0x8(%ebp),%eax
  8008fe:	89 10                	mov    %edx,(%eax)
  800900:	8b 45 08             	mov    0x8(%ebp),%eax
  800903:	8b 00                	mov    (%eax),%eax
  800905:	83 e8 04             	sub    $0x4,%eax
  800908:	8b 00                	mov    (%eax),%eax
  80090a:	99                   	cltd   
  80090b:	eb 18                	jmp    800925 <getint+0x5d>
	else
		return va_arg(*ap, int);
  80090d:	8b 45 08             	mov    0x8(%ebp),%eax
  800910:	8b 00                	mov    (%eax),%eax
  800912:	8d 50 04             	lea    0x4(%eax),%edx
  800915:	8b 45 08             	mov    0x8(%ebp),%eax
  800918:	89 10                	mov    %edx,(%eax)
  80091a:	8b 45 08             	mov    0x8(%ebp),%eax
  80091d:	8b 00                	mov    (%eax),%eax
  80091f:	83 e8 04             	sub    $0x4,%eax
  800922:	8b 00                	mov    (%eax),%eax
  800924:	99                   	cltd   
}
  800925:	5d                   	pop    %ebp
  800926:	c3                   	ret    

00800927 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  800927:	55                   	push   %ebp
  800928:	89 e5                	mov    %esp,%ebp
  80092a:	56                   	push   %esi
  80092b:	53                   	push   %ebx
  80092c:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  80092f:	eb 17                	jmp    800948 <vprintfmt+0x21>
			if (ch == '\0')
  800931:	85 db                	test   %ebx,%ebx
  800933:	0f 84 af 03 00 00    	je     800ce8 <vprintfmt+0x3c1>
				return;
			putch(ch, putdat);
  800939:	83 ec 08             	sub    $0x8,%esp
  80093c:	ff 75 0c             	pushl  0xc(%ebp)
  80093f:	53                   	push   %ebx
  800940:	8b 45 08             	mov    0x8(%ebp),%eax
  800943:	ff d0                	call   *%eax
  800945:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800948:	8b 45 10             	mov    0x10(%ebp),%eax
  80094b:	8d 50 01             	lea    0x1(%eax),%edx
  80094e:	89 55 10             	mov    %edx,0x10(%ebp)
  800951:	8a 00                	mov    (%eax),%al
  800953:	0f b6 d8             	movzbl %al,%ebx
  800956:	83 fb 25             	cmp    $0x25,%ebx
  800959:	75 d6                	jne    800931 <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  80095b:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  80095f:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  800966:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  80096d:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  800974:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  80097b:	8b 45 10             	mov    0x10(%ebp),%eax
  80097e:	8d 50 01             	lea    0x1(%eax),%edx
  800981:	89 55 10             	mov    %edx,0x10(%ebp)
  800984:	8a 00                	mov    (%eax),%al
  800986:	0f b6 d8             	movzbl %al,%ebx
  800989:	8d 43 dd             	lea    -0x23(%ebx),%eax
  80098c:	83 f8 55             	cmp    $0x55,%eax
  80098f:	0f 87 2b 03 00 00    	ja     800cc0 <vprintfmt+0x399>
  800995:	8b 04 85 d8 39 80 00 	mov    0x8039d8(,%eax,4),%eax
  80099c:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  80099e:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  8009a2:	eb d7                	jmp    80097b <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  8009a4:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  8009a8:	eb d1                	jmp    80097b <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8009aa:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  8009b1:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8009b4:	89 d0                	mov    %edx,%eax
  8009b6:	c1 e0 02             	shl    $0x2,%eax
  8009b9:	01 d0                	add    %edx,%eax
  8009bb:	01 c0                	add    %eax,%eax
  8009bd:	01 d8                	add    %ebx,%eax
  8009bf:	83 e8 30             	sub    $0x30,%eax
  8009c2:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  8009c5:	8b 45 10             	mov    0x10(%ebp),%eax
  8009c8:	8a 00                	mov    (%eax),%al
  8009ca:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  8009cd:	83 fb 2f             	cmp    $0x2f,%ebx
  8009d0:	7e 3e                	jle    800a10 <vprintfmt+0xe9>
  8009d2:	83 fb 39             	cmp    $0x39,%ebx
  8009d5:	7f 39                	jg     800a10 <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8009d7:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  8009da:	eb d5                	jmp    8009b1 <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  8009dc:	8b 45 14             	mov    0x14(%ebp),%eax
  8009df:	83 c0 04             	add    $0x4,%eax
  8009e2:	89 45 14             	mov    %eax,0x14(%ebp)
  8009e5:	8b 45 14             	mov    0x14(%ebp),%eax
  8009e8:	83 e8 04             	sub    $0x4,%eax
  8009eb:	8b 00                	mov    (%eax),%eax
  8009ed:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  8009f0:	eb 1f                	jmp    800a11 <vprintfmt+0xea>

		case '.':
			if (width < 0)
  8009f2:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8009f6:	79 83                	jns    80097b <vprintfmt+0x54>
				width = 0;
  8009f8:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  8009ff:	e9 77 ff ff ff       	jmp    80097b <vprintfmt+0x54>

		case '#':
			altflag = 1;
  800a04:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  800a0b:	e9 6b ff ff ff       	jmp    80097b <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  800a10:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  800a11:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800a15:	0f 89 60 ff ff ff    	jns    80097b <vprintfmt+0x54>
				width = precision, precision = -1;
  800a1b:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800a1e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800a21:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  800a28:	e9 4e ff ff ff       	jmp    80097b <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  800a2d:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  800a30:	e9 46 ff ff ff       	jmp    80097b <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  800a35:	8b 45 14             	mov    0x14(%ebp),%eax
  800a38:	83 c0 04             	add    $0x4,%eax
  800a3b:	89 45 14             	mov    %eax,0x14(%ebp)
  800a3e:	8b 45 14             	mov    0x14(%ebp),%eax
  800a41:	83 e8 04             	sub    $0x4,%eax
  800a44:	8b 00                	mov    (%eax),%eax
  800a46:	83 ec 08             	sub    $0x8,%esp
  800a49:	ff 75 0c             	pushl  0xc(%ebp)
  800a4c:	50                   	push   %eax
  800a4d:	8b 45 08             	mov    0x8(%ebp),%eax
  800a50:	ff d0                	call   *%eax
  800a52:	83 c4 10             	add    $0x10,%esp
			break;
  800a55:	e9 89 02 00 00       	jmp    800ce3 <vprintfmt+0x3bc>

		// error message
		case 'e':
			err = va_arg(ap, int);
  800a5a:	8b 45 14             	mov    0x14(%ebp),%eax
  800a5d:	83 c0 04             	add    $0x4,%eax
  800a60:	89 45 14             	mov    %eax,0x14(%ebp)
  800a63:	8b 45 14             	mov    0x14(%ebp),%eax
  800a66:	83 e8 04             	sub    $0x4,%eax
  800a69:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  800a6b:	85 db                	test   %ebx,%ebx
  800a6d:	79 02                	jns    800a71 <vprintfmt+0x14a>
				err = -err;
  800a6f:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  800a71:	83 fb 64             	cmp    $0x64,%ebx
  800a74:	7f 0b                	jg     800a81 <vprintfmt+0x15a>
  800a76:	8b 34 9d 20 38 80 00 	mov    0x803820(,%ebx,4),%esi
  800a7d:	85 f6                	test   %esi,%esi
  800a7f:	75 19                	jne    800a9a <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  800a81:	53                   	push   %ebx
  800a82:	68 c5 39 80 00       	push   $0x8039c5
  800a87:	ff 75 0c             	pushl  0xc(%ebp)
  800a8a:	ff 75 08             	pushl  0x8(%ebp)
  800a8d:	e8 5e 02 00 00       	call   800cf0 <printfmt>
  800a92:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  800a95:	e9 49 02 00 00       	jmp    800ce3 <vprintfmt+0x3bc>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  800a9a:	56                   	push   %esi
  800a9b:	68 ce 39 80 00       	push   $0x8039ce
  800aa0:	ff 75 0c             	pushl  0xc(%ebp)
  800aa3:	ff 75 08             	pushl  0x8(%ebp)
  800aa6:	e8 45 02 00 00       	call   800cf0 <printfmt>
  800aab:	83 c4 10             	add    $0x10,%esp
			break;
  800aae:	e9 30 02 00 00       	jmp    800ce3 <vprintfmt+0x3bc>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  800ab3:	8b 45 14             	mov    0x14(%ebp),%eax
  800ab6:	83 c0 04             	add    $0x4,%eax
  800ab9:	89 45 14             	mov    %eax,0x14(%ebp)
  800abc:	8b 45 14             	mov    0x14(%ebp),%eax
  800abf:	83 e8 04             	sub    $0x4,%eax
  800ac2:	8b 30                	mov    (%eax),%esi
  800ac4:	85 f6                	test   %esi,%esi
  800ac6:	75 05                	jne    800acd <vprintfmt+0x1a6>
				p = "(null)";
  800ac8:	be d1 39 80 00       	mov    $0x8039d1,%esi
			if (width > 0 && padc != '-')
  800acd:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800ad1:	7e 6d                	jle    800b40 <vprintfmt+0x219>
  800ad3:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  800ad7:	74 67                	je     800b40 <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  800ad9:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800adc:	83 ec 08             	sub    $0x8,%esp
  800adf:	50                   	push   %eax
  800ae0:	56                   	push   %esi
  800ae1:	e8 0c 03 00 00       	call   800df2 <strnlen>
  800ae6:	83 c4 10             	add    $0x10,%esp
  800ae9:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  800aec:	eb 16                	jmp    800b04 <vprintfmt+0x1dd>
					putch(padc, putdat);
  800aee:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  800af2:	83 ec 08             	sub    $0x8,%esp
  800af5:	ff 75 0c             	pushl  0xc(%ebp)
  800af8:	50                   	push   %eax
  800af9:	8b 45 08             	mov    0x8(%ebp),%eax
  800afc:	ff d0                	call   *%eax
  800afe:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800b01:	ff 4d e4             	decl   -0x1c(%ebp)
  800b04:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800b08:	7f e4                	jg     800aee <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800b0a:	eb 34                	jmp    800b40 <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  800b0c:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  800b10:	74 1c                	je     800b2e <vprintfmt+0x207>
  800b12:	83 fb 1f             	cmp    $0x1f,%ebx
  800b15:	7e 05                	jle    800b1c <vprintfmt+0x1f5>
  800b17:	83 fb 7e             	cmp    $0x7e,%ebx
  800b1a:	7e 12                	jle    800b2e <vprintfmt+0x207>
					putch('?', putdat);
  800b1c:	83 ec 08             	sub    $0x8,%esp
  800b1f:	ff 75 0c             	pushl  0xc(%ebp)
  800b22:	6a 3f                	push   $0x3f
  800b24:	8b 45 08             	mov    0x8(%ebp),%eax
  800b27:	ff d0                	call   *%eax
  800b29:	83 c4 10             	add    $0x10,%esp
  800b2c:	eb 0f                	jmp    800b3d <vprintfmt+0x216>
				else
					putch(ch, putdat);
  800b2e:	83 ec 08             	sub    $0x8,%esp
  800b31:	ff 75 0c             	pushl  0xc(%ebp)
  800b34:	53                   	push   %ebx
  800b35:	8b 45 08             	mov    0x8(%ebp),%eax
  800b38:	ff d0                	call   *%eax
  800b3a:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800b3d:	ff 4d e4             	decl   -0x1c(%ebp)
  800b40:	89 f0                	mov    %esi,%eax
  800b42:	8d 70 01             	lea    0x1(%eax),%esi
  800b45:	8a 00                	mov    (%eax),%al
  800b47:	0f be d8             	movsbl %al,%ebx
  800b4a:	85 db                	test   %ebx,%ebx
  800b4c:	74 24                	je     800b72 <vprintfmt+0x24b>
  800b4e:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800b52:	78 b8                	js     800b0c <vprintfmt+0x1e5>
  800b54:	ff 4d e0             	decl   -0x20(%ebp)
  800b57:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800b5b:	79 af                	jns    800b0c <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800b5d:	eb 13                	jmp    800b72 <vprintfmt+0x24b>
				putch(' ', putdat);
  800b5f:	83 ec 08             	sub    $0x8,%esp
  800b62:	ff 75 0c             	pushl  0xc(%ebp)
  800b65:	6a 20                	push   $0x20
  800b67:	8b 45 08             	mov    0x8(%ebp),%eax
  800b6a:	ff d0                	call   *%eax
  800b6c:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800b6f:	ff 4d e4             	decl   -0x1c(%ebp)
  800b72:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800b76:	7f e7                	jg     800b5f <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  800b78:	e9 66 01 00 00       	jmp    800ce3 <vprintfmt+0x3bc>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  800b7d:	83 ec 08             	sub    $0x8,%esp
  800b80:	ff 75 e8             	pushl  -0x18(%ebp)
  800b83:	8d 45 14             	lea    0x14(%ebp),%eax
  800b86:	50                   	push   %eax
  800b87:	e8 3c fd ff ff       	call   8008c8 <getint>
  800b8c:	83 c4 10             	add    $0x10,%esp
  800b8f:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800b92:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  800b95:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800b98:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800b9b:	85 d2                	test   %edx,%edx
  800b9d:	79 23                	jns    800bc2 <vprintfmt+0x29b>
				putch('-', putdat);
  800b9f:	83 ec 08             	sub    $0x8,%esp
  800ba2:	ff 75 0c             	pushl  0xc(%ebp)
  800ba5:	6a 2d                	push   $0x2d
  800ba7:	8b 45 08             	mov    0x8(%ebp),%eax
  800baa:	ff d0                	call   *%eax
  800bac:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  800baf:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800bb2:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800bb5:	f7 d8                	neg    %eax
  800bb7:	83 d2 00             	adc    $0x0,%edx
  800bba:	f7 da                	neg    %edx
  800bbc:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800bbf:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  800bc2:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800bc9:	e9 bc 00 00 00       	jmp    800c8a <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  800bce:	83 ec 08             	sub    $0x8,%esp
  800bd1:	ff 75 e8             	pushl  -0x18(%ebp)
  800bd4:	8d 45 14             	lea    0x14(%ebp),%eax
  800bd7:	50                   	push   %eax
  800bd8:	e8 84 fc ff ff       	call   800861 <getuint>
  800bdd:	83 c4 10             	add    $0x10,%esp
  800be0:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800be3:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  800be6:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800bed:	e9 98 00 00 00       	jmp    800c8a <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  800bf2:	83 ec 08             	sub    $0x8,%esp
  800bf5:	ff 75 0c             	pushl  0xc(%ebp)
  800bf8:	6a 58                	push   $0x58
  800bfa:	8b 45 08             	mov    0x8(%ebp),%eax
  800bfd:	ff d0                	call   *%eax
  800bff:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800c02:	83 ec 08             	sub    $0x8,%esp
  800c05:	ff 75 0c             	pushl  0xc(%ebp)
  800c08:	6a 58                	push   $0x58
  800c0a:	8b 45 08             	mov    0x8(%ebp),%eax
  800c0d:	ff d0                	call   *%eax
  800c0f:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800c12:	83 ec 08             	sub    $0x8,%esp
  800c15:	ff 75 0c             	pushl  0xc(%ebp)
  800c18:	6a 58                	push   $0x58
  800c1a:	8b 45 08             	mov    0x8(%ebp),%eax
  800c1d:	ff d0                	call   *%eax
  800c1f:	83 c4 10             	add    $0x10,%esp
			break;
  800c22:	e9 bc 00 00 00       	jmp    800ce3 <vprintfmt+0x3bc>

		// pointer
		case 'p':
			putch('0', putdat);
  800c27:	83 ec 08             	sub    $0x8,%esp
  800c2a:	ff 75 0c             	pushl  0xc(%ebp)
  800c2d:	6a 30                	push   $0x30
  800c2f:	8b 45 08             	mov    0x8(%ebp),%eax
  800c32:	ff d0                	call   *%eax
  800c34:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  800c37:	83 ec 08             	sub    $0x8,%esp
  800c3a:	ff 75 0c             	pushl  0xc(%ebp)
  800c3d:	6a 78                	push   $0x78
  800c3f:	8b 45 08             	mov    0x8(%ebp),%eax
  800c42:	ff d0                	call   *%eax
  800c44:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  800c47:	8b 45 14             	mov    0x14(%ebp),%eax
  800c4a:	83 c0 04             	add    $0x4,%eax
  800c4d:	89 45 14             	mov    %eax,0x14(%ebp)
  800c50:	8b 45 14             	mov    0x14(%ebp),%eax
  800c53:	83 e8 04             	sub    $0x4,%eax
  800c56:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800c58:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800c5b:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  800c62:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  800c69:	eb 1f                	jmp    800c8a <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  800c6b:	83 ec 08             	sub    $0x8,%esp
  800c6e:	ff 75 e8             	pushl  -0x18(%ebp)
  800c71:	8d 45 14             	lea    0x14(%ebp),%eax
  800c74:	50                   	push   %eax
  800c75:	e8 e7 fb ff ff       	call   800861 <getuint>
  800c7a:	83 c4 10             	add    $0x10,%esp
  800c7d:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800c80:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  800c83:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800c8a:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  800c8e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800c91:	83 ec 04             	sub    $0x4,%esp
  800c94:	52                   	push   %edx
  800c95:	ff 75 e4             	pushl  -0x1c(%ebp)
  800c98:	50                   	push   %eax
  800c99:	ff 75 f4             	pushl  -0xc(%ebp)
  800c9c:	ff 75 f0             	pushl  -0x10(%ebp)
  800c9f:	ff 75 0c             	pushl  0xc(%ebp)
  800ca2:	ff 75 08             	pushl  0x8(%ebp)
  800ca5:	e8 00 fb ff ff       	call   8007aa <printnum>
  800caa:	83 c4 20             	add    $0x20,%esp
			break;
  800cad:	eb 34                	jmp    800ce3 <vprintfmt+0x3bc>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  800caf:	83 ec 08             	sub    $0x8,%esp
  800cb2:	ff 75 0c             	pushl  0xc(%ebp)
  800cb5:	53                   	push   %ebx
  800cb6:	8b 45 08             	mov    0x8(%ebp),%eax
  800cb9:	ff d0                	call   *%eax
  800cbb:	83 c4 10             	add    $0x10,%esp
			break;
  800cbe:	eb 23                	jmp    800ce3 <vprintfmt+0x3bc>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800cc0:	83 ec 08             	sub    $0x8,%esp
  800cc3:	ff 75 0c             	pushl  0xc(%ebp)
  800cc6:	6a 25                	push   $0x25
  800cc8:	8b 45 08             	mov    0x8(%ebp),%eax
  800ccb:	ff d0                	call   *%eax
  800ccd:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  800cd0:	ff 4d 10             	decl   0x10(%ebp)
  800cd3:	eb 03                	jmp    800cd8 <vprintfmt+0x3b1>
  800cd5:	ff 4d 10             	decl   0x10(%ebp)
  800cd8:	8b 45 10             	mov    0x10(%ebp),%eax
  800cdb:	48                   	dec    %eax
  800cdc:	8a 00                	mov    (%eax),%al
  800cde:	3c 25                	cmp    $0x25,%al
  800ce0:	75 f3                	jne    800cd5 <vprintfmt+0x3ae>
				/* do nothing */;
			break;
  800ce2:	90                   	nop
		}
	}
  800ce3:	e9 47 fc ff ff       	jmp    80092f <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  800ce8:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  800ce9:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800cec:	5b                   	pop    %ebx
  800ced:	5e                   	pop    %esi
  800cee:	5d                   	pop    %ebp
  800cef:	c3                   	ret    

00800cf0 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800cf0:	55                   	push   %ebp
  800cf1:	89 e5                	mov    %esp,%ebp
  800cf3:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  800cf6:	8d 45 10             	lea    0x10(%ebp),%eax
  800cf9:	83 c0 04             	add    $0x4,%eax
  800cfc:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  800cff:	8b 45 10             	mov    0x10(%ebp),%eax
  800d02:	ff 75 f4             	pushl  -0xc(%ebp)
  800d05:	50                   	push   %eax
  800d06:	ff 75 0c             	pushl  0xc(%ebp)
  800d09:	ff 75 08             	pushl  0x8(%ebp)
  800d0c:	e8 16 fc ff ff       	call   800927 <vprintfmt>
  800d11:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  800d14:	90                   	nop
  800d15:	c9                   	leave  
  800d16:	c3                   	ret    

00800d17 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800d17:	55                   	push   %ebp
  800d18:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  800d1a:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d1d:	8b 40 08             	mov    0x8(%eax),%eax
  800d20:	8d 50 01             	lea    0x1(%eax),%edx
  800d23:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d26:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  800d29:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d2c:	8b 10                	mov    (%eax),%edx
  800d2e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d31:	8b 40 04             	mov    0x4(%eax),%eax
  800d34:	39 c2                	cmp    %eax,%edx
  800d36:	73 12                	jae    800d4a <sprintputch+0x33>
		*b->buf++ = ch;
  800d38:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d3b:	8b 00                	mov    (%eax),%eax
  800d3d:	8d 48 01             	lea    0x1(%eax),%ecx
  800d40:	8b 55 0c             	mov    0xc(%ebp),%edx
  800d43:	89 0a                	mov    %ecx,(%edx)
  800d45:	8b 55 08             	mov    0x8(%ebp),%edx
  800d48:	88 10                	mov    %dl,(%eax)
}
  800d4a:	90                   	nop
  800d4b:	5d                   	pop    %ebp
  800d4c:	c3                   	ret    

00800d4d <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800d4d:	55                   	push   %ebp
  800d4e:	89 e5                	mov    %esp,%ebp
  800d50:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  800d53:	8b 45 08             	mov    0x8(%ebp),%eax
  800d56:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800d59:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d5c:	8d 50 ff             	lea    -0x1(%eax),%edx
  800d5f:	8b 45 08             	mov    0x8(%ebp),%eax
  800d62:	01 d0                	add    %edx,%eax
  800d64:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800d67:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800d6e:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800d72:	74 06                	je     800d7a <vsnprintf+0x2d>
  800d74:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800d78:	7f 07                	jg     800d81 <vsnprintf+0x34>
		return -E_INVAL;
  800d7a:	b8 03 00 00 00       	mov    $0x3,%eax
  800d7f:	eb 20                	jmp    800da1 <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800d81:	ff 75 14             	pushl  0x14(%ebp)
  800d84:	ff 75 10             	pushl  0x10(%ebp)
  800d87:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800d8a:	50                   	push   %eax
  800d8b:	68 17 0d 80 00       	push   $0x800d17
  800d90:	e8 92 fb ff ff       	call   800927 <vprintfmt>
  800d95:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  800d98:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800d9b:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800d9e:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  800da1:	c9                   	leave  
  800da2:	c3                   	ret    

00800da3 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800da3:	55                   	push   %ebp
  800da4:	89 e5                	mov    %esp,%ebp
  800da6:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800da9:	8d 45 10             	lea    0x10(%ebp),%eax
  800dac:	83 c0 04             	add    $0x4,%eax
  800daf:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  800db2:	8b 45 10             	mov    0x10(%ebp),%eax
  800db5:	ff 75 f4             	pushl  -0xc(%ebp)
  800db8:	50                   	push   %eax
  800db9:	ff 75 0c             	pushl  0xc(%ebp)
  800dbc:	ff 75 08             	pushl  0x8(%ebp)
  800dbf:	e8 89 ff ff ff       	call   800d4d <vsnprintf>
  800dc4:	83 c4 10             	add    $0x10,%esp
  800dc7:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  800dca:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800dcd:	c9                   	leave  
  800dce:	c3                   	ret    

00800dcf <strlen>:

#include <inc/string.h>

int
strlen(const char *s)
{
  800dcf:	55                   	push   %ebp
  800dd0:	89 e5                	mov    %esp,%ebp
  800dd2:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  800dd5:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800ddc:	eb 06                	jmp    800de4 <strlen+0x15>
		n++;
  800dde:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  800de1:	ff 45 08             	incl   0x8(%ebp)
  800de4:	8b 45 08             	mov    0x8(%ebp),%eax
  800de7:	8a 00                	mov    (%eax),%al
  800de9:	84 c0                	test   %al,%al
  800deb:	75 f1                	jne    800dde <strlen+0xf>
		n++;
	return n;
  800ded:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800df0:	c9                   	leave  
  800df1:	c3                   	ret    

00800df2 <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  800df2:	55                   	push   %ebp
  800df3:	89 e5                	mov    %esp,%ebp
  800df5:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800df8:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800dff:	eb 09                	jmp    800e0a <strnlen+0x18>
		n++;
  800e01:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800e04:	ff 45 08             	incl   0x8(%ebp)
  800e07:	ff 4d 0c             	decl   0xc(%ebp)
  800e0a:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800e0e:	74 09                	je     800e19 <strnlen+0x27>
  800e10:	8b 45 08             	mov    0x8(%ebp),%eax
  800e13:	8a 00                	mov    (%eax),%al
  800e15:	84 c0                	test   %al,%al
  800e17:	75 e8                	jne    800e01 <strnlen+0xf>
		n++;
	return n;
  800e19:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800e1c:	c9                   	leave  
  800e1d:	c3                   	ret    

00800e1e <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800e1e:	55                   	push   %ebp
  800e1f:	89 e5                	mov    %esp,%ebp
  800e21:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  800e24:	8b 45 08             	mov    0x8(%ebp),%eax
  800e27:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  800e2a:	90                   	nop
  800e2b:	8b 45 08             	mov    0x8(%ebp),%eax
  800e2e:	8d 50 01             	lea    0x1(%eax),%edx
  800e31:	89 55 08             	mov    %edx,0x8(%ebp)
  800e34:	8b 55 0c             	mov    0xc(%ebp),%edx
  800e37:	8d 4a 01             	lea    0x1(%edx),%ecx
  800e3a:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800e3d:	8a 12                	mov    (%edx),%dl
  800e3f:	88 10                	mov    %dl,(%eax)
  800e41:	8a 00                	mov    (%eax),%al
  800e43:	84 c0                	test   %al,%al
  800e45:	75 e4                	jne    800e2b <strcpy+0xd>
		/* do nothing */;
	return ret;
  800e47:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800e4a:	c9                   	leave  
  800e4b:	c3                   	ret    

00800e4c <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  800e4c:	55                   	push   %ebp
  800e4d:	89 e5                	mov    %esp,%ebp
  800e4f:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  800e52:	8b 45 08             	mov    0x8(%ebp),%eax
  800e55:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  800e58:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800e5f:	eb 1f                	jmp    800e80 <strncpy+0x34>
		*dst++ = *src;
  800e61:	8b 45 08             	mov    0x8(%ebp),%eax
  800e64:	8d 50 01             	lea    0x1(%eax),%edx
  800e67:	89 55 08             	mov    %edx,0x8(%ebp)
  800e6a:	8b 55 0c             	mov    0xc(%ebp),%edx
  800e6d:	8a 12                	mov    (%edx),%dl
  800e6f:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  800e71:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e74:	8a 00                	mov    (%eax),%al
  800e76:	84 c0                	test   %al,%al
  800e78:	74 03                	je     800e7d <strncpy+0x31>
			src++;
  800e7a:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800e7d:	ff 45 fc             	incl   -0x4(%ebp)
  800e80:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800e83:	3b 45 10             	cmp    0x10(%ebp),%eax
  800e86:	72 d9                	jb     800e61 <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  800e88:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  800e8b:	c9                   	leave  
  800e8c:	c3                   	ret    

00800e8d <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  800e8d:	55                   	push   %ebp
  800e8e:	89 e5                	mov    %esp,%ebp
  800e90:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  800e93:	8b 45 08             	mov    0x8(%ebp),%eax
  800e96:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  800e99:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800e9d:	74 30                	je     800ecf <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  800e9f:	eb 16                	jmp    800eb7 <strlcpy+0x2a>
			*dst++ = *src++;
  800ea1:	8b 45 08             	mov    0x8(%ebp),%eax
  800ea4:	8d 50 01             	lea    0x1(%eax),%edx
  800ea7:	89 55 08             	mov    %edx,0x8(%ebp)
  800eaa:	8b 55 0c             	mov    0xc(%ebp),%edx
  800ead:	8d 4a 01             	lea    0x1(%edx),%ecx
  800eb0:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800eb3:	8a 12                	mov    (%edx),%dl
  800eb5:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  800eb7:	ff 4d 10             	decl   0x10(%ebp)
  800eba:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800ebe:	74 09                	je     800ec9 <strlcpy+0x3c>
  800ec0:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ec3:	8a 00                	mov    (%eax),%al
  800ec5:	84 c0                	test   %al,%al
  800ec7:	75 d8                	jne    800ea1 <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  800ec9:	8b 45 08             	mov    0x8(%ebp),%eax
  800ecc:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800ecf:	8b 55 08             	mov    0x8(%ebp),%edx
  800ed2:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800ed5:	29 c2                	sub    %eax,%edx
  800ed7:	89 d0                	mov    %edx,%eax
}
  800ed9:	c9                   	leave  
  800eda:	c3                   	ret    

00800edb <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800edb:	55                   	push   %ebp
  800edc:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  800ede:	eb 06                	jmp    800ee6 <strcmp+0xb>
		p++, q++;
  800ee0:	ff 45 08             	incl   0x8(%ebp)
  800ee3:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  800ee6:	8b 45 08             	mov    0x8(%ebp),%eax
  800ee9:	8a 00                	mov    (%eax),%al
  800eeb:	84 c0                	test   %al,%al
  800eed:	74 0e                	je     800efd <strcmp+0x22>
  800eef:	8b 45 08             	mov    0x8(%ebp),%eax
  800ef2:	8a 10                	mov    (%eax),%dl
  800ef4:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ef7:	8a 00                	mov    (%eax),%al
  800ef9:	38 c2                	cmp    %al,%dl
  800efb:	74 e3                	je     800ee0 <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800efd:	8b 45 08             	mov    0x8(%ebp),%eax
  800f00:	8a 00                	mov    (%eax),%al
  800f02:	0f b6 d0             	movzbl %al,%edx
  800f05:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f08:	8a 00                	mov    (%eax),%al
  800f0a:	0f b6 c0             	movzbl %al,%eax
  800f0d:	29 c2                	sub    %eax,%edx
  800f0f:	89 d0                	mov    %edx,%eax
}
  800f11:	5d                   	pop    %ebp
  800f12:	c3                   	ret    

00800f13 <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  800f13:	55                   	push   %ebp
  800f14:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  800f16:	eb 09                	jmp    800f21 <strncmp+0xe>
		n--, p++, q++;
  800f18:	ff 4d 10             	decl   0x10(%ebp)
  800f1b:	ff 45 08             	incl   0x8(%ebp)
  800f1e:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  800f21:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800f25:	74 17                	je     800f3e <strncmp+0x2b>
  800f27:	8b 45 08             	mov    0x8(%ebp),%eax
  800f2a:	8a 00                	mov    (%eax),%al
  800f2c:	84 c0                	test   %al,%al
  800f2e:	74 0e                	je     800f3e <strncmp+0x2b>
  800f30:	8b 45 08             	mov    0x8(%ebp),%eax
  800f33:	8a 10                	mov    (%eax),%dl
  800f35:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f38:	8a 00                	mov    (%eax),%al
  800f3a:	38 c2                	cmp    %al,%dl
  800f3c:	74 da                	je     800f18 <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  800f3e:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800f42:	75 07                	jne    800f4b <strncmp+0x38>
		return 0;
  800f44:	b8 00 00 00 00       	mov    $0x0,%eax
  800f49:	eb 14                	jmp    800f5f <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800f4b:	8b 45 08             	mov    0x8(%ebp),%eax
  800f4e:	8a 00                	mov    (%eax),%al
  800f50:	0f b6 d0             	movzbl %al,%edx
  800f53:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f56:	8a 00                	mov    (%eax),%al
  800f58:	0f b6 c0             	movzbl %al,%eax
  800f5b:	29 c2                	sub    %eax,%edx
  800f5d:	89 d0                	mov    %edx,%eax
}
  800f5f:	5d                   	pop    %ebp
  800f60:	c3                   	ret    

00800f61 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800f61:	55                   	push   %ebp
  800f62:	89 e5                	mov    %esp,%ebp
  800f64:	83 ec 04             	sub    $0x4,%esp
  800f67:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f6a:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800f6d:	eb 12                	jmp    800f81 <strchr+0x20>
		if (*s == c)
  800f6f:	8b 45 08             	mov    0x8(%ebp),%eax
  800f72:	8a 00                	mov    (%eax),%al
  800f74:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800f77:	75 05                	jne    800f7e <strchr+0x1d>
			return (char *) s;
  800f79:	8b 45 08             	mov    0x8(%ebp),%eax
  800f7c:	eb 11                	jmp    800f8f <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  800f7e:	ff 45 08             	incl   0x8(%ebp)
  800f81:	8b 45 08             	mov    0x8(%ebp),%eax
  800f84:	8a 00                	mov    (%eax),%al
  800f86:	84 c0                	test   %al,%al
  800f88:	75 e5                	jne    800f6f <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  800f8a:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800f8f:	c9                   	leave  
  800f90:	c3                   	ret    

00800f91 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800f91:	55                   	push   %ebp
  800f92:	89 e5                	mov    %esp,%ebp
  800f94:	83 ec 04             	sub    $0x4,%esp
  800f97:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f9a:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800f9d:	eb 0d                	jmp    800fac <strfind+0x1b>
		if (*s == c)
  800f9f:	8b 45 08             	mov    0x8(%ebp),%eax
  800fa2:	8a 00                	mov    (%eax),%al
  800fa4:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800fa7:	74 0e                	je     800fb7 <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  800fa9:	ff 45 08             	incl   0x8(%ebp)
  800fac:	8b 45 08             	mov    0x8(%ebp),%eax
  800faf:	8a 00                	mov    (%eax),%al
  800fb1:	84 c0                	test   %al,%al
  800fb3:	75 ea                	jne    800f9f <strfind+0xe>
  800fb5:	eb 01                	jmp    800fb8 <strfind+0x27>
		if (*s == c)
			break;
  800fb7:	90                   	nop
	return (char *) s;
  800fb8:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800fbb:	c9                   	leave  
  800fbc:	c3                   	ret    

00800fbd <memset>:


void *
memset(void *v, int c, uint32 n)
{
  800fbd:	55                   	push   %ebp
  800fbe:	89 e5                	mov    %esp,%ebp
  800fc0:	83 ec 10             	sub    $0x10,%esp
	char *p;
	int m;

	p = v;
  800fc3:	8b 45 08             	mov    0x8(%ebp),%eax
  800fc6:	89 45 fc             	mov    %eax,-0x4(%ebp)
	m = n;
  800fc9:	8b 45 10             	mov    0x10(%ebp),%eax
  800fcc:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (--m >= 0)
  800fcf:	eb 0e                	jmp    800fdf <memset+0x22>
		*p++ = c;
  800fd1:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800fd4:	8d 50 01             	lea    0x1(%eax),%edx
  800fd7:	89 55 fc             	mov    %edx,-0x4(%ebp)
  800fda:	8b 55 0c             	mov    0xc(%ebp),%edx
  800fdd:	88 10                	mov    %dl,(%eax)
	char *p;
	int m;

	p = v;
	m = n;
	while (--m >= 0)
  800fdf:	ff 4d f8             	decl   -0x8(%ebp)
  800fe2:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
  800fe6:	79 e9                	jns    800fd1 <memset+0x14>
		*p++ = c;

	return v;
  800fe8:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800feb:	c9                   	leave  
  800fec:	c3                   	ret    

00800fed <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  800fed:	55                   	push   %ebp
  800fee:	89 e5                	mov    %esp,%ebp
  800ff0:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  800ff3:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ff6:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  800ff9:	8b 45 08             	mov    0x8(%ebp),%eax
  800ffc:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (n-- > 0)
  800fff:	eb 16                	jmp    801017 <memcpy+0x2a>
		*d++ = *s++;
  801001:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801004:	8d 50 01             	lea    0x1(%eax),%edx
  801007:	89 55 f8             	mov    %edx,-0x8(%ebp)
  80100a:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80100d:	8d 4a 01             	lea    0x1(%edx),%ecx
  801010:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  801013:	8a 12                	mov    (%edx),%dl
  801015:	88 10                	mov    %dl,(%eax)
	const char *s;
	char *d;

	s = src;
	d = dst;
	while (n-- > 0)
  801017:	8b 45 10             	mov    0x10(%ebp),%eax
  80101a:	8d 50 ff             	lea    -0x1(%eax),%edx
  80101d:	89 55 10             	mov    %edx,0x10(%ebp)
  801020:	85 c0                	test   %eax,%eax
  801022:	75 dd                	jne    801001 <memcpy+0x14>
		*d++ = *s++;

	return dst;
  801024:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801027:	c9                   	leave  
  801028:	c3                   	ret    

00801029 <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  801029:	55                   	push   %ebp
  80102a:	89 e5                	mov    %esp,%ebp
  80102c:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  80102f:	8b 45 0c             	mov    0xc(%ebp),%eax
  801032:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  801035:	8b 45 08             	mov    0x8(%ebp),%eax
  801038:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  80103b:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80103e:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  801041:	73 50                	jae    801093 <memmove+0x6a>
  801043:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801046:	8b 45 10             	mov    0x10(%ebp),%eax
  801049:	01 d0                	add    %edx,%eax
  80104b:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  80104e:	76 43                	jbe    801093 <memmove+0x6a>
		s += n;
  801050:	8b 45 10             	mov    0x10(%ebp),%eax
  801053:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  801056:	8b 45 10             	mov    0x10(%ebp),%eax
  801059:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  80105c:	eb 10                	jmp    80106e <memmove+0x45>
			*--d = *--s;
  80105e:	ff 4d f8             	decl   -0x8(%ebp)
  801061:	ff 4d fc             	decl   -0x4(%ebp)
  801064:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801067:	8a 10                	mov    (%eax),%dl
  801069:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80106c:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  80106e:	8b 45 10             	mov    0x10(%ebp),%eax
  801071:	8d 50 ff             	lea    -0x1(%eax),%edx
  801074:	89 55 10             	mov    %edx,0x10(%ebp)
  801077:	85 c0                	test   %eax,%eax
  801079:	75 e3                	jne    80105e <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  80107b:	eb 23                	jmp    8010a0 <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  80107d:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801080:	8d 50 01             	lea    0x1(%eax),%edx
  801083:	89 55 f8             	mov    %edx,-0x8(%ebp)
  801086:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801089:	8d 4a 01             	lea    0x1(%edx),%ecx
  80108c:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  80108f:	8a 12                	mov    (%edx),%dl
  801091:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  801093:	8b 45 10             	mov    0x10(%ebp),%eax
  801096:	8d 50 ff             	lea    -0x1(%eax),%edx
  801099:	89 55 10             	mov    %edx,0x10(%ebp)
  80109c:	85 c0                	test   %eax,%eax
  80109e:	75 dd                	jne    80107d <memmove+0x54>
			*d++ = *s++;

	return dst;
  8010a0:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8010a3:	c9                   	leave  
  8010a4:	c3                   	ret    

008010a5 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  8010a5:	55                   	push   %ebp
  8010a6:	89 e5                	mov    %esp,%ebp
  8010a8:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  8010ab:	8b 45 08             	mov    0x8(%ebp),%eax
  8010ae:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  8010b1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8010b4:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  8010b7:	eb 2a                	jmp    8010e3 <memcmp+0x3e>
		if (*s1 != *s2)
  8010b9:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8010bc:	8a 10                	mov    (%eax),%dl
  8010be:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8010c1:	8a 00                	mov    (%eax),%al
  8010c3:	38 c2                	cmp    %al,%dl
  8010c5:	74 16                	je     8010dd <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  8010c7:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8010ca:	8a 00                	mov    (%eax),%al
  8010cc:	0f b6 d0             	movzbl %al,%edx
  8010cf:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8010d2:	8a 00                	mov    (%eax),%al
  8010d4:	0f b6 c0             	movzbl %al,%eax
  8010d7:	29 c2                	sub    %eax,%edx
  8010d9:	89 d0                	mov    %edx,%eax
  8010db:	eb 18                	jmp    8010f5 <memcmp+0x50>
		s1++, s2++;
  8010dd:	ff 45 fc             	incl   -0x4(%ebp)
  8010e0:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  8010e3:	8b 45 10             	mov    0x10(%ebp),%eax
  8010e6:	8d 50 ff             	lea    -0x1(%eax),%edx
  8010e9:	89 55 10             	mov    %edx,0x10(%ebp)
  8010ec:	85 c0                	test   %eax,%eax
  8010ee:	75 c9                	jne    8010b9 <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  8010f0:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8010f5:	c9                   	leave  
  8010f6:	c3                   	ret    

008010f7 <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  8010f7:	55                   	push   %ebp
  8010f8:	89 e5                	mov    %esp,%ebp
  8010fa:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  8010fd:	8b 55 08             	mov    0x8(%ebp),%edx
  801100:	8b 45 10             	mov    0x10(%ebp),%eax
  801103:	01 d0                	add    %edx,%eax
  801105:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  801108:	eb 15                	jmp    80111f <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  80110a:	8b 45 08             	mov    0x8(%ebp),%eax
  80110d:	8a 00                	mov    (%eax),%al
  80110f:	0f b6 d0             	movzbl %al,%edx
  801112:	8b 45 0c             	mov    0xc(%ebp),%eax
  801115:	0f b6 c0             	movzbl %al,%eax
  801118:	39 c2                	cmp    %eax,%edx
  80111a:	74 0d                	je     801129 <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  80111c:	ff 45 08             	incl   0x8(%ebp)
  80111f:	8b 45 08             	mov    0x8(%ebp),%eax
  801122:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  801125:	72 e3                	jb     80110a <memfind+0x13>
  801127:	eb 01                	jmp    80112a <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  801129:	90                   	nop
	return (void *) s;
  80112a:	8b 45 08             	mov    0x8(%ebp),%eax
}
  80112d:	c9                   	leave  
  80112e:	c3                   	ret    

0080112f <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  80112f:	55                   	push   %ebp
  801130:	89 e5                	mov    %esp,%ebp
  801132:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  801135:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  80113c:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801143:	eb 03                	jmp    801148 <strtol+0x19>
		s++;
  801145:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801148:	8b 45 08             	mov    0x8(%ebp),%eax
  80114b:	8a 00                	mov    (%eax),%al
  80114d:	3c 20                	cmp    $0x20,%al
  80114f:	74 f4                	je     801145 <strtol+0x16>
  801151:	8b 45 08             	mov    0x8(%ebp),%eax
  801154:	8a 00                	mov    (%eax),%al
  801156:	3c 09                	cmp    $0x9,%al
  801158:	74 eb                	je     801145 <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  80115a:	8b 45 08             	mov    0x8(%ebp),%eax
  80115d:	8a 00                	mov    (%eax),%al
  80115f:	3c 2b                	cmp    $0x2b,%al
  801161:	75 05                	jne    801168 <strtol+0x39>
		s++;
  801163:	ff 45 08             	incl   0x8(%ebp)
  801166:	eb 13                	jmp    80117b <strtol+0x4c>
	else if (*s == '-')
  801168:	8b 45 08             	mov    0x8(%ebp),%eax
  80116b:	8a 00                	mov    (%eax),%al
  80116d:	3c 2d                	cmp    $0x2d,%al
  80116f:	75 0a                	jne    80117b <strtol+0x4c>
		s++, neg = 1;
  801171:	ff 45 08             	incl   0x8(%ebp)
  801174:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  80117b:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80117f:	74 06                	je     801187 <strtol+0x58>
  801181:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  801185:	75 20                	jne    8011a7 <strtol+0x78>
  801187:	8b 45 08             	mov    0x8(%ebp),%eax
  80118a:	8a 00                	mov    (%eax),%al
  80118c:	3c 30                	cmp    $0x30,%al
  80118e:	75 17                	jne    8011a7 <strtol+0x78>
  801190:	8b 45 08             	mov    0x8(%ebp),%eax
  801193:	40                   	inc    %eax
  801194:	8a 00                	mov    (%eax),%al
  801196:	3c 78                	cmp    $0x78,%al
  801198:	75 0d                	jne    8011a7 <strtol+0x78>
		s += 2, base = 16;
  80119a:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  80119e:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  8011a5:	eb 28                	jmp    8011cf <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  8011a7:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8011ab:	75 15                	jne    8011c2 <strtol+0x93>
  8011ad:	8b 45 08             	mov    0x8(%ebp),%eax
  8011b0:	8a 00                	mov    (%eax),%al
  8011b2:	3c 30                	cmp    $0x30,%al
  8011b4:	75 0c                	jne    8011c2 <strtol+0x93>
		s++, base = 8;
  8011b6:	ff 45 08             	incl   0x8(%ebp)
  8011b9:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  8011c0:	eb 0d                	jmp    8011cf <strtol+0xa0>
	else if (base == 0)
  8011c2:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8011c6:	75 07                	jne    8011cf <strtol+0xa0>
		base = 10;
  8011c8:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  8011cf:	8b 45 08             	mov    0x8(%ebp),%eax
  8011d2:	8a 00                	mov    (%eax),%al
  8011d4:	3c 2f                	cmp    $0x2f,%al
  8011d6:	7e 19                	jle    8011f1 <strtol+0xc2>
  8011d8:	8b 45 08             	mov    0x8(%ebp),%eax
  8011db:	8a 00                	mov    (%eax),%al
  8011dd:	3c 39                	cmp    $0x39,%al
  8011df:	7f 10                	jg     8011f1 <strtol+0xc2>
			dig = *s - '0';
  8011e1:	8b 45 08             	mov    0x8(%ebp),%eax
  8011e4:	8a 00                	mov    (%eax),%al
  8011e6:	0f be c0             	movsbl %al,%eax
  8011e9:	83 e8 30             	sub    $0x30,%eax
  8011ec:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8011ef:	eb 42                	jmp    801233 <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  8011f1:	8b 45 08             	mov    0x8(%ebp),%eax
  8011f4:	8a 00                	mov    (%eax),%al
  8011f6:	3c 60                	cmp    $0x60,%al
  8011f8:	7e 19                	jle    801213 <strtol+0xe4>
  8011fa:	8b 45 08             	mov    0x8(%ebp),%eax
  8011fd:	8a 00                	mov    (%eax),%al
  8011ff:	3c 7a                	cmp    $0x7a,%al
  801201:	7f 10                	jg     801213 <strtol+0xe4>
			dig = *s - 'a' + 10;
  801203:	8b 45 08             	mov    0x8(%ebp),%eax
  801206:	8a 00                	mov    (%eax),%al
  801208:	0f be c0             	movsbl %al,%eax
  80120b:	83 e8 57             	sub    $0x57,%eax
  80120e:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801211:	eb 20                	jmp    801233 <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  801213:	8b 45 08             	mov    0x8(%ebp),%eax
  801216:	8a 00                	mov    (%eax),%al
  801218:	3c 40                	cmp    $0x40,%al
  80121a:	7e 39                	jle    801255 <strtol+0x126>
  80121c:	8b 45 08             	mov    0x8(%ebp),%eax
  80121f:	8a 00                	mov    (%eax),%al
  801221:	3c 5a                	cmp    $0x5a,%al
  801223:	7f 30                	jg     801255 <strtol+0x126>
			dig = *s - 'A' + 10;
  801225:	8b 45 08             	mov    0x8(%ebp),%eax
  801228:	8a 00                	mov    (%eax),%al
  80122a:	0f be c0             	movsbl %al,%eax
  80122d:	83 e8 37             	sub    $0x37,%eax
  801230:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  801233:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801236:	3b 45 10             	cmp    0x10(%ebp),%eax
  801239:	7d 19                	jge    801254 <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  80123b:	ff 45 08             	incl   0x8(%ebp)
  80123e:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801241:	0f af 45 10          	imul   0x10(%ebp),%eax
  801245:	89 c2                	mov    %eax,%edx
  801247:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80124a:	01 d0                	add    %edx,%eax
  80124c:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  80124f:	e9 7b ff ff ff       	jmp    8011cf <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  801254:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  801255:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801259:	74 08                	je     801263 <strtol+0x134>
		*endptr = (char *) s;
  80125b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80125e:	8b 55 08             	mov    0x8(%ebp),%edx
  801261:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  801263:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801267:	74 07                	je     801270 <strtol+0x141>
  801269:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80126c:	f7 d8                	neg    %eax
  80126e:	eb 03                	jmp    801273 <strtol+0x144>
  801270:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  801273:	c9                   	leave  
  801274:	c3                   	ret    

00801275 <ltostr>:

void
ltostr(long value, char *str)
{
  801275:	55                   	push   %ebp
  801276:	89 e5                	mov    %esp,%ebp
  801278:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  80127b:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  801282:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  801289:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80128d:	79 13                	jns    8012a2 <ltostr+0x2d>
	{
		neg = 1;
  80128f:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  801296:	8b 45 0c             	mov    0xc(%ebp),%eax
  801299:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  80129c:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  80129f:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  8012a2:	8b 45 08             	mov    0x8(%ebp),%eax
  8012a5:	b9 0a 00 00 00       	mov    $0xa,%ecx
  8012aa:	99                   	cltd   
  8012ab:	f7 f9                	idiv   %ecx
  8012ad:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  8012b0:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8012b3:	8d 50 01             	lea    0x1(%eax),%edx
  8012b6:	89 55 f8             	mov    %edx,-0x8(%ebp)
  8012b9:	89 c2                	mov    %eax,%edx
  8012bb:	8b 45 0c             	mov    0xc(%ebp),%eax
  8012be:	01 d0                	add    %edx,%eax
  8012c0:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8012c3:	83 c2 30             	add    $0x30,%edx
  8012c6:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  8012c8:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8012cb:	b8 67 66 66 66       	mov    $0x66666667,%eax
  8012d0:	f7 e9                	imul   %ecx
  8012d2:	c1 fa 02             	sar    $0x2,%edx
  8012d5:	89 c8                	mov    %ecx,%eax
  8012d7:	c1 f8 1f             	sar    $0x1f,%eax
  8012da:	29 c2                	sub    %eax,%edx
  8012dc:	89 d0                	mov    %edx,%eax
  8012de:	89 45 08             	mov    %eax,0x8(%ebp)
	} while (value % 10 != 0);
  8012e1:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8012e4:	b8 67 66 66 66       	mov    $0x66666667,%eax
  8012e9:	f7 e9                	imul   %ecx
  8012eb:	c1 fa 02             	sar    $0x2,%edx
  8012ee:	89 c8                	mov    %ecx,%eax
  8012f0:	c1 f8 1f             	sar    $0x1f,%eax
  8012f3:	29 c2                	sub    %eax,%edx
  8012f5:	89 d0                	mov    %edx,%eax
  8012f7:	c1 e0 02             	shl    $0x2,%eax
  8012fa:	01 d0                	add    %edx,%eax
  8012fc:	01 c0                	add    %eax,%eax
  8012fe:	29 c1                	sub    %eax,%ecx
  801300:	89 ca                	mov    %ecx,%edx
  801302:	85 d2                	test   %edx,%edx
  801304:	75 9c                	jne    8012a2 <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  801306:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  80130d:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801310:	48                   	dec    %eax
  801311:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  801314:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801318:	74 3d                	je     801357 <ltostr+0xe2>
		start = 1 ;
  80131a:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  801321:	eb 34                	jmp    801357 <ltostr+0xe2>
	{
		char tmp = str[start] ;
  801323:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801326:	8b 45 0c             	mov    0xc(%ebp),%eax
  801329:	01 d0                	add    %edx,%eax
  80132b:	8a 00                	mov    (%eax),%al
  80132d:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  801330:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801333:	8b 45 0c             	mov    0xc(%ebp),%eax
  801336:	01 c2                	add    %eax,%edx
  801338:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  80133b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80133e:	01 c8                	add    %ecx,%eax
  801340:	8a 00                	mov    (%eax),%al
  801342:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  801344:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801347:	8b 45 0c             	mov    0xc(%ebp),%eax
  80134a:	01 c2                	add    %eax,%edx
  80134c:	8a 45 eb             	mov    -0x15(%ebp),%al
  80134f:	88 02                	mov    %al,(%edx)
		start++ ;
  801351:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  801354:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  801357:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80135a:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  80135d:	7c c4                	jl     801323 <ltostr+0xae>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  80135f:	8b 55 f8             	mov    -0x8(%ebp),%edx
  801362:	8b 45 0c             	mov    0xc(%ebp),%eax
  801365:	01 d0                	add    %edx,%eax
  801367:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  80136a:	90                   	nop
  80136b:	c9                   	leave  
  80136c:	c3                   	ret    

0080136d <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  80136d:	55                   	push   %ebp
  80136e:	89 e5                	mov    %esp,%ebp
  801370:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  801373:	ff 75 08             	pushl  0x8(%ebp)
  801376:	e8 54 fa ff ff       	call   800dcf <strlen>
  80137b:	83 c4 04             	add    $0x4,%esp
  80137e:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  801381:	ff 75 0c             	pushl  0xc(%ebp)
  801384:	e8 46 fa ff ff       	call   800dcf <strlen>
  801389:	83 c4 04             	add    $0x4,%esp
  80138c:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  80138f:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  801396:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  80139d:	eb 17                	jmp    8013b6 <strcconcat+0x49>
		final[s] = str1[s] ;
  80139f:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8013a2:	8b 45 10             	mov    0x10(%ebp),%eax
  8013a5:	01 c2                	add    %eax,%edx
  8013a7:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  8013aa:	8b 45 08             	mov    0x8(%ebp),%eax
  8013ad:	01 c8                	add    %ecx,%eax
  8013af:	8a 00                	mov    (%eax),%al
  8013b1:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  8013b3:	ff 45 fc             	incl   -0x4(%ebp)
  8013b6:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8013b9:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  8013bc:	7c e1                	jl     80139f <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  8013be:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  8013c5:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  8013cc:	eb 1f                	jmp    8013ed <strcconcat+0x80>
		final[s++] = str2[i] ;
  8013ce:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8013d1:	8d 50 01             	lea    0x1(%eax),%edx
  8013d4:	89 55 fc             	mov    %edx,-0x4(%ebp)
  8013d7:	89 c2                	mov    %eax,%edx
  8013d9:	8b 45 10             	mov    0x10(%ebp),%eax
  8013dc:	01 c2                	add    %eax,%edx
  8013de:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  8013e1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8013e4:	01 c8                	add    %ecx,%eax
  8013e6:	8a 00                	mov    (%eax),%al
  8013e8:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  8013ea:	ff 45 f8             	incl   -0x8(%ebp)
  8013ed:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8013f0:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8013f3:	7c d9                	jl     8013ce <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  8013f5:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8013f8:	8b 45 10             	mov    0x10(%ebp),%eax
  8013fb:	01 d0                	add    %edx,%eax
  8013fd:	c6 00 00             	movb   $0x0,(%eax)
}
  801400:	90                   	nop
  801401:	c9                   	leave  
  801402:	c3                   	ret    

00801403 <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  801403:	55                   	push   %ebp
  801404:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  801406:	8b 45 14             	mov    0x14(%ebp),%eax
  801409:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  80140f:	8b 45 14             	mov    0x14(%ebp),%eax
  801412:	8b 00                	mov    (%eax),%eax
  801414:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80141b:	8b 45 10             	mov    0x10(%ebp),%eax
  80141e:	01 d0                	add    %edx,%eax
  801420:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801426:	eb 0c                	jmp    801434 <strsplit+0x31>
			*string++ = 0;
  801428:	8b 45 08             	mov    0x8(%ebp),%eax
  80142b:	8d 50 01             	lea    0x1(%eax),%edx
  80142e:	89 55 08             	mov    %edx,0x8(%ebp)
  801431:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801434:	8b 45 08             	mov    0x8(%ebp),%eax
  801437:	8a 00                	mov    (%eax),%al
  801439:	84 c0                	test   %al,%al
  80143b:	74 18                	je     801455 <strsplit+0x52>
  80143d:	8b 45 08             	mov    0x8(%ebp),%eax
  801440:	8a 00                	mov    (%eax),%al
  801442:	0f be c0             	movsbl %al,%eax
  801445:	50                   	push   %eax
  801446:	ff 75 0c             	pushl  0xc(%ebp)
  801449:	e8 13 fb ff ff       	call   800f61 <strchr>
  80144e:	83 c4 08             	add    $0x8,%esp
  801451:	85 c0                	test   %eax,%eax
  801453:	75 d3                	jne    801428 <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  801455:	8b 45 08             	mov    0x8(%ebp),%eax
  801458:	8a 00                	mov    (%eax),%al
  80145a:	84 c0                	test   %al,%al
  80145c:	74 5a                	je     8014b8 <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  80145e:	8b 45 14             	mov    0x14(%ebp),%eax
  801461:	8b 00                	mov    (%eax),%eax
  801463:	83 f8 0f             	cmp    $0xf,%eax
  801466:	75 07                	jne    80146f <strsplit+0x6c>
		{
			return 0;
  801468:	b8 00 00 00 00       	mov    $0x0,%eax
  80146d:	eb 66                	jmp    8014d5 <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  80146f:	8b 45 14             	mov    0x14(%ebp),%eax
  801472:	8b 00                	mov    (%eax),%eax
  801474:	8d 48 01             	lea    0x1(%eax),%ecx
  801477:	8b 55 14             	mov    0x14(%ebp),%edx
  80147a:	89 0a                	mov    %ecx,(%edx)
  80147c:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801483:	8b 45 10             	mov    0x10(%ebp),%eax
  801486:	01 c2                	add    %eax,%edx
  801488:	8b 45 08             	mov    0x8(%ebp),%eax
  80148b:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  80148d:	eb 03                	jmp    801492 <strsplit+0x8f>
			string++;
  80148f:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  801492:	8b 45 08             	mov    0x8(%ebp),%eax
  801495:	8a 00                	mov    (%eax),%al
  801497:	84 c0                	test   %al,%al
  801499:	74 8b                	je     801426 <strsplit+0x23>
  80149b:	8b 45 08             	mov    0x8(%ebp),%eax
  80149e:	8a 00                	mov    (%eax),%al
  8014a0:	0f be c0             	movsbl %al,%eax
  8014a3:	50                   	push   %eax
  8014a4:	ff 75 0c             	pushl  0xc(%ebp)
  8014a7:	e8 b5 fa ff ff       	call   800f61 <strchr>
  8014ac:	83 c4 08             	add    $0x8,%esp
  8014af:	85 c0                	test   %eax,%eax
  8014b1:	74 dc                	je     80148f <strsplit+0x8c>
			string++;
	}
  8014b3:	e9 6e ff ff ff       	jmp    801426 <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  8014b8:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  8014b9:	8b 45 14             	mov    0x14(%ebp),%eax
  8014bc:	8b 00                	mov    (%eax),%eax
  8014be:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8014c5:	8b 45 10             	mov    0x10(%ebp),%eax
  8014c8:	01 d0                	add    %edx,%eax
  8014ca:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  8014d0:	b8 01 00 00 00       	mov    $0x1,%eax
}
  8014d5:	c9                   	leave  
  8014d6:	c3                   	ret    

008014d7 <InitializeUHeap>:
//============================== GIVEN FUNCTIONS ===================================//
//==================================================================================//

int FirstTimeFlag = 1;
void InitializeUHeap()
{
  8014d7:	55                   	push   %ebp
  8014d8:	89 e5                	mov    %esp,%ebp
  8014da:	83 ec 08             	sub    $0x8,%esp
	if(FirstTimeFlag)
  8014dd:	a1 04 40 80 00       	mov    0x804004,%eax
  8014e2:	85 c0                	test   %eax,%eax
  8014e4:	74 1f                	je     801505 <InitializeUHeap+0x2e>
	{
		initialize_dyn_block_system();
  8014e6:	e8 1d 00 00 00       	call   801508 <initialize_dyn_block_system>
		cprintf("DYNAMIC BLOCK SYSTEM IS INITIALIZED\n");
  8014eb:	83 ec 0c             	sub    $0xc,%esp
  8014ee:	68 30 3b 80 00       	push   $0x803b30
  8014f3:	e8 55 f2 ff ff       	call   80074d <cprintf>
  8014f8:	83 c4 10             	add    $0x10,%esp
#if UHP_USE_BUDDY
		initialize_buddy();
		cprintf("BUDDY SYSTEM IS INITIALIZED\n");
#endif
		FirstTimeFlag = 0;
  8014fb:	c7 05 04 40 80 00 00 	movl   $0x0,0x804004
  801502:	00 00 00 
	}
}
  801505:	90                   	nop
  801506:	c9                   	leave  
  801507:	c3                   	ret    

00801508 <initialize_dyn_block_system>:

//=================================
// [1] INITIALIZE DYNAMIC ALLOCATOR:
//=================================
void initialize_dyn_block_system()
{
  801508:	55                   	push   %ebp
  801509:	89 e5                	mov    %esp,%ebp
  80150b:	83 ec 28             	sub    $0x28,%esp
	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] initialize_dyn_block_system
	// your code is here, remove the panic and write your code
	//panic("initialize_dyn_block_system() is not implemented yet...!!");

	LIST_INIT(&AllocMemBlocksList);
  80150e:	c7 05 40 40 80 00 00 	movl   $0x0,0x804040
  801515:	00 00 00 
  801518:	c7 05 44 40 80 00 00 	movl   $0x0,0x804044
  80151f:	00 00 00 
  801522:	c7 05 4c 40 80 00 00 	movl   $0x0,0x80404c
  801529:	00 00 00 
	LIST_INIT(&FreeMemBlocksList);
  80152c:	c7 05 38 41 80 00 00 	movl   $0x0,0x804138
  801533:	00 00 00 
  801536:	c7 05 3c 41 80 00 00 	movl   $0x0,0x80413c
  80153d:	00 00 00 
  801540:	c7 05 44 41 80 00 00 	movl   $0x0,0x804144
  801547:	00 00 00 
	MAX_MEM_BLOCK_CNT = NUM_OF_UHEAP_PAGES;
  80154a:	c7 05 20 41 80 00 00 	movl   $0x20000,0x804120
  801551:	00 02 00 
	MemBlockNodes = (void*)USER_DYN_BLKS_ARRAY;
  801554:	c7 45 f4 00 00 e0 7f 	movl   $0x7fe00000,-0xc(%ebp)
  80155b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80155e:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801563:	2d 00 10 00 00       	sub    $0x1000,%eax
  801568:	a3 50 40 80 00       	mov    %eax,0x804050
	int size_of_block = sizeof(struct MemBlock);
  80156d:	c7 45 f0 10 00 00 00 	movl   $0x10,-0x10(%ebp)
	int size_all_struct = size_of_block*MAX_MEM_BLOCK_CNT;
  801574:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801577:	a1 20 41 80 00       	mov    0x804120,%eax
  80157c:	0f af c2             	imul   %edx,%eax
  80157f:	89 45 ec             	mov    %eax,-0x14(%ebp)
	size_all_struct = ROUNDUP(size_all_struct, PAGE_SIZE);
  801582:	c7 45 e8 00 10 00 00 	movl   $0x1000,-0x18(%ebp)
  801589:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80158c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80158f:	01 d0                	add    %edx,%eax
  801591:	48                   	dec    %eax
  801592:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  801595:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801598:	ba 00 00 00 00       	mov    $0x0,%edx
  80159d:	f7 75 e8             	divl   -0x18(%ebp)
  8015a0:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8015a3:	29 d0                	sub    %edx,%eax
  8015a5:	89 45 ec             	mov    %eax,-0x14(%ebp)
	sys_allocate_chunk(USER_DYN_BLKS_ARRAY, size_all_struct,PERM_USER| PERM_WRITEABLE);
  8015a8:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8015ab:	c7 45 e0 00 00 e0 7f 	movl   $0x7fe00000,-0x20(%ebp)
  8015b2:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8015b5:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
  8015bb:	81 ea 00 10 00 00    	sub    $0x1000,%edx
  8015c1:	83 ec 04             	sub    $0x4,%esp
  8015c4:	6a 06                	push   $0x6
  8015c6:	50                   	push   %eax
  8015c7:	52                   	push   %edx
  8015c8:	e8 a1 05 00 00       	call   801b6e <sys_allocate_chunk>
  8015cd:	83 c4 10             	add    $0x10,%esp
	initialize_MemBlocksList(MAX_MEM_BLOCK_CNT);
  8015d0:	a1 20 41 80 00       	mov    0x804120,%eax
  8015d5:	83 ec 0c             	sub    $0xc,%esp
  8015d8:	50                   	push   %eax
  8015d9:	e8 16 0c 00 00       	call   8021f4 <initialize_MemBlocksList>
  8015de:	83 c4 10             	add    $0x10,%esp
	struct MemBlock* ourBlock =LIST_LAST(&AvailableMemBlocksList);
  8015e1:	a1 4c 41 80 00       	mov    0x80414c,%eax
  8015e6:	89 45 dc             	mov    %eax,-0x24(%ebp)
	LIST_REMOVE(&AvailableMemBlocksList,ourBlock);
  8015e9:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  8015ed:	75 14                	jne    801603 <initialize_dyn_block_system+0xfb>
  8015ef:	83 ec 04             	sub    $0x4,%esp
  8015f2:	68 55 3b 80 00       	push   $0x803b55
  8015f7:	6a 2d                	push   $0x2d
  8015f9:	68 73 3b 80 00       	push   $0x803b73
  8015fe:	e8 96 ee ff ff       	call   800499 <_panic>
  801603:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801606:	8b 00                	mov    (%eax),%eax
  801608:	85 c0                	test   %eax,%eax
  80160a:	74 10                	je     80161c <initialize_dyn_block_system+0x114>
  80160c:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80160f:	8b 00                	mov    (%eax),%eax
  801611:	8b 55 dc             	mov    -0x24(%ebp),%edx
  801614:	8b 52 04             	mov    0x4(%edx),%edx
  801617:	89 50 04             	mov    %edx,0x4(%eax)
  80161a:	eb 0b                	jmp    801627 <initialize_dyn_block_system+0x11f>
  80161c:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80161f:	8b 40 04             	mov    0x4(%eax),%eax
  801622:	a3 4c 41 80 00       	mov    %eax,0x80414c
  801627:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80162a:	8b 40 04             	mov    0x4(%eax),%eax
  80162d:	85 c0                	test   %eax,%eax
  80162f:	74 0f                	je     801640 <initialize_dyn_block_system+0x138>
  801631:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801634:	8b 40 04             	mov    0x4(%eax),%eax
  801637:	8b 55 dc             	mov    -0x24(%ebp),%edx
  80163a:	8b 12                	mov    (%edx),%edx
  80163c:	89 10                	mov    %edx,(%eax)
  80163e:	eb 0a                	jmp    80164a <initialize_dyn_block_system+0x142>
  801640:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801643:	8b 00                	mov    (%eax),%eax
  801645:	a3 48 41 80 00       	mov    %eax,0x804148
  80164a:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80164d:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  801653:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801656:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80165d:	a1 54 41 80 00       	mov    0x804154,%eax
  801662:	48                   	dec    %eax
  801663:	a3 54 41 80 00       	mov    %eax,0x804154
	ourBlock->size = USER_HEAP_MAX-USER_HEAP_START;
  801668:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80166b:	c7 40 0c 00 00 00 20 	movl   $0x20000000,0xc(%eax)
	ourBlock->sva=USER_HEAP_START;
  801672:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801675:	c7 40 08 00 00 00 80 	movl   $0x80000000,0x8(%eax)
	LIST_INSERT_TAIL(&FreeMemBlocksList, ourBlock);
  80167c:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  801680:	75 14                	jne    801696 <initialize_dyn_block_system+0x18e>
  801682:	83 ec 04             	sub    $0x4,%esp
  801685:	68 80 3b 80 00       	push   $0x803b80
  80168a:	6a 30                	push   $0x30
  80168c:	68 73 3b 80 00       	push   $0x803b73
  801691:	e8 03 ee ff ff       	call   800499 <_panic>
  801696:	8b 15 3c 41 80 00    	mov    0x80413c,%edx
  80169c:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80169f:	89 50 04             	mov    %edx,0x4(%eax)
  8016a2:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8016a5:	8b 40 04             	mov    0x4(%eax),%eax
  8016a8:	85 c0                	test   %eax,%eax
  8016aa:	74 0c                	je     8016b8 <initialize_dyn_block_system+0x1b0>
  8016ac:	a1 3c 41 80 00       	mov    0x80413c,%eax
  8016b1:	8b 55 dc             	mov    -0x24(%ebp),%edx
  8016b4:	89 10                	mov    %edx,(%eax)
  8016b6:	eb 08                	jmp    8016c0 <initialize_dyn_block_system+0x1b8>
  8016b8:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8016bb:	a3 38 41 80 00       	mov    %eax,0x804138
  8016c0:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8016c3:	a3 3c 41 80 00       	mov    %eax,0x80413c
  8016c8:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8016cb:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8016d1:	a1 44 41 80 00       	mov    0x804144,%eax
  8016d6:	40                   	inc    %eax
  8016d7:	a3 44 41 80 00       	mov    %eax,0x804144
	//[1] Initialize two lists (AllocMemBlocksList & FreeMemBlocksList) [Hint: use LIST_INIT()]
	//[2] Dynamically allocate the array of MemBlockNodes at VA USER_DYN_BLKS_ARRAY
	//	  (remember to set MAX_MEM_BLOCK_CNT with the chosen size of the array)
	//[3] Initialize AvailableMemBlocksList by filling it with the MemBlockNodes
	//[4] Insert a new MemBlock with the heap size into the FreeMemBlocksList
}
  8016dc:	90                   	nop
  8016dd:	c9                   	leave  
  8016de:	c3                   	ret    

008016df <malloc>:
//=================================
// [2] ALLOCATE SPACE IN USER HEAP:
//=================================

void* malloc(uint32 size)
{
  8016df:	55                   	push   %ebp
  8016e0:	89 e5                	mov    %esp,%ebp
  8016e2:	83 ec 18             	sub    $0x18,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  8016e5:	e8 ed fd ff ff       	call   8014d7 <InitializeUHeap>
	if (size == 0) return NULL ;
  8016ea:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8016ee:	75 07                	jne    8016f7 <malloc+0x18>
  8016f0:	b8 00 00 00 00       	mov    $0x0,%eax
  8016f5:	eb 67                	jmp    80175e <malloc+0x7f>

	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] malloc
	// your code is here, remove the panic and write your code
	//panic("malloc() is not implemented yet...!!");

	size = ROUNDUP(size, PAGE_SIZE);
  8016f7:	c7 45 f4 00 10 00 00 	movl   $0x1000,-0xc(%ebp)
  8016fe:	8b 55 08             	mov    0x8(%ebp),%edx
  801701:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801704:	01 d0                	add    %edx,%eax
  801706:	48                   	dec    %eax
  801707:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80170a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80170d:	ba 00 00 00 00       	mov    $0x0,%edx
  801712:	f7 75 f4             	divl   -0xc(%ebp)
  801715:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801718:	29 d0                	sub    %edx,%eax
  80171a:	89 45 08             	mov    %eax,0x8(%ebp)
	if(sys_isUHeapPlacementStrategyFIRSTFIT())
  80171d:	e8 1a 08 00 00       	call   801f3c <sys_isUHeapPlacementStrategyFIRSTFIT>
  801722:	85 c0                	test   %eax,%eax
  801724:	74 33                	je     801759 <malloc+0x7a>
	{
		struct MemBlock * myBlock = alloc_block_FF(size);
  801726:	83 ec 0c             	sub    $0xc,%esp
  801729:	ff 75 08             	pushl  0x8(%ebp)
  80172c:	e8 0c 0e 00 00       	call   80253d <alloc_block_FF>
  801731:	83 c4 10             	add    $0x10,%esp
  801734:	89 45 ec             	mov    %eax,-0x14(%ebp)
		if(myBlock != NULL)
  801737:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  80173b:	74 1c                	je     801759 <malloc+0x7a>
		{
			insert_sorted_allocList(myBlock);
  80173d:	83 ec 0c             	sub    $0xc,%esp
  801740:	ff 75 ec             	pushl  -0x14(%ebp)
  801743:	e8 07 0c 00 00       	call   80234f <insert_sorted_allocList>
  801748:	83 c4 10             	add    $0x10,%esp
			uint32 ptr = myBlock->sva;
  80174b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80174e:	8b 40 08             	mov    0x8(%eax),%eax
  801751:	89 45 e8             	mov    %eax,-0x18(%ebp)
			return (void *)ptr;
  801754:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801757:	eb 05                	jmp    80175e <malloc+0x7f>
		}
	}
	return NULL;
  801759:	b8 00 00 00 00       	mov    $0x0,%eax
	//		to the required allocation size (space should be on 4 KB BOUNDARY)
	//	2) if no suitable space found, return NULL
	// 	3) Return pointer containing the virtual address of allocated space,
	//
	//Use sys_isUHeapPlacementStrategyFIRSTFIT()... to check the current strategy
}
  80175e:	c9                   	leave  
  80175f:	c3                   	ret    

00801760 <free>:
//	We can use sys_free_user_mem(uint32 virtual_address, uint32 size); which
//		switches to the kernel mode, calls free_user_mem() in
//		"kern/mem/chunk_operations.c", then switch back to the user mode here
//	the free_user_mem function is empty, make sure to implement it.
void free(void* virtual_address)
{
  801760:	55                   	push   %ebp
  801761:	89 e5                	mov    %esp,%ebp
  801763:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] free
	// your code is here, remove the panic and write your code
	//panic("free() is not implemented yet...!!");

	uint32 virtualAddress = (uint32 )(virtual_address);
  801766:	8b 45 08             	mov    0x8(%ebp),%eax
  801769:	89 45 f4             	mov    %eax,-0xc(%ebp)
//	virtualAddress = ROUNDDOWN(virtualAddress, PAGE_SIZE);
	struct MemBlock * myBlock = find_block(&AllocMemBlocksList, virtualAddress);
  80176c:	83 ec 08             	sub    $0x8,%esp
  80176f:	ff 75 f4             	pushl  -0xc(%ebp)
  801772:	68 40 40 80 00       	push   $0x804040
  801777:	e8 5b 0b 00 00       	call   8022d7 <find_block>
  80177c:	83 c4 10             	add    $0x10,%esp
  80177f:	89 45 f0             	mov    %eax,-0x10(%ebp)
//	cprintf ("ptr sva at free user side = %x \n", myBlock->sva);
	sys_free_user_mem(virtualAddress, myBlock->size);
  801782:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801785:	8b 40 0c             	mov    0xc(%eax),%eax
  801788:	83 ec 08             	sub    $0x8,%esp
  80178b:	50                   	push   %eax
  80178c:	ff 75 f4             	pushl  -0xc(%ebp)
  80178f:	e8 a2 03 00 00       	call   801b36 <sys_free_user_mem>
  801794:	83 c4 10             	add    $0x10,%esp
	LIST_REMOVE(&AllocMemBlocksList, myBlock);
  801797:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80179b:	75 14                	jne    8017b1 <free+0x51>
  80179d:	83 ec 04             	sub    $0x4,%esp
  8017a0:	68 55 3b 80 00       	push   $0x803b55
  8017a5:	6a 76                	push   $0x76
  8017a7:	68 73 3b 80 00       	push   $0x803b73
  8017ac:	e8 e8 ec ff ff       	call   800499 <_panic>
  8017b1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8017b4:	8b 00                	mov    (%eax),%eax
  8017b6:	85 c0                	test   %eax,%eax
  8017b8:	74 10                	je     8017ca <free+0x6a>
  8017ba:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8017bd:	8b 00                	mov    (%eax),%eax
  8017bf:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8017c2:	8b 52 04             	mov    0x4(%edx),%edx
  8017c5:	89 50 04             	mov    %edx,0x4(%eax)
  8017c8:	eb 0b                	jmp    8017d5 <free+0x75>
  8017ca:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8017cd:	8b 40 04             	mov    0x4(%eax),%eax
  8017d0:	a3 44 40 80 00       	mov    %eax,0x804044
  8017d5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8017d8:	8b 40 04             	mov    0x4(%eax),%eax
  8017db:	85 c0                	test   %eax,%eax
  8017dd:	74 0f                	je     8017ee <free+0x8e>
  8017df:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8017e2:	8b 40 04             	mov    0x4(%eax),%eax
  8017e5:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8017e8:	8b 12                	mov    (%edx),%edx
  8017ea:	89 10                	mov    %edx,(%eax)
  8017ec:	eb 0a                	jmp    8017f8 <free+0x98>
  8017ee:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8017f1:	8b 00                	mov    (%eax),%eax
  8017f3:	a3 40 40 80 00       	mov    %eax,0x804040
  8017f8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8017fb:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  801801:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801804:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80180b:	a1 4c 40 80 00       	mov    0x80404c,%eax
  801810:	48                   	dec    %eax
  801811:	a3 4c 40 80 00       	mov    %eax,0x80404c
	insert_sorted_with_merge_freeList(myBlock);
  801816:	83 ec 0c             	sub    $0xc,%esp
  801819:	ff 75 f0             	pushl  -0x10(%ebp)
  80181c:	e8 0b 14 00 00       	call   802c2c <insert_sorted_with_merge_freeList>
  801821:	83 c4 10             	add    $0x10,%esp

	//you should get the size of the given allocation using its address
	//you need to call sys_free_user_mem()
	//refer to the project presentation and documentation for details
}
  801824:	90                   	nop
  801825:	c9                   	leave  
  801826:	c3                   	ret    

00801827 <smalloc>:

//=================================
// [4] ALLOCATE SHARED VARIABLE:
//=================================
void* smalloc(char *sharedVarName, uint32 size, uint8 isWritable)
{
  801827:	55                   	push   %ebp
  801828:	89 e5                	mov    %esp,%ebp
  80182a:	83 ec 28             	sub    $0x28,%esp
  80182d:	8b 45 10             	mov    0x10(%ebp),%eax
  801830:	88 45 e4             	mov    %al,-0x1c(%ebp)
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801833:	e8 9f fc ff ff       	call   8014d7 <InitializeUHeap>
	if (size == 0) return NULL ;
  801838:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80183c:	75 0a                	jne    801848 <smalloc+0x21>
  80183e:	b8 00 00 00 00       	mov    $0x0,%eax
  801843:	e9 8d 00 00 00       	jmp    8018d5 <smalloc+0xae>

	//This function should find the space of the required range
	// * ON 4KB BOUNDARY **** //
	//Use sys_isUHeapPlacementStrategyFIRSTFIT() to check the current strategy

	size = ROUNDUP(size, PAGE_SIZE);
  801848:	c7 45 f4 00 10 00 00 	movl   $0x1000,-0xc(%ebp)
  80184f:	8b 55 0c             	mov    0xc(%ebp),%edx
  801852:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801855:	01 d0                	add    %edx,%eax
  801857:	48                   	dec    %eax
  801858:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80185b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80185e:	ba 00 00 00 00       	mov    $0x0,%edx
  801863:	f7 75 f4             	divl   -0xc(%ebp)
  801866:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801869:	29 d0                	sub    %edx,%eax
  80186b:	89 45 0c             	mov    %eax,0xc(%ebp)
		if(sys_isUHeapPlacementStrategyFIRSTFIT())
  80186e:	e8 c9 06 00 00       	call   801f3c <sys_isUHeapPlacementStrategyFIRSTFIT>
  801873:	85 c0                	test   %eax,%eax
  801875:	74 59                	je     8018d0 <smalloc+0xa9>
		{
			struct MemBlock * v1=NULL;
  801877:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
			v1= alloc_block_FF(size);
  80187e:	83 ec 0c             	sub    $0xc,%esp
  801881:	ff 75 0c             	pushl  0xc(%ebp)
  801884:	e8 b4 0c 00 00       	call   80253d <alloc_block_FF>
  801889:	83 c4 10             	add    $0x10,%esp
  80188c:	89 45 ec             	mov    %eax,-0x14(%ebp)
			if(v1==NULL)
  80188f:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  801893:	75 07                	jne    80189c <smalloc+0x75>
			{
				return NULL;
  801895:	b8 00 00 00 00       	mov    $0x0,%eax
  80189a:	eb 39                	jmp    8018d5 <smalloc+0xae>
			}
			else
			{
				int ret=sys_createSharedObject(sharedVarName,  size,  isWritable,(void*)v1->sva);
  80189c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80189f:	8b 40 08             	mov    0x8(%eax),%eax
  8018a2:	89 c2                	mov    %eax,%edx
  8018a4:	0f b6 45 e4          	movzbl -0x1c(%ebp),%eax
  8018a8:	52                   	push   %edx
  8018a9:	50                   	push   %eax
  8018aa:	ff 75 0c             	pushl  0xc(%ebp)
  8018ad:	ff 75 08             	pushl  0x8(%ebp)
  8018b0:	e8 0c 04 00 00       	call   801cc1 <sys_createSharedObject>
  8018b5:	83 c4 10             	add    $0x10,%esp
  8018b8:	89 45 e8             	mov    %eax,-0x18(%ebp)
				if(ret>=0)
  8018bb:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  8018bf:	78 08                	js     8018c9 <smalloc+0xa2>
				{
					return (void*)v1->sva;
  8018c1:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8018c4:	8b 40 08             	mov    0x8(%eax),%eax
  8018c7:	eb 0c                	jmp    8018d5 <smalloc+0xae>
				}
				else
				{
					return NULL;
  8018c9:	b8 00 00 00 00       	mov    $0x0,%eax
  8018ce:	eb 05                	jmp    8018d5 <smalloc+0xae>
				}
			}

		}
		return NULL;
  8018d0:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8018d5:	c9                   	leave  
  8018d6:	c3                   	ret    

008018d7 <sget>:

//========================================
// [5] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
  8018d7:	55                   	push   %ebp
  8018d8:	89 e5                	mov    %esp,%ebp
  8018da:	83 ec 18             	sub    $0x18,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  8018dd:	e8 f5 fb ff ff       	call   8014d7 <InitializeUHeap>

	//This function should find the space for sharing the variable
	// *** ON 4KB BOUNDARY ******** //

	//Use sys_isUHeapPlacementStrategyFIRSTFIT() to check the current strategy
	int ret=sys_getSizeOfSharedObject(ownerEnvID,sharedVarName);
  8018e2:	83 ec 08             	sub    $0x8,%esp
  8018e5:	ff 75 0c             	pushl  0xc(%ebp)
  8018e8:	ff 75 08             	pushl  0x8(%ebp)
  8018eb:	e8 fb 03 00 00       	call   801ceb <sys_getSizeOfSharedObject>
  8018f0:	83 c4 10             	add    $0x10,%esp
  8018f3:	89 45 f4             	mov    %eax,-0xc(%ebp)
	if(ret==0)
  8018f6:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8018fa:	75 07                	jne    801903 <sget+0x2c>
	{
		return NULL;
  8018fc:	b8 00 00 00 00       	mov    $0x0,%eax
  801901:	eb 64                	jmp    801967 <sget+0x90>
	}
	if(sys_isUHeapPlacementStrategyFIRSTFIT())
  801903:	e8 34 06 00 00       	call   801f3c <sys_isUHeapPlacementStrategyFIRSTFIT>
  801908:	85 c0                	test   %eax,%eax
  80190a:	74 56                	je     801962 <sget+0x8b>
	{
		struct MemBlock * v1=NULL;
  80190c:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
		v1= alloc_block_FF(ret);
  801913:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801916:	83 ec 0c             	sub    $0xc,%esp
  801919:	50                   	push   %eax
  80191a:	e8 1e 0c 00 00       	call   80253d <alloc_block_FF>
  80191f:	83 c4 10             	add    $0x10,%esp
  801922:	89 45 f0             	mov    %eax,-0x10(%ebp)
		if(v1==NULL)
  801925:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801929:	75 07                	jne    801932 <sget+0x5b>
		{
		return NULL;
  80192b:	b8 00 00 00 00       	mov    $0x0,%eax
  801930:	eb 35                	jmp    801967 <sget+0x90>
	    }
		else
		{
			int ret1=sys_getSharedObject(ownerEnvID,sharedVarName,(void*)v1->sva);
  801932:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801935:	8b 40 08             	mov    0x8(%eax),%eax
  801938:	83 ec 04             	sub    $0x4,%esp
  80193b:	50                   	push   %eax
  80193c:	ff 75 0c             	pushl  0xc(%ebp)
  80193f:	ff 75 08             	pushl  0x8(%ebp)
  801942:	e8 c1 03 00 00       	call   801d08 <sys_getSharedObject>
  801947:	83 c4 10             	add    $0x10,%esp
  80194a:	89 45 ec             	mov    %eax,-0x14(%ebp)
			if(ret1>=0)
  80194d:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  801951:	78 08                	js     80195b <sget+0x84>
			{
				return (void*)v1->sva;
  801953:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801956:	8b 40 08             	mov    0x8(%eax),%eax
  801959:	eb 0c                	jmp    801967 <sget+0x90>
			}
			else
			{
				return NULL;
  80195b:	b8 00 00 00 00       	mov    $0x0,%eax
  801960:	eb 05                	jmp    801967 <sget+0x90>
			}
		}
	}
  return NULL;
  801962:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801967:	c9                   	leave  
  801968:	c3                   	ret    

00801969 <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  801969:	55                   	push   %ebp
  80196a:	89 e5                	mov    %esp,%ebp
  80196c:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  80196f:	e8 63 fb ff ff       	call   8014d7 <InitializeUHeap>
	//==============================================================
	// [USER HEAP - USER SIDE] realloc
	// Write your code here, remove the panic and write your code
	panic("realloc() is not implemented yet...!!");
  801974:	83 ec 04             	sub    $0x4,%esp
  801977:	68 a4 3b 80 00       	push   $0x803ba4
  80197c:	68 0e 01 00 00       	push   $0x10e
  801981:	68 73 3b 80 00       	push   $0x803b73
  801986:	e8 0e eb ff ff       	call   800499 <_panic>

0080198b <sfree>:
//	use sys_freeSharedObject(...); which switches to the kernel mode,
//	calls freeSharedObject(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the freeSharedObject() function is empty, make sure to implement it.

void sfree(void* virtual_address)
{
  80198b:	55                   	push   %ebp
  80198c:	89 e5                	mov    %esp,%ebp
  80198e:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT MS3 - BONUS] [SHARING - USER SIDE] sfree()

	// Write your code here, remove the panic and write your code
	panic("sfree() is not implemented yet...!!");
  801991:	83 ec 04             	sub    $0x4,%esp
  801994:	68 cc 3b 80 00       	push   $0x803bcc
  801999:	68 22 01 00 00       	push   $0x122
  80199e:	68 73 3b 80 00       	push   $0x803b73
  8019a3:	e8 f1 ea ff ff       	call   800499 <_panic>

008019a8 <expand>:

//==================================================================================//
//========================== MODIFICATION FUNCTIONS ================================//
//==================================================================================//
void expand(uint32 newSize)
{
  8019a8:	55                   	push   %ebp
  8019a9:	89 e5                	mov    %esp,%ebp
  8019ab:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  8019ae:	83 ec 04             	sub    $0x4,%esp
  8019b1:	68 f0 3b 80 00       	push   $0x803bf0
  8019b6:	68 2d 01 00 00       	push   $0x12d
  8019bb:	68 73 3b 80 00       	push   $0x803b73
  8019c0:	e8 d4 ea ff ff       	call   800499 <_panic>

008019c5 <shrink>:

}
void shrink(uint32 newSize)
{
  8019c5:	55                   	push   %ebp
  8019c6:	89 e5                	mov    %esp,%ebp
  8019c8:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  8019cb:	83 ec 04             	sub    $0x4,%esp
  8019ce:	68 f0 3b 80 00       	push   $0x803bf0
  8019d3:	68 32 01 00 00       	push   $0x132
  8019d8:	68 73 3b 80 00       	push   $0x803b73
  8019dd:	e8 b7 ea ff ff       	call   800499 <_panic>

008019e2 <freeHeap>:

}
void freeHeap(void* virtual_address)
{
  8019e2:	55                   	push   %ebp
  8019e3:	89 e5                	mov    %esp,%ebp
  8019e5:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  8019e8:	83 ec 04             	sub    $0x4,%esp
  8019eb:	68 f0 3b 80 00       	push   $0x803bf0
  8019f0:	68 37 01 00 00       	push   $0x137
  8019f5:	68 73 3b 80 00       	push   $0x803b73
  8019fa:	e8 9a ea ff ff       	call   800499 <_panic>

008019ff <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  8019ff:	55                   	push   %ebp
  801a00:	89 e5                	mov    %esp,%ebp
  801a02:	57                   	push   %edi
  801a03:	56                   	push   %esi
  801a04:	53                   	push   %ebx
  801a05:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801a08:	8b 45 08             	mov    0x8(%ebp),%eax
  801a0b:	8b 55 0c             	mov    0xc(%ebp),%edx
  801a0e:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801a11:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801a14:	8b 7d 18             	mov    0x18(%ebp),%edi
  801a17:	8b 75 1c             	mov    0x1c(%ebp),%esi
  801a1a:	cd 30                	int    $0x30
  801a1c:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  801a1f:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801a22:	83 c4 10             	add    $0x10,%esp
  801a25:	5b                   	pop    %ebx
  801a26:	5e                   	pop    %esi
  801a27:	5f                   	pop    %edi
  801a28:	5d                   	pop    %ebp
  801a29:	c3                   	ret    

00801a2a <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  801a2a:	55                   	push   %ebp
  801a2b:	89 e5                	mov    %esp,%ebp
  801a2d:	83 ec 04             	sub    $0x4,%esp
  801a30:	8b 45 10             	mov    0x10(%ebp),%eax
  801a33:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  801a36:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801a3a:	8b 45 08             	mov    0x8(%ebp),%eax
  801a3d:	6a 00                	push   $0x0
  801a3f:	6a 00                	push   $0x0
  801a41:	52                   	push   %edx
  801a42:	ff 75 0c             	pushl  0xc(%ebp)
  801a45:	50                   	push   %eax
  801a46:	6a 00                	push   $0x0
  801a48:	e8 b2 ff ff ff       	call   8019ff <syscall>
  801a4d:	83 c4 18             	add    $0x18,%esp
}
  801a50:	90                   	nop
  801a51:	c9                   	leave  
  801a52:	c3                   	ret    

00801a53 <sys_cgetc>:

int
sys_cgetc(void)
{
  801a53:	55                   	push   %ebp
  801a54:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  801a56:	6a 00                	push   $0x0
  801a58:	6a 00                	push   $0x0
  801a5a:	6a 00                	push   $0x0
  801a5c:	6a 00                	push   $0x0
  801a5e:	6a 00                	push   $0x0
  801a60:	6a 01                	push   $0x1
  801a62:	e8 98 ff ff ff       	call   8019ff <syscall>
  801a67:	83 c4 18             	add    $0x18,%esp
}
  801a6a:	c9                   	leave  
  801a6b:	c3                   	ret    

00801a6c <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  801a6c:	55                   	push   %ebp
  801a6d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  801a6f:	8b 55 0c             	mov    0xc(%ebp),%edx
  801a72:	8b 45 08             	mov    0x8(%ebp),%eax
  801a75:	6a 00                	push   $0x0
  801a77:	6a 00                	push   $0x0
  801a79:	6a 00                	push   $0x0
  801a7b:	52                   	push   %edx
  801a7c:	50                   	push   %eax
  801a7d:	6a 05                	push   $0x5
  801a7f:	e8 7b ff ff ff       	call   8019ff <syscall>
  801a84:	83 c4 18             	add    $0x18,%esp
}
  801a87:	c9                   	leave  
  801a88:	c3                   	ret    

00801a89 <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  801a89:	55                   	push   %ebp
  801a8a:	89 e5                	mov    %esp,%ebp
  801a8c:	56                   	push   %esi
  801a8d:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  801a8e:	8b 75 18             	mov    0x18(%ebp),%esi
  801a91:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801a94:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801a97:	8b 55 0c             	mov    0xc(%ebp),%edx
  801a9a:	8b 45 08             	mov    0x8(%ebp),%eax
  801a9d:	56                   	push   %esi
  801a9e:	53                   	push   %ebx
  801a9f:	51                   	push   %ecx
  801aa0:	52                   	push   %edx
  801aa1:	50                   	push   %eax
  801aa2:	6a 06                	push   $0x6
  801aa4:	e8 56 ff ff ff       	call   8019ff <syscall>
  801aa9:	83 c4 18             	add    $0x18,%esp
}
  801aac:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801aaf:	5b                   	pop    %ebx
  801ab0:	5e                   	pop    %esi
  801ab1:	5d                   	pop    %ebp
  801ab2:	c3                   	ret    

00801ab3 <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  801ab3:	55                   	push   %ebp
  801ab4:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  801ab6:	8b 55 0c             	mov    0xc(%ebp),%edx
  801ab9:	8b 45 08             	mov    0x8(%ebp),%eax
  801abc:	6a 00                	push   $0x0
  801abe:	6a 00                	push   $0x0
  801ac0:	6a 00                	push   $0x0
  801ac2:	52                   	push   %edx
  801ac3:	50                   	push   %eax
  801ac4:	6a 07                	push   $0x7
  801ac6:	e8 34 ff ff ff       	call   8019ff <syscall>
  801acb:	83 c4 18             	add    $0x18,%esp
}
  801ace:	c9                   	leave  
  801acf:	c3                   	ret    

00801ad0 <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  801ad0:	55                   	push   %ebp
  801ad1:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  801ad3:	6a 00                	push   $0x0
  801ad5:	6a 00                	push   $0x0
  801ad7:	6a 00                	push   $0x0
  801ad9:	ff 75 0c             	pushl  0xc(%ebp)
  801adc:	ff 75 08             	pushl  0x8(%ebp)
  801adf:	6a 08                	push   $0x8
  801ae1:	e8 19 ff ff ff       	call   8019ff <syscall>
  801ae6:	83 c4 18             	add    $0x18,%esp
}
  801ae9:	c9                   	leave  
  801aea:	c3                   	ret    

00801aeb <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  801aeb:	55                   	push   %ebp
  801aec:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  801aee:	6a 00                	push   $0x0
  801af0:	6a 00                	push   $0x0
  801af2:	6a 00                	push   $0x0
  801af4:	6a 00                	push   $0x0
  801af6:	6a 00                	push   $0x0
  801af8:	6a 09                	push   $0x9
  801afa:	e8 00 ff ff ff       	call   8019ff <syscall>
  801aff:	83 c4 18             	add    $0x18,%esp
}
  801b02:	c9                   	leave  
  801b03:	c3                   	ret    

00801b04 <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  801b04:	55                   	push   %ebp
  801b05:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  801b07:	6a 00                	push   $0x0
  801b09:	6a 00                	push   $0x0
  801b0b:	6a 00                	push   $0x0
  801b0d:	6a 00                	push   $0x0
  801b0f:	6a 00                	push   $0x0
  801b11:	6a 0a                	push   $0xa
  801b13:	e8 e7 fe ff ff       	call   8019ff <syscall>
  801b18:	83 c4 18             	add    $0x18,%esp
}
  801b1b:	c9                   	leave  
  801b1c:	c3                   	ret    

00801b1d <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  801b1d:	55                   	push   %ebp
  801b1e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  801b20:	6a 00                	push   $0x0
  801b22:	6a 00                	push   $0x0
  801b24:	6a 00                	push   $0x0
  801b26:	6a 00                	push   $0x0
  801b28:	6a 00                	push   $0x0
  801b2a:	6a 0b                	push   $0xb
  801b2c:	e8 ce fe ff ff       	call   8019ff <syscall>
  801b31:	83 c4 18             	add    $0x18,%esp
}
  801b34:	c9                   	leave  
  801b35:	c3                   	ret    

00801b36 <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  801b36:	55                   	push   %ebp
  801b37:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  801b39:	6a 00                	push   $0x0
  801b3b:	6a 00                	push   $0x0
  801b3d:	6a 00                	push   $0x0
  801b3f:	ff 75 0c             	pushl  0xc(%ebp)
  801b42:	ff 75 08             	pushl  0x8(%ebp)
  801b45:	6a 0f                	push   $0xf
  801b47:	e8 b3 fe ff ff       	call   8019ff <syscall>
  801b4c:	83 c4 18             	add    $0x18,%esp
	return;
  801b4f:	90                   	nop
}
  801b50:	c9                   	leave  
  801b51:	c3                   	ret    

00801b52 <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  801b52:	55                   	push   %ebp
  801b53:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  801b55:	6a 00                	push   $0x0
  801b57:	6a 00                	push   $0x0
  801b59:	6a 00                	push   $0x0
  801b5b:	ff 75 0c             	pushl  0xc(%ebp)
  801b5e:	ff 75 08             	pushl  0x8(%ebp)
  801b61:	6a 10                	push   $0x10
  801b63:	e8 97 fe ff ff       	call   8019ff <syscall>
  801b68:	83 c4 18             	add    $0x18,%esp
	return ;
  801b6b:	90                   	nop
}
  801b6c:	c9                   	leave  
  801b6d:	c3                   	ret    

00801b6e <sys_allocate_chunk>:

void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  801b6e:	55                   	push   %ebp
  801b6f:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  801b71:	6a 00                	push   $0x0
  801b73:	6a 00                	push   $0x0
  801b75:	ff 75 10             	pushl  0x10(%ebp)
  801b78:	ff 75 0c             	pushl  0xc(%ebp)
  801b7b:	ff 75 08             	pushl  0x8(%ebp)
  801b7e:	6a 11                	push   $0x11
  801b80:	e8 7a fe ff ff       	call   8019ff <syscall>
  801b85:	83 c4 18             	add    $0x18,%esp
	return ;
  801b88:	90                   	nop
}
  801b89:	c9                   	leave  
  801b8a:	c3                   	ret    

00801b8b <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  801b8b:	55                   	push   %ebp
  801b8c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  801b8e:	6a 00                	push   $0x0
  801b90:	6a 00                	push   $0x0
  801b92:	6a 00                	push   $0x0
  801b94:	6a 00                	push   $0x0
  801b96:	6a 00                	push   $0x0
  801b98:	6a 0c                	push   $0xc
  801b9a:	e8 60 fe ff ff       	call   8019ff <syscall>
  801b9f:	83 c4 18             	add    $0x18,%esp
}
  801ba2:	c9                   	leave  
  801ba3:	c3                   	ret    

00801ba4 <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  801ba4:	55                   	push   %ebp
  801ba5:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  801ba7:	6a 00                	push   $0x0
  801ba9:	6a 00                	push   $0x0
  801bab:	6a 00                	push   $0x0
  801bad:	6a 00                	push   $0x0
  801baf:	ff 75 08             	pushl  0x8(%ebp)
  801bb2:	6a 0d                	push   $0xd
  801bb4:	e8 46 fe ff ff       	call   8019ff <syscall>
  801bb9:	83 c4 18             	add    $0x18,%esp
}
  801bbc:	c9                   	leave  
  801bbd:	c3                   	ret    

00801bbe <sys_scarce_memory>:

void sys_scarce_memory()
{
  801bbe:	55                   	push   %ebp
  801bbf:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  801bc1:	6a 00                	push   $0x0
  801bc3:	6a 00                	push   $0x0
  801bc5:	6a 00                	push   $0x0
  801bc7:	6a 00                	push   $0x0
  801bc9:	6a 00                	push   $0x0
  801bcb:	6a 0e                	push   $0xe
  801bcd:	e8 2d fe ff ff       	call   8019ff <syscall>
  801bd2:	83 c4 18             	add    $0x18,%esp
}
  801bd5:	90                   	nop
  801bd6:	c9                   	leave  
  801bd7:	c3                   	ret    

00801bd8 <sys_disable_interrupt>:

//NEW !! 2012...
void
sys_disable_interrupt()
{
  801bd8:	55                   	push   %ebp
  801bd9:	89 e5                	mov    %esp,%ebp
	syscall(SYS_disableINTR,0, 0, 0, 0, 0);
  801bdb:	6a 00                	push   $0x0
  801bdd:	6a 00                	push   $0x0
  801bdf:	6a 00                	push   $0x0
  801be1:	6a 00                	push   $0x0
  801be3:	6a 00                	push   $0x0
  801be5:	6a 13                	push   $0x13
  801be7:	e8 13 fe ff ff       	call   8019ff <syscall>
  801bec:	83 c4 18             	add    $0x18,%esp
}
  801bef:	90                   	nop
  801bf0:	c9                   	leave  
  801bf1:	c3                   	ret    

00801bf2 <sys_enable_interrupt>:


void
sys_enable_interrupt()
{
  801bf2:	55                   	push   %ebp
  801bf3:	89 e5                	mov    %esp,%ebp
	syscall(SYS_enableINTR,0, 0, 0, 0, 0);
  801bf5:	6a 00                	push   $0x0
  801bf7:	6a 00                	push   $0x0
  801bf9:	6a 00                	push   $0x0
  801bfb:	6a 00                	push   $0x0
  801bfd:	6a 00                	push   $0x0
  801bff:	6a 14                	push   $0x14
  801c01:	e8 f9 fd ff ff       	call   8019ff <syscall>
  801c06:	83 c4 18             	add    $0x18,%esp
}
  801c09:	90                   	nop
  801c0a:	c9                   	leave  
  801c0b:	c3                   	ret    

00801c0c <sys_cputc>:


void
sys_cputc(const char c)
{
  801c0c:	55                   	push   %ebp
  801c0d:	89 e5                	mov    %esp,%ebp
  801c0f:	83 ec 04             	sub    $0x4,%esp
  801c12:	8b 45 08             	mov    0x8(%ebp),%eax
  801c15:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  801c18:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801c1c:	6a 00                	push   $0x0
  801c1e:	6a 00                	push   $0x0
  801c20:	6a 00                	push   $0x0
  801c22:	6a 00                	push   $0x0
  801c24:	50                   	push   %eax
  801c25:	6a 15                	push   $0x15
  801c27:	e8 d3 fd ff ff       	call   8019ff <syscall>
  801c2c:	83 c4 18             	add    $0x18,%esp
}
  801c2f:	90                   	nop
  801c30:	c9                   	leave  
  801c31:	c3                   	ret    

00801c32 <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  801c32:	55                   	push   %ebp
  801c33:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  801c35:	6a 00                	push   $0x0
  801c37:	6a 00                	push   $0x0
  801c39:	6a 00                	push   $0x0
  801c3b:	6a 00                	push   $0x0
  801c3d:	6a 00                	push   $0x0
  801c3f:	6a 16                	push   $0x16
  801c41:	e8 b9 fd ff ff       	call   8019ff <syscall>
  801c46:	83 c4 18             	add    $0x18,%esp
}
  801c49:	90                   	nop
  801c4a:	c9                   	leave  
  801c4b:	c3                   	ret    

00801c4c <sys_createSemaphore>:

int
sys_createSemaphore(char* semaphoreName, uint32 initialValue)
{
  801c4c:	55                   	push   %ebp
  801c4d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_semaphore,(uint32)semaphoreName, (uint32)initialValue, 0, 0, 0);
  801c4f:	8b 45 08             	mov    0x8(%ebp),%eax
  801c52:	6a 00                	push   $0x0
  801c54:	6a 00                	push   $0x0
  801c56:	6a 00                	push   $0x0
  801c58:	ff 75 0c             	pushl  0xc(%ebp)
  801c5b:	50                   	push   %eax
  801c5c:	6a 17                	push   $0x17
  801c5e:	e8 9c fd ff ff       	call   8019ff <syscall>
  801c63:	83 c4 18             	add    $0x18,%esp
}
  801c66:	c9                   	leave  
  801c67:	c3                   	ret    

00801c68 <sys_getSemaphoreValue>:

int
sys_getSemaphoreValue(int32 ownerEnvID, char* semaphoreName)
{
  801c68:	55                   	push   %ebp
  801c69:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_semaphore_value,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801c6b:	8b 55 0c             	mov    0xc(%ebp),%edx
  801c6e:	8b 45 08             	mov    0x8(%ebp),%eax
  801c71:	6a 00                	push   $0x0
  801c73:	6a 00                	push   $0x0
  801c75:	6a 00                	push   $0x0
  801c77:	52                   	push   %edx
  801c78:	50                   	push   %eax
  801c79:	6a 1a                	push   $0x1a
  801c7b:	e8 7f fd ff ff       	call   8019ff <syscall>
  801c80:	83 c4 18             	add    $0x18,%esp
}
  801c83:	c9                   	leave  
  801c84:	c3                   	ret    

00801c85 <sys_waitSemaphore>:

void
sys_waitSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  801c85:	55                   	push   %ebp
  801c86:	89 e5                	mov    %esp,%ebp
	syscall(SYS_wait_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801c88:	8b 55 0c             	mov    0xc(%ebp),%edx
  801c8b:	8b 45 08             	mov    0x8(%ebp),%eax
  801c8e:	6a 00                	push   $0x0
  801c90:	6a 00                	push   $0x0
  801c92:	6a 00                	push   $0x0
  801c94:	52                   	push   %edx
  801c95:	50                   	push   %eax
  801c96:	6a 18                	push   $0x18
  801c98:	e8 62 fd ff ff       	call   8019ff <syscall>
  801c9d:	83 c4 18             	add    $0x18,%esp
}
  801ca0:	90                   	nop
  801ca1:	c9                   	leave  
  801ca2:	c3                   	ret    

00801ca3 <sys_signalSemaphore>:

void
sys_signalSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  801ca3:	55                   	push   %ebp
  801ca4:	89 e5                	mov    %esp,%ebp
	syscall(SYS_signal_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801ca6:	8b 55 0c             	mov    0xc(%ebp),%edx
  801ca9:	8b 45 08             	mov    0x8(%ebp),%eax
  801cac:	6a 00                	push   $0x0
  801cae:	6a 00                	push   $0x0
  801cb0:	6a 00                	push   $0x0
  801cb2:	52                   	push   %edx
  801cb3:	50                   	push   %eax
  801cb4:	6a 19                	push   $0x19
  801cb6:	e8 44 fd ff ff       	call   8019ff <syscall>
  801cbb:	83 c4 18             	add    $0x18,%esp
}
  801cbe:	90                   	nop
  801cbf:	c9                   	leave  
  801cc0:	c3                   	ret    

00801cc1 <sys_createSharedObject>:

int
sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  801cc1:	55                   	push   %ebp
  801cc2:	89 e5                	mov    %esp,%ebp
  801cc4:	83 ec 04             	sub    $0x4,%esp
  801cc7:	8b 45 10             	mov    0x10(%ebp),%eax
  801cca:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  801ccd:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801cd0:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801cd4:	8b 45 08             	mov    0x8(%ebp),%eax
  801cd7:	6a 00                	push   $0x0
  801cd9:	51                   	push   %ecx
  801cda:	52                   	push   %edx
  801cdb:	ff 75 0c             	pushl  0xc(%ebp)
  801cde:	50                   	push   %eax
  801cdf:	6a 1b                	push   $0x1b
  801ce1:	e8 19 fd ff ff       	call   8019ff <syscall>
  801ce6:	83 c4 18             	add    $0x18,%esp
}
  801ce9:	c9                   	leave  
  801cea:	c3                   	ret    

00801ceb <sys_getSizeOfSharedObject>:

//2017:
int
sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  801ceb:	55                   	push   %ebp
  801cec:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  801cee:	8b 55 0c             	mov    0xc(%ebp),%edx
  801cf1:	8b 45 08             	mov    0x8(%ebp),%eax
  801cf4:	6a 00                	push   $0x0
  801cf6:	6a 00                	push   $0x0
  801cf8:	6a 00                	push   $0x0
  801cfa:	52                   	push   %edx
  801cfb:	50                   	push   %eax
  801cfc:	6a 1c                	push   $0x1c
  801cfe:	e8 fc fc ff ff       	call   8019ff <syscall>
  801d03:	83 c4 18             	add    $0x18,%esp
}
  801d06:	c9                   	leave  
  801d07:	c3                   	ret    

00801d08 <sys_getSharedObject>:
//==========

int
sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  801d08:	55                   	push   %ebp
  801d09:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  801d0b:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801d0e:	8b 55 0c             	mov    0xc(%ebp),%edx
  801d11:	8b 45 08             	mov    0x8(%ebp),%eax
  801d14:	6a 00                	push   $0x0
  801d16:	6a 00                	push   $0x0
  801d18:	51                   	push   %ecx
  801d19:	52                   	push   %edx
  801d1a:	50                   	push   %eax
  801d1b:	6a 1d                	push   $0x1d
  801d1d:	e8 dd fc ff ff       	call   8019ff <syscall>
  801d22:	83 c4 18             	add    $0x18,%esp
}
  801d25:	c9                   	leave  
  801d26:	c3                   	ret    

00801d27 <sys_freeSharedObject>:

int
sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  801d27:	55                   	push   %ebp
  801d28:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  801d2a:	8b 55 0c             	mov    0xc(%ebp),%edx
  801d2d:	8b 45 08             	mov    0x8(%ebp),%eax
  801d30:	6a 00                	push   $0x0
  801d32:	6a 00                	push   $0x0
  801d34:	6a 00                	push   $0x0
  801d36:	52                   	push   %edx
  801d37:	50                   	push   %eax
  801d38:	6a 1e                	push   $0x1e
  801d3a:	e8 c0 fc ff ff       	call   8019ff <syscall>
  801d3f:	83 c4 18             	add    $0x18,%esp
}
  801d42:	c9                   	leave  
  801d43:	c3                   	ret    

00801d44 <sys_getMaxShares>:

uint32 	sys_getMaxShares()
{
  801d44:	55                   	push   %ebp
  801d45:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_max_shares,0, 0, 0, 0, 0);
  801d47:	6a 00                	push   $0x0
  801d49:	6a 00                	push   $0x0
  801d4b:	6a 00                	push   $0x0
  801d4d:	6a 00                	push   $0x0
  801d4f:	6a 00                	push   $0x0
  801d51:	6a 1f                	push   $0x1f
  801d53:	e8 a7 fc ff ff       	call   8019ff <syscall>
  801d58:	83 c4 18             	add    $0x18,%esp
}
  801d5b:	c9                   	leave  
  801d5c:	c3                   	ret    

00801d5d <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  801d5d:	55                   	push   %ebp
  801d5e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  801d60:	8b 45 08             	mov    0x8(%ebp),%eax
  801d63:	6a 00                	push   $0x0
  801d65:	ff 75 14             	pushl  0x14(%ebp)
  801d68:	ff 75 10             	pushl  0x10(%ebp)
  801d6b:	ff 75 0c             	pushl  0xc(%ebp)
  801d6e:	50                   	push   %eax
  801d6f:	6a 20                	push   $0x20
  801d71:	e8 89 fc ff ff       	call   8019ff <syscall>
  801d76:	83 c4 18             	add    $0x18,%esp
}
  801d79:	c9                   	leave  
  801d7a:	c3                   	ret    

00801d7b <sys_run_env>:

void
sys_run_env(int32 envId)
{
  801d7b:	55                   	push   %ebp
  801d7c:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  801d7e:	8b 45 08             	mov    0x8(%ebp),%eax
  801d81:	6a 00                	push   $0x0
  801d83:	6a 00                	push   $0x0
  801d85:	6a 00                	push   $0x0
  801d87:	6a 00                	push   $0x0
  801d89:	50                   	push   %eax
  801d8a:	6a 21                	push   $0x21
  801d8c:	e8 6e fc ff ff       	call   8019ff <syscall>
  801d91:	83 c4 18             	add    $0x18,%esp
}
  801d94:	90                   	nop
  801d95:	c9                   	leave  
  801d96:	c3                   	ret    

00801d97 <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  801d97:	55                   	push   %ebp
  801d98:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  801d9a:	8b 45 08             	mov    0x8(%ebp),%eax
  801d9d:	6a 00                	push   $0x0
  801d9f:	6a 00                	push   $0x0
  801da1:	6a 00                	push   $0x0
  801da3:	6a 00                	push   $0x0
  801da5:	50                   	push   %eax
  801da6:	6a 22                	push   $0x22
  801da8:	e8 52 fc ff ff       	call   8019ff <syscall>
  801dad:	83 c4 18             	add    $0x18,%esp
}
  801db0:	c9                   	leave  
  801db1:	c3                   	ret    

00801db2 <sys_getenvid>:

int32 sys_getenvid(void)
{
  801db2:	55                   	push   %ebp
  801db3:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  801db5:	6a 00                	push   $0x0
  801db7:	6a 00                	push   $0x0
  801db9:	6a 00                	push   $0x0
  801dbb:	6a 00                	push   $0x0
  801dbd:	6a 00                	push   $0x0
  801dbf:	6a 02                	push   $0x2
  801dc1:	e8 39 fc ff ff       	call   8019ff <syscall>
  801dc6:	83 c4 18             	add    $0x18,%esp
}
  801dc9:	c9                   	leave  
  801dca:	c3                   	ret    

00801dcb <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  801dcb:	55                   	push   %ebp
  801dcc:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  801dce:	6a 00                	push   $0x0
  801dd0:	6a 00                	push   $0x0
  801dd2:	6a 00                	push   $0x0
  801dd4:	6a 00                	push   $0x0
  801dd6:	6a 00                	push   $0x0
  801dd8:	6a 03                	push   $0x3
  801dda:	e8 20 fc ff ff       	call   8019ff <syscall>
  801ddf:	83 c4 18             	add    $0x18,%esp
}
  801de2:	c9                   	leave  
  801de3:	c3                   	ret    

00801de4 <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  801de4:	55                   	push   %ebp
  801de5:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  801de7:	6a 00                	push   $0x0
  801de9:	6a 00                	push   $0x0
  801deb:	6a 00                	push   $0x0
  801ded:	6a 00                	push   $0x0
  801def:	6a 00                	push   $0x0
  801df1:	6a 04                	push   $0x4
  801df3:	e8 07 fc ff ff       	call   8019ff <syscall>
  801df8:	83 c4 18             	add    $0x18,%esp
}
  801dfb:	c9                   	leave  
  801dfc:	c3                   	ret    

00801dfd <sys_exit_env>:


void sys_exit_env(void)
{
  801dfd:	55                   	push   %ebp
  801dfe:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  801e00:	6a 00                	push   $0x0
  801e02:	6a 00                	push   $0x0
  801e04:	6a 00                	push   $0x0
  801e06:	6a 00                	push   $0x0
  801e08:	6a 00                	push   $0x0
  801e0a:	6a 23                	push   $0x23
  801e0c:	e8 ee fb ff ff       	call   8019ff <syscall>
  801e11:	83 c4 18             	add    $0x18,%esp
}
  801e14:	90                   	nop
  801e15:	c9                   	leave  
  801e16:	c3                   	ret    

00801e17 <sys_get_virtual_time>:


struct uint64
sys_get_virtual_time()
{
  801e17:	55                   	push   %ebp
  801e18:	89 e5                	mov    %esp,%ebp
  801e1a:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  801e1d:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801e20:	8d 50 04             	lea    0x4(%eax),%edx
  801e23:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801e26:	6a 00                	push   $0x0
  801e28:	6a 00                	push   $0x0
  801e2a:	6a 00                	push   $0x0
  801e2c:	52                   	push   %edx
  801e2d:	50                   	push   %eax
  801e2e:	6a 24                	push   $0x24
  801e30:	e8 ca fb ff ff       	call   8019ff <syscall>
  801e35:	83 c4 18             	add    $0x18,%esp
	return result;
  801e38:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801e3b:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801e3e:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801e41:	89 01                	mov    %eax,(%ecx)
  801e43:	89 51 04             	mov    %edx,0x4(%ecx)
}
  801e46:	8b 45 08             	mov    0x8(%ebp),%eax
  801e49:	c9                   	leave  
  801e4a:	c2 04 00             	ret    $0x4

00801e4d <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  801e4d:	55                   	push   %ebp
  801e4e:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  801e50:	6a 00                	push   $0x0
  801e52:	6a 00                	push   $0x0
  801e54:	ff 75 10             	pushl  0x10(%ebp)
  801e57:	ff 75 0c             	pushl  0xc(%ebp)
  801e5a:	ff 75 08             	pushl  0x8(%ebp)
  801e5d:	6a 12                	push   $0x12
  801e5f:	e8 9b fb ff ff       	call   8019ff <syscall>
  801e64:	83 c4 18             	add    $0x18,%esp
	return ;
  801e67:	90                   	nop
}
  801e68:	c9                   	leave  
  801e69:	c3                   	ret    

00801e6a <sys_rcr2>:
uint32 sys_rcr2()
{
  801e6a:	55                   	push   %ebp
  801e6b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  801e6d:	6a 00                	push   $0x0
  801e6f:	6a 00                	push   $0x0
  801e71:	6a 00                	push   $0x0
  801e73:	6a 00                	push   $0x0
  801e75:	6a 00                	push   $0x0
  801e77:	6a 25                	push   $0x25
  801e79:	e8 81 fb ff ff       	call   8019ff <syscall>
  801e7e:	83 c4 18             	add    $0x18,%esp
}
  801e81:	c9                   	leave  
  801e82:	c3                   	ret    

00801e83 <sys_bypassPageFault>:
void sys_bypassPageFault(uint8 instrLength)
{
  801e83:	55                   	push   %ebp
  801e84:	89 e5                	mov    %esp,%ebp
  801e86:	83 ec 04             	sub    $0x4,%esp
  801e89:	8b 45 08             	mov    0x8(%ebp),%eax
  801e8c:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  801e8f:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  801e93:	6a 00                	push   $0x0
  801e95:	6a 00                	push   $0x0
  801e97:	6a 00                	push   $0x0
  801e99:	6a 00                	push   $0x0
  801e9b:	50                   	push   %eax
  801e9c:	6a 26                	push   $0x26
  801e9e:	e8 5c fb ff ff       	call   8019ff <syscall>
  801ea3:	83 c4 18             	add    $0x18,%esp
	return ;
  801ea6:	90                   	nop
}
  801ea7:	c9                   	leave  
  801ea8:	c3                   	ret    

00801ea9 <rsttst>:
void rsttst()
{
  801ea9:	55                   	push   %ebp
  801eaa:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  801eac:	6a 00                	push   $0x0
  801eae:	6a 00                	push   $0x0
  801eb0:	6a 00                	push   $0x0
  801eb2:	6a 00                	push   $0x0
  801eb4:	6a 00                	push   $0x0
  801eb6:	6a 28                	push   $0x28
  801eb8:	e8 42 fb ff ff       	call   8019ff <syscall>
  801ebd:	83 c4 18             	add    $0x18,%esp
	return ;
  801ec0:	90                   	nop
}
  801ec1:	c9                   	leave  
  801ec2:	c3                   	ret    

00801ec3 <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  801ec3:	55                   	push   %ebp
  801ec4:	89 e5                	mov    %esp,%ebp
  801ec6:	83 ec 04             	sub    $0x4,%esp
  801ec9:	8b 45 14             	mov    0x14(%ebp),%eax
  801ecc:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  801ecf:	8b 55 18             	mov    0x18(%ebp),%edx
  801ed2:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801ed6:	52                   	push   %edx
  801ed7:	50                   	push   %eax
  801ed8:	ff 75 10             	pushl  0x10(%ebp)
  801edb:	ff 75 0c             	pushl  0xc(%ebp)
  801ede:	ff 75 08             	pushl  0x8(%ebp)
  801ee1:	6a 27                	push   $0x27
  801ee3:	e8 17 fb ff ff       	call   8019ff <syscall>
  801ee8:	83 c4 18             	add    $0x18,%esp
	return ;
  801eeb:	90                   	nop
}
  801eec:	c9                   	leave  
  801eed:	c3                   	ret    

00801eee <chktst>:
void chktst(uint32 n)
{
  801eee:	55                   	push   %ebp
  801eef:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  801ef1:	6a 00                	push   $0x0
  801ef3:	6a 00                	push   $0x0
  801ef5:	6a 00                	push   $0x0
  801ef7:	6a 00                	push   $0x0
  801ef9:	ff 75 08             	pushl  0x8(%ebp)
  801efc:	6a 29                	push   $0x29
  801efe:	e8 fc fa ff ff       	call   8019ff <syscall>
  801f03:	83 c4 18             	add    $0x18,%esp
	return ;
  801f06:	90                   	nop
}
  801f07:	c9                   	leave  
  801f08:	c3                   	ret    

00801f09 <inctst>:

void inctst()
{
  801f09:	55                   	push   %ebp
  801f0a:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  801f0c:	6a 00                	push   $0x0
  801f0e:	6a 00                	push   $0x0
  801f10:	6a 00                	push   $0x0
  801f12:	6a 00                	push   $0x0
  801f14:	6a 00                	push   $0x0
  801f16:	6a 2a                	push   $0x2a
  801f18:	e8 e2 fa ff ff       	call   8019ff <syscall>
  801f1d:	83 c4 18             	add    $0x18,%esp
	return ;
  801f20:	90                   	nop
}
  801f21:	c9                   	leave  
  801f22:	c3                   	ret    

00801f23 <gettst>:
uint32 gettst()
{
  801f23:	55                   	push   %ebp
  801f24:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  801f26:	6a 00                	push   $0x0
  801f28:	6a 00                	push   $0x0
  801f2a:	6a 00                	push   $0x0
  801f2c:	6a 00                	push   $0x0
  801f2e:	6a 00                	push   $0x0
  801f30:	6a 2b                	push   $0x2b
  801f32:	e8 c8 fa ff ff       	call   8019ff <syscall>
  801f37:	83 c4 18             	add    $0x18,%esp
}
  801f3a:	c9                   	leave  
  801f3b:	c3                   	ret    

00801f3c <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  801f3c:	55                   	push   %ebp
  801f3d:	89 e5                	mov    %esp,%ebp
  801f3f:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801f42:	6a 00                	push   $0x0
  801f44:	6a 00                	push   $0x0
  801f46:	6a 00                	push   $0x0
  801f48:	6a 00                	push   $0x0
  801f4a:	6a 00                	push   $0x0
  801f4c:	6a 2c                	push   $0x2c
  801f4e:	e8 ac fa ff ff       	call   8019ff <syscall>
  801f53:	83 c4 18             	add    $0x18,%esp
  801f56:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  801f59:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  801f5d:	75 07                	jne    801f66 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  801f5f:	b8 01 00 00 00       	mov    $0x1,%eax
  801f64:	eb 05                	jmp    801f6b <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  801f66:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801f6b:	c9                   	leave  
  801f6c:	c3                   	ret    

00801f6d <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  801f6d:	55                   	push   %ebp
  801f6e:	89 e5                	mov    %esp,%ebp
  801f70:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801f73:	6a 00                	push   $0x0
  801f75:	6a 00                	push   $0x0
  801f77:	6a 00                	push   $0x0
  801f79:	6a 00                	push   $0x0
  801f7b:	6a 00                	push   $0x0
  801f7d:	6a 2c                	push   $0x2c
  801f7f:	e8 7b fa ff ff       	call   8019ff <syscall>
  801f84:	83 c4 18             	add    $0x18,%esp
  801f87:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  801f8a:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  801f8e:	75 07                	jne    801f97 <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  801f90:	b8 01 00 00 00       	mov    $0x1,%eax
  801f95:	eb 05                	jmp    801f9c <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  801f97:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801f9c:	c9                   	leave  
  801f9d:	c3                   	ret    

00801f9e <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  801f9e:	55                   	push   %ebp
  801f9f:	89 e5                	mov    %esp,%ebp
  801fa1:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801fa4:	6a 00                	push   $0x0
  801fa6:	6a 00                	push   $0x0
  801fa8:	6a 00                	push   $0x0
  801faa:	6a 00                	push   $0x0
  801fac:	6a 00                	push   $0x0
  801fae:	6a 2c                	push   $0x2c
  801fb0:	e8 4a fa ff ff       	call   8019ff <syscall>
  801fb5:	83 c4 18             	add    $0x18,%esp
  801fb8:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  801fbb:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  801fbf:	75 07                	jne    801fc8 <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  801fc1:	b8 01 00 00 00       	mov    $0x1,%eax
  801fc6:	eb 05                	jmp    801fcd <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  801fc8:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801fcd:	c9                   	leave  
  801fce:	c3                   	ret    

00801fcf <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  801fcf:	55                   	push   %ebp
  801fd0:	89 e5                	mov    %esp,%ebp
  801fd2:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801fd5:	6a 00                	push   $0x0
  801fd7:	6a 00                	push   $0x0
  801fd9:	6a 00                	push   $0x0
  801fdb:	6a 00                	push   $0x0
  801fdd:	6a 00                	push   $0x0
  801fdf:	6a 2c                	push   $0x2c
  801fe1:	e8 19 fa ff ff       	call   8019ff <syscall>
  801fe6:	83 c4 18             	add    $0x18,%esp
  801fe9:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  801fec:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  801ff0:	75 07                	jne    801ff9 <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  801ff2:	b8 01 00 00 00       	mov    $0x1,%eax
  801ff7:	eb 05                	jmp    801ffe <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  801ff9:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801ffe:	c9                   	leave  
  801fff:	c3                   	ret    

00802000 <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  802000:	55                   	push   %ebp
  802001:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  802003:	6a 00                	push   $0x0
  802005:	6a 00                	push   $0x0
  802007:	6a 00                	push   $0x0
  802009:	6a 00                	push   $0x0
  80200b:	ff 75 08             	pushl  0x8(%ebp)
  80200e:	6a 2d                	push   $0x2d
  802010:	e8 ea f9 ff ff       	call   8019ff <syscall>
  802015:	83 c4 18             	add    $0x18,%esp
	return ;
  802018:	90                   	nop
}
  802019:	c9                   	leave  
  80201a:	c3                   	ret    

0080201b <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  80201b:	55                   	push   %ebp
  80201c:	89 e5                	mov    %esp,%ebp
  80201e:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  80201f:	8b 5d 14             	mov    0x14(%ebp),%ebx
  802022:	8b 4d 10             	mov    0x10(%ebp),%ecx
  802025:	8b 55 0c             	mov    0xc(%ebp),%edx
  802028:	8b 45 08             	mov    0x8(%ebp),%eax
  80202b:	6a 00                	push   $0x0
  80202d:	53                   	push   %ebx
  80202e:	51                   	push   %ecx
  80202f:	52                   	push   %edx
  802030:	50                   	push   %eax
  802031:	6a 2e                	push   $0x2e
  802033:	e8 c7 f9 ff ff       	call   8019ff <syscall>
  802038:	83 c4 18             	add    $0x18,%esp
}
  80203b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80203e:	c9                   	leave  
  80203f:	c3                   	ret    

00802040 <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  802040:	55                   	push   %ebp
  802041:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  802043:	8b 55 0c             	mov    0xc(%ebp),%edx
  802046:	8b 45 08             	mov    0x8(%ebp),%eax
  802049:	6a 00                	push   $0x0
  80204b:	6a 00                	push   $0x0
  80204d:	6a 00                	push   $0x0
  80204f:	52                   	push   %edx
  802050:	50                   	push   %eax
  802051:	6a 2f                	push   $0x2f
  802053:	e8 a7 f9 ff ff       	call   8019ff <syscall>
  802058:	83 c4 18             	add    $0x18,%esp
}
  80205b:	c9                   	leave  
  80205c:	c3                   	ret    

0080205d <print_mem_block_lists>:
//===========================
// PRINT MEM BLOCK LISTS:
//===========================

void print_mem_block_lists()
{
  80205d:	55                   	push   %ebp
  80205e:	89 e5                	mov    %esp,%ebp
  802060:	83 ec 18             	sub    $0x18,%esp
	cprintf("\n=========================================\n");
  802063:	83 ec 0c             	sub    $0xc,%esp
  802066:	68 00 3c 80 00       	push   $0x803c00
  80206b:	e8 dd e6 ff ff       	call   80074d <cprintf>
  802070:	83 c4 10             	add    $0x10,%esp
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
  802073:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nFreeMemBlocksList:\n");
  80207a:	83 ec 0c             	sub    $0xc,%esp
  80207d:	68 2c 3c 80 00       	push   $0x803c2c
  802082:	e8 c6 e6 ff ff       	call   80074d <cprintf>
  802087:	83 c4 10             	add    $0x10,%esp
	uint8 sorted = 1 ;
  80208a:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &FreeMemBlocksList)
  80208e:	a1 38 41 80 00       	mov    0x804138,%eax
  802093:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802096:	eb 56                	jmp    8020ee <print_mem_block_lists+0x91>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  802098:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80209c:	74 1c                	je     8020ba <print_mem_block_lists+0x5d>
  80209e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8020a1:	8b 50 08             	mov    0x8(%eax),%edx
  8020a4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8020a7:	8b 48 08             	mov    0x8(%eax),%ecx
  8020aa:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8020ad:	8b 40 0c             	mov    0xc(%eax),%eax
  8020b0:	01 c8                	add    %ecx,%eax
  8020b2:	39 c2                	cmp    %eax,%edx
  8020b4:	73 04                	jae    8020ba <print_mem_block_lists+0x5d>
			sorted = 0 ;
  8020b6:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  8020ba:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8020bd:	8b 50 08             	mov    0x8(%eax),%edx
  8020c0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8020c3:	8b 40 0c             	mov    0xc(%eax),%eax
  8020c6:	01 c2                	add    %eax,%edx
  8020c8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8020cb:	8b 40 08             	mov    0x8(%eax),%eax
  8020ce:	83 ec 04             	sub    $0x4,%esp
  8020d1:	52                   	push   %edx
  8020d2:	50                   	push   %eax
  8020d3:	68 41 3c 80 00       	push   $0x803c41
  8020d8:	e8 70 e6 ff ff       	call   80074d <cprintf>
  8020dd:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  8020e0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8020e3:	89 45 f0             	mov    %eax,-0x10(%ebp)
	cprintf("\n=========================================\n");
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
	cprintf("\nFreeMemBlocksList:\n");
	uint8 sorted = 1 ;
	LIST_FOREACH(blk, &FreeMemBlocksList)
  8020e6:	a1 40 41 80 00       	mov    0x804140,%eax
  8020eb:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8020ee:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8020f2:	74 07                	je     8020fb <print_mem_block_lists+0x9e>
  8020f4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8020f7:	8b 00                	mov    (%eax),%eax
  8020f9:	eb 05                	jmp    802100 <print_mem_block_lists+0xa3>
  8020fb:	b8 00 00 00 00       	mov    $0x0,%eax
  802100:	a3 40 41 80 00       	mov    %eax,0x804140
  802105:	a1 40 41 80 00       	mov    0x804140,%eax
  80210a:	85 c0                	test   %eax,%eax
  80210c:	75 8a                	jne    802098 <print_mem_block_lists+0x3b>
  80210e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802112:	75 84                	jne    802098 <print_mem_block_lists+0x3b>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;
  802114:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  802118:	75 10                	jne    80212a <print_mem_block_lists+0xcd>
  80211a:	83 ec 0c             	sub    $0xc,%esp
  80211d:	68 50 3c 80 00       	push   $0x803c50
  802122:	e8 26 e6 ff ff       	call   80074d <cprintf>
  802127:	83 c4 10             	add    $0x10,%esp

	lastBlk = NULL ;
  80212a:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nAllocMemBlocksList:\n");
  802131:	83 ec 0c             	sub    $0xc,%esp
  802134:	68 74 3c 80 00       	push   $0x803c74
  802139:	e8 0f e6 ff ff       	call   80074d <cprintf>
  80213e:	83 c4 10             	add    $0x10,%esp
	sorted = 1 ;
  802141:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &AllocMemBlocksList)
  802145:	a1 40 40 80 00       	mov    0x804040,%eax
  80214a:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80214d:	eb 56                	jmp    8021a5 <print_mem_block_lists+0x148>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  80214f:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802153:	74 1c                	je     802171 <print_mem_block_lists+0x114>
  802155:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802158:	8b 50 08             	mov    0x8(%eax),%edx
  80215b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80215e:	8b 48 08             	mov    0x8(%eax),%ecx
  802161:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802164:	8b 40 0c             	mov    0xc(%eax),%eax
  802167:	01 c8                	add    %ecx,%eax
  802169:	39 c2                	cmp    %eax,%edx
  80216b:	73 04                	jae    802171 <print_mem_block_lists+0x114>
			sorted = 0 ;
  80216d:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  802171:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802174:	8b 50 08             	mov    0x8(%eax),%edx
  802177:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80217a:	8b 40 0c             	mov    0xc(%eax),%eax
  80217d:	01 c2                	add    %eax,%edx
  80217f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802182:	8b 40 08             	mov    0x8(%eax),%eax
  802185:	83 ec 04             	sub    $0x4,%esp
  802188:	52                   	push   %edx
  802189:	50                   	push   %eax
  80218a:	68 41 3c 80 00       	push   $0x803c41
  80218f:	e8 b9 e5 ff ff       	call   80074d <cprintf>
  802194:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  802197:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80219a:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;

	lastBlk = NULL ;
	cprintf("\nAllocMemBlocksList:\n");
	sorted = 1 ;
	LIST_FOREACH(blk, &AllocMemBlocksList)
  80219d:	a1 48 40 80 00       	mov    0x804048,%eax
  8021a2:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8021a5:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8021a9:	74 07                	je     8021b2 <print_mem_block_lists+0x155>
  8021ab:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8021ae:	8b 00                	mov    (%eax),%eax
  8021b0:	eb 05                	jmp    8021b7 <print_mem_block_lists+0x15a>
  8021b2:	b8 00 00 00 00       	mov    $0x0,%eax
  8021b7:	a3 48 40 80 00       	mov    %eax,0x804048
  8021bc:	a1 48 40 80 00       	mov    0x804048,%eax
  8021c1:	85 c0                	test   %eax,%eax
  8021c3:	75 8a                	jne    80214f <print_mem_block_lists+0xf2>
  8021c5:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8021c9:	75 84                	jne    80214f <print_mem_block_lists+0xf2>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nAllocMemBlocksList is NOT SORTED!!\n") ;
  8021cb:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  8021cf:	75 10                	jne    8021e1 <print_mem_block_lists+0x184>
  8021d1:	83 ec 0c             	sub    $0xc,%esp
  8021d4:	68 8c 3c 80 00       	push   $0x803c8c
  8021d9:	e8 6f e5 ff ff       	call   80074d <cprintf>
  8021de:	83 c4 10             	add    $0x10,%esp
	cprintf("\n=========================================\n");
  8021e1:	83 ec 0c             	sub    $0xc,%esp
  8021e4:	68 00 3c 80 00       	push   $0x803c00
  8021e9:	e8 5f e5 ff ff       	call   80074d <cprintf>
  8021ee:	83 c4 10             	add    $0x10,%esp

}
  8021f1:	90                   	nop
  8021f2:	c9                   	leave  
  8021f3:	c3                   	ret    

008021f4 <initialize_MemBlocksList>:

//===============================
// [1] INITIALIZE AVAILABLE LIST:
//===============================
void initialize_MemBlocksList(uint32 numOfBlocks)
{
  8021f4:	55                   	push   %ebp
  8021f5:	89 e5                	mov    %esp,%ebp
  8021f7:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] initialize_MemBlocksList
	// Write your code here, remove the panic and write your code
	//panic("initialize_MemBlocksList() is not implemented yet...!!");
	uint32 n = numOfBlocks;
  8021fa:	8b 45 08             	mov    0x8(%ebp),%eax
  8021fd:	89 45 f0             	mov    %eax,-0x10(%ebp)

	LIST_INIT(&AvailableMemBlocksList);
  802200:	c7 05 48 41 80 00 00 	movl   $0x0,0x804148
  802207:	00 00 00 
  80220a:	c7 05 4c 41 80 00 00 	movl   $0x0,0x80414c
  802211:	00 00 00 
  802214:	c7 05 54 41 80 00 00 	movl   $0x0,0x804154
  80221b:	00 00 00 
	for(int i = 0; i<n;i++)
  80221e:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  802225:	e9 9e 00 00 00       	jmp    8022c8 <initialize_MemBlocksList+0xd4>
	{
		LIST_INSERT_HEAD(&AvailableMemBlocksList, &(MemBlockNodes[i]));
  80222a:	a1 50 40 80 00       	mov    0x804050,%eax
  80222f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802232:	c1 e2 04             	shl    $0x4,%edx
  802235:	01 d0                	add    %edx,%eax
  802237:	85 c0                	test   %eax,%eax
  802239:	75 14                	jne    80224f <initialize_MemBlocksList+0x5b>
  80223b:	83 ec 04             	sub    $0x4,%esp
  80223e:	68 b4 3c 80 00       	push   $0x803cb4
  802243:	6a 47                	push   $0x47
  802245:	68 d7 3c 80 00       	push   $0x803cd7
  80224a:	e8 4a e2 ff ff       	call   800499 <_panic>
  80224f:	a1 50 40 80 00       	mov    0x804050,%eax
  802254:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802257:	c1 e2 04             	shl    $0x4,%edx
  80225a:	01 d0                	add    %edx,%eax
  80225c:	8b 15 48 41 80 00    	mov    0x804148,%edx
  802262:	89 10                	mov    %edx,(%eax)
  802264:	8b 00                	mov    (%eax),%eax
  802266:	85 c0                	test   %eax,%eax
  802268:	74 18                	je     802282 <initialize_MemBlocksList+0x8e>
  80226a:	a1 48 41 80 00       	mov    0x804148,%eax
  80226f:	8b 15 50 40 80 00    	mov    0x804050,%edx
  802275:	8b 4d f4             	mov    -0xc(%ebp),%ecx
  802278:	c1 e1 04             	shl    $0x4,%ecx
  80227b:	01 ca                	add    %ecx,%edx
  80227d:	89 50 04             	mov    %edx,0x4(%eax)
  802280:	eb 12                	jmp    802294 <initialize_MemBlocksList+0xa0>
  802282:	a1 50 40 80 00       	mov    0x804050,%eax
  802287:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80228a:	c1 e2 04             	shl    $0x4,%edx
  80228d:	01 d0                	add    %edx,%eax
  80228f:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802294:	a1 50 40 80 00       	mov    0x804050,%eax
  802299:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80229c:	c1 e2 04             	shl    $0x4,%edx
  80229f:	01 d0                	add    %edx,%eax
  8022a1:	a3 48 41 80 00       	mov    %eax,0x804148
  8022a6:	a1 50 40 80 00       	mov    0x804050,%eax
  8022ab:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8022ae:	c1 e2 04             	shl    $0x4,%edx
  8022b1:	01 d0                	add    %edx,%eax
  8022b3:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8022ba:	a1 54 41 80 00       	mov    0x804154,%eax
  8022bf:	40                   	inc    %eax
  8022c0:	a3 54 41 80 00       	mov    %eax,0x804154
	// Write your code here, remove the panic and write your code
	//panic("initialize_MemBlocksList() is not implemented yet...!!");
	uint32 n = numOfBlocks;

	LIST_INIT(&AvailableMemBlocksList);
	for(int i = 0; i<n;i++)
  8022c5:	ff 45 f4             	incl   -0xc(%ebp)
  8022c8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022cb:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8022ce:	0f 82 56 ff ff ff    	jb     80222a <initialize_MemBlocksList+0x36>
	{
		LIST_INSERT_HEAD(&AvailableMemBlocksList, &(MemBlockNodes[i]));
	}
}
  8022d4:	90                   	nop
  8022d5:	c9                   	leave  
  8022d6:	c3                   	ret    

008022d7 <find_block>:

//===============================
// [2] FIND BLOCK:
//===============================
struct MemBlock *find_block(struct MemBlock_List *blockList, uint32 va)
{
  8022d7:	55                   	push   %ebp
  8022d8:	89 e5                	mov    %esp,%ebp
  8022da:	83 ec 10             	sub    $0x10,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] find_block
	// Write your code here, remove the panic and write your code
	//panic("find_block() is not implemented yet...!!");
	uint32 virAddress = va;
  8022dd:	8b 45 0c             	mov    0xc(%ebp),%eax
  8022e0:	89 45 f4             	mov    %eax,-0xc(%ebp)
	struct MemBlock* blk;
	int found = 0;
  8022e3:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	LIST_FOREACH(blk, &(AllocMemBlocksList))
  8022ea:	a1 40 40 80 00       	mov    0x804040,%eax
  8022ef:	89 45 fc             	mov    %eax,-0x4(%ebp)
  8022f2:	eb 23                	jmp    802317 <find_block+0x40>
	{
		if(blk->sva == virAddress)
  8022f4:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8022f7:	8b 40 08             	mov    0x8(%eax),%eax
  8022fa:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  8022fd:	75 09                	jne    802308 <find_block+0x31>
		{
			found = 1;
  8022ff:	c7 45 f8 01 00 00 00 	movl   $0x1,-0x8(%ebp)
			break;
  802306:	eb 35                	jmp    80233d <find_block+0x66>
		}
		else
		{
			found = 0;
  802308:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	//panic("find_block() is not implemented yet...!!");
	uint32 virAddress = va;
	struct MemBlock* blk;
	int found = 0;

	LIST_FOREACH(blk, &(AllocMemBlocksList))
  80230f:	a1 48 40 80 00       	mov    0x804048,%eax
  802314:	89 45 fc             	mov    %eax,-0x4(%ebp)
  802317:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  80231b:	74 07                	je     802324 <find_block+0x4d>
  80231d:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802320:	8b 00                	mov    (%eax),%eax
  802322:	eb 05                	jmp    802329 <find_block+0x52>
  802324:	b8 00 00 00 00       	mov    $0x0,%eax
  802329:	a3 48 40 80 00       	mov    %eax,0x804048
  80232e:	a1 48 40 80 00       	mov    0x804048,%eax
  802333:	85 c0                	test   %eax,%eax
  802335:	75 bd                	jne    8022f4 <find_block+0x1d>
  802337:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  80233b:	75 b7                	jne    8022f4 <find_block+0x1d>
		{
			found = 0;
			continue;
		}
	}
	if(found == 1)
  80233d:	83 7d f8 01          	cmpl   $0x1,-0x8(%ebp)
  802341:	75 05                	jne    802348 <find_block+0x71>
	{
		return blk;
  802343:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802346:	eb 05                	jmp    80234d <find_block+0x76>
	}
	else
	{
		return NULL;
  802348:	b8 00 00 00 00       	mov    $0x0,%eax
	}
}
  80234d:	c9                   	leave  
  80234e:	c3                   	ret    

0080234f <insert_sorted_allocList>:

//=========================================
// [3] INSERT BLOCK IN ALLOC LIST [SORTED]:
//=========================================
void insert_sorted_allocList(struct MemBlock *blockToInsert)
{
  80234f:	55                   	push   %ebp
  802350:	89 e5                	mov    %esp,%ebp
  802352:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] insert_sorted_allocList
	// Write your code here, remove the panic and write your code
	//panic("insert_sorted_allocList() is not implemented yet...!!");
	struct MemBlock* blk;
	struct MemBlock* newblk = blockToInsert;
  802355:	8b 45 08             	mov    0x8(%ebp),%eax
  802358:	89 45 f0             	mov    %eax,-0x10(%ebp)

	if((LIST_EMPTY(&AllocMemBlocksList)) || (newblk->sva < LIST_FIRST(&AllocMemBlocksList)->sva))
  80235b:	a1 40 40 80 00       	mov    0x804040,%eax
  802360:	85 c0                	test   %eax,%eax
  802362:	74 12                	je     802376 <insert_sorted_allocList+0x27>
  802364:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802367:	8b 50 08             	mov    0x8(%eax),%edx
  80236a:	a1 40 40 80 00       	mov    0x804040,%eax
  80236f:	8b 40 08             	mov    0x8(%eax),%eax
  802372:	39 c2                	cmp    %eax,%edx
  802374:	73 65                	jae    8023db <insert_sorted_allocList+0x8c>
	{
		LIST_INSERT_HEAD(&(AllocMemBlocksList), newblk);
  802376:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80237a:	75 14                	jne    802390 <insert_sorted_allocList+0x41>
  80237c:	83 ec 04             	sub    $0x4,%esp
  80237f:	68 b4 3c 80 00       	push   $0x803cb4
  802384:	6a 7b                	push   $0x7b
  802386:	68 d7 3c 80 00       	push   $0x803cd7
  80238b:	e8 09 e1 ff ff       	call   800499 <_panic>
  802390:	8b 15 40 40 80 00    	mov    0x804040,%edx
  802396:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802399:	89 10                	mov    %edx,(%eax)
  80239b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80239e:	8b 00                	mov    (%eax),%eax
  8023a0:	85 c0                	test   %eax,%eax
  8023a2:	74 0d                	je     8023b1 <insert_sorted_allocList+0x62>
  8023a4:	a1 40 40 80 00       	mov    0x804040,%eax
  8023a9:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8023ac:	89 50 04             	mov    %edx,0x4(%eax)
  8023af:	eb 08                	jmp    8023b9 <insert_sorted_allocList+0x6a>
  8023b1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8023b4:	a3 44 40 80 00       	mov    %eax,0x804044
  8023b9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8023bc:	a3 40 40 80 00       	mov    %eax,0x804040
  8023c1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8023c4:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8023cb:	a1 4c 40 80 00       	mov    0x80404c,%eax
  8023d0:	40                   	inc    %eax
  8023d1:	a3 4c 40 80 00       	mov    %eax,0x80404c
  8023d6:	e9 5f 01 00 00       	jmp    80253a <insert_sorted_allocList+0x1eb>
	}
	else if(newblk->sva > LIST_LAST(&AllocMemBlocksList)->sva)
  8023db:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8023de:	8b 50 08             	mov    0x8(%eax),%edx
  8023e1:	a1 44 40 80 00       	mov    0x804044,%eax
  8023e6:	8b 40 08             	mov    0x8(%eax),%eax
  8023e9:	39 c2                	cmp    %eax,%edx
  8023eb:	76 65                	jbe    802452 <insert_sorted_allocList+0x103>
	{
		LIST_INSERT_TAIL(&AllocMemBlocksList, newblk);
  8023ed:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8023f1:	75 14                	jne    802407 <insert_sorted_allocList+0xb8>
  8023f3:	83 ec 04             	sub    $0x4,%esp
  8023f6:	68 f0 3c 80 00       	push   $0x803cf0
  8023fb:	6a 7f                	push   $0x7f
  8023fd:	68 d7 3c 80 00       	push   $0x803cd7
  802402:	e8 92 e0 ff ff       	call   800499 <_panic>
  802407:	8b 15 44 40 80 00    	mov    0x804044,%edx
  80240d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802410:	89 50 04             	mov    %edx,0x4(%eax)
  802413:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802416:	8b 40 04             	mov    0x4(%eax),%eax
  802419:	85 c0                	test   %eax,%eax
  80241b:	74 0c                	je     802429 <insert_sorted_allocList+0xda>
  80241d:	a1 44 40 80 00       	mov    0x804044,%eax
  802422:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802425:	89 10                	mov    %edx,(%eax)
  802427:	eb 08                	jmp    802431 <insert_sorted_allocList+0xe2>
  802429:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80242c:	a3 40 40 80 00       	mov    %eax,0x804040
  802431:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802434:	a3 44 40 80 00       	mov    %eax,0x804044
  802439:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80243c:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802442:	a1 4c 40 80 00       	mov    0x80404c,%eax
  802447:	40                   	inc    %eax
  802448:	a3 4c 40 80 00       	mov    %eax,0x80404c
				LIST_INSERT_AFTER(&AllocMemBlocksList, blk, newblk);
				break;
			}
		}
	}
}
  80244d:	e9 e8 00 00 00       	jmp    80253a <insert_sorted_allocList+0x1eb>
	{
		LIST_INSERT_TAIL(&AllocMemBlocksList, newblk);
	}
	else
	{
		LIST_FOREACH(blk, &AllocMemBlocksList)
  802452:	a1 40 40 80 00       	mov    0x804040,%eax
  802457:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80245a:	e9 ab 00 00 00       	jmp    80250a <insert_sorted_allocList+0x1bb>
		{
			if(blk->prev_next_info.le_next != NULL && newblk->sva > blk->sva  && newblk->sva < blk->prev_next_info.le_next->sva)
  80245f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802462:	8b 00                	mov    (%eax),%eax
  802464:	85 c0                	test   %eax,%eax
  802466:	0f 84 96 00 00 00    	je     802502 <insert_sorted_allocList+0x1b3>
  80246c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80246f:	8b 50 08             	mov    0x8(%eax),%edx
  802472:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802475:	8b 40 08             	mov    0x8(%eax),%eax
  802478:	39 c2                	cmp    %eax,%edx
  80247a:	0f 86 82 00 00 00    	jbe    802502 <insert_sorted_allocList+0x1b3>
  802480:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802483:	8b 50 08             	mov    0x8(%eax),%edx
  802486:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802489:	8b 00                	mov    (%eax),%eax
  80248b:	8b 40 08             	mov    0x8(%eax),%eax
  80248e:	39 c2                	cmp    %eax,%edx
  802490:	73 70                	jae    802502 <insert_sorted_allocList+0x1b3>
			{
				LIST_INSERT_AFTER(&AllocMemBlocksList, blk, newblk);
  802492:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802496:	74 06                	je     80249e <insert_sorted_allocList+0x14f>
  802498:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80249c:	75 17                	jne    8024b5 <insert_sorted_allocList+0x166>
  80249e:	83 ec 04             	sub    $0x4,%esp
  8024a1:	68 14 3d 80 00       	push   $0x803d14
  8024a6:	68 87 00 00 00       	push   $0x87
  8024ab:	68 d7 3c 80 00       	push   $0x803cd7
  8024b0:	e8 e4 df ff ff       	call   800499 <_panic>
  8024b5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024b8:	8b 10                	mov    (%eax),%edx
  8024ba:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8024bd:	89 10                	mov    %edx,(%eax)
  8024bf:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8024c2:	8b 00                	mov    (%eax),%eax
  8024c4:	85 c0                	test   %eax,%eax
  8024c6:	74 0b                	je     8024d3 <insert_sorted_allocList+0x184>
  8024c8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024cb:	8b 00                	mov    (%eax),%eax
  8024cd:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8024d0:	89 50 04             	mov    %edx,0x4(%eax)
  8024d3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024d6:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8024d9:	89 10                	mov    %edx,(%eax)
  8024db:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8024de:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8024e1:	89 50 04             	mov    %edx,0x4(%eax)
  8024e4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8024e7:	8b 00                	mov    (%eax),%eax
  8024e9:	85 c0                	test   %eax,%eax
  8024eb:	75 08                	jne    8024f5 <insert_sorted_allocList+0x1a6>
  8024ed:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8024f0:	a3 44 40 80 00       	mov    %eax,0x804044
  8024f5:	a1 4c 40 80 00       	mov    0x80404c,%eax
  8024fa:	40                   	inc    %eax
  8024fb:	a3 4c 40 80 00       	mov    %eax,0x80404c
				break;
  802500:	eb 38                	jmp    80253a <insert_sorted_allocList+0x1eb>
	{
		LIST_INSERT_TAIL(&AllocMemBlocksList, newblk);
	}
	else
	{
		LIST_FOREACH(blk, &AllocMemBlocksList)
  802502:	a1 48 40 80 00       	mov    0x804048,%eax
  802507:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80250a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80250e:	74 07                	je     802517 <insert_sorted_allocList+0x1c8>
  802510:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802513:	8b 00                	mov    (%eax),%eax
  802515:	eb 05                	jmp    80251c <insert_sorted_allocList+0x1cd>
  802517:	b8 00 00 00 00       	mov    $0x0,%eax
  80251c:	a3 48 40 80 00       	mov    %eax,0x804048
  802521:	a1 48 40 80 00       	mov    0x804048,%eax
  802526:	85 c0                	test   %eax,%eax
  802528:	0f 85 31 ff ff ff    	jne    80245f <insert_sorted_allocList+0x110>
  80252e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802532:	0f 85 27 ff ff ff    	jne    80245f <insert_sorted_allocList+0x110>
				LIST_INSERT_AFTER(&AllocMemBlocksList, blk, newblk);
				break;
			}
		}
	}
}
  802538:	eb 00                	jmp    80253a <insert_sorted_allocList+0x1eb>
  80253a:	90                   	nop
  80253b:	c9                   	leave  
  80253c:	c3                   	ret    

0080253d <alloc_block_FF>:

//=========================================
// [4] ALLOCATE BLOCK BY FIRST FIT:
//=========================================
struct MemBlock *alloc_block_FF(uint32 size)
{
  80253d:	55                   	push   %ebp
  80253e:	89 e5                	mov    %esp,%ebp
  802540:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_FF
	// Write your code here, remove the panic and write your code
	//panic("alloc_block_FF() is not implemented yet...!!");
	uint32 versize = size;
  802543:	8b 45 08             	mov    0x8(%ebp),%eax
  802546:	89 45 f0             	mov    %eax,-0x10(%ebp)
	struct MemBlock* blk;
	struct MemBlock* newblk = LIST_FIRST(&AvailableMemBlocksList);
  802549:	a1 48 41 80 00       	mov    0x804148,%eax
  80254e:	89 45 ec             	mov    %eax,-0x14(%ebp)

	LIST_FOREACH(blk,&FreeMemBlocksList)
  802551:	a1 38 41 80 00       	mov    0x804138,%eax
  802556:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802559:	e9 77 01 00 00       	jmp    8026d5 <alloc_block_FF+0x198>
	{
		if(blk->size == versize)
  80255e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802561:	8b 40 0c             	mov    0xc(%eax),%eax
  802564:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  802567:	0f 85 8a 00 00 00    	jne    8025f7 <alloc_block_FF+0xba>
		{
			LIST_REMOVE(&FreeMemBlocksList,blk);
  80256d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802571:	75 17                	jne    80258a <alloc_block_FF+0x4d>
  802573:	83 ec 04             	sub    $0x4,%esp
  802576:	68 48 3d 80 00       	push   $0x803d48
  80257b:	68 9e 00 00 00       	push   $0x9e
  802580:	68 d7 3c 80 00       	push   $0x803cd7
  802585:	e8 0f df ff ff       	call   800499 <_panic>
  80258a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80258d:	8b 00                	mov    (%eax),%eax
  80258f:	85 c0                	test   %eax,%eax
  802591:	74 10                	je     8025a3 <alloc_block_FF+0x66>
  802593:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802596:	8b 00                	mov    (%eax),%eax
  802598:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80259b:	8b 52 04             	mov    0x4(%edx),%edx
  80259e:	89 50 04             	mov    %edx,0x4(%eax)
  8025a1:	eb 0b                	jmp    8025ae <alloc_block_FF+0x71>
  8025a3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025a6:	8b 40 04             	mov    0x4(%eax),%eax
  8025a9:	a3 3c 41 80 00       	mov    %eax,0x80413c
  8025ae:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025b1:	8b 40 04             	mov    0x4(%eax),%eax
  8025b4:	85 c0                	test   %eax,%eax
  8025b6:	74 0f                	je     8025c7 <alloc_block_FF+0x8a>
  8025b8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025bb:	8b 40 04             	mov    0x4(%eax),%eax
  8025be:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8025c1:	8b 12                	mov    (%edx),%edx
  8025c3:	89 10                	mov    %edx,(%eax)
  8025c5:	eb 0a                	jmp    8025d1 <alloc_block_FF+0x94>
  8025c7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025ca:	8b 00                	mov    (%eax),%eax
  8025cc:	a3 38 41 80 00       	mov    %eax,0x804138
  8025d1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025d4:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8025da:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025dd:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8025e4:	a1 44 41 80 00       	mov    0x804144,%eax
  8025e9:	48                   	dec    %eax
  8025ea:	a3 44 41 80 00       	mov    %eax,0x804144
			return blk;
  8025ef:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025f2:	e9 11 01 00 00       	jmp    802708 <alloc_block_FF+0x1cb>
		}
		else if(blk->size > versize)
  8025f7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025fa:	8b 40 0c             	mov    0xc(%eax),%eax
  8025fd:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  802600:	0f 86 c7 00 00 00    	jbe    8026cd <alloc_block_FF+0x190>
		{
			LIST_REMOVE(&AvailableMemBlocksList,newblk);
  802606:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  80260a:	75 17                	jne    802623 <alloc_block_FF+0xe6>
  80260c:	83 ec 04             	sub    $0x4,%esp
  80260f:	68 48 3d 80 00       	push   $0x803d48
  802614:	68 a3 00 00 00       	push   $0xa3
  802619:	68 d7 3c 80 00       	push   $0x803cd7
  80261e:	e8 76 de ff ff       	call   800499 <_panic>
  802623:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802626:	8b 00                	mov    (%eax),%eax
  802628:	85 c0                	test   %eax,%eax
  80262a:	74 10                	je     80263c <alloc_block_FF+0xff>
  80262c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80262f:	8b 00                	mov    (%eax),%eax
  802631:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802634:	8b 52 04             	mov    0x4(%edx),%edx
  802637:	89 50 04             	mov    %edx,0x4(%eax)
  80263a:	eb 0b                	jmp    802647 <alloc_block_FF+0x10a>
  80263c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80263f:	8b 40 04             	mov    0x4(%eax),%eax
  802642:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802647:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80264a:	8b 40 04             	mov    0x4(%eax),%eax
  80264d:	85 c0                	test   %eax,%eax
  80264f:	74 0f                	je     802660 <alloc_block_FF+0x123>
  802651:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802654:	8b 40 04             	mov    0x4(%eax),%eax
  802657:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80265a:	8b 12                	mov    (%edx),%edx
  80265c:	89 10                	mov    %edx,(%eax)
  80265e:	eb 0a                	jmp    80266a <alloc_block_FF+0x12d>
  802660:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802663:	8b 00                	mov    (%eax),%eax
  802665:	a3 48 41 80 00       	mov    %eax,0x804148
  80266a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80266d:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802673:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802676:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80267d:	a1 54 41 80 00       	mov    0x804154,%eax
  802682:	48                   	dec    %eax
  802683:	a3 54 41 80 00       	mov    %eax,0x804154
			newblk->size = versize;
  802688:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80268b:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80268e:	89 50 0c             	mov    %edx,0xc(%eax)
			blk->size = blk->size-versize;
  802691:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802694:	8b 40 0c             	mov    0xc(%eax),%eax
  802697:	2b 45 f0             	sub    -0x10(%ebp),%eax
  80269a:	89 c2                	mov    %eax,%edx
  80269c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80269f:	89 50 0c             	mov    %edx,0xc(%eax)
			uint32 newveradd = blk->sva;
  8026a2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026a5:	8b 40 08             	mov    0x8(%eax),%eax
  8026a8:	89 45 e8             	mov    %eax,-0x18(%ebp)
			blk->sva+=newblk->size;
  8026ab:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026ae:	8b 50 08             	mov    0x8(%eax),%edx
  8026b1:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8026b4:	8b 40 0c             	mov    0xc(%eax),%eax
  8026b7:	01 c2                	add    %eax,%edx
  8026b9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026bc:	89 50 08             	mov    %edx,0x8(%eax)
			newblk->sva = newveradd;
  8026bf:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8026c2:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8026c5:	89 50 08             	mov    %edx,0x8(%eax)
			return newblk;
  8026c8:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8026cb:	eb 3b                	jmp    802708 <alloc_block_FF+0x1cb>
	//panic("alloc_block_FF() is not implemented yet...!!");
	uint32 versize = size;
	struct MemBlock* blk;
	struct MemBlock* newblk = LIST_FIRST(&AvailableMemBlocksList);

	LIST_FOREACH(blk,&FreeMemBlocksList)
  8026cd:	a1 40 41 80 00       	mov    0x804140,%eax
  8026d2:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8026d5:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8026d9:	74 07                	je     8026e2 <alloc_block_FF+0x1a5>
  8026db:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026de:	8b 00                	mov    (%eax),%eax
  8026e0:	eb 05                	jmp    8026e7 <alloc_block_FF+0x1aa>
  8026e2:	b8 00 00 00 00       	mov    $0x0,%eax
  8026e7:	a3 40 41 80 00       	mov    %eax,0x804140
  8026ec:	a1 40 41 80 00       	mov    0x804140,%eax
  8026f1:	85 c0                	test   %eax,%eax
  8026f3:	0f 85 65 fe ff ff    	jne    80255e <alloc_block_FF+0x21>
  8026f9:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8026fd:	0f 85 5b fe ff ff    	jne    80255e <alloc_block_FF+0x21>
			blk->sva+=newblk->size;
			newblk->sva = newveradd;
			return newblk;
		}
	}
	return NULL;
  802703:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802708:	c9                   	leave  
  802709:	c3                   	ret    

0080270a <alloc_block_BF>:

//=========================================
// [5] ALLOCATE BLOCK BY BEST FIT:
//=========================================
struct MemBlock *alloc_block_BF(uint32 size)
{
  80270a:	55                   	push   %ebp
  80270b:	89 e5                	mov    %esp,%ebp
  80270d:	83 ec 28             	sub    $0x28,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_BF
	// Write your code here, remove the panic and write your code
	//panic("alloc_block_BF() is not implemented yet...!!");
	uint32 versize=size;
  802710:	8b 45 08             	mov    0x8(%ebp),%eax
  802713:	89 45 e8             	mov    %eax,-0x18(%ebp)
	struct MemBlock* blk;
	struct MemBlock* newblk=LIST_FIRST(&AvailableMemBlocksList);
  802716:	a1 48 41 80 00       	mov    0x804148,%eax
  80271b:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	uint32 newveradd;
	uint32 newsize;
	int size_free = LIST_SIZE(&FreeMemBlocksList);
  80271e:	a1 44 41 80 00       	mov    0x804144,%eax
  802723:	89 45 e0             	mov    %eax,-0x20(%ebp)

	LIST_FOREACH(blk, &FreeMemBlocksList)
  802726:	a1 38 41 80 00       	mov    0x804138,%eax
  80272b:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80272e:	e9 a1 00 00 00       	jmp    8027d4 <alloc_block_BF+0xca>
	{
		if(blk->size == versize)
  802733:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802736:	8b 40 0c             	mov    0xc(%eax),%eax
  802739:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  80273c:	0f 85 8a 00 00 00    	jne    8027cc <alloc_block_BF+0xc2>
		{
			LIST_REMOVE(&FreeMemBlocksList, blk);
  802742:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802746:	75 17                	jne    80275f <alloc_block_BF+0x55>
  802748:	83 ec 04             	sub    $0x4,%esp
  80274b:	68 48 3d 80 00       	push   $0x803d48
  802750:	68 c2 00 00 00       	push   $0xc2
  802755:	68 d7 3c 80 00       	push   $0x803cd7
  80275a:	e8 3a dd ff ff       	call   800499 <_panic>
  80275f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802762:	8b 00                	mov    (%eax),%eax
  802764:	85 c0                	test   %eax,%eax
  802766:	74 10                	je     802778 <alloc_block_BF+0x6e>
  802768:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80276b:	8b 00                	mov    (%eax),%eax
  80276d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802770:	8b 52 04             	mov    0x4(%edx),%edx
  802773:	89 50 04             	mov    %edx,0x4(%eax)
  802776:	eb 0b                	jmp    802783 <alloc_block_BF+0x79>
  802778:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80277b:	8b 40 04             	mov    0x4(%eax),%eax
  80277e:	a3 3c 41 80 00       	mov    %eax,0x80413c
  802783:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802786:	8b 40 04             	mov    0x4(%eax),%eax
  802789:	85 c0                	test   %eax,%eax
  80278b:	74 0f                	je     80279c <alloc_block_BF+0x92>
  80278d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802790:	8b 40 04             	mov    0x4(%eax),%eax
  802793:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802796:	8b 12                	mov    (%edx),%edx
  802798:	89 10                	mov    %edx,(%eax)
  80279a:	eb 0a                	jmp    8027a6 <alloc_block_BF+0x9c>
  80279c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80279f:	8b 00                	mov    (%eax),%eax
  8027a1:	a3 38 41 80 00       	mov    %eax,0x804138
  8027a6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027a9:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8027af:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027b2:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8027b9:	a1 44 41 80 00       	mov    0x804144,%eax
  8027be:	48                   	dec    %eax
  8027bf:	a3 44 41 80 00       	mov    %eax,0x804144
			return blk;
  8027c4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027c7:	e9 11 02 00 00       	jmp    8029dd <alloc_block_BF+0x2d3>
	struct MemBlock* newblk=LIST_FIRST(&AvailableMemBlocksList);
	uint32 newveradd;
	uint32 newsize;
	int size_free = LIST_SIZE(&FreeMemBlocksList);

	LIST_FOREACH(blk, &FreeMemBlocksList)
  8027cc:	a1 40 41 80 00       	mov    0x804140,%eax
  8027d1:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8027d4:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8027d8:	74 07                	je     8027e1 <alloc_block_BF+0xd7>
  8027da:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027dd:	8b 00                	mov    (%eax),%eax
  8027df:	eb 05                	jmp    8027e6 <alloc_block_BF+0xdc>
  8027e1:	b8 00 00 00 00       	mov    $0x0,%eax
  8027e6:	a3 40 41 80 00       	mov    %eax,0x804140
  8027eb:	a1 40 41 80 00       	mov    0x804140,%eax
  8027f0:	85 c0                	test   %eax,%eax
  8027f2:	0f 85 3b ff ff ff    	jne    802733 <alloc_block_BF+0x29>
  8027f8:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8027fc:	0f 85 31 ff ff ff    	jne    802733 <alloc_block_BF+0x29>
		{
			LIST_REMOVE(&FreeMemBlocksList, blk);
			return blk;
		}
	}
	LIST_FOREACH(blk, &FreeMemBlocksList)
  802802:	a1 38 41 80 00       	mov    0x804138,%eax
  802807:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80280a:	eb 27                	jmp    802833 <alloc_block_BF+0x129>
	{
		if(blk->size > versize)
  80280c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80280f:	8b 40 0c             	mov    0xc(%eax),%eax
  802812:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  802815:	76 14                	jbe    80282b <alloc_block_BF+0x121>
		{
			newsize = blk->size;
  802817:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80281a:	8b 40 0c             	mov    0xc(%eax),%eax
  80281d:	89 45 ec             	mov    %eax,-0x14(%ebp)
			newveradd = blk->sva;
  802820:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802823:	8b 40 08             	mov    0x8(%eax),%eax
  802826:	89 45 f0             	mov    %eax,-0x10(%ebp)
			break;
  802829:	eb 2e                	jmp    802859 <alloc_block_BF+0x14f>
		{
			LIST_REMOVE(&FreeMemBlocksList, blk);
			return blk;
		}
	}
	LIST_FOREACH(blk, &FreeMemBlocksList)
  80282b:	a1 40 41 80 00       	mov    0x804140,%eax
  802830:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802833:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802837:	74 07                	je     802840 <alloc_block_BF+0x136>
  802839:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80283c:	8b 00                	mov    (%eax),%eax
  80283e:	eb 05                	jmp    802845 <alloc_block_BF+0x13b>
  802840:	b8 00 00 00 00       	mov    $0x0,%eax
  802845:	a3 40 41 80 00       	mov    %eax,0x804140
  80284a:	a1 40 41 80 00       	mov    0x804140,%eax
  80284f:	85 c0                	test   %eax,%eax
  802851:	75 b9                	jne    80280c <alloc_block_BF+0x102>
  802853:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802857:	75 b3                	jne    80280c <alloc_block_BF+0x102>
			newsize = blk->size;
			newveradd = blk->sva;
			break;
		}
	}
	LIST_FOREACH(blk, &FreeMemBlocksList)
  802859:	a1 38 41 80 00       	mov    0x804138,%eax
  80285e:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802861:	eb 30                	jmp    802893 <alloc_block_BF+0x189>
	{
		if(newsize > blk->size && blk->size > versize)
  802863:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802866:	8b 40 0c             	mov    0xc(%eax),%eax
  802869:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  80286c:	73 1d                	jae    80288b <alloc_block_BF+0x181>
  80286e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802871:	8b 40 0c             	mov    0xc(%eax),%eax
  802874:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  802877:	76 12                	jbe    80288b <alloc_block_BF+0x181>
		{
	       newsize = blk->size;
  802879:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80287c:	8b 40 0c             	mov    0xc(%eax),%eax
  80287f:	89 45 ec             	mov    %eax,-0x14(%ebp)
		   newveradd = blk->sva;
  802882:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802885:	8b 40 08             	mov    0x8(%eax),%eax
  802888:	89 45 f0             	mov    %eax,-0x10(%ebp)
			newsize = blk->size;
			newveradd = blk->sva;
			break;
		}
	}
	LIST_FOREACH(blk, &FreeMemBlocksList)
  80288b:	a1 40 41 80 00       	mov    0x804140,%eax
  802890:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802893:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802897:	74 07                	je     8028a0 <alloc_block_BF+0x196>
  802899:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80289c:	8b 00                	mov    (%eax),%eax
  80289e:	eb 05                	jmp    8028a5 <alloc_block_BF+0x19b>
  8028a0:	b8 00 00 00 00       	mov    $0x0,%eax
  8028a5:	a3 40 41 80 00       	mov    %eax,0x804140
  8028aa:	a1 40 41 80 00       	mov    0x804140,%eax
  8028af:	85 c0                	test   %eax,%eax
  8028b1:	75 b0                	jne    802863 <alloc_block_BF+0x159>
  8028b3:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8028b7:	75 aa                	jne    802863 <alloc_block_BF+0x159>
		{
	       newsize = blk->size;
		   newveradd = blk->sva;
		}
	}
	LIST_FOREACH(blk, &FreeMemBlocksList)
  8028b9:	a1 38 41 80 00       	mov    0x804138,%eax
  8028be:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8028c1:	e9 e4 00 00 00       	jmp    8029aa <alloc_block_BF+0x2a0>
	{
		if(blk->size == newsize && blk->sva == newveradd)
  8028c6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028c9:	8b 40 0c             	mov    0xc(%eax),%eax
  8028cc:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  8028cf:	0f 85 cd 00 00 00    	jne    8029a2 <alloc_block_BF+0x298>
  8028d5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028d8:	8b 40 08             	mov    0x8(%eax),%eax
  8028db:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8028de:	0f 85 be 00 00 00    	jne    8029a2 <alloc_block_BF+0x298>
		{
			LIST_REMOVE(&AvailableMemBlocksList, newblk);
  8028e4:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8028e8:	75 17                	jne    802901 <alloc_block_BF+0x1f7>
  8028ea:	83 ec 04             	sub    $0x4,%esp
  8028ed:	68 48 3d 80 00       	push   $0x803d48
  8028f2:	68 db 00 00 00       	push   $0xdb
  8028f7:	68 d7 3c 80 00       	push   $0x803cd7
  8028fc:	e8 98 db ff ff       	call   800499 <_panic>
  802901:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802904:	8b 00                	mov    (%eax),%eax
  802906:	85 c0                	test   %eax,%eax
  802908:	74 10                	je     80291a <alloc_block_BF+0x210>
  80290a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80290d:	8b 00                	mov    (%eax),%eax
  80290f:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802912:	8b 52 04             	mov    0x4(%edx),%edx
  802915:	89 50 04             	mov    %edx,0x4(%eax)
  802918:	eb 0b                	jmp    802925 <alloc_block_BF+0x21b>
  80291a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80291d:	8b 40 04             	mov    0x4(%eax),%eax
  802920:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802925:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802928:	8b 40 04             	mov    0x4(%eax),%eax
  80292b:	85 c0                	test   %eax,%eax
  80292d:	74 0f                	je     80293e <alloc_block_BF+0x234>
  80292f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802932:	8b 40 04             	mov    0x4(%eax),%eax
  802935:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802938:	8b 12                	mov    (%edx),%edx
  80293a:	89 10                	mov    %edx,(%eax)
  80293c:	eb 0a                	jmp    802948 <alloc_block_BF+0x23e>
  80293e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802941:	8b 00                	mov    (%eax),%eax
  802943:	a3 48 41 80 00       	mov    %eax,0x804148
  802948:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80294b:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802951:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802954:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80295b:	a1 54 41 80 00       	mov    0x804154,%eax
  802960:	48                   	dec    %eax
  802961:	a3 54 41 80 00       	mov    %eax,0x804154
			newblk->size = versize;
  802966:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802969:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80296c:	89 50 0c             	mov    %edx,0xc(%eax)
			newblk->sva = newveradd;
  80296f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802972:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802975:	89 50 08             	mov    %edx,0x8(%eax)
			blk->size = blk->size - versize;
  802978:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80297b:	8b 40 0c             	mov    0xc(%eax),%eax
  80297e:	2b 45 e8             	sub    -0x18(%ebp),%eax
  802981:	89 c2                	mov    %eax,%edx
  802983:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802986:	89 50 0c             	mov    %edx,0xc(%eax)
			blk->sva+= newblk->size;
  802989:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80298c:	8b 50 08             	mov    0x8(%eax),%edx
  80298f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802992:	8b 40 0c             	mov    0xc(%eax),%eax
  802995:	01 c2                	add    %eax,%edx
  802997:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80299a:	89 50 08             	mov    %edx,0x8(%eax)
			return newblk;
  80299d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8029a0:	eb 3b                	jmp    8029dd <alloc_block_BF+0x2d3>
		{
	       newsize = blk->size;
		   newveradd = blk->sva;
		}
	}
	LIST_FOREACH(blk, &FreeMemBlocksList)
  8029a2:	a1 40 41 80 00       	mov    0x804140,%eax
  8029a7:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8029aa:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8029ae:	74 07                	je     8029b7 <alloc_block_BF+0x2ad>
  8029b0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029b3:	8b 00                	mov    (%eax),%eax
  8029b5:	eb 05                	jmp    8029bc <alloc_block_BF+0x2b2>
  8029b7:	b8 00 00 00 00       	mov    $0x0,%eax
  8029bc:	a3 40 41 80 00       	mov    %eax,0x804140
  8029c1:	a1 40 41 80 00       	mov    0x804140,%eax
  8029c6:	85 c0                	test   %eax,%eax
  8029c8:	0f 85 f8 fe ff ff    	jne    8028c6 <alloc_block_BF+0x1bc>
  8029ce:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8029d2:	0f 85 ee fe ff ff    	jne    8028c6 <alloc_block_BF+0x1bc>
			blk->size = blk->size - versize;
			blk->sva+= newblk->size;
			return newblk;
		}
	}
	return NULL;
  8029d8:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8029dd:	c9                   	leave  
  8029de:	c3                   	ret    

008029df <alloc_block_NF>:
//=========================================
// [7] ALLOCATE BLOCK BY NEXT FIT:
//=========================================
struct MemBlock *last_allocate;
struct MemBlock *alloc_block_NF(uint32 size)
{
  8029df:	55                   	push   %ebp
  8029e0:	89 e5                	mov    %esp,%ebp
  8029e2:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1 - BONUS] [DYNAMIC ALLOCATOR] alloc_block_NF
	// Write your code here, remove the panic and write your code
	//panic("alloc_block_NF() is not implemented yet...!!");
	uint32 versize = size;
  8029e5:	8b 45 08             	mov    0x8(%ebp),%eax
  8029e8:	89 45 f0             	mov    %eax,-0x10(%ebp)
	struct MemBlock* blk;
	struct MemBlock* newblk = LIST_FIRST(&AvailableMemBlocksList);
  8029eb:	a1 48 41 80 00       	mov    0x804148,%eax
  8029f0:	89 45 ec             	mov    %eax,-0x14(%ebp)

	LIST_FOREACH(blk,&FreeMemBlocksList)
  8029f3:	a1 38 41 80 00       	mov    0x804138,%eax
  8029f8:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8029fb:	e9 77 01 00 00       	jmp    802b77 <alloc_block_NF+0x198>
	{
		if(blk->size == versize)
  802a00:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a03:	8b 40 0c             	mov    0xc(%eax),%eax
  802a06:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  802a09:	0f 85 8a 00 00 00    	jne    802a99 <alloc_block_NF+0xba>
		{
			LIST_REMOVE(&FreeMemBlocksList,blk);
  802a0f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802a13:	75 17                	jne    802a2c <alloc_block_NF+0x4d>
  802a15:	83 ec 04             	sub    $0x4,%esp
  802a18:	68 48 3d 80 00       	push   $0x803d48
  802a1d:	68 f7 00 00 00       	push   $0xf7
  802a22:	68 d7 3c 80 00       	push   $0x803cd7
  802a27:	e8 6d da ff ff       	call   800499 <_panic>
  802a2c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a2f:	8b 00                	mov    (%eax),%eax
  802a31:	85 c0                	test   %eax,%eax
  802a33:	74 10                	je     802a45 <alloc_block_NF+0x66>
  802a35:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a38:	8b 00                	mov    (%eax),%eax
  802a3a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802a3d:	8b 52 04             	mov    0x4(%edx),%edx
  802a40:	89 50 04             	mov    %edx,0x4(%eax)
  802a43:	eb 0b                	jmp    802a50 <alloc_block_NF+0x71>
  802a45:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a48:	8b 40 04             	mov    0x4(%eax),%eax
  802a4b:	a3 3c 41 80 00       	mov    %eax,0x80413c
  802a50:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a53:	8b 40 04             	mov    0x4(%eax),%eax
  802a56:	85 c0                	test   %eax,%eax
  802a58:	74 0f                	je     802a69 <alloc_block_NF+0x8a>
  802a5a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a5d:	8b 40 04             	mov    0x4(%eax),%eax
  802a60:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802a63:	8b 12                	mov    (%edx),%edx
  802a65:	89 10                	mov    %edx,(%eax)
  802a67:	eb 0a                	jmp    802a73 <alloc_block_NF+0x94>
  802a69:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a6c:	8b 00                	mov    (%eax),%eax
  802a6e:	a3 38 41 80 00       	mov    %eax,0x804138
  802a73:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a76:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802a7c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a7f:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802a86:	a1 44 41 80 00       	mov    0x804144,%eax
  802a8b:	48                   	dec    %eax
  802a8c:	a3 44 41 80 00       	mov    %eax,0x804144
			return blk;
  802a91:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a94:	e9 11 01 00 00       	jmp    802baa <alloc_block_NF+0x1cb>
		}
		else if(blk->size > versize)
  802a99:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a9c:	8b 40 0c             	mov    0xc(%eax),%eax
  802a9f:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  802aa2:	0f 86 c7 00 00 00    	jbe    802b6f <alloc_block_NF+0x190>
		{
			LIST_REMOVE(&AvailableMemBlocksList,newblk);
  802aa8:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802aac:	75 17                	jne    802ac5 <alloc_block_NF+0xe6>
  802aae:	83 ec 04             	sub    $0x4,%esp
  802ab1:	68 48 3d 80 00       	push   $0x803d48
  802ab6:	68 fc 00 00 00       	push   $0xfc
  802abb:	68 d7 3c 80 00       	push   $0x803cd7
  802ac0:	e8 d4 d9 ff ff       	call   800499 <_panic>
  802ac5:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802ac8:	8b 00                	mov    (%eax),%eax
  802aca:	85 c0                	test   %eax,%eax
  802acc:	74 10                	je     802ade <alloc_block_NF+0xff>
  802ace:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802ad1:	8b 00                	mov    (%eax),%eax
  802ad3:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802ad6:	8b 52 04             	mov    0x4(%edx),%edx
  802ad9:	89 50 04             	mov    %edx,0x4(%eax)
  802adc:	eb 0b                	jmp    802ae9 <alloc_block_NF+0x10a>
  802ade:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802ae1:	8b 40 04             	mov    0x4(%eax),%eax
  802ae4:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802ae9:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802aec:	8b 40 04             	mov    0x4(%eax),%eax
  802aef:	85 c0                	test   %eax,%eax
  802af1:	74 0f                	je     802b02 <alloc_block_NF+0x123>
  802af3:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802af6:	8b 40 04             	mov    0x4(%eax),%eax
  802af9:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802afc:	8b 12                	mov    (%edx),%edx
  802afe:	89 10                	mov    %edx,(%eax)
  802b00:	eb 0a                	jmp    802b0c <alloc_block_NF+0x12d>
  802b02:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802b05:	8b 00                	mov    (%eax),%eax
  802b07:	a3 48 41 80 00       	mov    %eax,0x804148
  802b0c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802b0f:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802b15:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802b18:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802b1f:	a1 54 41 80 00       	mov    0x804154,%eax
  802b24:	48                   	dec    %eax
  802b25:	a3 54 41 80 00       	mov    %eax,0x804154
			newblk->size = versize;
  802b2a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802b2d:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802b30:	89 50 0c             	mov    %edx,0xc(%eax)
			blk->size = blk->size-versize;
  802b33:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b36:	8b 40 0c             	mov    0xc(%eax),%eax
  802b39:	2b 45 f0             	sub    -0x10(%ebp),%eax
  802b3c:	89 c2                	mov    %eax,%edx
  802b3e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b41:	89 50 0c             	mov    %edx,0xc(%eax)
			uint32 newveradd = blk->sva;
  802b44:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b47:	8b 40 08             	mov    0x8(%eax),%eax
  802b4a:	89 45 e8             	mov    %eax,-0x18(%ebp)
			blk->sva+=newblk->size;
  802b4d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b50:	8b 50 08             	mov    0x8(%eax),%edx
  802b53:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802b56:	8b 40 0c             	mov    0xc(%eax),%eax
  802b59:	01 c2                	add    %eax,%edx
  802b5b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b5e:	89 50 08             	mov    %edx,0x8(%eax)
			newblk->sva = newveradd;
  802b61:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802b64:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802b67:	89 50 08             	mov    %edx,0x8(%eax)
			return newblk;
  802b6a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802b6d:	eb 3b                	jmp    802baa <alloc_block_NF+0x1cb>
	//panic("alloc_block_NF() is not implemented yet...!!");
	uint32 versize = size;
	struct MemBlock* blk;
	struct MemBlock* newblk = LIST_FIRST(&AvailableMemBlocksList);

	LIST_FOREACH(blk,&FreeMemBlocksList)
  802b6f:	a1 40 41 80 00       	mov    0x804140,%eax
  802b74:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802b77:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802b7b:	74 07                	je     802b84 <alloc_block_NF+0x1a5>
  802b7d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b80:	8b 00                	mov    (%eax),%eax
  802b82:	eb 05                	jmp    802b89 <alloc_block_NF+0x1aa>
  802b84:	b8 00 00 00 00       	mov    $0x0,%eax
  802b89:	a3 40 41 80 00       	mov    %eax,0x804140
  802b8e:	a1 40 41 80 00       	mov    0x804140,%eax
  802b93:	85 c0                	test   %eax,%eax
  802b95:	0f 85 65 fe ff ff    	jne    802a00 <alloc_block_NF+0x21>
  802b9b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802b9f:	0f 85 5b fe ff ff    	jne    802a00 <alloc_block_NF+0x21>
			blk->sva+=newblk->size;
			newblk->sva = newveradd;
			return newblk;
		}
	}
	return NULL;
  802ba5:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802baa:	c9                   	leave  
  802bab:	c3                   	ret    

00802bac <addToAvailMemBlocksList>:

//===================================================
// [8] INSERT BLOCK (SORTED WITH MERGE) IN FREE LIST:
//===================================================
void addToAvailMemBlocksList(struct MemBlock *blockToInsert)
{
  802bac:	55                   	push   %ebp
  802bad:	89 e5                	mov    %esp,%ebp
  802baf:	83 ec 08             	sub    $0x8,%esp
	blockToInsert->sva = 0;
  802bb2:	8b 45 08             	mov    0x8(%ebp),%eax
  802bb5:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
	blockToInsert->size = 0;
  802bbc:	8b 45 08             	mov    0x8(%ebp),%eax
  802bbf:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
	//add to avail
	LIST_INSERT_TAIL(&AvailableMemBlocksList, blockToInsert);
  802bc6:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802bca:	75 17                	jne    802be3 <addToAvailMemBlocksList+0x37>
  802bcc:	83 ec 04             	sub    $0x4,%esp
  802bcf:	68 f0 3c 80 00       	push   $0x803cf0
  802bd4:	68 10 01 00 00       	push   $0x110
  802bd9:	68 d7 3c 80 00       	push   $0x803cd7
  802bde:	e8 b6 d8 ff ff       	call   800499 <_panic>
  802be3:	8b 15 4c 41 80 00    	mov    0x80414c,%edx
  802be9:	8b 45 08             	mov    0x8(%ebp),%eax
  802bec:	89 50 04             	mov    %edx,0x4(%eax)
  802bef:	8b 45 08             	mov    0x8(%ebp),%eax
  802bf2:	8b 40 04             	mov    0x4(%eax),%eax
  802bf5:	85 c0                	test   %eax,%eax
  802bf7:	74 0c                	je     802c05 <addToAvailMemBlocksList+0x59>
  802bf9:	a1 4c 41 80 00       	mov    0x80414c,%eax
  802bfe:	8b 55 08             	mov    0x8(%ebp),%edx
  802c01:	89 10                	mov    %edx,(%eax)
  802c03:	eb 08                	jmp    802c0d <addToAvailMemBlocksList+0x61>
  802c05:	8b 45 08             	mov    0x8(%ebp),%eax
  802c08:	a3 48 41 80 00       	mov    %eax,0x804148
  802c0d:	8b 45 08             	mov    0x8(%ebp),%eax
  802c10:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802c15:	8b 45 08             	mov    0x8(%ebp),%eax
  802c18:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802c1e:	a1 54 41 80 00       	mov    0x804154,%eax
  802c23:	40                   	inc    %eax
  802c24:	a3 54 41 80 00       	mov    %eax,0x804154
}
  802c29:	90                   	nop
  802c2a:	c9                   	leave  
  802c2b:	c3                   	ret    

00802c2c <insert_sorted_with_merge_freeList>:
void insert_sorted_with_merge_freeList(struct MemBlock *blockToInsert)
{
  802c2c:	55                   	push   %ebp
  802c2d:	89 e5                	mov    %esp,%ebp
  802c2f:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] insert_sorted_with_merge_freeList
	// Write your code here, remove the panic and write your code

	struct MemBlock* last = LIST_LAST(&FreeMemBlocksList);
  802c32:	a1 3c 41 80 00       	mov    0x80413c,%eax
  802c37:	89 45 f0             	mov    %eax,-0x10(%ebp)
	//check if list empty
	if (LIST_SIZE(&(FreeMemBlocksList)) == 0)
  802c3a:	a1 44 41 80 00       	mov    0x804144,%eax
  802c3f:	85 c0                	test   %eax,%eax
  802c41:	75 68                	jne    802cab <insert_sorted_with_merge_freeList+0x7f>
		LIST_INSERT_HEAD(&FreeMemBlocksList, blockToInsert);
  802c43:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802c47:	75 17                	jne    802c60 <insert_sorted_with_merge_freeList+0x34>
  802c49:	83 ec 04             	sub    $0x4,%esp
  802c4c:	68 b4 3c 80 00       	push   $0x803cb4
  802c51:	68 1a 01 00 00       	push   $0x11a
  802c56:	68 d7 3c 80 00       	push   $0x803cd7
  802c5b:	e8 39 d8 ff ff       	call   800499 <_panic>
  802c60:	8b 15 38 41 80 00    	mov    0x804138,%edx
  802c66:	8b 45 08             	mov    0x8(%ebp),%eax
  802c69:	89 10                	mov    %edx,(%eax)
  802c6b:	8b 45 08             	mov    0x8(%ebp),%eax
  802c6e:	8b 00                	mov    (%eax),%eax
  802c70:	85 c0                	test   %eax,%eax
  802c72:	74 0d                	je     802c81 <insert_sorted_with_merge_freeList+0x55>
  802c74:	a1 38 41 80 00       	mov    0x804138,%eax
  802c79:	8b 55 08             	mov    0x8(%ebp),%edx
  802c7c:	89 50 04             	mov    %edx,0x4(%eax)
  802c7f:	eb 08                	jmp    802c89 <insert_sorted_with_merge_freeList+0x5d>
  802c81:	8b 45 08             	mov    0x8(%ebp),%eax
  802c84:	a3 3c 41 80 00       	mov    %eax,0x80413c
  802c89:	8b 45 08             	mov    0x8(%ebp),%eax
  802c8c:	a3 38 41 80 00       	mov    %eax,0x804138
  802c91:	8b 45 08             	mov    0x8(%ebp),%eax
  802c94:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802c9b:	a1 44 41 80 00       	mov    0x804144,%eax
  802ca0:	40                   	inc    %eax
  802ca1:	a3 44 41 80 00       	mov    %eax,0x804144
		}
	}

	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  802ca6:	e9 c5 03 00 00       	jmp    803070 <insert_sorted_with_merge_freeList+0x444>
	struct MemBlock* last = LIST_LAST(&FreeMemBlocksList);
	//check if list empty
	if (LIST_SIZE(&(FreeMemBlocksList)) == 0)
		LIST_INSERT_HEAD(&FreeMemBlocksList, blockToInsert);
	//check if it's position is at last
	else if (last->sva < blockToInsert->sva) {
  802cab:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802cae:	8b 50 08             	mov    0x8(%eax),%edx
  802cb1:	8b 45 08             	mov    0x8(%ebp),%eax
  802cb4:	8b 40 08             	mov    0x8(%eax),%eax
  802cb7:	39 c2                	cmp    %eax,%edx
  802cb9:	0f 83 b2 00 00 00    	jae    802d71 <insert_sorted_with_merge_freeList+0x145>

		//if i have to merge
		if (last->sva + last->size == blockToInsert->sva) {
  802cbf:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802cc2:	8b 50 08             	mov    0x8(%eax),%edx
  802cc5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802cc8:	8b 40 0c             	mov    0xc(%eax),%eax
  802ccb:	01 c2                	add    %eax,%edx
  802ccd:	8b 45 08             	mov    0x8(%ebp),%eax
  802cd0:	8b 40 08             	mov    0x8(%eax),%eax
  802cd3:	39 c2                	cmp    %eax,%edx
  802cd5:	75 27                	jne    802cfe <insert_sorted_with_merge_freeList+0xd2>
			last->size = last->size + blockToInsert->size;
  802cd7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802cda:	8b 50 0c             	mov    0xc(%eax),%edx
  802cdd:	8b 45 08             	mov    0x8(%ebp),%eax
  802ce0:	8b 40 0c             	mov    0xc(%eax),%eax
  802ce3:	01 c2                	add    %eax,%edx
  802ce5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802ce8:	89 50 0c             	mov    %edx,0xc(%eax)
			addToAvailMemBlocksList(blockToInsert);
  802ceb:	83 ec 0c             	sub    $0xc,%esp
  802cee:	ff 75 08             	pushl  0x8(%ebp)
  802cf1:	e8 b6 fe ff ff       	call   802bac <addToAvailMemBlocksList>
  802cf6:	83 c4 10             	add    $0x10,%esp
		}
	}

	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  802cf9:	e9 72 03 00 00       	jmp    803070 <insert_sorted_with_merge_freeList+0x444>
		if (last->sva + last->size == blockToInsert->sva) {
			last->size = last->size + blockToInsert->size;
			addToAvailMemBlocksList(blockToInsert);

		} else {
			LIST_INSERT_AFTER(&FreeMemBlocksList, last, blockToInsert);
  802cfe:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802d02:	74 06                	je     802d0a <insert_sorted_with_merge_freeList+0xde>
  802d04:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802d08:	75 17                	jne    802d21 <insert_sorted_with_merge_freeList+0xf5>
  802d0a:	83 ec 04             	sub    $0x4,%esp
  802d0d:	68 14 3d 80 00       	push   $0x803d14
  802d12:	68 24 01 00 00       	push   $0x124
  802d17:	68 d7 3c 80 00       	push   $0x803cd7
  802d1c:	e8 78 d7 ff ff       	call   800499 <_panic>
  802d21:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d24:	8b 10                	mov    (%eax),%edx
  802d26:	8b 45 08             	mov    0x8(%ebp),%eax
  802d29:	89 10                	mov    %edx,(%eax)
  802d2b:	8b 45 08             	mov    0x8(%ebp),%eax
  802d2e:	8b 00                	mov    (%eax),%eax
  802d30:	85 c0                	test   %eax,%eax
  802d32:	74 0b                	je     802d3f <insert_sorted_with_merge_freeList+0x113>
  802d34:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d37:	8b 00                	mov    (%eax),%eax
  802d39:	8b 55 08             	mov    0x8(%ebp),%edx
  802d3c:	89 50 04             	mov    %edx,0x4(%eax)
  802d3f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d42:	8b 55 08             	mov    0x8(%ebp),%edx
  802d45:	89 10                	mov    %edx,(%eax)
  802d47:	8b 45 08             	mov    0x8(%ebp),%eax
  802d4a:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802d4d:	89 50 04             	mov    %edx,0x4(%eax)
  802d50:	8b 45 08             	mov    0x8(%ebp),%eax
  802d53:	8b 00                	mov    (%eax),%eax
  802d55:	85 c0                	test   %eax,%eax
  802d57:	75 08                	jne    802d61 <insert_sorted_with_merge_freeList+0x135>
  802d59:	8b 45 08             	mov    0x8(%ebp),%eax
  802d5c:	a3 3c 41 80 00       	mov    %eax,0x80413c
  802d61:	a1 44 41 80 00       	mov    0x804144,%eax
  802d66:	40                   	inc    %eax
  802d67:	a3 44 41 80 00       	mov    %eax,0x804144
		}
	}

	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  802d6c:	e9 ff 02 00 00       	jmp    803070 <insert_sorted_with_merge_freeList+0x444>
		} else {
			LIST_INSERT_AFTER(&FreeMemBlocksList, last, blockToInsert);
		}
	} else {
		struct MemBlock *iterator;
		LIST_FOREACH(iterator, &(FreeMemBlocksList))
  802d71:	a1 38 41 80 00       	mov    0x804138,%eax
  802d76:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802d79:	e9 c2 02 00 00       	jmp    803040 <insert_sorted_with_merge_freeList+0x414>
		{

			if (iterator->sva > blockToInsert->sva) {
  802d7e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d81:	8b 50 08             	mov    0x8(%eax),%edx
  802d84:	8b 45 08             	mov    0x8(%ebp),%eax
  802d87:	8b 40 08             	mov    0x8(%eax),%eax
  802d8a:	39 c2                	cmp    %eax,%edx
  802d8c:	0f 86 a6 02 00 00    	jbe    803038 <insert_sorted_with_merge_freeList+0x40c>

				struct MemBlock* prev = LIST_PREV(iterator);
  802d92:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d95:	8b 40 04             	mov    0x4(%eax),%eax
  802d98:	89 45 ec             	mov    %eax,-0x14(%ebp)
				if (prev == NULL) {
  802d9b:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802d9f:	0f 85 ba 00 00 00    	jne    802e5f <insert_sorted_with_merge_freeList+0x233>
					//check merge
					if (blockToInsert->size + blockToInsert->sva
  802da5:	8b 45 08             	mov    0x8(%ebp),%eax
  802da8:	8b 50 0c             	mov    0xc(%eax),%edx
  802dab:	8b 45 08             	mov    0x8(%ebp),%eax
  802dae:	8b 40 08             	mov    0x8(%eax),%eax
  802db1:	01 c2                	add    %eax,%edx
							== iterator->sva) {
  802db3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802db6:	8b 40 08             	mov    0x8(%eax),%eax
			if (iterator->sva > blockToInsert->sva) {

				struct MemBlock* prev = LIST_PREV(iterator);
				if (prev == NULL) {
					//check merge
					if (blockToInsert->size + blockToInsert->sva
  802db9:	39 c2                	cmp    %eax,%edx
  802dbb:	75 33                	jne    802df0 <insert_sorted_with_merge_freeList+0x1c4>
							== iterator->sva) {
						iterator->sva = blockToInsert->sva;
  802dbd:	8b 45 08             	mov    0x8(%ebp),%eax
  802dc0:	8b 50 08             	mov    0x8(%eax),%edx
  802dc3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802dc6:	89 50 08             	mov    %edx,0x8(%eax)
						iterator->size = iterator->size + blockToInsert->size;
  802dc9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802dcc:	8b 50 0c             	mov    0xc(%eax),%edx
  802dcf:	8b 45 08             	mov    0x8(%ebp),%eax
  802dd2:	8b 40 0c             	mov    0xc(%eax),%eax
  802dd5:	01 c2                	add    %eax,%edx
  802dd7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802dda:	89 50 0c             	mov    %edx,0xc(%eax)
						addToAvailMemBlocksList(blockToInsert);
  802ddd:	83 ec 0c             	sub    $0xc,%esp
  802de0:	ff 75 08             	pushl  0x8(%ebp)
  802de3:	e8 c4 fd ff ff       	call   802bac <addToAvailMemBlocksList>
  802de8:	83 c4 10             	add    $0x10,%esp

					else {
						LIST_INSERT_BEFORE(&FreeMemBlocksList, iterator,
								blockToInsert);
					}
					break;
  802deb:	e9 80 02 00 00       	jmp    803070 <insert_sorted_with_merge_freeList+0x444>
						addToAvailMemBlocksList(blockToInsert);

					}

					else {
						LIST_INSERT_BEFORE(&FreeMemBlocksList, iterator,
  802df0:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802df4:	74 06                	je     802dfc <insert_sorted_with_merge_freeList+0x1d0>
  802df6:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802dfa:	75 17                	jne    802e13 <insert_sorted_with_merge_freeList+0x1e7>
  802dfc:	83 ec 04             	sub    $0x4,%esp
  802dff:	68 68 3d 80 00       	push   $0x803d68
  802e04:	68 3a 01 00 00       	push   $0x13a
  802e09:	68 d7 3c 80 00       	push   $0x803cd7
  802e0e:	e8 86 d6 ff ff       	call   800499 <_panic>
  802e13:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e16:	8b 50 04             	mov    0x4(%eax),%edx
  802e19:	8b 45 08             	mov    0x8(%ebp),%eax
  802e1c:	89 50 04             	mov    %edx,0x4(%eax)
  802e1f:	8b 45 08             	mov    0x8(%ebp),%eax
  802e22:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802e25:	89 10                	mov    %edx,(%eax)
  802e27:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e2a:	8b 40 04             	mov    0x4(%eax),%eax
  802e2d:	85 c0                	test   %eax,%eax
  802e2f:	74 0d                	je     802e3e <insert_sorted_with_merge_freeList+0x212>
  802e31:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e34:	8b 40 04             	mov    0x4(%eax),%eax
  802e37:	8b 55 08             	mov    0x8(%ebp),%edx
  802e3a:	89 10                	mov    %edx,(%eax)
  802e3c:	eb 08                	jmp    802e46 <insert_sorted_with_merge_freeList+0x21a>
  802e3e:	8b 45 08             	mov    0x8(%ebp),%eax
  802e41:	a3 38 41 80 00       	mov    %eax,0x804138
  802e46:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e49:	8b 55 08             	mov    0x8(%ebp),%edx
  802e4c:	89 50 04             	mov    %edx,0x4(%eax)
  802e4f:	a1 44 41 80 00       	mov    0x804144,%eax
  802e54:	40                   	inc    %eax
  802e55:	a3 44 41 80 00       	mov    %eax,0x804144
								blockToInsert);
					}
					break;
  802e5a:	e9 11 02 00 00       	jmp    803070 <insert_sorted_with_merge_freeList+0x444>
				} else {
					//prev and next merge
					if (prev->sva + prev->size + blockToInsert->size
  802e5f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802e62:	8b 50 08             	mov    0x8(%eax),%edx
  802e65:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802e68:	8b 40 0c             	mov    0xc(%eax),%eax
  802e6b:	01 c2                	add    %eax,%edx
  802e6d:	8b 45 08             	mov    0x8(%ebp),%eax
  802e70:	8b 40 0c             	mov    0xc(%eax),%eax
  802e73:	01 c2                	add    %eax,%edx
							== iterator->sva) {
  802e75:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e78:	8b 40 08             	mov    0x8(%eax),%eax
								blockToInsert);
					}
					break;
				} else {
					//prev and next merge
					if (prev->sva + prev->size + blockToInsert->size
  802e7b:	39 c2                	cmp    %eax,%edx
  802e7d:	0f 85 bf 00 00 00    	jne    802f42 <insert_sorted_with_merge_freeList+0x316>
							== iterator->sva) {
						prev->size = prev->size + blockToInsert->size
  802e83:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802e86:	8b 50 0c             	mov    0xc(%eax),%edx
  802e89:	8b 45 08             	mov    0x8(%ebp),%eax
  802e8c:	8b 40 0c             	mov    0xc(%eax),%eax
  802e8f:	01 c2                	add    %eax,%edx
								+ iterator->size;
  802e91:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e94:	8b 40 0c             	mov    0xc(%eax),%eax
  802e97:	01 c2                	add    %eax,%edx
					break;
				} else {
					//prev and next merge
					if (prev->sva + prev->size + blockToInsert->size
							== iterator->sva) {
						prev->size = prev->size + blockToInsert->size
  802e99:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802e9c:	89 50 0c             	mov    %edx,0xc(%eax)
								+ iterator->size;
						LIST_REMOVE(&FreeMemBlocksList, iterator);
  802e9f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802ea3:	75 17                	jne    802ebc <insert_sorted_with_merge_freeList+0x290>
  802ea5:	83 ec 04             	sub    $0x4,%esp
  802ea8:	68 48 3d 80 00       	push   $0x803d48
  802ead:	68 43 01 00 00       	push   $0x143
  802eb2:	68 d7 3c 80 00       	push   $0x803cd7
  802eb7:	e8 dd d5 ff ff       	call   800499 <_panic>
  802ebc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ebf:	8b 00                	mov    (%eax),%eax
  802ec1:	85 c0                	test   %eax,%eax
  802ec3:	74 10                	je     802ed5 <insert_sorted_with_merge_freeList+0x2a9>
  802ec5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ec8:	8b 00                	mov    (%eax),%eax
  802eca:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802ecd:	8b 52 04             	mov    0x4(%edx),%edx
  802ed0:	89 50 04             	mov    %edx,0x4(%eax)
  802ed3:	eb 0b                	jmp    802ee0 <insert_sorted_with_merge_freeList+0x2b4>
  802ed5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ed8:	8b 40 04             	mov    0x4(%eax),%eax
  802edb:	a3 3c 41 80 00       	mov    %eax,0x80413c
  802ee0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ee3:	8b 40 04             	mov    0x4(%eax),%eax
  802ee6:	85 c0                	test   %eax,%eax
  802ee8:	74 0f                	je     802ef9 <insert_sorted_with_merge_freeList+0x2cd>
  802eea:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802eed:	8b 40 04             	mov    0x4(%eax),%eax
  802ef0:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802ef3:	8b 12                	mov    (%edx),%edx
  802ef5:	89 10                	mov    %edx,(%eax)
  802ef7:	eb 0a                	jmp    802f03 <insert_sorted_with_merge_freeList+0x2d7>
  802ef9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802efc:	8b 00                	mov    (%eax),%eax
  802efe:	a3 38 41 80 00       	mov    %eax,0x804138
  802f03:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f06:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802f0c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f0f:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802f16:	a1 44 41 80 00       	mov    0x804144,%eax
  802f1b:	48                   	dec    %eax
  802f1c:	a3 44 41 80 00       	mov    %eax,0x804144
						addToAvailMemBlocksList(blockToInsert);
  802f21:	83 ec 0c             	sub    $0xc,%esp
  802f24:	ff 75 08             	pushl  0x8(%ebp)
  802f27:	e8 80 fc ff ff       	call   802bac <addToAvailMemBlocksList>
  802f2c:	83 c4 10             	add    $0x10,%esp
						addToAvailMemBlocksList(iterator);
  802f2f:	83 ec 0c             	sub    $0xc,%esp
  802f32:	ff 75 f4             	pushl  -0xc(%ebp)
  802f35:	e8 72 fc ff ff       	call   802bac <addToAvailMemBlocksList>
  802f3a:	83 c4 10             	add    $0x10,%esp
					//Insert
					else {
						LIST_INSERT_BEFORE(&FreeMemBlocksList, iterator,
								blockToInsert);
					}
					break;
  802f3d:	e9 2e 01 00 00       	jmp    803070 <insert_sorted_with_merge_freeList+0x444>
						LIST_REMOVE(&FreeMemBlocksList, iterator);
						addToAvailMemBlocksList(blockToInsert);
						addToAvailMemBlocksList(iterator);
					}
					//previous merge
					else if (prev->sva + prev->size == blockToInsert->sva) {
  802f42:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802f45:	8b 50 08             	mov    0x8(%eax),%edx
  802f48:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802f4b:	8b 40 0c             	mov    0xc(%eax),%eax
  802f4e:	01 c2                	add    %eax,%edx
  802f50:	8b 45 08             	mov    0x8(%ebp),%eax
  802f53:	8b 40 08             	mov    0x8(%eax),%eax
  802f56:	39 c2                	cmp    %eax,%edx
  802f58:	75 27                	jne    802f81 <insert_sorted_with_merge_freeList+0x355>
						prev->size = prev->size + blockToInsert->size;
  802f5a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802f5d:	8b 50 0c             	mov    0xc(%eax),%edx
  802f60:	8b 45 08             	mov    0x8(%ebp),%eax
  802f63:	8b 40 0c             	mov    0xc(%eax),%eax
  802f66:	01 c2                	add    %eax,%edx
  802f68:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802f6b:	89 50 0c             	mov    %edx,0xc(%eax)
						addToAvailMemBlocksList(blockToInsert);
  802f6e:	83 ec 0c             	sub    $0xc,%esp
  802f71:	ff 75 08             	pushl  0x8(%ebp)
  802f74:	e8 33 fc ff ff       	call   802bac <addToAvailMemBlocksList>
  802f79:	83 c4 10             	add    $0x10,%esp
					//Insert
					else {
						LIST_INSERT_BEFORE(&FreeMemBlocksList, iterator,
								blockToInsert);
					}
					break;
  802f7c:	e9 ef 00 00 00       	jmp    803070 <insert_sorted_with_merge_freeList+0x444>
					else if (prev->sva + prev->size == blockToInsert->sva) {
						prev->size = prev->size + blockToInsert->size;
						addToAvailMemBlocksList(blockToInsert);
					}
					//next merge
					else if (blockToInsert->size + blockToInsert->sva
  802f81:	8b 45 08             	mov    0x8(%ebp),%eax
  802f84:	8b 50 0c             	mov    0xc(%eax),%edx
  802f87:	8b 45 08             	mov    0x8(%ebp),%eax
  802f8a:	8b 40 08             	mov    0x8(%eax),%eax
  802f8d:	01 c2                	add    %eax,%edx
							== iterator->sva) {
  802f8f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f92:	8b 40 08             	mov    0x8(%eax),%eax
					else if (prev->sva + prev->size == blockToInsert->sva) {
						prev->size = prev->size + blockToInsert->size;
						addToAvailMemBlocksList(blockToInsert);
					}
					//next merge
					else if (blockToInsert->size + blockToInsert->sva
  802f95:	39 c2                	cmp    %eax,%edx
  802f97:	75 33                	jne    802fcc <insert_sorted_with_merge_freeList+0x3a0>
							== iterator->sva) {
						iterator->sva = blockToInsert->sva;
  802f99:	8b 45 08             	mov    0x8(%ebp),%eax
  802f9c:	8b 50 08             	mov    0x8(%eax),%edx
  802f9f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802fa2:	89 50 08             	mov    %edx,0x8(%eax)
						iterator->size = iterator->size + blockToInsert->size;
  802fa5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802fa8:	8b 50 0c             	mov    0xc(%eax),%edx
  802fab:	8b 45 08             	mov    0x8(%ebp),%eax
  802fae:	8b 40 0c             	mov    0xc(%eax),%eax
  802fb1:	01 c2                	add    %eax,%edx
  802fb3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802fb6:	89 50 0c             	mov    %edx,0xc(%eax)
						addToAvailMemBlocksList(blockToInsert);
  802fb9:	83 ec 0c             	sub    $0xc,%esp
  802fbc:	ff 75 08             	pushl  0x8(%ebp)
  802fbf:	e8 e8 fb ff ff       	call   802bac <addToAvailMemBlocksList>
  802fc4:	83 c4 10             	add    $0x10,%esp
					//Insert
					else {
						LIST_INSERT_BEFORE(&FreeMemBlocksList, iterator,
								blockToInsert);
					}
					break;
  802fc7:	e9 a4 00 00 00       	jmp    803070 <insert_sorted_with_merge_freeList+0x444>
						iterator->size = iterator->size + blockToInsert->size;
						addToAvailMemBlocksList(blockToInsert);
					}
					//Insert
					else {
						LIST_INSERT_BEFORE(&FreeMemBlocksList, iterator,
  802fcc:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802fd0:	74 06                	je     802fd8 <insert_sorted_with_merge_freeList+0x3ac>
  802fd2:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802fd6:	75 17                	jne    802fef <insert_sorted_with_merge_freeList+0x3c3>
  802fd8:	83 ec 04             	sub    $0x4,%esp
  802fdb:	68 68 3d 80 00       	push   $0x803d68
  802fe0:	68 56 01 00 00       	push   $0x156
  802fe5:	68 d7 3c 80 00       	push   $0x803cd7
  802fea:	e8 aa d4 ff ff       	call   800499 <_panic>
  802fef:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ff2:	8b 50 04             	mov    0x4(%eax),%edx
  802ff5:	8b 45 08             	mov    0x8(%ebp),%eax
  802ff8:	89 50 04             	mov    %edx,0x4(%eax)
  802ffb:	8b 45 08             	mov    0x8(%ebp),%eax
  802ffe:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803001:	89 10                	mov    %edx,(%eax)
  803003:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803006:	8b 40 04             	mov    0x4(%eax),%eax
  803009:	85 c0                	test   %eax,%eax
  80300b:	74 0d                	je     80301a <insert_sorted_with_merge_freeList+0x3ee>
  80300d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803010:	8b 40 04             	mov    0x4(%eax),%eax
  803013:	8b 55 08             	mov    0x8(%ebp),%edx
  803016:	89 10                	mov    %edx,(%eax)
  803018:	eb 08                	jmp    803022 <insert_sorted_with_merge_freeList+0x3f6>
  80301a:	8b 45 08             	mov    0x8(%ebp),%eax
  80301d:	a3 38 41 80 00       	mov    %eax,0x804138
  803022:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803025:	8b 55 08             	mov    0x8(%ebp),%edx
  803028:	89 50 04             	mov    %edx,0x4(%eax)
  80302b:	a1 44 41 80 00       	mov    0x804144,%eax
  803030:	40                   	inc    %eax
  803031:	a3 44 41 80 00       	mov    %eax,0x804144
								blockToInsert);
					}
					break;
  803036:	eb 38                	jmp    803070 <insert_sorted_with_merge_freeList+0x444>
		} else {
			LIST_INSERT_AFTER(&FreeMemBlocksList, last, blockToInsert);
		}
	} else {
		struct MemBlock *iterator;
		LIST_FOREACH(iterator, &(FreeMemBlocksList))
  803038:	a1 40 41 80 00       	mov    0x804140,%eax
  80303d:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803040:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803044:	74 07                	je     80304d <insert_sorted_with_merge_freeList+0x421>
  803046:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803049:	8b 00                	mov    (%eax),%eax
  80304b:	eb 05                	jmp    803052 <insert_sorted_with_merge_freeList+0x426>
  80304d:	b8 00 00 00 00       	mov    $0x0,%eax
  803052:	a3 40 41 80 00       	mov    %eax,0x804140
  803057:	a1 40 41 80 00       	mov    0x804140,%eax
  80305c:	85 c0                	test   %eax,%eax
  80305e:	0f 85 1a fd ff ff    	jne    802d7e <insert_sorted_with_merge_freeList+0x152>
  803064:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803068:	0f 85 10 fd ff ff    	jne    802d7e <insert_sorted_with_merge_freeList+0x152>
		}
	}

	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  80306e:	eb 00                	jmp    803070 <insert_sorted_with_merge_freeList+0x444>
  803070:	90                   	nop
  803071:	c9                   	leave  
  803072:	c3                   	ret    
  803073:	90                   	nop

00803074 <__udivdi3>:
  803074:	55                   	push   %ebp
  803075:	57                   	push   %edi
  803076:	56                   	push   %esi
  803077:	53                   	push   %ebx
  803078:	83 ec 1c             	sub    $0x1c,%esp
  80307b:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  80307f:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  803083:	8b 7c 24 38          	mov    0x38(%esp),%edi
  803087:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  80308b:	89 ca                	mov    %ecx,%edx
  80308d:	89 f8                	mov    %edi,%eax
  80308f:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  803093:	85 f6                	test   %esi,%esi
  803095:	75 2d                	jne    8030c4 <__udivdi3+0x50>
  803097:	39 cf                	cmp    %ecx,%edi
  803099:	77 65                	ja     803100 <__udivdi3+0x8c>
  80309b:	89 fd                	mov    %edi,%ebp
  80309d:	85 ff                	test   %edi,%edi
  80309f:	75 0b                	jne    8030ac <__udivdi3+0x38>
  8030a1:	b8 01 00 00 00       	mov    $0x1,%eax
  8030a6:	31 d2                	xor    %edx,%edx
  8030a8:	f7 f7                	div    %edi
  8030aa:	89 c5                	mov    %eax,%ebp
  8030ac:	31 d2                	xor    %edx,%edx
  8030ae:	89 c8                	mov    %ecx,%eax
  8030b0:	f7 f5                	div    %ebp
  8030b2:	89 c1                	mov    %eax,%ecx
  8030b4:	89 d8                	mov    %ebx,%eax
  8030b6:	f7 f5                	div    %ebp
  8030b8:	89 cf                	mov    %ecx,%edi
  8030ba:	89 fa                	mov    %edi,%edx
  8030bc:	83 c4 1c             	add    $0x1c,%esp
  8030bf:	5b                   	pop    %ebx
  8030c0:	5e                   	pop    %esi
  8030c1:	5f                   	pop    %edi
  8030c2:	5d                   	pop    %ebp
  8030c3:	c3                   	ret    
  8030c4:	39 ce                	cmp    %ecx,%esi
  8030c6:	77 28                	ja     8030f0 <__udivdi3+0x7c>
  8030c8:	0f bd fe             	bsr    %esi,%edi
  8030cb:	83 f7 1f             	xor    $0x1f,%edi
  8030ce:	75 40                	jne    803110 <__udivdi3+0x9c>
  8030d0:	39 ce                	cmp    %ecx,%esi
  8030d2:	72 0a                	jb     8030de <__udivdi3+0x6a>
  8030d4:	3b 44 24 08          	cmp    0x8(%esp),%eax
  8030d8:	0f 87 9e 00 00 00    	ja     80317c <__udivdi3+0x108>
  8030de:	b8 01 00 00 00       	mov    $0x1,%eax
  8030e3:	89 fa                	mov    %edi,%edx
  8030e5:	83 c4 1c             	add    $0x1c,%esp
  8030e8:	5b                   	pop    %ebx
  8030e9:	5e                   	pop    %esi
  8030ea:	5f                   	pop    %edi
  8030eb:	5d                   	pop    %ebp
  8030ec:	c3                   	ret    
  8030ed:	8d 76 00             	lea    0x0(%esi),%esi
  8030f0:	31 ff                	xor    %edi,%edi
  8030f2:	31 c0                	xor    %eax,%eax
  8030f4:	89 fa                	mov    %edi,%edx
  8030f6:	83 c4 1c             	add    $0x1c,%esp
  8030f9:	5b                   	pop    %ebx
  8030fa:	5e                   	pop    %esi
  8030fb:	5f                   	pop    %edi
  8030fc:	5d                   	pop    %ebp
  8030fd:	c3                   	ret    
  8030fe:	66 90                	xchg   %ax,%ax
  803100:	89 d8                	mov    %ebx,%eax
  803102:	f7 f7                	div    %edi
  803104:	31 ff                	xor    %edi,%edi
  803106:	89 fa                	mov    %edi,%edx
  803108:	83 c4 1c             	add    $0x1c,%esp
  80310b:	5b                   	pop    %ebx
  80310c:	5e                   	pop    %esi
  80310d:	5f                   	pop    %edi
  80310e:	5d                   	pop    %ebp
  80310f:	c3                   	ret    
  803110:	bd 20 00 00 00       	mov    $0x20,%ebp
  803115:	89 eb                	mov    %ebp,%ebx
  803117:	29 fb                	sub    %edi,%ebx
  803119:	89 f9                	mov    %edi,%ecx
  80311b:	d3 e6                	shl    %cl,%esi
  80311d:	89 c5                	mov    %eax,%ebp
  80311f:	88 d9                	mov    %bl,%cl
  803121:	d3 ed                	shr    %cl,%ebp
  803123:	89 e9                	mov    %ebp,%ecx
  803125:	09 f1                	or     %esi,%ecx
  803127:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  80312b:	89 f9                	mov    %edi,%ecx
  80312d:	d3 e0                	shl    %cl,%eax
  80312f:	89 c5                	mov    %eax,%ebp
  803131:	89 d6                	mov    %edx,%esi
  803133:	88 d9                	mov    %bl,%cl
  803135:	d3 ee                	shr    %cl,%esi
  803137:	89 f9                	mov    %edi,%ecx
  803139:	d3 e2                	shl    %cl,%edx
  80313b:	8b 44 24 08          	mov    0x8(%esp),%eax
  80313f:	88 d9                	mov    %bl,%cl
  803141:	d3 e8                	shr    %cl,%eax
  803143:	09 c2                	or     %eax,%edx
  803145:	89 d0                	mov    %edx,%eax
  803147:	89 f2                	mov    %esi,%edx
  803149:	f7 74 24 0c          	divl   0xc(%esp)
  80314d:	89 d6                	mov    %edx,%esi
  80314f:	89 c3                	mov    %eax,%ebx
  803151:	f7 e5                	mul    %ebp
  803153:	39 d6                	cmp    %edx,%esi
  803155:	72 19                	jb     803170 <__udivdi3+0xfc>
  803157:	74 0b                	je     803164 <__udivdi3+0xf0>
  803159:	89 d8                	mov    %ebx,%eax
  80315b:	31 ff                	xor    %edi,%edi
  80315d:	e9 58 ff ff ff       	jmp    8030ba <__udivdi3+0x46>
  803162:	66 90                	xchg   %ax,%ax
  803164:	8b 54 24 08          	mov    0x8(%esp),%edx
  803168:	89 f9                	mov    %edi,%ecx
  80316a:	d3 e2                	shl    %cl,%edx
  80316c:	39 c2                	cmp    %eax,%edx
  80316e:	73 e9                	jae    803159 <__udivdi3+0xe5>
  803170:	8d 43 ff             	lea    -0x1(%ebx),%eax
  803173:	31 ff                	xor    %edi,%edi
  803175:	e9 40 ff ff ff       	jmp    8030ba <__udivdi3+0x46>
  80317a:	66 90                	xchg   %ax,%ax
  80317c:	31 c0                	xor    %eax,%eax
  80317e:	e9 37 ff ff ff       	jmp    8030ba <__udivdi3+0x46>
  803183:	90                   	nop

00803184 <__umoddi3>:
  803184:	55                   	push   %ebp
  803185:	57                   	push   %edi
  803186:	56                   	push   %esi
  803187:	53                   	push   %ebx
  803188:	83 ec 1c             	sub    $0x1c,%esp
  80318b:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  80318f:	8b 74 24 34          	mov    0x34(%esp),%esi
  803193:	8b 7c 24 38          	mov    0x38(%esp),%edi
  803197:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  80319b:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80319f:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8031a3:	89 f3                	mov    %esi,%ebx
  8031a5:	89 fa                	mov    %edi,%edx
  8031a7:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8031ab:	89 34 24             	mov    %esi,(%esp)
  8031ae:	85 c0                	test   %eax,%eax
  8031b0:	75 1a                	jne    8031cc <__umoddi3+0x48>
  8031b2:	39 f7                	cmp    %esi,%edi
  8031b4:	0f 86 a2 00 00 00    	jbe    80325c <__umoddi3+0xd8>
  8031ba:	89 c8                	mov    %ecx,%eax
  8031bc:	89 f2                	mov    %esi,%edx
  8031be:	f7 f7                	div    %edi
  8031c0:	89 d0                	mov    %edx,%eax
  8031c2:	31 d2                	xor    %edx,%edx
  8031c4:	83 c4 1c             	add    $0x1c,%esp
  8031c7:	5b                   	pop    %ebx
  8031c8:	5e                   	pop    %esi
  8031c9:	5f                   	pop    %edi
  8031ca:	5d                   	pop    %ebp
  8031cb:	c3                   	ret    
  8031cc:	39 f0                	cmp    %esi,%eax
  8031ce:	0f 87 ac 00 00 00    	ja     803280 <__umoddi3+0xfc>
  8031d4:	0f bd e8             	bsr    %eax,%ebp
  8031d7:	83 f5 1f             	xor    $0x1f,%ebp
  8031da:	0f 84 ac 00 00 00    	je     80328c <__umoddi3+0x108>
  8031e0:	bf 20 00 00 00       	mov    $0x20,%edi
  8031e5:	29 ef                	sub    %ebp,%edi
  8031e7:	89 fe                	mov    %edi,%esi
  8031e9:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  8031ed:	89 e9                	mov    %ebp,%ecx
  8031ef:	d3 e0                	shl    %cl,%eax
  8031f1:	89 d7                	mov    %edx,%edi
  8031f3:	89 f1                	mov    %esi,%ecx
  8031f5:	d3 ef                	shr    %cl,%edi
  8031f7:	09 c7                	or     %eax,%edi
  8031f9:	89 e9                	mov    %ebp,%ecx
  8031fb:	d3 e2                	shl    %cl,%edx
  8031fd:	89 14 24             	mov    %edx,(%esp)
  803200:	89 d8                	mov    %ebx,%eax
  803202:	d3 e0                	shl    %cl,%eax
  803204:	89 c2                	mov    %eax,%edx
  803206:	8b 44 24 08          	mov    0x8(%esp),%eax
  80320a:	d3 e0                	shl    %cl,%eax
  80320c:	89 44 24 04          	mov    %eax,0x4(%esp)
  803210:	8b 44 24 08          	mov    0x8(%esp),%eax
  803214:	89 f1                	mov    %esi,%ecx
  803216:	d3 e8                	shr    %cl,%eax
  803218:	09 d0                	or     %edx,%eax
  80321a:	d3 eb                	shr    %cl,%ebx
  80321c:	89 da                	mov    %ebx,%edx
  80321e:	f7 f7                	div    %edi
  803220:	89 d3                	mov    %edx,%ebx
  803222:	f7 24 24             	mull   (%esp)
  803225:	89 c6                	mov    %eax,%esi
  803227:	89 d1                	mov    %edx,%ecx
  803229:	39 d3                	cmp    %edx,%ebx
  80322b:	0f 82 87 00 00 00    	jb     8032b8 <__umoddi3+0x134>
  803231:	0f 84 91 00 00 00    	je     8032c8 <__umoddi3+0x144>
  803237:	8b 54 24 04          	mov    0x4(%esp),%edx
  80323b:	29 f2                	sub    %esi,%edx
  80323d:	19 cb                	sbb    %ecx,%ebx
  80323f:	89 d8                	mov    %ebx,%eax
  803241:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  803245:	d3 e0                	shl    %cl,%eax
  803247:	89 e9                	mov    %ebp,%ecx
  803249:	d3 ea                	shr    %cl,%edx
  80324b:	09 d0                	or     %edx,%eax
  80324d:	89 e9                	mov    %ebp,%ecx
  80324f:	d3 eb                	shr    %cl,%ebx
  803251:	89 da                	mov    %ebx,%edx
  803253:	83 c4 1c             	add    $0x1c,%esp
  803256:	5b                   	pop    %ebx
  803257:	5e                   	pop    %esi
  803258:	5f                   	pop    %edi
  803259:	5d                   	pop    %ebp
  80325a:	c3                   	ret    
  80325b:	90                   	nop
  80325c:	89 fd                	mov    %edi,%ebp
  80325e:	85 ff                	test   %edi,%edi
  803260:	75 0b                	jne    80326d <__umoddi3+0xe9>
  803262:	b8 01 00 00 00       	mov    $0x1,%eax
  803267:	31 d2                	xor    %edx,%edx
  803269:	f7 f7                	div    %edi
  80326b:	89 c5                	mov    %eax,%ebp
  80326d:	89 f0                	mov    %esi,%eax
  80326f:	31 d2                	xor    %edx,%edx
  803271:	f7 f5                	div    %ebp
  803273:	89 c8                	mov    %ecx,%eax
  803275:	f7 f5                	div    %ebp
  803277:	89 d0                	mov    %edx,%eax
  803279:	e9 44 ff ff ff       	jmp    8031c2 <__umoddi3+0x3e>
  80327e:	66 90                	xchg   %ax,%ax
  803280:	89 c8                	mov    %ecx,%eax
  803282:	89 f2                	mov    %esi,%edx
  803284:	83 c4 1c             	add    $0x1c,%esp
  803287:	5b                   	pop    %ebx
  803288:	5e                   	pop    %esi
  803289:	5f                   	pop    %edi
  80328a:	5d                   	pop    %ebp
  80328b:	c3                   	ret    
  80328c:	3b 04 24             	cmp    (%esp),%eax
  80328f:	72 06                	jb     803297 <__umoddi3+0x113>
  803291:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  803295:	77 0f                	ja     8032a6 <__umoddi3+0x122>
  803297:	89 f2                	mov    %esi,%edx
  803299:	29 f9                	sub    %edi,%ecx
  80329b:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  80329f:	89 14 24             	mov    %edx,(%esp)
  8032a2:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8032a6:	8b 44 24 04          	mov    0x4(%esp),%eax
  8032aa:	8b 14 24             	mov    (%esp),%edx
  8032ad:	83 c4 1c             	add    $0x1c,%esp
  8032b0:	5b                   	pop    %ebx
  8032b1:	5e                   	pop    %esi
  8032b2:	5f                   	pop    %edi
  8032b3:	5d                   	pop    %ebp
  8032b4:	c3                   	ret    
  8032b5:	8d 76 00             	lea    0x0(%esi),%esi
  8032b8:	2b 04 24             	sub    (%esp),%eax
  8032bb:	19 fa                	sbb    %edi,%edx
  8032bd:	89 d1                	mov    %edx,%ecx
  8032bf:	89 c6                	mov    %eax,%esi
  8032c1:	e9 71 ff ff ff       	jmp    803237 <__umoddi3+0xb3>
  8032c6:	66 90                	xchg   %ax,%ax
  8032c8:	39 44 24 04          	cmp    %eax,0x4(%esp)
  8032cc:	72 ea                	jb     8032b8 <__umoddi3+0x134>
  8032ce:	89 d9                	mov    %ebx,%ecx
  8032d0:	e9 62 ff ff ff       	jmp    803237 <__umoddi3+0xb3>
