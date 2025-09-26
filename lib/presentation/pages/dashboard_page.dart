import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:october_scada/presentation/widgets/dashboard/weather_gauges_section.dart';
import 'package:october_scada/presentation/widgets/tank/station_tank_card.dart';
import 'package:october_scada/presentation/widgets/weather/wave_tank.dart';

import '../../core/constants/app_constants.dart';
import '../../core/constants/mqtt_topics.dart';
import '../../core/utils/responsive_helper.dart';
import '../../domain/providers/mqtt_provider.dart';
import '../widgets/common/connection_status_indicator.dart';
import '../widgets/dashboard/pumps_section.dart';
import '../widgets/dashboard/transformers_section.dart';

class DashboardPage extends ConsumerWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final service = ref.watch(mqttProvider);
    final isConnected = service.connected;
    final isMobile = ResponsiveHelper.isMobile(context);
    final isDesktop = ResponsiveHelper.isDesktop(context);

    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(
            ResponsiveHelper.getHorizontalPadding(context),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (isMobile) SafeArea(child: SizedBox(height: 16.h)),
              // Connection Status
              if (!isConnected) const ConnectionStatusIndicator(),

              // Wave Tank - أصغر في الموبايل
              Center(
                child: WaveTank(
                  height: isMobile ? 40.h : 56.h,
                  waveAmplitude: isMobile ? 4.0 : 6.0,
                  waveSpeed: 1.0,
                ),
              ),

              // Main Content
              if (isMobile) ...[
                _buildMobileLayout(service),
              ] else ...[
                _buildDesktopLayout(service, isDesktop),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMobileLayout(service) {
    return Column(
      children: [
        // Pumps Section
        PumpsSection(service: service),

        // Station Tank
        _buildStationTank(service),
        SizedBox(height: 8.h),

        // Transformers Section
        TransformersSection(service: service),
        SizedBox(height: 0.2.h),

        // Weather and Gauges
        WeatherAndGaugesSection(
          ls: service.holdingRegisters[MqttTopics.flow] ?? 0,
          bar: service.holdingRegisters[MqttTopics.pressure] ?? 0,
        ),
      ],
    );
  }

  Widget _buildDesktopLayout(service, bool isDesktop) {
    return Row(
      children: [
        // Left Column - Pumps + Tank
        Expanded(
          flex: isDesktop ? 5 : 3,
          child: SizedBox(
            child: Column(
              children: [
                PumpsSection(service: service),
                _buildStationTank(service),
              ],
            ),
          ),
        ),

        SizedBox(width: 24.w),

        // Right Column - Transformers + Weather
        Expanded(
          flex: isDesktop ? 2 : 2,
          child: Column(
            children: [
              SizedBox(height: isDesktop ? 12.h : 0),
              TransformersSection(service: service),
              SizedBox(height: 0.5.h),
              WeatherAndGaugesSection(
                ls: service.holdingRegisters[MqttTopics.flow] ?? 0,
                bar: service.holdingRegisters[MqttTopics.pressure] ?? 0,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildStationTank(service) {
    return StationTankCard(
      title: "Station 1 Tank",
      flow: service.holdingRegisters[MqttTopics.flow] ?? 0,
      capacity: AppConstants.tankCapacity,
      levels: [
        service.holdingRegisters[MqttTopics.level1] ?? 0,
        service.holdingRegisters[MqttTopics.level2WithLevel4] ?? 0,
        service.holdingRegisters[MqttTopics.level3] ?? 0,
        service.holdingRegisters[MqttTopics.level2WithLevel4] ?? 0,
      ],
    );
  }
}
