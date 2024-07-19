
obj/user/heap_program:     file format elf32-i386


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
  800031:	e8 0c 02 00 00       	call   800242 <libmain>
1:      jmp 1b
  800036:	eb fe                	jmp    800036 <args_exist+0x5>

00800038 <_main>:
/* *********************************************************** */

#include <inc/lib.h>

void _main(void)
{
  800038:	55                   	push   %ebp
  800039:	89 e5                	mov    %esp,%ebp
  80003b:	57                   	push   %edi
  80003c:	56                   	push   %esi
  80003d:	53                   	push   %ebx
  80003e:	83 ec 5c             	sub    $0x5c,%esp
	int kilo = 1024;
  800041:	c7 45 d8 00 04 00 00 	movl   $0x400,-0x28(%ebp)
	int Mega = 1024*1024;
  800048:	c7 45 d4 00 00 10 00 	movl   $0x100000,-0x2c(%ebp)

	/// testing freeHeap()
	{
		uint32 size = 13*Mega;
  80004f:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  800052:	89 d0                	mov    %edx,%eax
  800054:	01 c0                	add    %eax,%eax
  800056:	01 d0                	add    %edx,%eax
  800058:	c1 e0 02             	shl    $0x2,%eax
  80005b:	01 d0                	add    %edx,%eax
  80005d:	89 45 d0             	mov    %eax,-0x30(%ebp)
		char *x = malloc(sizeof( char)*size) ;
  800060:	83 ec 0c             	sub    $0xc,%esp
  800063:	ff 75 d0             	pushl  -0x30(%ebp)
  800066:	e8 59 15 00 00       	call   8015c4 <malloc>
  80006b:	83 c4 10             	add    $0x10,%esp
  80006e:	89 45 cc             	mov    %eax,-0x34(%ebp)

		char *y = malloc(sizeof( char)*size) ;
  800071:	83 ec 0c             	sub    $0xc,%esp
  800074:	ff 75 d0             	pushl  -0x30(%ebp)
  800077:	e8 48 15 00 00       	call   8015c4 <malloc>
  80007c:	83 c4 10             	add    $0x10,%esp
  80007f:	89 45 c8             	mov    %eax,-0x38(%ebp)


		int usedDiskPages = sys_pf_calculate_allocated_pages() ;
  800082:	e8 e9 19 00 00       	call   801a70 <sys_pf_calculate_allocated_pages>
  800087:	89 45 c4             	mov    %eax,-0x3c(%ebp)

		x[1]=-1;
  80008a:	8b 45 cc             	mov    -0x34(%ebp),%eax
  80008d:	40                   	inc    %eax
  80008e:	c6 00 ff             	movb   $0xff,(%eax)

		x[5*Mega]=-1;
  800091:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  800094:	89 d0                	mov    %edx,%eax
  800096:	c1 e0 02             	shl    $0x2,%eax
  800099:	01 d0                	add    %edx,%eax
  80009b:	89 c2                	mov    %eax,%edx
  80009d:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8000a0:	01 d0                	add    %edx,%eax
  8000a2:	c6 00 ff             	movb   $0xff,(%eax)

		//Access VA 0x200000
		int *p1 = (int *)0x200000 ;
  8000a5:	c7 45 c0 00 00 20 00 	movl   $0x200000,-0x40(%ebp)
		*p1 = -1 ;
  8000ac:	8b 45 c0             	mov    -0x40(%ebp),%eax
  8000af:	c7 00 ff ff ff ff    	movl   $0xffffffff,(%eax)

		y[1*Mega]=-1;
  8000b5:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  8000b8:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8000bb:	01 d0                	add    %edx,%eax
  8000bd:	c6 00 ff             	movb   $0xff,(%eax)

		x[8*Mega] = -1;
  8000c0:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8000c3:	c1 e0 03             	shl    $0x3,%eax
  8000c6:	89 c2                	mov    %eax,%edx
  8000c8:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8000cb:	01 d0                	add    %edx,%eax
  8000cd:	c6 00 ff             	movb   $0xff,(%eax)

		x[12*Mega]=-1;
  8000d0:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  8000d3:	89 d0                	mov    %edx,%eax
  8000d5:	01 c0                	add    %eax,%eax
  8000d7:	01 d0                	add    %edx,%eax
  8000d9:	c1 e0 02             	shl    $0x2,%eax
  8000dc:	89 c2                	mov    %eax,%edx
  8000de:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8000e1:	01 d0                	add    %edx,%eax
  8000e3:	c6 00 ff             	movb   $0xff,(%eax)


		//int usedDiskPages = sys_pf_calculate_allocated_pages() ;


		free(x);
  8000e6:	83 ec 0c             	sub    $0xc,%esp
  8000e9:	ff 75 cc             	pushl  -0x34(%ebp)
  8000ec:	e8 54 15 00 00       	call   801645 <free>
  8000f1:	83 c4 10             	add    $0x10,%esp
		free(y);
  8000f4:	83 ec 0c             	sub    $0xc,%esp
  8000f7:	ff 75 c8             	pushl  -0x38(%ebp)
  8000fa:	e8 46 15 00 00       	call   801645 <free>
  8000ff:	83 c4 10             	add    $0x10,%esp

		///		cprintf("%d\n",sys_pf_calculate_allocated_pages() - usedDiskPages);
		///assert((sys_pf_calculate_allocated_pages() - usedDiskPages) == 5 ); //4 pages + 1 table, that was not in WS

		int freePages = sys_calculate_free_frames();
  800102:	e8 c9 18 00 00       	call   8019d0 <sys_calculate_free_frames>
  800107:	89 45 bc             	mov    %eax,-0x44(%ebp)
		x = malloc(sizeof(char)*size) ;
  80010a:	83 ec 0c             	sub    $0xc,%esp
  80010d:	ff 75 d0             	pushl  -0x30(%ebp)
  800110:	e8 af 14 00 00       	call   8015c4 <malloc>
  800115:	83 c4 10             	add    $0x10,%esp
  800118:	89 45 cc             	mov    %eax,-0x34(%ebp)

		//Access VA 0x200000
		*p1 = -1 ;
  80011b:	8b 45 c0             	mov    -0x40(%ebp),%eax
  80011e:	c7 00 ff ff ff ff    	movl   $0xffffffff,(%eax)


		x[1]=-2;
  800124:	8b 45 cc             	mov    -0x34(%ebp),%eax
  800127:	40                   	inc    %eax
  800128:	c6 00 fe             	movb   $0xfe,(%eax)

		x[5*Mega]=-2;
  80012b:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  80012e:	89 d0                	mov    %edx,%eax
  800130:	c1 e0 02             	shl    $0x2,%eax
  800133:	01 d0                	add    %edx,%eax
  800135:	89 c2                	mov    %eax,%edx
  800137:	8b 45 cc             	mov    -0x34(%ebp),%eax
  80013a:	01 d0                	add    %edx,%eax
  80013c:	c6 00 fe             	movb   $0xfe,(%eax)

		x[8*Mega] = -2;
  80013f:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  800142:	c1 e0 03             	shl    $0x3,%eax
  800145:	89 c2                	mov    %eax,%edx
  800147:	8b 45 cc             	mov    -0x34(%ebp),%eax
  80014a:	01 d0                	add    %edx,%eax
  80014c:	c6 00 fe             	movb   $0xfe,(%eax)

//		x[12*Mega]=-2;

		uint32 pageWSEntries[7] = {0x80000000, 0x80500000, 0x80800000, 0x800000, 0x803000, 0x200000, 0xeebfd000};
  80014f:	8d 45 9c             	lea    -0x64(%ebp),%eax
  800152:	bb bc 32 80 00       	mov    $0x8032bc,%ebx
  800157:	ba 07 00 00 00       	mov    $0x7,%edx
  80015c:	89 c7                	mov    %eax,%edi
  80015e:	89 de                	mov    %ebx,%esi
  800160:	89 d1                	mov    %edx,%ecx
  800162:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)

		int i = 0, j ;
  800164:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
		for (; i < 7; i++)
  80016b:	eb 7e                	jmp    8001eb <_main+0x1b3>
		{
			int found = 0 ;
  80016d:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
			for (j=0; j < (myEnv->page_WS_max_size); j++)
  800174:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  80017b:	eb 3d                	jmp    8001ba <_main+0x182>
			{
				if (pageWSEntries[i] == ROUNDDOWN(myEnv->__uptr_pws[j].virtual_address,PAGE_SIZE) )
  80017d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800180:	8b 4c 85 9c          	mov    -0x64(%ebp,%eax,4),%ecx
  800184:	a1 20 40 80 00       	mov    0x804020,%eax
  800189:	8b 98 9c 05 00 00    	mov    0x59c(%eax),%ebx
  80018f:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800192:	89 d0                	mov    %edx,%eax
  800194:	01 c0                	add    %eax,%eax
  800196:	01 d0                	add    %edx,%eax
  800198:	c1 e0 03             	shl    $0x3,%eax
  80019b:	01 d8                	add    %ebx,%eax
  80019d:	8b 00                	mov    (%eax),%eax
  80019f:	89 45 b8             	mov    %eax,-0x48(%ebp)
  8001a2:	8b 45 b8             	mov    -0x48(%ebp),%eax
  8001a5:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8001aa:	39 c1                	cmp    %eax,%ecx
  8001ac:	75 09                	jne    8001b7 <_main+0x17f>
				{
					found = 1 ;
  8001ae:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
					break;
  8001b5:	eb 12                	jmp    8001c9 <_main+0x191>

		int i = 0, j ;
		for (; i < 7; i++)
		{
			int found = 0 ;
			for (j=0; j < (myEnv->page_WS_max_size); j++)
  8001b7:	ff 45 e0             	incl   -0x20(%ebp)
  8001ba:	a1 20 40 80 00       	mov    0x804020,%eax
  8001bf:	8b 50 74             	mov    0x74(%eax),%edx
  8001c2:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8001c5:	39 c2                	cmp    %eax,%edx
  8001c7:	77 b4                	ja     80017d <_main+0x145>
				{
					found = 1 ;
					break;
				}
			}
			if (!found)
  8001c9:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  8001cd:	75 19                	jne    8001e8 <_main+0x1b0>
				panic("PAGE Placement algorithm failed after applying freeHeap. Page at VA %x is expected but not found", pageWSEntries[i]);
  8001cf:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8001d2:	8b 44 85 9c          	mov    -0x64(%ebp,%eax,4),%eax
  8001d6:	50                   	push   %eax
  8001d7:	68 c0 31 80 00       	push   $0x8031c0
  8001dc:	6a 4c                	push   $0x4c
  8001de:	68 21 32 80 00       	push   $0x803221
  8001e3:	e8 96 01 00 00       	call   80037e <_panic>
//		x[12*Mega]=-2;

		uint32 pageWSEntries[7] = {0x80000000, 0x80500000, 0x80800000, 0x800000, 0x803000, 0x200000, 0xeebfd000};

		int i = 0, j ;
		for (; i < 7; i++)
  8001e8:	ff 45 e4             	incl   -0x1c(%ebp)
  8001eb:	83 7d e4 06          	cmpl   $0x6,-0x1c(%ebp)
  8001ef:	0f 8e 78 ff ff ff    	jle    80016d <_main+0x135>
			}
			if (!found)
				panic("PAGE Placement algorithm failed after applying freeHeap. Page at VA %x is expected but not found", pageWSEntries[i]);
		}

		if( (freePages - sys_calculate_free_frames() ) != 6 ) panic("Extra/Less memory are wrongly allocated. diff = %d, expected = %d", freePages - sys_calculate_free_frames(), 8);
  8001f5:	8b 5d bc             	mov    -0x44(%ebp),%ebx
  8001f8:	e8 d3 17 00 00       	call   8019d0 <sys_calculate_free_frames>
  8001fd:	29 c3                	sub    %eax,%ebx
  8001ff:	89 d8                	mov    %ebx,%eax
  800201:	83 f8 06             	cmp    $0x6,%eax
  800204:	74 23                	je     800229 <_main+0x1f1>
  800206:	8b 5d bc             	mov    -0x44(%ebp),%ebx
  800209:	e8 c2 17 00 00       	call   8019d0 <sys_calculate_free_frames>
  80020e:	29 c3                	sub    %eax,%ebx
  800210:	89 d8                	mov    %ebx,%eax
  800212:	83 ec 0c             	sub    $0xc,%esp
  800215:	6a 08                	push   $0x8
  800217:	50                   	push   %eax
  800218:	68 38 32 80 00       	push   $0x803238
  80021d:	6a 4f                	push   $0x4f
  80021f:	68 21 32 80 00       	push   $0x803221
  800224:	e8 55 01 00 00       	call   80037e <_panic>
	}

	cprintf("Congratulations!! test HEAP_PROGRAM completed successfully.\n");
  800229:	83 ec 0c             	sub    $0xc,%esp
  80022c:	68 7c 32 80 00       	push   $0x80327c
  800231:	e8 fc 03 00 00       	call   800632 <cprintf>
  800236:	83 c4 10             	add    $0x10,%esp


	return;
  800239:	90                   	nop
}
  80023a:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80023d:	5b                   	pop    %ebx
  80023e:	5e                   	pop    %esi
  80023f:	5f                   	pop    %edi
  800240:	5d                   	pop    %ebp
  800241:	c3                   	ret    

00800242 <libmain>:
volatile struct Env *myEnv = NULL;
volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";

void
libmain(int argc, char **argv)
{
  800242:	55                   	push   %ebp
  800243:	89 e5                	mov    %esp,%ebp
  800245:	83 ec 18             	sub    $0x18,%esp
	int envIndex = sys_getenvindex();
  800248:	e8 63 1a 00 00       	call   801cb0 <sys_getenvindex>
  80024d:	89 45 f4             	mov    %eax,-0xc(%ebp)
	myEnv = &(envs[envIndex]);
  800250:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800253:	89 d0                	mov    %edx,%eax
  800255:	c1 e0 03             	shl    $0x3,%eax
  800258:	01 d0                	add    %edx,%eax
  80025a:	01 c0                	add    %eax,%eax
  80025c:	01 d0                	add    %edx,%eax
  80025e:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800265:	01 d0                	add    %edx,%eax
  800267:	c1 e0 04             	shl    $0x4,%eax
  80026a:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  80026f:	a3 20 40 80 00       	mov    %eax,0x804020

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  800274:	a1 20 40 80 00       	mov    0x804020,%eax
  800279:	8a 80 5c 05 00 00    	mov    0x55c(%eax),%al
  80027f:	84 c0                	test   %al,%al
  800281:	74 0f                	je     800292 <libmain+0x50>
		binaryname = myEnv->prog_name;
  800283:	a1 20 40 80 00       	mov    0x804020,%eax
  800288:	05 5c 05 00 00       	add    $0x55c,%eax
  80028d:	a3 00 40 80 00       	mov    %eax,0x804000

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  800292:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800296:	7e 0a                	jle    8002a2 <libmain+0x60>
		binaryname = argv[0];
  800298:	8b 45 0c             	mov    0xc(%ebp),%eax
  80029b:	8b 00                	mov    (%eax),%eax
  80029d:	a3 00 40 80 00       	mov    %eax,0x804000

	// call user main routine
	_main(argc, argv);
  8002a2:	83 ec 08             	sub    $0x8,%esp
  8002a5:	ff 75 0c             	pushl  0xc(%ebp)
  8002a8:	ff 75 08             	pushl  0x8(%ebp)
  8002ab:	e8 88 fd ff ff       	call   800038 <_main>
  8002b0:	83 c4 10             	add    $0x10,%esp



	sys_disable_interrupt();
  8002b3:	e8 05 18 00 00       	call   801abd <sys_disable_interrupt>
	cprintf("**************************************\n");
  8002b8:	83 ec 0c             	sub    $0xc,%esp
  8002bb:	68 f0 32 80 00       	push   $0x8032f0
  8002c0:	e8 6d 03 00 00       	call   800632 <cprintf>
  8002c5:	83 c4 10             	add    $0x10,%esp
	cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  8002c8:	a1 20 40 80 00       	mov    0x804020,%eax
  8002cd:	8b 90 44 05 00 00    	mov    0x544(%eax),%edx
  8002d3:	a1 20 40 80 00       	mov    0x804020,%eax
  8002d8:	8b 80 34 05 00 00    	mov    0x534(%eax),%eax
  8002de:	83 ec 04             	sub    $0x4,%esp
  8002e1:	52                   	push   %edx
  8002e2:	50                   	push   %eax
  8002e3:	68 18 33 80 00       	push   $0x803318
  8002e8:	e8 45 03 00 00       	call   800632 <cprintf>
  8002ed:	83 c4 10             	add    $0x10,%esp
	cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  8002f0:	a1 20 40 80 00       	mov    0x804020,%eax
  8002f5:	8b 88 54 05 00 00    	mov    0x554(%eax),%ecx
  8002fb:	a1 20 40 80 00       	mov    0x804020,%eax
  800300:	8b 90 50 05 00 00    	mov    0x550(%eax),%edx
  800306:	a1 20 40 80 00       	mov    0x804020,%eax
  80030b:	8b 80 4c 05 00 00    	mov    0x54c(%eax),%eax
  800311:	51                   	push   %ecx
  800312:	52                   	push   %edx
  800313:	50                   	push   %eax
  800314:	68 40 33 80 00       	push   $0x803340
  800319:	e8 14 03 00 00       	call   800632 <cprintf>
  80031e:	83 c4 10             	add    $0x10,%esp
	//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
	cprintf("Num of clocks = %d\n", myEnv->nClocks);
  800321:	a1 20 40 80 00       	mov    0x804020,%eax
  800326:	8b 80 a4 05 00 00    	mov    0x5a4(%eax),%eax
  80032c:	83 ec 08             	sub    $0x8,%esp
  80032f:	50                   	push   %eax
  800330:	68 98 33 80 00       	push   $0x803398
  800335:	e8 f8 02 00 00       	call   800632 <cprintf>
  80033a:	83 c4 10             	add    $0x10,%esp
	cprintf("**************************************\n");
  80033d:	83 ec 0c             	sub    $0xc,%esp
  800340:	68 f0 32 80 00       	push   $0x8032f0
  800345:	e8 e8 02 00 00       	call   800632 <cprintf>
  80034a:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  80034d:	e8 85 17 00 00       	call   801ad7 <sys_enable_interrupt>

	// exit gracefully
	exit();
  800352:	e8 19 00 00 00       	call   800370 <exit>
}
  800357:	90                   	nop
  800358:	c9                   	leave  
  800359:	c3                   	ret    

0080035a <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  80035a:	55                   	push   %ebp
  80035b:	89 e5                	mov    %esp,%ebp
  80035d:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  800360:	83 ec 0c             	sub    $0xc,%esp
  800363:	6a 00                	push   $0x0
  800365:	e8 12 19 00 00       	call   801c7c <sys_destroy_env>
  80036a:	83 c4 10             	add    $0x10,%esp
}
  80036d:	90                   	nop
  80036e:	c9                   	leave  
  80036f:	c3                   	ret    

00800370 <exit>:

void
exit(void)
{
  800370:	55                   	push   %ebp
  800371:	89 e5                	mov    %esp,%ebp
  800373:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  800376:	e8 67 19 00 00       	call   801ce2 <sys_exit_env>
}
  80037b:	90                   	nop
  80037c:	c9                   	leave  
  80037d:	c3                   	ret    

0080037e <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  80037e:	55                   	push   %ebp
  80037f:	89 e5                	mov    %esp,%ebp
  800381:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  800384:	8d 45 10             	lea    0x10(%ebp),%eax
  800387:	83 c0 04             	add    $0x4,%eax
  80038a:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  80038d:	a1 5c 41 80 00       	mov    0x80415c,%eax
  800392:	85 c0                	test   %eax,%eax
  800394:	74 16                	je     8003ac <_panic+0x2e>
		cprintf("%s: ", argv0);
  800396:	a1 5c 41 80 00       	mov    0x80415c,%eax
  80039b:	83 ec 08             	sub    $0x8,%esp
  80039e:	50                   	push   %eax
  80039f:	68 ac 33 80 00       	push   $0x8033ac
  8003a4:	e8 89 02 00 00       	call   800632 <cprintf>
  8003a9:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  8003ac:	a1 00 40 80 00       	mov    0x804000,%eax
  8003b1:	ff 75 0c             	pushl  0xc(%ebp)
  8003b4:	ff 75 08             	pushl  0x8(%ebp)
  8003b7:	50                   	push   %eax
  8003b8:	68 b1 33 80 00       	push   $0x8033b1
  8003bd:	e8 70 02 00 00       	call   800632 <cprintf>
  8003c2:	83 c4 10             	add    $0x10,%esp
	vcprintf(fmt, ap);
  8003c5:	8b 45 10             	mov    0x10(%ebp),%eax
  8003c8:	83 ec 08             	sub    $0x8,%esp
  8003cb:	ff 75 f4             	pushl  -0xc(%ebp)
  8003ce:	50                   	push   %eax
  8003cf:	e8 f3 01 00 00       	call   8005c7 <vcprintf>
  8003d4:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  8003d7:	83 ec 08             	sub    $0x8,%esp
  8003da:	6a 00                	push   $0x0
  8003dc:	68 cd 33 80 00       	push   $0x8033cd
  8003e1:	e8 e1 01 00 00       	call   8005c7 <vcprintf>
  8003e6:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  8003e9:	e8 82 ff ff ff       	call   800370 <exit>

	// should not return here
	while (1) ;
  8003ee:	eb fe                	jmp    8003ee <_panic+0x70>

008003f0 <CheckWSWithoutLastIndex>:
}

void CheckWSWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  8003f0:	55                   	push   %ebp
  8003f1:	89 e5                	mov    %esp,%ebp
  8003f3:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  8003f6:	a1 20 40 80 00       	mov    0x804020,%eax
  8003fb:	8b 50 74             	mov    0x74(%eax),%edx
  8003fe:	8b 45 0c             	mov    0xc(%ebp),%eax
  800401:	39 c2                	cmp    %eax,%edx
  800403:	74 14                	je     800419 <CheckWSWithoutLastIndex+0x29>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  800405:	83 ec 04             	sub    $0x4,%esp
  800408:	68 d0 33 80 00       	push   $0x8033d0
  80040d:	6a 26                	push   $0x26
  80040f:	68 1c 34 80 00       	push   $0x80341c
  800414:	e8 65 ff ff ff       	call   80037e <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  800419:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  800420:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800427:	e9 c2 00 00 00       	jmp    8004ee <CheckWSWithoutLastIndex+0xfe>
		if (expectedPages[e] == 0) {
  80042c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80042f:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800436:	8b 45 08             	mov    0x8(%ebp),%eax
  800439:	01 d0                	add    %edx,%eax
  80043b:	8b 00                	mov    (%eax),%eax
  80043d:	85 c0                	test   %eax,%eax
  80043f:	75 08                	jne    800449 <CheckWSWithoutLastIndex+0x59>
			expectedNumOfEmptyLocs++;
  800441:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  800444:	e9 a2 00 00 00       	jmp    8004eb <CheckWSWithoutLastIndex+0xfb>
		}
		int found = 0;
  800449:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800450:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  800457:	eb 69                	jmp    8004c2 <CheckWSWithoutLastIndex+0xd2>
			if (myEnv->__uptr_pws[w].empty == 0) {
  800459:	a1 20 40 80 00       	mov    0x804020,%eax
  80045e:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  800464:	8b 55 e8             	mov    -0x18(%ebp),%edx
  800467:	89 d0                	mov    %edx,%eax
  800469:	01 c0                	add    %eax,%eax
  80046b:	01 d0                	add    %edx,%eax
  80046d:	c1 e0 03             	shl    $0x3,%eax
  800470:	01 c8                	add    %ecx,%eax
  800472:	8a 40 04             	mov    0x4(%eax),%al
  800475:	84 c0                	test   %al,%al
  800477:	75 46                	jne    8004bf <CheckWSWithoutLastIndex+0xcf>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  800479:	a1 20 40 80 00       	mov    0x804020,%eax
  80047e:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  800484:	8b 55 e8             	mov    -0x18(%ebp),%edx
  800487:	89 d0                	mov    %edx,%eax
  800489:	01 c0                	add    %eax,%eax
  80048b:	01 d0                	add    %edx,%eax
  80048d:	c1 e0 03             	shl    $0x3,%eax
  800490:	01 c8                	add    %ecx,%eax
  800492:	8b 00                	mov    (%eax),%eax
  800494:	89 45 dc             	mov    %eax,-0x24(%ebp)
  800497:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80049a:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  80049f:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  8004a1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8004a4:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  8004ab:	8b 45 08             	mov    0x8(%ebp),%eax
  8004ae:	01 c8                	add    %ecx,%eax
  8004b0:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  8004b2:	39 c2                	cmp    %eax,%edx
  8004b4:	75 09                	jne    8004bf <CheckWSWithoutLastIndex+0xcf>
						== expectedPages[e]) {
					found = 1;
  8004b6:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  8004bd:	eb 12                	jmp    8004d1 <CheckWSWithoutLastIndex+0xe1>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8004bf:	ff 45 e8             	incl   -0x18(%ebp)
  8004c2:	a1 20 40 80 00       	mov    0x804020,%eax
  8004c7:	8b 50 74             	mov    0x74(%eax),%edx
  8004ca:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8004cd:	39 c2                	cmp    %eax,%edx
  8004cf:	77 88                	ja     800459 <CheckWSWithoutLastIndex+0x69>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  8004d1:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8004d5:	75 14                	jne    8004eb <CheckWSWithoutLastIndex+0xfb>
			panic(
  8004d7:	83 ec 04             	sub    $0x4,%esp
  8004da:	68 28 34 80 00       	push   $0x803428
  8004df:	6a 3a                	push   $0x3a
  8004e1:	68 1c 34 80 00       	push   $0x80341c
  8004e6:	e8 93 fe ff ff       	call   80037e <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  8004eb:	ff 45 f0             	incl   -0x10(%ebp)
  8004ee:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8004f1:	3b 45 0c             	cmp    0xc(%ebp),%eax
  8004f4:	0f 8c 32 ff ff ff    	jl     80042c <CheckWSWithoutLastIndex+0x3c>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  8004fa:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800501:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  800508:	eb 26                	jmp    800530 <CheckWSWithoutLastIndex+0x140>
		if (myEnv->__uptr_pws[w].empty == 1) {
  80050a:	a1 20 40 80 00       	mov    0x804020,%eax
  80050f:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  800515:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800518:	89 d0                	mov    %edx,%eax
  80051a:	01 c0                	add    %eax,%eax
  80051c:	01 d0                	add    %edx,%eax
  80051e:	c1 e0 03             	shl    $0x3,%eax
  800521:	01 c8                	add    %ecx,%eax
  800523:	8a 40 04             	mov    0x4(%eax),%al
  800526:	3c 01                	cmp    $0x1,%al
  800528:	75 03                	jne    80052d <CheckWSWithoutLastIndex+0x13d>
			actualNumOfEmptyLocs++;
  80052a:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  80052d:	ff 45 e0             	incl   -0x20(%ebp)
  800530:	a1 20 40 80 00       	mov    0x804020,%eax
  800535:	8b 50 74             	mov    0x74(%eax),%edx
  800538:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80053b:	39 c2                	cmp    %eax,%edx
  80053d:	77 cb                	ja     80050a <CheckWSWithoutLastIndex+0x11a>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  80053f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800542:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  800545:	74 14                	je     80055b <CheckWSWithoutLastIndex+0x16b>
		panic(
  800547:	83 ec 04             	sub    $0x4,%esp
  80054a:	68 7c 34 80 00       	push   $0x80347c
  80054f:	6a 44                	push   $0x44
  800551:	68 1c 34 80 00       	push   $0x80341c
  800556:	e8 23 fe ff ff       	call   80037e <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  80055b:	90                   	nop
  80055c:	c9                   	leave  
  80055d:	c3                   	ret    

0080055e <putch>:
};

//2017:
uint8 printProgName = 0;

static void putch(int ch, struct printbuf *b) {
  80055e:	55                   	push   %ebp
  80055f:	89 e5                	mov    %esp,%ebp
  800561:	83 ec 08             	sub    $0x8,%esp
	b->buf[b->idx++] = ch;
  800564:	8b 45 0c             	mov    0xc(%ebp),%eax
  800567:	8b 00                	mov    (%eax),%eax
  800569:	8d 48 01             	lea    0x1(%eax),%ecx
  80056c:	8b 55 0c             	mov    0xc(%ebp),%edx
  80056f:	89 0a                	mov    %ecx,(%edx)
  800571:	8b 55 08             	mov    0x8(%ebp),%edx
  800574:	88 d1                	mov    %dl,%cl
  800576:	8b 55 0c             	mov    0xc(%ebp),%edx
  800579:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  80057d:	8b 45 0c             	mov    0xc(%ebp),%eax
  800580:	8b 00                	mov    (%eax),%eax
  800582:	3d ff 00 00 00       	cmp    $0xff,%eax
  800587:	75 2c                	jne    8005b5 <putch+0x57>
		sys_cputs(b->buf, b->idx, printProgName);
  800589:	a0 24 40 80 00       	mov    0x804024,%al
  80058e:	0f b6 c0             	movzbl %al,%eax
  800591:	8b 55 0c             	mov    0xc(%ebp),%edx
  800594:	8b 12                	mov    (%edx),%edx
  800596:	89 d1                	mov    %edx,%ecx
  800598:	8b 55 0c             	mov    0xc(%ebp),%edx
  80059b:	83 c2 08             	add    $0x8,%edx
  80059e:	83 ec 04             	sub    $0x4,%esp
  8005a1:	50                   	push   %eax
  8005a2:	51                   	push   %ecx
  8005a3:	52                   	push   %edx
  8005a4:	e8 66 13 00 00       	call   80190f <sys_cputs>
  8005a9:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  8005ac:	8b 45 0c             	mov    0xc(%ebp),%eax
  8005af:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  8005b5:	8b 45 0c             	mov    0xc(%ebp),%eax
  8005b8:	8b 40 04             	mov    0x4(%eax),%eax
  8005bb:	8d 50 01             	lea    0x1(%eax),%edx
  8005be:	8b 45 0c             	mov    0xc(%ebp),%eax
  8005c1:	89 50 04             	mov    %edx,0x4(%eax)
}
  8005c4:	90                   	nop
  8005c5:	c9                   	leave  
  8005c6:	c3                   	ret    

008005c7 <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  8005c7:	55                   	push   %ebp
  8005c8:	89 e5                	mov    %esp,%ebp
  8005ca:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  8005d0:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  8005d7:	00 00 00 
	b.cnt = 0;
  8005da:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  8005e1:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  8005e4:	ff 75 0c             	pushl  0xc(%ebp)
  8005e7:	ff 75 08             	pushl  0x8(%ebp)
  8005ea:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  8005f0:	50                   	push   %eax
  8005f1:	68 5e 05 80 00       	push   $0x80055e
  8005f6:	e8 11 02 00 00       	call   80080c <vprintfmt>
  8005fb:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName);
  8005fe:	a0 24 40 80 00       	mov    0x804024,%al
  800603:	0f b6 c0             	movzbl %al,%eax
  800606:	8b 95 f0 fe ff ff    	mov    -0x110(%ebp),%edx
  80060c:	83 ec 04             	sub    $0x4,%esp
  80060f:	50                   	push   %eax
  800610:	52                   	push   %edx
  800611:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800617:	83 c0 08             	add    $0x8,%eax
  80061a:	50                   	push   %eax
  80061b:	e8 ef 12 00 00       	call   80190f <sys_cputs>
  800620:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  800623:	c6 05 24 40 80 00 00 	movb   $0x0,0x804024
	return b.cnt;
  80062a:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  800630:	c9                   	leave  
  800631:	c3                   	ret    

00800632 <cprintf>:

int cprintf(const char *fmt, ...) {
  800632:	55                   	push   %ebp
  800633:	89 e5                	mov    %esp,%ebp
  800635:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  800638:	c6 05 24 40 80 00 01 	movb   $0x1,0x804024
	va_start(ap, fmt);
  80063f:	8d 45 0c             	lea    0xc(%ebp),%eax
  800642:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800645:	8b 45 08             	mov    0x8(%ebp),%eax
  800648:	83 ec 08             	sub    $0x8,%esp
  80064b:	ff 75 f4             	pushl  -0xc(%ebp)
  80064e:	50                   	push   %eax
  80064f:	e8 73 ff ff ff       	call   8005c7 <vcprintf>
  800654:	83 c4 10             	add    $0x10,%esp
  800657:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  80065a:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  80065d:	c9                   	leave  
  80065e:	c3                   	ret    

0080065f <atomic_cprintf>:

int atomic_cprintf(const char *fmt, ...) {
  80065f:	55                   	push   %ebp
  800660:	89 e5                	mov    %esp,%ebp
  800662:	83 ec 18             	sub    $0x18,%esp
	sys_disable_interrupt();
  800665:	e8 53 14 00 00       	call   801abd <sys_disable_interrupt>
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  80066a:	8d 45 0c             	lea    0xc(%ebp),%eax
  80066d:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800670:	8b 45 08             	mov    0x8(%ebp),%eax
  800673:	83 ec 08             	sub    $0x8,%esp
  800676:	ff 75 f4             	pushl  -0xc(%ebp)
  800679:	50                   	push   %eax
  80067a:	e8 48 ff ff ff       	call   8005c7 <vcprintf>
  80067f:	83 c4 10             	add    $0x10,%esp
  800682:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	sys_enable_interrupt();
  800685:	e8 4d 14 00 00       	call   801ad7 <sys_enable_interrupt>
	return cnt;
  80068a:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  80068d:	c9                   	leave  
  80068e:	c3                   	ret    

0080068f <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  80068f:	55                   	push   %ebp
  800690:	89 e5                	mov    %esp,%ebp
  800692:	53                   	push   %ebx
  800693:	83 ec 14             	sub    $0x14,%esp
  800696:	8b 45 10             	mov    0x10(%ebp),%eax
  800699:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80069c:	8b 45 14             	mov    0x14(%ebp),%eax
  80069f:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  8006a2:	8b 45 18             	mov    0x18(%ebp),%eax
  8006a5:	ba 00 00 00 00       	mov    $0x0,%edx
  8006aa:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  8006ad:	77 55                	ja     800704 <printnum+0x75>
  8006af:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  8006b2:	72 05                	jb     8006b9 <printnum+0x2a>
  8006b4:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8006b7:	77 4b                	ja     800704 <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  8006b9:	8b 45 1c             	mov    0x1c(%ebp),%eax
  8006bc:	8d 58 ff             	lea    -0x1(%eax),%ebx
  8006bf:	8b 45 18             	mov    0x18(%ebp),%eax
  8006c2:	ba 00 00 00 00       	mov    $0x0,%edx
  8006c7:	52                   	push   %edx
  8006c8:	50                   	push   %eax
  8006c9:	ff 75 f4             	pushl  -0xc(%ebp)
  8006cc:	ff 75 f0             	pushl  -0x10(%ebp)
  8006cf:	e8 84 28 00 00       	call   802f58 <__udivdi3>
  8006d4:	83 c4 10             	add    $0x10,%esp
  8006d7:	83 ec 04             	sub    $0x4,%esp
  8006da:	ff 75 20             	pushl  0x20(%ebp)
  8006dd:	53                   	push   %ebx
  8006de:	ff 75 18             	pushl  0x18(%ebp)
  8006e1:	52                   	push   %edx
  8006e2:	50                   	push   %eax
  8006e3:	ff 75 0c             	pushl  0xc(%ebp)
  8006e6:	ff 75 08             	pushl  0x8(%ebp)
  8006e9:	e8 a1 ff ff ff       	call   80068f <printnum>
  8006ee:	83 c4 20             	add    $0x20,%esp
  8006f1:	eb 1a                	jmp    80070d <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  8006f3:	83 ec 08             	sub    $0x8,%esp
  8006f6:	ff 75 0c             	pushl  0xc(%ebp)
  8006f9:	ff 75 20             	pushl  0x20(%ebp)
  8006fc:	8b 45 08             	mov    0x8(%ebp),%eax
  8006ff:	ff d0                	call   *%eax
  800701:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800704:	ff 4d 1c             	decl   0x1c(%ebp)
  800707:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  80070b:	7f e6                	jg     8006f3 <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  80070d:	8b 4d 18             	mov    0x18(%ebp),%ecx
  800710:	bb 00 00 00 00       	mov    $0x0,%ebx
  800715:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800718:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80071b:	53                   	push   %ebx
  80071c:	51                   	push   %ecx
  80071d:	52                   	push   %edx
  80071e:	50                   	push   %eax
  80071f:	e8 44 29 00 00       	call   803068 <__umoddi3>
  800724:	83 c4 10             	add    $0x10,%esp
  800727:	05 f4 36 80 00       	add    $0x8036f4,%eax
  80072c:	8a 00                	mov    (%eax),%al
  80072e:	0f be c0             	movsbl %al,%eax
  800731:	83 ec 08             	sub    $0x8,%esp
  800734:	ff 75 0c             	pushl  0xc(%ebp)
  800737:	50                   	push   %eax
  800738:	8b 45 08             	mov    0x8(%ebp),%eax
  80073b:	ff d0                	call   *%eax
  80073d:	83 c4 10             	add    $0x10,%esp
}
  800740:	90                   	nop
  800741:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800744:	c9                   	leave  
  800745:	c3                   	ret    

00800746 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  800746:	55                   	push   %ebp
  800747:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800749:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  80074d:	7e 1c                	jle    80076b <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  80074f:	8b 45 08             	mov    0x8(%ebp),%eax
  800752:	8b 00                	mov    (%eax),%eax
  800754:	8d 50 08             	lea    0x8(%eax),%edx
  800757:	8b 45 08             	mov    0x8(%ebp),%eax
  80075a:	89 10                	mov    %edx,(%eax)
  80075c:	8b 45 08             	mov    0x8(%ebp),%eax
  80075f:	8b 00                	mov    (%eax),%eax
  800761:	83 e8 08             	sub    $0x8,%eax
  800764:	8b 50 04             	mov    0x4(%eax),%edx
  800767:	8b 00                	mov    (%eax),%eax
  800769:	eb 40                	jmp    8007ab <getuint+0x65>
	else if (lflag)
  80076b:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80076f:	74 1e                	je     80078f <getuint+0x49>
		return va_arg(*ap, unsigned long);
  800771:	8b 45 08             	mov    0x8(%ebp),%eax
  800774:	8b 00                	mov    (%eax),%eax
  800776:	8d 50 04             	lea    0x4(%eax),%edx
  800779:	8b 45 08             	mov    0x8(%ebp),%eax
  80077c:	89 10                	mov    %edx,(%eax)
  80077e:	8b 45 08             	mov    0x8(%ebp),%eax
  800781:	8b 00                	mov    (%eax),%eax
  800783:	83 e8 04             	sub    $0x4,%eax
  800786:	8b 00                	mov    (%eax),%eax
  800788:	ba 00 00 00 00       	mov    $0x0,%edx
  80078d:	eb 1c                	jmp    8007ab <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  80078f:	8b 45 08             	mov    0x8(%ebp),%eax
  800792:	8b 00                	mov    (%eax),%eax
  800794:	8d 50 04             	lea    0x4(%eax),%edx
  800797:	8b 45 08             	mov    0x8(%ebp),%eax
  80079a:	89 10                	mov    %edx,(%eax)
  80079c:	8b 45 08             	mov    0x8(%ebp),%eax
  80079f:	8b 00                	mov    (%eax),%eax
  8007a1:	83 e8 04             	sub    $0x4,%eax
  8007a4:	8b 00                	mov    (%eax),%eax
  8007a6:	ba 00 00 00 00       	mov    $0x0,%edx
}
  8007ab:	5d                   	pop    %ebp
  8007ac:	c3                   	ret    

008007ad <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  8007ad:	55                   	push   %ebp
  8007ae:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  8007b0:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  8007b4:	7e 1c                	jle    8007d2 <getint+0x25>
		return va_arg(*ap, long long);
  8007b6:	8b 45 08             	mov    0x8(%ebp),%eax
  8007b9:	8b 00                	mov    (%eax),%eax
  8007bb:	8d 50 08             	lea    0x8(%eax),%edx
  8007be:	8b 45 08             	mov    0x8(%ebp),%eax
  8007c1:	89 10                	mov    %edx,(%eax)
  8007c3:	8b 45 08             	mov    0x8(%ebp),%eax
  8007c6:	8b 00                	mov    (%eax),%eax
  8007c8:	83 e8 08             	sub    $0x8,%eax
  8007cb:	8b 50 04             	mov    0x4(%eax),%edx
  8007ce:	8b 00                	mov    (%eax),%eax
  8007d0:	eb 38                	jmp    80080a <getint+0x5d>
	else if (lflag)
  8007d2:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8007d6:	74 1a                	je     8007f2 <getint+0x45>
		return va_arg(*ap, long);
  8007d8:	8b 45 08             	mov    0x8(%ebp),%eax
  8007db:	8b 00                	mov    (%eax),%eax
  8007dd:	8d 50 04             	lea    0x4(%eax),%edx
  8007e0:	8b 45 08             	mov    0x8(%ebp),%eax
  8007e3:	89 10                	mov    %edx,(%eax)
  8007e5:	8b 45 08             	mov    0x8(%ebp),%eax
  8007e8:	8b 00                	mov    (%eax),%eax
  8007ea:	83 e8 04             	sub    $0x4,%eax
  8007ed:	8b 00                	mov    (%eax),%eax
  8007ef:	99                   	cltd   
  8007f0:	eb 18                	jmp    80080a <getint+0x5d>
	else
		return va_arg(*ap, int);
  8007f2:	8b 45 08             	mov    0x8(%ebp),%eax
  8007f5:	8b 00                	mov    (%eax),%eax
  8007f7:	8d 50 04             	lea    0x4(%eax),%edx
  8007fa:	8b 45 08             	mov    0x8(%ebp),%eax
  8007fd:	89 10                	mov    %edx,(%eax)
  8007ff:	8b 45 08             	mov    0x8(%ebp),%eax
  800802:	8b 00                	mov    (%eax),%eax
  800804:	83 e8 04             	sub    $0x4,%eax
  800807:	8b 00                	mov    (%eax),%eax
  800809:	99                   	cltd   
}
  80080a:	5d                   	pop    %ebp
  80080b:	c3                   	ret    

0080080c <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  80080c:	55                   	push   %ebp
  80080d:	89 e5                	mov    %esp,%ebp
  80080f:	56                   	push   %esi
  800810:	53                   	push   %ebx
  800811:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800814:	eb 17                	jmp    80082d <vprintfmt+0x21>
			if (ch == '\0')
  800816:	85 db                	test   %ebx,%ebx
  800818:	0f 84 af 03 00 00    	je     800bcd <vprintfmt+0x3c1>
				return;
			putch(ch, putdat);
  80081e:	83 ec 08             	sub    $0x8,%esp
  800821:	ff 75 0c             	pushl  0xc(%ebp)
  800824:	53                   	push   %ebx
  800825:	8b 45 08             	mov    0x8(%ebp),%eax
  800828:	ff d0                	call   *%eax
  80082a:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  80082d:	8b 45 10             	mov    0x10(%ebp),%eax
  800830:	8d 50 01             	lea    0x1(%eax),%edx
  800833:	89 55 10             	mov    %edx,0x10(%ebp)
  800836:	8a 00                	mov    (%eax),%al
  800838:	0f b6 d8             	movzbl %al,%ebx
  80083b:	83 fb 25             	cmp    $0x25,%ebx
  80083e:	75 d6                	jne    800816 <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  800840:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  800844:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  80084b:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  800852:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  800859:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800860:	8b 45 10             	mov    0x10(%ebp),%eax
  800863:	8d 50 01             	lea    0x1(%eax),%edx
  800866:	89 55 10             	mov    %edx,0x10(%ebp)
  800869:	8a 00                	mov    (%eax),%al
  80086b:	0f b6 d8             	movzbl %al,%ebx
  80086e:	8d 43 dd             	lea    -0x23(%ebx),%eax
  800871:	83 f8 55             	cmp    $0x55,%eax
  800874:	0f 87 2b 03 00 00    	ja     800ba5 <vprintfmt+0x399>
  80087a:	8b 04 85 18 37 80 00 	mov    0x803718(,%eax,4),%eax
  800881:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  800883:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  800887:	eb d7                	jmp    800860 <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  800889:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  80088d:	eb d1                	jmp    800860 <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  80088f:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  800896:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800899:	89 d0                	mov    %edx,%eax
  80089b:	c1 e0 02             	shl    $0x2,%eax
  80089e:	01 d0                	add    %edx,%eax
  8008a0:	01 c0                	add    %eax,%eax
  8008a2:	01 d8                	add    %ebx,%eax
  8008a4:	83 e8 30             	sub    $0x30,%eax
  8008a7:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  8008aa:	8b 45 10             	mov    0x10(%ebp),%eax
  8008ad:	8a 00                	mov    (%eax),%al
  8008af:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  8008b2:	83 fb 2f             	cmp    $0x2f,%ebx
  8008b5:	7e 3e                	jle    8008f5 <vprintfmt+0xe9>
  8008b7:	83 fb 39             	cmp    $0x39,%ebx
  8008ba:	7f 39                	jg     8008f5 <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8008bc:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  8008bf:	eb d5                	jmp    800896 <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  8008c1:	8b 45 14             	mov    0x14(%ebp),%eax
  8008c4:	83 c0 04             	add    $0x4,%eax
  8008c7:	89 45 14             	mov    %eax,0x14(%ebp)
  8008ca:	8b 45 14             	mov    0x14(%ebp),%eax
  8008cd:	83 e8 04             	sub    $0x4,%eax
  8008d0:	8b 00                	mov    (%eax),%eax
  8008d2:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  8008d5:	eb 1f                	jmp    8008f6 <vprintfmt+0xea>

		case '.':
			if (width < 0)
  8008d7:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8008db:	79 83                	jns    800860 <vprintfmt+0x54>
				width = 0;
  8008dd:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  8008e4:	e9 77 ff ff ff       	jmp    800860 <vprintfmt+0x54>

		case '#':
			altflag = 1;
  8008e9:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  8008f0:	e9 6b ff ff ff       	jmp    800860 <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  8008f5:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  8008f6:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8008fa:	0f 89 60 ff ff ff    	jns    800860 <vprintfmt+0x54>
				width = precision, precision = -1;
  800900:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800903:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800906:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  80090d:	e9 4e ff ff ff       	jmp    800860 <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  800912:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  800915:	e9 46 ff ff ff       	jmp    800860 <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  80091a:	8b 45 14             	mov    0x14(%ebp),%eax
  80091d:	83 c0 04             	add    $0x4,%eax
  800920:	89 45 14             	mov    %eax,0x14(%ebp)
  800923:	8b 45 14             	mov    0x14(%ebp),%eax
  800926:	83 e8 04             	sub    $0x4,%eax
  800929:	8b 00                	mov    (%eax),%eax
  80092b:	83 ec 08             	sub    $0x8,%esp
  80092e:	ff 75 0c             	pushl  0xc(%ebp)
  800931:	50                   	push   %eax
  800932:	8b 45 08             	mov    0x8(%ebp),%eax
  800935:	ff d0                	call   *%eax
  800937:	83 c4 10             	add    $0x10,%esp
			break;
  80093a:	e9 89 02 00 00       	jmp    800bc8 <vprintfmt+0x3bc>

		// error message
		case 'e':
			err = va_arg(ap, int);
  80093f:	8b 45 14             	mov    0x14(%ebp),%eax
  800942:	83 c0 04             	add    $0x4,%eax
  800945:	89 45 14             	mov    %eax,0x14(%ebp)
  800948:	8b 45 14             	mov    0x14(%ebp),%eax
  80094b:	83 e8 04             	sub    $0x4,%eax
  80094e:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  800950:	85 db                	test   %ebx,%ebx
  800952:	79 02                	jns    800956 <vprintfmt+0x14a>
				err = -err;
  800954:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  800956:	83 fb 64             	cmp    $0x64,%ebx
  800959:	7f 0b                	jg     800966 <vprintfmt+0x15a>
  80095b:	8b 34 9d 60 35 80 00 	mov    0x803560(,%ebx,4),%esi
  800962:	85 f6                	test   %esi,%esi
  800964:	75 19                	jne    80097f <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  800966:	53                   	push   %ebx
  800967:	68 05 37 80 00       	push   $0x803705
  80096c:	ff 75 0c             	pushl  0xc(%ebp)
  80096f:	ff 75 08             	pushl  0x8(%ebp)
  800972:	e8 5e 02 00 00       	call   800bd5 <printfmt>
  800977:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  80097a:	e9 49 02 00 00       	jmp    800bc8 <vprintfmt+0x3bc>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  80097f:	56                   	push   %esi
  800980:	68 0e 37 80 00       	push   $0x80370e
  800985:	ff 75 0c             	pushl  0xc(%ebp)
  800988:	ff 75 08             	pushl  0x8(%ebp)
  80098b:	e8 45 02 00 00       	call   800bd5 <printfmt>
  800990:	83 c4 10             	add    $0x10,%esp
			break;
  800993:	e9 30 02 00 00       	jmp    800bc8 <vprintfmt+0x3bc>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  800998:	8b 45 14             	mov    0x14(%ebp),%eax
  80099b:	83 c0 04             	add    $0x4,%eax
  80099e:	89 45 14             	mov    %eax,0x14(%ebp)
  8009a1:	8b 45 14             	mov    0x14(%ebp),%eax
  8009a4:	83 e8 04             	sub    $0x4,%eax
  8009a7:	8b 30                	mov    (%eax),%esi
  8009a9:	85 f6                	test   %esi,%esi
  8009ab:	75 05                	jne    8009b2 <vprintfmt+0x1a6>
				p = "(null)";
  8009ad:	be 11 37 80 00       	mov    $0x803711,%esi
			if (width > 0 && padc != '-')
  8009b2:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8009b6:	7e 6d                	jle    800a25 <vprintfmt+0x219>
  8009b8:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  8009bc:	74 67                	je     800a25 <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  8009be:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8009c1:	83 ec 08             	sub    $0x8,%esp
  8009c4:	50                   	push   %eax
  8009c5:	56                   	push   %esi
  8009c6:	e8 0c 03 00 00       	call   800cd7 <strnlen>
  8009cb:	83 c4 10             	add    $0x10,%esp
  8009ce:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  8009d1:	eb 16                	jmp    8009e9 <vprintfmt+0x1dd>
					putch(padc, putdat);
  8009d3:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  8009d7:	83 ec 08             	sub    $0x8,%esp
  8009da:	ff 75 0c             	pushl  0xc(%ebp)
  8009dd:	50                   	push   %eax
  8009de:	8b 45 08             	mov    0x8(%ebp),%eax
  8009e1:	ff d0                	call   *%eax
  8009e3:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  8009e6:	ff 4d e4             	decl   -0x1c(%ebp)
  8009e9:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8009ed:	7f e4                	jg     8009d3 <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8009ef:	eb 34                	jmp    800a25 <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  8009f1:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  8009f5:	74 1c                	je     800a13 <vprintfmt+0x207>
  8009f7:	83 fb 1f             	cmp    $0x1f,%ebx
  8009fa:	7e 05                	jle    800a01 <vprintfmt+0x1f5>
  8009fc:	83 fb 7e             	cmp    $0x7e,%ebx
  8009ff:	7e 12                	jle    800a13 <vprintfmt+0x207>
					putch('?', putdat);
  800a01:	83 ec 08             	sub    $0x8,%esp
  800a04:	ff 75 0c             	pushl  0xc(%ebp)
  800a07:	6a 3f                	push   $0x3f
  800a09:	8b 45 08             	mov    0x8(%ebp),%eax
  800a0c:	ff d0                	call   *%eax
  800a0e:	83 c4 10             	add    $0x10,%esp
  800a11:	eb 0f                	jmp    800a22 <vprintfmt+0x216>
				else
					putch(ch, putdat);
  800a13:	83 ec 08             	sub    $0x8,%esp
  800a16:	ff 75 0c             	pushl  0xc(%ebp)
  800a19:	53                   	push   %ebx
  800a1a:	8b 45 08             	mov    0x8(%ebp),%eax
  800a1d:	ff d0                	call   *%eax
  800a1f:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800a22:	ff 4d e4             	decl   -0x1c(%ebp)
  800a25:	89 f0                	mov    %esi,%eax
  800a27:	8d 70 01             	lea    0x1(%eax),%esi
  800a2a:	8a 00                	mov    (%eax),%al
  800a2c:	0f be d8             	movsbl %al,%ebx
  800a2f:	85 db                	test   %ebx,%ebx
  800a31:	74 24                	je     800a57 <vprintfmt+0x24b>
  800a33:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800a37:	78 b8                	js     8009f1 <vprintfmt+0x1e5>
  800a39:	ff 4d e0             	decl   -0x20(%ebp)
  800a3c:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800a40:	79 af                	jns    8009f1 <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800a42:	eb 13                	jmp    800a57 <vprintfmt+0x24b>
				putch(' ', putdat);
  800a44:	83 ec 08             	sub    $0x8,%esp
  800a47:	ff 75 0c             	pushl  0xc(%ebp)
  800a4a:	6a 20                	push   $0x20
  800a4c:	8b 45 08             	mov    0x8(%ebp),%eax
  800a4f:	ff d0                	call   *%eax
  800a51:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800a54:	ff 4d e4             	decl   -0x1c(%ebp)
  800a57:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800a5b:	7f e7                	jg     800a44 <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  800a5d:	e9 66 01 00 00       	jmp    800bc8 <vprintfmt+0x3bc>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  800a62:	83 ec 08             	sub    $0x8,%esp
  800a65:	ff 75 e8             	pushl  -0x18(%ebp)
  800a68:	8d 45 14             	lea    0x14(%ebp),%eax
  800a6b:	50                   	push   %eax
  800a6c:	e8 3c fd ff ff       	call   8007ad <getint>
  800a71:	83 c4 10             	add    $0x10,%esp
  800a74:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800a77:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  800a7a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800a7d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800a80:	85 d2                	test   %edx,%edx
  800a82:	79 23                	jns    800aa7 <vprintfmt+0x29b>
				putch('-', putdat);
  800a84:	83 ec 08             	sub    $0x8,%esp
  800a87:	ff 75 0c             	pushl  0xc(%ebp)
  800a8a:	6a 2d                	push   $0x2d
  800a8c:	8b 45 08             	mov    0x8(%ebp),%eax
  800a8f:	ff d0                	call   *%eax
  800a91:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  800a94:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800a97:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800a9a:	f7 d8                	neg    %eax
  800a9c:	83 d2 00             	adc    $0x0,%edx
  800a9f:	f7 da                	neg    %edx
  800aa1:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800aa4:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  800aa7:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800aae:	e9 bc 00 00 00       	jmp    800b6f <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  800ab3:	83 ec 08             	sub    $0x8,%esp
  800ab6:	ff 75 e8             	pushl  -0x18(%ebp)
  800ab9:	8d 45 14             	lea    0x14(%ebp),%eax
  800abc:	50                   	push   %eax
  800abd:	e8 84 fc ff ff       	call   800746 <getuint>
  800ac2:	83 c4 10             	add    $0x10,%esp
  800ac5:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800ac8:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  800acb:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800ad2:	e9 98 00 00 00       	jmp    800b6f <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  800ad7:	83 ec 08             	sub    $0x8,%esp
  800ada:	ff 75 0c             	pushl  0xc(%ebp)
  800add:	6a 58                	push   $0x58
  800adf:	8b 45 08             	mov    0x8(%ebp),%eax
  800ae2:	ff d0                	call   *%eax
  800ae4:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800ae7:	83 ec 08             	sub    $0x8,%esp
  800aea:	ff 75 0c             	pushl  0xc(%ebp)
  800aed:	6a 58                	push   $0x58
  800aef:	8b 45 08             	mov    0x8(%ebp),%eax
  800af2:	ff d0                	call   *%eax
  800af4:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800af7:	83 ec 08             	sub    $0x8,%esp
  800afa:	ff 75 0c             	pushl  0xc(%ebp)
  800afd:	6a 58                	push   $0x58
  800aff:	8b 45 08             	mov    0x8(%ebp),%eax
  800b02:	ff d0                	call   *%eax
  800b04:	83 c4 10             	add    $0x10,%esp
			break;
  800b07:	e9 bc 00 00 00       	jmp    800bc8 <vprintfmt+0x3bc>

		// pointer
		case 'p':
			putch('0', putdat);
  800b0c:	83 ec 08             	sub    $0x8,%esp
  800b0f:	ff 75 0c             	pushl  0xc(%ebp)
  800b12:	6a 30                	push   $0x30
  800b14:	8b 45 08             	mov    0x8(%ebp),%eax
  800b17:	ff d0                	call   *%eax
  800b19:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  800b1c:	83 ec 08             	sub    $0x8,%esp
  800b1f:	ff 75 0c             	pushl  0xc(%ebp)
  800b22:	6a 78                	push   $0x78
  800b24:	8b 45 08             	mov    0x8(%ebp),%eax
  800b27:	ff d0                	call   *%eax
  800b29:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  800b2c:	8b 45 14             	mov    0x14(%ebp),%eax
  800b2f:	83 c0 04             	add    $0x4,%eax
  800b32:	89 45 14             	mov    %eax,0x14(%ebp)
  800b35:	8b 45 14             	mov    0x14(%ebp),%eax
  800b38:	83 e8 04             	sub    $0x4,%eax
  800b3b:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800b3d:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800b40:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  800b47:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  800b4e:	eb 1f                	jmp    800b6f <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  800b50:	83 ec 08             	sub    $0x8,%esp
  800b53:	ff 75 e8             	pushl  -0x18(%ebp)
  800b56:	8d 45 14             	lea    0x14(%ebp),%eax
  800b59:	50                   	push   %eax
  800b5a:	e8 e7 fb ff ff       	call   800746 <getuint>
  800b5f:	83 c4 10             	add    $0x10,%esp
  800b62:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800b65:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  800b68:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800b6f:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  800b73:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800b76:	83 ec 04             	sub    $0x4,%esp
  800b79:	52                   	push   %edx
  800b7a:	ff 75 e4             	pushl  -0x1c(%ebp)
  800b7d:	50                   	push   %eax
  800b7e:	ff 75 f4             	pushl  -0xc(%ebp)
  800b81:	ff 75 f0             	pushl  -0x10(%ebp)
  800b84:	ff 75 0c             	pushl  0xc(%ebp)
  800b87:	ff 75 08             	pushl  0x8(%ebp)
  800b8a:	e8 00 fb ff ff       	call   80068f <printnum>
  800b8f:	83 c4 20             	add    $0x20,%esp
			break;
  800b92:	eb 34                	jmp    800bc8 <vprintfmt+0x3bc>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  800b94:	83 ec 08             	sub    $0x8,%esp
  800b97:	ff 75 0c             	pushl  0xc(%ebp)
  800b9a:	53                   	push   %ebx
  800b9b:	8b 45 08             	mov    0x8(%ebp),%eax
  800b9e:	ff d0                	call   *%eax
  800ba0:	83 c4 10             	add    $0x10,%esp
			break;
  800ba3:	eb 23                	jmp    800bc8 <vprintfmt+0x3bc>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800ba5:	83 ec 08             	sub    $0x8,%esp
  800ba8:	ff 75 0c             	pushl  0xc(%ebp)
  800bab:	6a 25                	push   $0x25
  800bad:	8b 45 08             	mov    0x8(%ebp),%eax
  800bb0:	ff d0                	call   *%eax
  800bb2:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  800bb5:	ff 4d 10             	decl   0x10(%ebp)
  800bb8:	eb 03                	jmp    800bbd <vprintfmt+0x3b1>
  800bba:	ff 4d 10             	decl   0x10(%ebp)
  800bbd:	8b 45 10             	mov    0x10(%ebp),%eax
  800bc0:	48                   	dec    %eax
  800bc1:	8a 00                	mov    (%eax),%al
  800bc3:	3c 25                	cmp    $0x25,%al
  800bc5:	75 f3                	jne    800bba <vprintfmt+0x3ae>
				/* do nothing */;
			break;
  800bc7:	90                   	nop
		}
	}
  800bc8:	e9 47 fc ff ff       	jmp    800814 <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  800bcd:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  800bce:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800bd1:	5b                   	pop    %ebx
  800bd2:	5e                   	pop    %esi
  800bd3:	5d                   	pop    %ebp
  800bd4:	c3                   	ret    

00800bd5 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800bd5:	55                   	push   %ebp
  800bd6:	89 e5                	mov    %esp,%ebp
  800bd8:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  800bdb:	8d 45 10             	lea    0x10(%ebp),%eax
  800bde:	83 c0 04             	add    $0x4,%eax
  800be1:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  800be4:	8b 45 10             	mov    0x10(%ebp),%eax
  800be7:	ff 75 f4             	pushl  -0xc(%ebp)
  800bea:	50                   	push   %eax
  800beb:	ff 75 0c             	pushl  0xc(%ebp)
  800bee:	ff 75 08             	pushl  0x8(%ebp)
  800bf1:	e8 16 fc ff ff       	call   80080c <vprintfmt>
  800bf6:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  800bf9:	90                   	nop
  800bfa:	c9                   	leave  
  800bfb:	c3                   	ret    

00800bfc <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800bfc:	55                   	push   %ebp
  800bfd:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  800bff:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c02:	8b 40 08             	mov    0x8(%eax),%eax
  800c05:	8d 50 01             	lea    0x1(%eax),%edx
  800c08:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c0b:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  800c0e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c11:	8b 10                	mov    (%eax),%edx
  800c13:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c16:	8b 40 04             	mov    0x4(%eax),%eax
  800c19:	39 c2                	cmp    %eax,%edx
  800c1b:	73 12                	jae    800c2f <sprintputch+0x33>
		*b->buf++ = ch;
  800c1d:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c20:	8b 00                	mov    (%eax),%eax
  800c22:	8d 48 01             	lea    0x1(%eax),%ecx
  800c25:	8b 55 0c             	mov    0xc(%ebp),%edx
  800c28:	89 0a                	mov    %ecx,(%edx)
  800c2a:	8b 55 08             	mov    0x8(%ebp),%edx
  800c2d:	88 10                	mov    %dl,(%eax)
}
  800c2f:	90                   	nop
  800c30:	5d                   	pop    %ebp
  800c31:	c3                   	ret    

00800c32 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800c32:	55                   	push   %ebp
  800c33:	89 e5                	mov    %esp,%ebp
  800c35:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  800c38:	8b 45 08             	mov    0x8(%ebp),%eax
  800c3b:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800c3e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c41:	8d 50 ff             	lea    -0x1(%eax),%edx
  800c44:	8b 45 08             	mov    0x8(%ebp),%eax
  800c47:	01 d0                	add    %edx,%eax
  800c49:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800c4c:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800c53:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800c57:	74 06                	je     800c5f <vsnprintf+0x2d>
  800c59:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800c5d:	7f 07                	jg     800c66 <vsnprintf+0x34>
		return -E_INVAL;
  800c5f:	b8 03 00 00 00       	mov    $0x3,%eax
  800c64:	eb 20                	jmp    800c86 <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800c66:	ff 75 14             	pushl  0x14(%ebp)
  800c69:	ff 75 10             	pushl  0x10(%ebp)
  800c6c:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800c6f:	50                   	push   %eax
  800c70:	68 fc 0b 80 00       	push   $0x800bfc
  800c75:	e8 92 fb ff ff       	call   80080c <vprintfmt>
  800c7a:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  800c7d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800c80:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800c83:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  800c86:	c9                   	leave  
  800c87:	c3                   	ret    

00800c88 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800c88:	55                   	push   %ebp
  800c89:	89 e5                	mov    %esp,%ebp
  800c8b:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800c8e:	8d 45 10             	lea    0x10(%ebp),%eax
  800c91:	83 c0 04             	add    $0x4,%eax
  800c94:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  800c97:	8b 45 10             	mov    0x10(%ebp),%eax
  800c9a:	ff 75 f4             	pushl  -0xc(%ebp)
  800c9d:	50                   	push   %eax
  800c9e:	ff 75 0c             	pushl  0xc(%ebp)
  800ca1:	ff 75 08             	pushl  0x8(%ebp)
  800ca4:	e8 89 ff ff ff       	call   800c32 <vsnprintf>
  800ca9:	83 c4 10             	add    $0x10,%esp
  800cac:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  800caf:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800cb2:	c9                   	leave  
  800cb3:	c3                   	ret    

00800cb4 <strlen>:

#include <inc/string.h>

