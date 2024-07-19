
obj/user/tst_air_customer:     file format elf32-i386


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
  800031:	e8 dc 03 00 00       	call   800412 <libmain>
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
  80003e:	81 ec 8c 01 00 00    	sub    $0x18c,%esp
	int32 parentenvID = sys_getparentenvid();
  800044:	e8 70 1c 00 00       	call   801cb9 <sys_getparentenvid>
  800049:	89 45 e4             	mov    %eax,-0x1c(%ebp)

	char _customers[] = "customers";
  80004c:	8d 45 c2             	lea    -0x3e(%ebp),%eax
  80004f:	bb e9 33 80 00       	mov    $0x8033e9,%ebx
  800054:	ba 0a 00 00 00       	mov    $0xa,%edx
  800059:	89 c7                	mov    %eax,%edi
  80005b:	89 de                	mov    %ebx,%esi
  80005d:	89 d1                	mov    %edx,%ecx
  80005f:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
	char _custCounter[] = "custCounter";
  800061:	8d 45 b6             	lea    -0x4a(%ebp),%eax
  800064:	bb f3 33 80 00       	mov    $0x8033f3,%ebx
  800069:	ba 03 00 00 00       	mov    $0x3,%edx
  80006e:	89 c7                	mov    %eax,%edi
  800070:	89 de                	mov    %ebx,%esi
  800072:	89 d1                	mov    %edx,%ecx
  800074:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
	char _flight1Counter[] = "flight1Counter";
  800076:	8d 45 a7             	lea    -0x59(%ebp),%eax
  800079:	bb ff 33 80 00       	mov    $0x8033ff,%ebx
  80007e:	ba 0f 00 00 00       	mov    $0xf,%edx
  800083:	89 c7                	mov    %eax,%edi
  800085:	89 de                	mov    %ebx,%esi
  800087:	89 d1                	mov    %edx,%ecx
  800089:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
	char _flight2Counter[] = "flight2Counter";
  80008b:	8d 45 98             	lea    -0x68(%ebp),%eax
  80008e:	bb 0e 34 80 00       	mov    $0x80340e,%ebx
  800093:	ba 0f 00 00 00       	mov    $0xf,%edx
  800098:	89 c7                	mov    %eax,%edi
  80009a:	89 de                	mov    %ebx,%esi
  80009c:	89 d1                	mov    %edx,%ecx
  80009e:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
	char _flightBooked1Counter[] = "flightBooked1Counter";
  8000a0:	8d 45 83             	lea    -0x7d(%ebp),%eax
  8000a3:	bb 1d 34 80 00       	mov    $0x80341d,%ebx
  8000a8:	ba 15 00 00 00       	mov    $0x15,%edx
  8000ad:	89 c7                	mov    %eax,%edi
  8000af:	89 de                	mov    %ebx,%esi
  8000b1:	89 d1                	mov    %edx,%ecx
  8000b3:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
	char _flightBooked2Counter[] = "flightBooked2Counter";
  8000b5:	8d 85 6e ff ff ff    	lea    -0x92(%ebp),%eax
  8000bb:	bb 32 34 80 00       	mov    $0x803432,%ebx
  8000c0:	ba 15 00 00 00       	mov    $0x15,%edx
  8000c5:	89 c7                	mov    %eax,%edi
  8000c7:	89 de                	mov    %ebx,%esi
  8000c9:	89 d1                	mov    %edx,%ecx
  8000cb:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
	char _flightBooked1Arr[] = "flightBooked1Arr";
  8000cd:	8d 85 5d ff ff ff    	lea    -0xa3(%ebp),%eax
  8000d3:	bb 47 34 80 00       	mov    $0x803447,%ebx
  8000d8:	ba 11 00 00 00       	mov    $0x11,%edx
  8000dd:	89 c7                	mov    %eax,%edi
  8000df:	89 de                	mov    %ebx,%esi
  8000e1:	89 d1                	mov    %edx,%ecx
  8000e3:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
	char _flightBooked2Arr[] = "flightBooked2Arr";
  8000e5:	8d 85 4c ff ff ff    	lea    -0xb4(%ebp),%eax
  8000eb:	bb 58 34 80 00       	mov    $0x803458,%ebx
  8000f0:	ba 11 00 00 00       	mov    $0x11,%edx
  8000f5:	89 c7                	mov    %eax,%edi
  8000f7:	89 de                	mov    %ebx,%esi
  8000f9:	89 d1                	mov    %edx,%ecx
  8000fb:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
	char _cust_ready_queue[] = "cust_ready_queue";
  8000fd:	8d 85 3b ff ff ff    	lea    -0xc5(%ebp),%eax
  800103:	bb 69 34 80 00       	mov    $0x803469,%ebx
  800108:	ba 11 00 00 00       	mov    $0x11,%edx
  80010d:	89 c7                	mov    %eax,%edi
  80010f:	89 de                	mov    %ebx,%esi
  800111:	89 d1                	mov    %edx,%ecx
  800113:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
	char _queue_in[] = "queue_in";
  800115:	8d 85 32 ff ff ff    	lea    -0xce(%ebp),%eax
  80011b:	bb 7a 34 80 00       	mov    $0x80347a,%ebx
  800120:	ba 09 00 00 00       	mov    $0x9,%edx
  800125:	89 c7                	mov    %eax,%edi
  800127:	89 de                	mov    %ebx,%esi
  800129:	89 d1                	mov    %edx,%ecx
  80012b:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
	char _queue_out[] = "queue_out";
  80012d:	8d 85 28 ff ff ff    	lea    -0xd8(%ebp),%eax
  800133:	bb 83 34 80 00       	mov    $0x803483,%ebx
  800138:	ba 0a 00 00 00       	mov    $0xa,%edx
  80013d:	89 c7                	mov    %eax,%edi
  80013f:	89 de                	mov    %ebx,%esi
  800141:	89 d1                	mov    %edx,%ecx
  800143:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)

	char _cust_ready[] = "cust_ready";
  800145:	8d 85 1d ff ff ff    	lea    -0xe3(%ebp),%eax
  80014b:	bb 8d 34 80 00       	mov    $0x80348d,%ebx
  800150:	ba 0b 00 00 00       	mov    $0xb,%edx
  800155:	89 c7                	mov    %eax,%edi
  800157:	89 de                	mov    %ebx,%esi
  800159:	89 d1                	mov    %edx,%ecx
  80015b:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
	char _custQueueCS[] = "custQueueCS";
  80015d:	8d 85 11 ff ff ff    	lea    -0xef(%ebp),%eax
  800163:	bb 98 34 80 00       	mov    $0x803498,%ebx
  800168:	ba 03 00 00 00       	mov    $0x3,%edx
  80016d:	89 c7                	mov    %eax,%edi
  80016f:	89 de                	mov    %ebx,%esi
  800171:	89 d1                	mov    %edx,%ecx
  800173:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
	char _flight1CS[] = "flight1CS";
  800175:	8d 85 07 ff ff ff    	lea    -0xf9(%ebp),%eax
  80017b:	bb a4 34 80 00       	mov    $0x8034a4,%ebx
  800180:	ba 0a 00 00 00       	mov    $0xa,%edx
  800185:	89 c7                	mov    %eax,%edi
  800187:	89 de                	mov    %ebx,%esi
  800189:	89 d1                	mov    %edx,%ecx
  80018b:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
	char _flight2CS[] = "flight2CS";
  80018d:	8d 85 fd fe ff ff    	lea    -0x103(%ebp),%eax
  800193:	bb ae 34 80 00       	mov    $0x8034ae,%ebx
  800198:	ba 0a 00 00 00       	mov    $0xa,%edx
  80019d:	89 c7                	mov    %eax,%edi
  80019f:	89 de                	mov    %ebx,%esi
  8001a1:	89 d1                	mov    %edx,%ecx
  8001a3:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)

	char _clerk[] = "clerk";
  8001a5:	c7 85 f7 fe ff ff 63 	movl   $0x72656c63,-0x109(%ebp)
  8001ac:	6c 65 72 
  8001af:	66 c7 85 fb fe ff ff 	movw   $0x6b,-0x105(%ebp)
  8001b6:	6b 00 
	char _custCounterCS[] = "custCounterCS";
  8001b8:	8d 85 e9 fe ff ff    	lea    -0x117(%ebp),%eax
  8001be:	bb b8 34 80 00       	mov    $0x8034b8,%ebx
  8001c3:	ba 0e 00 00 00       	mov    $0xe,%edx
  8001c8:	89 c7                	mov    %eax,%edi
  8001ca:	89 de                	mov    %ebx,%esi
  8001cc:	89 d1                	mov    %edx,%ecx
  8001ce:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
	char _custTerminated[] = "custTerminated";
  8001d0:	8d 85 da fe ff ff    	lea    -0x126(%ebp),%eax
  8001d6:	bb c6 34 80 00       	mov    $0x8034c6,%ebx
  8001db:	ba 0f 00 00 00       	mov    $0xf,%edx
  8001e0:	89 c7                	mov    %eax,%edi
  8001e2:	89 de                	mov    %ebx,%esi
  8001e4:	89 d1                	mov    %edx,%ecx
  8001e6:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)

	char _taircl[] = "taircl";
  8001e8:	8d 85 d3 fe ff ff    	lea    -0x12d(%ebp),%eax
  8001ee:	bb d5 34 80 00       	mov    $0x8034d5,%ebx
  8001f3:	ba 07 00 00 00       	mov    $0x7,%edx
  8001f8:	89 c7                	mov    %eax,%edi
  8001fa:	89 de                	mov    %ebx,%esi
  8001fc:	89 d1                	mov    %edx,%ecx
  8001fe:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
	char _taircu[] = "taircu";
  800200:	8d 85 cc fe ff ff    	lea    -0x134(%ebp),%eax
  800206:	bb dc 34 80 00       	mov    $0x8034dc,%ebx
  80020b:	ba 07 00 00 00       	mov    $0x7,%edx
  800210:	89 c7                	mov    %eax,%edi
  800212:	89 de                	mov    %ebx,%esi
  800214:	89 d1                	mov    %edx,%ecx
  800216:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)

	// Get the shared variables from the main program ***********************************

	struct Customer * customers = sget(parentenvID, _customers);
  800218:	83 ec 08             	sub    $0x8,%esp
  80021b:	8d 45 c2             	lea    -0x3e(%ebp),%eax
  80021e:	50                   	push   %eax
  80021f:	ff 75 e4             	pushl  -0x1c(%ebp)
  800222:	e8 85 15 00 00       	call   8017ac <sget>
  800227:	83 c4 10             	add    $0x10,%esp
  80022a:	89 45 e0             	mov    %eax,-0x20(%ebp)

	int* custCounter = sget(parentenvID, _custCounter);
  80022d:	83 ec 08             	sub    $0x8,%esp
  800230:	8d 45 b6             	lea    -0x4a(%ebp),%eax
  800233:	50                   	push   %eax
  800234:	ff 75 e4             	pushl  -0x1c(%ebp)
  800237:	e8 70 15 00 00       	call   8017ac <sget>
  80023c:	83 c4 10             	add    $0x10,%esp
  80023f:	89 45 dc             	mov    %eax,-0x24(%ebp)

	int* cust_ready_queue = sget(parentenvID, _cust_ready_queue);
  800242:	83 ec 08             	sub    $0x8,%esp
  800245:	8d 85 3b ff ff ff    	lea    -0xc5(%ebp),%eax
  80024b:	50                   	push   %eax
  80024c:	ff 75 e4             	pushl  -0x1c(%ebp)
  80024f:	e8 58 15 00 00       	call   8017ac <sget>
  800254:	83 c4 10             	add    $0x10,%esp
  800257:	89 45 d8             	mov    %eax,-0x28(%ebp)

	int* queue_in = sget(parentenvID, _queue_in);
  80025a:	83 ec 08             	sub    $0x8,%esp
  80025d:	8d 85 32 ff ff ff    	lea    -0xce(%ebp),%eax
  800263:	50                   	push   %eax
  800264:	ff 75 e4             	pushl  -0x1c(%ebp)
  800267:	e8 40 15 00 00       	call   8017ac <sget>
  80026c:	83 c4 10             	add    $0x10,%esp
  80026f:	89 45 d4             	mov    %eax,-0x2c(%ebp)

	// *********************************************************************************

	int custId, flightType;
	sys_waitSemaphore(parentenvID, _custCounterCS);
  800272:	83 ec 08             	sub    $0x8,%esp
  800275:	8d 85 e9 fe ff ff    	lea    -0x117(%ebp),%eax
  80027b:	50                   	push   %eax
  80027c:	ff 75 e4             	pushl  -0x1c(%ebp)
  80027f:	e8 d6 18 00 00       	call   801b5a <sys_waitSemaphore>
  800284:	83 c4 10             	add    $0x10,%esp
	{
		custId = *custCounter;
  800287:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80028a:	8b 00                	mov    (%eax),%eax
  80028c:	89 45 d0             	mov    %eax,-0x30(%ebp)
		//cprintf("custCounter= %d\n", *custCounter);
		*custCounter = *custCounter +1;
  80028f:	8b 45 dc             	mov    -0x24(%ebp),%eax
  800292:	8b 00                	mov    (%eax),%eax
  800294:	8d 50 01             	lea    0x1(%eax),%edx
  800297:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80029a:	89 10                	mov    %edx,(%eax)
	}
	sys_signalSemaphore(parentenvID, _custCounterCS);
  80029c:	83 ec 08             	sub    $0x8,%esp
  80029f:	8d 85 e9 fe ff ff    	lea    -0x117(%ebp),%eax
  8002a5:	50                   	push   %eax
  8002a6:	ff 75 e4             	pushl  -0x1c(%ebp)
  8002a9:	e8 ca 18 00 00       	call   801b78 <sys_signalSemaphore>
  8002ae:	83 c4 10             	add    $0x10,%esp

	//wait on one of the clerks
	sys_waitSemaphore(parentenvID, _clerk);
  8002b1:	83 ec 08             	sub    $0x8,%esp
  8002b4:	8d 85 f7 fe ff ff    	lea    -0x109(%ebp),%eax
  8002ba:	50                   	push   %eax
  8002bb:	ff 75 e4             	pushl  -0x1c(%ebp)
  8002be:	e8 97 18 00 00       	call   801b5a <sys_waitSemaphore>
  8002c3:	83 c4 10             	add    $0x10,%esp

	//enqueue the request
	flightType = customers[custId].flightType;
  8002c6:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8002c9:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
  8002d0:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8002d3:	01 d0                	add    %edx,%eax
  8002d5:	8b 00                	mov    (%eax),%eax
  8002d7:	89 45 cc             	mov    %eax,-0x34(%ebp)
	sys_waitSemaphore(parentenvID, _custQueueCS);
  8002da:	83 ec 08             	sub    $0x8,%esp
  8002dd:	8d 85 11 ff ff ff    	lea    -0xef(%ebp),%eax
  8002e3:	50                   	push   %eax
  8002e4:	ff 75 e4             	pushl  -0x1c(%ebp)
  8002e7:	e8 6e 18 00 00       	call   801b5a <sys_waitSemaphore>
  8002ec:	83 c4 10             	add    $0x10,%esp
	{
		cust_ready_queue[*queue_in] = custId;
  8002ef:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8002f2:	8b 00                	mov    (%eax),%eax
  8002f4:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8002fb:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8002fe:	01 c2                	add    %eax,%edx
  800300:	8b 45 d0             	mov    -0x30(%ebp),%eax
  800303:	89 02                	mov    %eax,(%edx)
		*queue_in = *queue_in +1;
  800305:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  800308:	8b 00                	mov    (%eax),%eax
  80030a:	8d 50 01             	lea    0x1(%eax),%edx
  80030d:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  800310:	89 10                	mov    %edx,(%eax)
	}
	sys_signalSemaphore(parentenvID, _custQueueCS);
  800312:	83 ec 08             	sub    $0x8,%esp
  800315:	8d 85 11 ff ff ff    	lea    -0xef(%ebp),%eax
  80031b:	50                   	push   %eax
  80031c:	ff 75 e4             	pushl  -0x1c(%ebp)
  80031f:	e8 54 18 00 00       	call   801b78 <sys_signalSemaphore>
  800324:	83 c4 10             	add    $0x10,%esp

	//signal ready
	sys_signalSemaphore(parentenvID, _cust_ready);
  800327:	83 ec 08             	sub    $0x8,%esp
  80032a:	8d 85 1d ff ff ff    	lea    -0xe3(%ebp),%eax
  800330:	50                   	push   %eax
  800331:	ff 75 e4             	pushl  -0x1c(%ebp)
  800334:	e8 3f 18 00 00       	call   801b78 <sys_signalSemaphore>
  800339:	83 c4 10             	add    $0x10,%esp

	//wait on finished
	char prefix[30]="cust_finished";
  80033c:	8d 85 ae fe ff ff    	lea    -0x152(%ebp),%eax
  800342:	bb e3 34 80 00       	mov    $0x8034e3,%ebx
  800347:	ba 0e 00 00 00       	mov    $0xe,%edx
  80034c:	89 c7                	mov    %eax,%edi
  80034e:	89 de                	mov    %ebx,%esi
  800350:	89 d1                	mov    %edx,%ecx
  800352:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
  800354:	8d 95 bc fe ff ff    	lea    -0x144(%ebp),%edx
  80035a:	b9 04 00 00 00       	mov    $0x4,%ecx
  80035f:	b8 00 00 00 00       	mov    $0x0,%eax
  800364:	89 d7                	mov    %edx,%edi
  800366:	f3 ab                	rep stos %eax,%es:(%edi)
	char id[5]; char sname[50];
	ltostr(custId, id);
  800368:	83 ec 08             	sub    $0x8,%esp
  80036b:	8d 85 a9 fe ff ff    	lea    -0x157(%ebp),%eax
  800371:	50                   	push   %eax
  800372:	ff 75 d0             	pushl  -0x30(%ebp)
  800375:	e8 d0 0d 00 00       	call   80114a <ltostr>
  80037a:	83 c4 10             	add    $0x10,%esp
	strcconcat(prefix, id, sname);
  80037d:	83 ec 04             	sub    $0x4,%esp
  800380:	8d 85 77 fe ff ff    	lea    -0x189(%ebp),%eax
  800386:	50                   	push   %eax
  800387:	8d 85 a9 fe ff ff    	lea    -0x157(%ebp),%eax
  80038d:	50                   	push   %eax
  80038e:	8d 85 ae fe ff ff    	lea    -0x152(%ebp),%eax
  800394:	50                   	push   %eax
  800395:	e8 a8 0e 00 00       	call   801242 <strcconcat>
  80039a:	83 c4 10             	add    $0x10,%esp
	sys_waitSemaphore(parentenvID, sname);
  80039d:	83 ec 08             	sub    $0x8,%esp
  8003a0:	8d 85 77 fe ff ff    	lea    -0x189(%ebp),%eax
  8003a6:	50                   	push   %eax
  8003a7:	ff 75 e4             	pushl  -0x1c(%ebp)
  8003aa:	e8 ab 17 00 00       	call   801b5a <sys_waitSemaphore>
  8003af:	83 c4 10             	add    $0x10,%esp

	//print the customer status
	if(customers[custId].booked == 1)
  8003b2:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8003b5:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
  8003bc:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8003bf:	01 d0                	add    %edx,%eax
  8003c1:	8b 40 04             	mov    0x4(%eax),%eax
  8003c4:	83 f8 01             	cmp    $0x1,%eax
  8003c7:	75 18                	jne    8003e1 <_main+0x3a9>
	{
		cprintf("cust %d: finished (BOOKED flight %d) \n", custId, flightType);
  8003c9:	83 ec 04             	sub    $0x4,%esp
  8003cc:	ff 75 cc             	pushl  -0x34(%ebp)
  8003cf:	ff 75 d0             	pushl  -0x30(%ebp)
  8003d2:	68 a0 33 80 00       	push   $0x8033a0
  8003d7:	e8 46 02 00 00       	call   800622 <cprintf>
  8003dc:	83 c4 10             	add    $0x10,%esp
  8003df:	eb 13                	jmp    8003f4 <_main+0x3bc>
	}
	else
	{
		cprintf("cust %d: finished (NOT BOOKED) \n", custId);
  8003e1:	83 ec 08             	sub    $0x8,%esp
  8003e4:	ff 75 d0             	pushl  -0x30(%ebp)
  8003e7:	68 c8 33 80 00       	push   $0x8033c8
  8003ec:	e8 31 02 00 00       	call   800622 <cprintf>
  8003f1:	83 c4 10             	add    $0x10,%esp
	}

	//customer is terminated
	sys_signalSemaphore(parentenvID, _custTerminated);
  8003f4:	83 ec 08             	sub    $0x8,%esp
  8003f7:	8d 85 da fe ff ff    	lea    -0x126(%ebp),%eax
  8003fd:	50                   	push   %eax
  8003fe:	ff 75 e4             	pushl  -0x1c(%ebp)
  800401:	e8 72 17 00 00       	call   801b78 <sys_signalSemaphore>
  800406:	83 c4 10             	add    $0x10,%esp

	return;
  800409:	90                   	nop
}
  80040a:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80040d:	5b                   	pop    %ebx
  80040e:	5e                   	pop    %esi
  80040f:	5f                   	pop    %edi
  800410:	5d                   	pop    %ebp
  800411:	c3                   	ret    

00800412 <libmain>:
volatile struct Env *myEnv = NULL;
volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";

void
libmain(int argc, char **argv)
{
  800412:	55                   	push   %ebp
  800413:	89 e5                	mov    %esp,%ebp
  800415:	83 ec 18             	sub    $0x18,%esp
	int envIndex = sys_getenvindex();
  800418:	e8 83 18 00 00       	call   801ca0 <sys_getenvindex>
  80041d:	89 45 f4             	mov    %eax,-0xc(%ebp)
	myEnv = &(envs[envIndex]);
  800420:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800423:	89 d0                	mov    %edx,%eax
  800425:	c1 e0 03             	shl    $0x3,%eax
  800428:	01 d0                	add    %edx,%eax
  80042a:	01 c0                	add    %eax,%eax
  80042c:	01 d0                	add    %edx,%eax
  80042e:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800435:	01 d0                	add    %edx,%eax
  800437:	c1 e0 04             	shl    $0x4,%eax
  80043a:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  80043f:	a3 20 40 80 00       	mov    %eax,0x804020

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  800444:	a1 20 40 80 00       	mov    0x804020,%eax
  800449:	8a 80 5c 05 00 00    	mov    0x55c(%eax),%al
  80044f:	84 c0                	test   %al,%al
  800451:	74 0f                	je     800462 <libmain+0x50>
		binaryname = myEnv->prog_name;
  800453:	a1 20 40 80 00       	mov    0x804020,%eax
  800458:	05 5c 05 00 00       	add    $0x55c,%eax
  80045d:	a3 00 40 80 00       	mov    %eax,0x804000

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  800462:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800466:	7e 0a                	jle    800472 <libmain+0x60>
		binaryname = argv[0];
  800468:	8b 45 0c             	mov    0xc(%ebp),%eax
  80046b:	8b 00                	mov    (%eax),%eax
  80046d:	a3 00 40 80 00       	mov    %eax,0x804000

	// call user main routine
	_main(argc, argv);
  800472:	83 ec 08             	sub    $0x8,%esp
  800475:	ff 75 0c             	pushl  0xc(%ebp)
  800478:	ff 75 08             	pushl  0x8(%ebp)
  80047b:	e8 b8 fb ff ff       	call   800038 <_main>
  800480:	83 c4 10             	add    $0x10,%esp



	sys_disable_interrupt();
  800483:	e8 25 16 00 00       	call   801aad <sys_disable_interrupt>
	cprintf("**************************************\n");
  800488:	83 ec 0c             	sub    $0xc,%esp
  80048b:	68 1c 35 80 00       	push   $0x80351c
  800490:	e8 8d 01 00 00       	call   800622 <cprintf>
  800495:	83 c4 10             	add    $0x10,%esp
	cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  800498:	a1 20 40 80 00       	mov    0x804020,%eax
  80049d:	8b 90 44 05 00 00    	mov    0x544(%eax),%edx
  8004a3:	a1 20 40 80 00       	mov    0x804020,%eax
  8004a8:	8b 80 34 05 00 00    	mov    0x534(%eax),%eax
  8004ae:	83 ec 04             	sub    $0x4,%esp
  8004b1:	52                   	push   %edx
  8004b2:	50                   	push   %eax
  8004b3:	68 44 35 80 00       	push   $0x803544
  8004b8:	e8 65 01 00 00       	call   800622 <cprintf>
  8004bd:	83 c4 10             	add    $0x10,%esp
	cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  8004c0:	a1 20 40 80 00       	mov    0x804020,%eax
  8004c5:	8b 88 54 05 00 00    	mov    0x554(%eax),%ecx
  8004cb:	a1 20 40 80 00       	mov    0x804020,%eax
  8004d0:	8b 90 50 05 00 00    	mov    0x550(%eax),%edx
  8004d6:	a1 20 40 80 00       	mov    0x804020,%eax
  8004db:	8b 80 4c 05 00 00    	mov    0x54c(%eax),%eax
  8004e1:	51                   	push   %ecx
  8004e2:	52                   	push   %edx
  8004e3:	50                   	push   %eax
  8004e4:	68 6c 35 80 00       	push   $0x80356c
  8004e9:	e8 34 01 00 00       	call   800622 <cprintf>
  8004ee:	83 c4 10             	add    $0x10,%esp
	//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
	cprintf("Num of clocks = %d\n", myEnv->nClocks);
  8004f1:	a1 20 40 80 00       	mov    0x804020,%eax
  8004f6:	8b 80 a4 05 00 00    	mov    0x5a4(%eax),%eax
  8004fc:	83 ec 08             	sub    $0x8,%esp
  8004ff:	50                   	push   %eax
  800500:	68 c4 35 80 00       	push   $0x8035c4
  800505:	e8 18 01 00 00       	call   800622 <cprintf>
  80050a:	83 c4 10             	add    $0x10,%esp
	cprintf("**************************************\n");
  80050d:	83 ec 0c             	sub    $0xc,%esp
  800510:	68 1c 35 80 00       	push   $0x80351c
  800515:	e8 08 01 00 00       	call   800622 <cprintf>
  80051a:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  80051d:	e8 a5 15 00 00       	call   801ac7 <sys_enable_interrupt>

	// exit gracefully
	exit();
  800522:	e8 19 00 00 00       	call   800540 <exit>
}
  800527:	90                   	nop
  800528:	c9                   	leave  
  800529:	c3                   	ret    

0080052a <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  80052a:	55                   	push   %ebp
  80052b:	89 e5                	mov    %esp,%ebp
  80052d:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  800530:	83 ec 0c             	sub    $0xc,%esp
  800533:	6a 00                	push   $0x0
  800535:	e8 32 17 00 00       	call   801c6c <sys_destroy_env>
  80053a:	83 c4 10             	add    $0x10,%esp
}
  80053d:	90                   	nop
  80053e:	c9                   	leave  
  80053f:	c3                   	ret    

00800540 <exit>:

void
exit(void)
{
  800540:	55                   	push   %ebp
  800541:	89 e5                	mov    %esp,%ebp
  800543:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  800546:	e8 87 17 00 00       	call   801cd2 <sys_exit_env>
}
  80054b:	90                   	nop
  80054c:	c9                   	leave  
  80054d:	c3                   	ret    

0080054e <putch>:
};

//2017:
uint8 printProgName = 0;

static void putch(int ch, struct printbuf *b) {
  80054e:	55                   	push   %ebp
  80054f:	89 e5                	mov    %esp,%ebp
  800551:	83 ec 08             	sub    $0x8,%esp
	b->buf[b->idx++] = ch;
  800554:	8b 45 0c             	mov    0xc(%ebp),%eax
  800557:	8b 00                	mov    (%eax),%eax
  800559:	8d 48 01             	lea    0x1(%eax),%ecx
  80055c:	8b 55 0c             	mov    0xc(%ebp),%edx
  80055f:	89 0a                	mov    %ecx,(%edx)
  800561:	8b 55 08             	mov    0x8(%ebp),%edx
  800564:	88 d1                	mov    %dl,%cl
  800566:	8b 55 0c             	mov    0xc(%ebp),%edx
  800569:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  80056d:	8b 45 0c             	mov    0xc(%ebp),%eax
  800570:	8b 00                	mov    (%eax),%eax
  800572:	3d ff 00 00 00       	cmp    $0xff,%eax
  800577:	75 2c                	jne    8005a5 <putch+0x57>
		sys_cputs(b->buf, b->idx, printProgName);
  800579:	a0 24 40 80 00       	mov    0x804024,%al
  80057e:	0f b6 c0             	movzbl %al,%eax
  800581:	8b 55 0c             	mov    0xc(%ebp),%edx
  800584:	8b 12                	mov    (%edx),%edx
  800586:	89 d1                	mov    %edx,%ecx
  800588:	8b 55 0c             	mov    0xc(%ebp),%edx
  80058b:	83 c2 08             	add    $0x8,%edx
  80058e:	83 ec 04             	sub    $0x4,%esp
  800591:	50                   	push   %eax
  800592:	51                   	push   %ecx
  800593:	52                   	push   %edx
  800594:	e8 66 13 00 00       	call   8018ff <sys_cputs>
  800599:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  80059c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80059f:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  8005a5:	8b 45 0c             	mov    0xc(%ebp),%eax
  8005a8:	8b 40 04             	mov    0x4(%eax),%eax
  8005ab:	8d 50 01             	lea    0x1(%eax),%edx
  8005ae:	8b 45 0c             	mov    0xc(%ebp),%eax
  8005b1:	89 50 04             	mov    %edx,0x4(%eax)
}
  8005b4:	90                   	nop
  8005b5:	c9                   	leave  
  8005b6:	c3                   	ret    

008005b7 <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  8005b7:	55                   	push   %ebp
  8005b8:	89 e5                	mov    %esp,%ebp
  8005ba:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  8005c0:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  8005c7:	00 00 00 
	b.cnt = 0;
  8005ca:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  8005d1:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  8005d4:	ff 75 0c             	pushl  0xc(%ebp)
  8005d7:	ff 75 08             	pushl  0x8(%ebp)
  8005da:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  8005e0:	50                   	push   %eax
  8005e1:	68 4e 05 80 00       	push   $0x80054e
  8005e6:	e8 11 02 00 00       	call   8007fc <vprintfmt>
  8005eb:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName);
  8005ee:	a0 24 40 80 00       	mov    0x804024,%al
  8005f3:	0f b6 c0             	movzbl %al,%eax
  8005f6:	8b 95 f0 fe ff ff    	mov    -0x110(%ebp),%edx
  8005fc:	83 ec 04             	sub    $0x4,%esp
  8005ff:	50                   	push   %eax
  800600:	52                   	push   %edx
  800601:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800607:	83 c0 08             	add    $0x8,%eax
  80060a:	50                   	push   %eax
  80060b:	e8 ef 12 00 00       	call   8018ff <sys_cputs>
  800610:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  800613:	c6 05 24 40 80 00 00 	movb   $0x0,0x804024
	return b.cnt;
  80061a:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  800620:	c9                   	leave  
  800621:	c3                   	ret    

00800622 <cprintf>:

