
obj/user/ef_tst_sharing_2master:     file format elf32-i386


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
  800031:	e8 49 03 00 00       	call   80037f <libmain>
1:      jmp 1b
  800036:	eb fe                	jmp    800036 <args_exist+0x5>

00800038 <_main>:
// Master program: create the shared variables, initialize them and run slaves
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
  80008d:	68 c0 33 80 00       	push   $0x8033c0
  800092:	6a 13                	push   $0x13
  800094:	68 dc 33 80 00       	push   $0x8033dc
  800099:	e8 1d 04 00 00       	call   8004bb <_panic>
	}
	uint32 *x, *y, *z ;

	//x: Readonly
	int freeFrames = sys_calculate_free_frames() ;
  80009e:	e8 6a 1a 00 00       	call   801b0d <sys_calculate_free_frames>
  8000a3:	89 45 ec             	mov    %eax,-0x14(%ebp)
	x = smalloc("x", 4, 0);
  8000a6:	83 ec 04             	sub    $0x4,%esp
  8000a9:	6a 00                	push   $0x0
  8000ab:	6a 04                	push   $0x4
  8000ad:	68 fa 33 80 00       	push   $0x8033fa
  8000b2:	e8 92 17 00 00       	call   801849 <smalloc>
  8000b7:	83 c4 10             	add    $0x10,%esp
  8000ba:	89 45 e8             	mov    %eax,-0x18(%ebp)
	if (x != (uint32*)USER_HEAP_START) panic("Create(): Returned address is not correct. make sure that you align the allocation on 4KB boundary");
  8000bd:	81 7d e8 00 00 00 80 	cmpl   $0x80000000,-0x18(%ebp)
  8000c4:	74 14                	je     8000da <_main+0xa2>
  8000c6:	83 ec 04             	sub    $0x4,%esp
  8000c9:	68 fc 33 80 00       	push   $0x8033fc
  8000ce:	6a 1a                	push   $0x1a
  8000d0:	68 dc 33 80 00       	push   $0x8033dc
  8000d5:	e8 e1 03 00 00       	call   8004bb <_panic>
	if ((freeFrames - sys_calculate_free_frames()) !=  1+1+2) panic("Create(): Wrong allocation- make sure that you allocate the required space in the user environment and add its frames to frames_storage %d %d %d", freeFrames, sys_calculate_free_frames(), freeFrames - sys_calculate_free_frames());
  8000da:	8b 5d ec             	mov    -0x14(%ebp),%ebx
  8000dd:	e8 2b 1a 00 00       	call   801b0d <sys_calculate_free_frames>
  8000e2:	29 c3                	sub    %eax,%ebx
  8000e4:	89 d8                	mov    %ebx,%eax
  8000e6:	83 f8 04             	cmp    $0x4,%eax
  8000e9:	74 28                	je     800113 <_main+0xdb>
  8000eb:	8b 5d ec             	mov    -0x14(%ebp),%ebx
  8000ee:	e8 1a 1a 00 00       	call   801b0d <sys_calculate_free_frames>
  8000f3:	29 c3                	sub    %eax,%ebx
  8000f5:	e8 13 1a 00 00       	call   801b0d <sys_calculate_free_frames>
  8000fa:	83 ec 08             	sub    $0x8,%esp
  8000fd:	53                   	push   %ebx
  8000fe:	50                   	push   %eax
  8000ff:	ff 75 ec             	pushl  -0x14(%ebp)
  800102:	68 60 34 80 00       	push   $0x803460
  800107:	6a 1b                	push   $0x1b
  800109:	68 dc 33 80 00       	push   $0x8033dc
  80010e:	e8 a8 03 00 00       	call   8004bb <_panic>

	//y: Readonly
	freeFrames = sys_calculate_free_frames() ;
  800113:	e8 f5 19 00 00       	call   801b0d <sys_calculate_free_frames>
  800118:	89 45 ec             	mov    %eax,-0x14(%ebp)
	y = smalloc("y", 4, 0);
  80011b:	83 ec 04             	sub    $0x4,%esp
  80011e:	6a 00                	push   $0x0
  800120:	6a 04                	push   $0x4
  800122:	68 f1 34 80 00       	push   $0x8034f1
  800127:	e8 1d 17 00 00       	call   801849 <smalloc>
  80012c:	83 c4 10             	add    $0x10,%esp
  80012f:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	if (y != (uint32*)(USER_HEAP_START + 1 * PAGE_SIZE)) panic("Create(): Returned address is not correct. make sure that you align the allocation on 4KB boundary");
  800132:	81 7d e4 00 10 00 80 	cmpl   $0x80001000,-0x1c(%ebp)
  800139:	74 14                	je     80014f <_main+0x117>
  80013b:	83 ec 04             	sub    $0x4,%esp
  80013e:	68 fc 33 80 00       	push   $0x8033fc
  800143:	6a 20                	push   $0x20
  800145:	68 dc 33 80 00       	push   $0x8033dc
  80014a:	e8 6c 03 00 00       	call   8004bb <_panic>
	if ((freeFrames - sys_calculate_free_frames()) !=  1+0+2) panic("Create(): Wrong allocation- make sure that you allocate the required space in the user environment and add its frames to frames_storage %d %d %d", freeFrames, sys_calculate_free_frames(), freeFrames - sys_calculate_free_frames());
  80014f:	8b 5d ec             	mov    -0x14(%ebp),%ebx
  800152:	e8 b6 19 00 00       	call   801b0d <sys_calculate_free_frames>
  800157:	29 c3                	sub    %eax,%ebx
  800159:	89 d8                	mov    %ebx,%eax
  80015b:	83 f8 03             	cmp    $0x3,%eax
  80015e:	74 28                	je     800188 <_main+0x150>
  800160:	8b 5d ec             	mov    -0x14(%ebp),%ebx
  800163:	e8 a5 19 00 00       	call   801b0d <sys_calculate_free_frames>
  800168:	29 c3                	sub    %eax,%ebx
  80016a:	e8 9e 19 00 00       	call   801b0d <sys_calculate_free_frames>
  80016f:	83 ec 08             	sub    $0x8,%esp
  800172:	53                   	push   %ebx
  800173:	50                   	push   %eax
  800174:	ff 75 ec             	pushl  -0x14(%ebp)
  800177:	68 60 34 80 00       	push   $0x803460
  80017c:	6a 21                	push   $0x21
  80017e:	68 dc 33 80 00       	push   $0x8033dc
  800183:	e8 33 03 00 00       	call   8004bb <_panic>

	//z: Writable
	freeFrames = sys_calculate_free_frames() ;
  800188:	e8 80 19 00 00       	call   801b0d <sys_calculate_free_frames>
  80018d:	89 45 ec             	mov    %eax,-0x14(%ebp)
	z = smalloc("z", 4, 1);
  800190:	83 ec 04             	sub    $0x4,%esp
  800193:	6a 01                	push   $0x1
  800195:	6a 04                	push   $0x4
  800197:	68 f3 34 80 00       	push   $0x8034f3
  80019c:	e8 a8 16 00 00       	call   801849 <smalloc>
  8001a1:	83 c4 10             	add    $0x10,%esp
  8001a4:	89 45 e0             	mov    %eax,-0x20(%ebp)
	if (z != (uint32*)(USER_HEAP_START + 2 * PAGE_SIZE)) panic("Create(): Returned address is not correct. make sure that you align the allocation on 4KB boundary");
  8001a7:	81 7d e0 00 20 00 80 	cmpl   $0x80002000,-0x20(%ebp)
  8001ae:	74 14                	je     8001c4 <_main+0x18c>
  8001b0:	83 ec 04             	sub    $0x4,%esp
  8001b3:	68 fc 33 80 00       	push   $0x8033fc
  8001b8:	6a 26                	push   $0x26
  8001ba:	68 dc 33 80 00       	push   $0x8033dc
  8001bf:	e8 f7 02 00 00       	call   8004bb <_panic>
	if ((freeFrames - sys_calculate_free_frames()) !=  1+0+2) panic("Create(): Wrong allocation- make sure that you allocate the required space in the user environment and add its frames to frames_storage");
  8001c4:	8b 5d ec             	mov    -0x14(%ebp),%ebx
  8001c7:	e8 41 19 00 00       	call   801b0d <sys_calculate_free_frames>
  8001cc:	29 c3                	sub    %eax,%ebx
  8001ce:	89 d8                	mov    %ebx,%eax
  8001d0:	83 f8 03             	cmp    $0x3,%eax
  8001d3:	74 14                	je     8001e9 <_main+0x1b1>
  8001d5:	83 ec 04             	sub    $0x4,%esp
  8001d8:	68 f8 34 80 00       	push   $0x8034f8
  8001dd:	6a 27                	push   $0x27
  8001df:	68 dc 33 80 00       	push   $0x8033dc
  8001e4:	e8 d2 02 00 00       	call   8004bb <_panic>

	*x = 10 ;
  8001e9:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8001ec:	c7 00 0a 00 00 00    	movl   $0xa,(%eax)
	*y = 20 ;
  8001f2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8001f5:	c7 00 14 00 00 00    	movl   $0x14,(%eax)

	int id1, id2, id3;
	id1 = sys_create_env("ef_shr2Slave1", (myEnv->page_WS_max_size),(myEnv->SecondListSize), 50);
  8001fb:	a1 20 40 80 00       	mov    0x804020,%eax
  800200:	8b 80 ec 05 00 00    	mov    0x5ec(%eax),%eax
  800206:	89 c2                	mov    %eax,%edx
  800208:	a1 20 40 80 00       	mov    0x804020,%eax
  80020d:	8b 40 74             	mov    0x74(%eax),%eax
  800210:	6a 32                	push   $0x32
  800212:	52                   	push   %edx
  800213:	50                   	push   %eax
  800214:	68 80 35 80 00       	push   $0x803580
  800219:	e8 61 1b 00 00       	call   801d7f <sys_create_env>
  80021e:	83 c4 10             	add    $0x10,%esp
  800221:	89 45 dc             	mov    %eax,-0x24(%ebp)
	id2 = sys_create_env("ef_shr2Slave1", (myEnv->page_WS_max_size),(myEnv->SecondListSize), 50);
  800224:	a1 20 40 80 00       	mov    0x804020,%eax
  800229:	8b 80 ec 05 00 00    	mov    0x5ec(%eax),%eax
  80022f:	89 c2                	mov    %eax,%edx
  800231:	a1 20 40 80 00       	mov    0x804020,%eax
  800236:	8b 40 74             	mov    0x74(%eax),%eax
  800239:	6a 32                	push   $0x32
  80023b:	52                   	push   %edx
  80023c:	50                   	push   %eax
  80023d:	68 80 35 80 00       	push   $0x803580
  800242:	e8 38 1b 00 00       	call   801d7f <sys_create_env>
  800247:	83 c4 10             	add    $0x10,%esp
  80024a:	89 45 d8             	mov    %eax,-0x28(%ebp)
	id3 = sys_create_env("ef_shr2Slave1", (myEnv->page_WS_max_size),(myEnv->SecondListSize), 50);
  80024d:	a1 20 40 80 00       	mov    0x804020,%eax
  800252:	8b 80 ec 05 00 00    	mov    0x5ec(%eax),%eax
  800258:	89 c2                	mov    %eax,%edx
  80025a:	a1 20 40 80 00       	mov    0x804020,%eax
  80025f:	8b 40 74             	mov    0x74(%eax),%eax
  800262:	6a 32                	push   $0x32
  800264:	52                   	push   %edx
  800265:	50                   	push   %eax
  800266:	68 80 35 80 00       	push   $0x803580
  80026b:	e8 0f 1b 00 00       	call   801d7f <sys_create_env>
  800270:	83 c4 10             	add    $0x10,%esp
  800273:	89 45 d4             	mov    %eax,-0x2c(%ebp)

	//to check that the slave environments completed successfully
	rsttst();
  800276:	e8 50 1c 00 00       	call   801ecb <rsttst>

	int* finish_children = smalloc("finish_children", sizeof(int), 1);
  80027b:	83 ec 04             	sub    $0x4,%esp
  80027e:	6a 01                	push   $0x1
  800280:	6a 04                	push   $0x4
  800282:	68 8e 35 80 00       	push   $0x80358e
  800287:	e8 bd 15 00 00       	call   801849 <smalloc>
  80028c:	83 c4 10             	add    $0x10,%esp
  80028f:	89 45 d0             	mov    %eax,-0x30(%ebp)

	sys_run_env(id1);
  800292:	83 ec 0c             	sub    $0xc,%esp
  800295:	ff 75 dc             	pushl  -0x24(%ebp)
  800298:	e8 00 1b 00 00       	call   801d9d <sys_run_env>
  80029d:	83 c4 10             	add    $0x10,%esp
	sys_run_env(id2);
  8002a0:	83 ec 0c             	sub    $0xc,%esp
  8002a3:	ff 75 d8             	pushl  -0x28(%ebp)
  8002a6:	e8 f2 1a 00 00       	call   801d9d <sys_run_env>
  8002ab:	83 c4 10             	add    $0x10,%esp
	sys_run_env(id3);
  8002ae:	83 ec 0c             	sub    $0xc,%esp
  8002b1:	ff 75 d4             	pushl  -0x2c(%ebp)
  8002b4:	e8 e4 1a 00 00       	call   801d9d <sys_run_env>
  8002b9:	83 c4 10             	add    $0x10,%esp

	env_sleep(15000) ;
  8002bc:	83 ec 0c             	sub    $0xc,%esp
  8002bf:	68 98 3a 00 00       	push   $0x3a98
  8002c4:	e8 cc 2d 00 00       	call   803095 <env_sleep>
  8002c9:	83 c4 10             	add    $0x10,%esp

	//to ensure that the slave environments completed successfully
	if (gettst()!=3) panic("test failed");
  8002cc:	e8 74 1c 00 00       	call   801f45 <gettst>
  8002d1:	83 f8 03             	cmp    $0x3,%eax
  8002d4:	74 14                	je     8002ea <_main+0x2b2>
  8002d6:	83 ec 04             	sub    $0x4,%esp
  8002d9:	68 9e 35 80 00       	push   $0x80359e
  8002de:	6a 3d                	push   $0x3d
  8002e0:	68 dc 33 80 00       	push   $0x8033dc
  8002e5:	e8 d1 01 00 00       	call   8004bb <_panic>


	if (*z != 30)
  8002ea:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8002ed:	8b 00                	mov    (%eax),%eax
  8002ef:	83 f8 1e             	cmp    $0x1e,%eax
  8002f2:	74 14                	je     800308 <_main+0x2d0>
		panic("Error!! Please check the creation (or the getting) of shared 2variables!!\n\n\n");
  8002f4:	83 ec 04             	sub    $0x4,%esp
  8002f7:	68 ac 35 80 00       	push   $0x8035ac
  8002fc:	6a 41                	push   $0x41
  8002fe:	68 dc 33 80 00       	push   $0x8033dc
  800303:	e8 b3 01 00 00       	call   8004bb <_panic>
	else
		cprintf("Congratulations!! Test of Shared Variables [Create & Get] [2] completed successfully!!\n\n\n");
  800308:	83 ec 0c             	sub    $0xc,%esp
  80030b:	68 fc 35 80 00       	push   $0x8035fc
  800310:	e8 5a 04 00 00       	call   80076f <cprintf>
  800315:	83 c4 10             	add    $0x10,%esp


	if (sys_getparentenvid() > 0) {
  800318:	e8 e9 1a 00 00       	call   801e06 <sys_getparentenvid>
  80031d:	85 c0                	test   %eax,%eax
  80031f:	7e 58                	jle    800379 <_main+0x341>
		sys_destroy_env(id1);
  800321:	83 ec 0c             	sub    $0xc,%esp
  800324:	ff 75 dc             	pushl  -0x24(%ebp)
  800327:	e8 8d 1a 00 00       	call   801db9 <sys_destroy_env>
  80032c:	83 c4 10             	add    $0x10,%esp
		sys_destroy_env(id2);
  80032f:	83 ec 0c             	sub    $0xc,%esp
  800332:	ff 75 d8             	pushl  -0x28(%ebp)
  800335:	e8 7f 1a 00 00       	call   801db9 <sys_destroy_env>
  80033a:	83 c4 10             	add    $0x10,%esp
		sys_destroy_env(id3);
  80033d:	83 ec 0c             	sub    $0xc,%esp
  800340:	ff 75 d4             	pushl  -0x2c(%ebp)
  800343:	e8 71 1a 00 00       	call   801db9 <sys_destroy_env>
  800348:	83 c4 10             	add    $0x10,%esp
		int *finishedCount = NULL;
  80034b:	c7 45 cc 00 00 00 00 	movl   $0x0,-0x34(%ebp)
		finishedCount = sget(sys_getparentenvid(), "finishedCount") ;
  800352:	e8 af 1a 00 00       	call   801e06 <sys_getparentenvid>
  800357:	83 ec 08             	sub    $0x8,%esp
  80035a:	68 56 36 80 00       	push   $0x803656
  80035f:	50                   	push   %eax
  800360:	e8 94 15 00 00       	call   8018f9 <sget>
  800365:	83 c4 10             	add    $0x10,%esp
  800368:	89 45 cc             	mov    %eax,-0x34(%ebp)
		(*finishedCount)++ ;
  80036b:	8b 45 cc             	mov    -0x34(%ebp),%eax
  80036e:	8b 00                	mov    (%eax),%eax
  800370:	8d 50 01             	lea    0x1(%eax),%edx
  800373:	8b 45 cc             	mov    -0x34(%ebp),%eax
  800376:	89 10                	mov    %edx,(%eax)
	}
	return;
  800378:	90                   	nop
  800379:	90                   	nop
}
  80037a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80037d:	c9                   	leave  
  80037e:	c3                   	ret    

0080037f <libmain>:
volatile struct Env *myEnv = NULL;
volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";

void
libmain(int argc, char **argv)
{
  80037f:	55                   	push   %ebp
  800380:	89 e5                	mov    %esp,%ebp
  800382:	83 ec 18             	sub    $0x18,%esp
	int envIndex = sys_getenvindex();
  800385:	e8 63 1a 00 00       	call   801ded <sys_getenvindex>
  80038a:	89 45 f4             	mov    %eax,-0xc(%ebp)
	myEnv = &(envs[envIndex]);
  80038d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800390:	89 d0                	mov    %edx,%eax
  800392:	c1 e0 03             	shl    $0x3,%eax
  800395:	01 d0                	add    %edx,%eax
  800397:	01 c0                	add    %eax,%eax
  800399:	01 d0                	add    %edx,%eax
  80039b:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8003a2:	01 d0                	add    %edx,%eax
  8003a4:	c1 e0 04             	shl    $0x4,%eax
  8003a7:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  8003ac:	a3 20 40 80 00       	mov    %eax,0x804020

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  8003b1:	a1 20 40 80 00       	mov    0x804020,%eax
  8003b6:	8a 80 5c 05 00 00    	mov    0x55c(%eax),%al
  8003bc:	84 c0                	test   %al,%al
  8003be:	74 0f                	je     8003cf <libmain+0x50>
		binaryname = myEnv->prog_name;
  8003c0:	a1 20 40 80 00       	mov    0x804020,%eax
  8003c5:	05 5c 05 00 00       	add    $0x55c,%eax
  8003ca:	a3 00 40 80 00       	mov    %eax,0x804000

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  8003cf:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8003d3:	7e 0a                	jle    8003df <libmain+0x60>
		binaryname = argv[0];
  8003d5:	8b 45 0c             	mov    0xc(%ebp),%eax
  8003d8:	8b 00                	mov    (%eax),%eax
  8003da:	a3 00 40 80 00       	mov    %eax,0x804000

	// call user main routine
	_main(argc, argv);
  8003df:	83 ec 08             	sub    $0x8,%esp
  8003e2:	ff 75 0c             	pushl  0xc(%ebp)
  8003e5:	ff 75 08             	pushl  0x8(%ebp)
  8003e8:	e8 4b fc ff ff       	call   800038 <_main>
  8003ed:	83 c4 10             	add    $0x10,%esp



	sys_disable_interrupt();
  8003f0:	e8 05 18 00 00       	call   801bfa <sys_disable_interrupt>
	cprintf("**************************************\n");
  8003f5:	83 ec 0c             	sub    $0xc,%esp
  8003f8:	68 7c 36 80 00       	push   $0x80367c
  8003fd:	e8 6d 03 00 00       	call   80076f <cprintf>
  800402:	83 c4 10             	add    $0x10,%esp
	cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  800405:	a1 20 40 80 00       	mov    0x804020,%eax
  80040a:	8b 90 44 05 00 00    	mov    0x544(%eax),%edx
  800410:	a1 20 40 80 00       	mov    0x804020,%eax
  800415:	8b 80 34 05 00 00    	mov    0x534(%eax),%eax
  80041b:	83 ec 04             	sub    $0x4,%esp
  80041e:	52                   	push   %edx
  80041f:	50                   	push   %eax
  800420:	68 a4 36 80 00       	push   $0x8036a4
  800425:	e8 45 03 00 00       	call   80076f <cprintf>
  80042a:	83 c4 10             	add    $0x10,%esp
	cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  80042d:	a1 20 40 80 00       	mov    0x804020,%eax
  800432:	8b 88 54 05 00 00    	mov    0x554(%eax),%ecx
  800438:	a1 20 40 80 00       	mov    0x804020,%eax
  80043d:	8b 90 50 05 00 00    	mov    0x550(%eax),%edx
  800443:	a1 20 40 80 00       	mov    0x804020,%eax
  800448:	8b 80 4c 05 00 00    	mov    0x54c(%eax),%eax
  80044e:	51                   	push   %ecx
  80044f:	52                   	push   %edx
  800450:	50                   	push   %eax
  800451:	68 cc 36 80 00       	push   $0x8036cc
  800456:	e8 14 03 00 00       	call   80076f <cprintf>
  80045b:	83 c4 10             	add    $0x10,%esp
	//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
	cprintf("Num of clocks = %d\n", myEnv->nClocks);
  80045e:	a1 20 40 80 00       	mov    0x804020,%eax
  800463:	8b 80 a4 05 00 00    	mov    0x5a4(%eax),%eax
  800469:	83 ec 08             	sub    $0x8,%esp
  80046c:	50                   	push   %eax
  80046d:	68 24 37 80 00       	push   $0x803724
  800472:	e8 f8 02 00 00       	call   80076f <cprintf>
  800477:	83 c4 10             	add    $0x10,%esp
	cprintf("**************************************\n");
  80047a:	83 ec 0c             	sub    $0xc,%esp
  80047d:	68 7c 36 80 00       	push   $0x80367c
  800482:	e8 e8 02 00 00       	call   80076f <cprintf>
  800487:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  80048a:	e8 85 17 00 00       	call   801c14 <sys_enable_interrupt>

	// exit gracefully
	exit();
  80048f:	e8 19 00 00 00       	call   8004ad <exit>
}
  800494:	90                   	nop
  800495:	c9                   	leave  
  800496:	c3                   	ret    

00800497 <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  800497:	55                   	push   %ebp
  800498:	89 e5                	mov    %esp,%ebp
  80049a:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  80049d:	83 ec 0c             	sub    $0xc,%esp
  8004a0:	6a 00                	push   $0x0
  8004a2:	e8 12 19 00 00       	call   801db9 <sys_destroy_env>
  8004a7:	83 c4 10             	add    $0x10,%esp
}
  8004aa:	90                   	nop
  8004ab:	c9                   	leave  
  8004ac:	c3                   	ret    

008004ad <exit>:

void
exit(void)
{
  8004ad:	55                   	push   %ebp
  8004ae:	89 e5                	mov    %esp,%ebp
  8004b0:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  8004b3:	e8 67 19 00 00       	call   801e1f <sys_exit_env>
}
  8004b8:	90                   	nop
  8004b9:	c9                   	leave  
  8004ba:	c3                   	ret    

008004bb <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  8004bb:	55                   	push   %ebp
  8004bc:	89 e5                	mov    %esp,%ebp
  8004be:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  8004c1:	8d 45 10             	lea    0x10(%ebp),%eax
  8004c4:	83 c0 04             	add    $0x4,%eax
  8004c7:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  8004ca:	a1 5c 41 80 00       	mov    0x80415c,%eax
  8004cf:	85 c0                	test   %eax,%eax
  8004d1:	74 16                	je     8004e9 <_panic+0x2e>
		cprintf("%s: ", argv0);
  8004d3:	a1 5c 41 80 00       	mov    0x80415c,%eax
  8004d8:	83 ec 08             	sub    $0x8,%esp
  8004db:	50                   	push   %eax
  8004dc:	68 38 37 80 00       	push   $0x803738
  8004e1:	e8 89 02 00 00       	call   80076f <cprintf>
  8004e6:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  8004e9:	a1 00 40 80 00       	mov    0x804000,%eax
  8004ee:	ff 75 0c             	pushl  0xc(%ebp)
  8004f1:	ff 75 08             	pushl  0x8(%ebp)
  8004f4:	50                   	push   %eax
  8004f5:	68 3d 37 80 00       	push   $0x80373d
  8004fa:	e8 70 02 00 00       	call   80076f <cprintf>
  8004ff:	83 c4 10             	add    $0x10,%esp
	vcprintf(fmt, ap);
  800502:	8b 45 10             	mov    0x10(%ebp),%eax
  800505:	83 ec 08             	sub    $0x8,%esp
  800508:	ff 75 f4             	pushl  -0xc(%ebp)
  80050b:	50                   	push   %eax
  80050c:	e8 f3 01 00 00       	call   800704 <vcprintf>
  800511:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  800514:	83 ec 08             	sub    $0x8,%esp
  800517:	6a 00                	push   $0x0
  800519:	68 59 37 80 00       	push   $0x803759
  80051e:	e8 e1 01 00 00       	call   800704 <vcprintf>
  800523:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  800526:	e8 82 ff ff ff       	call   8004ad <exit>

	// should not return here
	while (1) ;
  80052b:	eb fe                	jmp    80052b <_panic+0x70>

0080052d <CheckWSWithoutLastIndex>:
}

void CheckWSWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  80052d:	55                   	push   %ebp
  80052e:	89 e5                	mov    %esp,%ebp
  800530:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  800533:	a1 20 40 80 00       	mov    0x804020,%eax
  800538:	8b 50 74             	mov    0x74(%eax),%edx
  80053b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80053e:	39 c2                	cmp    %eax,%edx
  800540:	74 14                	je     800556 <CheckWSWithoutLastIndex+0x29>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  800542:	83 ec 04             	sub    $0x4,%esp
  800545:	68 5c 37 80 00       	push   $0x80375c
  80054a:	6a 26                	push   $0x26
  80054c:	68 a8 37 80 00       	push   $0x8037a8
  800551:	e8 65 ff ff ff       	call   8004bb <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  800556:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  80055d:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800564:	e9 c2 00 00 00       	jmp    80062b <CheckWSWithoutLastIndex+0xfe>
		if (expectedPages[e] == 0) {
  800569:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80056c:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800573:	8b 45 08             	mov    0x8(%ebp),%eax
  800576:	01 d0                	add    %edx,%eax
  800578:	8b 00                	mov    (%eax),%eax
  80057a:	85 c0                	test   %eax,%eax
  80057c:	75 08                	jne    800586 <CheckWSWithoutLastIndex+0x59>
			expectedNumOfEmptyLocs++;
  80057e:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  800581:	e9 a2 00 00 00       	jmp    800628 <CheckWSWithoutLastIndex+0xfb>
		}
		int found = 0;
  800586:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  80058d:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  800594:	eb 69                	jmp    8005ff <CheckWSWithoutLastIndex+0xd2>
			if (myEnv->__uptr_pws[w].empty == 0) {
  800596:	a1 20 40 80 00       	mov    0x804020,%eax
  80059b:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  8005a1:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8005a4:	89 d0                	mov    %edx,%eax
  8005a6:	01 c0                	add    %eax,%eax
  8005a8:	01 d0                	add    %edx,%eax
  8005aa:	c1 e0 03             	shl    $0x3,%eax
  8005ad:	01 c8                	add    %ecx,%eax
  8005af:	8a 40 04             	mov    0x4(%eax),%al
  8005b2:	84 c0                	test   %al,%al
  8005b4:	75 46                	jne    8005fc <CheckWSWithoutLastIndex+0xcf>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  8005b6:	a1 20 40 80 00       	mov    0x804020,%eax
  8005bb:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  8005c1:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8005c4:	89 d0                	mov    %edx,%eax
  8005c6:	01 c0                	add    %eax,%eax
  8005c8:	01 d0                	add    %edx,%eax
  8005ca:	c1 e0 03             	shl    $0x3,%eax
  8005cd:	01 c8                	add    %ecx,%eax
  8005cf:	8b 00                	mov    (%eax),%eax
  8005d1:	89 45 dc             	mov    %eax,-0x24(%ebp)
  8005d4:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8005d7:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8005dc:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  8005de:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8005e1:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  8005e8:	8b 45 08             	mov    0x8(%ebp),%eax
  8005eb:	01 c8                	add    %ecx,%eax
  8005ed:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  8005ef:	39 c2                	cmp    %eax,%edx
  8005f1:	75 09                	jne    8005fc <CheckWSWithoutLastIndex+0xcf>
						== expectedPages[e]) {
					found = 1;
  8005f3:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  8005fa:	eb 12                	jmp    80060e <CheckWSWithoutLastIndex+0xe1>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8005fc:	ff 45 e8             	incl   -0x18(%ebp)
  8005ff:	a1 20 40 80 00       	mov    0x804020,%eax
  800604:	8b 50 74             	mov    0x74(%eax),%edx
  800607:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80060a:	39 c2                	cmp    %eax,%edx
  80060c:	77 88                	ja     800596 <CheckWSWithoutLastIndex+0x69>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  80060e:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  800612:	75 14                	jne    800628 <CheckWSWithoutLastIndex+0xfb>
			panic(
  800614:	83 ec 04             	sub    $0x4,%esp
  800617:	68 b4 37 80 00       	push   $0x8037b4
  80061c:	6a 3a                	push   $0x3a
  80061e:	68 a8 37 80 00       	push   $0x8037a8
  800623:	e8 93 fe ff ff       	call   8004bb <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  800628:	ff 45 f0             	incl   -0x10(%ebp)
  80062b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80062e:	3b 45 0c             	cmp    0xc(%ebp),%eax
  800631:	0f 8c 32 ff ff ff    	jl     800569 <CheckWSWithoutLastIndex+0x3c>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  800637:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  80063e:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  800645:	eb 26                	jmp    80066d <CheckWSWithoutLastIndex+0x140>
		if (myEnv->__uptr_pws[w].empty == 1) {
  800647:	a1 20 40 80 00       	mov    0x804020,%eax
  80064c:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  800652:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800655:	89 d0                	mov    %edx,%eax
  800657:	01 c0                	add    %eax,%eax
  800659:	01 d0                	add    %edx,%eax
  80065b:	c1 e0 03             	shl    $0x3,%eax
  80065e:	01 c8                	add    %ecx,%eax
  800660:	8a 40 04             	mov    0x4(%eax),%al
  800663:	3c 01                	cmp    $0x1,%al
  800665:	75 03                	jne    80066a <CheckWSWithoutLastIndex+0x13d>
			actualNumOfEmptyLocs++;
  800667:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  80066a:	ff 45 e0             	incl   -0x20(%ebp)
  80066d:	a1 20 40 80 00       	mov    0x804020,%eax
  800672:	8b 50 74             	mov    0x74(%eax),%edx
  800675:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800678:	39 c2                	cmp    %eax,%edx
  80067a:	77 cb                	ja     800647 <CheckWSWithoutLastIndex+0x11a>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  80067c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80067f:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  800682:	74 14                	je     800698 <CheckWSWithoutLastIndex+0x16b>
		panic(
  800684:	83 ec 04             	sub    $0x4,%esp
  800687:	68 08 38 80 00       	push   $0x803808
  80068c:	6a 44                	push   $0x44
  80068e:	68 a8 37 80 00       	push   $0x8037a8
  800693:	e8 23 fe ff ff       	call   8004bb <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  800698:	90                   	nop
  800699:	c9                   	leave  
  80069a:	c3                   	ret    

0080069b <putch>:
};

//2017:
uint8 printProgName = 0;

static void putch(int ch, struct printbuf *b) {
  80069b:	55                   	push   %ebp
  80069c:	89 e5                	mov    %esp,%ebp
  80069e:	83 ec 08             	sub    $0x8,%esp
	b->buf[b->idx++] = ch;
  8006a1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8006a4:	8b 00                	mov    (%eax),%eax
  8006a6:	8d 48 01             	lea    0x1(%eax),%ecx
  8006a9:	8b 55 0c             	mov    0xc(%ebp),%edx
  8006ac:	89 0a                	mov    %ecx,(%edx)
  8006ae:	8b 55 08             	mov    0x8(%ebp),%edx
  8006b1:	88 d1                	mov    %dl,%cl
  8006b3:	8b 55 0c             	mov    0xc(%ebp),%edx
  8006b6:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  8006ba:	8b 45 0c             	mov    0xc(%ebp),%eax
  8006bd:	8b 00                	mov    (%eax),%eax
  8006bf:	3d ff 00 00 00       	cmp    $0xff,%eax
  8006c4:	75 2c                	jne    8006f2 <putch+0x57>
		sys_cputs(b->buf, b->idx, printProgName);
  8006c6:	a0 24 40 80 00       	mov    0x804024,%al
  8006cb:	0f b6 c0             	movzbl %al,%eax
  8006ce:	8b 55 0c             	mov    0xc(%ebp),%edx
  8006d1:	8b 12                	mov    (%edx),%edx
  8006d3:	89 d1                	mov    %edx,%ecx
  8006d5:	8b 55 0c             	mov    0xc(%ebp),%edx
  8006d8:	83 c2 08             	add    $0x8,%edx
  8006db:	83 ec 04             	sub    $0x4,%esp
  8006de:	50                   	push   %eax
  8006df:	51                   	push   %ecx
  8006e0:	52                   	push   %edx
  8006e1:	e8 66 13 00 00       	call   801a4c <sys_cputs>
  8006e6:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  8006e9:	8b 45 0c             	mov    0xc(%ebp),%eax
  8006ec:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  8006f2:	8b 45 0c             	mov    0xc(%ebp),%eax
  8006f5:	8b 40 04             	mov    0x4(%eax),%eax
  8006f8:	8d 50 01             	lea    0x1(%eax),%edx
  8006fb:	8b 45 0c             	mov    0xc(%ebp),%eax
  8006fe:	89 50 04             	mov    %edx,0x4(%eax)
}
  800701:	90                   	nop
  800702:	c9                   	leave  
  800703:	c3                   	ret    

00800704 <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  800704:	55                   	push   %ebp
  800705:	89 e5                	mov    %esp,%ebp
  800707:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  80070d:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  800714:	00 00 00 
	b.cnt = 0;
  800717:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  80071e:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  800721:	ff 75 0c             	pushl  0xc(%ebp)
  800724:	ff 75 08             	pushl  0x8(%ebp)
  800727:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  80072d:	50                   	push   %eax
  80072e:	68 9b 06 80 00       	push   $0x80069b
  800733:	e8 11 02 00 00       	call   800949 <vprintfmt>
  800738:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName);
  80073b:	a0 24 40 80 00       	mov    0x804024,%al
  800740:	0f b6 c0             	movzbl %al,%eax
  800743:	8b 95 f0 fe ff ff    	mov    -0x110(%ebp),%edx
  800749:	83 ec 04             	sub    $0x4,%esp
  80074c:	50                   	push   %eax
  80074d:	52                   	push   %edx
  80074e:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800754:	83 c0 08             	add    $0x8,%eax
  800757:	50                   	push   %eax
  800758:	e8 ef 12 00 00       	call   801a4c <sys_cputs>
  80075d:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  800760:	c6 05 24 40 80 00 00 	movb   $0x0,0x804024
	return b.cnt;
  800767:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  80076d:	c9                   	leave  
  80076e:	c3                   	ret    

0080076f <cprintf>:

int cprintf(const char *fmt, ...) {
  80076f:	55                   	push   %ebp
  800770:	89 e5                	mov    %esp,%ebp
  800772:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  800775:	c6 05 24 40 80 00 01 	movb   $0x1,0x804024
	va_start(ap, fmt);
  80077c:	8d 45 0c             	lea    0xc(%ebp),%eax
  80077f:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800782:	8b 45 08             	mov    0x8(%ebp),%eax
  800785:	83 ec 08             	sub    $0x8,%esp
  800788:	ff 75 f4             	pushl  -0xc(%ebp)
  80078b:	50                   	push   %eax
  80078c:	e8 73 ff ff ff       	call   800704 <vcprintf>
  800791:	83 c4 10             	add    $0x10,%esp
  800794:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  800797:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  80079a:	c9                   	leave  
  80079b:	c3                   	ret    

0080079c <atomic_cprintf>:

int atomic_cprintf(const char *fmt, ...) {
  80079c:	55                   	push   %ebp
  80079d:	89 e5                	mov    %esp,%ebp
  80079f:	83 ec 18             	sub    $0x18,%esp
	sys_disable_interrupt();
  8007a2:	e8 53 14 00 00       	call   801bfa <sys_disable_interrupt>
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  8007a7:	8d 45 0c             	lea    0xc(%ebp),%eax
  8007aa:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  8007ad:	8b 45 08             	mov    0x8(%ebp),%eax
  8007b0:	83 ec 08             	sub    $0x8,%esp
  8007b3:	ff 75 f4             	pushl  -0xc(%ebp)
  8007b6:	50                   	push   %eax
  8007b7:	e8 48 ff ff ff       	call   800704 <vcprintf>
  8007bc:	83 c4 10             	add    $0x10,%esp
  8007bf:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	sys_enable_interrupt();
  8007c2:	e8 4d 14 00 00       	call   801c14 <sys_enable_interrupt>
	return cnt;
  8007c7:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8007ca:	c9                   	leave  
  8007cb:	c3                   	ret    

008007cc <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  8007cc:	55                   	push   %ebp
  8007cd:	89 e5                	mov    %esp,%ebp
  8007cf:	53                   	push   %ebx
  8007d0:	83 ec 14             	sub    $0x14,%esp
  8007d3:	8b 45 10             	mov    0x10(%ebp),%eax
  8007d6:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8007d9:	8b 45 14             	mov    0x14(%ebp),%eax
  8007dc:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  8007df:	8b 45 18             	mov    0x18(%ebp),%eax
  8007e2:	ba 00 00 00 00       	mov    $0x0,%edx
  8007e7:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  8007ea:	77 55                	ja     800841 <printnum+0x75>
  8007ec:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  8007ef:	72 05                	jb     8007f6 <printnum+0x2a>
  8007f1:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8007f4:	77 4b                	ja     800841 <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  8007f6:	8b 45 1c             	mov    0x1c(%ebp),%eax
  8007f9:	8d 58 ff             	lea    -0x1(%eax),%ebx
  8007fc:	8b 45 18             	mov    0x18(%ebp),%eax
  8007ff:	ba 00 00 00 00       	mov    $0x0,%edx
  800804:	52                   	push   %edx
  800805:	50                   	push   %eax
  800806:	ff 75 f4             	pushl  -0xc(%ebp)
  800809:	ff 75 f0             	pushl  -0x10(%ebp)
  80080c:	e8 3b 29 00 00       	call   80314c <__udivdi3>
  800811:	83 c4 10             	add    $0x10,%esp
  800814:	83 ec 04             	sub    $0x4,%esp
  800817:	ff 75 20             	pushl  0x20(%ebp)
  80081a:	53                   	push   %ebx
  80081b:	ff 75 18             	pushl  0x18(%ebp)
  80081e:	52                   	push   %edx
  80081f:	50                   	push   %eax
  800820:	ff 75 0c             	pushl  0xc(%ebp)
  800823:	ff 75 08             	pushl  0x8(%ebp)
  800826:	e8 a1 ff ff ff       	call   8007cc <printnum>
  80082b:	83 c4 20             	add    $0x20,%esp
  80082e:	eb 1a                	jmp    80084a <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  800830:	83 ec 08             	sub    $0x8,%esp
  800833:	ff 75 0c             	pushl  0xc(%ebp)
  800836:	ff 75 20             	pushl  0x20(%ebp)
  800839:	8b 45 08             	mov    0x8(%ebp),%eax
  80083c:	ff d0                	call   *%eax
  80083e:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800841:	ff 4d 1c             	decl   0x1c(%ebp)
  800844:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  800848:	7f e6                	jg     800830 <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  80084a:	8b 4d 18             	mov    0x18(%ebp),%ecx
  80084d:	bb 00 00 00 00       	mov    $0x0,%ebx
  800852:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800855:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800858:	53                   	push   %ebx
  800859:	51                   	push   %ecx
  80085a:	52                   	push   %edx
  80085b:	50                   	push   %eax
  80085c:	e8 fb 29 00 00       	call   80325c <__umoddi3>
  800861:	83 c4 10             	add    $0x10,%esp
  800864:	05 74 3a 80 00       	add    $0x803a74,%eax
  800869:	8a 00                	mov    (%eax),%al
  80086b:	0f be c0             	movsbl %al,%eax
  80086e:	83 ec 08             	sub    $0x8,%esp
  800871:	ff 75 0c             	pushl  0xc(%ebp)
  800874:	50                   	push   %eax
  800875:	8b 45 08             	mov    0x8(%ebp),%eax
  800878:	ff d0                	call   *%eax
  80087a:	83 c4 10             	add    $0x10,%esp
}
  80087d:	90                   	nop
  80087e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800881:	c9                   	leave  
  800882:	c3                   	ret    

00800883 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  800883:	55                   	push   %ebp
  800884:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800886:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  80088a:	7e 1c                	jle    8008a8 <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  80088c:	8b 45 08             	mov    0x8(%ebp),%eax
  80088f:	8b 00                	mov    (%eax),%eax
  800891:	8d 50 08             	lea    0x8(%eax),%edx
  800894:	8b 45 08             	mov    0x8(%ebp),%eax
  800897:	89 10                	mov    %edx,(%eax)
  800899:	8b 45 08             	mov    0x8(%ebp),%eax
  80089c:	8b 00                	mov    (%eax),%eax
  80089e:	83 e8 08             	sub    $0x8,%eax
  8008a1:	8b 50 04             	mov    0x4(%eax),%edx
  8008a4:	8b 00                	mov    (%eax),%eax
  8008a6:	eb 40                	jmp    8008e8 <getuint+0x65>
	else if (lflag)
  8008a8:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8008ac:	74 1e                	je     8008cc <getuint+0x49>
		return va_arg(*ap, unsigned long);
  8008ae:	8b 45 08             	mov    0x8(%ebp),%eax
  8008b1:	8b 00                	mov    (%eax),%eax
  8008b3:	8d 50 04             	lea    0x4(%eax),%edx
  8008b6:	8b 45 08             	mov    0x8(%ebp),%eax
  8008b9:	89 10                	mov    %edx,(%eax)
  8008bb:	8b 45 08             	mov    0x8(%ebp),%eax
  8008be:	8b 00                	mov    (%eax),%eax
  8008c0:	83 e8 04             	sub    $0x4,%eax
  8008c3:	8b 00                	mov    (%eax),%eax
  8008c5:	ba 00 00 00 00       	mov    $0x0,%edx
  8008ca:	eb 1c                	jmp    8008e8 <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  8008cc:	8b 45 08             	mov    0x8(%ebp),%eax
  8008cf:	8b 00                	mov    (%eax),%eax
  8008d1:	8d 50 04             	lea    0x4(%eax),%edx
  8008d4:	8b 45 08             	mov    0x8(%ebp),%eax
  8008d7:	89 10                	mov    %edx,(%eax)
  8008d9:	8b 45 08             	mov    0x8(%ebp),%eax
  8008dc:	8b 00                	mov    (%eax),%eax
  8008de:	83 e8 04             	sub    $0x4,%eax
  8008e1:	8b 00                	mov    (%eax),%eax
  8008e3:	ba 00 00 00 00       	mov    $0x0,%edx
}
  8008e8:	5d                   	pop    %ebp
  8008e9:	c3                   	ret    

008008ea <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  8008ea:	55                   	push   %ebp
  8008eb:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  8008ed:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  8008f1:	7e 1c                	jle    80090f <getint+0x25>
		return va_arg(*ap, long long);
  8008f3:	8b 45 08             	mov    0x8(%ebp),%eax
  8008f6:	8b 00                	mov    (%eax),%eax
  8008f8:	8d 50 08             	lea    0x8(%eax),%edx
  8008fb:	8b 45 08             	mov    0x8(%ebp),%eax
  8008fe:	89 10                	mov    %edx,(%eax)
  800900:	8b 45 08             	mov    0x8(%ebp),%eax
  800903:	8b 00                	mov    (%eax),%eax
  800905:	83 e8 08             	sub    $0x8,%eax
  800908:	8b 50 04             	mov    0x4(%eax),%edx
  80090b:	8b 00                	mov    (%eax),%eax
  80090d:	eb 38                	jmp    800947 <getint+0x5d>
	else if (lflag)
  80090f:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800913:	74 1a                	je     80092f <getint+0x45>
		return va_arg(*ap, long);
  800915:	8b 45 08             	mov    0x8(%ebp),%eax
  800918:	8b 00                	mov    (%eax),%eax
  80091a:	8d 50 04             	lea    0x4(%eax),%edx
  80091d:	8b 45 08             	mov    0x8(%ebp),%eax
  800920:	89 10                	mov    %edx,(%eax)
  800922:	8b 45 08             	mov    0x8(%ebp),%eax
  800925:	8b 00                	mov    (%eax),%eax
  800927:	83 e8 04             	sub    $0x4,%eax
  80092a:	8b 00                	mov    (%eax),%eax
  80092c:	99                   	cltd   
  80092d:	eb 18                	jmp    800947 <getint+0x5d>
	else
		return va_arg(*ap, int);
  80092f:	8b 45 08             	mov    0x8(%ebp),%eax
  800932:	8b 00                	mov    (%eax),%eax
  800934:	8d 50 04             	lea    0x4(%eax),%edx
  800937:	8b 45 08             	mov    0x8(%ebp),%eax
  80093a:	89 10                	mov    %edx,(%eax)
  80093c:	8b 45 08             	mov    0x8(%ebp),%eax
  80093f:	8b 00                	mov    (%eax),%eax
  800941:	83 e8 04             	sub    $0x4,%eax
  800944:	8b 00                	mov    (%eax),%eax
  800946:	99                   	cltd   
}
  800947:	5d                   	pop    %ebp
  800948:	c3                   	ret    

00800949 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  800949:	55                   	push   %ebp
  80094a:	89 e5                	mov    %esp,%ebp
  80094c:	56                   	push   %esi
  80094d:	53                   	push   %ebx
  80094e:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800951:	eb 17                	jmp    80096a <vprintfmt+0x21>
			if (ch == '\0')
  800953:	85 db                	test   %ebx,%ebx
  800955:	0f 84 af 03 00 00    	je     800d0a <vprintfmt+0x3c1>
				return;
			putch(ch, putdat);
  80095b:	83 ec 08             	sub    $0x8,%esp
  80095e:	ff 75 0c             	pushl  0xc(%ebp)
  800961:	53                   	push   %ebx
  800962:	8b 45 08             	mov    0x8(%ebp),%eax
  800965:	ff d0                	call   *%eax
  800967:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  80096a:	8b 45 10             	mov    0x10(%ebp),%eax
  80096d:	8d 50 01             	lea    0x1(%eax),%edx
  800970:	89 55 10             	mov    %edx,0x10(%ebp)
  800973:	8a 00                	mov    (%eax),%al
  800975:	0f b6 d8             	movzbl %al,%ebx
  800978:	83 fb 25             	cmp    $0x25,%ebx
  80097b:	75 d6                	jne    800953 <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  80097d:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  800981:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  800988:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  80098f:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  800996:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  80099d:	8b 45 10             	mov    0x10(%ebp),%eax
  8009a0:	8d 50 01             	lea    0x1(%eax),%edx
  8009a3:	89 55 10             	mov    %edx,0x10(%ebp)
  8009a6:	8a 00                	mov    (%eax),%al
  8009a8:	0f b6 d8             	movzbl %al,%ebx
  8009ab:	8d 43 dd             	lea    -0x23(%ebx),%eax
  8009ae:	83 f8 55             	cmp    $0x55,%eax
  8009b1:	0f 87 2b 03 00 00    	ja     800ce2 <vprintfmt+0x399>
  8009b7:	8b 04 85 98 3a 80 00 	mov    0x803a98(,%eax,4),%eax
  8009be:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  8009c0:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  8009c4:	eb d7                	jmp    80099d <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  8009c6:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  8009ca:	eb d1                	jmp    80099d <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8009cc:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  8009d3:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8009d6:	89 d0                	mov    %edx,%eax
  8009d8:	c1 e0 02             	shl    $0x2,%eax
  8009db:	01 d0                	add    %edx,%eax
  8009dd:	01 c0                	add    %eax,%eax
  8009df:	01 d8                	add    %ebx,%eax
  8009e1:	83 e8 30             	sub    $0x30,%eax
  8009e4:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  8009e7:	8b 45 10             	mov    0x10(%ebp),%eax
  8009ea:	8a 00                	mov    (%eax),%al
  8009ec:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  8009ef:	83 fb 2f             	cmp    $0x2f,%ebx
  8009f2:	7e 3e                	jle    800a32 <vprintfmt+0xe9>
  8009f4:	83 fb 39             	cmp    $0x39,%ebx
  8009f7:	7f 39                	jg     800a32 <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8009f9:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  8009fc:	eb d5                	jmp    8009d3 <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  8009fe:	8b 45 14             	mov    0x14(%ebp),%eax
  800a01:	83 c0 04             	add    $0x4,%eax
  800a04:	89 45 14             	mov    %eax,0x14(%ebp)
  800a07:	8b 45 14             	mov    0x14(%ebp),%eax
  800a0a:	83 e8 04             	sub    $0x4,%eax
  800a0d:	8b 00                	mov    (%eax),%eax
  800a0f:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  800a12:	eb 1f                	jmp    800a33 <vprintfmt+0xea>

		case '.':
			if (width < 0)
  800a14:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800a18:	79 83                	jns    80099d <vprintfmt+0x54>
				width = 0;
  800a1a:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  800a21:	e9 77 ff ff ff       	jmp    80099d <vprintfmt+0x54>

		case '#':
			altflag = 1;
  800a26:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  800a2d:	e9 6b ff ff ff       	jmp    80099d <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  800a32:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  800a33:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800a37:	0f 89 60 ff ff ff    	jns    80099d <vprintfmt+0x54>
				width = precision, precision = -1;
  800a3d:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800a40:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800a43:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  800a4a:	e9 4e ff ff ff       	jmp    80099d <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  800a4f:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  800a52:	e9 46 ff ff ff       	jmp    80099d <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  800a57:	8b 45 14             	mov    0x14(%ebp),%eax
  800a5a:	83 c0 04             	add    $0x4,%eax
  800a5d:	89 45 14             	mov    %eax,0x14(%ebp)
  800a60:	8b 45 14             	mov    0x14(%ebp),%eax
  800a63:	83 e8 04             	sub    $0x4,%eax
  800a66:	8b 00                	mov    (%eax),%eax
  800a68:	83 ec 08             	sub    $0x8,%esp
  800a6b:	ff 75 0c             	pushl  0xc(%ebp)
  800a6e:	50                   	push   %eax
  800a6f:	8b 45 08             	mov    0x8(%ebp),%eax
  800a72:	ff d0                	call   *%eax
  800a74:	83 c4 10             	add    $0x10,%esp
			break;
  800a77:	e9 89 02 00 00       	jmp    800d05 <vprintfmt+0x3bc>

		// error message
		case 'e':
			err = va_arg(ap, int);
  800a7c:	8b 45 14             	mov    0x14(%ebp),%eax
  800a7f:	83 c0 04             	add    $0x4,%eax
  800a82:	89 45 14             	mov    %eax,0x14(%ebp)
  800a85:	8b 45 14             	mov    0x14(%ebp),%eax
  800a88:	83 e8 04             	sub    $0x4,%eax
  800a8b:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  800a8d:	85 db                	test   %ebx,%ebx
  800a8f:	79 02                	jns    800a93 <vprintfmt+0x14a>
				err = -err;
  800a91:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  800a93:	83 fb 64             	cmp    $0x64,%ebx
  800a96:	7f 0b                	jg     800aa3 <vprintfmt+0x15a>
  800a98:	8b 34 9d e0 38 80 00 	mov    0x8038e0(,%ebx,4),%esi
  800a9f:	85 f6                	test   %esi,%esi
  800aa1:	75 19                	jne    800abc <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  800aa3:	53                   	push   %ebx
  800aa4:	68 85 3a 80 00       	push   $0x803a85
  800aa9:	ff 75 0c             	pushl  0xc(%ebp)
  800aac:	ff 75 08             	pushl  0x8(%ebp)
  800aaf:	e8 5e 02 00 00       	call   800d12 <printfmt>
  800ab4:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  800ab7:	e9 49 02 00 00       	jmp    800d05 <vprintfmt+0x3bc>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  800abc:	56                   	push   %esi
  800abd:	68 8e 3a 80 00       	push   $0x803a8e
  800ac2:	ff 75 0c             	pushl  0xc(%ebp)
  800ac5:	ff 75 08             	pushl  0x8(%ebp)
  800ac8:	e8 45 02 00 00       	call   800d12 <printfmt>
  800acd:	83 c4 10             	add    $0x10,%esp
			break;
  800ad0:	e9 30 02 00 00       	jmp    800d05 <vprintfmt+0x3bc>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  800ad5:	8b 45 14             	mov    0x14(%ebp),%eax
  800ad8:	83 c0 04             	add    $0x4,%eax
  800adb:	89 45 14             	mov    %eax,0x14(%ebp)
  800ade:	8b 45 14             	mov    0x14(%ebp),%eax
  800ae1:	83 e8 04             	sub    $0x4,%eax
  800ae4:	8b 30                	mov    (%eax),%esi
  800ae6:	85 f6                	test   %esi,%esi
  800ae8:	75 05                	jne    800aef <vprintfmt+0x1a6>
				p = "(null)";
  800aea:	be 91 3a 80 00       	mov    $0x803a91,%esi
			if (width > 0 && padc != '-')
  800aef:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800af3:	7e 6d                	jle    800b62 <vprintfmt+0x219>
  800af5:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  800af9:	74 67                	je     800b62 <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  800afb:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800afe:	83 ec 08             	sub    $0x8,%esp
  800b01:	50                   	push   %eax
  800b02:	56                   	push   %esi
  800b03:	e8 0c 03 00 00       	call   800e14 <strnlen>
  800b08:	83 c4 10             	add    $0x10,%esp
  800b0b:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  800b0e:	eb 16                	jmp    800b26 <vprintfmt+0x1dd>
					putch(padc, putdat);
  800b10:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  800b14:	83 ec 08             	sub    $0x8,%esp
  800b17:	ff 75 0c             	pushl  0xc(%ebp)
  800b1a:	50                   	push   %eax
  800b1b:	8b 45 08             	mov    0x8(%ebp),%eax
  800b1e:	ff d0                	call   *%eax
  800b20:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800b23:	ff 4d e4             	decl   -0x1c(%ebp)
  800b26:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800b2a:	7f e4                	jg     800b10 <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800b2c:	eb 34                	jmp    800b62 <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  800b2e:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  800b32:	74 1c                	je     800b50 <vprintfmt+0x207>
  800b34:	83 fb 1f             	cmp    $0x1f,%ebx
  800b37:	7e 05                	jle    800b3e <vprintfmt+0x1f5>
  800b39:	83 fb 7e             	cmp    $0x7e,%ebx
  800b3c:	7e 12                	jle    800b50 <vprintfmt+0x207>
					putch('?', putdat);
  800b3e:	83 ec 08             	sub    $0x8,%esp
  800b41:	ff 75 0c             	pushl  0xc(%ebp)
  800b44:	6a 3f                	push   $0x3f
  800b46:	8b 45 08             	mov    0x8(%ebp),%eax
  800b49:	ff d0                	call   *%eax
  800b4b:	83 c4 10             	add    $0x10,%esp
  800b4e:	eb 0f                	jmp    800b5f <vprintfmt+0x216>
				else
					putch(ch, putdat);
  800b50:	83 ec 08             	sub    $0x8,%esp
  800b53:	ff 75 0c             	pushl  0xc(%ebp)
  800b56:	53                   	push   %ebx
  800b57:	8b 45 08             	mov    0x8(%ebp),%eax
  800b5a:	ff d0                	call   *%eax
  800b5c:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800b5f:	ff 4d e4             	decl   -0x1c(%ebp)
  800b62:	89 f0                	mov    %esi,%eax
  800b64:	8d 70 01             	lea    0x1(%eax),%esi
  800b67:	8a 00                	mov    (%eax),%al
  800b69:	0f be d8             	movsbl %al,%ebx
  800b6c:	85 db                	test   %ebx,%ebx
  800b6e:	74 24                	je     800b94 <vprintfmt+0x24b>
  800b70:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800b74:	78 b8                	js     800b2e <vprintfmt+0x1e5>
  800b76:	ff 4d e0             	decl   -0x20(%ebp)
  800b79:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800b7d:	79 af                	jns    800b2e <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800b7f:	eb 13                	jmp    800b94 <vprintfmt+0x24b>
				putch(' ', putdat);
  800b81:	83 ec 08             	sub    $0x8,%esp
  800b84:	ff 75 0c             	pushl  0xc(%ebp)
  800b87:	6a 20                	push   $0x20
  800b89:	8b 45 08             	mov    0x8(%ebp),%eax
  800b8c:	ff d0                	call   *%eax
  800b8e:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800b91:	ff 4d e4             	decl   -0x1c(%ebp)
  800b94:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800b98:	7f e7                	jg     800b81 <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  800b9a:	e9 66 01 00 00       	jmp    800d05 <vprintfmt+0x3bc>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  800b9f:	83 ec 08             	sub    $0x8,%esp
  800ba2:	ff 75 e8             	pushl  -0x18(%ebp)
  800ba5:	8d 45 14             	lea    0x14(%ebp),%eax
  800ba8:	50                   	push   %eax
  800ba9:	e8 3c fd ff ff       	call   8008ea <getint>
  800bae:	83 c4 10             	add    $0x10,%esp
  800bb1:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800bb4:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  800bb7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800bba:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800bbd:	85 d2                	test   %edx,%edx
  800bbf:	79 23                	jns    800be4 <vprintfmt+0x29b>
				putch('-', putdat);
  800bc1:	83 ec 08             	sub    $0x8,%esp
  800bc4:	ff 75 0c             	pushl  0xc(%ebp)
  800bc7:	6a 2d                	push   $0x2d
  800bc9:	8b 45 08             	mov    0x8(%ebp),%eax
  800bcc:	ff d0                	call   *%eax
  800bce:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  800bd1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800bd4:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800bd7:	f7 d8                	neg    %eax
  800bd9:	83 d2 00             	adc    $0x0,%edx
  800bdc:	f7 da                	neg    %edx
  800bde:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800be1:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  800be4:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800beb:	e9 bc 00 00 00       	jmp    800cac <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  800bf0:	83 ec 08             	sub    $0x8,%esp
  800bf3:	ff 75 e8             	pushl  -0x18(%ebp)
  800bf6:	8d 45 14             	lea    0x14(%ebp),%eax
  800bf9:	50                   	push   %eax
  800bfa:	e8 84 fc ff ff       	call   800883 <getuint>
  800bff:	83 c4 10             	add    $0x10,%esp
  800c02:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800c05:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  800c08:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800c0f:	e9 98 00 00 00       	jmp    800cac <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  800c14:	83 ec 08             	sub    $0x8,%esp
  800c17:	ff 75 0c             	pushl  0xc(%ebp)
  800c1a:	6a 58                	push   $0x58
  800c1c:	8b 45 08             	mov    0x8(%ebp),%eax
  800c1f:	ff d0                	call   *%eax
  800c21:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800c24:	83 ec 08             	sub    $0x8,%esp
  800c27:	ff 75 0c             	pushl  0xc(%ebp)
  800c2a:	6a 58                	push   $0x58
  800c2c:	8b 45 08             	mov    0x8(%ebp),%eax
  800c2f:	ff d0                	call   *%eax
  800c31:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800c34:	83 ec 08             	sub    $0x8,%esp
  800c37:	ff 75 0c             	pushl  0xc(%ebp)
  800c3a:	6a 58                	push   $0x58
  800c3c:	8b 45 08             	mov    0x8(%ebp),%eax
  800c3f:	ff d0                	call   *%eax
  800c41:	83 c4 10             	add    $0x10,%esp
			break;
  800c44:	e9 bc 00 00 00       	jmp    800d05 <vprintfmt+0x3bc>

		// pointer
		case 'p':
			putch('0', putdat);
  800c49:	83 ec 08             	sub    $0x8,%esp
  800c4c:	ff 75 0c             	pushl  0xc(%ebp)
  800c4f:	6a 30                	push   $0x30
  800c51:	8b 45 08             	mov    0x8(%ebp),%eax
  800c54:	ff d0                	call   *%eax
  800c56:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  800c59:	83 ec 08             	sub    $0x8,%esp
  800c5c:	ff 75 0c             	pushl  0xc(%ebp)
  800c5f:	6a 78                	push   $0x78
  800c61:	8b 45 08             	mov    0x8(%ebp),%eax
  800c64:	ff d0                	call   *%eax
  800c66:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  800c69:	8b 45 14             	mov    0x14(%ebp),%eax
  800c6c:	83 c0 04             	add    $0x4,%eax
  800c6f:	89 45 14             	mov    %eax,0x14(%ebp)
  800c72:	8b 45 14             	mov    0x14(%ebp),%eax
  800c75:	83 e8 04             	sub    $0x4,%eax
  800c78:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800c7a:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800c7d:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  800c84:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  800c8b:	eb 1f                	jmp    800cac <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  800c8d:	83 ec 08             	sub    $0x8,%esp
  800c90:	ff 75 e8             	pushl  -0x18(%ebp)
  800c93:	8d 45 14             	lea    0x14(%ebp),%eax
  800c96:	50                   	push   %eax
  800c97:	e8 e7 fb ff ff       	call   800883 <getuint>
  800c9c:	83 c4 10             	add    $0x10,%esp
  800c9f:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800ca2:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  800ca5:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800cac:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  800cb0:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800cb3:	83 ec 04             	sub    $0x4,%esp
  800cb6:	52                   	push   %edx
  800cb7:	ff 75 e4             	pushl  -0x1c(%ebp)
  800cba:	50                   	push   %eax
  800cbb:	ff 75 f4             	pushl  -0xc(%ebp)
  800cbe:	ff 75 f0             	pushl  -0x10(%ebp)
  800cc1:	ff 75 0c             	pushl  0xc(%ebp)
  800cc4:	ff 75 08             	pushl  0x8(%ebp)
  800cc7:	e8 00 fb ff ff       	call   8007cc <printnum>
  800ccc:	83 c4 20             	add    $0x20,%esp
			break;
  800ccf:	eb 34                	jmp    800d05 <vprintfmt+0x3bc>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  800cd1:	83 ec 08             	sub    $0x8,%esp
  800cd4:	ff 75 0c             	pushl  0xc(%ebp)
  800cd7:	53                   	push   %ebx
  800cd8:	8b 45 08             	mov    0x8(%ebp),%eax
  800cdb:	ff d0                	call   *%eax
  800cdd:	83 c4 10             	add    $0x10,%esp
			break;
  800ce0:	eb 23                	jmp    800d05 <vprintfmt+0x3bc>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800ce2:	83 ec 08             	sub    $0x8,%esp
  800ce5:	ff 75 0c             	pushl  0xc(%ebp)
  800ce8:	6a 25                	push   $0x25
  800cea:	8b 45 08             	mov    0x8(%ebp),%eax
  800ced:	ff d0                	call   *%eax
  800cef:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  800cf2:	ff 4d 10             	decl   0x10(%ebp)
  800cf5:	eb 03                	jmp    800cfa <vprintfmt+0x3b1>
  800cf7:	ff 4d 10             	decl   0x10(%ebp)
  800cfa:	8b 45 10             	mov    0x10(%ebp),%eax
  800cfd:	48                   	dec    %eax
  800cfe:	8a 00                	mov    (%eax),%al
  800d00:	3c 25                	cmp    $0x25,%al
  800d02:	75 f3                	jne    800cf7 <vprintfmt+0x3ae>
				/* do nothing */;
			break;
  800d04:	90                   	nop
		}
	}
  800d05:	e9 47 fc ff ff       	jmp    800951 <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  800d0a:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  800d0b:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800d0e:	5b                   	pop    %ebx
  800d0f:	5e                   	pop    %esi
  800d10:	5d                   	pop    %ebp
  800d11:	c3                   	ret    

00800d12 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800d12:	55                   	push   %ebp
  800d13:	89 e5                	mov    %esp,%ebp
  800d15:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  800d18:	8d 45 10             	lea    0x10(%ebp),%eax
  800d1b:	83 c0 04             	add    $0x4,%eax
  800d1e:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  800d21:	8b 45 10             	mov    0x10(%ebp),%eax
  800d24:	ff 75 f4             	pushl  -0xc(%ebp)
  800d27:	50                   	push   %eax
  800d28:	ff 75 0c             	pushl  0xc(%ebp)
  800d2b:	ff 75 08             	pushl  0x8(%ebp)
  800d2e:	e8 16 fc ff ff       	call   800949 <vprintfmt>
  800d33:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  800d36:	90                   	nop
  800d37:	c9                   	leave  
  800d38:	c3                   	ret    

00800d39 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800d39:	55                   	push   %ebp
  800d3a:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  800d3c:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d3f:	8b 40 08             	mov    0x8(%eax),%eax
  800d42:	8d 50 01             	lea    0x1(%eax),%edx
  800d45:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d48:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  800d4b:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d4e:	8b 10                	mov    (%eax),%edx
  800d50:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d53:	8b 40 04             	mov    0x4(%eax),%eax
  800d56:	39 c2                	cmp    %eax,%edx
  800d58:	73 12                	jae    800d6c <sprintputch+0x33>
		*b->buf++ = ch;
  800d5a:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d5d:	8b 00                	mov    (%eax),%eax
  800d5f:	8d 48 01             	lea    0x1(%eax),%ecx
  800d62:	8b 55 0c             	mov    0xc(%ebp),%edx
  800d65:	89 0a                	mov    %ecx,(%edx)
  800d67:	8b 55 08             	mov    0x8(%ebp),%edx
  800d6a:	88 10                	mov    %dl,(%eax)
}
  800d6c:	90                   	nop
  800d6d:	5d                   	pop    %ebp
  800d6e:	c3                   	ret    

00800d6f <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800d6f:	55                   	push   %ebp
  800d70:	89 e5                	mov    %esp,%ebp
  800d72:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  800d75:	8b 45 08             	mov    0x8(%ebp),%eax
  800d78:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800d7b:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d7e:	8d 50 ff             	lea    -0x1(%eax),%edx
  800d81:	8b 45 08             	mov    0x8(%ebp),%eax
  800d84:	01 d0                	add    %edx,%eax
  800d86:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800d89:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800d90:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800d94:	74 06                	je     800d9c <vsnprintf+0x2d>
  800d96:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800d9a:	7f 07                	jg     800da3 <vsnprintf+0x34>
		return -E_INVAL;
  800d9c:	b8 03 00 00 00       	mov    $0x3,%eax
  800da1:	eb 20                	jmp    800dc3 <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800da3:	ff 75 14             	pushl  0x14(%ebp)
  800da6:	ff 75 10             	pushl  0x10(%ebp)
  800da9:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800dac:	50                   	push   %eax
  800dad:	68 39 0d 80 00       	push   $0x800d39
  800db2:	e8 92 fb ff ff       	call   800949 <vprintfmt>
  800db7:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  800dba:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800dbd:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800dc0:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  800dc3:	c9                   	leave  
  800dc4:	c3                   	ret    

00800dc5 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800dc5:	55                   	push   %ebp
  800dc6:	89 e5                	mov    %esp,%ebp
  800dc8:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800dcb:	8d 45 10             	lea    0x10(%ebp),%eax
  800dce:	83 c0 04             	add    $0x4,%eax
  800dd1:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  800dd4:	8b 45 10             	mov    0x10(%ebp),%eax
  800dd7:	ff 75 f4             	pushl  -0xc(%ebp)
  800dda:	50                   	push   %eax
  800ddb:	ff 75 0c             	pushl  0xc(%ebp)
  800dde:	ff 75 08             	pushl  0x8(%ebp)
  800de1:	e8 89 ff ff ff       	call   800d6f <vsnprintf>
  800de6:	83 c4 10             	add    $0x10,%esp
  800de9:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  800dec:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800def:	c9                   	leave  
  800df0:	c3                   	ret    

00800df1 <strlen>:

#include <inc/string.h>

