
obj/user/tst_buffer_3:     file format elf32-i386


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
  800031:	e8 82 02 00 00       	call   8002b8 <libmain>
1:      jmp 1b
  800036:	eb fe                	jmp    800036 <args_exist+0x5>

00800038 <_main>:
/* *********************************************************** */

#include <inc/lib.h>

void _main(void)
{
  800038:	55                   	push   %ebp
  800039:	89 e5                	mov    %esp,%ebp
  80003b:	53                   	push   %ebx
  80003c:	83 ec 44             	sub    $0x44,%esp
//		if( ROUNDDOWN(myEnv->__uptr_pws[9].virtual_address,PAGE_SIZE) !=   0x803000)  panic("INITIAL PAGE WS entry checking failed! Review size of the WS..!!");
//		if( ROUNDDOWN(myEnv->__uptr_pws[10].virtual_address,PAGE_SIZE) !=   0x804000)  panic("INITIAL PAGE WS entry checking failed! Review size of the WS..!!");
//		if( ROUNDDOWN(myEnv->__uptr_pws[11].virtual_address,PAGE_SIZE) !=   0xeebfd000)  panic("INITIAL PAGE WS entry checking failed! Review size of the WS..!!");
//		if( myEnv->page_last_WS_index !=  0)  										panic("INITIAL PAGE WS last index checking failed! Review size of the WS..!!");
	}
	int kilo = 1024;
  80003f:	c7 45 ec 00 04 00 00 	movl   $0x400,-0x14(%ebp)
	int Mega = 1024*1024;
  800046:	c7 45 e8 00 00 10 00 	movl   $0x100000,-0x18(%ebp)

	{
		int freeFrames = sys_calculate_free_frames() ;
  80004d:	e8 f4 19 00 00       	call   801a46 <sys_calculate_free_frames>
  800052:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		int origFreeFrames = freeFrames ;
  800055:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800058:	89 45 e0             	mov    %eax,-0x20(%ebp)

		uint32 size = 10*Mega;
  80005b:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80005e:	89 d0                	mov    %edx,%eax
  800060:	c1 e0 02             	shl    $0x2,%eax
  800063:	01 d0                	add    %edx,%eax
  800065:	01 c0                	add    %eax,%eax
  800067:	89 45 dc             	mov    %eax,-0x24(%ebp)
		unsigned char *x = malloc(sizeof(unsigned char)*size) ;
  80006a:	83 ec 0c             	sub    $0xc,%esp
  80006d:	ff 75 dc             	pushl  -0x24(%ebp)
  800070:	e8 c5 15 00 00       	call   80163a <malloc>
  800075:	83 c4 10             	add    $0x10,%esp
  800078:	89 45 d8             	mov    %eax,-0x28(%ebp)
		freeFrames = sys_calculate_free_frames() ;
  80007b:	e8 c6 19 00 00       	call   801a46 <sys_calculate_free_frames>
  800080:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		int modFrames = sys_calculate_modified_frames();
  800083:	e8 d7 19 00 00       	call   801a5f <sys_calculate_modified_frames>
  800088:	89 45 d4             	mov    %eax,-0x2c(%ebp)

		cprintf("all frames AFTER malloc = %d\n", freeFrames + modFrames);
  80008b:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80008e:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  800091:	01 d0                	add    %edx,%eax
  800093:	83 ec 08             	sub    $0x8,%esp
  800096:	50                   	push   %eax
  800097:	68 40 32 80 00       	push   $0x803240
  80009c:	e8 07 06 00 00       	call   8006a8 <cprintf>
  8000a1:	83 c4 10             	add    $0x10,%esp
		x[1]=-1;
  8000a4:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8000a7:	40                   	inc    %eax
  8000a8:	c6 00 ff             	movb   $0xff,(%eax)

		x[1*Mega] = -1;
  8000ab:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8000ae:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8000b1:	01 d0                	add    %edx,%eax
  8000b3:	c6 00 ff             	movb   $0xff,(%eax)

		int i = x[2*Mega];
  8000b6:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8000b9:	01 c0                	add    %eax,%eax
  8000bb:	89 c2                	mov    %eax,%edx
  8000bd:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8000c0:	01 d0                	add    %edx,%eax
  8000c2:	8a 00                	mov    (%eax),%al
  8000c4:	0f b6 c0             	movzbl %al,%eax
  8000c7:	89 45 f4             	mov    %eax,-0xc(%ebp)

		int j = x[3*Mega];
  8000ca:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8000cd:	89 c2                	mov    %eax,%edx
  8000cf:	01 d2                	add    %edx,%edx
  8000d1:	01 d0                	add    %edx,%eax
  8000d3:	89 c2                	mov    %eax,%edx
  8000d5:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8000d8:	01 d0                	add    %edx,%eax
  8000da:	8a 00                	mov    (%eax),%al
  8000dc:	0f b6 c0             	movzbl %al,%eax
  8000df:	89 45 d0             	mov    %eax,-0x30(%ebp)

		x[4*Mega] = -1;
  8000e2:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8000e5:	c1 e0 02             	shl    $0x2,%eax
  8000e8:	89 c2                	mov    %eax,%edx
  8000ea:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8000ed:	01 d0                	add    %edx,%eax
  8000ef:	c6 00 ff             	movb   $0xff,(%eax)

		x[5*Mega] = -1;
  8000f2:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8000f5:	89 d0                	mov    %edx,%eax
  8000f7:	c1 e0 02             	shl    $0x2,%eax
  8000fa:	01 d0                	add    %edx,%eax
  8000fc:	89 c2                	mov    %eax,%edx
  8000fe:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800101:	01 d0                	add    %edx,%eax
  800103:	c6 00 ff             	movb   $0xff,(%eax)

		x[6*Mega] = -1;
  800106:	8b 55 e8             	mov    -0x18(%ebp),%edx
  800109:	89 d0                	mov    %edx,%eax
  80010b:	01 c0                	add    %eax,%eax
  80010d:	01 d0                	add    %edx,%eax
  80010f:	01 c0                	add    %eax,%eax
  800111:	89 c2                	mov    %eax,%edx
  800113:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800116:	01 d0                	add    %edx,%eax
  800118:	c6 00 ff             	movb   $0xff,(%eax)

		x[7*Mega] = -1;
  80011b:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80011e:	89 d0                	mov    %edx,%eax
  800120:	01 c0                	add    %eax,%eax
  800122:	01 d0                	add    %edx,%eax
  800124:	01 c0                	add    %eax,%eax
  800126:	01 d0                	add    %edx,%eax
  800128:	89 c2                	mov    %eax,%edx
  80012a:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80012d:	01 d0                	add    %edx,%eax
  80012f:	c6 00 ff             	movb   $0xff,(%eax)

		x[8*Mega] = -1;
  800132:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800135:	c1 e0 03             	shl    $0x3,%eax
  800138:	89 c2                	mov    %eax,%edx
  80013a:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80013d:	01 d0                	add    %edx,%eax
  80013f:	c6 00 ff             	movb   $0xff,(%eax)

		x[9*Mega] = -1;
  800142:	8b 55 e8             	mov    -0x18(%ebp),%edx
  800145:	89 d0                	mov    %edx,%eax
  800147:	c1 e0 03             	shl    $0x3,%eax
  80014a:	01 d0                	add    %edx,%eax
  80014c:	89 c2                	mov    %eax,%edx
  80014e:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800151:	01 d0                	add    %edx,%eax
  800153:	c6 00 ff             	movb   $0xff,(%eax)

		free(x);
  800156:	83 ec 0c             	sub    $0xc,%esp
  800159:	ff 75 d8             	pushl  -0x28(%ebp)
  80015c:	e8 5a 15 00 00       	call   8016bb <free>
  800161:	83 c4 10             	add    $0x10,%esp

		int numOFEmptyLocInWS = 0;
  800164:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
		for (i = 0 ; i < (myEnv->page_WS_max_size); i++)
  80016b:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  800172:	eb 79                	jmp    8001ed <_main+0x1b5>
		{
			if (myEnv->__uptr_pws[i].empty)
  800174:	a1 20 40 80 00       	mov    0x804020,%eax
  800179:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  80017f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800182:	89 d0                	mov    %edx,%eax
  800184:	01 c0                	add    %eax,%eax
  800186:	01 d0                	add    %edx,%eax
  800188:	c1 e0 03             	shl    $0x3,%eax
  80018b:	01 c8                	add    %ecx,%eax
  80018d:	8a 40 04             	mov    0x4(%eax),%al
  800190:	84 c0                	test   %al,%al
  800192:	74 05                	je     800199 <_main+0x161>
			{
				numOFEmptyLocInWS++;
  800194:	ff 45 f0             	incl   -0x10(%ebp)
  800197:	eb 51                	jmp    8001ea <_main+0x1b2>
			}
			else
			{
				uint32 va = ROUNDDOWN(myEnv->__uptr_pws[i].virtual_address,PAGE_SIZE) ;
  800199:	a1 20 40 80 00       	mov    0x804020,%eax
  80019e:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  8001a4:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8001a7:	89 d0                	mov    %edx,%eax
  8001a9:	01 c0                	add    %eax,%eax
  8001ab:	01 d0                	add    %edx,%eax
  8001ad:	c1 e0 03             	shl    $0x3,%eax
  8001b0:	01 c8                	add    %ecx,%eax
  8001b2:	8b 00                	mov    (%eax),%eax
  8001b4:	89 45 cc             	mov    %eax,-0x34(%ebp)
  8001b7:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8001ba:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8001bf:	89 45 c8             	mov    %eax,-0x38(%ebp)
				if (va >= USER_HEAP_START && va < (USER_HEAP_START + size))
  8001c2:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8001c5:	85 c0                	test   %eax,%eax
  8001c7:	79 21                	jns    8001ea <_main+0x1b2>
  8001c9:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8001cc:	05 00 00 00 80       	add    $0x80000000,%eax
  8001d1:	3b 45 c8             	cmp    -0x38(%ebp),%eax
  8001d4:	76 14                	jbe    8001ea <_main+0x1b2>
					panic("freeMem didn't remove its page(s) from the WS");
  8001d6:	83 ec 04             	sub    $0x4,%esp
  8001d9:	68 60 32 80 00       	push   $0x803260
  8001de:	6a 4e                	push   $0x4e
  8001e0:	68 8e 32 80 00       	push   $0x80328e
  8001e5:	e8 0a 02 00 00       	call   8003f4 <_panic>
		x[9*Mega] = -1;

		free(x);

		int numOFEmptyLocInWS = 0;
		for (i = 0 ; i < (myEnv->page_WS_max_size); i++)
  8001ea:	ff 45 f4             	incl   -0xc(%ebp)
  8001ed:	a1 20 40 80 00       	mov    0x804020,%eax
  8001f2:	8b 50 74             	mov    0x74(%eax),%edx
  8001f5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8001f8:	39 c2                	cmp    %eax,%edx
  8001fa:	0f 87 74 ff ff ff    	ja     800174 <_main+0x13c>
				uint32 va = ROUNDDOWN(myEnv->__uptr_pws[i].virtual_address,PAGE_SIZE) ;
				if (va >= USER_HEAP_START && va < (USER_HEAP_START + size))
					panic("freeMem didn't remove its page(s) from the WS");
			}
		}
		int free_frames = sys_calculate_free_frames();
  800200:	e8 41 18 00 00       	call   801a46 <sys_calculate_free_frames>
  800205:	89 45 c4             	mov    %eax,-0x3c(%ebp)
		int mod_frames = sys_calculate_modified_frames();
  800208:	e8 52 18 00 00       	call   801a5f <sys_calculate_modified_frames>
  80020d:	89 45 c0             	mov    %eax,-0x40(%ebp)
		if ((sys_calculate_modified_frames() + sys_calculate_free_frames() - numOFEmptyLocInWS) - (modFrames + freeFrames) != 0 ) panic("FreeMem didn't remove all modified frames in the given range from the modified list");
  800210:	e8 4a 18 00 00       	call   801a5f <sys_calculate_modified_frames>
  800215:	89 c3                	mov    %eax,%ebx
  800217:	e8 2a 18 00 00       	call   801a46 <sys_calculate_free_frames>
  80021c:	8d 14 03             	lea    (%ebx,%eax,1),%edx
  80021f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800222:	89 d1                	mov    %edx,%ecx
  800224:	29 c1                	sub    %eax,%ecx
  800226:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  800229:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80022c:	01 d0                	add    %edx,%eax
  80022e:	39 c1                	cmp    %eax,%ecx
  800230:	74 14                	je     800246 <_main+0x20e>
  800232:	83 ec 04             	sub    $0x4,%esp
  800235:	68 a4 32 80 00       	push   $0x8032a4
  80023a:	6a 53                	push   $0x53
  80023c:	68 8e 32 80 00       	push   $0x80328e
  800241:	e8 ae 01 00 00       	call   8003f4 <_panic>
		//if (sys_calculate_modified_frames() != 0 ) panic("FreeMem didn't remove all modified frames in the given range from the modified list");
		//if (sys_calculate_notmod_frames() != 7) panic("FreeMem didn't remove all un-modified frames in the given range from the free frame list");

		//if (sys_calculate_free_frames() - freeFrames != 3) panic("FreeMem didn't UN-BUFFER the removed BUFFERED frames in the given range.. (check updating of isBuffered");

		cprintf("Congratulations!! test of removing BUFFERED pages in freeHeap is completed successfully.\n");
  800246:	83 ec 0c             	sub    $0xc,%esp
  800249:	68 f8 32 80 00       	push   $0x8032f8
  80024e:	e8 55 04 00 00       	call   8006a8 <cprintf>
  800253:	83 c4 10             	add    $0x10,%esp

		//Try to access any of the removed buffered pages in the Heap [It's ILLEGAL ACCESS now]
		{
			cprintf("\nNow, trying to access the removed BUFFERED pages, you should make the kernel PANIC with ILLEGAL MEMORY ACCESS in page_fault_handler() since we have illegal access to page that is NOT EXIST in PF and NOT BELONGS to STACK.\n\n\n");
  800256:	83 ec 0c             	sub    $0xc,%esp
  800259:	68 54 33 80 00       	push   $0x803354
  80025e:	e8 45 04 00 00       	call   8006a8 <cprintf>
  800263:	83 c4 10             	add    $0x10,%esp

			x[1]=-1;
  800266:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800269:	40                   	inc    %eax
  80026a:	c6 00 ff             	movb   $0xff,(%eax)

			x[1*Mega] = -1;
  80026d:	8b 55 e8             	mov    -0x18(%ebp),%edx
  800270:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800273:	01 d0                	add    %edx,%eax
  800275:	c6 00 ff             	movb   $0xff,(%eax)

			int i = x[2*Mega];
  800278:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80027b:	01 c0                	add    %eax,%eax
  80027d:	89 c2                	mov    %eax,%edx
  80027f:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800282:	01 d0                	add    %edx,%eax
  800284:	8a 00                	mov    (%eax),%al
  800286:	0f b6 c0             	movzbl %al,%eax
  800289:	89 45 bc             	mov    %eax,-0x44(%ebp)

			int j = x[3*Mega];
  80028c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80028f:	89 c2                	mov    %eax,%edx
  800291:	01 d2                	add    %edx,%edx
  800293:	01 d0                	add    %edx,%eax
  800295:	89 c2                	mov    %eax,%edx
  800297:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80029a:	01 d0                	add    %edx,%eax
  80029c:	8a 00                	mov    (%eax),%al
  80029e:	0f b6 c0             	movzbl %al,%eax
  8002a1:	89 45 b8             	mov    %eax,-0x48(%ebp)
		}
		panic("ERROR: FOS SHOULD NOT panic here, it should panic earlier in page_fault_handler(), since we have illegal access to page that is NOT EXIST in PF and NOT BELONGS to STACK. REMEMBER: creating new page in page file shouldn't be allowed except ONLY for stack pages\n");
  8002a4:	83 ec 04             	sub    $0x4,%esp
  8002a7:	68 38 34 80 00       	push   $0x803438
  8002ac:	6a 68                	push   $0x68
  8002ae:	68 8e 32 80 00       	push   $0x80328e
  8002b3:	e8 3c 01 00 00       	call   8003f4 <_panic>

008002b8 <libmain>:
volatile struct Env *myEnv = NULL;
volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";

void
libmain(int argc, char **argv)
{
  8002b8:	55                   	push   %ebp
  8002b9:	89 e5                	mov    %esp,%ebp
  8002bb:	83 ec 18             	sub    $0x18,%esp
	int envIndex = sys_getenvindex();
  8002be:	e8 63 1a 00 00       	call   801d26 <sys_getenvindex>
  8002c3:	89 45 f4             	mov    %eax,-0xc(%ebp)
	myEnv = &(envs[envIndex]);
  8002c6:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8002c9:	89 d0                	mov    %edx,%eax
  8002cb:	c1 e0 03             	shl    $0x3,%eax
  8002ce:	01 d0                	add    %edx,%eax
  8002d0:	01 c0                	add    %eax,%eax
  8002d2:	01 d0                	add    %edx,%eax
  8002d4:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8002db:	01 d0                	add    %edx,%eax
  8002dd:	c1 e0 04             	shl    $0x4,%eax
  8002e0:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  8002e5:	a3 20 40 80 00       	mov    %eax,0x804020

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  8002ea:	a1 20 40 80 00       	mov    0x804020,%eax
  8002ef:	8a 80 5c 05 00 00    	mov    0x55c(%eax),%al
  8002f5:	84 c0                	test   %al,%al
  8002f7:	74 0f                	je     800308 <libmain+0x50>
		binaryname = myEnv->prog_name;
  8002f9:	a1 20 40 80 00       	mov    0x804020,%eax
  8002fe:	05 5c 05 00 00       	add    $0x55c,%eax
  800303:	a3 00 40 80 00       	mov    %eax,0x804000

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  800308:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80030c:	7e 0a                	jle    800318 <libmain+0x60>
		binaryname = argv[0];
  80030e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800311:	8b 00                	mov    (%eax),%eax
  800313:	a3 00 40 80 00       	mov    %eax,0x804000

	// call user main routine
	_main(argc, argv);
  800318:	83 ec 08             	sub    $0x8,%esp
  80031b:	ff 75 0c             	pushl  0xc(%ebp)
  80031e:	ff 75 08             	pushl  0x8(%ebp)
  800321:	e8 12 fd ff ff       	call   800038 <_main>
  800326:	83 c4 10             	add    $0x10,%esp



	sys_disable_interrupt();
  800329:	e8 05 18 00 00       	call   801b33 <sys_disable_interrupt>
	cprintf("**************************************\n");
  80032e:	83 ec 0c             	sub    $0xc,%esp
  800331:	68 58 35 80 00       	push   $0x803558
  800336:	e8 6d 03 00 00       	call   8006a8 <cprintf>
  80033b:	83 c4 10             	add    $0x10,%esp
	cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  80033e:	a1 20 40 80 00       	mov    0x804020,%eax
  800343:	8b 90 44 05 00 00    	mov    0x544(%eax),%edx
  800349:	a1 20 40 80 00       	mov    0x804020,%eax
  80034e:	8b 80 34 05 00 00    	mov    0x534(%eax),%eax
  800354:	83 ec 04             	sub    $0x4,%esp
  800357:	52                   	push   %edx
  800358:	50                   	push   %eax
  800359:	68 80 35 80 00       	push   $0x803580
  80035e:	e8 45 03 00 00       	call   8006a8 <cprintf>
  800363:	83 c4 10             	add    $0x10,%esp
	cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  800366:	a1 20 40 80 00       	mov    0x804020,%eax
  80036b:	8b 88 54 05 00 00    	mov    0x554(%eax),%ecx
  800371:	a1 20 40 80 00       	mov    0x804020,%eax
  800376:	8b 90 50 05 00 00    	mov    0x550(%eax),%edx
  80037c:	a1 20 40 80 00       	mov    0x804020,%eax
  800381:	8b 80 4c 05 00 00    	mov    0x54c(%eax),%eax
  800387:	51                   	push   %ecx
  800388:	52                   	push   %edx
  800389:	50                   	push   %eax
  80038a:	68 a8 35 80 00       	push   $0x8035a8
  80038f:	e8 14 03 00 00       	call   8006a8 <cprintf>
  800394:	83 c4 10             	add    $0x10,%esp
	//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
	cprintf("Num of clocks = %d\n", myEnv->nClocks);
  800397:	a1 20 40 80 00       	mov    0x804020,%eax
  80039c:	8b 80 a4 05 00 00    	mov    0x5a4(%eax),%eax
  8003a2:	83 ec 08             	sub    $0x8,%esp
  8003a5:	50                   	push   %eax
  8003a6:	68 00 36 80 00       	push   $0x803600
  8003ab:	e8 f8 02 00 00       	call   8006a8 <cprintf>
  8003b0:	83 c4 10             	add    $0x10,%esp
	cprintf("**************************************\n");
  8003b3:	83 ec 0c             	sub    $0xc,%esp
  8003b6:	68 58 35 80 00       	push   $0x803558
  8003bb:	e8 e8 02 00 00       	call   8006a8 <cprintf>
  8003c0:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  8003c3:	e8 85 17 00 00       	call   801b4d <sys_enable_interrupt>

	// exit gracefully
	exit();
  8003c8:	e8 19 00 00 00       	call   8003e6 <exit>
}
  8003cd:	90                   	nop
  8003ce:	c9                   	leave  
  8003cf:	c3                   	ret    

008003d0 <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  8003d0:	55                   	push   %ebp
  8003d1:	89 e5                	mov    %esp,%ebp
  8003d3:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  8003d6:	83 ec 0c             	sub    $0xc,%esp
  8003d9:	6a 00                	push   $0x0
  8003db:	e8 12 19 00 00       	call   801cf2 <sys_destroy_env>
  8003e0:	83 c4 10             	add    $0x10,%esp
}
  8003e3:	90                   	nop
  8003e4:	c9                   	leave  
  8003e5:	c3                   	ret    

008003e6 <exit>:

void
exit(void)
{
  8003e6:	55                   	push   %ebp
  8003e7:	89 e5                	mov    %esp,%ebp
  8003e9:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  8003ec:	e8 67 19 00 00       	call   801d58 <sys_exit_env>
}
  8003f1:	90                   	nop
  8003f2:	c9                   	leave  
  8003f3:	c3                   	ret    

008003f4 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  8003f4:	55                   	push   %ebp
  8003f5:	89 e5                	mov    %esp,%ebp
  8003f7:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  8003fa:	8d 45 10             	lea    0x10(%ebp),%eax
  8003fd:	83 c0 04             	add    $0x4,%eax
  800400:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  800403:	a1 5c 41 80 00       	mov    0x80415c,%eax
  800408:	85 c0                	test   %eax,%eax
  80040a:	74 16                	je     800422 <_panic+0x2e>
		cprintf("%s: ", argv0);
  80040c:	a1 5c 41 80 00       	mov    0x80415c,%eax
  800411:	83 ec 08             	sub    $0x8,%esp
  800414:	50                   	push   %eax
  800415:	68 14 36 80 00       	push   $0x803614
  80041a:	e8 89 02 00 00       	call   8006a8 <cprintf>
  80041f:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  800422:	a1 00 40 80 00       	mov    0x804000,%eax
  800427:	ff 75 0c             	pushl  0xc(%ebp)
  80042a:	ff 75 08             	pushl  0x8(%ebp)
  80042d:	50                   	push   %eax
  80042e:	68 19 36 80 00       	push   $0x803619
  800433:	e8 70 02 00 00       	call   8006a8 <cprintf>
  800438:	83 c4 10             	add    $0x10,%esp
	vcprintf(fmt, ap);
  80043b:	8b 45 10             	mov    0x10(%ebp),%eax
  80043e:	83 ec 08             	sub    $0x8,%esp
  800441:	ff 75 f4             	pushl  -0xc(%ebp)
  800444:	50                   	push   %eax
  800445:	e8 f3 01 00 00       	call   80063d <vcprintf>
  80044a:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  80044d:	83 ec 08             	sub    $0x8,%esp
  800450:	6a 00                	push   $0x0
  800452:	68 35 36 80 00       	push   $0x803635
  800457:	e8 e1 01 00 00       	call   80063d <vcprintf>
  80045c:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  80045f:	e8 82 ff ff ff       	call   8003e6 <exit>

	// should not return here
	while (1) ;
  800464:	eb fe                	jmp    800464 <_panic+0x70>

00800466 <CheckWSWithoutLastIndex>:
}

void CheckWSWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  800466:	55                   	push   %ebp
  800467:	89 e5                	mov    %esp,%ebp
  800469:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  80046c:	a1 20 40 80 00       	mov    0x804020,%eax
  800471:	8b 50 74             	mov    0x74(%eax),%edx
  800474:	8b 45 0c             	mov    0xc(%ebp),%eax
  800477:	39 c2                	cmp    %eax,%edx
  800479:	74 14                	je     80048f <CheckWSWithoutLastIndex+0x29>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  80047b:	83 ec 04             	sub    $0x4,%esp
  80047e:	68 38 36 80 00       	push   $0x803638
  800483:	6a 26                	push   $0x26
  800485:	68 84 36 80 00       	push   $0x803684
  80048a:	e8 65 ff ff ff       	call   8003f4 <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  80048f:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  800496:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  80049d:	e9 c2 00 00 00       	jmp    800564 <CheckWSWithoutLastIndex+0xfe>
		if (expectedPages[e] == 0) {
  8004a2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8004a5:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8004ac:	8b 45 08             	mov    0x8(%ebp),%eax
  8004af:	01 d0                	add    %edx,%eax
  8004b1:	8b 00                	mov    (%eax),%eax
  8004b3:	85 c0                	test   %eax,%eax
  8004b5:	75 08                	jne    8004bf <CheckWSWithoutLastIndex+0x59>
			expectedNumOfEmptyLocs++;
  8004b7:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  8004ba:	e9 a2 00 00 00       	jmp    800561 <CheckWSWithoutLastIndex+0xfb>
		}
		int found = 0;
  8004bf:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8004c6:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  8004cd:	eb 69                	jmp    800538 <CheckWSWithoutLastIndex+0xd2>
			if (myEnv->__uptr_pws[w].empty == 0) {
  8004cf:	a1 20 40 80 00       	mov    0x804020,%eax
  8004d4:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  8004da:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8004dd:	89 d0                	mov    %edx,%eax
  8004df:	01 c0                	add    %eax,%eax
  8004e1:	01 d0                	add    %edx,%eax
  8004e3:	c1 e0 03             	shl    $0x3,%eax
  8004e6:	01 c8                	add    %ecx,%eax
  8004e8:	8a 40 04             	mov    0x4(%eax),%al
  8004eb:	84 c0                	test   %al,%al
  8004ed:	75 46                	jne    800535 <CheckWSWithoutLastIndex+0xcf>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  8004ef:	a1 20 40 80 00       	mov    0x804020,%eax
  8004f4:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  8004fa:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8004fd:	89 d0                	mov    %edx,%eax
  8004ff:	01 c0                	add    %eax,%eax
  800501:	01 d0                	add    %edx,%eax
  800503:	c1 e0 03             	shl    $0x3,%eax
  800506:	01 c8                	add    %ecx,%eax
  800508:	8b 00                	mov    (%eax),%eax
  80050a:	89 45 dc             	mov    %eax,-0x24(%ebp)
  80050d:	8b 45 dc             	mov    -0x24(%ebp),%eax
  800510:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800515:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  800517:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80051a:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  800521:	8b 45 08             	mov    0x8(%ebp),%eax
  800524:	01 c8                	add    %ecx,%eax
  800526:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  800528:	39 c2                	cmp    %eax,%edx
  80052a:	75 09                	jne    800535 <CheckWSWithoutLastIndex+0xcf>
						== expectedPages[e]) {
					found = 1;
  80052c:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  800533:	eb 12                	jmp    800547 <CheckWSWithoutLastIndex+0xe1>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800535:	ff 45 e8             	incl   -0x18(%ebp)
  800538:	a1 20 40 80 00       	mov    0x804020,%eax
  80053d:	8b 50 74             	mov    0x74(%eax),%edx
  800540:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800543:	39 c2                	cmp    %eax,%edx
  800545:	77 88                	ja     8004cf <CheckWSWithoutLastIndex+0x69>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  800547:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  80054b:	75 14                	jne    800561 <CheckWSWithoutLastIndex+0xfb>
			panic(
  80054d:	83 ec 04             	sub    $0x4,%esp
  800550:	68 90 36 80 00       	push   $0x803690
  800555:	6a 3a                	push   $0x3a
  800557:	68 84 36 80 00       	push   $0x803684
  80055c:	e8 93 fe ff ff       	call   8003f4 <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  800561:	ff 45 f0             	incl   -0x10(%ebp)
  800564:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800567:	3b 45 0c             	cmp    0xc(%ebp),%eax
  80056a:	0f 8c 32 ff ff ff    	jl     8004a2 <CheckWSWithoutLastIndex+0x3c>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  800570:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800577:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  80057e:	eb 26                	jmp    8005a6 <CheckWSWithoutLastIndex+0x140>
		if (myEnv->__uptr_pws[w].empty == 1) {
  800580:	a1 20 40 80 00       	mov    0x804020,%eax
  800585:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  80058b:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80058e:	89 d0                	mov    %edx,%eax
  800590:	01 c0                	add    %eax,%eax
  800592:	01 d0                	add    %edx,%eax
  800594:	c1 e0 03             	shl    $0x3,%eax
  800597:	01 c8                	add    %ecx,%eax
  800599:	8a 40 04             	mov    0x4(%eax),%al
  80059c:	3c 01                	cmp    $0x1,%al
  80059e:	75 03                	jne    8005a3 <CheckWSWithoutLastIndex+0x13d>
			actualNumOfEmptyLocs++;
  8005a0:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8005a3:	ff 45 e0             	incl   -0x20(%ebp)
  8005a6:	a1 20 40 80 00       	mov    0x804020,%eax
  8005ab:	8b 50 74             	mov    0x74(%eax),%edx
  8005ae:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8005b1:	39 c2                	cmp    %eax,%edx
  8005b3:	77 cb                	ja     800580 <CheckWSWithoutLastIndex+0x11a>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  8005b5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8005b8:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  8005bb:	74 14                	je     8005d1 <CheckWSWithoutLastIndex+0x16b>
		panic(
  8005bd:	83 ec 04             	sub    $0x4,%esp
  8005c0:	68 e4 36 80 00       	push   $0x8036e4
  8005c5:	6a 44                	push   $0x44
  8005c7:	68 84 36 80 00       	push   $0x803684
  8005cc:	e8 23 fe ff ff       	call   8003f4 <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  8005d1:	90                   	nop
  8005d2:	c9                   	leave  
  8005d3:	c3                   	ret    

008005d4 <putch>:
};

//2017:
uint8 printProgName = 0;

static void putch(int ch, struct printbuf *b) {
  8005d4:	55                   	push   %ebp
  8005d5:	89 e5                	mov    %esp,%ebp
  8005d7:	83 ec 08             	sub    $0x8,%esp
	b->buf[b->idx++] = ch;
  8005da:	8b 45 0c             	mov    0xc(%ebp),%eax
  8005dd:	8b 00                	mov    (%eax),%eax
  8005df:	8d 48 01             	lea    0x1(%eax),%ecx
  8005e2:	8b 55 0c             	mov    0xc(%ebp),%edx
  8005e5:	89 0a                	mov    %ecx,(%edx)
  8005e7:	8b 55 08             	mov    0x8(%ebp),%edx
  8005ea:	88 d1                	mov    %dl,%cl
  8005ec:	8b 55 0c             	mov    0xc(%ebp),%edx
  8005ef:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  8005f3:	8b 45 0c             	mov    0xc(%ebp),%eax
  8005f6:	8b 00                	mov    (%eax),%eax
  8005f8:	3d ff 00 00 00       	cmp    $0xff,%eax
  8005fd:	75 2c                	jne    80062b <putch+0x57>
		sys_cputs(b->buf, b->idx, printProgName);
  8005ff:	a0 24 40 80 00       	mov    0x804024,%al
  800604:	0f b6 c0             	movzbl %al,%eax
  800607:	8b 55 0c             	mov    0xc(%ebp),%edx
  80060a:	8b 12                	mov    (%edx),%edx
  80060c:	89 d1                	mov    %edx,%ecx
  80060e:	8b 55 0c             	mov    0xc(%ebp),%edx
  800611:	83 c2 08             	add    $0x8,%edx
  800614:	83 ec 04             	sub    $0x4,%esp
  800617:	50                   	push   %eax
  800618:	51                   	push   %ecx
  800619:	52                   	push   %edx
  80061a:	e8 66 13 00 00       	call   801985 <sys_cputs>
  80061f:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  800622:	8b 45 0c             	mov    0xc(%ebp),%eax
  800625:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  80062b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80062e:	8b 40 04             	mov    0x4(%eax),%eax
  800631:	8d 50 01             	lea    0x1(%eax),%edx
  800634:	8b 45 0c             	mov    0xc(%ebp),%eax
  800637:	89 50 04             	mov    %edx,0x4(%eax)
}
  80063a:	90                   	nop
  80063b:	c9                   	leave  
  80063c:	c3                   	ret    

0080063d <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  80063d:	55                   	push   %ebp
  80063e:	89 e5                	mov    %esp,%ebp
  800640:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  800646:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  80064d:	00 00 00 
	b.cnt = 0;
  800650:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  800657:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  80065a:	ff 75 0c             	pushl  0xc(%ebp)
  80065d:	ff 75 08             	pushl  0x8(%ebp)
  800660:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800666:	50                   	push   %eax
  800667:	68 d4 05 80 00       	push   $0x8005d4
  80066c:	e8 11 02 00 00       	call   800882 <vprintfmt>
  800671:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName);
  800674:	a0 24 40 80 00       	mov    0x804024,%al
  800679:	0f b6 c0             	movzbl %al,%eax
  80067c:	8b 95 f0 fe ff ff    	mov    -0x110(%ebp),%edx
  800682:	83 ec 04             	sub    $0x4,%esp
  800685:	50                   	push   %eax
  800686:	52                   	push   %edx
  800687:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  80068d:	83 c0 08             	add    $0x8,%eax
  800690:	50                   	push   %eax
  800691:	e8 ef 12 00 00       	call   801985 <sys_cputs>
  800696:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  800699:	c6 05 24 40 80 00 00 	movb   $0x0,0x804024
	return b.cnt;
  8006a0:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  8006a6:	c9                   	leave  
  8006a7:	c3                   	ret    

008006a8 <cprintf>:

int cprintf(const char *fmt, ...) {
  8006a8:	55                   	push   %ebp
  8006a9:	89 e5                	mov    %esp,%ebp
  8006ab:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  8006ae:	c6 05 24 40 80 00 01 	movb   $0x1,0x804024
	va_start(ap, fmt);
  8006b5:	8d 45 0c             	lea    0xc(%ebp),%eax
  8006b8:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  8006bb:	8b 45 08             	mov    0x8(%ebp),%eax
  8006be:	83 ec 08             	sub    $0x8,%esp
  8006c1:	ff 75 f4             	pushl  -0xc(%ebp)
  8006c4:	50                   	push   %eax
  8006c5:	e8 73 ff ff ff       	call   80063d <vcprintf>
  8006ca:	83 c4 10             	add    $0x10,%esp
  8006cd:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  8006d0:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8006d3:	c9                   	leave  
  8006d4:	c3                   	ret    

008006d5 <atomic_cprintf>:

int atomic_cprintf(const char *fmt, ...) {
  8006d5:	55                   	push   %ebp
  8006d6:	89 e5                	mov    %esp,%ebp
  8006d8:	83 ec 18             	sub    $0x18,%esp
	sys_disable_interrupt();
  8006db:	e8 53 14 00 00       	call   801b33 <sys_disable_interrupt>
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  8006e0:	8d 45 0c             	lea    0xc(%ebp),%eax
  8006e3:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  8006e6:	8b 45 08             	mov    0x8(%ebp),%eax
  8006e9:	83 ec 08             	sub    $0x8,%esp
  8006ec:	ff 75 f4             	pushl  -0xc(%ebp)
  8006ef:	50                   	push   %eax
  8006f0:	e8 48 ff ff ff       	call   80063d <vcprintf>
  8006f5:	83 c4 10             	add    $0x10,%esp
  8006f8:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	sys_enable_interrupt();
  8006fb:	e8 4d 14 00 00       	call   801b4d <sys_enable_interrupt>
	return cnt;
  800700:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800703:	c9                   	leave  
  800704:	c3                   	ret    

00800705 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800705:	55                   	push   %ebp
  800706:	89 e5                	mov    %esp,%ebp
  800708:	53                   	push   %ebx
  800709:	83 ec 14             	sub    $0x14,%esp
  80070c:	8b 45 10             	mov    0x10(%ebp),%eax
  80070f:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800712:	8b 45 14             	mov    0x14(%ebp),%eax
  800715:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800718:	8b 45 18             	mov    0x18(%ebp),%eax
  80071b:	ba 00 00 00 00       	mov    $0x0,%edx
  800720:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800723:	77 55                	ja     80077a <printnum+0x75>
  800725:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800728:	72 05                	jb     80072f <printnum+0x2a>
  80072a:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  80072d:	77 4b                	ja     80077a <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  80072f:	8b 45 1c             	mov    0x1c(%ebp),%eax
  800732:	8d 58 ff             	lea    -0x1(%eax),%ebx
  800735:	8b 45 18             	mov    0x18(%ebp),%eax
  800738:	ba 00 00 00 00       	mov    $0x0,%edx
  80073d:	52                   	push   %edx
  80073e:	50                   	push   %eax
  80073f:	ff 75 f4             	pushl  -0xc(%ebp)
  800742:	ff 75 f0             	pushl  -0x10(%ebp)
  800745:	e8 86 28 00 00       	call   802fd0 <__udivdi3>
  80074a:	83 c4 10             	add    $0x10,%esp
  80074d:	83 ec 04             	sub    $0x4,%esp
  800750:	ff 75 20             	pushl  0x20(%ebp)
  800753:	53                   	push   %ebx
  800754:	ff 75 18             	pushl  0x18(%ebp)
  800757:	52                   	push   %edx
  800758:	50                   	push   %eax
  800759:	ff 75 0c             	pushl  0xc(%ebp)
  80075c:	ff 75 08             	pushl  0x8(%ebp)
  80075f:	e8 a1 ff ff ff       	call   800705 <printnum>
  800764:	83 c4 20             	add    $0x20,%esp
  800767:	eb 1a                	jmp    800783 <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  800769:	83 ec 08             	sub    $0x8,%esp
  80076c:	ff 75 0c             	pushl  0xc(%ebp)
  80076f:	ff 75 20             	pushl  0x20(%ebp)
  800772:	8b 45 08             	mov    0x8(%ebp),%eax
  800775:	ff d0                	call   *%eax
  800777:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  80077a:	ff 4d 1c             	decl   0x1c(%ebp)
  80077d:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  800781:	7f e6                	jg     800769 <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800783:	8b 4d 18             	mov    0x18(%ebp),%ecx
  800786:	bb 00 00 00 00       	mov    $0x0,%ebx
  80078b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80078e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800791:	53                   	push   %ebx
  800792:	51                   	push   %ecx
  800793:	52                   	push   %edx
  800794:	50                   	push   %eax
  800795:	e8 46 29 00 00       	call   8030e0 <__umoddi3>
  80079a:	83 c4 10             	add    $0x10,%esp
  80079d:	05 54 39 80 00       	add    $0x803954,%eax
  8007a2:	8a 00                	mov    (%eax),%al
  8007a4:	0f be c0             	movsbl %al,%eax
  8007a7:	83 ec 08             	sub    $0x8,%esp
  8007aa:	ff 75 0c             	pushl  0xc(%ebp)
  8007ad:	50                   	push   %eax
  8007ae:	8b 45 08             	mov    0x8(%ebp),%eax
  8007b1:	ff d0                	call   *%eax
  8007b3:	83 c4 10             	add    $0x10,%esp
}
  8007b6:	90                   	nop
  8007b7:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8007ba:	c9                   	leave  
  8007bb:	c3                   	ret    

008007bc <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  8007bc:	55                   	push   %ebp
  8007bd:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  8007bf:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  8007c3:	7e 1c                	jle    8007e1 <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  8007c5:	8b 45 08             	mov    0x8(%ebp),%eax
  8007c8:	8b 00                	mov    (%eax),%eax
  8007ca:	8d 50 08             	lea    0x8(%eax),%edx
  8007cd:	8b 45 08             	mov    0x8(%ebp),%eax
  8007d0:	89 10                	mov    %edx,(%eax)
  8007d2:	8b 45 08             	mov    0x8(%ebp),%eax
  8007d5:	8b 00                	mov    (%eax),%eax
  8007d7:	83 e8 08             	sub    $0x8,%eax
  8007da:	8b 50 04             	mov    0x4(%eax),%edx
  8007dd:	8b 00                	mov    (%eax),%eax
  8007df:	eb 40                	jmp    800821 <getuint+0x65>
	else if (lflag)
  8007e1:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8007e5:	74 1e                	je     800805 <getuint+0x49>
		return va_arg(*ap, unsigned long);
  8007e7:	8b 45 08             	mov    0x8(%ebp),%eax
  8007ea:	8b 00                	mov    (%eax),%eax
  8007ec:	8d 50 04             	lea    0x4(%eax),%edx
  8007ef:	8b 45 08             	mov    0x8(%ebp),%eax
  8007f2:	89 10                	mov    %edx,(%eax)
  8007f4:	8b 45 08             	mov    0x8(%ebp),%eax
  8007f7:	8b 00                	mov    (%eax),%eax
  8007f9:	83 e8 04             	sub    $0x4,%eax
  8007fc:	8b 00                	mov    (%eax),%eax
  8007fe:	ba 00 00 00 00       	mov    $0x0,%edx
  800803:	eb 1c                	jmp    800821 <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  800805:	8b 45 08             	mov    0x8(%ebp),%eax
  800808:	8b 00                	mov    (%eax),%eax
  80080a:	8d 50 04             	lea    0x4(%eax),%edx
  80080d:	8b 45 08             	mov    0x8(%ebp),%eax
  800810:	89 10                	mov    %edx,(%eax)
  800812:	8b 45 08             	mov    0x8(%ebp),%eax
  800815:	8b 00                	mov    (%eax),%eax
  800817:	83 e8 04             	sub    $0x4,%eax
  80081a:	8b 00                	mov    (%eax),%eax
  80081c:	ba 00 00 00 00       	mov    $0x0,%edx
}
  800821:	5d                   	pop    %ebp
  800822:	c3                   	ret    

00800823 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  800823:	55                   	push   %ebp
  800824:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800826:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  80082a:	7e 1c                	jle    800848 <getint+0x25>
		return va_arg(*ap, long long);
  80082c:	8b 45 08             	mov    0x8(%ebp),%eax
  80082f:	8b 00                	mov    (%eax),%eax
  800831:	8d 50 08             	lea    0x8(%eax),%edx
  800834:	8b 45 08             	mov    0x8(%ebp),%eax
  800837:	89 10                	mov    %edx,(%eax)
  800839:	8b 45 08             	mov    0x8(%ebp),%eax
  80083c:	8b 00                	mov    (%eax),%eax
  80083e:	83 e8 08             	sub    $0x8,%eax
  800841:	8b 50 04             	mov    0x4(%eax),%edx
  800844:	8b 00                	mov    (%eax),%eax
  800846:	eb 38                	jmp    800880 <getint+0x5d>
	else if (lflag)
  800848:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80084c:	74 1a                	je     800868 <getint+0x45>
		return va_arg(*ap, long);
  80084e:	8b 45 08             	mov    0x8(%ebp),%eax
  800851:	8b 00                	mov    (%eax),%eax
  800853:	8d 50 04             	lea    0x4(%eax),%edx
  800856:	8b 45 08             	mov    0x8(%ebp),%eax
  800859:	89 10                	mov    %edx,(%eax)
  80085b:	8b 45 08             	mov    0x8(%ebp),%eax
  80085e:	8b 00                	mov    (%eax),%eax
  800860:	83 e8 04             	sub    $0x4,%eax
  800863:	8b 00                	mov    (%eax),%eax
  800865:	99                   	cltd   
  800866:	eb 18                	jmp    800880 <getint+0x5d>
	else
		return va_arg(*ap, int);
  800868:	8b 45 08             	mov    0x8(%ebp),%eax
  80086b:	8b 00                	mov    (%eax),%eax
  80086d:	8d 50 04             	lea    0x4(%eax),%edx
  800870:	8b 45 08             	mov    0x8(%ebp),%eax
  800873:	89 10                	mov    %edx,(%eax)
  800875:	8b 45 08             	mov    0x8(%ebp),%eax
  800878:	8b 00                	mov    (%eax),%eax
  80087a:	83 e8 04             	sub    $0x4,%eax
  80087d:	8b 00                	mov    (%eax),%eax
  80087f:	99                   	cltd   
}
  800880:	5d                   	pop    %ebp
  800881:	c3                   	ret    

00800882 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  800882:	55                   	push   %ebp
  800883:	89 e5                	mov    %esp,%ebp
  800885:	56                   	push   %esi
  800886:	53                   	push   %ebx
  800887:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  80088a:	eb 17                	jmp    8008a3 <vprintfmt+0x21>
			if (ch == '\0')
  80088c:	85 db                	test   %ebx,%ebx
  80088e:	0f 84 af 03 00 00    	je     800c43 <vprintfmt+0x3c1>
				return;
			putch(ch, putdat);
  800894:	83 ec 08             	sub    $0x8,%esp
  800897:	ff 75 0c             	pushl  0xc(%ebp)
  80089a:	53                   	push   %ebx
  80089b:	8b 45 08             	mov    0x8(%ebp),%eax
  80089e:	ff d0                	call   *%eax
  8008a0:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8008a3:	8b 45 10             	mov    0x10(%ebp),%eax
  8008a6:	8d 50 01             	lea    0x1(%eax),%edx
  8008a9:	89 55 10             	mov    %edx,0x10(%ebp)
  8008ac:	8a 00                	mov    (%eax),%al
  8008ae:	0f b6 d8             	movzbl %al,%ebx
  8008b1:	83 fb 25             	cmp    $0x25,%ebx
  8008b4:	75 d6                	jne    80088c <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  8008b6:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  8008ba:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  8008c1:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  8008c8:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  8008cf:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8008d6:	8b 45 10             	mov    0x10(%ebp),%eax
  8008d9:	8d 50 01             	lea    0x1(%eax),%edx
  8008dc:	89 55 10             	mov    %edx,0x10(%ebp)
  8008df:	8a 00                	mov    (%eax),%al
  8008e1:	0f b6 d8             	movzbl %al,%ebx
  8008e4:	8d 43 dd             	lea    -0x23(%ebx),%eax
  8008e7:	83 f8 55             	cmp    $0x55,%eax
  8008ea:	0f 87 2b 03 00 00    	ja     800c1b <vprintfmt+0x399>
  8008f0:	8b 04 85 78 39 80 00 	mov    0x803978(,%eax,4),%eax
  8008f7:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  8008f9:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  8008fd:	eb d7                	jmp    8008d6 <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  8008ff:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  800903:	eb d1                	jmp    8008d6 <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800905:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  80090c:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80090f:	89 d0                	mov    %edx,%eax
  800911:	c1 e0 02             	shl    $0x2,%eax
  800914:	01 d0                	add    %edx,%eax
  800916:	01 c0                	add    %eax,%eax
  800918:	01 d8                	add    %ebx,%eax
  80091a:	83 e8 30             	sub    $0x30,%eax
  80091d:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  800920:	8b 45 10             	mov    0x10(%ebp),%eax
  800923:	8a 00                	mov    (%eax),%al
  800925:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  800928:	83 fb 2f             	cmp    $0x2f,%ebx
  80092b:	7e 3e                	jle    80096b <vprintfmt+0xe9>
  80092d:	83 fb 39             	cmp    $0x39,%ebx
  800930:	7f 39                	jg     80096b <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800932:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  800935:	eb d5                	jmp    80090c <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  800937:	8b 45 14             	mov    0x14(%ebp),%eax
  80093a:	83 c0 04             	add    $0x4,%eax
  80093d:	89 45 14             	mov    %eax,0x14(%ebp)
  800940:	8b 45 14             	mov    0x14(%ebp),%eax
  800943:	83 e8 04             	sub    $0x4,%eax
  800946:	8b 00                	mov    (%eax),%eax
  800948:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  80094b:	eb 1f                	jmp    80096c <vprintfmt+0xea>

		case '.':
			if (width < 0)
  80094d:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800951:	79 83                	jns    8008d6 <vprintfmt+0x54>
				width = 0;
  800953:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  80095a:	e9 77 ff ff ff       	jmp    8008d6 <vprintfmt+0x54>

		case '#':
			altflag = 1;
  80095f:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  800966:	e9 6b ff ff ff       	jmp    8008d6 <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  80096b:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  80096c:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800970:	0f 89 60 ff ff ff    	jns    8008d6 <vprintfmt+0x54>
				width = precision, precision = -1;
  800976:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800979:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  80097c:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  800983:	e9 4e ff ff ff       	jmp    8008d6 <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  800988:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  80098b:	e9 46 ff ff ff       	jmp    8008d6 <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  800990:	8b 45 14             	mov    0x14(%ebp),%eax
  800993:	83 c0 04             	add    $0x4,%eax
  800996:	89 45 14             	mov    %eax,0x14(%ebp)
  800999:	8b 45 14             	mov    0x14(%ebp),%eax
  80099c:	83 e8 04             	sub    $0x4,%eax
  80099f:	8b 00                	mov    (%eax),%eax
  8009a1:	83 ec 08             	sub    $0x8,%esp
  8009a4:	ff 75 0c             	pushl  0xc(%ebp)
  8009a7:	50                   	push   %eax
  8009a8:	8b 45 08             	mov    0x8(%ebp),%eax
  8009ab:	ff d0                	call   *%eax
  8009ad:	83 c4 10             	add    $0x10,%esp
			break;
  8009b0:	e9 89 02 00 00       	jmp    800c3e <vprintfmt+0x3bc>

		// error message
		case 'e':
			err = va_arg(ap, int);
  8009b5:	8b 45 14             	mov    0x14(%ebp),%eax
  8009b8:	83 c0 04             	add    $0x4,%eax
  8009bb:	89 45 14             	mov    %eax,0x14(%ebp)
  8009be:	8b 45 14             	mov    0x14(%ebp),%eax
  8009c1:	83 e8 04             	sub    $0x4,%eax
  8009c4:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  8009c6:	85 db                	test   %ebx,%ebx
  8009c8:	79 02                	jns    8009cc <vprintfmt+0x14a>
				err = -err;
  8009ca:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  8009cc:	83 fb 64             	cmp    $0x64,%ebx
  8009cf:	7f 0b                	jg     8009dc <vprintfmt+0x15a>
  8009d1:	8b 34 9d c0 37 80 00 	mov    0x8037c0(,%ebx,4),%esi
  8009d8:	85 f6                	test   %esi,%esi
  8009da:	75 19                	jne    8009f5 <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  8009dc:	53                   	push   %ebx
  8009dd:	68 65 39 80 00       	push   $0x803965
  8009e2:	ff 75 0c             	pushl  0xc(%ebp)
  8009e5:	ff 75 08             	pushl  0x8(%ebp)
  8009e8:	e8 5e 02 00 00       	call   800c4b <printfmt>
  8009ed:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  8009f0:	e9 49 02 00 00       	jmp    800c3e <vprintfmt+0x3bc>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  8009f5:	56                   	push   %esi
  8009f6:	68 6e 39 80 00       	push   $0x80396e
  8009fb:	ff 75 0c             	pushl  0xc(%ebp)
  8009fe:	ff 75 08             	pushl  0x8(%ebp)
  800a01:	e8 45 02 00 00       	call   800c4b <printfmt>
  800a06:	83 c4 10             	add    $0x10,%esp
			break;
  800a09:	e9 30 02 00 00       	jmp    800c3e <vprintfmt+0x3bc>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  800a0e:	8b 45 14             	mov    0x14(%ebp),%eax
  800a11:	83 c0 04             	add    $0x4,%eax
  800a14:	89 45 14             	mov    %eax,0x14(%ebp)
  800a17:	8b 45 14             	mov    0x14(%ebp),%eax
  800a1a:	83 e8 04             	sub    $0x4,%eax
  800a1d:	8b 30                	mov    (%eax),%esi
  800a1f:	85 f6                	test   %esi,%esi
  800a21:	75 05                	jne    800a28 <vprintfmt+0x1a6>
				p = "(null)";
  800a23:	be 71 39 80 00       	mov    $0x803971,%esi
			if (width > 0 && padc != '-')
  800a28:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800a2c:	7e 6d                	jle    800a9b <vprintfmt+0x219>
  800a2e:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  800a32:	74 67                	je     800a9b <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  800a34:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800a37:	83 ec 08             	sub    $0x8,%esp
  800a3a:	50                   	push   %eax
  800a3b:	56                   	push   %esi
  800a3c:	e8 0c 03 00 00       	call   800d4d <strnlen>
  800a41:	83 c4 10             	add    $0x10,%esp
  800a44:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  800a47:	eb 16                	jmp    800a5f <vprintfmt+0x1dd>
					putch(padc, putdat);
  800a49:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  800a4d:	83 ec 08             	sub    $0x8,%esp
  800a50:	ff 75 0c             	pushl  0xc(%ebp)
  800a53:	50                   	push   %eax
  800a54:	8b 45 08             	mov    0x8(%ebp),%eax
  800a57:	ff d0                	call   *%eax
  800a59:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800a5c:	ff 4d e4             	decl   -0x1c(%ebp)
  800a5f:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800a63:	7f e4                	jg     800a49 <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800a65:	eb 34                	jmp    800a9b <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  800a67:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  800a6b:	74 1c                	je     800a89 <vprintfmt+0x207>
  800a6d:	83 fb 1f             	cmp    $0x1f,%ebx
  800a70:	7e 05                	jle    800a77 <vprintfmt+0x1f5>
  800a72:	83 fb 7e             	cmp    $0x7e,%ebx
  800a75:	7e 12                	jle    800a89 <vprintfmt+0x207>
					putch('?', putdat);
  800a77:	83 ec 08             	sub    $0x8,%esp
  800a7a:	ff 75 0c             	pushl  0xc(%ebp)
  800a7d:	6a 3f                	push   $0x3f
  800a7f:	8b 45 08             	mov    0x8(%ebp),%eax
  800a82:	ff d0                	call   *%eax
  800a84:	83 c4 10             	add    $0x10,%esp
  800a87:	eb 0f                	jmp    800a98 <vprintfmt+0x216>
				else
					putch(ch, putdat);
  800a89:	83 ec 08             	sub    $0x8,%esp
  800a8c:	ff 75 0c             	pushl  0xc(%ebp)
  800a8f:	53                   	push   %ebx
  800a90:	8b 45 08             	mov    0x8(%ebp),%eax
  800a93:	ff d0                	call   *%eax
  800a95:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800a98:	ff 4d e4             	decl   -0x1c(%ebp)
  800a9b:	89 f0                	mov    %esi,%eax
  800a9d:	8d 70 01             	lea    0x1(%eax),%esi
  800aa0:	8a 00                	mov    (%eax),%al
  800aa2:	0f be d8             	movsbl %al,%ebx
  800aa5:	85 db                	test   %ebx,%ebx
  800aa7:	74 24                	je     800acd <vprintfmt+0x24b>
  800aa9:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800aad:	78 b8                	js     800a67 <vprintfmt+0x1e5>
  800aaf:	ff 4d e0             	decl   -0x20(%ebp)
  800ab2:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800ab6:	79 af                	jns    800a67 <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800ab8:	eb 13                	jmp    800acd <vprintfmt+0x24b>
				putch(' ', putdat);
  800aba:	83 ec 08             	sub    $0x8,%esp
  800abd:	ff 75 0c             	pushl  0xc(%ebp)
  800ac0:	6a 20                	push   $0x20
  800ac2:	8b 45 08             	mov    0x8(%ebp),%eax
  800ac5:	ff d0                	call   *%eax
  800ac7:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800aca:	ff 4d e4             	decl   -0x1c(%ebp)
  800acd:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800ad1:	7f e7                	jg     800aba <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  800ad3:	e9 66 01 00 00       	jmp    800c3e <vprintfmt+0x3bc>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  800ad8:	83 ec 08             	sub    $0x8,%esp
  800adb:	ff 75 e8             	pushl  -0x18(%ebp)
  800ade:	8d 45 14             	lea    0x14(%ebp),%eax
  800ae1:	50                   	push   %eax
  800ae2:	e8 3c fd ff ff       	call   800823 <getint>
  800ae7:	83 c4 10             	add    $0x10,%esp
  800aea:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800aed:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  800af0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800af3:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800af6:	85 d2                	test   %edx,%edx
  800af8:	79 23                	jns    800b1d <vprintfmt+0x29b>
				putch('-', putdat);
  800afa:	83 ec 08             	sub    $0x8,%esp
  800afd:	ff 75 0c             	pushl  0xc(%ebp)
  800b00:	6a 2d                	push   $0x2d
  800b02:	8b 45 08             	mov    0x8(%ebp),%eax
  800b05:	ff d0                	call   *%eax
  800b07:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  800b0a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800b0d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800b10:	f7 d8                	neg    %eax
  800b12:	83 d2 00             	adc    $0x0,%edx
  800b15:	f7 da                	neg    %edx
  800b17:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800b1a:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  800b1d:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800b24:	e9 bc 00 00 00       	jmp    800be5 <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  800b29:	83 ec 08             	sub    $0x8,%esp
  800b2c:	ff 75 e8             	pushl  -0x18(%ebp)
  800b2f:	8d 45 14             	lea    0x14(%ebp),%eax
  800b32:	50                   	push   %eax
  800b33:	e8 84 fc ff ff       	call   8007bc <getuint>
  800b38:	83 c4 10             	add    $0x10,%esp
  800b3b:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800b3e:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  800b41:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800b48:	e9 98 00 00 00       	jmp    800be5 <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  800b4d:	83 ec 08             	sub    $0x8,%esp
  800b50:	ff 75 0c             	pushl  0xc(%ebp)
  800b53:	6a 58                	push   $0x58
  800b55:	8b 45 08             	mov    0x8(%ebp),%eax
  800b58:	ff d0                	call   *%eax
  800b5a:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800b5d:	83 ec 08             	sub    $0x8,%esp
  800b60:	ff 75 0c             	pushl  0xc(%ebp)
  800b63:	6a 58                	push   $0x58
  800b65:	8b 45 08             	mov    0x8(%ebp),%eax
  800b68:	ff d0                	call   *%eax
  800b6a:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800b6d:	83 ec 08             	sub    $0x8,%esp
  800b70:	ff 75 0c             	pushl  0xc(%ebp)
  800b73:	6a 58                	push   $0x58
  800b75:	8b 45 08             	mov    0x8(%ebp),%eax
  800b78:	ff d0                	call   *%eax
  800b7a:	83 c4 10             	add    $0x10,%esp
			break;
  800b7d:	e9 bc 00 00 00       	jmp    800c3e <vprintfmt+0x3bc>

		// pointer
		case 'p':
			putch('0', putdat);
  800b82:	83 ec 08             	sub    $0x8,%esp
  800b85:	ff 75 0c             	pushl  0xc(%ebp)
  800b88:	6a 30                	push   $0x30
  800b8a:	8b 45 08             	mov    0x8(%ebp),%eax
  800b8d:	ff d0                	call   *%eax
  800b8f:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  800b92:	83 ec 08             	sub    $0x8,%esp
  800b95:	ff 75 0c             	pushl  0xc(%ebp)
  800b98:	6a 78                	push   $0x78
  800b9a:	8b 45 08             	mov    0x8(%ebp),%eax
  800b9d:	ff d0                	call   *%eax
  800b9f:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  800ba2:	8b 45 14             	mov    0x14(%ebp),%eax
  800ba5:	83 c0 04             	add    $0x4,%eax
  800ba8:	89 45 14             	mov    %eax,0x14(%ebp)
  800bab:	8b 45 14             	mov    0x14(%ebp),%eax
  800bae:	83 e8 04             	sub    $0x4,%eax
  800bb1:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800bb3:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800bb6:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  800bbd:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  800bc4:	eb 1f                	jmp    800be5 <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  800bc6:	83 ec 08             	sub    $0x8,%esp
  800bc9:	ff 75 e8             	pushl  -0x18(%ebp)
  800bcc:	8d 45 14             	lea    0x14(%ebp),%eax
  800bcf:	50                   	push   %eax
  800bd0:	e8 e7 fb ff ff       	call   8007bc <getuint>
  800bd5:	83 c4 10             	add    $0x10,%esp
  800bd8:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800bdb:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  800bde:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800be5:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  800be9:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800bec:	83 ec 04             	sub    $0x4,%esp
  800bef:	52                   	push   %edx
  800bf0:	ff 75 e4             	pushl  -0x1c(%ebp)
  800bf3:	50                   	push   %eax
  800bf4:	ff 75 f4             	pushl  -0xc(%ebp)
  800bf7:	ff 75 f0             	pushl  -0x10(%ebp)
  800bfa:	ff 75 0c             	pushl  0xc(%ebp)
  800bfd:	ff 75 08             	pushl  0x8(%ebp)
  800c00:	e8 00 fb ff ff       	call   800705 <printnum>
  800c05:	83 c4 20             	add    $0x20,%esp
			break;
  800c08:	eb 34                	jmp    800c3e <vprintfmt+0x3bc>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  800c0a:	83 ec 08             	sub    $0x8,%esp
  800c0d:	ff 75 0c             	pushl  0xc(%ebp)
  800c10:	53                   	push   %ebx
  800c11:	8b 45 08             	mov    0x8(%ebp),%eax
  800c14:	ff d0                	call   *%eax
  800c16:	83 c4 10             	add    $0x10,%esp
			break;
  800c19:	eb 23                	jmp    800c3e <vprintfmt+0x3bc>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800c1b:	83 ec 08             	sub    $0x8,%esp
  800c1e:	ff 75 0c             	pushl  0xc(%ebp)
  800c21:	6a 25                	push   $0x25
  800c23:	8b 45 08             	mov    0x8(%ebp),%eax
  800c26:	ff d0                	call   *%eax
  800c28:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  800c2b:	ff 4d 10             	decl   0x10(%ebp)
  800c2e:	eb 03                	jmp    800c33 <vprintfmt+0x3b1>
  800c30:	ff 4d 10             	decl   0x10(%ebp)
  800c33:	8b 45 10             	mov    0x10(%ebp),%eax
  800c36:	48                   	dec    %eax
  800c37:	8a 00                	mov    (%eax),%al
  800c39:	3c 25                	cmp    $0x25,%al
  800c3b:	75 f3                	jne    800c30 <vprintfmt+0x3ae>
				/* do nothing */;
			break;
  800c3d:	90                   	nop
		}
	}
  800c3e:	e9 47 fc ff ff       	jmp    80088a <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  800c43:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  800c44:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800c47:	5b                   	pop    %ebx
  800c48:	5e                   	pop    %esi
  800c49:	5d                   	pop    %ebp
  800c4a:	c3                   	ret    

00800c4b <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800c4b:	55                   	push   %ebp
  800c4c:	89 e5                	mov    %esp,%ebp
  800c4e:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  800c51:	8d 45 10             	lea    0x10(%ebp),%eax
  800c54:	83 c0 04             	add    $0x4,%eax
  800c57:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  800c5a:	8b 45 10             	mov    0x10(%ebp),%eax
  800c5d:	ff 75 f4             	pushl  -0xc(%ebp)
  800c60:	50                   	push   %eax
  800c61:	ff 75 0c             	pushl  0xc(%ebp)
  800c64:	ff 75 08             	pushl  0x8(%ebp)
  800c67:	e8 16 fc ff ff       	call   800882 <vprintfmt>
  800c6c:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  800c6f:	90                   	nop
  800c70:	c9                   	leave  
  800c71:	c3                   	ret    

00800c72 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800c72:	55                   	push   %ebp
  800c73:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  800c75:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c78:	8b 40 08             	mov    0x8(%eax),%eax
  800c7b:	8d 50 01             	lea    0x1(%eax),%edx
  800c7e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c81:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  800c84:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c87:	8b 10                	mov    (%eax),%edx
  800c89:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c8c:	8b 40 04             	mov    0x4(%eax),%eax
  800c8f:	39 c2                	cmp    %eax,%edx
  800c91:	73 12                	jae    800ca5 <sprintputch+0x33>
		*b->buf++ = ch;
  800c93:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c96:	8b 00                	mov    (%eax),%eax
  800c98:	8d 48 01             	lea    0x1(%eax),%ecx
  800c9b:	8b 55 0c             	mov    0xc(%ebp),%edx
  800c9e:	89 0a                	mov    %ecx,(%edx)
  800ca0:	8b 55 08             	mov    0x8(%ebp),%edx
  800ca3:	88 10                	mov    %dl,(%eax)
}
  800ca5:	90                   	nop
  800ca6:	5d                   	pop    %ebp
  800ca7:	c3                   	ret    

00800ca8 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800ca8:	55                   	push   %ebp
  800ca9:	89 e5                	mov    %esp,%ebp
  800cab:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  800cae:	8b 45 08             	mov    0x8(%ebp),%eax
  800cb1:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800cb4:	8b 45 0c             	mov    0xc(%ebp),%eax
  800cb7:	8d 50 ff             	lea    -0x1(%eax),%edx
  800cba:	8b 45 08             	mov    0x8(%ebp),%eax
  800cbd:	01 d0                	add    %edx,%eax
  800cbf:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800cc2:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800cc9:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800ccd:	74 06                	je     800cd5 <vsnprintf+0x2d>
  800ccf:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800cd3:	7f 07                	jg     800cdc <vsnprintf+0x34>
		return -E_INVAL;
  800cd5:	b8 03 00 00 00       	mov    $0x3,%eax
  800cda:	eb 20                	jmp    800cfc <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800cdc:	ff 75 14             	pushl  0x14(%ebp)
  800cdf:	ff 75 10             	pushl  0x10(%ebp)
  800ce2:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800ce5:	50                   	push   %eax
  800ce6:	68 72 0c 80 00       	push   $0x800c72
  800ceb:	e8 92 fb ff ff       	call   800882 <vprintfmt>
  800cf0:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  800cf3:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800cf6:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800cf9:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  800cfc:	c9                   	leave  
  800cfd:	c3                   	ret    

00800cfe <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800cfe:	55                   	push   %ebp
  800cff:	89 e5                	mov    %esp,%ebp
  800d01:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800d04:	8d 45 10             	lea    0x10(%ebp),%eax
  800d07:	83 c0 04             	add    $0x4,%eax
  800d0a:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  800d0d:	8b 45 10             	mov    0x10(%ebp),%eax
  800d10:	ff 75 f4             	pushl  -0xc(%ebp)
  800d13:	50                   	push   %eax
  800d14:	ff 75 0c             	pushl  0xc(%ebp)
  800d17:	ff 75 08             	pushl  0x8(%ebp)
  800d1a:	e8 89 ff ff ff       	call   800ca8 <vsnprintf>
  800d1f:	83 c4 10             	add    $0x10,%esp
  800d22:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  800d25:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800d28:	c9                   	leave  
  800d29:	c3                   	ret    

00800d2a <strlen>:

#include <inc/string.h>