int cprintf(const char *fmt, ...) {
  800622:	55                   	push   %ebp
  800623:	89 e5                	mov    %esp,%ebp
  800625:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  800628:	c6 05 24 40 80 00 01 	movb   $0x1,0x804024
	va_start(ap, fmt);
  80062f:	8d 45 0c             	lea    0xc(%ebp),%eax
  800632:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800635:	8b 45 08             	mov    0x8(%ebp),%eax
  800638:	83 ec 08             	sub    $0x8,%esp
  80063b:	ff 75 f4             	pushl  -0xc(%ebp)
  80063e:	50                   	push   %eax
  80063f:	e8 73 ff ff ff       	call   8005b7 <vcprintf>
  800644:	83 c4 10             	add    $0x10,%esp
  800647:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  80064a:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  80064d:	c9                   	leave  
  80064e:	c3                   	ret    

0080064f <atomic_cprintf>:

int atomic_cprintf(const char *fmt, ...) {
  80064f:	55                   	push   %ebp
  800650:	89 e5                	mov    %esp,%ebp
  800652:	83 ec 18             	sub    $0x18,%esp
	sys_disable_interrupt();
  800655:	e8 53 14 00 00       	call   801aad <sys_disable_interrupt>
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  80065a:	8d 45 0c             	lea    0xc(%ebp),%eax
  80065d:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800660:	8b 45 08             	mov    0x8(%ebp),%eax
  800663:	83 ec 08             	sub    $0x8,%esp
  800666:	ff 75 f4             	pushl  -0xc(%ebp)
  800669:	50                   	push   %eax
  80066a:	e8 48 ff ff ff       	call   8005b7 <vcprintf>
  80066f:	83 c4 10             	add    $0x10,%esp
  800672:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	sys_enable_interrupt();
  800675:	e8 4d 14 00 00       	call   801ac7 <sys_enable_interrupt>
	return cnt;
  80067a:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  80067d:	c9                   	leave  
  80067e:	c3                   	ret    

0080067f <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  80067f:	55                   	push   %ebp
  800680:	89 e5                	mov    %esp,%ebp
  800682:	53                   	push   %ebx
  800683:	83 ec 14             	sub    $0x14,%esp
  800686:	8b 45 10             	mov    0x10(%ebp),%eax
  800689:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80068c:	8b 45 14             	mov    0x14(%ebp),%eax
  80068f:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800692:	8b 45 18             	mov    0x18(%ebp),%eax
  800695:	ba 00 00 00 00       	mov    $0x0,%edx
  80069a:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  80069d:	77 55                	ja     8006f4 <printnum+0x75>
  80069f:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  8006a2:	72 05                	jb     8006a9 <printnum+0x2a>
  8006a4:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8006a7:	77 4b                	ja     8006f4 <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  8006a9:	8b 45 1c             	mov    0x1c(%ebp),%eax
  8006ac:	8d 58 ff             	lea    -0x1(%eax),%ebx
  8006af:	8b 45 18             	mov    0x18(%ebp),%eax
  8006b2:	ba 00 00 00 00       	mov    $0x0,%edx
  8006b7:	52                   	push   %edx
  8006b8:	50                   	push   %eax
  8006b9:	ff 75 f4             	pushl  -0xc(%ebp)
  8006bc:	ff 75 f0             	pushl  -0x10(%ebp)
  8006bf:	e8 64 2a 00 00       	call   803128 <__udivdi3>
  8006c4:	83 c4 10             	add    $0x10,%esp
  8006c7:	83 ec 04             	sub    $0x4,%esp
  8006ca:	ff 75 20             	pushl  0x20(%ebp)
  8006cd:	53                   	push   %ebx
  8006ce:	ff 75 18             	pushl  0x18(%ebp)
  8006d1:	52                   	push   %edx
  8006d2:	50                   	push   %eax
  8006d3:	ff 75 0c             	pushl  0xc(%ebp)
  8006d6:	ff 75 08             	pushl  0x8(%ebp)
  8006d9:	e8 a1 ff ff ff       	call   80067f <printnum>
  8006de:	83 c4 20             	add    $0x20,%esp
  8006e1:	eb 1a                	jmp    8006fd <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  8006e3:	83 ec 08             	sub    $0x8,%esp
  8006e6:	ff 75 0c             	pushl  0xc(%ebp)
  8006e9:	ff 75 20             	pushl  0x20(%ebp)
  8006ec:	8b 45 08             	mov    0x8(%ebp),%eax
  8006ef:	ff d0                	call   *%eax
  8006f1:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  8006f4:	ff 4d 1c             	decl   0x1c(%ebp)
  8006f7:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  8006fb:	7f e6                	jg     8006e3 <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  8006fd:	8b 4d 18             	mov    0x18(%ebp),%ecx
  800700:	bb 00 00 00 00       	mov    $0x0,%ebx
  800705:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800708:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80070b:	53                   	push   %ebx
  80070c:	51                   	push   %ecx
  80070d:	52                   	push   %edx
  80070e:	50                   	push   %eax
  80070f:	e8 24 2b 00 00       	call   803238 <__umoddi3>
  800714:	83 c4 10             	add    $0x10,%esp
  800717:	05 f4 37 80 00       	add    $0x8037f4,%eax
  80071c:	8a 00                	mov    (%eax),%al
  80071e:	0f be c0             	movsbl %al,%eax
  800721:	83 ec 08             	sub    $0x8,%esp
  800724:	ff 75 0c             	pushl  0xc(%ebp)
  800727:	50                   	push   %eax
  800728:	8b 45 08             	mov    0x8(%ebp),%eax
  80072b:	ff d0                	call   *%eax
  80072d:	83 c4 10             	add    $0x10,%esp
}
  800730:	90                   	nop
  800731:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800734:	c9                   	leave  
  800735:	c3                   	ret    

00800736 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  800736:	55                   	push   %ebp
  800737:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800739:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  80073d:	7e 1c                	jle    80075b <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  80073f:	8b 45 08             	mov    0x8(%ebp),%eax
  800742:	8b 00                	mov    (%eax),%eax
  800744:	8d 50 08             	lea    0x8(%eax),%edx
  800747:	8b 45 08             	mov    0x8(%ebp),%eax
  80074a:	89 10                	mov    %edx,(%eax)
  80074c:	8b 45 08             	mov    0x8(%ebp),%eax
  80074f:	8b 00                	mov    (%eax),%eax
  800751:	83 e8 08             	sub    $0x8,%eax
  800754:	8b 50 04             	mov    0x4(%eax),%edx
  800757:	8b 00                	mov    (%eax),%eax
  800759:	eb 40                	jmp    80079b <getuint+0x65>
	else if (lflag)
  80075b:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80075f:	74 1e                	je     80077f <getuint+0x49>
		return va_arg(*ap, unsigned long);
  800761:	8b 45 08             	mov    0x8(%ebp),%eax
  800764:	8b 00                	mov    (%eax),%eax
  800766:	8d 50 04             	lea    0x4(%eax),%edx
  800769:	8b 45 08             	mov    0x8(%ebp),%eax
  80076c:	89 10                	mov    %edx,(%eax)
  80076e:	8b 45 08             	mov    0x8(%ebp),%eax
  800771:	8b 00                	mov    (%eax),%eax
  800773:	83 e8 04             	sub    $0x4,%eax
  800776:	8b 00                	mov    (%eax),%eax
  800778:	ba 00 00 00 00       	mov    $0x0,%edx
  80077d:	eb 1c                	jmp    80079b <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  80077f:	8b 45 08             	mov    0x8(%ebp),%eax
  800782:	8b 00                	mov    (%eax),%eax
  800784:	8d 50 04             	lea    0x4(%eax),%edx
  800787:	8b 45 08             	mov    0x8(%ebp),%eax
  80078a:	89 10                	mov    %edx,(%eax)
  80078c:	8b 45 08             	mov    0x8(%ebp),%eax
  80078f:	8b 00                	mov    (%eax),%eax
  800791:	83 e8 04             	sub    $0x4,%eax
  800794:	8b 00                	mov    (%eax),%eax
  800796:	ba 00 00 00 00       	mov    $0x0,%edx
}
  80079b:	5d                   	pop    %ebp
  80079c:	c3                   	ret    

0080079d <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  80079d:	55                   	push   %ebp
  80079e:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  8007a0:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  8007a4:	7e 1c                	jle    8007c2 <getint+0x25>
		return va_arg(*ap, long long);
  8007a6:	8b 45 08             	mov    0x8(%ebp),%eax
  8007a9:	8b 00                	mov    (%eax),%eax
  8007ab:	8d 50 08             	lea    0x8(%eax),%edx
  8007ae:	8b 45 08             	mov    0x8(%ebp),%eax
  8007b1:	89 10                	mov    %edx,(%eax)
  8007b3:	8b 45 08             	mov    0x8(%ebp),%eax
  8007b6:	8b 00                	mov    (%eax),%eax
  8007b8:	83 e8 08             	sub    $0x8,%eax
  8007bb:	8b 50 04             	mov    0x4(%eax),%edx
  8007be:	8b 00                	mov    (%eax),%eax
  8007c0:	eb 38                	jmp    8007fa <getint+0x5d>
	else if (lflag)
  8007c2:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8007c6:	74 1a                	je     8007e2 <getint+0x45>
		return va_arg(*ap, long);
  8007c8:	8b 45 08             	mov    0x8(%ebp),%eax
  8007cb:	8b 00                	mov    (%eax),%eax
  8007cd:	8d 50 04             	lea    0x4(%eax),%edx
  8007d0:	8b 45 08             	mov    0x8(%ebp),%eax
  8007d3:	89 10                	mov    %edx,(%eax)
  8007d5:	8b 45 08             	mov    0x8(%ebp),%eax
  8007d8:	8b 00                	mov    (%eax),%eax
  8007da:	83 e8 04             	sub    $0x4,%eax
  8007dd:	8b 00                	mov    (%eax),%eax
  8007df:	99                   	cltd   
  8007e0:	eb 18                	jmp    8007fa <getint+0x5d>
	else
		return va_arg(*ap, int);
  8007e2:	8b 45 08             	mov    0x8(%ebp),%eax
  8007e5:	8b 00                	mov    (%eax),%eax
  8007e7:	8d 50 04             	lea    0x4(%eax),%edx
  8007ea:	8b 45 08             	mov    0x8(%ebp),%eax
  8007ed:	89 10                	mov    %edx,(%eax)
  8007ef:	8b 45 08             	mov    0x8(%ebp),%eax
  8007f2:	8b 00                	mov    (%eax),%eax
  8007f4:	83 e8 04             	sub    $0x4,%eax
  8007f7:	8b 00                	mov    (%eax),%eax
  8007f9:	99                   	cltd   
}
  8007fa:	5d                   	pop    %ebp
  8007fb:	c3                   	ret    

008007fc <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  8007fc:	55                   	push   %ebp
  8007fd:	89 e5                	mov    %esp,%ebp
  8007ff:	56                   	push   %esi
  800800:	53                   	push   %ebx
  800801:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800804:	eb 17                	jmp    80081d <vprintfmt+0x21>
			if (ch == '\0')
  800806:	85 db                	test   %ebx,%ebx
  800808:	0f 84 af 03 00 00    	je     800bbd <vprintfmt+0x3c1>
				return;
			putch(ch, putdat);
  80080e:	83 ec 08             	sub    $0x8,%esp
  800811:	ff 75 0c             	pushl  0xc(%ebp)
  800814:	53                   	push   %ebx
  800815:	8b 45 08             	mov    0x8(%ebp),%eax
  800818:	ff d0                	call   *%eax
  80081a:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  80081d:	8b 45 10             	mov    0x10(%ebp),%eax
  800820:	8d 50 01             	lea    0x1(%eax),%edx
  800823:	89 55 10             	mov    %edx,0x10(%ebp)
  800826:	8a 00                	mov    (%eax),%al
  800828:	0f b6 d8             	movzbl %al,%ebx
  80082b:	83 fb 25             	cmp    $0x25,%ebx
  80082e:	75 d6                	jne    800806 <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  800830:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  800834:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  80083b:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  800842:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  800849:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800850:	8b 45 10             	mov    0x10(%ebp),%eax
  800853:	8d 50 01             	lea    0x1(%eax),%edx
  800856:	89 55 10             	mov    %edx,0x10(%ebp)
  800859:	8a 00                	mov    (%eax),%al
  80085b:	0f b6 d8             	movzbl %al,%ebx
  80085e:	8d 43 dd             	lea    -0x23(%ebx),%eax
  800861:	83 f8 55             	cmp    $0x55,%eax
  800864:	0f 87 2b 03 00 00    	ja     800b95 <vprintfmt+0x399>
  80086a:	8b 04 85 18 38 80 00 	mov    0x803818(,%eax,4),%eax
  800871:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  800873:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  800877:	eb d7                	jmp    800850 <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  800879:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  80087d:	eb d1                	jmp    800850 <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  80087f:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  800886:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800889:	89 d0                	mov    %edx,%eax
  80088b:	c1 e0 02             	shl    $0x2,%eax
  80088e:	01 d0                	add    %edx,%eax
  800890:	01 c0                	add    %eax,%eax
  800892:	01 d8                	add    %ebx,%eax
  800894:	83 e8 30             	sub    $0x30,%eax
  800897:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  80089a:	8b 45 10             	mov    0x10(%ebp),%eax
  80089d:	8a 00                	mov    (%eax),%al
  80089f:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  8008a2:	83 fb 2f             	cmp    $0x2f,%ebx
  8008a5:	7e 3e                	jle    8008e5 <vprintfmt+0xe9>
  8008a7:	83 fb 39             	cmp    $0x39,%ebx
  8008aa:	7f 39                	jg     8008e5 <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8008ac:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  8008af:	eb d5                	jmp    800886 <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  8008b1:	8b 45 14             	mov    0x14(%ebp),%eax
  8008b4:	83 c0 04             	add    $0x4,%eax
  8008b7:	89 45 14             	mov    %eax,0x14(%ebp)
  8008ba:	8b 45 14             	mov    0x14(%ebp),%eax
  8008bd:	83 e8 04             	sub    $0x4,%eax
  8008c0:	8b 00                	mov    (%eax),%eax
  8008c2:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  8008c5:	eb 1f                	jmp    8008e6 <vprintfmt+0xea>

		case '.':
			if (width < 0)
  8008c7:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8008cb:	79 83                	jns    800850 <vprintfmt+0x54>
				width = 0;
  8008cd:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  8008d4:	e9 77 ff ff ff       	jmp    800850 <vprintfmt+0x54>

		case '#':
			altflag = 1;
  8008d9:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  8008e0:	e9 6b ff ff ff       	jmp    800850 <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  8008e5:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  8008e6:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8008ea:	0f 89 60 ff ff ff    	jns    800850 <vprintfmt+0x54>
				width = precision, precision = -1;
  8008f0:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8008f3:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8008f6:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  8008fd:	e9 4e ff ff ff       	jmp    800850 <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  800902:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  800905:	e9 46 ff ff ff       	jmp    800850 <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  80090a:	8b 45 14             	mov    0x14(%ebp),%eax
  80090d:	83 c0 04             	add    $0x4,%eax
  800910:	89 45 14             	mov    %eax,0x14(%ebp)
  800913:	8b 45 14             	mov    0x14(%ebp),%eax
  800916:	83 e8 04             	sub    $0x4,%eax
  800919:	8b 00                	mov    (%eax),%eax
  80091b:	83 ec 08             	sub    $0x8,%esp
  80091e:	ff 75 0c             	pushl  0xc(%ebp)
  800921:	50                   	push   %eax
  800922:	8b 45 08             	mov    0x8(%ebp),%eax
  800925:	ff d0                	call   *%eax
  800927:	83 c4 10             	add    $0x10,%esp
			break;
  80092a:	e9 89 02 00 00       	jmp    800bb8 <vprintfmt+0x3bc>

		// error message
		case 'e':
			err = va_arg(ap, int);
  80092f:	8b 45 14             	mov    0x14(%ebp),%eax
  800932:	83 c0 04             	add    $0x4,%eax
  800935:	89 45 14             	mov    %eax,0x14(%ebp)
  800938:	8b 45 14             	mov    0x14(%ebp),%eax
  80093b:	83 e8 04             	sub    $0x4,%eax
  80093e:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  800940:	85 db                	test   %ebx,%ebx
  800942:	79 02                	jns    800946 <vprintfmt+0x14a>
				err = -err;
  800944:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  800946:	83 fb 64             	cmp    $0x64,%ebx
  800949:	7f 0b                	jg     800956 <vprintfmt+0x15a>
  80094b:	8b 34 9d 60 36 80 00 	mov    0x803660(,%ebx,4),%esi
  800952:	85 f6                	test   %esi,%esi
  800954:	75 19                	jne    80096f <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  800956:	53                   	push   %ebx
  800957:	68 05 38 80 00       	push   $0x803805
  80095c:	ff 75 0c             	pushl  0xc(%ebp)
  80095f:	ff 75 08             	pushl  0x8(%ebp)
  800962:	e8 5e 02 00 00       	call   800bc5 <printfmt>
  800967:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  80096a:	e9 49 02 00 00       	jmp    800bb8 <vprintfmt+0x3bc>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  80096f:	56                   	push   %esi
  800970:	68 0e 38 80 00       	push   $0x80380e
  800975:	ff 75 0c             	pushl  0xc(%ebp)
  800978:	ff 75 08             	pushl  0x8(%ebp)
  80097b:	e8 45 02 00 00       	call   800bc5 <printfmt>
  800980:	83 c4 10             	add    $0x10,%esp
			break;
  800983:	e9 30 02 00 00       	jmp    800bb8 <vprintfmt+0x3bc>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  800988:	8b 45 14             	mov    0x14(%ebp),%eax
  80098b:	83 c0 04             	add    $0x4,%eax
  80098e:	89 45 14             	mov    %eax,0x14(%ebp)
  800991:	8b 45 14             	mov    0x14(%ebp),%eax
  800994:	83 e8 04             	sub    $0x4,%eax
  800997:	8b 30                	mov    (%eax),%esi
  800999:	85 f6                	test   %esi,%esi
  80099b:	75 05                	jne    8009a2 <vprintfmt+0x1a6>
				p = "(null)";
  80099d:	be 11 38 80 00       	mov    $0x803811,%esi
			if (width > 0 && padc != '-')
  8009a2:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8009a6:	7e 6d                	jle    800a15 <vprintfmt+0x219>
  8009a8:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  8009ac:	74 67                	je     800a15 <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  8009ae:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8009b1:	83 ec 08             	sub    $0x8,%esp
  8009b4:	50                   	push   %eax
  8009b5:	56                   	push   %esi
  8009b6:	e8 0c 03 00 00       	call   800cc7 <strnlen>
  8009bb:	83 c4 10             	add    $0x10,%esp
  8009be:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  8009c1:	eb 16                	jmp    8009d9 <vprintfmt+0x1dd>
					putch(padc, putdat);
  8009c3:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  8009c7:	83 ec 08             	sub    $0x8,%esp
  8009ca:	ff 75 0c             	pushl  0xc(%ebp)
  8009cd:	50                   	push   %eax
  8009ce:	8b 45 08             	mov    0x8(%ebp),%eax
  8009d1:	ff d0                	call   *%eax
  8009d3:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  8009d6:	ff 4d e4             	decl   -0x1c(%ebp)
  8009d9:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8009dd:	7f e4                	jg     8009c3 <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8009df:	eb 34                	jmp    800a15 <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  8009e1:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  8009e5:	74 1c                	je     800a03 <vprintfmt+0x207>
  8009e7:	83 fb 1f             	cmp    $0x1f,%ebx
  8009ea:	7e 05                	jle    8009f1 <vprintfmt+0x1f5>
  8009ec:	83 fb 7e             	cmp    $0x7e,%ebx
  8009ef:	7e 12                	jle    800a03 <vprintfmt+0x207>
					putch('?', putdat);
  8009f1:	83 ec 08             	sub    $0x8,%esp
  8009f4:	ff 75 0c             	pushl  0xc(%ebp)
  8009f7:	6a 3f                	push   $0x3f
  8009f9:	8b 45 08             	mov    0x8(%ebp),%eax
  8009fc:	ff d0                	call   *%eax
  8009fe:	83 c4 10             	add    $0x10,%esp
  800a01:	eb 0f                	jmp    800a12 <vprintfmt+0x216>
				else
					putch(ch, putdat);
  800a03:	83 ec 08             	sub    $0x8,%esp
  800a06:	ff 75 0c             	pushl  0xc(%ebp)
  800a09:	53                   	push   %ebx
  800a0a:	8b 45 08             	mov    0x8(%ebp),%eax
  800a0d:	ff d0                	call   *%eax
  800a0f:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800a12:	ff 4d e4             	decl   -0x1c(%ebp)
  800a15:	89 f0                	mov    %esi,%eax
  800a17:	8d 70 01             	lea    0x1(%eax),%esi
  800a1a:	8a 00                	mov    (%eax),%al
  800a1c:	0f be d8             	movsbl %al,%ebx
  800a1f:	85 db                	test   %ebx,%ebx
  800a21:	74 24                	je     800a47 <vprintfmt+0x24b>
  800a23:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800a27:	78 b8                	js     8009e1 <vprintfmt+0x1e5>
  800a29:	ff 4d e0             	decl   -0x20(%ebp)
  800a2c:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800a30:	79 af                	jns    8009e1 <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800a32:	eb 13                	jmp    800a47 <vprintfmt+0x24b>
				putch(' ', putdat);
  800a34:	83 ec 08             	sub    $0x8,%esp
  800a37:	ff 75 0c             	pushl  0xc(%ebp)
  800a3a:	6a 20                	push   $0x20
  800a3c:	8b 45 08             	mov    0x8(%ebp),%eax
  800a3f:	ff d0                	call   *%eax
  800a41:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800a44:	ff 4d e4             	decl   -0x1c(%ebp)
  800a47:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800a4b:	7f e7                	jg     800a34 <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  800a4d:	e9 66 01 00 00       	jmp    800bb8 <vprintfmt+0x3bc>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  800a52:	83 ec 08             	sub    $0x8,%esp
  800a55:	ff 75 e8             	pushl  -0x18(%ebp)
  800a58:	8d 45 14             	lea    0x14(%ebp),%eax
  800a5b:	50                   	push   %eax
  800a5c:	e8 3c fd ff ff       	call   80079d <getint>
  800a61:	83 c4 10             	add    $0x10,%esp
  800a64:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800a67:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  800a6a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800a6d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800a70:	85 d2                	test   %edx,%edx
  800a72:	79 23                	jns    800a97 <vprintfmt+0x29b>
				putch('-', putdat);
  800a74:	83 ec 08             	sub    $0x8,%esp
  800a77:	ff 75 0c             	pushl  0xc(%ebp)
  800a7a:	6a 2d                	push   $0x2d
  800a7c:	8b 45 08             	mov    0x8(%ebp),%eax
  800a7f:	ff d0                	call   *%eax
  800a81:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  800a84:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800a87:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800a8a:	f7 d8                	neg    %eax
  800a8c:	83 d2 00             	adc    $0x0,%edx
  800a8f:	f7 da                	neg    %edx
  800a91:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800a94:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  800a97:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800a9e:	e9 bc 00 00 00       	jmp    800b5f <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  800aa3:	83 ec 08             	sub    $0x8,%esp
  800aa6:	ff 75 e8             	pushl  -0x18(%ebp)
  800aa9:	8d 45 14             	lea    0x14(%ebp),%eax
  800aac:	50                   	push   %eax
  800aad:	e8 84 fc ff ff       	call   800736 <getuint>
  800ab2:	83 c4 10             	add    $0x10,%esp
  800ab5:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800ab8:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  800abb:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800ac2:	e9 98 00 00 00       	jmp    800b5f <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  800ac7:	83 ec 08             	sub    $0x8,%esp
  800aca:	ff 75 0c             	pushl  0xc(%ebp)
  800acd:	6a 58                	push   $0x58
  800acf:	8b 45 08             	mov    0x8(%ebp),%eax
  800ad2:	ff d0                	call   *%eax
  800ad4:	83 c4 10             	add    $0x10,%esp
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
			break;
  800af7:	e9 bc 00 00 00       	jmp    800bb8 <vprintfmt+0x3bc>

		// pointer
		case 'p':
			putch('0', putdat);
  800afc:	83 ec 08             	sub    $0x8,%esp
  800aff:	ff 75 0c             	pushl  0xc(%ebp)
  800b02:	6a 30                	push   $0x30
  800b04:	8b 45 08             	mov    0x8(%ebp),%eax
  800b07:	ff d0                	call   *%eax
  800b09:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  800b0c:	83 ec 08             	sub    $0x8,%esp
  800b0f:	ff 75 0c             	pushl  0xc(%ebp)
  800b12:	6a 78                	push   $0x78
  800b14:	8b 45 08             	mov    0x8(%ebp),%eax
  800b17:	ff d0                	call   *%eax
  800b19:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  800b1c:	8b 45 14             	mov    0x14(%ebp),%eax
  800b1f:	83 c0 04             	add    $0x4,%eax
  800b22:	89 45 14             	mov    %eax,0x14(%ebp)
  800b25:	8b 45 14             	mov    0x14(%ebp),%eax
  800b28:	83 e8 04             	sub    $0x4,%eax
  800b2b:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800b2d:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800b30:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  800b37:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  800b3e:	eb 1f                	jmp    800b5f <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  800b40:	83 ec 08             	sub    $0x8,%esp
  800b43:	ff 75 e8             	pushl  -0x18(%ebp)
  800b46:	8d 45 14             	lea    0x14(%ebp),%eax
  800b49:	50                   	push   %eax
  800b4a:	e8 e7 fb ff ff       	call   800736 <getuint>
  800b4f:	83 c4 10             	add    $0x10,%esp
  800b52:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800b55:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  800b58:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800b5f:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  800b63:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800b66:	83 ec 04             	sub    $0x4,%esp
  800b69:	52                   	push   %edx
  800b6a:	ff 75 e4             	pushl  -0x1c(%ebp)
  800b6d:	50                   	push   %eax
  800b6e:	ff 75 f4             	pushl  -0xc(%ebp)
  800b71:	ff 75 f0             	pushl  -0x10(%ebp)
  800b74:	ff 75 0c             	pushl  0xc(%ebp)
  800b77:	ff 75 08             	pushl  0x8(%ebp)
  800b7a:	e8 00 fb ff ff       	call   80067f <printnum>
  800b7f:	83 c4 20             	add    $0x20,%esp
			break;
  800b82:	eb 34                	jmp    800bb8 <vprintfmt+0x3bc>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  800b84:	83 ec 08             	sub    $0x8,%esp
  800b87:	ff 75 0c             	pushl  0xc(%ebp)
  800b8a:	53                   	push   %ebx
  800b8b:	8b 45 08             	mov    0x8(%ebp),%eax
  800b8e:	ff d0                	call   *%eax
  800b90:	83 c4 10             	add    $0x10,%esp
			break;
  800b93:	eb 23                	jmp    800bb8 <vprintfmt+0x3bc>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800b95:	83 ec 08             	sub    $0x8,%esp
  800b98:	ff 75 0c             	pushl  0xc(%ebp)
  800b9b:	6a 25                	push   $0x25
  800b9d:	8b 45 08             	mov    0x8(%ebp),%eax
  800ba0:	ff d0                	call   *%eax
  800ba2:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  800ba5:	ff 4d 10             	decl   0x10(%ebp)
  800ba8:	eb 03                	jmp    800bad <vprintfmt+0x3b1>
  800baa:	ff 4d 10             	decl   0x10(%ebp)
  800bad:	8b 45 10             	mov    0x10(%ebp),%eax
  800bb0:	48                   	dec    %eax
  800bb1:	8a 00                	mov    (%eax),%al
  800bb3:	3c 25                	cmp    $0x25,%al
  800bb5:	75 f3                	jne    800baa <vprintfmt+0x3ae>
				/* do nothing */;
			break;
  800bb7:	90                   	nop
		}
	}
  800bb8:	e9 47 fc ff ff       	jmp    800804 <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  800bbd:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  800bbe:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800bc1:	5b                   	pop    %ebx
  800bc2:	5e                   	pop    %esi
  800bc3:	5d                   	pop    %ebp
  800bc4:	c3                   	ret    

00800bc5 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800bc5:	55                   	push   %ebp
  800bc6:	89 e5                	mov    %esp,%ebp
  800bc8:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  800bcb:	8d 45 10             	lea    0x10(%ebp),%eax
  800bce:	83 c0 04             	add    $0x4,%eax
  800bd1:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  800bd4:	8b 45 10             	mov    0x10(%ebp),%eax
  800bd7:	ff 75 f4             	pushl  -0xc(%ebp)
  800bda:	50                   	push   %eax
  800bdb:	ff 75 0c             	pushl  0xc(%ebp)
  800bde:	ff 75 08             	pushl  0x8(%ebp)
  800be1:	e8 16 fc ff ff       	call   8007fc <vprintfmt>
  800be6:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  800be9:	90                   	nop
  800bea:	c9                   	leave  
  800beb:	c3                   	ret    

00800bec <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800bec:	55                   	push   %ebp
  800bed:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  800bef:	8b 45 0c             	mov    0xc(%ebp),%eax
  800bf2:	8b 40 08             	mov    0x8(%eax),%eax
  800bf5:	8d 50 01             	lea    0x1(%eax),%edx
  800bf8:	8b 45 0c             	mov    0xc(%ebp),%eax
  800bfb:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  800bfe:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c01:	8b 10                	mov    (%eax),%edx
  800c03:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c06:	8b 40 04             	mov    0x4(%eax),%eax
  800c09:	39 c2                	cmp    %eax,%edx
  800c0b:	73 12                	jae    800c1f <sprintputch+0x33>
		*b->buf++ = ch;
  800c0d:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c10:	8b 00                	mov    (%eax),%eax
  800c12:	8d 48 01             	lea    0x1(%eax),%ecx
  800c15:	8b 55 0c             	mov    0xc(%ebp),%edx
  800c18:	89 0a                	mov    %ecx,(%edx)
  800c1a:	8b 55 08             	mov    0x8(%ebp),%edx
  800c1d:	88 10                	mov    %dl,(%eax)
}
  800c1f:	90                   	nop
  800c20:	5d                   	pop    %ebp
  800c21:	c3                   	ret    

00800c22 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800c22:	55                   	push   %ebp
  800c23:	89 e5                	mov    %esp,%ebp
  800c25:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  800c28:	8b 45 08             	mov    0x8(%ebp),%eax
  800c2b:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800c2e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c31:	8d 50 ff             	lea    -0x1(%eax),%edx
  800c34:	8b 45 08             	mov    0x8(%ebp),%eax
  800c37:	01 d0                	add    %edx,%eax
  800c39:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800c3c:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800c43:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800c47:	74 06                	je     800c4f <vsnprintf+0x2d>
  800c49:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800c4d:	7f 07                	jg     800c56 <vsnprintf+0x34>
		return -E_INVAL;
  800c4f:	b8 03 00 00 00       	mov    $0x3,%eax
  800c54:	eb 20                	jmp    800c76 <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800c56:	ff 75 14             	pushl  0x14(%ebp)
  800c59:	ff 75 10             	pushl  0x10(%ebp)
  800c5c:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800c5f:	50                   	push   %eax
  800c60:	68 ec 0b 80 00       	push   $0x800bec
  800c65:	e8 92 fb ff ff       	call   8007fc <vprintfmt>
  800c6a:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  800c6d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800c70:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800c73:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  800c76:	c9                   	leave  
  800c77:	c3                   	ret    

00800c78 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800c78:	55                   	push   %ebp
  800c79:	89 e5                	mov    %esp,%ebp
  800c7b:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800c7e:	8d 45 10             	lea    0x10(%ebp),%eax
  800c81:	83 c0 04             	add    $0x4,%eax
  800c84:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  800c87:	8b 45 10             	mov    0x10(%ebp),%eax
  800c8a:	ff 75 f4             	pushl  -0xc(%ebp)
  800c8d:	50                   	push   %eax
  800c8e:	ff 75 0c             	pushl  0xc(%ebp)
  800c91:	ff 75 08             	pushl  0x8(%ebp)
  800c94:	e8 89 ff ff ff       	call   800c22 <vsnprintf>
  800c99:	83 c4 10             	add    $0x10,%esp
  800c9c:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  800c9f:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800ca2:	c9                   	leave  
  800ca3:	c3                   	ret    

00800ca4 <strlen>:

#include <inc/string.h>

int
strlen(const char *s)
{
  800ca4:	55                   	push   %ebp
  800ca5:	89 e5                	mov    %esp,%ebp
  800ca7:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  800caa:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800cb1:	eb 06                	jmp    800cb9 <strlen+0x15>
		n++;
  800cb3:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  800cb6:	ff 45 08             	incl   0x8(%ebp)
  800cb9:	8b 45 08             	mov    0x8(%ebp),%eax
  800cbc:	8a 00                	mov    (%eax),%al
  800cbe:	84 c0                	test   %al,%al
  800cc0:	75 f1                	jne    800cb3 <strlen+0xf>
		n++;
	return n;
  800cc2:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800cc5:	c9                   	leave  
  800cc6:	c3                   	ret    

00800cc7 <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  800cc7:	55                   	push   %ebp
  800cc8:	89 e5                	mov    %esp,%ebp
  800cca:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800ccd:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800cd4:	eb 09                	jmp    800cdf <strnlen+0x18>
		n++;
  800cd6:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800cd9:	ff 45 08             	incl   0x8(%ebp)
  800cdc:	ff 4d 0c             	decl   0xc(%ebp)
  800cdf:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800ce3:	74 09                	je     800cee <strnlen+0x27>
  800ce5:	8b 45 08             	mov    0x8(%ebp),%eax
  800ce8:	8a 00                	mov    (%eax),%al
  800cea:	84 c0                	test   %al,%al
  800cec:	75 e8                	jne    800cd6 <strnlen+0xf>
		n++;
	return n;
  800cee:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800cf1:	c9                   	leave  
  800cf2:	c3                   	ret    

00800cf3 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800cf3:	55                   	push   %ebp
  800cf4:	89 e5                	mov    %esp,%ebp
  800cf6:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  800cf9:	8b 45 08             	mov    0x8(%ebp),%eax
  800cfc:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  800cff:	90                   	nop
  800d00:	8b 45 08             	mov    0x8(%ebp),%eax
  800d03:	8d 50 01             	lea    0x1(%eax),%edx
  800d06:	89 55 08             	mov    %edx,0x8(%ebp)
  800d09:	8b 55 0c             	mov    0xc(%ebp),%edx
  800d0c:	8d 4a 01             	lea    0x1(%edx),%ecx
  800d0f:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800d12:	8a 12                	mov    (%edx),%dl
  800d14:	88 10                	mov    %dl,(%eax)
  800d16:	8a 00                	mov    (%eax),%al
  800d18:	84 c0                	test   %al,%al
  800d1a:	75 e4                	jne    800d00 <strcpy+0xd>
		/* do nothing */;
	return ret;
  800d1c:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800d1f:	c9                   	leave  
  800d20:	c3                   	ret    

00800d21 <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  800d21:	55                   	push   %ebp
  800d22:	89 e5                	mov    %esp,%ebp
  800d24:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  800d27:	8b 45 08             	mov    0x8(%ebp),%eax
  800d2a:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  800d2d:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800d34:	eb 1f                	jmp    800d55 <strncpy+0x34>
		*dst++ = *src;
  800d36:	8b 45 08             	mov    0x8(%ebp),%eax
  800d39:	8d 50 01             	lea    0x1(%eax),%edx
  800d3c:	89 55 08             	mov    %edx,0x8(%ebp)
  800d3f:	8b 55 0c             	mov    0xc(%ebp),%edx
  800d42:	8a 12                	mov    (%edx),%dl
  800d44:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  800d46:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d49:	8a 00                	mov    (%eax),%al
  800d4b:	84 c0                	test   %al,%al
  800d4d:	74 03                	je     800d52 <strncpy+0x31>
			src++;
  800d4f:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800d52:	ff 45 fc             	incl   -0x4(%ebp)
  800d55:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800d58:	3b 45 10             	cmp    0x10(%ebp),%eax
  800d5b:	72 d9                	jb     800d36 <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  800d5d:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  800d60:	c9                   	leave  
  800d61:	c3                   	ret    

00800d62 <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  800d62:	55                   	push   %ebp
  800d63:	89 e5                	mov    %esp,%ebp
  800d65:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  800d68:	8b 45 08             	mov    0x8(%ebp),%eax
  800d6b:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  800d6e:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800d72:	74 30                	je     800da4 <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  800d74:	eb 16                	jmp    800d8c <strlcpy+0x2a>
			*dst++ = *src++;
  800d76:	8b 45 08             	mov    0x8(%ebp),%eax
  800d79:	8d 50 01             	lea    0x1(%eax),%edx
  800d7c:	89 55 08             	mov    %edx,0x8(%ebp)
  800d7f:	8b 55 0c             	mov    0xc(%ebp),%edx
  800d82:	8d 4a 01             	lea    0x1(%edx),%ecx
  800d85:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800d88:	8a 12                	mov    (%edx),%dl
  800d8a:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  800d8c:	ff 4d 10             	decl   0x10(%ebp)
  800d8f:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800d93:	74 09                	je     800d9e <strlcpy+0x3c>
  800d95:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d98:	8a 00                	mov    (%eax),%al
  800d9a:	84 c0                	test   %al,%al
  800d9c:	75 d8                	jne    800d76 <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  800d9e:	8b 45 08             	mov    0x8(%ebp),%eax
  800da1:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800da4:	8b 55 08             	mov    0x8(%ebp),%edx
  800da7:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800daa:	29 c2                	sub    %eax,%edx
  800dac:	89 d0                	mov    %edx,%eax
}
  800dae:	c9                   	leave  
  800daf:	c3                   	ret    

