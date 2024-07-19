
obj/user/tst_freeRAM_2:     file format elf32-i386


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
  800031:	e8 ac 05 00 00       	call   8005e2 <libmain>
1:      jmp 1b
  800036:	eb fe                	jmp    800036 <args_exist+0x5>

00800038 <_main>:
	char a;
	short b;
	int c;
};
void _main(void)
{
  800038:	55                   	push   %ebp
  800039:	89 e5                	mov    %esp,%ebp
  80003b:	57                   	push   %edi
  80003c:	53                   	push   %ebx
  80003d:	81 ec b0 00 00 00    	sub    $0xb0,%esp





	int Mega = 1024*1024;
  800043:	c7 45 f4 00 00 10 00 	movl   $0x100000,-0xc(%ebp)
	int kilo = 1024;
  80004a:	c7 45 f0 00 04 00 00 	movl   $0x400,-0x10(%ebp)
	char minByte = 1<<7;
  800051:	c6 45 ef 80          	movb   $0x80,-0x11(%ebp)
	char maxByte = 0x7F;
  800055:	c6 45 ee 7f          	movb   $0x7f,-0x12(%ebp)
	short minShort = 1<<15 ;
  800059:	66 c7 45 ec 00 80    	movw   $0x8000,-0x14(%ebp)
	short maxShort = 0x7FFF;
  80005f:	66 c7 45 ea ff 7f    	movw   $0x7fff,-0x16(%ebp)
	int minInt = 1<<31 ;
  800065:	c7 45 e4 00 00 00 80 	movl   $0x80000000,-0x1c(%ebp)
	int maxInt = 0x7FFFFFFF;
  80006c:	c7 45 e0 ff ff ff 7f 	movl   $0x7fffffff,-0x20(%ebp)

	void* ptr_allocations[20] = {0};
  800073:	8d 95 4c ff ff ff    	lea    -0xb4(%ebp),%edx
  800079:	b9 14 00 00 00       	mov    $0x14,%ecx
  80007e:	b8 00 00 00 00       	mov    $0x0,%eax
  800083:	89 d7                	mov    %edx,%edi
  800085:	f3 ab                	rep stos %eax,%es:(%edi)
	{
		//Load "fib" & "fos_helloWorld" programs into RAM
		cprintf("Loading Fib & fos_helloWorld programs into RAM...");
  800087:	83 ec 0c             	sub    $0xc,%esp
  80008a:	68 20 36 80 00       	push   $0x803620
  80008f:	e8 3e 09 00 00       	call   8009d2 <cprintf>
  800094:	83 c4 10             	add    $0x10,%esp
		int32 envIdFib = sys_create_env("fib", (myEnv->page_WS_max_size),(myEnv->SecondListSize), (myEnv->percentage_of_WS_pages_to_be_removed));
  800097:	a1 20 40 80 00       	mov    0x804020,%eax
  80009c:	8b 90 a0 05 00 00    	mov    0x5a0(%eax),%edx
  8000a2:	a1 20 40 80 00       	mov    0x804020,%eax
  8000a7:	8b 80 ec 05 00 00    	mov    0x5ec(%eax),%eax
  8000ad:	89 c1                	mov    %eax,%ecx
  8000af:	a1 20 40 80 00       	mov    0x804020,%eax
  8000b4:	8b 40 74             	mov    0x74(%eax),%eax
  8000b7:	52                   	push   %edx
  8000b8:	51                   	push   %ecx
  8000b9:	50                   	push   %eax
  8000ba:	68 52 36 80 00       	push   $0x803652
  8000bf:	e8 1e 1f 00 00       	call   801fe2 <sys_create_env>
  8000c4:	83 c4 10             	add    $0x10,%esp
  8000c7:	89 45 dc             	mov    %eax,-0x24(%ebp)
		int freeFrames = sys_calculate_free_frames() ;
  8000ca:	e8 a1 1c 00 00       	call   801d70 <sys_calculate_free_frames>
  8000cf:	89 45 d8             	mov    %eax,-0x28(%ebp)
		int32 envIdHelloWorld = sys_create_env("fos_helloWorld", (myEnv->page_WS_max_size),(myEnv->SecondListSize), (myEnv->percentage_of_WS_pages_to_be_removed));
  8000d2:	a1 20 40 80 00       	mov    0x804020,%eax
  8000d7:	8b 90 a0 05 00 00    	mov    0x5a0(%eax),%edx
  8000dd:	a1 20 40 80 00       	mov    0x804020,%eax
  8000e2:	8b 80 ec 05 00 00    	mov    0x5ec(%eax),%eax
  8000e8:	89 c1                	mov    %eax,%ecx
  8000ea:	a1 20 40 80 00       	mov    0x804020,%eax
  8000ef:	8b 40 74             	mov    0x74(%eax),%eax
  8000f2:	52                   	push   %edx
  8000f3:	51                   	push   %ecx
  8000f4:	50                   	push   %eax
  8000f5:	68 56 36 80 00       	push   $0x803656
  8000fa:	e8 e3 1e 00 00       	call   801fe2 <sys_create_env>
  8000ff:	83 c4 10             	add    $0x10,%esp
  800102:	89 45 d4             	mov    %eax,-0x2c(%ebp)
		int helloWorldFrames = freeFrames - sys_calculate_free_frames() ;
  800105:	8b 5d d8             	mov    -0x28(%ebp),%ebx
  800108:	e8 63 1c 00 00       	call   801d70 <sys_calculate_free_frames>
  80010d:	29 c3                	sub    %eax,%ebx
  80010f:	89 d8                	mov    %ebx,%eax
  800111:	89 45 d0             	mov    %eax,-0x30(%ebp)
		env_sleep(2000);
  800114:	83 ec 0c             	sub    $0xc,%esp
  800117:	68 d0 07 00 00       	push   $0x7d0
  80011c:	e8 d7 31 00 00       	call   8032f8 <env_sleep>
  800121:	83 c4 10             	add    $0x10,%esp
		cprintf("[DONE]\n\n");
  800124:	83 ec 0c             	sub    $0xc,%esp
  800127:	68 65 36 80 00       	push   $0x803665
  80012c:	e8 a1 08 00 00       	call   8009d2 <cprintf>
  800131:	83 c4 10             	add    $0x10,%esp

		//Load and run "fos_add"
		cprintf("Loading fos_add program into RAM...");
  800134:	83 ec 0c             	sub    $0xc,%esp
  800137:	68 70 36 80 00       	push   $0x803670
  80013c:	e8 91 08 00 00       	call   8009d2 <cprintf>
  800141:	83 c4 10             	add    $0x10,%esp
		int32 envIdFOSAdd= sys_create_env("fos_add", (myEnv->page_WS_max_size), (myEnv->SecondListSize),(myEnv->percentage_of_WS_pages_to_be_removed));
  800144:	a1 20 40 80 00       	mov    0x804020,%eax
  800149:	8b 90 a0 05 00 00    	mov    0x5a0(%eax),%edx
  80014f:	a1 20 40 80 00       	mov    0x804020,%eax
  800154:	8b 80 ec 05 00 00    	mov    0x5ec(%eax),%eax
  80015a:	89 c1                	mov    %eax,%ecx
  80015c:	a1 20 40 80 00       	mov    0x804020,%eax
  800161:	8b 40 74             	mov    0x74(%eax),%eax
  800164:	52                   	push   %edx
  800165:	51                   	push   %ecx
  800166:	50                   	push   %eax
  800167:	68 94 36 80 00       	push   $0x803694
  80016c:	e8 71 1e 00 00       	call   801fe2 <sys_create_env>
  800171:	83 c4 10             	add    $0x10,%esp
  800174:	89 45 cc             	mov    %eax,-0x34(%ebp)
		env_sleep(2000);
  800177:	83 ec 0c             	sub    $0xc,%esp
  80017a:	68 d0 07 00 00       	push   $0x7d0
  80017f:	e8 74 31 00 00       	call   8032f8 <env_sleep>
  800184:	83 c4 10             	add    $0x10,%esp
		cprintf("[DONE]\n\n");
  800187:	83 ec 0c             	sub    $0xc,%esp
  80018a:	68 65 36 80 00       	push   $0x803665
  80018f:	e8 3e 08 00 00       	call   8009d2 <cprintf>
  800194:	83 c4 10             	add    $0x10,%esp
		cprintf("running fos_add program...\n\n");
  800197:	83 ec 0c             	sub    $0xc,%esp
  80019a:	68 9c 36 80 00       	push   $0x80369c
  80019f:	e8 2e 08 00 00       	call   8009d2 <cprintf>
  8001a4:	83 c4 10             	add    $0x10,%esp
		sys_run_env(envIdFOSAdd);
  8001a7:	83 ec 0c             	sub    $0xc,%esp
  8001aa:	ff 75 cc             	pushl  -0x34(%ebp)
  8001ad:	e8 4e 1e 00 00       	call   802000 <sys_run_env>
  8001b2:	83 c4 10             	add    $0x10,%esp

		cprintf("please be patient ...\n");
  8001b5:	83 ec 0c             	sub    $0xc,%esp
  8001b8:	68 b9 36 80 00       	push   $0x8036b9
  8001bd:	e8 10 08 00 00       	call   8009d2 <cprintf>
  8001c2:	83 c4 10             	add    $0x10,%esp
		env_sleep(5000);
  8001c5:	83 ec 0c             	sub    $0xc,%esp
  8001c8:	68 88 13 00 00       	push   $0x1388
  8001cd:	e8 26 31 00 00       	call   8032f8 <env_sleep>
  8001d2:	83 c4 10             	add    $0x10,%esp

		//Allocate 2 MB
		ptr_allocations[0] = malloc(2*Mega-kilo);
  8001d5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8001d8:	01 c0                	add    %eax,%eax
  8001da:	2b 45 f0             	sub    -0x10(%ebp),%eax
  8001dd:	83 ec 0c             	sub    $0xc,%esp
  8001e0:	50                   	push   %eax
  8001e1:	e8 7e 17 00 00       	call   801964 <malloc>
  8001e6:	83 c4 10             	add    $0x10,%esp
  8001e9:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%ebp)
		char *byteArr = (char *) ptr_allocations[0];
  8001ef:	8b 85 4c ff ff ff    	mov    -0xb4(%ebp),%eax
  8001f5:	89 45 c8             	mov    %eax,-0x38(%ebp)
		int lastIndexOfByte = (2*Mega-kilo)/sizeof(char) - 1;
  8001f8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8001fb:	01 c0                	add    %eax,%eax
  8001fd:	2b 45 f0             	sub    -0x10(%ebp),%eax
  800200:	48                   	dec    %eax
  800201:	89 45 c4             	mov    %eax,-0x3c(%ebp)
		byteArr[0] = minByte ;
  800204:	8b 45 c8             	mov    -0x38(%ebp),%eax
  800207:	8a 55 ef             	mov    -0x11(%ebp),%dl
  80020a:	88 10                	mov    %dl,(%eax)
		byteArr[lastIndexOfByte] = maxByte ;
  80020c:	8b 55 c4             	mov    -0x3c(%ebp),%edx
  80020f:	8b 45 c8             	mov    -0x38(%ebp),%eax
  800212:	01 c2                	add    %eax,%edx
  800214:	8a 45 ee             	mov    -0x12(%ebp),%al
  800217:	88 02                	mov    %al,(%edx)

		//Allocate another 2 MB
		ptr_allocations[1] = malloc(2*Mega-kilo);
  800219:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80021c:	01 c0                	add    %eax,%eax
  80021e:	2b 45 f0             	sub    -0x10(%ebp),%eax
  800221:	83 ec 0c             	sub    $0xc,%esp
  800224:	50                   	push   %eax
  800225:	e8 3a 17 00 00       	call   801964 <malloc>
  80022a:	83 c4 10             	add    $0x10,%esp
  80022d:	89 85 50 ff ff ff    	mov    %eax,-0xb0(%ebp)
		short *shortArr = (short *) ptr_allocations[1];
  800233:	8b 85 50 ff ff ff    	mov    -0xb0(%ebp),%eax
  800239:	89 45 c0             	mov    %eax,-0x40(%ebp)
		int lastIndexOfShort = (2*Mega-kilo)/sizeof(short) - 1;
  80023c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80023f:	01 c0                	add    %eax,%eax
  800241:	2b 45 f0             	sub    -0x10(%ebp),%eax
  800244:	d1 e8                	shr    %eax
  800246:	48                   	dec    %eax
  800247:	89 45 bc             	mov    %eax,-0x44(%ebp)
		shortArr[0] = minShort;
  80024a:	8b 55 c0             	mov    -0x40(%ebp),%edx
  80024d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800250:	66 89 02             	mov    %ax,(%edx)
		shortArr[lastIndexOfShort] = maxShort;
  800253:	8b 45 bc             	mov    -0x44(%ebp),%eax
  800256:	01 c0                	add    %eax,%eax
  800258:	89 c2                	mov    %eax,%edx
  80025a:	8b 45 c0             	mov    -0x40(%ebp),%eax
  80025d:	01 c2                	add    %eax,%edx
  80025f:	66 8b 45 ea          	mov    -0x16(%ebp),%ax
  800263:	66 89 02             	mov    %ax,(%edx)

		//Allocate all remaining RAM (Here: it requires to free some RAM by removing exited program (fos_add))
		freeFrames = sys_calculate_free_frames() ;
  800266:	e8 05 1b 00 00       	call   801d70 <sys_calculate_free_frames>
  80026b:	89 45 d8             	mov    %eax,-0x28(%ebp)
		ptr_allocations[2] = malloc(freeFrames*PAGE_SIZE);
  80026e:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800271:	c1 e0 0c             	shl    $0xc,%eax
  800274:	83 ec 0c             	sub    $0xc,%esp
  800277:	50                   	push   %eax
  800278:	e8 e7 16 00 00       	call   801964 <malloc>
  80027d:	83 c4 10             	add    $0x10,%esp
  800280:	89 85 54 ff ff ff    	mov    %eax,-0xac(%ebp)
		int *intArr = (int *) ptr_allocations[2];
  800286:	8b 85 54 ff ff ff    	mov    -0xac(%ebp),%eax
  80028c:	89 45 b8             	mov    %eax,-0x48(%ebp)
		int lastIndexOfInt = (freeFrames*PAGE_SIZE)/sizeof(int) - 1;
  80028f:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800292:	c1 e0 0c             	shl    $0xc,%eax
  800295:	c1 e8 02             	shr    $0x2,%eax
  800298:	48                   	dec    %eax
  800299:	89 45 b4             	mov    %eax,-0x4c(%ebp)
		intArr[0] = minInt;
  80029c:	8b 45 b8             	mov    -0x48(%ebp),%eax
  80029f:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8002a2:	89 10                	mov    %edx,(%eax)
		intArr[lastIndexOfInt] = maxInt;
  8002a4:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  8002a7:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8002ae:	8b 45 b8             	mov    -0x48(%ebp),%eax
  8002b1:	01 c2                	add    %eax,%edx
  8002b3:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8002b6:	89 02                	mov    %eax,(%edx)

		//Allocate 7 KB after freeing some RAM
		ptr_allocations[3] = malloc(7*kilo);
  8002b8:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8002bb:	89 d0                	mov    %edx,%eax
  8002bd:	01 c0                	add    %eax,%eax
  8002bf:	01 d0                	add    %edx,%eax
  8002c1:	01 c0                	add    %eax,%eax
  8002c3:	01 d0                	add    %edx,%eax
  8002c5:	83 ec 0c             	sub    $0xc,%esp
  8002c8:	50                   	push   %eax
  8002c9:	e8 96 16 00 00       	call   801964 <malloc>
  8002ce:	83 c4 10             	add    $0x10,%esp
  8002d1:	89 85 58 ff ff ff    	mov    %eax,-0xa8(%ebp)
		struct MyStruct *structArr = (struct MyStruct *) ptr_allocations[3];
  8002d7:	8b 85 58 ff ff ff    	mov    -0xa8(%ebp),%eax
  8002dd:	89 45 b0             	mov    %eax,-0x50(%ebp)
		int lastIndexOfStruct = (7*kilo)/sizeof(struct MyStruct) - 1;
  8002e0:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8002e3:	89 d0                	mov    %edx,%eax
  8002e5:	01 c0                	add    %eax,%eax
  8002e7:	01 d0                	add    %edx,%eax
  8002e9:	01 c0                	add    %eax,%eax
  8002eb:	01 d0                	add    %edx,%eax
  8002ed:	c1 e8 03             	shr    $0x3,%eax
  8002f0:	48                   	dec    %eax
  8002f1:	89 45 ac             	mov    %eax,-0x54(%ebp)
		structArr[0].a = minByte; structArr[0].b = minShort; structArr[0].c = minInt;
  8002f4:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8002f7:	8a 55 ef             	mov    -0x11(%ebp),%dl
  8002fa:	88 10                	mov    %dl,(%eax)
  8002fc:	8b 55 b0             	mov    -0x50(%ebp),%edx
  8002ff:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800302:	66 89 42 02          	mov    %ax,0x2(%edx)
  800306:	8b 45 b0             	mov    -0x50(%ebp),%eax
  800309:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80030c:	89 50 04             	mov    %edx,0x4(%eax)
		structArr[lastIndexOfStruct].a = maxByte; structArr[lastIndexOfStruct].b = maxShort; structArr[lastIndexOfStruct].c = maxInt;
  80030f:	8b 45 ac             	mov    -0x54(%ebp),%eax
  800312:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
  800319:	8b 45 b0             	mov    -0x50(%ebp),%eax
  80031c:	01 c2                	add    %eax,%edx
  80031e:	8a 45 ee             	mov    -0x12(%ebp),%al
  800321:	88 02                	mov    %al,(%edx)
  800323:	8b 45 ac             	mov    -0x54(%ebp),%eax
  800326:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
  80032d:	8b 45 b0             	mov    -0x50(%ebp),%eax
  800330:	01 c2                	add    %eax,%edx
  800332:	66 8b 45 ea          	mov    -0x16(%ebp),%ax
  800336:	66 89 42 02          	mov    %ax,0x2(%edx)
  80033a:	8b 45 ac             	mov    -0x54(%ebp),%eax
  80033d:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
  800344:	8b 45 b0             	mov    -0x50(%ebp),%eax
  800347:	01 c2                	add    %eax,%edx
  800349:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80034c:	89 42 04             	mov    %eax,0x4(%edx)

		cprintf("running fos_helloWorld program...\n\n");
  80034f:	83 ec 0c             	sub    $0xc,%esp
  800352:	68 d0 36 80 00       	push   $0x8036d0
  800357:	e8 76 06 00 00       	call   8009d2 <cprintf>
  80035c:	83 c4 10             	add    $0x10,%esp
		sys_run_env(envIdHelloWorld);
  80035f:	83 ec 0c             	sub    $0xc,%esp
  800362:	ff 75 d4             	pushl  -0x2c(%ebp)
  800365:	e8 96 1c 00 00       	call   802000 <sys_run_env>
  80036a:	83 c4 10             	add    $0x10,%esp

		cprintf("please be patient ...\n");
  80036d:	83 ec 0c             	sub    $0xc,%esp
  800370:	68 b9 36 80 00       	push   $0x8036b9
  800375:	e8 58 06 00 00       	call   8009d2 <cprintf>
  80037a:	83 c4 10             	add    $0x10,%esp
		env_sleep(5000);
  80037d:	83 ec 0c             	sub    $0xc,%esp
  800380:	68 88 13 00 00       	push   $0x1388
  800385:	e8 6e 2f 00 00       	call   8032f8 <env_sleep>
  80038a:	83 c4 10             	add    $0x10,%esp

		//Allocate the remaining RAM + extra RAM by the size of helloWorld program (Here: it requires to free some RAM by removing exited & loaded program(s) (fos_helloWorld & fib))
		freeFrames = sys_calculate_free_frames() ;
  80038d:	e8 de 19 00 00       	call   801d70 <sys_calculate_free_frames>
  800392:	89 45 d8             	mov    %eax,-0x28(%ebp)
		ptr_allocations[4] = malloc((freeFrames + helloWorldFrames)*PAGE_SIZE);
  800395:	8b 55 d8             	mov    -0x28(%ebp),%edx
  800398:	8b 45 d0             	mov    -0x30(%ebp),%eax
  80039b:	01 d0                	add    %edx,%eax
  80039d:	c1 e0 0c             	shl    $0xc,%eax
  8003a0:	83 ec 0c             	sub    $0xc,%esp
  8003a3:	50                   	push   %eax
  8003a4:	e8 bb 15 00 00       	call   801964 <malloc>
  8003a9:	83 c4 10             	add    $0x10,%esp
  8003ac:	89 85 5c ff ff ff    	mov    %eax,-0xa4(%ebp)
		int *intArr2 = (int *) ptr_allocations[4];
  8003b2:	8b 85 5c ff ff ff    	mov    -0xa4(%ebp),%eax
  8003b8:	89 45 a8             	mov    %eax,-0x58(%ebp)
		int lastIndexOfInt2 = ((freeFrames + helloWorldFrames)*PAGE_SIZE)/sizeof(int) - 1;
  8003bb:	8b 55 d8             	mov    -0x28(%ebp),%edx
  8003be:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8003c1:	01 d0                	add    %edx,%eax
  8003c3:	c1 e0 0c             	shl    $0xc,%eax
  8003c6:	c1 e8 02             	shr    $0x2,%eax
  8003c9:	48                   	dec    %eax
  8003ca:	89 45 a4             	mov    %eax,-0x5c(%ebp)
		intArr2[0] = minInt;
  8003cd:	8b 45 a8             	mov    -0x58(%ebp),%eax
  8003d0:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8003d3:	89 10                	mov    %edx,(%eax)
		intArr2[lastIndexOfInt2] = maxInt;
  8003d5:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  8003d8:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8003df:	8b 45 a8             	mov    -0x58(%ebp),%eax
  8003e2:	01 c2                	add    %eax,%edx
  8003e4:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8003e7:	89 02                	mov    %eax,(%edx)

		//Allocate 8 B after freeing the RAM
		ptr_allocations[5] = malloc(8);
  8003e9:	83 ec 0c             	sub    $0xc,%esp
  8003ec:	6a 08                	push   $0x8
  8003ee:	e8 71 15 00 00       	call   801964 <malloc>
  8003f3:	83 c4 10             	add    $0x10,%esp
  8003f6:	89 85 60 ff ff ff    	mov    %eax,-0xa0(%ebp)
		int *intArr3 = (int *) ptr_allocations[5];
  8003fc:	8b 85 60 ff ff ff    	mov    -0xa0(%ebp),%eax
  800402:	89 45 a0             	mov    %eax,-0x60(%ebp)
		int lastIndexOfInt3 = 8/sizeof(int) - 1;
  800405:	c7 45 9c 01 00 00 00 	movl   $0x1,-0x64(%ebp)
		intArr3[0] = minInt;
  80040c:	8b 45 a0             	mov    -0x60(%ebp),%eax
  80040f:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  800412:	89 10                	mov    %edx,(%eax)
		intArr3[lastIndexOfInt3] = maxInt;
  800414:	8b 45 9c             	mov    -0x64(%ebp),%eax
  800417:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80041e:	8b 45 a0             	mov    -0x60(%ebp),%eax
  800421:	01 c2                	add    %eax,%edx
  800423:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800426:	89 02                	mov    %eax,(%edx)

		//Check that the values are successfully stored
		if (byteArr[0] 	!= minByte 	|| byteArr[lastIndexOfByte] 	!= maxByte) panic("Wrong allocation: stored values are wrongly changed!");
  800428:	8b 45 c8             	mov    -0x38(%ebp),%eax
  80042b:	8a 00                	mov    (%eax),%al
  80042d:	3a 45 ef             	cmp    -0x11(%ebp),%al
  800430:	75 0f                	jne    800441 <_main+0x409>
  800432:	8b 55 c4             	mov    -0x3c(%ebp),%edx
  800435:	8b 45 c8             	mov    -0x38(%ebp),%eax
  800438:	01 d0                	add    %edx,%eax
  80043a:	8a 00                	mov    (%eax),%al
  80043c:	3a 45 ee             	cmp    -0x12(%ebp),%al
  80043f:	74 14                	je     800455 <_main+0x41d>
  800441:	83 ec 04             	sub    $0x4,%esp
  800444:	68 f4 36 80 00       	push   $0x8036f4
  800449:	6a 62                	push   $0x62
  80044b:	68 29 37 80 00       	push   $0x803729
  800450:	e8 c9 02 00 00       	call   80071e <_panic>
		if (shortArr[0] != minShort || shortArr[lastIndexOfShort] 	!= maxShort) panic("Wrong allocation: stored values are wrongly changed!");
  800455:	8b 45 c0             	mov    -0x40(%ebp),%eax
  800458:	66 8b 00             	mov    (%eax),%ax
  80045b:	66 3b 45 ec          	cmp    -0x14(%ebp),%ax
  80045f:	75 15                	jne    800476 <_main+0x43e>
  800461:	8b 45 bc             	mov    -0x44(%ebp),%eax
  800464:	01 c0                	add    %eax,%eax
  800466:	89 c2                	mov    %eax,%edx
  800468:	8b 45 c0             	mov    -0x40(%ebp),%eax
  80046b:	01 d0                	add    %edx,%eax
  80046d:	66 8b 00             	mov    (%eax),%ax
  800470:	66 3b 45 ea          	cmp    -0x16(%ebp),%ax
  800474:	74 14                	je     80048a <_main+0x452>
  800476:	83 ec 04             	sub    $0x4,%esp
  800479:	68 f4 36 80 00       	push   $0x8036f4
  80047e:	6a 63                	push   $0x63
  800480:	68 29 37 80 00       	push   $0x803729
  800485:	e8 94 02 00 00       	call   80071e <_panic>
		if (intArr[0] 	!= minInt 	|| intArr[lastIndexOfInt] 		!= maxInt) panic("Wrong allocation: stored values are wrongly changed!");
  80048a:	8b 45 b8             	mov    -0x48(%ebp),%eax
  80048d:	8b 00                	mov    (%eax),%eax
  80048f:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  800492:	75 16                	jne    8004aa <_main+0x472>
  800494:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  800497:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80049e:	8b 45 b8             	mov    -0x48(%ebp),%eax
  8004a1:	01 d0                	add    %edx,%eax
  8004a3:	8b 00                	mov    (%eax),%eax
  8004a5:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  8004a8:	74 14                	je     8004be <_main+0x486>
  8004aa:	83 ec 04             	sub    $0x4,%esp
  8004ad:	68 f4 36 80 00       	push   $0x8036f4
  8004b2:	6a 64                	push   $0x64
  8004b4:	68 29 37 80 00       	push   $0x803729
  8004b9:	e8 60 02 00 00       	call   80071e <_panic>
		if (intArr2[0] 	!= minInt 	|| intArr2[lastIndexOfInt2] 	!= maxInt) panic("Wrong allocation: stored values are wrongly changed!");
  8004be:	8b 45 a8             	mov    -0x58(%ebp),%eax
  8004c1:	8b 00                	mov    (%eax),%eax
  8004c3:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  8004c6:	75 16                	jne    8004de <_main+0x4a6>
  8004c8:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  8004cb:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8004d2:	8b 45 a8             	mov    -0x58(%ebp),%eax
  8004d5:	01 d0                	add    %edx,%eax
  8004d7:	8b 00                	mov    (%eax),%eax
  8004d9:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  8004dc:	74 14                	je     8004f2 <_main+0x4ba>
  8004de:	83 ec 04             	sub    $0x4,%esp
  8004e1:	68 f4 36 80 00       	push   $0x8036f4
  8004e6:	6a 65                	push   $0x65
  8004e8:	68 29 37 80 00       	push   $0x803729
  8004ed:	e8 2c 02 00 00       	call   80071e <_panic>
		if (intArr3[0] 	!= minInt 	|| intArr3[lastIndexOfInt3] 	!= maxInt) panic("Wrong allocation: stored values are wrongly changed!");
  8004f2:	8b 45 a0             	mov    -0x60(%ebp),%eax
  8004f5:	8b 00                	mov    (%eax),%eax
  8004f7:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  8004fa:	75 16                	jne    800512 <_main+0x4da>
  8004fc:	8b 45 9c             	mov    -0x64(%ebp),%eax
  8004ff:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800506:	8b 45 a0             	mov    -0x60(%ebp),%eax
  800509:	01 d0                	add    %edx,%eax
  80050b:	8b 00                	mov    (%eax),%eax
  80050d:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  800510:	74 14                	je     800526 <_main+0x4ee>
  800512:	83 ec 04             	sub    $0x4,%esp
  800515:	68 f4 36 80 00       	push   $0x8036f4
  80051a:	6a 66                	push   $0x66
  80051c:	68 29 37 80 00       	push   $0x803729
  800521:	e8 f8 01 00 00       	call   80071e <_panic>

		if (structArr[0].a != minByte 	|| structArr[lastIndexOfStruct].a != maxByte) 	panic("Wrong allocation: stored values are wrongly changed!");
  800526:	8b 45 b0             	mov    -0x50(%ebp),%eax
  800529:	8a 00                	mov    (%eax),%al
  80052b:	3a 45 ef             	cmp    -0x11(%ebp),%al
  80052e:	75 16                	jne    800546 <_main+0x50e>
  800530:	8b 45 ac             	mov    -0x54(%ebp),%eax
  800533:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
  80053a:	8b 45 b0             	mov    -0x50(%ebp),%eax
  80053d:	01 d0                	add    %edx,%eax
  80053f:	8a 00                	mov    (%eax),%al
  800541:	3a 45 ee             	cmp    -0x12(%ebp),%al
  800544:	74 14                	je     80055a <_main+0x522>
  800546:	83 ec 04             	sub    $0x4,%esp
  800549:	68 f4 36 80 00       	push   $0x8036f4
  80054e:	6a 68                	push   $0x68
  800550:	68 29 37 80 00       	push   $0x803729
  800555:	e8 c4 01 00 00       	call   80071e <_panic>
		if (structArr[0].b != minShort 	|| structArr[lastIndexOfStruct].b != maxShort) 	panic("Wrong allocation: stored values are wrongly changed!");
  80055a:	8b 45 b0             	mov    -0x50(%ebp),%eax
  80055d:	66 8b 40 02          	mov    0x2(%eax),%ax
  800561:	66 3b 45 ec          	cmp    -0x14(%ebp),%ax
  800565:	75 19                	jne    800580 <_main+0x548>
  800567:	8b 45 ac             	mov    -0x54(%ebp),%eax
  80056a:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
  800571:	8b 45 b0             	mov    -0x50(%ebp),%eax
  800574:	01 d0                	add    %edx,%eax
  800576:	66 8b 40 02          	mov    0x2(%eax),%ax
  80057a:	66 3b 45 ea          	cmp    -0x16(%ebp),%ax
  80057e:	74 14                	je     800594 <_main+0x55c>
  800580:	83 ec 04             	sub    $0x4,%esp
  800583:	68 f4 36 80 00       	push   $0x8036f4
  800588:	6a 69                	push   $0x69
  80058a:	68 29 37 80 00       	push   $0x803729
  80058f:	e8 8a 01 00 00       	call   80071e <_panic>
		if (structArr[0].c != minInt 	|| structArr[lastIndexOfStruct].c != maxInt) 	panic("Wrong allocation: stored values are wrongly changed!");
  800594:	8b 45 b0             	mov    -0x50(%ebp),%eax
  800597:	8b 40 04             	mov    0x4(%eax),%eax
  80059a:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  80059d:	75 17                	jne    8005b6 <_main+0x57e>
  80059f:	8b 45 ac             	mov    -0x54(%ebp),%eax
  8005a2:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
  8005a9:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8005ac:	01 d0                	add    %edx,%eax
  8005ae:	8b 40 04             	mov    0x4(%eax),%eax
  8005b1:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  8005b4:	74 14                	je     8005ca <_main+0x592>
  8005b6:	83 ec 04             	sub    $0x4,%esp
  8005b9:	68 f4 36 80 00       	push   $0x8036f4
  8005be:	6a 6a                	push   $0x6a
  8005c0:	68 29 37 80 00       	push   $0x803729
  8005c5:	e8 54 01 00 00       	call   80071e <_panic>


	}

	cprintf("Congratulations!! test freeRAM (1) completed successfully.\n");
  8005ca:	83 ec 0c             	sub    $0xc,%esp
  8005cd:	68 40 37 80 00       	push   $0x803740
  8005d2:	e8 fb 03 00 00       	call   8009d2 <cprintf>
  8005d7:	83 c4 10             	add    $0x10,%esp

	return;
  8005da:	90                   	nop
}
  8005db:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8005de:	5b                   	pop    %ebx
  8005df:	5f                   	pop    %edi
  8005e0:	5d                   	pop    %ebp
  8005e1:	c3                   	ret    

008005e2 <libmain>:
volatile struct Env *myEnv = NULL;
volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";

void
libmain(int argc, char **argv)
{
  8005e2:	55                   	push   %ebp
  8005e3:	89 e5                	mov    %esp,%ebp
  8005e5:	83 ec 18             	sub    $0x18,%esp
	int envIndex = sys_getenvindex();
  8005e8:	e8 63 1a 00 00       	call   802050 <sys_getenvindex>
  8005ed:	89 45 f4             	mov    %eax,-0xc(%ebp)
	myEnv = &(envs[envIndex]);
  8005f0:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8005f3:	89 d0                	mov    %edx,%eax
  8005f5:	c1 e0 03             	shl    $0x3,%eax
  8005f8:	01 d0                	add    %edx,%eax
  8005fa:	01 c0                	add    %eax,%eax
  8005fc:	01 d0                	add    %edx,%eax
  8005fe:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800605:	01 d0                	add    %edx,%eax
  800607:	c1 e0 04             	shl    $0x4,%eax
  80060a:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  80060f:	a3 20 40 80 00       	mov    %eax,0x804020

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  800614:	a1 20 40 80 00       	mov    0x804020,%eax
  800619:	8a 80 5c 05 00 00    	mov    0x55c(%eax),%al
  80061f:	84 c0                	test   %al,%al
  800621:	74 0f                	je     800632 <libmain+0x50>
		binaryname = myEnv->prog_name;
  800623:	a1 20 40 80 00       	mov    0x804020,%eax
  800628:	05 5c 05 00 00       	add    $0x55c,%eax
  80062d:	a3 00 40 80 00       	mov    %eax,0x804000

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  800632:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800636:	7e 0a                	jle    800642 <libmain+0x60>
		binaryname = argv[0];
  800638:	8b 45 0c             	mov    0xc(%ebp),%eax
  80063b:	8b 00                	mov    (%eax),%eax
  80063d:	a3 00 40 80 00       	mov    %eax,0x804000

	// call user main routine
	_main(argc, argv);
  800642:	83 ec 08             	sub    $0x8,%esp
  800645:	ff 75 0c             	pushl  0xc(%ebp)
  800648:	ff 75 08             	pushl  0x8(%ebp)
  80064b:	e8 e8 f9 ff ff       	call   800038 <_main>
  800650:	83 c4 10             	add    $0x10,%esp



	sys_disable_interrupt();
  800653:	e8 05 18 00 00       	call   801e5d <sys_disable_interrupt>
	cprintf("**************************************\n");
  800658:	83 ec 0c             	sub    $0xc,%esp
  80065b:	68 94 37 80 00       	push   $0x803794
  800660:	e8 6d 03 00 00       	call   8009d2 <cprintf>
  800665:	83 c4 10             	add    $0x10,%esp
	cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  800668:	a1 20 40 80 00       	mov    0x804020,%eax
  80066d:	8b 90 44 05 00 00    	mov    0x544(%eax),%edx
  800673:	a1 20 40 80 00       	mov    0x804020,%eax
  800678:	8b 80 34 05 00 00    	mov    0x534(%eax),%eax
  80067e:	83 ec 04             	sub    $0x4,%esp
  800681:	52                   	push   %edx
  800682:	50                   	push   %eax
  800683:	68 bc 37 80 00       	push   $0x8037bc
  800688:	e8 45 03 00 00       	call   8009d2 <cprintf>
  80068d:	83 c4 10             	add    $0x10,%esp
	cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  800690:	a1 20 40 80 00       	mov    0x804020,%eax
  800695:	8b 88 54 05 00 00    	mov    0x554(%eax),%ecx
  80069b:	a1 20 40 80 00       	mov    0x804020,%eax
  8006a0:	8b 90 50 05 00 00    	mov    0x550(%eax),%edx
  8006a6:	a1 20 40 80 00       	mov    0x804020,%eax
  8006ab:	8b 80 4c 05 00 00    	mov    0x54c(%eax),%eax
  8006b1:	51                   	push   %ecx
  8006b2:	52                   	push   %edx
  8006b3:	50                   	push   %eax
  8006b4:	68 e4 37 80 00       	push   $0x8037e4
  8006b9:	e8 14 03 00 00       	call   8009d2 <cprintf>
  8006be:	83 c4 10             	add    $0x10,%esp
	//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
	cprintf("Num of clocks = %d\n", myEnv->nClocks);
  8006c1:	a1 20 40 80 00       	mov    0x804020,%eax
  8006c6:	8b 80 a4 05 00 00    	mov    0x5a4(%eax),%eax
  8006cc:	83 ec 08             	sub    $0x8,%esp
  8006cf:	50                   	push   %eax
  8006d0:	68 3c 38 80 00       	push   $0x80383c
  8006d5:	e8 f8 02 00 00       	call   8009d2 <cprintf>
  8006da:	83 c4 10             	add    $0x10,%esp
	cprintf("**************************************\n");
  8006dd:	83 ec 0c             	sub    $0xc,%esp
  8006e0:	68 94 37 80 00       	push   $0x803794
  8006e5:	e8 e8 02 00 00       	call   8009d2 <cprintf>
  8006ea:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  8006ed:	e8 85 17 00 00       	call   801e77 <sys_enable_interrupt>

	// exit gracefully
	exit();
  8006f2:	e8 19 00 00 00       	call   800710 <exit>
}
  8006f7:	90                   	nop
  8006f8:	c9                   	leave  
  8006f9:	c3                   	ret    

