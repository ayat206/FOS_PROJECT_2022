
obj/user/tst_sharing_5_master:     file format elf32-i386


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
  800031:	e8 d8 03 00 00       	call   80040e <libmain>
1:      jmp 1b
  800036:	eb fe                	jmp    800036 <args_exist+0x5>

00800038 <_main>:
// Test the free of shared variables
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
  80008d:	68 40 34 80 00       	push   $0x803440
  800092:	6a 12                	push   $0x12
  800094:	68 5c 34 80 00       	push   $0x80345c
  800099:	e8 ac 04 00 00       	call   80054a <_panic>
	}
	/*Dummy malloc to enforce the UHEAP initializations*/
	malloc(0);
  80009e:	83 ec 0c             	sub    $0xc,%esp
  8000a1:	6a 00                	push   $0x0
  8000a3:	e8 e8 16 00 00       	call   801790 <malloc>
  8000a8:	83 c4 10             	add    $0x10,%esp
	/*=================================================*/

	cprintf("************************************************\n");
  8000ab:	83 ec 0c             	sub    $0xc,%esp
  8000ae:	68 78 34 80 00       	push   $0x803478
  8000b3:	e8 46 07 00 00       	call   8007fe <cprintf>
  8000b8:	83 c4 10             	add    $0x10,%esp
	cprintf("MAKE SURE to have a FRESH RUN for this test\n(i.e. don't run any program/test before it)\n");
  8000bb:	83 ec 0c             	sub    $0xc,%esp
  8000be:	68 ac 34 80 00       	push   $0x8034ac
  8000c3:	e8 36 07 00 00       	call   8007fe <cprintf>
  8000c8:	83 c4 10             	add    $0x10,%esp
	cprintf("************************************************\n\n\n");
  8000cb:	83 ec 0c             	sub    $0xc,%esp
  8000ce:	68 08 35 80 00       	push   $0x803508
  8000d3:	e8 26 07 00 00       	call   8007fe <cprintf>
  8000d8:	83 c4 10             	add    $0x10,%esp

	int envID = sys_getenvid();
  8000db:	e8 83 1d 00 00       	call   801e63 <sys_getenvid>
  8000e0:	89 45 ec             	mov    %eax,-0x14(%ebp)
	int expected = 0;
  8000e3:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
	cprintf("STEP A: checking free of shared object using 2 environments... \n");
  8000ea:	83 ec 0c             	sub    $0xc,%esp
  8000ed:	68 3c 35 80 00       	push   $0x80353c
  8000f2:	e8 07 07 00 00       	call   8007fe <cprintf>
  8000f7:	83 c4 10             	add    $0x10,%esp
	{
		uint32 *x;
		int32 envIdSlave1 = sys_create_env("tshr5slave", (myEnv->page_WS_max_size),(myEnv->SecondListSize), (myEnv->percentage_of_WS_pages_to_be_removed));
  8000fa:	a1 20 50 80 00       	mov    0x805020,%eax
  8000ff:	8b 90 a0 05 00 00    	mov    0x5a0(%eax),%edx
  800105:	a1 20 50 80 00       	mov    0x805020,%eax
  80010a:	8b 80 ec 05 00 00    	mov    0x5ec(%eax),%eax
  800110:	89 c1                	mov    %eax,%ecx
  800112:	a1 20 50 80 00       	mov    0x805020,%eax
  800117:	8b 40 74             	mov    0x74(%eax),%eax
  80011a:	52                   	push   %edx
  80011b:	51                   	push   %ecx
  80011c:	50                   	push   %eax
  80011d:	68 7d 35 80 00       	push   $0x80357d
  800122:	e8 e7 1c 00 00       	call   801e0e <sys_create_env>
  800127:	83 c4 10             	add    $0x10,%esp
  80012a:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		int32 envIdSlave2 = sys_create_env("tshr5slave", (myEnv->page_WS_max_size),(myEnv->SecondListSize), (myEnv->percentage_of_WS_pages_to_be_removed));
  80012d:	a1 20 50 80 00       	mov    0x805020,%eax
  800132:	8b 90 a0 05 00 00    	mov    0x5a0(%eax),%edx
  800138:	a1 20 50 80 00       	mov    0x805020,%eax
  80013d:	8b 80 ec 05 00 00    	mov    0x5ec(%eax),%eax
  800143:	89 c1                	mov    %eax,%ecx
  800145:	a1 20 50 80 00       	mov    0x805020,%eax
  80014a:	8b 40 74             	mov    0x74(%eax),%eax
  80014d:	52                   	push   %edx
  80014e:	51                   	push   %ecx
  80014f:	50                   	push   %eax
  800150:	68 7d 35 80 00       	push   $0x80357d
  800155:	e8 b4 1c 00 00       	call   801e0e <sys_create_env>
  80015a:	83 c4 10             	add    $0x10,%esp
  80015d:	89 45 e0             	mov    %eax,-0x20(%ebp)

		int freeFrames = sys_calculate_free_frames() ;
  800160:	e8 37 1a 00 00       	call   801b9c <sys_calculate_free_frames>
  800165:	89 45 dc             	mov    %eax,-0x24(%ebp)
		x = smalloc("x", PAGE_SIZE, 1);
  800168:	83 ec 04             	sub    $0x4,%esp
  80016b:	6a 01                	push   $0x1
  80016d:	68 00 10 00 00       	push   $0x1000
  800172:	68 88 35 80 00       	push   $0x803588
  800177:	e8 5c 17 00 00       	call   8018d8 <smalloc>
  80017c:	83 c4 10             	add    $0x10,%esp
  80017f:	89 45 d8             	mov    %eax,-0x28(%ebp)
		cprintf("Master env created x (1 page) \n");
  800182:	83 ec 0c             	sub    $0xc,%esp
  800185:	68 8c 35 80 00       	push   $0x80358c
  80018a:	e8 6f 06 00 00       	call   8007fe <cprintf>
  80018f:	83 c4 10             	add    $0x10,%esp
		if (x != (uint32*)USER_HEAP_START) panic("Returned address is not correct. check the setting of it and/or the updating of the shared_mem_free_address");
  800192:	81 7d d8 00 00 00 80 	cmpl   $0x80000000,-0x28(%ebp)
  800199:	74 14                	je     8001af <_main+0x177>
  80019b:	83 ec 04             	sub    $0x4,%esp
  80019e:	68 ac 35 80 00       	push   $0x8035ac
  8001a3:	6a 27                	push   $0x27
  8001a5:	68 5c 34 80 00       	push   $0x80345c
  8001aa:	e8 9b 03 00 00       	call   80054a <_panic>
		if ((freeFrames - sys_calculate_free_frames()) !=  1+1+2) panic("Wrong allocation: make sure that you allocate the required space in the user environment and add its frames to frames_storage");
  8001af:	8b 5d dc             	mov    -0x24(%ebp),%ebx
  8001b2:	e8 e5 19 00 00       	call   801b9c <sys_calculate_free_frames>
  8001b7:	29 c3                	sub    %eax,%ebx
  8001b9:	89 d8                	mov    %ebx,%eax
  8001bb:	83 f8 04             	cmp    $0x4,%eax
  8001be:	74 14                	je     8001d4 <_main+0x19c>
  8001c0:	83 ec 04             	sub    $0x4,%esp
  8001c3:	68 18 36 80 00       	push   $0x803618
  8001c8:	6a 28                	push   $0x28
  8001ca:	68 5c 34 80 00       	push   $0x80345c
  8001cf:	e8 76 03 00 00       	call   80054a <_panic>

		//to check that the slave environments completed successfully
		rsttst();
  8001d4:	e8 81 1d 00 00       	call   801f5a <rsttst>

		sys_run_env(envIdSlave1);
  8001d9:	83 ec 0c             	sub    $0xc,%esp
  8001dc:	ff 75 e4             	pushl  -0x1c(%ebp)
  8001df:	e8 48 1c 00 00       	call   801e2c <sys_run_env>
  8001e4:	83 c4 10             	add    $0x10,%esp
		sys_run_env(envIdSlave2);
  8001e7:	83 ec 0c             	sub    $0xc,%esp
  8001ea:	ff 75 e0             	pushl  -0x20(%ebp)
  8001ed:	e8 3a 1c 00 00       	call   801e2c <sys_run_env>
  8001f2:	83 c4 10             	add    $0x10,%esp

		cprintf("please be patient ...\n");
  8001f5:	83 ec 0c             	sub    $0xc,%esp
  8001f8:	68 96 36 80 00       	push   $0x803696
  8001fd:	e8 fc 05 00 00       	call   8007fe <cprintf>
  800202:	83 c4 10             	add    $0x10,%esp
		env_sleep(3000);
  800205:	83 ec 0c             	sub    $0xc,%esp
  800208:	68 b8 0b 00 00       	push   $0xbb8
  80020d:	e8 12 2f 00 00       	call   803124 <env_sleep>
  800212:	83 c4 10             	add    $0x10,%esp

		//to ensure that the slave environments completed successfully
		while (gettst()!=2) ;// panic("test failed");
  800215:	90                   	nop
  800216:	e8 b9 1d 00 00       	call   801fd4 <gettst>
  80021b:	83 f8 02             	cmp    $0x2,%eax
  80021e:	75 f6                	jne    800216 <_main+0x1de>

		freeFrames = sys_calculate_free_frames() ;
  800220:	e8 77 19 00 00       	call   801b9c <sys_calculate_free_frames>
  800225:	89 45 dc             	mov    %eax,-0x24(%ebp)
		sfree(x);
  800228:	83 ec 0c             	sub    $0xc,%esp
  80022b:	ff 75 d8             	pushl  -0x28(%ebp)
  80022e:	e8 09 18 00 00       	call   801a3c <sfree>
  800233:	83 c4 10             	add    $0x10,%esp
		cprintf("Master env removed x (1 page) \n");
  800236:	83 ec 0c             	sub    $0xc,%esp
  800239:	68 b0 36 80 00       	push   $0x8036b0
  80023e:	e8 bb 05 00 00       	call   8007fe <cprintf>
  800243:	83 c4 10             	add    $0x10,%esp
		int diff = (sys_calculate_free_frames() - freeFrames);
  800246:	e8 51 19 00 00       	call   801b9c <sys_calculate_free_frames>
  80024b:	89 c2                	mov    %eax,%edx
  80024d:	8b 45 dc             	mov    -0x24(%ebp),%eax
  800250:	29 c2                	sub    %eax,%edx
  800252:	89 d0                	mov    %edx,%eax
  800254:	89 45 d4             	mov    %eax,-0x2c(%ebp)
		expected = (1+1) + (1+1);
  800257:	c7 45 e8 04 00 00 00 	movl   $0x4,-0x18(%ebp)
		if ( diff !=  expected) panic("Wrong free (diff=%d, expected=%d): revise your freeSharedObject logic\n", diff, expected);
  80025e:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  800261:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  800264:	74 1a                	je     800280 <_main+0x248>
  800266:	83 ec 0c             	sub    $0xc,%esp
  800269:	ff 75 e8             	pushl  -0x18(%ebp)
  80026c:	ff 75 d4             	pushl  -0x2c(%ebp)
  80026f:	68 d0 36 80 00       	push   $0x8036d0
  800274:	6a 3b                	push   $0x3b
  800276:	68 5c 34 80 00       	push   $0x80345c
  80027b:	e8 ca 02 00 00       	call   80054a <_panic>
	}
	cprintf("Step A completed successfully!!\n\n\n");
  800280:	83 ec 0c             	sub    $0xc,%esp
  800283:	68 18 37 80 00       	push   $0x803718
  800288:	e8 71 05 00 00       	call   8007fe <cprintf>
  80028d:	83 c4 10             	add    $0x10,%esp

	cprintf("STEP B: checking free of 2 shared objects ... \n");
  800290:	83 ec 0c             	sub    $0xc,%esp
  800293:	68 3c 37 80 00       	push   $0x80373c
  800298:	e8 61 05 00 00       	call   8007fe <cprintf>
  80029d:	83 c4 10             	add    $0x10,%esp
	{
		uint32 *x, *z ;
		int32 envIdSlaveB1 = sys_create_env("tshr5slaveB1", (myEnv->page_WS_max_size),(myEnv->SecondListSize), (myEnv->percentage_of_WS_pages_to_be_removed));
  8002a0:	a1 20 50 80 00       	mov    0x805020,%eax
  8002a5:	8b 90 a0 05 00 00    	mov    0x5a0(%eax),%edx
  8002ab:	a1 20 50 80 00       	mov    0x805020,%eax
  8002b0:	8b 80 ec 05 00 00    	mov    0x5ec(%eax),%eax
  8002b6:	89 c1                	mov    %eax,%ecx
  8002b8:	a1 20 50 80 00       	mov    0x805020,%eax
  8002bd:	8b 40 74             	mov    0x74(%eax),%eax
  8002c0:	52                   	push   %edx
  8002c1:	51                   	push   %ecx
  8002c2:	50                   	push   %eax
  8002c3:	68 6c 37 80 00       	push   $0x80376c
  8002c8:	e8 41 1b 00 00       	call   801e0e <sys_create_env>
  8002cd:	83 c4 10             	add    $0x10,%esp
  8002d0:	89 45 d0             	mov    %eax,-0x30(%ebp)
		int32 envIdSlaveB2 = sys_create_env("tshr5slaveB2", (myEnv->page_WS_max_size),(myEnv->SecondListSize), (myEnv->percentage_of_WS_pages_to_be_removed));
  8002d3:	a1 20 50 80 00       	mov    0x805020,%eax
  8002d8:	8b 90 a0 05 00 00    	mov    0x5a0(%eax),%edx
  8002de:	a1 20 50 80 00       	mov    0x805020,%eax
  8002e3:	8b 80 ec 05 00 00    	mov    0x5ec(%eax),%eax
  8002e9:	89 c1                	mov    %eax,%ecx
  8002eb:	a1 20 50 80 00       	mov    0x805020,%eax
  8002f0:	8b 40 74             	mov    0x74(%eax),%eax
  8002f3:	52                   	push   %edx
  8002f4:	51                   	push   %ecx
  8002f5:	50                   	push   %eax
  8002f6:	68 79 37 80 00       	push   $0x803779
  8002fb:	e8 0e 1b 00 00       	call   801e0e <sys_create_env>
  800300:	83 c4 10             	add    $0x10,%esp
  800303:	89 45 cc             	mov    %eax,-0x34(%ebp)

		z = smalloc("z", PAGE_SIZE, 1);
  800306:	83 ec 04             	sub    $0x4,%esp
  800309:	6a 01                	push   $0x1
  80030b:	68 00 10 00 00       	push   $0x1000
  800310:	68 86 37 80 00       	push   $0x803786
  800315:	e8 be 15 00 00       	call   8018d8 <smalloc>
  80031a:	83 c4 10             	add    $0x10,%esp
  80031d:	89 45 c8             	mov    %eax,-0x38(%ebp)
		cprintf("Master env created z (1 page) \n");
  800320:	83 ec 0c             	sub    $0xc,%esp
  800323:	68 88 37 80 00       	push   $0x803788
  800328:	e8 d1 04 00 00       	call   8007fe <cprintf>
  80032d:	83 c4 10             	add    $0x10,%esp

		x = smalloc("x", PAGE_SIZE, 1);
  800330:	83 ec 04             	sub    $0x4,%esp
  800333:	6a 01                	push   $0x1
  800335:	68 00 10 00 00       	push   $0x1000
  80033a:	68 88 35 80 00       	push   $0x803588
  80033f:	e8 94 15 00 00       	call   8018d8 <smalloc>
  800344:	83 c4 10             	add    $0x10,%esp
  800347:	89 45 c4             	mov    %eax,-0x3c(%ebp)
		cprintf("Master env created x (1 page) \n");
  80034a:	83 ec 0c             	sub    $0xc,%esp
  80034d:	68 8c 35 80 00       	push   $0x80358c
  800352:	e8 a7 04 00 00       	call   8007fe <cprintf>
  800357:	83 c4 10             	add    $0x10,%esp

		rsttst();
  80035a:	e8 fb 1b 00 00       	call   801f5a <rsttst>

		sys_run_env(envIdSlaveB1);
  80035f:	83 ec 0c             	sub    $0xc,%esp
  800362:	ff 75 d0             	pushl  -0x30(%ebp)
  800365:	e8 c2 1a 00 00       	call   801e2c <sys_run_env>
  80036a:	83 c4 10             	add    $0x10,%esp
		sys_run_env(envIdSlaveB2);
  80036d:	83 ec 0c             	sub    $0xc,%esp
  800370:	ff 75 cc             	pushl  -0x34(%ebp)
  800373:	e8 b4 1a 00 00       	call   801e2c <sys_run_env>
  800378:	83 c4 10             	add    $0x10,%esp

		//give slaves time to catch the shared object before removal
		{
//			env_sleep(4000);
			while (gettst()!=2) ;
  80037b:	90                   	nop
  80037c:	e8 53 1c 00 00       	call   801fd4 <gettst>
  800381:	83 f8 02             	cmp    $0x2,%eax
  800384:	75 f6                	jne    80037c <_main+0x344>
		}

		rsttst();
  800386:	e8 cf 1b 00 00       	call   801f5a <rsttst>

		int freeFrames = sys_calculate_free_frames() ;
  80038b:	e8 0c 18 00 00       	call   801b9c <sys_calculate_free_frames>
  800390:	89 45 c0             	mov    %eax,-0x40(%ebp)

		sfree(z);
  800393:	83 ec 0c             	sub    $0xc,%esp
  800396:	ff 75 c8             	pushl  -0x38(%ebp)
  800399:	e8 9e 16 00 00       	call   801a3c <sfree>
  80039e:	83 c4 10             	add    $0x10,%esp
		cprintf("Master env removed z\n");
  8003a1:	83 ec 0c             	sub    $0xc,%esp
  8003a4:	68 a8 37 80 00       	push   $0x8037a8
  8003a9:	e8 50 04 00 00       	call   8007fe <cprintf>
  8003ae:	83 c4 10             	add    $0x10,%esp

		sfree(x);
  8003b1:	83 ec 0c             	sub    $0xc,%esp
  8003b4:	ff 75 c4             	pushl  -0x3c(%ebp)
  8003b7:	e8 80 16 00 00       	call   801a3c <sfree>
  8003bc:	83 c4 10             	add    $0x10,%esp
		cprintf("Master env removed x\n");
  8003bf:	83 ec 0c             	sub    $0xc,%esp
  8003c2:	68 be 37 80 00       	push   $0x8037be
  8003c7:	e8 32 04 00 00       	call   8007fe <cprintf>
  8003cc:	83 c4 10             	add    $0x10,%esp

		int diff = (sys_calculate_free_frames() - freeFrames);
  8003cf:	e8 c8 17 00 00       	call   801b9c <sys_calculate_free_frames>
  8003d4:	89 c2                	mov    %eax,%edx
  8003d6:	8b 45 c0             	mov    -0x40(%ebp),%eax
  8003d9:	29 c2                	sub    %eax,%edx
  8003db:	89 d0                	mov    %edx,%eax
  8003dd:	89 45 bc             	mov    %eax,-0x44(%ebp)
		expected = 1;
  8003e0:	c7 45 e8 01 00 00 00 	movl   $0x1,-0x18(%ebp)
		if (diff !=  expected) panic("Wrong free: frames removed not equal 1 !, correct frames to be removed are 1:\nfrom the env: 1 table\nframes_storage of z & x: should NOT cleared yet (still in use!)\n");
  8003e7:	8b 45 bc             	mov    -0x44(%ebp),%eax
  8003ea:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  8003ed:	74 14                	je     800403 <_main+0x3cb>
  8003ef:	83 ec 04             	sub    $0x4,%esp
  8003f2:	68 d4 37 80 00       	push   $0x8037d4
  8003f7:	6a 62                	push   $0x62
  8003f9:	68 5c 34 80 00       	push   $0x80345c
  8003fe:	e8 47 01 00 00       	call   80054a <_panic>

		//To indicate that it's completed successfully
		inctst();
  800403:	e8 b2 1b 00 00       	call   801fba <inctst>


	}


	return;
  800408:	90                   	nop
}
  800409:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80040c:	c9                   	leave  
  80040d:	c3                   	ret    

0080040e <libmain>:
volatile struct Env *myEnv = NULL;
volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";

void
libmain(int argc, char **argv)
{
  80040e:	55                   	push   %ebp
  80040f:	89 e5                	mov    %esp,%ebp
  800411:	83 ec 18             	sub    $0x18,%esp
	int envIndex = sys_getenvindex();
  800414:	e8 63 1a 00 00       	call   801e7c <sys_getenvindex>
  800419:	89 45 f4             	mov    %eax,-0xc(%ebp)
	myEnv = &(envs[envIndex]);
  80041c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80041f:	89 d0                	mov    %edx,%eax
  800421:	c1 e0 03             	shl    $0x3,%eax
  800424:	01 d0                	add    %edx,%eax
  800426:	01 c0                	add    %eax,%eax
  800428:	01 d0                	add    %edx,%eax
  80042a:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800431:	01 d0                	add    %edx,%eax
  800433:	c1 e0 04             	shl    $0x4,%eax
  800436:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  80043b:	a3 20 50 80 00       	mov    %eax,0x805020

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  800440:	a1 20 50 80 00       	mov    0x805020,%eax
  800445:	8a 80 5c 05 00 00    	mov    0x55c(%eax),%al
  80044b:	84 c0                	test   %al,%al
  80044d:	74 0f                	je     80045e <libmain+0x50>
		binaryname = myEnv->prog_name;
  80044f:	a1 20 50 80 00       	mov    0x805020,%eax
  800454:	05 5c 05 00 00       	add    $0x55c,%eax
  800459:	a3 00 50 80 00       	mov    %eax,0x805000

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  80045e:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800462:	7e 0a                	jle    80046e <libmain+0x60>
		binaryname = argv[0];
  800464:	8b 45 0c             	mov    0xc(%ebp),%eax
  800467:	8b 00                	mov    (%eax),%eax
  800469:	a3 00 50 80 00       	mov    %eax,0x805000

	// call user main routine
	_main(argc, argv);
  80046e:	83 ec 08             	sub    $0x8,%esp
  800471:	ff 75 0c             	pushl  0xc(%ebp)
  800474:	ff 75 08             	pushl  0x8(%ebp)
  800477:	e8 bc fb ff ff       	call   800038 <_main>
  80047c:	83 c4 10             	add    $0x10,%esp



	sys_disable_interrupt();
  80047f:	e8 05 18 00 00       	call   801c89 <sys_disable_interrupt>
	cprintf("**************************************\n");
  800484:	83 ec 0c             	sub    $0xc,%esp
  800487:	68 94 38 80 00       	push   $0x803894
  80048c:	e8 6d 03 00 00       	call   8007fe <cprintf>
  800491:	83 c4 10             	add    $0x10,%esp
	cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  800494:	a1 20 50 80 00       	mov    0x805020,%eax
  800499:	8b 90 44 05 00 00    	mov    0x544(%eax),%edx
  80049f:	a1 20 50 80 00       	mov    0x805020,%eax
  8004a4:	8b 80 34 05 00 00    	mov    0x534(%eax),%eax
  8004aa:	83 ec 04             	sub    $0x4,%esp
  8004ad:	52                   	push   %edx
  8004ae:	50                   	push   %eax
  8004af:	68 bc 38 80 00       	push   $0x8038bc
  8004b4:	e8 45 03 00 00       	call   8007fe <cprintf>
  8004b9:	83 c4 10             	add    $0x10,%esp
	cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  8004bc:	a1 20 50 80 00       	mov    0x805020,%eax
  8004c1:	8b 88 54 05 00 00    	mov    0x554(%eax),%ecx
  8004c7:	a1 20 50 80 00       	mov    0x805020,%eax
  8004cc:	8b 90 50 05 00 00    	mov    0x550(%eax),%edx
  8004d2:	a1 20 50 80 00       	mov    0x805020,%eax
  8004d7:	8b 80 4c 05 00 00    	mov    0x54c(%eax),%eax
  8004dd:	51                   	push   %ecx
  8004de:	52                   	push   %edx
  8004df:	50                   	push   %eax
  8004e0:	68 e4 38 80 00       	push   $0x8038e4
  8004e5:	e8 14 03 00 00       	call   8007fe <cprintf>
  8004ea:	83 c4 10             	add    $0x10,%esp
	//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
	cprintf("Num of clocks = %d\n", myEnv->nClocks);
  8004ed:	a1 20 50 80 00       	mov    0x805020,%eax
  8004f2:	8b 80 a4 05 00 00    	mov    0x5a4(%eax),%eax
  8004f8:	83 ec 08             	sub    $0x8,%esp
  8004fb:	50                   	push   %eax
  8004fc:	68 3c 39 80 00       	push   $0x80393c
  800501:	e8 f8 02 00 00       	call   8007fe <cprintf>
  800506:	83 c4 10             	add    $0x10,%esp
	cprintf("**************************************\n");
  800509:	83 ec 0c             	sub    $0xc,%esp
  80050c:	68 94 38 80 00       	push   $0x803894
  800511:	e8 e8 02 00 00       	call   8007fe <cprintf>
  800516:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  800519:	e8 85 17 00 00       	call   801ca3 <sys_enable_interrupt>

	// exit gracefully
	exit();
  80051e:	e8 19 00 00 00       	call   80053c <exit>
}
  800523:	90                   	nop
  800524:	c9                   	leave  
  800525:	c3                   	ret    

00800526 <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  800526:	55                   	push   %ebp
  800527:	89 e5                	mov    %esp,%ebp
  800529:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  80052c:	83 ec 0c             	sub    $0xc,%esp
  80052f:	6a 00                	push   $0x0
  800531:	e8 12 19 00 00       	call   801e48 <sys_destroy_env>
  800536:	83 c4 10             	add    $0x10,%esp
}
  800539:	90                   	nop
  80053a:	c9                   	leave  
  80053b:	c3                   	ret    

0080053c <exit>:

void
exit(void)
{
  80053c:	55                   	push   %ebp
  80053d:	89 e5                	mov    %esp,%ebp
  80053f:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  800542:	e8 67 19 00 00       	call   801eae <sys_exit_env>
}
  800547:	90                   	nop
  800548:	c9                   	leave  
  800549:	c3                   	ret    

0080054a <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  80054a:	55                   	push   %ebp
  80054b:	89 e5                	mov    %esp,%ebp
  80054d:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  800550:	8d 45 10             	lea    0x10(%ebp),%eax
  800553:	83 c0 04             	add    $0x4,%eax
  800556:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  800559:	a1 5c 51 80 00       	mov    0x80515c,%eax
  80055e:	85 c0                	test   %eax,%eax
  800560:	74 16                	je     800578 <_panic+0x2e>
		cprintf("%s: ", argv0);
  800562:	a1 5c 51 80 00       	mov    0x80515c,%eax
  800567:	83 ec 08             	sub    $0x8,%esp
  80056a:	50                   	push   %eax
  80056b:	68 50 39 80 00       	push   $0x803950
  800570:	e8 89 02 00 00       	call   8007fe <cprintf>
  800575:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  800578:	a1 00 50 80 00       	mov    0x805000,%eax
  80057d:	ff 75 0c             	pushl  0xc(%ebp)
  800580:	ff 75 08             	pushl  0x8(%ebp)
  800583:	50                   	push   %eax
  800584:	68 55 39 80 00       	push   $0x803955
  800589:	e8 70 02 00 00       	call   8007fe <cprintf>
  80058e:	83 c4 10             	add    $0x10,%esp
	vcprintf(fmt, ap);
  800591:	8b 45 10             	mov    0x10(%ebp),%eax
  800594:	83 ec 08             	sub    $0x8,%esp
  800597:	ff 75 f4             	pushl  -0xc(%ebp)
  80059a:	50                   	push   %eax
  80059b:	e8 f3 01 00 00       	call   800793 <vcprintf>
  8005a0:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  8005a3:	83 ec 08             	sub    $0x8,%esp
  8005a6:	6a 00                	push   $0x0
  8005a8:	68 71 39 80 00       	push   $0x803971
  8005ad:	e8 e1 01 00 00       	call   800793 <vcprintf>
  8005b2:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  8005b5:	e8 82 ff ff ff       	call   80053c <exit>

	// should not return here
	while (1) ;
  8005ba:	eb fe                	jmp    8005ba <_panic+0x70>

008005bc <CheckWSWithoutLastIndex>:
}

void CheckWSWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  8005bc:	55                   	push   %ebp
  8005bd:	89 e5                	mov    %esp,%ebp
  8005bf:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  8005c2:	a1 20 50 80 00       	mov    0x805020,%eax
  8005c7:	8b 50 74             	mov    0x74(%eax),%edx
  8005ca:	8b 45 0c             	mov    0xc(%ebp),%eax
  8005cd:	39 c2                	cmp    %eax,%edx
  8005cf:	74 14                	je     8005e5 <CheckWSWithoutLastIndex+0x29>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  8005d1:	83 ec 04             	sub    $0x4,%esp
  8005d4:	68 74 39 80 00       	push   $0x803974
  8005d9:	6a 26                	push   $0x26
  8005db:	68 c0 39 80 00       	push   $0x8039c0
  8005e0:	e8 65 ff ff ff       	call   80054a <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  8005e5:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  8005ec:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  8005f3:	e9 c2 00 00 00       	jmp    8006ba <CheckWSWithoutLastIndex+0xfe>
		if (expectedPages[e] == 0) {
  8005f8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8005fb:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800602:	8b 45 08             	mov    0x8(%ebp),%eax
  800605:	01 d0                	add    %edx,%eax
  800607:	8b 00                	mov    (%eax),%eax
  800609:	85 c0                	test   %eax,%eax
  80060b:	75 08                	jne    800615 <CheckWSWithoutLastIndex+0x59>
			expectedNumOfEmptyLocs++;
  80060d:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  800610:	e9 a2 00 00 00       	jmp    8006b7 <CheckWSWithoutLastIndex+0xfb>
		}
		int found = 0;
  800615:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  80061c:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  800623:	eb 69                	jmp    80068e <CheckWSWithoutLastIndex+0xd2>
			if (myEnv->__uptr_pws[w].empty == 0) {
  800625:	a1 20 50 80 00       	mov    0x805020,%eax
  80062a:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  800630:	8b 55 e8             	mov    -0x18(%ebp),%edx
  800633:	89 d0                	mov    %edx,%eax
  800635:	01 c0                	add    %eax,%eax
  800637:	01 d0                	add    %edx,%eax
  800639:	c1 e0 03             	shl    $0x3,%eax
  80063c:	01 c8                	add    %ecx,%eax
  80063e:	8a 40 04             	mov    0x4(%eax),%al
  800641:	84 c0                	test   %al,%al
  800643:	75 46                	jne    80068b <CheckWSWithoutLastIndex+0xcf>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  800645:	a1 20 50 80 00       	mov    0x805020,%eax
  80064a:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  800650:	8b 55 e8             	mov    -0x18(%ebp),%edx
  800653:	89 d0                	mov    %edx,%eax
  800655:	01 c0                	add    %eax,%eax
  800657:	01 d0                	add    %edx,%eax
  800659:	c1 e0 03             	shl    $0x3,%eax
  80065c:	01 c8                	add    %ecx,%eax
  80065e:	8b 00                	mov    (%eax),%eax
  800660:	89 45 dc             	mov    %eax,-0x24(%ebp)
  800663:	8b 45 dc             	mov    -0x24(%ebp),%eax
  800666:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  80066b:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  80066d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800670:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  800677:	8b 45 08             	mov    0x8(%ebp),%eax
  80067a:	01 c8                	add    %ecx,%eax
  80067c:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  80067e:	39 c2                	cmp    %eax,%edx
  800680:	75 09                	jne    80068b <CheckWSWithoutLastIndex+0xcf>
						== expectedPages[e]) {
					found = 1;
  800682:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  800689:	eb 12                	jmp    80069d <CheckWSWithoutLastIndex+0xe1>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  80068b:	ff 45 e8             	incl   -0x18(%ebp)
  80068e:	a1 20 50 80 00       	mov    0x805020,%eax
  800693:	8b 50 74             	mov    0x74(%eax),%edx
  800696:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800699:	39 c2                	cmp    %eax,%edx
  80069b:	77 88                	ja     800625 <CheckWSWithoutLastIndex+0x69>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  80069d:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8006a1:	75 14                	jne    8006b7 <CheckWSWithoutLastIndex+0xfb>
			panic(
  8006a3:	83 ec 04             	sub    $0x4,%esp
  8006a6:	68 cc 39 80 00       	push   $0x8039cc
  8006ab:	6a 3a                	push   $0x3a
  8006ad:	68 c0 39 80 00       	push   $0x8039c0
  8006b2:	e8 93 fe ff ff       	call   80054a <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  8006b7:	ff 45 f0             	incl   -0x10(%ebp)
  8006ba:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8006bd:	3b 45 0c             	cmp    0xc(%ebp),%eax
  8006c0:	0f 8c 32 ff ff ff    	jl     8005f8 <CheckWSWithoutLastIndex+0x3c>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  8006c6:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8006cd:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  8006d4:	eb 26                	jmp    8006fc <CheckWSWithoutLastIndex+0x140>
		if (myEnv->__uptr_pws[w].empty == 1) {
  8006d6:	a1 20 50 80 00       	mov    0x805020,%eax
  8006db:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  8006e1:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8006e4:	89 d0                	mov    %edx,%eax
  8006e6:	01 c0                	add    %eax,%eax
  8006e8:	01 d0                	add    %edx,%eax
  8006ea:	c1 e0 03             	shl    $0x3,%eax
  8006ed:	01 c8                	add    %ecx,%eax
  8006ef:	8a 40 04             	mov    0x4(%eax),%al
  8006f2:	3c 01                	cmp    $0x1,%al
  8006f4:	75 03                	jne    8006f9 <CheckWSWithoutLastIndex+0x13d>
			actualNumOfEmptyLocs++;
  8006f6:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8006f9:	ff 45 e0             	incl   -0x20(%ebp)
  8006fc:	a1 20 50 80 00       	mov    0x805020,%eax
  800701:	8b 50 74             	mov    0x74(%eax),%edx
  800704:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800707:	39 c2                	cmp    %eax,%edx
  800709:	77 cb                	ja     8006d6 <CheckWSWithoutLastIndex+0x11a>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  80070b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80070e:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  800711:	74 14                	je     800727 <CheckWSWithoutLastIndex+0x16b>
		panic(
  800713:	83 ec 04             	sub    $0x4,%esp
  800716:	68 20 3a 80 00       	push   $0x803a20
  80071b:	6a 44                	push   $0x44
  80071d:	68 c0 39 80 00       	push   $0x8039c0
  800722:	e8 23 fe ff ff       	call   80054a <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  800727:	90                   	nop
  800728:	c9                   	leave  
  800729:	c3                   	ret    

0080072a <putch>:
};

//2017:
uint8 printProgName = 0;

static void putch(int ch, struct printbuf *b) {
  80072a:	55                   	push   %ebp
  80072b:	89 e5                	mov    %esp,%ebp
  80072d:	83 ec 08             	sub    $0x8,%esp
	b->buf[b->idx++] = ch;
  800730:	8b 45 0c             	mov    0xc(%ebp),%eax
  800733:	8b 00                	mov    (%eax),%eax
  800735:	8d 48 01             	lea    0x1(%eax),%ecx
  800738:	8b 55 0c             	mov    0xc(%ebp),%edx
  80073b:	89 0a                	mov    %ecx,(%edx)
  80073d:	8b 55 08             	mov    0x8(%ebp),%edx
  800740:	88 d1                	mov    %dl,%cl
  800742:	8b 55 0c             	mov    0xc(%ebp),%edx
  800745:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  800749:	8b 45 0c             	mov    0xc(%ebp),%eax
  80074c:	8b 00                	mov    (%eax),%eax
  80074e:	3d ff 00 00 00       	cmp    $0xff,%eax
  800753:	75 2c                	jne    800781 <putch+0x57>
		sys_cputs(b->buf, b->idx, printProgName);
  800755:	a0 24 50 80 00       	mov    0x805024,%al
  80075a:	0f b6 c0             	movzbl %al,%eax
  80075d:	8b 55 0c             	mov    0xc(%ebp),%edx
  800760:	8b 12                	mov    (%edx),%edx
  800762:	89 d1                	mov    %edx,%ecx
  800764:	8b 55 0c             	mov    0xc(%ebp),%edx
  800767:	83 c2 08             	add    $0x8,%edx
  80076a:	83 ec 04             	sub    $0x4,%esp
  80076d:	50                   	push   %eax
  80076e:	51                   	push   %ecx
  80076f:	52                   	push   %edx
  800770:	e8 66 13 00 00       	call   801adb <sys_cputs>
  800775:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  800778:	8b 45 0c             	mov    0xc(%ebp),%eax
  80077b:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  800781:	8b 45 0c             	mov    0xc(%ebp),%eax
  800784:	8b 40 04             	mov    0x4(%eax),%eax
  800787:	8d 50 01             	lea    0x1(%eax),%edx
  80078a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80078d:	89 50 04             	mov    %edx,0x4(%eax)
}
  800790:	90                   	nop
  800791:	c9                   	leave  
  800792:	c3                   	ret    

00800793 <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  800793:	55                   	push   %ebp
  800794:	89 e5                	mov    %esp,%ebp
  800796:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  80079c:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  8007a3:	00 00 00 
	b.cnt = 0;
  8007a6:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  8007ad:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  8007b0:	ff 75 0c             	pushl  0xc(%ebp)
  8007b3:	ff 75 08             	pushl  0x8(%ebp)
  8007b6:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  8007bc:	50                   	push   %eax
  8007bd:	68 2a 07 80 00       	push   $0x80072a
  8007c2:	e8 11 02 00 00       	call   8009d8 <vprintfmt>
  8007c7:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName);
  8007ca:	a0 24 50 80 00       	mov    0x805024,%al
  8007cf:	0f b6 c0             	movzbl %al,%eax
  8007d2:	8b 95 f0 fe ff ff    	mov    -0x110(%ebp),%edx
  8007d8:	83 ec 04             	sub    $0x4,%esp
  8007db:	50                   	push   %eax
  8007dc:	52                   	push   %edx
  8007dd:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  8007e3:	83 c0 08             	add    $0x8,%eax
  8007e6:	50                   	push   %eax
  8007e7:	e8 ef 12 00 00       	call   801adb <sys_cputs>
  8007ec:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  8007ef:	c6 05 24 50 80 00 00 	movb   $0x0,0x805024
	return b.cnt;
  8007f6:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  8007fc:	c9                   	leave  
  8007fd:	c3                   	ret    

008007fe <cprintf>:

int cprintf(const char *fmt, ...) {
  8007fe:	55                   	push   %ebp
  8007ff:	89 e5                	mov    %esp,%ebp
  800801:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  800804:	c6 05 24 50 80 00 01 	movb   $0x1,0x805024
	va_start(ap, fmt);
  80080b:	8d 45 0c             	lea    0xc(%ebp),%eax
  80080e:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800811:	8b 45 08             	mov    0x8(%ebp),%eax
  800814:	83 ec 08             	sub    $0x8,%esp
  800817:	ff 75 f4             	pushl  -0xc(%ebp)
  80081a:	50                   	push   %eax
  80081b:	e8 73 ff ff ff       	call   800793 <vcprintf>
  800820:	83 c4 10             	add    $0x10,%esp
  800823:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  800826:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800829:	c9                   	leave  
  80082a:	c3                   	ret    

0080082b <atomic_cprintf>:

int atomic_cprintf(const char *fmt, ...) {
  80082b:	55                   	push   %ebp
  80082c:	89 e5                	mov    %esp,%ebp
  80082e:	83 ec 18             	sub    $0x18,%esp
	sys_disable_interrupt();
  800831:	e8 53 14 00 00       	call   801c89 <sys_disable_interrupt>
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  800836:	8d 45 0c             	lea    0xc(%ebp),%eax
  800839:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  80083c:	8b 45 08             	mov    0x8(%ebp),%eax
  80083f:	83 ec 08             	sub    $0x8,%esp
  800842:	ff 75 f4             	pushl  -0xc(%ebp)
  800845:	50                   	push   %eax
  800846:	e8 48 ff ff ff       	call   800793 <vcprintf>
  80084b:	83 c4 10             	add    $0x10,%esp
  80084e:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	sys_enable_interrupt();
  800851:	e8 4d 14 00 00       	call   801ca3 <sys_enable_interrupt>
	return cnt;
  800856:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800859:	c9                   	leave  
  80085a:	c3                   	ret    

0080085b <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  80085b:	55                   	push   %ebp
  80085c:	89 e5                	mov    %esp,%ebp
  80085e:	53                   	push   %ebx
  80085f:	83 ec 14             	sub    $0x14,%esp
  800862:	8b 45 10             	mov    0x10(%ebp),%eax
  800865:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800868:	8b 45 14             	mov    0x14(%ebp),%eax
  80086b:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  80086e:	8b 45 18             	mov    0x18(%ebp),%eax
  800871:	ba 00 00 00 00       	mov    $0x0,%edx
  800876:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800879:	77 55                	ja     8008d0 <printnum+0x75>
  80087b:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  80087e:	72 05                	jb     800885 <printnum+0x2a>
  800880:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  800883:	77 4b                	ja     8008d0 <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800885:	8b 45 1c             	mov    0x1c(%ebp),%eax
  800888:	8d 58 ff             	lea    -0x1(%eax),%ebx
  80088b:	8b 45 18             	mov    0x18(%ebp),%eax
  80088e:	ba 00 00 00 00       	mov    $0x0,%edx
  800893:	52                   	push   %edx
  800894:	50                   	push   %eax
  800895:	ff 75 f4             	pushl  -0xc(%ebp)
  800898:	ff 75 f0             	pushl  -0x10(%ebp)
  80089b:	e8 38 29 00 00       	call   8031d8 <__udivdi3>
  8008a0:	83 c4 10             	add    $0x10,%esp
  8008a3:	83 ec 04             	sub    $0x4,%esp
  8008a6:	ff 75 20             	pushl  0x20(%ebp)
  8008a9:	53                   	push   %ebx
  8008aa:	ff 75 18             	pushl  0x18(%ebp)
  8008ad:	52                   	push   %edx
  8008ae:	50                   	push   %eax
  8008af:	ff 75 0c             	pushl  0xc(%ebp)
  8008b2:	ff 75 08             	pushl  0x8(%ebp)
  8008b5:	e8 a1 ff ff ff       	call   80085b <printnum>
  8008ba:	83 c4 20             	add    $0x20,%esp
  8008bd:	eb 1a                	jmp    8008d9 <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  8008bf:	83 ec 08             	sub    $0x8,%esp
  8008c2:	ff 75 0c             	pushl  0xc(%ebp)
  8008c5:	ff 75 20             	pushl  0x20(%ebp)
  8008c8:	8b 45 08             	mov    0x8(%ebp),%eax
  8008cb:	ff d0                	call   *%eax
  8008cd:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  8008d0:	ff 4d 1c             	decl   0x1c(%ebp)
  8008d3:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  8008d7:	7f e6                	jg     8008bf <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  8008d9:	8b 4d 18             	mov    0x18(%ebp),%ecx
  8008dc:	bb 00 00 00 00       	mov    $0x0,%ebx
  8008e1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8008e4:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8008e7:	53                   	push   %ebx
  8008e8:	51                   	push   %ecx
  8008e9:	52                   	push   %edx
  8008ea:	50                   	push   %eax
  8008eb:	e8 f8 29 00 00       	call   8032e8 <__umoddi3>
  8008f0:	83 c4 10             	add    $0x10,%esp
  8008f3:	05 94 3c 80 00       	add    $0x803c94,%eax
  8008f8:	8a 00                	mov    (%eax),%al
  8008fa:	0f be c0             	movsbl %al,%eax
  8008fd:	83 ec 08             	sub    $0x8,%esp
  800900:	ff 75 0c             	pushl  0xc(%ebp)
  800903:	50                   	push   %eax
  800904:	8b 45 08             	mov    0x8(%ebp),%eax
  800907:	ff d0                	call   *%eax
  800909:	83 c4 10             	add    $0x10,%esp
}
  80090c:	90                   	nop
  80090d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800910:	c9                   	leave  
  800911:	c3                   	ret    

00800912 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  800912:	55                   	push   %ebp
  800913:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800915:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800919:	7e 1c                	jle    800937 <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  80091b:	8b 45 08             	mov    0x8(%ebp),%eax
  80091e:	8b 00                	mov    (%eax),%eax
  800920:	8d 50 08             	lea    0x8(%eax),%edx
  800923:	8b 45 08             	mov    0x8(%ebp),%eax
  800926:	89 10                	mov    %edx,(%eax)
  800928:	8b 45 08             	mov    0x8(%ebp),%eax
  80092b:	8b 00                	mov    (%eax),%eax
  80092d:	83 e8 08             	sub    $0x8,%eax
  800930:	8b 50 04             	mov    0x4(%eax),%edx
  800933:	8b 00                	mov    (%eax),%eax
  800935:	eb 40                	jmp    800977 <getuint+0x65>
	else if (lflag)
  800937:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80093b:	74 1e                	je     80095b <getuint+0x49>
		return va_arg(*ap, unsigned long);
  80093d:	8b 45 08             	mov    0x8(%ebp),%eax
  800940:	8b 00                	mov    (%eax),%eax
  800942:	8d 50 04             	lea    0x4(%eax),%edx
  800945:	8b 45 08             	mov    0x8(%ebp),%eax
  800948:	89 10                	mov    %edx,(%eax)
  80094a:	8b 45 08             	mov    0x8(%ebp),%eax
  80094d:	8b 00                	mov    (%eax),%eax
  80094f:	83 e8 04             	sub    $0x4,%eax
  800952:	8b 00                	mov    (%eax),%eax
  800954:	ba 00 00 00 00       	mov    $0x0,%edx
  800959:	eb 1c                	jmp    800977 <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  80095b:	8b 45 08             	mov    0x8(%ebp),%eax
  80095e:	8b 00                	mov    (%eax),%eax
  800960:	8d 50 04             	lea    0x4(%eax),%edx
  800963:	8b 45 08             	mov    0x8(%ebp),%eax
  800966:	89 10                	mov    %edx,(%eax)
  800968:	8b 45 08             	mov    0x8(%ebp),%eax
  80096b:	8b 00                	mov    (%eax),%eax
  80096d:	83 e8 04             	sub    $0x4,%eax
  800970:	8b 00                	mov    (%eax),%eax
  800972:	ba 00 00 00 00       	mov    $0x0,%edx
}
  800977:	5d                   	pop    %ebp
  800978:	c3                   	ret    

00800979 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  800979:	55                   	push   %ebp
  80097a:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  80097c:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800980:	7e 1c                	jle    80099e <getint+0x25>
		return va_arg(*ap, long long);
  800982:	8b 45 08             	mov    0x8(%ebp),%eax
  800985:	8b 00                	mov    (%eax),%eax
  800987:	8d 50 08             	lea    0x8(%eax),%edx
  80098a:	8b 45 08             	mov    0x8(%ebp),%eax
  80098d:	89 10                	mov    %edx,(%eax)
  80098f:	8b 45 08             	mov    0x8(%ebp),%eax
  800992:	8b 00                	mov    (%eax),%eax
  800994:	83 e8 08             	sub    $0x8,%eax
  800997:	8b 50 04             	mov    0x4(%eax),%edx
  80099a:	8b 00                	mov    (%eax),%eax
  80099c:	eb 38                	jmp    8009d6 <getint+0x5d>
	else if (lflag)
  80099e:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8009a2:	74 1a                	je     8009be <getint+0x45>
		return va_arg(*ap, long);
  8009a4:	8b 45 08             	mov    0x8(%ebp),%eax
  8009a7:	8b 00                	mov    (%eax),%eax
  8009a9:	8d 50 04             	lea    0x4(%eax),%edx
  8009ac:	8b 45 08             	mov    0x8(%ebp),%eax
  8009af:	89 10                	mov    %edx,(%eax)
  8009b1:	8b 45 08             	mov    0x8(%ebp),%eax
  8009b4:	8b 00                	mov    (%eax),%eax
  8009b6:	83 e8 04             	sub    $0x4,%eax
  8009b9:	8b 00                	mov    (%eax),%eax
  8009bb:	99                   	cltd   
  8009bc:	eb 18                	jmp    8009d6 <getint+0x5d>
	else
		return va_arg(*ap, int);
  8009be:	8b 45 08             	mov    0x8(%ebp),%eax
  8009c1:	8b 00                	mov    (%eax),%eax
  8009c3:	8d 50 04             	lea    0x4(%eax),%edx
  8009c6:	8b 45 08             	mov    0x8(%ebp),%eax
  8009c9:	89 10                	mov    %edx,(%eax)
  8009cb:	8b 45 08             	mov    0x8(%ebp),%eax
  8009ce:	8b 00                	mov    (%eax),%eax
  8009d0:	83 e8 04             	sub    $0x4,%eax
  8009d3:	8b 00                	mov    (%eax),%eax
  8009d5:	99                   	cltd   
}
  8009d6:	5d                   	pop    %ebp
  8009d7:	c3                   	ret    

008009d8 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  8009d8:	55                   	push   %ebp
  8009d9:	89 e5                	mov    %esp,%ebp
  8009db:	56                   	push   %esi
  8009dc:	53                   	push   %ebx
  8009dd:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8009e0:	eb 17                	jmp    8009f9 <vprintfmt+0x21>
			if (ch == '\0')
  8009e2:	85 db                	test   %ebx,%ebx
  8009e4:	0f 84 af 03 00 00    	je     800d99 <vprintfmt+0x3c1>
				return;
			putch(ch, putdat);
  8009ea:	83 ec 08             	sub    $0x8,%esp
  8009ed:	ff 75 0c             	pushl  0xc(%ebp)
  8009f0:	53                   	push   %ebx
  8009f1:	8b 45 08             	mov    0x8(%ebp),%eax
  8009f4:	ff d0                	call   *%eax
  8009f6:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8009f9:	8b 45 10             	mov    0x10(%ebp),%eax
  8009fc:	8d 50 01             	lea    0x1(%eax),%edx
  8009ff:	89 55 10             	mov    %edx,0x10(%ebp)
  800a02:	8a 00                	mov    (%eax),%al
  800a04:	0f b6 d8             	movzbl %al,%ebx
  800a07:	83 fb 25             	cmp    $0x25,%ebx
  800a0a:	75 d6                	jne    8009e2 <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  800a0c:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  800a10:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  800a17:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  800a1e:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  800a25:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800a2c:	8b 45 10             	mov    0x10(%ebp),%eax
  800a2f:	8d 50 01             	lea    0x1(%eax),%edx
  800a32:	89 55 10             	mov    %edx,0x10(%ebp)
  800a35:	8a 00                	mov    (%eax),%al
  800a37:	0f b6 d8             	movzbl %al,%ebx
  800a3a:	8d 43 dd             	lea    -0x23(%ebx),%eax
  800a3d:	83 f8 55             	cmp    $0x55,%eax
  800a40:	0f 87 2b 03 00 00    	ja     800d71 <vprintfmt+0x399>
  800a46:	8b 04 85 b8 3c 80 00 	mov    0x803cb8(,%eax,4),%eax
  800a4d:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  800a4f:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  800a53:	eb d7                	jmp    800a2c <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  800a55:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  800a59:	eb d1                	jmp    800a2c <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800a5b:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  800a62:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800a65:	89 d0                	mov    %edx,%eax
  800a67:	c1 e0 02             	shl    $0x2,%eax
  800a6a:	01 d0                	add    %edx,%eax
  800a6c:	01 c0                	add    %eax,%eax
  800a6e:	01 d8                	add    %ebx,%eax
  800a70:	83 e8 30             	sub    $0x30,%eax
  800a73:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  800a76:	8b 45 10             	mov    0x10(%ebp),%eax
  800a79:	8a 00                	mov    (%eax),%al
  800a7b:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  800a7e:	83 fb 2f             	cmp    $0x2f,%ebx
  800a81:	7e 3e                	jle    800ac1 <vprintfmt+0xe9>
  800a83:	83 fb 39             	cmp    $0x39,%ebx
  800a86:	7f 39                	jg     800ac1 <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800a88:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  800a8b:	eb d5                	jmp    800a62 <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  800a8d:	8b 45 14             	mov    0x14(%ebp),%eax
  800a90:	83 c0 04             	add    $0x4,%eax
  800a93:	89 45 14             	mov    %eax,0x14(%ebp)
  800a96:	8b 45 14             	mov    0x14(%ebp),%eax
  800a99:	83 e8 04             	sub    $0x4,%eax
  800a9c:	8b 00                	mov    (%eax),%eax
  800a9e:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  800aa1:	eb 1f                	jmp    800ac2 <vprintfmt+0xea>

		case '.':
			if (width < 0)
  800aa3:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800aa7:	79 83                	jns    800a2c <vprintfmt+0x54>
				width = 0;
  800aa9:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  800ab0:	e9 77 ff ff ff       	jmp    800a2c <vprintfmt+0x54>

		case '#':
			altflag = 1;
  800ab5:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  800abc:	e9 6b ff ff ff       	jmp    800a2c <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  800ac1:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  800ac2:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800ac6:	0f 89 60 ff ff ff    	jns    800a2c <vprintfmt+0x54>
				width = precision, precision = -1;
  800acc:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800acf:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800ad2:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  800ad9:	e9 4e ff ff ff       	jmp    800a2c <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  800ade:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  800ae1:	e9 46 ff ff ff       	jmp    800a2c <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  800ae6:	8b 45 14             	mov    0x14(%ebp),%eax
  800ae9:	83 c0 04             	add    $0x4,%eax
  800aec:	89 45 14             	mov    %eax,0x14(%ebp)
  800aef:	8b 45 14             	mov    0x14(%ebp),%eax
  800af2:	83 e8 04             	sub    $0x4,%eax
  800af5:	8b 00                	mov    (%eax),%eax
  800af7:	83 ec 08             	sub    $0x8,%esp
  800afa:	ff 75 0c             	pushl  0xc(%ebp)
  800afd:	50                   	push   %eax
  800afe:	8b 45 08             	mov    0x8(%ebp),%eax
  800b01:	ff d0                	call   *%eax
  800b03:	83 c4 10             	add    $0x10,%esp
			break;
  800b06:	e9 89 02 00 00       	jmp    800d94 <vprintfmt+0x3bc>

		// error message
		case 'e':
			err = va_arg(ap, int);
  800b0b:	8b 45 14             	mov    0x14(%ebp),%eax
  800b0e:	83 c0 04             	add    $0x4,%eax
  800b11:	89 45 14             	mov    %eax,0x14(%ebp)
  800b14:	8b 45 14             	mov    0x14(%ebp),%eax
  800b17:	83 e8 04             	sub    $0x4,%eax
  800b1a:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  800b1c:	85 db                	test   %ebx,%ebx
  800b1e:	79 02                	jns    800b22 <vprintfmt+0x14a>
				err = -err;
  800b20:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  800b22:	83 fb 64             	cmp    $0x64,%ebx
  800b25:	7f 0b                	jg     800b32 <vprintfmt+0x15a>
  800b27:	8b 34 9d 00 3b 80 00 	mov    0x803b00(,%ebx,4),%esi
  800b2e:	85 f6                	test   %esi,%esi
  800b30:	75 19                	jne    800b4b <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  800b32:	53                   	push   %ebx
  800b33:	68 a5 3c 80 00       	push   $0x803ca5
  800b38:	ff 75 0c             	pushl  0xc(%ebp)
  800b3b:	ff 75 08             	pushl  0x8(%ebp)
  800b3e:	e8 5e 02 00 00       	call   800da1 <printfmt>
  800b43:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  800b46:	e9 49 02 00 00       	jmp    800d94 <vprintfmt+0x3bc>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  800b4b:	56                   	push   %esi
  800b4c:	68 ae 3c 80 00       	push   $0x803cae
  800b51:	ff 75 0c             	pushl  0xc(%ebp)
  800b54:	ff 75 08             	pushl  0x8(%ebp)
  800b57:	e8 45 02 00 00       	call   800da1 <printfmt>
  800b5c:	83 c4 10             	add    $0x10,%esp
			break;
  800b5f:	e9 30 02 00 00       	jmp    800d94 <vprintfmt+0x3bc>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  800b64:	8b 45 14             	mov    0x14(%ebp),%eax
  800b67:	83 c0 04             	add    $0x4,%eax
  800b6a:	89 45 14             	mov    %eax,0x14(%ebp)
  800b6d:	8b 45 14             	mov    0x14(%ebp),%eax
  800b70:	83 e8 04             	sub    $0x4,%eax
  800b73:	8b 30                	mov    (%eax),%esi
  800b75:	85 f6                	test   %esi,%esi
  800b77:	75 05                	jne    800b7e <vprintfmt+0x1a6>
				p = "(null)";
  800b79:	be b1 3c 80 00       	mov    $0x803cb1,%esi
			if (width > 0 && padc != '-')
  800b7e:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800b82:	7e 6d                	jle    800bf1 <vprintfmt+0x219>
  800b84:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  800b88:	74 67                	je     800bf1 <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  800b8a:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800b8d:	83 ec 08             	sub    $0x8,%esp
  800b90:	50                   	push   %eax
  800b91:	56                   	push   %esi
  800b92:	e8 0c 03 00 00       	call   800ea3 <strnlen>
  800b97:	83 c4 10             	add    $0x10,%esp
  800b9a:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  800b9d:	eb 16                	jmp    800bb5 <vprintfmt+0x1dd>
					putch(padc, putdat);
  800b9f:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  800ba3:	83 ec 08             	sub    $0x8,%esp
  800ba6:	ff 75 0c             	pushl  0xc(%ebp)
  800ba9:	50                   	push   %eax
  800baa:	8b 45 08             	mov    0x8(%ebp),%eax
  800bad:	ff d0                	call   *%eax
  800baf:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800bb2:	ff 4d e4             	decl   -0x1c(%ebp)
  800bb5:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800bb9:	7f e4                	jg     800b9f <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800bbb:	eb 34                	jmp    800bf1 <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  800bbd:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  800bc1:	74 1c                	je     800bdf <vprintfmt+0x207>
  800bc3:	83 fb 1f             	cmp    $0x1f,%ebx
  800bc6:	7e 05                	jle    800bcd <vprintfmt+0x1f5>
  800bc8:	83 fb 7e             	cmp    $0x7e,%ebx
  800bcb:	7e 12                	jle    800bdf <vprintfmt+0x207>
					putch('?', putdat);
  800bcd:	83 ec 08             	sub    $0x8,%esp
  800bd0:	ff 75 0c             	pushl  0xc(%ebp)
  800bd3:	6a 3f                	push   $0x3f
  800bd5:	8b 45 08             	mov    0x8(%ebp),%eax
  800bd8:	ff d0                	call   *%eax
  800bda:	83 c4 10             	add    $0x10,%esp
  800bdd:	eb 0f                	jmp    800bee <vprintfmt+0x216>
				else
					putch(ch, putdat);
  800bdf:	83 ec 08             	sub    $0x8,%esp
  800be2:	ff 75 0c             	pushl  0xc(%ebp)
  800be5:	53                   	push   %ebx
  800be6:	8b 45 08             	mov    0x8(%ebp),%eax
  800be9:	ff d0                	call   *%eax
  800beb:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800bee:	ff 4d e4             	decl   -0x1c(%ebp)
  800bf1:	89 f0                	mov    %esi,%eax
  800bf3:	8d 70 01             	lea    0x1(%eax),%esi
  800bf6:	8a 00                	mov    (%eax),%al
  800bf8:	0f be d8             	movsbl %al,%ebx
  800bfb:	85 db                	test   %ebx,%ebx
  800bfd:	74 24                	je     800c23 <vprintfmt+0x24b>
  800bff:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800c03:	78 b8                	js     800bbd <vprintfmt+0x1e5>
  800c05:	ff 4d e0             	decl   -0x20(%ebp)
  800c08:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800c0c:	79 af                	jns    800bbd <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800c0e:	eb 13                	jmp    800c23 <vprintfmt+0x24b>
				putch(' ', putdat);
  800c10:	83 ec 08             	sub    $0x8,%esp
  800c13:	ff 75 0c             	pushl  0xc(%ebp)
  800c16:	6a 20                	push   $0x20
  800c18:	8b 45 08             	mov    0x8(%ebp),%eax
  800c1b:	ff d0                	call   *%eax
  800c1d:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800c20:	ff 4d e4             	decl   -0x1c(%ebp)
  800c23:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800c27:	7f e7                	jg     800c10 <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  800c29:	e9 66 01 00 00       	jmp    800d94 <vprintfmt+0x3bc>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  800c2e:	83 ec 08             	sub    $0x8,%esp
  800c31:	ff 75 e8             	pushl  -0x18(%ebp)
  800c34:	8d 45 14             	lea    0x14(%ebp),%eax
  800c37:	50                   	push   %eax
  800c38:	e8 3c fd ff ff       	call   800979 <getint>
  800c3d:	83 c4 10             	add    $0x10,%esp
  800c40:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800c43:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  800c46:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800c49:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800c4c:	85 d2                	test   %edx,%edx
  800c4e:	79 23                	jns    800c73 <vprintfmt+0x29b>
				putch('-', putdat);
  800c50:	83 ec 08             	sub    $0x8,%esp
  800c53:	ff 75 0c             	pushl  0xc(%ebp)
  800c56:	6a 2d                	push   $0x2d
  800c58:	8b 45 08             	mov    0x8(%ebp),%eax
  800c5b:	ff d0                	call   *%eax
  800c5d:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  800c60:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800c63:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800c66:	f7 d8                	neg    %eax
  800c68:	83 d2 00             	adc    $0x0,%edx
  800c6b:	f7 da                	neg    %edx
  800c6d:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800c70:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  800c73:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800c7a:	e9 bc 00 00 00       	jmp    800d3b <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  800c7f:	83 ec 08             	sub    $0x8,%esp
  800c82:	ff 75 e8             	pushl  -0x18(%ebp)
  800c85:	8d 45 14             	lea    0x14(%ebp),%eax
  800c88:	50                   	push   %eax
  800c89:	e8 84 fc ff ff       	call   800912 <getuint>
  800c8e:	83 c4 10             	add    $0x10,%esp
  800c91:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800c94:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  800c97:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800c9e:	e9 98 00 00 00       	jmp    800d3b <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  800ca3:	83 ec 08             	sub    $0x8,%esp
  800ca6:	ff 75 0c             	pushl  0xc(%ebp)
  800ca9:	6a 58                	push   $0x58
  800cab:	8b 45 08             	mov    0x8(%ebp),%eax
  800cae:	ff d0                	call   *%eax
  800cb0:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800cb3:	83 ec 08             	sub    $0x8,%esp
  800cb6:	ff 75 0c             	pushl  0xc(%ebp)
  800cb9:	6a 58                	push   $0x58
  800cbb:	8b 45 08             	mov    0x8(%ebp),%eax
  800cbe:	ff d0                	call   *%eax
  800cc0:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800cc3:	83 ec 08             	sub    $0x8,%esp
  800cc6:	ff 75 0c             	pushl  0xc(%ebp)
  800cc9:	6a 58                	push   $0x58
  800ccb:	8b 45 08             	mov    0x8(%ebp),%eax
  800cce:	ff d0                	call   *%eax
  800cd0:	83 c4 10             	add    $0x10,%esp
			break;
  800cd3:	e9 bc 00 00 00       	jmp    800d94 <vprintfmt+0x3bc>

		// pointer
		case 'p':
			putch('0', putdat);
  800cd8:	83 ec 08             	sub    $0x8,%esp
  800cdb:	ff 75 0c             	pushl  0xc(%ebp)
  800cde:	6a 30                	push   $0x30
  800ce0:	8b 45 08             	mov    0x8(%ebp),%eax
  800ce3:	ff d0                	call   *%eax
  800ce5:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  800ce8:	83 ec 08             	sub    $0x8,%esp
  800ceb:	ff 75 0c             	pushl  0xc(%ebp)
  800cee:	6a 78                	push   $0x78
  800cf0:	8b 45 08             	mov    0x8(%ebp),%eax
  800cf3:	ff d0                	call   *%eax
  800cf5:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  800cf8:	8b 45 14             	mov    0x14(%ebp),%eax
  800cfb:	83 c0 04             	add    $0x4,%eax
  800cfe:	89 45 14             	mov    %eax,0x14(%ebp)
  800d01:	8b 45 14             	mov    0x14(%ebp),%eax
  800d04:	83 e8 04             	sub    $0x4,%eax
  800d07:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800d09:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800d0c:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  800d13:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  800d1a:	eb 1f                	jmp    800d3b <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  800d1c:	83 ec 08             	sub    $0x8,%esp
  800d1f:	ff 75 e8             	pushl  -0x18(%ebp)
  800d22:	8d 45 14             	lea    0x14(%ebp),%eax
  800d25:	50                   	push   %eax
  800d26:	e8 e7 fb ff ff       	call   800912 <getuint>
  800d2b:	83 c4 10             	add    $0x10,%esp
  800d2e:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800d31:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  800d34:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800d3b:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  800d3f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800d42:	83 ec 04             	sub    $0x4,%esp
  800d45:	52                   	push   %edx
  800d46:	ff 75 e4             	pushl  -0x1c(%ebp)
  800d49:	50                   	push   %eax
  800d4a:	ff 75 f4             	pushl  -0xc(%ebp)
  800d4d:	ff 75 f0             	pushl  -0x10(%ebp)
  800d50:	ff 75 0c             	pushl  0xc(%ebp)
  800d53:	ff 75 08             	pushl  0x8(%ebp)
  800d56:	e8 00 fb ff ff       	call   80085b <printnum>
  800d5b:	83 c4 20             	add    $0x20,%esp
			break;
  800d5e:	eb 34                	jmp    800d94 <vprintfmt+0x3bc>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  800d60:	83 ec 08             	sub    $0x8,%esp
  800d63:	ff 75 0c             	pushl  0xc(%ebp)
  800d66:	53                   	push   %ebx
  800d67:	8b 45 08             	mov    0x8(%ebp),%eax
  800d6a:	ff d0                	call   *%eax
  800d6c:	83 c4 10             	add    $0x10,%esp
			break;
  800d6f:	eb 23                	jmp    800d94 <vprintfmt+0x3bc>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800d71:	83 ec 08             	sub    $0x8,%esp
  800d74:	ff 75 0c             	pushl  0xc(%ebp)
  800d77:	6a 25                	push   $0x25
  800d79:	8b 45 08             	mov    0x8(%ebp),%eax
  800d7c:	ff d0                	call   *%eax
  800d7e:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  800d81:	ff 4d 10             	decl   0x10(%ebp)
  800d84:	eb 03                	jmp    800d89 <vprintfmt+0x3b1>
  800d86:	ff 4d 10             	decl   0x10(%ebp)
  800d89:	8b 45 10             	mov    0x10(%ebp),%eax
  800d8c:	48                   	dec    %eax
  800d8d:	8a 00                	mov    (%eax),%al
  800d8f:	3c 25                	cmp    $0x25,%al
  800d91:	75 f3                	jne    800d86 <vprintfmt+0x3ae>
				/* do nothing */;
			break;
  800d93:	90                   	nop
		}
	}
  800d94:	e9 47 fc ff ff       	jmp    8009e0 <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  800d99:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  800d9a:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800d9d:	5b                   	pop    %ebx
  800d9e:	5e                   	pop    %esi
  800d9f:	5d                   	pop    %ebp
  800da0:	c3                   	ret    

00800da1 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800da1:	55                   	push   %ebp
  800da2:	89 e5                	mov    %esp,%ebp
  800da4:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  800da7:	8d 45 10             	lea    0x10(%ebp),%eax
  800daa:	83 c0 04             	add    $0x4,%eax
  800dad:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  800db0:	8b 45 10             	mov    0x10(%ebp),%eax
  800db3:	ff 75 f4             	pushl  -0xc(%ebp)
  800db6:	50                   	push   %eax
  800db7:	ff 75 0c             	pushl  0xc(%ebp)
  800dba:	ff 75 08             	pushl  0x8(%ebp)
  800dbd:	e8 16 fc ff ff       	call   8009d8 <vprintfmt>
  800dc2:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  800dc5:	90                   	nop
  800dc6:	c9                   	leave  
  800dc7:	c3                   	ret    

00800dc8 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800dc8:	55                   	push   %ebp
  800dc9:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  800dcb:	8b 45 0c             	mov    0xc(%ebp),%eax
  800dce:	8b 40 08             	mov    0x8(%eax),%eax
  800dd1:	8d 50 01             	lea    0x1(%eax),%edx
  800dd4:	8b 45 0c             	mov    0xc(%ebp),%eax
  800dd7:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  800dda:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ddd:	8b 10                	mov    (%eax),%edx
  800ddf:	8b 45 0c             	mov    0xc(%ebp),%eax
  800de2:	8b 40 04             	mov    0x4(%eax),%eax
  800de5:	39 c2                	cmp    %eax,%edx
  800de7:	73 12                	jae    800dfb <sprintputch+0x33>
		*b->buf++ = ch;
  800de9:	8b 45 0c             	mov    0xc(%ebp),%eax
  800dec:	8b 00                	mov    (%eax),%eax
  800dee:	8d 48 01             	lea    0x1(%eax),%ecx
  800df1:	8b 55 0c             	mov    0xc(%ebp),%edx
  800df4:	89 0a                	mov    %ecx,(%edx)
  800df6:	8b 55 08             	mov    0x8(%ebp),%edx
  800df9:	88 10                	mov    %dl,(%eax)
}
  800dfb:	90                   	nop
  800dfc:	5d                   	pop    %ebp
  800dfd:	c3                   	ret    

