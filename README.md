Developement of WSN Testbed 
============================

The following paper came out of this work : http://dl.acm.org/citation.cfm?id=2185231

Requirements : Should first install TinyOS 2.1.1 with Blip support.

Tested On : MicaZ Motes with mda100 sensor boards.

Firmware folder  
----------------
Contains the core firmware for this project

   		   To-do's 
    			To be placed in /opt/tinyos-2.1.1/apps/
    
			Command to install: 

 	                SENSORBOARD=mda100 make micaz blip install.<nodeid> mib520,/dev/   
    	   		ttyUSB<portno.>

PhotoSenseC.nc / TempSenseC.nc 
-------------------------------
Files used to access the LDR and Temperature sensor of the mda100 board.
To be placed in /opt/tinyos-2.1.1/tos/sensorboards/mda100/

tools folder
-------------
	This folder is part of the TinyOS installation and as such all copyrights 
	of TinyOS operting system applies to this folder. 
	
	This is seperately added to project because the folder contains tos-nwprog which is
	used for network reprogramming by WSN-backedn. 
	
	In case tos-nwprog is not found in your TinyOS version, you can the one present 
	in this folder instead. Apart from that, there is no need to change anything in this folder.

WSNBackend:
-----------
	This contains a python program which acts as a backend processing unit
	and message transaction bridge between the motes working on IPv6 and 
	web frontend working over IPv4.
 	
	To-Do's:
    	 1.  Place in HOME directory
     	 2.  Edit the function "Nprog_reboot" by setting the proper path to
            "filename.in"
     	 3.  Build images for Blink app in /opt/tinyos-2.1.1/apps/Blink and 
             UDPEcho app in /opt/tinyos-2.1.1./apps/UDPEcho for the micaz
             platform before performing network reprogramming

Filename.in
------------

      Gives command input to netcat shell for network reprogramming.
      Place it in a convenient location and edit the Nprog_Reboot function
      of the backend to indicate the proper path of filename.in.

      The command in this file is 'nwprog boot 0'. Change it to access other
      functionalities offered by netcat prompt (Although it hasn't been    
      tested).

cc2420_rxtest.py, cc2420_rxtest_web.py,tos_blinktoradio.py 
-----------------------------------------------------------

        All these files are related to bridging SDR with MicaZ and requires
        the installation of GNU Radio version 3.2 and UCLA IEEE 802.15.4 
        PHY layer modules for GNU Radio available at CGRAN
        
        Please place all these files in the src/examples/ folder of the 
        ucla_zigbee_phy folder.
    
       cc2420_rxtest.py : Receiving packet at SDR from MicaZ mote
       cc2420_rxtest_web.py : Same as above but can host a web interface (SDRMonitor.html)
       tos_blinktoradio.py : Transmit test, sending counter values (SDR acts as mote with id 1)

Testbed monitor folder
----------------------
        Contains all frontend files. Place in HOME folder. Initiate a python 
        server ( python -m SimpleHTTPServer) after navigating into this 
        folder. Within bin-debug folder "Testbed_monitor.html" provides the
        application framework. WSNBackend has to be initated before this.
        "SDRMonitor.html" gives the web interface for SDR. Have to initiate 
        cc2420_rxtest_web.py before using "SDRmonitor.html".