int
strlen(const char *s)
{
  800cb4:	55                   	push   %ebp
  800cb5:	89 e5                	mov    %esp,%ebp
  800cb7:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  800cba:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800cc1:	eb 06                	jmp    800cc9 <strlen+0x15>
		n++;
  800cc3:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  800cc6:	ff 45 08             	incl   0x8(%ebp)
  800cc9:	8b 45 08             	mov    0x8(%ebp),%eax
  800ccc:	8a 00                	mov    (%eax),%al
  800cce:	84 c0                	test   %al,%al
  800cd0:	75 f1                	jne    800cc3 <strlen+0xf>
		n++;
	return n;
  800cd2:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800cd5:	c9                   	leave  
  800cd6:	c3                   	ret    

00800cd7 <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  800cd7:	55                   	push   %ebp
  800cd8:	89 e5                	mov    %esp,%ebp
  800cda:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800cdd:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800ce4:	eb 09                	jmp    800cef <strnlen+0x18>
		n++;
  800ce6:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800ce9:	ff 45 08             	incl   0x8(%ebp)
  800cec:	ff 4d 0c             	decl   0xc(%ebp)
  800cef:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800cf3:	74 09                	je     800cfe <strnlen+0x27>
  800cf5:	8b 45 08             	mov    0x8(%ebp),%eax
  800cf8:	8a 00                	mov    (%eax),%al
  800cfa:	84 c0                	test   %al,%al
  800cfc:	75 e8                	jne    800ce6 <strnlen+0xf>
		n++;
	return n;
  800cfe:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800d01:	c9                   	leave  
  800d02:	c3                   	ret    

00800d03 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800d03:	55                   	push   %ebp
  800d04:	89 e5                	mov    %esp,%ebp
  800d06:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  800d09:	8b 45 08             	mov    0x8(%ebp),%eax
  800d0c:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  800d0f:	90                   	nop
  800d10:	8b 45 08             	mov    0x8(%ebp),%eax
  800d13:	8d 50 01             	lea    0x1(%eax),%edx
  800d16:	89 55 08             	mov    %edx,0x8(%ebp)
  800d19:	8b 55 0c             	mov    0xc(%ebp),%edx
  800d1c:	8d 4a 01             	lea    0x1(%edx),%ecx
  800d1f:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800d22:	8a 12                	mov    (%edx),%dl
  800d24:	88 10                	mov    %dl,(%eax)
  800d26:	8a 00                	mov    (%eax),%al
  800d28:	84 c0                	test   %al,%al
  800d2a:	75 e4                	jne    800d10 <strcpy+0xd>
		/* do nothing */;
	return ret;
  800d2c:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800d2f:	c9                   	leave  
  800d30:	c3                   	ret    

00800d31 <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  800d31:	55                   	push   %ebp
  800d32:	89 e5                	mov    %esp,%ebp
  800d34:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  800d37:	8b 45 08             	mov    0x8(%ebp),%eax
  800d3a:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  800d3d:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800d44:	eb 1f                	jmp    800d65 <strncpy+0x34>
		*dst++ = *src;
  800d46:	8b 45 08             	mov    0x8(%ebp),%eax
  800d49:	8d 50 01             	lea    0x1(%eax),%edx
  800d4c:	89 55 08             	mov    %edx,0x8(%ebp)
  800d4f:	8b 55 0c             	mov    0xc(%ebp),%edx
  800d52:	8a 12                	mov    (%edx),%dl
  800d54:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  800d56:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d59:	8a 00                	mov    (%eax),%al
  800d5b:	84 c0                	test   %al,%al
  800d5d:	74 03                	je     800d62 <strncpy+0x31>
			src++;
  800d5f:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800d62:	ff 45 fc             	incl   -0x4(%ebp)
  800d65:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800d68:	3b 45 10             	cmp    0x10(%ebp),%eax
  800d6b:	72 d9                	jb     800d46 <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  800d6d:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  800d70:	c9                   	leave  
  800d71:	c3                   	ret    

00800d72 <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  800d72:	55                   	push   %ebp
  800d73:	89 e5                	mov    %esp,%ebp
  800d75:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  800d78:	8b 45 08             	mov    0x8(%ebp),%eax
  800d7b:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  800d7e:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800d82:	74 30                	je     800db4 <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  800d84:	eb 16                	jmp    800d9c <strlcpy+0x2a>
			*dst++ = *src++;
  800d86:	8b 45 08             	mov    0x8(%ebp),%eax
  800d89:	8d 50 01             	lea    0x1(%eax),%edx
  800d8c:	89 55 08             	mov    %edx,0x8(%ebp)
  800d8f:	8b 55 0c             	mov    0xc(%ebp),%edx
  800d92:	8d 4a 01             	lea    0x1(%edx),%ecx
  800d95:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800d98:	8a 12                	mov    (%edx),%dl
  800d9a:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  800d9c:	ff 4d 10             	decl   0x10(%ebp)
  800d9f:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800da3:	74 09                	je     800dae <strlcpy+0x3c>
  800da5:	8b 45 0c             	mov    0xc(%ebp),%eax
  800da8:	8a 00                	mov    (%eax),%al
  800daa:	84 c0                	test   %al,%al
  800dac:	75 d8                	jne    800d86 <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  800dae:	8b 45 08             	mov    0x8(%ebp),%eax
  800db1:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800db4:	8b 55 08             	mov    0x8(%ebp),%edx
  800db7:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800dba:	29 c2                	sub    %eax,%edx
  800dbc:	89 d0                	mov    %edx,%eax
}
  800dbe:	c9                   	leave  
  800dbf:	c3                   	ret    

00800dc0 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800dc0:	55                   	push   %ebp
  800dc1:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  800dc3:	eb 06                	jmp    800dcb <strcmp+0xb>
		p++, q++;
  800dc5:	ff 45 08             	incl   0x8(%ebp)
  800dc8:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  800dcb:	8b 45 08             	mov    0x8(%ebp),%eax
  800dce:	8a 00                	mov    (%eax),%al
  800dd0:	84 c0                	test   %al,%al
  800dd2:	74 0e                	je     800de2 <strcmp+0x22>
  800dd4:	8b 45 08             	mov    0x8(%ebp),%eax
  800dd7:	8a 10                	mov    (%eax),%dl
  800dd9:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ddc:	8a 00                	mov    (%eax),%al
  800dde:	38 c2                	cmp    %al,%dl
  800de0:	74 e3                	je     800dc5 <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800de2:	8b 45 08             	mov    0x8(%ebp),%eax
  800de5:	8a 00                	mov    (%eax),%al
  800de7:	0f b6 d0             	movzbl %al,%edx
  800dea:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ded:	8a 00                	mov    (%eax),%al
  800def:	0f b6 c0             	movzbl %al,%eax
  800df2:	29 c2                	sub    %eax,%edx
  800df4:	89 d0                	mov    %edx,%eax
}
  800df6:	5d                   	pop    %ebp
  800df7:	c3                   	ret    

00800df8 <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  800df8:	55                   	push   %ebp
  800df9:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  800dfb:	eb 09                	jmp    800e06 <strncmp+0xe>
		n--, p++, q++;
  800dfd:	ff 4d 10             	decl   0x10(%ebp)
  800e00:	ff 45 08             	incl   0x8(%ebp)
  800e03:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  800e06:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800e0a:	74 17                	je     800e23 <strncmp+0x2b>
  800e0c:	8b 45 08             	mov    0x8(%ebp),%eax
  800e0f:	8a 00                	mov    (%eax),%al
  800e11:	84 c0                	test   %al,%al
  800e13:	74 0e                	je     800e23 <strncmp+0x2b>
  800e15:	8b 45 08             	mov    0x8(%ebp),%eax
  800e18:	8a 10                	mov    (%eax),%dl
  800e1a:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e1d:	8a 00                	mov    (%eax),%al
  800e1f:	38 c2                	cmp    %al,%dl
  800e21:	74 da                	je     800dfd <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  800e23:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800e27:	75 07                	jne    800e30 <strncmp+0x38>
		return 0;
  800e29:	b8 00 00 00 00       	mov    $0x0,%eax
  800e2e:	eb 14                	jmp    800e44 <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800e30:	8b 45 08             	mov    0x8(%ebp),%eax
  800e33:	8a 00                	mov    (%eax),%al
  800e35:	0f b6 d0             	movzbl %al,%edx
  800e38:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e3b:	8a 00                	mov    (%eax),%al
  800e3d:	0f b6 c0             	movzbl %al,%eax
  800e40:	29 c2                	sub    %eax,%edx
  800e42:	89 d0                	mov    %edx,%eax
}
  800e44:	5d                   	pop    %ebp
  800e45:	c3                   	ret    

00800e46 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800e46:	55                   	push   %ebp
  800e47:	89 e5                	mov    %esp,%ebp
  800e49:	83 ec 04             	sub    $0x4,%esp
  800e4c:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e4f:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800e52:	eb 12                	jmp    800e66 <strchr+0x20>
		if (*s == c)
  800e54:	8b 45 08             	mov    0x8(%ebp),%eax
  800e57:	8a 00                	mov    (%eax),%al
  800e59:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800e5c:	75 05                	jne    800e63 <strchr+0x1d>
			return (char *) s;
  800e5e:	8b 45 08             	mov    0x8(%ebp),%eax
  800e61:	eb 11                	jmp    800e74 <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  800e63:	ff 45 08             	incl   0x8(%ebp)
  800e66:	8b 45 08             	mov    0x8(%ebp),%eax
  800e69:	8a 00                	mov    (%eax),%al
  800e6b:	84 c0                	test   %al,%al
  800e6d:	75 e5                	jne    800e54 <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  800e6f:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800e74:	c9                   	leave  
  800e75:	c3                   	ret    

00800e76 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800e76:	55                   	push   %ebp
  800e77:	89 e5                	mov    %esp,%ebp
  800e79:	83 ec 04             	sub    $0x4,%esp
  800e7c:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e7f:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800e82:	eb 0d                	jmp    800e91 <strfind+0x1b>
		if (*s == c)
  800e84:	8b 45 08             	mov    0x8(%ebp),%eax
  800e87:	8a 00                	mov    (%eax),%al
  800e89:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800e8c:	74 0e                	je     800e9c <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  800e8e:	ff 45 08             	incl   0x8(%ebp)
  800e91:	8b 45 08             	mov    0x8(%ebp),%eax
  800e94:	8a 00                	mov    (%eax),%al
  800e96:	84 c0                	test   %al,%al
  800e98:	75 ea                	jne    800e84 <strfind+0xe>
  800e9a:	eb 01                	jmp    800e9d <strfind+0x27>
		if (*s == c)
			break;
  800e9c:	90                   	nop
	return (char *) s;
  800e9d:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800ea0:	c9                   	leave  
  800ea1:	c3                   	ret    

00800ea2 <memset>:


void *
memset(void *v, int c, uint32 n)
{
  800ea2:	55                   	push   %ebp
  800ea3:	89 e5                	mov    %esp,%ebp
  800ea5:	83 ec 10             	sub    $0x10,%esp
	char *p;
	int m;

	p = v;
  800ea8:	8b 45 08             	mov    0x8(%ebp),%eax
  800eab:	89 45 fc             	mov    %eax,-0x4(%ebp)
	m = n;
  800eae:	8b 45 10             	mov    0x10(%ebp),%eax
  800eb1:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (--m >= 0)
  800eb4:	eb 0e                	jmp    800ec4 <memset+0x22>
		*p++ = c;
  800eb6:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800eb9:	8d 50 01             	lea    0x1(%eax),%edx
  800ebc:	89 55 fc             	mov    %edx,-0x4(%ebp)
  800ebf:	8b 55 0c             	mov    0xc(%ebp),%edx
  800ec2:	88 10                	mov    %dl,(%eax)
	char *p;
	int m;

	p = v;
	m = n;
	while (--m >= 0)
  800ec4:	ff 4d f8             	decl   -0x8(%ebp)
  800ec7:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
  800ecb:	79 e9                	jns    800eb6 <memset+0x14>
		*p++ = c;

	return v;
  800ecd:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800ed0:	c9                   	leave  
  800ed1:	c3                   	ret    

00800ed2 <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  800ed2:	55                   	push   %ebp
  800ed3:	89 e5                	mov    %esp,%ebp
  800ed5:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  800ed8:	8b 45 0c             	mov    0xc(%ebp),%eax
  800edb:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  800ede:	8b 45 08             	mov    0x8(%ebp),%eax
  800ee1:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (n-- > 0)
  800ee4:	eb 16                	jmp    800efc <memcpy+0x2a>
		*d++ = *s++;
  800ee6:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800ee9:	8d 50 01             	lea    0x1(%eax),%edx
  800eec:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800eef:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800ef2:	8d 4a 01             	lea    0x1(%edx),%ecx
  800ef5:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  800ef8:	8a 12                	mov    (%edx),%dl
  800efa:	88 10                	mov    %dl,(%eax)
	const char *s;
	char *d;

	s = src;
	d = dst;
	while (n-- > 0)
  800efc:	8b 45 10             	mov    0x10(%ebp),%eax
  800eff:	8d 50 ff             	lea    -0x1(%eax),%edx
  800f02:	89 55 10             	mov    %edx,0x10(%ebp)
  800f05:	85 c0                	test   %eax,%eax
  800f07:	75 dd                	jne    800ee6 <memcpy+0x14>
		*d++ = *s++;

	return dst;
  800f09:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800f0c:	c9                   	leave  
  800f0d:	c3                   	ret    

00800f0e <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  800f0e:	55                   	push   %ebp
  800f0f:	89 e5                	mov    %esp,%ebp
  800f11:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  800f14:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f17:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  800f1a:	8b 45 08             	mov    0x8(%ebp),%eax
  800f1d:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  800f20:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800f23:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800f26:	73 50                	jae    800f78 <memmove+0x6a>
  800f28:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800f2b:	8b 45 10             	mov    0x10(%ebp),%eax
  800f2e:	01 d0                	add    %edx,%eax
  800f30:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800f33:	76 43                	jbe    800f78 <memmove+0x6a>
		s += n;
  800f35:	8b 45 10             	mov    0x10(%ebp),%eax
  800f38:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  800f3b:	8b 45 10             	mov    0x10(%ebp),%eax
  800f3e:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  800f41:	eb 10                	jmp    800f53 <memmove+0x45>
			*--d = *--s;
  800f43:	ff 4d f8             	decl   -0x8(%ebp)
  800f46:	ff 4d fc             	decl   -0x4(%ebp)
  800f49:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800f4c:	8a 10                	mov    (%eax),%dl
  800f4e:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800f51:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  800f53:	8b 45 10             	mov    0x10(%ebp),%eax
  800f56:	8d 50 ff             	lea    -0x1(%eax),%edx
  800f59:	89 55 10             	mov    %edx,0x10(%ebp)
  800f5c:	85 c0                	test   %eax,%eax
  800f5e:	75 e3                	jne    800f43 <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800f60:	eb 23                	jmp    800f85 <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  800f62:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800f65:	8d 50 01             	lea    0x1(%eax),%edx
  800f68:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800f6b:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800f6e:	8d 4a 01             	lea    0x1(%edx),%ecx
  800f71:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  800f74:	8a 12                	mov    (%edx),%dl
  800f76:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  800f78:	8b 45 10             	mov    0x10(%ebp),%eax
  800f7b:	8d 50 ff             	lea    -0x1(%eax),%edx
  800f7e:	89 55 10             	mov    %edx,0x10(%ebp)
  800f81:	85 c0                	test   %eax,%eax
  800f83:	75 dd                	jne    800f62 <memmove+0x54>
			*d++ = *s++;

	return dst;
  800f85:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800f88:	c9                   	leave  
  800f89:	c3                   	ret    

00800f8a <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  800f8a:	55                   	push   %ebp
  800f8b:	89 e5                	mov    %esp,%ebp
  800f8d:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  800f90:	8b 45 08             	mov    0x8(%ebp),%eax
  800f93:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  800f96:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f99:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  800f9c:	eb 2a                	jmp    800fc8 <memcmp+0x3e>
		if (*s1 != *s2)
  800f9e:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800fa1:	8a 10                	mov    (%eax),%dl
  800fa3:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800fa6:	8a 00                	mov    (%eax),%al
  800fa8:	38 c2                	cmp    %al,%dl
  800faa:	74 16                	je     800fc2 <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  800fac:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800faf:	8a 00                	mov    (%eax),%al
  800fb1:	0f b6 d0             	movzbl %al,%edx
  800fb4:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800fb7:	8a 00                	mov    (%eax),%al
  800fb9:	0f b6 c0             	movzbl %al,%eax
  800fbc:	29 c2                	sub    %eax,%edx
  800fbe:	89 d0                	mov    %edx,%eax
  800fc0:	eb 18                	jmp    800fda <memcmp+0x50>
		s1++, s2++;
  800fc2:	ff 45 fc             	incl   -0x4(%ebp)
  800fc5:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  800fc8:	8b 45 10             	mov    0x10(%ebp),%eax
  800fcb:	8d 50 ff             	lea    -0x1(%eax),%edx
  800fce:	89 55 10             	mov    %edx,0x10(%ebp)
  800fd1:	85 c0                	test   %eax,%eax
  800fd3:	75 c9                	jne    800f9e <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  800fd5:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800fda:	c9                   	leave  
  800fdb:	c3                   	ret    

00800fdc <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  800fdc:	55                   	push   %ebp
  800fdd:	89 e5                	mov    %esp,%ebp
  800fdf:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  800fe2:	8b 55 08             	mov    0x8(%ebp),%edx
  800fe5:	8b 45 10             	mov    0x10(%ebp),%eax
  800fe8:	01 d0                	add    %edx,%eax
  800fea:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  800fed:	eb 15                	jmp    801004 <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  800fef:	8b 45 08             	mov    0x8(%ebp),%eax
  800ff2:	8a 00                	mov    (%eax),%al
  800ff4:	0f b6 d0             	movzbl %al,%edx
  800ff7:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ffa:	0f b6 c0             	movzbl %al,%eax
  800ffd:	39 c2                	cmp    %eax,%edx
  800fff:	74 0d                	je     80100e <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  801001:	ff 45 08             	incl   0x8(%ebp)
  801004:	8b 45 08             	mov    0x8(%ebp),%eax
  801007:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  80100a:	72 e3                	jb     800fef <memfind+0x13>
  80100c:	eb 01                	jmp    80100f <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  80100e:	90                   	nop
	return (void *) s;
  80100f:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801012:	c9                   	leave  
  801013:	c3                   	ret    

00801014 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  801014:	55                   	push   %ebp
  801015:	89 e5                	mov    %esp,%ebp
  801017:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  80101a:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  801021:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801028:	eb 03                	jmp    80102d <strtol+0x19>
		s++;
  80102a:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  80102d:	8b 45 08             	mov    0x8(%ebp),%eax
  801030:	8a 00                	mov    (%eax),%al
  801032:	3c 20                	cmp    $0x20,%al
  801034:	74 f4                	je     80102a <strtol+0x16>
  801036:	8b 45 08             	mov    0x8(%ebp),%eax
  801039:	8a 00                	mov    (%eax),%al
  80103b:	3c 09                	cmp    $0x9,%al
  80103d:	74 eb                	je     80102a <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  80103f:	8b 45 08             	mov    0x8(%ebp),%eax
  801042:	8a 00                	mov    (%eax),%al
  801044:	3c 2b                	cmp    $0x2b,%al
  801046:	75 05                	jne    80104d <strtol+0x39>
		s++;
  801048:	ff 45 08             	incl   0x8(%ebp)
  80104b:	eb 13                	jmp    801060 <strtol+0x4c>
	else if (*s == '-')
  80104d:	8b 45 08             	mov    0x8(%ebp),%eax
  801050:	8a 00                	mov    (%eax),%al
  801052:	3c 2d                	cmp    $0x2d,%al
  801054:	75 0a                	jne    801060 <strtol+0x4c>
		s++, neg = 1;
  801056:	ff 45 08             	incl   0x8(%ebp)
  801059:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  801060:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801064:	74 06                	je     80106c <strtol+0x58>
  801066:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  80106a:	75 20                	jne    80108c <strtol+0x78>
  80106c:	8b 45 08             	mov    0x8(%ebp),%eax
  80106f:	8a 00                	mov    (%eax),%al
  801071:	3c 30                	cmp    $0x30,%al
  801073:	75 17                	jne    80108c <strtol+0x78>
  801075:	8b 45 08             	mov    0x8(%ebp),%eax
  801078:	40                   	inc    %eax
  801079:	8a 00                	mov    (%eax),%al
  80107b:	3c 78                	cmp    $0x78,%al
  80107d:	75 0d                	jne    80108c <strtol+0x78>
		s += 2, base = 16;
  80107f:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  801083:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  80108a:	eb 28                	jmp    8010b4 <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  80108c:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801090:	75 15                	jne    8010a7 <strtol+0x93>
  801092:	8b 45 08             	mov    0x8(%ebp),%eax
  801095:	8a 00                	mov    (%eax),%al
  801097:	3c 30                	cmp    $0x30,%al
  801099:	75 0c                	jne    8010a7 <strtol+0x93>
		s++, base = 8;
  80109b:	ff 45 08             	incl   0x8(%ebp)
  80109e:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  8010a5:	eb 0d                	jmp    8010b4 <strtol+0xa0>
	else if (base == 0)
  8010a7:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8010ab:	75 07                	jne    8010b4 <strtol+0xa0>
		base = 10;
  8010ad:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  8010b4:	8b 45 08             	mov    0x8(%ebp),%eax
  8010b7:	8a 00                	mov    (%eax),%al
  8010b9:	3c 2f                	cmp    $0x2f,%al
  8010bb:	7e 19                	jle    8010d6 <strtol+0xc2>
  8010bd:	8b 45 08             	mov    0x8(%ebp),%eax
  8010c0:	8a 00                	mov    (%eax),%al
  8010c2:	3c 39                	cmp    $0x39,%al
  8010c4:	7f 10                	jg     8010d6 <strtol+0xc2>
			dig = *s - '0';
  8010c6:	8b 45 08             	mov    0x8(%ebp),%eax
  8010c9:	8a 00                	mov    (%eax),%al
  8010cb:	0f be c0             	movsbl %al,%eax
  8010ce:	83 e8 30             	sub    $0x30,%eax
  8010d1:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8010d4:	eb 42                	jmp    801118 <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  8010d6:	8b 45 08             	mov    0x8(%ebp),%eax
  8010d9:	8a 00                	mov    (%eax),%al
  8010db:	3c 60                	cmp    $0x60,%al
  8010dd:	7e 19                	jle    8010f8 <strtol+0xe4>
  8010df:	8b 45 08             	mov    0x8(%ebp),%eax
  8010e2:	8a 00                	mov    (%eax),%al
  8010e4:	3c 7a                	cmp    $0x7a,%al
  8010e6:	7f 10                	jg     8010f8 <strtol+0xe4>
			dig = *s - 'a' + 10;
  8010e8:	8b 45 08             	mov    0x8(%ebp),%eax
  8010eb:	8a 00                	mov    (%eax),%al
  8010ed:	0f be c0             	movsbl %al,%eax
  8010f0:	83 e8 57             	sub    $0x57,%eax
  8010f3:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8010f6:	eb 20                	jmp    801118 <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  8010f8:	8b 45 08             	mov    0x8(%ebp),%eax
  8010fb:	8a 00                	mov    (%eax),%al
  8010fd:	3c 40                	cmp    $0x40,%al
  8010ff:	7e 39                	jle    80113a <strtol+0x126>
  801101:	8b 45 08             	mov    0x8(%ebp),%eax
  801104:	8a 00                	mov    (%eax),%al
  801106:	3c 5a                	cmp    $0x5a,%al
  801108:	7f 30                	jg     80113a <strtol+0x126>
			dig = *s - 'A' + 10;
  80110a:	8b 45 08             	mov    0x8(%ebp),%eax
  80110d:	8a 00                	mov    (%eax),%al
  80110f:	0f be c0             	movsbl %al,%eax
  801112:	83 e8 37             	sub    $0x37,%eax
  801115:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  801118:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80111b:	3b 45 10             	cmp    0x10(%ebp),%eax
  80111e:	7d 19                	jge    801139 <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  801120:	ff 45 08             	incl   0x8(%ebp)
  801123:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801126:	0f af 45 10          	imul   0x10(%ebp),%eax
  80112a:	89 c2                	mov    %eax,%edx
  80112c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80112f:	01 d0                	add    %edx,%eax
  801131:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  801134:	e9 7b ff ff ff       	jmp    8010b4 <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  801139:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  80113a:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80113e:	74 08                	je     801148 <strtol+0x134>
		*endptr = (char *) s;
  801140:	8b 45 0c             	mov    0xc(%ebp),%eax
  801143:	8b 55 08             	mov    0x8(%ebp),%edx
  801146:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  801148:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  80114c:	74 07                	je     801155 <strtol+0x141>
  80114e:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801151:	f7 d8                	neg    %eax
  801153:	eb 03                	jmp    801158 <strtol+0x144>
  801155:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  801158:	c9                   	leave  
  801159:	c3                   	ret    

0080115a <ltostr>:

void
ltostr(long value, char *str)
{
  80115a:	55                   	push   %ebp
  80115b:	89 e5                	mov    %esp,%ebp
  80115d:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  801160:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  801167:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  80116e:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801172:	79 13                	jns    801187 <ltostr+0x2d>
	{
		neg = 1;
  801174:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  80117b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80117e:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  801181:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  801184:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  801187:	8b 45 08             	mov    0x8(%ebp),%eax
  80118a:	b9 0a 00 00 00       	mov    $0xa,%ecx
  80118f:	99                   	cltd   
  801190:	f7 f9                	idiv   %ecx
  801192:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  801195:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801198:	8d 50 01             	lea    0x1(%eax),%edx
  80119b:	89 55 f8             	mov    %edx,-0x8(%ebp)
  80119e:	89 c2                	mov    %eax,%edx
  8011a0:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011a3:	01 d0                	add    %edx,%eax
  8011a5:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8011a8:	83 c2 30             	add    $0x30,%edx
  8011ab:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  8011ad:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8011b0:	b8 67 66 66 66       	mov    $0x66666667,%eax
  8011b5:	f7 e9                	imul   %ecx
  8011b7:	c1 fa 02             	sar    $0x2,%edx
  8011ba:	89 c8                	mov    %ecx,%eax
  8011bc:	c1 f8 1f             	sar    $0x1f,%eax
  8011bf:	29 c2                	sub    %eax,%edx
  8011c1:	89 d0                	mov    %edx,%eax
  8011c3:	89 45 08             	mov    %eax,0x8(%ebp)
	} while (value % 10 != 0);
  8011c6:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8011c9:	b8 67 66 66 66       	mov    $0x66666667,%eax
  8011ce:	f7 e9                	imul   %ecx
  8011d0:	c1 fa 02             	sar    $0x2,%edx
  8011d3:	89 c8                	mov    %ecx,%eax
  8011d5:	c1 f8 1f             	sar    $0x1f,%eax
  8011d8:	29 c2                	sub    %eax,%edx
  8011da:	89 d0                	mov    %edx,%eax
  8011dc:	c1 e0 02             	shl    $0x2,%eax
  8011df:	01 d0                	add    %edx,%eax
  8011e1:	01 c0                	add    %eax,%eax
  8011e3:	29 c1                	sub    %eax,%ecx
  8011e5:	89 ca                	mov    %ecx,%edx
  8011e7:	85 d2                	test   %edx,%edx
  8011e9:	75 9c                	jne    801187 <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  8011eb:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  8011f2:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8011f5:	48                   	dec    %eax
  8011f6:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  8011f9:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  8011fd:	74 3d                	je     80123c <ltostr+0xe2>
		start = 1 ;
  8011ff:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  801206:	eb 34                	jmp    80123c <ltostr+0xe2>
	{
		char tmp = str[start] ;
  801208:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80120b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80120e:	01 d0                	add    %edx,%eax
  801210:	8a 00                	mov    (%eax),%al
  801212:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  801215:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801218:	8b 45 0c             	mov    0xc(%ebp),%eax
  80121b:	01 c2                	add    %eax,%edx
  80121d:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  801220:	8b 45 0c             	mov    0xc(%ebp),%eax
  801223:	01 c8                	add    %ecx,%eax
  801225:	8a 00                	mov    (%eax),%al
  801227:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  801229:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80122c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80122f:	01 c2                	add    %eax,%edx
  801231:	8a 45 eb             	mov    -0x15(%ebp),%al
  801234:	88 02                	mov    %al,(%edx)
		start++ ;
  801236:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  801239:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  80123c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80123f:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801242:	7c c4                	jl     801208 <ltostr+0xae>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  801244:	8b 55 f8             	mov    -0x8(%ebp),%edx
  801247:	8b 45 0c             	mov    0xc(%ebp),%eax
  80124a:	01 d0                	add    %edx,%eax
  80124c:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  80124f:	90                   	nop
  801250:	c9                   	leave  
  801251:	c3                   	ret    

00801252 <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  801252:	55                   	push   %ebp
  801253:	89 e5                	mov    %esp,%ebp
  801255:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  801258:	ff 75 08             	pushl  0x8(%ebp)
  80125b:	e8 54 fa ff ff       	call   800cb4 <strlen>
  801260:	83 c4 04             	add    $0x4,%esp
  801263:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  801266:	ff 75 0c             	pushl  0xc(%ebp)
  801269:	e8 46 fa ff ff       	call   800cb4 <strlen>
  80126e:	83 c4 04             	add    $0x4,%esp
  801271:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  801274:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  80127b:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801282:	eb 17                	jmp    80129b <strcconcat+0x49>
		final[s] = str1[s] ;
  801284:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801287:	8b 45 10             	mov    0x10(%ebp),%eax
  80128a:	01 c2                	add    %eax,%edx
  80128c:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  80128f:	8b 45 08             	mov    0x8(%ebp),%eax
  801292:	01 c8                	add    %ecx,%eax
  801294:	8a 00                	mov    (%eax),%al
  801296:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  801298:	ff 45 fc             	incl   -0x4(%ebp)
  80129b:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80129e:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  8012a1:	7c e1                	jl     801284 <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  8012a3:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  8012aa:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  8012b1:	eb 1f                	jmp    8012d2 <strcconcat+0x80>
		final[s++] = str2[i] ;
  8012b3:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8012b6:	8d 50 01             	lea    0x1(%eax),%edx
  8012b9:	89 55 fc             	mov    %edx,-0x4(%ebp)
  8012bc:	89 c2                	mov    %eax,%edx
  8012be:	8b 45 10             	mov    0x10(%ebp),%eax
  8012c1:	01 c2                	add    %eax,%edx
  8012c3:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  8012c6:	8b 45 0c             	mov    0xc(%ebp),%eax
  8012c9:	01 c8                	add    %ecx,%eax
  8012cb:	8a 00                	mov    (%eax),%al
  8012cd:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  8012cf:	ff 45 f8             	incl   -0x8(%ebp)
  8012d2:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8012d5:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8012d8:	7c d9                	jl     8012b3 <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  8012da:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8012dd:	8b 45 10             	mov    0x10(%ebp),%eax
  8012e0:	01 d0                	add    %edx,%eax
  8012e2:	c6 00 00             	movb   $0x0,(%eax)
}
  8012e5:	90                   	nop
  8012e6:	c9                   	leave  
  8012e7:	c3                   	ret    

008012e8 <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  8012e8:	55                   	push   %ebp
  8012e9:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  8012eb:	8b 45 14             	mov    0x14(%ebp),%eax
  8012ee:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  8012f4:	8b 45 14             	mov    0x14(%ebp),%eax
  8012f7:	8b 00                	mov    (%eax),%eax
  8012f9:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801300:	8b 45 10             	mov    0x10(%ebp),%eax
  801303:	01 d0                	add    %edx,%eax
  801305:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  80130b:	eb 0c                	jmp    801319 <strsplit+0x31>
			*string++ = 0;
  80130d:	8b 45 08             	mov    0x8(%ebp),%eax
  801310:	8d 50 01             	lea    0x1(%eax),%edx
  801313:	89 55 08             	mov    %edx,0x8(%ebp)
  801316:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801319:	8b 45 08             	mov    0x8(%ebp),%eax
  80131c:	8a 00                	mov    (%eax),%al
  80131e:	84 c0                	test   %al,%al
  801320:	74 18                	je     80133a <strsplit+0x52>
  801322:	8b 45 08             	mov    0x8(%ebp),%eax
  801325:	8a 00                	mov    (%eax),%al
  801327:	0f be c0             	movsbl %al,%eax
  80132a:	50                   	push   %eax
  80132b:	ff 75 0c             	pushl  0xc(%ebp)
  80132e:	e8 13 fb ff ff       	call   800e46 <strchr>
  801333:	83 c4 08             	add    $0x8,%esp
  801336:	85 c0                	test   %eax,%eax
  801338:	75 d3                	jne    80130d <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  80133a:	8b 45 08             	mov    0x8(%ebp),%eax
  80133d:	8a 00                	mov    (%eax),%al
  80133f:	84 c0                	test   %al,%al
  801341:	74 5a                	je     80139d <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  801343:	8b 45 14             	mov    0x14(%ebp),%eax
  801346:	8b 00                	mov    (%eax),%eax
  801348:	83 f8 0f             	cmp    $0xf,%eax
  80134b:	75 07                	jne    801354 <strsplit+0x6c>
		{
			return 0;
  80134d:	b8 00 00 00 00       	mov    $0x0,%eax
  801352:	eb 66                	jmp    8013ba <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  801354:	8b 45 14             	mov    0x14(%ebp),%eax
  801357:	8b 00                	mov    (%eax),%eax
  801359:	8d 48 01             	lea    0x1(%eax),%ecx
  80135c:	8b 55 14             	mov    0x14(%ebp),%edx
  80135f:	89 0a                	mov    %ecx,(%edx)
  801361:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801368:	8b 45 10             	mov    0x10(%ebp),%eax
  80136b:	01 c2                	add    %eax,%edx
  80136d:	8b 45 08             	mov    0x8(%ebp),%eax
  801370:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  801372:	eb 03                	jmp    801377 <strsplit+0x8f>
			string++;
  801374:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  801377:	8b 45 08             	mov    0x8(%ebp),%eax
  80137a:	8a 00                	mov    (%eax),%al
  80137c:	84 c0                	test   %al,%al
  80137e:	74 8b                	je     80130b <strsplit+0x23>
  801380:	8b 45 08             	mov    0x8(%ebp),%eax
  801383:	8a 00                	mov    (%eax),%al
  801385:	0f be c0             	movsbl %al,%eax
  801388:	50                   	push   %eax
  801389:	ff 75 0c             	pushl  0xc(%ebp)
  80138c:	e8 b5 fa ff ff       	call   800e46 <strchr>
  801391:	83 c4 08             	add    $0x8,%esp
  801394:	85 c0                	test   %eax,%eax
  801396:	74 dc                	je     801374 <strsplit+0x8c>
			string++;
	}
  801398:	e9 6e ff ff ff       	jmp    80130b <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  80139d:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  80139e:	8b 45 14             	mov    0x14(%ebp),%eax
  8013a1:	8b 00                	mov    (%eax),%eax
  8013a3:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8013aa:	8b 45 10             	mov    0x10(%ebp),%eax
  8013ad:	01 d0                	add    %edx,%eax
  8013af:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  8013b5:	b8 01 00 00 00       	mov    $0x1,%eax
}
  8013ba:	c9                   	leave  
  8013bb:	c3                   	ret    

008013bc <InitializeUHeap>:
//============================== GIVEN FUNCTIONS ===================================//
//==================================================================================//

int FirstTimeFlag = 1;
void InitializeUHeap()
{
  8013bc:	55                   	push   %ebp
  8013bd:	89 e5                	mov    %esp,%ebp
  8013bf:	83 ec 08             	sub    $0x8,%esp
	if(FirstTimeFlag)
  8013c2:	a1 04 40 80 00       	mov    0x804004,%eax
  8013c7:	85 c0                	test   %eax,%eax
  8013c9:	74 1f                	je     8013ea <InitializeUHeap+0x2e>
	{
		initialize_dyn_block_system();
  8013cb:	e8 1d 00 00 00       	call   8013ed <initialize_dyn_block_system>
		cprintf("DYNAMIC BLOCK SYSTEM IS INITIALIZED\n");
  8013d0:	83 ec 0c             	sub    $0xc,%esp
  8013d3:	68 70 38 80 00       	push   $0x803870
  8013d8:	e8 55 f2 ff ff       	call   800632 <cprintf>
  8013dd:	83 c4 10             	add    $0x10,%esp
#if UHP_USE_BUDDY
		initialize_buddy();
		cprintf("BUDDY SYSTEM IS INITIALIZED\n");
#endif
		FirstTimeFlag = 0;
  8013e0:	c7 05 04 40 80 00 00 	movl   $0x0,0x804004
  8013e7:	00 00 00 
	}
}
  8013ea:	90                   	nop
  8013eb:	c9                   	leave  
  8013ec:	c3                   	ret    

008013ed <initialize_dyn_block_system>:

//=================================
// [1] INITIALIZE DYNAMIC ALLOCATOR:
//=================================
void initialize_dyn_block_system()
{
  8013ed:	55                   	push   %ebp
  8013ee:	89 e5                	mov    %esp,%ebp
  8013f0:	83 ec 28             	sub    $0x28,%esp
	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] initialize_dyn_block_system
	// your code is here, remove the panic and write your code
	//panic("initialize_dyn_block_system() is not implemented yet...!!");

	LIST_INIT(&AllocMemBlocksList);
  8013f3:	c7 05 40 40 80 00 00 	movl   $0x0,0x804040
  8013fa:	00 00 00 
  8013fd:	c7 05 44 40 80 00 00 	movl   $0x0,0x804044
  801404:	00 00 00 
  801407:	c7 05 4c 40 80 00 00 	movl   $0x0,0x80404c
  80140e:	00 00 00 
	LIST_INIT(&FreeMemBlocksList);
  801411:	c7 05 38 41 80 00 00 	movl   $0x0,0x804138
  801418:	00 00 00 
  80141b:	c7 05 3c 41 80 00 00 	movl   $0x0,0x80413c
  801422:	00 00 00 
  801425:	c7 05 44 41 80 00 00 	movl   $0x0,0x804144
  80142c:	00 00 00 
	MAX_MEM_BLOCK_CNT = NUM_OF_UHEAP_PAGES;
  80142f:	c7 05 20 41 80 00 00 	movl   $0x20000,0x804120
  801436:	00 02 00 
	MemBlockNodes = (void*)USER_DYN_BLKS_ARRAY;
  801439:	c7 45 f4 00 00 e0 7f 	movl   $0x7fe00000,-0xc(%ebp)
  801440:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801443:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801448:	2d 00 10 00 00       	sub    $0x1000,%eax
  80144d:	a3 50 40 80 00       	mov    %eax,0x804050
	int size_of_block = sizeof(struct MemBlock);
  801452:	c7 45 f0 10 00 00 00 	movl   $0x10,-0x10(%ebp)
	int size_all_struct = size_of_block*MAX_MEM_BLOCK_CNT;
  801459:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80145c:	a1 20 41 80 00       	mov    0x804120,%eax
  801461:	0f af c2             	imul   %edx,%eax
  801464:	89 45 ec             	mov    %eax,-0x14(%ebp)
	size_all_struct = ROUNDUP(size_all_struct, PAGE_SIZE);
  801467:	c7 45 e8 00 10 00 00 	movl   $0x1000,-0x18(%ebp)
  80146e:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801471:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801474:	01 d0                	add    %edx,%eax
  801476:	48                   	dec    %eax
  801477:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  80147a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80147d:	ba 00 00 00 00       	mov    $0x0,%edx
  801482:	f7 75 e8             	divl   -0x18(%ebp)
  801485:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801488:	29 d0                	sub    %edx,%eax
  80148a:	89 45 ec             	mov    %eax,-0x14(%ebp)
	sys_allocate_chunk(USER_DYN_BLKS_ARRAY, size_all_struct,PERM_USER| PERM_WRITEABLE);
  80148d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801490:	c7 45 e0 00 00 e0 7f 	movl   $0x7fe00000,-0x20(%ebp)
  801497:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80149a:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
  8014a0:	81 ea 00 10 00 00    	sub    $0x1000,%edx
  8014a6:	83 ec 04             	sub    $0x4,%esp
  8014a9:	6a 06                	push   $0x6
  8014ab:	50                   	push   %eax
  8014ac:	52                   	push   %edx
  8014ad:	e8 a1 05 00 00       	call   801a53 <sys_allocate_chunk>
  8014b2:	83 c4 10             	add    $0x10,%esp
	initialize_MemBlocksList(MAX_MEM_BLOCK_CNT);
  8014b5:	a1 20 41 80 00       	mov    0x804120,%eax
  8014ba:	83 ec 0c             	sub    $0xc,%esp
  8014bd:	50                   	push   %eax
  8014be:	e8 16 0c 00 00       	call   8020d9 <initialize_MemBlocksList>
  8014c3:	83 c4 10             	add    $0x10,%esp
	struct MemBlock* ourBlock =LIST_LAST(&AvailableMemBlocksList);
  8014c6:	a1 4c 41 80 00       	mov    0x80414c,%eax
  8014cb:	89 45 dc             	mov    %eax,-0x24(%ebp)
	LIST_REMOVE(&AvailableMemBlocksList,ourBlock);
  8014ce:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  8014d2:	75 14                	jne    8014e8 <initialize_dyn_block_system+0xfb>
  8014d4:	83 ec 04             	sub    $0x4,%esp
  8014d7:	68 95 38 80 00       	push   $0x803895
  8014dc:	6a 2d                	push   $0x2d
  8014de:	68 b3 38 80 00       	push   $0x8038b3
  8014e3:	e8 96 ee ff ff       	call   80037e <_panic>
  8014e8:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8014eb:	8b 00                	mov    (%eax),%eax
  8014ed:	85 c0                	test   %eax,%eax
  8014ef:	74 10                	je     801501 <initialize_dyn_block_system+0x114>
  8014f1:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8014f4:	8b 00                	mov    (%eax),%eax
  8014f6:	8b 55 dc             	mov    -0x24(%ebp),%edx
  8014f9:	8b 52 04             	mov    0x4(%edx),%edx
  8014fc:	89 50 04             	mov    %edx,0x4(%eax)
  8014ff:	eb 0b                	jmp    80150c <initialize_dyn_block_system+0x11f>
  801501:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801504:	8b 40 04             	mov    0x4(%eax),%eax
  801507:	a3 4c 41 80 00       	mov    %eax,0x80414c
  80150c:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80150f:	8b 40 04             	mov    0x4(%eax),%eax
  801512:	85 c0                	test   %eax,%eax
  801514:	74 0f                	je     801525 <initialize_dyn_block_system+0x138>
  801516:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801519:	8b 40 04             	mov    0x4(%eax),%eax
  80151c:	8b 55 dc             	mov    -0x24(%ebp),%edx
  80151f:	8b 12                	mov    (%edx),%edx
  801521:	89 10                	mov    %edx,(%eax)
  801523:	eb 0a                	jmp    80152f <initialize_dyn_block_system+0x142>
  801525:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801528:	8b 00                	mov    (%eax),%eax
  80152a:	a3 48 41 80 00       	mov    %eax,0x804148
  80152f:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801532:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  801538:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80153b:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  801542:	a1 54 41 80 00       	mov    0x804154,%eax
  801547:	48                   	dec    %eax
  801548:	a3 54 41 80 00       	mov    %eax,0x804154
	ourBlock->size = USER_HEAP_MAX-USER_HEAP_START;
  80154d:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801550:	c7 40 0c 00 00 00 20 	movl   $0x20000000,0xc(%eax)
	ourBlock->sva=USER_HEAP_START;
  801557:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80155a:	c7 40 08 00 00 00 80 	movl   $0x80000000,0x8(%eax)
	LIST_INSERT_TAIL(&FreeMemBlocksList, ourBlock);
  801561:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  801565:	75 14                	jne    80157b <initialize_dyn_block_system+0x18e>
  801567:	83 ec 04             	sub    $0x4,%esp
  80156a:	68 c0 38 80 00       	push   $0x8038c0
  80156f:	6a 30                	push   $0x30
  801571:	68 b3 38 80 00       	push   $0x8038b3
  801576:	e8 03 ee ff ff       	call   80037e <_panic>
  80157b:	8b 15 3c 41 80 00    	mov    0x80413c,%edx
  801581:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801584:	89 50 04             	mov    %edx,0x4(%eax)
  801587:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80158a:	8b 40 04             	mov    0x4(%eax),%eax
  80158d:	85 c0                	test   %eax,%eax
  80158f:	74 0c                	je     80159d <initialize_dyn_block_system+0x1b0>
  801591:	a1 3c 41 80 00       	mov    0x80413c,%eax
  801596:	8b 55 dc             	mov    -0x24(%ebp),%edx
  801599:	89 10                	mov    %edx,(%eax)
  80159b:	eb 08                	jmp    8015a5 <initialize_dyn_block_system+0x1b8>
  80159d:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8015a0:	a3 38 41 80 00       	mov    %eax,0x804138
  8015a5:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8015a8:	a3 3c 41 80 00       	mov    %eax,0x80413c
  8015ad:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8015b0:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8015b6:	a1 44 41 80 00       	mov    0x804144,%eax
  8015bb:	40                   	inc    %eax
  8015bc:	a3 44 41 80 00       	mov    %eax,0x804144
	//[1] Initialize two lists (AllocMemBlocksList & FreeMemBlocksList) [Hint: use LIST_INIT()]
	//[2] Dynamically allocate the array of MemBlockNodes at VA USER_DYN_BLKS_ARRAY
	//	  (remember to set MAX_MEM_BLOCK_CNT with the chosen size of the array)
	//[3] Initialize AvailableMemBlocksList by filling it with the MemBlockNodes
	//[4] Insert a new MemBlock with the heap size into the FreeMemBlocksList
}
  8015c1:	90                   	nop
  8015c2:	c9                   	leave  
  8015c3:	c3                   	ret    

