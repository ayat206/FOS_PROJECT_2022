
obj/user/tst_air_clerk:     file format elf32-i386


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
  800031:	e8 e7 05 00 00       	call   80061d <libmain>
1:      jmp 1b
  800036:	eb fe                	jmp    800036 <args_exist+0x5>

00800038 <_main>:
#include <inc/lib.h>
#include <user/air.h>

void
_main(void)
{
  800038:	55                   	push   %ebp
  800039:	89 e5                	mov    %esp,%ebp
  80003b:	57                   	push   %edi
  80003c:	56                   	push   %esi
  80003d:	53                   	push   %ebx
  80003e:	81 ec 9c 01 00 00    	sub    $0x19c,%esp
	int parentenvID = sys_getparentenvid();
  800044:	e8 5b 20 00 00       	call   8020a4 <sys_getparentenvid>
  800049:	89 45 e4             	mov    %eax,-0x1c(%ebp)

	// Get the shared variables from the main program ***********************************

	char _customers[] = "customers";
  80004c:	8d 45 ae             	lea    -0x52(%ebp),%eax
  80004f:	bb d5 35 80 00       	mov    $0x8035d5,%ebx
  800054:	ba 0a 00 00 00       	mov    $0xa,%edx
  800059:	89 c7                	mov    %eax,%edi
  80005b:	89 de                	mov    %ebx,%esi
  80005d:	89 d1                	mov    %edx,%ecx
  80005f:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
	char _custCounter[] = "custCounter";
  800061:	8d 45 a2             	lea    -0x5e(%ebp),%eax
  800064:	bb df 35 80 00       	mov    $0x8035df,%ebx
  800069:	ba 03 00 00 00       	mov    $0x3,%edx
  80006e:	89 c7                	mov    %eax,%edi
  800070:	89 de                	mov    %ebx,%esi
  800072:	89 d1                	mov    %edx,%ecx
  800074:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
	char _flight1Counter[] = "flight1Counter";
  800076:	8d 45 93             	lea    -0x6d(%ebp),%eax
  800079:	bb eb 35 80 00       	mov    $0x8035eb,%ebx
  80007e:	ba 0f 00 00 00       	mov    $0xf,%edx
  800083:	89 c7                	mov    %eax,%edi
  800085:	89 de                	mov    %ebx,%esi
  800087:	89 d1                	mov    %edx,%ecx
  800089:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
	char _flight2Counter[] = "flight2Counter";
  80008b:	8d 45 84             	lea    -0x7c(%ebp),%eax
  80008e:	bb fa 35 80 00       	mov    $0x8035fa,%ebx
  800093:	ba 0f 00 00 00       	mov    $0xf,%edx
  800098:	89 c7                	mov    %eax,%edi
  80009a:	89 de                	mov    %ebx,%esi
  80009c:	89 d1                	mov    %edx,%ecx
  80009e:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
	char _flightBooked1Counter[] = "flightBooked1Counter";
  8000a0:	8d 85 6f ff ff ff    	lea    -0x91(%ebp),%eax
  8000a6:	bb 09 36 80 00       	mov    $0x803609,%ebx
  8000ab:	ba 15 00 00 00       	mov    $0x15,%edx
  8000b0:	89 c7                	mov    %eax,%edi
  8000b2:	89 de                	mov    %ebx,%esi
  8000b4:	89 d1                	mov    %edx,%ecx
  8000b6:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
	char _flightBooked2Counter[] = "flightBooked2Counter";
  8000b8:	8d 85 5a ff ff ff    	lea    -0xa6(%ebp),%eax
  8000be:	bb 1e 36 80 00       	mov    $0x80361e,%ebx
  8000c3:	ba 15 00 00 00       	mov    $0x15,%edx
  8000c8:	89 c7                	mov    %eax,%edi
  8000ca:	89 de                	mov    %ebx,%esi
  8000cc:	89 d1                	mov    %edx,%ecx
  8000ce:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
	char _flightBooked1Arr[] = "flightBooked1Arr";
  8000d0:	8d 85 49 ff ff ff    	lea    -0xb7(%ebp),%eax
  8000d6:	bb 33 36 80 00       	mov    $0x803633,%ebx
  8000db:	ba 11 00 00 00       	mov    $0x11,%edx
  8000e0:	89 c7                	mov    %eax,%edi
  8000e2:	89 de                	mov    %ebx,%esi
  8000e4:	89 d1                	mov    %edx,%ecx
  8000e6:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
	char _flightBooked2Arr[] = "flightBooked2Arr";
  8000e8:	8d 85 38 ff ff ff    	lea    -0xc8(%ebp),%eax
  8000ee:	bb 44 36 80 00       	mov    $0x803644,%ebx
  8000f3:	ba 11 00 00 00       	mov    $0x11,%edx
  8000f8:	89 c7                	mov    %eax,%edi
  8000fa:	89 de                	mov    %ebx,%esi
  8000fc:	89 d1                	mov    %edx,%ecx
  8000fe:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
	char _cust_ready_queue[] = "cust_ready_queue";
  800100:	8d 85 27 ff ff ff    	lea    -0xd9(%ebp),%eax
  800106:	bb 55 36 80 00       	mov    $0x803655,%ebx
  80010b:	ba 11 00 00 00       	mov    $0x11,%edx
  800110:	89 c7                	mov    %eax,%edi
  800112:	89 de                	mov    %ebx,%esi
  800114:	89 d1                	mov    %edx,%ecx
  800116:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
	char _queue_in[] = "queue_in";
  800118:	8d 85 1e ff ff ff    	lea    -0xe2(%ebp),%eax
  80011e:	bb 66 36 80 00       	mov    $0x803666,%ebx
  800123:	ba 09 00 00 00       	mov    $0x9,%edx
  800128:	89 c7                	mov    %eax,%edi
  80012a:	89 de                	mov    %ebx,%esi
  80012c:	89 d1                	mov    %edx,%ecx
  80012e:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
	char _queue_out[] = "queue_out";
  800130:	8d 85 14 ff ff ff    	lea    -0xec(%ebp),%eax
  800136:	bb 6f 36 80 00       	mov    $0x80366f,%ebx
  80013b:	ba 0a 00 00 00       	mov    $0xa,%edx
  800140:	89 c7                	mov    %eax,%edi
  800142:	89 de                	mov    %ebx,%esi
  800144:	89 d1                	mov    %edx,%ecx
  800146:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)

	char _cust_ready[] = "cust_ready";
  800148:	8d 85 09 ff ff ff    	lea    -0xf7(%ebp),%eax
  80014e:	bb 79 36 80 00       	mov    $0x803679,%ebx
  800153:	ba 0b 00 00 00       	mov    $0xb,%edx
  800158:	89 c7                	mov    %eax,%edi
  80015a:	89 de                	mov    %ebx,%esi
  80015c:	89 d1                	mov    %edx,%ecx
  80015e:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
	char _custQueueCS[] = "custQueueCS";
  800160:	8d 85 fd fe ff ff    	lea    -0x103(%ebp),%eax
  800166:	bb 84 36 80 00       	mov    $0x803684,%ebx
  80016b:	ba 03 00 00 00       	mov    $0x3,%edx
  800170:	89 c7                	mov    %eax,%edi
  800172:	89 de                	mov    %ebx,%esi
  800174:	89 d1                	mov    %edx,%ecx
  800176:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
	char _flight1CS[] = "flight1CS";
  800178:	8d 85 f3 fe ff ff    	lea    -0x10d(%ebp),%eax
  80017e:	bb 90 36 80 00       	mov    $0x803690,%ebx
  800183:	ba 0a 00 00 00       	mov    $0xa,%edx
  800188:	89 c7                	mov    %eax,%edi
  80018a:	89 de                	mov    %ebx,%esi
  80018c:	89 d1                	mov    %edx,%ecx
  80018e:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
	char _flight2CS[] = "flight2CS";
  800190:	8d 85 e9 fe ff ff    	lea    -0x117(%ebp),%eax
  800196:	bb 9a 36 80 00       	mov    $0x80369a,%ebx
  80019b:	ba 0a 00 00 00       	mov    $0xa,%edx
  8001a0:	89 c7                	mov    %eax,%edi
  8001a2:	89 de                	mov    %ebx,%esi
  8001a4:	89 d1                	mov    %edx,%ecx
  8001a6:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)

	char _clerk[] = "clerk";
  8001a8:	c7 85 e3 fe ff ff 63 	movl   $0x72656c63,-0x11d(%ebp)
  8001af:	6c 65 72 
  8001b2:	66 c7 85 e7 fe ff ff 	movw   $0x6b,-0x119(%ebp)
  8001b9:	6b 00 
	char _custCounterCS[] = "custCounterCS";
  8001bb:	8d 85 d5 fe ff ff    	lea    -0x12b(%ebp),%eax
  8001c1:	bb a4 36 80 00       	mov    $0x8036a4,%ebx
  8001c6:	ba 0e 00 00 00       	mov    $0xe,%edx
  8001cb:	89 c7                	mov    %eax,%edi
  8001cd:	89 de                	mov    %ebx,%esi
  8001cf:	89 d1                	mov    %edx,%ecx
  8001d1:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
	char _custTerminated[] = "custTerminated";
  8001d3:	8d 85 c6 fe ff ff    	lea    -0x13a(%ebp),%eax
  8001d9:	bb b2 36 80 00       	mov    $0x8036b2,%ebx
  8001de:	ba 0f 00 00 00       	mov    $0xf,%edx
  8001e3:	89 c7                	mov    %eax,%edi
  8001e5:	89 de                	mov    %ebx,%esi
  8001e7:	89 d1                	mov    %edx,%ecx
  8001e9:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)

	char _taircl[] = "taircl";
  8001eb:	8d 85 bf fe ff ff    	lea    -0x141(%ebp),%eax
  8001f1:	bb c1 36 80 00       	mov    $0x8036c1,%ebx
  8001f6:	ba 07 00 00 00       	mov    $0x7,%edx
  8001fb:	89 c7                	mov    %eax,%edi
  8001fd:	89 de                	mov    %ebx,%esi
  8001ff:	89 d1                	mov    %edx,%ecx
  800201:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
	char _taircu[] = "taircu";
  800203:	8d 85 b8 fe ff ff    	lea    -0x148(%ebp),%eax
  800209:	bb c8 36 80 00       	mov    $0x8036c8,%ebx
  80020e:	ba 07 00 00 00       	mov    $0x7,%edx
  800213:	89 c7                	mov    %eax,%edi
  800215:	89 de                	mov    %ebx,%esi
  800217:	89 d1                	mov    %edx,%ecx
  800219:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)

	struct Customer * customers = sget(parentenvID, _customers);
  80021b:	83 ec 08             	sub    $0x8,%esp
  80021e:	8d 45 ae             	lea    -0x52(%ebp),%eax
  800221:	50                   	push   %eax
  800222:	ff 75 e4             	pushl  -0x1c(%ebp)
  800225:	e8 6d 19 00 00       	call   801b97 <sget>
  80022a:	83 c4 10             	add    $0x10,%esp
  80022d:	89 45 e0             	mov    %eax,-0x20(%ebp)

	int* flight1Counter = sget(parentenvID, _flight1Counter);
  800230:	83 ec 08             	sub    $0x8,%esp
  800233:	8d 45 93             	lea    -0x6d(%ebp),%eax
  800236:	50                   	push   %eax
  800237:	ff 75 e4             	pushl  -0x1c(%ebp)
  80023a:	e8 58 19 00 00       	call   801b97 <sget>
  80023f:	83 c4 10             	add    $0x10,%esp
  800242:	89 45 dc             	mov    %eax,-0x24(%ebp)
	int* flight2Counter = sget(parentenvID, _flight2Counter);
  800245:	83 ec 08             	sub    $0x8,%esp
  800248:	8d 45 84             	lea    -0x7c(%ebp),%eax
  80024b:	50                   	push   %eax
  80024c:	ff 75 e4             	pushl  -0x1c(%ebp)
  80024f:	e8 43 19 00 00       	call   801b97 <sget>
  800254:	83 c4 10             	add    $0x10,%esp
  800257:	89 45 d8             	mov    %eax,-0x28(%ebp)

	int* flight1BookedCounter = sget(parentenvID, _flightBooked1Counter);
  80025a:	83 ec 08             	sub    $0x8,%esp
  80025d:	8d 85 6f ff ff ff    	lea    -0x91(%ebp),%eax
  800263:	50                   	push   %eax
  800264:	ff 75 e4             	pushl  -0x1c(%ebp)
  800267:	e8 2b 19 00 00       	call   801b97 <sget>
  80026c:	83 c4 10             	add    $0x10,%esp
  80026f:	89 45 d4             	mov    %eax,-0x2c(%ebp)
	int* flight2BookedCounter = sget(parentenvID, _flightBooked2Counter);
  800272:	83 ec 08             	sub    $0x8,%esp
  800275:	8d 85 5a ff ff ff    	lea    -0xa6(%ebp),%eax
  80027b:	50                   	push   %eax
  80027c:	ff 75 e4             	pushl  -0x1c(%ebp)
  80027f:	e8 13 19 00 00       	call   801b97 <sget>
  800284:	83 c4 10             	add    $0x10,%esp
  800287:	89 45 d0             	mov    %eax,-0x30(%ebp)

	int* flight1BookedArr = sget(parentenvID, _flightBooked1Arr);
  80028a:	83 ec 08             	sub    $0x8,%esp
  80028d:	8d 85 49 ff ff ff    	lea    -0xb7(%ebp),%eax
  800293:	50                   	push   %eax
  800294:	ff 75 e4             	pushl  -0x1c(%ebp)
  800297:	e8 fb 18 00 00       	call   801b97 <sget>
  80029c:	83 c4 10             	add    $0x10,%esp
  80029f:	89 45 cc             	mov    %eax,-0x34(%ebp)
	int* flight2BookedArr = sget(parentenvID, _flightBooked2Arr);
  8002a2:	83 ec 08             	sub    $0x8,%esp
  8002a5:	8d 85 38 ff ff ff    	lea    -0xc8(%ebp),%eax
  8002ab:	50                   	push   %eax
  8002ac:	ff 75 e4             	pushl  -0x1c(%ebp)
  8002af:	e8 e3 18 00 00       	call   801b97 <sget>
  8002b4:	83 c4 10             	add    $0x10,%esp
  8002b7:	89 45 c8             	mov    %eax,-0x38(%ebp)

	int* cust_ready_queue = sget(parentenvID, _cust_ready_queue);
  8002ba:	83 ec 08             	sub    $0x8,%esp
  8002bd:	8d 85 27 ff ff ff    	lea    -0xd9(%ebp),%eax
  8002c3:	50                   	push   %eax
  8002c4:	ff 75 e4             	pushl  -0x1c(%ebp)
  8002c7:	e8 cb 18 00 00       	call   801b97 <sget>
  8002cc:	83 c4 10             	add    $0x10,%esp
  8002cf:	89 45 c4             	mov    %eax,-0x3c(%ebp)

	int* queue_out = sget(parentenvID, _queue_out);
  8002d2:	83 ec 08             	sub    $0x8,%esp
  8002d5:	8d 85 14 ff ff ff    	lea    -0xec(%ebp),%eax
  8002db:	50                   	push   %eax
  8002dc:	ff 75 e4             	pushl  -0x1c(%ebp)
  8002df:	e8 b3 18 00 00       	call   801b97 <sget>
  8002e4:	83 c4 10             	add    $0x10,%esp
  8002e7:	89 45 c0             	mov    %eax,-0x40(%ebp)

	while(1==1)
	{
		int custId;
		//wait for a customer
		sys_waitSemaphore(parentenvID, _cust_ready);
  8002ea:	83 ec 08             	sub    $0x8,%esp
  8002ed:	8d 85 09 ff ff ff    	lea    -0xf7(%ebp),%eax
  8002f3:	50                   	push   %eax
  8002f4:	ff 75 e4             	pushl  -0x1c(%ebp)
  8002f7:	e8 49 1c 00 00       	call   801f45 <sys_waitSemaphore>
  8002fc:	83 c4 10             	add    $0x10,%esp

		//dequeue the customer info
		sys_waitSemaphore(parentenvID, _custQueueCS);
  8002ff:	83 ec 08             	sub    $0x8,%esp
  800302:	8d 85 fd fe ff ff    	lea    -0x103(%ebp),%eax
  800308:	50                   	push   %eax
  800309:	ff 75 e4             	pushl  -0x1c(%ebp)
  80030c:	e8 34 1c 00 00       	call   801f45 <sys_waitSemaphore>
  800311:	83 c4 10             	add    $0x10,%esp
		{
			//cprintf("*queue_out = %d\n", *queue_out);
			custId = cust_ready_queue[*queue_out];
  800314:	8b 45 c0             	mov    -0x40(%ebp),%eax
  800317:	8b 00                	mov    (%eax),%eax
  800319:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800320:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  800323:	01 d0                	add    %edx,%eax
  800325:	8b 00                	mov    (%eax),%eax
  800327:	89 45 bc             	mov    %eax,-0x44(%ebp)
			*queue_out = *queue_out +1;
  80032a:	8b 45 c0             	mov    -0x40(%ebp),%eax
  80032d:	8b 00                	mov    (%eax),%eax
  80032f:	8d 50 01             	lea    0x1(%eax),%edx
  800332:	8b 45 c0             	mov    -0x40(%ebp),%eax
  800335:	89 10                	mov    %edx,(%eax)
		}
		sys_signalSemaphore(parentenvID, _custQueueCS);
  800337:	83 ec 08             	sub    $0x8,%esp
  80033a:	8d 85 fd fe ff ff    	lea    -0x103(%ebp),%eax
  800340:	50                   	push   %eax
  800341:	ff 75 e4             	pushl  -0x1c(%ebp)
  800344:	e8 1a 1c 00 00       	call   801f63 <sys_signalSemaphore>
  800349:	83 c4 10             	add    $0x10,%esp

		//try reserving on the required flight
		int custFlightType = customers[custId].flightType;
  80034c:	8b 45 bc             	mov    -0x44(%ebp),%eax
  80034f:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
  800356:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800359:	01 d0                	add    %edx,%eax
  80035b:	8b 00                	mov    (%eax),%eax
  80035d:	89 45 b8             	mov    %eax,-0x48(%ebp)
		//cprintf("custId dequeued = %d, ft = %d\n", custId, customers[custId].flightType);

		switch (custFlightType)
  800360:	8b 45 b8             	mov    -0x48(%ebp),%eax
  800363:	83 f8 02             	cmp    $0x2,%eax
  800366:	0f 84 90 00 00 00    	je     8003fc <_main+0x3c4>
  80036c:	83 f8 03             	cmp    $0x3,%eax
  80036f:	0f 84 05 01 00 00    	je     80047a <_main+0x442>
  800375:	83 f8 01             	cmp    $0x1,%eax
  800378:	0f 85 f8 01 00 00    	jne    800576 <_main+0x53e>
		{
		case 1:
		{
			//Check and update Flight1
			sys_waitSemaphore(parentenvID, _flight1CS);
  80037e:	83 ec 08             	sub    $0x8,%esp
  800381:	8d 85 f3 fe ff ff    	lea    -0x10d(%ebp),%eax
  800387:	50                   	push   %eax
  800388:	ff 75 e4             	pushl  -0x1c(%ebp)
  80038b:	e8 b5 1b 00 00       	call   801f45 <sys_waitSemaphore>
  800390:	83 c4 10             	add    $0x10,%esp
			{
				if(*flight1Counter > 0)
  800393:	8b 45 dc             	mov    -0x24(%ebp),%eax
  800396:	8b 00                	mov    (%eax),%eax
  800398:	85 c0                	test   %eax,%eax
  80039a:	7e 46                	jle    8003e2 <_main+0x3aa>
				{
					*flight1Counter = *flight1Counter - 1;
  80039c:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80039f:	8b 00                	mov    (%eax),%eax
  8003a1:	8d 50 ff             	lea    -0x1(%eax),%edx
  8003a4:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8003a7:	89 10                	mov    %edx,(%eax)
					customers[custId].booked = 1;
  8003a9:	8b 45 bc             	mov    -0x44(%ebp),%eax
  8003ac:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
  8003b3:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8003b6:	01 d0                	add    %edx,%eax
  8003b8:	c7 40 04 01 00 00 00 	movl   $0x1,0x4(%eax)
					flight1BookedArr[*flight1BookedCounter] = custId;
  8003bf:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8003c2:	8b 00                	mov    (%eax),%eax
  8003c4:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8003cb:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8003ce:	01 c2                	add    %eax,%edx
  8003d0:	8b 45 bc             	mov    -0x44(%ebp),%eax
  8003d3:	89 02                	mov    %eax,(%edx)
					*flight1BookedCounter =*flight1BookedCounter+1;
  8003d5:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8003d8:	8b 00                	mov    (%eax),%eax
  8003da:	8d 50 01             	lea    0x1(%eax),%edx
  8003dd:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8003e0:	89 10                	mov    %edx,(%eax)
				else
				{

				}
			}
			sys_signalSemaphore(parentenvID, _flight1CS);
  8003e2:	83 ec 08             	sub    $0x8,%esp
  8003e5:	8d 85 f3 fe ff ff    	lea    -0x10d(%ebp),%eax
  8003eb:	50                   	push   %eax
  8003ec:	ff 75 e4             	pushl  -0x1c(%ebp)
  8003ef:	e8 6f 1b 00 00       	call   801f63 <sys_signalSemaphore>
  8003f4:	83 c4 10             	add    $0x10,%esp
		}

		break;
  8003f7:	e9 91 01 00 00       	jmp    80058d <_main+0x555>
		case 2:
		{
			//Check and update Flight2
			sys_waitSemaphore(parentenvID, _flight2CS);
  8003fc:	83 ec 08             	sub    $0x8,%esp
  8003ff:	8d 85 e9 fe ff ff    	lea    -0x117(%ebp),%eax
  800405:	50                   	push   %eax
  800406:	ff 75 e4             	pushl  -0x1c(%ebp)
  800409:	e8 37 1b 00 00       	call   801f45 <sys_waitSemaphore>
  80040e:	83 c4 10             	add    $0x10,%esp
			{
				if(*flight2Counter > 0)
  800411:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800414:	8b 00                	mov    (%eax),%eax
  800416:	85 c0                	test   %eax,%eax
  800418:	7e 46                	jle    800460 <_main+0x428>
				{
					*flight2Counter = *flight2Counter - 1;
  80041a:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80041d:	8b 00                	mov    (%eax),%eax
  80041f:	8d 50 ff             	lea    -0x1(%eax),%edx
  800422:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800425:	89 10                	mov    %edx,(%eax)
					customers[custId].booked = 1;
  800427:	8b 45 bc             	mov    -0x44(%ebp),%eax
  80042a:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
  800431:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800434:	01 d0                	add    %edx,%eax
  800436:	c7 40 04 01 00 00 00 	movl   $0x1,0x4(%eax)
					flight2BookedArr[*flight2BookedCounter] = custId;
  80043d:	8b 45 d0             	mov    -0x30(%ebp),%eax
  800440:	8b 00                	mov    (%eax),%eax
  800442:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800449:	8b 45 c8             	mov    -0x38(%ebp),%eax
  80044c:	01 c2                	add    %eax,%edx
  80044e:	8b 45 bc             	mov    -0x44(%ebp),%eax
  800451:	89 02                	mov    %eax,(%edx)
					*flight2BookedCounter =*flight2BookedCounter+1;
  800453:	8b 45 d0             	mov    -0x30(%ebp),%eax
  800456:	8b 00                	mov    (%eax),%eax
  800458:	8d 50 01             	lea    0x1(%eax),%edx
  80045b:	8b 45 d0             	mov    -0x30(%ebp),%eax
  80045e:	89 10                	mov    %edx,(%eax)
				else
				{

				}
			}
			sys_signalSemaphore(parentenvID, _flight2CS);
  800460:	83 ec 08             	sub    $0x8,%esp
  800463:	8d 85 e9 fe ff ff    	lea    -0x117(%ebp),%eax
  800469:	50                   	push   %eax
  80046a:	ff 75 e4             	pushl  -0x1c(%ebp)
  80046d:	e8 f1 1a 00 00       	call   801f63 <sys_signalSemaphore>
  800472:	83 c4 10             	add    $0x10,%esp
		}
		break;
  800475:	e9 13 01 00 00       	jmp    80058d <_main+0x555>
		case 3:
		{
			//Check and update Both Flights
			sys_waitSemaphore(parentenvID, _flight1CS); sys_waitSemaphore(parentenvID, _flight2CS);
  80047a:	83 ec 08             	sub    $0x8,%esp
  80047d:	8d 85 f3 fe ff ff    	lea    -0x10d(%ebp),%eax
  800483:	50                   	push   %eax
  800484:	ff 75 e4             	pushl  -0x1c(%ebp)
  800487:	e8 b9 1a 00 00       	call   801f45 <sys_waitSemaphore>
  80048c:	83 c4 10             	add    $0x10,%esp
  80048f:	83 ec 08             	sub    $0x8,%esp
  800492:	8d 85 e9 fe ff ff    	lea    -0x117(%ebp),%eax
  800498:	50                   	push   %eax
  800499:	ff 75 e4             	pushl  -0x1c(%ebp)
  80049c:	e8 a4 1a 00 00       	call   801f45 <sys_waitSemaphore>
  8004a1:	83 c4 10             	add    $0x10,%esp
			{
				if(*flight1Counter > 0 && *flight2Counter >0 )
  8004a4:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8004a7:	8b 00                	mov    (%eax),%eax
  8004a9:	85 c0                	test   %eax,%eax
  8004ab:	0f 8e 99 00 00 00    	jle    80054a <_main+0x512>
  8004b1:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8004b4:	8b 00                	mov    (%eax),%eax
  8004b6:	85 c0                	test   %eax,%eax
  8004b8:	0f 8e 8c 00 00 00    	jle    80054a <_main+0x512>
				{
					*flight1Counter = *flight1Counter - 1;
  8004be:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8004c1:	8b 00                	mov    (%eax),%eax
  8004c3:	8d 50 ff             	lea    -0x1(%eax),%edx
  8004c6:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8004c9:	89 10                	mov    %edx,(%eax)
					customers[custId].booked = 1;
  8004cb:	8b 45 bc             	mov    -0x44(%ebp),%eax
  8004ce:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
  8004d5:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8004d8:	01 d0                	add    %edx,%eax
  8004da:	c7 40 04 01 00 00 00 	movl   $0x1,0x4(%eax)
					flight1BookedArr[*flight1BookedCounter] = custId;
  8004e1:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8004e4:	8b 00                	mov    (%eax),%eax
  8004e6:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8004ed:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8004f0:	01 c2                	add    %eax,%edx
  8004f2:	8b 45 bc             	mov    -0x44(%ebp),%eax
  8004f5:	89 02                	mov    %eax,(%edx)
					*flight1BookedCounter =*flight1BookedCounter+1;
  8004f7:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8004fa:	8b 00                	mov    (%eax),%eax
  8004fc:	8d 50 01             	lea    0x1(%eax),%edx
  8004ff:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  800502:	89 10                	mov    %edx,(%eax)

					*flight2Counter = *flight2Counter - 1;
  800504:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800507:	8b 00                	mov    (%eax),%eax
  800509:	8d 50 ff             	lea    -0x1(%eax),%edx
  80050c:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80050f:	89 10                	mov    %edx,(%eax)
					customers[custId].booked = 1;
  800511:	8b 45 bc             	mov    -0x44(%ebp),%eax
  800514:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
  80051b:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80051e:	01 d0                	add    %edx,%eax
  800520:	c7 40 04 01 00 00 00 	movl   $0x1,0x4(%eax)
					flight2BookedArr[*flight2BookedCounter] = custId;
  800527:	8b 45 d0             	mov    -0x30(%ebp),%eax
  80052a:	8b 00                	mov    (%eax),%eax
  80052c:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800533:	8b 45 c8             	mov    -0x38(%ebp),%eax
  800536:	01 c2                	add    %eax,%edx
  800538:	8b 45 bc             	mov    -0x44(%ebp),%eax
  80053b:	89 02                	mov    %eax,(%edx)
					*flight2BookedCounter =*flight2BookedCounter+1;
  80053d:	8b 45 d0             	mov    -0x30(%ebp),%eax
  800540:	8b 00                	mov    (%eax),%eax
  800542:	8d 50 01             	lea    0x1(%eax),%edx
  800545:	8b 45 d0             	mov    -0x30(%ebp),%eax
  800548:	89 10                	mov    %edx,(%eax)
				else
				{

				}
			}
			sys_signalSemaphore(parentenvID, _flight2CS); sys_signalSemaphore(parentenvID, _flight1CS);
  80054a:	83 ec 08             	sub    $0x8,%esp
  80054d:	8d 85 e9 fe ff ff    	lea    -0x117(%ebp),%eax
  800553:	50                   	push   %eax
  800554:	ff 75 e4             	pushl  -0x1c(%ebp)
  800557:	e8 07 1a 00 00       	call   801f63 <sys_signalSemaphore>
  80055c:	83 c4 10             	add    $0x10,%esp
  80055f:	83 ec 08             	sub    $0x8,%esp
  800562:	8d 85 f3 fe ff ff    	lea    -0x10d(%ebp),%eax
  800568:	50                   	push   %eax
  800569:	ff 75 e4             	pushl  -0x1c(%ebp)
  80056c:	e8 f2 19 00 00       	call   801f63 <sys_signalSemaphore>
  800571:	83 c4 10             	add    $0x10,%esp
		}
		break;
  800574:	eb 17                	jmp    80058d <_main+0x555>
		default:
			panic("customer must have flight type\n");
  800576:	83 ec 04             	sub    $0x4,%esp
  800579:	68 a0 35 80 00       	push   $0x8035a0
  80057e:	68 8f 00 00 00       	push   $0x8f
  800583:	68 c0 35 80 00       	push   $0x8035c0
  800588:	e8 cc 01 00 00       	call   800759 <_panic>
		}

		//signal finished
		char prefix[30]="cust_finished";
  80058d:	8d 85 9a fe ff ff    	lea    -0x166(%ebp),%eax
  800593:	bb cf 36 80 00       	mov    $0x8036cf,%ebx
  800598:	ba 0e 00 00 00       	mov    $0xe,%edx
  80059d:	89 c7                	mov    %eax,%edi
  80059f:	89 de                	mov    %ebx,%esi
  8005a1:	89 d1                	mov    %edx,%ecx
  8005a3:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
  8005a5:	8d 95 a8 fe ff ff    	lea    -0x158(%ebp),%edx
  8005ab:	b9 04 00 00 00       	mov    $0x4,%ecx
  8005b0:	b8 00 00 00 00       	mov    $0x0,%eax
  8005b5:	89 d7                	mov    %edx,%edi
  8005b7:	f3 ab                	rep stos %eax,%es:(%edi)
		char id[5]; char sname[50];
		ltostr(custId, id);
  8005b9:	83 ec 08             	sub    $0x8,%esp
  8005bc:	8d 85 95 fe ff ff    	lea    -0x16b(%ebp),%eax
  8005c2:	50                   	push   %eax
  8005c3:	ff 75 bc             	pushl  -0x44(%ebp)
  8005c6:	e8 6a 0f 00 00       	call   801535 <ltostr>
  8005cb:	83 c4 10             	add    $0x10,%esp
		strcconcat(prefix, id, sname);
  8005ce:	83 ec 04             	sub    $0x4,%esp
  8005d1:	8d 85 63 fe ff ff    	lea    -0x19d(%ebp),%eax
  8005d7:	50                   	push   %eax
  8005d8:	8d 85 95 fe ff ff    	lea    -0x16b(%ebp),%eax
  8005de:	50                   	push   %eax
  8005df:	8d 85 9a fe ff ff    	lea    -0x166(%ebp),%eax
  8005e5:	50                   	push   %eax
  8005e6:	e8 42 10 00 00       	call   80162d <strcconcat>
  8005eb:	83 c4 10             	add    $0x10,%esp
		sys_signalSemaphore(parentenvID, sname);
  8005ee:	83 ec 08             	sub    $0x8,%esp
  8005f1:	8d 85 63 fe ff ff    	lea    -0x19d(%ebp),%eax
  8005f7:	50                   	push   %eax
  8005f8:	ff 75 e4             	pushl  -0x1c(%ebp)
  8005fb:	e8 63 19 00 00       	call   801f63 <sys_signalSemaphore>
  800600:	83 c4 10             	add    $0x10,%esp

		//signal the clerk
		sys_signalSemaphore(parentenvID, _clerk);
  800603:	83 ec 08             	sub    $0x8,%esp
  800606:	8d 85 e3 fe ff ff    	lea    -0x11d(%ebp),%eax
  80060c:	50                   	push   %eax
  80060d:	ff 75 e4             	pushl  -0x1c(%ebp)
  800610:	e8 4e 19 00 00       	call   801f63 <sys_signalSemaphore>
  800615:	83 c4 10             	add    $0x10,%esp
	}
  800618:	e9 cd fc ff ff       	jmp    8002ea <_main+0x2b2>

0080061d <libmain>:
volatile struct Env *myEnv = NULL;
volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";

void
libmain(int argc, char **argv)
{
  80061d:	55                   	push   %ebp
  80061e:	89 e5                	mov    %esp,%ebp
  800620:	83 ec 18             	sub    $0x18,%esp
	int envIndex = sys_getenvindex();
  800623:	e8 63 1a 00 00       	call   80208b <sys_getenvindex>
  800628:	89 45 f4             	mov    %eax,-0xc(%ebp)
	myEnv = &(envs[envIndex]);
  80062b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80062e:	89 d0                	mov    %edx,%eax
  800630:	c1 e0 03             	shl    $0x3,%eax
  800633:	01 d0                	add    %edx,%eax
  800635:	01 c0                	add    %eax,%eax
  800637:	01 d0                	add    %edx,%eax
  800639:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800640:	01 d0                	add    %edx,%eax
  800642:	c1 e0 04             	shl    $0x4,%eax
  800645:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  80064a:	a3 20 40 80 00       	mov    %eax,0x804020

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  80064f:	a1 20 40 80 00       	mov    0x804020,%eax
  800654:	8a 80 5c 05 00 00    	mov    0x55c(%eax),%al
  80065a:	84 c0                	test   %al,%al
  80065c:	74 0f                	je     80066d <libmain+0x50>
		binaryname = myEnv->prog_name;
  80065e:	a1 20 40 80 00       	mov    0x804020,%eax
  800663:	05 5c 05 00 00       	add    $0x55c,%eax
  800668:	a3 00 40 80 00       	mov    %eax,0x804000

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  80066d:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800671:	7e 0a                	jle    80067d <libmain+0x60>
		binaryname = argv[0];
  800673:	8b 45 0c             	mov    0xc(%ebp),%eax
  800676:	8b 00                	mov    (%eax),%eax
  800678:	a3 00 40 80 00       	mov    %eax,0x804000

	// call user main routine
	_main(argc, argv);
  80067d:	83 ec 08             	sub    $0x8,%esp
  800680:	ff 75 0c             	pushl  0xc(%ebp)
  800683:	ff 75 08             	pushl  0x8(%ebp)
  800686:	e8 ad f9 ff ff       	call   800038 <_main>
  80068b:	83 c4 10             	add    $0x10,%esp



	sys_disable_interrupt();
  80068e:	e8 05 18 00 00       	call   801e98 <sys_disable_interrupt>
	cprintf("**************************************\n");
  800693:	83 ec 0c             	sub    $0xc,%esp
  800696:	68 08 37 80 00       	push   $0x803708
  80069b:	e8 6d 03 00 00       	call   800a0d <cprintf>
  8006a0:	83 c4 10             	add    $0x10,%esp
	cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  8006a3:	a1 20 40 80 00       	mov    0x804020,%eax
  8006a8:	8b 90 44 05 00 00    	mov    0x544(%eax),%edx
  8006ae:	a1 20 40 80 00       	mov    0x804020,%eax
  8006b3:	8b 80 34 05 00 00    	mov    0x534(%eax),%eax
  8006b9:	83 ec 04             	sub    $0x4,%esp
  8006bc:	52                   	push   %edx
  8006bd:	50                   	push   %eax
  8006be:	68 30 37 80 00       	push   $0x803730
  8006c3:	e8 45 03 00 00       	call   800a0d <cprintf>
  8006c8:	83 c4 10             	add    $0x10,%esp
	cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  8006cb:	a1 20 40 80 00       	mov    0x804020,%eax
  8006d0:	8b 88 54 05 00 00    	mov    0x554(%eax),%ecx
  8006d6:	a1 20 40 80 00       	mov    0x804020,%eax
  8006db:	8b 90 50 05 00 00    	mov    0x550(%eax),%edx
  8006e1:	a1 20 40 80 00       	mov    0x804020,%eax
  8006e6:	8b 80 4c 05 00 00    	mov    0x54c(%eax),%eax
  8006ec:	51                   	push   %ecx
  8006ed:	52                   	push   %edx
  8006ee:	50                   	push   %eax
  8006ef:	68 58 37 80 00       	push   $0x803758
  8006f4:	e8 14 03 00 00       	call   800a0d <cprintf>
  8006f9:	83 c4 10             	add    $0x10,%esp
	//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
	cprintf("Num of clocks = %d\n", myEnv->nClocks);
  8006fc:	a1 20 40 80 00       	mov    0x804020,%eax
  800701:	8b 80 a4 05 00 00    	mov    0x5a4(%eax),%eax
  800707:	83 ec 08             	sub    $0x8,%esp
  80070a:	50                   	push   %eax
  80070b:	68 b0 37 80 00       	push   $0x8037b0
  800710:	e8 f8 02 00 00       	call   800a0d <cprintf>
  800715:	83 c4 10             	add    $0x10,%esp
	cprintf("**************************************\n");
  800718:	83 ec 0c             	sub    $0xc,%esp
  80071b:	68 08 37 80 00       	push   $0x803708
  800720:	e8 e8 02 00 00       	call   800a0d <cprintf>
  800725:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  800728:	e8 85 17 00 00       	call   801eb2 <sys_enable_interrupt>

	// exit gracefully
	exit();
  80072d:	e8 19 00 00 00       	call   80074b <exit>
}
  800732:	90                   	nop
  800733:	c9                   	leave  
  800734:	c3                   	ret    

00800735 <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  800735:	55                   	push   %ebp
  800736:	89 e5                	mov    %esp,%ebp
  800738:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  80073b:	83 ec 0c             	sub    $0xc,%esp
  80073e:	6a 00                	push   $0x0
  800740:	e8 12 19 00 00       	call   802057 <sys_destroy_env>
  800745:	83 c4 10             	add    $0x10,%esp
}
  800748:	90                   	nop
  800749:	c9                   	leave  
  80074a:	c3                   	ret    

0080074b <exit>:

void
exit(void)
{
  80074b:	55                   	push   %ebp
  80074c:	89 e5                	mov    %esp,%ebp
  80074e:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  800751:	e8 67 19 00 00       	call   8020bd <sys_exit_env>
}
  800756:	90                   	nop
  800757:	c9                   	leave  
  800758:	c3                   	ret    

00800759 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  800759:	55                   	push   %ebp
  80075a:	89 e5                	mov    %esp,%ebp
  80075c:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  80075f:	8d 45 10             	lea    0x10(%ebp),%eax
  800762:	83 c0 04             	add    $0x4,%eax
  800765:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  800768:	a1 5c 41 80 00       	mov    0x80415c,%eax
  80076d:	85 c0                	test   %eax,%eax
  80076f:	74 16                	je     800787 <_panic+0x2e>
		cprintf("%s: ", argv0);
  800771:	a1 5c 41 80 00       	mov    0x80415c,%eax
  800776:	83 ec 08             	sub    $0x8,%esp
  800779:	50                   	push   %eax
  80077a:	68 c4 37 80 00       	push   $0x8037c4
  80077f:	e8 89 02 00 00       	call   800a0d <cprintf>
  800784:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  800787:	a1 00 40 80 00       	mov    0x804000,%eax
  80078c:	ff 75 0c             	pushl  0xc(%ebp)
  80078f:	ff 75 08             	pushl  0x8(%ebp)
  800792:	50                   	push   %eax
  800793:	68 c9 37 80 00       	push   $0x8037c9
  800798:	e8 70 02 00 00       	call   800a0d <cprintf>
  80079d:	83 c4 10             	add    $0x10,%esp
	vcprintf(fmt, ap);
  8007a0:	8b 45 10             	mov    0x10(%ebp),%eax
  8007a3:	83 ec 08             	sub    $0x8,%esp
  8007a6:	ff 75 f4             	pushl  -0xc(%ebp)
  8007a9:	50                   	push   %eax
  8007aa:	e8 f3 01 00 00       	call   8009a2 <vcprintf>
  8007af:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  8007b2:	83 ec 08             	sub    $0x8,%esp
  8007b5:	6a 00                	push   $0x0
  8007b7:	68 e5 37 80 00       	push   $0x8037e5
  8007bc:	e8 e1 01 00 00       	call   8009a2 <vcprintf>
  8007c1:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  8007c4:	e8 82 ff ff ff       	call   80074b <exit>

	// should not return here
	while (1) ;
  8007c9:	eb fe                	jmp    8007c9 <_panic+0x70>

008007cb <CheckWSWithoutLastIndex>:
}

void CheckWSWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  8007cb:	55                   	push   %ebp
  8007cc:	89 e5                	mov    %esp,%ebp
  8007ce:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  8007d1:	a1 20 40 80 00       	mov    0x804020,%eax
  8007d6:	8b 50 74             	mov    0x74(%eax),%edx
  8007d9:	8b 45 0c             	mov    0xc(%ebp),%eax
  8007dc:	39 c2                	cmp    %eax,%edx
  8007de:	74 14                	je     8007f4 <CheckWSWithoutLastIndex+0x29>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  8007e0:	83 ec 04             	sub    $0x4,%esp
  8007e3:	68 e8 37 80 00       	push   $0x8037e8
  8007e8:	6a 26                	push   $0x26
  8007ea:	68 34 38 80 00       	push   $0x803834
  8007ef:	e8 65 ff ff ff       	call   800759 <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  8007f4:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  8007fb:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800802:	e9 c2 00 00 00       	jmp    8008c9 <CheckWSWithoutLastIndex+0xfe>
		if (expectedPages[e] == 0) {
  800807:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80080a:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800811:	8b 45 08             	mov    0x8(%ebp),%eax
  800814:	01 d0                	add    %edx,%eax
  800816:	8b 00                	mov    (%eax),%eax
  800818:	85 c0                	test   %eax,%eax
  80081a:	75 08                	jne    800824 <CheckWSWithoutLastIndex+0x59>
			expectedNumOfEmptyLocs++;
  80081c:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  80081f:	e9 a2 00 00 00       	jmp    8008c6 <CheckWSWithoutLastIndex+0xfb>
		}
		int found = 0;
  800824:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  80082b:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  800832:	eb 69                	jmp    80089d <CheckWSWithoutLastIndex+0xd2>
			if (myEnv->__uptr_pws[w].empty == 0) {
  800834:	a1 20 40 80 00       	mov    0x804020,%eax
  800839:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  80083f:	8b 55 e8             	mov    -0x18(%ebp),%edx
  800842:	89 d0                	mov    %edx,%eax
  800844:	01 c0                	add    %eax,%eax
  800846:	01 d0                	add    %edx,%eax
  800848:	c1 e0 03             	shl    $0x3,%eax
  80084b:	01 c8                	add    %ecx,%eax
  80084d:	8a 40 04             	mov    0x4(%eax),%al
  800850:	84 c0                	test   %al,%al
  800852:	75 46                	jne    80089a <CheckWSWithoutLastIndex+0xcf>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  800854:	a1 20 40 80 00       	mov    0x804020,%eax
  800859:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  80085f:	8b 55 e8             	mov    -0x18(%ebp),%edx
  800862:	89 d0                	mov    %edx,%eax
  800864:	01 c0                	add    %eax,%eax
  800866:	01 d0                	add    %edx,%eax
  800868:	c1 e0 03             	shl    $0x3,%eax
  80086b:	01 c8                	add    %ecx,%eax
  80086d:	8b 00                	mov    (%eax),%eax
  80086f:	89 45 dc             	mov    %eax,-0x24(%ebp)
  800872:	8b 45 dc             	mov    -0x24(%ebp),%eax
  800875:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  80087a:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  80087c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80087f:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  800886:	8b 45 08             	mov    0x8(%ebp),%eax
  800889:	01 c8                	add    %ecx,%eax
  80088b:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  80088d:	39 c2                	cmp    %eax,%edx
  80088f:	75 09                	jne    80089a <CheckWSWithoutLastIndex+0xcf>
						== expectedPages[e]) {
					found = 1;
  800891:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  800898:	eb 12                	jmp    8008ac <CheckWSWithoutLastIndex+0xe1>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  80089a:	ff 45 e8             	incl   -0x18(%ebp)
  80089d:	a1 20 40 80 00       	mov    0x804020,%eax
  8008a2:	8b 50 74             	mov    0x74(%eax),%edx
  8008a5:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8008a8:	39 c2                	cmp    %eax,%edx
  8008aa:	77 88                	ja     800834 <CheckWSWithoutLastIndex+0x69>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  8008ac:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8008b0:	75 14                	jne    8008c6 <CheckWSWithoutLastIndex+0xfb>
			panic(
  8008b2:	83 ec 04             	sub    $0x4,%esp
  8008b5:	68 40 38 80 00       	push   $0x803840
  8008ba:	6a 3a                	push   $0x3a
  8008bc:	68 34 38 80 00       	push   $0x803834
  8008c1:	e8 93 fe ff ff       	call   800759 <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  8008c6:	ff 45 f0             	incl   -0x10(%ebp)
  8008c9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8008cc:	3b 45 0c             	cmp    0xc(%ebp),%eax
  8008cf:	0f 8c 32 ff ff ff    	jl     800807 <CheckWSWithoutLastIndex+0x3c>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  8008d5:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8008dc:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  8008e3:	eb 26                	jmp    80090b <CheckWSWithoutLastIndex+0x140>
		if (myEnv->__uptr_pws[w].empty == 1) {
  8008e5:	a1 20 40 80 00       	mov    0x804020,%eax
  8008ea:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  8008f0:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8008f3:	89 d0                	mov    %edx,%eax
  8008f5:	01 c0                	add    %eax,%eax
  8008f7:	01 d0                	add    %edx,%eax
  8008f9:	c1 e0 03             	shl    $0x3,%eax
  8008fc:	01 c8                	add    %ecx,%eax
  8008fe:	8a 40 04             	mov    0x4(%eax),%al
  800901:	3c 01                	cmp    $0x1,%al
  800903:	75 03                	jne    800908 <CheckWSWithoutLastIndex+0x13d>
			actualNumOfEmptyLocs++;
  800905:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800908:	ff 45 e0             	incl   -0x20(%ebp)
  80090b:	a1 20 40 80 00       	mov    0x804020,%eax
  800910:	8b 50 74             	mov    0x74(%eax),%edx
  800913:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800916:	39 c2                	cmp    %eax,%edx
  800918:	77 cb                	ja     8008e5 <CheckWSWithoutLastIndex+0x11a>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  80091a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80091d:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  800920:	74 14                	je     800936 <CheckWSWithoutLastIndex+0x16b>
		panic(
  800922:	83 ec 04             	sub    $0x4,%esp
  800925:	68 94 38 80 00       	push   $0x803894
  80092a:	6a 44                	push   $0x44
  80092c:	68 34 38 80 00       	push   $0x803834
  800931:	e8 23 fe ff ff       	call   800759 <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  800936:	90                   	nop
  800937:	c9                   	leave  
  800938:	c3                   	ret    

00800939 <putch>:
};

//2017:
uint8 printProgName = 0;

static void putch(int ch, struct printbuf *b) {
  800939:	55                   	push   %ebp
  80093a:	89 e5                	mov    %esp,%ebp
  80093c:	83 ec 08             	sub    $0x8,%esp
	b->buf[b->idx++] = ch;
  80093f:	8b 45 0c             	mov    0xc(%ebp),%eax
  800942:	8b 00                	mov    (%eax),%eax
  800944:	8d 48 01             	lea    0x1(%eax),%ecx
  800947:	8b 55 0c             	mov    0xc(%ebp),%edx
  80094a:	89 0a                	mov    %ecx,(%edx)
  80094c:	8b 55 08             	mov    0x8(%ebp),%edx
  80094f:	88 d1                	mov    %dl,%cl
  800951:	8b 55 0c             	mov    0xc(%ebp),%edx
  800954:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  800958:	8b 45 0c             	mov    0xc(%ebp),%eax
  80095b:	8b 00                	mov    (%eax),%eax
  80095d:	3d ff 00 00 00       	cmp    $0xff,%eax
  800962:	75 2c                	jne    800990 <putch+0x57>
		sys_cputs(b->buf, b->idx, printProgName);
  800964:	a0 24 40 80 00       	mov    0x804024,%al
  800969:	0f b6 c0             	movzbl %al,%eax
  80096c:	8b 55 0c             	mov    0xc(%ebp),%edx
  80096f:	8b 12                	mov    (%edx),%edx
  800971:	89 d1                	mov    %edx,%ecx
  800973:	8b 55 0c             	mov    0xc(%ebp),%edx
  800976:	83 c2 08             	add    $0x8,%edx
  800979:	83 ec 04             	sub    $0x4,%esp
  80097c:	50                   	push   %eax
  80097d:	51                   	push   %ecx
  80097e:	52                   	push   %edx
  80097f:	e8 66 13 00 00       	call   801cea <sys_cputs>
  800984:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  800987:	8b 45 0c             	mov    0xc(%ebp),%eax
  80098a:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  800990:	8b 45 0c             	mov    0xc(%ebp),%eax
  800993:	8b 40 04             	mov    0x4(%eax),%eax
  800996:	8d 50 01             	lea    0x1(%eax),%edx
  800999:	8b 45 0c             	mov    0xc(%ebp),%eax
  80099c:	89 50 04             	mov    %edx,0x4(%eax)
}
  80099f:	90                   	nop
  8009a0:	c9                   	leave  
  8009a1:	c3                   	ret    

008009a2 <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  8009a2:	55                   	push   %ebp
  8009a3:	89 e5                	mov    %esp,%ebp
  8009a5:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  8009ab:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  8009b2:	00 00 00 
	b.cnt = 0;
  8009b5:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  8009bc:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  8009bf:	ff 75 0c             	pushl  0xc(%ebp)
  8009c2:	ff 75 08             	pushl  0x8(%ebp)
  8009c5:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  8009cb:	50                   	push   %eax
  8009cc:	68 39 09 80 00       	push   $0x800939
  8009d1:	e8 11 02 00 00       	call   800be7 <vprintfmt>
  8009d6:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName);
  8009d9:	a0 24 40 80 00       	mov    0x804024,%al
  8009de:	0f b6 c0             	movzbl %al,%eax
  8009e1:	8b 95 f0 fe ff ff    	mov    -0x110(%ebp),%edx
  8009e7:	83 ec 04             	sub    $0x4,%esp
  8009ea:	50                   	push   %eax
  8009eb:	52                   	push   %edx
  8009ec:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  8009f2:	83 c0 08             	add    $0x8,%eax
  8009f5:	50                   	push   %eax
  8009f6:	e8 ef 12 00 00       	call   801cea <sys_cputs>
  8009fb:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  8009fe:	c6 05 24 40 80 00 00 	movb   $0x0,0x804024
	return b.cnt;
  800a05:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  800a0b:	c9                   	leave  
  800a0c:	c3                   	ret    

00800a0d <cprintf>:

int cprintf(const char *fmt, ...) {
  800a0d:	55                   	push   %ebp
  800a0e:	89 e5                	mov    %esp,%ebp
  800a10:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  800a13:	c6 05 24 40 80 00 01 	movb   $0x1,0x804024
	va_start(ap, fmt);
  800a1a:	8d 45 0c             	lea    0xc(%ebp),%eax
  800a1d:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800a20:	8b 45 08             	mov    0x8(%ebp),%eax
  800a23:	83 ec 08             	sub    $0x8,%esp
  800a26:	ff 75 f4             	pushl  -0xc(%ebp)
  800a29:	50                   	push   %eax
  800a2a:	e8 73 ff ff ff       	call   8009a2 <vcprintf>
  800a2f:	83 c4 10             	add    $0x10,%esp
  800a32:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  800a35:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800a38:	c9                   	leave  
  800a39:	c3                   	ret    

00800a3a <atomic_cprintf>:

int atomic_cprintf(const char *fmt, ...) {
  800a3a:	55                   	push   %ebp
  800a3b:	89 e5                	mov    %esp,%ebp
  800a3d:	83 ec 18             	sub    $0x18,%esp
	sys_disable_interrupt();
  800a40:	e8 53 14 00 00       	call   801e98 <sys_disable_interrupt>
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  800a45:	8d 45 0c             	lea    0xc(%ebp),%eax
  800a48:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800a4b:	8b 45 08             	mov    0x8(%ebp),%eax
  800a4e:	83 ec 08             	sub    $0x8,%esp
  800a51:	ff 75 f4             	pushl  -0xc(%ebp)
  800a54:	50                   	push   %eax
  800a55:	e8 48 ff ff ff       	call   8009a2 <vcprintf>
  800a5a:	83 c4 10             	add    $0x10,%esp
  800a5d:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	sys_enable_interrupt();
  800a60:	e8 4d 14 00 00       	call   801eb2 <sys_enable_interrupt>
	return cnt;
  800a65:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800a68:	c9                   	leave  
  800a69:	c3                   	ret    

00800a6a <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800a6a:	55                   	push   %ebp
  800a6b:	89 e5                	mov    %esp,%ebp
  800a6d:	53                   	push   %ebx
  800a6e:	83 ec 14             	sub    $0x14,%esp
  800a71:	8b 45 10             	mov    0x10(%ebp),%eax
  800a74:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800a77:	8b 45 14             	mov    0x14(%ebp),%eax
  800a7a:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800a7d:	8b 45 18             	mov    0x18(%ebp),%eax
  800a80:	ba 00 00 00 00       	mov    $0x0,%edx
  800a85:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800a88:	77 55                	ja     800adf <printnum+0x75>
  800a8a:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800a8d:	72 05                	jb     800a94 <printnum+0x2a>
  800a8f:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  800a92:	77 4b                	ja     800adf <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800a94:	8b 45 1c             	mov    0x1c(%ebp),%eax
  800a97:	8d 58 ff             	lea    -0x1(%eax),%ebx
  800a9a:	8b 45 18             	mov    0x18(%ebp),%eax
  800a9d:	ba 00 00 00 00       	mov    $0x0,%edx
  800aa2:	52                   	push   %edx
  800aa3:	50                   	push   %eax
  800aa4:	ff 75 f4             	pushl  -0xc(%ebp)
  800aa7:	ff 75 f0             	pushl  -0x10(%ebp)
  800aaa:	e8 85 28 00 00       	call   803334 <__udivdi3>
  800aaf:	83 c4 10             	add    $0x10,%esp
  800ab2:	83 ec 04             	sub    $0x4,%esp
  800ab5:	ff 75 20             	pushl  0x20(%ebp)
  800ab8:	53                   	push   %ebx
  800ab9:	ff 75 18             	pushl  0x18(%ebp)
  800abc:	52                   	push   %edx
  800abd:	50                   	push   %eax
  800abe:	ff 75 0c             	pushl  0xc(%ebp)
  800ac1:	ff 75 08             	pushl  0x8(%ebp)
  800ac4:	e8 a1 ff ff ff       	call   800a6a <printnum>
  800ac9:	83 c4 20             	add    $0x20,%esp
  800acc:	eb 1a                	jmp    800ae8 <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  800ace:	83 ec 08             	sub    $0x8,%esp
  800ad1:	ff 75 0c             	pushl  0xc(%ebp)
  800ad4:	ff 75 20             	pushl  0x20(%ebp)
  800ad7:	8b 45 08             	mov    0x8(%ebp),%eax
  800ada:	ff d0                	call   *%eax
  800adc:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800adf:	ff 4d 1c             	decl   0x1c(%ebp)
  800ae2:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  800ae6:	7f e6                	jg     800ace <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800ae8:	8b 4d 18             	mov    0x18(%ebp),%ecx
  800aeb:	bb 00 00 00 00       	mov    $0x0,%ebx
  800af0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800af3:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800af6:	53                   	push   %ebx
  800af7:	51                   	push   %ecx
  800af8:	52                   	push   %edx
  800af9:	50                   	push   %eax
  800afa:	e8 45 29 00 00       	call   803444 <__umoddi3>
  800aff:	83 c4 10             	add    $0x10,%esp
  800b02:	05 f4 3a 80 00       	add    $0x803af4,%eax
  800b07:	8a 00                	mov    (%eax),%al
  800b09:	0f be c0             	movsbl %al,%eax
  800b0c:	83 ec 08             	sub    $0x8,%esp
  800b0f:	ff 75 0c             	pushl  0xc(%ebp)
  800b12:	50                   	push   %eax
  800b13:	8b 45 08             	mov    0x8(%ebp),%eax
  800b16:	ff d0                	call   *%eax
  800b18:	83 c4 10             	add    $0x10,%esp
}
  800b1b:	90                   	nop
  800b1c:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800b1f:	c9                   	leave  
  800b20:	c3                   	ret    

00800b21 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  800b21:	55                   	push   %ebp
  800b22:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800b24:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800b28:	7e 1c                	jle    800b46 <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  800b2a:	8b 45 08             	mov    0x8(%ebp),%eax
  800b2d:	8b 00                	mov    (%eax),%eax
  800b2f:	8d 50 08             	lea    0x8(%eax),%edx
  800b32:	8b 45 08             	mov    0x8(%ebp),%eax
  800b35:	89 10                	mov    %edx,(%eax)
  800b37:	8b 45 08             	mov    0x8(%ebp),%eax
  800b3a:	8b 00                	mov    (%eax),%eax
  800b3c:	83 e8 08             	sub    $0x8,%eax
  800b3f:	8b 50 04             	mov    0x4(%eax),%edx
  800b42:	8b 00                	mov    (%eax),%eax
  800b44:	eb 40                	jmp    800b86 <getuint+0x65>
	else if (lflag)
  800b46:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800b4a:	74 1e                	je     800b6a <getuint+0x49>
		return va_arg(*ap, unsigned long);
  800b4c:	8b 45 08             	mov    0x8(%ebp),%eax
  800b4f:	8b 00                	mov    (%eax),%eax
  800b51:	8d 50 04             	lea    0x4(%eax),%edx
  800b54:	8b 45 08             	mov    0x8(%ebp),%eax
  800b57:	89 10                	mov    %edx,(%eax)
  800b59:	8b 45 08             	mov    0x8(%ebp),%eax
  800b5c:	8b 00                	mov    (%eax),%eax
  800b5e:	83 e8 04             	sub    $0x4,%eax
  800b61:	8b 00                	mov    (%eax),%eax
  800b63:	ba 00 00 00 00       	mov    $0x0,%edx
  800b68:	eb 1c                	jmp    800b86 <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  800b6a:	8b 45 08             	mov    0x8(%ebp),%eax
  800b6d:	8b 00                	mov    (%eax),%eax
  800b6f:	8d 50 04             	lea    0x4(%eax),%edx
  800b72:	8b 45 08             	mov    0x8(%ebp),%eax
  800b75:	89 10                	mov    %edx,(%eax)
  800b77:	8b 45 08             	mov    0x8(%ebp),%eax
  800b7a:	8b 00                	mov    (%eax),%eax
  800b7c:	83 e8 04             	sub    $0x4,%eax
  800b7f:	8b 00                	mov    (%eax),%eax
  800b81:	ba 00 00 00 00       	mov    $0x0,%edx
}
  800b86:	5d                   	pop    %ebp
  800b87:	c3                   	ret    

00800b88 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  800b88:	55                   	push   %ebp
  800b89:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800b8b:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800b8f:	7e 1c                	jle    800bad <getint+0x25>
		return va_arg(*ap, long long);
  800b91:	8b 45 08             	mov    0x8(%ebp),%eax
  800b94:	8b 00                	mov    (%eax),%eax
  800b96:	8d 50 08             	lea    0x8(%eax),%edx
  800b99:	8b 45 08             	mov    0x8(%ebp),%eax
  800b9c:	89 10                	mov    %edx,(%eax)
  800b9e:	8b 45 08             	mov    0x8(%ebp),%eax
  800ba1:	8b 00                	mov    (%eax),%eax
  800ba3:	83 e8 08             	sub    $0x8,%eax
  800ba6:	8b 50 04             	mov    0x4(%eax),%edx
  800ba9:	8b 00                	mov    (%eax),%eax
  800bab:	eb 38                	jmp    800be5 <getint+0x5d>
	else if (lflag)
  800bad:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800bb1:	74 1a                	je     800bcd <getint+0x45>
		return va_arg(*ap, long);
  800bb3:	8b 45 08             	mov    0x8(%ebp),%eax
  800bb6:	8b 00                	mov    (%eax),%eax
  800bb8:	8d 50 04             	lea    0x4(%eax),%edx
  800bbb:	8b 45 08             	mov    0x8(%ebp),%eax
  800bbe:	89 10                	mov    %edx,(%eax)
  800bc0:	8b 45 08             	mov    0x8(%ebp),%eax
  800bc3:	8b 00                	mov    (%eax),%eax
  800bc5:	83 e8 04             	sub    $0x4,%eax
  800bc8:	8b 00                	mov    (%eax),%eax
  800bca:	99                   	cltd   
  800bcb:	eb 18                	jmp    800be5 <getint+0x5d>
	else
		return va_arg(*ap, int);
  800bcd:	8b 45 08             	mov    0x8(%ebp),%eax
  800bd0:	8b 00                	mov    (%eax),%eax
  800bd2:	8d 50 04             	lea    0x4(%eax),%edx
  800bd5:	8b 45 08             	mov    0x8(%ebp),%eax
  800bd8:	89 10                	mov    %edx,(%eax)
  800bda:	8b 45 08             	mov    0x8(%ebp),%eax
  800bdd:	8b 00                	mov    (%eax),%eax
  800bdf:	83 e8 04             	sub    $0x4,%eax
  800be2:	8b 00                	mov    (%eax),%eax
  800be4:	99                   	cltd   
}
  800be5:	5d                   	pop    %ebp
  800be6:	c3                   	ret    

00800be7 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  800be7:	55                   	push   %ebp
  800be8:	89 e5                	mov    %esp,%ebp
  800bea:	56                   	push   %esi
  800beb:	53                   	push   %ebx
  800bec:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800bef:	eb 17                	jmp    800c08 <vprintfmt+0x21>
			if (ch == '\0')
  800bf1:	85 db                	test   %ebx,%ebx
  800bf3:	0f 84 af 03 00 00    	je     800fa8 <vprintfmt+0x3c1>
				return;
			putch(ch, putdat);
  800bf9:	83 ec 08             	sub    $0x8,%esp
  800bfc:	ff 75 0c             	pushl  0xc(%ebp)
  800bff:	53                   	push   %ebx
  800c00:	8b 45 08             	mov    0x8(%ebp),%eax
  800c03:	ff d0                	call   *%eax
  800c05:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800c08:	8b 45 10             	mov    0x10(%ebp),%eax
  800c0b:	8d 50 01             	lea    0x1(%eax),%edx
  800c0e:	89 55 10             	mov    %edx,0x10(%ebp)
  800c11:	8a 00                	mov    (%eax),%al
  800c13:	0f b6 d8             	movzbl %al,%ebx
  800c16:	83 fb 25             	cmp    $0x25,%ebx
  800c19:	75 d6                	jne    800bf1 <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  800c1b:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  800c1f:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  800c26:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  800c2d:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  800c34:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800c3b:	8b 45 10             	mov    0x10(%ebp),%eax
  800c3e:	8d 50 01             	lea    0x1(%eax),%edx
  800c41:	89 55 10             	mov    %edx,0x10(%ebp)
  800c44:	8a 00                	mov    (%eax),%al
  800c46:	0f b6 d8             	movzbl %al,%ebx
  800c49:	8d 43 dd             	lea    -0x23(%ebx),%eax
  800c4c:	83 f8 55             	cmp    $0x55,%eax
  800c4f:	0f 87 2b 03 00 00    	ja     800f80 <vprintfmt+0x399>
  800c55:	8b 04 85 18 3b 80 00 	mov    0x803b18(,%eax,4),%eax
  800c5c:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  800c5e:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  800c62:	eb d7                	jmp    800c3b <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  800c64:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  800c68:	eb d1                	jmp    800c3b <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800c6a:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  800c71:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800c74:	89 d0                	mov    %edx,%eax
  800c76:	c1 e0 02             	shl    $0x2,%eax
  800c79:	01 d0                	add    %edx,%eax
  800c7b:	01 c0                	add    %eax,%eax
  800c7d:	01 d8                	add    %ebx,%eax
  800c7f:	83 e8 30             	sub    $0x30,%eax
  800c82:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  800c85:	8b 45 10             	mov    0x10(%ebp),%eax
  800c88:	8a 00                	mov    (%eax),%al
  800c8a:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  800c8d:	83 fb 2f             	cmp    $0x2f,%ebx
  800c90:	7e 3e                	jle    800cd0 <vprintfmt+0xe9>
  800c92:	83 fb 39             	cmp    $0x39,%ebx
  800c95:	7f 39                	jg     800cd0 <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800c97:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  800c9a:	eb d5                	jmp    800c71 <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  800c9c:	8b 45 14             	mov    0x14(%ebp),%eax
  800c9f:	83 c0 04             	add    $0x4,%eax
  800ca2:	89 45 14             	mov    %eax,0x14(%ebp)
  800ca5:	8b 45 14             	mov    0x14(%ebp),%eax
  800ca8:	83 e8 04             	sub    $0x4,%eax
  800cab:	8b 00                	mov    (%eax),%eax
  800cad:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  800cb0:	eb 1f                	jmp    800cd1 <vprintfmt+0xea>

		case '.':
			if (width < 0)
  800cb2:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800cb6:	79 83                	jns    800c3b <vprintfmt+0x54>
				width = 0;
  800cb8:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  800cbf:	e9 77 ff ff ff       	jmp    800c3b <vprintfmt+0x54>

		case '#':
			altflag = 1;
  800cc4:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  800ccb:	e9 6b ff ff ff       	jmp    800c3b <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  800cd0:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  800cd1:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800cd5:	0f 89 60 ff ff ff    	jns    800c3b <vprintfmt+0x54>
				width = precision, precision = -1;
  800cdb:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800cde:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800ce1:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  800ce8:	e9 4e ff ff ff       	jmp    800c3b <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  800ced:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  800cf0:	e9 46 ff ff ff       	jmp    800c3b <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  800cf5:	8b 45 14             	mov    0x14(%ebp),%eax
  800cf8:	83 c0 04             	add    $0x4,%eax
  800cfb:	89 45 14             	mov    %eax,0x14(%ebp)
  800cfe:	8b 45 14             	mov    0x14(%ebp),%eax
  800d01:	83 e8 04             	sub    $0x4,%eax
  800d04:	8b 00                	mov    (%eax),%eax
  800d06:	83 ec 08             	sub    $0x8,%esp
  800d09:	ff 75 0c             	pushl  0xc(%ebp)
  800d0c:	50                   	push   %eax
  800d0d:	8b 45 08             	mov    0x8(%ebp),%eax
  800d10:	ff d0                	call   *%eax
  800d12:	83 c4 10             	add    $0x10,%esp
			break;
  800d15:	e9 89 02 00 00       	jmp    800fa3 <vprintfmt+0x3bc>

		// error message
		case 'e':
			err = va_arg(ap, int);
  800d1a:	8b 45 14             	mov    0x14(%ebp),%eax
  800d1d:	83 c0 04             	add    $0x4,%eax
  800d20:	89 45 14             	mov    %eax,0x14(%ebp)
  800d23:	8b 45 14             	mov    0x14(%ebp),%eax
  800d26:	83 e8 04             	sub    $0x4,%eax
  800d29:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  800d2b:	85 db                	test   %ebx,%ebx
  800d2d:	79 02                	jns    800d31 <vprintfmt+0x14a>
				err = -err;
  800d2f:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  800d31:	83 fb 64             	cmp    $0x64,%ebx
  800d34:	7f 0b                	jg     800d41 <vprintfmt+0x15a>
  800d36:	8b 34 9d 60 39 80 00 	mov    0x803960(,%ebx,4),%esi
  800d3d:	85 f6                	test   %esi,%esi
  800d3f:	75 19                	jne    800d5a <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  800d41:	53                   	push   %ebx
  800d42:	68 05 3b 80 00       	push   $0x803b05
  800d47:	ff 75 0c             	pushl  0xc(%ebp)
  800d4a:	ff 75 08             	pushl  0x8(%ebp)
  800d4d:	e8 5e 02 00 00       	call   800fb0 <printfmt>
  800d52:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  800d55:	e9 49 02 00 00       	jmp    800fa3 <vprintfmt+0x3bc>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  800d5a:	56                   	push   %esi
  800d5b:	68 0e 3b 80 00       	push   $0x803b0e
  800d60:	ff 75 0c             	pushl  0xc(%ebp)
  800d63:	ff 75 08             	pushl  0x8(%ebp)
  800d66:	e8 45 02 00 00       	call   800fb0 <printfmt>
  800d6b:	83 c4 10             	add    $0x10,%esp
			break;
  800d6e:	e9 30 02 00 00       	jmp    800fa3 <vprintfmt+0x3bc>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  800d73:	8b 45 14             	mov    0x14(%ebp),%eax
  800d76:	83 c0 04             	add    $0x4,%eax
  800d79:	89 45 14             	mov    %eax,0x14(%ebp)
  800d7c:	8b 45 14             	mov    0x14(%ebp),%eax
  800d7f:	83 e8 04             	sub    $0x4,%eax
  800d82:	8b 30                	mov    (%eax),%esi
  800d84:	85 f6                	test   %esi,%esi
  800d86:	75 05                	jne    800d8d <vprintfmt+0x1a6>
				p = "(null)";
  800d88:	be 11 3b 80 00       	mov    $0x803b11,%esi
			if (width > 0 && padc != '-')
  800d8d:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800d91:	7e 6d                	jle    800e00 <vprintfmt+0x219>
  800d93:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  800d97:	74 67                	je     800e00 <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  800d99:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800d9c:	83 ec 08             	sub    $0x8,%esp
  800d9f:	50                   	push   %eax
  800da0:	56                   	push   %esi
  800da1:	e8 0c 03 00 00       	call   8010b2 <strnlen>
  800da6:	83 c4 10             	add    $0x10,%esp
  800da9:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  800dac:	eb 16                	jmp    800dc4 <vprintfmt+0x1dd>
					putch(padc, putdat);
  800dae:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  800db2:	83 ec 08             	sub    $0x8,%esp
  800db5:	ff 75 0c             	pushl  0xc(%ebp)
  800db8:	50                   	push   %eax
  800db9:	8b 45 08             	mov    0x8(%ebp),%eax
  800dbc:	ff d0                	call   *%eax
  800dbe:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800dc1:	ff 4d e4             	decl   -0x1c(%ebp)
  800dc4:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800dc8:	7f e4                	jg     800dae <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800dca:	eb 34                	jmp    800e00 <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  800dcc:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  800dd0:	74 1c                	je     800dee <vprintfmt+0x207>
  800dd2:	83 fb 1f             	cmp    $0x1f,%ebx
  800dd5:	7e 05                	jle    800ddc <vprintfmt+0x1f5>
  800dd7:	83 fb 7e             	cmp    $0x7e,%ebx
  800dda:	7e 12                	jle    800dee <vprintfmt+0x207>
					putch('?', putdat);
  800ddc:	83 ec 08             	sub    $0x8,%esp
  800ddf:	ff 75 0c             	pushl  0xc(%ebp)
  800de2:	6a 3f                	push   $0x3f
  800de4:	8b 45 08             	mov    0x8(%ebp),%eax
  800de7:	ff d0                	call   *%eax
  800de9:	83 c4 10             	add    $0x10,%esp
  800dec:	eb 0f                	jmp    800dfd <vprintfmt+0x216>
				else
					putch(ch, putdat);
  800dee:	83 ec 08             	sub    $0x8,%esp
  800df1:	ff 75 0c             	pushl  0xc(%ebp)
  800df4:	53                   	push   %ebx
  800df5:	8b 45 08             	mov    0x8(%ebp),%eax
  800df8:	ff d0                	call   *%eax
  800dfa:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800dfd:	ff 4d e4             	decl   -0x1c(%ebp)
  800e00:	89 f0                	mov    %esi,%eax
  800e02:	8d 70 01             	lea    0x1(%eax),%esi
  800e05:	8a 00                	mov    (%eax),%al
  800e07:	0f be d8             	movsbl %al,%ebx
  800e0a:	85 db                	test   %ebx,%ebx
  800e0c:	74 24                	je     800e32 <vprintfmt+0x24b>
  800e0e:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800e12:	78 b8                	js     800dcc <vprintfmt+0x1e5>
  800e14:	ff 4d e0             	decl   -0x20(%ebp)
  800e17:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800e1b:	79 af                	jns    800dcc <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800e1d:	eb 13                	jmp    800e32 <vprintfmt+0x24b>
				putch(' ', putdat);
  800e1f:	83 ec 08             	sub    $0x8,%esp
  800e22:	ff 75 0c             	pushl  0xc(%ebp)
  800e25:	6a 20                	push   $0x20
  800e27:	8b 45 08             	mov    0x8(%ebp),%eax
  800e2a:	ff d0                	call   *%eax
  800e2c:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800e2f:	ff 4d e4             	decl   -0x1c(%ebp)
  800e32:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800e36:	7f e7                	jg     800e1f <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  800e38:	e9 66 01 00 00       	jmp    800fa3 <vprintfmt+0x3bc>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  800e3d:	83 ec 08             	sub    $0x8,%esp
  800e40:	ff 75 e8             	pushl  -0x18(%ebp)
  800e43:	8d 45 14             	lea    0x14(%ebp),%eax
  800e46:	50                   	push   %eax
  800e47:	e8 3c fd ff ff       	call   800b88 <getint>
  800e4c:	83 c4 10             	add    $0x10,%esp
  800e4f:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800e52:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  800e55:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800e58:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800e5b:	85 d2                	test   %edx,%edx
  800e5d:	79 23                	jns    800e82 <vprintfmt+0x29b>
				putch('-', putdat);
  800e5f:	83 ec 08             	sub    $0x8,%esp
  800e62:	ff 75 0c             	pushl  0xc(%ebp)
  800e65:	6a 2d                	push   $0x2d
  800e67:	8b 45 08             	mov    0x8(%ebp),%eax
  800e6a:	ff d0                	call   *%eax
  800e6c:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  800e6f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800e72:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800e75:	f7 d8                	neg    %eax
  800e77:	83 d2 00             	adc    $0x0,%edx
  800e7a:	f7 da                	neg    %edx
  800e7c:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800e7f:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  800e82:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800e89:	e9 bc 00 00 00       	jmp    800f4a <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  800e8e:	83 ec 08             	sub    $0x8,%esp
  800e91:	ff 75 e8             	pushl  -0x18(%ebp)
  800e94:	8d 45 14             	lea    0x14(%ebp),%eax
  800e97:	50                   	push   %eax
  800e98:	e8 84 fc ff ff       	call   800b21 <getuint>
  800e9d:	83 c4 10             	add    $0x10,%esp
  800ea0:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800ea3:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  800ea6:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800ead:	e9 98 00 00 00       	jmp    800f4a <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  800eb2:	83 ec 08             	sub    $0x8,%esp
  800eb5:	ff 75 0c             	pushl  0xc(%ebp)
  800eb8:	6a 58                	push   $0x58
  800eba:	8b 45 08             	mov    0x8(%ebp),%eax
  800ebd:	ff d0                	call   *%eax
  800ebf:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800ec2:	83 ec 08             	sub    $0x8,%esp
  800ec5:	ff 75 0c             	pushl  0xc(%ebp)
  800ec8:	6a 58                	push   $0x58
  800eca:	8b 45 08             	mov    0x8(%ebp),%eax
  800ecd:	ff d0                	call   *%eax
  800ecf:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800ed2:	83 ec 08             	sub    $0x8,%esp
  800ed5:	ff 75 0c             	pushl  0xc(%ebp)
  800ed8:	6a 58                	push   $0x58
  800eda:	8b 45 08             	mov    0x8(%ebp),%eax
  800edd:	ff d0                	call   *%eax
  800edf:	83 c4 10             	add    $0x10,%esp
			break;
  800ee2:	e9 bc 00 00 00       	jmp    800fa3 <vprintfmt+0x3bc>

		// pointer
		case 'p':
			putch('0', putdat);
  800ee7:	83 ec 08             	sub    $0x8,%esp
  800eea:	ff 75 0c             	pushl  0xc(%ebp)
  800eed:	6a 30                	push   $0x30
  800eef:	8b 45 08             	mov    0x8(%ebp),%eax
  800ef2:	ff d0                	call   *%eax
  800ef4:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  800ef7:	83 ec 08             	sub    $0x8,%esp
  800efa:	ff 75 0c             	pushl  0xc(%ebp)
  800efd:	6a 78                	push   $0x78
  800eff:	8b 45 08             	mov    0x8(%ebp),%eax
  800f02:	ff d0                	call   *%eax
  800f04:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  800f07:	8b 45 14             	mov    0x14(%ebp),%eax
  800f0a:	83 c0 04             	add    $0x4,%eax
  800f0d:	89 45 14             	mov    %eax,0x14(%ebp)
  800f10:	8b 45 14             	mov    0x14(%ebp),%eax
  800f13:	83 e8 04             	sub    $0x4,%eax
  800f16:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800f18:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800f1b:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  800f22:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  800f29:	eb 1f                	jmp    800f4a <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  800f2b:	83 ec 08             	sub    $0x8,%esp
  800f2e:	ff 75 e8             	pushl  -0x18(%ebp)
  800f31:	8d 45 14             	lea    0x14(%ebp),%eax
  800f34:	50                   	push   %eax
  800f35:	e8 e7 fb ff ff       	call   800b21 <getuint>
  800f3a:	83 c4 10             	add    $0x10,%esp
  800f3d:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800f40:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  800f43:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800f4a:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  800f4e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800f51:	83 ec 04             	sub    $0x4,%esp
  800f54:	52                   	push   %edx
  800f55:	ff 75 e4             	pushl  -0x1c(%ebp)
  800f58:	50                   	push   %eax
  800f59:	ff 75 f4             	pushl  -0xc(%ebp)
  800f5c:	ff 75 f0             	pushl  -0x10(%ebp)
  800f5f:	ff 75 0c             	pushl  0xc(%ebp)
  800f62:	ff 75 08             	pushl  0x8(%ebp)
  800f65:	e8 00 fb ff ff       	call   800a6a <printnum>
  800f6a:	83 c4 20             	add    $0x20,%esp
			break;
  800f6d:	eb 34                	jmp    800fa3 <vprintfmt+0x3bc>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  800f6f:	83 ec 08             	sub    $0x8,%esp
  800f72:	ff 75 0c             	pushl  0xc(%ebp)
  800f75:	53                   	push   %ebx
  800f76:	8b 45 08             	mov    0x8(%ebp),%eax
  800f79:	ff d0                	call   *%eax
  800f7b:	83 c4 10             	add    $0x10,%esp
			break;
  800f7e:	eb 23                	jmp    800fa3 <vprintfmt+0x3bc>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800f80:	83 ec 08             	sub    $0x8,%esp
  800f83:	ff 75 0c             	pushl  0xc(%ebp)
  800f86:	6a 25                	push   $0x25
  800f88:	8b 45 08             	mov    0x8(%ebp),%eax
  800f8b:	ff d0                	call   *%eax
  800f8d:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  800f90:	ff 4d 10             	decl   0x10(%ebp)
  800f93:	eb 03                	jmp    800f98 <vprintfmt+0x3b1>
  800f95:	ff 4d 10             	decl   0x10(%ebp)
  800f98:	8b 45 10             	mov    0x10(%ebp),%eax
  800f9b:	48                   	dec    %eax
  800f9c:	8a 00                	mov    (%eax),%al
  800f9e:	3c 25                	cmp    $0x25,%al
  800fa0:	75 f3                	jne    800f95 <vprintfmt+0x3ae>
				/* do nothing */;
			break;
  800fa2:	90                   	nop
		}
	}
  800fa3:	e9 47 fc ff ff       	jmp    800bef <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  800fa8:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  800fa9:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800fac:	5b                   	pop    %ebx
  800fad:	5e                   	pop    %esi
  800fae:	5d                   	pop    %ebp
  800faf:	c3                   	ret    