int
strlen(const char *s)
{
  800df1:	55                   	push   %ebp
  800df2:	89 e5                	mov    %esp,%ebp
  800df4:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  800df7:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800dfe:	eb 06                	jmp    800e06 <strlen+0x15>
		n++;
  800e00:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  800e03:	ff 45 08             	incl   0x8(%ebp)
  800e06:	8b 45 08             	mov    0x8(%ebp),%eax
  800e09:	8a 00                	mov    (%eax),%al
  800e0b:	84 c0                	test   %al,%al
  800e0d:	75 f1                	jne    800e00 <strlen+0xf>
		n++;
	return n;
  800e0f:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800e12:	c9                   	leave  
  800e13:	c3                   	ret    

00800e14 <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  800e14:	55                   	push   %ebp
  800e15:	89 e5                	mov    %esp,%ebp
  800e17:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800e1a:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800e21:	eb 09                	jmp    800e2c <strnlen+0x18>
		n++;
  800e23:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800e26:	ff 45 08             	incl   0x8(%ebp)
  800e29:	ff 4d 0c             	decl   0xc(%ebp)
  800e2c:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800e30:	74 09                	je     800e3b <strnlen+0x27>
  800e32:	8b 45 08             	mov    0x8(%ebp),%eax
  800e35:	8a 00                	mov    (%eax),%al
  800e37:	84 c0                	test   %al,%al
  800e39:	75 e8                	jne    800e23 <strnlen+0xf>
		n++;
	return n;
  800e3b:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800e3e:	c9                   	leave  
  800e3f:	c3                   	ret    

00800e40 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800e40:	55                   	push   %ebp
  800e41:	89 e5                	mov    %esp,%ebp
  800e43:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  800e46:	8b 45 08             	mov    0x8(%ebp),%eax
  800e49:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  800e4c:	90                   	nop
  800e4d:	8b 45 08             	mov    0x8(%ebp),%eax
  800e50:	8d 50 01             	lea    0x1(%eax),%edx
  800e53:	89 55 08             	mov    %edx,0x8(%ebp)
  800e56:	8b 55 0c             	mov    0xc(%ebp),%edx
  800e59:	8d 4a 01             	lea    0x1(%edx),%ecx
  800e5c:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800e5f:	8a 12                	mov    (%edx),%dl
  800e61:	88 10                	mov    %dl,(%eax)
  800e63:	8a 00                	mov    (%eax),%al
  800e65:	84 c0                	test   %al,%al
  800e67:	75 e4                	jne    800e4d <strcpy+0xd>
		/* do nothing */;
	return ret;
  800e69:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800e6c:	c9                   	leave  
  800e6d:	c3                   	ret    

00800e6e <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  800e6e:	55                   	push   %ebp
  800e6f:	89 e5                	mov    %esp,%ebp
  800e71:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  800e74:	8b 45 08             	mov    0x8(%ebp),%eax
  800e77:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  800e7a:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800e81:	eb 1f                	jmp    800ea2 <strncpy+0x34>
		*dst++ = *src;
  800e83:	8b 45 08             	mov    0x8(%ebp),%eax
  800e86:	8d 50 01             	lea    0x1(%eax),%edx
  800e89:	89 55 08             	mov    %edx,0x8(%ebp)
  800e8c:	8b 55 0c             	mov    0xc(%ebp),%edx
  800e8f:	8a 12                	mov    (%edx),%dl
  800e91:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  800e93:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e96:	8a 00                	mov    (%eax),%al
  800e98:	84 c0                	test   %al,%al
  800e9a:	74 03                	je     800e9f <strncpy+0x31>
			src++;
  800e9c:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800e9f:	ff 45 fc             	incl   -0x4(%ebp)
  800ea2:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800ea5:	3b 45 10             	cmp    0x10(%ebp),%eax
  800ea8:	72 d9                	jb     800e83 <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  800eaa:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  800ead:	c9                   	leave  
  800eae:	c3                   	ret    

00800eaf <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  800eaf:	55                   	push   %ebp
  800eb0:	89 e5                	mov    %esp,%ebp
  800eb2:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  800eb5:	8b 45 08             	mov    0x8(%ebp),%eax
  800eb8:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  800ebb:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800ebf:	74 30                	je     800ef1 <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  800ec1:	eb 16                	jmp    800ed9 <strlcpy+0x2a>
			*dst++ = *src++;
  800ec3:	8b 45 08             	mov    0x8(%ebp),%eax
  800ec6:	8d 50 01             	lea    0x1(%eax),%edx
  800ec9:	89 55 08             	mov    %edx,0x8(%ebp)
  800ecc:	8b 55 0c             	mov    0xc(%ebp),%edx
  800ecf:	8d 4a 01             	lea    0x1(%edx),%ecx
  800ed2:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800ed5:	8a 12                	mov    (%edx),%dl
  800ed7:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  800ed9:	ff 4d 10             	decl   0x10(%ebp)
  800edc:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800ee0:	74 09                	je     800eeb <strlcpy+0x3c>
  800ee2:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ee5:	8a 00                	mov    (%eax),%al
  800ee7:	84 c0                	test   %al,%al
  800ee9:	75 d8                	jne    800ec3 <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  800eeb:	8b 45 08             	mov    0x8(%ebp),%eax
  800eee:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800ef1:	8b 55 08             	mov    0x8(%ebp),%edx
  800ef4:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800ef7:	29 c2                	sub    %eax,%edx
  800ef9:	89 d0                	mov    %edx,%eax
}
  800efb:	c9                   	leave  
  800efc:	c3                   	ret    

00800efd <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800efd:	55                   	push   %ebp
  800efe:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  800f00:	eb 06                	jmp    800f08 <strcmp+0xb>
		p++, q++;
  800f02:	ff 45 08             	incl   0x8(%ebp)
  800f05:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  800f08:	8b 45 08             	mov    0x8(%ebp),%eax
  800f0b:	8a 00                	mov    (%eax),%al
  800f0d:	84 c0                	test   %al,%al
  800f0f:	74 0e                	je     800f1f <strcmp+0x22>
  800f11:	8b 45 08             	mov    0x8(%ebp),%eax
  800f14:	8a 10                	mov    (%eax),%dl
  800f16:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f19:	8a 00                	mov    (%eax),%al
  800f1b:	38 c2                	cmp    %al,%dl
  800f1d:	74 e3                	je     800f02 <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800f1f:	8b 45 08             	mov    0x8(%ebp),%eax
  800f22:	8a 00                	mov    (%eax),%al
  800f24:	0f b6 d0             	movzbl %al,%edx
  800f27:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f2a:	8a 00                	mov    (%eax),%al
  800f2c:	0f b6 c0             	movzbl %al,%eax
  800f2f:	29 c2                	sub    %eax,%edx
  800f31:	89 d0                	mov    %edx,%eax
}
  800f33:	5d                   	pop    %ebp
  800f34:	c3                   	ret    

00800f35 <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  800f35:	55                   	push   %ebp
  800f36:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  800f38:	eb 09                	jmp    800f43 <strncmp+0xe>
		n--, p++, q++;
  800f3a:	ff 4d 10             	decl   0x10(%ebp)
  800f3d:	ff 45 08             	incl   0x8(%ebp)
  800f40:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  800f43:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800f47:	74 17                	je     800f60 <strncmp+0x2b>
  800f49:	8b 45 08             	mov    0x8(%ebp),%eax
  800f4c:	8a 00                	mov    (%eax),%al
  800f4e:	84 c0                	test   %al,%al
  800f50:	74 0e                	je     800f60 <strncmp+0x2b>
  800f52:	8b 45 08             	mov    0x8(%ebp),%eax
  800f55:	8a 10                	mov    (%eax),%dl
  800f57:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f5a:	8a 00                	mov    (%eax),%al
  800f5c:	38 c2                	cmp    %al,%dl
  800f5e:	74 da                	je     800f3a <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  800f60:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800f64:	75 07                	jne    800f6d <strncmp+0x38>
		return 0;
  800f66:	b8 00 00 00 00       	mov    $0x0,%eax
  800f6b:	eb 14                	jmp    800f81 <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800f6d:	8b 45 08             	mov    0x8(%ebp),%eax
  800f70:	8a 00                	mov    (%eax),%al
  800f72:	0f b6 d0             	movzbl %al,%edx
  800f75:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f78:	8a 00                	mov    (%eax),%al
  800f7a:	0f b6 c0             	movzbl %al,%eax
  800f7d:	29 c2                	sub    %eax,%edx
  800f7f:	89 d0                	mov    %edx,%eax
}
  800f81:	5d                   	pop    %ebp
  800f82:	c3                   	ret    

00800f83 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800f83:	55                   	push   %ebp
  800f84:	89 e5                	mov    %esp,%ebp
  800f86:	83 ec 04             	sub    $0x4,%esp
  800f89:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f8c:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800f8f:	eb 12                	jmp    800fa3 <strchr+0x20>
		if (*s == c)
  800f91:	8b 45 08             	mov    0x8(%ebp),%eax
  800f94:	8a 00                	mov    (%eax),%al
  800f96:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800f99:	75 05                	jne    800fa0 <strchr+0x1d>
			return (char *) s;
  800f9b:	8b 45 08             	mov    0x8(%ebp),%eax
  800f9e:	eb 11                	jmp    800fb1 <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  800fa0:	ff 45 08             	incl   0x8(%ebp)
  800fa3:	8b 45 08             	mov    0x8(%ebp),%eax
  800fa6:	8a 00                	mov    (%eax),%al
  800fa8:	84 c0                	test   %al,%al
  800faa:	75 e5                	jne    800f91 <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  800fac:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800fb1:	c9                   	leave  
  800fb2:	c3                   	ret    

00800fb3 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800fb3:	55                   	push   %ebp
  800fb4:	89 e5                	mov    %esp,%ebp
  800fb6:	83 ec 04             	sub    $0x4,%esp
  800fb9:	8b 45 0c             	mov    0xc(%ebp),%eax
  800fbc:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800fbf:	eb 0d                	jmp    800fce <strfind+0x1b>
		if (*s == c)
  800fc1:	8b 45 08             	mov    0x8(%ebp),%eax
  800fc4:	8a 00                	mov    (%eax),%al
  800fc6:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800fc9:	74 0e                	je     800fd9 <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  800fcb:	ff 45 08             	incl   0x8(%ebp)
  800fce:	8b 45 08             	mov    0x8(%ebp),%eax
  800fd1:	8a 00                	mov    (%eax),%al
  800fd3:	84 c0                	test   %al,%al
  800fd5:	75 ea                	jne    800fc1 <strfind+0xe>
  800fd7:	eb 01                	jmp    800fda <strfind+0x27>
		if (*s == c)
			break;
  800fd9:	90                   	nop
	return (char *) s;
  800fda:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800fdd:	c9                   	leave  
  800fde:	c3                   	ret    

00800fdf <memset>:


void *
memset(void *v, int c, uint32 n)
{
  800fdf:	55                   	push   %ebp
  800fe0:	89 e5                	mov    %esp,%ebp
  800fe2:	83 ec 10             	sub    $0x10,%esp
	char *p;
	int m;

	p = v;
  800fe5:	8b 45 08             	mov    0x8(%ebp),%eax
  800fe8:	89 45 fc             	mov    %eax,-0x4(%ebp)
	m = n;
  800feb:	8b 45 10             	mov    0x10(%ebp),%eax
  800fee:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (--m >= 0)
  800ff1:	eb 0e                	jmp    801001 <memset+0x22>
		*p++ = c;
  800ff3:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800ff6:	8d 50 01             	lea    0x1(%eax),%edx
  800ff9:	89 55 fc             	mov    %edx,-0x4(%ebp)
  800ffc:	8b 55 0c             	mov    0xc(%ebp),%edx
  800fff:	88 10                	mov    %dl,(%eax)
	char *p;
	int m;

	p = v;
	m = n;
	while (--m >= 0)
  801001:	ff 4d f8             	decl   -0x8(%ebp)
  801004:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
  801008:	79 e9                	jns    800ff3 <memset+0x14>
		*p++ = c;

	return v;
  80100a:	8b 45 08             	mov    0x8(%ebp),%eax
}
  80100d:	c9                   	leave  
  80100e:	c3                   	ret    

0080100f <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  80100f:	55                   	push   %ebp
  801010:	89 e5                	mov    %esp,%ebp
  801012:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  801015:	8b 45 0c             	mov    0xc(%ebp),%eax
  801018:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  80101b:	8b 45 08             	mov    0x8(%ebp),%eax
  80101e:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (n-- > 0)
  801021:	eb 16                	jmp    801039 <memcpy+0x2a>
		*d++ = *s++;
  801023:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801026:	8d 50 01             	lea    0x1(%eax),%edx
  801029:	89 55 f8             	mov    %edx,-0x8(%ebp)
  80102c:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80102f:	8d 4a 01             	lea    0x1(%edx),%ecx
  801032:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  801035:	8a 12                	mov    (%edx),%dl
  801037:	88 10                	mov    %dl,(%eax)
	const char *s;
	char *d;

	s = src;
	d = dst;
	while (n-- > 0)
  801039:	8b 45 10             	mov    0x10(%ebp),%eax
  80103c:	8d 50 ff             	lea    -0x1(%eax),%edx
  80103f:	89 55 10             	mov    %edx,0x10(%ebp)
  801042:	85 c0                	test   %eax,%eax
  801044:	75 dd                	jne    801023 <memcpy+0x14>
		*d++ = *s++;

	return dst;
  801046:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801049:	c9                   	leave  
  80104a:	c3                   	ret    

0080104b <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  80104b:	55                   	push   %ebp
  80104c:	89 e5                	mov    %esp,%ebp
  80104e:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  801051:	8b 45 0c             	mov    0xc(%ebp),%eax
  801054:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  801057:	8b 45 08             	mov    0x8(%ebp),%eax
  80105a:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  80105d:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801060:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  801063:	73 50                	jae    8010b5 <memmove+0x6a>
  801065:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801068:	8b 45 10             	mov    0x10(%ebp),%eax
  80106b:	01 d0                	add    %edx,%eax
  80106d:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  801070:	76 43                	jbe    8010b5 <memmove+0x6a>
		s += n;
  801072:	8b 45 10             	mov    0x10(%ebp),%eax
  801075:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  801078:	8b 45 10             	mov    0x10(%ebp),%eax
  80107b:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  80107e:	eb 10                	jmp    801090 <memmove+0x45>
			*--d = *--s;
  801080:	ff 4d f8             	decl   -0x8(%ebp)
  801083:	ff 4d fc             	decl   -0x4(%ebp)
  801086:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801089:	8a 10                	mov    (%eax),%dl
  80108b:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80108e:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  801090:	8b 45 10             	mov    0x10(%ebp),%eax
  801093:	8d 50 ff             	lea    -0x1(%eax),%edx
  801096:	89 55 10             	mov    %edx,0x10(%ebp)
  801099:	85 c0                	test   %eax,%eax
  80109b:	75 e3                	jne    801080 <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  80109d:	eb 23                	jmp    8010c2 <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  80109f:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8010a2:	8d 50 01             	lea    0x1(%eax),%edx
  8010a5:	89 55 f8             	mov    %edx,-0x8(%ebp)
  8010a8:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8010ab:	8d 4a 01             	lea    0x1(%edx),%ecx
  8010ae:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  8010b1:	8a 12                	mov    (%edx),%dl
  8010b3:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  8010b5:	8b 45 10             	mov    0x10(%ebp),%eax
  8010b8:	8d 50 ff             	lea    -0x1(%eax),%edx
  8010bb:	89 55 10             	mov    %edx,0x10(%ebp)
  8010be:	85 c0                	test   %eax,%eax
  8010c0:	75 dd                	jne    80109f <memmove+0x54>
			*d++ = *s++;

	return dst;
  8010c2:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8010c5:	c9                   	leave  
  8010c6:	c3                   	ret    

008010c7 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  8010c7:	55                   	push   %ebp
  8010c8:	89 e5                	mov    %esp,%ebp
  8010ca:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  8010cd:	8b 45 08             	mov    0x8(%ebp),%eax
  8010d0:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  8010d3:	8b 45 0c             	mov    0xc(%ebp),%eax
  8010d6:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  8010d9:	eb 2a                	jmp    801105 <memcmp+0x3e>
		if (*s1 != *s2)
  8010db:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8010de:	8a 10                	mov    (%eax),%dl
  8010e0:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8010e3:	8a 00                	mov    (%eax),%al
  8010e5:	38 c2                	cmp    %al,%dl
  8010e7:	74 16                	je     8010ff <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  8010e9:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8010ec:	8a 00                	mov    (%eax),%al
  8010ee:	0f b6 d0             	movzbl %al,%edx
  8010f1:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8010f4:	8a 00                	mov    (%eax),%al
  8010f6:	0f b6 c0             	movzbl %al,%eax
  8010f9:	29 c2                	sub    %eax,%edx
  8010fb:	89 d0                	mov    %edx,%eax
  8010fd:	eb 18                	jmp    801117 <memcmp+0x50>
		s1++, s2++;
  8010ff:	ff 45 fc             	incl   -0x4(%ebp)
  801102:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  801105:	8b 45 10             	mov    0x10(%ebp),%eax
  801108:	8d 50 ff             	lea    -0x1(%eax),%edx
  80110b:	89 55 10             	mov    %edx,0x10(%ebp)
  80110e:	85 c0                	test   %eax,%eax
  801110:	75 c9                	jne    8010db <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  801112:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801117:	c9                   	leave  
  801118:	c3                   	ret    

00801119 <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  801119:	55                   	push   %ebp
  80111a:	89 e5                	mov    %esp,%ebp
  80111c:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  80111f:	8b 55 08             	mov    0x8(%ebp),%edx
  801122:	8b 45 10             	mov    0x10(%ebp),%eax
  801125:	01 d0                	add    %edx,%eax
  801127:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  80112a:	eb 15                	jmp    801141 <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  80112c:	8b 45 08             	mov    0x8(%ebp),%eax
  80112f:	8a 00                	mov    (%eax),%al
  801131:	0f b6 d0             	movzbl %al,%edx
  801134:	8b 45 0c             	mov    0xc(%ebp),%eax
  801137:	0f b6 c0             	movzbl %al,%eax
  80113a:	39 c2                	cmp    %eax,%edx
  80113c:	74 0d                	je     80114b <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  80113e:	ff 45 08             	incl   0x8(%ebp)
  801141:	8b 45 08             	mov    0x8(%ebp),%eax
  801144:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  801147:	72 e3                	jb     80112c <memfind+0x13>
  801149:	eb 01                	jmp    80114c <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  80114b:	90                   	nop
	return (void *) s;
  80114c:	8b 45 08             	mov    0x8(%ebp),%eax
}
  80114f:	c9                   	leave  
  801150:	c3                   	ret    

00801151 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  801151:	55                   	push   %ebp
  801152:	89 e5                	mov    %esp,%ebp
  801154:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  801157:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  80115e:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801165:	eb 03                	jmp    80116a <strtol+0x19>
		s++;
  801167:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  80116a:	8b 45 08             	mov    0x8(%ebp),%eax
  80116d:	8a 00                	mov    (%eax),%al
  80116f:	3c 20                	cmp    $0x20,%al
  801171:	74 f4                	je     801167 <strtol+0x16>
  801173:	8b 45 08             	mov    0x8(%ebp),%eax
  801176:	8a 00                	mov    (%eax),%al
  801178:	3c 09                	cmp    $0x9,%al
  80117a:	74 eb                	je     801167 <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  80117c:	8b 45 08             	mov    0x8(%ebp),%eax
  80117f:	8a 00                	mov    (%eax),%al
  801181:	3c 2b                	cmp    $0x2b,%al
  801183:	75 05                	jne    80118a <strtol+0x39>
		s++;
  801185:	ff 45 08             	incl   0x8(%ebp)
  801188:	eb 13                	jmp    80119d <strtol+0x4c>
	else if (*s == '-')
  80118a:	8b 45 08             	mov    0x8(%ebp),%eax
  80118d:	8a 00                	mov    (%eax),%al
  80118f:	3c 2d                	cmp    $0x2d,%al
  801191:	75 0a                	jne    80119d <strtol+0x4c>
		s++, neg = 1;
  801193:	ff 45 08             	incl   0x8(%ebp)
  801196:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  80119d:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8011a1:	74 06                	je     8011a9 <strtol+0x58>
  8011a3:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  8011a7:	75 20                	jne    8011c9 <strtol+0x78>
  8011a9:	8b 45 08             	mov    0x8(%ebp),%eax
  8011ac:	8a 00                	mov    (%eax),%al
  8011ae:	3c 30                	cmp    $0x30,%al
  8011b0:	75 17                	jne    8011c9 <strtol+0x78>
  8011b2:	8b 45 08             	mov    0x8(%ebp),%eax
  8011b5:	40                   	inc    %eax
  8011b6:	8a 00                	mov    (%eax),%al
  8011b8:	3c 78                	cmp    $0x78,%al
  8011ba:	75 0d                	jne    8011c9 <strtol+0x78>
		s += 2, base = 16;
  8011bc:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  8011c0:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  8011c7:	eb 28                	jmp    8011f1 <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  8011c9:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8011cd:	75 15                	jne    8011e4 <strtol+0x93>
  8011cf:	8b 45 08             	mov    0x8(%ebp),%eax
  8011d2:	8a 00                	mov    (%eax),%al
  8011d4:	3c 30                	cmp    $0x30,%al
  8011d6:	75 0c                	jne    8011e4 <strtol+0x93>
		s++, base = 8;
  8011d8:	ff 45 08             	incl   0x8(%ebp)
  8011db:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  8011e2:	eb 0d                	jmp    8011f1 <strtol+0xa0>
	else if (base == 0)
  8011e4:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8011e8:	75 07                	jne    8011f1 <strtol+0xa0>
		base = 10;
  8011ea:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  8011f1:	8b 45 08             	mov    0x8(%ebp),%eax
  8011f4:	8a 00                	mov    (%eax),%al
  8011f6:	3c 2f                	cmp    $0x2f,%al
  8011f8:	7e 19                	jle    801213 <strtol+0xc2>
  8011fa:	8b 45 08             	mov    0x8(%ebp),%eax
  8011fd:	8a 00                	mov    (%eax),%al
  8011ff:	3c 39                	cmp    $0x39,%al
  801201:	7f 10                	jg     801213 <strtol+0xc2>
			dig = *s - '0';
  801203:	8b 45 08             	mov    0x8(%ebp),%eax
  801206:	8a 00                	mov    (%eax),%al
  801208:	0f be c0             	movsbl %al,%eax
  80120b:	83 e8 30             	sub    $0x30,%eax
  80120e:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801211:	eb 42                	jmp    801255 <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  801213:	8b 45 08             	mov    0x8(%ebp),%eax
  801216:	8a 00                	mov    (%eax),%al
  801218:	3c 60                	cmp    $0x60,%al
  80121a:	7e 19                	jle    801235 <strtol+0xe4>
  80121c:	8b 45 08             	mov    0x8(%ebp),%eax
  80121f:	8a 00                	mov    (%eax),%al
  801221:	3c 7a                	cmp    $0x7a,%al
  801223:	7f 10                	jg     801235 <strtol+0xe4>
			dig = *s - 'a' + 10;
  801225:	8b 45 08             	mov    0x8(%ebp),%eax
  801228:	8a 00                	mov    (%eax),%al
  80122a:	0f be c0             	movsbl %al,%eax
  80122d:	83 e8 57             	sub    $0x57,%eax
  801230:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801233:	eb 20                	jmp    801255 <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  801235:	8b 45 08             	mov    0x8(%ebp),%eax
  801238:	8a 00                	mov    (%eax),%al
  80123a:	3c 40                	cmp    $0x40,%al
  80123c:	7e 39                	jle    801277 <strtol+0x126>
  80123e:	8b 45 08             	mov    0x8(%ebp),%eax
  801241:	8a 00                	mov    (%eax),%al
  801243:	3c 5a                	cmp    $0x5a,%al
  801245:	7f 30                	jg     801277 <strtol+0x126>
			dig = *s - 'A' + 10;
  801247:	8b 45 08             	mov    0x8(%ebp),%eax
  80124a:	8a 00                	mov    (%eax),%al
  80124c:	0f be c0             	movsbl %al,%eax
  80124f:	83 e8 37             	sub    $0x37,%eax
  801252:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  801255:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801258:	3b 45 10             	cmp    0x10(%ebp),%eax
  80125b:	7d 19                	jge    801276 <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  80125d:	ff 45 08             	incl   0x8(%ebp)
  801260:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801263:	0f af 45 10          	imul   0x10(%ebp),%eax
  801267:	89 c2                	mov    %eax,%edx
  801269:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80126c:	01 d0                	add    %edx,%eax
  80126e:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  801271:	e9 7b ff ff ff       	jmp    8011f1 <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  801276:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  801277:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80127b:	74 08                	je     801285 <strtol+0x134>
		*endptr = (char *) s;
  80127d:	8b 45 0c             	mov    0xc(%ebp),%eax
  801280:	8b 55 08             	mov    0x8(%ebp),%edx
  801283:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  801285:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801289:	74 07                	je     801292 <strtol+0x141>
  80128b:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80128e:	f7 d8                	neg    %eax
  801290:	eb 03                	jmp    801295 <strtol+0x144>
  801292:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  801295:	c9                   	leave  
  801296:	c3                   	ret    

00801297 <ltostr>:

void
ltostr(long value, char *str)
{
  801297:	55                   	push   %ebp
  801298:	89 e5                	mov    %esp,%ebp
  80129a:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  80129d:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  8012a4:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  8012ab:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8012af:	79 13                	jns    8012c4 <ltostr+0x2d>
	{
		neg = 1;
  8012b1:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  8012b8:	8b 45 0c             	mov    0xc(%ebp),%eax
  8012bb:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  8012be:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  8012c1:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  8012c4:	8b 45 08             	mov    0x8(%ebp),%eax
  8012c7:	b9 0a 00 00 00       	mov    $0xa,%ecx
  8012cc:	99                   	cltd   
  8012cd:	f7 f9                	idiv   %ecx
  8012cf:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  8012d2:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8012d5:	8d 50 01             	lea    0x1(%eax),%edx
  8012d8:	89 55 f8             	mov    %edx,-0x8(%ebp)
  8012db:	89 c2                	mov    %eax,%edx
  8012dd:	8b 45 0c             	mov    0xc(%ebp),%eax
  8012e0:	01 d0                	add    %edx,%eax
  8012e2:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8012e5:	83 c2 30             	add    $0x30,%edx
  8012e8:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  8012ea:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8012ed:	b8 67 66 66 66       	mov    $0x66666667,%eax
  8012f2:	f7 e9                	imul   %ecx
  8012f4:	c1 fa 02             	sar    $0x2,%edx
  8012f7:	89 c8                	mov    %ecx,%eax
  8012f9:	c1 f8 1f             	sar    $0x1f,%eax
  8012fc:	29 c2                	sub    %eax,%edx
  8012fe:	89 d0                	mov    %edx,%eax
  801300:	89 45 08             	mov    %eax,0x8(%ebp)
	} while (value % 10 != 0);
  801303:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801306:	b8 67 66 66 66       	mov    $0x66666667,%eax
  80130b:	f7 e9                	imul   %ecx
  80130d:	c1 fa 02             	sar    $0x2,%edx
  801310:	89 c8                	mov    %ecx,%eax
  801312:	c1 f8 1f             	sar    $0x1f,%eax
  801315:	29 c2                	sub    %eax,%edx
  801317:	89 d0                	mov    %edx,%eax
  801319:	c1 e0 02             	shl    $0x2,%eax
  80131c:	01 d0                	add    %edx,%eax
  80131e:	01 c0                	add    %eax,%eax
  801320:	29 c1                	sub    %eax,%ecx
  801322:	89 ca                	mov    %ecx,%edx
  801324:	85 d2                	test   %edx,%edx
  801326:	75 9c                	jne    8012c4 <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  801328:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  80132f:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801332:	48                   	dec    %eax
  801333:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  801336:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  80133a:	74 3d                	je     801379 <ltostr+0xe2>
		start = 1 ;
  80133c:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  801343:	eb 34                	jmp    801379 <ltostr+0xe2>
	{
		char tmp = str[start] ;
  801345:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801348:	8b 45 0c             	mov    0xc(%ebp),%eax
  80134b:	01 d0                	add    %edx,%eax
  80134d:	8a 00                	mov    (%eax),%al
  80134f:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  801352:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801355:	8b 45 0c             	mov    0xc(%ebp),%eax
  801358:	01 c2                	add    %eax,%edx
  80135a:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  80135d:	8b 45 0c             	mov    0xc(%ebp),%eax
  801360:	01 c8                	add    %ecx,%eax
  801362:	8a 00                	mov    (%eax),%al
  801364:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  801366:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801369:	8b 45 0c             	mov    0xc(%ebp),%eax
  80136c:	01 c2                	add    %eax,%edx
  80136e:	8a 45 eb             	mov    -0x15(%ebp),%al
  801371:	88 02                	mov    %al,(%edx)
		start++ ;
  801373:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  801376:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  801379:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80137c:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  80137f:	7c c4                	jl     801345 <ltostr+0xae>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  801381:	8b 55 f8             	mov    -0x8(%ebp),%edx
  801384:	8b 45 0c             	mov    0xc(%ebp),%eax
  801387:	01 d0                	add    %edx,%eax
  801389:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  80138c:	90                   	nop
  80138d:	c9                   	leave  
  80138e:	c3                   	ret    

0080138f <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  80138f:	55                   	push   %ebp
  801390:	89 e5                	mov    %esp,%ebp
  801392:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  801395:	ff 75 08             	pushl  0x8(%ebp)
  801398:	e8 54 fa ff ff       	call   800df1 <strlen>
  80139d:	83 c4 04             	add    $0x4,%esp
  8013a0:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  8013a3:	ff 75 0c             	pushl  0xc(%ebp)
  8013a6:	e8 46 fa ff ff       	call   800df1 <strlen>
  8013ab:	83 c4 04             	add    $0x4,%esp
  8013ae:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  8013b1:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  8013b8:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8013bf:	eb 17                	jmp    8013d8 <strcconcat+0x49>
		final[s] = str1[s] ;
  8013c1:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8013c4:	8b 45 10             	mov    0x10(%ebp),%eax
  8013c7:	01 c2                	add    %eax,%edx
  8013c9:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  8013cc:	8b 45 08             	mov    0x8(%ebp),%eax
  8013cf:	01 c8                	add    %ecx,%eax
  8013d1:	8a 00                	mov    (%eax),%al
  8013d3:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  8013d5:	ff 45 fc             	incl   -0x4(%ebp)
  8013d8:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8013db:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  8013de:	7c e1                	jl     8013c1 <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  8013e0:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  8013e7:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  8013ee:	eb 1f                	jmp    80140f <strcconcat+0x80>
		final[s++] = str2[i] ;
  8013f0:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8013f3:	8d 50 01             	lea    0x1(%eax),%edx
  8013f6:	89 55 fc             	mov    %edx,-0x4(%ebp)
  8013f9:	89 c2                	mov    %eax,%edx
  8013fb:	8b 45 10             	mov    0x10(%ebp),%eax
  8013fe:	01 c2                	add    %eax,%edx
  801400:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  801403:	8b 45 0c             	mov    0xc(%ebp),%eax
  801406:	01 c8                	add    %ecx,%eax
  801408:	8a 00                	mov    (%eax),%al
  80140a:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  80140c:	ff 45 f8             	incl   -0x8(%ebp)
  80140f:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801412:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801415:	7c d9                	jl     8013f0 <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  801417:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80141a:	8b 45 10             	mov    0x10(%ebp),%eax
  80141d:	01 d0                	add    %edx,%eax
  80141f:	c6 00 00             	movb   $0x0,(%eax)
}
  801422:	90                   	nop
  801423:	c9                   	leave  
  801424:	c3                   	ret    

00801425 <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  801425:	55                   	push   %ebp
  801426:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  801428:	8b 45 14             	mov    0x14(%ebp),%eax
  80142b:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  801431:	8b 45 14             	mov    0x14(%ebp),%eax
  801434:	8b 00                	mov    (%eax),%eax
  801436:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80143d:	8b 45 10             	mov    0x10(%ebp),%eax
  801440:	01 d0                	add    %edx,%eax
  801442:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801448:	eb 0c                	jmp    801456 <strsplit+0x31>
			*string++ = 0;
  80144a:	8b 45 08             	mov    0x8(%ebp),%eax
  80144d:	8d 50 01             	lea    0x1(%eax),%edx
  801450:	89 55 08             	mov    %edx,0x8(%ebp)
  801453:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801456:	8b 45 08             	mov    0x8(%ebp),%eax
  801459:	8a 00                	mov    (%eax),%al
  80145b:	84 c0                	test   %al,%al
  80145d:	74 18                	je     801477 <strsplit+0x52>
  80145f:	8b 45 08             	mov    0x8(%ebp),%eax
  801462:	8a 00                	mov    (%eax),%al
  801464:	0f be c0             	movsbl %al,%eax
  801467:	50                   	push   %eax
  801468:	ff 75 0c             	pushl  0xc(%ebp)
  80146b:	e8 13 fb ff ff       	call   800f83 <strchr>
  801470:	83 c4 08             	add    $0x8,%esp
  801473:	85 c0                	test   %eax,%eax
  801475:	75 d3                	jne    80144a <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  801477:	8b 45 08             	mov    0x8(%ebp),%eax
  80147a:	8a 00                	mov    (%eax),%al
  80147c:	84 c0                	test   %al,%al
  80147e:	74 5a                	je     8014da <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  801480:	8b 45 14             	mov    0x14(%ebp),%eax
  801483:	8b 00                	mov    (%eax),%eax
  801485:	83 f8 0f             	cmp    $0xf,%eax
  801488:	75 07                	jne    801491 <strsplit+0x6c>
		{
			return 0;
  80148a:	b8 00 00 00 00       	mov    $0x0,%eax
  80148f:	eb 66                	jmp    8014f7 <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  801491:	8b 45 14             	mov    0x14(%ebp),%eax
  801494:	8b 00                	mov    (%eax),%eax
  801496:	8d 48 01             	lea    0x1(%eax),%ecx
  801499:	8b 55 14             	mov    0x14(%ebp),%edx
  80149c:	89 0a                	mov    %ecx,(%edx)
  80149e:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8014a5:	8b 45 10             	mov    0x10(%ebp),%eax
  8014a8:	01 c2                	add    %eax,%edx
  8014aa:	8b 45 08             	mov    0x8(%ebp),%eax
  8014ad:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  8014af:	eb 03                	jmp    8014b4 <strsplit+0x8f>
			string++;
  8014b1:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  8014b4:	8b 45 08             	mov    0x8(%ebp),%eax
  8014b7:	8a 00                	mov    (%eax),%al
  8014b9:	84 c0                	test   %al,%al
  8014bb:	74 8b                	je     801448 <strsplit+0x23>
  8014bd:	8b 45 08             	mov    0x8(%ebp),%eax
  8014c0:	8a 00                	mov    (%eax),%al
  8014c2:	0f be c0             	movsbl %al,%eax
  8014c5:	50                   	push   %eax
  8014c6:	ff 75 0c             	pushl  0xc(%ebp)
  8014c9:	e8 b5 fa ff ff       	call   800f83 <strchr>
  8014ce:	83 c4 08             	add    $0x8,%esp
  8014d1:	85 c0                	test   %eax,%eax
  8014d3:	74 dc                	je     8014b1 <strsplit+0x8c>
			string++;
	}
  8014d5:	e9 6e ff ff ff       	jmp    801448 <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  8014da:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  8014db:	8b 45 14             	mov    0x14(%ebp),%eax
  8014de:	8b 00                	mov    (%eax),%eax
  8014e0:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8014e7:	8b 45 10             	mov    0x10(%ebp),%eax
  8014ea:	01 d0                	add    %edx,%eax
  8014ec:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  8014f2:	b8 01 00 00 00       	mov    $0x1,%eax
}
  8014f7:	c9                   	leave  
  8014f8:	c3                   	ret    

