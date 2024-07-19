
obj/user/ef_tst_sharing_5_master:     file format elf32-i386


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
  800031:	e8 3d 04 00 00       	call   800473 <libmain>
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
  80008d:	68 c0 34 80 00       	push   $0x8034c0
  800092:	6a 12                	push   $0x12
  800094:	68 dc 34 80 00       	push   $0x8034dc
  800099:	e8 11 05 00 00       	call   8005af <_panic>
	}

	cprintf("************************************************\n");
  80009e:	83 ec 0c             	sub    $0xc,%esp
  8000a1:	68 fc 34 80 00       	push   $0x8034fc
  8000a6:	e8 b8 07 00 00       	call   800863 <cprintf>
  8000ab:	83 c4 10             	add    $0x10,%esp
	cprintf("MAKE SURE to have a FRESH RUN for this test\n(i.e. don't run any program/test before it)\n");
  8000ae:	83 ec 0c             	sub    $0xc,%esp
  8000b1:	68 30 35 80 00       	push   $0x803530
  8000b6:	e8 a8 07 00 00       	call   800863 <cprintf>
  8000bb:	83 c4 10             	add    $0x10,%esp
	cprintf("************************************************\n\n\n");
  8000be:	83 ec 0c             	sub    $0xc,%esp
  8000c1:	68 8c 35 80 00       	push   $0x80358c
  8000c6:	e8 98 07 00 00       	call   800863 <cprintf>
  8000cb:	83 c4 10             	add    $0x10,%esp

	int envID = sys_getenvid();
  8000ce:	e8 f5 1d 00 00       	call   801ec8 <sys_getenvid>
  8000d3:	89 45 ec             	mov    %eax,-0x14(%ebp)

	int32 envIdSlave1, envIdSlave2, envIdSlaveB1, envIdSlaveB2;

	cprintf("STEP A: checking free of shared object using 2 environments... \n");
  8000d6:	83 ec 0c             	sub    $0xc,%esp
  8000d9:	68 c0 35 80 00       	push   $0x8035c0
  8000de:	e8 80 07 00 00       	call   800863 <cprintf>
  8000e3:	83 c4 10             	add    $0x10,%esp
	{
		uint32 *x;
		envIdSlave1 = sys_create_env("ef_tshr5slave", (myEnv->page_WS_max_size),(myEnv->SecondListSize), 50);
  8000e6:	a1 20 50 80 00       	mov    0x805020,%eax
  8000eb:	8b 80 ec 05 00 00    	mov    0x5ec(%eax),%eax
  8000f1:	89 c2                	mov    %eax,%edx
  8000f3:	a1 20 50 80 00       	mov    0x805020,%eax
  8000f8:	8b 40 74             	mov    0x74(%eax),%eax
  8000fb:	6a 32                	push   $0x32
  8000fd:	52                   	push   %edx
  8000fe:	50                   	push   %eax
  8000ff:	68 01 36 80 00       	push   $0x803601
  800104:	e8 6a 1d 00 00       	call   801e73 <sys_create_env>
  800109:	83 c4 10             	add    $0x10,%esp
  80010c:	89 45 e8             	mov    %eax,-0x18(%ebp)
		envIdSlave2 = sys_create_env("ef_tshr5slave", (myEnv->page_WS_max_size),(myEnv->SecondListSize), 50);
  80010f:	a1 20 50 80 00       	mov    0x805020,%eax
  800114:	8b 80 ec 05 00 00    	mov    0x5ec(%eax),%eax
  80011a:	89 c2                	mov    %eax,%edx
  80011c:	a1 20 50 80 00       	mov    0x805020,%eax
  800121:	8b 40 74             	mov    0x74(%eax),%eax
  800124:	6a 32                	push   $0x32
  800126:	52                   	push   %edx
  800127:	50                   	push   %eax
  800128:	68 01 36 80 00       	push   $0x803601
  80012d:	e8 41 1d 00 00       	call   801e73 <sys_create_env>
  800132:	83 c4 10             	add    $0x10,%esp
  800135:	89 45 e4             	mov    %eax,-0x1c(%ebp)

		int freeFrames = sys_calculate_free_frames() ;
  800138:	e8 c4 1a 00 00       	call   801c01 <sys_calculate_free_frames>
  80013d:	89 45 e0             	mov    %eax,-0x20(%ebp)
		x = smalloc("x", PAGE_SIZE, 1);
  800140:	83 ec 04             	sub    $0x4,%esp
  800143:	6a 01                	push   $0x1
  800145:	68 00 10 00 00       	push   $0x1000
  80014a:	68 0f 36 80 00       	push   $0x80360f
  80014f:	e8 e9 17 00 00       	call   80193d <smalloc>
  800154:	83 c4 10             	add    $0x10,%esp
  800157:	89 45 dc             	mov    %eax,-0x24(%ebp)
		cprintf("Master env created x (1 page) \n");
  80015a:	83 ec 0c             	sub    $0xc,%esp
  80015d:	68 14 36 80 00       	push   $0x803614
  800162:	e8 fc 06 00 00       	call   800863 <cprintf>
  800167:	83 c4 10             	add    $0x10,%esp
		if (x != (uint32*)USER_HEAP_START) panic("Returned address is not correct. check the setting of it and/or the updating of the shared_mem_free_address");
  80016a:	81 7d dc 00 00 00 80 	cmpl   $0x80000000,-0x24(%ebp)
  800171:	74 14                	je     800187 <_main+0x14f>
  800173:	83 ec 04             	sub    $0x4,%esp
  800176:	68 34 36 80 00       	push   $0x803634
  80017b:	6a 26                	push   $0x26
  80017d:	68 dc 34 80 00       	push   $0x8034dc
  800182:	e8 28 04 00 00       	call   8005af <_panic>
		if ((freeFrames - sys_calculate_free_frames()) !=  1+1+2) panic("Wrong allocation: make sure that you allocate the required space in the user environment and add its frames to frames_storage");
  800187:	8b 5d e0             	mov    -0x20(%ebp),%ebx
  80018a:	e8 72 1a 00 00       	call   801c01 <sys_calculate_free_frames>
  80018f:	29 c3                	sub    %eax,%ebx
  800191:	89 d8                	mov    %ebx,%eax
  800193:	83 f8 04             	cmp    $0x4,%eax
  800196:	74 14                	je     8001ac <_main+0x174>
  800198:	83 ec 04             	sub    $0x4,%esp
  80019b:	68 a0 36 80 00       	push   $0x8036a0
  8001a0:	6a 27                	push   $0x27
  8001a2:	68 dc 34 80 00       	push   $0x8034dc
  8001a7:	e8 03 04 00 00       	call   8005af <_panic>

		//to check that the slave environments completed successfully
		rsttst();
  8001ac:	e8 0e 1e 00 00       	call   801fbf <rsttst>

		sys_run_env(envIdSlave1);
  8001b1:	83 ec 0c             	sub    $0xc,%esp
  8001b4:	ff 75 e8             	pushl  -0x18(%ebp)
  8001b7:	e8 d5 1c 00 00       	call   801e91 <sys_run_env>
  8001bc:	83 c4 10             	add    $0x10,%esp
		sys_run_env(envIdSlave2);
  8001bf:	83 ec 0c             	sub    $0xc,%esp
  8001c2:	ff 75 e4             	pushl  -0x1c(%ebp)
  8001c5:	e8 c7 1c 00 00       	call   801e91 <sys_run_env>
  8001ca:	83 c4 10             	add    $0x10,%esp

		cprintf("please be patient ...\n");
  8001cd:	83 ec 0c             	sub    $0xc,%esp
  8001d0:	68 1e 37 80 00       	push   $0x80371e
  8001d5:	e8 89 06 00 00       	call   800863 <cprintf>
  8001da:	83 c4 10             	add    $0x10,%esp
		env_sleep(3000);
  8001dd:	83 ec 0c             	sub    $0xc,%esp
  8001e0:	68 b8 0b 00 00       	push   $0xbb8
  8001e5:	e8 9f 2f 00 00       	call   803189 <env_sleep>
  8001ea:	83 c4 10             	add    $0x10,%esp

		//to ensure that the slave environments completed successfully
		if (gettst()!=2) panic("test failed");
  8001ed:	e8 47 1e 00 00       	call   802039 <gettst>
  8001f2:	83 f8 02             	cmp    $0x2,%eax
  8001f5:	74 14                	je     80020b <_main+0x1d3>
  8001f7:	83 ec 04             	sub    $0x4,%esp
  8001fa:	68 35 37 80 00       	push   $0x803735
  8001ff:	6a 33                	push   $0x33
  800201:	68 dc 34 80 00       	push   $0x8034dc
  800206:	e8 a4 03 00 00       	call   8005af <_panic>

		sfree(x);
  80020b:	83 ec 0c             	sub    $0xc,%esp
  80020e:	ff 75 dc             	pushl  -0x24(%ebp)
  800211:	e8 8b 18 00 00       	call   801aa1 <sfree>
  800216:	83 c4 10             	add    $0x10,%esp
		cprintf("Master env removed x (1 page) \n");
  800219:	83 ec 0c             	sub    $0xc,%esp
  80021c:	68 44 37 80 00       	push   $0x803744
  800221:	e8 3d 06 00 00       	call   800863 <cprintf>
  800226:	83 c4 10             	add    $0x10,%esp
		int diff = (sys_calculate_free_frames() - freeFrames);
  800229:	e8 d3 19 00 00       	call   801c01 <sys_calculate_free_frames>
  80022e:	89 c2                	mov    %eax,%edx
  800230:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800233:	29 c2                	sub    %eax,%edx
  800235:	89 d0                	mov    %edx,%eax
  800237:	89 45 d8             	mov    %eax,-0x28(%ebp)
		if ( diff !=  0) panic("Wrong free: revise your freeSharedObject logic\n");
  80023a:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  80023e:	74 14                	je     800254 <_main+0x21c>
  800240:	83 ec 04             	sub    $0x4,%esp
  800243:	68 64 37 80 00       	push   $0x803764
  800248:	6a 38                	push   $0x38
  80024a:	68 dc 34 80 00       	push   $0x8034dc
  80024f:	e8 5b 03 00 00       	call   8005af <_panic>
	}
	cprintf("Step A completed successfully!!\n\n\n");
  800254:	83 ec 0c             	sub    $0xc,%esp
  800257:	68 94 37 80 00       	push   $0x803794
  80025c:	e8 02 06 00 00       	call   800863 <cprintf>
  800261:	83 c4 10             	add    $0x10,%esp

	cprintf("STEP B: checking free of 2 shared objects ... \n");
  800264:	83 ec 0c             	sub    $0xc,%esp
  800267:	68 b8 37 80 00       	push   $0x8037b8
  80026c:	e8 f2 05 00 00       	call   800863 <cprintf>
  800271:	83 c4 10             	add    $0x10,%esp
	{
		uint32 *x, *z ;
		envIdSlaveB1 = sys_create_env("ef_tshr5slaveB1", (myEnv->page_WS_max_size),(myEnv->SecondListSize), 50);
  800274:	a1 20 50 80 00       	mov    0x805020,%eax
  800279:	8b 80 ec 05 00 00    	mov    0x5ec(%eax),%eax
  80027f:	89 c2                	mov    %eax,%edx
  800281:	a1 20 50 80 00       	mov    0x805020,%eax
  800286:	8b 40 74             	mov    0x74(%eax),%eax
  800289:	6a 32                	push   $0x32
  80028b:	52                   	push   %edx
  80028c:	50                   	push   %eax
  80028d:	68 e8 37 80 00       	push   $0x8037e8
  800292:	e8 dc 1b 00 00       	call   801e73 <sys_create_env>
  800297:	83 c4 10             	add    $0x10,%esp
  80029a:	89 45 d4             	mov    %eax,-0x2c(%ebp)
		envIdSlaveB2 = sys_create_env("ef_tshr5slaveB2", (myEnv->page_WS_max_size), (myEnv->SecondListSize),50);
  80029d:	a1 20 50 80 00       	mov    0x805020,%eax
  8002a2:	8b 80 ec 05 00 00    	mov    0x5ec(%eax),%eax
  8002a8:	89 c2                	mov    %eax,%edx
  8002aa:	a1 20 50 80 00       	mov    0x805020,%eax
  8002af:	8b 40 74             	mov    0x74(%eax),%eax
  8002b2:	6a 32                	push   $0x32
  8002b4:	52                   	push   %edx
  8002b5:	50                   	push   %eax
  8002b6:	68 f8 37 80 00       	push   $0x8037f8
  8002bb:	e8 b3 1b 00 00       	call   801e73 <sys_create_env>
  8002c0:	83 c4 10             	add    $0x10,%esp
  8002c3:	89 45 d0             	mov    %eax,-0x30(%ebp)

		z = smalloc("z", PAGE_SIZE, 1);
  8002c6:	83 ec 04             	sub    $0x4,%esp
  8002c9:	6a 01                	push   $0x1
  8002cb:	68 00 10 00 00       	push   $0x1000
  8002d0:	68 08 38 80 00       	push   $0x803808
  8002d5:	e8 63 16 00 00       	call   80193d <smalloc>
  8002da:	83 c4 10             	add    $0x10,%esp
  8002dd:	89 45 cc             	mov    %eax,-0x34(%ebp)
		cprintf("Master env created z (1 page) \n");
  8002e0:	83 ec 0c             	sub    $0xc,%esp
  8002e3:	68 0c 38 80 00       	push   $0x80380c
  8002e8:	e8 76 05 00 00       	call   800863 <cprintf>
  8002ed:	83 c4 10             	add    $0x10,%esp

		x = smalloc("x", PAGE_SIZE, 1);
  8002f0:	83 ec 04             	sub    $0x4,%esp
  8002f3:	6a 01                	push   $0x1
  8002f5:	68 00 10 00 00       	push   $0x1000
  8002fa:	68 0f 36 80 00       	push   $0x80360f
  8002ff:	e8 39 16 00 00       	call   80193d <smalloc>
  800304:	83 c4 10             	add    $0x10,%esp
  800307:	89 45 c8             	mov    %eax,-0x38(%ebp)
		cprintf("Master env created x (1 page) \n");
  80030a:	83 ec 0c             	sub    $0xc,%esp
  80030d:	68 14 36 80 00       	push   $0x803614
  800312:	e8 4c 05 00 00       	call   800863 <cprintf>
  800317:	83 c4 10             	add    $0x10,%esp

		rsttst();
  80031a:	e8 a0 1c 00 00       	call   801fbf <rsttst>

		sys_run_env(envIdSlaveB1);
  80031f:	83 ec 0c             	sub    $0xc,%esp
  800322:	ff 75 d4             	pushl  -0x2c(%ebp)
  800325:	e8 67 1b 00 00       	call   801e91 <sys_run_env>
  80032a:	83 c4 10             	add    $0x10,%esp
		sys_run_env(envIdSlaveB2);
  80032d:	83 ec 0c             	sub    $0xc,%esp
  800330:	ff 75 d0             	pushl  -0x30(%ebp)
  800333:	e8 59 1b 00 00       	call   801e91 <sys_run_env>
  800338:	83 c4 10             	add    $0x10,%esp

		env_sleep(4000); //give slaves time to catch the shared object before removal
  80033b:	83 ec 0c             	sub    $0xc,%esp
  80033e:	68 a0 0f 00 00       	push   $0xfa0
  800343:	e8 41 2e 00 00       	call   803189 <env_sleep>
  800348:	83 c4 10             	add    $0x10,%esp

		int freeFrames = sys_calculate_free_frames() ;
  80034b:	e8 b1 18 00 00       	call   801c01 <sys_calculate_free_frames>
  800350:	89 45 c4             	mov    %eax,-0x3c(%ebp)

		sfree(z);
  800353:	83 ec 0c             	sub    $0xc,%esp
  800356:	ff 75 cc             	pushl  -0x34(%ebp)
  800359:	e8 43 17 00 00       	call   801aa1 <sfree>
  80035e:	83 c4 10             	add    $0x10,%esp
		cprintf("Master env removed z\n");
  800361:	83 ec 0c             	sub    $0xc,%esp
  800364:	68 2c 38 80 00       	push   $0x80382c
  800369:	e8 f5 04 00 00       	call   800863 <cprintf>
  80036e:	83 c4 10             	add    $0x10,%esp

		sfree(x);
  800371:	83 ec 0c             	sub    $0xc,%esp
  800374:	ff 75 c8             	pushl  -0x38(%ebp)
  800377:	e8 25 17 00 00       	call   801aa1 <sfree>
  80037c:	83 c4 10             	add    $0x10,%esp
		cprintf("Master env removed x\n");
  80037f:	83 ec 0c             	sub    $0xc,%esp
  800382:	68 42 38 80 00       	push   $0x803842
  800387:	e8 d7 04 00 00       	call   800863 <cprintf>
  80038c:	83 c4 10             	add    $0x10,%esp

		int diff = (sys_calculate_free_frames() - freeFrames);
  80038f:	e8 6d 18 00 00       	call   801c01 <sys_calculate_free_frames>
  800394:	89 c2                	mov    %eax,%edx
  800396:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  800399:	29 c2                	sub    %eax,%edx
  80039b:	89 d0                	mov    %edx,%eax
  80039d:	89 45 c0             	mov    %eax,-0x40(%ebp)

		if (diff !=  1) panic("Wrong free: frames removed not equal 1 !, correct frames to be removed are 1:\nfrom the env: 1 table\nframes_storage of z & x: should NOT cleared yet (still in use!)\n");
  8003a0:	83 7d c0 01          	cmpl   $0x1,-0x40(%ebp)
  8003a4:	74 14                	je     8003ba <_main+0x382>
  8003a6:	83 ec 04             	sub    $0x4,%esp
  8003a9:	68 58 38 80 00       	push   $0x803858
  8003ae:	6a 59                	push   $0x59
  8003b0:	68 dc 34 80 00       	push   $0x8034dc
  8003b5:	e8 f5 01 00 00       	call   8005af <_panic>

		//To indicate that it's completed successfully
		inctst();
  8003ba:	e8 60 1c 00 00       	call   80201f <inctst>

		int* finish_children = smalloc("finish_children", sizeof(int), 1);
  8003bf:	83 ec 04             	sub    $0x4,%esp
  8003c2:	6a 01                	push   $0x1
  8003c4:	6a 04                	push   $0x4
  8003c6:	68 fd 38 80 00       	push   $0x8038fd
  8003cb:	e8 6d 15 00 00       	call   80193d <smalloc>
  8003d0:	83 c4 10             	add    $0x10,%esp
  8003d3:	89 45 bc             	mov    %eax,-0x44(%ebp)
		*finish_children = 0;
  8003d6:	8b 45 bc             	mov    -0x44(%ebp),%eax
  8003d9:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

		if (sys_getparentenvid() > 0) {
  8003df:	e8 16 1b 00 00       	call   801efa <sys_getparentenvid>
  8003e4:	85 c0                	test   %eax,%eax
  8003e6:	0f 8e 81 00 00 00    	jle    80046d <_main+0x435>
			while(*finish_children != 1);
  8003ec:	90                   	nop
  8003ed:	8b 45 bc             	mov    -0x44(%ebp),%eax
  8003f0:	8b 00                	mov    (%eax),%eax
  8003f2:	83 f8 01             	cmp    $0x1,%eax
  8003f5:	75 f6                	jne    8003ed <_main+0x3b5>
			cprintf("done\n");
  8003f7:	83 ec 0c             	sub    $0xc,%esp
  8003fa:	68 0d 39 80 00       	push   $0x80390d
  8003ff:	e8 5f 04 00 00       	call   800863 <cprintf>
  800404:	83 c4 10             	add    $0x10,%esp
			sys_destroy_env(envIdSlave1);
  800407:	83 ec 0c             	sub    $0xc,%esp
  80040a:	ff 75 e8             	pushl  -0x18(%ebp)
  80040d:	e8 9b 1a 00 00       	call   801ead <sys_destroy_env>
  800412:	83 c4 10             	add    $0x10,%esp
			sys_destroy_env(envIdSlave2);
  800415:	83 ec 0c             	sub    $0xc,%esp
  800418:	ff 75 e4             	pushl  -0x1c(%ebp)
  80041b:	e8 8d 1a 00 00       	call   801ead <sys_destroy_env>
  800420:	83 c4 10             	add    $0x10,%esp
			sys_destroy_env(envIdSlaveB1);
  800423:	83 ec 0c             	sub    $0xc,%esp
  800426:	ff 75 d4             	pushl  -0x2c(%ebp)
  800429:	e8 7f 1a 00 00       	call   801ead <sys_destroy_env>
  80042e:	83 c4 10             	add    $0x10,%esp
			sys_destroy_env(envIdSlaveB2);
  800431:	83 ec 0c             	sub    $0xc,%esp
  800434:	ff 75 d0             	pushl  -0x30(%ebp)
  800437:	e8 71 1a 00 00       	call   801ead <sys_destroy_env>
  80043c:	83 c4 10             	add    $0x10,%esp

			int *finishedCount = NULL;
  80043f:	c7 45 b8 00 00 00 00 	movl   $0x0,-0x48(%ebp)
			finishedCount = sget(sys_getparentenvid(), "finishedCount") ;
  800446:	e8 af 1a 00 00       	call   801efa <sys_getparentenvid>
  80044b:	83 ec 08             	sub    $0x8,%esp
  80044e:	68 13 39 80 00       	push   $0x803913
  800453:	50                   	push   %eax
  800454:	e8 94 15 00 00       	call   8019ed <sget>
  800459:	83 c4 10             	add    $0x10,%esp
  80045c:	89 45 b8             	mov    %eax,-0x48(%ebp)
			(*finishedCount)++ ;
  80045f:	8b 45 b8             	mov    -0x48(%ebp),%eax
  800462:	8b 00                	mov    (%eax),%eax
  800464:	8d 50 01             	lea    0x1(%eax),%edx
  800467:	8b 45 b8             	mov    -0x48(%ebp),%eax
  80046a:	89 10                	mov    %edx,(%eax)
		}
	}


	return;
  80046c:	90                   	nop
  80046d:	90                   	nop
}
  80046e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800471:	c9                   	leave  
  800472:	c3                   	ret    

00800473 <libmain>:
volatile struct Env *myEnv = NULL;
volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";

void
libmain(int argc, char **argv)
{
  800473:	55                   	push   %ebp
  800474:	89 e5                	mov    %esp,%ebp
  800476:	83 ec 18             	sub    $0x18,%esp
	int envIndex = sys_getenvindex();
  800479:	e8 63 1a 00 00       	call   801ee1 <sys_getenvindex>
  80047e:	89 45 f4             	mov    %eax,-0xc(%ebp)
	myEnv = &(envs[envIndex]);
  800481:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800484:	89 d0                	mov    %edx,%eax
  800486:	c1 e0 03             	shl    $0x3,%eax
  800489:	01 d0                	add    %edx,%eax
  80048b:	01 c0                	add    %eax,%eax
  80048d:	01 d0                	add    %edx,%eax
  80048f:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800496:	01 d0                	add    %edx,%eax
  800498:	c1 e0 04             	shl    $0x4,%eax
  80049b:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  8004a0:	a3 20 50 80 00       	mov    %eax,0x805020

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  8004a5:	a1 20 50 80 00       	mov    0x805020,%eax
  8004aa:	8a 80 5c 05 00 00    	mov    0x55c(%eax),%al
  8004b0:	84 c0                	test   %al,%al
  8004b2:	74 0f                	je     8004c3 <libmain+0x50>
		binaryname = myEnv->prog_name;
  8004b4:	a1 20 50 80 00       	mov    0x805020,%eax
  8004b9:	05 5c 05 00 00       	add    $0x55c,%eax
  8004be:	a3 00 50 80 00       	mov    %eax,0x805000

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  8004c3:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8004c7:	7e 0a                	jle    8004d3 <libmain+0x60>
		binaryname = argv[0];
  8004c9:	8b 45 0c             	mov    0xc(%ebp),%eax
  8004cc:	8b 00                	mov    (%eax),%eax
  8004ce:	a3 00 50 80 00       	mov    %eax,0x805000

	// call user main routine
	_main(argc, argv);
  8004d3:	83 ec 08             	sub    $0x8,%esp
  8004d6:	ff 75 0c             	pushl  0xc(%ebp)
  8004d9:	ff 75 08             	pushl  0x8(%ebp)
  8004dc:	e8 57 fb ff ff       	call   800038 <_main>
  8004e1:	83 c4 10             	add    $0x10,%esp



	sys_disable_interrupt();
  8004e4:	e8 05 18 00 00       	call   801cee <sys_disable_interrupt>
	cprintf("**************************************\n");
  8004e9:	83 ec 0c             	sub    $0xc,%esp
  8004ec:	68 3c 39 80 00       	push   $0x80393c
  8004f1:	e8 6d 03 00 00       	call   800863 <cprintf>
  8004f6:	83 c4 10             	add    $0x10,%esp
	cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  8004f9:	a1 20 50 80 00       	mov    0x805020,%eax
  8004fe:	8b 90 44 05 00 00    	mov    0x544(%eax),%edx
  800504:	a1 20 50 80 00       	mov    0x805020,%eax
  800509:	8b 80 34 05 00 00    	mov    0x534(%eax),%eax
  80050f:	83 ec 04             	sub    $0x4,%esp
  800512:	52                   	push   %edx
  800513:	50                   	push   %eax
  800514:	68 64 39 80 00       	push   $0x803964
  800519:	e8 45 03 00 00       	call   800863 <cprintf>
  80051e:	83 c4 10             	add    $0x10,%esp
	cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  800521:	a1 20 50 80 00       	mov    0x805020,%eax
  800526:	8b 88 54 05 00 00    	mov    0x554(%eax),%ecx
  80052c:	a1 20 50 80 00       	mov    0x805020,%eax
  800531:	8b 90 50 05 00 00    	mov    0x550(%eax),%edx
  800537:	a1 20 50 80 00       	mov    0x805020,%eax
  80053c:	8b 80 4c 05 00 00    	mov    0x54c(%eax),%eax
  800542:	51                   	push   %ecx
  800543:	52                   	push   %edx
  800544:	50                   	push   %eax
  800545:	68 8c 39 80 00       	push   $0x80398c
  80054a:	e8 14 03 00 00       	call   800863 <cprintf>
  80054f:	83 c4 10             	add    $0x10,%esp
	//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
	cprintf("Num of clocks = %d\n", myEnv->nClocks);
  800552:	a1 20 50 80 00       	mov    0x805020,%eax
  800557:	8b 80 a4 05 00 00    	mov    0x5a4(%eax),%eax
  80055d:	83 ec 08             	sub    $0x8,%esp
  800560:	50                   	push   %eax
  800561:	68 e4 39 80 00       	push   $0x8039e4
  800566:	e8 f8 02 00 00       	call   800863 <cprintf>
  80056b:	83 c4 10             	add    $0x10,%esp
	cprintf("**************************************\n");
  80056e:	83 ec 0c             	sub    $0xc,%esp
  800571:	68 3c 39 80 00       	push   $0x80393c
  800576:	e8 e8 02 00 00       	call   800863 <cprintf>
  80057b:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  80057e:	e8 85 17 00 00       	call   801d08 <sys_enable_interrupt>

	// exit gracefully
	exit();
  800583:	e8 19 00 00 00       	call   8005a1 <exit>
}
  800588:	90                   	nop
  800589:	c9                   	leave  
  80058a:	c3                   	ret    

0080058b <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  80058b:	55                   	push   %ebp
  80058c:	89 e5                	mov    %esp,%ebp
  80058e:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  800591:	83 ec 0c             	sub    $0xc,%esp
  800594:	6a 00                	push   $0x0
  800596:	e8 12 19 00 00       	call   801ead <sys_destroy_env>
  80059b:	83 c4 10             	add    $0x10,%esp
}
  80059e:	90                   	nop
  80059f:	c9                   	leave  
  8005a0:	c3                   	ret    

008005a1 <exit>:

void
exit(void)
{
  8005a1:	55                   	push   %ebp
  8005a2:	89 e5                	mov    %esp,%ebp
  8005a4:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  8005a7:	e8 67 19 00 00       	call   801f13 <sys_exit_env>
}
  8005ac:	90                   	nop
  8005ad:	c9                   	leave  
  8005ae:	c3                   	ret    

008005af <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  8005af:	55                   	push   %ebp
  8005b0:	89 e5                	mov    %esp,%ebp
  8005b2:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  8005b5:	8d 45 10             	lea    0x10(%ebp),%eax
  8005b8:	83 c0 04             	add    $0x4,%eax
  8005bb:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  8005be:	a1 5c 51 80 00       	mov    0x80515c,%eax
  8005c3:	85 c0                	test   %eax,%eax
  8005c5:	74 16                	je     8005dd <_panic+0x2e>
		cprintf("%s: ", argv0);
  8005c7:	a1 5c 51 80 00       	mov    0x80515c,%eax
  8005cc:	83 ec 08             	sub    $0x8,%esp
  8005cf:	50                   	push   %eax
  8005d0:	68 f8 39 80 00       	push   $0x8039f8
  8005d5:	e8 89 02 00 00       	call   800863 <cprintf>
  8005da:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  8005dd:	a1 00 50 80 00       	mov    0x805000,%eax
  8005e2:	ff 75 0c             	pushl  0xc(%ebp)
  8005e5:	ff 75 08             	pushl  0x8(%ebp)
  8005e8:	50                   	push   %eax
  8005e9:	68 fd 39 80 00       	push   $0x8039fd
  8005ee:	e8 70 02 00 00       	call   800863 <cprintf>
  8005f3:	83 c4 10             	add    $0x10,%esp
	vcprintf(fmt, ap);
  8005f6:	8b 45 10             	mov    0x10(%ebp),%eax
  8005f9:	83 ec 08             	sub    $0x8,%esp
  8005fc:	ff 75 f4             	pushl  -0xc(%ebp)
  8005ff:	50                   	push   %eax
  800600:	e8 f3 01 00 00       	call   8007f8 <vcprintf>
  800605:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  800608:	83 ec 08             	sub    $0x8,%esp
  80060b:	6a 00                	push   $0x0
  80060d:	68 19 3a 80 00       	push   $0x803a19
  800612:	e8 e1 01 00 00       	call   8007f8 <vcprintf>
  800617:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  80061a:	e8 82 ff ff ff       	call   8005a1 <exit>

	// should not return here
	while (1) ;
  80061f:	eb fe                	jmp    80061f <_panic+0x70>

00800621 <CheckWSWithoutLastIndex>:
}

void CheckWSWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  800621:	55                   	push   %ebp
  800622:	89 e5                	mov    %esp,%ebp
  800624:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  800627:	a1 20 50 80 00       	mov    0x805020,%eax
  80062c:	8b 50 74             	mov    0x74(%eax),%edx
  80062f:	8b 45 0c             	mov    0xc(%ebp),%eax
  800632:	39 c2                	cmp    %eax,%edx
  800634:	74 14                	je     80064a <CheckWSWithoutLastIndex+0x29>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  800636:	83 ec 04             	sub    $0x4,%esp
  800639:	68 1c 3a 80 00       	push   $0x803a1c
  80063e:	6a 26                	push   $0x26
  800640:	68 68 3a 80 00       	push   $0x803a68
  800645:	e8 65 ff ff ff       	call   8005af <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  80064a:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  800651:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800658:	e9 c2 00 00 00       	jmp    80071f <CheckWSWithoutLastIndex+0xfe>
		if (expectedPages[e] == 0) {
  80065d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800660:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800667:	8b 45 08             	mov    0x8(%ebp),%eax
  80066a:	01 d0                	add    %edx,%eax
  80066c:	8b 00                	mov    (%eax),%eax
  80066e:	85 c0                	test   %eax,%eax
  800670:	75 08                	jne    80067a <CheckWSWithoutLastIndex+0x59>
			expectedNumOfEmptyLocs++;
  800672:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  800675:	e9 a2 00 00 00       	jmp    80071c <CheckWSWithoutLastIndex+0xfb>
		}
		int found = 0;
  80067a:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800681:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  800688:	eb 69                	jmp    8006f3 <CheckWSWithoutLastIndex+0xd2>
			if (myEnv->__uptr_pws[w].empty == 0) {
  80068a:	a1 20 50 80 00       	mov    0x805020,%eax
  80068f:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  800695:	8b 55 e8             	mov    -0x18(%ebp),%edx
  800698:	89 d0                	mov    %edx,%eax
  80069a:	01 c0                	add    %eax,%eax
  80069c:	01 d0                	add    %edx,%eax
  80069e:	c1 e0 03             	shl    $0x3,%eax
  8006a1:	01 c8                	add    %ecx,%eax
  8006a3:	8a 40 04             	mov    0x4(%eax),%al
  8006a6:	84 c0                	test   %al,%al
  8006a8:	75 46                	jne    8006f0 <CheckWSWithoutLastIndex+0xcf>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  8006aa:	a1 20 50 80 00       	mov    0x805020,%eax
  8006af:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  8006b5:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8006b8:	89 d0                	mov    %edx,%eax
  8006ba:	01 c0                	add    %eax,%eax
  8006bc:	01 d0                	add    %edx,%eax
  8006be:	c1 e0 03             	shl    $0x3,%eax
  8006c1:	01 c8                	add    %ecx,%eax
  8006c3:	8b 00                	mov    (%eax),%eax
  8006c5:	89 45 dc             	mov    %eax,-0x24(%ebp)
  8006c8:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8006cb:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8006d0:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  8006d2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8006d5:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  8006dc:	8b 45 08             	mov    0x8(%ebp),%eax
  8006df:	01 c8                	add    %ecx,%eax
  8006e1:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  8006e3:	39 c2                	cmp    %eax,%edx
  8006e5:	75 09                	jne    8006f0 <CheckWSWithoutLastIndex+0xcf>
						== expectedPages[e]) {
					found = 1;
  8006e7:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  8006ee:	eb 12                	jmp    800702 <CheckWSWithoutLastIndex+0xe1>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8006f0:	ff 45 e8             	incl   -0x18(%ebp)
  8006f3:	a1 20 50 80 00       	mov    0x805020,%eax
  8006f8:	8b 50 74             	mov    0x74(%eax),%edx
  8006fb:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8006fe:	39 c2                	cmp    %eax,%edx
  800700:	77 88                	ja     80068a <CheckWSWithoutLastIndex+0x69>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  800702:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  800706:	75 14                	jne    80071c <CheckWSWithoutLastIndex+0xfb>
			panic(
  800708:	83 ec 04             	sub    $0x4,%esp
  80070b:	68 74 3a 80 00       	push   $0x803a74
  800710:	6a 3a                	push   $0x3a
  800712:	68 68 3a 80 00       	push   $0x803a68
  800717:	e8 93 fe ff ff       	call   8005af <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  80071c:	ff 45 f0             	incl   -0x10(%ebp)
  80071f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800722:	3b 45 0c             	cmp    0xc(%ebp),%eax
  800725:	0f 8c 32 ff ff ff    	jl     80065d <CheckWSWithoutLastIndex+0x3c>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  80072b:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800732:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  800739:	eb 26                	jmp    800761 <CheckWSWithoutLastIndex+0x140>
		if (myEnv->__uptr_pws[w].empty == 1) {
  80073b:	a1 20 50 80 00       	mov    0x805020,%eax
  800740:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  800746:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800749:	89 d0                	mov    %edx,%eax
  80074b:	01 c0                	add    %eax,%eax
  80074d:	01 d0                	add    %edx,%eax
  80074f:	c1 e0 03             	shl    $0x3,%eax
  800752:	01 c8                	add    %ecx,%eax
  800754:	8a 40 04             	mov    0x4(%eax),%al
  800757:	3c 01                	cmp    $0x1,%al
  800759:	75 03                	jne    80075e <CheckWSWithoutLastIndex+0x13d>
			actualNumOfEmptyLocs++;
  80075b:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  80075e:	ff 45 e0             	incl   -0x20(%ebp)
  800761:	a1 20 50 80 00       	mov    0x805020,%eax
  800766:	8b 50 74             	mov    0x74(%eax),%edx
  800769:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80076c:	39 c2                	cmp    %eax,%edx
  80076e:	77 cb                	ja     80073b <CheckWSWithoutLastIndex+0x11a>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  800770:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800773:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  800776:	74 14                	je     80078c <CheckWSWithoutLastIndex+0x16b>
		panic(
  800778:	83 ec 04             	sub    $0x4,%esp
  80077b:	68 c8 3a 80 00       	push   $0x803ac8
  800780:	6a 44                	push   $0x44
  800782:	68 68 3a 80 00       	push   $0x803a68
  800787:	e8 23 fe ff ff       	call   8005af <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  80078c:	90                   	nop
  80078d:	c9                   	leave  
  80078e:	c3                   	ret    

0080078f <putch>:
};

//2017:
uint8 printProgName = 0;

static void putch(int ch, struct printbuf *b) {
  80078f:	55                   	push   %ebp
  800790:	89 e5                	mov    %esp,%ebp
  800792:	83 ec 08             	sub    $0x8,%esp
	b->buf[b->idx++] = ch;
  800795:	8b 45 0c             	mov    0xc(%ebp),%eax
  800798:	8b 00                	mov    (%eax),%eax
  80079a:	8d 48 01             	lea    0x1(%eax),%ecx
  80079d:	8b 55 0c             	mov    0xc(%ebp),%edx
  8007a0:	89 0a                	mov    %ecx,(%edx)
  8007a2:	8b 55 08             	mov    0x8(%ebp),%edx
  8007a5:	88 d1                	mov    %dl,%cl
  8007a7:	8b 55 0c             	mov    0xc(%ebp),%edx
  8007aa:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  8007ae:	8b 45 0c             	mov    0xc(%ebp),%eax
  8007b1:	8b 00                	mov    (%eax),%eax
  8007b3:	3d ff 00 00 00       	cmp    $0xff,%eax
  8007b8:	75 2c                	jne    8007e6 <putch+0x57>
		sys_cputs(b->buf, b->idx, printProgName);
  8007ba:	a0 24 50 80 00       	mov    0x805024,%al
  8007bf:	0f b6 c0             	movzbl %al,%eax
  8007c2:	8b 55 0c             	mov    0xc(%ebp),%edx
  8007c5:	8b 12                	mov    (%edx),%edx
  8007c7:	89 d1                	mov    %edx,%ecx
  8007c9:	8b 55 0c             	mov    0xc(%ebp),%edx
  8007cc:	83 c2 08             	add    $0x8,%edx
  8007cf:	83 ec 04             	sub    $0x4,%esp
  8007d2:	50                   	push   %eax
  8007d3:	51                   	push   %ecx
  8007d4:	52                   	push   %edx
  8007d5:	e8 66 13 00 00       	call   801b40 <sys_cputs>
  8007da:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  8007dd:	8b 45 0c             	mov    0xc(%ebp),%eax
  8007e0:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  8007e6:	8b 45 0c             	mov    0xc(%ebp),%eax
  8007e9:	8b 40 04             	mov    0x4(%eax),%eax
  8007ec:	8d 50 01             	lea    0x1(%eax),%edx
  8007ef:	8b 45 0c             	mov    0xc(%ebp),%eax
  8007f2:	89 50 04             	mov    %edx,0x4(%eax)
}
  8007f5:	90                   	nop
  8007f6:	c9                   	leave  
  8007f7:	c3                   	ret    

008007f8 <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  8007f8:	55                   	push   %ebp
  8007f9:	89 e5                	mov    %esp,%ebp
  8007fb:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  800801:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  800808:	00 00 00 
	b.cnt = 0;
  80080b:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  800812:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  800815:	ff 75 0c             	pushl  0xc(%ebp)
  800818:	ff 75 08             	pushl  0x8(%ebp)
  80081b:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800821:	50                   	push   %eax
  800822:	68 8f 07 80 00       	push   $0x80078f
  800827:	e8 11 02 00 00       	call   800a3d <vprintfmt>
  80082c:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName);
  80082f:	a0 24 50 80 00       	mov    0x805024,%al
  800834:	0f b6 c0             	movzbl %al,%eax
  800837:	8b 95 f0 fe ff ff    	mov    -0x110(%ebp),%edx
  80083d:	83 ec 04             	sub    $0x4,%esp
  800840:	50                   	push   %eax
  800841:	52                   	push   %edx
  800842:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800848:	83 c0 08             	add    $0x8,%eax
  80084b:	50                   	push   %eax
  80084c:	e8 ef 12 00 00       	call   801b40 <sys_cputs>
  800851:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  800854:	c6 05 24 50 80 00 00 	movb   $0x0,0x805024
	return b.cnt;
  80085b:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  800861:	c9                   	leave  
  800862:	c3                   	ret    

00800863 <cprintf>:

int cprintf(const char *fmt, ...) {
  800863:	55                   	push   %ebp
  800864:	89 e5                	mov    %esp,%ebp
  800866:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  800869:	c6 05 24 50 80 00 01 	movb   $0x1,0x805024
	va_start(ap, fmt);
  800870:	8d 45 0c             	lea    0xc(%ebp),%eax
  800873:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800876:	8b 45 08             	mov    0x8(%ebp),%eax
  800879:	83 ec 08             	sub    $0x8,%esp
  80087c:	ff 75 f4             	pushl  -0xc(%ebp)
  80087f:	50                   	push   %eax
  800880:	e8 73 ff ff ff       	call   8007f8 <vcprintf>
  800885:	83 c4 10             	add    $0x10,%esp
  800888:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  80088b:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  80088e:	c9                   	leave  
  80088f:	c3                   	ret    

00800890 <atomic_cprintf>:

int atomic_cprintf(const char *fmt, ...) {
  800890:	55                   	push   %ebp
  800891:	89 e5                	mov    %esp,%ebp
  800893:	83 ec 18             	sub    $0x18,%esp
	sys_disable_interrupt();
  800896:	e8 53 14 00 00       	call   801cee <sys_disable_interrupt>
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  80089b:	8d 45 0c             	lea    0xc(%ebp),%eax
  80089e:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  8008a1:	8b 45 08             	mov    0x8(%ebp),%eax
  8008a4:	83 ec 08             	sub    $0x8,%esp
  8008a7:	ff 75 f4             	pushl  -0xc(%ebp)
  8008aa:	50                   	push   %eax
  8008ab:	e8 48 ff ff ff       	call   8007f8 <vcprintf>
  8008b0:	83 c4 10             	add    $0x10,%esp
  8008b3:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	sys_enable_interrupt();
  8008b6:	e8 4d 14 00 00       	call   801d08 <sys_enable_interrupt>
	return cnt;
  8008bb:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8008be:	c9                   	leave  
  8008bf:	c3                   	ret    

008008c0 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  8008c0:	55                   	push   %ebp
  8008c1:	89 e5                	mov    %esp,%ebp
  8008c3:	53                   	push   %ebx
  8008c4:	83 ec 14             	sub    $0x14,%esp
  8008c7:	8b 45 10             	mov    0x10(%ebp),%eax
  8008ca:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8008cd:	8b 45 14             	mov    0x14(%ebp),%eax
  8008d0:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  8008d3:	8b 45 18             	mov    0x18(%ebp),%eax
  8008d6:	ba 00 00 00 00       	mov    $0x0,%edx
  8008db:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  8008de:	77 55                	ja     800935 <printnum+0x75>
  8008e0:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  8008e3:	72 05                	jb     8008ea <printnum+0x2a>
  8008e5:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8008e8:	77 4b                	ja     800935 <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  8008ea:	8b 45 1c             	mov    0x1c(%ebp),%eax
  8008ed:	8d 58 ff             	lea    -0x1(%eax),%ebx
  8008f0:	8b 45 18             	mov    0x18(%ebp),%eax
  8008f3:	ba 00 00 00 00       	mov    $0x0,%edx
  8008f8:	52                   	push   %edx
  8008f9:	50                   	push   %eax
  8008fa:	ff 75 f4             	pushl  -0xc(%ebp)
  8008fd:	ff 75 f0             	pushl  -0x10(%ebp)
  800900:	e8 3b 29 00 00       	call   803240 <__udivdi3>
  800905:	83 c4 10             	add    $0x10,%esp
  800908:	83 ec 04             	sub    $0x4,%esp
  80090b:	ff 75 20             	pushl  0x20(%ebp)
  80090e:	53                   	push   %ebx
  80090f:	ff 75 18             	pushl  0x18(%ebp)
  800912:	52                   	push   %edx
  800913:	50                   	push   %eax
  800914:	ff 75 0c             	pushl  0xc(%ebp)
  800917:	ff 75 08             	pushl  0x8(%ebp)
  80091a:	e8 a1 ff ff ff       	call   8008c0 <printnum>
  80091f:	83 c4 20             	add    $0x20,%esp
  800922:	eb 1a                	jmp    80093e <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  800924:	83 ec 08             	sub    $0x8,%esp
  800927:	ff 75 0c             	pushl  0xc(%ebp)
  80092a:	ff 75 20             	pushl  0x20(%ebp)
  80092d:	8b 45 08             	mov    0x8(%ebp),%eax
  800930:	ff d0                	call   *%eax
  800932:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800935:	ff 4d 1c             	decl   0x1c(%ebp)
  800938:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  80093c:	7f e6                	jg     800924 <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  80093e:	8b 4d 18             	mov    0x18(%ebp),%ecx
  800941:	bb 00 00 00 00       	mov    $0x0,%ebx
  800946:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800949:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80094c:	53                   	push   %ebx
  80094d:	51                   	push   %ecx
  80094e:	52                   	push   %edx
  80094f:	50                   	push   %eax
  800950:	e8 fb 29 00 00       	call   803350 <__umoddi3>
  800955:	83 c4 10             	add    $0x10,%esp
  800958:	05 34 3d 80 00       	add    $0x803d34,%eax
  80095d:	8a 00                	mov    (%eax),%al
  80095f:	0f be c0             	movsbl %al,%eax
  800962:	83 ec 08             	sub    $0x8,%esp
  800965:	ff 75 0c             	pushl  0xc(%ebp)
  800968:	50                   	push   %eax
  800969:	8b 45 08             	mov    0x8(%ebp),%eax
  80096c:	ff d0                	call   *%eax
  80096e:	83 c4 10             	add    $0x10,%esp
}
  800971:	90                   	nop
  800972:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800975:	c9                   	leave  
  800976:	c3                   	ret    

00800977 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  800977:	55                   	push   %ebp
  800978:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  80097a:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  80097e:	7e 1c                	jle    80099c <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  800980:	8b 45 08             	mov    0x8(%ebp),%eax
  800983:	8b 00                	mov    (%eax),%eax
  800985:	8d 50 08             	lea    0x8(%eax),%edx
  800988:	8b 45 08             	mov    0x8(%ebp),%eax
  80098b:	89 10                	mov    %edx,(%eax)
  80098d:	8b 45 08             	mov    0x8(%ebp),%eax
  800990:	8b 00                	mov    (%eax),%eax
  800992:	83 e8 08             	sub    $0x8,%eax
  800995:	8b 50 04             	mov    0x4(%eax),%edx
  800998:	8b 00                	mov    (%eax),%eax
  80099a:	eb 40                	jmp    8009dc <getuint+0x65>
	else if (lflag)
  80099c:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8009a0:	74 1e                	je     8009c0 <getuint+0x49>
		return va_arg(*ap, unsigned long);
  8009a2:	8b 45 08             	mov    0x8(%ebp),%eax
  8009a5:	8b 00                	mov    (%eax),%eax
  8009a7:	8d 50 04             	lea    0x4(%eax),%edx
  8009aa:	8b 45 08             	mov    0x8(%ebp),%eax
  8009ad:	89 10                	mov    %edx,(%eax)
  8009af:	8b 45 08             	mov    0x8(%ebp),%eax
  8009b2:	8b 00                	mov    (%eax),%eax
  8009b4:	83 e8 04             	sub    $0x4,%eax
  8009b7:	8b 00                	mov    (%eax),%eax
  8009b9:	ba 00 00 00 00       	mov    $0x0,%edx
  8009be:	eb 1c                	jmp    8009dc <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  8009c0:	8b 45 08             	mov    0x8(%ebp),%eax
  8009c3:	8b 00                	mov    (%eax),%eax
  8009c5:	8d 50 04             	lea    0x4(%eax),%edx
  8009c8:	8b 45 08             	mov    0x8(%ebp),%eax
  8009cb:	89 10                	mov    %edx,(%eax)
  8009cd:	8b 45 08             	mov    0x8(%ebp),%eax
  8009d0:	8b 00                	mov    (%eax),%eax
  8009d2:	83 e8 04             	sub    $0x4,%eax
  8009d5:	8b 00                	mov    (%eax),%eax
  8009d7:	ba 00 00 00 00       	mov    $0x0,%edx
}
  8009dc:	5d                   	pop    %ebp
  8009dd:	c3                   	ret    

008009de <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  8009de:	55                   	push   %ebp
  8009df:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  8009e1:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  8009e5:	7e 1c                	jle    800a03 <getint+0x25>
		return va_arg(*ap, long long);
  8009e7:	8b 45 08             	mov    0x8(%ebp),%eax
  8009ea:	8b 00                	mov    (%eax),%eax
  8009ec:	8d 50 08             	lea    0x8(%eax),%edx
  8009ef:	8b 45 08             	mov    0x8(%ebp),%eax
  8009f2:	89 10                	mov    %edx,(%eax)
  8009f4:	8b 45 08             	mov    0x8(%ebp),%eax
  8009f7:	8b 00                	mov    (%eax),%eax
  8009f9:	83 e8 08             	sub    $0x8,%eax
  8009fc:	8b 50 04             	mov    0x4(%eax),%edx
  8009ff:	8b 00                	mov    (%eax),%eax
  800a01:	eb 38                	jmp    800a3b <getint+0x5d>
	else if (lflag)
  800a03:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800a07:	74 1a                	je     800a23 <getint+0x45>
		return va_arg(*ap, long);
  800a09:	8b 45 08             	mov    0x8(%ebp),%eax
  800a0c:	8b 00                	mov    (%eax),%eax
  800a0e:	8d 50 04             	lea    0x4(%eax),%edx
  800a11:	8b 45 08             	mov    0x8(%ebp),%eax
  800a14:	89 10                	mov    %edx,(%eax)
  800a16:	8b 45 08             	mov    0x8(%ebp),%eax
  800a19:	8b 00                	mov    (%eax),%eax
  800a1b:	83 e8 04             	sub    $0x4,%eax
  800a1e:	8b 00                	mov    (%eax),%eax
  800a20:	99                   	cltd   
  800a21:	eb 18                	jmp    800a3b <getint+0x5d>
	else
		return va_arg(*ap, int);
  800a23:	8b 45 08             	mov    0x8(%ebp),%eax
  800a26:	8b 00                	mov    (%eax),%eax
  800a28:	8d 50 04             	lea    0x4(%eax),%edx
  800a2b:	8b 45 08             	mov    0x8(%ebp),%eax
  800a2e:	89 10                	mov    %edx,(%eax)
  800a30:	8b 45 08             	mov    0x8(%ebp),%eax
  800a33:	8b 00                	mov    (%eax),%eax
  800a35:	83 e8 04             	sub    $0x4,%eax
  800a38:	8b 00                	mov    (%eax),%eax
  800a3a:	99                   	cltd   
}
  800a3b:	5d                   	pop    %ebp
  800a3c:	c3                   	ret    

00800a3d <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  800a3d:	55                   	push   %ebp
  800a3e:	89 e5                	mov    %esp,%ebp
  800a40:	56                   	push   %esi
  800a41:	53                   	push   %ebx
  800a42:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800a45:	eb 17                	jmp    800a5e <vprintfmt+0x21>
			if (ch == '\0')
  800a47:	85 db                	test   %ebx,%ebx
  800a49:	0f 84 af 03 00 00    	je     800dfe <vprintfmt+0x3c1>
				return;
			putch(ch, putdat);
  800a4f:	83 ec 08             	sub    $0x8,%esp
  800a52:	ff 75 0c             	pushl  0xc(%ebp)
  800a55:	53                   	push   %ebx
  800a56:	8b 45 08             	mov    0x8(%ebp),%eax
  800a59:	ff d0                	call   *%eax
  800a5b:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800a5e:	8b 45 10             	mov    0x10(%ebp),%eax
  800a61:	8d 50 01             	lea    0x1(%eax),%edx
  800a64:	89 55 10             	mov    %edx,0x10(%ebp)
  800a67:	8a 00                	mov    (%eax),%al
  800a69:	0f b6 d8             	movzbl %al,%ebx
  800a6c:	83 fb 25             	cmp    $0x25,%ebx
  800a6f:	75 d6                	jne    800a47 <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  800a71:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  800a75:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  800a7c:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  800a83:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  800a8a:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800a91:	8b 45 10             	mov    0x10(%ebp),%eax
  800a94:	8d 50 01             	lea    0x1(%eax),%edx
  800a97:	89 55 10             	mov    %edx,0x10(%ebp)
  800a9a:	8a 00                	mov    (%eax),%al
  800a9c:	0f b6 d8             	movzbl %al,%ebx
  800a9f:	8d 43 dd             	lea    -0x23(%ebx),%eax
  800aa2:	83 f8 55             	cmp    $0x55,%eax
  800aa5:	0f 87 2b 03 00 00    	ja     800dd6 <vprintfmt+0x399>
  800aab:	8b 04 85 58 3d 80 00 	mov    0x803d58(,%eax,4),%eax
  800ab2:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  800ab4:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  800ab8:	eb d7                	jmp    800a91 <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  800aba:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  800abe:	eb d1                	jmp    800a91 <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800ac0:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  800ac7:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800aca:	89 d0                	mov    %edx,%eax
  800acc:	c1 e0 02             	shl    $0x2,%eax
  800acf:	01 d0                	add    %edx,%eax
  800ad1:	01 c0                	add    %eax,%eax
  800ad3:	01 d8                	add    %ebx,%eax
  800ad5:	83 e8 30             	sub    $0x30,%eax
  800ad8:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  800adb:	8b 45 10             	mov    0x10(%ebp),%eax
  800ade:	8a 00                	mov    (%eax),%al
  800ae0:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  800ae3:	83 fb 2f             	cmp    $0x2f,%ebx
  800ae6:	7e 3e                	jle    800b26 <vprintfmt+0xe9>
  800ae8:	83 fb 39             	cmp    $0x39,%ebx
  800aeb:	7f 39                	jg     800b26 <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800aed:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  800af0:	eb d5                	jmp    800ac7 <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  800af2:	8b 45 14             	mov    0x14(%ebp),%eax
  800af5:	83 c0 04             	add    $0x4,%eax
  800af8:	89 45 14             	mov    %eax,0x14(%ebp)
  800afb:	8b 45 14             	mov    0x14(%ebp),%eax
  800afe:	83 e8 04             	sub    $0x4,%eax
  800b01:	8b 00                	mov    (%eax),%eax
  800b03:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  800b06:	eb 1f                	jmp    800b27 <vprintfmt+0xea>

		case '.':
			if (width < 0)
  800b08:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800b0c:	79 83                	jns    800a91 <vprintfmt+0x54>
				width = 0;
  800b0e:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  800b15:	e9 77 ff ff ff       	jmp    800a91 <vprintfmt+0x54>

		case '#':
			altflag = 1;
  800b1a:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  800b21:	e9 6b ff ff ff       	jmp    800a91 <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  800b26:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  800b27:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800b2b:	0f 89 60 ff ff ff    	jns    800a91 <vprintfmt+0x54>
				width = precision, precision = -1;
  800b31:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800b34:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800b37:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  800b3e:	e9 4e ff ff ff       	jmp    800a91 <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  800b43:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  800b46:	e9 46 ff ff ff       	jmp    800a91 <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  800b4b:	8b 45 14             	mov    0x14(%ebp),%eax
  800b4e:	83 c0 04             	add    $0x4,%eax
  800b51:	89 45 14             	mov    %eax,0x14(%ebp)
  800b54:	8b 45 14             	mov    0x14(%ebp),%eax
  800b57:	83 e8 04             	sub    $0x4,%eax
  800b5a:	8b 00                	mov    (%eax),%eax
  800b5c:	83 ec 08             	sub    $0x8,%esp
  800b5f:	ff 75 0c             	pushl  0xc(%ebp)
  800b62:	50                   	push   %eax
  800b63:	8b 45 08             	mov    0x8(%ebp),%eax
  800b66:	ff d0                	call   *%eax
  800b68:	83 c4 10             	add    $0x10,%esp
			break;
  800b6b:	e9 89 02 00 00       	jmp    800df9 <vprintfmt+0x3bc>

		// error message
		case 'e':
			err = va_arg(ap, int);
  800b70:	8b 45 14             	mov    0x14(%ebp),%eax
  800b73:	83 c0 04             	add    $0x4,%eax
  800b76:	89 45 14             	mov    %eax,0x14(%ebp)
  800b79:	8b 45 14             	mov    0x14(%ebp),%eax
  800b7c:	83 e8 04             	sub    $0x4,%eax
  800b7f:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  800b81:	85 db                	test   %ebx,%ebx
  800b83:	79 02                	jns    800b87 <vprintfmt+0x14a>
				err = -err;
  800b85:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  800b87:	83 fb 64             	cmp    $0x64,%ebx
  800b8a:	7f 0b                	jg     800b97 <vprintfmt+0x15a>
  800b8c:	8b 34 9d a0 3b 80 00 	mov    0x803ba0(,%ebx,4),%esi
  800b93:	85 f6                	test   %esi,%esi
  800b95:	75 19                	jne    800bb0 <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  800b97:	53                   	push   %ebx
  800b98:	68 45 3d 80 00       	push   $0x803d45
  800b9d:	ff 75 0c             	pushl  0xc(%ebp)
  800ba0:	ff 75 08             	pushl  0x8(%ebp)
  800ba3:	e8 5e 02 00 00       	call   800e06 <printfmt>
  800ba8:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  800bab:	e9 49 02 00 00       	jmp    800df9 <vprintfmt+0x3bc>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  800bb0:	56                   	push   %esi
  800bb1:	68 4e 3d 80 00       	push   $0x803d4e
  800bb6:	ff 75 0c             	pushl  0xc(%ebp)
  800bb9:	ff 75 08             	pushl  0x8(%ebp)
  800bbc:	e8 45 02 00 00       	call   800e06 <printfmt>
  800bc1:	83 c4 10             	add    $0x10,%esp
			break;
  800bc4:	e9 30 02 00 00       	jmp    800df9 <vprintfmt+0x3bc>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  800bc9:	8b 45 14             	mov    0x14(%ebp),%eax
  800bcc:	83 c0 04             	add    $0x4,%eax
  800bcf:	89 45 14             	mov    %eax,0x14(%ebp)
  800bd2:	8b 45 14             	mov    0x14(%ebp),%eax
  800bd5:	83 e8 04             	sub    $0x4,%eax
  800bd8:	8b 30                	mov    (%eax),%esi
  800bda:	85 f6                	test   %esi,%esi
  800bdc:	75 05                	jne    800be3 <vprintfmt+0x1a6>
				p = "(null)";
  800bde:	be 51 3d 80 00       	mov    $0x803d51,%esi
			if (width > 0 && padc != '-')
  800be3:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800be7:	7e 6d                	jle    800c56 <vprintfmt+0x219>
  800be9:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  800bed:	74 67                	je     800c56 <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  800bef:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800bf2:	83 ec 08             	sub    $0x8,%esp
  800bf5:	50                   	push   %eax
  800bf6:	56                   	push   %esi
  800bf7:	e8 0c 03 00 00       	call   800f08 <strnlen>
  800bfc:	83 c4 10             	add    $0x10,%esp
  800bff:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  800c02:	eb 16                	jmp    800c1a <vprintfmt+0x1dd>
					putch(padc, putdat);
  800c04:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  800c08:	83 ec 08             	sub    $0x8,%esp
  800c0b:	ff 75 0c             	pushl  0xc(%ebp)
  800c0e:	50                   	push   %eax
  800c0f:	8b 45 08             	mov    0x8(%ebp),%eax
  800c12:	ff d0                	call   *%eax
  800c14:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800c17:	ff 4d e4             	decl   -0x1c(%ebp)
  800c1a:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800c1e:	7f e4                	jg     800c04 <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800c20:	eb 34                	jmp    800c56 <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  800c22:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  800c26:	74 1c                	je     800c44 <vprintfmt+0x207>
  800c28:	83 fb 1f             	cmp    $0x1f,%ebx
  800c2b:	7e 05                	jle    800c32 <vprintfmt+0x1f5>
  800c2d:	83 fb 7e             	cmp    $0x7e,%ebx
  800c30:	7e 12                	jle    800c44 <vprintfmt+0x207>
					putch('?', putdat);
  800c32:	83 ec 08             	sub    $0x8,%esp
  800c35:	ff 75 0c             	pushl  0xc(%ebp)
  800c38:	6a 3f                	push   $0x3f
  800c3a:	8b 45 08             	mov    0x8(%ebp),%eax
  800c3d:	ff d0                	call   *%eax
  800c3f:	83 c4 10             	add    $0x10,%esp
  800c42:	eb 0f                	jmp    800c53 <vprintfmt+0x216>
				else
					putch(ch, putdat);
  800c44:	83 ec 08             	sub    $0x8,%esp
  800c47:	ff 75 0c             	pushl  0xc(%ebp)
  800c4a:	53                   	push   %ebx
  800c4b:	8b 45 08             	mov    0x8(%ebp),%eax
  800c4e:	ff d0                	call   *%eax
  800c50:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800c53:	ff 4d e4             	decl   -0x1c(%ebp)
  800c56:	89 f0                	mov    %esi,%eax
  800c58:	8d 70 01             	lea    0x1(%eax),%esi
  800c5b:	8a 00                	mov    (%eax),%al
  800c5d:	0f be d8             	movsbl %al,%ebx
  800c60:	85 db                	test   %ebx,%ebx
  800c62:	74 24                	je     800c88 <vprintfmt+0x24b>
  800c64:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800c68:	78 b8                	js     800c22 <vprintfmt+0x1e5>
  800c6a:	ff 4d e0             	decl   -0x20(%ebp)
  800c6d:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800c71:	79 af                	jns    800c22 <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800c73:	eb 13                	jmp    800c88 <vprintfmt+0x24b>
				putch(' ', putdat);
  800c75:	83 ec 08             	sub    $0x8,%esp
  800c78:	ff 75 0c             	pushl  0xc(%ebp)
  800c7b:	6a 20                	push   $0x20
  800c7d:	8b 45 08             	mov    0x8(%ebp),%eax
  800c80:	ff d0                	call   *%eax
  800c82:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800c85:	ff 4d e4             	decl   -0x1c(%ebp)
  800c88:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800c8c:	7f e7                	jg     800c75 <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  800c8e:	e9 66 01 00 00       	jmp    800df9 <vprintfmt+0x3bc>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  800c93:	83 ec 08             	sub    $0x8,%esp
  800c96:	ff 75 e8             	pushl  -0x18(%ebp)
  800c99:	8d 45 14             	lea    0x14(%ebp),%eax
  800c9c:	50                   	push   %eax
  800c9d:	e8 3c fd ff ff       	call   8009de <getint>
  800ca2:	83 c4 10             	add    $0x10,%esp
  800ca5:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800ca8:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  800cab:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800cae:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800cb1:	85 d2                	test   %edx,%edx
  800cb3:	79 23                	jns    800cd8 <vprintfmt+0x29b>
				putch('-', putdat);
  800cb5:	83 ec 08             	sub    $0x8,%esp
  800cb8:	ff 75 0c             	pushl  0xc(%ebp)
  800cbb:	6a 2d                	push   $0x2d
  800cbd:	8b 45 08             	mov    0x8(%ebp),%eax
  800cc0:	ff d0                	call   *%eax
  800cc2:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  800cc5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800cc8:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800ccb:	f7 d8                	neg    %eax
  800ccd:	83 d2 00             	adc    $0x0,%edx
  800cd0:	f7 da                	neg    %edx
  800cd2:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800cd5:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  800cd8:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800cdf:	e9 bc 00 00 00       	jmp    800da0 <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  800ce4:	83 ec 08             	sub    $0x8,%esp
  800ce7:	ff 75 e8             	pushl  -0x18(%ebp)
  800cea:	8d 45 14             	lea    0x14(%ebp),%eax
  800ced:	50                   	push   %eax
  800cee:	e8 84 fc ff ff       	call   800977 <getuint>
  800cf3:	83 c4 10             	add    $0x10,%esp
  800cf6:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800cf9:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  800cfc:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800d03:	e9 98 00 00 00       	jmp    800da0 <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  800d08:	83 ec 08             	sub    $0x8,%esp
  800d0b:	ff 75 0c             	pushl  0xc(%ebp)
  800d0e:	6a 58                	push   $0x58
  800d10:	8b 45 08             	mov    0x8(%ebp),%eax
  800d13:	ff d0                	call   *%eax
  800d15:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800d18:	83 ec 08             	sub    $0x8,%esp
  800d1b:	ff 75 0c             	pushl  0xc(%ebp)
  800d1e:	6a 58                	push   $0x58
  800d20:	8b 45 08             	mov    0x8(%ebp),%eax
  800d23:	ff d0                	call   *%eax
  800d25:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800d28:	83 ec 08             	sub    $0x8,%esp
  800d2b:	ff 75 0c             	pushl  0xc(%ebp)
  800d2e:	6a 58                	push   $0x58
  800d30:	8b 45 08             	mov    0x8(%ebp),%eax
  800d33:	ff d0                	call   *%eax
  800d35:	83 c4 10             	add    $0x10,%esp
			break;
  800d38:	e9 bc 00 00 00       	jmp    800df9 <vprintfmt+0x3bc>

		// pointer
		case 'p':
			putch('0', putdat);
  800d3d:	83 ec 08             	sub    $0x8,%esp
  800d40:	ff 75 0c             	pushl  0xc(%ebp)
  800d43:	6a 30                	push   $0x30
  800d45:	8b 45 08             	mov    0x8(%ebp),%eax
  800d48:	ff d0                	call   *%eax
  800d4a:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  800d4d:	83 ec 08             	sub    $0x8,%esp
  800d50:	ff 75 0c             	pushl  0xc(%ebp)
  800d53:	6a 78                	push   $0x78
  800d55:	8b 45 08             	mov    0x8(%ebp),%eax
  800d58:	ff d0                	call   *%eax
  800d5a:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  800d5d:	8b 45 14             	mov    0x14(%ebp),%eax
  800d60:	83 c0 04             	add    $0x4,%eax
  800d63:	89 45 14             	mov    %eax,0x14(%ebp)
  800d66:	8b 45 14             	mov    0x14(%ebp),%eax
  800d69:	83 e8 04             	sub    $0x4,%eax
  800d6c:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800d6e:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800d71:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  800d78:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  800d7f:	eb 1f                	jmp    800da0 <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  800d81:	83 ec 08             	sub    $0x8,%esp
  800d84:	ff 75 e8             	pushl  -0x18(%ebp)
  800d87:	8d 45 14             	lea    0x14(%ebp),%eax
  800d8a:	50                   	push   %eax
  800d8b:	e8 e7 fb ff ff       	call   800977 <getuint>
  800d90:	83 c4 10             	add    $0x10,%esp
  800d93:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800d96:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  800d99:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800da0:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  800da4:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800da7:	83 ec 04             	sub    $0x4,%esp
  800daa:	52                   	push   %edx
  800dab:	ff 75 e4             	pushl  -0x1c(%ebp)
  800dae:	50                   	push   %eax
  800daf:	ff 75 f4             	pushl  -0xc(%ebp)
  800db2:	ff 75 f0             	pushl  -0x10(%ebp)
  800db5:	ff 75 0c             	pushl  0xc(%ebp)
  800db8:	ff 75 08             	pushl  0x8(%ebp)
  800dbb:	e8 00 fb ff ff       	call   8008c0 <printnum>
  800dc0:	83 c4 20             	add    $0x20,%esp
			break;
  800dc3:	eb 34                	jmp    800df9 <vprintfmt+0x3bc>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  800dc5:	83 ec 08             	sub    $0x8,%esp
  800dc8:	ff 75 0c             	pushl  0xc(%ebp)
  800dcb:	53                   	push   %ebx
  800dcc:	8b 45 08             	mov    0x8(%ebp),%eax
  800dcf:	ff d0                	call   *%eax
  800dd1:	83 c4 10             	add    $0x10,%esp
			break;
  800dd4:	eb 23                	jmp    800df9 <vprintfmt+0x3bc>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800dd6:	83 ec 08             	sub    $0x8,%esp
  800dd9:	ff 75 0c             	pushl  0xc(%ebp)
  800ddc:	6a 25                	push   $0x25
  800dde:	8b 45 08             	mov    0x8(%ebp),%eax
  800de1:	ff d0                	call   *%eax
  800de3:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  800de6:	ff 4d 10             	decl   0x10(%ebp)
  800de9:	eb 03                	jmp    800dee <vprintfmt+0x3b1>
  800deb:	ff 4d 10             	decl   0x10(%ebp)
  800dee:	8b 45 10             	mov    0x10(%ebp),%eax
  800df1:	48                   	dec    %eax
  800df2:	8a 00                	mov    (%eax),%al
  800df4:	3c 25                	cmp    $0x25,%al
  800df6:	75 f3                	jne    800deb <vprintfmt+0x3ae>
				/* do nothing */;
			break;
  800df8:	90                   	nop
		}
	}
  800df9:	e9 47 fc ff ff       	jmp    800a45 <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  800dfe:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  800dff:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800e02:	5b                   	pop    %ebx
  800e03:	5e                   	pop    %esi
  800e04:	5d                   	pop    %ebp
  800e05:	c3                   	ret    

00800e06 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800e06:	55                   	push   %ebp
  800e07:	89 e5                	mov    %esp,%ebp
  800e09:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  800e0c:	8d 45 10             	lea    0x10(%ebp),%eax
  800e0f:	83 c0 04             	add    $0x4,%eax
  800e12:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  800e15:	8b 45 10             	mov    0x10(%ebp),%eax
  800e18:	ff 75 f4             	pushl  -0xc(%ebp)
  800e1b:	50                   	push   %eax
  800e1c:	ff 75 0c             	pushl  0xc(%ebp)
  800e1f:	ff 75 08             	pushl  0x8(%ebp)
  800e22:	e8 16 fc ff ff       	call   800a3d <vprintfmt>
  800e27:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  800e2a:	90                   	nop
  800e2b:	c9                   	leave  
  800e2c:	c3                   	ret    