008006fa <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  8006fa:	55                   	push   %ebp
  8006fb:	89 e5                	mov    %esp,%ebp
  8006fd:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  800700:	83 ec 0c             	sub    $0xc,%esp
  800703:	6a 00                	push   $0x0
  800705:	e8 12 19 00 00       	call   80201c <sys_destroy_env>
  80070a:	83 c4 10             	add    $0x10,%esp
}
  80070d:	90                   	nop
  80070e:	c9                   	leave  
  80070f:	c3                   	ret    

00800710 <exit>:

void
exit(void)
{
  800710:	55                   	push   %ebp
  800711:	89 e5                	mov    %esp,%ebp
  800713:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  800716:	e8 67 19 00 00       	call   802082 <sys_exit_env>
}
  80071b:	90                   	nop
  80071c:	c9                   	leave  
  80071d:	c3                   	ret    

0080071e <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  80071e:	55                   	push   %ebp
  80071f:	89 e5                	mov    %esp,%ebp
  800721:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  800724:	8d 45 10             	lea    0x10(%ebp),%eax
  800727:	83 c0 04             	add    $0x4,%eax
  80072a:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  80072d:	a1 5c 41 80 00       	mov    0x80415c,%eax
  800732:	85 c0                	test   %eax,%eax
  800734:	74 16                	je     80074c <_panic+0x2e>
		cprintf("%s: ", argv0);
  800736:	a1 5c 41 80 00       	mov    0x80415c,%eax
  80073b:	83 ec 08             	sub    $0x8,%esp
  80073e:	50                   	push   %eax
  80073f:	68 50 38 80 00       	push   $0x803850
  800744:	e8 89 02 00 00       	call   8009d2 <cprintf>
  800749:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  80074c:	a1 00 40 80 00       	mov    0x804000,%eax
  800751:	ff 75 0c             	pushl  0xc(%ebp)
  800754:	ff 75 08             	pushl  0x8(%ebp)
  800757:	50                   	push   %eax
  800758:	68 55 38 80 00       	push   $0x803855
  80075d:	e8 70 02 00 00       	call   8009d2 <cprintf>
  800762:	83 c4 10             	add    $0x10,%esp
	vcprintf(fmt, ap);
  800765:	8b 45 10             	mov    0x10(%ebp),%eax
  800768:	83 ec 08             	sub    $0x8,%esp
  80076b:	ff 75 f4             	pushl  -0xc(%ebp)
  80076e:	50                   	push   %eax
  80076f:	e8 f3 01 00 00       	call   800967 <vcprintf>
  800774:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  800777:	83 ec 08             	sub    $0x8,%esp
  80077a:	6a 00                	push   $0x0
  80077c:	68 71 38 80 00       	push   $0x803871
  800781:	e8 e1 01 00 00       	call   800967 <vcprintf>
  800786:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  800789:	e8 82 ff ff ff       	call   800710 <exit>

	// should not return here
	while (1) ;
  80078e:	eb fe                	jmp    80078e <_panic+0x70>

00800790 <CheckWSWithoutLastIndex>:
}

void CheckWSWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  800790:	55                   	push   %ebp
  800791:	89 e5                	mov    %esp,%ebp
  800793:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  800796:	a1 20 40 80 00       	mov    0x804020,%eax
  80079b:	8b 50 74             	mov    0x74(%eax),%edx
  80079e:	8b 45 0c             	mov    0xc(%ebp),%eax
  8007a1:	39 c2                	cmp    %eax,%edx
  8007a3:	74 14                	je     8007b9 <CheckWSWithoutLastIndex+0x29>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  8007a5:	83 ec 04             	sub    $0x4,%esp
  8007a8:	68 74 38 80 00       	push   $0x803874
  8007ad:	6a 26                	push   $0x26
  8007af:	68 c0 38 80 00       	push   $0x8038c0
  8007b4:	e8 65 ff ff ff       	call   80071e <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  8007b9:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  8007c0:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  8007c7:	e9 c2 00 00 00       	jmp    80088e <CheckWSWithoutLastIndex+0xfe>
		if (expectedPages[e] == 0) {
  8007cc:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8007cf:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8007d6:	8b 45 08             	mov    0x8(%ebp),%eax
  8007d9:	01 d0                	add    %edx,%eax
  8007db:	8b 00                	mov    (%eax),%eax
  8007dd:	85 c0                	test   %eax,%eax
  8007df:	75 08                	jne    8007e9 <CheckWSWithoutLastIndex+0x59>
			expectedNumOfEmptyLocs++;
  8007e1:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  8007e4:	e9 a2 00 00 00       	jmp    80088b <CheckWSWithoutLastIndex+0xfb>
		}
		int found = 0;
  8007e9:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8007f0:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  8007f7:	eb 69                	jmp    800862 <CheckWSWithoutLastIndex+0xd2>
			if (myEnv->__uptr_pws[w].empty == 0) {
  8007f9:	a1 20 40 80 00       	mov    0x804020,%eax
  8007fe:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  800804:	8b 55 e8             	mov    -0x18(%ebp),%edx
  800807:	89 d0                	mov    %edx,%eax
  800809:	01 c0                	add    %eax,%eax
  80080b:	01 d0                	add    %edx,%eax
  80080d:	c1 e0 03             	shl    $0x3,%eax
  800810:	01 c8                	add    %ecx,%eax
  800812:	8a 40 04             	mov    0x4(%eax),%al
  800815:	84 c0                	test   %al,%al
  800817:	75 46                	jne    80085f <CheckWSWithoutLastIndex+0xcf>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  800819:	a1 20 40 80 00       	mov    0x804020,%eax
  80081e:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  800824:	8b 55 e8             	mov    -0x18(%ebp),%edx
  800827:	89 d0                	mov    %edx,%eax
  800829:	01 c0                	add    %eax,%eax
  80082b:	01 d0                	add    %edx,%eax
  80082d:	c1 e0 03             	shl    $0x3,%eax
  800830:	01 c8                	add    %ecx,%eax
  800832:	8b 00                	mov    (%eax),%eax
  800834:	89 45 dc             	mov    %eax,-0x24(%ebp)
  800837:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80083a:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  80083f:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  800841:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800844:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  80084b:	8b 45 08             	mov    0x8(%ebp),%eax
  80084e:	01 c8                	add    %ecx,%eax
  800850:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  800852:	39 c2                	cmp    %eax,%edx
  800854:	75 09                	jne    80085f <CheckWSWithoutLastIndex+0xcf>
						== expectedPages[e]) {
					found = 1;
  800856:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  80085d:	eb 12                	jmp    800871 <CheckWSWithoutLastIndex+0xe1>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  80085f:	ff 45 e8             	incl   -0x18(%ebp)
  800862:	a1 20 40 80 00       	mov    0x804020,%eax
  800867:	8b 50 74             	mov    0x74(%eax),%edx
  80086a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80086d:	39 c2                	cmp    %eax,%edx
  80086f:	77 88                	ja     8007f9 <CheckWSWithoutLastIndex+0x69>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  800871:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  800875:	75 14                	jne    80088b <CheckWSWithoutLastIndex+0xfb>
			panic(
  800877:	83 ec 04             	sub    $0x4,%esp
  80087a:	68 cc 38 80 00       	push   $0x8038cc
  80087f:	6a 3a                	push   $0x3a
  800881:	68 c0 38 80 00       	push   $0x8038c0
  800886:	e8 93 fe ff ff       	call   80071e <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  80088b:	ff 45 f0             	incl   -0x10(%ebp)
  80088e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800891:	3b 45 0c             	cmp    0xc(%ebp),%eax
  800894:	0f 8c 32 ff ff ff    	jl     8007cc <CheckWSWithoutLastIndex+0x3c>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  80089a:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8008a1:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  8008a8:	eb 26                	jmp    8008d0 <CheckWSWithoutLastIndex+0x140>
		if (myEnv->__uptr_pws[w].empty == 1) {
  8008aa:	a1 20 40 80 00       	mov    0x804020,%eax
  8008af:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  8008b5:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8008b8:	89 d0                	mov    %edx,%eax
  8008ba:	01 c0                	add    %eax,%eax
  8008bc:	01 d0                	add    %edx,%eax
  8008be:	c1 e0 03             	shl    $0x3,%eax
  8008c1:	01 c8                	add    %ecx,%eax
  8008c3:	8a 40 04             	mov    0x4(%eax),%al
  8008c6:	3c 01                	cmp    $0x1,%al
  8008c8:	75 03                	jne    8008cd <CheckWSWithoutLastIndex+0x13d>
			actualNumOfEmptyLocs++;
  8008ca:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8008cd:	ff 45 e0             	incl   -0x20(%ebp)
  8008d0:	a1 20 40 80 00       	mov    0x804020,%eax
  8008d5:	8b 50 74             	mov    0x74(%eax),%edx
  8008d8:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8008db:	39 c2                	cmp    %eax,%edx
  8008dd:	77 cb                	ja     8008aa <CheckWSWithoutLastIndex+0x11a>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  8008df:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8008e2:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  8008e5:	74 14                	je     8008fb <CheckWSWithoutLastIndex+0x16b>
		panic(
  8008e7:	83 ec 04             	sub    $0x4,%esp
  8008ea:	68 20 39 80 00       	push   $0x803920
  8008ef:	6a 44                	push   $0x44
  8008f1:	68 c0 38 80 00       	push   $0x8038c0
  8008f6:	e8 23 fe ff ff       	call   80071e <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  8008fb:	90                   	nop
  8008fc:	c9                   	leave  
  8008fd:	c3                   	ret    

008008fe <putch>:
};

//2017:
uint8 printProgName = 0;

static void putch(int ch, struct printbuf *b) {
  8008fe:	55                   	push   %ebp
  8008ff:	89 e5                	mov    %esp,%ebp
  800901:	83 ec 08             	sub    $0x8,%esp
	b->buf[b->idx++] = ch;
  800904:	8b 45 0c             	mov    0xc(%ebp),%eax
  800907:	8b 00                	mov    (%eax),%eax
  800909:	8d 48 01             	lea    0x1(%eax),%ecx
  80090c:	8b 55 0c             	mov    0xc(%ebp),%edx
  80090f:	89 0a                	mov    %ecx,(%edx)
  800911:	8b 55 08             	mov    0x8(%ebp),%edx
  800914:	88 d1                	mov    %dl,%cl
  800916:	8b 55 0c             	mov    0xc(%ebp),%edx
  800919:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  80091d:	8b 45 0c             	mov    0xc(%ebp),%eax
  800920:	8b 00                	mov    (%eax),%eax
  800922:	3d ff 00 00 00       	cmp    $0xff,%eax
  800927:	75 2c                	jne    800955 <putch+0x57>
		sys_cputs(b->buf, b->idx, printProgName);
  800929:	a0 24 40 80 00       	mov    0x804024,%al
  80092e:	0f b6 c0             	movzbl %al,%eax
  800931:	8b 55 0c             	mov    0xc(%ebp),%edx
  800934:	8b 12                	mov    (%edx),%edx
  800936:	89 d1                	mov    %edx,%ecx
  800938:	8b 55 0c             	mov    0xc(%ebp),%edx
  80093b:	83 c2 08             	add    $0x8,%edx
  80093e:	83 ec 04             	sub    $0x4,%esp
  800941:	50                   	push   %eax
  800942:	51                   	push   %ecx
  800943:	52                   	push   %edx
  800944:	e8 66 13 00 00       	call   801caf <sys_cputs>
  800949:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  80094c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80094f:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  800955:	8b 45 0c             	mov    0xc(%ebp),%eax
  800958:	8b 40 04             	mov    0x4(%eax),%eax
  80095b:	8d 50 01             	lea    0x1(%eax),%edx
  80095e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800961:	89 50 04             	mov    %edx,0x4(%eax)
}
  800964:	90                   	nop
  800965:	c9                   	leave  
  800966:	c3                   	ret    

00800967 <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  800967:	55                   	push   %ebp
  800968:	89 e5                	mov    %esp,%ebp
  80096a:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  800970:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  800977:	00 00 00 
	b.cnt = 0;
  80097a:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  800981:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  800984:	ff 75 0c             	pushl  0xc(%ebp)
  800987:	ff 75 08             	pushl  0x8(%ebp)
  80098a:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800990:	50                   	push   %eax
  800991:	68 fe 08 80 00       	push   $0x8008fe
  800996:	e8 11 02 00 00       	call   800bac <vprintfmt>
  80099b:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName);
  80099e:	a0 24 40 80 00       	mov    0x804024,%al
  8009a3:	0f b6 c0             	movzbl %al,%eax
  8009a6:	8b 95 f0 fe ff ff    	mov    -0x110(%ebp),%edx
  8009ac:	83 ec 04             	sub    $0x4,%esp
  8009af:	50                   	push   %eax
  8009b0:	52                   	push   %edx
  8009b1:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  8009b7:	83 c0 08             	add    $0x8,%eax
  8009ba:	50                   	push   %eax
  8009bb:	e8 ef 12 00 00       	call   801caf <sys_cputs>
  8009c0:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  8009c3:	c6 05 24 40 80 00 00 	movb   $0x0,0x804024
	return b.cnt;
  8009ca:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  8009d0:	c9                   	leave  
  8009d1:	c3                   	ret    

008009d2 <cprintf>:

int cprintf(const char *fmt, ...) {
  8009d2:	55                   	push   %ebp
  8009d3:	89 e5                	mov    %esp,%ebp
  8009d5:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  8009d8:	c6 05 24 40 80 00 01 	movb   $0x1,0x804024
	va_start(ap, fmt);
  8009df:	8d 45 0c             	lea    0xc(%ebp),%eax
  8009e2:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  8009e5:	8b 45 08             	mov    0x8(%ebp),%eax
  8009e8:	83 ec 08             	sub    $0x8,%esp
  8009eb:	ff 75 f4             	pushl  -0xc(%ebp)
  8009ee:	50                   	push   %eax
  8009ef:	e8 73 ff ff ff       	call   800967 <vcprintf>
  8009f4:	83 c4 10             	add    $0x10,%esp
  8009f7:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  8009fa:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8009fd:	c9                   	leave  
  8009fe:	c3                   	ret    

008009ff <atomic_cprintf>:

int atomic_cprintf(const char *fmt, ...) {
  8009ff:	55                   	push   %ebp
  800a00:	89 e5                	mov    %esp,%ebp
  800a02:	83 ec 18             	sub    $0x18,%esp
	sys_disable_interrupt();
  800a05:	e8 53 14 00 00       	call   801e5d <sys_disable_interrupt>
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  800a0a:	8d 45 0c             	lea    0xc(%ebp),%eax
  800a0d:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800a10:	8b 45 08             	mov    0x8(%ebp),%eax
  800a13:	83 ec 08             	sub    $0x8,%esp
  800a16:	ff 75 f4             	pushl  -0xc(%ebp)
  800a19:	50                   	push   %eax
  800a1a:	e8 48 ff ff ff       	call   800967 <vcprintf>
  800a1f:	83 c4 10             	add    $0x10,%esp
  800a22:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	sys_enable_interrupt();
  800a25:	e8 4d 14 00 00       	call   801e77 <sys_enable_interrupt>
	return cnt;
  800a2a:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800a2d:	c9                   	leave  
  800a2e:	c3                   	ret    

00800a2f <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800a2f:	55                   	push   %ebp
  800a30:	89 e5                	mov    %esp,%ebp
  800a32:	53                   	push   %ebx
  800a33:	83 ec 14             	sub    $0x14,%esp
  800a36:	8b 45 10             	mov    0x10(%ebp),%eax
  800a39:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800a3c:	8b 45 14             	mov    0x14(%ebp),%eax
  800a3f:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800a42:	8b 45 18             	mov    0x18(%ebp),%eax
  800a45:	ba 00 00 00 00       	mov    $0x0,%edx
  800a4a:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800a4d:	77 55                	ja     800aa4 <printnum+0x75>
  800a4f:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800a52:	72 05                	jb     800a59 <printnum+0x2a>
  800a54:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  800a57:	77 4b                	ja     800aa4 <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800a59:	8b 45 1c             	mov    0x1c(%ebp),%eax
  800a5c:	8d 58 ff             	lea    -0x1(%eax),%ebx
  800a5f:	8b 45 18             	mov    0x18(%ebp),%eax
  800a62:	ba 00 00 00 00       	mov    $0x0,%edx
  800a67:	52                   	push   %edx
  800a68:	50                   	push   %eax
  800a69:	ff 75 f4             	pushl  -0xc(%ebp)
  800a6c:	ff 75 f0             	pushl  -0x10(%ebp)
  800a6f:	e8 38 29 00 00       	call   8033ac <__udivdi3>
  800a74:	83 c4 10             	add    $0x10,%esp
  800a77:	83 ec 04             	sub    $0x4,%esp
  800a7a:	ff 75 20             	pushl  0x20(%ebp)
  800a7d:	53                   	push   %ebx
  800a7e:	ff 75 18             	pushl  0x18(%ebp)
  800a81:	52                   	push   %edx
  800a82:	50                   	push   %eax
  800a83:	ff 75 0c             	pushl  0xc(%ebp)
  800a86:	ff 75 08             	pushl  0x8(%ebp)
  800a89:	e8 a1 ff ff ff       	call   800a2f <printnum>
  800a8e:	83 c4 20             	add    $0x20,%esp
  800a91:	eb 1a                	jmp    800aad <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  800a93:	83 ec 08             	sub    $0x8,%esp
  800a96:	ff 75 0c             	pushl  0xc(%ebp)
  800a99:	ff 75 20             	pushl  0x20(%ebp)
  800a9c:	8b 45 08             	mov    0x8(%ebp),%eax
  800a9f:	ff d0                	call   *%eax
  800aa1:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800aa4:	ff 4d 1c             	decl   0x1c(%ebp)
  800aa7:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  800aab:	7f e6                	jg     800a93 <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800aad:	8b 4d 18             	mov    0x18(%ebp),%ecx
  800ab0:	bb 00 00 00 00       	mov    $0x0,%ebx
  800ab5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800ab8:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800abb:	53                   	push   %ebx
  800abc:	51                   	push   %ecx
  800abd:	52                   	push   %edx
  800abe:	50                   	push   %eax
  800abf:	e8 f8 29 00 00       	call   8034bc <__umoddi3>
  800ac4:	83 c4 10             	add    $0x10,%esp
  800ac7:	05 94 3b 80 00       	add    $0x803b94,%eax
  800acc:	8a 00                	mov    (%eax),%al
  800ace:	0f be c0             	movsbl %al,%eax
  800ad1:	83 ec 08             	sub    $0x8,%esp
  800ad4:	ff 75 0c             	pushl  0xc(%ebp)
  800ad7:	50                   	push   %eax
  800ad8:	8b 45 08             	mov    0x8(%ebp),%eax
  800adb:	ff d0                	call   *%eax
  800add:	83 c4 10             	add    $0x10,%esp
}
  800ae0:	90                   	nop
  800ae1:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800ae4:	c9                   	leave  
  800ae5:	c3                   	ret    

00800ae6 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  800ae6:	55                   	push   %ebp
  800ae7:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800ae9:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800aed:	7e 1c                	jle    800b0b <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  800aef:	8b 45 08             	mov    0x8(%ebp),%eax
  800af2:	8b 00                	mov    (%eax),%eax
  800af4:	8d 50 08             	lea    0x8(%eax),%edx
  800af7:	8b 45 08             	mov    0x8(%ebp),%eax
  800afa:	89 10                	mov    %edx,(%eax)
  800afc:	8b 45 08             	mov    0x8(%ebp),%eax
  800aff:	8b 00                	mov    (%eax),%eax
  800b01:	83 e8 08             	sub    $0x8,%eax
  800b04:	8b 50 04             	mov    0x4(%eax),%edx
  800b07:	8b 00                	mov    (%eax),%eax
  800b09:	eb 40                	jmp    800b4b <getuint+0x65>
	else if (lflag)
  800b0b:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800b0f:	74 1e                	je     800b2f <getuint+0x49>
		return va_arg(*ap, unsigned long);
  800b11:	8b 45 08             	mov    0x8(%ebp),%eax
  800b14:	8b 00                	mov    (%eax),%eax
  800b16:	8d 50 04             	lea    0x4(%eax),%edx
  800b19:	8b 45 08             	mov    0x8(%ebp),%eax
  800b1c:	89 10                	mov    %edx,(%eax)
  800b1e:	8b 45 08             	mov    0x8(%ebp),%eax
  800b21:	8b 00                	mov    (%eax),%eax
  800b23:	83 e8 04             	sub    $0x4,%eax
  800b26:	8b 00                	mov    (%eax),%eax
  800b28:	ba 00 00 00 00       	mov    $0x0,%edx
  800b2d:	eb 1c                	jmp    800b4b <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  800b2f:	8b 45 08             	mov    0x8(%ebp),%eax
  800b32:	8b 00                	mov    (%eax),%eax
  800b34:	8d 50 04             	lea    0x4(%eax),%edx
  800b37:	8b 45 08             	mov    0x8(%ebp),%eax
  800b3a:	89 10                	mov    %edx,(%eax)
  800b3c:	8b 45 08             	mov    0x8(%ebp),%eax
  800b3f:	8b 00                	mov    (%eax),%eax
  800b41:	83 e8 04             	sub    $0x4,%eax
  800b44:	8b 00                	mov    (%eax),%eax
  800b46:	ba 00 00 00 00       	mov    $0x0,%edx
}
  800b4b:	5d                   	pop    %ebp
  800b4c:	c3                   	ret    

00800b4d <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  800b4d:	55                   	push   %ebp
  800b4e:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800b50:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800b54:	7e 1c                	jle    800b72 <getint+0x25>
		return va_arg(*ap, long long);
  800b56:	8b 45 08             	mov    0x8(%ebp),%eax
  800b59:	8b 00                	mov    (%eax),%eax
  800b5b:	8d 50 08             	lea    0x8(%eax),%edx
  800b5e:	8b 45 08             	mov    0x8(%ebp),%eax
  800b61:	89 10                	mov    %edx,(%eax)
  800b63:	8b 45 08             	mov    0x8(%ebp),%eax
  800b66:	8b 00                	mov    (%eax),%eax
  800b68:	83 e8 08             	sub    $0x8,%eax
  800b6b:	8b 50 04             	mov    0x4(%eax),%edx
  800b6e:	8b 00                	mov    (%eax),%eax
  800b70:	eb 38                	jmp    800baa <getint+0x5d>
	else if (lflag)
  800b72:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800b76:	74 1a                	je     800b92 <getint+0x45>
		return va_arg(*ap, long);
  800b78:	8b 45 08             	mov    0x8(%ebp),%eax
  800b7b:	8b 00                	mov    (%eax),%eax
  800b7d:	8d 50 04             	lea    0x4(%eax),%edx
  800b80:	8b 45 08             	mov    0x8(%ebp),%eax
  800b83:	89 10                	mov    %edx,(%eax)
  800b85:	8b 45 08             	mov    0x8(%ebp),%eax
  800b88:	8b 00                	mov    (%eax),%eax
  800b8a:	83 e8 04             	sub    $0x4,%eax
  800b8d:	8b 00                	mov    (%eax),%eax
  800b8f:	99                   	cltd   
  800b90:	eb 18                	jmp    800baa <getint+0x5d>
	else
		return va_arg(*ap, int);
  800b92:	8b 45 08             	mov    0x8(%ebp),%eax
  800b95:	8b 00                	mov    (%eax),%eax
  800b97:	8d 50 04             	lea    0x4(%eax),%edx
  800b9a:	8b 45 08             	mov    0x8(%ebp),%eax
  800b9d:	89 10                	mov    %edx,(%eax)
  800b9f:	8b 45 08             	mov    0x8(%ebp),%eax
  800ba2:	8b 00                	mov    (%eax),%eax
  800ba4:	83 e8 04             	sub    $0x4,%eax
  800ba7:	8b 00                	mov    (%eax),%eax
  800ba9:	99                   	cltd   
}
  800baa:	5d                   	pop    %ebp
  800bab:	c3                   	ret    

00800bac <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  800bac:	55                   	push   %ebp
  800bad:	89 e5                	mov    %esp,%ebp
  800baf:	56                   	push   %esi
  800bb0:	53                   	push   %ebx
  800bb1:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800bb4:	eb 17                	jmp    800bcd <vprintfmt+0x21>
			if (ch == '\0')
  800bb6:	85 db                	test   %ebx,%ebx
  800bb8:	0f 84 af 03 00 00    	je     800f6d <vprintfmt+0x3c1>
				return;
			putch(ch, putdat);
  800bbe:	83 ec 08             	sub    $0x8,%esp
  800bc1:	ff 75 0c             	pushl  0xc(%ebp)
  800bc4:	53                   	push   %ebx
  800bc5:	8b 45 08             	mov    0x8(%ebp),%eax
  800bc8:	ff d0                	call   *%eax
  800bca:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800bcd:	8b 45 10             	mov    0x10(%ebp),%eax
  800bd0:	8d 50 01             	lea    0x1(%eax),%edx
  800bd3:	89 55 10             	mov    %edx,0x10(%ebp)
  800bd6:	8a 00                	mov    (%eax),%al
  800bd8:	0f b6 d8             	movzbl %al,%ebx
  800bdb:	83 fb 25             	cmp    $0x25,%ebx
  800bde:	75 d6                	jne    800bb6 <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  800be0:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  800be4:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  800beb:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  800bf2:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  800bf9:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800c00:	8b 45 10             	mov    0x10(%ebp),%eax
  800c03:	8d 50 01             	lea    0x1(%eax),%edx
  800c06:	89 55 10             	mov    %edx,0x10(%ebp)
  800c09:	8a 00                	mov    (%eax),%al
  800c0b:	0f b6 d8             	movzbl %al,%ebx
  800c0e:	8d 43 dd             	lea    -0x23(%ebx),%eax
  800c11:	83 f8 55             	cmp    $0x55,%eax
  800c14:	0f 87 2b 03 00 00    	ja     800f45 <vprintfmt+0x399>
  800c1a:	8b 04 85 b8 3b 80 00 	mov    0x803bb8(,%eax,4),%eax
  800c21:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  800c23:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  800c27:	eb d7                	jmp    800c00 <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  800c29:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  800c2d:	eb d1                	jmp    800c00 <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800c2f:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  800c36:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800c39:	89 d0                	mov    %edx,%eax
  800c3b:	c1 e0 02             	shl    $0x2,%eax
  800c3e:	01 d0                	add    %edx,%eax
  800c40:	01 c0                	add    %eax,%eax
  800c42:	01 d8                	add    %ebx,%eax
  800c44:	83 e8 30             	sub    $0x30,%eax
  800c47:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  800c4a:	8b 45 10             	mov    0x10(%ebp),%eax
  800c4d:	8a 00                	mov    (%eax),%al
  800c4f:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  800c52:	83 fb 2f             	cmp    $0x2f,%ebx
  800c55:	7e 3e                	jle    800c95 <vprintfmt+0xe9>
  800c57:	83 fb 39             	cmp    $0x39,%ebx
  800c5a:	7f 39                	jg     800c95 <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800c5c:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  800c5f:	eb d5                	jmp    800c36 <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  800c61:	8b 45 14             	mov    0x14(%ebp),%eax
  800c64:	83 c0 04             	add    $0x4,%eax
  800c67:	89 45 14             	mov    %eax,0x14(%ebp)
  800c6a:	8b 45 14             	mov    0x14(%ebp),%eax
  800c6d:	83 e8 04             	sub    $0x4,%eax
  800c70:	8b 00                	mov    (%eax),%eax
  800c72:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  800c75:	eb 1f                	jmp    800c96 <vprintfmt+0xea>

		case '.':
			if (width < 0)
  800c77:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800c7b:	79 83                	jns    800c00 <vprintfmt+0x54>
				width = 0;
  800c7d:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  800c84:	e9 77 ff ff ff       	jmp    800c00 <vprintfmt+0x54>

		case '#':
			altflag = 1;
  800c89:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  800c90:	e9 6b ff ff ff       	jmp    800c00 <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  800c95:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  800c96:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800c9a:	0f 89 60 ff ff ff    	jns    800c00 <vprintfmt+0x54>
				width = precision, precision = -1;
  800ca0:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800ca3:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800ca6:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  800cad:	e9 4e ff ff ff       	jmp    800c00 <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  800cb2:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  800cb5:	e9 46 ff ff ff       	jmp    800c00 <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  800cba:	8b 45 14             	mov    0x14(%ebp),%eax
  800cbd:	83 c0 04             	add    $0x4,%eax
  800cc0:	89 45 14             	mov    %eax,0x14(%ebp)
  800cc3:	8b 45 14             	mov    0x14(%ebp),%eax
  800cc6:	83 e8 04             	sub    $0x4,%eax
  800cc9:	8b 00                	mov    (%eax),%eax
  800ccb:	83 ec 08             	sub    $0x8,%esp
  800cce:	ff 75 0c             	pushl  0xc(%ebp)
  800cd1:	50                   	push   %eax
  800cd2:	8b 45 08             	mov    0x8(%ebp),%eax
  800cd5:	ff d0                	call   *%eax
  800cd7:	83 c4 10             	add    $0x10,%esp
			break;
  800cda:	e9 89 02 00 00       	jmp    800f68 <vprintfmt+0x3bc>

		// error message
		case 'e':
			err = va_arg(ap, int);
  800cdf:	8b 45 14             	mov    0x14(%ebp),%eax
  800ce2:	83 c0 04             	add    $0x4,%eax
  800ce5:	89 45 14             	mov    %eax,0x14(%ebp)
  800ce8:	8b 45 14             	mov    0x14(%ebp),%eax
  800ceb:	83 e8 04             	sub    $0x4,%eax
  800cee:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  800cf0:	85 db                	test   %ebx,%ebx
  800cf2:	79 02                	jns    800cf6 <vprintfmt+0x14a>
				err = -err;
  800cf4:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  800cf6:	83 fb 64             	cmp    $0x64,%ebx
  800cf9:	7f 0b                	jg     800d06 <vprintfmt+0x15a>
  800cfb:	8b 34 9d 00 3a 80 00 	mov    0x803a00(,%ebx,4),%esi
  800d02:	85 f6                	test   %esi,%esi
  800d04:	75 19                	jne    800d1f <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  800d06:	53                   	push   %ebx
  800d07:	68 a5 3b 80 00       	push   $0x803ba5
  800d0c:	ff 75 0c             	pushl  0xc(%ebp)
  800d0f:	ff 75 08             	pushl  0x8(%ebp)
  800d12:	e8 5e 02 00 00       	call   800f75 <printfmt>
  800d17:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  800d1a:	e9 49 02 00 00       	jmp    800f68 <vprintfmt+0x3bc>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  800d1f:	56                   	push   %esi
  800d20:	68 ae 3b 80 00       	push   $0x803bae
  800d25:	ff 75 0c             	pushl  0xc(%ebp)
  800d28:	ff 75 08             	pushl  0x8(%ebp)
  800d2b:	e8 45 02 00 00       	call   800f75 <printfmt>
  800d30:	83 c4 10             	add    $0x10,%esp
			break;
  800d33:	e9 30 02 00 00       	jmp    800f68 <vprintfmt+0x3bc>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  800d38:	8b 45 14             	mov    0x14(%ebp),%eax
  800d3b:	83 c0 04             	add    $0x4,%eax
  800d3e:	89 45 14             	mov    %eax,0x14(%ebp)
  800d41:	8b 45 14             	mov    0x14(%ebp),%eax
  800d44:	83 e8 04             	sub    $0x4,%eax
  800d47:	8b 30                	mov    (%eax),%esi
  800d49:	85 f6                	test   %esi,%esi
  800d4b:	75 05                	jne    800d52 <vprintfmt+0x1a6>
				p = "(null)";
  800d4d:	be b1 3b 80 00       	mov    $0x803bb1,%esi
			if (width > 0 && padc != '-')
  800d52:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800d56:	7e 6d                	jle    800dc5 <vprintfmt+0x219>
  800d58:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  800d5c:	74 67                	je     800dc5 <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  800d5e:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800d61:	83 ec 08             	sub    $0x8,%esp
  800d64:	50                   	push   %eax
  800d65:	56                   	push   %esi
  800d66:	e8 0c 03 00 00       	call   801077 <strnlen>
  800d6b:	83 c4 10             	add    $0x10,%esp
  800d6e:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  800d71:	eb 16                	jmp    800d89 <vprintfmt+0x1dd>
					putch(padc, putdat);
  800d73:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  800d77:	83 ec 08             	sub    $0x8,%esp
  800d7a:	ff 75 0c             	pushl  0xc(%ebp)
  800d7d:	50                   	push   %eax
  800d7e:	8b 45 08             	mov    0x8(%ebp),%eax
  800d81:	ff d0                	call   *%eax
  800d83:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800d86:	ff 4d e4             	decl   -0x1c(%ebp)
  800d89:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800d8d:	7f e4                	jg     800d73 <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800d8f:	eb 34                	jmp    800dc5 <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  800d91:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  800d95:	74 1c                	je     800db3 <vprintfmt+0x207>
  800d97:	83 fb 1f             	cmp    $0x1f,%ebx
  800d9a:	7e 05                	jle    800da1 <vprintfmt+0x1f5>
  800d9c:	83 fb 7e             	cmp    $0x7e,%ebx
  800d9f:	7e 12                	jle    800db3 <vprintfmt+0x207>
					putch('?', putdat);
  800da1:	83 ec 08             	sub    $0x8,%esp
  800da4:	ff 75 0c             	pushl  0xc(%ebp)
  800da7:	6a 3f                	push   $0x3f
  800da9:	8b 45 08             	mov    0x8(%ebp),%eax
  800dac:	ff d0                	call   *%eax
  800dae:	83 c4 10             	add    $0x10,%esp
  800db1:	eb 0f                	jmp    800dc2 <vprintfmt+0x216>
				else
					putch(ch, putdat);
  800db3:	83 ec 08             	sub    $0x8,%esp
  800db6:	ff 75 0c             	pushl  0xc(%ebp)
  800db9:	53                   	push   %ebx
  800dba:	8b 45 08             	mov    0x8(%ebp),%eax
  800dbd:	ff d0                	call   *%eax
  800dbf:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800dc2:	ff 4d e4             	decl   -0x1c(%ebp)
  800dc5:	89 f0                	mov    %esi,%eax
  800dc7:	8d 70 01             	lea    0x1(%eax),%esi
  800dca:	8a 00                	mov    (%eax),%al
  800dcc:	0f be d8             	movsbl %al,%ebx
  800dcf:	85 db                	test   %ebx,%ebx
  800dd1:	74 24                	je     800df7 <vprintfmt+0x24b>
  800dd3:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800dd7:	78 b8                	js     800d91 <vprintfmt+0x1e5>
  800dd9:	ff 4d e0             	decl   -0x20(%ebp)
  800ddc:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800de0:	79 af                	jns    800d91 <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800de2:	eb 13                	jmp    800df7 <vprintfmt+0x24b>
				putch(' ', putdat);
  800de4:	83 ec 08             	sub    $0x8,%esp
  800de7:	ff 75 0c             	pushl  0xc(%ebp)
  800dea:	6a 20                	push   $0x20
  800dec:	8b 45 08             	mov    0x8(%ebp),%eax
  800def:	ff d0                	call   *%eax
  800df1:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800df4:	ff 4d e4             	decl   -0x1c(%ebp)
  800df7:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800dfb:	7f e7                	jg     800de4 <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  800dfd:	e9 66 01 00 00       	jmp    800f68 <vprintfmt+0x3bc>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  800e02:	83 ec 08             	sub    $0x8,%esp
  800e05:	ff 75 e8             	pushl  -0x18(%ebp)
  800e08:	8d 45 14             	lea    0x14(%ebp),%eax
  800e0b:	50                   	push   %eax
  800e0c:	e8 3c fd ff ff       	call   800b4d <getint>
  800e11:	83 c4 10             	add    $0x10,%esp
  800e14:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800e17:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  800e1a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800e1d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800e20:	85 d2                	test   %edx,%edx
  800e22:	79 23                	jns    800e47 <vprintfmt+0x29b>
				putch('-', putdat);
  800e24:	83 ec 08             	sub    $0x8,%esp
  800e27:	ff 75 0c             	pushl  0xc(%ebp)
  800e2a:	6a 2d                	push   $0x2d
  800e2c:	8b 45 08             	mov    0x8(%ebp),%eax
  800e2f:	ff d0                	call   *%eax
  800e31:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  800e34:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800e37:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800e3a:	f7 d8                	neg    %eax
  800e3c:	83 d2 00             	adc    $0x0,%edx
  800e3f:	f7 da                	neg    %edx
  800e41:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800e44:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  800e47:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800e4e:	e9 bc 00 00 00       	jmp    800f0f <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  800e53:	83 ec 08             	sub    $0x8,%esp
  800e56:	ff 75 e8             	pushl  -0x18(%ebp)
  800e59:	8d 45 14             	lea    0x14(%ebp),%eax
  800e5c:	50                   	push   %eax
  800e5d:	e8 84 fc ff ff       	call   800ae6 <getuint>
  800e62:	83 c4 10             	add    $0x10,%esp
  800e65:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800e68:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  800e6b:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800e72:	e9 98 00 00 00       	jmp    800f0f <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  800e77:	83 ec 08             	sub    $0x8,%esp
  800e7a:	ff 75 0c             	pushl  0xc(%ebp)
  800e7d:	6a 58                	push   $0x58
  800e7f:	8b 45 08             	mov    0x8(%ebp),%eax
  800e82:	ff d0                	call   *%eax
  800e84:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800e87:	83 ec 08             	sub    $0x8,%esp
  800e8a:	ff 75 0c             	pushl  0xc(%ebp)
  800e8d:	6a 58                	push   $0x58
  800e8f:	8b 45 08             	mov    0x8(%ebp),%eax
  800e92:	ff d0                	call   *%eax
  800e94:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800e97:	83 ec 08             	sub    $0x8,%esp
  800e9a:	ff 75 0c             	pushl  0xc(%ebp)
  800e9d:	6a 58                	push   $0x58
  800e9f:	8b 45 08             	mov    0x8(%ebp),%eax
  800ea2:	ff d0                	call   *%eax
  800ea4:	83 c4 10             	add    $0x10,%esp
			break;
  800ea7:	e9 bc 00 00 00       	jmp    800f68 <vprintfmt+0x3bc>

		// pointer
		case 'p':
			putch('0', putdat);
  800eac:	83 ec 08             	sub    $0x8,%esp
  800eaf:	ff 75 0c             	pushl  0xc(%ebp)
  800eb2:	6a 30                	push   $0x30
  800eb4:	8b 45 08             	mov    0x8(%ebp),%eax
  800eb7:	ff d0                	call   *%eax
  800eb9:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  800ebc:	83 ec 08             	sub    $0x8,%esp
  800ebf:	ff 75 0c             	pushl  0xc(%ebp)
  800ec2:	6a 78                	push   $0x78
  800ec4:	8b 45 08             	mov    0x8(%ebp),%eax
  800ec7:	ff d0                	call   *%eax
  800ec9:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  800ecc:	8b 45 14             	mov    0x14(%ebp),%eax
  800ecf:	83 c0 04             	add    $0x4,%eax
  800ed2:	89 45 14             	mov    %eax,0x14(%ebp)
  800ed5:	8b 45 14             	mov    0x14(%ebp),%eax
  800ed8:	83 e8 04             	sub    $0x4,%eax
  800edb:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800edd:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800ee0:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  800ee7:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  800eee:	eb 1f                	jmp    800f0f <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  800ef0:	83 ec 08             	sub    $0x8,%esp
  800ef3:	ff 75 e8             	pushl  -0x18(%ebp)
  800ef6:	8d 45 14             	lea    0x14(%ebp),%eax
  800ef9:	50                   	push   %eax
  800efa:	e8 e7 fb ff ff       	call   800ae6 <getuint>
  800eff:	83 c4 10             	add    $0x10,%esp
  800f02:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800f05:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  800f08:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800f0f:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  800f13:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800f16:	83 ec 04             	sub    $0x4,%esp
  800f19:	52                   	push   %edx
  800f1a:	ff 75 e4             	pushl  -0x1c(%ebp)
  800f1d:	50                   	push   %eax
  800f1e:	ff 75 f4             	pushl  -0xc(%ebp)
  800f21:	ff 75 f0             	pushl  -0x10(%ebp)
  800f24:	ff 75 0c             	pushl  0xc(%ebp)
  800f27:	ff 75 08             	pushl  0x8(%ebp)
  800f2a:	e8 00 fb ff ff       	call   800a2f <printnum>
  800f2f:	83 c4 20             	add    $0x20,%esp
			break;
  800f32:	eb 34                	jmp    800f68 <vprintfmt+0x3bc>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  800f34:	83 ec 08             	sub    $0x8,%esp
  800f37:	ff 75 0c             	pushl  0xc(%ebp)
  800f3a:	53                   	push   %ebx
  800f3b:	8b 45 08             	mov    0x8(%ebp),%eax
  800f3e:	ff d0                	call   *%eax
  800f40:	83 c4 10             	add    $0x10,%esp
			break;
  800f43:	eb 23                	jmp    800f68 <vprintfmt+0x3bc>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800f45:	83 ec 08             	sub    $0x8,%esp
  800f48:	ff 75 0c             	pushl  0xc(%ebp)
  800f4b:	6a 25                	push   $0x25
  800f4d:	8b 45 08             	mov    0x8(%ebp),%eax
  800f50:	ff d0                	call   *%eax
  800f52:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  800f55:	ff 4d 10             	decl   0x10(%ebp)
  800f58:	eb 03                	jmp    800f5d <vprintfmt+0x3b1>
  800f5a:	ff 4d 10             	decl   0x10(%ebp)
  800f5d:	8b 45 10             	mov    0x10(%ebp),%eax
  800f60:	48                   	dec    %eax
  800f61:	8a 00                	mov    (%eax),%al
  800f63:	3c 25                	cmp    $0x25,%al
  800f65:	75 f3                	jne    800f5a <vprintfmt+0x3ae>
				/* do nothing */;
			break;
  800f67:	90                   	nop
		}
	}
  800f68:	e9 47 fc ff ff       	jmp    800bb4 <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  800f6d:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  800f6e:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800f71:	5b                   	pop    %ebx
  800f72:	5e                   	pop    %esi
  800f73:	5d                   	pop    %ebp
  800f74:	c3                   	ret    

