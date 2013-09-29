/**
 * Firmware for Testbed Monitor
 * (Part of master's thesis)
 * @author C.Rajgopal
 */
#include "Firmwareheader.h"
#include <IPDispatch.h>                        
#include <lib6lowpan.h>
#include <ip.h>
#include <Ieee154.h> 
#include<message.h>
#include "CC2420.h"
#include "AM.h"
module FirmwareC {
  uses {
    interface Leds;
    interface Boot;
    interface Timer<TMilli> as MilliTimer;
    interface Timer<TMilli> as SensorTimer;
    interface Timer<TMilli> as BcastTimer;
    interface SplitControl as RadioControl;
    interface UDP as ReportService;
    interface Read<uint16_t>;
    interface Read<uint16_t> as ReadPhoto;
    interface Read<uint16_t> as ReadTemp;
    interface Packet as RadioPacket;
    interface Ieee154Send as RadioSend;
    //interface RadioIeeePacket;
    interface CC2420Packet;
    interface Receive;
    interface ReadLqi;
  }
}
implementation {
  bool radio_flag = FALSE;
  bool poll_flag = FALSE;
  message_t pkt;
  nx_struct udp_radio_count_msg_t payload;
  uint8_t leds;
  uint16_t batt_val;
  uint16_t temp_val;
  uint16_t photo_val;
  uint16_t who;
  uint16_t datalqi;
  bool locked;
  struct sockaddr_in6 dest;
  uint8_t rssi;
  
  event void Boot.booted() {
       call RadioControl.start();
  }
 
  event void RadioControl.startDone(error_t e) {
        call SensorTimer.startPeriodic(1000);
	call MilliTimer.startPeriodic(5000);
	call ReportService.bind(1234);
  }
 
  event void RadioControl.stopDone(error_t e) { } //nothing to do
  
  event message_t* Receive.receive(message_t* msg, void* payload_1, uint8_t len) {
  	if (len == sizeof(rssi_echo_msg_t)) {
		rssi_echo_msg_t* btrpkt = (rssi_echo_msg_t*)payload_1;
		who = btrpkt->nodeid;
		if(who==TOS_NODE_ID){
		}
		else{
			rssi = (int8_t)call CC2420Packet.getRssi(msg);
			datalqi=call ReadLqi.read(msg);
   		}
  	}
  return msg;
  }
  

 
  event void ReportService.recvfrom(struct sockaddr_in6 *from, void *data, 
                           uint16_t len, struct ip_metadata *meta) {
	char* msg=data;
	if(msg[0]=='A' && msg[1]=='B'){
		call BcastTimer.startPeriodic(200);
	}
	if(msg[0]=='S' && msg[1]=='B'){
		call BcastTimer.stop();
	}
		
  }
  
  event void BcastTimer.fired(){
	call Leds.led0Toggle();
	if(!radio_flag){
		rssi_echo_msg_t* rem= (rssi_echo_msg_t*)call RadioPacket.getPayload(&pkt,sizeof(rssi_echo_msg_t));
		rem->nodeid=TOS_NODE_ID;
		if (call RadioSend.send(AM_BROADCAST_ADDR, &pkt, sizeof(rssi_echo_msg_t)) == SUCCESS) {
			call Leds.led1Toggle();
		}
	}
 }
  
 event void RadioSend.sendDone(message_t* msg, error_t error){
	call Leds.led2Toggle();
	//radio_flag=TRUE;
 }
 
 event void SensorTimer.fired(){
	call ReadPhoto.read();
	call ReadTemp.read();
  }
 
  event void MilliTimer.fired(){
	call Read.read();
  }
  
  event void Read.readDone(error_t err,uint16_t data) {
	if (err==SUCCESS) {
		batt_val=data;
		payload.batt_val=data;
		//payload.rssi=rssi;
		//payload.id=who;
		//inet_pton6("fec0::64", &dest.sin6_addr);
		//dest.sin6_port = hton16(1234);
		//if(call ReportService.sendto(&dest,&payload,sizeof(udp_radio_count_msg_t))==SUCCESS) {
		//	radio_flag=TRUE;
		}
  }
  event void ReadPhoto.readDone(error_t err,uint16_t data) {
	if (err==SUCCESS) {
		photo_val=data;
		payload.photosense=data;
		payload.rssi=rssi;
		payload.id=who;
		payload.datalqi=datalqi;
		inet_pton6("fec0::64", &dest.sin6_addr);
		dest.sin6_port = hton16(1234);
		if(call ReportService.sendto(&dest,&payload,sizeof(udp_radio_count_msg_t))==SUCCESS) {
			rssi=0;
			datalqi=0;
		}
          }
    }
  event void ReadTemp.readDone(error_t err,uint16_t data) {
	if (err==SUCCESS) {
		temp_val=data;
		payload.tempsense=data;
		}
  }
}
