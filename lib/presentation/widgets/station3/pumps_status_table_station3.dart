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
      decoration: BoxDecoration(
        color: AppTheme.darkerBackground,
        borderRadius: BorderRadius.circular(16.r),
      ),
      clipBehavior: Clip.antiAlias,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: DataTable(
          columns: const [
            DataColumn(label: Text('Pump')),
            DataColumn(label: Text('Running')),
            DataColumn(label: Text('Auto')),
            DataColumn(label: Text('Remote')),
            DataColumn(label: Text('Working Time')),
          ],
          rows: List.generate(6, (index) {
            final n = index + 1;
            final running = service.pumpsStatus['pump${n}_is_runnung'] ?? false;
            final auto = service.pumpsStatus['pump${n}_is_auto'] ?? false;
            final remote = service.pumpsStatus['pump${n}_is_remote'] ?? false;
            final h = service.pumpsTime['pump${n}_hour'] ?? 0;
            final m = service.pumpsTime['pump${n}_minute'] ?? 0;
            final s = service.pumpsTime['pump${n}_second'] ?? 0;
            final time =
                '${h.toString().padLeft(2, '0')}:${m.toString().padLeft(2, '0')}:${s.toString().padLeft(2, '0')}'
                    .toString();
            return DataRow(
              cells: [
                DataCell(Text('Pump $n')),
                DataCell(_boolChip(running)),
                DataCell(_boolChip(auto)),
                DataCell(_boolChip(remote)),
                DataCell(Text(time)),
              ],
            );
          }),
          headingRowColor: WidgetStateProperty.resolveWith(
            (_) => Colors.black12,
          ),
          dataTextStyle: const TextStyle(color: Colors.white),
          headingTextStyle: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
          dividerThickness: 0.5,
          border: TableBorder.symmetric(
            inside: const BorderSide(color: Colors.white24, width: 0.5),
          ),
        ),
      ),
    );
  }

  Widget _boolChip(bool value) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
      decoration: BoxDecoration(
        color: value ? Colors.green : Colors.red,
        borderRadius: BorderRadius.circular(8.r),
      ),
      child: Text(
        value ? 'ON' : 'OFF',
        style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
      ),
    );
  }
}
