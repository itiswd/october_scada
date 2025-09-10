import 'dart:math';

import 'package:flutter/material.dart';

/// Full-width tank widget with animated water (wave) inside.
/// - height: 50 (fixed)
/// - waveAmplitude controls wave height (in px)
/// - waveSpeed controls animation speed
class WaveTank extends StatefulWidget {
  final double height;
  final double waveAmplitude;
  final double waveSpeed;
  final Color borderColor;
  final double borderWidth;
  final Color waterColor;
  final Color waterColor2;

  const WaveTank({
    super.key,
    this.height = 50,
    this.waveAmplitude = 6.0,
    this.waveSpeed = 1.0,
    this.borderColor = Colors.black,
    this.borderWidth = 2.0,
    this.waterColor = const Color(0xff1E90FF),
    this.waterColor2 = const Color(0xff00BFFF),
  });

  @override
  WaveTankState createState() => WaveTankState();
}

class WaveTankState extends State<WaveTank>
    with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(hours: 1), // ⏳ الريستارت كل ساعة
    )..repeat();
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth;
        final height = widget.height;

        return SizedBox(
          width: width,
          height: height,
          child: Stack(
            alignment: Alignment.center,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(32),
                child: AnimatedBuilder(
                  animation: _ctrl,
                  builder: (context, _) {
                    // 🔹 نخلي الموجة تتحرك بسرعة لكن تعيد كل ساعة
                    final t = _ctrl.value * 2 * pi * 2000;
                    return CustomPaint(
                      size: Size(width, height),
                      painter: _WavePainter(
                        phase: t,
                        amplitude: widget.waveAmplitude,
                        color: widget.waterColor,
                        color2: widget.waterColor2,
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

/// Painter draws two sine waves (front + back) and fills below them.
class _WavePainter extends CustomPainter {
  final double phase;
  final double amplitude;
  final Color color;
  final Color color2;

  _WavePainter({
    required this.phase,
    required this.amplitude,
    required this.color,
    required this.color2,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final width = size.width;
    final height = size.height;

    final waterY = height / 2;

    // Back wave
    final pathBack = Path();
    pathBack.moveTo(0, height);
    for (double x = 0; x <= width; x++) {
      final dx = x / width;
      final y =
          waterY + sin((dx * 2 * pi * 1.2) + phase * 0.6) * (amplitude * 0.5);
      pathBack.lineTo(x, y);
    }
    pathBack.lineTo(width, height);
    pathBack.close();

    final paintBack = Paint()..color = color2.withValues(alpha: 0.45);
    canvas.drawPath(pathBack, paintBack);

    // Front wave
    final pathFront = Path();
    pathFront.moveTo(0, height);
    for (double x = 0; x <= width; x++) {
      final dx = x / width;
      final y = waterY + sin((dx * 2 * pi * 2.2) + phase) * amplitude;
      pathFront.lineTo(x, y);
    }
    pathFront.lineTo(width, height);
    pathFront.close();

    final paintFront = Paint()..color = color.withValues(alpha: 0.85);
    canvas.drawPath(pathFront, paintFront);

    // Gloss highlight
    final highlight = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          Colors.black.withValues(alpha: 0.12),
          Colors.black.withValues(alpha: 0.02),
        ],
      ).createShader(Rect.fromLTWH(0, 0, width, height))
      ..blendMode = BlendMode.srcOver;

    canvas.saveLayer(Rect.fromLTWH(0, 0, width, height), Paint());
    canvas.drawRect(Rect.fromLTWH(0, 0, width, waterY + amplitude), highlight);
    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant _WavePainter oldDelegate) {
    return oldDelegate.phase != phase ||
        oldDelegate.amplitude != amplitude ||
        oldDelegate.color != color ||
        oldDelegate.color2 != color2;
  }
}