int
strlen(const char *s)
{
  800d2a:	55                   	push   %ebp
  800d2b:	89 e5                	mov    %esp,%ebp
  800d2d:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  800d30:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800d37:	eb 06                	jmp    800d3f <strlen+0x15>
		n++;
  800d39:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  800d3c:	ff 45 08             	incl   0x8(%ebp)
  800d3f:	8b 45 08             	mov    0x8(%ebp),%eax
  800d42:	8a 00                	mov    (%eax),%al
  800d44:	84 c0                	test   %al,%al
  800d46:	75 f1                	jne    800d39 <strlen+0xf>
		n++;
	return n;
  800d48:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800d4b:	c9                   	leave  
  800d4c:	c3                   	ret    

00800d4d <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  800d4d:	55                   	push   %ebp
  800d4e:	89 e5                	mov    %esp,%ebp
  800d50:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800d53:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800d5a:	eb 09                	jmp    800d65 <strnlen+0x18>
		n++;
  800d5c:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800d5f:	ff 45 08             	incl   0x8(%ebp)
  800d62:	ff 4d 0c             	decl   0xc(%ebp)
  800d65:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800d69:	74 09                	je     800d74 <strnlen+0x27>
  800d6b:	8b 45 08             	mov    0x8(%ebp),%eax
  800d6e:	8a 00                	mov    (%eax),%al
  800d70:	84 c0                	test   %al,%al
  800d72:	75 e8                	jne    800d5c <strnlen+0xf>
		n++;
	return n;
  800d74:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800d77:	c9                   	leave  
  800d78:	c3                   	ret    

00800d79 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800d79:	55                   	push   %ebp
  800d7a:	89 e5                	mov    %esp,%ebp
  800d7c:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  800d7f:	8b 45 08             	mov    0x8(%ebp),%eax
  800d82:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  800d85:	90                   	nop
  800d86:	8b 45 08             	mov    0x8(%ebp),%eax
  800d89:	8d 50 01             	lea    0x1(%eax),%edx
  800d8c:	89 55 08             	mov    %edx,0x8(%ebp)
  800d8f:	8b 55 0c             	mov    0xc(%ebp),%edx
  800d92:	8d 4a 01             	lea    0x1(%edx),%ecx
  800d95:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800d98:	8a 12                	mov    (%edx),%dl
  800d9a:	88 10                	mov    %dl,(%eax)
  800d9c:	8a 00                	mov    (%eax),%al
  800d9e:	84 c0                	test   %al,%al
  800da0:	75 e4                	jne    800d86 <strcpy+0xd>
		/* do nothing */;
	return ret;
  800da2:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800da5:	c9                   	leave  
  800da6:	c3                   	ret    

00800da7 <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  800da7:	55                   	push   %ebp
  800da8:	89 e5                	mov    %esp,%ebp
  800daa:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  800dad:	8b 45 08             	mov    0x8(%ebp),%eax
  800db0:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  800db3:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800dba:	eb 1f                	jmp    800ddb <strncpy+0x34>
		*dst++ = *src;
  800dbc:	8b 45 08             	mov    0x8(%ebp),%eax
  800dbf:	8d 50 01             	lea    0x1(%eax),%edx
  800dc2:	89 55 08             	mov    %edx,0x8(%ebp)
  800dc5:	8b 55 0c             	mov    0xc(%ebp),%edx
  800dc8:	8a 12                	mov    (%edx),%dl
  800dca:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  800dcc:	8b 45 0c             	mov    0xc(%ebp),%eax
  800dcf:	8a 00                	mov    (%eax),%al
  800dd1:	84 c0                	test   %al,%al
  800dd3:	74 03                	je     800dd8 <strncpy+0x31>
			src++;
  800dd5:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800dd8:	ff 45 fc             	incl   -0x4(%ebp)
  800ddb:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800dde:	3b 45 10             	cmp    0x10(%ebp),%eax
  800de1:	72 d9                	jb     800dbc <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  800de3:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  800de6:	c9                   	leave  
  800de7:	c3                   	ret    

00800de8 <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  800de8:	55                   	push   %ebp
  800de9:	89 e5                	mov    %esp,%ebp
  800deb:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  800dee:	8b 45 08             	mov    0x8(%ebp),%eax
  800df1:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  800df4:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800df8:	74 30                	je     800e2a <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  800dfa:	eb 16                	jmp    800e12 <strlcpy+0x2a>
			*dst++ = *src++;
  800dfc:	8b 45 08             	mov    0x8(%ebp),%eax
  800dff:	8d 50 01             	lea    0x1(%eax),%edx
  800e02:	89 55 08             	mov    %edx,0x8(%ebp)
  800e05:	8b 55 0c             	mov    0xc(%ebp),%edx
  800e08:	8d 4a 01             	lea    0x1(%edx),%ecx
  800e0b:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800e0e:	8a 12                	mov    (%edx),%dl
  800e10:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  800e12:	ff 4d 10             	decl   0x10(%ebp)
  800e15:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800e19:	74 09                	je     800e24 <strlcpy+0x3c>
  800e1b:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e1e:	8a 00                	mov    (%eax),%al
  800e20:	84 c0                	test   %al,%al
  800e22:	75 d8                	jne    800dfc <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  800e24:	8b 45 08             	mov    0x8(%ebp),%eax
  800e27:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800e2a:	8b 55 08             	mov    0x8(%ebp),%edx
  800e2d:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800e30:	29 c2                	sub    %eax,%edx
  800e32:	89 d0                	mov    %edx,%eax
}
  800e34:	c9                   	leave  
  800e35:	c3                   	ret    

00800e36 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800e36:	55                   	push   %ebp
  800e37:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  800e39:	eb 06                	jmp    800e41 <strcmp+0xb>
		p++, q++;
  800e3b:	ff 45 08             	incl   0x8(%ebp)
  800e3e:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  800e41:	8b 45 08             	mov    0x8(%ebp),%eax
  800e44:	8a 00                	mov    (%eax),%al
  800e46:	84 c0                	test   %al,%al
  800e48:	74 0e                	je     800e58 <strcmp+0x22>
  800e4a:	8b 45 08             	mov    0x8(%ebp),%eax
  800e4d:	8a 10                	mov    (%eax),%dl
  800e4f:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e52:	8a 00                	mov    (%eax),%al
  800e54:	38 c2                	cmp    %al,%dl
  800e56:	74 e3                	je     800e3b <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800e58:	8b 45 08             	mov    0x8(%ebp),%eax
  800e5b:	8a 00                	mov    (%eax),%al
  800e5d:	0f b6 d0             	movzbl %al,%edx
  800e60:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e63:	8a 00                	mov    (%eax),%al
  800e65:	0f b6 c0             	movzbl %al,%eax
  800e68:	29 c2                	sub    %eax,%edx
  800e6a:	89 d0                	mov    %edx,%eax
}
  800e6c:	5d                   	pop    %ebp
  800e6d:	c3                   	ret    

00800e6e <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  800e6e:	55                   	push   %ebp
  800e6f:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  800e71:	eb 09                	jmp    800e7c <strncmp+0xe>
		n--, p++, q++;
  800e73:	ff 4d 10             	decl   0x10(%ebp)
  800e76:	ff 45 08             	incl   0x8(%ebp)
  800e79:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  800e7c:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800e80:	74 17                	je     800e99 <strncmp+0x2b>
  800e82:	8b 45 08             	mov    0x8(%ebp),%eax
  800e85:	8a 00                	mov    (%eax),%al
  800e87:	84 c0                	test   %al,%al
  800e89:	74 0e                	je     800e99 <strncmp+0x2b>
  800e8b:	8b 45 08             	mov    0x8(%ebp),%eax
  800e8e:	8a 10                	mov    (%eax),%dl
  800e90:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e93:	8a 00                	mov    (%eax),%al
  800e95:	38 c2                	cmp    %al,%dl
  800e97:	74 da                	je     800e73 <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  800e99:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800e9d:	75 07                	jne    800ea6 <strncmp+0x38>
		return 0;
  800e9f:	b8 00 00 00 00       	mov    $0x0,%eax
  800ea4:	eb 14                	jmp    800eba <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800ea6:	8b 45 08             	mov    0x8(%ebp),%eax
  800ea9:	8a 00                	mov    (%eax),%al
  800eab:	0f b6 d0             	movzbl %al,%edx
  800eae:	8b 45 0c             	mov    0xc(%ebp),%eax
  800eb1:	8a 00                	mov    (%eax),%al
  800eb3:	0f b6 c0             	movzbl %al,%eax
  800eb6:	29 c2                	sub    %eax,%edx
  800eb8:	89 d0                	mov    %edx,%eax
}
  800eba:	5d                   	pop    %ebp
  800ebb:	c3                   	ret    

00800ebc <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800ebc:	55                   	push   %ebp
  800ebd:	89 e5                	mov    %esp,%ebp
  800ebf:	83 ec 04             	sub    $0x4,%esp
  800ec2:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ec5:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800ec8:	eb 12                	jmp    800edc <strchr+0x20>
		if (*s == c)
  800eca:	8b 45 08             	mov    0x8(%ebp),%eax
  800ecd:	8a 00                	mov    (%eax),%al
  800ecf:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800ed2:	75 05                	jne    800ed9 <strchr+0x1d>
			return (char *) s;
  800ed4:	8b 45 08             	mov    0x8(%ebp),%eax
  800ed7:	eb 11                	jmp    800eea <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  800ed9:	ff 45 08             	incl   0x8(%ebp)
  800edc:	8b 45 08             	mov    0x8(%ebp),%eax
  800edf:	8a 00                	mov    (%eax),%al
  800ee1:	84 c0                	test   %al,%al
  800ee3:	75 e5                	jne    800eca <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  800ee5:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800eea:	c9                   	leave  
  800eeb:	c3                   	ret    

00800eec <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800eec:	55                   	push   %ebp
  800eed:	89 e5                	mov    %esp,%ebp
  800eef:	83 ec 04             	sub    $0x4,%esp
  800ef2:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ef5:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800ef8:	eb 0d                	jmp    800f07 <strfind+0x1b>
		if (*s == c)
  800efa:	8b 45 08             	mov    0x8(%ebp),%eax
  800efd:	8a 00                	mov    (%eax),%al
  800eff:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800f02:	74 0e                	je     800f12 <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  800f04:	ff 45 08             	incl   0x8(%ebp)
  800f07:	8b 45 08             	mov    0x8(%ebp),%eax
  800f0a:	8a 00                	mov    (%eax),%al
  800f0c:	84 c0                	test   %al,%al
  800f0e:	75 ea                	jne    800efa <strfind+0xe>
  800f10:	eb 01                	jmp    800f13 <strfind+0x27>
		if (*s == c)
			break;
  800f12:	90                   	nop
	return (char *) s;
  800f13:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800f16:	c9                   	leave  
  800f17:	c3                   	ret    

00800f18 <memset>:


void *
memset(void *v, int c, uint32 n)
{
  800f18:	55                   	push   %ebp
  800f19:	89 e5                	mov    %esp,%ebp
  800f1b:	83 ec 10             	sub    $0x10,%esp
	char *p;
	int m;

	p = v;
  800f1e:	8b 45 08             	mov    0x8(%ebp),%eax
  800f21:	89 45 fc             	mov    %eax,-0x4(%ebp)
	m = n;
  800f24:	8b 45 10             	mov    0x10(%ebp),%eax
  800f27:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (--m >= 0)
  800f2a:	eb 0e                	jmp    800f3a <memset+0x22>
		*p++ = c;
  800f2c:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800f2f:	8d 50 01             	lea    0x1(%eax),%edx
  800f32:	89 55 fc             	mov    %edx,-0x4(%ebp)
  800f35:	8b 55 0c             	mov    0xc(%ebp),%edx
  800f38:	88 10                	mov    %dl,(%eax)
	char *p;
	int m;

	p = v;
	m = n;
	while (--m >= 0)
  800f3a:	ff 4d f8             	decl   -0x8(%ebp)
  800f3d:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
  800f41:	79 e9                	jns    800f2c <memset+0x14>
		*p++ = c;

	return v;
  800f43:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800f46:	c9                   	leave  
  800f47:	c3                   	ret    

00800f48 <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  800f48:	55                   	push   %ebp
  800f49:	89 e5                	mov    %esp,%ebp
  800f4b:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  800f4e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f51:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  800f54:	8b 45 08             	mov    0x8(%ebp),%eax
  800f57:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (n-- > 0)
  800f5a:	eb 16                	jmp    800f72 <memcpy+0x2a>
		*d++ = *s++;
  800f5c:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800f5f:	8d 50 01             	lea    0x1(%eax),%edx
  800f62:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800f65:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800f68:	8d 4a 01             	lea    0x1(%edx),%ecx
  800f6b:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  800f6e:	8a 12                	mov    (%edx),%dl
  800f70:	88 10                	mov    %dl,(%eax)
	const char *s;
	char *d;

	s = src;
	d = dst;
	while (n-- > 0)
  800f72:	8b 45 10             	mov    0x10(%ebp),%eax
  800f75:	8d 50 ff             	lea    -0x1(%eax),%edx
  800f78:	89 55 10             	mov    %edx,0x10(%ebp)
  800f7b:	85 c0                	test   %eax,%eax
  800f7d:	75 dd                	jne    800f5c <memcpy+0x14>
		*d++ = *s++;

	return dst;
  800f7f:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800f82:	c9                   	leave  
  800f83:	c3                   	ret    

00800f84 <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  800f84:	55                   	push   %ebp
  800f85:	89 e5                	mov    %esp,%ebp
  800f87:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  800f8a:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f8d:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  800f90:	8b 45 08             	mov    0x8(%ebp),%eax
  800f93:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  800f96:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800f99:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800f9c:	73 50                	jae    800fee <memmove+0x6a>
  800f9e:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800fa1:	8b 45 10             	mov    0x10(%ebp),%eax
  800fa4:	01 d0                	add    %edx,%eax
  800fa6:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800fa9:	76 43                	jbe    800fee <memmove+0x6a>
		s += n;
  800fab:	8b 45 10             	mov    0x10(%ebp),%eax
  800fae:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  800fb1:	8b 45 10             	mov    0x10(%ebp),%eax
  800fb4:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  800fb7:	eb 10                	jmp    800fc9 <memmove+0x45>
			*--d = *--s;
  800fb9:	ff 4d f8             	decl   -0x8(%ebp)
  800fbc:	ff 4d fc             	decl   -0x4(%ebp)
  800fbf:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800fc2:	8a 10                	mov    (%eax),%dl
  800fc4:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800fc7:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  800fc9:	8b 45 10             	mov    0x10(%ebp),%eax
  800fcc:	8d 50 ff             	lea    -0x1(%eax),%edx
  800fcf:	89 55 10             	mov    %edx,0x10(%ebp)
  800fd2:	85 c0                	test   %eax,%eax
  800fd4:	75 e3                	jne    800fb9 <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800fd6:	eb 23                	jmp    800ffb <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  800fd8:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800fdb:	8d 50 01             	lea    0x1(%eax),%edx
  800fde:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800fe1:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800fe4:	8d 4a 01             	lea    0x1(%edx),%ecx
  800fe7:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  800fea:	8a 12                	mov    (%edx),%dl
  800fec:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  800fee:	8b 45 10             	mov    0x10(%ebp),%eax
  800ff1:	8d 50 ff             	lea    -0x1(%eax),%edx
  800ff4:	89 55 10             	mov    %edx,0x10(%ebp)
  800ff7:	85 c0                	test   %eax,%eax
  800ff9:	75 dd                	jne    800fd8 <memmove+0x54>
			*d++ = *s++;

	return dst;
  800ffb:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800ffe:	c9                   	leave  
  800fff:	c3                   	ret    

00801000 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  801000:	55                   	push   %ebp
  801001:	89 e5                	mov    %esp,%ebp
  801003:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  801006:	8b 45 08             	mov    0x8(%ebp),%eax
  801009:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  80100c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80100f:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  801012:	eb 2a                	jmp    80103e <memcmp+0x3e>
		if (*s1 != *s2)
  801014:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801017:	8a 10                	mov    (%eax),%dl
  801019:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80101c:	8a 00                	mov    (%eax),%al
  80101e:	38 c2                	cmp    %al,%dl
  801020:	74 16                	je     801038 <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  801022:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801025:	8a 00                	mov    (%eax),%al
  801027:	0f b6 d0             	movzbl %al,%edx
  80102a:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80102d:	8a 00                	mov    (%eax),%al
  80102f:	0f b6 c0             	movzbl %al,%eax
  801032:	29 c2                	sub    %eax,%edx
  801034:	89 d0                	mov    %edx,%eax
  801036:	eb 18                	jmp    801050 <memcmp+0x50>
		s1++, s2++;
  801038:	ff 45 fc             	incl   -0x4(%ebp)
  80103b:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  80103e:	8b 45 10             	mov    0x10(%ebp),%eax
  801041:	8d 50 ff             	lea    -0x1(%eax),%edx
  801044:	89 55 10             	mov    %edx,0x10(%ebp)
  801047:	85 c0                	test   %eax,%eax
  801049:	75 c9                	jne    801014 <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  80104b:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801050:	c9                   	leave  
  801051:	c3                   	ret    

00801052 <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  801052:	55                   	push   %ebp
  801053:	89 e5                	mov    %esp,%ebp
  801055:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  801058:	8b 55 08             	mov    0x8(%ebp),%edx
  80105b:	8b 45 10             	mov    0x10(%ebp),%eax
  80105e:	01 d0                	add    %edx,%eax
  801060:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  801063:	eb 15                	jmp    80107a <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  801065:	8b 45 08             	mov    0x8(%ebp),%eax
  801068:	8a 00                	mov    (%eax),%al
  80106a:	0f b6 d0             	movzbl %al,%edx
  80106d:	8b 45 0c             	mov    0xc(%ebp),%eax
  801070:	0f b6 c0             	movzbl %al,%eax
  801073:	39 c2                	cmp    %eax,%edx
  801075:	74 0d                	je     801084 <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  801077:	ff 45 08             	incl   0x8(%ebp)
  80107a:	8b 45 08             	mov    0x8(%ebp),%eax
  80107d:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  801080:	72 e3                	jb     801065 <memfind+0x13>
  801082:	eb 01                	jmp    801085 <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  801084:	90                   	nop
	return (void *) s;
  801085:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801088:	c9                   	leave  
  801089:	c3                   	ret    

0080108a <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  80108a:	55                   	push   %ebp
  80108b:	89 e5                	mov    %esp,%ebp
  80108d:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  801090:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  801097:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  80109e:	eb 03                	jmp    8010a3 <strtol+0x19>
		s++;
  8010a0:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  8010a3:	8b 45 08             	mov    0x8(%ebp),%eax
  8010a6:	8a 00                	mov    (%eax),%al
  8010a8:	3c 20                	cmp    $0x20,%al
  8010aa:	74 f4                	je     8010a0 <strtol+0x16>
  8010ac:	8b 45 08             	mov    0x8(%ebp),%eax
  8010af:	8a 00                	mov    (%eax),%al
  8010b1:	3c 09                	cmp    $0x9,%al
  8010b3:	74 eb                	je     8010a0 <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  8010b5:	8b 45 08             	mov    0x8(%ebp),%eax
  8010b8:	8a 00                	mov    (%eax),%al
  8010ba:	3c 2b                	cmp    $0x2b,%al
  8010bc:	75 05                	jne    8010c3 <strtol+0x39>
		s++;
  8010be:	ff 45 08             	incl   0x8(%ebp)
  8010c1:	eb 13                	jmp    8010d6 <strtol+0x4c>
	else if (*s == '-')
  8010c3:	8b 45 08             	mov    0x8(%ebp),%eax
  8010c6:	8a 00                	mov    (%eax),%al
  8010c8:	3c 2d                	cmp    $0x2d,%al
  8010ca:	75 0a                	jne    8010d6 <strtol+0x4c>
		s++, neg = 1;
  8010cc:	ff 45 08             	incl   0x8(%ebp)
  8010cf:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  8010d6:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8010da:	74 06                	je     8010e2 <strtol+0x58>
  8010dc:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  8010e0:	75 20                	jne    801102 <strtol+0x78>
  8010e2:	8b 45 08             	mov    0x8(%ebp),%eax
  8010e5:	8a 00                	mov    (%eax),%al
  8010e7:	3c 30                	cmp    $0x30,%al
  8010e9:	75 17                	jne    801102 <strtol+0x78>
  8010eb:	8b 45 08             	mov    0x8(%ebp),%eax
  8010ee:	40                   	inc    %eax
  8010ef:	8a 00                	mov    (%eax),%al
  8010f1:	3c 78                	cmp    $0x78,%al
  8010f3:	75 0d                	jne    801102 <strtol+0x78>
		s += 2, base = 16;
  8010f5:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  8010f9:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  801100:	eb 28                	jmp    80112a <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  801102:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801106:	75 15                	jne    80111d <strtol+0x93>
  801108:	8b 45 08             	mov    0x8(%ebp),%eax
  80110b:	8a 00                	mov    (%eax),%al
  80110d:	3c 30                	cmp    $0x30,%al
  80110f:	75 0c                	jne    80111d <strtol+0x93>
		s++, base = 8;
  801111:	ff 45 08             	incl   0x8(%ebp)
  801114:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  80111b:	eb 0d                	jmp    80112a <strtol+0xa0>
	else if (base == 0)
  80111d:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801121:	75 07                	jne    80112a <strtol+0xa0>
		base = 10;
  801123:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  80112a:	8b 45 08             	mov    0x8(%ebp),%eax
  80112d:	8a 00                	mov    (%eax),%al
  80112f:	3c 2f                	cmp    $0x2f,%al
  801131:	7e 19                	jle    80114c <strtol+0xc2>
  801133:	8b 45 08             	mov    0x8(%ebp),%eax
  801136:	8a 00                	mov    (%eax),%al
  801138:	3c 39                	cmp    $0x39,%al
  80113a:	7f 10                	jg     80114c <strtol+0xc2>
			dig = *s - '0';
  80113c:	8b 45 08             	mov    0x8(%ebp),%eax
  80113f:	8a 00                	mov    (%eax),%al
  801141:	0f be c0             	movsbl %al,%eax
  801144:	83 e8 30             	sub    $0x30,%eax
  801147:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80114a:	eb 42                	jmp    80118e <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  80114c:	8b 45 08             	mov    0x8(%ebp),%eax
  80114f:	8a 00                	mov    (%eax),%al
  801151:	3c 60                	cmp    $0x60,%al
  801153:	7e 19                	jle    80116e <strtol+0xe4>
  801155:	8b 45 08             	mov    0x8(%ebp),%eax
  801158:	8a 00                	mov    (%eax),%al
  80115a:	3c 7a                	cmp    $0x7a,%al
  80115c:	7f 10                	jg     80116e <strtol+0xe4>
			dig = *s - 'a' + 10;
  80115e:	8b 45 08             	mov    0x8(%ebp),%eax
  801161:	8a 00                	mov    (%eax),%al
  801163:	0f be c0             	movsbl %al,%eax
  801166:	83 e8 57             	sub    $0x57,%eax
  801169:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80116c:	eb 20                	jmp    80118e <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  80116e:	8b 45 08             	mov    0x8(%ebp),%eax
  801171:	8a 00                	mov    (%eax),%al
  801173:	3c 40                	cmp    $0x40,%al
  801175:	7e 39                	jle    8011b0 <strtol+0x126>
  801177:	8b 45 08             	mov    0x8(%ebp),%eax
  80117a:	8a 00                	mov    (%eax),%al
  80117c:	3c 5a                	cmp    $0x5a,%al
  80117e:	7f 30                	jg     8011b0 <strtol+0x126>
			dig = *s - 'A' + 10;
  801180:	8b 45 08             	mov    0x8(%ebp),%eax
  801183:	8a 00                	mov    (%eax),%al
  801185:	0f be c0             	movsbl %al,%eax
  801188:	83 e8 37             	sub    $0x37,%eax
  80118b:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  80118e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801191:	3b 45 10             	cmp    0x10(%ebp),%eax
  801194:	7d 19                	jge    8011af <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  801196:	ff 45 08             	incl   0x8(%ebp)
  801199:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80119c:	0f af 45 10          	imul   0x10(%ebp),%eax
  8011a0:	89 c2                	mov    %eax,%edx
  8011a2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8011a5:	01 d0                	add    %edx,%eax
  8011a7:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  8011aa:	e9 7b ff ff ff       	jmp    80112a <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  8011af:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  8011b0:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8011b4:	74 08                	je     8011be <strtol+0x134>
		*endptr = (char *) s;
  8011b6:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011b9:	8b 55 08             	mov    0x8(%ebp),%edx
  8011bc:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  8011be:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  8011c2:	74 07                	je     8011cb <strtol+0x141>
  8011c4:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8011c7:	f7 d8                	neg    %eax
  8011c9:	eb 03                	jmp    8011ce <strtol+0x144>
  8011cb:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  8011ce:	c9                   	leave  
  8011cf:	c3                   	ret    

008011d0 <ltostr>:

void
ltostr(long value, char *str)
{
  8011d0:	55                   	push   %ebp
  8011d1:	89 e5                	mov    %esp,%ebp
  8011d3:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  8011d6:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  8011dd:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  8011e4:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8011e8:	79 13                	jns    8011fd <ltostr+0x2d>
	{
		neg = 1;
  8011ea:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  8011f1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011f4:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  8011f7:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  8011fa:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  8011fd:	8b 45 08             	mov    0x8(%ebp),%eax
  801200:	b9 0a 00 00 00       	mov    $0xa,%ecx
  801205:	99                   	cltd   
  801206:	f7 f9                	idiv   %ecx
  801208:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  80120b:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80120e:	8d 50 01             	lea    0x1(%eax),%edx
  801211:	89 55 f8             	mov    %edx,-0x8(%ebp)
  801214:	89 c2                	mov    %eax,%edx
  801216:	8b 45 0c             	mov    0xc(%ebp),%eax
  801219:	01 d0                	add    %edx,%eax
  80121b:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80121e:	83 c2 30             	add    $0x30,%edx
  801221:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  801223:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801226:	b8 67 66 66 66       	mov    $0x66666667,%eax
  80122b:	f7 e9                	imul   %ecx
  80122d:	c1 fa 02             	sar    $0x2,%edx
  801230:	89 c8                	mov    %ecx,%eax
  801232:	c1 f8 1f             	sar    $0x1f,%eax
  801235:	29 c2                	sub    %eax,%edx
  801237:	89 d0                	mov    %edx,%eax
  801239:	89 45 08             	mov    %eax,0x8(%ebp)
	} while (value % 10 != 0);
  80123c:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80123f:	b8 67 66 66 66       	mov    $0x66666667,%eax
  801244:	f7 e9                	imul   %ecx
  801246:	c1 fa 02             	sar    $0x2,%edx
  801249:	89 c8                	mov    %ecx,%eax
  80124b:	c1 f8 1f             	sar    $0x1f,%eax
  80124e:	29 c2                	sub    %eax,%edx
  801250:	89 d0                	mov    %edx,%eax
  801252:	c1 e0 02             	shl    $0x2,%eax
  801255:	01 d0                	add    %edx,%eax
  801257:	01 c0                	add    %eax,%eax
  801259:	29 c1                	sub    %eax,%ecx
  80125b:	89 ca                	mov    %ecx,%edx
  80125d:	85 d2                	test   %edx,%edx
  80125f:	75 9c                	jne    8011fd <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  801261:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  801268:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80126b:	48                   	dec    %eax
  80126c:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  80126f:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801273:	74 3d                	je     8012b2 <ltostr+0xe2>
		start = 1 ;
  801275:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  80127c:	eb 34                	jmp    8012b2 <ltostr+0xe2>
	{
		char tmp = str[start] ;
  80127e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801281:	8b 45 0c             	mov    0xc(%ebp),%eax
  801284:	01 d0                	add    %edx,%eax
  801286:	8a 00                	mov    (%eax),%al
  801288:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  80128b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80128e:	8b 45 0c             	mov    0xc(%ebp),%eax
  801291:	01 c2                	add    %eax,%edx
  801293:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  801296:	8b 45 0c             	mov    0xc(%ebp),%eax
  801299:	01 c8                	add    %ecx,%eax
  80129b:	8a 00                	mov    (%eax),%al
  80129d:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  80129f:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8012a2:	8b 45 0c             	mov    0xc(%ebp),%eax
  8012a5:	01 c2                	add    %eax,%edx
  8012a7:	8a 45 eb             	mov    -0x15(%ebp),%al
  8012aa:	88 02                	mov    %al,(%edx)
		start++ ;
  8012ac:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  8012af:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  8012b2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8012b5:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8012b8:	7c c4                	jl     80127e <ltostr+0xae>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  8012ba:	8b 55 f8             	mov    -0x8(%ebp),%edx
  8012bd:	8b 45 0c             	mov    0xc(%ebp),%eax
  8012c0:	01 d0                	add    %edx,%eax
  8012c2:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  8012c5:	90                   	nop
  8012c6:	c9                   	leave  
  8012c7:	c3                   	ret    

008012c8 <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  8012c8:	55                   	push   %ebp
  8012c9:	89 e5                	mov    %esp,%ebp
  8012cb:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  8012ce:	ff 75 08             	pushl  0x8(%ebp)
  8012d1:	e8 54 fa ff ff       	call   800d2a <strlen>
  8012d6:	83 c4 04             	add    $0x4,%esp
  8012d9:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  8012dc:	ff 75 0c             	pushl  0xc(%ebp)
  8012df:	e8 46 fa ff ff       	call   800d2a <strlen>
  8012e4:	83 c4 04             	add    $0x4,%esp
  8012e7:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  8012ea:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  8012f1:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8012f8:	eb 17                	jmp    801311 <strcconcat+0x49>
		final[s] = str1[s] ;
  8012fa:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8012fd:	8b 45 10             	mov    0x10(%ebp),%eax
  801300:	01 c2                	add    %eax,%edx
  801302:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  801305:	8b 45 08             	mov    0x8(%ebp),%eax
  801308:	01 c8                	add    %ecx,%eax
  80130a:	8a 00                	mov    (%eax),%al
  80130c:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  80130e:	ff 45 fc             	incl   -0x4(%ebp)
  801311:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801314:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  801317:	7c e1                	jl     8012fa <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  801319:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  801320:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  801327:	eb 1f                	jmp    801348 <strcconcat+0x80>
		final[s++] = str2[i] ;
  801329:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80132c:	8d 50 01             	lea    0x1(%eax),%edx
  80132f:	89 55 fc             	mov    %edx,-0x4(%ebp)
  801332:	89 c2                	mov    %eax,%edx
  801334:	8b 45 10             	mov    0x10(%ebp),%eax
  801337:	01 c2                	add    %eax,%edx
  801339:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  80133c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80133f:	01 c8                	add    %ecx,%eax
  801341:	8a 00                	mov    (%eax),%al
  801343:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  801345:	ff 45 f8             	incl   -0x8(%ebp)
  801348:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80134b:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  80134e:	7c d9                	jl     801329 <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  801350:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801353:	8b 45 10             	mov    0x10(%ebp),%eax
  801356:	01 d0                	add    %edx,%eax
  801358:	c6 00 00             	movb   $0x0,(%eax)
}
  80135b:	90                   	nop
  80135c:	c9                   	leave  
  80135d:	c3                   	ret    

0080135e <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  80135e:	55                   	push   %ebp
  80135f:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  801361:	8b 45 14             	mov    0x14(%ebp),%eax
  801364:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  80136a:	8b 45 14             	mov    0x14(%ebp),%eax
  80136d:	8b 00                	mov    (%eax),%eax
  80136f:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801376:	8b 45 10             	mov    0x10(%ebp),%eax
  801379:	01 d0                	add    %edx,%eax
  80137b:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801381:	eb 0c                	jmp    80138f <strsplit+0x31>
			*string++ = 0;
  801383:	8b 45 08             	mov    0x8(%ebp),%eax
  801386:	8d 50 01             	lea    0x1(%eax),%edx
  801389:	89 55 08             	mov    %edx,0x8(%ebp)
  80138c:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  80138f:	8b 45 08             	mov    0x8(%ebp),%eax
  801392:	8a 00                	mov    (%eax),%al
  801394:	84 c0                	test   %al,%al
  801396:	74 18                	je     8013b0 <strsplit+0x52>
  801398:	8b 45 08             	mov    0x8(%ebp),%eax
  80139b:	8a 00                	mov    (%eax),%al
  80139d:	0f be c0             	movsbl %al,%eax
  8013a0:	50                   	push   %eax
  8013a1:	ff 75 0c             	pushl  0xc(%ebp)
  8013a4:	e8 13 fb ff ff       	call   800ebc <strchr>
  8013a9:	83 c4 08             	add    $0x8,%esp
  8013ac:	85 c0                	test   %eax,%eax
  8013ae:	75 d3                	jne    801383 <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  8013b0:	8b 45 08             	mov    0x8(%ebp),%eax
  8013b3:	8a 00                	mov    (%eax),%al
  8013b5:	84 c0                	test   %al,%al
  8013b7:	74 5a                	je     801413 <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  8013b9:	8b 45 14             	mov    0x14(%ebp),%eax
  8013bc:	8b 00                	mov    (%eax),%eax
  8013be:	83 f8 0f             	cmp    $0xf,%eax
  8013c1:	75 07                	jne    8013ca <strsplit+0x6c>
		{
			return 0;
  8013c3:	b8 00 00 00 00       	mov    $0x0,%eax
  8013c8:	eb 66                	jmp    801430 <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  8013ca:	8b 45 14             	mov    0x14(%ebp),%eax
  8013cd:	8b 00                	mov    (%eax),%eax
  8013cf:	8d 48 01             	lea    0x1(%eax),%ecx
  8013d2:	8b 55 14             	mov    0x14(%ebp),%edx
  8013d5:	89 0a                	mov    %ecx,(%edx)
  8013d7:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8013de:	8b 45 10             	mov    0x10(%ebp),%eax
  8013e1:	01 c2                	add    %eax,%edx
  8013e3:	8b 45 08             	mov    0x8(%ebp),%eax
  8013e6:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  8013e8:	eb 03                	jmp    8013ed <strsplit+0x8f>
			string++;
  8013ea:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  8013ed:	8b 45 08             	mov    0x8(%ebp),%eax
  8013f0:	8a 00                	mov    (%eax),%al
  8013f2:	84 c0                	test   %al,%al
  8013f4:	74 8b                	je     801381 <strsplit+0x23>
  8013f6:	8b 45 08             	mov    0x8(%ebp),%eax
  8013f9:	8a 00                	mov    (%eax),%al
  8013fb:	0f be c0             	movsbl %al,%eax
  8013fe:	50                   	push   %eax
  8013ff:	ff 75 0c             	pushl  0xc(%ebp)
  801402:	e8 b5 fa ff ff       	call   800ebc <strchr>
  801407:	83 c4 08             	add    $0x8,%esp
  80140a:	85 c0                	test   %eax,%eax
  80140c:	74 dc                	je     8013ea <strsplit+0x8c>
			string++;
	}
  80140e:	e9 6e ff ff ff       	jmp    801381 <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  801413:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  801414:	8b 45 14             	mov    0x14(%ebp),%eax
  801417:	8b 00                	mov    (%eax),%eax
  801419:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801420:	8b 45 10             	mov    0x10(%ebp),%eax
  801423:	01 d0                	add    %edx,%eax
  801425:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  80142b:	b8 01 00 00 00       	mov    $0x1,%eax
}
  801430:	c9                   	leave  
  801431:	c3                   	ret    

00801432 <InitializeUHeap>:
//============================== GIVEN FUNCTIONS ===================================//
//==================================================================================//

int FirstTimeFlag = 1;
void InitializeUHeap()
{
  801432:	55                   	push   %ebp
  801433:	89 e5                	mov    %esp,%ebp
  801435:	83 ec 08             	sub    $0x8,%esp
	if(FirstTimeFlag)
  801438:	a1 04 40 80 00       	mov    0x804004,%eax
  80143d:	85 c0                	test   %eax,%eax
  80143f:	74 1f                	je     801460 <InitializeUHeap+0x2e>
	{
		initialize_dyn_block_system();
  801441:	e8 1d 00 00 00       	call   801463 <initialize_dyn_block_system>
		cprintf("DYNAMIC BLOCK SYSTEM IS INITIALIZED\n");
  801446:	83 ec 0c             	sub    $0xc,%esp
  801449:	68 d0 3a 80 00       	push   $0x803ad0
  80144e:	e8 55 f2 ff ff       	call   8006a8 <cprintf>
  801453:	83 c4 10             	add    $0x10,%esp
#if UHP_USE_BUDDY
		initialize_buddy();
		cprintf("BUDDY SYSTEM IS INITIALIZED\n");
#endif
		FirstTimeFlag = 0;
  801456:	c7 05 04 40 80 00 00 	movl   $0x0,0x804004
  80145d:	00 00 00 
	}
}
  801460:	90                   	nop
  801461:	c9                   	leave  
  801462:	c3                   	ret    

00801463 <initialize_dyn_block_system>:

//=================================
// [1] INITIALIZE DYNAMIC ALLOCATOR:
//=================================
void initialize_dyn_block_system()
{
  801463:	55                   	push   %ebp
  801464:	89 e5                	mov    %esp,%ebp
  801466:	83 ec 28             	sub    $0x28,%esp
	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] initialize_dyn_block_system
	// your code is here, remove the panic and write your code
	//panic("initialize_dyn_block_system() is not implemented yet...!!");

	LIST_INIT(&AllocMemBlocksList);
  801469:	c7 05 40 40 80 00 00 	movl   $0x0,0x804040
  801470:	00 00 00 
  801473:	c7 05 44 40 80 00 00 	movl   $0x0,0x804044
  80147a:	00 00 00 
  80147d:	c7 05 4c 40 80 00 00 	movl   $0x0,0x80404c
  801484:	00 00 00 
	LIST_INIT(&FreeMemBlocksList);
  801487:	c7 05 38 41 80 00 00 	movl   $0x0,0x804138
  80148e:	00 00 00 
  801491:	c7 05 3c 41 80 00 00 	movl   $0x0,0x80413c
  801498:	00 00 00 
  80149b:	c7 05 44 41 80 00 00 	movl   $0x0,0x804144
  8014a2:	00 00 00 
	MAX_MEM_BLOCK_CNT = NUM_OF_UHEAP_PAGES;
  8014a5:	c7 05 20 41 80 00 00 	movl   $0x20000,0x804120
  8014ac:	00 02 00 
	MemBlockNodes = (void*)USER_DYN_BLKS_ARRAY;
  8014af:	c7 45 f4 00 00 e0 7f 	movl   $0x7fe00000,-0xc(%ebp)
  8014b6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8014b9:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8014be:	2d 00 10 00 00       	sub    $0x1000,%eax
  8014c3:	a3 50 40 80 00       	mov    %eax,0x804050
	int size_of_block = sizeof(struct MemBlock);
  8014c8:	c7 45 f0 10 00 00 00 	movl   $0x10,-0x10(%ebp)
	int size_all_struct = size_of_block*MAX_MEM_BLOCK_CNT;
  8014cf:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8014d2:	a1 20 41 80 00       	mov    0x804120,%eax
  8014d7:	0f af c2             	imul   %edx,%eax
  8014da:	89 45 ec             	mov    %eax,-0x14(%ebp)
	size_all_struct = ROUNDUP(size_all_struct, PAGE_SIZE);
  8014dd:	c7 45 e8 00 10 00 00 	movl   $0x1000,-0x18(%ebp)
  8014e4:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8014e7:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8014ea:	01 d0                	add    %edx,%eax
  8014ec:	48                   	dec    %eax
  8014ed:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8014f0:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8014f3:	ba 00 00 00 00       	mov    $0x0,%edx
  8014f8:	f7 75 e8             	divl   -0x18(%ebp)
  8014fb:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8014fe:	29 d0                	sub    %edx,%eax
  801500:	89 45 ec             	mov    %eax,-0x14(%ebp)
	sys_allocate_chunk(USER_DYN_BLKS_ARRAY, size_all_struct,PERM_USER| PERM_WRITEABLE);
  801503:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801506:	c7 45 e0 00 00 e0 7f 	movl   $0x7fe00000,-0x20(%ebp)
  80150d:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801510:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
  801516:	81 ea 00 10 00 00    	sub    $0x1000,%edx
  80151c:	83 ec 04             	sub    $0x4,%esp
  80151f:	6a 06                	push   $0x6
  801521:	50                   	push   %eax
  801522:	52                   	push   %edx
  801523:	e8 a1 05 00 00       	call   801ac9 <sys_allocate_chunk>
  801528:	83 c4 10             	add    $0x10,%esp
	initialize_MemBlocksList(MAX_MEM_BLOCK_CNT);
  80152b:	a1 20 41 80 00       	mov    0x804120,%eax
  801530:	83 ec 0c             	sub    $0xc,%esp
  801533:	50                   	push   %eax
  801534:	e8 16 0c 00 00       	call   80214f <initialize_MemBlocksList>
  801539:	83 c4 10             	add    $0x10,%esp
	struct MemBlock* ourBlock =LIST_LAST(&AvailableMemBlocksList);
  80153c:	a1 4c 41 80 00       	mov    0x80414c,%eax
  801541:	89 45 dc             	mov    %eax,-0x24(%ebp)
	LIST_REMOVE(&AvailableMemBlocksList,ourBlock);
  801544:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  801548:	75 14                	jne    80155e <initialize_dyn_block_system+0xfb>
  80154a:	83 ec 04             	sub    $0x4,%esp
  80154d:	68 f5 3a 80 00       	push   $0x803af5
  801552:	6a 2d                	push   $0x2d
  801554:	68 13 3b 80 00       	push   $0x803b13
  801559:	e8 96 ee ff ff       	call   8003f4 <_panic>
  80155e:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801561:	8b 00                	mov    (%eax),%eax
  801563:	85 c0                	test   %eax,%eax
  801565:	74 10                	je     801577 <initialize_dyn_block_system+0x114>
  801567:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80156a:	8b 00                	mov    (%eax),%eax
  80156c:	8b 55 dc             	mov    -0x24(%ebp),%edx
  80156f:	8b 52 04             	mov    0x4(%edx),%edx
  801572:	89 50 04             	mov    %edx,0x4(%eax)
  801575:	eb 0b                	jmp    801582 <initialize_dyn_block_system+0x11f>
  801577:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80157a:	8b 40 04             	mov    0x4(%eax),%eax
  80157d:	a3 4c 41 80 00       	mov    %eax,0x80414c
  801582:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801585:	8b 40 04             	mov    0x4(%eax),%eax
  801588:	85 c0                	test   %eax,%eax
  80158a:	74 0f                	je     80159b <initialize_dyn_block_system+0x138>
  80158c:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80158f:	8b 40 04             	mov    0x4(%eax),%eax
  801592:	8b 55 dc             	mov    -0x24(%ebp),%edx
  801595:	8b 12                	mov    (%edx),%edx
  801597:	89 10                	mov    %edx,(%eax)
  801599:	eb 0a                	jmp    8015a5 <initialize_dyn_block_system+0x142>
  80159b:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80159e:	8b 00                	mov    (%eax),%eax
  8015a0:	a3 48 41 80 00       	mov    %eax,0x804148
  8015a5:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8015a8:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8015ae:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8015b1:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8015b8:	a1 54 41 80 00       	mov    0x804154,%eax
  8015bd:	48                   	dec    %eax
  8015be:	a3 54 41 80 00       	mov    %eax,0x804154
	ourBlock->size = USER_HEAP_MAX-USER_HEAP_START;
  8015c3:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8015c6:	c7 40 0c 00 00 00 20 	movl   $0x20000000,0xc(%eax)
	ourBlock->sva=USER_HEAP_START;
  8015cd:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8015d0:	c7 40 08 00 00 00 80 	movl   $0x80000000,0x8(%eax)
	LIST_INSERT_TAIL(&FreeMemBlocksList, ourBlock);
  8015d7:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  8015db:	75 14                	jne    8015f1 <initialize_dyn_block_system+0x18e>
  8015dd:	83 ec 04             	sub    $0x4,%esp
  8015e0:	68 20 3b 80 00       	push   $0x803b20
  8015e5:	6a 30                	push   $0x30
  8015e7:	68 13 3b 80 00       	push   $0x803b13
  8015ec:	e8 03 ee ff ff       	call   8003f4 <_panic>
  8015f1:	8b 15 3c 41 80 00    	mov    0x80413c,%edx
  8015f7:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8015fa:	89 50 04             	mov    %edx,0x4(%eax)
  8015fd:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801600:	8b 40 04             	mov    0x4(%eax),%eax
  801603:	85 c0                	test   %eax,%eax
  801605:	74 0c                	je     801613 <initialize_dyn_block_system+0x1b0>
  801607:	a1 3c 41 80 00       	mov    0x80413c,%eax
  80160c:	8b 55 dc             	mov    -0x24(%ebp),%edx
  80160f:	89 10                	mov    %edx,(%eax)
  801611:	eb 08                	jmp    80161b <initialize_dyn_block_system+0x1b8>
  801613:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801616:	a3 38 41 80 00       	mov    %eax,0x804138
  80161b:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80161e:	a3 3c 41 80 00       	mov    %eax,0x80413c
  801623:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801626:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80162c:	a1 44 41 80 00       	mov    0x804144,%eax
  801631:	40                   	inc    %eax
  801632:	a3 44 41 80 00       	mov    %eax,0x804144
	//[1] Initialize two lists (AllocMemBlocksList & FreeMemBlocksList) [Hint: use LIST_INIT()]
	//[2] Dynamically allocate the array of MemBlockNodes at VA USER_DYN_BLKS_ARRAY
	//	  (remember to set MAX_MEM_BLOCK_CNT with the chosen size of the array)
	//[3] Initialize AvailableMemBlocksList by filling it with the MemBlockNodes
	//[4] Insert a new MemBlock with the heap size into the FreeMemBlocksList
}
  801637:	90                   	nop
  801638:	c9                   	leave  
  801639:	c3                   	ret    