00800db0 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800db0:	55                   	push   %ebp
  800db1:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  800db3:	eb 06                	jmp    800dbb <strcmp+0xb>
		p++, q++;
  800db5:	ff 45 08             	incl   0x8(%ebp)
  800db8:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  800dbb:	8b 45 08             	mov    0x8(%ebp),%eax
  800dbe:	8a 00                	mov    (%eax),%al
  800dc0:	84 c0                	test   %al,%al
  800dc2:	74 0e                	je     800dd2 <strcmp+0x22>
  800dc4:	8b 45 08             	mov    0x8(%ebp),%eax
  800dc7:	8a 10                	mov    (%eax),%dl
  800dc9:	8b 45 0c             	mov    0xc(%ebp),%eax
  800dcc:	8a 00                	mov    (%eax),%al
  800dce:	38 c2                	cmp    %al,%dl
  800dd0:	74 e3                	je     800db5 <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800dd2:	8b 45 08             	mov    0x8(%ebp),%eax
  800dd5:	8a 00                	mov    (%eax),%al
  800dd7:	0f b6 d0             	movzbl %al,%edx
  800dda:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ddd:	8a 00                	mov    (%eax),%al
  800ddf:	0f b6 c0             	movzbl %al,%eax
  800de2:	29 c2                	sub    %eax,%edx
  800de4:	89 d0                	mov    %edx,%eax
}
  800de6:	5d                   	pop    %ebp
  800de7:	c3                   	ret    

00800de8 <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  800de8:	55                   	push   %ebp
  800de9:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  800deb:	eb 09                	jmp    800df6 <strncmp+0xe>
		n--, p++, q++;
  800ded:	ff 4d 10             	decl   0x10(%ebp)
  800df0:	ff 45 08             	incl   0x8(%ebp)
  800df3:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  800df6:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800dfa:	74 17                	je     800e13 <strncmp+0x2b>
  800dfc:	8b 45 08             	mov    0x8(%ebp),%eax
  800dff:	8a 00                	mov    (%eax),%al
  800e01:	84 c0                	test   %al,%al
  800e03:	74 0e                	je     800e13 <strncmp+0x2b>
  800e05:	8b 45 08             	mov    0x8(%ebp),%eax
  800e08:	8a 10                	mov    (%eax),%dl
  800e0a:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e0d:	8a 00                	mov    (%eax),%al
  800e0f:	38 c2                	cmp    %al,%dl
  800e11:	74 da                	je     800ded <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  800e13:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800e17:	75 07                	jne    800e20 <strncmp+0x38>
		return 0;
  800e19:	b8 00 00 00 00       	mov    $0x0,%eax
  800e1e:	eb 14                	jmp    800e34 <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800e20:	8b 45 08             	mov    0x8(%ebp),%eax
  800e23:	8a 00                	mov    (%eax),%al
  800e25:	0f b6 d0             	movzbl %al,%edx
  800e28:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e2b:	8a 00                	mov    (%eax),%al
  800e2d:	0f b6 c0             	movzbl %al,%eax
  800e30:	29 c2                	sub    %eax,%edx
  800e32:	89 d0                	mov    %edx,%eax
}
  800e34:	5d                   	pop    %ebp
  800e35:	c3                   	ret    

00800e36 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800e36:	55                   	push   %ebp
  800e37:	89 e5                	mov    %esp,%ebp
  800e39:	83 ec 04             	sub    $0x4,%esp
  800e3c:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e3f:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800e42:	eb 12                	jmp    800e56 <strchr+0x20>
		if (*s == c)
  800e44:	8b 45 08             	mov    0x8(%ebp),%eax
  800e47:	8a 00                	mov    (%eax),%al
  800e49:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800e4c:	75 05                	jne    800e53 <strchr+0x1d>
			return (char *) s;
  800e4e:	8b 45 08             	mov    0x8(%ebp),%eax
  800e51:	eb 11                	jmp    800e64 <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  800e53:	ff 45 08             	incl   0x8(%ebp)
  800e56:	8b 45 08             	mov    0x8(%ebp),%eax
  800e59:	8a 00                	mov    (%eax),%al
  800e5b:	84 c0                	test   %al,%al
  800e5d:	75 e5                	jne    800e44 <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  800e5f:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800e64:	c9                   	leave  
  800e65:	c3                   	ret    

00800e66 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800e66:	55                   	push   %ebp
  800e67:	89 e5                	mov    %esp,%ebp
  800e69:	83 ec 04             	sub    $0x4,%esp
  800e6c:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e6f:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800e72:	eb 0d                	jmp    800e81 <strfind+0x1b>
		if (*s == c)
  800e74:	8b 45 08             	mov    0x8(%ebp),%eax
  800e77:	8a 00                	mov    (%eax),%al
  800e79:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800e7c:	74 0e                	je     800e8c <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  800e7e:	ff 45 08             	incl   0x8(%ebp)
  800e81:	8b 45 08             	mov    0x8(%ebp),%eax
  800e84:	8a 00                	mov    (%eax),%al
  800e86:	84 c0                	test   %al,%al
  800e88:	75 ea                	jne    800e74 <strfind+0xe>
  800e8a:	eb 01                	jmp    800e8d <strfind+0x27>
		if (*s == c)
			break;
  800e8c:	90                   	nop
	return (char *) s;
  800e8d:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800e90:	c9                   	leave  
  800e91:	c3                   	ret    

00800e92 <memset>:


void *
memset(void *v, int c, uint32 n)
{
  800e92:	55                   	push   %ebp
  800e93:	89 e5                	mov    %esp,%ebp
  800e95:	83 ec 10             	sub    $0x10,%esp
	char *p;
	int m;

	p = v;
  800e98:	8b 45 08             	mov    0x8(%ebp),%eax
  800e9b:	89 45 fc             	mov    %eax,-0x4(%ebp)
	m = n;
  800e9e:	8b 45 10             	mov    0x10(%ebp),%eax
  800ea1:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (--m >= 0)
  800ea4:	eb 0e                	jmp    800eb4 <memset+0x22>
		*p++ = c;
  800ea6:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800ea9:	8d 50 01             	lea    0x1(%eax),%edx
  800eac:	89 55 fc             	mov    %edx,-0x4(%ebp)
  800eaf:	8b 55 0c             	mov    0xc(%ebp),%edx
  800eb2:	88 10                	mov    %dl,(%eax)
	char *p;
	int m;

	p = v;
	m = n;
	while (--m >= 0)
  800eb4:	ff 4d f8             	decl   -0x8(%ebp)
  800eb7:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
  800ebb:	79 e9                	jns    800ea6 <memset+0x14>
		*p++ = c;

	return v;
  800ebd:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800ec0:	c9                   	leave  
  800ec1:	c3                   	ret    

00800ec2 <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  800ec2:	55                   	push   %ebp
  800ec3:	89 e5                	mov    %esp,%ebp
  800ec5:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  800ec8:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ecb:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  800ece:	8b 45 08             	mov    0x8(%ebp),%eax
  800ed1:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (n-- > 0)
  800ed4:	eb 16                	jmp    800eec <memcpy+0x2a>
		*d++ = *s++;
  800ed6:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800ed9:	8d 50 01             	lea    0x1(%eax),%edx
  800edc:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800edf:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800ee2:	8d 4a 01             	lea    0x1(%edx),%ecx
  800ee5:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  800ee8:	8a 12                	mov    (%edx),%dl
  800eea:	88 10                	mov    %dl,(%eax)
	const char *s;
	char *d;

	s = src;
	d = dst;
	while (n-- > 0)
  800eec:	8b 45 10             	mov    0x10(%ebp),%eax
  800eef:	8d 50 ff             	lea    -0x1(%eax),%edx
  800ef2:	89 55 10             	mov    %edx,0x10(%ebp)
  800ef5:	85 c0                	test   %eax,%eax
  800ef7:	75 dd                	jne    800ed6 <memcpy+0x14>
		*d++ = *s++;

	return dst;
  800ef9:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800efc:	c9                   	leave  
  800efd:	c3                   	ret    

00800efe <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  800efe:	55                   	push   %ebp
  800eff:	89 e5                	mov    %esp,%ebp
  800f01:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  800f04:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f07:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  800f0a:	8b 45 08             	mov    0x8(%ebp),%eax
  800f0d:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  800f10:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800f13:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800f16:	73 50                	jae    800f68 <memmove+0x6a>
  800f18:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800f1b:	8b 45 10             	mov    0x10(%ebp),%eax
  800f1e:	01 d0                	add    %edx,%eax
  800f20:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800f23:	76 43                	jbe    800f68 <memmove+0x6a>
		s += n;
  800f25:	8b 45 10             	mov    0x10(%ebp),%eax
  800f28:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  800f2b:	8b 45 10             	mov    0x10(%ebp),%eax
  800f2e:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  800f31:	eb 10                	jmp    800f43 <memmove+0x45>
			*--d = *--s;
  800f33:	ff 4d f8             	decl   -0x8(%ebp)
  800f36:	ff 4d fc             	decl   -0x4(%ebp)
  800f39:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800f3c:	8a 10                	mov    (%eax),%dl
  800f3e:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800f41:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  800f43:	8b 45 10             	mov    0x10(%ebp),%eax
  800f46:	8d 50 ff             	lea    -0x1(%eax),%edx
  800f49:	89 55 10             	mov    %edx,0x10(%ebp)
  800f4c:	85 c0                	test   %eax,%eax
  800f4e:	75 e3                	jne    800f33 <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800f50:	eb 23                	jmp    800f75 <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  800f52:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800f55:	8d 50 01             	lea    0x1(%eax),%edx
  800f58:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800f5b:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800f5e:	8d 4a 01             	lea    0x1(%edx),%ecx
  800f61:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  800f64:	8a 12                	mov    (%edx),%dl
  800f66:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  800f68:	8b 45 10             	mov    0x10(%ebp),%eax
  800f6b:	8d 50 ff             	lea    -0x1(%eax),%edx
  800f6e:	89 55 10             	mov    %edx,0x10(%ebp)
  800f71:	85 c0                	test   %eax,%eax
  800f73:	75 dd                	jne    800f52 <memmove+0x54>
			*d++ = *s++;

	return dst;
  800f75:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800f78:	c9                   	leave  
  800f79:	c3                   	ret    

00800f7a <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  800f7a:	55                   	push   %ebp
  800f7b:	89 e5                	mov    %esp,%ebp
  800f7d:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  800f80:	8b 45 08             	mov    0x8(%ebp),%eax
  800f83:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  800f86:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f89:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  800f8c:	eb 2a                	jmp    800fb8 <memcmp+0x3e>
		if (*s1 != *s2)
  800f8e:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800f91:	8a 10                	mov    (%eax),%dl
  800f93:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800f96:	8a 00                	mov    (%eax),%al
  800f98:	38 c2                	cmp    %al,%dl
  800f9a:	74 16                	je     800fb2 <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  800f9c:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800f9f:	8a 00                	mov    (%eax),%al
  800fa1:	0f b6 d0             	movzbl %al,%edx
  800fa4:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800fa7:	8a 00                	mov    (%eax),%al
  800fa9:	0f b6 c0             	movzbl %al,%eax
  800fac:	29 c2                	sub    %eax,%edx
  800fae:	89 d0                	mov    %edx,%eax
  800fb0:	eb 18                	jmp    800fca <memcmp+0x50>
		s1++, s2++;
  800fb2:	ff 45 fc             	incl   -0x4(%ebp)
  800fb5:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  800fb8:	8b 45 10             	mov    0x10(%ebp),%eax
  800fbb:	8d 50 ff             	lea    -0x1(%eax),%edx
  800fbe:	89 55 10             	mov    %edx,0x10(%ebp)
  800fc1:	85 c0                	test   %eax,%eax
  800fc3:	75 c9                	jne    800f8e <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  800fc5:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800fca:	c9                   	leave  
  800fcb:	c3                   	ret    

00800fcc <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  800fcc:	55                   	push   %ebp
  800fcd:	89 e5                	mov    %esp,%ebp
  800fcf:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  800fd2:	8b 55 08             	mov    0x8(%ebp),%edx
  800fd5:	8b 45 10             	mov    0x10(%ebp),%eax
  800fd8:	01 d0                	add    %edx,%eax
  800fda:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  800fdd:	eb 15                	jmp    800ff4 <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  800fdf:	8b 45 08             	mov    0x8(%ebp),%eax
  800fe2:	8a 00                	mov    (%eax),%al
  800fe4:	0f b6 d0             	movzbl %al,%edx
  800fe7:	8b 45 0c             	mov    0xc(%ebp),%eax
  800fea:	0f b6 c0             	movzbl %al,%eax
  800fed:	39 c2                	cmp    %eax,%edx
  800fef:	74 0d                	je     800ffe <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  800ff1:	ff 45 08             	incl   0x8(%ebp)
  800ff4:	8b 45 08             	mov    0x8(%ebp),%eax
  800ff7:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  800ffa:	72 e3                	jb     800fdf <memfind+0x13>
  800ffc:	eb 01                	jmp    800fff <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  800ffe:	90                   	nop
	return (void *) s;
  800fff:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801002:	c9                   	leave  
  801003:	c3                   	ret    

00801004 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  801004:	55                   	push   %ebp
  801005:	89 e5                	mov    %esp,%ebp
  801007:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  80100a:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  801011:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801018:	eb 03                	jmp    80101d <strtol+0x19>
		s++;
  80101a:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  80101d:	8b 45 08             	mov    0x8(%ebp),%eax
  801020:	8a 00                	mov    (%eax),%al
  801022:	3c 20                	cmp    $0x20,%al
  801024:	74 f4                	je     80101a <strtol+0x16>
  801026:	8b 45 08             	mov    0x8(%ebp),%eax
  801029:	8a 00                	mov    (%eax),%al
  80102b:	3c 09                	cmp    $0x9,%al
  80102d:	74 eb                	je     80101a <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  80102f:	8b 45 08             	mov    0x8(%ebp),%eax
  801032:	8a 00                	mov    (%eax),%al
  801034:	3c 2b                	cmp    $0x2b,%al
  801036:	75 05                	jne    80103d <strtol+0x39>
		s++;
  801038:	ff 45 08             	incl   0x8(%ebp)
  80103b:	eb 13                	jmp    801050 <strtol+0x4c>
	else if (*s == '-')
  80103d:	8b 45 08             	mov    0x8(%ebp),%eax
  801040:	8a 00                	mov    (%eax),%al
  801042:	3c 2d                	cmp    $0x2d,%al
  801044:	75 0a                	jne    801050 <strtol+0x4c>
		s++, neg = 1;
  801046:	ff 45 08             	incl   0x8(%ebp)
  801049:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  801050:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801054:	74 06                	je     80105c <strtol+0x58>
  801056:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  80105a:	75 20                	jne    80107c <strtol+0x78>
  80105c:	8b 45 08             	mov    0x8(%ebp),%eax
  80105f:	8a 00                	mov    (%eax),%al
  801061:	3c 30                	cmp    $0x30,%al
  801063:	75 17                	jne    80107c <strtol+0x78>
  801065:	8b 45 08             	mov    0x8(%ebp),%eax
  801068:	40                   	inc    %eax
  801069:	8a 00                	mov    (%eax),%al
  80106b:	3c 78                	cmp    $0x78,%al
  80106d:	75 0d                	jne    80107c <strtol+0x78>
		s += 2, base = 16;
  80106f:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  801073:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  80107a:	eb 28                	jmp    8010a4 <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  80107c:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801080:	75 15                	jne    801097 <strtol+0x93>
  801082:	8b 45 08             	mov    0x8(%ebp),%eax
  801085:	8a 00                	mov    (%eax),%al
  801087:	3c 30                	cmp    $0x30,%al
  801089:	75 0c                	jne    801097 <strtol+0x93>
		s++, base = 8;
  80108b:	ff 45 08             	incl   0x8(%ebp)
  80108e:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  801095:	eb 0d                	jmp    8010a4 <strtol+0xa0>
	else if (base == 0)
  801097:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80109b:	75 07                	jne    8010a4 <strtol+0xa0>
		base = 10;
  80109d:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  8010a4:	8b 45 08             	mov    0x8(%ebp),%eax
  8010a7:	8a 00                	mov    (%eax),%al
  8010a9:	3c 2f                	cmp    $0x2f,%al
  8010ab:	7e 19                	jle    8010c6 <strtol+0xc2>
  8010ad:	8b 45 08             	mov    0x8(%ebp),%eax
  8010b0:	8a 00                	mov    (%eax),%al
  8010b2:	3c 39                	cmp    $0x39,%al
  8010b4:	7f 10                	jg     8010c6 <strtol+0xc2>
			dig = *s - '0';
  8010b6:	8b 45 08             	mov    0x8(%ebp),%eax
  8010b9:	8a 00                	mov    (%eax),%al
  8010bb:	0f be c0             	movsbl %al,%eax
  8010be:	83 e8 30             	sub    $0x30,%eax
  8010c1:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8010c4:	eb 42                	jmp    801108 <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  8010c6:	8b 45 08             	mov    0x8(%ebp),%eax
  8010c9:	8a 00                	mov    (%eax),%al
  8010cb:	3c 60                	cmp    $0x60,%al
  8010cd:	7e 19                	jle    8010e8 <strtol+0xe4>
  8010cf:	8b 45 08             	mov    0x8(%ebp),%eax
  8010d2:	8a 00                	mov    (%eax),%al
  8010d4:	3c 7a                	cmp    $0x7a,%al
  8010d6:	7f 10                	jg     8010e8 <strtol+0xe4>
			dig = *s - 'a' + 10;
  8010d8:	8b 45 08             	mov    0x8(%ebp),%eax
  8010db:	8a 00                	mov    (%eax),%al
  8010dd:	0f be c0             	movsbl %al,%eax
  8010e0:	83 e8 57             	sub    $0x57,%eax
  8010e3:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8010e6:	eb 20                	jmp    801108 <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  8010e8:	8b 45 08             	mov    0x8(%ebp),%eax
  8010eb:	8a 00                	mov    (%eax),%al
  8010ed:	3c 40                	cmp    $0x40,%al
  8010ef:	7e 39                	jle    80112a <strtol+0x126>
  8010f1:	8b 45 08             	mov    0x8(%ebp),%eax
  8010f4:	8a 00                	mov    (%eax),%al
  8010f6:	3c 5a                	cmp    $0x5a,%al
  8010f8:	7f 30                	jg     80112a <strtol+0x126>
			dig = *s - 'A' + 10;
  8010fa:	8b 45 08             	mov    0x8(%ebp),%eax
  8010fd:	8a 00                	mov    (%eax),%al
  8010ff:	0f be c0             	movsbl %al,%eax
  801102:	83 e8 37             	sub    $0x37,%eax
  801105:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  801108:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80110b:	3b 45 10             	cmp    0x10(%ebp),%eax
  80110e:	7d 19                	jge    801129 <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  801110:	ff 45 08             	incl   0x8(%ebp)
  801113:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801116:	0f af 45 10          	imul   0x10(%ebp),%eax
  80111a:	89 c2                	mov    %eax,%edx
  80111c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80111f:	01 d0                	add    %edx,%eax
  801121:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  801124:	e9 7b ff ff ff       	jmp    8010a4 <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  801129:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  80112a:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80112e:	74 08                	je     801138 <strtol+0x134>
		*endptr = (char *) s;
  801130:	8b 45 0c             	mov    0xc(%ebp),%eax
  801133:	8b 55 08             	mov    0x8(%ebp),%edx
  801136:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  801138:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  80113c:	74 07                	je     801145 <strtol+0x141>
  80113e:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801141:	f7 d8                	neg    %eax
  801143:	eb 03                	jmp    801148 <strtol+0x144>
  801145:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  801148:	c9                   	leave  
  801149:	c3                   	ret    

0080114a <ltostr>:

void
ltostr(long value, char *str)
{
  80114a:	55                   	push   %ebp
  80114b:	89 e5                	mov    %esp,%ebp
  80114d:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  801150:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  801157:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  80115e:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801162:	79 13                	jns    801177 <ltostr+0x2d>
	{
		neg = 1;
  801164:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  80116b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80116e:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  801171:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  801174:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  801177:	8b 45 08             	mov    0x8(%ebp),%eax
  80117a:	b9 0a 00 00 00       	mov    $0xa,%ecx
  80117f:	99                   	cltd   
  801180:	f7 f9                	idiv   %ecx
  801182:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  801185:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801188:	8d 50 01             	lea    0x1(%eax),%edx
  80118b:	89 55 f8             	mov    %edx,-0x8(%ebp)
  80118e:	89 c2                	mov    %eax,%edx
  801190:	8b 45 0c             	mov    0xc(%ebp),%eax
  801193:	01 d0                	add    %edx,%eax
  801195:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801198:	83 c2 30             	add    $0x30,%edx
  80119b:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  80119d:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8011a0:	b8 67 66 66 66       	mov    $0x66666667,%eax
  8011a5:	f7 e9                	imul   %ecx
  8011a7:	c1 fa 02             	sar    $0x2,%edx
  8011aa:	89 c8                	mov    %ecx,%eax
  8011ac:	c1 f8 1f             	sar    $0x1f,%eax
  8011af:	29 c2                	sub    %eax,%edx
  8011b1:	89 d0                	mov    %edx,%eax
  8011b3:	89 45 08             	mov    %eax,0x8(%ebp)
	} while (value % 10 != 0);
  8011b6:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8011b9:	b8 67 66 66 66       	mov    $0x66666667,%eax
  8011be:	f7 e9                	imul   %ecx
  8011c0:	c1 fa 02             	sar    $0x2,%edx
  8011c3:	89 c8                	mov    %ecx,%eax
  8011c5:	c1 f8 1f             	sar    $0x1f,%eax
  8011c8:	29 c2                	sub    %eax,%edx
  8011ca:	89 d0                	mov    %edx,%eax
  8011cc:	c1 e0 02             	shl    $0x2,%eax
  8011cf:	01 d0                	add    %edx,%eax
  8011d1:	01 c0                	add    %eax,%eax
  8011d3:	29 c1                	sub    %eax,%ecx
  8011d5:	89 ca                	mov    %ecx,%edx
  8011d7:	85 d2                	test   %edx,%edx
  8011d9:	75 9c                	jne    801177 <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  8011db:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  8011e2:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8011e5:	48                   	dec    %eax
  8011e6:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  8011e9:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  8011ed:	74 3d                	je     80122c <ltostr+0xe2>
		start = 1 ;
  8011ef:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  8011f6:	eb 34                	jmp    80122c <ltostr+0xe2>
	{
		char tmp = str[start] ;
  8011f8:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8011fb:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011fe:	01 d0                	add    %edx,%eax
  801200:	8a 00                	mov    (%eax),%al
  801202:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  801205:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801208:	8b 45 0c             	mov    0xc(%ebp),%eax
  80120b:	01 c2                	add    %eax,%edx
  80120d:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  801210:	8b 45 0c             	mov    0xc(%ebp),%eax
  801213:	01 c8                	add    %ecx,%eax
  801215:	8a 00                	mov    (%eax),%al
  801217:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  801219:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80121c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80121f:	01 c2                	add    %eax,%edx
  801221:	8a 45 eb             	mov    -0x15(%ebp),%al
  801224:	88 02                	mov    %al,(%edx)
		start++ ;
  801226:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  801229:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  80122c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80122f:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801232:	7c c4                	jl     8011f8 <ltostr+0xae>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  801234:	8b 55 f8             	mov    -0x8(%ebp),%edx
  801237:	8b 45 0c             	mov    0xc(%ebp),%eax
  80123a:	01 d0                	add    %edx,%eax
  80123c:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  80123f:	90                   	nop
  801240:	c9                   	leave  
  801241:	c3                   	ret    

00801242 <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  801242:	55                   	push   %ebp
  801243:	89 e5                	mov    %esp,%ebp
  801245:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  801248:	ff 75 08             	pushl  0x8(%ebp)
  80124b:	e8 54 fa ff ff       	call   800ca4 <strlen>
  801250:	83 c4 04             	add    $0x4,%esp
  801253:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  801256:	ff 75 0c             	pushl  0xc(%ebp)
  801259:	e8 46 fa ff ff       	call   800ca4 <strlen>
  80125e:	83 c4 04             	add    $0x4,%esp
  801261:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  801264:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  80126b:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801272:	eb 17                	jmp    80128b <strcconcat+0x49>
		final[s] = str1[s] ;
  801274:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801277:	8b 45 10             	mov    0x10(%ebp),%eax
  80127a:	01 c2                	add    %eax,%edx
  80127c:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  80127f:	8b 45 08             	mov    0x8(%ebp),%eax
  801282:	01 c8                	add    %ecx,%eax
  801284:	8a 00                	mov    (%eax),%al
  801286:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  801288:	ff 45 fc             	incl   -0x4(%ebp)
  80128b:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80128e:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  801291:	7c e1                	jl     801274 <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  801293:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  80129a:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  8012a1:	eb 1f                	jmp    8012c2 <strcconcat+0x80>
		final[s++] = str2[i] ;
  8012a3:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8012a6:	8d 50 01             	lea    0x1(%eax),%edx
  8012a9:	89 55 fc             	mov    %edx,-0x4(%ebp)
  8012ac:	89 c2                	mov    %eax,%edx
  8012ae:	8b 45 10             	mov    0x10(%ebp),%eax
  8012b1:	01 c2                	add    %eax,%edx
  8012b3:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  8012b6:	8b 45 0c             	mov    0xc(%ebp),%eax
  8012b9:	01 c8                	add    %ecx,%eax
  8012bb:	8a 00                	mov    (%eax),%al
  8012bd:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  8012bf:	ff 45 f8             	incl   -0x8(%ebp)
  8012c2:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8012c5:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8012c8:	7c d9                	jl     8012a3 <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  8012ca:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8012cd:	8b 45 10             	mov    0x10(%ebp),%eax
  8012d0:	01 d0                	add    %edx,%eax
  8012d2:	c6 00 00             	movb   $0x0,(%eax)
}
  8012d5:	90                   	nop
  8012d6:	c9                   	leave  
  8012d7:	c3                   	ret    

008012d8 <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  8012d8:	55                   	push   %ebp
  8012d9:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  8012db:	8b 45 14             	mov    0x14(%ebp),%eax
  8012de:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  8012e4:	8b 45 14             	mov    0x14(%ebp),%eax
  8012e7:	8b 00                	mov    (%eax),%eax
  8012e9:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8012f0:	8b 45 10             	mov    0x10(%ebp),%eax
  8012f3:	01 d0                	add    %edx,%eax
  8012f5:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  8012fb:	eb 0c                	jmp    801309 <strsplit+0x31>
			*string++ = 0;
  8012fd:	8b 45 08             	mov    0x8(%ebp),%eax
  801300:	8d 50 01             	lea    0x1(%eax),%edx
  801303:	89 55 08             	mov    %edx,0x8(%ebp)
  801306:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801309:	8b 45 08             	mov    0x8(%ebp),%eax
  80130c:	8a 00                	mov    (%eax),%al
  80130e:	84 c0                	test   %al,%al
  801310:	74 18                	je     80132a <strsplit+0x52>
  801312:	8b 45 08             	mov    0x8(%ebp),%eax
  801315:	8a 00                	mov    (%eax),%al
  801317:	0f be c0             	movsbl %al,%eax
  80131a:	50                   	push   %eax
  80131b:	ff 75 0c             	pushl  0xc(%ebp)
  80131e:	e8 13 fb ff ff       	call   800e36 <strchr>
  801323:	83 c4 08             	add    $0x8,%esp
  801326:	85 c0                	test   %eax,%eax
  801328:	75 d3                	jne    8012fd <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  80132a:	8b 45 08             	mov    0x8(%ebp),%eax
  80132d:	8a 00                	mov    (%eax),%al
  80132f:	84 c0                	test   %al,%al
  801331:	74 5a                	je     80138d <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  801333:	8b 45 14             	mov    0x14(%ebp),%eax
  801336:	8b 00                	mov    (%eax),%eax
  801338:	83 f8 0f             	cmp    $0xf,%eax
  80133b:	75 07                	jne    801344 <strsplit+0x6c>
		{
			return 0;
  80133d:	b8 00 00 00 00       	mov    $0x0,%eax
  801342:	eb 66                	jmp    8013aa <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  801344:	8b 45 14             	mov    0x14(%ebp),%eax
  801347:	8b 00                	mov    (%eax),%eax
  801349:	8d 48 01             	lea    0x1(%eax),%ecx
  80134c:	8b 55 14             	mov    0x14(%ebp),%edx
  80134f:	89 0a                	mov    %ecx,(%edx)
  801351:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801358:	8b 45 10             	mov    0x10(%ebp),%eax
  80135b:	01 c2                	add    %eax,%edx
  80135d:	8b 45 08             	mov    0x8(%ebp),%eax
  801360:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  801362:	eb 03                	jmp    801367 <strsplit+0x8f>
			string++;
  801364:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  801367:	8b 45 08             	mov    0x8(%ebp),%eax
  80136a:	8a 00                	mov    (%eax),%al
  80136c:	84 c0                	test   %al,%al
  80136e:	74 8b                	je     8012fb <strsplit+0x23>
  801370:	8b 45 08             	mov    0x8(%ebp),%eax
  801373:	8a 00                	mov    (%eax),%al
  801375:	0f be c0             	movsbl %al,%eax
  801378:	50                   	push   %eax
  801379:	ff 75 0c             	pushl  0xc(%ebp)
  80137c:	e8 b5 fa ff ff       	call   800e36 <strchr>
  801381:	83 c4 08             	add    $0x8,%esp
  801384:	85 c0                	test   %eax,%eax
  801386:	74 dc                	je     801364 <strsplit+0x8c>
			string++;
	}
  801388:	e9 6e ff ff ff       	jmp    8012fb <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  80138d:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  80138e:	8b 45 14             	mov    0x14(%ebp),%eax
  801391:	8b 00                	mov    (%eax),%eax
  801393:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80139a:	8b 45 10             	mov    0x10(%ebp),%eax
  80139d:	01 d0                	add    %edx,%eax
  80139f:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  8013a5:	b8 01 00 00 00       	mov    $0x1,%eax
}
  8013aa:	c9                   	leave  
  8013ab:	c3                   	ret    

008013ac <InitializeUHeap>:
//============================== GIVEN FUNCTIONS ===================================//
//==================================================================================//

int FirstTimeFlag = 1;
void InitializeUHeap()
{
  8013ac:	55                   	push   %ebp
  8013ad:	89 e5                	mov    %esp,%ebp
  8013af:	83 ec 08             	sub    $0x8,%esp
	if(FirstTimeFlag)
  8013b2:	a1 04 40 80 00       	mov    0x804004,%eax
  8013b7:	85 c0                	test   %eax,%eax
  8013b9:	74 1f                	je     8013da <InitializeUHeap+0x2e>
	{
		initialize_dyn_block_system();
  8013bb:	e8 1d 00 00 00       	call   8013dd <initialize_dyn_block_system>
		cprintf("DYNAMIC BLOCK SYSTEM IS INITIALIZED\n");
  8013c0:	83 ec 0c             	sub    $0xc,%esp
  8013c3:	68 70 39 80 00       	push   $0x803970
  8013c8:	e8 55 f2 ff ff       	call   800622 <cprintf>
  8013cd:	83 c4 10             	add    $0x10,%esp
#if UHP_USE_BUDDY
		initialize_buddy();
		cprintf("BUDDY SYSTEM IS INITIALIZED\n");
#endif
		FirstTimeFlag = 0;
  8013d0:	c7 05 04 40 80 00 00 	movl   $0x0,0x804004
  8013d7:	00 00 00 
	}
}
  8013da:	90                   	nop
  8013db:	c9                   	leave  
  8013dc:	c3                   	ret    

008013dd <initialize_dyn_block_system>:

//=================================
// [1] INITIALIZE DYNAMIC ALLOCATOR:
//=================================
void initialize_dyn_block_system()
{
  8013dd:	55                   	push   %ebp
  8013de:	89 e5                	mov    %esp,%ebp
  8013e0:	83 ec 28             	sub    $0x28,%esp
	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] initialize_dyn_block_system
	// your code is here, remove the panic and write your code
	//panic("initialize_dyn_block_system() is not implemented yet...!!");

	LIST_INIT(&AllocMemBlocksList);
  8013e3:	c7 05 40 40 80 00 00 	movl   $0x0,0x804040
  8013ea:	00 00 00 
  8013ed:	c7 05 44 40 80 00 00 	movl   $0x0,0x804044
  8013f4:	00 00 00 
  8013f7:	c7 05 4c 40 80 00 00 	movl   $0x0,0x80404c
  8013fe:	00 00 00 
	LIST_INIT(&FreeMemBlocksList);
  801401:	c7 05 38 41 80 00 00 	movl   $0x0,0x804138
  801408:	00 00 00 
  80140b:	c7 05 3c 41 80 00 00 	movl   $0x0,0x80413c
  801412:	00 00 00 
  801415:	c7 05 44 41 80 00 00 	movl   $0x0,0x804144
  80141c:	00 00 00 
	MAX_MEM_BLOCK_CNT = NUM_OF_UHEAP_PAGES;
  80141f:	c7 05 20 41 80 00 00 	movl   $0x20000,0x804120
  801426:	00 02 00 
	MemBlockNodes = (void*)USER_DYN_BLKS_ARRAY;
  801429:	c7 45 f4 00 00 e0 7f 	movl   $0x7fe00000,-0xc(%ebp)
  801430:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801433:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801438:	2d 00 10 00 00       	sub    $0x1000,%eax
  80143d:	a3 50 40 80 00       	mov    %eax,0x804050
	int size_of_block = sizeof(struct MemBlock);
  801442:	c7 45 f0 10 00 00 00 	movl   $0x10,-0x10(%ebp)
	int size_all_struct = size_of_block*MAX_MEM_BLOCK_CNT;
  801449:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80144c:	a1 20 41 80 00       	mov    0x804120,%eax
  801451:	0f af c2             	imul   %edx,%eax
  801454:	89 45 ec             	mov    %eax,-0x14(%ebp)
	size_all_struct = ROUNDUP(size_all_struct, PAGE_SIZE);
  801457:	c7 45 e8 00 10 00 00 	movl   $0x1000,-0x18(%ebp)
  80145e:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801461:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801464:	01 d0                	add    %edx,%eax
  801466:	48                   	dec    %eax
  801467:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  80146a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80146d:	ba 00 00 00 00       	mov    $0x0,%edx
  801472:	f7 75 e8             	divl   -0x18(%ebp)
  801475:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801478:	29 d0                	sub    %edx,%eax
  80147a:	89 45 ec             	mov    %eax,-0x14(%ebp)
	sys_allocate_chunk(USER_DYN_BLKS_ARRAY, size_all_struct,PERM_USER| PERM_WRITEABLE);
  80147d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801480:	c7 45 e0 00 00 e0 7f 	movl   $0x7fe00000,-0x20(%ebp)
  801487:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80148a:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
  801490:	81 ea 00 10 00 00    	sub    $0x1000,%edx
  801496:	83 ec 04             	sub    $0x4,%esp
  801499:	6a 06                	push   $0x6
  80149b:	50                   	push   %eax
  80149c:	52                   	push   %edx
  80149d:	e8 a1 05 00 00       	call   801a43 <sys_allocate_chunk>
  8014a2:	83 c4 10             	add    $0x10,%esp
	initialize_MemBlocksList(MAX_MEM_BLOCK_CNT);
  8014a5:	a1 20 41 80 00       	mov    0x804120,%eax
  8014aa:	83 ec 0c             	sub    $0xc,%esp
  8014ad:	50                   	push   %eax
  8014ae:	e8 16 0c 00 00       	call   8020c9 <initialize_MemBlocksList>
  8014b3:	83 c4 10             	add    $0x10,%esp
	struct MemBlock* ourBlock =LIST_LAST(&AvailableMemBlocksList);
  8014b6:	a1 4c 41 80 00       	mov    0x80414c,%eax
  8014bb:	89 45 dc             	mov    %eax,-0x24(%ebp)
	LIST_REMOVE(&AvailableMemBlocksList,ourBlock);
  8014be:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  8014c2:	75 14                	jne    8014d8 <initialize_dyn_block_system+0xfb>
  8014c4:	83 ec 04             	sub    $0x4,%esp
  8014c7:	68 95 39 80 00       	push   $0x803995
  8014cc:	6a 2d                	push   $0x2d
  8014ce:	68 b3 39 80 00       	push   $0x8039b3
  8014d3:	e8 70 1a 00 00       	call   802f48 <_panic>
  8014d8:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8014db:	8b 00                	mov    (%eax),%eax
  8014dd:	85 c0                	test   %eax,%eax
  8014df:	74 10                	je     8014f1 <initialize_dyn_block_system+0x114>
  8014e1:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8014e4:	8b 00                	mov    (%eax),%eax
  8014e6:	8b 55 dc             	mov    -0x24(%ebp),%edx
  8014e9:	8b 52 04             	mov    0x4(%edx),%edx
  8014ec:	89 50 04             	mov    %edx,0x4(%eax)
  8014ef:	eb 0b                	jmp    8014fc <initialize_dyn_block_system+0x11f>
  8014f1:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8014f4:	8b 40 04             	mov    0x4(%eax),%eax
  8014f7:	a3 4c 41 80 00       	mov    %eax,0x80414c
  8014fc:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8014ff:	8b 40 04             	mov    0x4(%eax),%eax
  801502:	85 c0                	test   %eax,%eax
  801504:	74 0f                	je     801515 <initialize_dyn_block_system+0x138>
  801506:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801509:	8b 40 04             	mov    0x4(%eax),%eax
  80150c:	8b 55 dc             	mov    -0x24(%ebp),%edx
  80150f:	8b 12                	mov    (%edx),%edx
  801511:	89 10                	mov    %edx,(%eax)
  801513:	eb 0a                	jmp    80151f <initialize_dyn_block_system+0x142>
  801515:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801518:	8b 00                	mov    (%eax),%eax
  80151a:	a3 48 41 80 00       	mov    %eax,0x804148
  80151f:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801522:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  801528:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80152b:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  801532:	a1 54 41 80 00       	mov    0x804154,%eax
  801537:	48                   	dec    %eax
  801538:	a3 54 41 80 00       	mov    %eax,0x804154
	ourBlock->size = USER_HEAP_MAX-USER_HEAP_START;
  80153d:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801540:	c7 40 0c 00 00 00 20 	movl   $0x20000000,0xc(%eax)
	ourBlock->sva=USER_HEAP_START;
  801547:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80154a:	c7 40 08 00 00 00 80 	movl   $0x80000000,0x8(%eax)
	LIST_INSERT_TAIL(&FreeMemBlocksList, ourBlock);
  801551:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  801555:	75 14                	jne    80156b <initialize_dyn_block_system+0x18e>
  801557:	83 ec 04             	sub    $0x4,%esp
  80155a:	68 c0 39 80 00       	push   $0x8039c0
  80155f:	6a 30                	push   $0x30
  801561:	68 b3 39 80 00       	push   $0x8039b3
  801566:	e8 dd 19 00 00       	call   802f48 <_panic>
  80156b:	8b 15 3c 41 80 00    	mov    0x80413c,%edx
  801571:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801574:	89 50 04             	mov    %edx,0x4(%eax)
  801577:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80157a:	8b 40 04             	mov    0x4(%eax),%eax
  80157d:	85 c0                	test   %eax,%eax
  80157f:	74 0c                	je     80158d <initialize_dyn_block_system+0x1b0>
  801581:	a1 3c 41 80 00       	mov    0x80413c,%eax
  801586:	8b 55 dc             	mov    -0x24(%ebp),%edx
  801589:	89 10                	mov    %edx,(%eax)
  80158b:	eb 08                	jmp    801595 <initialize_dyn_block_system+0x1b8>
  80158d:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801590:	a3 38 41 80 00       	mov    %eax,0x804138
  801595:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801598:	a3 3c 41 80 00       	mov    %eax,0x80413c
  80159d:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8015a0:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8015a6:	a1 44 41 80 00       	mov    0x804144,%eax
  8015ab:	40                   	inc    %eax
  8015ac:	a3 44 41 80 00       	mov    %eax,0x804144
	//[1] Initialize two lists (AllocMemBlocksList & FreeMemBlocksList) [Hint: use LIST_INIT()]
	//[2] Dynamically allocate the array of MemBlockNodes at VA USER_DYN_BLKS_ARRAY
	//	  (remember to set MAX_MEM_BLOCK_CNT with the chosen size of the array)
	//[3] Initialize AvailableMemBlocksList by filling it with the MemBlockNodes
	//[4] Insert a new MemBlock with the heap size into the FreeMemBlocksList
}
  8015b1:	90                   	nop
  8015b2:	c9                   	leave  
  8015b3:	c3                   	ret    