00800fb0 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800fb0:	55                   	push   %ebp
  800fb1:	89 e5                	mov    %esp,%ebp
  800fb3:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  800fb6:	8d 45 10             	lea    0x10(%ebp),%eax
  800fb9:	83 c0 04             	add    $0x4,%eax
  800fbc:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  800fbf:	8b 45 10             	mov    0x10(%ebp),%eax
  800fc2:	ff 75 f4             	pushl  -0xc(%ebp)
  800fc5:	50                   	push   %eax
  800fc6:	ff 75 0c             	pushl  0xc(%ebp)
  800fc9:	ff 75 08             	pushl  0x8(%ebp)
  800fcc:	e8 16 fc ff ff       	call   800be7 <vprintfmt>
  800fd1:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  800fd4:	90                   	nop
  800fd5:	c9                   	leave  
  800fd6:	c3                   	ret    

00800fd7 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800fd7:	55                   	push   %ebp
  800fd8:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  800fda:	8b 45 0c             	mov    0xc(%ebp),%eax
  800fdd:	8b 40 08             	mov    0x8(%eax),%eax
  800fe0:	8d 50 01             	lea    0x1(%eax),%edx
  800fe3:	8b 45 0c             	mov    0xc(%ebp),%eax
  800fe6:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  800fe9:	8b 45 0c             	mov    0xc(%ebp),%eax
  800fec:	8b 10                	mov    (%eax),%edx
  800fee:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ff1:	8b 40 04             	mov    0x4(%eax),%eax
  800ff4:	39 c2                	cmp    %eax,%edx
  800ff6:	73 12                	jae    80100a <sprintputch+0x33>
		*b->buf++ = ch;
  800ff8:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ffb:	8b 00                	mov    (%eax),%eax
  800ffd:	8d 48 01             	lea    0x1(%eax),%ecx
  801000:	8b 55 0c             	mov    0xc(%ebp),%edx
  801003:	89 0a                	mov    %ecx,(%edx)
  801005:	8b 55 08             	mov    0x8(%ebp),%edx
  801008:	88 10                	mov    %dl,(%eax)
}
  80100a:	90                   	nop
  80100b:	5d                   	pop    %ebp
  80100c:	c3                   	ret    