008015c4 <malloc>:
//=================================
// [2] ALLOCATE SPACE IN USER HEAP:
//=================================

void* malloc(uint32 size)
{
  8015c4:	55                   	push   %ebp
  8015c5:	89 e5                	mov    %esp,%ebp
  8015c7:	83 ec 18             	sub    $0x18,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  8015ca:	e8 ed fd ff ff       	call   8013bc <InitializeUHeap>
	if (size == 0) return NULL ;
  8015cf:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8015d3:	75 07                	jne    8015dc <malloc+0x18>
  8015d5:	b8 00 00 00 00       	mov    $0x0,%eax
  8015da:	eb 67                	jmp    801643 <malloc+0x7f>

	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] malloc
	// your code is here, remove the panic and write your code
	//panic("malloc() is not implemented yet...!!");

	size = ROUNDUP(size, PAGE_SIZE);
  8015dc:	c7 45 f4 00 10 00 00 	movl   $0x1000,-0xc(%ebp)
  8015e3:	8b 55 08             	mov    0x8(%ebp),%edx
  8015e6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8015e9:	01 d0                	add    %edx,%eax
  8015eb:	48                   	dec    %eax
  8015ec:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8015ef:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8015f2:	ba 00 00 00 00       	mov    $0x0,%edx
  8015f7:	f7 75 f4             	divl   -0xc(%ebp)
  8015fa:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8015fd:	29 d0                	sub    %edx,%eax
  8015ff:	89 45 08             	mov    %eax,0x8(%ebp)
	if(sys_isUHeapPlacementStrategyFIRSTFIT())
  801602:	e8 1a 08 00 00       	call   801e21 <sys_isUHeapPlacementStrategyFIRSTFIT>
  801607:	85 c0                	test   %eax,%eax
  801609:	74 33                	je     80163e <malloc+0x7a>
	{
		struct MemBlock * myBlock = alloc_block_FF(size);
  80160b:	83 ec 0c             	sub    $0xc,%esp
  80160e:	ff 75 08             	pushl  0x8(%ebp)
  801611:	e8 0c 0e 00 00       	call   802422 <alloc_block_FF>
  801616:	83 c4 10             	add    $0x10,%esp
  801619:	89 45 ec             	mov    %eax,-0x14(%ebp)
		if(myBlock != NULL)
  80161c:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  801620:	74 1c                	je     80163e <malloc+0x7a>
		{
			insert_sorted_allocList(myBlock);
  801622:	83 ec 0c             	sub    $0xc,%esp
  801625:	ff 75 ec             	pushl  -0x14(%ebp)
  801628:	e8 07 0c 00 00       	call   802234 <insert_sorted_allocList>
  80162d:	83 c4 10             	add    $0x10,%esp
			uint32 ptr = myBlock->sva;
  801630:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801633:	8b 40 08             	mov    0x8(%eax),%eax
  801636:	89 45 e8             	mov    %eax,-0x18(%ebp)
			return (void *)ptr;
  801639:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80163c:	eb 05                	jmp    801643 <malloc+0x7f>
		}
	}
	return NULL;
  80163e:	b8 00 00 00 00       	mov    $0x0,%eax
	//		to the required allocation size (space should be on 4 KB BOUNDARY)
	//	2) if no suitable space found, return NULL
	// 	3) Return pointer containing the virtual address of allocated space,
	//
	//Use sys_isUHeapPlacementStrategyFIRSTFIT()... to check the current strategy
}
  801643:	c9                   	leave  
  801644:	c3                   	ret    

00801645 <free>:
//	We can use sys_free_user_mem(uint32 virtual_address, uint32 size); which
//		switches to the kernel mode, calls free_user_mem() in
//		"kern/mem/chunk_operations.c", then switch back to the user mode here
//	the free_user_mem function is empty, make sure to implement it.
void free(void* virtual_address)
{
  801645:	55                   	push   %ebp
  801646:	89 e5                	mov    %esp,%ebp
  801648:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] free
	// your code is here, remove the panic and write your code
	//panic("free() is not implemented yet...!!");

	uint32 virtualAddress = (uint32 )(virtual_address);
  80164b:	8b 45 08             	mov    0x8(%ebp),%eax
  80164e:	89 45 f4             	mov    %eax,-0xc(%ebp)
//	virtualAddress = ROUNDDOWN(virtualAddress, PAGE_SIZE);
	struct MemBlock * myBlock = find_block(&AllocMemBlocksList, virtualAddress);
  801651:	83 ec 08             	sub    $0x8,%esp
  801654:	ff 75 f4             	pushl  -0xc(%ebp)
  801657:	68 40 40 80 00       	push   $0x804040
  80165c:	e8 5b 0b 00 00       	call   8021bc <find_block>
  801661:	83 c4 10             	add    $0x10,%esp
  801664:	89 45 f0             	mov    %eax,-0x10(%ebp)
//	cprintf ("ptr sva at free user side = %x \n", myBlock->sva);
	sys_free_user_mem(virtualAddress, myBlock->size);
  801667:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80166a:	8b 40 0c             	mov    0xc(%eax),%eax
  80166d:	83 ec 08             	sub    $0x8,%esp
  801670:	50                   	push   %eax
  801671:	ff 75 f4             	pushl  -0xc(%ebp)
  801674:	e8 a2 03 00 00       	call   801a1b <sys_free_user_mem>
  801679:	83 c4 10             	add    $0x10,%esp
	LIST_REMOVE(&AllocMemBlocksList, myBlock);
  80167c:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801680:	75 14                	jne    801696 <free+0x51>
  801682:	83 ec 04             	sub    $0x4,%esp
  801685:	68 95 38 80 00       	push   $0x803895
  80168a:	6a 76                	push   $0x76
  80168c:	68 b3 38 80 00       	push   $0x8038b3
  801691:	e8 e8 ec ff ff       	call   80037e <_panic>
  801696:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801699:	8b 00                	mov    (%eax),%eax
  80169b:	85 c0                	test   %eax,%eax
  80169d:	74 10                	je     8016af <free+0x6a>
  80169f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8016a2:	8b 00                	mov    (%eax),%eax
  8016a4:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8016a7:	8b 52 04             	mov    0x4(%edx),%edx
  8016aa:	89 50 04             	mov    %edx,0x4(%eax)
  8016ad:	eb 0b                	jmp    8016ba <free+0x75>
  8016af:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8016b2:	8b 40 04             	mov    0x4(%eax),%eax
  8016b5:	a3 44 40 80 00       	mov    %eax,0x804044
  8016ba:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8016bd:	8b 40 04             	mov    0x4(%eax),%eax
  8016c0:	85 c0                	test   %eax,%eax
  8016c2:	74 0f                	je     8016d3 <free+0x8e>
  8016c4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8016c7:	8b 40 04             	mov    0x4(%eax),%eax
  8016ca:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8016cd:	8b 12                	mov    (%edx),%edx
  8016cf:	89 10                	mov    %edx,(%eax)
  8016d1:	eb 0a                	jmp    8016dd <free+0x98>
  8016d3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8016d6:	8b 00                	mov    (%eax),%eax
  8016d8:	a3 40 40 80 00       	mov    %eax,0x804040
  8016dd:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8016e0:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8016e6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8016e9:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8016f0:	a1 4c 40 80 00       	mov    0x80404c,%eax
  8016f5:	48                   	dec    %eax
  8016f6:	a3 4c 40 80 00       	mov    %eax,0x80404c
	insert_sorted_with_merge_freeList(myBlock);
  8016fb:	83 ec 0c             	sub    $0xc,%esp
  8016fe:	ff 75 f0             	pushl  -0x10(%ebp)
  801701:	e8 0b 14 00 00       	call   802b11 <insert_sorted_with_merge_freeList>
  801706:	83 c4 10             	add    $0x10,%esp

	//you should get the size of the given allocation using its address
	//you need to call sys_free_user_mem()
	//refer to the project presentation and documentation for details
}
  801709:	90                   	nop
  80170a:	c9                   	leave  
  80170b:	c3                   	ret    

0080170c <smalloc>:

//=================================
// [4] ALLOCATE SHARED VARIABLE:
//=================================
void* smalloc(char *sharedVarName, uint32 size, uint8 isWritable)
{
  80170c:	55                   	push   %ebp
  80170d:	89 e5                	mov    %esp,%ebp
  80170f:	83 ec 28             	sub    $0x28,%esp
  801712:	8b 45 10             	mov    0x10(%ebp),%eax
  801715:	88 45 e4             	mov    %al,-0x1c(%ebp)
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801718:	e8 9f fc ff ff       	call   8013bc <InitializeUHeap>
	if (size == 0) return NULL ;
  80171d:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801721:	75 0a                	jne    80172d <smalloc+0x21>
  801723:	b8 00 00 00 00       	mov    $0x0,%eax
  801728:	e9 8d 00 00 00       	jmp    8017ba <smalloc+0xae>

	//This function should find the space of the required range
	// * ON 4KB BOUNDARY **** //
	//Use sys_isUHeapPlacementStrategyFIRSTFIT() to check the current strategy

	size = ROUNDUP(size, PAGE_SIZE);
  80172d:	c7 45 f4 00 10 00 00 	movl   $0x1000,-0xc(%ebp)
  801734:	8b 55 0c             	mov    0xc(%ebp),%edx
  801737:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80173a:	01 d0                	add    %edx,%eax
  80173c:	48                   	dec    %eax
  80173d:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801740:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801743:	ba 00 00 00 00       	mov    $0x0,%edx
  801748:	f7 75 f4             	divl   -0xc(%ebp)
  80174b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80174e:	29 d0                	sub    %edx,%eax
  801750:	89 45 0c             	mov    %eax,0xc(%ebp)
		if(sys_isUHeapPlacementStrategyFIRSTFIT())
  801753:	e8 c9 06 00 00       	call   801e21 <sys_isUHeapPlacementStrategyFIRSTFIT>
  801758:	85 c0                	test   %eax,%eax
  80175a:	74 59                	je     8017b5 <smalloc+0xa9>
		{
			struct MemBlock * v1=NULL;
  80175c:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
			v1= alloc_block_FF(size);
  801763:	83 ec 0c             	sub    $0xc,%esp
  801766:	ff 75 0c             	pushl  0xc(%ebp)
  801769:	e8 b4 0c 00 00       	call   802422 <alloc_block_FF>
  80176e:	83 c4 10             	add    $0x10,%esp
  801771:	89 45 ec             	mov    %eax,-0x14(%ebp)
			if(v1==NULL)
  801774:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  801778:	75 07                	jne    801781 <smalloc+0x75>
			{
				return NULL;
  80177a:	b8 00 00 00 00       	mov    $0x0,%eax
  80177f:	eb 39                	jmp    8017ba <smalloc+0xae>
			}
			else
			{
				int ret=sys_createSharedObject(sharedVarName,  size,  isWritable,(void*)v1->sva);
  801781:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801784:	8b 40 08             	mov    0x8(%eax),%eax
  801787:	89 c2                	mov    %eax,%edx
  801789:	0f b6 45 e4          	movzbl -0x1c(%ebp),%eax
  80178d:	52                   	push   %edx
  80178e:	50                   	push   %eax
  80178f:	ff 75 0c             	pushl  0xc(%ebp)
  801792:	ff 75 08             	pushl  0x8(%ebp)
  801795:	e8 0c 04 00 00       	call   801ba6 <sys_createSharedObject>
  80179a:	83 c4 10             	add    $0x10,%esp
  80179d:	89 45 e8             	mov    %eax,-0x18(%ebp)
				if(ret>=0)
  8017a0:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  8017a4:	78 08                	js     8017ae <smalloc+0xa2>
				{
					return (void*)v1->sva;
  8017a6:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8017a9:	8b 40 08             	mov    0x8(%eax),%eax
  8017ac:	eb 0c                	jmp    8017ba <smalloc+0xae>
				}
				else
				{
					return NULL;
  8017ae:	b8 00 00 00 00       	mov    $0x0,%eax
  8017b3:	eb 05                	jmp    8017ba <smalloc+0xae>
				}
			}

		}
		return NULL;
  8017b5:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8017ba:	c9                   	leave  
  8017bb:	c3                   	ret    

008017bc <sget>:

//========================================
// [5] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
  8017bc:	55                   	push   %ebp
  8017bd:	89 e5                	mov    %esp,%ebp
  8017bf:	83 ec 18             	sub    $0x18,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  8017c2:	e8 f5 fb ff ff       	call   8013bc <InitializeUHeap>

	//This function should find the space for sharing the variable
	// *** ON 4KB BOUNDARY ******** //

	//Use sys_isUHeapPlacementStrategyFIRSTFIT() to check the current strategy
	int ret=sys_getSizeOfSharedObject(ownerEnvID,sharedVarName);
  8017c7:	83 ec 08             	sub    $0x8,%esp
  8017ca:	ff 75 0c             	pushl  0xc(%ebp)
  8017cd:	ff 75 08             	pushl  0x8(%ebp)
  8017d0:	e8 fb 03 00 00       	call   801bd0 <sys_getSizeOfSharedObject>
  8017d5:	83 c4 10             	add    $0x10,%esp
  8017d8:	89 45 f4             	mov    %eax,-0xc(%ebp)
	if(ret==0)
  8017db:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8017df:	75 07                	jne    8017e8 <sget+0x2c>
	{
		return NULL;
  8017e1:	b8 00 00 00 00       	mov    $0x0,%eax
  8017e6:	eb 64                	jmp    80184c <sget+0x90>
	}
	if(sys_isUHeapPlacementStrategyFIRSTFIT())
  8017e8:	e8 34 06 00 00       	call   801e21 <sys_isUHeapPlacementStrategyFIRSTFIT>
  8017ed:	85 c0                	test   %eax,%eax
  8017ef:	74 56                	je     801847 <sget+0x8b>
	{
		struct MemBlock * v1=NULL;
  8017f1:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
		v1= alloc_block_FF(ret);
  8017f8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8017fb:	83 ec 0c             	sub    $0xc,%esp
  8017fe:	50                   	push   %eax
  8017ff:	e8 1e 0c 00 00       	call   802422 <alloc_block_FF>
  801804:	83 c4 10             	add    $0x10,%esp
  801807:	89 45 f0             	mov    %eax,-0x10(%ebp)
		if(v1==NULL)
  80180a:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80180e:	75 07                	jne    801817 <sget+0x5b>
		{
		return NULL;
  801810:	b8 00 00 00 00       	mov    $0x0,%eax
  801815:	eb 35                	jmp    80184c <sget+0x90>
	    }
		else
		{
			int ret1=sys_getSharedObject(ownerEnvID,sharedVarName,(void*)v1->sva);
  801817:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80181a:	8b 40 08             	mov    0x8(%eax),%eax
  80181d:	83 ec 04             	sub    $0x4,%esp
  801820:	50                   	push   %eax
  801821:	ff 75 0c             	pushl  0xc(%ebp)
  801824:	ff 75 08             	pushl  0x8(%ebp)
  801827:	e8 c1 03 00 00       	call   801bed <sys_getSharedObject>
  80182c:	83 c4 10             	add    $0x10,%esp
  80182f:	89 45 ec             	mov    %eax,-0x14(%ebp)
			if(ret1>=0)
  801832:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  801836:	78 08                	js     801840 <sget+0x84>
			{
				return (void*)v1->sva;
  801838:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80183b:	8b 40 08             	mov    0x8(%eax),%eax
  80183e:	eb 0c                	jmp    80184c <sget+0x90>
			}
			else
			{
				return NULL;
  801840:	b8 00 00 00 00       	mov    $0x0,%eax
  801845:	eb 05                	jmp    80184c <sget+0x90>
			}
		}
	}
  return NULL;
  801847:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80184c:	c9                   	leave  
  80184d:	c3                   	ret    

0080184e <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  80184e:	55                   	push   %ebp
  80184f:	89 e5                	mov    %esp,%ebp
  801851:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801854:	e8 63 fb ff ff       	call   8013bc <InitializeUHeap>
	//==============================================================
	// [USER HEAP - USER SIDE] realloc
	// Write your code here, remove the panic and write your code
	panic("realloc() is not implemented yet...!!");
  801859:	83 ec 04             	sub    $0x4,%esp
  80185c:	68 e4 38 80 00       	push   $0x8038e4
  801861:	68 0e 01 00 00       	push   $0x10e
  801866:	68 b3 38 80 00       	push   $0x8038b3
  80186b:	e8 0e eb ff ff       	call   80037e <_panic>

00801870 <sfree>:
//	use sys_freeSharedObject(...); which switches to the kernel mode,
//	calls freeSharedObject(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the freeSharedObject() function is empty, make sure to implement it.

void sfree(void* virtual_address)
{
  801870:	55                   	push   %ebp
  801871:	89 e5                	mov    %esp,%ebp
  801873:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT MS3 - BONUS] [SHARING - USER SIDE] sfree()

	// Write your code here, remove the panic and write your code
	panic("sfree() is not implemented yet...!!");
  801876:	83 ec 04             	sub    $0x4,%esp
  801879:	68 0c 39 80 00       	push   $0x80390c
  80187e:	68 22 01 00 00       	push   $0x122
  801883:	68 b3 38 80 00       	push   $0x8038b3
  801888:	e8 f1 ea ff ff       	call   80037e <_panic>

0080188d <expand>:

//==================================================================================//
//========================== MODIFICATION FUNCTIONS ================================//
//==================================================================================//
void expand(uint32 newSize)
{
  80188d:	55                   	push   %ebp
  80188e:	89 e5                	mov    %esp,%ebp
  801890:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801893:	83 ec 04             	sub    $0x4,%esp
  801896:	68 30 39 80 00       	push   $0x803930
  80189b:	68 2d 01 00 00       	push   $0x12d
  8018a0:	68 b3 38 80 00       	push   $0x8038b3
  8018a5:	e8 d4 ea ff ff       	call   80037e <_panic>

008018aa <shrink>:

}
void shrink(uint32 newSize)
{
  8018aa:	55                   	push   %ebp
  8018ab:	89 e5                	mov    %esp,%ebp
  8018ad:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  8018b0:	83 ec 04             	sub    $0x4,%esp
  8018b3:	68 30 39 80 00       	push   $0x803930
  8018b8:	68 32 01 00 00       	push   $0x132
  8018bd:	68 b3 38 80 00       	push   $0x8038b3
  8018c2:	e8 b7 ea ff ff       	call   80037e <_panic>

008018c7 <freeHeap>:

}
void freeHeap(void* virtual_address)
{
  8018c7:	55                   	push   %ebp
  8018c8:	89 e5                	mov    %esp,%ebp
  8018ca:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  8018cd:	83 ec 04             	sub    $0x4,%esp
  8018d0:	68 30 39 80 00       	push   $0x803930
  8018d5:	68 37 01 00 00       	push   $0x137
  8018da:	68 b3 38 80 00       	push   $0x8038b3
  8018df:	e8 9a ea ff ff       	call   80037e <_panic>

008018e4 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  8018e4:	55                   	push   %ebp
  8018e5:	89 e5                	mov    %esp,%ebp
  8018e7:	57                   	push   %edi
  8018e8:	56                   	push   %esi
  8018e9:	53                   	push   %ebx
  8018ea:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8018ed:	8b 45 08             	mov    0x8(%ebp),%eax
  8018f0:	8b 55 0c             	mov    0xc(%ebp),%edx
  8018f3:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8018f6:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8018f9:	8b 7d 18             	mov    0x18(%ebp),%edi
  8018fc:	8b 75 1c             	mov    0x1c(%ebp),%esi
  8018ff:	cd 30                	int    $0x30
  801901:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  801904:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801907:	83 c4 10             	add    $0x10,%esp
  80190a:	5b                   	pop    %ebx
  80190b:	5e                   	pop    %esi
  80190c:	5f                   	pop    %edi
  80190d:	5d                   	pop    %ebp
  80190e:	c3                   	ret    

0080190f <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  80190f:	55                   	push   %ebp
  801910:	89 e5                	mov    %esp,%ebp
  801912:	83 ec 04             	sub    $0x4,%esp
  801915:	8b 45 10             	mov    0x10(%ebp),%eax
  801918:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  80191b:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  80191f:	8b 45 08             	mov    0x8(%ebp),%eax
  801922:	6a 00                	push   $0x0
  801924:	6a 00                	push   $0x0
  801926:	52                   	push   %edx
  801927:	ff 75 0c             	pushl  0xc(%ebp)
  80192a:	50                   	push   %eax
  80192b:	6a 00                	push   $0x0
  80192d:	e8 b2 ff ff ff       	call   8018e4 <syscall>
  801932:	83 c4 18             	add    $0x18,%esp
}
  801935:	90                   	nop
  801936:	c9                   	leave  
  801937:	c3                   	ret    

00801938 <sys_cgetc>:

int
sys_cgetc(void)
{
  801938:	55                   	push   %ebp
  801939:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  80193b:	6a 00                	push   $0x0
  80193d:	6a 00                	push   $0x0
  80193f:	6a 00                	push   $0x0
  801941:	6a 00                	push   $0x0
  801943:	6a 00                	push   $0x0
  801945:	6a 01                	push   $0x1
  801947:	e8 98 ff ff ff       	call   8018e4 <syscall>
  80194c:	83 c4 18             	add    $0x18,%esp
}
  80194f:	c9                   	leave  
  801950:	c3                   	ret    

00801951 <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  801951:	55                   	push   %ebp
  801952:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  801954:	8b 55 0c             	mov    0xc(%ebp),%edx
  801957:	8b 45 08             	mov    0x8(%ebp),%eax
  80195a:	6a 00                	push   $0x0
  80195c:	6a 00                	push   $0x0
  80195e:	6a 00                	push   $0x0
  801960:	52                   	push   %edx
  801961:	50                   	push   %eax
  801962:	6a 05                	push   $0x5
  801964:	e8 7b ff ff ff       	call   8018e4 <syscall>
  801969:	83 c4 18             	add    $0x18,%esp
}
  80196c:	c9                   	leave  
  80196d:	c3                   	ret    

0080196e <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  80196e:	55                   	push   %ebp
  80196f:	89 e5                	mov    %esp,%ebp
  801971:	56                   	push   %esi
  801972:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  801973:	8b 75 18             	mov    0x18(%ebp),%esi
  801976:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801979:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80197c:	8b 55 0c             	mov    0xc(%ebp),%edx
  80197f:	8b 45 08             	mov    0x8(%ebp),%eax
  801982:	56                   	push   %esi
  801983:	53                   	push   %ebx
  801984:	51                   	push   %ecx
  801985:	52                   	push   %edx
  801986:	50                   	push   %eax
  801987:	6a 06                	push   $0x6
  801989:	e8 56 ff ff ff       	call   8018e4 <syscall>
  80198e:	83 c4 18             	add    $0x18,%esp
}
  801991:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801994:	5b                   	pop    %ebx
  801995:	5e                   	pop    %esi
  801996:	5d                   	pop    %ebp
  801997:	c3                   	ret    

00801998 <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  801998:	55                   	push   %ebp
  801999:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  80199b:	8b 55 0c             	mov    0xc(%ebp),%edx
  80199e:	8b 45 08             	mov    0x8(%ebp),%eax
  8019a1:	6a 00                	push   $0x0
  8019a3:	6a 00                	push   $0x0
  8019a5:	6a 00                	push   $0x0
  8019a7:	52                   	push   %edx
  8019a8:	50                   	push   %eax
  8019a9:	6a 07                	push   $0x7
  8019ab:	e8 34 ff ff ff       	call   8018e4 <syscall>
  8019b0:	83 c4 18             	add    $0x18,%esp
}
  8019b3:	c9                   	leave  
  8019b4:	c3                   	ret    

