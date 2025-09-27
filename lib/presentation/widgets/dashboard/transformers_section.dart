import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../core/constants/mqtt_topics.dart';
import '../../../core/utils/responsive_helper.dart';
import '../../../data/services/mqtt_service.dart';
import '../../../theme/app_theme.dart';

class TransformersSection extends StatelessWidget {
  final MqttService service;

  const TransformersSection({super.key, required this.service});

  @override
  Widget build(BuildContext context) {
    final isMobile = ResponsiveHelper.isMobile(context);

    return Container(
      width: double.infinity,
      height: isMobile ? 140.h : 300.h,
      decoration: BoxDecoration(
        color: AppTheme.darkerBackground,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24.r)),
      ),
      child: Padding(
        padding: EdgeInsets.all(isMobile ? 12.w : 20.w),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Expanded(child: _buildGenerator()),
            Expanded(child: _buildTransformer1()),
            Expanded(child: _buildTransformer2()),
          ],
        ),
      ),
    );
  }

  Widget _buildGenerator() {
    return _TransformerWidget(
      title: 'Generator',
      value: service.inputs[MqttTopics.generator1],
      imageOn: 'assets/images/generator_on.png',
      imageOff: 'assets/images/generator_off.png',
      converted: true,
    );
  }

  Widget _buildTransformer1() {
    return _TransformerWidget(
      title: 'Transformer 1',
      value: service.inputs[MqttTopics.transformer1],
      imageOn: 'assets/images/transformer_on.png',
      imageOff: 'assets/images/transformer_off.png',
      converted: true,
    );
  }

  Widget _buildTransformer2() {
    return _TransformerWidget(
      title: 'Transformer 2',
      value: service.inputs[MqttTopics.transformer2],
      imageOn: 'assets/images/transformer_on.png',
      imageOff: 'assets/images/transformer_off.png',
      converted: false,
    );
  }
}

class _TransformerWidget extends StatelessWidget {
  final bool? value;
  final String imageOn;
  final String imageOff;
  final String title;
  final bool converted;

  const _TransformerWidget({
    required this.value,
    required this.imageOn,
    required this.title,
    required this.imageOff,
    required this.converted,
  });

  @override
  Widget build(BuildContext context) {
    final isMobile = ResponsiveHelper.isMobile(context);

    String image;
    String statusText;
    Color statusColor;

    if (value == true) {
      image = converted ? imageOff : imageOn;
      statusText = converted ? "OFF" : "ON";
      statusColor = converted ? Colors.red : Colors.green;
    } else {
      image = converted ? imageOn : imageOff;
      statusText = converted ? "ON" : "OFF";
      statusColor = converted ? Colors.green : Colors.red;
    }

    return SizedBox(
      height: isMobile ? 100.h : 180.h,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            image,
            width: isMobile ? 48.w : 96.w,
            height: isMobile ? 48.w : 96.w,
          ),
          SizedBox(height: isMobile ? 4.h : 8.h),
          Text(
            title,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: isMobile ? 12.sp : 20.sp,
              fontWeight: FontWeight.w700,
              color: Colors.white,
            ),
          ),
          Text(
            statusText,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: isMobile ? 12.sp : 20.sp,
              fontWeight: FontWeight.w700,
              color: statusColor,
            ),
          ),
        ],
      ),
    );
  }
}