00800dfe <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800dfe:	55                   	push   %ebp
  800dff:	89 e5                	mov    %esp,%ebp
  800e01:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  800e04:	8b 45 08             	mov    0x8(%ebp),%eax
  800e07:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800e0a:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e0d:	8d 50 ff             	lea    -0x1(%eax),%edx
  800e10:	8b 45 08             	mov    0x8(%ebp),%eax
  800e13:	01 d0                	add    %edx,%eax
  800e15:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800e18:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800e1f:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800e23:	74 06                	je     800e2b <vsnprintf+0x2d>
  800e25:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800e29:	7f 07                	jg     800e32 <vsnprintf+0x34>
		return -E_INVAL;
  800e2b:	b8 03 00 00 00       	mov    $0x3,%eax
  800e30:	eb 20                	jmp    800e52 <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800e32:	ff 75 14             	pushl  0x14(%ebp)
  800e35:	ff 75 10             	pushl  0x10(%ebp)
  800e38:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800e3b:	50                   	push   %eax
  800e3c:	68 c8 0d 80 00       	push   $0x800dc8
  800e41:	e8 92 fb ff ff       	call   8009d8 <vprintfmt>
  800e46:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  800e49:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800e4c:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800e4f:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  800e52:	c9                   	leave  
  800e53:	c3                   	ret    

00800e54 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800e54:	55                   	push   %ebp
  800e55:	89 e5                	mov    %esp,%ebp
  800e57:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800e5a:	8d 45 10             	lea    0x10(%ebp),%eax
  800e5d:	83 c0 04             	add    $0x4,%eax
  800e60:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  800e63:	8b 45 10             	mov    0x10(%ebp),%eax
  800e66:	ff 75 f4             	pushl  -0xc(%ebp)
  800e69:	50                   	push   %eax
  800e6a:	ff 75 0c             	pushl  0xc(%ebp)
  800e6d:	ff 75 08             	pushl  0x8(%ebp)
  800e70:	e8 89 ff ff ff       	call   800dfe <vsnprintf>
  800e75:	83 c4 10             	add    $0x10,%esp
  800e78:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  800e7b:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800e7e:	c9                   	leave  
  800e7f:	c3                   	ret    

00800e80 <strlen>:

#include <inc/string.h>

int
strlen(const char *s)
{
  800e80:	55                   	push   %ebp
  800e81:	89 e5                	mov    %esp,%ebp
  800e83:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  800e86:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800e8d:	eb 06                	jmp    800e95 <strlen+0x15>
		n++;
  800e8f:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  800e92:	ff 45 08             	incl   0x8(%ebp)
  800e95:	8b 45 08             	mov    0x8(%ebp),%eax
  800e98:	8a 00                	mov    (%eax),%al
  800e9a:	84 c0                	test   %al,%al
  800e9c:	75 f1                	jne    800e8f <strlen+0xf>
		n++;
	return n;
  800e9e:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800ea1:	c9                   	leave  
  800ea2:	c3                   	ret    

00800ea3 <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  800ea3:	55                   	push   %ebp
  800ea4:	89 e5                	mov    %esp,%ebp
  800ea6:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800ea9:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800eb0:	eb 09                	jmp    800ebb <strnlen+0x18>
		n++;
  800eb2:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800eb5:	ff 45 08             	incl   0x8(%ebp)
  800eb8:	ff 4d 0c             	decl   0xc(%ebp)
  800ebb:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800ebf:	74 09                	je     800eca <strnlen+0x27>
  800ec1:	8b 45 08             	mov    0x8(%ebp),%eax
  800ec4:	8a 00                	mov    (%eax),%al
  800ec6:	84 c0                	test   %al,%al
  800ec8:	75 e8                	jne    800eb2 <strnlen+0xf>
		n++;
	return n;
  800eca:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800ecd:	c9                   	leave  
  800ece:	c3                   	ret    

00800ecf <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800ecf:	55                   	push   %ebp
  800ed0:	89 e5                	mov    %esp,%ebp
  800ed2:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  800ed5:	8b 45 08             	mov    0x8(%ebp),%eax
  800ed8:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  800edb:	90                   	nop
  800edc:	8b 45 08             	mov    0x8(%ebp),%eax
  800edf:	8d 50 01             	lea    0x1(%eax),%edx
  800ee2:	89 55 08             	mov    %edx,0x8(%ebp)
  800ee5:	8b 55 0c             	mov    0xc(%ebp),%edx
  800ee8:	8d 4a 01             	lea    0x1(%edx),%ecx
  800eeb:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800eee:	8a 12                	mov    (%edx),%dl
  800ef0:	88 10                	mov    %dl,(%eax)
  800ef2:	8a 00                	mov    (%eax),%al
  800ef4:	84 c0                	test   %al,%al
  800ef6:	75 e4                	jne    800edc <strcpy+0xd>
		/* do nothing */;
	return ret;
  800ef8:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800efb:	c9                   	leave  
  800efc:	c3                   	ret    

00800efd <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  800efd:	55                   	push   %ebp
  800efe:	89 e5                	mov    %esp,%ebp
  800f00:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  800f03:	8b 45 08             	mov    0x8(%ebp),%eax
  800f06:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  800f09:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800f10:	eb 1f                	jmp    800f31 <strncpy+0x34>
		*dst++ = *src;
  800f12:	8b 45 08             	mov    0x8(%ebp),%eax
  800f15:	8d 50 01             	lea    0x1(%eax),%edx
  800f18:	89 55 08             	mov    %edx,0x8(%ebp)
  800f1b:	8b 55 0c             	mov    0xc(%ebp),%edx
  800f1e:	8a 12                	mov    (%edx),%dl
  800f20:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  800f22:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f25:	8a 00                	mov    (%eax),%al
  800f27:	84 c0                	test   %al,%al
  800f29:	74 03                	je     800f2e <strncpy+0x31>
			src++;
  800f2b:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800f2e:	ff 45 fc             	incl   -0x4(%ebp)
  800f31:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800f34:	3b 45 10             	cmp    0x10(%ebp),%eax
  800f37:	72 d9                	jb     800f12 <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  800f39:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  800f3c:	c9                   	leave  
  800f3d:	c3                   	ret    

00800f3e <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  800f3e:	55                   	push   %ebp
  800f3f:	89 e5                	mov    %esp,%ebp
  800f41:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  800f44:	8b 45 08             	mov    0x8(%ebp),%eax
  800f47:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  800f4a:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800f4e:	74 30                	je     800f80 <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  800f50:	eb 16                	jmp    800f68 <strlcpy+0x2a>
			*dst++ = *src++;
  800f52:	8b 45 08             	mov    0x8(%ebp),%eax
  800f55:	8d 50 01             	lea    0x1(%eax),%edx
  800f58:	89 55 08             	mov    %edx,0x8(%ebp)
  800f5b:	8b 55 0c             	mov    0xc(%ebp),%edx
  800f5e:	8d 4a 01             	lea    0x1(%edx),%ecx
  800f61:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800f64:	8a 12                	mov    (%edx),%dl
  800f66:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  800f68:	ff 4d 10             	decl   0x10(%ebp)
  800f6b:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800f6f:	74 09                	je     800f7a <strlcpy+0x3c>
  800f71:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f74:	8a 00                	mov    (%eax),%al
  800f76:	84 c0                	test   %al,%al
  800f78:	75 d8                	jne    800f52 <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  800f7a:	8b 45 08             	mov    0x8(%ebp),%eax
  800f7d:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800f80:	8b 55 08             	mov    0x8(%ebp),%edx
  800f83:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800f86:	29 c2                	sub    %eax,%edx
  800f88:	89 d0                	mov    %edx,%eax
}
  800f8a:	c9                   	leave  
  800f8b:	c3                   	ret    

00800f8c <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800f8c:	55                   	push   %ebp
  800f8d:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  800f8f:	eb 06                	jmp    800f97 <strcmp+0xb>
		p++, q++;
  800f91:	ff 45 08             	incl   0x8(%ebp)
  800f94:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  800f97:	8b 45 08             	mov    0x8(%ebp),%eax
  800f9a:	8a 00                	mov    (%eax),%al
  800f9c:	84 c0                	test   %al,%al
  800f9e:	74 0e                	je     800fae <strcmp+0x22>
  800fa0:	8b 45 08             	mov    0x8(%ebp),%eax
  800fa3:	8a 10                	mov    (%eax),%dl
  800fa5:	8b 45 0c             	mov    0xc(%ebp),%eax
  800fa8:	8a 00                	mov    (%eax),%al
  800faa:	38 c2                	cmp    %al,%dl
  800fac:	74 e3                	je     800f91 <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800fae:	8b 45 08             	mov    0x8(%ebp),%eax
  800fb1:	8a 00                	mov    (%eax),%al
  800fb3:	0f b6 d0             	movzbl %al,%edx
  800fb6:	8b 45 0c             	mov    0xc(%ebp),%eax
  800fb9:	8a 00                	mov    (%eax),%al
  800fbb:	0f b6 c0             	movzbl %al,%eax
  800fbe:	29 c2                	sub    %eax,%edx
  800fc0:	89 d0                	mov    %edx,%eax
}
  800fc2:	5d                   	pop    %ebp
  800fc3:	c3                   	ret    

00800fc4 <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  800fc4:	55                   	push   %ebp
  800fc5:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  800fc7:	eb 09                	jmp    800fd2 <strncmp+0xe>
		n--, p++, q++;
  800fc9:	ff 4d 10             	decl   0x10(%ebp)
  800fcc:	ff 45 08             	incl   0x8(%ebp)
  800fcf:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  800fd2:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800fd6:	74 17                	je     800fef <strncmp+0x2b>
  800fd8:	8b 45 08             	mov    0x8(%ebp),%eax
  800fdb:	8a 00                	mov    (%eax),%al
  800fdd:	84 c0                	test   %al,%al
  800fdf:	74 0e                	je     800fef <strncmp+0x2b>
  800fe1:	8b 45 08             	mov    0x8(%ebp),%eax
  800fe4:	8a 10                	mov    (%eax),%dl
  800fe6:	8b 45 0c             	mov    0xc(%ebp),%eax
  800fe9:	8a 00                	mov    (%eax),%al
  800feb:	38 c2                	cmp    %al,%dl
  800fed:	74 da                	je     800fc9 <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  800fef:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800ff3:	75 07                	jne    800ffc <strncmp+0x38>
		return 0;
  800ff5:	b8 00 00 00 00       	mov    $0x0,%eax
  800ffa:	eb 14                	jmp    801010 <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800ffc:	8b 45 08             	mov    0x8(%ebp),%eax
  800fff:	8a 00                	mov    (%eax),%al
  801001:	0f b6 d0             	movzbl %al,%edx
  801004:	8b 45 0c             	mov    0xc(%ebp),%eax
  801007:	8a 00                	mov    (%eax),%al
  801009:	0f b6 c0             	movzbl %al,%eax
  80100c:	29 c2                	sub    %eax,%edx
  80100e:	89 d0                	mov    %edx,%eax
}
  801010:	5d                   	pop    %ebp
  801011:	c3                   	ret    

00801012 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  801012:	55                   	push   %ebp
  801013:	89 e5                	mov    %esp,%ebp
  801015:	83 ec 04             	sub    $0x4,%esp
  801018:	8b 45 0c             	mov    0xc(%ebp),%eax
  80101b:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  80101e:	eb 12                	jmp    801032 <strchr+0x20>
		if (*s == c)
  801020:	8b 45 08             	mov    0x8(%ebp),%eax
  801023:	8a 00                	mov    (%eax),%al
  801025:	3a 45 fc             	cmp    -0x4(%ebp),%al
  801028:	75 05                	jne    80102f <strchr+0x1d>
			return (char *) s;
  80102a:	8b 45 08             	mov    0x8(%ebp),%eax
  80102d:	eb 11                	jmp    801040 <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  80102f:	ff 45 08             	incl   0x8(%ebp)
  801032:	8b 45 08             	mov    0x8(%ebp),%eax
  801035:	8a 00                	mov    (%eax),%al
  801037:	84 c0                	test   %al,%al
  801039:	75 e5                	jne    801020 <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  80103b:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801040:	c9                   	leave  
  801041:	c3                   	ret    

00801042 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  801042:	55                   	push   %ebp
  801043:	89 e5                	mov    %esp,%ebp
  801045:	83 ec 04             	sub    $0x4,%esp
  801048:	8b 45 0c             	mov    0xc(%ebp),%eax
  80104b:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  80104e:	eb 0d                	jmp    80105d <strfind+0x1b>
		if (*s == c)
  801050:	8b 45 08             	mov    0x8(%ebp),%eax
  801053:	8a 00                	mov    (%eax),%al
  801055:	3a 45 fc             	cmp    -0x4(%ebp),%al
  801058:	74 0e                	je     801068 <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  80105a:	ff 45 08             	incl   0x8(%ebp)
  80105d:	8b 45 08             	mov    0x8(%ebp),%eax
  801060:	8a 00                	mov    (%eax),%al
  801062:	84 c0                	test   %al,%al
  801064:	75 ea                	jne    801050 <strfind+0xe>
  801066:	eb 01                	jmp    801069 <strfind+0x27>
		if (*s == c)
			break;
  801068:	90                   	nop
	return (char *) s;
  801069:	8b 45 08             	mov    0x8(%ebp),%eax
}
  80106c:	c9                   	leave  
  80106d:	c3                   	ret    

0080106e <memset>:


void *
memset(void *v, int c, uint32 n)
{
  80106e:	55                   	push   %ebp
  80106f:	89 e5                	mov    %esp,%ebp
  801071:	83 ec 10             	sub    $0x10,%esp
	char *p;
	int m;

	p = v;
  801074:	8b 45 08             	mov    0x8(%ebp),%eax
  801077:	89 45 fc             	mov    %eax,-0x4(%ebp)
	m = n;
  80107a:	8b 45 10             	mov    0x10(%ebp),%eax
  80107d:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (--m >= 0)
  801080:	eb 0e                	jmp    801090 <memset+0x22>
		*p++ = c;
  801082:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801085:	8d 50 01             	lea    0x1(%eax),%edx
  801088:	89 55 fc             	mov    %edx,-0x4(%ebp)
  80108b:	8b 55 0c             	mov    0xc(%ebp),%edx
  80108e:	88 10                	mov    %dl,(%eax)
	char *p;
	int m;

	p = v;
	m = n;
	while (--m >= 0)
  801090:	ff 4d f8             	decl   -0x8(%ebp)
  801093:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
  801097:	79 e9                	jns    801082 <memset+0x14>
		*p++ = c;

	return v;
  801099:	8b 45 08             	mov    0x8(%ebp),%eax
}
  80109c:	c9                   	leave  
  80109d:	c3                   	ret    

0080109e <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  80109e:	55                   	push   %ebp
  80109f:	89 e5                	mov    %esp,%ebp
  8010a1:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  8010a4:	8b 45 0c             	mov    0xc(%ebp),%eax
  8010a7:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  8010aa:	8b 45 08             	mov    0x8(%ebp),%eax
  8010ad:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (n-- > 0)
  8010b0:	eb 16                	jmp    8010c8 <memcpy+0x2a>
		*d++ = *s++;
  8010b2:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8010b5:	8d 50 01             	lea    0x1(%eax),%edx
  8010b8:	89 55 f8             	mov    %edx,-0x8(%ebp)
  8010bb:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8010be:	8d 4a 01             	lea    0x1(%edx),%ecx
  8010c1:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  8010c4:	8a 12                	mov    (%edx),%dl
  8010c6:	88 10                	mov    %dl,(%eax)
	const char *s;
	char *d;

	s = src;
	d = dst;
	while (n-- > 0)
  8010c8:	8b 45 10             	mov    0x10(%ebp),%eax
  8010cb:	8d 50 ff             	lea    -0x1(%eax),%edx
  8010ce:	89 55 10             	mov    %edx,0x10(%ebp)
  8010d1:	85 c0                	test   %eax,%eax
  8010d3:	75 dd                	jne    8010b2 <memcpy+0x14>
		*d++ = *s++;

	return dst;
  8010d5:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8010d8:	c9                   	leave  
  8010d9:	c3                   	ret    

008010da <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  8010da:	55                   	push   %ebp
  8010db:	89 e5                	mov    %esp,%ebp
  8010dd:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  8010e0:	8b 45 0c             	mov    0xc(%ebp),%eax
  8010e3:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  8010e6:	8b 45 08             	mov    0x8(%ebp),%eax
  8010e9:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  8010ec:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8010ef:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  8010f2:	73 50                	jae    801144 <memmove+0x6a>
  8010f4:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8010f7:	8b 45 10             	mov    0x10(%ebp),%eax
  8010fa:	01 d0                	add    %edx,%eax
  8010fc:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  8010ff:	76 43                	jbe    801144 <memmove+0x6a>
		s += n;
  801101:	8b 45 10             	mov    0x10(%ebp),%eax
  801104:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  801107:	8b 45 10             	mov    0x10(%ebp),%eax
  80110a:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  80110d:	eb 10                	jmp    80111f <memmove+0x45>
			*--d = *--s;
  80110f:	ff 4d f8             	decl   -0x8(%ebp)
  801112:	ff 4d fc             	decl   -0x4(%ebp)
  801115:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801118:	8a 10                	mov    (%eax),%dl
  80111a:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80111d:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  80111f:	8b 45 10             	mov    0x10(%ebp),%eax
  801122:	8d 50 ff             	lea    -0x1(%eax),%edx
  801125:	89 55 10             	mov    %edx,0x10(%ebp)
  801128:	85 c0                	test   %eax,%eax
  80112a:	75 e3                	jne    80110f <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  80112c:	eb 23                	jmp    801151 <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  80112e:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801131:	8d 50 01             	lea    0x1(%eax),%edx
  801134:	89 55 f8             	mov    %edx,-0x8(%ebp)
  801137:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80113a:	8d 4a 01             	lea    0x1(%edx),%ecx
  80113d:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  801140:	8a 12                	mov    (%edx),%dl
  801142:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  801144:	8b 45 10             	mov    0x10(%ebp),%eax
  801147:	8d 50 ff             	lea    -0x1(%eax),%edx
  80114a:	89 55 10             	mov    %edx,0x10(%ebp)
  80114d:	85 c0                	test   %eax,%eax
  80114f:	75 dd                	jne    80112e <memmove+0x54>
			*d++ = *s++;

	return dst;
  801151:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801154:	c9                   	leave  
  801155:	c3                   	ret    

00801156 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  801156:	55                   	push   %ebp
  801157:	89 e5                	mov    %esp,%ebp
  801159:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  80115c:	8b 45 08             	mov    0x8(%ebp),%eax
  80115f:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  801162:	8b 45 0c             	mov    0xc(%ebp),%eax
  801165:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  801168:	eb 2a                	jmp    801194 <memcmp+0x3e>
		if (*s1 != *s2)
  80116a:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80116d:	8a 10                	mov    (%eax),%dl
  80116f:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801172:	8a 00                	mov    (%eax),%al
  801174:	38 c2                	cmp    %al,%dl
  801176:	74 16                	je     80118e <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  801178:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80117b:	8a 00                	mov    (%eax),%al
  80117d:	0f b6 d0             	movzbl %al,%edx
  801180:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801183:	8a 00                	mov    (%eax),%al
  801185:	0f b6 c0             	movzbl %al,%eax
  801188:	29 c2                	sub    %eax,%edx
  80118a:	89 d0                	mov    %edx,%eax
  80118c:	eb 18                	jmp    8011a6 <memcmp+0x50>
		s1++, s2++;
  80118e:	ff 45 fc             	incl   -0x4(%ebp)
  801191:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  801194:	8b 45 10             	mov    0x10(%ebp),%eax
  801197:	8d 50 ff             	lea    -0x1(%eax),%edx
  80119a:	89 55 10             	mov    %edx,0x10(%ebp)
  80119d:	85 c0                	test   %eax,%eax
  80119f:	75 c9                	jne    80116a <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  8011a1:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8011a6:	c9                   	leave  
  8011a7:	c3                   	ret    

008011a8 <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  8011a8:	55                   	push   %ebp
  8011a9:	89 e5                	mov    %esp,%ebp
  8011ab:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  8011ae:	8b 55 08             	mov    0x8(%ebp),%edx
  8011b1:	8b 45 10             	mov    0x10(%ebp),%eax
  8011b4:	01 d0                	add    %edx,%eax
  8011b6:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  8011b9:	eb 15                	jmp    8011d0 <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  8011bb:	8b 45 08             	mov    0x8(%ebp),%eax
  8011be:	8a 00                	mov    (%eax),%al
  8011c0:	0f b6 d0             	movzbl %al,%edx
  8011c3:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011c6:	0f b6 c0             	movzbl %al,%eax
  8011c9:	39 c2                	cmp    %eax,%edx
  8011cb:	74 0d                	je     8011da <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  8011cd:	ff 45 08             	incl   0x8(%ebp)
  8011d0:	8b 45 08             	mov    0x8(%ebp),%eax
  8011d3:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  8011d6:	72 e3                	jb     8011bb <memfind+0x13>
  8011d8:	eb 01                	jmp    8011db <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  8011da:	90                   	nop
	return (void *) s;
  8011db:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8011de:	c9                   	leave  
  8011df:	c3                   	ret    

008011e0 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  8011e0:	55                   	push   %ebp
  8011e1:	89 e5                	mov    %esp,%ebp
  8011e3:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  8011e6:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  8011ed:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  8011f4:	eb 03                	jmp    8011f9 <strtol+0x19>
		s++;
  8011f6:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  8011f9:	8b 45 08             	mov    0x8(%ebp),%eax
  8011fc:	8a 00                	mov    (%eax),%al
  8011fe:	3c 20                	cmp    $0x20,%al
  801200:	74 f4                	je     8011f6 <strtol+0x16>
  801202:	8b 45 08             	mov    0x8(%ebp),%eax
  801205:	8a 00                	mov    (%eax),%al
  801207:	3c 09                	cmp    $0x9,%al
  801209:	74 eb                	je     8011f6 <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  80120b:	8b 45 08             	mov    0x8(%ebp),%eax
  80120e:	8a 00                	mov    (%eax),%al
  801210:	3c 2b                	cmp    $0x2b,%al
  801212:	75 05                	jne    801219 <strtol+0x39>
		s++;
  801214:	ff 45 08             	incl   0x8(%ebp)
  801217:	eb 13                	jmp    80122c <strtol+0x4c>
	else if (*s == '-')
  801219:	8b 45 08             	mov    0x8(%ebp),%eax
  80121c:	8a 00                	mov    (%eax),%al
  80121e:	3c 2d                	cmp    $0x2d,%al
  801220:	75 0a                	jne    80122c <strtol+0x4c>
		s++, neg = 1;
  801222:	ff 45 08             	incl   0x8(%ebp)
  801225:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  80122c:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801230:	74 06                	je     801238 <strtol+0x58>
  801232:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  801236:	75 20                	jne    801258 <strtol+0x78>
  801238:	8b 45 08             	mov    0x8(%ebp),%eax
  80123b:	8a 00                	mov    (%eax),%al
  80123d:	3c 30                	cmp    $0x30,%al
  80123f:	75 17                	jne    801258 <strtol+0x78>
  801241:	8b 45 08             	mov    0x8(%ebp),%eax
  801244:	40                   	inc    %eax
  801245:	8a 00                	mov    (%eax),%al
  801247:	3c 78                	cmp    $0x78,%al
  801249:	75 0d                	jne    801258 <strtol+0x78>
		s += 2, base = 16;
  80124b:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  80124f:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  801256:	eb 28                	jmp    801280 <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  801258:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80125c:	75 15                	jne    801273 <strtol+0x93>
  80125e:	8b 45 08             	mov    0x8(%ebp),%eax
  801261:	8a 00                	mov    (%eax),%al
  801263:	3c 30                	cmp    $0x30,%al
  801265:	75 0c                	jne    801273 <strtol+0x93>
		s++, base = 8;
  801267:	ff 45 08             	incl   0x8(%ebp)
  80126a:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  801271:	eb 0d                	jmp    801280 <strtol+0xa0>
	else if (base == 0)
  801273:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801277:	75 07                	jne    801280 <strtol+0xa0>
		base = 10;
  801279:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  801280:	8b 45 08             	mov    0x8(%ebp),%eax
  801283:	8a 00                	mov    (%eax),%al
  801285:	3c 2f                	cmp    $0x2f,%al
  801287:	7e 19                	jle    8012a2 <strtol+0xc2>
  801289:	8b 45 08             	mov    0x8(%ebp),%eax
  80128c:	8a 00                	mov    (%eax),%al
  80128e:	3c 39                	cmp    $0x39,%al
  801290:	7f 10                	jg     8012a2 <strtol+0xc2>
			dig = *s - '0';
  801292:	8b 45 08             	mov    0x8(%ebp),%eax
  801295:	8a 00                	mov    (%eax),%al
  801297:	0f be c0             	movsbl %al,%eax
  80129a:	83 e8 30             	sub    $0x30,%eax
  80129d:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8012a0:	eb 42                	jmp    8012e4 <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  8012a2:	8b 45 08             	mov    0x8(%ebp),%eax
  8012a5:	8a 00                	mov    (%eax),%al
  8012a7:	3c 60                	cmp    $0x60,%al
  8012a9:	7e 19                	jle    8012c4 <strtol+0xe4>
  8012ab:	8b 45 08             	mov    0x8(%ebp),%eax
  8012ae:	8a 00                	mov    (%eax),%al
  8012b0:	3c 7a                	cmp    $0x7a,%al
  8012b2:	7f 10                	jg     8012c4 <strtol+0xe4>
			dig = *s - 'a' + 10;
  8012b4:	8b 45 08             	mov    0x8(%ebp),%eax
  8012b7:	8a 00                	mov    (%eax),%al
  8012b9:	0f be c0             	movsbl %al,%eax
  8012bc:	83 e8 57             	sub    $0x57,%eax
  8012bf:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8012c2:	eb 20                	jmp    8012e4 <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  8012c4:	8b 45 08             	mov    0x8(%ebp),%eax
  8012c7:	8a 00                	mov    (%eax),%al
  8012c9:	3c 40                	cmp    $0x40,%al
  8012cb:	7e 39                	jle    801306 <strtol+0x126>
  8012cd:	8b 45 08             	mov    0x8(%ebp),%eax
  8012d0:	8a 00                	mov    (%eax),%al
  8012d2:	3c 5a                	cmp    $0x5a,%al
  8012d4:	7f 30                	jg     801306 <strtol+0x126>
			dig = *s - 'A' + 10;
  8012d6:	8b 45 08             	mov    0x8(%ebp),%eax
  8012d9:	8a 00                	mov    (%eax),%al
  8012db:	0f be c0             	movsbl %al,%eax
  8012de:	83 e8 37             	sub    $0x37,%eax
  8012e1:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  8012e4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8012e7:	3b 45 10             	cmp    0x10(%ebp),%eax
  8012ea:	7d 19                	jge    801305 <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  8012ec:	ff 45 08             	incl   0x8(%ebp)
  8012ef:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8012f2:	0f af 45 10          	imul   0x10(%ebp),%eax
  8012f6:	89 c2                	mov    %eax,%edx
  8012f8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8012fb:	01 d0                	add    %edx,%eax
  8012fd:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  801300:	e9 7b ff ff ff       	jmp    801280 <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  801305:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  801306:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80130a:	74 08                	je     801314 <strtol+0x134>
		*endptr = (char *) s;
  80130c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80130f:	8b 55 08             	mov    0x8(%ebp),%edx
  801312:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  801314:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801318:	74 07                	je     801321 <strtol+0x141>
  80131a:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80131d:	f7 d8                	neg    %eax
  80131f:	eb 03                	jmp    801324 <strtol+0x144>
  801321:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  801324:	c9                   	leave  
  801325:	c3                   	ret    

00801326 <ltostr>:

void
ltostr(long value, char *str)
{
  801326:	55                   	push   %ebp
  801327:	89 e5                	mov    %esp,%ebp
  801329:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  80132c:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  801333:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  80133a:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80133e:	79 13                	jns    801353 <ltostr+0x2d>
	{
		neg = 1;
  801340:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  801347:	8b 45 0c             	mov    0xc(%ebp),%eax
  80134a:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  80134d:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  801350:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  801353:	8b 45 08             	mov    0x8(%ebp),%eax
  801356:	b9 0a 00 00 00       	mov    $0xa,%ecx
  80135b:	99                   	cltd   
  80135c:	f7 f9                	idiv   %ecx
  80135e:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  801361:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801364:	8d 50 01             	lea    0x1(%eax),%edx
  801367:	89 55 f8             	mov    %edx,-0x8(%ebp)
  80136a:	89 c2                	mov    %eax,%edx
  80136c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80136f:	01 d0                	add    %edx,%eax
  801371:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801374:	83 c2 30             	add    $0x30,%edx
  801377:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  801379:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80137c:	b8 67 66 66 66       	mov    $0x66666667,%eax
  801381:	f7 e9                	imul   %ecx
  801383:	c1 fa 02             	sar    $0x2,%edx
  801386:	89 c8                	mov    %ecx,%eax
  801388:	c1 f8 1f             	sar    $0x1f,%eax
  80138b:	29 c2                	sub    %eax,%edx
  80138d:	89 d0                	mov    %edx,%eax
  80138f:	89 45 08             	mov    %eax,0x8(%ebp)
	} while (value % 10 != 0);
  801392:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801395:	b8 67 66 66 66       	mov    $0x66666667,%eax
  80139a:	f7 e9                	imul   %ecx
  80139c:	c1 fa 02             	sar    $0x2,%edx
  80139f:	89 c8                	mov    %ecx,%eax
  8013a1:	c1 f8 1f             	sar    $0x1f,%eax
  8013a4:	29 c2                	sub    %eax,%edx
  8013a6:	89 d0                	mov    %edx,%eax
  8013a8:	c1 e0 02             	shl    $0x2,%eax
  8013ab:	01 d0                	add    %edx,%eax
  8013ad:	01 c0                	add    %eax,%eax
  8013af:	29 c1                	sub    %eax,%ecx
  8013b1:	89 ca                	mov    %ecx,%edx
  8013b3:	85 d2                	test   %edx,%edx
  8013b5:	75 9c                	jne    801353 <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  8013b7:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  8013be:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8013c1:	48                   	dec    %eax
  8013c2:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  8013c5:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  8013c9:	74 3d                	je     801408 <ltostr+0xe2>
		start = 1 ;
  8013cb:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  8013d2:	eb 34                	jmp    801408 <ltostr+0xe2>
	{
		char tmp = str[start] ;
  8013d4:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8013d7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8013da:	01 d0                	add    %edx,%eax
  8013dc:	8a 00                	mov    (%eax),%al
  8013de:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  8013e1:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8013e4:	8b 45 0c             	mov    0xc(%ebp),%eax
  8013e7:	01 c2                	add    %eax,%edx
  8013e9:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  8013ec:	8b 45 0c             	mov    0xc(%ebp),%eax
  8013ef:	01 c8                	add    %ecx,%eax
  8013f1:	8a 00                	mov    (%eax),%al
  8013f3:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  8013f5:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8013f8:	8b 45 0c             	mov    0xc(%ebp),%eax
  8013fb:	01 c2                	add    %eax,%edx
  8013fd:	8a 45 eb             	mov    -0x15(%ebp),%al
  801400:	88 02                	mov    %al,(%edx)
		start++ ;
  801402:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  801405:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  801408:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80140b:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  80140e:	7c c4                	jl     8013d4 <ltostr+0xae>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  801410:	8b 55 f8             	mov    -0x8(%ebp),%edx
  801413:	8b 45 0c             	mov    0xc(%ebp),%eax
  801416:	01 d0                	add    %edx,%eax
  801418:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  80141b:	90                   	nop
  80141c:	c9                   	leave  
  80141d:	c3                   	ret    

0080141e <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  80141e:	55                   	push   %ebp
  80141f:	89 e5                	mov    %esp,%ebp
  801421:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  801424:	ff 75 08             	pushl  0x8(%ebp)
  801427:	e8 54 fa ff ff       	call   800e80 <strlen>
  80142c:	83 c4 04             	add    $0x4,%esp
  80142f:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  801432:	ff 75 0c             	pushl  0xc(%ebp)
  801435:	e8 46 fa ff ff       	call   800e80 <strlen>
  80143a:	83 c4 04             	add    $0x4,%esp
  80143d:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  801440:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  801447:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  80144e:	eb 17                	jmp    801467 <strcconcat+0x49>
		final[s] = str1[s] ;
  801450:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801453:	8b 45 10             	mov    0x10(%ebp),%eax
  801456:	01 c2                	add    %eax,%edx
  801458:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  80145b:	8b 45 08             	mov    0x8(%ebp),%eax
  80145e:	01 c8                	add    %ecx,%eax
  801460:	8a 00                	mov    (%eax),%al
  801462:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  801464:	ff 45 fc             	incl   -0x4(%ebp)
  801467:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80146a:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  80146d:	7c e1                	jl     801450 <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  80146f:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  801476:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  80147d:	eb 1f                	jmp    80149e <strcconcat+0x80>
		final[s++] = str2[i] ;
  80147f:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801482:	8d 50 01             	lea    0x1(%eax),%edx
  801485:	89 55 fc             	mov    %edx,-0x4(%ebp)
  801488:	89 c2                	mov    %eax,%edx
  80148a:	8b 45 10             	mov    0x10(%ebp),%eax
  80148d:	01 c2                	add    %eax,%edx
  80148f:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  801492:	8b 45 0c             	mov    0xc(%ebp),%eax
  801495:	01 c8                	add    %ecx,%eax
  801497:	8a 00                	mov    (%eax),%al
  801499:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  80149b:	ff 45 f8             	incl   -0x8(%ebp)
  80149e:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8014a1:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8014a4:	7c d9                	jl     80147f <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  8014a6:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8014a9:	8b 45 10             	mov    0x10(%ebp),%eax
  8014ac:	01 d0                	add    %edx,%eax
  8014ae:	c6 00 00             	movb   $0x0,(%eax)
}
  8014b1:	90                   	nop
  8014b2:	c9                   	leave  
  8014b3:	c3                   	ret    

008014b4 <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  8014b4:	55                   	push   %ebp
  8014b5:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  8014b7:	8b 45 14             	mov    0x14(%ebp),%eax
  8014ba:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  8014c0:	8b 45 14             	mov    0x14(%ebp),%eax
  8014c3:	8b 00                	mov    (%eax),%eax
  8014c5:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8014cc:	8b 45 10             	mov    0x10(%ebp),%eax
  8014cf:	01 d0                	add    %edx,%eax
  8014d1:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  8014d7:	eb 0c                	jmp    8014e5 <strsplit+0x31>
			*string++ = 0;
  8014d9:	8b 45 08             	mov    0x8(%ebp),%eax
  8014dc:	8d 50 01             	lea    0x1(%eax),%edx
  8014df:	89 55 08             	mov    %edx,0x8(%ebp)
  8014e2:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  8014e5:	8b 45 08             	mov    0x8(%ebp),%eax
  8014e8:	8a 00                	mov    (%eax),%al
  8014ea:	84 c0                	test   %al,%al
  8014ec:	74 18                	je     801506 <strsplit+0x52>
  8014ee:	8b 45 08             	mov    0x8(%ebp),%eax
  8014f1:	8a 00                	mov    (%eax),%al
  8014f3:	0f be c0             	movsbl %al,%eax
  8014f6:	50                   	push   %eax
  8014f7:	ff 75 0c             	pushl  0xc(%ebp)
  8014fa:	e8 13 fb ff ff       	call   801012 <strchr>
  8014ff:	83 c4 08             	add    $0x8,%esp
  801502:	85 c0                	test   %eax,%eax
  801504:	75 d3                	jne    8014d9 <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  801506:	8b 45 08             	mov    0x8(%ebp),%eax
  801509:	8a 00                	mov    (%eax),%al
  80150b:	84 c0                	test   %al,%al
  80150d:	74 5a                	je     801569 <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  80150f:	8b 45 14             	mov    0x14(%ebp),%eax
  801512:	8b 00                	mov    (%eax),%eax
  801514:	83 f8 0f             	cmp    $0xf,%eax
  801517:	75 07                	jne    801520 <strsplit+0x6c>
		{
			return 0;
  801519:	b8 00 00 00 00       	mov    $0x0,%eax
  80151e:	eb 66                	jmp    801586 <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  801520:	8b 45 14             	mov    0x14(%ebp),%eax
  801523:	8b 00                	mov    (%eax),%eax
  801525:	8d 48 01             	lea    0x1(%eax),%ecx
  801528:	8b 55 14             	mov    0x14(%ebp),%edx
  80152b:	89 0a                	mov    %ecx,(%edx)
  80152d:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801534:	8b 45 10             	mov    0x10(%ebp),%eax
  801537:	01 c2                	add    %eax,%edx
  801539:	8b 45 08             	mov    0x8(%ebp),%eax
  80153c:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  80153e:	eb 03                	jmp    801543 <strsplit+0x8f>
			string++;
  801540:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  801543:	8b 45 08             	mov    0x8(%ebp),%eax
  801546:	8a 00                	mov    (%eax),%al
  801548:	84 c0                	test   %al,%al
  80154a:	74 8b                	je     8014d7 <strsplit+0x23>
  80154c:	8b 45 08             	mov    0x8(%ebp),%eax
  80154f:	8a 00                	mov    (%eax),%al
  801551:	0f be c0             	movsbl %al,%eax
  801554:	50                   	push   %eax
  801555:	ff 75 0c             	pushl  0xc(%ebp)
  801558:	e8 b5 fa ff ff       	call   801012 <strchr>
  80155d:	83 c4 08             	add    $0x8,%esp
  801560:	85 c0                	test   %eax,%eax
  801562:	74 dc                	je     801540 <strsplit+0x8c>
			string++;
	}
  801564:	e9 6e ff ff ff       	jmp    8014d7 <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  801569:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  80156a:	8b 45 14             	mov    0x14(%ebp),%eax
  80156d:	8b 00                	mov    (%eax),%eax
  80156f:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801576:	8b 45 10             	mov    0x10(%ebp),%eax
  801579:	01 d0                	add    %edx,%eax
  80157b:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  801581:	b8 01 00 00 00       	mov    $0x1,%eax
}
  801586:	c9                   	leave  
  801587:	c3                   	ret    

