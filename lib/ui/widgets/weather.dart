import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:http/http.dart' as http;
import 'package:percent_indicator/circular_percent_indicator.dart';

class WeatherAndGaugesWidget extends StatefulWidget {
  final double bar;
  final double ls;

  const WeatherAndGaugesWidget({
    super.key,
    required this.bar,
    required this.ls,
  });

  @override
  State<WeatherAndGaugesWidget> createState() => _WeatherAndGaugesWidgetState();
}

class _WeatherAndGaugesWidgetState extends State<WeatherAndGaugesWidget> {
  String temperature = "31°C";
  String humidity = "47%";
  String condition = "Clouds";
  String wind = "8";

  @override
  void initState() {
    super.initState();
    fetchWeather();
  }

  Future<void> fetchWeather() async {
    const apiKey = "35ffc091803539bc89a318bd4740dc54";
    const city = "October";
    final url =
        "https://api.openweathermap.org/data/2.5/weather?q=$city&units=metric&appid=$apiKey";

    try {
      final response = await http.get(Uri.parse(url));
      debugPrint("Status: ${response.statusCode}");
      debugPrint("Body: ${response.body}");

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        setState(() {
          temperature = "${data['main']['temp']}°C";
          humidity = "${data['main']['humidity']}%";
          condition = data['weather'][0]['main'];
          wind = data['wind']['speed'].toString();
        });
      } else {
        setState(() {
          condition = "API Error";
        });
      }
    } catch (e) {
      debugPrint("Error: $e");
      setState(() {
        condition = "Error";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Weather row
        Container(
          height: 240.h,
          color: const Color(0xFF1A1A1A),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _WeatherItem(
                icon: 'assets/images/icon_temp.png',
                value: temperature,
                color: Colors.red,
              ),
              SizedBox(width: 56.w),
              _WeatherItem(
                icon: 'assets/images/icon_humidity.png',
                value: humidity,
                color: Colors.blue,
              ),
              SizedBox(width: 56.w),
              _WeatherItem(
                icon: 'assets/images/icon_sunny.png',
                value: condition,
                color: Colors.orange,
              ),
              SizedBox(width: 56.w),
              _WeatherItem(
                icon: 'assets/images/icon_wind.png',
                value: wind,
                color: Colors.blue,
              ),
            ],
          ),
        ),

        SizedBox(height: 1.h),

        // Gauges
        Container(
          height: 300.h,
          padding: EdgeInsets.all(16.w),
          decoration: BoxDecoration(
            color: const Color(0xFF1A1A1A),
            borderRadius: BorderRadius.vertical(bottom: Radius.circular(40.r)),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _GaugeItem(
                value: widget.ls,
                unit: "L/S",
                percent: widget.ls == 0 ? 0 : 0.8,
              ),
              SizedBox(width: 56.w),
              _GaugeItem(
                value: widget.bar,
                unit: "BAR",
                percent: widget.bar == 0 ? 0 : 0.65,
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _WeatherItem extends StatelessWidget {
  final String icon;
  final String value;
  final Color color;

  const _WeatherItem({
    required this.icon,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 140.h,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(icon, width: 56.w, height: 56.h),
          SizedBox(height: 8.h),
          Text(
            value,
            style: TextStyle(
              color: color,
              fontSize: 20.sp,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}

class _GaugeItem extends StatelessWidget {
  final double value;
  final String unit;
  final double percent;

  const _GaugeItem({
    required this.value,
    required this.unit,
    required this.percent,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Center(
          child: CircleAvatar(backgroundColor: Colors.grey[850], radius: 72.r),
        ),
        Center(
          child: CircularPercentIndicator(
            radius: 88.r,
            lineWidth: 28.w,
            percent: percent,
            progressColor: Colors.blue,
            backgroundColor: Colors.grey.shade800,
            circularStrokeCap: CircularStrokeCap.butt,
            startAngle: 270,
            center: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  value.toStringAsFixed(2),
                  style: TextStyle(
                    color: Colors.blue,
                    fontSize: 16.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  unit,
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 12.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            animation: true,
            animationDuration: 1500,
          ),
        ),
      ],
    );
  }
}