00800e2d <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800e2d:	55                   	push   %ebp
  800e2e:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  800e30:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e33:	8b 40 08             	mov    0x8(%eax),%eax
  800e36:	8d 50 01             	lea    0x1(%eax),%edx
  800e39:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e3c:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  800e3f:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e42:	8b 10                	mov    (%eax),%edx
  800e44:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e47:	8b 40 04             	mov    0x4(%eax),%eax
  800e4a:	39 c2                	cmp    %eax,%edx
  800e4c:	73 12                	jae    800e60 <sprintputch+0x33>
		*b->buf++ = ch;
  800e4e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e51:	8b 00                	mov    (%eax),%eax
  800e53:	8d 48 01             	lea    0x1(%eax),%ecx
  800e56:	8b 55 0c             	mov    0xc(%ebp),%edx
  800e59:	89 0a                	mov    %ecx,(%edx)
  800e5b:	8b 55 08             	mov    0x8(%ebp),%edx
  800e5e:	88 10                	mov    %dl,(%eax)
}
  800e60:	90                   	nop
  800e61:	5d                   	pop    %ebp
  800e62:	c3                   	ret    

00800e63 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800e63:	55                   	push   %ebp
  800e64:	89 e5                	mov    %esp,%ebp
  800e66:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  800e69:	8b 45 08             	mov    0x8(%ebp),%eax
  800e6c:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800e6f:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e72:	8d 50 ff             	lea    -0x1(%eax),%edx
  800e75:	8b 45 08             	mov    0x8(%ebp),%eax
  800e78:	01 d0                	add    %edx,%eax
  800e7a:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800e7d:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800e84:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800e88:	74 06                	je     800e90 <vsnprintf+0x2d>
  800e8a:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800e8e:	7f 07                	jg     800e97 <vsnprintf+0x34>
		return -E_INVAL;
  800e90:	b8 03 00 00 00       	mov    $0x3,%eax
  800e95:	eb 20                	jmp    800eb7 <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800e97:	ff 75 14             	pushl  0x14(%ebp)
  800e9a:	ff 75 10             	pushl  0x10(%ebp)
  800e9d:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800ea0:	50                   	push   %eax
  800ea1:	68 2d 0e 80 00       	push   $0x800e2d
  800ea6:	e8 92 fb ff ff       	call   800a3d <vprintfmt>
  800eab:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  800eae:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800eb1:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800eb4:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  800eb7:	c9                   	leave  
  800eb8:	c3                   	ret    

00800eb9 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800eb9:	55                   	push   %ebp
  800eba:	89 e5                	mov    %esp,%ebp
  800ebc:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800ebf:	8d 45 10             	lea    0x10(%ebp),%eax
  800ec2:	83 c0 04             	add    $0x4,%eax
  800ec5:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  800ec8:	8b 45 10             	mov    0x10(%ebp),%eax
  800ecb:	ff 75 f4             	pushl  -0xc(%ebp)
  800ece:	50                   	push   %eax
  800ecf:	ff 75 0c             	pushl  0xc(%ebp)
  800ed2:	ff 75 08             	pushl  0x8(%ebp)
  800ed5:	e8 89 ff ff ff       	call   800e63 <vsnprintf>
  800eda:	83 c4 10             	add    $0x10,%esp
  800edd:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  800ee0:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800ee3:	c9                   	leave  
  800ee4:	c3                   	ret    

00800ee5 <strlen>:

#include <inc/string.h>

int
strlen(const char *s)
{
  800ee5:	55                   	push   %ebp
  800ee6:	89 e5                	mov    %esp,%ebp
  800ee8:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  800eeb:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800ef2:	eb 06                	jmp    800efa <strlen+0x15>
		n++;
  800ef4:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  800ef7:	ff 45 08             	incl   0x8(%ebp)
  800efa:	8b 45 08             	mov    0x8(%ebp),%eax
  800efd:	8a 00                	mov    (%eax),%al
  800eff:	84 c0                	test   %al,%al
  800f01:	75 f1                	jne    800ef4 <strlen+0xf>
		n++;
	return n;
  800f03:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800f06:	c9                   	leave  
  800f07:	c3                   	ret    

00800f08 <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  800f08:	55                   	push   %ebp
  800f09:	89 e5                	mov    %esp,%ebp
  800f0b:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800f0e:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800f15:	eb 09                	jmp    800f20 <strnlen+0x18>
		n++;
  800f17:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800f1a:	ff 45 08             	incl   0x8(%ebp)
  800f1d:	ff 4d 0c             	decl   0xc(%ebp)
  800f20:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800f24:	74 09                	je     800f2f <strnlen+0x27>
  800f26:	8b 45 08             	mov    0x8(%ebp),%eax
  800f29:	8a 00                	mov    (%eax),%al
  800f2b:	84 c0                	test   %al,%al
  800f2d:	75 e8                	jne    800f17 <strnlen+0xf>
		n++;
	return n;
  800f2f:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800f32:	c9                   	leave  
  800f33:	c3                   	ret    

00800f34 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800f34:	55                   	push   %ebp
  800f35:	89 e5                	mov    %esp,%ebp
  800f37:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  800f3a:	8b 45 08             	mov    0x8(%ebp),%eax
  800f3d:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  800f40:	90                   	nop
  800f41:	8b 45 08             	mov    0x8(%ebp),%eax
  800f44:	8d 50 01             	lea    0x1(%eax),%edx
  800f47:	89 55 08             	mov    %edx,0x8(%ebp)
  800f4a:	8b 55 0c             	mov    0xc(%ebp),%edx
  800f4d:	8d 4a 01             	lea    0x1(%edx),%ecx
  800f50:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800f53:	8a 12                	mov    (%edx),%dl
  800f55:	88 10                	mov    %dl,(%eax)
  800f57:	8a 00                	mov    (%eax),%al
  800f59:	84 c0                	test   %al,%al
  800f5b:	75 e4                	jne    800f41 <strcpy+0xd>
		/* do nothing */;
	return ret;
  800f5d:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800f60:	c9                   	leave  
  800f61:	c3                   	ret    

00800f62 <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  800f62:	55                   	push   %ebp
  800f63:	89 e5                	mov    %esp,%ebp
  800f65:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  800f68:	8b 45 08             	mov    0x8(%ebp),%eax
  800f6b:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  800f6e:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800f75:	eb 1f                	jmp    800f96 <strncpy+0x34>
		*dst++ = *src;
  800f77:	8b 45 08             	mov    0x8(%ebp),%eax
  800f7a:	8d 50 01             	lea    0x1(%eax),%edx
  800f7d:	89 55 08             	mov    %edx,0x8(%ebp)
  800f80:	8b 55 0c             	mov    0xc(%ebp),%edx
  800f83:	8a 12                	mov    (%edx),%dl
  800f85:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  800f87:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f8a:	8a 00                	mov    (%eax),%al
  800f8c:	84 c0                	test   %al,%al
  800f8e:	74 03                	je     800f93 <strncpy+0x31>
			src++;
  800f90:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800f93:	ff 45 fc             	incl   -0x4(%ebp)
  800f96:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800f99:	3b 45 10             	cmp    0x10(%ebp),%eax
  800f9c:	72 d9                	jb     800f77 <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  800f9e:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  800fa1:	c9                   	leave  
  800fa2:	c3                   	ret    

00800fa3 <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  800fa3:	55                   	push   %ebp
  800fa4:	89 e5                	mov    %esp,%ebp
  800fa6:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  800fa9:	8b 45 08             	mov    0x8(%ebp),%eax
  800fac:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  800faf:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800fb3:	74 30                	je     800fe5 <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  800fb5:	eb 16                	jmp    800fcd <strlcpy+0x2a>
			*dst++ = *src++;
  800fb7:	8b 45 08             	mov    0x8(%ebp),%eax
  800fba:	8d 50 01             	lea    0x1(%eax),%edx
  800fbd:	89 55 08             	mov    %edx,0x8(%ebp)
  800fc0:	8b 55 0c             	mov    0xc(%ebp),%edx
  800fc3:	8d 4a 01             	lea    0x1(%edx),%ecx
  800fc6:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800fc9:	8a 12                	mov    (%edx),%dl
  800fcb:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  800fcd:	ff 4d 10             	decl   0x10(%ebp)
  800fd0:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800fd4:	74 09                	je     800fdf <strlcpy+0x3c>
  800fd6:	8b 45 0c             	mov    0xc(%ebp),%eax
  800fd9:	8a 00                	mov    (%eax),%al
  800fdb:	84 c0                	test   %al,%al
  800fdd:	75 d8                	jne    800fb7 <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  800fdf:	8b 45 08             	mov    0x8(%ebp),%eax
  800fe2:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800fe5:	8b 55 08             	mov    0x8(%ebp),%edx
  800fe8:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800feb:	29 c2                	sub    %eax,%edx
  800fed:	89 d0                	mov    %edx,%eax
}
  800fef:	c9                   	leave  
  800ff0:	c3                   	ret    

00800ff1 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800ff1:	55                   	push   %ebp
  800ff2:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  800ff4:	eb 06                	jmp    800ffc <strcmp+0xb>
		p++, q++;
  800ff6:	ff 45 08             	incl   0x8(%ebp)
  800ff9:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  800ffc:	8b 45 08             	mov    0x8(%ebp),%eax
  800fff:	8a 00                	mov    (%eax),%al
  801001:	84 c0                	test   %al,%al
  801003:	74 0e                	je     801013 <strcmp+0x22>
  801005:	8b 45 08             	mov    0x8(%ebp),%eax
  801008:	8a 10                	mov    (%eax),%dl
  80100a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80100d:	8a 00                	mov    (%eax),%al
  80100f:	38 c2                	cmp    %al,%dl
  801011:	74 e3                	je     800ff6 <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  801013:	8b 45 08             	mov    0x8(%ebp),%eax
  801016:	8a 00                	mov    (%eax),%al
  801018:	0f b6 d0             	movzbl %al,%edx
  80101b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80101e:	8a 00                	mov    (%eax),%al
  801020:	0f b6 c0             	movzbl %al,%eax
  801023:	29 c2                	sub    %eax,%edx
  801025:	89 d0                	mov    %edx,%eax
}
  801027:	5d                   	pop    %ebp
  801028:	c3                   	ret    

00801029 <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  801029:	55                   	push   %ebp
  80102a:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  80102c:	eb 09                	jmp    801037 <strncmp+0xe>
		n--, p++, q++;
  80102e:	ff 4d 10             	decl   0x10(%ebp)
  801031:	ff 45 08             	incl   0x8(%ebp)
  801034:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  801037:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80103b:	74 17                	je     801054 <strncmp+0x2b>
  80103d:	8b 45 08             	mov    0x8(%ebp),%eax
  801040:	8a 00                	mov    (%eax),%al
  801042:	84 c0                	test   %al,%al
  801044:	74 0e                	je     801054 <strncmp+0x2b>
  801046:	8b 45 08             	mov    0x8(%ebp),%eax
  801049:	8a 10                	mov    (%eax),%dl
  80104b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80104e:	8a 00                	mov    (%eax),%al
  801050:	38 c2                	cmp    %al,%dl
  801052:	74 da                	je     80102e <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  801054:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801058:	75 07                	jne    801061 <strncmp+0x38>
		return 0;
  80105a:	b8 00 00 00 00       	mov    $0x0,%eax
  80105f:	eb 14                	jmp    801075 <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  801061:	8b 45 08             	mov    0x8(%ebp),%eax
  801064:	8a 00                	mov    (%eax),%al
  801066:	0f b6 d0             	movzbl %al,%edx
  801069:	8b 45 0c             	mov    0xc(%ebp),%eax
  80106c:	8a 00                	mov    (%eax),%al
  80106e:	0f b6 c0             	movzbl %al,%eax
  801071:	29 c2                	sub    %eax,%edx
  801073:	89 d0                	mov    %edx,%eax
}
  801075:	5d                   	pop    %ebp
  801076:	c3                   	ret    

00801077 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  801077:	55                   	push   %ebp
  801078:	89 e5                	mov    %esp,%ebp
  80107a:	83 ec 04             	sub    $0x4,%esp
  80107d:	8b 45 0c             	mov    0xc(%ebp),%eax
  801080:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  801083:	eb 12                	jmp    801097 <strchr+0x20>
		if (*s == c)
  801085:	8b 45 08             	mov    0x8(%ebp),%eax
  801088:	8a 00                	mov    (%eax),%al
  80108a:	3a 45 fc             	cmp    -0x4(%ebp),%al
  80108d:	75 05                	jne    801094 <strchr+0x1d>
			return (char *) s;
  80108f:	8b 45 08             	mov    0x8(%ebp),%eax
  801092:	eb 11                	jmp    8010a5 <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  801094:	ff 45 08             	incl   0x8(%ebp)
  801097:	8b 45 08             	mov    0x8(%ebp),%eax
  80109a:	8a 00                	mov    (%eax),%al
  80109c:	84 c0                	test   %al,%al
  80109e:	75 e5                	jne    801085 <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  8010a0:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8010a5:	c9                   	leave  
  8010a6:	c3                   	ret    

008010a7 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  8010a7:	55                   	push   %ebp
  8010a8:	89 e5                	mov    %esp,%ebp
  8010aa:	83 ec 04             	sub    $0x4,%esp
  8010ad:	8b 45 0c             	mov    0xc(%ebp),%eax
  8010b0:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  8010b3:	eb 0d                	jmp    8010c2 <strfind+0x1b>
		if (*s == c)
  8010b5:	8b 45 08             	mov    0x8(%ebp),%eax
  8010b8:	8a 00                	mov    (%eax),%al
  8010ba:	3a 45 fc             	cmp    -0x4(%ebp),%al
  8010bd:	74 0e                	je     8010cd <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  8010bf:	ff 45 08             	incl   0x8(%ebp)
  8010c2:	8b 45 08             	mov    0x8(%ebp),%eax
  8010c5:	8a 00                	mov    (%eax),%al
  8010c7:	84 c0                	test   %al,%al
  8010c9:	75 ea                	jne    8010b5 <strfind+0xe>
  8010cb:	eb 01                	jmp    8010ce <strfind+0x27>
		if (*s == c)
			break;
  8010cd:	90                   	nop
	return (char *) s;
  8010ce:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8010d1:	c9                   	leave  
  8010d2:	c3                   	ret    

008010d3 <memset>:


void *
memset(void *v, int c, uint32 n)
{
  8010d3:	55                   	push   %ebp
  8010d4:	89 e5                	mov    %esp,%ebp
  8010d6:	83 ec 10             	sub    $0x10,%esp
	char *p;
	int m;

	p = v;
  8010d9:	8b 45 08             	mov    0x8(%ebp),%eax
  8010dc:	89 45 fc             	mov    %eax,-0x4(%ebp)
	m = n;
  8010df:	8b 45 10             	mov    0x10(%ebp),%eax
  8010e2:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (--m >= 0)
  8010e5:	eb 0e                	jmp    8010f5 <memset+0x22>
		*p++ = c;
  8010e7:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8010ea:	8d 50 01             	lea    0x1(%eax),%edx
  8010ed:	89 55 fc             	mov    %edx,-0x4(%ebp)
  8010f0:	8b 55 0c             	mov    0xc(%ebp),%edx
  8010f3:	88 10                	mov    %dl,(%eax)
	char *p;
	int m;

	p = v;
	m = n;
	while (--m >= 0)
  8010f5:	ff 4d f8             	decl   -0x8(%ebp)
  8010f8:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
  8010fc:	79 e9                	jns    8010e7 <memset+0x14>
		*p++ = c;

	return v;
  8010fe:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801101:	c9                   	leave  
  801102:	c3                   	ret    

00801103 <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  801103:	55                   	push   %ebp
  801104:	89 e5                	mov    %esp,%ebp
  801106:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  801109:	8b 45 0c             	mov    0xc(%ebp),%eax
  80110c:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  80110f:	8b 45 08             	mov    0x8(%ebp),%eax
  801112:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (n-- > 0)
  801115:	eb 16                	jmp    80112d <memcpy+0x2a>
		*d++ = *s++;
  801117:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80111a:	8d 50 01             	lea    0x1(%eax),%edx
  80111d:	89 55 f8             	mov    %edx,-0x8(%ebp)
  801120:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801123:	8d 4a 01             	lea    0x1(%edx),%ecx
  801126:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  801129:	8a 12                	mov    (%edx),%dl
  80112b:	88 10                	mov    %dl,(%eax)
	const char *s;
	char *d;

	s = src;
	d = dst;
	while (n-- > 0)
  80112d:	8b 45 10             	mov    0x10(%ebp),%eax
  801130:	8d 50 ff             	lea    -0x1(%eax),%edx
  801133:	89 55 10             	mov    %edx,0x10(%ebp)
  801136:	85 c0                	test   %eax,%eax
  801138:	75 dd                	jne    801117 <memcpy+0x14>
		*d++ = *s++;

	return dst;
  80113a:	8b 45 08             	mov    0x8(%ebp),%eax
}
  80113d:	c9                   	leave  
  80113e:	c3                   	ret    

0080113f <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  80113f:	55                   	push   %ebp
  801140:	89 e5                	mov    %esp,%ebp
  801142:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  801145:	8b 45 0c             	mov    0xc(%ebp),%eax
  801148:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  80114b:	8b 45 08             	mov    0x8(%ebp),%eax
  80114e:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  801151:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801154:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  801157:	73 50                	jae    8011a9 <memmove+0x6a>
  801159:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80115c:	8b 45 10             	mov    0x10(%ebp),%eax
  80115f:	01 d0                	add    %edx,%eax
  801161:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  801164:	76 43                	jbe    8011a9 <memmove+0x6a>
		s += n;
  801166:	8b 45 10             	mov    0x10(%ebp),%eax
  801169:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  80116c:	8b 45 10             	mov    0x10(%ebp),%eax
  80116f:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  801172:	eb 10                	jmp    801184 <memmove+0x45>
			*--d = *--s;
  801174:	ff 4d f8             	decl   -0x8(%ebp)
  801177:	ff 4d fc             	decl   -0x4(%ebp)
  80117a:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80117d:	8a 10                	mov    (%eax),%dl
  80117f:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801182:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  801184:	8b 45 10             	mov    0x10(%ebp),%eax
  801187:	8d 50 ff             	lea    -0x1(%eax),%edx
  80118a:	89 55 10             	mov    %edx,0x10(%ebp)
  80118d:	85 c0                	test   %eax,%eax
  80118f:	75 e3                	jne    801174 <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  801191:	eb 23                	jmp    8011b6 <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  801193:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801196:	8d 50 01             	lea    0x1(%eax),%edx
  801199:	89 55 f8             	mov    %edx,-0x8(%ebp)
  80119c:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80119f:	8d 4a 01             	lea    0x1(%edx),%ecx
  8011a2:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  8011a5:	8a 12                	mov    (%edx),%dl
  8011a7:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  8011a9:	8b 45 10             	mov    0x10(%ebp),%eax
  8011ac:	8d 50 ff             	lea    -0x1(%eax),%edx
  8011af:	89 55 10             	mov    %edx,0x10(%ebp)
  8011b2:	85 c0                	test   %eax,%eax
  8011b4:	75 dd                	jne    801193 <memmove+0x54>
			*d++ = *s++;

	return dst;
  8011b6:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8011b9:	c9                   	leave  
  8011ba:	c3                   	ret    

008011bb <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  8011bb:	55                   	push   %ebp
  8011bc:	89 e5                	mov    %esp,%ebp
  8011be:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  8011c1:	8b 45 08             	mov    0x8(%ebp),%eax
  8011c4:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  8011c7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011ca:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  8011cd:	eb 2a                	jmp    8011f9 <memcmp+0x3e>
		if (*s1 != *s2)
  8011cf:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8011d2:	8a 10                	mov    (%eax),%dl
  8011d4:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8011d7:	8a 00                	mov    (%eax),%al
  8011d9:	38 c2                	cmp    %al,%dl
  8011db:	74 16                	je     8011f3 <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  8011dd:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8011e0:	8a 00                	mov    (%eax),%al
  8011e2:	0f b6 d0             	movzbl %al,%edx
  8011e5:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8011e8:	8a 00                	mov    (%eax),%al
  8011ea:	0f b6 c0             	movzbl %al,%eax
  8011ed:	29 c2                	sub    %eax,%edx
  8011ef:	89 d0                	mov    %edx,%eax
  8011f1:	eb 18                	jmp    80120b <memcmp+0x50>
		s1++, s2++;
  8011f3:	ff 45 fc             	incl   -0x4(%ebp)
  8011f6:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  8011f9:	8b 45 10             	mov    0x10(%ebp),%eax
  8011fc:	8d 50 ff             	lea    -0x1(%eax),%edx
  8011ff:	89 55 10             	mov    %edx,0x10(%ebp)
  801202:	85 c0                	test   %eax,%eax
  801204:	75 c9                	jne    8011cf <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  801206:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80120b:	c9                   	leave  
  80120c:	c3                   	ret    

0080120d <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  80120d:	55                   	push   %ebp
  80120e:	89 e5                	mov    %esp,%ebp
  801210:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  801213:	8b 55 08             	mov    0x8(%ebp),%edx
  801216:	8b 45 10             	mov    0x10(%ebp),%eax
  801219:	01 d0                	add    %edx,%eax
  80121b:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  80121e:	eb 15                	jmp    801235 <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  801220:	8b 45 08             	mov    0x8(%ebp),%eax
  801223:	8a 00                	mov    (%eax),%al
  801225:	0f b6 d0             	movzbl %al,%edx
  801228:	8b 45 0c             	mov    0xc(%ebp),%eax
  80122b:	0f b6 c0             	movzbl %al,%eax
  80122e:	39 c2                	cmp    %eax,%edx
  801230:	74 0d                	je     80123f <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  801232:	ff 45 08             	incl   0x8(%ebp)
  801235:	8b 45 08             	mov    0x8(%ebp),%eax
  801238:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  80123b:	72 e3                	jb     801220 <memfind+0x13>
  80123d:	eb 01                	jmp    801240 <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  80123f:	90                   	nop
	return (void *) s;
  801240:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801243:	c9                   	leave  
  801244:	c3                   	ret    

00801245 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  801245:	55                   	push   %ebp
  801246:	89 e5                	mov    %esp,%ebp
  801248:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  80124b:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  801252:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801259:	eb 03                	jmp    80125e <strtol+0x19>
		s++;
  80125b:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  80125e:	8b 45 08             	mov    0x8(%ebp),%eax
  801261:	8a 00                	mov    (%eax),%al
  801263:	3c 20                	cmp    $0x20,%al
  801265:	74 f4                	je     80125b <strtol+0x16>
  801267:	8b 45 08             	mov    0x8(%ebp),%eax
  80126a:	8a 00                	mov    (%eax),%al
  80126c:	3c 09                	cmp    $0x9,%al
  80126e:	74 eb                	je     80125b <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  801270:	8b 45 08             	mov    0x8(%ebp),%eax
  801273:	8a 00                	mov    (%eax),%al
  801275:	3c 2b                	cmp    $0x2b,%al
  801277:	75 05                	jne    80127e <strtol+0x39>
		s++;
  801279:	ff 45 08             	incl   0x8(%ebp)
  80127c:	eb 13                	jmp    801291 <strtol+0x4c>
	else if (*s == '-')
  80127e:	8b 45 08             	mov    0x8(%ebp),%eax
  801281:	8a 00                	mov    (%eax),%al
  801283:	3c 2d                	cmp    $0x2d,%al
  801285:	75 0a                	jne    801291 <strtol+0x4c>
		s++, neg = 1;
  801287:	ff 45 08             	incl   0x8(%ebp)
  80128a:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  801291:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801295:	74 06                	je     80129d <strtol+0x58>
  801297:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  80129b:	75 20                	jne    8012bd <strtol+0x78>
  80129d:	8b 45 08             	mov    0x8(%ebp),%eax
  8012a0:	8a 00                	mov    (%eax),%al
  8012a2:	3c 30                	cmp    $0x30,%al
  8012a4:	75 17                	jne    8012bd <strtol+0x78>
  8012a6:	8b 45 08             	mov    0x8(%ebp),%eax
  8012a9:	40                   	inc    %eax
  8012aa:	8a 00                	mov    (%eax),%al
  8012ac:	3c 78                	cmp    $0x78,%al
  8012ae:	75 0d                	jne    8012bd <strtol+0x78>
		s += 2, base = 16;
  8012b0:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  8012b4:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  8012bb:	eb 28                	jmp    8012e5 <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  8012bd:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8012c1:	75 15                	jne    8012d8 <strtol+0x93>
  8012c3:	8b 45 08             	mov    0x8(%ebp),%eax
  8012c6:	8a 00                	mov    (%eax),%al
  8012c8:	3c 30                	cmp    $0x30,%al
  8012ca:	75 0c                	jne    8012d8 <strtol+0x93>
		s++, base = 8;
  8012cc:	ff 45 08             	incl   0x8(%ebp)
  8012cf:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  8012d6:	eb 0d                	jmp    8012e5 <strtol+0xa0>
	else if (base == 0)
  8012d8:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8012dc:	75 07                	jne    8012e5 <strtol+0xa0>
		base = 10;
  8012de:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  8012e5:	8b 45 08             	mov    0x8(%ebp),%eax
  8012e8:	8a 00                	mov    (%eax),%al
  8012ea:	3c 2f                	cmp    $0x2f,%al
  8012ec:	7e 19                	jle    801307 <strtol+0xc2>
  8012ee:	8b 45 08             	mov    0x8(%ebp),%eax
  8012f1:	8a 00                	mov    (%eax),%al
  8012f3:	3c 39                	cmp    $0x39,%al
  8012f5:	7f 10                	jg     801307 <strtol+0xc2>
			dig = *s - '0';
  8012f7:	8b 45 08             	mov    0x8(%ebp),%eax
  8012fa:	8a 00                	mov    (%eax),%al
  8012fc:	0f be c0             	movsbl %al,%eax
  8012ff:	83 e8 30             	sub    $0x30,%eax
  801302:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801305:	eb 42                	jmp    801349 <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  801307:	8b 45 08             	mov    0x8(%ebp),%eax
  80130a:	8a 00                	mov    (%eax),%al
  80130c:	3c 60                	cmp    $0x60,%al
  80130e:	7e 19                	jle    801329 <strtol+0xe4>
  801310:	8b 45 08             	mov    0x8(%ebp),%eax
  801313:	8a 00                	mov    (%eax),%al
  801315:	3c 7a                	cmp    $0x7a,%al
  801317:	7f 10                	jg     801329 <strtol+0xe4>
			dig = *s - 'a' + 10;
  801319:	8b 45 08             	mov    0x8(%ebp),%eax
  80131c:	8a 00                	mov    (%eax),%al
  80131e:	0f be c0             	movsbl %al,%eax
  801321:	83 e8 57             	sub    $0x57,%eax
  801324:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801327:	eb 20                	jmp    801349 <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  801329:	8b 45 08             	mov    0x8(%ebp),%eax
  80132c:	8a 00                	mov    (%eax),%al
  80132e:	3c 40                	cmp    $0x40,%al
  801330:	7e 39                	jle    80136b <strtol+0x126>
  801332:	8b 45 08             	mov    0x8(%ebp),%eax
  801335:	8a 00                	mov    (%eax),%al
  801337:	3c 5a                	cmp    $0x5a,%al
  801339:	7f 30                	jg     80136b <strtol+0x126>
			dig = *s - 'A' + 10;
  80133b:	8b 45 08             	mov    0x8(%ebp),%eax
  80133e:	8a 00                	mov    (%eax),%al
  801340:	0f be c0             	movsbl %al,%eax
  801343:	83 e8 37             	sub    $0x37,%eax
  801346:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  801349:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80134c:	3b 45 10             	cmp    0x10(%ebp),%eax
  80134f:	7d 19                	jge    80136a <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  801351:	ff 45 08             	incl   0x8(%ebp)
  801354:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801357:	0f af 45 10          	imul   0x10(%ebp),%eax
  80135b:	89 c2                	mov    %eax,%edx
  80135d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801360:	01 d0                	add    %edx,%eax
  801362:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  801365:	e9 7b ff ff ff       	jmp    8012e5 <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  80136a:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  80136b:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80136f:	74 08                	je     801379 <strtol+0x134>
		*endptr = (char *) s;
  801371:	8b 45 0c             	mov    0xc(%ebp),%eax
  801374:	8b 55 08             	mov    0x8(%ebp),%edx
  801377:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  801379:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  80137d:	74 07                	je     801386 <strtol+0x141>
  80137f:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801382:	f7 d8                	neg    %eax
  801384:	eb 03                	jmp    801389 <strtol+0x144>
  801386:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  801389:	c9                   	leave  
  80138a:	c3                   	ret    

0080138b <ltostr>:

void
ltostr(long value, char *str)
{
  80138b:	55                   	push   %ebp
  80138c:	89 e5                	mov    %esp,%ebp
  80138e:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  801391:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  801398:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  80139f:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8013a3:	79 13                	jns    8013b8 <ltostr+0x2d>
	{
		neg = 1;
  8013a5:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  8013ac:	8b 45 0c             	mov    0xc(%ebp),%eax
  8013af:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  8013b2:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  8013b5:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  8013b8:	8b 45 08             	mov    0x8(%ebp),%eax
  8013bb:	b9 0a 00 00 00       	mov    $0xa,%ecx
  8013c0:	99                   	cltd   
  8013c1:	f7 f9                	idiv   %ecx
  8013c3:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  8013c6:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8013c9:	8d 50 01             	lea    0x1(%eax),%edx
  8013cc:	89 55 f8             	mov    %edx,-0x8(%ebp)
  8013cf:	89 c2                	mov    %eax,%edx
  8013d1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8013d4:	01 d0                	add    %edx,%eax
  8013d6:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8013d9:	83 c2 30             	add    $0x30,%edx
  8013dc:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  8013de:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8013e1:	b8 67 66 66 66       	mov    $0x66666667,%eax
  8013e6:	f7 e9                	imul   %ecx
  8013e8:	c1 fa 02             	sar    $0x2,%edx
  8013eb:	89 c8                	mov    %ecx,%eax
  8013ed:	c1 f8 1f             	sar    $0x1f,%eax
  8013f0:	29 c2                	sub    %eax,%edx
  8013f2:	89 d0                	mov    %edx,%eax
  8013f4:	89 45 08             	mov    %eax,0x8(%ebp)
	} while (value % 10 != 0);
  8013f7:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8013fa:	b8 67 66 66 66       	mov    $0x66666667,%eax
  8013ff:	f7 e9                	imul   %ecx
  801401:	c1 fa 02             	sar    $0x2,%edx
  801404:	89 c8                	mov    %ecx,%eax
  801406:	c1 f8 1f             	sar    $0x1f,%eax
  801409:	29 c2                	sub    %eax,%edx
  80140b:	89 d0                	mov    %edx,%eax
  80140d:	c1 e0 02             	shl    $0x2,%eax
  801410:	01 d0                	add    %edx,%eax
  801412:	01 c0                	add    %eax,%eax
  801414:	29 c1                	sub    %eax,%ecx
  801416:	89 ca                	mov    %ecx,%edx
  801418:	85 d2                	test   %edx,%edx
  80141a:	75 9c                	jne    8013b8 <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  80141c:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  801423:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801426:	48                   	dec    %eax
  801427:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  80142a:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  80142e:	74 3d                	je     80146d <ltostr+0xe2>
		start = 1 ;
  801430:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  801437:	eb 34                	jmp    80146d <ltostr+0xe2>
	{
		char tmp = str[start] ;
  801439:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80143c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80143f:	01 d0                	add    %edx,%eax
  801441:	8a 00                	mov    (%eax),%al
  801443:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  801446:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801449:	8b 45 0c             	mov    0xc(%ebp),%eax
  80144c:	01 c2                	add    %eax,%edx
  80144e:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  801451:	8b 45 0c             	mov    0xc(%ebp),%eax
  801454:	01 c8                	add    %ecx,%eax
  801456:	8a 00                	mov    (%eax),%al
  801458:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  80145a:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80145d:	8b 45 0c             	mov    0xc(%ebp),%eax
  801460:	01 c2                	add    %eax,%edx
  801462:	8a 45 eb             	mov    -0x15(%ebp),%al
  801465:	88 02                	mov    %al,(%edx)
		start++ ;
  801467:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  80146a:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  80146d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801470:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801473:	7c c4                	jl     801439 <ltostr+0xae>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  801475:	8b 55 f8             	mov    -0x8(%ebp),%edx
  801478:	8b 45 0c             	mov    0xc(%ebp),%eax
  80147b:	01 d0                	add    %edx,%eax
  80147d:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  801480:	90                   	nop
  801481:	c9                   	leave  
  801482:	c3                   	ret    

00801483 <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  801483:	55                   	push   %ebp
  801484:	89 e5                	mov    %esp,%ebp
  801486:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  801489:	ff 75 08             	pushl  0x8(%ebp)
  80148c:	e8 54 fa ff ff       	call   800ee5 <strlen>
  801491:	83 c4 04             	add    $0x4,%esp
  801494:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  801497:	ff 75 0c             	pushl  0xc(%ebp)
  80149a:	e8 46 fa ff ff       	call   800ee5 <strlen>
  80149f:	83 c4 04             	add    $0x4,%esp
  8014a2:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  8014a5:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  8014ac:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8014b3:	eb 17                	jmp    8014cc <strcconcat+0x49>
		final[s] = str1[s] ;
  8014b5:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8014b8:	8b 45 10             	mov    0x10(%ebp),%eax
  8014bb:	01 c2                	add    %eax,%edx
  8014bd:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  8014c0:	8b 45 08             	mov    0x8(%ebp),%eax
  8014c3:	01 c8                	add    %ecx,%eax
  8014c5:	8a 00                	mov    (%eax),%al
  8014c7:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  8014c9:	ff 45 fc             	incl   -0x4(%ebp)
  8014cc:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8014cf:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  8014d2:	7c e1                	jl     8014b5 <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  8014d4:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  8014db:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  8014e2:	eb 1f                	jmp    801503 <strcconcat+0x80>
		final[s++] = str2[i] ;
  8014e4:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8014e7:	8d 50 01             	lea    0x1(%eax),%edx
  8014ea:	89 55 fc             	mov    %edx,-0x4(%ebp)
  8014ed:	89 c2                	mov    %eax,%edx
  8014ef:	8b 45 10             	mov    0x10(%ebp),%eax
  8014f2:	01 c2                	add    %eax,%edx
  8014f4:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  8014f7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8014fa:	01 c8                	add    %ecx,%eax
  8014fc:	8a 00                	mov    (%eax),%al
  8014fe:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  801500:	ff 45 f8             	incl   -0x8(%ebp)
  801503:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801506:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801509:	7c d9                	jl     8014e4 <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  80150b:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80150e:	8b 45 10             	mov    0x10(%ebp),%eax
  801511:	01 d0                	add    %edx,%eax
  801513:	c6 00 00             	movb   $0x0,(%eax)
}
  801516:	90                   	nop
  801517:	c9                   	leave  
  801518:	c3                   	ret    

00801519 <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  801519:	55                   	push   %ebp
  80151a:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  80151c:	8b 45 14             	mov    0x14(%ebp),%eax
  80151f:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  801525:	8b 45 14             	mov    0x14(%ebp),%eax
  801528:	8b 00                	mov    (%eax),%eax
  80152a:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801531:	8b 45 10             	mov    0x10(%ebp),%eax
  801534:	01 d0                	add    %edx,%eax
  801536:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  80153c:	eb 0c                	jmp    80154a <strsplit+0x31>
			*string++ = 0;
  80153e:	8b 45 08             	mov    0x8(%ebp),%eax
  801541:	8d 50 01             	lea    0x1(%eax),%edx
  801544:	89 55 08             	mov    %edx,0x8(%ebp)
  801547:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  80154a:	8b 45 08             	mov    0x8(%ebp),%eax
  80154d:	8a 00                	mov    (%eax),%al
  80154f:	84 c0                	test   %al,%al
  801551:	74 18                	je     80156b <strsplit+0x52>
  801553:	8b 45 08             	mov    0x8(%ebp),%eax
  801556:	8a 00                	mov    (%eax),%al
  801558:	0f be c0             	movsbl %al,%eax
  80155b:	50                   	push   %eax
  80155c:	ff 75 0c             	pushl  0xc(%ebp)
  80155f:	e8 13 fb ff ff       	call   801077 <strchr>
  801564:	83 c4 08             	add    $0x8,%esp
  801567:	85 c0                	test   %eax,%eax
  801569:	75 d3                	jne    80153e <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  80156b:	8b 45 08             	mov    0x8(%ebp),%eax
  80156e:	8a 00                	mov    (%eax),%al
  801570:	84 c0                	test   %al,%al
  801572:	74 5a                	je     8015ce <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  801574:	8b 45 14             	mov    0x14(%ebp),%eax
  801577:	8b 00                	mov    (%eax),%eax
  801579:	83 f8 0f             	cmp    $0xf,%eax
  80157c:	75 07                	jne    801585 <strsplit+0x6c>
		{
			return 0;
  80157e:	b8 00 00 00 00       	mov    $0x0,%eax
  801583:	eb 66                	jmp    8015eb <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  801585:	8b 45 14             	mov    0x14(%ebp),%eax
  801588:	8b 00                	mov    (%eax),%eax
  80158a:	8d 48 01             	lea    0x1(%eax),%ecx
  80158d:	8b 55 14             	mov    0x14(%ebp),%edx
  801590:	89 0a                	mov    %ecx,(%edx)
  801592:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801599:	8b 45 10             	mov    0x10(%ebp),%eax
  80159c:	01 c2                	add    %eax,%edx
  80159e:	8b 45 08             	mov    0x8(%ebp),%eax
  8015a1:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  8015a3:	eb 03                	jmp    8015a8 <strsplit+0x8f>
			string++;
  8015a5:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  8015a8:	8b 45 08             	mov    0x8(%ebp),%eax
  8015ab:	8a 00                	mov    (%eax),%al
  8015ad:	84 c0                	test   %al,%al
  8015af:	74 8b                	je     80153c <strsplit+0x23>
  8015b1:	8b 45 08             	mov    0x8(%ebp),%eax
  8015b4:	8a 00                	mov    (%eax),%al
  8015b6:	0f be c0             	movsbl %al,%eax
  8015b9:	50                   	push   %eax
  8015ba:	ff 75 0c             	pushl  0xc(%ebp)
  8015bd:	e8 b5 fa ff ff       	call   801077 <strchr>
  8015c2:	83 c4 08             	add    $0x8,%esp
  8015c5:	85 c0                	test   %eax,%eax
  8015c7:	74 dc                	je     8015a5 <strsplit+0x8c>
			string++;
	}
  8015c9:	e9 6e ff ff ff       	jmp    80153c <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  8015ce:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  8015cf:	8b 45 14             	mov    0x14(%ebp),%eax
  8015d2:	8b 00                	mov    (%eax),%eax
  8015d4:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8015db:	8b 45 10             	mov    0x10(%ebp),%eax
  8015de:	01 d0                	add    %edx,%eax
  8015e0:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  8015e6:	b8 01 00 00 00       	mov    $0x1,%eax
}
  8015eb:	c9                   	leave  
  8015ec:	c3                   	ret    