0080100d <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  80100d:	55                   	push   %ebp
  80100e:	89 e5                	mov    %esp,%ebp
  801010:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  801013:	8b 45 08             	mov    0x8(%ebp),%eax
  801016:	89 45 ec             	mov    %eax,-0x14(%ebp)
  801019:	8b 45 0c             	mov    0xc(%ebp),%eax
  80101c:	8d 50 ff             	lea    -0x1(%eax),%edx
  80101f:	8b 45 08             	mov    0x8(%ebp),%eax
  801022:	01 d0                	add    %edx,%eax
  801024:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801027:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  80102e:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801032:	74 06                	je     80103a <vsnprintf+0x2d>
  801034:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801038:	7f 07                	jg     801041 <vsnprintf+0x34>
		return -E_INVAL;
  80103a:	b8 03 00 00 00       	mov    $0x3,%eax
  80103f:	eb 20                	jmp    801061 <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  801041:	ff 75 14             	pushl  0x14(%ebp)
  801044:	ff 75 10             	pushl  0x10(%ebp)
  801047:	8d 45 ec             	lea    -0x14(%ebp),%eax
  80104a:	50                   	push   %eax
  80104b:	68 d7 0f 80 00       	push   $0x800fd7
  801050:	e8 92 fb ff ff       	call   800be7 <vprintfmt>
  801055:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  801058:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80105b:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  80105e:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  801061:	c9                   	leave  
  801062:	c3                   	ret    

00801063 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  801063:	55                   	push   %ebp
  801064:	89 e5                	mov    %esp,%ebp
  801066:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  801069:	8d 45 10             	lea    0x10(%ebp),%eax
  80106c:	83 c0 04             	add    $0x4,%eax
  80106f:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  801072:	8b 45 10             	mov    0x10(%ebp),%eax
  801075:	ff 75 f4             	pushl  -0xc(%ebp)
  801078:	50                   	push   %eax
  801079:	ff 75 0c             	pushl  0xc(%ebp)
  80107c:	ff 75 08             	pushl  0x8(%ebp)
  80107f:	e8 89 ff ff ff       	call   80100d <vsnprintf>
  801084:	83 c4 10             	add    $0x10,%esp
  801087:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  80108a:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  80108d:	c9                   	leave  
  80108e:	c3                   	ret    

0080108f <strlen>:

#include <inc/string.h>

int
strlen(const char *s)
{
  80108f:	55                   	push   %ebp
  801090:	89 e5                	mov    %esp,%ebp
  801092:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  801095:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  80109c:	eb 06                	jmp    8010a4 <strlen+0x15>
		n++;
  80109e:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  8010a1:	ff 45 08             	incl   0x8(%ebp)
  8010a4:	8b 45 08             	mov    0x8(%ebp),%eax
  8010a7:	8a 00                	mov    (%eax),%al
  8010a9:	84 c0                	test   %al,%al
  8010ab:	75 f1                	jne    80109e <strlen+0xf>
		n++;
	return n;
  8010ad:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  8010b0:	c9                   	leave  
  8010b1:	c3                   	ret    

008010b2 <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  8010b2:	55                   	push   %ebp
  8010b3:	89 e5                	mov    %esp,%ebp
  8010b5:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  8010b8:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8010bf:	eb 09                	jmp    8010ca <strnlen+0x18>
		n++;
  8010c1:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  8010c4:	ff 45 08             	incl   0x8(%ebp)
  8010c7:	ff 4d 0c             	decl   0xc(%ebp)
  8010ca:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8010ce:	74 09                	je     8010d9 <strnlen+0x27>
  8010d0:	8b 45 08             	mov    0x8(%ebp),%eax
  8010d3:	8a 00                	mov    (%eax),%al
  8010d5:	84 c0                	test   %al,%al
  8010d7:	75 e8                	jne    8010c1 <strnlen+0xf>
		n++;
	return n;
  8010d9:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  8010dc:	c9                   	leave  
  8010dd:	c3                   	ret    

008010de <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  8010de:	55                   	push   %ebp
  8010df:	89 e5                	mov    %esp,%ebp
  8010e1:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  8010e4:	8b 45 08             	mov    0x8(%ebp),%eax
  8010e7:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  8010ea:	90                   	nop
  8010eb:	8b 45 08             	mov    0x8(%ebp),%eax
  8010ee:	8d 50 01             	lea    0x1(%eax),%edx
  8010f1:	89 55 08             	mov    %edx,0x8(%ebp)
  8010f4:	8b 55 0c             	mov    0xc(%ebp),%edx
  8010f7:	8d 4a 01             	lea    0x1(%edx),%ecx
  8010fa:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  8010fd:	8a 12                	mov    (%edx),%dl
  8010ff:	88 10                	mov    %dl,(%eax)
  801101:	8a 00                	mov    (%eax),%al
  801103:	84 c0                	test   %al,%al
  801105:	75 e4                	jne    8010eb <strcpy+0xd>
		/* do nothing */;
	return ret;
  801107:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  80110a:	c9                   	leave  
  80110b:	c3                   	ret    

0080110c <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  80110c:	55                   	push   %ebp
  80110d:	89 e5                	mov    %esp,%ebp
  80110f:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  801112:	8b 45 08             	mov    0x8(%ebp),%eax
  801115:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  801118:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  80111f:	eb 1f                	jmp    801140 <strncpy+0x34>
		*dst++ = *src;
  801121:	8b 45 08             	mov    0x8(%ebp),%eax
  801124:	8d 50 01             	lea    0x1(%eax),%edx
  801127:	89 55 08             	mov    %edx,0x8(%ebp)
  80112a:	8b 55 0c             	mov    0xc(%ebp),%edx
  80112d:	8a 12                	mov    (%edx),%dl
  80112f:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  801131:	8b 45 0c             	mov    0xc(%ebp),%eax
  801134:	8a 00                	mov    (%eax),%al
  801136:	84 c0                	test   %al,%al
  801138:	74 03                	je     80113d <strncpy+0x31>
			src++;
  80113a:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  80113d:	ff 45 fc             	incl   -0x4(%ebp)
  801140:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801143:	3b 45 10             	cmp    0x10(%ebp),%eax
  801146:	72 d9                	jb     801121 <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  801148:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  80114b:	c9                   	leave  
  80114c:	c3                   	ret    

0080114d <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  80114d:	55                   	push   %ebp
  80114e:	89 e5                	mov    %esp,%ebp
  801150:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  801153:	8b 45 08             	mov    0x8(%ebp),%eax
  801156:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  801159:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80115d:	74 30                	je     80118f <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  80115f:	eb 16                	jmp    801177 <strlcpy+0x2a>
			*dst++ = *src++;
  801161:	8b 45 08             	mov    0x8(%ebp),%eax
  801164:	8d 50 01             	lea    0x1(%eax),%edx
  801167:	89 55 08             	mov    %edx,0x8(%ebp)
  80116a:	8b 55 0c             	mov    0xc(%ebp),%edx
  80116d:	8d 4a 01             	lea    0x1(%edx),%ecx
  801170:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  801173:	8a 12                	mov    (%edx),%dl
  801175:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  801177:	ff 4d 10             	decl   0x10(%ebp)
  80117a:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80117e:	74 09                	je     801189 <strlcpy+0x3c>
  801180:	8b 45 0c             	mov    0xc(%ebp),%eax
  801183:	8a 00                	mov    (%eax),%al
  801185:	84 c0                	test   %al,%al
  801187:	75 d8                	jne    801161 <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  801189:	8b 45 08             	mov    0x8(%ebp),%eax
  80118c:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  80118f:	8b 55 08             	mov    0x8(%ebp),%edx
  801192:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801195:	29 c2                	sub    %eax,%edx
  801197:	89 d0                	mov    %edx,%eax
}
  801199:	c9                   	leave  
  80119a:	c3                   	ret    

0080119b <strcmp>:

int
strcmp(const char *p, const char *q)
{
  80119b:	55                   	push   %ebp
  80119c:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  80119e:	eb 06                	jmp    8011a6 <strcmp+0xb>
		p++, q++;
  8011a0:	ff 45 08             	incl   0x8(%ebp)
  8011a3:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  8011a6:	8b 45 08             	mov    0x8(%ebp),%eax
  8011a9:	8a 00                	mov    (%eax),%al
  8011ab:	84 c0                	test   %al,%al
  8011ad:	74 0e                	je     8011bd <strcmp+0x22>
  8011af:	8b 45 08             	mov    0x8(%ebp),%eax
  8011b2:	8a 10                	mov    (%eax),%dl
  8011b4:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011b7:	8a 00                	mov    (%eax),%al
  8011b9:	38 c2                	cmp    %al,%dl
  8011bb:	74 e3                	je     8011a0 <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  8011bd:	8b 45 08             	mov    0x8(%ebp),%eax
  8011c0:	8a 00                	mov    (%eax),%al
  8011c2:	0f b6 d0             	movzbl %al,%edx
  8011c5:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011c8:	8a 00                	mov    (%eax),%al
  8011ca:	0f b6 c0             	movzbl %al,%eax
  8011cd:	29 c2                	sub    %eax,%edx
  8011cf:	89 d0                	mov    %edx,%eax
}
  8011d1:	5d                   	pop    %ebp
  8011d2:	c3                   	ret    

008011d3 <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  8011d3:	55                   	push   %ebp
  8011d4:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  8011d6:	eb 09                	jmp    8011e1 <strncmp+0xe>
		n--, p++, q++;
  8011d8:	ff 4d 10             	decl   0x10(%ebp)
  8011db:	ff 45 08             	incl   0x8(%ebp)
  8011de:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  8011e1:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8011e5:	74 17                	je     8011fe <strncmp+0x2b>
  8011e7:	8b 45 08             	mov    0x8(%ebp),%eax
  8011ea:	8a 00                	mov    (%eax),%al
  8011ec:	84 c0                	test   %al,%al
  8011ee:	74 0e                	je     8011fe <strncmp+0x2b>
  8011f0:	8b 45 08             	mov    0x8(%ebp),%eax
  8011f3:	8a 10                	mov    (%eax),%dl
  8011f5:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011f8:	8a 00                	mov    (%eax),%al
  8011fa:	38 c2                	cmp    %al,%dl
  8011fc:	74 da                	je     8011d8 <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  8011fe:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801202:	75 07                	jne    80120b <strncmp+0x38>
		return 0;
  801204:	b8 00 00 00 00       	mov    $0x0,%eax
  801209:	eb 14                	jmp    80121f <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  80120b:	8b 45 08             	mov    0x8(%ebp),%eax
  80120e:	8a 00                	mov    (%eax),%al
  801210:	0f b6 d0             	movzbl %al,%edx
  801213:	8b 45 0c             	mov    0xc(%ebp),%eax
  801216:	8a 00                	mov    (%eax),%al
  801218:	0f b6 c0             	movzbl %al,%eax
  80121b:	29 c2                	sub    %eax,%edx
  80121d:	89 d0                	mov    %edx,%eax
}
  80121f:	5d                   	pop    %ebp
  801220:	c3                   	ret    

00801221 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  801221:	55                   	push   %ebp
  801222:	89 e5                	mov    %esp,%ebp
  801224:	83 ec 04             	sub    $0x4,%esp
  801227:	8b 45 0c             	mov    0xc(%ebp),%eax
  80122a:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  80122d:	eb 12                	jmp    801241 <strchr+0x20>
		if (*s == c)
  80122f:	8b 45 08             	mov    0x8(%ebp),%eax
  801232:	8a 00                	mov    (%eax),%al
  801234:	3a 45 fc             	cmp    -0x4(%ebp),%al
  801237:	75 05                	jne    80123e <strchr+0x1d>
			return (char *) s;
  801239:	8b 45 08             	mov    0x8(%ebp),%eax
  80123c:	eb 11                	jmp    80124f <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  80123e:	ff 45 08             	incl   0x8(%ebp)
  801241:	8b 45 08             	mov    0x8(%ebp),%eax
  801244:	8a 00                	mov    (%eax),%al
  801246:	84 c0                	test   %al,%al
  801248:	75 e5                	jne    80122f <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  80124a:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80124f:	c9                   	leave  
  801250:	c3                   	ret    

00801251 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  801251:	55                   	push   %ebp
  801252:	89 e5                	mov    %esp,%ebp
  801254:	83 ec 04             	sub    $0x4,%esp
  801257:	8b 45 0c             	mov    0xc(%ebp),%eax
  80125a:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  80125d:	eb 0d                	jmp    80126c <strfind+0x1b>
		if (*s == c)
  80125f:	8b 45 08             	mov    0x8(%ebp),%eax
  801262:	8a 00                	mov    (%eax),%al
  801264:	3a 45 fc             	cmp    -0x4(%ebp),%al
  801267:	74 0e                	je     801277 <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  801269:	ff 45 08             	incl   0x8(%ebp)
  80126c:	8b 45 08             	mov    0x8(%ebp),%eax
  80126f:	8a 00                	mov    (%eax),%al
  801271:	84 c0                	test   %al,%al
  801273:	75 ea                	jne    80125f <strfind+0xe>
  801275:	eb 01                	jmp    801278 <strfind+0x27>
		if (*s == c)
			break;
  801277:	90                   	nop
	return (char *) s;
  801278:	8b 45 08             	mov    0x8(%ebp),%eax
}
  80127b:	c9                   	leave  
  80127c:	c3                   	ret    

0080127d <memset>:


void *
memset(void *v, int c, uint32 n)
{
  80127d:	55                   	push   %ebp
  80127e:	89 e5                	mov    %esp,%ebp
  801280:	83 ec 10             	sub    $0x10,%esp
	char *p;
	int m;

	p = v;
  801283:	8b 45 08             	mov    0x8(%ebp),%eax
  801286:	89 45 fc             	mov    %eax,-0x4(%ebp)
	m = n;
  801289:	8b 45 10             	mov    0x10(%ebp),%eax
  80128c:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (--m >= 0)
  80128f:	eb 0e                	jmp    80129f <memset+0x22>
		*p++ = c;
  801291:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801294:	8d 50 01             	lea    0x1(%eax),%edx
  801297:	89 55 fc             	mov    %edx,-0x4(%ebp)
  80129a:	8b 55 0c             	mov    0xc(%ebp),%edx
  80129d:	88 10                	mov    %dl,(%eax)
	char *p;
	int m;

	p = v;
	m = n;
	while (--m >= 0)
  80129f:	ff 4d f8             	decl   -0x8(%ebp)
  8012a2:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
  8012a6:	79 e9                	jns    801291 <memset+0x14>
		*p++ = c;

	return v;
  8012a8:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8012ab:	c9                   	leave  
  8012ac:	c3                   	ret    

008012ad <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  8012ad:	55                   	push   %ebp
  8012ae:	89 e5                	mov    %esp,%ebp
  8012b0:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  8012b3:	8b 45 0c             	mov    0xc(%ebp),%eax
  8012b6:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  8012b9:	8b 45 08             	mov    0x8(%ebp),%eax
  8012bc:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (n-- > 0)
  8012bf:	eb 16                	jmp    8012d7 <memcpy+0x2a>
		*d++ = *s++;
  8012c1:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8012c4:	8d 50 01             	lea    0x1(%eax),%edx
  8012c7:	89 55 f8             	mov    %edx,-0x8(%ebp)
  8012ca:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8012cd:	8d 4a 01             	lea    0x1(%edx),%ecx
  8012d0:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  8012d3:	8a 12                	mov    (%edx),%dl
  8012d5:	88 10                	mov    %dl,(%eax)
	const char *s;
	char *d;

	s = src;
	d = dst;
	while (n-- > 0)
  8012d7:	8b 45 10             	mov    0x10(%ebp),%eax
  8012da:	8d 50 ff             	lea    -0x1(%eax),%edx
  8012dd:	89 55 10             	mov    %edx,0x10(%ebp)
  8012e0:	85 c0                	test   %eax,%eax
  8012e2:	75 dd                	jne    8012c1 <memcpy+0x14>
		*d++ = *s++;

	return dst;
  8012e4:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8012e7:	c9                   	leave  
  8012e8:	c3                   	ret    

008012e9 <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  8012e9:	55                   	push   %ebp
  8012ea:	89 e5                	mov    %esp,%ebp
  8012ec:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  8012ef:	8b 45 0c             	mov    0xc(%ebp),%eax
  8012f2:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  8012f5:	8b 45 08             	mov    0x8(%ebp),%eax
  8012f8:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  8012fb:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8012fe:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  801301:	73 50                	jae    801353 <memmove+0x6a>
  801303:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801306:	8b 45 10             	mov    0x10(%ebp),%eax
  801309:	01 d0                	add    %edx,%eax
  80130b:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  80130e:	76 43                	jbe    801353 <memmove+0x6a>
		s += n;
  801310:	8b 45 10             	mov    0x10(%ebp),%eax
  801313:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  801316:	8b 45 10             	mov    0x10(%ebp),%eax
  801319:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  80131c:	eb 10                	jmp    80132e <memmove+0x45>
			*--d = *--s;
  80131e:	ff 4d f8             	decl   -0x8(%ebp)
  801321:	ff 4d fc             	decl   -0x4(%ebp)
  801324:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801327:	8a 10                	mov    (%eax),%dl
  801329:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80132c:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  80132e:	8b 45 10             	mov    0x10(%ebp),%eax
  801331:	8d 50 ff             	lea    -0x1(%eax),%edx
  801334:	89 55 10             	mov    %edx,0x10(%ebp)
  801337:	85 c0                	test   %eax,%eax
  801339:	75 e3                	jne    80131e <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  80133b:	eb 23                	jmp    801360 <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  80133d:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801340:	8d 50 01             	lea    0x1(%eax),%edx
  801343:	89 55 f8             	mov    %edx,-0x8(%ebp)
  801346:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801349:	8d 4a 01             	lea    0x1(%edx),%ecx
  80134c:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  80134f:	8a 12                	mov    (%edx),%dl
  801351:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  801353:	8b 45 10             	mov    0x10(%ebp),%eax
  801356:	8d 50 ff             	lea    -0x1(%eax),%edx
  801359:	89 55 10             	mov    %edx,0x10(%ebp)
  80135c:	85 c0                	test   %eax,%eax
  80135e:	75 dd                	jne    80133d <memmove+0x54>
			*d++ = *s++;

	return dst;
  801360:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801363:	c9                   	leave  
  801364:	c3                   	ret    

00801365 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  801365:	55                   	push   %ebp
  801366:	89 e5                	mov    %esp,%ebp
  801368:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  80136b:	8b 45 08             	mov    0x8(%ebp),%eax
  80136e:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  801371:	8b 45 0c             	mov    0xc(%ebp),%eax
  801374:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  801377:	eb 2a                	jmp    8013a3 <memcmp+0x3e>
		if (*s1 != *s2)
  801379:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80137c:	8a 10                	mov    (%eax),%dl
  80137e:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801381:	8a 00                	mov    (%eax),%al
  801383:	38 c2                	cmp    %al,%dl
  801385:	74 16                	je     80139d <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  801387:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80138a:	8a 00                	mov    (%eax),%al
  80138c:	0f b6 d0             	movzbl %al,%edx
  80138f:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801392:	8a 00                	mov    (%eax),%al
  801394:	0f b6 c0             	movzbl %al,%eax
  801397:	29 c2                	sub    %eax,%edx
  801399:	89 d0                	mov    %edx,%eax
  80139b:	eb 18                	jmp    8013b5 <memcmp+0x50>
		s1++, s2++;
  80139d:	ff 45 fc             	incl   -0x4(%ebp)
  8013a0:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  8013a3:	8b 45 10             	mov    0x10(%ebp),%eax
  8013a6:	8d 50 ff             	lea    -0x1(%eax),%edx
  8013a9:	89 55 10             	mov    %edx,0x10(%ebp)
  8013ac:	85 c0                	test   %eax,%eax
  8013ae:	75 c9                	jne    801379 <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  8013b0:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8013b5:	c9                   	leave  
  8013b6:	c3                   	ret    

008013b7 <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  8013b7:	55                   	push   %ebp
  8013b8:	89 e5                	mov    %esp,%ebp
  8013ba:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  8013bd:	8b 55 08             	mov    0x8(%ebp),%edx
  8013c0:	8b 45 10             	mov    0x10(%ebp),%eax
  8013c3:	01 d0                	add    %edx,%eax
  8013c5:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  8013c8:	eb 15                	jmp    8013df <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  8013ca:	8b 45 08             	mov    0x8(%ebp),%eax
  8013cd:	8a 00                	mov    (%eax),%al
  8013cf:	0f b6 d0             	movzbl %al,%edx
  8013d2:	8b 45 0c             	mov    0xc(%ebp),%eax
  8013d5:	0f b6 c0             	movzbl %al,%eax
  8013d8:	39 c2                	cmp    %eax,%edx
  8013da:	74 0d                	je     8013e9 <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  8013dc:	ff 45 08             	incl   0x8(%ebp)
  8013df:	8b 45 08             	mov    0x8(%ebp),%eax
  8013e2:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  8013e5:	72 e3                	jb     8013ca <memfind+0x13>
  8013e7:	eb 01                	jmp    8013ea <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  8013e9:	90                   	nop
	return (void *) s;
  8013ea:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8013ed:	c9                   	leave  
  8013ee:	c3                   	ret    

008013ef <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  8013ef:	55                   	push   %ebp
  8013f0:	89 e5                	mov    %esp,%ebp
  8013f2:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  8013f5:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  8013fc:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801403:	eb 03                	jmp    801408 <strtol+0x19>
		s++;
  801405:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801408:	8b 45 08             	mov    0x8(%ebp),%eax
  80140b:	8a 00                	mov    (%eax),%al
  80140d:	3c 20                	cmp    $0x20,%al
  80140f:	74 f4                	je     801405 <strtol+0x16>
  801411:	8b 45 08             	mov    0x8(%ebp),%eax
  801414:	8a 00                	mov    (%eax),%al
  801416:	3c 09                	cmp    $0x9,%al
  801418:	74 eb                	je     801405 <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  80141a:	8b 45 08             	mov    0x8(%ebp),%eax
  80141d:	8a 00                	mov    (%eax),%al
  80141f:	3c 2b                	cmp    $0x2b,%al
  801421:	75 05                	jne    801428 <strtol+0x39>
		s++;
  801423:	ff 45 08             	incl   0x8(%ebp)
  801426:	eb 13                	jmp    80143b <strtol+0x4c>
	else if (*s == '-')
  801428:	8b 45 08             	mov    0x8(%ebp),%eax
  80142b:	8a 00                	mov    (%eax),%al
  80142d:	3c 2d                	cmp    $0x2d,%al
  80142f:	75 0a                	jne    80143b <strtol+0x4c>
		s++, neg = 1;
  801431:	ff 45 08             	incl   0x8(%ebp)
  801434:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  80143b:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80143f:	74 06                	je     801447 <strtol+0x58>
  801441:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  801445:	75 20                	jne    801467 <strtol+0x78>
  801447:	8b 45 08             	mov    0x8(%ebp),%eax
  80144a:	8a 00                	mov    (%eax),%al
  80144c:	3c 30                	cmp    $0x30,%al
  80144e:	75 17                	jne    801467 <strtol+0x78>
  801450:	8b 45 08             	mov    0x8(%ebp),%eax
  801453:	40                   	inc    %eax
  801454:	8a 00                	mov    (%eax),%al
  801456:	3c 78                	cmp    $0x78,%al
  801458:	75 0d                	jne    801467 <strtol+0x78>
		s += 2, base = 16;
  80145a:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  80145e:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  801465:	eb 28                	jmp    80148f <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  801467:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80146b:	75 15                	jne    801482 <strtol+0x93>
  80146d:	8b 45 08             	mov    0x8(%ebp),%eax
  801470:	8a 00                	mov    (%eax),%al
  801472:	3c 30                	cmp    $0x30,%al
  801474:	75 0c                	jne    801482 <strtol+0x93>
		s++, base = 8;
  801476:	ff 45 08             	incl   0x8(%ebp)
  801479:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  801480:	eb 0d                	jmp    80148f <strtol+0xa0>
	else if (base == 0)
  801482:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801486:	75 07                	jne    80148f <strtol+0xa0>
		base = 10;
  801488:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  80148f:	8b 45 08             	mov    0x8(%ebp),%eax
  801492:	8a 00                	mov    (%eax),%al
  801494:	3c 2f                	cmp    $0x2f,%al
  801496:	7e 19                	jle    8014b1 <strtol+0xc2>
  801498:	8b 45 08             	mov    0x8(%ebp),%eax
  80149b:	8a 00                	mov    (%eax),%al
  80149d:	3c 39                	cmp    $0x39,%al
  80149f:	7f 10                	jg     8014b1 <strtol+0xc2>
			dig = *s - '0';
  8014a1:	8b 45 08             	mov    0x8(%ebp),%eax
  8014a4:	8a 00                	mov    (%eax),%al
  8014a6:	0f be c0             	movsbl %al,%eax
  8014a9:	83 e8 30             	sub    $0x30,%eax
  8014ac:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8014af:	eb 42                	jmp    8014f3 <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  8014b1:	8b 45 08             	mov    0x8(%ebp),%eax
  8014b4:	8a 00                	mov    (%eax),%al
  8014b6:	3c 60                	cmp    $0x60,%al
  8014b8:	7e 19                	jle    8014d3 <strtol+0xe4>
  8014ba:	8b 45 08             	mov    0x8(%ebp),%eax
  8014bd:	8a 00                	mov    (%eax),%al
  8014bf:	3c 7a                	cmp    $0x7a,%al
  8014c1:	7f 10                	jg     8014d3 <strtol+0xe4>
			dig = *s - 'a' + 10;
  8014c3:	8b 45 08             	mov    0x8(%ebp),%eax
  8014c6:	8a 00                	mov    (%eax),%al
  8014c8:	0f be c0             	movsbl %al,%eax
  8014cb:	83 e8 57             	sub    $0x57,%eax
  8014ce:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8014d1:	eb 20                	jmp    8014f3 <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  8014d3:	8b 45 08             	mov    0x8(%ebp),%eax
  8014d6:	8a 00                	mov    (%eax),%al
  8014d8:	3c 40                	cmp    $0x40,%al
  8014da:	7e 39                	jle    801515 <strtol+0x126>
  8014dc:	8b 45 08             	mov    0x8(%ebp),%eax
  8014df:	8a 00                	mov    (%eax),%al
  8014e1:	3c 5a                	cmp    $0x5a,%al
  8014e3:	7f 30                	jg     801515 <strtol+0x126>
			dig = *s - 'A' + 10;
  8014e5:	8b 45 08             	mov    0x8(%ebp),%eax
  8014e8:	8a 00                	mov    (%eax),%al
  8014ea:	0f be c0             	movsbl %al,%eax
  8014ed:	83 e8 37             	sub    $0x37,%eax
  8014f0:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  8014f3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8014f6:	3b 45 10             	cmp    0x10(%ebp),%eax
  8014f9:	7d 19                	jge    801514 <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  8014fb:	ff 45 08             	incl   0x8(%ebp)
  8014fe:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801501:	0f af 45 10          	imul   0x10(%ebp),%eax
  801505:	89 c2                	mov    %eax,%edx
  801507:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80150a:	01 d0                	add    %edx,%eax
  80150c:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  80150f:	e9 7b ff ff ff       	jmp    80148f <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  801514:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  801515:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801519:	74 08                	je     801523 <strtol+0x134>
		*endptr = (char *) s;
  80151b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80151e:	8b 55 08             	mov    0x8(%ebp),%edx
  801521:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  801523:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801527:	74 07                	je     801530 <strtol+0x141>
  801529:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80152c:	f7 d8                	neg    %eax
  80152e:	eb 03                	jmp    801533 <strtol+0x144>
  801530:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  801533:	c9                   	leave  
  801534:	c3                   	ret    

00801535 <ltostr>:

void
ltostr(long value, char *str)
{
  801535:	55                   	push   %ebp
  801536:	89 e5                	mov    %esp,%ebp
  801538:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  80153b:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  801542:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  801549:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80154d:	79 13                	jns    801562 <ltostr+0x2d>
	{
		neg = 1;
  80154f:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  801556:	8b 45 0c             	mov    0xc(%ebp),%eax
  801559:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  80155c:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  80155f:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  801562:	8b 45 08             	mov    0x8(%ebp),%eax
  801565:	b9 0a 00 00 00       	mov    $0xa,%ecx
  80156a:	99                   	cltd   
  80156b:	f7 f9                	idiv   %ecx
  80156d:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  801570:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801573:	8d 50 01             	lea    0x1(%eax),%edx
  801576:	89 55 f8             	mov    %edx,-0x8(%ebp)
  801579:	89 c2                	mov    %eax,%edx
  80157b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80157e:	01 d0                	add    %edx,%eax
  801580:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801583:	83 c2 30             	add    $0x30,%edx
  801586:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  801588:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80158b:	b8 67 66 66 66       	mov    $0x66666667,%eax
  801590:	f7 e9                	imul   %ecx
  801592:	c1 fa 02             	sar    $0x2,%edx
  801595:	89 c8                	mov    %ecx,%eax
  801597:	c1 f8 1f             	sar    $0x1f,%eax
  80159a:	29 c2                	sub    %eax,%edx
  80159c:	89 d0                	mov    %edx,%eax
  80159e:	89 45 08             	mov    %eax,0x8(%ebp)
	} while (value % 10 != 0);
  8015a1:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8015a4:	b8 67 66 66 66       	mov    $0x66666667,%eax
  8015a9:	f7 e9                	imul   %ecx
  8015ab:	c1 fa 02             	sar    $0x2,%edx
  8015ae:	89 c8                	mov    %ecx,%eax
  8015b0:	c1 f8 1f             	sar    $0x1f,%eax
  8015b3:	29 c2                	sub    %eax,%edx
  8015b5:	89 d0                	mov    %edx,%eax
  8015b7:	c1 e0 02             	shl    $0x2,%eax
  8015ba:	01 d0                	add    %edx,%eax
  8015bc:	01 c0                	add    %eax,%eax
  8015be:	29 c1                	sub    %eax,%ecx
  8015c0:	89 ca                	mov    %ecx,%edx
  8015c2:	85 d2                	test   %edx,%edx
  8015c4:	75 9c                	jne    801562 <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  8015c6:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  8015cd:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8015d0:	48                   	dec    %eax
  8015d1:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  8015d4:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  8015d8:	74 3d                	je     801617 <ltostr+0xe2>
		start = 1 ;
  8015da:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  8015e1:	eb 34                	jmp    801617 <ltostr+0xe2>
	{
		char tmp = str[start] ;
  8015e3:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8015e6:	8b 45 0c             	mov    0xc(%ebp),%eax
  8015e9:	01 d0                	add    %edx,%eax
  8015eb:	8a 00                	mov    (%eax),%al
  8015ed:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  8015f0:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8015f3:	8b 45 0c             	mov    0xc(%ebp),%eax
  8015f6:	01 c2                	add    %eax,%edx
  8015f8:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  8015fb:	8b 45 0c             	mov    0xc(%ebp),%eax
  8015fe:	01 c8                	add    %ecx,%eax
  801600:	8a 00                	mov    (%eax),%al
  801602:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  801604:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801607:	8b 45 0c             	mov    0xc(%ebp),%eax
  80160a:	01 c2                	add    %eax,%edx
  80160c:	8a 45 eb             	mov    -0x15(%ebp),%al
  80160f:	88 02                	mov    %al,(%edx)
		start++ ;
  801611:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  801614:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  801617:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80161a:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  80161d:	7c c4                	jl     8015e3 <ltostr+0xae>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  80161f:	8b 55 f8             	mov    -0x8(%ebp),%edx
  801622:	8b 45 0c             	mov    0xc(%ebp),%eax
  801625:	01 d0                	add    %edx,%eax
  801627:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  80162a:	90                   	nop
  80162b:	c9                   	leave  
  80162c:	c3                   	ret    

0080162d <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  80162d:	55                   	push   %ebp
  80162e:	89 e5                	mov    %esp,%ebp
  801630:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  801633:	ff 75 08             	pushl  0x8(%ebp)
  801636:	e8 54 fa ff ff       	call   80108f <strlen>
  80163b:	83 c4 04             	add    $0x4,%esp
  80163e:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  801641:	ff 75 0c             	pushl  0xc(%ebp)
  801644:	e8 46 fa ff ff       	call   80108f <strlen>
  801649:	83 c4 04             	add    $0x4,%esp
  80164c:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  80164f:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  801656:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  80165d:	eb 17                	jmp    801676 <strcconcat+0x49>
		final[s] = str1[s] ;
  80165f:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801662:	8b 45 10             	mov    0x10(%ebp),%eax
  801665:	01 c2                	add    %eax,%edx
  801667:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  80166a:	8b 45 08             	mov    0x8(%ebp),%eax
  80166d:	01 c8                	add    %ecx,%eax
  80166f:	8a 00                	mov    (%eax),%al
  801671:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  801673:	ff 45 fc             	incl   -0x4(%ebp)
  801676:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801679:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  80167c:	7c e1                	jl     80165f <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  80167e:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  801685:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  80168c:	eb 1f                	jmp    8016ad <strcconcat+0x80>
		final[s++] = str2[i] ;
  80168e:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801691:	8d 50 01             	lea    0x1(%eax),%edx
  801694:	89 55 fc             	mov    %edx,-0x4(%ebp)
  801697:	89 c2                	mov    %eax,%edx
  801699:	8b 45 10             	mov    0x10(%ebp),%eax
  80169c:	01 c2                	add    %eax,%edx
  80169e:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  8016a1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8016a4:	01 c8                	add    %ecx,%eax
  8016a6:	8a 00                	mov    (%eax),%al
  8016a8:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  8016aa:	ff 45 f8             	incl   -0x8(%ebp)
  8016ad:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8016b0:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8016b3:	7c d9                	jl     80168e <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  8016b5:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8016b8:	8b 45 10             	mov    0x10(%ebp),%eax
  8016bb:	01 d0                	add    %edx,%eax
  8016bd:	c6 00 00             	movb   $0x0,(%eax)
}
  8016c0:	90                   	nop
  8016c1:	c9                   	leave  
  8016c2:	c3                   	ret    

008016c3 <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  8016c3:	55                   	push   %ebp
  8016c4:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  8016c6:	8b 45 14             	mov    0x14(%ebp),%eax
  8016c9:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  8016cf:	8b 45 14             	mov    0x14(%ebp),%eax
  8016d2:	8b 00                	mov    (%eax),%eax
  8016d4:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8016db:	8b 45 10             	mov    0x10(%ebp),%eax
  8016de:	01 d0                	add    %edx,%eax
  8016e0:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  8016e6:	eb 0c                	jmp    8016f4 <strsplit+0x31>
			*string++ = 0;
  8016e8:	8b 45 08             	mov    0x8(%ebp),%eax
  8016eb:	8d 50 01             	lea    0x1(%eax),%edx
  8016ee:	89 55 08             	mov    %edx,0x8(%ebp)
  8016f1:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  8016f4:	8b 45 08             	mov    0x8(%ebp),%eax
  8016f7:	8a 00                	mov    (%eax),%al
  8016f9:	84 c0                	test   %al,%al
  8016fb:	74 18                	je     801715 <strsplit+0x52>
  8016fd:	8b 45 08             	mov    0x8(%ebp),%eax
  801700:	8a 00                	mov    (%eax),%al
  801702:	0f be c0             	movsbl %al,%eax
  801705:	50                   	push   %eax
  801706:	ff 75 0c             	pushl  0xc(%ebp)
  801709:	e8 13 fb ff ff       	call   801221 <strchr>
  80170e:	83 c4 08             	add    $0x8,%esp
  801711:	85 c0                	test   %eax,%eax
  801713:	75 d3                	jne    8016e8 <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  801715:	8b 45 08             	mov    0x8(%ebp),%eax
  801718:	8a 00                	mov    (%eax),%al
  80171a:	84 c0                	test   %al,%al
  80171c:	74 5a                	je     801778 <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  80171e:	8b 45 14             	mov    0x14(%ebp),%eax
  801721:	8b 00                	mov    (%eax),%eax
  801723:	83 f8 0f             	cmp    $0xf,%eax
  801726:	75 07                	jne    80172f <strsplit+0x6c>
		{
			return 0;
  801728:	b8 00 00 00 00       	mov    $0x0,%eax
  80172d:	eb 66                	jmp    801795 <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  80172f:	8b 45 14             	mov    0x14(%ebp),%eax
  801732:	8b 00                	mov    (%eax),%eax
  801734:	8d 48 01             	lea    0x1(%eax),%ecx
  801737:	8b 55 14             	mov    0x14(%ebp),%edx
  80173a:	89 0a                	mov    %ecx,(%edx)
  80173c:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801743:	8b 45 10             	mov    0x10(%ebp),%eax
  801746:	01 c2                	add    %eax,%edx
  801748:	8b 45 08             	mov    0x8(%ebp),%eax
  80174b:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  80174d:	eb 03                	jmp    801752 <strsplit+0x8f>
			string++;
  80174f:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  801752:	8b 45 08             	mov    0x8(%ebp),%eax
  801755:	8a 00                	mov    (%eax),%al
  801757:	84 c0                	test   %al,%al
  801759:	74 8b                	je     8016e6 <strsplit+0x23>
  80175b:	8b 45 08             	mov    0x8(%ebp),%eax
  80175e:	8a 00                	mov    (%eax),%al
  801760:	0f be c0             	movsbl %al,%eax
  801763:	50                   	push   %eax
  801764:	ff 75 0c             	pushl  0xc(%ebp)
  801767:	e8 b5 fa ff ff       	call   801221 <strchr>
  80176c:	83 c4 08             	add    $0x8,%esp
  80176f:	85 c0                	test   %eax,%eax
  801771:	74 dc                	je     80174f <strsplit+0x8c>
			string++;
	}
  801773:	e9 6e ff ff ff       	jmp    8016e6 <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  801778:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  801779:	8b 45 14             	mov    0x14(%ebp),%eax
  80177c:	8b 00                	mov    (%eax),%eax
  80177e:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801785:	8b 45 10             	mov    0x10(%ebp),%eax
  801788:	01 d0                	add    %edx,%eax
  80178a:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  801790:	b8 01 00 00 00       	mov    $0x1,%eax
}
  801795:	c9                   	leave  
  801796:	c3                   	ret    

00801797 <InitializeUHeap>:
//============================== GIVEN FUNCTIONS ===================================//
//==================================================================================//

int FirstTimeFlag = 1;
void InitializeUHeap()
{
  801797:	55                   	push   %ebp
  801798:	89 e5                	mov    %esp,%ebp
  80179a:	83 ec 08             	sub    $0x8,%esp
	if(FirstTimeFlag)
  80179d:	a1 04 40 80 00       	mov    0x804004,%eax
  8017a2:	85 c0                	test   %eax,%eax
  8017a4:	74 1f                	je     8017c5 <InitializeUHeap+0x2e>
	{
		initialize_dyn_block_system();
  8017a6:	e8 1d 00 00 00       	call   8017c8 <initialize_dyn_block_system>
		cprintf("DYNAMIC BLOCK SYSTEM IS INITIALIZED\n");
  8017ab:	83 ec 0c             	sub    $0xc,%esp
  8017ae:	68 70 3c 80 00       	push   $0x803c70
  8017b3:	e8 55 f2 ff ff       	call   800a0d <cprintf>
  8017b8:	83 c4 10             	add    $0x10,%esp
#if UHP_USE_BUDDY
		initialize_buddy();
		cprintf("BUDDY SYSTEM IS INITIALIZED\n");
#endif
		FirstTimeFlag = 0;
  8017bb:	c7 05 04 40 80 00 00 	movl   $0x0,0x804004
  8017c2:	00 00 00 
	}
}
  8017c5:	90                   	nop
  8017c6:	c9                   	leave  
  8017c7:	c3                   	ret    

008017c8 <initialize_dyn_block_system>:

//=================================
// [1] INITIALIZE DYNAMIC ALLOCATOR:
//=================================
void initialize_dyn_block_system()
{
  8017c8:	55                   	push   %ebp
  8017c9:	89 e5                	mov    %esp,%ebp
  8017cb:	83 ec 28             	sub    $0x28,%esp
	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] initialize_dyn_block_system
	// your code is here, remove the panic and write your code
	//panic("initialize_dyn_block_system() is not implemented yet...!!");

	LIST_INIT(&AllocMemBlocksList);
  8017ce:	c7 05 40 40 80 00 00 	movl   $0x0,0x804040
  8017d5:	00 00 00 
  8017d8:	c7 05 44 40 80 00 00 	movl   $0x0,0x804044
  8017df:	00 00 00 
  8017e2:	c7 05 4c 40 80 00 00 	movl   $0x0,0x80404c
  8017e9:	00 00 00 
	LIST_INIT(&FreeMemBlocksList);
  8017ec:	c7 05 38 41 80 00 00 	movl   $0x0,0x804138
  8017f3:	00 00 00 
  8017f6:	c7 05 3c 41 80 00 00 	movl   $0x0,0x80413c
  8017fd:	00 00 00 
  801800:	c7 05 44 41 80 00 00 	movl   $0x0,0x804144
  801807:	00 00 00 
	MAX_MEM_BLOCK_CNT = NUM_OF_UHEAP_PAGES;
  80180a:	c7 05 20 41 80 00 00 	movl   $0x20000,0x804120
  801811:	00 02 00 
	MemBlockNodes = (void*)USER_DYN_BLKS_ARRAY;
  801814:	c7 45 f4 00 00 e0 7f 	movl   $0x7fe00000,-0xc(%ebp)
  80181b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80181e:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801823:	2d 00 10 00 00       	sub    $0x1000,%eax
  801828:	a3 50 40 80 00       	mov    %eax,0x804050
	int size_of_block = sizeof(struct MemBlock);
  80182d:	c7 45 f0 10 00 00 00 	movl   $0x10,-0x10(%ebp)
	int size_all_struct = size_of_block*MAX_MEM_BLOCK_CNT;
  801834:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801837:	a1 20 41 80 00       	mov    0x804120,%eax
  80183c:	0f af c2             	imul   %edx,%eax
  80183f:	89 45 ec             	mov    %eax,-0x14(%ebp)
	size_all_struct = ROUNDUP(size_all_struct, PAGE_SIZE);
  801842:	c7 45 e8 00 10 00 00 	movl   $0x1000,-0x18(%ebp)
  801849:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80184c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80184f:	01 d0                	add    %edx,%eax
  801851:	48                   	dec    %eax
  801852:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  801855:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801858:	ba 00 00 00 00       	mov    $0x0,%edx
  80185d:	f7 75 e8             	divl   -0x18(%ebp)
  801860:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801863:	29 d0                	sub    %edx,%eax
  801865:	89 45 ec             	mov    %eax,-0x14(%ebp)
	sys_allocate_chunk(USER_DYN_BLKS_ARRAY, size_all_struct,PERM_USER| PERM_WRITEABLE);
  801868:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80186b:	c7 45 e0 00 00 e0 7f 	movl   $0x7fe00000,-0x20(%ebp)
  801872:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801875:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
  80187b:	81 ea 00 10 00 00    	sub    $0x1000,%edx
  801881:	83 ec 04             	sub    $0x4,%esp
  801884:	6a 06                	push   $0x6
  801886:	50                   	push   %eax
  801887:	52                   	push   %edx
  801888:	e8 a1 05 00 00       	call   801e2e <sys_allocate_chunk>
  80188d:	83 c4 10             	add    $0x10,%esp
	initialize_MemBlocksList(MAX_MEM_BLOCK_CNT);
  801890:	a1 20 41 80 00       	mov    0x804120,%eax
  801895:	83 ec 0c             	sub    $0xc,%esp
  801898:	50                   	push   %eax
  801899:	e8 16 0c 00 00       	call   8024b4 <initialize_MemBlocksList>
  80189e:	83 c4 10             	add    $0x10,%esp
	struct MemBlock* ourBlock =LIST_LAST(&AvailableMemBlocksList);
  8018a1:	a1 4c 41 80 00       	mov    0x80414c,%eax
  8018a6:	89 45 dc             	mov    %eax,-0x24(%ebp)
	LIST_REMOVE(&AvailableMemBlocksList,ourBlock);
  8018a9:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  8018ad:	75 14                	jne    8018c3 <initialize_dyn_block_system+0xfb>
  8018af:	83 ec 04             	sub    $0x4,%esp
  8018b2:	68 95 3c 80 00       	push   $0x803c95
  8018b7:	6a 2d                	push   $0x2d
  8018b9:	68 b3 3c 80 00       	push   $0x803cb3
  8018be:	e8 96 ee ff ff       	call   800759 <_panic>
  8018c3:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8018c6:	8b 00                	mov    (%eax),%eax
  8018c8:	85 c0                	test   %eax,%eax
  8018ca:	74 10                	je     8018dc <initialize_dyn_block_system+0x114>
  8018cc:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8018cf:	8b 00                	mov    (%eax),%eax
  8018d1:	8b 55 dc             	mov    -0x24(%ebp),%edx
  8018d4:	8b 52 04             	mov    0x4(%edx),%edx
  8018d7:	89 50 04             	mov    %edx,0x4(%eax)
  8018da:	eb 0b                	jmp    8018e7 <initialize_dyn_block_system+0x11f>
  8018dc:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8018df:	8b 40 04             	mov    0x4(%eax),%eax
  8018e2:	a3 4c 41 80 00       	mov    %eax,0x80414c
  8018e7:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8018ea:	8b 40 04             	mov    0x4(%eax),%eax
  8018ed:	85 c0                	test   %eax,%eax
  8018ef:	74 0f                	je     801900 <initialize_dyn_block_system+0x138>
  8018f1:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8018f4:	8b 40 04             	mov    0x4(%eax),%eax
  8018f7:	8b 55 dc             	mov    -0x24(%ebp),%edx
  8018fa:	8b 12                	mov    (%edx),%edx
  8018fc:	89 10                	mov    %edx,(%eax)
  8018fe:	eb 0a                	jmp    80190a <initialize_dyn_block_system+0x142>
  801900:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801903:	8b 00                	mov    (%eax),%eax
  801905:	a3 48 41 80 00       	mov    %eax,0x804148
  80190a:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80190d:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  801913:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801916:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80191d:	a1 54 41 80 00       	mov    0x804154,%eax
  801922:	48                   	dec    %eax
  801923:	a3 54 41 80 00       	mov    %eax,0x804154
	ourBlock->size = USER_HEAP_MAX-USER_HEAP_START;
  801928:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80192b:	c7 40 0c 00 00 00 20 	movl   $0x20000000,0xc(%eax)
	ourBlock->sva=USER_HEAP_START;
  801932:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801935:	c7 40 08 00 00 00 80 	movl   $0x80000000,0x8(%eax)
	LIST_INSERT_TAIL(&FreeMemBlocksList, ourBlock);
  80193c:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  801940:	75 14                	jne    801956 <initialize_dyn_block_system+0x18e>
  801942:	83 ec 04             	sub    $0x4,%esp
  801945:	68 c0 3c 80 00       	push   $0x803cc0
  80194a:	6a 30                	push   $0x30
  80194c:	68 b3 3c 80 00       	push   $0x803cb3
  801951:	e8 03 ee ff ff       	call   800759 <_panic>
  801956:	8b 15 3c 41 80 00    	mov    0x80413c,%edx
  80195c:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80195f:	89 50 04             	mov    %edx,0x4(%eax)
  801962:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801965:	8b 40 04             	mov    0x4(%eax),%eax
  801968:	85 c0                	test   %eax,%eax
  80196a:	74 0c                	je     801978 <initialize_dyn_block_system+0x1b0>
  80196c:	a1 3c 41 80 00       	mov    0x80413c,%eax
  801971:	8b 55 dc             	mov    -0x24(%ebp),%edx
  801974:	89 10                	mov    %edx,(%eax)
  801976:	eb 08                	jmp    801980 <initialize_dyn_block_system+0x1b8>
  801978:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80197b:	a3 38 41 80 00       	mov    %eax,0x804138
  801980:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801983:	a3 3c 41 80 00       	mov    %eax,0x80413c
  801988:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80198b:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  801991:	a1 44 41 80 00       	mov    0x804144,%eax
  801996:	40                   	inc    %eax
  801997:	a3 44 41 80 00       	mov    %eax,0x804144
	//[1] Initialize two lists (AllocMemBlocksList & FreeMemBlocksList) [Hint: use LIST_INIT()]
	//[2] Dynamically allocate the array of MemBlockNodes at VA USER_DYN_BLKS_ARRAY
	//	  (remember to set MAX_MEM_BLOCK_CNT with the chosen size of the array)
	//[3] Initialize AvailableMemBlocksList by filling it with the MemBlockNodes
	//[4] Insert a new MemBlock with the heap size into the FreeMemBlocksList
}
  80199c:	90                   	nop
  80199d:	c9                   	leave  
  80199e:	c3                   	ret    

0080199f <malloc>:
//=================================
// [2] ALLOCATE SPACE IN USER HEAP:
//=================================

void* malloc(uint32 size)
{
  80199f:	55                   	push   %ebp
  8019a0:	89 e5                	mov    %esp,%ebp
  8019a2:	83 ec 18             	sub    $0x18,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  8019a5:	e8 ed fd ff ff       	call   801797 <InitializeUHeap>
	if (size == 0) return NULL ;
  8019aa:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8019ae:	75 07                	jne    8019b7 <malloc+0x18>
  8019b0:	b8 00 00 00 00       	mov    $0x0,%eax
  8019b5:	eb 67                	jmp    801a1e <malloc+0x7f>

	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] malloc
	// your code is here, remove the panic and write your code
	//panic("malloc() is not implemented yet...!!");

	size = ROUNDUP(size, PAGE_SIZE);
  8019b7:	c7 45 f4 00 10 00 00 	movl   $0x1000,-0xc(%ebp)
  8019be:	8b 55 08             	mov    0x8(%ebp),%edx
  8019c1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8019c4:	01 d0                	add    %edx,%eax
  8019c6:	48                   	dec    %eax
  8019c7:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8019ca:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8019cd:	ba 00 00 00 00       	mov    $0x0,%edx
  8019d2:	f7 75 f4             	divl   -0xc(%ebp)
  8019d5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8019d8:	29 d0                	sub    %edx,%eax
  8019da:	89 45 08             	mov    %eax,0x8(%ebp)
	if(sys_isUHeapPlacementStrategyFIRSTFIT())
  8019dd:	e8 1a 08 00 00       	call   8021fc <sys_isUHeapPlacementStrategyFIRSTFIT>
  8019e2:	85 c0                	test   %eax,%eax
  8019e4:	74 33                	je     801a19 <malloc+0x7a>
	{
		struct MemBlock * myBlock = alloc_block_FF(size);
  8019e6:	83 ec 0c             	sub    $0xc,%esp
  8019e9:	ff 75 08             	pushl  0x8(%ebp)
  8019ec:	e8 0c 0e 00 00       	call   8027fd <alloc_block_FF>
  8019f1:	83 c4 10             	add    $0x10,%esp
  8019f4:	89 45 ec             	mov    %eax,-0x14(%ebp)
		if(myBlock != NULL)
  8019f7:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8019fb:	74 1c                	je     801a19 <malloc+0x7a>
		{
			insert_sorted_allocList(myBlock);
  8019fd:	83 ec 0c             	sub    $0xc,%esp
  801a00:	ff 75 ec             	pushl  -0x14(%ebp)
  801a03:	e8 07 0c 00 00       	call   80260f <insert_sorted_allocList>
  801a08:	83 c4 10             	add    $0x10,%esp
			uint32 ptr = myBlock->sva;
  801a0b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801a0e:	8b 40 08             	mov    0x8(%eax),%eax
  801a11:	89 45 e8             	mov    %eax,-0x18(%ebp)
			return (void *)ptr;
  801a14:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801a17:	eb 05                	jmp    801a1e <malloc+0x7f>
		}
	}
	return NULL;
  801a19:	b8 00 00 00 00       	mov    $0x0,%eax
	//		to the required allocation size (space should be on 4 KB BOUNDARY)
	//	2) if no suitable space found, return NULL
	// 	3) Return pointer containing the virtual address of allocated space,
	//
	//Use sys_isUHeapPlacementStrategyFIRSTFIT()... to check the current strategy
}
  801a1e:	c9                   	leave  
  801a1f:	c3                   	ret    

00801a20 <free>:
//	We can use sys_free_user_mem(uint32 virtual_address, uint32 size); which
//		switches to the kernel mode, calls free_user_mem() in
//		"kern/mem/chunk_operations.c", then switch back to the user mode here
//	the free_user_mem function is empty, make sure to implement it.
void free(void* virtual_address)
{
  801a20:	55                   	push   %ebp
  801a21:	89 e5                	mov    %esp,%ebp
  801a23:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] free
	// your code is here, remove the panic and write your code
	//panic("free() is not implemented yet...!!");

	uint32 virtualAddress = (uint32 )(virtual_address);
  801a26:	8b 45 08             	mov    0x8(%ebp),%eax
  801a29:	89 45 f4             	mov    %eax,-0xc(%ebp)
//	virtualAddress = ROUNDDOWN(virtualAddress, PAGE_SIZE);
	struct MemBlock * myBlock = find_block(&AllocMemBlocksList, virtualAddress);
  801a2c:	83 ec 08             	sub    $0x8,%esp
  801a2f:	ff 75 f4             	pushl  -0xc(%ebp)
  801a32:	68 40 40 80 00       	push   $0x804040
  801a37:	e8 5b 0b 00 00       	call   802597 <find_block>
  801a3c:	83 c4 10             	add    $0x10,%esp
  801a3f:	89 45 f0             	mov    %eax,-0x10(%ebp)
//	cprintf ("ptr sva at free user side = %x \n", myBlock->sva);
	sys_free_user_mem(virtualAddress, myBlock->size);
  801a42:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801a45:	8b 40 0c             	mov    0xc(%eax),%eax
  801a48:	83 ec 08             	sub    $0x8,%esp
  801a4b:	50                   	push   %eax
  801a4c:	ff 75 f4             	pushl  -0xc(%ebp)
  801a4f:	e8 a2 03 00 00       	call   801df6 <sys_free_user_mem>
  801a54:	83 c4 10             	add    $0x10,%esp
	LIST_REMOVE(&AllocMemBlocksList, myBlock);
  801a57:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801a5b:	75 14                	jne    801a71 <free+0x51>
  801a5d:	83 ec 04             	sub    $0x4,%esp
  801a60:	68 95 3c 80 00       	push   $0x803c95
  801a65:	6a 76                	push   $0x76
  801a67:	68 b3 3c 80 00       	push   $0x803cb3
  801a6c:	e8 e8 ec ff ff       	call   800759 <_panic>
  801a71:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801a74:	8b 00                	mov    (%eax),%eax
  801a76:	85 c0                	test   %eax,%eax
  801a78:	74 10                	je     801a8a <free+0x6a>
  801a7a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801a7d:	8b 00                	mov    (%eax),%eax
  801a7f:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801a82:	8b 52 04             	mov    0x4(%edx),%edx
  801a85:	89 50 04             	mov    %edx,0x4(%eax)
  801a88:	eb 0b                	jmp    801a95 <free+0x75>
  801a8a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801a8d:	8b 40 04             	mov    0x4(%eax),%eax
  801a90:	a3 44 40 80 00       	mov    %eax,0x804044
  801a95:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801a98:	8b 40 04             	mov    0x4(%eax),%eax
  801a9b:	85 c0                	test   %eax,%eax
  801a9d:	74 0f                	je     801aae <free+0x8e>
  801a9f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801aa2:	8b 40 04             	mov    0x4(%eax),%eax
  801aa5:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801aa8:	8b 12                	mov    (%edx),%edx
  801aaa:	89 10                	mov    %edx,(%eax)
  801aac:	eb 0a                	jmp    801ab8 <free+0x98>
  801aae:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801ab1:	8b 00                	mov    (%eax),%eax
  801ab3:	a3 40 40 80 00       	mov    %eax,0x804040
  801ab8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801abb:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  801ac1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801ac4:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  801acb:	a1 4c 40 80 00       	mov    0x80404c,%eax
  801ad0:	48                   	dec    %eax
  801ad1:	a3 4c 40 80 00       	mov    %eax,0x80404c
	insert_sorted_with_merge_freeList(myBlock);
  801ad6:	83 ec 0c             	sub    $0xc,%esp
  801ad9:	ff 75 f0             	pushl  -0x10(%ebp)
  801adc:	e8 0b 14 00 00       	call   802eec <insert_sorted_with_merge_freeList>
  801ae1:	83 c4 10             	add    $0x10,%esp

	//you should get the size of the given allocation using its address
	//you need to call sys_free_user_mem()
	//refer to the project presentation and documentation for details
}
  801ae4:	90                   	nop
  801ae5:	c9                   	leave  
  801ae6:	c3                   	ret    

00801ae7 <smalloc>:

