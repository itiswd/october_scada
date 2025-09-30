import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:october_scada/core/core.dart';
import 'package:october_scada/domain/domain.dart';
import 'package:october_scada/presentation/widgets/station3/pump_group_station3.dart';
import 'package:october_scada/presentation/widgets/station3/pumps_status_table_station3.dart';
import 'package:october_scada/presentation/widgets/widgets.dart';

class Station3Page extends ConsumerWidget {
  const Station3Page({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final service = ref.watch(mqttProvider);
    final isConnected = service.connected;
    final isMobile = ResponsiveHelper.isMobile(context);

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(
              ResponsiveHelper.getHorizontalPadding(context),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (!isConnected) const ConnectionStatusIndicator(),

                if (isMobile) ...[
                  _buildMobileLayout(service, isMobile),
                ] else ...[
                  _buildDesktopLayout(service, isMobile),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildMobileLayout(dynamic service, bool isMobile) {
    return Column(
      children: [
        // Wave Tank header like Station 1
        Center(
          child: WaveTank(
            height: isMobile ? 40.h : 56.h,
            waveAmplitude: isMobile ? 4.0 : 6.0,
            waveSpeed: 1.0,
          ),
        ),
        // Pumps grouped 3 per tank
        PumpGroupWithTankStation3(
          service: service,
          pumpNumbers: const [1, 2, 3],
          tankNumber: 1,
        ),
        SizedBox(height: 8.h),
        // Pressure and Flow Sensors
        GaugesSection(
          title: 'Tank 1',
          bar: service.pressureSensors[MqttTopics.pressureSensor1] ?? 0,
          ls: service.tankData[MqttTopics.tank1Flow] ?? 0,
        ),
        SizedBox(height: 8.h),
        // Wave Tank header like Station 1
        Center(
          child: WaveTank(
            height: isMobile ? 40.h : 56.h,
            waveAmplitude: isMobile ? 4.0 : 6.0,
            waveSpeed: 1.0,
          ),
        ),
        // Pumps grouped 3 per tank
        PumpGroupWithTankStation3(
          service: service,
          pumpNumbers: const [4, 5, 6],
          tankNumber: 2,
        ),
        SizedBox(height: 8.h),
        // Pressure and Flow Sensors
        GaugesSection(
          title: 'Tank 2',
          bar: service.pressureSensors[MqttTopics.pressureSensor2] ?? 0,
          ls: service.tankData[MqttTopics.tank2Flow] ?? 0,
        ),
        SizedBox(height: 8.h),
        // Power Sources
        PowerSourcesStation3(
          supply1: service.powerSources[MqttTopics.supply1] ?? false,
          supply2: service.powerSources[MqttTopics.supply2] ?? false,
          generator: service.powerSources[MqttTopics.generator] ?? false,
        ),
        SizedBox(height: 8.h),
        //Weather Data
        WeatherWidget(),
        SizedBox(height: 8.h),
        // Pumps detailed table
        PumpsStatusTableStation3(service: service),
      ],
    );
  }

  Widget _buildDesktopLayout(dynamic service, bool isMobile) {
    return Column(
      children: [
        // Wave Tank header like Station 1
        Center(
          child: WaveTank(
            height: isMobile ? 40.h : 56.h,
            waveAmplitude: isMobile ? 4.0 : 6.0,
            waveSpeed: 1.0,
          ),
        ),
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              flex: 3,
              child: Column(
                children: [
                  //Tank 1
                  PumpGroupWithTankStation3(
                    service: service,
                    pumpNumbers: const [1, 2, 3],
                    tankNumber: 1,
                  ),
                  SizedBox(height: 8.h),
                  GaugesSection(
                    title: 'Tank 1',
                    bar:
                        service.pressureSensors[MqttTopics.pressureSensor1] ??
                        0,
                    ls: service.tankData[MqttTopics.tank1Flow] ?? 0,
                  ),
                ],
              ),
            ),

            SizedBox(width: 8.w),

            // Power + Weather + Pumps Data and Status
            Expanded(
              flex: 2,
              child: Column(
                children: [
                  PowerSourcesStation3(
                    supply1: service.powerSources[MqttTopics.supply1] ?? false,
                    supply2: service.powerSources[MqttTopics.supply2] ?? false,
                    generator:
                        service.powerSources[MqttTopics.generator] ?? false,
                  ),
                  SizedBox(height: 8.h),
                  //Weather Data
                  WeatherWidget(),
                  SizedBox(height: 8.h),
                  PumpsStatusTableStation3(service: service),
                ],
              ),
            ),
            SizedBox(width: 8.w),
            Expanded(
              flex: 3,
              child: Column(
                children: [
                  //Tank 2
                  PumpGroupWithTankStation3(
                    service: service,
                    pumpNumbers: const [1, 2, 3],
                    tankNumber: 1,
                  ),
                  SizedBox(height: 8.h),
                  GaugesSection(
                    title: 'Tank 2',
                    bar:
                        service.pressureSensors[MqttTopics.pressureSensor2] ??
                        0,
                    ls: service.tankData[MqttTopics.tank2Flow] ?? 0,
                  ),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }
}