00800f75 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800f75:	55                   	push   %ebp
  800f76:	89 e5                	mov    %esp,%ebp
  800f78:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  800f7b:	8d 45 10             	lea    0x10(%ebp),%eax
  800f7e:	83 c0 04             	add    $0x4,%eax
  800f81:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  800f84:	8b 45 10             	mov    0x10(%ebp),%eax
  800f87:	ff 75 f4             	pushl  -0xc(%ebp)
  800f8a:	50                   	push   %eax
  800f8b:	ff 75 0c             	pushl  0xc(%ebp)
  800f8e:	ff 75 08             	pushl  0x8(%ebp)
  800f91:	e8 16 fc ff ff       	call   800bac <vprintfmt>
  800f96:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  800f99:	90                   	nop
  800f9a:	c9                   	leave  
  800f9b:	c3                   	ret    

00800f9c <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800f9c:	55                   	push   %ebp
  800f9d:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  800f9f:	8b 45 0c             	mov    0xc(%ebp),%eax
  800fa2:	8b 40 08             	mov    0x8(%eax),%eax
  800fa5:	8d 50 01             	lea    0x1(%eax),%edx
  800fa8:	8b 45 0c             	mov    0xc(%ebp),%eax
  800fab:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  800fae:	8b 45 0c             	mov    0xc(%ebp),%eax
  800fb1:	8b 10                	mov    (%eax),%edx
  800fb3:	8b 45 0c             	mov    0xc(%ebp),%eax
  800fb6:	8b 40 04             	mov    0x4(%eax),%eax
  800fb9:	39 c2                	cmp    %eax,%edx
  800fbb:	73 12                	jae    800fcf <sprintputch+0x33>
		*b->buf++ = ch;
  800fbd:	8b 45 0c             	mov    0xc(%ebp),%eax
  800fc0:	8b 00                	mov    (%eax),%eax
  800fc2:	8d 48 01             	lea    0x1(%eax),%ecx
  800fc5:	8b 55 0c             	mov    0xc(%ebp),%edx
  800fc8:	89 0a                	mov    %ecx,(%edx)
  800fca:	8b 55 08             	mov    0x8(%ebp),%edx
  800fcd:	88 10                	mov    %dl,(%eax)
}
  800fcf:	90                   	nop
  800fd0:	5d                   	pop    %ebp
  800fd1:	c3                   	ret    

00800fd2 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800fd2:	55                   	push   %ebp
  800fd3:	89 e5                	mov    %esp,%ebp
  800fd5:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  800fd8:	8b 45 08             	mov    0x8(%ebp),%eax
  800fdb:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800fde:	8b 45 0c             	mov    0xc(%ebp),%eax
  800fe1:	8d 50 ff             	lea    -0x1(%eax),%edx
  800fe4:	8b 45 08             	mov    0x8(%ebp),%eax
  800fe7:	01 d0                	add    %edx,%eax
  800fe9:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800fec:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800ff3:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800ff7:	74 06                	je     800fff <vsnprintf+0x2d>
  800ff9:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800ffd:	7f 07                	jg     801006 <vsnprintf+0x34>
		return -E_INVAL;
  800fff:	b8 03 00 00 00       	mov    $0x3,%eax
  801004:	eb 20                	jmp    801026 <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  801006:	ff 75 14             	pushl  0x14(%ebp)
  801009:	ff 75 10             	pushl  0x10(%ebp)
  80100c:	8d 45 ec             	lea    -0x14(%ebp),%eax
  80100f:	50                   	push   %eax
  801010:	68 9c 0f 80 00       	push   $0x800f9c
  801015:	e8 92 fb ff ff       	call   800bac <vprintfmt>
  80101a:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  80101d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801020:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  801023:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  801026:	c9                   	leave  
  801027:	c3                   	ret    

00801028 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  801028:	55                   	push   %ebp
  801029:	89 e5                	mov    %esp,%ebp
  80102b:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  80102e:	8d 45 10             	lea    0x10(%ebp),%eax
  801031:	83 c0 04             	add    $0x4,%eax
  801034:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  801037:	8b 45 10             	mov    0x10(%ebp),%eax
  80103a:	ff 75 f4             	pushl  -0xc(%ebp)
  80103d:	50                   	push   %eax
  80103e:	ff 75 0c             	pushl  0xc(%ebp)
  801041:	ff 75 08             	pushl  0x8(%ebp)
  801044:	e8 89 ff ff ff       	call   800fd2 <vsnprintf>
  801049:	83 c4 10             	add    $0x10,%esp
  80104c:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  80104f:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801052:	c9                   	leave  
  801053:	c3                   	ret    

00801054 <strlen>:

#include <inc/string.h>

int
strlen(const char *s)
{
  801054:	55                   	push   %ebp
  801055:	89 e5                	mov    %esp,%ebp
  801057:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  80105a:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801061:	eb 06                	jmp    801069 <strlen+0x15>
		n++;
  801063:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  801066:	ff 45 08             	incl   0x8(%ebp)
  801069:	8b 45 08             	mov    0x8(%ebp),%eax
  80106c:	8a 00                	mov    (%eax),%al
  80106e:	84 c0                	test   %al,%al
  801070:	75 f1                	jne    801063 <strlen+0xf>
		n++;
	return n;
  801072:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  801075:	c9                   	leave  
  801076:	c3                   	ret    

00801077 <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  801077:	55                   	push   %ebp
  801078:	89 e5                	mov    %esp,%ebp
  80107a:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  80107d:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801084:	eb 09                	jmp    80108f <strnlen+0x18>
		n++;
  801086:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  801089:	ff 45 08             	incl   0x8(%ebp)
  80108c:	ff 4d 0c             	decl   0xc(%ebp)
  80108f:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801093:	74 09                	je     80109e <strnlen+0x27>
  801095:	8b 45 08             	mov    0x8(%ebp),%eax
  801098:	8a 00                	mov    (%eax),%al
  80109a:	84 c0                	test   %al,%al
  80109c:	75 e8                	jne    801086 <strnlen+0xf>
		n++;
	return n;
  80109e:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  8010a1:	c9                   	leave  
  8010a2:	c3                   	ret    

008010a3 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  8010a3:	55                   	push   %ebp
  8010a4:	89 e5                	mov    %esp,%ebp
  8010a6:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  8010a9:	8b 45 08             	mov    0x8(%ebp),%eax
  8010ac:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  8010af:	90                   	nop
  8010b0:	8b 45 08             	mov    0x8(%ebp),%eax
  8010b3:	8d 50 01             	lea    0x1(%eax),%edx
  8010b6:	89 55 08             	mov    %edx,0x8(%ebp)
  8010b9:	8b 55 0c             	mov    0xc(%ebp),%edx
  8010bc:	8d 4a 01             	lea    0x1(%edx),%ecx
  8010bf:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  8010c2:	8a 12                	mov    (%edx),%dl
  8010c4:	88 10                	mov    %dl,(%eax)
  8010c6:	8a 00                	mov    (%eax),%al
  8010c8:	84 c0                	test   %al,%al
  8010ca:	75 e4                	jne    8010b0 <strcpy+0xd>
		/* do nothing */;
	return ret;
  8010cc:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  8010cf:	c9                   	leave  
  8010d0:	c3                   	ret    

008010d1 <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  8010d1:	55                   	push   %ebp
  8010d2:	89 e5                	mov    %esp,%ebp
  8010d4:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  8010d7:	8b 45 08             	mov    0x8(%ebp),%eax
  8010da:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  8010dd:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8010e4:	eb 1f                	jmp    801105 <strncpy+0x34>
		*dst++ = *src;
  8010e6:	8b 45 08             	mov    0x8(%ebp),%eax
  8010e9:	8d 50 01             	lea    0x1(%eax),%edx
  8010ec:	89 55 08             	mov    %edx,0x8(%ebp)
  8010ef:	8b 55 0c             	mov    0xc(%ebp),%edx
  8010f2:	8a 12                	mov    (%edx),%dl
  8010f4:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  8010f6:	8b 45 0c             	mov    0xc(%ebp),%eax
  8010f9:	8a 00                	mov    (%eax),%al
  8010fb:	84 c0                	test   %al,%al
  8010fd:	74 03                	je     801102 <strncpy+0x31>
			src++;
  8010ff:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  801102:	ff 45 fc             	incl   -0x4(%ebp)
  801105:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801108:	3b 45 10             	cmp    0x10(%ebp),%eax
  80110b:	72 d9                	jb     8010e6 <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  80110d:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  801110:	c9                   	leave  
  801111:	c3                   	ret    

00801112 <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  801112:	55                   	push   %ebp
  801113:	89 e5                	mov    %esp,%ebp
  801115:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  801118:	8b 45 08             	mov    0x8(%ebp),%eax
  80111b:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  80111e:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801122:	74 30                	je     801154 <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  801124:	eb 16                	jmp    80113c <strlcpy+0x2a>
			*dst++ = *src++;
  801126:	8b 45 08             	mov    0x8(%ebp),%eax
  801129:	8d 50 01             	lea    0x1(%eax),%edx
  80112c:	89 55 08             	mov    %edx,0x8(%ebp)
  80112f:	8b 55 0c             	mov    0xc(%ebp),%edx
  801132:	8d 4a 01             	lea    0x1(%edx),%ecx
  801135:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  801138:	8a 12                	mov    (%edx),%dl
  80113a:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  80113c:	ff 4d 10             	decl   0x10(%ebp)
  80113f:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801143:	74 09                	je     80114e <strlcpy+0x3c>
  801145:	8b 45 0c             	mov    0xc(%ebp),%eax
  801148:	8a 00                	mov    (%eax),%al
  80114a:	84 c0                	test   %al,%al
  80114c:	75 d8                	jne    801126 <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  80114e:	8b 45 08             	mov    0x8(%ebp),%eax
  801151:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  801154:	8b 55 08             	mov    0x8(%ebp),%edx
  801157:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80115a:	29 c2                	sub    %eax,%edx
  80115c:	89 d0                	mov    %edx,%eax
}
  80115e:	c9                   	leave  
  80115f:	c3                   	ret    

00801160 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  801160:	55                   	push   %ebp
  801161:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  801163:	eb 06                	jmp    80116b <strcmp+0xb>
		p++, q++;
  801165:	ff 45 08             	incl   0x8(%ebp)
  801168:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  80116b:	8b 45 08             	mov    0x8(%ebp),%eax
  80116e:	8a 00                	mov    (%eax),%al
  801170:	84 c0                	test   %al,%al
  801172:	74 0e                	je     801182 <strcmp+0x22>
  801174:	8b 45 08             	mov    0x8(%ebp),%eax
  801177:	8a 10                	mov    (%eax),%dl
  801179:	8b 45 0c             	mov    0xc(%ebp),%eax
  80117c:	8a 00                	mov    (%eax),%al
  80117e:	38 c2                	cmp    %al,%dl
  801180:	74 e3                	je     801165 <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  801182:	8b 45 08             	mov    0x8(%ebp),%eax
  801185:	8a 00                	mov    (%eax),%al
  801187:	0f b6 d0             	movzbl %al,%edx
  80118a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80118d:	8a 00                	mov    (%eax),%al
  80118f:	0f b6 c0             	movzbl %al,%eax
  801192:	29 c2                	sub    %eax,%edx
  801194:	89 d0                	mov    %edx,%eax
}
  801196:	5d                   	pop    %ebp
  801197:	c3                   	ret    

00801198 <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  801198:	55                   	push   %ebp
  801199:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  80119b:	eb 09                	jmp    8011a6 <strncmp+0xe>
		n--, p++, q++;
  80119d:	ff 4d 10             	decl   0x10(%ebp)
  8011a0:	ff 45 08             	incl   0x8(%ebp)
  8011a3:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  8011a6:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8011aa:	74 17                	je     8011c3 <strncmp+0x2b>
  8011ac:	8b 45 08             	mov    0x8(%ebp),%eax
  8011af:	8a 00                	mov    (%eax),%al
  8011b1:	84 c0                	test   %al,%al
  8011b3:	74 0e                	je     8011c3 <strncmp+0x2b>
  8011b5:	8b 45 08             	mov    0x8(%ebp),%eax
  8011b8:	8a 10                	mov    (%eax),%dl
  8011ba:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011bd:	8a 00                	mov    (%eax),%al
  8011bf:	38 c2                	cmp    %al,%dl
  8011c1:	74 da                	je     80119d <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  8011c3:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8011c7:	75 07                	jne    8011d0 <strncmp+0x38>
		return 0;
  8011c9:	b8 00 00 00 00       	mov    $0x0,%eax
  8011ce:	eb 14                	jmp    8011e4 <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  8011d0:	8b 45 08             	mov    0x8(%ebp),%eax
  8011d3:	8a 00                	mov    (%eax),%al
  8011d5:	0f b6 d0             	movzbl %al,%edx
  8011d8:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011db:	8a 00                	mov    (%eax),%al
  8011dd:	0f b6 c0             	movzbl %al,%eax
  8011e0:	29 c2                	sub    %eax,%edx
  8011e2:	89 d0                	mov    %edx,%eax
}
  8011e4:	5d                   	pop    %ebp
  8011e5:	c3                   	ret    

008011e6 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  8011e6:	55                   	push   %ebp
  8011e7:	89 e5                	mov    %esp,%ebp
  8011e9:	83 ec 04             	sub    $0x4,%esp
  8011ec:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011ef:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  8011f2:	eb 12                	jmp    801206 <strchr+0x20>
		if (*s == c)
  8011f4:	8b 45 08             	mov    0x8(%ebp),%eax
  8011f7:	8a 00                	mov    (%eax),%al
  8011f9:	3a 45 fc             	cmp    -0x4(%ebp),%al
  8011fc:	75 05                	jne    801203 <strchr+0x1d>
			return (char *) s;
  8011fe:	8b 45 08             	mov    0x8(%ebp),%eax
  801201:	eb 11                	jmp    801214 <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  801203:	ff 45 08             	incl   0x8(%ebp)
  801206:	8b 45 08             	mov    0x8(%ebp),%eax
  801209:	8a 00                	mov    (%eax),%al
  80120b:	84 c0                	test   %al,%al
  80120d:	75 e5                	jne    8011f4 <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  80120f:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801214:	c9                   	leave  
  801215:	c3                   	ret    

00801216 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  801216:	55                   	push   %ebp
  801217:	89 e5                	mov    %esp,%ebp
  801219:	83 ec 04             	sub    $0x4,%esp
  80121c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80121f:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  801222:	eb 0d                	jmp    801231 <strfind+0x1b>
		if (*s == c)
  801224:	8b 45 08             	mov    0x8(%ebp),%eax
  801227:	8a 00                	mov    (%eax),%al
  801229:	3a 45 fc             	cmp    -0x4(%ebp),%al
  80122c:	74 0e                	je     80123c <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  80122e:	ff 45 08             	incl   0x8(%ebp)
  801231:	8b 45 08             	mov    0x8(%ebp),%eax
  801234:	8a 00                	mov    (%eax),%al
  801236:	84 c0                	test   %al,%al
  801238:	75 ea                	jne    801224 <strfind+0xe>
  80123a:	eb 01                	jmp    80123d <strfind+0x27>
		if (*s == c)
			break;
  80123c:	90                   	nop
	return (char *) s;
  80123d:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801240:	c9                   	leave  
  801241:	c3                   	ret    

00801242 <memset>:


void *
memset(void *v, int c, uint32 n)
{
  801242:	55                   	push   %ebp
  801243:	89 e5                	mov    %esp,%ebp
  801245:	83 ec 10             	sub    $0x10,%esp
	char *p;
	int m;

	p = v;
  801248:	8b 45 08             	mov    0x8(%ebp),%eax
  80124b:	89 45 fc             	mov    %eax,-0x4(%ebp)
	m = n;
  80124e:	8b 45 10             	mov    0x10(%ebp),%eax
  801251:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (--m >= 0)
  801254:	eb 0e                	jmp    801264 <memset+0x22>
		*p++ = c;
  801256:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801259:	8d 50 01             	lea    0x1(%eax),%edx
  80125c:	89 55 fc             	mov    %edx,-0x4(%ebp)
  80125f:	8b 55 0c             	mov    0xc(%ebp),%edx
  801262:	88 10                	mov    %dl,(%eax)
	char *p;
	int m;

	p = v;
	m = n;
	while (--m >= 0)
  801264:	ff 4d f8             	decl   -0x8(%ebp)
  801267:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
  80126b:	79 e9                	jns    801256 <memset+0x14>
		*p++ = c;

	return v;
  80126d:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801270:	c9                   	leave  
  801271:	c3                   	ret    

00801272 <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  801272:	55                   	push   %ebp
  801273:	89 e5                	mov    %esp,%ebp
  801275:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  801278:	8b 45 0c             	mov    0xc(%ebp),%eax
  80127b:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  80127e:	8b 45 08             	mov    0x8(%ebp),%eax
  801281:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (n-- > 0)
  801284:	eb 16                	jmp    80129c <memcpy+0x2a>
		*d++ = *s++;
  801286:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801289:	8d 50 01             	lea    0x1(%eax),%edx
  80128c:	89 55 f8             	mov    %edx,-0x8(%ebp)
  80128f:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801292:	8d 4a 01             	lea    0x1(%edx),%ecx
  801295:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  801298:	8a 12                	mov    (%edx),%dl
  80129a:	88 10                	mov    %dl,(%eax)
	const char *s;
	char *d;

	s = src;
	d = dst;
	while (n-- > 0)
  80129c:	8b 45 10             	mov    0x10(%ebp),%eax
  80129f:	8d 50 ff             	lea    -0x1(%eax),%edx
  8012a2:	89 55 10             	mov    %edx,0x10(%ebp)
  8012a5:	85 c0                	test   %eax,%eax
  8012a7:	75 dd                	jne    801286 <memcpy+0x14>
		*d++ = *s++;

	return dst;
  8012a9:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8012ac:	c9                   	leave  
  8012ad:	c3                   	ret    

008012ae <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  8012ae:	55                   	push   %ebp
  8012af:	89 e5                	mov    %esp,%ebp
  8012b1:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  8012b4:	8b 45 0c             	mov    0xc(%ebp),%eax
  8012b7:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  8012ba:	8b 45 08             	mov    0x8(%ebp),%eax
  8012bd:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  8012c0:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8012c3:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  8012c6:	73 50                	jae    801318 <memmove+0x6a>
  8012c8:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8012cb:	8b 45 10             	mov    0x10(%ebp),%eax
  8012ce:	01 d0                	add    %edx,%eax
  8012d0:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  8012d3:	76 43                	jbe    801318 <memmove+0x6a>
		s += n;
  8012d5:	8b 45 10             	mov    0x10(%ebp),%eax
  8012d8:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  8012db:	8b 45 10             	mov    0x10(%ebp),%eax
  8012de:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  8012e1:	eb 10                	jmp    8012f3 <memmove+0x45>
			*--d = *--s;
  8012e3:	ff 4d f8             	decl   -0x8(%ebp)
  8012e6:	ff 4d fc             	decl   -0x4(%ebp)
  8012e9:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8012ec:	8a 10                	mov    (%eax),%dl
  8012ee:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8012f1:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  8012f3:	8b 45 10             	mov    0x10(%ebp),%eax
  8012f6:	8d 50 ff             	lea    -0x1(%eax),%edx
  8012f9:	89 55 10             	mov    %edx,0x10(%ebp)
  8012fc:	85 c0                	test   %eax,%eax
  8012fe:	75 e3                	jne    8012e3 <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  801300:	eb 23                	jmp    801325 <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  801302:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801305:	8d 50 01             	lea    0x1(%eax),%edx
  801308:	89 55 f8             	mov    %edx,-0x8(%ebp)
  80130b:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80130e:	8d 4a 01             	lea    0x1(%edx),%ecx
  801311:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  801314:	8a 12                	mov    (%edx),%dl
  801316:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  801318:	8b 45 10             	mov    0x10(%ebp),%eax
  80131b:	8d 50 ff             	lea    -0x1(%eax),%edx
  80131e:	89 55 10             	mov    %edx,0x10(%ebp)
  801321:	85 c0                	test   %eax,%eax
  801323:	75 dd                	jne    801302 <memmove+0x54>
			*d++ = *s++;

	return dst;
  801325:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801328:	c9                   	leave  
  801329:	c3                   	ret    

0080132a <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  80132a:	55                   	push   %ebp
  80132b:	89 e5                	mov    %esp,%ebp
  80132d:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  801330:	8b 45 08             	mov    0x8(%ebp),%eax
  801333:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  801336:	8b 45 0c             	mov    0xc(%ebp),%eax
  801339:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  80133c:	eb 2a                	jmp    801368 <memcmp+0x3e>
		if (*s1 != *s2)
  80133e:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801341:	8a 10                	mov    (%eax),%dl
  801343:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801346:	8a 00                	mov    (%eax),%al
  801348:	38 c2                	cmp    %al,%dl
  80134a:	74 16                	je     801362 <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  80134c:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80134f:	8a 00                	mov    (%eax),%al
  801351:	0f b6 d0             	movzbl %al,%edx
  801354:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801357:	8a 00                	mov    (%eax),%al
  801359:	0f b6 c0             	movzbl %al,%eax
  80135c:	29 c2                	sub    %eax,%edx
  80135e:	89 d0                	mov    %edx,%eax
  801360:	eb 18                	jmp    80137a <memcmp+0x50>
		s1++, s2++;
  801362:	ff 45 fc             	incl   -0x4(%ebp)
  801365:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  801368:	8b 45 10             	mov    0x10(%ebp),%eax
  80136b:	8d 50 ff             	lea    -0x1(%eax),%edx
  80136e:	89 55 10             	mov    %edx,0x10(%ebp)
  801371:	85 c0                	test   %eax,%eax
  801373:	75 c9                	jne    80133e <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  801375:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80137a:	c9                   	leave  
  80137b:	c3                   	ret    

0080137c <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  80137c:	55                   	push   %ebp
  80137d:	89 e5                	mov    %esp,%ebp
  80137f:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  801382:	8b 55 08             	mov    0x8(%ebp),%edx
  801385:	8b 45 10             	mov    0x10(%ebp),%eax
  801388:	01 d0                	add    %edx,%eax
  80138a:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  80138d:	eb 15                	jmp    8013a4 <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  80138f:	8b 45 08             	mov    0x8(%ebp),%eax
  801392:	8a 00                	mov    (%eax),%al
  801394:	0f b6 d0             	movzbl %al,%edx
  801397:	8b 45 0c             	mov    0xc(%ebp),%eax
  80139a:	0f b6 c0             	movzbl %al,%eax
  80139d:	39 c2                	cmp    %eax,%edx
  80139f:	74 0d                	je     8013ae <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  8013a1:	ff 45 08             	incl   0x8(%ebp)
  8013a4:	8b 45 08             	mov    0x8(%ebp),%eax
  8013a7:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  8013aa:	72 e3                	jb     80138f <memfind+0x13>
  8013ac:	eb 01                	jmp    8013af <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  8013ae:	90                   	nop
	return (void *) s;
  8013af:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8013b2:	c9                   	leave  
  8013b3:	c3                   	ret    

008013b4 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  8013b4:	55                   	push   %ebp
  8013b5:	89 e5                	mov    %esp,%ebp
  8013b7:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  8013ba:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  8013c1:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  8013c8:	eb 03                	jmp    8013cd <strtol+0x19>
		s++;
  8013ca:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  8013cd:	8b 45 08             	mov    0x8(%ebp),%eax
  8013d0:	8a 00                	mov    (%eax),%al
  8013d2:	3c 20                	cmp    $0x20,%al
  8013d4:	74 f4                	je     8013ca <strtol+0x16>
  8013d6:	8b 45 08             	mov    0x8(%ebp),%eax
  8013d9:	8a 00                	mov    (%eax),%al
  8013db:	3c 09                	cmp    $0x9,%al
  8013dd:	74 eb                	je     8013ca <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  8013df:	8b 45 08             	mov    0x8(%ebp),%eax
  8013e2:	8a 00                	mov    (%eax),%al
  8013e4:	3c 2b                	cmp    $0x2b,%al
  8013e6:	75 05                	jne    8013ed <strtol+0x39>
		s++;
  8013e8:	ff 45 08             	incl   0x8(%ebp)
  8013eb:	eb 13                	jmp    801400 <strtol+0x4c>
	else if (*s == '-')
  8013ed:	8b 45 08             	mov    0x8(%ebp),%eax
  8013f0:	8a 00                	mov    (%eax),%al
  8013f2:	3c 2d                	cmp    $0x2d,%al
  8013f4:	75 0a                	jne    801400 <strtol+0x4c>
		s++, neg = 1;
  8013f6:	ff 45 08             	incl   0x8(%ebp)
  8013f9:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  801400:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801404:	74 06                	je     80140c <strtol+0x58>
  801406:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  80140a:	75 20                	jne    80142c <strtol+0x78>
  80140c:	8b 45 08             	mov    0x8(%ebp),%eax
  80140f:	8a 00                	mov    (%eax),%al
  801411:	3c 30                	cmp    $0x30,%al
  801413:	75 17                	jne    80142c <strtol+0x78>
  801415:	8b 45 08             	mov    0x8(%ebp),%eax
  801418:	40                   	inc    %eax
  801419:	8a 00                	mov    (%eax),%al
  80141b:	3c 78                	cmp    $0x78,%al
  80141d:	75 0d                	jne    80142c <strtol+0x78>
		s += 2, base = 16;
  80141f:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  801423:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  80142a:	eb 28                	jmp    801454 <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  80142c:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801430:	75 15                	jne    801447 <strtol+0x93>
  801432:	8b 45 08             	mov    0x8(%ebp),%eax
  801435:	8a 00                	mov    (%eax),%al
  801437:	3c 30                	cmp    $0x30,%al
  801439:	75 0c                	jne    801447 <strtol+0x93>
		s++, base = 8;
  80143b:	ff 45 08             	incl   0x8(%ebp)
  80143e:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  801445:	eb 0d                	jmp    801454 <strtol+0xa0>
	else if (base == 0)
  801447:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80144b:	75 07                	jne    801454 <strtol+0xa0>
		base = 10;
  80144d:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  801454:	8b 45 08             	mov    0x8(%ebp),%eax
  801457:	8a 00                	mov    (%eax),%al
  801459:	3c 2f                	cmp    $0x2f,%al
  80145b:	7e 19                	jle    801476 <strtol+0xc2>
  80145d:	8b 45 08             	mov    0x8(%ebp),%eax
  801460:	8a 00                	mov    (%eax),%al
  801462:	3c 39                	cmp    $0x39,%al
  801464:	7f 10                	jg     801476 <strtol+0xc2>
			dig = *s - '0';
  801466:	8b 45 08             	mov    0x8(%ebp),%eax
  801469:	8a 00                	mov    (%eax),%al
  80146b:	0f be c0             	movsbl %al,%eax
  80146e:	83 e8 30             	sub    $0x30,%eax
  801471:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801474:	eb 42                	jmp    8014b8 <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  801476:	8b 45 08             	mov    0x8(%ebp),%eax
  801479:	8a 00                	mov    (%eax),%al
  80147b:	3c 60                	cmp    $0x60,%al
  80147d:	7e 19                	jle    801498 <strtol+0xe4>
  80147f:	8b 45 08             	mov    0x8(%ebp),%eax
  801482:	8a 00                	mov    (%eax),%al
  801484:	3c 7a                	cmp    $0x7a,%al
  801486:	7f 10                	jg     801498 <strtol+0xe4>
			dig = *s - 'a' + 10;
  801488:	8b 45 08             	mov    0x8(%ebp),%eax
  80148b:	8a 00                	mov    (%eax),%al
  80148d:	0f be c0             	movsbl %al,%eax
  801490:	83 e8 57             	sub    $0x57,%eax
  801493:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801496:	eb 20                	jmp    8014b8 <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  801498:	8b 45 08             	mov    0x8(%ebp),%eax
  80149b:	8a 00                	mov    (%eax),%al
  80149d:	3c 40                	cmp    $0x40,%al
  80149f:	7e 39                	jle    8014da <strtol+0x126>
  8014a1:	8b 45 08             	mov    0x8(%ebp),%eax
  8014a4:	8a 00                	mov    (%eax),%al
  8014a6:	3c 5a                	cmp    $0x5a,%al
  8014a8:	7f 30                	jg     8014da <strtol+0x126>
			dig = *s - 'A' + 10;
  8014aa:	8b 45 08             	mov    0x8(%ebp),%eax
  8014ad:	8a 00                	mov    (%eax),%al
  8014af:	0f be c0             	movsbl %al,%eax
  8014b2:	83 e8 37             	sub    $0x37,%eax
  8014b5:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  8014b8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8014bb:	3b 45 10             	cmp    0x10(%ebp),%eax
  8014be:	7d 19                	jge    8014d9 <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  8014c0:	ff 45 08             	incl   0x8(%ebp)
  8014c3:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8014c6:	0f af 45 10          	imul   0x10(%ebp),%eax
  8014ca:	89 c2                	mov    %eax,%edx
  8014cc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8014cf:	01 d0                	add    %edx,%eax
  8014d1:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  8014d4:	e9 7b ff ff ff       	jmp    801454 <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  8014d9:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  8014da:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8014de:	74 08                	je     8014e8 <strtol+0x134>
		*endptr = (char *) s;
  8014e0:	8b 45 0c             	mov    0xc(%ebp),%eax
  8014e3:	8b 55 08             	mov    0x8(%ebp),%edx
  8014e6:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  8014e8:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  8014ec:	74 07                	je     8014f5 <strtol+0x141>
  8014ee:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8014f1:	f7 d8                	neg    %eax
  8014f3:	eb 03                	jmp    8014f8 <strtol+0x144>
  8014f5:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  8014f8:	c9                   	leave  
  8014f9:	c3                   	ret    

008014fa <ltostr>:

void
ltostr(long value, char *str)
{
  8014fa:	55                   	push   %ebp
  8014fb:	89 e5                	mov    %esp,%ebp
  8014fd:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  801500:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  801507:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  80150e:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801512:	79 13                	jns    801527 <ltostr+0x2d>
	{
		neg = 1;
  801514:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  80151b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80151e:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  801521:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  801524:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  801527:	8b 45 08             	mov    0x8(%ebp),%eax
  80152a:	b9 0a 00 00 00       	mov    $0xa,%ecx
  80152f:	99                   	cltd   
  801530:	f7 f9                	idiv   %ecx
  801532:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  801535:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801538:	8d 50 01             	lea    0x1(%eax),%edx
  80153b:	89 55 f8             	mov    %edx,-0x8(%ebp)
  80153e:	89 c2                	mov    %eax,%edx
  801540:	8b 45 0c             	mov    0xc(%ebp),%eax
  801543:	01 d0                	add    %edx,%eax
  801545:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801548:	83 c2 30             	add    $0x30,%edx
  80154b:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  80154d:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801550:	b8 67 66 66 66       	mov    $0x66666667,%eax
  801555:	f7 e9                	imul   %ecx
  801557:	c1 fa 02             	sar    $0x2,%edx
  80155a:	89 c8                	mov    %ecx,%eax
  80155c:	c1 f8 1f             	sar    $0x1f,%eax
  80155f:	29 c2                	sub    %eax,%edx
  801561:	89 d0                	mov    %edx,%eax
  801563:	89 45 08             	mov    %eax,0x8(%ebp)
	} while (value % 10 != 0);
  801566:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801569:	b8 67 66 66 66       	mov    $0x66666667,%eax
  80156e:	f7 e9                	imul   %ecx
  801570:	c1 fa 02             	sar    $0x2,%edx
  801573:	89 c8                	mov    %ecx,%eax
  801575:	c1 f8 1f             	sar    $0x1f,%eax
  801578:	29 c2                	sub    %eax,%edx
  80157a:	89 d0                	mov    %edx,%eax
  80157c:	c1 e0 02             	shl    $0x2,%eax
  80157f:	01 d0                	add    %edx,%eax
  801581:	01 c0                	add    %eax,%eax
  801583:	29 c1                	sub    %eax,%ecx
  801585:	89 ca                	mov    %ecx,%edx
  801587:	85 d2                	test   %edx,%edx
  801589:	75 9c                	jne    801527 <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  80158b:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  801592:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801595:	48                   	dec    %eax
  801596:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  801599:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  80159d:	74 3d                	je     8015dc <ltostr+0xe2>
		start = 1 ;
  80159f:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  8015a6:	eb 34                	jmp    8015dc <ltostr+0xe2>
	{
		char tmp = str[start] ;
  8015a8:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8015ab:	8b 45 0c             	mov    0xc(%ebp),%eax
  8015ae:	01 d0                	add    %edx,%eax
  8015b0:	8a 00                	mov    (%eax),%al
  8015b2:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  8015b5:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8015b8:	8b 45 0c             	mov    0xc(%ebp),%eax
  8015bb:	01 c2                	add    %eax,%edx
  8015bd:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  8015c0:	8b 45 0c             	mov    0xc(%ebp),%eax
  8015c3:	01 c8                	add    %ecx,%eax
  8015c5:	8a 00                	mov    (%eax),%al
  8015c7:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  8015c9:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8015cc:	8b 45 0c             	mov    0xc(%ebp),%eax
  8015cf:	01 c2                	add    %eax,%edx
  8015d1:	8a 45 eb             	mov    -0x15(%ebp),%al
  8015d4:	88 02                	mov    %al,(%edx)
		start++ ;
  8015d6:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  8015d9:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  8015dc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8015df:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8015e2:	7c c4                	jl     8015a8 <ltostr+0xae>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  8015e4:	8b 55 f8             	mov    -0x8(%ebp),%edx
  8015e7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8015ea:	01 d0                	add    %edx,%eax
  8015ec:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  8015ef:	90                   	nop
  8015f0:	c9                   	leave  
  8015f1:	c3                   	ret    

008015f2 <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  8015f2:	55                   	push   %ebp
  8015f3:	89 e5                	mov    %esp,%ebp
  8015f5:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  8015f8:	ff 75 08             	pushl  0x8(%ebp)
  8015fb:	e8 54 fa ff ff       	call   801054 <strlen>
  801600:	83 c4 04             	add    $0x4,%esp
  801603:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  801606:	ff 75 0c             	pushl  0xc(%ebp)
  801609:	e8 46 fa ff ff       	call   801054 <strlen>
  80160e:	83 c4 04             	add    $0x4,%esp
  801611:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  801614:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  80161b:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801622:	eb 17                	jmp    80163b <strcconcat+0x49>
		final[s] = str1[s] ;
  801624:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801627:	8b 45 10             	mov    0x10(%ebp),%eax
  80162a:	01 c2                	add    %eax,%edx
  80162c:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  80162f:	8b 45 08             	mov    0x8(%ebp),%eax
  801632:	01 c8                	add    %ecx,%eax
  801634:	8a 00                	mov    (%eax),%al
  801636:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  801638:	ff 45 fc             	incl   -0x4(%ebp)
  80163b:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80163e:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  801641:	7c e1                	jl     801624 <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  801643:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  80164a:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  801651:	eb 1f                	jmp    801672 <strcconcat+0x80>
		final[s++] = str2[i] ;
  801653:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801656:	8d 50 01             	lea    0x1(%eax),%edx
  801659:	89 55 fc             	mov    %edx,-0x4(%ebp)
  80165c:	89 c2                	mov    %eax,%edx
  80165e:	8b 45 10             	mov    0x10(%ebp),%eax
  801661:	01 c2                	add    %eax,%edx
  801663:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  801666:	8b 45 0c             	mov    0xc(%ebp),%eax
  801669:	01 c8                	add    %ecx,%eax
  80166b:	8a 00                	mov    (%eax),%al
  80166d:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  80166f:	ff 45 f8             	incl   -0x8(%ebp)
  801672:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801675:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801678:	7c d9                	jl     801653 <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  80167a:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80167d:	8b 45 10             	mov    0x10(%ebp),%eax
  801680:	01 d0                	add    %edx,%eax
  801682:	c6 00 00             	movb   $0x0,(%eax)
}
  801685:	90                   	nop
  801686:	c9                   	leave  
  801687:	c3                   	ret    

00801688 <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  801688:	55                   	push   %ebp
  801689:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  80168b:	8b 45 14             	mov    0x14(%ebp),%eax
  80168e:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  801694:	8b 45 14             	mov    0x14(%ebp),%eax
  801697:	8b 00                	mov    (%eax),%eax
  801699:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8016a0:	8b 45 10             	mov    0x10(%ebp),%eax
  8016a3:	01 d0                	add    %edx,%eax
  8016a5:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  8016ab:	eb 0c                	jmp    8016b9 <strsplit+0x31>
			*string++ = 0;
  8016ad:	8b 45 08             	mov    0x8(%ebp),%eax
  8016b0:	8d 50 01             	lea    0x1(%eax),%edx
  8016b3:	89 55 08             	mov    %edx,0x8(%ebp)
  8016b6:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  8016b9:	8b 45 08             	mov    0x8(%ebp),%eax
  8016bc:	8a 00                	mov    (%eax),%al
  8016be:	84 c0                	test   %al,%al
  8016c0:	74 18                	je     8016da <strsplit+0x52>
  8016c2:	8b 45 08             	mov    0x8(%ebp),%eax
  8016c5:	8a 00                	mov    (%eax),%al
  8016c7:	0f be c0             	movsbl %al,%eax
  8016ca:	50                   	push   %eax
  8016cb:	ff 75 0c             	pushl  0xc(%ebp)
  8016ce:	e8 13 fb ff ff       	call   8011e6 <strchr>
  8016d3:	83 c4 08             	add    $0x8,%esp
  8016d6:	85 c0                	test   %eax,%eax
  8016d8:	75 d3                	jne    8016ad <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  8016da:	8b 45 08             	mov    0x8(%ebp),%eax
  8016dd:	8a 00                	mov    (%eax),%al
  8016df:	84 c0                	test   %al,%al
  8016e1:	74 5a                	je     80173d <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  8016e3:	8b 45 14             	mov    0x14(%ebp),%eax
  8016e6:	8b 00                	mov    (%eax),%eax
  8016e8:	83 f8 0f             	cmp    $0xf,%eax
  8016eb:	75 07                	jne    8016f4 <strsplit+0x6c>
		{
			return 0;
  8016ed:	b8 00 00 00 00       	mov    $0x0,%eax
  8016f2:	eb 66                	jmp    80175a <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  8016f4:	8b 45 14             	mov    0x14(%ebp),%eax
  8016f7:	8b 00                	mov    (%eax),%eax
  8016f9:	8d 48 01             	lea    0x1(%eax),%ecx
  8016fc:	8b 55 14             	mov    0x14(%ebp),%edx
  8016ff:	89 0a                	mov    %ecx,(%edx)
  801701:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801708:	8b 45 10             	mov    0x10(%ebp),%eax
  80170b:	01 c2                	add    %eax,%edx
  80170d:	8b 45 08             	mov    0x8(%ebp),%eax
  801710:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  801712:	eb 03                	jmp    801717 <strsplit+0x8f>
			string++;
  801714:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  801717:	8b 45 08             	mov    0x8(%ebp),%eax
  80171a:	8a 00                	mov    (%eax),%al
  80171c:	84 c0                	test   %al,%al
  80171e:	74 8b                	je     8016ab <strsplit+0x23>
  801720:	8b 45 08             	mov    0x8(%ebp),%eax
  801723:	8a 00                	mov    (%eax),%al
  801725:	0f be c0             	movsbl %al,%eax
  801728:	50                   	push   %eax
  801729:	ff 75 0c             	pushl  0xc(%ebp)
  80172c:	e8 b5 fa ff ff       	call   8011e6 <strchr>
  801731:	83 c4 08             	add    $0x8,%esp
  801734:	85 c0                	test   %eax,%eax
  801736:	74 dc                	je     801714 <strsplit+0x8c>
			string++;
	}
  801738:	e9 6e ff ff ff       	jmp    8016ab <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  80173d:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  80173e:	8b 45 14             	mov    0x14(%ebp),%eax
  801741:	8b 00                	mov    (%eax),%eax
  801743:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80174a:	8b 45 10             	mov    0x10(%ebp),%eax
  80174d:	01 d0                	add    %edx,%eax
  80174f:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  801755:	b8 01 00 00 00       	mov    $0x1,%eax
}
  80175a:	c9                   	leave  
  80175b:	c3                   	ret    

0080175c <InitializeUHeap>:
//============================== GIVEN FUNCTIONS ===================================//
//==================================================================================//

int FirstTimeFlag = 1;
void InitializeUHeap()
{
  80175c:	55                   	push   %ebp
  80175d:	89 e5                	mov    %esp,%ebp
  80175f:	83 ec 08             	sub    $0x8,%esp
	if(FirstTimeFlag)
  801762:	a1 04 40 80 00       	mov    0x804004,%eax
  801767:	85 c0                	test   %eax,%eax
  801769:	74 1f                	je     80178a <InitializeUHeap+0x2e>
	{
		initialize_dyn_block_system();
  80176b:	e8 1d 00 00 00       	call   80178d <initialize_dyn_block_system>
		cprintf("DYNAMIC BLOCK SYSTEM IS INITIALIZED\n");
  801770:	83 ec 0c             	sub    $0xc,%esp
  801773:	68 10 3d 80 00       	push   $0x803d10
  801778:	e8 55 f2 ff ff       	call   8009d2 <cprintf>
  80177d:	83 c4 10             	add    $0x10,%esp
#if UHP_USE_BUDDY
		initialize_buddy();
		cprintf("BUDDY SYSTEM IS INITIALIZED\n");
#endif
		FirstTimeFlag = 0;
  801780:	c7 05 04 40 80 00 00 	movl   $0x0,0x804004
  801787:	00 00 00 
	}
}
  80178a:	90                   	nop
  80178b:	c9                   	leave  
  80178c:	c3                   	ret    

0080178d <initialize_dyn_block_system>:

//=================================
// [1] INITIALIZE DYNAMIC ALLOCATOR:
//=================================
void initialize_dyn_block_system()
{
  80178d:	55                   	push   %ebp
  80178e:	89 e5                	mov    %esp,%ebp
  801790:	83 ec 28             	sub    $0x28,%esp
	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] initialize_dyn_block_system
	// your code is here, remove the panic and write your code
	//panic("initialize_dyn_block_system() is not implemented yet...!!");

	LIST_INIT(&AllocMemBlocksList);
  801793:	c7 05 40 40 80 00 00 	movl   $0x0,0x804040
  80179a:	00 00 00 
  80179d:	c7 05 44 40 80 00 00 	movl   $0x0,0x804044
  8017a4:	00 00 00 
  8017a7:	c7 05 4c 40 80 00 00 	movl   $0x0,0x80404c
  8017ae:	00 00 00 
	LIST_INIT(&FreeMemBlocksList);
  8017b1:	c7 05 38 41 80 00 00 	movl   $0x0,0x804138
  8017b8:	00 00 00 
  8017bb:	c7 05 3c 41 80 00 00 	movl   $0x0,0x80413c
  8017c2:	00 00 00 
  8017c5:	c7 05 44 41 80 00 00 	movl   $0x0,0x804144
  8017cc:	00 00 00 
	MAX_MEM_BLOCK_CNT = NUM_OF_UHEAP_PAGES;
  8017cf:	c7 05 20 41 80 00 00 	movl   $0x20000,0x804120
  8017d6:	00 02 00 
	MemBlockNodes = (void*)USER_DYN_BLKS_ARRAY;
  8017d9:	c7 45 f4 00 00 e0 7f 	movl   $0x7fe00000,-0xc(%ebp)
  8017e0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8017e3:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8017e8:	2d 00 10 00 00       	sub    $0x1000,%eax
  8017ed:	a3 50 40 80 00       	mov    %eax,0x804050
	int size_of_block = sizeof(struct MemBlock);
  8017f2:	c7 45 f0 10 00 00 00 	movl   $0x10,-0x10(%ebp)
	int size_all_struct = size_of_block*MAX_MEM_BLOCK_CNT;
  8017f9:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8017fc:	a1 20 41 80 00       	mov    0x804120,%eax
  801801:	0f af c2             	imul   %edx,%eax
  801804:	89 45 ec             	mov    %eax,-0x14(%ebp)
	size_all_struct = ROUNDUP(size_all_struct, PAGE_SIZE);
  801807:	c7 45 e8 00 10 00 00 	movl   $0x1000,-0x18(%ebp)
  80180e:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801811:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801814:	01 d0                	add    %edx,%eax
  801816:	48                   	dec    %eax
  801817:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  80181a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80181d:	ba 00 00 00 00       	mov    $0x0,%edx
  801822:	f7 75 e8             	divl   -0x18(%ebp)
  801825:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801828:	29 d0                	sub    %edx,%eax
  80182a:	89 45 ec             	mov    %eax,-0x14(%ebp)
	sys_allocate_chunk(USER_DYN_BLKS_ARRAY, size_all_struct,PERM_USER| PERM_WRITEABLE);
  80182d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801830:	c7 45 e0 00 00 e0 7f 	movl   $0x7fe00000,-0x20(%ebp)
  801837:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80183a:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
  801840:	81 ea 00 10 00 00    	sub    $0x1000,%edx
  801846:	83 ec 04             	sub    $0x4,%esp
  801849:	6a 06                	push   $0x6
  80184b:	50                   	push   %eax
  80184c:	52                   	push   %edx
  80184d:	e8 a1 05 00 00       	call   801df3 <sys_allocate_chunk>
  801852:	83 c4 10             	add    $0x10,%esp
	initialize_MemBlocksList(MAX_MEM_BLOCK_CNT);
  801855:	a1 20 41 80 00       	mov    0x804120,%eax
  80185a:	83 ec 0c             	sub    $0xc,%esp
  80185d:	50                   	push   %eax
  80185e:	e8 16 0c 00 00       	call   802479 <initialize_MemBlocksList>
  801863:	83 c4 10             	add    $0x10,%esp
	struct MemBlock* ourBlock =LIST_LAST(&AvailableMemBlocksList);
  801866:	a1 4c 41 80 00       	mov    0x80414c,%eax
  80186b:	89 45 dc             	mov    %eax,-0x24(%ebp)
	LIST_REMOVE(&AvailableMemBlocksList,ourBlock);
  80186e:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  801872:	75 14                	jne    801888 <initialize_dyn_block_system+0xfb>
  801874:	83 ec 04             	sub    $0x4,%esp
  801877:	68 35 3d 80 00       	push   $0x803d35
  80187c:	6a 2d                	push   $0x2d
  80187e:	68 53 3d 80 00       	push   $0x803d53
  801883:	e8 96 ee ff ff       	call   80071e <_panic>
  801888:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80188b:	8b 00                	mov    (%eax),%eax
  80188d:	85 c0                	test   %eax,%eax
  80188f:	74 10                	je     8018a1 <initialize_dyn_block_system+0x114>
  801891:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801894:	8b 00                	mov    (%eax),%eax
  801896:	8b 55 dc             	mov    -0x24(%ebp),%edx
  801899:	8b 52 04             	mov    0x4(%edx),%edx
  80189c:	89 50 04             	mov    %edx,0x4(%eax)
  80189f:	eb 0b                	jmp    8018ac <initialize_dyn_block_system+0x11f>
  8018a1:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8018a4:	8b 40 04             	mov    0x4(%eax),%eax
  8018a7:	a3 4c 41 80 00       	mov    %eax,0x80414c
  8018ac:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8018af:	8b 40 04             	mov    0x4(%eax),%eax
  8018b2:	85 c0                	test   %eax,%eax
  8018b4:	74 0f                	je     8018c5 <initialize_dyn_block_system+0x138>
  8018b6:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8018b9:	8b 40 04             	mov    0x4(%eax),%eax
  8018bc:	8b 55 dc             	mov    -0x24(%ebp),%edx
  8018bf:	8b 12                	mov    (%edx),%edx
  8018c1:	89 10                	mov    %edx,(%eax)
  8018c3:	eb 0a                	jmp    8018cf <initialize_dyn_block_system+0x142>
  8018c5:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8018c8:	8b 00                	mov    (%eax),%eax
  8018ca:	a3 48 41 80 00       	mov    %eax,0x804148
  8018cf:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8018d2:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8018d8:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8018db:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8018e2:	a1 54 41 80 00       	mov    0x804154,%eax
  8018e7:	48                   	dec    %eax
  8018e8:	a3 54 41 80 00       	mov    %eax,0x804154
	ourBlock->size = USER_HEAP_MAX-USER_HEAP_START;
  8018ed:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8018f0:	c7 40 0c 00 00 00 20 	movl   $0x20000000,0xc(%eax)
	ourBlock->sva=USER_HEAP_START;
  8018f7:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8018fa:	c7 40 08 00 00 00 80 	movl   $0x80000000,0x8(%eax)
	LIST_INSERT_TAIL(&FreeMemBlocksList, ourBlock);
  801901:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  801905:	75 14                	jne    80191b <initialize_dyn_block_system+0x18e>
  801907:	83 ec 04             	sub    $0x4,%esp
  80190a:	68 60 3d 80 00       	push   $0x803d60
  80190f:	6a 30                	push   $0x30
  801911:	68 53 3d 80 00       	push   $0x803d53
  801916:	e8 03 ee ff ff       	call   80071e <_panic>
  80191b:	8b 15 3c 41 80 00    	mov    0x80413c,%edx
  801921:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801924:	89 50 04             	mov    %edx,0x4(%eax)
  801927:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80192a:	8b 40 04             	mov    0x4(%eax),%eax
  80192d:	85 c0                	test   %eax,%eax
  80192f:	74 0c                	je     80193d <initialize_dyn_block_system+0x1b0>
  801931:	a1 3c 41 80 00       	mov    0x80413c,%eax
  801936:	8b 55 dc             	mov    -0x24(%ebp),%edx
  801939:	89 10                	mov    %edx,(%eax)
  80193b:	eb 08                	jmp    801945 <initialize_dyn_block_system+0x1b8>
  80193d:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801940:	a3 38 41 80 00       	mov    %eax,0x804138
  801945:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801948:	a3 3c 41 80 00       	mov    %eax,0x80413c
  80194d:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801950:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  801956:	a1 44 41 80 00       	mov    0x804144,%eax
  80195b:	40                   	inc    %eax
  80195c:	a3 44 41 80 00       	mov    %eax,0x804144
	//[1] Initialize two lists (AllocMemBlocksList & FreeMemBlocksList) [Hint: use LIST_INIT()]
	//[2] Dynamically allocate the array of MemBlockNodes at VA USER_DYN_BLKS_ARRAY
	//	  (remember to set MAX_MEM_BLOCK_CNT with the chosen size of the array)
	//[3] Initialize AvailableMemBlocksList by filling it with the MemBlockNodes
	//[4] Insert a new MemBlock with the heap size into the FreeMemBlocksList
}
  801961:	90                   	nop
  801962:	c9                   	leave  
  801963:	c3                   	ret    

00801964 <malloc>:
//=================================
// [2] ALLOCATE SPACE IN USER HEAP:
//=================================

void* malloc(uint32 size)
{
  801964:	55                   	push   %ebp
  801965:	89 e5                	mov    %esp,%ebp
  801967:	83 ec 18             	sub    $0x18,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  80196a:	e8 ed fd ff ff       	call   80175c <InitializeUHeap>
	if (size == 0) return NULL ;
  80196f:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801973:	75 07                	jne    80197c <malloc+0x18>
  801975:	b8 00 00 00 00       	mov    $0x0,%eax
  80197a:	eb 67                	jmp    8019e3 <malloc+0x7f>

	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] malloc
	// your code is here, remove the panic and write your code
	//panic("malloc() is not implemented yet...!!");

	size = ROUNDUP(size, PAGE_SIZE);
  80197c:	c7 45 f4 00 10 00 00 	movl   $0x1000,-0xc(%ebp)
  801983:	8b 55 08             	mov    0x8(%ebp),%edx
  801986:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801989:	01 d0                	add    %edx,%eax
  80198b:	48                   	dec    %eax
  80198c:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80198f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801992:	ba 00 00 00 00       	mov    $0x0,%edx
  801997:	f7 75 f4             	divl   -0xc(%ebp)
  80199a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80199d:	29 d0                	sub    %edx,%eax
  80199f:	89 45 08             	mov    %eax,0x8(%ebp)
	if(sys_isUHeapPlacementStrategyFIRSTFIT())
  8019a2:	e8 1a 08 00 00       	call   8021c1 <sys_isUHeapPlacementStrategyFIRSTFIT>
  8019a7:	85 c0                	test   %eax,%eax
  8019a9:	74 33                	je     8019de <malloc+0x7a>
	{
		struct MemBlock * myBlock = alloc_block_FF(size);
  8019ab:	83 ec 0c             	sub    $0xc,%esp
  8019ae:	ff 75 08             	pushl  0x8(%ebp)
  8019b1:	e8 0c 0e 00 00       	call   8027c2 <alloc_block_FF>
  8019b6:	83 c4 10             	add    $0x10,%esp
  8019b9:	89 45 ec             	mov    %eax,-0x14(%ebp)
		if(myBlock != NULL)
  8019bc:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8019c0:	74 1c                	je     8019de <malloc+0x7a>
		{
			insert_sorted_allocList(myBlock);
  8019c2:	83 ec 0c             	sub    $0xc,%esp
  8019c5:	ff 75 ec             	pushl  -0x14(%ebp)
  8019c8:	e8 07 0c 00 00       	call   8025d4 <insert_sorted_allocList>
  8019cd:	83 c4 10             	add    $0x10,%esp
			uint32 ptr = myBlock->sva;
  8019d0:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8019d3:	8b 40 08             	mov    0x8(%eax),%eax
  8019d6:	89 45 e8             	mov    %eax,-0x18(%ebp)
			return (void *)ptr;
  8019d9:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8019dc:	eb 05                	jmp    8019e3 <malloc+0x7f>
		}
	}
	return NULL;
  8019de:	b8 00 00 00 00       	mov    $0x0,%eax
	//		to the required allocation size (space should be on 4 KB BOUNDARY)
	//	2) if no suitable space found, return NULL
	// 	3) Return pointer containing the virtual address of allocated space,
	//
	//Use sys_isUHeapPlacementStrategyFIRSTFIT()... to check the current strategy
}
  8019e3:	c9                   	leave  
  8019e4:	c3                   	ret    

008019e5 <free>:
//	We can use sys_free_user_mem(uint32 virtual_address, uint32 size); which
//		switches to the kernel mode, calls free_user_mem() in
//		"kern/mem/chunk_operations.c", then switch back to the user mode here
//	the free_user_mem function is empty, make sure to implement it.
void free(void* virtual_address)
{
  8019e5:	55                   	push   %ebp
  8019e6:	89 e5                	mov    %esp,%ebp
  8019e8:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] free
	// your code is here, remove the panic and write your code
	//panic("free() is not implemented yet...!!");

	uint32 virtualAddress = (uint32 )(virtual_address);
  8019eb:	8b 45 08             	mov    0x8(%ebp),%eax
  8019ee:	89 45 f4             	mov    %eax,-0xc(%ebp)
//	virtualAddress = ROUNDDOWN(virtualAddress, PAGE_SIZE);
	struct MemBlock * myBlock = find_block(&AllocMemBlocksList, virtualAddress);
  8019f1:	83 ec 08             	sub    $0x8,%esp
  8019f4:	ff 75 f4             	pushl  -0xc(%ebp)
  8019f7:	68 40 40 80 00       	push   $0x804040
  8019fc:	e8 5b 0b 00 00       	call   80255c <find_block>
  801a01:	83 c4 10             	add    $0x10,%esp
  801a04:	89 45 f0             	mov    %eax,-0x10(%ebp)
//	cprintf ("ptr sva at free user side = %x \n", myBlock->sva);
	sys_free_user_mem(virtualAddress, myBlock->size);
  801a07:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801a0a:	8b 40 0c             	mov    0xc(%eax),%eax
  801a0d:	83 ec 08             	sub    $0x8,%esp
  801a10:	50                   	push   %eax
  801a11:	ff 75 f4             	pushl  -0xc(%ebp)
  801a14:	e8 a2 03 00 00       	call   801dbb <sys_free_user_mem>
  801a19:	83 c4 10             	add    $0x10,%esp
	LIST_REMOVE(&AllocMemBlocksList, myBlock);
  801a1c:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801a20:	75 14                	jne    801a36 <free+0x51>
  801a22:	83 ec 04             	sub    $0x4,%esp
  801a25:	68 35 3d 80 00       	push   $0x803d35
  801a2a:	6a 76                	push   $0x76
  801a2c:	68 53 3d 80 00       	push   $0x803d53
  801a31:	e8 e8 ec ff ff       	call   80071e <_panic>
  801a36:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801a39:	8b 00                	mov    (%eax),%eax
  801a3b:	85 c0                	test   %eax,%eax
  801a3d:	74 10                	je     801a4f <free+0x6a>
  801a3f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801a42:	8b 00                	mov    (%eax),%eax
  801a44:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801a47:	8b 52 04             	mov    0x4(%edx),%edx
  801a4a:	89 50 04             	mov    %edx,0x4(%eax)
  801a4d:	eb 0b                	jmp    801a5a <free+0x75>
  801a4f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801a52:	8b 40 04             	mov    0x4(%eax),%eax
  801a55:	a3 44 40 80 00       	mov    %eax,0x804044
  801a5a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801a5d:	8b 40 04             	mov    0x4(%eax),%eax
  801a60:	85 c0                	test   %eax,%eax
  801a62:	74 0f                	je     801a73 <free+0x8e>
  801a64:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801a67:	8b 40 04             	mov    0x4(%eax),%eax
  801a6a:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801a6d:	8b 12                	mov    (%edx),%edx
  801a6f:	89 10                	mov    %edx,(%eax)
  801a71:	eb 0a                	jmp    801a7d <free+0x98>
  801a73:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801a76:	8b 00                	mov    (%eax),%eax
  801a78:	a3 40 40 80 00       	mov    %eax,0x804040
  801a7d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801a80:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  801a86:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801a89:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  801a90:	a1 4c 40 80 00       	mov    0x80404c,%eax
  801a95:	48                   	dec    %eax
  801a96:	a3 4c 40 80 00       	mov    %eax,0x80404c
	insert_sorted_with_merge_freeList(myBlock);
  801a9b:	83 ec 0c             	sub    $0xc,%esp
  801a9e:	ff 75 f0             	pushl  -0x10(%ebp)
  801aa1:	e8 0b 14 00 00       	call   802eb1 <insert_sorted_with_merge_freeList>
  801aa6:	83 c4 10             	add    $0x10,%esp

	//you should get the size of the given allocation using its address
	//you need to call sys_free_user_mem()
	//refer to the project presentation and documentation for details
}
  801aa9:	90                   	nop
  801aaa:	c9                   	leave  
  801aab:	c3                   	ret    

00801aac <smalloc>:

//=================================
// [4] ALLOCATE SHARED VARIABLE:
//=================================
void* smalloc(char *sharedVarName, uint32 size, uint8 isWritable)
{
  801aac:	55                   	push   %ebp
  801aad:	89 e5                	mov    %esp,%ebp
  801aaf:	83 ec 28             	sub    $0x28,%esp
  801ab2:	8b 45 10             	mov    0x10(%ebp),%eax
  801ab5:	88 45 e4             	mov    %al,-0x1c(%ebp)
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801ab8:	e8 9f fc ff ff       	call   80175c <InitializeUHeap>
	if (size == 0) return NULL ;
  801abd:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801ac1:	75 0a                	jne    801acd <smalloc+0x21>
  801ac3:	b8 00 00 00 00       	mov    $0x0,%eax
  801ac8:	e9 8d 00 00 00       	jmp    801b5a <smalloc+0xae>

	//This function should find the space of the required range
	// * ON 4KB BOUNDARY **** //
	//Use sys_isUHeapPlacementStrategyFIRSTFIT() to check the current strategy

	size = ROUNDUP(size, PAGE_SIZE);
  801acd:	c7 45 f4 00 10 00 00 	movl   $0x1000,-0xc(%ebp)
  801ad4:	8b 55 0c             	mov    0xc(%ebp),%edx
  801ad7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801ada:	01 d0                	add    %edx,%eax
  801adc:	48                   	dec    %eax
  801add:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801ae0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801ae3:	ba 00 00 00 00       	mov    $0x0,%edx
  801ae8:	f7 75 f4             	divl   -0xc(%ebp)
  801aeb:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801aee:	29 d0                	sub    %edx,%eax
  801af0:	89 45 0c             	mov    %eax,0xc(%ebp)
		if(sys_isUHeapPlacementStrategyFIRSTFIT())
  801af3:	e8 c9 06 00 00       	call   8021c1 <sys_isUHeapPlacementStrategyFIRSTFIT>
  801af8:	85 c0                	test   %eax,%eax
  801afa:	74 59                	je     801b55 <smalloc+0xa9>
		{
			struct MemBlock * v1=NULL;
  801afc:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
			v1= alloc_block_FF(size);
  801b03:	83 ec 0c             	sub    $0xc,%esp
  801b06:	ff 75 0c             	pushl  0xc(%ebp)
  801b09:	e8 b4 0c 00 00       	call   8027c2 <alloc_block_FF>
  801b0e:	83 c4 10             	add    $0x10,%esp
  801b11:	89 45 ec             	mov    %eax,-0x14(%ebp)
			if(v1==NULL)
  801b14:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  801b18:	75 07                	jne    801b21 <smalloc+0x75>
			{
				return NULL;
  801b1a:	b8 00 00 00 00       	mov    $0x0,%eax
  801b1f:	eb 39                	jmp    801b5a <smalloc+0xae>
			}
			else
			{
				int ret=sys_createSharedObject(sharedVarName,  size,  isWritable,(void*)v1->sva);
  801b21:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801b24:	8b 40 08             	mov    0x8(%eax),%eax
  801b27:	89 c2                	mov    %eax,%edx
  801b29:	0f b6 45 e4          	movzbl -0x1c(%ebp),%eax
  801b2d:	52                   	push   %edx
  801b2e:	50                   	push   %eax
  801b2f:	ff 75 0c             	pushl  0xc(%ebp)
  801b32:	ff 75 08             	pushl  0x8(%ebp)
  801b35:	e8 0c 04 00 00       	call   801f46 <sys_createSharedObject>
  801b3a:	83 c4 10             	add    $0x10,%esp
  801b3d:	89 45 e8             	mov    %eax,-0x18(%ebp)
				if(ret>=0)
  801b40:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  801b44:	78 08                	js     801b4e <smalloc+0xa2>
				{
					return (void*)v1->sva;
  801b46:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801b49:	8b 40 08             	mov    0x8(%eax),%eax
  801b4c:	eb 0c                	jmp    801b5a <smalloc+0xae>
				}
				else
				{
					return NULL;
  801b4e:	b8 00 00 00 00       	mov    $0x0,%eax
  801b53:	eb 05                	jmp    801b5a <smalloc+0xae>
				}
			}

		}
		return NULL;
  801b55:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801b5a:	c9                   	leave  
  801b5b:	c3                   	ret    

00801b5c <sget>:

//========================================
// [5] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
  801b5c:	55                   	push   %ebp
  801b5d:	89 e5                	mov    %esp,%ebp
  801b5f:	83 ec 18             	sub    $0x18,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801b62:	e8 f5 fb ff ff       	call   80175c <InitializeUHeap>

	//This function should find the space for sharing the variable
	// *** ON 4KB BOUNDARY ******** //

	//Use sys_isUHeapPlacementStrategyFIRSTFIT() to check the current strategy
	int ret=sys_getSizeOfSharedObject(ownerEnvID,sharedVarName);
  801b67:	83 ec 08             	sub    $0x8,%esp
  801b6a:	ff 75 0c             	pushl  0xc(%ebp)
  801b6d:	ff 75 08             	pushl  0x8(%ebp)
  801b70:	e8 fb 03 00 00       	call   801f70 <sys_getSizeOfSharedObject>
  801b75:	83 c4 10             	add    $0x10,%esp
  801b78:	89 45 f4             	mov    %eax,-0xc(%ebp)
	if(ret==0)
  801b7b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801b7f:	75 07                	jne    801b88 <sget+0x2c>
	{
		return NULL;
  801b81:	b8 00 00 00 00       	mov    $0x0,%eax
  801b86:	eb 64                	jmp    801bec <sget+0x90>
	}
	if(sys_isUHeapPlacementStrategyFIRSTFIT())
  801b88:	e8 34 06 00 00       	call   8021c1 <sys_isUHeapPlacementStrategyFIRSTFIT>
  801b8d:	85 c0                	test   %eax,%eax
  801b8f:	74 56                	je     801be7 <sget+0x8b>
	{
		struct MemBlock * v1=NULL;
  801b91:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
		v1= alloc_block_FF(ret);
  801b98:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801b9b:	83 ec 0c             	sub    $0xc,%esp
  801b9e:	50                   	push   %eax
  801b9f:	e8 1e 0c 00 00       	call   8027c2 <alloc_block_FF>
  801ba4:	83 c4 10             	add    $0x10,%esp
  801ba7:	89 45 f0             	mov    %eax,-0x10(%ebp)
		if(v1==NULL)
  801baa:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801bae:	75 07                	jne    801bb7 <sget+0x5b>
		{
		return NULL;
  801bb0:	b8 00 00 00 00       	mov    $0x0,%eax
  801bb5:	eb 35                	jmp    801bec <sget+0x90>
	    }
		else
		{
			int ret1=sys_getSharedObject(ownerEnvID,sharedVarName,(void*)v1->sva);
  801bb7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801bba:	8b 40 08             	mov    0x8(%eax),%eax
  801bbd:	83 ec 04             	sub    $0x4,%esp
  801bc0:	50                   	push   %eax
  801bc1:	ff 75 0c             	pushl  0xc(%ebp)
  801bc4:	ff 75 08             	pushl  0x8(%ebp)
  801bc7:	e8 c1 03 00 00       	call   801f8d <sys_getSharedObject>
  801bcc:	83 c4 10             	add    $0x10,%esp
  801bcf:	89 45 ec             	mov    %eax,-0x14(%ebp)
			if(ret1>=0)
  801bd2:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  801bd6:	78 08                	js     801be0 <sget+0x84>
			{
				return (void*)v1->sva;
  801bd8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801bdb:	8b 40 08             	mov    0x8(%eax),%eax
  801bde:	eb 0c                	jmp    801bec <sget+0x90>
			}
			else
			{
				return NULL;
  801be0:	b8 00 00 00 00       	mov    $0x0,%eax
  801be5:	eb 05                	jmp    801bec <sget+0x90>
			}
		}
	}
  return NULL;
  801be7:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801bec:	c9                   	leave  
  801bed:	c3                   	ret    

00801bee <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  801bee:	55                   	push   %ebp
  801bef:	89 e5                	mov    %esp,%ebp
  801bf1:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801bf4:	e8 63 fb ff ff       	call   80175c <InitializeUHeap>
	//==============================================================
	// [USER HEAP - USER SIDE] realloc
	// Write your code here, remove the panic and write your code
	panic("realloc() is not implemented yet...!!");
  801bf9:	83 ec 04             	sub    $0x4,%esp
  801bfc:	68 84 3d 80 00       	push   $0x803d84
  801c01:	68 0e 01 00 00       	push   $0x10e
  801c06:	68 53 3d 80 00       	push   $0x803d53
  801c0b:	e8 0e eb ff ff       	call   80071e <_panic>

00801c10 <sfree>:
//	use sys_freeSharedObject(...); which switches to the kernel mode,
//	calls freeSharedObject(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the freeSharedObject() function is empty, make sure to implement it.

void sfree(void* virtual_address)
{
  801c10:	55                   	push   %ebp
  801c11:	89 e5                	mov    %esp,%ebp
  801c13:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT MS3 - BONUS] [SHARING - USER SIDE] sfree()

	// Write your code here, remove the panic and write your code
	panic("sfree() is not implemented yet...!!");
  801c16:	83 ec 04             	sub    $0x4,%esp
  801c19:	68 ac 3d 80 00       	push   $0x803dac
  801c1e:	68 22 01 00 00       	push   $0x122
  801c23:	68 53 3d 80 00       	push   $0x803d53
  801c28:	e8 f1 ea ff ff       	call   80071e <_panic>

00801c2d <expand>:

//==================================================================================//
//========================== MODIFICATION FUNCTIONS ================================//
//==================================================================================//
void expand(uint32 newSize)
{
  801c2d:	55                   	push   %ebp
  801c2e:	89 e5                	mov    %esp,%ebp
  801c30:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801c33:	83 ec 04             	sub    $0x4,%esp
  801c36:	68 d0 3d 80 00       	push   $0x803dd0
  801c3b:	68 2d 01 00 00       	push   $0x12d
  801c40:	68 53 3d 80 00       	push   $0x803d53
  801c45:	e8 d4 ea ff ff       	call   80071e <_panic>

00801c4a <shrink>:

}
void shrink(uint32 newSize)
{
  801c4a:	55                   	push   %ebp
  801c4b:	89 e5                	mov    %esp,%ebp
  801c4d:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801c50:	83 ec 04             	sub    $0x4,%esp
  801c53:	68 d0 3d 80 00       	push   $0x803dd0
  801c58:	68 32 01 00 00       	push   $0x132
  801c5d:	68 53 3d 80 00       	push   $0x803d53
  801c62:	e8 b7 ea ff ff       	call   80071e <_panic>

00801c67 <freeHeap>:

}
void freeHeap(void* virtual_address)
{
  801c67:	55                   	push   %ebp
  801c68:	89 e5                	mov    %esp,%ebp
  801c6a:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801c6d:	83 ec 04             	sub    $0x4,%esp
  801c70:	68 d0 3d 80 00       	push   $0x803dd0
  801c75:	68 37 01 00 00       	push   $0x137
  801c7a:	68 53 3d 80 00       	push   $0x803d53
  801c7f:	e8 9a ea ff ff       	call   80071e <_panic>

00801c84 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  801c84:	55                   	push   %ebp
  801c85:	89 e5                	mov    %esp,%ebp
  801c87:	57                   	push   %edi
  801c88:	56                   	push   %esi
  801c89:	53                   	push   %ebx
  801c8a:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801c8d:	8b 45 08             	mov    0x8(%ebp),%eax
  801c90:	8b 55 0c             	mov    0xc(%ebp),%edx
  801c93:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801c96:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801c99:	8b 7d 18             	mov    0x18(%ebp),%edi
  801c9c:	8b 75 1c             	mov    0x1c(%ebp),%esi
  801c9f:	cd 30                	int    $0x30
  801ca1:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  801ca4:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801ca7:	83 c4 10             	add    $0x10,%esp
  801caa:	5b                   	pop    %ebx
  801cab:	5e                   	pop    %esi
  801cac:	5f                   	pop    %edi
  801cad:	5d                   	pop    %ebp
  801cae:	c3                   	ret    

00801caf <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  801caf:	55                   	push   %ebp
  801cb0:	89 e5                	mov    %esp,%ebp
  801cb2:	83 ec 04             	sub    $0x4,%esp
  801cb5:	8b 45 10             	mov    0x10(%ebp),%eax
  801cb8:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  801cbb:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801cbf:	8b 45 08             	mov    0x8(%ebp),%eax
  801cc2:	6a 00                	push   $0x0
  801cc4:	6a 00                	push   $0x0
  801cc6:	52                   	push   %edx
  801cc7:	ff 75 0c             	pushl  0xc(%ebp)
  801cca:	50                   	push   %eax
  801ccb:	6a 00                	push   $0x0
  801ccd:	e8 b2 ff ff ff       	call   801c84 <syscall>
  801cd2:	83 c4 18             	add    $0x18,%esp
}
  801cd5:	90                   	nop
  801cd6:	c9                   	leave  
  801cd7:	c3                   	ret    

00801cd8 <sys_cgetc>:

int
sys_cgetc(void)
{
  801cd8:	55                   	push   %ebp
  801cd9:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  801cdb:	6a 00                	push   $0x0
  801cdd:	6a 00                	push   $0x0
  801cdf:	6a 00                	push   $0x0
  801ce1:	6a 00                	push   $0x0
  801ce3:	6a 00                	push   $0x0
  801ce5:	6a 01                	push   $0x1
  801ce7:	e8 98 ff ff ff       	call   801c84 <syscall>
  801cec:	83 c4 18             	add    $0x18,%esp
}
  801cef:	c9                   	leave  
  801cf0:	c3                   	ret    

00801cf1 <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  801cf1:	55                   	push   %ebp
  801cf2:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  801cf4:	8b 55 0c             	mov    0xc(%ebp),%edx
  801cf7:	8b 45 08             	mov    0x8(%ebp),%eax
  801cfa:	6a 00                	push   $0x0
  801cfc:	6a 00                	push   $0x0
  801cfe:	6a 00                	push   $0x0
  801d00:	52                   	push   %edx
  801d01:	50                   	push   %eax
  801d02:	6a 05                	push   $0x5
  801d04:	e8 7b ff ff ff       	call   801c84 <syscall>
  801d09:	83 c4 18             	add    $0x18,%esp
}
  801d0c:	c9                   	leave  
  801d0d:	c3                   	ret    

