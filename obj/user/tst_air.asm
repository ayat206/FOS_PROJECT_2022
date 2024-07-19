
obj/user/tst_air:     file format elf32-i386


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
  800031:	e8 15 0b 00 00       	call   800b4b <libmain>
1:      jmp 1b
  800036:	eb fe                	jmp    800036 <args_exist+0x5>

00800038 <_main>:
#include <user/air.h>
int find(int* arr, int size, int val);

void
_main(void)
{
  800038:	55                   	push   %ebp
  800039:	89 e5                	mov    %esp,%ebp
  80003b:	57                   	push   %edi
  80003c:	56                   	push   %esi
  80003d:	53                   	push   %ebx
  80003e:	81 ec fc 01 00 00    	sub    $0x1fc,%esp
	int envID = sys_getenvid();
  800044:	e8 57 25 00 00       	call   8025a0 <sys_getenvid>
  800049:	89 45 bc             	mov    %eax,-0x44(%ebp)

	// *************************************************************************************************
	/// Shared Variables Region ************************************************************************
	// *************************************************************************************************

	int numOfCustomers = 15;
  80004c:	c7 45 b8 0f 00 00 00 	movl   $0xf,-0x48(%ebp)
	int flight1Customers = 3;
  800053:	c7 45 b4 03 00 00 00 	movl   $0x3,-0x4c(%ebp)
	int flight2Customers = 8;
  80005a:	c7 45 b0 08 00 00 00 	movl   $0x8,-0x50(%ebp)
	int flight3Customers = 4;
  800061:	c7 45 ac 04 00 00 00 	movl   $0x4,-0x54(%ebp)

	int flight1NumOfTickets = 8;
  800068:	c7 45 a8 08 00 00 00 	movl   $0x8,-0x58(%ebp)
	int flight2NumOfTickets = 15;
  80006f:	c7 45 a4 0f 00 00 00 	movl   $0xf,-0x5c(%ebp)

	char _customers[] = "customers";
  800076:	8d 85 6a ff ff ff    	lea    -0x96(%ebp),%eax
  80007c:	bb 56 3e 80 00       	mov    $0x803e56,%ebx
  800081:	ba 0a 00 00 00       	mov    $0xa,%edx
  800086:	89 c7                	mov    %eax,%edi
  800088:	89 de                	mov    %ebx,%esi
  80008a:	89 d1                	mov    %edx,%ecx
  80008c:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
	char _custCounter[] = "custCounter";
  80008e:	8d 85 5e ff ff ff    	lea    -0xa2(%ebp),%eax
  800094:	bb 60 3e 80 00       	mov    $0x803e60,%ebx
  800099:	ba 03 00 00 00       	mov    $0x3,%edx
  80009e:	89 c7                	mov    %eax,%edi
  8000a0:	89 de                	mov    %ebx,%esi
  8000a2:	89 d1                	mov    %edx,%ecx
  8000a4:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
	char _flight1Counter[] = "flight1Counter";
  8000a6:	8d 85 4f ff ff ff    	lea    -0xb1(%ebp),%eax
  8000ac:	bb 6c 3e 80 00       	mov    $0x803e6c,%ebx
  8000b1:	ba 0f 00 00 00       	mov    $0xf,%edx
  8000b6:	89 c7                	mov    %eax,%edi
  8000b8:	89 de                	mov    %ebx,%esi
  8000ba:	89 d1                	mov    %edx,%ecx
  8000bc:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
	char _flight2Counter[] = "flight2Counter";
  8000be:	8d 85 40 ff ff ff    	lea    -0xc0(%ebp),%eax
  8000c4:	bb 7b 3e 80 00       	mov    $0x803e7b,%ebx
  8000c9:	ba 0f 00 00 00       	mov    $0xf,%edx
  8000ce:	89 c7                	mov    %eax,%edi
  8000d0:	89 de                	mov    %ebx,%esi
  8000d2:	89 d1                	mov    %edx,%ecx
  8000d4:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
	char _flightBooked1Counter[] = "flightBooked1Counter";
  8000d6:	8d 85 2b ff ff ff    	lea    -0xd5(%ebp),%eax
  8000dc:	bb 8a 3e 80 00       	mov    $0x803e8a,%ebx
  8000e1:	ba 15 00 00 00       	mov    $0x15,%edx
  8000e6:	89 c7                	mov    %eax,%edi
  8000e8:	89 de                	mov    %ebx,%esi
  8000ea:	89 d1                	mov    %edx,%ecx
  8000ec:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
	char _flightBooked2Counter[] = "flightBooked2Counter";
  8000ee:	8d 85 16 ff ff ff    	lea    -0xea(%ebp),%eax
  8000f4:	bb 9f 3e 80 00       	mov    $0x803e9f,%ebx
  8000f9:	ba 15 00 00 00       	mov    $0x15,%edx
  8000fe:	89 c7                	mov    %eax,%edi
  800100:	89 de                	mov    %ebx,%esi
  800102:	89 d1                	mov    %edx,%ecx
  800104:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
	char _flightBooked1Arr[] = "flightBooked1Arr";
  800106:	8d 85 05 ff ff ff    	lea    -0xfb(%ebp),%eax
  80010c:	bb b4 3e 80 00       	mov    $0x803eb4,%ebx
  800111:	ba 11 00 00 00       	mov    $0x11,%edx
  800116:	89 c7                	mov    %eax,%edi
  800118:	89 de                	mov    %ebx,%esi
  80011a:	89 d1                	mov    %edx,%ecx
  80011c:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
	char _flightBooked2Arr[] = "flightBooked2Arr";
  80011e:	8d 85 f4 fe ff ff    	lea    -0x10c(%ebp),%eax
  800124:	bb c5 3e 80 00       	mov    $0x803ec5,%ebx
  800129:	ba 11 00 00 00       	mov    $0x11,%edx
  80012e:	89 c7                	mov    %eax,%edi
  800130:	89 de                	mov    %ebx,%esi
  800132:	89 d1                	mov    %edx,%ecx
  800134:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
	char _cust_ready_queue[] = "cust_ready_queue";
  800136:	8d 85 e3 fe ff ff    	lea    -0x11d(%ebp),%eax
  80013c:	bb d6 3e 80 00       	mov    $0x803ed6,%ebx
  800141:	ba 11 00 00 00       	mov    $0x11,%edx
  800146:	89 c7                	mov    %eax,%edi
  800148:	89 de                	mov    %ebx,%esi
  80014a:	89 d1                	mov    %edx,%ecx
  80014c:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
	char _queue_in[] = "queue_in";
  80014e:	8d 85 da fe ff ff    	lea    -0x126(%ebp),%eax
  800154:	bb e7 3e 80 00       	mov    $0x803ee7,%ebx
  800159:	ba 09 00 00 00       	mov    $0x9,%edx
  80015e:	89 c7                	mov    %eax,%edi
  800160:	89 de                	mov    %ebx,%esi
  800162:	89 d1                	mov    %edx,%ecx
  800164:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
	char _queue_out[] = "queue_out";
  800166:	8d 85 d0 fe ff ff    	lea    -0x130(%ebp),%eax
  80016c:	bb f0 3e 80 00       	mov    $0x803ef0,%ebx
  800171:	ba 0a 00 00 00       	mov    $0xa,%edx
  800176:	89 c7                	mov    %eax,%edi
  800178:	89 de                	mov    %ebx,%esi
  80017a:	89 d1                	mov    %edx,%ecx
  80017c:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)

	char _cust_ready[] = "cust_ready";
  80017e:	8d 85 c5 fe ff ff    	lea    -0x13b(%ebp),%eax
  800184:	bb fa 3e 80 00       	mov    $0x803efa,%ebx
  800189:	ba 0b 00 00 00       	mov    $0xb,%edx
  80018e:	89 c7                	mov    %eax,%edi
  800190:	89 de                	mov    %ebx,%esi
  800192:	89 d1                	mov    %edx,%ecx
  800194:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
	char _custQueueCS[] = "custQueueCS";
  800196:	8d 85 b9 fe ff ff    	lea    -0x147(%ebp),%eax
  80019c:	bb 05 3f 80 00       	mov    $0x803f05,%ebx
  8001a1:	ba 03 00 00 00       	mov    $0x3,%edx
  8001a6:	89 c7                	mov    %eax,%edi
  8001a8:	89 de                	mov    %ebx,%esi
  8001aa:	89 d1                	mov    %edx,%ecx
  8001ac:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
	char _flight1CS[] = "flight1CS";
  8001ae:	8d 85 af fe ff ff    	lea    -0x151(%ebp),%eax
  8001b4:	bb 11 3f 80 00       	mov    $0x803f11,%ebx
  8001b9:	ba 0a 00 00 00       	mov    $0xa,%edx
  8001be:	89 c7                	mov    %eax,%edi
  8001c0:	89 de                	mov    %ebx,%esi
  8001c2:	89 d1                	mov    %edx,%ecx
  8001c4:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
	char _flight2CS[] = "flight2CS";
  8001c6:	8d 85 a5 fe ff ff    	lea    -0x15b(%ebp),%eax
  8001cc:	bb 1b 3f 80 00       	mov    $0x803f1b,%ebx
  8001d1:	ba 0a 00 00 00       	mov    $0xa,%edx
  8001d6:	89 c7                	mov    %eax,%edi
  8001d8:	89 de                	mov    %ebx,%esi
  8001da:	89 d1                	mov    %edx,%ecx
  8001dc:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)

	char _clerk[] = "clerk";
  8001de:	c7 85 9f fe ff ff 63 	movl   $0x72656c63,-0x161(%ebp)
  8001e5:	6c 65 72 
  8001e8:	66 c7 85 a3 fe ff ff 	movw   $0x6b,-0x15d(%ebp)
  8001ef:	6b 00 
	char _custCounterCS[] = "custCounterCS";
  8001f1:	8d 85 91 fe ff ff    	lea    -0x16f(%ebp),%eax
  8001f7:	bb 25 3f 80 00       	mov    $0x803f25,%ebx
  8001fc:	ba 0e 00 00 00       	mov    $0xe,%edx
  800201:	89 c7                	mov    %eax,%edi
  800203:	89 de                	mov    %ebx,%esi
  800205:	89 d1                	mov    %edx,%ecx
  800207:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
	char _custTerminated[] = "custTerminated";
  800209:	8d 85 82 fe ff ff    	lea    -0x17e(%ebp),%eax
  80020f:	bb 33 3f 80 00       	mov    $0x803f33,%ebx
  800214:	ba 0f 00 00 00       	mov    $0xf,%edx
  800219:	89 c7                	mov    %eax,%edi
  80021b:	89 de                	mov    %ebx,%esi
  80021d:	89 d1                	mov    %edx,%ecx
  80021f:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)

	char _taircl[] = "taircl";
  800221:	8d 85 7b fe ff ff    	lea    -0x185(%ebp),%eax
  800227:	bb 42 3f 80 00       	mov    $0x803f42,%ebx
  80022c:	ba 07 00 00 00       	mov    $0x7,%edx
  800231:	89 c7                	mov    %eax,%edi
  800233:	89 de                	mov    %ebx,%esi
  800235:	89 d1                	mov    %edx,%ecx
  800237:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
	char _taircu[] = "taircu";
  800239:	8d 85 74 fe ff ff    	lea    -0x18c(%ebp),%eax
  80023f:	bb 49 3f 80 00       	mov    $0x803f49,%ebx
  800244:	ba 07 00 00 00       	mov    $0x7,%edx
  800249:	89 c7                	mov    %eax,%edi
  80024b:	89 de                	mov    %ebx,%esi
  80024d:	89 d1                	mov    %edx,%ecx
  80024f:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)

	struct Customer * custs;
	custs = smalloc(_customers, sizeof(struct Customer)*numOfCustomers, 1);
  800251:	8b 45 b8             	mov    -0x48(%ebp),%eax
  800254:	c1 e0 03             	shl    $0x3,%eax
  800257:	83 ec 04             	sub    $0x4,%esp
  80025a:	6a 01                	push   $0x1
  80025c:	50                   	push   %eax
  80025d:	8d 85 6a ff ff ff    	lea    -0x96(%ebp),%eax
  800263:	50                   	push   %eax
  800264:	e8 ac 1d 00 00       	call   802015 <smalloc>
  800269:	83 c4 10             	add    $0x10,%esp
  80026c:	89 45 a0             	mov    %eax,-0x60(%ebp)
	//sys_createSharedObject("customers", sizeof(struct Customer)*numOfCustomers, 1, (void**)&custs);


	{
		int f1 = 0;
  80026f:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
		for(;f1<flight1Customers; ++f1)
  800276:	eb 2e                	jmp    8002a6 <_main+0x26e>
		{
			custs[f1].booked = 0;
  800278:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80027b:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
  800282:	8b 45 a0             	mov    -0x60(%ebp),%eax
  800285:	01 d0                	add    %edx,%eax
  800287:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
			custs[f1].flightType = 1;
  80028e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800291:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
  800298:	8b 45 a0             	mov    -0x60(%ebp),%eax
  80029b:	01 d0                	add    %edx,%eax
  80029d:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
	//sys_createSharedObject("customers", sizeof(struct Customer)*numOfCustomers, 1, (void**)&custs);


	{
		int f1 = 0;
		for(;f1<flight1Customers; ++f1)
  8002a3:	ff 45 e4             	incl   -0x1c(%ebp)
  8002a6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8002a9:	3b 45 b4             	cmp    -0x4c(%ebp),%eax
  8002ac:	7c ca                	jl     800278 <_main+0x240>
		{
			custs[f1].booked = 0;
			custs[f1].flightType = 1;
		}

		int f2=f1;
  8002ae:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8002b1:	89 45 e0             	mov    %eax,-0x20(%ebp)
		for(;f2<f1+flight2Customers; ++f2)
  8002b4:	eb 2e                	jmp    8002e4 <_main+0x2ac>
		{
			custs[f2].booked = 0;
  8002b6:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8002b9:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
  8002c0:	8b 45 a0             	mov    -0x60(%ebp),%eax
  8002c3:	01 d0                	add    %edx,%eax
  8002c5:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
			custs[f2].flightType = 2;
  8002cc:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8002cf:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
  8002d6:	8b 45 a0             	mov    -0x60(%ebp),%eax
  8002d9:	01 d0                	add    %edx,%eax
  8002db:	c7 00 02 00 00 00    	movl   $0x2,(%eax)
			custs[f1].booked = 0;
			custs[f1].flightType = 1;
		}

		int f2=f1;
		for(;f2<f1+flight2Customers; ++f2)
  8002e1:	ff 45 e0             	incl   -0x20(%ebp)
  8002e4:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8002e7:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8002ea:	01 d0                	add    %edx,%eax
  8002ec:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  8002ef:	7f c5                	jg     8002b6 <_main+0x27e>
		{
			custs[f2].booked = 0;
			custs[f2].flightType = 2;
		}

		int f3=f2;
  8002f1:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8002f4:	89 45 dc             	mov    %eax,-0x24(%ebp)
		for(;f3<f2+flight3Customers; ++f3)
  8002f7:	eb 2e                	jmp    800327 <_main+0x2ef>
		{
			custs[f3].booked = 0;
  8002f9:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8002fc:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
  800303:	8b 45 a0             	mov    -0x60(%ebp),%eax
  800306:	01 d0                	add    %edx,%eax
  800308:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
			custs[f3].flightType = 3;
  80030f:	8b 45 dc             	mov    -0x24(%ebp),%eax
  800312:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
  800319:	8b 45 a0             	mov    -0x60(%ebp),%eax
  80031c:	01 d0                	add    %edx,%eax
  80031e:	c7 00 03 00 00 00    	movl   $0x3,(%eax)
			custs[f2].booked = 0;
			custs[f2].flightType = 2;
		}

		int f3=f2;
		for(;f3<f2+flight3Customers; ++f3)
  800324:	ff 45 dc             	incl   -0x24(%ebp)
  800327:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80032a:	8b 45 ac             	mov    -0x54(%ebp),%eax
  80032d:	01 d0                	add    %edx,%eax
  80032f:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  800332:	7f c5                	jg     8002f9 <_main+0x2c1>
			custs[f3].booked = 0;
			custs[f3].flightType = 3;
		}
	}

	int* custCounter = smalloc(_custCounter, sizeof(int), 1);
  800334:	83 ec 04             	sub    $0x4,%esp
  800337:	6a 01                	push   $0x1
  800339:	6a 04                	push   $0x4
  80033b:	8d 85 5e ff ff ff    	lea    -0xa2(%ebp),%eax
  800341:	50                   	push   %eax
  800342:	e8 ce 1c 00 00       	call   802015 <smalloc>
  800347:	83 c4 10             	add    $0x10,%esp
  80034a:	89 45 9c             	mov    %eax,-0x64(%ebp)
	*custCounter = 0;
  80034d:	8b 45 9c             	mov    -0x64(%ebp),%eax
  800350:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

	int* flight1Counter = smalloc(_flight1Counter, sizeof(int), 1);
  800356:	83 ec 04             	sub    $0x4,%esp
  800359:	6a 01                	push   $0x1
  80035b:	6a 04                	push   $0x4
  80035d:	8d 85 4f ff ff ff    	lea    -0xb1(%ebp),%eax
  800363:	50                   	push   %eax
  800364:	e8 ac 1c 00 00       	call   802015 <smalloc>
  800369:	83 c4 10             	add    $0x10,%esp
  80036c:	89 45 98             	mov    %eax,-0x68(%ebp)
	*flight1Counter = flight1NumOfTickets;
  80036f:	8b 45 98             	mov    -0x68(%ebp),%eax
  800372:	8b 55 a8             	mov    -0x58(%ebp),%edx
  800375:	89 10                	mov    %edx,(%eax)

	int* flight2Counter = smalloc(_flight2Counter, sizeof(int), 1);
  800377:	83 ec 04             	sub    $0x4,%esp
  80037a:	6a 01                	push   $0x1
  80037c:	6a 04                	push   $0x4
  80037e:	8d 85 40 ff ff ff    	lea    -0xc0(%ebp),%eax
  800384:	50                   	push   %eax
  800385:	e8 8b 1c 00 00       	call   802015 <smalloc>
  80038a:	83 c4 10             	add    $0x10,%esp
  80038d:	89 45 94             	mov    %eax,-0x6c(%ebp)
	*flight2Counter = flight2NumOfTickets;
  800390:	8b 45 94             	mov    -0x6c(%ebp),%eax
  800393:	8b 55 a4             	mov    -0x5c(%ebp),%edx
  800396:	89 10                	mov    %edx,(%eax)

	int* flight1BookedCounter = smalloc(_flightBooked1Counter, sizeof(int), 1);
  800398:	83 ec 04             	sub    $0x4,%esp
  80039b:	6a 01                	push   $0x1
  80039d:	6a 04                	push   $0x4
  80039f:	8d 85 2b ff ff ff    	lea    -0xd5(%ebp),%eax
  8003a5:	50                   	push   %eax
  8003a6:	e8 6a 1c 00 00       	call   802015 <smalloc>
  8003ab:	83 c4 10             	add    $0x10,%esp
  8003ae:	89 45 90             	mov    %eax,-0x70(%ebp)
	*flight1BookedCounter = 0;
  8003b1:	8b 45 90             	mov    -0x70(%ebp),%eax
  8003b4:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

	int* flight2BookedCounter = smalloc(_flightBooked2Counter, sizeof(int), 1);
  8003ba:	83 ec 04             	sub    $0x4,%esp
  8003bd:	6a 01                	push   $0x1
  8003bf:	6a 04                	push   $0x4
  8003c1:	8d 85 16 ff ff ff    	lea    -0xea(%ebp),%eax
  8003c7:	50                   	push   %eax
  8003c8:	e8 48 1c 00 00       	call   802015 <smalloc>
  8003cd:	83 c4 10             	add    $0x10,%esp
  8003d0:	89 45 8c             	mov    %eax,-0x74(%ebp)
	*flight2BookedCounter = 0;
  8003d3:	8b 45 8c             	mov    -0x74(%ebp),%eax
  8003d6:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

	int* flight1BookedArr = smalloc(_flightBooked1Arr, sizeof(int)*flight1NumOfTickets, 1);
  8003dc:	8b 45 a8             	mov    -0x58(%ebp),%eax
  8003df:	c1 e0 02             	shl    $0x2,%eax
  8003e2:	83 ec 04             	sub    $0x4,%esp
  8003e5:	6a 01                	push   $0x1
  8003e7:	50                   	push   %eax
  8003e8:	8d 85 05 ff ff ff    	lea    -0xfb(%ebp),%eax
  8003ee:	50                   	push   %eax
  8003ef:	e8 21 1c 00 00       	call   802015 <smalloc>
  8003f4:	83 c4 10             	add    $0x10,%esp
  8003f7:	89 45 88             	mov    %eax,-0x78(%ebp)
	int* flight2BookedArr = smalloc(_flightBooked2Arr, sizeof(int)*flight2NumOfTickets, 1);
  8003fa:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  8003fd:	c1 e0 02             	shl    $0x2,%eax
  800400:	83 ec 04             	sub    $0x4,%esp
  800403:	6a 01                	push   $0x1
  800405:	50                   	push   %eax
  800406:	8d 85 f4 fe ff ff    	lea    -0x10c(%ebp),%eax
  80040c:	50                   	push   %eax
  80040d:	e8 03 1c 00 00       	call   802015 <smalloc>
  800412:	83 c4 10             	add    $0x10,%esp
  800415:	89 45 84             	mov    %eax,-0x7c(%ebp)

	int* cust_ready_queue = smalloc(_cust_ready_queue, sizeof(int)*numOfCustomers, 1);
  800418:	8b 45 b8             	mov    -0x48(%ebp),%eax
  80041b:	c1 e0 02             	shl    $0x2,%eax
  80041e:	83 ec 04             	sub    $0x4,%esp
  800421:	6a 01                	push   $0x1
  800423:	50                   	push   %eax
  800424:	8d 85 e3 fe ff ff    	lea    -0x11d(%ebp),%eax
  80042a:	50                   	push   %eax
  80042b:	e8 e5 1b 00 00       	call   802015 <smalloc>
  800430:	83 c4 10             	add    $0x10,%esp
  800433:	89 45 80             	mov    %eax,-0x80(%ebp)

	int* queue_in = smalloc(_queue_in, sizeof(int), 1);
  800436:	83 ec 04             	sub    $0x4,%esp
  800439:	6a 01                	push   $0x1
  80043b:	6a 04                	push   $0x4
  80043d:	8d 85 da fe ff ff    	lea    -0x126(%ebp),%eax
  800443:	50                   	push   %eax
  800444:	e8 cc 1b 00 00       	call   802015 <smalloc>
  800449:	83 c4 10             	add    $0x10,%esp
  80044c:	89 85 7c ff ff ff    	mov    %eax,-0x84(%ebp)
	*queue_in = 0;
  800452:	8b 85 7c ff ff ff    	mov    -0x84(%ebp),%eax
  800458:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

	int* queue_out = smalloc(_queue_out, sizeof(int), 1);
  80045e:	83 ec 04             	sub    $0x4,%esp
  800461:	6a 01                	push   $0x1
  800463:	6a 04                	push   $0x4
  800465:	8d 85 d0 fe ff ff    	lea    -0x130(%ebp),%eax
  80046b:	50                   	push   %eax
  80046c:	e8 a4 1b 00 00       	call   802015 <smalloc>
  800471:	83 c4 10             	add    $0x10,%esp
  800474:	89 85 78 ff ff ff    	mov    %eax,-0x88(%ebp)
	*queue_out = 0;
  80047a:	8b 85 78 ff ff ff    	mov    -0x88(%ebp),%eax
  800480:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

	// *************************************************************************************************
	/// Semaphores Region ******************************************************************************
	// *************************************************************************************************
	sys_createSemaphore(_flight1CS, 1);
  800486:	83 ec 08             	sub    $0x8,%esp
  800489:	6a 01                	push   $0x1
  80048b:	8d 85 af fe ff ff    	lea    -0x151(%ebp),%eax
  800491:	50                   	push   %eax
  800492:	e8 a3 1f 00 00       	call   80243a <sys_createSemaphore>
  800497:	83 c4 10             	add    $0x10,%esp
	sys_createSemaphore(_flight2CS, 1);
  80049a:	83 ec 08             	sub    $0x8,%esp
  80049d:	6a 01                	push   $0x1
  80049f:	8d 85 a5 fe ff ff    	lea    -0x15b(%ebp),%eax
  8004a5:	50                   	push   %eax
  8004a6:	e8 8f 1f 00 00       	call   80243a <sys_createSemaphore>
  8004ab:	83 c4 10             	add    $0x10,%esp

	sys_createSemaphore(_custCounterCS, 1);
  8004ae:	83 ec 08             	sub    $0x8,%esp
  8004b1:	6a 01                	push   $0x1
  8004b3:	8d 85 91 fe ff ff    	lea    -0x16f(%ebp),%eax
  8004b9:	50                   	push   %eax
  8004ba:	e8 7b 1f 00 00       	call   80243a <sys_createSemaphore>
  8004bf:	83 c4 10             	add    $0x10,%esp
	sys_createSemaphore(_custQueueCS, 1);
  8004c2:	83 ec 08             	sub    $0x8,%esp
  8004c5:	6a 01                	push   $0x1
  8004c7:	8d 85 b9 fe ff ff    	lea    -0x147(%ebp),%eax
  8004cd:	50                   	push   %eax
  8004ce:	e8 67 1f 00 00       	call   80243a <sys_createSemaphore>
  8004d3:	83 c4 10             	add    $0x10,%esp

	sys_createSemaphore(_clerk, 3);
  8004d6:	83 ec 08             	sub    $0x8,%esp
  8004d9:	6a 03                	push   $0x3
  8004db:	8d 85 9f fe ff ff    	lea    -0x161(%ebp),%eax
  8004e1:	50                   	push   %eax
  8004e2:	e8 53 1f 00 00       	call   80243a <sys_createSemaphore>
  8004e7:	83 c4 10             	add    $0x10,%esp

	sys_createSemaphore(_cust_ready, 0);
  8004ea:	83 ec 08             	sub    $0x8,%esp
  8004ed:	6a 00                	push   $0x0
  8004ef:	8d 85 c5 fe ff ff    	lea    -0x13b(%ebp),%eax
  8004f5:	50                   	push   %eax
  8004f6:	e8 3f 1f 00 00       	call   80243a <sys_createSemaphore>
  8004fb:	83 c4 10             	add    $0x10,%esp

	sys_createSemaphore(_custTerminated, 0);
  8004fe:	83 ec 08             	sub    $0x8,%esp
  800501:	6a 00                	push   $0x0
  800503:	8d 85 82 fe ff ff    	lea    -0x17e(%ebp),%eax
  800509:	50                   	push   %eax
  80050a:	e8 2b 1f 00 00       	call   80243a <sys_createSemaphore>
  80050f:	83 c4 10             	add    $0x10,%esp

	int s=0;
  800512:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%ebp)
	for(s=0; s<numOfCustomers; ++s)
  800519:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%ebp)
  800520:	eb 78                	jmp    80059a <_main+0x562>
	{
		char prefix[30]="cust_finished";
  800522:	8d 85 56 fe ff ff    	lea    -0x1aa(%ebp),%eax
  800528:	bb 50 3f 80 00       	mov    $0x803f50,%ebx
  80052d:	ba 0e 00 00 00       	mov    $0xe,%edx
  800532:	89 c7                	mov    %eax,%edi
  800534:	89 de                	mov    %ebx,%esi
  800536:	89 d1                	mov    %edx,%ecx
  800538:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
  80053a:	8d 95 64 fe ff ff    	lea    -0x19c(%ebp),%edx
  800540:	b9 04 00 00 00       	mov    $0x4,%ecx
  800545:	b8 00 00 00 00       	mov    $0x0,%eax
  80054a:	89 d7                	mov    %edx,%edi
  80054c:	f3 ab                	rep stos %eax,%es:(%edi)
		char id[5]; char sname[50];
		ltostr(s, id);
  80054e:	83 ec 08             	sub    $0x8,%esp
  800551:	8d 85 51 fe ff ff    	lea    -0x1af(%ebp),%eax
  800557:	50                   	push   %eax
  800558:	ff 75 d8             	pushl  -0x28(%ebp)
  80055b:	e8 03 15 00 00       	call   801a63 <ltostr>
  800560:	83 c4 10             	add    $0x10,%esp
		strcconcat(prefix, id, sname);
  800563:	83 ec 04             	sub    $0x4,%esp
  800566:	8d 85 fc fd ff ff    	lea    -0x204(%ebp),%eax
  80056c:	50                   	push   %eax
  80056d:	8d 85 51 fe ff ff    	lea    -0x1af(%ebp),%eax
  800573:	50                   	push   %eax
  800574:	8d 85 56 fe ff ff    	lea    -0x1aa(%ebp),%eax
  80057a:	50                   	push   %eax
  80057b:	e8 db 15 00 00       	call   801b5b <strcconcat>
  800580:	83 c4 10             	add    $0x10,%esp
		sys_createSemaphore(sname, 0);
  800583:	83 ec 08             	sub    $0x8,%esp
  800586:	6a 00                	push   $0x0
  800588:	8d 85 fc fd ff ff    	lea    -0x204(%ebp),%eax
  80058e:	50                   	push   %eax
  80058f:	e8 a6 1e 00 00       	call   80243a <sys_createSemaphore>
  800594:	83 c4 10             	add    $0x10,%esp
	sys_createSemaphore(_cust_ready, 0);

	sys_createSemaphore(_custTerminated, 0);

	int s=0;
	for(s=0; s<numOfCustomers; ++s)
  800597:	ff 45 d8             	incl   -0x28(%ebp)
  80059a:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80059d:	3b 45 b8             	cmp    -0x48(%ebp),%eax
  8005a0:	7c 80                	jl     800522 <_main+0x4ea>
	// start all clerks and customers ******************************************************************
	// *************************************************************************************************

	//3 clerks
	uint32 envId;
	envId = sys_create_env(_taircl, (myEnv->page_WS_max_size),(myEnv->SecondListSize), (myEnv->percentage_of_WS_pages_to_be_removed));
  8005a2:	a1 20 50 80 00       	mov    0x805020,%eax
  8005a7:	8b 90 a0 05 00 00    	mov    0x5a0(%eax),%edx
  8005ad:	a1 20 50 80 00       	mov    0x805020,%eax
  8005b2:	8b 80 ec 05 00 00    	mov    0x5ec(%eax),%eax
  8005b8:	89 c1                	mov    %eax,%ecx
  8005ba:	a1 20 50 80 00       	mov    0x805020,%eax
  8005bf:	8b 40 74             	mov    0x74(%eax),%eax
  8005c2:	52                   	push   %edx
  8005c3:	51                   	push   %ecx
  8005c4:	50                   	push   %eax
  8005c5:	8d 85 7b fe ff ff    	lea    -0x185(%ebp),%eax
  8005cb:	50                   	push   %eax
  8005cc:	e8 7a 1f 00 00       	call   80254b <sys_create_env>
  8005d1:	83 c4 10             	add    $0x10,%esp
  8005d4:	89 85 74 ff ff ff    	mov    %eax,-0x8c(%ebp)
	sys_run_env(envId);
  8005da:	8b 85 74 ff ff ff    	mov    -0x8c(%ebp),%eax
  8005e0:	83 ec 0c             	sub    $0xc,%esp
  8005e3:	50                   	push   %eax
  8005e4:	e8 80 1f 00 00       	call   802569 <sys_run_env>
  8005e9:	83 c4 10             	add    $0x10,%esp

	envId = sys_create_env(_taircl, (myEnv->page_WS_max_size), (myEnv->SecondListSize),(myEnv->percentage_of_WS_pages_to_be_removed));
  8005ec:	a1 20 50 80 00       	mov    0x805020,%eax
  8005f1:	8b 90 a0 05 00 00    	mov    0x5a0(%eax),%edx
  8005f7:	a1 20 50 80 00       	mov    0x805020,%eax
  8005fc:	8b 80 ec 05 00 00    	mov    0x5ec(%eax),%eax
  800602:	89 c1                	mov    %eax,%ecx
  800604:	a1 20 50 80 00       	mov    0x805020,%eax
  800609:	8b 40 74             	mov    0x74(%eax),%eax
  80060c:	52                   	push   %edx
  80060d:	51                   	push   %ecx
  80060e:	50                   	push   %eax
  80060f:	8d 85 7b fe ff ff    	lea    -0x185(%ebp),%eax
  800615:	50                   	push   %eax
  800616:	e8 30 1f 00 00       	call   80254b <sys_create_env>
  80061b:	83 c4 10             	add    $0x10,%esp
  80061e:	89 85 74 ff ff ff    	mov    %eax,-0x8c(%ebp)
	sys_run_env(envId);
  800624:	8b 85 74 ff ff ff    	mov    -0x8c(%ebp),%eax
  80062a:	83 ec 0c             	sub    $0xc,%esp
  80062d:	50                   	push   %eax
  80062e:	e8 36 1f 00 00       	call   802569 <sys_run_env>
  800633:	83 c4 10             	add    $0x10,%esp

	envId = sys_create_env(_taircl, (myEnv->page_WS_max_size), (myEnv->SecondListSize),(myEnv->percentage_of_WS_pages_to_be_removed));
  800636:	a1 20 50 80 00       	mov    0x805020,%eax
  80063b:	8b 90 a0 05 00 00    	mov    0x5a0(%eax),%edx
  800641:	a1 20 50 80 00       	mov    0x805020,%eax
  800646:	8b 80 ec 05 00 00    	mov    0x5ec(%eax),%eax
  80064c:	89 c1                	mov    %eax,%ecx
  80064e:	a1 20 50 80 00       	mov    0x805020,%eax
  800653:	8b 40 74             	mov    0x74(%eax),%eax
  800656:	52                   	push   %edx
  800657:	51                   	push   %ecx
  800658:	50                   	push   %eax
  800659:	8d 85 7b fe ff ff    	lea    -0x185(%ebp),%eax
  80065f:	50                   	push   %eax
  800660:	e8 e6 1e 00 00       	call   80254b <sys_create_env>
  800665:	83 c4 10             	add    $0x10,%esp
  800668:	89 85 74 ff ff ff    	mov    %eax,-0x8c(%ebp)
	sys_run_env(envId);
  80066e:	8b 85 74 ff ff ff    	mov    -0x8c(%ebp),%eax
  800674:	83 ec 0c             	sub    $0xc,%esp
  800677:	50                   	push   %eax
  800678:	e8 ec 1e 00 00       	call   802569 <sys_run_env>
  80067d:	83 c4 10             	add    $0x10,%esp

	//customers
	int c;
	for(c=0; c< numOfCustomers;++c)
  800680:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
  800687:	eb 6d                	jmp    8006f6 <_main+0x6be>
	{
		envId = sys_create_env(_taircu, (myEnv->page_WS_max_size),(myEnv->SecondListSize), (myEnv->percentage_of_WS_pages_to_be_removed));
  800689:	a1 20 50 80 00       	mov    0x805020,%eax
  80068e:	8b 90 a0 05 00 00    	mov    0x5a0(%eax),%edx
  800694:	a1 20 50 80 00       	mov    0x805020,%eax
  800699:	8b 80 ec 05 00 00    	mov    0x5ec(%eax),%eax
  80069f:	89 c1                	mov    %eax,%ecx
  8006a1:	a1 20 50 80 00       	mov    0x805020,%eax
  8006a6:	8b 40 74             	mov    0x74(%eax),%eax
  8006a9:	52                   	push   %edx
  8006aa:	51                   	push   %ecx
  8006ab:	50                   	push   %eax
  8006ac:	8d 85 74 fe ff ff    	lea    -0x18c(%ebp),%eax
  8006b2:	50                   	push   %eax
  8006b3:	e8 93 1e 00 00       	call   80254b <sys_create_env>
  8006b8:	83 c4 10             	add    $0x10,%esp
  8006bb:	89 85 74 ff ff ff    	mov    %eax,-0x8c(%ebp)
		if (envId == E_ENV_CREATION_ERROR)
  8006c1:	83 bd 74 ff ff ff ef 	cmpl   $0xffffffef,-0x8c(%ebp)
  8006c8:	75 17                	jne    8006e1 <_main+0x6a9>
			panic("NO AVAILABLE ENVs... Please reduce the num of customers and try again");
  8006ca:	83 ec 04             	sub    $0x4,%esp
  8006cd:	68 80 3b 80 00       	push   $0x803b80
  8006d2:	68 95 00 00 00       	push   $0x95
  8006d7:	68 c6 3b 80 00       	push   $0x803bc6
  8006dc:	e8 a6 05 00 00       	call   800c87 <_panic>

		sys_run_env(envId);
  8006e1:	8b 85 74 ff ff ff    	mov    -0x8c(%ebp),%eax
  8006e7:	83 ec 0c             	sub    $0xc,%esp
  8006ea:	50                   	push   %eax
  8006eb:	e8 79 1e 00 00       	call   802569 <sys_run_env>
  8006f0:	83 c4 10             	add    $0x10,%esp
	envId = sys_create_env(_taircl, (myEnv->page_WS_max_size), (myEnv->SecondListSize),(myEnv->percentage_of_WS_pages_to_be_removed));
	sys_run_env(envId);

	//customers
	int c;
	for(c=0; c< numOfCustomers;++c)
  8006f3:	ff 45 d4             	incl   -0x2c(%ebp)
  8006f6:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8006f9:	3b 45 b8             	cmp    -0x48(%ebp),%eax
  8006fc:	7c 8b                	jl     800689 <_main+0x651>

		sys_run_env(envId);
	}

	//wait until all customers terminated
	for(c=0; c< numOfCustomers;++c)
  8006fe:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
  800705:	eb 18                	jmp    80071f <_main+0x6e7>
	{
		sys_waitSemaphore(envID, _custTerminated);
  800707:	83 ec 08             	sub    $0x8,%esp
  80070a:	8d 85 82 fe ff ff    	lea    -0x17e(%ebp),%eax
  800710:	50                   	push   %eax
  800711:	ff 75 bc             	pushl  -0x44(%ebp)
  800714:	e8 5a 1d 00 00       	call   802473 <sys_waitSemaphore>
  800719:	83 c4 10             	add    $0x10,%esp

		sys_run_env(envId);
	}

	//wait until all customers terminated
	for(c=0; c< numOfCustomers;++c)
  80071c:	ff 45 d4             	incl   -0x2c(%ebp)
  80071f:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  800722:	3b 45 b8             	cmp    -0x48(%ebp),%eax
  800725:	7c e0                	jl     800707 <_main+0x6cf>
	{
		sys_waitSemaphore(envID, _custTerminated);
	}

	env_sleep(1500);
  800727:	83 ec 0c             	sub    $0xc,%esp
  80072a:	68 dc 05 00 00       	push   $0x5dc
  80072f:	e8 2d 31 00 00       	call   803861 <env_sleep>
  800734:	83 c4 10             	add    $0x10,%esp

	//print out the results
	int b;
	for(b=0; b< (*flight1BookedCounter);++b)
  800737:	c7 45 d0 00 00 00 00 	movl   $0x0,-0x30(%ebp)
  80073e:	eb 45                	jmp    800785 <_main+0x74d>
	{
		cprintf("cust %d booked flight 1, originally ordered %d\n", flight1BookedArr[b], custs[flight1BookedArr[b]].flightType);
  800740:	8b 45 d0             	mov    -0x30(%ebp),%eax
  800743:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80074a:	8b 45 88             	mov    -0x78(%ebp),%eax
  80074d:	01 d0                	add    %edx,%eax
  80074f:	8b 00                	mov    (%eax),%eax
  800751:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
  800758:	8b 45 a0             	mov    -0x60(%ebp),%eax
  80075b:	01 d0                	add    %edx,%eax
  80075d:	8b 10                	mov    (%eax),%edx
  80075f:	8b 45 d0             	mov    -0x30(%ebp),%eax
  800762:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  800769:	8b 45 88             	mov    -0x78(%ebp),%eax
  80076c:	01 c8                	add    %ecx,%eax
  80076e:	8b 00                	mov    (%eax),%eax
  800770:	83 ec 04             	sub    $0x4,%esp
  800773:	52                   	push   %edx
  800774:	50                   	push   %eax
  800775:	68 d8 3b 80 00       	push   $0x803bd8
  80077a:	e8 bc 07 00 00       	call   800f3b <cprintf>
  80077f:	83 c4 10             	add    $0x10,%esp

	env_sleep(1500);

	//print out the results
	int b;
	for(b=0; b< (*flight1BookedCounter);++b)
  800782:	ff 45 d0             	incl   -0x30(%ebp)
  800785:	8b 45 90             	mov    -0x70(%ebp),%eax
  800788:	8b 00                	mov    (%eax),%eax
  80078a:	3b 45 d0             	cmp    -0x30(%ebp),%eax
  80078d:	7f b1                	jg     800740 <_main+0x708>
	{
		cprintf("cust %d booked flight 1, originally ordered %d\n", flight1BookedArr[b], custs[flight1BookedArr[b]].flightType);
	}

	for(b=0; b< (*flight2BookedCounter);++b)
  80078f:	c7 45 d0 00 00 00 00 	movl   $0x0,-0x30(%ebp)
  800796:	eb 45                	jmp    8007dd <_main+0x7a5>
	{
		cprintf("cust %d booked flight 2, originally ordered %d\n", flight2BookedArr[b], custs[flight2BookedArr[b]].flightType);
  800798:	8b 45 d0             	mov    -0x30(%ebp),%eax
  80079b:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8007a2:	8b 45 84             	mov    -0x7c(%ebp),%eax
  8007a5:	01 d0                	add    %edx,%eax
  8007a7:	8b 00                	mov    (%eax),%eax
  8007a9:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
  8007b0:	8b 45 a0             	mov    -0x60(%ebp),%eax
  8007b3:	01 d0                	add    %edx,%eax
  8007b5:	8b 10                	mov    (%eax),%edx
  8007b7:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8007ba:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  8007c1:	8b 45 84             	mov    -0x7c(%ebp),%eax
  8007c4:	01 c8                	add    %ecx,%eax
  8007c6:	8b 00                	mov    (%eax),%eax
  8007c8:	83 ec 04             	sub    $0x4,%esp
  8007cb:	52                   	push   %edx
  8007cc:	50                   	push   %eax
  8007cd:	68 08 3c 80 00       	push   $0x803c08
  8007d2:	e8 64 07 00 00       	call   800f3b <cprintf>
  8007d7:	83 c4 10             	add    $0x10,%esp
	for(b=0; b< (*flight1BookedCounter);++b)
	{
		cprintf("cust %d booked flight 1, originally ordered %d\n", flight1BookedArr[b], custs[flight1BookedArr[b]].flightType);
	}

	for(b=0; b< (*flight2BookedCounter);++b)
  8007da:	ff 45 d0             	incl   -0x30(%ebp)
  8007dd:	8b 45 8c             	mov    -0x74(%ebp),%eax
  8007e0:	8b 00                	mov    (%eax),%eax
  8007e2:	3b 45 d0             	cmp    -0x30(%ebp),%eax
  8007e5:	7f b1                	jg     800798 <_main+0x760>
		cprintf("cust %d booked flight 2, originally ordered %d\n", flight2BookedArr[b], custs[flight2BookedArr[b]].flightType);
	}

	//check out the final results and semaphores
	{
		int f1 = 0;
  8007e7:	c7 45 cc 00 00 00 00 	movl   $0x0,-0x34(%ebp)
		for(;f1<flight1Customers; ++f1)
  8007ee:	eb 33                	jmp    800823 <_main+0x7eb>
		{
			if(find(flight1BookedArr, flight1NumOfTickets, f1) != 1)
  8007f0:	83 ec 04             	sub    $0x4,%esp
  8007f3:	ff 75 cc             	pushl  -0x34(%ebp)
  8007f6:	ff 75 a8             	pushl  -0x58(%ebp)
  8007f9:	ff 75 88             	pushl  -0x78(%ebp)
  8007fc:	e8 05 03 00 00       	call   800b06 <find>
  800801:	83 c4 10             	add    $0x10,%esp
  800804:	83 f8 01             	cmp    $0x1,%eax
  800807:	74 17                	je     800820 <_main+0x7e8>
			{
				panic("Error, wrong booking for user %d\n", f1);
  800809:	ff 75 cc             	pushl  -0x34(%ebp)
  80080c:	68 38 3c 80 00       	push   $0x803c38
  800811:	68 b5 00 00 00       	push   $0xb5
  800816:	68 c6 3b 80 00       	push   $0x803bc6
  80081b:	e8 67 04 00 00       	call   800c87 <_panic>
	}

	//check out the final results and semaphores
	{
		int f1 = 0;
		for(;f1<flight1Customers; ++f1)
  800820:	ff 45 cc             	incl   -0x34(%ebp)
  800823:	8b 45 cc             	mov    -0x34(%ebp),%eax
  800826:	3b 45 b4             	cmp    -0x4c(%ebp),%eax
  800829:	7c c5                	jl     8007f0 <_main+0x7b8>
			{
				panic("Error, wrong booking for user %d\n", f1);
			}
		}

		int f2=f1;
  80082b:	8b 45 cc             	mov    -0x34(%ebp),%eax
  80082e:	89 45 c8             	mov    %eax,-0x38(%ebp)
		for(;f2<f1+flight2Customers; ++f2)
  800831:	eb 33                	jmp    800866 <_main+0x82e>
		{
			if(find(flight2BookedArr, flight2NumOfTickets, f2) != 1)
  800833:	83 ec 04             	sub    $0x4,%esp
  800836:	ff 75 c8             	pushl  -0x38(%ebp)
  800839:	ff 75 a4             	pushl  -0x5c(%ebp)
  80083c:	ff 75 84             	pushl  -0x7c(%ebp)
  80083f:	e8 c2 02 00 00       	call   800b06 <find>
  800844:	83 c4 10             	add    $0x10,%esp
  800847:	83 f8 01             	cmp    $0x1,%eax
  80084a:	74 17                	je     800863 <_main+0x82b>
			{
				panic("Error, wrong booking for user %d\n", f2);
  80084c:	ff 75 c8             	pushl  -0x38(%ebp)
  80084f:	68 38 3c 80 00       	push   $0x803c38
  800854:	68 be 00 00 00       	push   $0xbe
  800859:	68 c6 3b 80 00       	push   $0x803bc6
  80085e:	e8 24 04 00 00       	call   800c87 <_panic>
				panic("Error, wrong booking for user %d\n", f1);
			}
		}

		int f2=f1;
		for(;f2<f1+flight2Customers; ++f2)
  800863:	ff 45 c8             	incl   -0x38(%ebp)
  800866:	8b 55 cc             	mov    -0x34(%ebp),%edx
  800869:	8b 45 b0             	mov    -0x50(%ebp),%eax
  80086c:	01 d0                	add    %edx,%eax
  80086e:	3b 45 c8             	cmp    -0x38(%ebp),%eax
  800871:	7f c0                	jg     800833 <_main+0x7fb>
			{
				panic("Error, wrong booking for user %d\n", f2);
			}
		}

		int f3=f2;
  800873:	8b 45 c8             	mov    -0x38(%ebp),%eax
  800876:	89 45 c4             	mov    %eax,-0x3c(%ebp)
		for(;f3<f2+flight3Customers; ++f3)
  800879:	eb 4c                	jmp    8008c7 <_main+0x88f>
		{
			if(find(flight1BookedArr, flight1NumOfTickets, f3) != 1 || find(flight2BookedArr, flight2NumOfTickets, f3) != 1)
  80087b:	83 ec 04             	sub    $0x4,%esp
  80087e:	ff 75 c4             	pushl  -0x3c(%ebp)
  800881:	ff 75 a8             	pushl  -0x58(%ebp)
  800884:	ff 75 88             	pushl  -0x78(%ebp)
  800887:	e8 7a 02 00 00       	call   800b06 <find>
  80088c:	83 c4 10             	add    $0x10,%esp
  80088f:	83 f8 01             	cmp    $0x1,%eax
  800892:	75 19                	jne    8008ad <_main+0x875>
  800894:	83 ec 04             	sub    $0x4,%esp
  800897:	ff 75 c4             	pushl  -0x3c(%ebp)
  80089a:	ff 75 a4             	pushl  -0x5c(%ebp)
  80089d:	ff 75 84             	pushl  -0x7c(%ebp)
  8008a0:	e8 61 02 00 00       	call   800b06 <find>
  8008a5:	83 c4 10             	add    $0x10,%esp
  8008a8:	83 f8 01             	cmp    $0x1,%eax
  8008ab:	74 17                	je     8008c4 <_main+0x88c>
			{
				panic("Error, wrong booking for user %d\n", f3);
  8008ad:	ff 75 c4             	pushl  -0x3c(%ebp)
  8008b0:	68 38 3c 80 00       	push   $0x803c38
  8008b5:	68 c7 00 00 00       	push   $0xc7
  8008ba:	68 c6 3b 80 00       	push   $0x803bc6
  8008bf:	e8 c3 03 00 00       	call   800c87 <_panic>
				panic("Error, wrong booking for user %d\n", f2);
			}
		}

		int f3=f2;
		for(;f3<f2+flight3Customers; ++f3)
  8008c4:	ff 45 c4             	incl   -0x3c(%ebp)
  8008c7:	8b 55 c8             	mov    -0x38(%ebp),%edx
  8008ca:	8b 45 ac             	mov    -0x54(%ebp),%eax
  8008cd:	01 d0                	add    %edx,%eax
  8008cf:	3b 45 c4             	cmp    -0x3c(%ebp),%eax
  8008d2:	7f a7                	jg     80087b <_main+0x843>
			{
				panic("Error, wrong booking for user %d\n", f3);
			}
		}

		assert(sys_getSemaphoreValue(envID, _flight1CS) == 1);
  8008d4:	83 ec 08             	sub    $0x8,%esp
  8008d7:	8d 85 af fe ff ff    	lea    -0x151(%ebp),%eax
  8008dd:	50                   	push   %eax
  8008de:	ff 75 bc             	pushl  -0x44(%ebp)
  8008e1:	e8 70 1b 00 00       	call   802456 <sys_getSemaphoreValue>
  8008e6:	83 c4 10             	add    $0x10,%esp
  8008e9:	83 f8 01             	cmp    $0x1,%eax
  8008ec:	74 19                	je     800907 <_main+0x8cf>
  8008ee:	68 5c 3c 80 00       	push   $0x803c5c
  8008f3:	68 8a 3c 80 00       	push   $0x803c8a
  8008f8:	68 cb 00 00 00       	push   $0xcb
  8008fd:	68 c6 3b 80 00       	push   $0x803bc6
  800902:	e8 80 03 00 00       	call   800c87 <_panic>
		assert(sys_getSemaphoreValue(envID, _flight2CS) == 1);
  800907:	83 ec 08             	sub    $0x8,%esp
  80090a:	8d 85 a5 fe ff ff    	lea    -0x15b(%ebp),%eax
  800910:	50                   	push   %eax
  800911:	ff 75 bc             	pushl  -0x44(%ebp)
  800914:	e8 3d 1b 00 00       	call   802456 <sys_getSemaphoreValue>
  800919:	83 c4 10             	add    $0x10,%esp
  80091c:	83 f8 01             	cmp    $0x1,%eax
  80091f:	74 19                	je     80093a <_main+0x902>
  800921:	68 a0 3c 80 00       	push   $0x803ca0
  800926:	68 8a 3c 80 00       	push   $0x803c8a
  80092b:	68 cc 00 00 00       	push   $0xcc
  800930:	68 c6 3b 80 00       	push   $0x803bc6
  800935:	e8 4d 03 00 00       	call   800c87 <_panic>

		assert(sys_getSemaphoreValue(envID, _custCounterCS) ==  1);
  80093a:	83 ec 08             	sub    $0x8,%esp
  80093d:	8d 85 91 fe ff ff    	lea    -0x16f(%ebp),%eax
  800943:	50                   	push   %eax
  800944:	ff 75 bc             	pushl  -0x44(%ebp)
  800947:	e8 0a 1b 00 00       	call   802456 <sys_getSemaphoreValue>
  80094c:	83 c4 10             	add    $0x10,%esp
  80094f:	83 f8 01             	cmp    $0x1,%eax
  800952:	74 19                	je     80096d <_main+0x935>
  800954:	68 d0 3c 80 00       	push   $0x803cd0
  800959:	68 8a 3c 80 00       	push   $0x803c8a
  80095e:	68 ce 00 00 00       	push   $0xce
  800963:	68 c6 3b 80 00       	push   $0x803bc6
  800968:	e8 1a 03 00 00       	call   800c87 <_panic>
		assert(sys_getSemaphoreValue(envID, _custQueueCS) ==  1);
  80096d:	83 ec 08             	sub    $0x8,%esp
  800970:	8d 85 b9 fe ff ff    	lea    -0x147(%ebp),%eax
  800976:	50                   	push   %eax
  800977:	ff 75 bc             	pushl  -0x44(%ebp)
  80097a:	e8 d7 1a 00 00       	call   802456 <sys_getSemaphoreValue>
  80097f:	83 c4 10             	add    $0x10,%esp
  800982:	83 f8 01             	cmp    $0x1,%eax
  800985:	74 19                	je     8009a0 <_main+0x968>
  800987:	68 04 3d 80 00       	push   $0x803d04
  80098c:	68 8a 3c 80 00       	push   $0x803c8a
  800991:	68 cf 00 00 00       	push   $0xcf
  800996:	68 c6 3b 80 00       	push   $0x803bc6
  80099b:	e8 e7 02 00 00       	call   800c87 <_panic>

		assert(sys_getSemaphoreValue(envID, _clerk) == 3);
  8009a0:	83 ec 08             	sub    $0x8,%esp
  8009a3:	8d 85 9f fe ff ff    	lea    -0x161(%ebp),%eax
  8009a9:	50                   	push   %eax
  8009aa:	ff 75 bc             	pushl  -0x44(%ebp)
  8009ad:	e8 a4 1a 00 00       	call   802456 <sys_getSemaphoreValue>
  8009b2:	83 c4 10             	add    $0x10,%esp
  8009b5:	83 f8 03             	cmp    $0x3,%eax
  8009b8:	74 19                	je     8009d3 <_main+0x99b>
  8009ba:	68 34 3d 80 00       	push   $0x803d34
  8009bf:	68 8a 3c 80 00       	push   $0x803c8a
  8009c4:	68 d1 00 00 00       	push   $0xd1
  8009c9:	68 c6 3b 80 00       	push   $0x803bc6
  8009ce:	e8 b4 02 00 00       	call   800c87 <_panic>

		assert(sys_getSemaphoreValue(envID, _cust_ready) == -3);
  8009d3:	83 ec 08             	sub    $0x8,%esp
  8009d6:	8d 85 c5 fe ff ff    	lea    -0x13b(%ebp),%eax
  8009dc:	50                   	push   %eax
  8009dd:	ff 75 bc             	pushl  -0x44(%ebp)
  8009e0:	e8 71 1a 00 00       	call   802456 <sys_getSemaphoreValue>
  8009e5:	83 c4 10             	add    $0x10,%esp
  8009e8:	83 f8 fd             	cmp    $0xfffffffd,%eax
  8009eb:	74 19                	je     800a06 <_main+0x9ce>
  8009ed:	68 60 3d 80 00       	push   $0x803d60
  8009f2:	68 8a 3c 80 00       	push   $0x803c8a
  8009f7:	68 d3 00 00 00       	push   $0xd3
  8009fc:	68 c6 3b 80 00       	push   $0x803bc6
  800a01:	e8 81 02 00 00       	call   800c87 <_panic>

		assert(sys_getSemaphoreValue(envID, _custTerminated) ==  0);
  800a06:	83 ec 08             	sub    $0x8,%esp
  800a09:	8d 85 82 fe ff ff    	lea    -0x17e(%ebp),%eax
  800a0f:	50                   	push   %eax
  800a10:	ff 75 bc             	pushl  -0x44(%ebp)
  800a13:	e8 3e 1a 00 00       	call   802456 <sys_getSemaphoreValue>
  800a18:	83 c4 10             	add    $0x10,%esp
  800a1b:	85 c0                	test   %eax,%eax
  800a1d:	74 19                	je     800a38 <_main+0xa00>
  800a1f:	68 90 3d 80 00       	push   $0x803d90
  800a24:	68 8a 3c 80 00       	push   $0x803c8a
  800a29:	68 d5 00 00 00       	push   $0xd5
  800a2e:	68 c6 3b 80 00       	push   $0x803bc6
  800a33:	e8 4f 02 00 00       	call   800c87 <_panic>

		int s=0;
  800a38:	c7 45 c0 00 00 00 00 	movl   $0x0,-0x40(%ebp)
		for(s=0; s<numOfCustomers; ++s)
  800a3f:	c7 45 c0 00 00 00 00 	movl   $0x0,-0x40(%ebp)
  800a46:	e9 96 00 00 00       	jmp    800ae1 <_main+0xaa9>
		{
			char prefix[30]="cust_finished";
  800a4b:	8d 85 33 fe ff ff    	lea    -0x1cd(%ebp),%eax
  800a51:	bb 50 3f 80 00       	mov    $0x803f50,%ebx
  800a56:	ba 0e 00 00 00       	mov    $0xe,%edx
  800a5b:	89 c7                	mov    %eax,%edi
  800a5d:	89 de                	mov    %ebx,%esi
  800a5f:	89 d1                	mov    %edx,%ecx
  800a61:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
  800a63:	8d 95 41 fe ff ff    	lea    -0x1bf(%ebp),%edx
  800a69:	b9 04 00 00 00       	mov    $0x4,%ecx
  800a6e:	b8 00 00 00 00       	mov    $0x0,%eax
  800a73:	89 d7                	mov    %edx,%edi
  800a75:	f3 ab                	rep stos %eax,%es:(%edi)
			char id[5]; char cust_finishedSemaphoreName[50];
			ltostr(s, id);
  800a77:	83 ec 08             	sub    $0x8,%esp
  800a7a:	8d 85 2e fe ff ff    	lea    -0x1d2(%ebp),%eax
  800a80:	50                   	push   %eax
  800a81:	ff 75 c0             	pushl  -0x40(%ebp)
  800a84:	e8 da 0f 00 00       	call   801a63 <ltostr>
  800a89:	83 c4 10             	add    $0x10,%esp
			strcconcat(prefix, id, cust_finishedSemaphoreName);
  800a8c:	83 ec 04             	sub    $0x4,%esp
  800a8f:	8d 85 fc fd ff ff    	lea    -0x204(%ebp),%eax
  800a95:	50                   	push   %eax
  800a96:	8d 85 2e fe ff ff    	lea    -0x1d2(%ebp),%eax
  800a9c:	50                   	push   %eax
  800a9d:	8d 85 33 fe ff ff    	lea    -0x1cd(%ebp),%eax
  800aa3:	50                   	push   %eax
  800aa4:	e8 b2 10 00 00       	call   801b5b <strcconcat>
  800aa9:	83 c4 10             	add    $0x10,%esp
			assert(sys_getSemaphoreValue(envID, cust_finishedSemaphoreName) ==  0);
  800aac:	83 ec 08             	sub    $0x8,%esp
  800aaf:	8d 85 fc fd ff ff    	lea    -0x204(%ebp),%eax
  800ab5:	50                   	push   %eax
  800ab6:	ff 75 bc             	pushl  -0x44(%ebp)
  800ab9:	e8 98 19 00 00       	call   802456 <sys_getSemaphoreValue>
  800abe:	83 c4 10             	add    $0x10,%esp
  800ac1:	85 c0                	test   %eax,%eax
  800ac3:	74 19                	je     800ade <_main+0xaa6>
  800ac5:	68 c4 3d 80 00       	push   $0x803dc4
  800aca:	68 8a 3c 80 00       	push   $0x803c8a
  800acf:	68 de 00 00 00       	push   $0xde
  800ad4:	68 c6 3b 80 00       	push   $0x803bc6
  800ad9:	e8 a9 01 00 00       	call   800c87 <_panic>
		assert(sys_getSemaphoreValue(envID, _cust_ready) == -3);

		assert(sys_getSemaphoreValue(envID, _custTerminated) ==  0);

		int s=0;
		for(s=0; s<numOfCustomers; ++s)
  800ade:	ff 45 c0             	incl   -0x40(%ebp)
  800ae1:	8b 45 c0             	mov    -0x40(%ebp),%eax
  800ae4:	3b 45 b8             	cmp    -0x48(%ebp),%eax
  800ae7:	0f 8c 5e ff ff ff    	jl     800a4b <_main+0xa13>
			ltostr(s, id);
			strcconcat(prefix, id, cust_finishedSemaphoreName);
			assert(sys_getSemaphoreValue(envID, cust_finishedSemaphoreName) ==  0);
		}

		cprintf("Congratulations, All reservations are successfully done... have a nice flight :)\n");
  800aed:	83 ec 0c             	sub    $0xc,%esp
  800af0:	68 04 3e 80 00       	push   $0x803e04
  800af5:	e8 41 04 00 00       	call   800f3b <cprintf>
  800afa:	83 c4 10             	add    $0x10,%esp
	}

}
  800afd:	90                   	nop
  800afe:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800b01:	5b                   	pop    %ebx
  800b02:	5e                   	pop    %esi
  800b03:	5f                   	pop    %edi
  800b04:	5d                   	pop    %ebp
  800b05:	c3                   	ret    

00800b06 <find>:


int find(int* arr, int size, int val)
{
  800b06:	55                   	push   %ebp
  800b07:	89 e5                	mov    %esp,%ebp
  800b09:	83 ec 10             	sub    $0x10,%esp

	int result = 0;
  800b0c:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)

	int i;
	for(i=0; i<size;++i )
  800b13:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  800b1a:	eb 22                	jmp    800b3e <find+0x38>
	{
		if(arr[i] == val)
  800b1c:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800b1f:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800b26:	8b 45 08             	mov    0x8(%ebp),%eax
  800b29:	01 d0                	add    %edx,%eax
  800b2b:	8b 00                	mov    (%eax),%eax
  800b2d:	3b 45 10             	cmp    0x10(%ebp),%eax
  800b30:	75 09                	jne    800b3b <find+0x35>
		{
			result = 1;
  800b32:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
			break;
  800b39:	eb 0b                	jmp    800b46 <find+0x40>
{

	int result = 0;

	int i;
	for(i=0; i<size;++i )
  800b3b:	ff 45 f8             	incl   -0x8(%ebp)
  800b3e:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800b41:	3b 45 0c             	cmp    0xc(%ebp),%eax
  800b44:	7c d6                	jl     800b1c <find+0x16>
			result = 1;
			break;
		}
	}

	return result;
  800b46:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800b49:	c9                   	leave  
  800b4a:	c3                   	ret    

00800b4b <libmain>:
volatile struct Env *myEnv = NULL;
volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";

void
libmain(int argc, char **argv)
{
  800b4b:	55                   	push   %ebp
  800b4c:	89 e5                	mov    %esp,%ebp
  800b4e:	83 ec 18             	sub    $0x18,%esp
	int envIndex = sys_getenvindex();
  800b51:	e8 63 1a 00 00       	call   8025b9 <sys_getenvindex>
  800b56:	89 45 f4             	mov    %eax,-0xc(%ebp)
	myEnv = &(envs[envIndex]);
  800b59:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800b5c:	89 d0                	mov    %edx,%eax
  800b5e:	c1 e0 03             	shl    $0x3,%eax
  800b61:	01 d0                	add    %edx,%eax
  800b63:	01 c0                	add    %eax,%eax
  800b65:	01 d0                	add    %edx,%eax
  800b67:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800b6e:	01 d0                	add    %edx,%eax
  800b70:	c1 e0 04             	shl    $0x4,%eax
  800b73:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  800b78:	a3 20 50 80 00       	mov    %eax,0x805020

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  800b7d:	a1 20 50 80 00       	mov    0x805020,%eax
  800b82:	8a 80 5c 05 00 00    	mov    0x55c(%eax),%al
  800b88:	84 c0                	test   %al,%al
  800b8a:	74 0f                	je     800b9b <libmain+0x50>
		binaryname = myEnv->prog_name;
  800b8c:	a1 20 50 80 00       	mov    0x805020,%eax
  800b91:	05 5c 05 00 00       	add    $0x55c,%eax
  800b96:	a3 00 50 80 00       	mov    %eax,0x805000

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  800b9b:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800b9f:	7e 0a                	jle    800bab <libmain+0x60>
		binaryname = argv[0];
  800ba1:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ba4:	8b 00                	mov    (%eax),%eax
  800ba6:	a3 00 50 80 00       	mov    %eax,0x805000

	// call user main routine
	_main(argc, argv);
  800bab:	83 ec 08             	sub    $0x8,%esp
  800bae:	ff 75 0c             	pushl  0xc(%ebp)
  800bb1:	ff 75 08             	pushl  0x8(%ebp)
  800bb4:	e8 7f f4 ff ff       	call   800038 <_main>
  800bb9:	83 c4 10             	add    $0x10,%esp



	sys_disable_interrupt();
  800bbc:	e8 05 18 00 00       	call   8023c6 <sys_disable_interrupt>
	cprintf("**************************************\n");
  800bc1:	83 ec 0c             	sub    $0xc,%esp
  800bc4:	68 88 3f 80 00       	push   $0x803f88
  800bc9:	e8 6d 03 00 00       	call   800f3b <cprintf>
  800bce:	83 c4 10             	add    $0x10,%esp
	cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  800bd1:	a1 20 50 80 00       	mov    0x805020,%eax
  800bd6:	8b 90 44 05 00 00    	mov    0x544(%eax),%edx
  800bdc:	a1 20 50 80 00       	mov    0x805020,%eax
  800be1:	8b 80 34 05 00 00    	mov    0x534(%eax),%eax
  800be7:	83 ec 04             	sub    $0x4,%esp
  800bea:	52                   	push   %edx
  800beb:	50                   	push   %eax
  800bec:	68 b0 3f 80 00       	push   $0x803fb0
  800bf1:	e8 45 03 00 00       	call   800f3b <cprintf>
  800bf6:	83 c4 10             	add    $0x10,%esp
	cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  800bf9:	a1 20 50 80 00       	mov    0x805020,%eax
  800bfe:	8b 88 54 05 00 00    	mov    0x554(%eax),%ecx
  800c04:	a1 20 50 80 00       	mov    0x805020,%eax
  800c09:	8b 90 50 05 00 00    	mov    0x550(%eax),%edx
  800c0f:	a1 20 50 80 00       	mov    0x805020,%eax
  800c14:	8b 80 4c 05 00 00    	mov    0x54c(%eax),%eax
  800c1a:	51                   	push   %ecx
  800c1b:	52                   	push   %edx
  800c1c:	50                   	push   %eax
  800c1d:	68 d8 3f 80 00       	push   $0x803fd8
  800c22:	e8 14 03 00 00       	call   800f3b <cprintf>
  800c27:	83 c4 10             	add    $0x10,%esp
	//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
	cprintf("Num of clocks = %d\n", myEnv->nClocks);
  800c2a:	a1 20 50 80 00       	mov    0x805020,%eax
  800c2f:	8b 80 a4 05 00 00    	mov    0x5a4(%eax),%eax
  800c35:	83 ec 08             	sub    $0x8,%esp
  800c38:	50                   	push   %eax
  800c39:	68 30 40 80 00       	push   $0x804030
  800c3e:	e8 f8 02 00 00       	call   800f3b <cprintf>
  800c43:	83 c4 10             	add    $0x10,%esp
	cprintf("**************************************\n");
  800c46:	83 ec 0c             	sub    $0xc,%esp
  800c49:	68 88 3f 80 00       	push   $0x803f88
  800c4e:	e8 e8 02 00 00       	call   800f3b <cprintf>
  800c53:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  800c56:	e8 85 17 00 00       	call   8023e0 <sys_enable_interrupt>

	// exit gracefully
	exit();
  800c5b:	e8 19 00 00 00       	call   800c79 <exit>
}
  800c60:	90                   	nop
  800c61:	c9                   	leave  
  800c62:	c3                   	ret    

00800c63 <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  800c63:	55                   	push   %ebp
  800c64:	89 e5                	mov    %esp,%ebp
  800c66:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  800c69:	83 ec 0c             	sub    $0xc,%esp
  800c6c:	6a 00                	push   $0x0
  800c6e:	e8 12 19 00 00       	call   802585 <sys_destroy_env>
  800c73:	83 c4 10             	add    $0x10,%esp
}
  800c76:	90                   	nop
  800c77:	c9                   	leave  
  800c78:	c3                   	ret    

00800c79 <exit>:

void
exit(void)
{
  800c79:	55                   	push   %ebp
  800c7a:	89 e5                	mov    %esp,%ebp
  800c7c:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  800c7f:	e8 67 19 00 00       	call   8025eb <sys_exit_env>
}
  800c84:	90                   	nop
  800c85:	c9                   	leave  
  800c86:	c3                   	ret    

00800c87 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  800c87:	55                   	push   %ebp
  800c88:	89 e5                	mov    %esp,%ebp
  800c8a:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  800c8d:	8d 45 10             	lea    0x10(%ebp),%eax
  800c90:	83 c0 04             	add    $0x4,%eax
  800c93:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  800c96:	a1 5c 51 80 00       	mov    0x80515c,%eax
  800c9b:	85 c0                	test   %eax,%eax
  800c9d:	74 16                	je     800cb5 <_panic+0x2e>
		cprintf("%s: ", argv0);
  800c9f:	a1 5c 51 80 00       	mov    0x80515c,%eax
  800ca4:	83 ec 08             	sub    $0x8,%esp
  800ca7:	50                   	push   %eax
  800ca8:	68 44 40 80 00       	push   $0x804044
  800cad:	e8 89 02 00 00       	call   800f3b <cprintf>
  800cb2:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  800cb5:	a1 00 50 80 00       	mov    0x805000,%eax
  800cba:	ff 75 0c             	pushl  0xc(%ebp)
  800cbd:	ff 75 08             	pushl  0x8(%ebp)
  800cc0:	50                   	push   %eax
  800cc1:	68 49 40 80 00       	push   $0x804049
  800cc6:	e8 70 02 00 00       	call   800f3b <cprintf>
  800ccb:	83 c4 10             	add    $0x10,%esp
	vcprintf(fmt, ap);
  800cce:	8b 45 10             	mov    0x10(%ebp),%eax
  800cd1:	83 ec 08             	sub    $0x8,%esp
  800cd4:	ff 75 f4             	pushl  -0xc(%ebp)
  800cd7:	50                   	push   %eax
  800cd8:	e8 f3 01 00 00       	call   800ed0 <vcprintf>
  800cdd:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  800ce0:	83 ec 08             	sub    $0x8,%esp
  800ce3:	6a 00                	push   $0x0
  800ce5:	68 65 40 80 00       	push   $0x804065
  800cea:	e8 e1 01 00 00       	call   800ed0 <vcprintf>
  800cef:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  800cf2:	e8 82 ff ff ff       	call   800c79 <exit>

	// should not return here
	while (1) ;
  800cf7:	eb fe                	jmp    800cf7 <_panic+0x70>

00800cf9 <CheckWSWithoutLastIndex>:
}

void CheckWSWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  800cf9:	55                   	push   %ebp
  800cfa:	89 e5                	mov    %esp,%ebp
  800cfc:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  800cff:	a1 20 50 80 00       	mov    0x805020,%eax
  800d04:	8b 50 74             	mov    0x74(%eax),%edx
  800d07:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d0a:	39 c2                	cmp    %eax,%edx
  800d0c:	74 14                	je     800d22 <CheckWSWithoutLastIndex+0x29>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  800d0e:	83 ec 04             	sub    $0x4,%esp
  800d11:	68 68 40 80 00       	push   $0x804068
  800d16:	6a 26                	push   $0x26
  800d18:	68 b4 40 80 00       	push   $0x8040b4
  800d1d:	e8 65 ff ff ff       	call   800c87 <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  800d22:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  800d29:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800d30:	e9 c2 00 00 00       	jmp    800df7 <CheckWSWithoutLastIndex+0xfe>
		if (expectedPages[e] == 0) {
  800d35:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800d38:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800d3f:	8b 45 08             	mov    0x8(%ebp),%eax
  800d42:	01 d0                	add    %edx,%eax
  800d44:	8b 00                	mov    (%eax),%eax
  800d46:	85 c0                	test   %eax,%eax
  800d48:	75 08                	jne    800d52 <CheckWSWithoutLastIndex+0x59>
			expectedNumOfEmptyLocs++;
  800d4a:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  800d4d:	e9 a2 00 00 00       	jmp    800df4 <CheckWSWithoutLastIndex+0xfb>
		}
		int found = 0;
  800d52:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800d59:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  800d60:	eb 69                	jmp    800dcb <CheckWSWithoutLastIndex+0xd2>
			if (myEnv->__uptr_pws[w].empty == 0) {
  800d62:	a1 20 50 80 00       	mov    0x805020,%eax
  800d67:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  800d6d:	8b 55 e8             	mov    -0x18(%ebp),%edx
  800d70:	89 d0                	mov    %edx,%eax
  800d72:	01 c0                	add    %eax,%eax
  800d74:	01 d0                	add    %edx,%eax
  800d76:	c1 e0 03             	shl    $0x3,%eax
  800d79:	01 c8                	add    %ecx,%eax
  800d7b:	8a 40 04             	mov    0x4(%eax),%al
  800d7e:	84 c0                	test   %al,%al
  800d80:	75 46                	jne    800dc8 <CheckWSWithoutLastIndex+0xcf>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  800d82:	a1 20 50 80 00       	mov    0x805020,%eax
  800d87:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  800d8d:	8b 55 e8             	mov    -0x18(%ebp),%edx
  800d90:	89 d0                	mov    %edx,%eax
  800d92:	01 c0                	add    %eax,%eax
  800d94:	01 d0                	add    %edx,%eax
  800d96:	c1 e0 03             	shl    $0x3,%eax
  800d99:	01 c8                	add    %ecx,%eax
  800d9b:	8b 00                	mov    (%eax),%eax
  800d9d:	89 45 dc             	mov    %eax,-0x24(%ebp)
  800da0:	8b 45 dc             	mov    -0x24(%ebp),%eax
  800da3:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800da8:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  800daa:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800dad:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  800db4:	8b 45 08             	mov    0x8(%ebp),%eax
  800db7:	01 c8                	add    %ecx,%eax
  800db9:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  800dbb:	39 c2                	cmp    %eax,%edx
  800dbd:	75 09                	jne    800dc8 <CheckWSWithoutLastIndex+0xcf>
						== expectedPages[e]) {
					found = 1;
  800dbf:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  800dc6:	eb 12                	jmp    800dda <CheckWSWithoutLastIndex+0xe1>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800dc8:	ff 45 e8             	incl   -0x18(%ebp)
  800dcb:	a1 20 50 80 00       	mov    0x805020,%eax
  800dd0:	8b 50 74             	mov    0x74(%eax),%edx
  800dd3:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800dd6:	39 c2                	cmp    %eax,%edx
  800dd8:	77 88                	ja     800d62 <CheckWSWithoutLastIndex+0x69>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  800dda:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  800dde:	75 14                	jne    800df4 <CheckWSWithoutLastIndex+0xfb>
			panic(
  800de0:	83 ec 04             	sub    $0x4,%esp
  800de3:	68 c0 40 80 00       	push   $0x8040c0
  800de8:	6a 3a                	push   $0x3a
  800dea:	68 b4 40 80 00       	push   $0x8040b4
  800def:	e8 93 fe ff ff       	call   800c87 <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  800df4:	ff 45 f0             	incl   -0x10(%ebp)
  800df7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800dfa:	3b 45 0c             	cmp    0xc(%ebp),%eax
  800dfd:	0f 8c 32 ff ff ff    	jl     800d35 <CheckWSWithoutLastIndex+0x3c>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  800e03:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800e0a:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  800e11:	eb 26                	jmp    800e39 <CheckWSWithoutLastIndex+0x140>
		if (myEnv->__uptr_pws[w].empty == 1) {
  800e13:	a1 20 50 80 00       	mov    0x805020,%eax
  800e18:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  800e1e:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800e21:	89 d0                	mov    %edx,%eax
  800e23:	01 c0                	add    %eax,%eax
  800e25:	01 d0                	add    %edx,%eax
  800e27:	c1 e0 03             	shl    $0x3,%eax
  800e2a:	01 c8                	add    %ecx,%eax
  800e2c:	8a 40 04             	mov    0x4(%eax),%al
  800e2f:	3c 01                	cmp    $0x1,%al
  800e31:	75 03                	jne    800e36 <CheckWSWithoutLastIndex+0x13d>
			actualNumOfEmptyLocs++;
  800e33:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800e36:	ff 45 e0             	incl   -0x20(%ebp)
  800e39:	a1 20 50 80 00       	mov    0x805020,%eax
  800e3e:	8b 50 74             	mov    0x74(%eax),%edx
  800e41:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800e44:	39 c2                	cmp    %eax,%edx
  800e46:	77 cb                	ja     800e13 <CheckWSWithoutLastIndex+0x11a>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  800e48:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800e4b:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  800e4e:	74 14                	je     800e64 <CheckWSWithoutLastIndex+0x16b>
		panic(
  800e50:	83 ec 04             	sub    $0x4,%esp
  800e53:	68 14 41 80 00       	push   $0x804114
  800e58:	6a 44                	push   $0x44
  800e5a:	68 b4 40 80 00       	push   $0x8040b4
  800e5f:	e8 23 fe ff ff       	call   800c87 <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  800e64:	90                   	nop
  800e65:	c9                   	leave  
  800e66:	c3                   	ret    

00800e67 <putch>:
};

//2017:
uint8 printProgName = 0;

static void putch(int ch, struct printbuf *b) {
  800e67:	55                   	push   %ebp
  800e68:	89 e5                	mov    %esp,%ebp
  800e6a:	83 ec 08             	sub    $0x8,%esp
	b->buf[b->idx++] = ch;
  800e6d:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e70:	8b 00                	mov    (%eax),%eax
  800e72:	8d 48 01             	lea    0x1(%eax),%ecx
  800e75:	8b 55 0c             	mov    0xc(%ebp),%edx
  800e78:	89 0a                	mov    %ecx,(%edx)
  800e7a:	8b 55 08             	mov    0x8(%ebp),%edx
  800e7d:	88 d1                	mov    %dl,%cl
  800e7f:	8b 55 0c             	mov    0xc(%ebp),%edx
  800e82:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  800e86:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e89:	8b 00                	mov    (%eax),%eax
  800e8b:	3d ff 00 00 00       	cmp    $0xff,%eax
  800e90:	75 2c                	jne    800ebe <putch+0x57>
		sys_cputs(b->buf, b->idx, printProgName);
  800e92:	a0 24 50 80 00       	mov    0x805024,%al
  800e97:	0f b6 c0             	movzbl %al,%eax
  800e9a:	8b 55 0c             	mov    0xc(%ebp),%edx
  800e9d:	8b 12                	mov    (%edx),%edx
  800e9f:	89 d1                	mov    %edx,%ecx
  800ea1:	8b 55 0c             	mov    0xc(%ebp),%edx
  800ea4:	83 c2 08             	add    $0x8,%edx
  800ea7:	83 ec 04             	sub    $0x4,%esp
  800eaa:	50                   	push   %eax
  800eab:	51                   	push   %ecx
  800eac:	52                   	push   %edx
  800ead:	e8 66 13 00 00       	call   802218 <sys_cputs>
  800eb2:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  800eb5:	8b 45 0c             	mov    0xc(%ebp),%eax
  800eb8:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  800ebe:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ec1:	8b 40 04             	mov    0x4(%eax),%eax
  800ec4:	8d 50 01             	lea    0x1(%eax),%edx
  800ec7:	8b 45 0c             	mov    0xc(%ebp),%eax
  800eca:	89 50 04             	mov    %edx,0x4(%eax)
}
  800ecd:	90                   	nop
  800ece:	c9                   	leave  
  800ecf:	c3                   	ret    

00800ed0 <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  800ed0:	55                   	push   %ebp
  800ed1:	89 e5                	mov    %esp,%ebp
  800ed3:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  800ed9:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  800ee0:	00 00 00 
	b.cnt = 0;
  800ee3:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  800eea:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  800eed:	ff 75 0c             	pushl  0xc(%ebp)
  800ef0:	ff 75 08             	pushl  0x8(%ebp)
  800ef3:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800ef9:	50                   	push   %eax
  800efa:	68 67 0e 80 00       	push   $0x800e67
  800eff:	e8 11 02 00 00       	call   801115 <vprintfmt>
  800f04:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName);
  800f07:	a0 24 50 80 00       	mov    0x805024,%al
  800f0c:	0f b6 c0             	movzbl %al,%eax
  800f0f:	8b 95 f0 fe ff ff    	mov    -0x110(%ebp),%edx
  800f15:	83 ec 04             	sub    $0x4,%esp
  800f18:	50                   	push   %eax
  800f19:	52                   	push   %edx
  800f1a:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800f20:	83 c0 08             	add    $0x8,%eax
  800f23:	50                   	push   %eax
  800f24:	e8 ef 12 00 00       	call   802218 <sys_cputs>
  800f29:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  800f2c:	c6 05 24 50 80 00 00 	movb   $0x0,0x805024
	return b.cnt;
  800f33:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  800f39:	c9                   	leave  
  800f3a:	c3                   	ret    

00800f3b <cprintf>:

int cprintf(const char *fmt, ...) {
  800f3b:	55                   	push   %ebp
  800f3c:	89 e5                	mov    %esp,%ebp
  800f3e:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  800f41:	c6 05 24 50 80 00 01 	movb   $0x1,0x805024
	va_start(ap, fmt);
  800f48:	8d 45 0c             	lea    0xc(%ebp),%eax
  800f4b:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800f4e:	8b 45 08             	mov    0x8(%ebp),%eax
  800f51:	83 ec 08             	sub    $0x8,%esp
  800f54:	ff 75 f4             	pushl  -0xc(%ebp)
  800f57:	50                   	push   %eax
  800f58:	e8 73 ff ff ff       	call   800ed0 <vcprintf>
  800f5d:	83 c4 10             	add    $0x10,%esp
  800f60:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  800f63:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800f66:	c9                   	leave  
  800f67:	c3                   	ret    

00800f68 <atomic_cprintf>:

int atomic_cprintf(const char *fmt, ...) {
  800f68:	55                   	push   %ebp
  800f69:	89 e5                	mov    %esp,%ebp
  800f6b:	83 ec 18             	sub    $0x18,%esp
	sys_disable_interrupt();
  800f6e:	e8 53 14 00 00       	call   8023c6 <sys_disable_interrupt>
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  800f73:	8d 45 0c             	lea    0xc(%ebp),%eax
  800f76:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800f79:	8b 45 08             	mov    0x8(%ebp),%eax
  800f7c:	83 ec 08             	sub    $0x8,%esp
  800f7f:	ff 75 f4             	pushl  -0xc(%ebp)
  800f82:	50                   	push   %eax
  800f83:	e8 48 ff ff ff       	call   800ed0 <vcprintf>
  800f88:	83 c4 10             	add    $0x10,%esp
  800f8b:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	sys_enable_interrupt();
  800f8e:	e8 4d 14 00 00       	call   8023e0 <sys_enable_interrupt>
	return cnt;
  800f93:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800f96:	c9                   	leave  
  800f97:	c3                   	ret    

00800f98 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800f98:	55                   	push   %ebp
  800f99:	89 e5                	mov    %esp,%ebp
  800f9b:	53                   	push   %ebx
  800f9c:	83 ec 14             	sub    $0x14,%esp
  800f9f:	8b 45 10             	mov    0x10(%ebp),%eax
  800fa2:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800fa5:	8b 45 14             	mov    0x14(%ebp),%eax
  800fa8:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800fab:	8b 45 18             	mov    0x18(%ebp),%eax
  800fae:	ba 00 00 00 00       	mov    $0x0,%edx
  800fb3:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800fb6:	77 55                	ja     80100d <printnum+0x75>
  800fb8:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800fbb:	72 05                	jb     800fc2 <printnum+0x2a>
  800fbd:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  800fc0:	77 4b                	ja     80100d <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800fc2:	8b 45 1c             	mov    0x1c(%ebp),%eax
  800fc5:	8d 58 ff             	lea    -0x1(%eax),%ebx
  800fc8:	8b 45 18             	mov    0x18(%ebp),%eax
  800fcb:	ba 00 00 00 00       	mov    $0x0,%edx
  800fd0:	52                   	push   %edx
  800fd1:	50                   	push   %eax
  800fd2:	ff 75 f4             	pushl  -0xc(%ebp)
  800fd5:	ff 75 f0             	pushl  -0x10(%ebp)
  800fd8:	e8 3b 29 00 00       	call   803918 <__udivdi3>
  800fdd:	83 c4 10             	add    $0x10,%esp
  800fe0:	83 ec 04             	sub    $0x4,%esp
  800fe3:	ff 75 20             	pushl  0x20(%ebp)
  800fe6:	53                   	push   %ebx
  800fe7:	ff 75 18             	pushl  0x18(%ebp)
  800fea:	52                   	push   %edx
  800feb:	50                   	push   %eax
  800fec:	ff 75 0c             	pushl  0xc(%ebp)
  800fef:	ff 75 08             	pushl  0x8(%ebp)
  800ff2:	e8 a1 ff ff ff       	call   800f98 <printnum>
  800ff7:	83 c4 20             	add    $0x20,%esp
  800ffa:	eb 1a                	jmp    801016 <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  800ffc:	83 ec 08             	sub    $0x8,%esp
  800fff:	ff 75 0c             	pushl  0xc(%ebp)
  801002:	ff 75 20             	pushl  0x20(%ebp)
  801005:	8b 45 08             	mov    0x8(%ebp),%eax
  801008:	ff d0                	call   *%eax
  80100a:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  80100d:	ff 4d 1c             	decl   0x1c(%ebp)
  801010:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  801014:	7f e6                	jg     800ffc <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  801016:	8b 4d 18             	mov    0x18(%ebp),%ecx
  801019:	bb 00 00 00 00       	mov    $0x0,%ebx
  80101e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801021:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801024:	53                   	push   %ebx
  801025:	51                   	push   %ecx
  801026:	52                   	push   %edx
  801027:	50                   	push   %eax
  801028:	e8 fb 29 00 00       	call   803a28 <__umoddi3>
  80102d:	83 c4 10             	add    $0x10,%esp
  801030:	05 74 43 80 00       	add    $0x804374,%eax
  801035:	8a 00                	mov    (%eax),%al
  801037:	0f be c0             	movsbl %al,%eax
  80103a:	83 ec 08             	sub    $0x8,%esp
  80103d:	ff 75 0c             	pushl  0xc(%ebp)
  801040:	50                   	push   %eax
  801041:	8b 45 08             	mov    0x8(%ebp),%eax
  801044:	ff d0                	call   *%eax
  801046:	83 c4 10             	add    $0x10,%esp
}
  801049:	90                   	nop
  80104a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80104d:	c9                   	leave  
  80104e:	c3                   	ret    

0080104f <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  80104f:	55                   	push   %ebp
  801050:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  801052:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  801056:	7e 1c                	jle    801074 <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  801058:	8b 45 08             	mov    0x8(%ebp),%eax
  80105b:	8b 00                	mov    (%eax),%eax
  80105d:	8d 50 08             	lea    0x8(%eax),%edx
  801060:	8b 45 08             	mov    0x8(%ebp),%eax
  801063:	89 10                	mov    %edx,(%eax)
  801065:	8b 45 08             	mov    0x8(%ebp),%eax
  801068:	8b 00                	mov    (%eax),%eax
  80106a:	83 e8 08             	sub    $0x8,%eax
  80106d:	8b 50 04             	mov    0x4(%eax),%edx
  801070:	8b 00                	mov    (%eax),%eax
  801072:	eb 40                	jmp    8010b4 <getuint+0x65>
	else if (lflag)
  801074:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801078:	74 1e                	je     801098 <getuint+0x49>
		return va_arg(*ap, unsigned long);
  80107a:	8b 45 08             	mov    0x8(%ebp),%eax
  80107d:	8b 00                	mov    (%eax),%eax
  80107f:	8d 50 04             	lea    0x4(%eax),%edx
  801082:	8b 45 08             	mov    0x8(%ebp),%eax
  801085:	89 10                	mov    %edx,(%eax)
  801087:	8b 45 08             	mov    0x8(%ebp),%eax
  80108a:	8b 00                	mov    (%eax),%eax
  80108c:	83 e8 04             	sub    $0x4,%eax
  80108f:	8b 00                	mov    (%eax),%eax
  801091:	ba 00 00 00 00       	mov    $0x0,%edx
  801096:	eb 1c                	jmp    8010b4 <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  801098:	8b 45 08             	mov    0x8(%ebp),%eax
  80109b:	8b 00                	mov    (%eax),%eax
  80109d:	8d 50 04             	lea    0x4(%eax),%edx
  8010a0:	8b 45 08             	mov    0x8(%ebp),%eax
  8010a3:	89 10                	mov    %edx,(%eax)
  8010a5:	8b 45 08             	mov    0x8(%ebp),%eax
  8010a8:	8b 00                	mov    (%eax),%eax
  8010aa:	83 e8 04             	sub    $0x4,%eax
  8010ad:	8b 00                	mov    (%eax),%eax
  8010af:	ba 00 00 00 00       	mov    $0x0,%edx
}
  8010b4:	5d                   	pop    %ebp
  8010b5:	c3                   	ret    

008010b6 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  8010b6:	55                   	push   %ebp
  8010b7:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  8010b9:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  8010bd:	7e 1c                	jle    8010db <getint+0x25>
		return va_arg(*ap, long long);
  8010bf:	8b 45 08             	mov    0x8(%ebp),%eax
  8010c2:	8b 00                	mov    (%eax),%eax
  8010c4:	8d 50 08             	lea    0x8(%eax),%edx
  8010c7:	8b 45 08             	mov    0x8(%ebp),%eax
  8010ca:	89 10                	mov    %edx,(%eax)
  8010cc:	8b 45 08             	mov    0x8(%ebp),%eax
  8010cf:	8b 00                	mov    (%eax),%eax
  8010d1:	83 e8 08             	sub    $0x8,%eax
  8010d4:	8b 50 04             	mov    0x4(%eax),%edx
  8010d7:	8b 00                	mov    (%eax),%eax
  8010d9:	eb 38                	jmp    801113 <getint+0x5d>
	else if (lflag)
  8010db:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8010df:	74 1a                	je     8010fb <getint+0x45>
		return va_arg(*ap, long);
  8010e1:	8b 45 08             	mov    0x8(%ebp),%eax
  8010e4:	8b 00                	mov    (%eax),%eax
  8010e6:	8d 50 04             	lea    0x4(%eax),%edx
  8010e9:	8b 45 08             	mov    0x8(%ebp),%eax
  8010ec:	89 10                	mov    %edx,(%eax)
  8010ee:	8b 45 08             	mov    0x8(%ebp),%eax
  8010f1:	8b 00                	mov    (%eax),%eax
  8010f3:	83 e8 04             	sub    $0x4,%eax
  8010f6:	8b 00                	mov    (%eax),%eax
  8010f8:	99                   	cltd   
  8010f9:	eb 18                	jmp    801113 <getint+0x5d>
	else
		return va_arg(*ap, int);
  8010fb:	8b 45 08             	mov    0x8(%ebp),%eax
  8010fe:	8b 00                	mov    (%eax),%eax
  801100:	8d 50 04             	lea    0x4(%eax),%edx
  801103:	8b 45 08             	mov    0x8(%ebp),%eax
  801106:	89 10                	mov    %edx,(%eax)
  801108:	8b 45 08             	mov    0x8(%ebp),%eax
  80110b:	8b 00                	mov    (%eax),%eax
  80110d:	83 e8 04             	sub    $0x4,%eax
  801110:	8b 00                	mov    (%eax),%eax
  801112:	99                   	cltd   
}
  801113:	5d                   	pop    %ebp
  801114:	c3                   	ret    

00801115 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  801115:	55                   	push   %ebp
  801116:	89 e5                	mov    %esp,%ebp
  801118:	56                   	push   %esi
  801119:	53                   	push   %ebx
  80111a:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  80111d:	eb 17                	jmp    801136 <vprintfmt+0x21>
			if (ch == '\0')
  80111f:	85 db                	test   %ebx,%ebx
  801121:	0f 84 af 03 00 00    	je     8014d6 <vprintfmt+0x3c1>
				return;
			putch(ch, putdat);
  801127:	83 ec 08             	sub    $0x8,%esp
  80112a:	ff 75 0c             	pushl  0xc(%ebp)
  80112d:	53                   	push   %ebx
  80112e:	8b 45 08             	mov    0x8(%ebp),%eax
  801131:	ff d0                	call   *%eax
  801133:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  801136:	8b 45 10             	mov    0x10(%ebp),%eax
  801139:	8d 50 01             	lea    0x1(%eax),%edx
  80113c:	89 55 10             	mov    %edx,0x10(%ebp)
  80113f:	8a 00                	mov    (%eax),%al
  801141:	0f b6 d8             	movzbl %al,%ebx
  801144:	83 fb 25             	cmp    $0x25,%ebx
  801147:	75 d6                	jne    80111f <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  801149:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  80114d:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  801154:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  80115b:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  801162:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  801169:	8b 45 10             	mov    0x10(%ebp),%eax
  80116c:	8d 50 01             	lea    0x1(%eax),%edx
  80116f:	89 55 10             	mov    %edx,0x10(%ebp)
  801172:	8a 00                	mov    (%eax),%al
  801174:	0f b6 d8             	movzbl %al,%ebx
  801177:	8d 43 dd             	lea    -0x23(%ebx),%eax
  80117a:	83 f8 55             	cmp    $0x55,%eax
  80117d:	0f 87 2b 03 00 00    	ja     8014ae <vprintfmt+0x399>
  801183:	8b 04 85 98 43 80 00 	mov    0x804398(,%eax,4),%eax
  80118a:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  80118c:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  801190:	eb d7                	jmp    801169 <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  801192:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  801196:	eb d1                	jmp    801169 <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  801198:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  80119f:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8011a2:	89 d0                	mov    %edx,%eax
  8011a4:	c1 e0 02             	shl    $0x2,%eax
  8011a7:	01 d0                	add    %edx,%eax
  8011a9:	01 c0                	add    %eax,%eax
  8011ab:	01 d8                	add    %ebx,%eax
  8011ad:	83 e8 30             	sub    $0x30,%eax
  8011b0:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  8011b3:	8b 45 10             	mov    0x10(%ebp),%eax
  8011b6:	8a 00                	mov    (%eax),%al
  8011b8:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  8011bb:	83 fb 2f             	cmp    $0x2f,%ebx
  8011be:	7e 3e                	jle    8011fe <vprintfmt+0xe9>
  8011c0:	83 fb 39             	cmp    $0x39,%ebx
  8011c3:	7f 39                	jg     8011fe <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8011c5:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  8011c8:	eb d5                	jmp    80119f <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  8011ca:	8b 45 14             	mov    0x14(%ebp),%eax
  8011cd:	83 c0 04             	add    $0x4,%eax
  8011d0:	89 45 14             	mov    %eax,0x14(%ebp)
  8011d3:	8b 45 14             	mov    0x14(%ebp),%eax
  8011d6:	83 e8 04             	sub    $0x4,%eax
  8011d9:	8b 00                	mov    (%eax),%eax
  8011db:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  8011de:	eb 1f                	jmp    8011ff <vprintfmt+0xea>

		case '.':
			if (width < 0)
  8011e0:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8011e4:	79 83                	jns    801169 <vprintfmt+0x54>
				width = 0;
  8011e6:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  8011ed:	e9 77 ff ff ff       	jmp    801169 <vprintfmt+0x54>

		case '#':
			altflag = 1;
  8011f2:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  8011f9:	e9 6b ff ff ff       	jmp    801169 <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  8011fe:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  8011ff:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  801203:	0f 89 60 ff ff ff    	jns    801169 <vprintfmt+0x54>
				width = precision, precision = -1;
  801209:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80120c:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  80120f:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  801216:	e9 4e ff ff ff       	jmp    801169 <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  80121b:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  80121e:	e9 46 ff ff ff       	jmp    801169 <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  801223:	8b 45 14             	mov    0x14(%ebp),%eax
  801226:	83 c0 04             	add    $0x4,%eax
  801229:	89 45 14             	mov    %eax,0x14(%ebp)
  80122c:	8b 45 14             	mov    0x14(%ebp),%eax
  80122f:	83 e8 04             	sub    $0x4,%eax
  801232:	8b 00                	mov    (%eax),%eax
  801234:	83 ec 08             	sub    $0x8,%esp
  801237:	ff 75 0c             	pushl  0xc(%ebp)
  80123a:	50                   	push   %eax
  80123b:	8b 45 08             	mov    0x8(%ebp),%eax
  80123e:	ff d0                	call   *%eax
  801240:	83 c4 10             	add    $0x10,%esp
			break;
  801243:	e9 89 02 00 00       	jmp    8014d1 <vprintfmt+0x3bc>

		// error message
		case 'e':
			err = va_arg(ap, int);
  801248:	8b 45 14             	mov    0x14(%ebp),%eax
  80124b:	83 c0 04             	add    $0x4,%eax
  80124e:	89 45 14             	mov    %eax,0x14(%ebp)
  801251:	8b 45 14             	mov    0x14(%ebp),%eax
  801254:	83 e8 04             	sub    $0x4,%eax
  801257:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  801259:	85 db                	test   %ebx,%ebx
  80125b:	79 02                	jns    80125f <vprintfmt+0x14a>
				err = -err;
  80125d:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  80125f:	83 fb 64             	cmp    $0x64,%ebx
  801262:	7f 0b                	jg     80126f <vprintfmt+0x15a>
  801264:	8b 34 9d e0 41 80 00 	mov    0x8041e0(,%ebx,4),%esi
  80126b:	85 f6                	test   %esi,%esi
  80126d:	75 19                	jne    801288 <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  80126f:	53                   	push   %ebx
  801270:	68 85 43 80 00       	push   $0x804385
  801275:	ff 75 0c             	pushl  0xc(%ebp)
  801278:	ff 75 08             	pushl  0x8(%ebp)
  80127b:	e8 5e 02 00 00       	call   8014de <printfmt>
  801280:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  801283:	e9 49 02 00 00       	jmp    8014d1 <vprintfmt+0x3bc>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  801288:	56                   	push   %esi
  801289:	68 8e 43 80 00       	push   $0x80438e
  80128e:	ff 75 0c             	pushl  0xc(%ebp)
  801291:	ff 75 08             	pushl  0x8(%ebp)
  801294:	e8 45 02 00 00       	call   8014de <printfmt>
  801299:	83 c4 10             	add    $0x10,%esp
			break;
  80129c:	e9 30 02 00 00       	jmp    8014d1 <vprintfmt+0x3bc>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  8012a1:	8b 45 14             	mov    0x14(%ebp),%eax
  8012a4:	83 c0 04             	add    $0x4,%eax
  8012a7:	89 45 14             	mov    %eax,0x14(%ebp)
  8012aa:	8b 45 14             	mov    0x14(%ebp),%eax
  8012ad:	83 e8 04             	sub    $0x4,%eax
  8012b0:	8b 30                	mov    (%eax),%esi
  8012b2:	85 f6                	test   %esi,%esi
  8012b4:	75 05                	jne    8012bb <vprintfmt+0x1a6>
				p = "(null)";
  8012b6:	be 91 43 80 00       	mov    $0x804391,%esi
			if (width > 0 && padc != '-')
  8012bb:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8012bf:	7e 6d                	jle    80132e <vprintfmt+0x219>
  8012c1:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  8012c5:	74 67                	je     80132e <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  8012c7:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8012ca:	83 ec 08             	sub    $0x8,%esp
  8012cd:	50                   	push   %eax
  8012ce:	56                   	push   %esi
  8012cf:	e8 0c 03 00 00       	call   8015e0 <strnlen>
  8012d4:	83 c4 10             	add    $0x10,%esp
  8012d7:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  8012da:	eb 16                	jmp    8012f2 <vprintfmt+0x1dd>
					putch(padc, putdat);
  8012dc:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  8012e0:	83 ec 08             	sub    $0x8,%esp
  8012e3:	ff 75 0c             	pushl  0xc(%ebp)
  8012e6:	50                   	push   %eax
  8012e7:	8b 45 08             	mov    0x8(%ebp),%eax
  8012ea:	ff d0                	call   *%eax
  8012ec:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  8012ef:	ff 4d e4             	decl   -0x1c(%ebp)
  8012f2:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8012f6:	7f e4                	jg     8012dc <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8012f8:	eb 34                	jmp    80132e <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  8012fa:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  8012fe:	74 1c                	je     80131c <vprintfmt+0x207>
  801300:	83 fb 1f             	cmp    $0x1f,%ebx
  801303:	7e 05                	jle    80130a <vprintfmt+0x1f5>
  801305:	83 fb 7e             	cmp    $0x7e,%ebx
  801308:	7e 12                	jle    80131c <vprintfmt+0x207>
					putch('?', putdat);
  80130a:	83 ec 08             	sub    $0x8,%esp
  80130d:	ff 75 0c             	pushl  0xc(%ebp)
  801310:	6a 3f                	push   $0x3f
  801312:	8b 45 08             	mov    0x8(%ebp),%eax
  801315:	ff d0                	call   *%eax
  801317:	83 c4 10             	add    $0x10,%esp
  80131a:	eb 0f                	jmp    80132b <vprintfmt+0x216>
				else
					putch(ch, putdat);
  80131c:	83 ec 08             	sub    $0x8,%esp
  80131f:	ff 75 0c             	pushl  0xc(%ebp)
  801322:	53                   	push   %ebx
  801323:	8b 45 08             	mov    0x8(%ebp),%eax
  801326:	ff d0                	call   *%eax
  801328:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  80132b:	ff 4d e4             	decl   -0x1c(%ebp)
  80132e:	89 f0                	mov    %esi,%eax
  801330:	8d 70 01             	lea    0x1(%eax),%esi
  801333:	8a 00                	mov    (%eax),%al
  801335:	0f be d8             	movsbl %al,%ebx
  801338:	85 db                	test   %ebx,%ebx
  80133a:	74 24                	je     801360 <vprintfmt+0x24b>
  80133c:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  801340:	78 b8                	js     8012fa <vprintfmt+0x1e5>
  801342:	ff 4d e0             	decl   -0x20(%ebp)
  801345:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  801349:	79 af                	jns    8012fa <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  80134b:	eb 13                	jmp    801360 <vprintfmt+0x24b>
				putch(' ', putdat);
  80134d:	83 ec 08             	sub    $0x8,%esp
  801350:	ff 75 0c             	pushl  0xc(%ebp)
  801353:	6a 20                	push   $0x20
  801355:	8b 45 08             	mov    0x8(%ebp),%eax
  801358:	ff d0                	call   *%eax
  80135a:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  80135d:	ff 4d e4             	decl   -0x1c(%ebp)
  801360:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  801364:	7f e7                	jg     80134d <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  801366:	e9 66 01 00 00       	jmp    8014d1 <vprintfmt+0x3bc>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  80136b:	83 ec 08             	sub    $0x8,%esp
  80136e:	ff 75 e8             	pushl  -0x18(%ebp)
  801371:	8d 45 14             	lea    0x14(%ebp),%eax
  801374:	50                   	push   %eax
  801375:	e8 3c fd ff ff       	call   8010b6 <getint>
  80137a:	83 c4 10             	add    $0x10,%esp
  80137d:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801380:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  801383:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801386:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801389:	85 d2                	test   %edx,%edx
  80138b:	79 23                	jns    8013b0 <vprintfmt+0x29b>
				putch('-', putdat);
  80138d:	83 ec 08             	sub    $0x8,%esp
  801390:	ff 75 0c             	pushl  0xc(%ebp)
  801393:	6a 2d                	push   $0x2d
  801395:	8b 45 08             	mov    0x8(%ebp),%eax
  801398:	ff d0                	call   *%eax
  80139a:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  80139d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8013a0:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8013a3:	f7 d8                	neg    %eax
  8013a5:	83 d2 00             	adc    $0x0,%edx
  8013a8:	f7 da                	neg    %edx
  8013aa:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8013ad:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  8013b0:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  8013b7:	e9 bc 00 00 00       	jmp    801478 <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  8013bc:	83 ec 08             	sub    $0x8,%esp
  8013bf:	ff 75 e8             	pushl  -0x18(%ebp)
  8013c2:	8d 45 14             	lea    0x14(%ebp),%eax
  8013c5:	50                   	push   %eax
  8013c6:	e8 84 fc ff ff       	call   80104f <getuint>
  8013cb:	83 c4 10             	add    $0x10,%esp
  8013ce:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8013d1:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  8013d4:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  8013db:	e9 98 00 00 00       	jmp    801478 <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  8013e0:	83 ec 08             	sub    $0x8,%esp
  8013e3:	ff 75 0c             	pushl  0xc(%ebp)
  8013e6:	6a 58                	push   $0x58
  8013e8:	8b 45 08             	mov    0x8(%ebp),%eax
  8013eb:	ff d0                	call   *%eax
  8013ed:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  8013f0:	83 ec 08             	sub    $0x8,%esp
  8013f3:	ff 75 0c             	pushl  0xc(%ebp)
  8013f6:	6a 58                	push   $0x58
  8013f8:	8b 45 08             	mov    0x8(%ebp),%eax
  8013fb:	ff d0                	call   *%eax
  8013fd:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  801400:	83 ec 08             	sub    $0x8,%esp
  801403:	ff 75 0c             	pushl  0xc(%ebp)
  801406:	6a 58                	push   $0x58
  801408:	8b 45 08             	mov    0x8(%ebp),%eax
  80140b:	ff d0                	call   *%eax
  80140d:	83 c4 10             	add    $0x10,%esp
			break;
  801410:	e9 bc 00 00 00       	jmp    8014d1 <vprintfmt+0x3bc>

		// pointer
		case 'p':
			putch('0', putdat);
  801415:	83 ec 08             	sub    $0x8,%esp
  801418:	ff 75 0c             	pushl  0xc(%ebp)
  80141b:	6a 30                	push   $0x30
  80141d:	8b 45 08             	mov    0x8(%ebp),%eax
  801420:	ff d0                	call   *%eax
  801422:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  801425:	83 ec 08             	sub    $0x8,%esp
  801428:	ff 75 0c             	pushl  0xc(%ebp)
  80142b:	6a 78                	push   $0x78
  80142d:	8b 45 08             	mov    0x8(%ebp),%eax
  801430:	ff d0                	call   *%eax
  801432:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  801435:	8b 45 14             	mov    0x14(%ebp),%eax
  801438:	83 c0 04             	add    $0x4,%eax
  80143b:	89 45 14             	mov    %eax,0x14(%ebp)
  80143e:	8b 45 14             	mov    0x14(%ebp),%eax
  801441:	83 e8 04             	sub    $0x4,%eax
  801444:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  801446:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801449:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  801450:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  801457:	eb 1f                	jmp    801478 <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  801459:	83 ec 08             	sub    $0x8,%esp
  80145c:	ff 75 e8             	pushl  -0x18(%ebp)
  80145f:	8d 45 14             	lea    0x14(%ebp),%eax
  801462:	50                   	push   %eax
  801463:	e8 e7 fb ff ff       	call   80104f <getuint>
  801468:	83 c4 10             	add    $0x10,%esp
  80146b:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80146e:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  801471:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  801478:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  80147c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80147f:	83 ec 04             	sub    $0x4,%esp
  801482:	52                   	push   %edx
  801483:	ff 75 e4             	pushl  -0x1c(%ebp)
  801486:	50                   	push   %eax
  801487:	ff 75 f4             	pushl  -0xc(%ebp)
  80148a:	ff 75 f0             	pushl  -0x10(%ebp)
  80148d:	ff 75 0c             	pushl  0xc(%ebp)
  801490:	ff 75 08             	pushl  0x8(%ebp)
  801493:	e8 00 fb ff ff       	call   800f98 <printnum>
  801498:	83 c4 20             	add    $0x20,%esp
			break;
  80149b:	eb 34                	jmp    8014d1 <vprintfmt+0x3bc>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  80149d:	83 ec 08             	sub    $0x8,%esp
  8014a0:	ff 75 0c             	pushl  0xc(%ebp)
  8014a3:	53                   	push   %ebx
  8014a4:	8b 45 08             	mov    0x8(%ebp),%eax
  8014a7:	ff d0                	call   *%eax
  8014a9:	83 c4 10             	add    $0x10,%esp
			break;
  8014ac:	eb 23                	jmp    8014d1 <vprintfmt+0x3bc>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  8014ae:	83 ec 08             	sub    $0x8,%esp
  8014b1:	ff 75 0c             	pushl  0xc(%ebp)
  8014b4:	6a 25                	push   $0x25
  8014b6:	8b 45 08             	mov    0x8(%ebp),%eax
  8014b9:	ff d0                	call   *%eax
  8014bb:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  8014be:	ff 4d 10             	decl   0x10(%ebp)
  8014c1:	eb 03                	jmp    8014c6 <vprintfmt+0x3b1>
  8014c3:	ff 4d 10             	decl   0x10(%ebp)
  8014c6:	8b 45 10             	mov    0x10(%ebp),%eax
  8014c9:	48                   	dec    %eax
  8014ca:	8a 00                	mov    (%eax),%al
  8014cc:	3c 25                	cmp    $0x25,%al
  8014ce:	75 f3                	jne    8014c3 <vprintfmt+0x3ae>
				/* do nothing */;
			break;
  8014d0:	90                   	nop
		}
	}
  8014d1:	e9 47 fc ff ff       	jmp    80111d <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  8014d6:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  8014d7:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8014da:	5b                   	pop    %ebx
  8014db:	5e                   	pop    %esi
  8014dc:	5d                   	pop    %ebp
  8014dd:	c3                   	ret    

008014de <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  8014de:	55                   	push   %ebp
  8014df:	89 e5                	mov    %esp,%ebp
  8014e1:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  8014e4:	8d 45 10             	lea    0x10(%ebp),%eax
  8014e7:	83 c0 04             	add    $0x4,%eax
  8014ea:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  8014ed:	8b 45 10             	mov    0x10(%ebp),%eax
  8014f0:	ff 75 f4             	pushl  -0xc(%ebp)
  8014f3:	50                   	push   %eax
  8014f4:	ff 75 0c             	pushl  0xc(%ebp)
  8014f7:	ff 75 08             	pushl  0x8(%ebp)
  8014fa:	e8 16 fc ff ff       	call   801115 <vprintfmt>
  8014ff:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  801502:	90                   	nop
  801503:	c9                   	leave  
  801504:	c3                   	ret    

00801505 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  801505:	55                   	push   %ebp
  801506:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  801508:	8b 45 0c             	mov    0xc(%ebp),%eax
  80150b:	8b 40 08             	mov    0x8(%eax),%eax
  80150e:	8d 50 01             	lea    0x1(%eax),%edx
  801511:	8b 45 0c             	mov    0xc(%ebp),%eax
  801514:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  801517:	8b 45 0c             	mov    0xc(%ebp),%eax
  80151a:	8b 10                	mov    (%eax),%edx
  80151c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80151f:	8b 40 04             	mov    0x4(%eax),%eax
  801522:	39 c2                	cmp    %eax,%edx
  801524:	73 12                	jae    801538 <sprintputch+0x33>
		*b->buf++ = ch;
  801526:	8b 45 0c             	mov    0xc(%ebp),%eax
  801529:	8b 00                	mov    (%eax),%eax
  80152b:	8d 48 01             	lea    0x1(%eax),%ecx
  80152e:	8b 55 0c             	mov    0xc(%ebp),%edx
  801531:	89 0a                	mov    %ecx,(%edx)
  801533:	8b 55 08             	mov    0x8(%ebp),%edx
  801536:	88 10                	mov    %dl,(%eax)
}
  801538:	90                   	nop
  801539:	5d                   	pop    %ebp
  80153a:	c3                   	ret    

0080153b <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  80153b:	55                   	push   %ebp
  80153c:	89 e5                	mov    %esp,%ebp
  80153e:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  801541:	8b 45 08             	mov    0x8(%ebp),%eax
  801544:	89 45 ec             	mov    %eax,-0x14(%ebp)
  801547:	8b 45 0c             	mov    0xc(%ebp),%eax
  80154a:	8d 50 ff             	lea    -0x1(%eax),%edx
  80154d:	8b 45 08             	mov    0x8(%ebp),%eax
  801550:	01 d0                	add    %edx,%eax
  801552:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801555:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  80155c:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801560:	74 06                	je     801568 <vsnprintf+0x2d>
  801562:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801566:	7f 07                	jg     80156f <vsnprintf+0x34>
		return -E_INVAL;
  801568:	b8 03 00 00 00       	mov    $0x3,%eax
  80156d:	eb 20                	jmp    80158f <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  80156f:	ff 75 14             	pushl  0x14(%ebp)
  801572:	ff 75 10             	pushl  0x10(%ebp)
  801575:	8d 45 ec             	lea    -0x14(%ebp),%eax
  801578:	50                   	push   %eax
  801579:	68 05 15 80 00       	push   $0x801505
  80157e:	e8 92 fb ff ff       	call   801115 <vprintfmt>
  801583:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  801586:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801589:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  80158c:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  80158f:	c9                   	leave  
  801590:	c3                   	ret    

00801591 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  801591:	55                   	push   %ebp
  801592:	89 e5                	mov    %esp,%ebp
  801594:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  801597:	8d 45 10             	lea    0x10(%ebp),%eax
  80159a:	83 c0 04             	add    $0x4,%eax
  80159d:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  8015a0:	8b 45 10             	mov    0x10(%ebp),%eax
  8015a3:	ff 75 f4             	pushl  -0xc(%ebp)
  8015a6:	50                   	push   %eax
  8015a7:	ff 75 0c             	pushl  0xc(%ebp)
  8015aa:	ff 75 08             	pushl  0x8(%ebp)
  8015ad:	e8 89 ff ff ff       	call   80153b <vsnprintf>
  8015b2:	83 c4 10             	add    $0x10,%esp
  8015b5:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  8015b8:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8015bb:	c9                   	leave  
  8015bc:	c3                   	ret    

008015bd <strlen>:

#include <inc/string.h>

int
strlen(const char *s)
{
  8015bd:	55                   	push   %ebp
  8015be:	89 e5                	mov    %esp,%ebp
  8015c0:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  8015c3:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8015ca:	eb 06                	jmp    8015d2 <strlen+0x15>
		n++;
  8015cc:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  8015cf:	ff 45 08             	incl   0x8(%ebp)
  8015d2:	8b 45 08             	mov    0x8(%ebp),%eax
  8015d5:	8a 00                	mov    (%eax),%al
  8015d7:	84 c0                	test   %al,%al
  8015d9:	75 f1                	jne    8015cc <strlen+0xf>
		n++;
	return n;
  8015db:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  8015de:	c9                   	leave  
  8015df:	c3                   	ret    

008015e0 <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  8015e0:	55                   	push   %ebp
  8015e1:	89 e5                	mov    %esp,%ebp
  8015e3:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  8015e6:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8015ed:	eb 09                	jmp    8015f8 <strnlen+0x18>
		n++;
  8015ef:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  8015f2:	ff 45 08             	incl   0x8(%ebp)
  8015f5:	ff 4d 0c             	decl   0xc(%ebp)
  8015f8:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8015fc:	74 09                	je     801607 <strnlen+0x27>
  8015fe:	8b 45 08             	mov    0x8(%ebp),%eax
  801601:	8a 00                	mov    (%eax),%al
  801603:	84 c0                	test   %al,%al
  801605:	75 e8                	jne    8015ef <strnlen+0xf>
		n++;
	return n;
  801607:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  80160a:	c9                   	leave  
  80160b:	c3                   	ret    

0080160c <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  80160c:	55                   	push   %ebp
  80160d:	89 e5                	mov    %esp,%ebp
  80160f:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  801612:	8b 45 08             	mov    0x8(%ebp),%eax
  801615:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  801618:	90                   	nop
  801619:	8b 45 08             	mov    0x8(%ebp),%eax
  80161c:	8d 50 01             	lea    0x1(%eax),%edx
  80161f:	89 55 08             	mov    %edx,0x8(%ebp)
  801622:	8b 55 0c             	mov    0xc(%ebp),%edx
  801625:	8d 4a 01             	lea    0x1(%edx),%ecx
  801628:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  80162b:	8a 12                	mov    (%edx),%dl
  80162d:	88 10                	mov    %dl,(%eax)
  80162f:	8a 00                	mov    (%eax),%al
  801631:	84 c0                	test   %al,%al
  801633:	75 e4                	jne    801619 <strcpy+0xd>
		/* do nothing */;
	return ret;
  801635:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  801638:	c9                   	leave  
  801639:	c3                   	ret    

0080163a <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  80163a:	55                   	push   %ebp
  80163b:	89 e5                	mov    %esp,%ebp
  80163d:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  801640:	8b 45 08             	mov    0x8(%ebp),%eax
  801643:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  801646:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  80164d:	eb 1f                	jmp    80166e <strncpy+0x34>
		*dst++ = *src;
  80164f:	8b 45 08             	mov    0x8(%ebp),%eax
  801652:	8d 50 01             	lea    0x1(%eax),%edx
  801655:	89 55 08             	mov    %edx,0x8(%ebp)
  801658:	8b 55 0c             	mov    0xc(%ebp),%edx
  80165b:	8a 12                	mov    (%edx),%dl
  80165d:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  80165f:	8b 45 0c             	mov    0xc(%ebp),%eax
  801662:	8a 00                	mov    (%eax),%al
  801664:	84 c0                	test   %al,%al
  801666:	74 03                	je     80166b <strncpy+0x31>
			src++;
  801668:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  80166b:	ff 45 fc             	incl   -0x4(%ebp)
  80166e:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801671:	3b 45 10             	cmp    0x10(%ebp),%eax
  801674:	72 d9                	jb     80164f <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  801676:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  801679:	c9                   	leave  
  80167a:	c3                   	ret    

0080167b <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  80167b:	55                   	push   %ebp
  80167c:	89 e5                	mov    %esp,%ebp
  80167e:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  801681:	8b 45 08             	mov    0x8(%ebp),%eax
  801684:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  801687:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80168b:	74 30                	je     8016bd <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  80168d:	eb 16                	jmp    8016a5 <strlcpy+0x2a>
			*dst++ = *src++;
  80168f:	8b 45 08             	mov    0x8(%ebp),%eax
  801692:	8d 50 01             	lea    0x1(%eax),%edx
  801695:	89 55 08             	mov    %edx,0x8(%ebp)
  801698:	8b 55 0c             	mov    0xc(%ebp),%edx
  80169b:	8d 4a 01             	lea    0x1(%edx),%ecx
  80169e:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  8016a1:	8a 12                	mov    (%edx),%dl
  8016a3:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  8016a5:	ff 4d 10             	decl   0x10(%ebp)
  8016a8:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8016ac:	74 09                	je     8016b7 <strlcpy+0x3c>
  8016ae:	8b 45 0c             	mov    0xc(%ebp),%eax
  8016b1:	8a 00                	mov    (%eax),%al
  8016b3:	84 c0                	test   %al,%al
  8016b5:	75 d8                	jne    80168f <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  8016b7:	8b 45 08             	mov    0x8(%ebp),%eax
  8016ba:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  8016bd:	8b 55 08             	mov    0x8(%ebp),%edx
  8016c0:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8016c3:	29 c2                	sub    %eax,%edx
  8016c5:	89 d0                	mov    %edx,%eax
}
  8016c7:	c9                   	leave  
  8016c8:	c3                   	ret    

008016c9 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  8016c9:	55                   	push   %ebp
  8016ca:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  8016cc:	eb 06                	jmp    8016d4 <strcmp+0xb>
		p++, q++;
  8016ce:	ff 45 08             	incl   0x8(%ebp)
  8016d1:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  8016d4:	8b 45 08             	mov    0x8(%ebp),%eax
  8016d7:	8a 00                	mov    (%eax),%al
  8016d9:	84 c0                	test   %al,%al
  8016db:	74 0e                	je     8016eb <strcmp+0x22>
  8016dd:	8b 45 08             	mov    0x8(%ebp),%eax
  8016e0:	8a 10                	mov    (%eax),%dl
  8016e2:	8b 45 0c             	mov    0xc(%ebp),%eax
  8016e5:	8a 00                	mov    (%eax),%al
  8016e7:	38 c2                	cmp    %al,%dl
  8016e9:	74 e3                	je     8016ce <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  8016eb:	8b 45 08             	mov    0x8(%ebp),%eax
  8016ee:	8a 00                	mov    (%eax),%al
  8016f0:	0f b6 d0             	movzbl %al,%edx
  8016f3:	8b 45 0c             	mov    0xc(%ebp),%eax
  8016f6:	8a 00                	mov    (%eax),%al
  8016f8:	0f b6 c0             	movzbl %al,%eax
  8016fb:	29 c2                	sub    %eax,%edx
  8016fd:	89 d0                	mov    %edx,%eax
}
  8016ff:	5d                   	pop    %ebp
  801700:	c3                   	ret    

00801701 <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  801701:	55                   	push   %ebp
  801702:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  801704:	eb 09                	jmp    80170f <strncmp+0xe>
		n--, p++, q++;
  801706:	ff 4d 10             	decl   0x10(%ebp)
  801709:	ff 45 08             	incl   0x8(%ebp)
  80170c:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  80170f:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801713:	74 17                	je     80172c <strncmp+0x2b>
  801715:	8b 45 08             	mov    0x8(%ebp),%eax
  801718:	8a 00                	mov    (%eax),%al
  80171a:	84 c0                	test   %al,%al
  80171c:	74 0e                	je     80172c <strncmp+0x2b>
  80171e:	8b 45 08             	mov    0x8(%ebp),%eax
  801721:	8a 10                	mov    (%eax),%dl
  801723:	8b 45 0c             	mov    0xc(%ebp),%eax
  801726:	8a 00                	mov    (%eax),%al
  801728:	38 c2                	cmp    %al,%dl
  80172a:	74 da                	je     801706 <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  80172c:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801730:	75 07                	jne    801739 <strncmp+0x38>
		return 0;
  801732:	b8 00 00 00 00       	mov    $0x0,%eax
  801737:	eb 14                	jmp    80174d <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  801739:	8b 45 08             	mov    0x8(%ebp),%eax
  80173c:	8a 00                	mov    (%eax),%al
  80173e:	0f b6 d0             	movzbl %al,%edx
  801741:	8b 45 0c             	mov    0xc(%ebp),%eax
  801744:	8a 00                	mov    (%eax),%al
  801746:	0f b6 c0             	movzbl %al,%eax
  801749:	29 c2                	sub    %eax,%edx
  80174b:	89 d0                	mov    %edx,%eax
}
  80174d:	5d                   	pop    %ebp
  80174e:	c3                   	ret    

0080174f <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  80174f:	55                   	push   %ebp
  801750:	89 e5                	mov    %esp,%ebp
  801752:	83 ec 04             	sub    $0x4,%esp
  801755:	8b 45 0c             	mov    0xc(%ebp),%eax
  801758:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  80175b:	eb 12                	jmp    80176f <strchr+0x20>
		if (*s == c)
  80175d:	8b 45 08             	mov    0x8(%ebp),%eax
  801760:	8a 00                	mov    (%eax),%al
  801762:	3a 45 fc             	cmp    -0x4(%ebp),%al
  801765:	75 05                	jne    80176c <strchr+0x1d>
			return (char *) s;
  801767:	8b 45 08             	mov    0x8(%ebp),%eax
  80176a:	eb 11                	jmp    80177d <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  80176c:	ff 45 08             	incl   0x8(%ebp)
  80176f:	8b 45 08             	mov    0x8(%ebp),%eax
  801772:	8a 00                	mov    (%eax),%al
  801774:	84 c0                	test   %al,%al
  801776:	75 e5                	jne    80175d <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  801778:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80177d:	c9                   	leave  
  80177e:	c3                   	ret    

0080177f <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  80177f:	55                   	push   %ebp
  801780:	89 e5                	mov    %esp,%ebp
  801782:	83 ec 04             	sub    $0x4,%esp
  801785:	8b 45 0c             	mov    0xc(%ebp),%eax
  801788:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  80178b:	eb 0d                	jmp    80179a <strfind+0x1b>
		if (*s == c)
  80178d:	8b 45 08             	mov    0x8(%ebp),%eax
  801790:	8a 00                	mov    (%eax),%al
  801792:	3a 45 fc             	cmp    -0x4(%ebp),%al
  801795:	74 0e                	je     8017a5 <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  801797:	ff 45 08             	incl   0x8(%ebp)
  80179a:	8b 45 08             	mov    0x8(%ebp),%eax
  80179d:	8a 00                	mov    (%eax),%al
  80179f:	84 c0                	test   %al,%al
  8017a1:	75 ea                	jne    80178d <strfind+0xe>
  8017a3:	eb 01                	jmp    8017a6 <strfind+0x27>
		if (*s == c)
			break;
  8017a5:	90                   	nop
	return (char *) s;
  8017a6:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8017a9:	c9                   	leave  
  8017aa:	c3                   	ret    

008017ab <memset>:


void *
memset(void *v, int c, uint32 n)
{
  8017ab:	55                   	push   %ebp
  8017ac:	89 e5                	mov    %esp,%ebp
  8017ae:	83 ec 10             	sub    $0x10,%esp
	char *p;
	int m;

	p = v;
  8017b1:	8b 45 08             	mov    0x8(%ebp),%eax
  8017b4:	89 45 fc             	mov    %eax,-0x4(%ebp)
	m = n;
  8017b7:	8b 45 10             	mov    0x10(%ebp),%eax
  8017ba:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (--m >= 0)
  8017bd:	eb 0e                	jmp    8017cd <memset+0x22>
		*p++ = c;
  8017bf:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8017c2:	8d 50 01             	lea    0x1(%eax),%edx
  8017c5:	89 55 fc             	mov    %edx,-0x4(%ebp)
  8017c8:	8b 55 0c             	mov    0xc(%ebp),%edx
  8017cb:	88 10                	mov    %dl,(%eax)
	char *p;
	int m;

	p = v;
	m = n;
	while (--m >= 0)
  8017cd:	ff 4d f8             	decl   -0x8(%ebp)
  8017d0:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
  8017d4:	79 e9                	jns    8017bf <memset+0x14>
		*p++ = c;

	return v;
  8017d6:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8017d9:	c9                   	leave  
  8017da:	c3                   	ret    

008017db <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  8017db:	55                   	push   %ebp
  8017dc:	89 e5                	mov    %esp,%ebp
  8017de:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  8017e1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8017e4:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  8017e7:	8b 45 08             	mov    0x8(%ebp),%eax
  8017ea:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (n-- > 0)
  8017ed:	eb 16                	jmp    801805 <memcpy+0x2a>
		*d++ = *s++;
  8017ef:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8017f2:	8d 50 01             	lea    0x1(%eax),%edx
  8017f5:	89 55 f8             	mov    %edx,-0x8(%ebp)
  8017f8:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8017fb:	8d 4a 01             	lea    0x1(%edx),%ecx
  8017fe:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  801801:	8a 12                	mov    (%edx),%dl
  801803:	88 10                	mov    %dl,(%eax)
	const char *s;
	char *d;

	s = src;
	d = dst;
	while (n-- > 0)
  801805:	8b 45 10             	mov    0x10(%ebp),%eax
  801808:	8d 50 ff             	lea    -0x1(%eax),%edx
  80180b:	89 55 10             	mov    %edx,0x10(%ebp)
  80180e:	85 c0                	test   %eax,%eax
  801810:	75 dd                	jne    8017ef <memcpy+0x14>
		*d++ = *s++;

	return dst;
  801812:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801815:	c9                   	leave  
  801816:	c3                   	ret    

00801817 <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  801817:	55                   	push   %ebp
  801818:	89 e5                	mov    %esp,%ebp
  80181a:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  80181d:	8b 45 0c             	mov    0xc(%ebp),%eax
  801820:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  801823:	8b 45 08             	mov    0x8(%ebp),%eax
  801826:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  801829:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80182c:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  80182f:	73 50                	jae    801881 <memmove+0x6a>
  801831:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801834:	8b 45 10             	mov    0x10(%ebp),%eax
  801837:	01 d0                	add    %edx,%eax
  801839:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  80183c:	76 43                	jbe    801881 <memmove+0x6a>
		s += n;
  80183e:	8b 45 10             	mov    0x10(%ebp),%eax
  801841:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  801844:	8b 45 10             	mov    0x10(%ebp),%eax
  801847:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  80184a:	eb 10                	jmp    80185c <memmove+0x45>
			*--d = *--s;
  80184c:	ff 4d f8             	decl   -0x8(%ebp)
  80184f:	ff 4d fc             	decl   -0x4(%ebp)
  801852:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801855:	8a 10                	mov    (%eax),%dl
  801857:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80185a:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  80185c:	8b 45 10             	mov    0x10(%ebp),%eax
  80185f:	8d 50 ff             	lea    -0x1(%eax),%edx
  801862:	89 55 10             	mov    %edx,0x10(%ebp)
  801865:	85 c0                	test   %eax,%eax
  801867:	75 e3                	jne    80184c <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  801869:	eb 23                	jmp    80188e <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  80186b:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80186e:	8d 50 01             	lea    0x1(%eax),%edx
  801871:	89 55 f8             	mov    %edx,-0x8(%ebp)
  801874:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801877:	8d 4a 01             	lea    0x1(%edx),%ecx
  80187a:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  80187d:	8a 12                	mov    (%edx),%dl
  80187f:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  801881:	8b 45 10             	mov    0x10(%ebp),%eax
  801884:	8d 50 ff             	lea    -0x1(%eax),%edx
  801887:	89 55 10             	mov    %edx,0x10(%ebp)
  80188a:	85 c0                	test   %eax,%eax
  80188c:	75 dd                	jne    80186b <memmove+0x54>
			*d++ = *s++;

	return dst;
  80188e:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801891:	c9                   	leave  
  801892:	c3                   	ret    

00801893 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  801893:	55                   	push   %ebp
  801894:	89 e5                	mov    %esp,%ebp
  801896:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  801899:	8b 45 08             	mov    0x8(%ebp),%eax
  80189c:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  80189f:	8b 45 0c             	mov    0xc(%ebp),%eax
  8018a2:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  8018a5:	eb 2a                	jmp    8018d1 <memcmp+0x3e>
		if (*s1 != *s2)
  8018a7:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8018aa:	8a 10                	mov    (%eax),%dl
  8018ac:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8018af:	8a 00                	mov    (%eax),%al
  8018b1:	38 c2                	cmp    %al,%dl
  8018b3:	74 16                	je     8018cb <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  8018b5:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8018b8:	8a 00                	mov    (%eax),%al
  8018ba:	0f b6 d0             	movzbl %al,%edx
  8018bd:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8018c0:	8a 00                	mov    (%eax),%al
  8018c2:	0f b6 c0             	movzbl %al,%eax
  8018c5:	29 c2                	sub    %eax,%edx
  8018c7:	89 d0                	mov    %edx,%eax
  8018c9:	eb 18                	jmp    8018e3 <memcmp+0x50>
		s1++, s2++;
  8018cb:	ff 45 fc             	incl   -0x4(%ebp)
  8018ce:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  8018d1:	8b 45 10             	mov    0x10(%ebp),%eax
  8018d4:	8d 50 ff             	lea    -0x1(%eax),%edx
  8018d7:	89 55 10             	mov    %edx,0x10(%ebp)
  8018da:	85 c0                	test   %eax,%eax
  8018dc:	75 c9                	jne    8018a7 <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  8018de:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8018e3:	c9                   	leave  
  8018e4:	c3                   	ret    

008018e5 <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  8018e5:	55                   	push   %ebp
  8018e6:	89 e5                	mov    %esp,%ebp
  8018e8:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  8018eb:	8b 55 08             	mov    0x8(%ebp),%edx
  8018ee:	8b 45 10             	mov    0x10(%ebp),%eax
  8018f1:	01 d0                	add    %edx,%eax
  8018f3:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  8018f6:	eb 15                	jmp    80190d <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  8018f8:	8b 45 08             	mov    0x8(%ebp),%eax
  8018fb:	8a 00                	mov    (%eax),%al
  8018fd:	0f b6 d0             	movzbl %al,%edx
  801900:	8b 45 0c             	mov    0xc(%ebp),%eax
  801903:	0f b6 c0             	movzbl %al,%eax
  801906:	39 c2                	cmp    %eax,%edx
  801908:	74 0d                	je     801917 <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  80190a:	ff 45 08             	incl   0x8(%ebp)
  80190d:	8b 45 08             	mov    0x8(%ebp),%eax
  801910:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  801913:	72 e3                	jb     8018f8 <memfind+0x13>
  801915:	eb 01                	jmp    801918 <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  801917:	90                   	nop
	return (void *) s;
  801918:	8b 45 08             	mov    0x8(%ebp),%eax
}
  80191b:	c9                   	leave  
  80191c:	c3                   	ret    

0080191d <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  80191d:	55                   	push   %ebp
  80191e:	89 e5                	mov    %esp,%ebp
  801920:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  801923:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  80192a:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801931:	eb 03                	jmp    801936 <strtol+0x19>
		s++;
  801933:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801936:	8b 45 08             	mov    0x8(%ebp),%eax
  801939:	8a 00                	mov    (%eax),%al
  80193b:	3c 20                	cmp    $0x20,%al
  80193d:	74 f4                	je     801933 <strtol+0x16>
  80193f:	8b 45 08             	mov    0x8(%ebp),%eax
  801942:	8a 00                	mov    (%eax),%al
  801944:	3c 09                	cmp    $0x9,%al
  801946:	74 eb                	je     801933 <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  801948:	8b 45 08             	mov    0x8(%ebp),%eax
  80194b:	8a 00                	mov    (%eax),%al
  80194d:	3c 2b                	cmp    $0x2b,%al
  80194f:	75 05                	jne    801956 <strtol+0x39>
		s++;
  801951:	ff 45 08             	incl   0x8(%ebp)
  801954:	eb 13                	jmp    801969 <strtol+0x4c>
	else if (*s == '-')
  801956:	8b 45 08             	mov    0x8(%ebp),%eax
  801959:	8a 00                	mov    (%eax),%al
  80195b:	3c 2d                	cmp    $0x2d,%al
  80195d:	75 0a                	jne    801969 <strtol+0x4c>
		s++, neg = 1;
  80195f:	ff 45 08             	incl   0x8(%ebp)
  801962:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  801969:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80196d:	74 06                	je     801975 <strtol+0x58>
  80196f:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  801973:	75 20                	jne    801995 <strtol+0x78>
  801975:	8b 45 08             	mov    0x8(%ebp),%eax
  801978:	8a 00                	mov    (%eax),%al
  80197a:	3c 30                	cmp    $0x30,%al
  80197c:	75 17                	jne    801995 <strtol+0x78>
  80197e:	8b 45 08             	mov    0x8(%ebp),%eax
  801981:	40                   	inc    %eax
  801982:	8a 00                	mov    (%eax),%al
  801984:	3c 78                	cmp    $0x78,%al
  801986:	75 0d                	jne    801995 <strtol+0x78>
		s += 2, base = 16;
  801988:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  80198c:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  801993:	eb 28                	jmp    8019bd <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  801995:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801999:	75 15                	jne    8019b0 <strtol+0x93>
  80199b:	8b 45 08             	mov    0x8(%ebp),%eax
  80199e:	8a 00                	mov    (%eax),%al
  8019a0:	3c 30                	cmp    $0x30,%al
  8019a2:	75 0c                	jne    8019b0 <strtol+0x93>
		s++, base = 8;
  8019a4:	ff 45 08             	incl   0x8(%ebp)
  8019a7:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  8019ae:	eb 0d                	jmp    8019bd <strtol+0xa0>
	else if (base == 0)
  8019b0:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8019b4:	75 07                	jne    8019bd <strtol+0xa0>
		base = 10;
  8019b6:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  8019bd:	8b 45 08             	mov    0x8(%ebp),%eax
  8019c0:	8a 00                	mov    (%eax),%al
  8019c2:	3c 2f                	cmp    $0x2f,%al
  8019c4:	7e 19                	jle    8019df <strtol+0xc2>
  8019c6:	8b 45 08             	mov    0x8(%ebp),%eax
  8019c9:	8a 00                	mov    (%eax),%al
  8019cb:	3c 39                	cmp    $0x39,%al
  8019cd:	7f 10                	jg     8019df <strtol+0xc2>
			dig = *s - '0';
  8019cf:	8b 45 08             	mov    0x8(%ebp),%eax
  8019d2:	8a 00                	mov    (%eax),%al
  8019d4:	0f be c0             	movsbl %al,%eax
  8019d7:	83 e8 30             	sub    $0x30,%eax
  8019da:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8019dd:	eb 42                	jmp    801a21 <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  8019df:	8b 45 08             	mov    0x8(%ebp),%eax
  8019e2:	8a 00                	mov    (%eax),%al
  8019e4:	3c 60                	cmp    $0x60,%al
  8019e6:	7e 19                	jle    801a01 <strtol+0xe4>
  8019e8:	8b 45 08             	mov    0x8(%ebp),%eax
  8019eb:	8a 00                	mov    (%eax),%al
  8019ed:	3c 7a                	cmp    $0x7a,%al
  8019ef:	7f 10                	jg     801a01 <strtol+0xe4>
			dig = *s - 'a' + 10;
  8019f1:	8b 45 08             	mov    0x8(%ebp),%eax
  8019f4:	8a 00                	mov    (%eax),%al
  8019f6:	0f be c0             	movsbl %al,%eax
  8019f9:	83 e8 57             	sub    $0x57,%eax
  8019fc:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8019ff:	eb 20                	jmp    801a21 <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  801a01:	8b 45 08             	mov    0x8(%ebp),%eax
  801a04:	8a 00                	mov    (%eax),%al
  801a06:	3c 40                	cmp    $0x40,%al
  801a08:	7e 39                	jle    801a43 <strtol+0x126>
  801a0a:	8b 45 08             	mov    0x8(%ebp),%eax
  801a0d:	8a 00                	mov    (%eax),%al
  801a0f:	3c 5a                	cmp    $0x5a,%al
  801a11:	7f 30                	jg     801a43 <strtol+0x126>
			dig = *s - 'A' + 10;
  801a13:	8b 45 08             	mov    0x8(%ebp),%eax
  801a16:	8a 00                	mov    (%eax),%al
  801a18:	0f be c0             	movsbl %al,%eax
  801a1b:	83 e8 37             	sub    $0x37,%eax
  801a1e:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  801a21:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801a24:	3b 45 10             	cmp    0x10(%ebp),%eax
  801a27:	7d 19                	jge    801a42 <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  801a29:	ff 45 08             	incl   0x8(%ebp)
  801a2c:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801a2f:	0f af 45 10          	imul   0x10(%ebp),%eax
  801a33:	89 c2                	mov    %eax,%edx
  801a35:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801a38:	01 d0                	add    %edx,%eax
  801a3a:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  801a3d:	e9 7b ff ff ff       	jmp    8019bd <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  801a42:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  801a43:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801a47:	74 08                	je     801a51 <strtol+0x134>
		*endptr = (char *) s;
  801a49:	8b 45 0c             	mov    0xc(%ebp),%eax
  801a4c:	8b 55 08             	mov    0x8(%ebp),%edx
  801a4f:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  801a51:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801a55:	74 07                	je     801a5e <strtol+0x141>
  801a57:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801a5a:	f7 d8                	neg    %eax
  801a5c:	eb 03                	jmp    801a61 <strtol+0x144>
  801a5e:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  801a61:	c9                   	leave  
  801a62:	c3                   	ret    

00801a63 <ltostr>:

void
ltostr(long value, char *str)
{
  801a63:	55                   	push   %ebp
  801a64:	89 e5                	mov    %esp,%ebp
  801a66:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  801a69:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  801a70:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  801a77:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801a7b:	79 13                	jns    801a90 <ltostr+0x2d>
	{
		neg = 1;
  801a7d:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  801a84:	8b 45 0c             	mov    0xc(%ebp),%eax
  801a87:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  801a8a:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  801a8d:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  801a90:	8b 45 08             	mov    0x8(%ebp),%eax
  801a93:	b9 0a 00 00 00       	mov    $0xa,%ecx
  801a98:	99                   	cltd   
  801a99:	f7 f9                	idiv   %ecx
  801a9b:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  801a9e:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801aa1:	8d 50 01             	lea    0x1(%eax),%edx
  801aa4:	89 55 f8             	mov    %edx,-0x8(%ebp)
  801aa7:	89 c2                	mov    %eax,%edx
  801aa9:	8b 45 0c             	mov    0xc(%ebp),%eax
  801aac:	01 d0                	add    %edx,%eax
  801aae:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801ab1:	83 c2 30             	add    $0x30,%edx
  801ab4:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  801ab6:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801ab9:	b8 67 66 66 66       	mov    $0x66666667,%eax
  801abe:	f7 e9                	imul   %ecx
  801ac0:	c1 fa 02             	sar    $0x2,%edx
  801ac3:	89 c8                	mov    %ecx,%eax
  801ac5:	c1 f8 1f             	sar    $0x1f,%eax
  801ac8:	29 c2                	sub    %eax,%edx
  801aca:	89 d0                	mov    %edx,%eax
  801acc:	89 45 08             	mov    %eax,0x8(%ebp)
	} while (value % 10 != 0);
  801acf:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801ad2:	b8 67 66 66 66       	mov    $0x66666667,%eax
  801ad7:	f7 e9                	imul   %ecx
  801ad9:	c1 fa 02             	sar    $0x2,%edx
  801adc:	89 c8                	mov    %ecx,%eax
  801ade:	c1 f8 1f             	sar    $0x1f,%eax
  801ae1:	29 c2                	sub    %eax,%edx
  801ae3:	89 d0                	mov    %edx,%eax
  801ae5:	c1 e0 02             	shl    $0x2,%eax
  801ae8:	01 d0                	add    %edx,%eax
  801aea:	01 c0                	add    %eax,%eax
  801aec:	29 c1                	sub    %eax,%ecx
  801aee:	89 ca                	mov    %ecx,%edx
  801af0:	85 d2                	test   %edx,%edx
  801af2:	75 9c                	jne    801a90 <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  801af4:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  801afb:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801afe:	48                   	dec    %eax
  801aff:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  801b02:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801b06:	74 3d                	je     801b45 <ltostr+0xe2>
		start = 1 ;
  801b08:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  801b0f:	eb 34                	jmp    801b45 <ltostr+0xe2>
	{
		char tmp = str[start] ;
  801b11:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801b14:	8b 45 0c             	mov    0xc(%ebp),%eax
  801b17:	01 d0                	add    %edx,%eax
  801b19:	8a 00                	mov    (%eax),%al
  801b1b:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  801b1e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801b21:	8b 45 0c             	mov    0xc(%ebp),%eax
  801b24:	01 c2                	add    %eax,%edx
  801b26:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  801b29:	8b 45 0c             	mov    0xc(%ebp),%eax
  801b2c:	01 c8                	add    %ecx,%eax
  801b2e:	8a 00                	mov    (%eax),%al
  801b30:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  801b32:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801b35:	8b 45 0c             	mov    0xc(%ebp),%eax
  801b38:	01 c2                	add    %eax,%edx
  801b3a:	8a 45 eb             	mov    -0x15(%ebp),%al
  801b3d:	88 02                	mov    %al,(%edx)
		start++ ;
  801b3f:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  801b42:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  801b45:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801b48:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801b4b:	7c c4                	jl     801b11 <ltostr+0xae>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  801b4d:	8b 55 f8             	mov    -0x8(%ebp),%edx
  801b50:	8b 45 0c             	mov    0xc(%ebp),%eax
  801b53:	01 d0                	add    %edx,%eax
  801b55:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  801b58:	90                   	nop
  801b59:	c9                   	leave  
  801b5a:	c3                   	ret    

00801b5b <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  801b5b:	55                   	push   %ebp
  801b5c:	89 e5                	mov    %esp,%ebp
  801b5e:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  801b61:	ff 75 08             	pushl  0x8(%ebp)
  801b64:	e8 54 fa ff ff       	call   8015bd <strlen>
  801b69:	83 c4 04             	add    $0x4,%esp
  801b6c:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  801b6f:	ff 75 0c             	pushl  0xc(%ebp)
  801b72:	e8 46 fa ff ff       	call   8015bd <strlen>
  801b77:	83 c4 04             	add    $0x4,%esp
  801b7a:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  801b7d:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  801b84:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801b8b:	eb 17                	jmp    801ba4 <strcconcat+0x49>
		final[s] = str1[s] ;
  801b8d:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801b90:	8b 45 10             	mov    0x10(%ebp),%eax
  801b93:	01 c2                	add    %eax,%edx
  801b95:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  801b98:	8b 45 08             	mov    0x8(%ebp),%eax
  801b9b:	01 c8                	add    %ecx,%eax
  801b9d:	8a 00                	mov    (%eax),%al
  801b9f:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  801ba1:	ff 45 fc             	incl   -0x4(%ebp)
  801ba4:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801ba7:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  801baa:	7c e1                	jl     801b8d <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  801bac:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  801bb3:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  801bba:	eb 1f                	jmp    801bdb <strcconcat+0x80>
		final[s++] = str2[i] ;
  801bbc:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801bbf:	8d 50 01             	lea    0x1(%eax),%edx
  801bc2:	89 55 fc             	mov    %edx,-0x4(%ebp)
  801bc5:	89 c2                	mov    %eax,%edx
  801bc7:	8b 45 10             	mov    0x10(%ebp),%eax
  801bca:	01 c2                	add    %eax,%edx
  801bcc:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  801bcf:	8b 45 0c             	mov    0xc(%ebp),%eax
  801bd2:	01 c8                	add    %ecx,%eax
  801bd4:	8a 00                	mov    (%eax),%al
  801bd6:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  801bd8:	ff 45 f8             	incl   -0x8(%ebp)
  801bdb:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801bde:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801be1:	7c d9                	jl     801bbc <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  801be3:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801be6:	8b 45 10             	mov    0x10(%ebp),%eax
  801be9:	01 d0                	add    %edx,%eax
  801beb:	c6 00 00             	movb   $0x0,(%eax)
}
  801bee:	90                   	nop
  801bef:	c9                   	leave  
  801bf0:	c3                   	ret    

00801bf1 <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  801bf1:	55                   	push   %ebp
  801bf2:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  801bf4:	8b 45 14             	mov    0x14(%ebp),%eax
  801bf7:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  801bfd:	8b 45 14             	mov    0x14(%ebp),%eax
  801c00:	8b 00                	mov    (%eax),%eax
  801c02:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801c09:	8b 45 10             	mov    0x10(%ebp),%eax
  801c0c:	01 d0                	add    %edx,%eax
  801c0e:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801c14:	eb 0c                	jmp    801c22 <strsplit+0x31>
			*string++ = 0;
  801c16:	8b 45 08             	mov    0x8(%ebp),%eax
  801c19:	8d 50 01             	lea    0x1(%eax),%edx
  801c1c:	89 55 08             	mov    %edx,0x8(%ebp)
  801c1f:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801c22:	8b 45 08             	mov    0x8(%ebp),%eax
  801c25:	8a 00                	mov    (%eax),%al
  801c27:	84 c0                	test   %al,%al
  801c29:	74 18                	je     801c43 <strsplit+0x52>
  801c2b:	8b 45 08             	mov    0x8(%ebp),%eax
  801c2e:	8a 00                	mov    (%eax),%al
  801c30:	0f be c0             	movsbl %al,%eax
  801c33:	50                   	push   %eax
  801c34:	ff 75 0c             	pushl  0xc(%ebp)
  801c37:	e8 13 fb ff ff       	call   80174f <strchr>
  801c3c:	83 c4 08             	add    $0x8,%esp
  801c3f:	85 c0                	test   %eax,%eax
  801c41:	75 d3                	jne    801c16 <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  801c43:	8b 45 08             	mov    0x8(%ebp),%eax
  801c46:	8a 00                	mov    (%eax),%al
  801c48:	84 c0                	test   %al,%al
  801c4a:	74 5a                	je     801ca6 <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  801c4c:	8b 45 14             	mov    0x14(%ebp),%eax
  801c4f:	8b 00                	mov    (%eax),%eax
  801c51:	83 f8 0f             	cmp    $0xf,%eax
  801c54:	75 07                	jne    801c5d <strsplit+0x6c>
		{
			return 0;
  801c56:	b8 00 00 00 00       	mov    $0x0,%eax
  801c5b:	eb 66                	jmp    801cc3 <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  801c5d:	8b 45 14             	mov    0x14(%ebp),%eax
  801c60:	8b 00                	mov    (%eax),%eax
  801c62:	8d 48 01             	lea    0x1(%eax),%ecx
  801c65:	8b 55 14             	mov    0x14(%ebp),%edx
  801c68:	89 0a                	mov    %ecx,(%edx)
  801c6a:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801c71:	8b 45 10             	mov    0x10(%ebp),%eax
  801c74:	01 c2                	add    %eax,%edx
  801c76:	8b 45 08             	mov    0x8(%ebp),%eax
  801c79:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  801c7b:	eb 03                	jmp    801c80 <strsplit+0x8f>
			string++;
  801c7d:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  801c80:	8b 45 08             	mov    0x8(%ebp),%eax
  801c83:	8a 00                	mov    (%eax),%al
  801c85:	84 c0                	test   %al,%al
  801c87:	74 8b                	je     801c14 <strsplit+0x23>
  801c89:	8b 45 08             	mov    0x8(%ebp),%eax
  801c8c:	8a 00                	mov    (%eax),%al
  801c8e:	0f be c0             	movsbl %al,%eax
  801c91:	50                   	push   %eax
  801c92:	ff 75 0c             	pushl  0xc(%ebp)
  801c95:	e8 b5 fa ff ff       	call   80174f <strchr>
  801c9a:	83 c4 08             	add    $0x8,%esp
  801c9d:	85 c0                	test   %eax,%eax
  801c9f:	74 dc                	je     801c7d <strsplit+0x8c>
			string++;
	}
  801ca1:	e9 6e ff ff ff       	jmp    801c14 <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  801ca6:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  801ca7:	8b 45 14             	mov    0x14(%ebp),%eax
  801caa:	8b 00                	mov    (%eax),%eax
  801cac:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801cb3:	8b 45 10             	mov    0x10(%ebp),%eax
  801cb6:	01 d0                	add    %edx,%eax
  801cb8:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  801cbe:	b8 01 00 00 00       	mov    $0x1,%eax
}
  801cc3:	c9                   	leave  
  801cc4:	c3                   	ret    

00801cc5 <InitializeUHeap>:
//============================== GIVEN FUNCTIONS ===================================//
//==================================================================================//

int FirstTimeFlag = 1;
void InitializeUHeap()
{
  801cc5:	55                   	push   %ebp
  801cc6:	89 e5                	mov    %esp,%ebp
  801cc8:	83 ec 08             	sub    $0x8,%esp
	if(FirstTimeFlag)
  801ccb:	a1 04 50 80 00       	mov    0x805004,%eax
  801cd0:	85 c0                	test   %eax,%eax
  801cd2:	74 1f                	je     801cf3 <InitializeUHeap+0x2e>
	{
		initialize_dyn_block_system();
  801cd4:	e8 1d 00 00 00       	call   801cf6 <initialize_dyn_block_system>
		cprintf("DYNAMIC BLOCK SYSTEM IS INITIALIZED\n");
  801cd9:	83 ec 0c             	sub    $0xc,%esp
  801cdc:	68 f0 44 80 00       	push   $0x8044f0
  801ce1:	e8 55 f2 ff ff       	call   800f3b <cprintf>
  801ce6:	83 c4 10             	add    $0x10,%esp
#if UHP_USE_BUDDY
		initialize_buddy();
		cprintf("BUDDY SYSTEM IS INITIALIZED\n");
#endif
		FirstTimeFlag = 0;
  801ce9:	c7 05 04 50 80 00 00 	movl   $0x0,0x805004
  801cf0:	00 00 00 
	}
}
  801cf3:	90                   	nop
  801cf4:	c9                   	leave  
  801cf5:	c3                   	ret    

00801cf6 <initialize_dyn_block_system>:

//=================================
// [1] INITIALIZE DYNAMIC ALLOCATOR:
//=================================
void initialize_dyn_block_system()
{
  801cf6:	55                   	push   %ebp
  801cf7:	89 e5                	mov    %esp,%ebp
  801cf9:	83 ec 28             	sub    $0x28,%esp
	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] initialize_dyn_block_system
	// your code is here, remove the panic and write your code
	//panic("initialize_dyn_block_system() is not implemented yet...!!");

	LIST_INIT(&AllocMemBlocksList);
  801cfc:	c7 05 40 50 80 00 00 	movl   $0x0,0x805040
  801d03:	00 00 00 
  801d06:	c7 05 44 50 80 00 00 	movl   $0x0,0x805044
  801d0d:	00 00 00 
  801d10:	c7 05 4c 50 80 00 00 	movl   $0x0,0x80504c
  801d17:	00 00 00 
	LIST_INIT(&FreeMemBlocksList);
  801d1a:	c7 05 38 51 80 00 00 	movl   $0x0,0x805138
  801d21:	00 00 00 
  801d24:	c7 05 3c 51 80 00 00 	movl   $0x0,0x80513c
  801d2b:	00 00 00 
  801d2e:	c7 05 44 51 80 00 00 	movl   $0x0,0x805144
  801d35:	00 00 00 
	MAX_MEM_BLOCK_CNT = NUM_OF_UHEAP_PAGES;
  801d38:	c7 05 20 51 80 00 00 	movl   $0x20000,0x805120
  801d3f:	00 02 00 
	MemBlockNodes = (void*)USER_DYN_BLKS_ARRAY;
  801d42:	c7 45 f4 00 00 e0 7f 	movl   $0x7fe00000,-0xc(%ebp)
  801d49:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801d4c:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801d51:	2d 00 10 00 00       	sub    $0x1000,%eax
  801d56:	a3 50 50 80 00       	mov    %eax,0x805050
	int size_of_block = sizeof(struct MemBlock);
  801d5b:	c7 45 f0 10 00 00 00 	movl   $0x10,-0x10(%ebp)
	int size_all_struct = size_of_block*MAX_MEM_BLOCK_CNT;
  801d62:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801d65:	a1 20 51 80 00       	mov    0x805120,%eax
  801d6a:	0f af c2             	imul   %edx,%eax
  801d6d:	89 45 ec             	mov    %eax,-0x14(%ebp)
	size_all_struct = ROUNDUP(size_all_struct, PAGE_SIZE);
  801d70:	c7 45 e8 00 10 00 00 	movl   $0x1000,-0x18(%ebp)
  801d77:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801d7a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801d7d:	01 d0                	add    %edx,%eax
  801d7f:	48                   	dec    %eax
  801d80:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  801d83:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801d86:	ba 00 00 00 00       	mov    $0x0,%edx
  801d8b:	f7 75 e8             	divl   -0x18(%ebp)
  801d8e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801d91:	29 d0                	sub    %edx,%eax
  801d93:	89 45 ec             	mov    %eax,-0x14(%ebp)
	sys_allocate_chunk(USER_DYN_BLKS_ARRAY, size_all_struct,PERM_USER| PERM_WRITEABLE);
  801d96:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801d99:	c7 45 e0 00 00 e0 7f 	movl   $0x7fe00000,-0x20(%ebp)
  801da0:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801da3:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
  801da9:	81 ea 00 10 00 00    	sub    $0x1000,%edx
  801daf:	83 ec 04             	sub    $0x4,%esp
  801db2:	6a 06                	push   $0x6
  801db4:	50                   	push   %eax
  801db5:	52                   	push   %edx
  801db6:	e8 a1 05 00 00       	call   80235c <sys_allocate_chunk>
  801dbb:	83 c4 10             	add    $0x10,%esp
	initialize_MemBlocksList(MAX_MEM_BLOCK_CNT);
  801dbe:	a1 20 51 80 00       	mov    0x805120,%eax
  801dc3:	83 ec 0c             	sub    $0xc,%esp
  801dc6:	50                   	push   %eax
  801dc7:	e8 16 0c 00 00       	call   8029e2 <initialize_MemBlocksList>
  801dcc:	83 c4 10             	add    $0x10,%esp
	struct MemBlock* ourBlock =LIST_LAST(&AvailableMemBlocksList);
  801dcf:	a1 4c 51 80 00       	mov    0x80514c,%eax
  801dd4:	89 45 dc             	mov    %eax,-0x24(%ebp)
	LIST_REMOVE(&AvailableMemBlocksList,ourBlock);
  801dd7:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  801ddb:	75 14                	jne    801df1 <initialize_dyn_block_system+0xfb>
  801ddd:	83 ec 04             	sub    $0x4,%esp
  801de0:	68 15 45 80 00       	push   $0x804515
  801de5:	6a 2d                	push   $0x2d
  801de7:	68 33 45 80 00       	push   $0x804533
  801dec:	e8 96 ee ff ff       	call   800c87 <_panic>
  801df1:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801df4:	8b 00                	mov    (%eax),%eax
  801df6:	85 c0                	test   %eax,%eax
  801df8:	74 10                	je     801e0a <initialize_dyn_block_system+0x114>
  801dfa:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801dfd:	8b 00                	mov    (%eax),%eax
  801dff:	8b 55 dc             	mov    -0x24(%ebp),%edx
  801e02:	8b 52 04             	mov    0x4(%edx),%edx
  801e05:	89 50 04             	mov    %edx,0x4(%eax)
  801e08:	eb 0b                	jmp    801e15 <initialize_dyn_block_system+0x11f>
  801e0a:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801e0d:	8b 40 04             	mov    0x4(%eax),%eax
  801e10:	a3 4c 51 80 00       	mov    %eax,0x80514c
  801e15:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801e18:	8b 40 04             	mov    0x4(%eax),%eax
  801e1b:	85 c0                	test   %eax,%eax
  801e1d:	74 0f                	je     801e2e <initialize_dyn_block_system+0x138>
  801e1f:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801e22:	8b 40 04             	mov    0x4(%eax),%eax
  801e25:	8b 55 dc             	mov    -0x24(%ebp),%edx
  801e28:	8b 12                	mov    (%edx),%edx
  801e2a:	89 10                	mov    %edx,(%eax)
  801e2c:	eb 0a                	jmp    801e38 <initialize_dyn_block_system+0x142>
  801e2e:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801e31:	8b 00                	mov    (%eax),%eax
  801e33:	a3 48 51 80 00       	mov    %eax,0x805148
  801e38:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801e3b:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  801e41:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801e44:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  801e4b:	a1 54 51 80 00       	mov    0x805154,%eax
  801e50:	48                   	dec    %eax
  801e51:	a3 54 51 80 00       	mov    %eax,0x805154
	ourBlock->size = USER_HEAP_MAX-USER_HEAP_START;
  801e56:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801e59:	c7 40 0c 00 00 00 20 	movl   $0x20000000,0xc(%eax)
	ourBlock->sva=USER_HEAP_START;
  801e60:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801e63:	c7 40 08 00 00 00 80 	movl   $0x80000000,0x8(%eax)
	LIST_INSERT_TAIL(&FreeMemBlocksList, ourBlock);
  801e6a:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  801e6e:	75 14                	jne    801e84 <initialize_dyn_block_system+0x18e>
  801e70:	83 ec 04             	sub    $0x4,%esp
  801e73:	68 40 45 80 00       	push   $0x804540
  801e78:	6a 30                	push   $0x30
  801e7a:	68 33 45 80 00       	push   $0x804533
  801e7f:	e8 03 ee ff ff       	call   800c87 <_panic>
  801e84:	8b 15 3c 51 80 00    	mov    0x80513c,%edx
  801e8a:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801e8d:	89 50 04             	mov    %edx,0x4(%eax)
  801e90:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801e93:	8b 40 04             	mov    0x4(%eax),%eax
  801e96:	85 c0                	test   %eax,%eax
  801e98:	74 0c                	je     801ea6 <initialize_dyn_block_system+0x1b0>
  801e9a:	a1 3c 51 80 00       	mov    0x80513c,%eax
  801e9f:	8b 55 dc             	mov    -0x24(%ebp),%edx
  801ea2:	89 10                	mov    %edx,(%eax)
  801ea4:	eb 08                	jmp    801eae <initialize_dyn_block_system+0x1b8>
  801ea6:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801ea9:	a3 38 51 80 00       	mov    %eax,0x805138
  801eae:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801eb1:	a3 3c 51 80 00       	mov    %eax,0x80513c
  801eb6:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801eb9:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  801ebf:	a1 44 51 80 00       	mov    0x805144,%eax
  801ec4:	40                   	inc    %eax
  801ec5:	a3 44 51 80 00       	mov    %eax,0x805144
	//[1] Initialize two lists (AllocMemBlocksList & FreeMemBlocksList) [Hint: use LIST_INIT()]
	//[2] Dynamically allocate the array of MemBlockNodes at VA USER_DYN_BLKS_ARRAY
	//	  (remember to set MAX_MEM_BLOCK_CNT with the chosen size of the array)
	//[3] Initialize AvailableMemBlocksList by filling it with the MemBlockNodes
	//[4] Insert a new MemBlock with the heap size into the FreeMemBlocksList
}
  801eca:	90                   	nop
  801ecb:	c9                   	leave  
  801ecc:	c3                   	ret    

00801ecd <malloc>:
//=================================
// [2] ALLOCATE SPACE IN USER HEAP:
//=================================

void* malloc(uint32 size)
{
  801ecd:	55                   	push   %ebp
  801ece:	89 e5                	mov    %esp,%ebp
  801ed0:	83 ec 18             	sub    $0x18,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801ed3:	e8 ed fd ff ff       	call   801cc5 <InitializeUHeap>
	if (size == 0) return NULL ;
  801ed8:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801edc:	75 07                	jne    801ee5 <malloc+0x18>
  801ede:	b8 00 00 00 00       	mov    $0x0,%eax
  801ee3:	eb 67                	jmp    801f4c <malloc+0x7f>

	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] malloc
	// your code is here, remove the panic and write your code
	//panic("malloc() is not implemented yet...!!");

	size = ROUNDUP(size, PAGE_SIZE);
  801ee5:	c7 45 f4 00 10 00 00 	movl   $0x1000,-0xc(%ebp)
  801eec:	8b 55 08             	mov    0x8(%ebp),%edx
  801eef:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801ef2:	01 d0                	add    %edx,%eax
  801ef4:	48                   	dec    %eax
  801ef5:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801ef8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801efb:	ba 00 00 00 00       	mov    $0x0,%edx
  801f00:	f7 75 f4             	divl   -0xc(%ebp)
  801f03:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801f06:	29 d0                	sub    %edx,%eax
  801f08:	89 45 08             	mov    %eax,0x8(%ebp)
	if(sys_isUHeapPlacementStrategyFIRSTFIT())
  801f0b:	e8 1a 08 00 00       	call   80272a <sys_isUHeapPlacementStrategyFIRSTFIT>
  801f10:	85 c0                	test   %eax,%eax
  801f12:	74 33                	je     801f47 <malloc+0x7a>
	{
		struct MemBlock * myBlock = alloc_block_FF(size);
  801f14:	83 ec 0c             	sub    $0xc,%esp
  801f17:	ff 75 08             	pushl  0x8(%ebp)
  801f1a:	e8 0c 0e 00 00       	call   802d2b <alloc_block_FF>
  801f1f:	83 c4 10             	add    $0x10,%esp
  801f22:	89 45 ec             	mov    %eax,-0x14(%ebp)
		if(myBlock != NULL)
  801f25:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  801f29:	74 1c                	je     801f47 <malloc+0x7a>
		{
			insert_sorted_allocList(myBlock);
  801f2b:	83 ec 0c             	sub    $0xc,%esp
  801f2e:	ff 75 ec             	pushl  -0x14(%ebp)
  801f31:	e8 07 0c 00 00       	call   802b3d <insert_sorted_allocList>
  801f36:	83 c4 10             	add    $0x10,%esp
			uint32 ptr = myBlock->sva;
  801f39:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801f3c:	8b 40 08             	mov    0x8(%eax),%eax
  801f3f:	89 45 e8             	mov    %eax,-0x18(%ebp)
			return (void *)ptr;
  801f42:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801f45:	eb 05                	jmp    801f4c <malloc+0x7f>
		}
	}
	return NULL;
  801f47:	b8 00 00 00 00       	mov    $0x0,%eax
	//		to the required allocation size (space should be on 4 KB BOUNDARY)
	//	2) if no suitable space found, return NULL
	// 	3) Return pointer containing the virtual address of allocated space,
	//
	//Use sys_isUHeapPlacementStrategyFIRSTFIT()... to check the current strategy
}
  801f4c:	c9                   	leave  
  801f4d:	c3                   	ret    

00801f4e <free>:
//	We can use sys_free_user_mem(uint32 virtual_address, uint32 size); which
//		switches to the kernel mode, calls free_user_mem() in
//		"kern/mem/chunk_operations.c", then switch back to the user mode here
//	the free_user_mem function is empty, make sure to implement it.
void free(void* virtual_address)
{
  801f4e:	55                   	push   %ebp
  801f4f:	89 e5                	mov    %esp,%ebp
  801f51:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] free
	// your code is here, remove the panic and write your code
	//panic("free() is not implemented yet...!!");

	uint32 virtualAddress = (uint32 )(virtual_address);
  801f54:	8b 45 08             	mov    0x8(%ebp),%eax
  801f57:	89 45 f4             	mov    %eax,-0xc(%ebp)
//	virtualAddress = ROUNDDOWN(virtualAddress, PAGE_SIZE);
	struct MemBlock * myBlock = find_block(&AllocMemBlocksList, virtualAddress);
  801f5a:	83 ec 08             	sub    $0x8,%esp
  801f5d:	ff 75 f4             	pushl  -0xc(%ebp)
  801f60:	68 40 50 80 00       	push   $0x805040
  801f65:	e8 5b 0b 00 00       	call   802ac5 <find_block>
  801f6a:	83 c4 10             	add    $0x10,%esp
  801f6d:	89 45 f0             	mov    %eax,-0x10(%ebp)
//	cprintf ("ptr sva at free user side = %x \n", myBlock->sva);
	sys_free_user_mem(virtualAddress, myBlock->size);
  801f70:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801f73:	8b 40 0c             	mov    0xc(%eax),%eax
  801f76:	83 ec 08             	sub    $0x8,%esp
  801f79:	50                   	push   %eax
  801f7a:	ff 75 f4             	pushl  -0xc(%ebp)
  801f7d:	e8 a2 03 00 00       	call   802324 <sys_free_user_mem>
  801f82:	83 c4 10             	add    $0x10,%esp
	LIST_REMOVE(&AllocMemBlocksList, myBlock);
  801f85:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801f89:	75 14                	jne    801f9f <free+0x51>
  801f8b:	83 ec 04             	sub    $0x4,%esp
  801f8e:	68 15 45 80 00       	push   $0x804515
  801f93:	6a 76                	push   $0x76
  801f95:	68 33 45 80 00       	push   $0x804533
  801f9a:	e8 e8 ec ff ff       	call   800c87 <_panic>
  801f9f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801fa2:	8b 00                	mov    (%eax),%eax
  801fa4:	85 c0                	test   %eax,%eax
  801fa6:	74 10                	je     801fb8 <free+0x6a>
  801fa8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801fab:	8b 00                	mov    (%eax),%eax
  801fad:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801fb0:	8b 52 04             	mov    0x4(%edx),%edx
  801fb3:	89 50 04             	mov    %edx,0x4(%eax)
  801fb6:	eb 0b                	jmp    801fc3 <free+0x75>
  801fb8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801fbb:	8b 40 04             	mov    0x4(%eax),%eax
  801fbe:	a3 44 50 80 00       	mov    %eax,0x805044
  801fc3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801fc6:	8b 40 04             	mov    0x4(%eax),%eax
  801fc9:	85 c0                	test   %eax,%eax
  801fcb:	74 0f                	je     801fdc <free+0x8e>
  801fcd:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801fd0:	8b 40 04             	mov    0x4(%eax),%eax
  801fd3:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801fd6:	8b 12                	mov    (%edx),%edx
  801fd8:	89 10                	mov    %edx,(%eax)
  801fda:	eb 0a                	jmp    801fe6 <free+0x98>
  801fdc:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801fdf:	8b 00                	mov    (%eax),%eax
  801fe1:	a3 40 50 80 00       	mov    %eax,0x805040
  801fe6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801fe9:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  801fef:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801ff2:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  801ff9:	a1 4c 50 80 00       	mov    0x80504c,%eax
  801ffe:	48                   	dec    %eax
  801fff:	a3 4c 50 80 00       	mov    %eax,0x80504c
	insert_sorted_with_merge_freeList(myBlock);
  802004:	83 ec 0c             	sub    $0xc,%esp
  802007:	ff 75 f0             	pushl  -0x10(%ebp)
  80200a:	e8 0b 14 00 00       	call   80341a <insert_sorted_with_merge_freeList>
  80200f:	83 c4 10             	add    $0x10,%esp

	//you should get the size of the given allocation using its address
	//you need to call sys_free_user_mem()
	//refer to the project presentation and documentation for details
}
  802012:	90                   	nop
  802013:	c9                   	leave  
  802014:	c3                   	ret    

00802015 <smalloc>:

//=================================
// [4] ALLOCATE SHARED VARIABLE:
//=================================
void* smalloc(char *sharedVarName, uint32 size, uint8 isWritable)
{
  802015:	55                   	push   %ebp
  802016:	89 e5                	mov    %esp,%ebp
  802018:	83 ec 28             	sub    $0x28,%esp
  80201b:	8b 45 10             	mov    0x10(%ebp),%eax
  80201e:	88 45 e4             	mov    %al,-0x1c(%ebp)
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  802021:	e8 9f fc ff ff       	call   801cc5 <InitializeUHeap>
	if (size == 0) return NULL ;
  802026:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80202a:	75 0a                	jne    802036 <smalloc+0x21>
  80202c:	b8 00 00 00 00       	mov    $0x0,%eax
  802031:	e9 8d 00 00 00       	jmp    8020c3 <smalloc+0xae>

	//This function should find the space of the required range
	// * ON 4KB BOUNDARY **** //
	//Use sys_isUHeapPlacementStrategyFIRSTFIT() to check the current strategy

	size = ROUNDUP(size, PAGE_SIZE);
  802036:	c7 45 f4 00 10 00 00 	movl   $0x1000,-0xc(%ebp)
  80203d:	8b 55 0c             	mov    0xc(%ebp),%edx
  802040:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802043:	01 d0                	add    %edx,%eax
  802045:	48                   	dec    %eax
  802046:	89 45 f0             	mov    %eax,-0x10(%ebp)
  802049:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80204c:	ba 00 00 00 00       	mov    $0x0,%edx
  802051:	f7 75 f4             	divl   -0xc(%ebp)
  802054:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802057:	29 d0                	sub    %edx,%eax
  802059:	89 45 0c             	mov    %eax,0xc(%ebp)
		if(sys_isUHeapPlacementStrategyFIRSTFIT())
  80205c:	e8 c9 06 00 00       	call   80272a <sys_isUHeapPlacementStrategyFIRSTFIT>
  802061:	85 c0                	test   %eax,%eax
  802063:	74 59                	je     8020be <smalloc+0xa9>
		{
			struct MemBlock * v1=NULL;
  802065:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
			v1= alloc_block_FF(size);
  80206c:	83 ec 0c             	sub    $0xc,%esp
  80206f:	ff 75 0c             	pushl  0xc(%ebp)
  802072:	e8 b4 0c 00 00       	call   802d2b <alloc_block_FF>
  802077:	83 c4 10             	add    $0x10,%esp
  80207a:	89 45 ec             	mov    %eax,-0x14(%ebp)
			if(v1==NULL)
  80207d:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802081:	75 07                	jne    80208a <smalloc+0x75>
			{
				return NULL;
  802083:	b8 00 00 00 00       	mov    $0x0,%eax
  802088:	eb 39                	jmp    8020c3 <smalloc+0xae>
			}
			else
			{
				int ret=sys_createSharedObject(sharedVarName,  size,  isWritable,(void*)v1->sva);
  80208a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80208d:	8b 40 08             	mov    0x8(%eax),%eax
  802090:	89 c2                	mov    %eax,%edx
  802092:	0f b6 45 e4          	movzbl -0x1c(%ebp),%eax
  802096:	52                   	push   %edx
  802097:	50                   	push   %eax
  802098:	ff 75 0c             	pushl  0xc(%ebp)
  80209b:	ff 75 08             	pushl  0x8(%ebp)
  80209e:	e8 0c 04 00 00       	call   8024af <sys_createSharedObject>
  8020a3:	83 c4 10             	add    $0x10,%esp
  8020a6:	89 45 e8             	mov    %eax,-0x18(%ebp)
				if(ret>=0)
  8020a9:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  8020ad:	78 08                	js     8020b7 <smalloc+0xa2>
				{
					return (void*)v1->sva;
  8020af:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8020b2:	8b 40 08             	mov    0x8(%eax),%eax
  8020b5:	eb 0c                	jmp    8020c3 <smalloc+0xae>
				}
				else
				{
					return NULL;
  8020b7:	b8 00 00 00 00       	mov    $0x0,%eax
  8020bc:	eb 05                	jmp    8020c3 <smalloc+0xae>
				}
			}

		}
		return NULL;
  8020be:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8020c3:	c9                   	leave  
  8020c4:	c3                   	ret    

008020c5 <sget>:

//========================================
// [5] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
  8020c5:	55                   	push   %ebp
  8020c6:	89 e5                	mov    %esp,%ebp
  8020c8:	83 ec 18             	sub    $0x18,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  8020cb:	e8 f5 fb ff ff       	call   801cc5 <InitializeUHeap>

	//This function should find the space for sharing the variable
	// *** ON 4KB BOUNDARY ******** //

	//Use sys_isUHeapPlacementStrategyFIRSTFIT() to check the current strategy
	int ret=sys_getSizeOfSharedObject(ownerEnvID,sharedVarName);
  8020d0:	83 ec 08             	sub    $0x8,%esp
  8020d3:	ff 75 0c             	pushl  0xc(%ebp)
  8020d6:	ff 75 08             	pushl  0x8(%ebp)
  8020d9:	e8 fb 03 00 00       	call   8024d9 <sys_getSizeOfSharedObject>
  8020de:	83 c4 10             	add    $0x10,%esp
  8020e1:	89 45 f4             	mov    %eax,-0xc(%ebp)
	if(ret==0)
  8020e4:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8020e8:	75 07                	jne    8020f1 <sget+0x2c>
	{
		return NULL;
  8020ea:	b8 00 00 00 00       	mov    $0x0,%eax
  8020ef:	eb 64                	jmp    802155 <sget+0x90>
	}
	if(sys_isUHeapPlacementStrategyFIRSTFIT())
  8020f1:	e8 34 06 00 00       	call   80272a <sys_isUHeapPlacementStrategyFIRSTFIT>
  8020f6:	85 c0                	test   %eax,%eax
  8020f8:	74 56                	je     802150 <sget+0x8b>
	{
		struct MemBlock * v1=NULL;
  8020fa:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
		v1= alloc_block_FF(ret);
  802101:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802104:	83 ec 0c             	sub    $0xc,%esp
  802107:	50                   	push   %eax
  802108:	e8 1e 0c 00 00       	call   802d2b <alloc_block_FF>
  80210d:	83 c4 10             	add    $0x10,%esp
  802110:	89 45 f0             	mov    %eax,-0x10(%ebp)
		if(v1==NULL)
  802113:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802117:	75 07                	jne    802120 <sget+0x5b>
		{
		return NULL;
  802119:	b8 00 00 00 00       	mov    $0x0,%eax
  80211e:	eb 35                	jmp    802155 <sget+0x90>
	    }
		else
		{
			int ret1=sys_getSharedObject(ownerEnvID,sharedVarName,(void*)v1->sva);
  802120:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802123:	8b 40 08             	mov    0x8(%eax),%eax
  802126:	83 ec 04             	sub    $0x4,%esp
  802129:	50                   	push   %eax
  80212a:	ff 75 0c             	pushl  0xc(%ebp)
  80212d:	ff 75 08             	pushl  0x8(%ebp)
  802130:	e8 c1 03 00 00       	call   8024f6 <sys_getSharedObject>
  802135:	83 c4 10             	add    $0x10,%esp
  802138:	89 45 ec             	mov    %eax,-0x14(%ebp)
			if(ret1>=0)
  80213b:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  80213f:	78 08                	js     802149 <sget+0x84>
			{
				return (void*)v1->sva;
  802141:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802144:	8b 40 08             	mov    0x8(%eax),%eax
  802147:	eb 0c                	jmp    802155 <sget+0x90>
			}
			else
			{
				return NULL;
  802149:	b8 00 00 00 00       	mov    $0x0,%eax
  80214e:	eb 05                	jmp    802155 <sget+0x90>
			}
		}
	}
  return NULL;
  802150:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802155:	c9                   	leave  
  802156:	c3                   	ret    

00802157 <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  802157:	55                   	push   %ebp
  802158:	89 e5                	mov    %esp,%ebp
  80215a:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  80215d:	e8 63 fb ff ff       	call   801cc5 <InitializeUHeap>
	//==============================================================
	// [USER HEAP - USER SIDE] realloc
	// Write your code here, remove the panic and write your code
	panic("realloc() is not implemented yet...!!");
  802162:	83 ec 04             	sub    $0x4,%esp
  802165:	68 64 45 80 00       	push   $0x804564
  80216a:	68 0e 01 00 00       	push   $0x10e
  80216f:	68 33 45 80 00       	push   $0x804533
  802174:	e8 0e eb ff ff       	call   800c87 <_panic>

00802179 <sfree>:
//	use sys_freeSharedObject(...); which switches to the kernel mode,
//	calls freeSharedObject(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the freeSharedObject() function is empty, make sure to implement it.

void sfree(void* virtual_address)
{
  802179:	55                   	push   %ebp
  80217a:	89 e5                	mov    %esp,%ebp
  80217c:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT MS3 - BONUS] [SHARING - USER SIDE] sfree()

	// Write your code here, remove the panic and write your code
	panic("sfree() is not implemented yet...!!");
  80217f:	83 ec 04             	sub    $0x4,%esp
  802182:	68 8c 45 80 00       	push   $0x80458c
  802187:	68 22 01 00 00       	push   $0x122
  80218c:	68 33 45 80 00       	push   $0x804533
  802191:	e8 f1 ea ff ff       	call   800c87 <_panic>

00802196 <expand>:

//==================================================================================//
//========================== MODIFICATION FUNCTIONS ================================//
//==================================================================================//
void expand(uint32 newSize)
{
  802196:	55                   	push   %ebp
  802197:	89 e5                	mov    %esp,%ebp
  802199:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  80219c:	83 ec 04             	sub    $0x4,%esp
  80219f:	68 b0 45 80 00       	push   $0x8045b0
  8021a4:	68 2d 01 00 00       	push   $0x12d
  8021a9:	68 33 45 80 00       	push   $0x804533
  8021ae:	e8 d4 ea ff ff       	call   800c87 <_panic>

008021b3 <shrink>:

}
void shrink(uint32 newSize)
{
  8021b3:	55                   	push   %ebp
  8021b4:	89 e5                	mov    %esp,%ebp
  8021b6:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  8021b9:	83 ec 04             	sub    $0x4,%esp
  8021bc:	68 b0 45 80 00       	push   $0x8045b0
  8021c1:	68 32 01 00 00       	push   $0x132
  8021c6:	68 33 45 80 00       	push   $0x804533
  8021cb:	e8 b7 ea ff ff       	call   800c87 <_panic>

008021d0 <freeHeap>:

}
void freeHeap(void* virtual_address)
{
  8021d0:	55                   	push   %ebp
  8021d1:	89 e5                	mov    %esp,%ebp
  8021d3:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  8021d6:	83 ec 04             	sub    $0x4,%esp
  8021d9:	68 b0 45 80 00       	push   $0x8045b0
  8021de:	68 37 01 00 00       	push   $0x137
  8021e3:	68 33 45 80 00       	push   $0x804533
  8021e8:	e8 9a ea ff ff       	call   800c87 <_panic>

008021ed <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  8021ed:	55                   	push   %ebp
  8021ee:	89 e5                	mov    %esp,%ebp
  8021f0:	57                   	push   %edi
  8021f1:	56                   	push   %esi
  8021f2:	53                   	push   %ebx
  8021f3:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8021f6:	8b 45 08             	mov    0x8(%ebp),%eax
  8021f9:	8b 55 0c             	mov    0xc(%ebp),%edx
  8021fc:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8021ff:	8b 5d 14             	mov    0x14(%ebp),%ebx
  802202:	8b 7d 18             	mov    0x18(%ebp),%edi
  802205:	8b 75 1c             	mov    0x1c(%ebp),%esi
  802208:	cd 30                	int    $0x30
  80220a:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  80220d:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  802210:	83 c4 10             	add    $0x10,%esp
  802213:	5b                   	pop    %ebx
  802214:	5e                   	pop    %esi
  802215:	5f                   	pop    %edi
  802216:	5d                   	pop    %ebp
  802217:	c3                   	ret    

00802218 <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  802218:	55                   	push   %ebp
  802219:	89 e5                	mov    %esp,%ebp
  80221b:	83 ec 04             	sub    $0x4,%esp
  80221e:	8b 45 10             	mov    0x10(%ebp),%eax
  802221:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  802224:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  802228:	8b 45 08             	mov    0x8(%ebp),%eax
  80222b:	6a 00                	push   $0x0
  80222d:	6a 00                	push   $0x0
  80222f:	52                   	push   %edx
  802230:	ff 75 0c             	pushl  0xc(%ebp)
  802233:	50                   	push   %eax
  802234:	6a 00                	push   $0x0
  802236:	e8 b2 ff ff ff       	call   8021ed <syscall>
  80223b:	83 c4 18             	add    $0x18,%esp
}
  80223e:	90                   	nop
  80223f:	c9                   	leave  
  802240:	c3                   	ret    

00802241 <sys_cgetc>:

int
sys_cgetc(void)
{
  802241:	55                   	push   %ebp
  802242:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  802244:	6a 00                	push   $0x0
  802246:	6a 00                	push   $0x0
  802248:	6a 00                	push   $0x0
  80224a:	6a 00                	push   $0x0
  80224c:	6a 00                	push   $0x0
  80224e:	6a 01                	push   $0x1
  802250:	e8 98 ff ff ff       	call   8021ed <syscall>
  802255:	83 c4 18             	add    $0x18,%esp
}
  802258:	c9                   	leave  
  802259:	c3                   	ret    

0080225a <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  80225a:	55                   	push   %ebp
  80225b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  80225d:	8b 55 0c             	mov    0xc(%ebp),%edx
  802260:	8b 45 08             	mov    0x8(%ebp),%eax
  802263:	6a 00                	push   $0x0
  802265:	6a 00                	push   $0x0
  802267:	6a 00                	push   $0x0
  802269:	52                   	push   %edx
  80226a:	50                   	push   %eax
  80226b:	6a 05                	push   $0x5
  80226d:	e8 7b ff ff ff       	call   8021ed <syscall>
  802272:	83 c4 18             	add    $0x18,%esp
}
  802275:	c9                   	leave  
  802276:	c3                   	ret    

00802277 <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  802277:	55                   	push   %ebp
  802278:	89 e5                	mov    %esp,%ebp
  80227a:	56                   	push   %esi
  80227b:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  80227c:	8b 75 18             	mov    0x18(%ebp),%esi
  80227f:	8b 5d 14             	mov    0x14(%ebp),%ebx
  802282:	8b 4d 10             	mov    0x10(%ebp),%ecx
  802285:	8b 55 0c             	mov    0xc(%ebp),%edx
  802288:	8b 45 08             	mov    0x8(%ebp),%eax
  80228b:	56                   	push   %esi
  80228c:	53                   	push   %ebx
  80228d:	51                   	push   %ecx
  80228e:	52                   	push   %edx
  80228f:	50                   	push   %eax
  802290:	6a 06                	push   $0x6
  802292:	e8 56 ff ff ff       	call   8021ed <syscall>
  802297:	83 c4 18             	add    $0x18,%esp
}
  80229a:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80229d:	5b                   	pop    %ebx
  80229e:	5e                   	pop    %esi
  80229f:	5d                   	pop    %ebp
  8022a0:	c3                   	ret    

008022a1 <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  8022a1:	55                   	push   %ebp
  8022a2:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  8022a4:	8b 55 0c             	mov    0xc(%ebp),%edx
  8022a7:	8b 45 08             	mov    0x8(%ebp),%eax
  8022aa:	6a 00                	push   $0x0
  8022ac:	6a 00                	push   $0x0
  8022ae:	6a 00                	push   $0x0
  8022b0:	52                   	push   %edx
  8022b1:	50                   	push   %eax
  8022b2:	6a 07                	push   $0x7
  8022b4:	e8 34 ff ff ff       	call   8021ed <syscall>
  8022b9:	83 c4 18             	add    $0x18,%esp
}
  8022bc:	c9                   	leave  
  8022bd:	c3                   	ret    

008022be <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  8022be:	55                   	push   %ebp
  8022bf:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  8022c1:	6a 00                	push   $0x0
  8022c3:	6a 00                	push   $0x0
  8022c5:	6a 00                	push   $0x0
  8022c7:	ff 75 0c             	pushl  0xc(%ebp)
  8022ca:	ff 75 08             	pushl  0x8(%ebp)
  8022cd:	6a 08                	push   $0x8
  8022cf:	e8 19 ff ff ff       	call   8021ed <syscall>
  8022d4:	83 c4 18             	add    $0x18,%esp
}
  8022d7:	c9                   	leave  
  8022d8:	c3                   	ret    

008022d9 <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  8022d9:	55                   	push   %ebp
  8022da:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  8022dc:	6a 00                	push   $0x0
  8022de:	6a 00                	push   $0x0
  8022e0:	6a 00                	push   $0x0
  8022e2:	6a 00                	push   $0x0
  8022e4:	6a 00                	push   $0x0
  8022e6:	6a 09                	push   $0x9
  8022e8:	e8 00 ff ff ff       	call   8021ed <syscall>
  8022ed:	83 c4 18             	add    $0x18,%esp
}
  8022f0:	c9                   	leave  
  8022f1:	c3                   	ret    

008022f2 <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  8022f2:	55                   	push   %ebp
  8022f3:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  8022f5:	6a 00                	push   $0x0
  8022f7:	6a 00                	push   $0x0
  8022f9:	6a 00                	push   $0x0
  8022fb:	6a 00                	push   $0x0
  8022fd:	6a 00                	push   $0x0
  8022ff:	6a 0a                	push   $0xa
  802301:	e8 e7 fe ff ff       	call   8021ed <syscall>
  802306:	83 c4 18             	add    $0x18,%esp
}
  802309:	c9                   	leave  
  80230a:	c3                   	ret    

0080230b <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  80230b:	55                   	push   %ebp
  80230c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  80230e:	6a 00                	push   $0x0
  802310:	6a 00                	push   $0x0
  802312:	6a 00                	push   $0x0
  802314:	6a 00                	push   $0x0
  802316:	6a 00                	push   $0x0
  802318:	6a 0b                	push   $0xb
  80231a:	e8 ce fe ff ff       	call   8021ed <syscall>
  80231f:	83 c4 18             	add    $0x18,%esp
}
  802322:	c9                   	leave  
  802323:	c3                   	ret    

00802324 <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  802324:	55                   	push   %ebp
  802325:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  802327:	6a 00                	push   $0x0
  802329:	6a 00                	push   $0x0
  80232b:	6a 00                	push   $0x0
  80232d:	ff 75 0c             	pushl  0xc(%ebp)
  802330:	ff 75 08             	pushl  0x8(%ebp)
  802333:	6a 0f                	push   $0xf
  802335:	e8 b3 fe ff ff       	call   8021ed <syscall>
  80233a:	83 c4 18             	add    $0x18,%esp
	return;
  80233d:	90                   	nop
}
  80233e:	c9                   	leave  
  80233f:	c3                   	ret    

00802340 <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  802340:	55                   	push   %ebp
  802341:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  802343:	6a 00                	push   $0x0
  802345:	6a 00                	push   $0x0
  802347:	6a 00                	push   $0x0
  802349:	ff 75 0c             	pushl  0xc(%ebp)
  80234c:	ff 75 08             	pushl  0x8(%ebp)
  80234f:	6a 10                	push   $0x10
  802351:	e8 97 fe ff ff       	call   8021ed <syscall>
  802356:	83 c4 18             	add    $0x18,%esp
	return ;
  802359:	90                   	nop
}
  80235a:	c9                   	leave  
  80235b:	c3                   	ret    

0080235c <sys_allocate_chunk>:

void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  80235c:	55                   	push   %ebp
  80235d:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  80235f:	6a 00                	push   $0x0
  802361:	6a 00                	push   $0x0
  802363:	ff 75 10             	pushl  0x10(%ebp)
  802366:	ff 75 0c             	pushl  0xc(%ebp)
  802369:	ff 75 08             	pushl  0x8(%ebp)
  80236c:	6a 11                	push   $0x11
  80236e:	e8 7a fe ff ff       	call   8021ed <syscall>
  802373:	83 c4 18             	add    $0x18,%esp
	return ;
  802376:	90                   	nop
}
  802377:	c9                   	leave  
  802378:	c3                   	ret    

00802379 <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  802379:	55                   	push   %ebp
  80237a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  80237c:	6a 00                	push   $0x0
  80237e:	6a 00                	push   $0x0
  802380:	6a 00                	push   $0x0
  802382:	6a 00                	push   $0x0
  802384:	6a 00                	push   $0x0
  802386:	6a 0c                	push   $0xc
  802388:	e8 60 fe ff ff       	call   8021ed <syscall>
  80238d:	83 c4 18             	add    $0x18,%esp
}
  802390:	c9                   	leave  
  802391:	c3                   	ret    

00802392 <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  802392:	55                   	push   %ebp
  802393:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  802395:	6a 00                	push   $0x0
  802397:	6a 00                	push   $0x0
  802399:	6a 00                	push   $0x0
  80239b:	6a 00                	push   $0x0
  80239d:	ff 75 08             	pushl  0x8(%ebp)
  8023a0:	6a 0d                	push   $0xd
  8023a2:	e8 46 fe ff ff       	call   8021ed <syscall>
  8023a7:	83 c4 18             	add    $0x18,%esp
}
  8023aa:	c9                   	leave  
  8023ab:	c3                   	ret    

008023ac <sys_scarce_memory>:

void sys_scarce_memory()
{
  8023ac:	55                   	push   %ebp
  8023ad:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  8023af:	6a 00                	push   $0x0
  8023b1:	6a 00                	push   $0x0
  8023b3:	6a 00                	push   $0x0
  8023b5:	6a 00                	push   $0x0
  8023b7:	6a 00                	push   $0x0
  8023b9:	6a 0e                	push   $0xe
  8023bb:	e8 2d fe ff ff       	call   8021ed <syscall>
  8023c0:	83 c4 18             	add    $0x18,%esp
}
  8023c3:	90                   	nop
  8023c4:	c9                   	leave  
  8023c5:	c3                   	ret    

008023c6 <sys_disable_interrupt>:

//NEW !! 2012...
void
sys_disable_interrupt()
{
  8023c6:	55                   	push   %ebp
  8023c7:	89 e5                	mov    %esp,%ebp
	syscall(SYS_disableINTR,0, 0, 0, 0, 0);
  8023c9:	6a 00                	push   $0x0
  8023cb:	6a 00                	push   $0x0
  8023cd:	6a 00                	push   $0x0
  8023cf:	6a 00                	push   $0x0
  8023d1:	6a 00                	push   $0x0
  8023d3:	6a 13                	push   $0x13
  8023d5:	e8 13 fe ff ff       	call   8021ed <syscall>
  8023da:	83 c4 18             	add    $0x18,%esp
}
  8023dd:	90                   	nop
  8023de:	c9                   	leave  
  8023df:	c3                   	ret    

008023e0 <sys_enable_interrupt>:


void
sys_enable_interrupt()
{
  8023e0:	55                   	push   %ebp
  8023e1:	89 e5                	mov    %esp,%ebp
	syscall(SYS_enableINTR,0, 0, 0, 0, 0);
  8023e3:	6a 00                	push   $0x0
  8023e5:	6a 00                	push   $0x0
  8023e7:	6a 00                	push   $0x0
  8023e9:	6a 00                	push   $0x0
  8023eb:	6a 00                	push   $0x0
  8023ed:	6a 14                	push   $0x14
  8023ef:	e8 f9 fd ff ff       	call   8021ed <syscall>
  8023f4:	83 c4 18             	add    $0x18,%esp
}
  8023f7:	90                   	nop
  8023f8:	c9                   	leave  
  8023f9:	c3                   	ret    

008023fa <sys_cputc>:


void
sys_cputc(const char c)
{
  8023fa:	55                   	push   %ebp
  8023fb:	89 e5                	mov    %esp,%ebp
  8023fd:	83 ec 04             	sub    $0x4,%esp
  802400:	8b 45 08             	mov    0x8(%ebp),%eax
  802403:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  802406:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  80240a:	6a 00                	push   $0x0
  80240c:	6a 00                	push   $0x0
  80240e:	6a 00                	push   $0x0
  802410:	6a 00                	push   $0x0
  802412:	50                   	push   %eax
  802413:	6a 15                	push   $0x15
  802415:	e8 d3 fd ff ff       	call   8021ed <syscall>
  80241a:	83 c4 18             	add    $0x18,%esp
}
  80241d:	90                   	nop
  80241e:	c9                   	leave  
  80241f:	c3                   	ret    

00802420 <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  802420:	55                   	push   %ebp
  802421:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  802423:	6a 00                	push   $0x0
  802425:	6a 00                	push   $0x0
  802427:	6a 00                	push   $0x0
  802429:	6a 00                	push   $0x0
  80242b:	6a 00                	push   $0x0
  80242d:	6a 16                	push   $0x16
  80242f:	e8 b9 fd ff ff       	call   8021ed <syscall>
  802434:	83 c4 18             	add    $0x18,%esp
}
  802437:	90                   	nop
  802438:	c9                   	leave  
  802439:	c3                   	ret    

0080243a <sys_createSemaphore>:

int
sys_createSemaphore(char* semaphoreName, uint32 initialValue)
{
  80243a:	55                   	push   %ebp
  80243b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_semaphore,(uint32)semaphoreName, (uint32)initialValue, 0, 0, 0);
  80243d:	8b 45 08             	mov    0x8(%ebp),%eax
  802440:	6a 00                	push   $0x0
  802442:	6a 00                	push   $0x0
  802444:	6a 00                	push   $0x0
  802446:	ff 75 0c             	pushl  0xc(%ebp)
  802449:	50                   	push   %eax
  80244a:	6a 17                	push   $0x17
  80244c:	e8 9c fd ff ff       	call   8021ed <syscall>
  802451:	83 c4 18             	add    $0x18,%esp
}
  802454:	c9                   	leave  
  802455:	c3                   	ret    

00802456 <sys_getSemaphoreValue>:

int
sys_getSemaphoreValue(int32 ownerEnvID, char* semaphoreName)
{
  802456:	55                   	push   %ebp
  802457:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_semaphore_value,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  802459:	8b 55 0c             	mov    0xc(%ebp),%edx
  80245c:	8b 45 08             	mov    0x8(%ebp),%eax
  80245f:	6a 00                	push   $0x0
  802461:	6a 00                	push   $0x0
  802463:	6a 00                	push   $0x0
  802465:	52                   	push   %edx
  802466:	50                   	push   %eax
  802467:	6a 1a                	push   $0x1a
  802469:	e8 7f fd ff ff       	call   8021ed <syscall>
  80246e:	83 c4 18             	add    $0x18,%esp
}
  802471:	c9                   	leave  
  802472:	c3                   	ret    

00802473 <sys_waitSemaphore>:

void
sys_waitSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  802473:	55                   	push   %ebp
  802474:	89 e5                	mov    %esp,%ebp
	syscall(SYS_wait_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  802476:	8b 55 0c             	mov    0xc(%ebp),%edx
  802479:	8b 45 08             	mov    0x8(%ebp),%eax
  80247c:	6a 00                	push   $0x0
  80247e:	6a 00                	push   $0x0
  802480:	6a 00                	push   $0x0
  802482:	52                   	push   %edx
  802483:	50                   	push   %eax
  802484:	6a 18                	push   $0x18
  802486:	e8 62 fd ff ff       	call   8021ed <syscall>
  80248b:	83 c4 18             	add    $0x18,%esp
}
  80248e:	90                   	nop
  80248f:	c9                   	leave  
  802490:	c3                   	ret    

00802491 <sys_signalSemaphore>:

void
sys_signalSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  802491:	55                   	push   %ebp
  802492:	89 e5                	mov    %esp,%ebp
	syscall(SYS_signal_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  802494:	8b 55 0c             	mov    0xc(%ebp),%edx
  802497:	8b 45 08             	mov    0x8(%ebp),%eax
  80249a:	6a 00                	push   $0x0
  80249c:	6a 00                	push   $0x0
  80249e:	6a 00                	push   $0x0
  8024a0:	52                   	push   %edx
  8024a1:	50                   	push   %eax
  8024a2:	6a 19                	push   $0x19
  8024a4:	e8 44 fd ff ff       	call   8021ed <syscall>
  8024a9:	83 c4 18             	add    $0x18,%esp
}
  8024ac:	90                   	nop
  8024ad:	c9                   	leave  
  8024ae:	c3                   	ret    

008024af <sys_createSharedObject>:

int
sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  8024af:	55                   	push   %ebp
  8024b0:	89 e5                	mov    %esp,%ebp
  8024b2:	83 ec 04             	sub    $0x4,%esp
  8024b5:	8b 45 10             	mov    0x10(%ebp),%eax
  8024b8:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  8024bb:	8b 4d 14             	mov    0x14(%ebp),%ecx
  8024be:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  8024c2:	8b 45 08             	mov    0x8(%ebp),%eax
  8024c5:	6a 00                	push   $0x0
  8024c7:	51                   	push   %ecx
  8024c8:	52                   	push   %edx
  8024c9:	ff 75 0c             	pushl  0xc(%ebp)
  8024cc:	50                   	push   %eax
  8024cd:	6a 1b                	push   $0x1b
  8024cf:	e8 19 fd ff ff       	call   8021ed <syscall>
  8024d4:	83 c4 18             	add    $0x18,%esp
}
  8024d7:	c9                   	leave  
  8024d8:	c3                   	ret    

008024d9 <sys_getSizeOfSharedObject>:

//2017:
int
sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  8024d9:	55                   	push   %ebp
  8024da:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  8024dc:	8b 55 0c             	mov    0xc(%ebp),%edx
  8024df:	8b 45 08             	mov    0x8(%ebp),%eax
  8024e2:	6a 00                	push   $0x0
  8024e4:	6a 00                	push   $0x0
  8024e6:	6a 00                	push   $0x0
  8024e8:	52                   	push   %edx
  8024e9:	50                   	push   %eax
  8024ea:	6a 1c                	push   $0x1c
  8024ec:	e8 fc fc ff ff       	call   8021ed <syscall>
  8024f1:	83 c4 18             	add    $0x18,%esp
}
  8024f4:	c9                   	leave  
  8024f5:	c3                   	ret    

008024f6 <sys_getSharedObject>:
//==========

int
sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  8024f6:	55                   	push   %ebp
  8024f7:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  8024f9:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8024fc:	8b 55 0c             	mov    0xc(%ebp),%edx
  8024ff:	8b 45 08             	mov    0x8(%ebp),%eax
  802502:	6a 00                	push   $0x0
  802504:	6a 00                	push   $0x0
  802506:	51                   	push   %ecx
  802507:	52                   	push   %edx
  802508:	50                   	push   %eax
  802509:	6a 1d                	push   $0x1d
  80250b:	e8 dd fc ff ff       	call   8021ed <syscall>
  802510:	83 c4 18             	add    $0x18,%esp
}
  802513:	c9                   	leave  
  802514:	c3                   	ret    

00802515 <sys_freeSharedObject>:

int
sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  802515:	55                   	push   %ebp
  802516:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  802518:	8b 55 0c             	mov    0xc(%ebp),%edx
  80251b:	8b 45 08             	mov    0x8(%ebp),%eax
  80251e:	6a 00                	push   $0x0
  802520:	6a 00                	push   $0x0
  802522:	6a 00                	push   $0x0
  802524:	52                   	push   %edx
  802525:	50                   	push   %eax
  802526:	6a 1e                	push   $0x1e
  802528:	e8 c0 fc ff ff       	call   8021ed <syscall>
  80252d:	83 c4 18             	add    $0x18,%esp
}
  802530:	c9                   	leave  
  802531:	c3                   	ret    

00802532 <sys_getMaxShares>:

uint32 	sys_getMaxShares()
{
  802532:	55                   	push   %ebp
  802533:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_max_shares,0, 0, 0, 0, 0);
  802535:	6a 00                	push   $0x0
  802537:	6a 00                	push   $0x0
  802539:	6a 00                	push   $0x0
  80253b:	6a 00                	push   $0x0
  80253d:	6a 00                	push   $0x0
  80253f:	6a 1f                	push   $0x1f
  802541:	e8 a7 fc ff ff       	call   8021ed <syscall>
  802546:	83 c4 18             	add    $0x18,%esp
}
  802549:	c9                   	leave  
  80254a:	c3                   	ret    

0080254b <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  80254b:	55                   	push   %ebp
  80254c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  80254e:	8b 45 08             	mov    0x8(%ebp),%eax
  802551:	6a 00                	push   $0x0
  802553:	ff 75 14             	pushl  0x14(%ebp)
  802556:	ff 75 10             	pushl  0x10(%ebp)
  802559:	ff 75 0c             	pushl  0xc(%ebp)
  80255c:	50                   	push   %eax
  80255d:	6a 20                	push   $0x20
  80255f:	e8 89 fc ff ff       	call   8021ed <syscall>
  802564:	83 c4 18             	add    $0x18,%esp
}
  802567:	c9                   	leave  
  802568:	c3                   	ret    

00802569 <sys_run_env>:

void
sys_run_env(int32 envId)
{
  802569:	55                   	push   %ebp
  80256a:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  80256c:	8b 45 08             	mov    0x8(%ebp),%eax
  80256f:	6a 00                	push   $0x0
  802571:	6a 00                	push   $0x0
  802573:	6a 00                	push   $0x0
  802575:	6a 00                	push   $0x0
  802577:	50                   	push   %eax
  802578:	6a 21                	push   $0x21
  80257a:	e8 6e fc ff ff       	call   8021ed <syscall>
  80257f:	83 c4 18             	add    $0x18,%esp
}
  802582:	90                   	nop
  802583:	c9                   	leave  
  802584:	c3                   	ret    

00802585 <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  802585:	55                   	push   %ebp
  802586:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  802588:	8b 45 08             	mov    0x8(%ebp),%eax
  80258b:	6a 00                	push   $0x0
  80258d:	6a 00                	push   $0x0
  80258f:	6a 00                	push   $0x0
  802591:	6a 00                	push   $0x0
  802593:	50                   	push   %eax
  802594:	6a 22                	push   $0x22
  802596:	e8 52 fc ff ff       	call   8021ed <syscall>
  80259b:	83 c4 18             	add    $0x18,%esp
}
  80259e:	c9                   	leave  
  80259f:	c3                   	ret    

008025a0 <sys_getenvid>:

int32 sys_getenvid(void)
{
  8025a0:	55                   	push   %ebp
  8025a1:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  8025a3:	6a 00                	push   $0x0
  8025a5:	6a 00                	push   $0x0
  8025a7:	6a 00                	push   $0x0
  8025a9:	6a 00                	push   $0x0
  8025ab:	6a 00                	push   $0x0
  8025ad:	6a 02                	push   $0x2
  8025af:	e8 39 fc ff ff       	call   8021ed <syscall>
  8025b4:	83 c4 18             	add    $0x18,%esp
}
  8025b7:	c9                   	leave  
  8025b8:	c3                   	ret    

008025b9 <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  8025b9:	55                   	push   %ebp
  8025ba:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  8025bc:	6a 00                	push   $0x0
  8025be:	6a 00                	push   $0x0
  8025c0:	6a 00                	push   $0x0
  8025c2:	6a 00                	push   $0x0
  8025c4:	6a 00                	push   $0x0
  8025c6:	6a 03                	push   $0x3
  8025c8:	e8 20 fc ff ff       	call   8021ed <syscall>
  8025cd:	83 c4 18             	add    $0x18,%esp
}
  8025d0:	c9                   	leave  
  8025d1:	c3                   	ret    

008025d2 <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  8025d2:	55                   	push   %ebp
  8025d3:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  8025d5:	6a 00                	push   $0x0
  8025d7:	6a 00                	push   $0x0
  8025d9:	6a 00                	push   $0x0
  8025db:	6a 00                	push   $0x0
  8025dd:	6a 00                	push   $0x0
  8025df:	6a 04                	push   $0x4
  8025e1:	e8 07 fc ff ff       	call   8021ed <syscall>
  8025e6:	83 c4 18             	add    $0x18,%esp
}
  8025e9:	c9                   	leave  
  8025ea:	c3                   	ret    

008025eb <sys_exit_env>:


void sys_exit_env(void)
{
  8025eb:	55                   	push   %ebp
  8025ec:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  8025ee:	6a 00                	push   $0x0
  8025f0:	6a 00                	push   $0x0
  8025f2:	6a 00                	push   $0x0
  8025f4:	6a 00                	push   $0x0
  8025f6:	6a 00                	push   $0x0
  8025f8:	6a 23                	push   $0x23
  8025fa:	e8 ee fb ff ff       	call   8021ed <syscall>
  8025ff:	83 c4 18             	add    $0x18,%esp
}
  802602:	90                   	nop
  802603:	c9                   	leave  
  802604:	c3                   	ret    

00802605 <sys_get_virtual_time>:


struct uint64
sys_get_virtual_time()
{
  802605:	55                   	push   %ebp
  802606:	89 e5                	mov    %esp,%ebp
  802608:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  80260b:	8d 45 f8             	lea    -0x8(%ebp),%eax
  80260e:	8d 50 04             	lea    0x4(%eax),%edx
  802611:	8d 45 f8             	lea    -0x8(%ebp),%eax
  802614:	6a 00                	push   $0x0
  802616:	6a 00                	push   $0x0
  802618:	6a 00                	push   $0x0
  80261a:	52                   	push   %edx
  80261b:	50                   	push   %eax
  80261c:	6a 24                	push   $0x24
  80261e:	e8 ca fb ff ff       	call   8021ed <syscall>
  802623:	83 c4 18             	add    $0x18,%esp
	return result;
  802626:	8b 4d 08             	mov    0x8(%ebp),%ecx
  802629:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80262c:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80262f:	89 01                	mov    %eax,(%ecx)
  802631:	89 51 04             	mov    %edx,0x4(%ecx)
}
  802634:	8b 45 08             	mov    0x8(%ebp),%eax
  802637:	c9                   	leave  
  802638:	c2 04 00             	ret    $0x4

0080263b <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  80263b:	55                   	push   %ebp
  80263c:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  80263e:	6a 00                	push   $0x0
  802640:	6a 00                	push   $0x0
  802642:	ff 75 10             	pushl  0x10(%ebp)
  802645:	ff 75 0c             	pushl  0xc(%ebp)
  802648:	ff 75 08             	pushl  0x8(%ebp)
  80264b:	6a 12                	push   $0x12
  80264d:	e8 9b fb ff ff       	call   8021ed <syscall>
  802652:	83 c4 18             	add    $0x18,%esp
	return ;
  802655:	90                   	nop
}
  802656:	c9                   	leave  
  802657:	c3                   	ret    

00802658 <sys_rcr2>:
uint32 sys_rcr2()
{
  802658:	55                   	push   %ebp
  802659:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  80265b:	6a 00                	push   $0x0
  80265d:	6a 00                	push   $0x0
  80265f:	6a 00                	push   $0x0
  802661:	6a 00                	push   $0x0
  802663:	6a 00                	push   $0x0
  802665:	6a 25                	push   $0x25
  802667:	e8 81 fb ff ff       	call   8021ed <syscall>
  80266c:	83 c4 18             	add    $0x18,%esp
}
  80266f:	c9                   	leave  
  802670:	c3                   	ret    

00802671 <sys_bypassPageFault>:
void sys_bypassPageFault(uint8 instrLength)
{
  802671:	55                   	push   %ebp
  802672:	89 e5                	mov    %esp,%ebp
  802674:	83 ec 04             	sub    $0x4,%esp
  802677:	8b 45 08             	mov    0x8(%ebp),%eax
  80267a:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  80267d:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  802681:	6a 00                	push   $0x0
  802683:	6a 00                	push   $0x0
  802685:	6a 00                	push   $0x0
  802687:	6a 00                	push   $0x0
  802689:	50                   	push   %eax
  80268a:	6a 26                	push   $0x26
  80268c:	e8 5c fb ff ff       	call   8021ed <syscall>
  802691:	83 c4 18             	add    $0x18,%esp
	return ;
  802694:	90                   	nop
}
  802695:	c9                   	leave  
  802696:	c3                   	ret    

00802697 <rsttst>:
void rsttst()
{
  802697:	55                   	push   %ebp
  802698:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  80269a:	6a 00                	push   $0x0
  80269c:	6a 00                	push   $0x0
  80269e:	6a 00                	push   $0x0
  8026a0:	6a 00                	push   $0x0
  8026a2:	6a 00                	push   $0x0
  8026a4:	6a 28                	push   $0x28
  8026a6:	e8 42 fb ff ff       	call   8021ed <syscall>
  8026ab:	83 c4 18             	add    $0x18,%esp
	return ;
  8026ae:	90                   	nop
}
  8026af:	c9                   	leave  
  8026b0:	c3                   	ret    

008026b1 <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  8026b1:	55                   	push   %ebp
  8026b2:	89 e5                	mov    %esp,%ebp
  8026b4:	83 ec 04             	sub    $0x4,%esp
  8026b7:	8b 45 14             	mov    0x14(%ebp),%eax
  8026ba:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  8026bd:	8b 55 18             	mov    0x18(%ebp),%edx
  8026c0:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  8026c4:	52                   	push   %edx
  8026c5:	50                   	push   %eax
  8026c6:	ff 75 10             	pushl  0x10(%ebp)
  8026c9:	ff 75 0c             	pushl  0xc(%ebp)
  8026cc:	ff 75 08             	pushl  0x8(%ebp)
  8026cf:	6a 27                	push   $0x27
  8026d1:	e8 17 fb ff ff       	call   8021ed <syscall>
  8026d6:	83 c4 18             	add    $0x18,%esp
	return ;
  8026d9:	90                   	nop
}
  8026da:	c9                   	leave  
  8026db:	c3                   	ret    

008026dc <chktst>:
void chktst(uint32 n)
{
  8026dc:	55                   	push   %ebp
  8026dd:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  8026df:	6a 00                	push   $0x0
  8026e1:	6a 00                	push   $0x0
  8026e3:	6a 00                	push   $0x0
  8026e5:	6a 00                	push   $0x0
  8026e7:	ff 75 08             	pushl  0x8(%ebp)
  8026ea:	6a 29                	push   $0x29
  8026ec:	e8 fc fa ff ff       	call   8021ed <syscall>
  8026f1:	83 c4 18             	add    $0x18,%esp
	return ;
  8026f4:	90                   	nop
}
  8026f5:	c9                   	leave  
  8026f6:	c3                   	ret    

008026f7 <inctst>:

void inctst()
{
  8026f7:	55                   	push   %ebp
  8026f8:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  8026fa:	6a 00                	push   $0x0
  8026fc:	6a 00                	push   $0x0
  8026fe:	6a 00                	push   $0x0
  802700:	6a 00                	push   $0x0
  802702:	6a 00                	push   $0x0
  802704:	6a 2a                	push   $0x2a
  802706:	e8 e2 fa ff ff       	call   8021ed <syscall>
  80270b:	83 c4 18             	add    $0x18,%esp
	return ;
  80270e:	90                   	nop
}
  80270f:	c9                   	leave  
  802710:	c3                   	ret    

00802711 <gettst>:
uint32 gettst()
{
  802711:	55                   	push   %ebp
  802712:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  802714:	6a 00                	push   $0x0
  802716:	6a 00                	push   $0x0
  802718:	6a 00                	push   $0x0
  80271a:	6a 00                	push   $0x0
  80271c:	6a 00                	push   $0x0
  80271e:	6a 2b                	push   $0x2b
  802720:	e8 c8 fa ff ff       	call   8021ed <syscall>
  802725:	83 c4 18             	add    $0x18,%esp
}
  802728:	c9                   	leave  
  802729:	c3                   	ret    

0080272a <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  80272a:	55                   	push   %ebp
  80272b:	89 e5                	mov    %esp,%ebp
  80272d:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  802730:	6a 00                	push   $0x0
  802732:	6a 00                	push   $0x0
  802734:	6a 00                	push   $0x0
  802736:	6a 00                	push   $0x0
  802738:	6a 00                	push   $0x0
  80273a:	6a 2c                	push   $0x2c
  80273c:	e8 ac fa ff ff       	call   8021ed <syscall>
  802741:	83 c4 18             	add    $0x18,%esp
  802744:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  802747:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  80274b:	75 07                	jne    802754 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  80274d:	b8 01 00 00 00       	mov    $0x1,%eax
  802752:	eb 05                	jmp    802759 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  802754:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802759:	c9                   	leave  
  80275a:	c3                   	ret    

0080275b <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  80275b:	55                   	push   %ebp
  80275c:	89 e5                	mov    %esp,%ebp
  80275e:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  802761:	6a 00                	push   $0x0
  802763:	6a 00                	push   $0x0
  802765:	6a 00                	push   $0x0
  802767:	6a 00                	push   $0x0
  802769:	6a 00                	push   $0x0
  80276b:	6a 2c                	push   $0x2c
  80276d:	e8 7b fa ff ff       	call   8021ed <syscall>
  802772:	83 c4 18             	add    $0x18,%esp
  802775:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  802778:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  80277c:	75 07                	jne    802785 <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  80277e:	b8 01 00 00 00       	mov    $0x1,%eax
  802783:	eb 05                	jmp    80278a <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  802785:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80278a:	c9                   	leave  
  80278b:	c3                   	ret    

0080278c <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  80278c:	55                   	push   %ebp
  80278d:	89 e5                	mov    %esp,%ebp
  80278f:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  802792:	6a 00                	push   $0x0
  802794:	6a 00                	push   $0x0
  802796:	6a 00                	push   $0x0
  802798:	6a 00                	push   $0x0
  80279a:	6a 00                	push   $0x0
  80279c:	6a 2c                	push   $0x2c
  80279e:	e8 4a fa ff ff       	call   8021ed <syscall>
  8027a3:	83 c4 18             	add    $0x18,%esp
  8027a6:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  8027a9:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  8027ad:	75 07                	jne    8027b6 <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  8027af:	b8 01 00 00 00       	mov    $0x1,%eax
  8027b4:	eb 05                	jmp    8027bb <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  8027b6:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8027bb:	c9                   	leave  
  8027bc:	c3                   	ret    

008027bd <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  8027bd:	55                   	push   %ebp
  8027be:	89 e5                	mov    %esp,%ebp
  8027c0:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8027c3:	6a 00                	push   $0x0
  8027c5:	6a 00                	push   $0x0
  8027c7:	6a 00                	push   $0x0
  8027c9:	6a 00                	push   $0x0
  8027cb:	6a 00                	push   $0x0
  8027cd:	6a 2c                	push   $0x2c
  8027cf:	e8 19 fa ff ff       	call   8021ed <syscall>
  8027d4:	83 c4 18             	add    $0x18,%esp
  8027d7:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  8027da:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  8027de:	75 07                	jne    8027e7 <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  8027e0:	b8 01 00 00 00       	mov    $0x1,%eax
  8027e5:	eb 05                	jmp    8027ec <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  8027e7:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8027ec:	c9                   	leave  
  8027ed:	c3                   	ret    

008027ee <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  8027ee:	55                   	push   %ebp
  8027ef:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  8027f1:	6a 00                	push   $0x0
  8027f3:	6a 00                	push   $0x0
  8027f5:	6a 00                	push   $0x0
  8027f7:	6a 00                	push   $0x0
  8027f9:	ff 75 08             	pushl  0x8(%ebp)
  8027fc:	6a 2d                	push   $0x2d
  8027fe:	e8 ea f9 ff ff       	call   8021ed <syscall>
  802803:	83 c4 18             	add    $0x18,%esp
	return ;
  802806:	90                   	nop
}
  802807:	c9                   	leave  
  802808:	c3                   	ret    

00802809 <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  802809:	55                   	push   %ebp
  80280a:	89 e5                	mov    %esp,%ebp
  80280c:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  80280d:	8b 5d 14             	mov    0x14(%ebp),%ebx
  802810:	8b 4d 10             	mov    0x10(%ebp),%ecx
  802813:	8b 55 0c             	mov    0xc(%ebp),%edx
  802816:	8b 45 08             	mov    0x8(%ebp),%eax
  802819:	6a 00                	push   $0x0
  80281b:	53                   	push   %ebx
  80281c:	51                   	push   %ecx
  80281d:	52                   	push   %edx
  80281e:	50                   	push   %eax
  80281f:	6a 2e                	push   $0x2e
  802821:	e8 c7 f9 ff ff       	call   8021ed <syscall>
  802826:	83 c4 18             	add    $0x18,%esp
}
  802829:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80282c:	c9                   	leave  
  80282d:	c3                   	ret    

0080282e <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  80282e:	55                   	push   %ebp
  80282f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  802831:	8b 55 0c             	mov    0xc(%ebp),%edx
  802834:	8b 45 08             	mov    0x8(%ebp),%eax
  802837:	6a 00                	push   $0x0
  802839:	6a 00                	push   $0x0
  80283b:	6a 00                	push   $0x0
  80283d:	52                   	push   %edx
  80283e:	50                   	push   %eax
  80283f:	6a 2f                	push   $0x2f
  802841:	e8 a7 f9 ff ff       	call   8021ed <syscall>
  802846:	83 c4 18             	add    $0x18,%esp
}
  802849:	c9                   	leave  
  80284a:	c3                   	ret    

0080284b <print_mem_block_lists>:
//===========================
// PRINT MEM BLOCK LISTS:
//===========================

void print_mem_block_lists()
{
  80284b:	55                   	push   %ebp
  80284c:	89 e5                	mov    %esp,%ebp
  80284e:	83 ec 18             	sub    $0x18,%esp
	cprintf("\n=========================================\n");
  802851:	83 ec 0c             	sub    $0xc,%esp
  802854:	68 c0 45 80 00       	push   $0x8045c0
  802859:	e8 dd e6 ff ff       	call   800f3b <cprintf>
  80285e:	83 c4 10             	add    $0x10,%esp
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
  802861:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nFreeMemBlocksList:\n");
  802868:	83 ec 0c             	sub    $0xc,%esp
  80286b:	68 ec 45 80 00       	push   $0x8045ec
  802870:	e8 c6 e6 ff ff       	call   800f3b <cprintf>
  802875:	83 c4 10             	add    $0x10,%esp
	uint8 sorted = 1 ;
  802878:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &FreeMemBlocksList)
  80287c:	a1 38 51 80 00       	mov    0x805138,%eax
  802881:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802884:	eb 56                	jmp    8028dc <print_mem_block_lists+0x91>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  802886:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80288a:	74 1c                	je     8028a8 <print_mem_block_lists+0x5d>
  80288c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80288f:	8b 50 08             	mov    0x8(%eax),%edx
  802892:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802895:	8b 48 08             	mov    0x8(%eax),%ecx
  802898:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80289b:	8b 40 0c             	mov    0xc(%eax),%eax
  80289e:	01 c8                	add    %ecx,%eax
  8028a0:	39 c2                	cmp    %eax,%edx
  8028a2:	73 04                	jae    8028a8 <print_mem_block_lists+0x5d>
			sorted = 0 ;
  8028a4:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  8028a8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028ab:	8b 50 08             	mov    0x8(%eax),%edx
  8028ae:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028b1:	8b 40 0c             	mov    0xc(%eax),%eax
  8028b4:	01 c2                	add    %eax,%edx
  8028b6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028b9:	8b 40 08             	mov    0x8(%eax),%eax
  8028bc:	83 ec 04             	sub    $0x4,%esp
  8028bf:	52                   	push   %edx
  8028c0:	50                   	push   %eax
  8028c1:	68 01 46 80 00       	push   $0x804601
  8028c6:	e8 70 e6 ff ff       	call   800f3b <cprintf>
  8028cb:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  8028ce:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028d1:	89 45 f0             	mov    %eax,-0x10(%ebp)
	cprintf("\n=========================================\n");
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
	cprintf("\nFreeMemBlocksList:\n");
	uint8 sorted = 1 ;
	LIST_FOREACH(blk, &FreeMemBlocksList)
  8028d4:	a1 40 51 80 00       	mov    0x805140,%eax
  8028d9:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8028dc:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8028e0:	74 07                	je     8028e9 <print_mem_block_lists+0x9e>
  8028e2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028e5:	8b 00                	mov    (%eax),%eax
  8028e7:	eb 05                	jmp    8028ee <print_mem_block_lists+0xa3>
  8028e9:	b8 00 00 00 00       	mov    $0x0,%eax
  8028ee:	a3 40 51 80 00       	mov    %eax,0x805140
  8028f3:	a1 40 51 80 00       	mov    0x805140,%eax
  8028f8:	85 c0                	test   %eax,%eax
  8028fa:	75 8a                	jne    802886 <print_mem_block_lists+0x3b>
  8028fc:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802900:	75 84                	jne    802886 <print_mem_block_lists+0x3b>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;
  802902:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  802906:	75 10                	jne    802918 <print_mem_block_lists+0xcd>
  802908:	83 ec 0c             	sub    $0xc,%esp
  80290b:	68 10 46 80 00       	push   $0x804610
  802910:	e8 26 e6 ff ff       	call   800f3b <cprintf>
  802915:	83 c4 10             	add    $0x10,%esp

	lastBlk = NULL ;
  802918:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nAllocMemBlocksList:\n");
  80291f:	83 ec 0c             	sub    $0xc,%esp
  802922:	68 34 46 80 00       	push   $0x804634
  802927:	e8 0f e6 ff ff       	call   800f3b <cprintf>
  80292c:	83 c4 10             	add    $0x10,%esp
	sorted = 1 ;
  80292f:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &AllocMemBlocksList)
  802933:	a1 40 50 80 00       	mov    0x805040,%eax
  802938:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80293b:	eb 56                	jmp    802993 <print_mem_block_lists+0x148>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  80293d:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802941:	74 1c                	je     80295f <print_mem_block_lists+0x114>
  802943:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802946:	8b 50 08             	mov    0x8(%eax),%edx
  802949:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80294c:	8b 48 08             	mov    0x8(%eax),%ecx
  80294f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802952:	8b 40 0c             	mov    0xc(%eax),%eax
  802955:	01 c8                	add    %ecx,%eax
  802957:	39 c2                	cmp    %eax,%edx
  802959:	73 04                	jae    80295f <print_mem_block_lists+0x114>
			sorted = 0 ;
  80295b:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  80295f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802962:	8b 50 08             	mov    0x8(%eax),%edx
  802965:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802968:	8b 40 0c             	mov    0xc(%eax),%eax
  80296b:	01 c2                	add    %eax,%edx
  80296d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802970:	8b 40 08             	mov    0x8(%eax),%eax
  802973:	83 ec 04             	sub    $0x4,%esp
  802976:	52                   	push   %edx
  802977:	50                   	push   %eax
  802978:	68 01 46 80 00       	push   $0x804601
  80297d:	e8 b9 e5 ff ff       	call   800f3b <cprintf>
  802982:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  802985:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802988:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;

	lastBlk = NULL ;
	cprintf("\nAllocMemBlocksList:\n");
	sorted = 1 ;
	LIST_FOREACH(blk, &AllocMemBlocksList)
  80298b:	a1 48 50 80 00       	mov    0x805048,%eax
  802990:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802993:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802997:	74 07                	je     8029a0 <print_mem_block_lists+0x155>
  802999:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80299c:	8b 00                	mov    (%eax),%eax
  80299e:	eb 05                	jmp    8029a5 <print_mem_block_lists+0x15a>
  8029a0:	b8 00 00 00 00       	mov    $0x0,%eax
  8029a5:	a3 48 50 80 00       	mov    %eax,0x805048
  8029aa:	a1 48 50 80 00       	mov    0x805048,%eax
  8029af:	85 c0                	test   %eax,%eax
  8029b1:	75 8a                	jne    80293d <print_mem_block_lists+0xf2>
  8029b3:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8029b7:	75 84                	jne    80293d <print_mem_block_lists+0xf2>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nAllocMemBlocksList is NOT SORTED!!\n") ;
  8029b9:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  8029bd:	75 10                	jne    8029cf <print_mem_block_lists+0x184>
  8029bf:	83 ec 0c             	sub    $0xc,%esp
  8029c2:	68 4c 46 80 00       	push   $0x80464c
  8029c7:	e8 6f e5 ff ff       	call   800f3b <cprintf>
  8029cc:	83 c4 10             	add    $0x10,%esp
	cprintf("\n=========================================\n");
  8029cf:	83 ec 0c             	sub    $0xc,%esp
  8029d2:	68 c0 45 80 00       	push   $0x8045c0
  8029d7:	e8 5f e5 ff ff       	call   800f3b <cprintf>
  8029dc:	83 c4 10             	add    $0x10,%esp

}
  8029df:	90                   	nop
  8029e0:	c9                   	leave  
  8029e1:	c3                   	ret    

008029e2 <initialize_MemBlocksList>:

//===============================
// [1] INITIALIZE AVAILABLE LIST:
//===============================
void initialize_MemBlocksList(uint32 numOfBlocks)
{
  8029e2:	55                   	push   %ebp
  8029e3:	89 e5                	mov    %esp,%ebp
  8029e5:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] initialize_MemBlocksList
	// Write your code here, remove the panic and write your code
	//panic("initialize_MemBlocksList() is not implemented yet...!!");
	uint32 n = numOfBlocks;
  8029e8:	8b 45 08             	mov    0x8(%ebp),%eax
  8029eb:	89 45 f0             	mov    %eax,-0x10(%ebp)

	LIST_INIT(&AvailableMemBlocksList);
  8029ee:	c7 05 48 51 80 00 00 	movl   $0x0,0x805148
  8029f5:	00 00 00 
  8029f8:	c7 05 4c 51 80 00 00 	movl   $0x0,0x80514c
  8029ff:	00 00 00 
  802a02:	c7 05 54 51 80 00 00 	movl   $0x0,0x805154
  802a09:	00 00 00 
	for(int i = 0; i<n;i++)
  802a0c:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  802a13:	e9 9e 00 00 00       	jmp    802ab6 <initialize_MemBlocksList+0xd4>
	{
		LIST_INSERT_HEAD(&AvailableMemBlocksList, &(MemBlockNodes[i]));
  802a18:	a1 50 50 80 00       	mov    0x805050,%eax
  802a1d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802a20:	c1 e2 04             	shl    $0x4,%edx
  802a23:	01 d0                	add    %edx,%eax
  802a25:	85 c0                	test   %eax,%eax
  802a27:	75 14                	jne    802a3d <initialize_MemBlocksList+0x5b>
  802a29:	83 ec 04             	sub    $0x4,%esp
  802a2c:	68 74 46 80 00       	push   $0x804674
  802a31:	6a 47                	push   $0x47
  802a33:	68 97 46 80 00       	push   $0x804697
  802a38:	e8 4a e2 ff ff       	call   800c87 <_panic>
  802a3d:	a1 50 50 80 00       	mov    0x805050,%eax
  802a42:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802a45:	c1 e2 04             	shl    $0x4,%edx
  802a48:	01 d0                	add    %edx,%eax
  802a4a:	8b 15 48 51 80 00    	mov    0x805148,%edx
  802a50:	89 10                	mov    %edx,(%eax)
  802a52:	8b 00                	mov    (%eax),%eax
  802a54:	85 c0                	test   %eax,%eax
  802a56:	74 18                	je     802a70 <initialize_MemBlocksList+0x8e>
  802a58:	a1 48 51 80 00       	mov    0x805148,%eax
  802a5d:	8b 15 50 50 80 00    	mov    0x805050,%edx
  802a63:	8b 4d f4             	mov    -0xc(%ebp),%ecx
  802a66:	c1 e1 04             	shl    $0x4,%ecx
  802a69:	01 ca                	add    %ecx,%edx
  802a6b:	89 50 04             	mov    %edx,0x4(%eax)
  802a6e:	eb 12                	jmp    802a82 <initialize_MemBlocksList+0xa0>
  802a70:	a1 50 50 80 00       	mov    0x805050,%eax
  802a75:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802a78:	c1 e2 04             	shl    $0x4,%edx
  802a7b:	01 d0                	add    %edx,%eax
  802a7d:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802a82:	a1 50 50 80 00       	mov    0x805050,%eax
  802a87:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802a8a:	c1 e2 04             	shl    $0x4,%edx
  802a8d:	01 d0                	add    %edx,%eax
  802a8f:	a3 48 51 80 00       	mov    %eax,0x805148
  802a94:	a1 50 50 80 00       	mov    0x805050,%eax
  802a99:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802a9c:	c1 e2 04             	shl    $0x4,%edx
  802a9f:	01 d0                	add    %edx,%eax
  802aa1:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802aa8:	a1 54 51 80 00       	mov    0x805154,%eax
  802aad:	40                   	inc    %eax
  802aae:	a3 54 51 80 00       	mov    %eax,0x805154
	// Write your code here, remove the panic and write your code
	//panic("initialize_MemBlocksList() is not implemented yet...!!");
	uint32 n = numOfBlocks;

	LIST_INIT(&AvailableMemBlocksList);
	for(int i = 0; i<n;i++)
  802ab3:	ff 45 f4             	incl   -0xc(%ebp)
  802ab6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ab9:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  802abc:	0f 82 56 ff ff ff    	jb     802a18 <initialize_MemBlocksList+0x36>
	{
		LIST_INSERT_HEAD(&AvailableMemBlocksList, &(MemBlockNodes[i]));
	}
}
  802ac2:	90                   	nop
  802ac3:	c9                   	leave  
  802ac4:	c3                   	ret    

00802ac5 <find_block>:

//===============================
// [2] FIND BLOCK:
//===============================
struct MemBlock *find_block(struct MemBlock_List *blockList, uint32 va)
{
  802ac5:	55                   	push   %ebp
  802ac6:	89 e5                	mov    %esp,%ebp
  802ac8:	83 ec 10             	sub    $0x10,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] find_block
	// Write your code here, remove the panic and write your code
	//panic("find_block() is not implemented yet...!!");
	uint32 virAddress = va;
  802acb:	8b 45 0c             	mov    0xc(%ebp),%eax
  802ace:	89 45 f4             	mov    %eax,-0xc(%ebp)
	struct MemBlock* blk;
	int found = 0;
  802ad1:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	LIST_FOREACH(blk, &(AllocMemBlocksList))
  802ad8:	a1 40 50 80 00       	mov    0x805040,%eax
  802add:	89 45 fc             	mov    %eax,-0x4(%ebp)
  802ae0:	eb 23                	jmp    802b05 <find_block+0x40>
	{
		if(blk->sva == virAddress)
  802ae2:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802ae5:	8b 40 08             	mov    0x8(%eax),%eax
  802ae8:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  802aeb:	75 09                	jne    802af6 <find_block+0x31>
		{
			found = 1;
  802aed:	c7 45 f8 01 00 00 00 	movl   $0x1,-0x8(%ebp)
			break;
  802af4:	eb 35                	jmp    802b2b <find_block+0x66>
		}
		else
		{
			found = 0;
  802af6:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	//panic("find_block() is not implemented yet...!!");
	uint32 virAddress = va;
	struct MemBlock* blk;
	int found = 0;

	LIST_FOREACH(blk, &(AllocMemBlocksList))
  802afd:	a1 48 50 80 00       	mov    0x805048,%eax
  802b02:	89 45 fc             	mov    %eax,-0x4(%ebp)
  802b05:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  802b09:	74 07                	je     802b12 <find_block+0x4d>
  802b0b:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802b0e:	8b 00                	mov    (%eax),%eax
  802b10:	eb 05                	jmp    802b17 <find_block+0x52>
  802b12:	b8 00 00 00 00       	mov    $0x0,%eax
  802b17:	a3 48 50 80 00       	mov    %eax,0x805048
  802b1c:	a1 48 50 80 00       	mov    0x805048,%eax
  802b21:	85 c0                	test   %eax,%eax
  802b23:	75 bd                	jne    802ae2 <find_block+0x1d>
  802b25:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  802b29:	75 b7                	jne    802ae2 <find_block+0x1d>
		{
			found = 0;
			continue;
		}
	}
	if(found == 1)
  802b2b:	83 7d f8 01          	cmpl   $0x1,-0x8(%ebp)
  802b2f:	75 05                	jne    802b36 <find_block+0x71>
	{
		return blk;
  802b31:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802b34:	eb 05                	jmp    802b3b <find_block+0x76>
	}
	else
	{
		return NULL;
  802b36:	b8 00 00 00 00       	mov    $0x0,%eax
	}
}
  802b3b:	c9                   	leave  
  802b3c:	c3                   	ret    

00802b3d <insert_sorted_allocList>:

//=========================================
// [3] INSERT BLOCK IN ALLOC LIST [SORTED]:
//=========================================
void insert_sorted_allocList(struct MemBlock *blockToInsert)
{
  802b3d:	55                   	push   %ebp
  802b3e:	89 e5                	mov    %esp,%ebp
  802b40:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] insert_sorted_allocList
	// Write your code here, remove the panic and write your code
	//panic("insert_sorted_allocList() is not implemented yet...!!");
	struct MemBlock* blk;
	struct MemBlock* newblk = blockToInsert;
  802b43:	8b 45 08             	mov    0x8(%ebp),%eax
  802b46:	89 45 f0             	mov    %eax,-0x10(%ebp)

	if((LIST_EMPTY(&AllocMemBlocksList)) || (newblk->sva < LIST_FIRST(&AllocMemBlocksList)->sva))
  802b49:	a1 40 50 80 00       	mov    0x805040,%eax
  802b4e:	85 c0                	test   %eax,%eax
  802b50:	74 12                	je     802b64 <insert_sorted_allocList+0x27>
  802b52:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b55:	8b 50 08             	mov    0x8(%eax),%edx
  802b58:	a1 40 50 80 00       	mov    0x805040,%eax
  802b5d:	8b 40 08             	mov    0x8(%eax),%eax
  802b60:	39 c2                	cmp    %eax,%edx
  802b62:	73 65                	jae    802bc9 <insert_sorted_allocList+0x8c>
	{
		LIST_INSERT_HEAD(&(AllocMemBlocksList), newblk);
  802b64:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802b68:	75 14                	jne    802b7e <insert_sorted_allocList+0x41>
  802b6a:	83 ec 04             	sub    $0x4,%esp
  802b6d:	68 74 46 80 00       	push   $0x804674
  802b72:	6a 7b                	push   $0x7b
  802b74:	68 97 46 80 00       	push   $0x804697
  802b79:	e8 09 e1 ff ff       	call   800c87 <_panic>
  802b7e:	8b 15 40 50 80 00    	mov    0x805040,%edx
  802b84:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b87:	89 10                	mov    %edx,(%eax)
  802b89:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b8c:	8b 00                	mov    (%eax),%eax
  802b8e:	85 c0                	test   %eax,%eax
  802b90:	74 0d                	je     802b9f <insert_sorted_allocList+0x62>
  802b92:	a1 40 50 80 00       	mov    0x805040,%eax
  802b97:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802b9a:	89 50 04             	mov    %edx,0x4(%eax)
  802b9d:	eb 08                	jmp    802ba7 <insert_sorted_allocList+0x6a>
  802b9f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802ba2:	a3 44 50 80 00       	mov    %eax,0x805044
  802ba7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802baa:	a3 40 50 80 00       	mov    %eax,0x805040
  802baf:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802bb2:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802bb9:	a1 4c 50 80 00       	mov    0x80504c,%eax
  802bbe:	40                   	inc    %eax
  802bbf:	a3 4c 50 80 00       	mov    %eax,0x80504c
  802bc4:	e9 5f 01 00 00       	jmp    802d28 <insert_sorted_allocList+0x1eb>
	}
	else if(newblk->sva > LIST_LAST(&AllocMemBlocksList)->sva)
  802bc9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802bcc:	8b 50 08             	mov    0x8(%eax),%edx
  802bcf:	a1 44 50 80 00       	mov    0x805044,%eax
  802bd4:	8b 40 08             	mov    0x8(%eax),%eax
  802bd7:	39 c2                	cmp    %eax,%edx
  802bd9:	76 65                	jbe    802c40 <insert_sorted_allocList+0x103>
	{
		LIST_INSERT_TAIL(&AllocMemBlocksList, newblk);
  802bdb:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802bdf:	75 14                	jne    802bf5 <insert_sorted_allocList+0xb8>
  802be1:	83 ec 04             	sub    $0x4,%esp
  802be4:	68 b0 46 80 00       	push   $0x8046b0
  802be9:	6a 7f                	push   $0x7f
  802beb:	68 97 46 80 00       	push   $0x804697
  802bf0:	e8 92 e0 ff ff       	call   800c87 <_panic>
  802bf5:	8b 15 44 50 80 00    	mov    0x805044,%edx
  802bfb:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802bfe:	89 50 04             	mov    %edx,0x4(%eax)
  802c01:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c04:	8b 40 04             	mov    0x4(%eax),%eax
  802c07:	85 c0                	test   %eax,%eax
  802c09:	74 0c                	je     802c17 <insert_sorted_allocList+0xda>
  802c0b:	a1 44 50 80 00       	mov    0x805044,%eax
  802c10:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802c13:	89 10                	mov    %edx,(%eax)
  802c15:	eb 08                	jmp    802c1f <insert_sorted_allocList+0xe2>
  802c17:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c1a:	a3 40 50 80 00       	mov    %eax,0x805040
  802c1f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c22:	a3 44 50 80 00       	mov    %eax,0x805044
  802c27:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c2a:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802c30:	a1 4c 50 80 00       	mov    0x80504c,%eax
  802c35:	40                   	inc    %eax
  802c36:	a3 4c 50 80 00       	mov    %eax,0x80504c
				LIST_INSERT_AFTER(&AllocMemBlocksList, blk, newblk);
				break;
			}
		}
	}
}
  802c3b:	e9 e8 00 00 00       	jmp    802d28 <insert_sorted_allocList+0x1eb>
	{
		LIST_INSERT_TAIL(&AllocMemBlocksList, newblk);
	}
	else
	{
		LIST_FOREACH(blk, &AllocMemBlocksList)
  802c40:	a1 40 50 80 00       	mov    0x805040,%eax
  802c45:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802c48:	e9 ab 00 00 00       	jmp    802cf8 <insert_sorted_allocList+0x1bb>
		{
			if(blk->prev_next_info.le_next != NULL && newblk->sva > blk->sva  && newblk->sva < blk->prev_next_info.le_next->sva)
  802c4d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c50:	8b 00                	mov    (%eax),%eax
  802c52:	85 c0                	test   %eax,%eax
  802c54:	0f 84 96 00 00 00    	je     802cf0 <insert_sorted_allocList+0x1b3>
  802c5a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c5d:	8b 50 08             	mov    0x8(%eax),%edx
  802c60:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c63:	8b 40 08             	mov    0x8(%eax),%eax
  802c66:	39 c2                	cmp    %eax,%edx
  802c68:	0f 86 82 00 00 00    	jbe    802cf0 <insert_sorted_allocList+0x1b3>
  802c6e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c71:	8b 50 08             	mov    0x8(%eax),%edx
  802c74:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c77:	8b 00                	mov    (%eax),%eax
  802c79:	8b 40 08             	mov    0x8(%eax),%eax
  802c7c:	39 c2                	cmp    %eax,%edx
  802c7e:	73 70                	jae    802cf0 <insert_sorted_allocList+0x1b3>
			{
				LIST_INSERT_AFTER(&AllocMemBlocksList, blk, newblk);
  802c80:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802c84:	74 06                	je     802c8c <insert_sorted_allocList+0x14f>
  802c86:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802c8a:	75 17                	jne    802ca3 <insert_sorted_allocList+0x166>
  802c8c:	83 ec 04             	sub    $0x4,%esp
  802c8f:	68 d4 46 80 00       	push   $0x8046d4
  802c94:	68 87 00 00 00       	push   $0x87
  802c99:	68 97 46 80 00       	push   $0x804697
  802c9e:	e8 e4 df ff ff       	call   800c87 <_panic>
  802ca3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ca6:	8b 10                	mov    (%eax),%edx
  802ca8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802cab:	89 10                	mov    %edx,(%eax)
  802cad:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802cb0:	8b 00                	mov    (%eax),%eax
  802cb2:	85 c0                	test   %eax,%eax
  802cb4:	74 0b                	je     802cc1 <insert_sorted_allocList+0x184>
  802cb6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cb9:	8b 00                	mov    (%eax),%eax
  802cbb:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802cbe:	89 50 04             	mov    %edx,0x4(%eax)
  802cc1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cc4:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802cc7:	89 10                	mov    %edx,(%eax)
  802cc9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802ccc:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802ccf:	89 50 04             	mov    %edx,0x4(%eax)
  802cd2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802cd5:	8b 00                	mov    (%eax),%eax
  802cd7:	85 c0                	test   %eax,%eax
  802cd9:	75 08                	jne    802ce3 <insert_sorted_allocList+0x1a6>
  802cdb:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802cde:	a3 44 50 80 00       	mov    %eax,0x805044
  802ce3:	a1 4c 50 80 00       	mov    0x80504c,%eax
  802ce8:	40                   	inc    %eax
  802ce9:	a3 4c 50 80 00       	mov    %eax,0x80504c
				break;
  802cee:	eb 38                	jmp    802d28 <insert_sorted_allocList+0x1eb>
	{
		LIST_INSERT_TAIL(&AllocMemBlocksList, newblk);
	}
	else
	{
		LIST_FOREACH(blk, &AllocMemBlocksList)
  802cf0:	a1 48 50 80 00       	mov    0x805048,%eax
  802cf5:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802cf8:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802cfc:	74 07                	je     802d05 <insert_sorted_allocList+0x1c8>
  802cfe:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d01:	8b 00                	mov    (%eax),%eax
  802d03:	eb 05                	jmp    802d0a <insert_sorted_allocList+0x1cd>
  802d05:	b8 00 00 00 00       	mov    $0x0,%eax
  802d0a:	a3 48 50 80 00       	mov    %eax,0x805048
  802d0f:	a1 48 50 80 00       	mov    0x805048,%eax
  802d14:	85 c0                	test   %eax,%eax
  802d16:	0f 85 31 ff ff ff    	jne    802c4d <insert_sorted_allocList+0x110>
  802d1c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802d20:	0f 85 27 ff ff ff    	jne    802c4d <insert_sorted_allocList+0x110>
				LIST_INSERT_AFTER(&AllocMemBlocksList, blk, newblk);
				break;
			}
		}
	}
}
  802d26:	eb 00                	jmp    802d28 <insert_sorted_allocList+0x1eb>
  802d28:	90                   	nop
  802d29:	c9                   	leave  
  802d2a:	c3                   	ret    

00802d2b <alloc_block_FF>:

//=========================================
// [4] ALLOCATE BLOCK BY FIRST FIT:
//=========================================
struct MemBlock *alloc_block_FF(uint32 size)
{
  802d2b:	55                   	push   %ebp
  802d2c:	89 e5                	mov    %esp,%ebp
  802d2e:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_FF
	// Write your code here, remove the panic and write your code
	//panic("alloc_block_FF() is not implemented yet...!!");
	uint32 versize = size;
  802d31:	8b 45 08             	mov    0x8(%ebp),%eax
  802d34:	89 45 f0             	mov    %eax,-0x10(%ebp)
	struct MemBlock* blk;
	struct MemBlock* newblk = LIST_FIRST(&AvailableMemBlocksList);
  802d37:	a1 48 51 80 00       	mov    0x805148,%eax
  802d3c:	89 45 ec             	mov    %eax,-0x14(%ebp)

	LIST_FOREACH(blk,&FreeMemBlocksList)
  802d3f:	a1 38 51 80 00       	mov    0x805138,%eax
  802d44:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802d47:	e9 77 01 00 00       	jmp    802ec3 <alloc_block_FF+0x198>
	{
		if(blk->size == versize)
  802d4c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d4f:	8b 40 0c             	mov    0xc(%eax),%eax
  802d52:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  802d55:	0f 85 8a 00 00 00    	jne    802de5 <alloc_block_FF+0xba>
		{
			LIST_REMOVE(&FreeMemBlocksList,blk);
  802d5b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802d5f:	75 17                	jne    802d78 <alloc_block_FF+0x4d>
  802d61:	83 ec 04             	sub    $0x4,%esp
  802d64:	68 08 47 80 00       	push   $0x804708
  802d69:	68 9e 00 00 00       	push   $0x9e
  802d6e:	68 97 46 80 00       	push   $0x804697
  802d73:	e8 0f df ff ff       	call   800c87 <_panic>
  802d78:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d7b:	8b 00                	mov    (%eax),%eax
  802d7d:	85 c0                	test   %eax,%eax
  802d7f:	74 10                	je     802d91 <alloc_block_FF+0x66>
  802d81:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d84:	8b 00                	mov    (%eax),%eax
  802d86:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802d89:	8b 52 04             	mov    0x4(%edx),%edx
  802d8c:	89 50 04             	mov    %edx,0x4(%eax)
  802d8f:	eb 0b                	jmp    802d9c <alloc_block_FF+0x71>
  802d91:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d94:	8b 40 04             	mov    0x4(%eax),%eax
  802d97:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802d9c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d9f:	8b 40 04             	mov    0x4(%eax),%eax
  802da2:	85 c0                	test   %eax,%eax
  802da4:	74 0f                	je     802db5 <alloc_block_FF+0x8a>
  802da6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802da9:	8b 40 04             	mov    0x4(%eax),%eax
  802dac:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802daf:	8b 12                	mov    (%edx),%edx
  802db1:	89 10                	mov    %edx,(%eax)
  802db3:	eb 0a                	jmp    802dbf <alloc_block_FF+0x94>
  802db5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802db8:	8b 00                	mov    (%eax),%eax
  802dba:	a3 38 51 80 00       	mov    %eax,0x805138
  802dbf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802dc2:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802dc8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802dcb:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802dd2:	a1 44 51 80 00       	mov    0x805144,%eax
  802dd7:	48                   	dec    %eax
  802dd8:	a3 44 51 80 00       	mov    %eax,0x805144
			return blk;
  802ddd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802de0:	e9 11 01 00 00       	jmp    802ef6 <alloc_block_FF+0x1cb>
		}
		else if(blk->size > versize)
  802de5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802de8:	8b 40 0c             	mov    0xc(%eax),%eax
  802deb:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  802dee:	0f 86 c7 00 00 00    	jbe    802ebb <alloc_block_FF+0x190>
		{
			LIST_REMOVE(&AvailableMemBlocksList,newblk);
  802df4:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802df8:	75 17                	jne    802e11 <alloc_block_FF+0xe6>
  802dfa:	83 ec 04             	sub    $0x4,%esp
  802dfd:	68 08 47 80 00       	push   $0x804708
  802e02:	68 a3 00 00 00       	push   $0xa3
  802e07:	68 97 46 80 00       	push   $0x804697
  802e0c:	e8 76 de ff ff       	call   800c87 <_panic>
  802e11:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802e14:	8b 00                	mov    (%eax),%eax
  802e16:	85 c0                	test   %eax,%eax
  802e18:	74 10                	je     802e2a <alloc_block_FF+0xff>
  802e1a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802e1d:	8b 00                	mov    (%eax),%eax
  802e1f:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802e22:	8b 52 04             	mov    0x4(%edx),%edx
  802e25:	89 50 04             	mov    %edx,0x4(%eax)
  802e28:	eb 0b                	jmp    802e35 <alloc_block_FF+0x10a>
  802e2a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802e2d:	8b 40 04             	mov    0x4(%eax),%eax
  802e30:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802e35:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802e38:	8b 40 04             	mov    0x4(%eax),%eax
  802e3b:	85 c0                	test   %eax,%eax
  802e3d:	74 0f                	je     802e4e <alloc_block_FF+0x123>
  802e3f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802e42:	8b 40 04             	mov    0x4(%eax),%eax
  802e45:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802e48:	8b 12                	mov    (%edx),%edx
  802e4a:	89 10                	mov    %edx,(%eax)
  802e4c:	eb 0a                	jmp    802e58 <alloc_block_FF+0x12d>
  802e4e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802e51:	8b 00                	mov    (%eax),%eax
  802e53:	a3 48 51 80 00       	mov    %eax,0x805148
  802e58:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802e5b:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802e61:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802e64:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802e6b:	a1 54 51 80 00       	mov    0x805154,%eax
  802e70:	48                   	dec    %eax
  802e71:	a3 54 51 80 00       	mov    %eax,0x805154
			newblk->size = versize;
  802e76:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802e79:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802e7c:	89 50 0c             	mov    %edx,0xc(%eax)
			blk->size = blk->size-versize;
  802e7f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e82:	8b 40 0c             	mov    0xc(%eax),%eax
  802e85:	2b 45 f0             	sub    -0x10(%ebp),%eax
  802e88:	89 c2                	mov    %eax,%edx
  802e8a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e8d:	89 50 0c             	mov    %edx,0xc(%eax)
			uint32 newveradd = blk->sva;
  802e90:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e93:	8b 40 08             	mov    0x8(%eax),%eax
  802e96:	89 45 e8             	mov    %eax,-0x18(%ebp)
			blk->sva+=newblk->size;
  802e99:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e9c:	8b 50 08             	mov    0x8(%eax),%edx
  802e9f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802ea2:	8b 40 0c             	mov    0xc(%eax),%eax
  802ea5:	01 c2                	add    %eax,%edx
  802ea7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802eaa:	89 50 08             	mov    %edx,0x8(%eax)
			newblk->sva = newveradd;
  802ead:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802eb0:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802eb3:	89 50 08             	mov    %edx,0x8(%eax)
			return newblk;
  802eb6:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802eb9:	eb 3b                	jmp    802ef6 <alloc_block_FF+0x1cb>
	//panic("alloc_block_FF() is not implemented yet...!!");
	uint32 versize = size;
	struct MemBlock* blk;
	struct MemBlock* newblk = LIST_FIRST(&AvailableMemBlocksList);

	LIST_FOREACH(blk,&FreeMemBlocksList)
  802ebb:	a1 40 51 80 00       	mov    0x805140,%eax
  802ec0:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802ec3:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802ec7:	74 07                	je     802ed0 <alloc_block_FF+0x1a5>
  802ec9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ecc:	8b 00                	mov    (%eax),%eax
  802ece:	eb 05                	jmp    802ed5 <alloc_block_FF+0x1aa>
  802ed0:	b8 00 00 00 00       	mov    $0x0,%eax
  802ed5:	a3 40 51 80 00       	mov    %eax,0x805140
  802eda:	a1 40 51 80 00       	mov    0x805140,%eax
  802edf:	85 c0                	test   %eax,%eax
  802ee1:	0f 85 65 fe ff ff    	jne    802d4c <alloc_block_FF+0x21>
  802ee7:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802eeb:	0f 85 5b fe ff ff    	jne    802d4c <alloc_block_FF+0x21>
			blk->sva+=newblk->size;
			newblk->sva = newveradd;
			return newblk;
		}
	}
	return NULL;
  802ef1:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802ef6:	c9                   	leave  
  802ef7:	c3                   	ret    

00802ef8 <alloc_block_BF>:

//=========================================
// [5] ALLOCATE BLOCK BY BEST FIT:
//=========================================
struct MemBlock *alloc_block_BF(uint32 size)
{
  802ef8:	55                   	push   %ebp
  802ef9:	89 e5                	mov    %esp,%ebp
  802efb:	83 ec 28             	sub    $0x28,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_BF
	// Write your code here, remove the panic and write your code
	//panic("alloc_block_BF() is not implemented yet...!!");
	uint32 versize=size;
  802efe:	8b 45 08             	mov    0x8(%ebp),%eax
  802f01:	89 45 e8             	mov    %eax,-0x18(%ebp)
	struct MemBlock* blk;
	struct MemBlock* newblk=LIST_FIRST(&AvailableMemBlocksList);
  802f04:	a1 48 51 80 00       	mov    0x805148,%eax
  802f09:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	uint32 newveradd;
	uint32 newsize;
	int size_free = LIST_SIZE(&FreeMemBlocksList);
  802f0c:	a1 44 51 80 00       	mov    0x805144,%eax
  802f11:	89 45 e0             	mov    %eax,-0x20(%ebp)

	LIST_FOREACH(blk, &FreeMemBlocksList)
  802f14:	a1 38 51 80 00       	mov    0x805138,%eax
  802f19:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802f1c:	e9 a1 00 00 00       	jmp    802fc2 <alloc_block_BF+0xca>
	{
		if(blk->size == versize)
  802f21:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f24:	8b 40 0c             	mov    0xc(%eax),%eax
  802f27:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  802f2a:	0f 85 8a 00 00 00    	jne    802fba <alloc_block_BF+0xc2>
		{
			LIST_REMOVE(&FreeMemBlocksList, blk);
  802f30:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802f34:	75 17                	jne    802f4d <alloc_block_BF+0x55>
  802f36:	83 ec 04             	sub    $0x4,%esp
  802f39:	68 08 47 80 00       	push   $0x804708
  802f3e:	68 c2 00 00 00       	push   $0xc2
  802f43:	68 97 46 80 00       	push   $0x804697
  802f48:	e8 3a dd ff ff       	call   800c87 <_panic>
  802f4d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f50:	8b 00                	mov    (%eax),%eax
  802f52:	85 c0                	test   %eax,%eax
  802f54:	74 10                	je     802f66 <alloc_block_BF+0x6e>
  802f56:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f59:	8b 00                	mov    (%eax),%eax
  802f5b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802f5e:	8b 52 04             	mov    0x4(%edx),%edx
  802f61:	89 50 04             	mov    %edx,0x4(%eax)
  802f64:	eb 0b                	jmp    802f71 <alloc_block_BF+0x79>
  802f66:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f69:	8b 40 04             	mov    0x4(%eax),%eax
  802f6c:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802f71:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f74:	8b 40 04             	mov    0x4(%eax),%eax
  802f77:	85 c0                	test   %eax,%eax
  802f79:	74 0f                	je     802f8a <alloc_block_BF+0x92>
  802f7b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f7e:	8b 40 04             	mov    0x4(%eax),%eax
  802f81:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802f84:	8b 12                	mov    (%edx),%edx
  802f86:	89 10                	mov    %edx,(%eax)
  802f88:	eb 0a                	jmp    802f94 <alloc_block_BF+0x9c>
  802f8a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f8d:	8b 00                	mov    (%eax),%eax
  802f8f:	a3 38 51 80 00       	mov    %eax,0x805138
  802f94:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f97:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802f9d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802fa0:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802fa7:	a1 44 51 80 00       	mov    0x805144,%eax
  802fac:	48                   	dec    %eax
  802fad:	a3 44 51 80 00       	mov    %eax,0x805144
			return blk;
  802fb2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802fb5:	e9 11 02 00 00       	jmp    8031cb <alloc_block_BF+0x2d3>
	struct MemBlock* newblk=LIST_FIRST(&AvailableMemBlocksList);
	uint32 newveradd;
	uint32 newsize;
	int size_free = LIST_SIZE(&FreeMemBlocksList);

	LIST_FOREACH(blk, &FreeMemBlocksList)
  802fba:	a1 40 51 80 00       	mov    0x805140,%eax
  802fbf:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802fc2:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802fc6:	74 07                	je     802fcf <alloc_block_BF+0xd7>
  802fc8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802fcb:	8b 00                	mov    (%eax),%eax
  802fcd:	eb 05                	jmp    802fd4 <alloc_block_BF+0xdc>
  802fcf:	b8 00 00 00 00       	mov    $0x0,%eax
  802fd4:	a3 40 51 80 00       	mov    %eax,0x805140
  802fd9:	a1 40 51 80 00       	mov    0x805140,%eax
  802fde:	85 c0                	test   %eax,%eax
  802fe0:	0f 85 3b ff ff ff    	jne    802f21 <alloc_block_BF+0x29>
  802fe6:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802fea:	0f 85 31 ff ff ff    	jne    802f21 <alloc_block_BF+0x29>
		{
			LIST_REMOVE(&FreeMemBlocksList, blk);
			return blk;
		}
	}
	LIST_FOREACH(blk, &FreeMemBlocksList)
  802ff0:	a1 38 51 80 00       	mov    0x805138,%eax
  802ff5:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802ff8:	eb 27                	jmp    803021 <alloc_block_BF+0x129>
	{
		if(blk->size > versize)
  802ffa:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ffd:	8b 40 0c             	mov    0xc(%eax),%eax
  803000:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  803003:	76 14                	jbe    803019 <alloc_block_BF+0x121>
		{
			newsize = blk->size;
  803005:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803008:	8b 40 0c             	mov    0xc(%eax),%eax
  80300b:	89 45 ec             	mov    %eax,-0x14(%ebp)
			newveradd = blk->sva;
  80300e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803011:	8b 40 08             	mov    0x8(%eax),%eax
  803014:	89 45 f0             	mov    %eax,-0x10(%ebp)
			break;
  803017:	eb 2e                	jmp    803047 <alloc_block_BF+0x14f>
		{
			LIST_REMOVE(&FreeMemBlocksList, blk);
			return blk;
		}
	}
	LIST_FOREACH(blk, &FreeMemBlocksList)
  803019:	a1 40 51 80 00       	mov    0x805140,%eax
  80301e:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803021:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803025:	74 07                	je     80302e <alloc_block_BF+0x136>
  803027:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80302a:	8b 00                	mov    (%eax),%eax
  80302c:	eb 05                	jmp    803033 <alloc_block_BF+0x13b>
  80302e:	b8 00 00 00 00       	mov    $0x0,%eax
  803033:	a3 40 51 80 00       	mov    %eax,0x805140
  803038:	a1 40 51 80 00       	mov    0x805140,%eax
  80303d:	85 c0                	test   %eax,%eax
  80303f:	75 b9                	jne    802ffa <alloc_block_BF+0x102>
  803041:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803045:	75 b3                	jne    802ffa <alloc_block_BF+0x102>
			newsize = blk->size;
			newveradd = blk->sva;
			break;
		}
	}
	LIST_FOREACH(blk, &FreeMemBlocksList)
  803047:	a1 38 51 80 00       	mov    0x805138,%eax
  80304c:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80304f:	eb 30                	jmp    803081 <alloc_block_BF+0x189>
	{
		if(newsize > blk->size && blk->size > versize)
  803051:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803054:	8b 40 0c             	mov    0xc(%eax),%eax
  803057:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  80305a:	73 1d                	jae    803079 <alloc_block_BF+0x181>
  80305c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80305f:	8b 40 0c             	mov    0xc(%eax),%eax
  803062:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  803065:	76 12                	jbe    803079 <alloc_block_BF+0x181>
		{
	       newsize = blk->size;
  803067:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80306a:	8b 40 0c             	mov    0xc(%eax),%eax
  80306d:	89 45 ec             	mov    %eax,-0x14(%ebp)
		   newveradd = blk->sva;
  803070:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803073:	8b 40 08             	mov    0x8(%eax),%eax
  803076:	89 45 f0             	mov    %eax,-0x10(%ebp)
			newsize = blk->size;
			newveradd = blk->sva;
			break;
		}
	}
	LIST_FOREACH(blk, &FreeMemBlocksList)
  803079:	a1 40 51 80 00       	mov    0x805140,%eax
  80307e:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803081:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803085:	74 07                	je     80308e <alloc_block_BF+0x196>
  803087:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80308a:	8b 00                	mov    (%eax),%eax
  80308c:	eb 05                	jmp    803093 <alloc_block_BF+0x19b>
  80308e:	b8 00 00 00 00       	mov    $0x0,%eax
  803093:	a3 40 51 80 00       	mov    %eax,0x805140
  803098:	a1 40 51 80 00       	mov    0x805140,%eax
  80309d:	85 c0                	test   %eax,%eax
  80309f:	75 b0                	jne    803051 <alloc_block_BF+0x159>
  8030a1:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8030a5:	75 aa                	jne    803051 <alloc_block_BF+0x159>
		{
	       newsize = blk->size;
		   newveradd = blk->sva;
		}
	}
	LIST_FOREACH(blk, &FreeMemBlocksList)
  8030a7:	a1 38 51 80 00       	mov    0x805138,%eax
  8030ac:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8030af:	e9 e4 00 00 00       	jmp    803198 <alloc_block_BF+0x2a0>
	{
		if(blk->size == newsize && blk->sva == newveradd)
  8030b4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030b7:	8b 40 0c             	mov    0xc(%eax),%eax
  8030ba:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  8030bd:	0f 85 cd 00 00 00    	jne    803190 <alloc_block_BF+0x298>
  8030c3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030c6:	8b 40 08             	mov    0x8(%eax),%eax
  8030c9:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8030cc:	0f 85 be 00 00 00    	jne    803190 <alloc_block_BF+0x298>
		{
			LIST_REMOVE(&AvailableMemBlocksList, newblk);
  8030d2:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8030d6:	75 17                	jne    8030ef <alloc_block_BF+0x1f7>
  8030d8:	83 ec 04             	sub    $0x4,%esp
  8030db:	68 08 47 80 00       	push   $0x804708
  8030e0:	68 db 00 00 00       	push   $0xdb
  8030e5:	68 97 46 80 00       	push   $0x804697
  8030ea:	e8 98 db ff ff       	call   800c87 <_panic>
  8030ef:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8030f2:	8b 00                	mov    (%eax),%eax
  8030f4:	85 c0                	test   %eax,%eax
  8030f6:	74 10                	je     803108 <alloc_block_BF+0x210>
  8030f8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8030fb:	8b 00                	mov    (%eax),%eax
  8030fd:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803100:	8b 52 04             	mov    0x4(%edx),%edx
  803103:	89 50 04             	mov    %edx,0x4(%eax)
  803106:	eb 0b                	jmp    803113 <alloc_block_BF+0x21b>
  803108:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80310b:	8b 40 04             	mov    0x4(%eax),%eax
  80310e:	a3 4c 51 80 00       	mov    %eax,0x80514c
  803113:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803116:	8b 40 04             	mov    0x4(%eax),%eax
  803119:	85 c0                	test   %eax,%eax
  80311b:	74 0f                	je     80312c <alloc_block_BF+0x234>
  80311d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803120:	8b 40 04             	mov    0x4(%eax),%eax
  803123:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803126:	8b 12                	mov    (%edx),%edx
  803128:	89 10                	mov    %edx,(%eax)
  80312a:	eb 0a                	jmp    803136 <alloc_block_BF+0x23e>
  80312c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80312f:	8b 00                	mov    (%eax),%eax
  803131:	a3 48 51 80 00       	mov    %eax,0x805148
  803136:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803139:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80313f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803142:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803149:	a1 54 51 80 00       	mov    0x805154,%eax
  80314e:	48                   	dec    %eax
  80314f:	a3 54 51 80 00       	mov    %eax,0x805154
			newblk->size = versize;
  803154:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803157:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80315a:	89 50 0c             	mov    %edx,0xc(%eax)
			newblk->sva = newveradd;
  80315d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803160:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803163:	89 50 08             	mov    %edx,0x8(%eax)
			blk->size = blk->size - versize;
  803166:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803169:	8b 40 0c             	mov    0xc(%eax),%eax
  80316c:	2b 45 e8             	sub    -0x18(%ebp),%eax
  80316f:	89 c2                	mov    %eax,%edx
  803171:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803174:	89 50 0c             	mov    %edx,0xc(%eax)
			blk->sva+= newblk->size;
  803177:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80317a:	8b 50 08             	mov    0x8(%eax),%edx
  80317d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803180:	8b 40 0c             	mov    0xc(%eax),%eax
  803183:	01 c2                	add    %eax,%edx
  803185:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803188:	89 50 08             	mov    %edx,0x8(%eax)
			return newblk;
  80318b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80318e:	eb 3b                	jmp    8031cb <alloc_block_BF+0x2d3>
		{
	       newsize = blk->size;
		   newveradd = blk->sva;
		}
	}
	LIST_FOREACH(blk, &FreeMemBlocksList)
  803190:	a1 40 51 80 00       	mov    0x805140,%eax
  803195:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803198:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80319c:	74 07                	je     8031a5 <alloc_block_BF+0x2ad>
  80319e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8031a1:	8b 00                	mov    (%eax),%eax
  8031a3:	eb 05                	jmp    8031aa <alloc_block_BF+0x2b2>
  8031a5:	b8 00 00 00 00       	mov    $0x0,%eax
  8031aa:	a3 40 51 80 00       	mov    %eax,0x805140
  8031af:	a1 40 51 80 00       	mov    0x805140,%eax
  8031b4:	85 c0                	test   %eax,%eax
  8031b6:	0f 85 f8 fe ff ff    	jne    8030b4 <alloc_block_BF+0x1bc>
  8031bc:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8031c0:	0f 85 ee fe ff ff    	jne    8030b4 <alloc_block_BF+0x1bc>
			blk->size = blk->size - versize;
			blk->sva+= newblk->size;
			return newblk;
		}
	}
	return NULL;
  8031c6:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8031cb:	c9                   	leave  
  8031cc:	c3                   	ret    

008031cd <alloc_block_NF>:
//=========================================
// [7] ALLOCATE BLOCK BY NEXT FIT:
//=========================================
struct MemBlock *last_allocate;
struct MemBlock *alloc_block_NF(uint32 size)
{
  8031cd:	55                   	push   %ebp
  8031ce:	89 e5                	mov    %esp,%ebp
  8031d0:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1 - BONUS] [DYNAMIC ALLOCATOR] alloc_block_NF
	// Write your code here, remove the panic and write your code
	//panic("alloc_block_NF() is not implemented yet...!!");
	uint32 versize = size;
  8031d3:	8b 45 08             	mov    0x8(%ebp),%eax
  8031d6:	89 45 f0             	mov    %eax,-0x10(%ebp)
	struct MemBlock* blk;
	struct MemBlock* newblk = LIST_FIRST(&AvailableMemBlocksList);
  8031d9:	a1 48 51 80 00       	mov    0x805148,%eax
  8031de:	89 45 ec             	mov    %eax,-0x14(%ebp)

	LIST_FOREACH(blk,&FreeMemBlocksList)
  8031e1:	a1 38 51 80 00       	mov    0x805138,%eax
  8031e6:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8031e9:	e9 77 01 00 00       	jmp    803365 <alloc_block_NF+0x198>
	{
		if(blk->size == versize)
  8031ee:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8031f1:	8b 40 0c             	mov    0xc(%eax),%eax
  8031f4:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8031f7:	0f 85 8a 00 00 00    	jne    803287 <alloc_block_NF+0xba>
		{
			LIST_REMOVE(&FreeMemBlocksList,blk);
  8031fd:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803201:	75 17                	jne    80321a <alloc_block_NF+0x4d>
  803203:	83 ec 04             	sub    $0x4,%esp
  803206:	68 08 47 80 00       	push   $0x804708
  80320b:	68 f7 00 00 00       	push   $0xf7
  803210:	68 97 46 80 00       	push   $0x804697
  803215:	e8 6d da ff ff       	call   800c87 <_panic>
  80321a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80321d:	8b 00                	mov    (%eax),%eax
  80321f:	85 c0                	test   %eax,%eax
  803221:	74 10                	je     803233 <alloc_block_NF+0x66>
  803223:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803226:	8b 00                	mov    (%eax),%eax
  803228:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80322b:	8b 52 04             	mov    0x4(%edx),%edx
  80322e:	89 50 04             	mov    %edx,0x4(%eax)
  803231:	eb 0b                	jmp    80323e <alloc_block_NF+0x71>
  803233:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803236:	8b 40 04             	mov    0x4(%eax),%eax
  803239:	a3 3c 51 80 00       	mov    %eax,0x80513c
  80323e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803241:	8b 40 04             	mov    0x4(%eax),%eax
  803244:	85 c0                	test   %eax,%eax
  803246:	74 0f                	je     803257 <alloc_block_NF+0x8a>
  803248:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80324b:	8b 40 04             	mov    0x4(%eax),%eax
  80324e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803251:	8b 12                	mov    (%edx),%edx
  803253:	89 10                	mov    %edx,(%eax)
  803255:	eb 0a                	jmp    803261 <alloc_block_NF+0x94>
  803257:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80325a:	8b 00                	mov    (%eax),%eax
  80325c:	a3 38 51 80 00       	mov    %eax,0x805138
  803261:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803264:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80326a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80326d:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803274:	a1 44 51 80 00       	mov    0x805144,%eax
  803279:	48                   	dec    %eax
  80327a:	a3 44 51 80 00       	mov    %eax,0x805144
			return blk;
  80327f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803282:	e9 11 01 00 00       	jmp    803398 <alloc_block_NF+0x1cb>
		}
		else if(blk->size > versize)
  803287:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80328a:	8b 40 0c             	mov    0xc(%eax),%eax
  80328d:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  803290:	0f 86 c7 00 00 00    	jbe    80335d <alloc_block_NF+0x190>
		{
			LIST_REMOVE(&AvailableMemBlocksList,newblk);
  803296:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  80329a:	75 17                	jne    8032b3 <alloc_block_NF+0xe6>
  80329c:	83 ec 04             	sub    $0x4,%esp
  80329f:	68 08 47 80 00       	push   $0x804708
  8032a4:	68 fc 00 00 00       	push   $0xfc
  8032a9:	68 97 46 80 00       	push   $0x804697
  8032ae:	e8 d4 d9 ff ff       	call   800c87 <_panic>
  8032b3:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8032b6:	8b 00                	mov    (%eax),%eax
  8032b8:	85 c0                	test   %eax,%eax
  8032ba:	74 10                	je     8032cc <alloc_block_NF+0xff>
  8032bc:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8032bf:	8b 00                	mov    (%eax),%eax
  8032c1:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8032c4:	8b 52 04             	mov    0x4(%edx),%edx
  8032c7:	89 50 04             	mov    %edx,0x4(%eax)
  8032ca:	eb 0b                	jmp    8032d7 <alloc_block_NF+0x10a>
  8032cc:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8032cf:	8b 40 04             	mov    0x4(%eax),%eax
  8032d2:	a3 4c 51 80 00       	mov    %eax,0x80514c
  8032d7:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8032da:	8b 40 04             	mov    0x4(%eax),%eax
  8032dd:	85 c0                	test   %eax,%eax
  8032df:	74 0f                	je     8032f0 <alloc_block_NF+0x123>
  8032e1:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8032e4:	8b 40 04             	mov    0x4(%eax),%eax
  8032e7:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8032ea:	8b 12                	mov    (%edx),%edx
  8032ec:	89 10                	mov    %edx,(%eax)
  8032ee:	eb 0a                	jmp    8032fa <alloc_block_NF+0x12d>
  8032f0:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8032f3:	8b 00                	mov    (%eax),%eax
  8032f5:	a3 48 51 80 00       	mov    %eax,0x805148
  8032fa:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8032fd:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803303:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803306:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80330d:	a1 54 51 80 00       	mov    0x805154,%eax
  803312:	48                   	dec    %eax
  803313:	a3 54 51 80 00       	mov    %eax,0x805154
			newblk->size = versize;
  803318:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80331b:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80331e:	89 50 0c             	mov    %edx,0xc(%eax)
			blk->size = blk->size-versize;
  803321:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803324:	8b 40 0c             	mov    0xc(%eax),%eax
  803327:	2b 45 f0             	sub    -0x10(%ebp),%eax
  80332a:	89 c2                	mov    %eax,%edx
  80332c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80332f:	89 50 0c             	mov    %edx,0xc(%eax)
			uint32 newveradd = blk->sva;
  803332:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803335:	8b 40 08             	mov    0x8(%eax),%eax
  803338:	89 45 e8             	mov    %eax,-0x18(%ebp)
			blk->sva+=newblk->size;
  80333b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80333e:	8b 50 08             	mov    0x8(%eax),%edx
  803341:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803344:	8b 40 0c             	mov    0xc(%eax),%eax
  803347:	01 c2                	add    %eax,%edx
  803349:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80334c:	89 50 08             	mov    %edx,0x8(%eax)
			newblk->sva = newveradd;
  80334f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803352:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803355:	89 50 08             	mov    %edx,0x8(%eax)
			return newblk;
  803358:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80335b:	eb 3b                	jmp    803398 <alloc_block_NF+0x1cb>
	//panic("alloc_block_NF() is not implemented yet...!!");
	uint32 versize = size;
	struct MemBlock* blk;
	struct MemBlock* newblk = LIST_FIRST(&AvailableMemBlocksList);

	LIST_FOREACH(blk,&FreeMemBlocksList)
  80335d:	a1 40 51 80 00       	mov    0x805140,%eax
  803362:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803365:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803369:	74 07                	je     803372 <alloc_block_NF+0x1a5>
  80336b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80336e:	8b 00                	mov    (%eax),%eax
  803370:	eb 05                	jmp    803377 <alloc_block_NF+0x1aa>
  803372:	b8 00 00 00 00       	mov    $0x0,%eax
  803377:	a3 40 51 80 00       	mov    %eax,0x805140
  80337c:	a1 40 51 80 00       	mov    0x805140,%eax
  803381:	85 c0                	test   %eax,%eax
  803383:	0f 85 65 fe ff ff    	jne    8031ee <alloc_block_NF+0x21>
  803389:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80338d:	0f 85 5b fe ff ff    	jne    8031ee <alloc_block_NF+0x21>
			blk->sva+=newblk->size;
			newblk->sva = newveradd;
			return newblk;
		}
	}
	return NULL;
  803393:	b8 00 00 00 00       	mov    $0x0,%eax
}
  803398:	c9                   	leave  
  803399:	c3                   	ret    

0080339a <addToAvailMemBlocksList>:

//===================================================
// [8] INSERT BLOCK (SORTED WITH MERGE) IN FREE LIST:
//===================================================
void addToAvailMemBlocksList(struct MemBlock *blockToInsert)
{
  80339a:	55                   	push   %ebp
  80339b:	89 e5                	mov    %esp,%ebp
  80339d:	83 ec 08             	sub    $0x8,%esp
	blockToInsert->sva = 0;
  8033a0:	8b 45 08             	mov    0x8(%ebp),%eax
  8033a3:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
	blockToInsert->size = 0;
  8033aa:	8b 45 08             	mov    0x8(%ebp),%eax
  8033ad:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
	//add to avail
	LIST_INSERT_TAIL(&AvailableMemBlocksList, blockToInsert);
  8033b4:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8033b8:	75 17                	jne    8033d1 <addToAvailMemBlocksList+0x37>
  8033ba:	83 ec 04             	sub    $0x4,%esp
  8033bd:	68 b0 46 80 00       	push   $0x8046b0
  8033c2:	68 10 01 00 00       	push   $0x110
  8033c7:	68 97 46 80 00       	push   $0x804697
  8033cc:	e8 b6 d8 ff ff       	call   800c87 <_panic>
  8033d1:	8b 15 4c 51 80 00    	mov    0x80514c,%edx
  8033d7:	8b 45 08             	mov    0x8(%ebp),%eax
  8033da:	89 50 04             	mov    %edx,0x4(%eax)
  8033dd:	8b 45 08             	mov    0x8(%ebp),%eax
  8033e0:	8b 40 04             	mov    0x4(%eax),%eax
  8033e3:	85 c0                	test   %eax,%eax
  8033e5:	74 0c                	je     8033f3 <addToAvailMemBlocksList+0x59>
  8033e7:	a1 4c 51 80 00       	mov    0x80514c,%eax
  8033ec:	8b 55 08             	mov    0x8(%ebp),%edx
  8033ef:	89 10                	mov    %edx,(%eax)
  8033f1:	eb 08                	jmp    8033fb <addToAvailMemBlocksList+0x61>
  8033f3:	8b 45 08             	mov    0x8(%ebp),%eax
  8033f6:	a3 48 51 80 00       	mov    %eax,0x805148
  8033fb:	8b 45 08             	mov    0x8(%ebp),%eax
  8033fe:	a3 4c 51 80 00       	mov    %eax,0x80514c
  803403:	8b 45 08             	mov    0x8(%ebp),%eax
  803406:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80340c:	a1 54 51 80 00       	mov    0x805154,%eax
  803411:	40                   	inc    %eax
  803412:	a3 54 51 80 00       	mov    %eax,0x805154
}
  803417:	90                   	nop
  803418:	c9                   	leave  
  803419:	c3                   	ret    

0080341a <insert_sorted_with_merge_freeList>:
void insert_sorted_with_merge_freeList(struct MemBlock *blockToInsert)
{
  80341a:	55                   	push   %ebp
  80341b:	89 e5                	mov    %esp,%ebp
  80341d:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] insert_sorted_with_merge_freeList
	// Write your code here, remove the panic and write your code

	struct MemBlock* last = LIST_LAST(&FreeMemBlocksList);
  803420:	a1 3c 51 80 00       	mov    0x80513c,%eax
  803425:	89 45 f0             	mov    %eax,-0x10(%ebp)
	//check if list empty
	if (LIST_SIZE(&(FreeMemBlocksList)) == 0)
  803428:	a1 44 51 80 00       	mov    0x805144,%eax
  80342d:	85 c0                	test   %eax,%eax
  80342f:	75 68                	jne    803499 <insert_sorted_with_merge_freeList+0x7f>
		LIST_INSERT_HEAD(&FreeMemBlocksList, blockToInsert);
  803431:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803435:	75 17                	jne    80344e <insert_sorted_with_merge_freeList+0x34>
  803437:	83 ec 04             	sub    $0x4,%esp
  80343a:	68 74 46 80 00       	push   $0x804674
  80343f:	68 1a 01 00 00       	push   $0x11a
  803444:	68 97 46 80 00       	push   $0x804697
  803449:	e8 39 d8 ff ff       	call   800c87 <_panic>
  80344e:	8b 15 38 51 80 00    	mov    0x805138,%edx
  803454:	8b 45 08             	mov    0x8(%ebp),%eax
  803457:	89 10                	mov    %edx,(%eax)
  803459:	8b 45 08             	mov    0x8(%ebp),%eax
  80345c:	8b 00                	mov    (%eax),%eax
  80345e:	85 c0                	test   %eax,%eax
  803460:	74 0d                	je     80346f <insert_sorted_with_merge_freeList+0x55>
  803462:	a1 38 51 80 00       	mov    0x805138,%eax
  803467:	8b 55 08             	mov    0x8(%ebp),%edx
  80346a:	89 50 04             	mov    %edx,0x4(%eax)
  80346d:	eb 08                	jmp    803477 <insert_sorted_with_merge_freeList+0x5d>
  80346f:	8b 45 08             	mov    0x8(%ebp),%eax
  803472:	a3 3c 51 80 00       	mov    %eax,0x80513c
  803477:	8b 45 08             	mov    0x8(%ebp),%eax
  80347a:	a3 38 51 80 00       	mov    %eax,0x805138
  80347f:	8b 45 08             	mov    0x8(%ebp),%eax
  803482:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803489:	a1 44 51 80 00       	mov    0x805144,%eax
  80348e:	40                   	inc    %eax
  80348f:	a3 44 51 80 00       	mov    %eax,0x805144
		}
	}

	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  803494:	e9 c5 03 00 00       	jmp    80385e <insert_sorted_with_merge_freeList+0x444>
	struct MemBlock* last = LIST_LAST(&FreeMemBlocksList);
	//check if list empty
	if (LIST_SIZE(&(FreeMemBlocksList)) == 0)
		LIST_INSERT_HEAD(&FreeMemBlocksList, blockToInsert);
	//check if it's position is at last
	else if (last->sva < blockToInsert->sva) {
  803499:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80349c:	8b 50 08             	mov    0x8(%eax),%edx
  80349f:	8b 45 08             	mov    0x8(%ebp),%eax
  8034a2:	8b 40 08             	mov    0x8(%eax),%eax
  8034a5:	39 c2                	cmp    %eax,%edx
  8034a7:	0f 83 b2 00 00 00    	jae    80355f <insert_sorted_with_merge_freeList+0x145>

		//if i have to merge
		if (last->sva + last->size == blockToInsert->sva) {
  8034ad:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8034b0:	8b 50 08             	mov    0x8(%eax),%edx
  8034b3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8034b6:	8b 40 0c             	mov    0xc(%eax),%eax
  8034b9:	01 c2                	add    %eax,%edx
  8034bb:	8b 45 08             	mov    0x8(%ebp),%eax
  8034be:	8b 40 08             	mov    0x8(%eax),%eax
  8034c1:	39 c2                	cmp    %eax,%edx
  8034c3:	75 27                	jne    8034ec <insert_sorted_with_merge_freeList+0xd2>
			last->size = last->size + blockToInsert->size;
  8034c5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8034c8:	8b 50 0c             	mov    0xc(%eax),%edx
  8034cb:	8b 45 08             	mov    0x8(%ebp),%eax
  8034ce:	8b 40 0c             	mov    0xc(%eax),%eax
  8034d1:	01 c2                	add    %eax,%edx
  8034d3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8034d6:	89 50 0c             	mov    %edx,0xc(%eax)
			addToAvailMemBlocksList(blockToInsert);
  8034d9:	83 ec 0c             	sub    $0xc,%esp
  8034dc:	ff 75 08             	pushl  0x8(%ebp)
  8034df:	e8 b6 fe ff ff       	call   80339a <addToAvailMemBlocksList>
  8034e4:	83 c4 10             	add    $0x10,%esp
		}
	}

	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  8034e7:	e9 72 03 00 00       	jmp    80385e <insert_sorted_with_merge_freeList+0x444>
		if (last->sva + last->size == blockToInsert->sva) {
			last->size = last->size + blockToInsert->size;
			addToAvailMemBlocksList(blockToInsert);

		} else {
			LIST_INSERT_AFTER(&FreeMemBlocksList, last, blockToInsert);
  8034ec:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8034f0:	74 06                	je     8034f8 <insert_sorted_with_merge_freeList+0xde>
  8034f2:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8034f6:	75 17                	jne    80350f <insert_sorted_with_merge_freeList+0xf5>
  8034f8:	83 ec 04             	sub    $0x4,%esp
  8034fb:	68 d4 46 80 00       	push   $0x8046d4
  803500:	68 24 01 00 00       	push   $0x124
  803505:	68 97 46 80 00       	push   $0x804697
  80350a:	e8 78 d7 ff ff       	call   800c87 <_panic>
  80350f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803512:	8b 10                	mov    (%eax),%edx
  803514:	8b 45 08             	mov    0x8(%ebp),%eax
  803517:	89 10                	mov    %edx,(%eax)
  803519:	8b 45 08             	mov    0x8(%ebp),%eax
  80351c:	8b 00                	mov    (%eax),%eax
  80351e:	85 c0                	test   %eax,%eax
  803520:	74 0b                	je     80352d <insert_sorted_with_merge_freeList+0x113>
  803522:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803525:	8b 00                	mov    (%eax),%eax
  803527:	8b 55 08             	mov    0x8(%ebp),%edx
  80352a:	89 50 04             	mov    %edx,0x4(%eax)
  80352d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803530:	8b 55 08             	mov    0x8(%ebp),%edx
  803533:	89 10                	mov    %edx,(%eax)
  803535:	8b 45 08             	mov    0x8(%ebp),%eax
  803538:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80353b:	89 50 04             	mov    %edx,0x4(%eax)
  80353e:	8b 45 08             	mov    0x8(%ebp),%eax
  803541:	8b 00                	mov    (%eax),%eax
  803543:	85 c0                	test   %eax,%eax
  803545:	75 08                	jne    80354f <insert_sorted_with_merge_freeList+0x135>
  803547:	8b 45 08             	mov    0x8(%ebp),%eax
  80354a:	a3 3c 51 80 00       	mov    %eax,0x80513c
  80354f:	a1 44 51 80 00       	mov    0x805144,%eax
  803554:	40                   	inc    %eax
  803555:	a3 44 51 80 00       	mov    %eax,0x805144
		}
	}

	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  80355a:	e9 ff 02 00 00       	jmp    80385e <insert_sorted_with_merge_freeList+0x444>
		} else {
			LIST_INSERT_AFTER(&FreeMemBlocksList, last, blockToInsert);
		}
	} else {
		struct MemBlock *iterator;
		LIST_FOREACH(iterator, &(FreeMemBlocksList))
  80355f:	a1 38 51 80 00       	mov    0x805138,%eax
  803564:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803567:	e9 c2 02 00 00       	jmp    80382e <insert_sorted_with_merge_freeList+0x414>
		{

			if (iterator->sva > blockToInsert->sva) {
  80356c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80356f:	8b 50 08             	mov    0x8(%eax),%edx
  803572:	8b 45 08             	mov    0x8(%ebp),%eax
  803575:	8b 40 08             	mov    0x8(%eax),%eax
  803578:	39 c2                	cmp    %eax,%edx
  80357a:	0f 86 a6 02 00 00    	jbe    803826 <insert_sorted_with_merge_freeList+0x40c>

				struct MemBlock* prev = LIST_PREV(iterator);
  803580:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803583:	8b 40 04             	mov    0x4(%eax),%eax
  803586:	89 45 ec             	mov    %eax,-0x14(%ebp)
				if (prev == NULL) {
  803589:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  80358d:	0f 85 ba 00 00 00    	jne    80364d <insert_sorted_with_merge_freeList+0x233>
					//check merge
					if (blockToInsert->size + blockToInsert->sva
  803593:	8b 45 08             	mov    0x8(%ebp),%eax
  803596:	8b 50 0c             	mov    0xc(%eax),%edx
  803599:	8b 45 08             	mov    0x8(%ebp),%eax
  80359c:	8b 40 08             	mov    0x8(%eax),%eax
  80359f:	01 c2                	add    %eax,%edx
							== iterator->sva) {
  8035a1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8035a4:	8b 40 08             	mov    0x8(%eax),%eax
			if (iterator->sva > blockToInsert->sva) {

				struct MemBlock* prev = LIST_PREV(iterator);
				if (prev == NULL) {
					//check merge
					if (blockToInsert->size + blockToInsert->sva
  8035a7:	39 c2                	cmp    %eax,%edx
  8035a9:	75 33                	jne    8035de <insert_sorted_with_merge_freeList+0x1c4>
							== iterator->sva) {
						iterator->sva = blockToInsert->sva;
  8035ab:	8b 45 08             	mov    0x8(%ebp),%eax
  8035ae:	8b 50 08             	mov    0x8(%eax),%edx
  8035b1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8035b4:	89 50 08             	mov    %edx,0x8(%eax)
						iterator->size = iterator->size + blockToInsert->size;
  8035b7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8035ba:	8b 50 0c             	mov    0xc(%eax),%edx
  8035bd:	8b 45 08             	mov    0x8(%ebp),%eax
  8035c0:	8b 40 0c             	mov    0xc(%eax),%eax
  8035c3:	01 c2                	add    %eax,%edx
  8035c5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8035c8:	89 50 0c             	mov    %edx,0xc(%eax)
						addToAvailMemBlocksList(blockToInsert);
  8035cb:	83 ec 0c             	sub    $0xc,%esp
  8035ce:	ff 75 08             	pushl  0x8(%ebp)
  8035d1:	e8 c4 fd ff ff       	call   80339a <addToAvailMemBlocksList>
  8035d6:	83 c4 10             	add    $0x10,%esp

					else {
						LIST_INSERT_BEFORE(&FreeMemBlocksList, iterator,
								blockToInsert);
					}
					break;
  8035d9:	e9 80 02 00 00       	jmp    80385e <insert_sorted_with_merge_freeList+0x444>
						addToAvailMemBlocksList(blockToInsert);

					}

					else {
						LIST_INSERT_BEFORE(&FreeMemBlocksList, iterator,
  8035de:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8035e2:	74 06                	je     8035ea <insert_sorted_with_merge_freeList+0x1d0>
  8035e4:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8035e8:	75 17                	jne    803601 <insert_sorted_with_merge_freeList+0x1e7>
  8035ea:	83 ec 04             	sub    $0x4,%esp
  8035ed:	68 28 47 80 00       	push   $0x804728
  8035f2:	68 3a 01 00 00       	push   $0x13a
  8035f7:	68 97 46 80 00       	push   $0x804697
  8035fc:	e8 86 d6 ff ff       	call   800c87 <_panic>
  803601:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803604:	8b 50 04             	mov    0x4(%eax),%edx
  803607:	8b 45 08             	mov    0x8(%ebp),%eax
  80360a:	89 50 04             	mov    %edx,0x4(%eax)
  80360d:	8b 45 08             	mov    0x8(%ebp),%eax
  803610:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803613:	89 10                	mov    %edx,(%eax)
  803615:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803618:	8b 40 04             	mov    0x4(%eax),%eax
  80361b:	85 c0                	test   %eax,%eax
  80361d:	74 0d                	je     80362c <insert_sorted_with_merge_freeList+0x212>
  80361f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803622:	8b 40 04             	mov    0x4(%eax),%eax
  803625:	8b 55 08             	mov    0x8(%ebp),%edx
  803628:	89 10                	mov    %edx,(%eax)
  80362a:	eb 08                	jmp    803634 <insert_sorted_with_merge_freeList+0x21a>
  80362c:	8b 45 08             	mov    0x8(%ebp),%eax
  80362f:	a3 38 51 80 00       	mov    %eax,0x805138
  803634:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803637:	8b 55 08             	mov    0x8(%ebp),%edx
  80363a:	89 50 04             	mov    %edx,0x4(%eax)
  80363d:	a1 44 51 80 00       	mov    0x805144,%eax
  803642:	40                   	inc    %eax
  803643:	a3 44 51 80 00       	mov    %eax,0x805144
								blockToInsert);
					}
					break;
  803648:	e9 11 02 00 00       	jmp    80385e <insert_sorted_with_merge_freeList+0x444>
				} else {
					//prev and next merge
					if (prev->sva + prev->size + blockToInsert->size
  80364d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803650:	8b 50 08             	mov    0x8(%eax),%edx
  803653:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803656:	8b 40 0c             	mov    0xc(%eax),%eax
  803659:	01 c2                	add    %eax,%edx
  80365b:	8b 45 08             	mov    0x8(%ebp),%eax
  80365e:	8b 40 0c             	mov    0xc(%eax),%eax
  803661:	01 c2                	add    %eax,%edx
							== iterator->sva) {
  803663:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803666:	8b 40 08             	mov    0x8(%eax),%eax
								blockToInsert);
					}
					break;
				} else {
					//prev and next merge
					if (prev->sva + prev->size + blockToInsert->size
  803669:	39 c2                	cmp    %eax,%edx
  80366b:	0f 85 bf 00 00 00    	jne    803730 <insert_sorted_with_merge_freeList+0x316>
							== iterator->sva) {
						prev->size = prev->size + blockToInsert->size
  803671:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803674:	8b 50 0c             	mov    0xc(%eax),%edx
  803677:	8b 45 08             	mov    0x8(%ebp),%eax
  80367a:	8b 40 0c             	mov    0xc(%eax),%eax
  80367d:	01 c2                	add    %eax,%edx
								+ iterator->size;
  80367f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803682:	8b 40 0c             	mov    0xc(%eax),%eax
  803685:	01 c2                	add    %eax,%edx
					break;
				} else {
					//prev and next merge
					if (prev->sva + prev->size + blockToInsert->size
							== iterator->sva) {
						prev->size = prev->size + blockToInsert->size
  803687:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80368a:	89 50 0c             	mov    %edx,0xc(%eax)
								+ iterator->size;
						LIST_REMOVE(&FreeMemBlocksList, iterator);
  80368d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803691:	75 17                	jne    8036aa <insert_sorted_with_merge_freeList+0x290>
  803693:	83 ec 04             	sub    $0x4,%esp
  803696:	68 08 47 80 00       	push   $0x804708
  80369b:	68 43 01 00 00       	push   $0x143
  8036a0:	68 97 46 80 00       	push   $0x804697
  8036a5:	e8 dd d5 ff ff       	call   800c87 <_panic>
  8036aa:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8036ad:	8b 00                	mov    (%eax),%eax
  8036af:	85 c0                	test   %eax,%eax
  8036b1:	74 10                	je     8036c3 <insert_sorted_with_merge_freeList+0x2a9>
  8036b3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8036b6:	8b 00                	mov    (%eax),%eax
  8036b8:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8036bb:	8b 52 04             	mov    0x4(%edx),%edx
  8036be:	89 50 04             	mov    %edx,0x4(%eax)
  8036c1:	eb 0b                	jmp    8036ce <insert_sorted_with_merge_freeList+0x2b4>
  8036c3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8036c6:	8b 40 04             	mov    0x4(%eax),%eax
  8036c9:	a3 3c 51 80 00       	mov    %eax,0x80513c
  8036ce:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8036d1:	8b 40 04             	mov    0x4(%eax),%eax
  8036d4:	85 c0                	test   %eax,%eax
  8036d6:	74 0f                	je     8036e7 <insert_sorted_with_merge_freeList+0x2cd>
  8036d8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8036db:	8b 40 04             	mov    0x4(%eax),%eax
  8036de:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8036e1:	8b 12                	mov    (%edx),%edx
  8036e3:	89 10                	mov    %edx,(%eax)
  8036e5:	eb 0a                	jmp    8036f1 <insert_sorted_with_merge_freeList+0x2d7>
  8036e7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8036ea:	8b 00                	mov    (%eax),%eax
  8036ec:	a3 38 51 80 00       	mov    %eax,0x805138
  8036f1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8036f4:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8036fa:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8036fd:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803704:	a1 44 51 80 00       	mov    0x805144,%eax
  803709:	48                   	dec    %eax
  80370a:	a3 44 51 80 00       	mov    %eax,0x805144
						addToAvailMemBlocksList(blockToInsert);
  80370f:	83 ec 0c             	sub    $0xc,%esp
  803712:	ff 75 08             	pushl  0x8(%ebp)
  803715:	e8 80 fc ff ff       	call   80339a <addToAvailMemBlocksList>
  80371a:	83 c4 10             	add    $0x10,%esp
						addToAvailMemBlocksList(iterator);
  80371d:	83 ec 0c             	sub    $0xc,%esp
  803720:	ff 75 f4             	pushl  -0xc(%ebp)
  803723:	e8 72 fc ff ff       	call   80339a <addToAvailMemBlocksList>
  803728:	83 c4 10             	add    $0x10,%esp
					//Insert
					else {
						LIST_INSERT_BEFORE(&FreeMemBlocksList, iterator,
								blockToInsert);
					}
					break;
  80372b:	e9 2e 01 00 00       	jmp    80385e <insert_sorted_with_merge_freeList+0x444>
						LIST_REMOVE(&FreeMemBlocksList, iterator);
						addToAvailMemBlocksList(blockToInsert);
						addToAvailMemBlocksList(iterator);
					}
					//previous merge
					else if (prev->sva + prev->size == blockToInsert->sva) {
  803730:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803733:	8b 50 08             	mov    0x8(%eax),%edx
  803736:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803739:	8b 40 0c             	mov    0xc(%eax),%eax
  80373c:	01 c2                	add    %eax,%edx
  80373e:	8b 45 08             	mov    0x8(%ebp),%eax
  803741:	8b 40 08             	mov    0x8(%eax),%eax
  803744:	39 c2                	cmp    %eax,%edx
  803746:	75 27                	jne    80376f <insert_sorted_with_merge_freeList+0x355>
						prev->size = prev->size + blockToInsert->size;
  803748:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80374b:	8b 50 0c             	mov    0xc(%eax),%edx
  80374e:	8b 45 08             	mov    0x8(%ebp),%eax
  803751:	8b 40 0c             	mov    0xc(%eax),%eax
  803754:	01 c2                	add    %eax,%edx
  803756:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803759:	89 50 0c             	mov    %edx,0xc(%eax)
						addToAvailMemBlocksList(blockToInsert);
  80375c:	83 ec 0c             	sub    $0xc,%esp
  80375f:	ff 75 08             	pushl  0x8(%ebp)
  803762:	e8 33 fc ff ff       	call   80339a <addToAvailMemBlocksList>
  803767:	83 c4 10             	add    $0x10,%esp
					//Insert
					else {
						LIST_INSERT_BEFORE(&FreeMemBlocksList, iterator,
								blockToInsert);
					}
					break;
  80376a:	e9 ef 00 00 00       	jmp    80385e <insert_sorted_with_merge_freeList+0x444>
					else if (prev->sva + prev->size == blockToInsert->sva) {
						prev->size = prev->size + blockToInsert->size;
						addToAvailMemBlocksList(blockToInsert);
					}
					//next merge
					else if (blockToInsert->size + blockToInsert->sva
  80376f:	8b 45 08             	mov    0x8(%ebp),%eax
  803772:	8b 50 0c             	mov    0xc(%eax),%edx
  803775:	8b 45 08             	mov    0x8(%ebp),%eax
  803778:	8b 40 08             	mov    0x8(%eax),%eax
  80377b:	01 c2                	add    %eax,%edx
							== iterator->sva) {
  80377d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803780:	8b 40 08             	mov    0x8(%eax),%eax
					else if (prev->sva + prev->size == blockToInsert->sva) {
						prev->size = prev->size + blockToInsert->size;
						addToAvailMemBlocksList(blockToInsert);
					}
					//next merge
					else if (blockToInsert->size + blockToInsert->sva
  803783:	39 c2                	cmp    %eax,%edx
  803785:	75 33                	jne    8037ba <insert_sorted_with_merge_freeList+0x3a0>
							== iterator->sva) {
						iterator->sva = blockToInsert->sva;
  803787:	8b 45 08             	mov    0x8(%ebp),%eax
  80378a:	8b 50 08             	mov    0x8(%eax),%edx
  80378d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803790:	89 50 08             	mov    %edx,0x8(%eax)
						iterator->size = iterator->size + blockToInsert->size;
  803793:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803796:	8b 50 0c             	mov    0xc(%eax),%edx
  803799:	8b 45 08             	mov    0x8(%ebp),%eax
  80379c:	8b 40 0c             	mov    0xc(%eax),%eax
  80379f:	01 c2                	add    %eax,%edx
  8037a1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8037a4:	89 50 0c             	mov    %edx,0xc(%eax)
						addToAvailMemBlocksList(blockToInsert);
  8037a7:	83 ec 0c             	sub    $0xc,%esp
  8037aa:	ff 75 08             	pushl  0x8(%ebp)
  8037ad:	e8 e8 fb ff ff       	call   80339a <addToAvailMemBlocksList>
  8037b2:	83 c4 10             	add    $0x10,%esp
					//Insert
					else {
						LIST_INSERT_BEFORE(&FreeMemBlocksList, iterator,
								blockToInsert);
					}
					break;
  8037b5:	e9 a4 00 00 00       	jmp    80385e <insert_sorted_with_merge_freeList+0x444>
						iterator->size = iterator->size + blockToInsert->size;
						addToAvailMemBlocksList(blockToInsert);
					}
					//Insert
					else {
						LIST_INSERT_BEFORE(&FreeMemBlocksList, iterator,
  8037ba:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8037be:	74 06                	je     8037c6 <insert_sorted_with_merge_freeList+0x3ac>
  8037c0:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8037c4:	75 17                	jne    8037dd <insert_sorted_with_merge_freeList+0x3c3>
  8037c6:	83 ec 04             	sub    $0x4,%esp
  8037c9:	68 28 47 80 00       	push   $0x804728
  8037ce:	68 56 01 00 00       	push   $0x156
  8037d3:	68 97 46 80 00       	push   $0x804697
  8037d8:	e8 aa d4 ff ff       	call   800c87 <_panic>
  8037dd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8037e0:	8b 50 04             	mov    0x4(%eax),%edx
  8037e3:	8b 45 08             	mov    0x8(%ebp),%eax
  8037e6:	89 50 04             	mov    %edx,0x4(%eax)
  8037e9:	8b 45 08             	mov    0x8(%ebp),%eax
  8037ec:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8037ef:	89 10                	mov    %edx,(%eax)
  8037f1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8037f4:	8b 40 04             	mov    0x4(%eax),%eax
  8037f7:	85 c0                	test   %eax,%eax
  8037f9:	74 0d                	je     803808 <insert_sorted_with_merge_freeList+0x3ee>
  8037fb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8037fe:	8b 40 04             	mov    0x4(%eax),%eax
  803801:	8b 55 08             	mov    0x8(%ebp),%edx
  803804:	89 10                	mov    %edx,(%eax)
  803806:	eb 08                	jmp    803810 <insert_sorted_with_merge_freeList+0x3f6>
  803808:	8b 45 08             	mov    0x8(%ebp),%eax
  80380b:	a3 38 51 80 00       	mov    %eax,0x805138
  803810:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803813:	8b 55 08             	mov    0x8(%ebp),%edx
  803816:	89 50 04             	mov    %edx,0x4(%eax)
  803819:	a1 44 51 80 00       	mov    0x805144,%eax
  80381e:	40                   	inc    %eax
  80381f:	a3 44 51 80 00       	mov    %eax,0x805144
								blockToInsert);
					}
					break;
  803824:	eb 38                	jmp    80385e <insert_sorted_with_merge_freeList+0x444>
		} else {
			LIST_INSERT_AFTER(&FreeMemBlocksList, last, blockToInsert);
		}
	} else {
		struct MemBlock *iterator;
		LIST_FOREACH(iterator, &(FreeMemBlocksList))
  803826:	a1 40 51 80 00       	mov    0x805140,%eax
  80382b:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80382e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803832:	74 07                	je     80383b <insert_sorted_with_merge_freeList+0x421>
  803834:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803837:	8b 00                	mov    (%eax),%eax
  803839:	eb 05                	jmp    803840 <insert_sorted_with_merge_freeList+0x426>
  80383b:	b8 00 00 00 00       	mov    $0x0,%eax
  803840:	a3 40 51 80 00       	mov    %eax,0x805140
  803845:	a1 40 51 80 00       	mov    0x805140,%eax
  80384a:	85 c0                	test   %eax,%eax
  80384c:	0f 85 1a fd ff ff    	jne    80356c <insert_sorted_with_merge_freeList+0x152>
  803852:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803856:	0f 85 10 fd ff ff    	jne    80356c <insert_sorted_with_merge_freeList+0x152>
		}
	}

	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  80385c:	eb 00                	jmp    80385e <insert_sorted_with_merge_freeList+0x444>
  80385e:	90                   	nop
  80385f:	c9                   	leave  
  803860:	c3                   	ret    

00803861 <env_sleep>:
#include <inc/lib.h>
#include <inc/timerreg.h>

void
env_sleep(uint32 approxMilliSeconds)
{
  803861:	55                   	push   %ebp
  803862:	89 e5                	mov    %esp,%ebp
  803864:	83 ec 28             	sub    $0x28,%esp
//	cprintf("%s go to sleep...\n", myEnv->prog_name);
	uint32 time_in_cycles=approxMilliSeconds*CYCLES_PER_MILLISEC;
  803867:	8b 55 08             	mov    0x8(%ebp),%edx
  80386a:	89 d0                	mov    %edx,%eax
  80386c:	c1 e0 02             	shl    $0x2,%eax
  80386f:	01 d0                	add    %edx,%eax
  803871:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  803878:	01 d0                	add    %edx,%eax
  80387a:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  803881:	01 d0                	add    %edx,%eax
  803883:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80388a:	01 d0                	add    %edx,%eax
  80388c:	c1 e0 04             	shl    $0x4,%eax
  80388f:	89 45 f0             	mov    %eax,-0x10(%ebp)
	uint32 cycles_counter =0;
  803892:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	struct uint64 baseTime = sys_get_virtual_time() ;
  803899:	8d 45 e8             	lea    -0x18(%ebp),%eax
  80389c:	83 ec 0c             	sub    $0xc,%esp
  80389f:	50                   	push   %eax
  8038a0:	e8 60 ed ff ff       	call   802605 <sys_get_virtual_time>
  8038a5:	83 c4 0c             	add    $0xc,%esp
	while(cycles_counter<time_in_cycles)
  8038a8:	eb 41                	jmp    8038eb <env_sleep+0x8a>
	{
		struct uint64 currentTime = sys_get_virtual_time() ;
  8038aa:	8d 45 e0             	lea    -0x20(%ebp),%eax
  8038ad:	83 ec 0c             	sub    $0xc,%esp
  8038b0:	50                   	push   %eax
  8038b1:	e8 4f ed ff ff       	call   802605 <sys_get_virtual_time>
  8038b6:	83 c4 0c             	add    $0xc,%esp

		// update the cycles_count
		#define M32 0xffffffff
		// subtract basetime from current time
		struct uint64 res;
		res.low = (currentTime.low - baseTime.low) & M32;
  8038b9:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8038bc:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8038bf:	29 c2                	sub    %eax,%edx
  8038c1:	89 d0                	mov    %edx,%eax
  8038c3:	89 45 d8             	mov    %eax,-0x28(%ebp)
		res.hi = (currentTime.hi - baseTime.hi - (res.low > currentTime.low)) & M32;
  8038c6:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8038c9:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8038cc:	89 d1                	mov    %edx,%ecx
  8038ce:	29 c1                	sub    %eax,%ecx
  8038d0:	8b 55 d8             	mov    -0x28(%ebp),%edx
  8038d3:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8038d6:	39 c2                	cmp    %eax,%edx
  8038d8:	0f 97 c0             	seta   %al
  8038db:	0f b6 c0             	movzbl %al,%eax
  8038de:	29 c1                	sub    %eax,%ecx
  8038e0:	89 c8                	mov    %ecx,%eax
  8038e2:	89 45 dc             	mov    %eax,-0x24(%ebp)

		//update cycles_count with result
		cycles_counter = res.low;
  8038e5:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8038e8:	89 45 f4             	mov    %eax,-0xc(%ebp)
//	cprintf("%s go to sleep...\n", myEnv->prog_name);
	uint32 time_in_cycles=approxMilliSeconds*CYCLES_PER_MILLISEC;
	uint32 cycles_counter =0;

	struct uint64 baseTime = sys_get_virtual_time() ;
	while(cycles_counter<time_in_cycles)
  8038eb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8038ee:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8038f1:	72 b7                	jb     8038aa <env_sleep+0x49>
//				,cycles_counter
//				);
	}
	//cprintf("%s [%d] wake up now!\n", myEnv->prog_name, myEnv->env_id);

}
  8038f3:	90                   	nop
  8038f4:	c9                   	leave  
  8038f5:	c3                   	ret    

008038f6 <busy_wait>:

//2017
uint32 busy_wait(uint32 loopMax)
{
  8038f6:	55                   	push   %ebp
  8038f7:	89 e5                	mov    %esp,%ebp
  8038f9:	83 ec 10             	sub    $0x10,%esp
	uint32 i = 0 ;
  8038fc:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	while (i < loopMax) i++;
  803903:	eb 03                	jmp    803908 <busy_wait+0x12>
  803905:	ff 45 fc             	incl   -0x4(%ebp)
  803908:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80390b:	3b 45 08             	cmp    0x8(%ebp),%eax
  80390e:	72 f5                	jb     803905 <busy_wait+0xf>
	return i;
  803910:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  803913:	c9                   	leave  
  803914:	c3                   	ret    
  803915:	66 90                	xchg   %ax,%ax
  803917:	90                   	nop

00803918 <__udivdi3>:
  803918:	55                   	push   %ebp
  803919:	57                   	push   %edi
  80391a:	56                   	push   %esi
  80391b:	53                   	push   %ebx
  80391c:	83 ec 1c             	sub    $0x1c,%esp
  80391f:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  803923:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  803927:	8b 7c 24 38          	mov    0x38(%esp),%edi
  80392b:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  80392f:	89 ca                	mov    %ecx,%edx
  803931:	89 f8                	mov    %edi,%eax
  803933:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  803937:	85 f6                	test   %esi,%esi
  803939:	75 2d                	jne    803968 <__udivdi3+0x50>
  80393b:	39 cf                	cmp    %ecx,%edi
  80393d:	77 65                	ja     8039a4 <__udivdi3+0x8c>
  80393f:	89 fd                	mov    %edi,%ebp
  803941:	85 ff                	test   %edi,%edi
  803943:	75 0b                	jne    803950 <__udivdi3+0x38>
  803945:	b8 01 00 00 00       	mov    $0x1,%eax
  80394a:	31 d2                	xor    %edx,%edx
  80394c:	f7 f7                	div    %edi
  80394e:	89 c5                	mov    %eax,%ebp
  803950:	31 d2                	xor    %edx,%edx
  803952:	89 c8                	mov    %ecx,%eax
  803954:	f7 f5                	div    %ebp
  803956:	89 c1                	mov    %eax,%ecx
  803958:	89 d8                	mov    %ebx,%eax
  80395a:	f7 f5                	div    %ebp
  80395c:	89 cf                	mov    %ecx,%edi
  80395e:	89 fa                	mov    %edi,%edx
  803960:	83 c4 1c             	add    $0x1c,%esp
  803963:	5b                   	pop    %ebx
  803964:	5e                   	pop    %esi
  803965:	5f                   	pop    %edi
  803966:	5d                   	pop    %ebp
  803967:	c3                   	ret    
  803968:	39 ce                	cmp    %ecx,%esi
  80396a:	77 28                	ja     803994 <__udivdi3+0x7c>
  80396c:	0f bd fe             	bsr    %esi,%edi
  80396f:	83 f7 1f             	xor    $0x1f,%edi
  803972:	75 40                	jne    8039b4 <__udivdi3+0x9c>
  803974:	39 ce                	cmp    %ecx,%esi
  803976:	72 0a                	jb     803982 <__udivdi3+0x6a>
  803978:	3b 44 24 08          	cmp    0x8(%esp),%eax
  80397c:	0f 87 9e 00 00 00    	ja     803a20 <__udivdi3+0x108>
  803982:	b8 01 00 00 00       	mov    $0x1,%eax
  803987:	89 fa                	mov    %edi,%edx
  803989:	83 c4 1c             	add    $0x1c,%esp
  80398c:	5b                   	pop    %ebx
  80398d:	5e                   	pop    %esi
  80398e:	5f                   	pop    %edi
  80398f:	5d                   	pop    %ebp
  803990:	c3                   	ret    
  803991:	8d 76 00             	lea    0x0(%esi),%esi
  803994:	31 ff                	xor    %edi,%edi
  803996:	31 c0                	xor    %eax,%eax
  803998:	89 fa                	mov    %edi,%edx
  80399a:	83 c4 1c             	add    $0x1c,%esp
  80399d:	5b                   	pop    %ebx
  80399e:	5e                   	pop    %esi
  80399f:	5f                   	pop    %edi
  8039a0:	5d                   	pop    %ebp
  8039a1:	c3                   	ret    
  8039a2:	66 90                	xchg   %ax,%ax
  8039a4:	89 d8                	mov    %ebx,%eax
  8039a6:	f7 f7                	div    %edi
  8039a8:	31 ff                	xor    %edi,%edi
  8039aa:	89 fa                	mov    %edi,%edx
  8039ac:	83 c4 1c             	add    $0x1c,%esp
  8039af:	5b                   	pop    %ebx
  8039b0:	5e                   	pop    %esi
  8039b1:	5f                   	pop    %edi
  8039b2:	5d                   	pop    %ebp
  8039b3:	c3                   	ret    
  8039b4:	bd 20 00 00 00       	mov    $0x20,%ebp
  8039b9:	89 eb                	mov    %ebp,%ebx
  8039bb:	29 fb                	sub    %edi,%ebx
  8039bd:	89 f9                	mov    %edi,%ecx
  8039bf:	d3 e6                	shl    %cl,%esi
  8039c1:	89 c5                	mov    %eax,%ebp
  8039c3:	88 d9                	mov    %bl,%cl
  8039c5:	d3 ed                	shr    %cl,%ebp
  8039c7:	89 e9                	mov    %ebp,%ecx
  8039c9:	09 f1                	or     %esi,%ecx
  8039cb:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  8039cf:	89 f9                	mov    %edi,%ecx
  8039d1:	d3 e0                	shl    %cl,%eax
  8039d3:	89 c5                	mov    %eax,%ebp
  8039d5:	89 d6                	mov    %edx,%esi
  8039d7:	88 d9                	mov    %bl,%cl
  8039d9:	d3 ee                	shr    %cl,%esi
  8039db:	89 f9                	mov    %edi,%ecx
  8039dd:	d3 e2                	shl    %cl,%edx
  8039df:	8b 44 24 08          	mov    0x8(%esp),%eax
  8039e3:	88 d9                	mov    %bl,%cl
  8039e5:	d3 e8                	shr    %cl,%eax
  8039e7:	09 c2                	or     %eax,%edx
  8039e9:	89 d0                	mov    %edx,%eax
  8039eb:	89 f2                	mov    %esi,%edx
  8039ed:	f7 74 24 0c          	divl   0xc(%esp)
  8039f1:	89 d6                	mov    %edx,%esi
  8039f3:	89 c3                	mov    %eax,%ebx
  8039f5:	f7 e5                	mul    %ebp
  8039f7:	39 d6                	cmp    %edx,%esi
  8039f9:	72 19                	jb     803a14 <__udivdi3+0xfc>
  8039fb:	74 0b                	je     803a08 <__udivdi3+0xf0>
  8039fd:	89 d8                	mov    %ebx,%eax
  8039ff:	31 ff                	xor    %edi,%edi
  803a01:	e9 58 ff ff ff       	jmp    80395e <__udivdi3+0x46>
  803a06:	66 90                	xchg   %ax,%ax
  803a08:	8b 54 24 08          	mov    0x8(%esp),%edx
  803a0c:	89 f9                	mov    %edi,%ecx
  803a0e:	d3 e2                	shl    %cl,%edx
  803a10:	39 c2                	cmp    %eax,%edx
  803a12:	73 e9                	jae    8039fd <__udivdi3+0xe5>
  803a14:	8d 43 ff             	lea    -0x1(%ebx),%eax
  803a17:	31 ff                	xor    %edi,%edi
  803a19:	e9 40 ff ff ff       	jmp    80395e <__udivdi3+0x46>
  803a1e:	66 90                	xchg   %ax,%ax
  803a20:	31 c0                	xor    %eax,%eax
  803a22:	e9 37 ff ff ff       	jmp    80395e <__udivdi3+0x46>
  803a27:	90                   	nop

00803a28 <__umoddi3>:
  803a28:	55                   	push   %ebp
  803a29:	57                   	push   %edi
  803a2a:	56                   	push   %esi
  803a2b:	53                   	push   %ebx
  803a2c:	83 ec 1c             	sub    $0x1c,%esp
  803a2f:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  803a33:	8b 74 24 34          	mov    0x34(%esp),%esi
  803a37:	8b 7c 24 38          	mov    0x38(%esp),%edi
  803a3b:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  803a3f:	89 44 24 0c          	mov    %eax,0xc(%esp)
  803a43:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  803a47:	89 f3                	mov    %esi,%ebx
  803a49:	89 fa                	mov    %edi,%edx
  803a4b:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  803a4f:	89 34 24             	mov    %esi,(%esp)
  803a52:	85 c0                	test   %eax,%eax
  803a54:	75 1a                	jne    803a70 <__umoddi3+0x48>
  803a56:	39 f7                	cmp    %esi,%edi
  803a58:	0f 86 a2 00 00 00    	jbe    803b00 <__umoddi3+0xd8>
  803a5e:	89 c8                	mov    %ecx,%eax
  803a60:	89 f2                	mov    %esi,%edx
  803a62:	f7 f7                	div    %edi
  803a64:	89 d0                	mov    %edx,%eax
  803a66:	31 d2                	xor    %edx,%edx
  803a68:	83 c4 1c             	add    $0x1c,%esp
  803a6b:	5b                   	pop    %ebx
  803a6c:	5e                   	pop    %esi
  803a6d:	5f                   	pop    %edi
  803a6e:	5d                   	pop    %ebp
  803a6f:	c3                   	ret    
  803a70:	39 f0                	cmp    %esi,%eax
  803a72:	0f 87 ac 00 00 00    	ja     803b24 <__umoddi3+0xfc>
  803a78:	0f bd e8             	bsr    %eax,%ebp
  803a7b:	83 f5 1f             	xor    $0x1f,%ebp
  803a7e:	0f 84 ac 00 00 00    	je     803b30 <__umoddi3+0x108>
  803a84:	bf 20 00 00 00       	mov    $0x20,%edi
  803a89:	29 ef                	sub    %ebp,%edi
  803a8b:	89 fe                	mov    %edi,%esi
  803a8d:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  803a91:	89 e9                	mov    %ebp,%ecx
  803a93:	d3 e0                	shl    %cl,%eax
  803a95:	89 d7                	mov    %edx,%edi
  803a97:	89 f1                	mov    %esi,%ecx
  803a99:	d3 ef                	shr    %cl,%edi
  803a9b:	09 c7                	or     %eax,%edi
  803a9d:	89 e9                	mov    %ebp,%ecx
  803a9f:	d3 e2                	shl    %cl,%edx
  803aa1:	89 14 24             	mov    %edx,(%esp)
  803aa4:	89 d8                	mov    %ebx,%eax
  803aa6:	d3 e0                	shl    %cl,%eax
  803aa8:	89 c2                	mov    %eax,%edx
  803aaa:	8b 44 24 08          	mov    0x8(%esp),%eax
  803aae:	d3 e0                	shl    %cl,%eax
  803ab0:	89 44 24 04          	mov    %eax,0x4(%esp)
  803ab4:	8b 44 24 08          	mov    0x8(%esp),%eax
  803ab8:	89 f1                	mov    %esi,%ecx
  803aba:	d3 e8                	shr    %cl,%eax
  803abc:	09 d0                	or     %edx,%eax
  803abe:	d3 eb                	shr    %cl,%ebx
  803ac0:	89 da                	mov    %ebx,%edx
  803ac2:	f7 f7                	div    %edi
  803ac4:	89 d3                	mov    %edx,%ebx
  803ac6:	f7 24 24             	mull   (%esp)
  803ac9:	89 c6                	mov    %eax,%esi
  803acb:	89 d1                	mov    %edx,%ecx
  803acd:	39 d3                	cmp    %edx,%ebx
  803acf:	0f 82 87 00 00 00    	jb     803b5c <__umoddi3+0x134>
  803ad5:	0f 84 91 00 00 00    	je     803b6c <__umoddi3+0x144>
  803adb:	8b 54 24 04          	mov    0x4(%esp),%edx
  803adf:	29 f2                	sub    %esi,%edx
  803ae1:	19 cb                	sbb    %ecx,%ebx
  803ae3:	89 d8                	mov    %ebx,%eax
  803ae5:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  803ae9:	d3 e0                	shl    %cl,%eax
  803aeb:	89 e9                	mov    %ebp,%ecx
  803aed:	d3 ea                	shr    %cl,%edx
  803aef:	09 d0                	or     %edx,%eax
  803af1:	89 e9                	mov    %ebp,%ecx
  803af3:	d3 eb                	shr    %cl,%ebx
  803af5:	89 da                	mov    %ebx,%edx
  803af7:	83 c4 1c             	add    $0x1c,%esp
  803afa:	5b                   	pop    %ebx
  803afb:	5e                   	pop    %esi
  803afc:	5f                   	pop    %edi
  803afd:	5d                   	pop    %ebp
  803afe:	c3                   	ret    
  803aff:	90                   	nop
  803b00:	89 fd                	mov    %edi,%ebp
  803b02:	85 ff                	test   %edi,%edi
  803b04:	75 0b                	jne    803b11 <__umoddi3+0xe9>
  803b06:	b8 01 00 00 00       	mov    $0x1,%eax
  803b0b:	31 d2                	xor    %edx,%edx
  803b0d:	f7 f7                	div    %edi
  803b0f:	89 c5                	mov    %eax,%ebp
  803b11:	89 f0                	mov    %esi,%eax
  803b13:	31 d2                	xor    %edx,%edx
  803b15:	f7 f5                	div    %ebp
  803b17:	89 c8                	mov    %ecx,%eax
  803b19:	f7 f5                	div    %ebp
  803b1b:	89 d0                	mov    %edx,%eax
  803b1d:	e9 44 ff ff ff       	jmp    803a66 <__umoddi3+0x3e>
  803b22:	66 90                	xchg   %ax,%ax
  803b24:	89 c8                	mov    %ecx,%eax
  803b26:	89 f2                	mov    %esi,%edx
  803b28:	83 c4 1c             	add    $0x1c,%esp
  803b2b:	5b                   	pop    %ebx
  803b2c:	5e                   	pop    %esi
  803b2d:	5f                   	pop    %edi
  803b2e:	5d                   	pop    %ebp
  803b2f:	c3                   	ret    
  803b30:	3b 04 24             	cmp    (%esp),%eax
  803b33:	72 06                	jb     803b3b <__umoddi3+0x113>
  803b35:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  803b39:	77 0f                	ja     803b4a <__umoddi3+0x122>
  803b3b:	89 f2                	mov    %esi,%edx
  803b3d:	29 f9                	sub    %edi,%ecx
  803b3f:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  803b43:	89 14 24             	mov    %edx,(%esp)
  803b46:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  803b4a:	8b 44 24 04          	mov    0x4(%esp),%eax
  803b4e:	8b 14 24             	mov    (%esp),%edx
  803b51:	83 c4 1c             	add    $0x1c,%esp
  803b54:	5b                   	pop    %ebx
  803b55:	5e                   	pop    %esi
  803b56:	5f                   	pop    %edi
  803b57:	5d                   	pop    %ebp
  803b58:	c3                   	ret    
  803b59:	8d 76 00             	lea    0x0(%esi),%esi
  803b5c:	2b 04 24             	sub    (%esp),%eax
  803b5f:	19 fa                	sbb    %edi,%edx
  803b61:	89 d1                	mov    %edx,%ecx
  803b63:	89 c6                	mov    %eax,%esi
  803b65:	e9 71 ff ff ff       	jmp    803adb <__umoddi3+0xb3>
  803b6a:	66 90                	xchg   %ax,%ax
  803b6c:	39 44 24 04          	cmp    %eax,0x4(%esp)
  803b70:	72 ea                	jb     803b5c <__umoddi3+0x134>
  803b72:	89 d9                	mov    %ebx,%ecx
  803b74:	e9 62 ff ff ff       	jmp    803adb <__umoddi3+0xb3>