008019b5 <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  8019b5:	55                   	push   %ebp
  8019b6:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  8019b8:	6a 00                	push   $0x0
  8019ba:	6a 00                	push   $0x0
  8019bc:	6a 00                	push   $0x0
  8019be:	ff 75 0c             	pushl  0xc(%ebp)
  8019c1:	ff 75 08             	pushl  0x8(%ebp)
  8019c4:	6a 08                	push   $0x8
  8019c6:	e8 19 ff ff ff       	call   8018e4 <syscall>
  8019cb:	83 c4 18             	add    $0x18,%esp
}
  8019ce:	c9                   	leave  
  8019cf:	c3                   	ret    

008019d0 <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  8019d0:	55                   	push   %ebp
  8019d1:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  8019d3:	6a 00                	push   $0x0
  8019d5:	6a 00                	push   $0x0
  8019d7:	6a 00                	push   $0x0
  8019d9:	6a 00                	push   $0x0
  8019db:	6a 00                	push   $0x0
  8019dd:	6a 09                	push   $0x9
  8019df:	e8 00 ff ff ff       	call   8018e4 <syscall>
  8019e4:	83 c4 18             	add    $0x18,%esp
}
  8019e7:	c9                   	leave  
  8019e8:	c3                   	ret    

008019e9 <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  8019e9:	55                   	push   %ebp
  8019ea:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  8019ec:	6a 00                	push   $0x0
  8019ee:	6a 00                	push   $0x0
  8019f0:	6a 00                	push   $0x0
  8019f2:	6a 00                	push   $0x0
  8019f4:	6a 00                	push   $0x0
  8019f6:	6a 0a                	push   $0xa
  8019f8:	e8 e7 fe ff ff       	call   8018e4 <syscall>
  8019fd:	83 c4 18             	add    $0x18,%esp
}
  801a00:	c9                   	leave  
  801a01:	c3                   	ret    

00801a02 <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  801a02:	55                   	push   %ebp
  801a03:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  801a05:	6a 00                	push   $0x0
  801a07:	6a 00                	push   $0x0
  801a09:	6a 00                	push   $0x0
  801a0b:	6a 00                	push   $0x0
  801a0d:	6a 00                	push   $0x0
  801a0f:	6a 0b                	push   $0xb
  801a11:	e8 ce fe ff ff       	call   8018e4 <syscall>
  801a16:	83 c4 18             	add    $0x18,%esp
}
  801a19:	c9                   	leave  
  801a1a:	c3                   	ret    

00801a1b <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  801a1b:	55                   	push   %ebp
  801a1c:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  801a1e:	6a 00                	push   $0x0
  801a20:	6a 00                	push   $0x0
  801a22:	6a 00                	push   $0x0
  801a24:	ff 75 0c             	pushl  0xc(%ebp)
  801a27:	ff 75 08             	pushl  0x8(%ebp)
  801a2a:	6a 0f                	push   $0xf
  801a2c:	e8 b3 fe ff ff       	call   8018e4 <syscall>
  801a31:	83 c4 18             	add    $0x18,%esp
	return;
  801a34:	90                   	nop
}
  801a35:	c9                   	leave  
  801a36:	c3                   	ret    

00801a37 <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  801a37:	55                   	push   %ebp
  801a38:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  801a3a:	6a 00                	push   $0x0
  801a3c:	6a 00                	push   $0x0
  801a3e:	6a 00                	push   $0x0
  801a40:	ff 75 0c             	pushl  0xc(%ebp)
  801a43:	ff 75 08             	pushl  0x8(%ebp)
  801a46:	6a 10                	push   $0x10
  801a48:	e8 97 fe ff ff       	call   8018e4 <syscall>
  801a4d:	83 c4 18             	add    $0x18,%esp
	return ;
  801a50:	90                   	nop
}
  801a51:	c9                   	leave  
  801a52:	c3                   	ret    

00801a53 <sys_allocate_chunk>:

void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  801a53:	55                   	push   %ebp
  801a54:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  801a56:	6a 00                	push   $0x0
  801a58:	6a 00                	push   $0x0
  801a5a:	ff 75 10             	pushl  0x10(%ebp)
  801a5d:	ff 75 0c             	pushl  0xc(%ebp)
  801a60:	ff 75 08             	pushl  0x8(%ebp)
  801a63:	6a 11                	push   $0x11
  801a65:	e8 7a fe ff ff       	call   8018e4 <syscall>
  801a6a:	83 c4 18             	add    $0x18,%esp
	return ;
  801a6d:	90                   	nop
}
  801a6e:	c9                   	leave  
  801a6f:	c3                   	ret    

00801a70 <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  801a70:	55                   	push   %ebp
  801a71:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  801a73:	6a 00                	push   $0x0
  801a75:	6a 00                	push   $0x0
  801a77:	6a 00                	push   $0x0
  801a79:	6a 00                	push   $0x0
  801a7b:	6a 00                	push   $0x0
  801a7d:	6a 0c                	push   $0xc
  801a7f:	e8 60 fe ff ff       	call   8018e4 <syscall>
  801a84:	83 c4 18             	add    $0x18,%esp
}
  801a87:	c9                   	leave  
  801a88:	c3                   	ret    

00801a89 <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  801a89:	55                   	push   %ebp
  801a8a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  801a8c:	6a 00                	push   $0x0
  801a8e:	6a 00                	push   $0x0
  801a90:	6a 00                	push   $0x0
  801a92:	6a 00                	push   $0x0
  801a94:	ff 75 08             	pushl  0x8(%ebp)
  801a97:	6a 0d                	push   $0xd
  801a99:	e8 46 fe ff ff       	call   8018e4 <syscall>
  801a9e:	83 c4 18             	add    $0x18,%esp
}
  801aa1:	c9                   	leave  
  801aa2:	c3                   	ret    

00801aa3 <sys_scarce_memory>:

void sys_scarce_memory()
{
  801aa3:	55                   	push   %ebp
  801aa4:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  801aa6:	6a 00                	push   $0x0
  801aa8:	6a 00                	push   $0x0
  801aaa:	6a 00                	push   $0x0
  801aac:	6a 00                	push   $0x0
  801aae:	6a 00                	push   $0x0
  801ab0:	6a 0e                	push   $0xe
  801ab2:	e8 2d fe ff ff       	call   8018e4 <syscall>
  801ab7:	83 c4 18             	add    $0x18,%esp
}
  801aba:	90                   	nop
  801abb:	c9                   	leave  
  801abc:	c3                   	ret    

00801abd <sys_disable_interrupt>:

//NEW !! 2012...
void
sys_disable_interrupt()
{
  801abd:	55                   	push   %ebp
  801abe:	89 e5                	mov    %esp,%ebp
	syscall(SYS_disableINTR,0, 0, 0, 0, 0);
  801ac0:	6a 00                	push   $0x0
  801ac2:	6a 00                	push   $0x0
  801ac4:	6a 00                	push   $0x0
  801ac6:	6a 00                	push   $0x0
  801ac8:	6a 00                	push   $0x0
  801aca:	6a 13                	push   $0x13
  801acc:	e8 13 fe ff ff       	call   8018e4 <syscall>
  801ad1:	83 c4 18             	add    $0x18,%esp
}
  801ad4:	90                   	nop
  801ad5:	c9                   	leave  
  801ad6:	c3                   	ret    

00801ad7 <sys_enable_interrupt>:


void
sys_enable_interrupt()
{
  801ad7:	55                   	push   %ebp
  801ad8:	89 e5                	mov    %esp,%ebp
	syscall(SYS_enableINTR,0, 0, 0, 0, 0);
  801ada:	6a 00                	push   $0x0
  801adc:	6a 00                	push   $0x0
  801ade:	6a 00                	push   $0x0
  801ae0:	6a 00                	push   $0x0
  801ae2:	6a 00                	push   $0x0
  801ae4:	6a 14                	push   $0x14
  801ae6:	e8 f9 fd ff ff       	call   8018e4 <syscall>
  801aeb:	83 c4 18             	add    $0x18,%esp
}
  801aee:	90                   	nop
  801aef:	c9                   	leave  
  801af0:	c3                   	ret    

00801af1 <sys_cputc>:


void
sys_cputc(const char c)
{
  801af1:	55                   	push   %ebp
  801af2:	89 e5                	mov    %esp,%ebp
  801af4:	83 ec 04             	sub    $0x4,%esp
  801af7:	8b 45 08             	mov    0x8(%ebp),%eax
  801afa:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  801afd:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801b01:	6a 00                	push   $0x0
  801b03:	6a 00                	push   $0x0
  801b05:	6a 00                	push   $0x0
  801b07:	6a 00                	push   $0x0
  801b09:	50                   	push   %eax
  801b0a:	6a 15                	push   $0x15
  801b0c:	e8 d3 fd ff ff       	call   8018e4 <syscall>
  801b11:	83 c4 18             	add    $0x18,%esp
}
  801b14:	90                   	nop
  801b15:	c9                   	leave  
  801b16:	c3                   	ret    

00801b17 <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  801b17:	55                   	push   %ebp
  801b18:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  801b1a:	6a 00                	push   $0x0
  801b1c:	6a 00                	push   $0x0
  801b1e:	6a 00                	push   $0x0
  801b20:	6a 00                	push   $0x0
  801b22:	6a 00                	push   $0x0
  801b24:	6a 16                	push   $0x16
  801b26:	e8 b9 fd ff ff       	call   8018e4 <syscall>
  801b2b:	83 c4 18             	add    $0x18,%esp
}
  801b2e:	90                   	nop
  801b2f:	c9                   	leave  
  801b30:	c3                   	ret    

00801b31 <sys_createSemaphore>:

int
sys_createSemaphore(char* semaphoreName, uint32 initialValue)
{
  801b31:	55                   	push   %ebp
  801b32:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_semaphore,(uint32)semaphoreName, (uint32)initialValue, 0, 0, 0);
  801b34:	8b 45 08             	mov    0x8(%ebp),%eax
  801b37:	6a 00                	push   $0x0
  801b39:	6a 00                	push   $0x0
  801b3b:	6a 00                	push   $0x0
  801b3d:	ff 75 0c             	pushl  0xc(%ebp)
  801b40:	50                   	push   %eax
  801b41:	6a 17                	push   $0x17
  801b43:	e8 9c fd ff ff       	call   8018e4 <syscall>
  801b48:	83 c4 18             	add    $0x18,%esp
}
  801b4b:	c9                   	leave  
  801b4c:	c3                   	ret    

00801b4d <sys_getSemaphoreValue>:

int
sys_getSemaphoreValue(int32 ownerEnvID, char* semaphoreName)
{
  801b4d:	55                   	push   %ebp
  801b4e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_semaphore_value,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801b50:	8b 55 0c             	mov    0xc(%ebp),%edx
  801b53:	8b 45 08             	mov    0x8(%ebp),%eax
  801b56:	6a 00                	push   $0x0
  801b58:	6a 00                	push   $0x0
  801b5a:	6a 00                	push   $0x0
  801b5c:	52                   	push   %edx
  801b5d:	50                   	push   %eax
  801b5e:	6a 1a                	push   $0x1a
  801b60:	e8 7f fd ff ff       	call   8018e4 <syscall>
  801b65:	83 c4 18             	add    $0x18,%esp
}
  801b68:	c9                   	leave  
  801b69:	c3                   	ret    

00801b6a <sys_waitSemaphore>:

void
sys_waitSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  801b6a:	55                   	push   %ebp
  801b6b:	89 e5                	mov    %esp,%ebp
	syscall(SYS_wait_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801b6d:	8b 55 0c             	mov    0xc(%ebp),%edx
  801b70:	8b 45 08             	mov    0x8(%ebp),%eax
  801b73:	6a 00                	push   $0x0
  801b75:	6a 00                	push   $0x0
  801b77:	6a 00                	push   $0x0
  801b79:	52                   	push   %edx
  801b7a:	50                   	push   %eax
  801b7b:	6a 18                	push   $0x18
  801b7d:	e8 62 fd ff ff       	call   8018e4 <syscall>
  801b82:	83 c4 18             	add    $0x18,%esp
}
  801b85:	90                   	nop
  801b86:	c9                   	leave  
  801b87:	c3                   	ret    

00801b88 <sys_signalSemaphore>:

void
sys_signalSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  801b88:	55                   	push   %ebp
  801b89:	89 e5                	mov    %esp,%ebp
	syscall(SYS_signal_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801b8b:	8b 55 0c             	mov    0xc(%ebp),%edx
  801b8e:	8b 45 08             	mov    0x8(%ebp),%eax
  801b91:	6a 00                	push   $0x0
  801b93:	6a 00                	push   $0x0
  801b95:	6a 00                	push   $0x0
  801b97:	52                   	push   %edx
  801b98:	50                   	push   %eax
  801b99:	6a 19                	push   $0x19
  801b9b:	e8 44 fd ff ff       	call   8018e4 <syscall>
  801ba0:	83 c4 18             	add    $0x18,%esp
}
  801ba3:	90                   	nop
  801ba4:	c9                   	leave  
  801ba5:	c3                   	ret    

00801ba6 <sys_createSharedObject>:

int
sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  801ba6:	55                   	push   %ebp
  801ba7:	89 e5                	mov    %esp,%ebp
  801ba9:	83 ec 04             	sub    $0x4,%esp
  801bac:	8b 45 10             	mov    0x10(%ebp),%eax
  801baf:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  801bb2:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801bb5:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801bb9:	8b 45 08             	mov    0x8(%ebp),%eax
  801bbc:	6a 00                	push   $0x0
  801bbe:	51                   	push   %ecx
  801bbf:	52                   	push   %edx
  801bc0:	ff 75 0c             	pushl  0xc(%ebp)
  801bc3:	50                   	push   %eax
  801bc4:	6a 1b                	push   $0x1b
  801bc6:	e8 19 fd ff ff       	call   8018e4 <syscall>
  801bcb:	83 c4 18             	add    $0x18,%esp
}
  801bce:	c9                   	leave  
  801bcf:	c3                   	ret    

00801bd0 <sys_getSizeOfSharedObject>:

//2017:
int
sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  801bd0:	55                   	push   %ebp
  801bd1:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  801bd3:	8b 55 0c             	mov    0xc(%ebp),%edx
  801bd6:	8b 45 08             	mov    0x8(%ebp),%eax
  801bd9:	6a 00                	push   $0x0
  801bdb:	6a 00                	push   $0x0
  801bdd:	6a 00                	push   $0x0
  801bdf:	52                   	push   %edx
  801be0:	50                   	push   %eax
  801be1:	6a 1c                	push   $0x1c
  801be3:	e8 fc fc ff ff       	call   8018e4 <syscall>
  801be8:	83 c4 18             	add    $0x18,%esp
}
  801beb:	c9                   	leave  
  801bec:	c3                   	ret    

00801bed <sys_getSharedObject>:
//==========

int
sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  801bed:	55                   	push   %ebp
  801bee:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  801bf0:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801bf3:	8b 55 0c             	mov    0xc(%ebp),%edx
  801bf6:	8b 45 08             	mov    0x8(%ebp),%eax
  801bf9:	6a 00                	push   $0x0
  801bfb:	6a 00                	push   $0x0
  801bfd:	51                   	push   %ecx
  801bfe:	52                   	push   %edx
  801bff:	50                   	push   %eax
  801c00:	6a 1d                	push   $0x1d
  801c02:	e8 dd fc ff ff       	call   8018e4 <syscall>
  801c07:	83 c4 18             	add    $0x18,%esp
}
  801c0a:	c9                   	leave  
  801c0b:	c3                   	ret    

00801c0c <sys_freeSharedObject>:

int
sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  801c0c:	55                   	push   %ebp
  801c0d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  801c0f:	8b 55 0c             	mov    0xc(%ebp),%edx
  801c12:	8b 45 08             	mov    0x8(%ebp),%eax
  801c15:	6a 00                	push   $0x0
  801c17:	6a 00                	push   $0x0
  801c19:	6a 00                	push   $0x0
  801c1b:	52                   	push   %edx
  801c1c:	50                   	push   %eax
  801c1d:	6a 1e                	push   $0x1e
  801c1f:	e8 c0 fc ff ff       	call   8018e4 <syscall>
  801c24:	83 c4 18             	add    $0x18,%esp
}
  801c27:	c9                   	leave  
  801c28:	c3                   	ret    

00801c29 <sys_getMaxShares>:

uint32 	sys_getMaxShares()
{
  801c29:	55                   	push   %ebp
  801c2a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_max_shares,0, 0, 0, 0, 0);
  801c2c:	6a 00                	push   $0x0
  801c2e:	6a 00                	push   $0x0
  801c30:	6a 00                	push   $0x0
  801c32:	6a 00                	push   $0x0
  801c34:	6a 00                	push   $0x0
  801c36:	6a 1f                	push   $0x1f
  801c38:	e8 a7 fc ff ff       	call   8018e4 <syscall>
  801c3d:	83 c4 18             	add    $0x18,%esp
}
  801c40:	c9                   	leave  
  801c41:	c3                   	ret    

00801c42 <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  801c42:	55                   	push   %ebp
  801c43:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  801c45:	8b 45 08             	mov    0x8(%ebp),%eax
  801c48:	6a 00                	push   $0x0
  801c4a:	ff 75 14             	pushl  0x14(%ebp)
  801c4d:	ff 75 10             	pushl  0x10(%ebp)
  801c50:	ff 75 0c             	pushl  0xc(%ebp)
  801c53:	50                   	push   %eax
  801c54:	6a 20                	push   $0x20
  801c56:	e8 89 fc ff ff       	call   8018e4 <syscall>
  801c5b:	83 c4 18             	add    $0x18,%esp
}
  801c5e:	c9                   	leave  
  801c5f:	c3                   	ret    

00801c60 <sys_run_env>:

void
sys_run_env(int32 envId)
{
  801c60:	55                   	push   %ebp
  801c61:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  801c63:	8b 45 08             	mov    0x8(%ebp),%eax
  801c66:	6a 00                	push   $0x0
  801c68:	6a 00                	push   $0x0
  801c6a:	6a 00                	push   $0x0
  801c6c:	6a 00                	push   $0x0
  801c6e:	50                   	push   %eax
  801c6f:	6a 21                	push   $0x21
  801c71:	e8 6e fc ff ff       	call   8018e4 <syscall>
  801c76:	83 c4 18             	add    $0x18,%esp
}
  801c79:	90                   	nop
  801c7a:	c9                   	leave  
  801c7b:	c3                   	ret    

00801c7c <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  801c7c:	55                   	push   %ebp
  801c7d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  801c7f:	8b 45 08             	mov    0x8(%ebp),%eax
  801c82:	6a 00                	push   $0x0
  801c84:	6a 00                	push   $0x0
  801c86:	6a 00                	push   $0x0
  801c88:	6a 00                	push   $0x0
  801c8a:	50                   	push   %eax
  801c8b:	6a 22                	push   $0x22
  801c8d:	e8 52 fc ff ff       	call   8018e4 <syscall>
  801c92:	83 c4 18             	add    $0x18,%esp
}
  801c95:	c9                   	leave  
  801c96:	c3                   	ret    

00801c97 <sys_getenvid>:

int32 sys_getenvid(void)
{
  801c97:	55                   	push   %ebp
  801c98:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  801c9a:	6a 00                	push   $0x0
  801c9c:	6a 00                	push   $0x0
  801c9e:	6a 00                	push   $0x0
  801ca0:	6a 00                	push   $0x0
  801ca2:	6a 00                	push   $0x0
  801ca4:	6a 02                	push   $0x2
  801ca6:	e8 39 fc ff ff       	call   8018e4 <syscall>
  801cab:	83 c4 18             	add    $0x18,%esp
}
  801cae:	c9                   	leave  
  801caf:	c3                   	ret    

00801cb0 <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  801cb0:	55                   	push   %ebp
  801cb1:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  801cb3:	6a 00                	push   $0x0
  801cb5:	6a 00                	push   $0x0
  801cb7:	6a 00                	push   $0x0
  801cb9:	6a 00                	push   $0x0
  801cbb:	6a 00                	push   $0x0
  801cbd:	6a 03                	push   $0x3
  801cbf:	e8 20 fc ff ff       	call   8018e4 <syscall>
  801cc4:	83 c4 18             	add    $0x18,%esp
}
  801cc7:	c9                   	leave  
  801cc8:	c3                   	ret    

00801cc9 <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  801cc9:	55                   	push   %ebp
  801cca:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  801ccc:	6a 00                	push   $0x0
  801cce:	6a 00                	push   $0x0
  801cd0:	6a 00                	push   $0x0
  801cd2:	6a 00                	push   $0x0
  801cd4:	6a 00                	push   $0x0
  801cd6:	6a 04                	push   $0x4
  801cd8:	e8 07 fc ff ff       	call   8018e4 <syscall>
  801cdd:	83 c4 18             	add    $0x18,%esp
}
  801ce0:	c9                   	leave  
  801ce1:	c3                   	ret    

00801ce2 <sys_exit_env>:


void sys_exit_env(void)
{
  801ce2:	55                   	push   %ebp
  801ce3:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  801ce5:	6a 00                	push   $0x0
  801ce7:	6a 00                	push   $0x0
  801ce9:	6a 00                	push   $0x0
  801ceb:	6a 00                	push   $0x0
  801ced:	6a 00                	push   $0x0
  801cef:	6a 23                	push   $0x23
  801cf1:	e8 ee fb ff ff       	call   8018e4 <syscall>
  801cf6:	83 c4 18             	add    $0x18,%esp
}
  801cf9:	90                   	nop
  801cfa:	c9                   	leave  
  801cfb:	c3                   	ret    

00801cfc <sys_get_virtual_time>:


struct uint64
sys_get_virtual_time()
{
  801cfc:	55                   	push   %ebp
  801cfd:	89 e5                	mov    %esp,%ebp
  801cff:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  801d02:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801d05:	8d 50 04             	lea    0x4(%eax),%edx
  801d08:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801d0b:	6a 00                	push   $0x0
  801d0d:	6a 00                	push   $0x0
  801d0f:	6a 00                	push   $0x0
  801d11:	52                   	push   %edx
  801d12:	50                   	push   %eax
  801d13:	6a 24                	push   $0x24
  801d15:	e8 ca fb ff ff       	call   8018e4 <syscall>
  801d1a:	83 c4 18             	add    $0x18,%esp
	return result;
  801d1d:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801d20:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801d23:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801d26:	89 01                	mov    %eax,(%ecx)
  801d28:	89 51 04             	mov    %edx,0x4(%ecx)
}
  801d2b:	8b 45 08             	mov    0x8(%ebp),%eax
  801d2e:	c9                   	leave  
  801d2f:	c2 04 00             	ret    $0x4

00801d32 <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  801d32:	55                   	push   %ebp
  801d33:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  801d35:	6a 00                	push   $0x0
  801d37:	6a 00                	push   $0x0
  801d39:	ff 75 10             	pushl  0x10(%ebp)
  801d3c:	ff 75 0c             	pushl  0xc(%ebp)
  801d3f:	ff 75 08             	pushl  0x8(%ebp)
  801d42:	6a 12                	push   $0x12
  801d44:	e8 9b fb ff ff       	call   8018e4 <syscall>
  801d49:	83 c4 18             	add    $0x18,%esp
	return ;
  801d4c:	90                   	nop
}
  801d4d:	c9                   	leave  
  801d4e:	c3                   	ret    

00801d4f <sys_rcr2>:
uint32 sys_rcr2()
{
  801d4f:	55                   	push   %ebp
  801d50:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  801d52:	6a 00                	push   $0x0
  801d54:	6a 00                	push   $0x0
  801d56:	6a 00                	push   $0x0
  801d58:	6a 00                	push   $0x0
  801d5a:	6a 00                	push   $0x0
  801d5c:	6a 25                	push   $0x25
  801d5e:	e8 81 fb ff ff       	call   8018e4 <syscall>
  801d63:	83 c4 18             	add    $0x18,%esp
}
  801d66:	c9                   	leave  
  801d67:	c3                   	ret    

00801d68 <sys_bypassPageFault>:
void sys_bypassPageFault(uint8 instrLength)
{
  801d68:	55                   	push   %ebp
  801d69:	89 e5                	mov    %esp,%ebp
  801d6b:	83 ec 04             	sub    $0x4,%esp
  801d6e:	8b 45 08             	mov    0x8(%ebp),%eax
  801d71:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  801d74:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  801d78:	6a 00                	push   $0x0
  801d7a:	6a 00                	push   $0x0
  801d7c:	6a 00                	push   $0x0
  801d7e:	6a 00                	push   $0x0
  801d80:	50                   	push   %eax
  801d81:	6a 26                	push   $0x26
  801d83:	e8 5c fb ff ff       	call   8018e4 <syscall>
  801d88:	83 c4 18             	add    $0x18,%esp
	return ;
  801d8b:	90                   	nop
}
  801d8c:	c9                   	leave  
  801d8d:	c3                   	ret    

00801d8e <rsttst>:
void rsttst()
{
  801d8e:	55                   	push   %ebp
  801d8f:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  801d91:	6a 00                	push   $0x0
  801d93:	6a 00                	push   $0x0
  801d95:	6a 00                	push   $0x0
  801d97:	6a 00                	push   $0x0
  801d99:	6a 00                	push   $0x0
  801d9b:	6a 28                	push   $0x28
  801d9d:	e8 42 fb ff ff       	call   8018e4 <syscall>
  801da2:	83 c4 18             	add    $0x18,%esp
	return ;
  801da5:	90                   	nop
}
  801da6:	c9                   	leave  
  801da7:	c3                   	ret    

00801da8 <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  801da8:	55                   	push   %ebp
  801da9:	89 e5                	mov    %esp,%ebp
  801dab:	83 ec 04             	sub    $0x4,%esp
  801dae:	8b 45 14             	mov    0x14(%ebp),%eax
  801db1:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  801db4:	8b 55 18             	mov    0x18(%ebp),%edx
  801db7:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801dbb:	52                   	push   %edx
  801dbc:	50                   	push   %eax
  801dbd:	ff 75 10             	pushl  0x10(%ebp)
  801dc0:	ff 75 0c             	pushl  0xc(%ebp)
  801dc3:	ff 75 08             	pushl  0x8(%ebp)
  801dc6:	6a 27                	push   $0x27
  801dc8:	e8 17 fb ff ff       	call   8018e4 <syscall>
  801dcd:	83 c4 18             	add    $0x18,%esp
	return ;
  801dd0:	90                   	nop
}
  801dd1:	c9                   	leave  
  801dd2:	c3                   	ret    

00801dd3 <chktst>:
void chktst(uint32 n)
{
  801dd3:	55                   	push   %ebp
  801dd4:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  801dd6:	6a 00                	push   $0x0
  801dd8:	6a 00                	push   $0x0
  801dda:	6a 00                	push   $0x0
  801ddc:	6a 00                	push   $0x0
  801dde:	ff 75 08             	pushl  0x8(%ebp)
  801de1:	6a 29                	push   $0x29
  801de3:	e8 fc fa ff ff       	call   8018e4 <syscall>
  801de8:	83 c4 18             	add    $0x18,%esp
	return ;
  801deb:	90                   	nop
}
  801dec:	c9                   	leave  
  801ded:	c3                   	ret    

00801dee <inctst>:

void inctst()
{
  801dee:	55                   	push   %ebp
  801def:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  801df1:	6a 00                	push   $0x0
  801df3:	6a 00                	push   $0x0
  801df5:	6a 00                	push   $0x0
  801df7:	6a 00                	push   $0x0
  801df9:	6a 00                	push   $0x0
  801dfb:	6a 2a                	push   $0x2a
  801dfd:	e8 e2 fa ff ff       	call   8018e4 <syscall>
  801e02:	83 c4 18             	add    $0x18,%esp
	return ;
  801e05:	90                   	nop
}
  801e06:	c9                   	leave  
  801e07:	c3                   	ret    

00801e08 <gettst>:
uint32 gettst()
{
  801e08:	55                   	push   %ebp
  801e09:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  801e0b:	6a 00                	push   $0x0
  801e0d:	6a 00                	push   $0x0
  801e0f:	6a 00                	push   $0x0
  801e11:	6a 00                	push   $0x0
  801e13:	6a 00                	push   $0x0
  801e15:	6a 2b                	push   $0x2b
  801e17:	e8 c8 fa ff ff       	call   8018e4 <syscall>
  801e1c:	83 c4 18             	add    $0x18,%esp
}
  801e1f:	c9                   	leave  
  801e20:	c3                   	ret    

00801e21 <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  801e21:	55                   	push   %ebp
  801e22:	89 e5                	mov    %esp,%ebp
  801e24:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801e27:	6a 00                	push   $0x0
  801e29:	6a 00                	push   $0x0
  801e2b:	6a 00                	push   $0x0
  801e2d:	6a 00                	push   $0x0
  801e2f:	6a 00                	push   $0x0
  801e31:	6a 2c                	push   $0x2c
  801e33:	e8 ac fa ff ff       	call   8018e4 <syscall>
  801e38:	83 c4 18             	add    $0x18,%esp
  801e3b:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  801e3e:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  801e42:	75 07                	jne    801e4b <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  801e44:	b8 01 00 00 00       	mov    $0x1,%eax
  801e49:	eb 05                	jmp    801e50 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  801e4b:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801e50:	c9                   	leave  
  801e51:	c3                   	ret    

00801e52 <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  801e52:	55                   	push   %ebp
  801e53:	89 e5                	mov    %esp,%ebp
  801e55:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801e58:	6a 00                	push   $0x0
  801e5a:	6a 00                	push   $0x0
  801e5c:	6a 00                	push   $0x0
  801e5e:	6a 00                	push   $0x0
  801e60:	6a 00                	push   $0x0
  801e62:	6a 2c                	push   $0x2c
  801e64:	e8 7b fa ff ff       	call   8018e4 <syscall>
  801e69:	83 c4 18             	add    $0x18,%esp
  801e6c:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  801e6f:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  801e73:	75 07                	jne    801e7c <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  801e75:	b8 01 00 00 00       	mov    $0x1,%eax
  801e7a:	eb 05                	jmp    801e81 <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  801e7c:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801e81:	c9                   	leave  
  801e82:	c3                   	ret    

00801e83 <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  801e83:	55                   	push   %ebp
  801e84:	89 e5                	mov    %esp,%ebp
  801e86:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801e89:	6a 00                	push   $0x0
  801e8b:	6a 00                	push   $0x0
  801e8d:	6a 00                	push   $0x0
  801e8f:	6a 00                	push   $0x0
  801e91:	6a 00                	push   $0x0
  801e93:	6a 2c                	push   $0x2c
  801e95:	e8 4a fa ff ff       	call   8018e4 <syscall>
  801e9a:	83 c4 18             	add    $0x18,%esp
  801e9d:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  801ea0:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  801ea4:	75 07                	jne    801ead <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  801ea6:	b8 01 00 00 00       	mov    $0x1,%eax
  801eab:	eb 05                	jmp    801eb2 <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  801ead:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801eb2:	c9                   	leave  
  801eb3:	c3                   	ret    

00801eb4 <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  801eb4:	55                   	push   %ebp
  801eb5:	89 e5                	mov    %esp,%ebp
  801eb7:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801eba:	6a 00                	push   $0x0
  801ebc:	6a 00                	push   $0x0
  801ebe:	6a 00                	push   $0x0
  801ec0:	6a 00                	push   $0x0
  801ec2:	6a 00                	push   $0x0
  801ec4:	6a 2c                	push   $0x2c
  801ec6:	e8 19 fa ff ff       	call   8018e4 <syscall>
  801ecb:	83 c4 18             	add    $0x18,%esp
  801ece:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  801ed1:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  801ed5:	75 07                	jne    801ede <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  801ed7:	b8 01 00 00 00       	mov    $0x1,%eax
  801edc:	eb 05                	jmp    801ee3 <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  801ede:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801ee3:	c9                   	leave  
  801ee4:	c3                   	ret    

00801ee5 <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  801ee5:	55                   	push   %ebp
  801ee6:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  801ee8:	6a 00                	push   $0x0
  801eea:	6a 00                	push   $0x0
  801eec:	6a 00                	push   $0x0
  801eee:	6a 00                	push   $0x0
  801ef0:	ff 75 08             	pushl  0x8(%ebp)
  801ef3:	6a 2d                	push   $0x2d
  801ef5:	e8 ea f9 ff ff       	call   8018e4 <syscall>
  801efa:	83 c4 18             	add    $0x18,%esp
	return ;
  801efd:	90                   	nop
}
  801efe:	c9                   	leave  
  801eff:	c3                   	ret    

00801f00 <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  801f00:	55                   	push   %ebp
  801f01:	89 e5                	mov    %esp,%ebp
  801f03:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  801f04:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801f07:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801f0a:	8b 55 0c             	mov    0xc(%ebp),%edx
  801f0d:	8b 45 08             	mov    0x8(%ebp),%eax
  801f10:	6a 00                	push   $0x0
  801f12:	53                   	push   %ebx
  801f13:	51                   	push   %ecx
  801f14:	52                   	push   %edx
  801f15:	50                   	push   %eax
  801f16:	6a 2e                	push   $0x2e
  801f18:	e8 c7 f9 ff ff       	call   8018e4 <syscall>
  801f1d:	83 c4 18             	add    $0x18,%esp
}
  801f20:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801f23:	c9                   	leave  
  801f24:	c3                   	ret    

