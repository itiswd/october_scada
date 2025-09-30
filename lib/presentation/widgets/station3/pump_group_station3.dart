import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:october_scada/core/core.dart';
import 'package:october_scada/data/data.dart';
import 'package:october_scada/presentation/widgets/widgets.dart';
import 'package:october_scada/theme/theme.dart';

class PumpGroupWithTankStation3 extends StatelessWidget {
  final MqttService service;
  final List<int> pumpNumbers; // e.g., [1,2,3]
  final int tankNumber; // 1 or 2

  const PumpGroupWithTankStation3({
    super.key,
    required this.service,
    required this.pumpNumbers,
    required this.tankNumber,
  });

  @override
  Widget build(BuildContext context) {
    final isMobile = ResponsiveHelper.isMobile(context);
    final isDesktop = ResponsiveHelper.isDesktop(context);

    final tankLevelKey =
        tankNumber == 1 ? MqttTopics.tank1Level : MqttTopics.tank2Level;
    final tankFlowKey =
        tankNumber == 1 ? MqttTopics.tank1Flow : MqttTopics.tank2Flow;

    final tankCard = StationTankCard3(
      title: 'Tank $tankNumber',
      flow: service.tankData[tankFlowKey] ?? 0.0,
      capacity: AppConstants.tankCapacity,
      levels: [service.tankData[tankLevelKey] ?? 0.0],
    );

    final pumpsRow = Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: pumpNumbers.map((n) {
        final running = service.pumpsStatus['pump${n}_is_runnung'] ?? false;
        return PumpColumn(
          startOn: false,
          startOff: false,
          pump: running,
          endOn: false,
          endOff: false,
        );
      }).toList(),
    );

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: AppTheme.darkerBackground,
        borderRadius: BorderRadius.circular(24.r),
      ),
      padding: EdgeInsets.all(isMobile ? 12.r : 16.r),
      child: isDesktop
          ? Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(flex: 3, child: pumpsRow),
                SizedBox(width: 16.w),
                Expanded(flex: 2, child: tankCard),
              ],
            )
          : Column(
              children: [
                pumpsRow,
                SizedBox(height: 12.h),
                tankCard,
              ],
            ),
    );
  }
}