00801d0e <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  801d0e:	55                   	push   %ebp
  801d0f:	89 e5                	mov    %esp,%ebp
  801d11:	56                   	push   %esi
  801d12:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  801d13:	8b 75 18             	mov    0x18(%ebp),%esi
  801d16:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801d19:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801d1c:	8b 55 0c             	mov    0xc(%ebp),%edx
  801d1f:	8b 45 08             	mov    0x8(%ebp),%eax
  801d22:	56                   	push   %esi
  801d23:	53                   	push   %ebx
  801d24:	51                   	push   %ecx
  801d25:	52                   	push   %edx
  801d26:	50                   	push   %eax
  801d27:	6a 06                	push   $0x6
  801d29:	e8 56 ff ff ff       	call   801c84 <syscall>
  801d2e:	83 c4 18             	add    $0x18,%esp
}
  801d31:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801d34:	5b                   	pop    %ebx
  801d35:	5e                   	pop    %esi
  801d36:	5d                   	pop    %ebp
  801d37:	c3                   	ret    

00801d38 <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  801d38:	55                   	push   %ebp
  801d39:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  801d3b:	8b 55 0c             	mov    0xc(%ebp),%edx
  801d3e:	8b 45 08             	mov    0x8(%ebp),%eax
  801d41:	6a 00                	push   $0x0
  801d43:	6a 00                	push   $0x0
  801d45:	6a 00                	push   $0x0
  801d47:	52                   	push   %edx
  801d48:	50                   	push   %eax
  801d49:	6a 07                	push   $0x7
  801d4b:	e8 34 ff ff ff       	call   801c84 <syscall>
  801d50:	83 c4 18             	add    $0x18,%esp
}
  801d53:	c9                   	leave  
  801d54:	c3                   	ret    

00801d55 <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  801d55:	55                   	push   %ebp
  801d56:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  801d58:	6a 00                	push   $0x0
  801d5a:	6a 00                	push   $0x0
  801d5c:	6a 00                	push   $0x0
  801d5e:	ff 75 0c             	pushl  0xc(%ebp)
  801d61:	ff 75 08             	pushl  0x8(%ebp)
  801d64:	6a 08                	push   $0x8
  801d66:	e8 19 ff ff ff       	call   801c84 <syscall>
  801d6b:	83 c4 18             	add    $0x18,%esp
}
  801d6e:	c9                   	leave  
  801d6f:	c3                   	ret    

00801d70 <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  801d70:	55                   	push   %ebp
  801d71:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  801d73:	6a 00                	push   $0x0
  801d75:	6a 00                	push   $0x0
  801d77:	6a 00                	push   $0x0
  801d79:	6a 00                	push   $0x0
  801d7b:	6a 00                	push   $0x0
  801d7d:	6a 09                	push   $0x9
  801d7f:	e8 00 ff ff ff       	call   801c84 <syscall>
  801d84:	83 c4 18             	add    $0x18,%esp
}
  801d87:	c9                   	leave  
  801d88:	c3                   	ret    

00801d89 <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  801d89:	55                   	push   %ebp
  801d8a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  801d8c:	6a 00                	push   $0x0
  801d8e:	6a 00                	push   $0x0
  801d90:	6a 00                	push   $0x0
  801d92:	6a 00                	push   $0x0
  801d94:	6a 00                	push   $0x0
  801d96:	6a 0a                	push   $0xa
  801d98:	e8 e7 fe ff ff       	call   801c84 <syscall>
  801d9d:	83 c4 18             	add    $0x18,%esp
}
  801da0:	c9                   	leave  
  801da1:	c3                   	ret    

00801da2 <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  801da2:	55                   	push   %ebp
  801da3:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  801da5:	6a 00                	push   $0x0
  801da7:	6a 00                	push   $0x0
  801da9:	6a 00                	push   $0x0
  801dab:	6a 00                	push   $0x0
  801dad:	6a 00                	push   $0x0
  801daf:	6a 0b                	push   $0xb
  801db1:	e8 ce fe ff ff       	call   801c84 <syscall>
  801db6:	83 c4 18             	add    $0x18,%esp
}
  801db9:	c9                   	leave  
  801dba:	c3                   	ret    

00801dbb <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  801dbb:	55                   	push   %ebp
  801dbc:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  801dbe:	6a 00                	push   $0x0
  801dc0:	6a 00                	push   $0x0
  801dc2:	6a 00                	push   $0x0
  801dc4:	ff 75 0c             	pushl  0xc(%ebp)
  801dc7:	ff 75 08             	pushl  0x8(%ebp)
  801dca:	6a 0f                	push   $0xf
  801dcc:	e8 b3 fe ff ff       	call   801c84 <syscall>
  801dd1:	83 c4 18             	add    $0x18,%esp
	return;
  801dd4:	90                   	nop
}
  801dd5:	c9                   	leave  
  801dd6:	c3                   	ret    

00801dd7 <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  801dd7:	55                   	push   %ebp
  801dd8:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  801dda:	6a 00                	push   $0x0
  801ddc:	6a 00                	push   $0x0
  801dde:	6a 00                	push   $0x0
  801de0:	ff 75 0c             	pushl  0xc(%ebp)
  801de3:	ff 75 08             	pushl  0x8(%ebp)
  801de6:	6a 10                	push   $0x10
  801de8:	e8 97 fe ff ff       	call   801c84 <syscall>
  801ded:	83 c4 18             	add    $0x18,%esp
	return ;
  801df0:	90                   	nop
}
  801df1:	c9                   	leave  
  801df2:	c3                   	ret    

00801df3 <sys_allocate_chunk>:

void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  801df3:	55                   	push   %ebp
  801df4:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  801df6:	6a 00                	push   $0x0
  801df8:	6a 00                	push   $0x0
  801dfa:	ff 75 10             	pushl  0x10(%ebp)
  801dfd:	ff 75 0c             	pushl  0xc(%ebp)
  801e00:	ff 75 08             	pushl  0x8(%ebp)
  801e03:	6a 11                	push   $0x11
  801e05:	e8 7a fe ff ff       	call   801c84 <syscall>
  801e0a:	83 c4 18             	add    $0x18,%esp
	return ;
  801e0d:	90                   	nop
}
  801e0e:	c9                   	leave  
  801e0f:	c3                   	ret    

00801e10 <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  801e10:	55                   	push   %ebp
  801e11:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  801e13:	6a 00                	push   $0x0
  801e15:	6a 00                	push   $0x0
  801e17:	6a 00                	push   $0x0
  801e19:	6a 00                	push   $0x0
  801e1b:	6a 00                	push   $0x0
  801e1d:	6a 0c                	push   $0xc
  801e1f:	e8 60 fe ff ff       	call   801c84 <syscall>
  801e24:	83 c4 18             	add    $0x18,%esp
}
  801e27:	c9                   	leave  
  801e28:	c3                   	ret    

00801e29 <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  801e29:	55                   	push   %ebp
  801e2a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  801e2c:	6a 00                	push   $0x0
  801e2e:	6a 00                	push   $0x0
  801e30:	6a 00                	push   $0x0
  801e32:	6a 00                	push   $0x0
  801e34:	ff 75 08             	pushl  0x8(%ebp)
  801e37:	6a 0d                	push   $0xd
  801e39:	e8 46 fe ff ff       	call   801c84 <syscall>
  801e3e:	83 c4 18             	add    $0x18,%esp
}
  801e41:	c9                   	leave  
  801e42:	c3                   	ret    

00801e43 <sys_scarce_memory>:

void sys_scarce_memory()
{
  801e43:	55                   	push   %ebp
  801e44:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  801e46:	6a 00                	push   $0x0
  801e48:	6a 00                	push   $0x0
  801e4a:	6a 00                	push   $0x0
  801e4c:	6a 00                	push   $0x0
  801e4e:	6a 00                	push   $0x0
  801e50:	6a 0e                	push   $0xe
  801e52:	e8 2d fe ff ff       	call   801c84 <syscall>
  801e57:	83 c4 18             	add    $0x18,%esp
}
  801e5a:	90                   	nop
  801e5b:	c9                   	leave  
  801e5c:	c3                   	ret    

00801e5d <sys_disable_interrupt>:

//NEW !! 2012...
void
sys_disable_interrupt()
{
  801e5d:	55                   	push   %ebp
  801e5e:	89 e5                	mov    %esp,%ebp
	syscall(SYS_disableINTR,0, 0, 0, 0, 0);
  801e60:	6a 00                	push   $0x0
  801e62:	6a 00                	push   $0x0
  801e64:	6a 00                	push   $0x0
  801e66:	6a 00                	push   $0x0
  801e68:	6a 00                	push   $0x0
  801e6a:	6a 13                	push   $0x13
  801e6c:	e8 13 fe ff ff       	call   801c84 <syscall>
  801e71:	83 c4 18             	add    $0x18,%esp
}
  801e74:	90                   	nop
  801e75:	c9                   	leave  
  801e76:	c3                   	ret    

00801e77 <sys_enable_interrupt>:


void
sys_enable_interrupt()
{
  801e77:	55                   	push   %ebp
  801e78:	89 e5                	mov    %esp,%ebp
	syscall(SYS_enableINTR,0, 0, 0, 0, 0);
  801e7a:	6a 00                	push   $0x0
  801e7c:	6a 00                	push   $0x0
  801e7e:	6a 00                	push   $0x0
  801e80:	6a 00                	push   $0x0
  801e82:	6a 00                	push   $0x0
  801e84:	6a 14                	push   $0x14
  801e86:	e8 f9 fd ff ff       	call   801c84 <syscall>
  801e8b:	83 c4 18             	add    $0x18,%esp
}
  801e8e:	90                   	nop
  801e8f:	c9                   	leave  
  801e90:	c3                   	ret    

00801e91 <sys_cputc>:


void
sys_cputc(const char c)
{
  801e91:	55                   	push   %ebp
  801e92:	89 e5                	mov    %esp,%ebp
  801e94:	83 ec 04             	sub    $0x4,%esp
  801e97:	8b 45 08             	mov    0x8(%ebp),%eax
  801e9a:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  801e9d:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801ea1:	6a 00                	push   $0x0
  801ea3:	6a 00                	push   $0x0
  801ea5:	6a 00                	push   $0x0
  801ea7:	6a 00                	push   $0x0
  801ea9:	50                   	push   %eax
  801eaa:	6a 15                	push   $0x15
  801eac:	e8 d3 fd ff ff       	call   801c84 <syscall>
  801eb1:	83 c4 18             	add    $0x18,%esp
}
  801eb4:	90                   	nop
  801eb5:	c9                   	leave  
  801eb6:	c3                   	ret    

00801eb7 <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  801eb7:	55                   	push   %ebp
  801eb8:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  801eba:	6a 00                	push   $0x0
  801ebc:	6a 00                	push   $0x0
  801ebe:	6a 00                	push   $0x0
  801ec0:	6a 00                	push   $0x0
  801ec2:	6a 00                	push   $0x0
  801ec4:	6a 16                	push   $0x16
  801ec6:	e8 b9 fd ff ff       	call   801c84 <syscall>
  801ecb:	83 c4 18             	add    $0x18,%esp
}
  801ece:	90                   	nop
  801ecf:	c9                   	leave  
  801ed0:	c3                   	ret    

00801ed1 <sys_createSemaphore>:

int
sys_createSemaphore(char* semaphoreName, uint32 initialValue)
{
  801ed1:	55                   	push   %ebp
  801ed2:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_semaphore,(uint32)semaphoreName, (uint32)initialValue, 0, 0, 0);
  801ed4:	8b 45 08             	mov    0x8(%ebp),%eax
  801ed7:	6a 00                	push   $0x0
  801ed9:	6a 00                	push   $0x0
  801edb:	6a 00                	push   $0x0
  801edd:	ff 75 0c             	pushl  0xc(%ebp)
  801ee0:	50                   	push   %eax
  801ee1:	6a 17                	push   $0x17
  801ee3:	e8 9c fd ff ff       	call   801c84 <syscall>
  801ee8:	83 c4 18             	add    $0x18,%esp
}
  801eeb:	c9                   	leave  
  801eec:	c3                   	ret    

00801eed <sys_getSemaphoreValue>:

int
sys_getSemaphoreValue(int32 ownerEnvID, char* semaphoreName)
{
  801eed:	55                   	push   %ebp
  801eee:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_semaphore_value,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801ef0:	8b 55 0c             	mov    0xc(%ebp),%edx
  801ef3:	8b 45 08             	mov    0x8(%ebp),%eax
  801ef6:	6a 00                	push   $0x0
  801ef8:	6a 00                	push   $0x0
  801efa:	6a 00                	push   $0x0
  801efc:	52                   	push   %edx
  801efd:	50                   	push   %eax
  801efe:	6a 1a                	push   $0x1a
  801f00:	e8 7f fd ff ff       	call   801c84 <syscall>
  801f05:	83 c4 18             	add    $0x18,%esp
}
  801f08:	c9                   	leave  
  801f09:	c3                   	ret    

00801f0a <sys_waitSemaphore>:

void
sys_waitSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  801f0a:	55                   	push   %ebp
  801f0b:	89 e5                	mov    %esp,%ebp
	syscall(SYS_wait_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801f0d:	8b 55 0c             	mov    0xc(%ebp),%edx
  801f10:	8b 45 08             	mov    0x8(%ebp),%eax
  801f13:	6a 00                	push   $0x0
  801f15:	6a 00                	push   $0x0
  801f17:	6a 00                	push   $0x0
  801f19:	52                   	push   %edx
  801f1a:	50                   	push   %eax
  801f1b:	6a 18                	push   $0x18
  801f1d:	e8 62 fd ff ff       	call   801c84 <syscall>
  801f22:	83 c4 18             	add    $0x18,%esp
}
  801f25:	90                   	nop
  801f26:	c9                   	leave  
  801f27:	c3                   	ret    

00801f28 <sys_signalSemaphore>:

void
sys_signalSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  801f28:	55                   	push   %ebp
  801f29:	89 e5                	mov    %esp,%ebp
	syscall(SYS_signal_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801f2b:	8b 55 0c             	mov    0xc(%ebp),%edx
  801f2e:	8b 45 08             	mov    0x8(%ebp),%eax
  801f31:	6a 00                	push   $0x0
  801f33:	6a 00                	push   $0x0
  801f35:	6a 00                	push   $0x0
  801f37:	52                   	push   %edx
  801f38:	50                   	push   %eax
  801f39:	6a 19                	push   $0x19
  801f3b:	e8 44 fd ff ff       	call   801c84 <syscall>
  801f40:	83 c4 18             	add    $0x18,%esp
}
  801f43:	90                   	nop
  801f44:	c9                   	leave  
  801f45:	c3                   	ret    

00801f46 <sys_createSharedObject>:

int
sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  801f46:	55                   	push   %ebp
  801f47:	89 e5                	mov    %esp,%ebp
  801f49:	83 ec 04             	sub    $0x4,%esp
  801f4c:	8b 45 10             	mov    0x10(%ebp),%eax
  801f4f:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  801f52:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801f55:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801f59:	8b 45 08             	mov    0x8(%ebp),%eax
  801f5c:	6a 00                	push   $0x0
  801f5e:	51                   	push   %ecx
  801f5f:	52                   	push   %edx
  801f60:	ff 75 0c             	pushl  0xc(%ebp)
  801f63:	50                   	push   %eax
  801f64:	6a 1b                	push   $0x1b
  801f66:	e8 19 fd ff ff       	call   801c84 <syscall>
  801f6b:	83 c4 18             	add    $0x18,%esp
}
  801f6e:	c9                   	leave  
  801f6f:	c3                   	ret    

00801f70 <sys_getSizeOfSharedObject>:

//2017:
int
sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  801f70:	55                   	push   %ebp
  801f71:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  801f73:	8b 55 0c             	mov    0xc(%ebp),%edx
  801f76:	8b 45 08             	mov    0x8(%ebp),%eax
  801f79:	6a 00                	push   $0x0
  801f7b:	6a 00                	push   $0x0
  801f7d:	6a 00                	push   $0x0
  801f7f:	52                   	push   %edx
  801f80:	50                   	push   %eax
  801f81:	6a 1c                	push   $0x1c
  801f83:	e8 fc fc ff ff       	call   801c84 <syscall>
  801f88:	83 c4 18             	add    $0x18,%esp
}
  801f8b:	c9                   	leave  
  801f8c:	c3                   	ret    

00801f8d <sys_getSharedObject>:
//==========

int
sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  801f8d:	55                   	push   %ebp
  801f8e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  801f90:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801f93:	8b 55 0c             	mov    0xc(%ebp),%edx
  801f96:	8b 45 08             	mov    0x8(%ebp),%eax
  801f99:	6a 00                	push   $0x0
  801f9b:	6a 00                	push   $0x0
  801f9d:	51                   	push   %ecx
  801f9e:	52                   	push   %edx
  801f9f:	50                   	push   %eax
  801fa0:	6a 1d                	push   $0x1d
  801fa2:	e8 dd fc ff ff       	call   801c84 <syscall>
  801fa7:	83 c4 18             	add    $0x18,%esp
}
  801faa:	c9                   	leave  
  801fab:	c3                   	ret    

00801fac <sys_freeSharedObject>:

int
sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  801fac:	55                   	push   %ebp
  801fad:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  801faf:	8b 55 0c             	mov    0xc(%ebp),%edx
  801fb2:	8b 45 08             	mov    0x8(%ebp),%eax
  801fb5:	6a 00                	push   $0x0
  801fb7:	6a 00                	push   $0x0
  801fb9:	6a 00                	push   $0x0
  801fbb:	52                   	push   %edx
  801fbc:	50                   	push   %eax
  801fbd:	6a 1e                	push   $0x1e
  801fbf:	e8 c0 fc ff ff       	call   801c84 <syscall>
  801fc4:	83 c4 18             	add    $0x18,%esp
}
  801fc7:	c9                   	leave  
  801fc8:	c3                   	ret    

00801fc9 <sys_getMaxShares>:

uint32 	sys_getMaxShares()
{
  801fc9:	55                   	push   %ebp
  801fca:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_max_shares,0, 0, 0, 0, 0);
  801fcc:	6a 00                	push   $0x0
  801fce:	6a 00                	push   $0x0
  801fd0:	6a 00                	push   $0x0
  801fd2:	6a 00                	push   $0x0
  801fd4:	6a 00                	push   $0x0
  801fd6:	6a 1f                	push   $0x1f
  801fd8:	e8 a7 fc ff ff       	call   801c84 <syscall>
  801fdd:	83 c4 18             	add    $0x18,%esp
}
  801fe0:	c9                   	leave  
  801fe1:	c3                   	ret    

00801fe2 <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  801fe2:	55                   	push   %ebp
  801fe3:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  801fe5:	8b 45 08             	mov    0x8(%ebp),%eax
  801fe8:	6a 00                	push   $0x0
  801fea:	ff 75 14             	pushl  0x14(%ebp)
  801fed:	ff 75 10             	pushl  0x10(%ebp)
  801ff0:	ff 75 0c             	pushl  0xc(%ebp)
  801ff3:	50                   	push   %eax
  801ff4:	6a 20                	push   $0x20
  801ff6:	e8 89 fc ff ff       	call   801c84 <syscall>
  801ffb:	83 c4 18             	add    $0x18,%esp
}
  801ffe:	c9                   	leave  
  801fff:	c3                   	ret    

00802000 <sys_run_env>:

void
sys_run_env(int32 envId)
{
  802000:	55                   	push   %ebp
  802001:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  802003:	8b 45 08             	mov    0x8(%ebp),%eax
  802006:	6a 00                	push   $0x0
  802008:	6a 00                	push   $0x0
  80200a:	6a 00                	push   $0x0
  80200c:	6a 00                	push   $0x0
  80200e:	50                   	push   %eax
  80200f:	6a 21                	push   $0x21
  802011:	e8 6e fc ff ff       	call   801c84 <syscall>
  802016:	83 c4 18             	add    $0x18,%esp
}
  802019:	90                   	nop
  80201a:	c9                   	leave  
  80201b:	c3                   	ret    

0080201c <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  80201c:	55                   	push   %ebp
  80201d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  80201f:	8b 45 08             	mov    0x8(%ebp),%eax
  802022:	6a 00                	push   $0x0
  802024:	6a 00                	push   $0x0
  802026:	6a 00                	push   $0x0
  802028:	6a 00                	push   $0x0
  80202a:	50                   	push   %eax
  80202b:	6a 22                	push   $0x22
  80202d:	e8 52 fc ff ff       	call   801c84 <syscall>
  802032:	83 c4 18             	add    $0x18,%esp
}
  802035:	c9                   	leave  
  802036:	c3                   	ret    

00802037 <sys_getenvid>:

int32 sys_getenvid(void)
{
  802037:	55                   	push   %ebp
  802038:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  80203a:	6a 00                	push   $0x0
  80203c:	6a 00                	push   $0x0
  80203e:	6a 00                	push   $0x0
  802040:	6a 00                	push   $0x0
  802042:	6a 00                	push   $0x0
  802044:	6a 02                	push   $0x2
  802046:	e8 39 fc ff ff       	call   801c84 <syscall>
  80204b:	83 c4 18             	add    $0x18,%esp
}
  80204e:	c9                   	leave  
  80204f:	c3                   	ret    

00802050 <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  802050:	55                   	push   %ebp
  802051:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  802053:	6a 00                	push   $0x0
  802055:	6a 00                	push   $0x0
  802057:	6a 00                	push   $0x0
  802059:	6a 00                	push   $0x0
  80205b:	6a 00                	push   $0x0
  80205d:	6a 03                	push   $0x3
  80205f:	e8 20 fc ff ff       	call   801c84 <syscall>
  802064:	83 c4 18             	add    $0x18,%esp
}
  802067:	c9                   	leave  
  802068:	c3                   	ret    

00802069 <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  802069:	55                   	push   %ebp
  80206a:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  80206c:	6a 00                	push   $0x0
  80206e:	6a 00                	push   $0x0
  802070:	6a 00                	push   $0x0
  802072:	6a 00                	push   $0x0
  802074:	6a 00                	push   $0x0
  802076:	6a 04                	push   $0x4
  802078:	e8 07 fc ff ff       	call   801c84 <syscall>
  80207d:	83 c4 18             	add    $0x18,%esp
}
  802080:	c9                   	leave  
  802081:	c3                   	ret    

00802082 <sys_exit_env>:


void sys_exit_env(void)
{
  802082:	55                   	push   %ebp
  802083:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  802085:	6a 00                	push   $0x0
  802087:	6a 00                	push   $0x0
  802089:	6a 00                	push   $0x0
  80208b:	6a 00                	push   $0x0
  80208d:	6a 00                	push   $0x0
  80208f:	6a 23                	push   $0x23
  802091:	e8 ee fb ff ff       	call   801c84 <syscall>
  802096:	83 c4 18             	add    $0x18,%esp
}
  802099:	90                   	nop
  80209a:	c9                   	leave  
  80209b:	c3                   	ret    

0080209c <sys_get_virtual_time>:


struct uint64
sys_get_virtual_time()
{
  80209c:	55                   	push   %ebp
  80209d:	89 e5                	mov    %esp,%ebp
  80209f:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  8020a2:	8d 45 f8             	lea    -0x8(%ebp),%eax
  8020a5:	8d 50 04             	lea    0x4(%eax),%edx
  8020a8:	8d 45 f8             	lea    -0x8(%ebp),%eax
  8020ab:	6a 00                	push   $0x0
  8020ad:	6a 00                	push   $0x0
  8020af:	6a 00                	push   $0x0
  8020b1:	52                   	push   %edx
  8020b2:	50                   	push   %eax
  8020b3:	6a 24                	push   $0x24
  8020b5:	e8 ca fb ff ff       	call   801c84 <syscall>
  8020ba:	83 c4 18             	add    $0x18,%esp
	return result;
  8020bd:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8020c0:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8020c3:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8020c6:	89 01                	mov    %eax,(%ecx)
  8020c8:	89 51 04             	mov    %edx,0x4(%ecx)
}
  8020cb:	8b 45 08             	mov    0x8(%ebp),%eax
  8020ce:	c9                   	leave  
  8020cf:	c2 04 00             	ret    $0x4

008020d2 <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  8020d2:	55                   	push   %ebp
  8020d3:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  8020d5:	6a 00                	push   $0x0
  8020d7:	6a 00                	push   $0x0
  8020d9:	ff 75 10             	pushl  0x10(%ebp)
  8020dc:	ff 75 0c             	pushl  0xc(%ebp)
  8020df:	ff 75 08             	pushl  0x8(%ebp)
  8020e2:	6a 12                	push   $0x12
  8020e4:	e8 9b fb ff ff       	call   801c84 <syscall>
  8020e9:	83 c4 18             	add    $0x18,%esp
	return ;
  8020ec:	90                   	nop
}
  8020ed:	c9                   	leave  
  8020ee:	c3                   	ret    

008020ef <sys_rcr2>:
uint32 sys_rcr2()
{
  8020ef:	55                   	push   %ebp
  8020f0:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  8020f2:	6a 00                	push   $0x0
  8020f4:	6a 00                	push   $0x0
  8020f6:	6a 00                	push   $0x0
  8020f8:	6a 00                	push   $0x0
  8020fa:	6a 00                	push   $0x0
  8020fc:	6a 25                	push   $0x25
  8020fe:	e8 81 fb ff ff       	call   801c84 <syscall>
  802103:	83 c4 18             	add    $0x18,%esp
}
  802106:	c9                   	leave  
  802107:	c3                   	ret    

00802108 <sys_bypassPageFault>:
void sys_bypassPageFault(uint8 instrLength)
{
  802108:	55                   	push   %ebp
  802109:	89 e5                	mov    %esp,%ebp
  80210b:	83 ec 04             	sub    $0x4,%esp
  80210e:	8b 45 08             	mov    0x8(%ebp),%eax
  802111:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  802114:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  802118:	6a 00                	push   $0x0
  80211a:	6a 00                	push   $0x0
  80211c:	6a 00                	push   $0x0
  80211e:	6a 00                	push   $0x0
  802120:	50                   	push   %eax
  802121:	6a 26                	push   $0x26
  802123:	e8 5c fb ff ff       	call   801c84 <syscall>
  802128:	83 c4 18             	add    $0x18,%esp
	return ;
  80212b:	90                   	nop
}
  80212c:	c9                   	leave  
  80212d:	c3                   	ret    

0080212e <rsttst>:
void rsttst()
{
  80212e:	55                   	push   %ebp
  80212f:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  802131:	6a 00                	push   $0x0
  802133:	6a 00                	push   $0x0
  802135:	6a 00                	push   $0x0
  802137:	6a 00                	push   $0x0
  802139:	6a 00                	push   $0x0
  80213b:	6a 28                	push   $0x28
  80213d:	e8 42 fb ff ff       	call   801c84 <syscall>
  802142:	83 c4 18             	add    $0x18,%esp
	return ;
  802145:	90                   	nop
}
  802146:	c9                   	leave  
  802147:	c3                   	ret    

00802148 <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  802148:	55                   	push   %ebp
  802149:	89 e5                	mov    %esp,%ebp
  80214b:	83 ec 04             	sub    $0x4,%esp
  80214e:	8b 45 14             	mov    0x14(%ebp),%eax
  802151:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  802154:	8b 55 18             	mov    0x18(%ebp),%edx
  802157:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  80215b:	52                   	push   %edx
  80215c:	50                   	push   %eax
  80215d:	ff 75 10             	pushl  0x10(%ebp)
  802160:	ff 75 0c             	pushl  0xc(%ebp)
  802163:	ff 75 08             	pushl  0x8(%ebp)
  802166:	6a 27                	push   $0x27
  802168:	e8 17 fb ff ff       	call   801c84 <syscall>
  80216d:	83 c4 18             	add    $0x18,%esp
	return ;
  802170:	90                   	nop
}
  802171:	c9                   	leave  
  802172:	c3                   	ret    

00802173 <chktst>:
void chktst(uint32 n)
{
  802173:	55                   	push   %ebp
  802174:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  802176:	6a 00                	push   $0x0
  802178:	6a 00                	push   $0x0
  80217a:	6a 00                	push   $0x0
  80217c:	6a 00                	push   $0x0
  80217e:	ff 75 08             	pushl  0x8(%ebp)
  802181:	6a 29                	push   $0x29
  802183:	e8 fc fa ff ff       	call   801c84 <syscall>
  802188:	83 c4 18             	add    $0x18,%esp
	return ;
  80218b:	90                   	nop
}
  80218c:	c9                   	leave  
  80218d:	c3                   	ret    

0080218e <inctst>:

void inctst()
{
  80218e:	55                   	push   %ebp
  80218f:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  802191:	6a 00                	push   $0x0
  802193:	6a 00                	push   $0x0
  802195:	6a 00                	push   $0x0
  802197:	6a 00                	push   $0x0
  802199:	6a 00                	push   $0x0
  80219b:	6a 2a                	push   $0x2a
  80219d:	e8 e2 fa ff ff       	call   801c84 <syscall>
  8021a2:	83 c4 18             	add    $0x18,%esp
	return ;
  8021a5:	90                   	nop
}
  8021a6:	c9                   	leave  
  8021a7:	c3                   	ret    

008021a8 <gettst>:
uint32 gettst()
{
  8021a8:	55                   	push   %ebp
  8021a9:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  8021ab:	6a 00                	push   $0x0
  8021ad:	6a 00                	push   $0x0
  8021af:	6a 00                	push   $0x0
  8021b1:	6a 00                	push   $0x0
  8021b3:	6a 00                	push   $0x0
  8021b5:	6a 2b                	push   $0x2b
  8021b7:	e8 c8 fa ff ff       	call   801c84 <syscall>
  8021bc:	83 c4 18             	add    $0x18,%esp
}
  8021bf:	c9                   	leave  
  8021c0:	c3                   	ret    

