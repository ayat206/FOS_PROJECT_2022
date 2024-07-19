
obj/user/tst_sharing_3:     file format elf32-i386


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
  800031:	e8 8a 02 00 00       	call   8002c0 <libmain>
1:      jmp 1b
  800036:	eb fe                	jmp    800036 <args_exist+0x5>

00800038 <_main>:
// Test the SPECIAL CASES during the creation of shared variables (create_shared_memory)
#include <inc/lib.h>

void
_main(void)
{
  800038:	55                   	push   %ebp
  800039:	89 e5                	mov    %esp,%ebp
  80003b:	83 ec 48             	sub    $0x48,%esp
	//Initial test to ensure it works on "PLACEMENT" not "REPLACEMENT"
	{
		uint8 fullWS = 1;
  80003e:	c6 45 f7 01          	movb   $0x1,-0x9(%ebp)
		for (int i = 0; i < myEnv->page_WS_max_size; ++i)
  800042:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800049:	eb 29                	jmp    800074 <_main+0x3c>
		{
			if (myEnv->__uptr_pws[i].empty)
  80004b:	a1 20 40 80 00       	mov    0x804020,%eax
  800050:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  800056:	8b 55 f0             	mov    -0x10(%ebp),%edx
  800059:	89 d0                	mov    %edx,%eax
  80005b:	01 c0                	add    %eax,%eax
  80005d:	01 d0                	add    %edx,%eax
  80005f:	c1 e0 03             	shl    $0x3,%eax
  800062:	01 c8                	add    %ecx,%eax
  800064:	8a 40 04             	mov    0x4(%eax),%al
  800067:	84 c0                	test   %al,%al
  800069:	74 06                	je     800071 <_main+0x39>
			{
				fullWS = 0;
  80006b:	c6 45 f7 00          	movb   $0x0,-0x9(%ebp)
				break;
  80006f:	eb 12                	jmp    800083 <_main+0x4b>
_main(void)
{
	//Initial test to ensure it works on "PLACEMENT" not "REPLACEMENT"
	{
		uint8 fullWS = 1;
		for (int i = 0; i < myEnv->page_WS_max_size; ++i)
  800071:	ff 45 f0             	incl   -0x10(%ebp)
  800074:	a1 20 40 80 00       	mov    0x804020,%eax
  800079:	8b 50 74             	mov    0x74(%eax),%edx
  80007c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80007f:	39 c2                	cmp    %eax,%edx
  800081:	77 c8                	ja     80004b <_main+0x13>
			{
				fullWS = 0;
				break;
			}
		}
		if (fullWS) panic("Please increase the WS size");
  800083:	80 7d f7 00          	cmpb   $0x0,-0x9(%ebp)
  800087:	74 14                	je     80009d <_main+0x65>
  800089:	83 ec 04             	sub    $0x4,%esp
  80008c:	68 40 32 80 00       	push   $0x803240
  800091:	6a 12                	push   $0x12
  800093:	68 5c 32 80 00       	push   $0x80325c
  800098:	e8 5f 03 00 00       	call   8003fc <_panic>
	}
	/*Dummy malloc to enforce the UHEAP initializations*/
	malloc(0);
  80009d:	83 ec 0c             	sub    $0xc,%esp
  8000a0:	6a 00                	push   $0x0
  8000a2:	e8 9b 15 00 00       	call   801642 <malloc>
  8000a7:	83 c4 10             	add    $0x10,%esp
	/*=================================================*/

	cprintf("************************************************\n");
  8000aa:	83 ec 0c             	sub    $0xc,%esp
  8000ad:	68 74 32 80 00       	push   $0x803274
  8000b2:	e8 f9 05 00 00       	call   8006b0 <cprintf>
  8000b7:	83 c4 10             	add    $0x10,%esp
	cprintf("MAKE SURE to have a FRESH RUN for this test\n(i.e. don't run any program/test before it)\n");
  8000ba:	83 ec 0c             	sub    $0xc,%esp
  8000bd:	68 a8 32 80 00       	push   $0x8032a8
  8000c2:	e8 e9 05 00 00       	call   8006b0 <cprintf>
  8000c7:	83 c4 10             	add    $0x10,%esp
	cprintf("************************************************\n\n\n");
  8000ca:	83 ec 0c             	sub    $0xc,%esp
  8000cd:	68 04 33 80 00       	push   $0x803304
  8000d2:	e8 d9 05 00 00       	call   8006b0 <cprintf>
  8000d7:	83 c4 10             	add    $0x10,%esp

	uint32 *x, *y, *z ;
	cprintf("STEP A: checking creation of shared object that is already exists... \n\n");
  8000da:	83 ec 0c             	sub    $0xc,%esp
  8000dd:	68 38 33 80 00       	push   $0x803338
  8000e2:	e8 c9 05 00 00       	call   8006b0 <cprintf>
  8000e7:	83 c4 10             	add    $0x10,%esp
	{
		int ret ;
		//int ret = sys_createSharedObject("x", PAGE_SIZE, 1, (void*)&x);
		x = smalloc("x", PAGE_SIZE, 1);
  8000ea:	83 ec 04             	sub    $0x4,%esp
  8000ed:	6a 01                	push   $0x1
  8000ef:	68 00 10 00 00       	push   $0x1000
  8000f4:	68 80 33 80 00       	push   $0x803380
  8000f9:	e8 8c 16 00 00       	call   80178a <smalloc>
  8000fe:	83 c4 10             	add    $0x10,%esp
  800101:	89 45 e8             	mov    %eax,-0x18(%ebp)
		int freeFrames = sys_calculate_free_frames() ;
  800104:	e8 45 19 00 00       	call   801a4e <sys_calculate_free_frames>
  800109:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		x = smalloc("x", PAGE_SIZE, 1);
  80010c:	83 ec 04             	sub    $0x4,%esp
  80010f:	6a 01                	push   $0x1
  800111:	68 00 10 00 00       	push   $0x1000
  800116:	68 80 33 80 00       	push   $0x803380
  80011b:	e8 6a 16 00 00       	call   80178a <smalloc>
  800120:	83 c4 10             	add    $0x10,%esp
  800123:	89 45 e8             	mov    %eax,-0x18(%ebp)
		if (x != NULL) panic("Trying to create an already exists object and corresponding error is not returned!!");
  800126:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  80012a:	74 14                	je     800140 <_main+0x108>
  80012c:	83 ec 04             	sub    $0x4,%esp
  80012f:	68 84 33 80 00       	push   $0x803384
  800134:	6a 24                	push   $0x24
  800136:	68 5c 32 80 00       	push   $0x80325c
  80013b:	e8 bc 02 00 00       	call   8003fc <_panic>
		if ((freeFrames - sys_calculate_free_frames()) !=  0) panic("Wrong allocation: make sure that you don't allocate any memory if the shared object exists");
  800140:	e8 09 19 00 00       	call   801a4e <sys_calculate_free_frames>
  800145:	89 c2                	mov    %eax,%edx
  800147:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80014a:	39 c2                	cmp    %eax,%edx
  80014c:	74 14                	je     800162 <_main+0x12a>
  80014e:	83 ec 04             	sub    $0x4,%esp
  800151:	68 d8 33 80 00       	push   $0x8033d8
  800156:	6a 25                	push   $0x25
  800158:	68 5c 32 80 00       	push   $0x80325c
  80015d:	e8 9a 02 00 00       	call   8003fc <_panic>
	}

	cprintf("STEP B: checking the creation of shared object that exceeds the SHARED area limit... \n\n");
  800162:	83 ec 0c             	sub    $0xc,%esp
  800165:	68 34 34 80 00       	push   $0x803434
  80016a:	e8 41 05 00 00       	call   8006b0 <cprintf>
  80016f:	83 c4 10             	add    $0x10,%esp
	{
		int freeFrames = sys_calculate_free_frames() ;
  800172:	e8 d7 18 00 00       	call   801a4e <sys_calculate_free_frames>
  800177:	89 45 e0             	mov    %eax,-0x20(%ebp)
		uint32 size = USER_HEAP_MAX - USER_HEAP_START ;
  80017a:	c7 45 dc 00 00 00 20 	movl   $0x20000000,-0x24(%ebp)
		y = smalloc("y", size, 1);
  800181:	83 ec 04             	sub    $0x4,%esp
  800184:	6a 01                	push   $0x1
  800186:	ff 75 dc             	pushl  -0x24(%ebp)
  800189:	68 8c 34 80 00       	push   $0x80348c
  80018e:	e8 f7 15 00 00       	call   80178a <smalloc>
  800193:	83 c4 10             	add    $0x10,%esp
  800196:	89 45 d8             	mov    %eax,-0x28(%ebp)
		if (y != NULL) panic("Trying to create a shared object that exceed the SHARED area limit and the corresponding error is not returned!!");
  800199:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  80019d:	74 14                	je     8001b3 <_main+0x17b>
  80019f:	83 ec 04             	sub    $0x4,%esp
  8001a2:	68 90 34 80 00       	push   $0x803490
  8001a7:	6a 2d                	push   $0x2d
  8001a9:	68 5c 32 80 00       	push   $0x80325c
  8001ae:	e8 49 02 00 00       	call   8003fc <_panic>
		if ((freeFrames - sys_calculate_free_frames()) !=  0) panic("Wrong allocation: make sure that you don't allocate any memory if the shared object exceed the SHARED area limit");
  8001b3:	e8 96 18 00 00       	call   801a4e <sys_calculate_free_frames>
  8001b8:	89 c2                	mov    %eax,%edx
  8001ba:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8001bd:	39 c2                	cmp    %eax,%edx
  8001bf:	74 14                	je     8001d5 <_main+0x19d>
  8001c1:	83 ec 04             	sub    $0x4,%esp
  8001c4:	68 04 35 80 00       	push   $0x803504
  8001c9:	6a 2e                	push   $0x2e
  8001cb:	68 5c 32 80 00       	push   $0x80325c
  8001d0:	e8 27 02 00 00       	call   8003fc <_panic>
	}

	cprintf("STEP C: checking the creation of a number of shared objects that exceeds the MAX ALLOWED NUMBER of OBJECTS... \n\n");
  8001d5:	83 ec 0c             	sub    $0xc,%esp
  8001d8:	68 78 35 80 00       	push   $0x803578
  8001dd:	e8 ce 04 00 00       	call   8006b0 <cprintf>
  8001e2:	83 c4 10             	add    $0x10,%esp
	{
		uint32 maxShares = sys_getMaxShares();
  8001e5:	e8 bd 1a 00 00       	call   801ca7 <sys_getMaxShares>
  8001ea:	89 45 d4             	mov    %eax,-0x2c(%ebp)
		int i ;
		for (i = 0 ; i < maxShares - 1; i++)
  8001ed:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  8001f4:	eb 45                	jmp    80023b <_main+0x203>
		{
			char shareName[10] ;
			ltostr(i, shareName) ;
  8001f6:	83 ec 08             	sub    $0x8,%esp
  8001f9:	8d 45 c2             	lea    -0x3e(%ebp),%eax
  8001fc:	50                   	push   %eax
  8001fd:	ff 75 ec             	pushl  -0x14(%ebp)
  800200:	e8 d3 0f 00 00       	call   8011d8 <ltostr>
  800205:	83 c4 10             	add    $0x10,%esp
			z = smalloc(shareName, 1, 1);
  800208:	83 ec 04             	sub    $0x4,%esp
  80020b:	6a 01                	push   $0x1
  80020d:	6a 01                	push   $0x1
  80020f:	8d 45 c2             	lea    -0x3e(%ebp),%eax
  800212:	50                   	push   %eax
  800213:	e8 72 15 00 00       	call   80178a <smalloc>
  800218:	83 c4 10             	add    $0x10,%esp
  80021b:	89 45 d0             	mov    %eax,-0x30(%ebp)
			if (z == NULL) panic("WRONG... supposed no problem in creation here!!");
  80021e:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
  800222:	75 14                	jne    800238 <_main+0x200>
  800224:	83 ec 04             	sub    $0x4,%esp
  800227:	68 ec 35 80 00       	push   $0x8035ec
  80022c:	6a 3a                	push   $0x3a
  80022e:	68 5c 32 80 00       	push   $0x80325c
  800233:	e8 c4 01 00 00       	call   8003fc <_panic>

	cprintf("STEP C: checking the creation of a number of shared objects that exceeds the MAX ALLOWED NUMBER of OBJECTS... \n\n");
	{
		uint32 maxShares = sys_getMaxShares();
		int i ;
		for (i = 0 ; i < maxShares - 1; i++)
  800238:	ff 45 ec             	incl   -0x14(%ebp)
  80023b:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80023e:	8d 50 ff             	lea    -0x1(%eax),%edx
  800241:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800244:	39 c2                	cmp    %eax,%edx
  800246:	77 ae                	ja     8001f6 <_main+0x1be>
			char shareName[10] ;
			ltostr(i, shareName) ;
			z = smalloc(shareName, 1, 1);
			if (z == NULL) panic("WRONG... supposed no problem in creation here!!");
		}
		z = smalloc("outOfBounds", 1, 1);
  800248:	83 ec 04             	sub    $0x4,%esp
  80024b:	6a 01                	push   $0x1
  80024d:	6a 01                	push   $0x1
  80024f:	68 1c 36 80 00       	push   $0x80361c
  800254:	e8 31 15 00 00       	call   80178a <smalloc>
  800259:	83 c4 10             	add    $0x10,%esp
  80025c:	89 45 d0             	mov    %eax,-0x30(%ebp)
		uint32 maxShares_after = sys_getMaxShares();
  80025f:	e8 43 1a 00 00       	call   801ca7 <sys_getMaxShares>
  800264:	89 45 cc             	mov    %eax,-0x34(%ebp)
		//if krealloc is NOT invoked to double the size of max shares
		if ((maxShares_after == maxShares) && (z != NULL)) panic("Trying to create a shared object that exceed the number of ALLOWED OBJECTS and the corresponding error is not returned!!");
  800267:	8b 45 cc             	mov    -0x34(%ebp),%eax
  80026a:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  80026d:	75 1a                	jne    800289 <_main+0x251>
  80026f:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
  800273:	74 14                	je     800289 <_main+0x251>
  800275:	83 ec 04             	sub    $0x4,%esp
  800278:	68 28 36 80 00       	push   $0x803628
  80027d:	6a 3f                	push   $0x3f
  80027f:	68 5c 32 80 00       	push   $0x80325c
  800284:	e8 73 01 00 00       	call   8003fc <_panic>
		//else
		if ((maxShares_after == 2*maxShares) && (z == NULL)) panic("Trying to create a shared object that exceed the number of ALLOWED OBJECTS, krealloc should be invoked to double the size of shares array!!");
  800289:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80028c:	01 c0                	add    %eax,%eax
  80028e:	3b 45 cc             	cmp    -0x34(%ebp),%eax
  800291:	75 1a                	jne    8002ad <_main+0x275>
  800293:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
  800297:	75 14                	jne    8002ad <_main+0x275>
  800299:	83 ec 04             	sub    $0x4,%esp
  80029c:	68 a4 36 80 00       	push   $0x8036a4
  8002a1:	6a 41                	push   $0x41
  8002a3:	68 5c 32 80 00       	push   $0x80325c
  8002a8:	e8 4f 01 00 00       	call   8003fc <_panic>
	}
	cprintf("Congratulations!! Test of Shared Variables [Create: Special Cases] completed successfully!!\n\n\n");
  8002ad:	83 ec 0c             	sub    $0xc,%esp
  8002b0:	68 30 37 80 00       	push   $0x803730
  8002b5:	e8 f6 03 00 00       	call   8006b0 <cprintf>
  8002ba:	83 c4 10             	add    $0x10,%esp

	return;
  8002bd:	90                   	nop
}
  8002be:	c9                   	leave  
  8002bf:	c3                   	ret    

008002c0 <libmain>:
volatile struct Env *myEnv = NULL;
volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";

void
libmain(int argc, char **argv)
{
  8002c0:	55                   	push   %ebp
  8002c1:	89 e5                	mov    %esp,%ebp
  8002c3:	83 ec 18             	sub    $0x18,%esp
	int envIndex = sys_getenvindex();
  8002c6:	e8 63 1a 00 00       	call   801d2e <sys_getenvindex>
  8002cb:	89 45 f4             	mov    %eax,-0xc(%ebp)
	myEnv = &(envs[envIndex]);
  8002ce:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8002d1:	89 d0                	mov    %edx,%eax
  8002d3:	c1 e0 03             	shl    $0x3,%eax
  8002d6:	01 d0                	add    %edx,%eax
  8002d8:	01 c0                	add    %eax,%eax
  8002da:	01 d0                	add    %edx,%eax
  8002dc:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8002e3:	01 d0                	add    %edx,%eax
  8002e5:	c1 e0 04             	shl    $0x4,%eax
  8002e8:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  8002ed:	a3 20 40 80 00       	mov    %eax,0x804020

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  8002f2:	a1 20 40 80 00       	mov    0x804020,%eax
  8002f7:	8a 80 5c 05 00 00    	mov    0x55c(%eax),%al
  8002fd:	84 c0                	test   %al,%al
  8002ff:	74 0f                	je     800310 <libmain+0x50>
		binaryname = myEnv->prog_name;
  800301:	a1 20 40 80 00       	mov    0x804020,%eax
  800306:	05 5c 05 00 00       	add    $0x55c,%eax
  80030b:	a3 00 40 80 00       	mov    %eax,0x804000

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  800310:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800314:	7e 0a                	jle    800320 <libmain+0x60>
		binaryname = argv[0];
  800316:	8b 45 0c             	mov    0xc(%ebp),%eax
  800319:	8b 00                	mov    (%eax),%eax
  80031b:	a3 00 40 80 00       	mov    %eax,0x804000

	// call user main routine
	_main(argc, argv);
  800320:	83 ec 08             	sub    $0x8,%esp
  800323:	ff 75 0c             	pushl  0xc(%ebp)
  800326:	ff 75 08             	pushl  0x8(%ebp)
  800329:	e8 0a fd ff ff       	call   800038 <_main>
  80032e:	83 c4 10             	add    $0x10,%esp



	sys_disable_interrupt();
  800331:	e8 05 18 00 00       	call   801b3b <sys_disable_interrupt>
	cprintf("**************************************\n");
  800336:	83 ec 0c             	sub    $0xc,%esp
  800339:	68 a8 37 80 00       	push   $0x8037a8
  80033e:	e8 6d 03 00 00       	call   8006b0 <cprintf>
  800343:	83 c4 10             	add    $0x10,%esp
	cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  800346:	a1 20 40 80 00       	mov    0x804020,%eax
  80034b:	8b 90 44 05 00 00    	mov    0x544(%eax),%edx
  800351:	a1 20 40 80 00       	mov    0x804020,%eax
  800356:	8b 80 34 05 00 00    	mov    0x534(%eax),%eax
  80035c:	83 ec 04             	sub    $0x4,%esp
  80035f:	52                   	push   %edx
  800360:	50                   	push   %eax
  800361:	68 d0 37 80 00       	push   $0x8037d0
  800366:	e8 45 03 00 00       	call   8006b0 <cprintf>
  80036b:	83 c4 10             	add    $0x10,%esp
	cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  80036e:	a1 20 40 80 00       	mov    0x804020,%eax
  800373:	8b 88 54 05 00 00    	mov    0x554(%eax),%ecx
  800379:	a1 20 40 80 00       	mov    0x804020,%eax
  80037e:	8b 90 50 05 00 00    	mov    0x550(%eax),%edx
  800384:	a1 20 40 80 00       	mov    0x804020,%eax
  800389:	8b 80 4c 05 00 00    	mov    0x54c(%eax),%eax
  80038f:	51                   	push   %ecx
  800390:	52                   	push   %edx
  800391:	50                   	push   %eax
  800392:	68 f8 37 80 00       	push   $0x8037f8
  800397:	e8 14 03 00 00       	call   8006b0 <cprintf>
  80039c:	83 c4 10             	add    $0x10,%esp
	//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
	cprintf("Num of clocks = %d\n", myEnv->nClocks);
  80039f:	a1 20 40 80 00       	mov    0x804020,%eax
  8003a4:	8b 80 a4 05 00 00    	mov    0x5a4(%eax),%eax
  8003aa:	83 ec 08             	sub    $0x8,%esp
  8003ad:	50                   	push   %eax
  8003ae:	68 50 38 80 00       	push   $0x803850
  8003b3:	e8 f8 02 00 00       	call   8006b0 <cprintf>
  8003b8:	83 c4 10             	add    $0x10,%esp
	cprintf("**************************************\n");
  8003bb:	83 ec 0c             	sub    $0xc,%esp
  8003be:	68 a8 37 80 00       	push   $0x8037a8
  8003c3:	e8 e8 02 00 00       	call   8006b0 <cprintf>
  8003c8:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  8003cb:	e8 85 17 00 00       	call   801b55 <sys_enable_interrupt>

	// exit gracefully
	exit();
  8003d0:	e8 19 00 00 00       	call   8003ee <exit>
}
  8003d5:	90                   	nop
  8003d6:	c9                   	leave  
  8003d7:	c3                   	ret    

008003d8 <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  8003d8:	55                   	push   %ebp
  8003d9:	89 e5                	mov    %esp,%ebp
  8003db:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  8003de:	83 ec 0c             	sub    $0xc,%esp
  8003e1:	6a 00                	push   $0x0
  8003e3:	e8 12 19 00 00       	call   801cfa <sys_destroy_env>
  8003e8:	83 c4 10             	add    $0x10,%esp
}
  8003eb:	90                   	nop
  8003ec:	c9                   	leave  
  8003ed:	c3                   	ret    

008003ee <exit>:

void
exit(void)
{
  8003ee:	55                   	push   %ebp
  8003ef:	89 e5                	mov    %esp,%ebp
  8003f1:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  8003f4:	e8 67 19 00 00       	call   801d60 <sys_exit_env>
}
  8003f9:	90                   	nop
  8003fa:	c9                   	leave  
  8003fb:	c3                   	ret    

008003fc <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  8003fc:	55                   	push   %ebp
  8003fd:	89 e5                	mov    %esp,%ebp
  8003ff:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  800402:	8d 45 10             	lea    0x10(%ebp),%eax
  800405:	83 c0 04             	add    $0x4,%eax
  800408:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  80040b:	a1 5c 41 80 00       	mov    0x80415c,%eax
  800410:	85 c0                	test   %eax,%eax
  800412:	74 16                	je     80042a <_panic+0x2e>
		cprintf("%s: ", argv0);
  800414:	a1 5c 41 80 00       	mov    0x80415c,%eax
  800419:	83 ec 08             	sub    $0x8,%esp
  80041c:	50                   	push   %eax
  80041d:	68 64 38 80 00       	push   $0x803864
  800422:	e8 89 02 00 00       	call   8006b0 <cprintf>
  800427:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  80042a:	a1 00 40 80 00       	mov    0x804000,%eax
  80042f:	ff 75 0c             	pushl  0xc(%ebp)
  800432:	ff 75 08             	pushl  0x8(%ebp)
  800435:	50                   	push   %eax
  800436:	68 69 38 80 00       	push   $0x803869
  80043b:	e8 70 02 00 00       	call   8006b0 <cprintf>
  800440:	83 c4 10             	add    $0x10,%esp
	vcprintf(fmt, ap);
  800443:	8b 45 10             	mov    0x10(%ebp),%eax
  800446:	83 ec 08             	sub    $0x8,%esp
  800449:	ff 75 f4             	pushl  -0xc(%ebp)
  80044c:	50                   	push   %eax
  80044d:	e8 f3 01 00 00       	call   800645 <vcprintf>
  800452:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  800455:	83 ec 08             	sub    $0x8,%esp
  800458:	6a 00                	push   $0x0
  80045a:	68 85 38 80 00       	push   $0x803885
  80045f:	e8 e1 01 00 00       	call   800645 <vcprintf>
  800464:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  800467:	e8 82 ff ff ff       	call   8003ee <exit>

	// should not return here
	while (1) ;
  80046c:	eb fe                	jmp    80046c <_panic+0x70>

0080046e <CheckWSWithoutLastIndex>:
}

void CheckWSWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  80046e:	55                   	push   %ebp
  80046f:	89 e5                	mov    %esp,%ebp
  800471:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  800474:	a1 20 40 80 00       	mov    0x804020,%eax
  800479:	8b 50 74             	mov    0x74(%eax),%edx
  80047c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80047f:	39 c2                	cmp    %eax,%edx
  800481:	74 14                	je     800497 <CheckWSWithoutLastIndex+0x29>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  800483:	83 ec 04             	sub    $0x4,%esp
  800486:	68 88 38 80 00       	push   $0x803888
  80048b:	6a 26                	push   $0x26
  80048d:	68 d4 38 80 00       	push   $0x8038d4
  800492:	e8 65 ff ff ff       	call   8003fc <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  800497:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  80049e:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  8004a5:	e9 c2 00 00 00       	jmp    80056c <CheckWSWithoutLastIndex+0xfe>
		if (expectedPages[e] == 0) {
  8004aa:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8004ad:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8004b4:	8b 45 08             	mov    0x8(%ebp),%eax
  8004b7:	01 d0                	add    %edx,%eax
  8004b9:	8b 00                	mov    (%eax),%eax
  8004bb:	85 c0                	test   %eax,%eax
  8004bd:	75 08                	jne    8004c7 <CheckWSWithoutLastIndex+0x59>
			expectedNumOfEmptyLocs++;
  8004bf:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  8004c2:	e9 a2 00 00 00       	jmp    800569 <CheckWSWithoutLastIndex+0xfb>
		}
		int found = 0;
  8004c7:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8004ce:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  8004d5:	eb 69                	jmp    800540 <CheckWSWithoutLastIndex+0xd2>
			if (myEnv->__uptr_pws[w].empty == 0) {
  8004d7:	a1 20 40 80 00       	mov    0x804020,%eax
  8004dc:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  8004e2:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8004e5:	89 d0                	mov    %edx,%eax
  8004e7:	01 c0                	add    %eax,%eax
  8004e9:	01 d0                	add    %edx,%eax
  8004eb:	c1 e0 03             	shl    $0x3,%eax
  8004ee:	01 c8                	add    %ecx,%eax
  8004f0:	8a 40 04             	mov    0x4(%eax),%al
  8004f3:	84 c0                	test   %al,%al
  8004f5:	75 46                	jne    80053d <CheckWSWithoutLastIndex+0xcf>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  8004f7:	a1 20 40 80 00       	mov    0x804020,%eax
  8004fc:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  800502:	8b 55 e8             	mov    -0x18(%ebp),%edx
  800505:	89 d0                	mov    %edx,%eax
  800507:	01 c0                	add    %eax,%eax
  800509:	01 d0                	add    %edx,%eax
  80050b:	c1 e0 03             	shl    $0x3,%eax
  80050e:	01 c8                	add    %ecx,%eax
  800510:	8b 00                	mov    (%eax),%eax
  800512:	89 45 dc             	mov    %eax,-0x24(%ebp)
  800515:	8b 45 dc             	mov    -0x24(%ebp),%eax
  800518:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  80051d:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  80051f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800522:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  800529:	8b 45 08             	mov    0x8(%ebp),%eax
  80052c:	01 c8                	add    %ecx,%eax
  80052e:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  800530:	39 c2                	cmp    %eax,%edx
  800532:	75 09                	jne    80053d <CheckWSWithoutLastIndex+0xcf>
						== expectedPages[e]) {
					found = 1;
  800534:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  80053b:	eb 12                	jmp    80054f <CheckWSWithoutLastIndex+0xe1>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  80053d:	ff 45 e8             	incl   -0x18(%ebp)
  800540:	a1 20 40 80 00       	mov    0x804020,%eax
  800545:	8b 50 74             	mov    0x74(%eax),%edx
  800548:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80054b:	39 c2                	cmp    %eax,%edx
  80054d:	77 88                	ja     8004d7 <CheckWSWithoutLastIndex+0x69>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  80054f:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  800553:	75 14                	jne    800569 <CheckWSWithoutLastIndex+0xfb>
			panic(
  800555:	83 ec 04             	sub    $0x4,%esp
  800558:	68 e0 38 80 00       	push   $0x8038e0
  80055d:	6a 3a                	push   $0x3a
  80055f:	68 d4 38 80 00       	push   $0x8038d4
  800564:	e8 93 fe ff ff       	call   8003fc <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  800569:	ff 45 f0             	incl   -0x10(%ebp)
  80056c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80056f:	3b 45 0c             	cmp    0xc(%ebp),%eax
  800572:	0f 8c 32 ff ff ff    	jl     8004aa <CheckWSWithoutLastIndex+0x3c>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  800578:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  80057f:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  800586:	eb 26                	jmp    8005ae <CheckWSWithoutLastIndex+0x140>
		if (myEnv->__uptr_pws[w].empty == 1) {
  800588:	a1 20 40 80 00       	mov    0x804020,%eax
  80058d:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  800593:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800596:	89 d0                	mov    %edx,%eax
  800598:	01 c0                	add    %eax,%eax
  80059a:	01 d0                	add    %edx,%eax
  80059c:	c1 e0 03             	shl    $0x3,%eax
  80059f:	01 c8                	add    %ecx,%eax
  8005a1:	8a 40 04             	mov    0x4(%eax),%al
  8005a4:	3c 01                	cmp    $0x1,%al
  8005a6:	75 03                	jne    8005ab <CheckWSWithoutLastIndex+0x13d>
			actualNumOfEmptyLocs++;
  8005a8:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8005ab:	ff 45 e0             	incl   -0x20(%ebp)
  8005ae:	a1 20 40 80 00       	mov    0x804020,%eax
  8005b3:	8b 50 74             	mov    0x74(%eax),%edx
  8005b6:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8005b9:	39 c2                	cmp    %eax,%edx
  8005bb:	77 cb                	ja     800588 <CheckWSWithoutLastIndex+0x11a>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  8005bd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8005c0:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  8005c3:	74 14                	je     8005d9 <CheckWSWithoutLastIndex+0x16b>
		panic(
  8005c5:	83 ec 04             	sub    $0x4,%esp
  8005c8:	68 34 39 80 00       	push   $0x803934
  8005cd:	6a 44                	push   $0x44
  8005cf:	68 d4 38 80 00       	push   $0x8038d4
  8005d4:	e8 23 fe ff ff       	call   8003fc <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  8005d9:	90                   	nop
  8005da:	c9                   	leave  
  8005db:	c3                   	ret    

008005dc <putch>:
};

//2017:
uint8 printProgName = 0;

static void putch(int ch, struct printbuf *b) {
  8005dc:	55                   	push   %ebp
  8005dd:	89 e5                	mov    %esp,%ebp
  8005df:	83 ec 08             	sub    $0x8,%esp
	b->buf[b->idx++] = ch;
  8005e2:	8b 45 0c             	mov    0xc(%ebp),%eax
  8005e5:	8b 00                	mov    (%eax),%eax
  8005e7:	8d 48 01             	lea    0x1(%eax),%ecx
  8005ea:	8b 55 0c             	mov    0xc(%ebp),%edx
  8005ed:	89 0a                	mov    %ecx,(%edx)
  8005ef:	8b 55 08             	mov    0x8(%ebp),%edx
  8005f2:	88 d1                	mov    %dl,%cl
  8005f4:	8b 55 0c             	mov    0xc(%ebp),%edx
  8005f7:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  8005fb:	8b 45 0c             	mov    0xc(%ebp),%eax
  8005fe:	8b 00                	mov    (%eax),%eax
  800600:	3d ff 00 00 00       	cmp    $0xff,%eax
  800605:	75 2c                	jne    800633 <putch+0x57>
		sys_cputs(b->buf, b->idx, printProgName);
  800607:	a0 24 40 80 00       	mov    0x804024,%al
  80060c:	0f b6 c0             	movzbl %al,%eax
  80060f:	8b 55 0c             	mov    0xc(%ebp),%edx
  800612:	8b 12                	mov    (%edx),%edx
  800614:	89 d1                	mov    %edx,%ecx
  800616:	8b 55 0c             	mov    0xc(%ebp),%edx
  800619:	83 c2 08             	add    $0x8,%edx
  80061c:	83 ec 04             	sub    $0x4,%esp
  80061f:	50                   	push   %eax
  800620:	51                   	push   %ecx
  800621:	52                   	push   %edx
  800622:	e8 66 13 00 00       	call   80198d <sys_cputs>
  800627:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  80062a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80062d:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  800633:	8b 45 0c             	mov    0xc(%ebp),%eax
  800636:	8b 40 04             	mov    0x4(%eax),%eax
  800639:	8d 50 01             	lea    0x1(%eax),%edx
  80063c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80063f:	89 50 04             	mov    %edx,0x4(%eax)
}
  800642:	90                   	nop
  800643:	c9                   	leave  
  800644:	c3                   	ret    

00800645 <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  800645:	55                   	push   %ebp
  800646:	89 e5                	mov    %esp,%ebp
  800648:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  80064e:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  800655:	00 00 00 
	b.cnt = 0;
  800658:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  80065f:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  800662:	ff 75 0c             	pushl  0xc(%ebp)
  800665:	ff 75 08             	pushl  0x8(%ebp)
  800668:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  80066e:	50                   	push   %eax
  80066f:	68 dc 05 80 00       	push   $0x8005dc
  800674:	e8 11 02 00 00       	call   80088a <vprintfmt>
  800679:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName);
  80067c:	a0 24 40 80 00       	mov    0x804024,%al
  800681:	0f b6 c0             	movzbl %al,%eax
  800684:	8b 95 f0 fe ff ff    	mov    -0x110(%ebp),%edx
  80068a:	83 ec 04             	sub    $0x4,%esp
  80068d:	50                   	push   %eax
  80068e:	52                   	push   %edx
  80068f:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800695:	83 c0 08             	add    $0x8,%eax
  800698:	50                   	push   %eax
  800699:	e8 ef 12 00 00       	call   80198d <sys_cputs>
  80069e:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  8006a1:	c6 05 24 40 80 00 00 	movb   $0x0,0x804024
	return b.cnt;
  8006a8:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  8006ae:	c9                   	leave  
  8006af:	c3                   	ret    

008006b0 <cprintf>:

int cprintf(const char *fmt, ...) {
  8006b0:	55                   	push   %ebp
  8006b1:	89 e5                	mov    %esp,%ebp
  8006b3:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  8006b6:	c6 05 24 40 80 00 01 	movb   $0x1,0x804024
	va_start(ap, fmt);
  8006bd:	8d 45 0c             	lea    0xc(%ebp),%eax
  8006c0:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  8006c3:	8b 45 08             	mov    0x8(%ebp),%eax
  8006c6:	83 ec 08             	sub    $0x8,%esp
  8006c9:	ff 75 f4             	pushl  -0xc(%ebp)
  8006cc:	50                   	push   %eax
  8006cd:	e8 73 ff ff ff       	call   800645 <vcprintf>
  8006d2:	83 c4 10             	add    $0x10,%esp
  8006d5:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  8006d8:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8006db:	c9                   	leave  
  8006dc:	c3                   	ret    

008006dd <atomic_cprintf>:

int atomic_cprintf(const char *fmt, ...) {
  8006dd:	55                   	push   %ebp
  8006de:	89 e5                	mov    %esp,%ebp
  8006e0:	83 ec 18             	sub    $0x18,%esp
	sys_disable_interrupt();
  8006e3:	e8 53 14 00 00       	call   801b3b <sys_disable_interrupt>
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  8006e8:	8d 45 0c             	lea    0xc(%ebp),%eax
  8006eb:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  8006ee:	8b 45 08             	mov    0x8(%ebp),%eax
  8006f1:	83 ec 08             	sub    $0x8,%esp
  8006f4:	ff 75 f4             	pushl  -0xc(%ebp)
  8006f7:	50                   	push   %eax
  8006f8:	e8 48 ff ff ff       	call   800645 <vcprintf>
  8006fd:	83 c4 10             	add    $0x10,%esp
  800700:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	sys_enable_interrupt();
  800703:	e8 4d 14 00 00       	call   801b55 <sys_enable_interrupt>
	return cnt;
  800708:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  80070b:	c9                   	leave  
  80070c:	c3                   	ret    

0080070d <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  80070d:	55                   	push   %ebp
  80070e:	89 e5                	mov    %esp,%ebp
  800710:	53                   	push   %ebx
  800711:	83 ec 14             	sub    $0x14,%esp
  800714:	8b 45 10             	mov    0x10(%ebp),%eax
  800717:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80071a:	8b 45 14             	mov    0x14(%ebp),%eax
  80071d:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800720:	8b 45 18             	mov    0x18(%ebp),%eax
  800723:	ba 00 00 00 00       	mov    $0x0,%edx
  800728:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  80072b:	77 55                	ja     800782 <printnum+0x75>
  80072d:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800730:	72 05                	jb     800737 <printnum+0x2a>
  800732:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  800735:	77 4b                	ja     800782 <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800737:	8b 45 1c             	mov    0x1c(%ebp),%eax
  80073a:	8d 58 ff             	lea    -0x1(%eax),%ebx
  80073d:	8b 45 18             	mov    0x18(%ebp),%eax
  800740:	ba 00 00 00 00       	mov    $0x0,%edx
  800745:	52                   	push   %edx
  800746:	50                   	push   %eax
  800747:	ff 75 f4             	pushl  -0xc(%ebp)
  80074a:	ff 75 f0             	pushl  -0x10(%ebp)
  80074d:	e8 86 28 00 00       	call   802fd8 <__udivdi3>
  800752:	83 c4 10             	add    $0x10,%esp
  800755:	83 ec 04             	sub    $0x4,%esp
  800758:	ff 75 20             	pushl  0x20(%ebp)
  80075b:	53                   	push   %ebx
  80075c:	ff 75 18             	pushl  0x18(%ebp)
  80075f:	52                   	push   %edx
  800760:	50                   	push   %eax
  800761:	ff 75 0c             	pushl  0xc(%ebp)
  800764:	ff 75 08             	pushl  0x8(%ebp)
  800767:	e8 a1 ff ff ff       	call   80070d <printnum>
  80076c:	83 c4 20             	add    $0x20,%esp
  80076f:	eb 1a                	jmp    80078b <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  800771:	83 ec 08             	sub    $0x8,%esp
  800774:	ff 75 0c             	pushl  0xc(%ebp)
  800777:	ff 75 20             	pushl  0x20(%ebp)
  80077a:	8b 45 08             	mov    0x8(%ebp),%eax
  80077d:	ff d0                	call   *%eax
  80077f:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800782:	ff 4d 1c             	decl   0x1c(%ebp)
  800785:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  800789:	7f e6                	jg     800771 <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  80078b:	8b 4d 18             	mov    0x18(%ebp),%ecx
  80078e:	bb 00 00 00 00       	mov    $0x0,%ebx
  800793:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800796:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800799:	53                   	push   %ebx
  80079a:	51                   	push   %ecx
  80079b:	52                   	push   %edx
  80079c:	50                   	push   %eax
  80079d:	e8 46 29 00 00       	call   8030e8 <__umoddi3>
  8007a2:	83 c4 10             	add    $0x10,%esp
  8007a5:	05 94 3b 80 00       	add    $0x803b94,%eax
  8007aa:	8a 00                	mov    (%eax),%al
  8007ac:	0f be c0             	movsbl %al,%eax
  8007af:	83 ec 08             	sub    $0x8,%esp
  8007b2:	ff 75 0c             	pushl  0xc(%ebp)
  8007b5:	50                   	push   %eax
  8007b6:	8b 45 08             	mov    0x8(%ebp),%eax
  8007b9:	ff d0                	call   *%eax
  8007bb:	83 c4 10             	add    $0x10,%esp
}
  8007be:	90                   	nop
  8007bf:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8007c2:	c9                   	leave  
  8007c3:	c3                   	ret    

008007c4 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  8007c4:	55                   	push   %ebp
  8007c5:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  8007c7:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  8007cb:	7e 1c                	jle    8007e9 <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  8007cd:	8b 45 08             	mov    0x8(%ebp),%eax
  8007d0:	8b 00                	mov    (%eax),%eax
  8007d2:	8d 50 08             	lea    0x8(%eax),%edx
  8007d5:	8b 45 08             	mov    0x8(%ebp),%eax
  8007d8:	89 10                	mov    %edx,(%eax)
  8007da:	8b 45 08             	mov    0x8(%ebp),%eax
  8007dd:	8b 00                	mov    (%eax),%eax
  8007df:	83 e8 08             	sub    $0x8,%eax
  8007e2:	8b 50 04             	mov    0x4(%eax),%edx
  8007e5:	8b 00                	mov    (%eax),%eax
  8007e7:	eb 40                	jmp    800829 <getuint+0x65>
	else if (lflag)
  8007e9:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8007ed:	74 1e                	je     80080d <getuint+0x49>
		return va_arg(*ap, unsigned long);
  8007ef:	8b 45 08             	mov    0x8(%ebp),%eax
  8007f2:	8b 00                	mov    (%eax),%eax
  8007f4:	8d 50 04             	lea    0x4(%eax),%edx
  8007f7:	8b 45 08             	mov    0x8(%ebp),%eax
  8007fa:	89 10                	mov    %edx,(%eax)
  8007fc:	8b 45 08             	mov    0x8(%ebp),%eax
  8007ff:	8b 00                	mov    (%eax),%eax
  800801:	83 e8 04             	sub    $0x4,%eax
  800804:	8b 00                	mov    (%eax),%eax
  800806:	ba 00 00 00 00       	mov    $0x0,%edx
  80080b:	eb 1c                	jmp    800829 <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  80080d:	8b 45 08             	mov    0x8(%ebp),%eax
  800810:	8b 00                	mov    (%eax),%eax
  800812:	8d 50 04             	lea    0x4(%eax),%edx
  800815:	8b 45 08             	mov    0x8(%ebp),%eax
  800818:	89 10                	mov    %edx,(%eax)
  80081a:	8b 45 08             	mov    0x8(%ebp),%eax
  80081d:	8b 00                	mov    (%eax),%eax
  80081f:	83 e8 04             	sub    $0x4,%eax
  800822:	8b 00                	mov    (%eax),%eax
  800824:	ba 00 00 00 00       	mov    $0x0,%edx
}
  800829:	5d                   	pop    %ebp
  80082a:	c3                   	ret    

0080082b <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  80082b:	55                   	push   %ebp
  80082c:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  80082e:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800832:	7e 1c                	jle    800850 <getint+0x25>
		return va_arg(*ap, long long);
  800834:	8b 45 08             	mov    0x8(%ebp),%eax
  800837:	8b 00                	mov    (%eax),%eax
  800839:	8d 50 08             	lea    0x8(%eax),%edx
  80083c:	8b 45 08             	mov    0x8(%ebp),%eax
  80083f:	89 10                	mov    %edx,(%eax)
  800841:	8b 45 08             	mov    0x8(%ebp),%eax
  800844:	8b 00                	mov    (%eax),%eax
  800846:	83 e8 08             	sub    $0x8,%eax
  800849:	8b 50 04             	mov    0x4(%eax),%edx
  80084c:	8b 00                	mov    (%eax),%eax
  80084e:	eb 38                	jmp    800888 <getint+0x5d>
	else if (lflag)
  800850:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800854:	74 1a                	je     800870 <getint+0x45>
		return va_arg(*ap, long);
  800856:	8b 45 08             	mov    0x8(%ebp),%eax
  800859:	8b 00                	mov    (%eax),%eax
  80085b:	8d 50 04             	lea    0x4(%eax),%edx
  80085e:	8b 45 08             	mov    0x8(%ebp),%eax
  800861:	89 10                	mov    %edx,(%eax)
  800863:	8b 45 08             	mov    0x8(%ebp),%eax
  800866:	8b 00                	mov    (%eax),%eax
  800868:	83 e8 04             	sub    $0x4,%eax
  80086b:	8b 00                	mov    (%eax),%eax
  80086d:	99                   	cltd   
  80086e:	eb 18                	jmp    800888 <getint+0x5d>
	else
		return va_arg(*ap, int);
  800870:	8b 45 08             	mov    0x8(%ebp),%eax
  800873:	8b 00                	mov    (%eax),%eax
  800875:	8d 50 04             	lea    0x4(%eax),%edx
  800878:	8b 45 08             	mov    0x8(%ebp),%eax
  80087b:	89 10                	mov    %edx,(%eax)
  80087d:	8b 45 08             	mov    0x8(%ebp),%eax
  800880:	8b 00                	mov    (%eax),%eax
  800882:	83 e8 04             	sub    $0x4,%eax
  800885:	8b 00                	mov    (%eax),%eax
  800887:	99                   	cltd   
}
  800888:	5d                   	pop    %ebp
  800889:	c3                   	ret    

0080088a <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  80088a:	55                   	push   %ebp
  80088b:	89 e5                	mov    %esp,%ebp
  80088d:	56                   	push   %esi
  80088e:	53                   	push   %ebx
  80088f:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800892:	eb 17                	jmp    8008ab <vprintfmt+0x21>
			if (ch == '\0')
  800894:	85 db                	test   %ebx,%ebx
  800896:	0f 84 af 03 00 00    	je     800c4b <vprintfmt+0x3c1>
				return;
			putch(ch, putdat);
  80089c:	83 ec 08             	sub    $0x8,%esp
  80089f:	ff 75 0c             	pushl  0xc(%ebp)
  8008a2:	53                   	push   %ebx
  8008a3:	8b 45 08             	mov    0x8(%ebp),%eax
  8008a6:	ff d0                	call   *%eax
  8008a8:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8008ab:	8b 45 10             	mov    0x10(%ebp),%eax
  8008ae:	8d 50 01             	lea    0x1(%eax),%edx
  8008b1:	89 55 10             	mov    %edx,0x10(%ebp)
  8008b4:	8a 00                	mov    (%eax),%al
  8008b6:	0f b6 d8             	movzbl %al,%ebx
  8008b9:	83 fb 25             	cmp    $0x25,%ebx
  8008bc:	75 d6                	jne    800894 <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  8008be:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  8008c2:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  8008c9:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  8008d0:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  8008d7:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8008de:	8b 45 10             	mov    0x10(%ebp),%eax
  8008e1:	8d 50 01             	lea    0x1(%eax),%edx
  8008e4:	89 55 10             	mov    %edx,0x10(%ebp)
  8008e7:	8a 00                	mov    (%eax),%al
  8008e9:	0f b6 d8             	movzbl %al,%ebx
  8008ec:	8d 43 dd             	lea    -0x23(%ebx),%eax
  8008ef:	83 f8 55             	cmp    $0x55,%eax
  8008f2:	0f 87 2b 03 00 00    	ja     800c23 <vprintfmt+0x399>
  8008f8:	8b 04 85 b8 3b 80 00 	mov    0x803bb8(,%eax,4),%eax
  8008ff:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  800901:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  800905:	eb d7                	jmp    8008de <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  800907:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  80090b:	eb d1                	jmp    8008de <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  80090d:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  800914:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800917:	89 d0                	mov    %edx,%eax
  800919:	c1 e0 02             	shl    $0x2,%eax
  80091c:	01 d0                	add    %edx,%eax
  80091e:	01 c0                	add    %eax,%eax
  800920:	01 d8                	add    %ebx,%eax
  800922:	83 e8 30             	sub    $0x30,%eax
  800925:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  800928:	8b 45 10             	mov    0x10(%ebp),%eax
  80092b:	8a 00                	mov    (%eax),%al
  80092d:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  800930:	83 fb 2f             	cmp    $0x2f,%ebx
  800933:	7e 3e                	jle    800973 <vprintfmt+0xe9>
  800935:	83 fb 39             	cmp    $0x39,%ebx
  800938:	7f 39                	jg     800973 <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  80093a:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  80093d:	eb d5                	jmp    800914 <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  80093f:	8b 45 14             	mov    0x14(%ebp),%eax
  800942:	83 c0 04             	add    $0x4,%eax
  800945:	89 45 14             	mov    %eax,0x14(%ebp)
  800948:	8b 45 14             	mov    0x14(%ebp),%eax
  80094b:	83 e8 04             	sub    $0x4,%eax
  80094e:	8b 00                	mov    (%eax),%eax
  800950:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  800953:	eb 1f                	jmp    800974 <vprintfmt+0xea>

		case '.':
			if (width < 0)
  800955:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800959:	79 83                	jns    8008de <vprintfmt+0x54>
				width = 0;
  80095b:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  800962:	e9 77 ff ff ff       	jmp    8008de <vprintfmt+0x54>

		case '#':
			altflag = 1;
  800967:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  80096e:	e9 6b ff ff ff       	jmp    8008de <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  800973:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  800974:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800978:	0f 89 60 ff ff ff    	jns    8008de <vprintfmt+0x54>
				width = precision, precision = -1;
  80097e:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800981:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800984:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  80098b:	e9 4e ff ff ff       	jmp    8008de <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  800990:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  800993:	e9 46 ff ff ff       	jmp    8008de <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  800998:	8b 45 14             	mov    0x14(%ebp),%eax
  80099b:	83 c0 04             	add    $0x4,%eax
  80099e:	89 45 14             	mov    %eax,0x14(%ebp)
  8009a1:	8b 45 14             	mov    0x14(%ebp),%eax
  8009a4:	83 e8 04             	sub    $0x4,%eax
  8009a7:	8b 00                	mov    (%eax),%eax
  8009a9:	83 ec 08             	sub    $0x8,%esp
  8009ac:	ff 75 0c             	pushl  0xc(%ebp)
  8009af:	50                   	push   %eax
  8009b0:	8b 45 08             	mov    0x8(%ebp),%eax
  8009b3:	ff d0                	call   *%eax
  8009b5:	83 c4 10             	add    $0x10,%esp
			break;
  8009b8:	e9 89 02 00 00       	jmp    800c46 <vprintfmt+0x3bc>

		// error message
		case 'e':
			err = va_arg(ap, int);
  8009bd:	8b 45 14             	mov    0x14(%ebp),%eax
  8009c0:	83 c0 04             	add    $0x4,%eax
  8009c3:	89 45 14             	mov    %eax,0x14(%ebp)
  8009c6:	8b 45 14             	mov    0x14(%ebp),%eax
  8009c9:	83 e8 04             	sub    $0x4,%eax
  8009cc:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  8009ce:	85 db                	test   %ebx,%ebx
  8009d0:	79 02                	jns    8009d4 <vprintfmt+0x14a>
				err = -err;
  8009d2:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  8009d4:	83 fb 64             	cmp    $0x64,%ebx
  8009d7:	7f 0b                	jg     8009e4 <vprintfmt+0x15a>
  8009d9:	8b 34 9d 00 3a 80 00 	mov    0x803a00(,%ebx,4),%esi
  8009e0:	85 f6                	test   %esi,%esi
  8009e2:	75 19                	jne    8009fd <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  8009e4:	53                   	push   %ebx
  8009e5:	68 a5 3b 80 00       	push   $0x803ba5
  8009ea:	ff 75 0c             	pushl  0xc(%ebp)
  8009ed:	ff 75 08             	pushl  0x8(%ebp)
  8009f0:	e8 5e 02 00 00       	call   800c53 <printfmt>
  8009f5:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  8009f8:	e9 49 02 00 00       	jmp    800c46 <vprintfmt+0x3bc>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  8009fd:	56                   	push   %esi
  8009fe:	68 ae 3b 80 00       	push   $0x803bae
  800a03:	ff 75 0c             	pushl  0xc(%ebp)
  800a06:	ff 75 08             	pushl  0x8(%ebp)
  800a09:	e8 45 02 00 00       	call   800c53 <printfmt>
  800a0e:	83 c4 10             	add    $0x10,%esp
			break;
  800a11:	e9 30 02 00 00       	jmp    800c46 <vprintfmt+0x3bc>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  800a16:	8b 45 14             	mov    0x14(%ebp),%eax
  800a19:	83 c0 04             	add    $0x4,%eax
  800a1c:	89 45 14             	mov    %eax,0x14(%ebp)
  800a1f:	8b 45 14             	mov    0x14(%ebp),%eax
  800a22:	83 e8 04             	sub    $0x4,%eax
  800a25:	8b 30                	mov    (%eax),%esi
  800a27:	85 f6                	test   %esi,%esi
  800a29:	75 05                	jne    800a30 <vprintfmt+0x1a6>
				p = "(null)";
  800a2b:	be b1 3b 80 00       	mov    $0x803bb1,%esi
			if (width > 0 && padc != '-')
  800a30:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800a34:	7e 6d                	jle    800aa3 <vprintfmt+0x219>
  800a36:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  800a3a:	74 67                	je     800aa3 <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  800a3c:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800a3f:	83 ec 08             	sub    $0x8,%esp
  800a42:	50                   	push   %eax
  800a43:	56                   	push   %esi
  800a44:	e8 0c 03 00 00       	call   800d55 <strnlen>
  800a49:	83 c4 10             	add    $0x10,%esp
  800a4c:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  800a4f:	eb 16                	jmp    800a67 <vprintfmt+0x1dd>
					putch(padc, putdat);
  800a51:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  800a55:	83 ec 08             	sub    $0x8,%esp
  800a58:	ff 75 0c             	pushl  0xc(%ebp)
  800a5b:	50                   	push   %eax
  800a5c:	8b 45 08             	mov    0x8(%ebp),%eax
  800a5f:	ff d0                	call   *%eax
  800a61:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800a64:	ff 4d e4             	decl   -0x1c(%ebp)
  800a67:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800a6b:	7f e4                	jg     800a51 <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800a6d:	eb 34                	jmp    800aa3 <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  800a6f:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  800a73:	74 1c                	je     800a91 <vprintfmt+0x207>
  800a75:	83 fb 1f             	cmp    $0x1f,%ebx
  800a78:	7e 05                	jle    800a7f <vprintfmt+0x1f5>
  800a7a:	83 fb 7e             	cmp    $0x7e,%ebx
  800a7d:	7e 12                	jle    800a91 <vprintfmt+0x207>
					putch('?', putdat);
  800a7f:	83 ec 08             	sub    $0x8,%esp
  800a82:	ff 75 0c             	pushl  0xc(%ebp)
  800a85:	6a 3f                	push   $0x3f
  800a87:	8b 45 08             	mov    0x8(%ebp),%eax
  800a8a:	ff d0                	call   *%eax
  800a8c:	83 c4 10             	add    $0x10,%esp
  800a8f:	eb 0f                	jmp    800aa0 <vprintfmt+0x216>
				else
					putch(ch, putdat);
  800a91:	83 ec 08             	sub    $0x8,%esp
  800a94:	ff 75 0c             	pushl  0xc(%ebp)
  800a97:	53                   	push   %ebx
  800a98:	8b 45 08             	mov    0x8(%ebp),%eax
  800a9b:	ff d0                	call   *%eax
  800a9d:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800aa0:	ff 4d e4             	decl   -0x1c(%ebp)
  800aa3:	89 f0                	mov    %esi,%eax
  800aa5:	8d 70 01             	lea    0x1(%eax),%esi
  800aa8:	8a 00                	mov    (%eax),%al
  800aaa:	0f be d8             	movsbl %al,%ebx
  800aad:	85 db                	test   %ebx,%ebx
  800aaf:	74 24                	je     800ad5 <vprintfmt+0x24b>
  800ab1:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800ab5:	78 b8                	js     800a6f <vprintfmt+0x1e5>
  800ab7:	ff 4d e0             	decl   -0x20(%ebp)
  800aba:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800abe:	79 af                	jns    800a6f <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800ac0:	eb 13                	jmp    800ad5 <vprintfmt+0x24b>
				putch(' ', putdat);
  800ac2:	83 ec 08             	sub    $0x8,%esp
  800ac5:	ff 75 0c             	pushl  0xc(%ebp)
  800ac8:	6a 20                	push   $0x20
  800aca:	8b 45 08             	mov    0x8(%ebp),%eax
  800acd:	ff d0                	call   *%eax
  800acf:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800ad2:	ff 4d e4             	decl   -0x1c(%ebp)
  800ad5:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800ad9:	7f e7                	jg     800ac2 <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  800adb:	e9 66 01 00 00       	jmp    800c46 <vprintfmt+0x3bc>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  800ae0:	83 ec 08             	sub    $0x8,%esp
  800ae3:	ff 75 e8             	pushl  -0x18(%ebp)
  800ae6:	8d 45 14             	lea    0x14(%ebp),%eax
  800ae9:	50                   	push   %eax
  800aea:	e8 3c fd ff ff       	call   80082b <getint>
  800aef:	83 c4 10             	add    $0x10,%esp
  800af2:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800af5:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  800af8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800afb:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800afe:	85 d2                	test   %edx,%edx
  800b00:	79 23                	jns    800b25 <vprintfmt+0x29b>
				putch('-', putdat);
  800b02:	83 ec 08             	sub    $0x8,%esp
  800b05:	ff 75 0c             	pushl  0xc(%ebp)
  800b08:	6a 2d                	push   $0x2d
  800b0a:	8b 45 08             	mov    0x8(%ebp),%eax
  800b0d:	ff d0                	call   *%eax
  800b0f:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  800b12:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800b15:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800b18:	f7 d8                	neg    %eax
  800b1a:	83 d2 00             	adc    $0x0,%edx
  800b1d:	f7 da                	neg    %edx
  800b1f:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800b22:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  800b25:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800b2c:	e9 bc 00 00 00       	jmp    800bed <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  800b31:	83 ec 08             	sub    $0x8,%esp
  800b34:	ff 75 e8             	pushl  -0x18(%ebp)
  800b37:	8d 45 14             	lea    0x14(%ebp),%eax
  800b3a:	50                   	push   %eax
  800b3b:	e8 84 fc ff ff       	call   8007c4 <getuint>
  800b40:	83 c4 10             	add    $0x10,%esp
  800b43:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800b46:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  800b49:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800b50:	e9 98 00 00 00       	jmp    800bed <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  800b55:	83 ec 08             	sub    $0x8,%esp
  800b58:	ff 75 0c             	pushl  0xc(%ebp)
  800b5b:	6a 58                	push   $0x58
  800b5d:	8b 45 08             	mov    0x8(%ebp),%eax
  800b60:	ff d0                	call   *%eax
  800b62:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800b65:	83 ec 08             	sub    $0x8,%esp
  800b68:	ff 75 0c             	pushl  0xc(%ebp)
  800b6b:	6a 58                	push   $0x58
  800b6d:	8b 45 08             	mov    0x8(%ebp),%eax
  800b70:	ff d0                	call   *%eax
  800b72:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800b75:	83 ec 08             	sub    $0x8,%esp
  800b78:	ff 75 0c             	pushl  0xc(%ebp)
  800b7b:	6a 58                	push   $0x58
  800b7d:	8b 45 08             	mov    0x8(%ebp),%eax
  800b80:	ff d0                	call   *%eax
  800b82:	83 c4 10             	add    $0x10,%esp
			break;
  800b85:	e9 bc 00 00 00       	jmp    800c46 <vprintfmt+0x3bc>

		// pointer
		case 'p':
			putch('0', putdat);
  800b8a:	83 ec 08             	sub    $0x8,%esp
  800b8d:	ff 75 0c             	pushl  0xc(%ebp)
  800b90:	6a 30                	push   $0x30
  800b92:	8b 45 08             	mov    0x8(%ebp),%eax
  800b95:	ff d0                	call   *%eax
  800b97:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  800b9a:	83 ec 08             	sub    $0x8,%esp
  800b9d:	ff 75 0c             	pushl  0xc(%ebp)
  800ba0:	6a 78                	push   $0x78
  800ba2:	8b 45 08             	mov    0x8(%ebp),%eax
  800ba5:	ff d0                	call   *%eax
  800ba7:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  800baa:	8b 45 14             	mov    0x14(%ebp),%eax
  800bad:	83 c0 04             	add    $0x4,%eax
  800bb0:	89 45 14             	mov    %eax,0x14(%ebp)
  800bb3:	8b 45 14             	mov    0x14(%ebp),%eax
  800bb6:	83 e8 04             	sub    $0x4,%eax
  800bb9:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800bbb:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800bbe:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  800bc5:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  800bcc:	eb 1f                	jmp    800bed <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  800bce:	83 ec 08             	sub    $0x8,%esp
  800bd1:	ff 75 e8             	pushl  -0x18(%ebp)
  800bd4:	8d 45 14             	lea    0x14(%ebp),%eax
  800bd7:	50                   	push   %eax
  800bd8:	e8 e7 fb ff ff       	call   8007c4 <getuint>
  800bdd:	83 c4 10             	add    $0x10,%esp
  800be0:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800be3:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  800be6:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800bed:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  800bf1:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800bf4:	83 ec 04             	sub    $0x4,%esp
  800bf7:	52                   	push   %edx
  800bf8:	ff 75 e4             	pushl  -0x1c(%ebp)
  800bfb:	50                   	push   %eax
  800bfc:	ff 75 f4             	pushl  -0xc(%ebp)
  800bff:	ff 75 f0             	pushl  -0x10(%ebp)
  800c02:	ff 75 0c             	pushl  0xc(%ebp)
  800c05:	ff 75 08             	pushl  0x8(%ebp)
  800c08:	e8 00 fb ff ff       	call   80070d <printnum>
  800c0d:	83 c4 20             	add    $0x20,%esp
			break;
  800c10:	eb 34                	jmp    800c46 <vprintfmt+0x3bc>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  800c12:	83 ec 08             	sub    $0x8,%esp
  800c15:	ff 75 0c             	pushl  0xc(%ebp)
  800c18:	53                   	push   %ebx
  800c19:	8b 45 08             	mov    0x8(%ebp),%eax
  800c1c:	ff d0                	call   *%eax
  800c1e:	83 c4 10             	add    $0x10,%esp
			break;
  800c21:	eb 23                	jmp    800c46 <vprintfmt+0x3bc>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800c23:	83 ec 08             	sub    $0x8,%esp
  800c26:	ff 75 0c             	pushl  0xc(%ebp)
  800c29:	6a 25                	push   $0x25
  800c2b:	8b 45 08             	mov    0x8(%ebp),%eax
  800c2e:	ff d0                	call   *%eax
  800c30:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  800c33:	ff 4d 10             	decl   0x10(%ebp)
  800c36:	eb 03                	jmp    800c3b <vprintfmt+0x3b1>
  800c38:	ff 4d 10             	decl   0x10(%ebp)
  800c3b:	8b 45 10             	mov    0x10(%ebp),%eax
  800c3e:	48                   	dec    %eax
  800c3f:	8a 00                	mov    (%eax),%al
  800c41:	3c 25                	cmp    $0x25,%al
  800c43:	75 f3                	jne    800c38 <vprintfmt+0x3ae>
				/* do nothing */;
			break;
  800c45:	90                   	nop
		}
	}
  800c46:	e9 47 fc ff ff       	jmp    800892 <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  800c4b:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  800c4c:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800c4f:	5b                   	pop    %ebx
  800c50:	5e                   	pop    %esi
  800c51:	5d                   	pop    %ebp
  800c52:	c3                   	ret    

00800c53 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800c53:	55                   	push   %ebp
  800c54:	89 e5                	mov    %esp,%ebp
  800c56:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  800c59:	8d 45 10             	lea    0x10(%ebp),%eax
  800c5c:	83 c0 04             	add    $0x4,%eax
  800c5f:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  800c62:	8b 45 10             	mov    0x10(%ebp),%eax
  800c65:	ff 75 f4             	pushl  -0xc(%ebp)
  800c68:	50                   	push   %eax
  800c69:	ff 75 0c             	pushl  0xc(%ebp)
  800c6c:	ff 75 08             	pushl  0x8(%ebp)
  800c6f:	e8 16 fc ff ff       	call   80088a <vprintfmt>
  800c74:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  800c77:	90                   	nop
  800c78:	c9                   	leave  
  800c79:	c3                   	ret    

00800c7a <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800c7a:	55                   	push   %ebp
  800c7b:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  800c7d:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c80:	8b 40 08             	mov    0x8(%eax),%eax
  800c83:	8d 50 01             	lea    0x1(%eax),%edx
  800c86:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c89:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  800c8c:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c8f:	8b 10                	mov    (%eax),%edx
  800c91:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c94:	8b 40 04             	mov    0x4(%eax),%eax
  800c97:	39 c2                	cmp    %eax,%edx
  800c99:	73 12                	jae    800cad <sprintputch+0x33>
		*b->buf++ = ch;
  800c9b:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c9e:	8b 00                	mov    (%eax),%eax
  800ca0:	8d 48 01             	lea    0x1(%eax),%ecx
  800ca3:	8b 55 0c             	mov    0xc(%ebp),%edx
  800ca6:	89 0a                	mov    %ecx,(%edx)
  800ca8:	8b 55 08             	mov    0x8(%ebp),%edx
  800cab:	88 10                	mov    %dl,(%eax)
}
  800cad:	90                   	nop
  800cae:	5d                   	pop    %ebp
  800caf:	c3                   	ret    

