import 'package:flutter/material.dart';

import '../../../core/constants/mqtt_topics.dart';
import '../../../core/utils/responsive_helper.dart';
import '../../../data/services/mqtt_service.dart';
import '../pump/pump_column.dart';

class PumpsSection extends StatelessWidget {
  final MqttService service;

  const PumpsSection({super.key, required this.service});

  @override
  Widget build(BuildContext context) {
    final isMobile = ResponsiveHelper.isMobile(context);

    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(
        horizontal: ResponsiveHelper.getHorizontalPadding(context),
      ),
      child: isMobile ? _buildMobileLayout() : _buildDesktopLayout(),
    );
  }

  Widget _buildMobileLayout() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _buildPump1(),
        _buildPump2(),
        _buildPump3(),
        _buildPump4(),
        _buildPump5(),
        _buildPump6(),
      ],
    );
  }

  Widget _buildDesktopLayout() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _buildPump1(),
        _buildPump2(),
        _buildPump3(),
        _buildPump4(),
        _buildPump5(),
        _buildPump6(),
      ],
    );
  }

  Widget _buildPump1() {
    return PumpColumn(
      startOn: service.inputs[MqttTopics.valve1Open] ?? false,
      startOff: service.inputs[MqttTopics.valve1Close] ?? false,
      pump: service.inputs[MqttTopics.pump1] ?? false,
      endOn: service.inputs[MqttTopics.valve2Open] ?? false,
      endOff: service.inputs[MqttTopics.valve2Close] ?? false,
    );
  }

  Widget _buildPump2() {
    return PumpColumn(
      startOn: service.inputs[MqttTopics.valve3Open] ?? false,
      startOff: service.inputs[MqttTopics.valve3Close] ?? false,
      pump: service.inputs[MqttTopics.pump2] ?? false,
      endOn: service.inputs[MqttTopics.valve4Open] ?? false,
      endOff: service.inputs[MqttTopics.valve4Close] ?? false,
    );
  }

  Widget _buildPump3() {
    return PumpColumn(
      startOn: service.inputs[MqttTopics.valve5Open] ?? false,
      startOff: service.inputs[MqttTopics.valve5Close] ?? false,
      pump: service.inputs[MqttTopics.pump3] ?? false,
      endOn: service.inputs[MqttTopics.valve6Open] ?? false,
      endOff: service.inputs[MqttTopics.valve6Close] ?? false,
    );
  }

  Widget _buildPump4() {
    return PumpColumn(
      startOn: service.inputs[MqttTopics.valve7Open] ?? false,
      startOff: service.inputs[MqttTopics.valve7Close] ?? false,
      pump: service.inputs[MqttTopics.pump4] ?? false,
      endOn: false,
      endOff: false,
    );
  }

  Widget _buildPump5() {
    return PumpColumn(
      startOn: false,
      startOff: false,
      pump: service.inputs[MqttTopics.pump1] ?? false,
      endOn: false,
      endOff: false,
    );
  }

  Widget _buildPump6() {
    return PumpColumn(
      startOn: false,
      startOff: false,
      pump: service.inputs[MqttTopics.pump6] ?? false,
      endOn: false,
      endOff: false,
    );
  }
}