008021c1 <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  8021c1:	55                   	push   %ebp
  8021c2:	89 e5                	mov    %esp,%ebp
  8021c4:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8021c7:	6a 00                	push   $0x0
  8021c9:	6a 00                	push   $0x0
  8021cb:	6a 00                	push   $0x0
  8021cd:	6a 00                	push   $0x0
  8021cf:	6a 00                	push   $0x0
  8021d1:	6a 2c                	push   $0x2c
  8021d3:	e8 ac fa ff ff       	call   801c84 <syscall>
  8021d8:	83 c4 18             	add    $0x18,%esp
  8021db:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  8021de:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  8021e2:	75 07                	jne    8021eb <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  8021e4:	b8 01 00 00 00       	mov    $0x1,%eax
  8021e9:	eb 05                	jmp    8021f0 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  8021eb:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8021f0:	c9                   	leave  
  8021f1:	c3                   	ret    

008021f2 <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  8021f2:	55                   	push   %ebp
  8021f3:	89 e5                	mov    %esp,%ebp
  8021f5:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8021f8:	6a 00                	push   $0x0
  8021fa:	6a 00                	push   $0x0
  8021fc:	6a 00                	push   $0x0
  8021fe:	6a 00                	push   $0x0
  802200:	6a 00                	push   $0x0
  802202:	6a 2c                	push   $0x2c
  802204:	e8 7b fa ff ff       	call   801c84 <syscall>
  802209:	83 c4 18             	add    $0x18,%esp
  80220c:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  80220f:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  802213:	75 07                	jne    80221c <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  802215:	b8 01 00 00 00       	mov    $0x1,%eax
  80221a:	eb 05                	jmp    802221 <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  80221c:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802221:	c9                   	leave  
  802222:	c3                   	ret    

00802223 <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  802223:	55                   	push   %ebp
  802224:	89 e5                	mov    %esp,%ebp
  802226:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  802229:	6a 00                	push   $0x0
  80222b:	6a 00                	push   $0x0
  80222d:	6a 00                	push   $0x0
  80222f:	6a 00                	push   $0x0
  802231:	6a 00                	push   $0x0
  802233:	6a 2c                	push   $0x2c
  802235:	e8 4a fa ff ff       	call   801c84 <syscall>
  80223a:	83 c4 18             	add    $0x18,%esp
  80223d:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  802240:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  802244:	75 07                	jne    80224d <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  802246:	b8 01 00 00 00       	mov    $0x1,%eax
  80224b:	eb 05                	jmp    802252 <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  80224d:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802252:	c9                   	leave  
  802253:	c3                   	ret    

00802254 <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  802254:	55                   	push   %ebp
  802255:	89 e5                	mov    %esp,%ebp
  802257:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  80225a:	6a 00                	push   $0x0
  80225c:	6a 00                	push   $0x0
  80225e:	6a 00                	push   $0x0
  802260:	6a 00                	push   $0x0
  802262:	6a 00                	push   $0x0
  802264:	6a 2c                	push   $0x2c
  802266:	e8 19 fa ff ff       	call   801c84 <syscall>
  80226b:	83 c4 18             	add    $0x18,%esp
  80226e:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  802271:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  802275:	75 07                	jne    80227e <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  802277:	b8 01 00 00 00       	mov    $0x1,%eax
  80227c:	eb 05                	jmp    802283 <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  80227e:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802283:	c9                   	leave  
  802284:	c3                   	ret    

00802285 <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  802285:	55                   	push   %ebp
  802286:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  802288:	6a 00                	push   $0x0
  80228a:	6a 00                	push   $0x0
  80228c:	6a 00                	push   $0x0
  80228e:	6a 00                	push   $0x0
  802290:	ff 75 08             	pushl  0x8(%ebp)
  802293:	6a 2d                	push   $0x2d
  802295:	e8 ea f9 ff ff       	call   801c84 <syscall>
  80229a:	83 c4 18             	add    $0x18,%esp
	return ;
  80229d:	90                   	nop
}
  80229e:	c9                   	leave  
  80229f:	c3                   	ret    

008022a0 <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  8022a0:	55                   	push   %ebp
  8022a1:	89 e5                	mov    %esp,%ebp
  8022a3:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  8022a4:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8022a7:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8022aa:	8b 55 0c             	mov    0xc(%ebp),%edx
  8022ad:	8b 45 08             	mov    0x8(%ebp),%eax
  8022b0:	6a 00                	push   $0x0
  8022b2:	53                   	push   %ebx
  8022b3:	51                   	push   %ecx
  8022b4:	52                   	push   %edx
  8022b5:	50                   	push   %eax
  8022b6:	6a 2e                	push   $0x2e
  8022b8:	e8 c7 f9 ff ff       	call   801c84 <syscall>
  8022bd:	83 c4 18             	add    $0x18,%esp
}
  8022c0:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8022c3:	c9                   	leave  
  8022c4:	c3                   	ret    

008022c5 <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  8022c5:	55                   	push   %ebp
  8022c6:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  8022c8:	8b 55 0c             	mov    0xc(%ebp),%edx
  8022cb:	8b 45 08             	mov    0x8(%ebp),%eax
  8022ce:	6a 00                	push   $0x0
  8022d0:	6a 00                	push   $0x0
  8022d2:	6a 00                	push   $0x0
  8022d4:	52                   	push   %edx
  8022d5:	50                   	push   %eax
  8022d6:	6a 2f                	push   $0x2f
  8022d8:	e8 a7 f9 ff ff       	call   801c84 <syscall>
  8022dd:	83 c4 18             	add    $0x18,%esp
}
  8022e0:	c9                   	leave  
  8022e1:	c3                   	ret    

008022e2 <print_mem_block_lists>:
//===========================
// PRINT MEM BLOCK LISTS:
//===========================

void print_mem_block_lists()
{
  8022e2:	55                   	push   %ebp
  8022e3:	89 e5                	mov    %esp,%ebp
  8022e5:	83 ec 18             	sub    $0x18,%esp
	cprintf("\n=========================================\n");
  8022e8:	83 ec 0c             	sub    $0xc,%esp
  8022eb:	68 e0 3d 80 00       	push   $0x803de0
  8022f0:	e8 dd e6 ff ff       	call   8009d2 <cprintf>
  8022f5:	83 c4 10             	add    $0x10,%esp
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
  8022f8:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nFreeMemBlocksList:\n");
  8022ff:	83 ec 0c             	sub    $0xc,%esp
  802302:	68 0c 3e 80 00       	push   $0x803e0c
  802307:	e8 c6 e6 ff ff       	call   8009d2 <cprintf>
  80230c:	83 c4 10             	add    $0x10,%esp
	uint8 sorted = 1 ;
  80230f:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &FreeMemBlocksList)
  802313:	a1 38 41 80 00       	mov    0x804138,%eax
  802318:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80231b:	eb 56                	jmp    802373 <print_mem_block_lists+0x91>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  80231d:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802321:	74 1c                	je     80233f <print_mem_block_lists+0x5d>
  802323:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802326:	8b 50 08             	mov    0x8(%eax),%edx
  802329:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80232c:	8b 48 08             	mov    0x8(%eax),%ecx
  80232f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802332:	8b 40 0c             	mov    0xc(%eax),%eax
  802335:	01 c8                	add    %ecx,%eax
  802337:	39 c2                	cmp    %eax,%edx
  802339:	73 04                	jae    80233f <print_mem_block_lists+0x5d>
			sorted = 0 ;
  80233b:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  80233f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802342:	8b 50 08             	mov    0x8(%eax),%edx
  802345:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802348:	8b 40 0c             	mov    0xc(%eax),%eax
  80234b:	01 c2                	add    %eax,%edx
  80234d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802350:	8b 40 08             	mov    0x8(%eax),%eax
  802353:	83 ec 04             	sub    $0x4,%esp
  802356:	52                   	push   %edx
  802357:	50                   	push   %eax
  802358:	68 21 3e 80 00       	push   $0x803e21
  80235d:	e8 70 e6 ff ff       	call   8009d2 <cprintf>
  802362:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  802365:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802368:	89 45 f0             	mov    %eax,-0x10(%ebp)
	cprintf("\n=========================================\n");
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
	cprintf("\nFreeMemBlocksList:\n");
	uint8 sorted = 1 ;
	LIST_FOREACH(blk, &FreeMemBlocksList)
  80236b:	a1 40 41 80 00       	mov    0x804140,%eax
  802370:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802373:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802377:	74 07                	je     802380 <print_mem_block_lists+0x9e>
  802379:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80237c:	8b 00                	mov    (%eax),%eax
  80237e:	eb 05                	jmp    802385 <print_mem_block_lists+0xa3>
  802380:	b8 00 00 00 00       	mov    $0x0,%eax
  802385:	a3 40 41 80 00       	mov    %eax,0x804140
  80238a:	a1 40 41 80 00       	mov    0x804140,%eax
  80238f:	85 c0                	test   %eax,%eax
  802391:	75 8a                	jne    80231d <print_mem_block_lists+0x3b>
  802393:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802397:	75 84                	jne    80231d <print_mem_block_lists+0x3b>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;
  802399:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  80239d:	75 10                	jne    8023af <print_mem_block_lists+0xcd>
  80239f:	83 ec 0c             	sub    $0xc,%esp
  8023a2:	68 30 3e 80 00       	push   $0x803e30
  8023a7:	e8 26 e6 ff ff       	call   8009d2 <cprintf>
  8023ac:	83 c4 10             	add    $0x10,%esp

	lastBlk = NULL ;
  8023af:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nAllocMemBlocksList:\n");
  8023b6:	83 ec 0c             	sub    $0xc,%esp
  8023b9:	68 54 3e 80 00       	push   $0x803e54
  8023be:	e8 0f e6 ff ff       	call   8009d2 <cprintf>
  8023c3:	83 c4 10             	add    $0x10,%esp
	sorted = 1 ;
  8023c6:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &AllocMemBlocksList)
  8023ca:	a1 40 40 80 00       	mov    0x804040,%eax
  8023cf:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8023d2:	eb 56                	jmp    80242a <print_mem_block_lists+0x148>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  8023d4:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8023d8:	74 1c                	je     8023f6 <print_mem_block_lists+0x114>
  8023da:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023dd:	8b 50 08             	mov    0x8(%eax),%edx
  8023e0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8023e3:	8b 48 08             	mov    0x8(%eax),%ecx
  8023e6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8023e9:	8b 40 0c             	mov    0xc(%eax),%eax
  8023ec:	01 c8                	add    %ecx,%eax
  8023ee:	39 c2                	cmp    %eax,%edx
  8023f0:	73 04                	jae    8023f6 <print_mem_block_lists+0x114>
			sorted = 0 ;
  8023f2:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  8023f6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023f9:	8b 50 08             	mov    0x8(%eax),%edx
  8023fc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023ff:	8b 40 0c             	mov    0xc(%eax),%eax
  802402:	01 c2                	add    %eax,%edx
  802404:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802407:	8b 40 08             	mov    0x8(%eax),%eax
  80240a:	83 ec 04             	sub    $0x4,%esp
  80240d:	52                   	push   %edx
  80240e:	50                   	push   %eax
  80240f:	68 21 3e 80 00       	push   $0x803e21
  802414:	e8 b9 e5 ff ff       	call   8009d2 <cprintf>
  802419:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  80241c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80241f:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;

	lastBlk = NULL ;
	cprintf("\nAllocMemBlocksList:\n");
	sorted = 1 ;
	LIST_FOREACH(blk, &AllocMemBlocksList)
  802422:	a1 48 40 80 00       	mov    0x804048,%eax
  802427:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80242a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80242e:	74 07                	je     802437 <print_mem_block_lists+0x155>
  802430:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802433:	8b 00                	mov    (%eax),%eax
  802435:	eb 05                	jmp    80243c <print_mem_block_lists+0x15a>
  802437:	b8 00 00 00 00       	mov    $0x0,%eax
  80243c:	a3 48 40 80 00       	mov    %eax,0x804048
  802441:	a1 48 40 80 00       	mov    0x804048,%eax
  802446:	85 c0                	test   %eax,%eax
  802448:	75 8a                	jne    8023d4 <print_mem_block_lists+0xf2>
  80244a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80244e:	75 84                	jne    8023d4 <print_mem_block_lists+0xf2>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nAllocMemBlocksList is NOT SORTED!!\n") ;
  802450:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  802454:	75 10                	jne    802466 <print_mem_block_lists+0x184>
  802456:	83 ec 0c             	sub    $0xc,%esp
  802459:	68 6c 3e 80 00       	push   $0x803e6c
  80245e:	e8 6f e5 ff ff       	call   8009d2 <cprintf>
  802463:	83 c4 10             	add    $0x10,%esp
	cprintf("\n=========================================\n");
  802466:	83 ec 0c             	sub    $0xc,%esp
  802469:	68 e0 3d 80 00       	push   $0x803de0
  80246e:	e8 5f e5 ff ff       	call   8009d2 <cprintf>
  802473:	83 c4 10             	add    $0x10,%esp

}
  802476:	90                   	nop
  802477:	c9                   	leave  
  802478:	c3                   	ret    

00802479 <initialize_MemBlocksList>:

//===============================
// [1] INITIALIZE AVAILABLE LIST:
//===============================
void initialize_MemBlocksList(uint32 numOfBlocks)
{
  802479:	55                   	push   %ebp
  80247a:	89 e5                	mov    %esp,%ebp
  80247c:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] initialize_MemBlocksList
	// Write your code here, remove the panic and write your code
	//panic("initialize_MemBlocksList() is not implemented yet...!!");
	uint32 n = numOfBlocks;
  80247f:	8b 45 08             	mov    0x8(%ebp),%eax
  802482:	89 45 f0             	mov    %eax,-0x10(%ebp)

	LIST_INIT(&AvailableMemBlocksList);
  802485:	c7 05 48 41 80 00 00 	movl   $0x0,0x804148
  80248c:	00 00 00 
  80248f:	c7 05 4c 41 80 00 00 	movl   $0x0,0x80414c
  802496:	00 00 00 
  802499:	c7 05 54 41 80 00 00 	movl   $0x0,0x804154
  8024a0:	00 00 00 
	for(int i = 0; i<n;i++)
  8024a3:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  8024aa:	e9 9e 00 00 00       	jmp    80254d <initialize_MemBlocksList+0xd4>
	{
		LIST_INSERT_HEAD(&AvailableMemBlocksList, &(MemBlockNodes[i]));
  8024af:	a1 50 40 80 00       	mov    0x804050,%eax
  8024b4:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8024b7:	c1 e2 04             	shl    $0x4,%edx
  8024ba:	01 d0                	add    %edx,%eax
  8024bc:	85 c0                	test   %eax,%eax
  8024be:	75 14                	jne    8024d4 <initialize_MemBlocksList+0x5b>
  8024c0:	83 ec 04             	sub    $0x4,%esp
  8024c3:	68 94 3e 80 00       	push   $0x803e94
  8024c8:	6a 47                	push   $0x47
  8024ca:	68 b7 3e 80 00       	push   $0x803eb7
  8024cf:	e8 4a e2 ff ff       	call   80071e <_panic>
  8024d4:	a1 50 40 80 00       	mov    0x804050,%eax
  8024d9:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8024dc:	c1 e2 04             	shl    $0x4,%edx
  8024df:	01 d0                	add    %edx,%eax
  8024e1:	8b 15 48 41 80 00    	mov    0x804148,%edx
  8024e7:	89 10                	mov    %edx,(%eax)
  8024e9:	8b 00                	mov    (%eax),%eax
  8024eb:	85 c0                	test   %eax,%eax
  8024ed:	74 18                	je     802507 <initialize_MemBlocksList+0x8e>
  8024ef:	a1 48 41 80 00       	mov    0x804148,%eax
  8024f4:	8b 15 50 40 80 00    	mov    0x804050,%edx
  8024fa:	8b 4d f4             	mov    -0xc(%ebp),%ecx
  8024fd:	c1 e1 04             	shl    $0x4,%ecx
  802500:	01 ca                	add    %ecx,%edx
  802502:	89 50 04             	mov    %edx,0x4(%eax)
  802505:	eb 12                	jmp    802519 <initialize_MemBlocksList+0xa0>
  802507:	a1 50 40 80 00       	mov    0x804050,%eax
  80250c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80250f:	c1 e2 04             	shl    $0x4,%edx
  802512:	01 d0                	add    %edx,%eax
  802514:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802519:	a1 50 40 80 00       	mov    0x804050,%eax
  80251e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802521:	c1 e2 04             	shl    $0x4,%edx
  802524:	01 d0                	add    %edx,%eax
  802526:	a3 48 41 80 00       	mov    %eax,0x804148
  80252b:	a1 50 40 80 00       	mov    0x804050,%eax
  802530:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802533:	c1 e2 04             	shl    $0x4,%edx
  802536:	01 d0                	add    %edx,%eax
  802538:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80253f:	a1 54 41 80 00       	mov    0x804154,%eax
  802544:	40                   	inc    %eax
  802545:	a3 54 41 80 00       	mov    %eax,0x804154
	// Write your code here, remove the panic and write your code
	//panic("initialize_MemBlocksList() is not implemented yet...!!");
	uint32 n = numOfBlocks;

	LIST_INIT(&AvailableMemBlocksList);
	for(int i = 0; i<n;i++)
  80254a:	ff 45 f4             	incl   -0xc(%ebp)
  80254d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802550:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  802553:	0f 82 56 ff ff ff    	jb     8024af <initialize_MemBlocksList+0x36>
	{
		LIST_INSERT_HEAD(&AvailableMemBlocksList, &(MemBlockNodes[i]));
	}
}
  802559:	90                   	nop
  80255a:	c9                   	leave  
  80255b:	c3                   	ret    

0080255c <find_block>:

//===============================
// [2] FIND BLOCK:
//===============================
struct MemBlock *find_block(struct MemBlock_List *blockList, uint32 va)
{
  80255c:	55                   	push   %ebp
  80255d:	89 e5                	mov    %esp,%ebp
  80255f:	83 ec 10             	sub    $0x10,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] find_block
	// Write your code here, remove the panic and write your code
	//panic("find_block() is not implemented yet...!!");
	uint32 virAddress = va;
  802562:	8b 45 0c             	mov    0xc(%ebp),%eax
  802565:	89 45 f4             	mov    %eax,-0xc(%ebp)
	struct MemBlock* blk;
	int found = 0;
  802568:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	LIST_FOREACH(blk, &(AllocMemBlocksList))
  80256f:	a1 40 40 80 00       	mov    0x804040,%eax
  802574:	89 45 fc             	mov    %eax,-0x4(%ebp)
  802577:	eb 23                	jmp    80259c <find_block+0x40>
	{
		if(blk->sva == virAddress)
  802579:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80257c:	8b 40 08             	mov    0x8(%eax),%eax
  80257f:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  802582:	75 09                	jne    80258d <find_block+0x31>
		{
			found = 1;
  802584:	c7 45 f8 01 00 00 00 	movl   $0x1,-0x8(%ebp)
			break;
  80258b:	eb 35                	jmp    8025c2 <find_block+0x66>
		}
		else
		{
			found = 0;
  80258d:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	//panic("find_block() is not implemented yet...!!");
	uint32 virAddress = va;
	struct MemBlock* blk;
	int found = 0;

	LIST_FOREACH(blk, &(AllocMemBlocksList))
  802594:	a1 48 40 80 00       	mov    0x804048,%eax
  802599:	89 45 fc             	mov    %eax,-0x4(%ebp)
  80259c:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  8025a0:	74 07                	je     8025a9 <find_block+0x4d>
  8025a2:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8025a5:	8b 00                	mov    (%eax),%eax
  8025a7:	eb 05                	jmp    8025ae <find_block+0x52>
  8025a9:	b8 00 00 00 00       	mov    $0x0,%eax
  8025ae:	a3 48 40 80 00       	mov    %eax,0x804048
  8025b3:	a1 48 40 80 00       	mov    0x804048,%eax
  8025b8:	85 c0                	test   %eax,%eax
  8025ba:	75 bd                	jne    802579 <find_block+0x1d>
  8025bc:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  8025c0:	75 b7                	jne    802579 <find_block+0x1d>
		{
			found = 0;
			continue;
		}
	}
	if(found == 1)
  8025c2:	83 7d f8 01          	cmpl   $0x1,-0x8(%ebp)
  8025c6:	75 05                	jne    8025cd <find_block+0x71>
	{
		return blk;
  8025c8:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8025cb:	eb 05                	jmp    8025d2 <find_block+0x76>
	}
	else
	{
		return NULL;
  8025cd:	b8 00 00 00 00       	mov    $0x0,%eax
	}
}
  8025d2:	c9                   	leave  
  8025d3:	c3                   	ret    

008025d4 <insert_sorted_allocList>:

//=========================================
// [3] INSERT BLOCK IN ALLOC LIST [SORTED]:
//=========================================
void insert_sorted_allocList(struct MemBlock *blockToInsert)
{
  8025d4:	55                   	push   %ebp
  8025d5:	89 e5                	mov    %esp,%ebp
  8025d7:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] insert_sorted_allocList
	// Write your code here, remove the panic and write your code
	//panic("insert_sorted_allocList() is not implemented yet...!!");
	struct MemBlock* blk;
	struct MemBlock* newblk = blockToInsert;
  8025da:	8b 45 08             	mov    0x8(%ebp),%eax
  8025dd:	89 45 f0             	mov    %eax,-0x10(%ebp)

	if((LIST_EMPTY(&AllocMemBlocksList)) || (newblk->sva < LIST_FIRST(&AllocMemBlocksList)->sva))
  8025e0:	a1 40 40 80 00       	mov    0x804040,%eax
  8025e5:	85 c0                	test   %eax,%eax
  8025e7:	74 12                	je     8025fb <insert_sorted_allocList+0x27>
  8025e9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8025ec:	8b 50 08             	mov    0x8(%eax),%edx
  8025ef:	a1 40 40 80 00       	mov    0x804040,%eax
  8025f4:	8b 40 08             	mov    0x8(%eax),%eax
  8025f7:	39 c2                	cmp    %eax,%edx
  8025f9:	73 65                	jae    802660 <insert_sorted_allocList+0x8c>
	{
		LIST_INSERT_HEAD(&(AllocMemBlocksList), newblk);
  8025fb:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8025ff:	75 14                	jne    802615 <insert_sorted_allocList+0x41>
  802601:	83 ec 04             	sub    $0x4,%esp
  802604:	68 94 3e 80 00       	push   $0x803e94
  802609:	6a 7b                	push   $0x7b
  80260b:	68 b7 3e 80 00       	push   $0x803eb7
  802610:	e8 09 e1 ff ff       	call   80071e <_panic>
  802615:	8b 15 40 40 80 00    	mov    0x804040,%edx
  80261b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80261e:	89 10                	mov    %edx,(%eax)
  802620:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802623:	8b 00                	mov    (%eax),%eax
  802625:	85 c0                	test   %eax,%eax
  802627:	74 0d                	je     802636 <insert_sorted_allocList+0x62>
  802629:	a1 40 40 80 00       	mov    0x804040,%eax
  80262e:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802631:	89 50 04             	mov    %edx,0x4(%eax)
  802634:	eb 08                	jmp    80263e <insert_sorted_allocList+0x6a>
  802636:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802639:	a3 44 40 80 00       	mov    %eax,0x804044
  80263e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802641:	a3 40 40 80 00       	mov    %eax,0x804040
  802646:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802649:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802650:	a1 4c 40 80 00       	mov    0x80404c,%eax
  802655:	40                   	inc    %eax
  802656:	a3 4c 40 80 00       	mov    %eax,0x80404c
  80265b:	e9 5f 01 00 00       	jmp    8027bf <insert_sorted_allocList+0x1eb>
	}
	else if(newblk->sva > LIST_LAST(&AllocMemBlocksList)->sva)
  802660:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802663:	8b 50 08             	mov    0x8(%eax),%edx
  802666:	a1 44 40 80 00       	mov    0x804044,%eax
  80266b:	8b 40 08             	mov    0x8(%eax),%eax
  80266e:	39 c2                	cmp    %eax,%edx
  802670:	76 65                	jbe    8026d7 <insert_sorted_allocList+0x103>
	{
		LIST_INSERT_TAIL(&AllocMemBlocksList, newblk);
  802672:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802676:	75 14                	jne    80268c <insert_sorted_allocList+0xb8>
  802678:	83 ec 04             	sub    $0x4,%esp
  80267b:	68 d0 3e 80 00       	push   $0x803ed0
  802680:	6a 7f                	push   $0x7f
  802682:	68 b7 3e 80 00       	push   $0x803eb7
  802687:	e8 92 e0 ff ff       	call   80071e <_panic>
  80268c:	8b 15 44 40 80 00    	mov    0x804044,%edx
  802692:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802695:	89 50 04             	mov    %edx,0x4(%eax)
  802698:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80269b:	8b 40 04             	mov    0x4(%eax),%eax
  80269e:	85 c0                	test   %eax,%eax
  8026a0:	74 0c                	je     8026ae <insert_sorted_allocList+0xda>
  8026a2:	a1 44 40 80 00       	mov    0x804044,%eax
  8026a7:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8026aa:	89 10                	mov    %edx,(%eax)
  8026ac:	eb 08                	jmp    8026b6 <insert_sorted_allocList+0xe2>
  8026ae:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8026b1:	a3 40 40 80 00       	mov    %eax,0x804040
  8026b6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8026b9:	a3 44 40 80 00       	mov    %eax,0x804044
  8026be:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8026c1:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8026c7:	a1 4c 40 80 00       	mov    0x80404c,%eax
  8026cc:	40                   	inc    %eax
  8026cd:	a3 4c 40 80 00       	mov    %eax,0x80404c
				LIST_INSERT_AFTER(&AllocMemBlocksList, blk, newblk);
				break;
			}
		}
	}
}
  8026d2:	e9 e8 00 00 00       	jmp    8027bf <insert_sorted_allocList+0x1eb>
	{
		LIST_INSERT_TAIL(&AllocMemBlocksList, newblk);
	}
	else
	{
		LIST_FOREACH(blk, &AllocMemBlocksList)
  8026d7:	a1 40 40 80 00       	mov    0x804040,%eax
  8026dc:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8026df:	e9 ab 00 00 00       	jmp    80278f <insert_sorted_allocList+0x1bb>
		{
			if(blk->prev_next_info.le_next != NULL && newblk->sva > blk->sva  && newblk->sva < blk->prev_next_info.le_next->sva)
  8026e4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026e7:	8b 00                	mov    (%eax),%eax
  8026e9:	85 c0                	test   %eax,%eax
  8026eb:	0f 84 96 00 00 00    	je     802787 <insert_sorted_allocList+0x1b3>
  8026f1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8026f4:	8b 50 08             	mov    0x8(%eax),%edx
  8026f7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026fa:	8b 40 08             	mov    0x8(%eax),%eax
  8026fd:	39 c2                	cmp    %eax,%edx
  8026ff:	0f 86 82 00 00 00    	jbe    802787 <insert_sorted_allocList+0x1b3>
  802705:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802708:	8b 50 08             	mov    0x8(%eax),%edx
  80270b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80270e:	8b 00                	mov    (%eax),%eax
  802710:	8b 40 08             	mov    0x8(%eax),%eax
  802713:	39 c2                	cmp    %eax,%edx
  802715:	73 70                	jae    802787 <insert_sorted_allocList+0x1b3>
			{
				LIST_INSERT_AFTER(&AllocMemBlocksList, blk, newblk);
  802717:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80271b:	74 06                	je     802723 <insert_sorted_allocList+0x14f>
  80271d:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802721:	75 17                	jne    80273a <insert_sorted_allocList+0x166>
  802723:	83 ec 04             	sub    $0x4,%esp
  802726:	68 f4 3e 80 00       	push   $0x803ef4
  80272b:	68 87 00 00 00       	push   $0x87
  802730:	68 b7 3e 80 00       	push   $0x803eb7
  802735:	e8 e4 df ff ff       	call   80071e <_panic>
  80273a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80273d:	8b 10                	mov    (%eax),%edx
  80273f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802742:	89 10                	mov    %edx,(%eax)
  802744:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802747:	8b 00                	mov    (%eax),%eax
  802749:	85 c0                	test   %eax,%eax
  80274b:	74 0b                	je     802758 <insert_sorted_allocList+0x184>
  80274d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802750:	8b 00                	mov    (%eax),%eax
  802752:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802755:	89 50 04             	mov    %edx,0x4(%eax)
  802758:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80275b:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80275e:	89 10                	mov    %edx,(%eax)
  802760:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802763:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802766:	89 50 04             	mov    %edx,0x4(%eax)
  802769:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80276c:	8b 00                	mov    (%eax),%eax
  80276e:	85 c0                	test   %eax,%eax
  802770:	75 08                	jne    80277a <insert_sorted_allocList+0x1a6>
  802772:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802775:	a3 44 40 80 00       	mov    %eax,0x804044
  80277a:	a1 4c 40 80 00       	mov    0x80404c,%eax
  80277f:	40                   	inc    %eax
  802780:	a3 4c 40 80 00       	mov    %eax,0x80404c
				break;
  802785:	eb 38                	jmp    8027bf <insert_sorted_allocList+0x1eb>
	{
		LIST_INSERT_TAIL(&AllocMemBlocksList, newblk);
	}
	else
	{
		LIST_FOREACH(blk, &AllocMemBlocksList)
  802787:	a1 48 40 80 00       	mov    0x804048,%eax
  80278c:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80278f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802793:	74 07                	je     80279c <insert_sorted_allocList+0x1c8>
  802795:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802798:	8b 00                	mov    (%eax),%eax
  80279a:	eb 05                	jmp    8027a1 <insert_sorted_allocList+0x1cd>
  80279c:	b8 00 00 00 00       	mov    $0x0,%eax
  8027a1:	a3 48 40 80 00       	mov    %eax,0x804048
  8027a6:	a1 48 40 80 00       	mov    0x804048,%eax
  8027ab:	85 c0                	test   %eax,%eax
  8027ad:	0f 85 31 ff ff ff    	jne    8026e4 <insert_sorted_allocList+0x110>
  8027b3:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8027b7:	0f 85 27 ff ff ff    	jne    8026e4 <insert_sorted_allocList+0x110>
				LIST_INSERT_AFTER(&AllocMemBlocksList, blk, newblk);
				break;
			}
		}
	}
}
  8027bd:	eb 00                	jmp    8027bf <insert_sorted_allocList+0x1eb>
  8027bf:	90                   	nop
  8027c0:	c9                   	leave  
  8027c1:	c3                   	ret    

008027c2 <alloc_block_FF>:

//=========================================
// [4] ALLOCATE BLOCK BY FIRST FIT:
//=========================================
struct MemBlock *alloc_block_FF(uint32 size)
{
  8027c2:	55                   	push   %ebp
  8027c3:	89 e5                	mov    %esp,%ebp
  8027c5:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_FF
	// Write your code here, remove the panic and write your code
	//panic("alloc_block_FF() is not implemented yet...!!");
	uint32 versize = size;
  8027c8:	8b 45 08             	mov    0x8(%ebp),%eax
  8027cb:	89 45 f0             	mov    %eax,-0x10(%ebp)
	struct MemBlock* blk;
	struct MemBlock* newblk = LIST_FIRST(&AvailableMemBlocksList);
  8027ce:	a1 48 41 80 00       	mov    0x804148,%eax
  8027d3:	89 45 ec             	mov    %eax,-0x14(%ebp)

	LIST_FOREACH(blk,&FreeMemBlocksList)
  8027d6:	a1 38 41 80 00       	mov    0x804138,%eax
  8027db:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8027de:	e9 77 01 00 00       	jmp    80295a <alloc_block_FF+0x198>
	{
		if(blk->size == versize)
  8027e3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027e6:	8b 40 0c             	mov    0xc(%eax),%eax
  8027e9:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8027ec:	0f 85 8a 00 00 00    	jne    80287c <alloc_block_FF+0xba>
		{
			LIST_REMOVE(&FreeMemBlocksList,blk);
  8027f2:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8027f6:	75 17                	jne    80280f <alloc_block_FF+0x4d>
  8027f8:	83 ec 04             	sub    $0x4,%esp
  8027fb:	68 28 3f 80 00       	push   $0x803f28
  802800:	68 9e 00 00 00       	push   $0x9e
  802805:	68 b7 3e 80 00       	push   $0x803eb7
  80280a:	e8 0f df ff ff       	call   80071e <_panic>
  80280f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802812:	8b 00                	mov    (%eax),%eax
  802814:	85 c0                	test   %eax,%eax
  802816:	74 10                	je     802828 <alloc_block_FF+0x66>
  802818:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80281b:	8b 00                	mov    (%eax),%eax
  80281d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802820:	8b 52 04             	mov    0x4(%edx),%edx
  802823:	89 50 04             	mov    %edx,0x4(%eax)
  802826:	eb 0b                	jmp    802833 <alloc_block_FF+0x71>
  802828:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80282b:	8b 40 04             	mov    0x4(%eax),%eax
  80282e:	a3 3c 41 80 00       	mov    %eax,0x80413c
  802833:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802836:	8b 40 04             	mov    0x4(%eax),%eax
  802839:	85 c0                	test   %eax,%eax
  80283b:	74 0f                	je     80284c <alloc_block_FF+0x8a>
  80283d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802840:	8b 40 04             	mov    0x4(%eax),%eax
  802843:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802846:	8b 12                	mov    (%edx),%edx
  802848:	89 10                	mov    %edx,(%eax)
  80284a:	eb 0a                	jmp    802856 <alloc_block_FF+0x94>
  80284c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80284f:	8b 00                	mov    (%eax),%eax
  802851:	a3 38 41 80 00       	mov    %eax,0x804138
  802856:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802859:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80285f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802862:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802869:	a1 44 41 80 00       	mov    0x804144,%eax
  80286e:	48                   	dec    %eax
  80286f:	a3 44 41 80 00       	mov    %eax,0x804144
			return blk;
  802874:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802877:	e9 11 01 00 00       	jmp    80298d <alloc_block_FF+0x1cb>
		}
		else if(blk->size > versize)
  80287c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80287f:	8b 40 0c             	mov    0xc(%eax),%eax
  802882:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  802885:	0f 86 c7 00 00 00    	jbe    802952 <alloc_block_FF+0x190>
		{
			LIST_REMOVE(&AvailableMemBlocksList,newblk);
  80288b:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  80288f:	75 17                	jne    8028a8 <alloc_block_FF+0xe6>
  802891:	83 ec 04             	sub    $0x4,%esp
  802894:	68 28 3f 80 00       	push   $0x803f28
  802899:	68 a3 00 00 00       	push   $0xa3
  80289e:	68 b7 3e 80 00       	push   $0x803eb7
  8028a3:	e8 76 de ff ff       	call   80071e <_panic>
  8028a8:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8028ab:	8b 00                	mov    (%eax),%eax
  8028ad:	85 c0                	test   %eax,%eax
  8028af:	74 10                	je     8028c1 <alloc_block_FF+0xff>
  8028b1:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8028b4:	8b 00                	mov    (%eax),%eax
  8028b6:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8028b9:	8b 52 04             	mov    0x4(%edx),%edx
  8028bc:	89 50 04             	mov    %edx,0x4(%eax)
  8028bf:	eb 0b                	jmp    8028cc <alloc_block_FF+0x10a>
  8028c1:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8028c4:	8b 40 04             	mov    0x4(%eax),%eax
  8028c7:	a3 4c 41 80 00       	mov    %eax,0x80414c
  8028cc:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8028cf:	8b 40 04             	mov    0x4(%eax),%eax
  8028d2:	85 c0                	test   %eax,%eax
  8028d4:	74 0f                	je     8028e5 <alloc_block_FF+0x123>
  8028d6:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8028d9:	8b 40 04             	mov    0x4(%eax),%eax
  8028dc:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8028df:	8b 12                	mov    (%edx),%edx
  8028e1:	89 10                	mov    %edx,(%eax)
  8028e3:	eb 0a                	jmp    8028ef <alloc_block_FF+0x12d>
  8028e5:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8028e8:	8b 00                	mov    (%eax),%eax
  8028ea:	a3 48 41 80 00       	mov    %eax,0x804148
  8028ef:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8028f2:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8028f8:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8028fb:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802902:	a1 54 41 80 00       	mov    0x804154,%eax
  802907:	48                   	dec    %eax
  802908:	a3 54 41 80 00       	mov    %eax,0x804154
			newblk->size = versize;
  80290d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802910:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802913:	89 50 0c             	mov    %edx,0xc(%eax)
			blk->size = blk->size-versize;
  802916:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802919:	8b 40 0c             	mov    0xc(%eax),%eax
  80291c:	2b 45 f0             	sub    -0x10(%ebp),%eax
  80291f:	89 c2                	mov    %eax,%edx
  802921:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802924:	89 50 0c             	mov    %edx,0xc(%eax)
			uint32 newveradd = blk->sva;
  802927:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80292a:	8b 40 08             	mov    0x8(%eax),%eax
  80292d:	89 45 e8             	mov    %eax,-0x18(%ebp)
			blk->sva+=newblk->size;
  802930:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802933:	8b 50 08             	mov    0x8(%eax),%edx
  802936:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802939:	8b 40 0c             	mov    0xc(%eax),%eax
  80293c:	01 c2                	add    %eax,%edx
  80293e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802941:	89 50 08             	mov    %edx,0x8(%eax)
			newblk->sva = newveradd;
  802944:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802947:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80294a:	89 50 08             	mov    %edx,0x8(%eax)
			return newblk;
  80294d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802950:	eb 3b                	jmp    80298d <alloc_block_FF+0x1cb>
	//panic("alloc_block_FF() is not implemented yet...!!");
	uint32 versize = size;
	struct MemBlock* blk;
	struct MemBlock* newblk = LIST_FIRST(&AvailableMemBlocksList);

	LIST_FOREACH(blk,&FreeMemBlocksList)
  802952:	a1 40 41 80 00       	mov    0x804140,%eax
  802957:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80295a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80295e:	74 07                	je     802967 <alloc_block_FF+0x1a5>
  802960:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802963:	8b 00                	mov    (%eax),%eax
  802965:	eb 05                	jmp    80296c <alloc_block_FF+0x1aa>
  802967:	b8 00 00 00 00       	mov    $0x0,%eax
  80296c:	a3 40 41 80 00       	mov    %eax,0x804140
  802971:	a1 40 41 80 00       	mov    0x804140,%eax
  802976:	85 c0                	test   %eax,%eax
  802978:	0f 85 65 fe ff ff    	jne    8027e3 <alloc_block_FF+0x21>
  80297e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802982:	0f 85 5b fe ff ff    	jne    8027e3 <alloc_block_FF+0x21>
			blk->sva+=newblk->size;
			newblk->sva = newveradd;
			return newblk;
		}
	}
	return NULL;
  802988:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80298d:	c9                   	leave  
  80298e:	c3                   	ret    

0080298f <alloc_block_BF>:

//=========================================
// [5] ALLOCATE BLOCK BY BEST FIT:
//=========================================
struct MemBlock *alloc_block_BF(uint32 size)
{
  80298f:	55                   	push   %ebp
  802990:	89 e5                	mov    %esp,%ebp
  802992:	83 ec 28             	sub    $0x28,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_BF
	// Write your code here, remove the panic and write your code
	//panic("alloc_block_BF() is not implemented yet...!!");
	uint32 versize=size;
  802995:	8b 45 08             	mov    0x8(%ebp),%eax
  802998:	89 45 e8             	mov    %eax,-0x18(%ebp)
	struct MemBlock* blk;
	struct MemBlock* newblk=LIST_FIRST(&AvailableMemBlocksList);
  80299b:	a1 48 41 80 00       	mov    0x804148,%eax
  8029a0:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	uint32 newveradd;
	uint32 newsize;
	int size_free = LIST_SIZE(&FreeMemBlocksList);
  8029a3:	a1 44 41 80 00       	mov    0x804144,%eax
  8029a8:	89 45 e0             	mov    %eax,-0x20(%ebp)