00800cb0 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800cb0:	55                   	push   %ebp
  800cb1:	89 e5                	mov    %esp,%ebp
  800cb3:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  800cb6:	8b 45 08             	mov    0x8(%ebp),%eax
  800cb9:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800cbc:	8b 45 0c             	mov    0xc(%ebp),%eax
  800cbf:	8d 50 ff             	lea    -0x1(%eax),%edx
  800cc2:	8b 45 08             	mov    0x8(%ebp),%eax
  800cc5:	01 d0                	add    %edx,%eax
  800cc7:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800cca:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800cd1:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800cd5:	74 06                	je     800cdd <vsnprintf+0x2d>
  800cd7:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800cdb:	7f 07                	jg     800ce4 <vsnprintf+0x34>
		return -E_INVAL;
  800cdd:	b8 03 00 00 00       	mov    $0x3,%eax
  800ce2:	eb 20                	jmp    800d04 <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800ce4:	ff 75 14             	pushl  0x14(%ebp)
  800ce7:	ff 75 10             	pushl  0x10(%ebp)
  800cea:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800ced:	50                   	push   %eax
  800cee:	68 7a 0c 80 00       	push   $0x800c7a
  800cf3:	e8 92 fb ff ff       	call   80088a <vprintfmt>
  800cf8:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  800cfb:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800cfe:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800d01:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  800d04:	c9                   	leave  
  800d05:	c3                   	ret    

00800d06 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800d06:	55                   	push   %ebp
  800d07:	89 e5                	mov    %esp,%ebp
  800d09:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800d0c:	8d 45 10             	lea    0x10(%ebp),%eax
  800d0f:	83 c0 04             	add    $0x4,%eax
  800d12:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  800d15:	8b 45 10             	mov    0x10(%ebp),%eax
  800d18:	ff 75 f4             	pushl  -0xc(%ebp)
  800d1b:	50                   	push   %eax
  800d1c:	ff 75 0c             	pushl  0xc(%ebp)
  800d1f:	ff 75 08             	pushl  0x8(%ebp)
  800d22:	e8 89 ff ff ff       	call   800cb0 <vsnprintf>
  800d27:	83 c4 10             	add    $0x10,%esp
  800d2a:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  800d2d:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800d30:	c9                   	leave  
  800d31:	c3                   	ret    

00800d32 <strlen>:

#include <inc/string.h>