008015ed <InitializeUHeap>:
//============================== GIVEN FUNCTIONS ===================================//
//==================================================================================//

int FirstTimeFlag = 1;
void InitializeUHeap()
{
  8015ed:	55                   	push   %ebp
  8015ee:	89 e5                	mov    %esp,%ebp
  8015f0:	83 ec 08             	sub    $0x8,%esp
	if(FirstTimeFlag)
  8015f3:	a1 04 50 80 00       	mov    0x805004,%eax
  8015f8:	85 c0                	test   %eax,%eax
  8015fa:	74 1f                	je     80161b <InitializeUHeap+0x2e>
	{
		initialize_dyn_block_system();
  8015fc:	e8 1d 00 00 00       	call   80161e <initialize_dyn_block_system>
		cprintf("DYNAMIC BLOCK SYSTEM IS INITIALIZED\n");
  801601:	83 ec 0c             	sub    $0xc,%esp
  801604:	68 b0 3e 80 00       	push   $0x803eb0
  801609:	e8 55 f2 ff ff       	call   800863 <cprintf>
  80160e:	83 c4 10             	add    $0x10,%esp
#if UHP_USE_BUDDY
		initialize_buddy();
		cprintf("BUDDY SYSTEM IS INITIALIZED\n");
#endif
		FirstTimeFlag = 0;
  801611:	c7 05 04 50 80 00 00 	movl   $0x0,0x805004
  801618:	00 00 00 
	}
}
  80161b:	90                   	nop
  80161c:	c9                   	leave  
  80161d:	c3                   	ret    

0080161e <initialize_dyn_block_system>:

//=================================
// [1] INITIALIZE DYNAMIC ALLOCATOR:
//=================================
void initialize_dyn_block_system()
{
  80161e:	55                   	push   %ebp
  80161f:	89 e5                	mov    %esp,%ebp
  801621:	83 ec 28             	sub    $0x28,%esp
	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] initialize_dyn_block_system
	// your code is here, remove the panic and write your code
	//panic("initialize_dyn_block_system() is not implemented yet...!!");

	LIST_INIT(&AllocMemBlocksList);
  801624:	c7 05 40 50 80 00 00 	movl   $0x0,0x805040
  80162b:	00 00 00 
  80162e:	c7 05 44 50 80 00 00 	movl   $0x0,0x805044
  801635:	00 00 00 
  801638:	c7 05 4c 50 80 00 00 	movl   $0x0,0x80504c
  80163f:	00 00 00 
	LIST_INIT(&FreeMemBlocksList);
  801642:	c7 05 38 51 80 00 00 	movl   $0x0,0x805138
  801649:	00 00 00 
  80164c:	c7 05 3c 51 80 00 00 	movl   $0x0,0x80513c
  801653:	00 00 00 
  801656:	c7 05 44 51 80 00 00 	movl   $0x0,0x805144
  80165d:	00 00 00 
	MAX_MEM_BLOCK_CNT = NUM_OF_UHEAP_PAGES;
  801660:	c7 05 20 51 80 00 00 	movl   $0x20000,0x805120
  801667:	00 02 00 
	MemBlockNodes = (void*)USER_DYN_BLKS_ARRAY;
  80166a:	c7 45 f4 00 00 e0 7f 	movl   $0x7fe00000,-0xc(%ebp)
  801671:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801674:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801679:	2d 00 10 00 00       	sub    $0x1000,%eax
  80167e:	a3 50 50 80 00       	mov    %eax,0x805050
	int size_of_block = sizeof(struct MemBlock);
  801683:	c7 45 f0 10 00 00 00 	movl   $0x10,-0x10(%ebp)
	int size_all_struct = size_of_block*MAX_MEM_BLOCK_CNT;
  80168a:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80168d:	a1 20 51 80 00       	mov    0x805120,%eax
  801692:	0f af c2             	imul   %edx,%eax
  801695:	89 45 ec             	mov    %eax,-0x14(%ebp)
	size_all_struct = ROUNDUP(size_all_struct, PAGE_SIZE);
  801698:	c7 45 e8 00 10 00 00 	movl   $0x1000,-0x18(%ebp)
  80169f:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8016a2:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8016a5:	01 d0                	add    %edx,%eax
  8016a7:	48                   	dec    %eax
  8016a8:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8016ab:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8016ae:	ba 00 00 00 00       	mov    $0x0,%edx
  8016b3:	f7 75 e8             	divl   -0x18(%ebp)
  8016b6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8016b9:	29 d0                	sub    %edx,%eax
  8016bb:	89 45 ec             	mov    %eax,-0x14(%ebp)
	sys_allocate_chunk(USER_DYN_BLKS_ARRAY, size_all_struct,PERM_USER| PERM_WRITEABLE);
  8016be:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8016c1:	c7 45 e0 00 00 e0 7f 	movl   $0x7fe00000,-0x20(%ebp)
  8016c8:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8016cb:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
  8016d1:	81 ea 00 10 00 00    	sub    $0x1000,%edx
  8016d7:	83 ec 04             	sub    $0x4,%esp
  8016da:	6a 06                	push   $0x6
  8016dc:	50                   	push   %eax
  8016dd:	52                   	push   %edx
  8016de:	e8 a1 05 00 00       	call   801c84 <sys_allocate_chunk>
  8016e3:	83 c4 10             	add    $0x10,%esp
	initialize_MemBlocksList(MAX_MEM_BLOCK_CNT);
  8016e6:	a1 20 51 80 00       	mov    0x805120,%eax
  8016eb:	83 ec 0c             	sub    $0xc,%esp
  8016ee:	50                   	push   %eax
  8016ef:	e8 16 0c 00 00       	call   80230a <initialize_MemBlocksList>
  8016f4:	83 c4 10             	add    $0x10,%esp
	struct MemBlock* ourBlock =LIST_LAST(&AvailableMemBlocksList);
  8016f7:	a1 4c 51 80 00       	mov    0x80514c,%eax
  8016fc:	89 45 dc             	mov    %eax,-0x24(%ebp)
	LIST_REMOVE(&AvailableMemBlocksList,ourBlock);
  8016ff:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  801703:	75 14                	jne    801719 <initialize_dyn_block_system+0xfb>
  801705:	83 ec 04             	sub    $0x4,%esp
  801708:	68 d5 3e 80 00       	push   $0x803ed5
  80170d:	6a 2d                	push   $0x2d
  80170f:	68 f3 3e 80 00       	push   $0x803ef3
  801714:	e8 96 ee ff ff       	call   8005af <_panic>
  801719:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80171c:	8b 00                	mov    (%eax),%eax
  80171e:	85 c0                	test   %eax,%eax
  801720:	74 10                	je     801732 <initialize_dyn_block_system+0x114>
  801722:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801725:	8b 00                	mov    (%eax),%eax
  801727:	8b 55 dc             	mov    -0x24(%ebp),%edx
  80172a:	8b 52 04             	mov    0x4(%edx),%edx
  80172d:	89 50 04             	mov    %edx,0x4(%eax)
  801730:	eb 0b                	jmp    80173d <initialize_dyn_block_system+0x11f>
  801732:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801735:	8b 40 04             	mov    0x4(%eax),%eax
  801738:	a3 4c 51 80 00       	mov    %eax,0x80514c
  80173d:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801740:	8b 40 04             	mov    0x4(%eax),%eax
  801743:	85 c0                	test   %eax,%eax
  801745:	74 0f                	je     801756 <initialize_dyn_block_system+0x138>
  801747:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80174a:	8b 40 04             	mov    0x4(%eax),%eax
  80174d:	8b 55 dc             	mov    -0x24(%ebp),%edx
  801750:	8b 12                	mov    (%edx),%edx
  801752:	89 10                	mov    %edx,(%eax)
  801754:	eb 0a                	jmp    801760 <initialize_dyn_block_system+0x142>
  801756:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801759:	8b 00                	mov    (%eax),%eax
  80175b:	a3 48 51 80 00       	mov    %eax,0x805148
  801760:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801763:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  801769:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80176c:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  801773:	a1 54 51 80 00       	mov    0x805154,%eax
  801778:	48                   	dec    %eax
  801779:	a3 54 51 80 00       	mov    %eax,0x805154
	ourBlock->size = USER_HEAP_MAX-USER_HEAP_START;
  80177e:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801781:	c7 40 0c 00 00 00 20 	movl   $0x20000000,0xc(%eax)
	ourBlock->sva=USER_HEAP_START;
  801788:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80178b:	c7 40 08 00 00 00 80 	movl   $0x80000000,0x8(%eax)
	LIST_INSERT_TAIL(&FreeMemBlocksList, ourBlock);
  801792:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  801796:	75 14                	jne    8017ac <initialize_dyn_block_system+0x18e>
  801798:	83 ec 04             	sub    $0x4,%esp
  80179b:	68 00 3f 80 00       	push   $0x803f00
  8017a0:	6a 30                	push   $0x30
  8017a2:	68 f3 3e 80 00       	push   $0x803ef3
  8017a7:	e8 03 ee ff ff       	call   8005af <_panic>
  8017ac:	8b 15 3c 51 80 00    	mov    0x80513c,%edx
  8017b2:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8017b5:	89 50 04             	mov    %edx,0x4(%eax)
  8017b8:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8017bb:	8b 40 04             	mov    0x4(%eax),%eax
  8017be:	85 c0                	test   %eax,%eax
  8017c0:	74 0c                	je     8017ce <initialize_dyn_block_system+0x1b0>
  8017c2:	a1 3c 51 80 00       	mov    0x80513c,%eax
  8017c7:	8b 55 dc             	mov    -0x24(%ebp),%edx
  8017ca:	89 10                	mov    %edx,(%eax)
  8017cc:	eb 08                	jmp    8017d6 <initialize_dyn_block_system+0x1b8>
  8017ce:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8017d1:	a3 38 51 80 00       	mov    %eax,0x805138
  8017d6:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8017d9:	a3 3c 51 80 00       	mov    %eax,0x80513c
  8017de:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8017e1:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8017e7:	a1 44 51 80 00       	mov    0x805144,%eax
  8017ec:	40                   	inc    %eax
  8017ed:	a3 44 51 80 00       	mov    %eax,0x805144
	//[1] Initialize two lists (AllocMemBlocksList & FreeMemBlocksList) [Hint: use LIST_INIT()]
	//[2] Dynamically allocate the array of MemBlockNodes at VA USER_DYN_BLKS_ARRAY
	//	  (remember to set MAX_MEM_BLOCK_CNT with the chosen size of the array)
	//[3] Initialize AvailableMemBlocksList by filling it with the MemBlockNodes
	//[4] Insert a new MemBlock with the heap size into the FreeMemBlocksList
}
  8017f2:	90                   	nop
  8017f3:	c9                   	leave  
  8017f4:	c3                   	ret    

008017f5 <malloc>:
//=================================
// [2] ALLOCATE SPACE IN USER HEAP:
//=================================

void* malloc(uint32 size)
{
  8017f5:	55                   	push   %ebp
  8017f6:	89 e5                	mov    %esp,%ebp
  8017f8:	83 ec 18             	sub    $0x18,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  8017fb:	e8 ed fd ff ff       	call   8015ed <InitializeUHeap>
	if (size == 0) return NULL ;
  801800:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801804:	75 07                	jne    80180d <malloc+0x18>
  801806:	b8 00 00 00 00       	mov    $0x0,%eax
  80180b:	eb 67                	jmp    801874 <malloc+0x7f>

	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] malloc
	// your code is here, remove the panic and write your code
	//panic("malloc() is not implemented yet...!!");

	size = ROUNDUP(size, PAGE_SIZE);
  80180d:	c7 45 f4 00 10 00 00 	movl   $0x1000,-0xc(%ebp)
  801814:	8b 55 08             	mov    0x8(%ebp),%edx
  801817:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80181a:	01 d0                	add    %edx,%eax
  80181c:	48                   	dec    %eax
  80181d:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801820:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801823:	ba 00 00 00 00       	mov    $0x0,%edx
  801828:	f7 75 f4             	divl   -0xc(%ebp)
  80182b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80182e:	29 d0                	sub    %edx,%eax
  801830:	89 45 08             	mov    %eax,0x8(%ebp)
	if(sys_isUHeapPlacementStrategyFIRSTFIT())
  801833:	e8 1a 08 00 00       	call   802052 <sys_isUHeapPlacementStrategyFIRSTFIT>
  801838:	85 c0                	test   %eax,%eax
  80183a:	74 33                	je     80186f <malloc+0x7a>
	{
		struct MemBlock * myBlock = alloc_block_FF(size);
  80183c:	83 ec 0c             	sub    $0xc,%esp
  80183f:	ff 75 08             	pushl  0x8(%ebp)
  801842:	e8 0c 0e 00 00       	call   802653 <alloc_block_FF>
  801847:	83 c4 10             	add    $0x10,%esp
  80184a:	89 45 ec             	mov    %eax,-0x14(%ebp)
		if(myBlock != NULL)
  80184d:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  801851:	74 1c                	je     80186f <malloc+0x7a>
		{
			insert_sorted_allocList(myBlock);
  801853:	83 ec 0c             	sub    $0xc,%esp
  801856:	ff 75 ec             	pushl  -0x14(%ebp)
  801859:	e8 07 0c 00 00       	call   802465 <insert_sorted_allocList>
  80185e:	83 c4 10             	add    $0x10,%esp
			uint32 ptr = myBlock->sva;
  801861:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801864:	8b 40 08             	mov    0x8(%eax),%eax
  801867:	89 45 e8             	mov    %eax,-0x18(%ebp)
			return (void *)ptr;
  80186a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80186d:	eb 05                	jmp    801874 <malloc+0x7f>
		}
	}
	return NULL;
  80186f:	b8 00 00 00 00       	mov    $0x0,%eax
	//		to the required allocation size (space should be on 4 KB BOUNDARY)
	//	2) if no suitable space found, return NULL
	// 	3) Return pointer containing the virtual address of allocated space,
	//
	//Use sys_isUHeapPlacementStrategyFIRSTFIT()... to check the current strategy
}
  801874:	c9                   	leave  
  801875:	c3                   	ret    

00801876 <free>:
//	We can use sys_free_user_mem(uint32 virtual_address, uint32 size); which
//		switches to the kernel mode, calls free_user_mem() in
//		"kern/mem/chunk_operations.c", then switch back to the user mode here
//	the free_user_mem function is empty, make sure to implement it.
void free(void* virtual_address)
{
  801876:	55                   	push   %ebp
  801877:	89 e5                	mov    %esp,%ebp
  801879:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] free
	// your code is here, remove the panic and write your code
	//panic("free() is not implemented yet...!!");

	uint32 virtualAddress = (uint32 )(virtual_address);
  80187c:	8b 45 08             	mov    0x8(%ebp),%eax
  80187f:	89 45 f4             	mov    %eax,-0xc(%ebp)
//	virtualAddress = ROUNDDOWN(virtualAddress, PAGE_SIZE);
	struct MemBlock * myBlock = find_block(&AllocMemBlocksList, virtualAddress);
  801882:	83 ec 08             	sub    $0x8,%esp
  801885:	ff 75 f4             	pushl  -0xc(%ebp)
  801888:	68 40 50 80 00       	push   $0x805040
  80188d:	e8 5b 0b 00 00       	call   8023ed <find_block>
  801892:	83 c4 10             	add    $0x10,%esp
  801895:	89 45 f0             	mov    %eax,-0x10(%ebp)
//	cprintf ("ptr sva at free user side = %x \n", myBlock->sva);
	sys_free_user_mem(virtualAddress, myBlock->size);
  801898:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80189b:	8b 40 0c             	mov    0xc(%eax),%eax
  80189e:	83 ec 08             	sub    $0x8,%esp
  8018a1:	50                   	push   %eax
  8018a2:	ff 75 f4             	pushl  -0xc(%ebp)
  8018a5:	e8 a2 03 00 00       	call   801c4c <sys_free_user_mem>
  8018aa:	83 c4 10             	add    $0x10,%esp
	LIST_REMOVE(&AllocMemBlocksList, myBlock);
  8018ad:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8018b1:	75 14                	jne    8018c7 <free+0x51>
  8018b3:	83 ec 04             	sub    $0x4,%esp
  8018b6:	68 d5 3e 80 00       	push   $0x803ed5
  8018bb:	6a 76                	push   $0x76
  8018bd:	68 f3 3e 80 00       	push   $0x803ef3
  8018c2:	e8 e8 ec ff ff       	call   8005af <_panic>
  8018c7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8018ca:	8b 00                	mov    (%eax),%eax
  8018cc:	85 c0                	test   %eax,%eax
  8018ce:	74 10                	je     8018e0 <free+0x6a>
  8018d0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8018d3:	8b 00                	mov    (%eax),%eax
  8018d5:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8018d8:	8b 52 04             	mov    0x4(%edx),%edx
  8018db:	89 50 04             	mov    %edx,0x4(%eax)
  8018de:	eb 0b                	jmp    8018eb <free+0x75>
  8018e0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8018e3:	8b 40 04             	mov    0x4(%eax),%eax
  8018e6:	a3 44 50 80 00       	mov    %eax,0x805044
  8018eb:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8018ee:	8b 40 04             	mov    0x4(%eax),%eax
  8018f1:	85 c0                	test   %eax,%eax
  8018f3:	74 0f                	je     801904 <free+0x8e>
  8018f5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8018f8:	8b 40 04             	mov    0x4(%eax),%eax
  8018fb:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8018fe:	8b 12                	mov    (%edx),%edx
  801900:	89 10                	mov    %edx,(%eax)
  801902:	eb 0a                	jmp    80190e <free+0x98>
  801904:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801907:	8b 00                	mov    (%eax),%eax
  801909:	a3 40 50 80 00       	mov    %eax,0x805040
  80190e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801911:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  801917:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80191a:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  801921:	a1 4c 50 80 00       	mov    0x80504c,%eax
  801926:	48                   	dec    %eax
  801927:	a3 4c 50 80 00       	mov    %eax,0x80504c
	insert_sorted_with_merge_freeList(myBlock);
  80192c:	83 ec 0c             	sub    $0xc,%esp
  80192f:	ff 75 f0             	pushl  -0x10(%ebp)
  801932:	e8 0b 14 00 00       	call   802d42 <insert_sorted_with_merge_freeList>
  801937:	83 c4 10             	add    $0x10,%esp

	//you should get the size of the given allocation using its address
	//you need to call sys_free_user_mem()
	//refer to the project presentation and documentation for details
}
  80193a:	90                   	nop
  80193b:	c9                   	leave  
  80193c:	c3                   	ret    

0080193d <smalloc>:

//=================================
// [4] ALLOCATE SHARED VARIABLE:
//=================================
void* smalloc(char *sharedVarName, uint32 size, uint8 isWritable)
{
  80193d:	55                   	push   %ebp
  80193e:	89 e5                	mov    %esp,%ebp
  801940:	83 ec 28             	sub    $0x28,%esp
  801943:	8b 45 10             	mov    0x10(%ebp),%eax
  801946:	88 45 e4             	mov    %al,-0x1c(%ebp)
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801949:	e8 9f fc ff ff       	call   8015ed <InitializeUHeap>
	if (size == 0) return NULL ;
  80194e:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801952:	75 0a                	jne    80195e <smalloc+0x21>
  801954:	b8 00 00 00 00       	mov    $0x0,%eax
  801959:	e9 8d 00 00 00       	jmp    8019eb <smalloc+0xae>

	//This function should find the space of the required range
	// * ON 4KB BOUNDARY **** //
	//Use sys_isUHeapPlacementStrategyFIRSTFIT() to check the current strategy

	size = ROUNDUP(size, PAGE_SIZE);
  80195e:	c7 45 f4 00 10 00 00 	movl   $0x1000,-0xc(%ebp)
  801965:	8b 55 0c             	mov    0xc(%ebp),%edx
  801968:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80196b:	01 d0                	add    %edx,%eax
  80196d:	48                   	dec    %eax
  80196e:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801971:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801974:	ba 00 00 00 00       	mov    $0x0,%edx
  801979:	f7 75 f4             	divl   -0xc(%ebp)
  80197c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80197f:	29 d0                	sub    %edx,%eax
  801981:	89 45 0c             	mov    %eax,0xc(%ebp)
		if(sys_isUHeapPlacementStrategyFIRSTFIT())
  801984:	e8 c9 06 00 00       	call   802052 <sys_isUHeapPlacementStrategyFIRSTFIT>
  801989:	85 c0                	test   %eax,%eax
  80198b:	74 59                	je     8019e6 <smalloc+0xa9>
		{
			struct MemBlock * v1=NULL;
  80198d:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
			v1= alloc_block_FF(size);
  801994:	83 ec 0c             	sub    $0xc,%esp
  801997:	ff 75 0c             	pushl  0xc(%ebp)
  80199a:	e8 b4 0c 00 00       	call   802653 <alloc_block_FF>
  80199f:	83 c4 10             	add    $0x10,%esp
  8019a2:	89 45 ec             	mov    %eax,-0x14(%ebp)
			if(v1==NULL)
  8019a5:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8019a9:	75 07                	jne    8019b2 <smalloc+0x75>
			{
				return NULL;
  8019ab:	b8 00 00 00 00       	mov    $0x0,%eax
  8019b0:	eb 39                	jmp    8019eb <smalloc+0xae>
			}
			else
			{
				int ret=sys_createSharedObject(sharedVarName,  size,  isWritable,(void*)v1->sva);
  8019b2:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8019b5:	8b 40 08             	mov    0x8(%eax),%eax
  8019b8:	89 c2                	mov    %eax,%edx
  8019ba:	0f b6 45 e4          	movzbl -0x1c(%ebp),%eax
  8019be:	52                   	push   %edx
  8019bf:	50                   	push   %eax
  8019c0:	ff 75 0c             	pushl  0xc(%ebp)
  8019c3:	ff 75 08             	pushl  0x8(%ebp)
  8019c6:	e8 0c 04 00 00       	call   801dd7 <sys_createSharedObject>
  8019cb:	83 c4 10             	add    $0x10,%esp
  8019ce:	89 45 e8             	mov    %eax,-0x18(%ebp)
				if(ret>=0)
  8019d1:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  8019d5:	78 08                	js     8019df <smalloc+0xa2>
				{
					return (void*)v1->sva;
  8019d7:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8019da:	8b 40 08             	mov    0x8(%eax),%eax
  8019dd:	eb 0c                	jmp    8019eb <smalloc+0xae>
				}
				else
				{
					return NULL;
  8019df:	b8 00 00 00 00       	mov    $0x0,%eax
  8019e4:	eb 05                	jmp    8019eb <smalloc+0xae>
				}
			}

		}
		return NULL;
  8019e6:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8019eb:	c9                   	leave  
  8019ec:	c3                   	ret    

008019ed <sget>:

//========================================
// [5] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
  8019ed:	55                   	push   %ebp
  8019ee:	89 e5                	mov    %esp,%ebp
  8019f0:	83 ec 18             	sub    $0x18,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  8019f3:	e8 f5 fb ff ff       	call   8015ed <InitializeUHeap>

	//This function should find the space for sharing the variable
	// *** ON 4KB BOUNDARY ******** //

	//Use sys_isUHeapPlacementStrategyFIRSTFIT() to check the current strategy
	int ret=sys_getSizeOfSharedObject(ownerEnvID,sharedVarName);
  8019f8:	83 ec 08             	sub    $0x8,%esp
  8019fb:	ff 75 0c             	pushl  0xc(%ebp)
  8019fe:	ff 75 08             	pushl  0x8(%ebp)
  801a01:	e8 fb 03 00 00       	call   801e01 <sys_getSizeOfSharedObject>
  801a06:	83 c4 10             	add    $0x10,%esp
  801a09:	89 45 f4             	mov    %eax,-0xc(%ebp)
	if(ret==0)
  801a0c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801a10:	75 07                	jne    801a19 <sget+0x2c>
	{
		return NULL;
  801a12:	b8 00 00 00 00       	mov    $0x0,%eax
  801a17:	eb 64                	jmp    801a7d <sget+0x90>
	}
	if(sys_isUHeapPlacementStrategyFIRSTFIT())
  801a19:	e8 34 06 00 00       	call   802052 <sys_isUHeapPlacementStrategyFIRSTFIT>
  801a1e:	85 c0                	test   %eax,%eax
  801a20:	74 56                	je     801a78 <sget+0x8b>
	{
		struct MemBlock * v1=NULL;
  801a22:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
		v1= alloc_block_FF(ret);
  801a29:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801a2c:	83 ec 0c             	sub    $0xc,%esp
  801a2f:	50                   	push   %eax
  801a30:	e8 1e 0c 00 00       	call   802653 <alloc_block_FF>
  801a35:	83 c4 10             	add    $0x10,%esp
  801a38:	89 45 f0             	mov    %eax,-0x10(%ebp)
		if(v1==NULL)
  801a3b:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801a3f:	75 07                	jne    801a48 <sget+0x5b>
		{
		return NULL;
  801a41:	b8 00 00 00 00       	mov    $0x0,%eax
  801a46:	eb 35                	jmp    801a7d <sget+0x90>
	    }
		else
		{
			int ret1=sys_getSharedObject(ownerEnvID,sharedVarName,(void*)v1->sva);
  801a48:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801a4b:	8b 40 08             	mov    0x8(%eax),%eax
  801a4e:	83 ec 04             	sub    $0x4,%esp
  801a51:	50                   	push   %eax
  801a52:	ff 75 0c             	pushl  0xc(%ebp)
  801a55:	ff 75 08             	pushl  0x8(%ebp)
  801a58:	e8 c1 03 00 00       	call   801e1e <sys_getSharedObject>
  801a5d:	83 c4 10             	add    $0x10,%esp
  801a60:	89 45 ec             	mov    %eax,-0x14(%ebp)
			if(ret1>=0)
  801a63:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  801a67:	78 08                	js     801a71 <sget+0x84>
			{
				return (void*)v1->sva;
  801a69:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801a6c:	8b 40 08             	mov    0x8(%eax),%eax
  801a6f:	eb 0c                	jmp    801a7d <sget+0x90>
			}
			else
			{
				return NULL;
  801a71:	b8 00 00 00 00       	mov    $0x0,%eax
  801a76:	eb 05                	jmp    801a7d <sget+0x90>
			}
		}
	}
  return NULL;
  801a78:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801a7d:	c9                   	leave  
  801a7e:	c3                   	ret    

00801a7f <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  801a7f:	55                   	push   %ebp
  801a80:	89 e5                	mov    %esp,%ebp
  801a82:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801a85:	e8 63 fb ff ff       	call   8015ed <InitializeUHeap>
	//==============================================================
	// [USER HEAP - USER SIDE] realloc
	// Write your code here, remove the panic and write your code
	panic("realloc() is not implemented yet...!!");
  801a8a:	83 ec 04             	sub    $0x4,%esp
  801a8d:	68 24 3f 80 00       	push   $0x803f24
  801a92:	68 0e 01 00 00       	push   $0x10e
  801a97:	68 f3 3e 80 00       	push   $0x803ef3
  801a9c:	e8 0e eb ff ff       	call   8005af <_panic>

00801aa1 <sfree>:
//	use sys_freeSharedObject(...); which switches to the kernel mode,
//	calls freeSharedObject(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the freeSharedObject() function is empty, make sure to implement it.

void sfree(void* virtual_address)
{
  801aa1:	55                   	push   %ebp
  801aa2:	89 e5                	mov    %esp,%ebp
  801aa4:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT MS3 - BONUS] [SHARING - USER SIDE] sfree()

	// Write your code here, remove the panic and write your code
	panic("sfree() is not implemented yet...!!");
  801aa7:	83 ec 04             	sub    $0x4,%esp
  801aaa:	68 4c 3f 80 00       	push   $0x803f4c
  801aaf:	68 22 01 00 00       	push   $0x122
  801ab4:	68 f3 3e 80 00       	push   $0x803ef3
  801ab9:	e8 f1 ea ff ff       	call   8005af <_panic>

00801abe <expand>:

//==================================================================================//
//========================== MODIFICATION FUNCTIONS ================================//
//==================================================================================//
void expand(uint32 newSize)
{
  801abe:	55                   	push   %ebp
  801abf:	89 e5                	mov    %esp,%ebp
  801ac1:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801ac4:	83 ec 04             	sub    $0x4,%esp
  801ac7:	68 70 3f 80 00       	push   $0x803f70
  801acc:	68 2d 01 00 00       	push   $0x12d
  801ad1:	68 f3 3e 80 00       	push   $0x803ef3
  801ad6:	e8 d4 ea ff ff       	call   8005af <_panic>

00801adb <shrink>:

}
void shrink(uint32 newSize)
{
  801adb:	55                   	push   %ebp
  801adc:	89 e5                	mov    %esp,%ebp
  801ade:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801ae1:	83 ec 04             	sub    $0x4,%esp
  801ae4:	68 70 3f 80 00       	push   $0x803f70
  801ae9:	68 32 01 00 00       	push   $0x132
  801aee:	68 f3 3e 80 00       	push   $0x803ef3
  801af3:	e8 b7 ea ff ff       	call   8005af <_panic>

00801af8 <freeHeap>:

}
void freeHeap(void* virtual_address)
{
  801af8:	55                   	push   %ebp
  801af9:	89 e5                	mov    %esp,%ebp
  801afb:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801afe:	83 ec 04             	sub    $0x4,%esp
  801b01:	68 70 3f 80 00       	push   $0x803f70
  801b06:	68 37 01 00 00       	push   $0x137
  801b0b:	68 f3 3e 80 00       	push   $0x803ef3
  801b10:	e8 9a ea ff ff       	call   8005af <_panic>

00801b15 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  801b15:	55                   	push   %ebp
  801b16:	89 e5                	mov    %esp,%ebp
  801b18:	57                   	push   %edi
  801b19:	56                   	push   %esi
  801b1a:	53                   	push   %ebx
  801b1b:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801b1e:	8b 45 08             	mov    0x8(%ebp),%eax
  801b21:	8b 55 0c             	mov    0xc(%ebp),%edx
  801b24:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801b27:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801b2a:	8b 7d 18             	mov    0x18(%ebp),%edi
  801b2d:	8b 75 1c             	mov    0x1c(%ebp),%esi
  801b30:	cd 30                	int    $0x30
  801b32:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  801b35:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801b38:	83 c4 10             	add    $0x10,%esp
  801b3b:	5b                   	pop    %ebx
  801b3c:	5e                   	pop    %esi
  801b3d:	5f                   	pop    %edi
  801b3e:	5d                   	pop    %ebp
  801b3f:	c3                   	ret    

00801b40 <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  801b40:	55                   	push   %ebp
  801b41:	89 e5                	mov    %esp,%ebp
  801b43:	83 ec 04             	sub    $0x4,%esp
  801b46:	8b 45 10             	mov    0x10(%ebp),%eax
  801b49:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  801b4c:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801b50:	8b 45 08             	mov    0x8(%ebp),%eax
  801b53:	6a 00                	push   $0x0
  801b55:	6a 00                	push   $0x0
  801b57:	52                   	push   %edx
  801b58:	ff 75 0c             	pushl  0xc(%ebp)
  801b5b:	50                   	push   %eax
  801b5c:	6a 00                	push   $0x0
  801b5e:	e8 b2 ff ff ff       	call   801b15 <syscall>
  801b63:	83 c4 18             	add    $0x18,%esp
}
  801b66:	90                   	nop
  801b67:	c9                   	leave  
  801b68:	c3                   	ret    

00801b69 <sys_cgetc>:

int
sys_cgetc(void)
{
  801b69:	55                   	push   %ebp
  801b6a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  801b6c:	6a 00                	push   $0x0
  801b6e:	6a 00                	push   $0x0
  801b70:	6a 00                	push   $0x0
  801b72:	6a 00                	push   $0x0
  801b74:	6a 00                	push   $0x0
  801b76:	6a 01                	push   $0x1
  801b78:	e8 98 ff ff ff       	call   801b15 <syscall>
  801b7d:	83 c4 18             	add    $0x18,%esp
}
  801b80:	c9                   	leave  
  801b81:	c3                   	ret    

00801b82 <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  801b82:	55                   	push   %ebp
  801b83:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  801b85:	8b 55 0c             	mov    0xc(%ebp),%edx
  801b88:	8b 45 08             	mov    0x8(%ebp),%eax
  801b8b:	6a 00                	push   $0x0
  801b8d:	6a 00                	push   $0x0
  801b8f:	6a 00                	push   $0x0
  801b91:	52                   	push   %edx
  801b92:	50                   	push   %eax
  801b93:	6a 05                	push   $0x5
  801b95:	e8 7b ff ff ff       	call   801b15 <syscall>
  801b9a:	83 c4 18             	add    $0x18,%esp
}
  801b9d:	c9                   	leave  
  801b9e:	c3                   	ret    