008015b4 <malloc>:
//=================================
// [2] ALLOCATE SPACE IN USER HEAP:
//=================================

void* malloc(uint32 size)
{
  8015b4:	55                   	push   %ebp
  8015b5:	89 e5                	mov    %esp,%ebp
  8015b7:	83 ec 18             	sub    $0x18,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  8015ba:	e8 ed fd ff ff       	call   8013ac <InitializeUHeap>
	if (size == 0) return NULL ;
  8015bf:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8015c3:	75 07                	jne    8015cc <malloc+0x18>
  8015c5:	b8 00 00 00 00       	mov    $0x0,%eax
  8015ca:	eb 67                	jmp    801633 <malloc+0x7f>

	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] malloc
	// your code is here, remove the panic and write your code
	//panic("malloc() is not implemented yet...!!");

	size = ROUNDUP(size, PAGE_SIZE);
  8015cc:	c7 45 f4 00 10 00 00 	movl   $0x1000,-0xc(%ebp)
  8015d3:	8b 55 08             	mov    0x8(%ebp),%edx
  8015d6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8015d9:	01 d0                	add    %edx,%eax
  8015db:	48                   	dec    %eax
  8015dc:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8015df:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8015e2:	ba 00 00 00 00       	mov    $0x0,%edx
  8015e7:	f7 75 f4             	divl   -0xc(%ebp)
  8015ea:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8015ed:	29 d0                	sub    %edx,%eax
  8015ef:	89 45 08             	mov    %eax,0x8(%ebp)
	if(sys_isUHeapPlacementStrategyFIRSTFIT())
  8015f2:	e8 1a 08 00 00       	call   801e11 <sys_isUHeapPlacementStrategyFIRSTFIT>
  8015f7:	85 c0                	test   %eax,%eax
  8015f9:	74 33                	je     80162e <malloc+0x7a>
	{
		struct MemBlock * myBlock = alloc_block_FF(size);
  8015fb:	83 ec 0c             	sub    $0xc,%esp
  8015fe:	ff 75 08             	pushl  0x8(%ebp)
  801601:	e8 0c 0e 00 00       	call   802412 <alloc_block_FF>
  801606:	83 c4 10             	add    $0x10,%esp
  801609:	89 45 ec             	mov    %eax,-0x14(%ebp)
		if(myBlock != NULL)
  80160c:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  801610:	74 1c                	je     80162e <malloc+0x7a>
		{
			insert_sorted_allocList(myBlock);
  801612:	83 ec 0c             	sub    $0xc,%esp
  801615:	ff 75 ec             	pushl  -0x14(%ebp)
  801618:	e8 07 0c 00 00       	call   802224 <insert_sorted_allocList>
  80161d:	83 c4 10             	add    $0x10,%esp
			uint32 ptr = myBlock->sva;
  801620:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801623:	8b 40 08             	mov    0x8(%eax),%eax
  801626:	89 45 e8             	mov    %eax,-0x18(%ebp)
			return (void *)ptr;
  801629:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80162c:	eb 05                	jmp    801633 <malloc+0x7f>
		}
	}
	return NULL;
  80162e:	b8 00 00 00 00       	mov    $0x0,%eax
	//		to the required allocation size (space should be on 4 KB BOUNDARY)
	//	2) if no suitable space found, return NULL
	// 	3) Return pointer containing the virtual address of allocated space,
	//
	//Use sys_isUHeapPlacementStrategyFIRSTFIT()... to check the current strategy
}
  801633:	c9                   	leave  
  801634:	c3                   	ret    

00801635 <free>:
//	We can use sys_free_user_mem(uint32 virtual_address, uint32 size); which
//		switches to the kernel mode, calls free_user_mem() in
//		"kern/mem/chunk_operations.c", then switch back to the user mode here
//	the free_user_mem function is empty, make sure to implement it.
void free(void* virtual_address)
{
  801635:	55                   	push   %ebp
  801636:	89 e5                	mov    %esp,%ebp
  801638:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] free
	// your code is here, remove the panic and write your code
	//panic("free() is not implemented yet...!!");

	uint32 virtualAddress = (uint32 )(virtual_address);
  80163b:	8b 45 08             	mov    0x8(%ebp),%eax
  80163e:	89 45 f4             	mov    %eax,-0xc(%ebp)
//	virtualAddress = ROUNDDOWN(virtualAddress, PAGE_SIZE);
	struct MemBlock * myBlock = find_block(&AllocMemBlocksList, virtualAddress);
  801641:	83 ec 08             	sub    $0x8,%esp
  801644:	ff 75 f4             	pushl  -0xc(%ebp)
  801647:	68 40 40 80 00       	push   $0x804040
  80164c:	e8 5b 0b 00 00       	call   8021ac <find_block>
  801651:	83 c4 10             	add    $0x10,%esp
  801654:	89 45 f0             	mov    %eax,-0x10(%ebp)
//	cprintf ("ptr sva at free user side = %x \n", myBlock->sva);
	sys_free_user_mem(virtualAddress, myBlock->size);
  801657:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80165a:	8b 40 0c             	mov    0xc(%eax),%eax
  80165d:	83 ec 08             	sub    $0x8,%esp
  801660:	50                   	push   %eax
  801661:	ff 75 f4             	pushl  -0xc(%ebp)
  801664:	e8 a2 03 00 00       	call   801a0b <sys_free_user_mem>
  801669:	83 c4 10             	add    $0x10,%esp
	LIST_REMOVE(&AllocMemBlocksList, myBlock);
  80166c:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801670:	75 14                	jne    801686 <free+0x51>
  801672:	83 ec 04             	sub    $0x4,%esp
  801675:	68 95 39 80 00       	push   $0x803995
  80167a:	6a 76                	push   $0x76
  80167c:	68 b3 39 80 00       	push   $0x8039b3
  801681:	e8 c2 18 00 00       	call   802f48 <_panic>
  801686:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801689:	8b 00                	mov    (%eax),%eax
  80168b:	85 c0                	test   %eax,%eax
  80168d:	74 10                	je     80169f <free+0x6a>
  80168f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801692:	8b 00                	mov    (%eax),%eax
  801694:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801697:	8b 52 04             	mov    0x4(%edx),%edx
  80169a:	89 50 04             	mov    %edx,0x4(%eax)
  80169d:	eb 0b                	jmp    8016aa <free+0x75>
  80169f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8016a2:	8b 40 04             	mov    0x4(%eax),%eax
  8016a5:	a3 44 40 80 00       	mov    %eax,0x804044
  8016aa:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8016ad:	8b 40 04             	mov    0x4(%eax),%eax
  8016b0:	85 c0                	test   %eax,%eax
  8016b2:	74 0f                	je     8016c3 <free+0x8e>
  8016b4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8016b7:	8b 40 04             	mov    0x4(%eax),%eax
  8016ba:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8016bd:	8b 12                	mov    (%edx),%edx
  8016bf:	89 10                	mov    %edx,(%eax)
  8016c1:	eb 0a                	jmp    8016cd <free+0x98>
  8016c3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8016c6:	8b 00                	mov    (%eax),%eax
  8016c8:	a3 40 40 80 00       	mov    %eax,0x804040
  8016cd:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8016d0:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8016d6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8016d9:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8016e0:	a1 4c 40 80 00       	mov    0x80404c,%eax
  8016e5:	48                   	dec    %eax
  8016e6:	a3 4c 40 80 00       	mov    %eax,0x80404c
	insert_sorted_with_merge_freeList(myBlock);
  8016eb:	83 ec 0c             	sub    $0xc,%esp
  8016ee:	ff 75 f0             	pushl  -0x10(%ebp)
  8016f1:	e8 0b 14 00 00       	call   802b01 <insert_sorted_with_merge_freeList>
  8016f6:	83 c4 10             	add    $0x10,%esp

	//you should get the size of the given allocation using its address
	//you need to call sys_free_user_mem()
	//refer to the project presentation and documentation for details
}
  8016f9:	90                   	nop
  8016fa:	c9                   	leave  
  8016fb:	c3                   	ret    

008016fc <smalloc>:

//=================================
// [4] ALLOCATE SHARED VARIABLE:
//=================================
void* smalloc(char *sharedVarName, uint32 size, uint8 isWritable)
{
  8016fc:	55                   	push   %ebp
  8016fd:	89 e5                	mov    %esp,%ebp
  8016ff:	83 ec 28             	sub    $0x28,%esp
  801702:	8b 45 10             	mov    0x10(%ebp),%eax
  801705:	88 45 e4             	mov    %al,-0x1c(%ebp)
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801708:	e8 9f fc ff ff       	call   8013ac <InitializeUHeap>
	if (size == 0) return NULL ;
  80170d:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801711:	75 0a                	jne    80171d <smalloc+0x21>
  801713:	b8 00 00 00 00       	mov    $0x0,%eax
  801718:	e9 8d 00 00 00       	jmp    8017aa <smalloc+0xae>

	//This function should find the space of the required range
	// * ON 4KB BOUNDARY **** //
	//Use sys_isUHeapPlacementStrategyFIRSTFIT() to check the current strategy

	size = ROUNDUP(size, PAGE_SIZE);
  80171d:	c7 45 f4 00 10 00 00 	movl   $0x1000,-0xc(%ebp)
  801724:	8b 55 0c             	mov    0xc(%ebp),%edx
  801727:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80172a:	01 d0                	add    %edx,%eax
  80172c:	48                   	dec    %eax
  80172d:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801730:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801733:	ba 00 00 00 00       	mov    $0x0,%edx
  801738:	f7 75 f4             	divl   -0xc(%ebp)
  80173b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80173e:	29 d0                	sub    %edx,%eax
  801740:	89 45 0c             	mov    %eax,0xc(%ebp)
		if(sys_isUHeapPlacementStrategyFIRSTFIT())
  801743:	e8 c9 06 00 00       	call   801e11 <sys_isUHeapPlacementStrategyFIRSTFIT>
  801748:	85 c0                	test   %eax,%eax
  80174a:	74 59                	je     8017a5 <smalloc+0xa9>
		{
			struct MemBlock * v1=NULL;
  80174c:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
			v1= alloc_block_FF(size);
  801753:	83 ec 0c             	sub    $0xc,%esp
  801756:	ff 75 0c             	pushl  0xc(%ebp)
  801759:	e8 b4 0c 00 00       	call   802412 <alloc_block_FF>
  80175e:	83 c4 10             	add    $0x10,%esp
  801761:	89 45 ec             	mov    %eax,-0x14(%ebp)
			if(v1==NULL)
  801764:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  801768:	75 07                	jne    801771 <smalloc+0x75>
			{
				return NULL;
  80176a:	b8 00 00 00 00       	mov    $0x0,%eax
  80176f:	eb 39                	jmp    8017aa <smalloc+0xae>
			}
			else
			{
				int ret=sys_createSharedObject(sharedVarName,  size,  isWritable,(void*)v1->sva);
  801771:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801774:	8b 40 08             	mov    0x8(%eax),%eax
  801777:	89 c2                	mov    %eax,%edx
  801779:	0f b6 45 e4          	movzbl -0x1c(%ebp),%eax
  80177d:	52                   	push   %edx
  80177e:	50                   	push   %eax
  80177f:	ff 75 0c             	pushl  0xc(%ebp)
  801782:	ff 75 08             	pushl  0x8(%ebp)
  801785:	e8 0c 04 00 00       	call   801b96 <sys_createSharedObject>
  80178a:	83 c4 10             	add    $0x10,%esp
  80178d:	89 45 e8             	mov    %eax,-0x18(%ebp)
				if(ret>=0)
  801790:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  801794:	78 08                	js     80179e <smalloc+0xa2>
				{
					return (void*)v1->sva;
  801796:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801799:	8b 40 08             	mov    0x8(%eax),%eax
  80179c:	eb 0c                	jmp    8017aa <smalloc+0xae>
				}
				else
				{
					return NULL;
  80179e:	b8 00 00 00 00       	mov    $0x0,%eax
  8017a3:	eb 05                	jmp    8017aa <smalloc+0xae>
				}
			}

		}
		return NULL;
  8017a5:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8017aa:	c9                   	leave  
  8017ab:	c3                   	ret    

008017ac <sget>:

//========================================
// [5] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
  8017ac:	55                   	push   %ebp
  8017ad:	89 e5                	mov    %esp,%ebp
  8017af:	83 ec 18             	sub    $0x18,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  8017b2:	e8 f5 fb ff ff       	call   8013ac <InitializeUHeap>

	//This function should find the space for sharing the variable
	// *** ON 4KB BOUNDARY ******** //

	//Use sys_isUHeapPlacementStrategyFIRSTFIT() to check the current strategy
	int ret=sys_getSizeOfSharedObject(ownerEnvID,sharedVarName);
  8017b7:	83 ec 08             	sub    $0x8,%esp
  8017ba:	ff 75 0c             	pushl  0xc(%ebp)
  8017bd:	ff 75 08             	pushl  0x8(%ebp)
  8017c0:	e8 fb 03 00 00       	call   801bc0 <sys_getSizeOfSharedObject>
  8017c5:	83 c4 10             	add    $0x10,%esp
  8017c8:	89 45 f4             	mov    %eax,-0xc(%ebp)
	if(ret==0)
  8017cb:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8017cf:	75 07                	jne    8017d8 <sget+0x2c>
	{
		return NULL;
  8017d1:	b8 00 00 00 00       	mov    $0x0,%eax
  8017d6:	eb 64                	jmp    80183c <sget+0x90>
	}
	if(sys_isUHeapPlacementStrategyFIRSTFIT())
  8017d8:	e8 34 06 00 00       	call   801e11 <sys_isUHeapPlacementStrategyFIRSTFIT>
  8017dd:	85 c0                	test   %eax,%eax
  8017df:	74 56                	je     801837 <sget+0x8b>
	{
		struct MemBlock * v1=NULL;
  8017e1:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
		v1= alloc_block_FF(ret);
  8017e8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8017eb:	83 ec 0c             	sub    $0xc,%esp
  8017ee:	50                   	push   %eax
  8017ef:	e8 1e 0c 00 00       	call   802412 <alloc_block_FF>
  8017f4:	83 c4 10             	add    $0x10,%esp
  8017f7:	89 45 f0             	mov    %eax,-0x10(%ebp)
		if(v1==NULL)
  8017fa:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8017fe:	75 07                	jne    801807 <sget+0x5b>
		{
		return NULL;
  801800:	b8 00 00 00 00       	mov    $0x0,%eax
  801805:	eb 35                	jmp    80183c <sget+0x90>
	    }
		else
		{
			int ret1=sys_getSharedObject(ownerEnvID,sharedVarName,(void*)v1->sva);
  801807:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80180a:	8b 40 08             	mov    0x8(%eax),%eax
  80180d:	83 ec 04             	sub    $0x4,%esp
  801810:	50                   	push   %eax
  801811:	ff 75 0c             	pushl  0xc(%ebp)
  801814:	ff 75 08             	pushl  0x8(%ebp)
  801817:	e8 c1 03 00 00       	call   801bdd <sys_getSharedObject>
  80181c:	83 c4 10             	add    $0x10,%esp
  80181f:	89 45 ec             	mov    %eax,-0x14(%ebp)
			if(ret1>=0)
  801822:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  801826:	78 08                	js     801830 <sget+0x84>
			{
				return (void*)v1->sva;
  801828:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80182b:	8b 40 08             	mov    0x8(%eax),%eax
  80182e:	eb 0c                	jmp    80183c <sget+0x90>
			}
			else
			{
				return NULL;
  801830:	b8 00 00 00 00       	mov    $0x0,%eax
  801835:	eb 05                	jmp    80183c <sget+0x90>
			}
		}
	}
  return NULL;
  801837:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80183c:	c9                   	leave  
  80183d:	c3                   	ret    

0080183e <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  80183e:	55                   	push   %ebp
  80183f:	89 e5                	mov    %esp,%ebp
  801841:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801844:	e8 63 fb ff ff       	call   8013ac <InitializeUHeap>
	//==============================================================
	// [USER HEAP - USER SIDE] realloc
	// Write your code here, remove the panic and write your code
	panic("realloc() is not implemented yet...!!");
  801849:	83 ec 04             	sub    $0x4,%esp
  80184c:	68 e4 39 80 00       	push   $0x8039e4
  801851:	68 0e 01 00 00       	push   $0x10e
  801856:	68 b3 39 80 00       	push   $0x8039b3
  80185b:	e8 e8 16 00 00       	call   802f48 <_panic>

00801860 <sfree>:
//	use sys_freeSharedObject(...); which switches to the kernel mode,
//	calls freeSharedObject(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the freeSharedObject() function is empty, make sure to implement it.

void sfree(void* virtual_address)
{
  801860:	55                   	push   %ebp
  801861:	89 e5                	mov    %esp,%ebp
  801863:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT MS3 - BONUS] [SHARING - USER SIDE] sfree()

	// Write your code here, remove the panic and write your code
	panic("sfree() is not implemented yet...!!");
  801866:	83 ec 04             	sub    $0x4,%esp
  801869:	68 0c 3a 80 00       	push   $0x803a0c
  80186e:	68 22 01 00 00       	push   $0x122
  801873:	68 b3 39 80 00       	push   $0x8039b3
  801878:	e8 cb 16 00 00       	call   802f48 <_panic>

0080187d <expand>:

//==================================================================================//
//========================== MODIFICATION FUNCTIONS ================================//
//==================================================================================//
void expand(uint32 newSize)
{
  80187d:	55                   	push   %ebp
  80187e:	89 e5                	mov    %esp,%ebp
  801880:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801883:	83 ec 04             	sub    $0x4,%esp
  801886:	68 30 3a 80 00       	push   $0x803a30
  80188b:	68 2d 01 00 00       	push   $0x12d
  801890:	68 b3 39 80 00       	push   $0x8039b3
  801895:	e8 ae 16 00 00       	call   802f48 <_panic>

0080189a <shrink>:

}
void shrink(uint32 newSize)
{
  80189a:	55                   	push   %ebp
  80189b:	89 e5                	mov    %esp,%ebp
  80189d:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  8018a0:	83 ec 04             	sub    $0x4,%esp
  8018a3:	68 30 3a 80 00       	push   $0x803a30
  8018a8:	68 32 01 00 00       	push   $0x132
  8018ad:	68 b3 39 80 00       	push   $0x8039b3
  8018b2:	e8 91 16 00 00       	call   802f48 <_panic>

008018b7 <freeHeap>:

}
void freeHeap(void* virtual_address)
{
  8018b7:	55                   	push   %ebp
  8018b8:	89 e5                	mov    %esp,%ebp
  8018ba:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  8018bd:	83 ec 04             	sub    $0x4,%esp
  8018c0:	68 30 3a 80 00       	push   $0x803a30
  8018c5:	68 37 01 00 00       	push   $0x137
  8018ca:	68 b3 39 80 00       	push   $0x8039b3
  8018cf:	e8 74 16 00 00       	call   802f48 <_panic>

008018d4 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  8018d4:	55                   	push   %ebp
  8018d5:	89 e5                	mov    %esp,%ebp
  8018d7:	57                   	push   %edi
  8018d8:	56                   	push   %esi
  8018d9:	53                   	push   %ebx
  8018da:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8018dd:	8b 45 08             	mov    0x8(%ebp),%eax
  8018e0:	8b 55 0c             	mov    0xc(%ebp),%edx
  8018e3:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8018e6:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8018e9:	8b 7d 18             	mov    0x18(%ebp),%edi
  8018ec:	8b 75 1c             	mov    0x1c(%ebp),%esi
  8018ef:	cd 30                	int    $0x30
  8018f1:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  8018f4:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8018f7:	83 c4 10             	add    $0x10,%esp
  8018fa:	5b                   	pop    %ebx
  8018fb:	5e                   	pop    %esi
  8018fc:	5f                   	pop    %edi
  8018fd:	5d                   	pop    %ebp
  8018fe:	c3                   	ret    

008018ff <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  8018ff:	55                   	push   %ebp
  801900:	89 e5                	mov    %esp,%ebp
  801902:	83 ec 04             	sub    $0x4,%esp
  801905:	8b 45 10             	mov    0x10(%ebp),%eax
  801908:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  80190b:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  80190f:	8b 45 08             	mov    0x8(%ebp),%eax
  801912:	6a 00                	push   $0x0
  801914:	6a 00                	push   $0x0
  801916:	52                   	push   %edx
  801917:	ff 75 0c             	pushl  0xc(%ebp)
  80191a:	50                   	push   %eax
  80191b:	6a 00                	push   $0x0
  80191d:	e8 b2 ff ff ff       	call   8018d4 <syscall>
  801922:	83 c4 18             	add    $0x18,%esp
}
  801925:	90                   	nop
  801926:	c9                   	leave  
  801927:	c3                   	ret    

00801928 <sys_cgetc>:

int
sys_cgetc(void)
{
  801928:	55                   	push   %ebp
  801929:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  80192b:	6a 00                	push   $0x0
  80192d:	6a 00                	push   $0x0
  80192f:	6a 00                	push   $0x0
  801931:	6a 00                	push   $0x0
  801933:	6a 00                	push   $0x0
  801935:	6a 01                	push   $0x1
  801937:	e8 98 ff ff ff       	call   8018d4 <syscall>
  80193c:	83 c4 18             	add    $0x18,%esp
}
  80193f:	c9                   	leave  
  801940:	c3                   	ret    

00801941 <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  801941:	55                   	push   %ebp
  801942:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  801944:	8b 55 0c             	mov    0xc(%ebp),%edx
  801947:	8b 45 08             	mov    0x8(%ebp),%eax
  80194a:	6a 00                	push   $0x0
  80194c:	6a 00                	push   $0x0
  80194e:	6a 00                	push   $0x0
  801950:	52                   	push   %edx
  801951:	50                   	push   %eax
  801952:	6a 05                	push   $0x5
  801954:	e8 7b ff ff ff       	call   8018d4 <syscall>
  801959:	83 c4 18             	add    $0x18,%esp
}
  80195c:	c9                   	leave  
  80195d:	c3                   	ret    

0080195e <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  80195e:	55                   	push   %ebp
  80195f:	89 e5                	mov    %esp,%ebp
  801961:	56                   	push   %esi
  801962:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  801963:	8b 75 18             	mov    0x18(%ebp),%esi
  801966:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801969:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80196c:	8b 55 0c             	mov    0xc(%ebp),%edx
  80196f:	8b 45 08             	mov    0x8(%ebp),%eax
  801972:	56                   	push   %esi
  801973:	53                   	push   %ebx
  801974:	51                   	push   %ecx
  801975:	52                   	push   %edx
  801976:	50                   	push   %eax
  801977:	6a 06                	push   $0x6
  801979:	e8 56 ff ff ff       	call   8018d4 <syscall>
  80197e:	83 c4 18             	add    $0x18,%esp
}
  801981:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801984:	5b                   	pop    %ebx
  801985:	5e                   	pop    %esi
  801986:	5d                   	pop    %ebp
  801987:	c3                   	ret    

00801988 <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  801988:	55                   	push   %ebp
  801989:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  80198b:	8b 55 0c             	mov    0xc(%ebp),%edx
  80198e:	8b 45 08             	mov    0x8(%ebp),%eax
  801991:	6a 00                	push   $0x0
  801993:	6a 00                	push   $0x0
  801995:	6a 00                	push   $0x0
  801997:	52                   	push   %edx
  801998:	50                   	push   %eax
  801999:	6a 07                	push   $0x7
  80199b:	e8 34 ff ff ff       	call   8018d4 <syscall>
  8019a0:	83 c4 18             	add    $0x18,%esp
}
  8019a3:	c9                   	leave  
  8019a4:	c3                   	ret    

008019a5 <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  8019a5:	55                   	push   %ebp
  8019a6:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  8019a8:	6a 00                	push   $0x0
  8019aa:	6a 00                	push   $0x0
  8019ac:	6a 00                	push   $0x0
  8019ae:	ff 75 0c             	pushl  0xc(%ebp)
  8019b1:	ff 75 08             	pushl  0x8(%ebp)
  8019b4:	6a 08                	push   $0x8
  8019b6:	e8 19 ff ff ff       	call   8018d4 <syscall>
  8019bb:	83 c4 18             	add    $0x18,%esp
}
  8019be:	c9                   	leave  
  8019bf:	c3                   	ret    

008019c0 <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  8019c0:	55                   	push   %ebp
  8019c1:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  8019c3:	6a 00                	push   $0x0
  8019c5:	6a 00                	push   $0x0
  8019c7:	6a 00                	push   $0x0
  8019c9:	6a 00                	push   $0x0
  8019cb:	6a 00                	push   $0x0
  8019cd:	6a 09                	push   $0x9
  8019cf:	e8 00 ff ff ff       	call   8018d4 <syscall>
  8019d4:	83 c4 18             	add    $0x18,%esp
}
  8019d7:	c9                   	leave  
  8019d8:	c3                   	ret    

008019d9 <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  8019d9:	55                   	push   %ebp
  8019da:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  8019dc:	6a 00                	push   $0x0
  8019de:	6a 00                	push   $0x0
  8019e0:	6a 00                	push   $0x0
  8019e2:	6a 00                	push   $0x0
  8019e4:	6a 00                	push   $0x0
  8019e6:	6a 0a                	push   $0xa
  8019e8:	e8 e7 fe ff ff       	call   8018d4 <syscall>
  8019ed:	83 c4 18             	add    $0x18,%esp
}
  8019f0:	c9                   	leave  
  8019f1:	c3                   	ret    

008019f2 <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  8019f2:	55                   	push   %ebp
  8019f3:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  8019f5:	6a 00                	push   $0x0
  8019f7:	6a 00                	push   $0x0
  8019f9:	6a 00                	push   $0x0
  8019fb:	6a 00                	push   $0x0
  8019fd:	6a 00                	push   $0x0
  8019ff:	6a 0b                	push   $0xb
  801a01:	e8 ce fe ff ff       	call   8018d4 <syscall>
  801a06:	83 c4 18             	add    $0x18,%esp
}
  801a09:	c9                   	leave  
  801a0a:	c3                   	ret    

00801a0b <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  801a0b:	55                   	push   %ebp
  801a0c:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  801a0e:	6a 00                	push   $0x0
  801a10:	6a 00                	push   $0x0
  801a12:	6a 00                	push   $0x0
  801a14:	ff 75 0c             	pushl  0xc(%ebp)
  801a17:	ff 75 08             	pushl  0x8(%ebp)
  801a1a:	6a 0f                	push   $0xf
  801a1c:	e8 b3 fe ff ff       	call   8018d4 <syscall>
  801a21:	83 c4 18             	add    $0x18,%esp
	return;
  801a24:	90                   	nop
}
  801a25:	c9                   	leave  
  801a26:	c3                   	ret    

00801a27 <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  801a27:	55                   	push   %ebp
  801a28:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  801a2a:	6a 00                	push   $0x0
  801a2c:	6a 00                	push   $0x0
  801a2e:	6a 00                	push   $0x0
  801a30:	ff 75 0c             	pushl  0xc(%ebp)
  801a33:	ff 75 08             	pushl  0x8(%ebp)
  801a36:	6a 10                	push   $0x10
  801a38:	e8 97 fe ff ff       	call   8018d4 <syscall>
  801a3d:	83 c4 18             	add    $0x18,%esp
	return ;
  801a40:	90                   	nop
}
  801a41:	c9                   	leave  
  801a42:	c3                   	ret    

00801a43 <sys_allocate_chunk>:

void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  801a43:	55                   	push   %ebp
  801a44:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  801a46:	6a 00                	push   $0x0
  801a48:	6a 00                	push   $0x0
  801a4a:	ff 75 10             	pushl  0x10(%ebp)
  801a4d:	ff 75 0c             	pushl  0xc(%ebp)
  801a50:	ff 75 08             	pushl  0x8(%ebp)
  801a53:	6a 11                	push   $0x11
  801a55:	e8 7a fe ff ff       	call   8018d4 <syscall>
  801a5a:	83 c4 18             	add    $0x18,%esp
	return ;
  801a5d:	90                   	nop
}
  801a5e:	c9                   	leave  
  801a5f:	c3                   	ret    

00801a60 <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  801a60:	55                   	push   %ebp
  801a61:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  801a63:	6a 00                	push   $0x0
  801a65:	6a 00                	push   $0x0
  801a67:	6a 00                	push   $0x0
  801a69:	6a 00                	push   $0x0
  801a6b:	6a 00                	push   $0x0
  801a6d:	6a 0c                	push   $0xc
  801a6f:	e8 60 fe ff ff       	call   8018d4 <syscall>
  801a74:	83 c4 18             	add    $0x18,%esp
}
  801a77:	c9                   	leave  
  801a78:	c3                   	ret    

00801a79 <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  801a79:	55                   	push   %ebp
  801a7a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  801a7c:	6a 00                	push   $0x0
  801a7e:	6a 00                	push   $0x0
  801a80:	6a 00                	push   $0x0
  801a82:	6a 00                	push   $0x0
  801a84:	ff 75 08             	pushl  0x8(%ebp)
  801a87:	6a 0d                	push   $0xd
  801a89:	e8 46 fe ff ff       	call   8018d4 <syscall>
  801a8e:	83 c4 18             	add    $0x18,%esp
}
  801a91:	c9                   	leave  
  801a92:	c3                   	ret    

00801a93 <sys_scarce_memory>:

void sys_scarce_memory()
{
  801a93:	55                   	push   %ebp
  801a94:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  801a96:	6a 00                	push   $0x0
  801a98:	6a 00                	push   $0x0
  801a9a:	6a 00                	push   $0x0
  801a9c:	6a 00                	push   $0x0
  801a9e:	6a 00                	push   $0x0
  801aa0:	6a 0e                	push   $0xe
  801aa2:	e8 2d fe ff ff       	call   8018d4 <syscall>
  801aa7:	83 c4 18             	add    $0x18,%esp
}
  801aaa:	90                   	nop
  801aab:	c9                   	leave  
  801aac:	c3                   	ret    

00801aad <sys_disable_interrupt>:

//NEW !! 2012...
void
sys_disable_interrupt()
{
  801aad:	55                   	push   %ebp
  801aae:	89 e5                	mov    %esp,%ebp
	syscall(SYS_disableINTR,0, 0, 0, 0, 0);
  801ab0:	6a 00                	push   $0x0
  801ab2:	6a 00                	push   $0x0
  801ab4:	6a 00                	push   $0x0
  801ab6:	6a 00                	push   $0x0
  801ab8:	6a 00                	push   $0x0
  801aba:	6a 13                	push   $0x13
  801abc:	e8 13 fe ff ff       	call   8018d4 <syscall>
  801ac1:	83 c4 18             	add    $0x18,%esp
}
  801ac4:	90                   	nop
  801ac5:	c9                   	leave  
  801ac6:	c3                   	ret    

00801ac7 <sys_enable_interrupt>:


void
sys_enable_interrupt()
{
  801ac7:	55                   	push   %ebp
  801ac8:	89 e5                	mov    %esp,%ebp
	syscall(SYS_enableINTR,0, 0, 0, 0, 0);
  801aca:	6a 00                	push   $0x0
  801acc:	6a 00                	push   $0x0
  801ace:	6a 00                	push   $0x0
  801ad0:	6a 00                	push   $0x0
  801ad2:	6a 00                	push   $0x0
  801ad4:	6a 14                	push   $0x14
  801ad6:	e8 f9 fd ff ff       	call   8018d4 <syscall>
  801adb:	83 c4 18             	add    $0x18,%esp
}
  801ade:	90                   	nop
  801adf:	c9                   	leave  
  801ae0:	c3                   	ret    

00801ae1 <sys_cputc>:


void
sys_cputc(const char c)
{
  801ae1:	55                   	push   %ebp
  801ae2:	89 e5                	mov    %esp,%ebp
  801ae4:	83 ec 04             	sub    $0x4,%esp
  801ae7:	8b 45 08             	mov    0x8(%ebp),%eax
  801aea:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  801aed:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801af1:	6a 00                	push   $0x0
  801af3:	6a 00                	push   $0x0
  801af5:	6a 00                	push   $0x0
  801af7:	6a 00                	push   $0x0
  801af9:	50                   	push   %eax
  801afa:	6a 15                	push   $0x15
  801afc:	e8 d3 fd ff ff       	call   8018d4 <syscall>
  801b01:	83 c4 18             	add    $0x18,%esp
}
  801b04:	90                   	nop
  801b05:	c9                   	leave  
  801b06:	c3                   	ret    

00801b07 <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  801b07:	55                   	push   %ebp
  801b08:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  801b0a:	6a 00                	push   $0x0
  801b0c:	6a 00                	push   $0x0
  801b0e:	6a 00                	push   $0x0
  801b10:	6a 00                	push   $0x0
  801b12:	6a 00                	push   $0x0
  801b14:	6a 16                	push   $0x16
  801b16:	e8 b9 fd ff ff       	call   8018d4 <syscall>
  801b1b:	83 c4 18             	add    $0x18,%esp
}
  801b1e:	90                   	nop
  801b1f:	c9                   	leave  
  801b20:	c3                   	ret    

00801b21 <sys_createSemaphore>:

int
sys_createSemaphore(char* semaphoreName, uint32 initialValue)
{
  801b21:	55                   	push   %ebp
  801b22:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_semaphore,(uint32)semaphoreName, (uint32)initialValue, 0, 0, 0);
  801b24:	8b 45 08             	mov    0x8(%ebp),%eax
  801b27:	6a 00                	push   $0x0
  801b29:	6a 00                	push   $0x0
  801b2b:	6a 00                	push   $0x0
  801b2d:	ff 75 0c             	pushl  0xc(%ebp)
  801b30:	50                   	push   %eax
  801b31:	6a 17                	push   $0x17
  801b33:	e8 9c fd ff ff       	call   8018d4 <syscall>
  801b38:	83 c4 18             	add    $0x18,%esp
}
  801b3b:	c9                   	leave  
  801b3c:	c3                   	ret    

00801b3d <sys_getSemaphoreValue>:

int
sys_getSemaphoreValue(int32 ownerEnvID, char* semaphoreName)
{
  801b3d:	55                   	push   %ebp
  801b3e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_semaphore_value,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801b40:	8b 55 0c             	mov    0xc(%ebp),%edx
  801b43:	8b 45 08             	mov    0x8(%ebp),%eax
  801b46:	6a 00                	push   $0x0
  801b48:	6a 00                	push   $0x0
  801b4a:	6a 00                	push   $0x0
  801b4c:	52                   	push   %edx
  801b4d:	50                   	push   %eax
  801b4e:	6a 1a                	push   $0x1a
  801b50:	e8 7f fd ff ff       	call   8018d4 <syscall>
  801b55:	83 c4 18             	add    $0x18,%esp
}
  801b58:	c9                   	leave  
  801b59:	c3                   	ret    

00801b5a <sys_waitSemaphore>:

void
sys_waitSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  801b5a:	55                   	push   %ebp
  801b5b:	89 e5                	mov    %esp,%ebp
	syscall(SYS_wait_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801b5d:	8b 55 0c             	mov    0xc(%ebp),%edx
  801b60:	8b 45 08             	mov    0x8(%ebp),%eax
  801b63:	6a 00                	push   $0x0
  801b65:	6a 00                	push   $0x0
  801b67:	6a 00                	push   $0x0
  801b69:	52                   	push   %edx
  801b6a:	50                   	push   %eax
  801b6b:	6a 18                	push   $0x18
  801b6d:	e8 62 fd ff ff       	call   8018d4 <syscall>
  801b72:	83 c4 18             	add    $0x18,%esp
}
  801b75:	90                   	nop
  801b76:	c9                   	leave  
  801b77:	c3                   	ret    

00801b78 <sys_signalSemaphore>:

void
sys_signalSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  801b78:	55                   	push   %ebp
  801b79:	89 e5                	mov    %esp,%ebp
	syscall(SYS_signal_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801b7b:	8b 55 0c             	mov    0xc(%ebp),%edx
  801b7e:	8b 45 08             	mov    0x8(%ebp),%eax
  801b81:	6a 00                	push   $0x0
  801b83:	6a 00                	push   $0x0
  801b85:	6a 00                	push   $0x0
  801b87:	52                   	push   %edx
  801b88:	50                   	push   %eax
  801b89:	6a 19                	push   $0x19
  801b8b:	e8 44 fd ff ff       	call   8018d4 <syscall>
  801b90:	83 c4 18             	add    $0x18,%esp
}
  801b93:	90                   	nop
  801b94:	c9                   	leave  
  801b95:	c3                   	ret    

00801b96 <sys_createSharedObject>:

int
sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  801b96:	55                   	push   %ebp
  801b97:	89 e5                	mov    %esp,%ebp
  801b99:	83 ec 04             	sub    $0x4,%esp
  801b9c:	8b 45 10             	mov    0x10(%ebp),%eax
  801b9f:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  801ba2:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801ba5:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801ba9:	8b 45 08             	mov    0x8(%ebp),%eax
  801bac:	6a 00                	push   $0x0
  801bae:	51                   	push   %ecx
  801baf:	52                   	push   %edx
  801bb0:	ff 75 0c             	pushl  0xc(%ebp)
  801bb3:	50                   	push   %eax
  801bb4:	6a 1b                	push   $0x1b
  801bb6:	e8 19 fd ff ff       	call   8018d4 <syscall>
  801bbb:	83 c4 18             	add    $0x18,%esp
}
  801bbe:	c9                   	leave  
  801bbf:	c3                   	ret    

00801bc0 <sys_getSizeOfSharedObject>:

//2017:
int
sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  801bc0:	55                   	push   %ebp
  801bc1:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  801bc3:	8b 55 0c             	mov    0xc(%ebp),%edx
  801bc6:	8b 45 08             	mov    0x8(%ebp),%eax
  801bc9:	6a 00                	push   $0x0
  801bcb:	6a 00                	push   $0x0
  801bcd:	6a 00                	push   $0x0
  801bcf:	52                   	push   %edx
  801bd0:	50                   	push   %eax
  801bd1:	6a 1c                	push   $0x1c
  801bd3:	e8 fc fc ff ff       	call   8018d4 <syscall>
  801bd8:	83 c4 18             	add    $0x18,%esp
}
  801bdb:	c9                   	leave  
  801bdc:	c3                   	ret    

00801bdd <sys_getSharedObject>:
//==========

int
sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  801bdd:	55                   	push   %ebp
  801bde:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  801be0:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801be3:	8b 55 0c             	mov    0xc(%ebp),%edx
  801be6:	8b 45 08             	mov    0x8(%ebp),%eax
  801be9:	6a 00                	push   $0x0
  801beb:	6a 00                	push   $0x0
  801bed:	51                   	push   %ecx
  801bee:	52                   	push   %edx
  801bef:	50                   	push   %eax
  801bf0:	6a 1d                	push   $0x1d
  801bf2:	e8 dd fc ff ff       	call   8018d4 <syscall>
  801bf7:	83 c4 18             	add    $0x18,%esp
}
  801bfa:	c9                   	leave  
  801bfb:	c3                   	ret    

00801bfc <sys_freeSharedObject>:

int
sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  801bfc:	55                   	push   %ebp
  801bfd:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  801bff:	8b 55 0c             	mov    0xc(%ebp),%edx
  801c02:	8b 45 08             	mov    0x8(%ebp),%eax
  801c05:	6a 00                	push   $0x0
  801c07:	6a 00                	push   $0x0
  801c09:	6a 00                	push   $0x0
  801c0b:	52                   	push   %edx
  801c0c:	50                   	push   %eax
  801c0d:	6a 1e                	push   $0x1e
  801c0f:	e8 c0 fc ff ff       	call   8018d4 <syscall>
  801c14:	83 c4 18             	add    $0x18,%esp
}
  801c17:	c9                   	leave  
  801c18:	c3                   	ret    

00801c19 <sys_getMaxShares>:

uint32 	sys_getMaxShares()
{
  801c19:	55                   	push   %ebp
  801c1a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_max_shares,0, 0, 0, 0, 0);
  801c1c:	6a 00                	push   $0x0
  801c1e:	6a 00                	push   $0x0
  801c20:	6a 00                	push   $0x0
  801c22:	6a 00                	push   $0x0
  801c24:	6a 00                	push   $0x0
  801c26:	6a 1f                	push   $0x1f
  801c28:	e8 a7 fc ff ff       	call   8018d4 <syscall>
  801c2d:	83 c4 18             	add    $0x18,%esp
}
  801c30:	c9                   	leave  
  801c31:	c3                   	ret    

00801c32 <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  801c32:	55                   	push   %ebp
  801c33:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  801c35:	8b 45 08             	mov    0x8(%ebp),%eax
  801c38:	6a 00                	push   $0x0
  801c3a:	ff 75 14             	pushl  0x14(%ebp)
  801c3d:	ff 75 10             	pushl  0x10(%ebp)
  801c40:	ff 75 0c             	pushl  0xc(%ebp)
  801c43:	50                   	push   %eax
  801c44:	6a 20                	push   $0x20
  801c46:	e8 89 fc ff ff       	call   8018d4 <syscall>
  801c4b:	83 c4 18             	add    $0x18,%esp
}
  801c4e:	c9                   	leave  
  801c4f:	c3                   	ret    

00801c50 <sys_run_env>:

void
sys_run_env(int32 envId)
{
  801c50:	55                   	push   %ebp
  801c51:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  801c53:	8b 45 08             	mov    0x8(%ebp),%eax
  801c56:	6a 00                	push   $0x0
  801c58:	6a 00                	push   $0x0
  801c5a:	6a 00                	push   $0x0
  801c5c:	6a 00                	push   $0x0
  801c5e:	50                   	push   %eax
  801c5f:	6a 21                	push   $0x21
  801c61:	e8 6e fc ff ff       	call   8018d4 <syscall>
  801c66:	83 c4 18             	add    $0x18,%esp
}
  801c69:	90                   	nop
  801c6a:	c9                   	leave  
  801c6b:	c3                   	ret    

00801c6c <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  801c6c:	55                   	push   %ebp
  801c6d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  801c6f:	8b 45 08             	mov    0x8(%ebp),%eax
  801c72:	6a 00                	push   $0x0
  801c74:	6a 00                	push   $0x0
  801c76:	6a 00                	push   $0x0
  801c78:	6a 00                	push   $0x0
  801c7a:	50                   	push   %eax
  801c7b:	6a 22                	push   $0x22
  801c7d:	e8 52 fc ff ff       	call   8018d4 <syscall>
  801c82:	83 c4 18             	add    $0x18,%esp
}
  801c85:	c9                   	leave  
  801c86:	c3                   	ret    

00801c87 <sys_getenvid>:

int32 sys_getenvid(void)
{
  801c87:	55                   	push   %ebp
  801c88:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  801c8a:	6a 00                	push   $0x0
  801c8c:	6a 00                	push   $0x0
  801c8e:	6a 00                	push   $0x0
  801c90:	6a 00                	push   $0x0
  801c92:	6a 00                	push   $0x0
  801c94:	6a 02                	push   $0x2
  801c96:	e8 39 fc ff ff       	call   8018d4 <syscall>
  801c9b:	83 c4 18             	add    $0x18,%esp
}
  801c9e:	c9                   	leave  
  801c9f:	c3                   	ret    

00801ca0 <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  801ca0:	55                   	push   %ebp
  801ca1:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  801ca3:	6a 00                	push   $0x0
  801ca5:	6a 00                	push   $0x0
  801ca7:	6a 00                	push   $0x0
  801ca9:	6a 00                	push   $0x0
  801cab:	6a 00                	push   $0x0
  801cad:	6a 03                	push   $0x3
  801caf:	e8 20 fc ff ff       	call   8018d4 <syscall>
  801cb4:	83 c4 18             	add    $0x18,%esp
}
  801cb7:	c9                   	leave  
  801cb8:	c3                   	ret    

00801cb9 <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  801cb9:	55                   	push   %ebp
  801cba:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  801cbc:	6a 00                	push   $0x0
  801cbe:	6a 00                	push   $0x0
  801cc0:	6a 00                	push   $0x0
  801cc2:	6a 00                	push   $0x0
  801cc4:	6a 00                	push   $0x0
  801cc6:	6a 04                	push   $0x4
  801cc8:	e8 07 fc ff ff       	call   8018d4 <syscall>
  801ccd:	83 c4 18             	add    $0x18,%esp
}
  801cd0:	c9                   	leave  
  801cd1:	c3                   	ret    

00801cd2 <sys_exit_env>:


void sys_exit_env(void)
{
  801cd2:	55                   	push   %ebp
  801cd3:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  801cd5:	6a 00                	push   $0x0
  801cd7:	6a 00                	push   $0x0
  801cd9:	6a 00                	push   $0x0
  801cdb:	6a 00                	push   $0x0
  801cdd:	6a 00                	push   $0x0
  801cdf:	6a 23                	push   $0x23
  801ce1:	e8 ee fb ff ff       	call   8018d4 <syscall>
  801ce6:	83 c4 18             	add    $0x18,%esp
}
  801ce9:	90                   	nop
  801cea:	c9                   	leave  
  801ceb:	c3                   	ret    

00801cec <sys_get_virtual_time>:


struct uint64
sys_get_virtual_time()
{
  801cec:	55                   	push   %ebp
  801ced:	89 e5                	mov    %esp,%ebp
  801cef:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  801cf2:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801cf5:	8d 50 04             	lea    0x4(%eax),%edx
  801cf8:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801cfb:	6a 00                	push   $0x0
  801cfd:	6a 00                	push   $0x0
  801cff:	6a 00                	push   $0x0
  801d01:	52                   	push   %edx
  801d02:	50                   	push   %eax
  801d03:	6a 24                	push   $0x24
  801d05:	e8 ca fb ff ff       	call   8018d4 <syscall>
  801d0a:	83 c4 18             	add    $0x18,%esp
	return result;
  801d0d:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801d10:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801d13:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801d16:	89 01                	mov    %eax,(%ecx)
  801d18:	89 51 04             	mov    %edx,0x4(%ecx)
}
  801d1b:	8b 45 08             	mov    0x8(%ebp),%eax
  801d1e:	c9                   	leave  
  801d1f:	c2 04 00             	ret    $0x4

00801d22 <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  801d22:	55                   	push   %ebp
  801d23:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  801d25:	6a 00                	push   $0x0
  801d27:	6a 00                	push   $0x0
  801d29:	ff 75 10             	pushl  0x10(%ebp)
  801d2c:	ff 75 0c             	pushl  0xc(%ebp)
  801d2f:	ff 75 08             	pushl  0x8(%ebp)
  801d32:	6a 12                	push   $0x12
  801d34:	e8 9b fb ff ff       	call   8018d4 <syscall>
  801d39:	83 c4 18             	add    $0x18,%esp
	return ;
  801d3c:	90                   	nop
}
  801d3d:	c9                   	leave  
  801d3e:	c3                   	ret    

00801d3f <sys_rcr2>:
uint32 sys_rcr2()
{
  801d3f:	55                   	push   %ebp
  801d40:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  801d42:	6a 00                	push   $0x0
  801d44:	6a 00                	push   $0x0
  801d46:	6a 00                	push   $0x0
  801d48:	6a 00                	push   $0x0
  801d4a:	6a 00                	push   $0x0
  801d4c:	6a 25                	push   $0x25
  801d4e:	e8 81 fb ff ff       	call   8018d4 <syscall>
  801d53:	83 c4 18             	add    $0x18,%esp
}
  801d56:	c9                   	leave  
  801d57:	c3                   	ret    

00801d58 <sys_bypassPageFault>:
void sys_bypassPageFault(uint8 instrLength)
{
  801d58:	55                   	push   %ebp
  801d59:	89 e5                	mov    %esp,%ebp
  801d5b:	83 ec 04             	sub    $0x4,%esp
  801d5e:	8b 45 08             	mov    0x8(%ebp),%eax
  801d61:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  801d64:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  801d68:	6a 00                	push   $0x0
  801d6a:	6a 00                	push   $0x0
  801d6c:	6a 00                	push   $0x0
  801d6e:	6a 00                	push   $0x0
  801d70:	50                   	push   %eax
  801d71:	6a 26                	push   $0x26
  801d73:	e8 5c fb ff ff       	call   8018d4 <syscall>
  801d78:	83 c4 18             	add    $0x18,%esp
	return ;
  801d7b:	90                   	nop
}
  801d7c:	c9                   	leave  
  801d7d:	c3                   	ret    

00801d7e <rsttst>:
void rsttst()
{
  801d7e:	55                   	push   %ebp
  801d7f:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  801d81:	6a 00                	push   $0x0
  801d83:	6a 00                	push   $0x0
  801d85:	6a 00                	push   $0x0
  801d87:	6a 00                	push   $0x0
  801d89:	6a 00                	push   $0x0
  801d8b:	6a 28                	push   $0x28
  801d8d:	e8 42 fb ff ff       	call   8018d4 <syscall>
  801d92:	83 c4 18             	add    $0x18,%esp
	return ;
  801d95:	90                   	nop
}
  801d96:	c9                   	leave  
  801d97:	c3                   	ret    

00801d98 <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  801d98:	55                   	push   %ebp
  801d99:	89 e5                	mov    %esp,%ebp
  801d9b:	83 ec 04             	sub    $0x4,%esp
  801d9e:	8b 45 14             	mov    0x14(%ebp),%eax
  801da1:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  801da4:	8b 55 18             	mov    0x18(%ebp),%edx
  801da7:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801dab:	52                   	push   %edx
  801dac:	50                   	push   %eax
  801dad:	ff 75 10             	pushl  0x10(%ebp)
  801db0:	ff 75 0c             	pushl  0xc(%ebp)
  801db3:	ff 75 08             	pushl  0x8(%ebp)
  801db6:	6a 27                	push   $0x27
  801db8:	e8 17 fb ff ff       	call   8018d4 <syscall>
  801dbd:	83 c4 18             	add    $0x18,%esp
	return ;
  801dc0:	90                   	nop
}
  801dc1:	c9                   	leave  
  801dc2:	c3                   	ret    

00801dc3 <chktst>:
void chktst(uint32 n)
{
  801dc3:	55                   	push   %ebp
  801dc4:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  801dc6:	6a 00                	push   $0x0
  801dc8:	6a 00                	push   $0x0
  801dca:	6a 00                	push   $0x0
  801dcc:	6a 00                	push   $0x0
  801dce:	ff 75 08             	pushl  0x8(%ebp)
  801dd1:	6a 29                	push   $0x29
  801dd3:	e8 fc fa ff ff       	call   8018d4 <syscall>
  801dd8:	83 c4 18             	add    $0x18,%esp
	return ;
  801ddb:	90                   	nop
}
  801ddc:	c9                   	leave  
  801ddd:	c3                   	ret    

00801dde <inctst>:

void inctst()
{
  801dde:	55                   	push   %ebp
  801ddf:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  801de1:	6a 00                	push   $0x0
  801de3:	6a 00                	push   $0x0
  801de5:	6a 00                	push   $0x0
  801de7:	6a 00                	push   $0x0
  801de9:	6a 00                	push   $0x0
  801deb:	6a 2a                	push   $0x2a
  801ded:	e8 e2 fa ff ff       	call   8018d4 <syscall>
  801df2:	83 c4 18             	add    $0x18,%esp
	return ;
  801df5:	90                   	nop
}
  801df6:	c9                   	leave  
  801df7:	c3                   	ret    

00801df8 <gettst>:
uint32 gettst()
{
  801df8:	55                   	push   %ebp
  801df9:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  801dfb:	6a 00                	push   $0x0
  801dfd:	6a 00                	push   $0x0
  801dff:	6a 00                	push   $0x0
  801e01:	6a 00                	push   $0x0
  801e03:	6a 00                	push   $0x0
  801e05:	6a 2b                	push   $0x2b
  801e07:	e8 c8 fa ff ff       	call   8018d4 <syscall>
  801e0c:	83 c4 18             	add    $0x18,%esp
}
  801e0f:	c9                   	leave  
  801e10:	c3                   	ret    

00801e11 <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  801e11:	55                   	push   %ebp
  801e12:	89 e5                	mov    %esp,%ebp
  801e14:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801e17:	6a 00                	push   $0x0
  801e19:	6a 00                	push   $0x0
  801e1b:	6a 00                	push   $0x0
  801e1d:	6a 00                	push   $0x0
  801e1f:	6a 00                	push   $0x0
  801e21:	6a 2c                	push   $0x2c
  801e23:	e8 ac fa ff ff       	call   8018d4 <syscall>
  801e28:	83 c4 18             	add    $0x18,%esp
  801e2b:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  801e2e:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  801e32:	75 07                	jne    801e3b <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  801e34:	b8 01 00 00 00       	mov    $0x1,%eax
  801e39:	eb 05                	jmp    801e40 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  801e3b:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801e40:	c9                   	leave  
  801e41:	c3                   	ret    

00801e42 <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  801e42:	55                   	push   %ebp
  801e43:	89 e5                	mov    %esp,%ebp
  801e45:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801e48:	6a 00                	push   $0x0
  801e4a:	6a 00                	push   $0x0
  801e4c:	6a 00                	push   $0x0
  801e4e:	6a 00                	push   $0x0
  801e50:	6a 00                	push   $0x0
  801e52:	6a 2c                	push   $0x2c
  801e54:	e8 7b fa ff ff       	call   8018d4 <syscall>
  801e59:	83 c4 18             	add    $0x18,%esp
  801e5c:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  801e5f:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  801e63:	75 07                	jne    801e6c <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  801e65:	b8 01 00 00 00       	mov    $0x1,%eax
  801e6a:	eb 05                	jmp    801e71 <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  801e6c:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801e71:	c9                   	leave  
  801e72:	c3                   	ret    

00801e73 <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  801e73:	55                   	push   %ebp
  801e74:	89 e5                	mov    %esp,%ebp
  801e76:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801e79:	6a 00                	push   $0x0
  801e7b:	6a 00                	push   $0x0
  801e7d:	6a 00                	push   $0x0
  801e7f:	6a 00                	push   $0x0
  801e81:	6a 00                	push   $0x0
  801e83:	6a 2c                	push   $0x2c
  801e85:	e8 4a fa ff ff       	call   8018d4 <syscall>
  801e8a:	83 c4 18             	add    $0x18,%esp
  801e8d:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  801e90:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  801e94:	75 07                	jne    801e9d <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  801e96:	b8 01 00 00 00       	mov    $0x1,%eax
  801e9b:	eb 05                	jmp    801ea2 <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  801e9d:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801ea2:	c9                   	leave  
  801ea3:	c3                   	ret    

00801ea4 <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  801ea4:	55                   	push   %ebp
  801ea5:	89 e5                	mov    %esp,%ebp
  801ea7:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801eaa:	6a 00                	push   $0x0
  801eac:	6a 00                	push   $0x0
  801eae:	6a 00                	push   $0x0
  801eb0:	6a 00                	push   $0x0
  801eb2:	6a 00                	push   $0x0
  801eb4:	6a 2c                	push   $0x2c
  801eb6:	e8 19 fa ff ff       	call   8018d4 <syscall>
  801ebb:	83 c4 18             	add    $0x18,%esp
  801ebe:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  801ec1:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  801ec5:	75 07                	jne    801ece <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  801ec7:	b8 01 00 00 00       	mov    $0x1,%eax
  801ecc:	eb 05                	jmp    801ed3 <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  801ece:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801ed3:	c9                   	leave  
  801ed4:	c3                   	ret    

00801ed5 <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  801ed5:	55                   	push   %ebp
  801ed6:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  801ed8:	6a 00                	push   $0x0
  801eda:	6a 00                	push   $0x0
  801edc:	6a 00                	push   $0x0
  801ede:	6a 00                	push   $0x0
  801ee0:	ff 75 08             	pushl  0x8(%ebp)
  801ee3:	6a 2d                	push   $0x2d
  801ee5:	e8 ea f9 ff ff       	call   8018d4 <syscall>
  801eea:	83 c4 18             	add    $0x18,%esp
	return ;
  801eed:	90                   	nop
}
  801eee:	c9                   	leave  
  801eef:	c3                   	ret    

00801ef0 <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  801ef0:	55                   	push   %ebp
  801ef1:	89 e5                	mov    %esp,%ebp
  801ef3:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  801ef4:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801ef7:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801efa:	8b 55 0c             	mov    0xc(%ebp),%edx
  801efd:	8b 45 08             	mov    0x8(%ebp),%eax
  801f00:	6a 00                	push   $0x0
  801f02:	53                   	push   %ebx
  801f03:	51                   	push   %ecx
  801f04:	52                   	push   %edx
  801f05:	50                   	push   %eax
  801f06:	6a 2e                	push   $0x2e
  801f08:	e8 c7 f9 ff ff       	call   8018d4 <syscall>
  801f0d:	83 c4 18             	add    $0x18,%esp
}
  801f10:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801f13:	c9                   	leave  
  801f14:	c3                   	ret    

00801f15 <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  801f15:	55                   	push   %ebp
  801f16:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  801f18:	8b 55 0c             	mov    0xc(%ebp),%edx
  801f1b:	8b 45 08             	mov    0x8(%ebp),%eax
  801f1e:	6a 00                	push   $0x0
  801f20:	6a 00                	push   $0x0
  801f22:	6a 00                	push   $0x0
  801f24:	52                   	push   %edx
  801f25:	50                   	push   %eax
  801f26:	6a 2f                	push   $0x2f
  801f28:	e8 a7 f9 ff ff       	call   8018d4 <syscall>
  801f2d:	83 c4 18             	add    $0x18,%esp
}
  801f30:	c9                   	leave  
  801f31:	c3                   	ret    

00801f32 <print_mem_block_lists>:
//===========================
// PRINT MEM BLOCK LISTS:
//===========================

void print_mem_block_lists()
{
  801f32:	55                   	push   %ebp
  801f33:	89 e5                	mov    %esp,%ebp
  801f35:	83 ec 18             	sub    $0x18,%esp
	cprintf("\n=========================================\n");
  801f38:	83 ec 0c             	sub    $0xc,%esp
  801f3b:	68 40 3a 80 00       	push   $0x803a40
  801f40:	e8 dd e6 ff ff       	call   800622 <cprintf>
  801f45:	83 c4 10             	add    $0x10,%esp
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
  801f48:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nFreeMemBlocksList:\n");
  801f4f:	83 ec 0c             	sub    $0xc,%esp
  801f52:	68 6c 3a 80 00       	push   $0x803a6c
  801f57:	e8 c6 e6 ff ff       	call   800622 <cprintf>
  801f5c:	83 c4 10             	add    $0x10,%esp
	uint8 sorted = 1 ;
  801f5f:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &FreeMemBlocksList)
  801f63:	a1 38 41 80 00       	mov    0x804138,%eax
  801f68:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801f6b:	eb 56                	jmp    801fc3 <print_mem_block_lists+0x91>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  801f6d:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801f71:	74 1c                	je     801f8f <print_mem_block_lists+0x5d>
  801f73:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f76:	8b 50 08             	mov    0x8(%eax),%edx
  801f79:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801f7c:	8b 48 08             	mov    0x8(%eax),%ecx
  801f7f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801f82:	8b 40 0c             	mov    0xc(%eax),%eax
  801f85:	01 c8                	add    %ecx,%eax
  801f87:	39 c2                	cmp    %eax,%edx
  801f89:	73 04                	jae    801f8f <print_mem_block_lists+0x5d>
			sorted = 0 ;
  801f8b:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  801f8f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f92:	8b 50 08             	mov    0x8(%eax),%edx
  801f95:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f98:	8b 40 0c             	mov    0xc(%eax),%eax
  801f9b:	01 c2                	add    %eax,%edx
  801f9d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801fa0:	8b 40 08             	mov    0x8(%eax),%eax
  801fa3:	83 ec 04             	sub    $0x4,%esp
  801fa6:	52                   	push   %edx
  801fa7:	50                   	push   %eax
  801fa8:	68 81 3a 80 00       	push   $0x803a81
  801fad:	e8 70 e6 ff ff       	call   800622 <cprintf>
  801fb2:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  801fb5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801fb8:	89 45 f0             	mov    %eax,-0x10(%ebp)
	cprintf("\n=========================================\n");
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
	cprintf("\nFreeMemBlocksList:\n");
	uint8 sorted = 1 ;
	LIST_FOREACH(blk, &FreeMemBlocksList)
  801fbb:	a1 40 41 80 00       	mov    0x804140,%eax
  801fc0:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801fc3:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801fc7:	74 07                	je     801fd0 <print_mem_block_lists+0x9e>
  801fc9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801fcc:	8b 00                	mov    (%eax),%eax
  801fce:	eb 05                	jmp    801fd5 <print_mem_block_lists+0xa3>
  801fd0:	b8 00 00 00 00       	mov    $0x0,%eax
  801fd5:	a3 40 41 80 00       	mov    %eax,0x804140
  801fda:	a1 40 41 80 00       	mov    0x804140,%eax
  801fdf:	85 c0                	test   %eax,%eax
  801fe1:	75 8a                	jne    801f6d <print_mem_block_lists+0x3b>
  801fe3:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801fe7:	75 84                	jne    801f6d <print_mem_block_lists+0x3b>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;
  801fe9:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  801fed:	75 10                	jne    801fff <print_mem_block_lists+0xcd>
  801fef:	83 ec 0c             	sub    $0xc,%esp
  801ff2:	68 90 3a 80 00       	push   $0x803a90
  801ff7:	e8 26 e6 ff ff       	call   800622 <cprintf>
  801ffc:	83 c4 10             	add    $0x10,%esp

	lastBlk = NULL ;
  801fff:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nAllocMemBlocksList:\n");
  802006:	83 ec 0c             	sub    $0xc,%esp
  802009:	68 b4 3a 80 00       	push   $0x803ab4
  80200e:	e8 0f e6 ff ff       	call   800622 <cprintf>
  802013:	83 c4 10             	add    $0x10,%esp
	sorted = 1 ;
  802016:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &AllocMemBlocksList)
  80201a:	a1 40 40 80 00       	mov    0x804040,%eax
  80201f:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802022:	eb 56                	jmp    80207a <print_mem_block_lists+0x148>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  802024:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802028:	74 1c                	je     802046 <print_mem_block_lists+0x114>
  80202a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80202d:	8b 50 08             	mov    0x8(%eax),%edx
  802030:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802033:	8b 48 08             	mov    0x8(%eax),%ecx
  802036:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802039:	8b 40 0c             	mov    0xc(%eax),%eax
  80203c:	01 c8                	add    %ecx,%eax
  80203e:	39 c2                	cmp    %eax,%edx
  802040:	73 04                	jae    802046 <print_mem_block_lists+0x114>
			sorted = 0 ;
  802042:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  802046:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802049:	8b 50 08             	mov    0x8(%eax),%edx
  80204c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80204f:	8b 40 0c             	mov    0xc(%eax),%eax
  802052:	01 c2                	add    %eax,%edx
  802054:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802057:	8b 40 08             	mov    0x8(%eax),%eax
  80205a:	83 ec 04             	sub    $0x4,%esp
  80205d:	52                   	push   %edx
  80205e:	50                   	push   %eax
  80205f:	68 81 3a 80 00       	push   $0x803a81
  802064:	e8 b9 e5 ff ff       	call   800622 <cprintf>
  802069:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  80206c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80206f:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;

	lastBlk = NULL ;
	cprintf("\nAllocMemBlocksList:\n");
	sorted = 1 ;
	LIST_FOREACH(blk, &AllocMemBlocksList)
  802072:	a1 48 40 80 00       	mov    0x804048,%eax
  802077:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80207a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80207e:	74 07                	je     802087 <print_mem_block_lists+0x155>
  802080:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802083:	8b 00                	mov    (%eax),%eax
  802085:	eb 05                	jmp    80208c <print_mem_block_lists+0x15a>
  802087:	b8 00 00 00 00       	mov    $0x0,%eax
  80208c:	a3 48 40 80 00       	mov    %eax,0x804048
  802091:	a1 48 40 80 00       	mov    0x804048,%eax
  802096:	85 c0                	test   %eax,%eax
  802098:	75 8a                	jne    802024 <print_mem_block_lists+0xf2>
  80209a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80209e:	75 84                	jne    802024 <print_mem_block_lists+0xf2>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nAllocMemBlocksList is NOT SORTED!!\n") ;
  8020a0:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  8020a4:	75 10                	jne    8020b6 <print_mem_block_lists+0x184>
  8020a6:	83 ec 0c             	sub    $0xc,%esp
  8020a9:	68 cc 3a 80 00       	push   $0x803acc
  8020ae:	e8 6f e5 ff ff       	call   800622 <cprintf>
  8020b3:	83 c4 10             	add    $0x10,%esp
	cprintf("\n=========================================\n");
  8020b6:	83 ec 0c             	sub    $0xc,%esp
  8020b9:	68 40 3a 80 00       	push   $0x803a40
  8020be:	e8 5f e5 ff ff       	call   800622 <cprintf>
  8020c3:	83 c4 10             	add    $0x10,%esp

}
  8020c6:	90                   	nop
  8020c7:	c9                   	leave  
  8020c8:	c3                   	ret    