int
strlen(const char *s)
{
  800d32:	55                   	push   %ebp
  800d33:	89 e5                	mov    %esp,%ebp
  800d35:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  800d38:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800d3f:	eb 06                	jmp    800d47 <strlen+0x15>
		n++;
  800d41:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  800d44:	ff 45 08             	incl   0x8(%ebp)
  800d47:	8b 45 08             	mov    0x8(%ebp),%eax
  800d4a:	8a 00                	mov    (%eax),%al
  800d4c:	84 c0                	test   %al,%al
  800d4e:	75 f1                	jne    800d41 <strlen+0xf>
		n++;
	return n;
  800d50:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800d53:	c9                   	leave  
  800d54:	c3                   	ret    

00800d55 <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  800d55:	55                   	push   %ebp
  800d56:	89 e5                	mov    %esp,%ebp
  800d58:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800d5b:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800d62:	eb 09                	jmp    800d6d <strnlen+0x18>
		n++;
  800d64:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800d67:	ff 45 08             	incl   0x8(%ebp)
  800d6a:	ff 4d 0c             	decl   0xc(%ebp)
  800d6d:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800d71:	74 09                	je     800d7c <strnlen+0x27>
  800d73:	8b 45 08             	mov    0x8(%ebp),%eax
  800d76:	8a 00                	mov    (%eax),%al
  800d78:	84 c0                	test   %al,%al
  800d7a:	75 e8                	jne    800d64 <strnlen+0xf>
		n++;
	return n;
  800d7c:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800d7f:	c9                   	leave  
  800d80:	c3                   	ret    

00800d81 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800d81:	55                   	push   %ebp
  800d82:	89 e5                	mov    %esp,%ebp
  800d84:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  800d87:	8b 45 08             	mov    0x8(%ebp),%eax
  800d8a:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  800d8d:	90                   	nop
  800d8e:	8b 45 08             	mov    0x8(%ebp),%eax
  800d91:	8d 50 01             	lea    0x1(%eax),%edx
  800d94:	89 55 08             	mov    %edx,0x8(%ebp)
  800d97:	8b 55 0c             	mov    0xc(%ebp),%edx
  800d9a:	8d 4a 01             	lea    0x1(%edx),%ecx
  800d9d:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800da0:	8a 12                	mov    (%edx),%dl
  800da2:	88 10                	mov    %dl,(%eax)
  800da4:	8a 00                	mov    (%eax),%al
  800da6:	84 c0                	test   %al,%al
  800da8:	75 e4                	jne    800d8e <strcpy+0xd>
		/* do nothing */;
	return ret;
  800daa:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800dad:	c9                   	leave  
  800dae:	c3                   	ret    

00800daf <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  800daf:	55                   	push   %ebp
  800db0:	89 e5                	mov    %esp,%ebp
  800db2:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  800db5:	8b 45 08             	mov    0x8(%ebp),%eax
  800db8:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  800dbb:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800dc2:	eb 1f                	jmp    800de3 <strncpy+0x34>
		*dst++ = *src;
  800dc4:	8b 45 08             	mov    0x8(%ebp),%eax
  800dc7:	8d 50 01             	lea    0x1(%eax),%edx
  800dca:	89 55 08             	mov    %edx,0x8(%ebp)
  800dcd:	8b 55 0c             	mov    0xc(%ebp),%edx
  800dd0:	8a 12                	mov    (%edx),%dl
  800dd2:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  800dd4:	8b 45 0c             	mov    0xc(%ebp),%eax
  800dd7:	8a 00                	mov    (%eax),%al
  800dd9:	84 c0                	test   %al,%al
  800ddb:	74 03                	je     800de0 <strncpy+0x31>
			src++;
  800ddd:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800de0:	ff 45 fc             	incl   -0x4(%ebp)
  800de3:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800de6:	3b 45 10             	cmp    0x10(%ebp),%eax
  800de9:	72 d9                	jb     800dc4 <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  800deb:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  800dee:	c9                   	leave  
  800def:	c3                   	ret    

00800df0 <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  800df0:	55                   	push   %ebp
  800df1:	89 e5                	mov    %esp,%ebp
  800df3:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  800df6:	8b 45 08             	mov    0x8(%ebp),%eax
  800df9:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  800dfc:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800e00:	74 30                	je     800e32 <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  800e02:	eb 16                	jmp    800e1a <strlcpy+0x2a>
			*dst++ = *src++;
  800e04:	8b 45 08             	mov    0x8(%ebp),%eax
  800e07:	8d 50 01             	lea    0x1(%eax),%edx
  800e0a:	89 55 08             	mov    %edx,0x8(%ebp)
  800e0d:	8b 55 0c             	mov    0xc(%ebp),%edx
  800e10:	8d 4a 01             	lea    0x1(%edx),%ecx
  800e13:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800e16:	8a 12                	mov    (%edx),%dl
  800e18:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  800e1a:	ff 4d 10             	decl   0x10(%ebp)
  800e1d:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800e21:	74 09                	je     800e2c <strlcpy+0x3c>
  800e23:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e26:	8a 00                	mov    (%eax),%al
  800e28:	84 c0                	test   %al,%al
  800e2a:	75 d8                	jne    800e04 <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  800e2c:	8b 45 08             	mov    0x8(%ebp),%eax
  800e2f:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800e32:	8b 55 08             	mov    0x8(%ebp),%edx
  800e35:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800e38:	29 c2                	sub    %eax,%edx
  800e3a:	89 d0                	mov    %edx,%eax
}
  800e3c:	c9                   	leave  
  800e3d:	c3                   	ret    

00800e3e <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800e3e:	55                   	push   %ebp
  800e3f:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  800e41:	eb 06                	jmp    800e49 <strcmp+0xb>
		p++, q++;
  800e43:	ff 45 08             	incl   0x8(%ebp)
  800e46:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  800e49:	8b 45 08             	mov    0x8(%ebp),%eax
  800e4c:	8a 00                	mov    (%eax),%al
  800e4e:	84 c0                	test   %al,%al
  800e50:	74 0e                	je     800e60 <strcmp+0x22>
  800e52:	8b 45 08             	mov    0x8(%ebp),%eax
  800e55:	8a 10                	mov    (%eax),%dl
  800e57:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e5a:	8a 00                	mov    (%eax),%al
  800e5c:	38 c2                	cmp    %al,%dl
  800e5e:	74 e3                	je     800e43 <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800e60:	8b 45 08             	mov    0x8(%ebp),%eax
  800e63:	8a 00                	mov    (%eax),%al
  800e65:	0f b6 d0             	movzbl %al,%edx
  800e68:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e6b:	8a 00                	mov    (%eax),%al
  800e6d:	0f b6 c0             	movzbl %al,%eax
  800e70:	29 c2                	sub    %eax,%edx
  800e72:	89 d0                	mov    %edx,%eax
}
  800e74:	5d                   	pop    %ebp
  800e75:	c3                   	ret    

00800e76 <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  800e76:	55                   	push   %ebp
  800e77:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  800e79:	eb 09                	jmp    800e84 <strncmp+0xe>
		n--, p++, q++;
  800e7b:	ff 4d 10             	decl   0x10(%ebp)
  800e7e:	ff 45 08             	incl   0x8(%ebp)
  800e81:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  800e84:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800e88:	74 17                	je     800ea1 <strncmp+0x2b>
  800e8a:	8b 45 08             	mov    0x8(%ebp),%eax
  800e8d:	8a 00                	mov    (%eax),%al
  800e8f:	84 c0                	test   %al,%al
  800e91:	74 0e                	je     800ea1 <strncmp+0x2b>
  800e93:	8b 45 08             	mov    0x8(%ebp),%eax
  800e96:	8a 10                	mov    (%eax),%dl
  800e98:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e9b:	8a 00                	mov    (%eax),%al
  800e9d:	38 c2                	cmp    %al,%dl
  800e9f:	74 da                	je     800e7b <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  800ea1:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800ea5:	75 07                	jne    800eae <strncmp+0x38>
		return 0;
  800ea7:	b8 00 00 00 00       	mov    $0x0,%eax
  800eac:	eb 14                	jmp    800ec2 <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800eae:	8b 45 08             	mov    0x8(%ebp),%eax
  800eb1:	8a 00                	mov    (%eax),%al
  800eb3:	0f b6 d0             	movzbl %al,%edx
  800eb6:	8b 45 0c             	mov    0xc(%ebp),%eax
  800eb9:	8a 00                	mov    (%eax),%al
  800ebb:	0f b6 c0             	movzbl %al,%eax
  800ebe:	29 c2                	sub    %eax,%edx
  800ec0:	89 d0                	mov    %edx,%eax
}
  800ec2:	5d                   	pop    %ebp
  800ec3:	c3                   	ret    

00800ec4 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800ec4:	55                   	push   %ebp
  800ec5:	89 e5                	mov    %esp,%ebp
  800ec7:	83 ec 04             	sub    $0x4,%esp
  800eca:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ecd:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800ed0:	eb 12                	jmp    800ee4 <strchr+0x20>
		if (*s == c)
  800ed2:	8b 45 08             	mov    0x8(%ebp),%eax
  800ed5:	8a 00                	mov    (%eax),%al
  800ed7:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800eda:	75 05                	jne    800ee1 <strchr+0x1d>
			return (char *) s;
  800edc:	8b 45 08             	mov    0x8(%ebp),%eax
  800edf:	eb 11                	jmp    800ef2 <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  800ee1:	ff 45 08             	incl   0x8(%ebp)
  800ee4:	8b 45 08             	mov    0x8(%ebp),%eax
  800ee7:	8a 00                	mov    (%eax),%al
  800ee9:	84 c0                	test   %al,%al
  800eeb:	75 e5                	jne    800ed2 <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  800eed:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800ef2:	c9                   	leave  
  800ef3:	c3                   	ret    

00800ef4 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800ef4:	55                   	push   %ebp
  800ef5:	89 e5                	mov    %esp,%ebp
  800ef7:	83 ec 04             	sub    $0x4,%esp
  800efa:	8b 45 0c             	mov    0xc(%ebp),%eax
  800efd:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800f00:	eb 0d                	jmp    800f0f <strfind+0x1b>
		if (*s == c)
  800f02:	8b 45 08             	mov    0x8(%ebp),%eax
  800f05:	8a 00                	mov    (%eax),%al
  800f07:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800f0a:	74 0e                	je     800f1a <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  800f0c:	ff 45 08             	incl   0x8(%ebp)
  800f0f:	8b 45 08             	mov    0x8(%ebp),%eax
  800f12:	8a 00                	mov    (%eax),%al
  800f14:	84 c0                	test   %al,%al
  800f16:	75 ea                	jne    800f02 <strfind+0xe>
  800f18:	eb 01                	jmp    800f1b <strfind+0x27>
		if (*s == c)
			break;
  800f1a:	90                   	nop
	return (char *) s;
  800f1b:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800f1e:	c9                   	leave  
  800f1f:	c3                   	ret    

00800f20 <memset>:


void *
memset(void *v, int c, uint32 n)
{
  800f20:	55                   	push   %ebp
  800f21:	89 e5                	mov    %esp,%ebp
  800f23:	83 ec 10             	sub    $0x10,%esp
	char *p;
	int m;

	p = v;
  800f26:	8b 45 08             	mov    0x8(%ebp),%eax
  800f29:	89 45 fc             	mov    %eax,-0x4(%ebp)
	m = n;
  800f2c:	8b 45 10             	mov    0x10(%ebp),%eax
  800f2f:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (--m >= 0)
  800f32:	eb 0e                	jmp    800f42 <memset+0x22>
		*p++ = c;
  800f34:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800f37:	8d 50 01             	lea    0x1(%eax),%edx
  800f3a:	89 55 fc             	mov    %edx,-0x4(%ebp)
  800f3d:	8b 55 0c             	mov    0xc(%ebp),%edx
  800f40:	88 10                	mov    %dl,(%eax)
	char *p;
	int m;

	p = v;
	m = n;
	while (--m >= 0)
  800f42:	ff 4d f8             	decl   -0x8(%ebp)
  800f45:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
  800f49:	79 e9                	jns    800f34 <memset+0x14>
		*p++ = c;

	return v;
  800f4b:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800f4e:	c9                   	leave  
  800f4f:	c3                   	ret    

00800f50 <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  800f50:	55                   	push   %ebp
  800f51:	89 e5                	mov    %esp,%ebp
  800f53:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  800f56:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f59:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  800f5c:	8b 45 08             	mov    0x8(%ebp),%eax
  800f5f:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (n-- > 0)
  800f62:	eb 16                	jmp    800f7a <memcpy+0x2a>
		*d++ = *s++;
  800f64:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800f67:	8d 50 01             	lea    0x1(%eax),%edx
  800f6a:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800f6d:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800f70:	8d 4a 01             	lea    0x1(%edx),%ecx
  800f73:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  800f76:	8a 12                	mov    (%edx),%dl
  800f78:	88 10                	mov    %dl,(%eax)
	const char *s;
	char *d;

	s = src;
	d = dst;
	while (n-- > 0)
  800f7a:	8b 45 10             	mov    0x10(%ebp),%eax
  800f7d:	8d 50 ff             	lea    -0x1(%eax),%edx
  800f80:	89 55 10             	mov    %edx,0x10(%ebp)
  800f83:	85 c0                	test   %eax,%eax
  800f85:	75 dd                	jne    800f64 <memcpy+0x14>
		*d++ = *s++;

	return dst;
  800f87:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800f8a:	c9                   	leave  
  800f8b:	c3                   	ret    

00800f8c <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  800f8c:	55                   	push   %ebp
  800f8d:	89 e5                	mov    %esp,%ebp
  800f8f:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  800f92:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f95:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  800f98:	8b 45 08             	mov    0x8(%ebp),%eax
  800f9b:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  800f9e:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800fa1:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800fa4:	73 50                	jae    800ff6 <memmove+0x6a>
  800fa6:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800fa9:	8b 45 10             	mov    0x10(%ebp),%eax
  800fac:	01 d0                	add    %edx,%eax
  800fae:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800fb1:	76 43                	jbe    800ff6 <memmove+0x6a>
		s += n;
  800fb3:	8b 45 10             	mov    0x10(%ebp),%eax
  800fb6:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  800fb9:	8b 45 10             	mov    0x10(%ebp),%eax
  800fbc:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  800fbf:	eb 10                	jmp    800fd1 <memmove+0x45>
			*--d = *--s;
  800fc1:	ff 4d f8             	decl   -0x8(%ebp)
  800fc4:	ff 4d fc             	decl   -0x4(%ebp)
  800fc7:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800fca:	8a 10                	mov    (%eax),%dl
  800fcc:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800fcf:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  800fd1:	8b 45 10             	mov    0x10(%ebp),%eax
  800fd4:	8d 50 ff             	lea    -0x1(%eax),%edx
  800fd7:	89 55 10             	mov    %edx,0x10(%ebp)
  800fda:	85 c0                	test   %eax,%eax
  800fdc:	75 e3                	jne    800fc1 <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800fde:	eb 23                	jmp    801003 <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  800fe0:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800fe3:	8d 50 01             	lea    0x1(%eax),%edx
  800fe6:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800fe9:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800fec:	8d 4a 01             	lea    0x1(%edx),%ecx
  800fef:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  800ff2:	8a 12                	mov    (%edx),%dl
  800ff4:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  800ff6:	8b 45 10             	mov    0x10(%ebp),%eax
  800ff9:	8d 50 ff             	lea    -0x1(%eax),%edx
  800ffc:	89 55 10             	mov    %edx,0x10(%ebp)
  800fff:	85 c0                	test   %eax,%eax
  801001:	75 dd                	jne    800fe0 <memmove+0x54>
			*d++ = *s++;

	return dst;
  801003:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801006:	c9                   	leave  
  801007:	c3                   	ret    

00801008 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  801008:	55                   	push   %ebp
  801009:	89 e5                	mov    %esp,%ebp
  80100b:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  80100e:	8b 45 08             	mov    0x8(%ebp),%eax
  801011:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  801014:	8b 45 0c             	mov    0xc(%ebp),%eax
  801017:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  80101a:	eb 2a                	jmp    801046 <memcmp+0x3e>
		if (*s1 != *s2)
  80101c:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80101f:	8a 10                	mov    (%eax),%dl
  801021:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801024:	8a 00                	mov    (%eax),%al
  801026:	38 c2                	cmp    %al,%dl
  801028:	74 16                	je     801040 <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  80102a:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80102d:	8a 00                	mov    (%eax),%al
  80102f:	0f b6 d0             	movzbl %al,%edx
  801032:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801035:	8a 00                	mov    (%eax),%al
  801037:	0f b6 c0             	movzbl %al,%eax
  80103a:	29 c2                	sub    %eax,%edx
  80103c:	89 d0                	mov    %edx,%eax
  80103e:	eb 18                	jmp    801058 <memcmp+0x50>
		s1++, s2++;
  801040:	ff 45 fc             	incl   -0x4(%ebp)
  801043:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  801046:	8b 45 10             	mov    0x10(%ebp),%eax
  801049:	8d 50 ff             	lea    -0x1(%eax),%edx
  80104c:	89 55 10             	mov    %edx,0x10(%ebp)
  80104f:	85 c0                	test   %eax,%eax
  801051:	75 c9                	jne    80101c <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  801053:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801058:	c9                   	leave  
  801059:	c3                   	ret    

0080105a <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  80105a:	55                   	push   %ebp
  80105b:	89 e5                	mov    %esp,%ebp
  80105d:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  801060:	8b 55 08             	mov    0x8(%ebp),%edx
  801063:	8b 45 10             	mov    0x10(%ebp),%eax
  801066:	01 d0                	add    %edx,%eax
  801068:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  80106b:	eb 15                	jmp    801082 <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  80106d:	8b 45 08             	mov    0x8(%ebp),%eax
  801070:	8a 00                	mov    (%eax),%al
  801072:	0f b6 d0             	movzbl %al,%edx
  801075:	8b 45 0c             	mov    0xc(%ebp),%eax
  801078:	0f b6 c0             	movzbl %al,%eax
  80107b:	39 c2                	cmp    %eax,%edx
  80107d:	74 0d                	je     80108c <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  80107f:	ff 45 08             	incl   0x8(%ebp)
  801082:	8b 45 08             	mov    0x8(%ebp),%eax
  801085:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  801088:	72 e3                	jb     80106d <memfind+0x13>
  80108a:	eb 01                	jmp    80108d <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  80108c:	90                   	nop
	return (void *) s;
  80108d:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801090:	c9                   	leave  
  801091:	c3                   	ret    

00801092 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  801092:	55                   	push   %ebp
  801093:	89 e5                	mov    %esp,%ebp
  801095:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  801098:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  80109f:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  8010a6:	eb 03                	jmp    8010ab <strtol+0x19>
		s++;
  8010a8:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  8010ab:	8b 45 08             	mov    0x8(%ebp),%eax
  8010ae:	8a 00                	mov    (%eax),%al
  8010b0:	3c 20                	cmp    $0x20,%al
  8010b2:	74 f4                	je     8010a8 <strtol+0x16>
  8010b4:	8b 45 08             	mov    0x8(%ebp),%eax
  8010b7:	8a 00                	mov    (%eax),%al
  8010b9:	3c 09                	cmp    $0x9,%al
  8010bb:	74 eb                	je     8010a8 <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  8010bd:	8b 45 08             	mov    0x8(%ebp),%eax
  8010c0:	8a 00                	mov    (%eax),%al
  8010c2:	3c 2b                	cmp    $0x2b,%al
  8010c4:	75 05                	jne    8010cb <strtol+0x39>
		s++;
  8010c6:	ff 45 08             	incl   0x8(%ebp)
  8010c9:	eb 13                	jmp    8010de <strtol+0x4c>
	else if (*s == '-')
  8010cb:	8b 45 08             	mov    0x8(%ebp),%eax
  8010ce:	8a 00                	mov    (%eax),%al
  8010d0:	3c 2d                	cmp    $0x2d,%al
  8010d2:	75 0a                	jne    8010de <strtol+0x4c>
		s++, neg = 1;
  8010d4:	ff 45 08             	incl   0x8(%ebp)
  8010d7:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  8010de:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8010e2:	74 06                	je     8010ea <strtol+0x58>
  8010e4:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  8010e8:	75 20                	jne    80110a <strtol+0x78>
  8010ea:	8b 45 08             	mov    0x8(%ebp),%eax
  8010ed:	8a 00                	mov    (%eax),%al
  8010ef:	3c 30                	cmp    $0x30,%al
  8010f1:	75 17                	jne    80110a <strtol+0x78>
  8010f3:	8b 45 08             	mov    0x8(%ebp),%eax
  8010f6:	40                   	inc    %eax
  8010f7:	8a 00                	mov    (%eax),%al
  8010f9:	3c 78                	cmp    $0x78,%al
  8010fb:	75 0d                	jne    80110a <strtol+0x78>
		s += 2, base = 16;
  8010fd:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  801101:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  801108:	eb 28                	jmp    801132 <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  80110a:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80110e:	75 15                	jne    801125 <strtol+0x93>
  801110:	8b 45 08             	mov    0x8(%ebp),%eax
  801113:	8a 00                	mov    (%eax),%al
  801115:	3c 30                	cmp    $0x30,%al
  801117:	75 0c                	jne    801125 <strtol+0x93>
		s++, base = 8;
  801119:	ff 45 08             	incl   0x8(%ebp)
  80111c:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  801123:	eb 0d                	jmp    801132 <strtol+0xa0>
	else if (base == 0)
  801125:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801129:	75 07                	jne    801132 <strtol+0xa0>
		base = 10;
  80112b:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  801132:	8b 45 08             	mov    0x8(%ebp),%eax
  801135:	8a 00                	mov    (%eax),%al
  801137:	3c 2f                	cmp    $0x2f,%al
  801139:	7e 19                	jle    801154 <strtol+0xc2>
  80113b:	8b 45 08             	mov    0x8(%ebp),%eax
  80113e:	8a 00                	mov    (%eax),%al
  801140:	3c 39                	cmp    $0x39,%al
  801142:	7f 10                	jg     801154 <strtol+0xc2>
			dig = *s - '0';
  801144:	8b 45 08             	mov    0x8(%ebp),%eax
  801147:	8a 00                	mov    (%eax),%al
  801149:	0f be c0             	movsbl %al,%eax
  80114c:	83 e8 30             	sub    $0x30,%eax
  80114f:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801152:	eb 42                	jmp    801196 <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  801154:	8b 45 08             	mov    0x8(%ebp),%eax
  801157:	8a 00                	mov    (%eax),%al
  801159:	3c 60                	cmp    $0x60,%al
  80115b:	7e 19                	jle    801176 <strtol+0xe4>
  80115d:	8b 45 08             	mov    0x8(%ebp),%eax
  801160:	8a 00                	mov    (%eax),%al
  801162:	3c 7a                	cmp    $0x7a,%al
  801164:	7f 10                	jg     801176 <strtol+0xe4>
			dig = *s - 'a' + 10;
  801166:	8b 45 08             	mov    0x8(%ebp),%eax
  801169:	8a 00                	mov    (%eax),%al
  80116b:	0f be c0             	movsbl %al,%eax
  80116e:	83 e8 57             	sub    $0x57,%eax
  801171:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801174:	eb 20                	jmp    801196 <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  801176:	8b 45 08             	mov    0x8(%ebp),%eax
  801179:	8a 00                	mov    (%eax),%al
  80117b:	3c 40                	cmp    $0x40,%al
  80117d:	7e 39                	jle    8011b8 <strtol+0x126>
  80117f:	8b 45 08             	mov    0x8(%ebp),%eax
  801182:	8a 00                	mov    (%eax),%al
  801184:	3c 5a                	cmp    $0x5a,%al
  801186:	7f 30                	jg     8011b8 <strtol+0x126>
			dig = *s - 'A' + 10;
  801188:	8b 45 08             	mov    0x8(%ebp),%eax
  80118b:	8a 00                	mov    (%eax),%al
  80118d:	0f be c0             	movsbl %al,%eax
  801190:	83 e8 37             	sub    $0x37,%eax
  801193:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  801196:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801199:	3b 45 10             	cmp    0x10(%ebp),%eax
  80119c:	7d 19                	jge    8011b7 <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  80119e:	ff 45 08             	incl   0x8(%ebp)
  8011a1:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8011a4:	0f af 45 10          	imul   0x10(%ebp),%eax
  8011a8:	89 c2                	mov    %eax,%edx
  8011aa:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8011ad:	01 d0                	add    %edx,%eax
  8011af:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  8011b2:	e9 7b ff ff ff       	jmp    801132 <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  8011b7:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  8011b8:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8011bc:	74 08                	je     8011c6 <strtol+0x134>
		*endptr = (char *) s;
  8011be:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011c1:	8b 55 08             	mov    0x8(%ebp),%edx
  8011c4:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  8011c6:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  8011ca:	74 07                	je     8011d3 <strtol+0x141>
  8011cc:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8011cf:	f7 d8                	neg    %eax
  8011d1:	eb 03                	jmp    8011d6 <strtol+0x144>
  8011d3:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  8011d6:	c9                   	leave  
  8011d7:	c3                   	ret    

008011d8 <ltostr>:

void
ltostr(long value, char *str)
{
  8011d8:	55                   	push   %ebp
  8011d9:	89 e5                	mov    %esp,%ebp
  8011db:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  8011de:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  8011e5:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  8011ec:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8011f0:	79 13                	jns    801205 <ltostr+0x2d>
	{
		neg = 1;
  8011f2:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  8011f9:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011fc:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  8011ff:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  801202:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  801205:	8b 45 08             	mov    0x8(%ebp),%eax
  801208:	b9 0a 00 00 00       	mov    $0xa,%ecx
  80120d:	99                   	cltd   
  80120e:	f7 f9                	idiv   %ecx
  801210:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  801213:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801216:	8d 50 01             	lea    0x1(%eax),%edx
  801219:	89 55 f8             	mov    %edx,-0x8(%ebp)
  80121c:	89 c2                	mov    %eax,%edx
  80121e:	8b 45 0c             	mov    0xc(%ebp),%eax
  801221:	01 d0                	add    %edx,%eax
  801223:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801226:	83 c2 30             	add    $0x30,%edx
  801229:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  80122b:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80122e:	b8 67 66 66 66       	mov    $0x66666667,%eax
  801233:	f7 e9                	imul   %ecx
  801235:	c1 fa 02             	sar    $0x2,%edx
  801238:	89 c8                	mov    %ecx,%eax
  80123a:	c1 f8 1f             	sar    $0x1f,%eax
  80123d:	29 c2                	sub    %eax,%edx
  80123f:	89 d0                	mov    %edx,%eax
  801241:	89 45 08             	mov    %eax,0x8(%ebp)
	} while (value % 10 != 0);
  801244:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801247:	b8 67 66 66 66       	mov    $0x66666667,%eax
  80124c:	f7 e9                	imul   %ecx
  80124e:	c1 fa 02             	sar    $0x2,%edx
  801251:	89 c8                	mov    %ecx,%eax
  801253:	c1 f8 1f             	sar    $0x1f,%eax
  801256:	29 c2                	sub    %eax,%edx
  801258:	89 d0                	mov    %edx,%eax
  80125a:	c1 e0 02             	shl    $0x2,%eax
  80125d:	01 d0                	add    %edx,%eax
  80125f:	01 c0                	add    %eax,%eax
  801261:	29 c1                	sub    %eax,%ecx
  801263:	89 ca                	mov    %ecx,%edx
  801265:	85 d2                	test   %edx,%edx
  801267:	75 9c                	jne    801205 <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  801269:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  801270:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801273:	48                   	dec    %eax
  801274:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  801277:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  80127b:	74 3d                	je     8012ba <ltostr+0xe2>
		start = 1 ;
  80127d:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  801284:	eb 34                	jmp    8012ba <ltostr+0xe2>
	{
		char tmp = str[start] ;
  801286:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801289:	8b 45 0c             	mov    0xc(%ebp),%eax
  80128c:	01 d0                	add    %edx,%eax
  80128e:	8a 00                	mov    (%eax),%al
  801290:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  801293:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801296:	8b 45 0c             	mov    0xc(%ebp),%eax
  801299:	01 c2                	add    %eax,%edx
  80129b:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  80129e:	8b 45 0c             	mov    0xc(%ebp),%eax
  8012a1:	01 c8                	add    %ecx,%eax
  8012a3:	8a 00                	mov    (%eax),%al
  8012a5:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  8012a7:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8012aa:	8b 45 0c             	mov    0xc(%ebp),%eax
  8012ad:	01 c2                	add    %eax,%edx
  8012af:	8a 45 eb             	mov    -0x15(%ebp),%al
  8012b2:	88 02                	mov    %al,(%edx)
		start++ ;
  8012b4:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  8012b7:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  8012ba:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8012bd:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8012c0:	7c c4                	jl     801286 <ltostr+0xae>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  8012c2:	8b 55 f8             	mov    -0x8(%ebp),%edx
  8012c5:	8b 45 0c             	mov    0xc(%ebp),%eax
  8012c8:	01 d0                	add    %edx,%eax
  8012ca:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  8012cd:	90                   	nop
  8012ce:	c9                   	leave  
  8012cf:	c3                   	ret    

008012d0 <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  8012d0:	55                   	push   %ebp
  8012d1:	89 e5                	mov    %esp,%ebp
  8012d3:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  8012d6:	ff 75 08             	pushl  0x8(%ebp)
  8012d9:	e8 54 fa ff ff       	call   800d32 <strlen>
  8012de:	83 c4 04             	add    $0x4,%esp
  8012e1:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  8012e4:	ff 75 0c             	pushl  0xc(%ebp)
  8012e7:	e8 46 fa ff ff       	call   800d32 <strlen>
  8012ec:	83 c4 04             	add    $0x4,%esp
  8012ef:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  8012f2:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  8012f9:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801300:	eb 17                	jmp    801319 <strcconcat+0x49>
		final[s] = str1[s] ;
  801302:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801305:	8b 45 10             	mov    0x10(%ebp),%eax
  801308:	01 c2                	add    %eax,%edx
  80130a:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  80130d:	8b 45 08             	mov    0x8(%ebp),%eax
  801310:	01 c8                	add    %ecx,%eax
  801312:	8a 00                	mov    (%eax),%al
  801314:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  801316:	ff 45 fc             	incl   -0x4(%ebp)
  801319:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80131c:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  80131f:	7c e1                	jl     801302 <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  801321:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  801328:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  80132f:	eb 1f                	jmp    801350 <strcconcat+0x80>
		final[s++] = str2[i] ;
  801331:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801334:	8d 50 01             	lea    0x1(%eax),%edx
  801337:	89 55 fc             	mov    %edx,-0x4(%ebp)
  80133a:	89 c2                	mov    %eax,%edx
  80133c:	8b 45 10             	mov    0x10(%ebp),%eax
  80133f:	01 c2                	add    %eax,%edx
  801341:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  801344:	8b 45 0c             	mov    0xc(%ebp),%eax
  801347:	01 c8                	add    %ecx,%eax
  801349:	8a 00                	mov    (%eax),%al
  80134b:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  80134d:	ff 45 f8             	incl   -0x8(%ebp)
  801350:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801353:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801356:	7c d9                	jl     801331 <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  801358:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80135b:	8b 45 10             	mov    0x10(%ebp),%eax
  80135e:	01 d0                	add    %edx,%eax
  801360:	c6 00 00             	movb   $0x0,(%eax)
}
  801363:	90                   	nop
  801364:	c9                   	leave  
  801365:	c3                   	ret    

00801366 <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  801366:	55                   	push   %ebp
  801367:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  801369:	8b 45 14             	mov    0x14(%ebp),%eax
  80136c:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  801372:	8b 45 14             	mov    0x14(%ebp),%eax
  801375:	8b 00                	mov    (%eax),%eax
  801377:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80137e:	8b 45 10             	mov    0x10(%ebp),%eax
  801381:	01 d0                	add    %edx,%eax
  801383:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801389:	eb 0c                	jmp    801397 <strsplit+0x31>
			*string++ = 0;
  80138b:	8b 45 08             	mov    0x8(%ebp),%eax
  80138e:	8d 50 01             	lea    0x1(%eax),%edx
  801391:	89 55 08             	mov    %edx,0x8(%ebp)
  801394:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801397:	8b 45 08             	mov    0x8(%ebp),%eax
  80139a:	8a 00                	mov    (%eax),%al
  80139c:	84 c0                	test   %al,%al
  80139e:	74 18                	je     8013b8 <strsplit+0x52>
  8013a0:	8b 45 08             	mov    0x8(%ebp),%eax
  8013a3:	8a 00                	mov    (%eax),%al
  8013a5:	0f be c0             	movsbl %al,%eax
  8013a8:	50                   	push   %eax
  8013a9:	ff 75 0c             	pushl  0xc(%ebp)
  8013ac:	e8 13 fb ff ff       	call   800ec4 <strchr>
  8013b1:	83 c4 08             	add    $0x8,%esp
  8013b4:	85 c0                	test   %eax,%eax
  8013b6:	75 d3                	jne    80138b <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  8013b8:	8b 45 08             	mov    0x8(%ebp),%eax
  8013bb:	8a 00                	mov    (%eax),%al
  8013bd:	84 c0                	test   %al,%al
  8013bf:	74 5a                	je     80141b <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  8013c1:	8b 45 14             	mov    0x14(%ebp),%eax
  8013c4:	8b 00                	mov    (%eax),%eax
  8013c6:	83 f8 0f             	cmp    $0xf,%eax
  8013c9:	75 07                	jne    8013d2 <strsplit+0x6c>
		{
			return 0;
  8013cb:	b8 00 00 00 00       	mov    $0x0,%eax
  8013d0:	eb 66                	jmp    801438 <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  8013d2:	8b 45 14             	mov    0x14(%ebp),%eax
  8013d5:	8b 00                	mov    (%eax),%eax
  8013d7:	8d 48 01             	lea    0x1(%eax),%ecx
  8013da:	8b 55 14             	mov    0x14(%ebp),%edx
  8013dd:	89 0a                	mov    %ecx,(%edx)
  8013df:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8013e6:	8b 45 10             	mov    0x10(%ebp),%eax
  8013e9:	01 c2                	add    %eax,%edx
  8013eb:	8b 45 08             	mov    0x8(%ebp),%eax
  8013ee:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  8013f0:	eb 03                	jmp    8013f5 <strsplit+0x8f>
			string++;
  8013f2:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  8013f5:	8b 45 08             	mov    0x8(%ebp),%eax
  8013f8:	8a 00                	mov    (%eax),%al
  8013fa:	84 c0                	test   %al,%al
  8013fc:	74 8b                	je     801389 <strsplit+0x23>
  8013fe:	8b 45 08             	mov    0x8(%ebp),%eax
  801401:	8a 00                	mov    (%eax),%al
  801403:	0f be c0             	movsbl %al,%eax
  801406:	50                   	push   %eax
  801407:	ff 75 0c             	pushl  0xc(%ebp)
  80140a:	e8 b5 fa ff ff       	call   800ec4 <strchr>
  80140f:	83 c4 08             	add    $0x8,%esp
  801412:	85 c0                	test   %eax,%eax
  801414:	74 dc                	je     8013f2 <strsplit+0x8c>
			string++;
	}
  801416:	e9 6e ff ff ff       	jmp    801389 <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  80141b:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  80141c:	8b 45 14             	mov    0x14(%ebp),%eax
  80141f:	8b 00                	mov    (%eax),%eax
  801421:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801428:	8b 45 10             	mov    0x10(%ebp),%eax
  80142b:	01 d0                	add    %edx,%eax
  80142d:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  801433:	b8 01 00 00 00       	mov    $0x1,%eax
}
  801438:	c9                   	leave  
  801439:	c3                   	ret    

0080143a <InitializeUHeap>:
//============================== GIVEN FUNCTIONS ===================================//
//==================================================================================//

int FirstTimeFlag = 1;
void InitializeUHeap()
{
  80143a:	55                   	push   %ebp
  80143b:	89 e5                	mov    %esp,%ebp
  80143d:	83 ec 08             	sub    $0x8,%esp
	if(FirstTimeFlag)
  801440:	a1 04 40 80 00       	mov    0x804004,%eax
  801445:	85 c0                	test   %eax,%eax
  801447:	74 1f                	je     801468 <InitializeUHeap+0x2e>
	{
		initialize_dyn_block_system();
  801449:	e8 1d 00 00 00       	call   80146b <initialize_dyn_block_system>
		cprintf("DYNAMIC BLOCK SYSTEM IS INITIALIZED\n");
  80144e:	83 ec 0c             	sub    $0xc,%esp
  801451:	68 10 3d 80 00       	push   $0x803d10
  801456:	e8 55 f2 ff ff       	call   8006b0 <cprintf>
  80145b:	83 c4 10             	add    $0x10,%esp
#if UHP_USE_BUDDY
		initialize_buddy();
		cprintf("BUDDY SYSTEM IS INITIALIZED\n");
#endif
		FirstTimeFlag = 0;
  80145e:	c7 05 04 40 80 00 00 	movl   $0x0,0x804004
  801465:	00 00 00 
	}
}
  801468:	90                   	nop
  801469:	c9                   	leave  
  80146a:	c3                   	ret    

0080146b <initialize_dyn_block_system>:

//=================================
// [1] INITIALIZE DYNAMIC ALLOCATOR:
//=================================
void initialize_dyn_block_system()
{
  80146b:	55                   	push   %ebp
  80146c:	89 e5                	mov    %esp,%ebp
  80146e:	83 ec 28             	sub    $0x28,%esp
	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] initialize_dyn_block_system
	// your code is here, remove the panic and write your code
	//panic("initialize_dyn_block_system() is not implemented yet...!!");

	LIST_INIT(&AllocMemBlocksList);
  801471:	c7 05 40 40 80 00 00 	movl   $0x0,0x804040
  801478:	00 00 00 
  80147b:	c7 05 44 40 80 00 00 	movl   $0x0,0x804044
  801482:	00 00 00 
  801485:	c7 05 4c 40 80 00 00 	movl   $0x0,0x80404c
  80148c:	00 00 00 
	LIST_INIT(&FreeMemBlocksList);
  80148f:	c7 05 38 41 80 00 00 	movl   $0x0,0x804138
  801496:	00 00 00 
  801499:	c7 05 3c 41 80 00 00 	movl   $0x0,0x80413c
  8014a0:	00 00 00 
  8014a3:	c7 05 44 41 80 00 00 	movl   $0x0,0x804144
  8014aa:	00 00 00 
	MAX_MEM_BLOCK_CNT = NUM_OF_UHEAP_PAGES;
  8014ad:	c7 05 20 41 80 00 00 	movl   $0x20000,0x804120
  8014b4:	00 02 00 
	MemBlockNodes = (void*)USER_DYN_BLKS_ARRAY;
  8014b7:	c7 45 f4 00 00 e0 7f 	movl   $0x7fe00000,-0xc(%ebp)
  8014be:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8014c1:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8014c6:	2d 00 10 00 00       	sub    $0x1000,%eax
  8014cb:	a3 50 40 80 00       	mov    %eax,0x804050
	int size_of_block = sizeof(struct MemBlock);
  8014d0:	c7 45 f0 10 00 00 00 	movl   $0x10,-0x10(%ebp)
	int size_all_struct = size_of_block*MAX_MEM_BLOCK_CNT;
  8014d7:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8014da:	a1 20 41 80 00       	mov    0x804120,%eax
  8014df:	0f af c2             	imul   %edx,%eax
  8014e2:	89 45 ec             	mov    %eax,-0x14(%ebp)
	size_all_struct = ROUNDUP(size_all_struct, PAGE_SIZE);
  8014e5:	c7 45 e8 00 10 00 00 	movl   $0x1000,-0x18(%ebp)
  8014ec:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8014ef:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8014f2:	01 d0                	add    %edx,%eax
  8014f4:	48                   	dec    %eax
  8014f5:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8014f8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8014fb:	ba 00 00 00 00       	mov    $0x0,%edx
  801500:	f7 75 e8             	divl   -0x18(%ebp)
  801503:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801506:	29 d0                	sub    %edx,%eax
  801508:	89 45 ec             	mov    %eax,-0x14(%ebp)
	sys_allocate_chunk(USER_DYN_BLKS_ARRAY, size_all_struct,PERM_USER| PERM_WRITEABLE);
  80150b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80150e:	c7 45 e0 00 00 e0 7f 	movl   $0x7fe00000,-0x20(%ebp)
  801515:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801518:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
  80151e:	81 ea 00 10 00 00    	sub    $0x1000,%edx
  801524:	83 ec 04             	sub    $0x4,%esp
  801527:	6a 06                	push   $0x6
  801529:	50                   	push   %eax
  80152a:	52                   	push   %edx
  80152b:	e8 a1 05 00 00       	call   801ad1 <sys_allocate_chunk>
  801530:	83 c4 10             	add    $0x10,%esp
	initialize_MemBlocksList(MAX_MEM_BLOCK_CNT);
  801533:	a1 20 41 80 00       	mov    0x804120,%eax
  801538:	83 ec 0c             	sub    $0xc,%esp
  80153b:	50                   	push   %eax
  80153c:	e8 16 0c 00 00       	call   802157 <initialize_MemBlocksList>
  801541:	83 c4 10             	add    $0x10,%esp
	struct MemBlock* ourBlock =LIST_LAST(&AvailableMemBlocksList);
  801544:	a1 4c 41 80 00       	mov    0x80414c,%eax
  801549:	89 45 dc             	mov    %eax,-0x24(%ebp)
	LIST_REMOVE(&AvailableMemBlocksList,ourBlock);
  80154c:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  801550:	75 14                	jne    801566 <initialize_dyn_block_system+0xfb>
  801552:	83 ec 04             	sub    $0x4,%esp
  801555:	68 35 3d 80 00       	push   $0x803d35
  80155a:	6a 2d                	push   $0x2d
  80155c:	68 53 3d 80 00       	push   $0x803d53
  801561:	e8 96 ee ff ff       	call   8003fc <_panic>
  801566:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801569:	8b 00                	mov    (%eax),%eax
  80156b:	85 c0                	test   %eax,%eax
  80156d:	74 10                	je     80157f <initialize_dyn_block_system+0x114>
  80156f:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801572:	8b 00                	mov    (%eax),%eax
  801574:	8b 55 dc             	mov    -0x24(%ebp),%edx
  801577:	8b 52 04             	mov    0x4(%edx),%edx
  80157a:	89 50 04             	mov    %edx,0x4(%eax)
  80157d:	eb 0b                	jmp    80158a <initialize_dyn_block_system+0x11f>
  80157f:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801582:	8b 40 04             	mov    0x4(%eax),%eax
  801585:	a3 4c 41 80 00       	mov    %eax,0x80414c
  80158a:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80158d:	8b 40 04             	mov    0x4(%eax),%eax
  801590:	85 c0                	test   %eax,%eax
  801592:	74 0f                	je     8015a3 <initialize_dyn_block_system+0x138>
  801594:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801597:	8b 40 04             	mov    0x4(%eax),%eax
  80159a:	8b 55 dc             	mov    -0x24(%ebp),%edx
  80159d:	8b 12                	mov    (%edx),%edx
  80159f:	89 10                	mov    %edx,(%eax)
  8015a1:	eb 0a                	jmp    8015ad <initialize_dyn_block_system+0x142>
  8015a3:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8015a6:	8b 00                	mov    (%eax),%eax
  8015a8:	a3 48 41 80 00       	mov    %eax,0x804148
  8015ad:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8015b0:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8015b6:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8015b9:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8015c0:	a1 54 41 80 00       	mov    0x804154,%eax
  8015c5:	48                   	dec    %eax
  8015c6:	a3 54 41 80 00       	mov    %eax,0x804154
	ourBlock->size = USER_HEAP_MAX-USER_HEAP_START;
  8015cb:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8015ce:	c7 40 0c 00 00 00 20 	movl   $0x20000000,0xc(%eax)
	ourBlock->sva=USER_HEAP_START;
  8015d5:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8015d8:	c7 40 08 00 00 00 80 	movl   $0x80000000,0x8(%eax)
	LIST_INSERT_TAIL(&FreeMemBlocksList, ourBlock);
  8015df:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  8015e3:	75 14                	jne    8015f9 <initialize_dyn_block_system+0x18e>
  8015e5:	83 ec 04             	sub    $0x4,%esp
  8015e8:	68 60 3d 80 00       	push   $0x803d60
  8015ed:	6a 30                	push   $0x30
  8015ef:	68 53 3d 80 00       	push   $0x803d53
  8015f4:	e8 03 ee ff ff       	call   8003fc <_panic>
  8015f9:	8b 15 3c 41 80 00    	mov    0x80413c,%edx
  8015ff:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801602:	89 50 04             	mov    %edx,0x4(%eax)
  801605:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801608:	8b 40 04             	mov    0x4(%eax),%eax
  80160b:	85 c0                	test   %eax,%eax
  80160d:	74 0c                	je     80161b <initialize_dyn_block_system+0x1b0>
  80160f:	a1 3c 41 80 00       	mov    0x80413c,%eax
  801614:	8b 55 dc             	mov    -0x24(%ebp),%edx
  801617:	89 10                	mov    %edx,(%eax)
  801619:	eb 08                	jmp    801623 <initialize_dyn_block_system+0x1b8>
  80161b:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80161e:	a3 38 41 80 00       	mov    %eax,0x804138
  801623:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801626:	a3 3c 41 80 00       	mov    %eax,0x80413c
  80162b:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80162e:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  801634:	a1 44 41 80 00       	mov    0x804144,%eax
  801639:	40                   	inc    %eax
  80163a:	a3 44 41 80 00       	mov    %eax,0x804144
	//[1] Initialize two lists (AllocMemBlocksList & FreeMemBlocksList) [Hint: use LIST_INIT()]
	//[2] Dynamically allocate the array of MemBlockNodes at VA USER_DYN_BLKS_ARRAY
	//	  (remember to set MAX_MEM_BLOCK_CNT with the chosen size of the array)
	//[3] Initialize AvailableMemBlocksList by filling it with the MemBlockNodes
	//[4] Insert a new MemBlock with the heap size into the FreeMemBlocksList
}
  80163f:	90                   	nop
  801640:	c9                   	leave  
  801641:	c3                   	ret    

