
obj/user/tst_sharing_2master:     file format elf32-i386


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
  800031:	e8 35 03 00 00       	call   80036b <libmain>
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
  80008d:	68 a0 33 80 00       	push   $0x8033a0
  800092:	6a 13                	push   $0x13
  800094:	68 bc 33 80 00       	push   $0x8033bc
  800099:	e8 09 04 00 00       	call   8004a7 <_panic>
	}
	/*Dummy malloc to enforce the UHEAP initializations*/
	malloc(0);
  80009e:	83 ec 0c             	sub    $0xc,%esp
  8000a1:	6a 00                	push   $0x0
  8000a3:	e8 45 16 00 00       	call   8016ed <malloc>
  8000a8:	83 c4 10             	add    $0x10,%esp
	/*=================================================*/

	uint32 *x, *y, *z ;

	//x: Readonly
	int freeFrames = sys_calculate_free_frames() ;
  8000ab:	e8 49 1a 00 00       	call   801af9 <sys_calculate_free_frames>
  8000b0:	89 45 ec             	mov    %eax,-0x14(%ebp)
	x = smalloc("x", 4, 0);
  8000b3:	83 ec 04             	sub    $0x4,%esp
  8000b6:	6a 00                	push   $0x0
  8000b8:	6a 04                	push   $0x4
  8000ba:	68 d7 33 80 00       	push   $0x8033d7
  8000bf:	e8 71 17 00 00       	call   801835 <smalloc>
  8000c4:	83 c4 10             	add    $0x10,%esp
  8000c7:	89 45 e8             	mov    %eax,-0x18(%ebp)
	if (x != (uint32*)USER_HEAP_START) panic("Create(): Returned address is not correct. make sure that you align the allocation on 4KB boundary");
  8000ca:	81 7d e8 00 00 00 80 	cmpl   $0x80000000,-0x18(%ebp)
  8000d1:	74 14                	je     8000e7 <_main+0xaf>
  8000d3:	83 ec 04             	sub    $0x4,%esp
  8000d6:	68 dc 33 80 00       	push   $0x8033dc
  8000db:	6a 1e                	push   $0x1e
  8000dd:	68 bc 33 80 00       	push   $0x8033bc
  8000e2:	e8 c0 03 00 00       	call   8004a7 <_panic>
	if ((freeFrames - sys_calculate_free_frames()) !=  1+1+2) panic("Create(): Wrong allocation- make sure that you allocate the required space in the user environment and add its frames to frames_storage");
  8000e7:	8b 5d ec             	mov    -0x14(%ebp),%ebx
  8000ea:	e8 0a 1a 00 00       	call   801af9 <sys_calculate_free_frames>
  8000ef:	29 c3                	sub    %eax,%ebx
  8000f1:	89 d8                	mov    %ebx,%eax
  8000f3:	83 f8 04             	cmp    $0x4,%eax
  8000f6:	74 14                	je     80010c <_main+0xd4>
  8000f8:	83 ec 04             	sub    $0x4,%esp
  8000fb:	68 40 34 80 00       	push   $0x803440
  800100:	6a 1f                	push   $0x1f
  800102:	68 bc 33 80 00       	push   $0x8033bc
  800107:	e8 9b 03 00 00       	call   8004a7 <_panic>

	//y: Readonly
	freeFrames = sys_calculate_free_frames() ;
  80010c:	e8 e8 19 00 00       	call   801af9 <sys_calculate_free_frames>
  800111:	89 45 ec             	mov    %eax,-0x14(%ebp)
	y = smalloc("y", 4, 0);
  800114:	83 ec 04             	sub    $0x4,%esp
  800117:	6a 00                	push   $0x0
  800119:	6a 04                	push   $0x4
  80011b:	68 c8 34 80 00       	push   $0x8034c8
  800120:	e8 10 17 00 00       	call   801835 <smalloc>
  800125:	83 c4 10             	add    $0x10,%esp
  800128:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	if (y != (uint32*)(USER_HEAP_START + 1 * PAGE_SIZE)) panic("Create(): Returned address is not correct. make sure that you align the allocation on 4KB boundary");
  80012b:	81 7d e4 00 10 00 80 	cmpl   $0x80001000,-0x1c(%ebp)
  800132:	74 14                	je     800148 <_main+0x110>
  800134:	83 ec 04             	sub    $0x4,%esp
  800137:	68 dc 33 80 00       	push   $0x8033dc
  80013c:	6a 24                	push   $0x24
  80013e:	68 bc 33 80 00       	push   $0x8033bc
  800143:	e8 5f 03 00 00       	call   8004a7 <_panic>
	if ((freeFrames - sys_calculate_free_frames()) !=  1+0+2) panic("Create(): Wrong allocation- make sure that you allocate the required space in the user environment and add its frames to frames_storage");
  800148:	8b 5d ec             	mov    -0x14(%ebp),%ebx
  80014b:	e8 a9 19 00 00       	call   801af9 <sys_calculate_free_frames>
  800150:	29 c3                	sub    %eax,%ebx
  800152:	89 d8                	mov    %ebx,%eax
  800154:	83 f8 03             	cmp    $0x3,%eax
  800157:	74 14                	je     80016d <_main+0x135>
  800159:	83 ec 04             	sub    $0x4,%esp
  80015c:	68 40 34 80 00       	push   $0x803440
  800161:	6a 25                	push   $0x25
  800163:	68 bc 33 80 00       	push   $0x8033bc
  800168:	e8 3a 03 00 00       	call   8004a7 <_panic>

	//z: Writable
	freeFrames = sys_calculate_free_frames() ;
  80016d:	e8 87 19 00 00       	call   801af9 <sys_calculate_free_frames>
  800172:	89 45 ec             	mov    %eax,-0x14(%ebp)
	z = smalloc("z", 4, 1);
  800175:	83 ec 04             	sub    $0x4,%esp
  800178:	6a 01                	push   $0x1
  80017a:	6a 04                	push   $0x4
  80017c:	68 ca 34 80 00       	push   $0x8034ca
  800181:	e8 af 16 00 00       	call   801835 <smalloc>
  800186:	83 c4 10             	add    $0x10,%esp
  800189:	89 45 e0             	mov    %eax,-0x20(%ebp)
	if (z != (uint32*)(USER_HEAP_START + 2 * PAGE_SIZE)) panic("Create(): Returned address is not correct. make sure that you align the allocation on 4KB boundary");
  80018c:	81 7d e0 00 20 00 80 	cmpl   $0x80002000,-0x20(%ebp)
  800193:	74 14                	je     8001a9 <_main+0x171>
  800195:	83 ec 04             	sub    $0x4,%esp
  800198:	68 dc 33 80 00       	push   $0x8033dc
  80019d:	6a 2a                	push   $0x2a
  80019f:	68 bc 33 80 00       	push   $0x8033bc
  8001a4:	e8 fe 02 00 00       	call   8004a7 <_panic>
	if ((freeFrames - sys_calculate_free_frames()) !=  1+0+2) panic("Create(): Wrong allocation- make sure that you allocate the required space in the user environment and add its frames to frames_storage");
  8001a9:	8b 5d ec             	mov    -0x14(%ebp),%ebx
  8001ac:	e8 48 19 00 00       	call   801af9 <sys_calculate_free_frames>
  8001b1:	29 c3                	sub    %eax,%ebx
  8001b3:	89 d8                	mov    %ebx,%eax
  8001b5:	83 f8 03             	cmp    $0x3,%eax
  8001b8:	74 14                	je     8001ce <_main+0x196>
  8001ba:	83 ec 04             	sub    $0x4,%esp
  8001bd:	68 40 34 80 00       	push   $0x803440
  8001c2:	6a 2b                	push   $0x2b
  8001c4:	68 bc 33 80 00       	push   $0x8033bc
  8001c9:	e8 d9 02 00 00       	call   8004a7 <_panic>

	*x = 10 ;
  8001ce:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8001d1:	c7 00 0a 00 00 00    	movl   $0xa,(%eax)
	*y = 20 ;
  8001d7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8001da:	c7 00 14 00 00 00    	movl   $0x14,(%eax)

	int id1, id2, id3;
	id1 = sys_create_env("shr2Slave1", (myEnv->page_WS_max_size),(myEnv->SecondListSize), (myEnv->percentage_of_WS_pages_to_be_removed));
  8001e0:	a1 20 40 80 00       	mov    0x804020,%eax
  8001e5:	8b 90 a0 05 00 00    	mov    0x5a0(%eax),%edx
  8001eb:	a1 20 40 80 00       	mov    0x804020,%eax
  8001f0:	8b 80 ec 05 00 00    	mov    0x5ec(%eax),%eax
  8001f6:	89 c1                	mov    %eax,%ecx
  8001f8:	a1 20 40 80 00       	mov    0x804020,%eax
  8001fd:	8b 40 74             	mov    0x74(%eax),%eax
  800200:	52                   	push   %edx
  800201:	51                   	push   %ecx
  800202:	50                   	push   %eax
  800203:	68 cc 34 80 00       	push   $0x8034cc
  800208:	e8 5e 1b 00 00       	call   801d6b <sys_create_env>
  80020d:	83 c4 10             	add    $0x10,%esp
  800210:	89 45 dc             	mov    %eax,-0x24(%ebp)
	id2 = sys_create_env("shr2Slave1", (myEnv->page_WS_max_size), (myEnv->SecondListSize),(myEnv->percentage_of_WS_pages_to_be_removed));
  800213:	a1 20 40 80 00       	mov    0x804020,%eax
  800218:	8b 90 a0 05 00 00    	mov    0x5a0(%eax),%edx
  80021e:	a1 20 40 80 00       	mov    0x804020,%eax
  800223:	8b 80 ec 05 00 00    	mov    0x5ec(%eax),%eax
  800229:	89 c1                	mov    %eax,%ecx
  80022b:	a1 20 40 80 00       	mov    0x804020,%eax
  800230:	8b 40 74             	mov    0x74(%eax),%eax
  800233:	52                   	push   %edx
  800234:	51                   	push   %ecx
  800235:	50                   	push   %eax
  800236:	68 cc 34 80 00       	push   $0x8034cc
  80023b:	e8 2b 1b 00 00       	call   801d6b <sys_create_env>
  800240:	83 c4 10             	add    $0x10,%esp
  800243:	89 45 d8             	mov    %eax,-0x28(%ebp)
	id3 = sys_create_env("shr2Slave1", (myEnv->page_WS_max_size), (myEnv->SecondListSize),(myEnv->percentage_of_WS_pages_to_be_removed));
  800246:	a1 20 40 80 00       	mov    0x804020,%eax
  80024b:	8b 90 a0 05 00 00    	mov    0x5a0(%eax),%edx
  800251:	a1 20 40 80 00       	mov    0x804020,%eax
  800256:	8b 80 ec 05 00 00    	mov    0x5ec(%eax),%eax
  80025c:	89 c1                	mov    %eax,%ecx
  80025e:	a1 20 40 80 00       	mov    0x804020,%eax
  800263:	8b 40 74             	mov    0x74(%eax),%eax
  800266:	52                   	push   %edx
  800267:	51                   	push   %ecx
  800268:	50                   	push   %eax
  800269:	68 cc 34 80 00       	push   $0x8034cc
  80026e:	e8 f8 1a 00 00       	call   801d6b <sys_create_env>
  800273:	83 c4 10             	add    $0x10,%esp
  800276:	89 45 d4             	mov    %eax,-0x2c(%ebp)

	//to check that the slave environments completed successfully
	rsttst();
  800279:	e8 39 1c 00 00       	call   801eb7 <rsttst>

	sys_run_env(id1);
  80027e:	83 ec 0c             	sub    $0xc,%esp
  800281:	ff 75 dc             	pushl  -0x24(%ebp)
  800284:	e8 00 1b 00 00       	call   801d89 <sys_run_env>
  800289:	83 c4 10             	add    $0x10,%esp
	sys_run_env(id2);
  80028c:	83 ec 0c             	sub    $0xc,%esp
  80028f:	ff 75 d8             	pushl  -0x28(%ebp)
  800292:	e8 f2 1a 00 00       	call   801d89 <sys_run_env>
  800297:	83 c4 10             	add    $0x10,%esp
	sys_run_env(id3);
  80029a:	83 ec 0c             	sub    $0xc,%esp
  80029d:	ff 75 d4             	pushl  -0x2c(%ebp)
  8002a0:	e8 e4 1a 00 00       	call   801d89 <sys_run_env>
  8002a5:	83 c4 10             	add    $0x10,%esp

	env_sleep(12000) ;
  8002a8:	83 ec 0c             	sub    $0xc,%esp
  8002ab:	68 e0 2e 00 00       	push   $0x2ee0
  8002b0:	e8 cc 2d 00 00       	call   803081 <env_sleep>
  8002b5:	83 c4 10             	add    $0x10,%esp

	//to ensure that the slave environments completed successfully
	if (gettst()!=3) panic("test failed");
  8002b8:	e8 74 1c 00 00       	call   801f31 <gettst>
  8002bd:	83 f8 03             	cmp    $0x3,%eax
  8002c0:	74 14                	je     8002d6 <_main+0x29e>
  8002c2:	83 ec 04             	sub    $0x4,%esp
  8002c5:	68 d7 34 80 00       	push   $0x8034d7
  8002ca:	6a 3f                	push   $0x3f
  8002cc:	68 bc 33 80 00       	push   $0x8033bc
  8002d1:	e8 d1 01 00 00       	call   8004a7 <_panic>


	if (*z != 30)
  8002d6:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8002d9:	8b 00                	mov    (%eax),%eax
  8002db:	83 f8 1e             	cmp    $0x1e,%eax
  8002de:	74 14                	je     8002f4 <_main+0x2bc>
		panic("Error!! Please check the creation (or the getting) of shared variables!!\n\n\n");
  8002e0:	83 ec 04             	sub    $0x4,%esp
  8002e3:	68 e4 34 80 00       	push   $0x8034e4
  8002e8:	6a 43                	push   $0x43
  8002ea:	68 bc 33 80 00       	push   $0x8033bc
  8002ef:	e8 b3 01 00 00       	call   8004a7 <_panic>
	else
		cprintf("Congratulations!! Test of Shared Variables [Create & Get] [2] completed successfully!!\n\n\n");
  8002f4:	83 ec 0c             	sub    $0xc,%esp
  8002f7:	68 30 35 80 00       	push   $0x803530
  8002fc:	e8 5a 04 00 00       	call   80075b <cprintf>
  800301:	83 c4 10             	add    $0x10,%esp

	cprintf("Now, ILLEGAL MEM ACCESS should be occur, due to attempting to write a ReadOnly variable\n\n\n");
  800304:	83 ec 0c             	sub    $0xc,%esp
  800307:	68 8c 35 80 00       	push   $0x80358c
  80030c:	e8 4a 04 00 00       	call   80075b <cprintf>
  800311:	83 c4 10             	add    $0x10,%esp

	id1 = sys_create_env("shr2Slave2", (myEnv->page_WS_max_size),(myEnv->SecondListSize), (myEnv->percentage_of_WS_pages_to_be_removed));
  800314:	a1 20 40 80 00       	mov    0x804020,%eax
  800319:	8b 90 a0 05 00 00    	mov    0x5a0(%eax),%edx
  80031f:	a1 20 40 80 00       	mov    0x804020,%eax
  800324:	8b 80 ec 05 00 00    	mov    0x5ec(%eax),%eax
  80032a:	89 c1                	mov    %eax,%ecx
  80032c:	a1 20 40 80 00       	mov    0x804020,%eax
  800331:	8b 40 74             	mov    0x74(%eax),%eax
  800334:	52                   	push   %edx
  800335:	51                   	push   %ecx
  800336:	50                   	push   %eax
  800337:	68 e7 35 80 00       	push   $0x8035e7
  80033c:	e8 2a 1a 00 00       	call   801d6b <sys_create_env>
  800341:	83 c4 10             	add    $0x10,%esp
  800344:	89 45 dc             	mov    %eax,-0x24(%ebp)

	env_sleep(3000) ;
  800347:	83 ec 0c             	sub    $0xc,%esp
  80034a:	68 b8 0b 00 00       	push   $0xbb8
  80034f:	e8 2d 2d 00 00       	call   803081 <env_sleep>
  800354:	83 c4 10             	add    $0x10,%esp

	sys_run_env(id1);
  800357:	83 ec 0c             	sub    $0xc,%esp
  80035a:	ff 75 dc             	pushl  -0x24(%ebp)
  80035d:	e8 27 1a 00 00       	call   801d89 <sys_run_env>
  800362:	83 c4 10             	add    $0x10,%esp

	return;
  800365:	90                   	nop
}
  800366:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800369:	c9                   	leave  
  80036a:	c3                   	ret    

0080036b <libmain>:
volatile struct Env *myEnv = NULL;
volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";

void
libmain(int argc, char **argv)
{
  80036b:	55                   	push   %ebp
  80036c:	89 e5                	mov    %esp,%ebp
  80036e:	83 ec 18             	sub    $0x18,%esp
	int envIndex = sys_getenvindex();
  800371:	e8 63 1a 00 00       	call   801dd9 <sys_getenvindex>
  800376:	89 45 f4             	mov    %eax,-0xc(%ebp)
	myEnv = &(envs[envIndex]);
  800379:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80037c:	89 d0                	mov    %edx,%eax
  80037e:	c1 e0 03             	shl    $0x3,%eax
  800381:	01 d0                	add    %edx,%eax
  800383:	01 c0                	add    %eax,%eax
  800385:	01 d0                	add    %edx,%eax
  800387:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80038e:	01 d0                	add    %edx,%eax
  800390:	c1 e0 04             	shl    $0x4,%eax
  800393:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  800398:	a3 20 40 80 00       	mov    %eax,0x804020

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  80039d:	a1 20 40 80 00       	mov    0x804020,%eax
  8003a2:	8a 80 5c 05 00 00    	mov    0x55c(%eax),%al
  8003a8:	84 c0                	test   %al,%al
  8003aa:	74 0f                	je     8003bb <libmain+0x50>
		binaryname = myEnv->prog_name;
  8003ac:	a1 20 40 80 00       	mov    0x804020,%eax
  8003b1:	05 5c 05 00 00       	add    $0x55c,%eax
  8003b6:	a3 00 40 80 00       	mov    %eax,0x804000

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  8003bb:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8003bf:	7e 0a                	jle    8003cb <libmain+0x60>
		binaryname = argv[0];
  8003c1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8003c4:	8b 00                	mov    (%eax),%eax
  8003c6:	a3 00 40 80 00       	mov    %eax,0x804000

	// call user main routine
	_main(argc, argv);
  8003cb:	83 ec 08             	sub    $0x8,%esp
  8003ce:	ff 75 0c             	pushl  0xc(%ebp)
  8003d1:	ff 75 08             	pushl  0x8(%ebp)
  8003d4:	e8 5f fc ff ff       	call   800038 <_main>
  8003d9:	83 c4 10             	add    $0x10,%esp



	sys_disable_interrupt();
  8003dc:	e8 05 18 00 00       	call   801be6 <sys_disable_interrupt>
	cprintf("**************************************\n");
  8003e1:	83 ec 0c             	sub    $0xc,%esp
  8003e4:	68 0c 36 80 00       	push   $0x80360c
  8003e9:	e8 6d 03 00 00       	call   80075b <cprintf>
  8003ee:	83 c4 10             	add    $0x10,%esp
	cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  8003f1:	a1 20 40 80 00       	mov    0x804020,%eax
  8003f6:	8b 90 44 05 00 00    	mov    0x544(%eax),%edx
  8003fc:	a1 20 40 80 00       	mov    0x804020,%eax
  800401:	8b 80 34 05 00 00    	mov    0x534(%eax),%eax
  800407:	83 ec 04             	sub    $0x4,%esp
  80040a:	52                   	push   %edx
  80040b:	50                   	push   %eax
  80040c:	68 34 36 80 00       	push   $0x803634
  800411:	e8 45 03 00 00       	call   80075b <cprintf>
  800416:	83 c4 10             	add    $0x10,%esp
	cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  800419:	a1 20 40 80 00       	mov    0x804020,%eax
  80041e:	8b 88 54 05 00 00    	mov    0x554(%eax),%ecx
  800424:	a1 20 40 80 00       	mov    0x804020,%eax
  800429:	8b 90 50 05 00 00    	mov    0x550(%eax),%edx
  80042f:	a1 20 40 80 00       	mov    0x804020,%eax
  800434:	8b 80 4c 05 00 00    	mov    0x54c(%eax),%eax
  80043a:	51                   	push   %ecx
  80043b:	52                   	push   %edx
  80043c:	50                   	push   %eax
  80043d:	68 5c 36 80 00       	push   $0x80365c
  800442:	e8 14 03 00 00       	call   80075b <cprintf>
  800447:	83 c4 10             	add    $0x10,%esp
	//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
	cprintf("Num of clocks = %d\n", myEnv->nClocks);
  80044a:	a1 20 40 80 00       	mov    0x804020,%eax
  80044f:	8b 80 a4 05 00 00    	mov    0x5a4(%eax),%eax
  800455:	83 ec 08             	sub    $0x8,%esp
  800458:	50                   	push   %eax
  800459:	68 b4 36 80 00       	push   $0x8036b4
  80045e:	e8 f8 02 00 00       	call   80075b <cprintf>
  800463:	83 c4 10             	add    $0x10,%esp
	cprintf("**************************************\n");
  800466:	83 ec 0c             	sub    $0xc,%esp
  800469:	68 0c 36 80 00       	push   $0x80360c
  80046e:	e8 e8 02 00 00       	call   80075b <cprintf>
  800473:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  800476:	e8 85 17 00 00       	call   801c00 <sys_enable_interrupt>

	// exit gracefully
	exit();
  80047b:	e8 19 00 00 00       	call   800499 <exit>
}
  800480:	90                   	nop
  800481:	c9                   	leave  
  800482:	c3                   	ret    

00800483 <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  800483:	55                   	push   %ebp
  800484:	89 e5                	mov    %esp,%ebp
  800486:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  800489:	83 ec 0c             	sub    $0xc,%esp
  80048c:	6a 00                	push   $0x0
  80048e:	e8 12 19 00 00       	call   801da5 <sys_destroy_env>
  800493:	83 c4 10             	add    $0x10,%esp
}
  800496:	90                   	nop
  800497:	c9                   	leave  
  800498:	c3                   	ret    

00800499 <exit>:

void
exit(void)
{
  800499:	55                   	push   %ebp
  80049a:	89 e5                	mov    %esp,%ebp
  80049c:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  80049f:	e8 67 19 00 00       	call   801e0b <sys_exit_env>
}
  8004a4:	90                   	nop
  8004a5:	c9                   	leave  
  8004a6:	c3                   	ret    

008004a7 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  8004a7:	55                   	push   %ebp
  8004a8:	89 e5                	mov    %esp,%ebp
  8004aa:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  8004ad:	8d 45 10             	lea    0x10(%ebp),%eax
  8004b0:	83 c0 04             	add    $0x4,%eax
  8004b3:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  8004b6:	a1 5c 41 80 00       	mov    0x80415c,%eax
  8004bb:	85 c0                	test   %eax,%eax
  8004bd:	74 16                	je     8004d5 <_panic+0x2e>
		cprintf("%s: ", argv0);
  8004bf:	a1 5c 41 80 00       	mov    0x80415c,%eax
  8004c4:	83 ec 08             	sub    $0x8,%esp
  8004c7:	50                   	push   %eax
  8004c8:	68 c8 36 80 00       	push   $0x8036c8
  8004cd:	e8 89 02 00 00       	call   80075b <cprintf>
  8004d2:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  8004d5:	a1 00 40 80 00       	mov    0x804000,%eax
  8004da:	ff 75 0c             	pushl  0xc(%ebp)
  8004dd:	ff 75 08             	pushl  0x8(%ebp)
  8004e0:	50                   	push   %eax
  8004e1:	68 cd 36 80 00       	push   $0x8036cd
  8004e6:	e8 70 02 00 00       	call   80075b <cprintf>
  8004eb:	83 c4 10             	add    $0x10,%esp
	vcprintf(fmt, ap);
  8004ee:	8b 45 10             	mov    0x10(%ebp),%eax
  8004f1:	83 ec 08             	sub    $0x8,%esp
  8004f4:	ff 75 f4             	pushl  -0xc(%ebp)
  8004f7:	50                   	push   %eax
  8004f8:	e8 f3 01 00 00       	call   8006f0 <vcprintf>
  8004fd:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  800500:	83 ec 08             	sub    $0x8,%esp
  800503:	6a 00                	push   $0x0
  800505:	68 e9 36 80 00       	push   $0x8036e9
  80050a:	e8 e1 01 00 00       	call   8006f0 <vcprintf>
  80050f:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  800512:	e8 82 ff ff ff       	call   800499 <exit>

	// should not return here
	while (1) ;
  800517:	eb fe                	jmp    800517 <_panic+0x70>

00800519 <CheckWSWithoutLastIndex>:
}

void CheckWSWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  800519:	55                   	push   %ebp
  80051a:	89 e5                	mov    %esp,%ebp
  80051c:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  80051f:	a1 20 40 80 00       	mov    0x804020,%eax
  800524:	8b 50 74             	mov    0x74(%eax),%edx
  800527:	8b 45 0c             	mov    0xc(%ebp),%eax
  80052a:	39 c2                	cmp    %eax,%edx
  80052c:	74 14                	je     800542 <CheckWSWithoutLastIndex+0x29>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  80052e:	83 ec 04             	sub    $0x4,%esp
  800531:	68 ec 36 80 00       	push   $0x8036ec
  800536:	6a 26                	push   $0x26
  800538:	68 38 37 80 00       	push   $0x803738
  80053d:	e8 65 ff ff ff       	call   8004a7 <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  800542:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  800549:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800550:	e9 c2 00 00 00       	jmp    800617 <CheckWSWithoutLastIndex+0xfe>
		if (expectedPages[e] == 0) {
  800555:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800558:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80055f:	8b 45 08             	mov    0x8(%ebp),%eax
  800562:	01 d0                	add    %edx,%eax
  800564:	8b 00                	mov    (%eax),%eax
  800566:	85 c0                	test   %eax,%eax
  800568:	75 08                	jne    800572 <CheckWSWithoutLastIndex+0x59>
			expectedNumOfEmptyLocs++;
  80056a:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  80056d:	e9 a2 00 00 00       	jmp    800614 <CheckWSWithoutLastIndex+0xfb>
		}
		int found = 0;
  800572:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800579:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  800580:	eb 69                	jmp    8005eb <CheckWSWithoutLastIndex+0xd2>
			if (myEnv->__uptr_pws[w].empty == 0) {
  800582:	a1 20 40 80 00       	mov    0x804020,%eax
  800587:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  80058d:	8b 55 e8             	mov    -0x18(%ebp),%edx
  800590:	89 d0                	mov    %edx,%eax
  800592:	01 c0                	add    %eax,%eax
  800594:	01 d0                	add    %edx,%eax
  800596:	c1 e0 03             	shl    $0x3,%eax
  800599:	01 c8                	add    %ecx,%eax
  80059b:	8a 40 04             	mov    0x4(%eax),%al
  80059e:	84 c0                	test   %al,%al
  8005a0:	75 46                	jne    8005e8 <CheckWSWithoutLastIndex+0xcf>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  8005a2:	a1 20 40 80 00       	mov    0x804020,%eax
  8005a7:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  8005ad:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8005b0:	89 d0                	mov    %edx,%eax
  8005b2:	01 c0                	add    %eax,%eax
  8005b4:	01 d0                	add    %edx,%eax
  8005b6:	c1 e0 03             	shl    $0x3,%eax
  8005b9:	01 c8                	add    %ecx,%eax
  8005bb:	8b 00                	mov    (%eax),%eax
  8005bd:	89 45 dc             	mov    %eax,-0x24(%ebp)
  8005c0:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8005c3:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8005c8:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  8005ca:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8005cd:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  8005d4:	8b 45 08             	mov    0x8(%ebp),%eax
  8005d7:	01 c8                	add    %ecx,%eax
  8005d9:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  8005db:	39 c2                	cmp    %eax,%edx
  8005dd:	75 09                	jne    8005e8 <CheckWSWithoutLastIndex+0xcf>
						== expectedPages[e]) {
					found = 1;
  8005df:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  8005e6:	eb 12                	jmp    8005fa <CheckWSWithoutLastIndex+0xe1>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8005e8:	ff 45 e8             	incl   -0x18(%ebp)
  8005eb:	a1 20 40 80 00       	mov    0x804020,%eax
  8005f0:	8b 50 74             	mov    0x74(%eax),%edx
  8005f3:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8005f6:	39 c2                	cmp    %eax,%edx
  8005f8:	77 88                	ja     800582 <CheckWSWithoutLastIndex+0x69>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  8005fa:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8005fe:	75 14                	jne    800614 <CheckWSWithoutLastIndex+0xfb>
			panic(
  800600:	83 ec 04             	sub    $0x4,%esp
  800603:	68 44 37 80 00       	push   $0x803744
  800608:	6a 3a                	push   $0x3a
  80060a:	68 38 37 80 00       	push   $0x803738
  80060f:	e8 93 fe ff ff       	call   8004a7 <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  800614:	ff 45 f0             	incl   -0x10(%ebp)
  800617:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80061a:	3b 45 0c             	cmp    0xc(%ebp),%eax
  80061d:	0f 8c 32 ff ff ff    	jl     800555 <CheckWSWithoutLastIndex+0x3c>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  800623:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  80062a:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  800631:	eb 26                	jmp    800659 <CheckWSWithoutLastIndex+0x140>
		if (myEnv->__uptr_pws[w].empty == 1) {
  800633:	a1 20 40 80 00       	mov    0x804020,%eax
  800638:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  80063e:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800641:	89 d0                	mov    %edx,%eax
  800643:	01 c0                	add    %eax,%eax
  800645:	01 d0                	add    %edx,%eax
  800647:	c1 e0 03             	shl    $0x3,%eax
  80064a:	01 c8                	add    %ecx,%eax
  80064c:	8a 40 04             	mov    0x4(%eax),%al
  80064f:	3c 01                	cmp    $0x1,%al
  800651:	75 03                	jne    800656 <CheckWSWithoutLastIndex+0x13d>
			actualNumOfEmptyLocs++;
  800653:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800656:	ff 45 e0             	incl   -0x20(%ebp)
  800659:	a1 20 40 80 00       	mov    0x804020,%eax
  80065e:	8b 50 74             	mov    0x74(%eax),%edx
  800661:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800664:	39 c2                	cmp    %eax,%edx
  800666:	77 cb                	ja     800633 <CheckWSWithoutLastIndex+0x11a>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  800668:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80066b:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  80066e:	74 14                	je     800684 <CheckWSWithoutLastIndex+0x16b>
		panic(
  800670:	83 ec 04             	sub    $0x4,%esp
  800673:	68 98 37 80 00       	push   $0x803798
  800678:	6a 44                	push   $0x44
  80067a:	68 38 37 80 00       	push   $0x803738
  80067f:	e8 23 fe ff ff       	call   8004a7 <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  800684:	90                   	nop
  800685:	c9                   	leave  
  800686:	c3                   	ret    

00800687 <putch>:
};

//2017:
uint8 printProgName = 0;

static void putch(int ch, struct printbuf *b) {
  800687:	55                   	push   %ebp
  800688:	89 e5                	mov    %esp,%ebp
  80068a:	83 ec 08             	sub    $0x8,%esp
	b->buf[b->idx++] = ch;
  80068d:	8b 45 0c             	mov    0xc(%ebp),%eax
  800690:	8b 00                	mov    (%eax),%eax
  800692:	8d 48 01             	lea    0x1(%eax),%ecx
  800695:	8b 55 0c             	mov    0xc(%ebp),%edx
  800698:	89 0a                	mov    %ecx,(%edx)
  80069a:	8b 55 08             	mov    0x8(%ebp),%edx
  80069d:	88 d1                	mov    %dl,%cl
  80069f:	8b 55 0c             	mov    0xc(%ebp),%edx
  8006a2:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  8006a6:	8b 45 0c             	mov    0xc(%ebp),%eax
  8006a9:	8b 00                	mov    (%eax),%eax
  8006ab:	3d ff 00 00 00       	cmp    $0xff,%eax
  8006b0:	75 2c                	jne    8006de <putch+0x57>
		sys_cputs(b->buf, b->idx, printProgName);
  8006b2:	a0 24 40 80 00       	mov    0x804024,%al
  8006b7:	0f b6 c0             	movzbl %al,%eax
  8006ba:	8b 55 0c             	mov    0xc(%ebp),%edx
  8006bd:	8b 12                	mov    (%edx),%edx
  8006bf:	89 d1                	mov    %edx,%ecx
  8006c1:	8b 55 0c             	mov    0xc(%ebp),%edx
  8006c4:	83 c2 08             	add    $0x8,%edx
  8006c7:	83 ec 04             	sub    $0x4,%esp
  8006ca:	50                   	push   %eax
  8006cb:	51                   	push   %ecx
  8006cc:	52                   	push   %edx
  8006cd:	e8 66 13 00 00       	call   801a38 <sys_cputs>
  8006d2:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  8006d5:	8b 45 0c             	mov    0xc(%ebp),%eax
  8006d8:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  8006de:	8b 45 0c             	mov    0xc(%ebp),%eax
  8006e1:	8b 40 04             	mov    0x4(%eax),%eax
  8006e4:	8d 50 01             	lea    0x1(%eax),%edx
  8006e7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8006ea:	89 50 04             	mov    %edx,0x4(%eax)
}
  8006ed:	90                   	nop
  8006ee:	c9                   	leave  
  8006ef:	c3                   	ret    

008006f0 <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  8006f0:	55                   	push   %ebp
  8006f1:	89 e5                	mov    %esp,%ebp
  8006f3:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  8006f9:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  800700:	00 00 00 
	b.cnt = 0;
  800703:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  80070a:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  80070d:	ff 75 0c             	pushl  0xc(%ebp)
  800710:	ff 75 08             	pushl  0x8(%ebp)
  800713:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800719:	50                   	push   %eax
  80071a:	68 87 06 80 00       	push   $0x800687
  80071f:	e8 11 02 00 00       	call   800935 <vprintfmt>
  800724:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName);
  800727:	a0 24 40 80 00       	mov    0x804024,%al
  80072c:	0f b6 c0             	movzbl %al,%eax
  80072f:	8b 95 f0 fe ff ff    	mov    -0x110(%ebp),%edx
  800735:	83 ec 04             	sub    $0x4,%esp
  800738:	50                   	push   %eax
  800739:	52                   	push   %edx
  80073a:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800740:	83 c0 08             	add    $0x8,%eax
  800743:	50                   	push   %eax
  800744:	e8 ef 12 00 00       	call   801a38 <sys_cputs>
  800749:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  80074c:	c6 05 24 40 80 00 00 	movb   $0x0,0x804024
	return b.cnt;
  800753:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  800759:	c9                   	leave  
  80075a:	c3                   	ret    

0080075b <cprintf>:

int cprintf(const char *fmt, ...) {
  80075b:	55                   	push   %ebp
  80075c:	89 e5                	mov    %esp,%ebp
  80075e:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  800761:	c6 05 24 40 80 00 01 	movb   $0x1,0x804024
	va_start(ap, fmt);
  800768:	8d 45 0c             	lea    0xc(%ebp),%eax
  80076b:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  80076e:	8b 45 08             	mov    0x8(%ebp),%eax
  800771:	83 ec 08             	sub    $0x8,%esp
  800774:	ff 75 f4             	pushl  -0xc(%ebp)
  800777:	50                   	push   %eax
  800778:	e8 73 ff ff ff       	call   8006f0 <vcprintf>
  80077d:	83 c4 10             	add    $0x10,%esp
  800780:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  800783:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800786:	c9                   	leave  
  800787:	c3                   	ret    

00800788 <atomic_cprintf>:

int atomic_cprintf(const char *fmt, ...) {
  800788:	55                   	push   %ebp
  800789:	89 e5                	mov    %esp,%ebp
  80078b:	83 ec 18             	sub    $0x18,%esp
	sys_disable_interrupt();
  80078e:	e8 53 14 00 00       	call   801be6 <sys_disable_interrupt>
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  800793:	8d 45 0c             	lea    0xc(%ebp),%eax
  800796:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800799:	8b 45 08             	mov    0x8(%ebp),%eax
  80079c:	83 ec 08             	sub    $0x8,%esp
  80079f:	ff 75 f4             	pushl  -0xc(%ebp)
  8007a2:	50                   	push   %eax
  8007a3:	e8 48 ff ff ff       	call   8006f0 <vcprintf>
  8007a8:	83 c4 10             	add    $0x10,%esp
  8007ab:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	sys_enable_interrupt();
  8007ae:	e8 4d 14 00 00       	call   801c00 <sys_enable_interrupt>
	return cnt;
  8007b3:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8007b6:	c9                   	leave  
  8007b7:	c3                   	ret    

008007b8 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  8007b8:	55                   	push   %ebp
  8007b9:	89 e5                	mov    %esp,%ebp
  8007bb:	53                   	push   %ebx
  8007bc:	83 ec 14             	sub    $0x14,%esp
  8007bf:	8b 45 10             	mov    0x10(%ebp),%eax
  8007c2:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8007c5:	8b 45 14             	mov    0x14(%ebp),%eax
  8007c8:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  8007cb:	8b 45 18             	mov    0x18(%ebp),%eax
  8007ce:	ba 00 00 00 00       	mov    $0x0,%edx
  8007d3:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  8007d6:	77 55                	ja     80082d <printnum+0x75>
  8007d8:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  8007db:	72 05                	jb     8007e2 <printnum+0x2a>
  8007dd:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8007e0:	77 4b                	ja     80082d <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  8007e2:	8b 45 1c             	mov    0x1c(%ebp),%eax
  8007e5:	8d 58 ff             	lea    -0x1(%eax),%ebx
  8007e8:	8b 45 18             	mov    0x18(%ebp),%eax
  8007eb:	ba 00 00 00 00       	mov    $0x0,%edx
  8007f0:	52                   	push   %edx
  8007f1:	50                   	push   %eax
  8007f2:	ff 75 f4             	pushl  -0xc(%ebp)
  8007f5:	ff 75 f0             	pushl  -0x10(%ebp)
  8007f8:	e8 3b 29 00 00       	call   803138 <__udivdi3>
  8007fd:	83 c4 10             	add    $0x10,%esp
  800800:	83 ec 04             	sub    $0x4,%esp
  800803:	ff 75 20             	pushl  0x20(%ebp)
  800806:	53                   	push   %ebx
  800807:	ff 75 18             	pushl  0x18(%ebp)
  80080a:	52                   	push   %edx
  80080b:	50                   	push   %eax
  80080c:	ff 75 0c             	pushl  0xc(%ebp)
  80080f:	ff 75 08             	pushl  0x8(%ebp)
  800812:	e8 a1 ff ff ff       	call   8007b8 <printnum>
  800817:	83 c4 20             	add    $0x20,%esp
  80081a:	eb 1a                	jmp    800836 <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  80081c:	83 ec 08             	sub    $0x8,%esp
  80081f:	ff 75 0c             	pushl  0xc(%ebp)
  800822:	ff 75 20             	pushl  0x20(%ebp)
  800825:	8b 45 08             	mov    0x8(%ebp),%eax
  800828:	ff d0                	call   *%eax
  80082a:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  80082d:	ff 4d 1c             	decl   0x1c(%ebp)
  800830:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  800834:	7f e6                	jg     80081c <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800836:	8b 4d 18             	mov    0x18(%ebp),%ecx
  800839:	bb 00 00 00 00       	mov    $0x0,%ebx
  80083e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800841:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800844:	53                   	push   %ebx
  800845:	51                   	push   %ecx
  800846:	52                   	push   %edx
  800847:	50                   	push   %eax
  800848:	e8 fb 29 00 00       	call   803248 <__umoddi3>
  80084d:	83 c4 10             	add    $0x10,%esp
  800850:	05 14 3a 80 00       	add    $0x803a14,%eax
  800855:	8a 00                	mov    (%eax),%al
  800857:	0f be c0             	movsbl %al,%eax
  80085a:	83 ec 08             	sub    $0x8,%esp
  80085d:	ff 75 0c             	pushl  0xc(%ebp)
  800860:	50                   	push   %eax
  800861:	8b 45 08             	mov    0x8(%ebp),%eax
  800864:	ff d0                	call   *%eax
  800866:	83 c4 10             	add    $0x10,%esp
}
  800869:	90                   	nop
  80086a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80086d:	c9                   	leave  
  80086e:	c3                   	ret    

0080086f <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  80086f:	55                   	push   %ebp
  800870:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800872:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800876:	7e 1c                	jle    800894 <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  800878:	8b 45 08             	mov    0x8(%ebp),%eax
  80087b:	8b 00                	mov    (%eax),%eax
  80087d:	8d 50 08             	lea    0x8(%eax),%edx
  800880:	8b 45 08             	mov    0x8(%ebp),%eax
  800883:	89 10                	mov    %edx,(%eax)
  800885:	8b 45 08             	mov    0x8(%ebp),%eax
  800888:	8b 00                	mov    (%eax),%eax
  80088a:	83 e8 08             	sub    $0x8,%eax
  80088d:	8b 50 04             	mov    0x4(%eax),%edx
  800890:	8b 00                	mov    (%eax),%eax
  800892:	eb 40                	jmp    8008d4 <getuint+0x65>
	else if (lflag)
  800894:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800898:	74 1e                	je     8008b8 <getuint+0x49>
		return va_arg(*ap, unsigned long);
  80089a:	8b 45 08             	mov    0x8(%ebp),%eax
  80089d:	8b 00                	mov    (%eax),%eax
  80089f:	8d 50 04             	lea    0x4(%eax),%edx
  8008a2:	8b 45 08             	mov    0x8(%ebp),%eax
  8008a5:	89 10                	mov    %edx,(%eax)
  8008a7:	8b 45 08             	mov    0x8(%ebp),%eax
  8008aa:	8b 00                	mov    (%eax),%eax
  8008ac:	83 e8 04             	sub    $0x4,%eax
  8008af:	8b 00                	mov    (%eax),%eax
  8008b1:	ba 00 00 00 00       	mov    $0x0,%edx
  8008b6:	eb 1c                	jmp    8008d4 <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  8008b8:	8b 45 08             	mov    0x8(%ebp),%eax
  8008bb:	8b 00                	mov    (%eax),%eax
  8008bd:	8d 50 04             	lea    0x4(%eax),%edx
  8008c0:	8b 45 08             	mov    0x8(%ebp),%eax
  8008c3:	89 10                	mov    %edx,(%eax)
  8008c5:	8b 45 08             	mov    0x8(%ebp),%eax
  8008c8:	8b 00                	mov    (%eax),%eax
  8008ca:	83 e8 04             	sub    $0x4,%eax
  8008cd:	8b 00                	mov    (%eax),%eax
  8008cf:	ba 00 00 00 00       	mov    $0x0,%edx
}
  8008d4:	5d                   	pop    %ebp
  8008d5:	c3                   	ret    

008008d6 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  8008d6:	55                   	push   %ebp
  8008d7:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  8008d9:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  8008dd:	7e 1c                	jle    8008fb <getint+0x25>
		return va_arg(*ap, long long);
  8008df:	8b 45 08             	mov    0x8(%ebp),%eax
  8008e2:	8b 00                	mov    (%eax),%eax
  8008e4:	8d 50 08             	lea    0x8(%eax),%edx
  8008e7:	8b 45 08             	mov    0x8(%ebp),%eax
  8008ea:	89 10                	mov    %edx,(%eax)
  8008ec:	8b 45 08             	mov    0x8(%ebp),%eax
  8008ef:	8b 00                	mov    (%eax),%eax
  8008f1:	83 e8 08             	sub    $0x8,%eax
  8008f4:	8b 50 04             	mov    0x4(%eax),%edx
  8008f7:	8b 00                	mov    (%eax),%eax
  8008f9:	eb 38                	jmp    800933 <getint+0x5d>
	else if (lflag)
  8008fb:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8008ff:	74 1a                	je     80091b <getint+0x45>
		return va_arg(*ap, long);
  800901:	8b 45 08             	mov    0x8(%ebp),%eax
  800904:	8b 00                	mov    (%eax),%eax
  800906:	8d 50 04             	lea    0x4(%eax),%edx
  800909:	8b 45 08             	mov    0x8(%ebp),%eax
  80090c:	89 10                	mov    %edx,(%eax)
  80090e:	8b 45 08             	mov    0x8(%ebp),%eax
  800911:	8b 00                	mov    (%eax),%eax
  800913:	83 e8 04             	sub    $0x4,%eax
  800916:	8b 00                	mov    (%eax),%eax
  800918:	99                   	cltd   
  800919:	eb 18                	jmp    800933 <getint+0x5d>
	else
		return va_arg(*ap, int);
  80091b:	8b 45 08             	mov    0x8(%ebp),%eax
  80091e:	8b 00                	mov    (%eax),%eax
  800920:	8d 50 04             	lea    0x4(%eax),%edx
  800923:	8b 45 08             	mov    0x8(%ebp),%eax
  800926:	89 10                	mov    %edx,(%eax)
  800928:	8b 45 08             	mov    0x8(%ebp),%eax
  80092b:	8b 00                	mov    (%eax),%eax
  80092d:	83 e8 04             	sub    $0x4,%eax
  800930:	8b 00                	mov    (%eax),%eax
  800932:	99                   	cltd   
}
  800933:	5d                   	pop    %ebp
  800934:	c3                   	ret    

00800935 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  800935:	55                   	push   %ebp
  800936:	89 e5                	mov    %esp,%ebp
  800938:	56                   	push   %esi
  800939:	53                   	push   %ebx
  80093a:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  80093d:	eb 17                	jmp    800956 <vprintfmt+0x21>
			if (ch == '\0')
  80093f:	85 db                	test   %ebx,%ebx
  800941:	0f 84 af 03 00 00    	je     800cf6 <vprintfmt+0x3c1>
				return;
			putch(ch, putdat);
  800947:	83 ec 08             	sub    $0x8,%esp
  80094a:	ff 75 0c             	pushl  0xc(%ebp)
  80094d:	53                   	push   %ebx
  80094e:	8b 45 08             	mov    0x8(%ebp),%eax
  800951:	ff d0                	call   *%eax
  800953:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800956:	8b 45 10             	mov    0x10(%ebp),%eax
  800959:	8d 50 01             	lea    0x1(%eax),%edx
  80095c:	89 55 10             	mov    %edx,0x10(%ebp)
  80095f:	8a 00                	mov    (%eax),%al
  800961:	0f b6 d8             	movzbl %al,%ebx
  800964:	83 fb 25             	cmp    $0x25,%ebx
  800967:	75 d6                	jne    80093f <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  800969:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  80096d:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  800974:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  80097b:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  800982:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800989:	8b 45 10             	mov    0x10(%ebp),%eax
  80098c:	8d 50 01             	lea    0x1(%eax),%edx
  80098f:	89 55 10             	mov    %edx,0x10(%ebp)
  800992:	8a 00                	mov    (%eax),%al
  800994:	0f b6 d8             	movzbl %al,%ebx
  800997:	8d 43 dd             	lea    -0x23(%ebx),%eax
  80099a:	83 f8 55             	cmp    $0x55,%eax
  80099d:	0f 87 2b 03 00 00    	ja     800cce <vprintfmt+0x399>
  8009a3:	8b 04 85 38 3a 80 00 	mov    0x803a38(,%eax,4),%eax
  8009aa:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  8009ac:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  8009b0:	eb d7                	jmp    800989 <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  8009b2:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  8009b6:	eb d1                	jmp    800989 <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8009b8:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  8009bf:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8009c2:	89 d0                	mov    %edx,%eax
  8009c4:	c1 e0 02             	shl    $0x2,%eax
  8009c7:	01 d0                	add    %edx,%eax
  8009c9:	01 c0                	add    %eax,%eax
  8009cb:	01 d8                	add    %ebx,%eax
  8009cd:	83 e8 30             	sub    $0x30,%eax
  8009d0:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  8009d3:	8b 45 10             	mov    0x10(%ebp),%eax
  8009d6:	8a 00                	mov    (%eax),%al
  8009d8:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  8009db:	83 fb 2f             	cmp    $0x2f,%ebx
  8009de:	7e 3e                	jle    800a1e <vprintfmt+0xe9>
  8009e0:	83 fb 39             	cmp    $0x39,%ebx
  8009e3:	7f 39                	jg     800a1e <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8009e5:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  8009e8:	eb d5                	jmp    8009bf <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  8009ea:	8b 45 14             	mov    0x14(%ebp),%eax
  8009ed:	83 c0 04             	add    $0x4,%eax
  8009f0:	89 45 14             	mov    %eax,0x14(%ebp)
  8009f3:	8b 45 14             	mov    0x14(%ebp),%eax
  8009f6:	83 e8 04             	sub    $0x4,%eax
  8009f9:	8b 00                	mov    (%eax),%eax
  8009fb:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  8009fe:	eb 1f                	jmp    800a1f <vprintfmt+0xea>

		case '.':
			if (width < 0)
  800a00:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800a04:	79 83                	jns    800989 <vprintfmt+0x54>
				width = 0;
  800a06:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  800a0d:	e9 77 ff ff ff       	jmp    800989 <vprintfmt+0x54>

		case '#':
			altflag = 1;
  800a12:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  800a19:	e9 6b ff ff ff       	jmp    800989 <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  800a1e:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  800a1f:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800a23:	0f 89 60 ff ff ff    	jns    800989 <vprintfmt+0x54>
				width = precision, precision = -1;
  800a29:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800a2c:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800a2f:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  800a36:	e9 4e ff ff ff       	jmp    800989 <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  800a3b:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  800a3e:	e9 46 ff ff ff       	jmp    800989 <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  800a43:	8b 45 14             	mov    0x14(%ebp),%eax
  800a46:	83 c0 04             	add    $0x4,%eax
  800a49:	89 45 14             	mov    %eax,0x14(%ebp)
  800a4c:	8b 45 14             	mov    0x14(%ebp),%eax
  800a4f:	83 e8 04             	sub    $0x4,%eax
  800a52:	8b 00                	mov    (%eax),%eax
  800a54:	83 ec 08             	sub    $0x8,%esp
  800a57:	ff 75 0c             	pushl  0xc(%ebp)
  800a5a:	50                   	push   %eax
  800a5b:	8b 45 08             	mov    0x8(%ebp),%eax
  800a5e:	ff d0                	call   *%eax
  800a60:	83 c4 10             	add    $0x10,%esp
			break;
  800a63:	e9 89 02 00 00       	jmp    800cf1 <vprintfmt+0x3bc>

		// error message
		case 'e':
			err = va_arg(ap, int);
  800a68:	8b 45 14             	mov    0x14(%ebp),%eax
  800a6b:	83 c0 04             	add    $0x4,%eax
  800a6e:	89 45 14             	mov    %eax,0x14(%ebp)
  800a71:	8b 45 14             	mov    0x14(%ebp),%eax
  800a74:	83 e8 04             	sub    $0x4,%eax
  800a77:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  800a79:	85 db                	test   %ebx,%ebx
  800a7b:	79 02                	jns    800a7f <vprintfmt+0x14a>
				err = -err;
  800a7d:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  800a7f:	83 fb 64             	cmp    $0x64,%ebx
  800a82:	7f 0b                	jg     800a8f <vprintfmt+0x15a>
  800a84:	8b 34 9d 80 38 80 00 	mov    0x803880(,%ebx,4),%esi
  800a8b:	85 f6                	test   %esi,%esi
  800a8d:	75 19                	jne    800aa8 <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  800a8f:	53                   	push   %ebx
  800a90:	68 25 3a 80 00       	push   $0x803a25
  800a95:	ff 75 0c             	pushl  0xc(%ebp)
  800a98:	ff 75 08             	pushl  0x8(%ebp)
  800a9b:	e8 5e 02 00 00       	call   800cfe <printfmt>
  800aa0:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  800aa3:	e9 49 02 00 00       	jmp    800cf1 <vprintfmt+0x3bc>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  800aa8:	56                   	push   %esi
  800aa9:	68 2e 3a 80 00       	push   $0x803a2e
  800aae:	ff 75 0c             	pushl  0xc(%ebp)
  800ab1:	ff 75 08             	pushl  0x8(%ebp)
  800ab4:	e8 45 02 00 00       	call   800cfe <printfmt>
  800ab9:	83 c4 10             	add    $0x10,%esp
			break;
  800abc:	e9 30 02 00 00       	jmp    800cf1 <vprintfmt+0x3bc>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  800ac1:	8b 45 14             	mov    0x14(%ebp),%eax
  800ac4:	83 c0 04             	add    $0x4,%eax
  800ac7:	89 45 14             	mov    %eax,0x14(%ebp)
  800aca:	8b 45 14             	mov    0x14(%ebp),%eax
  800acd:	83 e8 04             	sub    $0x4,%eax
  800ad0:	8b 30                	mov    (%eax),%esi
  800ad2:	85 f6                	test   %esi,%esi
  800ad4:	75 05                	jne    800adb <vprintfmt+0x1a6>
				p = "(null)";
  800ad6:	be 31 3a 80 00       	mov    $0x803a31,%esi
			if (width > 0 && padc != '-')
  800adb:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800adf:	7e 6d                	jle    800b4e <vprintfmt+0x219>
  800ae1:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  800ae5:	74 67                	je     800b4e <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  800ae7:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800aea:	83 ec 08             	sub    $0x8,%esp
  800aed:	50                   	push   %eax
  800aee:	56                   	push   %esi
  800aef:	e8 0c 03 00 00       	call   800e00 <strnlen>
  800af4:	83 c4 10             	add    $0x10,%esp
  800af7:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  800afa:	eb 16                	jmp    800b12 <vprintfmt+0x1dd>
					putch(padc, putdat);
  800afc:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  800b00:	83 ec 08             	sub    $0x8,%esp
  800b03:	ff 75 0c             	pushl  0xc(%ebp)
  800b06:	50                   	push   %eax
  800b07:	8b 45 08             	mov    0x8(%ebp),%eax
  800b0a:	ff d0                	call   *%eax
  800b0c:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800b0f:	ff 4d e4             	decl   -0x1c(%ebp)
  800b12:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800b16:	7f e4                	jg     800afc <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800b18:	eb 34                	jmp    800b4e <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  800b1a:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  800b1e:	74 1c                	je     800b3c <vprintfmt+0x207>
  800b20:	83 fb 1f             	cmp    $0x1f,%ebx
  800b23:	7e 05                	jle    800b2a <vprintfmt+0x1f5>
  800b25:	83 fb 7e             	cmp    $0x7e,%ebx
  800b28:	7e 12                	jle    800b3c <vprintfmt+0x207>
					putch('?', putdat);
  800b2a:	83 ec 08             	sub    $0x8,%esp
  800b2d:	ff 75 0c             	pushl  0xc(%ebp)
  800b30:	6a 3f                	push   $0x3f
  800b32:	8b 45 08             	mov    0x8(%ebp),%eax
  800b35:	ff d0                	call   *%eax
  800b37:	83 c4 10             	add    $0x10,%esp
  800b3a:	eb 0f                	jmp    800b4b <vprintfmt+0x216>
				else
					putch(ch, putdat);
  800b3c:	83 ec 08             	sub    $0x8,%esp
  800b3f:	ff 75 0c             	pushl  0xc(%ebp)
  800b42:	53                   	push   %ebx
  800b43:	8b 45 08             	mov    0x8(%ebp),%eax
  800b46:	ff d0                	call   *%eax
  800b48:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800b4b:	ff 4d e4             	decl   -0x1c(%ebp)
  800b4e:	89 f0                	mov    %esi,%eax
  800b50:	8d 70 01             	lea    0x1(%eax),%esi
  800b53:	8a 00                	mov    (%eax),%al
  800b55:	0f be d8             	movsbl %al,%ebx
  800b58:	85 db                	test   %ebx,%ebx
  800b5a:	74 24                	je     800b80 <vprintfmt+0x24b>
  800b5c:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800b60:	78 b8                	js     800b1a <vprintfmt+0x1e5>
  800b62:	ff 4d e0             	decl   -0x20(%ebp)
  800b65:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800b69:	79 af                	jns    800b1a <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800b6b:	eb 13                	jmp    800b80 <vprintfmt+0x24b>
				putch(' ', putdat);
  800b6d:	83 ec 08             	sub    $0x8,%esp
  800b70:	ff 75 0c             	pushl  0xc(%ebp)
  800b73:	6a 20                	push   $0x20
  800b75:	8b 45 08             	mov    0x8(%ebp),%eax
  800b78:	ff d0                	call   *%eax
  800b7a:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800b7d:	ff 4d e4             	decl   -0x1c(%ebp)
  800b80:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800b84:	7f e7                	jg     800b6d <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  800b86:	e9 66 01 00 00       	jmp    800cf1 <vprintfmt+0x3bc>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  800b8b:	83 ec 08             	sub    $0x8,%esp
  800b8e:	ff 75 e8             	pushl  -0x18(%ebp)
  800b91:	8d 45 14             	lea    0x14(%ebp),%eax
  800b94:	50                   	push   %eax
  800b95:	e8 3c fd ff ff       	call   8008d6 <getint>
  800b9a:	83 c4 10             	add    $0x10,%esp
  800b9d:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800ba0:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  800ba3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800ba6:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800ba9:	85 d2                	test   %edx,%edx
  800bab:	79 23                	jns    800bd0 <vprintfmt+0x29b>
				putch('-', putdat);
  800bad:	83 ec 08             	sub    $0x8,%esp
  800bb0:	ff 75 0c             	pushl  0xc(%ebp)
  800bb3:	6a 2d                	push   $0x2d
  800bb5:	8b 45 08             	mov    0x8(%ebp),%eax
  800bb8:	ff d0                	call   *%eax
  800bba:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  800bbd:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800bc0:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800bc3:	f7 d8                	neg    %eax
  800bc5:	83 d2 00             	adc    $0x0,%edx
  800bc8:	f7 da                	neg    %edx
  800bca:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800bcd:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  800bd0:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800bd7:	e9 bc 00 00 00       	jmp    800c98 <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  800bdc:	83 ec 08             	sub    $0x8,%esp
  800bdf:	ff 75 e8             	pushl  -0x18(%ebp)
  800be2:	8d 45 14             	lea    0x14(%ebp),%eax
  800be5:	50                   	push   %eax
  800be6:	e8 84 fc ff ff       	call   80086f <getuint>
  800beb:	83 c4 10             	add    $0x10,%esp
  800bee:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800bf1:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  800bf4:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800bfb:	e9 98 00 00 00       	jmp    800c98 <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  800c00:	83 ec 08             	sub    $0x8,%esp
  800c03:	ff 75 0c             	pushl  0xc(%ebp)
  800c06:	6a 58                	push   $0x58
  800c08:	8b 45 08             	mov    0x8(%ebp),%eax
  800c0b:	ff d0                	call   *%eax
  800c0d:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800c10:	83 ec 08             	sub    $0x8,%esp
  800c13:	ff 75 0c             	pushl  0xc(%ebp)
  800c16:	6a 58                	push   $0x58
  800c18:	8b 45 08             	mov    0x8(%ebp),%eax
  800c1b:	ff d0                	call   *%eax
  800c1d:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800c20:	83 ec 08             	sub    $0x8,%esp
  800c23:	ff 75 0c             	pushl  0xc(%ebp)
  800c26:	6a 58                	push   $0x58
  800c28:	8b 45 08             	mov    0x8(%ebp),%eax
  800c2b:	ff d0                	call   *%eax
  800c2d:	83 c4 10             	add    $0x10,%esp
			break;
  800c30:	e9 bc 00 00 00       	jmp    800cf1 <vprintfmt+0x3bc>

		// pointer
		case 'p':
			putch('0', putdat);
  800c35:	83 ec 08             	sub    $0x8,%esp
  800c38:	ff 75 0c             	pushl  0xc(%ebp)
  800c3b:	6a 30                	push   $0x30
  800c3d:	8b 45 08             	mov    0x8(%ebp),%eax
  800c40:	ff d0                	call   *%eax
  800c42:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  800c45:	83 ec 08             	sub    $0x8,%esp
  800c48:	ff 75 0c             	pushl  0xc(%ebp)
  800c4b:	6a 78                	push   $0x78
  800c4d:	8b 45 08             	mov    0x8(%ebp),%eax
  800c50:	ff d0                	call   *%eax
  800c52:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  800c55:	8b 45 14             	mov    0x14(%ebp),%eax
  800c58:	83 c0 04             	add    $0x4,%eax
  800c5b:	89 45 14             	mov    %eax,0x14(%ebp)
  800c5e:	8b 45 14             	mov    0x14(%ebp),%eax
  800c61:	83 e8 04             	sub    $0x4,%eax
  800c64:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800c66:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800c69:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  800c70:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  800c77:	eb 1f                	jmp    800c98 <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  800c79:	83 ec 08             	sub    $0x8,%esp
  800c7c:	ff 75 e8             	pushl  -0x18(%ebp)
  800c7f:	8d 45 14             	lea    0x14(%ebp),%eax
  800c82:	50                   	push   %eax
  800c83:	e8 e7 fb ff ff       	call   80086f <getuint>
  800c88:	83 c4 10             	add    $0x10,%esp
  800c8b:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800c8e:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  800c91:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800c98:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  800c9c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800c9f:	83 ec 04             	sub    $0x4,%esp
  800ca2:	52                   	push   %edx
  800ca3:	ff 75 e4             	pushl  -0x1c(%ebp)
  800ca6:	50                   	push   %eax
  800ca7:	ff 75 f4             	pushl  -0xc(%ebp)
  800caa:	ff 75 f0             	pushl  -0x10(%ebp)
  800cad:	ff 75 0c             	pushl  0xc(%ebp)
  800cb0:	ff 75 08             	pushl  0x8(%ebp)
  800cb3:	e8 00 fb ff ff       	call   8007b8 <printnum>
  800cb8:	83 c4 20             	add    $0x20,%esp
			break;
  800cbb:	eb 34                	jmp    800cf1 <vprintfmt+0x3bc>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  800cbd:	83 ec 08             	sub    $0x8,%esp
  800cc0:	ff 75 0c             	pushl  0xc(%ebp)
  800cc3:	53                   	push   %ebx
  800cc4:	8b 45 08             	mov    0x8(%ebp),%eax
  800cc7:	ff d0                	call   *%eax
  800cc9:	83 c4 10             	add    $0x10,%esp
			break;
  800ccc:	eb 23                	jmp    800cf1 <vprintfmt+0x3bc>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800cce:	83 ec 08             	sub    $0x8,%esp
  800cd1:	ff 75 0c             	pushl  0xc(%ebp)
  800cd4:	6a 25                	push   $0x25
  800cd6:	8b 45 08             	mov    0x8(%ebp),%eax
  800cd9:	ff d0                	call   *%eax
  800cdb:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  800cde:	ff 4d 10             	decl   0x10(%ebp)
  800ce1:	eb 03                	jmp    800ce6 <vprintfmt+0x3b1>
  800ce3:	ff 4d 10             	decl   0x10(%ebp)
  800ce6:	8b 45 10             	mov    0x10(%ebp),%eax
  800ce9:	48                   	dec    %eax
  800cea:	8a 00                	mov    (%eax),%al
  800cec:	3c 25                	cmp    $0x25,%al
  800cee:	75 f3                	jne    800ce3 <vprintfmt+0x3ae>
				/* do nothing */;
			break;
  800cf0:	90                   	nop
		}
	}
  800cf1:	e9 47 fc ff ff       	jmp    80093d <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  800cf6:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  800cf7:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800cfa:	5b                   	pop    %ebx
  800cfb:	5e                   	pop    %esi
  800cfc:	5d                   	pop    %ebp
  800cfd:	c3                   	ret    

00800cfe <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800cfe:	55                   	push   %ebp
  800cff:	89 e5                	mov    %esp,%ebp
  800d01:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  800d04:	8d 45 10             	lea    0x10(%ebp),%eax
  800d07:	83 c0 04             	add    $0x4,%eax
  800d0a:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  800d0d:	8b 45 10             	mov    0x10(%ebp),%eax
  800d10:	ff 75 f4             	pushl  -0xc(%ebp)
  800d13:	50                   	push   %eax
  800d14:	ff 75 0c             	pushl  0xc(%ebp)
  800d17:	ff 75 08             	pushl  0x8(%ebp)
  800d1a:	e8 16 fc ff ff       	call   800935 <vprintfmt>
  800d1f:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  800d22:	90                   	nop
  800d23:	c9                   	leave  
  800d24:	c3                   	ret    

00800d25 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800d25:	55                   	push   %ebp
  800d26:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  800d28:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d2b:	8b 40 08             	mov    0x8(%eax),%eax
  800d2e:	8d 50 01             	lea    0x1(%eax),%edx
  800d31:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d34:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  800d37:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d3a:	8b 10                	mov    (%eax),%edx
  800d3c:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d3f:	8b 40 04             	mov    0x4(%eax),%eax
  800d42:	39 c2                	cmp    %eax,%edx
  800d44:	73 12                	jae    800d58 <sprintputch+0x33>
		*b->buf++ = ch;
  800d46:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d49:	8b 00                	mov    (%eax),%eax
  800d4b:	8d 48 01             	lea    0x1(%eax),%ecx
  800d4e:	8b 55 0c             	mov    0xc(%ebp),%edx
  800d51:	89 0a                	mov    %ecx,(%edx)
  800d53:	8b 55 08             	mov    0x8(%ebp),%edx
  800d56:	88 10                	mov    %dl,(%eax)
}
  800d58:	90                   	nop
  800d59:	5d                   	pop    %ebp
  800d5a:	c3                   	ret    

00800d5b <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800d5b:	55                   	push   %ebp
  800d5c:	89 e5                	mov    %esp,%ebp
  800d5e:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  800d61:	8b 45 08             	mov    0x8(%ebp),%eax
  800d64:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800d67:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d6a:	8d 50 ff             	lea    -0x1(%eax),%edx
  800d6d:	8b 45 08             	mov    0x8(%ebp),%eax
  800d70:	01 d0                	add    %edx,%eax
  800d72:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800d75:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800d7c:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800d80:	74 06                	je     800d88 <vsnprintf+0x2d>
  800d82:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800d86:	7f 07                	jg     800d8f <vsnprintf+0x34>
		return -E_INVAL;
  800d88:	b8 03 00 00 00       	mov    $0x3,%eax
  800d8d:	eb 20                	jmp    800daf <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800d8f:	ff 75 14             	pushl  0x14(%ebp)
  800d92:	ff 75 10             	pushl  0x10(%ebp)
  800d95:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800d98:	50                   	push   %eax
  800d99:	68 25 0d 80 00       	push   $0x800d25
  800d9e:	e8 92 fb ff ff       	call   800935 <vprintfmt>
  800da3:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  800da6:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800da9:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800dac:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  800daf:	c9                   	leave  
  800db0:	c3                   	ret    

00800db1 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800db1:	55                   	push   %ebp
  800db2:	89 e5                	mov    %esp,%ebp
  800db4:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800db7:	8d 45 10             	lea    0x10(%ebp),%eax
  800dba:	83 c0 04             	add    $0x4,%eax
  800dbd:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  800dc0:	8b 45 10             	mov    0x10(%ebp),%eax
  800dc3:	ff 75 f4             	pushl  -0xc(%ebp)
  800dc6:	50                   	push   %eax
  800dc7:	ff 75 0c             	pushl  0xc(%ebp)
  800dca:	ff 75 08             	pushl  0x8(%ebp)
  800dcd:	e8 89 ff ff ff       	call   800d5b <vsnprintf>
  800dd2:	83 c4 10             	add    $0x10,%esp
  800dd5:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  800dd8:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800ddb:	c9                   	leave  
  800ddc:	c3                   	ret    

00800ddd <strlen>:

#include <inc/string.h>