//=================================
// [4] ALLOCATE SHARED VARIABLE:
//=================================
void* smalloc(char *sharedVarName, uint32 size, uint8 isWritable)
{
  801ae7:	55                   	push   %ebp
  801ae8:	89 e5                	mov    %esp,%ebp
  801aea:	83 ec 28             	sub    $0x28,%esp
  801aed:	8b 45 10             	mov    0x10(%ebp),%eax
  801af0:	88 45 e4             	mov    %al,-0x1c(%ebp)
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801af3:	e8 9f fc ff ff       	call   801797 <InitializeUHeap>
	if (size == 0) return NULL ;
  801af8:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801afc:	75 0a                	jne    801b08 <smalloc+0x21>
  801afe:	b8 00 00 00 00       	mov    $0x0,%eax
  801b03:	e9 8d 00 00 00       	jmp    801b95 <smalloc+0xae>

	//This function should find the space of the required range
	// * ON 4KB BOUNDARY **** //
	//Use sys_isUHeapPlacementStrategyFIRSTFIT() to check the current strategy

	size = ROUNDUP(size, PAGE_SIZE);
  801b08:	c7 45 f4 00 10 00 00 	movl   $0x1000,-0xc(%ebp)
  801b0f:	8b 55 0c             	mov    0xc(%ebp),%edx
  801b12:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801b15:	01 d0                	add    %edx,%eax
  801b17:	48                   	dec    %eax
  801b18:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801b1b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801b1e:	ba 00 00 00 00       	mov    $0x0,%edx
  801b23:	f7 75 f4             	divl   -0xc(%ebp)
  801b26:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801b29:	29 d0                	sub    %edx,%eax
  801b2b:	89 45 0c             	mov    %eax,0xc(%ebp)
		if(sys_isUHeapPlacementStrategyFIRSTFIT())
  801b2e:	e8 c9 06 00 00       	call   8021fc <sys_isUHeapPlacementStrategyFIRSTFIT>
  801b33:	85 c0                	test   %eax,%eax
  801b35:	74 59                	je     801b90 <smalloc+0xa9>
		{
			struct MemBlock * v1=NULL;
  801b37:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
			v1= alloc_block_FF(size);
  801b3e:	83 ec 0c             	sub    $0xc,%esp
  801b41:	ff 75 0c             	pushl  0xc(%ebp)
  801b44:	e8 b4 0c 00 00       	call   8027fd <alloc_block_FF>
  801b49:	83 c4 10             	add    $0x10,%esp
  801b4c:	89 45 ec             	mov    %eax,-0x14(%ebp)
			if(v1==NULL)
  801b4f:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  801b53:	75 07                	jne    801b5c <smalloc+0x75>
			{
				return NULL;
  801b55:	b8 00 00 00 00       	mov    $0x0,%eax
  801b5a:	eb 39                	jmp    801b95 <smalloc+0xae>
			}
			else
			{
				int ret=sys_createSharedObject(sharedVarName,  size,  isWritable,(void*)v1->sva);
  801b5c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801b5f:	8b 40 08             	mov    0x8(%eax),%eax
  801b62:	89 c2                	mov    %eax,%edx
  801b64:	0f b6 45 e4          	movzbl -0x1c(%ebp),%eax
  801b68:	52                   	push   %edx
  801b69:	50                   	push   %eax
  801b6a:	ff 75 0c             	pushl  0xc(%ebp)
  801b6d:	ff 75 08             	pushl  0x8(%ebp)
  801b70:	e8 0c 04 00 00       	call   801f81 <sys_createSharedObject>
  801b75:	83 c4 10             	add    $0x10,%esp
  801b78:	89 45 e8             	mov    %eax,-0x18(%ebp)
				if(ret>=0)
  801b7b:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  801b7f:	78 08                	js     801b89 <smalloc+0xa2>
				{
					return (void*)v1->sva;
  801b81:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801b84:	8b 40 08             	mov    0x8(%eax),%eax
  801b87:	eb 0c                	jmp    801b95 <smalloc+0xae>
				}
				else
				{
					return NULL;
  801b89:	b8 00 00 00 00       	mov    $0x0,%eax
  801b8e:	eb 05                	jmp    801b95 <smalloc+0xae>
				}
			}

		}
		return NULL;
  801b90:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801b95:	c9                   	leave  
  801b96:	c3                   	ret    

00801b97 <sget>:

//========================================
// [5] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
  801b97:	55                   	push   %ebp
  801b98:	89 e5                	mov    %esp,%ebp
  801b9a:	83 ec 18             	sub    $0x18,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801b9d:	e8 f5 fb ff ff       	call   801797 <InitializeUHeap>

	//This function should find the space for sharing the variable
	// *** ON 4KB BOUNDARY ******** //

	//Use sys_isUHeapPlacementStrategyFIRSTFIT() to check the current strategy
	int ret=sys_getSizeOfSharedObject(ownerEnvID,sharedVarName);
  801ba2:	83 ec 08             	sub    $0x8,%esp
  801ba5:	ff 75 0c             	pushl  0xc(%ebp)
  801ba8:	ff 75 08             	pushl  0x8(%ebp)
  801bab:	e8 fb 03 00 00       	call   801fab <sys_getSizeOfSharedObject>
  801bb0:	83 c4 10             	add    $0x10,%esp
  801bb3:	89 45 f4             	mov    %eax,-0xc(%ebp)
	if(ret==0)
  801bb6:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801bba:	75 07                	jne    801bc3 <sget+0x2c>
	{
		return NULL;
  801bbc:	b8 00 00 00 00       	mov    $0x0,%eax
  801bc1:	eb 64                	jmp    801c27 <sget+0x90>
	}
	if(sys_isUHeapPlacementStrategyFIRSTFIT())
  801bc3:	e8 34 06 00 00       	call   8021fc <sys_isUHeapPlacementStrategyFIRSTFIT>
  801bc8:	85 c0                	test   %eax,%eax
  801bca:	74 56                	je     801c22 <sget+0x8b>
	{
		struct MemBlock * v1=NULL;
  801bcc:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
		v1= alloc_block_FF(ret);
  801bd3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801bd6:	83 ec 0c             	sub    $0xc,%esp
  801bd9:	50                   	push   %eax
  801bda:	e8 1e 0c 00 00       	call   8027fd <alloc_block_FF>
  801bdf:	83 c4 10             	add    $0x10,%esp
  801be2:	89 45 f0             	mov    %eax,-0x10(%ebp)
		if(v1==NULL)
  801be5:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801be9:	75 07                	jne    801bf2 <sget+0x5b>
		{
		return NULL;
  801beb:	b8 00 00 00 00       	mov    $0x0,%eax
  801bf0:	eb 35                	jmp    801c27 <sget+0x90>
	    }
		else
		{
			int ret1=sys_getSharedObject(ownerEnvID,sharedVarName,(void*)v1->sva);
  801bf2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801bf5:	8b 40 08             	mov    0x8(%eax),%eax
  801bf8:	83 ec 04             	sub    $0x4,%esp
  801bfb:	50                   	push   %eax
  801bfc:	ff 75 0c             	pushl  0xc(%ebp)
  801bff:	ff 75 08             	pushl  0x8(%ebp)
  801c02:	e8 c1 03 00 00       	call   801fc8 <sys_getSharedObject>
  801c07:	83 c4 10             	add    $0x10,%esp
  801c0a:	89 45 ec             	mov    %eax,-0x14(%ebp)
			if(ret1>=0)
  801c0d:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  801c11:	78 08                	js     801c1b <sget+0x84>
			{
				return (void*)v1->sva;
  801c13:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801c16:	8b 40 08             	mov    0x8(%eax),%eax
  801c19:	eb 0c                	jmp    801c27 <sget+0x90>
			}
			else
			{
				return NULL;
  801c1b:	b8 00 00 00 00       	mov    $0x0,%eax
  801c20:	eb 05                	jmp    801c27 <sget+0x90>
			}
		}
	}
  return NULL;
  801c22:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801c27:	c9                   	leave  
  801c28:	c3                   	ret    

00801c29 <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  801c29:	55                   	push   %ebp
  801c2a:	89 e5                	mov    %esp,%ebp
  801c2c:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801c2f:	e8 63 fb ff ff       	call   801797 <InitializeUHeap>
	//==============================================================
	// [USER HEAP - USER SIDE] realloc
	// Write your code here, remove the panic and write your code
	panic("realloc() is not implemented yet...!!");
  801c34:	83 ec 04             	sub    $0x4,%esp
  801c37:	68 e4 3c 80 00       	push   $0x803ce4
  801c3c:	68 0e 01 00 00       	push   $0x10e
  801c41:	68 b3 3c 80 00       	push   $0x803cb3
  801c46:	e8 0e eb ff ff       	call   800759 <_panic>

00801c4b <sfree>:
//	use sys_freeSharedObject(...); which switches to the kernel mode,
//	calls freeSharedObject(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the freeSharedObject() function is empty, make sure to implement it.

void sfree(void* virtual_address)
{
  801c4b:	55                   	push   %ebp
  801c4c:	89 e5                	mov    %esp,%ebp
  801c4e:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT MS3 - BONUS] [SHARING - USER SIDE] sfree()

	// Write your code here, remove the panic and write your code
	panic("sfree() is not implemented yet...!!");
  801c51:	83 ec 04             	sub    $0x4,%esp
  801c54:	68 0c 3d 80 00       	push   $0x803d0c
  801c59:	68 22 01 00 00       	push   $0x122
  801c5e:	68 b3 3c 80 00       	push   $0x803cb3
  801c63:	e8 f1 ea ff ff       	call   800759 <_panic>

00801c68 <expand>:

//==================================================================================//
//========================== MODIFICATION FUNCTIONS ================================//
//==================================================================================//
void expand(uint32 newSize)
{
  801c68:	55                   	push   %ebp
  801c69:	89 e5                	mov    %esp,%ebp
  801c6b:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801c6e:	83 ec 04             	sub    $0x4,%esp
  801c71:	68 30 3d 80 00       	push   $0x803d30
  801c76:	68 2d 01 00 00       	push   $0x12d
  801c7b:	68 b3 3c 80 00       	push   $0x803cb3
  801c80:	e8 d4 ea ff ff       	call   800759 <_panic>

00801c85 <shrink>:

}
void shrink(uint32 newSize)
{
  801c85:	55                   	push   %ebp
  801c86:	89 e5                	mov    %esp,%ebp
  801c88:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801c8b:	83 ec 04             	sub    $0x4,%esp
  801c8e:	68 30 3d 80 00       	push   $0x803d30
  801c93:	68 32 01 00 00       	push   $0x132
  801c98:	68 b3 3c 80 00       	push   $0x803cb3
  801c9d:	e8 b7 ea ff ff       	call   800759 <_panic>

00801ca2 <freeHeap>:

}
void freeHeap(void* virtual_address)
{
  801ca2:	55                   	push   %ebp
  801ca3:	89 e5                	mov    %esp,%ebp
  801ca5:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801ca8:	83 ec 04             	sub    $0x4,%esp
  801cab:	68 30 3d 80 00       	push   $0x803d30
  801cb0:	68 37 01 00 00       	push   $0x137
  801cb5:	68 b3 3c 80 00       	push   $0x803cb3
  801cba:	e8 9a ea ff ff       	call   800759 <_panic>

00801cbf <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  801cbf:	55                   	push   %ebp
  801cc0:	89 e5                	mov    %esp,%ebp
  801cc2:	57                   	push   %edi
  801cc3:	56                   	push   %esi
  801cc4:	53                   	push   %ebx
  801cc5:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801cc8:	8b 45 08             	mov    0x8(%ebp),%eax
  801ccb:	8b 55 0c             	mov    0xc(%ebp),%edx
  801cce:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801cd1:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801cd4:	8b 7d 18             	mov    0x18(%ebp),%edi
  801cd7:	8b 75 1c             	mov    0x1c(%ebp),%esi
  801cda:	cd 30                	int    $0x30
  801cdc:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  801cdf:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801ce2:	83 c4 10             	add    $0x10,%esp
  801ce5:	5b                   	pop    %ebx
  801ce6:	5e                   	pop    %esi
  801ce7:	5f                   	pop    %edi
  801ce8:	5d                   	pop    %ebp
  801ce9:	c3                   	ret    

00801cea <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  801cea:	55                   	push   %ebp
  801ceb:	89 e5                	mov    %esp,%ebp
  801ced:	83 ec 04             	sub    $0x4,%esp
  801cf0:	8b 45 10             	mov    0x10(%ebp),%eax
  801cf3:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  801cf6:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801cfa:	8b 45 08             	mov    0x8(%ebp),%eax
  801cfd:	6a 00                	push   $0x0
  801cff:	6a 00                	push   $0x0
  801d01:	52                   	push   %edx
  801d02:	ff 75 0c             	pushl  0xc(%ebp)
  801d05:	50                   	push   %eax
  801d06:	6a 00                	push   $0x0
  801d08:	e8 b2 ff ff ff       	call   801cbf <syscall>
  801d0d:	83 c4 18             	add    $0x18,%esp
}
  801d10:	90                   	nop
  801d11:	c9                   	leave  
  801d12:	c3                   	ret    

00801d13 <sys_cgetc>:

int
sys_cgetc(void)
{
  801d13:	55                   	push   %ebp
  801d14:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  801d16:	6a 00                	push   $0x0
  801d18:	6a 00                	push   $0x0
  801d1a:	6a 00                	push   $0x0
  801d1c:	6a 00                	push   $0x0
  801d1e:	6a 00                	push   $0x0
  801d20:	6a 01                	push   $0x1
  801d22:	e8 98 ff ff ff       	call   801cbf <syscall>
  801d27:	83 c4 18             	add    $0x18,%esp
}
  801d2a:	c9                   	leave  
  801d2b:	c3                   	ret    

00801d2c <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  801d2c:	55                   	push   %ebp
  801d2d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  801d2f:	8b 55 0c             	mov    0xc(%ebp),%edx
  801d32:	8b 45 08             	mov    0x8(%ebp),%eax
  801d35:	6a 00                	push   $0x0
  801d37:	6a 00                	push   $0x0
  801d39:	6a 00                	push   $0x0
  801d3b:	52                   	push   %edx
  801d3c:	50                   	push   %eax
  801d3d:	6a 05                	push   $0x5
  801d3f:	e8 7b ff ff ff       	call   801cbf <syscall>
  801d44:	83 c4 18             	add    $0x18,%esp
}
  801d47:	c9                   	leave  
  801d48:	c3                   	ret    

00801d49 <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  801d49:	55                   	push   %ebp
  801d4a:	89 e5                	mov    %esp,%ebp
  801d4c:	56                   	push   %esi
  801d4d:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  801d4e:	8b 75 18             	mov    0x18(%ebp),%esi
  801d51:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801d54:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801d57:	8b 55 0c             	mov    0xc(%ebp),%edx
  801d5a:	8b 45 08             	mov    0x8(%ebp),%eax
  801d5d:	56                   	push   %esi
  801d5e:	53                   	push   %ebx
  801d5f:	51                   	push   %ecx
  801d60:	52                   	push   %edx
  801d61:	50                   	push   %eax
  801d62:	6a 06                	push   $0x6
  801d64:	e8 56 ff ff ff       	call   801cbf <syscall>
  801d69:	83 c4 18             	add    $0x18,%esp
}
  801d6c:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801d6f:	5b                   	pop    %ebx
  801d70:	5e                   	pop    %esi
  801d71:	5d                   	pop    %ebp
  801d72:	c3                   	ret    

00801d73 <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  801d73:	55                   	push   %ebp
  801d74:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  801d76:	8b 55 0c             	mov    0xc(%ebp),%edx
  801d79:	8b 45 08             	mov    0x8(%ebp),%eax
  801d7c:	6a 00                	push   $0x0
  801d7e:	6a 00                	push   $0x0
  801d80:	6a 00                	push   $0x0
  801d82:	52                   	push   %edx
  801d83:	50                   	push   %eax
  801d84:	6a 07                	push   $0x7
  801d86:	e8 34 ff ff ff       	call   801cbf <syscall>
  801d8b:	83 c4 18             	add    $0x18,%esp
}
  801d8e:	c9                   	leave  
  801d8f:	c3                   	ret    

00801d90 <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  801d90:	55                   	push   %ebp
  801d91:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  801d93:	6a 00                	push   $0x0
  801d95:	6a 00                	push   $0x0
  801d97:	6a 00                	push   $0x0
  801d99:	ff 75 0c             	pushl  0xc(%ebp)
  801d9c:	ff 75 08             	pushl  0x8(%ebp)
  801d9f:	6a 08                	push   $0x8
  801da1:	e8 19 ff ff ff       	call   801cbf <syscall>
  801da6:	83 c4 18             	add    $0x18,%esp
}
  801da9:	c9                   	leave  
  801daa:	c3                   	ret    

00801dab <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  801dab:	55                   	push   %ebp
  801dac:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  801dae:	6a 00                	push   $0x0
  801db0:	6a 00                	push   $0x0
  801db2:	6a 00                	push   $0x0
  801db4:	6a 00                	push   $0x0
  801db6:	6a 00                	push   $0x0
  801db8:	6a 09                	push   $0x9
  801dba:	e8 00 ff ff ff       	call   801cbf <syscall>
  801dbf:	83 c4 18             	add    $0x18,%esp
}
  801dc2:	c9                   	leave  
  801dc3:	c3                   	ret    

00801dc4 <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  801dc4:	55                   	push   %ebp
  801dc5:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  801dc7:	6a 00                	push   $0x0
  801dc9:	6a 00                	push   $0x0
  801dcb:	6a 00                	push   $0x0
  801dcd:	6a 00                	push   $0x0
  801dcf:	6a 00                	push   $0x0
  801dd1:	6a 0a                	push   $0xa
  801dd3:	e8 e7 fe ff ff       	call   801cbf <syscall>
  801dd8:	83 c4 18             	add    $0x18,%esp
}
  801ddb:	c9                   	leave  
  801ddc:	c3                   	ret    

00801ddd <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  801ddd:	55                   	push   %ebp
  801dde:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  801de0:	6a 00                	push   $0x0
  801de2:	6a 00                	push   $0x0
  801de4:	6a 00                	push   $0x0
  801de6:	6a 00                	push   $0x0
  801de8:	6a 00                	push   $0x0
  801dea:	6a 0b                	push   $0xb
  801dec:	e8 ce fe ff ff       	call   801cbf <syscall>
  801df1:	83 c4 18             	add    $0x18,%esp
}
  801df4:	c9                   	leave  
  801df5:	c3                   	ret    

00801df6 <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  801df6:	55                   	push   %ebp
  801df7:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  801df9:	6a 00                	push   $0x0
  801dfb:	6a 00                	push   $0x0
  801dfd:	6a 00                	push   $0x0
  801dff:	ff 75 0c             	pushl  0xc(%ebp)
  801e02:	ff 75 08             	pushl  0x8(%ebp)
  801e05:	6a 0f                	push   $0xf
  801e07:	e8 b3 fe ff ff       	call   801cbf <syscall>
  801e0c:	83 c4 18             	add    $0x18,%esp
	return;
  801e0f:	90                   	nop
}
  801e10:	c9                   	leave  
  801e11:	c3                   	ret    

00801e12 <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  801e12:	55                   	push   %ebp
  801e13:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  801e15:	6a 00                	push   $0x0
  801e17:	6a 00                	push   $0x0
  801e19:	6a 00                	push   $0x0
  801e1b:	ff 75 0c             	pushl  0xc(%ebp)
  801e1e:	ff 75 08             	pushl  0x8(%ebp)
  801e21:	6a 10                	push   $0x10
  801e23:	e8 97 fe ff ff       	call   801cbf <syscall>
  801e28:	83 c4 18             	add    $0x18,%esp
	return ;
  801e2b:	90                   	nop
}
  801e2c:	c9                   	leave  
  801e2d:	c3                   	ret    

00801e2e <sys_allocate_chunk>:

void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  801e2e:	55                   	push   %ebp
  801e2f:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  801e31:	6a 00                	push   $0x0
  801e33:	6a 00                	push   $0x0
  801e35:	ff 75 10             	pushl  0x10(%ebp)
  801e38:	ff 75 0c             	pushl  0xc(%ebp)
  801e3b:	ff 75 08             	pushl  0x8(%ebp)
  801e3e:	6a 11                	push   $0x11
  801e40:	e8 7a fe ff ff       	call   801cbf <syscall>
  801e45:	83 c4 18             	add    $0x18,%esp
	return ;
  801e48:	90                   	nop
}
  801e49:	c9                   	leave  
  801e4a:	c3                   	ret    

00801e4b <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  801e4b:	55                   	push   %ebp
  801e4c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  801e4e:	6a 00                	push   $0x0
  801e50:	6a 00                	push   $0x0
  801e52:	6a 00                	push   $0x0
  801e54:	6a 00                	push   $0x0
  801e56:	6a 00                	push   $0x0
  801e58:	6a 0c                	push   $0xc
  801e5a:	e8 60 fe ff ff       	call   801cbf <syscall>
  801e5f:	83 c4 18             	add    $0x18,%esp
}
  801e62:	c9                   	leave  
  801e63:	c3                   	ret    

00801e64 <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  801e64:	55                   	push   %ebp
  801e65:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  801e67:	6a 00                	push   $0x0
  801e69:	6a 00                	push   $0x0
  801e6b:	6a 00                	push   $0x0
  801e6d:	6a 00                	push   $0x0
  801e6f:	ff 75 08             	pushl  0x8(%ebp)
  801e72:	6a 0d                	push   $0xd
  801e74:	e8 46 fe ff ff       	call   801cbf <syscall>
  801e79:	83 c4 18             	add    $0x18,%esp
}
  801e7c:	c9                   	leave  
  801e7d:	c3                   	ret    

00801e7e <sys_scarce_memory>:

void sys_scarce_memory()
{
  801e7e:	55                   	push   %ebp
  801e7f:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  801e81:	6a 00                	push   $0x0
  801e83:	6a 00                	push   $0x0
  801e85:	6a 00                	push   $0x0
  801e87:	6a 00                	push   $0x0
  801e89:	6a 00                	push   $0x0
  801e8b:	6a 0e                	push   $0xe
  801e8d:	e8 2d fe ff ff       	call   801cbf <syscall>
  801e92:	83 c4 18             	add    $0x18,%esp
}
  801e95:	90                   	nop
  801e96:	c9                   	leave  
  801e97:	c3                   	ret    

00801e98 <sys_disable_interrupt>:

//NEW !! 2012...
void
sys_disable_interrupt()
{
  801e98:	55                   	push   %ebp
  801e99:	89 e5                	mov    %esp,%ebp
	syscall(SYS_disableINTR,0, 0, 0, 0, 0);
  801e9b:	6a 00                	push   $0x0
  801e9d:	6a 00                	push   $0x0
  801e9f:	6a 00                	push   $0x0
  801ea1:	6a 00                	push   $0x0
  801ea3:	6a 00                	push   $0x0
  801ea5:	6a 13                	push   $0x13
  801ea7:	e8 13 fe ff ff       	call   801cbf <syscall>
  801eac:	83 c4 18             	add    $0x18,%esp
}
  801eaf:	90                   	nop
  801eb0:	c9                   	leave  
  801eb1:	c3                   	ret    

00801eb2 <sys_enable_interrupt>:


void
sys_enable_interrupt()
{
  801eb2:	55                   	push   %ebp
  801eb3:	89 e5                	mov    %esp,%ebp
	syscall(SYS_enableINTR,0, 0, 0, 0, 0);
  801eb5:	6a 00                	push   $0x0
  801eb7:	6a 00                	push   $0x0
  801eb9:	6a 00                	push   $0x0
  801ebb:	6a 00                	push   $0x0
  801ebd:	6a 00                	push   $0x0
  801ebf:	6a 14                	push   $0x14
  801ec1:	e8 f9 fd ff ff       	call   801cbf <syscall>
  801ec6:	83 c4 18             	add    $0x18,%esp
}
  801ec9:	90                   	nop
  801eca:	c9                   	leave  
  801ecb:	c3                   	ret    

00801ecc <sys_cputc>:


void
sys_cputc(const char c)
{
  801ecc:	55                   	push   %ebp
  801ecd:	89 e5                	mov    %esp,%ebp
  801ecf:	83 ec 04             	sub    $0x4,%esp
  801ed2:	8b 45 08             	mov    0x8(%ebp),%eax
  801ed5:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  801ed8:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801edc:	6a 00                	push   $0x0
  801ede:	6a 00                	push   $0x0
  801ee0:	6a 00                	push   $0x0
  801ee2:	6a 00                	push   $0x0
  801ee4:	50                   	push   %eax
  801ee5:	6a 15                	push   $0x15
  801ee7:	e8 d3 fd ff ff       	call   801cbf <syscall>
  801eec:	83 c4 18             	add    $0x18,%esp
}
  801eef:	90                   	nop
  801ef0:	c9                   	leave  
  801ef1:	c3                   	ret    

00801ef2 <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  801ef2:	55                   	push   %ebp
  801ef3:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  801ef5:	6a 00                	push   $0x0
  801ef7:	6a 00                	push   $0x0
  801ef9:	6a 00                	push   $0x0
  801efb:	6a 00                	push   $0x0
  801efd:	6a 00                	push   $0x0
  801eff:	6a 16                	push   $0x16
  801f01:	e8 b9 fd ff ff       	call   801cbf <syscall>
  801f06:	83 c4 18             	add    $0x18,%esp
}
  801f09:	90                   	nop
  801f0a:	c9                   	leave  
  801f0b:	c3                   	ret    

00801f0c <sys_createSemaphore>:

int
sys_createSemaphore(char* semaphoreName, uint32 initialValue)
{
  801f0c:	55                   	push   %ebp
  801f0d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_semaphore,(uint32)semaphoreName, (uint32)initialValue, 0, 0, 0);
  801f0f:	8b 45 08             	mov    0x8(%ebp),%eax
  801f12:	6a 00                	push   $0x0
  801f14:	6a 00                	push   $0x0
  801f16:	6a 00                	push   $0x0
  801f18:	ff 75 0c             	pushl  0xc(%ebp)
  801f1b:	50                   	push   %eax
  801f1c:	6a 17                	push   $0x17
  801f1e:	e8 9c fd ff ff       	call   801cbf <syscall>
  801f23:	83 c4 18             	add    $0x18,%esp
}
  801f26:	c9                   	leave  
  801f27:	c3                   	ret    

00801f28 <sys_getSemaphoreValue>:

int
sys_getSemaphoreValue(int32 ownerEnvID, char* semaphoreName)
{
  801f28:	55                   	push   %ebp
  801f29:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_semaphore_value,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801f2b:	8b 55 0c             	mov    0xc(%ebp),%edx
  801f2e:	8b 45 08             	mov    0x8(%ebp),%eax
  801f31:	6a 00                	push   $0x0
  801f33:	6a 00                	push   $0x0
  801f35:	6a 00                	push   $0x0
  801f37:	52                   	push   %edx
  801f38:	50                   	push   %eax
  801f39:	6a 1a                	push   $0x1a
  801f3b:	e8 7f fd ff ff       	call   801cbf <syscall>
  801f40:	83 c4 18             	add    $0x18,%esp
}
  801f43:	c9                   	leave  
  801f44:	c3                   	ret    

00801f45 <sys_waitSemaphore>:

void
sys_waitSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  801f45:	55                   	push   %ebp
  801f46:	89 e5                	mov    %esp,%ebp
	syscall(SYS_wait_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801f48:	8b 55 0c             	mov    0xc(%ebp),%edx
  801f4b:	8b 45 08             	mov    0x8(%ebp),%eax
  801f4e:	6a 00                	push   $0x0
  801f50:	6a 00                	push   $0x0
  801f52:	6a 00                	push   $0x0
  801f54:	52                   	push   %edx
  801f55:	50                   	push   %eax
  801f56:	6a 18                	push   $0x18
  801f58:	e8 62 fd ff ff       	call   801cbf <syscall>
  801f5d:	83 c4 18             	add    $0x18,%esp
}
  801f60:	90                   	nop
  801f61:	c9                   	leave  
  801f62:	c3                   	ret    

00801f63 <sys_signalSemaphore>:

void
sys_signalSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  801f63:	55                   	push   %ebp
  801f64:	89 e5                	mov    %esp,%ebp
	syscall(SYS_signal_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801f66:	8b 55 0c             	mov    0xc(%ebp),%edx
  801f69:	8b 45 08             	mov    0x8(%ebp),%eax
  801f6c:	6a 00                	push   $0x0
  801f6e:	6a 00                	push   $0x0
  801f70:	6a 00                	push   $0x0
  801f72:	52                   	push   %edx
  801f73:	50                   	push   %eax
  801f74:	6a 19                	push   $0x19
  801f76:	e8 44 fd ff ff       	call   801cbf <syscall>
  801f7b:	83 c4 18             	add    $0x18,%esp
}
  801f7e:	90                   	nop
  801f7f:	c9                   	leave  
  801f80:	c3                   	ret    

00801f81 <sys_createSharedObject>:

int
sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  801f81:	55                   	push   %ebp
  801f82:	89 e5                	mov    %esp,%ebp
  801f84:	83 ec 04             	sub    $0x4,%esp
  801f87:	8b 45 10             	mov    0x10(%ebp),%eax
  801f8a:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  801f8d:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801f90:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801f94:	8b 45 08             	mov    0x8(%ebp),%eax
  801f97:	6a 00                	push   $0x0
  801f99:	51                   	push   %ecx
  801f9a:	52                   	push   %edx
  801f9b:	ff 75 0c             	pushl  0xc(%ebp)
  801f9e:	50                   	push   %eax
  801f9f:	6a 1b                	push   $0x1b
  801fa1:	e8 19 fd ff ff       	call   801cbf <syscall>
  801fa6:	83 c4 18             	add    $0x18,%esp
}
  801fa9:	c9                   	leave  
  801faa:	c3                   	ret    

00801fab <sys_getSizeOfSharedObject>:

//2017:
int
sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  801fab:	55                   	push   %ebp
  801fac:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  801fae:	8b 55 0c             	mov    0xc(%ebp),%edx
  801fb1:	8b 45 08             	mov    0x8(%ebp),%eax
  801fb4:	6a 00                	push   $0x0
  801fb6:	6a 00                	push   $0x0
  801fb8:	6a 00                	push   $0x0
  801fba:	52                   	push   %edx
  801fbb:	50                   	push   %eax
  801fbc:	6a 1c                	push   $0x1c
  801fbe:	e8 fc fc ff ff       	call   801cbf <syscall>
  801fc3:	83 c4 18             	add    $0x18,%esp
}
  801fc6:	c9                   	leave  
  801fc7:	c3                   	ret    

00801fc8 <sys_getSharedObject>:
//==========

int
sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  801fc8:	55                   	push   %ebp
  801fc9:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  801fcb:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801fce:	8b 55 0c             	mov    0xc(%ebp),%edx
  801fd1:	8b 45 08             	mov    0x8(%ebp),%eax
  801fd4:	6a 00                	push   $0x0
  801fd6:	6a 00                	push   $0x0
  801fd8:	51                   	push   %ecx
  801fd9:	52                   	push   %edx
  801fda:	50                   	push   %eax
  801fdb:	6a 1d                	push   $0x1d
  801fdd:	e8 dd fc ff ff       	call   801cbf <syscall>
  801fe2:	83 c4 18             	add    $0x18,%esp
}
  801fe5:	c9                   	leave  
  801fe6:	c3                   	ret    

00801fe7 <sys_freeSharedObject>:

int
sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  801fe7:	55                   	push   %ebp
  801fe8:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  801fea:	8b 55 0c             	mov    0xc(%ebp),%edx
  801fed:	8b 45 08             	mov    0x8(%ebp),%eax
  801ff0:	6a 00                	push   $0x0
  801ff2:	6a 00                	push   $0x0
  801ff4:	6a 00                	push   $0x0
  801ff6:	52                   	push   %edx
  801ff7:	50                   	push   %eax
  801ff8:	6a 1e                	push   $0x1e
  801ffa:	e8 c0 fc ff ff       	call   801cbf <syscall>
  801fff:	83 c4 18             	add    $0x18,%esp
}
  802002:	c9                   	leave  
  802003:	c3                   	ret    

00802004 <sys_getMaxShares>:

uint32 	sys_getMaxShares()
{
  802004:	55                   	push   %ebp
  802005:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_max_shares,0, 0, 0, 0, 0);
  802007:	6a 00                	push   $0x0
  802009:	6a 00                	push   $0x0
  80200b:	6a 00                	push   $0x0
  80200d:	6a 00                	push   $0x0
  80200f:	6a 00                	push   $0x0
  802011:	6a 1f                	push   $0x1f
  802013:	e8 a7 fc ff ff       	call   801cbf <syscall>
  802018:	83 c4 18             	add    $0x18,%esp
}
  80201b:	c9                   	leave  
  80201c:	c3                   	ret    

0080201d <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  80201d:	55                   	push   %ebp
  80201e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  802020:	8b 45 08             	mov    0x8(%ebp),%eax
  802023:	6a 00                	push   $0x0
  802025:	ff 75 14             	pushl  0x14(%ebp)
  802028:	ff 75 10             	pushl  0x10(%ebp)
  80202b:	ff 75 0c             	pushl  0xc(%ebp)
  80202e:	50                   	push   %eax
  80202f:	6a 20                	push   $0x20
  802031:	e8 89 fc ff ff       	call   801cbf <syscall>
  802036:	83 c4 18             	add    $0x18,%esp
}
  802039:	c9                   	leave  
  80203a:	c3                   	ret    

0080203b <sys_run_env>:

void
sys_run_env(int32 envId)
{
  80203b:	55                   	push   %ebp
  80203c:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  80203e:	8b 45 08             	mov    0x8(%ebp),%eax
  802041:	6a 00                	push   $0x0
  802043:	6a 00                	push   $0x0
  802045:	6a 00                	push   $0x0
  802047:	6a 00                	push   $0x0
  802049:	50                   	push   %eax
  80204a:	6a 21                	push   $0x21
  80204c:	e8 6e fc ff ff       	call   801cbf <syscall>
  802051:	83 c4 18             	add    $0x18,%esp
}
  802054:	90                   	nop
  802055:	c9                   	leave  
  802056:	c3                   	ret    

00802057 <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  802057:	55                   	push   %ebp
  802058:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  80205a:	8b 45 08             	mov    0x8(%ebp),%eax
  80205d:	6a 00                	push   $0x0
  80205f:	6a 00                	push   $0x0
  802061:	6a 00                	push   $0x0
  802063:	6a 00                	push   $0x0
  802065:	50                   	push   %eax
  802066:	6a 22                	push   $0x22
  802068:	e8 52 fc ff ff       	call   801cbf <syscall>
  80206d:	83 c4 18             	add    $0x18,%esp
}
  802070:	c9                   	leave  
  802071:	c3                   	ret    

00802072 <sys_getenvid>:

int32 sys_getenvid(void)
{
  802072:	55                   	push   %ebp
  802073:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  802075:	6a 00                	push   $0x0
  802077:	6a 00                	push   $0x0
  802079:	6a 00                	push   $0x0
  80207b:	6a 00                	push   $0x0
  80207d:	6a 00                	push   $0x0
  80207f:	6a 02                	push   $0x2
  802081:	e8 39 fc ff ff       	call   801cbf <syscall>
  802086:	83 c4 18             	add    $0x18,%esp
}
  802089:	c9                   	leave  
  80208a:	c3                   	ret    

0080208b <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  80208b:	55                   	push   %ebp
  80208c:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  80208e:	6a 00                	push   $0x0
  802090:	6a 00                	push   $0x0
  802092:	6a 00                	push   $0x0
  802094:	6a 00                	push   $0x0
  802096:	6a 00                	push   $0x0
  802098:	6a 03                	push   $0x3
  80209a:	e8 20 fc ff ff       	call   801cbf <syscall>
  80209f:	83 c4 18             	add    $0x18,%esp
}
  8020a2:	c9                   	leave  
  8020a3:	c3                   	ret    

008020a4 <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  8020a4:	55                   	push   %ebp
  8020a5:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  8020a7:	6a 00                	push   $0x0
  8020a9:	6a 00                	push   $0x0
  8020ab:	6a 00                	push   $0x0
  8020ad:	6a 00                	push   $0x0
  8020af:	6a 00                	push   $0x0
  8020b1:	6a 04                	push   $0x4
  8020b3:	e8 07 fc ff ff       	call   801cbf <syscall>
  8020b8:	83 c4 18             	add    $0x18,%esp
}
  8020bb:	c9                   	leave  
  8020bc:	c3                   	ret    

008020bd <sys_exit_env>:


void sys_exit_env(void)
{
  8020bd:	55                   	push   %ebp
  8020be:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  8020c0:	6a 00                	push   $0x0
  8020c2:	6a 00                	push   $0x0
  8020c4:	6a 00                	push   $0x0
  8020c6:	6a 00                	push   $0x0
  8020c8:	6a 00                	push   $0x0
  8020ca:	6a 23                	push   $0x23
  8020cc:	e8 ee fb ff ff       	call   801cbf <syscall>
  8020d1:	83 c4 18             	add    $0x18,%esp
}
  8020d4:	90                   	nop
  8020d5:	c9                   	leave  
  8020d6:	c3                   	ret    

008020d7 <sys_get_virtual_time>:


struct uint64
sys_get_virtual_time()
{
  8020d7:	55                   	push   %ebp
  8020d8:	89 e5                	mov    %esp,%ebp
  8020da:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  8020dd:	8d 45 f8             	lea    -0x8(%ebp),%eax
  8020e0:	8d 50 04             	lea    0x4(%eax),%edx
  8020e3:	8d 45 f8             	lea    -0x8(%ebp),%eax
  8020e6:	6a 00                	push   $0x0
  8020e8:	6a 00                	push   $0x0
  8020ea:	6a 00                	push   $0x0
  8020ec:	52                   	push   %edx
  8020ed:	50                   	push   %eax
  8020ee:	6a 24                	push   $0x24
  8020f0:	e8 ca fb ff ff       	call   801cbf <syscall>
  8020f5:	83 c4 18             	add    $0x18,%esp
	return result;
  8020f8:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8020fb:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8020fe:	8b 55 fc             	mov    -0x4(%ebp),%edx
  802101:	89 01                	mov    %eax,(%ecx)
  802103:	89 51 04             	mov    %edx,0x4(%ecx)
}
  802106:	8b 45 08             	mov    0x8(%ebp),%eax
  802109:	c9                   	leave  
  80210a:	c2 04 00             	ret    $0x4

0080210d <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  80210d:	55                   	push   %ebp
  80210e:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  802110:	6a 00                	push   $0x0
  802112:	6a 00                	push   $0x0
  802114:	ff 75 10             	pushl  0x10(%ebp)
  802117:	ff 75 0c             	pushl  0xc(%ebp)
  80211a:	ff 75 08             	pushl  0x8(%ebp)
  80211d:	6a 12                	push   $0x12
  80211f:	e8 9b fb ff ff       	call   801cbf <syscall>
  802124:	83 c4 18             	add    $0x18,%esp
	return ;
  802127:	90                   	nop
}
  802128:	c9                   	leave  
  802129:	c3                   	ret    

0080212a <sys_rcr2>:
uint32 sys_rcr2()
{
  80212a:	55                   	push   %ebp
  80212b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  80212d:	6a 00                	push   $0x0
  80212f:	6a 00                	push   $0x0
  802131:	6a 00                	push   $0x0
  802133:	6a 00                	push   $0x0
  802135:	6a 00                	push   $0x0
  802137:	6a 25                	push   $0x25
  802139:	e8 81 fb ff ff       	call   801cbf <syscall>
  80213e:	83 c4 18             	add    $0x18,%esp
}
  802141:	c9                   	leave  
  802142:	c3                   	ret    

00802143 <sys_bypassPageFault>:
void sys_bypassPageFault(uint8 instrLength)
{
  802143:	55                   	push   %ebp
  802144:	89 e5                	mov    %esp,%ebp
  802146:	83 ec 04             	sub    $0x4,%esp
  802149:	8b 45 08             	mov    0x8(%ebp),%eax
  80214c:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  80214f:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  802153:	6a 00                	push   $0x0
  802155:	6a 00                	push   $0x0
  802157:	6a 00                	push   $0x0
  802159:	6a 00                	push   $0x0
  80215b:	50                   	push   %eax
  80215c:	6a 26                	push   $0x26
  80215e:	e8 5c fb ff ff       	call   801cbf <syscall>
  802163:	83 c4 18             	add    $0x18,%esp
	return ;
  802166:	90                   	nop
}
  802167:	c9                   	leave  
  802168:	c3                   	ret    

