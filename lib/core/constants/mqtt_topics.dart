class MqttTopics {
  // Pump inputs
  static const String pump1 = 'IN_2_P1';
  static const String pump2 = 'IN_5_P2';
  static const String pump3 = 'IN_8_P3';
  static const String pump4 = 'IN_11_P4';
  static const String pump6 = 'IN_17_P6';

  // Valve inputs
  static const String valve1Open = 'IN_20_V1_O';
  static const String valve1Close = 'IN_21_V1_C';
  static const String valve2Open = 'IN_24_V2_O';
  static const String valve2Close = 'IN_25_V2_C';
  static const String valve3Open = 'IN_28_V3_O';
  static const String valve3Close = 'IN_29_V3_C';
  static const String valve4Open = 'IN_32_V4_O';
  static const String valve4Close = 'IN_33_V4_C';
  static const String valve5Open = 'IN_36_V5_O';
  static const String valve5Close = 'IN_37_V5_C';
  static const String valve6Open = 'IN_40_V6_O';
  static const String valve6Close = 'IN_41_V6_C';
  static const String valve7Open = 'IN_44_V7_O';
  static const String valve7Close = 'IN_45_V7_C';

  // Transformer and Generator inputs
  static const String transformer1 = 'IN_1_TR1_W2';
  static const String transformer2 = 'IN_4_TR2_W2';
  static const String generator1 = 'IN_7_GEN1_W2';

  // Analog inputs
  static const String level1 = 'ANLOG_IN1_LVL1';
  static const String level2WithLevel4 = 'ANLOG_IN2_LVL2_WITH_LVL4';
  static const String level3 = 'ANLOG_IN3_LVL3';
  static const String pressure = 'ANLOG_IN5_PRESURE';
  static const String flow = 'ANLOG_IN6_FLOW';
}