00801f25 <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  801f25:	55                   	push   %ebp
  801f26:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  801f28:	8b 55 0c             	mov    0xc(%ebp),%edx
  801f2b:	8b 45 08             	mov    0x8(%ebp),%eax
  801f2e:	6a 00                	push   $0x0
  801f30:	6a 00                	push   $0x0
  801f32:	6a 00                	push   $0x0
  801f34:	52                   	push   %edx
  801f35:	50                   	push   %eax
  801f36:	6a 2f                	push   $0x2f
  801f38:	e8 a7 f9 ff ff       	call   8018e4 <syscall>
  801f3d:	83 c4 18             	add    $0x18,%esp
}
  801f40:	c9                   	leave  
  801f41:	c3                   	ret    

00801f42 <print_mem_block_lists>:
//===========================
// PRINT MEM BLOCK LISTS:
//===========================

void print_mem_block_lists()
{
  801f42:	55                   	push   %ebp
  801f43:	89 e5                	mov    %esp,%ebp
  801f45:	83 ec 18             	sub    $0x18,%esp
	cprintf("\n=========================================\n");
  801f48:	83 ec 0c             	sub    $0xc,%esp
  801f4b:	68 40 39 80 00       	push   $0x803940
  801f50:	e8 dd e6 ff ff       	call   800632 <cprintf>
  801f55:	83 c4 10             	add    $0x10,%esp
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
  801f58:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nFreeMemBlocksList:\n");
  801f5f:	83 ec 0c             	sub    $0xc,%esp
  801f62:	68 6c 39 80 00       	push   $0x80396c
  801f67:	e8 c6 e6 ff ff       	call   800632 <cprintf>
  801f6c:	83 c4 10             	add    $0x10,%esp
	uint8 sorted = 1 ;
  801f6f:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &FreeMemBlocksList)
  801f73:	a1 38 41 80 00       	mov    0x804138,%eax
  801f78:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801f7b:	eb 56                	jmp    801fd3 <print_mem_block_lists+0x91>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  801f7d:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801f81:	74 1c                	je     801f9f <print_mem_block_lists+0x5d>
  801f83:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f86:	8b 50 08             	mov    0x8(%eax),%edx
  801f89:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801f8c:	8b 48 08             	mov    0x8(%eax),%ecx
  801f8f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801f92:	8b 40 0c             	mov    0xc(%eax),%eax
  801f95:	01 c8                	add    %ecx,%eax
  801f97:	39 c2                	cmp    %eax,%edx
  801f99:	73 04                	jae    801f9f <print_mem_block_lists+0x5d>
			sorted = 0 ;
  801f9b:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  801f9f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801fa2:	8b 50 08             	mov    0x8(%eax),%edx
  801fa5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801fa8:	8b 40 0c             	mov    0xc(%eax),%eax
  801fab:	01 c2                	add    %eax,%edx
  801fad:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801fb0:	8b 40 08             	mov    0x8(%eax),%eax
  801fb3:	83 ec 04             	sub    $0x4,%esp
  801fb6:	52                   	push   %edx
  801fb7:	50                   	push   %eax
  801fb8:	68 81 39 80 00       	push   $0x803981
  801fbd:	e8 70 e6 ff ff       	call   800632 <cprintf>
  801fc2:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  801fc5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801fc8:	89 45 f0             	mov    %eax,-0x10(%ebp)
	cprintf("\n=========================================\n");
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
	cprintf("\nFreeMemBlocksList:\n");
	uint8 sorted = 1 ;
	LIST_FOREACH(blk, &FreeMemBlocksList)
  801fcb:	a1 40 41 80 00       	mov    0x804140,%eax
  801fd0:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801fd3:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801fd7:	74 07                	je     801fe0 <print_mem_block_lists+0x9e>
  801fd9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801fdc:	8b 00                	mov    (%eax),%eax
  801fde:	eb 05                	jmp    801fe5 <print_mem_block_lists+0xa3>
  801fe0:	b8 00 00 00 00       	mov    $0x0,%eax
  801fe5:	a3 40 41 80 00       	mov    %eax,0x804140
  801fea:	a1 40 41 80 00       	mov    0x804140,%eax
  801fef:	85 c0                	test   %eax,%eax
  801ff1:	75 8a                	jne    801f7d <print_mem_block_lists+0x3b>
  801ff3:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801ff7:	75 84                	jne    801f7d <print_mem_block_lists+0x3b>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;
  801ff9:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  801ffd:	75 10                	jne    80200f <print_mem_block_lists+0xcd>
  801fff:	83 ec 0c             	sub    $0xc,%esp
  802002:	68 90 39 80 00       	push   $0x803990
  802007:	e8 26 e6 ff ff       	call   800632 <cprintf>
  80200c:	83 c4 10             	add    $0x10,%esp

	lastBlk = NULL ;
  80200f:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nAllocMemBlocksList:\n");
  802016:	83 ec 0c             	sub    $0xc,%esp
  802019:	68 b4 39 80 00       	push   $0x8039b4
  80201e:	e8 0f e6 ff ff       	call   800632 <cprintf>
  802023:	83 c4 10             	add    $0x10,%esp
	sorted = 1 ;
  802026:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &AllocMemBlocksList)
  80202a:	a1 40 40 80 00       	mov    0x804040,%eax
  80202f:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802032:	eb 56                	jmp    80208a <print_mem_block_lists+0x148>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  802034:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802038:	74 1c                	je     802056 <print_mem_block_lists+0x114>
  80203a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80203d:	8b 50 08             	mov    0x8(%eax),%edx
  802040:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802043:	8b 48 08             	mov    0x8(%eax),%ecx
  802046:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802049:	8b 40 0c             	mov    0xc(%eax),%eax
  80204c:	01 c8                	add    %ecx,%eax
  80204e:	39 c2                	cmp    %eax,%edx
  802050:	73 04                	jae    802056 <print_mem_block_lists+0x114>
			sorted = 0 ;
  802052:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  802056:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802059:	8b 50 08             	mov    0x8(%eax),%edx
  80205c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80205f:	8b 40 0c             	mov    0xc(%eax),%eax
  802062:	01 c2                	add    %eax,%edx
  802064:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802067:	8b 40 08             	mov    0x8(%eax),%eax
  80206a:	83 ec 04             	sub    $0x4,%esp
  80206d:	52                   	push   %edx
  80206e:	50                   	push   %eax
  80206f:	68 81 39 80 00       	push   $0x803981
  802074:	e8 b9 e5 ff ff       	call   800632 <cprintf>
  802079:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  80207c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80207f:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;

	lastBlk = NULL ;
	cprintf("\nAllocMemBlocksList:\n");
	sorted = 1 ;
	LIST_FOREACH(blk, &AllocMemBlocksList)
  802082:	a1 48 40 80 00       	mov    0x804048,%eax
  802087:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80208a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80208e:	74 07                	je     802097 <print_mem_block_lists+0x155>
  802090:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802093:	8b 00                	mov    (%eax),%eax
  802095:	eb 05                	jmp    80209c <print_mem_block_lists+0x15a>
  802097:	b8 00 00 00 00       	mov    $0x0,%eax
  80209c:	a3 48 40 80 00       	mov    %eax,0x804048
  8020a1:	a1 48 40 80 00       	mov    0x804048,%eax
  8020a6:	85 c0                	test   %eax,%eax
  8020a8:	75 8a                	jne    802034 <print_mem_block_lists+0xf2>
  8020aa:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8020ae:	75 84                	jne    802034 <print_mem_block_lists+0xf2>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nAllocMemBlocksList is NOT SORTED!!\n") ;
  8020b0:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  8020b4:	75 10                	jne    8020c6 <print_mem_block_lists+0x184>
  8020b6:	83 ec 0c             	sub    $0xc,%esp
  8020b9:	68 cc 39 80 00       	push   $0x8039cc
  8020be:	e8 6f e5 ff ff       	call   800632 <cprintf>
  8020c3:	83 c4 10             	add    $0x10,%esp
	cprintf("\n=========================================\n");
  8020c6:	83 ec 0c             	sub    $0xc,%esp
  8020c9:	68 40 39 80 00       	push   $0x803940
  8020ce:	e8 5f e5 ff ff       	call   800632 <cprintf>
  8020d3:	83 c4 10             	add    $0x10,%esp

}
  8020d6:	90                   	nop
  8020d7:	c9                   	leave  
  8020d8:	c3                   	ret    

008020d9 <initialize_MemBlocksList>:

//===============================
// [1] INITIALIZE AVAILABLE LIST:
//===============================
void initialize_MemBlocksList(uint32 numOfBlocks)
{
  8020d9:	55                   	push   %ebp
  8020da:	89 e5                	mov    %esp,%ebp
  8020dc:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] initialize_MemBlocksList
	// Write your code here, remove the panic and write your code
	//panic("initialize_MemBlocksList() is not implemented yet...!!");
	uint32 n = numOfBlocks;
  8020df:	8b 45 08             	mov    0x8(%ebp),%eax
  8020e2:	89 45 f0             	mov    %eax,-0x10(%ebp)

	LIST_INIT(&AvailableMemBlocksList);
  8020e5:	c7 05 48 41 80 00 00 	movl   $0x0,0x804148
  8020ec:	00 00 00 
  8020ef:	c7 05 4c 41 80 00 00 	movl   $0x0,0x80414c
  8020f6:	00 00 00 
  8020f9:	c7 05 54 41 80 00 00 	movl   $0x0,0x804154
  802100:	00 00 00 
	for(int i = 0; i<n;i++)
  802103:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  80210a:	e9 9e 00 00 00       	jmp    8021ad <initialize_MemBlocksList+0xd4>
	{
		LIST_INSERT_HEAD(&AvailableMemBlocksList, &(MemBlockNodes[i]));
  80210f:	a1 50 40 80 00       	mov    0x804050,%eax
  802114:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802117:	c1 e2 04             	shl    $0x4,%edx
  80211a:	01 d0                	add    %edx,%eax
  80211c:	85 c0                	test   %eax,%eax
  80211e:	75 14                	jne    802134 <initialize_MemBlocksList+0x5b>
  802120:	83 ec 04             	sub    $0x4,%esp
  802123:	68 f4 39 80 00       	push   $0x8039f4
  802128:	6a 47                	push   $0x47
  80212a:	68 17 3a 80 00       	push   $0x803a17
  80212f:	e8 4a e2 ff ff       	call   80037e <_panic>
  802134:	a1 50 40 80 00       	mov    0x804050,%eax
  802139:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80213c:	c1 e2 04             	shl    $0x4,%edx
  80213f:	01 d0                	add    %edx,%eax
  802141:	8b 15 48 41 80 00    	mov    0x804148,%edx
  802147:	89 10                	mov    %edx,(%eax)
  802149:	8b 00                	mov    (%eax),%eax
  80214b:	85 c0                	test   %eax,%eax
  80214d:	74 18                	je     802167 <initialize_MemBlocksList+0x8e>
  80214f:	a1 48 41 80 00       	mov    0x804148,%eax
  802154:	8b 15 50 40 80 00    	mov    0x804050,%edx
  80215a:	8b 4d f4             	mov    -0xc(%ebp),%ecx
  80215d:	c1 e1 04             	shl    $0x4,%ecx
  802160:	01 ca                	add    %ecx,%edx
  802162:	89 50 04             	mov    %edx,0x4(%eax)
  802165:	eb 12                	jmp    802179 <initialize_MemBlocksList+0xa0>
  802167:	a1 50 40 80 00       	mov    0x804050,%eax
  80216c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80216f:	c1 e2 04             	shl    $0x4,%edx
  802172:	01 d0                	add    %edx,%eax
  802174:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802179:	a1 50 40 80 00       	mov    0x804050,%eax
  80217e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802181:	c1 e2 04             	shl    $0x4,%edx
  802184:	01 d0                	add    %edx,%eax
  802186:	a3 48 41 80 00       	mov    %eax,0x804148
  80218b:	a1 50 40 80 00       	mov    0x804050,%eax
  802190:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802193:	c1 e2 04             	shl    $0x4,%edx
  802196:	01 d0                	add    %edx,%eax
  802198:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80219f:	a1 54 41 80 00       	mov    0x804154,%eax
  8021a4:	40                   	inc    %eax
  8021a5:	a3 54 41 80 00       	mov    %eax,0x804154
	// Write your code here, remove the panic and write your code
	//panic("initialize_MemBlocksList() is not implemented yet...!!");
	uint32 n = numOfBlocks;

	LIST_INIT(&AvailableMemBlocksList);
	for(int i = 0; i<n;i++)
  8021aa:	ff 45 f4             	incl   -0xc(%ebp)
  8021ad:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8021b0:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8021b3:	0f 82 56 ff ff ff    	jb     80210f <initialize_MemBlocksList+0x36>
	{
		LIST_INSERT_HEAD(&AvailableMemBlocksList, &(MemBlockNodes[i]));
	}
}
  8021b9:	90                   	nop
  8021ba:	c9                   	leave  
  8021bb:	c3                   	ret    

008021bc <find_block>:

//===============================
// [2] FIND BLOCK:
//===============================
struct MemBlock *find_block(struct MemBlock_List *blockList, uint32 va)
{
  8021bc:	55                   	push   %ebp
  8021bd:	89 e5                	mov    %esp,%ebp
  8021bf:	83 ec 10             	sub    $0x10,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] find_block
	// Write your code here, remove the panic and write your code
	//panic("find_block() is not implemented yet...!!");
	uint32 virAddress = va;
  8021c2:	8b 45 0c             	mov    0xc(%ebp),%eax
  8021c5:	89 45 f4             	mov    %eax,-0xc(%ebp)
	struct MemBlock* blk;
	int found = 0;
  8021c8:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	LIST_FOREACH(blk, &(AllocMemBlocksList))
  8021cf:	a1 40 40 80 00       	mov    0x804040,%eax
  8021d4:	89 45 fc             	mov    %eax,-0x4(%ebp)
  8021d7:	eb 23                	jmp    8021fc <find_block+0x40>
	{
		if(blk->sva == virAddress)
  8021d9:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8021dc:	8b 40 08             	mov    0x8(%eax),%eax
  8021df:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  8021e2:	75 09                	jne    8021ed <find_block+0x31>
		{
			found = 1;
  8021e4:	c7 45 f8 01 00 00 00 	movl   $0x1,-0x8(%ebp)
			break;
  8021eb:	eb 35                	jmp    802222 <find_block+0x66>
		}
		else
		{
			found = 0;
  8021ed:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	//panic("find_block() is not implemented yet...!!");
	uint32 virAddress = va;
	struct MemBlock* blk;
	int found = 0;

	LIST_FOREACH(blk, &(AllocMemBlocksList))
  8021f4:	a1 48 40 80 00       	mov    0x804048,%eax
  8021f9:	89 45 fc             	mov    %eax,-0x4(%ebp)
  8021fc:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  802200:	74 07                	je     802209 <find_block+0x4d>
  802202:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802205:	8b 00                	mov    (%eax),%eax
  802207:	eb 05                	jmp    80220e <find_block+0x52>
  802209:	b8 00 00 00 00       	mov    $0x0,%eax
  80220e:	a3 48 40 80 00       	mov    %eax,0x804048
  802213:	a1 48 40 80 00       	mov    0x804048,%eax
  802218:	85 c0                	test   %eax,%eax
  80221a:	75 bd                	jne    8021d9 <find_block+0x1d>
  80221c:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  802220:	75 b7                	jne    8021d9 <find_block+0x1d>
		{
			found = 0;
			continue;
		}
	}
	if(found == 1)
  802222:	83 7d f8 01          	cmpl   $0x1,-0x8(%ebp)
  802226:	75 05                	jne    80222d <find_block+0x71>
	{
		return blk;
  802228:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80222b:	eb 05                	jmp    802232 <find_block+0x76>
	}
	else
	{
		return NULL;
  80222d:	b8 00 00 00 00       	mov    $0x0,%eax
	}
}
  802232:	c9                   	leave  
  802233:	c3                   	ret    

00802234 <insert_sorted_allocList>:

//=========================================
// [3] INSERT BLOCK IN ALLOC LIST [SORTED]:
//=========================================
void insert_sorted_allocList(struct MemBlock *blockToInsert)
{
  802234:	55                   	push   %ebp
  802235:	89 e5                	mov    %esp,%ebp
  802237:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] insert_sorted_allocList
	// Write your code here, remove the panic and write your code
	//panic("insert_sorted_allocList() is not implemented yet...!!");
	struct MemBlock* blk;
	struct MemBlock* newblk = blockToInsert;
  80223a:	8b 45 08             	mov    0x8(%ebp),%eax
  80223d:	89 45 f0             	mov    %eax,-0x10(%ebp)

	if((LIST_EMPTY(&AllocMemBlocksList)) || (newblk->sva < LIST_FIRST(&AllocMemBlocksList)->sva))
  802240:	a1 40 40 80 00       	mov    0x804040,%eax
  802245:	85 c0                	test   %eax,%eax
  802247:	74 12                	je     80225b <insert_sorted_allocList+0x27>
  802249:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80224c:	8b 50 08             	mov    0x8(%eax),%edx
  80224f:	a1 40 40 80 00       	mov    0x804040,%eax
  802254:	8b 40 08             	mov    0x8(%eax),%eax
  802257:	39 c2                	cmp    %eax,%edx
  802259:	73 65                	jae    8022c0 <insert_sorted_allocList+0x8c>
	{
		LIST_INSERT_HEAD(&(AllocMemBlocksList), newblk);
  80225b:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80225f:	75 14                	jne    802275 <insert_sorted_allocList+0x41>
  802261:	83 ec 04             	sub    $0x4,%esp
  802264:	68 f4 39 80 00       	push   $0x8039f4
  802269:	6a 7b                	push   $0x7b
  80226b:	68 17 3a 80 00       	push   $0x803a17
  802270:	e8 09 e1 ff ff       	call   80037e <_panic>
  802275:	8b 15 40 40 80 00    	mov    0x804040,%edx
  80227b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80227e:	89 10                	mov    %edx,(%eax)
  802280:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802283:	8b 00                	mov    (%eax),%eax
  802285:	85 c0                	test   %eax,%eax
  802287:	74 0d                	je     802296 <insert_sorted_allocList+0x62>
  802289:	a1 40 40 80 00       	mov    0x804040,%eax
  80228e:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802291:	89 50 04             	mov    %edx,0x4(%eax)
  802294:	eb 08                	jmp    80229e <insert_sorted_allocList+0x6a>
  802296:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802299:	a3 44 40 80 00       	mov    %eax,0x804044
  80229e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8022a1:	a3 40 40 80 00       	mov    %eax,0x804040
  8022a6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8022a9:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8022b0:	a1 4c 40 80 00       	mov    0x80404c,%eax
  8022b5:	40                   	inc    %eax
  8022b6:	a3 4c 40 80 00       	mov    %eax,0x80404c
  8022bb:	e9 5f 01 00 00       	jmp    80241f <insert_sorted_allocList+0x1eb>
	}
	else if(newblk->sva > LIST_LAST(&AllocMemBlocksList)->sva)
  8022c0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8022c3:	8b 50 08             	mov    0x8(%eax),%edx
  8022c6:	a1 44 40 80 00       	mov    0x804044,%eax
  8022cb:	8b 40 08             	mov    0x8(%eax),%eax
  8022ce:	39 c2                	cmp    %eax,%edx
  8022d0:	76 65                	jbe    802337 <insert_sorted_allocList+0x103>
	{
		LIST_INSERT_TAIL(&AllocMemBlocksList, newblk);
  8022d2:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8022d6:	75 14                	jne    8022ec <insert_sorted_allocList+0xb8>
  8022d8:	83 ec 04             	sub    $0x4,%esp
  8022db:	68 30 3a 80 00       	push   $0x803a30
  8022e0:	6a 7f                	push   $0x7f
  8022e2:	68 17 3a 80 00       	push   $0x803a17
  8022e7:	e8 92 e0 ff ff       	call   80037e <_panic>
  8022ec:	8b 15 44 40 80 00    	mov    0x804044,%edx
  8022f2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8022f5:	89 50 04             	mov    %edx,0x4(%eax)
  8022f8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8022fb:	8b 40 04             	mov    0x4(%eax),%eax
  8022fe:	85 c0                	test   %eax,%eax
  802300:	74 0c                	je     80230e <insert_sorted_allocList+0xda>
  802302:	a1 44 40 80 00       	mov    0x804044,%eax
  802307:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80230a:	89 10                	mov    %edx,(%eax)
  80230c:	eb 08                	jmp    802316 <insert_sorted_allocList+0xe2>
  80230e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802311:	a3 40 40 80 00       	mov    %eax,0x804040
  802316:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802319:	a3 44 40 80 00       	mov    %eax,0x804044
  80231e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802321:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802327:	a1 4c 40 80 00       	mov    0x80404c,%eax
  80232c:	40                   	inc    %eax
  80232d:	a3 4c 40 80 00       	mov    %eax,0x80404c
				LIST_INSERT_AFTER(&AllocMemBlocksList, blk, newblk);
				break;
			}
		}
	}
}
  802332:	e9 e8 00 00 00       	jmp    80241f <insert_sorted_allocList+0x1eb>
	{
		LIST_INSERT_TAIL(&AllocMemBlocksList, newblk);
	}
	else
	{
		LIST_FOREACH(blk, &AllocMemBlocksList)
  802337:	a1 40 40 80 00       	mov    0x804040,%eax
  80233c:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80233f:	e9 ab 00 00 00       	jmp    8023ef <insert_sorted_allocList+0x1bb>
		{
			if(blk->prev_next_info.le_next != NULL && newblk->sva > blk->sva  && newblk->sva < blk->prev_next_info.le_next->sva)
  802344:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802347:	8b 00                	mov    (%eax),%eax
  802349:	85 c0                	test   %eax,%eax
  80234b:	0f 84 96 00 00 00    	je     8023e7 <insert_sorted_allocList+0x1b3>
  802351:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802354:	8b 50 08             	mov    0x8(%eax),%edx
  802357:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80235a:	8b 40 08             	mov    0x8(%eax),%eax
  80235d:	39 c2                	cmp    %eax,%edx
  80235f:	0f 86 82 00 00 00    	jbe    8023e7 <insert_sorted_allocList+0x1b3>
  802365:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802368:	8b 50 08             	mov    0x8(%eax),%edx
  80236b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80236e:	8b 00                	mov    (%eax),%eax
  802370:	8b 40 08             	mov    0x8(%eax),%eax
  802373:	39 c2                	cmp    %eax,%edx
  802375:	73 70                	jae    8023e7 <insert_sorted_allocList+0x1b3>
			{
				LIST_INSERT_AFTER(&AllocMemBlocksList, blk, newblk);
  802377:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80237b:	74 06                	je     802383 <insert_sorted_allocList+0x14f>
  80237d:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802381:	75 17                	jne    80239a <insert_sorted_allocList+0x166>
  802383:	83 ec 04             	sub    $0x4,%esp
  802386:	68 54 3a 80 00       	push   $0x803a54
  80238b:	68 87 00 00 00       	push   $0x87
  802390:	68 17 3a 80 00       	push   $0x803a17
  802395:	e8 e4 df ff ff       	call   80037e <_panic>
  80239a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80239d:	8b 10                	mov    (%eax),%edx
  80239f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8023a2:	89 10                	mov    %edx,(%eax)
  8023a4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8023a7:	8b 00                	mov    (%eax),%eax
  8023a9:	85 c0                	test   %eax,%eax
  8023ab:	74 0b                	je     8023b8 <insert_sorted_allocList+0x184>
  8023ad:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023b0:	8b 00                	mov    (%eax),%eax
  8023b2:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8023b5:	89 50 04             	mov    %edx,0x4(%eax)
  8023b8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023bb:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8023be:	89 10                	mov    %edx,(%eax)
  8023c0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8023c3:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8023c6:	89 50 04             	mov    %edx,0x4(%eax)
  8023c9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8023cc:	8b 00                	mov    (%eax),%eax
  8023ce:	85 c0                	test   %eax,%eax
  8023d0:	75 08                	jne    8023da <insert_sorted_allocList+0x1a6>
  8023d2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8023d5:	a3 44 40 80 00       	mov    %eax,0x804044
  8023da:	a1 4c 40 80 00       	mov    0x80404c,%eax
  8023df:	40                   	inc    %eax
  8023e0:	a3 4c 40 80 00       	mov    %eax,0x80404c
				break;
  8023e5:	eb 38                	jmp    80241f <insert_sorted_allocList+0x1eb>
	{
		LIST_INSERT_TAIL(&AllocMemBlocksList, newblk);
	}
	else
	{
		LIST_FOREACH(blk, &AllocMemBlocksList)
  8023e7:	a1 48 40 80 00       	mov    0x804048,%eax
  8023ec:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8023ef:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8023f3:	74 07                	je     8023fc <insert_sorted_allocList+0x1c8>
  8023f5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023f8:	8b 00                	mov    (%eax),%eax
  8023fa:	eb 05                	jmp    802401 <insert_sorted_allocList+0x1cd>
  8023fc:	b8 00 00 00 00       	mov    $0x0,%eax
  802401:	a3 48 40 80 00       	mov    %eax,0x804048
  802406:	a1 48 40 80 00       	mov    0x804048,%eax
  80240b:	85 c0                	test   %eax,%eax
  80240d:	0f 85 31 ff ff ff    	jne    802344 <insert_sorted_allocList+0x110>
  802413:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802417:	0f 85 27 ff ff ff    	jne    802344 <insert_sorted_allocList+0x110>
				LIST_INSERT_AFTER(&AllocMemBlocksList, blk, newblk);
				break;
			}
		}
	}
}
  80241d:	eb 00                	jmp    80241f <insert_sorted_allocList+0x1eb>
  80241f:	90                   	nop
  802420:	c9                   	leave  
  802421:	c3                   	ret    

00802422 <alloc_block_FF>:

//=========================================
// [4] ALLOCATE BLOCK BY FIRST FIT:
//=========================================
struct MemBlock *alloc_block_FF(uint32 size)
{
  802422:	55                   	push   %ebp
  802423:	89 e5                	mov    %esp,%ebp
  802425:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_FF
	// Write your code here, remove the panic and write your code
	//panic("alloc_block_FF() is not implemented yet...!!");
	uint32 versize = size;
  802428:	8b 45 08             	mov    0x8(%ebp),%eax
  80242b:	89 45 f0             	mov    %eax,-0x10(%ebp)
	struct MemBlock* blk;
	struct MemBlock* newblk = LIST_FIRST(&AvailableMemBlocksList);
  80242e:	a1 48 41 80 00       	mov    0x804148,%eax
  802433:	89 45 ec             	mov    %eax,-0x14(%ebp)

	LIST_FOREACH(blk,&FreeMemBlocksList)
  802436:	a1 38 41 80 00       	mov    0x804138,%eax
  80243b:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80243e:	e9 77 01 00 00       	jmp    8025ba <alloc_block_FF+0x198>
	{
		if(blk->size == versize)
  802443:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802446:	8b 40 0c             	mov    0xc(%eax),%eax
  802449:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  80244c:	0f 85 8a 00 00 00    	jne    8024dc <alloc_block_FF+0xba>
		{
			LIST_REMOVE(&FreeMemBlocksList,blk);
  802452:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802456:	75 17                	jne    80246f <alloc_block_FF+0x4d>
  802458:	83 ec 04             	sub    $0x4,%esp
  80245b:	68 88 3a 80 00       	push   $0x803a88
  802460:	68 9e 00 00 00       	push   $0x9e
  802465:	68 17 3a 80 00       	push   $0x803a17
  80246a:	e8 0f df ff ff       	call   80037e <_panic>
  80246f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802472:	8b 00                	mov    (%eax),%eax
  802474:	85 c0                	test   %eax,%eax
  802476:	74 10                	je     802488 <alloc_block_FF+0x66>
  802478:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80247b:	8b 00                	mov    (%eax),%eax
  80247d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802480:	8b 52 04             	mov    0x4(%edx),%edx
  802483:	89 50 04             	mov    %edx,0x4(%eax)
  802486:	eb 0b                	jmp    802493 <alloc_block_FF+0x71>
  802488:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80248b:	8b 40 04             	mov    0x4(%eax),%eax
  80248e:	a3 3c 41 80 00       	mov    %eax,0x80413c
  802493:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802496:	8b 40 04             	mov    0x4(%eax),%eax
  802499:	85 c0                	test   %eax,%eax
  80249b:	74 0f                	je     8024ac <alloc_block_FF+0x8a>
  80249d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024a0:	8b 40 04             	mov    0x4(%eax),%eax
  8024a3:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8024a6:	8b 12                	mov    (%edx),%edx
  8024a8:	89 10                	mov    %edx,(%eax)
  8024aa:	eb 0a                	jmp    8024b6 <alloc_block_FF+0x94>
  8024ac:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024af:	8b 00                	mov    (%eax),%eax
  8024b1:	a3 38 41 80 00       	mov    %eax,0x804138
  8024b6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024b9:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8024bf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024c2:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8024c9:	a1 44 41 80 00       	mov    0x804144,%eax
  8024ce:	48                   	dec    %eax
  8024cf:	a3 44 41 80 00       	mov    %eax,0x804144
			return blk;
  8024d4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024d7:	e9 11 01 00 00       	jmp    8025ed <alloc_block_FF+0x1cb>
		}
		else if(blk->size > versize)
  8024dc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024df:	8b 40 0c             	mov    0xc(%eax),%eax
  8024e2:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8024e5:	0f 86 c7 00 00 00    	jbe    8025b2 <alloc_block_FF+0x190>
		{
			LIST_REMOVE(&AvailableMemBlocksList,newblk);
  8024eb:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8024ef:	75 17                	jne    802508 <alloc_block_FF+0xe6>
  8024f1:	83 ec 04             	sub    $0x4,%esp
  8024f4:	68 88 3a 80 00       	push   $0x803a88
  8024f9:	68 a3 00 00 00       	push   $0xa3
  8024fe:	68 17 3a 80 00       	push   $0x803a17
  802503:	e8 76 de ff ff       	call   80037e <_panic>
  802508:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80250b:	8b 00                	mov    (%eax),%eax
  80250d:	85 c0                	test   %eax,%eax
  80250f:	74 10                	je     802521 <alloc_block_FF+0xff>
  802511:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802514:	8b 00                	mov    (%eax),%eax
  802516:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802519:	8b 52 04             	mov    0x4(%edx),%edx
  80251c:	89 50 04             	mov    %edx,0x4(%eax)
  80251f:	eb 0b                	jmp    80252c <alloc_block_FF+0x10a>
  802521:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802524:	8b 40 04             	mov    0x4(%eax),%eax
  802527:	a3 4c 41 80 00       	mov    %eax,0x80414c
  80252c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80252f:	8b 40 04             	mov    0x4(%eax),%eax
  802532:	85 c0                	test   %eax,%eax
  802534:	74 0f                	je     802545 <alloc_block_FF+0x123>
  802536:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802539:	8b 40 04             	mov    0x4(%eax),%eax
  80253c:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80253f:	8b 12                	mov    (%edx),%edx
  802541:	89 10                	mov    %edx,(%eax)
  802543:	eb 0a                	jmp    80254f <alloc_block_FF+0x12d>
  802545:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802548:	8b 00                	mov    (%eax),%eax
  80254a:	a3 48 41 80 00       	mov    %eax,0x804148
  80254f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802552:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802558:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80255b:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802562:	a1 54 41 80 00       	mov    0x804154,%eax
  802567:	48                   	dec    %eax
  802568:	a3 54 41 80 00       	mov    %eax,0x804154
			newblk->size = versize;
  80256d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802570:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802573:	89 50 0c             	mov    %edx,0xc(%eax)
			blk->size = blk->size-versize;
  802576:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802579:	8b 40 0c             	mov    0xc(%eax),%eax
  80257c:	2b 45 f0             	sub    -0x10(%ebp),%eax
  80257f:	89 c2                	mov    %eax,%edx
  802581:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802584:	89 50 0c             	mov    %edx,0xc(%eax)
			uint32 newveradd = blk->sva;
  802587:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80258a:	8b 40 08             	mov    0x8(%eax),%eax
  80258d:	89 45 e8             	mov    %eax,-0x18(%ebp)
			blk->sva+=newblk->size;
  802590:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802593:	8b 50 08             	mov    0x8(%eax),%edx
  802596:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802599:	8b 40 0c             	mov    0xc(%eax),%eax
  80259c:	01 c2                	add    %eax,%edx
  80259e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025a1:	89 50 08             	mov    %edx,0x8(%eax)
			newblk->sva = newveradd;
  8025a4:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8025a7:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8025aa:	89 50 08             	mov    %edx,0x8(%eax)
			return newblk;
  8025ad:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8025b0:	eb 3b                	jmp    8025ed <alloc_block_FF+0x1cb>
	//panic("alloc_block_FF() is not implemented yet...!!");
	uint32 versize = size;
	struct MemBlock* blk;
	struct MemBlock* newblk = LIST_FIRST(&AvailableMemBlocksList);

	LIST_FOREACH(blk,&FreeMemBlocksList)
  8025b2:	a1 40 41 80 00       	mov    0x804140,%eax
  8025b7:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8025ba:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8025be:	74 07                	je     8025c7 <alloc_block_FF+0x1a5>
  8025c0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025c3:	8b 00                	mov    (%eax),%eax
  8025c5:	eb 05                	jmp    8025cc <alloc_block_FF+0x1aa>
  8025c7:	b8 00 00 00 00       	mov    $0x0,%eax
  8025cc:	a3 40 41 80 00       	mov    %eax,0x804140
  8025d1:	a1 40 41 80 00       	mov    0x804140,%eax
  8025d6:	85 c0                	test   %eax,%eax
  8025d8:	0f 85 65 fe ff ff    	jne    802443 <alloc_block_FF+0x21>
  8025de:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8025e2:	0f 85 5b fe ff ff    	jne    802443 <alloc_block_FF+0x21>
			blk->sva+=newblk->size;
			newblk->sva = newveradd;
			return newblk;
		}
	}
	return NULL;
  8025e8:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8025ed:	c9                   	leave  
  8025ee:	c3                   	ret    

008025ef <alloc_block_BF>:

//=========================================
// [5] ALLOCATE BLOCK BY BEST FIT:
//=========================================
struct MemBlock *alloc_block_BF(uint32 size)
{
  8025ef:	55                   	push   %ebp
  8025f0:	89 e5                	mov    %esp,%ebp
  8025f2:	83 ec 28             	sub    $0x28,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_BF
	// Write your code here, remove the panic and write your code
	//panic("alloc_block_BF() is not implemented yet...!!");
	uint32 versize=size;
  8025f5:	8b 45 08             	mov    0x8(%ebp),%eax
  8025f8:	89 45 e8             	mov    %eax,-0x18(%ebp)
	struct MemBlock* blk;
	struct MemBlock* newblk=LIST_FIRST(&AvailableMemBlocksList);
  8025fb:	a1 48 41 80 00       	mov    0x804148,%eax
  802600:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	uint32 newveradd;
	uint32 newsize;
	int size_free = LIST_SIZE(&FreeMemBlocksList);
  802603:	a1 44 41 80 00       	mov    0x804144,%eax
  802608:	89 45 e0             	mov    %eax,-0x20(%ebp)