00801642 <malloc>:
//=================================
// [2] ALLOCATE SPACE IN USER HEAP:
//=================================

void* malloc(uint32 size)
{
  801642:	55                   	push   %ebp
  801643:	89 e5                	mov    %esp,%ebp
  801645:	83 ec 18             	sub    $0x18,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801648:	e8 ed fd ff ff       	call   80143a <InitializeUHeap>
	if (size == 0) return NULL ;
  80164d:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801651:	75 07                	jne    80165a <malloc+0x18>
  801653:	b8 00 00 00 00       	mov    $0x0,%eax
  801658:	eb 67                	jmp    8016c1 <malloc+0x7f>

	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] malloc
	// your code is here, remove the panic and write your code
	//panic("malloc() is not implemented yet...!!");

	size = ROUNDUP(size, PAGE_SIZE);
  80165a:	c7 45 f4 00 10 00 00 	movl   $0x1000,-0xc(%ebp)
  801661:	8b 55 08             	mov    0x8(%ebp),%edx
  801664:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801667:	01 d0                	add    %edx,%eax
  801669:	48                   	dec    %eax
  80166a:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80166d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801670:	ba 00 00 00 00       	mov    $0x0,%edx
  801675:	f7 75 f4             	divl   -0xc(%ebp)
  801678:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80167b:	29 d0                	sub    %edx,%eax
  80167d:	89 45 08             	mov    %eax,0x8(%ebp)
	if(sys_isUHeapPlacementStrategyFIRSTFIT())
  801680:	e8 1a 08 00 00       	call   801e9f <sys_isUHeapPlacementStrategyFIRSTFIT>
  801685:	85 c0                	test   %eax,%eax
  801687:	74 33                	je     8016bc <malloc+0x7a>
	{
		struct MemBlock * myBlock = alloc_block_FF(size);
  801689:	83 ec 0c             	sub    $0xc,%esp
  80168c:	ff 75 08             	pushl  0x8(%ebp)
  80168f:	e8 0c 0e 00 00       	call   8024a0 <alloc_block_FF>
  801694:	83 c4 10             	add    $0x10,%esp
  801697:	89 45 ec             	mov    %eax,-0x14(%ebp)
		if(myBlock != NULL)
  80169a:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  80169e:	74 1c                	je     8016bc <malloc+0x7a>
		{
			insert_sorted_allocList(myBlock);
  8016a0:	83 ec 0c             	sub    $0xc,%esp
  8016a3:	ff 75 ec             	pushl  -0x14(%ebp)
  8016a6:	e8 07 0c 00 00       	call   8022b2 <insert_sorted_allocList>
  8016ab:	83 c4 10             	add    $0x10,%esp
			uint32 ptr = myBlock->sva;
  8016ae:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8016b1:	8b 40 08             	mov    0x8(%eax),%eax
  8016b4:	89 45 e8             	mov    %eax,-0x18(%ebp)
			return (void *)ptr;
  8016b7:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8016ba:	eb 05                	jmp    8016c1 <malloc+0x7f>
		}
	}
	return NULL;
  8016bc:	b8 00 00 00 00       	mov    $0x0,%eax
	//		to the required allocation size (space should be on 4 KB BOUNDARY)
	//	2) if no suitable space found, return NULL
	// 	3) Return pointer containing the virtual address of allocated space,
	//
	//Use sys_isUHeapPlacementStrategyFIRSTFIT()... to check the current strategy
}
  8016c1:	c9                   	leave  
  8016c2:	c3                   	ret    

008016c3 <free>:
//	We can use sys_free_user_mem(uint32 virtual_address, uint32 size); which
//		switches to the kernel mode, calls free_user_mem() in
//		"kern/mem/chunk_operations.c", then switch back to the user mode here
//	the free_user_mem function is empty, make sure to implement it.
void free(void* virtual_address)
{
  8016c3:	55                   	push   %ebp
  8016c4:	89 e5                	mov    %esp,%ebp
  8016c6:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] free
	// your code is here, remove the panic and write your code
	//panic("free() is not implemented yet...!!");

	uint32 virtualAddress = (uint32 )(virtual_address);
  8016c9:	8b 45 08             	mov    0x8(%ebp),%eax
  8016cc:	89 45 f4             	mov    %eax,-0xc(%ebp)
//	virtualAddress = ROUNDDOWN(virtualAddress, PAGE_SIZE);
	struct MemBlock * myBlock = find_block(&AllocMemBlocksList, virtualAddress);
  8016cf:	83 ec 08             	sub    $0x8,%esp
  8016d2:	ff 75 f4             	pushl  -0xc(%ebp)
  8016d5:	68 40 40 80 00       	push   $0x804040
  8016da:	e8 5b 0b 00 00       	call   80223a <find_block>
  8016df:	83 c4 10             	add    $0x10,%esp
  8016e2:	89 45 f0             	mov    %eax,-0x10(%ebp)
//	cprintf ("ptr sva at free user side = %x \n", myBlock->sva);
	sys_free_user_mem(virtualAddress, myBlock->size);
  8016e5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8016e8:	8b 40 0c             	mov    0xc(%eax),%eax
  8016eb:	83 ec 08             	sub    $0x8,%esp
  8016ee:	50                   	push   %eax
  8016ef:	ff 75 f4             	pushl  -0xc(%ebp)
  8016f2:	e8 a2 03 00 00       	call   801a99 <sys_free_user_mem>
  8016f7:	83 c4 10             	add    $0x10,%esp
	LIST_REMOVE(&AllocMemBlocksList, myBlock);
  8016fa:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8016fe:	75 14                	jne    801714 <free+0x51>
  801700:	83 ec 04             	sub    $0x4,%esp
  801703:	68 35 3d 80 00       	push   $0x803d35
  801708:	6a 76                	push   $0x76
  80170a:	68 53 3d 80 00       	push   $0x803d53
  80170f:	e8 e8 ec ff ff       	call   8003fc <_panic>
  801714:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801717:	8b 00                	mov    (%eax),%eax
  801719:	85 c0                	test   %eax,%eax
  80171b:	74 10                	je     80172d <free+0x6a>
  80171d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801720:	8b 00                	mov    (%eax),%eax
  801722:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801725:	8b 52 04             	mov    0x4(%edx),%edx
  801728:	89 50 04             	mov    %edx,0x4(%eax)
  80172b:	eb 0b                	jmp    801738 <free+0x75>
  80172d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801730:	8b 40 04             	mov    0x4(%eax),%eax
  801733:	a3 44 40 80 00       	mov    %eax,0x804044
  801738:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80173b:	8b 40 04             	mov    0x4(%eax),%eax
  80173e:	85 c0                	test   %eax,%eax
  801740:	74 0f                	je     801751 <free+0x8e>
  801742:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801745:	8b 40 04             	mov    0x4(%eax),%eax
  801748:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80174b:	8b 12                	mov    (%edx),%edx
  80174d:	89 10                	mov    %edx,(%eax)
  80174f:	eb 0a                	jmp    80175b <free+0x98>
  801751:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801754:	8b 00                	mov    (%eax),%eax
  801756:	a3 40 40 80 00       	mov    %eax,0x804040
  80175b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80175e:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  801764:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801767:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80176e:	a1 4c 40 80 00       	mov    0x80404c,%eax
  801773:	48                   	dec    %eax
  801774:	a3 4c 40 80 00       	mov    %eax,0x80404c
	insert_sorted_with_merge_freeList(myBlock);
  801779:	83 ec 0c             	sub    $0xc,%esp
  80177c:	ff 75 f0             	pushl  -0x10(%ebp)
  80177f:	e8 0b 14 00 00       	call   802b8f <insert_sorted_with_merge_freeList>
  801784:	83 c4 10             	add    $0x10,%esp

	//you should get the size of the given allocation using its address
	//you need to call sys_free_user_mem()
	//refer to the project presentation and documentation for details
}
  801787:	90                   	nop
  801788:	c9                   	leave  
  801789:	c3                   	ret    

0080178a <smalloc>:

//=================================
// [4] ALLOCATE SHARED VARIABLE:
//=================================
void* smalloc(char *sharedVarName, uint32 size, uint8 isWritable)
{
  80178a:	55                   	push   %ebp
  80178b:	89 e5                	mov    %esp,%ebp
  80178d:	83 ec 28             	sub    $0x28,%esp
  801790:	8b 45 10             	mov    0x10(%ebp),%eax
  801793:	88 45 e4             	mov    %al,-0x1c(%ebp)
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801796:	e8 9f fc ff ff       	call   80143a <InitializeUHeap>
	if (size == 0) return NULL ;
  80179b:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80179f:	75 0a                	jne    8017ab <smalloc+0x21>
  8017a1:	b8 00 00 00 00       	mov    $0x0,%eax
  8017a6:	e9 8d 00 00 00       	jmp    801838 <smalloc+0xae>

	//This function should find the space of the required range
	// * ON 4KB BOUNDARY **** //
	//Use sys_isUHeapPlacementStrategyFIRSTFIT() to check the current strategy

	size = ROUNDUP(size, PAGE_SIZE);
  8017ab:	c7 45 f4 00 10 00 00 	movl   $0x1000,-0xc(%ebp)
  8017b2:	8b 55 0c             	mov    0xc(%ebp),%edx
  8017b5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8017b8:	01 d0                	add    %edx,%eax
  8017ba:	48                   	dec    %eax
  8017bb:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8017be:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8017c1:	ba 00 00 00 00       	mov    $0x0,%edx
  8017c6:	f7 75 f4             	divl   -0xc(%ebp)
  8017c9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8017cc:	29 d0                	sub    %edx,%eax
  8017ce:	89 45 0c             	mov    %eax,0xc(%ebp)
		if(sys_isUHeapPlacementStrategyFIRSTFIT())
  8017d1:	e8 c9 06 00 00       	call   801e9f <sys_isUHeapPlacementStrategyFIRSTFIT>
  8017d6:	85 c0                	test   %eax,%eax
  8017d8:	74 59                	je     801833 <smalloc+0xa9>
		{
			struct MemBlock * v1=NULL;
  8017da:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
			v1= alloc_block_FF(size);
  8017e1:	83 ec 0c             	sub    $0xc,%esp
  8017e4:	ff 75 0c             	pushl  0xc(%ebp)
  8017e7:	e8 b4 0c 00 00       	call   8024a0 <alloc_block_FF>
  8017ec:	83 c4 10             	add    $0x10,%esp
  8017ef:	89 45 ec             	mov    %eax,-0x14(%ebp)
			if(v1==NULL)
  8017f2:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8017f6:	75 07                	jne    8017ff <smalloc+0x75>
			{
				return NULL;
  8017f8:	b8 00 00 00 00       	mov    $0x0,%eax
  8017fd:	eb 39                	jmp    801838 <smalloc+0xae>
			}
			else
			{
				int ret=sys_createSharedObject(sharedVarName,  size,  isWritable,(void*)v1->sva);
  8017ff:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801802:	8b 40 08             	mov    0x8(%eax),%eax
  801805:	89 c2                	mov    %eax,%edx
  801807:	0f b6 45 e4          	movzbl -0x1c(%ebp),%eax
  80180b:	52                   	push   %edx
  80180c:	50                   	push   %eax
  80180d:	ff 75 0c             	pushl  0xc(%ebp)
  801810:	ff 75 08             	pushl  0x8(%ebp)
  801813:	e8 0c 04 00 00       	call   801c24 <sys_createSharedObject>
  801818:	83 c4 10             	add    $0x10,%esp
  80181b:	89 45 e8             	mov    %eax,-0x18(%ebp)
				if(ret>=0)
  80181e:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  801822:	78 08                	js     80182c <smalloc+0xa2>
				{
					return (void*)v1->sva;
  801824:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801827:	8b 40 08             	mov    0x8(%eax),%eax
  80182a:	eb 0c                	jmp    801838 <smalloc+0xae>
				}
				else
				{
					return NULL;
  80182c:	b8 00 00 00 00       	mov    $0x0,%eax
  801831:	eb 05                	jmp    801838 <smalloc+0xae>
				}
			}

		}
		return NULL;
  801833:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801838:	c9                   	leave  
  801839:	c3                   	ret    

0080183a <sget>:

//========================================
// [5] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
  80183a:	55                   	push   %ebp
  80183b:	89 e5                	mov    %esp,%ebp
  80183d:	83 ec 18             	sub    $0x18,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801840:	e8 f5 fb ff ff       	call   80143a <InitializeUHeap>

	//This function should find the space for sharing the variable
	// *** ON 4KB BOUNDARY ******** //

	//Use sys_isUHeapPlacementStrategyFIRSTFIT() to check the current strategy
	int ret=sys_getSizeOfSharedObject(ownerEnvID,sharedVarName);
  801845:	83 ec 08             	sub    $0x8,%esp
  801848:	ff 75 0c             	pushl  0xc(%ebp)
  80184b:	ff 75 08             	pushl  0x8(%ebp)
  80184e:	e8 fb 03 00 00       	call   801c4e <sys_getSizeOfSharedObject>
  801853:	83 c4 10             	add    $0x10,%esp
  801856:	89 45 f4             	mov    %eax,-0xc(%ebp)
	if(ret==0)
  801859:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80185d:	75 07                	jne    801866 <sget+0x2c>
	{
		return NULL;
  80185f:	b8 00 00 00 00       	mov    $0x0,%eax
  801864:	eb 64                	jmp    8018ca <sget+0x90>
	}
	if(sys_isUHeapPlacementStrategyFIRSTFIT())
  801866:	e8 34 06 00 00       	call   801e9f <sys_isUHeapPlacementStrategyFIRSTFIT>
  80186b:	85 c0                	test   %eax,%eax
  80186d:	74 56                	je     8018c5 <sget+0x8b>
	{
		struct MemBlock * v1=NULL;
  80186f:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
		v1= alloc_block_FF(ret);
  801876:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801879:	83 ec 0c             	sub    $0xc,%esp
  80187c:	50                   	push   %eax
  80187d:	e8 1e 0c 00 00       	call   8024a0 <alloc_block_FF>
  801882:	83 c4 10             	add    $0x10,%esp
  801885:	89 45 f0             	mov    %eax,-0x10(%ebp)
		if(v1==NULL)
  801888:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80188c:	75 07                	jne    801895 <sget+0x5b>
		{
		return NULL;
  80188e:	b8 00 00 00 00       	mov    $0x0,%eax
  801893:	eb 35                	jmp    8018ca <sget+0x90>
	    }
		else
		{
			int ret1=sys_getSharedObject(ownerEnvID,sharedVarName,(void*)v1->sva);
  801895:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801898:	8b 40 08             	mov    0x8(%eax),%eax
  80189b:	83 ec 04             	sub    $0x4,%esp
  80189e:	50                   	push   %eax
  80189f:	ff 75 0c             	pushl  0xc(%ebp)
  8018a2:	ff 75 08             	pushl  0x8(%ebp)
  8018a5:	e8 c1 03 00 00       	call   801c6b <sys_getSharedObject>
  8018aa:	83 c4 10             	add    $0x10,%esp
  8018ad:	89 45 ec             	mov    %eax,-0x14(%ebp)
			if(ret1>=0)
  8018b0:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8018b4:	78 08                	js     8018be <sget+0x84>
			{
				return (void*)v1->sva;
  8018b6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8018b9:	8b 40 08             	mov    0x8(%eax),%eax
  8018bc:	eb 0c                	jmp    8018ca <sget+0x90>
			}
			else
			{
				return NULL;
  8018be:	b8 00 00 00 00       	mov    $0x0,%eax
  8018c3:	eb 05                	jmp    8018ca <sget+0x90>
			}
		}
	}
  return NULL;
  8018c5:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8018ca:	c9                   	leave  
  8018cb:	c3                   	ret    

008018cc <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  8018cc:	55                   	push   %ebp
  8018cd:	89 e5                	mov    %esp,%ebp
  8018cf:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  8018d2:	e8 63 fb ff ff       	call   80143a <InitializeUHeap>
	//==============================================================
	// [USER HEAP - USER SIDE] realloc
	// Write your code here, remove the panic and write your code
	panic("realloc() is not implemented yet...!!");
  8018d7:	83 ec 04             	sub    $0x4,%esp
  8018da:	68 84 3d 80 00       	push   $0x803d84
  8018df:	68 0e 01 00 00       	push   $0x10e
  8018e4:	68 53 3d 80 00       	push   $0x803d53
  8018e9:	e8 0e eb ff ff       	call   8003fc <_panic>

008018ee <sfree>:
//	use sys_freeSharedObject(...); which switches to the kernel mode,
//	calls freeSharedObject(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the freeSharedObject() function is empty, make sure to implement it.

void sfree(void* virtual_address)
{
  8018ee:	55                   	push   %ebp
  8018ef:	89 e5                	mov    %esp,%ebp
  8018f1:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT MS3 - BONUS] [SHARING - USER SIDE] sfree()

	// Write your code here, remove the panic and write your code
	panic("sfree() is not implemented yet...!!");
  8018f4:	83 ec 04             	sub    $0x4,%esp
  8018f7:	68 ac 3d 80 00       	push   $0x803dac
  8018fc:	68 22 01 00 00       	push   $0x122
  801901:	68 53 3d 80 00       	push   $0x803d53
  801906:	e8 f1 ea ff ff       	call   8003fc <_panic>

0080190b <expand>:

//==================================================================================//
//========================== MODIFICATION FUNCTIONS ================================//
//==================================================================================//
void expand(uint32 newSize)
{
  80190b:	55                   	push   %ebp
  80190c:	89 e5                	mov    %esp,%ebp
  80190e:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801911:	83 ec 04             	sub    $0x4,%esp
  801914:	68 d0 3d 80 00       	push   $0x803dd0
  801919:	68 2d 01 00 00       	push   $0x12d
  80191e:	68 53 3d 80 00       	push   $0x803d53
  801923:	e8 d4 ea ff ff       	call   8003fc <_panic>

00801928 <shrink>:

}
void shrink(uint32 newSize)
{
  801928:	55                   	push   %ebp
  801929:	89 e5                	mov    %esp,%ebp
  80192b:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  80192e:	83 ec 04             	sub    $0x4,%esp
  801931:	68 d0 3d 80 00       	push   $0x803dd0
  801936:	68 32 01 00 00       	push   $0x132
  80193b:	68 53 3d 80 00       	push   $0x803d53
  801940:	e8 b7 ea ff ff       	call   8003fc <_panic>

00801945 <freeHeap>:

}
void freeHeap(void* virtual_address)
{
  801945:	55                   	push   %ebp
  801946:	89 e5                	mov    %esp,%ebp
  801948:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  80194b:	83 ec 04             	sub    $0x4,%esp
  80194e:	68 d0 3d 80 00       	push   $0x803dd0
  801953:	68 37 01 00 00       	push   $0x137
  801958:	68 53 3d 80 00       	push   $0x803d53
  80195d:	e8 9a ea ff ff       	call   8003fc <_panic>

00801962 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  801962:	55                   	push   %ebp
  801963:	89 e5                	mov    %esp,%ebp
  801965:	57                   	push   %edi
  801966:	56                   	push   %esi
  801967:	53                   	push   %ebx
  801968:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  80196b:	8b 45 08             	mov    0x8(%ebp),%eax
  80196e:	8b 55 0c             	mov    0xc(%ebp),%edx
  801971:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801974:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801977:	8b 7d 18             	mov    0x18(%ebp),%edi
  80197a:	8b 75 1c             	mov    0x1c(%ebp),%esi
  80197d:	cd 30                	int    $0x30
  80197f:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  801982:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801985:	83 c4 10             	add    $0x10,%esp
  801988:	5b                   	pop    %ebx
  801989:	5e                   	pop    %esi
  80198a:	5f                   	pop    %edi
  80198b:	5d                   	pop    %ebp
  80198c:	c3                   	ret    

0080198d <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  80198d:	55                   	push   %ebp
  80198e:	89 e5                	mov    %esp,%ebp
  801990:	83 ec 04             	sub    $0x4,%esp
  801993:	8b 45 10             	mov    0x10(%ebp),%eax
  801996:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  801999:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  80199d:	8b 45 08             	mov    0x8(%ebp),%eax
  8019a0:	6a 00                	push   $0x0
  8019a2:	6a 00                	push   $0x0
  8019a4:	52                   	push   %edx
  8019a5:	ff 75 0c             	pushl  0xc(%ebp)
  8019a8:	50                   	push   %eax
  8019a9:	6a 00                	push   $0x0
  8019ab:	e8 b2 ff ff ff       	call   801962 <syscall>
  8019b0:	83 c4 18             	add    $0x18,%esp
}
  8019b3:	90                   	nop
  8019b4:	c9                   	leave  
  8019b5:	c3                   	ret    

008019b6 <sys_cgetc>:

int
sys_cgetc(void)
{
  8019b6:	55                   	push   %ebp
  8019b7:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  8019b9:	6a 00                	push   $0x0
  8019bb:	6a 00                	push   $0x0
  8019bd:	6a 00                	push   $0x0
  8019bf:	6a 00                	push   $0x0
  8019c1:	6a 00                	push   $0x0
  8019c3:	6a 01                	push   $0x1
  8019c5:	e8 98 ff ff ff       	call   801962 <syscall>
  8019ca:	83 c4 18             	add    $0x18,%esp
}
  8019cd:	c9                   	leave  
  8019ce:	c3                   	ret    

008019cf <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  8019cf:	55                   	push   %ebp
  8019d0:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  8019d2:	8b 55 0c             	mov    0xc(%ebp),%edx
  8019d5:	8b 45 08             	mov    0x8(%ebp),%eax
  8019d8:	6a 00                	push   $0x0
  8019da:	6a 00                	push   $0x0
  8019dc:	6a 00                	push   $0x0
  8019de:	52                   	push   %edx
  8019df:	50                   	push   %eax
  8019e0:	6a 05                	push   $0x5
  8019e2:	e8 7b ff ff ff       	call   801962 <syscall>
  8019e7:	83 c4 18             	add    $0x18,%esp
}
  8019ea:	c9                   	leave  
  8019eb:	c3                   	ret    

