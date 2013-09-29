/**
 * Temperature sense abstraction for Testbed Monitor
 * (Part of master's thesis)
 * @author C.Rajgopal
 */

generic configuration TempSenseC() {
  provides interface Read<uint16_t> ;
}
implementation {
  components new TempC() as Sensor;

  Read = Sensor;
}
