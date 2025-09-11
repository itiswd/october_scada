import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:october_scada/services/mqtt_service.dart';
import 'package:october_scada/ui/widgets/station_tank_card.dart';
import 'package:october_scada/ui/widgets/wave_tank.dart';
import 'package:october_scada/ui/widgets/weather.dart';

import '../../state/mqtt_controller.dart';

class DashboardPage extends ConsumerWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final service = ref.watch(mqttProvider);
    final bool isConnected = service.connected;
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 251, 250, 251),
      body: LayoutBuilder(
        builder: (context, constraints) {
          // breakpoints
          bool isMobile = constraints.maxWidth < 600.w;
          bool isDesktop = constraints.maxWidth >= 1100.w;
          return SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.all(12.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  /// Connection Status
                  if (!isConnected) const ConnectionStatusIndicator(),

                  /// Wave Tank
                  Center(
                    child: WaveTank(
                      height: isMobile ? 32.h : 56.h,
                      waveAmplitude: 6.0,
                      waveSpeed: 1.0,
                    ),
                  ),

                  /// Main content
                  Flex(
                    direction: isMobile ? Axis.vertical : Axis.horizontal,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      /// Pumps + Tank
                      Expanded(
                        flex: isDesktop ? 5 : 1,
                        child: Column(
                          children: [
                            /// Pumps Row
                            SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: Row(
                                children: [
                                  PumpColumn(
                                    startOn:
                                        service.inputs['IN_20_V1_O'] ?? false,
                                    startOff:
                                        service.inputs['IN_21_V1_C'] ?? false,
                                    pump: service.inputs['IN_2_P1'] ?? false,
                                    endOn:
                                        service.inputs['IN_24_V2_O'] ?? false,
                                    endOff:
                                        service.inputs['IN_25_V2_C'] ?? false,
                                    valveOn: 'assets/images/valve_on.png',
                                    valveOff: 'assets/images/valve_off.png',
                                    valveNull: 'assets/images/valve_null.png',
                                    pumpOn: 'assets/images/pump_on.gif',
                                    pumpOff: 'assets/images/pump_off.png',
                                  ),
                                  SizedBox(width: 12.w),
                                  PumpColumn(
                                    startOn:
                                        service.inputs['IN_28_V3_O'] ?? false,
                                    startOff:
                                        service.inputs['IN_29_V3_C'] ?? false,
                                    pump: service.inputs['IN_5_P2'] ?? false,
                                    endOn:
                                        service.inputs['IN_32_V4_O'] ?? false,
                                    endOff:
                                        service.inputs['IN_33_V4_C'] ?? false,
                                    valveOn: 'assets/images/valve_on.png',
                                    valveOff: 'assets/images/valve_off.png',
                                    valveNull: 'assets/images/valve_null.png',
                                    pumpOn: 'assets/images/pump_on.gif',
                                    pumpOff: 'assets/images/pump_off.png',
                                  ),
                                  SizedBox(width: 12.w),
                                  PumpColumn(
                                    startOn:
                                        service.inputs['IN_36_V5_O'] ?? false,
                                    startOff:
                                        service.inputs['IN_37_V5_C'] ?? false,
                                    pump: service.inputs['IN_8_P3'] ?? false,
                                    endOn:
                                        service.inputs['IN_40_V6_O'] ?? false,
                                    endOff:
                                        service.inputs['IN_41_V6_C'] ?? false,
                                    valveOn: 'assets/images/valve_on.png',
                                    valveOff: 'assets/images/valve_off.png',
                                    valveNull: 'assets/images/valve_null.png',
                                    pumpOn: 'assets/images/pump_on.gif',
                                    pumpOff: 'assets/images/pump_off.png',
                                  ),
                                  SizedBox(width: 12.w),
                                  PumpColumn(
                                    startOn:
                                        service.inputs['IN_44_V7_O'] ?? false,
                                    startOff:
                                        service.inputs['IN_45_V7_C'] ?? false,
                                    pump: service.inputs['IN_11_P4'] ?? false,
                                    endOn: service.inputs[''] ?? false,
                                    endOff: service.inputs[''] ?? false,
                                    valveOn: 'assets/images/valve_on.png',
                                    valveOff: 'assets/images/valve_off.png',
                                    valveNull: 'assets/images/valve_null.png',
                                    pumpOn: 'assets/images/pump_on.gif',
                                    pumpOff: 'assets/images/pump_off.png',
                                  ),
                                  SizedBox(width: 12.w),
                                  PumpColumn(
                                    startOn: service.inputs[''] ?? false,
                                    startOff: service.inputs[''] ?? false,
                                    pump: service.inputs['IN_2_P1'] ?? false,
                                    endOn: service.inputs[''] ?? false,
                                    endOff: service.inputs[''] ?? false,
                                    valveOn: 'assets/images/valve_on.png',
                                    valveOff: 'assets/images/valve_off.png',
                                    valveNull: 'assets/images/valve_null.png',
                                    pumpOn: 'assets/images/pump_on.gif',
                                    pumpOff: 'assets/images/pump_off.png',
                                  ),
                                  SizedBox(width: 12.w),
                                  PumpColumn(
                                    startOn:
                                        service.inputs['IN_60_V11_O'] ?? false,
                                    startOff: service.inputs[''] ?? false,
                                    pump: service.inputs['IN_17_P6'] ?? false,
                                    endOn: service.inputs[''] ?? false,
                                    endOff: service.inputs[''] ?? false,
                                    valveOn: 'assets/images/valve_on.png',
                                    valveOff: 'assets/images/valve_off.png',
                                    valveNull: 'assets/images/valve_null.png',
                                    pumpOn: 'assets/images/pump_on.gif',
                                    pumpOff: 'assets/images/pump_off.png',
                                  ),
                                ],
                              ),
                            ),

                            /// Station Tank
                            StationTankCard(
                              title: "Station 1 Tank",
                              flow:
                                  service.holdingRegisters['ANLOG_IN6_FLOW'] ??
                                  0,
                              capacity: 7.8,
                              levels: [
                                service.holdingRegisters['ANLOG_IN1_LVL1'] ?? 0,
                                service.holdingRegisters['ANLOG_IN2_LVL2_WITH_LVL4'] ??
                                    0,
                                service.holdingRegisters['ANLOG_IN3_LVL3'] ?? 0,
                                service.holdingRegisters['ANLOG_IN2_LVL2_WITH_LVL4'] ??
                                    0,
                              ],
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        width: isMobile ? 0 : 24.w,
                        height: isMobile ? 24.h : 0,
                      ),

                      /// Generators + Weather
                      Expanded(
                        flex: isDesktop ? 2 : 1,
                        child: Column(
                          children: [
                            SizedBox(height: isDesktop ? 12.h : 0),

                            /// Transformers and Generators
                            Transformers(isMobile: isMobile, service: service),
                            SizedBox(height: 1.h),

                            /// Weather and Gauges
                            WeatherAndGaugesWidget(
                              ls:
                                  service.holdingRegisters['ANLOG_IN6_FLOW'] ??
                                  0,
                              bar:
                                  service
                                      .holdingRegisters['ANLOG_IN5_PRESURE'] ??
                                  0,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

class Transformers extends StatelessWidget {
  const Transformers({
    super.key,
    required this.isMobile,
    required this.service,
  });

  final bool isMobile;
  final MqttService service;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: isMobile ? 160.h : 300.h,
      decoration: BoxDecoration(
        color: const Color.fromARGB(255, 25, 25, 25),
        borderRadius: BorderRadius.vertical(top: Radius.circular(40.r)),
      ),
      child: Padding(
        padding: EdgeInsets.all(20.w),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            TransWidget(
              title: 'Generator',
              value: service.inputs['IN_7_GEN1_W2'],
              imageOn: 'assets/images/generator_on.png',
              imageOff: 'assets/images/generator_off.png',
              converted: true,
            ),
            TransWidget(
              title: 'Transformer 1',
              value: service.inputs['IN_1_TR1_W2'],
              imageOn: 'assets/images/transformer_on.png',
              imageOff: 'assets/images/transformer_off.png',
              converted: true,
            ),
            TransWidget(
              title: 'Transformer 2',
              value: service.inputs['IN_4_TR2_W2'],
              imageOn: 'assets/images/transformer_on.png',
              imageOff: 'assets/images/transformer_off.png',
              converted: false,
            ),
          ],
        ),
      ),
    );
  }
}

class ConnectionStatusIndicator extends StatelessWidget {
  const ConnectionStatusIndicator({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: 12.h),
      child: Container(
        color: Colors.red.withAlpha(60),
        child: Padding(
          padding: EdgeInsets.all(4.0.r),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                'assets/images/server-down.png',
                width: 40.w,
                height: 40.w,
              ),
              SizedBox(width: 12.w),
              Text(
                "Offline",
                style: TextStyle(
                  color: Colors.red,
                  fontSize: 28.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class PumpColumn extends StatelessWidget {
  final bool startOn;
  final bool startOff;
  final bool endOn;
  final bool endOff;
  final String valveOn;
  final String valveOff;
  final String valveNull;
  final bool pump;
  final String pumpOn;
  final String pumpOff;

  const PumpColumn({
    super.key,
    required this.startOn,
    required this.startOff,
    required this.pump,
    required this.endOn,
    required this.endOff,
    required this.valveOn,
    required this.valveOff,
    required this.valveNull,
    required this.pumpOn,
    required this.pumpOff,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Image.asset(
          startOn
              ? valveOn
              : startOff
              ? valveOff
              : valveNull,
          width: 96.w,
        ),
        Padding(
          padding: EdgeInsets.only(left: 10.w),
          child: Image.asset(pump ? pumpOn : pumpOff, width: 120.w),
        ),
        Padding(
          padding: EdgeInsets.only(left: 51.w),
          child: Image.asset(
            endOn
                ? valveOn
                : endOff
                ? valveOff
                : valveNull,
            width: 96.w,
          ),
        ),
      ],
    );
  }
}

class TransWidget extends StatelessWidget {
  final bool? value;
  final String imageOn;
  final String imageOff;
  final String title;
  final bool converted;

  const TransWidget({
    super.key,
    required this.value,
    required this.imageOn,
    required this.title,
    required this.imageOff,
    required this.converted,
  });

  @override
  Widget build(BuildContext context) {
    String image;
    String statusText;
    Color statusColor;

    if (value == true) {
      image = converted ? imageOff : imageOn;
      statusText = converted ? "OFF" : "ON";
      statusColor = converted ? Colors.red : Colors.green;
    } else {
      image = converted ? imageOn : imageOff;
      statusText = converted ? "ON" : "OFF";
      statusColor = converted ? Colors.green : Colors.red;
    }

    return SizedBox(
      height: 180.h,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(image, width: 96.w),
            Text(
              "$title\n$statusText",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 20.sp,
                fontWeight: FontWeight.w700,
                color: statusColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