	LIST_FOREACH(blk, &FreeMemBlocksList)
  80260b:	a1 38 41 80 00       	mov    0x804138,%eax
  802610:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802613:	e9 a1 00 00 00       	jmp    8026b9 <alloc_block_BF+0xca>
	{
		if(blk->size == versize)
  802618:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80261b:	8b 40 0c             	mov    0xc(%eax),%eax
  80261e:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  802621:	0f 85 8a 00 00 00    	jne    8026b1 <alloc_block_BF+0xc2>
		{
			LIST_REMOVE(&FreeMemBlocksList, blk);
  802627:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80262b:	75 17                	jne    802644 <alloc_block_BF+0x55>
  80262d:	83 ec 04             	sub    $0x4,%esp
  802630:	68 88 3a 80 00       	push   $0x803a88
  802635:	68 c2 00 00 00       	push   $0xc2
  80263a:	68 17 3a 80 00       	push   $0x803a17
  80263f:	e8 3a dd ff ff       	call   80037e <_panic>
  802644:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802647:	8b 00                	mov    (%eax),%eax
  802649:	85 c0                	test   %eax,%eax
  80264b:	74 10                	je     80265d <alloc_block_BF+0x6e>
  80264d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802650:	8b 00                	mov    (%eax),%eax
  802652:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802655:	8b 52 04             	mov    0x4(%edx),%edx
  802658:	89 50 04             	mov    %edx,0x4(%eax)
  80265b:	eb 0b                	jmp    802668 <alloc_block_BF+0x79>
  80265d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802660:	8b 40 04             	mov    0x4(%eax),%eax
  802663:	a3 3c 41 80 00       	mov    %eax,0x80413c
  802668:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80266b:	8b 40 04             	mov    0x4(%eax),%eax
  80266e:	85 c0                	test   %eax,%eax
  802670:	74 0f                	je     802681 <alloc_block_BF+0x92>
  802672:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802675:	8b 40 04             	mov    0x4(%eax),%eax
  802678:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80267b:	8b 12                	mov    (%edx),%edx
  80267d:	89 10                	mov    %edx,(%eax)
  80267f:	eb 0a                	jmp    80268b <alloc_block_BF+0x9c>
  802681:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802684:	8b 00                	mov    (%eax),%eax
  802686:	a3 38 41 80 00       	mov    %eax,0x804138
  80268b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80268e:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802694:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802697:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80269e:	a1 44 41 80 00       	mov    0x804144,%eax
  8026a3:	48                   	dec    %eax
  8026a4:	a3 44 41 80 00       	mov    %eax,0x804144
			return blk;
  8026a9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026ac:	e9 11 02 00 00       	jmp    8028c2 <alloc_block_BF+0x2d3>
	struct MemBlock* newblk=LIST_FIRST(&AvailableMemBlocksList);
	uint32 newveradd;
	uint32 newsize;
	int size_free = LIST_SIZE(&FreeMemBlocksList);

	LIST_FOREACH(blk, &FreeMemBlocksList)
  8026b1:	a1 40 41 80 00       	mov    0x804140,%eax
  8026b6:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8026b9:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8026bd:	74 07                	je     8026c6 <alloc_block_BF+0xd7>
  8026bf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026c2:	8b 00                	mov    (%eax),%eax
  8026c4:	eb 05                	jmp    8026cb <alloc_block_BF+0xdc>
  8026c6:	b8 00 00 00 00       	mov    $0x0,%eax
  8026cb:	a3 40 41 80 00       	mov    %eax,0x804140
  8026d0:	a1 40 41 80 00       	mov    0x804140,%eax
  8026d5:	85 c0                	test   %eax,%eax
  8026d7:	0f 85 3b ff ff ff    	jne    802618 <alloc_block_BF+0x29>
  8026dd:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8026e1:	0f 85 31 ff ff ff    	jne    802618 <alloc_block_BF+0x29>
		{
			LIST_REMOVE(&FreeMemBlocksList, blk);
			return blk;
		}
	}
	LIST_FOREACH(blk, &FreeMemBlocksList)
  8026e7:	a1 38 41 80 00       	mov    0x804138,%eax
  8026ec:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8026ef:	eb 27                	jmp    802718 <alloc_block_BF+0x129>
	{
		if(blk->size > versize)
  8026f1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026f4:	8b 40 0c             	mov    0xc(%eax),%eax
  8026f7:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  8026fa:	76 14                	jbe    802710 <alloc_block_BF+0x121>
		{
			newsize = blk->size;
  8026fc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026ff:	8b 40 0c             	mov    0xc(%eax),%eax
  802702:	89 45 ec             	mov    %eax,-0x14(%ebp)
			newveradd = blk->sva;
  802705:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802708:	8b 40 08             	mov    0x8(%eax),%eax
  80270b:	89 45 f0             	mov    %eax,-0x10(%ebp)
			break;
  80270e:	eb 2e                	jmp    80273e <alloc_block_BF+0x14f>
		{
			LIST_REMOVE(&FreeMemBlocksList, blk);
			return blk;
		}
	}
	LIST_FOREACH(blk, &FreeMemBlocksList)
  802710:	a1 40 41 80 00       	mov    0x804140,%eax
  802715:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802718:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80271c:	74 07                	je     802725 <alloc_block_BF+0x136>
  80271e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802721:	8b 00                	mov    (%eax),%eax
  802723:	eb 05                	jmp    80272a <alloc_block_BF+0x13b>
  802725:	b8 00 00 00 00       	mov    $0x0,%eax
  80272a:	a3 40 41 80 00       	mov    %eax,0x804140
  80272f:	a1 40 41 80 00       	mov    0x804140,%eax
  802734:	85 c0                	test   %eax,%eax
  802736:	75 b9                	jne    8026f1 <alloc_block_BF+0x102>
  802738:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80273c:	75 b3                	jne    8026f1 <alloc_block_BF+0x102>
			newsize = blk->size;
			newveradd = blk->sva;
			break;
		}
	}
	LIST_FOREACH(blk, &FreeMemBlocksList)
  80273e:	a1 38 41 80 00       	mov    0x804138,%eax
  802743:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802746:	eb 30                	jmp    802778 <alloc_block_BF+0x189>
	{
		if(newsize > blk->size && blk->size > versize)
  802748:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80274b:	8b 40 0c             	mov    0xc(%eax),%eax
  80274e:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  802751:	73 1d                	jae    802770 <alloc_block_BF+0x181>
  802753:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802756:	8b 40 0c             	mov    0xc(%eax),%eax
  802759:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  80275c:	76 12                	jbe    802770 <alloc_block_BF+0x181>
		{
	       newsize = blk->size;
  80275e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802761:	8b 40 0c             	mov    0xc(%eax),%eax
  802764:	89 45 ec             	mov    %eax,-0x14(%ebp)
		   newveradd = blk->sva;
  802767:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80276a:	8b 40 08             	mov    0x8(%eax),%eax
  80276d:	89 45 f0             	mov    %eax,-0x10(%ebp)
			newsize = blk->size;
			newveradd = blk->sva;
			break;
		}
	}
	LIST_FOREACH(blk, &FreeMemBlocksList)
  802770:	a1 40 41 80 00       	mov    0x804140,%eax
  802775:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802778:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80277c:	74 07                	je     802785 <alloc_block_BF+0x196>
  80277e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802781:	8b 00                	mov    (%eax),%eax
  802783:	eb 05                	jmp    80278a <alloc_block_BF+0x19b>
  802785:	b8 00 00 00 00       	mov    $0x0,%eax
  80278a:	a3 40 41 80 00       	mov    %eax,0x804140
  80278f:	a1 40 41 80 00       	mov    0x804140,%eax
  802794:	85 c0                	test   %eax,%eax
  802796:	75 b0                	jne    802748 <alloc_block_BF+0x159>
  802798:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80279c:	75 aa                	jne    802748 <alloc_block_BF+0x159>
		{
	       newsize = blk->size;
		   newveradd = blk->sva;
		}
	}
	LIST_FOREACH(blk, &FreeMemBlocksList)
  80279e:	a1 38 41 80 00       	mov    0x804138,%eax
  8027a3:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8027a6:	e9 e4 00 00 00       	jmp    80288f <alloc_block_BF+0x2a0>
	{
		if(blk->size == newsize && blk->sva == newveradd)
  8027ab:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027ae:	8b 40 0c             	mov    0xc(%eax),%eax
  8027b1:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  8027b4:	0f 85 cd 00 00 00    	jne    802887 <alloc_block_BF+0x298>
  8027ba:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027bd:	8b 40 08             	mov    0x8(%eax),%eax
  8027c0:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8027c3:	0f 85 be 00 00 00    	jne    802887 <alloc_block_BF+0x298>
		{
			LIST_REMOVE(&AvailableMemBlocksList, newblk);
  8027c9:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8027cd:	75 17                	jne    8027e6 <alloc_block_BF+0x1f7>
  8027cf:	83 ec 04             	sub    $0x4,%esp
  8027d2:	68 88 3a 80 00       	push   $0x803a88
  8027d7:	68 db 00 00 00       	push   $0xdb
  8027dc:	68 17 3a 80 00       	push   $0x803a17
  8027e1:	e8 98 db ff ff       	call   80037e <_panic>
  8027e6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8027e9:	8b 00                	mov    (%eax),%eax
  8027eb:	85 c0                	test   %eax,%eax
  8027ed:	74 10                	je     8027ff <alloc_block_BF+0x210>
  8027ef:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8027f2:	8b 00                	mov    (%eax),%eax
  8027f4:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8027f7:	8b 52 04             	mov    0x4(%edx),%edx
  8027fa:	89 50 04             	mov    %edx,0x4(%eax)
  8027fd:	eb 0b                	jmp    80280a <alloc_block_BF+0x21b>
  8027ff:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802802:	8b 40 04             	mov    0x4(%eax),%eax
  802805:	a3 4c 41 80 00       	mov    %eax,0x80414c
  80280a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80280d:	8b 40 04             	mov    0x4(%eax),%eax
  802810:	85 c0                	test   %eax,%eax
  802812:	74 0f                	je     802823 <alloc_block_BF+0x234>
  802814:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802817:	8b 40 04             	mov    0x4(%eax),%eax
  80281a:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80281d:	8b 12                	mov    (%edx),%edx
  80281f:	89 10                	mov    %edx,(%eax)
  802821:	eb 0a                	jmp    80282d <alloc_block_BF+0x23e>
  802823:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802826:	8b 00                	mov    (%eax),%eax
  802828:	a3 48 41 80 00       	mov    %eax,0x804148
  80282d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802830:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802836:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802839:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802840:	a1 54 41 80 00       	mov    0x804154,%eax
  802845:	48                   	dec    %eax
  802846:	a3 54 41 80 00       	mov    %eax,0x804154
			newblk->size = versize;
  80284b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80284e:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802851:	89 50 0c             	mov    %edx,0xc(%eax)
			newblk->sva = newveradd;
  802854:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802857:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80285a:	89 50 08             	mov    %edx,0x8(%eax)
			blk->size = blk->size - versize;
  80285d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802860:	8b 40 0c             	mov    0xc(%eax),%eax
  802863:	2b 45 e8             	sub    -0x18(%ebp),%eax
  802866:	89 c2                	mov    %eax,%edx
  802868:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80286b:	89 50 0c             	mov    %edx,0xc(%eax)
			blk->sva+= newblk->size;
  80286e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802871:	8b 50 08             	mov    0x8(%eax),%edx
  802874:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802877:	8b 40 0c             	mov    0xc(%eax),%eax
  80287a:	01 c2                	add    %eax,%edx
  80287c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80287f:	89 50 08             	mov    %edx,0x8(%eax)
			return newblk;
  802882:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802885:	eb 3b                	jmp    8028c2 <alloc_block_BF+0x2d3>
		{
	       newsize = blk->size;
		   newveradd = blk->sva;
		}
	}
	LIST_FOREACH(blk, &FreeMemBlocksList)
  802887:	a1 40 41 80 00       	mov    0x804140,%eax
  80288c:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80288f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802893:	74 07                	je     80289c <alloc_block_BF+0x2ad>
  802895:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802898:	8b 00                	mov    (%eax),%eax
  80289a:	eb 05                	jmp    8028a1 <alloc_block_BF+0x2b2>
  80289c:	b8 00 00 00 00       	mov    $0x0,%eax
  8028a1:	a3 40 41 80 00       	mov    %eax,0x804140
  8028a6:	a1 40 41 80 00       	mov    0x804140,%eax
  8028ab:	85 c0                	test   %eax,%eax
  8028ad:	0f 85 f8 fe ff ff    	jne    8027ab <alloc_block_BF+0x1bc>
  8028b3:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8028b7:	0f 85 ee fe ff ff    	jne    8027ab <alloc_block_BF+0x1bc>
			blk->size = blk->size - versize;
			blk->sva+= newblk->size;
			return newblk;
		}
	}
	return NULL;
  8028bd:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8028c2:	c9                   	leave  
  8028c3:	c3                   	ret    

008028c4 <alloc_block_NF>:
//=========================================
// [7] ALLOCATE BLOCK BY NEXT FIT:
//=========================================
struct MemBlock *last_allocate;
struct MemBlock *alloc_block_NF(uint32 size)
{
  8028c4:	55                   	push   %ebp
  8028c5:	89 e5                	mov    %esp,%ebp
  8028c7:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1 - BONUS] [DYNAMIC ALLOCATOR] alloc_block_NF
	// Write your code here, remove the panic and write your code
	//panic("alloc_block_NF() is not implemented yet...!!");
	uint32 versize = size;
  8028ca:	8b 45 08             	mov    0x8(%ebp),%eax
  8028cd:	89 45 f0             	mov    %eax,-0x10(%ebp)
	struct MemBlock* blk;
	struct MemBlock* newblk = LIST_FIRST(&AvailableMemBlocksList);
  8028d0:	a1 48 41 80 00       	mov    0x804148,%eax
  8028d5:	89 45 ec             	mov    %eax,-0x14(%ebp)

	LIST_FOREACH(blk,&FreeMemBlocksList)
  8028d8:	a1 38 41 80 00       	mov    0x804138,%eax
  8028dd:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8028e0:	e9 77 01 00 00       	jmp    802a5c <alloc_block_NF+0x198>
	{
		if(blk->size == versize)
  8028e5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028e8:	8b 40 0c             	mov    0xc(%eax),%eax
  8028eb:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8028ee:	0f 85 8a 00 00 00    	jne    80297e <alloc_block_NF+0xba>
		{
			LIST_REMOVE(&FreeMemBlocksList,blk);
  8028f4:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8028f8:	75 17                	jne    802911 <alloc_block_NF+0x4d>
  8028fa:	83 ec 04             	sub    $0x4,%esp
  8028fd:	68 88 3a 80 00       	push   $0x803a88
  802902:	68 f7 00 00 00       	push   $0xf7
  802907:	68 17 3a 80 00       	push   $0x803a17
  80290c:	e8 6d da ff ff       	call   80037e <_panic>
  802911:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802914:	8b 00                	mov    (%eax),%eax
  802916:	85 c0                	test   %eax,%eax
  802918:	74 10                	je     80292a <alloc_block_NF+0x66>
  80291a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80291d:	8b 00                	mov    (%eax),%eax
  80291f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802922:	8b 52 04             	mov    0x4(%edx),%edx
  802925:	89 50 04             	mov    %edx,0x4(%eax)
  802928:	eb 0b                	jmp    802935 <alloc_block_NF+0x71>
  80292a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80292d:	8b 40 04             	mov    0x4(%eax),%eax
  802930:	a3 3c 41 80 00       	mov    %eax,0x80413c
  802935:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802938:	8b 40 04             	mov    0x4(%eax),%eax
  80293b:	85 c0                	test   %eax,%eax
  80293d:	74 0f                	je     80294e <alloc_block_NF+0x8a>
  80293f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802942:	8b 40 04             	mov    0x4(%eax),%eax
  802945:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802948:	8b 12                	mov    (%edx),%edx
  80294a:	89 10                	mov    %edx,(%eax)
  80294c:	eb 0a                	jmp    802958 <alloc_block_NF+0x94>
  80294e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802951:	8b 00                	mov    (%eax),%eax
  802953:	a3 38 41 80 00       	mov    %eax,0x804138
  802958:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80295b:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802961:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802964:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80296b:	a1 44 41 80 00       	mov    0x804144,%eax
  802970:	48                   	dec    %eax
  802971:	a3 44 41 80 00       	mov    %eax,0x804144
			return blk;
  802976:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802979:	e9 11 01 00 00       	jmp    802a8f <alloc_block_NF+0x1cb>
		}
		else if(blk->size > versize)
  80297e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802981:	8b 40 0c             	mov    0xc(%eax),%eax
  802984:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  802987:	0f 86 c7 00 00 00    	jbe    802a54 <alloc_block_NF+0x190>
		{
			LIST_REMOVE(&AvailableMemBlocksList,newblk);
  80298d:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802991:	75 17                	jne    8029aa <alloc_block_NF+0xe6>
  802993:	83 ec 04             	sub    $0x4,%esp
  802996:	68 88 3a 80 00       	push   $0x803a88
  80299b:	68 fc 00 00 00       	push   $0xfc
  8029a0:	68 17 3a 80 00       	push   $0x803a17
  8029a5:	e8 d4 d9 ff ff       	call   80037e <_panic>
  8029aa:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8029ad:	8b 00                	mov    (%eax),%eax
  8029af:	85 c0                	test   %eax,%eax
  8029b1:	74 10                	je     8029c3 <alloc_block_NF+0xff>
  8029b3:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8029b6:	8b 00                	mov    (%eax),%eax
  8029b8:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8029bb:	8b 52 04             	mov    0x4(%edx),%edx
  8029be:	89 50 04             	mov    %edx,0x4(%eax)
  8029c1:	eb 0b                	jmp    8029ce <alloc_block_NF+0x10a>
  8029c3:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8029c6:	8b 40 04             	mov    0x4(%eax),%eax
  8029c9:	a3 4c 41 80 00       	mov    %eax,0x80414c
  8029ce:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8029d1:	8b 40 04             	mov    0x4(%eax),%eax
  8029d4:	85 c0                	test   %eax,%eax
  8029d6:	74 0f                	je     8029e7 <alloc_block_NF+0x123>
  8029d8:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8029db:	8b 40 04             	mov    0x4(%eax),%eax
  8029de:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8029e1:	8b 12                	mov    (%edx),%edx
  8029e3:	89 10                	mov    %edx,(%eax)
  8029e5:	eb 0a                	jmp    8029f1 <alloc_block_NF+0x12d>
  8029e7:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8029ea:	8b 00                	mov    (%eax),%eax
  8029ec:	a3 48 41 80 00       	mov    %eax,0x804148
  8029f1:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8029f4:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8029fa:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8029fd:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802a04:	a1 54 41 80 00       	mov    0x804154,%eax
  802a09:	48                   	dec    %eax
  802a0a:	a3 54 41 80 00       	mov    %eax,0x804154
			newblk->size = versize;
  802a0f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802a12:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802a15:	89 50 0c             	mov    %edx,0xc(%eax)
			blk->size = blk->size-versize;
  802a18:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a1b:	8b 40 0c             	mov    0xc(%eax),%eax
  802a1e:	2b 45 f0             	sub    -0x10(%ebp),%eax
  802a21:	89 c2                	mov    %eax,%edx
  802a23:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a26:	89 50 0c             	mov    %edx,0xc(%eax)
			uint32 newveradd = blk->sva;
  802a29:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a2c:	8b 40 08             	mov    0x8(%eax),%eax
  802a2f:	89 45 e8             	mov    %eax,-0x18(%ebp)
			blk->sva+=newblk->size;
  802a32:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a35:	8b 50 08             	mov    0x8(%eax),%edx
  802a38:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802a3b:	8b 40 0c             	mov    0xc(%eax),%eax
  802a3e:	01 c2                	add    %eax,%edx
  802a40:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a43:	89 50 08             	mov    %edx,0x8(%eax)
			newblk->sva = newveradd;
  802a46:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802a49:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802a4c:	89 50 08             	mov    %edx,0x8(%eax)
			return newblk;
  802a4f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802a52:	eb 3b                	jmp    802a8f <alloc_block_NF+0x1cb>
	//panic("alloc_block_NF() is not implemented yet...!!");
	uint32 versize = size;
	struct MemBlock* blk;
	struct MemBlock* newblk = LIST_FIRST(&AvailableMemBlocksList);

	LIST_FOREACH(blk,&FreeMemBlocksList)
  802a54:	a1 40 41 80 00       	mov    0x804140,%eax
  802a59:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802a5c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802a60:	74 07                	je     802a69 <alloc_block_NF+0x1a5>
  802a62:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a65:	8b 00                	mov    (%eax),%eax
  802a67:	eb 05                	jmp    802a6e <alloc_block_NF+0x1aa>
  802a69:	b8 00 00 00 00       	mov    $0x0,%eax
  802a6e:	a3 40 41 80 00       	mov    %eax,0x804140
  802a73:	a1 40 41 80 00       	mov    0x804140,%eax
  802a78:	85 c0                	test   %eax,%eax
  802a7a:	0f 85 65 fe ff ff    	jne    8028e5 <alloc_block_NF+0x21>
  802a80:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802a84:	0f 85 5b fe ff ff    	jne    8028e5 <alloc_block_NF+0x21>
			blk->sva+=newblk->size;
			newblk->sva = newveradd;
			return newblk;
		}
	}
	return NULL;
  802a8a:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802a8f:	c9                   	leave  
  802a90:	c3                   	ret    

00802a91 <addToAvailMemBlocksList>:

//===================================================
// [8] INSERT BLOCK (SORTED WITH MERGE) IN FREE LIST:
//===================================================
void addToAvailMemBlocksList(struct MemBlock *blockToInsert)
{
  802a91:	55                   	push   %ebp
  802a92:	89 e5                	mov    %esp,%ebp
  802a94:	83 ec 08             	sub    $0x8,%esp
	blockToInsert->sva = 0;
  802a97:	8b 45 08             	mov    0x8(%ebp),%eax
  802a9a:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
	blockToInsert->size = 0;
  802aa1:	8b 45 08             	mov    0x8(%ebp),%eax
  802aa4:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
	//add to avail
	LIST_INSERT_TAIL(&AvailableMemBlocksList, blockToInsert);
  802aab:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802aaf:	75 17                	jne    802ac8 <addToAvailMemBlocksList+0x37>
  802ab1:	83 ec 04             	sub    $0x4,%esp
  802ab4:	68 30 3a 80 00       	push   $0x803a30
  802ab9:	68 10 01 00 00       	push   $0x110
  802abe:	68 17 3a 80 00       	push   $0x803a17
  802ac3:	e8 b6 d8 ff ff       	call   80037e <_panic>
  802ac8:	8b 15 4c 41 80 00    	mov    0x80414c,%edx
  802ace:	8b 45 08             	mov    0x8(%ebp),%eax
  802ad1:	89 50 04             	mov    %edx,0x4(%eax)
  802ad4:	8b 45 08             	mov    0x8(%ebp),%eax
  802ad7:	8b 40 04             	mov    0x4(%eax),%eax
  802ada:	85 c0                	test   %eax,%eax
  802adc:	74 0c                	je     802aea <addToAvailMemBlocksList+0x59>
  802ade:	a1 4c 41 80 00       	mov    0x80414c,%eax
  802ae3:	8b 55 08             	mov    0x8(%ebp),%edx
  802ae6:	89 10                	mov    %edx,(%eax)
  802ae8:	eb 08                	jmp    802af2 <addToAvailMemBlocksList+0x61>
  802aea:	8b 45 08             	mov    0x8(%ebp),%eax
  802aed:	a3 48 41 80 00       	mov    %eax,0x804148
  802af2:	8b 45 08             	mov    0x8(%ebp),%eax
  802af5:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802afa:	8b 45 08             	mov    0x8(%ebp),%eax
  802afd:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802b03:	a1 54 41 80 00       	mov    0x804154,%eax
  802b08:	40                   	inc    %eax
  802b09:	a3 54 41 80 00       	mov    %eax,0x804154
}
  802b0e:	90                   	nop
  802b0f:	c9                   	leave  
  802b10:	c3                   	ret    