008014f9 <InitializeUHeap>:
//============================== GIVEN FUNCTIONS ===================================//
//==================================================================================//

int FirstTimeFlag = 1;
void InitializeUHeap()
{
  8014f9:	55                   	push   %ebp
  8014fa:	89 e5                	mov    %esp,%ebp
  8014fc:	83 ec 08             	sub    $0x8,%esp
	if(FirstTimeFlag)
  8014ff:	a1 04 40 80 00       	mov    0x804004,%eax
  801504:	85 c0                	test   %eax,%eax
  801506:	74 1f                	je     801527 <InitializeUHeap+0x2e>
	{
		initialize_dyn_block_system();
  801508:	e8 1d 00 00 00       	call   80152a <initialize_dyn_block_system>
		cprintf("DYNAMIC BLOCK SYSTEM IS INITIALIZED\n");
  80150d:	83 ec 0c             	sub    $0xc,%esp
  801510:	68 f0 3b 80 00       	push   $0x803bf0
  801515:	e8 55 f2 ff ff       	call   80076f <cprintf>
  80151a:	83 c4 10             	add    $0x10,%esp
#if UHP_USE_BUDDY
		initialize_buddy();
		cprintf("BUDDY SYSTEM IS INITIALIZED\n");
#endif
		FirstTimeFlag = 0;
  80151d:	c7 05 04 40 80 00 00 	movl   $0x0,0x804004
  801524:	00 00 00 
	}
}
  801527:	90                   	nop
  801528:	c9                   	leave  
  801529:	c3                   	ret    

0080152a <initialize_dyn_block_system>:

//=================================
// [1] INITIALIZE DYNAMIC ALLOCATOR:
//=================================
void initialize_dyn_block_system()
{
  80152a:	55                   	push   %ebp
  80152b:	89 e5                	mov    %esp,%ebp
  80152d:	83 ec 28             	sub    $0x28,%esp
	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] initialize_dyn_block_system
	// your code is here, remove the panic and write your code
	//panic("initialize_dyn_block_system() is not implemented yet...!!");

	LIST_INIT(&AllocMemBlocksList);
  801530:	c7 05 40 40 80 00 00 	movl   $0x0,0x804040
  801537:	00 00 00 
  80153a:	c7 05 44 40 80 00 00 	movl   $0x0,0x804044
  801541:	00 00 00 
  801544:	c7 05 4c 40 80 00 00 	movl   $0x0,0x80404c
  80154b:	00 00 00 
	LIST_INIT(&FreeMemBlocksList);
  80154e:	c7 05 38 41 80 00 00 	movl   $0x0,0x804138
  801555:	00 00 00 
  801558:	c7 05 3c 41 80 00 00 	movl   $0x0,0x80413c
  80155f:	00 00 00 
  801562:	c7 05 44 41 80 00 00 	movl   $0x0,0x804144
  801569:	00 00 00 
	MAX_MEM_BLOCK_CNT = NUM_OF_UHEAP_PAGES;
  80156c:	c7 05 20 41 80 00 00 	movl   $0x20000,0x804120
  801573:	00 02 00 
	MemBlockNodes = (void*)USER_DYN_BLKS_ARRAY;
  801576:	c7 45 f4 00 00 e0 7f 	movl   $0x7fe00000,-0xc(%ebp)
  80157d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801580:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801585:	2d 00 10 00 00       	sub    $0x1000,%eax
  80158a:	a3 50 40 80 00       	mov    %eax,0x804050
	int size_of_block = sizeof(struct MemBlock);
  80158f:	c7 45 f0 10 00 00 00 	movl   $0x10,-0x10(%ebp)
	int size_all_struct = size_of_block*MAX_MEM_BLOCK_CNT;
  801596:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801599:	a1 20 41 80 00       	mov    0x804120,%eax
  80159e:	0f af c2             	imul   %edx,%eax
  8015a1:	89 45 ec             	mov    %eax,-0x14(%ebp)
	size_all_struct = ROUNDUP(size_all_struct, PAGE_SIZE);
  8015a4:	c7 45 e8 00 10 00 00 	movl   $0x1000,-0x18(%ebp)
  8015ab:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8015ae:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8015b1:	01 d0                	add    %edx,%eax
  8015b3:	48                   	dec    %eax
  8015b4:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8015b7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8015ba:	ba 00 00 00 00       	mov    $0x0,%edx
  8015bf:	f7 75 e8             	divl   -0x18(%ebp)
  8015c2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8015c5:	29 d0                	sub    %edx,%eax
  8015c7:	89 45 ec             	mov    %eax,-0x14(%ebp)
	sys_allocate_chunk(USER_DYN_BLKS_ARRAY, size_all_struct,PERM_USER| PERM_WRITEABLE);
  8015ca:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8015cd:	c7 45 e0 00 00 e0 7f 	movl   $0x7fe00000,-0x20(%ebp)
  8015d4:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8015d7:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
  8015dd:	81 ea 00 10 00 00    	sub    $0x1000,%edx
  8015e3:	83 ec 04             	sub    $0x4,%esp
  8015e6:	6a 06                	push   $0x6
  8015e8:	50                   	push   %eax
  8015e9:	52                   	push   %edx
  8015ea:	e8 a1 05 00 00       	call   801b90 <sys_allocate_chunk>
  8015ef:	83 c4 10             	add    $0x10,%esp
	initialize_MemBlocksList(MAX_MEM_BLOCK_CNT);
  8015f2:	a1 20 41 80 00       	mov    0x804120,%eax
  8015f7:	83 ec 0c             	sub    $0xc,%esp
  8015fa:	50                   	push   %eax
  8015fb:	e8 16 0c 00 00       	call   802216 <initialize_MemBlocksList>
  801600:	83 c4 10             	add    $0x10,%esp
	struct MemBlock* ourBlock =LIST_LAST(&AvailableMemBlocksList);
  801603:	a1 4c 41 80 00       	mov    0x80414c,%eax
  801608:	89 45 dc             	mov    %eax,-0x24(%ebp)
	LIST_REMOVE(&AvailableMemBlocksList,ourBlock);
  80160b:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  80160f:	75 14                	jne    801625 <initialize_dyn_block_system+0xfb>
  801611:	83 ec 04             	sub    $0x4,%esp
  801614:	68 15 3c 80 00       	push   $0x803c15
  801619:	6a 2d                	push   $0x2d
  80161b:	68 33 3c 80 00       	push   $0x803c33
  801620:	e8 96 ee ff ff       	call   8004bb <_panic>
  801625:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801628:	8b 00                	mov    (%eax),%eax
  80162a:	85 c0                	test   %eax,%eax
  80162c:	74 10                	je     80163e <initialize_dyn_block_system+0x114>
  80162e:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801631:	8b 00                	mov    (%eax),%eax
  801633:	8b 55 dc             	mov    -0x24(%ebp),%edx
  801636:	8b 52 04             	mov    0x4(%edx),%edx
  801639:	89 50 04             	mov    %edx,0x4(%eax)
  80163c:	eb 0b                	jmp    801649 <initialize_dyn_block_system+0x11f>
  80163e:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801641:	8b 40 04             	mov    0x4(%eax),%eax
  801644:	a3 4c 41 80 00       	mov    %eax,0x80414c
  801649:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80164c:	8b 40 04             	mov    0x4(%eax),%eax
  80164f:	85 c0                	test   %eax,%eax
  801651:	74 0f                	je     801662 <initialize_dyn_block_system+0x138>
  801653:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801656:	8b 40 04             	mov    0x4(%eax),%eax
  801659:	8b 55 dc             	mov    -0x24(%ebp),%edx
  80165c:	8b 12                	mov    (%edx),%edx
  80165e:	89 10                	mov    %edx,(%eax)
  801660:	eb 0a                	jmp    80166c <initialize_dyn_block_system+0x142>
  801662:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801665:	8b 00                	mov    (%eax),%eax
  801667:	a3 48 41 80 00       	mov    %eax,0x804148
  80166c:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80166f:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  801675:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801678:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80167f:	a1 54 41 80 00       	mov    0x804154,%eax
  801684:	48                   	dec    %eax
  801685:	a3 54 41 80 00       	mov    %eax,0x804154
	ourBlock->size = USER_HEAP_MAX-USER_HEAP_START;
  80168a:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80168d:	c7 40 0c 00 00 00 20 	movl   $0x20000000,0xc(%eax)
	ourBlock->sva=USER_HEAP_START;
  801694:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801697:	c7 40 08 00 00 00 80 	movl   $0x80000000,0x8(%eax)
	LIST_INSERT_TAIL(&FreeMemBlocksList, ourBlock);
  80169e:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  8016a2:	75 14                	jne    8016b8 <initialize_dyn_block_system+0x18e>
  8016a4:	83 ec 04             	sub    $0x4,%esp
  8016a7:	68 40 3c 80 00       	push   $0x803c40
  8016ac:	6a 30                	push   $0x30
  8016ae:	68 33 3c 80 00       	push   $0x803c33
  8016b3:	e8 03 ee ff ff       	call   8004bb <_panic>
  8016b8:	8b 15 3c 41 80 00    	mov    0x80413c,%edx
  8016be:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8016c1:	89 50 04             	mov    %edx,0x4(%eax)
  8016c4:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8016c7:	8b 40 04             	mov    0x4(%eax),%eax
  8016ca:	85 c0                	test   %eax,%eax
  8016cc:	74 0c                	je     8016da <initialize_dyn_block_system+0x1b0>
  8016ce:	a1 3c 41 80 00       	mov    0x80413c,%eax
  8016d3:	8b 55 dc             	mov    -0x24(%ebp),%edx
  8016d6:	89 10                	mov    %edx,(%eax)
  8016d8:	eb 08                	jmp    8016e2 <initialize_dyn_block_system+0x1b8>
  8016da:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8016dd:	a3 38 41 80 00       	mov    %eax,0x804138
  8016e2:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8016e5:	a3 3c 41 80 00       	mov    %eax,0x80413c
  8016ea:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8016ed:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8016f3:	a1 44 41 80 00       	mov    0x804144,%eax
  8016f8:	40                   	inc    %eax
  8016f9:	a3 44 41 80 00       	mov    %eax,0x804144
	//[1] Initialize two lists (AllocMemBlocksList & FreeMemBlocksList) [Hint: use LIST_INIT()]
	//[2] Dynamically allocate the array of MemBlockNodes at VA USER_DYN_BLKS_ARRAY
	//	  (remember to set MAX_MEM_BLOCK_CNT with the chosen size of the array)
	//[3] Initialize AvailableMemBlocksList by filling it with the MemBlockNodes
	//[4] Insert a new MemBlock with the heap size into the FreeMemBlocksList
}
  8016fe:	90                   	nop
  8016ff:	c9                   	leave  
  801700:	c3                   	ret    

00801701 <malloc>:
//=================================
// [2] ALLOCATE SPACE IN USER HEAP:
//=================================

void* malloc(uint32 size)
{
  801701:	55                   	push   %ebp
  801702:	89 e5                	mov    %esp,%ebp
  801704:	83 ec 18             	sub    $0x18,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801707:	e8 ed fd ff ff       	call   8014f9 <InitializeUHeap>
	if (size == 0) return NULL ;
  80170c:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801710:	75 07                	jne    801719 <malloc+0x18>
  801712:	b8 00 00 00 00       	mov    $0x0,%eax
  801717:	eb 67                	jmp    801780 <malloc+0x7f>

	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] malloc
	// your code is here, remove the panic and write your code
	//panic("malloc() is not implemented yet...!!");

	size = ROUNDUP(size, PAGE_SIZE);
  801719:	c7 45 f4 00 10 00 00 	movl   $0x1000,-0xc(%ebp)
  801720:	8b 55 08             	mov    0x8(%ebp),%edx
  801723:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801726:	01 d0                	add    %edx,%eax
  801728:	48                   	dec    %eax
  801729:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80172c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80172f:	ba 00 00 00 00       	mov    $0x0,%edx
  801734:	f7 75 f4             	divl   -0xc(%ebp)
  801737:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80173a:	29 d0                	sub    %edx,%eax
  80173c:	89 45 08             	mov    %eax,0x8(%ebp)
	if(sys_isUHeapPlacementStrategyFIRSTFIT())
  80173f:	e8 1a 08 00 00       	call   801f5e <sys_isUHeapPlacementStrategyFIRSTFIT>
  801744:	85 c0                	test   %eax,%eax
  801746:	74 33                	je     80177b <malloc+0x7a>
	{
		struct MemBlock * myBlock = alloc_block_FF(size);
  801748:	83 ec 0c             	sub    $0xc,%esp
  80174b:	ff 75 08             	pushl  0x8(%ebp)
  80174e:	e8 0c 0e 00 00       	call   80255f <alloc_block_FF>
  801753:	83 c4 10             	add    $0x10,%esp
  801756:	89 45 ec             	mov    %eax,-0x14(%ebp)
		if(myBlock != NULL)
  801759:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  80175d:	74 1c                	je     80177b <malloc+0x7a>
		{
			insert_sorted_allocList(myBlock);
  80175f:	83 ec 0c             	sub    $0xc,%esp
  801762:	ff 75 ec             	pushl  -0x14(%ebp)
  801765:	e8 07 0c 00 00       	call   802371 <insert_sorted_allocList>
  80176a:	83 c4 10             	add    $0x10,%esp
			uint32 ptr = myBlock->sva;
  80176d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801770:	8b 40 08             	mov    0x8(%eax),%eax
  801773:	89 45 e8             	mov    %eax,-0x18(%ebp)
			return (void *)ptr;
  801776:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801779:	eb 05                	jmp    801780 <malloc+0x7f>
		}
	}
	return NULL;
  80177b:	b8 00 00 00 00       	mov    $0x0,%eax
	//		to the required allocation size (space should be on 4 KB BOUNDARY)
	//	2) if no suitable space found, return NULL
	// 	3) Return pointer containing the virtual address of allocated space,
	//
	//Use sys_isUHeapPlacementStrategyFIRSTFIT()... to check the current strategy
}
  801780:	c9                   	leave  
  801781:	c3                   	ret    

00801782 <free>:
//	We can use sys_free_user_mem(uint32 virtual_address, uint32 size); which
//		switches to the kernel mode, calls free_user_mem() in
//		"kern/mem/chunk_operations.c", then switch back to the user mode here
//	the free_user_mem function is empty, make sure to implement it.
void free(void* virtual_address)
{
  801782:	55                   	push   %ebp
  801783:	89 e5                	mov    %esp,%ebp
  801785:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] free
	// your code is here, remove the panic and write your code
	//panic("free() is not implemented yet...!!");

	uint32 virtualAddress = (uint32 )(virtual_address);
  801788:	8b 45 08             	mov    0x8(%ebp),%eax
  80178b:	89 45 f4             	mov    %eax,-0xc(%ebp)
//	virtualAddress = ROUNDDOWN(virtualAddress, PAGE_SIZE);
	struct MemBlock * myBlock = find_block(&AllocMemBlocksList, virtualAddress);
  80178e:	83 ec 08             	sub    $0x8,%esp
  801791:	ff 75 f4             	pushl  -0xc(%ebp)
  801794:	68 40 40 80 00       	push   $0x804040
  801799:	e8 5b 0b 00 00       	call   8022f9 <find_block>
  80179e:	83 c4 10             	add    $0x10,%esp
  8017a1:	89 45 f0             	mov    %eax,-0x10(%ebp)
//	cprintf ("ptr sva at free user side = %x \n", myBlock->sva);
	sys_free_user_mem(virtualAddress, myBlock->size);
  8017a4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8017a7:	8b 40 0c             	mov    0xc(%eax),%eax
  8017aa:	83 ec 08             	sub    $0x8,%esp
  8017ad:	50                   	push   %eax
  8017ae:	ff 75 f4             	pushl  -0xc(%ebp)
  8017b1:	e8 a2 03 00 00       	call   801b58 <sys_free_user_mem>
  8017b6:	83 c4 10             	add    $0x10,%esp
	LIST_REMOVE(&AllocMemBlocksList, myBlock);
  8017b9:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8017bd:	75 14                	jne    8017d3 <free+0x51>
  8017bf:	83 ec 04             	sub    $0x4,%esp
  8017c2:	68 15 3c 80 00       	push   $0x803c15
  8017c7:	6a 76                	push   $0x76
  8017c9:	68 33 3c 80 00       	push   $0x803c33
  8017ce:	e8 e8 ec ff ff       	call   8004bb <_panic>
  8017d3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8017d6:	8b 00                	mov    (%eax),%eax
  8017d8:	85 c0                	test   %eax,%eax
  8017da:	74 10                	je     8017ec <free+0x6a>
  8017dc:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8017df:	8b 00                	mov    (%eax),%eax
  8017e1:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8017e4:	8b 52 04             	mov    0x4(%edx),%edx
  8017e7:	89 50 04             	mov    %edx,0x4(%eax)
  8017ea:	eb 0b                	jmp    8017f7 <free+0x75>
  8017ec:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8017ef:	8b 40 04             	mov    0x4(%eax),%eax
  8017f2:	a3 44 40 80 00       	mov    %eax,0x804044
  8017f7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8017fa:	8b 40 04             	mov    0x4(%eax),%eax
  8017fd:	85 c0                	test   %eax,%eax
  8017ff:	74 0f                	je     801810 <free+0x8e>
  801801:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801804:	8b 40 04             	mov    0x4(%eax),%eax
  801807:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80180a:	8b 12                	mov    (%edx),%edx
  80180c:	89 10                	mov    %edx,(%eax)
  80180e:	eb 0a                	jmp    80181a <free+0x98>
  801810:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801813:	8b 00                	mov    (%eax),%eax
  801815:	a3 40 40 80 00       	mov    %eax,0x804040
  80181a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80181d:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  801823:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801826:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80182d:	a1 4c 40 80 00       	mov    0x80404c,%eax
  801832:	48                   	dec    %eax
  801833:	a3 4c 40 80 00       	mov    %eax,0x80404c
	insert_sorted_with_merge_freeList(myBlock);
  801838:	83 ec 0c             	sub    $0xc,%esp
  80183b:	ff 75 f0             	pushl  -0x10(%ebp)
  80183e:	e8 0b 14 00 00       	call   802c4e <insert_sorted_with_merge_freeList>
  801843:	83 c4 10             	add    $0x10,%esp

	//you should get the size of the given allocation using its address
	//you need to call sys_free_user_mem()
	//refer to the project presentation and documentation for details
}
  801846:	90                   	nop
  801847:	c9                   	leave  
  801848:	c3                   	ret    

00801849 <smalloc>:

//=================================
// [4] ALLOCATE SHARED VARIABLE:
//=================================
void* smalloc(char *sharedVarName, uint32 size, uint8 isWritable)
{
  801849:	55                   	push   %ebp
  80184a:	89 e5                	mov    %esp,%ebp
  80184c:	83 ec 28             	sub    $0x28,%esp
  80184f:	8b 45 10             	mov    0x10(%ebp),%eax
  801852:	88 45 e4             	mov    %al,-0x1c(%ebp)
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801855:	e8 9f fc ff ff       	call   8014f9 <InitializeUHeap>
	if (size == 0) return NULL ;
  80185a:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80185e:	75 0a                	jne    80186a <smalloc+0x21>
  801860:	b8 00 00 00 00       	mov    $0x0,%eax
  801865:	e9 8d 00 00 00       	jmp    8018f7 <smalloc+0xae>

	//This function should find the space of the required range
	// * ON 4KB BOUNDARY **** //
	//Use sys_isUHeapPlacementStrategyFIRSTFIT() to check the current strategy

	size = ROUNDUP(size, PAGE_SIZE);
  80186a:	c7 45 f4 00 10 00 00 	movl   $0x1000,-0xc(%ebp)
  801871:	8b 55 0c             	mov    0xc(%ebp),%edx
  801874:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801877:	01 d0                	add    %edx,%eax
  801879:	48                   	dec    %eax
  80187a:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80187d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801880:	ba 00 00 00 00       	mov    $0x0,%edx
  801885:	f7 75 f4             	divl   -0xc(%ebp)
  801888:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80188b:	29 d0                	sub    %edx,%eax
  80188d:	89 45 0c             	mov    %eax,0xc(%ebp)
		if(sys_isUHeapPlacementStrategyFIRSTFIT())
  801890:	e8 c9 06 00 00       	call   801f5e <sys_isUHeapPlacementStrategyFIRSTFIT>
  801895:	85 c0                	test   %eax,%eax
  801897:	74 59                	je     8018f2 <smalloc+0xa9>
		{
			struct MemBlock * v1=NULL;
  801899:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
			v1= alloc_block_FF(size);
  8018a0:	83 ec 0c             	sub    $0xc,%esp
  8018a3:	ff 75 0c             	pushl  0xc(%ebp)
  8018a6:	e8 b4 0c 00 00       	call   80255f <alloc_block_FF>
  8018ab:	83 c4 10             	add    $0x10,%esp
  8018ae:	89 45 ec             	mov    %eax,-0x14(%ebp)
			if(v1==NULL)
  8018b1:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8018b5:	75 07                	jne    8018be <smalloc+0x75>
			{
				return NULL;
  8018b7:	b8 00 00 00 00       	mov    $0x0,%eax
  8018bc:	eb 39                	jmp    8018f7 <smalloc+0xae>
			}
			else
			{
				int ret=sys_createSharedObject(sharedVarName,  size,  isWritable,(void*)v1->sva);
  8018be:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8018c1:	8b 40 08             	mov    0x8(%eax),%eax
  8018c4:	89 c2                	mov    %eax,%edx
  8018c6:	0f b6 45 e4          	movzbl -0x1c(%ebp),%eax
  8018ca:	52                   	push   %edx
  8018cb:	50                   	push   %eax
  8018cc:	ff 75 0c             	pushl  0xc(%ebp)
  8018cf:	ff 75 08             	pushl  0x8(%ebp)
  8018d2:	e8 0c 04 00 00       	call   801ce3 <sys_createSharedObject>
  8018d7:	83 c4 10             	add    $0x10,%esp
  8018da:	89 45 e8             	mov    %eax,-0x18(%ebp)
				if(ret>=0)
  8018dd:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  8018e1:	78 08                	js     8018eb <smalloc+0xa2>
				{
					return (void*)v1->sva;
  8018e3:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8018e6:	8b 40 08             	mov    0x8(%eax),%eax
  8018e9:	eb 0c                	jmp    8018f7 <smalloc+0xae>
				}
				else
				{
					return NULL;
  8018eb:	b8 00 00 00 00       	mov    $0x0,%eax
  8018f0:	eb 05                	jmp    8018f7 <smalloc+0xae>
				}
			}

		}
		return NULL;
  8018f2:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8018f7:	c9                   	leave  
  8018f8:	c3                   	ret    

008018f9 <sget>:

//========================================
// [5] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
  8018f9:	55                   	push   %ebp
  8018fa:	89 e5                	mov    %esp,%ebp
  8018fc:	83 ec 18             	sub    $0x18,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  8018ff:	e8 f5 fb ff ff       	call   8014f9 <InitializeUHeap>

	//This function should find the space for sharing the variable
	// *** ON 4KB BOUNDARY ******** //

	//Use sys_isUHeapPlacementStrategyFIRSTFIT() to check the current strategy
	int ret=sys_getSizeOfSharedObject(ownerEnvID,sharedVarName);
  801904:	83 ec 08             	sub    $0x8,%esp
  801907:	ff 75 0c             	pushl  0xc(%ebp)
  80190a:	ff 75 08             	pushl  0x8(%ebp)
  80190d:	e8 fb 03 00 00       	call   801d0d <sys_getSizeOfSharedObject>
  801912:	83 c4 10             	add    $0x10,%esp
  801915:	89 45 f4             	mov    %eax,-0xc(%ebp)
	if(ret==0)
  801918:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80191c:	75 07                	jne    801925 <sget+0x2c>
	{
		return NULL;
  80191e:	b8 00 00 00 00       	mov    $0x0,%eax
  801923:	eb 64                	jmp    801989 <sget+0x90>
	}
	if(sys_isUHeapPlacementStrategyFIRSTFIT())
  801925:	e8 34 06 00 00       	call   801f5e <sys_isUHeapPlacementStrategyFIRSTFIT>
  80192a:	85 c0                	test   %eax,%eax
  80192c:	74 56                	je     801984 <sget+0x8b>
	{
		struct MemBlock * v1=NULL;
  80192e:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
		v1= alloc_block_FF(ret);
  801935:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801938:	83 ec 0c             	sub    $0xc,%esp
  80193b:	50                   	push   %eax
  80193c:	e8 1e 0c 00 00       	call   80255f <alloc_block_FF>
  801941:	83 c4 10             	add    $0x10,%esp
  801944:	89 45 f0             	mov    %eax,-0x10(%ebp)
		if(v1==NULL)
  801947:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80194b:	75 07                	jne    801954 <sget+0x5b>
		{
		return NULL;
  80194d:	b8 00 00 00 00       	mov    $0x0,%eax
  801952:	eb 35                	jmp    801989 <sget+0x90>
	    }
		else
		{
			int ret1=sys_getSharedObject(ownerEnvID,sharedVarName,(void*)v1->sva);
  801954:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801957:	8b 40 08             	mov    0x8(%eax),%eax
  80195a:	83 ec 04             	sub    $0x4,%esp
  80195d:	50                   	push   %eax
  80195e:	ff 75 0c             	pushl  0xc(%ebp)
  801961:	ff 75 08             	pushl  0x8(%ebp)
  801964:	e8 c1 03 00 00       	call   801d2a <sys_getSharedObject>
  801969:	83 c4 10             	add    $0x10,%esp
  80196c:	89 45 ec             	mov    %eax,-0x14(%ebp)
			if(ret1>=0)
  80196f:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  801973:	78 08                	js     80197d <sget+0x84>
			{
				return (void*)v1->sva;
  801975:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801978:	8b 40 08             	mov    0x8(%eax),%eax
  80197b:	eb 0c                	jmp    801989 <sget+0x90>
			}
			else
			{
				return NULL;
  80197d:	b8 00 00 00 00       	mov    $0x0,%eax
  801982:	eb 05                	jmp    801989 <sget+0x90>
			}
		}
	}
  return NULL;
  801984:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801989:	c9                   	leave  
  80198a:	c3                   	ret    

0080198b <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  80198b:	55                   	push   %ebp
  80198c:	89 e5                	mov    %esp,%ebp
  80198e:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801991:	e8 63 fb ff ff       	call   8014f9 <InitializeUHeap>
	//==============================================================
	// [USER HEAP - USER SIDE] realloc
	// Write your code here, remove the panic and write your code
	panic("realloc() is not implemented yet...!!");
  801996:	83 ec 04             	sub    $0x4,%esp
  801999:	68 64 3c 80 00       	push   $0x803c64
  80199e:	68 0e 01 00 00       	push   $0x10e
  8019a3:	68 33 3c 80 00       	push   $0x803c33
  8019a8:	e8 0e eb ff ff       	call   8004bb <_panic>

008019ad <sfree>:
//	use sys_freeSharedObject(...); which switches to the kernel mode,
//	calls freeSharedObject(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the freeSharedObject() function is empty, make sure to implement it.

void sfree(void* virtual_address)
{
  8019ad:	55                   	push   %ebp
  8019ae:	89 e5                	mov    %esp,%ebp
  8019b0:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT MS3 - BONUS] [SHARING - USER SIDE] sfree()

	// Write your code here, remove the panic and write your code
	panic("sfree() is not implemented yet...!!");
  8019b3:	83 ec 04             	sub    $0x4,%esp
  8019b6:	68 8c 3c 80 00       	push   $0x803c8c
  8019bb:	68 22 01 00 00       	push   $0x122
  8019c0:	68 33 3c 80 00       	push   $0x803c33
  8019c5:	e8 f1 ea ff ff       	call   8004bb <_panic>

008019ca <expand>:

//==================================================================================//
//========================== MODIFICATION FUNCTIONS ================================//
//==================================================================================//
void expand(uint32 newSize)
{
  8019ca:	55                   	push   %ebp
  8019cb:	89 e5                	mov    %esp,%ebp
  8019cd:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  8019d0:	83 ec 04             	sub    $0x4,%esp
  8019d3:	68 b0 3c 80 00       	push   $0x803cb0
  8019d8:	68 2d 01 00 00       	push   $0x12d
  8019dd:	68 33 3c 80 00       	push   $0x803c33
  8019e2:	e8 d4 ea ff ff       	call   8004bb <_panic>

008019e7 <shrink>:

}
void shrink(uint32 newSize)
{
  8019e7:	55                   	push   %ebp
  8019e8:	89 e5                	mov    %esp,%ebp
  8019ea:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  8019ed:	83 ec 04             	sub    $0x4,%esp
  8019f0:	68 b0 3c 80 00       	push   $0x803cb0
  8019f5:	68 32 01 00 00       	push   $0x132
  8019fa:	68 33 3c 80 00       	push   $0x803c33
  8019ff:	e8 b7 ea ff ff       	call   8004bb <_panic>

00801a04 <freeHeap>:

}
void freeHeap(void* virtual_address)
{
  801a04:	55                   	push   %ebp
  801a05:	89 e5                	mov    %esp,%ebp
  801a07:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801a0a:	83 ec 04             	sub    $0x4,%esp
  801a0d:	68 b0 3c 80 00       	push   $0x803cb0
  801a12:	68 37 01 00 00       	push   $0x137
  801a17:	68 33 3c 80 00       	push   $0x803c33
  801a1c:	e8 9a ea ff ff       	call   8004bb <_panic>

00801a21 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  801a21:	55                   	push   %ebp
  801a22:	89 e5                	mov    %esp,%ebp
  801a24:	57                   	push   %edi
  801a25:	56                   	push   %esi
  801a26:	53                   	push   %ebx
  801a27:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801a2a:	8b 45 08             	mov    0x8(%ebp),%eax
  801a2d:	8b 55 0c             	mov    0xc(%ebp),%edx
  801a30:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801a33:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801a36:	8b 7d 18             	mov    0x18(%ebp),%edi
  801a39:	8b 75 1c             	mov    0x1c(%ebp),%esi
  801a3c:	cd 30                	int    $0x30
  801a3e:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  801a41:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801a44:	83 c4 10             	add    $0x10,%esp
  801a47:	5b                   	pop    %ebx
  801a48:	5e                   	pop    %esi
  801a49:	5f                   	pop    %edi
  801a4a:	5d                   	pop    %ebp
  801a4b:	c3                   	ret    

00801a4c <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  801a4c:	55                   	push   %ebp
  801a4d:	89 e5                	mov    %esp,%ebp
  801a4f:	83 ec 04             	sub    $0x4,%esp
  801a52:	8b 45 10             	mov    0x10(%ebp),%eax
  801a55:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  801a58:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801a5c:	8b 45 08             	mov    0x8(%ebp),%eax
  801a5f:	6a 00                	push   $0x0
  801a61:	6a 00                	push   $0x0
  801a63:	52                   	push   %edx
  801a64:	ff 75 0c             	pushl  0xc(%ebp)
  801a67:	50                   	push   %eax
  801a68:	6a 00                	push   $0x0
  801a6a:	e8 b2 ff ff ff       	call   801a21 <syscall>
  801a6f:	83 c4 18             	add    $0x18,%esp
}
  801a72:	90                   	nop
  801a73:	c9                   	leave  
  801a74:	c3                   	ret    

00801a75 <sys_cgetc>:

int
sys_cgetc(void)
{
  801a75:	55                   	push   %ebp
  801a76:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  801a78:	6a 00                	push   $0x0
  801a7a:	6a 00                	push   $0x0
  801a7c:	6a 00                	push   $0x0
  801a7e:	6a 00                	push   $0x0
  801a80:	6a 00                	push   $0x0
  801a82:	6a 01                	push   $0x1
  801a84:	e8 98 ff ff ff       	call   801a21 <syscall>
  801a89:	83 c4 18             	add    $0x18,%esp
}
  801a8c:	c9                   	leave  
  801a8d:	c3                   	ret    

00801a8e <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  801a8e:	55                   	push   %ebp
  801a8f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  801a91:	8b 55 0c             	mov    0xc(%ebp),%edx
  801a94:	8b 45 08             	mov    0x8(%ebp),%eax
  801a97:	6a 00                	push   $0x0
  801a99:	6a 00                	push   $0x0
  801a9b:	6a 00                	push   $0x0
  801a9d:	52                   	push   %edx
  801a9e:	50                   	push   %eax
  801a9f:	6a 05                	push   $0x5
  801aa1:	e8 7b ff ff ff       	call   801a21 <syscall>
  801aa6:	83 c4 18             	add    $0x18,%esp
}
  801aa9:	c9                   	leave  
  801aaa:	c3                   	ret    

00801aab <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  801aab:	55                   	push   %ebp
  801aac:	89 e5                	mov    %esp,%ebp
  801aae:	56                   	push   %esi
  801aaf:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  801ab0:	8b 75 18             	mov    0x18(%ebp),%esi
  801ab3:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801ab6:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801ab9:	8b 55 0c             	mov    0xc(%ebp),%edx
  801abc:	8b 45 08             	mov    0x8(%ebp),%eax
  801abf:	56                   	push   %esi
  801ac0:	53                   	push   %ebx
  801ac1:	51                   	push   %ecx
  801ac2:	52                   	push   %edx
  801ac3:	50                   	push   %eax
  801ac4:	6a 06                	push   $0x6
  801ac6:	e8 56 ff ff ff       	call   801a21 <syscall>
  801acb:	83 c4 18             	add    $0x18,%esp
}
  801ace:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801ad1:	5b                   	pop    %ebx
  801ad2:	5e                   	pop    %esi
  801ad3:	5d                   	pop    %ebp
  801ad4:	c3                   	ret    

