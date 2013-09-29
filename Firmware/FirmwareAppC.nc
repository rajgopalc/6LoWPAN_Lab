/**
 * Firmware for Testbed Monitor
 * (Part of master's thesis)
 * @author C.Rajgopal
 */
#include "Firmwareheader.h"
#include <Ieee154.h> 
#include "CC2420.h"
#include "AM.h"
#include<message.h>
configuration FirmwareAppC {}
implementation {
  components MainC;
  components FirmwareC as App;
  components LedsC;
  components new TimerMilliC();
  components new TimerMilliC() as SensorTimer;
  components new TimerMilliC() as BcastTimer;
  components new VoltageC() as Batt; 
  components IPDispatchC;
  components new PhotoSenseC();
  components new TempSenseC();
  App.RadioControl -> IPDispatchC;
	
  components CC2420ActiveMessageC;
  App.CC2420Packet->CC2420ActiveMessageC.CC2420Packet;
  components CC2420Ieee154MessageC as Radio; 
  
  components UdpC;
  components ReadLqiC;
  components UDPShellC;  

  App.Receive->Radio.Ieee154Receive;
  components new UdpSocketC() as ReportService;
  //components new UdpSocketC() as PollingService;
  App.ReportService -> ReportService;
  //App.PollingService -> PollingService;
  
  
  App.RadioSend -> Radio.Ieee154Send;
  App.RadioPacket -> Radio.Packet;
  //App.RadioIeeePacket -> Radio;

  App.Boot -> MainC.Boot;
  App.Read -> Batt;
  App.Leds -> LedsC;
  App.MilliTimer -> TimerMilliC;
  App.SensorTimer->SensorTimer;
  App.BcastTimer->BcastTimer;
  App.ReadPhoto -> PhotoSenseC;
  App.ReadTemp -> TempSenseC;
  App.ReadLqi->ReadLqiC;
}
