import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:october_scada/core/core.dart';
import 'package:october_scada/data/data.dart';
import 'package:october_scada/presentation/stations/station3/widgets/pump_card_station3.dart';
import 'package:october_scada/theme/theme.dart';

class PumpsSectionStation3 extends StatelessWidget {
  final MqttService service;

  const PumpsSectionStation3({super.key, required this.service});

  @override
  Widget build(BuildContext context) {
    final isMobile = ResponsiveHelper.isMobile(context);

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: AppTheme.darkerBackground,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24.r)),
      ),
      padding: EdgeInsets.symmetric(
        horizontal: ResponsiveHelper.getHorizontalPadding(context),
        vertical: isMobile ? 12.h : 16.h,
      ),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: List.generate(6, (index) {
            final pumpNum = index + 1;
            return Padding(
              padding: EdgeInsets.symmetric(horizontal: isMobile ? 6.w : 10.w),
              child: PumpCardStation3(
                pumpNumber: pumpNum,
                isRunning:
                    service.pumpsStatus['pump${pumpNum}_is_runnung'] ?? false,
                isAuto: service.pumpsStatus['pump${pumpNum}_is_auto'] ?? false,
                isRemote:
                    service.pumpsStatus['pump${pumpNum}_is_remote'] ?? false,
                hours: service.pumpsTime['pump${pumpNum}_hour'] ?? 0,
                minutes: service.pumpsTime['pump${pumpNum}_minute'] ?? 0,
                seconds: service.pumpsTime['pump${pumpNum}_second'] ?? 0,
              ),
            );
          }),
        ),
      ),
    );
  }
}
