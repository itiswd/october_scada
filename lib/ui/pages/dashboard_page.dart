import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:october_scada/ui/widgets/station_tank_card.dart';
import 'package:october_scada/ui/widgets/wave_tank.dart';
import 'package:october_scada/ui/widgets/weather.dart';
import 'package:shimmer/shimmer.dart';

import '../../state/mqtt_controller.dart';

class DashboardPage extends ConsumerWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final service = ref.watch(mqttProvider);

    return Scaffold(
      backgroundColor: Color.fromARGB(255, 251, 250, 251),

      body: service.connected
          ? SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    //Waved tank
                    WaveTank(height: 48, waveAmplitude: 6.0, waveSpeed: 1.0),
                    //Valves and Pumps
                    Row(
                      children: [
                        Spacer(flex: 1),
                        SizedBox(
                          // color: Colors.white,
                          width: 950,
                          child: Column(
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  //Stage 1
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
                                  //Stage 2
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
                                  ), //Stage 3
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
                                  //Stage 4
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
                                  ), //Stage 5
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
                                  ), //Stage 6
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
                              StationTankCard(
                                title: "Station 1 Tank",
                                flow:
                                    service
                                        .holdingRegisters['ANLOG_IN6_FLOW'] ??
                                    0,
                                capacity: 7.8,
                                levels: [
                                  service.holdingRegisters['ANLOG_IN1_LVL1'] ??
                                      0,
                                  service.holdingRegisters['ANLOG_IN2_LVL2_WITH_LVL4'] ??
                                      0,
                                  service.holdingRegisters['ANLOG_IN3_LVL3'] ??
                                      0,
                                  service.holdingRegisters['ANLOG_IN2_LVL2_WITH_LVL4'] ??
                                      0,
                                ],
                              ),
                            ],
                          ),
                        ),
                        Spacer(flex: 3),
                        Column(
                          children: [
                            //Generators and Transformers
                            Container(
                              height: 200,
                              decoration: BoxDecoration(
                                color: const Color.fromARGB(255, 25, 25, 25),
                                borderRadius: BorderRadius.circular(16),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(32),
                                child: Center(
                                  child: Row(
                                    spacing: 32,
                                    children: [
                                      TransWidget(
                                        title: 'Generator',
                                        value: service.inputs['IN_7_GEN1_W2'],
                                        imageOn:
                                            'assets/images/generator_off.png',

                                        imageOff:
                                            'assets/images/generator_off.png',
                                        imageNull:
                                            'assets/images/generator_null.png',
                                      ),
                                      TransWidget(
                                        title: 'Transformer 1',
                                        value: service.inputs['IN_1_TR1_W2'],
                                        imageOn:
                                            'assets/images/transformer_on.png',
                                        imageOff:
                                            'assets/images/transformer_off.png',
                                        imageNull:
                                            'assets/images/transformer_null.png',
                                      ),
                                      TransWidget(
                                        title: 'Transformer 2',
                                        value: service.inputs['IN_4_TR2_W2'],

                                        imageOn:
                                            'assets/images/transformer_off.png',
                                        imageOff:
                                            'assets/images/transformer_on.png',
                                        imageNull:
                                            'assets/images/transformer_null.png',
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
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
                        Spacer(flex: 4),
                      ],
                    ),
                  ],
                ),
              ),
            )
          : _buildShimmerLoader(),
    );
  }

  Widget _buildShimmerLoader() {
    return Shimmer.fromColors(
      baseColor: Colors.grey.shade900,
      highlightColor: Colors.grey.shade700,
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            Container(
              width: double.infinity,
              height: 30,
              color: Colors.grey.shade800,
            ),
            const SizedBox(height: 20),
            Container(
              width: double.infinity,
              height: 200,
              color: Colors.grey.shade800,
            ),
          ],
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
          width: 80,
        ),
        Padding(
          padding: const EdgeInsets.only(left: 16),
          child: Image.asset(pump ? pumpOn : pumpOff, width: 120),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 52),
          child: Image.asset(
            endOn
                ? valveOn
                : endOff
                ? valveOff
                : valveNull,
            width: 80,
          ),
        ),
      ],
    );
  }
}

class TransWidget extends StatelessWidget {
  final bool? value; // ✅ خليها nullable
  final String imageOn;
  final String imageOff;
  final String imageNull;
  final String title;

  const TransWidget({
    super.key,
    required this.value,
    required this.imageOn,
    required this.title,
    required this.imageOff,
    required this.imageNull,
  });

  @override
  Widget build(BuildContext context) {
    // ✅ نحدد الصورة حسب الحالة
    String image;
    String statusText;
    Color statusColor;

    if (value == true) {
      image = imageOff;
      statusText = "OFF";
      statusColor = Colors.red;
    } else if (value == false) {
      image = imageOn;
      statusText = "ON";
      statusColor = Colors.green;
    } else {
      image = imageNull;
      statusText = "N/A";
      statusColor = Colors.grey;
    }

    return SizedBox(
      width: 120,
      height: 140,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(image, width: 80),
            Text(
              "$title\n$statusText",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
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
