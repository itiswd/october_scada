import 'dart:math';

import 'package:flutter/material.dart';

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
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(hours: 1),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
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
          child: ClipRRect(
            borderRadius: BorderRadius.circular(32),
            child: AnimatedBuilder(
              animation: _controller,
              builder: (context, _) {
                final t = _controller.value * 2 * pi * 2000 * widget.waveSpeed;
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
        );
      },
    );
  }
}

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
    _drawWave(
      canvas,
      width,
      height,
      waterY,
      phase * 0.6,
      1.2,
      amplitude * 0.5,
      color2.withValues(alpha: 0.45),
    );

    // Front wave
    _drawWave(
      canvas,
      width,
      height,
      waterY,
      phase,
      2.2,
      amplitude,
      color.withValues(alpha: 0.85),
    );

    // Gloss highlight
    _drawGloss(canvas, width, height, waterY);
  }

  void _drawWave(
    Canvas canvas,
    double width,
    double height,
    double waterY,
    double wavePhase,
    double frequency,
    double waveAmplitude,
    Color waveColor,
  ) {
    final path = Path();
    path.moveTo(0, height);

    for (double x = 0; x <= width; x++) {
      final dx = x / width;
      final y =
          waterY + sin((dx * 2 * pi * frequency) + wavePhase) * waveAmplitude;
      path.lineTo(x, y);
    }

    path.lineTo(width, height);
    path.close();

    final paint = Paint()..color = waveColor;
    canvas.drawPath(path, paint);
  }

  void _drawGloss(Canvas canvas, double width, double height, double waterY) {
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