00802169 <rsttst>:
void rsttst()
{
  802169:	55                   	push   %ebp
  80216a:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  80216c:	6a 00                	push   $0x0
  80216e:	6a 00                	push   $0x0
  802170:	6a 00                	push   $0x0
  802172:	6a 00                	push   $0x0
  802174:	6a 00                	push   $0x0
  802176:	6a 28                	push   $0x28
  802178:	e8 42 fb ff ff       	call   801cbf <syscall>
  80217d:	83 c4 18             	add    $0x18,%esp
	return ;
  802180:	90                   	nop
}
  802181:	c9                   	leave  
  802182:	c3                   	ret    

00802183 <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  802183:	55                   	push   %ebp
  802184:	89 e5                	mov    %esp,%ebp
  802186:	83 ec 04             	sub    $0x4,%esp
  802189:	8b 45 14             	mov    0x14(%ebp),%eax
  80218c:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  80218f:	8b 55 18             	mov    0x18(%ebp),%edx
  802192:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  802196:	52                   	push   %edx
  802197:	50                   	push   %eax
  802198:	ff 75 10             	pushl  0x10(%ebp)
  80219b:	ff 75 0c             	pushl  0xc(%ebp)
  80219e:	ff 75 08             	pushl  0x8(%ebp)
  8021a1:	6a 27                	push   $0x27
  8021a3:	e8 17 fb ff ff       	call   801cbf <syscall>
  8021a8:	83 c4 18             	add    $0x18,%esp
	return ;
  8021ab:	90                   	nop
}
  8021ac:	c9                   	leave  
  8021ad:	c3                   	ret    

008021ae <chktst>:
void chktst(uint32 n)
{
  8021ae:	55                   	push   %ebp
  8021af:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  8021b1:	6a 00                	push   $0x0
  8021b3:	6a 00                	push   $0x0
  8021b5:	6a 00                	push   $0x0
  8021b7:	6a 00                	push   $0x0
  8021b9:	ff 75 08             	pushl  0x8(%ebp)
  8021bc:	6a 29                	push   $0x29
  8021be:	e8 fc fa ff ff       	call   801cbf <syscall>
  8021c3:	83 c4 18             	add    $0x18,%esp
	return ;
  8021c6:	90                   	nop
}
  8021c7:	c9                   	leave  
  8021c8:	c3                   	ret    

008021c9 <inctst>:

void inctst()
{
  8021c9:	55                   	push   %ebp
  8021ca:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  8021cc:	6a 00                	push   $0x0
  8021ce:	6a 00                	push   $0x0
  8021d0:	6a 00                	push   $0x0
  8021d2:	6a 00                	push   $0x0
  8021d4:	6a 00                	push   $0x0
  8021d6:	6a 2a                	push   $0x2a
  8021d8:	e8 e2 fa ff ff       	call   801cbf <syscall>
  8021dd:	83 c4 18             	add    $0x18,%esp
	return ;
  8021e0:	90                   	nop
}
  8021e1:	c9                   	leave  
  8021e2:	c3                   	ret    

008021e3 <gettst>:
uint32 gettst()
{
  8021e3:	55                   	push   %ebp
  8021e4:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  8021e6:	6a 00                	push   $0x0
  8021e8:	6a 00                	push   $0x0
  8021ea:	6a 00                	push   $0x0
  8021ec:	6a 00                	push   $0x0
  8021ee:	6a 00                	push   $0x0
  8021f0:	6a 2b                	push   $0x2b
  8021f2:	e8 c8 fa ff ff       	call   801cbf <syscall>
  8021f7:	83 c4 18             	add    $0x18,%esp
}
  8021fa:	c9                   	leave  
  8021fb:	c3                   	ret    

008021fc <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  8021fc:	55                   	push   %ebp
  8021fd:	89 e5                	mov    %esp,%ebp
  8021ff:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  802202:	6a 00                	push   $0x0
  802204:	6a 00                	push   $0x0
  802206:	6a 00                	push   $0x0
  802208:	6a 00                	push   $0x0
  80220a:	6a 00                	push   $0x0
  80220c:	6a 2c                	push   $0x2c
  80220e:	e8 ac fa ff ff       	call   801cbf <syscall>
  802213:	83 c4 18             	add    $0x18,%esp
  802216:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  802219:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  80221d:	75 07                	jne    802226 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  80221f:	b8 01 00 00 00       	mov    $0x1,%eax
  802224:	eb 05                	jmp    80222b <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  802226:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80222b:	c9                   	leave  
  80222c:	c3                   	ret    

0080222d <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  80222d:	55                   	push   %ebp
  80222e:	89 e5                	mov    %esp,%ebp
  802230:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  802233:	6a 00                	push   $0x0
  802235:	6a 00                	push   $0x0
  802237:	6a 00                	push   $0x0
  802239:	6a 00                	push   $0x0
  80223b:	6a 00                	push   $0x0
  80223d:	6a 2c                	push   $0x2c
  80223f:	e8 7b fa ff ff       	call   801cbf <syscall>
  802244:	83 c4 18             	add    $0x18,%esp
  802247:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  80224a:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  80224e:	75 07                	jne    802257 <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  802250:	b8 01 00 00 00       	mov    $0x1,%eax
  802255:	eb 05                	jmp    80225c <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  802257:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80225c:	c9                   	leave  
  80225d:	c3                   	ret    

0080225e <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  80225e:	55                   	push   %ebp
  80225f:	89 e5                	mov    %esp,%ebp
  802261:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  802264:	6a 00                	push   $0x0
  802266:	6a 00                	push   $0x0
  802268:	6a 00                	push   $0x0
  80226a:	6a 00                	push   $0x0
  80226c:	6a 00                	push   $0x0
  80226e:	6a 2c                	push   $0x2c
  802270:	e8 4a fa ff ff       	call   801cbf <syscall>
  802275:	83 c4 18             	add    $0x18,%esp
  802278:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  80227b:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  80227f:	75 07                	jne    802288 <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  802281:	b8 01 00 00 00       	mov    $0x1,%eax
  802286:	eb 05                	jmp    80228d <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  802288:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80228d:	c9                   	leave  
  80228e:	c3                   	ret    

0080228f <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  80228f:	55                   	push   %ebp
  802290:	89 e5                	mov    %esp,%ebp
  802292:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  802295:	6a 00                	push   $0x0
  802297:	6a 00                	push   $0x0
  802299:	6a 00                	push   $0x0
  80229b:	6a 00                	push   $0x0
  80229d:	6a 00                	push   $0x0
  80229f:	6a 2c                	push   $0x2c
  8022a1:	e8 19 fa ff ff       	call   801cbf <syscall>
  8022a6:	83 c4 18             	add    $0x18,%esp
  8022a9:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  8022ac:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  8022b0:	75 07                	jne    8022b9 <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  8022b2:	b8 01 00 00 00       	mov    $0x1,%eax
  8022b7:	eb 05                	jmp    8022be <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  8022b9:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8022be:	c9                   	leave  
  8022bf:	c3                   	ret    

008022c0 <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  8022c0:	55                   	push   %ebp
  8022c1:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  8022c3:	6a 00                	push   $0x0
  8022c5:	6a 00                	push   $0x0
  8022c7:	6a 00                	push   $0x0
  8022c9:	6a 00                	push   $0x0
  8022cb:	ff 75 08             	pushl  0x8(%ebp)
  8022ce:	6a 2d                	push   $0x2d
  8022d0:	e8 ea f9 ff ff       	call   801cbf <syscall>
  8022d5:	83 c4 18             	add    $0x18,%esp
	return ;
  8022d8:	90                   	nop
}
  8022d9:	c9                   	leave  
  8022da:	c3                   	ret    

008022db <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  8022db:	55                   	push   %ebp
  8022dc:	89 e5                	mov    %esp,%ebp
  8022de:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  8022df:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8022e2:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8022e5:	8b 55 0c             	mov    0xc(%ebp),%edx
  8022e8:	8b 45 08             	mov    0x8(%ebp),%eax
  8022eb:	6a 00                	push   $0x0
  8022ed:	53                   	push   %ebx
  8022ee:	51                   	push   %ecx
  8022ef:	52                   	push   %edx
  8022f0:	50                   	push   %eax
  8022f1:	6a 2e                	push   $0x2e
  8022f3:	e8 c7 f9 ff ff       	call   801cbf <syscall>
  8022f8:	83 c4 18             	add    $0x18,%esp
}
  8022fb:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8022fe:	c9                   	leave  
  8022ff:	c3                   	ret    

00802300 <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  802300:	55                   	push   %ebp
  802301:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  802303:	8b 55 0c             	mov    0xc(%ebp),%edx
  802306:	8b 45 08             	mov    0x8(%ebp),%eax
  802309:	6a 00                	push   $0x0
  80230b:	6a 00                	push   $0x0
  80230d:	6a 00                	push   $0x0
  80230f:	52                   	push   %edx
  802310:	50                   	push   %eax
  802311:	6a 2f                	push   $0x2f
  802313:	e8 a7 f9 ff ff       	call   801cbf <syscall>
  802318:	83 c4 18             	add    $0x18,%esp
}
  80231b:	c9                   	leave  
  80231c:	c3                   	ret    

0080231d <print_mem_block_lists>:
//===========================
// PRINT MEM BLOCK LISTS:
//===========================

void print_mem_block_lists()
{
  80231d:	55                   	push   %ebp
  80231e:	89 e5                	mov    %esp,%ebp
  802320:	83 ec 18             	sub    $0x18,%esp
	cprintf("\n=========================================\n");
  802323:	83 ec 0c             	sub    $0xc,%esp
  802326:	68 40 3d 80 00       	push   $0x803d40
  80232b:	e8 dd e6 ff ff       	call   800a0d <cprintf>
  802330:	83 c4 10             	add    $0x10,%esp
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
  802333:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nFreeMemBlocksList:\n");
  80233a:	83 ec 0c             	sub    $0xc,%esp
  80233d:	68 6c 3d 80 00       	push   $0x803d6c
  802342:	e8 c6 e6 ff ff       	call   800a0d <cprintf>
  802347:	83 c4 10             	add    $0x10,%esp
	uint8 sorted = 1 ;
  80234a:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &FreeMemBlocksList)
  80234e:	a1 38 41 80 00       	mov    0x804138,%eax
  802353:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802356:	eb 56                	jmp    8023ae <print_mem_block_lists+0x91>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  802358:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80235c:	74 1c                	je     80237a <print_mem_block_lists+0x5d>
  80235e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802361:	8b 50 08             	mov    0x8(%eax),%edx
  802364:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802367:	8b 48 08             	mov    0x8(%eax),%ecx
  80236a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80236d:	8b 40 0c             	mov    0xc(%eax),%eax
  802370:	01 c8                	add    %ecx,%eax
  802372:	39 c2                	cmp    %eax,%edx
  802374:	73 04                	jae    80237a <print_mem_block_lists+0x5d>
			sorted = 0 ;
  802376:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  80237a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80237d:	8b 50 08             	mov    0x8(%eax),%edx
  802380:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802383:	8b 40 0c             	mov    0xc(%eax),%eax
  802386:	01 c2                	add    %eax,%edx
  802388:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80238b:	8b 40 08             	mov    0x8(%eax),%eax
  80238e:	83 ec 04             	sub    $0x4,%esp
  802391:	52                   	push   %edx
  802392:	50                   	push   %eax
  802393:	68 81 3d 80 00       	push   $0x803d81
  802398:	e8 70 e6 ff ff       	call   800a0d <cprintf>
  80239d:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  8023a0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023a3:	89 45 f0             	mov    %eax,-0x10(%ebp)
	cprintf("\n=========================================\n");
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
	cprintf("\nFreeMemBlocksList:\n");
	uint8 sorted = 1 ;
	LIST_FOREACH(blk, &FreeMemBlocksList)
  8023a6:	a1 40 41 80 00       	mov    0x804140,%eax
  8023ab:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8023ae:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8023b2:	74 07                	je     8023bb <print_mem_block_lists+0x9e>
  8023b4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023b7:	8b 00                	mov    (%eax),%eax
  8023b9:	eb 05                	jmp    8023c0 <print_mem_block_lists+0xa3>
  8023bb:	b8 00 00 00 00       	mov    $0x0,%eax
  8023c0:	a3 40 41 80 00       	mov    %eax,0x804140
  8023c5:	a1 40 41 80 00       	mov    0x804140,%eax
  8023ca:	85 c0                	test   %eax,%eax
  8023cc:	75 8a                	jne    802358 <print_mem_block_lists+0x3b>
  8023ce:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8023d2:	75 84                	jne    802358 <print_mem_block_lists+0x3b>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;
  8023d4:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  8023d8:	75 10                	jne    8023ea <print_mem_block_lists+0xcd>
  8023da:	83 ec 0c             	sub    $0xc,%esp
  8023dd:	68 90 3d 80 00       	push   $0x803d90
  8023e2:	e8 26 e6 ff ff       	call   800a0d <cprintf>
  8023e7:	83 c4 10             	add    $0x10,%esp

	lastBlk = NULL ;
  8023ea:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nAllocMemBlocksList:\n");
  8023f1:	83 ec 0c             	sub    $0xc,%esp
  8023f4:	68 b4 3d 80 00       	push   $0x803db4
  8023f9:	e8 0f e6 ff ff       	call   800a0d <cprintf>
  8023fe:	83 c4 10             	add    $0x10,%esp
	sorted = 1 ;
  802401:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &AllocMemBlocksList)
  802405:	a1 40 40 80 00       	mov    0x804040,%eax
  80240a:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80240d:	eb 56                	jmp    802465 <print_mem_block_lists+0x148>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  80240f:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802413:	74 1c                	je     802431 <print_mem_block_lists+0x114>
  802415:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802418:	8b 50 08             	mov    0x8(%eax),%edx
  80241b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80241e:	8b 48 08             	mov    0x8(%eax),%ecx
  802421:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802424:	8b 40 0c             	mov    0xc(%eax),%eax
  802427:	01 c8                	add    %ecx,%eax
  802429:	39 c2                	cmp    %eax,%edx
  80242b:	73 04                	jae    802431 <print_mem_block_lists+0x114>
			sorted = 0 ;
  80242d:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  802431:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802434:	8b 50 08             	mov    0x8(%eax),%edx
  802437:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80243a:	8b 40 0c             	mov    0xc(%eax),%eax
  80243d:	01 c2                	add    %eax,%edx
  80243f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802442:	8b 40 08             	mov    0x8(%eax),%eax
  802445:	83 ec 04             	sub    $0x4,%esp
  802448:	52                   	push   %edx
  802449:	50                   	push   %eax
  80244a:	68 81 3d 80 00       	push   $0x803d81
  80244f:	e8 b9 e5 ff ff       	call   800a0d <cprintf>
  802454:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  802457:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80245a:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;

	lastBlk = NULL ;
	cprintf("\nAllocMemBlocksList:\n");
	sorted = 1 ;
	LIST_FOREACH(blk, &AllocMemBlocksList)
  80245d:	a1 48 40 80 00       	mov    0x804048,%eax
  802462:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802465:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802469:	74 07                	je     802472 <print_mem_block_lists+0x155>
  80246b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80246e:	8b 00                	mov    (%eax),%eax
  802470:	eb 05                	jmp    802477 <print_mem_block_lists+0x15a>
  802472:	b8 00 00 00 00       	mov    $0x0,%eax
  802477:	a3 48 40 80 00       	mov    %eax,0x804048
  80247c:	a1 48 40 80 00       	mov    0x804048,%eax
  802481:	85 c0                	test   %eax,%eax
  802483:	75 8a                	jne    80240f <print_mem_block_lists+0xf2>
  802485:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802489:	75 84                	jne    80240f <print_mem_block_lists+0xf2>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nAllocMemBlocksList is NOT SORTED!!\n") ;
  80248b:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  80248f:	75 10                	jne    8024a1 <print_mem_block_lists+0x184>
  802491:	83 ec 0c             	sub    $0xc,%esp
  802494:	68 cc 3d 80 00       	push   $0x803dcc
  802499:	e8 6f e5 ff ff       	call   800a0d <cprintf>
  80249e:	83 c4 10             	add    $0x10,%esp
	cprintf("\n=========================================\n");
  8024a1:	83 ec 0c             	sub    $0xc,%esp
  8024a4:	68 40 3d 80 00       	push   $0x803d40
  8024a9:	e8 5f e5 ff ff       	call   800a0d <cprintf>
  8024ae:	83 c4 10             	add    $0x10,%esp

}
  8024b1:	90                   	nop
  8024b2:	c9                   	leave  
  8024b3:	c3                   	ret    

008024b4 <initialize_MemBlocksList>:

//===============================
// [1] INITIALIZE AVAILABLE LIST:
//===============================
void initialize_MemBlocksList(uint32 numOfBlocks)
{
  8024b4:	55                   	push   %ebp
  8024b5:	89 e5                	mov    %esp,%ebp
  8024b7:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] initialize_MemBlocksList
	// Write your code here, remove the panic and write your code
	//panic("initialize_MemBlocksList() is not implemented yet...!!");
	uint32 n = numOfBlocks;
  8024ba:	8b 45 08             	mov    0x8(%ebp),%eax
  8024bd:	89 45 f0             	mov    %eax,-0x10(%ebp)

	LIST_INIT(&AvailableMemBlocksList);
  8024c0:	c7 05 48 41 80 00 00 	movl   $0x0,0x804148
  8024c7:	00 00 00 
  8024ca:	c7 05 4c 41 80 00 00 	movl   $0x0,0x80414c
  8024d1:	00 00 00 
  8024d4:	c7 05 54 41 80 00 00 	movl   $0x0,0x804154
  8024db:	00 00 00 
	for(int i = 0; i<n;i++)
  8024de:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  8024e5:	e9 9e 00 00 00       	jmp    802588 <initialize_MemBlocksList+0xd4>
	{
		LIST_INSERT_HEAD(&AvailableMemBlocksList, &(MemBlockNodes[i]));
  8024ea:	a1 50 40 80 00       	mov    0x804050,%eax
  8024ef:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8024f2:	c1 e2 04             	shl    $0x4,%edx
  8024f5:	01 d0                	add    %edx,%eax
  8024f7:	85 c0                	test   %eax,%eax
  8024f9:	75 14                	jne    80250f <initialize_MemBlocksList+0x5b>
  8024fb:	83 ec 04             	sub    $0x4,%esp
  8024fe:	68 f4 3d 80 00       	push   $0x803df4
  802503:	6a 47                	push   $0x47
  802505:	68 17 3e 80 00       	push   $0x803e17
  80250a:	e8 4a e2 ff ff       	call   800759 <_panic>
  80250f:	a1 50 40 80 00       	mov    0x804050,%eax
  802514:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802517:	c1 e2 04             	shl    $0x4,%edx
  80251a:	01 d0                	add    %edx,%eax
  80251c:	8b 15 48 41 80 00    	mov    0x804148,%edx
  802522:	89 10                	mov    %edx,(%eax)
  802524:	8b 00                	mov    (%eax),%eax
  802526:	85 c0                	test   %eax,%eax
  802528:	74 18                	je     802542 <initialize_MemBlocksList+0x8e>
  80252a:	a1 48 41 80 00       	mov    0x804148,%eax
  80252f:	8b 15 50 40 80 00    	mov    0x804050,%edx
  802535:	8b 4d f4             	mov    -0xc(%ebp),%ecx
  802538:	c1 e1 04             	shl    $0x4,%ecx
  80253b:	01 ca                	add    %ecx,%edx
  80253d:	89 50 04             	mov    %edx,0x4(%eax)
  802540:	eb 12                	jmp    802554 <initialize_MemBlocksList+0xa0>
  802542:	a1 50 40 80 00       	mov    0x804050,%eax
  802547:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80254a:	c1 e2 04             	shl    $0x4,%edx
  80254d:	01 d0                	add    %edx,%eax
  80254f:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802554:	a1 50 40 80 00       	mov    0x804050,%eax
  802559:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80255c:	c1 e2 04             	shl    $0x4,%edx
  80255f:	01 d0                	add    %edx,%eax
  802561:	a3 48 41 80 00       	mov    %eax,0x804148
  802566:	a1 50 40 80 00       	mov    0x804050,%eax
  80256b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80256e:	c1 e2 04             	shl    $0x4,%edx
  802571:	01 d0                	add    %edx,%eax
  802573:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80257a:	a1 54 41 80 00       	mov    0x804154,%eax
  80257f:	40                   	inc    %eax
  802580:	a3 54 41 80 00       	mov    %eax,0x804154
	// Write your code here, remove the panic and write your code
	//panic("initialize_MemBlocksList() is not implemented yet...!!");
	uint32 n = numOfBlocks;

	LIST_INIT(&AvailableMemBlocksList);
	for(int i = 0; i<n;i++)
  802585:	ff 45 f4             	incl   -0xc(%ebp)
  802588:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80258b:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  80258e:	0f 82 56 ff ff ff    	jb     8024ea <initialize_MemBlocksList+0x36>
	{
		LIST_INSERT_HEAD(&AvailableMemBlocksList, &(MemBlockNodes[i]));
	}
}
  802594:	90                   	nop
  802595:	c9                   	leave  
  802596:	c3                   	ret    

00802597 <find_block>:

//===============================
// [2] FIND BLOCK:
//===============================
struct MemBlock *find_block(struct MemBlock_List *blockList, uint32 va)
{
  802597:	55                   	push   %ebp
  802598:	89 e5                	mov    %esp,%ebp
  80259a:	83 ec 10             	sub    $0x10,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] find_block
	// Write your code here, remove the panic and write your code
	//panic("find_block() is not implemented yet...!!");
	uint32 virAddress = va;
  80259d:	8b 45 0c             	mov    0xc(%ebp),%eax
  8025a0:	89 45 f4             	mov    %eax,-0xc(%ebp)
	struct MemBlock* blk;
	int found = 0;
  8025a3:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	LIST_FOREACH(blk, &(AllocMemBlocksList))
  8025aa:	a1 40 40 80 00       	mov    0x804040,%eax
  8025af:	89 45 fc             	mov    %eax,-0x4(%ebp)
  8025b2:	eb 23                	jmp    8025d7 <find_block+0x40>
	{
		if(blk->sva == virAddress)
  8025b4:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8025b7:	8b 40 08             	mov    0x8(%eax),%eax
  8025ba:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  8025bd:	75 09                	jne    8025c8 <find_block+0x31>
		{
			found = 1;
  8025bf:	c7 45 f8 01 00 00 00 	movl   $0x1,-0x8(%ebp)
			break;
  8025c6:	eb 35                	jmp    8025fd <find_block+0x66>
		}
		else
		{
			found = 0;
  8025c8:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	//panic("find_block() is not implemented yet...!!");
	uint32 virAddress = va;
	struct MemBlock* blk;
	int found = 0;

	LIST_FOREACH(blk, &(AllocMemBlocksList))
  8025cf:	a1 48 40 80 00       	mov    0x804048,%eax
  8025d4:	89 45 fc             	mov    %eax,-0x4(%ebp)
  8025d7:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  8025db:	74 07                	je     8025e4 <find_block+0x4d>
  8025dd:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8025e0:	8b 00                	mov    (%eax),%eax
  8025e2:	eb 05                	jmp    8025e9 <find_block+0x52>
  8025e4:	b8 00 00 00 00       	mov    $0x0,%eax
  8025e9:	a3 48 40 80 00       	mov    %eax,0x804048
  8025ee:	a1 48 40 80 00       	mov    0x804048,%eax
  8025f3:	85 c0                	test   %eax,%eax
  8025f5:	75 bd                	jne    8025b4 <find_block+0x1d>
  8025f7:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  8025fb:	75 b7                	jne    8025b4 <find_block+0x1d>
		{
			found = 0;
			continue;
		}
	}
	if(found == 1)
  8025fd:	83 7d f8 01          	cmpl   $0x1,-0x8(%ebp)
  802601:	75 05                	jne    802608 <find_block+0x71>
	{
		return blk;
  802603:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802606:	eb 05                	jmp    80260d <find_block+0x76>
	}
	else
	{
		return NULL;
  802608:	b8 00 00 00 00       	mov    $0x0,%eax
	}
}
  80260d:	c9                   	leave  
  80260e:	c3                   	ret    

0080260f <insert_sorted_allocList>:

//=========================================
// [3] INSERT BLOCK IN ALLOC LIST [SORTED]:
//=========================================
void insert_sorted_allocList(struct MemBlock *blockToInsert)
{
  80260f:	55                   	push   %ebp
  802610:	89 e5                	mov    %esp,%ebp
  802612:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] insert_sorted_allocList
	// Write your code here, remove the panic and write your code
	//panic("insert_sorted_allocList() is not implemented yet...!!");
	struct MemBlock* blk;
	struct MemBlock* newblk = blockToInsert;
  802615:	8b 45 08             	mov    0x8(%ebp),%eax
  802618:	89 45 f0             	mov    %eax,-0x10(%ebp)

	if((LIST_EMPTY(&AllocMemBlocksList)) || (newblk->sva < LIST_FIRST(&AllocMemBlocksList)->sva))
  80261b:	a1 40 40 80 00       	mov    0x804040,%eax
  802620:	85 c0                	test   %eax,%eax
  802622:	74 12                	je     802636 <insert_sorted_allocList+0x27>
  802624:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802627:	8b 50 08             	mov    0x8(%eax),%edx
  80262a:	a1 40 40 80 00       	mov    0x804040,%eax
  80262f:	8b 40 08             	mov    0x8(%eax),%eax
  802632:	39 c2                	cmp    %eax,%edx
  802634:	73 65                	jae    80269b <insert_sorted_allocList+0x8c>
	{
		LIST_INSERT_HEAD(&(AllocMemBlocksList), newblk);
  802636:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80263a:	75 14                	jne    802650 <insert_sorted_allocList+0x41>
  80263c:	83 ec 04             	sub    $0x4,%esp
  80263f:	68 f4 3d 80 00       	push   $0x803df4
  802644:	6a 7b                	push   $0x7b
  802646:	68 17 3e 80 00       	push   $0x803e17
  80264b:	e8 09 e1 ff ff       	call   800759 <_panic>
  802650:	8b 15 40 40 80 00    	mov    0x804040,%edx
  802656:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802659:	89 10                	mov    %edx,(%eax)
  80265b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80265e:	8b 00                	mov    (%eax),%eax
  802660:	85 c0                	test   %eax,%eax
  802662:	74 0d                	je     802671 <insert_sorted_allocList+0x62>
  802664:	a1 40 40 80 00       	mov    0x804040,%eax
  802669:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80266c:	89 50 04             	mov    %edx,0x4(%eax)
  80266f:	eb 08                	jmp    802679 <insert_sorted_allocList+0x6a>
  802671:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802674:	a3 44 40 80 00       	mov    %eax,0x804044
  802679:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80267c:	a3 40 40 80 00       	mov    %eax,0x804040
  802681:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802684:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80268b:	a1 4c 40 80 00       	mov    0x80404c,%eax
  802690:	40                   	inc    %eax
  802691:	a3 4c 40 80 00       	mov    %eax,0x80404c
  802696:	e9 5f 01 00 00       	jmp    8027fa <insert_sorted_allocList+0x1eb>
	}
	else if(newblk->sva > LIST_LAST(&AllocMemBlocksList)->sva)
  80269b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80269e:	8b 50 08             	mov    0x8(%eax),%edx
  8026a1:	a1 44 40 80 00       	mov    0x804044,%eax
  8026a6:	8b 40 08             	mov    0x8(%eax),%eax
  8026a9:	39 c2                	cmp    %eax,%edx
  8026ab:	76 65                	jbe    802712 <insert_sorted_allocList+0x103>
	{
		LIST_INSERT_TAIL(&AllocMemBlocksList, newblk);
  8026ad:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8026b1:	75 14                	jne    8026c7 <insert_sorted_allocList+0xb8>
  8026b3:	83 ec 04             	sub    $0x4,%esp
  8026b6:	68 30 3e 80 00       	push   $0x803e30
  8026bb:	6a 7f                	push   $0x7f
  8026bd:	68 17 3e 80 00       	push   $0x803e17
  8026c2:	e8 92 e0 ff ff       	call   800759 <_panic>
  8026c7:	8b 15 44 40 80 00    	mov    0x804044,%edx
  8026cd:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8026d0:	89 50 04             	mov    %edx,0x4(%eax)
  8026d3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8026d6:	8b 40 04             	mov    0x4(%eax),%eax
  8026d9:	85 c0                	test   %eax,%eax
  8026db:	74 0c                	je     8026e9 <insert_sorted_allocList+0xda>
  8026dd:	a1 44 40 80 00       	mov    0x804044,%eax
  8026e2:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8026e5:	89 10                	mov    %edx,(%eax)
  8026e7:	eb 08                	jmp    8026f1 <insert_sorted_allocList+0xe2>
  8026e9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8026ec:	a3 40 40 80 00       	mov    %eax,0x804040
  8026f1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8026f4:	a3 44 40 80 00       	mov    %eax,0x804044
  8026f9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8026fc:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802702:	a1 4c 40 80 00       	mov    0x80404c,%eax
  802707:	40                   	inc    %eax
  802708:	a3 4c 40 80 00       	mov    %eax,0x80404c
				LIST_INSERT_AFTER(&AllocMemBlocksList, blk, newblk);
				break;
			}
		}
	}
}
  80270d:	e9 e8 00 00 00       	jmp    8027fa <insert_sorted_allocList+0x1eb>
	{
		LIST_INSERT_TAIL(&AllocMemBlocksList, newblk);
	}
	else
	{
		LIST_FOREACH(blk, &AllocMemBlocksList)
  802712:	a1 40 40 80 00       	mov    0x804040,%eax
  802717:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80271a:	e9 ab 00 00 00       	jmp    8027ca <insert_sorted_allocList+0x1bb>
		{
			if(blk->prev_next_info.le_next != NULL && newblk->sva > blk->sva  && newblk->sva < blk->prev_next_info.le_next->sva)
  80271f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802722:	8b 00                	mov    (%eax),%eax
  802724:	85 c0                	test   %eax,%eax
  802726:	0f 84 96 00 00 00    	je     8027c2 <insert_sorted_allocList+0x1b3>
  80272c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80272f:	8b 50 08             	mov    0x8(%eax),%edx
  802732:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802735:	8b 40 08             	mov    0x8(%eax),%eax
  802738:	39 c2                	cmp    %eax,%edx
  80273a:	0f 86 82 00 00 00    	jbe    8027c2 <insert_sorted_allocList+0x1b3>
  802740:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802743:	8b 50 08             	mov    0x8(%eax),%edx
  802746:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802749:	8b 00                	mov    (%eax),%eax
  80274b:	8b 40 08             	mov    0x8(%eax),%eax
  80274e:	39 c2                	cmp    %eax,%edx
  802750:	73 70                	jae    8027c2 <insert_sorted_allocList+0x1b3>
			{
				LIST_INSERT_AFTER(&AllocMemBlocksList, blk, newblk);
  802752:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802756:	74 06                	je     80275e <insert_sorted_allocList+0x14f>
  802758:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80275c:	75 17                	jne    802775 <insert_sorted_allocList+0x166>
  80275e:	83 ec 04             	sub    $0x4,%esp
  802761:	68 54 3e 80 00       	push   $0x803e54
  802766:	68 87 00 00 00       	push   $0x87
  80276b:	68 17 3e 80 00       	push   $0x803e17
  802770:	e8 e4 df ff ff       	call   800759 <_panic>
  802775:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802778:	8b 10                	mov    (%eax),%edx
  80277a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80277d:	89 10                	mov    %edx,(%eax)
  80277f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802782:	8b 00                	mov    (%eax),%eax
  802784:	85 c0                	test   %eax,%eax
  802786:	74 0b                	je     802793 <insert_sorted_allocList+0x184>
  802788:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80278b:	8b 00                	mov    (%eax),%eax
  80278d:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802790:	89 50 04             	mov    %edx,0x4(%eax)
  802793:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802796:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802799:	89 10                	mov    %edx,(%eax)
  80279b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80279e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8027a1:	89 50 04             	mov    %edx,0x4(%eax)
  8027a4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8027a7:	8b 00                	mov    (%eax),%eax
  8027a9:	85 c0                	test   %eax,%eax
  8027ab:	75 08                	jne    8027b5 <insert_sorted_allocList+0x1a6>
  8027ad:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8027b0:	a3 44 40 80 00       	mov    %eax,0x804044
  8027b5:	a1 4c 40 80 00       	mov    0x80404c,%eax
  8027ba:	40                   	inc    %eax
  8027bb:	a3 4c 40 80 00       	mov    %eax,0x80404c
				break;
  8027c0:	eb 38                	jmp    8027fa <insert_sorted_allocList+0x1eb>
	{
		LIST_INSERT_TAIL(&AllocMemBlocksList, newblk);
	}
	else
	{
		LIST_FOREACH(blk, &AllocMemBlocksList)
  8027c2:	a1 48 40 80 00       	mov    0x804048,%eax
  8027c7:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8027ca:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8027ce:	74 07                	je     8027d7 <insert_sorted_allocList+0x1c8>
  8027d0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027d3:	8b 00                	mov    (%eax),%eax
  8027d5:	eb 05                	jmp    8027dc <insert_sorted_allocList+0x1cd>
  8027d7:	b8 00 00 00 00       	mov    $0x0,%eax
  8027dc:	a3 48 40 80 00       	mov    %eax,0x804048
  8027e1:	a1 48 40 80 00       	mov    0x804048,%eax
  8027e6:	85 c0                	test   %eax,%eax
  8027e8:	0f 85 31 ff ff ff    	jne    80271f <insert_sorted_allocList+0x110>
  8027ee:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8027f2:	0f 85 27 ff ff ff    	jne    80271f <insert_sorted_allocList+0x110>
				LIST_INSERT_AFTER(&AllocMemBlocksList, blk, newblk);
				break;
			}
		}
	}
}
  8027f8:	eb 00                	jmp    8027fa <insert_sorted_allocList+0x1eb>
  8027fa:	90                   	nop
  8027fb:	c9                   	leave  
  8027fc:	c3                   	ret    

008027fd <alloc_block_FF>:

//=========================================
// [4] ALLOCATE BLOCK BY FIRST FIT:
//=========================================
struct MemBlock *alloc_block_FF(uint32 size)
{
  8027fd:	55                   	push   %ebp
  8027fe:	89 e5                	mov    %esp,%ebp
  802800:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_FF
	// Write your code here, remove the panic and write your code
	//panic("alloc_block_FF() is not implemented yet...!!");
	uint32 versize = size;
  802803:	8b 45 08             	mov    0x8(%ebp),%eax
  802806:	89 45 f0             	mov    %eax,-0x10(%ebp)
	struct MemBlock* blk;
	struct MemBlock* newblk = LIST_FIRST(&AvailableMemBlocksList);
  802809:	a1 48 41 80 00       	mov    0x804148,%eax
  80280e:	89 45 ec             	mov    %eax,-0x14(%ebp)