int
strlen(const char *s)
{
  800ddd:	55                   	push   %ebp
  800dde:	89 e5                	mov    %esp,%ebp
  800de0:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  800de3:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800dea:	eb 06                	jmp    800df2 <strlen+0x15>
		n++;
  800dec:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  800def:	ff 45 08             	incl   0x8(%ebp)
  800df2:	8b 45 08             	mov    0x8(%ebp),%eax
  800df5:	8a 00                	mov    (%eax),%al
  800df7:	84 c0                	test   %al,%al
  800df9:	75 f1                	jne    800dec <strlen+0xf>
		n++;
	return n;
  800dfb:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800dfe:	c9                   	leave  
  800dff:	c3                   	ret    

00800e00 <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  800e00:	55                   	push   %ebp
  800e01:	89 e5                	mov    %esp,%ebp
  800e03:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800e06:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800e0d:	eb 09                	jmp    800e18 <strnlen+0x18>
		n++;
  800e0f:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800e12:	ff 45 08             	incl   0x8(%ebp)
  800e15:	ff 4d 0c             	decl   0xc(%ebp)
  800e18:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800e1c:	74 09                	je     800e27 <strnlen+0x27>
  800e1e:	8b 45 08             	mov    0x8(%ebp),%eax
  800e21:	8a 00                	mov    (%eax),%al
  800e23:	84 c0                	test   %al,%al
  800e25:	75 e8                	jne    800e0f <strnlen+0xf>
		n++;
	return n;
  800e27:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800e2a:	c9                   	leave  
  800e2b:	c3                   	ret    

00800e2c <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800e2c:	55                   	push   %ebp
  800e2d:	89 e5                	mov    %esp,%ebp
  800e2f:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  800e32:	8b 45 08             	mov    0x8(%ebp),%eax
  800e35:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  800e38:	90                   	nop
  800e39:	8b 45 08             	mov    0x8(%ebp),%eax
  800e3c:	8d 50 01             	lea    0x1(%eax),%edx
  800e3f:	89 55 08             	mov    %edx,0x8(%ebp)
  800e42:	8b 55 0c             	mov    0xc(%ebp),%edx
  800e45:	8d 4a 01             	lea    0x1(%edx),%ecx
  800e48:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800e4b:	8a 12                	mov    (%edx),%dl
  800e4d:	88 10                	mov    %dl,(%eax)
  800e4f:	8a 00                	mov    (%eax),%al
  800e51:	84 c0                	test   %al,%al
  800e53:	75 e4                	jne    800e39 <strcpy+0xd>
		/* do nothing */;
	return ret;
  800e55:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800e58:	c9                   	leave  
  800e59:	c3                   	ret    

00800e5a <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  800e5a:	55                   	push   %ebp
  800e5b:	89 e5                	mov    %esp,%ebp
  800e5d:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  800e60:	8b 45 08             	mov    0x8(%ebp),%eax
  800e63:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  800e66:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800e6d:	eb 1f                	jmp    800e8e <strncpy+0x34>
		*dst++ = *src;
  800e6f:	8b 45 08             	mov    0x8(%ebp),%eax
  800e72:	8d 50 01             	lea    0x1(%eax),%edx
  800e75:	89 55 08             	mov    %edx,0x8(%ebp)
  800e78:	8b 55 0c             	mov    0xc(%ebp),%edx
  800e7b:	8a 12                	mov    (%edx),%dl
  800e7d:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  800e7f:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e82:	8a 00                	mov    (%eax),%al
  800e84:	84 c0                	test   %al,%al
  800e86:	74 03                	je     800e8b <strncpy+0x31>
			src++;
  800e88:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800e8b:	ff 45 fc             	incl   -0x4(%ebp)
  800e8e:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800e91:	3b 45 10             	cmp    0x10(%ebp),%eax
  800e94:	72 d9                	jb     800e6f <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  800e96:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  800e99:	c9                   	leave  
  800e9a:	c3                   	ret    

00800e9b <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  800e9b:	55                   	push   %ebp
  800e9c:	89 e5                	mov    %esp,%ebp
  800e9e:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  800ea1:	8b 45 08             	mov    0x8(%ebp),%eax
  800ea4:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  800ea7:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800eab:	74 30                	je     800edd <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  800ead:	eb 16                	jmp    800ec5 <strlcpy+0x2a>
			*dst++ = *src++;
  800eaf:	8b 45 08             	mov    0x8(%ebp),%eax
  800eb2:	8d 50 01             	lea    0x1(%eax),%edx
  800eb5:	89 55 08             	mov    %edx,0x8(%ebp)
  800eb8:	8b 55 0c             	mov    0xc(%ebp),%edx
  800ebb:	8d 4a 01             	lea    0x1(%edx),%ecx
  800ebe:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800ec1:	8a 12                	mov    (%edx),%dl
  800ec3:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  800ec5:	ff 4d 10             	decl   0x10(%ebp)
  800ec8:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800ecc:	74 09                	je     800ed7 <strlcpy+0x3c>
  800ece:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ed1:	8a 00                	mov    (%eax),%al
  800ed3:	84 c0                	test   %al,%al
  800ed5:	75 d8                	jne    800eaf <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  800ed7:	8b 45 08             	mov    0x8(%ebp),%eax
  800eda:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800edd:	8b 55 08             	mov    0x8(%ebp),%edx
  800ee0:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800ee3:	29 c2                	sub    %eax,%edx
  800ee5:	89 d0                	mov    %edx,%eax
}
  800ee7:	c9                   	leave  
  800ee8:	c3                   	ret    

00800ee9 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800ee9:	55                   	push   %ebp
  800eea:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  800eec:	eb 06                	jmp    800ef4 <strcmp+0xb>
		p++, q++;
  800eee:	ff 45 08             	incl   0x8(%ebp)
  800ef1:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  800ef4:	8b 45 08             	mov    0x8(%ebp),%eax
  800ef7:	8a 00                	mov    (%eax),%al
  800ef9:	84 c0                	test   %al,%al
  800efb:	74 0e                	je     800f0b <strcmp+0x22>
  800efd:	8b 45 08             	mov    0x8(%ebp),%eax
  800f00:	8a 10                	mov    (%eax),%dl
  800f02:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f05:	8a 00                	mov    (%eax),%al
  800f07:	38 c2                	cmp    %al,%dl
  800f09:	74 e3                	je     800eee <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800f0b:	8b 45 08             	mov    0x8(%ebp),%eax
  800f0e:	8a 00                	mov    (%eax),%al
  800f10:	0f b6 d0             	movzbl %al,%edx
  800f13:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f16:	8a 00                	mov    (%eax),%al
  800f18:	0f b6 c0             	movzbl %al,%eax
  800f1b:	29 c2                	sub    %eax,%edx
  800f1d:	89 d0                	mov    %edx,%eax
}
  800f1f:	5d                   	pop    %ebp
  800f20:	c3                   	ret    

00800f21 <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  800f21:	55                   	push   %ebp
  800f22:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  800f24:	eb 09                	jmp    800f2f <strncmp+0xe>
		n--, p++, q++;
  800f26:	ff 4d 10             	decl   0x10(%ebp)
  800f29:	ff 45 08             	incl   0x8(%ebp)
  800f2c:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  800f2f:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800f33:	74 17                	je     800f4c <strncmp+0x2b>
  800f35:	8b 45 08             	mov    0x8(%ebp),%eax
  800f38:	8a 00                	mov    (%eax),%al
  800f3a:	84 c0                	test   %al,%al
  800f3c:	74 0e                	je     800f4c <strncmp+0x2b>
  800f3e:	8b 45 08             	mov    0x8(%ebp),%eax
  800f41:	8a 10                	mov    (%eax),%dl
  800f43:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f46:	8a 00                	mov    (%eax),%al
  800f48:	38 c2                	cmp    %al,%dl
  800f4a:	74 da                	je     800f26 <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  800f4c:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800f50:	75 07                	jne    800f59 <strncmp+0x38>
		return 0;
  800f52:	b8 00 00 00 00       	mov    $0x0,%eax
  800f57:	eb 14                	jmp    800f6d <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800f59:	8b 45 08             	mov    0x8(%ebp),%eax
  800f5c:	8a 00                	mov    (%eax),%al
  800f5e:	0f b6 d0             	movzbl %al,%edx
  800f61:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f64:	8a 00                	mov    (%eax),%al
  800f66:	0f b6 c0             	movzbl %al,%eax
  800f69:	29 c2                	sub    %eax,%edx
  800f6b:	89 d0                	mov    %edx,%eax
}
  800f6d:	5d                   	pop    %ebp
  800f6e:	c3                   	ret    

00800f6f <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800f6f:	55                   	push   %ebp
  800f70:	89 e5                	mov    %esp,%ebp
  800f72:	83 ec 04             	sub    $0x4,%esp
  800f75:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f78:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800f7b:	eb 12                	jmp    800f8f <strchr+0x20>
		if (*s == c)
  800f7d:	8b 45 08             	mov    0x8(%ebp),%eax
  800f80:	8a 00                	mov    (%eax),%al
  800f82:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800f85:	75 05                	jne    800f8c <strchr+0x1d>
			return (char *) s;
  800f87:	8b 45 08             	mov    0x8(%ebp),%eax
  800f8a:	eb 11                	jmp    800f9d <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  800f8c:	ff 45 08             	incl   0x8(%ebp)
  800f8f:	8b 45 08             	mov    0x8(%ebp),%eax
  800f92:	8a 00                	mov    (%eax),%al
  800f94:	84 c0                	test   %al,%al
  800f96:	75 e5                	jne    800f7d <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  800f98:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800f9d:	c9                   	leave  
  800f9e:	c3                   	ret    

00800f9f <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800f9f:	55                   	push   %ebp
  800fa0:	89 e5                	mov    %esp,%ebp
  800fa2:	83 ec 04             	sub    $0x4,%esp
  800fa5:	8b 45 0c             	mov    0xc(%ebp),%eax
  800fa8:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800fab:	eb 0d                	jmp    800fba <strfind+0x1b>
		if (*s == c)
  800fad:	8b 45 08             	mov    0x8(%ebp),%eax
  800fb0:	8a 00                	mov    (%eax),%al
  800fb2:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800fb5:	74 0e                	je     800fc5 <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  800fb7:	ff 45 08             	incl   0x8(%ebp)
  800fba:	8b 45 08             	mov    0x8(%ebp),%eax
  800fbd:	8a 00                	mov    (%eax),%al
  800fbf:	84 c0                	test   %al,%al
  800fc1:	75 ea                	jne    800fad <strfind+0xe>
  800fc3:	eb 01                	jmp    800fc6 <strfind+0x27>
		if (*s == c)
			break;
  800fc5:	90                   	nop
	return (char *) s;
  800fc6:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800fc9:	c9                   	leave  
  800fca:	c3                   	ret    

00800fcb <memset>:


void *
memset(void *v, int c, uint32 n)
{
  800fcb:	55                   	push   %ebp
  800fcc:	89 e5                	mov    %esp,%ebp
  800fce:	83 ec 10             	sub    $0x10,%esp
	char *p;
	int m;

	p = v;
  800fd1:	8b 45 08             	mov    0x8(%ebp),%eax
  800fd4:	89 45 fc             	mov    %eax,-0x4(%ebp)
	m = n;
  800fd7:	8b 45 10             	mov    0x10(%ebp),%eax
  800fda:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (--m >= 0)
  800fdd:	eb 0e                	jmp    800fed <memset+0x22>
		*p++ = c;
  800fdf:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800fe2:	8d 50 01             	lea    0x1(%eax),%edx
  800fe5:	89 55 fc             	mov    %edx,-0x4(%ebp)
  800fe8:	8b 55 0c             	mov    0xc(%ebp),%edx
  800feb:	88 10                	mov    %dl,(%eax)
	char *p;
	int m;

	p = v;
	m = n;
	while (--m >= 0)
  800fed:	ff 4d f8             	decl   -0x8(%ebp)
  800ff0:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
  800ff4:	79 e9                	jns    800fdf <memset+0x14>
		*p++ = c;

	return v;
  800ff6:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800ff9:	c9                   	leave  
  800ffa:	c3                   	ret    

00800ffb <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  800ffb:	55                   	push   %ebp
  800ffc:	89 e5                	mov    %esp,%ebp
  800ffe:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  801001:	8b 45 0c             	mov    0xc(%ebp),%eax
  801004:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  801007:	8b 45 08             	mov    0x8(%ebp),%eax
  80100a:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (n-- > 0)
  80100d:	eb 16                	jmp    801025 <memcpy+0x2a>
		*d++ = *s++;
  80100f:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801012:	8d 50 01             	lea    0x1(%eax),%edx
  801015:	89 55 f8             	mov    %edx,-0x8(%ebp)
  801018:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80101b:	8d 4a 01             	lea    0x1(%edx),%ecx
  80101e:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  801021:	8a 12                	mov    (%edx),%dl
  801023:	88 10                	mov    %dl,(%eax)
	const char *s;
	char *d;

	s = src;
	d = dst;
	while (n-- > 0)
  801025:	8b 45 10             	mov    0x10(%ebp),%eax
  801028:	8d 50 ff             	lea    -0x1(%eax),%edx
  80102b:	89 55 10             	mov    %edx,0x10(%ebp)
  80102e:	85 c0                	test   %eax,%eax
  801030:	75 dd                	jne    80100f <memcpy+0x14>
		*d++ = *s++;

	return dst;
  801032:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801035:	c9                   	leave  
  801036:	c3                   	ret    

00801037 <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  801037:	55                   	push   %ebp
  801038:	89 e5                	mov    %esp,%ebp
  80103a:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  80103d:	8b 45 0c             	mov    0xc(%ebp),%eax
  801040:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  801043:	8b 45 08             	mov    0x8(%ebp),%eax
  801046:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  801049:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80104c:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  80104f:	73 50                	jae    8010a1 <memmove+0x6a>
  801051:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801054:	8b 45 10             	mov    0x10(%ebp),%eax
  801057:	01 d0                	add    %edx,%eax
  801059:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  80105c:	76 43                	jbe    8010a1 <memmove+0x6a>
		s += n;
  80105e:	8b 45 10             	mov    0x10(%ebp),%eax
  801061:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  801064:	8b 45 10             	mov    0x10(%ebp),%eax
  801067:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  80106a:	eb 10                	jmp    80107c <memmove+0x45>
			*--d = *--s;
  80106c:	ff 4d f8             	decl   -0x8(%ebp)
  80106f:	ff 4d fc             	decl   -0x4(%ebp)
  801072:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801075:	8a 10                	mov    (%eax),%dl
  801077:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80107a:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  80107c:	8b 45 10             	mov    0x10(%ebp),%eax
  80107f:	8d 50 ff             	lea    -0x1(%eax),%edx
  801082:	89 55 10             	mov    %edx,0x10(%ebp)
  801085:	85 c0                	test   %eax,%eax
  801087:	75 e3                	jne    80106c <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  801089:	eb 23                	jmp    8010ae <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  80108b:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80108e:	8d 50 01             	lea    0x1(%eax),%edx
  801091:	89 55 f8             	mov    %edx,-0x8(%ebp)
  801094:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801097:	8d 4a 01             	lea    0x1(%edx),%ecx
  80109a:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  80109d:	8a 12                	mov    (%edx),%dl
  80109f:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  8010a1:	8b 45 10             	mov    0x10(%ebp),%eax
  8010a4:	8d 50 ff             	lea    -0x1(%eax),%edx
  8010a7:	89 55 10             	mov    %edx,0x10(%ebp)
  8010aa:	85 c0                	test   %eax,%eax
  8010ac:	75 dd                	jne    80108b <memmove+0x54>
			*d++ = *s++;

	return dst;
  8010ae:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8010b1:	c9                   	leave  
  8010b2:	c3                   	ret    

008010b3 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  8010b3:	55                   	push   %ebp
  8010b4:	89 e5                	mov    %esp,%ebp
  8010b6:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  8010b9:	8b 45 08             	mov    0x8(%ebp),%eax
  8010bc:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  8010bf:	8b 45 0c             	mov    0xc(%ebp),%eax
  8010c2:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  8010c5:	eb 2a                	jmp    8010f1 <memcmp+0x3e>
		if (*s1 != *s2)
  8010c7:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8010ca:	8a 10                	mov    (%eax),%dl
  8010cc:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8010cf:	8a 00                	mov    (%eax),%al
  8010d1:	38 c2                	cmp    %al,%dl
  8010d3:	74 16                	je     8010eb <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  8010d5:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8010d8:	8a 00                	mov    (%eax),%al
  8010da:	0f b6 d0             	movzbl %al,%edx
  8010dd:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8010e0:	8a 00                	mov    (%eax),%al
  8010e2:	0f b6 c0             	movzbl %al,%eax
  8010e5:	29 c2                	sub    %eax,%edx
  8010e7:	89 d0                	mov    %edx,%eax
  8010e9:	eb 18                	jmp    801103 <memcmp+0x50>
		s1++, s2++;
  8010eb:	ff 45 fc             	incl   -0x4(%ebp)
  8010ee:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  8010f1:	8b 45 10             	mov    0x10(%ebp),%eax
  8010f4:	8d 50 ff             	lea    -0x1(%eax),%edx
  8010f7:	89 55 10             	mov    %edx,0x10(%ebp)
  8010fa:	85 c0                	test   %eax,%eax
  8010fc:	75 c9                	jne    8010c7 <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  8010fe:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801103:	c9                   	leave  
  801104:	c3                   	ret    

00801105 <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  801105:	55                   	push   %ebp
  801106:	89 e5                	mov    %esp,%ebp
  801108:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  80110b:	8b 55 08             	mov    0x8(%ebp),%edx
  80110e:	8b 45 10             	mov    0x10(%ebp),%eax
  801111:	01 d0                	add    %edx,%eax
  801113:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  801116:	eb 15                	jmp    80112d <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  801118:	8b 45 08             	mov    0x8(%ebp),%eax
  80111b:	8a 00                	mov    (%eax),%al
  80111d:	0f b6 d0             	movzbl %al,%edx
  801120:	8b 45 0c             	mov    0xc(%ebp),%eax
  801123:	0f b6 c0             	movzbl %al,%eax
  801126:	39 c2                	cmp    %eax,%edx
  801128:	74 0d                	je     801137 <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  80112a:	ff 45 08             	incl   0x8(%ebp)
  80112d:	8b 45 08             	mov    0x8(%ebp),%eax
  801130:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  801133:	72 e3                	jb     801118 <memfind+0x13>
  801135:	eb 01                	jmp    801138 <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  801137:	90                   	nop
	return (void *) s;
  801138:	8b 45 08             	mov    0x8(%ebp),%eax
}
  80113b:	c9                   	leave  
  80113c:	c3                   	ret    

0080113d <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  80113d:	55                   	push   %ebp
  80113e:	89 e5                	mov    %esp,%ebp
  801140:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  801143:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  80114a:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801151:	eb 03                	jmp    801156 <strtol+0x19>
		s++;
  801153:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801156:	8b 45 08             	mov    0x8(%ebp),%eax
  801159:	8a 00                	mov    (%eax),%al
  80115b:	3c 20                	cmp    $0x20,%al
  80115d:	74 f4                	je     801153 <strtol+0x16>
  80115f:	8b 45 08             	mov    0x8(%ebp),%eax
  801162:	8a 00                	mov    (%eax),%al
  801164:	3c 09                	cmp    $0x9,%al
  801166:	74 eb                	je     801153 <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  801168:	8b 45 08             	mov    0x8(%ebp),%eax
  80116b:	8a 00                	mov    (%eax),%al
  80116d:	3c 2b                	cmp    $0x2b,%al
  80116f:	75 05                	jne    801176 <strtol+0x39>
		s++;
  801171:	ff 45 08             	incl   0x8(%ebp)
  801174:	eb 13                	jmp    801189 <strtol+0x4c>
	else if (*s == '-')
  801176:	8b 45 08             	mov    0x8(%ebp),%eax
  801179:	8a 00                	mov    (%eax),%al
  80117b:	3c 2d                	cmp    $0x2d,%al
  80117d:	75 0a                	jne    801189 <strtol+0x4c>
		s++, neg = 1;
  80117f:	ff 45 08             	incl   0x8(%ebp)
  801182:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  801189:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80118d:	74 06                	je     801195 <strtol+0x58>
  80118f:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  801193:	75 20                	jne    8011b5 <strtol+0x78>
  801195:	8b 45 08             	mov    0x8(%ebp),%eax
  801198:	8a 00                	mov    (%eax),%al
  80119a:	3c 30                	cmp    $0x30,%al
  80119c:	75 17                	jne    8011b5 <strtol+0x78>
  80119e:	8b 45 08             	mov    0x8(%ebp),%eax
  8011a1:	40                   	inc    %eax
  8011a2:	8a 00                	mov    (%eax),%al
  8011a4:	3c 78                	cmp    $0x78,%al
  8011a6:	75 0d                	jne    8011b5 <strtol+0x78>
		s += 2, base = 16;
  8011a8:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  8011ac:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  8011b3:	eb 28                	jmp    8011dd <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  8011b5:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8011b9:	75 15                	jne    8011d0 <strtol+0x93>
  8011bb:	8b 45 08             	mov    0x8(%ebp),%eax
  8011be:	8a 00                	mov    (%eax),%al
  8011c0:	3c 30                	cmp    $0x30,%al
  8011c2:	75 0c                	jne    8011d0 <strtol+0x93>
		s++, base = 8;
  8011c4:	ff 45 08             	incl   0x8(%ebp)
  8011c7:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  8011ce:	eb 0d                	jmp    8011dd <strtol+0xa0>
	else if (base == 0)
  8011d0:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8011d4:	75 07                	jne    8011dd <strtol+0xa0>
		base = 10;
  8011d6:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  8011dd:	8b 45 08             	mov    0x8(%ebp),%eax
  8011e0:	8a 00                	mov    (%eax),%al
  8011e2:	3c 2f                	cmp    $0x2f,%al
  8011e4:	7e 19                	jle    8011ff <strtol+0xc2>
  8011e6:	8b 45 08             	mov    0x8(%ebp),%eax
  8011e9:	8a 00                	mov    (%eax),%al
  8011eb:	3c 39                	cmp    $0x39,%al
  8011ed:	7f 10                	jg     8011ff <strtol+0xc2>
			dig = *s - '0';
  8011ef:	8b 45 08             	mov    0x8(%ebp),%eax
  8011f2:	8a 00                	mov    (%eax),%al
  8011f4:	0f be c0             	movsbl %al,%eax
  8011f7:	83 e8 30             	sub    $0x30,%eax
  8011fa:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8011fd:	eb 42                	jmp    801241 <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  8011ff:	8b 45 08             	mov    0x8(%ebp),%eax
  801202:	8a 00                	mov    (%eax),%al
  801204:	3c 60                	cmp    $0x60,%al
  801206:	7e 19                	jle    801221 <strtol+0xe4>
  801208:	8b 45 08             	mov    0x8(%ebp),%eax
  80120b:	8a 00                	mov    (%eax),%al
  80120d:	3c 7a                	cmp    $0x7a,%al
  80120f:	7f 10                	jg     801221 <strtol+0xe4>
			dig = *s - 'a' + 10;
  801211:	8b 45 08             	mov    0x8(%ebp),%eax
  801214:	8a 00                	mov    (%eax),%al
  801216:	0f be c0             	movsbl %al,%eax
  801219:	83 e8 57             	sub    $0x57,%eax
  80121c:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80121f:	eb 20                	jmp    801241 <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  801221:	8b 45 08             	mov    0x8(%ebp),%eax
  801224:	8a 00                	mov    (%eax),%al
  801226:	3c 40                	cmp    $0x40,%al
  801228:	7e 39                	jle    801263 <strtol+0x126>
  80122a:	8b 45 08             	mov    0x8(%ebp),%eax
  80122d:	8a 00                	mov    (%eax),%al
  80122f:	3c 5a                	cmp    $0x5a,%al
  801231:	7f 30                	jg     801263 <strtol+0x126>
			dig = *s - 'A' + 10;
  801233:	8b 45 08             	mov    0x8(%ebp),%eax
  801236:	8a 00                	mov    (%eax),%al
  801238:	0f be c0             	movsbl %al,%eax
  80123b:	83 e8 37             	sub    $0x37,%eax
  80123e:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  801241:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801244:	3b 45 10             	cmp    0x10(%ebp),%eax
  801247:	7d 19                	jge    801262 <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  801249:	ff 45 08             	incl   0x8(%ebp)
  80124c:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80124f:	0f af 45 10          	imul   0x10(%ebp),%eax
  801253:	89 c2                	mov    %eax,%edx
  801255:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801258:	01 d0                	add    %edx,%eax
  80125a:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  80125d:	e9 7b ff ff ff       	jmp    8011dd <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  801262:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  801263:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801267:	74 08                	je     801271 <strtol+0x134>
		*endptr = (char *) s;
  801269:	8b 45 0c             	mov    0xc(%ebp),%eax
  80126c:	8b 55 08             	mov    0x8(%ebp),%edx
  80126f:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  801271:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801275:	74 07                	je     80127e <strtol+0x141>
  801277:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80127a:	f7 d8                	neg    %eax
  80127c:	eb 03                	jmp    801281 <strtol+0x144>
  80127e:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  801281:	c9                   	leave  
  801282:	c3                   	ret    

00801283 <ltostr>:

void
ltostr(long value, char *str)
{
  801283:	55                   	push   %ebp
  801284:	89 e5                	mov    %esp,%ebp
  801286:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  801289:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  801290:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  801297:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80129b:	79 13                	jns    8012b0 <ltostr+0x2d>
	{
		neg = 1;
  80129d:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  8012a4:	8b 45 0c             	mov    0xc(%ebp),%eax
  8012a7:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  8012aa:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  8012ad:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  8012b0:	8b 45 08             	mov    0x8(%ebp),%eax
  8012b3:	b9 0a 00 00 00       	mov    $0xa,%ecx
  8012b8:	99                   	cltd   
  8012b9:	f7 f9                	idiv   %ecx
  8012bb:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  8012be:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8012c1:	8d 50 01             	lea    0x1(%eax),%edx
  8012c4:	89 55 f8             	mov    %edx,-0x8(%ebp)
  8012c7:	89 c2                	mov    %eax,%edx
  8012c9:	8b 45 0c             	mov    0xc(%ebp),%eax
  8012cc:	01 d0                	add    %edx,%eax
  8012ce:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8012d1:	83 c2 30             	add    $0x30,%edx
  8012d4:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  8012d6:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8012d9:	b8 67 66 66 66       	mov    $0x66666667,%eax
  8012de:	f7 e9                	imul   %ecx
  8012e0:	c1 fa 02             	sar    $0x2,%edx
  8012e3:	89 c8                	mov    %ecx,%eax
  8012e5:	c1 f8 1f             	sar    $0x1f,%eax
  8012e8:	29 c2                	sub    %eax,%edx
  8012ea:	89 d0                	mov    %edx,%eax
  8012ec:	89 45 08             	mov    %eax,0x8(%ebp)
	} while (value % 10 != 0);
  8012ef:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8012f2:	b8 67 66 66 66       	mov    $0x66666667,%eax
  8012f7:	f7 e9                	imul   %ecx
  8012f9:	c1 fa 02             	sar    $0x2,%edx
  8012fc:	89 c8                	mov    %ecx,%eax
  8012fe:	c1 f8 1f             	sar    $0x1f,%eax
  801301:	29 c2                	sub    %eax,%edx
  801303:	89 d0                	mov    %edx,%eax
  801305:	c1 e0 02             	shl    $0x2,%eax
  801308:	01 d0                	add    %edx,%eax
  80130a:	01 c0                	add    %eax,%eax
  80130c:	29 c1                	sub    %eax,%ecx
  80130e:	89 ca                	mov    %ecx,%edx
  801310:	85 d2                	test   %edx,%edx
  801312:	75 9c                	jne    8012b0 <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  801314:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  80131b:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80131e:	48                   	dec    %eax
  80131f:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  801322:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801326:	74 3d                	je     801365 <ltostr+0xe2>
		start = 1 ;
  801328:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  80132f:	eb 34                	jmp    801365 <ltostr+0xe2>
	{
		char tmp = str[start] ;
  801331:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801334:	8b 45 0c             	mov    0xc(%ebp),%eax
  801337:	01 d0                	add    %edx,%eax
  801339:	8a 00                	mov    (%eax),%al
  80133b:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  80133e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801341:	8b 45 0c             	mov    0xc(%ebp),%eax
  801344:	01 c2                	add    %eax,%edx
  801346:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  801349:	8b 45 0c             	mov    0xc(%ebp),%eax
  80134c:	01 c8                	add    %ecx,%eax
  80134e:	8a 00                	mov    (%eax),%al
  801350:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  801352:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801355:	8b 45 0c             	mov    0xc(%ebp),%eax
  801358:	01 c2                	add    %eax,%edx
  80135a:	8a 45 eb             	mov    -0x15(%ebp),%al
  80135d:	88 02                	mov    %al,(%edx)
		start++ ;
  80135f:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  801362:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  801365:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801368:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  80136b:	7c c4                	jl     801331 <ltostr+0xae>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  80136d:	8b 55 f8             	mov    -0x8(%ebp),%edx
  801370:	8b 45 0c             	mov    0xc(%ebp),%eax
  801373:	01 d0                	add    %edx,%eax
  801375:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  801378:	90                   	nop
  801379:	c9                   	leave  
  80137a:	c3                   	ret    

0080137b <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  80137b:	55                   	push   %ebp
  80137c:	89 e5                	mov    %esp,%ebp
  80137e:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  801381:	ff 75 08             	pushl  0x8(%ebp)
  801384:	e8 54 fa ff ff       	call   800ddd <strlen>
  801389:	83 c4 04             	add    $0x4,%esp
  80138c:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  80138f:	ff 75 0c             	pushl  0xc(%ebp)
  801392:	e8 46 fa ff ff       	call   800ddd <strlen>
  801397:	83 c4 04             	add    $0x4,%esp
  80139a:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  80139d:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  8013a4:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8013ab:	eb 17                	jmp    8013c4 <strcconcat+0x49>
		final[s] = str1[s] ;
  8013ad:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8013b0:	8b 45 10             	mov    0x10(%ebp),%eax
  8013b3:	01 c2                	add    %eax,%edx
  8013b5:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  8013b8:	8b 45 08             	mov    0x8(%ebp),%eax
  8013bb:	01 c8                	add    %ecx,%eax
  8013bd:	8a 00                	mov    (%eax),%al
  8013bf:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  8013c1:	ff 45 fc             	incl   -0x4(%ebp)
  8013c4:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8013c7:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  8013ca:	7c e1                	jl     8013ad <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  8013cc:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  8013d3:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  8013da:	eb 1f                	jmp    8013fb <strcconcat+0x80>
		final[s++] = str2[i] ;
  8013dc:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8013df:	8d 50 01             	lea    0x1(%eax),%edx
  8013e2:	89 55 fc             	mov    %edx,-0x4(%ebp)
  8013e5:	89 c2                	mov    %eax,%edx
  8013e7:	8b 45 10             	mov    0x10(%ebp),%eax
  8013ea:	01 c2                	add    %eax,%edx
  8013ec:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  8013ef:	8b 45 0c             	mov    0xc(%ebp),%eax
  8013f2:	01 c8                	add    %ecx,%eax
  8013f4:	8a 00                	mov    (%eax),%al
  8013f6:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  8013f8:	ff 45 f8             	incl   -0x8(%ebp)
  8013fb:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8013fe:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801401:	7c d9                	jl     8013dc <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  801403:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801406:	8b 45 10             	mov    0x10(%ebp),%eax
  801409:	01 d0                	add    %edx,%eax
  80140b:	c6 00 00             	movb   $0x0,(%eax)
}
  80140e:	90                   	nop
  80140f:	c9                   	leave  
  801410:	c3                   	ret    

00801411 <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  801411:	55                   	push   %ebp
  801412:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  801414:	8b 45 14             	mov    0x14(%ebp),%eax
  801417:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  80141d:	8b 45 14             	mov    0x14(%ebp),%eax
  801420:	8b 00                	mov    (%eax),%eax
  801422:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801429:	8b 45 10             	mov    0x10(%ebp),%eax
  80142c:	01 d0                	add    %edx,%eax
  80142e:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801434:	eb 0c                	jmp    801442 <strsplit+0x31>
			*string++ = 0;
  801436:	8b 45 08             	mov    0x8(%ebp),%eax
  801439:	8d 50 01             	lea    0x1(%eax),%edx
  80143c:	89 55 08             	mov    %edx,0x8(%ebp)
  80143f:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801442:	8b 45 08             	mov    0x8(%ebp),%eax
  801445:	8a 00                	mov    (%eax),%al
  801447:	84 c0                	test   %al,%al
  801449:	74 18                	je     801463 <strsplit+0x52>
  80144b:	8b 45 08             	mov    0x8(%ebp),%eax
  80144e:	8a 00                	mov    (%eax),%al
  801450:	0f be c0             	movsbl %al,%eax
  801453:	50                   	push   %eax
  801454:	ff 75 0c             	pushl  0xc(%ebp)
  801457:	e8 13 fb ff ff       	call   800f6f <strchr>
  80145c:	83 c4 08             	add    $0x8,%esp
  80145f:	85 c0                	test   %eax,%eax
  801461:	75 d3                	jne    801436 <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  801463:	8b 45 08             	mov    0x8(%ebp),%eax
  801466:	8a 00                	mov    (%eax),%al
  801468:	84 c0                	test   %al,%al
  80146a:	74 5a                	je     8014c6 <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  80146c:	8b 45 14             	mov    0x14(%ebp),%eax
  80146f:	8b 00                	mov    (%eax),%eax
  801471:	83 f8 0f             	cmp    $0xf,%eax
  801474:	75 07                	jne    80147d <strsplit+0x6c>
		{
			return 0;
  801476:	b8 00 00 00 00       	mov    $0x0,%eax
  80147b:	eb 66                	jmp    8014e3 <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  80147d:	8b 45 14             	mov    0x14(%ebp),%eax
  801480:	8b 00                	mov    (%eax),%eax
  801482:	8d 48 01             	lea    0x1(%eax),%ecx
  801485:	8b 55 14             	mov    0x14(%ebp),%edx
  801488:	89 0a                	mov    %ecx,(%edx)
  80148a:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801491:	8b 45 10             	mov    0x10(%ebp),%eax
  801494:	01 c2                	add    %eax,%edx
  801496:	8b 45 08             	mov    0x8(%ebp),%eax
  801499:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  80149b:	eb 03                	jmp    8014a0 <strsplit+0x8f>
			string++;
  80149d:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  8014a0:	8b 45 08             	mov    0x8(%ebp),%eax
  8014a3:	8a 00                	mov    (%eax),%al
  8014a5:	84 c0                	test   %al,%al
  8014a7:	74 8b                	je     801434 <strsplit+0x23>
  8014a9:	8b 45 08             	mov    0x8(%ebp),%eax
  8014ac:	8a 00                	mov    (%eax),%al
  8014ae:	0f be c0             	movsbl %al,%eax
  8014b1:	50                   	push   %eax
  8014b2:	ff 75 0c             	pushl  0xc(%ebp)
  8014b5:	e8 b5 fa ff ff       	call   800f6f <strchr>
  8014ba:	83 c4 08             	add    $0x8,%esp
  8014bd:	85 c0                	test   %eax,%eax
  8014bf:	74 dc                	je     80149d <strsplit+0x8c>
			string++;
	}
  8014c1:	e9 6e ff ff ff       	jmp    801434 <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  8014c6:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  8014c7:	8b 45 14             	mov    0x14(%ebp),%eax
  8014ca:	8b 00                	mov    (%eax),%eax
  8014cc:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8014d3:	8b 45 10             	mov    0x10(%ebp),%eax
  8014d6:	01 d0                	add    %edx,%eax
  8014d8:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  8014de:	b8 01 00 00 00       	mov    $0x1,%eax
}
  8014e3:	c9                   	leave  
  8014e4:	c3                   	ret    