008020c9 <initialize_MemBlocksList>:

//===============================
// [1] INITIALIZE AVAILABLE LIST:
//===============================
void initialize_MemBlocksList(uint32 numOfBlocks)
{
  8020c9:	55                   	push   %ebp
  8020ca:	89 e5                	mov    %esp,%ebp
  8020cc:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] initialize_MemBlocksList
	// Write your code here, remove the panic and write your code
	//panic("initialize_MemBlocksList() is not implemented yet...!!");
	uint32 n = numOfBlocks;
  8020cf:	8b 45 08             	mov    0x8(%ebp),%eax
  8020d2:	89 45 f0             	mov    %eax,-0x10(%ebp)

	LIST_INIT(&AvailableMemBlocksList);
  8020d5:	c7 05 48 41 80 00 00 	movl   $0x0,0x804148
  8020dc:	00 00 00 
  8020df:	c7 05 4c 41 80 00 00 	movl   $0x0,0x80414c
  8020e6:	00 00 00 
  8020e9:	c7 05 54 41 80 00 00 	movl   $0x0,0x804154
  8020f0:	00 00 00 
	for(int i = 0; i<n;i++)
  8020f3:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  8020fa:	e9 9e 00 00 00       	jmp    80219d <initialize_MemBlocksList+0xd4>
	{
		LIST_INSERT_HEAD(&AvailableMemBlocksList, &(MemBlockNodes[i]));
  8020ff:	a1 50 40 80 00       	mov    0x804050,%eax
  802104:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802107:	c1 e2 04             	shl    $0x4,%edx
  80210a:	01 d0                	add    %edx,%eax
  80210c:	85 c0                	test   %eax,%eax
  80210e:	75 14                	jne    802124 <initialize_MemBlocksList+0x5b>
  802110:	83 ec 04             	sub    $0x4,%esp
  802113:	68 f4 3a 80 00       	push   $0x803af4
  802118:	6a 47                	push   $0x47
  80211a:	68 17 3b 80 00       	push   $0x803b17
  80211f:	e8 24 0e 00 00       	call   802f48 <_panic>
  802124:	a1 50 40 80 00       	mov    0x804050,%eax
  802129:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80212c:	c1 e2 04             	shl    $0x4,%edx
  80212f:	01 d0                	add    %edx,%eax
  802131:	8b 15 48 41 80 00    	mov    0x804148,%edx
  802137:	89 10                	mov    %edx,(%eax)
  802139:	8b 00                	mov    (%eax),%eax
  80213b:	85 c0                	test   %eax,%eax
  80213d:	74 18                	je     802157 <initialize_MemBlocksList+0x8e>
  80213f:	a1 48 41 80 00       	mov    0x804148,%eax
  802144:	8b 15 50 40 80 00    	mov    0x804050,%edx
  80214a:	8b 4d f4             	mov    -0xc(%ebp),%ecx
  80214d:	c1 e1 04             	shl    $0x4,%ecx
  802150:	01 ca                	add    %ecx,%edx
  802152:	89 50 04             	mov    %edx,0x4(%eax)
  802155:	eb 12                	jmp    802169 <initialize_MemBlocksList+0xa0>
  802157:	a1 50 40 80 00       	mov    0x804050,%eax
  80215c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80215f:	c1 e2 04             	shl    $0x4,%edx
  802162:	01 d0                	add    %edx,%eax
  802164:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802169:	a1 50 40 80 00       	mov    0x804050,%eax
  80216e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802171:	c1 e2 04             	shl    $0x4,%edx
  802174:	01 d0                	add    %edx,%eax
  802176:	a3 48 41 80 00       	mov    %eax,0x804148
  80217b:	a1 50 40 80 00       	mov    0x804050,%eax
  802180:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802183:	c1 e2 04             	shl    $0x4,%edx
  802186:	01 d0                	add    %edx,%eax
  802188:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80218f:	a1 54 41 80 00       	mov    0x804154,%eax
  802194:	40                   	inc    %eax
  802195:	a3 54 41 80 00       	mov    %eax,0x804154
	// Write your code here, remove the panic and write your code
	//panic("initialize_MemBlocksList() is not implemented yet...!!");
	uint32 n = numOfBlocks;

	LIST_INIT(&AvailableMemBlocksList);
	for(int i = 0; i<n;i++)
  80219a:	ff 45 f4             	incl   -0xc(%ebp)
  80219d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8021a0:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8021a3:	0f 82 56 ff ff ff    	jb     8020ff <initialize_MemBlocksList+0x36>
	{
		LIST_INSERT_HEAD(&AvailableMemBlocksList, &(MemBlockNodes[i]));
	}
}
  8021a9:	90                   	nop
  8021aa:	c9                   	leave  
  8021ab:	c3                   	ret    

008021ac <find_block>:

//===============================
// [2] FIND BLOCK:
//===============================
struct MemBlock *find_block(struct MemBlock_List *blockList, uint32 va)
{
  8021ac:	55                   	push   %ebp
  8021ad:	89 e5                	mov    %esp,%ebp
  8021af:	83 ec 10             	sub    $0x10,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] find_block
	// Write your code here, remove the panic and write your code
	//panic("find_block() is not implemented yet...!!");
	uint32 virAddress = va;
  8021b2:	8b 45 0c             	mov    0xc(%ebp),%eax
  8021b5:	89 45 f4             	mov    %eax,-0xc(%ebp)
	struct MemBlock* blk;
	int found = 0;
  8021b8:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	LIST_FOREACH(blk, &(AllocMemBlocksList))
  8021bf:	a1 40 40 80 00       	mov    0x804040,%eax
  8021c4:	89 45 fc             	mov    %eax,-0x4(%ebp)
  8021c7:	eb 23                	jmp    8021ec <find_block+0x40>
	{
		if(blk->sva == virAddress)
  8021c9:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8021cc:	8b 40 08             	mov    0x8(%eax),%eax
  8021cf:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  8021d2:	75 09                	jne    8021dd <find_block+0x31>
		{
			found = 1;
  8021d4:	c7 45 f8 01 00 00 00 	movl   $0x1,-0x8(%ebp)
			break;
  8021db:	eb 35                	jmp    802212 <find_block+0x66>
		}
		else
		{
			found = 0;
  8021dd:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	//panic("find_block() is not implemented yet...!!");
	uint32 virAddress = va;
	struct MemBlock* blk;
	int found = 0;

	LIST_FOREACH(blk, &(AllocMemBlocksList))
  8021e4:	a1 48 40 80 00       	mov    0x804048,%eax
  8021e9:	89 45 fc             	mov    %eax,-0x4(%ebp)
  8021ec:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  8021f0:	74 07                	je     8021f9 <find_block+0x4d>
  8021f2:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8021f5:	8b 00                	mov    (%eax),%eax
  8021f7:	eb 05                	jmp    8021fe <find_block+0x52>
  8021f9:	b8 00 00 00 00       	mov    $0x0,%eax
  8021fe:	a3 48 40 80 00       	mov    %eax,0x804048
  802203:	a1 48 40 80 00       	mov    0x804048,%eax
  802208:	85 c0                	test   %eax,%eax
  80220a:	75 bd                	jne    8021c9 <find_block+0x1d>
  80220c:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  802210:	75 b7                	jne    8021c9 <find_block+0x1d>
		{
			found = 0;
			continue;
		}
	}
	if(found == 1)
  802212:	83 7d f8 01          	cmpl   $0x1,-0x8(%ebp)
  802216:	75 05                	jne    80221d <find_block+0x71>
	{
		return blk;
  802218:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80221b:	eb 05                	jmp    802222 <find_block+0x76>
	}
	else
	{
		return NULL;
  80221d:	b8 00 00 00 00       	mov    $0x0,%eax
	}
}
  802222:	c9                   	leave  
  802223:	c3                   	ret    

00802224 <insert_sorted_allocList>:

//=========================================
// [3] INSERT BLOCK IN ALLOC LIST [SORTED]:
//=========================================
void insert_sorted_allocList(struct MemBlock *blockToInsert)
{
  802224:	55                   	push   %ebp
  802225:	89 e5                	mov    %esp,%ebp
  802227:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] insert_sorted_allocList
	// Write your code here, remove the panic and write your code
	//panic("insert_sorted_allocList() is not implemented yet...!!");
	struct MemBlock* blk;
	struct MemBlock* newblk = blockToInsert;
  80222a:	8b 45 08             	mov    0x8(%ebp),%eax
  80222d:	89 45 f0             	mov    %eax,-0x10(%ebp)

	if((LIST_EMPTY(&AllocMemBlocksList)) || (newblk->sva < LIST_FIRST(&AllocMemBlocksList)->sva))
  802230:	a1 40 40 80 00       	mov    0x804040,%eax
  802235:	85 c0                	test   %eax,%eax
  802237:	74 12                	je     80224b <insert_sorted_allocList+0x27>
  802239:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80223c:	8b 50 08             	mov    0x8(%eax),%edx
  80223f:	a1 40 40 80 00       	mov    0x804040,%eax
  802244:	8b 40 08             	mov    0x8(%eax),%eax
  802247:	39 c2                	cmp    %eax,%edx
  802249:	73 65                	jae    8022b0 <insert_sorted_allocList+0x8c>
	{
		LIST_INSERT_HEAD(&(AllocMemBlocksList), newblk);
  80224b:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80224f:	75 14                	jne    802265 <insert_sorted_allocList+0x41>
  802251:	83 ec 04             	sub    $0x4,%esp
  802254:	68 f4 3a 80 00       	push   $0x803af4
  802259:	6a 7b                	push   $0x7b
  80225b:	68 17 3b 80 00       	push   $0x803b17
  802260:	e8 e3 0c 00 00       	call   802f48 <_panic>
  802265:	8b 15 40 40 80 00    	mov    0x804040,%edx
  80226b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80226e:	89 10                	mov    %edx,(%eax)
  802270:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802273:	8b 00                	mov    (%eax),%eax
  802275:	85 c0                	test   %eax,%eax
  802277:	74 0d                	je     802286 <insert_sorted_allocList+0x62>
  802279:	a1 40 40 80 00       	mov    0x804040,%eax
  80227e:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802281:	89 50 04             	mov    %edx,0x4(%eax)
  802284:	eb 08                	jmp    80228e <insert_sorted_allocList+0x6a>
  802286:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802289:	a3 44 40 80 00       	mov    %eax,0x804044
  80228e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802291:	a3 40 40 80 00       	mov    %eax,0x804040
  802296:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802299:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8022a0:	a1 4c 40 80 00       	mov    0x80404c,%eax
  8022a5:	40                   	inc    %eax
  8022a6:	a3 4c 40 80 00       	mov    %eax,0x80404c
  8022ab:	e9 5f 01 00 00       	jmp    80240f <insert_sorted_allocList+0x1eb>
	}
	else if(newblk->sva > LIST_LAST(&AllocMemBlocksList)->sva)
  8022b0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8022b3:	8b 50 08             	mov    0x8(%eax),%edx
  8022b6:	a1 44 40 80 00       	mov    0x804044,%eax
  8022bb:	8b 40 08             	mov    0x8(%eax),%eax
  8022be:	39 c2                	cmp    %eax,%edx
  8022c0:	76 65                	jbe    802327 <insert_sorted_allocList+0x103>
	{
		LIST_INSERT_TAIL(&AllocMemBlocksList, newblk);
  8022c2:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8022c6:	75 14                	jne    8022dc <insert_sorted_allocList+0xb8>
  8022c8:	83 ec 04             	sub    $0x4,%esp
  8022cb:	68 30 3b 80 00       	push   $0x803b30
  8022d0:	6a 7f                	push   $0x7f
  8022d2:	68 17 3b 80 00       	push   $0x803b17
  8022d7:	e8 6c 0c 00 00       	call   802f48 <_panic>
  8022dc:	8b 15 44 40 80 00    	mov    0x804044,%edx
  8022e2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8022e5:	89 50 04             	mov    %edx,0x4(%eax)
  8022e8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8022eb:	8b 40 04             	mov    0x4(%eax),%eax
  8022ee:	85 c0                	test   %eax,%eax
  8022f0:	74 0c                	je     8022fe <insert_sorted_allocList+0xda>
  8022f2:	a1 44 40 80 00       	mov    0x804044,%eax
  8022f7:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8022fa:	89 10                	mov    %edx,(%eax)
  8022fc:	eb 08                	jmp    802306 <insert_sorted_allocList+0xe2>
  8022fe:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802301:	a3 40 40 80 00       	mov    %eax,0x804040
  802306:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802309:	a3 44 40 80 00       	mov    %eax,0x804044
  80230e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802311:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802317:	a1 4c 40 80 00       	mov    0x80404c,%eax
  80231c:	40                   	inc    %eax
  80231d:	a3 4c 40 80 00       	mov    %eax,0x80404c
				LIST_INSERT_AFTER(&AllocMemBlocksList, blk, newblk);
				break;
			}
		}
	}
}
  802322:	e9 e8 00 00 00       	jmp    80240f <insert_sorted_allocList+0x1eb>
	{
		LIST_INSERT_TAIL(&AllocMemBlocksList, newblk);
	}
	else
	{
		LIST_FOREACH(blk, &AllocMemBlocksList)
  802327:	a1 40 40 80 00       	mov    0x804040,%eax
  80232c:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80232f:	e9 ab 00 00 00       	jmp    8023df <insert_sorted_allocList+0x1bb>
		{
			if(blk->prev_next_info.le_next != NULL && newblk->sva > blk->sva  && newblk->sva < blk->prev_next_info.le_next->sva)
  802334:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802337:	8b 00                	mov    (%eax),%eax
  802339:	85 c0                	test   %eax,%eax
  80233b:	0f 84 96 00 00 00    	je     8023d7 <insert_sorted_allocList+0x1b3>
  802341:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802344:	8b 50 08             	mov    0x8(%eax),%edx
  802347:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80234a:	8b 40 08             	mov    0x8(%eax),%eax
  80234d:	39 c2                	cmp    %eax,%edx
  80234f:	0f 86 82 00 00 00    	jbe    8023d7 <insert_sorted_allocList+0x1b3>
  802355:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802358:	8b 50 08             	mov    0x8(%eax),%edx
  80235b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80235e:	8b 00                	mov    (%eax),%eax
  802360:	8b 40 08             	mov    0x8(%eax),%eax
  802363:	39 c2                	cmp    %eax,%edx
  802365:	73 70                	jae    8023d7 <insert_sorted_allocList+0x1b3>
			{
				LIST_INSERT_AFTER(&AllocMemBlocksList, blk, newblk);
  802367:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80236b:	74 06                	je     802373 <insert_sorted_allocList+0x14f>
  80236d:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802371:	75 17                	jne    80238a <insert_sorted_allocList+0x166>
  802373:	83 ec 04             	sub    $0x4,%esp
  802376:	68 54 3b 80 00       	push   $0x803b54
  80237b:	68 87 00 00 00       	push   $0x87
  802380:	68 17 3b 80 00       	push   $0x803b17
  802385:	e8 be 0b 00 00       	call   802f48 <_panic>
  80238a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80238d:	8b 10                	mov    (%eax),%edx
  80238f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802392:	89 10                	mov    %edx,(%eax)
  802394:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802397:	8b 00                	mov    (%eax),%eax
  802399:	85 c0                	test   %eax,%eax
  80239b:	74 0b                	je     8023a8 <insert_sorted_allocList+0x184>
  80239d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023a0:	8b 00                	mov    (%eax),%eax
  8023a2:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8023a5:	89 50 04             	mov    %edx,0x4(%eax)
  8023a8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023ab:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8023ae:	89 10                	mov    %edx,(%eax)
  8023b0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8023b3:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8023b6:	89 50 04             	mov    %edx,0x4(%eax)
  8023b9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8023bc:	8b 00                	mov    (%eax),%eax
  8023be:	85 c0                	test   %eax,%eax
  8023c0:	75 08                	jne    8023ca <insert_sorted_allocList+0x1a6>
  8023c2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8023c5:	a3 44 40 80 00       	mov    %eax,0x804044
  8023ca:	a1 4c 40 80 00       	mov    0x80404c,%eax
  8023cf:	40                   	inc    %eax
  8023d0:	a3 4c 40 80 00       	mov    %eax,0x80404c
				break;
  8023d5:	eb 38                	jmp    80240f <insert_sorted_allocList+0x1eb>
	{
		LIST_INSERT_TAIL(&AllocMemBlocksList, newblk);
	}
	else
	{
		LIST_FOREACH(blk, &AllocMemBlocksList)
  8023d7:	a1 48 40 80 00       	mov    0x804048,%eax
  8023dc:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8023df:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8023e3:	74 07                	je     8023ec <insert_sorted_allocList+0x1c8>
  8023e5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023e8:	8b 00                	mov    (%eax),%eax
  8023ea:	eb 05                	jmp    8023f1 <insert_sorted_allocList+0x1cd>
  8023ec:	b8 00 00 00 00       	mov    $0x0,%eax
  8023f1:	a3 48 40 80 00       	mov    %eax,0x804048
  8023f6:	a1 48 40 80 00       	mov    0x804048,%eax
  8023fb:	85 c0                	test   %eax,%eax
  8023fd:	0f 85 31 ff ff ff    	jne    802334 <insert_sorted_allocList+0x110>
  802403:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802407:	0f 85 27 ff ff ff    	jne    802334 <insert_sorted_allocList+0x110>
				LIST_INSERT_AFTER(&AllocMemBlocksList, blk, newblk);
				break;
			}
		}
	}
}
  80240d:	eb 00                	jmp    80240f <insert_sorted_allocList+0x1eb>
  80240f:	90                   	nop
  802410:	c9                   	leave  
  802411:	c3                   	ret    

00802412 <alloc_block_FF>:

//=========================================
// [4] ALLOCATE BLOCK BY FIRST FIT:
//=========================================
struct MemBlock *alloc_block_FF(uint32 size)
{
  802412:	55                   	push   %ebp
  802413:	89 e5                	mov    %esp,%ebp
  802415:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_FF
	// Write your code here, remove the panic and write your code
	//panic("alloc_block_FF() is not implemented yet...!!");
	uint32 versize = size;
  802418:	8b 45 08             	mov    0x8(%ebp),%eax
  80241b:	89 45 f0             	mov    %eax,-0x10(%ebp)
	struct MemBlock* blk;
	struct MemBlock* newblk = LIST_FIRST(&AvailableMemBlocksList);
  80241e:	a1 48 41 80 00       	mov    0x804148,%eax
  802423:	89 45 ec             	mov    %eax,-0x14(%ebp)

	LIST_FOREACH(blk,&FreeMemBlocksList)
  802426:	a1 38 41 80 00       	mov    0x804138,%eax
  80242b:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80242e:	e9 77 01 00 00       	jmp    8025aa <alloc_block_FF+0x198>
	{
		if(blk->size == versize)
  802433:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802436:	8b 40 0c             	mov    0xc(%eax),%eax
  802439:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  80243c:	0f 85 8a 00 00 00    	jne    8024cc <alloc_block_FF+0xba>
		{
			LIST_REMOVE(&FreeMemBlocksList,blk);
  802442:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802446:	75 17                	jne    80245f <alloc_block_FF+0x4d>
  802448:	83 ec 04             	sub    $0x4,%esp
  80244b:	68 88 3b 80 00       	push   $0x803b88
  802450:	68 9e 00 00 00       	push   $0x9e
  802455:	68 17 3b 80 00       	push   $0x803b17
  80245a:	e8 e9 0a 00 00       	call   802f48 <_panic>
  80245f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802462:	8b 00                	mov    (%eax),%eax
  802464:	85 c0                	test   %eax,%eax
  802466:	74 10                	je     802478 <alloc_block_FF+0x66>
  802468:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80246b:	8b 00                	mov    (%eax),%eax
  80246d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802470:	8b 52 04             	mov    0x4(%edx),%edx
  802473:	89 50 04             	mov    %edx,0x4(%eax)
  802476:	eb 0b                	jmp    802483 <alloc_block_FF+0x71>
  802478:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80247b:	8b 40 04             	mov    0x4(%eax),%eax
  80247e:	a3 3c 41 80 00       	mov    %eax,0x80413c
  802483:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802486:	8b 40 04             	mov    0x4(%eax),%eax
  802489:	85 c0                	test   %eax,%eax
  80248b:	74 0f                	je     80249c <alloc_block_FF+0x8a>
  80248d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802490:	8b 40 04             	mov    0x4(%eax),%eax
  802493:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802496:	8b 12                	mov    (%edx),%edx
  802498:	89 10                	mov    %edx,(%eax)
  80249a:	eb 0a                	jmp    8024a6 <alloc_block_FF+0x94>
  80249c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80249f:	8b 00                	mov    (%eax),%eax
  8024a1:	a3 38 41 80 00       	mov    %eax,0x804138
  8024a6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024a9:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8024af:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024b2:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8024b9:	a1 44 41 80 00       	mov    0x804144,%eax
  8024be:	48                   	dec    %eax
  8024bf:	a3 44 41 80 00       	mov    %eax,0x804144
			return blk;
  8024c4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024c7:	e9 11 01 00 00       	jmp    8025dd <alloc_block_FF+0x1cb>
		}
		else if(blk->size > versize)
  8024cc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024cf:	8b 40 0c             	mov    0xc(%eax),%eax
  8024d2:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8024d5:	0f 86 c7 00 00 00    	jbe    8025a2 <alloc_block_FF+0x190>
		{
			LIST_REMOVE(&AvailableMemBlocksList,newblk);
  8024db:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8024df:	75 17                	jne    8024f8 <alloc_block_FF+0xe6>
  8024e1:	83 ec 04             	sub    $0x4,%esp
  8024e4:	68 88 3b 80 00       	push   $0x803b88
  8024e9:	68 a3 00 00 00       	push   $0xa3
  8024ee:	68 17 3b 80 00       	push   $0x803b17
  8024f3:	e8 50 0a 00 00       	call   802f48 <_panic>
  8024f8:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8024fb:	8b 00                	mov    (%eax),%eax
  8024fd:	85 c0                	test   %eax,%eax
  8024ff:	74 10                	je     802511 <alloc_block_FF+0xff>
  802501:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802504:	8b 00                	mov    (%eax),%eax
  802506:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802509:	8b 52 04             	mov    0x4(%edx),%edx
  80250c:	89 50 04             	mov    %edx,0x4(%eax)
  80250f:	eb 0b                	jmp    80251c <alloc_block_FF+0x10a>
  802511:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802514:	8b 40 04             	mov    0x4(%eax),%eax
  802517:	a3 4c 41 80 00       	mov    %eax,0x80414c
  80251c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80251f:	8b 40 04             	mov    0x4(%eax),%eax
  802522:	85 c0                	test   %eax,%eax
  802524:	74 0f                	je     802535 <alloc_block_FF+0x123>
  802526:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802529:	8b 40 04             	mov    0x4(%eax),%eax
  80252c:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80252f:	8b 12                	mov    (%edx),%edx
  802531:	89 10                	mov    %edx,(%eax)
  802533:	eb 0a                	jmp    80253f <alloc_block_FF+0x12d>
  802535:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802538:	8b 00                	mov    (%eax),%eax
  80253a:	a3 48 41 80 00       	mov    %eax,0x804148
  80253f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802542:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802548:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80254b:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802552:	a1 54 41 80 00       	mov    0x804154,%eax
  802557:	48                   	dec    %eax
  802558:	a3 54 41 80 00       	mov    %eax,0x804154
			newblk->size = versize;
  80255d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802560:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802563:	89 50 0c             	mov    %edx,0xc(%eax)
			blk->size = blk->size-versize;
  802566:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802569:	8b 40 0c             	mov    0xc(%eax),%eax
  80256c:	2b 45 f0             	sub    -0x10(%ebp),%eax
  80256f:	89 c2                	mov    %eax,%edx
  802571:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802574:	89 50 0c             	mov    %edx,0xc(%eax)
			uint32 newveradd = blk->sva;
  802577:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80257a:	8b 40 08             	mov    0x8(%eax),%eax
  80257d:	89 45 e8             	mov    %eax,-0x18(%ebp)
			blk->sva+=newblk->size;
  802580:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802583:	8b 50 08             	mov    0x8(%eax),%edx
  802586:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802589:	8b 40 0c             	mov    0xc(%eax),%eax
  80258c:	01 c2                	add    %eax,%edx
  80258e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802591:	89 50 08             	mov    %edx,0x8(%eax)
			newblk->sva = newveradd;
  802594:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802597:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80259a:	89 50 08             	mov    %edx,0x8(%eax)
			return newblk;
  80259d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8025a0:	eb 3b                	jmp    8025dd <alloc_block_FF+0x1cb>
	//panic("alloc_block_FF() is not implemented yet...!!");
	uint32 versize = size;
	struct MemBlock* blk;
	struct MemBlock* newblk = LIST_FIRST(&AvailableMemBlocksList);

	LIST_FOREACH(blk,&FreeMemBlocksList)
  8025a2:	a1 40 41 80 00       	mov    0x804140,%eax
  8025a7:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8025aa:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8025ae:	74 07                	je     8025b7 <alloc_block_FF+0x1a5>
  8025b0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025b3:	8b 00                	mov    (%eax),%eax
  8025b5:	eb 05                	jmp    8025bc <alloc_block_FF+0x1aa>
  8025b7:	b8 00 00 00 00       	mov    $0x0,%eax
  8025bc:	a3 40 41 80 00       	mov    %eax,0x804140
  8025c1:	a1 40 41 80 00       	mov    0x804140,%eax
  8025c6:	85 c0                	test   %eax,%eax
  8025c8:	0f 85 65 fe ff ff    	jne    802433 <alloc_block_FF+0x21>
  8025ce:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8025d2:	0f 85 5b fe ff ff    	jne    802433 <alloc_block_FF+0x21>
			blk->sva+=newblk->size;
			newblk->sva = newveradd;
			return newblk;
		}
	}
	return NULL;
  8025d8:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8025dd:	c9                   	leave  
  8025de:	c3                   	ret    

008025df <alloc_block_BF>:

//=========================================
// [5] ALLOCATE BLOCK BY BEST FIT:
//=========================================
struct MemBlock *alloc_block_BF(uint32 size)
{
  8025df:	55                   	push   %ebp
  8025e0:	89 e5                	mov    %esp,%ebp
  8025e2:	83 ec 28             	sub    $0x28,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_BF
	// Write your code here, remove the panic and write your code
	//panic("alloc_block_BF() is not implemented yet...!!");
	uint32 versize=size;
  8025e5:	8b 45 08             	mov    0x8(%ebp),%eax
  8025e8:	89 45 e8             	mov    %eax,-0x18(%ebp)
	struct MemBlock* blk;
	struct MemBlock* newblk=LIST_FIRST(&AvailableMemBlocksList);
  8025eb:	a1 48 41 80 00       	mov    0x804148,%eax
  8025f0:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	uint32 newveradd;
	uint32 newsize;
	int size_free = LIST_SIZE(&FreeMemBlocksList);
  8025f3:	a1 44 41 80 00       	mov    0x804144,%eax
  8025f8:	89 45 e0             	mov    %eax,-0x20(%ebp)