	LIST_FOREACH(blk, &FreeMemBlocksList)
  8029ab:	a1 38 41 80 00       	mov    0x804138,%eax
  8029b0:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8029b3:	e9 a1 00 00 00       	jmp    802a59 <alloc_block_BF+0xca>
	{
		if(blk->size == versize)
  8029b8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029bb:	8b 40 0c             	mov    0xc(%eax),%eax
  8029be:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  8029c1:	0f 85 8a 00 00 00    	jne    802a51 <alloc_block_BF+0xc2>
		{
			LIST_REMOVE(&FreeMemBlocksList, blk);
  8029c7:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8029cb:	75 17                	jne    8029e4 <alloc_block_BF+0x55>
  8029cd:	83 ec 04             	sub    $0x4,%esp
  8029d0:	68 28 3f 80 00       	push   $0x803f28
  8029d5:	68 c2 00 00 00       	push   $0xc2
  8029da:	68 b7 3e 80 00       	push   $0x803eb7
  8029df:	e8 3a dd ff ff       	call   80071e <_panic>
  8029e4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029e7:	8b 00                	mov    (%eax),%eax
  8029e9:	85 c0                	test   %eax,%eax
  8029eb:	74 10                	je     8029fd <alloc_block_BF+0x6e>
  8029ed:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029f0:	8b 00                	mov    (%eax),%eax
  8029f2:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8029f5:	8b 52 04             	mov    0x4(%edx),%edx
  8029f8:	89 50 04             	mov    %edx,0x4(%eax)
  8029fb:	eb 0b                	jmp    802a08 <alloc_block_BF+0x79>
  8029fd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a00:	8b 40 04             	mov    0x4(%eax),%eax
  802a03:	a3 3c 41 80 00       	mov    %eax,0x80413c
  802a08:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a0b:	8b 40 04             	mov    0x4(%eax),%eax
  802a0e:	85 c0                	test   %eax,%eax
  802a10:	74 0f                	je     802a21 <alloc_block_BF+0x92>
  802a12:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a15:	8b 40 04             	mov    0x4(%eax),%eax
  802a18:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802a1b:	8b 12                	mov    (%edx),%edx
  802a1d:	89 10                	mov    %edx,(%eax)
  802a1f:	eb 0a                	jmp    802a2b <alloc_block_BF+0x9c>
  802a21:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a24:	8b 00                	mov    (%eax),%eax
  802a26:	a3 38 41 80 00       	mov    %eax,0x804138
  802a2b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a2e:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802a34:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a37:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802a3e:	a1 44 41 80 00       	mov    0x804144,%eax
  802a43:	48                   	dec    %eax
  802a44:	a3 44 41 80 00       	mov    %eax,0x804144
			return blk;
  802a49:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a4c:	e9 11 02 00 00       	jmp    802c62 <alloc_block_BF+0x2d3>
	struct MemBlock* newblk=LIST_FIRST(&AvailableMemBlocksList);
	uint32 newveradd;
	uint32 newsize;
	int size_free = LIST_SIZE(&FreeMemBlocksList);

	LIST_FOREACH(blk, &FreeMemBlocksList)
  802a51:	a1 40 41 80 00       	mov    0x804140,%eax
  802a56:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802a59:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802a5d:	74 07                	je     802a66 <alloc_block_BF+0xd7>
  802a5f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a62:	8b 00                	mov    (%eax),%eax
  802a64:	eb 05                	jmp    802a6b <alloc_block_BF+0xdc>
  802a66:	b8 00 00 00 00       	mov    $0x0,%eax
  802a6b:	a3 40 41 80 00       	mov    %eax,0x804140
  802a70:	a1 40 41 80 00       	mov    0x804140,%eax
  802a75:	85 c0                	test   %eax,%eax
  802a77:	0f 85 3b ff ff ff    	jne    8029b8 <alloc_block_BF+0x29>
  802a7d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802a81:	0f 85 31 ff ff ff    	jne    8029b8 <alloc_block_BF+0x29>
		{
			LIST_REMOVE(&FreeMemBlocksList, blk);
			return blk;
		}
	}
	LIST_FOREACH(blk, &FreeMemBlocksList)
  802a87:	a1 38 41 80 00       	mov    0x804138,%eax
  802a8c:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802a8f:	eb 27                	jmp    802ab8 <alloc_block_BF+0x129>
	{
		if(blk->size > versize)
  802a91:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a94:	8b 40 0c             	mov    0xc(%eax),%eax
  802a97:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  802a9a:	76 14                	jbe    802ab0 <alloc_block_BF+0x121>
		{
			newsize = blk->size;
  802a9c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a9f:	8b 40 0c             	mov    0xc(%eax),%eax
  802aa2:	89 45 ec             	mov    %eax,-0x14(%ebp)
			newveradd = blk->sva;
  802aa5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802aa8:	8b 40 08             	mov    0x8(%eax),%eax
  802aab:	89 45 f0             	mov    %eax,-0x10(%ebp)
			break;
  802aae:	eb 2e                	jmp    802ade <alloc_block_BF+0x14f>
		{
			LIST_REMOVE(&FreeMemBlocksList, blk);
			return blk;
		}
	}
	LIST_FOREACH(blk, &FreeMemBlocksList)
  802ab0:	a1 40 41 80 00       	mov    0x804140,%eax
  802ab5:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802ab8:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802abc:	74 07                	je     802ac5 <alloc_block_BF+0x136>
  802abe:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ac1:	8b 00                	mov    (%eax),%eax
  802ac3:	eb 05                	jmp    802aca <alloc_block_BF+0x13b>
  802ac5:	b8 00 00 00 00       	mov    $0x0,%eax
  802aca:	a3 40 41 80 00       	mov    %eax,0x804140
  802acf:	a1 40 41 80 00       	mov    0x804140,%eax
  802ad4:	85 c0                	test   %eax,%eax
  802ad6:	75 b9                	jne    802a91 <alloc_block_BF+0x102>
  802ad8:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802adc:	75 b3                	jne    802a91 <alloc_block_BF+0x102>
			newsize = blk->size;
			newveradd = blk->sva;
			break;
		}
	}
	LIST_FOREACH(blk, &FreeMemBlocksList)
  802ade:	a1 38 41 80 00       	mov    0x804138,%eax
  802ae3:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802ae6:	eb 30                	jmp    802b18 <alloc_block_BF+0x189>
	{
		if(newsize > blk->size && blk->size > versize)
  802ae8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802aeb:	8b 40 0c             	mov    0xc(%eax),%eax
  802aee:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  802af1:	73 1d                	jae    802b10 <alloc_block_BF+0x181>
  802af3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802af6:	8b 40 0c             	mov    0xc(%eax),%eax
  802af9:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  802afc:	76 12                	jbe    802b10 <alloc_block_BF+0x181>
		{
	       newsize = blk->size;
  802afe:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b01:	8b 40 0c             	mov    0xc(%eax),%eax
  802b04:	89 45 ec             	mov    %eax,-0x14(%ebp)
		   newveradd = blk->sva;
  802b07:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b0a:	8b 40 08             	mov    0x8(%eax),%eax
  802b0d:	89 45 f0             	mov    %eax,-0x10(%ebp)
			newsize = blk->size;
			newveradd = blk->sva;
			break;
		}
	}
	LIST_FOREACH(blk, &FreeMemBlocksList)
  802b10:	a1 40 41 80 00       	mov    0x804140,%eax
  802b15:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802b18:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802b1c:	74 07                	je     802b25 <alloc_block_BF+0x196>
  802b1e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b21:	8b 00                	mov    (%eax),%eax
  802b23:	eb 05                	jmp    802b2a <alloc_block_BF+0x19b>
  802b25:	b8 00 00 00 00       	mov    $0x0,%eax
  802b2a:	a3 40 41 80 00       	mov    %eax,0x804140
  802b2f:	a1 40 41 80 00       	mov    0x804140,%eax
  802b34:	85 c0                	test   %eax,%eax
  802b36:	75 b0                	jne    802ae8 <alloc_block_BF+0x159>
  802b38:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802b3c:	75 aa                	jne    802ae8 <alloc_block_BF+0x159>
		{
	       newsize = blk->size;
		   newveradd = blk->sva;
		}
	}
	LIST_FOREACH(blk, &FreeMemBlocksList)
  802b3e:	a1 38 41 80 00       	mov    0x804138,%eax
  802b43:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802b46:	e9 e4 00 00 00       	jmp    802c2f <alloc_block_BF+0x2a0>
	{
		if(blk->size == newsize && blk->sva == newveradd)
  802b4b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b4e:	8b 40 0c             	mov    0xc(%eax),%eax
  802b51:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  802b54:	0f 85 cd 00 00 00    	jne    802c27 <alloc_block_BF+0x298>
  802b5a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b5d:	8b 40 08             	mov    0x8(%eax),%eax
  802b60:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  802b63:	0f 85 be 00 00 00    	jne    802c27 <alloc_block_BF+0x298>
		{
			LIST_REMOVE(&AvailableMemBlocksList, newblk);
  802b69:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  802b6d:	75 17                	jne    802b86 <alloc_block_BF+0x1f7>
  802b6f:	83 ec 04             	sub    $0x4,%esp
  802b72:	68 28 3f 80 00       	push   $0x803f28
  802b77:	68 db 00 00 00       	push   $0xdb
  802b7c:	68 b7 3e 80 00       	push   $0x803eb7
  802b81:	e8 98 db ff ff       	call   80071e <_panic>
  802b86:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802b89:	8b 00                	mov    (%eax),%eax
  802b8b:	85 c0                	test   %eax,%eax
  802b8d:	74 10                	je     802b9f <alloc_block_BF+0x210>
  802b8f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802b92:	8b 00                	mov    (%eax),%eax
  802b94:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802b97:	8b 52 04             	mov    0x4(%edx),%edx
  802b9a:	89 50 04             	mov    %edx,0x4(%eax)
  802b9d:	eb 0b                	jmp    802baa <alloc_block_BF+0x21b>
  802b9f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802ba2:	8b 40 04             	mov    0x4(%eax),%eax
  802ba5:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802baa:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802bad:	8b 40 04             	mov    0x4(%eax),%eax
  802bb0:	85 c0                	test   %eax,%eax
  802bb2:	74 0f                	je     802bc3 <alloc_block_BF+0x234>
  802bb4:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802bb7:	8b 40 04             	mov    0x4(%eax),%eax
  802bba:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802bbd:	8b 12                	mov    (%edx),%edx
  802bbf:	89 10                	mov    %edx,(%eax)
  802bc1:	eb 0a                	jmp    802bcd <alloc_block_BF+0x23e>
  802bc3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802bc6:	8b 00                	mov    (%eax),%eax
  802bc8:	a3 48 41 80 00       	mov    %eax,0x804148
  802bcd:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802bd0:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802bd6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802bd9:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802be0:	a1 54 41 80 00       	mov    0x804154,%eax
  802be5:	48                   	dec    %eax
  802be6:	a3 54 41 80 00       	mov    %eax,0x804154
			newblk->size = versize;
  802beb:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802bee:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802bf1:	89 50 0c             	mov    %edx,0xc(%eax)
			newblk->sva = newveradd;
  802bf4:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802bf7:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802bfa:	89 50 08             	mov    %edx,0x8(%eax)
			blk->size = blk->size - versize;
  802bfd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c00:	8b 40 0c             	mov    0xc(%eax),%eax
  802c03:	2b 45 e8             	sub    -0x18(%ebp),%eax
  802c06:	89 c2                	mov    %eax,%edx
  802c08:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c0b:	89 50 0c             	mov    %edx,0xc(%eax)
			blk->sva+= newblk->size;
  802c0e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c11:	8b 50 08             	mov    0x8(%eax),%edx
  802c14:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802c17:	8b 40 0c             	mov    0xc(%eax),%eax
  802c1a:	01 c2                	add    %eax,%edx
  802c1c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c1f:	89 50 08             	mov    %edx,0x8(%eax)
			return newblk;
  802c22:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802c25:	eb 3b                	jmp    802c62 <alloc_block_BF+0x2d3>
		{
	       newsize = blk->size;
		   newveradd = blk->sva;
		}
	}
	LIST_FOREACH(blk, &FreeMemBlocksList)
  802c27:	a1 40 41 80 00       	mov    0x804140,%eax
  802c2c:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802c2f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802c33:	74 07                	je     802c3c <alloc_block_BF+0x2ad>
  802c35:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c38:	8b 00                	mov    (%eax),%eax
  802c3a:	eb 05                	jmp    802c41 <alloc_block_BF+0x2b2>
  802c3c:	b8 00 00 00 00       	mov    $0x0,%eax
  802c41:	a3 40 41 80 00       	mov    %eax,0x804140
  802c46:	a1 40 41 80 00       	mov    0x804140,%eax
  802c4b:	85 c0                	test   %eax,%eax
  802c4d:	0f 85 f8 fe ff ff    	jne    802b4b <alloc_block_BF+0x1bc>
  802c53:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802c57:	0f 85 ee fe ff ff    	jne    802b4b <alloc_block_BF+0x1bc>
			blk->size = blk->size - versize;
			blk->sva+= newblk->size;
			return newblk;
		}
	}
	return NULL;
  802c5d:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802c62:	c9                   	leave  
  802c63:	c3                   	ret    

00802c64 <alloc_block_NF>:
//=========================================
// [7] ALLOCATE BLOCK BY NEXT FIT:
//=========================================
struct MemBlock *last_allocate;
struct MemBlock *alloc_block_NF(uint32 size)
{
  802c64:	55                   	push   %ebp
  802c65:	89 e5                	mov    %esp,%ebp
  802c67:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1 - BONUS] [DYNAMIC ALLOCATOR] alloc_block_NF
	// Write your code here, remove the panic and write your code
	//panic("alloc_block_NF() is not implemented yet...!!");
	uint32 versize = size;
  802c6a:	8b 45 08             	mov    0x8(%ebp),%eax
  802c6d:	89 45 f0             	mov    %eax,-0x10(%ebp)
	struct MemBlock* blk;
	struct MemBlock* newblk = LIST_FIRST(&AvailableMemBlocksList);
  802c70:	a1 48 41 80 00       	mov    0x804148,%eax
  802c75:	89 45 ec             	mov    %eax,-0x14(%ebp)

	LIST_FOREACH(blk,&FreeMemBlocksList)
  802c78:	a1 38 41 80 00       	mov    0x804138,%eax
  802c7d:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802c80:	e9 77 01 00 00       	jmp    802dfc <alloc_block_NF+0x198>
	{
		if(blk->size == versize)
  802c85:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c88:	8b 40 0c             	mov    0xc(%eax),%eax
  802c8b:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  802c8e:	0f 85 8a 00 00 00    	jne    802d1e <alloc_block_NF+0xba>
		{
			LIST_REMOVE(&FreeMemBlocksList,blk);
  802c94:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802c98:	75 17                	jne    802cb1 <alloc_block_NF+0x4d>
  802c9a:	83 ec 04             	sub    $0x4,%esp
  802c9d:	68 28 3f 80 00       	push   $0x803f28
  802ca2:	68 f7 00 00 00       	push   $0xf7
  802ca7:	68 b7 3e 80 00       	push   $0x803eb7
  802cac:	e8 6d da ff ff       	call   80071e <_panic>
  802cb1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cb4:	8b 00                	mov    (%eax),%eax
  802cb6:	85 c0                	test   %eax,%eax
  802cb8:	74 10                	je     802cca <alloc_block_NF+0x66>
  802cba:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cbd:	8b 00                	mov    (%eax),%eax
  802cbf:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802cc2:	8b 52 04             	mov    0x4(%edx),%edx
  802cc5:	89 50 04             	mov    %edx,0x4(%eax)
  802cc8:	eb 0b                	jmp    802cd5 <alloc_block_NF+0x71>
  802cca:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ccd:	8b 40 04             	mov    0x4(%eax),%eax
  802cd0:	a3 3c 41 80 00       	mov    %eax,0x80413c
  802cd5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cd8:	8b 40 04             	mov    0x4(%eax),%eax
  802cdb:	85 c0                	test   %eax,%eax
  802cdd:	74 0f                	je     802cee <alloc_block_NF+0x8a>
  802cdf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ce2:	8b 40 04             	mov    0x4(%eax),%eax
  802ce5:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802ce8:	8b 12                	mov    (%edx),%edx
  802cea:	89 10                	mov    %edx,(%eax)
  802cec:	eb 0a                	jmp    802cf8 <alloc_block_NF+0x94>
  802cee:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cf1:	8b 00                	mov    (%eax),%eax
  802cf3:	a3 38 41 80 00       	mov    %eax,0x804138
  802cf8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cfb:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802d01:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d04:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802d0b:	a1 44 41 80 00       	mov    0x804144,%eax
  802d10:	48                   	dec    %eax
  802d11:	a3 44 41 80 00       	mov    %eax,0x804144
			return blk;
  802d16:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d19:	e9 11 01 00 00       	jmp    802e2f <alloc_block_NF+0x1cb>
		}
		else if(blk->size > versize)
  802d1e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d21:	8b 40 0c             	mov    0xc(%eax),%eax
  802d24:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  802d27:	0f 86 c7 00 00 00    	jbe    802df4 <alloc_block_NF+0x190>
		{
			LIST_REMOVE(&AvailableMemBlocksList,newblk);
  802d2d:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802d31:	75 17                	jne    802d4a <alloc_block_NF+0xe6>
  802d33:	83 ec 04             	sub    $0x4,%esp
  802d36:	68 28 3f 80 00       	push   $0x803f28
  802d3b:	68 fc 00 00 00       	push   $0xfc
  802d40:	68 b7 3e 80 00       	push   $0x803eb7
  802d45:	e8 d4 d9 ff ff       	call   80071e <_panic>
  802d4a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802d4d:	8b 00                	mov    (%eax),%eax
  802d4f:	85 c0                	test   %eax,%eax
  802d51:	74 10                	je     802d63 <alloc_block_NF+0xff>
  802d53:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802d56:	8b 00                	mov    (%eax),%eax
  802d58:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802d5b:	8b 52 04             	mov    0x4(%edx),%edx
  802d5e:	89 50 04             	mov    %edx,0x4(%eax)
  802d61:	eb 0b                	jmp    802d6e <alloc_block_NF+0x10a>
  802d63:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802d66:	8b 40 04             	mov    0x4(%eax),%eax
  802d69:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802d6e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802d71:	8b 40 04             	mov    0x4(%eax),%eax
  802d74:	85 c0                	test   %eax,%eax
  802d76:	74 0f                	je     802d87 <alloc_block_NF+0x123>
  802d78:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802d7b:	8b 40 04             	mov    0x4(%eax),%eax
  802d7e:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802d81:	8b 12                	mov    (%edx),%edx
  802d83:	89 10                	mov    %edx,(%eax)
  802d85:	eb 0a                	jmp    802d91 <alloc_block_NF+0x12d>
  802d87:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802d8a:	8b 00                	mov    (%eax),%eax
  802d8c:	a3 48 41 80 00       	mov    %eax,0x804148
  802d91:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802d94:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802d9a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802d9d:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802da4:	a1 54 41 80 00       	mov    0x804154,%eax
  802da9:	48                   	dec    %eax
  802daa:	a3 54 41 80 00       	mov    %eax,0x804154
			newblk->size = versize;
  802daf:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802db2:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802db5:	89 50 0c             	mov    %edx,0xc(%eax)
			blk->size = blk->size-versize;
  802db8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802dbb:	8b 40 0c             	mov    0xc(%eax),%eax
  802dbe:	2b 45 f0             	sub    -0x10(%ebp),%eax
  802dc1:	89 c2                	mov    %eax,%edx
  802dc3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802dc6:	89 50 0c             	mov    %edx,0xc(%eax)
			uint32 newveradd = blk->sva;
  802dc9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802dcc:	8b 40 08             	mov    0x8(%eax),%eax
  802dcf:	89 45 e8             	mov    %eax,-0x18(%ebp)
			blk->sva+=newblk->size;
  802dd2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802dd5:	8b 50 08             	mov    0x8(%eax),%edx
  802dd8:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802ddb:	8b 40 0c             	mov    0xc(%eax),%eax
  802dde:	01 c2                	add    %eax,%edx
  802de0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802de3:	89 50 08             	mov    %edx,0x8(%eax)
			newblk->sva = newveradd;
  802de6:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802de9:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802dec:	89 50 08             	mov    %edx,0x8(%eax)
			return newblk;
  802def:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802df2:	eb 3b                	jmp    802e2f <alloc_block_NF+0x1cb>
	//panic("alloc_block_NF() is not implemented yet...!!");
	uint32 versize = size;
	struct MemBlock* blk;
	struct MemBlock* newblk = LIST_FIRST(&AvailableMemBlocksList);

	LIST_FOREACH(blk,&FreeMemBlocksList)
  802df4:	a1 40 41 80 00       	mov    0x804140,%eax
  802df9:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802dfc:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802e00:	74 07                	je     802e09 <alloc_block_NF+0x1a5>
  802e02:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e05:	8b 00                	mov    (%eax),%eax
  802e07:	eb 05                	jmp    802e0e <alloc_block_NF+0x1aa>
  802e09:	b8 00 00 00 00       	mov    $0x0,%eax
  802e0e:	a3 40 41 80 00       	mov    %eax,0x804140
  802e13:	a1 40 41 80 00       	mov    0x804140,%eax
  802e18:	85 c0                	test   %eax,%eax
  802e1a:	0f 85 65 fe ff ff    	jne    802c85 <alloc_block_NF+0x21>
  802e20:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802e24:	0f 85 5b fe ff ff    	jne    802c85 <alloc_block_NF+0x21>
			blk->sva+=newblk->size;
			newblk->sva = newveradd;
			return newblk;
		}
	}
	return NULL;
  802e2a:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802e2f:	c9                   	leave  
  802e30:	c3                   	ret    

00802e31 <addToAvailMemBlocksList>:

//===================================================
// [8] INSERT BLOCK (SORTED WITH MERGE) IN FREE LIST:
//===================================================
void addToAvailMemBlocksList(struct MemBlock *blockToInsert)
{
  802e31:	55                   	push   %ebp
  802e32:	89 e5                	mov    %esp,%ebp
  802e34:	83 ec 08             	sub    $0x8,%esp
	blockToInsert->sva = 0;
  802e37:	8b 45 08             	mov    0x8(%ebp),%eax
  802e3a:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
	blockToInsert->size = 0;
  802e41:	8b 45 08             	mov    0x8(%ebp),%eax
  802e44:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
	//add to avail
	LIST_INSERT_TAIL(&AvailableMemBlocksList, blockToInsert);
  802e4b:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802e4f:	75 17                	jne    802e68 <addToAvailMemBlocksList+0x37>
  802e51:	83 ec 04             	sub    $0x4,%esp
  802e54:	68 d0 3e 80 00       	push   $0x803ed0
  802e59:	68 10 01 00 00       	push   $0x110
  802e5e:	68 b7 3e 80 00       	push   $0x803eb7
  802e63:	e8 b6 d8 ff ff       	call   80071e <_panic>
  802e68:	8b 15 4c 41 80 00    	mov    0x80414c,%edx
  802e6e:	8b 45 08             	mov    0x8(%ebp),%eax
  802e71:	89 50 04             	mov    %edx,0x4(%eax)
  802e74:	8b 45 08             	mov    0x8(%ebp),%eax
  802e77:	8b 40 04             	mov    0x4(%eax),%eax
  802e7a:	85 c0                	test   %eax,%eax
  802e7c:	74 0c                	je     802e8a <addToAvailMemBlocksList+0x59>
  802e7e:	a1 4c 41 80 00       	mov    0x80414c,%eax
  802e83:	8b 55 08             	mov    0x8(%ebp),%edx
  802e86:	89 10                	mov    %edx,(%eax)
  802e88:	eb 08                	jmp    802e92 <addToAvailMemBlocksList+0x61>
  802e8a:	8b 45 08             	mov    0x8(%ebp),%eax
  802e8d:	a3 48 41 80 00       	mov    %eax,0x804148
  802e92:	8b 45 08             	mov    0x8(%ebp),%eax
  802e95:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802e9a:	8b 45 08             	mov    0x8(%ebp),%eax
  802e9d:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802ea3:	a1 54 41 80 00       	mov    0x804154,%eax
  802ea8:	40                   	inc    %eax
  802ea9:	a3 54 41 80 00       	mov    %eax,0x804154
}
  802eae:	90                   	nop
  802eaf:	c9                   	leave  
  802eb0:	c3                   	ret    