0080163a <malloc>:
//=================================
// [2] ALLOCATE SPACE IN USER HEAP:
//=================================

void* malloc(uint32 size)
{
  80163a:	55                   	push   %ebp
  80163b:	89 e5                	mov    %esp,%ebp
  80163d:	83 ec 18             	sub    $0x18,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801640:	e8 ed fd ff ff       	call   801432 <InitializeUHeap>
	if (size == 0) return NULL ;
  801645:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801649:	75 07                	jne    801652 <malloc+0x18>
  80164b:	b8 00 00 00 00       	mov    $0x0,%eax
  801650:	eb 67                	jmp    8016b9 <malloc+0x7f>

	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] malloc
	// your code is here, remove the panic and write your code
	//panic("malloc() is not implemented yet...!!");

	size = ROUNDUP(size, PAGE_SIZE);
  801652:	c7 45 f4 00 10 00 00 	movl   $0x1000,-0xc(%ebp)
  801659:	8b 55 08             	mov    0x8(%ebp),%edx
  80165c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80165f:	01 d0                	add    %edx,%eax
  801661:	48                   	dec    %eax
  801662:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801665:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801668:	ba 00 00 00 00       	mov    $0x0,%edx
  80166d:	f7 75 f4             	divl   -0xc(%ebp)
  801670:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801673:	29 d0                	sub    %edx,%eax
  801675:	89 45 08             	mov    %eax,0x8(%ebp)
	if(sys_isUHeapPlacementStrategyFIRSTFIT())
  801678:	e8 1a 08 00 00       	call   801e97 <sys_isUHeapPlacementStrategyFIRSTFIT>
  80167d:	85 c0                	test   %eax,%eax
  80167f:	74 33                	je     8016b4 <malloc+0x7a>
	{
		struct MemBlock * myBlock = alloc_block_FF(size);
  801681:	83 ec 0c             	sub    $0xc,%esp
  801684:	ff 75 08             	pushl  0x8(%ebp)
  801687:	e8 0c 0e 00 00       	call   802498 <alloc_block_FF>
  80168c:	83 c4 10             	add    $0x10,%esp
  80168f:	89 45 ec             	mov    %eax,-0x14(%ebp)
		if(myBlock != NULL)
  801692:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  801696:	74 1c                	je     8016b4 <malloc+0x7a>
		{
			insert_sorted_allocList(myBlock);
  801698:	83 ec 0c             	sub    $0xc,%esp
  80169b:	ff 75 ec             	pushl  -0x14(%ebp)
  80169e:	e8 07 0c 00 00       	call   8022aa <insert_sorted_allocList>
  8016a3:	83 c4 10             	add    $0x10,%esp
			uint32 ptr = myBlock->sva;
  8016a6:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8016a9:	8b 40 08             	mov    0x8(%eax),%eax
  8016ac:	89 45 e8             	mov    %eax,-0x18(%ebp)
			return (void *)ptr;
  8016af:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8016b2:	eb 05                	jmp    8016b9 <malloc+0x7f>
		}
	}
	return NULL;
  8016b4:	b8 00 00 00 00       	mov    $0x0,%eax
	//		to the required allocation size (space should be on 4 KB BOUNDARY)
	//	2) if no suitable space found, return NULL
	// 	3) Return pointer containing the virtual address of allocated space,
	//
	//Use sys_isUHeapPlacementStrategyFIRSTFIT()... to check the current strategy
}
  8016b9:	c9                   	leave  
  8016ba:	c3                   	ret    

008016bb <free>:
//	We can use sys_free_user_mem(uint32 virtual_address, uint32 size); which
//		switches to the kernel mode, calls free_user_mem() in
//		"kern/mem/chunk_operations.c", then switch back to the user mode here
//	the free_user_mem function is empty, make sure to implement it.
void free(void* virtual_address)
{
  8016bb:	55                   	push   %ebp
  8016bc:	89 e5                	mov    %esp,%ebp
  8016be:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] free
	// your code is here, remove the panic and write your code
	//panic("free() is not implemented yet...!!");

	uint32 virtualAddress = (uint32 )(virtual_address);
  8016c1:	8b 45 08             	mov    0x8(%ebp),%eax
  8016c4:	89 45 f4             	mov    %eax,-0xc(%ebp)
//	virtualAddress = ROUNDDOWN(virtualAddress, PAGE_SIZE);
	struct MemBlock * myBlock = find_block(&AllocMemBlocksList, virtualAddress);
  8016c7:	83 ec 08             	sub    $0x8,%esp
  8016ca:	ff 75 f4             	pushl  -0xc(%ebp)
  8016cd:	68 40 40 80 00       	push   $0x804040
  8016d2:	e8 5b 0b 00 00       	call   802232 <find_block>
  8016d7:	83 c4 10             	add    $0x10,%esp
  8016da:	89 45 f0             	mov    %eax,-0x10(%ebp)
//	cprintf ("ptr sva at free user side = %x \n", myBlock->sva);
	sys_free_user_mem(virtualAddress, myBlock->size);
  8016dd:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8016e0:	8b 40 0c             	mov    0xc(%eax),%eax
  8016e3:	83 ec 08             	sub    $0x8,%esp
  8016e6:	50                   	push   %eax
  8016e7:	ff 75 f4             	pushl  -0xc(%ebp)
  8016ea:	e8 a2 03 00 00       	call   801a91 <sys_free_user_mem>
  8016ef:	83 c4 10             	add    $0x10,%esp
	LIST_REMOVE(&AllocMemBlocksList, myBlock);
  8016f2:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8016f6:	75 14                	jne    80170c <free+0x51>
  8016f8:	83 ec 04             	sub    $0x4,%esp
  8016fb:	68 f5 3a 80 00       	push   $0x803af5
  801700:	6a 76                	push   $0x76
  801702:	68 13 3b 80 00       	push   $0x803b13
  801707:	e8 e8 ec ff ff       	call   8003f4 <_panic>
  80170c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80170f:	8b 00                	mov    (%eax),%eax
  801711:	85 c0                	test   %eax,%eax
  801713:	74 10                	je     801725 <free+0x6a>
  801715:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801718:	8b 00                	mov    (%eax),%eax
  80171a:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80171d:	8b 52 04             	mov    0x4(%edx),%edx
  801720:	89 50 04             	mov    %edx,0x4(%eax)
  801723:	eb 0b                	jmp    801730 <free+0x75>
  801725:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801728:	8b 40 04             	mov    0x4(%eax),%eax
  80172b:	a3 44 40 80 00       	mov    %eax,0x804044
  801730:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801733:	8b 40 04             	mov    0x4(%eax),%eax
  801736:	85 c0                	test   %eax,%eax
  801738:	74 0f                	je     801749 <free+0x8e>
  80173a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80173d:	8b 40 04             	mov    0x4(%eax),%eax
  801740:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801743:	8b 12                	mov    (%edx),%edx
  801745:	89 10                	mov    %edx,(%eax)
  801747:	eb 0a                	jmp    801753 <free+0x98>
  801749:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80174c:	8b 00                	mov    (%eax),%eax
  80174e:	a3 40 40 80 00       	mov    %eax,0x804040
  801753:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801756:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80175c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80175f:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  801766:	a1 4c 40 80 00       	mov    0x80404c,%eax
  80176b:	48                   	dec    %eax
  80176c:	a3 4c 40 80 00       	mov    %eax,0x80404c
	insert_sorted_with_merge_freeList(myBlock);
  801771:	83 ec 0c             	sub    $0xc,%esp
  801774:	ff 75 f0             	pushl  -0x10(%ebp)
  801777:	e8 0b 14 00 00       	call   802b87 <insert_sorted_with_merge_freeList>
  80177c:	83 c4 10             	add    $0x10,%esp

	//you should get the size of the given allocation using its address
	//you need to call sys_free_user_mem()
	//refer to the project presentation and documentation for details
}
  80177f:	90                   	nop
  801780:	c9                   	leave  
  801781:	c3                   	ret    

00801782 <smalloc>:

//=================================
// [4] ALLOCATE SHARED VARIABLE:
//=================================
void* smalloc(char *sharedVarName, uint32 size, uint8 isWritable)
{
  801782:	55                   	push   %ebp
  801783:	89 e5                	mov    %esp,%ebp
  801785:	83 ec 28             	sub    $0x28,%esp
  801788:	8b 45 10             	mov    0x10(%ebp),%eax
  80178b:	88 45 e4             	mov    %al,-0x1c(%ebp)
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  80178e:	e8 9f fc ff ff       	call   801432 <InitializeUHeap>
	if (size == 0) return NULL ;
  801793:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801797:	75 0a                	jne    8017a3 <smalloc+0x21>
  801799:	b8 00 00 00 00       	mov    $0x0,%eax
  80179e:	e9 8d 00 00 00       	jmp    801830 <smalloc+0xae>

	//This function should find the space of the required range
	// * ON 4KB BOUNDARY **** //
	//Use sys_isUHeapPlacementStrategyFIRSTFIT() to check the current strategy

	size = ROUNDUP(size, PAGE_SIZE);
  8017a3:	c7 45 f4 00 10 00 00 	movl   $0x1000,-0xc(%ebp)
  8017aa:	8b 55 0c             	mov    0xc(%ebp),%edx
  8017ad:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8017b0:	01 d0                	add    %edx,%eax
  8017b2:	48                   	dec    %eax
  8017b3:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8017b6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8017b9:	ba 00 00 00 00       	mov    $0x0,%edx
  8017be:	f7 75 f4             	divl   -0xc(%ebp)
  8017c1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8017c4:	29 d0                	sub    %edx,%eax
  8017c6:	89 45 0c             	mov    %eax,0xc(%ebp)
		if(sys_isUHeapPlacementStrategyFIRSTFIT())
  8017c9:	e8 c9 06 00 00       	call   801e97 <sys_isUHeapPlacementStrategyFIRSTFIT>
  8017ce:	85 c0                	test   %eax,%eax
  8017d0:	74 59                	je     80182b <smalloc+0xa9>
		{
			struct MemBlock * v1=NULL;
  8017d2:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
			v1= alloc_block_FF(size);
  8017d9:	83 ec 0c             	sub    $0xc,%esp
  8017dc:	ff 75 0c             	pushl  0xc(%ebp)
  8017df:	e8 b4 0c 00 00       	call   802498 <alloc_block_FF>
  8017e4:	83 c4 10             	add    $0x10,%esp
  8017e7:	89 45 ec             	mov    %eax,-0x14(%ebp)
			if(v1==NULL)
  8017ea:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8017ee:	75 07                	jne    8017f7 <smalloc+0x75>
			{
				return NULL;
  8017f0:	b8 00 00 00 00       	mov    $0x0,%eax
  8017f5:	eb 39                	jmp    801830 <smalloc+0xae>
			}
			else
			{
				int ret=sys_createSharedObject(sharedVarName,  size,  isWritable,(void*)v1->sva);
  8017f7:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8017fa:	8b 40 08             	mov    0x8(%eax),%eax
  8017fd:	89 c2                	mov    %eax,%edx
  8017ff:	0f b6 45 e4          	movzbl -0x1c(%ebp),%eax
  801803:	52                   	push   %edx
  801804:	50                   	push   %eax
  801805:	ff 75 0c             	pushl  0xc(%ebp)
  801808:	ff 75 08             	pushl  0x8(%ebp)
  80180b:	e8 0c 04 00 00       	call   801c1c <sys_createSharedObject>
  801810:	83 c4 10             	add    $0x10,%esp
  801813:	89 45 e8             	mov    %eax,-0x18(%ebp)
				if(ret>=0)
  801816:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  80181a:	78 08                	js     801824 <smalloc+0xa2>
				{
					return (void*)v1->sva;
  80181c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80181f:	8b 40 08             	mov    0x8(%eax),%eax
  801822:	eb 0c                	jmp    801830 <smalloc+0xae>
				}
				else
				{
					return NULL;
  801824:	b8 00 00 00 00       	mov    $0x0,%eax
  801829:	eb 05                	jmp    801830 <smalloc+0xae>
				}
			}

		}
		return NULL;
  80182b:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801830:	c9                   	leave  
  801831:	c3                   	ret    

00801832 <sget>:

//========================================
// [5] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
  801832:	55                   	push   %ebp
  801833:	89 e5                	mov    %esp,%ebp
  801835:	83 ec 18             	sub    $0x18,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801838:	e8 f5 fb ff ff       	call   801432 <InitializeUHeap>

	//This function should find the space for sharing the variable
	// *** ON 4KB BOUNDARY ******** //

	//Use sys_isUHeapPlacementStrategyFIRSTFIT() to check the current strategy
	int ret=sys_getSizeOfSharedObject(ownerEnvID,sharedVarName);
  80183d:	83 ec 08             	sub    $0x8,%esp
  801840:	ff 75 0c             	pushl  0xc(%ebp)
  801843:	ff 75 08             	pushl  0x8(%ebp)
  801846:	e8 fb 03 00 00       	call   801c46 <sys_getSizeOfSharedObject>
  80184b:	83 c4 10             	add    $0x10,%esp
  80184e:	89 45 f4             	mov    %eax,-0xc(%ebp)
	if(ret==0)
  801851:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801855:	75 07                	jne    80185e <sget+0x2c>
	{
		return NULL;
  801857:	b8 00 00 00 00       	mov    $0x0,%eax
  80185c:	eb 64                	jmp    8018c2 <sget+0x90>
	}
	if(sys_isUHeapPlacementStrategyFIRSTFIT())
  80185e:	e8 34 06 00 00       	call   801e97 <sys_isUHeapPlacementStrategyFIRSTFIT>
  801863:	85 c0                	test   %eax,%eax
  801865:	74 56                	je     8018bd <sget+0x8b>
	{
		struct MemBlock * v1=NULL;
  801867:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
		v1= alloc_block_FF(ret);
  80186e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801871:	83 ec 0c             	sub    $0xc,%esp
  801874:	50                   	push   %eax
  801875:	e8 1e 0c 00 00       	call   802498 <alloc_block_FF>
  80187a:	83 c4 10             	add    $0x10,%esp
  80187d:	89 45 f0             	mov    %eax,-0x10(%ebp)
		if(v1==NULL)
  801880:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801884:	75 07                	jne    80188d <sget+0x5b>
		{
		return NULL;
  801886:	b8 00 00 00 00       	mov    $0x0,%eax
  80188b:	eb 35                	jmp    8018c2 <sget+0x90>
	    }
		else
		{
			int ret1=sys_getSharedObject(ownerEnvID,sharedVarName,(void*)v1->sva);
  80188d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801890:	8b 40 08             	mov    0x8(%eax),%eax
  801893:	83 ec 04             	sub    $0x4,%esp
  801896:	50                   	push   %eax
  801897:	ff 75 0c             	pushl  0xc(%ebp)
  80189a:	ff 75 08             	pushl  0x8(%ebp)
  80189d:	e8 c1 03 00 00       	call   801c63 <sys_getSharedObject>
  8018a2:	83 c4 10             	add    $0x10,%esp
  8018a5:	89 45 ec             	mov    %eax,-0x14(%ebp)
			if(ret1>=0)
  8018a8:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8018ac:	78 08                	js     8018b6 <sget+0x84>
			{
				return (void*)v1->sva;
  8018ae:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8018b1:	8b 40 08             	mov    0x8(%eax),%eax
  8018b4:	eb 0c                	jmp    8018c2 <sget+0x90>
			}
			else
			{
				return NULL;
  8018b6:	b8 00 00 00 00       	mov    $0x0,%eax
  8018bb:	eb 05                	jmp    8018c2 <sget+0x90>
			}
		}
	}
  return NULL;
  8018bd:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8018c2:	c9                   	leave  
  8018c3:	c3                   	ret    

008018c4 <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  8018c4:	55                   	push   %ebp
  8018c5:	89 e5                	mov    %esp,%ebp
  8018c7:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  8018ca:	e8 63 fb ff ff       	call   801432 <InitializeUHeap>
	//==============================================================
	// [USER HEAP - USER SIDE] realloc
	// Write your code here, remove the panic and write your code
	panic("realloc() is not implemented yet...!!");
  8018cf:	83 ec 04             	sub    $0x4,%esp
  8018d2:	68 44 3b 80 00       	push   $0x803b44
  8018d7:	68 0e 01 00 00       	push   $0x10e
  8018dc:	68 13 3b 80 00       	push   $0x803b13
  8018e1:	e8 0e eb ff ff       	call   8003f4 <_panic>

008018e6 <sfree>:
//	use sys_freeSharedObject(...); which switches to the kernel mode,
//	calls freeSharedObject(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the freeSharedObject() function is empty, make sure to implement it.

void sfree(void* virtual_address)
{
  8018e6:	55                   	push   %ebp
  8018e7:	89 e5                	mov    %esp,%ebp
  8018e9:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT MS3 - BONUS] [SHARING - USER SIDE] sfree()

	// Write your code here, remove the panic and write your code
	panic("sfree() is not implemented yet...!!");
  8018ec:	83 ec 04             	sub    $0x4,%esp
  8018ef:	68 6c 3b 80 00       	push   $0x803b6c
  8018f4:	68 22 01 00 00       	push   $0x122
  8018f9:	68 13 3b 80 00       	push   $0x803b13
  8018fe:	e8 f1 ea ff ff       	call   8003f4 <_panic>

00801903 <expand>:

//==================================================================================//
//========================== MODIFICATION FUNCTIONS ================================//
//==================================================================================//
void expand(uint32 newSize)
{
  801903:	55                   	push   %ebp
  801904:	89 e5                	mov    %esp,%ebp
  801906:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801909:	83 ec 04             	sub    $0x4,%esp
  80190c:	68 90 3b 80 00       	push   $0x803b90
  801911:	68 2d 01 00 00       	push   $0x12d
  801916:	68 13 3b 80 00       	push   $0x803b13
  80191b:	e8 d4 ea ff ff       	call   8003f4 <_panic>

00801920 <shrink>:

}
void shrink(uint32 newSize)
{
  801920:	55                   	push   %ebp
  801921:	89 e5                	mov    %esp,%ebp
  801923:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801926:	83 ec 04             	sub    $0x4,%esp
  801929:	68 90 3b 80 00       	push   $0x803b90
  80192e:	68 32 01 00 00       	push   $0x132
  801933:	68 13 3b 80 00       	push   $0x803b13
  801938:	e8 b7 ea ff ff       	call   8003f4 <_panic>

0080193d <freeHeap>:

}
void freeHeap(void* virtual_address)
{
  80193d:	55                   	push   %ebp
  80193e:	89 e5                	mov    %esp,%ebp
  801940:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801943:	83 ec 04             	sub    $0x4,%esp
  801946:	68 90 3b 80 00       	push   $0x803b90
  80194b:	68 37 01 00 00       	push   $0x137
  801950:	68 13 3b 80 00       	push   $0x803b13
  801955:	e8 9a ea ff ff       	call   8003f4 <_panic>

0080195a <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  80195a:	55                   	push   %ebp
  80195b:	89 e5                	mov    %esp,%ebp
  80195d:	57                   	push   %edi
  80195e:	56                   	push   %esi
  80195f:	53                   	push   %ebx
  801960:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801963:	8b 45 08             	mov    0x8(%ebp),%eax
  801966:	8b 55 0c             	mov    0xc(%ebp),%edx
  801969:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80196c:	8b 5d 14             	mov    0x14(%ebp),%ebx
  80196f:	8b 7d 18             	mov    0x18(%ebp),%edi
  801972:	8b 75 1c             	mov    0x1c(%ebp),%esi
  801975:	cd 30                	int    $0x30
  801977:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  80197a:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  80197d:	83 c4 10             	add    $0x10,%esp
  801980:	5b                   	pop    %ebx
  801981:	5e                   	pop    %esi
  801982:	5f                   	pop    %edi
  801983:	5d                   	pop    %ebp
  801984:	c3                   	ret    

00801985 <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  801985:	55                   	push   %ebp
  801986:	89 e5                	mov    %esp,%ebp
  801988:	83 ec 04             	sub    $0x4,%esp
  80198b:	8b 45 10             	mov    0x10(%ebp),%eax
  80198e:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  801991:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801995:	8b 45 08             	mov    0x8(%ebp),%eax
  801998:	6a 00                	push   $0x0
  80199a:	6a 00                	push   $0x0
  80199c:	52                   	push   %edx
  80199d:	ff 75 0c             	pushl  0xc(%ebp)
  8019a0:	50                   	push   %eax
  8019a1:	6a 00                	push   $0x0
  8019a3:	e8 b2 ff ff ff       	call   80195a <syscall>
  8019a8:	83 c4 18             	add    $0x18,%esp
}
  8019ab:	90                   	nop
  8019ac:	c9                   	leave  
  8019ad:	c3                   	ret    

008019ae <sys_cgetc>:

int
sys_cgetc(void)
{
  8019ae:	55                   	push   %ebp
  8019af:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  8019b1:	6a 00                	push   $0x0
  8019b3:	6a 00                	push   $0x0
  8019b5:	6a 00                	push   $0x0
  8019b7:	6a 00                	push   $0x0
  8019b9:	6a 00                	push   $0x0
  8019bb:	6a 01                	push   $0x1
  8019bd:	e8 98 ff ff ff       	call   80195a <syscall>
  8019c2:	83 c4 18             	add    $0x18,%esp
}
  8019c5:	c9                   	leave  
  8019c6:	c3                   	ret    

008019c7 <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  8019c7:	55                   	push   %ebp
  8019c8:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  8019ca:	8b 55 0c             	mov    0xc(%ebp),%edx
  8019cd:	8b 45 08             	mov    0x8(%ebp),%eax
  8019d0:	6a 00                	push   $0x0
  8019d2:	6a 00                	push   $0x0
  8019d4:	6a 00                	push   $0x0
  8019d6:	52                   	push   %edx
  8019d7:	50                   	push   %eax
  8019d8:	6a 05                	push   $0x5
  8019da:	e8 7b ff ff ff       	call   80195a <syscall>
  8019df:	83 c4 18             	add    $0x18,%esp
}
  8019e2:	c9                   	leave  
  8019e3:	c3                   	ret    