	LIST_FOREACH(blk,&FreeMemBlocksList)
  802811:	a1 38 41 80 00       	mov    0x804138,%eax
  802816:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802819:	e9 77 01 00 00       	jmp    802995 <alloc_block_FF+0x198>
	{
		if(blk->size == versize)
  80281e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802821:	8b 40 0c             	mov    0xc(%eax),%eax
  802824:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  802827:	0f 85 8a 00 00 00    	jne    8028b7 <alloc_block_FF+0xba>
		{
			LIST_REMOVE(&FreeMemBlocksList,blk);
  80282d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802831:	75 17                	jne    80284a <alloc_block_FF+0x4d>
  802833:	83 ec 04             	sub    $0x4,%esp
  802836:	68 88 3e 80 00       	push   $0x803e88
  80283b:	68 9e 00 00 00       	push   $0x9e
  802840:	68 17 3e 80 00       	push   $0x803e17
  802845:	e8 0f df ff ff       	call   800759 <_panic>
  80284a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80284d:	8b 00                	mov    (%eax),%eax
  80284f:	85 c0                	test   %eax,%eax
  802851:	74 10                	je     802863 <alloc_block_FF+0x66>
  802853:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802856:	8b 00                	mov    (%eax),%eax
  802858:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80285b:	8b 52 04             	mov    0x4(%edx),%edx
  80285e:	89 50 04             	mov    %edx,0x4(%eax)
  802861:	eb 0b                	jmp    80286e <alloc_block_FF+0x71>
  802863:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802866:	8b 40 04             	mov    0x4(%eax),%eax
  802869:	a3 3c 41 80 00       	mov    %eax,0x80413c
  80286e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802871:	8b 40 04             	mov    0x4(%eax),%eax
  802874:	85 c0                	test   %eax,%eax
  802876:	74 0f                	je     802887 <alloc_block_FF+0x8a>
  802878:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80287b:	8b 40 04             	mov    0x4(%eax),%eax
  80287e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802881:	8b 12                	mov    (%edx),%edx
  802883:	89 10                	mov    %edx,(%eax)
  802885:	eb 0a                	jmp    802891 <alloc_block_FF+0x94>
  802887:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80288a:	8b 00                	mov    (%eax),%eax
  80288c:	a3 38 41 80 00       	mov    %eax,0x804138
  802891:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802894:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80289a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80289d:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8028a4:	a1 44 41 80 00       	mov    0x804144,%eax
  8028a9:	48                   	dec    %eax
  8028aa:	a3 44 41 80 00       	mov    %eax,0x804144
			return blk;
  8028af:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028b2:	e9 11 01 00 00       	jmp    8029c8 <alloc_block_FF+0x1cb>
		}
		else if(blk->size > versize)
  8028b7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028ba:	8b 40 0c             	mov    0xc(%eax),%eax
  8028bd:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8028c0:	0f 86 c7 00 00 00    	jbe    80298d <alloc_block_FF+0x190>
		{
			LIST_REMOVE(&AvailableMemBlocksList,newblk);
  8028c6:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8028ca:	75 17                	jne    8028e3 <alloc_block_FF+0xe6>
  8028cc:	83 ec 04             	sub    $0x4,%esp
  8028cf:	68 88 3e 80 00       	push   $0x803e88
  8028d4:	68 a3 00 00 00       	push   $0xa3
  8028d9:	68 17 3e 80 00       	push   $0x803e17
  8028de:	e8 76 de ff ff       	call   800759 <_panic>
  8028e3:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8028e6:	8b 00                	mov    (%eax),%eax
  8028e8:	85 c0                	test   %eax,%eax
  8028ea:	74 10                	je     8028fc <alloc_block_FF+0xff>
  8028ec:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8028ef:	8b 00                	mov    (%eax),%eax
  8028f1:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8028f4:	8b 52 04             	mov    0x4(%edx),%edx
  8028f7:	89 50 04             	mov    %edx,0x4(%eax)
  8028fa:	eb 0b                	jmp    802907 <alloc_block_FF+0x10a>
  8028fc:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8028ff:	8b 40 04             	mov    0x4(%eax),%eax
  802902:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802907:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80290a:	8b 40 04             	mov    0x4(%eax),%eax
  80290d:	85 c0                	test   %eax,%eax
  80290f:	74 0f                	je     802920 <alloc_block_FF+0x123>
  802911:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802914:	8b 40 04             	mov    0x4(%eax),%eax
  802917:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80291a:	8b 12                	mov    (%edx),%edx
  80291c:	89 10                	mov    %edx,(%eax)
  80291e:	eb 0a                	jmp    80292a <alloc_block_FF+0x12d>
  802920:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802923:	8b 00                	mov    (%eax),%eax
  802925:	a3 48 41 80 00       	mov    %eax,0x804148
  80292a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80292d:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802933:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802936:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80293d:	a1 54 41 80 00       	mov    0x804154,%eax
  802942:	48                   	dec    %eax
  802943:	a3 54 41 80 00       	mov    %eax,0x804154
			newblk->size = versize;
  802948:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80294b:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80294e:	89 50 0c             	mov    %edx,0xc(%eax)
			blk->size = blk->size-versize;
  802951:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802954:	8b 40 0c             	mov    0xc(%eax),%eax
  802957:	2b 45 f0             	sub    -0x10(%ebp),%eax
  80295a:	89 c2                	mov    %eax,%edx
  80295c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80295f:	89 50 0c             	mov    %edx,0xc(%eax)
			uint32 newveradd = blk->sva;
  802962:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802965:	8b 40 08             	mov    0x8(%eax),%eax
  802968:	89 45 e8             	mov    %eax,-0x18(%ebp)
			blk->sva+=newblk->size;
  80296b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80296e:	8b 50 08             	mov    0x8(%eax),%edx
  802971:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802974:	8b 40 0c             	mov    0xc(%eax),%eax
  802977:	01 c2                	add    %eax,%edx
  802979:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80297c:	89 50 08             	mov    %edx,0x8(%eax)
			newblk->sva = newveradd;
  80297f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802982:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802985:	89 50 08             	mov    %edx,0x8(%eax)
			return newblk;
  802988:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80298b:	eb 3b                	jmp    8029c8 <alloc_block_FF+0x1cb>
	//panic("alloc_block_FF() is not implemented yet...!!");
	uint32 versize = size;
	struct MemBlock* blk;
	struct MemBlock* newblk = LIST_FIRST(&AvailableMemBlocksList);

	LIST_FOREACH(blk,&FreeMemBlocksList)
  80298d:	a1 40 41 80 00       	mov    0x804140,%eax
  802992:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802995:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802999:	74 07                	je     8029a2 <alloc_block_FF+0x1a5>
  80299b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80299e:	8b 00                	mov    (%eax),%eax
  8029a0:	eb 05                	jmp    8029a7 <alloc_block_FF+0x1aa>
  8029a2:	b8 00 00 00 00       	mov    $0x0,%eax
  8029a7:	a3 40 41 80 00       	mov    %eax,0x804140
  8029ac:	a1 40 41 80 00       	mov    0x804140,%eax
  8029b1:	85 c0                	test   %eax,%eax
  8029b3:	0f 85 65 fe ff ff    	jne    80281e <alloc_block_FF+0x21>
  8029b9:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8029bd:	0f 85 5b fe ff ff    	jne    80281e <alloc_block_FF+0x21>
			blk->sva+=newblk->size;
			newblk->sva = newveradd;
			return newblk;
		}
	}
	return NULL;
  8029c3:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8029c8:	c9                   	leave  
  8029c9:	c3                   	ret    

008029ca <alloc_block_BF>:

//=========================================
// [5] ALLOCATE BLOCK BY BEST FIT:
//=========================================
struct MemBlock *alloc_block_BF(uint32 size)
{
  8029ca:	55                   	push   %ebp
  8029cb:	89 e5                	mov    %esp,%ebp
  8029cd:	83 ec 28             	sub    $0x28,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_BF
	// Write your code here, remove the panic and write your code
	//panic("alloc_block_BF() is not implemented yet...!!");
	uint32 versize=size;
  8029d0:	8b 45 08             	mov    0x8(%ebp),%eax
  8029d3:	89 45 e8             	mov    %eax,-0x18(%ebp)
	struct MemBlock* blk;
	struct MemBlock* newblk=LIST_FIRST(&AvailableMemBlocksList);
  8029d6:	a1 48 41 80 00       	mov    0x804148,%eax
  8029db:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	uint32 newveradd;
	uint32 newsize;
	int size_free = LIST_SIZE(&FreeMemBlocksList);
  8029de:	a1 44 41 80 00       	mov    0x804144,%eax
  8029e3:	89 45 e0             	mov    %eax,-0x20(%ebp)

	LIST_FOREACH(blk, &FreeMemBlocksList)
  8029e6:	a1 38 41 80 00       	mov    0x804138,%eax
  8029eb:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8029ee:	e9 a1 00 00 00       	jmp    802a94 <alloc_block_BF+0xca>
	{
		if(blk->size == versize)
  8029f3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029f6:	8b 40 0c             	mov    0xc(%eax),%eax
  8029f9:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  8029fc:	0f 85 8a 00 00 00    	jne    802a8c <alloc_block_BF+0xc2>
		{
			LIST_REMOVE(&FreeMemBlocksList, blk);
  802a02:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802a06:	75 17                	jne    802a1f <alloc_block_BF+0x55>
  802a08:	83 ec 04             	sub    $0x4,%esp
  802a0b:	68 88 3e 80 00       	push   $0x803e88
  802a10:	68 c2 00 00 00       	push   $0xc2
  802a15:	68 17 3e 80 00       	push   $0x803e17
  802a1a:	e8 3a dd ff ff       	call   800759 <_panic>
  802a1f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a22:	8b 00                	mov    (%eax),%eax
  802a24:	85 c0                	test   %eax,%eax
  802a26:	74 10                	je     802a38 <alloc_block_BF+0x6e>
  802a28:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a2b:	8b 00                	mov    (%eax),%eax
  802a2d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802a30:	8b 52 04             	mov    0x4(%edx),%edx
  802a33:	89 50 04             	mov    %edx,0x4(%eax)
  802a36:	eb 0b                	jmp    802a43 <alloc_block_BF+0x79>
  802a38:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a3b:	8b 40 04             	mov    0x4(%eax),%eax
  802a3e:	a3 3c 41 80 00       	mov    %eax,0x80413c
  802a43:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a46:	8b 40 04             	mov    0x4(%eax),%eax
  802a49:	85 c0                	test   %eax,%eax
  802a4b:	74 0f                	je     802a5c <alloc_block_BF+0x92>
  802a4d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a50:	8b 40 04             	mov    0x4(%eax),%eax
  802a53:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802a56:	8b 12                	mov    (%edx),%edx
  802a58:	89 10                	mov    %edx,(%eax)
  802a5a:	eb 0a                	jmp    802a66 <alloc_block_BF+0x9c>
  802a5c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a5f:	8b 00                	mov    (%eax),%eax
  802a61:	a3 38 41 80 00       	mov    %eax,0x804138
  802a66:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a69:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802a6f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a72:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802a79:	a1 44 41 80 00       	mov    0x804144,%eax
  802a7e:	48                   	dec    %eax
  802a7f:	a3 44 41 80 00       	mov    %eax,0x804144
			return blk;
  802a84:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a87:	e9 11 02 00 00       	jmp    802c9d <alloc_block_BF+0x2d3>
	struct MemBlock* newblk=LIST_FIRST(&AvailableMemBlocksList);
	uint32 newveradd;
	uint32 newsize;
	int size_free = LIST_SIZE(&FreeMemBlocksList);

	LIST_FOREACH(blk, &FreeMemBlocksList)
  802a8c:	a1 40 41 80 00       	mov    0x804140,%eax
  802a91:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802a94:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802a98:	74 07                	je     802aa1 <alloc_block_BF+0xd7>
  802a9a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a9d:	8b 00                	mov    (%eax),%eax
  802a9f:	eb 05                	jmp    802aa6 <alloc_block_BF+0xdc>
  802aa1:	b8 00 00 00 00       	mov    $0x0,%eax
  802aa6:	a3 40 41 80 00       	mov    %eax,0x804140
  802aab:	a1 40 41 80 00       	mov    0x804140,%eax
  802ab0:	85 c0                	test   %eax,%eax
  802ab2:	0f 85 3b ff ff ff    	jne    8029f3 <alloc_block_BF+0x29>
  802ab8:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802abc:	0f 85 31 ff ff ff    	jne    8029f3 <alloc_block_BF+0x29>
		{
			LIST_REMOVE(&FreeMemBlocksList, blk);
			return blk;
		}
	}
	LIST_FOREACH(blk, &FreeMemBlocksList)
  802ac2:	a1 38 41 80 00       	mov    0x804138,%eax
  802ac7:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802aca:	eb 27                	jmp    802af3 <alloc_block_BF+0x129>
	{
		if(blk->size > versize)
  802acc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802acf:	8b 40 0c             	mov    0xc(%eax),%eax
  802ad2:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  802ad5:	76 14                	jbe    802aeb <alloc_block_BF+0x121>
		{
			newsize = blk->size;
  802ad7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ada:	8b 40 0c             	mov    0xc(%eax),%eax
  802add:	89 45 ec             	mov    %eax,-0x14(%ebp)
			newveradd = blk->sva;
  802ae0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ae3:	8b 40 08             	mov    0x8(%eax),%eax
  802ae6:	89 45 f0             	mov    %eax,-0x10(%ebp)
			break;
  802ae9:	eb 2e                	jmp    802b19 <alloc_block_BF+0x14f>
		{
			LIST_REMOVE(&FreeMemBlocksList, blk);
			return blk;
		}
	}
	LIST_FOREACH(blk, &FreeMemBlocksList)
  802aeb:	a1 40 41 80 00       	mov    0x804140,%eax
  802af0:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802af3:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802af7:	74 07                	je     802b00 <alloc_block_BF+0x136>
  802af9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802afc:	8b 00                	mov    (%eax),%eax
  802afe:	eb 05                	jmp    802b05 <alloc_block_BF+0x13b>
  802b00:	b8 00 00 00 00       	mov    $0x0,%eax
  802b05:	a3 40 41 80 00       	mov    %eax,0x804140
  802b0a:	a1 40 41 80 00       	mov    0x804140,%eax
  802b0f:	85 c0                	test   %eax,%eax
  802b11:	75 b9                	jne    802acc <alloc_block_BF+0x102>
  802b13:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802b17:	75 b3                	jne    802acc <alloc_block_BF+0x102>
			newsize = blk->size;
			newveradd = blk->sva;
			break;
		}
	}
	LIST_FOREACH(blk, &FreeMemBlocksList)
  802b19:	a1 38 41 80 00       	mov    0x804138,%eax
  802b1e:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802b21:	eb 30                	jmp    802b53 <alloc_block_BF+0x189>
	{
		if(newsize > blk->size && blk->size > versize)
  802b23:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b26:	8b 40 0c             	mov    0xc(%eax),%eax
  802b29:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  802b2c:	73 1d                	jae    802b4b <alloc_block_BF+0x181>
  802b2e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b31:	8b 40 0c             	mov    0xc(%eax),%eax
  802b34:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  802b37:	76 12                	jbe    802b4b <alloc_block_BF+0x181>
		{
	       newsize = blk->size;
  802b39:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b3c:	8b 40 0c             	mov    0xc(%eax),%eax
  802b3f:	89 45 ec             	mov    %eax,-0x14(%ebp)
		   newveradd = blk->sva;
  802b42:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b45:	8b 40 08             	mov    0x8(%eax),%eax
  802b48:	89 45 f0             	mov    %eax,-0x10(%ebp)
			newsize = blk->size;
			newveradd = blk->sva;
			break;
		}
	}
	LIST_FOREACH(blk, &FreeMemBlocksList)
  802b4b:	a1 40 41 80 00       	mov    0x804140,%eax
  802b50:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802b53:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802b57:	74 07                	je     802b60 <alloc_block_BF+0x196>
  802b59:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b5c:	8b 00                	mov    (%eax),%eax
  802b5e:	eb 05                	jmp    802b65 <alloc_block_BF+0x19b>
  802b60:	b8 00 00 00 00       	mov    $0x0,%eax
  802b65:	a3 40 41 80 00       	mov    %eax,0x804140
  802b6a:	a1 40 41 80 00       	mov    0x804140,%eax
  802b6f:	85 c0                	test   %eax,%eax
  802b71:	75 b0                	jne    802b23 <alloc_block_BF+0x159>
  802b73:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802b77:	75 aa                	jne    802b23 <alloc_block_BF+0x159>
		{
	       newsize = blk->size;
		   newveradd = blk->sva;
		}
	}
	LIST_FOREACH(blk, &FreeMemBlocksList)
  802b79:	a1 38 41 80 00       	mov    0x804138,%eax
  802b7e:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802b81:	e9 e4 00 00 00       	jmp    802c6a <alloc_block_BF+0x2a0>
	{
		if(blk->size == newsize && blk->sva == newveradd)
  802b86:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b89:	8b 40 0c             	mov    0xc(%eax),%eax
  802b8c:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  802b8f:	0f 85 cd 00 00 00    	jne    802c62 <alloc_block_BF+0x298>
  802b95:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b98:	8b 40 08             	mov    0x8(%eax),%eax
  802b9b:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  802b9e:	0f 85 be 00 00 00    	jne    802c62 <alloc_block_BF+0x298>
		{
			LIST_REMOVE(&AvailableMemBlocksList, newblk);
  802ba4:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  802ba8:	75 17                	jne    802bc1 <alloc_block_BF+0x1f7>
  802baa:	83 ec 04             	sub    $0x4,%esp
  802bad:	68 88 3e 80 00       	push   $0x803e88
  802bb2:	68 db 00 00 00       	push   $0xdb
  802bb7:	68 17 3e 80 00       	push   $0x803e17
  802bbc:	e8 98 db ff ff       	call   800759 <_panic>
  802bc1:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802bc4:	8b 00                	mov    (%eax),%eax
  802bc6:	85 c0                	test   %eax,%eax
  802bc8:	74 10                	je     802bda <alloc_block_BF+0x210>
  802bca:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802bcd:	8b 00                	mov    (%eax),%eax
  802bcf:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802bd2:	8b 52 04             	mov    0x4(%edx),%edx
  802bd5:	89 50 04             	mov    %edx,0x4(%eax)
  802bd8:	eb 0b                	jmp    802be5 <alloc_block_BF+0x21b>
  802bda:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802bdd:	8b 40 04             	mov    0x4(%eax),%eax
  802be0:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802be5:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802be8:	8b 40 04             	mov    0x4(%eax),%eax
  802beb:	85 c0                	test   %eax,%eax
  802bed:	74 0f                	je     802bfe <alloc_block_BF+0x234>
  802bef:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802bf2:	8b 40 04             	mov    0x4(%eax),%eax
  802bf5:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802bf8:	8b 12                	mov    (%edx),%edx
  802bfa:	89 10                	mov    %edx,(%eax)
  802bfc:	eb 0a                	jmp    802c08 <alloc_block_BF+0x23e>
  802bfe:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802c01:	8b 00                	mov    (%eax),%eax
  802c03:	a3 48 41 80 00       	mov    %eax,0x804148
  802c08:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802c0b:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802c11:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802c14:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802c1b:	a1 54 41 80 00       	mov    0x804154,%eax
  802c20:	48                   	dec    %eax
  802c21:	a3 54 41 80 00       	mov    %eax,0x804154
			newblk->size = versize;
  802c26:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802c29:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802c2c:	89 50 0c             	mov    %edx,0xc(%eax)
			newblk->sva = newveradd;
  802c2f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802c32:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802c35:	89 50 08             	mov    %edx,0x8(%eax)
			blk->size = blk->size - versize;
  802c38:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c3b:	8b 40 0c             	mov    0xc(%eax),%eax
  802c3e:	2b 45 e8             	sub    -0x18(%ebp),%eax
  802c41:	89 c2                	mov    %eax,%edx
  802c43:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c46:	89 50 0c             	mov    %edx,0xc(%eax)
			blk->sva+= newblk->size;
  802c49:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c4c:	8b 50 08             	mov    0x8(%eax),%edx
  802c4f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802c52:	8b 40 0c             	mov    0xc(%eax),%eax
  802c55:	01 c2                	add    %eax,%edx
  802c57:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c5a:	89 50 08             	mov    %edx,0x8(%eax)
			return newblk;
  802c5d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802c60:	eb 3b                	jmp    802c9d <alloc_block_BF+0x2d3>
		{
	       newsize = blk->size;
		   newveradd = blk->sva;
		}
	}
	LIST_FOREACH(blk, &FreeMemBlocksList)
  802c62:	a1 40 41 80 00       	mov    0x804140,%eax
  802c67:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802c6a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802c6e:	74 07                	je     802c77 <alloc_block_BF+0x2ad>
  802c70:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c73:	8b 00                	mov    (%eax),%eax
  802c75:	eb 05                	jmp    802c7c <alloc_block_BF+0x2b2>
  802c77:	b8 00 00 00 00       	mov    $0x0,%eax
  802c7c:	a3 40 41 80 00       	mov    %eax,0x804140
  802c81:	a1 40 41 80 00       	mov    0x804140,%eax
  802c86:	85 c0                	test   %eax,%eax
  802c88:	0f 85 f8 fe ff ff    	jne    802b86 <alloc_block_BF+0x1bc>
  802c8e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802c92:	0f 85 ee fe ff ff    	jne    802b86 <alloc_block_BF+0x1bc>
			blk->size = blk->size - versize;
			blk->sva+= newblk->size;
			return newblk;
		}
	}
	return NULL;
  802c98:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802c9d:	c9                   	leave  
  802c9e:	c3                   	ret    

00802c9f <alloc_block_NF>:
//=========================================
// [7] ALLOCATE BLOCK BY NEXT FIT:
//=========================================
struct MemBlock *last_allocate;
struct MemBlock *alloc_block_NF(uint32 size)
{
  802c9f:	55                   	push   %ebp
  802ca0:	89 e5                	mov    %esp,%ebp
  802ca2:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1 - BONUS] [DYNAMIC ALLOCATOR] alloc_block_NF
	// Write your code here, remove the panic and write your code
	//panic("alloc_block_NF() is not implemented yet...!!");
	uint32 versize = size;
  802ca5:	8b 45 08             	mov    0x8(%ebp),%eax
  802ca8:	89 45 f0             	mov    %eax,-0x10(%ebp)
	struct MemBlock* blk;
	struct MemBlock* newblk = LIST_FIRST(&AvailableMemBlocksList);
  802cab:	a1 48 41 80 00       	mov    0x804148,%eax
  802cb0:	89 45 ec             	mov    %eax,-0x14(%ebp)

	LIST_FOREACH(blk,&FreeMemBlocksList)
  802cb3:	a1 38 41 80 00       	mov    0x804138,%eax
  802cb8:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802cbb:	e9 77 01 00 00       	jmp    802e37 <alloc_block_NF+0x198>
	{
		if(blk->size == versize)
  802cc0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cc3:	8b 40 0c             	mov    0xc(%eax),%eax
  802cc6:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  802cc9:	0f 85 8a 00 00 00    	jne    802d59 <alloc_block_NF+0xba>
		{
			LIST_REMOVE(&FreeMemBlocksList,blk);
  802ccf:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802cd3:	75 17                	jne    802cec <alloc_block_NF+0x4d>
  802cd5:	83 ec 04             	sub    $0x4,%esp
  802cd8:	68 88 3e 80 00       	push   $0x803e88
  802cdd:	68 f7 00 00 00       	push   $0xf7
  802ce2:	68 17 3e 80 00       	push   $0x803e17
  802ce7:	e8 6d da ff ff       	call   800759 <_panic>
  802cec:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cef:	8b 00                	mov    (%eax),%eax
  802cf1:	85 c0                	test   %eax,%eax
  802cf3:	74 10                	je     802d05 <alloc_block_NF+0x66>
  802cf5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cf8:	8b 00                	mov    (%eax),%eax
  802cfa:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802cfd:	8b 52 04             	mov    0x4(%edx),%edx
  802d00:	89 50 04             	mov    %edx,0x4(%eax)
  802d03:	eb 0b                	jmp    802d10 <alloc_block_NF+0x71>
  802d05:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d08:	8b 40 04             	mov    0x4(%eax),%eax
  802d0b:	a3 3c 41 80 00       	mov    %eax,0x80413c
  802d10:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d13:	8b 40 04             	mov    0x4(%eax),%eax
  802d16:	85 c0                	test   %eax,%eax
  802d18:	74 0f                	je     802d29 <alloc_block_NF+0x8a>
  802d1a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d1d:	8b 40 04             	mov    0x4(%eax),%eax
  802d20:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802d23:	8b 12                	mov    (%edx),%edx
  802d25:	89 10                	mov    %edx,(%eax)
  802d27:	eb 0a                	jmp    802d33 <alloc_block_NF+0x94>
  802d29:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d2c:	8b 00                	mov    (%eax),%eax
  802d2e:	a3 38 41 80 00       	mov    %eax,0x804138
  802d33:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d36:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802d3c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d3f:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802d46:	a1 44 41 80 00       	mov    0x804144,%eax
  802d4b:	48                   	dec    %eax
  802d4c:	a3 44 41 80 00       	mov    %eax,0x804144
			return blk;
  802d51:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d54:	e9 11 01 00 00       	jmp    802e6a <alloc_block_NF+0x1cb>
		}
		else if(blk->size > versize)
  802d59:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d5c:	8b 40 0c             	mov    0xc(%eax),%eax
  802d5f:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  802d62:	0f 86 c7 00 00 00    	jbe    802e2f <alloc_block_NF+0x190>
		{
			LIST_REMOVE(&AvailableMemBlocksList,newblk);
  802d68:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802d6c:	75 17                	jne    802d85 <alloc_block_NF+0xe6>
  802d6e:	83 ec 04             	sub    $0x4,%esp
  802d71:	68 88 3e 80 00       	push   $0x803e88
  802d76:	68 fc 00 00 00       	push   $0xfc
  802d7b:	68 17 3e 80 00       	push   $0x803e17
  802d80:	e8 d4 d9 ff ff       	call   800759 <_panic>
  802d85:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802d88:	8b 00                	mov    (%eax),%eax
  802d8a:	85 c0                	test   %eax,%eax
  802d8c:	74 10                	je     802d9e <alloc_block_NF+0xff>
  802d8e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802d91:	8b 00                	mov    (%eax),%eax
  802d93:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802d96:	8b 52 04             	mov    0x4(%edx),%edx
  802d99:	89 50 04             	mov    %edx,0x4(%eax)
  802d9c:	eb 0b                	jmp    802da9 <alloc_block_NF+0x10a>
  802d9e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802da1:	8b 40 04             	mov    0x4(%eax),%eax
  802da4:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802da9:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802dac:	8b 40 04             	mov    0x4(%eax),%eax
  802daf:	85 c0                	test   %eax,%eax
  802db1:	74 0f                	je     802dc2 <alloc_block_NF+0x123>
  802db3:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802db6:	8b 40 04             	mov    0x4(%eax),%eax
  802db9:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802dbc:	8b 12                	mov    (%edx),%edx
  802dbe:	89 10                	mov    %edx,(%eax)
  802dc0:	eb 0a                	jmp    802dcc <alloc_block_NF+0x12d>
  802dc2:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802dc5:	8b 00                	mov    (%eax),%eax
  802dc7:	a3 48 41 80 00       	mov    %eax,0x804148
  802dcc:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802dcf:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802dd5:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802dd8:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802ddf:	a1 54 41 80 00       	mov    0x804154,%eax
  802de4:	48                   	dec    %eax
  802de5:	a3 54 41 80 00       	mov    %eax,0x804154
			newblk->size = versize;
  802dea:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802ded:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802df0:	89 50 0c             	mov    %edx,0xc(%eax)
			blk->size = blk->size-versize;
  802df3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802df6:	8b 40 0c             	mov    0xc(%eax),%eax
  802df9:	2b 45 f0             	sub    -0x10(%ebp),%eax
  802dfc:	89 c2                	mov    %eax,%edx
  802dfe:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e01:	89 50 0c             	mov    %edx,0xc(%eax)
			uint32 newveradd = blk->sva;
  802e04:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e07:	8b 40 08             	mov    0x8(%eax),%eax
  802e0a:	89 45 e8             	mov    %eax,-0x18(%ebp)
			blk->sva+=newblk->size;
  802e0d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e10:	8b 50 08             	mov    0x8(%eax),%edx
  802e13:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802e16:	8b 40 0c             	mov    0xc(%eax),%eax
  802e19:	01 c2                	add    %eax,%edx
  802e1b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e1e:	89 50 08             	mov    %edx,0x8(%eax)
			newblk->sva = newveradd;
  802e21:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802e24:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802e27:	89 50 08             	mov    %edx,0x8(%eax)
			return newblk;
  802e2a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802e2d:	eb 3b                	jmp    802e6a <alloc_block_NF+0x1cb>
	//panic("alloc_block_NF() is not implemented yet...!!");
	uint32 versize = size;
	struct MemBlock* blk;
	struct MemBlock* newblk = LIST_FIRST(&AvailableMemBlocksList);

	LIST_FOREACH(blk,&FreeMemBlocksList)
  802e2f:	a1 40 41 80 00       	mov    0x804140,%eax
  802e34:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802e37:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802e3b:	74 07                	je     802e44 <alloc_block_NF+0x1a5>
  802e3d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e40:	8b 00                	mov    (%eax),%eax
  802e42:	eb 05                	jmp    802e49 <alloc_block_NF+0x1aa>
  802e44:	b8 00 00 00 00       	mov    $0x0,%eax
  802e49:	a3 40 41 80 00       	mov    %eax,0x804140
  802e4e:	a1 40 41 80 00       	mov    0x804140,%eax
  802e53:	85 c0                	test   %eax,%eax
  802e55:	0f 85 65 fe ff ff    	jne    802cc0 <alloc_block_NF+0x21>
  802e5b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802e5f:	0f 85 5b fe ff ff    	jne    802cc0 <alloc_block_NF+0x21>
			blk->sva+=newblk->size;
			newblk->sva = newveradd;
			return newblk;
		}
	}
	return NULL;
  802e65:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802e6a:	c9                   	leave  
  802e6b:	c3                   	ret    

00802e6c <addToAvailMemBlocksList>:

//===================================================
// [8] INSERT BLOCK (SORTED WITH MERGE) IN FREE LIST:
//===================================================
void addToAvailMemBlocksList(struct MemBlock *blockToInsert)
{
  802e6c:	55                   	push   %ebp
  802e6d:	89 e5                	mov    %esp,%ebp
  802e6f:	83 ec 08             	sub    $0x8,%esp
	blockToInsert->sva = 0;
  802e72:	8b 45 08             	mov    0x8(%ebp),%eax
  802e75:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
	blockToInsert->size = 0;
  802e7c:	8b 45 08             	mov    0x8(%ebp),%eax
  802e7f:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
	//add to avail
	LIST_INSERT_TAIL(&AvailableMemBlocksList, blockToInsert);
  802e86:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802e8a:	75 17                	jne    802ea3 <addToAvailMemBlocksList+0x37>
  802e8c:	83 ec 04             	sub    $0x4,%esp
  802e8f:	68 30 3e 80 00       	push   $0x803e30
  802e94:	68 10 01 00 00       	push   $0x110
  802e99:	68 17 3e 80 00       	push   $0x803e17
  802e9e:	e8 b6 d8 ff ff       	call   800759 <_panic>
  802ea3:	8b 15 4c 41 80 00    	mov    0x80414c,%edx
  802ea9:	8b 45 08             	mov    0x8(%ebp),%eax
  802eac:	89 50 04             	mov    %edx,0x4(%eax)
  802eaf:	8b 45 08             	mov    0x8(%ebp),%eax
  802eb2:	8b 40 04             	mov    0x4(%eax),%eax
  802eb5:	85 c0                	test   %eax,%eax
  802eb7:	74 0c                	je     802ec5 <addToAvailMemBlocksList+0x59>
  802eb9:	a1 4c 41 80 00       	mov    0x80414c,%eax
  802ebe:	8b 55 08             	mov    0x8(%ebp),%edx
  802ec1:	89 10                	mov    %edx,(%eax)
  802ec3:	eb 08                	jmp    802ecd <addToAvailMemBlocksList+0x61>
  802ec5:	8b 45 08             	mov    0x8(%ebp),%eax
  802ec8:	a3 48 41 80 00       	mov    %eax,0x804148
  802ecd:	8b 45 08             	mov    0x8(%ebp),%eax
  802ed0:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802ed5:	8b 45 08             	mov    0x8(%ebp),%eax
  802ed8:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802ede:	a1 54 41 80 00       	mov    0x804154,%eax
  802ee3:	40                   	inc    %eax
  802ee4:	a3 54 41 80 00       	mov    %eax,0x804154
}
  802ee9:	90                   	nop
  802eea:	c9                   	leave  
  802eeb:	c3                   	ret    