00802eb1 <insert_sorted_with_merge_freeList>:
void insert_sorted_with_merge_freeList(struct MemBlock *blockToInsert)
{
  802eb1:	55                   	push   %ebp
  802eb2:	89 e5                	mov    %esp,%ebp
  802eb4:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] insert_sorted_with_merge_freeList
	// Write your code here, remove the panic and write your code

	struct MemBlock* last = LIST_LAST(&FreeMemBlocksList);
  802eb7:	a1 3c 41 80 00       	mov    0x80413c,%eax
  802ebc:	89 45 f0             	mov    %eax,-0x10(%ebp)
	//check if list empty
	if (LIST_SIZE(&(FreeMemBlocksList)) == 0)
  802ebf:	a1 44 41 80 00       	mov    0x804144,%eax
  802ec4:	85 c0                	test   %eax,%eax
  802ec6:	75 68                	jne    802f30 <insert_sorted_with_merge_freeList+0x7f>
		LIST_INSERT_HEAD(&FreeMemBlocksList, blockToInsert);
  802ec8:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802ecc:	75 17                	jne    802ee5 <insert_sorted_with_merge_freeList+0x34>
  802ece:	83 ec 04             	sub    $0x4,%esp
  802ed1:	68 94 3e 80 00       	push   $0x803e94
  802ed6:	68 1a 01 00 00       	push   $0x11a
  802edb:	68 b7 3e 80 00       	push   $0x803eb7
  802ee0:	e8 39 d8 ff ff       	call   80071e <_panic>
  802ee5:	8b 15 38 41 80 00    	mov    0x804138,%edx
  802eeb:	8b 45 08             	mov    0x8(%ebp),%eax
  802eee:	89 10                	mov    %edx,(%eax)
  802ef0:	8b 45 08             	mov    0x8(%ebp),%eax
  802ef3:	8b 00                	mov    (%eax),%eax
  802ef5:	85 c0                	test   %eax,%eax
  802ef7:	74 0d                	je     802f06 <insert_sorted_with_merge_freeList+0x55>
  802ef9:	a1 38 41 80 00       	mov    0x804138,%eax
  802efe:	8b 55 08             	mov    0x8(%ebp),%edx
  802f01:	89 50 04             	mov    %edx,0x4(%eax)
  802f04:	eb 08                	jmp    802f0e <insert_sorted_with_merge_freeList+0x5d>
  802f06:	8b 45 08             	mov    0x8(%ebp),%eax
  802f09:	a3 3c 41 80 00       	mov    %eax,0x80413c
  802f0e:	8b 45 08             	mov    0x8(%ebp),%eax
  802f11:	a3 38 41 80 00       	mov    %eax,0x804138
  802f16:	8b 45 08             	mov    0x8(%ebp),%eax
  802f19:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802f20:	a1 44 41 80 00       	mov    0x804144,%eax
  802f25:	40                   	inc    %eax
  802f26:	a3 44 41 80 00       	mov    %eax,0x804144
		}
	}

	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  802f2b:	e9 c5 03 00 00       	jmp    8032f5 <insert_sorted_with_merge_freeList+0x444>
	struct MemBlock* last = LIST_LAST(&FreeMemBlocksList);
	//check if list empty
	if (LIST_SIZE(&(FreeMemBlocksList)) == 0)
		LIST_INSERT_HEAD(&FreeMemBlocksList, blockToInsert);
	//check if it's position is at last
	else if (last->sva < blockToInsert->sva) {
  802f30:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802f33:	8b 50 08             	mov    0x8(%eax),%edx
  802f36:	8b 45 08             	mov    0x8(%ebp),%eax
  802f39:	8b 40 08             	mov    0x8(%eax),%eax
  802f3c:	39 c2                	cmp    %eax,%edx
  802f3e:	0f 83 b2 00 00 00    	jae    802ff6 <insert_sorted_with_merge_freeList+0x145>

		//if i have to merge
		if (last->sva + last->size == blockToInsert->sva) {
  802f44:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802f47:	8b 50 08             	mov    0x8(%eax),%edx
  802f4a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802f4d:	8b 40 0c             	mov    0xc(%eax),%eax
  802f50:	01 c2                	add    %eax,%edx
  802f52:	8b 45 08             	mov    0x8(%ebp),%eax
  802f55:	8b 40 08             	mov    0x8(%eax),%eax
  802f58:	39 c2                	cmp    %eax,%edx
  802f5a:	75 27                	jne    802f83 <insert_sorted_with_merge_freeList+0xd2>
			last->size = last->size + blockToInsert->size;
  802f5c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802f5f:	8b 50 0c             	mov    0xc(%eax),%edx
  802f62:	8b 45 08             	mov    0x8(%ebp),%eax
  802f65:	8b 40 0c             	mov    0xc(%eax),%eax
  802f68:	01 c2                	add    %eax,%edx
  802f6a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802f6d:	89 50 0c             	mov    %edx,0xc(%eax)
			addToAvailMemBlocksList(blockToInsert);
  802f70:	83 ec 0c             	sub    $0xc,%esp
  802f73:	ff 75 08             	pushl  0x8(%ebp)
  802f76:	e8 b6 fe ff ff       	call   802e31 <addToAvailMemBlocksList>
  802f7b:	83 c4 10             	add    $0x10,%esp
		}
	}

	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  802f7e:	e9 72 03 00 00       	jmp    8032f5 <insert_sorted_with_merge_freeList+0x444>
		if (last->sva + last->size == blockToInsert->sva) {
			last->size = last->size + blockToInsert->size;
			addToAvailMemBlocksList(blockToInsert);

		} else {
			LIST_INSERT_AFTER(&FreeMemBlocksList, last, blockToInsert);
  802f83:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802f87:	74 06                	je     802f8f <insert_sorted_with_merge_freeList+0xde>
  802f89:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802f8d:	75 17                	jne    802fa6 <insert_sorted_with_merge_freeList+0xf5>
  802f8f:	83 ec 04             	sub    $0x4,%esp
  802f92:	68 f4 3e 80 00       	push   $0x803ef4
  802f97:	68 24 01 00 00       	push   $0x124
  802f9c:	68 b7 3e 80 00       	push   $0x803eb7
  802fa1:	e8 78 d7 ff ff       	call   80071e <_panic>
  802fa6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802fa9:	8b 10                	mov    (%eax),%edx
  802fab:	8b 45 08             	mov    0x8(%ebp),%eax
  802fae:	89 10                	mov    %edx,(%eax)
  802fb0:	8b 45 08             	mov    0x8(%ebp),%eax
  802fb3:	8b 00                	mov    (%eax),%eax
  802fb5:	85 c0                	test   %eax,%eax
  802fb7:	74 0b                	je     802fc4 <insert_sorted_with_merge_freeList+0x113>
  802fb9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802fbc:	8b 00                	mov    (%eax),%eax
  802fbe:	8b 55 08             	mov    0x8(%ebp),%edx
  802fc1:	89 50 04             	mov    %edx,0x4(%eax)
  802fc4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802fc7:	8b 55 08             	mov    0x8(%ebp),%edx
  802fca:	89 10                	mov    %edx,(%eax)
  802fcc:	8b 45 08             	mov    0x8(%ebp),%eax
  802fcf:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802fd2:	89 50 04             	mov    %edx,0x4(%eax)
  802fd5:	8b 45 08             	mov    0x8(%ebp),%eax
  802fd8:	8b 00                	mov    (%eax),%eax
  802fda:	85 c0                	test   %eax,%eax
  802fdc:	75 08                	jne    802fe6 <insert_sorted_with_merge_freeList+0x135>
  802fde:	8b 45 08             	mov    0x8(%ebp),%eax
  802fe1:	a3 3c 41 80 00       	mov    %eax,0x80413c
  802fe6:	a1 44 41 80 00       	mov    0x804144,%eax
  802feb:	40                   	inc    %eax
  802fec:	a3 44 41 80 00       	mov    %eax,0x804144
		}
	}

	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  802ff1:	e9 ff 02 00 00       	jmp    8032f5 <insert_sorted_with_merge_freeList+0x444>
		} else {
			LIST_INSERT_AFTER(&FreeMemBlocksList, last, blockToInsert);
		}
	} else {
		struct MemBlock *iterator;
		LIST_FOREACH(iterator, &(FreeMemBlocksList))
  802ff6:	a1 38 41 80 00       	mov    0x804138,%eax
  802ffb:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802ffe:	e9 c2 02 00 00       	jmp    8032c5 <insert_sorted_with_merge_freeList+0x414>
		{

			if (iterator->sva > blockToInsert->sva) {
  803003:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803006:	8b 50 08             	mov    0x8(%eax),%edx
  803009:	8b 45 08             	mov    0x8(%ebp),%eax
  80300c:	8b 40 08             	mov    0x8(%eax),%eax
  80300f:	39 c2                	cmp    %eax,%edx
  803011:	0f 86 a6 02 00 00    	jbe    8032bd <insert_sorted_with_merge_freeList+0x40c>

				struct MemBlock* prev = LIST_PREV(iterator);
  803017:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80301a:	8b 40 04             	mov    0x4(%eax),%eax
  80301d:	89 45 ec             	mov    %eax,-0x14(%ebp)
				if (prev == NULL) {
  803020:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  803024:	0f 85 ba 00 00 00    	jne    8030e4 <insert_sorted_with_merge_freeList+0x233>
					//check merge
					if (blockToInsert->size + blockToInsert->sva
  80302a:	8b 45 08             	mov    0x8(%ebp),%eax
  80302d:	8b 50 0c             	mov    0xc(%eax),%edx
  803030:	8b 45 08             	mov    0x8(%ebp),%eax
  803033:	8b 40 08             	mov    0x8(%eax),%eax
  803036:	01 c2                	add    %eax,%edx
							== iterator->sva) {
  803038:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80303b:	8b 40 08             	mov    0x8(%eax),%eax
			if (iterator->sva > blockToInsert->sva) {

				struct MemBlock* prev = LIST_PREV(iterator);
				if (prev == NULL) {
					//check merge
					if (blockToInsert->size + blockToInsert->sva
  80303e:	39 c2                	cmp    %eax,%edx
  803040:	75 33                	jne    803075 <insert_sorted_with_merge_freeList+0x1c4>
							== iterator->sva) {
						iterator->sva = blockToInsert->sva;
  803042:	8b 45 08             	mov    0x8(%ebp),%eax
  803045:	8b 50 08             	mov    0x8(%eax),%edx
  803048:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80304b:	89 50 08             	mov    %edx,0x8(%eax)
						iterator->size = iterator->size + blockToInsert->size;
  80304e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803051:	8b 50 0c             	mov    0xc(%eax),%edx
  803054:	8b 45 08             	mov    0x8(%ebp),%eax
  803057:	8b 40 0c             	mov    0xc(%eax),%eax
  80305a:	01 c2                	add    %eax,%edx
  80305c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80305f:	89 50 0c             	mov    %edx,0xc(%eax)
						addToAvailMemBlocksList(blockToInsert);
  803062:	83 ec 0c             	sub    $0xc,%esp
  803065:	ff 75 08             	pushl  0x8(%ebp)
  803068:	e8 c4 fd ff ff       	call   802e31 <addToAvailMemBlocksList>
  80306d:	83 c4 10             	add    $0x10,%esp

					else {
						LIST_INSERT_BEFORE(&FreeMemBlocksList, iterator,
								blockToInsert);
					}
					break;
  803070:	e9 80 02 00 00       	jmp    8032f5 <insert_sorted_with_merge_freeList+0x444>
						addToAvailMemBlocksList(blockToInsert);

					}

					else {
						LIST_INSERT_BEFORE(&FreeMemBlocksList, iterator,
  803075:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803079:	74 06                	je     803081 <insert_sorted_with_merge_freeList+0x1d0>
  80307b:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80307f:	75 17                	jne    803098 <insert_sorted_with_merge_freeList+0x1e7>
  803081:	83 ec 04             	sub    $0x4,%esp
  803084:	68 48 3f 80 00       	push   $0x803f48
  803089:	68 3a 01 00 00       	push   $0x13a
  80308e:	68 b7 3e 80 00       	push   $0x803eb7
  803093:	e8 86 d6 ff ff       	call   80071e <_panic>
  803098:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80309b:	8b 50 04             	mov    0x4(%eax),%edx
  80309e:	8b 45 08             	mov    0x8(%ebp),%eax
  8030a1:	89 50 04             	mov    %edx,0x4(%eax)
  8030a4:	8b 45 08             	mov    0x8(%ebp),%eax
  8030a7:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8030aa:	89 10                	mov    %edx,(%eax)
  8030ac:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030af:	8b 40 04             	mov    0x4(%eax),%eax
  8030b2:	85 c0                	test   %eax,%eax
  8030b4:	74 0d                	je     8030c3 <insert_sorted_with_merge_freeList+0x212>
  8030b6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030b9:	8b 40 04             	mov    0x4(%eax),%eax
  8030bc:	8b 55 08             	mov    0x8(%ebp),%edx
  8030bf:	89 10                	mov    %edx,(%eax)
  8030c1:	eb 08                	jmp    8030cb <insert_sorted_with_merge_freeList+0x21a>
  8030c3:	8b 45 08             	mov    0x8(%ebp),%eax
  8030c6:	a3 38 41 80 00       	mov    %eax,0x804138
  8030cb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030ce:	8b 55 08             	mov    0x8(%ebp),%edx
  8030d1:	89 50 04             	mov    %edx,0x4(%eax)
  8030d4:	a1 44 41 80 00       	mov    0x804144,%eax
  8030d9:	40                   	inc    %eax
  8030da:	a3 44 41 80 00       	mov    %eax,0x804144
								blockToInsert);
					}
					break;
  8030df:	e9 11 02 00 00       	jmp    8032f5 <insert_sorted_with_merge_freeList+0x444>
				} else {
					//prev and next merge
					if (prev->sva + prev->size + blockToInsert->size
  8030e4:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8030e7:	8b 50 08             	mov    0x8(%eax),%edx
  8030ea:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8030ed:	8b 40 0c             	mov    0xc(%eax),%eax
  8030f0:	01 c2                	add    %eax,%edx
  8030f2:	8b 45 08             	mov    0x8(%ebp),%eax
  8030f5:	8b 40 0c             	mov    0xc(%eax),%eax
  8030f8:	01 c2                	add    %eax,%edx
							== iterator->sva) {
  8030fa:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030fd:	8b 40 08             	mov    0x8(%eax),%eax
								blockToInsert);
					}
					break;
				} else {
					//prev and next merge
					if (prev->sva + prev->size + blockToInsert->size
  803100:	39 c2                	cmp    %eax,%edx
  803102:	0f 85 bf 00 00 00    	jne    8031c7 <insert_sorted_with_merge_freeList+0x316>
							== iterator->sva) {
						prev->size = prev->size + blockToInsert->size
  803108:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80310b:	8b 50 0c             	mov    0xc(%eax),%edx
  80310e:	8b 45 08             	mov    0x8(%ebp),%eax
  803111:	8b 40 0c             	mov    0xc(%eax),%eax
  803114:	01 c2                	add    %eax,%edx
								+ iterator->size;
  803116:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803119:	8b 40 0c             	mov    0xc(%eax),%eax
  80311c:	01 c2                	add    %eax,%edx
					break;
				} else {
					//prev and next merge
					if (prev->sva + prev->size + blockToInsert->size
							== iterator->sva) {
						prev->size = prev->size + blockToInsert->size
  80311e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803121:	89 50 0c             	mov    %edx,0xc(%eax)
								+ iterator->size;
						LIST_REMOVE(&FreeMemBlocksList, iterator);
  803124:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803128:	75 17                	jne    803141 <insert_sorted_with_merge_freeList+0x290>
  80312a:	83 ec 04             	sub    $0x4,%esp
  80312d:	68 28 3f 80 00       	push   $0x803f28
  803132:	68 43 01 00 00       	push   $0x143
  803137:	68 b7 3e 80 00       	push   $0x803eb7
  80313c:	e8 dd d5 ff ff       	call   80071e <_panic>
  803141:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803144:	8b 00                	mov    (%eax),%eax
  803146:	85 c0                	test   %eax,%eax
  803148:	74 10                	je     80315a <insert_sorted_with_merge_freeList+0x2a9>
  80314a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80314d:	8b 00                	mov    (%eax),%eax
  80314f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803152:	8b 52 04             	mov    0x4(%edx),%edx
  803155:	89 50 04             	mov    %edx,0x4(%eax)
  803158:	eb 0b                	jmp    803165 <insert_sorted_with_merge_freeList+0x2b4>
  80315a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80315d:	8b 40 04             	mov    0x4(%eax),%eax
  803160:	a3 3c 41 80 00       	mov    %eax,0x80413c
  803165:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803168:	8b 40 04             	mov    0x4(%eax),%eax
  80316b:	85 c0                	test   %eax,%eax
  80316d:	74 0f                	je     80317e <insert_sorted_with_merge_freeList+0x2cd>
  80316f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803172:	8b 40 04             	mov    0x4(%eax),%eax
  803175:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803178:	8b 12                	mov    (%edx),%edx
  80317a:	89 10                	mov    %edx,(%eax)
  80317c:	eb 0a                	jmp    803188 <insert_sorted_with_merge_freeList+0x2d7>
  80317e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803181:	8b 00                	mov    (%eax),%eax
  803183:	a3 38 41 80 00       	mov    %eax,0x804138
  803188:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80318b:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803191:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803194:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80319b:	a1 44 41 80 00       	mov    0x804144,%eax
  8031a0:	48                   	dec    %eax
  8031a1:	a3 44 41 80 00       	mov    %eax,0x804144
						addToAvailMemBlocksList(blockToInsert);
  8031a6:	83 ec 0c             	sub    $0xc,%esp
  8031a9:	ff 75 08             	pushl  0x8(%ebp)
  8031ac:	e8 80 fc ff ff       	call   802e31 <addToAvailMemBlocksList>
  8031b1:	83 c4 10             	add    $0x10,%esp
						addToAvailMemBlocksList(iterator);
  8031b4:	83 ec 0c             	sub    $0xc,%esp
  8031b7:	ff 75 f4             	pushl  -0xc(%ebp)
  8031ba:	e8 72 fc ff ff       	call   802e31 <addToAvailMemBlocksList>
  8031bf:	83 c4 10             	add    $0x10,%esp
					//Insert
					else {
						LIST_INSERT_BEFORE(&FreeMemBlocksList, iterator,
								blockToInsert);
					}
					break;
  8031c2:	e9 2e 01 00 00       	jmp    8032f5 <insert_sorted_with_merge_freeList+0x444>
						LIST_REMOVE(&FreeMemBlocksList, iterator);
						addToAvailMemBlocksList(blockToInsert);
						addToAvailMemBlocksList(iterator);
					}
					//previous merge
					else if (prev->sva + prev->size == blockToInsert->sva) {
  8031c7:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8031ca:	8b 50 08             	mov    0x8(%eax),%edx
  8031cd:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8031d0:	8b 40 0c             	mov    0xc(%eax),%eax
  8031d3:	01 c2                	add    %eax,%edx
  8031d5:	8b 45 08             	mov    0x8(%ebp),%eax
  8031d8:	8b 40 08             	mov    0x8(%eax),%eax
  8031db:	39 c2                	cmp    %eax,%edx
  8031dd:	75 27                	jne    803206 <insert_sorted_with_merge_freeList+0x355>
						prev->size = prev->size + blockToInsert->size;
  8031df:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8031e2:	8b 50 0c             	mov    0xc(%eax),%edx
  8031e5:	8b 45 08             	mov    0x8(%ebp),%eax
  8031e8:	8b 40 0c             	mov    0xc(%eax),%eax
  8031eb:	01 c2                	add    %eax,%edx
  8031ed:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8031f0:	89 50 0c             	mov    %edx,0xc(%eax)
						addToAvailMemBlocksList(blockToInsert);
  8031f3:	83 ec 0c             	sub    $0xc,%esp
  8031f6:	ff 75 08             	pushl  0x8(%ebp)
  8031f9:	e8 33 fc ff ff       	call   802e31 <addToAvailMemBlocksList>
  8031fe:	83 c4 10             	add    $0x10,%esp
					//Insert
					else {
						LIST_INSERT_BEFORE(&FreeMemBlocksList, iterator,
								blockToInsert);
					}
					break;
  803201:	e9 ef 00 00 00       	jmp    8032f5 <insert_sorted_with_merge_freeList+0x444>
					else if (prev->sva + prev->size == blockToInsert->sva) {
						prev->size = prev->size + blockToInsert->size;
						addToAvailMemBlocksList(blockToInsert);
					}
					//next merge
					else if (blockToInsert->size + blockToInsert->sva
  803206:	8b 45 08             	mov    0x8(%ebp),%eax
  803209:	8b 50 0c             	mov    0xc(%eax),%edx
  80320c:	8b 45 08             	mov    0x8(%ebp),%eax
  80320f:	8b 40 08             	mov    0x8(%eax),%eax
  803212:	01 c2                	add    %eax,%edx
							== iterator->sva) {
  803214:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803217:	8b 40 08             	mov    0x8(%eax),%eax
					else if (prev->sva + prev->size == blockToInsert->sva) {
						prev->size = prev->size + blockToInsert->size;
						addToAvailMemBlocksList(blockToInsert);
					}
					//next merge
					else if (blockToInsert->size + blockToInsert->sva
  80321a:	39 c2                	cmp    %eax,%edx
  80321c:	75 33                	jne    803251 <insert_sorted_with_merge_freeList+0x3a0>
							== iterator->sva) {
						iterator->sva = blockToInsert->sva;
  80321e:	8b 45 08             	mov    0x8(%ebp),%eax
  803221:	8b 50 08             	mov    0x8(%eax),%edx
  803224:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803227:	89 50 08             	mov    %edx,0x8(%eax)
						iterator->size = iterator->size + blockToInsert->size;
  80322a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80322d:	8b 50 0c             	mov    0xc(%eax),%edx
  803230:	8b 45 08             	mov    0x8(%ebp),%eax
  803233:	8b 40 0c             	mov    0xc(%eax),%eax
  803236:	01 c2                	add    %eax,%edx
  803238:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80323b:	89 50 0c             	mov    %edx,0xc(%eax)
						addToAvailMemBlocksList(blockToInsert);
  80323e:	83 ec 0c             	sub    $0xc,%esp
  803241:	ff 75 08             	pushl  0x8(%ebp)
  803244:	e8 e8 fb ff ff       	call   802e31 <addToAvailMemBlocksList>
  803249:	83 c4 10             	add    $0x10,%esp
					//Insert
					else {
						LIST_INSERT_BEFORE(&FreeMemBlocksList, iterator,
								blockToInsert);
					}
					break;
  80324c:	e9 a4 00 00 00       	jmp    8032f5 <insert_sorted_with_merge_freeList+0x444>
						iterator->size = iterator->size + blockToInsert->size;
						addToAvailMemBlocksList(blockToInsert);
					}
					//Insert
					else {
						LIST_INSERT_BEFORE(&FreeMemBlocksList, iterator,
  803251:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803255:	74 06                	je     80325d <insert_sorted_with_merge_freeList+0x3ac>
  803257:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80325b:	75 17                	jne    803274 <insert_sorted_with_merge_freeList+0x3c3>
  80325d:	83 ec 04             	sub    $0x4,%esp
  803260:	68 48 3f 80 00       	push   $0x803f48
  803265:	68 56 01 00 00       	push   $0x156
  80326a:	68 b7 3e 80 00       	push   $0x803eb7
  80326f:	e8 aa d4 ff ff       	call   80071e <_panic>
  803274:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803277:	8b 50 04             	mov    0x4(%eax),%edx
  80327a:	8b 45 08             	mov    0x8(%ebp),%eax
  80327d:	89 50 04             	mov    %edx,0x4(%eax)
  803280:	8b 45 08             	mov    0x8(%ebp),%eax
  803283:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803286:	89 10                	mov    %edx,(%eax)
  803288:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80328b:	8b 40 04             	mov    0x4(%eax),%eax
  80328e:	85 c0                	test   %eax,%eax
  803290:	74 0d                	je     80329f <insert_sorted_with_merge_freeList+0x3ee>
  803292:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803295:	8b 40 04             	mov    0x4(%eax),%eax
  803298:	8b 55 08             	mov    0x8(%ebp),%edx
  80329b:	89 10                	mov    %edx,(%eax)
  80329d:	eb 08                	jmp    8032a7 <insert_sorted_with_merge_freeList+0x3f6>
  80329f:	8b 45 08             	mov    0x8(%ebp),%eax
  8032a2:	a3 38 41 80 00       	mov    %eax,0x804138
  8032a7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8032aa:	8b 55 08             	mov    0x8(%ebp),%edx
  8032ad:	89 50 04             	mov    %edx,0x4(%eax)
  8032b0:	a1 44 41 80 00       	mov    0x804144,%eax
  8032b5:	40                   	inc    %eax
  8032b6:	a3 44 41 80 00       	mov    %eax,0x804144
								blockToInsert);
					}
					break;
  8032bb:	eb 38                	jmp    8032f5 <insert_sorted_with_merge_freeList+0x444>
		} else {
			LIST_INSERT_AFTER(&FreeMemBlocksList, last, blockToInsert);
		}
	} else {
		struct MemBlock *iterator;
		LIST_FOREACH(iterator, &(FreeMemBlocksList))
  8032bd:	a1 40 41 80 00       	mov    0x804140,%eax
  8032c2:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8032c5:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8032c9:	74 07                	je     8032d2 <insert_sorted_with_merge_freeList+0x421>
  8032cb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8032ce:	8b 00                	mov    (%eax),%eax
  8032d0:	eb 05                	jmp    8032d7 <insert_sorted_with_merge_freeList+0x426>
  8032d2:	b8 00 00 00 00       	mov    $0x0,%eax
  8032d7:	a3 40 41 80 00       	mov    %eax,0x804140
  8032dc:	a1 40 41 80 00       	mov    0x804140,%eax
  8032e1:	85 c0                	test   %eax,%eax
  8032e3:	0f 85 1a fd ff ff    	jne    803003 <insert_sorted_with_merge_freeList+0x152>
  8032e9:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8032ed:	0f 85 10 fd ff ff    	jne    803003 <insert_sorted_with_merge_freeList+0x152>
		}
	}

	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  8032f3:	eb 00                	jmp    8032f5 <insert_sorted_with_merge_freeList+0x444>
  8032f5:	90                   	nop
  8032f6:	c9                   	leave  
  8032f7:	c3                   	ret    

008032f8 <env_sleep>:
#include <inc/lib.h>
#include <inc/timerreg.h>

void
env_sleep(uint32 approxMilliSeconds)
{
  8032f8:	55                   	push   %ebp
  8032f9:	89 e5                	mov    %esp,%ebp
  8032fb:	83 ec 28             	sub    $0x28,%esp
//	cprintf("%s go to sleep...\n", myEnv->prog_name);
	uint32 time_in_cycles=approxMilliSeconds*CYCLES_PER_MILLISEC;
  8032fe:	8b 55 08             	mov    0x8(%ebp),%edx
  803301:	89 d0                	mov    %edx,%eax
  803303:	c1 e0 02             	shl    $0x2,%eax
  803306:	01 d0                	add    %edx,%eax
  803308:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80330f:	01 d0                	add    %edx,%eax
  803311:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  803318:	01 d0                	add    %edx,%eax
  80331a:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  803321:	01 d0                	add    %edx,%eax
  803323:	c1 e0 04             	shl    $0x4,%eax
  803326:	89 45 f0             	mov    %eax,-0x10(%ebp)
	uint32 cycles_counter =0;
  803329:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	struct uint64 baseTime = sys_get_virtual_time() ;
  803330:	8d 45 e8             	lea    -0x18(%ebp),%eax
  803333:	83 ec 0c             	sub    $0xc,%esp
  803336:	50                   	push   %eax
  803337:	e8 60 ed ff ff       	call   80209c <sys_get_virtual_time>
  80333c:	83 c4 0c             	add    $0xc,%esp
	while(cycles_counter<time_in_cycles)
  80333f:	eb 41                	jmp    803382 <env_sleep+0x8a>
	{
		struct uint64 currentTime = sys_get_virtual_time() ;
  803341:	8d 45 e0             	lea    -0x20(%ebp),%eax
  803344:	83 ec 0c             	sub    $0xc,%esp
  803347:	50                   	push   %eax
  803348:	e8 4f ed ff ff       	call   80209c <sys_get_virtual_time>
  80334d:	83 c4 0c             	add    $0xc,%esp

		// update the cycles_count
		#define M32 0xffffffff
		// subtract basetime from current time
		struct uint64 res;
		res.low = (currentTime.low - baseTime.low) & M32;
  803350:	8b 55 e0             	mov    -0x20(%ebp),%edx
  803353:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803356:	29 c2                	sub    %eax,%edx
  803358:	89 d0                	mov    %edx,%eax
  80335a:	89 45 d8             	mov    %eax,-0x28(%ebp)
		res.hi = (currentTime.hi - baseTime.hi - (res.low > currentTime.low)) & M32;
  80335d:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803360:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803363:	89 d1                	mov    %edx,%ecx
  803365:	29 c1                	sub    %eax,%ecx
  803367:	8b 55 d8             	mov    -0x28(%ebp),%edx
  80336a:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80336d:	39 c2                	cmp    %eax,%edx
  80336f:	0f 97 c0             	seta   %al
  803372:	0f b6 c0             	movzbl %al,%eax
  803375:	29 c1                	sub    %eax,%ecx
  803377:	89 c8                	mov    %ecx,%eax
  803379:	89 45 dc             	mov    %eax,-0x24(%ebp)

		//update cycles_count with result
		cycles_counter = res.low;
  80337c:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80337f:	89 45 f4             	mov    %eax,-0xc(%ebp)
//	cprintf("%s go to sleep...\n", myEnv->prog_name);
	uint32 time_in_cycles=approxMilliSeconds*CYCLES_PER_MILLISEC;
	uint32 cycles_counter =0;

	struct uint64 baseTime = sys_get_virtual_time() ;
	while(cycles_counter<time_in_cycles)
  803382:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803385:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  803388:	72 b7                	jb     803341 <env_sleep+0x49>
//				,cycles_counter
//				);
	}
	//cprintf("%s [%d] wake up now!\n", myEnv->prog_name, myEnv->env_id);

}
  80338a:	90                   	nop
  80338b:	c9                   	leave  
  80338c:	c3                   	ret    

0080338d <busy_wait>:

//2017
uint32 busy_wait(uint32 loopMax)
{
  80338d:	55                   	push   %ebp
  80338e:	89 e5                	mov    %esp,%ebp
  803390:	83 ec 10             	sub    $0x10,%esp
	uint32 i = 0 ;
  803393:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	while (i < loopMax) i++;
  80339a:	eb 03                	jmp    80339f <busy_wait+0x12>
  80339c:	ff 45 fc             	incl   -0x4(%ebp)
  80339f:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8033a2:	3b 45 08             	cmp    0x8(%ebp),%eax
  8033a5:	72 f5                	jb     80339c <busy_wait+0xf>
	return i;
  8033a7:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  8033aa:	c9                   	leave  
  8033ab:	c3                   	ret    

008033ac <__udivdi3>:
  8033ac:	55                   	push   %ebp
  8033ad:	57                   	push   %edi
  8033ae:	56                   	push   %esi
  8033af:	53                   	push   %ebx
  8033b0:	83 ec 1c             	sub    $0x1c,%esp
  8033b3:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  8033b7:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  8033bb:	8b 7c 24 38          	mov    0x38(%esp),%edi
  8033bf:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8033c3:	89 ca                	mov    %ecx,%edx
  8033c5:	89 f8                	mov    %edi,%eax
  8033c7:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  8033cb:	85 f6                	test   %esi,%esi
  8033cd:	75 2d                	jne    8033fc <__udivdi3+0x50>
  8033cf:	39 cf                	cmp    %ecx,%edi
  8033d1:	77 65                	ja     803438 <__udivdi3+0x8c>
  8033d3:	89 fd                	mov    %edi,%ebp
  8033d5:	85 ff                	test   %edi,%edi
  8033d7:	75 0b                	jne    8033e4 <__udivdi3+0x38>
  8033d9:	b8 01 00 00 00       	mov    $0x1,%eax
  8033de:	31 d2                	xor    %edx,%edx
  8033e0:	f7 f7                	div    %edi
  8033e2:	89 c5                	mov    %eax,%ebp
  8033e4:	31 d2                	xor    %edx,%edx
  8033e6:	89 c8                	mov    %ecx,%eax
  8033e8:	f7 f5                	div    %ebp
  8033ea:	89 c1                	mov    %eax,%ecx
  8033ec:	89 d8                	mov    %ebx,%eax
  8033ee:	f7 f5                	div    %ebp
  8033f0:	89 cf                	mov    %ecx,%edi
  8033f2:	89 fa                	mov    %edi,%edx
  8033f4:	83 c4 1c             	add    $0x1c,%esp
  8033f7:	5b                   	pop    %ebx
  8033f8:	5e                   	pop    %esi
  8033f9:	5f                   	pop    %edi
  8033fa:	5d                   	pop    %ebp
  8033fb:	c3                   	ret    
  8033fc:	39 ce                	cmp    %ecx,%esi
  8033fe:	77 28                	ja     803428 <__udivdi3+0x7c>
  803400:	0f bd fe             	bsr    %esi,%edi
  803403:	83 f7 1f             	xor    $0x1f,%edi
  803406:	75 40                	jne    803448 <__udivdi3+0x9c>
  803408:	39 ce                	cmp    %ecx,%esi
  80340a:	72 0a                	jb     803416 <__udivdi3+0x6a>
  80340c:	3b 44 24 08          	cmp    0x8(%esp),%eax
  803410:	0f 87 9e 00 00 00    	ja     8034b4 <__udivdi3+0x108>
  803416:	b8 01 00 00 00       	mov    $0x1,%eax
  80341b:	89 fa                	mov    %edi,%edx
  80341d:	83 c4 1c             	add    $0x1c,%esp
  803420:	5b                   	pop    %ebx
  803421:	5e                   	pop    %esi
  803422:	5f                   	pop    %edi
  803423:	5d                   	pop    %ebp
  803424:	c3                   	ret    
  803425:	8d 76 00             	lea    0x0(%esi),%esi
  803428:	31 ff                	xor    %edi,%edi
  80342a:	31 c0                	xor    %eax,%eax
  80342c:	89 fa                	mov    %edi,%edx
  80342e:	83 c4 1c             	add    $0x1c,%esp
  803431:	5b                   	pop    %ebx
  803432:	5e                   	pop    %esi
  803433:	5f                   	pop    %edi
  803434:	5d                   	pop    %ebp
  803435:	c3                   	ret    
  803436:	66 90                	xchg   %ax,%ax
  803438:	89 d8                	mov    %ebx,%eax
  80343a:	f7 f7                	div    %edi
  80343c:	31 ff                	xor    %edi,%edi
  80343e:	89 fa                	mov    %edi,%edx
  803440:	83 c4 1c             	add    $0x1c,%esp
  803443:	5b                   	pop    %ebx
  803444:	5e                   	pop    %esi
  803445:	5f                   	pop    %edi
  803446:	5d                   	pop    %ebp
  803447:	c3                   	ret    
  803448:	bd 20 00 00 00       	mov    $0x20,%ebp
  80344d:	89 eb                	mov    %ebp,%ebx
  80344f:	29 fb                	sub    %edi,%ebx
  803451:	89 f9                	mov    %edi,%ecx
  803453:	d3 e6                	shl    %cl,%esi
  803455:	89 c5                	mov    %eax,%ebp
  803457:	88 d9                	mov    %bl,%cl
  803459:	d3 ed                	shr    %cl,%ebp
  80345b:	89 e9                	mov    %ebp,%ecx
  80345d:	09 f1                	or     %esi,%ecx
  80345f:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  803463:	89 f9                	mov    %edi,%ecx
  803465:	d3 e0                	shl    %cl,%eax
  803467:	89 c5                	mov    %eax,%ebp
  803469:	89 d6                	mov    %edx,%esi
  80346b:	88 d9                	mov    %bl,%cl
  80346d:	d3 ee                	shr    %cl,%esi
  80346f:	89 f9                	mov    %edi,%ecx
  803471:	d3 e2                	shl    %cl,%edx
  803473:	8b 44 24 08          	mov    0x8(%esp),%eax
  803477:	88 d9                	mov    %bl,%cl
  803479:	d3 e8                	shr    %cl,%eax
  80347b:	09 c2                	or     %eax,%edx
  80347d:	89 d0                	mov    %edx,%eax
  80347f:	89 f2                	mov    %esi,%edx
  803481:	f7 74 24 0c          	divl   0xc(%esp)
  803485:	89 d6                	mov    %edx,%esi
  803487:	89 c3                	mov    %eax,%ebx
  803489:	f7 e5                	mul    %ebp
  80348b:	39 d6                	cmp    %edx,%esi
  80348d:	72 19                	jb     8034a8 <__udivdi3+0xfc>
  80348f:	74 0b                	je     80349c <__udivdi3+0xf0>
  803491:	89 d8                	mov    %ebx,%eax
  803493:	31 ff                	xor    %edi,%edi
  803495:	e9 58 ff ff ff       	jmp    8033f2 <__udivdi3+0x46>
  80349a:	66 90                	xchg   %ax,%ax
  80349c:	8b 54 24 08          	mov    0x8(%esp),%edx
  8034a0:	89 f9                	mov    %edi,%ecx
  8034a2:	d3 e2                	shl    %cl,%edx
  8034a4:	39 c2                	cmp    %eax,%edx
  8034a6:	73 e9                	jae    803491 <__udivdi3+0xe5>
  8034a8:	8d 43 ff             	lea    -0x1(%ebx),%eax
  8034ab:	31 ff                	xor    %edi,%edi
  8034ad:	e9 40 ff ff ff       	jmp    8033f2 <__udivdi3+0x46>
  8034b2:	66 90                	xchg   %ax,%ax
  8034b4:	31 c0                	xor    %eax,%eax
  8034b6:	e9 37 ff ff ff       	jmp    8033f2 <__udivdi3+0x46>
  8034bb:	90                   	nop

008034bc <__umoddi3>:
  8034bc:	55                   	push   %ebp
  8034bd:	57                   	push   %edi
  8034be:	56                   	push   %esi
  8034bf:	53                   	push   %ebx
  8034c0:	83 ec 1c             	sub    $0x1c,%esp
  8034c3:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  8034c7:	8b 74 24 34          	mov    0x34(%esp),%esi
  8034cb:	8b 7c 24 38          	mov    0x38(%esp),%edi
  8034cf:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  8034d3:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8034d7:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8034db:	89 f3                	mov    %esi,%ebx
  8034dd:	89 fa                	mov    %edi,%edx
  8034df:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8034e3:	89 34 24             	mov    %esi,(%esp)
  8034e6:	85 c0                	test   %eax,%eax
  8034e8:	75 1a                	jne    803504 <__umoddi3+0x48>
  8034ea:	39 f7                	cmp    %esi,%edi
  8034ec:	0f 86 a2 00 00 00    	jbe    803594 <__umoddi3+0xd8>
  8034f2:	89 c8                	mov    %ecx,%eax
  8034f4:	89 f2                	mov    %esi,%edx
  8034f6:	f7 f7                	div    %edi
  8034f8:	89 d0                	mov    %edx,%eax
  8034fa:	31 d2                	xor    %edx,%edx
  8034fc:	83 c4 1c             	add    $0x1c,%esp
  8034ff:	5b                   	pop    %ebx
  803500:	5e                   	pop    %esi
  803501:	5f                   	pop    %edi
  803502:	5d                   	pop    %ebp
  803503:	c3                   	ret    
  803504:	39 f0                	cmp    %esi,%eax
  803506:	0f 87 ac 00 00 00    	ja     8035b8 <__umoddi3+0xfc>
  80350c:	0f bd e8             	bsr    %eax,%ebp
  80350f:	83 f5 1f             	xor    $0x1f,%ebp
  803512:	0f 84 ac 00 00 00    	je     8035c4 <__umoddi3+0x108>
  803518:	bf 20 00 00 00       	mov    $0x20,%edi
  80351d:	29 ef                	sub    %ebp,%edi
  80351f:	89 fe                	mov    %edi,%esi
  803521:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  803525:	89 e9                	mov    %ebp,%ecx
  803527:	d3 e0                	shl    %cl,%eax
  803529:	89 d7                	mov    %edx,%edi
  80352b:	89 f1                	mov    %esi,%ecx
  80352d:	d3 ef                	shr    %cl,%edi
  80352f:	09 c7                	or     %eax,%edi
  803531:	89 e9                	mov    %ebp,%ecx
  803533:	d3 e2                	shl    %cl,%edx
  803535:	89 14 24             	mov    %edx,(%esp)
  803538:	89 d8                	mov    %ebx,%eax
  80353a:	d3 e0                	shl    %cl,%eax
  80353c:	89 c2                	mov    %eax,%edx
  80353e:	8b 44 24 08          	mov    0x8(%esp),%eax
  803542:	d3 e0                	shl    %cl,%eax
  803544:	89 44 24 04          	mov    %eax,0x4(%esp)
  803548:	8b 44 24 08          	mov    0x8(%esp),%eax
  80354c:	89 f1                	mov    %esi,%ecx
  80354e:	d3 e8                	shr    %cl,%eax
  803550:	09 d0                	or     %edx,%eax
  803552:	d3 eb                	shr    %cl,%ebx
  803554:	89 da                	mov    %ebx,%edx
  803556:	f7 f7                	div    %edi
  803558:	89 d3                	mov    %edx,%ebx
  80355a:	f7 24 24             	mull   (%esp)
  80355d:	89 c6                	mov    %eax,%esi
  80355f:	89 d1                	mov    %edx,%ecx
  803561:	39 d3                	cmp    %edx,%ebx
  803563:	0f 82 87 00 00 00    	jb     8035f0 <__umoddi3+0x134>
  803569:	0f 84 91 00 00 00    	je     803600 <__umoddi3+0x144>
  80356f:	8b 54 24 04          	mov    0x4(%esp),%edx
  803573:	29 f2                	sub    %esi,%edx
  803575:	19 cb                	sbb    %ecx,%ebx
  803577:	89 d8                	mov    %ebx,%eax
  803579:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  80357d:	d3 e0                	shl    %cl,%eax
  80357f:	89 e9                	mov    %ebp,%ecx
  803581:	d3 ea                	shr    %cl,%edx
  803583:	09 d0                	or     %edx,%eax
  803585:	89 e9                	mov    %ebp,%ecx
  803587:	d3 eb                	shr    %cl,%ebx
  803589:	89 da                	mov    %ebx,%edx
  80358b:	83 c4 1c             	add    $0x1c,%esp
  80358e:	5b                   	pop    %ebx
  80358f:	5e                   	pop    %esi
  803590:	5f                   	pop    %edi
  803591:	5d                   	pop    %ebp
  803592:	c3                   	ret    
  803593:	90                   	nop
  803594:	89 fd                	mov    %edi,%ebp
  803596:	85 ff                	test   %edi,%edi
  803598:	75 0b                	jne    8035a5 <__umoddi3+0xe9>
  80359a:	b8 01 00 00 00       	mov    $0x1,%eax
  80359f:	31 d2                	xor    %edx,%edx
  8035a1:	f7 f7                	div    %edi
  8035a3:	89 c5                	mov    %eax,%ebp
  8035a5:	89 f0                	mov    %esi,%eax
  8035a7:	31 d2                	xor    %edx,%edx
  8035a9:	f7 f5                	div    %ebp
  8035ab:	89 c8                	mov    %ecx,%eax
  8035ad:	f7 f5                	div    %ebp
  8035af:	89 d0                	mov    %edx,%eax
  8035b1:	e9 44 ff ff ff       	jmp    8034fa <__umoddi3+0x3e>
  8035b6:	66 90                	xchg   %ax,%ax
  8035b8:	89 c8                	mov    %ecx,%eax
  8035ba:	89 f2                	mov    %esi,%edx
  8035bc:	83 c4 1c             	add    $0x1c,%esp
  8035bf:	5b                   	pop    %ebx
  8035c0:	5e                   	pop    %esi
  8035c1:	5f                   	pop    %edi
  8035c2:	5d                   	pop    %ebp
  8035c3:	c3                   	ret    
  8035c4:	3b 04 24             	cmp    (%esp),%eax
  8035c7:	72 06                	jb     8035cf <__umoddi3+0x113>
  8035c9:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  8035cd:	77 0f                	ja     8035de <__umoddi3+0x122>
  8035cf:	89 f2                	mov    %esi,%edx
  8035d1:	29 f9                	sub    %edi,%ecx
  8035d3:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  8035d7:	89 14 24             	mov    %edx,(%esp)
  8035da:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8035de:	8b 44 24 04          	mov    0x4(%esp),%eax
  8035e2:	8b 14 24             	mov    (%esp),%edx
  8035e5:	83 c4 1c             	add    $0x1c,%esp
  8035e8:	5b                   	pop    %ebx
  8035e9:	5e                   	pop    %esi
  8035ea:	5f                   	pop    %edi
  8035eb:	5d                   	pop    %ebp
  8035ec:	c3                   	ret    
  8035ed:	8d 76 00             	lea    0x0(%esi),%esi
  8035f0:	2b 04 24             	sub    (%esp),%eax
  8035f3:	19 fa                	sbb    %edi,%edx
  8035f5:	89 d1                	mov    %edx,%ecx
  8035f7:	89 c6                	mov    %eax,%esi
  8035f9:	e9 71 ff ff ff       	jmp    80356f <__umoddi3+0xb3>
  8035fe:	66 90                	xchg   %ax,%ax
  803600:	39 44 24 04          	cmp    %eax,0x4(%esp)
  803604:	72 ea                	jb     8035f0 <__umoddi3+0x134>
  803606:	89 d9                	mov    %ebx,%ecx
  803608:	e9 62 ff ff ff       	jmp    80356f <__umoddi3+0xb3>