008019e4 <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  8019e4:	55                   	push   %ebp
  8019e5:	89 e5                	mov    %esp,%ebp
  8019e7:	56                   	push   %esi
  8019e8:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  8019e9:	8b 75 18             	mov    0x18(%ebp),%esi
  8019ec:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8019ef:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8019f2:	8b 55 0c             	mov    0xc(%ebp),%edx
  8019f5:	8b 45 08             	mov    0x8(%ebp),%eax
  8019f8:	56                   	push   %esi
  8019f9:	53                   	push   %ebx
  8019fa:	51                   	push   %ecx
  8019fb:	52                   	push   %edx
  8019fc:	50                   	push   %eax
  8019fd:	6a 06                	push   $0x6
  8019ff:	e8 56 ff ff ff       	call   80195a <syscall>
  801a04:	83 c4 18             	add    $0x18,%esp
}
  801a07:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801a0a:	5b                   	pop    %ebx
  801a0b:	5e                   	pop    %esi
  801a0c:	5d                   	pop    %ebp
  801a0d:	c3                   	ret    

00801a0e <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  801a0e:	55                   	push   %ebp
  801a0f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  801a11:	8b 55 0c             	mov    0xc(%ebp),%edx
  801a14:	8b 45 08             	mov    0x8(%ebp),%eax
  801a17:	6a 00                	push   $0x0
  801a19:	6a 00                	push   $0x0
  801a1b:	6a 00                	push   $0x0
  801a1d:	52                   	push   %edx
  801a1e:	50                   	push   %eax
  801a1f:	6a 07                	push   $0x7
  801a21:	e8 34 ff ff ff       	call   80195a <syscall>
  801a26:	83 c4 18             	add    $0x18,%esp
}
  801a29:	c9                   	leave  
  801a2a:	c3                   	ret    

00801a2b <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  801a2b:	55                   	push   %ebp
  801a2c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  801a2e:	6a 00                	push   $0x0
  801a30:	6a 00                	push   $0x0
  801a32:	6a 00                	push   $0x0
  801a34:	ff 75 0c             	pushl  0xc(%ebp)
  801a37:	ff 75 08             	pushl  0x8(%ebp)
  801a3a:	6a 08                	push   $0x8
  801a3c:	e8 19 ff ff ff       	call   80195a <syscall>
  801a41:	83 c4 18             	add    $0x18,%esp
}
  801a44:	c9                   	leave  
  801a45:	c3                   	ret    

00801a46 <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  801a46:	55                   	push   %ebp
  801a47:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  801a49:	6a 00                	push   $0x0
  801a4b:	6a 00                	push   $0x0
  801a4d:	6a 00                	push   $0x0
  801a4f:	6a 00                	push   $0x0
  801a51:	6a 00                	push   $0x0
  801a53:	6a 09                	push   $0x9
  801a55:	e8 00 ff ff ff       	call   80195a <syscall>
  801a5a:	83 c4 18             	add    $0x18,%esp
}
  801a5d:	c9                   	leave  
  801a5e:	c3                   	ret    

00801a5f <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  801a5f:	55                   	push   %ebp
  801a60:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  801a62:	6a 00                	push   $0x0
  801a64:	6a 00                	push   $0x0
  801a66:	6a 00                	push   $0x0
  801a68:	6a 00                	push   $0x0
  801a6a:	6a 00                	push   $0x0
  801a6c:	6a 0a                	push   $0xa
  801a6e:	e8 e7 fe ff ff       	call   80195a <syscall>
  801a73:	83 c4 18             	add    $0x18,%esp
}
  801a76:	c9                   	leave  
  801a77:	c3                   	ret    

00801a78 <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  801a78:	55                   	push   %ebp
  801a79:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  801a7b:	6a 00                	push   $0x0
  801a7d:	6a 00                	push   $0x0
  801a7f:	6a 00                	push   $0x0
  801a81:	6a 00                	push   $0x0
  801a83:	6a 00                	push   $0x0
  801a85:	6a 0b                	push   $0xb
  801a87:	e8 ce fe ff ff       	call   80195a <syscall>
  801a8c:	83 c4 18             	add    $0x18,%esp
}
  801a8f:	c9                   	leave  
  801a90:	c3                   	ret    

00801a91 <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  801a91:	55                   	push   %ebp
  801a92:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  801a94:	6a 00                	push   $0x0
  801a96:	6a 00                	push   $0x0
  801a98:	6a 00                	push   $0x0
  801a9a:	ff 75 0c             	pushl  0xc(%ebp)
  801a9d:	ff 75 08             	pushl  0x8(%ebp)
  801aa0:	6a 0f                	push   $0xf
  801aa2:	e8 b3 fe ff ff       	call   80195a <syscall>
  801aa7:	83 c4 18             	add    $0x18,%esp
	return;
  801aaa:	90                   	nop
}
  801aab:	c9                   	leave  
  801aac:	c3                   	ret    

00801aad <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  801aad:	55                   	push   %ebp
  801aae:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  801ab0:	6a 00                	push   $0x0
  801ab2:	6a 00                	push   $0x0
  801ab4:	6a 00                	push   $0x0
  801ab6:	ff 75 0c             	pushl  0xc(%ebp)
  801ab9:	ff 75 08             	pushl  0x8(%ebp)
  801abc:	6a 10                	push   $0x10
  801abe:	e8 97 fe ff ff       	call   80195a <syscall>
  801ac3:	83 c4 18             	add    $0x18,%esp
	return ;
  801ac6:	90                   	nop
}
  801ac7:	c9                   	leave  
  801ac8:	c3                   	ret    

00801ac9 <sys_allocate_chunk>:

void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  801ac9:	55                   	push   %ebp
  801aca:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  801acc:	6a 00                	push   $0x0
  801ace:	6a 00                	push   $0x0
  801ad0:	ff 75 10             	pushl  0x10(%ebp)
  801ad3:	ff 75 0c             	pushl  0xc(%ebp)
  801ad6:	ff 75 08             	pushl  0x8(%ebp)
  801ad9:	6a 11                	push   $0x11
  801adb:	e8 7a fe ff ff       	call   80195a <syscall>
  801ae0:	83 c4 18             	add    $0x18,%esp
	return ;
  801ae3:	90                   	nop
}
  801ae4:	c9                   	leave  
  801ae5:	c3                   	ret    

00801ae6 <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  801ae6:	55                   	push   %ebp
  801ae7:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  801ae9:	6a 00                	push   $0x0
  801aeb:	6a 00                	push   $0x0
  801aed:	6a 00                	push   $0x0
  801aef:	6a 00                	push   $0x0
  801af1:	6a 00                	push   $0x0
  801af3:	6a 0c                	push   $0xc
  801af5:	e8 60 fe ff ff       	call   80195a <syscall>
  801afa:	83 c4 18             	add    $0x18,%esp
}
  801afd:	c9                   	leave  
  801afe:	c3                   	ret    

00801aff <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  801aff:	55                   	push   %ebp
  801b00:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  801b02:	6a 00                	push   $0x0
  801b04:	6a 00                	push   $0x0
  801b06:	6a 00                	push   $0x0
  801b08:	6a 00                	push   $0x0
  801b0a:	ff 75 08             	pushl  0x8(%ebp)
  801b0d:	6a 0d                	push   $0xd
  801b0f:	e8 46 fe ff ff       	call   80195a <syscall>
  801b14:	83 c4 18             	add    $0x18,%esp
}
  801b17:	c9                   	leave  
  801b18:	c3                   	ret    

00801b19 <sys_scarce_memory>:

void sys_scarce_memory()
{
  801b19:	55                   	push   %ebp
  801b1a:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  801b1c:	6a 00                	push   $0x0
  801b1e:	6a 00                	push   $0x0
  801b20:	6a 00                	push   $0x0
  801b22:	6a 00                	push   $0x0
  801b24:	6a 00                	push   $0x0
  801b26:	6a 0e                	push   $0xe
  801b28:	e8 2d fe ff ff       	call   80195a <syscall>
  801b2d:	83 c4 18             	add    $0x18,%esp
}
  801b30:	90                   	nop
  801b31:	c9                   	leave  
  801b32:	c3                   	ret    

00801b33 <sys_disable_interrupt>:

//NEW !! 2012...
void
sys_disable_interrupt()
{
  801b33:	55                   	push   %ebp
  801b34:	89 e5                	mov    %esp,%ebp
	syscall(SYS_disableINTR,0, 0, 0, 0, 0);
  801b36:	6a 00                	push   $0x0
  801b38:	6a 00                	push   $0x0
  801b3a:	6a 00                	push   $0x0
  801b3c:	6a 00                	push   $0x0
  801b3e:	6a 00                	push   $0x0
  801b40:	6a 13                	push   $0x13
  801b42:	e8 13 fe ff ff       	call   80195a <syscall>
  801b47:	83 c4 18             	add    $0x18,%esp
}
  801b4a:	90                   	nop
  801b4b:	c9                   	leave  
  801b4c:	c3                   	ret    

00801b4d <sys_enable_interrupt>:


void
sys_enable_interrupt()
{
  801b4d:	55                   	push   %ebp
  801b4e:	89 e5                	mov    %esp,%ebp
	syscall(SYS_enableINTR,0, 0, 0, 0, 0);
  801b50:	6a 00                	push   $0x0
  801b52:	6a 00                	push   $0x0
  801b54:	6a 00                	push   $0x0
  801b56:	6a 00                	push   $0x0
  801b58:	6a 00                	push   $0x0
  801b5a:	6a 14                	push   $0x14
  801b5c:	e8 f9 fd ff ff       	call   80195a <syscall>
  801b61:	83 c4 18             	add    $0x18,%esp
}
  801b64:	90                   	nop
  801b65:	c9                   	leave  
  801b66:	c3                   	ret    

00801b67 <sys_cputc>:


void
sys_cputc(const char c)
{
  801b67:	55                   	push   %ebp
  801b68:	89 e5                	mov    %esp,%ebp
  801b6a:	83 ec 04             	sub    $0x4,%esp
  801b6d:	8b 45 08             	mov    0x8(%ebp),%eax
  801b70:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  801b73:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801b77:	6a 00                	push   $0x0
  801b79:	6a 00                	push   $0x0
  801b7b:	6a 00                	push   $0x0
  801b7d:	6a 00                	push   $0x0
  801b7f:	50                   	push   %eax
  801b80:	6a 15                	push   $0x15
  801b82:	e8 d3 fd ff ff       	call   80195a <syscall>
  801b87:	83 c4 18             	add    $0x18,%esp
}
  801b8a:	90                   	nop
  801b8b:	c9                   	leave  
  801b8c:	c3                   	ret    

00801b8d <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  801b8d:	55                   	push   %ebp
  801b8e:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  801b90:	6a 00                	push   $0x0
  801b92:	6a 00                	push   $0x0
  801b94:	6a 00                	push   $0x0
  801b96:	6a 00                	push   $0x0
  801b98:	6a 00                	push   $0x0
  801b9a:	6a 16                	push   $0x16
  801b9c:	e8 b9 fd ff ff       	call   80195a <syscall>
  801ba1:	83 c4 18             	add    $0x18,%esp
}
  801ba4:	90                   	nop
  801ba5:	c9                   	leave  
  801ba6:	c3                   	ret    

00801ba7 <sys_createSemaphore>:

int
sys_createSemaphore(char* semaphoreName, uint32 initialValue)
{
  801ba7:	55                   	push   %ebp
  801ba8:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_semaphore,(uint32)semaphoreName, (uint32)initialValue, 0, 0, 0);
  801baa:	8b 45 08             	mov    0x8(%ebp),%eax
  801bad:	6a 00                	push   $0x0
  801baf:	6a 00                	push   $0x0
  801bb1:	6a 00                	push   $0x0
  801bb3:	ff 75 0c             	pushl  0xc(%ebp)
  801bb6:	50                   	push   %eax
  801bb7:	6a 17                	push   $0x17
  801bb9:	e8 9c fd ff ff       	call   80195a <syscall>
  801bbe:	83 c4 18             	add    $0x18,%esp
}
  801bc1:	c9                   	leave  
  801bc2:	c3                   	ret    

00801bc3 <sys_getSemaphoreValue>:

int
sys_getSemaphoreValue(int32 ownerEnvID, char* semaphoreName)
{
  801bc3:	55                   	push   %ebp
  801bc4:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_semaphore_value,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801bc6:	8b 55 0c             	mov    0xc(%ebp),%edx
  801bc9:	8b 45 08             	mov    0x8(%ebp),%eax
  801bcc:	6a 00                	push   $0x0
  801bce:	6a 00                	push   $0x0
  801bd0:	6a 00                	push   $0x0
  801bd2:	52                   	push   %edx
  801bd3:	50                   	push   %eax
  801bd4:	6a 1a                	push   $0x1a
  801bd6:	e8 7f fd ff ff       	call   80195a <syscall>
  801bdb:	83 c4 18             	add    $0x18,%esp
}
  801bde:	c9                   	leave  
  801bdf:	c3                   	ret    

00801be0 <sys_waitSemaphore>:

void
sys_waitSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  801be0:	55                   	push   %ebp
  801be1:	89 e5                	mov    %esp,%ebp
	syscall(SYS_wait_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801be3:	8b 55 0c             	mov    0xc(%ebp),%edx
  801be6:	8b 45 08             	mov    0x8(%ebp),%eax
  801be9:	6a 00                	push   $0x0
  801beb:	6a 00                	push   $0x0
  801bed:	6a 00                	push   $0x0
  801bef:	52                   	push   %edx
  801bf0:	50                   	push   %eax
  801bf1:	6a 18                	push   $0x18
  801bf3:	e8 62 fd ff ff       	call   80195a <syscall>
  801bf8:	83 c4 18             	add    $0x18,%esp
}
  801bfb:	90                   	nop
  801bfc:	c9                   	leave  
  801bfd:	c3                   	ret    

00801bfe <sys_signalSemaphore>:

void
sys_signalSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  801bfe:	55                   	push   %ebp
  801bff:	89 e5                	mov    %esp,%ebp
	syscall(SYS_signal_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801c01:	8b 55 0c             	mov    0xc(%ebp),%edx
  801c04:	8b 45 08             	mov    0x8(%ebp),%eax
  801c07:	6a 00                	push   $0x0
  801c09:	6a 00                	push   $0x0
  801c0b:	6a 00                	push   $0x0
  801c0d:	52                   	push   %edx
  801c0e:	50                   	push   %eax
  801c0f:	6a 19                	push   $0x19
  801c11:	e8 44 fd ff ff       	call   80195a <syscall>
  801c16:	83 c4 18             	add    $0x18,%esp
}
  801c19:	90                   	nop
  801c1a:	c9                   	leave  
  801c1b:	c3                   	ret    

00801c1c <sys_createSharedObject>:

int
sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  801c1c:	55                   	push   %ebp
  801c1d:	89 e5                	mov    %esp,%ebp
  801c1f:	83 ec 04             	sub    $0x4,%esp
  801c22:	8b 45 10             	mov    0x10(%ebp),%eax
  801c25:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  801c28:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801c2b:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801c2f:	8b 45 08             	mov    0x8(%ebp),%eax
  801c32:	6a 00                	push   $0x0
  801c34:	51                   	push   %ecx
  801c35:	52                   	push   %edx
  801c36:	ff 75 0c             	pushl  0xc(%ebp)
  801c39:	50                   	push   %eax
  801c3a:	6a 1b                	push   $0x1b
  801c3c:	e8 19 fd ff ff       	call   80195a <syscall>
  801c41:	83 c4 18             	add    $0x18,%esp
}
  801c44:	c9                   	leave  
  801c45:	c3                   	ret    

00801c46 <sys_getSizeOfSharedObject>:

//2017:
int
sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  801c46:	55                   	push   %ebp
  801c47:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  801c49:	8b 55 0c             	mov    0xc(%ebp),%edx
  801c4c:	8b 45 08             	mov    0x8(%ebp),%eax
  801c4f:	6a 00                	push   $0x0
  801c51:	6a 00                	push   $0x0
  801c53:	6a 00                	push   $0x0
  801c55:	52                   	push   %edx
  801c56:	50                   	push   %eax
  801c57:	6a 1c                	push   $0x1c
  801c59:	e8 fc fc ff ff       	call   80195a <syscall>
  801c5e:	83 c4 18             	add    $0x18,%esp
}
  801c61:	c9                   	leave  
  801c62:	c3                   	ret    

00801c63 <sys_getSharedObject>:
//==========

int
sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  801c63:	55                   	push   %ebp
  801c64:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  801c66:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801c69:	8b 55 0c             	mov    0xc(%ebp),%edx
  801c6c:	8b 45 08             	mov    0x8(%ebp),%eax
  801c6f:	6a 00                	push   $0x0
  801c71:	6a 00                	push   $0x0
  801c73:	51                   	push   %ecx
  801c74:	52                   	push   %edx
  801c75:	50                   	push   %eax
  801c76:	6a 1d                	push   $0x1d
  801c78:	e8 dd fc ff ff       	call   80195a <syscall>
  801c7d:	83 c4 18             	add    $0x18,%esp
}
  801c80:	c9                   	leave  
  801c81:	c3                   	ret    

00801c82 <sys_freeSharedObject>:

int
sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  801c82:	55                   	push   %ebp
  801c83:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  801c85:	8b 55 0c             	mov    0xc(%ebp),%edx
  801c88:	8b 45 08             	mov    0x8(%ebp),%eax
  801c8b:	6a 00                	push   $0x0
  801c8d:	6a 00                	push   $0x0
  801c8f:	6a 00                	push   $0x0
  801c91:	52                   	push   %edx
  801c92:	50                   	push   %eax
  801c93:	6a 1e                	push   $0x1e
  801c95:	e8 c0 fc ff ff       	call   80195a <syscall>
  801c9a:	83 c4 18             	add    $0x18,%esp
}
  801c9d:	c9                   	leave  
  801c9e:	c3                   	ret    

00801c9f <sys_getMaxShares>:

uint32 	sys_getMaxShares()
{
  801c9f:	55                   	push   %ebp
  801ca0:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_max_shares,0, 0, 0, 0, 0);
  801ca2:	6a 00                	push   $0x0
  801ca4:	6a 00                	push   $0x0
  801ca6:	6a 00                	push   $0x0
  801ca8:	6a 00                	push   $0x0
  801caa:	6a 00                	push   $0x0
  801cac:	6a 1f                	push   $0x1f
  801cae:	e8 a7 fc ff ff       	call   80195a <syscall>
  801cb3:	83 c4 18             	add    $0x18,%esp
}
  801cb6:	c9                   	leave  
  801cb7:	c3                   	ret    

00801cb8 <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  801cb8:	55                   	push   %ebp
  801cb9:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  801cbb:	8b 45 08             	mov    0x8(%ebp),%eax
  801cbe:	6a 00                	push   $0x0
  801cc0:	ff 75 14             	pushl  0x14(%ebp)
  801cc3:	ff 75 10             	pushl  0x10(%ebp)
  801cc6:	ff 75 0c             	pushl  0xc(%ebp)
  801cc9:	50                   	push   %eax
  801cca:	6a 20                	push   $0x20
  801ccc:	e8 89 fc ff ff       	call   80195a <syscall>
  801cd1:	83 c4 18             	add    $0x18,%esp
}
  801cd4:	c9                   	leave  
  801cd5:	c3                   	ret    

00801cd6 <sys_run_env>:

void
sys_run_env(int32 envId)
{
  801cd6:	55                   	push   %ebp
  801cd7:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  801cd9:	8b 45 08             	mov    0x8(%ebp),%eax
  801cdc:	6a 00                	push   $0x0
  801cde:	6a 00                	push   $0x0
  801ce0:	6a 00                	push   $0x0
  801ce2:	6a 00                	push   $0x0
  801ce4:	50                   	push   %eax
  801ce5:	6a 21                	push   $0x21
  801ce7:	e8 6e fc ff ff       	call   80195a <syscall>
  801cec:	83 c4 18             	add    $0x18,%esp
}
  801cef:	90                   	nop
  801cf0:	c9                   	leave  
  801cf1:	c3                   	ret    

00801cf2 <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  801cf2:	55                   	push   %ebp
  801cf3:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  801cf5:	8b 45 08             	mov    0x8(%ebp),%eax
  801cf8:	6a 00                	push   $0x0
  801cfa:	6a 00                	push   $0x0
  801cfc:	6a 00                	push   $0x0
  801cfe:	6a 00                	push   $0x0
  801d00:	50                   	push   %eax
  801d01:	6a 22                	push   $0x22
  801d03:	e8 52 fc ff ff       	call   80195a <syscall>
  801d08:	83 c4 18             	add    $0x18,%esp
}
  801d0b:	c9                   	leave  
  801d0c:	c3                   	ret    

00801d0d <sys_getenvid>:

int32 sys_getenvid(void)
{
  801d0d:	55                   	push   %ebp
  801d0e:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  801d10:	6a 00                	push   $0x0
  801d12:	6a 00                	push   $0x0
  801d14:	6a 00                	push   $0x0
  801d16:	6a 00                	push   $0x0
  801d18:	6a 00                	push   $0x0
  801d1a:	6a 02                	push   $0x2
  801d1c:	e8 39 fc ff ff       	call   80195a <syscall>
  801d21:	83 c4 18             	add    $0x18,%esp
}
  801d24:	c9                   	leave  
  801d25:	c3                   	ret    

00801d26 <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  801d26:	55                   	push   %ebp
  801d27:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  801d29:	6a 00                	push   $0x0
  801d2b:	6a 00                	push   $0x0
  801d2d:	6a 00                	push   $0x0
  801d2f:	6a 00                	push   $0x0
  801d31:	6a 00                	push   $0x0
  801d33:	6a 03                	push   $0x3
  801d35:	e8 20 fc ff ff       	call   80195a <syscall>
  801d3a:	83 c4 18             	add    $0x18,%esp
}
  801d3d:	c9                   	leave  
  801d3e:	c3                   	ret    

00801d3f <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  801d3f:	55                   	push   %ebp
  801d40:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  801d42:	6a 00                	push   $0x0
  801d44:	6a 00                	push   $0x0
  801d46:	6a 00                	push   $0x0
  801d48:	6a 00                	push   $0x0
  801d4a:	6a 00                	push   $0x0
  801d4c:	6a 04                	push   $0x4
  801d4e:	e8 07 fc ff ff       	call   80195a <syscall>
  801d53:	83 c4 18             	add    $0x18,%esp
}
  801d56:	c9                   	leave  
  801d57:	c3                   	ret    

00801d58 <sys_exit_env>:


void sys_exit_env(void)
{
  801d58:	55                   	push   %ebp
  801d59:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  801d5b:	6a 00                	push   $0x0
  801d5d:	6a 00                	push   $0x0
  801d5f:	6a 00                	push   $0x0
  801d61:	6a 00                	push   $0x0
  801d63:	6a 00                	push   $0x0
  801d65:	6a 23                	push   $0x23
  801d67:	e8 ee fb ff ff       	call   80195a <syscall>
  801d6c:	83 c4 18             	add    $0x18,%esp
}
  801d6f:	90                   	nop
  801d70:	c9                   	leave  
  801d71:	c3                   	ret    

00801d72 <sys_get_virtual_time>:


struct uint64
sys_get_virtual_time()
{
  801d72:	55                   	push   %ebp
  801d73:	89 e5                	mov    %esp,%ebp
  801d75:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  801d78:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801d7b:	8d 50 04             	lea    0x4(%eax),%edx
  801d7e:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801d81:	6a 00                	push   $0x0
  801d83:	6a 00                	push   $0x0
  801d85:	6a 00                	push   $0x0
  801d87:	52                   	push   %edx
  801d88:	50                   	push   %eax
  801d89:	6a 24                	push   $0x24
  801d8b:	e8 ca fb ff ff       	call   80195a <syscall>
  801d90:	83 c4 18             	add    $0x18,%esp
	return result;
  801d93:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801d96:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801d99:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801d9c:	89 01                	mov    %eax,(%ecx)
  801d9e:	89 51 04             	mov    %edx,0x4(%ecx)
}
  801da1:	8b 45 08             	mov    0x8(%ebp),%eax
  801da4:	c9                   	leave  
  801da5:	c2 04 00             	ret    $0x4

00801da8 <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  801da8:	55                   	push   %ebp
  801da9:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  801dab:	6a 00                	push   $0x0
  801dad:	6a 00                	push   $0x0
  801daf:	ff 75 10             	pushl  0x10(%ebp)
  801db2:	ff 75 0c             	pushl  0xc(%ebp)
  801db5:	ff 75 08             	pushl  0x8(%ebp)
  801db8:	6a 12                	push   $0x12
  801dba:	e8 9b fb ff ff       	call   80195a <syscall>
  801dbf:	83 c4 18             	add    $0x18,%esp
	return ;
  801dc2:	90                   	nop
}
  801dc3:	c9                   	leave  
  801dc4:	c3                   	ret    

00801dc5 <sys_rcr2>:
uint32 sys_rcr2()
{
  801dc5:	55                   	push   %ebp
  801dc6:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  801dc8:	6a 00                	push   $0x0
  801dca:	6a 00                	push   $0x0
  801dcc:	6a 00                	push   $0x0
  801dce:	6a 00                	push   $0x0
  801dd0:	6a 00                	push   $0x0
  801dd2:	6a 25                	push   $0x25
  801dd4:	e8 81 fb ff ff       	call   80195a <syscall>
  801dd9:	83 c4 18             	add    $0x18,%esp
}
  801ddc:	c9                   	leave  
  801ddd:	c3                   	ret    

00801dde <sys_bypassPageFault>:
void sys_bypassPageFault(uint8 instrLength)
{
  801dde:	55                   	push   %ebp
  801ddf:	89 e5                	mov    %esp,%ebp
  801de1:	83 ec 04             	sub    $0x4,%esp
  801de4:	8b 45 08             	mov    0x8(%ebp),%eax
  801de7:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  801dea:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  801dee:	6a 00                	push   $0x0
  801df0:	6a 00                	push   $0x0
  801df2:	6a 00                	push   $0x0
  801df4:	6a 00                	push   $0x0
  801df6:	50                   	push   %eax
  801df7:	6a 26                	push   $0x26
  801df9:	e8 5c fb ff ff       	call   80195a <syscall>
  801dfe:	83 c4 18             	add    $0x18,%esp
	return ;
  801e01:	90                   	nop
}
  801e02:	c9                   	leave  
  801e03:	c3                   	ret    

00801e04 <rsttst>:
void rsttst()
{
  801e04:	55                   	push   %ebp
  801e05:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  801e07:	6a 00                	push   $0x0
  801e09:	6a 00                	push   $0x0
  801e0b:	6a 00                	push   $0x0
  801e0d:	6a 00                	push   $0x0
  801e0f:	6a 00                	push   $0x0
  801e11:	6a 28                	push   $0x28
  801e13:	e8 42 fb ff ff       	call   80195a <syscall>
  801e18:	83 c4 18             	add    $0x18,%esp
	return ;
  801e1b:	90                   	nop
}
  801e1c:	c9                   	leave  
  801e1d:	c3                   	ret    

00801e1e <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  801e1e:	55                   	push   %ebp
  801e1f:	89 e5                	mov    %esp,%ebp
  801e21:	83 ec 04             	sub    $0x4,%esp
  801e24:	8b 45 14             	mov    0x14(%ebp),%eax
  801e27:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  801e2a:	8b 55 18             	mov    0x18(%ebp),%edx
  801e2d:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801e31:	52                   	push   %edx
  801e32:	50                   	push   %eax
  801e33:	ff 75 10             	pushl  0x10(%ebp)
  801e36:	ff 75 0c             	pushl  0xc(%ebp)
  801e39:	ff 75 08             	pushl  0x8(%ebp)
  801e3c:	6a 27                	push   $0x27
  801e3e:	e8 17 fb ff ff       	call   80195a <syscall>
  801e43:	83 c4 18             	add    $0x18,%esp
	return ;
  801e46:	90                   	nop
}
  801e47:	c9                   	leave  
  801e48:	c3                   	ret    

00801e49 <chktst>:
void chktst(uint32 n)
{
  801e49:	55                   	push   %ebp
  801e4a:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  801e4c:	6a 00                	push   $0x0
  801e4e:	6a 00                	push   $0x0
  801e50:	6a 00                	push   $0x0
  801e52:	6a 00                	push   $0x0
  801e54:	ff 75 08             	pushl  0x8(%ebp)
  801e57:	6a 29                	push   $0x29
  801e59:	e8 fc fa ff ff       	call   80195a <syscall>
  801e5e:	83 c4 18             	add    $0x18,%esp
	return ;
  801e61:	90                   	nop
}
  801e62:	c9                   	leave  
  801e63:	c3                   	ret    

00801e64 <inctst>:

void inctst()
{
  801e64:	55                   	push   %ebp
  801e65:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  801e67:	6a 00                	push   $0x0
  801e69:	6a 00                	push   $0x0
  801e6b:	6a 00                	push   $0x0
  801e6d:	6a 00                	push   $0x0
  801e6f:	6a 00                	push   $0x0
  801e71:	6a 2a                	push   $0x2a
  801e73:	e8 e2 fa ff ff       	call   80195a <syscall>
  801e78:	83 c4 18             	add    $0x18,%esp
	return ;
  801e7b:	90                   	nop
}
  801e7c:	c9                   	leave  
  801e7d:	c3                   	ret    

00801e7e <gettst>:
uint32 gettst()
{
  801e7e:	55                   	push   %ebp
  801e7f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  801e81:	6a 00                	push   $0x0
  801e83:	6a 00                	push   $0x0
  801e85:	6a 00                	push   $0x0
  801e87:	6a 00                	push   $0x0
  801e89:	6a 00                	push   $0x0
  801e8b:	6a 2b                	push   $0x2b
  801e8d:	e8 c8 fa ff ff       	call   80195a <syscall>
  801e92:	83 c4 18             	add    $0x18,%esp
}
  801e95:	c9                   	leave  
  801e96:	c3                   	ret    

00801e97 <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  801e97:	55                   	push   %ebp
  801e98:	89 e5                	mov    %esp,%ebp
  801e9a:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801e9d:	6a 00                	push   $0x0
  801e9f:	6a 00                	push   $0x0
  801ea1:	6a 00                	push   $0x0
  801ea3:	6a 00                	push   $0x0
  801ea5:	6a 00                	push   $0x0
  801ea7:	6a 2c                	push   $0x2c
  801ea9:	e8 ac fa ff ff       	call   80195a <syscall>
  801eae:	83 c4 18             	add    $0x18,%esp
  801eb1:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  801eb4:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  801eb8:	75 07                	jne    801ec1 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  801eba:	b8 01 00 00 00       	mov    $0x1,%eax
  801ebf:	eb 05                	jmp    801ec6 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  801ec1:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801ec6:	c9                   	leave  
  801ec7:	c3                   	ret    

00801ec8 <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  801ec8:	55                   	push   %ebp
  801ec9:	89 e5                	mov    %esp,%ebp
  801ecb:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801ece:	6a 00                	push   $0x0
  801ed0:	6a 00                	push   $0x0
  801ed2:	6a 00                	push   $0x0
  801ed4:	6a 00                	push   $0x0
  801ed6:	6a 00                	push   $0x0
  801ed8:	6a 2c                	push   $0x2c
  801eda:	e8 7b fa ff ff       	call   80195a <syscall>
  801edf:	83 c4 18             	add    $0x18,%esp
  801ee2:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  801ee5:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  801ee9:	75 07                	jne    801ef2 <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  801eeb:	b8 01 00 00 00       	mov    $0x1,%eax
  801ef0:	eb 05                	jmp    801ef7 <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  801ef2:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801ef7:	c9                   	leave  
  801ef8:	c3                   	ret    

00801ef9 <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  801ef9:	55                   	push   %ebp
  801efa:	89 e5                	mov    %esp,%ebp
  801efc:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801eff:	6a 00                	push   $0x0
  801f01:	6a 00                	push   $0x0
  801f03:	6a 00                	push   $0x0
  801f05:	6a 00                	push   $0x0
  801f07:	6a 00                	push   $0x0
  801f09:	6a 2c                	push   $0x2c
  801f0b:	e8 4a fa ff ff       	call   80195a <syscall>
  801f10:	83 c4 18             	add    $0x18,%esp
  801f13:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  801f16:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  801f1a:	75 07                	jne    801f23 <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  801f1c:	b8 01 00 00 00       	mov    $0x1,%eax
  801f21:	eb 05                	jmp    801f28 <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  801f23:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801f28:	c9                   	leave  
  801f29:	c3                   	ret    

00801f2a <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  801f2a:	55                   	push   %ebp
  801f2b:	89 e5                	mov    %esp,%ebp
  801f2d:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801f30:	6a 00                	push   $0x0
  801f32:	6a 00                	push   $0x0
  801f34:	6a 00                	push   $0x0
  801f36:	6a 00                	push   $0x0
  801f38:	6a 00                	push   $0x0
  801f3a:	6a 2c                	push   $0x2c
  801f3c:	e8 19 fa ff ff       	call   80195a <syscall>
  801f41:	83 c4 18             	add    $0x18,%esp
  801f44:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  801f47:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  801f4b:	75 07                	jne    801f54 <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  801f4d:	b8 01 00 00 00       	mov    $0x1,%eax
  801f52:	eb 05                	jmp    801f59 <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  801f54:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801f59:	c9                   	leave  
  801f5a:	c3                   	ret    

00801f5b <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  801f5b:	55                   	push   %ebp
  801f5c:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  801f5e:	6a 00                	push   $0x0
  801f60:	6a 00                	push   $0x0
  801f62:	6a 00                	push   $0x0
  801f64:	6a 00                	push   $0x0
  801f66:	ff 75 08             	pushl  0x8(%ebp)
  801f69:	6a 2d                	push   $0x2d
  801f6b:	e8 ea f9 ff ff       	call   80195a <syscall>
  801f70:	83 c4 18             	add    $0x18,%esp
	return ;
  801f73:	90                   	nop
}
  801f74:	c9                   	leave  
  801f75:	c3                   	ret    