008019ec <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  8019ec:	55                   	push   %ebp
  8019ed:	89 e5                	mov    %esp,%ebp
  8019ef:	56                   	push   %esi
  8019f0:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  8019f1:	8b 75 18             	mov    0x18(%ebp),%esi
  8019f4:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8019f7:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8019fa:	8b 55 0c             	mov    0xc(%ebp),%edx
  8019fd:	8b 45 08             	mov    0x8(%ebp),%eax
  801a00:	56                   	push   %esi
  801a01:	53                   	push   %ebx
  801a02:	51                   	push   %ecx
  801a03:	52                   	push   %edx
  801a04:	50                   	push   %eax
  801a05:	6a 06                	push   $0x6
  801a07:	e8 56 ff ff ff       	call   801962 <syscall>
  801a0c:	83 c4 18             	add    $0x18,%esp
}
  801a0f:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801a12:	5b                   	pop    %ebx
  801a13:	5e                   	pop    %esi
  801a14:	5d                   	pop    %ebp
  801a15:	c3                   	ret    

00801a16 <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  801a16:	55                   	push   %ebp
  801a17:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  801a19:	8b 55 0c             	mov    0xc(%ebp),%edx
  801a1c:	8b 45 08             	mov    0x8(%ebp),%eax
  801a1f:	6a 00                	push   $0x0
  801a21:	6a 00                	push   $0x0
  801a23:	6a 00                	push   $0x0
  801a25:	52                   	push   %edx
  801a26:	50                   	push   %eax
  801a27:	6a 07                	push   $0x7
  801a29:	e8 34 ff ff ff       	call   801962 <syscall>
  801a2e:	83 c4 18             	add    $0x18,%esp
}
  801a31:	c9                   	leave  
  801a32:	c3                   	ret    

00801a33 <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  801a33:	55                   	push   %ebp
  801a34:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  801a36:	6a 00                	push   $0x0
  801a38:	6a 00                	push   $0x0
  801a3a:	6a 00                	push   $0x0
  801a3c:	ff 75 0c             	pushl  0xc(%ebp)
  801a3f:	ff 75 08             	pushl  0x8(%ebp)
  801a42:	6a 08                	push   $0x8
  801a44:	e8 19 ff ff ff       	call   801962 <syscall>
  801a49:	83 c4 18             	add    $0x18,%esp
}
  801a4c:	c9                   	leave  
  801a4d:	c3                   	ret    

00801a4e <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  801a4e:	55                   	push   %ebp
  801a4f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  801a51:	6a 00                	push   $0x0
  801a53:	6a 00                	push   $0x0
  801a55:	6a 00                	push   $0x0
  801a57:	6a 00                	push   $0x0
  801a59:	6a 00                	push   $0x0
  801a5b:	6a 09                	push   $0x9
  801a5d:	e8 00 ff ff ff       	call   801962 <syscall>
  801a62:	83 c4 18             	add    $0x18,%esp
}
  801a65:	c9                   	leave  
  801a66:	c3                   	ret    

00801a67 <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  801a67:	55                   	push   %ebp
  801a68:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  801a6a:	6a 00                	push   $0x0
  801a6c:	6a 00                	push   $0x0
  801a6e:	6a 00                	push   $0x0
  801a70:	6a 00                	push   $0x0
  801a72:	6a 00                	push   $0x0
  801a74:	6a 0a                	push   $0xa
  801a76:	e8 e7 fe ff ff       	call   801962 <syscall>
  801a7b:	83 c4 18             	add    $0x18,%esp
}
  801a7e:	c9                   	leave  
  801a7f:	c3                   	ret    

00801a80 <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  801a80:	55                   	push   %ebp
  801a81:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  801a83:	6a 00                	push   $0x0
  801a85:	6a 00                	push   $0x0
  801a87:	6a 00                	push   $0x0
  801a89:	6a 00                	push   $0x0
  801a8b:	6a 00                	push   $0x0
  801a8d:	6a 0b                	push   $0xb
  801a8f:	e8 ce fe ff ff       	call   801962 <syscall>
  801a94:	83 c4 18             	add    $0x18,%esp
}
  801a97:	c9                   	leave  
  801a98:	c3                   	ret    

00801a99 <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  801a99:	55                   	push   %ebp
  801a9a:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  801a9c:	6a 00                	push   $0x0
  801a9e:	6a 00                	push   $0x0
  801aa0:	6a 00                	push   $0x0
  801aa2:	ff 75 0c             	pushl  0xc(%ebp)
  801aa5:	ff 75 08             	pushl  0x8(%ebp)
  801aa8:	6a 0f                	push   $0xf
  801aaa:	e8 b3 fe ff ff       	call   801962 <syscall>
  801aaf:	83 c4 18             	add    $0x18,%esp
	return;
  801ab2:	90                   	nop
}
  801ab3:	c9                   	leave  
  801ab4:	c3                   	ret    

00801ab5 <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  801ab5:	55                   	push   %ebp
  801ab6:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  801ab8:	6a 00                	push   $0x0
  801aba:	6a 00                	push   $0x0
  801abc:	6a 00                	push   $0x0
  801abe:	ff 75 0c             	pushl  0xc(%ebp)
  801ac1:	ff 75 08             	pushl  0x8(%ebp)
  801ac4:	6a 10                	push   $0x10
  801ac6:	e8 97 fe ff ff       	call   801962 <syscall>
  801acb:	83 c4 18             	add    $0x18,%esp
	return ;
  801ace:	90                   	nop
}
  801acf:	c9                   	leave  
  801ad0:	c3                   	ret    

00801ad1 <sys_allocate_chunk>:

void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  801ad1:	55                   	push   %ebp
  801ad2:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  801ad4:	6a 00                	push   $0x0
  801ad6:	6a 00                	push   $0x0
  801ad8:	ff 75 10             	pushl  0x10(%ebp)
  801adb:	ff 75 0c             	pushl  0xc(%ebp)
  801ade:	ff 75 08             	pushl  0x8(%ebp)
  801ae1:	6a 11                	push   $0x11
  801ae3:	e8 7a fe ff ff       	call   801962 <syscall>
  801ae8:	83 c4 18             	add    $0x18,%esp
	return ;
  801aeb:	90                   	nop
}
  801aec:	c9                   	leave  
  801aed:	c3                   	ret    

00801aee <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  801aee:	55                   	push   %ebp
  801aef:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  801af1:	6a 00                	push   $0x0
  801af3:	6a 00                	push   $0x0
  801af5:	6a 00                	push   $0x0
  801af7:	6a 00                	push   $0x0
  801af9:	6a 00                	push   $0x0
  801afb:	6a 0c                	push   $0xc
  801afd:	e8 60 fe ff ff       	call   801962 <syscall>
  801b02:	83 c4 18             	add    $0x18,%esp
}
  801b05:	c9                   	leave  
  801b06:	c3                   	ret    

00801b07 <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  801b07:	55                   	push   %ebp
  801b08:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  801b0a:	6a 00                	push   $0x0
  801b0c:	6a 00                	push   $0x0
  801b0e:	6a 00                	push   $0x0
  801b10:	6a 00                	push   $0x0
  801b12:	ff 75 08             	pushl  0x8(%ebp)
  801b15:	6a 0d                	push   $0xd
  801b17:	e8 46 fe ff ff       	call   801962 <syscall>
  801b1c:	83 c4 18             	add    $0x18,%esp
}
  801b1f:	c9                   	leave  
  801b20:	c3                   	ret    

00801b21 <sys_scarce_memory>:

void sys_scarce_memory()
{
  801b21:	55                   	push   %ebp
  801b22:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  801b24:	6a 00                	push   $0x0
  801b26:	6a 00                	push   $0x0
  801b28:	6a 00                	push   $0x0
  801b2a:	6a 00                	push   $0x0
  801b2c:	6a 00                	push   $0x0
  801b2e:	6a 0e                	push   $0xe
  801b30:	e8 2d fe ff ff       	call   801962 <syscall>
  801b35:	83 c4 18             	add    $0x18,%esp
}
  801b38:	90                   	nop
  801b39:	c9                   	leave  
  801b3a:	c3                   	ret    

00801b3b <sys_disable_interrupt>:

//NEW !! 2012...
void
sys_disable_interrupt()
{
  801b3b:	55                   	push   %ebp
  801b3c:	89 e5                	mov    %esp,%ebp
	syscall(SYS_disableINTR,0, 0, 0, 0, 0);
  801b3e:	6a 00                	push   $0x0
  801b40:	6a 00                	push   $0x0
  801b42:	6a 00                	push   $0x0
  801b44:	6a 00                	push   $0x0
  801b46:	6a 00                	push   $0x0
  801b48:	6a 13                	push   $0x13
  801b4a:	e8 13 fe ff ff       	call   801962 <syscall>
  801b4f:	83 c4 18             	add    $0x18,%esp
}
  801b52:	90                   	nop
  801b53:	c9                   	leave  
  801b54:	c3                   	ret    

00801b55 <sys_enable_interrupt>:


void
sys_enable_interrupt()
{
  801b55:	55                   	push   %ebp
  801b56:	89 e5                	mov    %esp,%ebp
	syscall(SYS_enableINTR,0, 0, 0, 0, 0);
  801b58:	6a 00                	push   $0x0
  801b5a:	6a 00                	push   $0x0
  801b5c:	6a 00                	push   $0x0
  801b5e:	6a 00                	push   $0x0
  801b60:	6a 00                	push   $0x0
  801b62:	6a 14                	push   $0x14
  801b64:	e8 f9 fd ff ff       	call   801962 <syscall>
  801b69:	83 c4 18             	add    $0x18,%esp
}
  801b6c:	90                   	nop
  801b6d:	c9                   	leave  
  801b6e:	c3                   	ret    

00801b6f <sys_cputc>:


void
sys_cputc(const char c)
{
  801b6f:	55                   	push   %ebp
  801b70:	89 e5                	mov    %esp,%ebp
  801b72:	83 ec 04             	sub    $0x4,%esp
  801b75:	8b 45 08             	mov    0x8(%ebp),%eax
  801b78:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  801b7b:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801b7f:	6a 00                	push   $0x0
  801b81:	6a 00                	push   $0x0
  801b83:	6a 00                	push   $0x0
  801b85:	6a 00                	push   $0x0
  801b87:	50                   	push   %eax
  801b88:	6a 15                	push   $0x15
  801b8a:	e8 d3 fd ff ff       	call   801962 <syscall>
  801b8f:	83 c4 18             	add    $0x18,%esp
}
  801b92:	90                   	nop
  801b93:	c9                   	leave  
  801b94:	c3                   	ret    

00801b95 <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  801b95:	55                   	push   %ebp
  801b96:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  801b98:	6a 00                	push   $0x0
  801b9a:	6a 00                	push   $0x0
  801b9c:	6a 00                	push   $0x0
  801b9e:	6a 00                	push   $0x0
  801ba0:	6a 00                	push   $0x0
  801ba2:	6a 16                	push   $0x16
  801ba4:	e8 b9 fd ff ff       	call   801962 <syscall>
  801ba9:	83 c4 18             	add    $0x18,%esp
}
  801bac:	90                   	nop
  801bad:	c9                   	leave  
  801bae:	c3                   	ret    

00801baf <sys_createSemaphore>:

int
sys_createSemaphore(char* semaphoreName, uint32 initialValue)
{
  801baf:	55                   	push   %ebp
  801bb0:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_semaphore,(uint32)semaphoreName, (uint32)initialValue, 0, 0, 0);
  801bb2:	8b 45 08             	mov    0x8(%ebp),%eax
  801bb5:	6a 00                	push   $0x0
  801bb7:	6a 00                	push   $0x0
  801bb9:	6a 00                	push   $0x0
  801bbb:	ff 75 0c             	pushl  0xc(%ebp)
  801bbe:	50                   	push   %eax
  801bbf:	6a 17                	push   $0x17
  801bc1:	e8 9c fd ff ff       	call   801962 <syscall>
  801bc6:	83 c4 18             	add    $0x18,%esp
}
  801bc9:	c9                   	leave  
  801bca:	c3                   	ret    

00801bcb <sys_getSemaphoreValue>:

int
sys_getSemaphoreValue(int32 ownerEnvID, char* semaphoreName)
{
  801bcb:	55                   	push   %ebp
  801bcc:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_semaphore_value,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801bce:	8b 55 0c             	mov    0xc(%ebp),%edx
  801bd1:	8b 45 08             	mov    0x8(%ebp),%eax
  801bd4:	6a 00                	push   $0x0
  801bd6:	6a 00                	push   $0x0
  801bd8:	6a 00                	push   $0x0
  801bda:	52                   	push   %edx
  801bdb:	50                   	push   %eax
  801bdc:	6a 1a                	push   $0x1a
  801bde:	e8 7f fd ff ff       	call   801962 <syscall>
  801be3:	83 c4 18             	add    $0x18,%esp
}
  801be6:	c9                   	leave  
  801be7:	c3                   	ret    

00801be8 <sys_waitSemaphore>:

void
sys_waitSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  801be8:	55                   	push   %ebp
  801be9:	89 e5                	mov    %esp,%ebp
	syscall(SYS_wait_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801beb:	8b 55 0c             	mov    0xc(%ebp),%edx
  801bee:	8b 45 08             	mov    0x8(%ebp),%eax
  801bf1:	6a 00                	push   $0x0
  801bf3:	6a 00                	push   $0x0
  801bf5:	6a 00                	push   $0x0
  801bf7:	52                   	push   %edx
  801bf8:	50                   	push   %eax
  801bf9:	6a 18                	push   $0x18
  801bfb:	e8 62 fd ff ff       	call   801962 <syscall>
  801c00:	83 c4 18             	add    $0x18,%esp
}
  801c03:	90                   	nop
  801c04:	c9                   	leave  
  801c05:	c3                   	ret    

00801c06 <sys_signalSemaphore>:

void
sys_signalSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  801c06:	55                   	push   %ebp
  801c07:	89 e5                	mov    %esp,%ebp
	syscall(SYS_signal_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801c09:	8b 55 0c             	mov    0xc(%ebp),%edx
  801c0c:	8b 45 08             	mov    0x8(%ebp),%eax
  801c0f:	6a 00                	push   $0x0
  801c11:	6a 00                	push   $0x0
  801c13:	6a 00                	push   $0x0
  801c15:	52                   	push   %edx
  801c16:	50                   	push   %eax
  801c17:	6a 19                	push   $0x19
  801c19:	e8 44 fd ff ff       	call   801962 <syscall>
  801c1e:	83 c4 18             	add    $0x18,%esp
}
  801c21:	90                   	nop
  801c22:	c9                   	leave  
  801c23:	c3                   	ret    

00801c24 <sys_createSharedObject>:

int
sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  801c24:	55                   	push   %ebp
  801c25:	89 e5                	mov    %esp,%ebp
  801c27:	83 ec 04             	sub    $0x4,%esp
  801c2a:	8b 45 10             	mov    0x10(%ebp),%eax
  801c2d:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  801c30:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801c33:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801c37:	8b 45 08             	mov    0x8(%ebp),%eax
  801c3a:	6a 00                	push   $0x0
  801c3c:	51                   	push   %ecx
  801c3d:	52                   	push   %edx
  801c3e:	ff 75 0c             	pushl  0xc(%ebp)
  801c41:	50                   	push   %eax
  801c42:	6a 1b                	push   $0x1b
  801c44:	e8 19 fd ff ff       	call   801962 <syscall>
  801c49:	83 c4 18             	add    $0x18,%esp
}
  801c4c:	c9                   	leave  
  801c4d:	c3                   	ret    

00801c4e <sys_getSizeOfSharedObject>:

//2017:
int
sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  801c4e:	55                   	push   %ebp
  801c4f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  801c51:	8b 55 0c             	mov    0xc(%ebp),%edx
  801c54:	8b 45 08             	mov    0x8(%ebp),%eax
  801c57:	6a 00                	push   $0x0
  801c59:	6a 00                	push   $0x0
  801c5b:	6a 00                	push   $0x0
  801c5d:	52                   	push   %edx
  801c5e:	50                   	push   %eax
  801c5f:	6a 1c                	push   $0x1c
  801c61:	e8 fc fc ff ff       	call   801962 <syscall>
  801c66:	83 c4 18             	add    $0x18,%esp
}
  801c69:	c9                   	leave  
  801c6a:	c3                   	ret    

00801c6b <sys_getSharedObject>:
//==========

int
sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  801c6b:	55                   	push   %ebp
  801c6c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  801c6e:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801c71:	8b 55 0c             	mov    0xc(%ebp),%edx
  801c74:	8b 45 08             	mov    0x8(%ebp),%eax
  801c77:	6a 00                	push   $0x0
  801c79:	6a 00                	push   $0x0
  801c7b:	51                   	push   %ecx
  801c7c:	52                   	push   %edx
  801c7d:	50                   	push   %eax
  801c7e:	6a 1d                	push   $0x1d
  801c80:	e8 dd fc ff ff       	call   801962 <syscall>
  801c85:	83 c4 18             	add    $0x18,%esp
}
  801c88:	c9                   	leave  
  801c89:	c3                   	ret    

00801c8a <sys_freeSharedObject>:

int
sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  801c8a:	55                   	push   %ebp
  801c8b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  801c8d:	8b 55 0c             	mov    0xc(%ebp),%edx
  801c90:	8b 45 08             	mov    0x8(%ebp),%eax
  801c93:	6a 00                	push   $0x0
  801c95:	6a 00                	push   $0x0
  801c97:	6a 00                	push   $0x0
  801c99:	52                   	push   %edx
  801c9a:	50                   	push   %eax
  801c9b:	6a 1e                	push   $0x1e
  801c9d:	e8 c0 fc ff ff       	call   801962 <syscall>
  801ca2:	83 c4 18             	add    $0x18,%esp
}
  801ca5:	c9                   	leave  
  801ca6:	c3                   	ret    

00801ca7 <sys_getMaxShares>:

uint32 	sys_getMaxShares()
{
  801ca7:	55                   	push   %ebp
  801ca8:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_max_shares,0, 0, 0, 0, 0);
  801caa:	6a 00                	push   $0x0
  801cac:	6a 00                	push   $0x0
  801cae:	6a 00                	push   $0x0
  801cb0:	6a 00                	push   $0x0
  801cb2:	6a 00                	push   $0x0
  801cb4:	6a 1f                	push   $0x1f
  801cb6:	e8 a7 fc ff ff       	call   801962 <syscall>
  801cbb:	83 c4 18             	add    $0x18,%esp
}
  801cbe:	c9                   	leave  
  801cbf:	c3                   	ret    

00801cc0 <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  801cc0:	55                   	push   %ebp
  801cc1:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  801cc3:	8b 45 08             	mov    0x8(%ebp),%eax
  801cc6:	6a 00                	push   $0x0
  801cc8:	ff 75 14             	pushl  0x14(%ebp)
  801ccb:	ff 75 10             	pushl  0x10(%ebp)
  801cce:	ff 75 0c             	pushl  0xc(%ebp)
  801cd1:	50                   	push   %eax
  801cd2:	6a 20                	push   $0x20
  801cd4:	e8 89 fc ff ff       	call   801962 <syscall>
  801cd9:	83 c4 18             	add    $0x18,%esp
}
  801cdc:	c9                   	leave  
  801cdd:	c3                   	ret    

00801cde <sys_run_env>:

void
sys_run_env(int32 envId)
{
  801cde:	55                   	push   %ebp
  801cdf:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  801ce1:	8b 45 08             	mov    0x8(%ebp),%eax
  801ce4:	6a 00                	push   $0x0
  801ce6:	6a 00                	push   $0x0
  801ce8:	6a 00                	push   $0x0
  801cea:	6a 00                	push   $0x0
  801cec:	50                   	push   %eax
  801ced:	6a 21                	push   $0x21
  801cef:	e8 6e fc ff ff       	call   801962 <syscall>
  801cf4:	83 c4 18             	add    $0x18,%esp
}
  801cf7:	90                   	nop
  801cf8:	c9                   	leave  
  801cf9:	c3                   	ret    

00801cfa <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  801cfa:	55                   	push   %ebp
  801cfb:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  801cfd:	8b 45 08             	mov    0x8(%ebp),%eax
  801d00:	6a 00                	push   $0x0
  801d02:	6a 00                	push   $0x0
  801d04:	6a 00                	push   $0x0
  801d06:	6a 00                	push   $0x0
  801d08:	50                   	push   %eax
  801d09:	6a 22                	push   $0x22
  801d0b:	e8 52 fc ff ff       	call   801962 <syscall>
  801d10:	83 c4 18             	add    $0x18,%esp
}
  801d13:	c9                   	leave  
  801d14:	c3                   	ret    

00801d15 <sys_getenvid>:

int32 sys_getenvid(void)
{
  801d15:	55                   	push   %ebp
  801d16:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  801d18:	6a 00                	push   $0x0
  801d1a:	6a 00                	push   $0x0
  801d1c:	6a 00                	push   $0x0
  801d1e:	6a 00                	push   $0x0
  801d20:	6a 00                	push   $0x0
  801d22:	6a 02                	push   $0x2
  801d24:	e8 39 fc ff ff       	call   801962 <syscall>
  801d29:	83 c4 18             	add    $0x18,%esp
}
  801d2c:	c9                   	leave  
  801d2d:	c3                   	ret    

00801d2e <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  801d2e:	55                   	push   %ebp
  801d2f:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  801d31:	6a 00                	push   $0x0
  801d33:	6a 00                	push   $0x0
  801d35:	6a 00                	push   $0x0
  801d37:	6a 00                	push   $0x0
  801d39:	6a 00                	push   $0x0
  801d3b:	6a 03                	push   $0x3
  801d3d:	e8 20 fc ff ff       	call   801962 <syscall>
  801d42:	83 c4 18             	add    $0x18,%esp
}
  801d45:	c9                   	leave  
  801d46:	c3                   	ret    

00801d47 <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  801d47:	55                   	push   %ebp
  801d48:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  801d4a:	6a 00                	push   $0x0
  801d4c:	6a 00                	push   $0x0
  801d4e:	6a 00                	push   $0x0
  801d50:	6a 00                	push   $0x0
  801d52:	6a 00                	push   $0x0
  801d54:	6a 04                	push   $0x4
  801d56:	e8 07 fc ff ff       	call   801962 <syscall>
  801d5b:	83 c4 18             	add    $0x18,%esp
}
  801d5e:	c9                   	leave  
  801d5f:	c3                   	ret    

00801d60 <sys_exit_env>:


void sys_exit_env(void)
{
  801d60:	55                   	push   %ebp
  801d61:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  801d63:	6a 00                	push   $0x0
  801d65:	6a 00                	push   $0x0
  801d67:	6a 00                	push   $0x0
  801d69:	6a 00                	push   $0x0
  801d6b:	6a 00                	push   $0x0
  801d6d:	6a 23                	push   $0x23
  801d6f:	e8 ee fb ff ff       	call   801962 <syscall>
  801d74:	83 c4 18             	add    $0x18,%esp
}
  801d77:	90                   	nop
  801d78:	c9                   	leave  
  801d79:	c3                   	ret    

00801d7a <sys_get_virtual_time>:


struct uint64
sys_get_virtual_time()
{
  801d7a:	55                   	push   %ebp
  801d7b:	89 e5                	mov    %esp,%ebp
  801d7d:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  801d80:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801d83:	8d 50 04             	lea    0x4(%eax),%edx
  801d86:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801d89:	6a 00                	push   $0x0
  801d8b:	6a 00                	push   $0x0
  801d8d:	6a 00                	push   $0x0
  801d8f:	52                   	push   %edx
  801d90:	50                   	push   %eax
  801d91:	6a 24                	push   $0x24
  801d93:	e8 ca fb ff ff       	call   801962 <syscall>
  801d98:	83 c4 18             	add    $0x18,%esp
	return result;
  801d9b:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801d9e:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801da1:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801da4:	89 01                	mov    %eax,(%ecx)
  801da6:	89 51 04             	mov    %edx,0x4(%ecx)
}
  801da9:	8b 45 08             	mov    0x8(%ebp),%eax
  801dac:	c9                   	leave  
  801dad:	c2 04 00             	ret    $0x4

00801db0 <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  801db0:	55                   	push   %ebp
  801db1:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  801db3:	6a 00                	push   $0x0
  801db5:	6a 00                	push   $0x0
  801db7:	ff 75 10             	pushl  0x10(%ebp)
  801dba:	ff 75 0c             	pushl  0xc(%ebp)
  801dbd:	ff 75 08             	pushl  0x8(%ebp)
  801dc0:	6a 12                	push   $0x12
  801dc2:	e8 9b fb ff ff       	call   801962 <syscall>
  801dc7:	83 c4 18             	add    $0x18,%esp
	return ;
  801dca:	90                   	nop
}
  801dcb:	c9                   	leave  
  801dcc:	c3                   	ret    

00801dcd <sys_rcr2>:
uint32 sys_rcr2()
{
  801dcd:	55                   	push   %ebp
  801dce:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  801dd0:	6a 00                	push   $0x0
  801dd2:	6a 00                	push   $0x0
  801dd4:	6a 00                	push   $0x0
  801dd6:	6a 00                	push   $0x0
  801dd8:	6a 00                	push   $0x0
  801dda:	6a 25                	push   $0x25
  801ddc:	e8 81 fb ff ff       	call   801962 <syscall>
  801de1:	83 c4 18             	add    $0x18,%esp
}
  801de4:	c9                   	leave  
  801de5:	c3                   	ret    

00801de6 <sys_bypassPageFault>:
void sys_bypassPageFault(uint8 instrLength)
{
  801de6:	55                   	push   %ebp
  801de7:	89 e5                	mov    %esp,%ebp
  801de9:	83 ec 04             	sub    $0x4,%esp
  801dec:	8b 45 08             	mov    0x8(%ebp),%eax
  801def:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  801df2:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  801df6:	6a 00                	push   $0x0
  801df8:	6a 00                	push   $0x0
  801dfa:	6a 00                	push   $0x0
  801dfc:	6a 00                	push   $0x0
  801dfe:	50                   	push   %eax
  801dff:	6a 26                	push   $0x26
  801e01:	e8 5c fb ff ff       	call   801962 <syscall>
  801e06:	83 c4 18             	add    $0x18,%esp
	return ;
  801e09:	90                   	nop
}
  801e0a:	c9                   	leave  
  801e0b:	c3                   	ret    

00801e0c <rsttst>:
void rsttst()
{
  801e0c:	55                   	push   %ebp
  801e0d:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  801e0f:	6a 00                	push   $0x0
  801e11:	6a 00                	push   $0x0
  801e13:	6a 00                	push   $0x0
  801e15:	6a 00                	push   $0x0
  801e17:	6a 00                	push   $0x0
  801e19:	6a 28                	push   $0x28
  801e1b:	e8 42 fb ff ff       	call   801962 <syscall>
  801e20:	83 c4 18             	add    $0x18,%esp
	return ;
  801e23:	90                   	nop
}
  801e24:	c9                   	leave  
  801e25:	c3                   	ret    

00801e26 <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  801e26:	55                   	push   %ebp
  801e27:	89 e5                	mov    %esp,%ebp
  801e29:	83 ec 04             	sub    $0x4,%esp
  801e2c:	8b 45 14             	mov    0x14(%ebp),%eax
  801e2f:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  801e32:	8b 55 18             	mov    0x18(%ebp),%edx
  801e35:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801e39:	52                   	push   %edx
  801e3a:	50                   	push   %eax
  801e3b:	ff 75 10             	pushl  0x10(%ebp)
  801e3e:	ff 75 0c             	pushl  0xc(%ebp)
  801e41:	ff 75 08             	pushl  0x8(%ebp)
  801e44:	6a 27                	push   $0x27
  801e46:	e8 17 fb ff ff       	call   801962 <syscall>
  801e4b:	83 c4 18             	add    $0x18,%esp
	return ;
  801e4e:	90                   	nop
}
  801e4f:	c9                   	leave  
  801e50:	c3                   	ret    

00801e51 <chktst>:
void chktst(uint32 n)
{
  801e51:	55                   	push   %ebp
  801e52:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  801e54:	6a 00                	push   $0x0
  801e56:	6a 00                	push   $0x0
  801e58:	6a 00                	push   $0x0
  801e5a:	6a 00                	push   $0x0
  801e5c:	ff 75 08             	pushl  0x8(%ebp)
  801e5f:	6a 29                	push   $0x29
  801e61:	e8 fc fa ff ff       	call   801962 <syscall>
  801e66:	83 c4 18             	add    $0x18,%esp
	return ;
  801e69:	90                   	nop
}
  801e6a:	c9                   	leave  
  801e6b:	c3                   	ret    

00801e6c <inctst>:

void inctst()
{
  801e6c:	55                   	push   %ebp
  801e6d:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  801e6f:	6a 00                	push   $0x0
  801e71:	6a 00                	push   $0x0
  801e73:	6a 00                	push   $0x0
  801e75:	6a 00                	push   $0x0
  801e77:	6a 00                	push   $0x0
  801e79:	6a 2a                	push   $0x2a
  801e7b:	e8 e2 fa ff ff       	call   801962 <syscall>
  801e80:	83 c4 18             	add    $0x18,%esp
	return ;
  801e83:	90                   	nop
}
  801e84:	c9                   	leave  
  801e85:	c3                   	ret    

00801e86 <gettst>:
uint32 gettst()
{
  801e86:	55                   	push   %ebp
  801e87:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  801e89:	6a 00                	push   $0x0
  801e8b:	6a 00                	push   $0x0
  801e8d:	6a 00                	push   $0x0
  801e8f:	6a 00                	push   $0x0
  801e91:	6a 00                	push   $0x0
  801e93:	6a 2b                	push   $0x2b
  801e95:	e8 c8 fa ff ff       	call   801962 <syscall>
  801e9a:	83 c4 18             	add    $0x18,%esp
}
  801e9d:	c9                   	leave  
  801e9e:	c3                   	ret    

00801e9f <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  801e9f:	55                   	push   %ebp
  801ea0:	89 e5                	mov    %esp,%ebp
  801ea2:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801ea5:	6a 00                	push   $0x0
  801ea7:	6a 00                	push   $0x0
  801ea9:	6a 00                	push   $0x0
  801eab:	6a 00                	push   $0x0
  801ead:	6a 00                	push   $0x0
  801eaf:	6a 2c                	push   $0x2c
  801eb1:	e8 ac fa ff ff       	call   801962 <syscall>
  801eb6:	83 c4 18             	add    $0x18,%esp
  801eb9:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  801ebc:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  801ec0:	75 07                	jne    801ec9 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  801ec2:	b8 01 00 00 00       	mov    $0x1,%eax
  801ec7:	eb 05                	jmp    801ece <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  801ec9:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801ece:	c9                   	leave  
  801ecf:	c3                   	ret    

00801ed0 <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  801ed0:	55                   	push   %ebp
  801ed1:	89 e5                	mov    %esp,%ebp
  801ed3:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801ed6:	6a 00                	push   $0x0
  801ed8:	6a 00                	push   $0x0
  801eda:	6a 00                	push   $0x0
  801edc:	6a 00                	push   $0x0
  801ede:	6a 00                	push   $0x0
  801ee0:	6a 2c                	push   $0x2c
  801ee2:	e8 7b fa ff ff       	call   801962 <syscall>
  801ee7:	83 c4 18             	add    $0x18,%esp
  801eea:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  801eed:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  801ef1:	75 07                	jne    801efa <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  801ef3:	b8 01 00 00 00       	mov    $0x1,%eax
  801ef8:	eb 05                	jmp    801eff <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  801efa:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801eff:	c9                   	leave  
  801f00:	c3                   	ret    

00801f01 <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  801f01:	55                   	push   %ebp
  801f02:	89 e5                	mov    %esp,%ebp
  801f04:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801f07:	6a 00                	push   $0x0
  801f09:	6a 00                	push   $0x0
  801f0b:	6a 00                	push   $0x0
  801f0d:	6a 00                	push   $0x0
  801f0f:	6a 00                	push   $0x0
  801f11:	6a 2c                	push   $0x2c
  801f13:	e8 4a fa ff ff       	call   801962 <syscall>
  801f18:	83 c4 18             	add    $0x18,%esp
  801f1b:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  801f1e:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  801f22:	75 07                	jne    801f2b <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  801f24:	b8 01 00 00 00       	mov    $0x1,%eax
  801f29:	eb 05                	jmp    801f30 <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  801f2b:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801f30:	c9                   	leave  
  801f31:	c3                   	ret    

00801f32 <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  801f32:	55                   	push   %ebp
  801f33:	89 e5                	mov    %esp,%ebp
  801f35:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801f38:	6a 00                	push   $0x0
  801f3a:	6a 00                	push   $0x0
  801f3c:	6a 00                	push   $0x0
  801f3e:	6a 00                	push   $0x0
  801f40:	6a 00                	push   $0x0
  801f42:	6a 2c                	push   $0x2c
  801f44:	e8 19 fa ff ff       	call   801962 <syscall>
  801f49:	83 c4 18             	add    $0x18,%esp
  801f4c:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  801f4f:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  801f53:	75 07                	jne    801f5c <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  801f55:	b8 01 00 00 00       	mov    $0x1,%eax
  801f5a:	eb 05                	jmp    801f61 <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  801f5c:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801f61:	c9                   	leave  
  801f62:	c3                   	ret    

00801f63 <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  801f63:	55                   	push   %ebp
  801f64:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  801f66:	6a 00                	push   $0x0
  801f68:	6a 00                	push   $0x0
  801f6a:	6a 00                	push   $0x0
  801f6c:	6a 00                	push   $0x0
  801f6e:	ff 75 08             	pushl  0x8(%ebp)
  801f71:	6a 2d                	push   $0x2d
  801f73:	e8 ea f9 ff ff       	call   801962 <syscall>
  801f78:	83 c4 18             	add    $0x18,%esp
	return ;
  801f7b:	90                   	nop
}
  801f7c:	c9                   	leave  
  801f7d:	c3                   	ret    

