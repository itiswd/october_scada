import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:october_scada/core/core.dart';
import 'package:october_scada/domain/domain.dart';
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
                // Connection Status
                if (!isConnected) const ConnectionStatusIndicator(),

                // Main Content
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
        // Pumps Section
        _buildPumpsGrid(service, true),
        SizedBox(height: 16.h),

        // Tanks
        _buildTank1(service, true),
        SizedBox(height: 8.h),
        _buildTank2(service, true),
        SizedBox(height: 16.h),

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
              _buildPumpsGrid(service, false),
              SizedBox(height: 16.h),
              _buildTank1(service, false),
              SizedBox(height: 8.h),
              _buildTank2(service, false),
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
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildPumpsGrid(service, bool isMobile) {
    return Wrap(
      spacing: isMobile ? 8.w : 16.w,
      runSpacing: isMobile ? 8.h : 16.h,
      children: List.generate(6, (index) {
        final pumpNum = index + 1;
        return PumpCardStation3(
          pumpNumber: pumpNum,
          isRunning: service.pumpsStatus['pump${pumpNum}_is_runnung'] ?? false,
          isAuto: service.pumpsStatus['pump${pumpNum}_is_auto'] ?? false,
          isRemote: service.pumpsStatus['pump${pumpNum}_is_remote'] ?? false,
          hours: service.pumpsTime['pump${pumpNum}_hour'] ?? 0,
          minutes: service.pumpsTime['pump${pumpNum}_minute'] ?? 0,
          seconds: service.pumpsTime['pump${pumpNum}_second'] ?? 0,
        );
      }),
    );
  }

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