00801f76 <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  801f76:	55                   	push   %ebp
  801f77:	89 e5                	mov    %esp,%ebp
  801f79:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  801f7a:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801f7d:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801f80:	8b 55 0c             	mov    0xc(%ebp),%edx
  801f83:	8b 45 08             	mov    0x8(%ebp),%eax
  801f86:	6a 00                	push   $0x0
  801f88:	53                   	push   %ebx
  801f89:	51                   	push   %ecx
  801f8a:	52                   	push   %edx
  801f8b:	50                   	push   %eax
  801f8c:	6a 2e                	push   $0x2e
  801f8e:	e8 c7 f9 ff ff       	call   80195a <syscall>
  801f93:	83 c4 18             	add    $0x18,%esp
}
  801f96:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801f99:	c9                   	leave  
  801f9a:	c3                   	ret    

00801f9b <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  801f9b:	55                   	push   %ebp
  801f9c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  801f9e:	8b 55 0c             	mov    0xc(%ebp),%edx
  801fa1:	8b 45 08             	mov    0x8(%ebp),%eax
  801fa4:	6a 00                	push   $0x0
  801fa6:	6a 00                	push   $0x0
  801fa8:	6a 00                	push   $0x0
  801faa:	52                   	push   %edx
  801fab:	50                   	push   %eax
  801fac:	6a 2f                	push   $0x2f
  801fae:	e8 a7 f9 ff ff       	call   80195a <syscall>
  801fb3:	83 c4 18             	add    $0x18,%esp
}
  801fb6:	c9                   	leave  
  801fb7:	c3                   	ret    

00801fb8 <print_mem_block_lists>:
//===========================
// PRINT MEM BLOCK LISTS:
//===========================

void print_mem_block_lists()
{
  801fb8:	55                   	push   %ebp
  801fb9:	89 e5                	mov    %esp,%ebp
  801fbb:	83 ec 18             	sub    $0x18,%esp
	cprintf("\n=========================================\n");
  801fbe:	83 ec 0c             	sub    $0xc,%esp
  801fc1:	68 a0 3b 80 00       	push   $0x803ba0
  801fc6:	e8 dd e6 ff ff       	call   8006a8 <cprintf>
  801fcb:	83 c4 10             	add    $0x10,%esp
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
  801fce:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nFreeMemBlocksList:\n");
  801fd5:	83 ec 0c             	sub    $0xc,%esp
  801fd8:	68 cc 3b 80 00       	push   $0x803bcc
  801fdd:	e8 c6 e6 ff ff       	call   8006a8 <cprintf>
  801fe2:	83 c4 10             	add    $0x10,%esp
	uint8 sorted = 1 ;
  801fe5:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &FreeMemBlocksList)
  801fe9:	a1 38 41 80 00       	mov    0x804138,%eax
  801fee:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801ff1:	eb 56                	jmp    802049 <print_mem_block_lists+0x91>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  801ff3:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801ff7:	74 1c                	je     802015 <print_mem_block_lists+0x5d>
  801ff9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801ffc:	8b 50 08             	mov    0x8(%eax),%edx
  801fff:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802002:	8b 48 08             	mov    0x8(%eax),%ecx
  802005:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802008:	8b 40 0c             	mov    0xc(%eax),%eax
  80200b:	01 c8                	add    %ecx,%eax
  80200d:	39 c2                	cmp    %eax,%edx
  80200f:	73 04                	jae    802015 <print_mem_block_lists+0x5d>
			sorted = 0 ;
  802011:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  802015:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802018:	8b 50 08             	mov    0x8(%eax),%edx
  80201b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80201e:	8b 40 0c             	mov    0xc(%eax),%eax
  802021:	01 c2                	add    %eax,%edx
  802023:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802026:	8b 40 08             	mov    0x8(%eax),%eax
  802029:	83 ec 04             	sub    $0x4,%esp
  80202c:	52                   	push   %edx
  80202d:	50                   	push   %eax
  80202e:	68 e1 3b 80 00       	push   $0x803be1
  802033:	e8 70 e6 ff ff       	call   8006a8 <cprintf>
  802038:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  80203b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80203e:	89 45 f0             	mov    %eax,-0x10(%ebp)
	cprintf("\n=========================================\n");
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
	cprintf("\nFreeMemBlocksList:\n");
	uint8 sorted = 1 ;
	LIST_FOREACH(blk, &FreeMemBlocksList)
  802041:	a1 40 41 80 00       	mov    0x804140,%eax
  802046:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802049:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80204d:	74 07                	je     802056 <print_mem_block_lists+0x9e>
  80204f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802052:	8b 00                	mov    (%eax),%eax
  802054:	eb 05                	jmp    80205b <print_mem_block_lists+0xa3>
  802056:	b8 00 00 00 00       	mov    $0x0,%eax
  80205b:	a3 40 41 80 00       	mov    %eax,0x804140
  802060:	a1 40 41 80 00       	mov    0x804140,%eax
  802065:	85 c0                	test   %eax,%eax
  802067:	75 8a                	jne    801ff3 <print_mem_block_lists+0x3b>
  802069:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80206d:	75 84                	jne    801ff3 <print_mem_block_lists+0x3b>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;
  80206f:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  802073:	75 10                	jne    802085 <print_mem_block_lists+0xcd>
  802075:	83 ec 0c             	sub    $0xc,%esp
  802078:	68 f0 3b 80 00       	push   $0x803bf0
  80207d:	e8 26 e6 ff ff       	call   8006a8 <cprintf>
  802082:	83 c4 10             	add    $0x10,%esp

	lastBlk = NULL ;
  802085:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nAllocMemBlocksList:\n");
  80208c:	83 ec 0c             	sub    $0xc,%esp
  80208f:	68 14 3c 80 00       	push   $0x803c14
  802094:	e8 0f e6 ff ff       	call   8006a8 <cprintf>
  802099:	83 c4 10             	add    $0x10,%esp
	sorted = 1 ;
  80209c:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &AllocMemBlocksList)
  8020a0:	a1 40 40 80 00       	mov    0x804040,%eax
  8020a5:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8020a8:	eb 56                	jmp    802100 <print_mem_block_lists+0x148>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  8020aa:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8020ae:	74 1c                	je     8020cc <print_mem_block_lists+0x114>
  8020b0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8020b3:	8b 50 08             	mov    0x8(%eax),%edx
  8020b6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8020b9:	8b 48 08             	mov    0x8(%eax),%ecx
  8020bc:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8020bf:	8b 40 0c             	mov    0xc(%eax),%eax
  8020c2:	01 c8                	add    %ecx,%eax
  8020c4:	39 c2                	cmp    %eax,%edx
  8020c6:	73 04                	jae    8020cc <print_mem_block_lists+0x114>
			sorted = 0 ;
  8020c8:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  8020cc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8020cf:	8b 50 08             	mov    0x8(%eax),%edx
  8020d2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8020d5:	8b 40 0c             	mov    0xc(%eax),%eax
  8020d8:	01 c2                	add    %eax,%edx
  8020da:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8020dd:	8b 40 08             	mov    0x8(%eax),%eax
  8020e0:	83 ec 04             	sub    $0x4,%esp
  8020e3:	52                   	push   %edx
  8020e4:	50                   	push   %eax
  8020e5:	68 e1 3b 80 00       	push   $0x803be1
  8020ea:	e8 b9 e5 ff ff       	call   8006a8 <cprintf>
  8020ef:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  8020f2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8020f5:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;

	lastBlk = NULL ;
	cprintf("\nAllocMemBlocksList:\n");
	sorted = 1 ;
	LIST_FOREACH(blk, &AllocMemBlocksList)
  8020f8:	a1 48 40 80 00       	mov    0x804048,%eax
  8020fd:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802100:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802104:	74 07                	je     80210d <print_mem_block_lists+0x155>
  802106:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802109:	8b 00                	mov    (%eax),%eax
  80210b:	eb 05                	jmp    802112 <print_mem_block_lists+0x15a>
  80210d:	b8 00 00 00 00       	mov    $0x0,%eax
  802112:	a3 48 40 80 00       	mov    %eax,0x804048
  802117:	a1 48 40 80 00       	mov    0x804048,%eax
  80211c:	85 c0                	test   %eax,%eax
  80211e:	75 8a                	jne    8020aa <print_mem_block_lists+0xf2>
  802120:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802124:	75 84                	jne    8020aa <print_mem_block_lists+0xf2>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nAllocMemBlocksList is NOT SORTED!!\n") ;
  802126:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  80212a:	75 10                	jne    80213c <print_mem_block_lists+0x184>
  80212c:	83 ec 0c             	sub    $0xc,%esp
  80212f:	68 2c 3c 80 00       	push   $0x803c2c
  802134:	e8 6f e5 ff ff       	call   8006a8 <cprintf>
  802139:	83 c4 10             	add    $0x10,%esp
	cprintf("\n=========================================\n");
  80213c:	83 ec 0c             	sub    $0xc,%esp
  80213f:	68 a0 3b 80 00       	push   $0x803ba0
  802144:	e8 5f e5 ff ff       	call   8006a8 <cprintf>
  802149:	83 c4 10             	add    $0x10,%esp

}
  80214c:	90                   	nop
  80214d:	c9                   	leave  
  80214e:	c3                   	ret    

0080214f <initialize_MemBlocksList>:

//===============================
// [1] INITIALIZE AVAILABLE LIST:
//===============================
void initialize_MemBlocksList(uint32 numOfBlocks)
{
  80214f:	55                   	push   %ebp
  802150:	89 e5                	mov    %esp,%ebp
  802152:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] initialize_MemBlocksList
	// Write your code here, remove the panic and write your code
	//panic("initialize_MemBlocksList() is not implemented yet...!!");
	uint32 n = numOfBlocks;
  802155:	8b 45 08             	mov    0x8(%ebp),%eax
  802158:	89 45 f0             	mov    %eax,-0x10(%ebp)

	LIST_INIT(&AvailableMemBlocksList);
  80215b:	c7 05 48 41 80 00 00 	movl   $0x0,0x804148
  802162:	00 00 00 
  802165:	c7 05 4c 41 80 00 00 	movl   $0x0,0x80414c
  80216c:	00 00 00 
  80216f:	c7 05 54 41 80 00 00 	movl   $0x0,0x804154
  802176:	00 00 00 
	for(int i = 0; i<n;i++)
  802179:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  802180:	e9 9e 00 00 00       	jmp    802223 <initialize_MemBlocksList+0xd4>
	{
		LIST_INSERT_HEAD(&AvailableMemBlocksList, &(MemBlockNodes[i]));
  802185:	a1 50 40 80 00       	mov    0x804050,%eax
  80218a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80218d:	c1 e2 04             	shl    $0x4,%edx
  802190:	01 d0                	add    %edx,%eax
  802192:	85 c0                	test   %eax,%eax
  802194:	75 14                	jne    8021aa <initialize_MemBlocksList+0x5b>
  802196:	83 ec 04             	sub    $0x4,%esp
  802199:	68 54 3c 80 00       	push   $0x803c54
  80219e:	6a 47                	push   $0x47
  8021a0:	68 77 3c 80 00       	push   $0x803c77
  8021a5:	e8 4a e2 ff ff       	call   8003f4 <_panic>
  8021aa:	a1 50 40 80 00       	mov    0x804050,%eax
  8021af:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8021b2:	c1 e2 04             	shl    $0x4,%edx
  8021b5:	01 d0                	add    %edx,%eax
  8021b7:	8b 15 48 41 80 00    	mov    0x804148,%edx
  8021bd:	89 10                	mov    %edx,(%eax)
  8021bf:	8b 00                	mov    (%eax),%eax
  8021c1:	85 c0                	test   %eax,%eax
  8021c3:	74 18                	je     8021dd <initialize_MemBlocksList+0x8e>
  8021c5:	a1 48 41 80 00       	mov    0x804148,%eax
  8021ca:	8b 15 50 40 80 00    	mov    0x804050,%edx
  8021d0:	8b 4d f4             	mov    -0xc(%ebp),%ecx
  8021d3:	c1 e1 04             	shl    $0x4,%ecx
  8021d6:	01 ca                	add    %ecx,%edx
  8021d8:	89 50 04             	mov    %edx,0x4(%eax)
  8021db:	eb 12                	jmp    8021ef <initialize_MemBlocksList+0xa0>
  8021dd:	a1 50 40 80 00       	mov    0x804050,%eax
  8021e2:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8021e5:	c1 e2 04             	shl    $0x4,%edx
  8021e8:	01 d0                	add    %edx,%eax
  8021ea:	a3 4c 41 80 00       	mov    %eax,0x80414c
  8021ef:	a1 50 40 80 00       	mov    0x804050,%eax
  8021f4:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8021f7:	c1 e2 04             	shl    $0x4,%edx
  8021fa:	01 d0                	add    %edx,%eax
  8021fc:	a3 48 41 80 00       	mov    %eax,0x804148
  802201:	a1 50 40 80 00       	mov    0x804050,%eax
  802206:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802209:	c1 e2 04             	shl    $0x4,%edx
  80220c:	01 d0                	add    %edx,%eax
  80220e:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802215:	a1 54 41 80 00       	mov    0x804154,%eax
  80221a:	40                   	inc    %eax
  80221b:	a3 54 41 80 00       	mov    %eax,0x804154
	// Write your code here, remove the panic and write your code
	//panic("initialize_MemBlocksList() is not implemented yet...!!");
	uint32 n = numOfBlocks;

	LIST_INIT(&AvailableMemBlocksList);
	for(int i = 0; i<n;i++)
  802220:	ff 45 f4             	incl   -0xc(%ebp)
  802223:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802226:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  802229:	0f 82 56 ff ff ff    	jb     802185 <initialize_MemBlocksList+0x36>
	{
		LIST_INSERT_HEAD(&AvailableMemBlocksList, &(MemBlockNodes[i]));
	}
}
  80222f:	90                   	nop
  802230:	c9                   	leave  
  802231:	c3                   	ret    

00802232 <find_block>:

//===============================
// [2] FIND BLOCK:
//===============================
struct MemBlock *find_block(struct MemBlock_List *blockList, uint32 va)
{
  802232:	55                   	push   %ebp
  802233:	89 e5                	mov    %esp,%ebp
  802235:	83 ec 10             	sub    $0x10,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] find_block
	// Write your code here, remove the panic and write your code
	//panic("find_block() is not implemented yet...!!");
	uint32 virAddress = va;
  802238:	8b 45 0c             	mov    0xc(%ebp),%eax
  80223b:	89 45 f4             	mov    %eax,-0xc(%ebp)
	struct MemBlock* blk;
	int found = 0;
  80223e:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	LIST_FOREACH(blk, &(AllocMemBlocksList))
  802245:	a1 40 40 80 00       	mov    0x804040,%eax
  80224a:	89 45 fc             	mov    %eax,-0x4(%ebp)
  80224d:	eb 23                	jmp    802272 <find_block+0x40>
	{
		if(blk->sva == virAddress)
  80224f:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802252:	8b 40 08             	mov    0x8(%eax),%eax
  802255:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  802258:	75 09                	jne    802263 <find_block+0x31>
		{
			found = 1;
  80225a:	c7 45 f8 01 00 00 00 	movl   $0x1,-0x8(%ebp)
			break;
  802261:	eb 35                	jmp    802298 <find_block+0x66>
		}
		else
		{
			found = 0;
  802263:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	//panic("find_block() is not implemented yet...!!");
	uint32 virAddress = va;
	struct MemBlock* blk;
	int found = 0;

	LIST_FOREACH(blk, &(AllocMemBlocksList))
  80226a:	a1 48 40 80 00       	mov    0x804048,%eax
  80226f:	89 45 fc             	mov    %eax,-0x4(%ebp)
  802272:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  802276:	74 07                	je     80227f <find_block+0x4d>
  802278:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80227b:	8b 00                	mov    (%eax),%eax
  80227d:	eb 05                	jmp    802284 <find_block+0x52>
  80227f:	b8 00 00 00 00       	mov    $0x0,%eax
  802284:	a3 48 40 80 00       	mov    %eax,0x804048
  802289:	a1 48 40 80 00       	mov    0x804048,%eax
  80228e:	85 c0                	test   %eax,%eax
  802290:	75 bd                	jne    80224f <find_block+0x1d>
  802292:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  802296:	75 b7                	jne    80224f <find_block+0x1d>
		{
			found = 0;
			continue;
		}
	}
	if(found == 1)
  802298:	83 7d f8 01          	cmpl   $0x1,-0x8(%ebp)
  80229c:	75 05                	jne    8022a3 <find_block+0x71>
	{
		return blk;
  80229e:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8022a1:	eb 05                	jmp    8022a8 <find_block+0x76>
	}
	else
	{
		return NULL;
  8022a3:	b8 00 00 00 00       	mov    $0x0,%eax
	}
}
  8022a8:	c9                   	leave  
  8022a9:	c3                   	ret    

008022aa <insert_sorted_allocList>:

//=========================================
// [3] INSERT BLOCK IN ALLOC LIST [SORTED]:
//=========================================
void insert_sorted_allocList(struct MemBlock *blockToInsert)
{
  8022aa:	55                   	push   %ebp
  8022ab:	89 e5                	mov    %esp,%ebp
  8022ad:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] insert_sorted_allocList
	// Write your code here, remove the panic and write your code
	//panic("insert_sorted_allocList() is not implemented yet...!!");
	struct MemBlock* blk;
	struct MemBlock* newblk = blockToInsert;
  8022b0:	8b 45 08             	mov    0x8(%ebp),%eax
  8022b3:	89 45 f0             	mov    %eax,-0x10(%ebp)

	if((LIST_EMPTY(&AllocMemBlocksList)) || (newblk->sva < LIST_FIRST(&AllocMemBlocksList)->sva))
  8022b6:	a1 40 40 80 00       	mov    0x804040,%eax
  8022bb:	85 c0                	test   %eax,%eax
  8022bd:	74 12                	je     8022d1 <insert_sorted_allocList+0x27>
  8022bf:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8022c2:	8b 50 08             	mov    0x8(%eax),%edx
  8022c5:	a1 40 40 80 00       	mov    0x804040,%eax
  8022ca:	8b 40 08             	mov    0x8(%eax),%eax
  8022cd:	39 c2                	cmp    %eax,%edx
  8022cf:	73 65                	jae    802336 <insert_sorted_allocList+0x8c>
	{
		LIST_INSERT_HEAD(&(AllocMemBlocksList), newblk);
  8022d1:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8022d5:	75 14                	jne    8022eb <insert_sorted_allocList+0x41>
  8022d7:	83 ec 04             	sub    $0x4,%esp
  8022da:	68 54 3c 80 00       	push   $0x803c54
  8022df:	6a 7b                	push   $0x7b
  8022e1:	68 77 3c 80 00       	push   $0x803c77
  8022e6:	e8 09 e1 ff ff       	call   8003f4 <_panic>
  8022eb:	8b 15 40 40 80 00    	mov    0x804040,%edx
  8022f1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8022f4:	89 10                	mov    %edx,(%eax)
  8022f6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8022f9:	8b 00                	mov    (%eax),%eax
  8022fb:	85 c0                	test   %eax,%eax
  8022fd:	74 0d                	je     80230c <insert_sorted_allocList+0x62>
  8022ff:	a1 40 40 80 00       	mov    0x804040,%eax
  802304:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802307:	89 50 04             	mov    %edx,0x4(%eax)
  80230a:	eb 08                	jmp    802314 <insert_sorted_allocList+0x6a>
  80230c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80230f:	a3 44 40 80 00       	mov    %eax,0x804044
  802314:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802317:	a3 40 40 80 00       	mov    %eax,0x804040
  80231c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80231f:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802326:	a1 4c 40 80 00       	mov    0x80404c,%eax
  80232b:	40                   	inc    %eax
  80232c:	a3 4c 40 80 00       	mov    %eax,0x80404c
  802331:	e9 5f 01 00 00       	jmp    802495 <insert_sorted_allocList+0x1eb>
	}
	else if(newblk->sva > LIST_LAST(&AllocMemBlocksList)->sva)
  802336:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802339:	8b 50 08             	mov    0x8(%eax),%edx
  80233c:	a1 44 40 80 00       	mov    0x804044,%eax
  802341:	8b 40 08             	mov    0x8(%eax),%eax
  802344:	39 c2                	cmp    %eax,%edx
  802346:	76 65                	jbe    8023ad <insert_sorted_allocList+0x103>
	{
		LIST_INSERT_TAIL(&AllocMemBlocksList, newblk);
  802348:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80234c:	75 14                	jne    802362 <insert_sorted_allocList+0xb8>
  80234e:	83 ec 04             	sub    $0x4,%esp
  802351:	68 90 3c 80 00       	push   $0x803c90
  802356:	6a 7f                	push   $0x7f
  802358:	68 77 3c 80 00       	push   $0x803c77
  80235d:	e8 92 e0 ff ff       	call   8003f4 <_panic>
  802362:	8b 15 44 40 80 00    	mov    0x804044,%edx
  802368:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80236b:	89 50 04             	mov    %edx,0x4(%eax)
  80236e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802371:	8b 40 04             	mov    0x4(%eax),%eax
  802374:	85 c0                	test   %eax,%eax
  802376:	74 0c                	je     802384 <insert_sorted_allocList+0xda>
  802378:	a1 44 40 80 00       	mov    0x804044,%eax
  80237d:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802380:	89 10                	mov    %edx,(%eax)
  802382:	eb 08                	jmp    80238c <insert_sorted_allocList+0xe2>
  802384:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802387:	a3 40 40 80 00       	mov    %eax,0x804040
  80238c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80238f:	a3 44 40 80 00       	mov    %eax,0x804044
  802394:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802397:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80239d:	a1 4c 40 80 00       	mov    0x80404c,%eax
  8023a2:	40                   	inc    %eax
  8023a3:	a3 4c 40 80 00       	mov    %eax,0x80404c
				LIST_INSERT_AFTER(&AllocMemBlocksList, blk, newblk);
				break;
			}
		}
	}
}
  8023a8:	e9 e8 00 00 00       	jmp    802495 <insert_sorted_allocList+0x1eb>
	{
		LIST_INSERT_TAIL(&AllocMemBlocksList, newblk);
	}
	else
	{
		LIST_FOREACH(blk, &AllocMemBlocksList)
  8023ad:	a1 40 40 80 00       	mov    0x804040,%eax
  8023b2:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8023b5:	e9 ab 00 00 00       	jmp    802465 <insert_sorted_allocList+0x1bb>
		{
			if(blk->prev_next_info.le_next != NULL && newblk->sva > blk->sva  && newblk->sva < blk->prev_next_info.le_next->sva)
  8023ba:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023bd:	8b 00                	mov    (%eax),%eax
  8023bf:	85 c0                	test   %eax,%eax
  8023c1:	0f 84 96 00 00 00    	je     80245d <insert_sorted_allocList+0x1b3>
  8023c7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8023ca:	8b 50 08             	mov    0x8(%eax),%edx
  8023cd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023d0:	8b 40 08             	mov    0x8(%eax),%eax
  8023d3:	39 c2                	cmp    %eax,%edx
  8023d5:	0f 86 82 00 00 00    	jbe    80245d <insert_sorted_allocList+0x1b3>
  8023db:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8023de:	8b 50 08             	mov    0x8(%eax),%edx
  8023e1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023e4:	8b 00                	mov    (%eax),%eax
  8023e6:	8b 40 08             	mov    0x8(%eax),%eax
  8023e9:	39 c2                	cmp    %eax,%edx
  8023eb:	73 70                	jae    80245d <insert_sorted_allocList+0x1b3>
			{
				LIST_INSERT_AFTER(&AllocMemBlocksList, blk, newblk);
  8023ed:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8023f1:	74 06                	je     8023f9 <insert_sorted_allocList+0x14f>
  8023f3:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8023f7:	75 17                	jne    802410 <insert_sorted_allocList+0x166>
  8023f9:	83 ec 04             	sub    $0x4,%esp
  8023fc:	68 b4 3c 80 00       	push   $0x803cb4
  802401:	68 87 00 00 00       	push   $0x87
  802406:	68 77 3c 80 00       	push   $0x803c77
  80240b:	e8 e4 df ff ff       	call   8003f4 <_panic>
  802410:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802413:	8b 10                	mov    (%eax),%edx
  802415:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802418:	89 10                	mov    %edx,(%eax)
  80241a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80241d:	8b 00                	mov    (%eax),%eax
  80241f:	85 c0                	test   %eax,%eax
  802421:	74 0b                	je     80242e <insert_sorted_allocList+0x184>
  802423:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802426:	8b 00                	mov    (%eax),%eax
  802428:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80242b:	89 50 04             	mov    %edx,0x4(%eax)
  80242e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802431:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802434:	89 10                	mov    %edx,(%eax)
  802436:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802439:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80243c:	89 50 04             	mov    %edx,0x4(%eax)
  80243f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802442:	8b 00                	mov    (%eax),%eax
  802444:	85 c0                	test   %eax,%eax
  802446:	75 08                	jne    802450 <insert_sorted_allocList+0x1a6>
  802448:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80244b:	a3 44 40 80 00       	mov    %eax,0x804044
  802450:	a1 4c 40 80 00       	mov    0x80404c,%eax
  802455:	40                   	inc    %eax
  802456:	a3 4c 40 80 00       	mov    %eax,0x80404c
				break;
  80245b:	eb 38                	jmp    802495 <insert_sorted_allocList+0x1eb>
	{
		LIST_INSERT_TAIL(&AllocMemBlocksList, newblk);
	}
	else
	{
		LIST_FOREACH(blk, &AllocMemBlocksList)
  80245d:	a1 48 40 80 00       	mov    0x804048,%eax
  802462:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802465:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802469:	74 07                	je     802472 <insert_sorted_allocList+0x1c8>
  80246b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80246e:	8b 00                	mov    (%eax),%eax
  802470:	eb 05                	jmp    802477 <insert_sorted_allocList+0x1cd>
  802472:	b8 00 00 00 00       	mov    $0x0,%eax
  802477:	a3 48 40 80 00       	mov    %eax,0x804048
  80247c:	a1 48 40 80 00       	mov    0x804048,%eax
  802481:	85 c0                	test   %eax,%eax
  802483:	0f 85 31 ff ff ff    	jne    8023ba <insert_sorted_allocList+0x110>
  802489:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80248d:	0f 85 27 ff ff ff    	jne    8023ba <insert_sorted_allocList+0x110>
				LIST_INSERT_AFTER(&AllocMemBlocksList, blk, newblk);
				break;
			}
		}
	}
}
  802493:	eb 00                	jmp    802495 <insert_sorted_allocList+0x1eb>
  802495:	90                   	nop
  802496:	c9                   	leave  
  802497:	c3                   	ret    

00802498 <alloc_block_FF>:

//=========================================
// [4] ALLOCATE BLOCK BY FIRST FIT:
//=========================================
struct MemBlock *alloc_block_FF(uint32 size)
{
  802498:	55                   	push   %ebp
  802499:	89 e5                	mov    %esp,%ebp
  80249b:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_FF
	// Write your code here, remove the panic and write your code
	//panic("alloc_block_FF() is not implemented yet...!!");
	uint32 versize = size;
  80249e:	8b 45 08             	mov    0x8(%ebp),%eax
  8024a1:	89 45 f0             	mov    %eax,-0x10(%ebp)
	struct MemBlock* blk;
	struct MemBlock* newblk = LIST_FIRST(&AvailableMemBlocksList);
  8024a4:	a1 48 41 80 00       	mov    0x804148,%eax
  8024a9:	89 45 ec             	mov    %eax,-0x14(%ebp)

	LIST_FOREACH(blk,&FreeMemBlocksList)
  8024ac:	a1 38 41 80 00       	mov    0x804138,%eax
  8024b1:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8024b4:	e9 77 01 00 00       	jmp    802630 <alloc_block_FF+0x198>
	{
		if(blk->size == versize)
  8024b9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024bc:	8b 40 0c             	mov    0xc(%eax),%eax
  8024bf:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8024c2:	0f 85 8a 00 00 00    	jne    802552 <alloc_block_FF+0xba>
		{
			LIST_REMOVE(&FreeMemBlocksList,blk);
  8024c8:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8024cc:	75 17                	jne    8024e5 <alloc_block_FF+0x4d>
  8024ce:	83 ec 04             	sub    $0x4,%esp
  8024d1:	68 e8 3c 80 00       	push   $0x803ce8
  8024d6:	68 9e 00 00 00       	push   $0x9e
  8024db:	68 77 3c 80 00       	push   $0x803c77
  8024e0:	e8 0f df ff ff       	call   8003f4 <_panic>
  8024e5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024e8:	8b 00                	mov    (%eax),%eax
  8024ea:	85 c0                	test   %eax,%eax
  8024ec:	74 10                	je     8024fe <alloc_block_FF+0x66>
  8024ee:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024f1:	8b 00                	mov    (%eax),%eax
  8024f3:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8024f6:	8b 52 04             	mov    0x4(%edx),%edx
  8024f9:	89 50 04             	mov    %edx,0x4(%eax)
  8024fc:	eb 0b                	jmp    802509 <alloc_block_FF+0x71>
  8024fe:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802501:	8b 40 04             	mov    0x4(%eax),%eax
  802504:	a3 3c 41 80 00       	mov    %eax,0x80413c
  802509:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80250c:	8b 40 04             	mov    0x4(%eax),%eax
  80250f:	85 c0                	test   %eax,%eax
  802511:	74 0f                	je     802522 <alloc_block_FF+0x8a>
  802513:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802516:	8b 40 04             	mov    0x4(%eax),%eax
  802519:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80251c:	8b 12                	mov    (%edx),%edx
  80251e:	89 10                	mov    %edx,(%eax)
  802520:	eb 0a                	jmp    80252c <alloc_block_FF+0x94>
  802522:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802525:	8b 00                	mov    (%eax),%eax
  802527:	a3 38 41 80 00       	mov    %eax,0x804138
  80252c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80252f:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802535:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802538:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80253f:	a1 44 41 80 00       	mov    0x804144,%eax
  802544:	48                   	dec    %eax
  802545:	a3 44 41 80 00       	mov    %eax,0x804144
			return blk;
  80254a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80254d:	e9 11 01 00 00       	jmp    802663 <alloc_block_FF+0x1cb>
		}
		else if(blk->size > versize)
  802552:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802555:	8b 40 0c             	mov    0xc(%eax),%eax
  802558:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  80255b:	0f 86 c7 00 00 00    	jbe    802628 <alloc_block_FF+0x190>
		{
			LIST_REMOVE(&AvailableMemBlocksList,newblk);
  802561:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802565:	75 17                	jne    80257e <alloc_block_FF+0xe6>
  802567:	83 ec 04             	sub    $0x4,%esp
  80256a:	68 e8 3c 80 00       	push   $0x803ce8
  80256f:	68 a3 00 00 00       	push   $0xa3
  802574:	68 77 3c 80 00       	push   $0x803c77
  802579:	e8 76 de ff ff       	call   8003f4 <_panic>
  80257e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802581:	8b 00                	mov    (%eax),%eax
  802583:	85 c0                	test   %eax,%eax
  802585:	74 10                	je     802597 <alloc_block_FF+0xff>
  802587:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80258a:	8b 00                	mov    (%eax),%eax
  80258c:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80258f:	8b 52 04             	mov    0x4(%edx),%edx
  802592:	89 50 04             	mov    %edx,0x4(%eax)
  802595:	eb 0b                	jmp    8025a2 <alloc_block_FF+0x10a>
  802597:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80259a:	8b 40 04             	mov    0x4(%eax),%eax
  80259d:	a3 4c 41 80 00       	mov    %eax,0x80414c
  8025a2:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8025a5:	8b 40 04             	mov    0x4(%eax),%eax
  8025a8:	85 c0                	test   %eax,%eax
  8025aa:	74 0f                	je     8025bb <alloc_block_FF+0x123>
  8025ac:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8025af:	8b 40 04             	mov    0x4(%eax),%eax
  8025b2:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8025b5:	8b 12                	mov    (%edx),%edx
  8025b7:	89 10                	mov    %edx,(%eax)
  8025b9:	eb 0a                	jmp    8025c5 <alloc_block_FF+0x12d>
  8025bb:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8025be:	8b 00                	mov    (%eax),%eax
  8025c0:	a3 48 41 80 00       	mov    %eax,0x804148
  8025c5:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8025c8:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8025ce:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8025d1:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8025d8:	a1 54 41 80 00       	mov    0x804154,%eax
  8025dd:	48                   	dec    %eax
  8025de:	a3 54 41 80 00       	mov    %eax,0x804154
			newblk->size = versize;
  8025e3:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8025e6:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8025e9:	89 50 0c             	mov    %edx,0xc(%eax)
			blk->size = blk->size-versize;
  8025ec:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025ef:	8b 40 0c             	mov    0xc(%eax),%eax
  8025f2:	2b 45 f0             	sub    -0x10(%ebp),%eax
  8025f5:	89 c2                	mov    %eax,%edx
  8025f7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025fa:	89 50 0c             	mov    %edx,0xc(%eax)
			uint32 newveradd = blk->sva;
  8025fd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802600:	8b 40 08             	mov    0x8(%eax),%eax
  802603:	89 45 e8             	mov    %eax,-0x18(%ebp)
			blk->sva+=newblk->size;
  802606:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802609:	8b 50 08             	mov    0x8(%eax),%edx
  80260c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80260f:	8b 40 0c             	mov    0xc(%eax),%eax
  802612:	01 c2                	add    %eax,%edx
  802614:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802617:	89 50 08             	mov    %edx,0x8(%eax)
			newblk->sva = newveradd;
  80261a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80261d:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802620:	89 50 08             	mov    %edx,0x8(%eax)
			return newblk;
  802623:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802626:	eb 3b                	jmp    802663 <alloc_block_FF+0x1cb>
	//panic("alloc_block_FF() is not implemented yet...!!");
	uint32 versize = size;
	struct MemBlock* blk;
	struct MemBlock* newblk = LIST_FIRST(&AvailableMemBlocksList);

	LIST_FOREACH(blk,&FreeMemBlocksList)
  802628:	a1 40 41 80 00       	mov    0x804140,%eax
  80262d:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802630:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802634:	74 07                	je     80263d <alloc_block_FF+0x1a5>
  802636:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802639:	8b 00                	mov    (%eax),%eax
  80263b:	eb 05                	jmp    802642 <alloc_block_FF+0x1aa>
  80263d:	b8 00 00 00 00       	mov    $0x0,%eax
  802642:	a3 40 41 80 00       	mov    %eax,0x804140
  802647:	a1 40 41 80 00       	mov    0x804140,%eax
  80264c:	85 c0                	test   %eax,%eax
  80264e:	0f 85 65 fe ff ff    	jne    8024b9 <alloc_block_FF+0x21>
  802654:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802658:	0f 85 5b fe ff ff    	jne    8024b9 <alloc_block_FF+0x21>
			blk->sva+=newblk->size;
			newblk->sva = newveradd;
			return newblk;
		}
	}
	return NULL;
  80265e:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802663:	c9                   	leave  
  802664:	c3                   	ret    

00802665 <alloc_block_BF>:

//=========================================
// [5] ALLOCATE BLOCK BY BEST FIT:
//=========================================
struct MemBlock *alloc_block_BF(uint32 size)
{
  802665:	55                   	push   %ebp
  802666:	89 e5                	mov    %esp,%ebp
  802668:	83 ec 28             	sub    $0x28,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_BF
	// Write your code here, remove the panic and write your code
	//panic("alloc_block_BF() is not implemented yet...!!");
	uint32 versize=size;
  80266b:	8b 45 08             	mov    0x8(%ebp),%eax
  80266e:	89 45 e8             	mov    %eax,-0x18(%ebp)
	struct MemBlock* blk;
	struct MemBlock* newblk=LIST_FIRST(&AvailableMemBlocksList);
  802671:	a1 48 41 80 00       	mov    0x804148,%eax
  802676:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	uint32 newveradd;
	uint32 newsize;
	int size_free = LIST_SIZE(&FreeMemBlocksList);
  802679:	a1 44 41 80 00       	mov    0x804144,%eax
  80267e:	89 45 e0             	mov    %eax,-0x20(%ebp)