008014e5 <InitializeUHeap>:
//============================== GIVEN FUNCTIONS ===================================//
//==================================================================================//

int FirstTimeFlag = 1;
void InitializeUHeap()
{
  8014e5:	55                   	push   %ebp
  8014e6:	89 e5                	mov    %esp,%ebp
  8014e8:	83 ec 08             	sub    $0x8,%esp
	if(FirstTimeFlag)
  8014eb:	a1 04 40 80 00       	mov    0x804004,%eax
  8014f0:	85 c0                	test   %eax,%eax
  8014f2:	74 1f                	je     801513 <InitializeUHeap+0x2e>
	{
		initialize_dyn_block_system();
  8014f4:	e8 1d 00 00 00       	call   801516 <initialize_dyn_block_system>
		cprintf("DYNAMIC BLOCK SYSTEM IS INITIALIZED\n");
  8014f9:	83 ec 0c             	sub    $0xc,%esp
  8014fc:	68 90 3b 80 00       	push   $0x803b90
  801501:	e8 55 f2 ff ff       	call   80075b <cprintf>
  801506:	83 c4 10             	add    $0x10,%esp
#if UHP_USE_BUDDY
		initialize_buddy();
		cprintf("BUDDY SYSTEM IS INITIALIZED\n");
#endif
		FirstTimeFlag = 0;
  801509:	c7 05 04 40 80 00 00 	movl   $0x0,0x804004
  801510:	00 00 00 
	}
}
  801513:	90                   	nop
  801514:	c9                   	leave  
  801515:	c3                   	ret    

00801516 <initialize_dyn_block_system>:

//=================================
// [1] INITIALIZE DYNAMIC ALLOCATOR:
//=================================
void initialize_dyn_block_system()
{
  801516:	55                   	push   %ebp
  801517:	89 e5                	mov    %esp,%ebp
  801519:	83 ec 28             	sub    $0x28,%esp
	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] initialize_dyn_block_system
	// your code is here, remove the panic and write your code
	//panic("initialize_dyn_block_system() is not implemented yet...!!");

	LIST_INIT(&AllocMemBlocksList);
  80151c:	c7 05 40 40 80 00 00 	movl   $0x0,0x804040
  801523:	00 00 00 
  801526:	c7 05 44 40 80 00 00 	movl   $0x0,0x804044
  80152d:	00 00 00 
  801530:	c7 05 4c 40 80 00 00 	movl   $0x0,0x80404c
  801537:	00 00 00 
	LIST_INIT(&FreeMemBlocksList);
  80153a:	c7 05 38 41 80 00 00 	movl   $0x0,0x804138
  801541:	00 00 00 
  801544:	c7 05 3c 41 80 00 00 	movl   $0x0,0x80413c
  80154b:	00 00 00 
  80154e:	c7 05 44 41 80 00 00 	movl   $0x0,0x804144
  801555:	00 00 00 
	MAX_MEM_BLOCK_CNT = NUM_OF_UHEAP_PAGES;
  801558:	c7 05 20 41 80 00 00 	movl   $0x20000,0x804120
  80155f:	00 02 00 
	MemBlockNodes = (void*)USER_DYN_BLKS_ARRAY;
  801562:	c7 45 f4 00 00 e0 7f 	movl   $0x7fe00000,-0xc(%ebp)
  801569:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80156c:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801571:	2d 00 10 00 00       	sub    $0x1000,%eax
  801576:	a3 50 40 80 00       	mov    %eax,0x804050
	int size_of_block = sizeof(struct MemBlock);
  80157b:	c7 45 f0 10 00 00 00 	movl   $0x10,-0x10(%ebp)
	int size_all_struct = size_of_block*MAX_MEM_BLOCK_CNT;
  801582:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801585:	a1 20 41 80 00       	mov    0x804120,%eax
  80158a:	0f af c2             	imul   %edx,%eax
  80158d:	89 45 ec             	mov    %eax,-0x14(%ebp)
	size_all_struct = ROUNDUP(size_all_struct, PAGE_SIZE);
  801590:	c7 45 e8 00 10 00 00 	movl   $0x1000,-0x18(%ebp)
  801597:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80159a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80159d:	01 d0                	add    %edx,%eax
  80159f:	48                   	dec    %eax
  8015a0:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8015a3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8015a6:	ba 00 00 00 00       	mov    $0x0,%edx
  8015ab:	f7 75 e8             	divl   -0x18(%ebp)
  8015ae:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8015b1:	29 d0                	sub    %edx,%eax
  8015b3:	89 45 ec             	mov    %eax,-0x14(%ebp)
	sys_allocate_chunk(USER_DYN_BLKS_ARRAY, size_all_struct,PERM_USER| PERM_WRITEABLE);
  8015b6:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8015b9:	c7 45 e0 00 00 e0 7f 	movl   $0x7fe00000,-0x20(%ebp)
  8015c0:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8015c3:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
  8015c9:	81 ea 00 10 00 00    	sub    $0x1000,%edx
  8015cf:	83 ec 04             	sub    $0x4,%esp
  8015d2:	6a 06                	push   $0x6
  8015d4:	50                   	push   %eax
  8015d5:	52                   	push   %edx
  8015d6:	e8 a1 05 00 00       	call   801b7c <sys_allocate_chunk>
  8015db:	83 c4 10             	add    $0x10,%esp
	initialize_MemBlocksList(MAX_MEM_BLOCK_CNT);
  8015de:	a1 20 41 80 00       	mov    0x804120,%eax
  8015e3:	83 ec 0c             	sub    $0xc,%esp
  8015e6:	50                   	push   %eax
  8015e7:	e8 16 0c 00 00       	call   802202 <initialize_MemBlocksList>
  8015ec:	83 c4 10             	add    $0x10,%esp
	struct MemBlock* ourBlock =LIST_LAST(&AvailableMemBlocksList);
  8015ef:	a1 4c 41 80 00       	mov    0x80414c,%eax
  8015f4:	89 45 dc             	mov    %eax,-0x24(%ebp)
	LIST_REMOVE(&AvailableMemBlocksList,ourBlock);
  8015f7:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  8015fb:	75 14                	jne    801611 <initialize_dyn_block_system+0xfb>
  8015fd:	83 ec 04             	sub    $0x4,%esp
  801600:	68 b5 3b 80 00       	push   $0x803bb5
  801605:	6a 2d                	push   $0x2d
  801607:	68 d3 3b 80 00       	push   $0x803bd3
  80160c:	e8 96 ee ff ff       	call   8004a7 <_panic>
  801611:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801614:	8b 00                	mov    (%eax),%eax
  801616:	85 c0                	test   %eax,%eax
  801618:	74 10                	je     80162a <initialize_dyn_block_system+0x114>
  80161a:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80161d:	8b 00                	mov    (%eax),%eax
  80161f:	8b 55 dc             	mov    -0x24(%ebp),%edx
  801622:	8b 52 04             	mov    0x4(%edx),%edx
  801625:	89 50 04             	mov    %edx,0x4(%eax)
  801628:	eb 0b                	jmp    801635 <initialize_dyn_block_system+0x11f>
  80162a:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80162d:	8b 40 04             	mov    0x4(%eax),%eax
  801630:	a3 4c 41 80 00       	mov    %eax,0x80414c
  801635:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801638:	8b 40 04             	mov    0x4(%eax),%eax
  80163b:	85 c0                	test   %eax,%eax
  80163d:	74 0f                	je     80164e <initialize_dyn_block_system+0x138>
  80163f:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801642:	8b 40 04             	mov    0x4(%eax),%eax
  801645:	8b 55 dc             	mov    -0x24(%ebp),%edx
  801648:	8b 12                	mov    (%edx),%edx
  80164a:	89 10                	mov    %edx,(%eax)
  80164c:	eb 0a                	jmp    801658 <initialize_dyn_block_system+0x142>
  80164e:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801651:	8b 00                	mov    (%eax),%eax
  801653:	a3 48 41 80 00       	mov    %eax,0x804148
  801658:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80165b:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  801661:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801664:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80166b:	a1 54 41 80 00       	mov    0x804154,%eax
  801670:	48                   	dec    %eax
  801671:	a3 54 41 80 00       	mov    %eax,0x804154
	ourBlock->size = USER_HEAP_MAX-USER_HEAP_START;
  801676:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801679:	c7 40 0c 00 00 00 20 	movl   $0x20000000,0xc(%eax)
	ourBlock->sva=USER_HEAP_START;
  801680:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801683:	c7 40 08 00 00 00 80 	movl   $0x80000000,0x8(%eax)
	LIST_INSERT_TAIL(&FreeMemBlocksList, ourBlock);
  80168a:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  80168e:	75 14                	jne    8016a4 <initialize_dyn_block_system+0x18e>
  801690:	83 ec 04             	sub    $0x4,%esp
  801693:	68 e0 3b 80 00       	push   $0x803be0
  801698:	6a 30                	push   $0x30
  80169a:	68 d3 3b 80 00       	push   $0x803bd3
  80169f:	e8 03 ee ff ff       	call   8004a7 <_panic>
  8016a4:	8b 15 3c 41 80 00    	mov    0x80413c,%edx
  8016aa:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8016ad:	89 50 04             	mov    %edx,0x4(%eax)
  8016b0:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8016b3:	8b 40 04             	mov    0x4(%eax),%eax
  8016b6:	85 c0                	test   %eax,%eax
  8016b8:	74 0c                	je     8016c6 <initialize_dyn_block_system+0x1b0>
  8016ba:	a1 3c 41 80 00       	mov    0x80413c,%eax
  8016bf:	8b 55 dc             	mov    -0x24(%ebp),%edx
  8016c2:	89 10                	mov    %edx,(%eax)
  8016c4:	eb 08                	jmp    8016ce <initialize_dyn_block_system+0x1b8>
  8016c6:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8016c9:	a3 38 41 80 00       	mov    %eax,0x804138
  8016ce:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8016d1:	a3 3c 41 80 00       	mov    %eax,0x80413c
  8016d6:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8016d9:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8016df:	a1 44 41 80 00       	mov    0x804144,%eax
  8016e4:	40                   	inc    %eax
  8016e5:	a3 44 41 80 00       	mov    %eax,0x804144
	//[1] Initialize two lists (AllocMemBlocksList & FreeMemBlocksList) [Hint: use LIST_INIT()]
	//[2] Dynamically allocate the array of MemBlockNodes at VA USER_DYN_BLKS_ARRAY
	//	  (remember to set MAX_MEM_BLOCK_CNT with the chosen size of the array)
	//[3] Initialize AvailableMemBlocksList by filling it with the MemBlockNodes
	//[4] Insert a new MemBlock with the heap size into the FreeMemBlocksList
}
  8016ea:	90                   	nop
  8016eb:	c9                   	leave  
  8016ec:	c3                   	ret    

008016ed <malloc>:
//=================================
// [2] ALLOCATE SPACE IN USER HEAP:
//=================================

void* malloc(uint32 size)
{
  8016ed:	55                   	push   %ebp
  8016ee:	89 e5                	mov    %esp,%ebp
  8016f0:	83 ec 18             	sub    $0x18,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  8016f3:	e8 ed fd ff ff       	call   8014e5 <InitializeUHeap>
	if (size == 0) return NULL ;
  8016f8:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8016fc:	75 07                	jne    801705 <malloc+0x18>
  8016fe:	b8 00 00 00 00       	mov    $0x0,%eax
  801703:	eb 67                	jmp    80176c <malloc+0x7f>

	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] malloc
	// your code is here, remove the panic and write your code
	//panic("malloc() is not implemented yet...!!");

	size = ROUNDUP(size, PAGE_SIZE);
  801705:	c7 45 f4 00 10 00 00 	movl   $0x1000,-0xc(%ebp)
  80170c:	8b 55 08             	mov    0x8(%ebp),%edx
  80170f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801712:	01 d0                	add    %edx,%eax
  801714:	48                   	dec    %eax
  801715:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801718:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80171b:	ba 00 00 00 00       	mov    $0x0,%edx
  801720:	f7 75 f4             	divl   -0xc(%ebp)
  801723:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801726:	29 d0                	sub    %edx,%eax
  801728:	89 45 08             	mov    %eax,0x8(%ebp)
	if(sys_isUHeapPlacementStrategyFIRSTFIT())
  80172b:	e8 1a 08 00 00       	call   801f4a <sys_isUHeapPlacementStrategyFIRSTFIT>
  801730:	85 c0                	test   %eax,%eax
  801732:	74 33                	je     801767 <malloc+0x7a>
	{
		struct MemBlock * myBlock = alloc_block_FF(size);
  801734:	83 ec 0c             	sub    $0xc,%esp
  801737:	ff 75 08             	pushl  0x8(%ebp)
  80173a:	e8 0c 0e 00 00       	call   80254b <alloc_block_FF>
  80173f:	83 c4 10             	add    $0x10,%esp
  801742:	89 45 ec             	mov    %eax,-0x14(%ebp)
		if(myBlock != NULL)
  801745:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  801749:	74 1c                	je     801767 <malloc+0x7a>
		{
			insert_sorted_allocList(myBlock);
  80174b:	83 ec 0c             	sub    $0xc,%esp
  80174e:	ff 75 ec             	pushl  -0x14(%ebp)
  801751:	e8 07 0c 00 00       	call   80235d <insert_sorted_allocList>
  801756:	83 c4 10             	add    $0x10,%esp
			uint32 ptr = myBlock->sva;
  801759:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80175c:	8b 40 08             	mov    0x8(%eax),%eax
  80175f:	89 45 e8             	mov    %eax,-0x18(%ebp)
			return (void *)ptr;
  801762:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801765:	eb 05                	jmp    80176c <malloc+0x7f>
		}
	}
	return NULL;
  801767:	b8 00 00 00 00       	mov    $0x0,%eax
	//		to the required allocation size (space should be on 4 KB BOUNDARY)
	//	2) if no suitable space found, return NULL
	// 	3) Return pointer containing the virtual address of allocated space,
	//
	//Use sys_isUHeapPlacementStrategyFIRSTFIT()... to check the current strategy
}
  80176c:	c9                   	leave  
  80176d:	c3                   	ret    

0080176e <free>:
//	We can use sys_free_user_mem(uint32 virtual_address, uint32 size); which
//		switches to the kernel mode, calls free_user_mem() in
//		"kern/mem/chunk_operations.c", then switch back to the user mode here
//	the free_user_mem function is empty, make sure to implement it.
void free(void* virtual_address)
{
  80176e:	55                   	push   %ebp
  80176f:	89 e5                	mov    %esp,%ebp
  801771:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] free
	// your code is here, remove the panic and write your code
	//panic("free() is not implemented yet...!!");

	uint32 virtualAddress = (uint32 )(virtual_address);
  801774:	8b 45 08             	mov    0x8(%ebp),%eax
  801777:	89 45 f4             	mov    %eax,-0xc(%ebp)
//	virtualAddress = ROUNDDOWN(virtualAddress, PAGE_SIZE);
	struct MemBlock * myBlock = find_block(&AllocMemBlocksList, virtualAddress);
  80177a:	83 ec 08             	sub    $0x8,%esp
  80177d:	ff 75 f4             	pushl  -0xc(%ebp)
  801780:	68 40 40 80 00       	push   $0x804040
  801785:	e8 5b 0b 00 00       	call   8022e5 <find_block>
  80178a:	83 c4 10             	add    $0x10,%esp
  80178d:	89 45 f0             	mov    %eax,-0x10(%ebp)
//	cprintf ("ptr sva at free user side = %x \n", myBlock->sva);
	sys_free_user_mem(virtualAddress, myBlock->size);
  801790:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801793:	8b 40 0c             	mov    0xc(%eax),%eax
  801796:	83 ec 08             	sub    $0x8,%esp
  801799:	50                   	push   %eax
  80179a:	ff 75 f4             	pushl  -0xc(%ebp)
  80179d:	e8 a2 03 00 00       	call   801b44 <sys_free_user_mem>
  8017a2:	83 c4 10             	add    $0x10,%esp
	LIST_REMOVE(&AllocMemBlocksList, myBlock);
  8017a5:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8017a9:	75 14                	jne    8017bf <free+0x51>
  8017ab:	83 ec 04             	sub    $0x4,%esp
  8017ae:	68 b5 3b 80 00       	push   $0x803bb5
  8017b3:	6a 76                	push   $0x76
  8017b5:	68 d3 3b 80 00       	push   $0x803bd3
  8017ba:	e8 e8 ec ff ff       	call   8004a7 <_panic>
  8017bf:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8017c2:	8b 00                	mov    (%eax),%eax
  8017c4:	85 c0                	test   %eax,%eax
  8017c6:	74 10                	je     8017d8 <free+0x6a>
  8017c8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8017cb:	8b 00                	mov    (%eax),%eax
  8017cd:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8017d0:	8b 52 04             	mov    0x4(%edx),%edx
  8017d3:	89 50 04             	mov    %edx,0x4(%eax)
  8017d6:	eb 0b                	jmp    8017e3 <free+0x75>
  8017d8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8017db:	8b 40 04             	mov    0x4(%eax),%eax
  8017de:	a3 44 40 80 00       	mov    %eax,0x804044
  8017e3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8017e6:	8b 40 04             	mov    0x4(%eax),%eax
  8017e9:	85 c0                	test   %eax,%eax
  8017eb:	74 0f                	je     8017fc <free+0x8e>
  8017ed:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8017f0:	8b 40 04             	mov    0x4(%eax),%eax
  8017f3:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8017f6:	8b 12                	mov    (%edx),%edx
  8017f8:	89 10                	mov    %edx,(%eax)
  8017fa:	eb 0a                	jmp    801806 <free+0x98>
  8017fc:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8017ff:	8b 00                	mov    (%eax),%eax
  801801:	a3 40 40 80 00       	mov    %eax,0x804040
  801806:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801809:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80180f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801812:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  801819:	a1 4c 40 80 00       	mov    0x80404c,%eax
  80181e:	48                   	dec    %eax
  80181f:	a3 4c 40 80 00       	mov    %eax,0x80404c
	insert_sorted_with_merge_freeList(myBlock);
  801824:	83 ec 0c             	sub    $0xc,%esp
  801827:	ff 75 f0             	pushl  -0x10(%ebp)
  80182a:	e8 0b 14 00 00       	call   802c3a <insert_sorted_with_merge_freeList>
  80182f:	83 c4 10             	add    $0x10,%esp

	//you should get the size of the given allocation using its address
	//you need to call sys_free_user_mem()
	//refer to the project presentation and documentation for details
}
  801832:	90                   	nop
  801833:	c9                   	leave  
  801834:	c3                   	ret    

00801835 <smalloc>:

//=================================
// [4] ALLOCATE SHARED VARIABLE:
//=================================
void* smalloc(char *sharedVarName, uint32 size, uint8 isWritable)
{
  801835:	55                   	push   %ebp
  801836:	89 e5                	mov    %esp,%ebp
  801838:	83 ec 28             	sub    $0x28,%esp
  80183b:	8b 45 10             	mov    0x10(%ebp),%eax
  80183e:	88 45 e4             	mov    %al,-0x1c(%ebp)
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801841:	e8 9f fc ff ff       	call   8014e5 <InitializeUHeap>
	if (size == 0) return NULL ;
  801846:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80184a:	75 0a                	jne    801856 <smalloc+0x21>
  80184c:	b8 00 00 00 00       	mov    $0x0,%eax
  801851:	e9 8d 00 00 00       	jmp    8018e3 <smalloc+0xae>

	//This function should find the space of the required range
	// * ON 4KB BOUNDARY **** //
	//Use sys_isUHeapPlacementStrategyFIRSTFIT() to check the current strategy

	size = ROUNDUP(size, PAGE_SIZE);
  801856:	c7 45 f4 00 10 00 00 	movl   $0x1000,-0xc(%ebp)
  80185d:	8b 55 0c             	mov    0xc(%ebp),%edx
  801860:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801863:	01 d0                	add    %edx,%eax
  801865:	48                   	dec    %eax
  801866:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801869:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80186c:	ba 00 00 00 00       	mov    $0x0,%edx
  801871:	f7 75 f4             	divl   -0xc(%ebp)
  801874:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801877:	29 d0                	sub    %edx,%eax
  801879:	89 45 0c             	mov    %eax,0xc(%ebp)
		if(sys_isUHeapPlacementStrategyFIRSTFIT())
  80187c:	e8 c9 06 00 00       	call   801f4a <sys_isUHeapPlacementStrategyFIRSTFIT>
  801881:	85 c0                	test   %eax,%eax
  801883:	74 59                	je     8018de <smalloc+0xa9>
		{
			struct MemBlock * v1=NULL;
  801885:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
			v1= alloc_block_FF(size);
  80188c:	83 ec 0c             	sub    $0xc,%esp
  80188f:	ff 75 0c             	pushl  0xc(%ebp)
  801892:	e8 b4 0c 00 00       	call   80254b <alloc_block_FF>
  801897:	83 c4 10             	add    $0x10,%esp
  80189a:	89 45 ec             	mov    %eax,-0x14(%ebp)
			if(v1==NULL)
  80189d:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8018a1:	75 07                	jne    8018aa <smalloc+0x75>
			{
				return NULL;
  8018a3:	b8 00 00 00 00       	mov    $0x0,%eax
  8018a8:	eb 39                	jmp    8018e3 <smalloc+0xae>
			}
			else
			{
				int ret=sys_createSharedObject(sharedVarName,  size,  isWritable,(void*)v1->sva);
  8018aa:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8018ad:	8b 40 08             	mov    0x8(%eax),%eax
  8018b0:	89 c2                	mov    %eax,%edx
  8018b2:	0f b6 45 e4          	movzbl -0x1c(%ebp),%eax
  8018b6:	52                   	push   %edx
  8018b7:	50                   	push   %eax
  8018b8:	ff 75 0c             	pushl  0xc(%ebp)
  8018bb:	ff 75 08             	pushl  0x8(%ebp)
  8018be:	e8 0c 04 00 00       	call   801ccf <sys_createSharedObject>
  8018c3:	83 c4 10             	add    $0x10,%esp
  8018c6:	89 45 e8             	mov    %eax,-0x18(%ebp)
				if(ret>=0)
  8018c9:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  8018cd:	78 08                	js     8018d7 <smalloc+0xa2>
				{
					return (void*)v1->sva;
  8018cf:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8018d2:	8b 40 08             	mov    0x8(%eax),%eax
  8018d5:	eb 0c                	jmp    8018e3 <smalloc+0xae>
				}
				else
				{
					return NULL;
  8018d7:	b8 00 00 00 00       	mov    $0x0,%eax
  8018dc:	eb 05                	jmp    8018e3 <smalloc+0xae>
				}
			}

		}
		return NULL;
  8018de:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8018e3:	c9                   	leave  
  8018e4:	c3                   	ret    

008018e5 <sget>:

//========================================
// [5] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
  8018e5:	55                   	push   %ebp
  8018e6:	89 e5                	mov    %esp,%ebp
  8018e8:	83 ec 18             	sub    $0x18,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  8018eb:	e8 f5 fb ff ff       	call   8014e5 <InitializeUHeap>

	//This function should find the space for sharing the variable
	// *** ON 4KB BOUNDARY ******** //

	//Use sys_isUHeapPlacementStrategyFIRSTFIT() to check the current strategy
	int ret=sys_getSizeOfSharedObject(ownerEnvID,sharedVarName);
  8018f0:	83 ec 08             	sub    $0x8,%esp
  8018f3:	ff 75 0c             	pushl  0xc(%ebp)
  8018f6:	ff 75 08             	pushl  0x8(%ebp)
  8018f9:	e8 fb 03 00 00       	call   801cf9 <sys_getSizeOfSharedObject>
  8018fe:	83 c4 10             	add    $0x10,%esp
  801901:	89 45 f4             	mov    %eax,-0xc(%ebp)
	if(ret==0)
  801904:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801908:	75 07                	jne    801911 <sget+0x2c>
	{
		return NULL;
  80190a:	b8 00 00 00 00       	mov    $0x0,%eax
  80190f:	eb 64                	jmp    801975 <sget+0x90>
	}
	if(sys_isUHeapPlacementStrategyFIRSTFIT())
  801911:	e8 34 06 00 00       	call   801f4a <sys_isUHeapPlacementStrategyFIRSTFIT>
  801916:	85 c0                	test   %eax,%eax
  801918:	74 56                	je     801970 <sget+0x8b>
	{
		struct MemBlock * v1=NULL;
  80191a:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
		v1= alloc_block_FF(ret);
  801921:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801924:	83 ec 0c             	sub    $0xc,%esp
  801927:	50                   	push   %eax
  801928:	e8 1e 0c 00 00       	call   80254b <alloc_block_FF>
  80192d:	83 c4 10             	add    $0x10,%esp
  801930:	89 45 f0             	mov    %eax,-0x10(%ebp)
		if(v1==NULL)
  801933:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801937:	75 07                	jne    801940 <sget+0x5b>
		{
		return NULL;
  801939:	b8 00 00 00 00       	mov    $0x0,%eax
  80193e:	eb 35                	jmp    801975 <sget+0x90>
	    }
		else
		{
			int ret1=sys_getSharedObject(ownerEnvID,sharedVarName,(void*)v1->sva);
  801940:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801943:	8b 40 08             	mov    0x8(%eax),%eax
  801946:	83 ec 04             	sub    $0x4,%esp
  801949:	50                   	push   %eax
  80194a:	ff 75 0c             	pushl  0xc(%ebp)
  80194d:	ff 75 08             	pushl  0x8(%ebp)
  801950:	e8 c1 03 00 00       	call   801d16 <sys_getSharedObject>
  801955:	83 c4 10             	add    $0x10,%esp
  801958:	89 45 ec             	mov    %eax,-0x14(%ebp)
			if(ret1>=0)
  80195b:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  80195f:	78 08                	js     801969 <sget+0x84>
			{
				return (void*)v1->sva;
  801961:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801964:	8b 40 08             	mov    0x8(%eax),%eax
  801967:	eb 0c                	jmp    801975 <sget+0x90>
			}
			else
			{
				return NULL;
  801969:	b8 00 00 00 00       	mov    $0x0,%eax
  80196e:	eb 05                	jmp    801975 <sget+0x90>
			}
		}
	}
  return NULL;
  801970:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801975:	c9                   	leave  
  801976:	c3                   	ret    

00801977 <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  801977:	55                   	push   %ebp
  801978:	89 e5                	mov    %esp,%ebp
  80197a:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  80197d:	e8 63 fb ff ff       	call   8014e5 <InitializeUHeap>
	//==============================================================
	// [USER HEAP - USER SIDE] realloc
	// Write your code here, remove the panic and write your code
	panic("realloc() is not implemented yet...!!");
  801982:	83 ec 04             	sub    $0x4,%esp
  801985:	68 04 3c 80 00       	push   $0x803c04
  80198a:	68 0e 01 00 00       	push   $0x10e
  80198f:	68 d3 3b 80 00       	push   $0x803bd3
  801994:	e8 0e eb ff ff       	call   8004a7 <_panic>

00801999 <sfree>:
//	use sys_freeSharedObject(...); which switches to the kernel mode,
//	calls freeSharedObject(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the freeSharedObject() function is empty, make sure to implement it.

void sfree(void* virtual_address)
{
  801999:	55                   	push   %ebp
  80199a:	89 e5                	mov    %esp,%ebp
  80199c:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT MS3 - BONUS] [SHARING - USER SIDE] sfree()

	// Write your code here, remove the panic and write your code
	panic("sfree() is not implemented yet...!!");
  80199f:	83 ec 04             	sub    $0x4,%esp
  8019a2:	68 2c 3c 80 00       	push   $0x803c2c
  8019a7:	68 22 01 00 00       	push   $0x122
  8019ac:	68 d3 3b 80 00       	push   $0x803bd3
  8019b1:	e8 f1 ea ff ff       	call   8004a7 <_panic>

008019b6 <expand>:

//==================================================================================//
//========================== MODIFICATION FUNCTIONS ================================//
//==================================================================================//
void expand(uint32 newSize)
{
  8019b6:	55                   	push   %ebp
  8019b7:	89 e5                	mov    %esp,%ebp
  8019b9:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  8019bc:	83 ec 04             	sub    $0x4,%esp
  8019bf:	68 50 3c 80 00       	push   $0x803c50
  8019c4:	68 2d 01 00 00       	push   $0x12d
  8019c9:	68 d3 3b 80 00       	push   $0x803bd3
  8019ce:	e8 d4 ea ff ff       	call   8004a7 <_panic>

008019d3 <shrink>:

}
void shrink(uint32 newSize)
{
  8019d3:	55                   	push   %ebp
  8019d4:	89 e5                	mov    %esp,%ebp
  8019d6:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  8019d9:	83 ec 04             	sub    $0x4,%esp
  8019dc:	68 50 3c 80 00       	push   $0x803c50
  8019e1:	68 32 01 00 00       	push   $0x132
  8019e6:	68 d3 3b 80 00       	push   $0x803bd3
  8019eb:	e8 b7 ea ff ff       	call   8004a7 <_panic>

008019f0 <freeHeap>:

}
void freeHeap(void* virtual_address)
{
  8019f0:	55                   	push   %ebp
  8019f1:	89 e5                	mov    %esp,%ebp
  8019f3:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  8019f6:	83 ec 04             	sub    $0x4,%esp
  8019f9:	68 50 3c 80 00       	push   $0x803c50
  8019fe:	68 37 01 00 00       	push   $0x137
  801a03:	68 d3 3b 80 00       	push   $0x803bd3
  801a08:	e8 9a ea ff ff       	call   8004a7 <_panic>

00801a0d <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  801a0d:	55                   	push   %ebp
  801a0e:	89 e5                	mov    %esp,%ebp
  801a10:	57                   	push   %edi
  801a11:	56                   	push   %esi
  801a12:	53                   	push   %ebx
  801a13:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801a16:	8b 45 08             	mov    0x8(%ebp),%eax
  801a19:	8b 55 0c             	mov    0xc(%ebp),%edx
  801a1c:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801a1f:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801a22:	8b 7d 18             	mov    0x18(%ebp),%edi
  801a25:	8b 75 1c             	mov    0x1c(%ebp),%esi
  801a28:	cd 30                	int    $0x30
  801a2a:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  801a2d:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801a30:	83 c4 10             	add    $0x10,%esp
  801a33:	5b                   	pop    %ebx
  801a34:	5e                   	pop    %esi
  801a35:	5f                   	pop    %edi
  801a36:	5d                   	pop    %ebp
  801a37:	c3                   	ret    

00801a38 <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  801a38:	55                   	push   %ebp
  801a39:	89 e5                	mov    %esp,%ebp
  801a3b:	83 ec 04             	sub    $0x4,%esp
  801a3e:	8b 45 10             	mov    0x10(%ebp),%eax
  801a41:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  801a44:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801a48:	8b 45 08             	mov    0x8(%ebp),%eax
  801a4b:	6a 00                	push   $0x0
  801a4d:	6a 00                	push   $0x0
  801a4f:	52                   	push   %edx
  801a50:	ff 75 0c             	pushl  0xc(%ebp)
  801a53:	50                   	push   %eax
  801a54:	6a 00                	push   $0x0
  801a56:	e8 b2 ff ff ff       	call   801a0d <syscall>
  801a5b:	83 c4 18             	add    $0x18,%esp
}
  801a5e:	90                   	nop
  801a5f:	c9                   	leave  
  801a60:	c3                   	ret    

00801a61 <sys_cgetc>:

int
sys_cgetc(void)
{
  801a61:	55                   	push   %ebp
  801a62:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  801a64:	6a 00                	push   $0x0
  801a66:	6a 00                	push   $0x0
  801a68:	6a 00                	push   $0x0
  801a6a:	6a 00                	push   $0x0
  801a6c:	6a 00                	push   $0x0
  801a6e:	6a 01                	push   $0x1
  801a70:	e8 98 ff ff ff       	call   801a0d <syscall>
  801a75:	83 c4 18             	add    $0x18,%esp
}
  801a78:	c9                   	leave  
  801a79:	c3                   	ret    

00801a7a <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  801a7a:	55                   	push   %ebp
  801a7b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  801a7d:	8b 55 0c             	mov    0xc(%ebp),%edx
  801a80:	8b 45 08             	mov    0x8(%ebp),%eax
  801a83:	6a 00                	push   $0x0
  801a85:	6a 00                	push   $0x0
  801a87:	6a 00                	push   $0x0
  801a89:	52                   	push   %edx
  801a8a:	50                   	push   %eax
  801a8b:	6a 05                	push   $0x5
  801a8d:	e8 7b ff ff ff       	call   801a0d <syscall>
  801a92:	83 c4 18             	add    $0x18,%esp
}
  801a95:	c9                   	leave  
  801a96:	c3                   	ret    

00801a97 <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  801a97:	55                   	push   %ebp
  801a98:	89 e5                	mov    %esp,%ebp
  801a9a:	56                   	push   %esi
  801a9b:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  801a9c:	8b 75 18             	mov    0x18(%ebp),%esi
  801a9f:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801aa2:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801aa5:	8b 55 0c             	mov    0xc(%ebp),%edx
  801aa8:	8b 45 08             	mov    0x8(%ebp),%eax
  801aab:	56                   	push   %esi
  801aac:	53                   	push   %ebx
  801aad:	51                   	push   %ecx
  801aae:	52                   	push   %edx
  801aaf:	50                   	push   %eax
  801ab0:	6a 06                	push   $0x6
  801ab2:	e8 56 ff ff ff       	call   801a0d <syscall>
  801ab7:	83 c4 18             	add    $0x18,%esp
}
  801aba:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801abd:	5b                   	pop    %ebx
  801abe:	5e                   	pop    %esi
  801abf:	5d                   	pop    %ebp
  801ac0:	c3                   	ret    

00801ac1 <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  801ac1:	55                   	push   %ebp
  801ac2:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  801ac4:	8b 55 0c             	mov    0xc(%ebp),%edx
  801ac7:	8b 45 08             	mov    0x8(%ebp),%eax
  801aca:	6a 00                	push   $0x0
  801acc:	6a 00                	push   $0x0
  801ace:	6a 00                	push   $0x0
  801ad0:	52                   	push   %edx
  801ad1:	50                   	push   %eax
  801ad2:	6a 07                	push   $0x7
  801ad4:	e8 34 ff ff ff       	call   801a0d <syscall>
  801ad9:	83 c4 18             	add    $0x18,%esp
}
  801adc:	c9                   	leave  
  801add:	c3                   	ret    