00801ad5 <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  801ad5:	55                   	push   %ebp
  801ad6:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  801ad8:	8b 55 0c             	mov    0xc(%ebp),%edx
  801adb:	8b 45 08             	mov    0x8(%ebp),%eax
  801ade:	6a 00                	push   $0x0
  801ae0:	6a 00                	push   $0x0
  801ae2:	6a 00                	push   $0x0
  801ae4:	52                   	push   %edx
  801ae5:	50                   	push   %eax
  801ae6:	6a 07                	push   $0x7
  801ae8:	e8 34 ff ff ff       	call   801a21 <syscall>
  801aed:	83 c4 18             	add    $0x18,%esp
}
  801af0:	c9                   	leave  
  801af1:	c3                   	ret    

00801af2 <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  801af2:	55                   	push   %ebp
  801af3:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  801af5:	6a 00                	push   $0x0
  801af7:	6a 00                	push   $0x0
  801af9:	6a 00                	push   $0x0
  801afb:	ff 75 0c             	pushl  0xc(%ebp)
  801afe:	ff 75 08             	pushl  0x8(%ebp)
  801b01:	6a 08                	push   $0x8
  801b03:	e8 19 ff ff ff       	call   801a21 <syscall>
  801b08:	83 c4 18             	add    $0x18,%esp
}
  801b0b:	c9                   	leave  
  801b0c:	c3                   	ret    

00801b0d <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  801b0d:	55                   	push   %ebp
  801b0e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  801b10:	6a 00                	push   $0x0
  801b12:	6a 00                	push   $0x0
  801b14:	6a 00                	push   $0x0
  801b16:	6a 00                	push   $0x0
  801b18:	6a 00                	push   $0x0
  801b1a:	6a 09                	push   $0x9
  801b1c:	e8 00 ff ff ff       	call   801a21 <syscall>
  801b21:	83 c4 18             	add    $0x18,%esp
}
  801b24:	c9                   	leave  
  801b25:	c3                   	ret    

00801b26 <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  801b26:	55                   	push   %ebp
  801b27:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  801b29:	6a 00                	push   $0x0
  801b2b:	6a 00                	push   $0x0
  801b2d:	6a 00                	push   $0x0
  801b2f:	6a 00                	push   $0x0
  801b31:	6a 00                	push   $0x0
  801b33:	6a 0a                	push   $0xa
  801b35:	e8 e7 fe ff ff       	call   801a21 <syscall>
  801b3a:	83 c4 18             	add    $0x18,%esp
}
  801b3d:	c9                   	leave  
  801b3e:	c3                   	ret    

00801b3f <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  801b3f:	55                   	push   %ebp
  801b40:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  801b42:	6a 00                	push   $0x0
  801b44:	6a 00                	push   $0x0
  801b46:	6a 00                	push   $0x0
  801b48:	6a 00                	push   $0x0
  801b4a:	6a 00                	push   $0x0
  801b4c:	6a 0b                	push   $0xb
  801b4e:	e8 ce fe ff ff       	call   801a21 <syscall>
  801b53:	83 c4 18             	add    $0x18,%esp
}
  801b56:	c9                   	leave  
  801b57:	c3                   	ret    

00801b58 <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  801b58:	55                   	push   %ebp
  801b59:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  801b5b:	6a 00                	push   $0x0
  801b5d:	6a 00                	push   $0x0
  801b5f:	6a 00                	push   $0x0
  801b61:	ff 75 0c             	pushl  0xc(%ebp)
  801b64:	ff 75 08             	pushl  0x8(%ebp)
  801b67:	6a 0f                	push   $0xf
  801b69:	e8 b3 fe ff ff       	call   801a21 <syscall>
  801b6e:	83 c4 18             	add    $0x18,%esp
	return;
  801b71:	90                   	nop
}
  801b72:	c9                   	leave  
  801b73:	c3                   	ret    

00801b74 <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  801b74:	55                   	push   %ebp
  801b75:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  801b77:	6a 00                	push   $0x0
  801b79:	6a 00                	push   $0x0
  801b7b:	6a 00                	push   $0x0
  801b7d:	ff 75 0c             	pushl  0xc(%ebp)
  801b80:	ff 75 08             	pushl  0x8(%ebp)
  801b83:	6a 10                	push   $0x10
  801b85:	e8 97 fe ff ff       	call   801a21 <syscall>
  801b8a:	83 c4 18             	add    $0x18,%esp
	return ;
  801b8d:	90                   	nop
}
  801b8e:	c9                   	leave  
  801b8f:	c3                   	ret    

00801b90 <sys_allocate_chunk>:

void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  801b90:	55                   	push   %ebp
  801b91:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  801b93:	6a 00                	push   $0x0
  801b95:	6a 00                	push   $0x0
  801b97:	ff 75 10             	pushl  0x10(%ebp)
  801b9a:	ff 75 0c             	pushl  0xc(%ebp)
  801b9d:	ff 75 08             	pushl  0x8(%ebp)
  801ba0:	6a 11                	push   $0x11
  801ba2:	e8 7a fe ff ff       	call   801a21 <syscall>
  801ba7:	83 c4 18             	add    $0x18,%esp
	return ;
  801baa:	90                   	nop
}
  801bab:	c9                   	leave  
  801bac:	c3                   	ret    

00801bad <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  801bad:	55                   	push   %ebp
  801bae:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  801bb0:	6a 00                	push   $0x0
  801bb2:	6a 00                	push   $0x0
  801bb4:	6a 00                	push   $0x0
  801bb6:	6a 00                	push   $0x0
  801bb8:	6a 00                	push   $0x0
  801bba:	6a 0c                	push   $0xc
  801bbc:	e8 60 fe ff ff       	call   801a21 <syscall>
  801bc1:	83 c4 18             	add    $0x18,%esp
}
  801bc4:	c9                   	leave  
  801bc5:	c3                   	ret    

00801bc6 <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  801bc6:	55                   	push   %ebp
  801bc7:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  801bc9:	6a 00                	push   $0x0
  801bcb:	6a 00                	push   $0x0
  801bcd:	6a 00                	push   $0x0
  801bcf:	6a 00                	push   $0x0
  801bd1:	ff 75 08             	pushl  0x8(%ebp)
  801bd4:	6a 0d                	push   $0xd
  801bd6:	e8 46 fe ff ff       	call   801a21 <syscall>
  801bdb:	83 c4 18             	add    $0x18,%esp
}
  801bde:	c9                   	leave  
  801bdf:	c3                   	ret    

00801be0 <sys_scarce_memory>:

void sys_scarce_memory()
{
  801be0:	55                   	push   %ebp
  801be1:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  801be3:	6a 00                	push   $0x0
  801be5:	6a 00                	push   $0x0
  801be7:	6a 00                	push   $0x0
  801be9:	6a 00                	push   $0x0
  801beb:	6a 00                	push   $0x0
  801bed:	6a 0e                	push   $0xe
  801bef:	e8 2d fe ff ff       	call   801a21 <syscall>
  801bf4:	83 c4 18             	add    $0x18,%esp
}
  801bf7:	90                   	nop
  801bf8:	c9                   	leave  
  801bf9:	c3                   	ret    

00801bfa <sys_disable_interrupt>:

//NEW !! 2012...
void
sys_disable_interrupt()
{
  801bfa:	55                   	push   %ebp
  801bfb:	89 e5                	mov    %esp,%ebp
	syscall(SYS_disableINTR,0, 0, 0, 0, 0);
  801bfd:	6a 00                	push   $0x0
  801bff:	6a 00                	push   $0x0
  801c01:	6a 00                	push   $0x0
  801c03:	6a 00                	push   $0x0
  801c05:	6a 00                	push   $0x0
  801c07:	6a 13                	push   $0x13
  801c09:	e8 13 fe ff ff       	call   801a21 <syscall>
  801c0e:	83 c4 18             	add    $0x18,%esp
}
  801c11:	90                   	nop
  801c12:	c9                   	leave  
  801c13:	c3                   	ret    

00801c14 <sys_enable_interrupt>:


void
sys_enable_interrupt()
{
  801c14:	55                   	push   %ebp
  801c15:	89 e5                	mov    %esp,%ebp
	syscall(SYS_enableINTR,0, 0, 0, 0, 0);
  801c17:	6a 00                	push   $0x0
  801c19:	6a 00                	push   $0x0
  801c1b:	6a 00                	push   $0x0
  801c1d:	6a 00                	push   $0x0
  801c1f:	6a 00                	push   $0x0
  801c21:	6a 14                	push   $0x14
  801c23:	e8 f9 fd ff ff       	call   801a21 <syscall>
  801c28:	83 c4 18             	add    $0x18,%esp
}
  801c2b:	90                   	nop
  801c2c:	c9                   	leave  
  801c2d:	c3                   	ret    

00801c2e <sys_cputc>:


void
sys_cputc(const char c)
{
  801c2e:	55                   	push   %ebp
  801c2f:	89 e5                	mov    %esp,%ebp
  801c31:	83 ec 04             	sub    $0x4,%esp
  801c34:	8b 45 08             	mov    0x8(%ebp),%eax
  801c37:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  801c3a:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801c3e:	6a 00                	push   $0x0
  801c40:	6a 00                	push   $0x0
  801c42:	6a 00                	push   $0x0
  801c44:	6a 00                	push   $0x0
  801c46:	50                   	push   %eax
  801c47:	6a 15                	push   $0x15
  801c49:	e8 d3 fd ff ff       	call   801a21 <syscall>
  801c4e:	83 c4 18             	add    $0x18,%esp
}
  801c51:	90                   	nop
  801c52:	c9                   	leave  
  801c53:	c3                   	ret    

00801c54 <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  801c54:	55                   	push   %ebp
  801c55:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  801c57:	6a 00                	push   $0x0
  801c59:	6a 00                	push   $0x0
  801c5b:	6a 00                	push   $0x0
  801c5d:	6a 00                	push   $0x0
  801c5f:	6a 00                	push   $0x0
  801c61:	6a 16                	push   $0x16
  801c63:	e8 b9 fd ff ff       	call   801a21 <syscall>
  801c68:	83 c4 18             	add    $0x18,%esp
}
  801c6b:	90                   	nop
  801c6c:	c9                   	leave  
  801c6d:	c3                   	ret    

00801c6e <sys_createSemaphore>:

int
sys_createSemaphore(char* semaphoreName, uint32 initialValue)
{
  801c6e:	55                   	push   %ebp
  801c6f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_semaphore,(uint32)semaphoreName, (uint32)initialValue, 0, 0, 0);
  801c71:	8b 45 08             	mov    0x8(%ebp),%eax
  801c74:	6a 00                	push   $0x0
  801c76:	6a 00                	push   $0x0
  801c78:	6a 00                	push   $0x0
  801c7a:	ff 75 0c             	pushl  0xc(%ebp)
  801c7d:	50                   	push   %eax
  801c7e:	6a 17                	push   $0x17
  801c80:	e8 9c fd ff ff       	call   801a21 <syscall>
  801c85:	83 c4 18             	add    $0x18,%esp
}
  801c88:	c9                   	leave  
  801c89:	c3                   	ret    

00801c8a <sys_getSemaphoreValue>:

int
sys_getSemaphoreValue(int32 ownerEnvID, char* semaphoreName)
{
  801c8a:	55                   	push   %ebp
  801c8b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_semaphore_value,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801c8d:	8b 55 0c             	mov    0xc(%ebp),%edx
  801c90:	8b 45 08             	mov    0x8(%ebp),%eax
  801c93:	6a 00                	push   $0x0
  801c95:	6a 00                	push   $0x0
  801c97:	6a 00                	push   $0x0
  801c99:	52                   	push   %edx
  801c9a:	50                   	push   %eax
  801c9b:	6a 1a                	push   $0x1a
  801c9d:	e8 7f fd ff ff       	call   801a21 <syscall>
  801ca2:	83 c4 18             	add    $0x18,%esp
}
  801ca5:	c9                   	leave  
  801ca6:	c3                   	ret    

00801ca7 <sys_waitSemaphore>:

void
sys_waitSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  801ca7:	55                   	push   %ebp
  801ca8:	89 e5                	mov    %esp,%ebp
	syscall(SYS_wait_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801caa:	8b 55 0c             	mov    0xc(%ebp),%edx
  801cad:	8b 45 08             	mov    0x8(%ebp),%eax
  801cb0:	6a 00                	push   $0x0
  801cb2:	6a 00                	push   $0x0
  801cb4:	6a 00                	push   $0x0
  801cb6:	52                   	push   %edx
  801cb7:	50                   	push   %eax
  801cb8:	6a 18                	push   $0x18
  801cba:	e8 62 fd ff ff       	call   801a21 <syscall>
  801cbf:	83 c4 18             	add    $0x18,%esp
}
  801cc2:	90                   	nop
  801cc3:	c9                   	leave  
  801cc4:	c3                   	ret    

00801cc5 <sys_signalSemaphore>:

void
sys_signalSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  801cc5:	55                   	push   %ebp
  801cc6:	89 e5                	mov    %esp,%ebp
	syscall(SYS_signal_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801cc8:	8b 55 0c             	mov    0xc(%ebp),%edx
  801ccb:	8b 45 08             	mov    0x8(%ebp),%eax
  801cce:	6a 00                	push   $0x0
  801cd0:	6a 00                	push   $0x0
  801cd2:	6a 00                	push   $0x0
  801cd4:	52                   	push   %edx
  801cd5:	50                   	push   %eax
  801cd6:	6a 19                	push   $0x19
  801cd8:	e8 44 fd ff ff       	call   801a21 <syscall>
  801cdd:	83 c4 18             	add    $0x18,%esp
}
  801ce0:	90                   	nop
  801ce1:	c9                   	leave  
  801ce2:	c3                   	ret    

00801ce3 <sys_createSharedObject>:

int
sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  801ce3:	55                   	push   %ebp
  801ce4:	89 e5                	mov    %esp,%ebp
  801ce6:	83 ec 04             	sub    $0x4,%esp
  801ce9:	8b 45 10             	mov    0x10(%ebp),%eax
  801cec:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  801cef:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801cf2:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801cf6:	8b 45 08             	mov    0x8(%ebp),%eax
  801cf9:	6a 00                	push   $0x0
  801cfb:	51                   	push   %ecx
  801cfc:	52                   	push   %edx
  801cfd:	ff 75 0c             	pushl  0xc(%ebp)
  801d00:	50                   	push   %eax
  801d01:	6a 1b                	push   $0x1b
  801d03:	e8 19 fd ff ff       	call   801a21 <syscall>
  801d08:	83 c4 18             	add    $0x18,%esp
}
  801d0b:	c9                   	leave  
  801d0c:	c3                   	ret    

00801d0d <sys_getSizeOfSharedObject>:

//2017:
int
sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  801d0d:	55                   	push   %ebp
  801d0e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  801d10:	8b 55 0c             	mov    0xc(%ebp),%edx
  801d13:	8b 45 08             	mov    0x8(%ebp),%eax
  801d16:	6a 00                	push   $0x0
  801d18:	6a 00                	push   $0x0
  801d1a:	6a 00                	push   $0x0
  801d1c:	52                   	push   %edx
  801d1d:	50                   	push   %eax
  801d1e:	6a 1c                	push   $0x1c
  801d20:	e8 fc fc ff ff       	call   801a21 <syscall>
  801d25:	83 c4 18             	add    $0x18,%esp
}
  801d28:	c9                   	leave  
  801d29:	c3                   	ret    

00801d2a <sys_getSharedObject>:
//==========

int
sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  801d2a:	55                   	push   %ebp
  801d2b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  801d2d:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801d30:	8b 55 0c             	mov    0xc(%ebp),%edx
  801d33:	8b 45 08             	mov    0x8(%ebp),%eax
  801d36:	6a 00                	push   $0x0
  801d38:	6a 00                	push   $0x0
  801d3a:	51                   	push   %ecx
  801d3b:	52                   	push   %edx
  801d3c:	50                   	push   %eax
  801d3d:	6a 1d                	push   $0x1d
  801d3f:	e8 dd fc ff ff       	call   801a21 <syscall>
  801d44:	83 c4 18             	add    $0x18,%esp
}
  801d47:	c9                   	leave  
  801d48:	c3                   	ret    

00801d49 <sys_freeSharedObject>:

int
sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  801d49:	55                   	push   %ebp
  801d4a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  801d4c:	8b 55 0c             	mov    0xc(%ebp),%edx
  801d4f:	8b 45 08             	mov    0x8(%ebp),%eax
  801d52:	6a 00                	push   $0x0
  801d54:	6a 00                	push   $0x0
  801d56:	6a 00                	push   $0x0
  801d58:	52                   	push   %edx
  801d59:	50                   	push   %eax
  801d5a:	6a 1e                	push   $0x1e
  801d5c:	e8 c0 fc ff ff       	call   801a21 <syscall>
  801d61:	83 c4 18             	add    $0x18,%esp
}
  801d64:	c9                   	leave  
  801d65:	c3                   	ret    

00801d66 <sys_getMaxShares>:

uint32 	sys_getMaxShares()
{
  801d66:	55                   	push   %ebp
  801d67:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_max_shares,0, 0, 0, 0, 0);
  801d69:	6a 00                	push   $0x0
  801d6b:	6a 00                	push   $0x0
  801d6d:	6a 00                	push   $0x0
  801d6f:	6a 00                	push   $0x0
  801d71:	6a 00                	push   $0x0
  801d73:	6a 1f                	push   $0x1f
  801d75:	e8 a7 fc ff ff       	call   801a21 <syscall>
  801d7a:	83 c4 18             	add    $0x18,%esp
}
  801d7d:	c9                   	leave  
  801d7e:	c3                   	ret    

00801d7f <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  801d7f:	55                   	push   %ebp
  801d80:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  801d82:	8b 45 08             	mov    0x8(%ebp),%eax
  801d85:	6a 00                	push   $0x0
  801d87:	ff 75 14             	pushl  0x14(%ebp)
  801d8a:	ff 75 10             	pushl  0x10(%ebp)
  801d8d:	ff 75 0c             	pushl  0xc(%ebp)
  801d90:	50                   	push   %eax
  801d91:	6a 20                	push   $0x20
  801d93:	e8 89 fc ff ff       	call   801a21 <syscall>
  801d98:	83 c4 18             	add    $0x18,%esp
}
  801d9b:	c9                   	leave  
  801d9c:	c3                   	ret    

00801d9d <sys_run_env>:

void
sys_run_env(int32 envId)
{
  801d9d:	55                   	push   %ebp
  801d9e:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  801da0:	8b 45 08             	mov    0x8(%ebp),%eax
  801da3:	6a 00                	push   $0x0
  801da5:	6a 00                	push   $0x0
  801da7:	6a 00                	push   $0x0
  801da9:	6a 00                	push   $0x0
  801dab:	50                   	push   %eax
  801dac:	6a 21                	push   $0x21
  801dae:	e8 6e fc ff ff       	call   801a21 <syscall>
  801db3:	83 c4 18             	add    $0x18,%esp
}
  801db6:	90                   	nop
  801db7:	c9                   	leave  
  801db8:	c3                   	ret    

00801db9 <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  801db9:	55                   	push   %ebp
  801dba:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  801dbc:	8b 45 08             	mov    0x8(%ebp),%eax
  801dbf:	6a 00                	push   $0x0
  801dc1:	6a 00                	push   $0x0
  801dc3:	6a 00                	push   $0x0
  801dc5:	6a 00                	push   $0x0
  801dc7:	50                   	push   %eax
  801dc8:	6a 22                	push   $0x22
  801dca:	e8 52 fc ff ff       	call   801a21 <syscall>
  801dcf:	83 c4 18             	add    $0x18,%esp
}
  801dd2:	c9                   	leave  
  801dd3:	c3                   	ret    

00801dd4 <sys_getenvid>:

int32 sys_getenvid(void)
{
  801dd4:	55                   	push   %ebp
  801dd5:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  801dd7:	6a 00                	push   $0x0
  801dd9:	6a 00                	push   $0x0
  801ddb:	6a 00                	push   $0x0
  801ddd:	6a 00                	push   $0x0
  801ddf:	6a 00                	push   $0x0
  801de1:	6a 02                	push   $0x2
  801de3:	e8 39 fc ff ff       	call   801a21 <syscall>
  801de8:	83 c4 18             	add    $0x18,%esp
}
  801deb:	c9                   	leave  
  801dec:	c3                   	ret    

00801ded <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  801ded:	55                   	push   %ebp
  801dee:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  801df0:	6a 00                	push   $0x0
  801df2:	6a 00                	push   $0x0
  801df4:	6a 00                	push   $0x0
  801df6:	6a 00                	push   $0x0
  801df8:	6a 00                	push   $0x0
  801dfa:	6a 03                	push   $0x3
  801dfc:	e8 20 fc ff ff       	call   801a21 <syscall>
  801e01:	83 c4 18             	add    $0x18,%esp
}
  801e04:	c9                   	leave  
  801e05:	c3                   	ret    

00801e06 <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  801e06:	55                   	push   %ebp
  801e07:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  801e09:	6a 00                	push   $0x0
  801e0b:	6a 00                	push   $0x0
  801e0d:	6a 00                	push   $0x0
  801e0f:	6a 00                	push   $0x0
  801e11:	6a 00                	push   $0x0
  801e13:	6a 04                	push   $0x4
  801e15:	e8 07 fc ff ff       	call   801a21 <syscall>
  801e1a:	83 c4 18             	add    $0x18,%esp
}
  801e1d:	c9                   	leave  
  801e1e:	c3                   	ret    

00801e1f <sys_exit_env>:


void sys_exit_env(void)
{
  801e1f:	55                   	push   %ebp
  801e20:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  801e22:	6a 00                	push   $0x0
  801e24:	6a 00                	push   $0x0
  801e26:	6a 00                	push   $0x0
  801e28:	6a 00                	push   $0x0
  801e2a:	6a 00                	push   $0x0
  801e2c:	6a 23                	push   $0x23
  801e2e:	e8 ee fb ff ff       	call   801a21 <syscall>
  801e33:	83 c4 18             	add    $0x18,%esp
}
  801e36:	90                   	nop
  801e37:	c9                   	leave  
  801e38:	c3                   	ret    

00801e39 <sys_get_virtual_time>:


struct uint64
sys_get_virtual_time()
{
  801e39:	55                   	push   %ebp
  801e3a:	89 e5                	mov    %esp,%ebp
  801e3c:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  801e3f:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801e42:	8d 50 04             	lea    0x4(%eax),%edx
  801e45:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801e48:	6a 00                	push   $0x0
  801e4a:	6a 00                	push   $0x0
  801e4c:	6a 00                	push   $0x0
  801e4e:	52                   	push   %edx
  801e4f:	50                   	push   %eax
  801e50:	6a 24                	push   $0x24
  801e52:	e8 ca fb ff ff       	call   801a21 <syscall>
  801e57:	83 c4 18             	add    $0x18,%esp
	return result;
  801e5a:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801e5d:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801e60:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801e63:	89 01                	mov    %eax,(%ecx)
  801e65:	89 51 04             	mov    %edx,0x4(%ecx)
}
  801e68:	8b 45 08             	mov    0x8(%ebp),%eax
  801e6b:	c9                   	leave  
  801e6c:	c2 04 00             	ret    $0x4

00801e6f <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  801e6f:	55                   	push   %ebp
  801e70:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  801e72:	6a 00                	push   $0x0
  801e74:	6a 00                	push   $0x0
  801e76:	ff 75 10             	pushl  0x10(%ebp)
  801e79:	ff 75 0c             	pushl  0xc(%ebp)
  801e7c:	ff 75 08             	pushl  0x8(%ebp)
  801e7f:	6a 12                	push   $0x12
  801e81:	e8 9b fb ff ff       	call   801a21 <syscall>
  801e86:	83 c4 18             	add    $0x18,%esp
	return ;
  801e89:	90                   	nop
}
  801e8a:	c9                   	leave  
  801e8b:	c3                   	ret    

00801e8c <sys_rcr2>:
uint32 sys_rcr2()
{
  801e8c:	55                   	push   %ebp
  801e8d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  801e8f:	6a 00                	push   $0x0
  801e91:	6a 00                	push   $0x0
  801e93:	6a 00                	push   $0x0
  801e95:	6a 00                	push   $0x0
  801e97:	6a 00                	push   $0x0
  801e99:	6a 25                	push   $0x25
  801e9b:	e8 81 fb ff ff       	call   801a21 <syscall>
  801ea0:	83 c4 18             	add    $0x18,%esp
}
  801ea3:	c9                   	leave  
  801ea4:	c3                   	ret    

00801ea5 <sys_bypassPageFault>:
void sys_bypassPageFault(uint8 instrLength)
{
  801ea5:	55                   	push   %ebp
  801ea6:	89 e5                	mov    %esp,%ebp
  801ea8:	83 ec 04             	sub    $0x4,%esp
  801eab:	8b 45 08             	mov    0x8(%ebp),%eax
  801eae:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  801eb1:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  801eb5:	6a 00                	push   $0x0
  801eb7:	6a 00                	push   $0x0
  801eb9:	6a 00                	push   $0x0
  801ebb:	6a 00                	push   $0x0
  801ebd:	50                   	push   %eax
  801ebe:	6a 26                	push   $0x26
  801ec0:	e8 5c fb ff ff       	call   801a21 <syscall>
  801ec5:	83 c4 18             	add    $0x18,%esp
	return ;
  801ec8:	90                   	nop
}
  801ec9:	c9                   	leave  
  801eca:	c3                   	ret    

00801ecb <rsttst>:
void rsttst()
{
  801ecb:	55                   	push   %ebp
  801ecc:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  801ece:	6a 00                	push   $0x0
  801ed0:	6a 00                	push   $0x0
  801ed2:	6a 00                	push   $0x0
  801ed4:	6a 00                	push   $0x0
  801ed6:	6a 00                	push   $0x0
  801ed8:	6a 28                	push   $0x28
  801eda:	e8 42 fb ff ff       	call   801a21 <syscall>
  801edf:	83 c4 18             	add    $0x18,%esp
	return ;
  801ee2:	90                   	nop
}
  801ee3:	c9                   	leave  
  801ee4:	c3                   	ret    

00801ee5 <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  801ee5:	55                   	push   %ebp
  801ee6:	89 e5                	mov    %esp,%ebp
  801ee8:	83 ec 04             	sub    $0x4,%esp
  801eeb:	8b 45 14             	mov    0x14(%ebp),%eax
  801eee:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  801ef1:	8b 55 18             	mov    0x18(%ebp),%edx
  801ef4:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801ef8:	52                   	push   %edx
  801ef9:	50                   	push   %eax
  801efa:	ff 75 10             	pushl  0x10(%ebp)
  801efd:	ff 75 0c             	pushl  0xc(%ebp)
  801f00:	ff 75 08             	pushl  0x8(%ebp)
  801f03:	6a 27                	push   $0x27
  801f05:	e8 17 fb ff ff       	call   801a21 <syscall>
  801f0a:	83 c4 18             	add    $0x18,%esp
	return ;
  801f0d:	90                   	nop
}
  801f0e:	c9                   	leave  
  801f0f:	c3                   	ret    

00801f10 <chktst>:
void chktst(uint32 n)
{
  801f10:	55                   	push   %ebp
  801f11:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  801f13:	6a 00                	push   $0x0
  801f15:	6a 00                	push   $0x0
  801f17:	6a 00                	push   $0x0
  801f19:	6a 00                	push   $0x0
  801f1b:	ff 75 08             	pushl  0x8(%ebp)
  801f1e:	6a 29                	push   $0x29
  801f20:	e8 fc fa ff ff       	call   801a21 <syscall>
  801f25:	83 c4 18             	add    $0x18,%esp
	return ;
  801f28:	90                   	nop
}
  801f29:	c9                   	leave  
  801f2a:	c3                   	ret    

00801f2b <inctst>:

void inctst()
{
  801f2b:	55                   	push   %ebp
  801f2c:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  801f2e:	6a 00                	push   $0x0
  801f30:	6a 00                	push   $0x0
  801f32:	6a 00                	push   $0x0
  801f34:	6a 00                	push   $0x0
  801f36:	6a 00                	push   $0x0
  801f38:	6a 2a                	push   $0x2a
  801f3a:	e8 e2 fa ff ff       	call   801a21 <syscall>
  801f3f:	83 c4 18             	add    $0x18,%esp
	return ;
  801f42:	90                   	nop
}
  801f43:	c9                   	leave  
  801f44:	c3                   	ret    

00801f45 <gettst>:
uint32 gettst()
{
  801f45:	55                   	push   %ebp
  801f46:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  801f48:	6a 00                	push   $0x0
  801f4a:	6a 00                	push   $0x0
  801f4c:	6a 00                	push   $0x0
  801f4e:	6a 00                	push   $0x0
  801f50:	6a 00                	push   $0x0
  801f52:	6a 2b                	push   $0x2b
  801f54:	e8 c8 fa ff ff       	call   801a21 <syscall>
  801f59:	83 c4 18             	add    $0x18,%esp
}
  801f5c:	c9                   	leave  
  801f5d:	c3                   	ret    

00801f5e <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  801f5e:	55                   	push   %ebp
  801f5f:	89 e5                	mov    %esp,%ebp
  801f61:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801f64:	6a 00                	push   $0x0
  801f66:	6a 00                	push   $0x0
  801f68:	6a 00                	push   $0x0
  801f6a:	6a 00                	push   $0x0
  801f6c:	6a 00                	push   $0x0
  801f6e:	6a 2c                	push   $0x2c
  801f70:	e8 ac fa ff ff       	call   801a21 <syscall>
  801f75:	83 c4 18             	add    $0x18,%esp
  801f78:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  801f7b:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  801f7f:	75 07                	jne    801f88 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  801f81:	b8 01 00 00 00       	mov    $0x1,%eax
  801f86:	eb 05                	jmp    801f8d <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  801f88:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801f8d:	c9                   	leave  
  801f8e:	c3                   	ret    

00801f8f <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  801f8f:	55                   	push   %ebp
  801f90:	89 e5                	mov    %esp,%ebp
  801f92:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801f95:	6a 00                	push   $0x0
  801f97:	6a 00                	push   $0x0
  801f99:	6a 00                	push   $0x0
  801f9b:	6a 00                	push   $0x0
  801f9d:	6a 00                	push   $0x0
  801f9f:	6a 2c                	push   $0x2c
  801fa1:	e8 7b fa ff ff       	call   801a21 <syscall>
  801fa6:	83 c4 18             	add    $0x18,%esp
  801fa9:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  801fac:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  801fb0:	75 07                	jne    801fb9 <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  801fb2:	b8 01 00 00 00       	mov    $0x1,%eax
  801fb7:	eb 05                	jmp    801fbe <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  801fb9:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801fbe:	c9                   	leave  
  801fbf:	c3                   	ret    

00801fc0 <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  801fc0:	55                   	push   %ebp
  801fc1:	89 e5                	mov    %esp,%ebp
  801fc3:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801fc6:	6a 00                	push   $0x0
  801fc8:	6a 00                	push   $0x0
  801fca:	6a 00                	push   $0x0
  801fcc:	6a 00                	push   $0x0
  801fce:	6a 00                	push   $0x0
  801fd0:	6a 2c                	push   $0x2c
  801fd2:	e8 4a fa ff ff       	call   801a21 <syscall>
  801fd7:	83 c4 18             	add    $0x18,%esp
  801fda:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  801fdd:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  801fe1:	75 07                	jne    801fea <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  801fe3:	b8 01 00 00 00       	mov    $0x1,%eax
  801fe8:	eb 05                	jmp    801fef <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  801fea:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801fef:	c9                   	leave  
  801ff0:	c3                   	ret    

00801ff1 <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  801ff1:	55                   	push   %ebp
  801ff2:	89 e5                	mov    %esp,%ebp
  801ff4:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801ff7:	6a 00                	push   $0x0
  801ff9:	6a 00                	push   $0x0
  801ffb:	6a 00                	push   $0x0
  801ffd:	6a 00                	push   $0x0
  801fff:	6a 00                	push   $0x0
  802001:	6a 2c                	push   $0x2c
  802003:	e8 19 fa ff ff       	call   801a21 <syscall>
  802008:	83 c4 18             	add    $0x18,%esp
  80200b:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  80200e:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  802012:	75 07                	jne    80201b <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  802014:	b8 01 00 00 00       	mov    $0x1,%eax
  802019:	eb 05                	jmp    802020 <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  80201b:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802020:	c9                   	leave  
  802021:	c3                   	ret    

00802022 <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  802022:	55                   	push   %ebp
  802023:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  802025:	6a 00                	push   $0x0
  802027:	6a 00                	push   $0x0
  802029:	6a 00                	push   $0x0
  80202b:	6a 00                	push   $0x0
  80202d:	ff 75 08             	pushl  0x8(%ebp)
  802030:	6a 2d                	push   $0x2d
  802032:	e8 ea f9 ff ff       	call   801a21 <syscall>
  802037:	83 c4 18             	add    $0x18,%esp
	return ;
  80203a:	90                   	nop
}
  80203b:	c9                   	leave  
  80203c:	c3                   	ret    

0080203d <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  80203d:	55                   	push   %ebp
  80203e:	89 e5                	mov    %esp,%ebp
  802040:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  802041:	8b 5d 14             	mov    0x14(%ebp),%ebx
  802044:	8b 4d 10             	mov    0x10(%ebp),%ecx
  802047:	8b 55 0c             	mov    0xc(%ebp),%edx
  80204a:	8b 45 08             	mov    0x8(%ebp),%eax
  80204d:	6a 00                	push   $0x0
  80204f:	53                   	push   %ebx
  802050:	51                   	push   %ecx
  802051:	52                   	push   %edx
  802052:	50                   	push   %eax
  802053:	6a 2e                	push   $0x2e
  802055:	e8 c7 f9 ff ff       	call   801a21 <syscall>
  80205a:	83 c4 18             	add    $0x18,%esp
}
  80205d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  802060:	c9                   	leave  
  802061:	c3                   	ret    

00802062 <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  802062:	55                   	push   %ebp
  802063:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  802065:	8b 55 0c             	mov    0xc(%ebp),%edx
  802068:	8b 45 08             	mov    0x8(%ebp),%eax
  80206b:	6a 00                	push   $0x0
  80206d:	6a 00                	push   $0x0
  80206f:	6a 00                	push   $0x0
  802071:	52                   	push   %edx
  802072:	50                   	push   %eax
  802073:	6a 2f                	push   $0x2f
  802075:	e8 a7 f9 ff ff       	call   801a21 <syscall>
  80207a:	83 c4 18             	add    $0x18,%esp
}
  80207d:	c9                   	leave  
  80207e:	c3                   	ret    

0080207f <print_mem_block_lists>:
//===========================
// PRINT MEM BLOCK LISTS:
//===========================