	LIST_FOREACH(blk, &FreeMemBlocksList)
  802681:	a1 38 41 80 00       	mov    0x804138,%eax
  802686:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802689:	e9 a1 00 00 00       	jmp    80272f <alloc_block_BF+0xca>
	{
		if(blk->size == versize)
  80268e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802691:	8b 40 0c             	mov    0xc(%eax),%eax
  802694:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  802697:	0f 85 8a 00 00 00    	jne    802727 <alloc_block_BF+0xc2>
		{
			LIST_REMOVE(&FreeMemBlocksList, blk);
  80269d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8026a1:	75 17                	jne    8026ba <alloc_block_BF+0x55>
  8026a3:	83 ec 04             	sub    $0x4,%esp
  8026a6:	68 e8 3c 80 00       	push   $0x803ce8
  8026ab:	68 c2 00 00 00       	push   $0xc2
  8026b0:	68 77 3c 80 00       	push   $0x803c77
  8026b5:	e8 3a dd ff ff       	call   8003f4 <_panic>
  8026ba:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026bd:	8b 00                	mov    (%eax),%eax
  8026bf:	85 c0                	test   %eax,%eax
  8026c1:	74 10                	je     8026d3 <alloc_block_BF+0x6e>
  8026c3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026c6:	8b 00                	mov    (%eax),%eax
  8026c8:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8026cb:	8b 52 04             	mov    0x4(%edx),%edx
  8026ce:	89 50 04             	mov    %edx,0x4(%eax)
  8026d1:	eb 0b                	jmp    8026de <alloc_block_BF+0x79>
  8026d3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026d6:	8b 40 04             	mov    0x4(%eax),%eax
  8026d9:	a3 3c 41 80 00       	mov    %eax,0x80413c
  8026de:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026e1:	8b 40 04             	mov    0x4(%eax),%eax
  8026e4:	85 c0                	test   %eax,%eax
  8026e6:	74 0f                	je     8026f7 <alloc_block_BF+0x92>
  8026e8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026eb:	8b 40 04             	mov    0x4(%eax),%eax
  8026ee:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8026f1:	8b 12                	mov    (%edx),%edx
  8026f3:	89 10                	mov    %edx,(%eax)
  8026f5:	eb 0a                	jmp    802701 <alloc_block_BF+0x9c>
  8026f7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026fa:	8b 00                	mov    (%eax),%eax
  8026fc:	a3 38 41 80 00       	mov    %eax,0x804138
  802701:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802704:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80270a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80270d:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802714:	a1 44 41 80 00       	mov    0x804144,%eax
  802719:	48                   	dec    %eax
  80271a:	a3 44 41 80 00       	mov    %eax,0x804144
			return blk;
  80271f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802722:	e9 11 02 00 00       	jmp    802938 <alloc_block_BF+0x2d3>
	struct MemBlock* newblk=LIST_FIRST(&AvailableMemBlocksList);
	uint32 newveradd;
	uint32 newsize;
	int size_free = LIST_SIZE(&FreeMemBlocksList);

	LIST_FOREACH(blk, &FreeMemBlocksList)
  802727:	a1 40 41 80 00       	mov    0x804140,%eax
  80272c:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80272f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802733:	74 07                	je     80273c <alloc_block_BF+0xd7>
  802735:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802738:	8b 00                	mov    (%eax),%eax
  80273a:	eb 05                	jmp    802741 <alloc_block_BF+0xdc>
  80273c:	b8 00 00 00 00       	mov    $0x0,%eax
  802741:	a3 40 41 80 00       	mov    %eax,0x804140
  802746:	a1 40 41 80 00       	mov    0x804140,%eax
  80274b:	85 c0                	test   %eax,%eax
  80274d:	0f 85 3b ff ff ff    	jne    80268e <alloc_block_BF+0x29>
  802753:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802757:	0f 85 31 ff ff ff    	jne    80268e <alloc_block_BF+0x29>
		{
			LIST_REMOVE(&FreeMemBlocksList, blk);
			return blk;
		}
	}
	LIST_FOREACH(blk, &FreeMemBlocksList)
  80275d:	a1 38 41 80 00       	mov    0x804138,%eax
  802762:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802765:	eb 27                	jmp    80278e <alloc_block_BF+0x129>
	{
		if(blk->size > versize)
  802767:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80276a:	8b 40 0c             	mov    0xc(%eax),%eax
  80276d:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  802770:	76 14                	jbe    802786 <alloc_block_BF+0x121>
		{
			newsize = blk->size;
  802772:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802775:	8b 40 0c             	mov    0xc(%eax),%eax
  802778:	89 45 ec             	mov    %eax,-0x14(%ebp)
			newveradd = blk->sva;
  80277b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80277e:	8b 40 08             	mov    0x8(%eax),%eax
  802781:	89 45 f0             	mov    %eax,-0x10(%ebp)
			break;
  802784:	eb 2e                	jmp    8027b4 <alloc_block_BF+0x14f>
		{
			LIST_REMOVE(&FreeMemBlocksList, blk);
			return blk;
		}
	}
	LIST_FOREACH(blk, &FreeMemBlocksList)
  802786:	a1 40 41 80 00       	mov    0x804140,%eax
  80278b:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80278e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802792:	74 07                	je     80279b <alloc_block_BF+0x136>
  802794:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802797:	8b 00                	mov    (%eax),%eax
  802799:	eb 05                	jmp    8027a0 <alloc_block_BF+0x13b>
  80279b:	b8 00 00 00 00       	mov    $0x0,%eax
  8027a0:	a3 40 41 80 00       	mov    %eax,0x804140
  8027a5:	a1 40 41 80 00       	mov    0x804140,%eax
  8027aa:	85 c0                	test   %eax,%eax
  8027ac:	75 b9                	jne    802767 <alloc_block_BF+0x102>
  8027ae:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8027b2:	75 b3                	jne    802767 <alloc_block_BF+0x102>
			newsize = blk->size;
			newveradd = blk->sva;
			break;
		}
	}
	LIST_FOREACH(blk, &FreeMemBlocksList)
  8027b4:	a1 38 41 80 00       	mov    0x804138,%eax
  8027b9:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8027bc:	eb 30                	jmp    8027ee <alloc_block_BF+0x189>
	{
		if(newsize > blk->size && blk->size > versize)
  8027be:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027c1:	8b 40 0c             	mov    0xc(%eax),%eax
  8027c4:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  8027c7:	73 1d                	jae    8027e6 <alloc_block_BF+0x181>
  8027c9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027cc:	8b 40 0c             	mov    0xc(%eax),%eax
  8027cf:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  8027d2:	76 12                	jbe    8027e6 <alloc_block_BF+0x181>
		{
	       newsize = blk->size;
  8027d4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027d7:	8b 40 0c             	mov    0xc(%eax),%eax
  8027da:	89 45 ec             	mov    %eax,-0x14(%ebp)
		   newveradd = blk->sva;
  8027dd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027e0:	8b 40 08             	mov    0x8(%eax),%eax
  8027e3:	89 45 f0             	mov    %eax,-0x10(%ebp)
			newsize = blk->size;
			newveradd = blk->sva;
			break;
		}
	}
	LIST_FOREACH(blk, &FreeMemBlocksList)
  8027e6:	a1 40 41 80 00       	mov    0x804140,%eax
  8027eb:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8027ee:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8027f2:	74 07                	je     8027fb <alloc_block_BF+0x196>
  8027f4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027f7:	8b 00                	mov    (%eax),%eax
  8027f9:	eb 05                	jmp    802800 <alloc_block_BF+0x19b>
  8027fb:	b8 00 00 00 00       	mov    $0x0,%eax
  802800:	a3 40 41 80 00       	mov    %eax,0x804140
  802805:	a1 40 41 80 00       	mov    0x804140,%eax
  80280a:	85 c0                	test   %eax,%eax
  80280c:	75 b0                	jne    8027be <alloc_block_BF+0x159>
  80280e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802812:	75 aa                	jne    8027be <alloc_block_BF+0x159>
		{
	       newsize = blk->size;
		   newveradd = blk->sva;
		}
	}
	LIST_FOREACH(blk, &FreeMemBlocksList)
  802814:	a1 38 41 80 00       	mov    0x804138,%eax
  802819:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80281c:	e9 e4 00 00 00       	jmp    802905 <alloc_block_BF+0x2a0>
	{
		if(blk->size == newsize && blk->sva == newveradd)
  802821:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802824:	8b 40 0c             	mov    0xc(%eax),%eax
  802827:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  80282a:	0f 85 cd 00 00 00    	jne    8028fd <alloc_block_BF+0x298>
  802830:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802833:	8b 40 08             	mov    0x8(%eax),%eax
  802836:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  802839:	0f 85 be 00 00 00    	jne    8028fd <alloc_block_BF+0x298>
		{
			LIST_REMOVE(&AvailableMemBlocksList, newblk);
  80283f:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  802843:	75 17                	jne    80285c <alloc_block_BF+0x1f7>
  802845:	83 ec 04             	sub    $0x4,%esp
  802848:	68 e8 3c 80 00       	push   $0x803ce8
  80284d:	68 db 00 00 00       	push   $0xdb
  802852:	68 77 3c 80 00       	push   $0x803c77
  802857:	e8 98 db ff ff       	call   8003f4 <_panic>
  80285c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80285f:	8b 00                	mov    (%eax),%eax
  802861:	85 c0                	test   %eax,%eax
  802863:	74 10                	je     802875 <alloc_block_BF+0x210>
  802865:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802868:	8b 00                	mov    (%eax),%eax
  80286a:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80286d:	8b 52 04             	mov    0x4(%edx),%edx
  802870:	89 50 04             	mov    %edx,0x4(%eax)
  802873:	eb 0b                	jmp    802880 <alloc_block_BF+0x21b>
  802875:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802878:	8b 40 04             	mov    0x4(%eax),%eax
  80287b:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802880:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802883:	8b 40 04             	mov    0x4(%eax),%eax
  802886:	85 c0                	test   %eax,%eax
  802888:	74 0f                	je     802899 <alloc_block_BF+0x234>
  80288a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80288d:	8b 40 04             	mov    0x4(%eax),%eax
  802890:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802893:	8b 12                	mov    (%edx),%edx
  802895:	89 10                	mov    %edx,(%eax)
  802897:	eb 0a                	jmp    8028a3 <alloc_block_BF+0x23e>
  802899:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80289c:	8b 00                	mov    (%eax),%eax
  80289e:	a3 48 41 80 00       	mov    %eax,0x804148
  8028a3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8028a6:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8028ac:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8028af:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8028b6:	a1 54 41 80 00       	mov    0x804154,%eax
  8028bb:	48                   	dec    %eax
  8028bc:	a3 54 41 80 00       	mov    %eax,0x804154
			newblk->size = versize;
  8028c1:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8028c4:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8028c7:	89 50 0c             	mov    %edx,0xc(%eax)
			newblk->sva = newveradd;
  8028ca:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8028cd:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8028d0:	89 50 08             	mov    %edx,0x8(%eax)
			blk->size = blk->size - versize;
  8028d3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028d6:	8b 40 0c             	mov    0xc(%eax),%eax
  8028d9:	2b 45 e8             	sub    -0x18(%ebp),%eax
  8028dc:	89 c2                	mov    %eax,%edx
  8028de:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028e1:	89 50 0c             	mov    %edx,0xc(%eax)
			blk->sva+= newblk->size;
  8028e4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028e7:	8b 50 08             	mov    0x8(%eax),%edx
  8028ea:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8028ed:	8b 40 0c             	mov    0xc(%eax),%eax
  8028f0:	01 c2                	add    %eax,%edx
  8028f2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028f5:	89 50 08             	mov    %edx,0x8(%eax)
			return newblk;
  8028f8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8028fb:	eb 3b                	jmp    802938 <alloc_block_BF+0x2d3>
		{
	       newsize = blk->size;
		   newveradd = blk->sva;
		}
	}
	LIST_FOREACH(blk, &FreeMemBlocksList)
  8028fd:	a1 40 41 80 00       	mov    0x804140,%eax
  802902:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802905:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802909:	74 07                	je     802912 <alloc_block_BF+0x2ad>
  80290b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80290e:	8b 00                	mov    (%eax),%eax
  802910:	eb 05                	jmp    802917 <alloc_block_BF+0x2b2>
  802912:	b8 00 00 00 00       	mov    $0x0,%eax
  802917:	a3 40 41 80 00       	mov    %eax,0x804140
  80291c:	a1 40 41 80 00       	mov    0x804140,%eax
  802921:	85 c0                	test   %eax,%eax
  802923:	0f 85 f8 fe ff ff    	jne    802821 <alloc_block_BF+0x1bc>
  802929:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80292d:	0f 85 ee fe ff ff    	jne    802821 <alloc_block_BF+0x1bc>
			blk->size = blk->size - versize;
			blk->sva+= newblk->size;
			return newblk;
		}
	}
	return NULL;
  802933:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802938:	c9                   	leave  
  802939:	c3                   	ret    

0080293a <alloc_block_NF>:
//=========================================
// [7] ALLOCATE BLOCK BY NEXT FIT:
//=========================================
struct MemBlock *last_allocate;
struct MemBlock *alloc_block_NF(uint32 size)
{
  80293a:	55                   	push   %ebp
  80293b:	89 e5                	mov    %esp,%ebp
  80293d:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1 - BONUS] [DYNAMIC ALLOCATOR] alloc_block_NF
	// Write your code here, remove the panic and write your code
	//panic("alloc_block_NF() is not implemented yet...!!");
	uint32 versize = size;
  802940:	8b 45 08             	mov    0x8(%ebp),%eax
  802943:	89 45 f0             	mov    %eax,-0x10(%ebp)
	struct MemBlock* blk;
	struct MemBlock* newblk = LIST_FIRST(&AvailableMemBlocksList);
  802946:	a1 48 41 80 00       	mov    0x804148,%eax
  80294b:	89 45 ec             	mov    %eax,-0x14(%ebp)

	LIST_FOREACH(blk,&FreeMemBlocksList)
  80294e:	a1 38 41 80 00       	mov    0x804138,%eax
  802953:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802956:	e9 77 01 00 00       	jmp    802ad2 <alloc_block_NF+0x198>
	{
		if(blk->size == versize)
  80295b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80295e:	8b 40 0c             	mov    0xc(%eax),%eax
  802961:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  802964:	0f 85 8a 00 00 00    	jne    8029f4 <alloc_block_NF+0xba>
		{
			LIST_REMOVE(&FreeMemBlocksList,blk);
  80296a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80296e:	75 17                	jne    802987 <alloc_block_NF+0x4d>
  802970:	83 ec 04             	sub    $0x4,%esp
  802973:	68 e8 3c 80 00       	push   $0x803ce8
  802978:	68 f7 00 00 00       	push   $0xf7
  80297d:	68 77 3c 80 00       	push   $0x803c77
  802982:	e8 6d da ff ff       	call   8003f4 <_panic>
  802987:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80298a:	8b 00                	mov    (%eax),%eax
  80298c:	85 c0                	test   %eax,%eax
  80298e:	74 10                	je     8029a0 <alloc_block_NF+0x66>
  802990:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802993:	8b 00                	mov    (%eax),%eax
  802995:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802998:	8b 52 04             	mov    0x4(%edx),%edx
  80299b:	89 50 04             	mov    %edx,0x4(%eax)
  80299e:	eb 0b                	jmp    8029ab <alloc_block_NF+0x71>
  8029a0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029a3:	8b 40 04             	mov    0x4(%eax),%eax
  8029a6:	a3 3c 41 80 00       	mov    %eax,0x80413c
  8029ab:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029ae:	8b 40 04             	mov    0x4(%eax),%eax
  8029b1:	85 c0                	test   %eax,%eax
  8029b3:	74 0f                	je     8029c4 <alloc_block_NF+0x8a>
  8029b5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029b8:	8b 40 04             	mov    0x4(%eax),%eax
  8029bb:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8029be:	8b 12                	mov    (%edx),%edx
  8029c0:	89 10                	mov    %edx,(%eax)
  8029c2:	eb 0a                	jmp    8029ce <alloc_block_NF+0x94>
  8029c4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029c7:	8b 00                	mov    (%eax),%eax
  8029c9:	a3 38 41 80 00       	mov    %eax,0x804138
  8029ce:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029d1:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8029d7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029da:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8029e1:	a1 44 41 80 00       	mov    0x804144,%eax
  8029e6:	48                   	dec    %eax
  8029e7:	a3 44 41 80 00       	mov    %eax,0x804144
			return blk;
  8029ec:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029ef:	e9 11 01 00 00       	jmp    802b05 <alloc_block_NF+0x1cb>
		}
		else if(blk->size > versize)
  8029f4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029f7:	8b 40 0c             	mov    0xc(%eax),%eax
  8029fa:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8029fd:	0f 86 c7 00 00 00    	jbe    802aca <alloc_block_NF+0x190>
		{
			LIST_REMOVE(&AvailableMemBlocksList,newblk);
  802a03:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802a07:	75 17                	jne    802a20 <alloc_block_NF+0xe6>
  802a09:	83 ec 04             	sub    $0x4,%esp
  802a0c:	68 e8 3c 80 00       	push   $0x803ce8
  802a11:	68 fc 00 00 00       	push   $0xfc
  802a16:	68 77 3c 80 00       	push   $0x803c77
  802a1b:	e8 d4 d9 ff ff       	call   8003f4 <_panic>
  802a20:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802a23:	8b 00                	mov    (%eax),%eax
  802a25:	85 c0                	test   %eax,%eax
  802a27:	74 10                	je     802a39 <alloc_block_NF+0xff>
  802a29:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802a2c:	8b 00                	mov    (%eax),%eax
  802a2e:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802a31:	8b 52 04             	mov    0x4(%edx),%edx
  802a34:	89 50 04             	mov    %edx,0x4(%eax)
  802a37:	eb 0b                	jmp    802a44 <alloc_block_NF+0x10a>
  802a39:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802a3c:	8b 40 04             	mov    0x4(%eax),%eax
  802a3f:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802a44:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802a47:	8b 40 04             	mov    0x4(%eax),%eax
  802a4a:	85 c0                	test   %eax,%eax
  802a4c:	74 0f                	je     802a5d <alloc_block_NF+0x123>
  802a4e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802a51:	8b 40 04             	mov    0x4(%eax),%eax
  802a54:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802a57:	8b 12                	mov    (%edx),%edx
  802a59:	89 10                	mov    %edx,(%eax)
  802a5b:	eb 0a                	jmp    802a67 <alloc_block_NF+0x12d>
  802a5d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802a60:	8b 00                	mov    (%eax),%eax
  802a62:	a3 48 41 80 00       	mov    %eax,0x804148
  802a67:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802a6a:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802a70:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802a73:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802a7a:	a1 54 41 80 00       	mov    0x804154,%eax
  802a7f:	48                   	dec    %eax
  802a80:	a3 54 41 80 00       	mov    %eax,0x804154
			newblk->size = versize;
  802a85:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802a88:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802a8b:	89 50 0c             	mov    %edx,0xc(%eax)
			blk->size = blk->size-versize;
  802a8e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a91:	8b 40 0c             	mov    0xc(%eax),%eax
  802a94:	2b 45 f0             	sub    -0x10(%ebp),%eax
  802a97:	89 c2                	mov    %eax,%edx
  802a99:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a9c:	89 50 0c             	mov    %edx,0xc(%eax)
			uint32 newveradd = blk->sva;
  802a9f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802aa2:	8b 40 08             	mov    0x8(%eax),%eax
  802aa5:	89 45 e8             	mov    %eax,-0x18(%ebp)
			blk->sva+=newblk->size;
  802aa8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802aab:	8b 50 08             	mov    0x8(%eax),%edx
  802aae:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802ab1:	8b 40 0c             	mov    0xc(%eax),%eax
  802ab4:	01 c2                	add    %eax,%edx
  802ab6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ab9:	89 50 08             	mov    %edx,0x8(%eax)
			newblk->sva = newveradd;
  802abc:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802abf:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802ac2:	89 50 08             	mov    %edx,0x8(%eax)
			return newblk;
  802ac5:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802ac8:	eb 3b                	jmp    802b05 <alloc_block_NF+0x1cb>
	//panic("alloc_block_NF() is not implemented yet...!!");
	uint32 versize = size;
	struct MemBlock* blk;
	struct MemBlock* newblk = LIST_FIRST(&AvailableMemBlocksList);

	LIST_FOREACH(blk,&FreeMemBlocksList)
  802aca:	a1 40 41 80 00       	mov    0x804140,%eax
  802acf:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802ad2:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802ad6:	74 07                	je     802adf <alloc_block_NF+0x1a5>
  802ad8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802adb:	8b 00                	mov    (%eax),%eax
  802add:	eb 05                	jmp    802ae4 <alloc_block_NF+0x1aa>
  802adf:	b8 00 00 00 00       	mov    $0x0,%eax
  802ae4:	a3 40 41 80 00       	mov    %eax,0x804140
  802ae9:	a1 40 41 80 00       	mov    0x804140,%eax
  802aee:	85 c0                	test   %eax,%eax
  802af0:	0f 85 65 fe ff ff    	jne    80295b <alloc_block_NF+0x21>
  802af6:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802afa:	0f 85 5b fe ff ff    	jne    80295b <alloc_block_NF+0x21>
			blk->sva+=newblk->size;
			newblk->sva = newveradd;
			return newblk;
		}
	}
	return NULL;
  802b00:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802b05:	c9                   	leave  
  802b06:	c3                   	ret    

00802b07 <addToAvailMemBlocksList>:

//===================================================
// [8] INSERT BLOCK (SORTED WITH MERGE) IN FREE LIST:
//===================================================
void addToAvailMemBlocksList(struct MemBlock *blockToInsert)
{
  802b07:	55                   	push   %ebp
  802b08:	89 e5                	mov    %esp,%ebp
  802b0a:	83 ec 08             	sub    $0x8,%esp
	blockToInsert->sva = 0;
  802b0d:	8b 45 08             	mov    0x8(%ebp),%eax
  802b10:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
	blockToInsert->size = 0;
  802b17:	8b 45 08             	mov    0x8(%ebp),%eax
  802b1a:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
	//add to avail
	LIST_INSERT_TAIL(&AvailableMemBlocksList, blockToInsert);
  802b21:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802b25:	75 17                	jne    802b3e <addToAvailMemBlocksList+0x37>
  802b27:	83 ec 04             	sub    $0x4,%esp
  802b2a:	68 90 3c 80 00       	push   $0x803c90
  802b2f:	68 10 01 00 00       	push   $0x110
  802b34:	68 77 3c 80 00       	push   $0x803c77
  802b39:	e8 b6 d8 ff ff       	call   8003f4 <_panic>
  802b3e:	8b 15 4c 41 80 00    	mov    0x80414c,%edx
  802b44:	8b 45 08             	mov    0x8(%ebp),%eax
  802b47:	89 50 04             	mov    %edx,0x4(%eax)
  802b4a:	8b 45 08             	mov    0x8(%ebp),%eax
  802b4d:	8b 40 04             	mov    0x4(%eax),%eax
  802b50:	85 c0                	test   %eax,%eax
  802b52:	74 0c                	je     802b60 <addToAvailMemBlocksList+0x59>
  802b54:	a1 4c 41 80 00       	mov    0x80414c,%eax
  802b59:	8b 55 08             	mov    0x8(%ebp),%edx
  802b5c:	89 10                	mov    %edx,(%eax)
  802b5e:	eb 08                	jmp    802b68 <addToAvailMemBlocksList+0x61>
  802b60:	8b 45 08             	mov    0x8(%ebp),%eax
  802b63:	a3 48 41 80 00       	mov    %eax,0x804148
  802b68:	8b 45 08             	mov    0x8(%ebp),%eax
  802b6b:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802b70:	8b 45 08             	mov    0x8(%ebp),%eax
  802b73:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802b79:	a1 54 41 80 00       	mov    0x804154,%eax
  802b7e:	40                   	inc    %eax
  802b7f:	a3 54 41 80 00       	mov    %eax,0x804154
}
  802b84:	90                   	nop
  802b85:	c9                   	leave  
  802b86:	c3                   	ret    