00801ade <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  801ade:	55                   	push   %ebp
  801adf:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  801ae1:	6a 00                	push   $0x0
  801ae3:	6a 00                	push   $0x0
  801ae5:	6a 00                	push   $0x0
  801ae7:	ff 75 0c             	pushl  0xc(%ebp)
  801aea:	ff 75 08             	pushl  0x8(%ebp)
  801aed:	6a 08                	push   $0x8
  801aef:	e8 19 ff ff ff       	call   801a0d <syscall>
  801af4:	83 c4 18             	add    $0x18,%esp
}
  801af7:	c9                   	leave  
  801af8:	c3                   	ret    

00801af9 <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  801af9:	55                   	push   %ebp
  801afa:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  801afc:	6a 00                	push   $0x0
  801afe:	6a 00                	push   $0x0
  801b00:	6a 00                	push   $0x0
  801b02:	6a 00                	push   $0x0
  801b04:	6a 00                	push   $0x0
  801b06:	6a 09                	push   $0x9
  801b08:	e8 00 ff ff ff       	call   801a0d <syscall>
  801b0d:	83 c4 18             	add    $0x18,%esp
}
  801b10:	c9                   	leave  
  801b11:	c3                   	ret    

00801b12 <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  801b12:	55                   	push   %ebp
  801b13:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  801b15:	6a 00                	push   $0x0
  801b17:	6a 00                	push   $0x0
  801b19:	6a 00                	push   $0x0
  801b1b:	6a 00                	push   $0x0
  801b1d:	6a 00                	push   $0x0
  801b1f:	6a 0a                	push   $0xa
  801b21:	e8 e7 fe ff ff       	call   801a0d <syscall>
  801b26:	83 c4 18             	add    $0x18,%esp
}
  801b29:	c9                   	leave  
  801b2a:	c3                   	ret    

00801b2b <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  801b2b:	55                   	push   %ebp
  801b2c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  801b2e:	6a 00                	push   $0x0
  801b30:	6a 00                	push   $0x0
  801b32:	6a 00                	push   $0x0
  801b34:	6a 00                	push   $0x0
  801b36:	6a 00                	push   $0x0
  801b38:	6a 0b                	push   $0xb
  801b3a:	e8 ce fe ff ff       	call   801a0d <syscall>
  801b3f:	83 c4 18             	add    $0x18,%esp
}
  801b42:	c9                   	leave  
  801b43:	c3                   	ret    

00801b44 <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  801b44:	55                   	push   %ebp
  801b45:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  801b47:	6a 00                	push   $0x0
  801b49:	6a 00                	push   $0x0
  801b4b:	6a 00                	push   $0x0
  801b4d:	ff 75 0c             	pushl  0xc(%ebp)
  801b50:	ff 75 08             	pushl  0x8(%ebp)
  801b53:	6a 0f                	push   $0xf
  801b55:	e8 b3 fe ff ff       	call   801a0d <syscall>
  801b5a:	83 c4 18             	add    $0x18,%esp
	return;
  801b5d:	90                   	nop
}
  801b5e:	c9                   	leave  
  801b5f:	c3                   	ret    

00801b60 <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  801b60:	55                   	push   %ebp
  801b61:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  801b63:	6a 00                	push   $0x0
  801b65:	6a 00                	push   $0x0
  801b67:	6a 00                	push   $0x0
  801b69:	ff 75 0c             	pushl  0xc(%ebp)
  801b6c:	ff 75 08             	pushl  0x8(%ebp)
  801b6f:	6a 10                	push   $0x10
  801b71:	e8 97 fe ff ff       	call   801a0d <syscall>
  801b76:	83 c4 18             	add    $0x18,%esp
	return ;
  801b79:	90                   	nop
}
  801b7a:	c9                   	leave  
  801b7b:	c3                   	ret    

00801b7c <sys_allocate_chunk>:

void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  801b7c:	55                   	push   %ebp
  801b7d:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  801b7f:	6a 00                	push   $0x0
  801b81:	6a 00                	push   $0x0
  801b83:	ff 75 10             	pushl  0x10(%ebp)
  801b86:	ff 75 0c             	pushl  0xc(%ebp)
  801b89:	ff 75 08             	pushl  0x8(%ebp)
  801b8c:	6a 11                	push   $0x11
  801b8e:	e8 7a fe ff ff       	call   801a0d <syscall>
  801b93:	83 c4 18             	add    $0x18,%esp
	return ;
  801b96:	90                   	nop
}
  801b97:	c9                   	leave  
  801b98:	c3                   	ret    

00801b99 <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  801b99:	55                   	push   %ebp
  801b9a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  801b9c:	6a 00                	push   $0x0
  801b9e:	6a 00                	push   $0x0
  801ba0:	6a 00                	push   $0x0
  801ba2:	6a 00                	push   $0x0
  801ba4:	6a 00                	push   $0x0
  801ba6:	6a 0c                	push   $0xc
  801ba8:	e8 60 fe ff ff       	call   801a0d <syscall>
  801bad:	83 c4 18             	add    $0x18,%esp
}
  801bb0:	c9                   	leave  
  801bb1:	c3                   	ret    

00801bb2 <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  801bb2:	55                   	push   %ebp
  801bb3:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  801bb5:	6a 00                	push   $0x0
  801bb7:	6a 00                	push   $0x0
  801bb9:	6a 00                	push   $0x0
  801bbb:	6a 00                	push   $0x0
  801bbd:	ff 75 08             	pushl  0x8(%ebp)
  801bc0:	6a 0d                	push   $0xd
  801bc2:	e8 46 fe ff ff       	call   801a0d <syscall>
  801bc7:	83 c4 18             	add    $0x18,%esp
}
  801bca:	c9                   	leave  
  801bcb:	c3                   	ret    

00801bcc <sys_scarce_memory>:

void sys_scarce_memory()
{
  801bcc:	55                   	push   %ebp
  801bcd:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  801bcf:	6a 00                	push   $0x0
  801bd1:	6a 00                	push   $0x0
  801bd3:	6a 00                	push   $0x0
  801bd5:	6a 00                	push   $0x0
  801bd7:	6a 00                	push   $0x0
  801bd9:	6a 0e                	push   $0xe
  801bdb:	e8 2d fe ff ff       	call   801a0d <syscall>
  801be0:	83 c4 18             	add    $0x18,%esp
}
  801be3:	90                   	nop
  801be4:	c9                   	leave  
  801be5:	c3                   	ret    

00801be6 <sys_disable_interrupt>:

//NEW !! 2012...
void
sys_disable_interrupt()
{
  801be6:	55                   	push   %ebp
  801be7:	89 e5                	mov    %esp,%ebp
	syscall(SYS_disableINTR,0, 0, 0, 0, 0);
  801be9:	6a 00                	push   $0x0
  801beb:	6a 00                	push   $0x0
  801bed:	6a 00                	push   $0x0
  801bef:	6a 00                	push   $0x0
  801bf1:	6a 00                	push   $0x0
  801bf3:	6a 13                	push   $0x13
  801bf5:	e8 13 fe ff ff       	call   801a0d <syscall>
  801bfa:	83 c4 18             	add    $0x18,%esp
}
  801bfd:	90                   	nop
  801bfe:	c9                   	leave  
  801bff:	c3                   	ret    

00801c00 <sys_enable_interrupt>:


void
sys_enable_interrupt()
{
  801c00:	55                   	push   %ebp
  801c01:	89 e5                	mov    %esp,%ebp
	syscall(SYS_enableINTR,0, 0, 0, 0, 0);
  801c03:	6a 00                	push   $0x0
  801c05:	6a 00                	push   $0x0
  801c07:	6a 00                	push   $0x0
  801c09:	6a 00                	push   $0x0
  801c0b:	6a 00                	push   $0x0
  801c0d:	6a 14                	push   $0x14
  801c0f:	e8 f9 fd ff ff       	call   801a0d <syscall>
  801c14:	83 c4 18             	add    $0x18,%esp
}
  801c17:	90                   	nop
  801c18:	c9                   	leave  
  801c19:	c3                   	ret    

00801c1a <sys_cputc>:


void
sys_cputc(const char c)
{
  801c1a:	55                   	push   %ebp
  801c1b:	89 e5                	mov    %esp,%ebp
  801c1d:	83 ec 04             	sub    $0x4,%esp
  801c20:	8b 45 08             	mov    0x8(%ebp),%eax
  801c23:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  801c26:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801c2a:	6a 00                	push   $0x0
  801c2c:	6a 00                	push   $0x0
  801c2e:	6a 00                	push   $0x0
  801c30:	6a 00                	push   $0x0
  801c32:	50                   	push   %eax
  801c33:	6a 15                	push   $0x15
  801c35:	e8 d3 fd ff ff       	call   801a0d <syscall>
  801c3a:	83 c4 18             	add    $0x18,%esp
}
  801c3d:	90                   	nop
  801c3e:	c9                   	leave  
  801c3f:	c3                   	ret    

00801c40 <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  801c40:	55                   	push   %ebp
  801c41:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  801c43:	6a 00                	push   $0x0
  801c45:	6a 00                	push   $0x0
  801c47:	6a 00                	push   $0x0
  801c49:	6a 00                	push   $0x0
  801c4b:	6a 00                	push   $0x0
  801c4d:	6a 16                	push   $0x16
  801c4f:	e8 b9 fd ff ff       	call   801a0d <syscall>
  801c54:	83 c4 18             	add    $0x18,%esp
}
  801c57:	90                   	nop
  801c58:	c9                   	leave  
  801c59:	c3                   	ret    

00801c5a <sys_createSemaphore>:

int
sys_createSemaphore(char* semaphoreName, uint32 initialValue)
{
  801c5a:	55                   	push   %ebp
  801c5b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_semaphore,(uint32)semaphoreName, (uint32)initialValue, 0, 0, 0);
  801c5d:	8b 45 08             	mov    0x8(%ebp),%eax
  801c60:	6a 00                	push   $0x0
  801c62:	6a 00                	push   $0x0
  801c64:	6a 00                	push   $0x0
  801c66:	ff 75 0c             	pushl  0xc(%ebp)
  801c69:	50                   	push   %eax
  801c6a:	6a 17                	push   $0x17
  801c6c:	e8 9c fd ff ff       	call   801a0d <syscall>
  801c71:	83 c4 18             	add    $0x18,%esp
}
  801c74:	c9                   	leave  
  801c75:	c3                   	ret    

00801c76 <sys_getSemaphoreValue>:

int
sys_getSemaphoreValue(int32 ownerEnvID, char* semaphoreName)
{
  801c76:	55                   	push   %ebp
  801c77:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_semaphore_value,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801c79:	8b 55 0c             	mov    0xc(%ebp),%edx
  801c7c:	8b 45 08             	mov    0x8(%ebp),%eax
  801c7f:	6a 00                	push   $0x0
  801c81:	6a 00                	push   $0x0
  801c83:	6a 00                	push   $0x0
  801c85:	52                   	push   %edx
  801c86:	50                   	push   %eax
  801c87:	6a 1a                	push   $0x1a
  801c89:	e8 7f fd ff ff       	call   801a0d <syscall>
  801c8e:	83 c4 18             	add    $0x18,%esp
}
  801c91:	c9                   	leave  
  801c92:	c3                   	ret    

00801c93 <sys_waitSemaphore>:

void
sys_waitSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  801c93:	55                   	push   %ebp
  801c94:	89 e5                	mov    %esp,%ebp
	syscall(SYS_wait_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801c96:	8b 55 0c             	mov    0xc(%ebp),%edx
  801c99:	8b 45 08             	mov    0x8(%ebp),%eax
  801c9c:	6a 00                	push   $0x0
  801c9e:	6a 00                	push   $0x0
  801ca0:	6a 00                	push   $0x0
  801ca2:	52                   	push   %edx
  801ca3:	50                   	push   %eax
  801ca4:	6a 18                	push   $0x18
  801ca6:	e8 62 fd ff ff       	call   801a0d <syscall>
  801cab:	83 c4 18             	add    $0x18,%esp
}
  801cae:	90                   	nop
  801caf:	c9                   	leave  
  801cb0:	c3                   	ret    

00801cb1 <sys_signalSemaphore>:

void
sys_signalSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  801cb1:	55                   	push   %ebp
  801cb2:	89 e5                	mov    %esp,%ebp
	syscall(SYS_signal_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801cb4:	8b 55 0c             	mov    0xc(%ebp),%edx
  801cb7:	8b 45 08             	mov    0x8(%ebp),%eax
  801cba:	6a 00                	push   $0x0
  801cbc:	6a 00                	push   $0x0
  801cbe:	6a 00                	push   $0x0
  801cc0:	52                   	push   %edx
  801cc1:	50                   	push   %eax
  801cc2:	6a 19                	push   $0x19
  801cc4:	e8 44 fd ff ff       	call   801a0d <syscall>
  801cc9:	83 c4 18             	add    $0x18,%esp
}
  801ccc:	90                   	nop
  801ccd:	c9                   	leave  
  801cce:	c3                   	ret    

00801ccf <sys_createSharedObject>:

int
sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  801ccf:	55                   	push   %ebp
  801cd0:	89 e5                	mov    %esp,%ebp
  801cd2:	83 ec 04             	sub    $0x4,%esp
  801cd5:	8b 45 10             	mov    0x10(%ebp),%eax
  801cd8:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  801cdb:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801cde:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801ce2:	8b 45 08             	mov    0x8(%ebp),%eax
  801ce5:	6a 00                	push   $0x0
  801ce7:	51                   	push   %ecx
  801ce8:	52                   	push   %edx
  801ce9:	ff 75 0c             	pushl  0xc(%ebp)
  801cec:	50                   	push   %eax
  801ced:	6a 1b                	push   $0x1b
  801cef:	e8 19 fd ff ff       	call   801a0d <syscall>
  801cf4:	83 c4 18             	add    $0x18,%esp
}
  801cf7:	c9                   	leave  
  801cf8:	c3                   	ret    

00801cf9 <sys_getSizeOfSharedObject>:

//2017:
int
sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  801cf9:	55                   	push   %ebp
  801cfa:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  801cfc:	8b 55 0c             	mov    0xc(%ebp),%edx
  801cff:	8b 45 08             	mov    0x8(%ebp),%eax
  801d02:	6a 00                	push   $0x0
  801d04:	6a 00                	push   $0x0
  801d06:	6a 00                	push   $0x0
  801d08:	52                   	push   %edx
  801d09:	50                   	push   %eax
  801d0a:	6a 1c                	push   $0x1c
  801d0c:	e8 fc fc ff ff       	call   801a0d <syscall>
  801d11:	83 c4 18             	add    $0x18,%esp
}
  801d14:	c9                   	leave  
  801d15:	c3                   	ret    

00801d16 <sys_getSharedObject>:
//==========

int
sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  801d16:	55                   	push   %ebp
  801d17:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  801d19:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801d1c:	8b 55 0c             	mov    0xc(%ebp),%edx
  801d1f:	8b 45 08             	mov    0x8(%ebp),%eax
  801d22:	6a 00                	push   $0x0
  801d24:	6a 00                	push   $0x0
  801d26:	51                   	push   %ecx
  801d27:	52                   	push   %edx
  801d28:	50                   	push   %eax
  801d29:	6a 1d                	push   $0x1d
  801d2b:	e8 dd fc ff ff       	call   801a0d <syscall>
  801d30:	83 c4 18             	add    $0x18,%esp
}
  801d33:	c9                   	leave  
  801d34:	c3                   	ret    

00801d35 <sys_freeSharedObject>:

int
sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  801d35:	55                   	push   %ebp
  801d36:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  801d38:	8b 55 0c             	mov    0xc(%ebp),%edx
  801d3b:	8b 45 08             	mov    0x8(%ebp),%eax
  801d3e:	6a 00                	push   $0x0
  801d40:	6a 00                	push   $0x0
  801d42:	6a 00                	push   $0x0
  801d44:	52                   	push   %edx
  801d45:	50                   	push   %eax
  801d46:	6a 1e                	push   $0x1e
  801d48:	e8 c0 fc ff ff       	call   801a0d <syscall>
  801d4d:	83 c4 18             	add    $0x18,%esp
}
  801d50:	c9                   	leave  
  801d51:	c3                   	ret    

00801d52 <sys_getMaxShares>:

uint32 	sys_getMaxShares()
{
  801d52:	55                   	push   %ebp
  801d53:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_max_shares,0, 0, 0, 0, 0);
  801d55:	6a 00                	push   $0x0
  801d57:	6a 00                	push   $0x0
  801d59:	6a 00                	push   $0x0
  801d5b:	6a 00                	push   $0x0
  801d5d:	6a 00                	push   $0x0
  801d5f:	6a 1f                	push   $0x1f
  801d61:	e8 a7 fc ff ff       	call   801a0d <syscall>
  801d66:	83 c4 18             	add    $0x18,%esp
}
  801d69:	c9                   	leave  
  801d6a:	c3                   	ret    

00801d6b <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  801d6b:	55                   	push   %ebp
  801d6c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  801d6e:	8b 45 08             	mov    0x8(%ebp),%eax
  801d71:	6a 00                	push   $0x0
  801d73:	ff 75 14             	pushl  0x14(%ebp)
  801d76:	ff 75 10             	pushl  0x10(%ebp)
  801d79:	ff 75 0c             	pushl  0xc(%ebp)
  801d7c:	50                   	push   %eax
  801d7d:	6a 20                	push   $0x20
  801d7f:	e8 89 fc ff ff       	call   801a0d <syscall>
  801d84:	83 c4 18             	add    $0x18,%esp
}
  801d87:	c9                   	leave  
  801d88:	c3                   	ret    

00801d89 <sys_run_env>:

void
sys_run_env(int32 envId)
{
  801d89:	55                   	push   %ebp
  801d8a:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  801d8c:	8b 45 08             	mov    0x8(%ebp),%eax
  801d8f:	6a 00                	push   $0x0
  801d91:	6a 00                	push   $0x0
  801d93:	6a 00                	push   $0x0
  801d95:	6a 00                	push   $0x0
  801d97:	50                   	push   %eax
  801d98:	6a 21                	push   $0x21
  801d9a:	e8 6e fc ff ff       	call   801a0d <syscall>
  801d9f:	83 c4 18             	add    $0x18,%esp
}
  801da2:	90                   	nop
  801da3:	c9                   	leave  
  801da4:	c3                   	ret    

00801da5 <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  801da5:	55                   	push   %ebp
  801da6:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  801da8:	8b 45 08             	mov    0x8(%ebp),%eax
  801dab:	6a 00                	push   $0x0
  801dad:	6a 00                	push   $0x0
  801daf:	6a 00                	push   $0x0
  801db1:	6a 00                	push   $0x0
  801db3:	50                   	push   %eax
  801db4:	6a 22                	push   $0x22
  801db6:	e8 52 fc ff ff       	call   801a0d <syscall>
  801dbb:	83 c4 18             	add    $0x18,%esp
}
  801dbe:	c9                   	leave  
  801dbf:	c3                   	ret    

00801dc0 <sys_getenvid>:

int32 sys_getenvid(void)
{
  801dc0:	55                   	push   %ebp
  801dc1:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  801dc3:	6a 00                	push   $0x0
  801dc5:	6a 00                	push   $0x0
  801dc7:	6a 00                	push   $0x0
  801dc9:	6a 00                	push   $0x0
  801dcb:	6a 00                	push   $0x0
  801dcd:	6a 02                	push   $0x2
  801dcf:	e8 39 fc ff ff       	call   801a0d <syscall>
  801dd4:	83 c4 18             	add    $0x18,%esp
}
  801dd7:	c9                   	leave  
  801dd8:	c3                   	ret    

00801dd9 <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  801dd9:	55                   	push   %ebp
  801dda:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  801ddc:	6a 00                	push   $0x0
  801dde:	6a 00                	push   $0x0
  801de0:	6a 00                	push   $0x0
  801de2:	6a 00                	push   $0x0
  801de4:	6a 00                	push   $0x0
  801de6:	6a 03                	push   $0x3
  801de8:	e8 20 fc ff ff       	call   801a0d <syscall>
  801ded:	83 c4 18             	add    $0x18,%esp
}
  801df0:	c9                   	leave  
  801df1:	c3                   	ret    

00801df2 <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  801df2:	55                   	push   %ebp
  801df3:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  801df5:	6a 00                	push   $0x0
  801df7:	6a 00                	push   $0x0
  801df9:	6a 00                	push   $0x0
  801dfb:	6a 00                	push   $0x0
  801dfd:	6a 00                	push   $0x0
  801dff:	6a 04                	push   $0x4
  801e01:	e8 07 fc ff ff       	call   801a0d <syscall>
  801e06:	83 c4 18             	add    $0x18,%esp
}
  801e09:	c9                   	leave  
  801e0a:	c3                   	ret    

00801e0b <sys_exit_env>:


void sys_exit_env(void)
{
  801e0b:	55                   	push   %ebp
  801e0c:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  801e0e:	6a 00                	push   $0x0
  801e10:	6a 00                	push   $0x0
  801e12:	6a 00                	push   $0x0
  801e14:	6a 00                	push   $0x0
  801e16:	6a 00                	push   $0x0
  801e18:	6a 23                	push   $0x23
  801e1a:	e8 ee fb ff ff       	call   801a0d <syscall>
  801e1f:	83 c4 18             	add    $0x18,%esp
}
  801e22:	90                   	nop
  801e23:	c9                   	leave  
  801e24:	c3                   	ret    

00801e25 <sys_get_virtual_time>:


struct uint64
sys_get_virtual_time()
{
  801e25:	55                   	push   %ebp
  801e26:	89 e5                	mov    %esp,%ebp
  801e28:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  801e2b:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801e2e:	8d 50 04             	lea    0x4(%eax),%edx
  801e31:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801e34:	6a 00                	push   $0x0
  801e36:	6a 00                	push   $0x0
  801e38:	6a 00                	push   $0x0
  801e3a:	52                   	push   %edx
  801e3b:	50                   	push   %eax
  801e3c:	6a 24                	push   $0x24
  801e3e:	e8 ca fb ff ff       	call   801a0d <syscall>
  801e43:	83 c4 18             	add    $0x18,%esp
	return result;
  801e46:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801e49:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801e4c:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801e4f:	89 01                	mov    %eax,(%ecx)
  801e51:	89 51 04             	mov    %edx,0x4(%ecx)
}
  801e54:	8b 45 08             	mov    0x8(%ebp),%eax
  801e57:	c9                   	leave  
  801e58:	c2 04 00             	ret    $0x4

00801e5b <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  801e5b:	55                   	push   %ebp
  801e5c:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  801e5e:	6a 00                	push   $0x0
  801e60:	6a 00                	push   $0x0
  801e62:	ff 75 10             	pushl  0x10(%ebp)
  801e65:	ff 75 0c             	pushl  0xc(%ebp)
  801e68:	ff 75 08             	pushl  0x8(%ebp)
  801e6b:	6a 12                	push   $0x12
  801e6d:	e8 9b fb ff ff       	call   801a0d <syscall>
  801e72:	83 c4 18             	add    $0x18,%esp
	return ;
  801e75:	90                   	nop
}
  801e76:	c9                   	leave  
  801e77:	c3                   	ret    

00801e78 <sys_rcr2>:
uint32 sys_rcr2()
{
  801e78:	55                   	push   %ebp
  801e79:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  801e7b:	6a 00                	push   $0x0
  801e7d:	6a 00                	push   $0x0
  801e7f:	6a 00                	push   $0x0
  801e81:	6a 00                	push   $0x0
  801e83:	6a 00                	push   $0x0
  801e85:	6a 25                	push   $0x25
  801e87:	e8 81 fb ff ff       	call   801a0d <syscall>
  801e8c:	83 c4 18             	add    $0x18,%esp
}
  801e8f:	c9                   	leave  
  801e90:	c3                   	ret    

00801e91 <sys_bypassPageFault>:
void sys_bypassPageFault(uint8 instrLength)
{
  801e91:	55                   	push   %ebp
  801e92:	89 e5                	mov    %esp,%ebp
  801e94:	83 ec 04             	sub    $0x4,%esp
  801e97:	8b 45 08             	mov    0x8(%ebp),%eax
  801e9a:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  801e9d:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  801ea1:	6a 00                	push   $0x0
  801ea3:	6a 00                	push   $0x0
  801ea5:	6a 00                	push   $0x0
  801ea7:	6a 00                	push   $0x0
  801ea9:	50                   	push   %eax
  801eaa:	6a 26                	push   $0x26
  801eac:	e8 5c fb ff ff       	call   801a0d <syscall>
  801eb1:	83 c4 18             	add    $0x18,%esp
	return ;
  801eb4:	90                   	nop
}
  801eb5:	c9                   	leave  
  801eb6:	c3                   	ret    

00801eb7 <rsttst>:
void rsttst()
{
  801eb7:	55                   	push   %ebp
  801eb8:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  801eba:	6a 00                	push   $0x0
  801ebc:	6a 00                	push   $0x0
  801ebe:	6a 00                	push   $0x0
  801ec0:	6a 00                	push   $0x0
  801ec2:	6a 00                	push   $0x0
  801ec4:	6a 28                	push   $0x28
  801ec6:	e8 42 fb ff ff       	call   801a0d <syscall>
  801ecb:	83 c4 18             	add    $0x18,%esp
	return ;
  801ece:	90                   	nop
}
  801ecf:	c9                   	leave  
  801ed0:	c3                   	ret    

00801ed1 <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  801ed1:	55                   	push   %ebp
  801ed2:	89 e5                	mov    %esp,%ebp
  801ed4:	83 ec 04             	sub    $0x4,%esp
  801ed7:	8b 45 14             	mov    0x14(%ebp),%eax
  801eda:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  801edd:	8b 55 18             	mov    0x18(%ebp),%edx
  801ee0:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801ee4:	52                   	push   %edx
  801ee5:	50                   	push   %eax
  801ee6:	ff 75 10             	pushl  0x10(%ebp)
  801ee9:	ff 75 0c             	pushl  0xc(%ebp)
  801eec:	ff 75 08             	pushl  0x8(%ebp)
  801eef:	6a 27                	push   $0x27
  801ef1:	e8 17 fb ff ff       	call   801a0d <syscall>
  801ef6:	83 c4 18             	add    $0x18,%esp
	return ;
  801ef9:	90                   	nop
}
  801efa:	c9                   	leave  
  801efb:	c3                   	ret    

00801efc <chktst>:
void chktst(uint32 n)
{
  801efc:	55                   	push   %ebp
  801efd:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  801eff:	6a 00                	push   $0x0
  801f01:	6a 00                	push   $0x0
  801f03:	6a 00                	push   $0x0
  801f05:	6a 00                	push   $0x0
  801f07:	ff 75 08             	pushl  0x8(%ebp)
  801f0a:	6a 29                	push   $0x29
  801f0c:	e8 fc fa ff ff       	call   801a0d <syscall>
  801f11:	83 c4 18             	add    $0x18,%esp
	return ;
  801f14:	90                   	nop
}
  801f15:	c9                   	leave  
  801f16:	c3                   	ret    

00801f17 <inctst>:

void inctst()
{
  801f17:	55                   	push   %ebp
  801f18:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  801f1a:	6a 00                	push   $0x0
  801f1c:	6a 00                	push   $0x0
  801f1e:	6a 00                	push   $0x0
  801f20:	6a 00                	push   $0x0
  801f22:	6a 00                	push   $0x0
  801f24:	6a 2a                	push   $0x2a
  801f26:	e8 e2 fa ff ff       	call   801a0d <syscall>
  801f2b:	83 c4 18             	add    $0x18,%esp
	return ;
  801f2e:	90                   	nop
}
  801f2f:	c9                   	leave  
  801f30:	c3                   	ret    

00801f31 <gettst>:
uint32 gettst()
{
  801f31:	55                   	push   %ebp
  801f32:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  801f34:	6a 00                	push   $0x0
  801f36:	6a 00                	push   $0x0
  801f38:	6a 00                	push   $0x0
  801f3a:	6a 00                	push   $0x0
  801f3c:	6a 00                	push   $0x0
  801f3e:	6a 2b                	push   $0x2b
  801f40:	e8 c8 fa ff ff       	call   801a0d <syscall>
  801f45:	83 c4 18             	add    $0x18,%esp
}
  801f48:	c9                   	leave  
  801f49:	c3                   	ret    

00801f4a <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  801f4a:	55                   	push   %ebp
  801f4b:	89 e5                	mov    %esp,%ebp
  801f4d:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801f50:	6a 00                	push   $0x0
  801f52:	6a 00                	push   $0x0
  801f54:	6a 00                	push   $0x0
  801f56:	6a 00                	push   $0x0
  801f58:	6a 00                	push   $0x0
  801f5a:	6a 2c                	push   $0x2c
  801f5c:	e8 ac fa ff ff       	call   801a0d <syscall>
  801f61:	83 c4 18             	add    $0x18,%esp
  801f64:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  801f67:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  801f6b:	75 07                	jne    801f74 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  801f6d:	b8 01 00 00 00       	mov    $0x1,%eax
  801f72:	eb 05                	jmp    801f79 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  801f74:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801f79:	c9                   	leave  
  801f7a:	c3                   	ret    

00801f7b <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  801f7b:	55                   	push   %ebp
  801f7c:	89 e5                	mov    %esp,%ebp
  801f7e:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801f81:	6a 00                	push   $0x0
  801f83:	6a 00                	push   $0x0
  801f85:	6a 00                	push   $0x0
  801f87:	6a 00                	push   $0x0
  801f89:	6a 00                	push   $0x0
  801f8b:	6a 2c                	push   $0x2c
  801f8d:	e8 7b fa ff ff       	call   801a0d <syscall>
  801f92:	83 c4 18             	add    $0x18,%esp
  801f95:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  801f98:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  801f9c:	75 07                	jne    801fa5 <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  801f9e:	b8 01 00 00 00       	mov    $0x1,%eax
  801fa3:	eb 05                	jmp    801faa <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  801fa5:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801faa:	c9                   	leave  
  801fab:	c3                   	ret    

00801fac <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  801fac:	55                   	push   %ebp
  801fad:	89 e5                	mov    %esp,%ebp
  801faf:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801fb2:	6a 00                	push   $0x0
  801fb4:	6a 00                	push   $0x0
  801fb6:	6a 00                	push   $0x0
  801fb8:	6a 00                	push   $0x0
  801fba:	6a 00                	push   $0x0
  801fbc:	6a 2c                	push   $0x2c
  801fbe:	e8 4a fa ff ff       	call   801a0d <syscall>
  801fc3:	83 c4 18             	add    $0x18,%esp
  801fc6:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  801fc9:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  801fcd:	75 07                	jne    801fd6 <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  801fcf:	b8 01 00 00 00       	mov    $0x1,%eax
  801fd4:	eb 05                	jmp    801fdb <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  801fd6:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801fdb:	c9                   	leave  
  801fdc:	c3                   	ret    

00801fdd <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  801fdd:	55                   	push   %ebp
  801fde:	89 e5                	mov    %esp,%ebp
  801fe0:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801fe3:	6a 00                	push   $0x0
  801fe5:	6a 00                	push   $0x0
  801fe7:	6a 00                	push   $0x0
  801fe9:	6a 00                	push   $0x0
  801feb:	6a 00                	push   $0x0
  801fed:	6a 2c                	push   $0x2c
  801fef:	e8 19 fa ff ff       	call   801a0d <syscall>
  801ff4:	83 c4 18             	add    $0x18,%esp
  801ff7:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  801ffa:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  801ffe:	75 07                	jne    802007 <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  802000:	b8 01 00 00 00       	mov    $0x1,%eax
  802005:	eb 05                	jmp    80200c <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  802007:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80200c:	c9                   	leave  
  80200d:	c3                   	ret    

0080200e <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  80200e:	55                   	push   %ebp
  80200f:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  802011:	6a 00                	push   $0x0
  802013:	6a 00                	push   $0x0
  802015:	6a 00                	push   $0x0
  802017:	6a 00                	push   $0x0
  802019:	ff 75 08             	pushl  0x8(%ebp)
  80201c:	6a 2d                	push   $0x2d
  80201e:	e8 ea f9 ff ff       	call   801a0d <syscall>
  802023:	83 c4 18             	add    $0x18,%esp
	return ;
  802026:	90                   	nop
}
  802027:	c9                   	leave  
  802028:	c3                   	ret    

00802029 <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  802029:	55                   	push   %ebp
  80202a:	89 e5                	mov    %esp,%ebp
  80202c:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  80202d:	8b 5d 14             	mov    0x14(%ebp),%ebx
  802030:	8b 4d 10             	mov    0x10(%ebp),%ecx
  802033:	8b 55 0c             	mov    0xc(%ebp),%edx
  802036:	8b 45 08             	mov    0x8(%ebp),%eax
  802039:	6a 00                	push   $0x0
  80203b:	53                   	push   %ebx
  80203c:	51                   	push   %ecx
  80203d:	52                   	push   %edx
  80203e:	50                   	push   %eax
  80203f:	6a 2e                	push   $0x2e
  802041:	e8 c7 f9 ff ff       	call   801a0d <syscall>
  802046:	83 c4 18             	add    $0x18,%esp
}
  802049:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80204c:	c9                   	leave  
  80204d:	c3                   	ret    

0080204e <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  80204e:	55                   	push   %ebp
  80204f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  802051:	8b 55 0c             	mov    0xc(%ebp),%edx
  802054:	8b 45 08             	mov    0x8(%ebp),%eax
  802057:	6a 00                	push   $0x0
  802059:	6a 00                	push   $0x0
  80205b:	6a 00                	push   $0x0
  80205d:	52                   	push   %edx
  80205e:	50                   	push   %eax
  80205f:	6a 2f                	push   $0x2f
  802061:	e8 a7 f9 ff ff       	call   801a0d <syscall>
  802066:	83 c4 18             	add    $0x18,%esp
}
  802069:	c9                   	leave  
  80206a:	c3                   	ret    

0080206b <print_mem_block_lists>:
//===========================
// PRINT MEM BLOCK LISTS:
//===========================