00801b9f <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  801b9f:	55                   	push   %ebp
  801ba0:	89 e5                	mov    %esp,%ebp
  801ba2:	56                   	push   %esi
  801ba3:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  801ba4:	8b 75 18             	mov    0x18(%ebp),%esi
  801ba7:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801baa:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801bad:	8b 55 0c             	mov    0xc(%ebp),%edx
  801bb0:	8b 45 08             	mov    0x8(%ebp),%eax
  801bb3:	56                   	push   %esi
  801bb4:	53                   	push   %ebx
  801bb5:	51                   	push   %ecx
  801bb6:	52                   	push   %edx
  801bb7:	50                   	push   %eax
  801bb8:	6a 06                	push   $0x6
  801bba:	e8 56 ff ff ff       	call   801b15 <syscall>
  801bbf:	83 c4 18             	add    $0x18,%esp
}
  801bc2:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801bc5:	5b                   	pop    %ebx
  801bc6:	5e                   	pop    %esi
  801bc7:	5d                   	pop    %ebp
  801bc8:	c3                   	ret    

00801bc9 <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  801bc9:	55                   	push   %ebp
  801bca:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  801bcc:	8b 55 0c             	mov    0xc(%ebp),%edx
  801bcf:	8b 45 08             	mov    0x8(%ebp),%eax
  801bd2:	6a 00                	push   $0x0
  801bd4:	6a 00                	push   $0x0
  801bd6:	6a 00                	push   $0x0
  801bd8:	52                   	push   %edx
  801bd9:	50                   	push   %eax
  801bda:	6a 07                	push   $0x7
  801bdc:	e8 34 ff ff ff       	call   801b15 <syscall>
  801be1:	83 c4 18             	add    $0x18,%esp
}
  801be4:	c9                   	leave  
  801be5:	c3                   	ret    

00801be6 <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  801be6:	55                   	push   %ebp
  801be7:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  801be9:	6a 00                	push   $0x0
  801beb:	6a 00                	push   $0x0
  801bed:	6a 00                	push   $0x0
  801bef:	ff 75 0c             	pushl  0xc(%ebp)
  801bf2:	ff 75 08             	pushl  0x8(%ebp)
  801bf5:	6a 08                	push   $0x8
  801bf7:	e8 19 ff ff ff       	call   801b15 <syscall>
  801bfc:	83 c4 18             	add    $0x18,%esp
}
  801bff:	c9                   	leave  
  801c00:	c3                   	ret    

00801c01 <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  801c01:	55                   	push   %ebp
  801c02:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  801c04:	6a 00                	push   $0x0
  801c06:	6a 00                	push   $0x0
  801c08:	6a 00                	push   $0x0
  801c0a:	6a 00                	push   $0x0
  801c0c:	6a 00                	push   $0x0
  801c0e:	6a 09                	push   $0x9
  801c10:	e8 00 ff ff ff       	call   801b15 <syscall>
  801c15:	83 c4 18             	add    $0x18,%esp
}
  801c18:	c9                   	leave  
  801c19:	c3                   	ret    

00801c1a <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  801c1a:	55                   	push   %ebp
  801c1b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  801c1d:	6a 00                	push   $0x0
  801c1f:	6a 00                	push   $0x0
  801c21:	6a 00                	push   $0x0
  801c23:	6a 00                	push   $0x0
  801c25:	6a 00                	push   $0x0
  801c27:	6a 0a                	push   $0xa
  801c29:	e8 e7 fe ff ff       	call   801b15 <syscall>
  801c2e:	83 c4 18             	add    $0x18,%esp
}
  801c31:	c9                   	leave  
  801c32:	c3                   	ret    

00801c33 <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  801c33:	55                   	push   %ebp
  801c34:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  801c36:	6a 00                	push   $0x0
  801c38:	6a 00                	push   $0x0
  801c3a:	6a 00                	push   $0x0
  801c3c:	6a 00                	push   $0x0
  801c3e:	6a 00                	push   $0x0
  801c40:	6a 0b                	push   $0xb
  801c42:	e8 ce fe ff ff       	call   801b15 <syscall>
  801c47:	83 c4 18             	add    $0x18,%esp
}
  801c4a:	c9                   	leave  
  801c4b:	c3                   	ret    

00801c4c <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  801c4c:	55                   	push   %ebp
  801c4d:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  801c4f:	6a 00                	push   $0x0
  801c51:	6a 00                	push   $0x0
  801c53:	6a 00                	push   $0x0
  801c55:	ff 75 0c             	pushl  0xc(%ebp)
  801c58:	ff 75 08             	pushl  0x8(%ebp)
  801c5b:	6a 0f                	push   $0xf
  801c5d:	e8 b3 fe ff ff       	call   801b15 <syscall>
  801c62:	83 c4 18             	add    $0x18,%esp
	return;
  801c65:	90                   	nop
}
  801c66:	c9                   	leave  
  801c67:	c3                   	ret    

00801c68 <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  801c68:	55                   	push   %ebp
  801c69:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  801c6b:	6a 00                	push   $0x0
  801c6d:	6a 00                	push   $0x0
  801c6f:	6a 00                	push   $0x0
  801c71:	ff 75 0c             	pushl  0xc(%ebp)
  801c74:	ff 75 08             	pushl  0x8(%ebp)
  801c77:	6a 10                	push   $0x10
  801c79:	e8 97 fe ff ff       	call   801b15 <syscall>
  801c7e:	83 c4 18             	add    $0x18,%esp
	return ;
  801c81:	90                   	nop
}
  801c82:	c9                   	leave  
  801c83:	c3                   	ret    

00801c84 <sys_allocate_chunk>:

void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  801c84:	55                   	push   %ebp
  801c85:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  801c87:	6a 00                	push   $0x0
  801c89:	6a 00                	push   $0x0
  801c8b:	ff 75 10             	pushl  0x10(%ebp)
  801c8e:	ff 75 0c             	pushl  0xc(%ebp)
  801c91:	ff 75 08             	pushl  0x8(%ebp)
  801c94:	6a 11                	push   $0x11
  801c96:	e8 7a fe ff ff       	call   801b15 <syscall>
  801c9b:	83 c4 18             	add    $0x18,%esp
	return ;
  801c9e:	90                   	nop
}
  801c9f:	c9                   	leave  
  801ca0:	c3                   	ret    

00801ca1 <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  801ca1:	55                   	push   %ebp
  801ca2:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  801ca4:	6a 00                	push   $0x0
  801ca6:	6a 00                	push   $0x0
  801ca8:	6a 00                	push   $0x0
  801caa:	6a 00                	push   $0x0
  801cac:	6a 00                	push   $0x0
  801cae:	6a 0c                	push   $0xc
  801cb0:	e8 60 fe ff ff       	call   801b15 <syscall>
  801cb5:	83 c4 18             	add    $0x18,%esp
}
  801cb8:	c9                   	leave  
  801cb9:	c3                   	ret    

00801cba <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  801cba:	55                   	push   %ebp
  801cbb:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  801cbd:	6a 00                	push   $0x0
  801cbf:	6a 00                	push   $0x0
  801cc1:	6a 00                	push   $0x0
  801cc3:	6a 00                	push   $0x0
  801cc5:	ff 75 08             	pushl  0x8(%ebp)
  801cc8:	6a 0d                	push   $0xd
  801cca:	e8 46 fe ff ff       	call   801b15 <syscall>
  801ccf:	83 c4 18             	add    $0x18,%esp
}
  801cd2:	c9                   	leave  
  801cd3:	c3                   	ret    

00801cd4 <sys_scarce_memory>:

void sys_scarce_memory()
{
  801cd4:	55                   	push   %ebp
  801cd5:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  801cd7:	6a 00                	push   $0x0
  801cd9:	6a 00                	push   $0x0
  801cdb:	6a 00                	push   $0x0
  801cdd:	6a 00                	push   $0x0
  801cdf:	6a 00                	push   $0x0
  801ce1:	6a 0e                	push   $0xe
  801ce3:	e8 2d fe ff ff       	call   801b15 <syscall>
  801ce8:	83 c4 18             	add    $0x18,%esp
}
  801ceb:	90                   	nop
  801cec:	c9                   	leave  
  801ced:	c3                   	ret    

00801cee <sys_disable_interrupt>:

//NEW !! 2012...
void
sys_disable_interrupt()
{
  801cee:	55                   	push   %ebp
  801cef:	89 e5                	mov    %esp,%ebp
	syscall(SYS_disableINTR,0, 0, 0, 0, 0);
  801cf1:	6a 00                	push   $0x0
  801cf3:	6a 00                	push   $0x0
  801cf5:	6a 00                	push   $0x0
  801cf7:	6a 00                	push   $0x0
  801cf9:	6a 00                	push   $0x0
  801cfb:	6a 13                	push   $0x13
  801cfd:	e8 13 fe ff ff       	call   801b15 <syscall>
  801d02:	83 c4 18             	add    $0x18,%esp
}
  801d05:	90                   	nop
  801d06:	c9                   	leave  
  801d07:	c3                   	ret    

00801d08 <sys_enable_interrupt>:


void
sys_enable_interrupt()
{
  801d08:	55                   	push   %ebp
  801d09:	89 e5                	mov    %esp,%ebp
	syscall(SYS_enableINTR,0, 0, 0, 0, 0);
  801d0b:	6a 00                	push   $0x0
  801d0d:	6a 00                	push   $0x0
  801d0f:	6a 00                	push   $0x0
  801d11:	6a 00                	push   $0x0
  801d13:	6a 00                	push   $0x0
  801d15:	6a 14                	push   $0x14
  801d17:	e8 f9 fd ff ff       	call   801b15 <syscall>
  801d1c:	83 c4 18             	add    $0x18,%esp
}
  801d1f:	90                   	nop
  801d20:	c9                   	leave  
  801d21:	c3                   	ret    

00801d22 <sys_cputc>:


void
sys_cputc(const char c)
{
  801d22:	55                   	push   %ebp
  801d23:	89 e5                	mov    %esp,%ebp
  801d25:	83 ec 04             	sub    $0x4,%esp
  801d28:	8b 45 08             	mov    0x8(%ebp),%eax
  801d2b:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  801d2e:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801d32:	6a 00                	push   $0x0
  801d34:	6a 00                	push   $0x0
  801d36:	6a 00                	push   $0x0
  801d38:	6a 00                	push   $0x0
  801d3a:	50                   	push   %eax
  801d3b:	6a 15                	push   $0x15
  801d3d:	e8 d3 fd ff ff       	call   801b15 <syscall>
  801d42:	83 c4 18             	add    $0x18,%esp
}
  801d45:	90                   	nop
  801d46:	c9                   	leave  
  801d47:	c3                   	ret    

00801d48 <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  801d48:	55                   	push   %ebp
  801d49:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  801d4b:	6a 00                	push   $0x0
  801d4d:	6a 00                	push   $0x0
  801d4f:	6a 00                	push   $0x0
  801d51:	6a 00                	push   $0x0
  801d53:	6a 00                	push   $0x0
  801d55:	6a 16                	push   $0x16
  801d57:	e8 b9 fd ff ff       	call   801b15 <syscall>
  801d5c:	83 c4 18             	add    $0x18,%esp
}
  801d5f:	90                   	nop
  801d60:	c9                   	leave  
  801d61:	c3                   	ret    

00801d62 <sys_createSemaphore>:

int
sys_createSemaphore(char* semaphoreName, uint32 initialValue)
{
  801d62:	55                   	push   %ebp
  801d63:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_semaphore,(uint32)semaphoreName, (uint32)initialValue, 0, 0, 0);
  801d65:	8b 45 08             	mov    0x8(%ebp),%eax
  801d68:	6a 00                	push   $0x0
  801d6a:	6a 00                	push   $0x0
  801d6c:	6a 00                	push   $0x0
  801d6e:	ff 75 0c             	pushl  0xc(%ebp)
  801d71:	50                   	push   %eax
  801d72:	6a 17                	push   $0x17
  801d74:	e8 9c fd ff ff       	call   801b15 <syscall>
  801d79:	83 c4 18             	add    $0x18,%esp
}
  801d7c:	c9                   	leave  
  801d7d:	c3                   	ret    

00801d7e <sys_getSemaphoreValue>:

int
sys_getSemaphoreValue(int32 ownerEnvID, char* semaphoreName)
{
  801d7e:	55                   	push   %ebp
  801d7f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_semaphore_value,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801d81:	8b 55 0c             	mov    0xc(%ebp),%edx
  801d84:	8b 45 08             	mov    0x8(%ebp),%eax
  801d87:	6a 00                	push   $0x0
  801d89:	6a 00                	push   $0x0
  801d8b:	6a 00                	push   $0x0
  801d8d:	52                   	push   %edx
  801d8e:	50                   	push   %eax
  801d8f:	6a 1a                	push   $0x1a
  801d91:	e8 7f fd ff ff       	call   801b15 <syscall>
  801d96:	83 c4 18             	add    $0x18,%esp
}
  801d99:	c9                   	leave  
  801d9a:	c3                   	ret    

00801d9b <sys_waitSemaphore>:

void
sys_waitSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  801d9b:	55                   	push   %ebp
  801d9c:	89 e5                	mov    %esp,%ebp
	syscall(SYS_wait_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801d9e:	8b 55 0c             	mov    0xc(%ebp),%edx
  801da1:	8b 45 08             	mov    0x8(%ebp),%eax
  801da4:	6a 00                	push   $0x0
  801da6:	6a 00                	push   $0x0
  801da8:	6a 00                	push   $0x0
  801daa:	52                   	push   %edx
  801dab:	50                   	push   %eax
  801dac:	6a 18                	push   $0x18
  801dae:	e8 62 fd ff ff       	call   801b15 <syscall>
  801db3:	83 c4 18             	add    $0x18,%esp
}
  801db6:	90                   	nop
  801db7:	c9                   	leave  
  801db8:	c3                   	ret    

00801db9 <sys_signalSemaphore>:

void
sys_signalSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  801db9:	55                   	push   %ebp
  801dba:	89 e5                	mov    %esp,%ebp
	syscall(SYS_signal_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801dbc:	8b 55 0c             	mov    0xc(%ebp),%edx
  801dbf:	8b 45 08             	mov    0x8(%ebp),%eax
  801dc2:	6a 00                	push   $0x0
  801dc4:	6a 00                	push   $0x0
  801dc6:	6a 00                	push   $0x0
  801dc8:	52                   	push   %edx
  801dc9:	50                   	push   %eax
  801dca:	6a 19                	push   $0x19
  801dcc:	e8 44 fd ff ff       	call   801b15 <syscall>
  801dd1:	83 c4 18             	add    $0x18,%esp
}
  801dd4:	90                   	nop
  801dd5:	c9                   	leave  
  801dd6:	c3                   	ret    

00801dd7 <sys_createSharedObject>:

int
sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  801dd7:	55                   	push   %ebp
  801dd8:	89 e5                	mov    %esp,%ebp
  801dda:	83 ec 04             	sub    $0x4,%esp
  801ddd:	8b 45 10             	mov    0x10(%ebp),%eax
  801de0:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  801de3:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801de6:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801dea:	8b 45 08             	mov    0x8(%ebp),%eax
  801ded:	6a 00                	push   $0x0
  801def:	51                   	push   %ecx
  801df0:	52                   	push   %edx
  801df1:	ff 75 0c             	pushl  0xc(%ebp)
  801df4:	50                   	push   %eax
  801df5:	6a 1b                	push   $0x1b
  801df7:	e8 19 fd ff ff       	call   801b15 <syscall>
  801dfc:	83 c4 18             	add    $0x18,%esp
}
  801dff:	c9                   	leave  
  801e00:	c3                   	ret    

00801e01 <sys_getSizeOfSharedObject>:

//2017:
int
sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  801e01:	55                   	push   %ebp
  801e02:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  801e04:	8b 55 0c             	mov    0xc(%ebp),%edx
  801e07:	8b 45 08             	mov    0x8(%ebp),%eax
  801e0a:	6a 00                	push   $0x0
  801e0c:	6a 00                	push   $0x0
  801e0e:	6a 00                	push   $0x0
  801e10:	52                   	push   %edx
  801e11:	50                   	push   %eax
  801e12:	6a 1c                	push   $0x1c
  801e14:	e8 fc fc ff ff       	call   801b15 <syscall>
  801e19:	83 c4 18             	add    $0x18,%esp
}
  801e1c:	c9                   	leave  
  801e1d:	c3                   	ret    

00801e1e <sys_getSharedObject>:
//==========

int
sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  801e1e:	55                   	push   %ebp
  801e1f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  801e21:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801e24:	8b 55 0c             	mov    0xc(%ebp),%edx
  801e27:	8b 45 08             	mov    0x8(%ebp),%eax
  801e2a:	6a 00                	push   $0x0
  801e2c:	6a 00                	push   $0x0
  801e2e:	51                   	push   %ecx
  801e2f:	52                   	push   %edx
  801e30:	50                   	push   %eax
  801e31:	6a 1d                	push   $0x1d
  801e33:	e8 dd fc ff ff       	call   801b15 <syscall>
  801e38:	83 c4 18             	add    $0x18,%esp
}
  801e3b:	c9                   	leave  
  801e3c:	c3                   	ret    

00801e3d <sys_freeSharedObject>:

int
sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  801e3d:	55                   	push   %ebp
  801e3e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  801e40:	8b 55 0c             	mov    0xc(%ebp),%edx
  801e43:	8b 45 08             	mov    0x8(%ebp),%eax
  801e46:	6a 00                	push   $0x0
  801e48:	6a 00                	push   $0x0
  801e4a:	6a 00                	push   $0x0
  801e4c:	52                   	push   %edx
  801e4d:	50                   	push   %eax
  801e4e:	6a 1e                	push   $0x1e
  801e50:	e8 c0 fc ff ff       	call   801b15 <syscall>
  801e55:	83 c4 18             	add    $0x18,%esp
}
  801e58:	c9                   	leave  
  801e59:	c3                   	ret    

00801e5a <sys_getMaxShares>:

uint32 	sys_getMaxShares()
{
  801e5a:	55                   	push   %ebp
  801e5b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_max_shares,0, 0, 0, 0, 0);
  801e5d:	6a 00                	push   $0x0
  801e5f:	6a 00                	push   $0x0
  801e61:	6a 00                	push   $0x0
  801e63:	6a 00                	push   $0x0
  801e65:	6a 00                	push   $0x0
  801e67:	6a 1f                	push   $0x1f
  801e69:	e8 a7 fc ff ff       	call   801b15 <syscall>
  801e6e:	83 c4 18             	add    $0x18,%esp
}
  801e71:	c9                   	leave  
  801e72:	c3                   	ret    

00801e73 <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  801e73:	55                   	push   %ebp
  801e74:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  801e76:	8b 45 08             	mov    0x8(%ebp),%eax
  801e79:	6a 00                	push   $0x0
  801e7b:	ff 75 14             	pushl  0x14(%ebp)
  801e7e:	ff 75 10             	pushl  0x10(%ebp)
  801e81:	ff 75 0c             	pushl  0xc(%ebp)
  801e84:	50                   	push   %eax
  801e85:	6a 20                	push   $0x20
  801e87:	e8 89 fc ff ff       	call   801b15 <syscall>
  801e8c:	83 c4 18             	add    $0x18,%esp
}
  801e8f:	c9                   	leave  
  801e90:	c3                   	ret    

00801e91 <sys_run_env>:

void
sys_run_env(int32 envId)
{
  801e91:	55                   	push   %ebp
  801e92:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  801e94:	8b 45 08             	mov    0x8(%ebp),%eax
  801e97:	6a 00                	push   $0x0
  801e99:	6a 00                	push   $0x0
  801e9b:	6a 00                	push   $0x0
  801e9d:	6a 00                	push   $0x0
  801e9f:	50                   	push   %eax
  801ea0:	6a 21                	push   $0x21
  801ea2:	e8 6e fc ff ff       	call   801b15 <syscall>
  801ea7:	83 c4 18             	add    $0x18,%esp
}
  801eaa:	90                   	nop
  801eab:	c9                   	leave  
  801eac:	c3                   	ret    

00801ead <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  801ead:	55                   	push   %ebp
  801eae:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  801eb0:	8b 45 08             	mov    0x8(%ebp),%eax
  801eb3:	6a 00                	push   $0x0
  801eb5:	6a 00                	push   $0x0
  801eb7:	6a 00                	push   $0x0
  801eb9:	6a 00                	push   $0x0
  801ebb:	50                   	push   %eax
  801ebc:	6a 22                	push   $0x22
  801ebe:	e8 52 fc ff ff       	call   801b15 <syscall>
  801ec3:	83 c4 18             	add    $0x18,%esp
}
  801ec6:	c9                   	leave  
  801ec7:	c3                   	ret    

00801ec8 <sys_getenvid>:

int32 sys_getenvid(void)
{
  801ec8:	55                   	push   %ebp
  801ec9:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  801ecb:	6a 00                	push   $0x0
  801ecd:	6a 00                	push   $0x0
  801ecf:	6a 00                	push   $0x0
  801ed1:	6a 00                	push   $0x0
  801ed3:	6a 00                	push   $0x0
  801ed5:	6a 02                	push   $0x2
  801ed7:	e8 39 fc ff ff       	call   801b15 <syscall>
  801edc:	83 c4 18             	add    $0x18,%esp
}
  801edf:	c9                   	leave  
  801ee0:	c3                   	ret    

00801ee1 <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  801ee1:	55                   	push   %ebp
  801ee2:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  801ee4:	6a 00                	push   $0x0
  801ee6:	6a 00                	push   $0x0
  801ee8:	6a 00                	push   $0x0
  801eea:	6a 00                	push   $0x0
  801eec:	6a 00                	push   $0x0
  801eee:	6a 03                	push   $0x3
  801ef0:	e8 20 fc ff ff       	call   801b15 <syscall>
  801ef5:	83 c4 18             	add    $0x18,%esp
}
  801ef8:	c9                   	leave  
  801ef9:	c3                   	ret    

00801efa <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  801efa:	55                   	push   %ebp
  801efb:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  801efd:	6a 00                	push   $0x0
  801eff:	6a 00                	push   $0x0
  801f01:	6a 00                	push   $0x0
  801f03:	6a 00                	push   $0x0
  801f05:	6a 00                	push   $0x0
  801f07:	6a 04                	push   $0x4
  801f09:	e8 07 fc ff ff       	call   801b15 <syscall>
  801f0e:	83 c4 18             	add    $0x18,%esp
}
  801f11:	c9                   	leave  
  801f12:	c3                   	ret    

00801f13 <sys_exit_env>:


void sys_exit_env(void)
{
  801f13:	55                   	push   %ebp
  801f14:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  801f16:	6a 00                	push   $0x0
  801f18:	6a 00                	push   $0x0
  801f1a:	6a 00                	push   $0x0
  801f1c:	6a 00                	push   $0x0
  801f1e:	6a 00                	push   $0x0
  801f20:	6a 23                	push   $0x23
  801f22:	e8 ee fb ff ff       	call   801b15 <syscall>
  801f27:	83 c4 18             	add    $0x18,%esp
}
  801f2a:	90                   	nop
  801f2b:	c9                   	leave  
  801f2c:	c3                   	ret    

00801f2d <sys_get_virtual_time>:


struct uint64
sys_get_virtual_time()
{
  801f2d:	55                   	push   %ebp
  801f2e:	89 e5                	mov    %esp,%ebp
  801f30:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  801f33:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801f36:	8d 50 04             	lea    0x4(%eax),%edx
  801f39:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801f3c:	6a 00                	push   $0x0
  801f3e:	6a 00                	push   $0x0
  801f40:	6a 00                	push   $0x0
  801f42:	52                   	push   %edx
  801f43:	50                   	push   %eax
  801f44:	6a 24                	push   $0x24
  801f46:	e8 ca fb ff ff       	call   801b15 <syscall>
  801f4b:	83 c4 18             	add    $0x18,%esp
	return result;
  801f4e:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801f51:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801f54:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801f57:	89 01                	mov    %eax,(%ecx)
  801f59:	89 51 04             	mov    %edx,0x4(%ecx)
}
  801f5c:	8b 45 08             	mov    0x8(%ebp),%eax
  801f5f:	c9                   	leave  
  801f60:	c2 04 00             	ret    $0x4

00801f63 <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  801f63:	55                   	push   %ebp
  801f64:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  801f66:	6a 00                	push   $0x0
  801f68:	6a 00                	push   $0x0
  801f6a:	ff 75 10             	pushl  0x10(%ebp)
  801f6d:	ff 75 0c             	pushl  0xc(%ebp)
  801f70:	ff 75 08             	pushl  0x8(%ebp)
  801f73:	6a 12                	push   $0x12
  801f75:	e8 9b fb ff ff       	call   801b15 <syscall>
  801f7a:	83 c4 18             	add    $0x18,%esp
	return ;
  801f7d:	90                   	nop
}
  801f7e:	c9                   	leave  
  801f7f:	c3                   	ret    

00801f80 <sys_rcr2>:
uint32 sys_rcr2()
{
  801f80:	55                   	push   %ebp
  801f81:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  801f83:	6a 00                	push   $0x0
  801f85:	6a 00                	push   $0x0
  801f87:	6a 00                	push   $0x0
  801f89:	6a 00                	push   $0x0
  801f8b:	6a 00                	push   $0x0
  801f8d:	6a 25                	push   $0x25
  801f8f:	e8 81 fb ff ff       	call   801b15 <syscall>
  801f94:	83 c4 18             	add    $0x18,%esp
}
  801f97:	c9                   	leave  
  801f98:	c3                   	ret    

00801f99 <sys_bypassPageFault>:
void sys_bypassPageFault(uint8 instrLength)
{
  801f99:	55                   	push   %ebp
  801f9a:	89 e5                	mov    %esp,%ebp
  801f9c:	83 ec 04             	sub    $0x4,%esp
  801f9f:	8b 45 08             	mov    0x8(%ebp),%eax
  801fa2:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  801fa5:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  801fa9:	6a 00                	push   $0x0
  801fab:	6a 00                	push   $0x0
  801fad:	6a 00                	push   $0x0
  801faf:	6a 00                	push   $0x0
  801fb1:	50                   	push   %eax
  801fb2:	6a 26                	push   $0x26
  801fb4:	e8 5c fb ff ff       	call   801b15 <syscall>
  801fb9:	83 c4 18             	add    $0x18,%esp
	return ;
  801fbc:	90                   	nop
}
  801fbd:	c9                   	leave  
  801fbe:	c3                   	ret    

00801fbf <rsttst>:
void rsttst()
{
  801fbf:	55                   	push   %ebp
  801fc0:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  801fc2:	6a 00                	push   $0x0
  801fc4:	6a 00                	push   $0x0
  801fc6:	6a 00                	push   $0x0
  801fc8:	6a 00                	push   $0x0
  801fca:	6a 00                	push   $0x0
  801fcc:	6a 28                	push   $0x28
  801fce:	e8 42 fb ff ff       	call   801b15 <syscall>
  801fd3:	83 c4 18             	add    $0x18,%esp
	return ;
  801fd6:	90                   	nop
}
  801fd7:	c9                   	leave  
  801fd8:	c3                   	ret    

00801fd9 <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  801fd9:	55                   	push   %ebp
  801fda:	89 e5                	mov    %esp,%ebp
  801fdc:	83 ec 04             	sub    $0x4,%esp
  801fdf:	8b 45 14             	mov    0x14(%ebp),%eax
  801fe2:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  801fe5:	8b 55 18             	mov    0x18(%ebp),%edx
  801fe8:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801fec:	52                   	push   %edx
  801fed:	50                   	push   %eax
  801fee:	ff 75 10             	pushl  0x10(%ebp)
  801ff1:	ff 75 0c             	pushl  0xc(%ebp)
  801ff4:	ff 75 08             	pushl  0x8(%ebp)
  801ff7:	6a 27                	push   $0x27
  801ff9:	e8 17 fb ff ff       	call   801b15 <syscall>
  801ffe:	83 c4 18             	add    $0x18,%esp
	return ;
  802001:	90                   	nop
}
  802002:	c9                   	leave  
  802003:	c3                   	ret    

00802004 <chktst>:
void chktst(uint32 n)
{
  802004:	55                   	push   %ebp
  802005:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  802007:	6a 00                	push   $0x0
  802009:	6a 00                	push   $0x0
  80200b:	6a 00                	push   $0x0
  80200d:	6a 00                	push   $0x0
  80200f:	ff 75 08             	pushl  0x8(%ebp)
  802012:	6a 29                	push   $0x29
  802014:	e8 fc fa ff ff       	call   801b15 <syscall>
  802019:	83 c4 18             	add    $0x18,%esp
	return ;
  80201c:	90                   	nop
}
  80201d:	c9                   	leave  
  80201e:	c3                   	ret    

0080201f <inctst>:

void inctst()
{
  80201f:	55                   	push   %ebp
  802020:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  802022:	6a 00                	push   $0x0
  802024:	6a 00                	push   $0x0
  802026:	6a 00                	push   $0x0
  802028:	6a 00                	push   $0x0
  80202a:	6a 00                	push   $0x0
  80202c:	6a 2a                	push   $0x2a
  80202e:	e8 e2 fa ff ff       	call   801b15 <syscall>
  802033:	83 c4 18             	add    $0x18,%esp
	return ;
  802036:	90                   	nop
}
  802037:	c9                   	leave  
  802038:	c3                   	ret    

00802039 <gettst>:
uint32 gettst()
{
  802039:	55                   	push   %ebp
  80203a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  80203c:	6a 00                	push   $0x0
  80203e:	6a 00                	push   $0x0
  802040:	6a 00                	push   $0x0
  802042:	6a 00                	push   $0x0
  802044:	6a 00                	push   $0x0
  802046:	6a 2b                	push   $0x2b
  802048:	e8 c8 fa ff ff       	call   801b15 <syscall>
  80204d:	83 c4 18             	add    $0x18,%esp
}
  802050:	c9                   	leave  
  802051:	c3                   	ret    

00802052 <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  802052:	55                   	push   %ebp
  802053:	89 e5                	mov    %esp,%ebp
  802055:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  802058:	6a 00                	push   $0x0
  80205a:	6a 00                	push   $0x0
  80205c:	6a 00                	push   $0x0
  80205e:	6a 00                	push   $0x0
  802060:	6a 00                	push   $0x0
  802062:	6a 2c                	push   $0x2c
  802064:	e8 ac fa ff ff       	call   801b15 <syscall>
  802069:	83 c4 18             	add    $0x18,%esp
  80206c:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  80206f:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  802073:	75 07                	jne    80207c <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  802075:	b8 01 00 00 00       	mov    $0x1,%eax
  80207a:	eb 05                	jmp    802081 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  80207c:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802081:	c9                   	leave  
  802082:	c3                   	ret    

00802083 <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  802083:	55                   	push   %ebp
  802084:	89 e5                	mov    %esp,%ebp
  802086:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  802089:	6a 00                	push   $0x0
  80208b:	6a 00                	push   $0x0
  80208d:	6a 00                	push   $0x0
  80208f:	6a 00                	push   $0x0
  802091:	6a 00                	push   $0x0
  802093:	6a 2c                	push   $0x2c
  802095:	e8 7b fa ff ff       	call   801b15 <syscall>
  80209a:	83 c4 18             	add    $0x18,%esp
  80209d:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  8020a0:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  8020a4:	75 07                	jne    8020ad <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  8020a6:	b8 01 00 00 00       	mov    $0x1,%eax
  8020ab:	eb 05                	jmp    8020b2 <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  8020ad:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8020b2:	c9                   	leave  
  8020b3:	c3                   	ret    

008020b4 <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  8020b4:	55                   	push   %ebp
  8020b5:	89 e5                	mov    %esp,%ebp
  8020b7:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8020ba:	6a 00                	push   $0x0
  8020bc:	6a 00                	push   $0x0
  8020be:	6a 00                	push   $0x0
  8020c0:	6a 00                	push   $0x0
  8020c2:	6a 00                	push   $0x0
  8020c4:	6a 2c                	push   $0x2c
  8020c6:	e8 4a fa ff ff       	call   801b15 <syscall>
  8020cb:	83 c4 18             	add    $0x18,%esp
  8020ce:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  8020d1:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  8020d5:	75 07                	jne    8020de <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  8020d7:	b8 01 00 00 00       	mov    $0x1,%eax
  8020dc:	eb 05                	jmp    8020e3 <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  8020de:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8020e3:	c9                   	leave  
  8020e4:	c3                   	ret    

008020e5 <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  8020e5:	55                   	push   %ebp
  8020e6:	89 e5                	mov    %esp,%ebp
  8020e8:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8020eb:	6a 00                	push   $0x0
  8020ed:	6a 00                	push   $0x0
  8020ef:	6a 00                	push   $0x0
  8020f1:	6a 00                	push   $0x0
  8020f3:	6a 00                	push   $0x0
  8020f5:	6a 2c                	push   $0x2c
  8020f7:	e8 19 fa ff ff       	call   801b15 <syscall>
  8020fc:	83 c4 18             	add    $0x18,%esp
  8020ff:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  802102:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  802106:	75 07                	jne    80210f <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  802108:	b8 01 00 00 00       	mov    $0x1,%eax
  80210d:	eb 05                	jmp    802114 <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  80210f:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802114:	c9                   	leave  
  802115:	c3                   	ret    

00802116 <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  802116:	55                   	push   %ebp
  802117:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  802119:	6a 00                	push   $0x0
  80211b:	6a 00                	push   $0x0
  80211d:	6a 00                	push   $0x0
  80211f:	6a 00                	push   $0x0
  802121:	ff 75 08             	pushl  0x8(%ebp)
  802124:	6a 2d                	push   $0x2d
  802126:	e8 ea f9 ff ff       	call   801b15 <syscall>
  80212b:	83 c4 18             	add    $0x18,%esp
	return ;
  80212e:	90                   	nop
}
  80212f:	c9                   	leave  
  802130:	c3                   	ret    