00802b11 <insert_sorted_with_merge_freeList>:
void insert_sorted_with_merge_freeList(struct MemBlock *blockToInsert)
{
  802b11:	55                   	push   %ebp
  802b12:	89 e5                	mov    %esp,%ebp
  802b14:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] insert_sorted_with_merge_freeList
	// Write your code here, remove the panic and write your code

	struct MemBlock* last = LIST_LAST(&FreeMemBlocksList);
  802b17:	a1 3c 41 80 00       	mov    0x80413c,%eax
  802b1c:	89 45 f0             	mov    %eax,-0x10(%ebp)
	//check if list empty
	if (LIST_SIZE(&(FreeMemBlocksList)) == 0)
  802b1f:	a1 44 41 80 00       	mov    0x804144,%eax
  802b24:	85 c0                	test   %eax,%eax
  802b26:	75 68                	jne    802b90 <insert_sorted_with_merge_freeList+0x7f>
		LIST_INSERT_HEAD(&FreeMemBlocksList, blockToInsert);
  802b28:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802b2c:	75 17                	jne    802b45 <insert_sorted_with_merge_freeList+0x34>
  802b2e:	83 ec 04             	sub    $0x4,%esp
  802b31:	68 f4 39 80 00       	push   $0x8039f4
  802b36:	68 1a 01 00 00       	push   $0x11a
  802b3b:	68 17 3a 80 00       	push   $0x803a17
  802b40:	e8 39 d8 ff ff       	call   80037e <_panic>
  802b45:	8b 15 38 41 80 00    	mov    0x804138,%edx
  802b4b:	8b 45 08             	mov    0x8(%ebp),%eax
  802b4e:	89 10                	mov    %edx,(%eax)
  802b50:	8b 45 08             	mov    0x8(%ebp),%eax
  802b53:	8b 00                	mov    (%eax),%eax
  802b55:	85 c0                	test   %eax,%eax
  802b57:	74 0d                	je     802b66 <insert_sorted_with_merge_freeList+0x55>
  802b59:	a1 38 41 80 00       	mov    0x804138,%eax
  802b5e:	8b 55 08             	mov    0x8(%ebp),%edx
  802b61:	89 50 04             	mov    %edx,0x4(%eax)
  802b64:	eb 08                	jmp    802b6e <insert_sorted_with_merge_freeList+0x5d>
  802b66:	8b 45 08             	mov    0x8(%ebp),%eax
  802b69:	a3 3c 41 80 00       	mov    %eax,0x80413c
  802b6e:	8b 45 08             	mov    0x8(%ebp),%eax
  802b71:	a3 38 41 80 00       	mov    %eax,0x804138
  802b76:	8b 45 08             	mov    0x8(%ebp),%eax
  802b79:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802b80:	a1 44 41 80 00       	mov    0x804144,%eax
  802b85:	40                   	inc    %eax
  802b86:	a3 44 41 80 00       	mov    %eax,0x804144
		}
	}

	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  802b8b:	e9 c5 03 00 00       	jmp    802f55 <insert_sorted_with_merge_freeList+0x444>
	struct MemBlock* last = LIST_LAST(&FreeMemBlocksList);
	//check if list empty
	if (LIST_SIZE(&(FreeMemBlocksList)) == 0)
		LIST_INSERT_HEAD(&FreeMemBlocksList, blockToInsert);
	//check if it's position is at last
	else if (last->sva < blockToInsert->sva) {
  802b90:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b93:	8b 50 08             	mov    0x8(%eax),%edx
  802b96:	8b 45 08             	mov    0x8(%ebp),%eax
  802b99:	8b 40 08             	mov    0x8(%eax),%eax
  802b9c:	39 c2                	cmp    %eax,%edx
  802b9e:	0f 83 b2 00 00 00    	jae    802c56 <insert_sorted_with_merge_freeList+0x145>

		//if i have to merge
		if (last->sva + last->size == blockToInsert->sva) {
  802ba4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802ba7:	8b 50 08             	mov    0x8(%eax),%edx
  802baa:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802bad:	8b 40 0c             	mov    0xc(%eax),%eax
  802bb0:	01 c2                	add    %eax,%edx
  802bb2:	8b 45 08             	mov    0x8(%ebp),%eax
  802bb5:	8b 40 08             	mov    0x8(%eax),%eax
  802bb8:	39 c2                	cmp    %eax,%edx
  802bba:	75 27                	jne    802be3 <insert_sorted_with_merge_freeList+0xd2>
			last->size = last->size + blockToInsert->size;
  802bbc:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802bbf:	8b 50 0c             	mov    0xc(%eax),%edx
  802bc2:	8b 45 08             	mov    0x8(%ebp),%eax
  802bc5:	8b 40 0c             	mov    0xc(%eax),%eax
  802bc8:	01 c2                	add    %eax,%edx
  802bca:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802bcd:	89 50 0c             	mov    %edx,0xc(%eax)
			addToAvailMemBlocksList(blockToInsert);
  802bd0:	83 ec 0c             	sub    $0xc,%esp
  802bd3:	ff 75 08             	pushl  0x8(%ebp)
  802bd6:	e8 b6 fe ff ff       	call   802a91 <addToAvailMemBlocksList>
  802bdb:	83 c4 10             	add    $0x10,%esp
		}
	}

	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  802bde:	e9 72 03 00 00       	jmp    802f55 <insert_sorted_with_merge_freeList+0x444>
		if (last->sva + last->size == blockToInsert->sva) {
			last->size = last->size + blockToInsert->size;
			addToAvailMemBlocksList(blockToInsert);

		} else {
			LIST_INSERT_AFTER(&FreeMemBlocksList, last, blockToInsert);
  802be3:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802be7:	74 06                	je     802bef <insert_sorted_with_merge_freeList+0xde>
  802be9:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802bed:	75 17                	jne    802c06 <insert_sorted_with_merge_freeList+0xf5>
  802bef:	83 ec 04             	sub    $0x4,%esp
  802bf2:	68 54 3a 80 00       	push   $0x803a54
  802bf7:	68 24 01 00 00       	push   $0x124
  802bfc:	68 17 3a 80 00       	push   $0x803a17
  802c01:	e8 78 d7 ff ff       	call   80037e <_panic>
  802c06:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c09:	8b 10                	mov    (%eax),%edx
  802c0b:	8b 45 08             	mov    0x8(%ebp),%eax
  802c0e:	89 10                	mov    %edx,(%eax)
  802c10:	8b 45 08             	mov    0x8(%ebp),%eax
  802c13:	8b 00                	mov    (%eax),%eax
  802c15:	85 c0                	test   %eax,%eax
  802c17:	74 0b                	je     802c24 <insert_sorted_with_merge_freeList+0x113>
  802c19:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c1c:	8b 00                	mov    (%eax),%eax
  802c1e:	8b 55 08             	mov    0x8(%ebp),%edx
  802c21:	89 50 04             	mov    %edx,0x4(%eax)
  802c24:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c27:	8b 55 08             	mov    0x8(%ebp),%edx
  802c2a:	89 10                	mov    %edx,(%eax)
  802c2c:	8b 45 08             	mov    0x8(%ebp),%eax
  802c2f:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802c32:	89 50 04             	mov    %edx,0x4(%eax)
  802c35:	8b 45 08             	mov    0x8(%ebp),%eax
  802c38:	8b 00                	mov    (%eax),%eax
  802c3a:	85 c0                	test   %eax,%eax
  802c3c:	75 08                	jne    802c46 <insert_sorted_with_merge_freeList+0x135>
  802c3e:	8b 45 08             	mov    0x8(%ebp),%eax
  802c41:	a3 3c 41 80 00       	mov    %eax,0x80413c
  802c46:	a1 44 41 80 00       	mov    0x804144,%eax
  802c4b:	40                   	inc    %eax
  802c4c:	a3 44 41 80 00       	mov    %eax,0x804144
		}
	}

	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  802c51:	e9 ff 02 00 00       	jmp    802f55 <insert_sorted_with_merge_freeList+0x444>
		} else {
			LIST_INSERT_AFTER(&FreeMemBlocksList, last, blockToInsert);
		}
	} else {
		struct MemBlock *iterator;
		LIST_FOREACH(iterator, &(FreeMemBlocksList))
  802c56:	a1 38 41 80 00       	mov    0x804138,%eax
  802c5b:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802c5e:	e9 c2 02 00 00       	jmp    802f25 <insert_sorted_with_merge_freeList+0x414>
		{

			if (iterator->sva > blockToInsert->sva) {
  802c63:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c66:	8b 50 08             	mov    0x8(%eax),%edx
  802c69:	8b 45 08             	mov    0x8(%ebp),%eax
  802c6c:	8b 40 08             	mov    0x8(%eax),%eax
  802c6f:	39 c2                	cmp    %eax,%edx
  802c71:	0f 86 a6 02 00 00    	jbe    802f1d <insert_sorted_with_merge_freeList+0x40c>

				struct MemBlock* prev = LIST_PREV(iterator);
  802c77:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c7a:	8b 40 04             	mov    0x4(%eax),%eax
  802c7d:	89 45 ec             	mov    %eax,-0x14(%ebp)
				if (prev == NULL) {
  802c80:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802c84:	0f 85 ba 00 00 00    	jne    802d44 <insert_sorted_with_merge_freeList+0x233>
					//check merge
					if (blockToInsert->size + blockToInsert->sva
  802c8a:	8b 45 08             	mov    0x8(%ebp),%eax
  802c8d:	8b 50 0c             	mov    0xc(%eax),%edx
  802c90:	8b 45 08             	mov    0x8(%ebp),%eax
  802c93:	8b 40 08             	mov    0x8(%eax),%eax
  802c96:	01 c2                	add    %eax,%edx
							== iterator->sva) {
  802c98:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c9b:	8b 40 08             	mov    0x8(%eax),%eax
			if (iterator->sva > blockToInsert->sva) {

				struct MemBlock* prev = LIST_PREV(iterator);
				if (prev == NULL) {
					//check merge
					if (blockToInsert->size + blockToInsert->sva
  802c9e:	39 c2                	cmp    %eax,%edx
  802ca0:	75 33                	jne    802cd5 <insert_sorted_with_merge_freeList+0x1c4>
							== iterator->sva) {
						iterator->sva = blockToInsert->sva;
  802ca2:	8b 45 08             	mov    0x8(%ebp),%eax
  802ca5:	8b 50 08             	mov    0x8(%eax),%edx
  802ca8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cab:	89 50 08             	mov    %edx,0x8(%eax)
						iterator->size = iterator->size + blockToInsert->size;
  802cae:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cb1:	8b 50 0c             	mov    0xc(%eax),%edx
  802cb4:	8b 45 08             	mov    0x8(%ebp),%eax
  802cb7:	8b 40 0c             	mov    0xc(%eax),%eax
  802cba:	01 c2                	add    %eax,%edx
  802cbc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cbf:	89 50 0c             	mov    %edx,0xc(%eax)
						addToAvailMemBlocksList(blockToInsert);
  802cc2:	83 ec 0c             	sub    $0xc,%esp
  802cc5:	ff 75 08             	pushl  0x8(%ebp)
  802cc8:	e8 c4 fd ff ff       	call   802a91 <addToAvailMemBlocksList>
  802ccd:	83 c4 10             	add    $0x10,%esp

					else {
						LIST_INSERT_BEFORE(&FreeMemBlocksList, iterator,
								blockToInsert);
					}
					break;
  802cd0:	e9 80 02 00 00       	jmp    802f55 <insert_sorted_with_merge_freeList+0x444>
						addToAvailMemBlocksList(blockToInsert);

					}

					else {
						LIST_INSERT_BEFORE(&FreeMemBlocksList, iterator,
  802cd5:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802cd9:	74 06                	je     802ce1 <insert_sorted_with_merge_freeList+0x1d0>
  802cdb:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802cdf:	75 17                	jne    802cf8 <insert_sorted_with_merge_freeList+0x1e7>
  802ce1:	83 ec 04             	sub    $0x4,%esp
  802ce4:	68 a8 3a 80 00       	push   $0x803aa8
  802ce9:	68 3a 01 00 00       	push   $0x13a
  802cee:	68 17 3a 80 00       	push   $0x803a17
  802cf3:	e8 86 d6 ff ff       	call   80037e <_panic>
  802cf8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cfb:	8b 50 04             	mov    0x4(%eax),%edx
  802cfe:	8b 45 08             	mov    0x8(%ebp),%eax
  802d01:	89 50 04             	mov    %edx,0x4(%eax)
  802d04:	8b 45 08             	mov    0x8(%ebp),%eax
  802d07:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802d0a:	89 10                	mov    %edx,(%eax)
  802d0c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d0f:	8b 40 04             	mov    0x4(%eax),%eax
  802d12:	85 c0                	test   %eax,%eax
  802d14:	74 0d                	je     802d23 <insert_sorted_with_merge_freeList+0x212>
  802d16:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d19:	8b 40 04             	mov    0x4(%eax),%eax
  802d1c:	8b 55 08             	mov    0x8(%ebp),%edx
  802d1f:	89 10                	mov    %edx,(%eax)
  802d21:	eb 08                	jmp    802d2b <insert_sorted_with_merge_freeList+0x21a>
  802d23:	8b 45 08             	mov    0x8(%ebp),%eax
  802d26:	a3 38 41 80 00       	mov    %eax,0x804138
  802d2b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d2e:	8b 55 08             	mov    0x8(%ebp),%edx
  802d31:	89 50 04             	mov    %edx,0x4(%eax)
  802d34:	a1 44 41 80 00       	mov    0x804144,%eax
  802d39:	40                   	inc    %eax
  802d3a:	a3 44 41 80 00       	mov    %eax,0x804144
								blockToInsert);
					}
					break;
  802d3f:	e9 11 02 00 00       	jmp    802f55 <insert_sorted_with_merge_freeList+0x444>
				} else {
					//prev and next merge
					if (prev->sva + prev->size + blockToInsert->size
  802d44:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802d47:	8b 50 08             	mov    0x8(%eax),%edx
  802d4a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802d4d:	8b 40 0c             	mov    0xc(%eax),%eax
  802d50:	01 c2                	add    %eax,%edx
  802d52:	8b 45 08             	mov    0x8(%ebp),%eax
  802d55:	8b 40 0c             	mov    0xc(%eax),%eax
  802d58:	01 c2                	add    %eax,%edx
							== iterator->sva) {
  802d5a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d5d:	8b 40 08             	mov    0x8(%eax),%eax
								blockToInsert);
					}
					break;
				} else {
					//prev and next merge
					if (prev->sva + prev->size + blockToInsert->size
  802d60:	39 c2                	cmp    %eax,%edx
  802d62:	0f 85 bf 00 00 00    	jne    802e27 <insert_sorted_with_merge_freeList+0x316>
							== iterator->sva) {
						prev->size = prev->size + blockToInsert->size
  802d68:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802d6b:	8b 50 0c             	mov    0xc(%eax),%edx
  802d6e:	8b 45 08             	mov    0x8(%ebp),%eax
  802d71:	8b 40 0c             	mov    0xc(%eax),%eax
  802d74:	01 c2                	add    %eax,%edx
								+ iterator->size;
  802d76:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d79:	8b 40 0c             	mov    0xc(%eax),%eax
  802d7c:	01 c2                	add    %eax,%edx
					break;
				} else {
					//prev and next merge
					if (prev->sva + prev->size + blockToInsert->size
							== iterator->sva) {
						prev->size = prev->size + blockToInsert->size
  802d7e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802d81:	89 50 0c             	mov    %edx,0xc(%eax)
								+ iterator->size;
						LIST_REMOVE(&FreeMemBlocksList, iterator);
  802d84:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802d88:	75 17                	jne    802da1 <insert_sorted_with_merge_freeList+0x290>
  802d8a:	83 ec 04             	sub    $0x4,%esp
  802d8d:	68 88 3a 80 00       	push   $0x803a88
  802d92:	68 43 01 00 00       	push   $0x143
  802d97:	68 17 3a 80 00       	push   $0x803a17
  802d9c:	e8 dd d5 ff ff       	call   80037e <_panic>
  802da1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802da4:	8b 00                	mov    (%eax),%eax
  802da6:	85 c0                	test   %eax,%eax
  802da8:	74 10                	je     802dba <insert_sorted_with_merge_freeList+0x2a9>
  802daa:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802dad:	8b 00                	mov    (%eax),%eax
  802daf:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802db2:	8b 52 04             	mov    0x4(%edx),%edx
  802db5:	89 50 04             	mov    %edx,0x4(%eax)
  802db8:	eb 0b                	jmp    802dc5 <insert_sorted_with_merge_freeList+0x2b4>
  802dba:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802dbd:	8b 40 04             	mov    0x4(%eax),%eax
  802dc0:	a3 3c 41 80 00       	mov    %eax,0x80413c
  802dc5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802dc8:	8b 40 04             	mov    0x4(%eax),%eax
  802dcb:	85 c0                	test   %eax,%eax
  802dcd:	74 0f                	je     802dde <insert_sorted_with_merge_freeList+0x2cd>
  802dcf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802dd2:	8b 40 04             	mov    0x4(%eax),%eax
  802dd5:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802dd8:	8b 12                	mov    (%edx),%edx
  802dda:	89 10                	mov    %edx,(%eax)
  802ddc:	eb 0a                	jmp    802de8 <insert_sorted_with_merge_freeList+0x2d7>
  802dde:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802de1:	8b 00                	mov    (%eax),%eax
  802de3:	a3 38 41 80 00       	mov    %eax,0x804138
  802de8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802deb:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802df1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802df4:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802dfb:	a1 44 41 80 00       	mov    0x804144,%eax
  802e00:	48                   	dec    %eax
  802e01:	a3 44 41 80 00       	mov    %eax,0x804144
						addToAvailMemBlocksList(blockToInsert);
  802e06:	83 ec 0c             	sub    $0xc,%esp
  802e09:	ff 75 08             	pushl  0x8(%ebp)
  802e0c:	e8 80 fc ff ff       	call   802a91 <addToAvailMemBlocksList>
  802e11:	83 c4 10             	add    $0x10,%esp
						addToAvailMemBlocksList(iterator);
  802e14:	83 ec 0c             	sub    $0xc,%esp
  802e17:	ff 75 f4             	pushl  -0xc(%ebp)
  802e1a:	e8 72 fc ff ff       	call   802a91 <addToAvailMemBlocksList>
  802e1f:	83 c4 10             	add    $0x10,%esp
					//Insert
					else {
						LIST_INSERT_BEFORE(&FreeMemBlocksList, iterator,
								blockToInsert);
					}
					break;
  802e22:	e9 2e 01 00 00       	jmp    802f55 <insert_sorted_with_merge_freeList+0x444>
						LIST_REMOVE(&FreeMemBlocksList, iterator);
						addToAvailMemBlocksList(blockToInsert);
						addToAvailMemBlocksList(iterator);
					}
					//previous merge
					else if (prev->sva + prev->size == blockToInsert->sva) {
  802e27:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802e2a:	8b 50 08             	mov    0x8(%eax),%edx
  802e2d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802e30:	8b 40 0c             	mov    0xc(%eax),%eax
  802e33:	01 c2                	add    %eax,%edx
  802e35:	8b 45 08             	mov    0x8(%ebp),%eax
  802e38:	8b 40 08             	mov    0x8(%eax),%eax
  802e3b:	39 c2                	cmp    %eax,%edx
  802e3d:	75 27                	jne    802e66 <insert_sorted_with_merge_freeList+0x355>
						prev->size = prev->size + blockToInsert->size;
  802e3f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802e42:	8b 50 0c             	mov    0xc(%eax),%edx
  802e45:	8b 45 08             	mov    0x8(%ebp),%eax
  802e48:	8b 40 0c             	mov    0xc(%eax),%eax
  802e4b:	01 c2                	add    %eax,%edx
  802e4d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802e50:	89 50 0c             	mov    %edx,0xc(%eax)
						addToAvailMemBlocksList(blockToInsert);
  802e53:	83 ec 0c             	sub    $0xc,%esp
  802e56:	ff 75 08             	pushl  0x8(%ebp)
  802e59:	e8 33 fc ff ff       	call   802a91 <addToAvailMemBlocksList>
  802e5e:	83 c4 10             	add    $0x10,%esp
					//Insert
					else {
						LIST_INSERT_BEFORE(&FreeMemBlocksList, iterator,
								blockToInsert);
					}
					break;
  802e61:	e9 ef 00 00 00       	jmp    802f55 <insert_sorted_with_merge_freeList+0x444>
					else if (prev->sva + prev->size == blockToInsert->sva) {
						prev->size = prev->size + blockToInsert->size;
						addToAvailMemBlocksList(blockToInsert);
					}
					//next merge
					else if (blockToInsert->size + blockToInsert->sva
  802e66:	8b 45 08             	mov    0x8(%ebp),%eax
  802e69:	8b 50 0c             	mov    0xc(%eax),%edx
  802e6c:	8b 45 08             	mov    0x8(%ebp),%eax
  802e6f:	8b 40 08             	mov    0x8(%eax),%eax
  802e72:	01 c2                	add    %eax,%edx
							== iterator->sva) {
  802e74:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e77:	8b 40 08             	mov    0x8(%eax),%eax
					else if (prev->sva + prev->size == blockToInsert->sva) {
						prev->size = prev->size + blockToInsert->size;
						addToAvailMemBlocksList(blockToInsert);
					}
					//next merge
					else if (blockToInsert->size + blockToInsert->sva
  802e7a:	39 c2                	cmp    %eax,%edx
  802e7c:	75 33                	jne    802eb1 <insert_sorted_with_merge_freeList+0x3a0>
							== iterator->sva) {
						iterator->sva = blockToInsert->sva;
  802e7e:	8b 45 08             	mov    0x8(%ebp),%eax
  802e81:	8b 50 08             	mov    0x8(%eax),%edx
  802e84:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e87:	89 50 08             	mov    %edx,0x8(%eax)
						iterator->size = iterator->size + blockToInsert->size;
  802e8a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e8d:	8b 50 0c             	mov    0xc(%eax),%edx
  802e90:	8b 45 08             	mov    0x8(%ebp),%eax
  802e93:	8b 40 0c             	mov    0xc(%eax),%eax
  802e96:	01 c2                	add    %eax,%edx
  802e98:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e9b:	89 50 0c             	mov    %edx,0xc(%eax)
						addToAvailMemBlocksList(blockToInsert);
  802e9e:	83 ec 0c             	sub    $0xc,%esp
  802ea1:	ff 75 08             	pushl  0x8(%ebp)
  802ea4:	e8 e8 fb ff ff       	call   802a91 <addToAvailMemBlocksList>
  802ea9:	83 c4 10             	add    $0x10,%esp
					//Insert
					else {
						LIST_INSERT_BEFORE(&FreeMemBlocksList, iterator,
								blockToInsert);
					}
					break;
  802eac:	e9 a4 00 00 00       	jmp    802f55 <insert_sorted_with_merge_freeList+0x444>
						iterator->size = iterator->size + blockToInsert->size;
						addToAvailMemBlocksList(blockToInsert);
					}
					//Insert
					else {
						LIST_INSERT_BEFORE(&FreeMemBlocksList, iterator,
  802eb1:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802eb5:	74 06                	je     802ebd <insert_sorted_with_merge_freeList+0x3ac>
  802eb7:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802ebb:	75 17                	jne    802ed4 <insert_sorted_with_merge_freeList+0x3c3>
  802ebd:	83 ec 04             	sub    $0x4,%esp
  802ec0:	68 a8 3a 80 00       	push   $0x803aa8
  802ec5:	68 56 01 00 00       	push   $0x156
  802eca:	68 17 3a 80 00       	push   $0x803a17
  802ecf:	e8 aa d4 ff ff       	call   80037e <_panic>
  802ed4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ed7:	8b 50 04             	mov    0x4(%eax),%edx
  802eda:	8b 45 08             	mov    0x8(%ebp),%eax
  802edd:	89 50 04             	mov    %edx,0x4(%eax)
  802ee0:	8b 45 08             	mov    0x8(%ebp),%eax
  802ee3:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802ee6:	89 10                	mov    %edx,(%eax)
  802ee8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802eeb:	8b 40 04             	mov    0x4(%eax),%eax
  802eee:	85 c0                	test   %eax,%eax
  802ef0:	74 0d                	je     802eff <insert_sorted_with_merge_freeList+0x3ee>
  802ef2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ef5:	8b 40 04             	mov    0x4(%eax),%eax
  802ef8:	8b 55 08             	mov    0x8(%ebp),%edx
  802efb:	89 10                	mov    %edx,(%eax)
  802efd:	eb 08                	jmp    802f07 <insert_sorted_with_merge_freeList+0x3f6>
  802eff:	8b 45 08             	mov    0x8(%ebp),%eax
  802f02:	a3 38 41 80 00       	mov    %eax,0x804138
  802f07:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f0a:	8b 55 08             	mov    0x8(%ebp),%edx
  802f0d:	89 50 04             	mov    %edx,0x4(%eax)
  802f10:	a1 44 41 80 00       	mov    0x804144,%eax
  802f15:	40                   	inc    %eax
  802f16:	a3 44 41 80 00       	mov    %eax,0x804144
								blockToInsert);
					}
					break;
  802f1b:	eb 38                	jmp    802f55 <insert_sorted_with_merge_freeList+0x444>
		} else {
			LIST_INSERT_AFTER(&FreeMemBlocksList, last, blockToInsert);
		}
	} else {
		struct MemBlock *iterator;
		LIST_FOREACH(iterator, &(FreeMemBlocksList))
  802f1d:	a1 40 41 80 00       	mov    0x804140,%eax
  802f22:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802f25:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802f29:	74 07                	je     802f32 <insert_sorted_with_merge_freeList+0x421>
  802f2b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f2e:	8b 00                	mov    (%eax),%eax
  802f30:	eb 05                	jmp    802f37 <insert_sorted_with_merge_freeList+0x426>
  802f32:	b8 00 00 00 00       	mov    $0x0,%eax
  802f37:	a3 40 41 80 00       	mov    %eax,0x804140
  802f3c:	a1 40 41 80 00       	mov    0x804140,%eax
  802f41:	85 c0                	test   %eax,%eax
  802f43:	0f 85 1a fd ff ff    	jne    802c63 <insert_sorted_with_merge_freeList+0x152>
  802f49:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802f4d:	0f 85 10 fd ff ff    	jne    802c63 <insert_sorted_with_merge_freeList+0x152>
		}
	}

	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  802f53:	eb 00                	jmp    802f55 <insert_sorted_with_merge_freeList+0x444>
  802f55:	90                   	nop
  802f56:	c9                   	leave  
  802f57:	c3                   	ret    

00802f58 <__udivdi3>:
  802f58:	55                   	push   %ebp
  802f59:	57                   	push   %edi
  802f5a:	56                   	push   %esi
  802f5b:	53                   	push   %ebx
  802f5c:	83 ec 1c             	sub    $0x1c,%esp
  802f5f:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  802f63:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  802f67:	8b 7c 24 38          	mov    0x38(%esp),%edi
  802f6b:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  802f6f:	89 ca                	mov    %ecx,%edx
  802f71:	89 f8                	mov    %edi,%eax
  802f73:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  802f77:	85 f6                	test   %esi,%esi
  802f79:	75 2d                	jne    802fa8 <__udivdi3+0x50>
  802f7b:	39 cf                	cmp    %ecx,%edi
  802f7d:	77 65                	ja     802fe4 <__udivdi3+0x8c>
  802f7f:	89 fd                	mov    %edi,%ebp
  802f81:	85 ff                	test   %edi,%edi
  802f83:	75 0b                	jne    802f90 <__udivdi3+0x38>
  802f85:	b8 01 00 00 00       	mov    $0x1,%eax
  802f8a:	31 d2                	xor    %edx,%edx
  802f8c:	f7 f7                	div    %edi
  802f8e:	89 c5                	mov    %eax,%ebp
  802f90:	31 d2                	xor    %edx,%edx
  802f92:	89 c8                	mov    %ecx,%eax
  802f94:	f7 f5                	div    %ebp
  802f96:	89 c1                	mov    %eax,%ecx
  802f98:	89 d8                	mov    %ebx,%eax
  802f9a:	f7 f5                	div    %ebp
  802f9c:	89 cf                	mov    %ecx,%edi
  802f9e:	89 fa                	mov    %edi,%edx
  802fa0:	83 c4 1c             	add    $0x1c,%esp
  802fa3:	5b                   	pop    %ebx
  802fa4:	5e                   	pop    %esi
  802fa5:	5f                   	pop    %edi
  802fa6:	5d                   	pop    %ebp
  802fa7:	c3                   	ret    
  802fa8:	39 ce                	cmp    %ecx,%esi
  802faa:	77 28                	ja     802fd4 <__udivdi3+0x7c>
  802fac:	0f bd fe             	bsr    %esi,%edi
  802faf:	83 f7 1f             	xor    $0x1f,%edi
  802fb2:	75 40                	jne    802ff4 <__udivdi3+0x9c>
  802fb4:	39 ce                	cmp    %ecx,%esi
  802fb6:	72 0a                	jb     802fc2 <__udivdi3+0x6a>
  802fb8:	3b 44 24 08          	cmp    0x8(%esp),%eax
  802fbc:	0f 87 9e 00 00 00    	ja     803060 <__udivdi3+0x108>
  802fc2:	b8 01 00 00 00       	mov    $0x1,%eax
  802fc7:	89 fa                	mov    %edi,%edx
  802fc9:	83 c4 1c             	add    $0x1c,%esp
  802fcc:	5b                   	pop    %ebx
  802fcd:	5e                   	pop    %esi
  802fce:	5f                   	pop    %edi
  802fcf:	5d                   	pop    %ebp
  802fd0:	c3                   	ret    
  802fd1:	8d 76 00             	lea    0x0(%esi),%esi
  802fd4:	31 ff                	xor    %edi,%edi
  802fd6:	31 c0                	xor    %eax,%eax
  802fd8:	89 fa                	mov    %edi,%edx
  802fda:	83 c4 1c             	add    $0x1c,%esp
  802fdd:	5b                   	pop    %ebx
  802fde:	5e                   	pop    %esi
  802fdf:	5f                   	pop    %edi
  802fe0:	5d                   	pop    %ebp
  802fe1:	c3                   	ret    
  802fe2:	66 90                	xchg   %ax,%ax
  802fe4:	89 d8                	mov    %ebx,%eax
  802fe6:	f7 f7                	div    %edi
  802fe8:	31 ff                	xor    %edi,%edi
  802fea:	89 fa                	mov    %edi,%edx
  802fec:	83 c4 1c             	add    $0x1c,%esp
  802fef:	5b                   	pop    %ebx
  802ff0:	5e                   	pop    %esi
  802ff1:	5f                   	pop    %edi
  802ff2:	5d                   	pop    %ebp
  802ff3:	c3                   	ret    
  802ff4:	bd 20 00 00 00       	mov    $0x20,%ebp
  802ff9:	89 eb                	mov    %ebp,%ebx
  802ffb:	29 fb                	sub    %edi,%ebx
  802ffd:	89 f9                	mov    %edi,%ecx
  802fff:	d3 e6                	shl    %cl,%esi
  803001:	89 c5                	mov    %eax,%ebp
  803003:	88 d9                	mov    %bl,%cl
  803005:	d3 ed                	shr    %cl,%ebp
  803007:	89 e9                	mov    %ebp,%ecx
  803009:	09 f1                	or     %esi,%ecx
  80300b:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  80300f:	89 f9                	mov    %edi,%ecx
  803011:	d3 e0                	shl    %cl,%eax
  803013:	89 c5                	mov    %eax,%ebp
  803015:	89 d6                	mov    %edx,%esi
  803017:	88 d9                	mov    %bl,%cl
  803019:	d3 ee                	shr    %cl,%esi
  80301b:	89 f9                	mov    %edi,%ecx
  80301d:	d3 e2                	shl    %cl,%edx
  80301f:	8b 44 24 08          	mov    0x8(%esp),%eax
  803023:	88 d9                	mov    %bl,%cl
  803025:	d3 e8                	shr    %cl,%eax
  803027:	09 c2                	or     %eax,%edx
  803029:	89 d0                	mov    %edx,%eax
  80302b:	89 f2                	mov    %esi,%edx
  80302d:	f7 74 24 0c          	divl   0xc(%esp)
  803031:	89 d6                	mov    %edx,%esi
  803033:	89 c3                	mov    %eax,%ebx
  803035:	f7 e5                	mul    %ebp
  803037:	39 d6                	cmp    %edx,%esi
  803039:	72 19                	jb     803054 <__udivdi3+0xfc>
  80303b:	74 0b                	je     803048 <__udivdi3+0xf0>
  80303d:	89 d8                	mov    %ebx,%eax
  80303f:	31 ff                	xor    %edi,%edi
  803041:	e9 58 ff ff ff       	jmp    802f9e <__udivdi3+0x46>
  803046:	66 90                	xchg   %ax,%ax
  803048:	8b 54 24 08          	mov    0x8(%esp),%edx
  80304c:	89 f9                	mov    %edi,%ecx
  80304e:	d3 e2                	shl    %cl,%edx
  803050:	39 c2                	cmp    %eax,%edx
  803052:	73 e9                	jae    80303d <__udivdi3+0xe5>
  803054:	8d 43 ff             	lea    -0x1(%ebx),%eax
  803057:	31 ff                	xor    %edi,%edi
  803059:	e9 40 ff ff ff       	jmp    802f9e <__udivdi3+0x46>
  80305e:	66 90                	xchg   %ax,%ax
  803060:	31 c0                	xor    %eax,%eax
  803062:	e9 37 ff ff ff       	jmp    802f9e <__udivdi3+0x46>
  803067:	90                   	nop

00803068 <__umoddi3>:
  803068:	55                   	push   %ebp
  803069:	57                   	push   %edi
  80306a:	56                   	push   %esi
  80306b:	53                   	push   %ebx
  80306c:	83 ec 1c             	sub    $0x1c,%esp
  80306f:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  803073:	8b 74 24 34          	mov    0x34(%esp),%esi
  803077:	8b 7c 24 38          	mov    0x38(%esp),%edi
  80307b:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  80307f:	89 44 24 0c          	mov    %eax,0xc(%esp)
  803083:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  803087:	89 f3                	mov    %esi,%ebx
  803089:	89 fa                	mov    %edi,%edx
  80308b:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  80308f:	89 34 24             	mov    %esi,(%esp)
  803092:	85 c0                	test   %eax,%eax
  803094:	75 1a                	jne    8030b0 <__umoddi3+0x48>
  803096:	39 f7                	cmp    %esi,%edi
  803098:	0f 86 a2 00 00 00    	jbe    803140 <__umoddi3+0xd8>
  80309e:	89 c8                	mov    %ecx,%eax
  8030a0:	89 f2                	mov    %esi,%edx
  8030a2:	f7 f7                	div    %edi
  8030a4:	89 d0                	mov    %edx,%eax
  8030a6:	31 d2                	xor    %edx,%edx
  8030a8:	83 c4 1c             	add    $0x1c,%esp
  8030ab:	5b                   	pop    %ebx
  8030ac:	5e                   	pop    %esi
  8030ad:	5f                   	pop    %edi
  8030ae:	5d                   	pop    %ebp
  8030af:	c3                   	ret    
  8030b0:	39 f0                	cmp    %esi,%eax
  8030b2:	0f 87 ac 00 00 00    	ja     803164 <__umoddi3+0xfc>
  8030b8:	0f bd e8             	bsr    %eax,%ebp
  8030bb:	83 f5 1f             	xor    $0x1f,%ebp
  8030be:	0f 84 ac 00 00 00    	je     803170 <__umoddi3+0x108>
  8030c4:	bf 20 00 00 00       	mov    $0x20,%edi
  8030c9:	29 ef                	sub    %ebp,%edi
  8030cb:	89 fe                	mov    %edi,%esi
  8030cd:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  8030d1:	89 e9                	mov    %ebp,%ecx
  8030d3:	d3 e0                	shl    %cl,%eax
  8030d5:	89 d7                	mov    %edx,%edi
  8030d7:	89 f1                	mov    %esi,%ecx
  8030d9:	d3 ef                	shr    %cl,%edi
  8030db:	09 c7                	or     %eax,%edi
  8030dd:	89 e9                	mov    %ebp,%ecx
  8030df:	d3 e2                	shl    %cl,%edx
  8030e1:	89 14 24             	mov    %edx,(%esp)
  8030e4:	89 d8                	mov    %ebx,%eax
  8030e6:	d3 e0                	shl    %cl,%eax
  8030e8:	89 c2                	mov    %eax,%edx
  8030ea:	8b 44 24 08          	mov    0x8(%esp),%eax
  8030ee:	d3 e0                	shl    %cl,%eax
  8030f0:	89 44 24 04          	mov    %eax,0x4(%esp)
  8030f4:	8b 44 24 08          	mov    0x8(%esp),%eax
  8030f8:	89 f1                	mov    %esi,%ecx
  8030fa:	d3 e8                	shr    %cl,%eax
  8030fc:	09 d0                	or     %edx,%eax
  8030fe:	d3 eb                	shr    %cl,%ebx
  803100:	89 da                	mov    %ebx,%edx
  803102:	f7 f7                	div    %edi
  803104:	89 d3                	mov    %edx,%ebx
  803106:	f7 24 24             	mull   (%esp)
  803109:	89 c6                	mov    %eax,%esi
  80310b:	89 d1                	mov    %edx,%ecx
  80310d:	39 d3                	cmp    %edx,%ebx
  80310f:	0f 82 87 00 00 00    	jb     80319c <__umoddi3+0x134>
  803115:	0f 84 91 00 00 00    	je     8031ac <__umoddi3+0x144>
  80311b:	8b 54 24 04          	mov    0x4(%esp),%edx
  80311f:	29 f2                	sub    %esi,%edx
  803121:	19 cb                	sbb    %ecx,%ebx
  803123:	89 d8                	mov    %ebx,%eax
  803125:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  803129:	d3 e0                	shl    %cl,%eax
  80312b:	89 e9                	mov    %ebp,%ecx
  80312d:	d3 ea                	shr    %cl,%edx
  80312f:	09 d0                	or     %edx,%eax
  803131:	89 e9                	mov    %ebp,%ecx
  803133:	d3 eb                	shr    %cl,%ebx
  803135:	89 da                	mov    %ebx,%edx
  803137:	83 c4 1c             	add    $0x1c,%esp
  80313a:	5b                   	pop    %ebx
  80313b:	5e                   	pop    %esi
  80313c:	5f                   	pop    %edi
  80313d:	5d                   	pop    %ebp
  80313e:	c3                   	ret    
  80313f:	90                   	nop
  803140:	89 fd                	mov    %edi,%ebp
  803142:	85 ff                	test   %edi,%edi
  803144:	75 0b                	jne    803151 <__umoddi3+0xe9>
  803146:	b8 01 00 00 00       	mov    $0x1,%eax
  80314b:	31 d2                	xor    %edx,%edx
  80314d:	f7 f7                	div    %edi
  80314f:	89 c5                	mov    %eax,%ebp
  803151:	89 f0                	mov    %esi,%eax
  803153:	31 d2                	xor    %edx,%edx
  803155:	f7 f5                	div    %ebp
  803157:	89 c8                	mov    %ecx,%eax
  803159:	f7 f5                	div    %ebp
  80315b:	89 d0                	mov    %edx,%eax
  80315d:	e9 44 ff ff ff       	jmp    8030a6 <__umoddi3+0x3e>
  803162:	66 90                	xchg   %ax,%ax
  803164:	89 c8                	mov    %ecx,%eax
  803166:	89 f2                	mov    %esi,%edx
  803168:	83 c4 1c             	add    $0x1c,%esp
  80316b:	5b                   	pop    %ebx
  80316c:	5e                   	pop    %esi
  80316d:	5f                   	pop    %edi
  80316e:	5d                   	pop    %ebp
  80316f:	c3                   	ret    
  803170:	3b 04 24             	cmp    (%esp),%eax
  803173:	72 06                	jb     80317b <__umoddi3+0x113>
  803175:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  803179:	77 0f                	ja     80318a <__umoddi3+0x122>
  80317b:	89 f2                	mov    %esi,%edx
  80317d:	29 f9                	sub    %edi,%ecx
  80317f:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  803183:	89 14 24             	mov    %edx,(%esp)
  803186:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  80318a:	8b 44 24 04          	mov    0x4(%esp),%eax
  80318e:	8b 14 24             	mov    (%esp),%edx
  803191:	83 c4 1c             	add    $0x1c,%esp
  803194:	5b                   	pop    %ebx
  803195:	5e                   	pop    %esi
  803196:	5f                   	pop    %edi
  803197:	5d                   	pop    %ebp
  803198:	c3                   	ret    
  803199:	8d 76 00             	lea    0x0(%esi),%esi
  80319c:	2b 04 24             	sub    (%esp),%eax
  80319f:	19 fa                	sbb    %edi,%edx
  8031a1:	89 d1                	mov    %edx,%ecx
  8031a3:	89 c6                	mov    %eax,%esi
  8031a5:	e9 71 ff ff ff       	jmp    80311b <__umoddi3+0xb3>
  8031aa:	66 90                	xchg   %ax,%ax
  8031ac:	39 44 24 04          	cmp    %eax,0x4(%esp)
  8031b0:	72 ea                	jb     80319c <__umoddi3+0x134>
  8031b2:	89 d9                	mov    %ebx,%ecx
  8031b4:	e9 62 ff ff ff       	jmp    80311b <__umoddi3+0xb3>