00801588 <InitializeUHeap>:
//============================== GIVEN FUNCTIONS ===================================//
//==================================================================================//

int FirstTimeFlag = 1;
void InitializeUHeap()
{
  801588:	55                   	push   %ebp
  801589:	89 e5                	mov    %esp,%ebp
  80158b:	83 ec 08             	sub    $0x8,%esp
	if(FirstTimeFlag)
  80158e:	a1 04 50 80 00       	mov    0x805004,%eax
  801593:	85 c0                	test   %eax,%eax
  801595:	74 1f                	je     8015b6 <InitializeUHeap+0x2e>
	{
		initialize_dyn_block_system();
  801597:	e8 1d 00 00 00       	call   8015b9 <initialize_dyn_block_system>
		cprintf("DYNAMIC BLOCK SYSTEM IS INITIALIZED\n");
  80159c:	83 ec 0c             	sub    $0xc,%esp
  80159f:	68 10 3e 80 00       	push   $0x803e10
  8015a4:	e8 55 f2 ff ff       	call   8007fe <cprintf>
  8015a9:	83 c4 10             	add    $0x10,%esp
#if UHP_USE_BUDDY
		initialize_buddy();
		cprintf("BUDDY SYSTEM IS INITIALIZED\n");
#endif
		FirstTimeFlag = 0;
  8015ac:	c7 05 04 50 80 00 00 	movl   $0x0,0x805004
  8015b3:	00 00 00 
	}
}
  8015b6:	90                   	nop
  8015b7:	c9                   	leave  
  8015b8:	c3                   	ret    

008015b9 <initialize_dyn_block_system>:

//=================================
// [1] INITIALIZE DYNAMIC ALLOCATOR:
//=================================
void initialize_dyn_block_system()
{
  8015b9:	55                   	push   %ebp
  8015ba:	89 e5                	mov    %esp,%ebp
  8015bc:	83 ec 28             	sub    $0x28,%esp
	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] initialize_dyn_block_system
	// your code is here, remove the panic and write your code
	//panic("initialize_dyn_block_system() is not implemented yet...!!");

	LIST_INIT(&AllocMemBlocksList);
  8015bf:	c7 05 40 50 80 00 00 	movl   $0x0,0x805040
  8015c6:	00 00 00 
  8015c9:	c7 05 44 50 80 00 00 	movl   $0x0,0x805044
  8015d0:	00 00 00 
  8015d3:	c7 05 4c 50 80 00 00 	movl   $0x0,0x80504c
  8015da:	00 00 00 
	LIST_INIT(&FreeMemBlocksList);
  8015dd:	c7 05 38 51 80 00 00 	movl   $0x0,0x805138
  8015e4:	00 00 00 
  8015e7:	c7 05 3c 51 80 00 00 	movl   $0x0,0x80513c
  8015ee:	00 00 00 
  8015f1:	c7 05 44 51 80 00 00 	movl   $0x0,0x805144
  8015f8:	00 00 00 
	MAX_MEM_BLOCK_CNT = NUM_OF_UHEAP_PAGES;
  8015fb:	c7 05 20 51 80 00 00 	movl   $0x20000,0x805120
  801602:	00 02 00 
	MemBlockNodes = (void*)USER_DYN_BLKS_ARRAY;
  801605:	c7 45 f4 00 00 e0 7f 	movl   $0x7fe00000,-0xc(%ebp)
  80160c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80160f:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801614:	2d 00 10 00 00       	sub    $0x1000,%eax
  801619:	a3 50 50 80 00       	mov    %eax,0x805050
	int size_of_block = sizeof(struct MemBlock);
  80161e:	c7 45 f0 10 00 00 00 	movl   $0x10,-0x10(%ebp)
	int size_all_struct = size_of_block*MAX_MEM_BLOCK_CNT;
  801625:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801628:	a1 20 51 80 00       	mov    0x805120,%eax
  80162d:	0f af c2             	imul   %edx,%eax
  801630:	89 45 ec             	mov    %eax,-0x14(%ebp)
	size_all_struct = ROUNDUP(size_all_struct, PAGE_SIZE);
  801633:	c7 45 e8 00 10 00 00 	movl   $0x1000,-0x18(%ebp)
  80163a:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80163d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801640:	01 d0                	add    %edx,%eax
  801642:	48                   	dec    %eax
  801643:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  801646:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801649:	ba 00 00 00 00       	mov    $0x0,%edx
  80164e:	f7 75 e8             	divl   -0x18(%ebp)
  801651:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801654:	29 d0                	sub    %edx,%eax
  801656:	89 45 ec             	mov    %eax,-0x14(%ebp)
	sys_allocate_chunk(USER_DYN_BLKS_ARRAY, size_all_struct,PERM_USER| PERM_WRITEABLE);
  801659:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80165c:	c7 45 e0 00 00 e0 7f 	movl   $0x7fe00000,-0x20(%ebp)
  801663:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801666:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
  80166c:	81 ea 00 10 00 00    	sub    $0x1000,%edx
  801672:	83 ec 04             	sub    $0x4,%esp
  801675:	6a 06                	push   $0x6
  801677:	50                   	push   %eax
  801678:	52                   	push   %edx
  801679:	e8 a1 05 00 00       	call   801c1f <sys_allocate_chunk>
  80167e:	83 c4 10             	add    $0x10,%esp
	initialize_MemBlocksList(MAX_MEM_BLOCK_CNT);
  801681:	a1 20 51 80 00       	mov    0x805120,%eax
  801686:	83 ec 0c             	sub    $0xc,%esp
  801689:	50                   	push   %eax
  80168a:	e8 16 0c 00 00       	call   8022a5 <initialize_MemBlocksList>
  80168f:	83 c4 10             	add    $0x10,%esp
	struct MemBlock* ourBlock =LIST_LAST(&AvailableMemBlocksList);
  801692:	a1 4c 51 80 00       	mov    0x80514c,%eax
  801697:	89 45 dc             	mov    %eax,-0x24(%ebp)
	LIST_REMOVE(&AvailableMemBlocksList,ourBlock);
  80169a:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  80169e:	75 14                	jne    8016b4 <initialize_dyn_block_system+0xfb>
  8016a0:	83 ec 04             	sub    $0x4,%esp
  8016a3:	68 35 3e 80 00       	push   $0x803e35
  8016a8:	6a 2d                	push   $0x2d
  8016aa:	68 53 3e 80 00       	push   $0x803e53
  8016af:	e8 96 ee ff ff       	call   80054a <_panic>
  8016b4:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8016b7:	8b 00                	mov    (%eax),%eax
  8016b9:	85 c0                	test   %eax,%eax
  8016bb:	74 10                	je     8016cd <initialize_dyn_block_system+0x114>
  8016bd:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8016c0:	8b 00                	mov    (%eax),%eax
  8016c2:	8b 55 dc             	mov    -0x24(%ebp),%edx
  8016c5:	8b 52 04             	mov    0x4(%edx),%edx
  8016c8:	89 50 04             	mov    %edx,0x4(%eax)
  8016cb:	eb 0b                	jmp    8016d8 <initialize_dyn_block_system+0x11f>
  8016cd:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8016d0:	8b 40 04             	mov    0x4(%eax),%eax
  8016d3:	a3 4c 51 80 00       	mov    %eax,0x80514c
  8016d8:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8016db:	8b 40 04             	mov    0x4(%eax),%eax
  8016de:	85 c0                	test   %eax,%eax
  8016e0:	74 0f                	je     8016f1 <initialize_dyn_block_system+0x138>
  8016e2:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8016e5:	8b 40 04             	mov    0x4(%eax),%eax
  8016e8:	8b 55 dc             	mov    -0x24(%ebp),%edx
  8016eb:	8b 12                	mov    (%edx),%edx
  8016ed:	89 10                	mov    %edx,(%eax)
  8016ef:	eb 0a                	jmp    8016fb <initialize_dyn_block_system+0x142>
  8016f1:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8016f4:	8b 00                	mov    (%eax),%eax
  8016f6:	a3 48 51 80 00       	mov    %eax,0x805148
  8016fb:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8016fe:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  801704:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801707:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80170e:	a1 54 51 80 00       	mov    0x805154,%eax
  801713:	48                   	dec    %eax
  801714:	a3 54 51 80 00       	mov    %eax,0x805154
	ourBlock->size = USER_HEAP_MAX-USER_HEAP_START;
  801719:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80171c:	c7 40 0c 00 00 00 20 	movl   $0x20000000,0xc(%eax)
	ourBlock->sva=USER_HEAP_START;
  801723:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801726:	c7 40 08 00 00 00 80 	movl   $0x80000000,0x8(%eax)
	LIST_INSERT_TAIL(&FreeMemBlocksList, ourBlock);
  80172d:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  801731:	75 14                	jne    801747 <initialize_dyn_block_system+0x18e>
  801733:	83 ec 04             	sub    $0x4,%esp
  801736:	68 60 3e 80 00       	push   $0x803e60
  80173b:	6a 30                	push   $0x30
  80173d:	68 53 3e 80 00       	push   $0x803e53
  801742:	e8 03 ee ff ff       	call   80054a <_panic>
  801747:	8b 15 3c 51 80 00    	mov    0x80513c,%edx
  80174d:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801750:	89 50 04             	mov    %edx,0x4(%eax)
  801753:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801756:	8b 40 04             	mov    0x4(%eax),%eax
  801759:	85 c0                	test   %eax,%eax
  80175b:	74 0c                	je     801769 <initialize_dyn_block_system+0x1b0>
  80175d:	a1 3c 51 80 00       	mov    0x80513c,%eax
  801762:	8b 55 dc             	mov    -0x24(%ebp),%edx
  801765:	89 10                	mov    %edx,(%eax)
  801767:	eb 08                	jmp    801771 <initialize_dyn_block_system+0x1b8>
  801769:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80176c:	a3 38 51 80 00       	mov    %eax,0x805138
  801771:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801774:	a3 3c 51 80 00       	mov    %eax,0x80513c
  801779:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80177c:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  801782:	a1 44 51 80 00       	mov    0x805144,%eax
  801787:	40                   	inc    %eax
  801788:	a3 44 51 80 00       	mov    %eax,0x805144
	//[1] Initialize two lists (AllocMemBlocksList & FreeMemBlocksList) [Hint: use LIST_INIT()]
	//[2] Dynamically allocate the array of MemBlockNodes at VA USER_DYN_BLKS_ARRAY
	//	  (remember to set MAX_MEM_BLOCK_CNT with the chosen size of the array)
	//[3] Initialize AvailableMemBlocksList by filling it with the MemBlockNodes
	//[4] Insert a new MemBlock with the heap size into the FreeMemBlocksList
}
  80178d:	90                   	nop
  80178e:	c9                   	leave  
  80178f:	c3                   	ret    

00801790 <malloc>:
//=================================
// [2] ALLOCATE SPACE IN USER HEAP:
//=================================

void* malloc(uint32 size)
{
  801790:	55                   	push   %ebp
  801791:	89 e5                	mov    %esp,%ebp
  801793:	83 ec 18             	sub    $0x18,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801796:	e8 ed fd ff ff       	call   801588 <InitializeUHeap>
	if (size == 0) return NULL ;
  80179b:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80179f:	75 07                	jne    8017a8 <malloc+0x18>
  8017a1:	b8 00 00 00 00       	mov    $0x0,%eax
  8017a6:	eb 67                	jmp    80180f <malloc+0x7f>

	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] malloc
	// your code is here, remove the panic and write your code
	//panic("malloc() is not implemented yet...!!");

	size = ROUNDUP(size, PAGE_SIZE);
  8017a8:	c7 45 f4 00 10 00 00 	movl   $0x1000,-0xc(%ebp)
  8017af:	8b 55 08             	mov    0x8(%ebp),%edx
  8017b2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8017b5:	01 d0                	add    %edx,%eax
  8017b7:	48                   	dec    %eax
  8017b8:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8017bb:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8017be:	ba 00 00 00 00       	mov    $0x0,%edx
  8017c3:	f7 75 f4             	divl   -0xc(%ebp)
  8017c6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8017c9:	29 d0                	sub    %edx,%eax
  8017cb:	89 45 08             	mov    %eax,0x8(%ebp)
	if(sys_isUHeapPlacementStrategyFIRSTFIT())
  8017ce:	e8 1a 08 00 00       	call   801fed <sys_isUHeapPlacementStrategyFIRSTFIT>
  8017d3:	85 c0                	test   %eax,%eax
  8017d5:	74 33                	je     80180a <malloc+0x7a>
	{
		struct MemBlock * myBlock = alloc_block_FF(size);
  8017d7:	83 ec 0c             	sub    $0xc,%esp
  8017da:	ff 75 08             	pushl  0x8(%ebp)
  8017dd:	e8 0c 0e 00 00       	call   8025ee <alloc_block_FF>
  8017e2:	83 c4 10             	add    $0x10,%esp
  8017e5:	89 45 ec             	mov    %eax,-0x14(%ebp)
		if(myBlock != NULL)
  8017e8:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8017ec:	74 1c                	je     80180a <malloc+0x7a>
		{
			insert_sorted_allocList(myBlock);
  8017ee:	83 ec 0c             	sub    $0xc,%esp
  8017f1:	ff 75 ec             	pushl  -0x14(%ebp)
  8017f4:	e8 07 0c 00 00       	call   802400 <insert_sorted_allocList>
  8017f9:	83 c4 10             	add    $0x10,%esp
			uint32 ptr = myBlock->sva;
  8017fc:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8017ff:	8b 40 08             	mov    0x8(%eax),%eax
  801802:	89 45 e8             	mov    %eax,-0x18(%ebp)
			return (void *)ptr;
  801805:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801808:	eb 05                	jmp    80180f <malloc+0x7f>
		}
	}
	return NULL;
  80180a:	b8 00 00 00 00       	mov    $0x0,%eax
	//		to the required allocation size (space should be on 4 KB BOUNDARY)
	//	2) if no suitable space found, return NULL
	// 	3) Return pointer containing the virtual address of allocated space,
	//
	//Use sys_isUHeapPlacementStrategyFIRSTFIT()... to check the current strategy
}
  80180f:	c9                   	leave  
  801810:	c3                   	ret    

00801811 <free>:
//	We can use sys_free_user_mem(uint32 virtual_address, uint32 size); which
//		switches to the kernel mode, calls free_user_mem() in
//		"kern/mem/chunk_operations.c", then switch back to the user mode here
//	the free_user_mem function is empty, make sure to implement it.
void free(void* virtual_address)
{
  801811:	55                   	push   %ebp
  801812:	89 e5                	mov    %esp,%ebp
  801814:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] free
	// your code is here, remove the panic and write your code
	//panic("free() is not implemented yet...!!");

	uint32 virtualAddress = (uint32 )(virtual_address);
  801817:	8b 45 08             	mov    0x8(%ebp),%eax
  80181a:	89 45 f4             	mov    %eax,-0xc(%ebp)
//	virtualAddress = ROUNDDOWN(virtualAddress, PAGE_SIZE);
	struct MemBlock * myBlock = find_block(&AllocMemBlocksList, virtualAddress);
  80181d:	83 ec 08             	sub    $0x8,%esp
  801820:	ff 75 f4             	pushl  -0xc(%ebp)
  801823:	68 40 50 80 00       	push   $0x805040
  801828:	e8 5b 0b 00 00       	call   802388 <find_block>
  80182d:	83 c4 10             	add    $0x10,%esp
  801830:	89 45 f0             	mov    %eax,-0x10(%ebp)
//	cprintf ("ptr sva at free user side = %x \n", myBlock->sva);
	sys_free_user_mem(virtualAddress, myBlock->size);
  801833:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801836:	8b 40 0c             	mov    0xc(%eax),%eax
  801839:	83 ec 08             	sub    $0x8,%esp
  80183c:	50                   	push   %eax
  80183d:	ff 75 f4             	pushl  -0xc(%ebp)
  801840:	e8 a2 03 00 00       	call   801be7 <sys_free_user_mem>
  801845:	83 c4 10             	add    $0x10,%esp
	LIST_REMOVE(&AllocMemBlocksList, myBlock);
  801848:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80184c:	75 14                	jne    801862 <free+0x51>
  80184e:	83 ec 04             	sub    $0x4,%esp
  801851:	68 35 3e 80 00       	push   $0x803e35
  801856:	6a 76                	push   $0x76
  801858:	68 53 3e 80 00       	push   $0x803e53
  80185d:	e8 e8 ec ff ff       	call   80054a <_panic>
  801862:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801865:	8b 00                	mov    (%eax),%eax
  801867:	85 c0                	test   %eax,%eax
  801869:	74 10                	je     80187b <free+0x6a>
  80186b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80186e:	8b 00                	mov    (%eax),%eax
  801870:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801873:	8b 52 04             	mov    0x4(%edx),%edx
  801876:	89 50 04             	mov    %edx,0x4(%eax)
  801879:	eb 0b                	jmp    801886 <free+0x75>
  80187b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80187e:	8b 40 04             	mov    0x4(%eax),%eax
  801881:	a3 44 50 80 00       	mov    %eax,0x805044
  801886:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801889:	8b 40 04             	mov    0x4(%eax),%eax
  80188c:	85 c0                	test   %eax,%eax
  80188e:	74 0f                	je     80189f <free+0x8e>
  801890:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801893:	8b 40 04             	mov    0x4(%eax),%eax
  801896:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801899:	8b 12                	mov    (%edx),%edx
  80189b:	89 10                	mov    %edx,(%eax)
  80189d:	eb 0a                	jmp    8018a9 <free+0x98>
  80189f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8018a2:	8b 00                	mov    (%eax),%eax
  8018a4:	a3 40 50 80 00       	mov    %eax,0x805040
  8018a9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8018ac:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8018b2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8018b5:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8018bc:	a1 4c 50 80 00       	mov    0x80504c,%eax
  8018c1:	48                   	dec    %eax
  8018c2:	a3 4c 50 80 00       	mov    %eax,0x80504c
	insert_sorted_with_merge_freeList(myBlock);
  8018c7:	83 ec 0c             	sub    $0xc,%esp
  8018ca:	ff 75 f0             	pushl  -0x10(%ebp)
  8018cd:	e8 0b 14 00 00       	call   802cdd <insert_sorted_with_merge_freeList>
  8018d2:	83 c4 10             	add    $0x10,%esp

	//you should get the size of the given allocation using its address
	//you need to call sys_free_user_mem()
	//refer to the project presentation and documentation for details
}
  8018d5:	90                   	nop
  8018d6:	c9                   	leave  
  8018d7:	c3                   	ret    

008018d8 <smalloc>:

//=================================
// [4] ALLOCATE SHARED VARIABLE:
//=================================
void* smalloc(char *sharedVarName, uint32 size, uint8 isWritable)
{
  8018d8:	55                   	push   %ebp
  8018d9:	89 e5                	mov    %esp,%ebp
  8018db:	83 ec 28             	sub    $0x28,%esp
  8018de:	8b 45 10             	mov    0x10(%ebp),%eax
  8018e1:	88 45 e4             	mov    %al,-0x1c(%ebp)
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  8018e4:	e8 9f fc ff ff       	call   801588 <InitializeUHeap>
	if (size == 0) return NULL ;
  8018e9:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8018ed:	75 0a                	jne    8018f9 <smalloc+0x21>
  8018ef:	b8 00 00 00 00       	mov    $0x0,%eax
  8018f4:	e9 8d 00 00 00       	jmp    801986 <smalloc+0xae>

	//This function should find the space of the required range
	// * ON 4KB BOUNDARY **** //
	//Use sys_isUHeapPlacementStrategyFIRSTFIT() to check the current strategy

	size = ROUNDUP(size, PAGE_SIZE);
  8018f9:	c7 45 f4 00 10 00 00 	movl   $0x1000,-0xc(%ebp)
  801900:	8b 55 0c             	mov    0xc(%ebp),%edx
  801903:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801906:	01 d0                	add    %edx,%eax
  801908:	48                   	dec    %eax
  801909:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80190c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80190f:	ba 00 00 00 00       	mov    $0x0,%edx
  801914:	f7 75 f4             	divl   -0xc(%ebp)
  801917:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80191a:	29 d0                	sub    %edx,%eax
  80191c:	89 45 0c             	mov    %eax,0xc(%ebp)
		if(sys_isUHeapPlacementStrategyFIRSTFIT())
  80191f:	e8 c9 06 00 00       	call   801fed <sys_isUHeapPlacementStrategyFIRSTFIT>
  801924:	85 c0                	test   %eax,%eax
  801926:	74 59                	je     801981 <smalloc+0xa9>
		{
			struct MemBlock * v1=NULL;
  801928:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
			v1= alloc_block_FF(size);
  80192f:	83 ec 0c             	sub    $0xc,%esp
  801932:	ff 75 0c             	pushl  0xc(%ebp)
  801935:	e8 b4 0c 00 00       	call   8025ee <alloc_block_FF>
  80193a:	83 c4 10             	add    $0x10,%esp
  80193d:	89 45 ec             	mov    %eax,-0x14(%ebp)
			if(v1==NULL)
  801940:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  801944:	75 07                	jne    80194d <smalloc+0x75>
			{
				return NULL;
  801946:	b8 00 00 00 00       	mov    $0x0,%eax
  80194b:	eb 39                	jmp    801986 <smalloc+0xae>
			}
			else
			{
				int ret=sys_createSharedObject(sharedVarName,  size,  isWritable,(void*)v1->sva);
  80194d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801950:	8b 40 08             	mov    0x8(%eax),%eax
  801953:	89 c2                	mov    %eax,%edx
  801955:	0f b6 45 e4          	movzbl -0x1c(%ebp),%eax
  801959:	52                   	push   %edx
  80195a:	50                   	push   %eax
  80195b:	ff 75 0c             	pushl  0xc(%ebp)
  80195e:	ff 75 08             	pushl  0x8(%ebp)
  801961:	e8 0c 04 00 00       	call   801d72 <sys_createSharedObject>
  801966:	83 c4 10             	add    $0x10,%esp
  801969:	89 45 e8             	mov    %eax,-0x18(%ebp)
				if(ret>=0)
  80196c:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  801970:	78 08                	js     80197a <smalloc+0xa2>
				{
					return (void*)v1->sva;
  801972:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801975:	8b 40 08             	mov    0x8(%eax),%eax
  801978:	eb 0c                	jmp    801986 <smalloc+0xae>
				}
				else
				{
					return NULL;
  80197a:	b8 00 00 00 00       	mov    $0x0,%eax
  80197f:	eb 05                	jmp    801986 <smalloc+0xae>
				}
			}

		}
		return NULL;
  801981:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801986:	c9                   	leave  
  801987:	c3                   	ret    

00801988 <sget>:

//========================================
// [5] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
  801988:	55                   	push   %ebp
  801989:	89 e5                	mov    %esp,%ebp
  80198b:	83 ec 18             	sub    $0x18,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  80198e:	e8 f5 fb ff ff       	call   801588 <InitializeUHeap>

	//This function should find the space for sharing the variable
	// *** ON 4KB BOUNDARY ******** //

	//Use sys_isUHeapPlacementStrategyFIRSTFIT() to check the current strategy
	int ret=sys_getSizeOfSharedObject(ownerEnvID,sharedVarName);
  801993:	83 ec 08             	sub    $0x8,%esp
  801996:	ff 75 0c             	pushl  0xc(%ebp)
  801999:	ff 75 08             	pushl  0x8(%ebp)
  80199c:	e8 fb 03 00 00       	call   801d9c <sys_getSizeOfSharedObject>
  8019a1:	83 c4 10             	add    $0x10,%esp
  8019a4:	89 45 f4             	mov    %eax,-0xc(%ebp)
	if(ret==0)
  8019a7:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8019ab:	75 07                	jne    8019b4 <sget+0x2c>
	{
		return NULL;
  8019ad:	b8 00 00 00 00       	mov    $0x0,%eax
  8019b2:	eb 64                	jmp    801a18 <sget+0x90>
	}
	if(sys_isUHeapPlacementStrategyFIRSTFIT())
  8019b4:	e8 34 06 00 00       	call   801fed <sys_isUHeapPlacementStrategyFIRSTFIT>
  8019b9:	85 c0                	test   %eax,%eax
  8019bb:	74 56                	je     801a13 <sget+0x8b>
	{
		struct MemBlock * v1=NULL;
  8019bd:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
		v1= alloc_block_FF(ret);
  8019c4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8019c7:	83 ec 0c             	sub    $0xc,%esp
  8019ca:	50                   	push   %eax
  8019cb:	e8 1e 0c 00 00       	call   8025ee <alloc_block_FF>
  8019d0:	83 c4 10             	add    $0x10,%esp
  8019d3:	89 45 f0             	mov    %eax,-0x10(%ebp)
		if(v1==NULL)
  8019d6:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8019da:	75 07                	jne    8019e3 <sget+0x5b>
		{
		return NULL;
  8019dc:	b8 00 00 00 00       	mov    $0x0,%eax
  8019e1:	eb 35                	jmp    801a18 <sget+0x90>
	    }
		else
		{
			int ret1=sys_getSharedObject(ownerEnvID,sharedVarName,(void*)v1->sva);
  8019e3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8019e6:	8b 40 08             	mov    0x8(%eax),%eax
  8019e9:	83 ec 04             	sub    $0x4,%esp
  8019ec:	50                   	push   %eax
  8019ed:	ff 75 0c             	pushl  0xc(%ebp)
  8019f0:	ff 75 08             	pushl  0x8(%ebp)
  8019f3:	e8 c1 03 00 00       	call   801db9 <sys_getSharedObject>
  8019f8:	83 c4 10             	add    $0x10,%esp
  8019fb:	89 45 ec             	mov    %eax,-0x14(%ebp)
			if(ret1>=0)
  8019fe:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  801a02:	78 08                	js     801a0c <sget+0x84>
			{
				return (void*)v1->sva;
  801a04:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801a07:	8b 40 08             	mov    0x8(%eax),%eax
  801a0a:	eb 0c                	jmp    801a18 <sget+0x90>
			}
			else
			{
				return NULL;
  801a0c:	b8 00 00 00 00       	mov    $0x0,%eax
  801a11:	eb 05                	jmp    801a18 <sget+0x90>
			}
		}
	}
  return NULL;
  801a13:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801a18:	c9                   	leave  
  801a19:	c3                   	ret    

00801a1a <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  801a1a:	55                   	push   %ebp
  801a1b:	89 e5                	mov    %esp,%ebp
  801a1d:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801a20:	e8 63 fb ff ff       	call   801588 <InitializeUHeap>
	//==============================================================
	// [USER HEAP - USER SIDE] realloc
	// Write your code here, remove the panic and write your code
	panic("realloc() is not implemented yet...!!");
  801a25:	83 ec 04             	sub    $0x4,%esp
  801a28:	68 84 3e 80 00       	push   $0x803e84
  801a2d:	68 0e 01 00 00       	push   $0x10e
  801a32:	68 53 3e 80 00       	push   $0x803e53
  801a37:	e8 0e eb ff ff       	call   80054a <_panic>

00801a3c <sfree>:
//	use sys_freeSharedObject(...); which switches to the kernel mode,
//	calls freeSharedObject(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the freeSharedObject() function is empty, make sure to implement it.

void sfree(void* virtual_address)
{
  801a3c:	55                   	push   %ebp
  801a3d:	89 e5                	mov    %esp,%ebp
  801a3f:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT MS3 - BONUS] [SHARING - USER SIDE] sfree()

	// Write your code here, remove the panic and write your code
	panic("sfree() is not implemented yet...!!");
  801a42:	83 ec 04             	sub    $0x4,%esp
  801a45:	68 ac 3e 80 00       	push   $0x803eac
  801a4a:	68 22 01 00 00       	push   $0x122
  801a4f:	68 53 3e 80 00       	push   $0x803e53
  801a54:	e8 f1 ea ff ff       	call   80054a <_panic>

00801a59 <expand>:

//==================================================================================//
//========================== MODIFICATION FUNCTIONS ================================//
//==================================================================================//
void expand(uint32 newSize)
{
  801a59:	55                   	push   %ebp
  801a5a:	89 e5                	mov    %esp,%ebp
  801a5c:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801a5f:	83 ec 04             	sub    $0x4,%esp
  801a62:	68 d0 3e 80 00       	push   $0x803ed0
  801a67:	68 2d 01 00 00       	push   $0x12d
  801a6c:	68 53 3e 80 00       	push   $0x803e53
  801a71:	e8 d4 ea ff ff       	call   80054a <_panic>

00801a76 <shrink>:

}
void shrink(uint32 newSize)
{
  801a76:	55                   	push   %ebp
  801a77:	89 e5                	mov    %esp,%ebp
  801a79:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801a7c:	83 ec 04             	sub    $0x4,%esp
  801a7f:	68 d0 3e 80 00       	push   $0x803ed0
  801a84:	68 32 01 00 00       	push   $0x132
  801a89:	68 53 3e 80 00       	push   $0x803e53
  801a8e:	e8 b7 ea ff ff       	call   80054a <_panic>

00801a93 <freeHeap>:

}
void freeHeap(void* virtual_address)
{
  801a93:	55                   	push   %ebp
  801a94:	89 e5                	mov    %esp,%ebp
  801a96:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801a99:	83 ec 04             	sub    $0x4,%esp
  801a9c:	68 d0 3e 80 00       	push   $0x803ed0
  801aa1:	68 37 01 00 00       	push   $0x137
  801aa6:	68 53 3e 80 00       	push   $0x803e53
  801aab:	e8 9a ea ff ff       	call   80054a <_panic>

00801ab0 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  801ab0:	55                   	push   %ebp
  801ab1:	89 e5                	mov    %esp,%ebp
  801ab3:	57                   	push   %edi
  801ab4:	56                   	push   %esi
  801ab5:	53                   	push   %ebx
  801ab6:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801ab9:	8b 45 08             	mov    0x8(%ebp),%eax
  801abc:	8b 55 0c             	mov    0xc(%ebp),%edx
  801abf:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801ac2:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801ac5:	8b 7d 18             	mov    0x18(%ebp),%edi
  801ac8:	8b 75 1c             	mov    0x1c(%ebp),%esi
  801acb:	cd 30                	int    $0x30
  801acd:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  801ad0:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801ad3:	83 c4 10             	add    $0x10,%esp
  801ad6:	5b                   	pop    %ebx
  801ad7:	5e                   	pop    %esi
  801ad8:	5f                   	pop    %edi
  801ad9:	5d                   	pop    %ebp
  801ada:	c3                   	ret    

00801adb <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  801adb:	55                   	push   %ebp
  801adc:	89 e5                	mov    %esp,%ebp
  801ade:	83 ec 04             	sub    $0x4,%esp
  801ae1:	8b 45 10             	mov    0x10(%ebp),%eax
  801ae4:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  801ae7:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801aeb:	8b 45 08             	mov    0x8(%ebp),%eax
  801aee:	6a 00                	push   $0x0
  801af0:	6a 00                	push   $0x0
  801af2:	52                   	push   %edx
  801af3:	ff 75 0c             	pushl  0xc(%ebp)
  801af6:	50                   	push   %eax
  801af7:	6a 00                	push   $0x0
  801af9:	e8 b2 ff ff ff       	call   801ab0 <syscall>
  801afe:	83 c4 18             	add    $0x18,%esp
}
  801b01:	90                   	nop
  801b02:	c9                   	leave  
  801b03:	c3                   	ret    

00801b04 <sys_cgetc>:

int
sys_cgetc(void)
{
  801b04:	55                   	push   %ebp
  801b05:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  801b07:	6a 00                	push   $0x0
  801b09:	6a 00                	push   $0x0
  801b0b:	6a 00                	push   $0x0
  801b0d:	6a 00                	push   $0x0
  801b0f:	6a 00                	push   $0x0
  801b11:	6a 01                	push   $0x1
  801b13:	e8 98 ff ff ff       	call   801ab0 <syscall>
  801b18:	83 c4 18             	add    $0x18,%esp
}
  801b1b:	c9                   	leave  
  801b1c:	c3                   	ret    

00801b1d <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  801b1d:	55                   	push   %ebp
  801b1e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  801b20:	8b 55 0c             	mov    0xc(%ebp),%edx
  801b23:	8b 45 08             	mov    0x8(%ebp),%eax
  801b26:	6a 00                	push   $0x0
  801b28:	6a 00                	push   $0x0
  801b2a:	6a 00                	push   $0x0
  801b2c:	52                   	push   %edx
  801b2d:	50                   	push   %eax
  801b2e:	6a 05                	push   $0x5
  801b30:	e8 7b ff ff ff       	call   801ab0 <syscall>
  801b35:	83 c4 18             	add    $0x18,%esp
}
  801b38:	c9                   	leave  
  801b39:	c3                   	ret    

