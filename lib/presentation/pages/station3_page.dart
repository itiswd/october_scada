import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:october_scada/core/core.dart';
import 'package:october_scada/domain/domain.dart';
import 'package:october_scada/presentation/widgets/widgets.dart';
import 'package:october_scada/presentation/widgets/station3/pumps_section_station3.dart';
import 'package:october_scada/presentation/widgets/station3/pump_group_station3.dart';
import 'package:october_scada/presentation/widgets/station3/pumps_status_table_station3.dart';

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

                // Wave Tank header like Station 1
                Center(
                  child: WaveTank(
                    height: isMobile ? 40.h : 56.h,
                    waveAmplitude: isMobile ? 4.0 : 6.0,
                    waveSpeed: 1.0,
                  ),
                ),

                if (isMobile) ...[
                  _buildMobileLayout(service),
                ] else ...[
                  _buildDesktopLayout(service),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildMobileLayout(service) {
    return Column(
      children: [
        // Pumps grouped 3 per tank
        PumpGroupWithTankStation3(
          service: service,
          pumpNumbers: const [1, 2, 3],
          tankNumber: 1,
        ),
        SizedBox(height: 12.h),
        PumpGroupWithTankStation3(
          service: service,
          pumpNumbers: const [4, 5, 6],
          tankNumber: 2,
        ),
        SizedBox(height: 12.h),

        // Power Sources
        PowerSourcesStation3(
          supply1: service.powerSources[MqttTopics.supply1] ?? false,
          supply2: service.powerSources[MqttTopics.supply2] ?? false,
          generator: service.powerSources[MqttTopics.generator] ?? false,
        ),
        SizedBox(height: 8.h),

        // Pressure Sensors
        PressureSensorsWidget(
          sensor1: service.pressureSensors[MqttTopics.pressureSensor1] ?? 0,
          sensor2: service.pressureSensors[MqttTopics.pressureSensor2] ?? 0,
        ),
        SizedBox(height: 12.h),
        // Pumps detailed table
        PumpsStatusTableStation3(service: service),
      ],
    );
  }

  Widget _buildDesktopLayout(service) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Left Column - Pumps + Tanks
        Expanded(
          flex: 5,
          child: Column(
            children: [
              PumpGroupWithTankStation3(
                service: service,
                pumpNumbers: const [1, 2, 3],
                tankNumber: 1,
              ),
              SizedBox(height: 16.h),
              PumpGroupWithTankStation3(
                service: service,
                pumpNumbers: const [4, 5, 6],
                tankNumber: 2,
              ),
            ],
          ),
        ),

        SizedBox(width: 24.w),

        // Right Column - Power + Pressure
        Expanded(
          flex: 2,
          child: Column(
            children: [
              PowerSourcesStation3(
                supply1: service.powerSources[MqttTopics.supply1] ?? false,
                supply2: service.powerSources[MqttTopics.supply2] ?? false,
                generator: service.powerSources[MqttTopics.generator] ?? false,
              ),
              SizedBox(height: 16.h),
              PressureSensorsWidget(
                sensor1:
                    service.pressureSensors[MqttTopics.pressureSensor1] ?? 0,
                sensor2:
                    service.pressureSensors[MqttTopics.pressureSensor2] ?? 0,
              ),
              SizedBox(height: 16.h),
              PumpsStatusTableStation3(service: service),
            ],
          ),
        ),
      ],
    );
  }

  // Replaced with PumpsSectionStation3

  Widget _buildTank1(service, bool isMobile) {
    final level = service.tankData[MqttTopics.tank1Level] ?? 0.0;
    return StationTankCard3(
      title: "Tank 1",
      flow: service.tankData[MqttTopics.tank1Flow] ?? 0.0,
      capacity: AppConstants.tankCapacity,
      levels: [level],
    );
  }

  Widget _buildTank2(service, bool isMobile) {
    final level = service.tankData[MqttTopics.tank2Level] ?? 0.0;
    return StationTankCard3(
      title: "Tank 2",
      flow: service.tankData[MqttTopics.tank2Flow] ?? 0.0,
      capacity: AppConstants.tankCapacity,
      levels: [level],
    );
  }
}
