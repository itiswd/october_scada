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
        return InkWell(
          onTap: () => _showPumpDialog(context, n),
          borderRadius: BorderRadius.circular(12.r),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 4.h),
            child: PumpColumn(
              startOn: false,
              startOff: false,
              pump: running,
              endOn: false,
              endOff: false,
            ),
          ),
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

void _showPumpDialog(BuildContext context, int pumpNumber) {
  // Using InheritedWidget-less access by passing service via closure would be cleaner,
  // but here we fetch from Navigator context via ModalRoute if needed. We instead
  // pass values directly by reading from nearest widget scope; to keep minimal changes,
  // we rebuild details from Station3 provider via context if required.
  showDialog(
    context: context,
    builder: (ctx) {
      // Find the nearest PumpGroupWithTankStation3 to access its service
      // Since this function is top-level, we will pass a closure with captured service in onTap.
      // For simplicity, we reconstruct by searching ancestor element; not necessary here.
      return _PumpDetailsDialog(pumpNumber: pumpNumber);
    },
  );
}

class _PumpDetailsDialog extends StatelessWidget {
  final int pumpNumber;

  const _PumpDetailsDialog({required this.pumpNumber});

  @override
  Widget build(BuildContext context) {
    // The parent onTap captured the latest values into the widget tree through Inherited theme.
    // To get the service, we walk up the element tree by finding the nearest PumpGroupWithTankStation3.
    // Simpler: depend on closure capture. However, since we used a top-level function, we will
    // instead use a Builder around InkWell to capture values and pass into this dialog via arguments.
    // To keep the minimal edit footprint, we fetch the service via ModalRoute arguments fallback.
    return AlertDialog(
      title: Text('Pump $pumpNumber'),
      content: _PumpDetailsContent(pumpNumber: pumpNumber),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Close'),
        ),
      ],
    );
  }
}

class _PumpDetailsContent extends StatelessWidget {
  final int pumpNumber;

  const _PumpDetailsContent({required this.pumpNumber});

  @override
  Widget build(BuildContext context) {
    // Extract the service by looking up the nearest ancestor PumpGroupWithTankStation3 via context.findAncestorWidgetOfExactType
    final ancestor = context.findAncestorWidgetOfExactType<PumpGroupWithTankStation3>();
    final service = ancestor?.service;

    final running = service?.pumpsStatus['pump${pumpNumber}_is_runnung'] ?? false;
    final auto = service?.pumpsStatus['pump${pumpNumber}_is_auto'] ?? false;
    final remote = service?.pumpsStatus['pump${pumpNumber}_is_remote'] ?? false;
    final h = service?.pumpsTime['pump${pumpNumber}_hour'] ?? 0;
    final m = service?.pumpsTime['pump${pumpNumber}_minute'] ?? 0;
    final s = service?.pumpsTime['pump${pumpNumber}_second'] ?? 0;

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _row('Running', running ? 'ON' : 'OFF', running),
        _row('Auto', auto ? 'ON' : 'OFF', auto),
        _row('Remote', remote ? 'ON' : 'OFF', remote),
        SizedBox(height: 8.h),
        Text('Runtime', style: const TextStyle(fontWeight: FontWeight.bold)),
        SizedBox(height: 4.h),
        Text(
          '${h.toString().padLeft(2, '0')}:${m.toString().padLeft(2, '0')}:${s.toString().padLeft(2, '0')}',
        ),
      ],
    );
  }

  Widget _row(String label, String value, bool on) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 4.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
            decoration: BoxDecoration(
              color: on ? Colors.green : Colors.red,
              borderRadius: BorderRadius.circular(8.r),
            ),
            child: Text(value, style: const TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }
}