00802131 <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  802131:	55                   	push   %ebp
  802132:	89 e5                	mov    %esp,%ebp
  802134:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  802135:	8b 5d 14             	mov    0x14(%ebp),%ebx
  802138:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80213b:	8b 55 0c             	mov    0xc(%ebp),%edx
  80213e:	8b 45 08             	mov    0x8(%ebp),%eax
  802141:	6a 00                	push   $0x0
  802143:	53                   	push   %ebx
  802144:	51                   	push   %ecx
  802145:	52                   	push   %edx
  802146:	50                   	push   %eax
  802147:	6a 2e                	push   $0x2e
  802149:	e8 c7 f9 ff ff       	call   801b15 <syscall>
  80214e:	83 c4 18             	add    $0x18,%esp
}
  802151:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  802154:	c9                   	leave  
  802155:	c3                   	ret    

00802156 <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  802156:	55                   	push   %ebp
  802157:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  802159:	8b 55 0c             	mov    0xc(%ebp),%edx
  80215c:	8b 45 08             	mov    0x8(%ebp),%eax
  80215f:	6a 00                	push   $0x0
  802161:	6a 00                	push   $0x0
  802163:	6a 00                	push   $0x0
  802165:	52                   	push   %edx
  802166:	50                   	push   %eax
  802167:	6a 2f                	push   $0x2f
  802169:	e8 a7 f9 ff ff       	call   801b15 <syscall>
  80216e:	83 c4 18             	add    $0x18,%esp
}
  802171:	c9                   	leave  
  802172:	c3                   	ret    

00802173 <print_mem_block_lists>:
//===========================
// PRINT MEM BLOCK LISTS:
//===========================

void print_mem_block_lists()
{
  802173:	55                   	push   %ebp
  802174:	89 e5                	mov    %esp,%ebp
  802176:	83 ec 18             	sub    $0x18,%esp
	cprintf("\n=========================================\n");
  802179:	83 ec 0c             	sub    $0xc,%esp
  80217c:	68 80 3f 80 00       	push   $0x803f80
  802181:	e8 dd e6 ff ff       	call   800863 <cprintf>
  802186:	83 c4 10             	add    $0x10,%esp
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
  802189:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nFreeMemBlocksList:\n");
  802190:	83 ec 0c             	sub    $0xc,%esp
  802193:	68 ac 3f 80 00       	push   $0x803fac
  802198:	e8 c6 e6 ff ff       	call   800863 <cprintf>
  80219d:	83 c4 10             	add    $0x10,%esp
	uint8 sorted = 1 ;
  8021a0:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &FreeMemBlocksList)
  8021a4:	a1 38 51 80 00       	mov    0x805138,%eax
  8021a9:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8021ac:	eb 56                	jmp    802204 <print_mem_block_lists+0x91>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  8021ae:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8021b2:	74 1c                	je     8021d0 <print_mem_block_lists+0x5d>
  8021b4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8021b7:	8b 50 08             	mov    0x8(%eax),%edx
  8021ba:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8021bd:	8b 48 08             	mov    0x8(%eax),%ecx
  8021c0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8021c3:	8b 40 0c             	mov    0xc(%eax),%eax
  8021c6:	01 c8                	add    %ecx,%eax
  8021c8:	39 c2                	cmp    %eax,%edx
  8021ca:	73 04                	jae    8021d0 <print_mem_block_lists+0x5d>
			sorted = 0 ;
  8021cc:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  8021d0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8021d3:	8b 50 08             	mov    0x8(%eax),%edx
  8021d6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8021d9:	8b 40 0c             	mov    0xc(%eax),%eax
  8021dc:	01 c2                	add    %eax,%edx
  8021de:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8021e1:	8b 40 08             	mov    0x8(%eax),%eax
  8021e4:	83 ec 04             	sub    $0x4,%esp
  8021e7:	52                   	push   %edx
  8021e8:	50                   	push   %eax
  8021e9:	68 c1 3f 80 00       	push   $0x803fc1
  8021ee:	e8 70 e6 ff ff       	call   800863 <cprintf>
  8021f3:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  8021f6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8021f9:	89 45 f0             	mov    %eax,-0x10(%ebp)
	cprintf("\n=========================================\n");
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
	cprintf("\nFreeMemBlocksList:\n");
	uint8 sorted = 1 ;
	LIST_FOREACH(blk, &FreeMemBlocksList)
  8021fc:	a1 40 51 80 00       	mov    0x805140,%eax
  802201:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802204:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802208:	74 07                	je     802211 <print_mem_block_lists+0x9e>
  80220a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80220d:	8b 00                	mov    (%eax),%eax
  80220f:	eb 05                	jmp    802216 <print_mem_block_lists+0xa3>
  802211:	b8 00 00 00 00       	mov    $0x0,%eax
  802216:	a3 40 51 80 00       	mov    %eax,0x805140
  80221b:	a1 40 51 80 00       	mov    0x805140,%eax
  802220:	85 c0                	test   %eax,%eax
  802222:	75 8a                	jne    8021ae <print_mem_block_lists+0x3b>
  802224:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802228:	75 84                	jne    8021ae <print_mem_block_lists+0x3b>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;
  80222a:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  80222e:	75 10                	jne    802240 <print_mem_block_lists+0xcd>
  802230:	83 ec 0c             	sub    $0xc,%esp
  802233:	68 d0 3f 80 00       	push   $0x803fd0
  802238:	e8 26 e6 ff ff       	call   800863 <cprintf>
  80223d:	83 c4 10             	add    $0x10,%esp

	lastBlk = NULL ;
  802240:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nAllocMemBlocksList:\n");
  802247:	83 ec 0c             	sub    $0xc,%esp
  80224a:	68 f4 3f 80 00       	push   $0x803ff4
  80224f:	e8 0f e6 ff ff       	call   800863 <cprintf>
  802254:	83 c4 10             	add    $0x10,%esp
	sorted = 1 ;
  802257:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &AllocMemBlocksList)
  80225b:	a1 40 50 80 00       	mov    0x805040,%eax
  802260:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802263:	eb 56                	jmp    8022bb <print_mem_block_lists+0x148>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  802265:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802269:	74 1c                	je     802287 <print_mem_block_lists+0x114>
  80226b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80226e:	8b 50 08             	mov    0x8(%eax),%edx
  802271:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802274:	8b 48 08             	mov    0x8(%eax),%ecx
  802277:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80227a:	8b 40 0c             	mov    0xc(%eax),%eax
  80227d:	01 c8                	add    %ecx,%eax
  80227f:	39 c2                	cmp    %eax,%edx
  802281:	73 04                	jae    802287 <print_mem_block_lists+0x114>
			sorted = 0 ;
  802283:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  802287:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80228a:	8b 50 08             	mov    0x8(%eax),%edx
  80228d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802290:	8b 40 0c             	mov    0xc(%eax),%eax
  802293:	01 c2                	add    %eax,%edx
  802295:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802298:	8b 40 08             	mov    0x8(%eax),%eax
  80229b:	83 ec 04             	sub    $0x4,%esp
  80229e:	52                   	push   %edx
  80229f:	50                   	push   %eax
  8022a0:	68 c1 3f 80 00       	push   $0x803fc1
  8022a5:	e8 b9 e5 ff ff       	call   800863 <cprintf>
  8022aa:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  8022ad:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022b0:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;

	lastBlk = NULL ;
	cprintf("\nAllocMemBlocksList:\n");
	sorted = 1 ;
	LIST_FOREACH(blk, &AllocMemBlocksList)
  8022b3:	a1 48 50 80 00       	mov    0x805048,%eax
  8022b8:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8022bb:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8022bf:	74 07                	je     8022c8 <print_mem_block_lists+0x155>
  8022c1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022c4:	8b 00                	mov    (%eax),%eax
  8022c6:	eb 05                	jmp    8022cd <print_mem_block_lists+0x15a>
  8022c8:	b8 00 00 00 00       	mov    $0x0,%eax
  8022cd:	a3 48 50 80 00       	mov    %eax,0x805048
  8022d2:	a1 48 50 80 00       	mov    0x805048,%eax
  8022d7:	85 c0                	test   %eax,%eax
  8022d9:	75 8a                	jne    802265 <print_mem_block_lists+0xf2>
  8022db:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8022df:	75 84                	jne    802265 <print_mem_block_lists+0xf2>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nAllocMemBlocksList is NOT SORTED!!\n") ;
  8022e1:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  8022e5:	75 10                	jne    8022f7 <print_mem_block_lists+0x184>
  8022e7:	83 ec 0c             	sub    $0xc,%esp
  8022ea:	68 0c 40 80 00       	push   $0x80400c
  8022ef:	e8 6f e5 ff ff       	call   800863 <cprintf>
  8022f4:	83 c4 10             	add    $0x10,%esp
	cprintf("\n=========================================\n");
  8022f7:	83 ec 0c             	sub    $0xc,%esp
  8022fa:	68 80 3f 80 00       	push   $0x803f80
  8022ff:	e8 5f e5 ff ff       	call   800863 <cprintf>
  802304:	83 c4 10             	add    $0x10,%esp

}
  802307:	90                   	nop
  802308:	c9                   	leave  
  802309:	c3                   	ret    

0080230a <initialize_MemBlocksList>:

//===============================
// [1] INITIALIZE AVAILABLE LIST:
//===============================
void initialize_MemBlocksList(uint32 numOfBlocks)
{
  80230a:	55                   	push   %ebp
  80230b:	89 e5                	mov    %esp,%ebp
  80230d:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] initialize_MemBlocksList
	// Write your code here, remove the panic and write your code
	//panic("initialize_MemBlocksList() is not implemented yet...!!");
	uint32 n = numOfBlocks;
  802310:	8b 45 08             	mov    0x8(%ebp),%eax
  802313:	89 45 f0             	mov    %eax,-0x10(%ebp)

	LIST_INIT(&AvailableMemBlocksList);
  802316:	c7 05 48 51 80 00 00 	movl   $0x0,0x805148
  80231d:	00 00 00 
  802320:	c7 05 4c 51 80 00 00 	movl   $0x0,0x80514c
  802327:	00 00 00 
  80232a:	c7 05 54 51 80 00 00 	movl   $0x0,0x805154
  802331:	00 00 00 
	for(int i = 0; i<n;i++)
  802334:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  80233b:	e9 9e 00 00 00       	jmp    8023de <initialize_MemBlocksList+0xd4>
	{
		LIST_INSERT_HEAD(&AvailableMemBlocksList, &(MemBlockNodes[i]));
  802340:	a1 50 50 80 00       	mov    0x805050,%eax
  802345:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802348:	c1 e2 04             	shl    $0x4,%edx
  80234b:	01 d0                	add    %edx,%eax
  80234d:	85 c0                	test   %eax,%eax
  80234f:	75 14                	jne    802365 <initialize_MemBlocksList+0x5b>
  802351:	83 ec 04             	sub    $0x4,%esp
  802354:	68 34 40 80 00       	push   $0x804034
  802359:	6a 47                	push   $0x47
  80235b:	68 57 40 80 00       	push   $0x804057
  802360:	e8 4a e2 ff ff       	call   8005af <_panic>
  802365:	a1 50 50 80 00       	mov    0x805050,%eax
  80236a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80236d:	c1 e2 04             	shl    $0x4,%edx
  802370:	01 d0                	add    %edx,%eax
  802372:	8b 15 48 51 80 00    	mov    0x805148,%edx
  802378:	89 10                	mov    %edx,(%eax)
  80237a:	8b 00                	mov    (%eax),%eax
  80237c:	85 c0                	test   %eax,%eax
  80237e:	74 18                	je     802398 <initialize_MemBlocksList+0x8e>
  802380:	a1 48 51 80 00       	mov    0x805148,%eax
  802385:	8b 15 50 50 80 00    	mov    0x805050,%edx
  80238b:	8b 4d f4             	mov    -0xc(%ebp),%ecx
  80238e:	c1 e1 04             	shl    $0x4,%ecx
  802391:	01 ca                	add    %ecx,%edx
  802393:	89 50 04             	mov    %edx,0x4(%eax)
  802396:	eb 12                	jmp    8023aa <initialize_MemBlocksList+0xa0>
  802398:	a1 50 50 80 00       	mov    0x805050,%eax
  80239d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8023a0:	c1 e2 04             	shl    $0x4,%edx
  8023a3:	01 d0                	add    %edx,%eax
  8023a5:	a3 4c 51 80 00       	mov    %eax,0x80514c
  8023aa:	a1 50 50 80 00       	mov    0x805050,%eax
  8023af:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8023b2:	c1 e2 04             	shl    $0x4,%edx
  8023b5:	01 d0                	add    %edx,%eax
  8023b7:	a3 48 51 80 00       	mov    %eax,0x805148
  8023bc:	a1 50 50 80 00       	mov    0x805050,%eax
  8023c1:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8023c4:	c1 e2 04             	shl    $0x4,%edx
  8023c7:	01 d0                	add    %edx,%eax
  8023c9:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8023d0:	a1 54 51 80 00       	mov    0x805154,%eax
  8023d5:	40                   	inc    %eax
  8023d6:	a3 54 51 80 00       	mov    %eax,0x805154
	// Write your code here, remove the panic and write your code
	//panic("initialize_MemBlocksList() is not implemented yet...!!");
	uint32 n = numOfBlocks;

	LIST_INIT(&AvailableMemBlocksList);
	for(int i = 0; i<n;i++)
  8023db:	ff 45 f4             	incl   -0xc(%ebp)
  8023de:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023e1:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8023e4:	0f 82 56 ff ff ff    	jb     802340 <initialize_MemBlocksList+0x36>
	{
		LIST_INSERT_HEAD(&AvailableMemBlocksList, &(MemBlockNodes[i]));
	}
}
  8023ea:	90                   	nop
  8023eb:	c9                   	leave  
  8023ec:	c3                   	ret    

008023ed <find_block>:

//===============================
// [2] FIND BLOCK:
//===============================
struct MemBlock *find_block(struct MemBlock_List *blockList, uint32 va)
{
  8023ed:	55                   	push   %ebp
  8023ee:	89 e5                	mov    %esp,%ebp
  8023f0:	83 ec 10             	sub    $0x10,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] find_block
	// Write your code here, remove the panic and write your code
	//panic("find_block() is not implemented yet...!!");
	uint32 virAddress = va;
  8023f3:	8b 45 0c             	mov    0xc(%ebp),%eax
  8023f6:	89 45 f4             	mov    %eax,-0xc(%ebp)
	struct MemBlock* blk;
	int found = 0;
  8023f9:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	LIST_FOREACH(blk, &(AllocMemBlocksList))
  802400:	a1 40 50 80 00       	mov    0x805040,%eax
  802405:	89 45 fc             	mov    %eax,-0x4(%ebp)
  802408:	eb 23                	jmp    80242d <find_block+0x40>
	{
		if(blk->sva == virAddress)
  80240a:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80240d:	8b 40 08             	mov    0x8(%eax),%eax
  802410:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  802413:	75 09                	jne    80241e <find_block+0x31>
		{
			found = 1;
  802415:	c7 45 f8 01 00 00 00 	movl   $0x1,-0x8(%ebp)
			break;
  80241c:	eb 35                	jmp    802453 <find_block+0x66>
		}
		else
		{
			found = 0;
  80241e:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	//panic("find_block() is not implemented yet...!!");
	uint32 virAddress = va;
	struct MemBlock* blk;
	int found = 0;

	LIST_FOREACH(blk, &(AllocMemBlocksList))
  802425:	a1 48 50 80 00       	mov    0x805048,%eax
  80242a:	89 45 fc             	mov    %eax,-0x4(%ebp)
  80242d:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  802431:	74 07                	je     80243a <find_block+0x4d>
  802433:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802436:	8b 00                	mov    (%eax),%eax
  802438:	eb 05                	jmp    80243f <find_block+0x52>
  80243a:	b8 00 00 00 00       	mov    $0x0,%eax
  80243f:	a3 48 50 80 00       	mov    %eax,0x805048
  802444:	a1 48 50 80 00       	mov    0x805048,%eax
  802449:	85 c0                	test   %eax,%eax
  80244b:	75 bd                	jne    80240a <find_block+0x1d>
  80244d:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  802451:	75 b7                	jne    80240a <find_block+0x1d>
		{
			found = 0;
			continue;
		}
	}
	if(found == 1)
  802453:	83 7d f8 01          	cmpl   $0x1,-0x8(%ebp)
  802457:	75 05                	jne    80245e <find_block+0x71>
	{
		return blk;
  802459:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80245c:	eb 05                	jmp    802463 <find_block+0x76>
	}
	else
	{
		return NULL;
  80245e:	b8 00 00 00 00       	mov    $0x0,%eax
	}
}
  802463:	c9                   	leave  
  802464:	c3                   	ret    

00802465 <insert_sorted_allocList>:

//=========================================
// [3] INSERT BLOCK IN ALLOC LIST [SORTED]:
//=========================================
void insert_sorted_allocList(struct MemBlock *blockToInsert)
{
  802465:	55                   	push   %ebp
  802466:	89 e5                	mov    %esp,%ebp
  802468:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] insert_sorted_allocList
	// Write your code here, remove the panic and write your code
	//panic("insert_sorted_allocList() is not implemented yet...!!");
	struct MemBlock* blk;
	struct MemBlock* newblk = blockToInsert;
  80246b:	8b 45 08             	mov    0x8(%ebp),%eax
  80246e:	89 45 f0             	mov    %eax,-0x10(%ebp)

	if((LIST_EMPTY(&AllocMemBlocksList)) || (newblk->sva < LIST_FIRST(&AllocMemBlocksList)->sva))
  802471:	a1 40 50 80 00       	mov    0x805040,%eax
  802476:	85 c0                	test   %eax,%eax
  802478:	74 12                	je     80248c <insert_sorted_allocList+0x27>
  80247a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80247d:	8b 50 08             	mov    0x8(%eax),%edx
  802480:	a1 40 50 80 00       	mov    0x805040,%eax
  802485:	8b 40 08             	mov    0x8(%eax),%eax
  802488:	39 c2                	cmp    %eax,%edx
  80248a:	73 65                	jae    8024f1 <insert_sorted_allocList+0x8c>
	{
		LIST_INSERT_HEAD(&(AllocMemBlocksList), newblk);
  80248c:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802490:	75 14                	jne    8024a6 <insert_sorted_allocList+0x41>
  802492:	83 ec 04             	sub    $0x4,%esp
  802495:	68 34 40 80 00       	push   $0x804034
  80249a:	6a 7b                	push   $0x7b
  80249c:	68 57 40 80 00       	push   $0x804057
  8024a1:	e8 09 e1 ff ff       	call   8005af <_panic>
  8024a6:	8b 15 40 50 80 00    	mov    0x805040,%edx
  8024ac:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8024af:	89 10                	mov    %edx,(%eax)
  8024b1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8024b4:	8b 00                	mov    (%eax),%eax
  8024b6:	85 c0                	test   %eax,%eax
  8024b8:	74 0d                	je     8024c7 <insert_sorted_allocList+0x62>
  8024ba:	a1 40 50 80 00       	mov    0x805040,%eax
  8024bf:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8024c2:	89 50 04             	mov    %edx,0x4(%eax)
  8024c5:	eb 08                	jmp    8024cf <insert_sorted_allocList+0x6a>
  8024c7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8024ca:	a3 44 50 80 00       	mov    %eax,0x805044
  8024cf:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8024d2:	a3 40 50 80 00       	mov    %eax,0x805040
  8024d7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8024da:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8024e1:	a1 4c 50 80 00       	mov    0x80504c,%eax
  8024e6:	40                   	inc    %eax
  8024e7:	a3 4c 50 80 00       	mov    %eax,0x80504c
  8024ec:	e9 5f 01 00 00       	jmp    802650 <insert_sorted_allocList+0x1eb>
	}
	else if(newblk->sva > LIST_LAST(&AllocMemBlocksList)->sva)
  8024f1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8024f4:	8b 50 08             	mov    0x8(%eax),%edx
  8024f7:	a1 44 50 80 00       	mov    0x805044,%eax
  8024fc:	8b 40 08             	mov    0x8(%eax),%eax
  8024ff:	39 c2                	cmp    %eax,%edx
  802501:	76 65                	jbe    802568 <insert_sorted_allocList+0x103>
	{
		LIST_INSERT_TAIL(&AllocMemBlocksList, newblk);
  802503:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802507:	75 14                	jne    80251d <insert_sorted_allocList+0xb8>
  802509:	83 ec 04             	sub    $0x4,%esp
  80250c:	68 70 40 80 00       	push   $0x804070
  802511:	6a 7f                	push   $0x7f
  802513:	68 57 40 80 00       	push   $0x804057
  802518:	e8 92 e0 ff ff       	call   8005af <_panic>
  80251d:	8b 15 44 50 80 00    	mov    0x805044,%edx
  802523:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802526:	89 50 04             	mov    %edx,0x4(%eax)
  802529:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80252c:	8b 40 04             	mov    0x4(%eax),%eax
  80252f:	85 c0                	test   %eax,%eax
  802531:	74 0c                	je     80253f <insert_sorted_allocList+0xda>
  802533:	a1 44 50 80 00       	mov    0x805044,%eax
  802538:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80253b:	89 10                	mov    %edx,(%eax)
  80253d:	eb 08                	jmp    802547 <insert_sorted_allocList+0xe2>
  80253f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802542:	a3 40 50 80 00       	mov    %eax,0x805040
  802547:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80254a:	a3 44 50 80 00       	mov    %eax,0x805044
  80254f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802552:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802558:	a1 4c 50 80 00       	mov    0x80504c,%eax
  80255d:	40                   	inc    %eax
  80255e:	a3 4c 50 80 00       	mov    %eax,0x80504c
				LIST_INSERT_AFTER(&AllocMemBlocksList, blk, newblk);
				break;
			}
		}
	}
}
  802563:	e9 e8 00 00 00       	jmp    802650 <insert_sorted_allocList+0x1eb>
	{
		LIST_INSERT_TAIL(&AllocMemBlocksList, newblk);
	}
	else
	{
		LIST_FOREACH(blk, &AllocMemBlocksList)
  802568:	a1 40 50 80 00       	mov    0x805040,%eax
  80256d:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802570:	e9 ab 00 00 00       	jmp    802620 <insert_sorted_allocList+0x1bb>
		{
			if(blk->prev_next_info.le_next != NULL && newblk->sva > blk->sva  && newblk->sva < blk->prev_next_info.le_next->sva)
  802575:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802578:	8b 00                	mov    (%eax),%eax
  80257a:	85 c0                	test   %eax,%eax
  80257c:	0f 84 96 00 00 00    	je     802618 <insert_sorted_allocList+0x1b3>
  802582:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802585:	8b 50 08             	mov    0x8(%eax),%edx
  802588:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80258b:	8b 40 08             	mov    0x8(%eax),%eax
  80258e:	39 c2                	cmp    %eax,%edx
  802590:	0f 86 82 00 00 00    	jbe    802618 <insert_sorted_allocList+0x1b3>
  802596:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802599:	8b 50 08             	mov    0x8(%eax),%edx
  80259c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80259f:	8b 00                	mov    (%eax),%eax
  8025a1:	8b 40 08             	mov    0x8(%eax),%eax
  8025a4:	39 c2                	cmp    %eax,%edx
  8025a6:	73 70                	jae    802618 <insert_sorted_allocList+0x1b3>
			{
				LIST_INSERT_AFTER(&AllocMemBlocksList, blk, newblk);
  8025a8:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8025ac:	74 06                	je     8025b4 <insert_sorted_allocList+0x14f>
  8025ae:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8025b2:	75 17                	jne    8025cb <insert_sorted_allocList+0x166>
  8025b4:	83 ec 04             	sub    $0x4,%esp
  8025b7:	68 94 40 80 00       	push   $0x804094
  8025bc:	68 87 00 00 00       	push   $0x87
  8025c1:	68 57 40 80 00       	push   $0x804057
  8025c6:	e8 e4 df ff ff       	call   8005af <_panic>
  8025cb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025ce:	8b 10                	mov    (%eax),%edx
  8025d0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8025d3:	89 10                	mov    %edx,(%eax)
  8025d5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8025d8:	8b 00                	mov    (%eax),%eax
  8025da:	85 c0                	test   %eax,%eax
  8025dc:	74 0b                	je     8025e9 <insert_sorted_allocList+0x184>
  8025de:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025e1:	8b 00                	mov    (%eax),%eax
  8025e3:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8025e6:	89 50 04             	mov    %edx,0x4(%eax)
  8025e9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025ec:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8025ef:	89 10                	mov    %edx,(%eax)
  8025f1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8025f4:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8025f7:	89 50 04             	mov    %edx,0x4(%eax)
  8025fa:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8025fd:	8b 00                	mov    (%eax),%eax
  8025ff:	85 c0                	test   %eax,%eax
  802601:	75 08                	jne    80260b <insert_sorted_allocList+0x1a6>
  802603:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802606:	a3 44 50 80 00       	mov    %eax,0x805044
  80260b:	a1 4c 50 80 00       	mov    0x80504c,%eax
  802610:	40                   	inc    %eax
  802611:	a3 4c 50 80 00       	mov    %eax,0x80504c
				break;
  802616:	eb 38                	jmp    802650 <insert_sorted_allocList+0x1eb>
	{
		LIST_INSERT_TAIL(&AllocMemBlocksList, newblk);
	}
	else
	{
		LIST_FOREACH(blk, &AllocMemBlocksList)
  802618:	a1 48 50 80 00       	mov    0x805048,%eax
  80261d:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802620:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802624:	74 07                	je     80262d <insert_sorted_allocList+0x1c8>
  802626:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802629:	8b 00                	mov    (%eax),%eax
  80262b:	eb 05                	jmp    802632 <insert_sorted_allocList+0x1cd>
  80262d:	b8 00 00 00 00       	mov    $0x0,%eax
  802632:	a3 48 50 80 00       	mov    %eax,0x805048
  802637:	a1 48 50 80 00       	mov    0x805048,%eax
  80263c:	85 c0                	test   %eax,%eax
  80263e:	0f 85 31 ff ff ff    	jne    802575 <insert_sorted_allocList+0x110>
  802644:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802648:	0f 85 27 ff ff ff    	jne    802575 <insert_sorted_allocList+0x110>
				LIST_INSERT_AFTER(&AllocMemBlocksList, blk, newblk);
				break;
			}
		}
	}
}
  80264e:	eb 00                	jmp    802650 <insert_sorted_allocList+0x1eb>
  802650:	90                   	nop
  802651:	c9                   	leave  
  802652:	c3                   	ret    

00802653 <alloc_block_FF>:

//=========================================
// [4] ALLOCATE BLOCK BY FIRST FIT:
//=========================================
struct MemBlock *alloc_block_FF(uint32 size)
{
  802653:	55                   	push   %ebp
  802654:	89 e5                	mov    %esp,%ebp
  802656:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_FF
	// Write your code here, remove the panic and write your code
	//panic("alloc_block_FF() is not implemented yet...!!");
	uint32 versize = size;
  802659:	8b 45 08             	mov    0x8(%ebp),%eax
  80265c:	89 45 f0             	mov    %eax,-0x10(%ebp)
	struct MemBlock* blk;
	struct MemBlock* newblk = LIST_FIRST(&AvailableMemBlocksList);
  80265f:	a1 48 51 80 00       	mov    0x805148,%eax
  802664:	89 45 ec             	mov    %eax,-0x14(%ebp)

	LIST_FOREACH(blk,&FreeMemBlocksList)
  802667:	a1 38 51 80 00       	mov    0x805138,%eax
  80266c:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80266f:	e9 77 01 00 00       	jmp    8027eb <alloc_block_FF+0x198>
	{
		if(blk->size == versize)
  802674:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802677:	8b 40 0c             	mov    0xc(%eax),%eax
  80267a:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  80267d:	0f 85 8a 00 00 00    	jne    80270d <alloc_block_FF+0xba>
		{
			LIST_REMOVE(&FreeMemBlocksList,blk);
  802683:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802687:	75 17                	jne    8026a0 <alloc_block_FF+0x4d>
  802689:	83 ec 04             	sub    $0x4,%esp
  80268c:	68 c8 40 80 00       	push   $0x8040c8
  802691:	68 9e 00 00 00       	push   $0x9e
  802696:	68 57 40 80 00       	push   $0x804057
  80269b:	e8 0f df ff ff       	call   8005af <_panic>
  8026a0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026a3:	8b 00                	mov    (%eax),%eax
  8026a5:	85 c0                	test   %eax,%eax
  8026a7:	74 10                	je     8026b9 <alloc_block_FF+0x66>
  8026a9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026ac:	8b 00                	mov    (%eax),%eax
  8026ae:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8026b1:	8b 52 04             	mov    0x4(%edx),%edx
  8026b4:	89 50 04             	mov    %edx,0x4(%eax)
  8026b7:	eb 0b                	jmp    8026c4 <alloc_block_FF+0x71>
  8026b9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026bc:	8b 40 04             	mov    0x4(%eax),%eax
  8026bf:	a3 3c 51 80 00       	mov    %eax,0x80513c
  8026c4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026c7:	8b 40 04             	mov    0x4(%eax),%eax
  8026ca:	85 c0                	test   %eax,%eax
  8026cc:	74 0f                	je     8026dd <alloc_block_FF+0x8a>
  8026ce:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026d1:	8b 40 04             	mov    0x4(%eax),%eax
  8026d4:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8026d7:	8b 12                	mov    (%edx),%edx
  8026d9:	89 10                	mov    %edx,(%eax)
  8026db:	eb 0a                	jmp    8026e7 <alloc_block_FF+0x94>
  8026dd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026e0:	8b 00                	mov    (%eax),%eax
  8026e2:	a3 38 51 80 00       	mov    %eax,0x805138
  8026e7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026ea:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8026f0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026f3:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8026fa:	a1 44 51 80 00       	mov    0x805144,%eax
  8026ff:	48                   	dec    %eax
  802700:	a3 44 51 80 00       	mov    %eax,0x805144
			return blk;
  802705:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802708:	e9 11 01 00 00       	jmp    80281e <alloc_block_FF+0x1cb>
		}
		else if(blk->size > versize)
  80270d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802710:	8b 40 0c             	mov    0xc(%eax),%eax
  802713:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  802716:	0f 86 c7 00 00 00    	jbe    8027e3 <alloc_block_FF+0x190>
		{
			LIST_REMOVE(&AvailableMemBlocksList,newblk);
  80271c:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802720:	75 17                	jne    802739 <alloc_block_FF+0xe6>
  802722:	83 ec 04             	sub    $0x4,%esp
  802725:	68 c8 40 80 00       	push   $0x8040c8
  80272a:	68 a3 00 00 00       	push   $0xa3
  80272f:	68 57 40 80 00       	push   $0x804057
  802734:	e8 76 de ff ff       	call   8005af <_panic>
  802739:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80273c:	8b 00                	mov    (%eax),%eax
  80273e:	85 c0                	test   %eax,%eax
  802740:	74 10                	je     802752 <alloc_block_FF+0xff>
  802742:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802745:	8b 00                	mov    (%eax),%eax
  802747:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80274a:	8b 52 04             	mov    0x4(%edx),%edx
  80274d:	89 50 04             	mov    %edx,0x4(%eax)
  802750:	eb 0b                	jmp    80275d <alloc_block_FF+0x10a>
  802752:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802755:	8b 40 04             	mov    0x4(%eax),%eax
  802758:	a3 4c 51 80 00       	mov    %eax,0x80514c
  80275d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802760:	8b 40 04             	mov    0x4(%eax),%eax
  802763:	85 c0                	test   %eax,%eax
  802765:	74 0f                	je     802776 <alloc_block_FF+0x123>
  802767:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80276a:	8b 40 04             	mov    0x4(%eax),%eax
  80276d:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802770:	8b 12                	mov    (%edx),%edx
  802772:	89 10                	mov    %edx,(%eax)
  802774:	eb 0a                	jmp    802780 <alloc_block_FF+0x12d>
  802776:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802779:	8b 00                	mov    (%eax),%eax
  80277b:	a3 48 51 80 00       	mov    %eax,0x805148
  802780:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802783:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802789:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80278c:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802793:	a1 54 51 80 00       	mov    0x805154,%eax
  802798:	48                   	dec    %eax
  802799:	a3 54 51 80 00       	mov    %eax,0x805154
			newblk->size = versize;
  80279e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8027a1:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8027a4:	89 50 0c             	mov    %edx,0xc(%eax)
			blk->size = blk->size-versize;
  8027a7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027aa:	8b 40 0c             	mov    0xc(%eax),%eax
  8027ad:	2b 45 f0             	sub    -0x10(%ebp),%eax
  8027b0:	89 c2                	mov    %eax,%edx
  8027b2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027b5:	89 50 0c             	mov    %edx,0xc(%eax)
			uint32 newveradd = blk->sva;
  8027b8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027bb:	8b 40 08             	mov    0x8(%eax),%eax
  8027be:	89 45 e8             	mov    %eax,-0x18(%ebp)
			blk->sva+=newblk->size;
  8027c1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027c4:	8b 50 08             	mov    0x8(%eax),%edx
  8027c7:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8027ca:	8b 40 0c             	mov    0xc(%eax),%eax
  8027cd:	01 c2                	add    %eax,%edx
  8027cf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027d2:	89 50 08             	mov    %edx,0x8(%eax)
			newblk->sva = newveradd;
  8027d5:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8027d8:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8027db:	89 50 08             	mov    %edx,0x8(%eax)
			return newblk;
  8027de:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8027e1:	eb 3b                	jmp    80281e <alloc_block_FF+0x1cb>
	//panic("alloc_block_FF() is not implemented yet...!!");
	uint32 versize = size;
	struct MemBlock* blk;
	struct MemBlock* newblk = LIST_FIRST(&AvailableMemBlocksList);

	LIST_FOREACH(blk,&FreeMemBlocksList)
  8027e3:	a1 40 51 80 00       	mov    0x805140,%eax
  8027e8:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8027eb:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8027ef:	74 07                	je     8027f8 <alloc_block_FF+0x1a5>
  8027f1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027f4:	8b 00                	mov    (%eax),%eax
  8027f6:	eb 05                	jmp    8027fd <alloc_block_FF+0x1aa>
  8027f8:	b8 00 00 00 00       	mov    $0x0,%eax
  8027fd:	a3 40 51 80 00       	mov    %eax,0x805140
  802802:	a1 40 51 80 00       	mov    0x805140,%eax
  802807:	85 c0                	test   %eax,%eax
  802809:	0f 85 65 fe ff ff    	jne    802674 <alloc_block_FF+0x21>
  80280f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802813:	0f 85 5b fe ff ff    	jne    802674 <alloc_block_FF+0x21>
			blk->sva+=newblk->size;
			newblk->sva = newveradd;
			return newblk;
		}
	}
	return NULL;
  802819:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80281e:	c9                   	leave  
  80281f:	c3                   	ret    

00802820 <alloc_block_BF>:

//=========================================
// [5] ALLOCATE BLOCK BY BEST FIT:
//=========================================
struct MemBlock *alloc_block_BF(uint32 size)
{
  802820:	55                   	push   %ebp
  802821:	89 e5                	mov    %esp,%ebp
  802823:	83 ec 28             	sub    $0x28,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_BF
	// Write your code here, remove the panic and write your code
	//panic("alloc_block_BF() is not implemented yet...!!");
	uint32 versize=size;
  802826:	8b 45 08             	mov    0x8(%ebp),%eax
  802829:	89 45 e8             	mov    %eax,-0x18(%ebp)
	struct MemBlock* blk;
	struct MemBlock* newblk=LIST_FIRST(&AvailableMemBlocksList);
  80282c:	a1 48 51 80 00       	mov    0x805148,%eax
  802831:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	uint32 newveradd;
	uint32 newsize;
	int size_free = LIST_SIZE(&FreeMemBlocksList);
  802834:	a1 44 51 80 00       	mov    0x805144,%eax
  802839:	89 45 e0             	mov    %eax,-0x20(%ebp)