	LIST_FOREACH(blk, &FreeMemBlocksList)
  8025fb:	a1 38 41 80 00       	mov    0x804138,%eax
  802600:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802603:	e9 a1 00 00 00       	jmp    8026a9 <alloc_block_BF+0xca>
	{
		if(blk->size == versize)
  802608:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80260b:	8b 40 0c             	mov    0xc(%eax),%eax
  80260e:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  802611:	0f 85 8a 00 00 00    	jne    8026a1 <alloc_block_BF+0xc2>
		{
			LIST_REMOVE(&FreeMemBlocksList, blk);
  802617:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80261b:	75 17                	jne    802634 <alloc_block_BF+0x55>
  80261d:	83 ec 04             	sub    $0x4,%esp
  802620:	68 88 3b 80 00       	push   $0x803b88
  802625:	68 c2 00 00 00       	push   $0xc2
  80262a:	68 17 3b 80 00       	push   $0x803b17
  80262f:	e8 14 09 00 00       	call   802f48 <_panic>
  802634:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802637:	8b 00                	mov    (%eax),%eax
  802639:	85 c0                	test   %eax,%eax
  80263b:	74 10                	je     80264d <alloc_block_BF+0x6e>
  80263d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802640:	8b 00                	mov    (%eax),%eax
  802642:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802645:	8b 52 04             	mov    0x4(%edx),%edx
  802648:	89 50 04             	mov    %edx,0x4(%eax)
  80264b:	eb 0b                	jmp    802658 <alloc_block_BF+0x79>
  80264d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802650:	8b 40 04             	mov    0x4(%eax),%eax
  802653:	a3 3c 41 80 00       	mov    %eax,0x80413c
  802658:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80265b:	8b 40 04             	mov    0x4(%eax),%eax
  80265e:	85 c0                	test   %eax,%eax
  802660:	74 0f                	je     802671 <alloc_block_BF+0x92>
  802662:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802665:	8b 40 04             	mov    0x4(%eax),%eax
  802668:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80266b:	8b 12                	mov    (%edx),%edx
  80266d:	89 10                	mov    %edx,(%eax)
  80266f:	eb 0a                	jmp    80267b <alloc_block_BF+0x9c>
  802671:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802674:	8b 00                	mov    (%eax),%eax
  802676:	a3 38 41 80 00       	mov    %eax,0x804138
  80267b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80267e:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802684:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802687:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80268e:	a1 44 41 80 00       	mov    0x804144,%eax
  802693:	48                   	dec    %eax
  802694:	a3 44 41 80 00       	mov    %eax,0x804144
			return blk;
  802699:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80269c:	e9 11 02 00 00       	jmp    8028b2 <alloc_block_BF+0x2d3>
	struct MemBlock* newblk=LIST_FIRST(&AvailableMemBlocksList);
	uint32 newveradd;
	uint32 newsize;
	int size_free = LIST_SIZE(&FreeMemBlocksList);

	LIST_FOREACH(blk, &FreeMemBlocksList)
  8026a1:	a1 40 41 80 00       	mov    0x804140,%eax
  8026a6:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8026a9:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8026ad:	74 07                	je     8026b6 <alloc_block_BF+0xd7>
  8026af:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026b2:	8b 00                	mov    (%eax),%eax
  8026b4:	eb 05                	jmp    8026bb <alloc_block_BF+0xdc>
  8026b6:	b8 00 00 00 00       	mov    $0x0,%eax
  8026bb:	a3 40 41 80 00       	mov    %eax,0x804140
  8026c0:	a1 40 41 80 00       	mov    0x804140,%eax
  8026c5:	85 c0                	test   %eax,%eax
  8026c7:	0f 85 3b ff ff ff    	jne    802608 <alloc_block_BF+0x29>
  8026cd:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8026d1:	0f 85 31 ff ff ff    	jne    802608 <alloc_block_BF+0x29>
		{
			LIST_REMOVE(&FreeMemBlocksList, blk);
			return blk;
		}
	}
	LIST_FOREACH(blk, &FreeMemBlocksList)
  8026d7:	a1 38 41 80 00       	mov    0x804138,%eax
  8026dc:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8026df:	eb 27                	jmp    802708 <alloc_block_BF+0x129>
	{
		if(blk->size > versize)
  8026e1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026e4:	8b 40 0c             	mov    0xc(%eax),%eax
  8026e7:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  8026ea:	76 14                	jbe    802700 <alloc_block_BF+0x121>
		{
			newsize = blk->size;
  8026ec:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026ef:	8b 40 0c             	mov    0xc(%eax),%eax
  8026f2:	89 45 ec             	mov    %eax,-0x14(%ebp)
			newveradd = blk->sva;
  8026f5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026f8:	8b 40 08             	mov    0x8(%eax),%eax
  8026fb:	89 45 f0             	mov    %eax,-0x10(%ebp)
			break;
  8026fe:	eb 2e                	jmp    80272e <alloc_block_BF+0x14f>
		{
			LIST_REMOVE(&FreeMemBlocksList, blk);
			return blk;
		}
	}
	LIST_FOREACH(blk, &FreeMemBlocksList)
  802700:	a1 40 41 80 00       	mov    0x804140,%eax
  802705:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802708:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80270c:	74 07                	je     802715 <alloc_block_BF+0x136>
  80270e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802711:	8b 00                	mov    (%eax),%eax
  802713:	eb 05                	jmp    80271a <alloc_block_BF+0x13b>
  802715:	b8 00 00 00 00       	mov    $0x0,%eax
  80271a:	a3 40 41 80 00       	mov    %eax,0x804140
  80271f:	a1 40 41 80 00       	mov    0x804140,%eax
  802724:	85 c0                	test   %eax,%eax
  802726:	75 b9                	jne    8026e1 <alloc_block_BF+0x102>
  802728:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80272c:	75 b3                	jne    8026e1 <alloc_block_BF+0x102>
			newsize = blk->size;
			newveradd = blk->sva;
			break;
		}
	}
	LIST_FOREACH(blk, &FreeMemBlocksList)
  80272e:	a1 38 41 80 00       	mov    0x804138,%eax
  802733:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802736:	eb 30                	jmp    802768 <alloc_block_BF+0x189>
	{
		if(newsize > blk->size && blk->size > versize)
  802738:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80273b:	8b 40 0c             	mov    0xc(%eax),%eax
  80273e:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  802741:	73 1d                	jae    802760 <alloc_block_BF+0x181>
  802743:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802746:	8b 40 0c             	mov    0xc(%eax),%eax
  802749:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  80274c:	76 12                	jbe    802760 <alloc_block_BF+0x181>
		{
	       newsize = blk->size;
  80274e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802751:	8b 40 0c             	mov    0xc(%eax),%eax
  802754:	89 45 ec             	mov    %eax,-0x14(%ebp)
		   newveradd = blk->sva;
  802757:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80275a:	8b 40 08             	mov    0x8(%eax),%eax
  80275d:	89 45 f0             	mov    %eax,-0x10(%ebp)
			newsize = blk->size;
			newveradd = blk->sva;
			break;
		}
	}
	LIST_FOREACH(blk, &FreeMemBlocksList)
  802760:	a1 40 41 80 00       	mov    0x804140,%eax
  802765:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802768:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80276c:	74 07                	je     802775 <alloc_block_BF+0x196>
  80276e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802771:	8b 00                	mov    (%eax),%eax
  802773:	eb 05                	jmp    80277a <alloc_block_BF+0x19b>
  802775:	b8 00 00 00 00       	mov    $0x0,%eax
  80277a:	a3 40 41 80 00       	mov    %eax,0x804140
  80277f:	a1 40 41 80 00       	mov    0x804140,%eax
  802784:	85 c0                	test   %eax,%eax
  802786:	75 b0                	jne    802738 <alloc_block_BF+0x159>
  802788:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80278c:	75 aa                	jne    802738 <alloc_block_BF+0x159>
		{
	       newsize = blk->size;
		   newveradd = blk->sva;
		}
	}
	LIST_FOREACH(blk, &FreeMemBlocksList)
  80278e:	a1 38 41 80 00       	mov    0x804138,%eax
  802793:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802796:	e9 e4 00 00 00       	jmp    80287f <alloc_block_BF+0x2a0>
	{
		if(blk->size == newsize && blk->sva == newveradd)
  80279b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80279e:	8b 40 0c             	mov    0xc(%eax),%eax
  8027a1:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  8027a4:	0f 85 cd 00 00 00    	jne    802877 <alloc_block_BF+0x298>
  8027aa:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027ad:	8b 40 08             	mov    0x8(%eax),%eax
  8027b0:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8027b3:	0f 85 be 00 00 00    	jne    802877 <alloc_block_BF+0x298>
		{
			LIST_REMOVE(&AvailableMemBlocksList, newblk);
  8027b9:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8027bd:	75 17                	jne    8027d6 <alloc_block_BF+0x1f7>
  8027bf:	83 ec 04             	sub    $0x4,%esp
  8027c2:	68 88 3b 80 00       	push   $0x803b88
  8027c7:	68 db 00 00 00       	push   $0xdb
  8027cc:	68 17 3b 80 00       	push   $0x803b17
  8027d1:	e8 72 07 00 00       	call   802f48 <_panic>
  8027d6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8027d9:	8b 00                	mov    (%eax),%eax
  8027db:	85 c0                	test   %eax,%eax
  8027dd:	74 10                	je     8027ef <alloc_block_BF+0x210>
  8027df:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8027e2:	8b 00                	mov    (%eax),%eax
  8027e4:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8027e7:	8b 52 04             	mov    0x4(%edx),%edx
  8027ea:	89 50 04             	mov    %edx,0x4(%eax)
  8027ed:	eb 0b                	jmp    8027fa <alloc_block_BF+0x21b>
  8027ef:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8027f2:	8b 40 04             	mov    0x4(%eax),%eax
  8027f5:	a3 4c 41 80 00       	mov    %eax,0x80414c
  8027fa:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8027fd:	8b 40 04             	mov    0x4(%eax),%eax
  802800:	85 c0                	test   %eax,%eax
  802802:	74 0f                	je     802813 <alloc_block_BF+0x234>
  802804:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802807:	8b 40 04             	mov    0x4(%eax),%eax
  80280a:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80280d:	8b 12                	mov    (%edx),%edx
  80280f:	89 10                	mov    %edx,(%eax)
  802811:	eb 0a                	jmp    80281d <alloc_block_BF+0x23e>
  802813:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802816:	8b 00                	mov    (%eax),%eax
  802818:	a3 48 41 80 00       	mov    %eax,0x804148
  80281d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802820:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802826:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802829:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802830:	a1 54 41 80 00       	mov    0x804154,%eax
  802835:	48                   	dec    %eax
  802836:	a3 54 41 80 00       	mov    %eax,0x804154
			newblk->size = versize;
  80283b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80283e:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802841:	89 50 0c             	mov    %edx,0xc(%eax)
			newblk->sva = newveradd;
  802844:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802847:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80284a:	89 50 08             	mov    %edx,0x8(%eax)
			blk->size = blk->size - versize;
  80284d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802850:	8b 40 0c             	mov    0xc(%eax),%eax
  802853:	2b 45 e8             	sub    -0x18(%ebp),%eax
  802856:	89 c2                	mov    %eax,%edx
  802858:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80285b:	89 50 0c             	mov    %edx,0xc(%eax)
			blk->sva+= newblk->size;
  80285e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802861:	8b 50 08             	mov    0x8(%eax),%edx
  802864:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802867:	8b 40 0c             	mov    0xc(%eax),%eax
  80286a:	01 c2                	add    %eax,%edx
  80286c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80286f:	89 50 08             	mov    %edx,0x8(%eax)
			return newblk;
  802872:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802875:	eb 3b                	jmp    8028b2 <alloc_block_BF+0x2d3>
		{
	       newsize = blk->size;
		   newveradd = blk->sva;
		}
	}
	LIST_FOREACH(blk, &FreeMemBlocksList)
  802877:	a1 40 41 80 00       	mov    0x804140,%eax
  80287c:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80287f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802883:	74 07                	je     80288c <alloc_block_BF+0x2ad>
  802885:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802888:	8b 00                	mov    (%eax),%eax
  80288a:	eb 05                	jmp    802891 <alloc_block_BF+0x2b2>
  80288c:	b8 00 00 00 00       	mov    $0x0,%eax
  802891:	a3 40 41 80 00       	mov    %eax,0x804140
  802896:	a1 40 41 80 00       	mov    0x804140,%eax
  80289b:	85 c0                	test   %eax,%eax
  80289d:	0f 85 f8 fe ff ff    	jne    80279b <alloc_block_BF+0x1bc>
  8028a3:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8028a7:	0f 85 ee fe ff ff    	jne    80279b <alloc_block_BF+0x1bc>
			blk->size = blk->size - versize;
			blk->sva+= newblk->size;
			return newblk;
		}
	}
	return NULL;
  8028ad:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8028b2:	c9                   	leave  
  8028b3:	c3                   	ret    

008028b4 <alloc_block_NF>:
//=========================================
// [7] ALLOCATE BLOCK BY NEXT FIT:
//=========================================
struct MemBlock *last_allocate;
struct MemBlock *alloc_block_NF(uint32 size)
{
  8028b4:	55                   	push   %ebp
  8028b5:	89 e5                	mov    %esp,%ebp
  8028b7:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1 - BONUS] [DYNAMIC ALLOCATOR] alloc_block_NF
	// Write your code here, remove the panic and write your code
	//panic("alloc_block_NF() is not implemented yet...!!");
	uint32 versize = size;
  8028ba:	8b 45 08             	mov    0x8(%ebp),%eax
  8028bd:	89 45 f0             	mov    %eax,-0x10(%ebp)
	struct MemBlock* blk;
	struct MemBlock* newblk = LIST_FIRST(&AvailableMemBlocksList);
  8028c0:	a1 48 41 80 00       	mov    0x804148,%eax
  8028c5:	89 45 ec             	mov    %eax,-0x14(%ebp)

	LIST_FOREACH(blk,&FreeMemBlocksList)
  8028c8:	a1 38 41 80 00       	mov    0x804138,%eax
  8028cd:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8028d0:	e9 77 01 00 00       	jmp    802a4c <alloc_block_NF+0x198>
	{
		if(blk->size == versize)
  8028d5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028d8:	8b 40 0c             	mov    0xc(%eax),%eax
  8028db:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8028de:	0f 85 8a 00 00 00    	jne    80296e <alloc_block_NF+0xba>
		{
			LIST_REMOVE(&FreeMemBlocksList,blk);
  8028e4:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8028e8:	75 17                	jne    802901 <alloc_block_NF+0x4d>
  8028ea:	83 ec 04             	sub    $0x4,%esp
  8028ed:	68 88 3b 80 00       	push   $0x803b88
  8028f2:	68 f7 00 00 00       	push   $0xf7
  8028f7:	68 17 3b 80 00       	push   $0x803b17
  8028fc:	e8 47 06 00 00       	call   802f48 <_panic>
  802901:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802904:	8b 00                	mov    (%eax),%eax
  802906:	85 c0                	test   %eax,%eax
  802908:	74 10                	je     80291a <alloc_block_NF+0x66>
  80290a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80290d:	8b 00                	mov    (%eax),%eax
  80290f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802912:	8b 52 04             	mov    0x4(%edx),%edx
  802915:	89 50 04             	mov    %edx,0x4(%eax)
  802918:	eb 0b                	jmp    802925 <alloc_block_NF+0x71>
  80291a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80291d:	8b 40 04             	mov    0x4(%eax),%eax
  802920:	a3 3c 41 80 00       	mov    %eax,0x80413c
  802925:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802928:	8b 40 04             	mov    0x4(%eax),%eax
  80292b:	85 c0                	test   %eax,%eax
  80292d:	74 0f                	je     80293e <alloc_block_NF+0x8a>
  80292f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802932:	8b 40 04             	mov    0x4(%eax),%eax
  802935:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802938:	8b 12                	mov    (%edx),%edx
  80293a:	89 10                	mov    %edx,(%eax)
  80293c:	eb 0a                	jmp    802948 <alloc_block_NF+0x94>
  80293e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802941:	8b 00                	mov    (%eax),%eax
  802943:	a3 38 41 80 00       	mov    %eax,0x804138
  802948:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80294b:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802951:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802954:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80295b:	a1 44 41 80 00       	mov    0x804144,%eax
  802960:	48                   	dec    %eax
  802961:	a3 44 41 80 00       	mov    %eax,0x804144
			return blk;
  802966:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802969:	e9 11 01 00 00       	jmp    802a7f <alloc_block_NF+0x1cb>
		}
		else if(blk->size > versize)
  80296e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802971:	8b 40 0c             	mov    0xc(%eax),%eax
  802974:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  802977:	0f 86 c7 00 00 00    	jbe    802a44 <alloc_block_NF+0x190>
		{
			LIST_REMOVE(&AvailableMemBlocksList,newblk);
  80297d:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802981:	75 17                	jne    80299a <alloc_block_NF+0xe6>
  802983:	83 ec 04             	sub    $0x4,%esp
  802986:	68 88 3b 80 00       	push   $0x803b88
  80298b:	68 fc 00 00 00       	push   $0xfc
  802990:	68 17 3b 80 00       	push   $0x803b17
  802995:	e8 ae 05 00 00       	call   802f48 <_panic>
  80299a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80299d:	8b 00                	mov    (%eax),%eax
  80299f:	85 c0                	test   %eax,%eax
  8029a1:	74 10                	je     8029b3 <alloc_block_NF+0xff>
  8029a3:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8029a6:	8b 00                	mov    (%eax),%eax
  8029a8:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8029ab:	8b 52 04             	mov    0x4(%edx),%edx
  8029ae:	89 50 04             	mov    %edx,0x4(%eax)
  8029b1:	eb 0b                	jmp    8029be <alloc_block_NF+0x10a>
  8029b3:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8029b6:	8b 40 04             	mov    0x4(%eax),%eax
  8029b9:	a3 4c 41 80 00       	mov    %eax,0x80414c
  8029be:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8029c1:	8b 40 04             	mov    0x4(%eax),%eax
  8029c4:	85 c0                	test   %eax,%eax
  8029c6:	74 0f                	je     8029d7 <alloc_block_NF+0x123>
  8029c8:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8029cb:	8b 40 04             	mov    0x4(%eax),%eax
  8029ce:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8029d1:	8b 12                	mov    (%edx),%edx
  8029d3:	89 10                	mov    %edx,(%eax)
  8029d5:	eb 0a                	jmp    8029e1 <alloc_block_NF+0x12d>
  8029d7:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8029da:	8b 00                	mov    (%eax),%eax
  8029dc:	a3 48 41 80 00       	mov    %eax,0x804148
  8029e1:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8029e4:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8029ea:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8029ed:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8029f4:	a1 54 41 80 00       	mov    0x804154,%eax
  8029f9:	48                   	dec    %eax
  8029fa:	a3 54 41 80 00       	mov    %eax,0x804154
			newblk->size = versize;
  8029ff:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802a02:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802a05:	89 50 0c             	mov    %edx,0xc(%eax)
			blk->size = blk->size-versize;
  802a08:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a0b:	8b 40 0c             	mov    0xc(%eax),%eax
  802a0e:	2b 45 f0             	sub    -0x10(%ebp),%eax
  802a11:	89 c2                	mov    %eax,%edx
  802a13:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a16:	89 50 0c             	mov    %edx,0xc(%eax)
			uint32 newveradd = blk->sva;
  802a19:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a1c:	8b 40 08             	mov    0x8(%eax),%eax
  802a1f:	89 45 e8             	mov    %eax,-0x18(%ebp)
			blk->sva+=newblk->size;
  802a22:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a25:	8b 50 08             	mov    0x8(%eax),%edx
  802a28:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802a2b:	8b 40 0c             	mov    0xc(%eax),%eax
  802a2e:	01 c2                	add    %eax,%edx
  802a30:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a33:	89 50 08             	mov    %edx,0x8(%eax)
			newblk->sva = newveradd;
  802a36:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802a39:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802a3c:	89 50 08             	mov    %edx,0x8(%eax)
			return newblk;
  802a3f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802a42:	eb 3b                	jmp    802a7f <alloc_block_NF+0x1cb>
	//panic("alloc_block_NF() is not implemented yet...!!");
	uint32 versize = size;
	struct MemBlock* blk;
	struct MemBlock* newblk = LIST_FIRST(&AvailableMemBlocksList);

	LIST_FOREACH(blk,&FreeMemBlocksList)
  802a44:	a1 40 41 80 00       	mov    0x804140,%eax
  802a49:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802a4c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802a50:	74 07                	je     802a59 <alloc_block_NF+0x1a5>
  802a52:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a55:	8b 00                	mov    (%eax),%eax
  802a57:	eb 05                	jmp    802a5e <alloc_block_NF+0x1aa>
  802a59:	b8 00 00 00 00       	mov    $0x0,%eax
  802a5e:	a3 40 41 80 00       	mov    %eax,0x804140
  802a63:	a1 40 41 80 00       	mov    0x804140,%eax
  802a68:	85 c0                	test   %eax,%eax
  802a6a:	0f 85 65 fe ff ff    	jne    8028d5 <alloc_block_NF+0x21>
  802a70:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802a74:	0f 85 5b fe ff ff    	jne    8028d5 <alloc_block_NF+0x21>
			blk->sva+=newblk->size;
			newblk->sva = newveradd;
			return newblk;
		}
	}
	return NULL;
  802a7a:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802a7f:	c9                   	leave  
  802a80:	c3                   	ret    

00802a81 <addToAvailMemBlocksList>:

//===================================================
// [8] INSERT BLOCK (SORTED WITH MERGE) IN FREE LIST:
//===================================================
void addToAvailMemBlocksList(struct MemBlock *blockToInsert)
{
  802a81:	55                   	push   %ebp
  802a82:	89 e5                	mov    %esp,%ebp
  802a84:	83 ec 08             	sub    $0x8,%esp
	blockToInsert->sva = 0;
  802a87:	8b 45 08             	mov    0x8(%ebp),%eax
  802a8a:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
	blockToInsert->size = 0;
  802a91:	8b 45 08             	mov    0x8(%ebp),%eax
  802a94:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
	//add to avail
	LIST_INSERT_TAIL(&AvailableMemBlocksList, blockToInsert);
  802a9b:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802a9f:	75 17                	jne    802ab8 <addToAvailMemBlocksList+0x37>
  802aa1:	83 ec 04             	sub    $0x4,%esp
  802aa4:	68 30 3b 80 00       	push   $0x803b30
  802aa9:	68 10 01 00 00       	push   $0x110
  802aae:	68 17 3b 80 00       	push   $0x803b17
  802ab3:	e8 90 04 00 00       	call   802f48 <_panic>
  802ab8:	8b 15 4c 41 80 00    	mov    0x80414c,%edx
  802abe:	8b 45 08             	mov    0x8(%ebp),%eax
  802ac1:	89 50 04             	mov    %edx,0x4(%eax)
  802ac4:	8b 45 08             	mov    0x8(%ebp),%eax
  802ac7:	8b 40 04             	mov    0x4(%eax),%eax
  802aca:	85 c0                	test   %eax,%eax
  802acc:	74 0c                	je     802ada <addToAvailMemBlocksList+0x59>
  802ace:	a1 4c 41 80 00       	mov    0x80414c,%eax
  802ad3:	8b 55 08             	mov    0x8(%ebp),%edx
  802ad6:	89 10                	mov    %edx,(%eax)
  802ad8:	eb 08                	jmp    802ae2 <addToAvailMemBlocksList+0x61>
  802ada:	8b 45 08             	mov    0x8(%ebp),%eax
  802add:	a3 48 41 80 00       	mov    %eax,0x804148
  802ae2:	8b 45 08             	mov    0x8(%ebp),%eax
  802ae5:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802aea:	8b 45 08             	mov    0x8(%ebp),%eax
  802aed:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802af3:	a1 54 41 80 00       	mov    0x804154,%eax
  802af8:	40                   	inc    %eax
  802af9:	a3 54 41 80 00       	mov    %eax,0x804154
}
  802afe:	90                   	nop
  802aff:	c9                   	leave  
  802b00:	c3                   	ret    