void print_mem_block_lists()
{
  80206b:	55                   	push   %ebp
  80206c:	89 e5                	mov    %esp,%ebp
  80206e:	83 ec 18             	sub    $0x18,%esp
	cprintf("\n=========================================\n");
  802071:	83 ec 0c             	sub    $0xc,%esp
  802074:	68 60 3c 80 00       	push   $0x803c60
  802079:	e8 dd e6 ff ff       	call   80075b <cprintf>
  80207e:	83 c4 10             	add    $0x10,%esp
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
  802081:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nFreeMemBlocksList:\n");
  802088:	83 ec 0c             	sub    $0xc,%esp
  80208b:	68 8c 3c 80 00       	push   $0x803c8c
  802090:	e8 c6 e6 ff ff       	call   80075b <cprintf>
  802095:	83 c4 10             	add    $0x10,%esp
	uint8 sorted = 1 ;
  802098:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &FreeMemBlocksList)
  80209c:	a1 38 41 80 00       	mov    0x804138,%eax
  8020a1:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8020a4:	eb 56                	jmp    8020fc <print_mem_block_lists+0x91>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  8020a6:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8020aa:	74 1c                	je     8020c8 <print_mem_block_lists+0x5d>
  8020ac:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8020af:	8b 50 08             	mov    0x8(%eax),%edx
  8020b2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8020b5:	8b 48 08             	mov    0x8(%eax),%ecx
  8020b8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8020bb:	8b 40 0c             	mov    0xc(%eax),%eax
  8020be:	01 c8                	add    %ecx,%eax
  8020c0:	39 c2                	cmp    %eax,%edx
  8020c2:	73 04                	jae    8020c8 <print_mem_block_lists+0x5d>
			sorted = 0 ;
  8020c4:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  8020c8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8020cb:	8b 50 08             	mov    0x8(%eax),%edx
  8020ce:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8020d1:	8b 40 0c             	mov    0xc(%eax),%eax
  8020d4:	01 c2                	add    %eax,%edx
  8020d6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8020d9:	8b 40 08             	mov    0x8(%eax),%eax
  8020dc:	83 ec 04             	sub    $0x4,%esp
  8020df:	52                   	push   %edx
  8020e0:	50                   	push   %eax
  8020e1:	68 a1 3c 80 00       	push   $0x803ca1
  8020e6:	e8 70 e6 ff ff       	call   80075b <cprintf>
  8020eb:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  8020ee:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8020f1:	89 45 f0             	mov    %eax,-0x10(%ebp)
	cprintf("\n=========================================\n");
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
	cprintf("\nFreeMemBlocksList:\n");
	uint8 sorted = 1 ;
	LIST_FOREACH(blk, &FreeMemBlocksList)
  8020f4:	a1 40 41 80 00       	mov    0x804140,%eax
  8020f9:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8020fc:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802100:	74 07                	je     802109 <print_mem_block_lists+0x9e>
  802102:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802105:	8b 00                	mov    (%eax),%eax
  802107:	eb 05                	jmp    80210e <print_mem_block_lists+0xa3>
  802109:	b8 00 00 00 00       	mov    $0x0,%eax
  80210e:	a3 40 41 80 00       	mov    %eax,0x804140
  802113:	a1 40 41 80 00       	mov    0x804140,%eax
  802118:	85 c0                	test   %eax,%eax
  80211a:	75 8a                	jne    8020a6 <print_mem_block_lists+0x3b>
  80211c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802120:	75 84                	jne    8020a6 <print_mem_block_lists+0x3b>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;
  802122:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  802126:	75 10                	jne    802138 <print_mem_block_lists+0xcd>
  802128:	83 ec 0c             	sub    $0xc,%esp
  80212b:	68 b0 3c 80 00       	push   $0x803cb0
  802130:	e8 26 e6 ff ff       	call   80075b <cprintf>
  802135:	83 c4 10             	add    $0x10,%esp

	lastBlk = NULL ;
  802138:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nAllocMemBlocksList:\n");
  80213f:	83 ec 0c             	sub    $0xc,%esp
  802142:	68 d4 3c 80 00       	push   $0x803cd4
  802147:	e8 0f e6 ff ff       	call   80075b <cprintf>
  80214c:	83 c4 10             	add    $0x10,%esp
	sorted = 1 ;
  80214f:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &AllocMemBlocksList)
  802153:	a1 40 40 80 00       	mov    0x804040,%eax
  802158:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80215b:	eb 56                	jmp    8021b3 <print_mem_block_lists+0x148>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  80215d:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802161:	74 1c                	je     80217f <print_mem_block_lists+0x114>
  802163:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802166:	8b 50 08             	mov    0x8(%eax),%edx
  802169:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80216c:	8b 48 08             	mov    0x8(%eax),%ecx
  80216f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802172:	8b 40 0c             	mov    0xc(%eax),%eax
  802175:	01 c8                	add    %ecx,%eax
  802177:	39 c2                	cmp    %eax,%edx
  802179:	73 04                	jae    80217f <print_mem_block_lists+0x114>
			sorted = 0 ;
  80217b:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  80217f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802182:	8b 50 08             	mov    0x8(%eax),%edx
  802185:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802188:	8b 40 0c             	mov    0xc(%eax),%eax
  80218b:	01 c2                	add    %eax,%edx
  80218d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802190:	8b 40 08             	mov    0x8(%eax),%eax
  802193:	83 ec 04             	sub    $0x4,%esp
  802196:	52                   	push   %edx
  802197:	50                   	push   %eax
  802198:	68 a1 3c 80 00       	push   $0x803ca1
  80219d:	e8 b9 e5 ff ff       	call   80075b <cprintf>
  8021a2:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  8021a5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8021a8:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;

	lastBlk = NULL ;
	cprintf("\nAllocMemBlocksList:\n");
	sorted = 1 ;
	LIST_FOREACH(blk, &AllocMemBlocksList)
  8021ab:	a1 48 40 80 00       	mov    0x804048,%eax
  8021b0:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8021b3:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8021b7:	74 07                	je     8021c0 <print_mem_block_lists+0x155>
  8021b9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8021bc:	8b 00                	mov    (%eax),%eax
  8021be:	eb 05                	jmp    8021c5 <print_mem_block_lists+0x15a>
  8021c0:	b8 00 00 00 00       	mov    $0x0,%eax
  8021c5:	a3 48 40 80 00       	mov    %eax,0x804048
  8021ca:	a1 48 40 80 00       	mov    0x804048,%eax
  8021cf:	85 c0                	test   %eax,%eax
  8021d1:	75 8a                	jne    80215d <print_mem_block_lists+0xf2>
  8021d3:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8021d7:	75 84                	jne    80215d <print_mem_block_lists+0xf2>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nAllocMemBlocksList is NOT SORTED!!\n") ;
  8021d9:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  8021dd:	75 10                	jne    8021ef <print_mem_block_lists+0x184>
  8021df:	83 ec 0c             	sub    $0xc,%esp
  8021e2:	68 ec 3c 80 00       	push   $0x803cec
  8021e7:	e8 6f e5 ff ff       	call   80075b <cprintf>
  8021ec:	83 c4 10             	add    $0x10,%esp
	cprintf("\n=========================================\n");
  8021ef:	83 ec 0c             	sub    $0xc,%esp
  8021f2:	68 60 3c 80 00       	push   $0x803c60
  8021f7:	e8 5f e5 ff ff       	call   80075b <cprintf>
  8021fc:	83 c4 10             	add    $0x10,%esp

}
  8021ff:	90                   	nop
  802200:	c9                   	leave  
  802201:	c3                   	ret    

00802202 <initialize_MemBlocksList>:

//===============================
// [1] INITIALIZE AVAILABLE LIST:
//===============================
void initialize_MemBlocksList(uint32 numOfBlocks)
{
  802202:	55                   	push   %ebp
  802203:	89 e5                	mov    %esp,%ebp
  802205:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] initialize_MemBlocksList
	// Write your code here, remove the panic and write your code
	//panic("initialize_MemBlocksList() is not implemented yet...!!");
	uint32 n = numOfBlocks;
  802208:	8b 45 08             	mov    0x8(%ebp),%eax
  80220b:	89 45 f0             	mov    %eax,-0x10(%ebp)

	LIST_INIT(&AvailableMemBlocksList);
  80220e:	c7 05 48 41 80 00 00 	movl   $0x0,0x804148
  802215:	00 00 00 
  802218:	c7 05 4c 41 80 00 00 	movl   $0x0,0x80414c
  80221f:	00 00 00 
  802222:	c7 05 54 41 80 00 00 	movl   $0x0,0x804154
  802229:	00 00 00 
	for(int i = 0; i<n;i++)
  80222c:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  802233:	e9 9e 00 00 00       	jmp    8022d6 <initialize_MemBlocksList+0xd4>
	{
		LIST_INSERT_HEAD(&AvailableMemBlocksList, &(MemBlockNodes[i]));
  802238:	a1 50 40 80 00       	mov    0x804050,%eax
  80223d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802240:	c1 e2 04             	shl    $0x4,%edx
  802243:	01 d0                	add    %edx,%eax
  802245:	85 c0                	test   %eax,%eax
  802247:	75 14                	jne    80225d <initialize_MemBlocksList+0x5b>
  802249:	83 ec 04             	sub    $0x4,%esp
  80224c:	68 14 3d 80 00       	push   $0x803d14
  802251:	6a 47                	push   $0x47
  802253:	68 37 3d 80 00       	push   $0x803d37
  802258:	e8 4a e2 ff ff       	call   8004a7 <_panic>
  80225d:	a1 50 40 80 00       	mov    0x804050,%eax
  802262:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802265:	c1 e2 04             	shl    $0x4,%edx
  802268:	01 d0                	add    %edx,%eax
  80226a:	8b 15 48 41 80 00    	mov    0x804148,%edx
  802270:	89 10                	mov    %edx,(%eax)
  802272:	8b 00                	mov    (%eax),%eax
  802274:	85 c0                	test   %eax,%eax
  802276:	74 18                	je     802290 <initialize_MemBlocksList+0x8e>
  802278:	a1 48 41 80 00       	mov    0x804148,%eax
  80227d:	8b 15 50 40 80 00    	mov    0x804050,%edx
  802283:	8b 4d f4             	mov    -0xc(%ebp),%ecx
  802286:	c1 e1 04             	shl    $0x4,%ecx
  802289:	01 ca                	add    %ecx,%edx
  80228b:	89 50 04             	mov    %edx,0x4(%eax)
  80228e:	eb 12                	jmp    8022a2 <initialize_MemBlocksList+0xa0>
  802290:	a1 50 40 80 00       	mov    0x804050,%eax
  802295:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802298:	c1 e2 04             	shl    $0x4,%edx
  80229b:	01 d0                	add    %edx,%eax
  80229d:	a3 4c 41 80 00       	mov    %eax,0x80414c
  8022a2:	a1 50 40 80 00       	mov    0x804050,%eax
  8022a7:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8022aa:	c1 e2 04             	shl    $0x4,%edx
  8022ad:	01 d0                	add    %edx,%eax
  8022af:	a3 48 41 80 00       	mov    %eax,0x804148
  8022b4:	a1 50 40 80 00       	mov    0x804050,%eax
  8022b9:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8022bc:	c1 e2 04             	shl    $0x4,%edx
  8022bf:	01 d0                	add    %edx,%eax
  8022c1:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8022c8:	a1 54 41 80 00       	mov    0x804154,%eax
  8022cd:	40                   	inc    %eax
  8022ce:	a3 54 41 80 00       	mov    %eax,0x804154
	// Write your code here, remove the panic and write your code
	//panic("initialize_MemBlocksList() is not implemented yet...!!");
	uint32 n = numOfBlocks;

	LIST_INIT(&AvailableMemBlocksList);
	for(int i = 0; i<n;i++)
  8022d3:	ff 45 f4             	incl   -0xc(%ebp)
  8022d6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022d9:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8022dc:	0f 82 56 ff ff ff    	jb     802238 <initialize_MemBlocksList+0x36>
	{
		LIST_INSERT_HEAD(&AvailableMemBlocksList, &(MemBlockNodes[i]));
	}
}
  8022e2:	90                   	nop
  8022e3:	c9                   	leave  
  8022e4:	c3                   	ret    

008022e5 <find_block>:

//===============================
// [2] FIND BLOCK:
//===============================
struct MemBlock *find_block(struct MemBlock_List *blockList, uint32 va)
{
  8022e5:	55                   	push   %ebp
  8022e6:	89 e5                	mov    %esp,%ebp
  8022e8:	83 ec 10             	sub    $0x10,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] find_block
	// Write your code here, remove the panic and write your code
	//panic("find_block() is not implemented yet...!!");
	uint32 virAddress = va;
  8022eb:	8b 45 0c             	mov    0xc(%ebp),%eax
  8022ee:	89 45 f4             	mov    %eax,-0xc(%ebp)
	struct MemBlock* blk;
	int found = 0;
  8022f1:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	LIST_FOREACH(blk, &(AllocMemBlocksList))
  8022f8:	a1 40 40 80 00       	mov    0x804040,%eax
  8022fd:	89 45 fc             	mov    %eax,-0x4(%ebp)
  802300:	eb 23                	jmp    802325 <find_block+0x40>
	{
		if(blk->sva == virAddress)
  802302:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802305:	8b 40 08             	mov    0x8(%eax),%eax
  802308:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  80230b:	75 09                	jne    802316 <find_block+0x31>
		{
			found = 1;
  80230d:	c7 45 f8 01 00 00 00 	movl   $0x1,-0x8(%ebp)
			break;
  802314:	eb 35                	jmp    80234b <find_block+0x66>
		}
		else
		{
			found = 0;
  802316:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	//panic("find_block() is not implemented yet...!!");
	uint32 virAddress = va;
	struct MemBlock* blk;
	int found = 0;

	LIST_FOREACH(blk, &(AllocMemBlocksList))
  80231d:	a1 48 40 80 00       	mov    0x804048,%eax
  802322:	89 45 fc             	mov    %eax,-0x4(%ebp)
  802325:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  802329:	74 07                	je     802332 <find_block+0x4d>
  80232b:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80232e:	8b 00                	mov    (%eax),%eax
  802330:	eb 05                	jmp    802337 <find_block+0x52>
  802332:	b8 00 00 00 00       	mov    $0x0,%eax
  802337:	a3 48 40 80 00       	mov    %eax,0x804048
  80233c:	a1 48 40 80 00       	mov    0x804048,%eax
  802341:	85 c0                	test   %eax,%eax
  802343:	75 bd                	jne    802302 <find_block+0x1d>
  802345:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  802349:	75 b7                	jne    802302 <find_block+0x1d>
		{
			found = 0;
			continue;
		}
	}
	if(found == 1)
  80234b:	83 7d f8 01          	cmpl   $0x1,-0x8(%ebp)
  80234f:	75 05                	jne    802356 <find_block+0x71>
	{
		return blk;
  802351:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802354:	eb 05                	jmp    80235b <find_block+0x76>
	}
	else
	{
		return NULL;
  802356:	b8 00 00 00 00       	mov    $0x0,%eax
	}
}
  80235b:	c9                   	leave  
  80235c:	c3                   	ret    

0080235d <insert_sorted_allocList>:

//=========================================
// [3] INSERT BLOCK IN ALLOC LIST [SORTED]:
//=========================================
void insert_sorted_allocList(struct MemBlock *blockToInsert)
{
  80235d:	55                   	push   %ebp
  80235e:	89 e5                	mov    %esp,%ebp
  802360:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] insert_sorted_allocList
	// Write your code here, remove the panic and write your code
	//panic("insert_sorted_allocList() is not implemented yet...!!");
	struct MemBlock* blk;
	struct MemBlock* newblk = blockToInsert;
  802363:	8b 45 08             	mov    0x8(%ebp),%eax
  802366:	89 45 f0             	mov    %eax,-0x10(%ebp)

	if((LIST_EMPTY(&AllocMemBlocksList)) || (newblk->sva < LIST_FIRST(&AllocMemBlocksList)->sva))
  802369:	a1 40 40 80 00       	mov    0x804040,%eax
  80236e:	85 c0                	test   %eax,%eax
  802370:	74 12                	je     802384 <insert_sorted_allocList+0x27>
  802372:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802375:	8b 50 08             	mov    0x8(%eax),%edx
  802378:	a1 40 40 80 00       	mov    0x804040,%eax
  80237d:	8b 40 08             	mov    0x8(%eax),%eax
  802380:	39 c2                	cmp    %eax,%edx
  802382:	73 65                	jae    8023e9 <insert_sorted_allocList+0x8c>
	{
		LIST_INSERT_HEAD(&(AllocMemBlocksList), newblk);
  802384:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802388:	75 14                	jne    80239e <insert_sorted_allocList+0x41>
  80238a:	83 ec 04             	sub    $0x4,%esp
  80238d:	68 14 3d 80 00       	push   $0x803d14
  802392:	6a 7b                	push   $0x7b
  802394:	68 37 3d 80 00       	push   $0x803d37
  802399:	e8 09 e1 ff ff       	call   8004a7 <_panic>
  80239e:	8b 15 40 40 80 00    	mov    0x804040,%edx
  8023a4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8023a7:	89 10                	mov    %edx,(%eax)
  8023a9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8023ac:	8b 00                	mov    (%eax),%eax
  8023ae:	85 c0                	test   %eax,%eax
  8023b0:	74 0d                	je     8023bf <insert_sorted_allocList+0x62>
  8023b2:	a1 40 40 80 00       	mov    0x804040,%eax
  8023b7:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8023ba:	89 50 04             	mov    %edx,0x4(%eax)
  8023bd:	eb 08                	jmp    8023c7 <insert_sorted_allocList+0x6a>
  8023bf:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8023c2:	a3 44 40 80 00       	mov    %eax,0x804044
  8023c7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8023ca:	a3 40 40 80 00       	mov    %eax,0x804040
  8023cf:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8023d2:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8023d9:	a1 4c 40 80 00       	mov    0x80404c,%eax
  8023de:	40                   	inc    %eax
  8023df:	a3 4c 40 80 00       	mov    %eax,0x80404c
  8023e4:	e9 5f 01 00 00       	jmp    802548 <insert_sorted_allocList+0x1eb>
	}
	else if(newblk->sva > LIST_LAST(&AllocMemBlocksList)->sva)
  8023e9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8023ec:	8b 50 08             	mov    0x8(%eax),%edx
  8023ef:	a1 44 40 80 00       	mov    0x804044,%eax
  8023f4:	8b 40 08             	mov    0x8(%eax),%eax
  8023f7:	39 c2                	cmp    %eax,%edx
  8023f9:	76 65                	jbe    802460 <insert_sorted_allocList+0x103>
	{
		LIST_INSERT_TAIL(&AllocMemBlocksList, newblk);
  8023fb:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8023ff:	75 14                	jne    802415 <insert_sorted_allocList+0xb8>
  802401:	83 ec 04             	sub    $0x4,%esp
  802404:	68 50 3d 80 00       	push   $0x803d50
  802409:	6a 7f                	push   $0x7f
  80240b:	68 37 3d 80 00       	push   $0x803d37
  802410:	e8 92 e0 ff ff       	call   8004a7 <_panic>
  802415:	8b 15 44 40 80 00    	mov    0x804044,%edx
  80241b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80241e:	89 50 04             	mov    %edx,0x4(%eax)
  802421:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802424:	8b 40 04             	mov    0x4(%eax),%eax
  802427:	85 c0                	test   %eax,%eax
  802429:	74 0c                	je     802437 <insert_sorted_allocList+0xda>
  80242b:	a1 44 40 80 00       	mov    0x804044,%eax
  802430:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802433:	89 10                	mov    %edx,(%eax)
  802435:	eb 08                	jmp    80243f <insert_sorted_allocList+0xe2>
  802437:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80243a:	a3 40 40 80 00       	mov    %eax,0x804040
  80243f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802442:	a3 44 40 80 00       	mov    %eax,0x804044
  802447:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80244a:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802450:	a1 4c 40 80 00       	mov    0x80404c,%eax
  802455:	40                   	inc    %eax
  802456:	a3 4c 40 80 00       	mov    %eax,0x80404c
				LIST_INSERT_AFTER(&AllocMemBlocksList, blk, newblk);
				break;
			}
		}
	}
}
  80245b:	e9 e8 00 00 00       	jmp    802548 <insert_sorted_allocList+0x1eb>
	{
		LIST_INSERT_TAIL(&AllocMemBlocksList, newblk);
	}
	else
	{
		LIST_FOREACH(blk, &AllocMemBlocksList)
  802460:	a1 40 40 80 00       	mov    0x804040,%eax
  802465:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802468:	e9 ab 00 00 00       	jmp    802518 <insert_sorted_allocList+0x1bb>
		{
			if(blk->prev_next_info.le_next != NULL && newblk->sva > blk->sva  && newblk->sva < blk->prev_next_info.le_next->sva)
  80246d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802470:	8b 00                	mov    (%eax),%eax
  802472:	85 c0                	test   %eax,%eax
  802474:	0f 84 96 00 00 00    	je     802510 <insert_sorted_allocList+0x1b3>
  80247a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80247d:	8b 50 08             	mov    0x8(%eax),%edx
  802480:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802483:	8b 40 08             	mov    0x8(%eax),%eax
  802486:	39 c2                	cmp    %eax,%edx
  802488:	0f 86 82 00 00 00    	jbe    802510 <insert_sorted_allocList+0x1b3>
  80248e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802491:	8b 50 08             	mov    0x8(%eax),%edx
  802494:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802497:	8b 00                	mov    (%eax),%eax
  802499:	8b 40 08             	mov    0x8(%eax),%eax
  80249c:	39 c2                	cmp    %eax,%edx
  80249e:	73 70                	jae    802510 <insert_sorted_allocList+0x1b3>
			{
				LIST_INSERT_AFTER(&AllocMemBlocksList, blk, newblk);
  8024a0:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8024a4:	74 06                	je     8024ac <insert_sorted_allocList+0x14f>
  8024a6:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8024aa:	75 17                	jne    8024c3 <insert_sorted_allocList+0x166>
  8024ac:	83 ec 04             	sub    $0x4,%esp
  8024af:	68 74 3d 80 00       	push   $0x803d74
  8024b4:	68 87 00 00 00       	push   $0x87
  8024b9:	68 37 3d 80 00       	push   $0x803d37
  8024be:	e8 e4 df ff ff       	call   8004a7 <_panic>
  8024c3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024c6:	8b 10                	mov    (%eax),%edx
  8024c8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8024cb:	89 10                	mov    %edx,(%eax)
  8024cd:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8024d0:	8b 00                	mov    (%eax),%eax
  8024d2:	85 c0                	test   %eax,%eax
  8024d4:	74 0b                	je     8024e1 <insert_sorted_allocList+0x184>
  8024d6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024d9:	8b 00                	mov    (%eax),%eax
  8024db:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8024de:	89 50 04             	mov    %edx,0x4(%eax)
  8024e1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024e4:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8024e7:	89 10                	mov    %edx,(%eax)
  8024e9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8024ec:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8024ef:	89 50 04             	mov    %edx,0x4(%eax)
  8024f2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8024f5:	8b 00                	mov    (%eax),%eax
  8024f7:	85 c0                	test   %eax,%eax
  8024f9:	75 08                	jne    802503 <insert_sorted_allocList+0x1a6>
  8024fb:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8024fe:	a3 44 40 80 00       	mov    %eax,0x804044
  802503:	a1 4c 40 80 00       	mov    0x80404c,%eax
  802508:	40                   	inc    %eax
  802509:	a3 4c 40 80 00       	mov    %eax,0x80404c
				break;
  80250e:	eb 38                	jmp    802548 <insert_sorted_allocList+0x1eb>
	{
		LIST_INSERT_TAIL(&AllocMemBlocksList, newblk);
	}
	else
	{
		LIST_FOREACH(blk, &AllocMemBlocksList)
  802510:	a1 48 40 80 00       	mov    0x804048,%eax
  802515:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802518:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80251c:	74 07                	je     802525 <insert_sorted_allocList+0x1c8>
  80251e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802521:	8b 00                	mov    (%eax),%eax
  802523:	eb 05                	jmp    80252a <insert_sorted_allocList+0x1cd>
  802525:	b8 00 00 00 00       	mov    $0x0,%eax
  80252a:	a3 48 40 80 00       	mov    %eax,0x804048
  80252f:	a1 48 40 80 00       	mov    0x804048,%eax
  802534:	85 c0                	test   %eax,%eax
  802536:	0f 85 31 ff ff ff    	jne    80246d <insert_sorted_allocList+0x110>
  80253c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802540:	0f 85 27 ff ff ff    	jne    80246d <insert_sorted_allocList+0x110>
				LIST_INSERT_AFTER(&AllocMemBlocksList, blk, newblk);
				break;
			}
		}
	}
}
  802546:	eb 00                	jmp    802548 <insert_sorted_allocList+0x1eb>
  802548:	90                   	nop
  802549:	c9                   	leave  
  80254a:	c3                   	ret    

0080254b <alloc_block_FF>:

//=========================================
// [4] ALLOCATE BLOCK BY FIRST FIT:
//=========================================
struct MemBlock *alloc_block_FF(uint32 size)
{
  80254b:	55                   	push   %ebp
  80254c:	89 e5                	mov    %esp,%ebp
  80254e:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_FF
	// Write your code here, remove the panic and write your code
	//panic("alloc_block_FF() is not implemented yet...!!");
	uint32 versize = size;
  802551:	8b 45 08             	mov    0x8(%ebp),%eax
  802554:	89 45 f0             	mov    %eax,-0x10(%ebp)
	struct MemBlock* blk;
	struct MemBlock* newblk = LIST_FIRST(&AvailableMemBlocksList);
  802557:	a1 48 41 80 00       	mov    0x804148,%eax
  80255c:	89 45 ec             	mov    %eax,-0x14(%ebp)

	LIST_FOREACH(blk,&FreeMemBlocksList)
  80255f:	a1 38 41 80 00       	mov    0x804138,%eax
  802564:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802567:	e9 77 01 00 00       	jmp    8026e3 <alloc_block_FF+0x198>
	{
		if(blk->size == versize)
  80256c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80256f:	8b 40 0c             	mov    0xc(%eax),%eax
  802572:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  802575:	0f 85 8a 00 00 00    	jne    802605 <alloc_block_FF+0xba>
		{
			LIST_REMOVE(&FreeMemBlocksList,blk);
  80257b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80257f:	75 17                	jne    802598 <alloc_block_FF+0x4d>
  802581:	83 ec 04             	sub    $0x4,%esp
  802584:	68 a8 3d 80 00       	push   $0x803da8
  802589:	68 9e 00 00 00       	push   $0x9e
  80258e:	68 37 3d 80 00       	push   $0x803d37
  802593:	e8 0f df ff ff       	call   8004a7 <_panic>
  802598:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80259b:	8b 00                	mov    (%eax),%eax
  80259d:	85 c0                	test   %eax,%eax
  80259f:	74 10                	je     8025b1 <alloc_block_FF+0x66>
  8025a1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025a4:	8b 00                	mov    (%eax),%eax
  8025a6:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8025a9:	8b 52 04             	mov    0x4(%edx),%edx
  8025ac:	89 50 04             	mov    %edx,0x4(%eax)
  8025af:	eb 0b                	jmp    8025bc <alloc_block_FF+0x71>
  8025b1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025b4:	8b 40 04             	mov    0x4(%eax),%eax
  8025b7:	a3 3c 41 80 00       	mov    %eax,0x80413c
  8025bc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025bf:	8b 40 04             	mov    0x4(%eax),%eax
  8025c2:	85 c0                	test   %eax,%eax
  8025c4:	74 0f                	je     8025d5 <alloc_block_FF+0x8a>
  8025c6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025c9:	8b 40 04             	mov    0x4(%eax),%eax
  8025cc:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8025cf:	8b 12                	mov    (%edx),%edx
  8025d1:	89 10                	mov    %edx,(%eax)
  8025d3:	eb 0a                	jmp    8025df <alloc_block_FF+0x94>
  8025d5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025d8:	8b 00                	mov    (%eax),%eax
  8025da:	a3 38 41 80 00       	mov    %eax,0x804138
  8025df:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025e2:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8025e8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025eb:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8025f2:	a1 44 41 80 00       	mov    0x804144,%eax
  8025f7:	48                   	dec    %eax
  8025f8:	a3 44 41 80 00       	mov    %eax,0x804144
			return blk;
  8025fd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802600:	e9 11 01 00 00       	jmp    802716 <alloc_block_FF+0x1cb>
		}
		else if(blk->size > versize)
  802605:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802608:	8b 40 0c             	mov    0xc(%eax),%eax
  80260b:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  80260e:	0f 86 c7 00 00 00    	jbe    8026db <alloc_block_FF+0x190>
		{
			LIST_REMOVE(&AvailableMemBlocksList,newblk);
  802614:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802618:	75 17                	jne    802631 <alloc_block_FF+0xe6>
  80261a:	83 ec 04             	sub    $0x4,%esp
  80261d:	68 a8 3d 80 00       	push   $0x803da8
  802622:	68 a3 00 00 00       	push   $0xa3
  802627:	68 37 3d 80 00       	push   $0x803d37
  80262c:	e8 76 de ff ff       	call   8004a7 <_panic>
  802631:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802634:	8b 00                	mov    (%eax),%eax
  802636:	85 c0                	test   %eax,%eax
  802638:	74 10                	je     80264a <alloc_block_FF+0xff>
  80263a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80263d:	8b 00                	mov    (%eax),%eax
  80263f:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802642:	8b 52 04             	mov    0x4(%edx),%edx
  802645:	89 50 04             	mov    %edx,0x4(%eax)
  802648:	eb 0b                	jmp    802655 <alloc_block_FF+0x10a>
  80264a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80264d:	8b 40 04             	mov    0x4(%eax),%eax
  802650:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802655:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802658:	8b 40 04             	mov    0x4(%eax),%eax
  80265b:	85 c0                	test   %eax,%eax
  80265d:	74 0f                	je     80266e <alloc_block_FF+0x123>
  80265f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802662:	8b 40 04             	mov    0x4(%eax),%eax
  802665:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802668:	8b 12                	mov    (%edx),%edx
  80266a:	89 10                	mov    %edx,(%eax)
  80266c:	eb 0a                	jmp    802678 <alloc_block_FF+0x12d>
  80266e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802671:	8b 00                	mov    (%eax),%eax
  802673:	a3 48 41 80 00       	mov    %eax,0x804148
  802678:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80267b:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802681:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802684:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80268b:	a1 54 41 80 00       	mov    0x804154,%eax
  802690:	48                   	dec    %eax
  802691:	a3 54 41 80 00       	mov    %eax,0x804154
			newblk->size = versize;
  802696:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802699:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80269c:	89 50 0c             	mov    %edx,0xc(%eax)
			blk->size = blk->size-versize;
  80269f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026a2:	8b 40 0c             	mov    0xc(%eax),%eax
  8026a5:	2b 45 f0             	sub    -0x10(%ebp),%eax
  8026a8:	89 c2                	mov    %eax,%edx
  8026aa:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026ad:	89 50 0c             	mov    %edx,0xc(%eax)
			uint32 newveradd = blk->sva;
  8026b0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026b3:	8b 40 08             	mov    0x8(%eax),%eax
  8026b6:	89 45 e8             	mov    %eax,-0x18(%ebp)
			blk->sva+=newblk->size;
  8026b9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026bc:	8b 50 08             	mov    0x8(%eax),%edx
  8026bf:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8026c2:	8b 40 0c             	mov    0xc(%eax),%eax
  8026c5:	01 c2                	add    %eax,%edx
  8026c7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026ca:	89 50 08             	mov    %edx,0x8(%eax)
			newblk->sva = newveradd;
  8026cd:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8026d0:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8026d3:	89 50 08             	mov    %edx,0x8(%eax)
			return newblk;
  8026d6:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8026d9:	eb 3b                	jmp    802716 <alloc_block_FF+0x1cb>
	//panic("alloc_block_FF() is not implemented yet...!!");
	uint32 versize = size;
	struct MemBlock* blk;
	struct MemBlock* newblk = LIST_FIRST(&AvailableMemBlocksList);

	LIST_FOREACH(blk,&FreeMemBlocksList)
  8026db:	a1 40 41 80 00       	mov    0x804140,%eax
  8026e0:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8026e3:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8026e7:	74 07                	je     8026f0 <alloc_block_FF+0x1a5>
  8026e9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026ec:	8b 00                	mov    (%eax),%eax
  8026ee:	eb 05                	jmp    8026f5 <alloc_block_FF+0x1aa>
  8026f0:	b8 00 00 00 00       	mov    $0x0,%eax
  8026f5:	a3 40 41 80 00       	mov    %eax,0x804140
  8026fa:	a1 40 41 80 00       	mov    0x804140,%eax
  8026ff:	85 c0                	test   %eax,%eax
  802701:	0f 85 65 fe ff ff    	jne    80256c <alloc_block_FF+0x21>
  802707:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80270b:	0f 85 5b fe ff ff    	jne    80256c <alloc_block_FF+0x21>
			blk->sva+=newblk->size;
			newblk->sva = newveradd;
			return newblk;
		}
	}
	return NULL;
  802711:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802716:	c9                   	leave  
  802717:	c3                   	ret    

00802718 <alloc_block_BF>:

//=========================================
// [5] ALLOCATE BLOCK BY BEST FIT:
//=========================================
struct MemBlock *alloc_block_BF(uint32 size)
{
  802718:	55                   	push   %ebp
  802719:	89 e5                	mov    %esp,%ebp
  80271b:	83 ec 28             	sub    $0x28,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_BF
	// Write your code here, remove the panic and write your code
	//panic("alloc_block_BF() is not implemented yet...!!");
	uint32 versize=size;
  80271e:	8b 45 08             	mov    0x8(%ebp),%eax
  802721:	89 45 e8             	mov    %eax,-0x18(%ebp)
	struct MemBlock* blk;
	struct MemBlock* newblk=LIST_FIRST(&AvailableMemBlocksList);
  802724:	a1 48 41 80 00       	mov    0x804148,%eax
  802729:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	uint32 newveradd;
	uint32 newsize;
	int size_free = LIST_SIZE(&FreeMemBlocksList);
  80272c:	a1 44 41 80 00       	mov    0x804144,%eax
  802731:	89 45 e0             	mov    %eax,-0x20(%ebp)