00801f7e <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  801f7e:	55                   	push   %ebp
  801f7f:	89 e5                	mov    %esp,%ebp
  801f81:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  801f82:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801f85:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801f88:	8b 55 0c             	mov    0xc(%ebp),%edx
  801f8b:	8b 45 08             	mov    0x8(%ebp),%eax
  801f8e:	6a 00                	push   $0x0
  801f90:	53                   	push   %ebx
  801f91:	51                   	push   %ecx
  801f92:	52                   	push   %edx
  801f93:	50                   	push   %eax
  801f94:	6a 2e                	push   $0x2e
  801f96:	e8 c7 f9 ff ff       	call   801962 <syscall>
  801f9b:	83 c4 18             	add    $0x18,%esp
}
  801f9e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801fa1:	c9                   	leave  
  801fa2:	c3                   	ret    

00801fa3 <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  801fa3:	55                   	push   %ebp
  801fa4:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  801fa6:	8b 55 0c             	mov    0xc(%ebp),%edx
  801fa9:	8b 45 08             	mov    0x8(%ebp),%eax
  801fac:	6a 00                	push   $0x0
  801fae:	6a 00                	push   $0x0
  801fb0:	6a 00                	push   $0x0
  801fb2:	52                   	push   %edx
  801fb3:	50                   	push   %eax
  801fb4:	6a 2f                	push   $0x2f
  801fb6:	e8 a7 f9 ff ff       	call   801962 <syscall>
  801fbb:	83 c4 18             	add    $0x18,%esp
}
  801fbe:	c9                   	leave  
  801fbf:	c3                   	ret    

00801fc0 <print_mem_block_lists>:
//===========================
// PRINT MEM BLOCK LISTS:
//===========================

void print_mem_block_lists()
{
  801fc0:	55                   	push   %ebp
  801fc1:	89 e5                	mov    %esp,%ebp
  801fc3:	83 ec 18             	sub    $0x18,%esp
	cprintf("\n=========================================\n");
  801fc6:	83 ec 0c             	sub    $0xc,%esp
  801fc9:	68 e0 3d 80 00       	push   $0x803de0
  801fce:	e8 dd e6 ff ff       	call   8006b0 <cprintf>
  801fd3:	83 c4 10             	add    $0x10,%esp
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
  801fd6:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nFreeMemBlocksList:\n");
  801fdd:	83 ec 0c             	sub    $0xc,%esp
  801fe0:	68 0c 3e 80 00       	push   $0x803e0c
  801fe5:	e8 c6 e6 ff ff       	call   8006b0 <cprintf>
  801fea:	83 c4 10             	add    $0x10,%esp
	uint8 sorted = 1 ;
  801fed:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &FreeMemBlocksList)
  801ff1:	a1 38 41 80 00       	mov    0x804138,%eax
  801ff6:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801ff9:	eb 56                	jmp    802051 <print_mem_block_lists+0x91>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  801ffb:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801fff:	74 1c                	je     80201d <print_mem_block_lists+0x5d>
  802001:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802004:	8b 50 08             	mov    0x8(%eax),%edx
  802007:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80200a:	8b 48 08             	mov    0x8(%eax),%ecx
  80200d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802010:	8b 40 0c             	mov    0xc(%eax),%eax
  802013:	01 c8                	add    %ecx,%eax
  802015:	39 c2                	cmp    %eax,%edx
  802017:	73 04                	jae    80201d <print_mem_block_lists+0x5d>
			sorted = 0 ;
  802019:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  80201d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802020:	8b 50 08             	mov    0x8(%eax),%edx
  802023:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802026:	8b 40 0c             	mov    0xc(%eax),%eax
  802029:	01 c2                	add    %eax,%edx
  80202b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80202e:	8b 40 08             	mov    0x8(%eax),%eax
  802031:	83 ec 04             	sub    $0x4,%esp
  802034:	52                   	push   %edx
  802035:	50                   	push   %eax
  802036:	68 21 3e 80 00       	push   $0x803e21
  80203b:	e8 70 e6 ff ff       	call   8006b0 <cprintf>
  802040:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  802043:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802046:	89 45 f0             	mov    %eax,-0x10(%ebp)
	cprintf("\n=========================================\n");
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
	cprintf("\nFreeMemBlocksList:\n");
	uint8 sorted = 1 ;
	LIST_FOREACH(blk, &FreeMemBlocksList)
  802049:	a1 40 41 80 00       	mov    0x804140,%eax
  80204e:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802051:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802055:	74 07                	je     80205e <print_mem_block_lists+0x9e>
  802057:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80205a:	8b 00                	mov    (%eax),%eax
  80205c:	eb 05                	jmp    802063 <print_mem_block_lists+0xa3>
  80205e:	b8 00 00 00 00       	mov    $0x0,%eax
  802063:	a3 40 41 80 00       	mov    %eax,0x804140
  802068:	a1 40 41 80 00       	mov    0x804140,%eax
  80206d:	85 c0                	test   %eax,%eax
  80206f:	75 8a                	jne    801ffb <print_mem_block_lists+0x3b>
  802071:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802075:	75 84                	jne    801ffb <print_mem_block_lists+0x3b>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;
  802077:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  80207b:	75 10                	jne    80208d <print_mem_block_lists+0xcd>
  80207d:	83 ec 0c             	sub    $0xc,%esp
  802080:	68 30 3e 80 00       	push   $0x803e30
  802085:	e8 26 e6 ff ff       	call   8006b0 <cprintf>
  80208a:	83 c4 10             	add    $0x10,%esp

	lastBlk = NULL ;
  80208d:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nAllocMemBlocksList:\n");
  802094:	83 ec 0c             	sub    $0xc,%esp
  802097:	68 54 3e 80 00       	push   $0x803e54
  80209c:	e8 0f e6 ff ff       	call   8006b0 <cprintf>
  8020a1:	83 c4 10             	add    $0x10,%esp
	sorted = 1 ;
  8020a4:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &AllocMemBlocksList)
  8020a8:	a1 40 40 80 00       	mov    0x804040,%eax
  8020ad:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8020b0:	eb 56                	jmp    802108 <print_mem_block_lists+0x148>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  8020b2:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8020b6:	74 1c                	je     8020d4 <print_mem_block_lists+0x114>
  8020b8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8020bb:	8b 50 08             	mov    0x8(%eax),%edx
  8020be:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8020c1:	8b 48 08             	mov    0x8(%eax),%ecx
  8020c4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8020c7:	8b 40 0c             	mov    0xc(%eax),%eax
  8020ca:	01 c8                	add    %ecx,%eax
  8020cc:	39 c2                	cmp    %eax,%edx
  8020ce:	73 04                	jae    8020d4 <print_mem_block_lists+0x114>
			sorted = 0 ;
  8020d0:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  8020d4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8020d7:	8b 50 08             	mov    0x8(%eax),%edx
  8020da:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8020dd:	8b 40 0c             	mov    0xc(%eax),%eax
  8020e0:	01 c2                	add    %eax,%edx
  8020e2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8020e5:	8b 40 08             	mov    0x8(%eax),%eax
  8020e8:	83 ec 04             	sub    $0x4,%esp
  8020eb:	52                   	push   %edx
  8020ec:	50                   	push   %eax
  8020ed:	68 21 3e 80 00       	push   $0x803e21
  8020f2:	e8 b9 e5 ff ff       	call   8006b0 <cprintf>
  8020f7:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  8020fa:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8020fd:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;

	lastBlk = NULL ;
	cprintf("\nAllocMemBlocksList:\n");
	sorted = 1 ;
	LIST_FOREACH(blk, &AllocMemBlocksList)
  802100:	a1 48 40 80 00       	mov    0x804048,%eax
  802105:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802108:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80210c:	74 07                	je     802115 <print_mem_block_lists+0x155>
  80210e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802111:	8b 00                	mov    (%eax),%eax
  802113:	eb 05                	jmp    80211a <print_mem_block_lists+0x15a>
  802115:	b8 00 00 00 00       	mov    $0x0,%eax
  80211a:	a3 48 40 80 00       	mov    %eax,0x804048
  80211f:	a1 48 40 80 00       	mov    0x804048,%eax
  802124:	85 c0                	test   %eax,%eax
  802126:	75 8a                	jne    8020b2 <print_mem_block_lists+0xf2>
  802128:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80212c:	75 84                	jne    8020b2 <print_mem_block_lists+0xf2>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nAllocMemBlocksList is NOT SORTED!!\n") ;
  80212e:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  802132:	75 10                	jne    802144 <print_mem_block_lists+0x184>
  802134:	83 ec 0c             	sub    $0xc,%esp
  802137:	68 6c 3e 80 00       	push   $0x803e6c
  80213c:	e8 6f e5 ff ff       	call   8006b0 <cprintf>
  802141:	83 c4 10             	add    $0x10,%esp
	cprintf("\n=========================================\n");
  802144:	83 ec 0c             	sub    $0xc,%esp
  802147:	68 e0 3d 80 00       	push   $0x803de0
  80214c:	e8 5f e5 ff ff       	call   8006b0 <cprintf>
  802151:	83 c4 10             	add    $0x10,%esp

}
  802154:	90                   	nop
  802155:	c9                   	leave  
  802156:	c3                   	ret    

00802157 <initialize_MemBlocksList>:

//===============================
// [1] INITIALIZE AVAILABLE LIST:
//===============================
void initialize_MemBlocksList(uint32 numOfBlocks)
{
  802157:	55                   	push   %ebp
  802158:	89 e5                	mov    %esp,%ebp
  80215a:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] initialize_MemBlocksList
	// Write your code here, remove the panic and write your code
	//panic("initialize_MemBlocksList() is not implemented yet...!!");
	uint32 n = numOfBlocks;
  80215d:	8b 45 08             	mov    0x8(%ebp),%eax
  802160:	89 45 f0             	mov    %eax,-0x10(%ebp)

	LIST_INIT(&AvailableMemBlocksList);
  802163:	c7 05 48 41 80 00 00 	movl   $0x0,0x804148
  80216a:	00 00 00 
  80216d:	c7 05 4c 41 80 00 00 	movl   $0x0,0x80414c
  802174:	00 00 00 
  802177:	c7 05 54 41 80 00 00 	movl   $0x0,0x804154
  80217e:	00 00 00 
	for(int i = 0; i<n;i++)
  802181:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  802188:	e9 9e 00 00 00       	jmp    80222b <initialize_MemBlocksList+0xd4>
	{
		LIST_INSERT_HEAD(&AvailableMemBlocksList, &(MemBlockNodes[i]));
  80218d:	a1 50 40 80 00       	mov    0x804050,%eax
  802192:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802195:	c1 e2 04             	shl    $0x4,%edx
  802198:	01 d0                	add    %edx,%eax
  80219a:	85 c0                	test   %eax,%eax
  80219c:	75 14                	jne    8021b2 <initialize_MemBlocksList+0x5b>
  80219e:	83 ec 04             	sub    $0x4,%esp
  8021a1:	68 94 3e 80 00       	push   $0x803e94
  8021a6:	6a 47                	push   $0x47
  8021a8:	68 b7 3e 80 00       	push   $0x803eb7
  8021ad:	e8 4a e2 ff ff       	call   8003fc <_panic>
  8021b2:	a1 50 40 80 00       	mov    0x804050,%eax
  8021b7:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8021ba:	c1 e2 04             	shl    $0x4,%edx
  8021bd:	01 d0                	add    %edx,%eax
  8021bf:	8b 15 48 41 80 00    	mov    0x804148,%edx
  8021c5:	89 10                	mov    %edx,(%eax)
  8021c7:	8b 00                	mov    (%eax),%eax
  8021c9:	85 c0                	test   %eax,%eax
  8021cb:	74 18                	je     8021e5 <initialize_MemBlocksList+0x8e>
  8021cd:	a1 48 41 80 00       	mov    0x804148,%eax
  8021d2:	8b 15 50 40 80 00    	mov    0x804050,%edx
  8021d8:	8b 4d f4             	mov    -0xc(%ebp),%ecx
  8021db:	c1 e1 04             	shl    $0x4,%ecx
  8021de:	01 ca                	add    %ecx,%edx
  8021e0:	89 50 04             	mov    %edx,0x4(%eax)
  8021e3:	eb 12                	jmp    8021f7 <initialize_MemBlocksList+0xa0>
  8021e5:	a1 50 40 80 00       	mov    0x804050,%eax
  8021ea:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8021ed:	c1 e2 04             	shl    $0x4,%edx
  8021f0:	01 d0                	add    %edx,%eax
  8021f2:	a3 4c 41 80 00       	mov    %eax,0x80414c
  8021f7:	a1 50 40 80 00       	mov    0x804050,%eax
  8021fc:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8021ff:	c1 e2 04             	shl    $0x4,%edx
  802202:	01 d0                	add    %edx,%eax
  802204:	a3 48 41 80 00       	mov    %eax,0x804148
  802209:	a1 50 40 80 00       	mov    0x804050,%eax
  80220e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802211:	c1 e2 04             	shl    $0x4,%edx
  802214:	01 d0                	add    %edx,%eax
  802216:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80221d:	a1 54 41 80 00       	mov    0x804154,%eax
  802222:	40                   	inc    %eax
  802223:	a3 54 41 80 00       	mov    %eax,0x804154
	// Write your code here, remove the panic and write your code
	//panic("initialize_MemBlocksList() is not implemented yet...!!");
	uint32 n = numOfBlocks;

	LIST_INIT(&AvailableMemBlocksList);
	for(int i = 0; i<n;i++)
  802228:	ff 45 f4             	incl   -0xc(%ebp)
  80222b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80222e:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  802231:	0f 82 56 ff ff ff    	jb     80218d <initialize_MemBlocksList+0x36>
	{
		LIST_INSERT_HEAD(&AvailableMemBlocksList, &(MemBlockNodes[i]));
	}
}
  802237:	90                   	nop
  802238:	c9                   	leave  
  802239:	c3                   	ret    

0080223a <find_block>:

//===============================
// [2] FIND BLOCK:
//===============================
struct MemBlock *find_block(struct MemBlock_List *blockList, uint32 va)
{
  80223a:	55                   	push   %ebp
  80223b:	89 e5                	mov    %esp,%ebp
  80223d:	83 ec 10             	sub    $0x10,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] find_block
	// Write your code here, remove the panic and write your code
	//panic("find_block() is not implemented yet...!!");
	uint32 virAddress = va;
  802240:	8b 45 0c             	mov    0xc(%ebp),%eax
  802243:	89 45 f4             	mov    %eax,-0xc(%ebp)
	struct MemBlock* blk;
	int found = 0;
  802246:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	LIST_FOREACH(blk, &(AllocMemBlocksList))
  80224d:	a1 40 40 80 00       	mov    0x804040,%eax
  802252:	89 45 fc             	mov    %eax,-0x4(%ebp)
  802255:	eb 23                	jmp    80227a <find_block+0x40>
	{
		if(blk->sva == virAddress)
  802257:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80225a:	8b 40 08             	mov    0x8(%eax),%eax
  80225d:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  802260:	75 09                	jne    80226b <find_block+0x31>
		{
			found = 1;
  802262:	c7 45 f8 01 00 00 00 	movl   $0x1,-0x8(%ebp)
			break;
  802269:	eb 35                	jmp    8022a0 <find_block+0x66>
		}
		else
		{
			found = 0;
  80226b:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	//panic("find_block() is not implemented yet...!!");
	uint32 virAddress = va;
	struct MemBlock* blk;
	int found = 0;

	LIST_FOREACH(blk, &(AllocMemBlocksList))
  802272:	a1 48 40 80 00       	mov    0x804048,%eax
  802277:	89 45 fc             	mov    %eax,-0x4(%ebp)
  80227a:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  80227e:	74 07                	je     802287 <find_block+0x4d>
  802280:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802283:	8b 00                	mov    (%eax),%eax
  802285:	eb 05                	jmp    80228c <find_block+0x52>
  802287:	b8 00 00 00 00       	mov    $0x0,%eax
  80228c:	a3 48 40 80 00       	mov    %eax,0x804048
  802291:	a1 48 40 80 00       	mov    0x804048,%eax
  802296:	85 c0                	test   %eax,%eax
  802298:	75 bd                	jne    802257 <find_block+0x1d>
  80229a:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  80229e:	75 b7                	jne    802257 <find_block+0x1d>
		{
			found = 0;
			continue;
		}
	}
	if(found == 1)
  8022a0:	83 7d f8 01          	cmpl   $0x1,-0x8(%ebp)
  8022a4:	75 05                	jne    8022ab <find_block+0x71>
	{
		return blk;
  8022a6:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8022a9:	eb 05                	jmp    8022b0 <find_block+0x76>
	}
	else
	{
		return NULL;
  8022ab:	b8 00 00 00 00       	mov    $0x0,%eax
	}
}
  8022b0:	c9                   	leave  
  8022b1:	c3                   	ret    

008022b2 <insert_sorted_allocList>:

//=========================================
// [3] INSERT BLOCK IN ALLOC LIST [SORTED]:
//=========================================
void insert_sorted_allocList(struct MemBlock *blockToInsert)
{
  8022b2:	55                   	push   %ebp
  8022b3:	89 e5                	mov    %esp,%ebp
  8022b5:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] insert_sorted_allocList
	// Write your code here, remove the panic and write your code
	//panic("insert_sorted_allocList() is not implemented yet...!!");
	struct MemBlock* blk;
	struct MemBlock* newblk = blockToInsert;
  8022b8:	8b 45 08             	mov    0x8(%ebp),%eax
  8022bb:	89 45 f0             	mov    %eax,-0x10(%ebp)

	if((LIST_EMPTY(&AllocMemBlocksList)) || (newblk->sva < LIST_FIRST(&AllocMemBlocksList)->sva))
  8022be:	a1 40 40 80 00       	mov    0x804040,%eax
  8022c3:	85 c0                	test   %eax,%eax
  8022c5:	74 12                	je     8022d9 <insert_sorted_allocList+0x27>
  8022c7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8022ca:	8b 50 08             	mov    0x8(%eax),%edx
  8022cd:	a1 40 40 80 00       	mov    0x804040,%eax
  8022d2:	8b 40 08             	mov    0x8(%eax),%eax
  8022d5:	39 c2                	cmp    %eax,%edx
  8022d7:	73 65                	jae    80233e <insert_sorted_allocList+0x8c>
	{
		LIST_INSERT_HEAD(&(AllocMemBlocksList), newblk);
  8022d9:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8022dd:	75 14                	jne    8022f3 <insert_sorted_allocList+0x41>
  8022df:	83 ec 04             	sub    $0x4,%esp
  8022e2:	68 94 3e 80 00       	push   $0x803e94
  8022e7:	6a 7b                	push   $0x7b
  8022e9:	68 b7 3e 80 00       	push   $0x803eb7
  8022ee:	e8 09 e1 ff ff       	call   8003fc <_panic>
  8022f3:	8b 15 40 40 80 00    	mov    0x804040,%edx
  8022f9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8022fc:	89 10                	mov    %edx,(%eax)
  8022fe:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802301:	8b 00                	mov    (%eax),%eax
  802303:	85 c0                	test   %eax,%eax
  802305:	74 0d                	je     802314 <insert_sorted_allocList+0x62>
  802307:	a1 40 40 80 00       	mov    0x804040,%eax
  80230c:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80230f:	89 50 04             	mov    %edx,0x4(%eax)
  802312:	eb 08                	jmp    80231c <insert_sorted_allocList+0x6a>
  802314:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802317:	a3 44 40 80 00       	mov    %eax,0x804044
  80231c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80231f:	a3 40 40 80 00       	mov    %eax,0x804040
  802324:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802327:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80232e:	a1 4c 40 80 00       	mov    0x80404c,%eax
  802333:	40                   	inc    %eax
  802334:	a3 4c 40 80 00       	mov    %eax,0x80404c
  802339:	e9 5f 01 00 00       	jmp    80249d <insert_sorted_allocList+0x1eb>
	}
	else if(newblk->sva > LIST_LAST(&AllocMemBlocksList)->sva)
  80233e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802341:	8b 50 08             	mov    0x8(%eax),%edx
  802344:	a1 44 40 80 00       	mov    0x804044,%eax
  802349:	8b 40 08             	mov    0x8(%eax),%eax
  80234c:	39 c2                	cmp    %eax,%edx
  80234e:	76 65                	jbe    8023b5 <insert_sorted_allocList+0x103>
	{
		LIST_INSERT_TAIL(&AllocMemBlocksList, newblk);
  802350:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802354:	75 14                	jne    80236a <insert_sorted_allocList+0xb8>
  802356:	83 ec 04             	sub    $0x4,%esp
  802359:	68 d0 3e 80 00       	push   $0x803ed0
  80235e:	6a 7f                	push   $0x7f
  802360:	68 b7 3e 80 00       	push   $0x803eb7
  802365:	e8 92 e0 ff ff       	call   8003fc <_panic>
  80236a:	8b 15 44 40 80 00    	mov    0x804044,%edx
  802370:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802373:	89 50 04             	mov    %edx,0x4(%eax)
  802376:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802379:	8b 40 04             	mov    0x4(%eax),%eax
  80237c:	85 c0                	test   %eax,%eax
  80237e:	74 0c                	je     80238c <insert_sorted_allocList+0xda>
  802380:	a1 44 40 80 00       	mov    0x804044,%eax
  802385:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802388:	89 10                	mov    %edx,(%eax)
  80238a:	eb 08                	jmp    802394 <insert_sorted_allocList+0xe2>
  80238c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80238f:	a3 40 40 80 00       	mov    %eax,0x804040
  802394:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802397:	a3 44 40 80 00       	mov    %eax,0x804044
  80239c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80239f:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8023a5:	a1 4c 40 80 00       	mov    0x80404c,%eax
  8023aa:	40                   	inc    %eax
  8023ab:	a3 4c 40 80 00       	mov    %eax,0x80404c
				LIST_INSERT_AFTER(&AllocMemBlocksList, blk, newblk);
				break;
			}
		}
	}
}
  8023b0:	e9 e8 00 00 00       	jmp    80249d <insert_sorted_allocList+0x1eb>
	{
		LIST_INSERT_TAIL(&AllocMemBlocksList, newblk);
	}
	else
	{
		LIST_FOREACH(blk, &AllocMemBlocksList)
  8023b5:	a1 40 40 80 00       	mov    0x804040,%eax
  8023ba:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8023bd:	e9 ab 00 00 00       	jmp    80246d <insert_sorted_allocList+0x1bb>
		{
			if(blk->prev_next_info.le_next != NULL && newblk->sva > blk->sva  && newblk->sva < blk->prev_next_info.le_next->sva)
  8023c2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023c5:	8b 00                	mov    (%eax),%eax
  8023c7:	85 c0                	test   %eax,%eax
  8023c9:	0f 84 96 00 00 00    	je     802465 <insert_sorted_allocList+0x1b3>
  8023cf:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8023d2:	8b 50 08             	mov    0x8(%eax),%edx
  8023d5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023d8:	8b 40 08             	mov    0x8(%eax),%eax
  8023db:	39 c2                	cmp    %eax,%edx
  8023dd:	0f 86 82 00 00 00    	jbe    802465 <insert_sorted_allocList+0x1b3>
  8023e3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8023e6:	8b 50 08             	mov    0x8(%eax),%edx
  8023e9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023ec:	8b 00                	mov    (%eax),%eax
  8023ee:	8b 40 08             	mov    0x8(%eax),%eax
  8023f1:	39 c2                	cmp    %eax,%edx
  8023f3:	73 70                	jae    802465 <insert_sorted_allocList+0x1b3>
			{
				LIST_INSERT_AFTER(&AllocMemBlocksList, blk, newblk);
  8023f5:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8023f9:	74 06                	je     802401 <insert_sorted_allocList+0x14f>
  8023fb:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8023ff:	75 17                	jne    802418 <insert_sorted_allocList+0x166>
  802401:	83 ec 04             	sub    $0x4,%esp
  802404:	68 f4 3e 80 00       	push   $0x803ef4
  802409:	68 87 00 00 00       	push   $0x87
  80240e:	68 b7 3e 80 00       	push   $0x803eb7
  802413:	e8 e4 df ff ff       	call   8003fc <_panic>
  802418:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80241b:	8b 10                	mov    (%eax),%edx
  80241d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802420:	89 10                	mov    %edx,(%eax)
  802422:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802425:	8b 00                	mov    (%eax),%eax
  802427:	85 c0                	test   %eax,%eax
  802429:	74 0b                	je     802436 <insert_sorted_allocList+0x184>
  80242b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80242e:	8b 00                	mov    (%eax),%eax
  802430:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802433:	89 50 04             	mov    %edx,0x4(%eax)
  802436:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802439:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80243c:	89 10                	mov    %edx,(%eax)
  80243e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802441:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802444:	89 50 04             	mov    %edx,0x4(%eax)
  802447:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80244a:	8b 00                	mov    (%eax),%eax
  80244c:	85 c0                	test   %eax,%eax
  80244e:	75 08                	jne    802458 <insert_sorted_allocList+0x1a6>
  802450:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802453:	a3 44 40 80 00       	mov    %eax,0x804044
  802458:	a1 4c 40 80 00       	mov    0x80404c,%eax
  80245d:	40                   	inc    %eax
  80245e:	a3 4c 40 80 00       	mov    %eax,0x80404c
				break;
  802463:	eb 38                	jmp    80249d <insert_sorted_allocList+0x1eb>
	{
		LIST_INSERT_TAIL(&AllocMemBlocksList, newblk);
	}
	else
	{
		LIST_FOREACH(blk, &AllocMemBlocksList)
  802465:	a1 48 40 80 00       	mov    0x804048,%eax
  80246a:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80246d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802471:	74 07                	je     80247a <insert_sorted_allocList+0x1c8>
  802473:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802476:	8b 00                	mov    (%eax),%eax
  802478:	eb 05                	jmp    80247f <insert_sorted_allocList+0x1cd>
  80247a:	b8 00 00 00 00       	mov    $0x0,%eax
  80247f:	a3 48 40 80 00       	mov    %eax,0x804048
  802484:	a1 48 40 80 00       	mov    0x804048,%eax
  802489:	85 c0                	test   %eax,%eax
  80248b:	0f 85 31 ff ff ff    	jne    8023c2 <insert_sorted_allocList+0x110>
  802491:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802495:	0f 85 27 ff ff ff    	jne    8023c2 <insert_sorted_allocList+0x110>
				LIST_INSERT_AFTER(&AllocMemBlocksList, blk, newblk);
				break;
			}
		}
	}
}
  80249b:	eb 00                	jmp    80249d <insert_sorted_allocList+0x1eb>
  80249d:	90                   	nop
  80249e:	c9                   	leave  
  80249f:	c3                   	ret    

008024a0 <alloc_block_FF>:

//=========================================
// [4] ALLOCATE BLOCK BY FIRST FIT:
//=========================================
struct MemBlock *alloc_block_FF(uint32 size)
{
  8024a0:	55                   	push   %ebp
  8024a1:	89 e5                	mov    %esp,%ebp
  8024a3:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_FF
	// Write your code here, remove the panic and write your code
	//panic("alloc_block_FF() is not implemented yet...!!");
	uint32 versize = size;
  8024a6:	8b 45 08             	mov    0x8(%ebp),%eax
  8024a9:	89 45 f0             	mov    %eax,-0x10(%ebp)
	struct MemBlock* blk;
	struct MemBlock* newblk = LIST_FIRST(&AvailableMemBlocksList);
  8024ac:	a1 48 41 80 00       	mov    0x804148,%eax
  8024b1:	89 45 ec             	mov    %eax,-0x14(%ebp)

	LIST_FOREACH(blk,&FreeMemBlocksList)
  8024b4:	a1 38 41 80 00       	mov    0x804138,%eax
  8024b9:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8024bc:	e9 77 01 00 00       	jmp    802638 <alloc_block_FF+0x198>
	{
		if(blk->size == versize)
  8024c1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024c4:	8b 40 0c             	mov    0xc(%eax),%eax
  8024c7:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8024ca:	0f 85 8a 00 00 00    	jne    80255a <alloc_block_FF+0xba>
		{
			LIST_REMOVE(&FreeMemBlocksList,blk);
  8024d0:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8024d4:	75 17                	jne    8024ed <alloc_block_FF+0x4d>
  8024d6:	83 ec 04             	sub    $0x4,%esp
  8024d9:	68 28 3f 80 00       	push   $0x803f28
  8024de:	68 9e 00 00 00       	push   $0x9e
  8024e3:	68 b7 3e 80 00       	push   $0x803eb7
  8024e8:	e8 0f df ff ff       	call   8003fc <_panic>
  8024ed:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024f0:	8b 00                	mov    (%eax),%eax
  8024f2:	85 c0                	test   %eax,%eax
  8024f4:	74 10                	je     802506 <alloc_block_FF+0x66>
  8024f6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024f9:	8b 00                	mov    (%eax),%eax
  8024fb:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8024fe:	8b 52 04             	mov    0x4(%edx),%edx
  802501:	89 50 04             	mov    %edx,0x4(%eax)
  802504:	eb 0b                	jmp    802511 <alloc_block_FF+0x71>
  802506:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802509:	8b 40 04             	mov    0x4(%eax),%eax
  80250c:	a3 3c 41 80 00       	mov    %eax,0x80413c
  802511:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802514:	8b 40 04             	mov    0x4(%eax),%eax
  802517:	85 c0                	test   %eax,%eax
  802519:	74 0f                	je     80252a <alloc_block_FF+0x8a>
  80251b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80251e:	8b 40 04             	mov    0x4(%eax),%eax
  802521:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802524:	8b 12                	mov    (%edx),%edx
  802526:	89 10                	mov    %edx,(%eax)
  802528:	eb 0a                	jmp    802534 <alloc_block_FF+0x94>
  80252a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80252d:	8b 00                	mov    (%eax),%eax
  80252f:	a3 38 41 80 00       	mov    %eax,0x804138
  802534:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802537:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80253d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802540:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802547:	a1 44 41 80 00       	mov    0x804144,%eax
  80254c:	48                   	dec    %eax
  80254d:	a3 44 41 80 00       	mov    %eax,0x804144
			return blk;
  802552:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802555:	e9 11 01 00 00       	jmp    80266b <alloc_block_FF+0x1cb>
		}
		else if(blk->size > versize)
  80255a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80255d:	8b 40 0c             	mov    0xc(%eax),%eax
  802560:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  802563:	0f 86 c7 00 00 00    	jbe    802630 <alloc_block_FF+0x190>
		{
			LIST_REMOVE(&AvailableMemBlocksList,newblk);
  802569:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  80256d:	75 17                	jne    802586 <alloc_block_FF+0xe6>
  80256f:	83 ec 04             	sub    $0x4,%esp
  802572:	68 28 3f 80 00       	push   $0x803f28
  802577:	68 a3 00 00 00       	push   $0xa3
  80257c:	68 b7 3e 80 00       	push   $0x803eb7
  802581:	e8 76 de ff ff       	call   8003fc <_panic>
  802586:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802589:	8b 00                	mov    (%eax),%eax
  80258b:	85 c0                	test   %eax,%eax
  80258d:	74 10                	je     80259f <alloc_block_FF+0xff>
  80258f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802592:	8b 00                	mov    (%eax),%eax
  802594:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802597:	8b 52 04             	mov    0x4(%edx),%edx
  80259a:	89 50 04             	mov    %edx,0x4(%eax)
  80259d:	eb 0b                	jmp    8025aa <alloc_block_FF+0x10a>
  80259f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8025a2:	8b 40 04             	mov    0x4(%eax),%eax
  8025a5:	a3 4c 41 80 00       	mov    %eax,0x80414c
  8025aa:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8025ad:	8b 40 04             	mov    0x4(%eax),%eax
  8025b0:	85 c0                	test   %eax,%eax
  8025b2:	74 0f                	je     8025c3 <alloc_block_FF+0x123>
  8025b4:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8025b7:	8b 40 04             	mov    0x4(%eax),%eax
  8025ba:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8025bd:	8b 12                	mov    (%edx),%edx
  8025bf:	89 10                	mov    %edx,(%eax)
  8025c1:	eb 0a                	jmp    8025cd <alloc_block_FF+0x12d>
  8025c3:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8025c6:	8b 00                	mov    (%eax),%eax
  8025c8:	a3 48 41 80 00       	mov    %eax,0x804148
  8025cd:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8025d0:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8025d6:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8025d9:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8025e0:	a1 54 41 80 00       	mov    0x804154,%eax
  8025e5:	48                   	dec    %eax
  8025e6:	a3 54 41 80 00       	mov    %eax,0x804154
			newblk->size = versize;
  8025eb:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8025ee:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8025f1:	89 50 0c             	mov    %edx,0xc(%eax)
			blk->size = blk->size-versize;
  8025f4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025f7:	8b 40 0c             	mov    0xc(%eax),%eax
  8025fa:	2b 45 f0             	sub    -0x10(%ebp),%eax
  8025fd:	89 c2                	mov    %eax,%edx
  8025ff:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802602:	89 50 0c             	mov    %edx,0xc(%eax)
			uint32 newveradd = blk->sva;
  802605:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802608:	8b 40 08             	mov    0x8(%eax),%eax
  80260b:	89 45 e8             	mov    %eax,-0x18(%ebp)
			blk->sva+=newblk->size;
  80260e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802611:	8b 50 08             	mov    0x8(%eax),%edx
  802614:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802617:	8b 40 0c             	mov    0xc(%eax),%eax
  80261a:	01 c2                	add    %eax,%edx
  80261c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80261f:	89 50 08             	mov    %edx,0x8(%eax)
			newblk->sva = newveradd;
  802622:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802625:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802628:	89 50 08             	mov    %edx,0x8(%eax)
			return newblk;
  80262b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80262e:	eb 3b                	jmp    80266b <alloc_block_FF+0x1cb>
	//panic("alloc_block_FF() is not implemented yet...!!");
	uint32 versize = size;
	struct MemBlock* blk;
	struct MemBlock* newblk = LIST_FIRST(&AvailableMemBlocksList);

	LIST_FOREACH(blk,&FreeMemBlocksList)
  802630:	a1 40 41 80 00       	mov    0x804140,%eax
  802635:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802638:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80263c:	74 07                	je     802645 <alloc_block_FF+0x1a5>
  80263e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802641:	8b 00                	mov    (%eax),%eax
  802643:	eb 05                	jmp    80264a <alloc_block_FF+0x1aa>
  802645:	b8 00 00 00 00       	mov    $0x0,%eax
  80264a:	a3 40 41 80 00       	mov    %eax,0x804140
  80264f:	a1 40 41 80 00       	mov    0x804140,%eax
  802654:	85 c0                	test   %eax,%eax
  802656:	0f 85 65 fe ff ff    	jne    8024c1 <alloc_block_FF+0x21>
  80265c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802660:	0f 85 5b fe ff ff    	jne    8024c1 <alloc_block_FF+0x21>
			blk->sva+=newblk->size;
			newblk->sva = newveradd;
			return newblk;
		}
	}
	return NULL;
  802666:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80266b:	c9                   	leave  
  80266c:	c3                   	ret    

0080266d <alloc_block_BF>:

//=========================================
// [5] ALLOCATE BLOCK BY BEST FIT:
//=========================================
struct MemBlock *alloc_block_BF(uint32 size)
{
  80266d:	55                   	push   %ebp
  80266e:	89 e5                	mov    %esp,%ebp
  802670:	83 ec 28             	sub    $0x28,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_BF
	// Write your code here, remove the panic and write your code
	//panic("alloc_block_BF() is not implemented yet...!!");
	uint32 versize=size;
  802673:	8b 45 08             	mov    0x8(%ebp),%eax
  802676:	89 45 e8             	mov    %eax,-0x18(%ebp)
	struct MemBlock* blk;
	struct MemBlock* newblk=LIST_FIRST(&AvailableMemBlocksList);
  802679:	a1 48 41 80 00       	mov    0x804148,%eax
  80267e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	uint32 newveradd;
	uint32 newsize;
	int size_free = LIST_SIZE(&FreeMemBlocksList);
  802681:	a1 44 41 80 00       	mov    0x804144,%eax
  802686:	89 45 e0             	mov    %eax,-0x20(%ebp)