00801b3a <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  801b3a:	55                   	push   %ebp
  801b3b:	89 e5                	mov    %esp,%ebp
  801b3d:	56                   	push   %esi
  801b3e:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  801b3f:	8b 75 18             	mov    0x18(%ebp),%esi
  801b42:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801b45:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801b48:	8b 55 0c             	mov    0xc(%ebp),%edx
  801b4b:	8b 45 08             	mov    0x8(%ebp),%eax
  801b4e:	56                   	push   %esi
  801b4f:	53                   	push   %ebx
  801b50:	51                   	push   %ecx
  801b51:	52                   	push   %edx
  801b52:	50                   	push   %eax
  801b53:	6a 06                	push   $0x6
  801b55:	e8 56 ff ff ff       	call   801ab0 <syscall>
  801b5a:	83 c4 18             	add    $0x18,%esp
}
  801b5d:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801b60:	5b                   	pop    %ebx
  801b61:	5e                   	pop    %esi
  801b62:	5d                   	pop    %ebp
  801b63:	c3                   	ret    

00801b64 <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  801b64:	55                   	push   %ebp
  801b65:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  801b67:	8b 55 0c             	mov    0xc(%ebp),%edx
  801b6a:	8b 45 08             	mov    0x8(%ebp),%eax
  801b6d:	6a 00                	push   $0x0
  801b6f:	6a 00                	push   $0x0
  801b71:	6a 00                	push   $0x0
  801b73:	52                   	push   %edx
  801b74:	50                   	push   %eax
  801b75:	6a 07                	push   $0x7
  801b77:	e8 34 ff ff ff       	call   801ab0 <syscall>
  801b7c:	83 c4 18             	add    $0x18,%esp
}
  801b7f:	c9                   	leave  
  801b80:	c3                   	ret    

00801b81 <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  801b81:	55                   	push   %ebp
  801b82:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  801b84:	6a 00                	push   $0x0
  801b86:	6a 00                	push   $0x0
  801b88:	6a 00                	push   $0x0
  801b8a:	ff 75 0c             	pushl  0xc(%ebp)
  801b8d:	ff 75 08             	pushl  0x8(%ebp)
  801b90:	6a 08                	push   $0x8
  801b92:	e8 19 ff ff ff       	call   801ab0 <syscall>
  801b97:	83 c4 18             	add    $0x18,%esp
}
  801b9a:	c9                   	leave  
  801b9b:	c3                   	ret    

00801b9c <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  801b9c:	55                   	push   %ebp
  801b9d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  801b9f:	6a 00                	push   $0x0
  801ba1:	6a 00                	push   $0x0
  801ba3:	6a 00                	push   $0x0
  801ba5:	6a 00                	push   $0x0
  801ba7:	6a 00                	push   $0x0
  801ba9:	6a 09                	push   $0x9
  801bab:	e8 00 ff ff ff       	call   801ab0 <syscall>
  801bb0:	83 c4 18             	add    $0x18,%esp
}
  801bb3:	c9                   	leave  
  801bb4:	c3                   	ret    

00801bb5 <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  801bb5:	55                   	push   %ebp
  801bb6:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  801bb8:	6a 00                	push   $0x0
  801bba:	6a 00                	push   $0x0
  801bbc:	6a 00                	push   $0x0
  801bbe:	6a 00                	push   $0x0
  801bc0:	6a 00                	push   $0x0
  801bc2:	6a 0a                	push   $0xa
  801bc4:	e8 e7 fe ff ff       	call   801ab0 <syscall>
  801bc9:	83 c4 18             	add    $0x18,%esp
}
  801bcc:	c9                   	leave  
  801bcd:	c3                   	ret    

00801bce <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  801bce:	55                   	push   %ebp
  801bcf:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  801bd1:	6a 00                	push   $0x0
  801bd3:	6a 00                	push   $0x0
  801bd5:	6a 00                	push   $0x0
  801bd7:	6a 00                	push   $0x0
  801bd9:	6a 00                	push   $0x0
  801bdb:	6a 0b                	push   $0xb
  801bdd:	e8 ce fe ff ff       	call   801ab0 <syscall>
  801be2:	83 c4 18             	add    $0x18,%esp
}
  801be5:	c9                   	leave  
  801be6:	c3                   	ret    

00801be7 <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  801be7:	55                   	push   %ebp
  801be8:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  801bea:	6a 00                	push   $0x0
  801bec:	6a 00                	push   $0x0
  801bee:	6a 00                	push   $0x0
  801bf0:	ff 75 0c             	pushl  0xc(%ebp)
  801bf3:	ff 75 08             	pushl  0x8(%ebp)
  801bf6:	6a 0f                	push   $0xf
  801bf8:	e8 b3 fe ff ff       	call   801ab0 <syscall>
  801bfd:	83 c4 18             	add    $0x18,%esp
	return;
  801c00:	90                   	nop
}
  801c01:	c9                   	leave  
  801c02:	c3                   	ret    

00801c03 <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  801c03:	55                   	push   %ebp
  801c04:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  801c06:	6a 00                	push   $0x0
  801c08:	6a 00                	push   $0x0
  801c0a:	6a 00                	push   $0x0
  801c0c:	ff 75 0c             	pushl  0xc(%ebp)
  801c0f:	ff 75 08             	pushl  0x8(%ebp)
  801c12:	6a 10                	push   $0x10
  801c14:	e8 97 fe ff ff       	call   801ab0 <syscall>
  801c19:	83 c4 18             	add    $0x18,%esp
	return ;
  801c1c:	90                   	nop
}
  801c1d:	c9                   	leave  
  801c1e:	c3                   	ret    

00801c1f <sys_allocate_chunk>:

void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  801c1f:	55                   	push   %ebp
  801c20:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  801c22:	6a 00                	push   $0x0
  801c24:	6a 00                	push   $0x0
  801c26:	ff 75 10             	pushl  0x10(%ebp)
  801c29:	ff 75 0c             	pushl  0xc(%ebp)
  801c2c:	ff 75 08             	pushl  0x8(%ebp)
  801c2f:	6a 11                	push   $0x11
  801c31:	e8 7a fe ff ff       	call   801ab0 <syscall>
  801c36:	83 c4 18             	add    $0x18,%esp
	return ;
  801c39:	90                   	nop
}
  801c3a:	c9                   	leave  
  801c3b:	c3                   	ret    

00801c3c <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  801c3c:	55                   	push   %ebp
  801c3d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  801c3f:	6a 00                	push   $0x0
  801c41:	6a 00                	push   $0x0
  801c43:	6a 00                	push   $0x0
  801c45:	6a 00                	push   $0x0
  801c47:	6a 00                	push   $0x0
  801c49:	6a 0c                	push   $0xc
  801c4b:	e8 60 fe ff ff       	call   801ab0 <syscall>
  801c50:	83 c4 18             	add    $0x18,%esp
}
  801c53:	c9                   	leave  
  801c54:	c3                   	ret    

00801c55 <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  801c55:	55                   	push   %ebp
  801c56:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  801c58:	6a 00                	push   $0x0
  801c5a:	6a 00                	push   $0x0
  801c5c:	6a 00                	push   $0x0
  801c5e:	6a 00                	push   $0x0
  801c60:	ff 75 08             	pushl  0x8(%ebp)
  801c63:	6a 0d                	push   $0xd
  801c65:	e8 46 fe ff ff       	call   801ab0 <syscall>
  801c6a:	83 c4 18             	add    $0x18,%esp
}
  801c6d:	c9                   	leave  
  801c6e:	c3                   	ret    

00801c6f <sys_scarce_memory>:

void sys_scarce_memory()
{
  801c6f:	55                   	push   %ebp
  801c70:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  801c72:	6a 00                	push   $0x0
  801c74:	6a 00                	push   $0x0
  801c76:	6a 00                	push   $0x0
  801c78:	6a 00                	push   $0x0
  801c7a:	6a 00                	push   $0x0
  801c7c:	6a 0e                	push   $0xe
  801c7e:	e8 2d fe ff ff       	call   801ab0 <syscall>
  801c83:	83 c4 18             	add    $0x18,%esp
}
  801c86:	90                   	nop
  801c87:	c9                   	leave  
  801c88:	c3                   	ret    

00801c89 <sys_disable_interrupt>:

//NEW !! 2012...
void
sys_disable_interrupt()
{
  801c89:	55                   	push   %ebp
  801c8a:	89 e5                	mov    %esp,%ebp
	syscall(SYS_disableINTR,0, 0, 0, 0, 0);
  801c8c:	6a 00                	push   $0x0
  801c8e:	6a 00                	push   $0x0
  801c90:	6a 00                	push   $0x0
  801c92:	6a 00                	push   $0x0
  801c94:	6a 00                	push   $0x0
  801c96:	6a 13                	push   $0x13
  801c98:	e8 13 fe ff ff       	call   801ab0 <syscall>
  801c9d:	83 c4 18             	add    $0x18,%esp
}
  801ca0:	90                   	nop
  801ca1:	c9                   	leave  
  801ca2:	c3                   	ret    

00801ca3 <sys_enable_interrupt>:


void
sys_enable_interrupt()
{
  801ca3:	55                   	push   %ebp
  801ca4:	89 e5                	mov    %esp,%ebp
	syscall(SYS_enableINTR,0, 0, 0, 0, 0);
  801ca6:	6a 00                	push   $0x0
  801ca8:	6a 00                	push   $0x0
  801caa:	6a 00                	push   $0x0
  801cac:	6a 00                	push   $0x0
  801cae:	6a 00                	push   $0x0
  801cb0:	6a 14                	push   $0x14
  801cb2:	e8 f9 fd ff ff       	call   801ab0 <syscall>
  801cb7:	83 c4 18             	add    $0x18,%esp
}
  801cba:	90                   	nop
  801cbb:	c9                   	leave  
  801cbc:	c3                   	ret    

00801cbd <sys_cputc>:


void
sys_cputc(const char c)
{
  801cbd:	55                   	push   %ebp
  801cbe:	89 e5                	mov    %esp,%ebp
  801cc0:	83 ec 04             	sub    $0x4,%esp
  801cc3:	8b 45 08             	mov    0x8(%ebp),%eax
  801cc6:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  801cc9:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801ccd:	6a 00                	push   $0x0
  801ccf:	6a 00                	push   $0x0
  801cd1:	6a 00                	push   $0x0
  801cd3:	6a 00                	push   $0x0
  801cd5:	50                   	push   %eax
  801cd6:	6a 15                	push   $0x15
  801cd8:	e8 d3 fd ff ff       	call   801ab0 <syscall>
  801cdd:	83 c4 18             	add    $0x18,%esp
}
  801ce0:	90                   	nop
  801ce1:	c9                   	leave  
  801ce2:	c3                   	ret    

00801ce3 <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  801ce3:	55                   	push   %ebp
  801ce4:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  801ce6:	6a 00                	push   $0x0
  801ce8:	6a 00                	push   $0x0
  801cea:	6a 00                	push   $0x0
  801cec:	6a 00                	push   $0x0
  801cee:	6a 00                	push   $0x0
  801cf0:	6a 16                	push   $0x16
  801cf2:	e8 b9 fd ff ff       	call   801ab0 <syscall>
  801cf7:	83 c4 18             	add    $0x18,%esp
}
  801cfa:	90                   	nop
  801cfb:	c9                   	leave  
  801cfc:	c3                   	ret    

00801cfd <sys_createSemaphore>:

int
sys_createSemaphore(char* semaphoreName, uint32 initialValue)
{
  801cfd:	55                   	push   %ebp
  801cfe:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_semaphore,(uint32)semaphoreName, (uint32)initialValue, 0, 0, 0);
  801d00:	8b 45 08             	mov    0x8(%ebp),%eax
  801d03:	6a 00                	push   $0x0
  801d05:	6a 00                	push   $0x0
  801d07:	6a 00                	push   $0x0
  801d09:	ff 75 0c             	pushl  0xc(%ebp)
  801d0c:	50                   	push   %eax
  801d0d:	6a 17                	push   $0x17
  801d0f:	e8 9c fd ff ff       	call   801ab0 <syscall>
  801d14:	83 c4 18             	add    $0x18,%esp
}
  801d17:	c9                   	leave  
  801d18:	c3                   	ret    

00801d19 <sys_getSemaphoreValue>:

int
sys_getSemaphoreValue(int32 ownerEnvID, char* semaphoreName)
{
  801d19:	55                   	push   %ebp
  801d1a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_semaphore_value,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801d1c:	8b 55 0c             	mov    0xc(%ebp),%edx
  801d1f:	8b 45 08             	mov    0x8(%ebp),%eax
  801d22:	6a 00                	push   $0x0
  801d24:	6a 00                	push   $0x0
  801d26:	6a 00                	push   $0x0
  801d28:	52                   	push   %edx
  801d29:	50                   	push   %eax
  801d2a:	6a 1a                	push   $0x1a
  801d2c:	e8 7f fd ff ff       	call   801ab0 <syscall>
  801d31:	83 c4 18             	add    $0x18,%esp
}
  801d34:	c9                   	leave  
  801d35:	c3                   	ret    

00801d36 <sys_waitSemaphore>:

void
sys_waitSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  801d36:	55                   	push   %ebp
  801d37:	89 e5                	mov    %esp,%ebp
	syscall(SYS_wait_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801d39:	8b 55 0c             	mov    0xc(%ebp),%edx
  801d3c:	8b 45 08             	mov    0x8(%ebp),%eax
  801d3f:	6a 00                	push   $0x0
  801d41:	6a 00                	push   $0x0
  801d43:	6a 00                	push   $0x0
  801d45:	52                   	push   %edx
  801d46:	50                   	push   %eax
  801d47:	6a 18                	push   $0x18
  801d49:	e8 62 fd ff ff       	call   801ab0 <syscall>
  801d4e:	83 c4 18             	add    $0x18,%esp
}
  801d51:	90                   	nop
  801d52:	c9                   	leave  
  801d53:	c3                   	ret    

00801d54 <sys_signalSemaphore>:

void
sys_signalSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  801d54:	55                   	push   %ebp
  801d55:	89 e5                	mov    %esp,%ebp
	syscall(SYS_signal_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801d57:	8b 55 0c             	mov    0xc(%ebp),%edx
  801d5a:	8b 45 08             	mov    0x8(%ebp),%eax
  801d5d:	6a 00                	push   $0x0
  801d5f:	6a 00                	push   $0x0
  801d61:	6a 00                	push   $0x0
  801d63:	52                   	push   %edx
  801d64:	50                   	push   %eax
  801d65:	6a 19                	push   $0x19
  801d67:	e8 44 fd ff ff       	call   801ab0 <syscall>
  801d6c:	83 c4 18             	add    $0x18,%esp
}
  801d6f:	90                   	nop
  801d70:	c9                   	leave  
  801d71:	c3                   	ret    

00801d72 <sys_createSharedObject>:

int
sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  801d72:	55                   	push   %ebp
  801d73:	89 e5                	mov    %esp,%ebp
  801d75:	83 ec 04             	sub    $0x4,%esp
  801d78:	8b 45 10             	mov    0x10(%ebp),%eax
  801d7b:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  801d7e:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801d81:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801d85:	8b 45 08             	mov    0x8(%ebp),%eax
  801d88:	6a 00                	push   $0x0
  801d8a:	51                   	push   %ecx
  801d8b:	52                   	push   %edx
  801d8c:	ff 75 0c             	pushl  0xc(%ebp)
  801d8f:	50                   	push   %eax
  801d90:	6a 1b                	push   $0x1b
  801d92:	e8 19 fd ff ff       	call   801ab0 <syscall>
  801d97:	83 c4 18             	add    $0x18,%esp
}
  801d9a:	c9                   	leave  
  801d9b:	c3                   	ret    

00801d9c <sys_getSizeOfSharedObject>:

//2017:
int
sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  801d9c:	55                   	push   %ebp
  801d9d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  801d9f:	8b 55 0c             	mov    0xc(%ebp),%edx
  801da2:	8b 45 08             	mov    0x8(%ebp),%eax
  801da5:	6a 00                	push   $0x0
  801da7:	6a 00                	push   $0x0
  801da9:	6a 00                	push   $0x0
  801dab:	52                   	push   %edx
  801dac:	50                   	push   %eax
  801dad:	6a 1c                	push   $0x1c
  801daf:	e8 fc fc ff ff       	call   801ab0 <syscall>
  801db4:	83 c4 18             	add    $0x18,%esp
}
  801db7:	c9                   	leave  
  801db8:	c3                   	ret    

00801db9 <sys_getSharedObject>:
//==========

int
sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  801db9:	55                   	push   %ebp
  801dba:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  801dbc:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801dbf:	8b 55 0c             	mov    0xc(%ebp),%edx
  801dc2:	8b 45 08             	mov    0x8(%ebp),%eax
  801dc5:	6a 00                	push   $0x0
  801dc7:	6a 00                	push   $0x0
  801dc9:	51                   	push   %ecx
  801dca:	52                   	push   %edx
  801dcb:	50                   	push   %eax
  801dcc:	6a 1d                	push   $0x1d
  801dce:	e8 dd fc ff ff       	call   801ab0 <syscall>
  801dd3:	83 c4 18             	add    $0x18,%esp
}
  801dd6:	c9                   	leave  
  801dd7:	c3                   	ret    

00801dd8 <sys_freeSharedObject>:

int
sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  801dd8:	55                   	push   %ebp
  801dd9:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  801ddb:	8b 55 0c             	mov    0xc(%ebp),%edx
  801dde:	8b 45 08             	mov    0x8(%ebp),%eax
  801de1:	6a 00                	push   $0x0
  801de3:	6a 00                	push   $0x0
  801de5:	6a 00                	push   $0x0
  801de7:	52                   	push   %edx
  801de8:	50                   	push   %eax
  801de9:	6a 1e                	push   $0x1e
  801deb:	e8 c0 fc ff ff       	call   801ab0 <syscall>
  801df0:	83 c4 18             	add    $0x18,%esp
}
  801df3:	c9                   	leave  
  801df4:	c3                   	ret    

00801df5 <sys_getMaxShares>:

uint32 	sys_getMaxShares()
{
  801df5:	55                   	push   %ebp
  801df6:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_max_shares,0, 0, 0, 0, 0);
  801df8:	6a 00                	push   $0x0
  801dfa:	6a 00                	push   $0x0
  801dfc:	6a 00                	push   $0x0
  801dfe:	6a 00                	push   $0x0
  801e00:	6a 00                	push   $0x0
  801e02:	6a 1f                	push   $0x1f
  801e04:	e8 a7 fc ff ff       	call   801ab0 <syscall>
  801e09:	83 c4 18             	add    $0x18,%esp
}
  801e0c:	c9                   	leave  
  801e0d:	c3                   	ret    

00801e0e <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  801e0e:	55                   	push   %ebp
  801e0f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  801e11:	8b 45 08             	mov    0x8(%ebp),%eax
  801e14:	6a 00                	push   $0x0
  801e16:	ff 75 14             	pushl  0x14(%ebp)
  801e19:	ff 75 10             	pushl  0x10(%ebp)
  801e1c:	ff 75 0c             	pushl  0xc(%ebp)
  801e1f:	50                   	push   %eax
  801e20:	6a 20                	push   $0x20
  801e22:	e8 89 fc ff ff       	call   801ab0 <syscall>
  801e27:	83 c4 18             	add    $0x18,%esp
}
  801e2a:	c9                   	leave  
  801e2b:	c3                   	ret    

00801e2c <sys_run_env>:

void
sys_run_env(int32 envId)
{
  801e2c:	55                   	push   %ebp
  801e2d:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  801e2f:	8b 45 08             	mov    0x8(%ebp),%eax
  801e32:	6a 00                	push   $0x0
  801e34:	6a 00                	push   $0x0
  801e36:	6a 00                	push   $0x0
  801e38:	6a 00                	push   $0x0
  801e3a:	50                   	push   %eax
  801e3b:	6a 21                	push   $0x21
  801e3d:	e8 6e fc ff ff       	call   801ab0 <syscall>
  801e42:	83 c4 18             	add    $0x18,%esp
}
  801e45:	90                   	nop
  801e46:	c9                   	leave  
  801e47:	c3                   	ret    

00801e48 <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  801e48:	55                   	push   %ebp
  801e49:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  801e4b:	8b 45 08             	mov    0x8(%ebp),%eax
  801e4e:	6a 00                	push   $0x0
  801e50:	6a 00                	push   $0x0
  801e52:	6a 00                	push   $0x0
  801e54:	6a 00                	push   $0x0
  801e56:	50                   	push   %eax
  801e57:	6a 22                	push   $0x22
  801e59:	e8 52 fc ff ff       	call   801ab0 <syscall>
  801e5e:	83 c4 18             	add    $0x18,%esp
}
  801e61:	c9                   	leave  
  801e62:	c3                   	ret    

00801e63 <sys_getenvid>:

int32 sys_getenvid(void)
{
  801e63:	55                   	push   %ebp
  801e64:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  801e66:	6a 00                	push   $0x0
  801e68:	6a 00                	push   $0x0
  801e6a:	6a 00                	push   $0x0
  801e6c:	6a 00                	push   $0x0
  801e6e:	6a 00                	push   $0x0
  801e70:	6a 02                	push   $0x2
  801e72:	e8 39 fc ff ff       	call   801ab0 <syscall>
  801e77:	83 c4 18             	add    $0x18,%esp
}
  801e7a:	c9                   	leave  
  801e7b:	c3                   	ret    

00801e7c <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  801e7c:	55                   	push   %ebp
  801e7d:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  801e7f:	6a 00                	push   $0x0
  801e81:	6a 00                	push   $0x0
  801e83:	6a 00                	push   $0x0
  801e85:	6a 00                	push   $0x0
  801e87:	6a 00                	push   $0x0
  801e89:	6a 03                	push   $0x3
  801e8b:	e8 20 fc ff ff       	call   801ab0 <syscall>
  801e90:	83 c4 18             	add    $0x18,%esp
}
  801e93:	c9                   	leave  
  801e94:	c3                   	ret    

00801e95 <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  801e95:	55                   	push   %ebp
  801e96:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  801e98:	6a 00                	push   $0x0
  801e9a:	6a 00                	push   $0x0
  801e9c:	6a 00                	push   $0x0
  801e9e:	6a 00                	push   $0x0
  801ea0:	6a 00                	push   $0x0
  801ea2:	6a 04                	push   $0x4
  801ea4:	e8 07 fc ff ff       	call   801ab0 <syscall>
  801ea9:	83 c4 18             	add    $0x18,%esp
}
  801eac:	c9                   	leave  
  801ead:	c3                   	ret    

00801eae <sys_exit_env>:


void sys_exit_env(void)
{
  801eae:	55                   	push   %ebp
  801eaf:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  801eb1:	6a 00                	push   $0x0
  801eb3:	6a 00                	push   $0x0
  801eb5:	6a 00                	push   $0x0
  801eb7:	6a 00                	push   $0x0
  801eb9:	6a 00                	push   $0x0
  801ebb:	6a 23                	push   $0x23
  801ebd:	e8 ee fb ff ff       	call   801ab0 <syscall>
  801ec2:	83 c4 18             	add    $0x18,%esp
}
  801ec5:	90                   	nop
  801ec6:	c9                   	leave  
  801ec7:	c3                   	ret    

00801ec8 <sys_get_virtual_time>:


struct uint64
sys_get_virtual_time()
{
  801ec8:	55                   	push   %ebp
  801ec9:	89 e5                	mov    %esp,%ebp
  801ecb:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  801ece:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801ed1:	8d 50 04             	lea    0x4(%eax),%edx
  801ed4:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801ed7:	6a 00                	push   $0x0
  801ed9:	6a 00                	push   $0x0
  801edb:	6a 00                	push   $0x0
  801edd:	52                   	push   %edx
  801ede:	50                   	push   %eax
  801edf:	6a 24                	push   $0x24
  801ee1:	e8 ca fb ff ff       	call   801ab0 <syscall>
  801ee6:	83 c4 18             	add    $0x18,%esp
	return result;
  801ee9:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801eec:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801eef:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801ef2:	89 01                	mov    %eax,(%ecx)
  801ef4:	89 51 04             	mov    %edx,0x4(%ecx)
}
  801ef7:	8b 45 08             	mov    0x8(%ebp),%eax
  801efa:	c9                   	leave  
  801efb:	c2 04 00             	ret    $0x4

00801efe <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  801efe:	55                   	push   %ebp
  801eff:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  801f01:	6a 00                	push   $0x0
  801f03:	6a 00                	push   $0x0
  801f05:	ff 75 10             	pushl  0x10(%ebp)
  801f08:	ff 75 0c             	pushl  0xc(%ebp)
  801f0b:	ff 75 08             	pushl  0x8(%ebp)
  801f0e:	6a 12                	push   $0x12
  801f10:	e8 9b fb ff ff       	call   801ab0 <syscall>
  801f15:	83 c4 18             	add    $0x18,%esp
	return ;
  801f18:	90                   	nop
}
  801f19:	c9                   	leave  
  801f1a:	c3                   	ret    

00801f1b <sys_rcr2>:
uint32 sys_rcr2()
{
  801f1b:	55                   	push   %ebp
  801f1c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  801f1e:	6a 00                	push   $0x0
  801f20:	6a 00                	push   $0x0
  801f22:	6a 00                	push   $0x0
  801f24:	6a 00                	push   $0x0
  801f26:	6a 00                	push   $0x0
  801f28:	6a 25                	push   $0x25
  801f2a:	e8 81 fb ff ff       	call   801ab0 <syscall>
  801f2f:	83 c4 18             	add    $0x18,%esp
}
  801f32:	c9                   	leave  
  801f33:	c3                   	ret    

00801f34 <sys_bypassPageFault>:
void sys_bypassPageFault(uint8 instrLength)
{
  801f34:	55                   	push   %ebp
  801f35:	89 e5                	mov    %esp,%ebp
  801f37:	83 ec 04             	sub    $0x4,%esp
  801f3a:	8b 45 08             	mov    0x8(%ebp),%eax
  801f3d:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  801f40:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  801f44:	6a 00                	push   $0x0
  801f46:	6a 00                	push   $0x0
  801f48:	6a 00                	push   $0x0
  801f4a:	6a 00                	push   $0x0
  801f4c:	50                   	push   %eax
  801f4d:	6a 26                	push   $0x26
  801f4f:	e8 5c fb ff ff       	call   801ab0 <syscall>
  801f54:	83 c4 18             	add    $0x18,%esp
	return ;
  801f57:	90                   	nop
}
  801f58:	c9                   	leave  
  801f59:	c3                   	ret    

00801f5a <rsttst>:
void rsttst()
{
  801f5a:	55                   	push   %ebp
  801f5b:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  801f5d:	6a 00                	push   $0x0
  801f5f:	6a 00                	push   $0x0
  801f61:	6a 00                	push   $0x0
  801f63:	6a 00                	push   $0x0
  801f65:	6a 00                	push   $0x0
  801f67:	6a 28                	push   $0x28
  801f69:	e8 42 fb ff ff       	call   801ab0 <syscall>
  801f6e:	83 c4 18             	add    $0x18,%esp
	return ;
  801f71:	90                   	nop
}
  801f72:	c9                   	leave  
  801f73:	c3                   	ret    

00801f74 <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  801f74:	55                   	push   %ebp
  801f75:	89 e5                	mov    %esp,%ebp
  801f77:	83 ec 04             	sub    $0x4,%esp
  801f7a:	8b 45 14             	mov    0x14(%ebp),%eax
  801f7d:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  801f80:	8b 55 18             	mov    0x18(%ebp),%edx
  801f83:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801f87:	52                   	push   %edx
  801f88:	50                   	push   %eax
  801f89:	ff 75 10             	pushl  0x10(%ebp)
  801f8c:	ff 75 0c             	pushl  0xc(%ebp)
  801f8f:	ff 75 08             	pushl  0x8(%ebp)
  801f92:	6a 27                	push   $0x27
  801f94:	e8 17 fb ff ff       	call   801ab0 <syscall>
  801f99:	83 c4 18             	add    $0x18,%esp
	return ;
  801f9c:	90                   	nop
}
  801f9d:	c9                   	leave  
  801f9e:	c3                   	ret    

00801f9f <chktst>:
void chktst(uint32 n)
{
  801f9f:	55                   	push   %ebp
  801fa0:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  801fa2:	6a 00                	push   $0x0
  801fa4:	6a 00                	push   $0x0
  801fa6:	6a 00                	push   $0x0
  801fa8:	6a 00                	push   $0x0
  801faa:	ff 75 08             	pushl  0x8(%ebp)
  801fad:	6a 29                	push   $0x29
  801faf:	e8 fc fa ff ff       	call   801ab0 <syscall>
  801fb4:	83 c4 18             	add    $0x18,%esp
	return ;
  801fb7:	90                   	nop
}
  801fb8:	c9                   	leave  
  801fb9:	c3                   	ret    

00801fba <inctst>:

void inctst()
{
  801fba:	55                   	push   %ebp
  801fbb:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  801fbd:	6a 00                	push   $0x0
  801fbf:	6a 00                	push   $0x0
  801fc1:	6a 00                	push   $0x0
  801fc3:	6a 00                	push   $0x0
  801fc5:	6a 00                	push   $0x0
  801fc7:	6a 2a                	push   $0x2a
  801fc9:	e8 e2 fa ff ff       	call   801ab0 <syscall>
  801fce:	83 c4 18             	add    $0x18,%esp
	return ;
  801fd1:	90                   	nop
}
  801fd2:	c9                   	leave  
  801fd3:	c3                   	ret    

00801fd4 <gettst>:
uint32 gettst()
{
  801fd4:	55                   	push   %ebp
  801fd5:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  801fd7:	6a 00                	push   $0x0
  801fd9:	6a 00                	push   $0x0
  801fdb:	6a 00                	push   $0x0
  801fdd:	6a 00                	push   $0x0
  801fdf:	6a 00                	push   $0x0
  801fe1:	6a 2b                	push   $0x2b
  801fe3:	e8 c8 fa ff ff       	call   801ab0 <syscall>
  801fe8:	83 c4 18             	add    $0x18,%esp
}
  801feb:	c9                   	leave  
  801fec:	c3                   	ret    

00801fed <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  801fed:	55                   	push   %ebp
  801fee:	89 e5                	mov    %esp,%ebp
  801ff0:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801ff3:	6a 00                	push   $0x0
  801ff5:	6a 00                	push   $0x0
  801ff7:	6a 00                	push   $0x0
  801ff9:	6a 00                	push   $0x0
  801ffb:	6a 00                	push   $0x0
  801ffd:	6a 2c                	push   $0x2c
  801fff:	e8 ac fa ff ff       	call   801ab0 <syscall>
  802004:	83 c4 18             	add    $0x18,%esp
  802007:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  80200a:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  80200e:	75 07                	jne    802017 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  802010:	b8 01 00 00 00       	mov    $0x1,%eax
  802015:	eb 05                	jmp    80201c <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  802017:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80201c:	c9                   	leave  
  80201d:	c3                   	ret    

0080201e <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  80201e:	55                   	push   %ebp
  80201f:	89 e5                	mov    %esp,%ebp
  802021:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  802024:	6a 00                	push   $0x0
  802026:	6a 00                	push   $0x0
  802028:	6a 00                	push   $0x0
  80202a:	6a 00                	push   $0x0
  80202c:	6a 00                	push   $0x0
  80202e:	6a 2c                	push   $0x2c
  802030:	e8 7b fa ff ff       	call   801ab0 <syscall>
  802035:	83 c4 18             	add    $0x18,%esp
  802038:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  80203b:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  80203f:	75 07                	jne    802048 <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  802041:	b8 01 00 00 00       	mov    $0x1,%eax
  802046:	eb 05                	jmp    80204d <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  802048:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80204d:	c9                   	leave  
  80204e:	c3                   	ret    

0080204f <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  80204f:	55                   	push   %ebp
  802050:	89 e5                	mov    %esp,%ebp
  802052:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  802055:	6a 00                	push   $0x0
  802057:	6a 00                	push   $0x0
  802059:	6a 00                	push   $0x0
  80205b:	6a 00                	push   $0x0
  80205d:	6a 00                	push   $0x0
  80205f:	6a 2c                	push   $0x2c
  802061:	e8 4a fa ff ff       	call   801ab0 <syscall>
  802066:	83 c4 18             	add    $0x18,%esp
  802069:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  80206c:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  802070:	75 07                	jne    802079 <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  802072:	b8 01 00 00 00       	mov    $0x1,%eax
  802077:	eb 05                	jmp    80207e <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  802079:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80207e:	c9                   	leave  
  80207f:	c3                   	ret    

00802080 <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  802080:	55                   	push   %ebp
  802081:	89 e5                	mov    %esp,%ebp
  802083:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  802086:	6a 00                	push   $0x0
  802088:	6a 00                	push   $0x0
  80208a:	6a 00                	push   $0x0
  80208c:	6a 00                	push   $0x0
  80208e:	6a 00                	push   $0x0
  802090:	6a 2c                	push   $0x2c
  802092:	e8 19 fa ff ff       	call   801ab0 <syscall>
  802097:	83 c4 18             	add    $0x18,%esp
  80209a:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  80209d:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  8020a1:	75 07                	jne    8020aa <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  8020a3:	b8 01 00 00 00       	mov    $0x1,%eax
  8020a8:	eb 05                	jmp    8020af <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  8020aa:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8020af:	c9                   	leave  
  8020b0:	c3                   	ret    

008020b1 <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  8020b1:	55                   	push   %ebp
  8020b2:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  8020b4:	6a 00                	push   $0x0
  8020b6:	6a 00                	push   $0x0
  8020b8:	6a 00                	push   $0x0
  8020ba:	6a 00                	push   $0x0
  8020bc:	ff 75 08             	pushl  0x8(%ebp)
  8020bf:	6a 2d                	push   $0x2d
  8020c1:	e8 ea f9 ff ff       	call   801ab0 <syscall>
  8020c6:	83 c4 18             	add    $0x18,%esp
	return ;
  8020c9:	90                   	nop
}
  8020ca:	c9                   	leave  
  8020cb:	c3                   	ret    

008020cc <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  8020cc:	55                   	push   %ebp
  8020cd:	89 e5                	mov    %esp,%ebp
  8020cf:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  8020d0:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8020d3:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8020d6:	8b 55 0c             	mov    0xc(%ebp),%edx
  8020d9:	8b 45 08             	mov    0x8(%ebp),%eax
  8020dc:	6a 00                	push   $0x0
  8020de:	53                   	push   %ebx
  8020df:	51                   	push   %ecx
  8020e0:	52                   	push   %edx
  8020e1:	50                   	push   %eax
  8020e2:	6a 2e                	push   $0x2e
  8020e4:	e8 c7 f9 ff ff       	call   801ab0 <syscall>
  8020e9:	83 c4 18             	add    $0x18,%esp
}
  8020ec:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8020ef:	c9                   	leave  
  8020f0:	c3                   	ret    