void print_mem_block_lists()
{
  80207f:	55                   	push   %ebp
  802080:	89 e5                	mov    %esp,%ebp
  802082:	83 ec 18             	sub    $0x18,%esp
	cprintf("\n=========================================\n");
  802085:	83 ec 0c             	sub    $0xc,%esp
  802088:	68 c0 3c 80 00       	push   $0x803cc0
  80208d:	e8 dd e6 ff ff       	call   80076f <cprintf>
  802092:	83 c4 10             	add    $0x10,%esp
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
  802095:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nFreeMemBlocksList:\n");
  80209c:	83 ec 0c             	sub    $0xc,%esp
  80209f:	68 ec 3c 80 00       	push   $0x803cec
  8020a4:	e8 c6 e6 ff ff       	call   80076f <cprintf>
  8020a9:	83 c4 10             	add    $0x10,%esp
	uint8 sorted = 1 ;
  8020ac:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &FreeMemBlocksList)
  8020b0:	a1 38 41 80 00       	mov    0x804138,%eax
  8020b5:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8020b8:	eb 56                	jmp    802110 <print_mem_block_lists+0x91>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  8020ba:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8020be:	74 1c                	je     8020dc <print_mem_block_lists+0x5d>
  8020c0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8020c3:	8b 50 08             	mov    0x8(%eax),%edx
  8020c6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8020c9:	8b 48 08             	mov    0x8(%eax),%ecx
  8020cc:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8020cf:	8b 40 0c             	mov    0xc(%eax),%eax
  8020d2:	01 c8                	add    %ecx,%eax
  8020d4:	39 c2                	cmp    %eax,%edx
  8020d6:	73 04                	jae    8020dc <print_mem_block_lists+0x5d>
			sorted = 0 ;
  8020d8:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  8020dc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8020df:	8b 50 08             	mov    0x8(%eax),%edx
  8020e2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8020e5:	8b 40 0c             	mov    0xc(%eax),%eax
  8020e8:	01 c2                	add    %eax,%edx
  8020ea:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8020ed:	8b 40 08             	mov    0x8(%eax),%eax
  8020f0:	83 ec 04             	sub    $0x4,%esp
  8020f3:	52                   	push   %edx
  8020f4:	50                   	push   %eax
  8020f5:	68 01 3d 80 00       	push   $0x803d01
  8020fa:	e8 70 e6 ff ff       	call   80076f <cprintf>
  8020ff:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  802102:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802105:	89 45 f0             	mov    %eax,-0x10(%ebp)
	cprintf("\n=========================================\n");
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
	cprintf("\nFreeMemBlocksList:\n");
	uint8 sorted = 1 ;
	LIST_FOREACH(blk, &FreeMemBlocksList)
  802108:	a1 40 41 80 00       	mov    0x804140,%eax
  80210d:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802110:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802114:	74 07                	je     80211d <print_mem_block_lists+0x9e>
  802116:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802119:	8b 00                	mov    (%eax),%eax
  80211b:	eb 05                	jmp    802122 <print_mem_block_lists+0xa3>
  80211d:	b8 00 00 00 00       	mov    $0x0,%eax
  802122:	a3 40 41 80 00       	mov    %eax,0x804140
  802127:	a1 40 41 80 00       	mov    0x804140,%eax
  80212c:	85 c0                	test   %eax,%eax
  80212e:	75 8a                	jne    8020ba <print_mem_block_lists+0x3b>
  802130:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802134:	75 84                	jne    8020ba <print_mem_block_lists+0x3b>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;
  802136:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  80213a:	75 10                	jne    80214c <print_mem_block_lists+0xcd>
  80213c:	83 ec 0c             	sub    $0xc,%esp
  80213f:	68 10 3d 80 00       	push   $0x803d10
  802144:	e8 26 e6 ff ff       	call   80076f <cprintf>
  802149:	83 c4 10             	add    $0x10,%esp

	lastBlk = NULL ;
  80214c:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nAllocMemBlocksList:\n");
  802153:	83 ec 0c             	sub    $0xc,%esp
  802156:	68 34 3d 80 00       	push   $0x803d34
  80215b:	e8 0f e6 ff ff       	call   80076f <cprintf>
  802160:	83 c4 10             	add    $0x10,%esp
	sorted = 1 ;
  802163:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &AllocMemBlocksList)
  802167:	a1 40 40 80 00       	mov    0x804040,%eax
  80216c:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80216f:	eb 56                	jmp    8021c7 <print_mem_block_lists+0x148>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  802171:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802175:	74 1c                	je     802193 <print_mem_block_lists+0x114>
  802177:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80217a:	8b 50 08             	mov    0x8(%eax),%edx
  80217d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802180:	8b 48 08             	mov    0x8(%eax),%ecx
  802183:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802186:	8b 40 0c             	mov    0xc(%eax),%eax
  802189:	01 c8                	add    %ecx,%eax
  80218b:	39 c2                	cmp    %eax,%edx
  80218d:	73 04                	jae    802193 <print_mem_block_lists+0x114>
			sorted = 0 ;
  80218f:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  802193:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802196:	8b 50 08             	mov    0x8(%eax),%edx
  802199:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80219c:	8b 40 0c             	mov    0xc(%eax),%eax
  80219f:	01 c2                	add    %eax,%edx
  8021a1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8021a4:	8b 40 08             	mov    0x8(%eax),%eax
  8021a7:	83 ec 04             	sub    $0x4,%esp
  8021aa:	52                   	push   %edx
  8021ab:	50                   	push   %eax
  8021ac:	68 01 3d 80 00       	push   $0x803d01
  8021b1:	e8 b9 e5 ff ff       	call   80076f <cprintf>
  8021b6:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  8021b9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8021bc:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;

	lastBlk = NULL ;
	cprintf("\nAllocMemBlocksList:\n");
	sorted = 1 ;
	LIST_FOREACH(blk, &AllocMemBlocksList)
  8021bf:	a1 48 40 80 00       	mov    0x804048,%eax
  8021c4:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8021c7:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8021cb:	74 07                	je     8021d4 <print_mem_block_lists+0x155>
  8021cd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8021d0:	8b 00                	mov    (%eax),%eax
  8021d2:	eb 05                	jmp    8021d9 <print_mem_block_lists+0x15a>
  8021d4:	b8 00 00 00 00       	mov    $0x0,%eax
  8021d9:	a3 48 40 80 00       	mov    %eax,0x804048
  8021de:	a1 48 40 80 00       	mov    0x804048,%eax
  8021e3:	85 c0                	test   %eax,%eax
  8021e5:	75 8a                	jne    802171 <print_mem_block_lists+0xf2>
  8021e7:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8021eb:	75 84                	jne    802171 <print_mem_block_lists+0xf2>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nAllocMemBlocksList is NOT SORTED!!\n") ;
  8021ed:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  8021f1:	75 10                	jne    802203 <print_mem_block_lists+0x184>
  8021f3:	83 ec 0c             	sub    $0xc,%esp
  8021f6:	68 4c 3d 80 00       	push   $0x803d4c
  8021fb:	e8 6f e5 ff ff       	call   80076f <cprintf>
  802200:	83 c4 10             	add    $0x10,%esp
	cprintf("\n=========================================\n");
  802203:	83 ec 0c             	sub    $0xc,%esp
  802206:	68 c0 3c 80 00       	push   $0x803cc0
  80220b:	e8 5f e5 ff ff       	call   80076f <cprintf>
  802210:	83 c4 10             	add    $0x10,%esp

}
  802213:	90                   	nop
  802214:	c9                   	leave  
  802215:	c3                   	ret    

00802216 <initialize_MemBlocksList>:

//===============================
// [1] INITIALIZE AVAILABLE LIST:
//===============================
void initialize_MemBlocksList(uint32 numOfBlocks)
{
  802216:	55                   	push   %ebp
  802217:	89 e5                	mov    %esp,%ebp
  802219:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] initialize_MemBlocksList
	// Write your code here, remove the panic and write your code
	//panic("initialize_MemBlocksList() is not implemented yet...!!");
	uint32 n = numOfBlocks;
  80221c:	8b 45 08             	mov    0x8(%ebp),%eax
  80221f:	89 45 f0             	mov    %eax,-0x10(%ebp)

	LIST_INIT(&AvailableMemBlocksList);
  802222:	c7 05 48 41 80 00 00 	movl   $0x0,0x804148
  802229:	00 00 00 
  80222c:	c7 05 4c 41 80 00 00 	movl   $0x0,0x80414c
  802233:	00 00 00 
  802236:	c7 05 54 41 80 00 00 	movl   $0x0,0x804154
  80223d:	00 00 00 
	for(int i = 0; i<n;i++)
  802240:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  802247:	e9 9e 00 00 00       	jmp    8022ea <initialize_MemBlocksList+0xd4>
	{
		LIST_INSERT_HEAD(&AvailableMemBlocksList, &(MemBlockNodes[i]));
  80224c:	a1 50 40 80 00       	mov    0x804050,%eax
  802251:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802254:	c1 e2 04             	shl    $0x4,%edx
  802257:	01 d0                	add    %edx,%eax
  802259:	85 c0                	test   %eax,%eax
  80225b:	75 14                	jne    802271 <initialize_MemBlocksList+0x5b>
  80225d:	83 ec 04             	sub    $0x4,%esp
  802260:	68 74 3d 80 00       	push   $0x803d74
  802265:	6a 47                	push   $0x47
  802267:	68 97 3d 80 00       	push   $0x803d97
  80226c:	e8 4a e2 ff ff       	call   8004bb <_panic>
  802271:	a1 50 40 80 00       	mov    0x804050,%eax
  802276:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802279:	c1 e2 04             	shl    $0x4,%edx
  80227c:	01 d0                	add    %edx,%eax
  80227e:	8b 15 48 41 80 00    	mov    0x804148,%edx
  802284:	89 10                	mov    %edx,(%eax)
  802286:	8b 00                	mov    (%eax),%eax
  802288:	85 c0                	test   %eax,%eax
  80228a:	74 18                	je     8022a4 <initialize_MemBlocksList+0x8e>
  80228c:	a1 48 41 80 00       	mov    0x804148,%eax
  802291:	8b 15 50 40 80 00    	mov    0x804050,%edx
  802297:	8b 4d f4             	mov    -0xc(%ebp),%ecx
  80229a:	c1 e1 04             	shl    $0x4,%ecx
  80229d:	01 ca                	add    %ecx,%edx
  80229f:	89 50 04             	mov    %edx,0x4(%eax)
  8022a2:	eb 12                	jmp    8022b6 <initialize_MemBlocksList+0xa0>
  8022a4:	a1 50 40 80 00       	mov    0x804050,%eax
  8022a9:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8022ac:	c1 e2 04             	shl    $0x4,%edx
  8022af:	01 d0                	add    %edx,%eax
  8022b1:	a3 4c 41 80 00       	mov    %eax,0x80414c
  8022b6:	a1 50 40 80 00       	mov    0x804050,%eax
  8022bb:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8022be:	c1 e2 04             	shl    $0x4,%edx
  8022c1:	01 d0                	add    %edx,%eax
  8022c3:	a3 48 41 80 00       	mov    %eax,0x804148
  8022c8:	a1 50 40 80 00       	mov    0x804050,%eax
  8022cd:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8022d0:	c1 e2 04             	shl    $0x4,%edx
  8022d3:	01 d0                	add    %edx,%eax
  8022d5:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8022dc:	a1 54 41 80 00       	mov    0x804154,%eax
  8022e1:	40                   	inc    %eax
  8022e2:	a3 54 41 80 00       	mov    %eax,0x804154
	// Write your code here, remove the panic and write your code
	//panic("initialize_MemBlocksList() is not implemented yet...!!");
	uint32 n = numOfBlocks;

	LIST_INIT(&AvailableMemBlocksList);
	for(int i = 0; i<n;i++)
  8022e7:	ff 45 f4             	incl   -0xc(%ebp)
  8022ea:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022ed:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8022f0:	0f 82 56 ff ff ff    	jb     80224c <initialize_MemBlocksList+0x36>
	{
		LIST_INSERT_HEAD(&AvailableMemBlocksList, &(MemBlockNodes[i]));
	}
}
  8022f6:	90                   	nop
  8022f7:	c9                   	leave  
  8022f8:	c3                   	ret    

008022f9 <find_block>:

//===============================
// [2] FIND BLOCK:
//===============================
struct MemBlock *find_block(struct MemBlock_List *blockList, uint32 va)
{
  8022f9:	55                   	push   %ebp
  8022fa:	89 e5                	mov    %esp,%ebp
  8022fc:	83 ec 10             	sub    $0x10,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] find_block
	// Write your code here, remove the panic and write your code
	//panic("find_block() is not implemented yet...!!");
	uint32 virAddress = va;
  8022ff:	8b 45 0c             	mov    0xc(%ebp),%eax
  802302:	89 45 f4             	mov    %eax,-0xc(%ebp)
	struct MemBlock* blk;
	int found = 0;
  802305:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	LIST_FOREACH(blk, &(AllocMemBlocksList))
  80230c:	a1 40 40 80 00       	mov    0x804040,%eax
  802311:	89 45 fc             	mov    %eax,-0x4(%ebp)
  802314:	eb 23                	jmp    802339 <find_block+0x40>
	{
		if(blk->sva == virAddress)
  802316:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802319:	8b 40 08             	mov    0x8(%eax),%eax
  80231c:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  80231f:	75 09                	jne    80232a <find_block+0x31>
		{
			found = 1;
  802321:	c7 45 f8 01 00 00 00 	movl   $0x1,-0x8(%ebp)
			break;
  802328:	eb 35                	jmp    80235f <find_block+0x66>
		}
		else
		{
			found = 0;
  80232a:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	//panic("find_block() is not implemented yet...!!");
	uint32 virAddress = va;
	struct MemBlock* blk;
	int found = 0;

	LIST_FOREACH(blk, &(AllocMemBlocksList))
  802331:	a1 48 40 80 00       	mov    0x804048,%eax
  802336:	89 45 fc             	mov    %eax,-0x4(%ebp)
  802339:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  80233d:	74 07                	je     802346 <find_block+0x4d>
  80233f:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802342:	8b 00                	mov    (%eax),%eax
  802344:	eb 05                	jmp    80234b <find_block+0x52>
  802346:	b8 00 00 00 00       	mov    $0x0,%eax
  80234b:	a3 48 40 80 00       	mov    %eax,0x804048
  802350:	a1 48 40 80 00       	mov    0x804048,%eax
  802355:	85 c0                	test   %eax,%eax
  802357:	75 bd                	jne    802316 <find_block+0x1d>
  802359:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  80235d:	75 b7                	jne    802316 <find_block+0x1d>
		{
			found = 0;
			continue;
		}
	}
	if(found == 1)
  80235f:	83 7d f8 01          	cmpl   $0x1,-0x8(%ebp)
  802363:	75 05                	jne    80236a <find_block+0x71>
	{
		return blk;
  802365:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802368:	eb 05                	jmp    80236f <find_block+0x76>
	}
	else
	{
		return NULL;
  80236a:	b8 00 00 00 00       	mov    $0x0,%eax
	}
}
  80236f:	c9                   	leave  
  802370:	c3                   	ret    

00802371 <insert_sorted_allocList>:

//=========================================
// [3] INSERT BLOCK IN ALLOC LIST [SORTED]:
//=========================================
void insert_sorted_allocList(struct MemBlock *blockToInsert)
{
  802371:	55                   	push   %ebp
  802372:	89 e5                	mov    %esp,%ebp
  802374:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] insert_sorted_allocList
	// Write your code here, remove the panic and write your code
	//panic("insert_sorted_allocList() is not implemented yet...!!");
	struct MemBlock* blk;
	struct MemBlock* newblk = blockToInsert;
  802377:	8b 45 08             	mov    0x8(%ebp),%eax
  80237a:	89 45 f0             	mov    %eax,-0x10(%ebp)

	if((LIST_EMPTY(&AllocMemBlocksList)) || (newblk->sva < LIST_FIRST(&AllocMemBlocksList)->sva))
  80237d:	a1 40 40 80 00       	mov    0x804040,%eax
  802382:	85 c0                	test   %eax,%eax
  802384:	74 12                	je     802398 <insert_sorted_allocList+0x27>
  802386:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802389:	8b 50 08             	mov    0x8(%eax),%edx
  80238c:	a1 40 40 80 00       	mov    0x804040,%eax
  802391:	8b 40 08             	mov    0x8(%eax),%eax
  802394:	39 c2                	cmp    %eax,%edx
  802396:	73 65                	jae    8023fd <insert_sorted_allocList+0x8c>
	{
		LIST_INSERT_HEAD(&(AllocMemBlocksList), newblk);
  802398:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80239c:	75 14                	jne    8023b2 <insert_sorted_allocList+0x41>
  80239e:	83 ec 04             	sub    $0x4,%esp
  8023a1:	68 74 3d 80 00       	push   $0x803d74
  8023a6:	6a 7b                	push   $0x7b
  8023a8:	68 97 3d 80 00       	push   $0x803d97
  8023ad:	e8 09 e1 ff ff       	call   8004bb <_panic>
  8023b2:	8b 15 40 40 80 00    	mov    0x804040,%edx
  8023b8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8023bb:	89 10                	mov    %edx,(%eax)
  8023bd:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8023c0:	8b 00                	mov    (%eax),%eax
  8023c2:	85 c0                	test   %eax,%eax
  8023c4:	74 0d                	je     8023d3 <insert_sorted_allocList+0x62>
  8023c6:	a1 40 40 80 00       	mov    0x804040,%eax
  8023cb:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8023ce:	89 50 04             	mov    %edx,0x4(%eax)
  8023d1:	eb 08                	jmp    8023db <insert_sorted_allocList+0x6a>
  8023d3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8023d6:	a3 44 40 80 00       	mov    %eax,0x804044
  8023db:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8023de:	a3 40 40 80 00       	mov    %eax,0x804040
  8023e3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8023e6:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8023ed:	a1 4c 40 80 00       	mov    0x80404c,%eax
  8023f2:	40                   	inc    %eax
  8023f3:	a3 4c 40 80 00       	mov    %eax,0x80404c
  8023f8:	e9 5f 01 00 00       	jmp    80255c <insert_sorted_allocList+0x1eb>
	}
	else if(newblk->sva > LIST_LAST(&AllocMemBlocksList)->sva)
  8023fd:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802400:	8b 50 08             	mov    0x8(%eax),%edx
  802403:	a1 44 40 80 00       	mov    0x804044,%eax
  802408:	8b 40 08             	mov    0x8(%eax),%eax
  80240b:	39 c2                	cmp    %eax,%edx
  80240d:	76 65                	jbe    802474 <insert_sorted_allocList+0x103>
	{
		LIST_INSERT_TAIL(&AllocMemBlocksList, newblk);
  80240f:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802413:	75 14                	jne    802429 <insert_sorted_allocList+0xb8>
  802415:	83 ec 04             	sub    $0x4,%esp
  802418:	68 b0 3d 80 00       	push   $0x803db0
  80241d:	6a 7f                	push   $0x7f
  80241f:	68 97 3d 80 00       	push   $0x803d97
  802424:	e8 92 e0 ff ff       	call   8004bb <_panic>
  802429:	8b 15 44 40 80 00    	mov    0x804044,%edx
  80242f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802432:	89 50 04             	mov    %edx,0x4(%eax)
  802435:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802438:	8b 40 04             	mov    0x4(%eax),%eax
  80243b:	85 c0                	test   %eax,%eax
  80243d:	74 0c                	je     80244b <insert_sorted_allocList+0xda>
  80243f:	a1 44 40 80 00       	mov    0x804044,%eax
  802444:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802447:	89 10                	mov    %edx,(%eax)
  802449:	eb 08                	jmp    802453 <insert_sorted_allocList+0xe2>
  80244b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80244e:	a3 40 40 80 00       	mov    %eax,0x804040
  802453:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802456:	a3 44 40 80 00       	mov    %eax,0x804044
  80245b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80245e:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802464:	a1 4c 40 80 00       	mov    0x80404c,%eax
  802469:	40                   	inc    %eax
  80246a:	a3 4c 40 80 00       	mov    %eax,0x80404c
				LIST_INSERT_AFTER(&AllocMemBlocksList, blk, newblk);
				break;
			}
		}
	}
}
  80246f:	e9 e8 00 00 00       	jmp    80255c <insert_sorted_allocList+0x1eb>
	{
		LIST_INSERT_TAIL(&AllocMemBlocksList, newblk);
	}
	else
	{
		LIST_FOREACH(blk, &AllocMemBlocksList)
  802474:	a1 40 40 80 00       	mov    0x804040,%eax
  802479:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80247c:	e9 ab 00 00 00       	jmp    80252c <insert_sorted_allocList+0x1bb>
		{
			if(blk->prev_next_info.le_next != NULL && newblk->sva > blk->sva  && newblk->sva < blk->prev_next_info.le_next->sva)
  802481:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802484:	8b 00                	mov    (%eax),%eax
  802486:	85 c0                	test   %eax,%eax
  802488:	0f 84 96 00 00 00    	je     802524 <insert_sorted_allocList+0x1b3>
  80248e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802491:	8b 50 08             	mov    0x8(%eax),%edx
  802494:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802497:	8b 40 08             	mov    0x8(%eax),%eax
  80249a:	39 c2                	cmp    %eax,%edx
  80249c:	0f 86 82 00 00 00    	jbe    802524 <insert_sorted_allocList+0x1b3>
  8024a2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8024a5:	8b 50 08             	mov    0x8(%eax),%edx
  8024a8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024ab:	8b 00                	mov    (%eax),%eax
  8024ad:	8b 40 08             	mov    0x8(%eax),%eax
  8024b0:	39 c2                	cmp    %eax,%edx
  8024b2:	73 70                	jae    802524 <insert_sorted_allocList+0x1b3>
			{
				LIST_INSERT_AFTER(&AllocMemBlocksList, blk, newblk);
  8024b4:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8024b8:	74 06                	je     8024c0 <insert_sorted_allocList+0x14f>
  8024ba:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8024be:	75 17                	jne    8024d7 <insert_sorted_allocList+0x166>
  8024c0:	83 ec 04             	sub    $0x4,%esp
  8024c3:	68 d4 3d 80 00       	push   $0x803dd4
  8024c8:	68 87 00 00 00       	push   $0x87
  8024cd:	68 97 3d 80 00       	push   $0x803d97
  8024d2:	e8 e4 df ff ff       	call   8004bb <_panic>
  8024d7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024da:	8b 10                	mov    (%eax),%edx
  8024dc:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8024df:	89 10                	mov    %edx,(%eax)
  8024e1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8024e4:	8b 00                	mov    (%eax),%eax
  8024e6:	85 c0                	test   %eax,%eax
  8024e8:	74 0b                	je     8024f5 <insert_sorted_allocList+0x184>
  8024ea:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024ed:	8b 00                	mov    (%eax),%eax
  8024ef:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8024f2:	89 50 04             	mov    %edx,0x4(%eax)
  8024f5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024f8:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8024fb:	89 10                	mov    %edx,(%eax)
  8024fd:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802500:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802503:	89 50 04             	mov    %edx,0x4(%eax)
  802506:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802509:	8b 00                	mov    (%eax),%eax
  80250b:	85 c0                	test   %eax,%eax
  80250d:	75 08                	jne    802517 <insert_sorted_allocList+0x1a6>
  80250f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802512:	a3 44 40 80 00       	mov    %eax,0x804044
  802517:	a1 4c 40 80 00       	mov    0x80404c,%eax
  80251c:	40                   	inc    %eax
  80251d:	a3 4c 40 80 00       	mov    %eax,0x80404c
				break;
  802522:	eb 38                	jmp    80255c <insert_sorted_allocList+0x1eb>
	{
		LIST_INSERT_TAIL(&AllocMemBlocksList, newblk);
	}
	else
	{
		LIST_FOREACH(blk, &AllocMemBlocksList)
  802524:	a1 48 40 80 00       	mov    0x804048,%eax
  802529:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80252c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802530:	74 07                	je     802539 <insert_sorted_allocList+0x1c8>
  802532:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802535:	8b 00                	mov    (%eax),%eax
  802537:	eb 05                	jmp    80253e <insert_sorted_allocList+0x1cd>
  802539:	b8 00 00 00 00       	mov    $0x0,%eax
  80253e:	a3 48 40 80 00       	mov    %eax,0x804048
  802543:	a1 48 40 80 00       	mov    0x804048,%eax
  802548:	85 c0                	test   %eax,%eax
  80254a:	0f 85 31 ff ff ff    	jne    802481 <insert_sorted_allocList+0x110>
  802550:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802554:	0f 85 27 ff ff ff    	jne    802481 <insert_sorted_allocList+0x110>
				LIST_INSERT_AFTER(&AllocMemBlocksList, blk, newblk);
				break;
			}
		}
	}
}
  80255a:	eb 00                	jmp    80255c <insert_sorted_allocList+0x1eb>
  80255c:	90                   	nop
  80255d:	c9                   	leave  
  80255e:	c3                   	ret    

0080255f <alloc_block_FF>:

//=========================================
// [4] ALLOCATE BLOCK BY FIRST FIT:
//=========================================
struct MemBlock *alloc_block_FF(uint32 size)
{
  80255f:	55                   	push   %ebp
  802560:	89 e5                	mov    %esp,%ebp
  802562:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_FF
	// Write your code here, remove the panic and write your code
	//panic("alloc_block_FF() is not implemented yet...!!");
	uint32 versize = size;
  802565:	8b 45 08             	mov    0x8(%ebp),%eax
  802568:	89 45 f0             	mov    %eax,-0x10(%ebp)
	struct MemBlock* blk;
	struct MemBlock* newblk = LIST_FIRST(&AvailableMemBlocksList);
  80256b:	a1 48 41 80 00       	mov    0x804148,%eax
  802570:	89 45 ec             	mov    %eax,-0x14(%ebp)

	LIST_FOREACH(blk,&FreeMemBlocksList)
  802573:	a1 38 41 80 00       	mov    0x804138,%eax
  802578:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80257b:	e9 77 01 00 00       	jmp    8026f7 <alloc_block_FF+0x198>
	{
		if(blk->size == versize)
  802580:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802583:	8b 40 0c             	mov    0xc(%eax),%eax
  802586:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  802589:	0f 85 8a 00 00 00    	jne    802619 <alloc_block_FF+0xba>
		{
			LIST_REMOVE(&FreeMemBlocksList,blk);
  80258f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802593:	75 17                	jne    8025ac <alloc_block_FF+0x4d>
  802595:	83 ec 04             	sub    $0x4,%esp
  802598:	68 08 3e 80 00       	push   $0x803e08
  80259d:	68 9e 00 00 00       	push   $0x9e
  8025a2:	68 97 3d 80 00       	push   $0x803d97
  8025a7:	e8 0f df ff ff       	call   8004bb <_panic>
  8025ac:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025af:	8b 00                	mov    (%eax),%eax
  8025b1:	85 c0                	test   %eax,%eax
  8025b3:	74 10                	je     8025c5 <alloc_block_FF+0x66>
  8025b5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025b8:	8b 00                	mov    (%eax),%eax
  8025ba:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8025bd:	8b 52 04             	mov    0x4(%edx),%edx
  8025c0:	89 50 04             	mov    %edx,0x4(%eax)
  8025c3:	eb 0b                	jmp    8025d0 <alloc_block_FF+0x71>
  8025c5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025c8:	8b 40 04             	mov    0x4(%eax),%eax
  8025cb:	a3 3c 41 80 00       	mov    %eax,0x80413c
  8025d0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025d3:	8b 40 04             	mov    0x4(%eax),%eax
  8025d6:	85 c0                	test   %eax,%eax
  8025d8:	74 0f                	je     8025e9 <alloc_block_FF+0x8a>
  8025da:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025dd:	8b 40 04             	mov    0x4(%eax),%eax
  8025e0:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8025e3:	8b 12                	mov    (%edx),%edx
  8025e5:	89 10                	mov    %edx,(%eax)
  8025e7:	eb 0a                	jmp    8025f3 <alloc_block_FF+0x94>
  8025e9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025ec:	8b 00                	mov    (%eax),%eax
  8025ee:	a3 38 41 80 00       	mov    %eax,0x804138
  8025f3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025f6:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8025fc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025ff:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802606:	a1 44 41 80 00       	mov    0x804144,%eax
  80260b:	48                   	dec    %eax
  80260c:	a3 44 41 80 00       	mov    %eax,0x804144
			return blk;
  802611:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802614:	e9 11 01 00 00       	jmp    80272a <alloc_block_FF+0x1cb>
		}
		else if(blk->size > versize)
  802619:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80261c:	8b 40 0c             	mov    0xc(%eax),%eax
  80261f:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  802622:	0f 86 c7 00 00 00    	jbe    8026ef <alloc_block_FF+0x190>
		{
			LIST_REMOVE(&AvailableMemBlocksList,newblk);
  802628:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  80262c:	75 17                	jne    802645 <alloc_block_FF+0xe6>
  80262e:	83 ec 04             	sub    $0x4,%esp
  802631:	68 08 3e 80 00       	push   $0x803e08
  802636:	68 a3 00 00 00       	push   $0xa3
  80263b:	68 97 3d 80 00       	push   $0x803d97
  802640:	e8 76 de ff ff       	call   8004bb <_panic>
  802645:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802648:	8b 00                	mov    (%eax),%eax
  80264a:	85 c0                	test   %eax,%eax
  80264c:	74 10                	je     80265e <alloc_block_FF+0xff>
  80264e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802651:	8b 00                	mov    (%eax),%eax
  802653:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802656:	8b 52 04             	mov    0x4(%edx),%edx
  802659:	89 50 04             	mov    %edx,0x4(%eax)
  80265c:	eb 0b                	jmp    802669 <alloc_block_FF+0x10a>
  80265e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802661:	8b 40 04             	mov    0x4(%eax),%eax
  802664:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802669:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80266c:	8b 40 04             	mov    0x4(%eax),%eax
  80266f:	85 c0                	test   %eax,%eax
  802671:	74 0f                	je     802682 <alloc_block_FF+0x123>
  802673:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802676:	8b 40 04             	mov    0x4(%eax),%eax
  802679:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80267c:	8b 12                	mov    (%edx),%edx
  80267e:	89 10                	mov    %edx,(%eax)
  802680:	eb 0a                	jmp    80268c <alloc_block_FF+0x12d>
  802682:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802685:	8b 00                	mov    (%eax),%eax
  802687:	a3 48 41 80 00       	mov    %eax,0x804148
  80268c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80268f:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802695:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802698:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80269f:	a1 54 41 80 00       	mov    0x804154,%eax
  8026a4:	48                   	dec    %eax
  8026a5:	a3 54 41 80 00       	mov    %eax,0x804154
			newblk->size = versize;
  8026aa:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8026ad:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8026b0:	89 50 0c             	mov    %edx,0xc(%eax)
			blk->size = blk->size-versize;
  8026b3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026b6:	8b 40 0c             	mov    0xc(%eax),%eax
  8026b9:	2b 45 f0             	sub    -0x10(%ebp),%eax
  8026bc:	89 c2                	mov    %eax,%edx
  8026be:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026c1:	89 50 0c             	mov    %edx,0xc(%eax)
			uint32 newveradd = blk->sva;
  8026c4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026c7:	8b 40 08             	mov    0x8(%eax),%eax
  8026ca:	89 45 e8             	mov    %eax,-0x18(%ebp)
			blk->sva+=newblk->size;
  8026cd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026d0:	8b 50 08             	mov    0x8(%eax),%edx
  8026d3:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8026d6:	8b 40 0c             	mov    0xc(%eax),%eax
  8026d9:	01 c2                	add    %eax,%edx
  8026db:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026de:	89 50 08             	mov    %edx,0x8(%eax)
			newblk->sva = newveradd;
  8026e1:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8026e4:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8026e7:	89 50 08             	mov    %edx,0x8(%eax)
			return newblk;
  8026ea:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8026ed:	eb 3b                	jmp    80272a <alloc_block_FF+0x1cb>
	//panic("alloc_block_FF() is not implemented yet...!!");
	uint32 versize = size;
	struct MemBlock* blk;
	struct MemBlock* newblk = LIST_FIRST(&AvailableMemBlocksList);

	LIST_FOREACH(blk,&FreeMemBlocksList)
  8026ef:	a1 40 41 80 00       	mov    0x804140,%eax
  8026f4:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8026f7:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8026fb:	74 07                	je     802704 <alloc_block_FF+0x1a5>
  8026fd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802700:	8b 00                	mov    (%eax),%eax
  802702:	eb 05                	jmp    802709 <alloc_block_FF+0x1aa>
  802704:	b8 00 00 00 00       	mov    $0x0,%eax
  802709:	a3 40 41 80 00       	mov    %eax,0x804140
  80270e:	a1 40 41 80 00       	mov    0x804140,%eax
  802713:	85 c0                	test   %eax,%eax
  802715:	0f 85 65 fe ff ff    	jne    802580 <alloc_block_FF+0x21>
  80271b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80271f:	0f 85 5b fe ff ff    	jne    802580 <alloc_block_FF+0x21>
			blk->sva+=newblk->size;
			newblk->sva = newveradd;
			return newblk;
		}
	}
	return NULL;
  802725:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80272a:	c9                   	leave  
  80272b:	c3                   	ret    

0080272c <alloc_block_BF>:

//=========================================
// [5] ALLOCATE BLOCK BY BEST FIT:
//=========================================
struct MemBlock *alloc_block_BF(uint32 size)
{
  80272c:	55                   	push   %ebp
  80272d:	89 e5                	mov    %esp,%ebp
  80272f:	83 ec 28             	sub    $0x28,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_BF
	// Write your code here, remove the panic and write your code
	//panic("alloc_block_BF() is not implemented yet...!!");
	uint32 versize=size;
  802732:	8b 45 08             	mov    0x8(%ebp),%eax
  802735:	89 45 e8             	mov    %eax,-0x18(%ebp)
	struct MemBlock* blk;
	struct MemBlock* newblk=LIST_FIRST(&AvailableMemBlocksList);
  802738:	a1 48 41 80 00       	mov    0x804148,%eax
  80273d:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	uint32 newveradd;
	uint32 newsize;
	int size_free = LIST_SIZE(&FreeMemBlocksList);
  802740:	a1 44 41 80 00       	mov    0x804144,%eax
  802745:	89 45 e0             	mov    %eax,-0x20(%ebp)