	LIST_FOREACH(blk, &FreeMemBlocksList)
  802689:	a1 38 41 80 00       	mov    0x804138,%eax
  80268e:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802691:	e9 a1 00 00 00       	jmp    802737 <alloc_block_BF+0xca>
	{
		if(blk->size == versize)
  802696:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802699:	8b 40 0c             	mov    0xc(%eax),%eax
  80269c:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  80269f:	0f 85 8a 00 00 00    	jne    80272f <alloc_block_BF+0xc2>
		{
			LIST_REMOVE(&FreeMemBlocksList, blk);
  8026a5:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8026a9:	75 17                	jne    8026c2 <alloc_block_BF+0x55>
  8026ab:	83 ec 04             	sub    $0x4,%esp
  8026ae:	68 28 3f 80 00       	push   $0x803f28
  8026b3:	68 c2 00 00 00       	push   $0xc2
  8026b8:	68 b7 3e 80 00       	push   $0x803eb7
  8026bd:	e8 3a dd ff ff       	call   8003fc <_panic>
  8026c2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026c5:	8b 00                	mov    (%eax),%eax
  8026c7:	85 c0                	test   %eax,%eax
  8026c9:	74 10                	je     8026db <alloc_block_BF+0x6e>
  8026cb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026ce:	8b 00                	mov    (%eax),%eax
  8026d0:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8026d3:	8b 52 04             	mov    0x4(%edx),%edx
  8026d6:	89 50 04             	mov    %edx,0x4(%eax)
  8026d9:	eb 0b                	jmp    8026e6 <alloc_block_BF+0x79>
  8026db:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026de:	8b 40 04             	mov    0x4(%eax),%eax
  8026e1:	a3 3c 41 80 00       	mov    %eax,0x80413c
  8026e6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026e9:	8b 40 04             	mov    0x4(%eax),%eax
  8026ec:	85 c0                	test   %eax,%eax
  8026ee:	74 0f                	je     8026ff <alloc_block_BF+0x92>
  8026f0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026f3:	8b 40 04             	mov    0x4(%eax),%eax
  8026f6:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8026f9:	8b 12                	mov    (%edx),%edx
  8026fb:	89 10                	mov    %edx,(%eax)
  8026fd:	eb 0a                	jmp    802709 <alloc_block_BF+0x9c>
  8026ff:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802702:	8b 00                	mov    (%eax),%eax
  802704:	a3 38 41 80 00       	mov    %eax,0x804138
  802709:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80270c:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802712:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802715:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80271c:	a1 44 41 80 00       	mov    0x804144,%eax
  802721:	48                   	dec    %eax
  802722:	a3 44 41 80 00       	mov    %eax,0x804144
			return blk;
  802727:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80272a:	e9 11 02 00 00       	jmp    802940 <alloc_block_BF+0x2d3>
	struct MemBlock* newblk=LIST_FIRST(&AvailableMemBlocksList);
	uint32 newveradd;
	uint32 newsize;
	int size_free = LIST_SIZE(&FreeMemBlocksList);

	LIST_FOREACH(blk, &FreeMemBlocksList)
  80272f:	a1 40 41 80 00       	mov    0x804140,%eax
  802734:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802737:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80273b:	74 07                	je     802744 <alloc_block_BF+0xd7>
  80273d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802740:	8b 00                	mov    (%eax),%eax
  802742:	eb 05                	jmp    802749 <alloc_block_BF+0xdc>
  802744:	b8 00 00 00 00       	mov    $0x0,%eax
  802749:	a3 40 41 80 00       	mov    %eax,0x804140
  80274e:	a1 40 41 80 00       	mov    0x804140,%eax
  802753:	85 c0                	test   %eax,%eax
  802755:	0f 85 3b ff ff ff    	jne    802696 <alloc_block_BF+0x29>
  80275b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80275f:	0f 85 31 ff ff ff    	jne    802696 <alloc_block_BF+0x29>
		{
			LIST_REMOVE(&FreeMemBlocksList, blk);
			return blk;
		}
	}
	LIST_FOREACH(blk, &FreeMemBlocksList)
  802765:	a1 38 41 80 00       	mov    0x804138,%eax
  80276a:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80276d:	eb 27                	jmp    802796 <alloc_block_BF+0x129>
	{
		if(blk->size > versize)
  80276f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802772:	8b 40 0c             	mov    0xc(%eax),%eax
  802775:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  802778:	76 14                	jbe    80278e <alloc_block_BF+0x121>
		{
			newsize = blk->size;
  80277a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80277d:	8b 40 0c             	mov    0xc(%eax),%eax
  802780:	89 45 ec             	mov    %eax,-0x14(%ebp)
			newveradd = blk->sva;
  802783:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802786:	8b 40 08             	mov    0x8(%eax),%eax
  802789:	89 45 f0             	mov    %eax,-0x10(%ebp)
			break;
  80278c:	eb 2e                	jmp    8027bc <alloc_block_BF+0x14f>
		{
			LIST_REMOVE(&FreeMemBlocksList, blk);
			return blk;
		}
	}
	LIST_FOREACH(blk, &FreeMemBlocksList)
  80278e:	a1 40 41 80 00       	mov    0x804140,%eax
  802793:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802796:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80279a:	74 07                	je     8027a3 <alloc_block_BF+0x136>
  80279c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80279f:	8b 00                	mov    (%eax),%eax
  8027a1:	eb 05                	jmp    8027a8 <alloc_block_BF+0x13b>
  8027a3:	b8 00 00 00 00       	mov    $0x0,%eax
  8027a8:	a3 40 41 80 00       	mov    %eax,0x804140
  8027ad:	a1 40 41 80 00       	mov    0x804140,%eax
  8027b2:	85 c0                	test   %eax,%eax
  8027b4:	75 b9                	jne    80276f <alloc_block_BF+0x102>
  8027b6:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8027ba:	75 b3                	jne    80276f <alloc_block_BF+0x102>
			newsize = blk->size;
			newveradd = blk->sva;
			break;
		}
	}
	LIST_FOREACH(blk, &FreeMemBlocksList)
  8027bc:	a1 38 41 80 00       	mov    0x804138,%eax
  8027c1:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8027c4:	eb 30                	jmp    8027f6 <alloc_block_BF+0x189>
	{
		if(newsize > blk->size && blk->size > versize)
  8027c6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027c9:	8b 40 0c             	mov    0xc(%eax),%eax
  8027cc:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  8027cf:	73 1d                	jae    8027ee <alloc_block_BF+0x181>
  8027d1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027d4:	8b 40 0c             	mov    0xc(%eax),%eax
  8027d7:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  8027da:	76 12                	jbe    8027ee <alloc_block_BF+0x181>
		{
	       newsize = blk->size;
  8027dc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027df:	8b 40 0c             	mov    0xc(%eax),%eax
  8027e2:	89 45 ec             	mov    %eax,-0x14(%ebp)
		   newveradd = blk->sva;
  8027e5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027e8:	8b 40 08             	mov    0x8(%eax),%eax
  8027eb:	89 45 f0             	mov    %eax,-0x10(%ebp)
			newsize = blk->size;
			newveradd = blk->sva;
			break;
		}
	}
	LIST_FOREACH(blk, &FreeMemBlocksList)
  8027ee:	a1 40 41 80 00       	mov    0x804140,%eax
  8027f3:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8027f6:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8027fa:	74 07                	je     802803 <alloc_block_BF+0x196>
  8027fc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027ff:	8b 00                	mov    (%eax),%eax
  802801:	eb 05                	jmp    802808 <alloc_block_BF+0x19b>
  802803:	b8 00 00 00 00       	mov    $0x0,%eax
  802808:	a3 40 41 80 00       	mov    %eax,0x804140
  80280d:	a1 40 41 80 00       	mov    0x804140,%eax
  802812:	85 c0                	test   %eax,%eax
  802814:	75 b0                	jne    8027c6 <alloc_block_BF+0x159>
  802816:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80281a:	75 aa                	jne    8027c6 <alloc_block_BF+0x159>
		{
	       newsize = blk->size;
		   newveradd = blk->sva;
		}
	}
	LIST_FOREACH(blk, &FreeMemBlocksList)
  80281c:	a1 38 41 80 00       	mov    0x804138,%eax
  802821:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802824:	e9 e4 00 00 00       	jmp    80290d <alloc_block_BF+0x2a0>
	{
		if(blk->size == newsize && blk->sva == newveradd)
  802829:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80282c:	8b 40 0c             	mov    0xc(%eax),%eax
  80282f:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  802832:	0f 85 cd 00 00 00    	jne    802905 <alloc_block_BF+0x298>
  802838:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80283b:	8b 40 08             	mov    0x8(%eax),%eax
  80283e:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  802841:	0f 85 be 00 00 00    	jne    802905 <alloc_block_BF+0x298>
		{
			LIST_REMOVE(&AvailableMemBlocksList, newblk);
  802847:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80284b:	75 17                	jne    802864 <alloc_block_BF+0x1f7>
  80284d:	83 ec 04             	sub    $0x4,%esp
  802850:	68 28 3f 80 00       	push   $0x803f28
  802855:	68 db 00 00 00       	push   $0xdb
  80285a:	68 b7 3e 80 00       	push   $0x803eb7
  80285f:	e8 98 db ff ff       	call   8003fc <_panic>
  802864:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802867:	8b 00                	mov    (%eax),%eax
  802869:	85 c0                	test   %eax,%eax
  80286b:	74 10                	je     80287d <alloc_block_BF+0x210>
  80286d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802870:	8b 00                	mov    (%eax),%eax
  802872:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802875:	8b 52 04             	mov    0x4(%edx),%edx
  802878:	89 50 04             	mov    %edx,0x4(%eax)
  80287b:	eb 0b                	jmp    802888 <alloc_block_BF+0x21b>
  80287d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802880:	8b 40 04             	mov    0x4(%eax),%eax
  802883:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802888:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80288b:	8b 40 04             	mov    0x4(%eax),%eax
  80288e:	85 c0                	test   %eax,%eax
  802890:	74 0f                	je     8028a1 <alloc_block_BF+0x234>
  802892:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802895:	8b 40 04             	mov    0x4(%eax),%eax
  802898:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80289b:	8b 12                	mov    (%edx),%edx
  80289d:	89 10                	mov    %edx,(%eax)
  80289f:	eb 0a                	jmp    8028ab <alloc_block_BF+0x23e>
  8028a1:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8028a4:	8b 00                	mov    (%eax),%eax
  8028a6:	a3 48 41 80 00       	mov    %eax,0x804148
  8028ab:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8028ae:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8028b4:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8028b7:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8028be:	a1 54 41 80 00       	mov    0x804154,%eax
  8028c3:	48                   	dec    %eax
  8028c4:	a3 54 41 80 00       	mov    %eax,0x804154
			newblk->size = versize;
  8028c9:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8028cc:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8028cf:	89 50 0c             	mov    %edx,0xc(%eax)
			newblk->sva = newveradd;
  8028d2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8028d5:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8028d8:	89 50 08             	mov    %edx,0x8(%eax)
			blk->size = blk->size - versize;
  8028db:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028de:	8b 40 0c             	mov    0xc(%eax),%eax
  8028e1:	2b 45 e8             	sub    -0x18(%ebp),%eax
  8028e4:	89 c2                	mov    %eax,%edx
  8028e6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028e9:	89 50 0c             	mov    %edx,0xc(%eax)
			blk->sva+= newblk->size;
  8028ec:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028ef:	8b 50 08             	mov    0x8(%eax),%edx
  8028f2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8028f5:	8b 40 0c             	mov    0xc(%eax),%eax
  8028f8:	01 c2                	add    %eax,%edx
  8028fa:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028fd:	89 50 08             	mov    %edx,0x8(%eax)
			return newblk;
  802900:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802903:	eb 3b                	jmp    802940 <alloc_block_BF+0x2d3>
		{
	       newsize = blk->size;
		   newveradd = blk->sva;
		}
	}
	LIST_FOREACH(blk, &FreeMemBlocksList)
  802905:	a1 40 41 80 00       	mov    0x804140,%eax
  80290a:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80290d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802911:	74 07                	je     80291a <alloc_block_BF+0x2ad>
  802913:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802916:	8b 00                	mov    (%eax),%eax
  802918:	eb 05                	jmp    80291f <alloc_block_BF+0x2b2>
  80291a:	b8 00 00 00 00       	mov    $0x0,%eax
  80291f:	a3 40 41 80 00       	mov    %eax,0x804140
  802924:	a1 40 41 80 00       	mov    0x804140,%eax
  802929:	85 c0                	test   %eax,%eax
  80292b:	0f 85 f8 fe ff ff    	jne    802829 <alloc_block_BF+0x1bc>
  802931:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802935:	0f 85 ee fe ff ff    	jne    802829 <alloc_block_BF+0x1bc>
			blk->size = blk->size - versize;
			blk->sva+= newblk->size;
			return newblk;
		}
	}
	return NULL;
  80293b:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802940:	c9                   	leave  
  802941:	c3                   	ret    

00802942 <alloc_block_NF>:
//=========================================
// [7] ALLOCATE BLOCK BY NEXT FIT:
//=========================================
struct MemBlock *last_allocate;
struct MemBlock *alloc_block_NF(uint32 size)
{
  802942:	55                   	push   %ebp
  802943:	89 e5                	mov    %esp,%ebp
  802945:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1 - BONUS] [DYNAMIC ALLOCATOR] alloc_block_NF
	// Write your code here, remove the panic and write your code
	//panic("alloc_block_NF() is not implemented yet...!!");
	uint32 versize = size;
  802948:	8b 45 08             	mov    0x8(%ebp),%eax
  80294b:	89 45 f0             	mov    %eax,-0x10(%ebp)
	struct MemBlock* blk;
	struct MemBlock* newblk = LIST_FIRST(&AvailableMemBlocksList);
  80294e:	a1 48 41 80 00       	mov    0x804148,%eax
  802953:	89 45 ec             	mov    %eax,-0x14(%ebp)

	LIST_FOREACH(blk,&FreeMemBlocksList)
  802956:	a1 38 41 80 00       	mov    0x804138,%eax
  80295b:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80295e:	e9 77 01 00 00       	jmp    802ada <alloc_block_NF+0x198>
	{
		if(blk->size == versize)
  802963:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802966:	8b 40 0c             	mov    0xc(%eax),%eax
  802969:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  80296c:	0f 85 8a 00 00 00    	jne    8029fc <alloc_block_NF+0xba>
		{
			LIST_REMOVE(&FreeMemBlocksList,blk);
  802972:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802976:	75 17                	jne    80298f <alloc_block_NF+0x4d>
  802978:	83 ec 04             	sub    $0x4,%esp
  80297b:	68 28 3f 80 00       	push   $0x803f28
  802980:	68 f7 00 00 00       	push   $0xf7
  802985:	68 b7 3e 80 00       	push   $0x803eb7
  80298a:	e8 6d da ff ff       	call   8003fc <_panic>
  80298f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802992:	8b 00                	mov    (%eax),%eax
  802994:	85 c0                	test   %eax,%eax
  802996:	74 10                	je     8029a8 <alloc_block_NF+0x66>
  802998:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80299b:	8b 00                	mov    (%eax),%eax
  80299d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8029a0:	8b 52 04             	mov    0x4(%edx),%edx
  8029a3:	89 50 04             	mov    %edx,0x4(%eax)
  8029a6:	eb 0b                	jmp    8029b3 <alloc_block_NF+0x71>
  8029a8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029ab:	8b 40 04             	mov    0x4(%eax),%eax
  8029ae:	a3 3c 41 80 00       	mov    %eax,0x80413c
  8029b3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029b6:	8b 40 04             	mov    0x4(%eax),%eax
  8029b9:	85 c0                	test   %eax,%eax
  8029bb:	74 0f                	je     8029cc <alloc_block_NF+0x8a>
  8029bd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029c0:	8b 40 04             	mov    0x4(%eax),%eax
  8029c3:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8029c6:	8b 12                	mov    (%edx),%edx
  8029c8:	89 10                	mov    %edx,(%eax)
  8029ca:	eb 0a                	jmp    8029d6 <alloc_block_NF+0x94>
  8029cc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029cf:	8b 00                	mov    (%eax),%eax
  8029d1:	a3 38 41 80 00       	mov    %eax,0x804138
  8029d6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029d9:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8029df:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029e2:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8029e9:	a1 44 41 80 00       	mov    0x804144,%eax
  8029ee:	48                   	dec    %eax
  8029ef:	a3 44 41 80 00       	mov    %eax,0x804144
			return blk;
  8029f4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029f7:	e9 11 01 00 00       	jmp    802b0d <alloc_block_NF+0x1cb>
		}
		else if(blk->size > versize)
  8029fc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029ff:	8b 40 0c             	mov    0xc(%eax),%eax
  802a02:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  802a05:	0f 86 c7 00 00 00    	jbe    802ad2 <alloc_block_NF+0x190>
		{
			LIST_REMOVE(&AvailableMemBlocksList,newblk);
  802a0b:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802a0f:	75 17                	jne    802a28 <alloc_block_NF+0xe6>
  802a11:	83 ec 04             	sub    $0x4,%esp
  802a14:	68 28 3f 80 00       	push   $0x803f28
  802a19:	68 fc 00 00 00       	push   $0xfc
  802a1e:	68 b7 3e 80 00       	push   $0x803eb7
  802a23:	e8 d4 d9 ff ff       	call   8003fc <_panic>
  802a28:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802a2b:	8b 00                	mov    (%eax),%eax
  802a2d:	85 c0                	test   %eax,%eax
  802a2f:	74 10                	je     802a41 <alloc_block_NF+0xff>
  802a31:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802a34:	8b 00                	mov    (%eax),%eax
  802a36:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802a39:	8b 52 04             	mov    0x4(%edx),%edx
  802a3c:	89 50 04             	mov    %edx,0x4(%eax)
  802a3f:	eb 0b                	jmp    802a4c <alloc_block_NF+0x10a>
  802a41:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802a44:	8b 40 04             	mov    0x4(%eax),%eax
  802a47:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802a4c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802a4f:	8b 40 04             	mov    0x4(%eax),%eax
  802a52:	85 c0                	test   %eax,%eax
  802a54:	74 0f                	je     802a65 <alloc_block_NF+0x123>
  802a56:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802a59:	8b 40 04             	mov    0x4(%eax),%eax
  802a5c:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802a5f:	8b 12                	mov    (%edx),%edx
  802a61:	89 10                	mov    %edx,(%eax)
  802a63:	eb 0a                	jmp    802a6f <alloc_block_NF+0x12d>
  802a65:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802a68:	8b 00                	mov    (%eax),%eax
  802a6a:	a3 48 41 80 00       	mov    %eax,0x804148
  802a6f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802a72:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802a78:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802a7b:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802a82:	a1 54 41 80 00       	mov    0x804154,%eax
  802a87:	48                   	dec    %eax
  802a88:	a3 54 41 80 00       	mov    %eax,0x804154
			newblk->size = versize;
  802a8d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802a90:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802a93:	89 50 0c             	mov    %edx,0xc(%eax)
			blk->size = blk->size-versize;
  802a96:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a99:	8b 40 0c             	mov    0xc(%eax),%eax
  802a9c:	2b 45 f0             	sub    -0x10(%ebp),%eax
  802a9f:	89 c2                	mov    %eax,%edx
  802aa1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802aa4:	89 50 0c             	mov    %edx,0xc(%eax)
			uint32 newveradd = blk->sva;
  802aa7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802aaa:	8b 40 08             	mov    0x8(%eax),%eax
  802aad:	89 45 e8             	mov    %eax,-0x18(%ebp)
			blk->sva+=newblk->size;
  802ab0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ab3:	8b 50 08             	mov    0x8(%eax),%edx
  802ab6:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802ab9:	8b 40 0c             	mov    0xc(%eax),%eax
  802abc:	01 c2                	add    %eax,%edx
  802abe:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ac1:	89 50 08             	mov    %edx,0x8(%eax)
			newblk->sva = newveradd;
  802ac4:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802ac7:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802aca:	89 50 08             	mov    %edx,0x8(%eax)
			return newblk;
  802acd:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802ad0:	eb 3b                	jmp    802b0d <alloc_block_NF+0x1cb>
	//panic("alloc_block_NF() is not implemented yet...!!");
	uint32 versize = size;
	struct MemBlock* blk;
	struct MemBlock* newblk = LIST_FIRST(&AvailableMemBlocksList);

	LIST_FOREACH(blk,&FreeMemBlocksList)
  802ad2:	a1 40 41 80 00       	mov    0x804140,%eax
  802ad7:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802ada:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802ade:	74 07                	je     802ae7 <alloc_block_NF+0x1a5>
  802ae0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ae3:	8b 00                	mov    (%eax),%eax
  802ae5:	eb 05                	jmp    802aec <alloc_block_NF+0x1aa>
  802ae7:	b8 00 00 00 00       	mov    $0x0,%eax
  802aec:	a3 40 41 80 00       	mov    %eax,0x804140
  802af1:	a1 40 41 80 00       	mov    0x804140,%eax
  802af6:	85 c0                	test   %eax,%eax
  802af8:	0f 85 65 fe ff ff    	jne    802963 <alloc_block_NF+0x21>
  802afe:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802b02:	0f 85 5b fe ff ff    	jne    802963 <alloc_block_NF+0x21>
			blk->sva+=newblk->size;
			newblk->sva = newveradd;
			return newblk;
		}
	}
	return NULL;
  802b08:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802b0d:	c9                   	leave  
  802b0e:	c3                   	ret    

00802b0f <addToAvailMemBlocksList>:

//===================================================
// [8] INSERT BLOCK (SORTED WITH MERGE) IN FREE LIST:
//===================================================
void addToAvailMemBlocksList(struct MemBlock *blockToInsert)
{
  802b0f:	55                   	push   %ebp
  802b10:	89 e5                	mov    %esp,%ebp
  802b12:	83 ec 08             	sub    $0x8,%esp
	blockToInsert->sva = 0;
  802b15:	8b 45 08             	mov    0x8(%ebp),%eax
  802b18:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
	blockToInsert->size = 0;
  802b1f:	8b 45 08             	mov    0x8(%ebp),%eax
  802b22:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
	//add to avail
	LIST_INSERT_TAIL(&AvailableMemBlocksList, blockToInsert);
  802b29:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802b2d:	75 17                	jne    802b46 <addToAvailMemBlocksList+0x37>
  802b2f:	83 ec 04             	sub    $0x4,%esp
  802b32:	68 d0 3e 80 00       	push   $0x803ed0
  802b37:	68 10 01 00 00       	push   $0x110
  802b3c:	68 b7 3e 80 00       	push   $0x803eb7
  802b41:	e8 b6 d8 ff ff       	call   8003fc <_panic>
  802b46:	8b 15 4c 41 80 00    	mov    0x80414c,%edx
  802b4c:	8b 45 08             	mov    0x8(%ebp),%eax
  802b4f:	89 50 04             	mov    %edx,0x4(%eax)
  802b52:	8b 45 08             	mov    0x8(%ebp),%eax
  802b55:	8b 40 04             	mov    0x4(%eax),%eax
  802b58:	85 c0                	test   %eax,%eax
  802b5a:	74 0c                	je     802b68 <addToAvailMemBlocksList+0x59>
  802b5c:	a1 4c 41 80 00       	mov    0x80414c,%eax
  802b61:	8b 55 08             	mov    0x8(%ebp),%edx
  802b64:	89 10                	mov    %edx,(%eax)
  802b66:	eb 08                	jmp    802b70 <addToAvailMemBlocksList+0x61>
  802b68:	8b 45 08             	mov    0x8(%ebp),%eax
  802b6b:	a3 48 41 80 00       	mov    %eax,0x804148
  802b70:	8b 45 08             	mov    0x8(%ebp),%eax
  802b73:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802b78:	8b 45 08             	mov    0x8(%ebp),%eax
  802b7b:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802b81:	a1 54 41 80 00       	mov    0x804154,%eax
  802b86:	40                   	inc    %eax
  802b87:	a3 54 41 80 00       	mov    %eax,0x804154
}
  802b8c:	90                   	nop
  802b8d:	c9                   	leave  
  802b8e:	c3                   	ret    