008020f1 <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  8020f1:	55                   	push   %ebp
  8020f2:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  8020f4:	8b 55 0c             	mov    0xc(%ebp),%edx
  8020f7:	8b 45 08             	mov    0x8(%ebp),%eax
  8020fa:	6a 00                	push   $0x0
  8020fc:	6a 00                	push   $0x0
  8020fe:	6a 00                	push   $0x0
  802100:	52                   	push   %edx
  802101:	50                   	push   %eax
  802102:	6a 2f                	push   $0x2f
  802104:	e8 a7 f9 ff ff       	call   801ab0 <syscall>
  802109:	83 c4 18             	add    $0x18,%esp
}
  80210c:	c9                   	leave  
  80210d:	c3                   	ret    

0080210e <print_mem_block_lists>:
//===========================
// PRINT MEM BLOCK LISTS:
//===========================

void print_mem_block_lists()
{
  80210e:	55                   	push   %ebp
  80210f:	89 e5                	mov    %esp,%ebp
  802111:	83 ec 18             	sub    $0x18,%esp
	cprintf("\n=========================================\n");
  802114:	83 ec 0c             	sub    $0xc,%esp
  802117:	68 e0 3e 80 00       	push   $0x803ee0
  80211c:	e8 dd e6 ff ff       	call   8007fe <cprintf>
  802121:	83 c4 10             	add    $0x10,%esp
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
  802124:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nFreeMemBlocksList:\n");
  80212b:	83 ec 0c             	sub    $0xc,%esp
  80212e:	68 0c 3f 80 00       	push   $0x803f0c
  802133:	e8 c6 e6 ff ff       	call   8007fe <cprintf>
  802138:	83 c4 10             	add    $0x10,%esp
	uint8 sorted = 1 ;
  80213b:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &FreeMemBlocksList)
  80213f:	a1 38 51 80 00       	mov    0x805138,%eax
  802144:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802147:	eb 56                	jmp    80219f <print_mem_block_lists+0x91>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  802149:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80214d:	74 1c                	je     80216b <print_mem_block_lists+0x5d>
  80214f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802152:	8b 50 08             	mov    0x8(%eax),%edx
  802155:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802158:	8b 48 08             	mov    0x8(%eax),%ecx
  80215b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80215e:	8b 40 0c             	mov    0xc(%eax),%eax
  802161:	01 c8                	add    %ecx,%eax
  802163:	39 c2                	cmp    %eax,%edx
  802165:	73 04                	jae    80216b <print_mem_block_lists+0x5d>
			sorted = 0 ;
  802167:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  80216b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80216e:	8b 50 08             	mov    0x8(%eax),%edx
  802171:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802174:	8b 40 0c             	mov    0xc(%eax),%eax
  802177:	01 c2                	add    %eax,%edx
  802179:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80217c:	8b 40 08             	mov    0x8(%eax),%eax
  80217f:	83 ec 04             	sub    $0x4,%esp
  802182:	52                   	push   %edx
  802183:	50                   	push   %eax
  802184:	68 21 3f 80 00       	push   $0x803f21
  802189:	e8 70 e6 ff ff       	call   8007fe <cprintf>
  80218e:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  802191:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802194:	89 45 f0             	mov    %eax,-0x10(%ebp)
	cprintf("\n=========================================\n");
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
	cprintf("\nFreeMemBlocksList:\n");
	uint8 sorted = 1 ;
	LIST_FOREACH(blk, &FreeMemBlocksList)
  802197:	a1 40 51 80 00       	mov    0x805140,%eax
  80219c:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80219f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8021a3:	74 07                	je     8021ac <print_mem_block_lists+0x9e>
  8021a5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8021a8:	8b 00                	mov    (%eax),%eax
  8021aa:	eb 05                	jmp    8021b1 <print_mem_block_lists+0xa3>
  8021ac:	b8 00 00 00 00       	mov    $0x0,%eax
  8021b1:	a3 40 51 80 00       	mov    %eax,0x805140
  8021b6:	a1 40 51 80 00       	mov    0x805140,%eax
  8021bb:	85 c0                	test   %eax,%eax
  8021bd:	75 8a                	jne    802149 <print_mem_block_lists+0x3b>
  8021bf:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8021c3:	75 84                	jne    802149 <print_mem_block_lists+0x3b>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;
  8021c5:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  8021c9:	75 10                	jne    8021db <print_mem_block_lists+0xcd>
  8021cb:	83 ec 0c             	sub    $0xc,%esp
  8021ce:	68 30 3f 80 00       	push   $0x803f30
  8021d3:	e8 26 e6 ff ff       	call   8007fe <cprintf>
  8021d8:	83 c4 10             	add    $0x10,%esp

	lastBlk = NULL ;
  8021db:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nAllocMemBlocksList:\n");
  8021e2:	83 ec 0c             	sub    $0xc,%esp
  8021e5:	68 54 3f 80 00       	push   $0x803f54
  8021ea:	e8 0f e6 ff ff       	call   8007fe <cprintf>
  8021ef:	83 c4 10             	add    $0x10,%esp
	sorted = 1 ;
  8021f2:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &AllocMemBlocksList)
  8021f6:	a1 40 50 80 00       	mov    0x805040,%eax
  8021fb:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8021fe:	eb 56                	jmp    802256 <print_mem_block_lists+0x148>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  802200:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802204:	74 1c                	je     802222 <print_mem_block_lists+0x114>
  802206:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802209:	8b 50 08             	mov    0x8(%eax),%edx
  80220c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80220f:	8b 48 08             	mov    0x8(%eax),%ecx
  802212:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802215:	8b 40 0c             	mov    0xc(%eax),%eax
  802218:	01 c8                	add    %ecx,%eax
  80221a:	39 c2                	cmp    %eax,%edx
  80221c:	73 04                	jae    802222 <print_mem_block_lists+0x114>
			sorted = 0 ;
  80221e:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  802222:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802225:	8b 50 08             	mov    0x8(%eax),%edx
  802228:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80222b:	8b 40 0c             	mov    0xc(%eax),%eax
  80222e:	01 c2                	add    %eax,%edx
  802230:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802233:	8b 40 08             	mov    0x8(%eax),%eax
  802236:	83 ec 04             	sub    $0x4,%esp
  802239:	52                   	push   %edx
  80223a:	50                   	push   %eax
  80223b:	68 21 3f 80 00       	push   $0x803f21
  802240:	e8 b9 e5 ff ff       	call   8007fe <cprintf>
  802245:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  802248:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80224b:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;

	lastBlk = NULL ;
	cprintf("\nAllocMemBlocksList:\n");
	sorted = 1 ;
	LIST_FOREACH(blk, &AllocMemBlocksList)
  80224e:	a1 48 50 80 00       	mov    0x805048,%eax
  802253:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802256:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80225a:	74 07                	je     802263 <print_mem_block_lists+0x155>
  80225c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80225f:	8b 00                	mov    (%eax),%eax
  802261:	eb 05                	jmp    802268 <print_mem_block_lists+0x15a>
  802263:	b8 00 00 00 00       	mov    $0x0,%eax
  802268:	a3 48 50 80 00       	mov    %eax,0x805048
  80226d:	a1 48 50 80 00       	mov    0x805048,%eax
  802272:	85 c0                	test   %eax,%eax
  802274:	75 8a                	jne    802200 <print_mem_block_lists+0xf2>
  802276:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80227a:	75 84                	jne    802200 <print_mem_block_lists+0xf2>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nAllocMemBlocksList is NOT SORTED!!\n") ;
  80227c:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  802280:	75 10                	jne    802292 <print_mem_block_lists+0x184>
  802282:	83 ec 0c             	sub    $0xc,%esp
  802285:	68 6c 3f 80 00       	push   $0x803f6c
  80228a:	e8 6f e5 ff ff       	call   8007fe <cprintf>
  80228f:	83 c4 10             	add    $0x10,%esp
	cprintf("\n=========================================\n");
  802292:	83 ec 0c             	sub    $0xc,%esp
  802295:	68 e0 3e 80 00       	push   $0x803ee0
  80229a:	e8 5f e5 ff ff       	call   8007fe <cprintf>
  80229f:	83 c4 10             	add    $0x10,%esp

}
  8022a2:	90                   	nop
  8022a3:	c9                   	leave  
  8022a4:	c3                   	ret    

008022a5 <initialize_MemBlocksList>:

//===============================
// [1] INITIALIZE AVAILABLE LIST:
//===============================
void initialize_MemBlocksList(uint32 numOfBlocks)
{
  8022a5:	55                   	push   %ebp
  8022a6:	89 e5                	mov    %esp,%ebp
  8022a8:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] initialize_MemBlocksList
	// Write your code here, remove the panic and write your code
	//panic("initialize_MemBlocksList() is not implemented yet...!!");
	uint32 n = numOfBlocks;
  8022ab:	8b 45 08             	mov    0x8(%ebp),%eax
  8022ae:	89 45 f0             	mov    %eax,-0x10(%ebp)

	LIST_INIT(&AvailableMemBlocksList);
  8022b1:	c7 05 48 51 80 00 00 	movl   $0x0,0x805148
  8022b8:	00 00 00 
  8022bb:	c7 05 4c 51 80 00 00 	movl   $0x0,0x80514c
  8022c2:	00 00 00 
  8022c5:	c7 05 54 51 80 00 00 	movl   $0x0,0x805154
  8022cc:	00 00 00 
	for(int i = 0; i<n;i++)
  8022cf:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  8022d6:	e9 9e 00 00 00       	jmp    802379 <initialize_MemBlocksList+0xd4>
	{
		LIST_INSERT_HEAD(&AvailableMemBlocksList, &(MemBlockNodes[i]));
  8022db:	a1 50 50 80 00       	mov    0x805050,%eax
  8022e0:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8022e3:	c1 e2 04             	shl    $0x4,%edx
  8022e6:	01 d0                	add    %edx,%eax
  8022e8:	85 c0                	test   %eax,%eax
  8022ea:	75 14                	jne    802300 <initialize_MemBlocksList+0x5b>
  8022ec:	83 ec 04             	sub    $0x4,%esp
  8022ef:	68 94 3f 80 00       	push   $0x803f94
  8022f4:	6a 47                	push   $0x47
  8022f6:	68 b7 3f 80 00       	push   $0x803fb7
  8022fb:	e8 4a e2 ff ff       	call   80054a <_panic>
  802300:	a1 50 50 80 00       	mov    0x805050,%eax
  802305:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802308:	c1 e2 04             	shl    $0x4,%edx
  80230b:	01 d0                	add    %edx,%eax
  80230d:	8b 15 48 51 80 00    	mov    0x805148,%edx
  802313:	89 10                	mov    %edx,(%eax)
  802315:	8b 00                	mov    (%eax),%eax
  802317:	85 c0                	test   %eax,%eax
  802319:	74 18                	je     802333 <initialize_MemBlocksList+0x8e>
  80231b:	a1 48 51 80 00       	mov    0x805148,%eax
  802320:	8b 15 50 50 80 00    	mov    0x805050,%edx
  802326:	8b 4d f4             	mov    -0xc(%ebp),%ecx
  802329:	c1 e1 04             	shl    $0x4,%ecx
  80232c:	01 ca                	add    %ecx,%edx
  80232e:	89 50 04             	mov    %edx,0x4(%eax)
  802331:	eb 12                	jmp    802345 <initialize_MemBlocksList+0xa0>
  802333:	a1 50 50 80 00       	mov    0x805050,%eax
  802338:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80233b:	c1 e2 04             	shl    $0x4,%edx
  80233e:	01 d0                	add    %edx,%eax
  802340:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802345:	a1 50 50 80 00       	mov    0x805050,%eax
  80234a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80234d:	c1 e2 04             	shl    $0x4,%edx
  802350:	01 d0                	add    %edx,%eax
  802352:	a3 48 51 80 00       	mov    %eax,0x805148
  802357:	a1 50 50 80 00       	mov    0x805050,%eax
  80235c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80235f:	c1 e2 04             	shl    $0x4,%edx
  802362:	01 d0                	add    %edx,%eax
  802364:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80236b:	a1 54 51 80 00       	mov    0x805154,%eax
  802370:	40                   	inc    %eax
  802371:	a3 54 51 80 00       	mov    %eax,0x805154
	// Write your code here, remove the panic and write your code
	//panic("initialize_MemBlocksList() is not implemented yet...!!");
	uint32 n = numOfBlocks;

	LIST_INIT(&AvailableMemBlocksList);
	for(int i = 0; i<n;i++)
  802376:	ff 45 f4             	incl   -0xc(%ebp)
  802379:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80237c:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  80237f:	0f 82 56 ff ff ff    	jb     8022db <initialize_MemBlocksList+0x36>
	{
		LIST_INSERT_HEAD(&AvailableMemBlocksList, &(MemBlockNodes[i]));
	}
}
  802385:	90                   	nop
  802386:	c9                   	leave  
  802387:	c3                   	ret    

00802388 <find_block>:

//===============================
// [2] FIND BLOCK:
//===============================
struct MemBlock *find_block(struct MemBlock_List *blockList, uint32 va)
{
  802388:	55                   	push   %ebp
  802389:	89 e5                	mov    %esp,%ebp
  80238b:	83 ec 10             	sub    $0x10,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] find_block
	// Write your code here, remove the panic and write your code
	//panic("find_block() is not implemented yet...!!");
	uint32 virAddress = va;
  80238e:	8b 45 0c             	mov    0xc(%ebp),%eax
  802391:	89 45 f4             	mov    %eax,-0xc(%ebp)
	struct MemBlock* blk;
	int found = 0;
  802394:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	LIST_FOREACH(blk, &(AllocMemBlocksList))
  80239b:	a1 40 50 80 00       	mov    0x805040,%eax
  8023a0:	89 45 fc             	mov    %eax,-0x4(%ebp)
  8023a3:	eb 23                	jmp    8023c8 <find_block+0x40>
	{
		if(blk->sva == virAddress)
  8023a5:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8023a8:	8b 40 08             	mov    0x8(%eax),%eax
  8023ab:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  8023ae:	75 09                	jne    8023b9 <find_block+0x31>
		{
			found = 1;
  8023b0:	c7 45 f8 01 00 00 00 	movl   $0x1,-0x8(%ebp)
			break;
  8023b7:	eb 35                	jmp    8023ee <find_block+0x66>
		}
		else
		{
			found = 0;
  8023b9:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	//panic("find_block() is not implemented yet...!!");
	uint32 virAddress = va;
	struct MemBlock* blk;
	int found = 0;

	LIST_FOREACH(blk, &(AllocMemBlocksList))
  8023c0:	a1 48 50 80 00       	mov    0x805048,%eax
  8023c5:	89 45 fc             	mov    %eax,-0x4(%ebp)
  8023c8:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  8023cc:	74 07                	je     8023d5 <find_block+0x4d>
  8023ce:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8023d1:	8b 00                	mov    (%eax),%eax
  8023d3:	eb 05                	jmp    8023da <find_block+0x52>
  8023d5:	b8 00 00 00 00       	mov    $0x0,%eax
  8023da:	a3 48 50 80 00       	mov    %eax,0x805048
  8023df:	a1 48 50 80 00       	mov    0x805048,%eax
  8023e4:	85 c0                	test   %eax,%eax
  8023e6:	75 bd                	jne    8023a5 <find_block+0x1d>
  8023e8:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  8023ec:	75 b7                	jne    8023a5 <find_block+0x1d>
		{
			found = 0;
			continue;
		}
	}
	if(found == 1)
  8023ee:	83 7d f8 01          	cmpl   $0x1,-0x8(%ebp)
  8023f2:	75 05                	jne    8023f9 <find_block+0x71>
	{
		return blk;
  8023f4:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8023f7:	eb 05                	jmp    8023fe <find_block+0x76>
	}
	else
	{
		return NULL;
  8023f9:	b8 00 00 00 00       	mov    $0x0,%eax
	}
}
  8023fe:	c9                   	leave  
  8023ff:	c3                   	ret    

00802400 <insert_sorted_allocList>:

//=========================================
// [3] INSERT BLOCK IN ALLOC LIST [SORTED]:
//=========================================
void insert_sorted_allocList(struct MemBlock *blockToInsert)
{
  802400:	55                   	push   %ebp
  802401:	89 e5                	mov    %esp,%ebp
  802403:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] insert_sorted_allocList
	// Write your code here, remove the panic and write your code
	//panic("insert_sorted_allocList() is not implemented yet...!!");
	struct MemBlock* blk;
	struct MemBlock* newblk = blockToInsert;
  802406:	8b 45 08             	mov    0x8(%ebp),%eax
  802409:	89 45 f0             	mov    %eax,-0x10(%ebp)

	if((LIST_EMPTY(&AllocMemBlocksList)) || (newblk->sva < LIST_FIRST(&AllocMemBlocksList)->sva))
  80240c:	a1 40 50 80 00       	mov    0x805040,%eax
  802411:	85 c0                	test   %eax,%eax
  802413:	74 12                	je     802427 <insert_sorted_allocList+0x27>
  802415:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802418:	8b 50 08             	mov    0x8(%eax),%edx
  80241b:	a1 40 50 80 00       	mov    0x805040,%eax
  802420:	8b 40 08             	mov    0x8(%eax),%eax
  802423:	39 c2                	cmp    %eax,%edx
  802425:	73 65                	jae    80248c <insert_sorted_allocList+0x8c>
	{
		LIST_INSERT_HEAD(&(AllocMemBlocksList), newblk);
  802427:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80242b:	75 14                	jne    802441 <insert_sorted_allocList+0x41>
  80242d:	83 ec 04             	sub    $0x4,%esp
  802430:	68 94 3f 80 00       	push   $0x803f94
  802435:	6a 7b                	push   $0x7b
  802437:	68 b7 3f 80 00       	push   $0x803fb7
  80243c:	e8 09 e1 ff ff       	call   80054a <_panic>
  802441:	8b 15 40 50 80 00    	mov    0x805040,%edx
  802447:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80244a:	89 10                	mov    %edx,(%eax)
  80244c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80244f:	8b 00                	mov    (%eax),%eax
  802451:	85 c0                	test   %eax,%eax
  802453:	74 0d                	je     802462 <insert_sorted_allocList+0x62>
  802455:	a1 40 50 80 00       	mov    0x805040,%eax
  80245a:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80245d:	89 50 04             	mov    %edx,0x4(%eax)
  802460:	eb 08                	jmp    80246a <insert_sorted_allocList+0x6a>
  802462:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802465:	a3 44 50 80 00       	mov    %eax,0x805044
  80246a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80246d:	a3 40 50 80 00       	mov    %eax,0x805040
  802472:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802475:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80247c:	a1 4c 50 80 00       	mov    0x80504c,%eax
  802481:	40                   	inc    %eax
  802482:	a3 4c 50 80 00       	mov    %eax,0x80504c
  802487:	e9 5f 01 00 00       	jmp    8025eb <insert_sorted_allocList+0x1eb>
	}
	else if(newblk->sva > LIST_LAST(&AllocMemBlocksList)->sva)
  80248c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80248f:	8b 50 08             	mov    0x8(%eax),%edx
  802492:	a1 44 50 80 00       	mov    0x805044,%eax
  802497:	8b 40 08             	mov    0x8(%eax),%eax
  80249a:	39 c2                	cmp    %eax,%edx
  80249c:	76 65                	jbe    802503 <insert_sorted_allocList+0x103>
	{
		LIST_INSERT_TAIL(&AllocMemBlocksList, newblk);
  80249e:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8024a2:	75 14                	jne    8024b8 <insert_sorted_allocList+0xb8>
  8024a4:	83 ec 04             	sub    $0x4,%esp
  8024a7:	68 d0 3f 80 00       	push   $0x803fd0
  8024ac:	6a 7f                	push   $0x7f
  8024ae:	68 b7 3f 80 00       	push   $0x803fb7
  8024b3:	e8 92 e0 ff ff       	call   80054a <_panic>
  8024b8:	8b 15 44 50 80 00    	mov    0x805044,%edx
  8024be:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8024c1:	89 50 04             	mov    %edx,0x4(%eax)
  8024c4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8024c7:	8b 40 04             	mov    0x4(%eax),%eax
  8024ca:	85 c0                	test   %eax,%eax
  8024cc:	74 0c                	je     8024da <insert_sorted_allocList+0xda>
  8024ce:	a1 44 50 80 00       	mov    0x805044,%eax
  8024d3:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8024d6:	89 10                	mov    %edx,(%eax)
  8024d8:	eb 08                	jmp    8024e2 <insert_sorted_allocList+0xe2>
  8024da:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8024dd:	a3 40 50 80 00       	mov    %eax,0x805040
  8024e2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8024e5:	a3 44 50 80 00       	mov    %eax,0x805044
  8024ea:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8024ed:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8024f3:	a1 4c 50 80 00       	mov    0x80504c,%eax
  8024f8:	40                   	inc    %eax
  8024f9:	a3 4c 50 80 00       	mov    %eax,0x80504c
				LIST_INSERT_AFTER(&AllocMemBlocksList, blk, newblk);
				break;
			}
		}
	}
}
  8024fe:	e9 e8 00 00 00       	jmp    8025eb <insert_sorted_allocList+0x1eb>
	{
		LIST_INSERT_TAIL(&AllocMemBlocksList, newblk);
	}
	else
	{
		LIST_FOREACH(blk, &AllocMemBlocksList)
  802503:	a1 40 50 80 00       	mov    0x805040,%eax
  802508:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80250b:	e9 ab 00 00 00       	jmp    8025bb <insert_sorted_allocList+0x1bb>
		{
			if(blk->prev_next_info.le_next != NULL && newblk->sva > blk->sva  && newblk->sva < blk->prev_next_info.le_next->sva)
  802510:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802513:	8b 00                	mov    (%eax),%eax
  802515:	85 c0                	test   %eax,%eax
  802517:	0f 84 96 00 00 00    	je     8025b3 <insert_sorted_allocList+0x1b3>
  80251d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802520:	8b 50 08             	mov    0x8(%eax),%edx
  802523:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802526:	8b 40 08             	mov    0x8(%eax),%eax
  802529:	39 c2                	cmp    %eax,%edx
  80252b:	0f 86 82 00 00 00    	jbe    8025b3 <insert_sorted_allocList+0x1b3>
  802531:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802534:	8b 50 08             	mov    0x8(%eax),%edx
  802537:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80253a:	8b 00                	mov    (%eax),%eax
  80253c:	8b 40 08             	mov    0x8(%eax),%eax
  80253f:	39 c2                	cmp    %eax,%edx
  802541:	73 70                	jae    8025b3 <insert_sorted_allocList+0x1b3>
			{
				LIST_INSERT_AFTER(&AllocMemBlocksList, blk, newblk);
  802543:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802547:	74 06                	je     80254f <insert_sorted_allocList+0x14f>
  802549:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80254d:	75 17                	jne    802566 <insert_sorted_allocList+0x166>
  80254f:	83 ec 04             	sub    $0x4,%esp
  802552:	68 f4 3f 80 00       	push   $0x803ff4
  802557:	68 87 00 00 00       	push   $0x87
  80255c:	68 b7 3f 80 00       	push   $0x803fb7
  802561:	e8 e4 df ff ff       	call   80054a <_panic>
  802566:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802569:	8b 10                	mov    (%eax),%edx
  80256b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80256e:	89 10                	mov    %edx,(%eax)
  802570:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802573:	8b 00                	mov    (%eax),%eax
  802575:	85 c0                	test   %eax,%eax
  802577:	74 0b                	je     802584 <insert_sorted_allocList+0x184>
  802579:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80257c:	8b 00                	mov    (%eax),%eax
  80257e:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802581:	89 50 04             	mov    %edx,0x4(%eax)
  802584:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802587:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80258a:	89 10                	mov    %edx,(%eax)
  80258c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80258f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802592:	89 50 04             	mov    %edx,0x4(%eax)
  802595:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802598:	8b 00                	mov    (%eax),%eax
  80259a:	85 c0                	test   %eax,%eax
  80259c:	75 08                	jne    8025a6 <insert_sorted_allocList+0x1a6>
  80259e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8025a1:	a3 44 50 80 00       	mov    %eax,0x805044
  8025a6:	a1 4c 50 80 00       	mov    0x80504c,%eax
  8025ab:	40                   	inc    %eax
  8025ac:	a3 4c 50 80 00       	mov    %eax,0x80504c
				break;
  8025b1:	eb 38                	jmp    8025eb <insert_sorted_allocList+0x1eb>
	{
		LIST_INSERT_TAIL(&AllocMemBlocksList, newblk);
	}
	else
	{
		LIST_FOREACH(blk, &AllocMemBlocksList)
  8025b3:	a1 48 50 80 00       	mov    0x805048,%eax
  8025b8:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8025bb:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8025bf:	74 07                	je     8025c8 <insert_sorted_allocList+0x1c8>
  8025c1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025c4:	8b 00                	mov    (%eax),%eax
  8025c6:	eb 05                	jmp    8025cd <insert_sorted_allocList+0x1cd>
  8025c8:	b8 00 00 00 00       	mov    $0x0,%eax
  8025cd:	a3 48 50 80 00       	mov    %eax,0x805048
  8025d2:	a1 48 50 80 00       	mov    0x805048,%eax
  8025d7:	85 c0                	test   %eax,%eax
  8025d9:	0f 85 31 ff ff ff    	jne    802510 <insert_sorted_allocList+0x110>
  8025df:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8025e3:	0f 85 27 ff ff ff    	jne    802510 <insert_sorted_allocList+0x110>
				LIST_INSERT_AFTER(&AllocMemBlocksList, blk, newblk);
				break;
			}
		}
	}
}
  8025e9:	eb 00                	jmp    8025eb <insert_sorted_allocList+0x1eb>
  8025eb:	90                   	nop
  8025ec:	c9                   	leave  
  8025ed:	c3                   	ret    

008025ee <alloc_block_FF>:

//=========================================
// [4] ALLOCATE BLOCK BY FIRST FIT:
//=========================================
struct MemBlock *alloc_block_FF(uint32 size)
{
  8025ee:	55                   	push   %ebp
  8025ef:	89 e5                	mov    %esp,%ebp
  8025f1:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_FF
	// Write your code here, remove the panic and write your code
	//panic("alloc_block_FF() is not implemented yet...!!");
	uint32 versize = size;
  8025f4:	8b 45 08             	mov    0x8(%ebp),%eax
  8025f7:	89 45 f0             	mov    %eax,-0x10(%ebp)
	struct MemBlock* blk;
	struct MemBlock* newblk = LIST_FIRST(&AvailableMemBlocksList);
  8025fa:	a1 48 51 80 00       	mov    0x805148,%eax
  8025ff:	89 45 ec             	mov    %eax,-0x14(%ebp)

	LIST_FOREACH(blk,&FreeMemBlocksList)
  802602:	a1 38 51 80 00       	mov    0x805138,%eax
  802607:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80260a:	e9 77 01 00 00       	jmp    802786 <alloc_block_FF+0x198>
	{
		if(blk->size == versize)
  80260f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802612:	8b 40 0c             	mov    0xc(%eax),%eax
  802615:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  802618:	0f 85 8a 00 00 00    	jne    8026a8 <alloc_block_FF+0xba>
		{
			LIST_REMOVE(&FreeMemBlocksList,blk);
  80261e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802622:	75 17                	jne    80263b <alloc_block_FF+0x4d>
  802624:	83 ec 04             	sub    $0x4,%esp
  802627:	68 28 40 80 00       	push   $0x804028
  80262c:	68 9e 00 00 00       	push   $0x9e
  802631:	68 b7 3f 80 00       	push   $0x803fb7
  802636:	e8 0f df ff ff       	call   80054a <_panic>
  80263b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80263e:	8b 00                	mov    (%eax),%eax
  802640:	85 c0                	test   %eax,%eax
  802642:	74 10                	je     802654 <alloc_block_FF+0x66>
  802644:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802647:	8b 00                	mov    (%eax),%eax
  802649:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80264c:	8b 52 04             	mov    0x4(%edx),%edx
  80264f:	89 50 04             	mov    %edx,0x4(%eax)
  802652:	eb 0b                	jmp    80265f <alloc_block_FF+0x71>
  802654:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802657:	8b 40 04             	mov    0x4(%eax),%eax
  80265a:	a3 3c 51 80 00       	mov    %eax,0x80513c
  80265f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802662:	8b 40 04             	mov    0x4(%eax),%eax
  802665:	85 c0                	test   %eax,%eax
  802667:	74 0f                	je     802678 <alloc_block_FF+0x8a>
  802669:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80266c:	8b 40 04             	mov    0x4(%eax),%eax
  80266f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802672:	8b 12                	mov    (%edx),%edx
  802674:	89 10                	mov    %edx,(%eax)
  802676:	eb 0a                	jmp    802682 <alloc_block_FF+0x94>
  802678:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80267b:	8b 00                	mov    (%eax),%eax
  80267d:	a3 38 51 80 00       	mov    %eax,0x805138
  802682:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802685:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80268b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80268e:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802695:	a1 44 51 80 00       	mov    0x805144,%eax
  80269a:	48                   	dec    %eax
  80269b:	a3 44 51 80 00       	mov    %eax,0x805144
			return blk;
  8026a0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026a3:	e9 11 01 00 00       	jmp    8027b9 <alloc_block_FF+0x1cb>
		}
		else if(blk->size > versize)
  8026a8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026ab:	8b 40 0c             	mov    0xc(%eax),%eax
  8026ae:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8026b1:	0f 86 c7 00 00 00    	jbe    80277e <alloc_block_FF+0x190>
		{
			LIST_REMOVE(&AvailableMemBlocksList,newblk);
  8026b7:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8026bb:	75 17                	jne    8026d4 <alloc_block_FF+0xe6>
  8026bd:	83 ec 04             	sub    $0x4,%esp
  8026c0:	68 28 40 80 00       	push   $0x804028
  8026c5:	68 a3 00 00 00       	push   $0xa3
  8026ca:	68 b7 3f 80 00       	push   $0x803fb7
  8026cf:	e8 76 de ff ff       	call   80054a <_panic>
  8026d4:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8026d7:	8b 00                	mov    (%eax),%eax
  8026d9:	85 c0                	test   %eax,%eax
  8026db:	74 10                	je     8026ed <alloc_block_FF+0xff>
  8026dd:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8026e0:	8b 00                	mov    (%eax),%eax
  8026e2:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8026e5:	8b 52 04             	mov    0x4(%edx),%edx
  8026e8:	89 50 04             	mov    %edx,0x4(%eax)
  8026eb:	eb 0b                	jmp    8026f8 <alloc_block_FF+0x10a>
  8026ed:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8026f0:	8b 40 04             	mov    0x4(%eax),%eax
  8026f3:	a3 4c 51 80 00       	mov    %eax,0x80514c
  8026f8:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8026fb:	8b 40 04             	mov    0x4(%eax),%eax
  8026fe:	85 c0                	test   %eax,%eax
  802700:	74 0f                	je     802711 <alloc_block_FF+0x123>
  802702:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802705:	8b 40 04             	mov    0x4(%eax),%eax
  802708:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80270b:	8b 12                	mov    (%edx),%edx
  80270d:	89 10                	mov    %edx,(%eax)
  80270f:	eb 0a                	jmp    80271b <alloc_block_FF+0x12d>
  802711:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802714:	8b 00                	mov    (%eax),%eax
  802716:	a3 48 51 80 00       	mov    %eax,0x805148
  80271b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80271e:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802724:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802727:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80272e:	a1 54 51 80 00       	mov    0x805154,%eax
  802733:	48                   	dec    %eax
  802734:	a3 54 51 80 00       	mov    %eax,0x805154
			newblk->size = versize;
  802739:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80273c:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80273f:	89 50 0c             	mov    %edx,0xc(%eax)
			blk->size = blk->size-versize;
  802742:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802745:	8b 40 0c             	mov    0xc(%eax),%eax
  802748:	2b 45 f0             	sub    -0x10(%ebp),%eax
  80274b:	89 c2                	mov    %eax,%edx
  80274d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802750:	89 50 0c             	mov    %edx,0xc(%eax)
			uint32 newveradd = blk->sva;
  802753:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802756:	8b 40 08             	mov    0x8(%eax),%eax
  802759:	89 45 e8             	mov    %eax,-0x18(%ebp)
			blk->sva+=newblk->size;
  80275c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80275f:	8b 50 08             	mov    0x8(%eax),%edx
  802762:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802765:	8b 40 0c             	mov    0xc(%eax),%eax
  802768:	01 c2                	add    %eax,%edx
  80276a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80276d:	89 50 08             	mov    %edx,0x8(%eax)
			newblk->sva = newveradd;
  802770:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802773:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802776:	89 50 08             	mov    %edx,0x8(%eax)
			return newblk;
  802779:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80277c:	eb 3b                	jmp    8027b9 <alloc_block_FF+0x1cb>
	//panic("alloc_block_FF() is not implemented yet...!!");
	uint32 versize = size;
	struct MemBlock* blk;
	struct MemBlock* newblk = LIST_FIRST(&AvailableMemBlocksList);

	LIST_FOREACH(blk,&FreeMemBlocksList)
  80277e:	a1 40 51 80 00       	mov    0x805140,%eax
  802783:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802786:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80278a:	74 07                	je     802793 <alloc_block_FF+0x1a5>
  80278c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80278f:	8b 00                	mov    (%eax),%eax
  802791:	eb 05                	jmp    802798 <alloc_block_FF+0x1aa>
  802793:	b8 00 00 00 00       	mov    $0x0,%eax
  802798:	a3 40 51 80 00       	mov    %eax,0x805140
  80279d:	a1 40 51 80 00       	mov    0x805140,%eax
  8027a2:	85 c0                	test   %eax,%eax
  8027a4:	0f 85 65 fe ff ff    	jne    80260f <alloc_block_FF+0x21>
  8027aa:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8027ae:	0f 85 5b fe ff ff    	jne    80260f <alloc_block_FF+0x21>
			blk->sva+=newblk->size;
			newblk->sva = newveradd;
			return newblk;
		}
	}
	return NULL;
  8027b4:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8027b9:	c9                   	leave  
  8027ba:	c3                   	ret    

008027bb <alloc_block_BF>:

//=========================================
// [5] ALLOCATE BLOCK BY BEST FIT:
//=========================================
struct MemBlock *alloc_block_BF(uint32 size)
{
  8027bb:	55                   	push   %ebp
  8027bc:	89 e5                	mov    %esp,%ebp
  8027be:	83 ec 28             	sub    $0x28,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_BF
	// Write your code here, remove the panic and write your code
	//panic("alloc_block_BF() is not implemented yet...!!");
	uint32 versize=size;
  8027c1:	8b 45 08             	mov    0x8(%ebp),%eax
  8027c4:	89 45 e8             	mov    %eax,-0x18(%ebp)
	struct MemBlock* blk;
	struct MemBlock* newblk=LIST_FIRST(&AvailableMemBlocksList);
  8027c7:	a1 48 51 80 00       	mov    0x805148,%eax
  8027cc:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	uint32 newveradd;
	uint32 newsize;
	int size_free = LIST_SIZE(&FreeMemBlocksList);
  8027cf:	a1 44 51 80 00       	mov    0x805144,%eax
  8027d4:	89 45 e0             	mov    %eax,-0x20(%ebp)