	LIST_FOREACH(blk, &FreeMemBlocksList)
  802748:	a1 38 41 80 00       	mov    0x804138,%eax
  80274d:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802750:	e9 a1 00 00 00       	jmp    8027f6 <alloc_block_BF+0xca>
	{
		if(blk->size == versize)
  802755:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802758:	8b 40 0c             	mov    0xc(%eax),%eax
  80275b:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  80275e:	0f 85 8a 00 00 00    	jne    8027ee <alloc_block_BF+0xc2>
		{
			LIST_REMOVE(&FreeMemBlocksList, blk);
  802764:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802768:	75 17                	jne    802781 <alloc_block_BF+0x55>
  80276a:	83 ec 04             	sub    $0x4,%esp
  80276d:	68 08 3e 80 00       	push   $0x803e08
  802772:	68 c2 00 00 00       	push   $0xc2
  802777:	68 97 3d 80 00       	push   $0x803d97
  80277c:	e8 3a dd ff ff       	call   8004bb <_panic>
  802781:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802784:	8b 00                	mov    (%eax),%eax
  802786:	85 c0                	test   %eax,%eax
  802788:	74 10                	je     80279a <alloc_block_BF+0x6e>
  80278a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80278d:	8b 00                	mov    (%eax),%eax
  80278f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802792:	8b 52 04             	mov    0x4(%edx),%edx
  802795:	89 50 04             	mov    %edx,0x4(%eax)
  802798:	eb 0b                	jmp    8027a5 <alloc_block_BF+0x79>
  80279a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80279d:	8b 40 04             	mov    0x4(%eax),%eax
  8027a0:	a3 3c 41 80 00       	mov    %eax,0x80413c
  8027a5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027a8:	8b 40 04             	mov    0x4(%eax),%eax
  8027ab:	85 c0                	test   %eax,%eax
  8027ad:	74 0f                	je     8027be <alloc_block_BF+0x92>
  8027af:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027b2:	8b 40 04             	mov    0x4(%eax),%eax
  8027b5:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8027b8:	8b 12                	mov    (%edx),%edx
  8027ba:	89 10                	mov    %edx,(%eax)
  8027bc:	eb 0a                	jmp    8027c8 <alloc_block_BF+0x9c>
  8027be:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027c1:	8b 00                	mov    (%eax),%eax
  8027c3:	a3 38 41 80 00       	mov    %eax,0x804138
  8027c8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027cb:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8027d1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027d4:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8027db:	a1 44 41 80 00       	mov    0x804144,%eax
  8027e0:	48                   	dec    %eax
  8027e1:	a3 44 41 80 00       	mov    %eax,0x804144
			return blk;
  8027e6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027e9:	e9 11 02 00 00       	jmp    8029ff <alloc_block_BF+0x2d3>
	struct MemBlock* newblk=LIST_FIRST(&AvailableMemBlocksList);
	uint32 newveradd;
	uint32 newsize;
	int size_free = LIST_SIZE(&FreeMemBlocksList);

	LIST_FOREACH(blk, &FreeMemBlocksList)
  8027ee:	a1 40 41 80 00       	mov    0x804140,%eax
  8027f3:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8027f6:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8027fa:	74 07                	je     802803 <alloc_block_BF+0xd7>
  8027fc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027ff:	8b 00                	mov    (%eax),%eax
  802801:	eb 05                	jmp    802808 <alloc_block_BF+0xdc>
  802803:	b8 00 00 00 00       	mov    $0x0,%eax
  802808:	a3 40 41 80 00       	mov    %eax,0x804140
  80280d:	a1 40 41 80 00       	mov    0x804140,%eax
  802812:	85 c0                	test   %eax,%eax
  802814:	0f 85 3b ff ff ff    	jne    802755 <alloc_block_BF+0x29>
  80281a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80281e:	0f 85 31 ff ff ff    	jne    802755 <alloc_block_BF+0x29>
		{
			LIST_REMOVE(&FreeMemBlocksList, blk);
			return blk;
		}
	}
	LIST_FOREACH(blk, &FreeMemBlocksList)
  802824:	a1 38 41 80 00       	mov    0x804138,%eax
  802829:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80282c:	eb 27                	jmp    802855 <alloc_block_BF+0x129>
	{
		if(blk->size > versize)
  80282e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802831:	8b 40 0c             	mov    0xc(%eax),%eax
  802834:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  802837:	76 14                	jbe    80284d <alloc_block_BF+0x121>
		{
			newsize = blk->size;
  802839:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80283c:	8b 40 0c             	mov    0xc(%eax),%eax
  80283f:	89 45 ec             	mov    %eax,-0x14(%ebp)
			newveradd = blk->sva;
  802842:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802845:	8b 40 08             	mov    0x8(%eax),%eax
  802848:	89 45 f0             	mov    %eax,-0x10(%ebp)
			break;
  80284b:	eb 2e                	jmp    80287b <alloc_block_BF+0x14f>
		{
			LIST_REMOVE(&FreeMemBlocksList, blk);
			return blk;
		}
	}
	LIST_FOREACH(blk, &FreeMemBlocksList)
  80284d:	a1 40 41 80 00       	mov    0x804140,%eax
  802852:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802855:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802859:	74 07                	je     802862 <alloc_block_BF+0x136>
  80285b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80285e:	8b 00                	mov    (%eax),%eax
  802860:	eb 05                	jmp    802867 <alloc_block_BF+0x13b>
  802862:	b8 00 00 00 00       	mov    $0x0,%eax
  802867:	a3 40 41 80 00       	mov    %eax,0x804140
  80286c:	a1 40 41 80 00       	mov    0x804140,%eax
  802871:	85 c0                	test   %eax,%eax
  802873:	75 b9                	jne    80282e <alloc_block_BF+0x102>
  802875:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802879:	75 b3                	jne    80282e <alloc_block_BF+0x102>
			newsize = blk->size;
			newveradd = blk->sva;
			break;
		}
	}
	LIST_FOREACH(blk, &FreeMemBlocksList)
  80287b:	a1 38 41 80 00       	mov    0x804138,%eax
  802880:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802883:	eb 30                	jmp    8028b5 <alloc_block_BF+0x189>
	{
		if(newsize > blk->size && blk->size > versize)
  802885:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802888:	8b 40 0c             	mov    0xc(%eax),%eax
  80288b:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  80288e:	73 1d                	jae    8028ad <alloc_block_BF+0x181>
  802890:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802893:	8b 40 0c             	mov    0xc(%eax),%eax
  802896:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  802899:	76 12                	jbe    8028ad <alloc_block_BF+0x181>
		{
	       newsize = blk->size;
  80289b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80289e:	8b 40 0c             	mov    0xc(%eax),%eax
  8028a1:	89 45 ec             	mov    %eax,-0x14(%ebp)
		   newveradd = blk->sva;
  8028a4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028a7:	8b 40 08             	mov    0x8(%eax),%eax
  8028aa:	89 45 f0             	mov    %eax,-0x10(%ebp)
			newsize = blk->size;
			newveradd = blk->sva;
			break;
		}
	}
	LIST_FOREACH(blk, &FreeMemBlocksList)
  8028ad:	a1 40 41 80 00       	mov    0x804140,%eax
  8028b2:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8028b5:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8028b9:	74 07                	je     8028c2 <alloc_block_BF+0x196>
  8028bb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028be:	8b 00                	mov    (%eax),%eax
  8028c0:	eb 05                	jmp    8028c7 <alloc_block_BF+0x19b>
  8028c2:	b8 00 00 00 00       	mov    $0x0,%eax
  8028c7:	a3 40 41 80 00       	mov    %eax,0x804140
  8028cc:	a1 40 41 80 00       	mov    0x804140,%eax
  8028d1:	85 c0                	test   %eax,%eax
  8028d3:	75 b0                	jne    802885 <alloc_block_BF+0x159>
  8028d5:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8028d9:	75 aa                	jne    802885 <alloc_block_BF+0x159>
		{
	       newsize = blk->size;
		   newveradd = blk->sva;
		}
	}
	LIST_FOREACH(blk, &FreeMemBlocksList)
  8028db:	a1 38 41 80 00       	mov    0x804138,%eax
  8028e0:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8028e3:	e9 e4 00 00 00       	jmp    8029cc <alloc_block_BF+0x2a0>
	{
		if(blk->size == newsize && blk->sva == newveradd)
  8028e8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028eb:	8b 40 0c             	mov    0xc(%eax),%eax
  8028ee:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  8028f1:	0f 85 cd 00 00 00    	jne    8029c4 <alloc_block_BF+0x298>
  8028f7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028fa:	8b 40 08             	mov    0x8(%eax),%eax
  8028fd:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  802900:	0f 85 be 00 00 00    	jne    8029c4 <alloc_block_BF+0x298>
		{
			LIST_REMOVE(&AvailableMemBlocksList, newblk);
  802906:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80290a:	75 17                	jne    802923 <alloc_block_BF+0x1f7>
  80290c:	83 ec 04             	sub    $0x4,%esp
  80290f:	68 08 3e 80 00       	push   $0x803e08
  802914:	68 db 00 00 00       	push   $0xdb
  802919:	68 97 3d 80 00       	push   $0x803d97
  80291e:	e8 98 db ff ff       	call   8004bb <_panic>
  802923:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802926:	8b 00                	mov    (%eax),%eax
  802928:	85 c0                	test   %eax,%eax
  80292a:	74 10                	je     80293c <alloc_block_BF+0x210>
  80292c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80292f:	8b 00                	mov    (%eax),%eax
  802931:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802934:	8b 52 04             	mov    0x4(%edx),%edx
  802937:	89 50 04             	mov    %edx,0x4(%eax)
  80293a:	eb 0b                	jmp    802947 <alloc_block_BF+0x21b>
  80293c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80293f:	8b 40 04             	mov    0x4(%eax),%eax
  802942:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802947:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80294a:	8b 40 04             	mov    0x4(%eax),%eax
  80294d:	85 c0                	test   %eax,%eax
  80294f:	74 0f                	je     802960 <alloc_block_BF+0x234>
  802951:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802954:	8b 40 04             	mov    0x4(%eax),%eax
  802957:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80295a:	8b 12                	mov    (%edx),%edx
  80295c:	89 10                	mov    %edx,(%eax)
  80295e:	eb 0a                	jmp    80296a <alloc_block_BF+0x23e>
  802960:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802963:	8b 00                	mov    (%eax),%eax
  802965:	a3 48 41 80 00       	mov    %eax,0x804148
  80296a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80296d:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802973:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802976:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80297d:	a1 54 41 80 00       	mov    0x804154,%eax
  802982:	48                   	dec    %eax
  802983:	a3 54 41 80 00       	mov    %eax,0x804154
			newblk->size = versize;
  802988:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80298b:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80298e:	89 50 0c             	mov    %edx,0xc(%eax)
			newblk->sva = newveradd;
  802991:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802994:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802997:	89 50 08             	mov    %edx,0x8(%eax)
			blk->size = blk->size - versize;
  80299a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80299d:	8b 40 0c             	mov    0xc(%eax),%eax
  8029a0:	2b 45 e8             	sub    -0x18(%ebp),%eax
  8029a3:	89 c2                	mov    %eax,%edx
  8029a5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029a8:	89 50 0c             	mov    %edx,0xc(%eax)
			blk->sva+= newblk->size;
  8029ab:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029ae:	8b 50 08             	mov    0x8(%eax),%edx
  8029b1:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8029b4:	8b 40 0c             	mov    0xc(%eax),%eax
  8029b7:	01 c2                	add    %eax,%edx
  8029b9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029bc:	89 50 08             	mov    %edx,0x8(%eax)
			return newblk;
  8029bf:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8029c2:	eb 3b                	jmp    8029ff <alloc_block_BF+0x2d3>
		{
	       newsize = blk->size;
		   newveradd = blk->sva;
		}
	}
	LIST_FOREACH(blk, &FreeMemBlocksList)
  8029c4:	a1 40 41 80 00       	mov    0x804140,%eax
  8029c9:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8029cc:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8029d0:	74 07                	je     8029d9 <alloc_block_BF+0x2ad>
  8029d2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029d5:	8b 00                	mov    (%eax),%eax
  8029d7:	eb 05                	jmp    8029de <alloc_block_BF+0x2b2>
  8029d9:	b8 00 00 00 00       	mov    $0x0,%eax
  8029de:	a3 40 41 80 00       	mov    %eax,0x804140
  8029e3:	a1 40 41 80 00       	mov    0x804140,%eax
  8029e8:	85 c0                	test   %eax,%eax
  8029ea:	0f 85 f8 fe ff ff    	jne    8028e8 <alloc_block_BF+0x1bc>
  8029f0:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8029f4:	0f 85 ee fe ff ff    	jne    8028e8 <alloc_block_BF+0x1bc>
			blk->size = blk->size - versize;
			blk->sva+= newblk->size;
			return newblk;
		}
	}
	return NULL;
  8029fa:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8029ff:	c9                   	leave  
  802a00:	c3                   	ret    

00802a01 <alloc_block_NF>:
//=========================================
// [7] ALLOCATE BLOCK BY NEXT FIT:
//=========================================
struct MemBlock *last_allocate;
struct MemBlock *alloc_block_NF(uint32 size)
{
  802a01:	55                   	push   %ebp
  802a02:	89 e5                	mov    %esp,%ebp
  802a04:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1 - BONUS] [DYNAMIC ALLOCATOR] alloc_block_NF
	// Write your code here, remove the panic and write your code
	//panic("alloc_block_NF() is not implemented yet...!!");
	uint32 versize = size;
  802a07:	8b 45 08             	mov    0x8(%ebp),%eax
  802a0a:	89 45 f0             	mov    %eax,-0x10(%ebp)
	struct MemBlock* blk;
	struct MemBlock* newblk = LIST_FIRST(&AvailableMemBlocksList);
  802a0d:	a1 48 41 80 00       	mov    0x804148,%eax
  802a12:	89 45 ec             	mov    %eax,-0x14(%ebp)

	LIST_FOREACH(blk,&FreeMemBlocksList)
  802a15:	a1 38 41 80 00       	mov    0x804138,%eax
  802a1a:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802a1d:	e9 77 01 00 00       	jmp    802b99 <alloc_block_NF+0x198>
	{
		if(blk->size == versize)
  802a22:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a25:	8b 40 0c             	mov    0xc(%eax),%eax
  802a28:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  802a2b:	0f 85 8a 00 00 00    	jne    802abb <alloc_block_NF+0xba>
		{
			LIST_REMOVE(&FreeMemBlocksList,blk);
  802a31:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802a35:	75 17                	jne    802a4e <alloc_block_NF+0x4d>
  802a37:	83 ec 04             	sub    $0x4,%esp
  802a3a:	68 08 3e 80 00       	push   $0x803e08
  802a3f:	68 f7 00 00 00       	push   $0xf7
  802a44:	68 97 3d 80 00       	push   $0x803d97
  802a49:	e8 6d da ff ff       	call   8004bb <_panic>
  802a4e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a51:	8b 00                	mov    (%eax),%eax
  802a53:	85 c0                	test   %eax,%eax
  802a55:	74 10                	je     802a67 <alloc_block_NF+0x66>
  802a57:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a5a:	8b 00                	mov    (%eax),%eax
  802a5c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802a5f:	8b 52 04             	mov    0x4(%edx),%edx
  802a62:	89 50 04             	mov    %edx,0x4(%eax)
  802a65:	eb 0b                	jmp    802a72 <alloc_block_NF+0x71>
  802a67:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a6a:	8b 40 04             	mov    0x4(%eax),%eax
  802a6d:	a3 3c 41 80 00       	mov    %eax,0x80413c
  802a72:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a75:	8b 40 04             	mov    0x4(%eax),%eax
  802a78:	85 c0                	test   %eax,%eax
  802a7a:	74 0f                	je     802a8b <alloc_block_NF+0x8a>
  802a7c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a7f:	8b 40 04             	mov    0x4(%eax),%eax
  802a82:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802a85:	8b 12                	mov    (%edx),%edx
  802a87:	89 10                	mov    %edx,(%eax)
  802a89:	eb 0a                	jmp    802a95 <alloc_block_NF+0x94>
  802a8b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a8e:	8b 00                	mov    (%eax),%eax
  802a90:	a3 38 41 80 00       	mov    %eax,0x804138
  802a95:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a98:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802a9e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802aa1:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802aa8:	a1 44 41 80 00       	mov    0x804144,%eax
  802aad:	48                   	dec    %eax
  802aae:	a3 44 41 80 00       	mov    %eax,0x804144
			return blk;
  802ab3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ab6:	e9 11 01 00 00       	jmp    802bcc <alloc_block_NF+0x1cb>
		}
		else if(blk->size > versize)
  802abb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802abe:	8b 40 0c             	mov    0xc(%eax),%eax
  802ac1:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  802ac4:	0f 86 c7 00 00 00    	jbe    802b91 <alloc_block_NF+0x190>
		{
			LIST_REMOVE(&AvailableMemBlocksList,newblk);
  802aca:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802ace:	75 17                	jne    802ae7 <alloc_block_NF+0xe6>
  802ad0:	83 ec 04             	sub    $0x4,%esp
  802ad3:	68 08 3e 80 00       	push   $0x803e08
  802ad8:	68 fc 00 00 00       	push   $0xfc
  802add:	68 97 3d 80 00       	push   $0x803d97
  802ae2:	e8 d4 d9 ff ff       	call   8004bb <_panic>
  802ae7:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802aea:	8b 00                	mov    (%eax),%eax
  802aec:	85 c0                	test   %eax,%eax
  802aee:	74 10                	je     802b00 <alloc_block_NF+0xff>
  802af0:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802af3:	8b 00                	mov    (%eax),%eax
  802af5:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802af8:	8b 52 04             	mov    0x4(%edx),%edx
  802afb:	89 50 04             	mov    %edx,0x4(%eax)
  802afe:	eb 0b                	jmp    802b0b <alloc_block_NF+0x10a>
  802b00:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802b03:	8b 40 04             	mov    0x4(%eax),%eax
  802b06:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802b0b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802b0e:	8b 40 04             	mov    0x4(%eax),%eax
  802b11:	85 c0                	test   %eax,%eax
  802b13:	74 0f                	je     802b24 <alloc_block_NF+0x123>
  802b15:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802b18:	8b 40 04             	mov    0x4(%eax),%eax
  802b1b:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802b1e:	8b 12                	mov    (%edx),%edx
  802b20:	89 10                	mov    %edx,(%eax)
  802b22:	eb 0a                	jmp    802b2e <alloc_block_NF+0x12d>
  802b24:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802b27:	8b 00                	mov    (%eax),%eax
  802b29:	a3 48 41 80 00       	mov    %eax,0x804148
  802b2e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802b31:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802b37:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802b3a:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802b41:	a1 54 41 80 00       	mov    0x804154,%eax
  802b46:	48                   	dec    %eax
  802b47:	a3 54 41 80 00       	mov    %eax,0x804154
			newblk->size = versize;
  802b4c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802b4f:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802b52:	89 50 0c             	mov    %edx,0xc(%eax)
			blk->size = blk->size-versize;
  802b55:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b58:	8b 40 0c             	mov    0xc(%eax),%eax
  802b5b:	2b 45 f0             	sub    -0x10(%ebp),%eax
  802b5e:	89 c2                	mov    %eax,%edx
  802b60:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b63:	89 50 0c             	mov    %edx,0xc(%eax)
			uint32 newveradd = blk->sva;
  802b66:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b69:	8b 40 08             	mov    0x8(%eax),%eax
  802b6c:	89 45 e8             	mov    %eax,-0x18(%ebp)
			blk->sva+=newblk->size;
  802b6f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b72:	8b 50 08             	mov    0x8(%eax),%edx
  802b75:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802b78:	8b 40 0c             	mov    0xc(%eax),%eax
  802b7b:	01 c2                	add    %eax,%edx
  802b7d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b80:	89 50 08             	mov    %edx,0x8(%eax)
			newblk->sva = newveradd;
  802b83:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802b86:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802b89:	89 50 08             	mov    %edx,0x8(%eax)
			return newblk;
  802b8c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802b8f:	eb 3b                	jmp    802bcc <alloc_block_NF+0x1cb>
	//panic("alloc_block_NF() is not implemented yet...!!");
	uint32 versize = size;
	struct MemBlock* blk;
	struct MemBlock* newblk = LIST_FIRST(&AvailableMemBlocksList);

	LIST_FOREACH(blk,&FreeMemBlocksList)
  802b91:	a1 40 41 80 00       	mov    0x804140,%eax
  802b96:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802b99:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802b9d:	74 07                	je     802ba6 <alloc_block_NF+0x1a5>
  802b9f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ba2:	8b 00                	mov    (%eax),%eax
  802ba4:	eb 05                	jmp    802bab <alloc_block_NF+0x1aa>
  802ba6:	b8 00 00 00 00       	mov    $0x0,%eax
  802bab:	a3 40 41 80 00       	mov    %eax,0x804140
  802bb0:	a1 40 41 80 00       	mov    0x804140,%eax
  802bb5:	85 c0                	test   %eax,%eax
  802bb7:	0f 85 65 fe ff ff    	jne    802a22 <alloc_block_NF+0x21>
  802bbd:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802bc1:	0f 85 5b fe ff ff    	jne    802a22 <alloc_block_NF+0x21>
			blk->sva+=newblk->size;
			newblk->sva = newveradd;
			return newblk;
		}
	}
	return NULL;
  802bc7:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802bcc:	c9                   	leave  
  802bcd:	c3                   	ret    

00802bce <addToAvailMemBlocksList>:

//===================================================
// [8] INSERT BLOCK (SORTED WITH MERGE) IN FREE LIST:
//===================================================
void addToAvailMemBlocksList(struct MemBlock *blockToInsert)
{
  802bce:	55                   	push   %ebp
  802bcf:	89 e5                	mov    %esp,%ebp
  802bd1:	83 ec 08             	sub    $0x8,%esp
	blockToInsert->sva = 0;
  802bd4:	8b 45 08             	mov    0x8(%ebp),%eax
  802bd7:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
	blockToInsert->size = 0;
  802bde:	8b 45 08             	mov    0x8(%ebp),%eax
  802be1:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
	//add to avail
	LIST_INSERT_TAIL(&AvailableMemBlocksList, blockToInsert);
  802be8:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802bec:	75 17                	jne    802c05 <addToAvailMemBlocksList+0x37>
  802bee:	83 ec 04             	sub    $0x4,%esp
  802bf1:	68 b0 3d 80 00       	push   $0x803db0
  802bf6:	68 10 01 00 00       	push   $0x110
  802bfb:	68 97 3d 80 00       	push   $0x803d97
  802c00:	e8 b6 d8 ff ff       	call   8004bb <_panic>
  802c05:	8b 15 4c 41 80 00    	mov    0x80414c,%edx
  802c0b:	8b 45 08             	mov    0x8(%ebp),%eax
  802c0e:	89 50 04             	mov    %edx,0x4(%eax)
  802c11:	8b 45 08             	mov    0x8(%ebp),%eax
  802c14:	8b 40 04             	mov    0x4(%eax),%eax
  802c17:	85 c0                	test   %eax,%eax
  802c19:	74 0c                	je     802c27 <addToAvailMemBlocksList+0x59>
  802c1b:	a1 4c 41 80 00       	mov    0x80414c,%eax
  802c20:	8b 55 08             	mov    0x8(%ebp),%edx
  802c23:	89 10                	mov    %edx,(%eax)
  802c25:	eb 08                	jmp    802c2f <addToAvailMemBlocksList+0x61>
  802c27:	8b 45 08             	mov    0x8(%ebp),%eax
  802c2a:	a3 48 41 80 00       	mov    %eax,0x804148
  802c2f:	8b 45 08             	mov    0x8(%ebp),%eax
  802c32:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802c37:	8b 45 08             	mov    0x8(%ebp),%eax
  802c3a:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802c40:	a1 54 41 80 00       	mov    0x804154,%eax
  802c45:	40                   	inc    %eax
  802c46:	a3 54 41 80 00       	mov    %eax,0x804154
}
  802c4b:	90                   	nop
  802c4c:	c9                   	leave  
  802c4d:	c3                   	ret    

