/**
 * Temperature sense abstraction for Testbed Monitor
 * (Part of master's thesis)
 * @author C.Rajgopal
 */

generic configuration PhotoSenseC() {
  provides interface Read<uint16_t> ;
}
implementation {
  components new PhotoC() as Sensor;

  Read = Sensor;
}