	LIST_FOREACH(blk, &FreeMemBlocksList)
  80283c:	a1 38 51 80 00       	mov    0x805138,%eax
  802841:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802844:	e9 a1 00 00 00       	jmp    8028ea <alloc_block_BF+0xca>
	{
		if(blk->size == versize)
  802849:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80284c:	8b 40 0c             	mov    0xc(%eax),%eax
  80284f:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  802852:	0f 85 8a 00 00 00    	jne    8028e2 <alloc_block_BF+0xc2>
		{
			LIST_REMOVE(&FreeMemBlocksList, blk);
  802858:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80285c:	75 17                	jne    802875 <alloc_block_BF+0x55>
  80285e:	83 ec 04             	sub    $0x4,%esp
  802861:	68 c8 40 80 00       	push   $0x8040c8
  802866:	68 c2 00 00 00       	push   $0xc2
  80286b:	68 57 40 80 00       	push   $0x804057
  802870:	e8 3a dd ff ff       	call   8005af <_panic>
  802875:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802878:	8b 00                	mov    (%eax),%eax
  80287a:	85 c0                	test   %eax,%eax
  80287c:	74 10                	je     80288e <alloc_block_BF+0x6e>
  80287e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802881:	8b 00                	mov    (%eax),%eax
  802883:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802886:	8b 52 04             	mov    0x4(%edx),%edx
  802889:	89 50 04             	mov    %edx,0x4(%eax)
  80288c:	eb 0b                	jmp    802899 <alloc_block_BF+0x79>
  80288e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802891:	8b 40 04             	mov    0x4(%eax),%eax
  802894:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802899:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80289c:	8b 40 04             	mov    0x4(%eax),%eax
  80289f:	85 c0                	test   %eax,%eax
  8028a1:	74 0f                	je     8028b2 <alloc_block_BF+0x92>
  8028a3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028a6:	8b 40 04             	mov    0x4(%eax),%eax
  8028a9:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8028ac:	8b 12                	mov    (%edx),%edx
  8028ae:	89 10                	mov    %edx,(%eax)
  8028b0:	eb 0a                	jmp    8028bc <alloc_block_BF+0x9c>
  8028b2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028b5:	8b 00                	mov    (%eax),%eax
  8028b7:	a3 38 51 80 00       	mov    %eax,0x805138
  8028bc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028bf:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8028c5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028c8:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8028cf:	a1 44 51 80 00       	mov    0x805144,%eax
  8028d4:	48                   	dec    %eax
  8028d5:	a3 44 51 80 00       	mov    %eax,0x805144
			return blk;
  8028da:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028dd:	e9 11 02 00 00       	jmp    802af3 <alloc_block_BF+0x2d3>
	struct MemBlock* newblk=LIST_FIRST(&AvailableMemBlocksList);
	uint32 newveradd;
	uint32 newsize;
	int size_free = LIST_SIZE(&FreeMemBlocksList);

	LIST_FOREACH(blk, &FreeMemBlocksList)
  8028e2:	a1 40 51 80 00       	mov    0x805140,%eax
  8028e7:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8028ea:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8028ee:	74 07                	je     8028f7 <alloc_block_BF+0xd7>
  8028f0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028f3:	8b 00                	mov    (%eax),%eax
  8028f5:	eb 05                	jmp    8028fc <alloc_block_BF+0xdc>
  8028f7:	b8 00 00 00 00       	mov    $0x0,%eax
  8028fc:	a3 40 51 80 00       	mov    %eax,0x805140
  802901:	a1 40 51 80 00       	mov    0x805140,%eax
  802906:	85 c0                	test   %eax,%eax
  802908:	0f 85 3b ff ff ff    	jne    802849 <alloc_block_BF+0x29>
  80290e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802912:	0f 85 31 ff ff ff    	jne    802849 <alloc_block_BF+0x29>
		{
			LIST_REMOVE(&FreeMemBlocksList, blk);
			return blk;
		}
	}
	LIST_FOREACH(blk, &FreeMemBlocksList)
  802918:	a1 38 51 80 00       	mov    0x805138,%eax
  80291d:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802920:	eb 27                	jmp    802949 <alloc_block_BF+0x129>
	{
		if(blk->size > versize)
  802922:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802925:	8b 40 0c             	mov    0xc(%eax),%eax
  802928:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  80292b:	76 14                	jbe    802941 <alloc_block_BF+0x121>
		{
			newsize = blk->size;
  80292d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802930:	8b 40 0c             	mov    0xc(%eax),%eax
  802933:	89 45 ec             	mov    %eax,-0x14(%ebp)
			newveradd = blk->sva;
  802936:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802939:	8b 40 08             	mov    0x8(%eax),%eax
  80293c:	89 45 f0             	mov    %eax,-0x10(%ebp)
			break;
  80293f:	eb 2e                	jmp    80296f <alloc_block_BF+0x14f>
		{
			LIST_REMOVE(&FreeMemBlocksList, blk);
			return blk;
		}
	}
	LIST_FOREACH(blk, &FreeMemBlocksList)
  802941:	a1 40 51 80 00       	mov    0x805140,%eax
  802946:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802949:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80294d:	74 07                	je     802956 <alloc_block_BF+0x136>
  80294f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802952:	8b 00                	mov    (%eax),%eax
  802954:	eb 05                	jmp    80295b <alloc_block_BF+0x13b>
  802956:	b8 00 00 00 00       	mov    $0x0,%eax
  80295b:	a3 40 51 80 00       	mov    %eax,0x805140
  802960:	a1 40 51 80 00       	mov    0x805140,%eax
  802965:	85 c0                	test   %eax,%eax
  802967:	75 b9                	jne    802922 <alloc_block_BF+0x102>
  802969:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80296d:	75 b3                	jne    802922 <alloc_block_BF+0x102>
			newsize = blk->size;
			newveradd = blk->sva;
			break;
		}
	}
	LIST_FOREACH(blk, &FreeMemBlocksList)
  80296f:	a1 38 51 80 00       	mov    0x805138,%eax
  802974:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802977:	eb 30                	jmp    8029a9 <alloc_block_BF+0x189>
	{
		if(newsize > blk->size && blk->size > versize)
  802979:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80297c:	8b 40 0c             	mov    0xc(%eax),%eax
  80297f:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  802982:	73 1d                	jae    8029a1 <alloc_block_BF+0x181>
  802984:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802987:	8b 40 0c             	mov    0xc(%eax),%eax
  80298a:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  80298d:	76 12                	jbe    8029a1 <alloc_block_BF+0x181>
		{
	       newsize = blk->size;
  80298f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802992:	8b 40 0c             	mov    0xc(%eax),%eax
  802995:	89 45 ec             	mov    %eax,-0x14(%ebp)
		   newveradd = blk->sva;
  802998:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80299b:	8b 40 08             	mov    0x8(%eax),%eax
  80299e:	89 45 f0             	mov    %eax,-0x10(%ebp)
			newsize = blk->size;
			newveradd = blk->sva;
			break;
		}
	}
	LIST_FOREACH(blk, &FreeMemBlocksList)
  8029a1:	a1 40 51 80 00       	mov    0x805140,%eax
  8029a6:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8029a9:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8029ad:	74 07                	je     8029b6 <alloc_block_BF+0x196>
  8029af:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029b2:	8b 00                	mov    (%eax),%eax
  8029b4:	eb 05                	jmp    8029bb <alloc_block_BF+0x19b>
  8029b6:	b8 00 00 00 00       	mov    $0x0,%eax
  8029bb:	a3 40 51 80 00       	mov    %eax,0x805140
  8029c0:	a1 40 51 80 00       	mov    0x805140,%eax
  8029c5:	85 c0                	test   %eax,%eax
  8029c7:	75 b0                	jne    802979 <alloc_block_BF+0x159>
  8029c9:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8029cd:	75 aa                	jne    802979 <alloc_block_BF+0x159>
		{
	       newsize = blk->size;
		   newveradd = blk->sva;
		}
	}
	LIST_FOREACH(blk, &FreeMemBlocksList)
  8029cf:	a1 38 51 80 00       	mov    0x805138,%eax
  8029d4:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8029d7:	e9 e4 00 00 00       	jmp    802ac0 <alloc_block_BF+0x2a0>
	{
		if(blk->size == newsize && blk->sva == newveradd)
  8029dc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029df:	8b 40 0c             	mov    0xc(%eax),%eax
  8029e2:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  8029e5:	0f 85 cd 00 00 00    	jne    802ab8 <alloc_block_BF+0x298>
  8029eb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029ee:	8b 40 08             	mov    0x8(%eax),%eax
  8029f1:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8029f4:	0f 85 be 00 00 00    	jne    802ab8 <alloc_block_BF+0x298>
		{
			LIST_REMOVE(&AvailableMemBlocksList, newblk);
  8029fa:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8029fe:	75 17                	jne    802a17 <alloc_block_BF+0x1f7>
  802a00:	83 ec 04             	sub    $0x4,%esp
  802a03:	68 c8 40 80 00       	push   $0x8040c8
  802a08:	68 db 00 00 00       	push   $0xdb
  802a0d:	68 57 40 80 00       	push   $0x804057
  802a12:	e8 98 db ff ff       	call   8005af <_panic>
  802a17:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802a1a:	8b 00                	mov    (%eax),%eax
  802a1c:	85 c0                	test   %eax,%eax
  802a1e:	74 10                	je     802a30 <alloc_block_BF+0x210>
  802a20:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802a23:	8b 00                	mov    (%eax),%eax
  802a25:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802a28:	8b 52 04             	mov    0x4(%edx),%edx
  802a2b:	89 50 04             	mov    %edx,0x4(%eax)
  802a2e:	eb 0b                	jmp    802a3b <alloc_block_BF+0x21b>
  802a30:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802a33:	8b 40 04             	mov    0x4(%eax),%eax
  802a36:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802a3b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802a3e:	8b 40 04             	mov    0x4(%eax),%eax
  802a41:	85 c0                	test   %eax,%eax
  802a43:	74 0f                	je     802a54 <alloc_block_BF+0x234>
  802a45:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802a48:	8b 40 04             	mov    0x4(%eax),%eax
  802a4b:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802a4e:	8b 12                	mov    (%edx),%edx
  802a50:	89 10                	mov    %edx,(%eax)
  802a52:	eb 0a                	jmp    802a5e <alloc_block_BF+0x23e>
  802a54:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802a57:	8b 00                	mov    (%eax),%eax
  802a59:	a3 48 51 80 00       	mov    %eax,0x805148
  802a5e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802a61:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802a67:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802a6a:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802a71:	a1 54 51 80 00       	mov    0x805154,%eax
  802a76:	48                   	dec    %eax
  802a77:	a3 54 51 80 00       	mov    %eax,0x805154
			newblk->size = versize;
  802a7c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802a7f:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802a82:	89 50 0c             	mov    %edx,0xc(%eax)
			newblk->sva = newveradd;
  802a85:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802a88:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802a8b:	89 50 08             	mov    %edx,0x8(%eax)
			blk->size = blk->size - versize;
  802a8e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a91:	8b 40 0c             	mov    0xc(%eax),%eax
  802a94:	2b 45 e8             	sub    -0x18(%ebp),%eax
  802a97:	89 c2                	mov    %eax,%edx
  802a99:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a9c:	89 50 0c             	mov    %edx,0xc(%eax)
			blk->sva+= newblk->size;
  802a9f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802aa2:	8b 50 08             	mov    0x8(%eax),%edx
  802aa5:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802aa8:	8b 40 0c             	mov    0xc(%eax),%eax
  802aab:	01 c2                	add    %eax,%edx
  802aad:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ab0:	89 50 08             	mov    %edx,0x8(%eax)
			return newblk;
  802ab3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802ab6:	eb 3b                	jmp    802af3 <alloc_block_BF+0x2d3>
		{
	       newsize = blk->size;
		   newveradd = blk->sva;
		}
	}
	LIST_FOREACH(blk, &FreeMemBlocksList)
  802ab8:	a1 40 51 80 00       	mov    0x805140,%eax
  802abd:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802ac0:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802ac4:	74 07                	je     802acd <alloc_block_BF+0x2ad>
  802ac6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ac9:	8b 00                	mov    (%eax),%eax
  802acb:	eb 05                	jmp    802ad2 <alloc_block_BF+0x2b2>
  802acd:	b8 00 00 00 00       	mov    $0x0,%eax
  802ad2:	a3 40 51 80 00       	mov    %eax,0x805140
  802ad7:	a1 40 51 80 00       	mov    0x805140,%eax
  802adc:	85 c0                	test   %eax,%eax
  802ade:	0f 85 f8 fe ff ff    	jne    8029dc <alloc_block_BF+0x1bc>
  802ae4:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802ae8:	0f 85 ee fe ff ff    	jne    8029dc <alloc_block_BF+0x1bc>
			blk->size = blk->size - versize;
			blk->sva+= newblk->size;
			return newblk;
		}
	}
	return NULL;
  802aee:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802af3:	c9                   	leave  
  802af4:	c3                   	ret    

00802af5 <alloc_block_NF>:
//=========================================
// [7] ALLOCATE BLOCK BY NEXT FIT:
//=========================================
struct MemBlock *last_allocate;
struct MemBlock *alloc_block_NF(uint32 size)
{
  802af5:	55                   	push   %ebp
  802af6:	89 e5                	mov    %esp,%ebp
  802af8:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1 - BONUS] [DYNAMIC ALLOCATOR] alloc_block_NF
	// Write your code here, remove the panic and write your code
	//panic("alloc_block_NF() is not implemented yet...!!");
	uint32 versize = size;
  802afb:	8b 45 08             	mov    0x8(%ebp),%eax
  802afe:	89 45 f0             	mov    %eax,-0x10(%ebp)
	struct MemBlock* blk;
	struct MemBlock* newblk = LIST_FIRST(&AvailableMemBlocksList);
  802b01:	a1 48 51 80 00       	mov    0x805148,%eax
  802b06:	89 45 ec             	mov    %eax,-0x14(%ebp)

	LIST_FOREACH(blk,&FreeMemBlocksList)
  802b09:	a1 38 51 80 00       	mov    0x805138,%eax
  802b0e:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802b11:	e9 77 01 00 00       	jmp    802c8d <alloc_block_NF+0x198>
	{
		if(blk->size == versize)
  802b16:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b19:	8b 40 0c             	mov    0xc(%eax),%eax
  802b1c:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  802b1f:	0f 85 8a 00 00 00    	jne    802baf <alloc_block_NF+0xba>
		{
			LIST_REMOVE(&FreeMemBlocksList,blk);
  802b25:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802b29:	75 17                	jne    802b42 <alloc_block_NF+0x4d>
  802b2b:	83 ec 04             	sub    $0x4,%esp
  802b2e:	68 c8 40 80 00       	push   $0x8040c8
  802b33:	68 f7 00 00 00       	push   $0xf7
  802b38:	68 57 40 80 00       	push   $0x804057
  802b3d:	e8 6d da ff ff       	call   8005af <_panic>
  802b42:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b45:	8b 00                	mov    (%eax),%eax
  802b47:	85 c0                	test   %eax,%eax
  802b49:	74 10                	je     802b5b <alloc_block_NF+0x66>
  802b4b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b4e:	8b 00                	mov    (%eax),%eax
  802b50:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802b53:	8b 52 04             	mov    0x4(%edx),%edx
  802b56:	89 50 04             	mov    %edx,0x4(%eax)
  802b59:	eb 0b                	jmp    802b66 <alloc_block_NF+0x71>
  802b5b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b5e:	8b 40 04             	mov    0x4(%eax),%eax
  802b61:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802b66:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b69:	8b 40 04             	mov    0x4(%eax),%eax
  802b6c:	85 c0                	test   %eax,%eax
  802b6e:	74 0f                	je     802b7f <alloc_block_NF+0x8a>
  802b70:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b73:	8b 40 04             	mov    0x4(%eax),%eax
  802b76:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802b79:	8b 12                	mov    (%edx),%edx
  802b7b:	89 10                	mov    %edx,(%eax)
  802b7d:	eb 0a                	jmp    802b89 <alloc_block_NF+0x94>
  802b7f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b82:	8b 00                	mov    (%eax),%eax
  802b84:	a3 38 51 80 00       	mov    %eax,0x805138
  802b89:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b8c:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802b92:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b95:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802b9c:	a1 44 51 80 00       	mov    0x805144,%eax
  802ba1:	48                   	dec    %eax
  802ba2:	a3 44 51 80 00       	mov    %eax,0x805144
			return blk;
  802ba7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802baa:	e9 11 01 00 00       	jmp    802cc0 <alloc_block_NF+0x1cb>
		}
		else if(blk->size > versize)
  802baf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bb2:	8b 40 0c             	mov    0xc(%eax),%eax
  802bb5:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  802bb8:	0f 86 c7 00 00 00    	jbe    802c85 <alloc_block_NF+0x190>
		{
			LIST_REMOVE(&AvailableMemBlocksList,newblk);
  802bbe:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802bc2:	75 17                	jne    802bdb <alloc_block_NF+0xe6>
  802bc4:	83 ec 04             	sub    $0x4,%esp
  802bc7:	68 c8 40 80 00       	push   $0x8040c8
  802bcc:	68 fc 00 00 00       	push   $0xfc
  802bd1:	68 57 40 80 00       	push   $0x804057
  802bd6:	e8 d4 d9 ff ff       	call   8005af <_panic>
  802bdb:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802bde:	8b 00                	mov    (%eax),%eax
  802be0:	85 c0                	test   %eax,%eax
  802be2:	74 10                	je     802bf4 <alloc_block_NF+0xff>
  802be4:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802be7:	8b 00                	mov    (%eax),%eax
  802be9:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802bec:	8b 52 04             	mov    0x4(%edx),%edx
  802bef:	89 50 04             	mov    %edx,0x4(%eax)
  802bf2:	eb 0b                	jmp    802bff <alloc_block_NF+0x10a>
  802bf4:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802bf7:	8b 40 04             	mov    0x4(%eax),%eax
  802bfa:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802bff:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802c02:	8b 40 04             	mov    0x4(%eax),%eax
  802c05:	85 c0                	test   %eax,%eax
  802c07:	74 0f                	je     802c18 <alloc_block_NF+0x123>
  802c09:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802c0c:	8b 40 04             	mov    0x4(%eax),%eax
  802c0f:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802c12:	8b 12                	mov    (%edx),%edx
  802c14:	89 10                	mov    %edx,(%eax)
  802c16:	eb 0a                	jmp    802c22 <alloc_block_NF+0x12d>
  802c18:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802c1b:	8b 00                	mov    (%eax),%eax
  802c1d:	a3 48 51 80 00       	mov    %eax,0x805148
  802c22:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802c25:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802c2b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802c2e:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802c35:	a1 54 51 80 00       	mov    0x805154,%eax
  802c3a:	48                   	dec    %eax
  802c3b:	a3 54 51 80 00       	mov    %eax,0x805154
			newblk->size = versize;
  802c40:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802c43:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802c46:	89 50 0c             	mov    %edx,0xc(%eax)
			blk->size = blk->size-versize;
  802c49:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c4c:	8b 40 0c             	mov    0xc(%eax),%eax
  802c4f:	2b 45 f0             	sub    -0x10(%ebp),%eax
  802c52:	89 c2                	mov    %eax,%edx
  802c54:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c57:	89 50 0c             	mov    %edx,0xc(%eax)
			uint32 newveradd = blk->sva;
  802c5a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c5d:	8b 40 08             	mov    0x8(%eax),%eax
  802c60:	89 45 e8             	mov    %eax,-0x18(%ebp)
			blk->sva+=newblk->size;
  802c63:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c66:	8b 50 08             	mov    0x8(%eax),%edx
  802c69:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802c6c:	8b 40 0c             	mov    0xc(%eax),%eax
  802c6f:	01 c2                	add    %eax,%edx
  802c71:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c74:	89 50 08             	mov    %edx,0x8(%eax)
			newblk->sva = newveradd;
  802c77:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802c7a:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802c7d:	89 50 08             	mov    %edx,0x8(%eax)
			return newblk;
  802c80:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802c83:	eb 3b                	jmp    802cc0 <alloc_block_NF+0x1cb>
	//panic("alloc_block_NF() is not implemented yet...!!");
	uint32 versize = size;
	struct MemBlock* blk;
	struct MemBlock* newblk = LIST_FIRST(&AvailableMemBlocksList);

	LIST_FOREACH(blk,&FreeMemBlocksList)
  802c85:	a1 40 51 80 00       	mov    0x805140,%eax
  802c8a:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802c8d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802c91:	74 07                	je     802c9a <alloc_block_NF+0x1a5>
  802c93:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c96:	8b 00                	mov    (%eax),%eax
  802c98:	eb 05                	jmp    802c9f <alloc_block_NF+0x1aa>
  802c9a:	b8 00 00 00 00       	mov    $0x0,%eax
  802c9f:	a3 40 51 80 00       	mov    %eax,0x805140
  802ca4:	a1 40 51 80 00       	mov    0x805140,%eax
  802ca9:	85 c0                	test   %eax,%eax
  802cab:	0f 85 65 fe ff ff    	jne    802b16 <alloc_block_NF+0x21>
  802cb1:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802cb5:	0f 85 5b fe ff ff    	jne    802b16 <alloc_block_NF+0x21>
			blk->sva+=newblk->size;
			newblk->sva = newveradd;
			return newblk;
		}
	}
	return NULL;
  802cbb:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802cc0:	c9                   	leave  
  802cc1:	c3                   	ret    

00802cc2 <addToAvailMemBlocksList>:

//===================================================
// [8] INSERT BLOCK (SORTED WITH MERGE) IN FREE LIST:
//===================================================
void addToAvailMemBlocksList(struct MemBlock *blockToInsert)
{
  802cc2:	55                   	push   %ebp
  802cc3:	89 e5                	mov    %esp,%ebp
  802cc5:	83 ec 08             	sub    $0x8,%esp
	blockToInsert->sva = 0;
  802cc8:	8b 45 08             	mov    0x8(%ebp),%eax
  802ccb:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
	blockToInsert->size = 0;
  802cd2:	8b 45 08             	mov    0x8(%ebp),%eax
  802cd5:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
	//add to avail
	LIST_INSERT_TAIL(&AvailableMemBlocksList, blockToInsert);
  802cdc:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802ce0:	75 17                	jne    802cf9 <addToAvailMemBlocksList+0x37>
  802ce2:	83 ec 04             	sub    $0x4,%esp
  802ce5:	68 70 40 80 00       	push   $0x804070
  802cea:	68 10 01 00 00       	push   $0x110
  802cef:	68 57 40 80 00       	push   $0x804057
  802cf4:	e8 b6 d8 ff ff       	call   8005af <_panic>
  802cf9:	8b 15 4c 51 80 00    	mov    0x80514c,%edx
  802cff:	8b 45 08             	mov    0x8(%ebp),%eax
  802d02:	89 50 04             	mov    %edx,0x4(%eax)
  802d05:	8b 45 08             	mov    0x8(%ebp),%eax
  802d08:	8b 40 04             	mov    0x4(%eax),%eax
  802d0b:	85 c0                	test   %eax,%eax
  802d0d:	74 0c                	je     802d1b <addToAvailMemBlocksList+0x59>
  802d0f:	a1 4c 51 80 00       	mov    0x80514c,%eax
  802d14:	8b 55 08             	mov    0x8(%ebp),%edx
  802d17:	89 10                	mov    %edx,(%eax)
  802d19:	eb 08                	jmp    802d23 <addToAvailMemBlocksList+0x61>
  802d1b:	8b 45 08             	mov    0x8(%ebp),%eax
  802d1e:	a3 48 51 80 00       	mov    %eax,0x805148
  802d23:	8b 45 08             	mov    0x8(%ebp),%eax
  802d26:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802d2b:	8b 45 08             	mov    0x8(%ebp),%eax
  802d2e:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802d34:	a1 54 51 80 00       	mov    0x805154,%eax
  802d39:	40                   	inc    %eax
  802d3a:	a3 54 51 80 00       	mov    %eax,0x805154
}
  802d3f:	90                   	nop
  802d40:	c9                   	leave  
  802d41:	c3                   	ret    

