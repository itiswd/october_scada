// ======================
// MQTT Topics
// ======================
class MqttTopics {
  // ===== Station1 =====

  // Pump inputs
  static const String pump1 = 'IN_2_P1';
  static const String pump2 = 'IN_5_P2';
  static const String pump3 = 'IN_8_P3';
  static const String pump4 = 'IN_11_P4';
  static const String pump5 = 'IN_14_P5';
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

  // ===== Station3 =====

  // Power sources
  static const String supply1 = 'supply1';
  static const String supply2 = 'supply2';
  static const String generator = 'generator';

  // Pressure sensors
  static const String pressureSensor1 = 'sensor1';
  static const String pressureSensor2 = 'sensor2';

  // Pumps status
  static const String pump1IsRunning = 'pump1_is_runnung';
  static const String pump2IsRunning = 'pump2_is_runnung';
  static const String pump3IsRunning = 'pump3_is_runnung';
  static const String pump4IsRunning = 'pump4_is_runnung';
  static const String pump5IsRunning = 'pump5_is_runnung';
  static const String pump6IsRunning = 'pump6_is_runnung';

  static const String pump1IsAuto = 'pump1_is_auto';
  static const String pump2IsAuto = 'pump2_is_auto';
  static const String pump3IsAuto = 'pump3_is_auto';
  static const String pump4IsAuto = 'pump4_is_auto';
  static const String pump5IsAuto = 'pump5_is_auto';
  static const String pump6IsAuto = 'pump6_is_auto';

  static const String pump1IsRemote = 'pump1_is_remote';
  static const String pump2IsRemote = 'pump2_is_remote';
  static const String pump3IsRemote = 'pump3_is_remote';
  static const String pump4IsRemote = 'pump4_is_remote';
  static const String pump5IsRemote = 'pump5_is_remote';
  static const String pump6IsRemote = 'pump6_is_remote';

  // Pump runtime
  static const String pump1Hour = 'pump1_hour';
  static const String pump1Minute = 'pump1_minute';
  static const String pump1Second = 'pump1_second';

  static const String pump2Hour = 'pump2_hour';
  static const String pump2Minute = 'pump2_minute';
  static const String pump2Second = 'pump2_second';

  static const String pump3Hour = 'pump3_hour';
  static const String pump3Minute = 'pump3_minute';
  static const String pump3Second = 'pump3_second';

  static const String pump4Hour = 'pump4_hour';
  static const String pump4Minute = 'pump4_minute';
  static const String pump4Second = 'pump4_second';

  static const String pump5Hour = 'pump5_hour';
  static const String pump5Minute = 'pump5_minute';
  static const String pump5Second = 'pump5_second';

  static const String pump6Hour = 'pump6_hour';
  static const String pump6Minute = 'pump6_minute';
  static const String pump6Second = 'pump6_second';

  // Tank data
  static const String tank1Flow = 'tank1_flow';
  static const String tank2Flow = 'tank2_flow';
  static const String tank1Level = 'tank1_level';
  static const String tank2Level = 'tank2_level';
}
