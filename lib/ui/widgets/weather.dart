import 'dart:convert';

import 'package:flutter/material.dart';
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
  String temperature = "--°C";
  String humidity = "--%";
  String condition = "Loading...";
  String wind = "--";

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
          height: 200,
          margin: const EdgeInsets.only(bottom: 16, top: 16),
          decoration: BoxDecoration(
            color: const Color(0xFF1A1A1A),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Row(
            children: [
              _WeatherItem(
                icon: 'assets/images/icon_temp.png',
                value: temperature,
                color: Colors.orange,
              ),
              _WeatherItem(
                icon: 'assets/images/icon_humidity.png',
                value: humidity,
                color: Colors.blue,
              ),
              _WeatherItem(
                icon: 'assets/images/icon_sunny.png',
                value: condition,
                color: Colors.orange,
              ),
              _WeatherItem(
                icon: 'assets/images/icon_wind.png',
                value: wind,
                color: Colors.green,
              ),
            ],
          ),
        ),

        // Gauges
        Container(
          height: 200,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: const Color(0xFF1A1A1A),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _GaugeItem(
                value: widget.ls,
                unit: "L/S",
                percent: widget.ls == 0 ? 0 : 0.8,
              ),
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
      width: 120,
      height: 140,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(icon, width: 40, height: 40, color: color),
          const SizedBox(height: 6),
          Text(
            value,
            style: TextStyle(
              color: color,
              fontSize: 14,
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
    return SizedBox(
      width: 220,
      child: Stack(
        children: [
          Center(
            child: CircleAvatar(backgroundColor: Colors.grey[850], radius: 60),
          ),
          Center(
            child: CircularPercentIndicator(
              radius: 64,
              lineWidth: 24,
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
                    style: const TextStyle(
                      color: Colors.blue,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    unit,
                    style: const TextStyle(
                      color: Colors.white70,
                      fontSize: 12,
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
      ),
    );
  }
}