	LIST_FOREACH(blk, &FreeMemBlocksList)
  8027d7:	a1 38 51 80 00       	mov    0x805138,%eax
  8027dc:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8027df:	e9 a1 00 00 00       	jmp    802885 <alloc_block_BF+0xca>
	{
		if(blk->size == versize)
  8027e4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027e7:	8b 40 0c             	mov    0xc(%eax),%eax
  8027ea:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  8027ed:	0f 85 8a 00 00 00    	jne    80287d <alloc_block_BF+0xc2>
		{
			LIST_REMOVE(&FreeMemBlocksList, blk);
  8027f3:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8027f7:	75 17                	jne    802810 <alloc_block_BF+0x55>
  8027f9:	83 ec 04             	sub    $0x4,%esp
  8027fc:	68 28 40 80 00       	push   $0x804028
  802801:	68 c2 00 00 00       	push   $0xc2
  802806:	68 b7 3f 80 00       	push   $0x803fb7
  80280b:	e8 3a dd ff ff       	call   80054a <_panic>
  802810:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802813:	8b 00                	mov    (%eax),%eax
  802815:	85 c0                	test   %eax,%eax
  802817:	74 10                	je     802829 <alloc_block_BF+0x6e>
  802819:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80281c:	8b 00                	mov    (%eax),%eax
  80281e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802821:	8b 52 04             	mov    0x4(%edx),%edx
  802824:	89 50 04             	mov    %edx,0x4(%eax)
  802827:	eb 0b                	jmp    802834 <alloc_block_BF+0x79>
  802829:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80282c:	8b 40 04             	mov    0x4(%eax),%eax
  80282f:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802834:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802837:	8b 40 04             	mov    0x4(%eax),%eax
  80283a:	85 c0                	test   %eax,%eax
  80283c:	74 0f                	je     80284d <alloc_block_BF+0x92>
  80283e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802841:	8b 40 04             	mov    0x4(%eax),%eax
  802844:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802847:	8b 12                	mov    (%edx),%edx
  802849:	89 10                	mov    %edx,(%eax)
  80284b:	eb 0a                	jmp    802857 <alloc_block_BF+0x9c>
  80284d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802850:	8b 00                	mov    (%eax),%eax
  802852:	a3 38 51 80 00       	mov    %eax,0x805138
  802857:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80285a:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802860:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802863:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80286a:	a1 44 51 80 00       	mov    0x805144,%eax
  80286f:	48                   	dec    %eax
  802870:	a3 44 51 80 00       	mov    %eax,0x805144
			return blk;
  802875:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802878:	e9 11 02 00 00       	jmp    802a8e <alloc_block_BF+0x2d3>
	struct MemBlock* newblk=LIST_FIRST(&AvailableMemBlocksList);
	uint32 newveradd;
	uint32 newsize;
	int size_free = LIST_SIZE(&FreeMemBlocksList);

	LIST_FOREACH(blk, &FreeMemBlocksList)
  80287d:	a1 40 51 80 00       	mov    0x805140,%eax
  802882:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802885:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802889:	74 07                	je     802892 <alloc_block_BF+0xd7>
  80288b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80288e:	8b 00                	mov    (%eax),%eax
  802890:	eb 05                	jmp    802897 <alloc_block_BF+0xdc>
  802892:	b8 00 00 00 00       	mov    $0x0,%eax
  802897:	a3 40 51 80 00       	mov    %eax,0x805140
  80289c:	a1 40 51 80 00       	mov    0x805140,%eax
  8028a1:	85 c0                	test   %eax,%eax
  8028a3:	0f 85 3b ff ff ff    	jne    8027e4 <alloc_block_BF+0x29>
  8028a9:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8028ad:	0f 85 31 ff ff ff    	jne    8027e4 <alloc_block_BF+0x29>
		{
			LIST_REMOVE(&FreeMemBlocksList, blk);
			return blk;
		}
	}
	LIST_FOREACH(blk, &FreeMemBlocksList)
  8028b3:	a1 38 51 80 00       	mov    0x805138,%eax
  8028b8:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8028bb:	eb 27                	jmp    8028e4 <alloc_block_BF+0x129>
	{
		if(blk->size > versize)
  8028bd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028c0:	8b 40 0c             	mov    0xc(%eax),%eax
  8028c3:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  8028c6:	76 14                	jbe    8028dc <alloc_block_BF+0x121>
		{
			newsize = blk->size;
  8028c8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028cb:	8b 40 0c             	mov    0xc(%eax),%eax
  8028ce:	89 45 ec             	mov    %eax,-0x14(%ebp)
			newveradd = blk->sva;
  8028d1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028d4:	8b 40 08             	mov    0x8(%eax),%eax
  8028d7:	89 45 f0             	mov    %eax,-0x10(%ebp)
			break;
  8028da:	eb 2e                	jmp    80290a <alloc_block_BF+0x14f>
		{
			LIST_REMOVE(&FreeMemBlocksList, blk);
			return blk;
		}
	}
	LIST_FOREACH(blk, &FreeMemBlocksList)
  8028dc:	a1 40 51 80 00       	mov    0x805140,%eax
  8028e1:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8028e4:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8028e8:	74 07                	je     8028f1 <alloc_block_BF+0x136>
  8028ea:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028ed:	8b 00                	mov    (%eax),%eax
  8028ef:	eb 05                	jmp    8028f6 <alloc_block_BF+0x13b>
  8028f1:	b8 00 00 00 00       	mov    $0x0,%eax
  8028f6:	a3 40 51 80 00       	mov    %eax,0x805140
  8028fb:	a1 40 51 80 00       	mov    0x805140,%eax
  802900:	85 c0                	test   %eax,%eax
  802902:	75 b9                	jne    8028bd <alloc_block_BF+0x102>
  802904:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802908:	75 b3                	jne    8028bd <alloc_block_BF+0x102>
			newsize = blk->size;
			newveradd = blk->sva;
			break;
		}
	}
	LIST_FOREACH(blk, &FreeMemBlocksList)
  80290a:	a1 38 51 80 00       	mov    0x805138,%eax
  80290f:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802912:	eb 30                	jmp    802944 <alloc_block_BF+0x189>
	{
		if(newsize > blk->size && blk->size > versize)
  802914:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802917:	8b 40 0c             	mov    0xc(%eax),%eax
  80291a:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  80291d:	73 1d                	jae    80293c <alloc_block_BF+0x181>
  80291f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802922:	8b 40 0c             	mov    0xc(%eax),%eax
  802925:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  802928:	76 12                	jbe    80293c <alloc_block_BF+0x181>
		{
	       newsize = blk->size;
  80292a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80292d:	8b 40 0c             	mov    0xc(%eax),%eax
  802930:	89 45 ec             	mov    %eax,-0x14(%ebp)
		   newveradd = blk->sva;
  802933:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802936:	8b 40 08             	mov    0x8(%eax),%eax
  802939:	89 45 f0             	mov    %eax,-0x10(%ebp)
			newsize = blk->size;
			newveradd = blk->sva;
			break;
		}
	}
	LIST_FOREACH(blk, &FreeMemBlocksList)
  80293c:	a1 40 51 80 00       	mov    0x805140,%eax
  802941:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802944:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802948:	74 07                	je     802951 <alloc_block_BF+0x196>
  80294a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80294d:	8b 00                	mov    (%eax),%eax
  80294f:	eb 05                	jmp    802956 <alloc_block_BF+0x19b>
  802951:	b8 00 00 00 00       	mov    $0x0,%eax
  802956:	a3 40 51 80 00       	mov    %eax,0x805140
  80295b:	a1 40 51 80 00       	mov    0x805140,%eax
  802960:	85 c0                	test   %eax,%eax
  802962:	75 b0                	jne    802914 <alloc_block_BF+0x159>
  802964:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802968:	75 aa                	jne    802914 <alloc_block_BF+0x159>
		{
	       newsize = blk->size;
		   newveradd = blk->sva;
		}
	}
	LIST_FOREACH(blk, &FreeMemBlocksList)
  80296a:	a1 38 51 80 00       	mov    0x805138,%eax
  80296f:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802972:	e9 e4 00 00 00       	jmp    802a5b <alloc_block_BF+0x2a0>
	{
		if(blk->size == newsize && blk->sva == newveradd)
  802977:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80297a:	8b 40 0c             	mov    0xc(%eax),%eax
  80297d:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  802980:	0f 85 cd 00 00 00    	jne    802a53 <alloc_block_BF+0x298>
  802986:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802989:	8b 40 08             	mov    0x8(%eax),%eax
  80298c:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  80298f:	0f 85 be 00 00 00    	jne    802a53 <alloc_block_BF+0x298>
		{
			LIST_REMOVE(&AvailableMemBlocksList, newblk);
  802995:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  802999:	75 17                	jne    8029b2 <alloc_block_BF+0x1f7>
  80299b:	83 ec 04             	sub    $0x4,%esp
  80299e:	68 28 40 80 00       	push   $0x804028
  8029a3:	68 db 00 00 00       	push   $0xdb
  8029a8:	68 b7 3f 80 00       	push   $0x803fb7
  8029ad:	e8 98 db ff ff       	call   80054a <_panic>
  8029b2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8029b5:	8b 00                	mov    (%eax),%eax
  8029b7:	85 c0                	test   %eax,%eax
  8029b9:	74 10                	je     8029cb <alloc_block_BF+0x210>
  8029bb:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8029be:	8b 00                	mov    (%eax),%eax
  8029c0:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8029c3:	8b 52 04             	mov    0x4(%edx),%edx
  8029c6:	89 50 04             	mov    %edx,0x4(%eax)
  8029c9:	eb 0b                	jmp    8029d6 <alloc_block_BF+0x21b>
  8029cb:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8029ce:	8b 40 04             	mov    0x4(%eax),%eax
  8029d1:	a3 4c 51 80 00       	mov    %eax,0x80514c
  8029d6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8029d9:	8b 40 04             	mov    0x4(%eax),%eax
  8029dc:	85 c0                	test   %eax,%eax
  8029de:	74 0f                	je     8029ef <alloc_block_BF+0x234>
  8029e0:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8029e3:	8b 40 04             	mov    0x4(%eax),%eax
  8029e6:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8029e9:	8b 12                	mov    (%edx),%edx
  8029eb:	89 10                	mov    %edx,(%eax)
  8029ed:	eb 0a                	jmp    8029f9 <alloc_block_BF+0x23e>
  8029ef:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8029f2:	8b 00                	mov    (%eax),%eax
  8029f4:	a3 48 51 80 00       	mov    %eax,0x805148
  8029f9:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8029fc:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802a02:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802a05:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802a0c:	a1 54 51 80 00       	mov    0x805154,%eax
  802a11:	48                   	dec    %eax
  802a12:	a3 54 51 80 00       	mov    %eax,0x805154
			newblk->size = versize;
  802a17:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802a1a:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802a1d:	89 50 0c             	mov    %edx,0xc(%eax)
			newblk->sva = newveradd;
  802a20:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802a23:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802a26:	89 50 08             	mov    %edx,0x8(%eax)
			blk->size = blk->size - versize;
  802a29:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a2c:	8b 40 0c             	mov    0xc(%eax),%eax
  802a2f:	2b 45 e8             	sub    -0x18(%ebp),%eax
  802a32:	89 c2                	mov    %eax,%edx
  802a34:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a37:	89 50 0c             	mov    %edx,0xc(%eax)
			blk->sva+= newblk->size;
  802a3a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a3d:	8b 50 08             	mov    0x8(%eax),%edx
  802a40:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802a43:	8b 40 0c             	mov    0xc(%eax),%eax
  802a46:	01 c2                	add    %eax,%edx
  802a48:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a4b:	89 50 08             	mov    %edx,0x8(%eax)
			return newblk;
  802a4e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802a51:	eb 3b                	jmp    802a8e <alloc_block_BF+0x2d3>
		{
	       newsize = blk->size;
		   newveradd = blk->sva;
		}
	}
	LIST_FOREACH(blk, &FreeMemBlocksList)
  802a53:	a1 40 51 80 00       	mov    0x805140,%eax
  802a58:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802a5b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802a5f:	74 07                	je     802a68 <alloc_block_BF+0x2ad>
  802a61:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a64:	8b 00                	mov    (%eax),%eax
  802a66:	eb 05                	jmp    802a6d <alloc_block_BF+0x2b2>
  802a68:	b8 00 00 00 00       	mov    $0x0,%eax
  802a6d:	a3 40 51 80 00       	mov    %eax,0x805140
  802a72:	a1 40 51 80 00       	mov    0x805140,%eax
  802a77:	85 c0                	test   %eax,%eax
  802a79:	0f 85 f8 fe ff ff    	jne    802977 <alloc_block_BF+0x1bc>
  802a7f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802a83:	0f 85 ee fe ff ff    	jne    802977 <alloc_block_BF+0x1bc>
			blk->size = blk->size - versize;
			blk->sva+= newblk->size;
			return newblk;
		}
	}
	return NULL;
  802a89:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802a8e:	c9                   	leave  
  802a8f:	c3                   	ret    

00802a90 <alloc_block_NF>:
//=========================================
// [7] ALLOCATE BLOCK BY NEXT FIT:
//=========================================
struct MemBlock *last_allocate;
struct MemBlock *alloc_block_NF(uint32 size)
{
  802a90:	55                   	push   %ebp
  802a91:	89 e5                	mov    %esp,%ebp
  802a93:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1 - BONUS] [DYNAMIC ALLOCATOR] alloc_block_NF
	// Write your code here, remove the panic and write your code
	//panic("alloc_block_NF() is not implemented yet...!!");
	uint32 versize = size;
  802a96:	8b 45 08             	mov    0x8(%ebp),%eax
  802a99:	89 45 f0             	mov    %eax,-0x10(%ebp)
	struct MemBlock* blk;
	struct MemBlock* newblk = LIST_FIRST(&AvailableMemBlocksList);
  802a9c:	a1 48 51 80 00       	mov    0x805148,%eax
  802aa1:	89 45 ec             	mov    %eax,-0x14(%ebp)

	LIST_FOREACH(blk,&FreeMemBlocksList)
  802aa4:	a1 38 51 80 00       	mov    0x805138,%eax
  802aa9:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802aac:	e9 77 01 00 00       	jmp    802c28 <alloc_block_NF+0x198>
	{
		if(blk->size == versize)
  802ab1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ab4:	8b 40 0c             	mov    0xc(%eax),%eax
  802ab7:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  802aba:	0f 85 8a 00 00 00    	jne    802b4a <alloc_block_NF+0xba>
		{
			LIST_REMOVE(&FreeMemBlocksList,blk);
  802ac0:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802ac4:	75 17                	jne    802add <alloc_block_NF+0x4d>
  802ac6:	83 ec 04             	sub    $0x4,%esp
  802ac9:	68 28 40 80 00       	push   $0x804028
  802ace:	68 f7 00 00 00       	push   $0xf7
  802ad3:	68 b7 3f 80 00       	push   $0x803fb7
  802ad8:	e8 6d da ff ff       	call   80054a <_panic>
  802add:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ae0:	8b 00                	mov    (%eax),%eax
  802ae2:	85 c0                	test   %eax,%eax
  802ae4:	74 10                	je     802af6 <alloc_block_NF+0x66>
  802ae6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ae9:	8b 00                	mov    (%eax),%eax
  802aeb:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802aee:	8b 52 04             	mov    0x4(%edx),%edx
  802af1:	89 50 04             	mov    %edx,0x4(%eax)
  802af4:	eb 0b                	jmp    802b01 <alloc_block_NF+0x71>
  802af6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802af9:	8b 40 04             	mov    0x4(%eax),%eax
  802afc:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802b01:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b04:	8b 40 04             	mov    0x4(%eax),%eax
  802b07:	85 c0                	test   %eax,%eax
  802b09:	74 0f                	je     802b1a <alloc_block_NF+0x8a>
  802b0b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b0e:	8b 40 04             	mov    0x4(%eax),%eax
  802b11:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802b14:	8b 12                	mov    (%edx),%edx
  802b16:	89 10                	mov    %edx,(%eax)
  802b18:	eb 0a                	jmp    802b24 <alloc_block_NF+0x94>
  802b1a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b1d:	8b 00                	mov    (%eax),%eax
  802b1f:	a3 38 51 80 00       	mov    %eax,0x805138
  802b24:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b27:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802b2d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b30:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802b37:	a1 44 51 80 00       	mov    0x805144,%eax
  802b3c:	48                   	dec    %eax
  802b3d:	a3 44 51 80 00       	mov    %eax,0x805144
			return blk;
  802b42:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b45:	e9 11 01 00 00       	jmp    802c5b <alloc_block_NF+0x1cb>
		}
		else if(blk->size > versize)
  802b4a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b4d:	8b 40 0c             	mov    0xc(%eax),%eax
  802b50:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  802b53:	0f 86 c7 00 00 00    	jbe    802c20 <alloc_block_NF+0x190>
		{
			LIST_REMOVE(&AvailableMemBlocksList,newblk);
  802b59:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802b5d:	75 17                	jne    802b76 <alloc_block_NF+0xe6>
  802b5f:	83 ec 04             	sub    $0x4,%esp
  802b62:	68 28 40 80 00       	push   $0x804028
  802b67:	68 fc 00 00 00       	push   $0xfc
  802b6c:	68 b7 3f 80 00       	push   $0x803fb7
  802b71:	e8 d4 d9 ff ff       	call   80054a <_panic>
  802b76:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802b79:	8b 00                	mov    (%eax),%eax
  802b7b:	85 c0                	test   %eax,%eax
  802b7d:	74 10                	je     802b8f <alloc_block_NF+0xff>
  802b7f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802b82:	8b 00                	mov    (%eax),%eax
  802b84:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802b87:	8b 52 04             	mov    0x4(%edx),%edx
  802b8a:	89 50 04             	mov    %edx,0x4(%eax)
  802b8d:	eb 0b                	jmp    802b9a <alloc_block_NF+0x10a>
  802b8f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802b92:	8b 40 04             	mov    0x4(%eax),%eax
  802b95:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802b9a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802b9d:	8b 40 04             	mov    0x4(%eax),%eax
  802ba0:	85 c0                	test   %eax,%eax
  802ba2:	74 0f                	je     802bb3 <alloc_block_NF+0x123>
  802ba4:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802ba7:	8b 40 04             	mov    0x4(%eax),%eax
  802baa:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802bad:	8b 12                	mov    (%edx),%edx
  802baf:	89 10                	mov    %edx,(%eax)
  802bb1:	eb 0a                	jmp    802bbd <alloc_block_NF+0x12d>
  802bb3:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802bb6:	8b 00                	mov    (%eax),%eax
  802bb8:	a3 48 51 80 00       	mov    %eax,0x805148
  802bbd:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802bc0:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802bc6:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802bc9:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802bd0:	a1 54 51 80 00       	mov    0x805154,%eax
  802bd5:	48                   	dec    %eax
  802bd6:	a3 54 51 80 00       	mov    %eax,0x805154
			newblk->size = versize;
  802bdb:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802bde:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802be1:	89 50 0c             	mov    %edx,0xc(%eax)
			blk->size = blk->size-versize;
  802be4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802be7:	8b 40 0c             	mov    0xc(%eax),%eax
  802bea:	2b 45 f0             	sub    -0x10(%ebp),%eax
  802bed:	89 c2                	mov    %eax,%edx
  802bef:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bf2:	89 50 0c             	mov    %edx,0xc(%eax)
			uint32 newveradd = blk->sva;
  802bf5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bf8:	8b 40 08             	mov    0x8(%eax),%eax
  802bfb:	89 45 e8             	mov    %eax,-0x18(%ebp)
			blk->sva+=newblk->size;
  802bfe:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c01:	8b 50 08             	mov    0x8(%eax),%edx
  802c04:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802c07:	8b 40 0c             	mov    0xc(%eax),%eax
  802c0a:	01 c2                	add    %eax,%edx
  802c0c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c0f:	89 50 08             	mov    %edx,0x8(%eax)
			newblk->sva = newveradd;
  802c12:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802c15:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802c18:	89 50 08             	mov    %edx,0x8(%eax)
			return newblk;
  802c1b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802c1e:	eb 3b                	jmp    802c5b <alloc_block_NF+0x1cb>
	//panic("alloc_block_NF() is not implemented yet...!!");
	uint32 versize = size;
	struct MemBlock* blk;
	struct MemBlock* newblk = LIST_FIRST(&AvailableMemBlocksList);

	LIST_FOREACH(blk,&FreeMemBlocksList)
  802c20:	a1 40 51 80 00       	mov    0x805140,%eax
  802c25:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802c28:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802c2c:	74 07                	je     802c35 <alloc_block_NF+0x1a5>
  802c2e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c31:	8b 00                	mov    (%eax),%eax
  802c33:	eb 05                	jmp    802c3a <alloc_block_NF+0x1aa>
  802c35:	b8 00 00 00 00       	mov    $0x0,%eax
  802c3a:	a3 40 51 80 00       	mov    %eax,0x805140
  802c3f:	a1 40 51 80 00       	mov    0x805140,%eax
  802c44:	85 c0                	test   %eax,%eax
  802c46:	0f 85 65 fe ff ff    	jne    802ab1 <alloc_block_NF+0x21>
  802c4c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802c50:	0f 85 5b fe ff ff    	jne    802ab1 <alloc_block_NF+0x21>
			blk->sva+=newblk->size;
			newblk->sva = newveradd;
			return newblk;
		}
	}
	return NULL;
  802c56:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802c5b:	c9                   	leave  
  802c5c:	c3                   	ret    

00802c5d <addToAvailMemBlocksList>:

//===================================================
// [8] INSERT BLOCK (SORTED WITH MERGE) IN FREE LIST:
//===================================================
void addToAvailMemBlocksList(struct MemBlock *blockToInsert)
{
  802c5d:	55                   	push   %ebp
  802c5e:	89 e5                	mov    %esp,%ebp
  802c60:	83 ec 08             	sub    $0x8,%esp
	blockToInsert->sva = 0;
  802c63:	8b 45 08             	mov    0x8(%ebp),%eax
  802c66:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
	blockToInsert->size = 0;
  802c6d:	8b 45 08             	mov    0x8(%ebp),%eax
  802c70:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
	//add to avail
	LIST_INSERT_TAIL(&AvailableMemBlocksList, blockToInsert);
  802c77:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802c7b:	75 17                	jne    802c94 <addToAvailMemBlocksList+0x37>
  802c7d:	83 ec 04             	sub    $0x4,%esp
  802c80:	68 d0 3f 80 00       	push   $0x803fd0
  802c85:	68 10 01 00 00       	push   $0x110
  802c8a:	68 b7 3f 80 00       	push   $0x803fb7
  802c8f:	e8 b6 d8 ff ff       	call   80054a <_panic>
  802c94:	8b 15 4c 51 80 00    	mov    0x80514c,%edx
  802c9a:	8b 45 08             	mov    0x8(%ebp),%eax
  802c9d:	89 50 04             	mov    %edx,0x4(%eax)
  802ca0:	8b 45 08             	mov    0x8(%ebp),%eax
  802ca3:	8b 40 04             	mov    0x4(%eax),%eax
  802ca6:	85 c0                	test   %eax,%eax
  802ca8:	74 0c                	je     802cb6 <addToAvailMemBlocksList+0x59>
  802caa:	a1 4c 51 80 00       	mov    0x80514c,%eax
  802caf:	8b 55 08             	mov    0x8(%ebp),%edx
  802cb2:	89 10                	mov    %edx,(%eax)
  802cb4:	eb 08                	jmp    802cbe <addToAvailMemBlocksList+0x61>
  802cb6:	8b 45 08             	mov    0x8(%ebp),%eax
  802cb9:	a3 48 51 80 00       	mov    %eax,0x805148
  802cbe:	8b 45 08             	mov    0x8(%ebp),%eax
  802cc1:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802cc6:	8b 45 08             	mov    0x8(%ebp),%eax
  802cc9:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802ccf:	a1 54 51 80 00       	mov    0x805154,%eax
  802cd4:	40                   	inc    %eax
  802cd5:	a3 54 51 80 00       	mov    %eax,0x805154
}
  802cda:	90                   	nop
  802cdb:	c9                   	leave  
  802cdc:	c3                   	ret    