00802eec <insert_sorted_with_merge_freeList>:
void insert_sorted_with_merge_freeList(struct MemBlock *blockToInsert)
{
  802eec:	55                   	push   %ebp
  802eed:	89 e5                	mov    %esp,%ebp
  802eef:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] insert_sorted_with_merge_freeList
	// Write your code here, remove the panic and write your code

	struct MemBlock* last = LIST_LAST(&FreeMemBlocksList);
  802ef2:	a1 3c 41 80 00       	mov    0x80413c,%eax
  802ef7:	89 45 f0             	mov    %eax,-0x10(%ebp)
	//check if list empty
	if (LIST_SIZE(&(FreeMemBlocksList)) == 0)
  802efa:	a1 44 41 80 00       	mov    0x804144,%eax
  802eff:	85 c0                	test   %eax,%eax
  802f01:	75 68                	jne    802f6b <insert_sorted_with_merge_freeList+0x7f>
		LIST_INSERT_HEAD(&FreeMemBlocksList, blockToInsert);
  802f03:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802f07:	75 17                	jne    802f20 <insert_sorted_with_merge_freeList+0x34>
  802f09:	83 ec 04             	sub    $0x4,%esp
  802f0c:	68 f4 3d 80 00       	push   $0x803df4
  802f11:	68 1a 01 00 00       	push   $0x11a
  802f16:	68 17 3e 80 00       	push   $0x803e17
  802f1b:	e8 39 d8 ff ff       	call   800759 <_panic>
  802f20:	8b 15 38 41 80 00    	mov    0x804138,%edx
  802f26:	8b 45 08             	mov    0x8(%ebp),%eax
  802f29:	89 10                	mov    %edx,(%eax)
  802f2b:	8b 45 08             	mov    0x8(%ebp),%eax
  802f2e:	8b 00                	mov    (%eax),%eax
  802f30:	85 c0                	test   %eax,%eax
  802f32:	74 0d                	je     802f41 <insert_sorted_with_merge_freeList+0x55>
  802f34:	a1 38 41 80 00       	mov    0x804138,%eax
  802f39:	8b 55 08             	mov    0x8(%ebp),%edx
  802f3c:	89 50 04             	mov    %edx,0x4(%eax)
  802f3f:	eb 08                	jmp    802f49 <insert_sorted_with_merge_freeList+0x5d>
  802f41:	8b 45 08             	mov    0x8(%ebp),%eax
  802f44:	a3 3c 41 80 00       	mov    %eax,0x80413c
  802f49:	8b 45 08             	mov    0x8(%ebp),%eax
  802f4c:	a3 38 41 80 00       	mov    %eax,0x804138
  802f51:	8b 45 08             	mov    0x8(%ebp),%eax
  802f54:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802f5b:	a1 44 41 80 00       	mov    0x804144,%eax
  802f60:	40                   	inc    %eax
  802f61:	a3 44 41 80 00       	mov    %eax,0x804144
		}
	}

	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  802f66:	e9 c5 03 00 00       	jmp    803330 <insert_sorted_with_merge_freeList+0x444>
	struct MemBlock* last = LIST_LAST(&FreeMemBlocksList);
	//check if list empty
	if (LIST_SIZE(&(FreeMemBlocksList)) == 0)
		LIST_INSERT_HEAD(&FreeMemBlocksList, blockToInsert);
	//check if it's position is at last
	else if (last->sva < blockToInsert->sva) {
  802f6b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802f6e:	8b 50 08             	mov    0x8(%eax),%edx
  802f71:	8b 45 08             	mov    0x8(%ebp),%eax
  802f74:	8b 40 08             	mov    0x8(%eax),%eax
  802f77:	39 c2                	cmp    %eax,%edx
  802f79:	0f 83 b2 00 00 00    	jae    803031 <insert_sorted_with_merge_freeList+0x145>

		//if i have to merge
		if (last->sva + last->size == blockToInsert->sva) {
  802f7f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802f82:	8b 50 08             	mov    0x8(%eax),%edx
  802f85:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802f88:	8b 40 0c             	mov    0xc(%eax),%eax
  802f8b:	01 c2                	add    %eax,%edx
  802f8d:	8b 45 08             	mov    0x8(%ebp),%eax
  802f90:	8b 40 08             	mov    0x8(%eax),%eax
  802f93:	39 c2                	cmp    %eax,%edx
  802f95:	75 27                	jne    802fbe <insert_sorted_with_merge_freeList+0xd2>
			last->size = last->size + blockToInsert->size;
  802f97:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802f9a:	8b 50 0c             	mov    0xc(%eax),%edx
  802f9d:	8b 45 08             	mov    0x8(%ebp),%eax
  802fa0:	8b 40 0c             	mov    0xc(%eax),%eax
  802fa3:	01 c2                	add    %eax,%edx
  802fa5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802fa8:	89 50 0c             	mov    %edx,0xc(%eax)
			addToAvailMemBlocksList(blockToInsert);
  802fab:	83 ec 0c             	sub    $0xc,%esp
  802fae:	ff 75 08             	pushl  0x8(%ebp)
  802fb1:	e8 b6 fe ff ff       	call   802e6c <addToAvailMemBlocksList>
  802fb6:	83 c4 10             	add    $0x10,%esp
		}
	}

	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  802fb9:	e9 72 03 00 00       	jmp    803330 <insert_sorted_with_merge_freeList+0x444>
		if (last->sva + last->size == blockToInsert->sva) {
			last->size = last->size + blockToInsert->size;
			addToAvailMemBlocksList(blockToInsert);

		} else {
			LIST_INSERT_AFTER(&FreeMemBlocksList, last, blockToInsert);
  802fbe:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802fc2:	74 06                	je     802fca <insert_sorted_with_merge_freeList+0xde>
  802fc4:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802fc8:	75 17                	jne    802fe1 <insert_sorted_with_merge_freeList+0xf5>
  802fca:	83 ec 04             	sub    $0x4,%esp
  802fcd:	68 54 3e 80 00       	push   $0x803e54
  802fd2:	68 24 01 00 00       	push   $0x124
  802fd7:	68 17 3e 80 00       	push   $0x803e17
  802fdc:	e8 78 d7 ff ff       	call   800759 <_panic>
  802fe1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802fe4:	8b 10                	mov    (%eax),%edx
  802fe6:	8b 45 08             	mov    0x8(%ebp),%eax
  802fe9:	89 10                	mov    %edx,(%eax)
  802feb:	8b 45 08             	mov    0x8(%ebp),%eax
  802fee:	8b 00                	mov    (%eax),%eax
  802ff0:	85 c0                	test   %eax,%eax
  802ff2:	74 0b                	je     802fff <insert_sorted_with_merge_freeList+0x113>
  802ff4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802ff7:	8b 00                	mov    (%eax),%eax
  802ff9:	8b 55 08             	mov    0x8(%ebp),%edx
  802ffc:	89 50 04             	mov    %edx,0x4(%eax)
  802fff:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803002:	8b 55 08             	mov    0x8(%ebp),%edx
  803005:	89 10                	mov    %edx,(%eax)
  803007:	8b 45 08             	mov    0x8(%ebp),%eax
  80300a:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80300d:	89 50 04             	mov    %edx,0x4(%eax)
  803010:	8b 45 08             	mov    0x8(%ebp),%eax
  803013:	8b 00                	mov    (%eax),%eax
  803015:	85 c0                	test   %eax,%eax
  803017:	75 08                	jne    803021 <insert_sorted_with_merge_freeList+0x135>
  803019:	8b 45 08             	mov    0x8(%ebp),%eax
  80301c:	a3 3c 41 80 00       	mov    %eax,0x80413c
  803021:	a1 44 41 80 00       	mov    0x804144,%eax
  803026:	40                   	inc    %eax
  803027:	a3 44 41 80 00       	mov    %eax,0x804144
		}
	}

	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  80302c:	e9 ff 02 00 00       	jmp    803330 <insert_sorted_with_merge_freeList+0x444>
		} else {
			LIST_INSERT_AFTER(&FreeMemBlocksList, last, blockToInsert);
		}
	} else {
		struct MemBlock *iterator;
		LIST_FOREACH(iterator, &(FreeMemBlocksList))
  803031:	a1 38 41 80 00       	mov    0x804138,%eax
  803036:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803039:	e9 c2 02 00 00       	jmp    803300 <insert_sorted_with_merge_freeList+0x414>
		{

			if (iterator->sva > blockToInsert->sva) {
  80303e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803041:	8b 50 08             	mov    0x8(%eax),%edx
  803044:	8b 45 08             	mov    0x8(%ebp),%eax
  803047:	8b 40 08             	mov    0x8(%eax),%eax
  80304a:	39 c2                	cmp    %eax,%edx
  80304c:	0f 86 a6 02 00 00    	jbe    8032f8 <insert_sorted_with_merge_freeList+0x40c>

				struct MemBlock* prev = LIST_PREV(iterator);
  803052:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803055:	8b 40 04             	mov    0x4(%eax),%eax
  803058:	89 45 ec             	mov    %eax,-0x14(%ebp)
				if (prev == NULL) {
  80305b:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  80305f:	0f 85 ba 00 00 00    	jne    80311f <insert_sorted_with_merge_freeList+0x233>
					//check merge
					if (blockToInsert->size + blockToInsert->sva
  803065:	8b 45 08             	mov    0x8(%ebp),%eax
  803068:	8b 50 0c             	mov    0xc(%eax),%edx
  80306b:	8b 45 08             	mov    0x8(%ebp),%eax
  80306e:	8b 40 08             	mov    0x8(%eax),%eax
  803071:	01 c2                	add    %eax,%edx
							== iterator->sva) {
  803073:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803076:	8b 40 08             	mov    0x8(%eax),%eax
			if (iterator->sva > blockToInsert->sva) {

				struct MemBlock* prev = LIST_PREV(iterator);
				if (prev == NULL) {
					//check merge
					if (blockToInsert->size + blockToInsert->sva
  803079:	39 c2                	cmp    %eax,%edx
  80307b:	75 33                	jne    8030b0 <insert_sorted_with_merge_freeList+0x1c4>
							== iterator->sva) {
						iterator->sva = blockToInsert->sva;
  80307d:	8b 45 08             	mov    0x8(%ebp),%eax
  803080:	8b 50 08             	mov    0x8(%eax),%edx
  803083:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803086:	89 50 08             	mov    %edx,0x8(%eax)
						iterator->size = iterator->size + blockToInsert->size;
  803089:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80308c:	8b 50 0c             	mov    0xc(%eax),%edx
  80308f:	8b 45 08             	mov    0x8(%ebp),%eax
  803092:	8b 40 0c             	mov    0xc(%eax),%eax
  803095:	01 c2                	add    %eax,%edx
  803097:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80309a:	89 50 0c             	mov    %edx,0xc(%eax)
						addToAvailMemBlocksList(blockToInsert);
  80309d:	83 ec 0c             	sub    $0xc,%esp
  8030a0:	ff 75 08             	pushl  0x8(%ebp)
  8030a3:	e8 c4 fd ff ff       	call   802e6c <addToAvailMemBlocksList>
  8030a8:	83 c4 10             	add    $0x10,%esp

					else {
						LIST_INSERT_BEFORE(&FreeMemBlocksList, iterator,
								blockToInsert);
					}
					break;
  8030ab:	e9 80 02 00 00       	jmp    803330 <insert_sorted_with_merge_freeList+0x444>
						addToAvailMemBlocksList(blockToInsert);

					}

					else {
						LIST_INSERT_BEFORE(&FreeMemBlocksList, iterator,
  8030b0:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8030b4:	74 06                	je     8030bc <insert_sorted_with_merge_freeList+0x1d0>
  8030b6:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8030ba:	75 17                	jne    8030d3 <insert_sorted_with_merge_freeList+0x1e7>
  8030bc:	83 ec 04             	sub    $0x4,%esp
  8030bf:	68 a8 3e 80 00       	push   $0x803ea8
  8030c4:	68 3a 01 00 00       	push   $0x13a
  8030c9:	68 17 3e 80 00       	push   $0x803e17
  8030ce:	e8 86 d6 ff ff       	call   800759 <_panic>
  8030d3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030d6:	8b 50 04             	mov    0x4(%eax),%edx
  8030d9:	8b 45 08             	mov    0x8(%ebp),%eax
  8030dc:	89 50 04             	mov    %edx,0x4(%eax)
  8030df:	8b 45 08             	mov    0x8(%ebp),%eax
  8030e2:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8030e5:	89 10                	mov    %edx,(%eax)
  8030e7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030ea:	8b 40 04             	mov    0x4(%eax),%eax
  8030ed:	85 c0                	test   %eax,%eax
  8030ef:	74 0d                	je     8030fe <insert_sorted_with_merge_freeList+0x212>
  8030f1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030f4:	8b 40 04             	mov    0x4(%eax),%eax
  8030f7:	8b 55 08             	mov    0x8(%ebp),%edx
  8030fa:	89 10                	mov    %edx,(%eax)
  8030fc:	eb 08                	jmp    803106 <insert_sorted_with_merge_freeList+0x21a>
  8030fe:	8b 45 08             	mov    0x8(%ebp),%eax
  803101:	a3 38 41 80 00       	mov    %eax,0x804138
  803106:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803109:	8b 55 08             	mov    0x8(%ebp),%edx
  80310c:	89 50 04             	mov    %edx,0x4(%eax)
  80310f:	a1 44 41 80 00       	mov    0x804144,%eax
  803114:	40                   	inc    %eax
  803115:	a3 44 41 80 00       	mov    %eax,0x804144
								blockToInsert);
					}
					break;
  80311a:	e9 11 02 00 00       	jmp    803330 <insert_sorted_with_merge_freeList+0x444>
				} else {
					//prev and next merge
					if (prev->sva + prev->size + blockToInsert->size
  80311f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803122:	8b 50 08             	mov    0x8(%eax),%edx
  803125:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803128:	8b 40 0c             	mov    0xc(%eax),%eax
  80312b:	01 c2                	add    %eax,%edx
  80312d:	8b 45 08             	mov    0x8(%ebp),%eax
  803130:	8b 40 0c             	mov    0xc(%eax),%eax
  803133:	01 c2                	add    %eax,%edx
							== iterator->sva) {
  803135:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803138:	8b 40 08             	mov    0x8(%eax),%eax
								blockToInsert);
					}
					break;
				} else {
					//prev and next merge
					if (prev->sva + prev->size + blockToInsert->size
  80313b:	39 c2                	cmp    %eax,%edx
  80313d:	0f 85 bf 00 00 00    	jne    803202 <insert_sorted_with_merge_freeList+0x316>
							== iterator->sva) {
						prev->size = prev->size + blockToInsert->size
  803143:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803146:	8b 50 0c             	mov    0xc(%eax),%edx
  803149:	8b 45 08             	mov    0x8(%ebp),%eax
  80314c:	8b 40 0c             	mov    0xc(%eax),%eax
  80314f:	01 c2                	add    %eax,%edx
								+ iterator->size;
  803151:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803154:	8b 40 0c             	mov    0xc(%eax),%eax
  803157:	01 c2                	add    %eax,%edx
					break;
				} else {
					//prev and next merge
					if (prev->sva + prev->size + blockToInsert->size
							== iterator->sva) {
						prev->size = prev->size + blockToInsert->size
  803159:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80315c:	89 50 0c             	mov    %edx,0xc(%eax)
								+ iterator->size;
						LIST_REMOVE(&FreeMemBlocksList, iterator);
  80315f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803163:	75 17                	jne    80317c <insert_sorted_with_merge_freeList+0x290>
  803165:	83 ec 04             	sub    $0x4,%esp
  803168:	68 88 3e 80 00       	push   $0x803e88
  80316d:	68 43 01 00 00       	push   $0x143
  803172:	68 17 3e 80 00       	push   $0x803e17
  803177:	e8 dd d5 ff ff       	call   800759 <_panic>
  80317c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80317f:	8b 00                	mov    (%eax),%eax
  803181:	85 c0                	test   %eax,%eax
  803183:	74 10                	je     803195 <insert_sorted_with_merge_freeList+0x2a9>
  803185:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803188:	8b 00                	mov    (%eax),%eax
  80318a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80318d:	8b 52 04             	mov    0x4(%edx),%edx
  803190:	89 50 04             	mov    %edx,0x4(%eax)
  803193:	eb 0b                	jmp    8031a0 <insert_sorted_with_merge_freeList+0x2b4>
  803195:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803198:	8b 40 04             	mov    0x4(%eax),%eax
  80319b:	a3 3c 41 80 00       	mov    %eax,0x80413c
  8031a0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8031a3:	8b 40 04             	mov    0x4(%eax),%eax
  8031a6:	85 c0                	test   %eax,%eax
  8031a8:	74 0f                	je     8031b9 <insert_sorted_with_merge_freeList+0x2cd>
  8031aa:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8031ad:	8b 40 04             	mov    0x4(%eax),%eax
  8031b0:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8031b3:	8b 12                	mov    (%edx),%edx
  8031b5:	89 10                	mov    %edx,(%eax)
  8031b7:	eb 0a                	jmp    8031c3 <insert_sorted_with_merge_freeList+0x2d7>
  8031b9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8031bc:	8b 00                	mov    (%eax),%eax
  8031be:	a3 38 41 80 00       	mov    %eax,0x804138
  8031c3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8031c6:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8031cc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8031cf:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8031d6:	a1 44 41 80 00       	mov    0x804144,%eax
  8031db:	48                   	dec    %eax
  8031dc:	a3 44 41 80 00       	mov    %eax,0x804144
						addToAvailMemBlocksList(blockToInsert);
  8031e1:	83 ec 0c             	sub    $0xc,%esp
  8031e4:	ff 75 08             	pushl  0x8(%ebp)
  8031e7:	e8 80 fc ff ff       	call   802e6c <addToAvailMemBlocksList>
  8031ec:	83 c4 10             	add    $0x10,%esp
						addToAvailMemBlocksList(iterator);
  8031ef:	83 ec 0c             	sub    $0xc,%esp
  8031f2:	ff 75 f4             	pushl  -0xc(%ebp)
  8031f5:	e8 72 fc ff ff       	call   802e6c <addToAvailMemBlocksList>
  8031fa:	83 c4 10             	add    $0x10,%esp
					//Insert
					else {
						LIST_INSERT_BEFORE(&FreeMemBlocksList, iterator,
								blockToInsert);
					}
					break;
  8031fd:	e9 2e 01 00 00       	jmp    803330 <insert_sorted_with_merge_freeList+0x444>
						LIST_REMOVE(&FreeMemBlocksList, iterator);
						addToAvailMemBlocksList(blockToInsert);
						addToAvailMemBlocksList(iterator);
					}
					//previous merge
					else if (prev->sva + prev->size == blockToInsert->sva) {
  803202:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803205:	8b 50 08             	mov    0x8(%eax),%edx
  803208:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80320b:	8b 40 0c             	mov    0xc(%eax),%eax
  80320e:	01 c2                	add    %eax,%edx
  803210:	8b 45 08             	mov    0x8(%ebp),%eax
  803213:	8b 40 08             	mov    0x8(%eax),%eax
  803216:	39 c2                	cmp    %eax,%edx
  803218:	75 27                	jne    803241 <insert_sorted_with_merge_freeList+0x355>
						prev->size = prev->size + blockToInsert->size;
  80321a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80321d:	8b 50 0c             	mov    0xc(%eax),%edx
  803220:	8b 45 08             	mov    0x8(%ebp),%eax
  803223:	8b 40 0c             	mov    0xc(%eax),%eax
  803226:	01 c2                	add    %eax,%edx
  803228:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80322b:	89 50 0c             	mov    %edx,0xc(%eax)
						addToAvailMemBlocksList(blockToInsert);
  80322e:	83 ec 0c             	sub    $0xc,%esp
  803231:	ff 75 08             	pushl  0x8(%ebp)
  803234:	e8 33 fc ff ff       	call   802e6c <addToAvailMemBlocksList>
  803239:	83 c4 10             	add    $0x10,%esp
					//Insert
					else {
						LIST_INSERT_BEFORE(&FreeMemBlocksList, iterator,
								blockToInsert);
					}
					break;
  80323c:	e9 ef 00 00 00       	jmp    803330 <insert_sorted_with_merge_freeList+0x444>
					else if (prev->sva + prev->size == blockToInsert->sva) {
						prev->size = prev->size + blockToInsert->size;
						addToAvailMemBlocksList(blockToInsert);
					}
					//next merge
					else if (blockToInsert->size + blockToInsert->sva
  803241:	8b 45 08             	mov    0x8(%ebp),%eax
  803244:	8b 50 0c             	mov    0xc(%eax),%edx
  803247:	8b 45 08             	mov    0x8(%ebp),%eax
  80324a:	8b 40 08             	mov    0x8(%eax),%eax
  80324d:	01 c2                	add    %eax,%edx
							== iterator->sva) {
  80324f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803252:	8b 40 08             	mov    0x8(%eax),%eax
					else if (prev->sva + prev->size == blockToInsert->sva) {
						prev->size = prev->size + blockToInsert->size;
						addToAvailMemBlocksList(blockToInsert);
					}
					//next merge
					else if (blockToInsert->size + blockToInsert->sva
  803255:	39 c2                	cmp    %eax,%edx
  803257:	75 33                	jne    80328c <insert_sorted_with_merge_freeList+0x3a0>
							== iterator->sva) {
						iterator->sva = blockToInsert->sva;
  803259:	8b 45 08             	mov    0x8(%ebp),%eax
  80325c:	8b 50 08             	mov    0x8(%eax),%edx
  80325f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803262:	89 50 08             	mov    %edx,0x8(%eax)
						iterator->size = iterator->size + blockToInsert->size;
  803265:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803268:	8b 50 0c             	mov    0xc(%eax),%edx
  80326b:	8b 45 08             	mov    0x8(%ebp),%eax
  80326e:	8b 40 0c             	mov    0xc(%eax),%eax
  803271:	01 c2                	add    %eax,%edx
  803273:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803276:	89 50 0c             	mov    %edx,0xc(%eax)
						addToAvailMemBlocksList(blockToInsert);
  803279:	83 ec 0c             	sub    $0xc,%esp
  80327c:	ff 75 08             	pushl  0x8(%ebp)
  80327f:	e8 e8 fb ff ff       	call   802e6c <addToAvailMemBlocksList>
  803284:	83 c4 10             	add    $0x10,%esp
					//Insert
					else {
						LIST_INSERT_BEFORE(&FreeMemBlocksList, iterator,
								blockToInsert);
					}
					break;
  803287:	e9 a4 00 00 00       	jmp    803330 <insert_sorted_with_merge_freeList+0x444>
						iterator->size = iterator->size + blockToInsert->size;
						addToAvailMemBlocksList(blockToInsert);
					}
					//Insert
					else {
						LIST_INSERT_BEFORE(&FreeMemBlocksList, iterator,
  80328c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803290:	74 06                	je     803298 <insert_sorted_with_merge_freeList+0x3ac>
  803292:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803296:	75 17                	jne    8032af <insert_sorted_with_merge_freeList+0x3c3>
  803298:	83 ec 04             	sub    $0x4,%esp
  80329b:	68 a8 3e 80 00       	push   $0x803ea8
  8032a0:	68 56 01 00 00       	push   $0x156
  8032a5:	68 17 3e 80 00       	push   $0x803e17
  8032aa:	e8 aa d4 ff ff       	call   800759 <_panic>
  8032af:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8032b2:	8b 50 04             	mov    0x4(%eax),%edx
  8032b5:	8b 45 08             	mov    0x8(%ebp),%eax
  8032b8:	89 50 04             	mov    %edx,0x4(%eax)
  8032bb:	8b 45 08             	mov    0x8(%ebp),%eax
  8032be:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8032c1:	89 10                	mov    %edx,(%eax)
  8032c3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8032c6:	8b 40 04             	mov    0x4(%eax),%eax
  8032c9:	85 c0                	test   %eax,%eax
  8032cb:	74 0d                	je     8032da <insert_sorted_with_merge_freeList+0x3ee>
  8032cd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8032d0:	8b 40 04             	mov    0x4(%eax),%eax
  8032d3:	8b 55 08             	mov    0x8(%ebp),%edx
  8032d6:	89 10                	mov    %edx,(%eax)
  8032d8:	eb 08                	jmp    8032e2 <insert_sorted_with_merge_freeList+0x3f6>
  8032da:	8b 45 08             	mov    0x8(%ebp),%eax
  8032dd:	a3 38 41 80 00       	mov    %eax,0x804138
  8032e2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8032e5:	8b 55 08             	mov    0x8(%ebp),%edx
  8032e8:	89 50 04             	mov    %edx,0x4(%eax)
  8032eb:	a1 44 41 80 00       	mov    0x804144,%eax
  8032f0:	40                   	inc    %eax
  8032f1:	a3 44 41 80 00       	mov    %eax,0x804144
								blockToInsert);
					}
					break;
  8032f6:	eb 38                	jmp    803330 <insert_sorted_with_merge_freeList+0x444>
		} else {
			LIST_INSERT_AFTER(&FreeMemBlocksList, last, blockToInsert);
		}
	} else {
		struct MemBlock *iterator;
		LIST_FOREACH(iterator, &(FreeMemBlocksList))
  8032f8:	a1 40 41 80 00       	mov    0x804140,%eax
  8032fd:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803300:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803304:	74 07                	je     80330d <insert_sorted_with_merge_freeList+0x421>
  803306:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803309:	8b 00                	mov    (%eax),%eax
  80330b:	eb 05                	jmp    803312 <insert_sorted_with_merge_freeList+0x426>
  80330d:	b8 00 00 00 00       	mov    $0x0,%eax
  803312:	a3 40 41 80 00       	mov    %eax,0x804140
  803317:	a1 40 41 80 00       	mov    0x804140,%eax
  80331c:	85 c0                	test   %eax,%eax
  80331e:	0f 85 1a fd ff ff    	jne    80303e <insert_sorted_with_merge_freeList+0x152>
  803324:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803328:	0f 85 10 fd ff ff    	jne    80303e <insert_sorted_with_merge_freeList+0x152>
		}
	}

	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  80332e:	eb 00                	jmp    803330 <insert_sorted_with_merge_freeList+0x444>
  803330:	90                   	nop
  803331:	c9                   	leave  
  803332:	c3                   	ret    
  803333:	90                   	nop

00803334 <__udivdi3>:
  803334:	55                   	push   %ebp
  803335:	57                   	push   %edi
  803336:	56                   	push   %esi
  803337:	53                   	push   %ebx
  803338:	83 ec 1c             	sub    $0x1c,%esp
  80333b:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  80333f:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  803343:	8b 7c 24 38          	mov    0x38(%esp),%edi
  803347:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  80334b:	89 ca                	mov    %ecx,%edx
  80334d:	89 f8                	mov    %edi,%eax
  80334f:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  803353:	85 f6                	test   %esi,%esi
  803355:	75 2d                	jne    803384 <__udivdi3+0x50>
  803357:	39 cf                	cmp    %ecx,%edi
  803359:	77 65                	ja     8033c0 <__udivdi3+0x8c>
  80335b:	89 fd                	mov    %edi,%ebp
  80335d:	85 ff                	test   %edi,%edi
  80335f:	75 0b                	jne    80336c <__udivdi3+0x38>
  803361:	b8 01 00 00 00       	mov    $0x1,%eax
  803366:	31 d2                	xor    %edx,%edx
  803368:	f7 f7                	div    %edi
  80336a:	89 c5                	mov    %eax,%ebp
  80336c:	31 d2                	xor    %edx,%edx
  80336e:	89 c8                	mov    %ecx,%eax
  803370:	f7 f5                	div    %ebp
  803372:	89 c1                	mov    %eax,%ecx
  803374:	89 d8                	mov    %ebx,%eax
  803376:	f7 f5                	div    %ebp
  803378:	89 cf                	mov    %ecx,%edi
  80337a:	89 fa                	mov    %edi,%edx
  80337c:	83 c4 1c             	add    $0x1c,%esp
  80337f:	5b                   	pop    %ebx
  803380:	5e                   	pop    %esi
  803381:	5f                   	pop    %edi
  803382:	5d                   	pop    %ebp
  803383:	c3                   	ret    
  803384:	39 ce                	cmp    %ecx,%esi
  803386:	77 28                	ja     8033b0 <__udivdi3+0x7c>
  803388:	0f bd fe             	bsr    %esi,%edi
  80338b:	83 f7 1f             	xor    $0x1f,%edi
  80338e:	75 40                	jne    8033d0 <__udivdi3+0x9c>
  803390:	39 ce                	cmp    %ecx,%esi
  803392:	72 0a                	jb     80339e <__udivdi3+0x6a>
  803394:	3b 44 24 08          	cmp    0x8(%esp),%eax
  803398:	0f 87 9e 00 00 00    	ja     80343c <__udivdi3+0x108>
  80339e:	b8 01 00 00 00       	mov    $0x1,%eax
  8033a3:	89 fa                	mov    %edi,%edx
  8033a5:	83 c4 1c             	add    $0x1c,%esp
  8033a8:	5b                   	pop    %ebx
  8033a9:	5e                   	pop    %esi
  8033aa:	5f                   	pop    %edi
  8033ab:	5d                   	pop    %ebp
  8033ac:	c3                   	ret    
  8033ad:	8d 76 00             	lea    0x0(%esi),%esi
  8033b0:	31 ff                	xor    %edi,%edi
  8033b2:	31 c0                	xor    %eax,%eax
  8033b4:	89 fa                	mov    %edi,%edx
  8033b6:	83 c4 1c             	add    $0x1c,%esp
  8033b9:	5b                   	pop    %ebx
  8033ba:	5e                   	pop    %esi
  8033bb:	5f                   	pop    %edi
  8033bc:	5d                   	pop    %ebp
  8033bd:	c3                   	ret    
  8033be:	66 90                	xchg   %ax,%ax
  8033c0:	89 d8                	mov    %ebx,%eax
  8033c2:	f7 f7                	div    %edi
  8033c4:	31 ff                	xor    %edi,%edi
  8033c6:	89 fa                	mov    %edi,%edx
  8033c8:	83 c4 1c             	add    $0x1c,%esp
  8033cb:	5b                   	pop    %ebx
  8033cc:	5e                   	pop    %esi
  8033cd:	5f                   	pop    %edi
  8033ce:	5d                   	pop    %ebp
  8033cf:	c3                   	ret    
  8033d0:	bd 20 00 00 00       	mov    $0x20,%ebp
  8033d5:	89 eb                	mov    %ebp,%ebx
  8033d7:	29 fb                	sub    %edi,%ebx
  8033d9:	89 f9                	mov    %edi,%ecx
  8033db:	d3 e6                	shl    %cl,%esi
  8033dd:	89 c5                	mov    %eax,%ebp
  8033df:	88 d9                	mov    %bl,%cl
  8033e1:	d3 ed                	shr    %cl,%ebp
  8033e3:	89 e9                	mov    %ebp,%ecx
  8033e5:	09 f1                	or     %esi,%ecx
  8033e7:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  8033eb:	89 f9                	mov    %edi,%ecx
  8033ed:	d3 e0                	shl    %cl,%eax
  8033ef:	89 c5                	mov    %eax,%ebp
  8033f1:	89 d6                	mov    %edx,%esi
  8033f3:	88 d9                	mov    %bl,%cl
  8033f5:	d3 ee                	shr    %cl,%esi
  8033f7:	89 f9                	mov    %edi,%ecx
  8033f9:	d3 e2                	shl    %cl,%edx
  8033fb:	8b 44 24 08          	mov    0x8(%esp),%eax
  8033ff:	88 d9                	mov    %bl,%cl
  803401:	d3 e8                	shr    %cl,%eax
  803403:	09 c2                	or     %eax,%edx
  803405:	89 d0                	mov    %edx,%eax
  803407:	89 f2                	mov    %esi,%edx
  803409:	f7 74 24 0c          	divl   0xc(%esp)
  80340d:	89 d6                	mov    %edx,%esi
  80340f:	89 c3                	mov    %eax,%ebx
  803411:	f7 e5                	mul    %ebp
  803413:	39 d6                	cmp    %edx,%esi
  803415:	72 19                	jb     803430 <__udivdi3+0xfc>
  803417:	74 0b                	je     803424 <__udivdi3+0xf0>
  803419:	89 d8                	mov    %ebx,%eax
  80341b:	31 ff                	xor    %edi,%edi
  80341d:	e9 58 ff ff ff       	jmp    80337a <__udivdi3+0x46>
  803422:	66 90                	xchg   %ax,%ax
  803424:	8b 54 24 08          	mov    0x8(%esp),%edx
  803428:	89 f9                	mov    %edi,%ecx
  80342a:	d3 e2                	shl    %cl,%edx
  80342c:	39 c2                	cmp    %eax,%edx
  80342e:	73 e9                	jae    803419 <__udivdi3+0xe5>
  803430:	8d 43 ff             	lea    -0x1(%ebx),%eax
  803433:	31 ff                	xor    %edi,%edi
  803435:	e9 40 ff ff ff       	jmp    80337a <__udivdi3+0x46>
  80343a:	66 90                	xchg   %ax,%ax
  80343c:	31 c0                	xor    %eax,%eax
  80343e:	e9 37 ff ff ff       	jmp    80337a <__udivdi3+0x46>
  803443:	90                   	nop

00803444 <__umoddi3>:
  803444:	55                   	push   %ebp
  803445:	57                   	push   %edi
  803446:	56                   	push   %esi
  803447:	53                   	push   %ebx
  803448:	83 ec 1c             	sub    $0x1c,%esp
  80344b:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  80344f:	8b 74 24 34          	mov    0x34(%esp),%esi
  803453:	8b 7c 24 38          	mov    0x38(%esp),%edi
  803457:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  80345b:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80345f:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  803463:	89 f3                	mov    %esi,%ebx
  803465:	89 fa                	mov    %edi,%edx
  803467:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  80346b:	89 34 24             	mov    %esi,(%esp)
  80346e:	85 c0                	test   %eax,%eax
  803470:	75 1a                	jne    80348c <__umoddi3+0x48>
  803472:	39 f7                	cmp    %esi,%edi
  803474:	0f 86 a2 00 00 00    	jbe    80351c <__umoddi3+0xd8>
  80347a:	89 c8                	mov    %ecx,%eax
  80347c:	89 f2                	mov    %esi,%edx
  80347e:	f7 f7                	div    %edi
  803480:	89 d0                	mov    %edx,%eax
  803482:	31 d2                	xor    %edx,%edx
  803484:	83 c4 1c             	add    $0x1c,%esp
  803487:	5b                   	pop    %ebx
  803488:	5e                   	pop    %esi
  803489:	5f                   	pop    %edi
  80348a:	5d                   	pop    %ebp
  80348b:	c3                   	ret    
  80348c:	39 f0                	cmp    %esi,%eax
  80348e:	0f 87 ac 00 00 00    	ja     803540 <__umoddi3+0xfc>
  803494:	0f bd e8             	bsr    %eax,%ebp
  803497:	83 f5 1f             	xor    $0x1f,%ebp
  80349a:	0f 84 ac 00 00 00    	je     80354c <__umoddi3+0x108>
  8034a0:	bf 20 00 00 00       	mov    $0x20,%edi
  8034a5:	29 ef                	sub    %ebp,%edi
  8034a7:	89 fe                	mov    %edi,%esi
  8034a9:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  8034ad:	89 e9                	mov    %ebp,%ecx
  8034af:	d3 e0                	shl    %cl,%eax
  8034b1:	89 d7                	mov    %edx,%edi
  8034b3:	89 f1                	mov    %esi,%ecx
  8034b5:	d3 ef                	shr    %cl,%edi
  8034b7:	09 c7                	or     %eax,%edi
  8034b9:	89 e9                	mov    %ebp,%ecx
  8034bb:	d3 e2                	shl    %cl,%edx
  8034bd:	89 14 24             	mov    %edx,(%esp)
  8034c0:	89 d8                	mov    %ebx,%eax
  8034c2:	d3 e0                	shl    %cl,%eax
  8034c4:	89 c2                	mov    %eax,%edx
  8034c6:	8b 44 24 08          	mov    0x8(%esp),%eax
  8034ca:	d3 e0                	shl    %cl,%eax
  8034cc:	89 44 24 04          	mov    %eax,0x4(%esp)
  8034d0:	8b 44 24 08          	mov    0x8(%esp),%eax
  8034d4:	89 f1                	mov    %esi,%ecx
  8034d6:	d3 e8                	shr    %cl,%eax
  8034d8:	09 d0                	or     %edx,%eax
  8034da:	d3 eb                	shr    %cl,%ebx
  8034dc:	89 da                	mov    %ebx,%edx
  8034de:	f7 f7                	div    %edi
  8034e0:	89 d3                	mov    %edx,%ebx
  8034e2:	f7 24 24             	mull   (%esp)
  8034e5:	89 c6                	mov    %eax,%esi
  8034e7:	89 d1                	mov    %edx,%ecx
  8034e9:	39 d3                	cmp    %edx,%ebx
  8034eb:	0f 82 87 00 00 00    	jb     803578 <__umoddi3+0x134>
  8034f1:	0f 84 91 00 00 00    	je     803588 <__umoddi3+0x144>
  8034f7:	8b 54 24 04          	mov    0x4(%esp),%edx
  8034fb:	29 f2                	sub    %esi,%edx
  8034fd:	19 cb                	sbb    %ecx,%ebx
  8034ff:	89 d8                	mov    %ebx,%eax
  803501:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  803505:	d3 e0                	shl    %cl,%eax
  803507:	89 e9                	mov    %ebp,%ecx
  803509:	d3 ea                	shr    %cl,%edx
  80350b:	09 d0                	or     %edx,%eax
  80350d:	89 e9                	mov    %ebp,%ecx
  80350f:	d3 eb                	shr    %cl,%ebx
  803511:	89 da                	mov    %ebx,%edx
  803513:	83 c4 1c             	add    $0x1c,%esp
  803516:	5b                   	pop    %ebx
  803517:	5e                   	pop    %esi
  803518:	5f                   	pop    %edi
  803519:	5d                   	pop    %ebp
  80351a:	c3                   	ret    
  80351b:	90                   	nop
  80351c:	89 fd                	mov    %edi,%ebp
  80351e:	85 ff                	test   %edi,%edi
  803520:	75 0b                	jne    80352d <__umoddi3+0xe9>
  803522:	b8 01 00 00 00       	mov    $0x1,%eax
  803527:	31 d2                	xor    %edx,%edx
  803529:	f7 f7                	div    %edi
  80352b:	89 c5                	mov    %eax,%ebp
  80352d:	89 f0                	mov    %esi,%eax
  80352f:	31 d2                	xor    %edx,%edx
  803531:	f7 f5                	div    %ebp
  803533:	89 c8                	mov    %ecx,%eax
  803535:	f7 f5                	div    %ebp
  803537:	89 d0                	mov    %edx,%eax
  803539:	e9 44 ff ff ff       	jmp    803482 <__umoddi3+0x3e>
  80353e:	66 90                	xchg   %ax,%ax
  803540:	89 c8                	mov    %ecx,%eax
  803542:	89 f2                	mov    %esi,%edx
  803544:	83 c4 1c             	add    $0x1c,%esp
  803547:	5b                   	pop    %ebx
  803548:	5e                   	pop    %esi
  803549:	5f                   	pop    %edi
  80354a:	5d                   	pop    %ebp
  80354b:	c3                   	ret    
  80354c:	3b 04 24             	cmp    (%esp),%eax
  80354f:	72 06                	jb     803557 <__umoddi3+0x113>
  803551:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  803555:	77 0f                	ja     803566 <__umoddi3+0x122>
  803557:	89 f2                	mov    %esi,%edx
  803559:	29 f9                	sub    %edi,%ecx
  80355b:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  80355f:	89 14 24             	mov    %edx,(%esp)
  803562:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  803566:	8b 44 24 04          	mov    0x4(%esp),%eax
  80356a:	8b 14 24             	mov    (%esp),%edx
  80356d:	83 c4 1c             	add    $0x1c,%esp
  803570:	5b                   	pop    %ebx
  803571:	5e                   	pop    %esi
  803572:	5f                   	pop    %edi
  803573:	5d                   	pop    %ebp
  803574:	c3                   	ret    
  803575:	8d 76 00             	lea    0x0(%esi),%esi
  803578:	2b 04 24             	sub    (%esp),%eax
  80357b:	19 fa                	sbb    %edi,%edx
  80357d:	89 d1                	mov    %edx,%ecx
  80357f:	89 c6                	mov    %eax,%esi
  803581:	e9 71 ff ff ff       	jmp    8034f7 <__umoddi3+0xb3>
  803586:	66 90                	xchg   %ax,%ax
  803588:	39 44 24 04          	cmp    %eax,0x4(%esp)
  80358c:	72 ea                	jb     803578 <__umoddi3+0x134>
  80358e:	89 d9                	mov    %ebx,%ecx
  803590:	e9 62 ff ff ff       	jmp    8034f7 <__umoddi3+0xb3>
