import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:october_scada/data/data.dart';
import 'package:october_scada/theme/theme.dart';

class PumpsStatusTableStation3 extends StatelessWidget {
  final MqttService service;

  const PumpsStatusTableStation3({super.key, required this.service});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: AppTheme.darkerBackground,
        borderRadius: BorderRadius.circular(24.r),
      ),
      child: ListView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: 6,
        itemBuilder: (context, index) {
          final n = index + 1;
          final running = service.pumpsStatus['pump${n}_is_runnung'] ?? false;
          final auto = service.pumpsStatus['pump${n}_is_auto'] ?? false;
          final remote = service.pumpsStatus['pump${n}_is_remote'] ?? false;
          final h = service.pumpsTime['pump${n}_hour'] ?? 0;
          final m = service.pumpsTime['pump${n}_minute'] ?? 0;
          final s = service.pumpsTime['pump${n}_second'] ?? 0;
          final time =
              '${h.toString().padLeft(2, '0')}:${m.toString().padLeft(2, '0')}:${s.toString().padLeft(2, '0')}';

          return Card(
            color: Colors.black26,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12.r),
            ),
            margin: EdgeInsets.symmetric(vertical: 6.h),
            child: Padding(
              padding: EdgeInsets.all(12.w),
              child: Row(
                children: [
                  // Pump title
                  Expanded(
                    flex: 2,
                    child: Text(
                      'Pump $n',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16.sp,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),

                  // Status chips
                  Expanded(child: _statusColumn('Running', running)),
                  Expanded(child: _statusColumn('Auto', auto)),
                  Expanded(child: _statusColumn('Remote', remote)),

                  // Working time
                  Expanded(
                    flex: 2,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          'Working Time',
                          style: TextStyle(
                            color: Colors.white70,
                            fontSize: 11.sp,
                          ),
                        ),
                        SizedBox(height: 4.h),
                        Text(
                          time,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 13.sp,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _statusColumn(String label, bool value) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          label,
          style: TextStyle(color: Colors.white70, fontSize: 11.sp),
        ),
        SizedBox(height: 4.h),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
          decoration: BoxDecoration(
            color: value ? Colors.green : Colors.red,
            borderRadius: BorderRadius.circular(8.r),
          ),
          child: Text(
            value ? 'ON' : 'OFF',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 12.sp,
            ),
          ),
        ),
      ],
    );
  }
}