00802cdd <insert_sorted_with_merge_freeList>:
void insert_sorted_with_merge_freeList(struct MemBlock *blockToInsert)
{
  802cdd:	55                   	push   %ebp
  802cde:	89 e5                	mov    %esp,%ebp
  802ce0:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] insert_sorted_with_merge_freeList
	// Write your code here, remove the panic and write your code

	struct MemBlock* last = LIST_LAST(&FreeMemBlocksList);
  802ce3:	a1 3c 51 80 00       	mov    0x80513c,%eax
  802ce8:	89 45 f0             	mov    %eax,-0x10(%ebp)
	//check if list empty
	if (LIST_SIZE(&(FreeMemBlocksList)) == 0)
  802ceb:	a1 44 51 80 00       	mov    0x805144,%eax
  802cf0:	85 c0                	test   %eax,%eax
  802cf2:	75 68                	jne    802d5c <insert_sorted_with_merge_freeList+0x7f>
		LIST_INSERT_HEAD(&FreeMemBlocksList, blockToInsert);
  802cf4:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802cf8:	75 17                	jne    802d11 <insert_sorted_with_merge_freeList+0x34>
  802cfa:	83 ec 04             	sub    $0x4,%esp
  802cfd:	68 94 3f 80 00       	push   $0x803f94
  802d02:	68 1a 01 00 00       	push   $0x11a
  802d07:	68 b7 3f 80 00       	push   $0x803fb7
  802d0c:	e8 39 d8 ff ff       	call   80054a <_panic>
  802d11:	8b 15 38 51 80 00    	mov    0x805138,%edx
  802d17:	8b 45 08             	mov    0x8(%ebp),%eax
  802d1a:	89 10                	mov    %edx,(%eax)
  802d1c:	8b 45 08             	mov    0x8(%ebp),%eax
  802d1f:	8b 00                	mov    (%eax),%eax
  802d21:	85 c0                	test   %eax,%eax
  802d23:	74 0d                	je     802d32 <insert_sorted_with_merge_freeList+0x55>
  802d25:	a1 38 51 80 00       	mov    0x805138,%eax
  802d2a:	8b 55 08             	mov    0x8(%ebp),%edx
  802d2d:	89 50 04             	mov    %edx,0x4(%eax)
  802d30:	eb 08                	jmp    802d3a <insert_sorted_with_merge_freeList+0x5d>
  802d32:	8b 45 08             	mov    0x8(%ebp),%eax
  802d35:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802d3a:	8b 45 08             	mov    0x8(%ebp),%eax
  802d3d:	a3 38 51 80 00       	mov    %eax,0x805138
  802d42:	8b 45 08             	mov    0x8(%ebp),%eax
  802d45:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802d4c:	a1 44 51 80 00       	mov    0x805144,%eax
  802d51:	40                   	inc    %eax
  802d52:	a3 44 51 80 00       	mov    %eax,0x805144
		}
	}

	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  802d57:	e9 c5 03 00 00       	jmp    803121 <insert_sorted_with_merge_freeList+0x444>
	struct MemBlock* last = LIST_LAST(&FreeMemBlocksList);
	//check if list empty
	if (LIST_SIZE(&(FreeMemBlocksList)) == 0)
		LIST_INSERT_HEAD(&FreeMemBlocksList, blockToInsert);
	//check if it's position is at last
	else if (last->sva < blockToInsert->sva) {
  802d5c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d5f:	8b 50 08             	mov    0x8(%eax),%edx
  802d62:	8b 45 08             	mov    0x8(%ebp),%eax
  802d65:	8b 40 08             	mov    0x8(%eax),%eax
  802d68:	39 c2                	cmp    %eax,%edx
  802d6a:	0f 83 b2 00 00 00    	jae    802e22 <insert_sorted_with_merge_freeList+0x145>

		//if i have to merge
		if (last->sva + last->size == blockToInsert->sva) {
  802d70:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d73:	8b 50 08             	mov    0x8(%eax),%edx
  802d76:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d79:	8b 40 0c             	mov    0xc(%eax),%eax
  802d7c:	01 c2                	add    %eax,%edx
  802d7e:	8b 45 08             	mov    0x8(%ebp),%eax
  802d81:	8b 40 08             	mov    0x8(%eax),%eax
  802d84:	39 c2                	cmp    %eax,%edx
  802d86:	75 27                	jne    802daf <insert_sorted_with_merge_freeList+0xd2>
			last->size = last->size + blockToInsert->size;
  802d88:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d8b:	8b 50 0c             	mov    0xc(%eax),%edx
  802d8e:	8b 45 08             	mov    0x8(%ebp),%eax
  802d91:	8b 40 0c             	mov    0xc(%eax),%eax
  802d94:	01 c2                	add    %eax,%edx
  802d96:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d99:	89 50 0c             	mov    %edx,0xc(%eax)
			addToAvailMemBlocksList(blockToInsert);
  802d9c:	83 ec 0c             	sub    $0xc,%esp
  802d9f:	ff 75 08             	pushl  0x8(%ebp)
  802da2:	e8 b6 fe ff ff       	call   802c5d <addToAvailMemBlocksList>
  802da7:	83 c4 10             	add    $0x10,%esp
		}
	}

	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  802daa:	e9 72 03 00 00       	jmp    803121 <insert_sorted_with_merge_freeList+0x444>
		if (last->sva + last->size == blockToInsert->sva) {
			last->size = last->size + blockToInsert->size;
			addToAvailMemBlocksList(blockToInsert);

		} else {
			LIST_INSERT_AFTER(&FreeMemBlocksList, last, blockToInsert);
  802daf:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802db3:	74 06                	je     802dbb <insert_sorted_with_merge_freeList+0xde>
  802db5:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802db9:	75 17                	jne    802dd2 <insert_sorted_with_merge_freeList+0xf5>
  802dbb:	83 ec 04             	sub    $0x4,%esp
  802dbe:	68 f4 3f 80 00       	push   $0x803ff4
  802dc3:	68 24 01 00 00       	push   $0x124
  802dc8:	68 b7 3f 80 00       	push   $0x803fb7
  802dcd:	e8 78 d7 ff ff       	call   80054a <_panic>
  802dd2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802dd5:	8b 10                	mov    (%eax),%edx
  802dd7:	8b 45 08             	mov    0x8(%ebp),%eax
  802dda:	89 10                	mov    %edx,(%eax)
  802ddc:	8b 45 08             	mov    0x8(%ebp),%eax
  802ddf:	8b 00                	mov    (%eax),%eax
  802de1:	85 c0                	test   %eax,%eax
  802de3:	74 0b                	je     802df0 <insert_sorted_with_merge_freeList+0x113>
  802de5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802de8:	8b 00                	mov    (%eax),%eax
  802dea:	8b 55 08             	mov    0x8(%ebp),%edx
  802ded:	89 50 04             	mov    %edx,0x4(%eax)
  802df0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802df3:	8b 55 08             	mov    0x8(%ebp),%edx
  802df6:	89 10                	mov    %edx,(%eax)
  802df8:	8b 45 08             	mov    0x8(%ebp),%eax
  802dfb:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802dfe:	89 50 04             	mov    %edx,0x4(%eax)
  802e01:	8b 45 08             	mov    0x8(%ebp),%eax
  802e04:	8b 00                	mov    (%eax),%eax
  802e06:	85 c0                	test   %eax,%eax
  802e08:	75 08                	jne    802e12 <insert_sorted_with_merge_freeList+0x135>
  802e0a:	8b 45 08             	mov    0x8(%ebp),%eax
  802e0d:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802e12:	a1 44 51 80 00       	mov    0x805144,%eax
  802e17:	40                   	inc    %eax
  802e18:	a3 44 51 80 00       	mov    %eax,0x805144
		}
	}

	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  802e1d:	e9 ff 02 00 00       	jmp    803121 <insert_sorted_with_merge_freeList+0x444>
		} else {
			LIST_INSERT_AFTER(&FreeMemBlocksList, last, blockToInsert);
		}
	} else {
		struct MemBlock *iterator;
		LIST_FOREACH(iterator, &(FreeMemBlocksList))
  802e22:	a1 38 51 80 00       	mov    0x805138,%eax
  802e27:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802e2a:	e9 c2 02 00 00       	jmp    8030f1 <insert_sorted_with_merge_freeList+0x414>
		{

			if (iterator->sva > blockToInsert->sva) {
  802e2f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e32:	8b 50 08             	mov    0x8(%eax),%edx
  802e35:	8b 45 08             	mov    0x8(%ebp),%eax
  802e38:	8b 40 08             	mov    0x8(%eax),%eax
  802e3b:	39 c2                	cmp    %eax,%edx
  802e3d:	0f 86 a6 02 00 00    	jbe    8030e9 <insert_sorted_with_merge_freeList+0x40c>

				struct MemBlock* prev = LIST_PREV(iterator);
  802e43:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e46:	8b 40 04             	mov    0x4(%eax),%eax
  802e49:	89 45 ec             	mov    %eax,-0x14(%ebp)
				if (prev == NULL) {
  802e4c:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802e50:	0f 85 ba 00 00 00    	jne    802f10 <insert_sorted_with_merge_freeList+0x233>
					//check merge
					if (blockToInsert->size + blockToInsert->sva
  802e56:	8b 45 08             	mov    0x8(%ebp),%eax
  802e59:	8b 50 0c             	mov    0xc(%eax),%edx
  802e5c:	8b 45 08             	mov    0x8(%ebp),%eax
  802e5f:	8b 40 08             	mov    0x8(%eax),%eax
  802e62:	01 c2                	add    %eax,%edx
							== iterator->sva) {
  802e64:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e67:	8b 40 08             	mov    0x8(%eax),%eax
			if (iterator->sva > blockToInsert->sva) {

				struct MemBlock* prev = LIST_PREV(iterator);
				if (prev == NULL) {
					//check merge
					if (blockToInsert->size + blockToInsert->sva
  802e6a:	39 c2                	cmp    %eax,%edx
  802e6c:	75 33                	jne    802ea1 <insert_sorted_with_merge_freeList+0x1c4>
							== iterator->sva) {
						iterator->sva = blockToInsert->sva;
  802e6e:	8b 45 08             	mov    0x8(%ebp),%eax
  802e71:	8b 50 08             	mov    0x8(%eax),%edx
  802e74:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e77:	89 50 08             	mov    %edx,0x8(%eax)
						iterator->size = iterator->size + blockToInsert->size;
  802e7a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e7d:	8b 50 0c             	mov    0xc(%eax),%edx
  802e80:	8b 45 08             	mov    0x8(%ebp),%eax
  802e83:	8b 40 0c             	mov    0xc(%eax),%eax
  802e86:	01 c2                	add    %eax,%edx
  802e88:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e8b:	89 50 0c             	mov    %edx,0xc(%eax)
						addToAvailMemBlocksList(blockToInsert);
  802e8e:	83 ec 0c             	sub    $0xc,%esp
  802e91:	ff 75 08             	pushl  0x8(%ebp)
  802e94:	e8 c4 fd ff ff       	call   802c5d <addToAvailMemBlocksList>
  802e99:	83 c4 10             	add    $0x10,%esp

					else {
						LIST_INSERT_BEFORE(&FreeMemBlocksList, iterator,
								blockToInsert);
					}
					break;
  802e9c:	e9 80 02 00 00       	jmp    803121 <insert_sorted_with_merge_freeList+0x444>
						addToAvailMemBlocksList(blockToInsert);

					}

					else {
						LIST_INSERT_BEFORE(&FreeMemBlocksList, iterator,
  802ea1:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802ea5:	74 06                	je     802ead <insert_sorted_with_merge_freeList+0x1d0>
  802ea7:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802eab:	75 17                	jne    802ec4 <insert_sorted_with_merge_freeList+0x1e7>
  802ead:	83 ec 04             	sub    $0x4,%esp
  802eb0:	68 48 40 80 00       	push   $0x804048
  802eb5:	68 3a 01 00 00       	push   $0x13a
  802eba:	68 b7 3f 80 00       	push   $0x803fb7
  802ebf:	e8 86 d6 ff ff       	call   80054a <_panic>
  802ec4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ec7:	8b 50 04             	mov    0x4(%eax),%edx
  802eca:	8b 45 08             	mov    0x8(%ebp),%eax
  802ecd:	89 50 04             	mov    %edx,0x4(%eax)
  802ed0:	8b 45 08             	mov    0x8(%ebp),%eax
  802ed3:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802ed6:	89 10                	mov    %edx,(%eax)
  802ed8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802edb:	8b 40 04             	mov    0x4(%eax),%eax
  802ede:	85 c0                	test   %eax,%eax
  802ee0:	74 0d                	je     802eef <insert_sorted_with_merge_freeList+0x212>
  802ee2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ee5:	8b 40 04             	mov    0x4(%eax),%eax
  802ee8:	8b 55 08             	mov    0x8(%ebp),%edx
  802eeb:	89 10                	mov    %edx,(%eax)
  802eed:	eb 08                	jmp    802ef7 <insert_sorted_with_merge_freeList+0x21a>
  802eef:	8b 45 08             	mov    0x8(%ebp),%eax
  802ef2:	a3 38 51 80 00       	mov    %eax,0x805138
  802ef7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802efa:	8b 55 08             	mov    0x8(%ebp),%edx
  802efd:	89 50 04             	mov    %edx,0x4(%eax)
  802f00:	a1 44 51 80 00       	mov    0x805144,%eax
  802f05:	40                   	inc    %eax
  802f06:	a3 44 51 80 00       	mov    %eax,0x805144
								blockToInsert);
					}
					break;
  802f0b:	e9 11 02 00 00       	jmp    803121 <insert_sorted_with_merge_freeList+0x444>
				} else {
					//prev and next merge
					if (prev->sva + prev->size + blockToInsert->size
  802f10:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802f13:	8b 50 08             	mov    0x8(%eax),%edx
  802f16:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802f19:	8b 40 0c             	mov    0xc(%eax),%eax
  802f1c:	01 c2                	add    %eax,%edx
  802f1e:	8b 45 08             	mov    0x8(%ebp),%eax
  802f21:	8b 40 0c             	mov    0xc(%eax),%eax
  802f24:	01 c2                	add    %eax,%edx
							== iterator->sva) {
  802f26:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f29:	8b 40 08             	mov    0x8(%eax),%eax
								blockToInsert);
					}
					break;
				} else {
					//prev and next merge
					if (prev->sva + prev->size + blockToInsert->size
  802f2c:	39 c2                	cmp    %eax,%edx
  802f2e:	0f 85 bf 00 00 00    	jne    802ff3 <insert_sorted_with_merge_freeList+0x316>
							== iterator->sva) {
						prev->size = prev->size + blockToInsert->size
  802f34:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802f37:	8b 50 0c             	mov    0xc(%eax),%edx
  802f3a:	8b 45 08             	mov    0x8(%ebp),%eax
  802f3d:	8b 40 0c             	mov    0xc(%eax),%eax
  802f40:	01 c2                	add    %eax,%edx
								+ iterator->size;
  802f42:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f45:	8b 40 0c             	mov    0xc(%eax),%eax
  802f48:	01 c2                	add    %eax,%edx
					break;
				} else {
					//prev and next merge
					if (prev->sva + prev->size + blockToInsert->size
							== iterator->sva) {
						prev->size = prev->size + blockToInsert->size
  802f4a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802f4d:	89 50 0c             	mov    %edx,0xc(%eax)
								+ iterator->size;
						LIST_REMOVE(&FreeMemBlocksList, iterator);
  802f50:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802f54:	75 17                	jne    802f6d <insert_sorted_with_merge_freeList+0x290>
  802f56:	83 ec 04             	sub    $0x4,%esp
  802f59:	68 28 40 80 00       	push   $0x804028
  802f5e:	68 43 01 00 00       	push   $0x143
  802f63:	68 b7 3f 80 00       	push   $0x803fb7
  802f68:	e8 dd d5 ff ff       	call   80054a <_panic>
  802f6d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f70:	8b 00                	mov    (%eax),%eax
  802f72:	85 c0                	test   %eax,%eax
  802f74:	74 10                	je     802f86 <insert_sorted_with_merge_freeList+0x2a9>
  802f76:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f79:	8b 00                	mov    (%eax),%eax
  802f7b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802f7e:	8b 52 04             	mov    0x4(%edx),%edx
  802f81:	89 50 04             	mov    %edx,0x4(%eax)
  802f84:	eb 0b                	jmp    802f91 <insert_sorted_with_merge_freeList+0x2b4>
  802f86:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f89:	8b 40 04             	mov    0x4(%eax),%eax
  802f8c:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802f91:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f94:	8b 40 04             	mov    0x4(%eax),%eax
  802f97:	85 c0                	test   %eax,%eax
  802f99:	74 0f                	je     802faa <insert_sorted_with_merge_freeList+0x2cd>
  802f9b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f9e:	8b 40 04             	mov    0x4(%eax),%eax
  802fa1:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802fa4:	8b 12                	mov    (%edx),%edx
  802fa6:	89 10                	mov    %edx,(%eax)
  802fa8:	eb 0a                	jmp    802fb4 <insert_sorted_with_merge_freeList+0x2d7>
  802faa:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802fad:	8b 00                	mov    (%eax),%eax
  802faf:	a3 38 51 80 00       	mov    %eax,0x805138
  802fb4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802fb7:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802fbd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802fc0:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802fc7:	a1 44 51 80 00       	mov    0x805144,%eax
  802fcc:	48                   	dec    %eax
  802fcd:	a3 44 51 80 00       	mov    %eax,0x805144
						addToAvailMemBlocksList(blockToInsert);
  802fd2:	83 ec 0c             	sub    $0xc,%esp
  802fd5:	ff 75 08             	pushl  0x8(%ebp)
  802fd8:	e8 80 fc ff ff       	call   802c5d <addToAvailMemBlocksList>
  802fdd:	83 c4 10             	add    $0x10,%esp
						addToAvailMemBlocksList(iterator);
  802fe0:	83 ec 0c             	sub    $0xc,%esp
  802fe3:	ff 75 f4             	pushl  -0xc(%ebp)
  802fe6:	e8 72 fc ff ff       	call   802c5d <addToAvailMemBlocksList>
  802feb:	83 c4 10             	add    $0x10,%esp
					//Insert
					else {
						LIST_INSERT_BEFORE(&FreeMemBlocksList, iterator,
								blockToInsert);
					}
					break;
  802fee:	e9 2e 01 00 00       	jmp    803121 <insert_sorted_with_merge_freeList+0x444>
						LIST_REMOVE(&FreeMemBlocksList, iterator);
						addToAvailMemBlocksList(blockToInsert);
						addToAvailMemBlocksList(iterator);
					}
					//previous merge
					else if (prev->sva + prev->size == blockToInsert->sva) {
  802ff3:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802ff6:	8b 50 08             	mov    0x8(%eax),%edx
  802ff9:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802ffc:	8b 40 0c             	mov    0xc(%eax),%eax
  802fff:	01 c2                	add    %eax,%edx
  803001:	8b 45 08             	mov    0x8(%ebp),%eax
  803004:	8b 40 08             	mov    0x8(%eax),%eax
  803007:	39 c2                	cmp    %eax,%edx
  803009:	75 27                	jne    803032 <insert_sorted_with_merge_freeList+0x355>
						prev->size = prev->size + blockToInsert->size;
  80300b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80300e:	8b 50 0c             	mov    0xc(%eax),%edx
  803011:	8b 45 08             	mov    0x8(%ebp),%eax
  803014:	8b 40 0c             	mov    0xc(%eax),%eax
  803017:	01 c2                	add    %eax,%edx
  803019:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80301c:	89 50 0c             	mov    %edx,0xc(%eax)
						addToAvailMemBlocksList(blockToInsert);
  80301f:	83 ec 0c             	sub    $0xc,%esp
  803022:	ff 75 08             	pushl  0x8(%ebp)
  803025:	e8 33 fc ff ff       	call   802c5d <addToAvailMemBlocksList>
  80302a:	83 c4 10             	add    $0x10,%esp
					//Insert
					else {
						LIST_INSERT_BEFORE(&FreeMemBlocksList, iterator,
								blockToInsert);
					}
					break;
  80302d:	e9 ef 00 00 00       	jmp    803121 <insert_sorted_with_merge_freeList+0x444>
					else if (prev->sva + prev->size == blockToInsert->sva) {
						prev->size = prev->size + blockToInsert->size;
						addToAvailMemBlocksList(blockToInsert);
					}
					//next merge
					else if (blockToInsert->size + blockToInsert->sva
  803032:	8b 45 08             	mov    0x8(%ebp),%eax
  803035:	8b 50 0c             	mov    0xc(%eax),%edx
  803038:	8b 45 08             	mov    0x8(%ebp),%eax
  80303b:	8b 40 08             	mov    0x8(%eax),%eax
  80303e:	01 c2                	add    %eax,%edx
							== iterator->sva) {
  803040:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803043:	8b 40 08             	mov    0x8(%eax),%eax
					else if (prev->sva + prev->size == blockToInsert->sva) {
						prev->size = prev->size + blockToInsert->size;
						addToAvailMemBlocksList(blockToInsert);
					}
					//next merge
					else if (blockToInsert->size + blockToInsert->sva
  803046:	39 c2                	cmp    %eax,%edx
  803048:	75 33                	jne    80307d <insert_sorted_with_merge_freeList+0x3a0>
							== iterator->sva) {
						iterator->sva = blockToInsert->sva;
  80304a:	8b 45 08             	mov    0x8(%ebp),%eax
  80304d:	8b 50 08             	mov    0x8(%eax),%edx
  803050:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803053:	89 50 08             	mov    %edx,0x8(%eax)
						iterator->size = iterator->size + blockToInsert->size;
  803056:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803059:	8b 50 0c             	mov    0xc(%eax),%edx
  80305c:	8b 45 08             	mov    0x8(%ebp),%eax
  80305f:	8b 40 0c             	mov    0xc(%eax),%eax
  803062:	01 c2                	add    %eax,%edx
  803064:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803067:	89 50 0c             	mov    %edx,0xc(%eax)
						addToAvailMemBlocksList(blockToInsert);
  80306a:	83 ec 0c             	sub    $0xc,%esp
  80306d:	ff 75 08             	pushl  0x8(%ebp)
  803070:	e8 e8 fb ff ff       	call   802c5d <addToAvailMemBlocksList>
  803075:	83 c4 10             	add    $0x10,%esp
					//Insert
					else {
						LIST_INSERT_BEFORE(&FreeMemBlocksList, iterator,
								blockToInsert);
					}
					break;
  803078:	e9 a4 00 00 00       	jmp    803121 <insert_sorted_with_merge_freeList+0x444>
						iterator->size = iterator->size + blockToInsert->size;
						addToAvailMemBlocksList(blockToInsert);
					}
					//Insert
					else {
						LIST_INSERT_BEFORE(&FreeMemBlocksList, iterator,
  80307d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803081:	74 06                	je     803089 <insert_sorted_with_merge_freeList+0x3ac>
  803083:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803087:	75 17                	jne    8030a0 <insert_sorted_with_merge_freeList+0x3c3>
  803089:	83 ec 04             	sub    $0x4,%esp
  80308c:	68 48 40 80 00       	push   $0x804048
  803091:	68 56 01 00 00       	push   $0x156
  803096:	68 b7 3f 80 00       	push   $0x803fb7
  80309b:	e8 aa d4 ff ff       	call   80054a <_panic>
  8030a0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030a3:	8b 50 04             	mov    0x4(%eax),%edx
  8030a6:	8b 45 08             	mov    0x8(%ebp),%eax
  8030a9:	89 50 04             	mov    %edx,0x4(%eax)
  8030ac:	8b 45 08             	mov    0x8(%ebp),%eax
  8030af:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8030b2:	89 10                	mov    %edx,(%eax)
  8030b4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030b7:	8b 40 04             	mov    0x4(%eax),%eax
  8030ba:	85 c0                	test   %eax,%eax
  8030bc:	74 0d                	je     8030cb <insert_sorted_with_merge_freeList+0x3ee>
  8030be:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030c1:	8b 40 04             	mov    0x4(%eax),%eax
  8030c4:	8b 55 08             	mov    0x8(%ebp),%edx
  8030c7:	89 10                	mov    %edx,(%eax)
  8030c9:	eb 08                	jmp    8030d3 <insert_sorted_with_merge_freeList+0x3f6>
  8030cb:	8b 45 08             	mov    0x8(%ebp),%eax
  8030ce:	a3 38 51 80 00       	mov    %eax,0x805138
  8030d3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030d6:	8b 55 08             	mov    0x8(%ebp),%edx
  8030d9:	89 50 04             	mov    %edx,0x4(%eax)
  8030dc:	a1 44 51 80 00       	mov    0x805144,%eax
  8030e1:	40                   	inc    %eax
  8030e2:	a3 44 51 80 00       	mov    %eax,0x805144
								blockToInsert);
					}
					break;
  8030e7:	eb 38                	jmp    803121 <insert_sorted_with_merge_freeList+0x444>
		} else {
			LIST_INSERT_AFTER(&FreeMemBlocksList, last, blockToInsert);
		}
	} else {
		struct MemBlock *iterator;
		LIST_FOREACH(iterator, &(FreeMemBlocksList))
  8030e9:	a1 40 51 80 00       	mov    0x805140,%eax
  8030ee:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8030f1:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8030f5:	74 07                	je     8030fe <insert_sorted_with_merge_freeList+0x421>
  8030f7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030fa:	8b 00                	mov    (%eax),%eax
  8030fc:	eb 05                	jmp    803103 <insert_sorted_with_merge_freeList+0x426>
  8030fe:	b8 00 00 00 00       	mov    $0x0,%eax
  803103:	a3 40 51 80 00       	mov    %eax,0x805140
  803108:	a1 40 51 80 00       	mov    0x805140,%eax
  80310d:	85 c0                	test   %eax,%eax
  80310f:	0f 85 1a fd ff ff    	jne    802e2f <insert_sorted_with_merge_freeList+0x152>
  803115:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803119:	0f 85 10 fd ff ff    	jne    802e2f <insert_sorted_with_merge_freeList+0x152>
		}
	}

	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  80311f:	eb 00                	jmp    803121 <insert_sorted_with_merge_freeList+0x444>
  803121:	90                   	nop
  803122:	c9                   	leave  
  803123:	c3                   	ret    

00803124 <env_sleep>:
#include <inc/lib.h>
#include <inc/timerreg.h>

void
env_sleep(uint32 approxMilliSeconds)
{
  803124:	55                   	push   %ebp
  803125:	89 e5                	mov    %esp,%ebp
  803127:	83 ec 28             	sub    $0x28,%esp
//	cprintf("%s go to sleep...\n", myEnv->prog_name);
	uint32 time_in_cycles=approxMilliSeconds*CYCLES_PER_MILLISEC;
  80312a:	8b 55 08             	mov    0x8(%ebp),%edx
  80312d:	89 d0                	mov    %edx,%eax
  80312f:	c1 e0 02             	shl    $0x2,%eax
  803132:	01 d0                	add    %edx,%eax
  803134:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80313b:	01 d0                	add    %edx,%eax
  80313d:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  803144:	01 d0                	add    %edx,%eax
  803146:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80314d:	01 d0                	add    %edx,%eax
  80314f:	c1 e0 04             	shl    $0x4,%eax
  803152:	89 45 f0             	mov    %eax,-0x10(%ebp)
	uint32 cycles_counter =0;
  803155:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	struct uint64 baseTime = sys_get_virtual_time() ;
  80315c:	8d 45 e8             	lea    -0x18(%ebp),%eax
  80315f:	83 ec 0c             	sub    $0xc,%esp
  803162:	50                   	push   %eax
  803163:	e8 60 ed ff ff       	call   801ec8 <sys_get_virtual_time>
  803168:	83 c4 0c             	add    $0xc,%esp
	while(cycles_counter<time_in_cycles)
  80316b:	eb 41                	jmp    8031ae <env_sleep+0x8a>
	{
		struct uint64 currentTime = sys_get_virtual_time() ;
  80316d:	8d 45 e0             	lea    -0x20(%ebp),%eax
  803170:	83 ec 0c             	sub    $0xc,%esp
  803173:	50                   	push   %eax
  803174:	e8 4f ed ff ff       	call   801ec8 <sys_get_virtual_time>
  803179:	83 c4 0c             	add    $0xc,%esp

		// update the cycles_count
		#define M32 0xffffffff
		// subtract basetime from current time
		struct uint64 res;
		res.low = (currentTime.low - baseTime.low) & M32;
  80317c:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80317f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803182:	29 c2                	sub    %eax,%edx
  803184:	89 d0                	mov    %edx,%eax
  803186:	89 45 d8             	mov    %eax,-0x28(%ebp)
		res.hi = (currentTime.hi - baseTime.hi - (res.low > currentTime.low)) & M32;
  803189:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80318c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80318f:	89 d1                	mov    %edx,%ecx
  803191:	29 c1                	sub    %eax,%ecx
  803193:	8b 55 d8             	mov    -0x28(%ebp),%edx
  803196:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803199:	39 c2                	cmp    %eax,%edx
  80319b:	0f 97 c0             	seta   %al
  80319e:	0f b6 c0             	movzbl %al,%eax
  8031a1:	29 c1                	sub    %eax,%ecx
  8031a3:	89 c8                	mov    %ecx,%eax
  8031a5:	89 45 dc             	mov    %eax,-0x24(%ebp)

		//update cycles_count with result
		cycles_counter = res.low;
  8031a8:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8031ab:	89 45 f4             	mov    %eax,-0xc(%ebp)
//	cprintf("%s go to sleep...\n", myEnv->prog_name);
	uint32 time_in_cycles=approxMilliSeconds*CYCLES_PER_MILLISEC;
	uint32 cycles_counter =0;

	struct uint64 baseTime = sys_get_virtual_time() ;
	while(cycles_counter<time_in_cycles)
  8031ae:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8031b1:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8031b4:	72 b7                	jb     80316d <env_sleep+0x49>
//				,cycles_counter
//				);
	}
	//cprintf("%s [%d] wake up now!\n", myEnv->prog_name, myEnv->env_id);

}
  8031b6:	90                   	nop
  8031b7:	c9                   	leave  
  8031b8:	c3                   	ret    

008031b9 <busy_wait>:

//2017
uint32 busy_wait(uint32 loopMax)
{
  8031b9:	55                   	push   %ebp
  8031ba:	89 e5                	mov    %esp,%ebp
  8031bc:	83 ec 10             	sub    $0x10,%esp
	uint32 i = 0 ;
  8031bf:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	while (i < loopMax) i++;
  8031c6:	eb 03                	jmp    8031cb <busy_wait+0x12>
  8031c8:	ff 45 fc             	incl   -0x4(%ebp)
  8031cb:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8031ce:	3b 45 08             	cmp    0x8(%ebp),%eax
  8031d1:	72 f5                	jb     8031c8 <busy_wait+0xf>
	return i;
  8031d3:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  8031d6:	c9                   	leave  
  8031d7:	c3                   	ret    

008031d8 <__udivdi3>:
  8031d8:	55                   	push   %ebp
  8031d9:	57                   	push   %edi
  8031da:	56                   	push   %esi
  8031db:	53                   	push   %ebx
  8031dc:	83 ec 1c             	sub    $0x1c,%esp
  8031df:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  8031e3:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  8031e7:	8b 7c 24 38          	mov    0x38(%esp),%edi
  8031eb:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8031ef:	89 ca                	mov    %ecx,%edx
  8031f1:	89 f8                	mov    %edi,%eax
  8031f3:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  8031f7:	85 f6                	test   %esi,%esi
  8031f9:	75 2d                	jne    803228 <__udivdi3+0x50>
  8031fb:	39 cf                	cmp    %ecx,%edi
  8031fd:	77 65                	ja     803264 <__udivdi3+0x8c>
  8031ff:	89 fd                	mov    %edi,%ebp
  803201:	85 ff                	test   %edi,%edi
  803203:	75 0b                	jne    803210 <__udivdi3+0x38>
  803205:	b8 01 00 00 00       	mov    $0x1,%eax
  80320a:	31 d2                	xor    %edx,%edx
  80320c:	f7 f7                	div    %edi
  80320e:	89 c5                	mov    %eax,%ebp
  803210:	31 d2                	xor    %edx,%edx
  803212:	89 c8                	mov    %ecx,%eax
  803214:	f7 f5                	div    %ebp
  803216:	89 c1                	mov    %eax,%ecx
  803218:	89 d8                	mov    %ebx,%eax
  80321a:	f7 f5                	div    %ebp
  80321c:	89 cf                	mov    %ecx,%edi
  80321e:	89 fa                	mov    %edi,%edx
  803220:	83 c4 1c             	add    $0x1c,%esp
  803223:	5b                   	pop    %ebx
  803224:	5e                   	pop    %esi
  803225:	5f                   	pop    %edi
  803226:	5d                   	pop    %ebp
  803227:	c3                   	ret    
  803228:	39 ce                	cmp    %ecx,%esi
  80322a:	77 28                	ja     803254 <__udivdi3+0x7c>
  80322c:	0f bd fe             	bsr    %esi,%edi
  80322f:	83 f7 1f             	xor    $0x1f,%edi
  803232:	75 40                	jne    803274 <__udivdi3+0x9c>
  803234:	39 ce                	cmp    %ecx,%esi
  803236:	72 0a                	jb     803242 <__udivdi3+0x6a>
  803238:	3b 44 24 08          	cmp    0x8(%esp),%eax
  80323c:	0f 87 9e 00 00 00    	ja     8032e0 <__udivdi3+0x108>
  803242:	b8 01 00 00 00       	mov    $0x1,%eax
  803247:	89 fa                	mov    %edi,%edx
  803249:	83 c4 1c             	add    $0x1c,%esp
  80324c:	5b                   	pop    %ebx
  80324d:	5e                   	pop    %esi
  80324e:	5f                   	pop    %edi
  80324f:	5d                   	pop    %ebp
  803250:	c3                   	ret    
  803251:	8d 76 00             	lea    0x0(%esi),%esi
  803254:	31 ff                	xor    %edi,%edi
  803256:	31 c0                	xor    %eax,%eax
  803258:	89 fa                	mov    %edi,%edx
  80325a:	83 c4 1c             	add    $0x1c,%esp
  80325d:	5b                   	pop    %ebx
  80325e:	5e                   	pop    %esi
  80325f:	5f                   	pop    %edi
  803260:	5d                   	pop    %ebp
  803261:	c3                   	ret    
  803262:	66 90                	xchg   %ax,%ax
  803264:	89 d8                	mov    %ebx,%eax
  803266:	f7 f7                	div    %edi
  803268:	31 ff                	xor    %edi,%edi
  80326a:	89 fa                	mov    %edi,%edx
  80326c:	83 c4 1c             	add    $0x1c,%esp
  80326f:	5b                   	pop    %ebx
  803270:	5e                   	pop    %esi
  803271:	5f                   	pop    %edi
  803272:	5d                   	pop    %ebp
  803273:	c3                   	ret    
  803274:	bd 20 00 00 00       	mov    $0x20,%ebp
  803279:	89 eb                	mov    %ebp,%ebx
  80327b:	29 fb                	sub    %edi,%ebx
  80327d:	89 f9                	mov    %edi,%ecx
  80327f:	d3 e6                	shl    %cl,%esi
  803281:	89 c5                	mov    %eax,%ebp
  803283:	88 d9                	mov    %bl,%cl
  803285:	d3 ed                	shr    %cl,%ebp
  803287:	89 e9                	mov    %ebp,%ecx
  803289:	09 f1                	or     %esi,%ecx
  80328b:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  80328f:	89 f9                	mov    %edi,%ecx
  803291:	d3 e0                	shl    %cl,%eax
  803293:	89 c5                	mov    %eax,%ebp
  803295:	89 d6                	mov    %edx,%esi
  803297:	88 d9                	mov    %bl,%cl
  803299:	d3 ee                	shr    %cl,%esi
  80329b:	89 f9                	mov    %edi,%ecx
  80329d:	d3 e2                	shl    %cl,%edx
  80329f:	8b 44 24 08          	mov    0x8(%esp),%eax
  8032a3:	88 d9                	mov    %bl,%cl
  8032a5:	d3 e8                	shr    %cl,%eax
  8032a7:	09 c2                	or     %eax,%edx
  8032a9:	89 d0                	mov    %edx,%eax
  8032ab:	89 f2                	mov    %esi,%edx
  8032ad:	f7 74 24 0c          	divl   0xc(%esp)
  8032b1:	89 d6                	mov    %edx,%esi
  8032b3:	89 c3                	mov    %eax,%ebx
  8032b5:	f7 e5                	mul    %ebp
  8032b7:	39 d6                	cmp    %edx,%esi
  8032b9:	72 19                	jb     8032d4 <__udivdi3+0xfc>
  8032bb:	74 0b                	je     8032c8 <__udivdi3+0xf0>
  8032bd:	89 d8                	mov    %ebx,%eax
  8032bf:	31 ff                	xor    %edi,%edi
  8032c1:	e9 58 ff ff ff       	jmp    80321e <__udivdi3+0x46>
  8032c6:	66 90                	xchg   %ax,%ax
  8032c8:	8b 54 24 08          	mov    0x8(%esp),%edx
  8032cc:	89 f9                	mov    %edi,%ecx
  8032ce:	d3 e2                	shl    %cl,%edx
  8032d0:	39 c2                	cmp    %eax,%edx
  8032d2:	73 e9                	jae    8032bd <__udivdi3+0xe5>
  8032d4:	8d 43 ff             	lea    -0x1(%ebx),%eax
  8032d7:	31 ff                	xor    %edi,%edi
  8032d9:	e9 40 ff ff ff       	jmp    80321e <__udivdi3+0x46>
  8032de:	66 90                	xchg   %ax,%ax
  8032e0:	31 c0                	xor    %eax,%eax
  8032e2:	e9 37 ff ff ff       	jmp    80321e <__udivdi3+0x46>
  8032e7:	90                   	nop

008032e8 <__umoddi3>:
  8032e8:	55                   	push   %ebp
  8032e9:	57                   	push   %edi
  8032ea:	56                   	push   %esi
  8032eb:	53                   	push   %ebx
  8032ec:	83 ec 1c             	sub    $0x1c,%esp
  8032ef:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  8032f3:	8b 74 24 34          	mov    0x34(%esp),%esi
  8032f7:	8b 7c 24 38          	mov    0x38(%esp),%edi
  8032fb:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  8032ff:	89 44 24 0c          	mov    %eax,0xc(%esp)
  803303:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  803307:	89 f3                	mov    %esi,%ebx
  803309:	89 fa                	mov    %edi,%edx
  80330b:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  80330f:	89 34 24             	mov    %esi,(%esp)
  803312:	85 c0                	test   %eax,%eax
  803314:	75 1a                	jne    803330 <__umoddi3+0x48>
  803316:	39 f7                	cmp    %esi,%edi
  803318:	0f 86 a2 00 00 00    	jbe    8033c0 <__umoddi3+0xd8>
  80331e:	89 c8                	mov    %ecx,%eax
  803320:	89 f2                	mov    %esi,%edx
  803322:	f7 f7                	div    %edi
  803324:	89 d0                	mov    %edx,%eax
  803326:	31 d2                	xor    %edx,%edx
  803328:	83 c4 1c             	add    $0x1c,%esp
  80332b:	5b                   	pop    %ebx
  80332c:	5e                   	pop    %esi
  80332d:	5f                   	pop    %edi
  80332e:	5d                   	pop    %ebp
  80332f:	c3                   	ret    
  803330:	39 f0                	cmp    %esi,%eax
  803332:	0f 87 ac 00 00 00    	ja     8033e4 <__umoddi3+0xfc>
  803338:	0f bd e8             	bsr    %eax,%ebp
  80333b:	83 f5 1f             	xor    $0x1f,%ebp
  80333e:	0f 84 ac 00 00 00    	je     8033f0 <__umoddi3+0x108>
  803344:	bf 20 00 00 00       	mov    $0x20,%edi
  803349:	29 ef                	sub    %ebp,%edi
  80334b:	89 fe                	mov    %edi,%esi
  80334d:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  803351:	89 e9                	mov    %ebp,%ecx
  803353:	d3 e0                	shl    %cl,%eax
  803355:	89 d7                	mov    %edx,%edi
  803357:	89 f1                	mov    %esi,%ecx
  803359:	d3 ef                	shr    %cl,%edi
  80335b:	09 c7                	or     %eax,%edi
  80335d:	89 e9                	mov    %ebp,%ecx
  80335f:	d3 e2                	shl    %cl,%edx
  803361:	89 14 24             	mov    %edx,(%esp)
  803364:	89 d8                	mov    %ebx,%eax
  803366:	d3 e0                	shl    %cl,%eax
  803368:	89 c2                	mov    %eax,%edx
  80336a:	8b 44 24 08          	mov    0x8(%esp),%eax
  80336e:	d3 e0                	shl    %cl,%eax
  803370:	89 44 24 04          	mov    %eax,0x4(%esp)
  803374:	8b 44 24 08          	mov    0x8(%esp),%eax
  803378:	89 f1                	mov    %esi,%ecx
  80337a:	d3 e8                	shr    %cl,%eax
  80337c:	09 d0                	or     %edx,%eax
  80337e:	d3 eb                	shr    %cl,%ebx
  803380:	89 da                	mov    %ebx,%edx
  803382:	f7 f7                	div    %edi
  803384:	89 d3                	mov    %edx,%ebx
  803386:	f7 24 24             	mull   (%esp)
  803389:	89 c6                	mov    %eax,%esi
  80338b:	89 d1                	mov    %edx,%ecx
  80338d:	39 d3                	cmp    %edx,%ebx
  80338f:	0f 82 87 00 00 00    	jb     80341c <__umoddi3+0x134>
  803395:	0f 84 91 00 00 00    	je     80342c <__umoddi3+0x144>
  80339b:	8b 54 24 04          	mov    0x4(%esp),%edx
  80339f:	29 f2                	sub    %esi,%edx
  8033a1:	19 cb                	sbb    %ecx,%ebx
  8033a3:	89 d8                	mov    %ebx,%eax
  8033a5:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  8033a9:	d3 e0                	shl    %cl,%eax
  8033ab:	89 e9                	mov    %ebp,%ecx
  8033ad:	d3 ea                	shr    %cl,%edx
  8033af:	09 d0                	or     %edx,%eax
  8033b1:	89 e9                	mov    %ebp,%ecx
  8033b3:	d3 eb                	shr    %cl,%ebx
  8033b5:	89 da                	mov    %ebx,%edx
  8033b7:	83 c4 1c             	add    $0x1c,%esp
  8033ba:	5b                   	pop    %ebx
  8033bb:	5e                   	pop    %esi
  8033bc:	5f                   	pop    %edi
  8033bd:	5d                   	pop    %ebp
  8033be:	c3                   	ret    
  8033bf:	90                   	nop
  8033c0:	89 fd                	mov    %edi,%ebp
  8033c2:	85 ff                	test   %edi,%edi
  8033c4:	75 0b                	jne    8033d1 <__umoddi3+0xe9>
  8033c6:	b8 01 00 00 00       	mov    $0x1,%eax
  8033cb:	31 d2                	xor    %edx,%edx
  8033cd:	f7 f7                	div    %edi
  8033cf:	89 c5                	mov    %eax,%ebp
  8033d1:	89 f0                	mov    %esi,%eax
  8033d3:	31 d2                	xor    %edx,%edx
  8033d5:	f7 f5                	div    %ebp
  8033d7:	89 c8                	mov    %ecx,%eax
  8033d9:	f7 f5                	div    %ebp
  8033db:	89 d0                	mov    %edx,%eax
  8033dd:	e9 44 ff ff ff       	jmp    803326 <__umoddi3+0x3e>
  8033e2:	66 90                	xchg   %ax,%ax
  8033e4:	89 c8                	mov    %ecx,%eax
  8033e6:	89 f2                	mov    %esi,%edx
  8033e8:	83 c4 1c             	add    $0x1c,%esp
  8033eb:	5b                   	pop    %ebx
  8033ec:	5e                   	pop    %esi
  8033ed:	5f                   	pop    %edi
  8033ee:	5d                   	pop    %ebp
  8033ef:	c3                   	ret    
  8033f0:	3b 04 24             	cmp    (%esp),%eax
  8033f3:	72 06                	jb     8033fb <__umoddi3+0x113>
  8033f5:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  8033f9:	77 0f                	ja     80340a <__umoddi3+0x122>
  8033fb:	89 f2                	mov    %esi,%edx
  8033fd:	29 f9                	sub    %edi,%ecx
  8033ff:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  803403:	89 14 24             	mov    %edx,(%esp)
  803406:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  80340a:	8b 44 24 04          	mov    0x4(%esp),%eax
  80340e:	8b 14 24             	mov    (%esp),%edx
  803411:	83 c4 1c             	add    $0x1c,%esp
  803414:	5b                   	pop    %ebx
  803415:	5e                   	pop    %esi
  803416:	5f                   	pop    %edi
  803417:	5d                   	pop    %ebp
  803418:	c3                   	ret    
  803419:	8d 76 00             	lea    0x0(%esi),%esi
  80341c:	2b 04 24             	sub    (%esp),%eax
  80341f:	19 fa                	sbb    %edi,%edx
  803421:	89 d1                	mov    %edx,%ecx
  803423:	89 c6                	mov    %eax,%esi
  803425:	e9 71 ff ff ff       	jmp    80339b <__umoddi3+0xb3>
  80342a:	66 90                	xchg   %ax,%ax
  80342c:	39 44 24 04          	cmp    %eax,0x4(%esp)
  803430:	72 ea                	jb     80341c <__umoddi3+0x134>
  803432:	89 d9                	mov    %ebx,%ecx
  803434:	e9 62 ff ff ff       	jmp    80339b <__umoddi3+0xb3>