00802b01 <insert_sorted_with_merge_freeList>:
void insert_sorted_with_merge_freeList(struct MemBlock *blockToInsert)
{
  802b01:	55                   	push   %ebp
  802b02:	89 e5                	mov    %esp,%ebp
  802b04:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] insert_sorted_with_merge_freeList
	// Write your code here, remove the panic and write your code

	struct MemBlock* last = LIST_LAST(&FreeMemBlocksList);
  802b07:	a1 3c 41 80 00       	mov    0x80413c,%eax
  802b0c:	89 45 f0             	mov    %eax,-0x10(%ebp)
	//check if list empty
	if (LIST_SIZE(&(FreeMemBlocksList)) == 0)
  802b0f:	a1 44 41 80 00       	mov    0x804144,%eax
  802b14:	85 c0                	test   %eax,%eax
  802b16:	75 68                	jne    802b80 <insert_sorted_with_merge_freeList+0x7f>
		LIST_INSERT_HEAD(&FreeMemBlocksList, blockToInsert);
  802b18:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802b1c:	75 17                	jne    802b35 <insert_sorted_with_merge_freeList+0x34>
  802b1e:	83 ec 04             	sub    $0x4,%esp
  802b21:	68 f4 3a 80 00       	push   $0x803af4
  802b26:	68 1a 01 00 00       	push   $0x11a
  802b2b:	68 17 3b 80 00       	push   $0x803b17
  802b30:	e8 13 04 00 00       	call   802f48 <_panic>
  802b35:	8b 15 38 41 80 00    	mov    0x804138,%edx
  802b3b:	8b 45 08             	mov    0x8(%ebp),%eax
  802b3e:	89 10                	mov    %edx,(%eax)
  802b40:	8b 45 08             	mov    0x8(%ebp),%eax
  802b43:	8b 00                	mov    (%eax),%eax
  802b45:	85 c0                	test   %eax,%eax
  802b47:	74 0d                	je     802b56 <insert_sorted_with_merge_freeList+0x55>
  802b49:	a1 38 41 80 00       	mov    0x804138,%eax
  802b4e:	8b 55 08             	mov    0x8(%ebp),%edx
  802b51:	89 50 04             	mov    %edx,0x4(%eax)
  802b54:	eb 08                	jmp    802b5e <insert_sorted_with_merge_freeList+0x5d>
  802b56:	8b 45 08             	mov    0x8(%ebp),%eax
  802b59:	a3 3c 41 80 00       	mov    %eax,0x80413c
  802b5e:	8b 45 08             	mov    0x8(%ebp),%eax
  802b61:	a3 38 41 80 00       	mov    %eax,0x804138
  802b66:	8b 45 08             	mov    0x8(%ebp),%eax
  802b69:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802b70:	a1 44 41 80 00       	mov    0x804144,%eax
  802b75:	40                   	inc    %eax
  802b76:	a3 44 41 80 00       	mov    %eax,0x804144
		}
	}

	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  802b7b:	e9 c5 03 00 00       	jmp    802f45 <insert_sorted_with_merge_freeList+0x444>
	struct MemBlock* last = LIST_LAST(&FreeMemBlocksList);
	//check if list empty
	if (LIST_SIZE(&(FreeMemBlocksList)) == 0)
		LIST_INSERT_HEAD(&FreeMemBlocksList, blockToInsert);
	//check if it's position is at last
	else if (last->sva < blockToInsert->sva) {
  802b80:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b83:	8b 50 08             	mov    0x8(%eax),%edx
  802b86:	8b 45 08             	mov    0x8(%ebp),%eax
  802b89:	8b 40 08             	mov    0x8(%eax),%eax
  802b8c:	39 c2                	cmp    %eax,%edx
  802b8e:	0f 83 b2 00 00 00    	jae    802c46 <insert_sorted_with_merge_freeList+0x145>

		//if i have to merge
		if (last->sva + last->size == blockToInsert->sva) {
  802b94:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b97:	8b 50 08             	mov    0x8(%eax),%edx
  802b9a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b9d:	8b 40 0c             	mov    0xc(%eax),%eax
  802ba0:	01 c2                	add    %eax,%edx
  802ba2:	8b 45 08             	mov    0x8(%ebp),%eax
  802ba5:	8b 40 08             	mov    0x8(%eax),%eax
  802ba8:	39 c2                	cmp    %eax,%edx
  802baa:	75 27                	jne    802bd3 <insert_sorted_with_merge_freeList+0xd2>
			last->size = last->size + blockToInsert->size;
  802bac:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802baf:	8b 50 0c             	mov    0xc(%eax),%edx
  802bb2:	8b 45 08             	mov    0x8(%ebp),%eax
  802bb5:	8b 40 0c             	mov    0xc(%eax),%eax
  802bb8:	01 c2                	add    %eax,%edx
  802bba:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802bbd:	89 50 0c             	mov    %edx,0xc(%eax)
			addToAvailMemBlocksList(blockToInsert);
  802bc0:	83 ec 0c             	sub    $0xc,%esp
  802bc3:	ff 75 08             	pushl  0x8(%ebp)
  802bc6:	e8 b6 fe ff ff       	call   802a81 <addToAvailMemBlocksList>
  802bcb:	83 c4 10             	add    $0x10,%esp
		}
	}

	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  802bce:	e9 72 03 00 00       	jmp    802f45 <insert_sorted_with_merge_freeList+0x444>
		if (last->sva + last->size == blockToInsert->sva) {
			last->size = last->size + blockToInsert->size;
			addToAvailMemBlocksList(blockToInsert);

		} else {
			LIST_INSERT_AFTER(&FreeMemBlocksList, last, blockToInsert);
  802bd3:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802bd7:	74 06                	je     802bdf <insert_sorted_with_merge_freeList+0xde>
  802bd9:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802bdd:	75 17                	jne    802bf6 <insert_sorted_with_merge_freeList+0xf5>
  802bdf:	83 ec 04             	sub    $0x4,%esp
  802be2:	68 54 3b 80 00       	push   $0x803b54
  802be7:	68 24 01 00 00       	push   $0x124
  802bec:	68 17 3b 80 00       	push   $0x803b17
  802bf1:	e8 52 03 00 00       	call   802f48 <_panic>
  802bf6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802bf9:	8b 10                	mov    (%eax),%edx
  802bfb:	8b 45 08             	mov    0x8(%ebp),%eax
  802bfe:	89 10                	mov    %edx,(%eax)
  802c00:	8b 45 08             	mov    0x8(%ebp),%eax
  802c03:	8b 00                	mov    (%eax),%eax
  802c05:	85 c0                	test   %eax,%eax
  802c07:	74 0b                	je     802c14 <insert_sorted_with_merge_freeList+0x113>
  802c09:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c0c:	8b 00                	mov    (%eax),%eax
  802c0e:	8b 55 08             	mov    0x8(%ebp),%edx
  802c11:	89 50 04             	mov    %edx,0x4(%eax)
  802c14:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c17:	8b 55 08             	mov    0x8(%ebp),%edx
  802c1a:	89 10                	mov    %edx,(%eax)
  802c1c:	8b 45 08             	mov    0x8(%ebp),%eax
  802c1f:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802c22:	89 50 04             	mov    %edx,0x4(%eax)
  802c25:	8b 45 08             	mov    0x8(%ebp),%eax
  802c28:	8b 00                	mov    (%eax),%eax
  802c2a:	85 c0                	test   %eax,%eax
  802c2c:	75 08                	jne    802c36 <insert_sorted_with_merge_freeList+0x135>
  802c2e:	8b 45 08             	mov    0x8(%ebp),%eax
  802c31:	a3 3c 41 80 00       	mov    %eax,0x80413c
  802c36:	a1 44 41 80 00       	mov    0x804144,%eax
  802c3b:	40                   	inc    %eax
  802c3c:	a3 44 41 80 00       	mov    %eax,0x804144
		}
	}

	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  802c41:	e9 ff 02 00 00       	jmp    802f45 <insert_sorted_with_merge_freeList+0x444>
		} else {
			LIST_INSERT_AFTER(&FreeMemBlocksList, last, blockToInsert);
		}
	} else {
		struct MemBlock *iterator;
		LIST_FOREACH(iterator, &(FreeMemBlocksList))
  802c46:	a1 38 41 80 00       	mov    0x804138,%eax
  802c4b:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802c4e:	e9 c2 02 00 00       	jmp    802f15 <insert_sorted_with_merge_freeList+0x414>
		{

			if (iterator->sva > blockToInsert->sva) {
  802c53:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c56:	8b 50 08             	mov    0x8(%eax),%edx
  802c59:	8b 45 08             	mov    0x8(%ebp),%eax
  802c5c:	8b 40 08             	mov    0x8(%eax),%eax
  802c5f:	39 c2                	cmp    %eax,%edx
  802c61:	0f 86 a6 02 00 00    	jbe    802f0d <insert_sorted_with_merge_freeList+0x40c>

				struct MemBlock* prev = LIST_PREV(iterator);
  802c67:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c6a:	8b 40 04             	mov    0x4(%eax),%eax
  802c6d:	89 45 ec             	mov    %eax,-0x14(%ebp)
				if (prev == NULL) {
  802c70:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802c74:	0f 85 ba 00 00 00    	jne    802d34 <insert_sorted_with_merge_freeList+0x233>
					//check merge
					if (blockToInsert->size + blockToInsert->sva
  802c7a:	8b 45 08             	mov    0x8(%ebp),%eax
  802c7d:	8b 50 0c             	mov    0xc(%eax),%edx
  802c80:	8b 45 08             	mov    0x8(%ebp),%eax
  802c83:	8b 40 08             	mov    0x8(%eax),%eax
  802c86:	01 c2                	add    %eax,%edx
							== iterator->sva) {
  802c88:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c8b:	8b 40 08             	mov    0x8(%eax),%eax
			if (iterator->sva > blockToInsert->sva) {

				struct MemBlock* prev = LIST_PREV(iterator);
				if (prev == NULL) {
					//check merge
					if (blockToInsert->size + blockToInsert->sva
  802c8e:	39 c2                	cmp    %eax,%edx
  802c90:	75 33                	jne    802cc5 <insert_sorted_with_merge_freeList+0x1c4>
							== iterator->sva) {
						iterator->sva = blockToInsert->sva;
  802c92:	8b 45 08             	mov    0x8(%ebp),%eax
  802c95:	8b 50 08             	mov    0x8(%eax),%edx
  802c98:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c9b:	89 50 08             	mov    %edx,0x8(%eax)
						iterator->size = iterator->size + blockToInsert->size;
  802c9e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ca1:	8b 50 0c             	mov    0xc(%eax),%edx
  802ca4:	8b 45 08             	mov    0x8(%ebp),%eax
  802ca7:	8b 40 0c             	mov    0xc(%eax),%eax
  802caa:	01 c2                	add    %eax,%edx
  802cac:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802caf:	89 50 0c             	mov    %edx,0xc(%eax)
						addToAvailMemBlocksList(blockToInsert);
  802cb2:	83 ec 0c             	sub    $0xc,%esp
  802cb5:	ff 75 08             	pushl  0x8(%ebp)
  802cb8:	e8 c4 fd ff ff       	call   802a81 <addToAvailMemBlocksList>
  802cbd:	83 c4 10             	add    $0x10,%esp

					else {
						LIST_INSERT_BEFORE(&FreeMemBlocksList, iterator,
								blockToInsert);
					}
					break;
  802cc0:	e9 80 02 00 00       	jmp    802f45 <insert_sorted_with_merge_freeList+0x444>
						addToAvailMemBlocksList(blockToInsert);

					}

					else {
						LIST_INSERT_BEFORE(&FreeMemBlocksList, iterator,
  802cc5:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802cc9:	74 06                	je     802cd1 <insert_sorted_with_merge_freeList+0x1d0>
  802ccb:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802ccf:	75 17                	jne    802ce8 <insert_sorted_with_merge_freeList+0x1e7>
  802cd1:	83 ec 04             	sub    $0x4,%esp
  802cd4:	68 a8 3b 80 00       	push   $0x803ba8
  802cd9:	68 3a 01 00 00       	push   $0x13a
  802cde:	68 17 3b 80 00       	push   $0x803b17
  802ce3:	e8 60 02 00 00       	call   802f48 <_panic>
  802ce8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ceb:	8b 50 04             	mov    0x4(%eax),%edx
  802cee:	8b 45 08             	mov    0x8(%ebp),%eax
  802cf1:	89 50 04             	mov    %edx,0x4(%eax)
  802cf4:	8b 45 08             	mov    0x8(%ebp),%eax
  802cf7:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802cfa:	89 10                	mov    %edx,(%eax)
  802cfc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cff:	8b 40 04             	mov    0x4(%eax),%eax
  802d02:	85 c0                	test   %eax,%eax
  802d04:	74 0d                	je     802d13 <insert_sorted_with_merge_freeList+0x212>
  802d06:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d09:	8b 40 04             	mov    0x4(%eax),%eax
  802d0c:	8b 55 08             	mov    0x8(%ebp),%edx
  802d0f:	89 10                	mov    %edx,(%eax)
  802d11:	eb 08                	jmp    802d1b <insert_sorted_with_merge_freeList+0x21a>
  802d13:	8b 45 08             	mov    0x8(%ebp),%eax
  802d16:	a3 38 41 80 00       	mov    %eax,0x804138
  802d1b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d1e:	8b 55 08             	mov    0x8(%ebp),%edx
  802d21:	89 50 04             	mov    %edx,0x4(%eax)
  802d24:	a1 44 41 80 00       	mov    0x804144,%eax
  802d29:	40                   	inc    %eax
  802d2a:	a3 44 41 80 00       	mov    %eax,0x804144
								blockToInsert);
					}
					break;
  802d2f:	e9 11 02 00 00       	jmp    802f45 <insert_sorted_with_merge_freeList+0x444>
				} else {
					//prev and next merge
					if (prev->sva + prev->size + blockToInsert->size
  802d34:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802d37:	8b 50 08             	mov    0x8(%eax),%edx
  802d3a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802d3d:	8b 40 0c             	mov    0xc(%eax),%eax
  802d40:	01 c2                	add    %eax,%edx
  802d42:	8b 45 08             	mov    0x8(%ebp),%eax
  802d45:	8b 40 0c             	mov    0xc(%eax),%eax
  802d48:	01 c2                	add    %eax,%edx
							== iterator->sva) {
  802d4a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d4d:	8b 40 08             	mov    0x8(%eax),%eax
								blockToInsert);
					}
					break;
				} else {
					//prev and next merge
					if (prev->sva + prev->size + blockToInsert->size
  802d50:	39 c2                	cmp    %eax,%edx
  802d52:	0f 85 bf 00 00 00    	jne    802e17 <insert_sorted_with_merge_freeList+0x316>
							== iterator->sva) {
						prev->size = prev->size + blockToInsert->size
  802d58:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802d5b:	8b 50 0c             	mov    0xc(%eax),%edx
  802d5e:	8b 45 08             	mov    0x8(%ebp),%eax
  802d61:	8b 40 0c             	mov    0xc(%eax),%eax
  802d64:	01 c2                	add    %eax,%edx
								+ iterator->size;
  802d66:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d69:	8b 40 0c             	mov    0xc(%eax),%eax
  802d6c:	01 c2                	add    %eax,%edx
					break;
				} else {
					//prev and next merge
					if (prev->sva + prev->size + blockToInsert->size
							== iterator->sva) {
						prev->size = prev->size + blockToInsert->size
  802d6e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802d71:	89 50 0c             	mov    %edx,0xc(%eax)
								+ iterator->size;
						LIST_REMOVE(&FreeMemBlocksList, iterator);
  802d74:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802d78:	75 17                	jne    802d91 <insert_sorted_with_merge_freeList+0x290>
  802d7a:	83 ec 04             	sub    $0x4,%esp
  802d7d:	68 88 3b 80 00       	push   $0x803b88
  802d82:	68 43 01 00 00       	push   $0x143
  802d87:	68 17 3b 80 00       	push   $0x803b17
  802d8c:	e8 b7 01 00 00       	call   802f48 <_panic>
  802d91:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d94:	8b 00                	mov    (%eax),%eax
  802d96:	85 c0                	test   %eax,%eax
  802d98:	74 10                	je     802daa <insert_sorted_with_merge_freeList+0x2a9>
  802d9a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d9d:	8b 00                	mov    (%eax),%eax
  802d9f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802da2:	8b 52 04             	mov    0x4(%edx),%edx
  802da5:	89 50 04             	mov    %edx,0x4(%eax)
  802da8:	eb 0b                	jmp    802db5 <insert_sorted_with_merge_freeList+0x2b4>
  802daa:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802dad:	8b 40 04             	mov    0x4(%eax),%eax
  802db0:	a3 3c 41 80 00       	mov    %eax,0x80413c
  802db5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802db8:	8b 40 04             	mov    0x4(%eax),%eax
  802dbb:	85 c0                	test   %eax,%eax
  802dbd:	74 0f                	je     802dce <insert_sorted_with_merge_freeList+0x2cd>
  802dbf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802dc2:	8b 40 04             	mov    0x4(%eax),%eax
  802dc5:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802dc8:	8b 12                	mov    (%edx),%edx
  802dca:	89 10                	mov    %edx,(%eax)
  802dcc:	eb 0a                	jmp    802dd8 <insert_sorted_with_merge_freeList+0x2d7>
  802dce:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802dd1:	8b 00                	mov    (%eax),%eax
  802dd3:	a3 38 41 80 00       	mov    %eax,0x804138
  802dd8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ddb:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802de1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802de4:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802deb:	a1 44 41 80 00       	mov    0x804144,%eax
  802df0:	48                   	dec    %eax
  802df1:	a3 44 41 80 00       	mov    %eax,0x804144
						addToAvailMemBlocksList(blockToInsert);
  802df6:	83 ec 0c             	sub    $0xc,%esp
  802df9:	ff 75 08             	pushl  0x8(%ebp)
  802dfc:	e8 80 fc ff ff       	call   802a81 <addToAvailMemBlocksList>
  802e01:	83 c4 10             	add    $0x10,%esp
						addToAvailMemBlocksList(iterator);
  802e04:	83 ec 0c             	sub    $0xc,%esp
  802e07:	ff 75 f4             	pushl  -0xc(%ebp)
  802e0a:	e8 72 fc ff ff       	call   802a81 <addToAvailMemBlocksList>
  802e0f:	83 c4 10             	add    $0x10,%esp
					//Insert
					else {
						LIST_INSERT_BEFORE(&FreeMemBlocksList, iterator,
								blockToInsert);
					}
					break;
  802e12:	e9 2e 01 00 00       	jmp    802f45 <insert_sorted_with_merge_freeList+0x444>
						LIST_REMOVE(&FreeMemBlocksList, iterator);
						addToAvailMemBlocksList(blockToInsert);
						addToAvailMemBlocksList(iterator);
					}
					//previous merge
					else if (prev->sva + prev->size == blockToInsert->sva) {
  802e17:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802e1a:	8b 50 08             	mov    0x8(%eax),%edx
  802e1d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802e20:	8b 40 0c             	mov    0xc(%eax),%eax
  802e23:	01 c2                	add    %eax,%edx
  802e25:	8b 45 08             	mov    0x8(%ebp),%eax
  802e28:	8b 40 08             	mov    0x8(%eax),%eax
  802e2b:	39 c2                	cmp    %eax,%edx
  802e2d:	75 27                	jne    802e56 <insert_sorted_with_merge_freeList+0x355>
						prev->size = prev->size + blockToInsert->size;
  802e2f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802e32:	8b 50 0c             	mov    0xc(%eax),%edx
  802e35:	8b 45 08             	mov    0x8(%ebp),%eax
  802e38:	8b 40 0c             	mov    0xc(%eax),%eax
  802e3b:	01 c2                	add    %eax,%edx
  802e3d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802e40:	89 50 0c             	mov    %edx,0xc(%eax)
						addToAvailMemBlocksList(blockToInsert);
  802e43:	83 ec 0c             	sub    $0xc,%esp
  802e46:	ff 75 08             	pushl  0x8(%ebp)
  802e49:	e8 33 fc ff ff       	call   802a81 <addToAvailMemBlocksList>
  802e4e:	83 c4 10             	add    $0x10,%esp
					//Insert
					else {
						LIST_INSERT_BEFORE(&FreeMemBlocksList, iterator,
								blockToInsert);
					}
					break;
  802e51:	e9 ef 00 00 00       	jmp    802f45 <insert_sorted_with_merge_freeList+0x444>
					else if (prev->sva + prev->size == blockToInsert->sva) {
						prev->size = prev->size + blockToInsert->size;
						addToAvailMemBlocksList(blockToInsert);
					}
					//next merge
					else if (blockToInsert->size + blockToInsert->sva
  802e56:	8b 45 08             	mov    0x8(%ebp),%eax
  802e59:	8b 50 0c             	mov    0xc(%eax),%edx
  802e5c:	8b 45 08             	mov    0x8(%ebp),%eax
  802e5f:	8b 40 08             	mov    0x8(%eax),%eax
  802e62:	01 c2                	add    %eax,%edx
							== iterator->sva) {
  802e64:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e67:	8b 40 08             	mov    0x8(%eax),%eax
					else if (prev->sva + prev->size == blockToInsert->sva) {
						prev->size = prev->size + blockToInsert->size;
						addToAvailMemBlocksList(blockToInsert);
					}
					//next merge
					else if (blockToInsert->size + blockToInsert->sva
  802e6a:	39 c2                	cmp    %eax,%edx
  802e6c:	75 33                	jne    802ea1 <insert_sorted_with_merge_freeList+0x3a0>
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
  802e94:	e8 e8 fb ff ff       	call   802a81 <addToAvailMemBlocksList>
  802e99:	83 c4 10             	add    $0x10,%esp
					//Insert
					else {
						LIST_INSERT_BEFORE(&FreeMemBlocksList, iterator,
								blockToInsert);
					}
					break;
  802e9c:	e9 a4 00 00 00       	jmp    802f45 <insert_sorted_with_merge_freeList+0x444>
						iterator->size = iterator->size + blockToInsert->size;
						addToAvailMemBlocksList(blockToInsert);
					}
					//Insert
					else {
						LIST_INSERT_BEFORE(&FreeMemBlocksList, iterator,
  802ea1:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802ea5:	74 06                	je     802ead <insert_sorted_with_merge_freeList+0x3ac>
  802ea7:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802eab:	75 17                	jne    802ec4 <insert_sorted_with_merge_freeList+0x3c3>
  802ead:	83 ec 04             	sub    $0x4,%esp
  802eb0:	68 a8 3b 80 00       	push   $0x803ba8
  802eb5:	68 56 01 00 00       	push   $0x156
  802eba:	68 17 3b 80 00       	push   $0x803b17
  802ebf:	e8 84 00 00 00       	call   802f48 <_panic>
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
  802ee0:	74 0d                	je     802eef <insert_sorted_with_merge_freeList+0x3ee>
  802ee2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ee5:	8b 40 04             	mov    0x4(%eax),%eax
  802ee8:	8b 55 08             	mov    0x8(%ebp),%edx
  802eeb:	89 10                	mov    %edx,(%eax)
  802eed:	eb 08                	jmp    802ef7 <insert_sorted_with_merge_freeList+0x3f6>
  802eef:	8b 45 08             	mov    0x8(%ebp),%eax
  802ef2:	a3 38 41 80 00       	mov    %eax,0x804138
  802ef7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802efa:	8b 55 08             	mov    0x8(%ebp),%edx
  802efd:	89 50 04             	mov    %edx,0x4(%eax)
  802f00:	a1 44 41 80 00       	mov    0x804144,%eax
  802f05:	40                   	inc    %eax
  802f06:	a3 44 41 80 00       	mov    %eax,0x804144
								blockToInsert);
					}
					break;
  802f0b:	eb 38                	jmp    802f45 <insert_sorted_with_merge_freeList+0x444>
		} else {
			LIST_INSERT_AFTER(&FreeMemBlocksList, last, blockToInsert);
		}
	} else {
		struct MemBlock *iterator;
		LIST_FOREACH(iterator, &(FreeMemBlocksList))
  802f0d:	a1 40 41 80 00       	mov    0x804140,%eax
  802f12:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802f15:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802f19:	74 07                	je     802f22 <insert_sorted_with_merge_freeList+0x421>
  802f1b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f1e:	8b 00                	mov    (%eax),%eax
  802f20:	eb 05                	jmp    802f27 <insert_sorted_with_merge_freeList+0x426>
  802f22:	b8 00 00 00 00       	mov    $0x0,%eax
  802f27:	a3 40 41 80 00       	mov    %eax,0x804140
  802f2c:	a1 40 41 80 00       	mov    0x804140,%eax
  802f31:	85 c0                	test   %eax,%eax
  802f33:	0f 85 1a fd ff ff    	jne    802c53 <insert_sorted_with_merge_freeList+0x152>
  802f39:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802f3d:	0f 85 10 fd ff ff    	jne    802c53 <insert_sorted_with_merge_freeList+0x152>
		}
	}

	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  802f43:	eb 00                	jmp    802f45 <insert_sorted_with_merge_freeList+0x444>
  802f45:	90                   	nop
  802f46:	c9                   	leave  
  802f47:	c3                   	ret    

00802f48 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  802f48:	55                   	push   %ebp
  802f49:	89 e5                	mov    %esp,%ebp
  802f4b:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  802f4e:	8d 45 10             	lea    0x10(%ebp),%eax
  802f51:	83 c0 04             	add    $0x4,%eax
  802f54:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  802f57:	a1 60 41 80 00       	mov    0x804160,%eax
  802f5c:	85 c0                	test   %eax,%eax
  802f5e:	74 16                	je     802f76 <_panic+0x2e>
		cprintf("%s: ", argv0);
  802f60:	a1 60 41 80 00       	mov    0x804160,%eax
  802f65:	83 ec 08             	sub    $0x8,%esp
  802f68:	50                   	push   %eax
  802f69:	68 e0 3b 80 00       	push   $0x803be0
  802f6e:	e8 af d6 ff ff       	call   800622 <cprintf>
  802f73:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  802f76:	a1 00 40 80 00       	mov    0x804000,%eax
  802f7b:	ff 75 0c             	pushl  0xc(%ebp)
  802f7e:	ff 75 08             	pushl  0x8(%ebp)
  802f81:	50                   	push   %eax
  802f82:	68 e5 3b 80 00       	push   $0x803be5
  802f87:	e8 96 d6 ff ff       	call   800622 <cprintf>
  802f8c:	83 c4 10             	add    $0x10,%esp
	vcprintf(fmt, ap);
  802f8f:	8b 45 10             	mov    0x10(%ebp),%eax
  802f92:	83 ec 08             	sub    $0x8,%esp
  802f95:	ff 75 f4             	pushl  -0xc(%ebp)
  802f98:	50                   	push   %eax
  802f99:	e8 19 d6 ff ff       	call   8005b7 <vcprintf>
  802f9e:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  802fa1:	83 ec 08             	sub    $0x8,%esp
  802fa4:	6a 00                	push   $0x0
  802fa6:	68 01 3c 80 00       	push   $0x803c01
  802fab:	e8 07 d6 ff ff       	call   8005b7 <vcprintf>
  802fb0:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  802fb3:	e8 88 d5 ff ff       	call   800540 <exit>

	// should not return here
	while (1) ;
  802fb8:	eb fe                	jmp    802fb8 <_panic+0x70>

00802fba <CheckWSWithoutLastIndex>:
}

void CheckWSWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  802fba:	55                   	push   %ebp
  802fbb:	89 e5                	mov    %esp,%ebp
  802fbd:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  802fc0:	a1 20 40 80 00       	mov    0x804020,%eax
  802fc5:	8b 50 74             	mov    0x74(%eax),%edx
  802fc8:	8b 45 0c             	mov    0xc(%ebp),%eax
  802fcb:	39 c2                	cmp    %eax,%edx
  802fcd:	74 14                	je     802fe3 <CheckWSWithoutLastIndex+0x29>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  802fcf:	83 ec 04             	sub    $0x4,%esp
  802fd2:	68 04 3c 80 00       	push   $0x803c04
  802fd7:	6a 26                	push   $0x26
  802fd9:	68 50 3c 80 00       	push   $0x803c50
  802fde:	e8 65 ff ff ff       	call   802f48 <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  802fe3:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  802fea:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  802ff1:	e9 c2 00 00 00       	jmp    8030b8 <CheckWSWithoutLastIndex+0xfe>
		if (expectedPages[e] == 0) {
  802ff6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802ff9:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  803000:	8b 45 08             	mov    0x8(%ebp),%eax
  803003:	01 d0                	add    %edx,%eax
  803005:	8b 00                	mov    (%eax),%eax
  803007:	85 c0                	test   %eax,%eax
  803009:	75 08                	jne    803013 <CheckWSWithoutLastIndex+0x59>
			expectedNumOfEmptyLocs++;
  80300b:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  80300e:	e9 a2 00 00 00       	jmp    8030b5 <CheckWSWithoutLastIndex+0xfb>
		}
		int found = 0;
  803013:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  80301a:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  803021:	eb 69                	jmp    80308c <CheckWSWithoutLastIndex+0xd2>
			if (myEnv->__uptr_pws[w].empty == 0) {
  803023:	a1 20 40 80 00       	mov    0x804020,%eax
  803028:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  80302e:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803031:	89 d0                	mov    %edx,%eax
  803033:	01 c0                	add    %eax,%eax
  803035:	01 d0                	add    %edx,%eax
  803037:	c1 e0 03             	shl    $0x3,%eax
  80303a:	01 c8                	add    %ecx,%eax
  80303c:	8a 40 04             	mov    0x4(%eax),%al
  80303f:	84 c0                	test   %al,%al
  803041:	75 46                	jne    803089 <CheckWSWithoutLastIndex+0xcf>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  803043:	a1 20 40 80 00       	mov    0x804020,%eax
  803048:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  80304e:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803051:	89 d0                	mov    %edx,%eax
  803053:	01 c0                	add    %eax,%eax
  803055:	01 d0                	add    %edx,%eax
  803057:	c1 e0 03             	shl    $0x3,%eax
  80305a:	01 c8                	add    %ecx,%eax
  80305c:	8b 00                	mov    (%eax),%eax
  80305e:	89 45 dc             	mov    %eax,-0x24(%ebp)
  803061:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803064:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  803069:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  80306b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80306e:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  803075:	8b 45 08             	mov    0x8(%ebp),%eax
  803078:	01 c8                	add    %ecx,%eax
  80307a:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  80307c:	39 c2                	cmp    %eax,%edx
  80307e:	75 09                	jne    803089 <CheckWSWithoutLastIndex+0xcf>
						== expectedPages[e]) {
					found = 1;
  803080:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  803087:	eb 12                	jmp    80309b <CheckWSWithoutLastIndex+0xe1>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  803089:	ff 45 e8             	incl   -0x18(%ebp)
  80308c:	a1 20 40 80 00       	mov    0x804020,%eax
  803091:	8b 50 74             	mov    0x74(%eax),%edx
  803094:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803097:	39 c2                	cmp    %eax,%edx
  803099:	77 88                	ja     803023 <CheckWSWithoutLastIndex+0x69>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  80309b:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  80309f:	75 14                	jne    8030b5 <CheckWSWithoutLastIndex+0xfb>
			panic(
  8030a1:	83 ec 04             	sub    $0x4,%esp
  8030a4:	68 5c 3c 80 00       	push   $0x803c5c
  8030a9:	6a 3a                	push   $0x3a
  8030ab:	68 50 3c 80 00       	push   $0x803c50
  8030b0:	e8 93 fe ff ff       	call   802f48 <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  8030b5:	ff 45 f0             	incl   -0x10(%ebp)
  8030b8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8030bb:	3b 45 0c             	cmp    0xc(%ebp),%eax
  8030be:	0f 8c 32 ff ff ff    	jl     802ff6 <CheckWSWithoutLastIndex+0x3c>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  8030c4:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8030cb:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  8030d2:	eb 26                	jmp    8030fa <CheckWSWithoutLastIndex+0x140>
		if (myEnv->__uptr_pws[w].empty == 1) {
  8030d4:	a1 20 40 80 00       	mov    0x804020,%eax
  8030d9:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  8030df:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8030e2:	89 d0                	mov    %edx,%eax
  8030e4:	01 c0                	add    %eax,%eax
  8030e6:	01 d0                	add    %edx,%eax
  8030e8:	c1 e0 03             	shl    $0x3,%eax
  8030eb:	01 c8                	add    %ecx,%eax
  8030ed:	8a 40 04             	mov    0x4(%eax),%al
  8030f0:	3c 01                	cmp    $0x1,%al
  8030f2:	75 03                	jne    8030f7 <CheckWSWithoutLastIndex+0x13d>
			actualNumOfEmptyLocs++;
  8030f4:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8030f7:	ff 45 e0             	incl   -0x20(%ebp)
  8030fa:	a1 20 40 80 00       	mov    0x804020,%eax
  8030ff:	8b 50 74             	mov    0x74(%eax),%edx
  803102:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803105:	39 c2                	cmp    %eax,%edx
  803107:	77 cb                	ja     8030d4 <CheckWSWithoutLastIndex+0x11a>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  803109:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80310c:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  80310f:	74 14                	je     803125 <CheckWSWithoutLastIndex+0x16b>
		panic(
  803111:	83 ec 04             	sub    $0x4,%esp
  803114:	68 b0 3c 80 00       	push   $0x803cb0
  803119:	6a 44                	push   $0x44
  80311b:	68 50 3c 80 00       	push   $0x803c50
  803120:	e8 23 fe ff ff       	call   802f48 <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  803125:	90                   	nop
  803126:	c9                   	leave  
  803127:	c3                   	ret    

00803128 <__udivdi3>:
  803128:	55                   	push   %ebp
  803129:	57                   	push   %edi
  80312a:	56                   	push   %esi
  80312b:	53                   	push   %ebx
  80312c:	83 ec 1c             	sub    $0x1c,%esp
  80312f:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  803133:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  803137:	8b 7c 24 38          	mov    0x38(%esp),%edi
  80313b:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  80313f:	89 ca                	mov    %ecx,%edx
  803141:	89 f8                	mov    %edi,%eax
  803143:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  803147:	85 f6                	test   %esi,%esi
  803149:	75 2d                	jne    803178 <__udivdi3+0x50>
  80314b:	39 cf                	cmp    %ecx,%edi
  80314d:	77 65                	ja     8031b4 <__udivdi3+0x8c>
  80314f:	89 fd                	mov    %edi,%ebp
  803151:	85 ff                	test   %edi,%edi
  803153:	75 0b                	jne    803160 <__udivdi3+0x38>
  803155:	b8 01 00 00 00       	mov    $0x1,%eax
  80315a:	31 d2                	xor    %edx,%edx
  80315c:	f7 f7                	div    %edi
  80315e:	89 c5                	mov    %eax,%ebp
  803160:	31 d2                	xor    %edx,%edx
  803162:	89 c8                	mov    %ecx,%eax
  803164:	f7 f5                	div    %ebp
  803166:	89 c1                	mov    %eax,%ecx
  803168:	89 d8                	mov    %ebx,%eax
  80316a:	f7 f5                	div    %ebp
  80316c:	89 cf                	mov    %ecx,%edi
  80316e:	89 fa                	mov    %edi,%edx
  803170:	83 c4 1c             	add    $0x1c,%esp
  803173:	5b                   	pop    %ebx
  803174:	5e                   	pop    %esi
  803175:	5f                   	pop    %edi
  803176:	5d                   	pop    %ebp
  803177:	c3                   	ret    
  803178:	39 ce                	cmp    %ecx,%esi
  80317a:	77 28                	ja     8031a4 <__udivdi3+0x7c>
  80317c:	0f bd fe             	bsr    %esi,%edi
  80317f:	83 f7 1f             	xor    $0x1f,%edi
  803182:	75 40                	jne    8031c4 <__udivdi3+0x9c>
  803184:	39 ce                	cmp    %ecx,%esi
  803186:	72 0a                	jb     803192 <__udivdi3+0x6a>
  803188:	3b 44 24 08          	cmp    0x8(%esp),%eax
  80318c:	0f 87 9e 00 00 00    	ja     803230 <__udivdi3+0x108>
  803192:	b8 01 00 00 00       	mov    $0x1,%eax
  803197:	89 fa                	mov    %edi,%edx
  803199:	83 c4 1c             	add    $0x1c,%esp
  80319c:	5b                   	pop    %ebx
  80319d:	5e                   	pop    %esi
  80319e:	5f                   	pop    %edi
  80319f:	5d                   	pop    %ebp
  8031a0:	c3                   	ret    
  8031a1:	8d 76 00             	lea    0x0(%esi),%esi
  8031a4:	31 ff                	xor    %edi,%edi
  8031a6:	31 c0                	xor    %eax,%eax
  8031a8:	89 fa                	mov    %edi,%edx
  8031aa:	83 c4 1c             	add    $0x1c,%esp
  8031ad:	5b                   	pop    %ebx
  8031ae:	5e                   	pop    %esi
  8031af:	5f                   	pop    %edi
  8031b0:	5d                   	pop    %ebp
  8031b1:	c3                   	ret    
  8031b2:	66 90                	xchg   %ax,%ax
  8031b4:	89 d8                	mov    %ebx,%eax
  8031b6:	f7 f7                	div    %edi
  8031b8:	31 ff                	xor    %edi,%edi
  8031ba:	89 fa                	mov    %edi,%edx
  8031bc:	83 c4 1c             	add    $0x1c,%esp
  8031bf:	5b                   	pop    %ebx
  8031c0:	5e                   	pop    %esi
  8031c1:	5f                   	pop    %edi
  8031c2:	5d                   	pop    %ebp
  8031c3:	c3                   	ret    
  8031c4:	bd 20 00 00 00       	mov    $0x20,%ebp
  8031c9:	89 eb                	mov    %ebp,%ebx
  8031cb:	29 fb                	sub    %edi,%ebx
  8031cd:	89 f9                	mov    %edi,%ecx
  8031cf:	d3 e6                	shl    %cl,%esi
  8031d1:	89 c5                	mov    %eax,%ebp
  8031d3:	88 d9                	mov    %bl,%cl
  8031d5:	d3 ed                	shr    %cl,%ebp
  8031d7:	89 e9                	mov    %ebp,%ecx
  8031d9:	09 f1                	or     %esi,%ecx
  8031db:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  8031df:	89 f9                	mov    %edi,%ecx
  8031e1:	d3 e0                	shl    %cl,%eax
  8031e3:	89 c5                	mov    %eax,%ebp
  8031e5:	89 d6                	mov    %edx,%esi
  8031e7:	88 d9                	mov    %bl,%cl
  8031e9:	d3 ee                	shr    %cl,%esi
  8031eb:	89 f9                	mov    %edi,%ecx
  8031ed:	d3 e2                	shl    %cl,%edx
  8031ef:	8b 44 24 08          	mov    0x8(%esp),%eax
  8031f3:	88 d9                	mov    %bl,%cl
  8031f5:	d3 e8                	shr    %cl,%eax
  8031f7:	09 c2                	or     %eax,%edx
  8031f9:	89 d0                	mov    %edx,%eax
  8031fb:	89 f2                	mov    %esi,%edx
  8031fd:	f7 74 24 0c          	divl   0xc(%esp)
  803201:	89 d6                	mov    %edx,%esi
  803203:	89 c3                	mov    %eax,%ebx
  803205:	f7 e5                	mul    %ebp
  803207:	39 d6                	cmp    %edx,%esi
  803209:	72 19                	jb     803224 <__udivdi3+0xfc>
  80320b:	74 0b                	je     803218 <__udivdi3+0xf0>
  80320d:	89 d8                	mov    %ebx,%eax
  80320f:	31 ff                	xor    %edi,%edi
  803211:	e9 58 ff ff ff       	jmp    80316e <__udivdi3+0x46>
  803216:	66 90                	xchg   %ax,%ax
  803218:	8b 54 24 08          	mov    0x8(%esp),%edx
  80321c:	89 f9                	mov    %edi,%ecx
  80321e:	d3 e2                	shl    %cl,%edx
  803220:	39 c2                	cmp    %eax,%edx
  803222:	73 e9                	jae    80320d <__udivdi3+0xe5>
  803224:	8d 43 ff             	lea    -0x1(%ebx),%eax
  803227:	31 ff                	xor    %edi,%edi
  803229:	e9 40 ff ff ff       	jmp    80316e <__udivdi3+0x46>
  80322e:	66 90                	xchg   %ax,%ax
  803230:	31 c0                	xor    %eax,%eax
  803232:	e9 37 ff ff ff       	jmp    80316e <__udivdi3+0x46>
  803237:	90                   	nop

00803238 <__umoddi3>:
  803238:	55                   	push   %ebp
  803239:	57                   	push   %edi
  80323a:	56                   	push   %esi
  80323b:	53                   	push   %ebx
  80323c:	83 ec 1c             	sub    $0x1c,%esp
  80323f:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  803243:	8b 74 24 34          	mov    0x34(%esp),%esi
  803247:	8b 7c 24 38          	mov    0x38(%esp),%edi
  80324b:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  80324f:	89 44 24 0c          	mov    %eax,0xc(%esp)
  803253:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  803257:	89 f3                	mov    %esi,%ebx
  803259:	89 fa                	mov    %edi,%edx
  80325b:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  80325f:	89 34 24             	mov    %esi,(%esp)
  803262:	85 c0                	test   %eax,%eax
  803264:	75 1a                	jne    803280 <__umoddi3+0x48>
  803266:	39 f7                	cmp    %esi,%edi
  803268:	0f 86 a2 00 00 00    	jbe    803310 <__umoddi3+0xd8>
  80326e:	89 c8                	mov    %ecx,%eax
  803270:	89 f2                	mov    %esi,%edx
  803272:	f7 f7                	div    %edi
  803274:	89 d0                	mov    %edx,%eax
  803276:	31 d2                	xor    %edx,%edx
  803278:	83 c4 1c             	add    $0x1c,%esp
  80327b:	5b                   	pop    %ebx
  80327c:	5e                   	pop    %esi
  80327d:	5f                   	pop    %edi
  80327e:	5d                   	pop    %ebp
  80327f:	c3                   	ret    
  803280:	39 f0                	cmp    %esi,%eax
  803282:	0f 87 ac 00 00 00    	ja     803334 <__umoddi3+0xfc>
  803288:	0f bd e8             	bsr    %eax,%ebp
  80328b:	83 f5 1f             	xor    $0x1f,%ebp
  80328e:	0f 84 ac 00 00 00    	je     803340 <__umoddi3+0x108>
  803294:	bf 20 00 00 00       	mov    $0x20,%edi
  803299:	29 ef                	sub    %ebp,%edi
  80329b:	89 fe                	mov    %edi,%esi
  80329d:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  8032a1:	89 e9                	mov    %ebp,%ecx
  8032a3:	d3 e0                	shl    %cl,%eax
  8032a5:	89 d7                	mov    %edx,%edi
  8032a7:	89 f1                	mov    %esi,%ecx
  8032a9:	d3 ef                	shr    %cl,%edi
  8032ab:	09 c7                	or     %eax,%edi
  8032ad:	89 e9                	mov    %ebp,%ecx
  8032af:	d3 e2                	shl    %cl,%edx
  8032b1:	89 14 24             	mov    %edx,(%esp)
  8032b4:	89 d8                	mov    %ebx,%eax
  8032b6:	d3 e0                	shl    %cl,%eax
  8032b8:	89 c2                	mov    %eax,%edx
  8032ba:	8b 44 24 08          	mov    0x8(%esp),%eax
  8032be:	d3 e0                	shl    %cl,%eax
  8032c0:	89 44 24 04          	mov    %eax,0x4(%esp)
  8032c4:	8b 44 24 08          	mov    0x8(%esp),%eax
  8032c8:	89 f1                	mov    %esi,%ecx
  8032ca:	d3 e8                	shr    %cl,%eax
  8032cc:	09 d0                	or     %edx,%eax
  8032ce:	d3 eb                	shr    %cl,%ebx
  8032d0:	89 da                	mov    %ebx,%edx
  8032d2:	f7 f7                	div    %edi
  8032d4:	89 d3                	mov    %edx,%ebx
  8032d6:	f7 24 24             	mull   (%esp)
  8032d9:	89 c6                	mov    %eax,%esi
  8032db:	89 d1                	mov    %edx,%ecx
  8032dd:	39 d3                	cmp    %edx,%ebx
  8032df:	0f 82 87 00 00 00    	jb     80336c <__umoddi3+0x134>
  8032e5:	0f 84 91 00 00 00    	je     80337c <__umoddi3+0x144>
  8032eb:	8b 54 24 04          	mov    0x4(%esp),%edx
  8032ef:	29 f2                	sub    %esi,%edx
  8032f1:	19 cb                	sbb    %ecx,%ebx
  8032f3:	89 d8                	mov    %ebx,%eax
  8032f5:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  8032f9:	d3 e0                	shl    %cl,%eax
  8032fb:	89 e9                	mov    %ebp,%ecx
  8032fd:	d3 ea                	shr    %cl,%edx
  8032ff:	09 d0                	or     %edx,%eax
  803301:	89 e9                	mov    %ebp,%ecx
  803303:	d3 eb                	shr    %cl,%ebx
  803305:	89 da                	mov    %ebx,%edx
  803307:	83 c4 1c             	add    $0x1c,%esp
  80330a:	5b                   	pop    %ebx
  80330b:	5e                   	pop    %esi
  80330c:	5f                   	pop    %edi
  80330d:	5d                   	pop    %ebp
  80330e:	c3                   	ret    
  80330f:	90                   	nop
  803310:	89 fd                	mov    %edi,%ebp
  803312:	85 ff                	test   %edi,%edi
  803314:	75 0b                	jne    803321 <__umoddi3+0xe9>
  803316:	b8 01 00 00 00       	mov    $0x1,%eax
  80331b:	31 d2                	xor    %edx,%edx
  80331d:	f7 f7                	div    %edi
  80331f:	89 c5                	mov    %eax,%ebp
  803321:	89 f0                	mov    %esi,%eax
  803323:	31 d2                	xor    %edx,%edx
  803325:	f7 f5                	div    %ebp
  803327:	89 c8                	mov    %ecx,%eax
  803329:	f7 f5                	div    %ebp
  80332b:	89 d0                	mov    %edx,%eax
  80332d:	e9 44 ff ff ff       	jmp    803276 <__umoddi3+0x3e>
  803332:	66 90                	xchg   %ax,%ax
  803334:	89 c8                	mov    %ecx,%eax
  803336:	89 f2                	mov    %esi,%edx
  803338:	83 c4 1c             	add    $0x1c,%esp
  80333b:	5b                   	pop    %ebx
  80333c:	5e                   	pop    %esi
  80333d:	5f                   	pop    %edi
  80333e:	5d                   	pop    %ebp
  80333f:	c3                   	ret    
  803340:	3b 04 24             	cmp    (%esp),%eax
  803343:	72 06                	jb     80334b <__umoddi3+0x113>
  803345:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  803349:	77 0f                	ja     80335a <__umoddi3+0x122>
  80334b:	89 f2                	mov    %esi,%edx
  80334d:	29 f9                	sub    %edi,%ecx
  80334f:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  803353:	89 14 24             	mov    %edx,(%esp)
  803356:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  80335a:	8b 44 24 04          	mov    0x4(%esp),%eax
  80335e:	8b 14 24             	mov    (%esp),%edx
  803361:	83 c4 1c             	add    $0x1c,%esp
  803364:	5b                   	pop    %ebx
  803365:	5e                   	pop    %esi
  803366:	5f                   	pop    %edi
  803367:	5d                   	pop    %ebp
  803368:	c3                   	ret    
  803369:	8d 76 00             	lea    0x0(%esi),%esi
  80336c:	2b 04 24             	sub    (%esp),%eax
  80336f:	19 fa                	sbb    %edi,%edx
  803371:	89 d1                	mov    %edx,%ecx
  803373:	89 c6                	mov    %eax,%esi
  803375:	e9 71 ff ff ff       	jmp    8032eb <__umoddi3+0xb3>
  80337a:	66 90                	xchg   %ax,%ax
  80337c:	39 44 24 04          	cmp    %eax,0x4(%esp)
  803380:	72 ea                	jb     80336c <__umoddi3+0x134>
  803382:	89 d9                	mov    %ebx,%ecx
  803384:	e9 62 ff ff ff       	jmp    8032eb <__umoddi3+0xb3>