00802b8f <insert_sorted_with_merge_freeList>:
void insert_sorted_with_merge_freeList(struct MemBlock *blockToInsert)
{
  802b8f:	55                   	push   %ebp
  802b90:	89 e5                	mov    %esp,%ebp
  802b92:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] insert_sorted_with_merge_freeList
	// Write your code here, remove the panic and write your code

	struct MemBlock* last = LIST_LAST(&FreeMemBlocksList);
  802b95:	a1 3c 41 80 00       	mov    0x80413c,%eax
  802b9a:	89 45 f0             	mov    %eax,-0x10(%ebp)
	//check if list empty
	if (LIST_SIZE(&(FreeMemBlocksList)) == 0)
  802b9d:	a1 44 41 80 00       	mov    0x804144,%eax
  802ba2:	85 c0                	test   %eax,%eax
  802ba4:	75 68                	jne    802c0e <insert_sorted_with_merge_freeList+0x7f>
		LIST_INSERT_HEAD(&FreeMemBlocksList, blockToInsert);
  802ba6:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802baa:	75 17                	jne    802bc3 <insert_sorted_with_merge_freeList+0x34>
  802bac:	83 ec 04             	sub    $0x4,%esp
  802baf:	68 94 3e 80 00       	push   $0x803e94
  802bb4:	68 1a 01 00 00       	push   $0x11a
  802bb9:	68 b7 3e 80 00       	push   $0x803eb7
  802bbe:	e8 39 d8 ff ff       	call   8003fc <_panic>
  802bc3:	8b 15 38 41 80 00    	mov    0x804138,%edx
  802bc9:	8b 45 08             	mov    0x8(%ebp),%eax
  802bcc:	89 10                	mov    %edx,(%eax)
  802bce:	8b 45 08             	mov    0x8(%ebp),%eax
  802bd1:	8b 00                	mov    (%eax),%eax
  802bd3:	85 c0                	test   %eax,%eax
  802bd5:	74 0d                	je     802be4 <insert_sorted_with_merge_freeList+0x55>
  802bd7:	a1 38 41 80 00       	mov    0x804138,%eax
  802bdc:	8b 55 08             	mov    0x8(%ebp),%edx
  802bdf:	89 50 04             	mov    %edx,0x4(%eax)
  802be2:	eb 08                	jmp    802bec <insert_sorted_with_merge_freeList+0x5d>
  802be4:	8b 45 08             	mov    0x8(%ebp),%eax
  802be7:	a3 3c 41 80 00       	mov    %eax,0x80413c
  802bec:	8b 45 08             	mov    0x8(%ebp),%eax
  802bef:	a3 38 41 80 00       	mov    %eax,0x804138
  802bf4:	8b 45 08             	mov    0x8(%ebp),%eax
  802bf7:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802bfe:	a1 44 41 80 00       	mov    0x804144,%eax
  802c03:	40                   	inc    %eax
  802c04:	a3 44 41 80 00       	mov    %eax,0x804144
		}
	}

	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  802c09:	e9 c5 03 00 00       	jmp    802fd3 <insert_sorted_with_merge_freeList+0x444>
	struct MemBlock* last = LIST_LAST(&FreeMemBlocksList);
	//check if list empty
	if (LIST_SIZE(&(FreeMemBlocksList)) == 0)
		LIST_INSERT_HEAD(&FreeMemBlocksList, blockToInsert);
	//check if it's position is at last
	else if (last->sva < blockToInsert->sva) {
  802c0e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c11:	8b 50 08             	mov    0x8(%eax),%edx
  802c14:	8b 45 08             	mov    0x8(%ebp),%eax
  802c17:	8b 40 08             	mov    0x8(%eax),%eax
  802c1a:	39 c2                	cmp    %eax,%edx
  802c1c:	0f 83 b2 00 00 00    	jae    802cd4 <insert_sorted_with_merge_freeList+0x145>

		//if i have to merge
		if (last->sva + last->size == blockToInsert->sva) {
  802c22:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c25:	8b 50 08             	mov    0x8(%eax),%edx
  802c28:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c2b:	8b 40 0c             	mov    0xc(%eax),%eax
  802c2e:	01 c2                	add    %eax,%edx
  802c30:	8b 45 08             	mov    0x8(%ebp),%eax
  802c33:	8b 40 08             	mov    0x8(%eax),%eax
  802c36:	39 c2                	cmp    %eax,%edx
  802c38:	75 27                	jne    802c61 <insert_sorted_with_merge_freeList+0xd2>
			last->size = last->size + blockToInsert->size;
  802c3a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c3d:	8b 50 0c             	mov    0xc(%eax),%edx
  802c40:	8b 45 08             	mov    0x8(%ebp),%eax
  802c43:	8b 40 0c             	mov    0xc(%eax),%eax
  802c46:	01 c2                	add    %eax,%edx
  802c48:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c4b:	89 50 0c             	mov    %edx,0xc(%eax)
			addToAvailMemBlocksList(blockToInsert);
  802c4e:	83 ec 0c             	sub    $0xc,%esp
  802c51:	ff 75 08             	pushl  0x8(%ebp)
  802c54:	e8 b6 fe ff ff       	call   802b0f <addToAvailMemBlocksList>
  802c59:	83 c4 10             	add    $0x10,%esp
		}
	}

	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  802c5c:	e9 72 03 00 00       	jmp    802fd3 <insert_sorted_with_merge_freeList+0x444>
		if (last->sva + last->size == blockToInsert->sva) {
			last->size = last->size + blockToInsert->size;
			addToAvailMemBlocksList(blockToInsert);

		} else {
			LIST_INSERT_AFTER(&FreeMemBlocksList, last, blockToInsert);
  802c61:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802c65:	74 06                	je     802c6d <insert_sorted_with_merge_freeList+0xde>
  802c67:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802c6b:	75 17                	jne    802c84 <insert_sorted_with_merge_freeList+0xf5>
  802c6d:	83 ec 04             	sub    $0x4,%esp
  802c70:	68 f4 3e 80 00       	push   $0x803ef4
  802c75:	68 24 01 00 00       	push   $0x124
  802c7a:	68 b7 3e 80 00       	push   $0x803eb7
  802c7f:	e8 78 d7 ff ff       	call   8003fc <_panic>
  802c84:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c87:	8b 10                	mov    (%eax),%edx
  802c89:	8b 45 08             	mov    0x8(%ebp),%eax
  802c8c:	89 10                	mov    %edx,(%eax)
  802c8e:	8b 45 08             	mov    0x8(%ebp),%eax
  802c91:	8b 00                	mov    (%eax),%eax
  802c93:	85 c0                	test   %eax,%eax
  802c95:	74 0b                	je     802ca2 <insert_sorted_with_merge_freeList+0x113>
  802c97:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c9a:	8b 00                	mov    (%eax),%eax
  802c9c:	8b 55 08             	mov    0x8(%ebp),%edx
  802c9f:	89 50 04             	mov    %edx,0x4(%eax)
  802ca2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802ca5:	8b 55 08             	mov    0x8(%ebp),%edx
  802ca8:	89 10                	mov    %edx,(%eax)
  802caa:	8b 45 08             	mov    0x8(%ebp),%eax
  802cad:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802cb0:	89 50 04             	mov    %edx,0x4(%eax)
  802cb3:	8b 45 08             	mov    0x8(%ebp),%eax
  802cb6:	8b 00                	mov    (%eax),%eax
  802cb8:	85 c0                	test   %eax,%eax
  802cba:	75 08                	jne    802cc4 <insert_sorted_with_merge_freeList+0x135>
  802cbc:	8b 45 08             	mov    0x8(%ebp),%eax
  802cbf:	a3 3c 41 80 00       	mov    %eax,0x80413c
  802cc4:	a1 44 41 80 00       	mov    0x804144,%eax
  802cc9:	40                   	inc    %eax
  802cca:	a3 44 41 80 00       	mov    %eax,0x804144
		}
	}

	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  802ccf:	e9 ff 02 00 00       	jmp    802fd3 <insert_sorted_with_merge_freeList+0x444>
		} else {
			LIST_INSERT_AFTER(&FreeMemBlocksList, last, blockToInsert);
		}
	} else {
		struct MemBlock *iterator;
		LIST_FOREACH(iterator, &(FreeMemBlocksList))
  802cd4:	a1 38 41 80 00       	mov    0x804138,%eax
  802cd9:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802cdc:	e9 c2 02 00 00       	jmp    802fa3 <insert_sorted_with_merge_freeList+0x414>
		{

			if (iterator->sva > blockToInsert->sva) {
  802ce1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ce4:	8b 50 08             	mov    0x8(%eax),%edx
  802ce7:	8b 45 08             	mov    0x8(%ebp),%eax
  802cea:	8b 40 08             	mov    0x8(%eax),%eax
  802ced:	39 c2                	cmp    %eax,%edx
  802cef:	0f 86 a6 02 00 00    	jbe    802f9b <insert_sorted_with_merge_freeList+0x40c>

				struct MemBlock* prev = LIST_PREV(iterator);
  802cf5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cf8:	8b 40 04             	mov    0x4(%eax),%eax
  802cfb:	89 45 ec             	mov    %eax,-0x14(%ebp)
				if (prev == NULL) {
  802cfe:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802d02:	0f 85 ba 00 00 00    	jne    802dc2 <insert_sorted_with_merge_freeList+0x233>
					//check merge
					if (blockToInsert->size + blockToInsert->sva
  802d08:	8b 45 08             	mov    0x8(%ebp),%eax
  802d0b:	8b 50 0c             	mov    0xc(%eax),%edx
  802d0e:	8b 45 08             	mov    0x8(%ebp),%eax
  802d11:	8b 40 08             	mov    0x8(%eax),%eax
  802d14:	01 c2                	add    %eax,%edx
							== iterator->sva) {
  802d16:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d19:	8b 40 08             	mov    0x8(%eax),%eax
			if (iterator->sva > blockToInsert->sva) {

				struct MemBlock* prev = LIST_PREV(iterator);
				if (prev == NULL) {
					//check merge
					if (blockToInsert->size + blockToInsert->sva
  802d1c:	39 c2                	cmp    %eax,%edx
  802d1e:	75 33                	jne    802d53 <insert_sorted_with_merge_freeList+0x1c4>
							== iterator->sva) {
						iterator->sva = blockToInsert->sva;
  802d20:	8b 45 08             	mov    0x8(%ebp),%eax
  802d23:	8b 50 08             	mov    0x8(%eax),%edx
  802d26:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d29:	89 50 08             	mov    %edx,0x8(%eax)
						iterator->size = iterator->size + blockToInsert->size;
  802d2c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d2f:	8b 50 0c             	mov    0xc(%eax),%edx
  802d32:	8b 45 08             	mov    0x8(%ebp),%eax
  802d35:	8b 40 0c             	mov    0xc(%eax),%eax
  802d38:	01 c2                	add    %eax,%edx
  802d3a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d3d:	89 50 0c             	mov    %edx,0xc(%eax)
						addToAvailMemBlocksList(blockToInsert);
  802d40:	83 ec 0c             	sub    $0xc,%esp
  802d43:	ff 75 08             	pushl  0x8(%ebp)
  802d46:	e8 c4 fd ff ff       	call   802b0f <addToAvailMemBlocksList>
  802d4b:	83 c4 10             	add    $0x10,%esp

					else {
						LIST_INSERT_BEFORE(&FreeMemBlocksList, iterator,
								blockToInsert);
					}
					break;
  802d4e:	e9 80 02 00 00       	jmp    802fd3 <insert_sorted_with_merge_freeList+0x444>
						addToAvailMemBlocksList(blockToInsert);

					}

					else {
						LIST_INSERT_BEFORE(&FreeMemBlocksList, iterator,
  802d53:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802d57:	74 06                	je     802d5f <insert_sorted_with_merge_freeList+0x1d0>
  802d59:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802d5d:	75 17                	jne    802d76 <insert_sorted_with_merge_freeList+0x1e7>
  802d5f:	83 ec 04             	sub    $0x4,%esp
  802d62:	68 48 3f 80 00       	push   $0x803f48
  802d67:	68 3a 01 00 00       	push   $0x13a
  802d6c:	68 b7 3e 80 00       	push   $0x803eb7
  802d71:	e8 86 d6 ff ff       	call   8003fc <_panic>
  802d76:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d79:	8b 50 04             	mov    0x4(%eax),%edx
  802d7c:	8b 45 08             	mov    0x8(%ebp),%eax
  802d7f:	89 50 04             	mov    %edx,0x4(%eax)
  802d82:	8b 45 08             	mov    0x8(%ebp),%eax
  802d85:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802d88:	89 10                	mov    %edx,(%eax)
  802d8a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d8d:	8b 40 04             	mov    0x4(%eax),%eax
  802d90:	85 c0                	test   %eax,%eax
  802d92:	74 0d                	je     802da1 <insert_sorted_with_merge_freeList+0x212>
  802d94:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d97:	8b 40 04             	mov    0x4(%eax),%eax
  802d9a:	8b 55 08             	mov    0x8(%ebp),%edx
  802d9d:	89 10                	mov    %edx,(%eax)
  802d9f:	eb 08                	jmp    802da9 <insert_sorted_with_merge_freeList+0x21a>
  802da1:	8b 45 08             	mov    0x8(%ebp),%eax
  802da4:	a3 38 41 80 00       	mov    %eax,0x804138
  802da9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802dac:	8b 55 08             	mov    0x8(%ebp),%edx
  802daf:	89 50 04             	mov    %edx,0x4(%eax)
  802db2:	a1 44 41 80 00       	mov    0x804144,%eax
  802db7:	40                   	inc    %eax
  802db8:	a3 44 41 80 00       	mov    %eax,0x804144
								blockToInsert);
					}
					break;
  802dbd:	e9 11 02 00 00       	jmp    802fd3 <insert_sorted_with_merge_freeList+0x444>
				} else {
					//prev and next merge
					if (prev->sva + prev->size + blockToInsert->size
  802dc2:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802dc5:	8b 50 08             	mov    0x8(%eax),%edx
  802dc8:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802dcb:	8b 40 0c             	mov    0xc(%eax),%eax
  802dce:	01 c2                	add    %eax,%edx
  802dd0:	8b 45 08             	mov    0x8(%ebp),%eax
  802dd3:	8b 40 0c             	mov    0xc(%eax),%eax
  802dd6:	01 c2                	add    %eax,%edx
							== iterator->sva) {
  802dd8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ddb:	8b 40 08             	mov    0x8(%eax),%eax
								blockToInsert);
					}
					break;
				} else {
					//prev and next merge
					if (prev->sva + prev->size + blockToInsert->size
  802dde:	39 c2                	cmp    %eax,%edx
  802de0:	0f 85 bf 00 00 00    	jne    802ea5 <insert_sorted_with_merge_freeList+0x316>
							== iterator->sva) {
						prev->size = prev->size + blockToInsert->size
  802de6:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802de9:	8b 50 0c             	mov    0xc(%eax),%edx
  802dec:	8b 45 08             	mov    0x8(%ebp),%eax
  802def:	8b 40 0c             	mov    0xc(%eax),%eax
  802df2:	01 c2                	add    %eax,%edx
								+ iterator->size;
  802df4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802df7:	8b 40 0c             	mov    0xc(%eax),%eax
  802dfa:	01 c2                	add    %eax,%edx
					break;
				} else {
					//prev and next merge
					if (prev->sva + prev->size + blockToInsert->size
							== iterator->sva) {
						prev->size = prev->size + blockToInsert->size
  802dfc:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802dff:	89 50 0c             	mov    %edx,0xc(%eax)
								+ iterator->size;
						LIST_REMOVE(&FreeMemBlocksList, iterator);
  802e02:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802e06:	75 17                	jne    802e1f <insert_sorted_with_merge_freeList+0x290>
  802e08:	83 ec 04             	sub    $0x4,%esp
  802e0b:	68 28 3f 80 00       	push   $0x803f28
  802e10:	68 43 01 00 00       	push   $0x143
  802e15:	68 b7 3e 80 00       	push   $0x803eb7
  802e1a:	e8 dd d5 ff ff       	call   8003fc <_panic>
  802e1f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e22:	8b 00                	mov    (%eax),%eax
  802e24:	85 c0                	test   %eax,%eax
  802e26:	74 10                	je     802e38 <insert_sorted_with_merge_freeList+0x2a9>
  802e28:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e2b:	8b 00                	mov    (%eax),%eax
  802e2d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802e30:	8b 52 04             	mov    0x4(%edx),%edx
  802e33:	89 50 04             	mov    %edx,0x4(%eax)
  802e36:	eb 0b                	jmp    802e43 <insert_sorted_with_merge_freeList+0x2b4>
  802e38:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e3b:	8b 40 04             	mov    0x4(%eax),%eax
  802e3e:	a3 3c 41 80 00       	mov    %eax,0x80413c
  802e43:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e46:	8b 40 04             	mov    0x4(%eax),%eax
  802e49:	85 c0                	test   %eax,%eax
  802e4b:	74 0f                	je     802e5c <insert_sorted_with_merge_freeList+0x2cd>
  802e4d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e50:	8b 40 04             	mov    0x4(%eax),%eax
  802e53:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802e56:	8b 12                	mov    (%edx),%edx
  802e58:	89 10                	mov    %edx,(%eax)
  802e5a:	eb 0a                	jmp    802e66 <insert_sorted_with_merge_freeList+0x2d7>
  802e5c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e5f:	8b 00                	mov    (%eax),%eax
  802e61:	a3 38 41 80 00       	mov    %eax,0x804138
  802e66:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e69:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802e6f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e72:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802e79:	a1 44 41 80 00       	mov    0x804144,%eax
  802e7e:	48                   	dec    %eax
  802e7f:	a3 44 41 80 00       	mov    %eax,0x804144
						addToAvailMemBlocksList(blockToInsert);
  802e84:	83 ec 0c             	sub    $0xc,%esp
  802e87:	ff 75 08             	pushl  0x8(%ebp)
  802e8a:	e8 80 fc ff ff       	call   802b0f <addToAvailMemBlocksList>
  802e8f:	83 c4 10             	add    $0x10,%esp
						addToAvailMemBlocksList(iterator);
  802e92:	83 ec 0c             	sub    $0xc,%esp
  802e95:	ff 75 f4             	pushl  -0xc(%ebp)
  802e98:	e8 72 fc ff ff       	call   802b0f <addToAvailMemBlocksList>
  802e9d:	83 c4 10             	add    $0x10,%esp
					//Insert
					else {
						LIST_INSERT_BEFORE(&FreeMemBlocksList, iterator,
								blockToInsert);
					}
					break;
  802ea0:	e9 2e 01 00 00       	jmp    802fd3 <insert_sorted_with_merge_freeList+0x444>
						LIST_REMOVE(&FreeMemBlocksList, iterator);
						addToAvailMemBlocksList(blockToInsert);
						addToAvailMemBlocksList(iterator);
					}
					//previous merge
					else if (prev->sva + prev->size == blockToInsert->sva) {
  802ea5:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802ea8:	8b 50 08             	mov    0x8(%eax),%edx
  802eab:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802eae:	8b 40 0c             	mov    0xc(%eax),%eax
  802eb1:	01 c2                	add    %eax,%edx
  802eb3:	8b 45 08             	mov    0x8(%ebp),%eax
  802eb6:	8b 40 08             	mov    0x8(%eax),%eax
  802eb9:	39 c2                	cmp    %eax,%edx
  802ebb:	75 27                	jne    802ee4 <insert_sorted_with_merge_freeList+0x355>
						prev->size = prev->size + blockToInsert->size;
  802ebd:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802ec0:	8b 50 0c             	mov    0xc(%eax),%edx
  802ec3:	8b 45 08             	mov    0x8(%ebp),%eax
  802ec6:	8b 40 0c             	mov    0xc(%eax),%eax
  802ec9:	01 c2                	add    %eax,%edx
  802ecb:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802ece:	89 50 0c             	mov    %edx,0xc(%eax)
						addToAvailMemBlocksList(blockToInsert);
  802ed1:	83 ec 0c             	sub    $0xc,%esp
  802ed4:	ff 75 08             	pushl  0x8(%ebp)
  802ed7:	e8 33 fc ff ff       	call   802b0f <addToAvailMemBlocksList>
  802edc:	83 c4 10             	add    $0x10,%esp
					//Insert
					else {
						LIST_INSERT_BEFORE(&FreeMemBlocksList, iterator,
								blockToInsert);
					}
					break;
  802edf:	e9 ef 00 00 00       	jmp    802fd3 <insert_sorted_with_merge_freeList+0x444>
					else if (prev->sva + prev->size == blockToInsert->sva) {
						prev->size = prev->size + blockToInsert->size;
						addToAvailMemBlocksList(blockToInsert);
					}
					//next merge
					else if (blockToInsert->size + blockToInsert->sva
  802ee4:	8b 45 08             	mov    0x8(%ebp),%eax
  802ee7:	8b 50 0c             	mov    0xc(%eax),%edx
  802eea:	8b 45 08             	mov    0x8(%ebp),%eax
  802eed:	8b 40 08             	mov    0x8(%eax),%eax
  802ef0:	01 c2                	add    %eax,%edx
							== iterator->sva) {
  802ef2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ef5:	8b 40 08             	mov    0x8(%eax),%eax
					else if (prev->sva + prev->size == blockToInsert->sva) {
						prev->size = prev->size + blockToInsert->size;
						addToAvailMemBlocksList(blockToInsert);
					}
					//next merge
					else if (blockToInsert->size + blockToInsert->sva
  802ef8:	39 c2                	cmp    %eax,%edx
  802efa:	75 33                	jne    802f2f <insert_sorted_with_merge_freeList+0x3a0>
							== iterator->sva) {
						iterator->sva = blockToInsert->sva;
  802efc:	8b 45 08             	mov    0x8(%ebp),%eax
  802eff:	8b 50 08             	mov    0x8(%eax),%edx
  802f02:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f05:	89 50 08             	mov    %edx,0x8(%eax)
						iterator->size = iterator->size + blockToInsert->size;
  802f08:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f0b:	8b 50 0c             	mov    0xc(%eax),%edx
  802f0e:	8b 45 08             	mov    0x8(%ebp),%eax
  802f11:	8b 40 0c             	mov    0xc(%eax),%eax
  802f14:	01 c2                	add    %eax,%edx
  802f16:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f19:	89 50 0c             	mov    %edx,0xc(%eax)
						addToAvailMemBlocksList(blockToInsert);
  802f1c:	83 ec 0c             	sub    $0xc,%esp
  802f1f:	ff 75 08             	pushl  0x8(%ebp)
  802f22:	e8 e8 fb ff ff       	call   802b0f <addToAvailMemBlocksList>
  802f27:	83 c4 10             	add    $0x10,%esp
					//Insert
					else {
						LIST_INSERT_BEFORE(&FreeMemBlocksList, iterator,
								blockToInsert);
					}
					break;
  802f2a:	e9 a4 00 00 00       	jmp    802fd3 <insert_sorted_with_merge_freeList+0x444>
						iterator->size = iterator->size + blockToInsert->size;
						addToAvailMemBlocksList(blockToInsert);
					}
					//Insert
					else {
						LIST_INSERT_BEFORE(&FreeMemBlocksList, iterator,
  802f2f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802f33:	74 06                	je     802f3b <insert_sorted_with_merge_freeList+0x3ac>
  802f35:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802f39:	75 17                	jne    802f52 <insert_sorted_with_merge_freeList+0x3c3>
  802f3b:	83 ec 04             	sub    $0x4,%esp
  802f3e:	68 48 3f 80 00       	push   $0x803f48
  802f43:	68 56 01 00 00       	push   $0x156
  802f48:	68 b7 3e 80 00       	push   $0x803eb7
  802f4d:	e8 aa d4 ff ff       	call   8003fc <_panic>
  802f52:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f55:	8b 50 04             	mov    0x4(%eax),%edx
  802f58:	8b 45 08             	mov    0x8(%ebp),%eax
  802f5b:	89 50 04             	mov    %edx,0x4(%eax)
  802f5e:	8b 45 08             	mov    0x8(%ebp),%eax
  802f61:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802f64:	89 10                	mov    %edx,(%eax)
  802f66:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f69:	8b 40 04             	mov    0x4(%eax),%eax
  802f6c:	85 c0                	test   %eax,%eax
  802f6e:	74 0d                	je     802f7d <insert_sorted_with_merge_freeList+0x3ee>
  802f70:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f73:	8b 40 04             	mov    0x4(%eax),%eax
  802f76:	8b 55 08             	mov    0x8(%ebp),%edx
  802f79:	89 10                	mov    %edx,(%eax)
  802f7b:	eb 08                	jmp    802f85 <insert_sorted_with_merge_freeList+0x3f6>
  802f7d:	8b 45 08             	mov    0x8(%ebp),%eax
  802f80:	a3 38 41 80 00       	mov    %eax,0x804138
  802f85:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f88:	8b 55 08             	mov    0x8(%ebp),%edx
  802f8b:	89 50 04             	mov    %edx,0x4(%eax)
  802f8e:	a1 44 41 80 00       	mov    0x804144,%eax
  802f93:	40                   	inc    %eax
  802f94:	a3 44 41 80 00       	mov    %eax,0x804144
								blockToInsert);
					}
					break;
  802f99:	eb 38                	jmp    802fd3 <insert_sorted_with_merge_freeList+0x444>
		} else {
			LIST_INSERT_AFTER(&FreeMemBlocksList, last, blockToInsert);
		}
	} else {
		struct MemBlock *iterator;
		LIST_FOREACH(iterator, &(FreeMemBlocksList))
  802f9b:	a1 40 41 80 00       	mov    0x804140,%eax
  802fa0:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802fa3:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802fa7:	74 07                	je     802fb0 <insert_sorted_with_merge_freeList+0x421>
  802fa9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802fac:	8b 00                	mov    (%eax),%eax
  802fae:	eb 05                	jmp    802fb5 <insert_sorted_with_merge_freeList+0x426>
  802fb0:	b8 00 00 00 00       	mov    $0x0,%eax
  802fb5:	a3 40 41 80 00       	mov    %eax,0x804140
  802fba:	a1 40 41 80 00       	mov    0x804140,%eax
  802fbf:	85 c0                	test   %eax,%eax
  802fc1:	0f 85 1a fd ff ff    	jne    802ce1 <insert_sorted_with_merge_freeList+0x152>
  802fc7:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802fcb:	0f 85 10 fd ff ff    	jne    802ce1 <insert_sorted_with_merge_freeList+0x152>
		}
	}

	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  802fd1:	eb 00                	jmp    802fd3 <insert_sorted_with_merge_freeList+0x444>
  802fd3:	90                   	nop
  802fd4:	c9                   	leave  
  802fd5:	c3                   	ret    
  802fd6:	66 90                	xchg   %ax,%ax

00802fd8 <__udivdi3>:
  802fd8:	55                   	push   %ebp
  802fd9:	57                   	push   %edi
  802fda:	56                   	push   %esi
  802fdb:	53                   	push   %ebx
  802fdc:	83 ec 1c             	sub    $0x1c,%esp
  802fdf:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  802fe3:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  802fe7:	8b 7c 24 38          	mov    0x38(%esp),%edi
  802feb:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  802fef:	89 ca                	mov    %ecx,%edx
  802ff1:	89 f8                	mov    %edi,%eax
  802ff3:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  802ff7:	85 f6                	test   %esi,%esi
  802ff9:	75 2d                	jne    803028 <__udivdi3+0x50>
  802ffb:	39 cf                	cmp    %ecx,%edi
  802ffd:	77 65                	ja     803064 <__udivdi3+0x8c>
  802fff:	89 fd                	mov    %edi,%ebp
  803001:	85 ff                	test   %edi,%edi
  803003:	75 0b                	jne    803010 <__udivdi3+0x38>
  803005:	b8 01 00 00 00       	mov    $0x1,%eax
  80300a:	31 d2                	xor    %edx,%edx
  80300c:	f7 f7                	div    %edi
  80300e:	89 c5                	mov    %eax,%ebp
  803010:	31 d2                	xor    %edx,%edx
  803012:	89 c8                	mov    %ecx,%eax
  803014:	f7 f5                	div    %ebp
  803016:	89 c1                	mov    %eax,%ecx
  803018:	89 d8                	mov    %ebx,%eax
  80301a:	f7 f5                	div    %ebp
  80301c:	89 cf                	mov    %ecx,%edi
  80301e:	89 fa                	mov    %edi,%edx
  803020:	83 c4 1c             	add    $0x1c,%esp
  803023:	5b                   	pop    %ebx
  803024:	5e                   	pop    %esi
  803025:	5f                   	pop    %edi
  803026:	5d                   	pop    %ebp
  803027:	c3                   	ret    
  803028:	39 ce                	cmp    %ecx,%esi
  80302a:	77 28                	ja     803054 <__udivdi3+0x7c>
  80302c:	0f bd fe             	bsr    %esi,%edi
  80302f:	83 f7 1f             	xor    $0x1f,%edi
  803032:	75 40                	jne    803074 <__udivdi3+0x9c>
  803034:	39 ce                	cmp    %ecx,%esi
  803036:	72 0a                	jb     803042 <__udivdi3+0x6a>
  803038:	3b 44 24 08          	cmp    0x8(%esp),%eax
  80303c:	0f 87 9e 00 00 00    	ja     8030e0 <__udivdi3+0x108>
  803042:	b8 01 00 00 00       	mov    $0x1,%eax
  803047:	89 fa                	mov    %edi,%edx
  803049:	83 c4 1c             	add    $0x1c,%esp
  80304c:	5b                   	pop    %ebx
  80304d:	5e                   	pop    %esi
  80304e:	5f                   	pop    %edi
  80304f:	5d                   	pop    %ebp
  803050:	c3                   	ret    
  803051:	8d 76 00             	lea    0x0(%esi),%esi
  803054:	31 ff                	xor    %edi,%edi
  803056:	31 c0                	xor    %eax,%eax
  803058:	89 fa                	mov    %edi,%edx
  80305a:	83 c4 1c             	add    $0x1c,%esp
  80305d:	5b                   	pop    %ebx
  80305e:	5e                   	pop    %esi
  80305f:	5f                   	pop    %edi
  803060:	5d                   	pop    %ebp
  803061:	c3                   	ret    
  803062:	66 90                	xchg   %ax,%ax
  803064:	89 d8                	mov    %ebx,%eax
  803066:	f7 f7                	div    %edi
  803068:	31 ff                	xor    %edi,%edi
  80306a:	89 fa                	mov    %edi,%edx
  80306c:	83 c4 1c             	add    $0x1c,%esp
  80306f:	5b                   	pop    %ebx
  803070:	5e                   	pop    %esi
  803071:	5f                   	pop    %edi
  803072:	5d                   	pop    %ebp
  803073:	c3                   	ret    
  803074:	bd 20 00 00 00       	mov    $0x20,%ebp
  803079:	89 eb                	mov    %ebp,%ebx
  80307b:	29 fb                	sub    %edi,%ebx
  80307d:	89 f9                	mov    %edi,%ecx
  80307f:	d3 e6                	shl    %cl,%esi
  803081:	89 c5                	mov    %eax,%ebp
  803083:	88 d9                	mov    %bl,%cl
  803085:	d3 ed                	shr    %cl,%ebp
  803087:	89 e9                	mov    %ebp,%ecx
  803089:	09 f1                	or     %esi,%ecx
  80308b:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  80308f:	89 f9                	mov    %edi,%ecx
  803091:	d3 e0                	shl    %cl,%eax
  803093:	89 c5                	mov    %eax,%ebp
  803095:	89 d6                	mov    %edx,%esi
  803097:	88 d9                	mov    %bl,%cl
  803099:	d3 ee                	shr    %cl,%esi
  80309b:	89 f9                	mov    %edi,%ecx
  80309d:	d3 e2                	shl    %cl,%edx
  80309f:	8b 44 24 08          	mov    0x8(%esp),%eax
  8030a3:	88 d9                	mov    %bl,%cl
  8030a5:	d3 e8                	shr    %cl,%eax
  8030a7:	09 c2                	or     %eax,%edx
  8030a9:	89 d0                	mov    %edx,%eax
  8030ab:	89 f2                	mov    %esi,%edx
  8030ad:	f7 74 24 0c          	divl   0xc(%esp)
  8030b1:	89 d6                	mov    %edx,%esi
  8030b3:	89 c3                	mov    %eax,%ebx
  8030b5:	f7 e5                	mul    %ebp
  8030b7:	39 d6                	cmp    %edx,%esi
  8030b9:	72 19                	jb     8030d4 <__udivdi3+0xfc>
  8030bb:	74 0b                	je     8030c8 <__udivdi3+0xf0>
  8030bd:	89 d8                	mov    %ebx,%eax
  8030bf:	31 ff                	xor    %edi,%edi
  8030c1:	e9 58 ff ff ff       	jmp    80301e <__udivdi3+0x46>
  8030c6:	66 90                	xchg   %ax,%ax
  8030c8:	8b 54 24 08          	mov    0x8(%esp),%edx
  8030cc:	89 f9                	mov    %edi,%ecx
  8030ce:	d3 e2                	shl    %cl,%edx
  8030d0:	39 c2                	cmp    %eax,%edx
  8030d2:	73 e9                	jae    8030bd <__udivdi3+0xe5>
  8030d4:	8d 43 ff             	lea    -0x1(%ebx),%eax
  8030d7:	31 ff                	xor    %edi,%edi
  8030d9:	e9 40 ff ff ff       	jmp    80301e <__udivdi3+0x46>
  8030de:	66 90                	xchg   %ax,%ax
  8030e0:	31 c0                	xor    %eax,%eax
  8030e2:	e9 37 ff ff ff       	jmp    80301e <__udivdi3+0x46>
  8030e7:	90                   	nop

008030e8 <__umoddi3>:
  8030e8:	55                   	push   %ebp
  8030e9:	57                   	push   %edi
  8030ea:	56                   	push   %esi
  8030eb:	53                   	push   %ebx
  8030ec:	83 ec 1c             	sub    $0x1c,%esp
  8030ef:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  8030f3:	8b 74 24 34          	mov    0x34(%esp),%esi
  8030f7:	8b 7c 24 38          	mov    0x38(%esp),%edi
  8030fb:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  8030ff:	89 44 24 0c          	mov    %eax,0xc(%esp)
  803103:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  803107:	89 f3                	mov    %esi,%ebx
  803109:	89 fa                	mov    %edi,%edx
  80310b:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  80310f:	89 34 24             	mov    %esi,(%esp)
  803112:	85 c0                	test   %eax,%eax
  803114:	75 1a                	jne    803130 <__umoddi3+0x48>
  803116:	39 f7                	cmp    %esi,%edi
  803118:	0f 86 a2 00 00 00    	jbe    8031c0 <__umoddi3+0xd8>
  80311e:	89 c8                	mov    %ecx,%eax
  803120:	89 f2                	mov    %esi,%edx
  803122:	f7 f7                	div    %edi
  803124:	89 d0                	mov    %edx,%eax
  803126:	31 d2                	xor    %edx,%edx
  803128:	83 c4 1c             	add    $0x1c,%esp
  80312b:	5b                   	pop    %ebx
  80312c:	5e                   	pop    %esi
  80312d:	5f                   	pop    %edi
  80312e:	5d                   	pop    %ebp
  80312f:	c3                   	ret    
  803130:	39 f0                	cmp    %esi,%eax
  803132:	0f 87 ac 00 00 00    	ja     8031e4 <__umoddi3+0xfc>
  803138:	0f bd e8             	bsr    %eax,%ebp
  80313b:	83 f5 1f             	xor    $0x1f,%ebp
  80313e:	0f 84 ac 00 00 00    	je     8031f0 <__umoddi3+0x108>
  803144:	bf 20 00 00 00       	mov    $0x20,%edi
  803149:	29 ef                	sub    %ebp,%edi
  80314b:	89 fe                	mov    %edi,%esi
  80314d:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  803151:	89 e9                	mov    %ebp,%ecx
  803153:	d3 e0                	shl    %cl,%eax
  803155:	89 d7                	mov    %edx,%edi
  803157:	89 f1                	mov    %esi,%ecx
  803159:	d3 ef                	shr    %cl,%edi
  80315b:	09 c7                	or     %eax,%edi
  80315d:	89 e9                	mov    %ebp,%ecx
  80315f:	d3 e2                	shl    %cl,%edx
  803161:	89 14 24             	mov    %edx,(%esp)
  803164:	89 d8                	mov    %ebx,%eax
  803166:	d3 e0                	shl    %cl,%eax
  803168:	89 c2                	mov    %eax,%edx
  80316a:	8b 44 24 08          	mov    0x8(%esp),%eax
  80316e:	d3 e0                	shl    %cl,%eax
  803170:	89 44 24 04          	mov    %eax,0x4(%esp)
  803174:	8b 44 24 08          	mov    0x8(%esp),%eax
  803178:	89 f1                	mov    %esi,%ecx
  80317a:	d3 e8                	shr    %cl,%eax
  80317c:	09 d0                	or     %edx,%eax
  80317e:	d3 eb                	shr    %cl,%ebx
  803180:	89 da                	mov    %ebx,%edx
  803182:	f7 f7                	div    %edi
  803184:	89 d3                	mov    %edx,%ebx
  803186:	f7 24 24             	mull   (%esp)
  803189:	89 c6                	mov    %eax,%esi
  80318b:	89 d1                	mov    %edx,%ecx
  80318d:	39 d3                	cmp    %edx,%ebx
  80318f:	0f 82 87 00 00 00    	jb     80321c <__umoddi3+0x134>
  803195:	0f 84 91 00 00 00    	je     80322c <__umoddi3+0x144>
  80319b:	8b 54 24 04          	mov    0x4(%esp),%edx
  80319f:	29 f2                	sub    %esi,%edx
  8031a1:	19 cb                	sbb    %ecx,%ebx
  8031a3:	89 d8                	mov    %ebx,%eax
  8031a5:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  8031a9:	d3 e0                	shl    %cl,%eax
  8031ab:	89 e9                	mov    %ebp,%ecx
  8031ad:	d3 ea                	shr    %cl,%edx
  8031af:	09 d0                	or     %edx,%eax
  8031b1:	89 e9                	mov    %ebp,%ecx
  8031b3:	d3 eb                	shr    %cl,%ebx
  8031b5:	89 da                	mov    %ebx,%edx
  8031b7:	83 c4 1c             	add    $0x1c,%esp
  8031ba:	5b                   	pop    %ebx
  8031bb:	5e                   	pop    %esi
  8031bc:	5f                   	pop    %edi
  8031bd:	5d                   	pop    %ebp
  8031be:	c3                   	ret    
  8031bf:	90                   	nop
  8031c0:	89 fd                	mov    %edi,%ebp
  8031c2:	85 ff                	test   %edi,%edi
  8031c4:	75 0b                	jne    8031d1 <__umoddi3+0xe9>
  8031c6:	b8 01 00 00 00       	mov    $0x1,%eax
  8031cb:	31 d2                	xor    %edx,%edx
  8031cd:	f7 f7                	div    %edi
  8031cf:	89 c5                	mov    %eax,%ebp
  8031d1:	89 f0                	mov    %esi,%eax
  8031d3:	31 d2                	xor    %edx,%edx
  8031d5:	f7 f5                	div    %ebp
  8031d7:	89 c8                	mov    %ecx,%eax
  8031d9:	f7 f5                	div    %ebp
  8031db:	89 d0                	mov    %edx,%eax
  8031dd:	e9 44 ff ff ff       	jmp    803126 <__umoddi3+0x3e>
  8031e2:	66 90                	xchg   %ax,%ax
  8031e4:	89 c8                	mov    %ecx,%eax
  8031e6:	89 f2                	mov    %esi,%edx
  8031e8:	83 c4 1c             	add    $0x1c,%esp
  8031eb:	5b                   	pop    %ebx
  8031ec:	5e                   	pop    %esi
  8031ed:	5f                   	pop    %edi
  8031ee:	5d                   	pop    %ebp
  8031ef:	c3                   	ret    
  8031f0:	3b 04 24             	cmp    (%esp),%eax
  8031f3:	72 06                	jb     8031fb <__umoddi3+0x113>
  8031f5:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  8031f9:	77 0f                	ja     80320a <__umoddi3+0x122>
  8031fb:	89 f2                	mov    %esi,%edx
  8031fd:	29 f9                	sub    %edi,%ecx
  8031ff:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  803203:	89 14 24             	mov    %edx,(%esp)
  803206:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  80320a:	8b 44 24 04          	mov    0x4(%esp),%eax
  80320e:	8b 14 24             	mov    (%esp),%edx
  803211:	83 c4 1c             	add    $0x1c,%esp
  803214:	5b                   	pop    %ebx
  803215:	5e                   	pop    %esi
  803216:	5f                   	pop    %edi
  803217:	5d                   	pop    %ebp
  803218:	c3                   	ret    
  803219:	8d 76 00             	lea    0x0(%esi),%esi
  80321c:	2b 04 24             	sub    (%esp),%eax
  80321f:	19 fa                	sbb    %edi,%edx
  803221:	89 d1                	mov    %edx,%ecx
  803223:	89 c6                	mov    %eax,%esi
  803225:	e9 71 ff ff ff       	jmp    80319b <__umoddi3+0xb3>
  80322a:	66 90                	xchg   %ax,%ax
  80322c:	39 44 24 04          	cmp    %eax,0x4(%esp)
  803230:	72 ea                	jb     80321c <__umoddi3+0x134>
  803232:	89 d9                	mov    %ebx,%ecx
  803234:	e9 62 ff ff ff       	jmp    80319b <__umoddi3+0xb3>