	LIST_FOREACH(blk, &FreeMemBlocksList)
  802734:	a1 38 41 80 00       	mov    0x804138,%eax
  802739:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80273c:	e9 a1 00 00 00       	jmp    8027e2 <alloc_block_BF+0xca>
	{
		if(blk->size == versize)
  802741:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802744:	8b 40 0c             	mov    0xc(%eax),%eax
  802747:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  80274a:	0f 85 8a 00 00 00    	jne    8027da <alloc_block_BF+0xc2>
		{
			LIST_REMOVE(&FreeMemBlocksList, blk);
  802750:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802754:	75 17                	jne    80276d <alloc_block_BF+0x55>
  802756:	83 ec 04             	sub    $0x4,%esp
  802759:	68 a8 3d 80 00       	push   $0x803da8
  80275e:	68 c2 00 00 00       	push   $0xc2
  802763:	68 37 3d 80 00       	push   $0x803d37
  802768:	e8 3a dd ff ff       	call   8004a7 <_panic>
  80276d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802770:	8b 00                	mov    (%eax),%eax
  802772:	85 c0                	test   %eax,%eax
  802774:	74 10                	je     802786 <alloc_block_BF+0x6e>
  802776:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802779:	8b 00                	mov    (%eax),%eax
  80277b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80277e:	8b 52 04             	mov    0x4(%edx),%edx
  802781:	89 50 04             	mov    %edx,0x4(%eax)
  802784:	eb 0b                	jmp    802791 <alloc_block_BF+0x79>
  802786:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802789:	8b 40 04             	mov    0x4(%eax),%eax
  80278c:	a3 3c 41 80 00       	mov    %eax,0x80413c
  802791:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802794:	8b 40 04             	mov    0x4(%eax),%eax
  802797:	85 c0                	test   %eax,%eax
  802799:	74 0f                	je     8027aa <alloc_block_BF+0x92>
  80279b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80279e:	8b 40 04             	mov    0x4(%eax),%eax
  8027a1:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8027a4:	8b 12                	mov    (%edx),%edx
  8027a6:	89 10                	mov    %edx,(%eax)
  8027a8:	eb 0a                	jmp    8027b4 <alloc_block_BF+0x9c>
  8027aa:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027ad:	8b 00                	mov    (%eax),%eax
  8027af:	a3 38 41 80 00       	mov    %eax,0x804138
  8027b4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027b7:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8027bd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027c0:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8027c7:	a1 44 41 80 00       	mov    0x804144,%eax
  8027cc:	48                   	dec    %eax
  8027cd:	a3 44 41 80 00       	mov    %eax,0x804144
			return blk;
  8027d2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027d5:	e9 11 02 00 00       	jmp    8029eb <alloc_block_BF+0x2d3>
	struct MemBlock* newblk=LIST_FIRST(&AvailableMemBlocksList);
	uint32 newveradd;
	uint32 newsize;
	int size_free = LIST_SIZE(&FreeMemBlocksList);

	LIST_FOREACH(blk, &FreeMemBlocksList)
  8027da:	a1 40 41 80 00       	mov    0x804140,%eax
  8027df:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8027e2:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8027e6:	74 07                	je     8027ef <alloc_block_BF+0xd7>
  8027e8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027eb:	8b 00                	mov    (%eax),%eax
  8027ed:	eb 05                	jmp    8027f4 <alloc_block_BF+0xdc>
  8027ef:	b8 00 00 00 00       	mov    $0x0,%eax
  8027f4:	a3 40 41 80 00       	mov    %eax,0x804140
  8027f9:	a1 40 41 80 00       	mov    0x804140,%eax
  8027fe:	85 c0                	test   %eax,%eax
  802800:	0f 85 3b ff ff ff    	jne    802741 <alloc_block_BF+0x29>
  802806:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80280a:	0f 85 31 ff ff ff    	jne    802741 <alloc_block_BF+0x29>
		{
			LIST_REMOVE(&FreeMemBlocksList, blk);
			return blk;
		}
	}
	LIST_FOREACH(blk, &FreeMemBlocksList)
  802810:	a1 38 41 80 00       	mov    0x804138,%eax
  802815:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802818:	eb 27                	jmp    802841 <alloc_block_BF+0x129>
	{
		if(blk->size > versize)
  80281a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80281d:	8b 40 0c             	mov    0xc(%eax),%eax
  802820:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  802823:	76 14                	jbe    802839 <alloc_block_BF+0x121>
		{
			newsize = blk->size;
  802825:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802828:	8b 40 0c             	mov    0xc(%eax),%eax
  80282b:	89 45 ec             	mov    %eax,-0x14(%ebp)
			newveradd = blk->sva;
  80282e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802831:	8b 40 08             	mov    0x8(%eax),%eax
  802834:	89 45 f0             	mov    %eax,-0x10(%ebp)
			break;
  802837:	eb 2e                	jmp    802867 <alloc_block_BF+0x14f>
		{
			LIST_REMOVE(&FreeMemBlocksList, blk);
			return blk;
		}
	}
	LIST_FOREACH(blk, &FreeMemBlocksList)
  802839:	a1 40 41 80 00       	mov    0x804140,%eax
  80283e:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802841:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802845:	74 07                	je     80284e <alloc_block_BF+0x136>
  802847:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80284a:	8b 00                	mov    (%eax),%eax
  80284c:	eb 05                	jmp    802853 <alloc_block_BF+0x13b>
  80284e:	b8 00 00 00 00       	mov    $0x0,%eax
  802853:	a3 40 41 80 00       	mov    %eax,0x804140
  802858:	a1 40 41 80 00       	mov    0x804140,%eax
  80285d:	85 c0                	test   %eax,%eax
  80285f:	75 b9                	jne    80281a <alloc_block_BF+0x102>
  802861:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802865:	75 b3                	jne    80281a <alloc_block_BF+0x102>
			newsize = blk->size;
			newveradd = blk->sva;
			break;
		}
	}
	LIST_FOREACH(blk, &FreeMemBlocksList)
  802867:	a1 38 41 80 00       	mov    0x804138,%eax
  80286c:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80286f:	eb 30                	jmp    8028a1 <alloc_block_BF+0x189>
	{
		if(newsize > blk->size && blk->size > versize)
  802871:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802874:	8b 40 0c             	mov    0xc(%eax),%eax
  802877:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  80287a:	73 1d                	jae    802899 <alloc_block_BF+0x181>
  80287c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80287f:	8b 40 0c             	mov    0xc(%eax),%eax
  802882:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  802885:	76 12                	jbe    802899 <alloc_block_BF+0x181>
		{
	       newsize = blk->size;
  802887:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80288a:	8b 40 0c             	mov    0xc(%eax),%eax
  80288d:	89 45 ec             	mov    %eax,-0x14(%ebp)
		   newveradd = blk->sva;
  802890:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802893:	8b 40 08             	mov    0x8(%eax),%eax
  802896:	89 45 f0             	mov    %eax,-0x10(%ebp)
			newsize = blk->size;
			newveradd = blk->sva;
			break;
		}
	}
	LIST_FOREACH(blk, &FreeMemBlocksList)
  802899:	a1 40 41 80 00       	mov    0x804140,%eax
  80289e:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8028a1:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8028a5:	74 07                	je     8028ae <alloc_block_BF+0x196>
  8028a7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028aa:	8b 00                	mov    (%eax),%eax
  8028ac:	eb 05                	jmp    8028b3 <alloc_block_BF+0x19b>
  8028ae:	b8 00 00 00 00       	mov    $0x0,%eax
  8028b3:	a3 40 41 80 00       	mov    %eax,0x804140
  8028b8:	a1 40 41 80 00       	mov    0x804140,%eax
  8028bd:	85 c0                	test   %eax,%eax
  8028bf:	75 b0                	jne    802871 <alloc_block_BF+0x159>
  8028c1:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8028c5:	75 aa                	jne    802871 <alloc_block_BF+0x159>
		{
	       newsize = blk->size;
		   newveradd = blk->sva;
		}
	}
	LIST_FOREACH(blk, &FreeMemBlocksList)
  8028c7:	a1 38 41 80 00       	mov    0x804138,%eax
  8028cc:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8028cf:	e9 e4 00 00 00       	jmp    8029b8 <alloc_block_BF+0x2a0>
	{
		if(blk->size == newsize && blk->sva == newveradd)
  8028d4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028d7:	8b 40 0c             	mov    0xc(%eax),%eax
  8028da:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  8028dd:	0f 85 cd 00 00 00    	jne    8029b0 <alloc_block_BF+0x298>
  8028e3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028e6:	8b 40 08             	mov    0x8(%eax),%eax
  8028e9:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8028ec:	0f 85 be 00 00 00    	jne    8029b0 <alloc_block_BF+0x298>
		{
			LIST_REMOVE(&AvailableMemBlocksList, newblk);
  8028f2:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8028f6:	75 17                	jne    80290f <alloc_block_BF+0x1f7>
  8028f8:	83 ec 04             	sub    $0x4,%esp
  8028fb:	68 a8 3d 80 00       	push   $0x803da8
  802900:	68 db 00 00 00       	push   $0xdb
  802905:	68 37 3d 80 00       	push   $0x803d37
  80290a:	e8 98 db ff ff       	call   8004a7 <_panic>
  80290f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802912:	8b 00                	mov    (%eax),%eax
  802914:	85 c0                	test   %eax,%eax
  802916:	74 10                	je     802928 <alloc_block_BF+0x210>
  802918:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80291b:	8b 00                	mov    (%eax),%eax
  80291d:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802920:	8b 52 04             	mov    0x4(%edx),%edx
  802923:	89 50 04             	mov    %edx,0x4(%eax)
  802926:	eb 0b                	jmp    802933 <alloc_block_BF+0x21b>
  802928:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80292b:	8b 40 04             	mov    0x4(%eax),%eax
  80292e:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802933:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802936:	8b 40 04             	mov    0x4(%eax),%eax
  802939:	85 c0                	test   %eax,%eax
  80293b:	74 0f                	je     80294c <alloc_block_BF+0x234>
  80293d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802940:	8b 40 04             	mov    0x4(%eax),%eax
  802943:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802946:	8b 12                	mov    (%edx),%edx
  802948:	89 10                	mov    %edx,(%eax)
  80294a:	eb 0a                	jmp    802956 <alloc_block_BF+0x23e>
  80294c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80294f:	8b 00                	mov    (%eax),%eax
  802951:	a3 48 41 80 00       	mov    %eax,0x804148
  802956:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802959:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80295f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802962:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802969:	a1 54 41 80 00       	mov    0x804154,%eax
  80296e:	48                   	dec    %eax
  80296f:	a3 54 41 80 00       	mov    %eax,0x804154
			newblk->size = versize;
  802974:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802977:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80297a:	89 50 0c             	mov    %edx,0xc(%eax)
			newblk->sva = newveradd;
  80297d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802980:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802983:	89 50 08             	mov    %edx,0x8(%eax)
			blk->size = blk->size - versize;
  802986:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802989:	8b 40 0c             	mov    0xc(%eax),%eax
  80298c:	2b 45 e8             	sub    -0x18(%ebp),%eax
  80298f:	89 c2                	mov    %eax,%edx
  802991:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802994:	89 50 0c             	mov    %edx,0xc(%eax)
			blk->sva+= newblk->size;
  802997:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80299a:	8b 50 08             	mov    0x8(%eax),%edx
  80299d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8029a0:	8b 40 0c             	mov    0xc(%eax),%eax
  8029a3:	01 c2                	add    %eax,%edx
  8029a5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029a8:	89 50 08             	mov    %edx,0x8(%eax)
			return newblk;
  8029ab:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8029ae:	eb 3b                	jmp    8029eb <alloc_block_BF+0x2d3>
		{
	       newsize = blk->size;
		   newveradd = blk->sva;
		}
	}
	LIST_FOREACH(blk, &FreeMemBlocksList)
  8029b0:	a1 40 41 80 00       	mov    0x804140,%eax
  8029b5:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8029b8:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8029bc:	74 07                	je     8029c5 <alloc_block_BF+0x2ad>
  8029be:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029c1:	8b 00                	mov    (%eax),%eax
  8029c3:	eb 05                	jmp    8029ca <alloc_block_BF+0x2b2>
  8029c5:	b8 00 00 00 00       	mov    $0x0,%eax
  8029ca:	a3 40 41 80 00       	mov    %eax,0x804140
  8029cf:	a1 40 41 80 00       	mov    0x804140,%eax
  8029d4:	85 c0                	test   %eax,%eax
  8029d6:	0f 85 f8 fe ff ff    	jne    8028d4 <alloc_block_BF+0x1bc>
  8029dc:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8029e0:	0f 85 ee fe ff ff    	jne    8028d4 <alloc_block_BF+0x1bc>
			blk->size = blk->size - versize;
			blk->sva+= newblk->size;
			return newblk;
		}
	}
	return NULL;
  8029e6:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8029eb:	c9                   	leave  
  8029ec:	c3                   	ret    

008029ed <alloc_block_NF>:
//=========================================
// [7] ALLOCATE BLOCK BY NEXT FIT:
//=========================================
struct MemBlock *last_allocate;
struct MemBlock *alloc_block_NF(uint32 size)
{
  8029ed:	55                   	push   %ebp
  8029ee:	89 e5                	mov    %esp,%ebp
  8029f0:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1 - BONUS] [DYNAMIC ALLOCATOR] alloc_block_NF
	// Write your code here, remove the panic and write your code
	//panic("alloc_block_NF() is not implemented yet...!!");
	uint32 versize = size;
  8029f3:	8b 45 08             	mov    0x8(%ebp),%eax
  8029f6:	89 45 f0             	mov    %eax,-0x10(%ebp)
	struct MemBlock* blk;
	struct MemBlock* newblk = LIST_FIRST(&AvailableMemBlocksList);
  8029f9:	a1 48 41 80 00       	mov    0x804148,%eax
  8029fe:	89 45 ec             	mov    %eax,-0x14(%ebp)

	LIST_FOREACH(blk,&FreeMemBlocksList)
  802a01:	a1 38 41 80 00       	mov    0x804138,%eax
  802a06:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802a09:	e9 77 01 00 00       	jmp    802b85 <alloc_block_NF+0x198>
	{
		if(blk->size == versize)
  802a0e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a11:	8b 40 0c             	mov    0xc(%eax),%eax
  802a14:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  802a17:	0f 85 8a 00 00 00    	jne    802aa7 <alloc_block_NF+0xba>
		{
			LIST_REMOVE(&FreeMemBlocksList,blk);
  802a1d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802a21:	75 17                	jne    802a3a <alloc_block_NF+0x4d>
  802a23:	83 ec 04             	sub    $0x4,%esp
  802a26:	68 a8 3d 80 00       	push   $0x803da8
  802a2b:	68 f7 00 00 00       	push   $0xf7
  802a30:	68 37 3d 80 00       	push   $0x803d37
  802a35:	e8 6d da ff ff       	call   8004a7 <_panic>
  802a3a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a3d:	8b 00                	mov    (%eax),%eax
  802a3f:	85 c0                	test   %eax,%eax
  802a41:	74 10                	je     802a53 <alloc_block_NF+0x66>
  802a43:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a46:	8b 00                	mov    (%eax),%eax
  802a48:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802a4b:	8b 52 04             	mov    0x4(%edx),%edx
  802a4e:	89 50 04             	mov    %edx,0x4(%eax)
  802a51:	eb 0b                	jmp    802a5e <alloc_block_NF+0x71>
  802a53:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a56:	8b 40 04             	mov    0x4(%eax),%eax
  802a59:	a3 3c 41 80 00       	mov    %eax,0x80413c
  802a5e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a61:	8b 40 04             	mov    0x4(%eax),%eax
  802a64:	85 c0                	test   %eax,%eax
  802a66:	74 0f                	je     802a77 <alloc_block_NF+0x8a>
  802a68:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a6b:	8b 40 04             	mov    0x4(%eax),%eax
  802a6e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802a71:	8b 12                	mov    (%edx),%edx
  802a73:	89 10                	mov    %edx,(%eax)
  802a75:	eb 0a                	jmp    802a81 <alloc_block_NF+0x94>
  802a77:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a7a:	8b 00                	mov    (%eax),%eax
  802a7c:	a3 38 41 80 00       	mov    %eax,0x804138
  802a81:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a84:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802a8a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a8d:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802a94:	a1 44 41 80 00       	mov    0x804144,%eax
  802a99:	48                   	dec    %eax
  802a9a:	a3 44 41 80 00       	mov    %eax,0x804144
			return blk;
  802a9f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802aa2:	e9 11 01 00 00       	jmp    802bb8 <alloc_block_NF+0x1cb>
		}
		else if(blk->size > versize)
  802aa7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802aaa:	8b 40 0c             	mov    0xc(%eax),%eax
  802aad:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  802ab0:	0f 86 c7 00 00 00    	jbe    802b7d <alloc_block_NF+0x190>
		{
			LIST_REMOVE(&AvailableMemBlocksList,newblk);
  802ab6:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802aba:	75 17                	jne    802ad3 <alloc_block_NF+0xe6>
  802abc:	83 ec 04             	sub    $0x4,%esp
  802abf:	68 a8 3d 80 00       	push   $0x803da8
  802ac4:	68 fc 00 00 00       	push   $0xfc
  802ac9:	68 37 3d 80 00       	push   $0x803d37
  802ace:	e8 d4 d9 ff ff       	call   8004a7 <_panic>
  802ad3:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802ad6:	8b 00                	mov    (%eax),%eax
  802ad8:	85 c0                	test   %eax,%eax
  802ada:	74 10                	je     802aec <alloc_block_NF+0xff>
  802adc:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802adf:	8b 00                	mov    (%eax),%eax
  802ae1:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802ae4:	8b 52 04             	mov    0x4(%edx),%edx
  802ae7:	89 50 04             	mov    %edx,0x4(%eax)
  802aea:	eb 0b                	jmp    802af7 <alloc_block_NF+0x10a>
  802aec:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802aef:	8b 40 04             	mov    0x4(%eax),%eax
  802af2:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802af7:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802afa:	8b 40 04             	mov    0x4(%eax),%eax
  802afd:	85 c0                	test   %eax,%eax
  802aff:	74 0f                	je     802b10 <alloc_block_NF+0x123>
  802b01:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802b04:	8b 40 04             	mov    0x4(%eax),%eax
  802b07:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802b0a:	8b 12                	mov    (%edx),%edx
  802b0c:	89 10                	mov    %edx,(%eax)
  802b0e:	eb 0a                	jmp    802b1a <alloc_block_NF+0x12d>
  802b10:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802b13:	8b 00                	mov    (%eax),%eax
  802b15:	a3 48 41 80 00       	mov    %eax,0x804148
  802b1a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802b1d:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802b23:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802b26:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802b2d:	a1 54 41 80 00       	mov    0x804154,%eax
  802b32:	48                   	dec    %eax
  802b33:	a3 54 41 80 00       	mov    %eax,0x804154
			newblk->size = versize;
  802b38:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802b3b:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802b3e:	89 50 0c             	mov    %edx,0xc(%eax)
			blk->size = blk->size-versize;
  802b41:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b44:	8b 40 0c             	mov    0xc(%eax),%eax
  802b47:	2b 45 f0             	sub    -0x10(%ebp),%eax
  802b4a:	89 c2                	mov    %eax,%edx
  802b4c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b4f:	89 50 0c             	mov    %edx,0xc(%eax)
			uint32 newveradd = blk->sva;
  802b52:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b55:	8b 40 08             	mov    0x8(%eax),%eax
  802b58:	89 45 e8             	mov    %eax,-0x18(%ebp)
			blk->sva+=newblk->size;
  802b5b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b5e:	8b 50 08             	mov    0x8(%eax),%edx
  802b61:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802b64:	8b 40 0c             	mov    0xc(%eax),%eax
  802b67:	01 c2                	add    %eax,%edx
  802b69:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b6c:	89 50 08             	mov    %edx,0x8(%eax)
			newblk->sva = newveradd;
  802b6f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802b72:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802b75:	89 50 08             	mov    %edx,0x8(%eax)
			return newblk;
  802b78:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802b7b:	eb 3b                	jmp    802bb8 <alloc_block_NF+0x1cb>
	//panic("alloc_block_NF() is not implemented yet...!!");
	uint32 versize = size;
	struct MemBlock* blk;
	struct MemBlock* newblk = LIST_FIRST(&AvailableMemBlocksList);

	LIST_FOREACH(blk,&FreeMemBlocksList)
  802b7d:	a1 40 41 80 00       	mov    0x804140,%eax
  802b82:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802b85:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802b89:	74 07                	je     802b92 <alloc_block_NF+0x1a5>
  802b8b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b8e:	8b 00                	mov    (%eax),%eax
  802b90:	eb 05                	jmp    802b97 <alloc_block_NF+0x1aa>
  802b92:	b8 00 00 00 00       	mov    $0x0,%eax
  802b97:	a3 40 41 80 00       	mov    %eax,0x804140
  802b9c:	a1 40 41 80 00       	mov    0x804140,%eax
  802ba1:	85 c0                	test   %eax,%eax
  802ba3:	0f 85 65 fe ff ff    	jne    802a0e <alloc_block_NF+0x21>
  802ba9:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802bad:	0f 85 5b fe ff ff    	jne    802a0e <alloc_block_NF+0x21>
			blk->sva+=newblk->size;
			newblk->sva = newveradd;
			return newblk;
		}
	}
	return NULL;
  802bb3:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802bb8:	c9                   	leave  
  802bb9:	c3                   	ret    

00802bba <addToAvailMemBlocksList>:

//===================================================
// [8] INSERT BLOCK (SORTED WITH MERGE) IN FREE LIST:
//===================================================
void addToAvailMemBlocksList(struct MemBlock *blockToInsert)
{
  802bba:	55                   	push   %ebp
  802bbb:	89 e5                	mov    %esp,%ebp
  802bbd:	83 ec 08             	sub    $0x8,%esp
	blockToInsert->sva = 0;
  802bc0:	8b 45 08             	mov    0x8(%ebp),%eax
  802bc3:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
	blockToInsert->size = 0;
  802bca:	8b 45 08             	mov    0x8(%ebp),%eax
  802bcd:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
	//add to avail
	LIST_INSERT_TAIL(&AvailableMemBlocksList, blockToInsert);
  802bd4:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802bd8:	75 17                	jne    802bf1 <addToAvailMemBlocksList+0x37>
  802bda:	83 ec 04             	sub    $0x4,%esp
  802bdd:	68 50 3d 80 00       	push   $0x803d50
  802be2:	68 10 01 00 00       	push   $0x110
  802be7:	68 37 3d 80 00       	push   $0x803d37
  802bec:	e8 b6 d8 ff ff       	call   8004a7 <_panic>
  802bf1:	8b 15 4c 41 80 00    	mov    0x80414c,%edx
  802bf7:	8b 45 08             	mov    0x8(%ebp),%eax
  802bfa:	89 50 04             	mov    %edx,0x4(%eax)
  802bfd:	8b 45 08             	mov    0x8(%ebp),%eax
  802c00:	8b 40 04             	mov    0x4(%eax),%eax
  802c03:	85 c0                	test   %eax,%eax
  802c05:	74 0c                	je     802c13 <addToAvailMemBlocksList+0x59>
  802c07:	a1 4c 41 80 00       	mov    0x80414c,%eax
  802c0c:	8b 55 08             	mov    0x8(%ebp),%edx
  802c0f:	89 10                	mov    %edx,(%eax)
  802c11:	eb 08                	jmp    802c1b <addToAvailMemBlocksList+0x61>
  802c13:	8b 45 08             	mov    0x8(%ebp),%eax
  802c16:	a3 48 41 80 00       	mov    %eax,0x804148
  802c1b:	8b 45 08             	mov    0x8(%ebp),%eax
  802c1e:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802c23:	8b 45 08             	mov    0x8(%ebp),%eax
  802c26:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802c2c:	a1 54 41 80 00       	mov    0x804154,%eax
  802c31:	40                   	inc    %eax
  802c32:	a3 54 41 80 00       	mov    %eax,0x804154
}
  802c37:	90                   	nop
  802c38:	c9                   	leave  
  802c39:	c3                   	ret    

