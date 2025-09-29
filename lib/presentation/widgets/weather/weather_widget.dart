import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:http/http.dart' as http;
import 'package:october_scada/theme/app_theme.dart';

import '../../../core/constants/app_constants.dart';
import '../../../core/utils/responsive_helper.dart';

class WeatherWidget extends StatefulWidget {
  const WeatherWidget({super.key});

  @override
  State<WeatherWidget> createState() => _WeatherWidgetState();
}

class _WeatherWidgetState extends State<WeatherWidget> {
  String temperature = "31°C";
  String humidity = "47%";
  String condition = "Clouds";
  String wind = "8";
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchWeather();
  }

  Future<void> _fetchWeather() async {
    const url =
        "https://api.openweathermap.org/data/2.5/weather"
        "?q=${AppConstants.weatherCity}"
        "&units=metric"
        "&appid=${AppConstants.weatherApiKey}";

    try {
      final response = await http
          .get(Uri.parse(url))
          .timeout(const Duration(seconds: 6));

      if (response.statusCode == 200) {
        final data = json.decode(response.body) as Map<String, dynamic>;
        final main = data['main'] as Map<String, dynamic>?;
        final weatherList = data['weather'] as List?;
        final windMap = data['wind'] as Map<String, dynamic>?;

        final tempValue = (main?['temp'] as num?)?.round();
        final humidityValue = (main?['humidity'] as num?)?.toInt();
        final conditionText = (weatherList != null && weatherList.isNotEmpty)
            ? (weatherList[0]['main'] as String? ?? 'N/A')
            : 'N/A';
        final windValue = (windMap?['speed'] as num?)?.toDouble() ?? 0.0;
        if (mounted) {
          setState(() {
            temperature = tempValue != null ? "$tempValue°C" : "--";
            humidity = humidityValue != null ? "$humidity%" : "--";
            condition = conditionText;
            wind = windValue.toStringAsFixed(1);
            isLoading = false;
          });
        }
      } else {
        _setErrorState("API Error");
      }
    } catch (e) {
      debugPrint("Weather fetch error: $e");
      _setErrorState("Connection Error");
    }
  }

  void _setErrorState(String errorMessage) {
    if (mounted) {
      setState(() {
        condition = errorMessage;
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final isMobile = ResponsiveHelper.isMobile(context);

    return Container(
      height: isMobile ? 100.h : 240.h,
      color: AppTheme.darkerBackground,
      child: isLoading
          ? _buildLoadingState(isMobile)
          : _buildWeatherData(isMobile),
    );
  }

  Widget _buildLoadingState(bool isMobile) {
    return Center(
      child: CircularProgressIndicator(
        color: Colors.blue,
        strokeWidth: isMobile ? 2.0 : 4.0,
      ),
    );
  }

  Widget _buildWeatherData(bool isMobile) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _buildWeatherItem(
          'assets/images/icon_temp.png',
          temperature,
          Colors.red,
          isMobile,
        ),
        SizedBox(width: 56.w),
        _buildWeatherItem(
          'assets/images/icon_humidity.png',
          humidity,
          Colors.blue,
          isMobile,
        ),
        SizedBox(width: 56.w),
        _buildWeatherItem(
          'assets/images/icon_sunny.png',
          condition,
          Colors.orange,
          isMobile,
        ),
        SizedBox(width: 56.w),
        _buildWeatherItem(
          'assets/images/icon_wind.png',
          wind,
          Colors.blue,
          isMobile,
        ),
      ],
    );
  }
}

Widget _buildWeatherItem(
  String icon,
  String value,
  Color color,
  bool isMobile,
) {
  return SizedBox(
    height: isMobile ? 64.h : 140.h,
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Image.asset(
          icon,
          width: isMobile ? 28.w : 56.w,
          height: isMobile ? 28.h : 56.h,
          errorBuilder: (context, error, stackTrace) {
            return Icon(
              Icons.error,
              size: isMobile ? 28.w : 56.w,
              color: Colors.grey,
            );
          },
        ),
        SizedBox(height: 4.h),
        Text(
          value,
          style: TextStyle(
            color: color,
            fontSize: isMobile ? 12.sp : 20.sp,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    ),
  );
}