00802d42 <insert_sorted_with_merge_freeList>:
void insert_sorted_with_merge_freeList(struct MemBlock *blockToInsert)
{
  802d42:	55                   	push   %ebp
  802d43:	89 e5                	mov    %esp,%ebp
  802d45:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] insert_sorted_with_merge_freeList
	// Write your code here, remove the panic and write your code

	struct MemBlock* last = LIST_LAST(&FreeMemBlocksList);
  802d48:	a1 3c 51 80 00       	mov    0x80513c,%eax
  802d4d:	89 45 f0             	mov    %eax,-0x10(%ebp)
	//check if list empty
	if (LIST_SIZE(&(FreeMemBlocksList)) == 0)
  802d50:	a1 44 51 80 00       	mov    0x805144,%eax
  802d55:	85 c0                	test   %eax,%eax
  802d57:	75 68                	jne    802dc1 <insert_sorted_with_merge_freeList+0x7f>
		LIST_INSERT_HEAD(&FreeMemBlocksList, blockToInsert);
  802d59:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802d5d:	75 17                	jne    802d76 <insert_sorted_with_merge_freeList+0x34>
  802d5f:	83 ec 04             	sub    $0x4,%esp
  802d62:	68 34 40 80 00       	push   $0x804034
  802d67:	68 1a 01 00 00       	push   $0x11a
  802d6c:	68 57 40 80 00       	push   $0x804057
  802d71:	e8 39 d8 ff ff       	call   8005af <_panic>
  802d76:	8b 15 38 51 80 00    	mov    0x805138,%edx
  802d7c:	8b 45 08             	mov    0x8(%ebp),%eax
  802d7f:	89 10                	mov    %edx,(%eax)
  802d81:	8b 45 08             	mov    0x8(%ebp),%eax
  802d84:	8b 00                	mov    (%eax),%eax
  802d86:	85 c0                	test   %eax,%eax
  802d88:	74 0d                	je     802d97 <insert_sorted_with_merge_freeList+0x55>
  802d8a:	a1 38 51 80 00       	mov    0x805138,%eax
  802d8f:	8b 55 08             	mov    0x8(%ebp),%edx
  802d92:	89 50 04             	mov    %edx,0x4(%eax)
  802d95:	eb 08                	jmp    802d9f <insert_sorted_with_merge_freeList+0x5d>
  802d97:	8b 45 08             	mov    0x8(%ebp),%eax
  802d9a:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802d9f:	8b 45 08             	mov    0x8(%ebp),%eax
  802da2:	a3 38 51 80 00       	mov    %eax,0x805138
  802da7:	8b 45 08             	mov    0x8(%ebp),%eax
  802daa:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802db1:	a1 44 51 80 00       	mov    0x805144,%eax
  802db6:	40                   	inc    %eax
  802db7:	a3 44 51 80 00       	mov    %eax,0x805144
		}
	}

	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  802dbc:	e9 c5 03 00 00       	jmp    803186 <insert_sorted_with_merge_freeList+0x444>
	struct MemBlock* last = LIST_LAST(&FreeMemBlocksList);
	//check if list empty
	if (LIST_SIZE(&(FreeMemBlocksList)) == 0)
		LIST_INSERT_HEAD(&FreeMemBlocksList, blockToInsert);
	//check if it's position is at last
	else if (last->sva < blockToInsert->sva) {
  802dc1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802dc4:	8b 50 08             	mov    0x8(%eax),%edx
  802dc7:	8b 45 08             	mov    0x8(%ebp),%eax
  802dca:	8b 40 08             	mov    0x8(%eax),%eax
  802dcd:	39 c2                	cmp    %eax,%edx
  802dcf:	0f 83 b2 00 00 00    	jae    802e87 <insert_sorted_with_merge_freeList+0x145>

		//if i have to merge
		if (last->sva + last->size == blockToInsert->sva) {
  802dd5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802dd8:	8b 50 08             	mov    0x8(%eax),%edx
  802ddb:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802dde:	8b 40 0c             	mov    0xc(%eax),%eax
  802de1:	01 c2                	add    %eax,%edx
  802de3:	8b 45 08             	mov    0x8(%ebp),%eax
  802de6:	8b 40 08             	mov    0x8(%eax),%eax
  802de9:	39 c2                	cmp    %eax,%edx
  802deb:	75 27                	jne    802e14 <insert_sorted_with_merge_freeList+0xd2>
			last->size = last->size + blockToInsert->size;
  802ded:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802df0:	8b 50 0c             	mov    0xc(%eax),%edx
  802df3:	8b 45 08             	mov    0x8(%ebp),%eax
  802df6:	8b 40 0c             	mov    0xc(%eax),%eax
  802df9:	01 c2                	add    %eax,%edx
  802dfb:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802dfe:	89 50 0c             	mov    %edx,0xc(%eax)
			addToAvailMemBlocksList(blockToInsert);
  802e01:	83 ec 0c             	sub    $0xc,%esp
  802e04:	ff 75 08             	pushl  0x8(%ebp)
  802e07:	e8 b6 fe ff ff       	call   802cc2 <addToAvailMemBlocksList>
  802e0c:	83 c4 10             	add    $0x10,%esp
		}
	}

	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  802e0f:	e9 72 03 00 00       	jmp    803186 <insert_sorted_with_merge_freeList+0x444>
		if (last->sva + last->size == blockToInsert->sva) {
			last->size = last->size + blockToInsert->size;
			addToAvailMemBlocksList(blockToInsert);

		} else {
			LIST_INSERT_AFTER(&FreeMemBlocksList, last, blockToInsert);
  802e14:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802e18:	74 06                	je     802e20 <insert_sorted_with_merge_freeList+0xde>
  802e1a:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802e1e:	75 17                	jne    802e37 <insert_sorted_with_merge_freeList+0xf5>
  802e20:	83 ec 04             	sub    $0x4,%esp
  802e23:	68 94 40 80 00       	push   $0x804094
  802e28:	68 24 01 00 00       	push   $0x124
  802e2d:	68 57 40 80 00       	push   $0x804057
  802e32:	e8 78 d7 ff ff       	call   8005af <_panic>
  802e37:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802e3a:	8b 10                	mov    (%eax),%edx
  802e3c:	8b 45 08             	mov    0x8(%ebp),%eax
  802e3f:	89 10                	mov    %edx,(%eax)
  802e41:	8b 45 08             	mov    0x8(%ebp),%eax
  802e44:	8b 00                	mov    (%eax),%eax
  802e46:	85 c0                	test   %eax,%eax
  802e48:	74 0b                	je     802e55 <insert_sorted_with_merge_freeList+0x113>
  802e4a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802e4d:	8b 00                	mov    (%eax),%eax
  802e4f:	8b 55 08             	mov    0x8(%ebp),%edx
  802e52:	89 50 04             	mov    %edx,0x4(%eax)
  802e55:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802e58:	8b 55 08             	mov    0x8(%ebp),%edx
  802e5b:	89 10                	mov    %edx,(%eax)
  802e5d:	8b 45 08             	mov    0x8(%ebp),%eax
  802e60:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802e63:	89 50 04             	mov    %edx,0x4(%eax)
  802e66:	8b 45 08             	mov    0x8(%ebp),%eax
  802e69:	8b 00                	mov    (%eax),%eax
  802e6b:	85 c0                	test   %eax,%eax
  802e6d:	75 08                	jne    802e77 <insert_sorted_with_merge_freeList+0x135>
  802e6f:	8b 45 08             	mov    0x8(%ebp),%eax
  802e72:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802e77:	a1 44 51 80 00       	mov    0x805144,%eax
  802e7c:	40                   	inc    %eax
  802e7d:	a3 44 51 80 00       	mov    %eax,0x805144
		}
	}

	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  802e82:	e9 ff 02 00 00       	jmp    803186 <insert_sorted_with_merge_freeList+0x444>
		} else {
			LIST_INSERT_AFTER(&FreeMemBlocksList, last, blockToInsert);
		}
	} else {
		struct MemBlock *iterator;
		LIST_FOREACH(iterator, &(FreeMemBlocksList))
  802e87:	a1 38 51 80 00       	mov    0x805138,%eax
  802e8c:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802e8f:	e9 c2 02 00 00       	jmp    803156 <insert_sorted_with_merge_freeList+0x414>
		{

			if (iterator->sva > blockToInsert->sva) {
  802e94:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e97:	8b 50 08             	mov    0x8(%eax),%edx
  802e9a:	8b 45 08             	mov    0x8(%ebp),%eax
  802e9d:	8b 40 08             	mov    0x8(%eax),%eax
  802ea0:	39 c2                	cmp    %eax,%edx
  802ea2:	0f 86 a6 02 00 00    	jbe    80314e <insert_sorted_with_merge_freeList+0x40c>

				struct MemBlock* prev = LIST_PREV(iterator);
  802ea8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802eab:	8b 40 04             	mov    0x4(%eax),%eax
  802eae:	89 45 ec             	mov    %eax,-0x14(%ebp)
				if (prev == NULL) {
  802eb1:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802eb5:	0f 85 ba 00 00 00    	jne    802f75 <insert_sorted_with_merge_freeList+0x233>
					//check merge
					if (blockToInsert->size + blockToInsert->sva
  802ebb:	8b 45 08             	mov    0x8(%ebp),%eax
  802ebe:	8b 50 0c             	mov    0xc(%eax),%edx
  802ec1:	8b 45 08             	mov    0x8(%ebp),%eax
  802ec4:	8b 40 08             	mov    0x8(%eax),%eax
  802ec7:	01 c2                	add    %eax,%edx
							== iterator->sva) {
  802ec9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ecc:	8b 40 08             	mov    0x8(%eax),%eax
			if (iterator->sva > blockToInsert->sva) {

				struct MemBlock* prev = LIST_PREV(iterator);
				if (prev == NULL) {
					//check merge
					if (blockToInsert->size + blockToInsert->sva
  802ecf:	39 c2                	cmp    %eax,%edx
  802ed1:	75 33                	jne    802f06 <insert_sorted_with_merge_freeList+0x1c4>
							== iterator->sva) {
						iterator->sva = blockToInsert->sva;
  802ed3:	8b 45 08             	mov    0x8(%ebp),%eax
  802ed6:	8b 50 08             	mov    0x8(%eax),%edx
  802ed9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802edc:	89 50 08             	mov    %edx,0x8(%eax)
						iterator->size = iterator->size + blockToInsert->size;
  802edf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ee2:	8b 50 0c             	mov    0xc(%eax),%edx
  802ee5:	8b 45 08             	mov    0x8(%ebp),%eax
  802ee8:	8b 40 0c             	mov    0xc(%eax),%eax
  802eeb:	01 c2                	add    %eax,%edx
  802eed:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ef0:	89 50 0c             	mov    %edx,0xc(%eax)
						addToAvailMemBlocksList(blockToInsert);
  802ef3:	83 ec 0c             	sub    $0xc,%esp
  802ef6:	ff 75 08             	pushl  0x8(%ebp)
  802ef9:	e8 c4 fd ff ff       	call   802cc2 <addToAvailMemBlocksList>
  802efe:	83 c4 10             	add    $0x10,%esp

					else {
						LIST_INSERT_BEFORE(&FreeMemBlocksList, iterator,
								blockToInsert);
					}
					break;
  802f01:	e9 80 02 00 00       	jmp    803186 <insert_sorted_with_merge_freeList+0x444>
						addToAvailMemBlocksList(blockToInsert);

					}

					else {
						LIST_INSERT_BEFORE(&FreeMemBlocksList, iterator,
  802f06:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802f0a:	74 06                	je     802f12 <insert_sorted_with_merge_freeList+0x1d0>
  802f0c:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802f10:	75 17                	jne    802f29 <insert_sorted_with_merge_freeList+0x1e7>
  802f12:	83 ec 04             	sub    $0x4,%esp
  802f15:	68 e8 40 80 00       	push   $0x8040e8
  802f1a:	68 3a 01 00 00       	push   $0x13a
  802f1f:	68 57 40 80 00       	push   $0x804057
  802f24:	e8 86 d6 ff ff       	call   8005af <_panic>
  802f29:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f2c:	8b 50 04             	mov    0x4(%eax),%edx
  802f2f:	8b 45 08             	mov    0x8(%ebp),%eax
  802f32:	89 50 04             	mov    %edx,0x4(%eax)
  802f35:	8b 45 08             	mov    0x8(%ebp),%eax
  802f38:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802f3b:	89 10                	mov    %edx,(%eax)
  802f3d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f40:	8b 40 04             	mov    0x4(%eax),%eax
  802f43:	85 c0                	test   %eax,%eax
  802f45:	74 0d                	je     802f54 <insert_sorted_with_merge_freeList+0x212>
  802f47:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f4a:	8b 40 04             	mov    0x4(%eax),%eax
  802f4d:	8b 55 08             	mov    0x8(%ebp),%edx
  802f50:	89 10                	mov    %edx,(%eax)
  802f52:	eb 08                	jmp    802f5c <insert_sorted_with_merge_freeList+0x21a>
  802f54:	8b 45 08             	mov    0x8(%ebp),%eax
  802f57:	a3 38 51 80 00       	mov    %eax,0x805138
  802f5c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f5f:	8b 55 08             	mov    0x8(%ebp),%edx
  802f62:	89 50 04             	mov    %edx,0x4(%eax)
  802f65:	a1 44 51 80 00       	mov    0x805144,%eax
  802f6a:	40                   	inc    %eax
  802f6b:	a3 44 51 80 00       	mov    %eax,0x805144
								blockToInsert);
					}
					break;
  802f70:	e9 11 02 00 00       	jmp    803186 <insert_sorted_with_merge_freeList+0x444>
				} else {
					//prev and next merge
					if (prev->sva + prev->size + blockToInsert->size
  802f75:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802f78:	8b 50 08             	mov    0x8(%eax),%edx
  802f7b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802f7e:	8b 40 0c             	mov    0xc(%eax),%eax
  802f81:	01 c2                	add    %eax,%edx
  802f83:	8b 45 08             	mov    0x8(%ebp),%eax
  802f86:	8b 40 0c             	mov    0xc(%eax),%eax
  802f89:	01 c2                	add    %eax,%edx
							== iterator->sva) {
  802f8b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f8e:	8b 40 08             	mov    0x8(%eax),%eax
								blockToInsert);
					}
					break;
				} else {
					//prev and next merge
					if (prev->sva + prev->size + blockToInsert->size
  802f91:	39 c2                	cmp    %eax,%edx
  802f93:	0f 85 bf 00 00 00    	jne    803058 <insert_sorted_with_merge_freeList+0x316>
							== iterator->sva) {
						prev->size = prev->size + blockToInsert->size
  802f99:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802f9c:	8b 50 0c             	mov    0xc(%eax),%edx
  802f9f:	8b 45 08             	mov    0x8(%ebp),%eax
  802fa2:	8b 40 0c             	mov    0xc(%eax),%eax
  802fa5:	01 c2                	add    %eax,%edx
								+ iterator->size;
  802fa7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802faa:	8b 40 0c             	mov    0xc(%eax),%eax
  802fad:	01 c2                	add    %eax,%edx
					break;
				} else {
					//prev and next merge
					if (prev->sva + prev->size + blockToInsert->size
							== iterator->sva) {
						prev->size = prev->size + blockToInsert->size
  802faf:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802fb2:	89 50 0c             	mov    %edx,0xc(%eax)
								+ iterator->size;
						LIST_REMOVE(&FreeMemBlocksList, iterator);
  802fb5:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802fb9:	75 17                	jne    802fd2 <insert_sorted_with_merge_freeList+0x290>
  802fbb:	83 ec 04             	sub    $0x4,%esp
  802fbe:	68 c8 40 80 00       	push   $0x8040c8
  802fc3:	68 43 01 00 00       	push   $0x143
  802fc8:	68 57 40 80 00       	push   $0x804057
  802fcd:	e8 dd d5 ff ff       	call   8005af <_panic>
  802fd2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802fd5:	8b 00                	mov    (%eax),%eax
  802fd7:	85 c0                	test   %eax,%eax
  802fd9:	74 10                	je     802feb <insert_sorted_with_merge_freeList+0x2a9>
  802fdb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802fde:	8b 00                	mov    (%eax),%eax
  802fe0:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802fe3:	8b 52 04             	mov    0x4(%edx),%edx
  802fe6:	89 50 04             	mov    %edx,0x4(%eax)
  802fe9:	eb 0b                	jmp    802ff6 <insert_sorted_with_merge_freeList+0x2b4>
  802feb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802fee:	8b 40 04             	mov    0x4(%eax),%eax
  802ff1:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802ff6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ff9:	8b 40 04             	mov    0x4(%eax),%eax
  802ffc:	85 c0                	test   %eax,%eax
  802ffe:	74 0f                	je     80300f <insert_sorted_with_merge_freeList+0x2cd>
  803000:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803003:	8b 40 04             	mov    0x4(%eax),%eax
  803006:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803009:	8b 12                	mov    (%edx),%edx
  80300b:	89 10                	mov    %edx,(%eax)
  80300d:	eb 0a                	jmp    803019 <insert_sorted_with_merge_freeList+0x2d7>
  80300f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803012:	8b 00                	mov    (%eax),%eax
  803014:	a3 38 51 80 00       	mov    %eax,0x805138
  803019:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80301c:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803022:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803025:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80302c:	a1 44 51 80 00       	mov    0x805144,%eax
  803031:	48                   	dec    %eax
  803032:	a3 44 51 80 00       	mov    %eax,0x805144
						addToAvailMemBlocksList(blockToInsert);
  803037:	83 ec 0c             	sub    $0xc,%esp
  80303a:	ff 75 08             	pushl  0x8(%ebp)
  80303d:	e8 80 fc ff ff       	call   802cc2 <addToAvailMemBlocksList>
  803042:	83 c4 10             	add    $0x10,%esp
						addToAvailMemBlocksList(iterator);
  803045:	83 ec 0c             	sub    $0xc,%esp
  803048:	ff 75 f4             	pushl  -0xc(%ebp)
  80304b:	e8 72 fc ff ff       	call   802cc2 <addToAvailMemBlocksList>
  803050:	83 c4 10             	add    $0x10,%esp
					//Insert
					else {
						LIST_INSERT_BEFORE(&FreeMemBlocksList, iterator,
								blockToInsert);
					}
					break;
  803053:	e9 2e 01 00 00       	jmp    803186 <insert_sorted_with_merge_freeList+0x444>
						LIST_REMOVE(&FreeMemBlocksList, iterator);
						addToAvailMemBlocksList(blockToInsert);
						addToAvailMemBlocksList(iterator);
					}
					//previous merge
					else if (prev->sva + prev->size == blockToInsert->sva) {
  803058:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80305b:	8b 50 08             	mov    0x8(%eax),%edx
  80305e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803061:	8b 40 0c             	mov    0xc(%eax),%eax
  803064:	01 c2                	add    %eax,%edx
  803066:	8b 45 08             	mov    0x8(%ebp),%eax
  803069:	8b 40 08             	mov    0x8(%eax),%eax
  80306c:	39 c2                	cmp    %eax,%edx
  80306e:	75 27                	jne    803097 <insert_sorted_with_merge_freeList+0x355>
						prev->size = prev->size + blockToInsert->size;
  803070:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803073:	8b 50 0c             	mov    0xc(%eax),%edx
  803076:	8b 45 08             	mov    0x8(%ebp),%eax
  803079:	8b 40 0c             	mov    0xc(%eax),%eax
  80307c:	01 c2                	add    %eax,%edx
  80307e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803081:	89 50 0c             	mov    %edx,0xc(%eax)
						addToAvailMemBlocksList(blockToInsert);
  803084:	83 ec 0c             	sub    $0xc,%esp
  803087:	ff 75 08             	pushl  0x8(%ebp)
  80308a:	e8 33 fc ff ff       	call   802cc2 <addToAvailMemBlocksList>
  80308f:	83 c4 10             	add    $0x10,%esp
					//Insert
					else {
						LIST_INSERT_BEFORE(&FreeMemBlocksList, iterator,
								blockToInsert);
					}
					break;
  803092:	e9 ef 00 00 00       	jmp    803186 <insert_sorted_with_merge_freeList+0x444>
					else if (prev->sva + prev->size == blockToInsert->sva) {
						prev->size = prev->size + blockToInsert->size;
						addToAvailMemBlocksList(blockToInsert);
					}
					//next merge
					else if (blockToInsert->size + blockToInsert->sva
  803097:	8b 45 08             	mov    0x8(%ebp),%eax
  80309a:	8b 50 0c             	mov    0xc(%eax),%edx
  80309d:	8b 45 08             	mov    0x8(%ebp),%eax
  8030a0:	8b 40 08             	mov    0x8(%eax),%eax
  8030a3:	01 c2                	add    %eax,%edx
							== iterator->sva) {
  8030a5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030a8:	8b 40 08             	mov    0x8(%eax),%eax
					else if (prev->sva + prev->size == blockToInsert->sva) {
						prev->size = prev->size + blockToInsert->size;
						addToAvailMemBlocksList(blockToInsert);
					}
					//next merge
					else if (blockToInsert->size + blockToInsert->sva
  8030ab:	39 c2                	cmp    %eax,%edx
  8030ad:	75 33                	jne    8030e2 <insert_sorted_with_merge_freeList+0x3a0>
							== iterator->sva) {
						iterator->sva = blockToInsert->sva;
  8030af:	8b 45 08             	mov    0x8(%ebp),%eax
  8030b2:	8b 50 08             	mov    0x8(%eax),%edx
  8030b5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030b8:	89 50 08             	mov    %edx,0x8(%eax)
						iterator->size = iterator->size + blockToInsert->size;
  8030bb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030be:	8b 50 0c             	mov    0xc(%eax),%edx
  8030c1:	8b 45 08             	mov    0x8(%ebp),%eax
  8030c4:	8b 40 0c             	mov    0xc(%eax),%eax
  8030c7:	01 c2                	add    %eax,%edx
  8030c9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030cc:	89 50 0c             	mov    %edx,0xc(%eax)
						addToAvailMemBlocksList(blockToInsert);
  8030cf:	83 ec 0c             	sub    $0xc,%esp
  8030d2:	ff 75 08             	pushl  0x8(%ebp)
  8030d5:	e8 e8 fb ff ff       	call   802cc2 <addToAvailMemBlocksList>
  8030da:	83 c4 10             	add    $0x10,%esp
					//Insert
					else {
						LIST_INSERT_BEFORE(&FreeMemBlocksList, iterator,
								blockToInsert);
					}
					break;
  8030dd:	e9 a4 00 00 00       	jmp    803186 <insert_sorted_with_merge_freeList+0x444>
						iterator->size = iterator->size + blockToInsert->size;
						addToAvailMemBlocksList(blockToInsert);
					}
					//Insert
					else {
						LIST_INSERT_BEFORE(&FreeMemBlocksList, iterator,
  8030e2:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8030e6:	74 06                	je     8030ee <insert_sorted_with_merge_freeList+0x3ac>
  8030e8:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8030ec:	75 17                	jne    803105 <insert_sorted_with_merge_freeList+0x3c3>
  8030ee:	83 ec 04             	sub    $0x4,%esp
  8030f1:	68 e8 40 80 00       	push   $0x8040e8
  8030f6:	68 56 01 00 00       	push   $0x156
  8030fb:	68 57 40 80 00       	push   $0x804057
  803100:	e8 aa d4 ff ff       	call   8005af <_panic>
  803105:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803108:	8b 50 04             	mov    0x4(%eax),%edx
  80310b:	8b 45 08             	mov    0x8(%ebp),%eax
  80310e:	89 50 04             	mov    %edx,0x4(%eax)
  803111:	8b 45 08             	mov    0x8(%ebp),%eax
  803114:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803117:	89 10                	mov    %edx,(%eax)
  803119:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80311c:	8b 40 04             	mov    0x4(%eax),%eax
  80311f:	85 c0                	test   %eax,%eax
  803121:	74 0d                	je     803130 <insert_sorted_with_merge_freeList+0x3ee>
  803123:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803126:	8b 40 04             	mov    0x4(%eax),%eax
  803129:	8b 55 08             	mov    0x8(%ebp),%edx
  80312c:	89 10                	mov    %edx,(%eax)
  80312e:	eb 08                	jmp    803138 <insert_sorted_with_merge_freeList+0x3f6>
  803130:	8b 45 08             	mov    0x8(%ebp),%eax
  803133:	a3 38 51 80 00       	mov    %eax,0x805138
  803138:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80313b:	8b 55 08             	mov    0x8(%ebp),%edx
  80313e:	89 50 04             	mov    %edx,0x4(%eax)
  803141:	a1 44 51 80 00       	mov    0x805144,%eax
  803146:	40                   	inc    %eax
  803147:	a3 44 51 80 00       	mov    %eax,0x805144
								blockToInsert);
					}
					break;
  80314c:	eb 38                	jmp    803186 <insert_sorted_with_merge_freeList+0x444>
		} else {
			LIST_INSERT_AFTER(&FreeMemBlocksList, last, blockToInsert);
		}
	} else {
		struct MemBlock *iterator;
		LIST_FOREACH(iterator, &(FreeMemBlocksList))
  80314e:	a1 40 51 80 00       	mov    0x805140,%eax
  803153:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803156:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80315a:	74 07                	je     803163 <insert_sorted_with_merge_freeList+0x421>
  80315c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80315f:	8b 00                	mov    (%eax),%eax
  803161:	eb 05                	jmp    803168 <insert_sorted_with_merge_freeList+0x426>
  803163:	b8 00 00 00 00       	mov    $0x0,%eax
  803168:	a3 40 51 80 00       	mov    %eax,0x805140
  80316d:	a1 40 51 80 00       	mov    0x805140,%eax
  803172:	85 c0                	test   %eax,%eax
  803174:	0f 85 1a fd ff ff    	jne    802e94 <insert_sorted_with_merge_freeList+0x152>
  80317a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80317e:	0f 85 10 fd ff ff    	jne    802e94 <insert_sorted_with_merge_freeList+0x152>
		}
	}

	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  803184:	eb 00                	jmp    803186 <insert_sorted_with_merge_freeList+0x444>
  803186:	90                   	nop
  803187:	c9                   	leave  
  803188:	c3                   	ret    

00803189 <env_sleep>:
#include <inc/lib.h>
#include <inc/timerreg.h>

void
env_sleep(uint32 approxMilliSeconds)
{
  803189:	55                   	push   %ebp
  80318a:	89 e5                	mov    %esp,%ebp
  80318c:	83 ec 28             	sub    $0x28,%esp
//	cprintf("%s go to sleep...\n", myEnv->prog_name);
	uint32 time_in_cycles=approxMilliSeconds*CYCLES_PER_MILLISEC;
  80318f:	8b 55 08             	mov    0x8(%ebp),%edx
  803192:	89 d0                	mov    %edx,%eax
  803194:	c1 e0 02             	shl    $0x2,%eax
  803197:	01 d0                	add    %edx,%eax
  803199:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8031a0:	01 d0                	add    %edx,%eax
  8031a2:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8031a9:	01 d0                	add    %edx,%eax
  8031ab:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8031b2:	01 d0                	add    %edx,%eax
  8031b4:	c1 e0 04             	shl    $0x4,%eax
  8031b7:	89 45 f0             	mov    %eax,-0x10(%ebp)
	uint32 cycles_counter =0;
  8031ba:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	struct uint64 baseTime = sys_get_virtual_time() ;
  8031c1:	8d 45 e8             	lea    -0x18(%ebp),%eax
  8031c4:	83 ec 0c             	sub    $0xc,%esp
  8031c7:	50                   	push   %eax
  8031c8:	e8 60 ed ff ff       	call   801f2d <sys_get_virtual_time>
  8031cd:	83 c4 0c             	add    $0xc,%esp
	while(cycles_counter<time_in_cycles)
  8031d0:	eb 41                	jmp    803213 <env_sleep+0x8a>
	{
		struct uint64 currentTime = sys_get_virtual_time() ;
  8031d2:	8d 45 e0             	lea    -0x20(%ebp),%eax
  8031d5:	83 ec 0c             	sub    $0xc,%esp
  8031d8:	50                   	push   %eax
  8031d9:	e8 4f ed ff ff       	call   801f2d <sys_get_virtual_time>
  8031de:	83 c4 0c             	add    $0xc,%esp

		// update the cycles_count
		#define M32 0xffffffff
		// subtract basetime from current time
		struct uint64 res;
		res.low = (currentTime.low - baseTime.low) & M32;
  8031e1:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8031e4:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8031e7:	29 c2                	sub    %eax,%edx
  8031e9:	89 d0                	mov    %edx,%eax
  8031eb:	89 45 d8             	mov    %eax,-0x28(%ebp)
		res.hi = (currentTime.hi - baseTime.hi - (res.low > currentTime.low)) & M32;
  8031ee:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8031f1:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8031f4:	89 d1                	mov    %edx,%ecx
  8031f6:	29 c1                	sub    %eax,%ecx
  8031f8:	8b 55 d8             	mov    -0x28(%ebp),%edx
  8031fb:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8031fe:	39 c2                	cmp    %eax,%edx
  803200:	0f 97 c0             	seta   %al
  803203:	0f b6 c0             	movzbl %al,%eax
  803206:	29 c1                	sub    %eax,%ecx
  803208:	89 c8                	mov    %ecx,%eax
  80320a:	89 45 dc             	mov    %eax,-0x24(%ebp)

		//update cycles_count with result
		cycles_counter = res.low;
  80320d:	8b 45 d8             	mov    -0x28(%ebp),%eax
  803210:	89 45 f4             	mov    %eax,-0xc(%ebp)
//	cprintf("%s go to sleep...\n", myEnv->prog_name);
	uint32 time_in_cycles=approxMilliSeconds*CYCLES_PER_MILLISEC;
	uint32 cycles_counter =0;

	struct uint64 baseTime = sys_get_virtual_time() ;
	while(cycles_counter<time_in_cycles)
  803213:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803216:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  803219:	72 b7                	jb     8031d2 <env_sleep+0x49>
//				,cycles_counter
//				);
	}
	//cprintf("%s [%d] wake up now!\n", myEnv->prog_name, myEnv->env_id);

}
  80321b:	90                   	nop
  80321c:	c9                   	leave  
  80321d:	c3                   	ret    

0080321e <busy_wait>:

//2017
uint32 busy_wait(uint32 loopMax)
{
  80321e:	55                   	push   %ebp
  80321f:	89 e5                	mov    %esp,%ebp
  803221:	83 ec 10             	sub    $0x10,%esp
	uint32 i = 0 ;
  803224:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	while (i < loopMax) i++;
  80322b:	eb 03                	jmp    803230 <busy_wait+0x12>
  80322d:	ff 45 fc             	incl   -0x4(%ebp)
  803230:	8b 45 fc             	mov    -0x4(%ebp),%eax
  803233:	3b 45 08             	cmp    0x8(%ebp),%eax
  803236:	72 f5                	jb     80322d <busy_wait+0xf>
	return i;
  803238:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  80323b:	c9                   	leave  
  80323c:	c3                   	ret    
  80323d:	66 90                	xchg   %ax,%ax
  80323f:	90                   	nop

00803240 <__udivdi3>:
  803240:	55                   	push   %ebp
  803241:	57                   	push   %edi
  803242:	56                   	push   %esi
  803243:	53                   	push   %ebx
  803244:	83 ec 1c             	sub    $0x1c,%esp
  803247:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  80324b:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  80324f:	8b 7c 24 38          	mov    0x38(%esp),%edi
  803253:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  803257:	89 ca                	mov    %ecx,%edx
  803259:	89 f8                	mov    %edi,%eax
  80325b:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  80325f:	85 f6                	test   %esi,%esi
  803261:	75 2d                	jne    803290 <__udivdi3+0x50>
  803263:	39 cf                	cmp    %ecx,%edi
  803265:	77 65                	ja     8032cc <__udivdi3+0x8c>
  803267:	89 fd                	mov    %edi,%ebp
  803269:	85 ff                	test   %edi,%edi
  80326b:	75 0b                	jne    803278 <__udivdi3+0x38>
  80326d:	b8 01 00 00 00       	mov    $0x1,%eax
  803272:	31 d2                	xor    %edx,%edx
  803274:	f7 f7                	div    %edi
  803276:	89 c5                	mov    %eax,%ebp
  803278:	31 d2                	xor    %edx,%edx
  80327a:	89 c8                	mov    %ecx,%eax
  80327c:	f7 f5                	div    %ebp
  80327e:	89 c1                	mov    %eax,%ecx
  803280:	89 d8                	mov    %ebx,%eax
  803282:	f7 f5                	div    %ebp
  803284:	89 cf                	mov    %ecx,%edi
  803286:	89 fa                	mov    %edi,%edx
  803288:	83 c4 1c             	add    $0x1c,%esp
  80328b:	5b                   	pop    %ebx
  80328c:	5e                   	pop    %esi
  80328d:	5f                   	pop    %edi
  80328e:	5d                   	pop    %ebp
  80328f:	c3                   	ret    
  803290:	39 ce                	cmp    %ecx,%esi
  803292:	77 28                	ja     8032bc <__udivdi3+0x7c>
  803294:	0f bd fe             	bsr    %esi,%edi
  803297:	83 f7 1f             	xor    $0x1f,%edi
  80329a:	75 40                	jne    8032dc <__udivdi3+0x9c>
  80329c:	39 ce                	cmp    %ecx,%esi
  80329e:	72 0a                	jb     8032aa <__udivdi3+0x6a>
  8032a0:	3b 44 24 08          	cmp    0x8(%esp),%eax
  8032a4:	0f 87 9e 00 00 00    	ja     803348 <__udivdi3+0x108>
  8032aa:	b8 01 00 00 00       	mov    $0x1,%eax
  8032af:	89 fa                	mov    %edi,%edx
  8032b1:	83 c4 1c             	add    $0x1c,%esp
  8032b4:	5b                   	pop    %ebx
  8032b5:	5e                   	pop    %esi
  8032b6:	5f                   	pop    %edi
  8032b7:	5d                   	pop    %ebp
  8032b8:	c3                   	ret    
  8032b9:	8d 76 00             	lea    0x0(%esi),%esi
  8032bc:	31 ff                	xor    %edi,%edi
  8032be:	31 c0                	xor    %eax,%eax
  8032c0:	89 fa                	mov    %edi,%edx
  8032c2:	83 c4 1c             	add    $0x1c,%esp
  8032c5:	5b                   	pop    %ebx
  8032c6:	5e                   	pop    %esi
  8032c7:	5f                   	pop    %edi
  8032c8:	5d                   	pop    %ebp
  8032c9:	c3                   	ret    
  8032ca:	66 90                	xchg   %ax,%ax
  8032cc:	89 d8                	mov    %ebx,%eax
  8032ce:	f7 f7                	div    %edi
  8032d0:	31 ff                	xor    %edi,%edi
  8032d2:	89 fa                	mov    %edi,%edx
  8032d4:	83 c4 1c             	add    $0x1c,%esp
  8032d7:	5b                   	pop    %ebx
  8032d8:	5e                   	pop    %esi
  8032d9:	5f                   	pop    %edi
  8032da:	5d                   	pop    %ebp
  8032db:	c3                   	ret    
  8032dc:	bd 20 00 00 00       	mov    $0x20,%ebp
  8032e1:	89 eb                	mov    %ebp,%ebx
  8032e3:	29 fb                	sub    %edi,%ebx
  8032e5:	89 f9                	mov    %edi,%ecx
  8032e7:	d3 e6                	shl    %cl,%esi
  8032e9:	89 c5                	mov    %eax,%ebp
  8032eb:	88 d9                	mov    %bl,%cl
  8032ed:	d3 ed                	shr    %cl,%ebp
  8032ef:	89 e9                	mov    %ebp,%ecx
  8032f1:	09 f1                	or     %esi,%ecx
  8032f3:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  8032f7:	89 f9                	mov    %edi,%ecx
  8032f9:	d3 e0                	shl    %cl,%eax
  8032fb:	89 c5                	mov    %eax,%ebp
  8032fd:	89 d6                	mov    %edx,%esi
  8032ff:	88 d9                	mov    %bl,%cl
  803301:	d3 ee                	shr    %cl,%esi
  803303:	89 f9                	mov    %edi,%ecx
  803305:	d3 e2                	shl    %cl,%edx
  803307:	8b 44 24 08          	mov    0x8(%esp),%eax
  80330b:	88 d9                	mov    %bl,%cl
  80330d:	d3 e8                	shr    %cl,%eax
  80330f:	09 c2                	or     %eax,%edx
  803311:	89 d0                	mov    %edx,%eax
  803313:	89 f2                	mov    %esi,%edx
  803315:	f7 74 24 0c          	divl   0xc(%esp)
  803319:	89 d6                	mov    %edx,%esi
  80331b:	89 c3                	mov    %eax,%ebx
  80331d:	f7 e5                	mul    %ebp
  80331f:	39 d6                	cmp    %edx,%esi
  803321:	72 19                	jb     80333c <__udivdi3+0xfc>
  803323:	74 0b                	je     803330 <__udivdi3+0xf0>
  803325:	89 d8                	mov    %ebx,%eax
  803327:	31 ff                	xor    %edi,%edi
  803329:	e9 58 ff ff ff       	jmp    803286 <__udivdi3+0x46>
  80332e:	66 90                	xchg   %ax,%ax
  803330:	8b 54 24 08          	mov    0x8(%esp),%edx
  803334:	89 f9                	mov    %edi,%ecx
  803336:	d3 e2                	shl    %cl,%edx
  803338:	39 c2                	cmp    %eax,%edx
  80333a:	73 e9                	jae    803325 <__udivdi3+0xe5>
  80333c:	8d 43 ff             	lea    -0x1(%ebx),%eax
  80333f:	31 ff                	xor    %edi,%edi
  803341:	e9 40 ff ff ff       	jmp    803286 <__udivdi3+0x46>
  803346:	66 90                	xchg   %ax,%ax
  803348:	31 c0                	xor    %eax,%eax
  80334a:	e9 37 ff ff ff       	jmp    803286 <__udivdi3+0x46>
  80334f:	90                   	nop

00803350 <__umoddi3>:
  803350:	55                   	push   %ebp
  803351:	57                   	push   %edi
  803352:	56                   	push   %esi
  803353:	53                   	push   %ebx
  803354:	83 ec 1c             	sub    $0x1c,%esp
  803357:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  80335b:	8b 74 24 34          	mov    0x34(%esp),%esi
  80335f:	8b 7c 24 38          	mov    0x38(%esp),%edi
  803363:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  803367:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80336b:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  80336f:	89 f3                	mov    %esi,%ebx
  803371:	89 fa                	mov    %edi,%edx
  803373:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  803377:	89 34 24             	mov    %esi,(%esp)
  80337a:	85 c0                	test   %eax,%eax
  80337c:	75 1a                	jne    803398 <__umoddi3+0x48>
  80337e:	39 f7                	cmp    %esi,%edi
  803380:	0f 86 a2 00 00 00    	jbe    803428 <__umoddi3+0xd8>
  803386:	89 c8                	mov    %ecx,%eax
  803388:	89 f2                	mov    %esi,%edx
  80338a:	f7 f7                	div    %edi
  80338c:	89 d0                	mov    %edx,%eax
  80338e:	31 d2                	xor    %edx,%edx
  803390:	83 c4 1c             	add    $0x1c,%esp
  803393:	5b                   	pop    %ebx
  803394:	5e                   	pop    %esi
  803395:	5f                   	pop    %edi
  803396:	5d                   	pop    %ebp
  803397:	c3                   	ret    
  803398:	39 f0                	cmp    %esi,%eax
  80339a:	0f 87 ac 00 00 00    	ja     80344c <__umoddi3+0xfc>
  8033a0:	0f bd e8             	bsr    %eax,%ebp
  8033a3:	83 f5 1f             	xor    $0x1f,%ebp
  8033a6:	0f 84 ac 00 00 00    	je     803458 <__umoddi3+0x108>
  8033ac:	bf 20 00 00 00       	mov    $0x20,%edi
  8033b1:	29 ef                	sub    %ebp,%edi
  8033b3:	89 fe                	mov    %edi,%esi
  8033b5:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  8033b9:	89 e9                	mov    %ebp,%ecx
  8033bb:	d3 e0                	shl    %cl,%eax
  8033bd:	89 d7                	mov    %edx,%edi
  8033bf:	89 f1                	mov    %esi,%ecx
  8033c1:	d3 ef                	shr    %cl,%edi
  8033c3:	09 c7                	or     %eax,%edi
  8033c5:	89 e9                	mov    %ebp,%ecx
  8033c7:	d3 e2                	shl    %cl,%edx
  8033c9:	89 14 24             	mov    %edx,(%esp)
  8033cc:	89 d8                	mov    %ebx,%eax
  8033ce:	d3 e0                	shl    %cl,%eax
  8033d0:	89 c2                	mov    %eax,%edx
  8033d2:	8b 44 24 08          	mov    0x8(%esp),%eax
  8033d6:	d3 e0                	shl    %cl,%eax
  8033d8:	89 44 24 04          	mov    %eax,0x4(%esp)
  8033dc:	8b 44 24 08          	mov    0x8(%esp),%eax
  8033e0:	89 f1                	mov    %esi,%ecx
  8033e2:	d3 e8                	shr    %cl,%eax
  8033e4:	09 d0                	or     %edx,%eax
  8033e6:	d3 eb                	shr    %cl,%ebx
  8033e8:	89 da                	mov    %ebx,%edx
  8033ea:	f7 f7                	div    %edi
  8033ec:	89 d3                	mov    %edx,%ebx
  8033ee:	f7 24 24             	mull   (%esp)
  8033f1:	89 c6                	mov    %eax,%esi
  8033f3:	89 d1                	mov    %edx,%ecx
  8033f5:	39 d3                	cmp    %edx,%ebx
  8033f7:	0f 82 87 00 00 00    	jb     803484 <__umoddi3+0x134>
  8033fd:	0f 84 91 00 00 00    	je     803494 <__umoddi3+0x144>
  803403:	8b 54 24 04          	mov    0x4(%esp),%edx
  803407:	29 f2                	sub    %esi,%edx
  803409:	19 cb                	sbb    %ecx,%ebx
  80340b:	89 d8                	mov    %ebx,%eax
  80340d:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  803411:	d3 e0                	shl    %cl,%eax
  803413:	89 e9                	mov    %ebp,%ecx
  803415:	d3 ea                	shr    %cl,%edx
  803417:	09 d0                	or     %edx,%eax
  803419:	89 e9                	mov    %ebp,%ecx
  80341b:	d3 eb                	shr    %cl,%ebx
  80341d:	89 da                	mov    %ebx,%edx
  80341f:	83 c4 1c             	add    $0x1c,%esp
  803422:	5b                   	pop    %ebx
  803423:	5e                   	pop    %esi
  803424:	5f                   	pop    %edi
  803425:	5d                   	pop    %ebp
  803426:	c3                   	ret    
  803427:	90                   	nop
  803428:	89 fd                	mov    %edi,%ebp
  80342a:	85 ff                	test   %edi,%edi
  80342c:	75 0b                	jne    803439 <__umoddi3+0xe9>
  80342e:	b8 01 00 00 00       	mov    $0x1,%eax
  803433:	31 d2                	xor    %edx,%edx
  803435:	f7 f7                	div    %edi
  803437:	89 c5                	mov    %eax,%ebp
  803439:	89 f0                	mov    %esi,%eax
  80343b:	31 d2                	xor    %edx,%edx
  80343d:	f7 f5                	div    %ebp
  80343f:	89 c8                	mov    %ecx,%eax
  803441:	f7 f5                	div    %ebp
  803443:	89 d0                	mov    %edx,%eax
  803445:	e9 44 ff ff ff       	jmp    80338e <__umoddi3+0x3e>
  80344a:	66 90                	xchg   %ax,%ax
  80344c:	89 c8                	mov    %ecx,%eax
  80344e:	89 f2                	mov    %esi,%edx
  803450:	83 c4 1c             	add    $0x1c,%esp
  803453:	5b                   	pop    %ebx
  803454:	5e                   	pop    %esi
  803455:	5f                   	pop    %edi
  803456:	5d                   	pop    %ebp
  803457:	c3                   	ret    
  803458:	3b 04 24             	cmp    (%esp),%eax
  80345b:	72 06                	jb     803463 <__umoddi3+0x113>
  80345d:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  803461:	77 0f                	ja     803472 <__umoddi3+0x122>
  803463:	89 f2                	mov    %esi,%edx
  803465:	29 f9                	sub    %edi,%ecx
  803467:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  80346b:	89 14 24             	mov    %edx,(%esp)
  80346e:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  803472:	8b 44 24 04          	mov    0x4(%esp),%eax
  803476:	8b 14 24             	mov    (%esp),%edx
  803479:	83 c4 1c             	add    $0x1c,%esp
  80347c:	5b                   	pop    %ebx
  80347d:	5e                   	pop    %esi
  80347e:	5f                   	pop    %edi
  80347f:	5d                   	pop    %ebp
  803480:	c3                   	ret    
  803481:	8d 76 00             	lea    0x0(%esi),%esi
  803484:	2b 04 24             	sub    (%esp),%eax
  803487:	19 fa                	sbb    %edi,%edx
  803489:	89 d1                	mov    %edx,%ecx
  80348b:	89 c6                	mov    %eax,%esi
  80348d:	e9 71 ff ff ff       	jmp    803403 <__umoddi3+0xb3>
  803492:	66 90                	xchg   %ax,%ax
  803494:	39 44 24 04          	cmp    %eax,0x4(%esp)
  803498:	72 ea                	jb     803484 <__umoddi3+0x134>
  80349a:	89 d9                	mov    %ebx,%ecx
  80349c:	e9 62 ff ff ff       	jmp    803403 <__umoddi3+0xb3>