00802c3a <insert_sorted_with_merge_freeList>:
void insert_sorted_with_merge_freeList(struct MemBlock *blockToInsert)
{
  802c3a:	55                   	push   %ebp
  802c3b:	89 e5                	mov    %esp,%ebp
  802c3d:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] insert_sorted_with_merge_freeList
	// Write your code here, remove the panic and write your code

	struct MemBlock* last = LIST_LAST(&FreeMemBlocksList);
  802c40:	a1 3c 41 80 00       	mov    0x80413c,%eax
  802c45:	89 45 f0             	mov    %eax,-0x10(%ebp)
	//check if list empty
	if (LIST_SIZE(&(FreeMemBlocksList)) == 0)
  802c48:	a1 44 41 80 00       	mov    0x804144,%eax
  802c4d:	85 c0                	test   %eax,%eax
  802c4f:	75 68                	jne    802cb9 <insert_sorted_with_merge_freeList+0x7f>
		LIST_INSERT_HEAD(&FreeMemBlocksList, blockToInsert);
  802c51:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802c55:	75 17                	jne    802c6e <insert_sorted_with_merge_freeList+0x34>
  802c57:	83 ec 04             	sub    $0x4,%esp
  802c5a:	68 14 3d 80 00       	push   $0x803d14
  802c5f:	68 1a 01 00 00       	push   $0x11a
  802c64:	68 37 3d 80 00       	push   $0x803d37
  802c69:	e8 39 d8 ff ff       	call   8004a7 <_panic>
  802c6e:	8b 15 38 41 80 00    	mov    0x804138,%edx
  802c74:	8b 45 08             	mov    0x8(%ebp),%eax
  802c77:	89 10                	mov    %edx,(%eax)
  802c79:	8b 45 08             	mov    0x8(%ebp),%eax
  802c7c:	8b 00                	mov    (%eax),%eax
  802c7e:	85 c0                	test   %eax,%eax
  802c80:	74 0d                	je     802c8f <insert_sorted_with_merge_freeList+0x55>
  802c82:	a1 38 41 80 00       	mov    0x804138,%eax
  802c87:	8b 55 08             	mov    0x8(%ebp),%edx
  802c8a:	89 50 04             	mov    %edx,0x4(%eax)
  802c8d:	eb 08                	jmp    802c97 <insert_sorted_with_merge_freeList+0x5d>
  802c8f:	8b 45 08             	mov    0x8(%ebp),%eax
  802c92:	a3 3c 41 80 00       	mov    %eax,0x80413c
  802c97:	8b 45 08             	mov    0x8(%ebp),%eax
  802c9a:	a3 38 41 80 00       	mov    %eax,0x804138
  802c9f:	8b 45 08             	mov    0x8(%ebp),%eax
  802ca2:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802ca9:	a1 44 41 80 00       	mov    0x804144,%eax
  802cae:	40                   	inc    %eax
  802caf:	a3 44 41 80 00       	mov    %eax,0x804144
		}
	}

	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  802cb4:	e9 c5 03 00 00       	jmp    80307e <insert_sorted_with_merge_freeList+0x444>
	struct MemBlock* last = LIST_LAST(&FreeMemBlocksList);
	//check if list empty
	if (LIST_SIZE(&(FreeMemBlocksList)) == 0)
		LIST_INSERT_HEAD(&FreeMemBlocksList, blockToInsert);
	//check if it's position is at last
	else if (last->sva < blockToInsert->sva) {
  802cb9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802cbc:	8b 50 08             	mov    0x8(%eax),%edx
  802cbf:	8b 45 08             	mov    0x8(%ebp),%eax
  802cc2:	8b 40 08             	mov    0x8(%eax),%eax
  802cc5:	39 c2                	cmp    %eax,%edx
  802cc7:	0f 83 b2 00 00 00    	jae    802d7f <insert_sorted_with_merge_freeList+0x145>

		//if i have to merge
		if (last->sva + last->size == blockToInsert->sva) {
  802ccd:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802cd0:	8b 50 08             	mov    0x8(%eax),%edx
  802cd3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802cd6:	8b 40 0c             	mov    0xc(%eax),%eax
  802cd9:	01 c2                	add    %eax,%edx
  802cdb:	8b 45 08             	mov    0x8(%ebp),%eax
  802cde:	8b 40 08             	mov    0x8(%eax),%eax
  802ce1:	39 c2                	cmp    %eax,%edx
  802ce3:	75 27                	jne    802d0c <insert_sorted_with_merge_freeList+0xd2>
			last->size = last->size + blockToInsert->size;
  802ce5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802ce8:	8b 50 0c             	mov    0xc(%eax),%edx
  802ceb:	8b 45 08             	mov    0x8(%ebp),%eax
  802cee:	8b 40 0c             	mov    0xc(%eax),%eax
  802cf1:	01 c2                	add    %eax,%edx
  802cf3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802cf6:	89 50 0c             	mov    %edx,0xc(%eax)
			addToAvailMemBlocksList(blockToInsert);
  802cf9:	83 ec 0c             	sub    $0xc,%esp
  802cfc:	ff 75 08             	pushl  0x8(%ebp)
  802cff:	e8 b6 fe ff ff       	call   802bba <addToAvailMemBlocksList>
  802d04:	83 c4 10             	add    $0x10,%esp
		}
	}

	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  802d07:	e9 72 03 00 00       	jmp    80307e <insert_sorted_with_merge_freeList+0x444>
		if (last->sva + last->size == blockToInsert->sva) {
			last->size = last->size + blockToInsert->size;
			addToAvailMemBlocksList(blockToInsert);

		} else {
			LIST_INSERT_AFTER(&FreeMemBlocksList, last, blockToInsert);
  802d0c:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802d10:	74 06                	je     802d18 <insert_sorted_with_merge_freeList+0xde>
  802d12:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802d16:	75 17                	jne    802d2f <insert_sorted_with_merge_freeList+0xf5>
  802d18:	83 ec 04             	sub    $0x4,%esp
  802d1b:	68 74 3d 80 00       	push   $0x803d74
  802d20:	68 24 01 00 00       	push   $0x124
  802d25:	68 37 3d 80 00       	push   $0x803d37
  802d2a:	e8 78 d7 ff ff       	call   8004a7 <_panic>
  802d2f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d32:	8b 10                	mov    (%eax),%edx
  802d34:	8b 45 08             	mov    0x8(%ebp),%eax
  802d37:	89 10                	mov    %edx,(%eax)
  802d39:	8b 45 08             	mov    0x8(%ebp),%eax
  802d3c:	8b 00                	mov    (%eax),%eax
  802d3e:	85 c0                	test   %eax,%eax
  802d40:	74 0b                	je     802d4d <insert_sorted_with_merge_freeList+0x113>
  802d42:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d45:	8b 00                	mov    (%eax),%eax
  802d47:	8b 55 08             	mov    0x8(%ebp),%edx
  802d4a:	89 50 04             	mov    %edx,0x4(%eax)
  802d4d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d50:	8b 55 08             	mov    0x8(%ebp),%edx
  802d53:	89 10                	mov    %edx,(%eax)
  802d55:	8b 45 08             	mov    0x8(%ebp),%eax
  802d58:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802d5b:	89 50 04             	mov    %edx,0x4(%eax)
  802d5e:	8b 45 08             	mov    0x8(%ebp),%eax
  802d61:	8b 00                	mov    (%eax),%eax
  802d63:	85 c0                	test   %eax,%eax
  802d65:	75 08                	jne    802d6f <insert_sorted_with_merge_freeList+0x135>
  802d67:	8b 45 08             	mov    0x8(%ebp),%eax
  802d6a:	a3 3c 41 80 00       	mov    %eax,0x80413c
  802d6f:	a1 44 41 80 00       	mov    0x804144,%eax
  802d74:	40                   	inc    %eax
  802d75:	a3 44 41 80 00       	mov    %eax,0x804144
		}
	}

	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  802d7a:	e9 ff 02 00 00       	jmp    80307e <insert_sorted_with_merge_freeList+0x444>
		} else {
			LIST_INSERT_AFTER(&FreeMemBlocksList, last, blockToInsert);
		}
	} else {
		struct MemBlock *iterator;
		LIST_FOREACH(iterator, &(FreeMemBlocksList))
  802d7f:	a1 38 41 80 00       	mov    0x804138,%eax
  802d84:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802d87:	e9 c2 02 00 00       	jmp    80304e <insert_sorted_with_merge_freeList+0x414>
		{

			if (iterator->sva > blockToInsert->sva) {
  802d8c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d8f:	8b 50 08             	mov    0x8(%eax),%edx
  802d92:	8b 45 08             	mov    0x8(%ebp),%eax
  802d95:	8b 40 08             	mov    0x8(%eax),%eax
  802d98:	39 c2                	cmp    %eax,%edx
  802d9a:	0f 86 a6 02 00 00    	jbe    803046 <insert_sorted_with_merge_freeList+0x40c>

				struct MemBlock* prev = LIST_PREV(iterator);
  802da0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802da3:	8b 40 04             	mov    0x4(%eax),%eax
  802da6:	89 45 ec             	mov    %eax,-0x14(%ebp)
				if (prev == NULL) {
  802da9:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802dad:	0f 85 ba 00 00 00    	jne    802e6d <insert_sorted_with_merge_freeList+0x233>
					//check merge
					if (blockToInsert->size + blockToInsert->sva
  802db3:	8b 45 08             	mov    0x8(%ebp),%eax
  802db6:	8b 50 0c             	mov    0xc(%eax),%edx
  802db9:	8b 45 08             	mov    0x8(%ebp),%eax
  802dbc:	8b 40 08             	mov    0x8(%eax),%eax
  802dbf:	01 c2                	add    %eax,%edx
							== iterator->sva) {
  802dc1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802dc4:	8b 40 08             	mov    0x8(%eax),%eax
			if (iterator->sva > blockToInsert->sva) {

				struct MemBlock* prev = LIST_PREV(iterator);
				if (prev == NULL) {
					//check merge
					if (blockToInsert->size + blockToInsert->sva
  802dc7:	39 c2                	cmp    %eax,%edx
  802dc9:	75 33                	jne    802dfe <insert_sorted_with_merge_freeList+0x1c4>
							== iterator->sva) {
						iterator->sva = blockToInsert->sva;
  802dcb:	8b 45 08             	mov    0x8(%ebp),%eax
  802dce:	8b 50 08             	mov    0x8(%eax),%edx
  802dd1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802dd4:	89 50 08             	mov    %edx,0x8(%eax)
						iterator->size = iterator->size + blockToInsert->size;
  802dd7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802dda:	8b 50 0c             	mov    0xc(%eax),%edx
  802ddd:	8b 45 08             	mov    0x8(%ebp),%eax
  802de0:	8b 40 0c             	mov    0xc(%eax),%eax
  802de3:	01 c2                	add    %eax,%edx
  802de5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802de8:	89 50 0c             	mov    %edx,0xc(%eax)
						addToAvailMemBlocksList(blockToInsert);
  802deb:	83 ec 0c             	sub    $0xc,%esp
  802dee:	ff 75 08             	pushl  0x8(%ebp)
  802df1:	e8 c4 fd ff ff       	call   802bba <addToAvailMemBlocksList>
  802df6:	83 c4 10             	add    $0x10,%esp

					else {
						LIST_INSERT_BEFORE(&FreeMemBlocksList, iterator,
								blockToInsert);
					}
					break;
  802df9:	e9 80 02 00 00       	jmp    80307e <insert_sorted_with_merge_freeList+0x444>
						addToAvailMemBlocksList(blockToInsert);

					}

					else {
						LIST_INSERT_BEFORE(&FreeMemBlocksList, iterator,
  802dfe:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802e02:	74 06                	je     802e0a <insert_sorted_with_merge_freeList+0x1d0>
  802e04:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802e08:	75 17                	jne    802e21 <insert_sorted_with_merge_freeList+0x1e7>
  802e0a:	83 ec 04             	sub    $0x4,%esp
  802e0d:	68 c8 3d 80 00       	push   $0x803dc8
  802e12:	68 3a 01 00 00       	push   $0x13a
  802e17:	68 37 3d 80 00       	push   $0x803d37
  802e1c:	e8 86 d6 ff ff       	call   8004a7 <_panic>
  802e21:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e24:	8b 50 04             	mov    0x4(%eax),%edx
  802e27:	8b 45 08             	mov    0x8(%ebp),%eax
  802e2a:	89 50 04             	mov    %edx,0x4(%eax)
  802e2d:	8b 45 08             	mov    0x8(%ebp),%eax
  802e30:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802e33:	89 10                	mov    %edx,(%eax)
  802e35:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e38:	8b 40 04             	mov    0x4(%eax),%eax
  802e3b:	85 c0                	test   %eax,%eax
  802e3d:	74 0d                	je     802e4c <insert_sorted_with_merge_freeList+0x212>
  802e3f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e42:	8b 40 04             	mov    0x4(%eax),%eax
  802e45:	8b 55 08             	mov    0x8(%ebp),%edx
  802e48:	89 10                	mov    %edx,(%eax)
  802e4a:	eb 08                	jmp    802e54 <insert_sorted_with_merge_freeList+0x21a>
  802e4c:	8b 45 08             	mov    0x8(%ebp),%eax
  802e4f:	a3 38 41 80 00       	mov    %eax,0x804138
  802e54:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e57:	8b 55 08             	mov    0x8(%ebp),%edx
  802e5a:	89 50 04             	mov    %edx,0x4(%eax)
  802e5d:	a1 44 41 80 00       	mov    0x804144,%eax
  802e62:	40                   	inc    %eax
  802e63:	a3 44 41 80 00       	mov    %eax,0x804144
								blockToInsert);
					}
					break;
  802e68:	e9 11 02 00 00       	jmp    80307e <insert_sorted_with_merge_freeList+0x444>
				} else {
					//prev and next merge
					if (prev->sva + prev->size + blockToInsert->size
  802e6d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802e70:	8b 50 08             	mov    0x8(%eax),%edx
  802e73:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802e76:	8b 40 0c             	mov    0xc(%eax),%eax
  802e79:	01 c2                	add    %eax,%edx
  802e7b:	8b 45 08             	mov    0x8(%ebp),%eax
  802e7e:	8b 40 0c             	mov    0xc(%eax),%eax
  802e81:	01 c2                	add    %eax,%edx
							== iterator->sva) {
  802e83:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e86:	8b 40 08             	mov    0x8(%eax),%eax
								blockToInsert);
					}
					break;
				} else {
					//prev and next merge
					if (prev->sva + prev->size + blockToInsert->size
  802e89:	39 c2                	cmp    %eax,%edx
  802e8b:	0f 85 bf 00 00 00    	jne    802f50 <insert_sorted_with_merge_freeList+0x316>
							== iterator->sva) {
						prev->size = prev->size + blockToInsert->size
  802e91:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802e94:	8b 50 0c             	mov    0xc(%eax),%edx
  802e97:	8b 45 08             	mov    0x8(%ebp),%eax
  802e9a:	8b 40 0c             	mov    0xc(%eax),%eax
  802e9d:	01 c2                	add    %eax,%edx
								+ iterator->size;
  802e9f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ea2:	8b 40 0c             	mov    0xc(%eax),%eax
  802ea5:	01 c2                	add    %eax,%edx
					break;
				} else {
					//prev and next merge
					if (prev->sva + prev->size + blockToInsert->size
							== iterator->sva) {
						prev->size = prev->size + blockToInsert->size
  802ea7:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802eaa:	89 50 0c             	mov    %edx,0xc(%eax)
								+ iterator->size;
						LIST_REMOVE(&FreeMemBlocksList, iterator);
  802ead:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802eb1:	75 17                	jne    802eca <insert_sorted_with_merge_freeList+0x290>
  802eb3:	83 ec 04             	sub    $0x4,%esp
  802eb6:	68 a8 3d 80 00       	push   $0x803da8
  802ebb:	68 43 01 00 00       	push   $0x143
  802ec0:	68 37 3d 80 00       	push   $0x803d37
  802ec5:	e8 dd d5 ff ff       	call   8004a7 <_panic>
  802eca:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ecd:	8b 00                	mov    (%eax),%eax
  802ecf:	85 c0                	test   %eax,%eax
  802ed1:	74 10                	je     802ee3 <insert_sorted_with_merge_freeList+0x2a9>
  802ed3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ed6:	8b 00                	mov    (%eax),%eax
  802ed8:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802edb:	8b 52 04             	mov    0x4(%edx),%edx
  802ede:	89 50 04             	mov    %edx,0x4(%eax)
  802ee1:	eb 0b                	jmp    802eee <insert_sorted_with_merge_freeList+0x2b4>
  802ee3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ee6:	8b 40 04             	mov    0x4(%eax),%eax
  802ee9:	a3 3c 41 80 00       	mov    %eax,0x80413c
  802eee:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ef1:	8b 40 04             	mov    0x4(%eax),%eax
  802ef4:	85 c0                	test   %eax,%eax
  802ef6:	74 0f                	je     802f07 <insert_sorted_with_merge_freeList+0x2cd>
  802ef8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802efb:	8b 40 04             	mov    0x4(%eax),%eax
  802efe:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802f01:	8b 12                	mov    (%edx),%edx
  802f03:	89 10                	mov    %edx,(%eax)
  802f05:	eb 0a                	jmp    802f11 <insert_sorted_with_merge_freeList+0x2d7>
  802f07:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f0a:	8b 00                	mov    (%eax),%eax
  802f0c:	a3 38 41 80 00       	mov    %eax,0x804138
  802f11:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f14:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802f1a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f1d:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802f24:	a1 44 41 80 00       	mov    0x804144,%eax
  802f29:	48                   	dec    %eax
  802f2a:	a3 44 41 80 00       	mov    %eax,0x804144
						addToAvailMemBlocksList(blockToInsert);
  802f2f:	83 ec 0c             	sub    $0xc,%esp
  802f32:	ff 75 08             	pushl  0x8(%ebp)
  802f35:	e8 80 fc ff ff       	call   802bba <addToAvailMemBlocksList>
  802f3a:	83 c4 10             	add    $0x10,%esp
						addToAvailMemBlocksList(iterator);
  802f3d:	83 ec 0c             	sub    $0xc,%esp
  802f40:	ff 75 f4             	pushl  -0xc(%ebp)
  802f43:	e8 72 fc ff ff       	call   802bba <addToAvailMemBlocksList>
  802f48:	83 c4 10             	add    $0x10,%esp
					//Insert
					else {
						LIST_INSERT_BEFORE(&FreeMemBlocksList, iterator,
								blockToInsert);
					}
					break;
  802f4b:	e9 2e 01 00 00       	jmp    80307e <insert_sorted_with_merge_freeList+0x444>
						LIST_REMOVE(&FreeMemBlocksList, iterator);
						addToAvailMemBlocksList(blockToInsert);
						addToAvailMemBlocksList(iterator);
					}
					//previous merge
					else if (prev->sva + prev->size == blockToInsert->sva) {
  802f50:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802f53:	8b 50 08             	mov    0x8(%eax),%edx
  802f56:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802f59:	8b 40 0c             	mov    0xc(%eax),%eax
  802f5c:	01 c2                	add    %eax,%edx
  802f5e:	8b 45 08             	mov    0x8(%ebp),%eax
  802f61:	8b 40 08             	mov    0x8(%eax),%eax
  802f64:	39 c2                	cmp    %eax,%edx
  802f66:	75 27                	jne    802f8f <insert_sorted_with_merge_freeList+0x355>
						prev->size = prev->size + blockToInsert->size;
  802f68:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802f6b:	8b 50 0c             	mov    0xc(%eax),%edx
  802f6e:	8b 45 08             	mov    0x8(%ebp),%eax
  802f71:	8b 40 0c             	mov    0xc(%eax),%eax
  802f74:	01 c2                	add    %eax,%edx
  802f76:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802f79:	89 50 0c             	mov    %edx,0xc(%eax)
						addToAvailMemBlocksList(blockToInsert);
  802f7c:	83 ec 0c             	sub    $0xc,%esp
  802f7f:	ff 75 08             	pushl  0x8(%ebp)
  802f82:	e8 33 fc ff ff       	call   802bba <addToAvailMemBlocksList>
  802f87:	83 c4 10             	add    $0x10,%esp
					//Insert
					else {
						LIST_INSERT_BEFORE(&FreeMemBlocksList, iterator,
								blockToInsert);
					}
					break;
  802f8a:	e9 ef 00 00 00       	jmp    80307e <insert_sorted_with_merge_freeList+0x444>
					else if (prev->sva + prev->size == blockToInsert->sva) {
						prev->size = prev->size + blockToInsert->size;
						addToAvailMemBlocksList(blockToInsert);
					}
					//next merge
					else if (blockToInsert->size + blockToInsert->sva
  802f8f:	8b 45 08             	mov    0x8(%ebp),%eax
  802f92:	8b 50 0c             	mov    0xc(%eax),%edx
  802f95:	8b 45 08             	mov    0x8(%ebp),%eax
  802f98:	8b 40 08             	mov    0x8(%eax),%eax
  802f9b:	01 c2                	add    %eax,%edx
							== iterator->sva) {
  802f9d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802fa0:	8b 40 08             	mov    0x8(%eax),%eax
					else if (prev->sva + prev->size == blockToInsert->sva) {
						prev->size = prev->size + blockToInsert->size;
						addToAvailMemBlocksList(blockToInsert);
					}
					//next merge
					else if (blockToInsert->size + blockToInsert->sva
  802fa3:	39 c2                	cmp    %eax,%edx
  802fa5:	75 33                	jne    802fda <insert_sorted_with_merge_freeList+0x3a0>
							== iterator->sva) {
						iterator->sva = blockToInsert->sva;
  802fa7:	8b 45 08             	mov    0x8(%ebp),%eax
  802faa:	8b 50 08             	mov    0x8(%eax),%edx
  802fad:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802fb0:	89 50 08             	mov    %edx,0x8(%eax)
						iterator->size = iterator->size + blockToInsert->size;
  802fb3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802fb6:	8b 50 0c             	mov    0xc(%eax),%edx
  802fb9:	8b 45 08             	mov    0x8(%ebp),%eax
  802fbc:	8b 40 0c             	mov    0xc(%eax),%eax
  802fbf:	01 c2                	add    %eax,%edx
  802fc1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802fc4:	89 50 0c             	mov    %edx,0xc(%eax)
						addToAvailMemBlocksList(blockToInsert);
  802fc7:	83 ec 0c             	sub    $0xc,%esp
  802fca:	ff 75 08             	pushl  0x8(%ebp)
  802fcd:	e8 e8 fb ff ff       	call   802bba <addToAvailMemBlocksList>
  802fd2:	83 c4 10             	add    $0x10,%esp
					//Insert
					else {
						LIST_INSERT_BEFORE(&FreeMemBlocksList, iterator,
								blockToInsert);
					}
					break;
  802fd5:	e9 a4 00 00 00       	jmp    80307e <insert_sorted_with_merge_freeList+0x444>
						iterator->size = iterator->size + blockToInsert->size;
						addToAvailMemBlocksList(blockToInsert);
					}
					//Insert
					else {
						LIST_INSERT_BEFORE(&FreeMemBlocksList, iterator,
  802fda:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802fde:	74 06                	je     802fe6 <insert_sorted_with_merge_freeList+0x3ac>
  802fe0:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802fe4:	75 17                	jne    802ffd <insert_sorted_with_merge_freeList+0x3c3>
  802fe6:	83 ec 04             	sub    $0x4,%esp
  802fe9:	68 c8 3d 80 00       	push   $0x803dc8
  802fee:	68 56 01 00 00       	push   $0x156
  802ff3:	68 37 3d 80 00       	push   $0x803d37
  802ff8:	e8 aa d4 ff ff       	call   8004a7 <_panic>
  802ffd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803000:	8b 50 04             	mov    0x4(%eax),%edx
  803003:	8b 45 08             	mov    0x8(%ebp),%eax
  803006:	89 50 04             	mov    %edx,0x4(%eax)
  803009:	8b 45 08             	mov    0x8(%ebp),%eax
  80300c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80300f:	89 10                	mov    %edx,(%eax)
  803011:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803014:	8b 40 04             	mov    0x4(%eax),%eax
  803017:	85 c0                	test   %eax,%eax
  803019:	74 0d                	je     803028 <insert_sorted_with_merge_freeList+0x3ee>
  80301b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80301e:	8b 40 04             	mov    0x4(%eax),%eax
  803021:	8b 55 08             	mov    0x8(%ebp),%edx
  803024:	89 10                	mov    %edx,(%eax)
  803026:	eb 08                	jmp    803030 <insert_sorted_with_merge_freeList+0x3f6>
  803028:	8b 45 08             	mov    0x8(%ebp),%eax
  80302b:	a3 38 41 80 00       	mov    %eax,0x804138
  803030:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803033:	8b 55 08             	mov    0x8(%ebp),%edx
  803036:	89 50 04             	mov    %edx,0x4(%eax)
  803039:	a1 44 41 80 00       	mov    0x804144,%eax
  80303e:	40                   	inc    %eax
  80303f:	a3 44 41 80 00       	mov    %eax,0x804144
								blockToInsert);
					}
					break;
  803044:	eb 38                	jmp    80307e <insert_sorted_with_merge_freeList+0x444>
		} else {
			LIST_INSERT_AFTER(&FreeMemBlocksList, last, blockToInsert);
		}
	} else {
		struct MemBlock *iterator;
		LIST_FOREACH(iterator, &(FreeMemBlocksList))
  803046:	a1 40 41 80 00       	mov    0x804140,%eax
  80304b:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80304e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803052:	74 07                	je     80305b <insert_sorted_with_merge_freeList+0x421>
  803054:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803057:	8b 00                	mov    (%eax),%eax
  803059:	eb 05                	jmp    803060 <insert_sorted_with_merge_freeList+0x426>
  80305b:	b8 00 00 00 00       	mov    $0x0,%eax
  803060:	a3 40 41 80 00       	mov    %eax,0x804140
  803065:	a1 40 41 80 00       	mov    0x804140,%eax
  80306a:	85 c0                	test   %eax,%eax
  80306c:	0f 85 1a fd ff ff    	jne    802d8c <insert_sorted_with_merge_freeList+0x152>
  803072:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803076:	0f 85 10 fd ff ff    	jne    802d8c <insert_sorted_with_merge_freeList+0x152>
		}
	}

	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  80307c:	eb 00                	jmp    80307e <insert_sorted_with_merge_freeList+0x444>
  80307e:	90                   	nop
  80307f:	c9                   	leave  
  803080:	c3                   	ret    

00803081 <env_sleep>:
#include <inc/lib.h>
#include <inc/timerreg.h>

void
env_sleep(uint32 approxMilliSeconds)
{
  803081:	55                   	push   %ebp
  803082:	89 e5                	mov    %esp,%ebp
  803084:	83 ec 28             	sub    $0x28,%esp
//	cprintf("%s go to sleep...\n", myEnv->prog_name);
	uint32 time_in_cycles=approxMilliSeconds*CYCLES_PER_MILLISEC;
  803087:	8b 55 08             	mov    0x8(%ebp),%edx
  80308a:	89 d0                	mov    %edx,%eax
  80308c:	c1 e0 02             	shl    $0x2,%eax
  80308f:	01 d0                	add    %edx,%eax
  803091:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  803098:	01 d0                	add    %edx,%eax
  80309a:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8030a1:	01 d0                	add    %edx,%eax
  8030a3:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8030aa:	01 d0                	add    %edx,%eax
  8030ac:	c1 e0 04             	shl    $0x4,%eax
  8030af:	89 45 f0             	mov    %eax,-0x10(%ebp)
	uint32 cycles_counter =0;
  8030b2:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	struct uint64 baseTime = sys_get_virtual_time() ;
  8030b9:	8d 45 e8             	lea    -0x18(%ebp),%eax
  8030bc:	83 ec 0c             	sub    $0xc,%esp
  8030bf:	50                   	push   %eax
  8030c0:	e8 60 ed ff ff       	call   801e25 <sys_get_virtual_time>
  8030c5:	83 c4 0c             	add    $0xc,%esp
	while(cycles_counter<time_in_cycles)
  8030c8:	eb 41                	jmp    80310b <env_sleep+0x8a>
	{
		struct uint64 currentTime = sys_get_virtual_time() ;
  8030ca:	8d 45 e0             	lea    -0x20(%ebp),%eax
  8030cd:	83 ec 0c             	sub    $0xc,%esp
  8030d0:	50                   	push   %eax
  8030d1:	e8 4f ed ff ff       	call   801e25 <sys_get_virtual_time>
  8030d6:	83 c4 0c             	add    $0xc,%esp

		// update the cycles_count
		#define M32 0xffffffff
		// subtract basetime from current time
		struct uint64 res;
		res.low = (currentTime.low - baseTime.low) & M32;
  8030d9:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8030dc:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8030df:	29 c2                	sub    %eax,%edx
  8030e1:	89 d0                	mov    %edx,%eax
  8030e3:	89 45 d8             	mov    %eax,-0x28(%ebp)
		res.hi = (currentTime.hi - baseTime.hi - (res.low > currentTime.low)) & M32;
  8030e6:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8030e9:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8030ec:	89 d1                	mov    %edx,%ecx
  8030ee:	29 c1                	sub    %eax,%ecx
  8030f0:	8b 55 d8             	mov    -0x28(%ebp),%edx
  8030f3:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8030f6:	39 c2                	cmp    %eax,%edx
  8030f8:	0f 97 c0             	seta   %al
  8030fb:	0f b6 c0             	movzbl %al,%eax
  8030fe:	29 c1                	sub    %eax,%ecx
  803100:	89 c8                	mov    %ecx,%eax
  803102:	89 45 dc             	mov    %eax,-0x24(%ebp)

		//update cycles_count with result
		cycles_counter = res.low;
  803105:	8b 45 d8             	mov    -0x28(%ebp),%eax
  803108:	89 45 f4             	mov    %eax,-0xc(%ebp)
//	cprintf("%s go to sleep...\n", myEnv->prog_name);
	uint32 time_in_cycles=approxMilliSeconds*CYCLES_PER_MILLISEC;
	uint32 cycles_counter =0;

	struct uint64 baseTime = sys_get_virtual_time() ;
	while(cycles_counter<time_in_cycles)
  80310b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80310e:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  803111:	72 b7                	jb     8030ca <env_sleep+0x49>
//				,cycles_counter
//				);
	}
	//cprintf("%s [%d] wake up now!\n", myEnv->prog_name, myEnv->env_id);

}
  803113:	90                   	nop
  803114:	c9                   	leave  
  803115:	c3                   	ret    

00803116 <busy_wait>:

//2017
uint32 busy_wait(uint32 loopMax)
{
  803116:	55                   	push   %ebp
  803117:	89 e5                	mov    %esp,%ebp
  803119:	83 ec 10             	sub    $0x10,%esp
	uint32 i = 0 ;
  80311c:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	while (i < loopMax) i++;
  803123:	eb 03                	jmp    803128 <busy_wait+0x12>
  803125:	ff 45 fc             	incl   -0x4(%ebp)
  803128:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80312b:	3b 45 08             	cmp    0x8(%ebp),%eax
  80312e:	72 f5                	jb     803125 <busy_wait+0xf>
	return i;
  803130:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  803133:	c9                   	leave  
  803134:	c3                   	ret    
  803135:	66 90                	xchg   %ax,%ax
  803137:	90                   	nop

00803138 <__udivdi3>:
  803138:	55                   	push   %ebp
  803139:	57                   	push   %edi
  80313a:	56                   	push   %esi
  80313b:	53                   	push   %ebx
  80313c:	83 ec 1c             	sub    $0x1c,%esp
  80313f:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  803143:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  803147:	8b 7c 24 38          	mov    0x38(%esp),%edi
  80314b:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  80314f:	89 ca                	mov    %ecx,%edx
  803151:	89 f8                	mov    %edi,%eax
  803153:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  803157:	85 f6                	test   %esi,%esi
  803159:	75 2d                	jne    803188 <__udivdi3+0x50>
  80315b:	39 cf                	cmp    %ecx,%edi
  80315d:	77 65                	ja     8031c4 <__udivdi3+0x8c>
  80315f:	89 fd                	mov    %edi,%ebp
  803161:	85 ff                	test   %edi,%edi
  803163:	75 0b                	jne    803170 <__udivdi3+0x38>
  803165:	b8 01 00 00 00       	mov    $0x1,%eax
  80316a:	31 d2                	xor    %edx,%edx
  80316c:	f7 f7                	div    %edi
  80316e:	89 c5                	mov    %eax,%ebp
  803170:	31 d2                	xor    %edx,%edx
  803172:	89 c8                	mov    %ecx,%eax
  803174:	f7 f5                	div    %ebp
  803176:	89 c1                	mov    %eax,%ecx
  803178:	89 d8                	mov    %ebx,%eax
  80317a:	f7 f5                	div    %ebp
  80317c:	89 cf                	mov    %ecx,%edi
  80317e:	89 fa                	mov    %edi,%edx
  803180:	83 c4 1c             	add    $0x1c,%esp
  803183:	5b                   	pop    %ebx
  803184:	5e                   	pop    %esi
  803185:	5f                   	pop    %edi
  803186:	5d                   	pop    %ebp
  803187:	c3                   	ret    
  803188:	39 ce                	cmp    %ecx,%esi
  80318a:	77 28                	ja     8031b4 <__udivdi3+0x7c>
  80318c:	0f bd fe             	bsr    %esi,%edi
  80318f:	83 f7 1f             	xor    $0x1f,%edi
  803192:	75 40                	jne    8031d4 <__udivdi3+0x9c>
  803194:	39 ce                	cmp    %ecx,%esi
  803196:	72 0a                	jb     8031a2 <__udivdi3+0x6a>
  803198:	3b 44 24 08          	cmp    0x8(%esp),%eax
  80319c:	0f 87 9e 00 00 00    	ja     803240 <__udivdi3+0x108>
  8031a2:	b8 01 00 00 00       	mov    $0x1,%eax
  8031a7:	89 fa                	mov    %edi,%edx
  8031a9:	83 c4 1c             	add    $0x1c,%esp
  8031ac:	5b                   	pop    %ebx
  8031ad:	5e                   	pop    %esi
  8031ae:	5f                   	pop    %edi
  8031af:	5d                   	pop    %ebp
  8031b0:	c3                   	ret    
  8031b1:	8d 76 00             	lea    0x0(%esi),%esi
  8031b4:	31 ff                	xor    %edi,%edi
  8031b6:	31 c0                	xor    %eax,%eax
  8031b8:	89 fa                	mov    %edi,%edx
  8031ba:	83 c4 1c             	add    $0x1c,%esp
  8031bd:	5b                   	pop    %ebx
  8031be:	5e                   	pop    %esi
  8031bf:	5f                   	pop    %edi
  8031c0:	5d                   	pop    %ebp
  8031c1:	c3                   	ret    
  8031c2:	66 90                	xchg   %ax,%ax
  8031c4:	89 d8                	mov    %ebx,%eax
  8031c6:	f7 f7                	div    %edi
  8031c8:	31 ff                	xor    %edi,%edi
  8031ca:	89 fa                	mov    %edi,%edx
  8031cc:	83 c4 1c             	add    $0x1c,%esp
  8031cf:	5b                   	pop    %ebx
  8031d0:	5e                   	pop    %esi
  8031d1:	5f                   	pop    %edi
  8031d2:	5d                   	pop    %ebp
  8031d3:	c3                   	ret    
  8031d4:	bd 20 00 00 00       	mov    $0x20,%ebp
  8031d9:	89 eb                	mov    %ebp,%ebx
  8031db:	29 fb                	sub    %edi,%ebx
  8031dd:	89 f9                	mov    %edi,%ecx
  8031df:	d3 e6                	shl    %cl,%esi
  8031e1:	89 c5                	mov    %eax,%ebp
  8031e3:	88 d9                	mov    %bl,%cl
  8031e5:	d3 ed                	shr    %cl,%ebp
  8031e7:	89 e9                	mov    %ebp,%ecx
  8031e9:	09 f1                	or     %esi,%ecx
  8031eb:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  8031ef:	89 f9                	mov    %edi,%ecx
  8031f1:	d3 e0                	shl    %cl,%eax
  8031f3:	89 c5                	mov    %eax,%ebp
  8031f5:	89 d6                	mov    %edx,%esi
  8031f7:	88 d9                	mov    %bl,%cl
  8031f9:	d3 ee                	shr    %cl,%esi
  8031fb:	89 f9                	mov    %edi,%ecx
  8031fd:	d3 e2                	shl    %cl,%edx
  8031ff:	8b 44 24 08          	mov    0x8(%esp),%eax
  803203:	88 d9                	mov    %bl,%cl
  803205:	d3 e8                	shr    %cl,%eax
  803207:	09 c2                	or     %eax,%edx
  803209:	89 d0                	mov    %edx,%eax
  80320b:	89 f2                	mov    %esi,%edx
  80320d:	f7 74 24 0c          	divl   0xc(%esp)
  803211:	89 d6                	mov    %edx,%esi
  803213:	89 c3                	mov    %eax,%ebx
  803215:	f7 e5                	mul    %ebp
  803217:	39 d6                	cmp    %edx,%esi
  803219:	72 19                	jb     803234 <__udivdi3+0xfc>
  80321b:	74 0b                	je     803228 <__udivdi3+0xf0>
  80321d:	89 d8                	mov    %ebx,%eax
  80321f:	31 ff                	xor    %edi,%edi
  803221:	e9 58 ff ff ff       	jmp    80317e <__udivdi3+0x46>
  803226:	66 90                	xchg   %ax,%ax
  803228:	8b 54 24 08          	mov    0x8(%esp),%edx
  80322c:	89 f9                	mov    %edi,%ecx
  80322e:	d3 e2                	shl    %cl,%edx
  803230:	39 c2                	cmp    %eax,%edx
  803232:	73 e9                	jae    80321d <__udivdi3+0xe5>
  803234:	8d 43 ff             	lea    -0x1(%ebx),%eax
  803237:	31 ff                	xor    %edi,%edi
  803239:	e9 40 ff ff ff       	jmp    80317e <__udivdi3+0x46>
  80323e:	66 90                	xchg   %ax,%ax
  803240:	31 c0                	xor    %eax,%eax
  803242:	e9 37 ff ff ff       	jmp    80317e <__udivdi3+0x46>
  803247:	90                   	nop

00803248 <__umoddi3>:
  803248:	55                   	push   %ebp
  803249:	57                   	push   %edi
  80324a:	56                   	push   %esi
  80324b:	53                   	push   %ebx
  80324c:	83 ec 1c             	sub    $0x1c,%esp
  80324f:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  803253:	8b 74 24 34          	mov    0x34(%esp),%esi
  803257:	8b 7c 24 38          	mov    0x38(%esp),%edi
  80325b:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  80325f:	89 44 24 0c          	mov    %eax,0xc(%esp)
  803263:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  803267:	89 f3                	mov    %esi,%ebx
  803269:	89 fa                	mov    %edi,%edx
  80326b:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  80326f:	89 34 24             	mov    %esi,(%esp)
  803272:	85 c0                	test   %eax,%eax
  803274:	75 1a                	jne    803290 <__umoddi3+0x48>
  803276:	39 f7                	cmp    %esi,%edi
  803278:	0f 86 a2 00 00 00    	jbe    803320 <__umoddi3+0xd8>
  80327e:	89 c8                	mov    %ecx,%eax
  803280:	89 f2                	mov    %esi,%edx
  803282:	f7 f7                	div    %edi
  803284:	89 d0                	mov    %edx,%eax
  803286:	31 d2                	xor    %edx,%edx
  803288:	83 c4 1c             	add    $0x1c,%esp
  80328b:	5b                   	pop    %ebx
  80328c:	5e                   	pop    %esi
  80328d:	5f                   	pop    %edi
  80328e:	5d                   	pop    %ebp
  80328f:	c3                   	ret    
  803290:	39 f0                	cmp    %esi,%eax
  803292:	0f 87 ac 00 00 00    	ja     803344 <__umoddi3+0xfc>
  803298:	0f bd e8             	bsr    %eax,%ebp
  80329b:	83 f5 1f             	xor    $0x1f,%ebp
  80329e:	0f 84 ac 00 00 00    	je     803350 <__umoddi3+0x108>
  8032a4:	bf 20 00 00 00       	mov    $0x20,%edi
  8032a9:	29 ef                	sub    %ebp,%edi
  8032ab:	89 fe                	mov    %edi,%esi
  8032ad:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  8032b1:	89 e9                	mov    %ebp,%ecx
  8032b3:	d3 e0                	shl    %cl,%eax
  8032b5:	89 d7                	mov    %edx,%edi
  8032b7:	89 f1                	mov    %esi,%ecx
  8032b9:	d3 ef                	shr    %cl,%edi
  8032bb:	09 c7                	or     %eax,%edi
  8032bd:	89 e9                	mov    %ebp,%ecx
  8032bf:	d3 e2                	shl    %cl,%edx
  8032c1:	89 14 24             	mov    %edx,(%esp)
  8032c4:	89 d8                	mov    %ebx,%eax
  8032c6:	d3 e0                	shl    %cl,%eax
  8032c8:	89 c2                	mov    %eax,%edx
  8032ca:	8b 44 24 08          	mov    0x8(%esp),%eax
  8032ce:	d3 e0                	shl    %cl,%eax
  8032d0:	89 44 24 04          	mov    %eax,0x4(%esp)
  8032d4:	8b 44 24 08          	mov    0x8(%esp),%eax
  8032d8:	89 f1                	mov    %esi,%ecx
  8032da:	d3 e8                	shr    %cl,%eax
  8032dc:	09 d0                	or     %edx,%eax
  8032de:	d3 eb                	shr    %cl,%ebx
  8032e0:	89 da                	mov    %ebx,%edx
  8032e2:	f7 f7                	div    %edi
  8032e4:	89 d3                	mov    %edx,%ebx
  8032e6:	f7 24 24             	mull   (%esp)
  8032e9:	89 c6                	mov    %eax,%esi
  8032eb:	89 d1                	mov    %edx,%ecx
  8032ed:	39 d3                	cmp    %edx,%ebx
  8032ef:	0f 82 87 00 00 00    	jb     80337c <__umoddi3+0x134>
  8032f5:	0f 84 91 00 00 00    	je     80338c <__umoddi3+0x144>
  8032fb:	8b 54 24 04          	mov    0x4(%esp),%edx
  8032ff:	29 f2                	sub    %esi,%edx
  803301:	19 cb                	sbb    %ecx,%ebx
  803303:	89 d8                	mov    %ebx,%eax
  803305:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  803309:	d3 e0                	shl    %cl,%eax
  80330b:	89 e9                	mov    %ebp,%ecx
  80330d:	d3 ea                	shr    %cl,%edx
  80330f:	09 d0                	or     %edx,%eax
  803311:	89 e9                	mov    %ebp,%ecx
  803313:	d3 eb                	shr    %cl,%ebx
  803315:	89 da                	mov    %ebx,%edx
  803317:	83 c4 1c             	add    $0x1c,%esp
  80331a:	5b                   	pop    %ebx
  80331b:	5e                   	pop    %esi
  80331c:	5f                   	pop    %edi
  80331d:	5d                   	pop    %ebp
  80331e:	c3                   	ret    
  80331f:	90                   	nop
  803320:	89 fd                	mov    %edi,%ebp
  803322:	85 ff                	test   %edi,%edi
  803324:	75 0b                	jne    803331 <__umoddi3+0xe9>
  803326:	b8 01 00 00 00       	mov    $0x1,%eax
  80332b:	31 d2                	xor    %edx,%edx
  80332d:	f7 f7                	div    %edi
  80332f:	89 c5                	mov    %eax,%ebp
  803331:	89 f0                	mov    %esi,%eax
  803333:	31 d2                	xor    %edx,%edx
  803335:	f7 f5                	div    %ebp
  803337:	89 c8                	mov    %ecx,%eax
  803339:	f7 f5                	div    %ebp
  80333b:	89 d0                	mov    %edx,%eax
  80333d:	e9 44 ff ff ff       	jmp    803286 <__umoddi3+0x3e>
  803342:	66 90                	xchg   %ax,%ax
  803344:	89 c8                	mov    %ecx,%eax
  803346:	89 f2                	mov    %esi,%edx
  803348:	83 c4 1c             	add    $0x1c,%esp
  80334b:	5b                   	pop    %ebx
  80334c:	5e                   	pop    %esi
  80334d:	5f                   	pop    %edi
  80334e:	5d                   	pop    %ebp
  80334f:	c3                   	ret    
  803350:	3b 04 24             	cmp    (%esp),%eax
  803353:	72 06                	jb     80335b <__umoddi3+0x113>
  803355:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  803359:	77 0f                	ja     80336a <__umoddi3+0x122>
  80335b:	89 f2                	mov    %esi,%edx
  80335d:	29 f9                	sub    %edi,%ecx
  80335f:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  803363:	89 14 24             	mov    %edx,(%esp)
  803366:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  80336a:	8b 44 24 04          	mov    0x4(%esp),%eax
  80336e:	8b 14 24             	mov    (%esp),%edx
  803371:	83 c4 1c             	add    $0x1c,%esp
  803374:	5b                   	pop    %ebx
  803375:	5e                   	pop    %esi
  803376:	5f                   	pop    %edi
  803377:	5d                   	pop    %ebp
  803378:	c3                   	ret    
  803379:	8d 76 00             	lea    0x0(%esi),%esi
  80337c:	2b 04 24             	sub    (%esp),%eax
  80337f:	19 fa                	sbb    %edi,%edx
  803381:	89 d1                	mov    %edx,%ecx
  803383:	89 c6                	mov    %eax,%esi
  803385:	e9 71 ff ff ff       	jmp    8032fb <__umoddi3+0xb3>
  80338a:	66 90                	xchg   %ax,%ax
  80338c:	39 44 24 04          	cmp    %eax,0x4(%esp)
  803390:	72 ea                	jb     80337c <__umoddi3+0x134>
  803392:	89 d9                	mov    %ebx,%ecx
  803394:	e9 62 ff ff ff       	jmp    8032fb <__umoddi3+0xb3>
