#ifndef FIRMWAREHEADER_H
#define FIRMWAREHEADER_H

typedef nx_struct udp_radio_count_msg_t {
  nx_uint16_t batt_val;
  nx_uint8_t  rssi;
  nx_uint16_t  id;
  nx_uint16_t  photosense;
  nx_uint16_t  tempsense;
  nx_uint16_t datalqi;
} udp_radio_count_msg_t;

typedef nx_struct rssi_echo_msg_t {
 nx_uint16_t nodeid;
} rssi_echo_msg_t;

typedef nx_struct polling_msg_t {
  nx_uint16_t  data;
} polling_msg_t;

#endif