00802c4e <insert_sorted_with_merge_freeList>:
void insert_sorted_with_merge_freeList(struct MemBlock *blockToInsert)
{
  802c4e:	55                   	push   %ebp
  802c4f:	89 e5                	mov    %esp,%ebp
  802c51:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] insert_sorted_with_merge_freeList
	// Write your code here, remove the panic and write your code

	struct MemBlock* last = LIST_LAST(&FreeMemBlocksList);
  802c54:	a1 3c 41 80 00       	mov    0x80413c,%eax
  802c59:	89 45 f0             	mov    %eax,-0x10(%ebp)
	//check if list empty
	if (LIST_SIZE(&(FreeMemBlocksList)) == 0)
  802c5c:	a1 44 41 80 00       	mov    0x804144,%eax
  802c61:	85 c0                	test   %eax,%eax
  802c63:	75 68                	jne    802ccd <insert_sorted_with_merge_freeList+0x7f>
		LIST_INSERT_HEAD(&FreeMemBlocksList, blockToInsert);
  802c65:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802c69:	75 17                	jne    802c82 <insert_sorted_with_merge_freeList+0x34>
  802c6b:	83 ec 04             	sub    $0x4,%esp
  802c6e:	68 74 3d 80 00       	push   $0x803d74
  802c73:	68 1a 01 00 00       	push   $0x11a
  802c78:	68 97 3d 80 00       	push   $0x803d97
  802c7d:	e8 39 d8 ff ff       	call   8004bb <_panic>
  802c82:	8b 15 38 41 80 00    	mov    0x804138,%edx
  802c88:	8b 45 08             	mov    0x8(%ebp),%eax
  802c8b:	89 10                	mov    %edx,(%eax)
  802c8d:	8b 45 08             	mov    0x8(%ebp),%eax
  802c90:	8b 00                	mov    (%eax),%eax
  802c92:	85 c0                	test   %eax,%eax
  802c94:	74 0d                	je     802ca3 <insert_sorted_with_merge_freeList+0x55>
  802c96:	a1 38 41 80 00       	mov    0x804138,%eax
  802c9b:	8b 55 08             	mov    0x8(%ebp),%edx
  802c9e:	89 50 04             	mov    %edx,0x4(%eax)
  802ca1:	eb 08                	jmp    802cab <insert_sorted_with_merge_freeList+0x5d>
  802ca3:	8b 45 08             	mov    0x8(%ebp),%eax
  802ca6:	a3 3c 41 80 00       	mov    %eax,0x80413c
  802cab:	8b 45 08             	mov    0x8(%ebp),%eax
  802cae:	a3 38 41 80 00       	mov    %eax,0x804138
  802cb3:	8b 45 08             	mov    0x8(%ebp),%eax
  802cb6:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802cbd:	a1 44 41 80 00       	mov    0x804144,%eax
  802cc2:	40                   	inc    %eax
  802cc3:	a3 44 41 80 00       	mov    %eax,0x804144
		}
	}

	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  802cc8:	e9 c5 03 00 00       	jmp    803092 <insert_sorted_with_merge_freeList+0x444>
	struct MemBlock* last = LIST_LAST(&FreeMemBlocksList);
	//check if list empty
	if (LIST_SIZE(&(FreeMemBlocksList)) == 0)
		LIST_INSERT_HEAD(&FreeMemBlocksList, blockToInsert);
	//check if it's position is at last
	else if (last->sva < blockToInsert->sva) {
  802ccd:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802cd0:	8b 50 08             	mov    0x8(%eax),%edx
  802cd3:	8b 45 08             	mov    0x8(%ebp),%eax
  802cd6:	8b 40 08             	mov    0x8(%eax),%eax
  802cd9:	39 c2                	cmp    %eax,%edx
  802cdb:	0f 83 b2 00 00 00    	jae    802d93 <insert_sorted_with_merge_freeList+0x145>

		//if i have to merge
		if (last->sva + last->size == blockToInsert->sva) {
  802ce1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802ce4:	8b 50 08             	mov    0x8(%eax),%edx
  802ce7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802cea:	8b 40 0c             	mov    0xc(%eax),%eax
  802ced:	01 c2                	add    %eax,%edx
  802cef:	8b 45 08             	mov    0x8(%ebp),%eax
  802cf2:	8b 40 08             	mov    0x8(%eax),%eax
  802cf5:	39 c2                	cmp    %eax,%edx
  802cf7:	75 27                	jne    802d20 <insert_sorted_with_merge_freeList+0xd2>
			last->size = last->size + blockToInsert->size;
  802cf9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802cfc:	8b 50 0c             	mov    0xc(%eax),%edx
  802cff:	8b 45 08             	mov    0x8(%ebp),%eax
  802d02:	8b 40 0c             	mov    0xc(%eax),%eax
  802d05:	01 c2                	add    %eax,%edx
  802d07:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d0a:	89 50 0c             	mov    %edx,0xc(%eax)
			addToAvailMemBlocksList(blockToInsert);
  802d0d:	83 ec 0c             	sub    $0xc,%esp
  802d10:	ff 75 08             	pushl  0x8(%ebp)
  802d13:	e8 b6 fe ff ff       	call   802bce <addToAvailMemBlocksList>
  802d18:	83 c4 10             	add    $0x10,%esp
		}
	}

	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  802d1b:	e9 72 03 00 00       	jmp    803092 <insert_sorted_with_merge_freeList+0x444>
		if (last->sva + last->size == blockToInsert->sva) {
			last->size = last->size + blockToInsert->size;
			addToAvailMemBlocksList(blockToInsert);

		} else {
			LIST_INSERT_AFTER(&FreeMemBlocksList, last, blockToInsert);
  802d20:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802d24:	74 06                	je     802d2c <insert_sorted_with_merge_freeList+0xde>
  802d26:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802d2a:	75 17                	jne    802d43 <insert_sorted_with_merge_freeList+0xf5>
  802d2c:	83 ec 04             	sub    $0x4,%esp
  802d2f:	68 d4 3d 80 00       	push   $0x803dd4
  802d34:	68 24 01 00 00       	push   $0x124
  802d39:	68 97 3d 80 00       	push   $0x803d97
  802d3e:	e8 78 d7 ff ff       	call   8004bb <_panic>
  802d43:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d46:	8b 10                	mov    (%eax),%edx
  802d48:	8b 45 08             	mov    0x8(%ebp),%eax
  802d4b:	89 10                	mov    %edx,(%eax)
  802d4d:	8b 45 08             	mov    0x8(%ebp),%eax
  802d50:	8b 00                	mov    (%eax),%eax
  802d52:	85 c0                	test   %eax,%eax
  802d54:	74 0b                	je     802d61 <insert_sorted_with_merge_freeList+0x113>
  802d56:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d59:	8b 00                	mov    (%eax),%eax
  802d5b:	8b 55 08             	mov    0x8(%ebp),%edx
  802d5e:	89 50 04             	mov    %edx,0x4(%eax)
  802d61:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d64:	8b 55 08             	mov    0x8(%ebp),%edx
  802d67:	89 10                	mov    %edx,(%eax)
  802d69:	8b 45 08             	mov    0x8(%ebp),%eax
  802d6c:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802d6f:	89 50 04             	mov    %edx,0x4(%eax)
  802d72:	8b 45 08             	mov    0x8(%ebp),%eax
  802d75:	8b 00                	mov    (%eax),%eax
  802d77:	85 c0                	test   %eax,%eax
  802d79:	75 08                	jne    802d83 <insert_sorted_with_merge_freeList+0x135>
  802d7b:	8b 45 08             	mov    0x8(%ebp),%eax
  802d7e:	a3 3c 41 80 00       	mov    %eax,0x80413c
  802d83:	a1 44 41 80 00       	mov    0x804144,%eax
  802d88:	40                   	inc    %eax
  802d89:	a3 44 41 80 00       	mov    %eax,0x804144
		}
	}

	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  802d8e:	e9 ff 02 00 00       	jmp    803092 <insert_sorted_with_merge_freeList+0x444>
		} else {
			LIST_INSERT_AFTER(&FreeMemBlocksList, last, blockToInsert);
		}
	} else {
		struct MemBlock *iterator;
		LIST_FOREACH(iterator, &(FreeMemBlocksList))
  802d93:	a1 38 41 80 00       	mov    0x804138,%eax
  802d98:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802d9b:	e9 c2 02 00 00       	jmp    803062 <insert_sorted_with_merge_freeList+0x414>
		{

			if (iterator->sva > blockToInsert->sva) {
  802da0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802da3:	8b 50 08             	mov    0x8(%eax),%edx
  802da6:	8b 45 08             	mov    0x8(%ebp),%eax
  802da9:	8b 40 08             	mov    0x8(%eax),%eax
  802dac:	39 c2                	cmp    %eax,%edx
  802dae:	0f 86 a6 02 00 00    	jbe    80305a <insert_sorted_with_merge_freeList+0x40c>

				struct MemBlock* prev = LIST_PREV(iterator);
  802db4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802db7:	8b 40 04             	mov    0x4(%eax),%eax
  802dba:	89 45 ec             	mov    %eax,-0x14(%ebp)
				if (prev == NULL) {
  802dbd:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802dc1:	0f 85 ba 00 00 00    	jne    802e81 <insert_sorted_with_merge_freeList+0x233>
					//check merge
					if (blockToInsert->size + blockToInsert->sva
  802dc7:	8b 45 08             	mov    0x8(%ebp),%eax
  802dca:	8b 50 0c             	mov    0xc(%eax),%edx
  802dcd:	8b 45 08             	mov    0x8(%ebp),%eax
  802dd0:	8b 40 08             	mov    0x8(%eax),%eax
  802dd3:	01 c2                	add    %eax,%edx
							== iterator->sva) {
  802dd5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802dd8:	8b 40 08             	mov    0x8(%eax),%eax
			if (iterator->sva > blockToInsert->sva) {

				struct MemBlock* prev = LIST_PREV(iterator);
				if (prev == NULL) {
					//check merge
					if (blockToInsert->size + blockToInsert->sva
  802ddb:	39 c2                	cmp    %eax,%edx
  802ddd:	75 33                	jne    802e12 <insert_sorted_with_merge_freeList+0x1c4>
							== iterator->sva) {
						iterator->sva = blockToInsert->sva;
  802ddf:	8b 45 08             	mov    0x8(%ebp),%eax
  802de2:	8b 50 08             	mov    0x8(%eax),%edx
  802de5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802de8:	89 50 08             	mov    %edx,0x8(%eax)
						iterator->size = iterator->size + blockToInsert->size;
  802deb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802dee:	8b 50 0c             	mov    0xc(%eax),%edx
  802df1:	8b 45 08             	mov    0x8(%ebp),%eax
  802df4:	8b 40 0c             	mov    0xc(%eax),%eax
  802df7:	01 c2                	add    %eax,%edx
  802df9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802dfc:	89 50 0c             	mov    %edx,0xc(%eax)
						addToAvailMemBlocksList(blockToInsert);
  802dff:	83 ec 0c             	sub    $0xc,%esp
  802e02:	ff 75 08             	pushl  0x8(%ebp)
  802e05:	e8 c4 fd ff ff       	call   802bce <addToAvailMemBlocksList>
  802e0a:	83 c4 10             	add    $0x10,%esp

					else {
						LIST_INSERT_BEFORE(&FreeMemBlocksList, iterator,
								blockToInsert);
					}
					break;
  802e0d:	e9 80 02 00 00       	jmp    803092 <insert_sorted_with_merge_freeList+0x444>
						addToAvailMemBlocksList(blockToInsert);

					}

					else {
						LIST_INSERT_BEFORE(&FreeMemBlocksList, iterator,
  802e12:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802e16:	74 06                	je     802e1e <insert_sorted_with_merge_freeList+0x1d0>
  802e18:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802e1c:	75 17                	jne    802e35 <insert_sorted_with_merge_freeList+0x1e7>
  802e1e:	83 ec 04             	sub    $0x4,%esp
  802e21:	68 28 3e 80 00       	push   $0x803e28
  802e26:	68 3a 01 00 00       	push   $0x13a
  802e2b:	68 97 3d 80 00       	push   $0x803d97
  802e30:	e8 86 d6 ff ff       	call   8004bb <_panic>
  802e35:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e38:	8b 50 04             	mov    0x4(%eax),%edx
  802e3b:	8b 45 08             	mov    0x8(%ebp),%eax
  802e3e:	89 50 04             	mov    %edx,0x4(%eax)
  802e41:	8b 45 08             	mov    0x8(%ebp),%eax
  802e44:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802e47:	89 10                	mov    %edx,(%eax)
  802e49:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e4c:	8b 40 04             	mov    0x4(%eax),%eax
  802e4f:	85 c0                	test   %eax,%eax
  802e51:	74 0d                	je     802e60 <insert_sorted_with_merge_freeList+0x212>
  802e53:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e56:	8b 40 04             	mov    0x4(%eax),%eax
  802e59:	8b 55 08             	mov    0x8(%ebp),%edx
  802e5c:	89 10                	mov    %edx,(%eax)
  802e5e:	eb 08                	jmp    802e68 <insert_sorted_with_merge_freeList+0x21a>
  802e60:	8b 45 08             	mov    0x8(%ebp),%eax
  802e63:	a3 38 41 80 00       	mov    %eax,0x804138
  802e68:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e6b:	8b 55 08             	mov    0x8(%ebp),%edx
  802e6e:	89 50 04             	mov    %edx,0x4(%eax)
  802e71:	a1 44 41 80 00       	mov    0x804144,%eax
  802e76:	40                   	inc    %eax
  802e77:	a3 44 41 80 00       	mov    %eax,0x804144
								blockToInsert);
					}
					break;
  802e7c:	e9 11 02 00 00       	jmp    803092 <insert_sorted_with_merge_freeList+0x444>
				} else {
					//prev and next merge
					if (prev->sva + prev->size + blockToInsert->size
  802e81:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802e84:	8b 50 08             	mov    0x8(%eax),%edx
  802e87:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802e8a:	8b 40 0c             	mov    0xc(%eax),%eax
  802e8d:	01 c2                	add    %eax,%edx
  802e8f:	8b 45 08             	mov    0x8(%ebp),%eax
  802e92:	8b 40 0c             	mov    0xc(%eax),%eax
  802e95:	01 c2                	add    %eax,%edx
							== iterator->sva) {
  802e97:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e9a:	8b 40 08             	mov    0x8(%eax),%eax
								blockToInsert);
					}
					break;
				} else {
					//prev and next merge
					if (prev->sva + prev->size + blockToInsert->size
  802e9d:	39 c2                	cmp    %eax,%edx
  802e9f:	0f 85 bf 00 00 00    	jne    802f64 <insert_sorted_with_merge_freeList+0x316>
							== iterator->sva) {
						prev->size = prev->size + blockToInsert->size
  802ea5:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802ea8:	8b 50 0c             	mov    0xc(%eax),%edx
  802eab:	8b 45 08             	mov    0x8(%ebp),%eax
  802eae:	8b 40 0c             	mov    0xc(%eax),%eax
  802eb1:	01 c2                	add    %eax,%edx
								+ iterator->size;
  802eb3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802eb6:	8b 40 0c             	mov    0xc(%eax),%eax
  802eb9:	01 c2                	add    %eax,%edx
					break;
				} else {
					//prev and next merge
					if (prev->sva + prev->size + blockToInsert->size
							== iterator->sva) {
						prev->size = prev->size + blockToInsert->size
  802ebb:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802ebe:	89 50 0c             	mov    %edx,0xc(%eax)
								+ iterator->size;
						LIST_REMOVE(&FreeMemBlocksList, iterator);
  802ec1:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802ec5:	75 17                	jne    802ede <insert_sorted_with_merge_freeList+0x290>
  802ec7:	83 ec 04             	sub    $0x4,%esp
  802eca:	68 08 3e 80 00       	push   $0x803e08
  802ecf:	68 43 01 00 00       	push   $0x143
  802ed4:	68 97 3d 80 00       	push   $0x803d97
  802ed9:	e8 dd d5 ff ff       	call   8004bb <_panic>
  802ede:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ee1:	8b 00                	mov    (%eax),%eax
  802ee3:	85 c0                	test   %eax,%eax
  802ee5:	74 10                	je     802ef7 <insert_sorted_with_merge_freeList+0x2a9>
  802ee7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802eea:	8b 00                	mov    (%eax),%eax
  802eec:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802eef:	8b 52 04             	mov    0x4(%edx),%edx
  802ef2:	89 50 04             	mov    %edx,0x4(%eax)
  802ef5:	eb 0b                	jmp    802f02 <insert_sorted_with_merge_freeList+0x2b4>
  802ef7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802efa:	8b 40 04             	mov    0x4(%eax),%eax
  802efd:	a3 3c 41 80 00       	mov    %eax,0x80413c
  802f02:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f05:	8b 40 04             	mov    0x4(%eax),%eax
  802f08:	85 c0                	test   %eax,%eax
  802f0a:	74 0f                	je     802f1b <insert_sorted_with_merge_freeList+0x2cd>
  802f0c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f0f:	8b 40 04             	mov    0x4(%eax),%eax
  802f12:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802f15:	8b 12                	mov    (%edx),%edx
  802f17:	89 10                	mov    %edx,(%eax)
  802f19:	eb 0a                	jmp    802f25 <insert_sorted_with_merge_freeList+0x2d7>
  802f1b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f1e:	8b 00                	mov    (%eax),%eax
  802f20:	a3 38 41 80 00       	mov    %eax,0x804138
  802f25:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f28:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802f2e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f31:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802f38:	a1 44 41 80 00       	mov    0x804144,%eax
  802f3d:	48                   	dec    %eax
  802f3e:	a3 44 41 80 00       	mov    %eax,0x804144
						addToAvailMemBlocksList(blockToInsert);
  802f43:	83 ec 0c             	sub    $0xc,%esp
  802f46:	ff 75 08             	pushl  0x8(%ebp)
  802f49:	e8 80 fc ff ff       	call   802bce <addToAvailMemBlocksList>
  802f4e:	83 c4 10             	add    $0x10,%esp
						addToAvailMemBlocksList(iterator);
  802f51:	83 ec 0c             	sub    $0xc,%esp
  802f54:	ff 75 f4             	pushl  -0xc(%ebp)
  802f57:	e8 72 fc ff ff       	call   802bce <addToAvailMemBlocksList>
  802f5c:	83 c4 10             	add    $0x10,%esp
					//Insert
					else {
						LIST_INSERT_BEFORE(&FreeMemBlocksList, iterator,
								blockToInsert);
					}
					break;
  802f5f:	e9 2e 01 00 00       	jmp    803092 <insert_sorted_with_merge_freeList+0x444>
						LIST_REMOVE(&FreeMemBlocksList, iterator);
						addToAvailMemBlocksList(blockToInsert);
						addToAvailMemBlocksList(iterator);
					}
					//previous merge
					else if (prev->sva + prev->size == blockToInsert->sva) {
  802f64:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802f67:	8b 50 08             	mov    0x8(%eax),%edx
  802f6a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802f6d:	8b 40 0c             	mov    0xc(%eax),%eax
  802f70:	01 c2                	add    %eax,%edx
  802f72:	8b 45 08             	mov    0x8(%ebp),%eax
  802f75:	8b 40 08             	mov    0x8(%eax),%eax
  802f78:	39 c2                	cmp    %eax,%edx
  802f7a:	75 27                	jne    802fa3 <insert_sorted_with_merge_freeList+0x355>
						prev->size = prev->size + blockToInsert->size;
  802f7c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802f7f:	8b 50 0c             	mov    0xc(%eax),%edx
  802f82:	8b 45 08             	mov    0x8(%ebp),%eax
  802f85:	8b 40 0c             	mov    0xc(%eax),%eax
  802f88:	01 c2                	add    %eax,%edx
  802f8a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802f8d:	89 50 0c             	mov    %edx,0xc(%eax)
						addToAvailMemBlocksList(blockToInsert);
  802f90:	83 ec 0c             	sub    $0xc,%esp
  802f93:	ff 75 08             	pushl  0x8(%ebp)
  802f96:	e8 33 fc ff ff       	call   802bce <addToAvailMemBlocksList>
  802f9b:	83 c4 10             	add    $0x10,%esp
					//Insert
					else {
						LIST_INSERT_BEFORE(&FreeMemBlocksList, iterator,
								blockToInsert);
					}
					break;
  802f9e:	e9 ef 00 00 00       	jmp    803092 <insert_sorted_with_merge_freeList+0x444>
					else if (prev->sva + prev->size == blockToInsert->sva) {
						prev->size = prev->size + blockToInsert->size;
						addToAvailMemBlocksList(blockToInsert);
					}
					//next merge
					else if (blockToInsert->size + blockToInsert->sva
  802fa3:	8b 45 08             	mov    0x8(%ebp),%eax
  802fa6:	8b 50 0c             	mov    0xc(%eax),%edx
  802fa9:	8b 45 08             	mov    0x8(%ebp),%eax
  802fac:	8b 40 08             	mov    0x8(%eax),%eax
  802faf:	01 c2                	add    %eax,%edx
							== iterator->sva) {
  802fb1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802fb4:	8b 40 08             	mov    0x8(%eax),%eax
					else if (prev->sva + prev->size == blockToInsert->sva) {
						prev->size = prev->size + blockToInsert->size;
						addToAvailMemBlocksList(blockToInsert);
					}
					//next merge
					else if (blockToInsert->size + blockToInsert->sva
  802fb7:	39 c2                	cmp    %eax,%edx
  802fb9:	75 33                	jne    802fee <insert_sorted_with_merge_freeList+0x3a0>
							== iterator->sva) {
						iterator->sva = blockToInsert->sva;
  802fbb:	8b 45 08             	mov    0x8(%ebp),%eax
  802fbe:	8b 50 08             	mov    0x8(%eax),%edx
  802fc1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802fc4:	89 50 08             	mov    %edx,0x8(%eax)
						iterator->size = iterator->size + blockToInsert->size;
  802fc7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802fca:	8b 50 0c             	mov    0xc(%eax),%edx
  802fcd:	8b 45 08             	mov    0x8(%ebp),%eax
  802fd0:	8b 40 0c             	mov    0xc(%eax),%eax
  802fd3:	01 c2                	add    %eax,%edx
  802fd5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802fd8:	89 50 0c             	mov    %edx,0xc(%eax)
						addToAvailMemBlocksList(blockToInsert);
  802fdb:	83 ec 0c             	sub    $0xc,%esp
  802fde:	ff 75 08             	pushl  0x8(%ebp)
  802fe1:	e8 e8 fb ff ff       	call   802bce <addToAvailMemBlocksList>
  802fe6:	83 c4 10             	add    $0x10,%esp
					//Insert
					else {
						LIST_INSERT_BEFORE(&FreeMemBlocksList, iterator,
								blockToInsert);
					}
					break;
  802fe9:	e9 a4 00 00 00       	jmp    803092 <insert_sorted_with_merge_freeList+0x444>
						iterator->size = iterator->size + blockToInsert->size;
						addToAvailMemBlocksList(blockToInsert);
					}
					//Insert
					else {
						LIST_INSERT_BEFORE(&FreeMemBlocksList, iterator,
  802fee:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802ff2:	74 06                	je     802ffa <insert_sorted_with_merge_freeList+0x3ac>
  802ff4:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802ff8:	75 17                	jne    803011 <insert_sorted_with_merge_freeList+0x3c3>
  802ffa:	83 ec 04             	sub    $0x4,%esp
  802ffd:	68 28 3e 80 00       	push   $0x803e28
  803002:	68 56 01 00 00       	push   $0x156
  803007:	68 97 3d 80 00       	push   $0x803d97
  80300c:	e8 aa d4 ff ff       	call   8004bb <_panic>
  803011:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803014:	8b 50 04             	mov    0x4(%eax),%edx
  803017:	8b 45 08             	mov    0x8(%ebp),%eax
  80301a:	89 50 04             	mov    %edx,0x4(%eax)
  80301d:	8b 45 08             	mov    0x8(%ebp),%eax
  803020:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803023:	89 10                	mov    %edx,(%eax)
  803025:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803028:	8b 40 04             	mov    0x4(%eax),%eax
  80302b:	85 c0                	test   %eax,%eax
  80302d:	74 0d                	je     80303c <insert_sorted_with_merge_freeList+0x3ee>
  80302f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803032:	8b 40 04             	mov    0x4(%eax),%eax
  803035:	8b 55 08             	mov    0x8(%ebp),%edx
  803038:	89 10                	mov    %edx,(%eax)
  80303a:	eb 08                	jmp    803044 <insert_sorted_with_merge_freeList+0x3f6>
  80303c:	8b 45 08             	mov    0x8(%ebp),%eax
  80303f:	a3 38 41 80 00       	mov    %eax,0x804138
  803044:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803047:	8b 55 08             	mov    0x8(%ebp),%edx
  80304a:	89 50 04             	mov    %edx,0x4(%eax)
  80304d:	a1 44 41 80 00       	mov    0x804144,%eax
  803052:	40                   	inc    %eax
  803053:	a3 44 41 80 00       	mov    %eax,0x804144
								blockToInsert);
					}
					break;
  803058:	eb 38                	jmp    803092 <insert_sorted_with_merge_freeList+0x444>
		} else {
			LIST_INSERT_AFTER(&FreeMemBlocksList, last, blockToInsert);
		}
	} else {
		struct MemBlock *iterator;
		LIST_FOREACH(iterator, &(FreeMemBlocksList))
  80305a:	a1 40 41 80 00       	mov    0x804140,%eax
  80305f:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803062:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803066:	74 07                	je     80306f <insert_sorted_with_merge_freeList+0x421>
  803068:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80306b:	8b 00                	mov    (%eax),%eax
  80306d:	eb 05                	jmp    803074 <insert_sorted_with_merge_freeList+0x426>
  80306f:	b8 00 00 00 00       	mov    $0x0,%eax
  803074:	a3 40 41 80 00       	mov    %eax,0x804140
  803079:	a1 40 41 80 00       	mov    0x804140,%eax
  80307e:	85 c0                	test   %eax,%eax
  803080:	0f 85 1a fd ff ff    	jne    802da0 <insert_sorted_with_merge_freeList+0x152>
  803086:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80308a:	0f 85 10 fd ff ff    	jne    802da0 <insert_sorted_with_merge_freeList+0x152>
		}
	}

	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  803090:	eb 00                	jmp    803092 <insert_sorted_with_merge_freeList+0x444>
  803092:	90                   	nop
  803093:	c9                   	leave  
  803094:	c3                   	ret    

00803095 <env_sleep>:
#include <inc/lib.h>
#include <inc/timerreg.h>

void
env_sleep(uint32 approxMilliSeconds)
{
  803095:	55                   	push   %ebp
  803096:	89 e5                	mov    %esp,%ebp
  803098:	83 ec 28             	sub    $0x28,%esp
//	cprintf("%s go to sleep...\n", myEnv->prog_name);
	uint32 time_in_cycles=approxMilliSeconds*CYCLES_PER_MILLISEC;
  80309b:	8b 55 08             	mov    0x8(%ebp),%edx
  80309e:	89 d0                	mov    %edx,%eax
  8030a0:	c1 e0 02             	shl    $0x2,%eax
  8030a3:	01 d0                	add    %edx,%eax
  8030a5:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8030ac:	01 d0                	add    %edx,%eax
  8030ae:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8030b5:	01 d0                	add    %edx,%eax
  8030b7:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8030be:	01 d0                	add    %edx,%eax
  8030c0:	c1 e0 04             	shl    $0x4,%eax
  8030c3:	89 45 f0             	mov    %eax,-0x10(%ebp)
	uint32 cycles_counter =0;
  8030c6:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	struct uint64 baseTime = sys_get_virtual_time() ;
  8030cd:	8d 45 e8             	lea    -0x18(%ebp),%eax
  8030d0:	83 ec 0c             	sub    $0xc,%esp
  8030d3:	50                   	push   %eax
  8030d4:	e8 60 ed ff ff       	call   801e39 <sys_get_virtual_time>
  8030d9:	83 c4 0c             	add    $0xc,%esp
	while(cycles_counter<time_in_cycles)
  8030dc:	eb 41                	jmp    80311f <env_sleep+0x8a>
	{
		struct uint64 currentTime = sys_get_virtual_time() ;
  8030de:	8d 45 e0             	lea    -0x20(%ebp),%eax
  8030e1:	83 ec 0c             	sub    $0xc,%esp
  8030e4:	50                   	push   %eax
  8030e5:	e8 4f ed ff ff       	call   801e39 <sys_get_virtual_time>
  8030ea:	83 c4 0c             	add    $0xc,%esp

		// update the cycles_count
		#define M32 0xffffffff
		// subtract basetime from current time
		struct uint64 res;
		res.low = (currentTime.low - baseTime.low) & M32;
  8030ed:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8030f0:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8030f3:	29 c2                	sub    %eax,%edx
  8030f5:	89 d0                	mov    %edx,%eax
  8030f7:	89 45 d8             	mov    %eax,-0x28(%ebp)
		res.hi = (currentTime.hi - baseTime.hi - (res.low > currentTime.low)) & M32;
  8030fa:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8030fd:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803100:	89 d1                	mov    %edx,%ecx
  803102:	29 c1                	sub    %eax,%ecx
  803104:	8b 55 d8             	mov    -0x28(%ebp),%edx
  803107:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80310a:	39 c2                	cmp    %eax,%edx
  80310c:	0f 97 c0             	seta   %al
  80310f:	0f b6 c0             	movzbl %al,%eax
  803112:	29 c1                	sub    %eax,%ecx
  803114:	89 c8                	mov    %ecx,%eax
  803116:	89 45 dc             	mov    %eax,-0x24(%ebp)

		//update cycles_count with result
		cycles_counter = res.low;
  803119:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80311c:	89 45 f4             	mov    %eax,-0xc(%ebp)
//	cprintf("%s go to sleep...\n", myEnv->prog_name);
	uint32 time_in_cycles=approxMilliSeconds*CYCLES_PER_MILLISEC;
	uint32 cycles_counter =0;

	struct uint64 baseTime = sys_get_virtual_time() ;
	while(cycles_counter<time_in_cycles)
  80311f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803122:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  803125:	72 b7                	jb     8030de <env_sleep+0x49>
//				,cycles_counter
//				);
	}
	//cprintf("%s [%d] wake up now!\n", myEnv->prog_name, myEnv->env_id);

}
  803127:	90                   	nop
  803128:	c9                   	leave  
  803129:	c3                   	ret    

0080312a <busy_wait>:

//2017
uint32 busy_wait(uint32 loopMax)
{
  80312a:	55                   	push   %ebp
  80312b:	89 e5                	mov    %esp,%ebp
  80312d:	83 ec 10             	sub    $0x10,%esp
	uint32 i = 0 ;
  803130:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	while (i < loopMax) i++;
  803137:	eb 03                	jmp    80313c <busy_wait+0x12>
  803139:	ff 45 fc             	incl   -0x4(%ebp)
  80313c:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80313f:	3b 45 08             	cmp    0x8(%ebp),%eax
  803142:	72 f5                	jb     803139 <busy_wait+0xf>
	return i;
  803144:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  803147:	c9                   	leave  
  803148:	c3                   	ret    
  803149:	66 90                	xchg   %ax,%ax
  80314b:	90                   	nop

0080314c <__udivdi3>:
  80314c:	55                   	push   %ebp
  80314d:	57                   	push   %edi
  80314e:	56                   	push   %esi
  80314f:	53                   	push   %ebx
  803150:	83 ec 1c             	sub    $0x1c,%esp
  803153:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  803157:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  80315b:	8b 7c 24 38          	mov    0x38(%esp),%edi
  80315f:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  803163:	89 ca                	mov    %ecx,%edx
  803165:	89 f8                	mov    %edi,%eax
  803167:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  80316b:	85 f6                	test   %esi,%esi
  80316d:	75 2d                	jne    80319c <__udivdi3+0x50>
  80316f:	39 cf                	cmp    %ecx,%edi
  803171:	77 65                	ja     8031d8 <__udivdi3+0x8c>
  803173:	89 fd                	mov    %edi,%ebp
  803175:	85 ff                	test   %edi,%edi
  803177:	75 0b                	jne    803184 <__udivdi3+0x38>
  803179:	b8 01 00 00 00       	mov    $0x1,%eax
  80317e:	31 d2                	xor    %edx,%edx
  803180:	f7 f7                	div    %edi
  803182:	89 c5                	mov    %eax,%ebp
  803184:	31 d2                	xor    %edx,%edx
  803186:	89 c8                	mov    %ecx,%eax
  803188:	f7 f5                	div    %ebp
  80318a:	89 c1                	mov    %eax,%ecx
  80318c:	89 d8                	mov    %ebx,%eax
  80318e:	f7 f5                	div    %ebp
  803190:	89 cf                	mov    %ecx,%edi
  803192:	89 fa                	mov    %edi,%edx
  803194:	83 c4 1c             	add    $0x1c,%esp
  803197:	5b                   	pop    %ebx
  803198:	5e                   	pop    %esi
  803199:	5f                   	pop    %edi
  80319a:	5d                   	pop    %ebp
  80319b:	c3                   	ret    
  80319c:	39 ce                	cmp    %ecx,%esi
  80319e:	77 28                	ja     8031c8 <__udivdi3+0x7c>
  8031a0:	0f bd fe             	bsr    %esi,%edi
  8031a3:	83 f7 1f             	xor    $0x1f,%edi
  8031a6:	75 40                	jne    8031e8 <__udivdi3+0x9c>
  8031a8:	39 ce                	cmp    %ecx,%esi
  8031aa:	72 0a                	jb     8031b6 <__udivdi3+0x6a>
  8031ac:	3b 44 24 08          	cmp    0x8(%esp),%eax
  8031b0:	0f 87 9e 00 00 00    	ja     803254 <__udivdi3+0x108>
  8031b6:	b8 01 00 00 00       	mov    $0x1,%eax
  8031bb:	89 fa                	mov    %edi,%edx
  8031bd:	83 c4 1c             	add    $0x1c,%esp
  8031c0:	5b                   	pop    %ebx
  8031c1:	5e                   	pop    %esi
  8031c2:	5f                   	pop    %edi
  8031c3:	5d                   	pop    %ebp
  8031c4:	c3                   	ret    
  8031c5:	8d 76 00             	lea    0x0(%esi),%esi
  8031c8:	31 ff                	xor    %edi,%edi
  8031ca:	31 c0                	xor    %eax,%eax
  8031cc:	89 fa                	mov    %edi,%edx
  8031ce:	83 c4 1c             	add    $0x1c,%esp
  8031d1:	5b                   	pop    %ebx
  8031d2:	5e                   	pop    %esi
  8031d3:	5f                   	pop    %edi
  8031d4:	5d                   	pop    %ebp
  8031d5:	c3                   	ret    
  8031d6:	66 90                	xchg   %ax,%ax
  8031d8:	89 d8                	mov    %ebx,%eax
  8031da:	f7 f7                	div    %edi
  8031dc:	31 ff                	xor    %edi,%edi
  8031de:	89 fa                	mov    %edi,%edx
  8031e0:	83 c4 1c             	add    $0x1c,%esp
  8031e3:	5b                   	pop    %ebx
  8031e4:	5e                   	pop    %esi
  8031e5:	5f                   	pop    %edi
  8031e6:	5d                   	pop    %ebp
  8031e7:	c3                   	ret    
  8031e8:	bd 20 00 00 00       	mov    $0x20,%ebp
  8031ed:	89 eb                	mov    %ebp,%ebx
  8031ef:	29 fb                	sub    %edi,%ebx
  8031f1:	89 f9                	mov    %edi,%ecx
  8031f3:	d3 e6                	shl    %cl,%esi
  8031f5:	89 c5                	mov    %eax,%ebp
  8031f7:	88 d9                	mov    %bl,%cl
  8031f9:	d3 ed                	shr    %cl,%ebp
  8031fb:	89 e9                	mov    %ebp,%ecx
  8031fd:	09 f1                	or     %esi,%ecx
  8031ff:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  803203:	89 f9                	mov    %edi,%ecx
  803205:	d3 e0                	shl    %cl,%eax
  803207:	89 c5                	mov    %eax,%ebp
  803209:	89 d6                	mov    %edx,%esi
  80320b:	88 d9                	mov    %bl,%cl
  80320d:	d3 ee                	shr    %cl,%esi
  80320f:	89 f9                	mov    %edi,%ecx
  803211:	d3 e2                	shl    %cl,%edx
  803213:	8b 44 24 08          	mov    0x8(%esp),%eax
  803217:	88 d9                	mov    %bl,%cl
  803219:	d3 e8                	shr    %cl,%eax
  80321b:	09 c2                	or     %eax,%edx
  80321d:	89 d0                	mov    %edx,%eax
  80321f:	89 f2                	mov    %esi,%edx
  803221:	f7 74 24 0c          	divl   0xc(%esp)
  803225:	89 d6                	mov    %edx,%esi
  803227:	89 c3                	mov    %eax,%ebx
  803229:	f7 e5                	mul    %ebp
  80322b:	39 d6                	cmp    %edx,%esi
  80322d:	72 19                	jb     803248 <__udivdi3+0xfc>
  80322f:	74 0b                	je     80323c <__udivdi3+0xf0>
  803231:	89 d8                	mov    %ebx,%eax
  803233:	31 ff                	xor    %edi,%edi
  803235:	e9 58 ff ff ff       	jmp    803192 <__udivdi3+0x46>
  80323a:	66 90                	xchg   %ax,%ax
  80323c:	8b 54 24 08          	mov    0x8(%esp),%edx
  803240:	89 f9                	mov    %edi,%ecx
  803242:	d3 e2                	shl    %cl,%edx
  803244:	39 c2                	cmp    %eax,%edx
  803246:	73 e9                	jae    803231 <__udivdi3+0xe5>
  803248:	8d 43 ff             	lea    -0x1(%ebx),%eax
  80324b:	31 ff                	xor    %edi,%edi
  80324d:	e9 40 ff ff ff       	jmp    803192 <__udivdi3+0x46>
  803252:	66 90                	xchg   %ax,%ax
  803254:	31 c0                	xor    %eax,%eax
  803256:	e9 37 ff ff ff       	jmp    803192 <__udivdi3+0x46>
  80325b:	90                   	nop

0080325c <__umoddi3>:
  80325c:	55                   	push   %ebp
  80325d:	57                   	push   %edi
  80325e:	56                   	push   %esi
  80325f:	53                   	push   %ebx
  803260:	83 ec 1c             	sub    $0x1c,%esp
  803263:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  803267:	8b 74 24 34          	mov    0x34(%esp),%esi
  80326b:	8b 7c 24 38          	mov    0x38(%esp),%edi
  80326f:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  803273:	89 44 24 0c          	mov    %eax,0xc(%esp)
  803277:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  80327b:	89 f3                	mov    %esi,%ebx
  80327d:	89 fa                	mov    %edi,%edx
  80327f:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  803283:	89 34 24             	mov    %esi,(%esp)
  803286:	85 c0                	test   %eax,%eax
  803288:	75 1a                	jne    8032a4 <__umoddi3+0x48>
  80328a:	39 f7                	cmp    %esi,%edi
  80328c:	0f 86 a2 00 00 00    	jbe    803334 <__umoddi3+0xd8>
  803292:	89 c8                	mov    %ecx,%eax
  803294:	89 f2                	mov    %esi,%edx
  803296:	f7 f7                	div    %edi
  803298:	89 d0                	mov    %edx,%eax
  80329a:	31 d2                	xor    %edx,%edx
  80329c:	83 c4 1c             	add    $0x1c,%esp
  80329f:	5b                   	pop    %ebx
  8032a0:	5e                   	pop    %esi
  8032a1:	5f                   	pop    %edi
  8032a2:	5d                   	pop    %ebp
  8032a3:	c3                   	ret    
  8032a4:	39 f0                	cmp    %esi,%eax
  8032a6:	0f 87 ac 00 00 00    	ja     803358 <__umoddi3+0xfc>
  8032ac:	0f bd e8             	bsr    %eax,%ebp
  8032af:	83 f5 1f             	xor    $0x1f,%ebp
  8032b2:	0f 84 ac 00 00 00    	je     803364 <__umoddi3+0x108>
  8032b8:	bf 20 00 00 00       	mov    $0x20,%edi
  8032bd:	29 ef                	sub    %ebp,%edi
  8032bf:	89 fe                	mov    %edi,%esi
  8032c1:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  8032c5:	89 e9                	mov    %ebp,%ecx
  8032c7:	d3 e0                	shl    %cl,%eax
  8032c9:	89 d7                	mov    %edx,%edi
  8032cb:	89 f1                	mov    %esi,%ecx
  8032cd:	d3 ef                	shr    %cl,%edi
  8032cf:	09 c7                	or     %eax,%edi
  8032d1:	89 e9                	mov    %ebp,%ecx
  8032d3:	d3 e2                	shl    %cl,%edx
  8032d5:	89 14 24             	mov    %edx,(%esp)
  8032d8:	89 d8                	mov    %ebx,%eax
  8032da:	d3 e0                	shl    %cl,%eax
  8032dc:	89 c2                	mov    %eax,%edx
  8032de:	8b 44 24 08          	mov    0x8(%esp),%eax
  8032e2:	d3 e0                	shl    %cl,%eax
  8032e4:	89 44 24 04          	mov    %eax,0x4(%esp)
  8032e8:	8b 44 24 08          	mov    0x8(%esp),%eax
  8032ec:	89 f1                	mov    %esi,%ecx
  8032ee:	d3 e8                	shr    %cl,%eax
  8032f0:	09 d0                	or     %edx,%eax
  8032f2:	d3 eb                	shr    %cl,%ebx
  8032f4:	89 da                	mov    %ebx,%edx
  8032f6:	f7 f7                	div    %edi
  8032f8:	89 d3                	mov    %edx,%ebx
  8032fa:	f7 24 24             	mull   (%esp)
  8032fd:	89 c6                	mov    %eax,%esi
  8032ff:	89 d1                	mov    %edx,%ecx
  803301:	39 d3                	cmp    %edx,%ebx
  803303:	0f 82 87 00 00 00    	jb     803390 <__umoddi3+0x134>
  803309:	0f 84 91 00 00 00    	je     8033a0 <__umoddi3+0x144>
  80330f:	8b 54 24 04          	mov    0x4(%esp),%edx
  803313:	29 f2                	sub    %esi,%edx
  803315:	19 cb                	sbb    %ecx,%ebx
  803317:	89 d8                	mov    %ebx,%eax
  803319:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  80331d:	d3 e0                	shl    %cl,%eax
  80331f:	89 e9                	mov    %ebp,%ecx
  803321:	d3 ea                	shr    %cl,%edx
  803323:	09 d0                	or     %edx,%eax
  803325:	89 e9                	mov    %ebp,%ecx
  803327:	d3 eb                	shr    %cl,%ebx
  803329:	89 da                	mov    %ebx,%edx
  80332b:	83 c4 1c             	add    $0x1c,%esp
  80332e:	5b                   	pop    %ebx
  80332f:	5e                   	pop    %esi
  803330:	5f                   	pop    %edi
  803331:	5d                   	pop    %ebp
  803332:	c3                   	ret    
  803333:	90                   	nop
  803334:	89 fd                	mov    %edi,%ebp
  803336:	85 ff                	test   %edi,%edi
  803338:	75 0b                	jne    803345 <__umoddi3+0xe9>
  80333a:	b8 01 00 00 00       	mov    $0x1,%eax
  80333f:	31 d2                	xor    %edx,%edx
  803341:	f7 f7                	div    %edi
  803343:	89 c5                	mov    %eax,%ebp
  803345:	89 f0                	mov    %esi,%eax
  803347:	31 d2                	xor    %edx,%edx
  803349:	f7 f5                	div    %ebp
  80334b:	89 c8                	mov    %ecx,%eax
  80334d:	f7 f5                	div    %ebp
  80334f:	89 d0                	mov    %edx,%eax
  803351:	e9 44 ff ff ff       	jmp    80329a <__umoddi3+0x3e>
  803356:	66 90                	xchg   %ax,%ax
  803358:	89 c8                	mov    %ecx,%eax
  80335a:	89 f2                	mov    %esi,%edx
  80335c:	83 c4 1c             	add    $0x1c,%esp
  80335f:	5b                   	pop    %ebx
  803360:	5e                   	pop    %esi
  803361:	5f                   	pop    %edi
  803362:	5d                   	pop    %ebp
  803363:	c3                   	ret    
  803364:	3b 04 24             	cmp    (%esp),%eax
  803367:	72 06                	jb     80336f <__umoddi3+0x113>
  803369:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  80336d:	77 0f                	ja     80337e <__umoddi3+0x122>
  80336f:	89 f2                	mov    %esi,%edx
  803371:	29 f9                	sub    %edi,%ecx
  803373:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  803377:	89 14 24             	mov    %edx,(%esp)
  80337a:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  80337e:	8b 44 24 04          	mov    0x4(%esp),%eax
  803382:	8b 14 24             	mov    (%esp),%edx
  803385:	83 c4 1c             	add    $0x1c,%esp
  803388:	5b                   	pop    %ebx
  803389:	5e                   	pop    %esi
  80338a:	5f                   	pop    %edi
  80338b:	5d                   	pop    %ebp
  80338c:	c3                   	ret    
  80338d:	8d 76 00             	lea    0x0(%esi),%esi
  803390:	2b 04 24             	sub    (%esp),%eax
  803393:	19 fa                	sbb    %edi,%edx
  803395:	89 d1                	mov    %edx,%ecx
  803397:	89 c6                	mov    %eax,%esi
  803399:	e9 71 ff ff ff       	jmp    80330f <__umoddi3+0xb3>
  80339e:	66 90                	xchg   %ax,%ax
  8033a0:	39 44 24 04          	cmp    %eax,0x4(%esp)
  8033a4:	72 ea                	jb     803390 <__umoddi3+0x134>
  8033a6:	89 d9                	mov    %ebx,%ecx
  8033a8:	e9 62 ff ff ff       	jmp    80330f <__umoddi3+0xb3>