00802b87 <insert_sorted_with_merge_freeList>:
void insert_sorted_with_merge_freeList(struct MemBlock *blockToInsert)
{
  802b87:	55                   	push   %ebp
  802b88:	89 e5                	mov    %esp,%ebp
  802b8a:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] insert_sorted_with_merge_freeList
	// Write your code here, remove the panic and write your code

	struct MemBlock* last = LIST_LAST(&FreeMemBlocksList);
  802b8d:	a1 3c 41 80 00       	mov    0x80413c,%eax
  802b92:	89 45 f0             	mov    %eax,-0x10(%ebp)
	//check if list empty
	if (LIST_SIZE(&(FreeMemBlocksList)) == 0)
  802b95:	a1 44 41 80 00       	mov    0x804144,%eax
  802b9a:	85 c0                	test   %eax,%eax
  802b9c:	75 68                	jne    802c06 <insert_sorted_with_merge_freeList+0x7f>
		LIST_INSERT_HEAD(&FreeMemBlocksList, blockToInsert);
  802b9e:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802ba2:	75 17                	jne    802bbb <insert_sorted_with_merge_freeList+0x34>
  802ba4:	83 ec 04             	sub    $0x4,%esp
  802ba7:	68 54 3c 80 00       	push   $0x803c54
  802bac:	68 1a 01 00 00       	push   $0x11a
  802bb1:	68 77 3c 80 00       	push   $0x803c77
  802bb6:	e8 39 d8 ff ff       	call   8003f4 <_panic>
  802bbb:	8b 15 38 41 80 00    	mov    0x804138,%edx
  802bc1:	8b 45 08             	mov    0x8(%ebp),%eax
  802bc4:	89 10                	mov    %edx,(%eax)
  802bc6:	8b 45 08             	mov    0x8(%ebp),%eax
  802bc9:	8b 00                	mov    (%eax),%eax
  802bcb:	85 c0                	test   %eax,%eax
  802bcd:	74 0d                	je     802bdc <insert_sorted_with_merge_freeList+0x55>
  802bcf:	a1 38 41 80 00       	mov    0x804138,%eax
  802bd4:	8b 55 08             	mov    0x8(%ebp),%edx
  802bd7:	89 50 04             	mov    %edx,0x4(%eax)
  802bda:	eb 08                	jmp    802be4 <insert_sorted_with_merge_freeList+0x5d>
  802bdc:	8b 45 08             	mov    0x8(%ebp),%eax
  802bdf:	a3 3c 41 80 00       	mov    %eax,0x80413c
  802be4:	8b 45 08             	mov    0x8(%ebp),%eax
  802be7:	a3 38 41 80 00       	mov    %eax,0x804138
  802bec:	8b 45 08             	mov    0x8(%ebp),%eax
  802bef:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802bf6:	a1 44 41 80 00       	mov    0x804144,%eax
  802bfb:	40                   	inc    %eax
  802bfc:	a3 44 41 80 00       	mov    %eax,0x804144
		}
	}

	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  802c01:	e9 c5 03 00 00       	jmp    802fcb <insert_sorted_with_merge_freeList+0x444>
	struct MemBlock* last = LIST_LAST(&FreeMemBlocksList);
	//check if list empty
	if (LIST_SIZE(&(FreeMemBlocksList)) == 0)
		LIST_INSERT_HEAD(&FreeMemBlocksList, blockToInsert);
	//check if it's position is at last
	else if (last->sva < blockToInsert->sva) {
  802c06:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c09:	8b 50 08             	mov    0x8(%eax),%edx
  802c0c:	8b 45 08             	mov    0x8(%ebp),%eax
  802c0f:	8b 40 08             	mov    0x8(%eax),%eax
  802c12:	39 c2                	cmp    %eax,%edx
  802c14:	0f 83 b2 00 00 00    	jae    802ccc <insert_sorted_with_merge_freeList+0x145>

		//if i have to merge
		if (last->sva + last->size == blockToInsert->sva) {
  802c1a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c1d:	8b 50 08             	mov    0x8(%eax),%edx
  802c20:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c23:	8b 40 0c             	mov    0xc(%eax),%eax
  802c26:	01 c2                	add    %eax,%edx
  802c28:	8b 45 08             	mov    0x8(%ebp),%eax
  802c2b:	8b 40 08             	mov    0x8(%eax),%eax
  802c2e:	39 c2                	cmp    %eax,%edx
  802c30:	75 27                	jne    802c59 <insert_sorted_with_merge_freeList+0xd2>
			last->size = last->size + blockToInsert->size;
  802c32:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c35:	8b 50 0c             	mov    0xc(%eax),%edx
  802c38:	8b 45 08             	mov    0x8(%ebp),%eax
  802c3b:	8b 40 0c             	mov    0xc(%eax),%eax
  802c3e:	01 c2                	add    %eax,%edx
  802c40:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c43:	89 50 0c             	mov    %edx,0xc(%eax)
			addToAvailMemBlocksList(blockToInsert);
  802c46:	83 ec 0c             	sub    $0xc,%esp
  802c49:	ff 75 08             	pushl  0x8(%ebp)
  802c4c:	e8 b6 fe ff ff       	call   802b07 <addToAvailMemBlocksList>
  802c51:	83 c4 10             	add    $0x10,%esp
		}
	}

	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  802c54:	e9 72 03 00 00       	jmp    802fcb <insert_sorted_with_merge_freeList+0x444>
		if (last->sva + last->size == blockToInsert->sva) {
			last->size = last->size + blockToInsert->size;
			addToAvailMemBlocksList(blockToInsert);

		} else {
			LIST_INSERT_AFTER(&FreeMemBlocksList, last, blockToInsert);
  802c59:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802c5d:	74 06                	je     802c65 <insert_sorted_with_merge_freeList+0xde>
  802c5f:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802c63:	75 17                	jne    802c7c <insert_sorted_with_merge_freeList+0xf5>
  802c65:	83 ec 04             	sub    $0x4,%esp
  802c68:	68 b4 3c 80 00       	push   $0x803cb4
  802c6d:	68 24 01 00 00       	push   $0x124
  802c72:	68 77 3c 80 00       	push   $0x803c77
  802c77:	e8 78 d7 ff ff       	call   8003f4 <_panic>
  802c7c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c7f:	8b 10                	mov    (%eax),%edx
  802c81:	8b 45 08             	mov    0x8(%ebp),%eax
  802c84:	89 10                	mov    %edx,(%eax)
  802c86:	8b 45 08             	mov    0x8(%ebp),%eax
  802c89:	8b 00                	mov    (%eax),%eax
  802c8b:	85 c0                	test   %eax,%eax
  802c8d:	74 0b                	je     802c9a <insert_sorted_with_merge_freeList+0x113>
  802c8f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c92:	8b 00                	mov    (%eax),%eax
  802c94:	8b 55 08             	mov    0x8(%ebp),%edx
  802c97:	89 50 04             	mov    %edx,0x4(%eax)
  802c9a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c9d:	8b 55 08             	mov    0x8(%ebp),%edx
  802ca0:	89 10                	mov    %edx,(%eax)
  802ca2:	8b 45 08             	mov    0x8(%ebp),%eax
  802ca5:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802ca8:	89 50 04             	mov    %edx,0x4(%eax)
  802cab:	8b 45 08             	mov    0x8(%ebp),%eax
  802cae:	8b 00                	mov    (%eax),%eax
  802cb0:	85 c0                	test   %eax,%eax
  802cb2:	75 08                	jne    802cbc <insert_sorted_with_merge_freeList+0x135>
  802cb4:	8b 45 08             	mov    0x8(%ebp),%eax
  802cb7:	a3 3c 41 80 00       	mov    %eax,0x80413c
  802cbc:	a1 44 41 80 00       	mov    0x804144,%eax
  802cc1:	40                   	inc    %eax
  802cc2:	a3 44 41 80 00       	mov    %eax,0x804144
		}
	}

	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  802cc7:	e9 ff 02 00 00       	jmp    802fcb <insert_sorted_with_merge_freeList+0x444>
		} else {
			LIST_INSERT_AFTER(&FreeMemBlocksList, last, blockToInsert);
		}
	} else {
		struct MemBlock *iterator;
		LIST_FOREACH(iterator, &(FreeMemBlocksList))
  802ccc:	a1 38 41 80 00       	mov    0x804138,%eax
  802cd1:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802cd4:	e9 c2 02 00 00       	jmp    802f9b <insert_sorted_with_merge_freeList+0x414>
		{

			if (iterator->sva > blockToInsert->sva) {
  802cd9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cdc:	8b 50 08             	mov    0x8(%eax),%edx
  802cdf:	8b 45 08             	mov    0x8(%ebp),%eax
  802ce2:	8b 40 08             	mov    0x8(%eax),%eax
  802ce5:	39 c2                	cmp    %eax,%edx
  802ce7:	0f 86 a6 02 00 00    	jbe    802f93 <insert_sorted_with_merge_freeList+0x40c>

				struct MemBlock* prev = LIST_PREV(iterator);
  802ced:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cf0:	8b 40 04             	mov    0x4(%eax),%eax
  802cf3:	89 45 ec             	mov    %eax,-0x14(%ebp)
				if (prev == NULL) {
  802cf6:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802cfa:	0f 85 ba 00 00 00    	jne    802dba <insert_sorted_with_merge_freeList+0x233>
					//check merge
					if (blockToInsert->size + blockToInsert->sva
  802d00:	8b 45 08             	mov    0x8(%ebp),%eax
  802d03:	8b 50 0c             	mov    0xc(%eax),%edx
  802d06:	8b 45 08             	mov    0x8(%ebp),%eax
  802d09:	8b 40 08             	mov    0x8(%eax),%eax
  802d0c:	01 c2                	add    %eax,%edx
							== iterator->sva) {
  802d0e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d11:	8b 40 08             	mov    0x8(%eax),%eax
			if (iterator->sva > blockToInsert->sva) {

				struct MemBlock* prev = LIST_PREV(iterator);
				if (prev == NULL) {
					//check merge
					if (blockToInsert->size + blockToInsert->sva
  802d14:	39 c2                	cmp    %eax,%edx
  802d16:	75 33                	jne    802d4b <insert_sorted_with_merge_freeList+0x1c4>
							== iterator->sva) {
						iterator->sva = blockToInsert->sva;
  802d18:	8b 45 08             	mov    0x8(%ebp),%eax
  802d1b:	8b 50 08             	mov    0x8(%eax),%edx
  802d1e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d21:	89 50 08             	mov    %edx,0x8(%eax)
						iterator->size = iterator->size + blockToInsert->size;
  802d24:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d27:	8b 50 0c             	mov    0xc(%eax),%edx
  802d2a:	8b 45 08             	mov    0x8(%ebp),%eax
  802d2d:	8b 40 0c             	mov    0xc(%eax),%eax
  802d30:	01 c2                	add    %eax,%edx
  802d32:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d35:	89 50 0c             	mov    %edx,0xc(%eax)
						addToAvailMemBlocksList(blockToInsert);
  802d38:	83 ec 0c             	sub    $0xc,%esp
  802d3b:	ff 75 08             	pushl  0x8(%ebp)
  802d3e:	e8 c4 fd ff ff       	call   802b07 <addToAvailMemBlocksList>
  802d43:	83 c4 10             	add    $0x10,%esp

					else {
						LIST_INSERT_BEFORE(&FreeMemBlocksList, iterator,
								blockToInsert);
					}
					break;
  802d46:	e9 80 02 00 00       	jmp    802fcb <insert_sorted_with_merge_freeList+0x444>
						addToAvailMemBlocksList(blockToInsert);

					}

					else {
						LIST_INSERT_BEFORE(&FreeMemBlocksList, iterator,
  802d4b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802d4f:	74 06                	je     802d57 <insert_sorted_with_merge_freeList+0x1d0>
  802d51:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802d55:	75 17                	jne    802d6e <insert_sorted_with_merge_freeList+0x1e7>
  802d57:	83 ec 04             	sub    $0x4,%esp
  802d5a:	68 08 3d 80 00       	push   $0x803d08
  802d5f:	68 3a 01 00 00       	push   $0x13a
  802d64:	68 77 3c 80 00       	push   $0x803c77
  802d69:	e8 86 d6 ff ff       	call   8003f4 <_panic>
  802d6e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d71:	8b 50 04             	mov    0x4(%eax),%edx
  802d74:	8b 45 08             	mov    0x8(%ebp),%eax
  802d77:	89 50 04             	mov    %edx,0x4(%eax)
  802d7a:	8b 45 08             	mov    0x8(%ebp),%eax
  802d7d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802d80:	89 10                	mov    %edx,(%eax)
  802d82:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d85:	8b 40 04             	mov    0x4(%eax),%eax
  802d88:	85 c0                	test   %eax,%eax
  802d8a:	74 0d                	je     802d99 <insert_sorted_with_merge_freeList+0x212>
  802d8c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d8f:	8b 40 04             	mov    0x4(%eax),%eax
  802d92:	8b 55 08             	mov    0x8(%ebp),%edx
  802d95:	89 10                	mov    %edx,(%eax)
  802d97:	eb 08                	jmp    802da1 <insert_sorted_with_merge_freeList+0x21a>
  802d99:	8b 45 08             	mov    0x8(%ebp),%eax
  802d9c:	a3 38 41 80 00       	mov    %eax,0x804138
  802da1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802da4:	8b 55 08             	mov    0x8(%ebp),%edx
  802da7:	89 50 04             	mov    %edx,0x4(%eax)
  802daa:	a1 44 41 80 00       	mov    0x804144,%eax
  802daf:	40                   	inc    %eax
  802db0:	a3 44 41 80 00       	mov    %eax,0x804144
								blockToInsert);
					}
					break;
  802db5:	e9 11 02 00 00       	jmp    802fcb <insert_sorted_with_merge_freeList+0x444>
				} else {
					//prev and next merge
					if (prev->sva + prev->size + blockToInsert->size
  802dba:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802dbd:	8b 50 08             	mov    0x8(%eax),%edx
  802dc0:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802dc3:	8b 40 0c             	mov    0xc(%eax),%eax
  802dc6:	01 c2                	add    %eax,%edx
  802dc8:	8b 45 08             	mov    0x8(%ebp),%eax
  802dcb:	8b 40 0c             	mov    0xc(%eax),%eax
  802dce:	01 c2                	add    %eax,%edx
							== iterator->sva) {
  802dd0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802dd3:	8b 40 08             	mov    0x8(%eax),%eax
								blockToInsert);
					}
					break;
				} else {
					//prev and next merge
					if (prev->sva + prev->size + blockToInsert->size
  802dd6:	39 c2                	cmp    %eax,%edx
  802dd8:	0f 85 bf 00 00 00    	jne    802e9d <insert_sorted_with_merge_freeList+0x316>
							== iterator->sva) {
						prev->size = prev->size + blockToInsert->size
  802dde:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802de1:	8b 50 0c             	mov    0xc(%eax),%edx
  802de4:	8b 45 08             	mov    0x8(%ebp),%eax
  802de7:	8b 40 0c             	mov    0xc(%eax),%eax
  802dea:	01 c2                	add    %eax,%edx
								+ iterator->size;
  802dec:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802def:	8b 40 0c             	mov    0xc(%eax),%eax
  802df2:	01 c2                	add    %eax,%edx
					break;
				} else {
					//prev and next merge
					if (prev->sva + prev->size + blockToInsert->size
							== iterator->sva) {
						prev->size = prev->size + blockToInsert->size
  802df4:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802df7:	89 50 0c             	mov    %edx,0xc(%eax)
								+ iterator->size;
						LIST_REMOVE(&FreeMemBlocksList, iterator);
  802dfa:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802dfe:	75 17                	jne    802e17 <insert_sorted_with_merge_freeList+0x290>
  802e00:	83 ec 04             	sub    $0x4,%esp
  802e03:	68 e8 3c 80 00       	push   $0x803ce8
  802e08:	68 43 01 00 00       	push   $0x143
  802e0d:	68 77 3c 80 00       	push   $0x803c77
  802e12:	e8 dd d5 ff ff       	call   8003f4 <_panic>
  802e17:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e1a:	8b 00                	mov    (%eax),%eax
  802e1c:	85 c0                	test   %eax,%eax
  802e1e:	74 10                	je     802e30 <insert_sorted_with_merge_freeList+0x2a9>
  802e20:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e23:	8b 00                	mov    (%eax),%eax
  802e25:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802e28:	8b 52 04             	mov    0x4(%edx),%edx
  802e2b:	89 50 04             	mov    %edx,0x4(%eax)
  802e2e:	eb 0b                	jmp    802e3b <insert_sorted_with_merge_freeList+0x2b4>
  802e30:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e33:	8b 40 04             	mov    0x4(%eax),%eax
  802e36:	a3 3c 41 80 00       	mov    %eax,0x80413c
  802e3b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e3e:	8b 40 04             	mov    0x4(%eax),%eax
  802e41:	85 c0                	test   %eax,%eax
  802e43:	74 0f                	je     802e54 <insert_sorted_with_merge_freeList+0x2cd>
  802e45:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e48:	8b 40 04             	mov    0x4(%eax),%eax
  802e4b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802e4e:	8b 12                	mov    (%edx),%edx
  802e50:	89 10                	mov    %edx,(%eax)
  802e52:	eb 0a                	jmp    802e5e <insert_sorted_with_merge_freeList+0x2d7>
  802e54:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e57:	8b 00                	mov    (%eax),%eax
  802e59:	a3 38 41 80 00       	mov    %eax,0x804138
  802e5e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e61:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802e67:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e6a:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802e71:	a1 44 41 80 00       	mov    0x804144,%eax
  802e76:	48                   	dec    %eax
  802e77:	a3 44 41 80 00       	mov    %eax,0x804144
						addToAvailMemBlocksList(blockToInsert);
  802e7c:	83 ec 0c             	sub    $0xc,%esp
  802e7f:	ff 75 08             	pushl  0x8(%ebp)
  802e82:	e8 80 fc ff ff       	call   802b07 <addToAvailMemBlocksList>
  802e87:	83 c4 10             	add    $0x10,%esp
						addToAvailMemBlocksList(iterator);
  802e8a:	83 ec 0c             	sub    $0xc,%esp
  802e8d:	ff 75 f4             	pushl  -0xc(%ebp)
  802e90:	e8 72 fc ff ff       	call   802b07 <addToAvailMemBlocksList>
  802e95:	83 c4 10             	add    $0x10,%esp
					//Insert
					else {
						LIST_INSERT_BEFORE(&FreeMemBlocksList, iterator,
								blockToInsert);
					}
					break;
  802e98:	e9 2e 01 00 00       	jmp    802fcb <insert_sorted_with_merge_freeList+0x444>
						LIST_REMOVE(&FreeMemBlocksList, iterator);
						addToAvailMemBlocksList(blockToInsert);
						addToAvailMemBlocksList(iterator);
					}
					//previous merge
					else if (prev->sva + prev->size == blockToInsert->sva) {
  802e9d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802ea0:	8b 50 08             	mov    0x8(%eax),%edx
  802ea3:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802ea6:	8b 40 0c             	mov    0xc(%eax),%eax
  802ea9:	01 c2                	add    %eax,%edx
  802eab:	8b 45 08             	mov    0x8(%ebp),%eax
  802eae:	8b 40 08             	mov    0x8(%eax),%eax
  802eb1:	39 c2                	cmp    %eax,%edx
  802eb3:	75 27                	jne    802edc <insert_sorted_with_merge_freeList+0x355>
						prev->size = prev->size + blockToInsert->size;
  802eb5:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802eb8:	8b 50 0c             	mov    0xc(%eax),%edx
  802ebb:	8b 45 08             	mov    0x8(%ebp),%eax
  802ebe:	8b 40 0c             	mov    0xc(%eax),%eax
  802ec1:	01 c2                	add    %eax,%edx
  802ec3:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802ec6:	89 50 0c             	mov    %edx,0xc(%eax)
						addToAvailMemBlocksList(blockToInsert);
  802ec9:	83 ec 0c             	sub    $0xc,%esp
  802ecc:	ff 75 08             	pushl  0x8(%ebp)
  802ecf:	e8 33 fc ff ff       	call   802b07 <addToAvailMemBlocksList>
  802ed4:	83 c4 10             	add    $0x10,%esp
					//Insert
					else {
						LIST_INSERT_BEFORE(&FreeMemBlocksList, iterator,
								blockToInsert);
					}
					break;
  802ed7:	e9 ef 00 00 00       	jmp    802fcb <insert_sorted_with_merge_freeList+0x444>
					else if (prev->sva + prev->size == blockToInsert->sva) {
						prev->size = prev->size + blockToInsert->size;
						addToAvailMemBlocksList(blockToInsert);
					}
					//next merge
					else if (blockToInsert->size + blockToInsert->sva
  802edc:	8b 45 08             	mov    0x8(%ebp),%eax
  802edf:	8b 50 0c             	mov    0xc(%eax),%edx
  802ee2:	8b 45 08             	mov    0x8(%ebp),%eax
  802ee5:	8b 40 08             	mov    0x8(%eax),%eax
  802ee8:	01 c2                	add    %eax,%edx
							== iterator->sva) {
  802eea:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802eed:	8b 40 08             	mov    0x8(%eax),%eax
					else if (prev->sva + prev->size == blockToInsert->sva) {
						prev->size = prev->size + blockToInsert->size;
						addToAvailMemBlocksList(blockToInsert);
					}
					//next merge
					else if (blockToInsert->size + blockToInsert->sva
  802ef0:	39 c2                	cmp    %eax,%edx
  802ef2:	75 33                	jne    802f27 <insert_sorted_with_merge_freeList+0x3a0>
							== iterator->sva) {
						iterator->sva = blockToInsert->sva;
  802ef4:	8b 45 08             	mov    0x8(%ebp),%eax
  802ef7:	8b 50 08             	mov    0x8(%eax),%edx
  802efa:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802efd:	89 50 08             	mov    %edx,0x8(%eax)
						iterator->size = iterator->size + blockToInsert->size;
  802f00:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f03:	8b 50 0c             	mov    0xc(%eax),%edx
  802f06:	8b 45 08             	mov    0x8(%ebp),%eax
  802f09:	8b 40 0c             	mov    0xc(%eax),%eax
  802f0c:	01 c2                	add    %eax,%edx
  802f0e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f11:	89 50 0c             	mov    %edx,0xc(%eax)
						addToAvailMemBlocksList(blockToInsert);
  802f14:	83 ec 0c             	sub    $0xc,%esp
  802f17:	ff 75 08             	pushl  0x8(%ebp)
  802f1a:	e8 e8 fb ff ff       	call   802b07 <addToAvailMemBlocksList>
  802f1f:	83 c4 10             	add    $0x10,%esp
					//Insert
					else {
						LIST_INSERT_BEFORE(&FreeMemBlocksList, iterator,
								blockToInsert);
					}
					break;
  802f22:	e9 a4 00 00 00       	jmp    802fcb <insert_sorted_with_merge_freeList+0x444>
						iterator->size = iterator->size + blockToInsert->size;
						addToAvailMemBlocksList(blockToInsert);
					}
					//Insert
					else {
						LIST_INSERT_BEFORE(&FreeMemBlocksList, iterator,
  802f27:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802f2b:	74 06                	je     802f33 <insert_sorted_with_merge_freeList+0x3ac>
  802f2d:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802f31:	75 17                	jne    802f4a <insert_sorted_with_merge_freeList+0x3c3>
  802f33:	83 ec 04             	sub    $0x4,%esp
  802f36:	68 08 3d 80 00       	push   $0x803d08
  802f3b:	68 56 01 00 00       	push   $0x156
  802f40:	68 77 3c 80 00       	push   $0x803c77
  802f45:	e8 aa d4 ff ff       	call   8003f4 <_panic>
  802f4a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f4d:	8b 50 04             	mov    0x4(%eax),%edx
  802f50:	8b 45 08             	mov    0x8(%ebp),%eax
  802f53:	89 50 04             	mov    %edx,0x4(%eax)
  802f56:	8b 45 08             	mov    0x8(%ebp),%eax
  802f59:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802f5c:	89 10                	mov    %edx,(%eax)
  802f5e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f61:	8b 40 04             	mov    0x4(%eax),%eax
  802f64:	85 c0                	test   %eax,%eax
  802f66:	74 0d                	je     802f75 <insert_sorted_with_merge_freeList+0x3ee>
  802f68:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f6b:	8b 40 04             	mov    0x4(%eax),%eax
  802f6e:	8b 55 08             	mov    0x8(%ebp),%edx
  802f71:	89 10                	mov    %edx,(%eax)
  802f73:	eb 08                	jmp    802f7d <insert_sorted_with_merge_freeList+0x3f6>
  802f75:	8b 45 08             	mov    0x8(%ebp),%eax
  802f78:	a3 38 41 80 00       	mov    %eax,0x804138
  802f7d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f80:	8b 55 08             	mov    0x8(%ebp),%edx
  802f83:	89 50 04             	mov    %edx,0x4(%eax)
  802f86:	a1 44 41 80 00       	mov    0x804144,%eax
  802f8b:	40                   	inc    %eax
  802f8c:	a3 44 41 80 00       	mov    %eax,0x804144
								blockToInsert);
					}
					break;
  802f91:	eb 38                	jmp    802fcb <insert_sorted_with_merge_freeList+0x444>
		} else {
			LIST_INSERT_AFTER(&FreeMemBlocksList, last, blockToInsert);
		}
	} else {
		struct MemBlock *iterator;
		LIST_FOREACH(iterator, &(FreeMemBlocksList))
  802f93:	a1 40 41 80 00       	mov    0x804140,%eax
  802f98:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802f9b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802f9f:	74 07                	je     802fa8 <insert_sorted_with_merge_freeList+0x421>
  802fa1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802fa4:	8b 00                	mov    (%eax),%eax
  802fa6:	eb 05                	jmp    802fad <insert_sorted_with_merge_freeList+0x426>
  802fa8:	b8 00 00 00 00       	mov    $0x0,%eax
  802fad:	a3 40 41 80 00       	mov    %eax,0x804140
  802fb2:	a1 40 41 80 00       	mov    0x804140,%eax
  802fb7:	85 c0                	test   %eax,%eax
  802fb9:	0f 85 1a fd ff ff    	jne    802cd9 <insert_sorted_with_merge_freeList+0x152>
  802fbf:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802fc3:	0f 85 10 fd ff ff    	jne    802cd9 <insert_sorted_with_merge_freeList+0x152>
		}
	}

	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  802fc9:	eb 00                	jmp    802fcb <insert_sorted_with_merge_freeList+0x444>
  802fcb:	90                   	nop
  802fcc:	c9                   	leave  
  802fcd:	c3                   	ret    
  802fce:	66 90                	xchg   %ax,%ax

00802fd0 <__udivdi3>:
  802fd0:	55                   	push   %ebp
  802fd1:	57                   	push   %edi
  802fd2:	56                   	push   %esi
  802fd3:	53                   	push   %ebx
  802fd4:	83 ec 1c             	sub    $0x1c,%esp
  802fd7:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  802fdb:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  802fdf:	8b 7c 24 38          	mov    0x38(%esp),%edi
  802fe3:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  802fe7:	89 ca                	mov    %ecx,%edx
  802fe9:	89 f8                	mov    %edi,%eax
  802feb:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  802fef:	85 f6                	test   %esi,%esi
  802ff1:	75 2d                	jne    803020 <__udivdi3+0x50>
  802ff3:	39 cf                	cmp    %ecx,%edi
  802ff5:	77 65                	ja     80305c <__udivdi3+0x8c>
  802ff7:	89 fd                	mov    %edi,%ebp
  802ff9:	85 ff                	test   %edi,%edi
  802ffb:	75 0b                	jne    803008 <__udivdi3+0x38>
  802ffd:	b8 01 00 00 00       	mov    $0x1,%eax
  803002:	31 d2                	xor    %edx,%edx
  803004:	f7 f7                	div    %edi
  803006:	89 c5                	mov    %eax,%ebp
  803008:	31 d2                	xor    %edx,%edx
  80300a:	89 c8                	mov    %ecx,%eax
  80300c:	f7 f5                	div    %ebp
  80300e:	89 c1                	mov    %eax,%ecx
  803010:	89 d8                	mov    %ebx,%eax
  803012:	f7 f5                	div    %ebp
  803014:	89 cf                	mov    %ecx,%edi
  803016:	89 fa                	mov    %edi,%edx
  803018:	83 c4 1c             	add    $0x1c,%esp
  80301b:	5b                   	pop    %ebx
  80301c:	5e                   	pop    %esi
  80301d:	5f                   	pop    %edi
  80301e:	5d                   	pop    %ebp
  80301f:	c3                   	ret    
  803020:	39 ce                	cmp    %ecx,%esi
  803022:	77 28                	ja     80304c <__udivdi3+0x7c>
  803024:	0f bd fe             	bsr    %esi,%edi
  803027:	83 f7 1f             	xor    $0x1f,%edi
  80302a:	75 40                	jne    80306c <__udivdi3+0x9c>
  80302c:	39 ce                	cmp    %ecx,%esi
  80302e:	72 0a                	jb     80303a <__udivdi3+0x6a>
  803030:	3b 44 24 08          	cmp    0x8(%esp),%eax
  803034:	0f 87 9e 00 00 00    	ja     8030d8 <__udivdi3+0x108>
  80303a:	b8 01 00 00 00       	mov    $0x1,%eax
  80303f:	89 fa                	mov    %edi,%edx
  803041:	83 c4 1c             	add    $0x1c,%esp
  803044:	5b                   	pop    %ebx
  803045:	5e                   	pop    %esi
  803046:	5f                   	pop    %edi
  803047:	5d                   	pop    %ebp
  803048:	c3                   	ret    
  803049:	8d 76 00             	lea    0x0(%esi),%esi
  80304c:	31 ff                	xor    %edi,%edi
  80304e:	31 c0                	xor    %eax,%eax
  803050:	89 fa                	mov    %edi,%edx
  803052:	83 c4 1c             	add    $0x1c,%esp
  803055:	5b                   	pop    %ebx
  803056:	5e                   	pop    %esi
  803057:	5f                   	pop    %edi
  803058:	5d                   	pop    %ebp
  803059:	c3                   	ret    
  80305a:	66 90                	xchg   %ax,%ax
  80305c:	89 d8                	mov    %ebx,%eax
  80305e:	f7 f7                	div    %edi
  803060:	31 ff                	xor    %edi,%edi
  803062:	89 fa                	mov    %edi,%edx
  803064:	83 c4 1c             	add    $0x1c,%esp
  803067:	5b                   	pop    %ebx
  803068:	5e                   	pop    %esi
  803069:	5f                   	pop    %edi
  80306a:	5d                   	pop    %ebp
  80306b:	c3                   	ret    
  80306c:	bd 20 00 00 00       	mov    $0x20,%ebp
  803071:	89 eb                	mov    %ebp,%ebx
  803073:	29 fb                	sub    %edi,%ebx
  803075:	89 f9                	mov    %edi,%ecx
  803077:	d3 e6                	shl    %cl,%esi
  803079:	89 c5                	mov    %eax,%ebp
  80307b:	88 d9                	mov    %bl,%cl
  80307d:	d3 ed                	shr    %cl,%ebp
  80307f:	89 e9                	mov    %ebp,%ecx
  803081:	09 f1                	or     %esi,%ecx
  803083:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  803087:	89 f9                	mov    %edi,%ecx
  803089:	d3 e0                	shl    %cl,%eax
  80308b:	89 c5                	mov    %eax,%ebp
  80308d:	89 d6                	mov    %edx,%esi
  80308f:	88 d9                	mov    %bl,%cl
  803091:	d3 ee                	shr    %cl,%esi
  803093:	89 f9                	mov    %edi,%ecx
  803095:	d3 e2                	shl    %cl,%edx
  803097:	8b 44 24 08          	mov    0x8(%esp),%eax
  80309b:	88 d9                	mov    %bl,%cl
  80309d:	d3 e8                	shr    %cl,%eax
  80309f:	09 c2                	or     %eax,%edx
  8030a1:	89 d0                	mov    %edx,%eax
  8030a3:	89 f2                	mov    %esi,%edx
  8030a5:	f7 74 24 0c          	divl   0xc(%esp)
  8030a9:	89 d6                	mov    %edx,%esi
  8030ab:	89 c3                	mov    %eax,%ebx
  8030ad:	f7 e5                	mul    %ebp
  8030af:	39 d6                	cmp    %edx,%esi
  8030b1:	72 19                	jb     8030cc <__udivdi3+0xfc>
  8030b3:	74 0b                	je     8030c0 <__udivdi3+0xf0>
  8030b5:	89 d8                	mov    %ebx,%eax
  8030b7:	31 ff                	xor    %edi,%edi
  8030b9:	e9 58 ff ff ff       	jmp    803016 <__udivdi3+0x46>
  8030be:	66 90                	xchg   %ax,%ax
  8030c0:	8b 54 24 08          	mov    0x8(%esp),%edx
  8030c4:	89 f9                	mov    %edi,%ecx
  8030c6:	d3 e2                	shl    %cl,%edx
  8030c8:	39 c2                	cmp    %eax,%edx
  8030ca:	73 e9                	jae    8030b5 <__udivdi3+0xe5>
  8030cc:	8d 43 ff             	lea    -0x1(%ebx),%eax
  8030cf:	31 ff                	xor    %edi,%edi
  8030d1:	e9 40 ff ff ff       	jmp    803016 <__udivdi3+0x46>
  8030d6:	66 90                	xchg   %ax,%ax
  8030d8:	31 c0                	xor    %eax,%eax
  8030da:	e9 37 ff ff ff       	jmp    803016 <__udivdi3+0x46>
  8030df:	90                   	nop

008030e0 <__umoddi3>:
  8030e0:	55                   	push   %ebp
  8030e1:	57                   	push   %edi
  8030e2:	56                   	push   %esi
  8030e3:	53                   	push   %ebx
  8030e4:	83 ec 1c             	sub    $0x1c,%esp
  8030e7:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  8030eb:	8b 74 24 34          	mov    0x34(%esp),%esi
  8030ef:	8b 7c 24 38          	mov    0x38(%esp),%edi
  8030f3:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  8030f7:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8030fb:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8030ff:	89 f3                	mov    %esi,%ebx
  803101:	89 fa                	mov    %edi,%edx
  803103:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  803107:	89 34 24             	mov    %esi,(%esp)
  80310a:	85 c0                	test   %eax,%eax
  80310c:	75 1a                	jne    803128 <__umoddi3+0x48>
  80310e:	39 f7                	cmp    %esi,%edi
  803110:	0f 86 a2 00 00 00    	jbe    8031b8 <__umoddi3+0xd8>
  803116:	89 c8                	mov    %ecx,%eax
  803118:	89 f2                	mov    %esi,%edx
  80311a:	f7 f7                	div    %edi
  80311c:	89 d0                	mov    %edx,%eax
  80311e:	31 d2                	xor    %edx,%edx
  803120:	83 c4 1c             	add    $0x1c,%esp
  803123:	5b                   	pop    %ebx
  803124:	5e                   	pop    %esi
  803125:	5f                   	pop    %edi
  803126:	5d                   	pop    %ebp
  803127:	c3                   	ret    
  803128:	39 f0                	cmp    %esi,%eax
  80312a:	0f 87 ac 00 00 00    	ja     8031dc <__umoddi3+0xfc>
  803130:	0f bd e8             	bsr    %eax,%ebp
  803133:	83 f5 1f             	xor    $0x1f,%ebp
  803136:	0f 84 ac 00 00 00    	je     8031e8 <__umoddi3+0x108>
  80313c:	bf 20 00 00 00       	mov    $0x20,%edi
  803141:	29 ef                	sub    %ebp,%edi
  803143:	89 fe                	mov    %edi,%esi
  803145:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  803149:	89 e9                	mov    %ebp,%ecx
  80314b:	d3 e0                	shl    %cl,%eax
  80314d:	89 d7                	mov    %edx,%edi
  80314f:	89 f1                	mov    %esi,%ecx
  803151:	d3 ef                	shr    %cl,%edi
  803153:	09 c7                	or     %eax,%edi
  803155:	89 e9                	mov    %ebp,%ecx
  803157:	d3 e2                	shl    %cl,%edx
  803159:	89 14 24             	mov    %edx,(%esp)
  80315c:	89 d8                	mov    %ebx,%eax
  80315e:	d3 e0                	shl    %cl,%eax
  803160:	89 c2                	mov    %eax,%edx
  803162:	8b 44 24 08          	mov    0x8(%esp),%eax
  803166:	d3 e0                	shl    %cl,%eax
  803168:	89 44 24 04          	mov    %eax,0x4(%esp)
  80316c:	8b 44 24 08          	mov    0x8(%esp),%eax
  803170:	89 f1                	mov    %esi,%ecx
  803172:	d3 e8                	shr    %cl,%eax
  803174:	09 d0                	or     %edx,%eax
  803176:	d3 eb                	shr    %cl,%ebx
  803178:	89 da                	mov    %ebx,%edx
  80317a:	f7 f7                	div    %edi
  80317c:	89 d3                	mov    %edx,%ebx
  80317e:	f7 24 24             	mull   (%esp)
  803181:	89 c6                	mov    %eax,%esi
  803183:	89 d1                	mov    %edx,%ecx
  803185:	39 d3                	cmp    %edx,%ebx
  803187:	0f 82 87 00 00 00    	jb     803214 <__umoddi3+0x134>
  80318d:	0f 84 91 00 00 00    	je     803224 <__umoddi3+0x144>
  803193:	8b 54 24 04          	mov    0x4(%esp),%edx
  803197:	29 f2                	sub    %esi,%edx
  803199:	19 cb                	sbb    %ecx,%ebx
  80319b:	89 d8                	mov    %ebx,%eax
  80319d:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  8031a1:	d3 e0                	shl    %cl,%eax
  8031a3:	89 e9                	mov    %ebp,%ecx
  8031a5:	d3 ea                	shr    %cl,%edx
  8031a7:	09 d0                	or     %edx,%eax
  8031a9:	89 e9                	mov    %ebp,%ecx
  8031ab:	d3 eb                	shr    %cl,%ebx
  8031ad:	89 da                	mov    %ebx,%edx
  8031af:	83 c4 1c             	add    $0x1c,%esp
  8031b2:	5b                   	pop    %ebx
  8031b3:	5e                   	pop    %esi
  8031b4:	5f                   	pop    %edi
  8031b5:	5d                   	pop    %ebp
  8031b6:	c3                   	ret    
  8031b7:	90                   	nop
  8031b8:	89 fd                	mov    %edi,%ebp
  8031ba:	85 ff                	test   %edi,%edi
  8031bc:	75 0b                	jne    8031c9 <__umoddi3+0xe9>
  8031be:	b8 01 00 00 00       	mov    $0x1,%eax
  8031c3:	31 d2                	xor    %edx,%edx
  8031c5:	f7 f7                	div    %edi
  8031c7:	89 c5                	mov    %eax,%ebp
  8031c9:	89 f0                	mov    %esi,%eax
  8031cb:	31 d2                	xor    %edx,%edx
  8031cd:	f7 f5                	div    %ebp
  8031cf:	89 c8                	mov    %ecx,%eax
  8031d1:	f7 f5                	div    %ebp
  8031d3:	89 d0                	mov    %edx,%eax
  8031d5:	e9 44 ff ff ff       	jmp    80311e <__umoddi3+0x3e>
  8031da:	66 90                	xchg   %ax,%ax
  8031dc:	89 c8                	mov    %ecx,%eax
  8031de:	89 f2                	mov    %esi,%edx
  8031e0:	83 c4 1c             	add    $0x1c,%esp
  8031e3:	5b                   	pop    %ebx
  8031e4:	5e                   	pop    %esi
  8031e5:	5f                   	pop    %edi
  8031e6:	5d                   	pop    %ebp
  8031e7:	c3                   	ret    
  8031e8:	3b 04 24             	cmp    (%esp),%eax
  8031eb:	72 06                	jb     8031f3 <__umoddi3+0x113>
  8031ed:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  8031f1:	77 0f                	ja     803202 <__umoddi3+0x122>
  8031f3:	89 f2                	mov    %esi,%edx
  8031f5:	29 f9                	sub    %edi,%ecx
  8031f7:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  8031fb:	89 14 24             	mov    %edx,(%esp)
  8031fe:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  803202:	8b 44 24 04          	mov    0x4(%esp),%eax
  803206:	8b 14 24             	mov    (%esp),%edx
  803209:	83 c4 1c             	add    $0x1c,%esp
  80320c:	5b                   	pop    %ebx
  80320d:	5e                   	pop    %esi
  80320e:	5f                   	pop    %edi
  80320f:	5d                   	pop    %ebp
  803210:	c3                   	ret    
  803211:	8d 76 00             	lea    0x0(%esi),%esi
  803214:	2b 04 24             	sub    (%esp),%eax
  803217:	19 fa                	sbb    %edi,%edx
  803219:	89 d1                	mov    %edx,%ecx
  80321b:	89 c6                	mov    %eax,%esi
  80321d:	e9 71 ff ff ff       	jmp    803193 <__umoddi3+0xb3>
  803222:	66 90                	xchg   %ax,%ax
  803224:	39 44 24 04          	cmp    %eax,0x4(%esp)
  803228:	72 ea                	jb     803214 <__umoddi3+0x134>
  80322a:	89 d9                	mov    %ebx,%ecx
  80322c:	e9 62 ff ff ff       	jmp    803193 <__umoddi3+0xb3>
