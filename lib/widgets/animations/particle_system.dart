import 'package:flutter/material.dart';
import 'dart:math' as math;

class Particle {
  double x;
  double y;
  double vx;
  double vy;
  double size;
  double opacity;
  Color color;
  double rotationSpeed;
  double rotation;
  String? symbol;

  Particle({
    required this.x,
    required this.y,
    required this.vx,
    required this.vy,
    required this.size,
    required this.opacity,
    required this.color,
    required this.rotationSpeed,
    this.rotation = 0,
    this.symbol,
  });
}

class ParticleSystem extends StatefulWidget {
  final int particleCount;
  final Color? particleColor;
  final bool showCodeSymbols;
  final double particleSpeed;

  const ParticleSystem({
    super.key,
    this.particleCount = 50,
    this.particleColor,
    this.showCodeSymbols = true,
    this.particleSpeed = 1.0,
  });

  @override
  State<ParticleSystem> createState() => _ParticleSystemState();
}

class _ParticleSystemState extends State<ParticleSystem>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  final List<Particle> _particles = [];
  final List<String> _codeSymbols = [
    '{', '}', '<', '>', '/', '(', ')', '[', ']', ';',
    '=', '+', '-', '*', '&', '|', '?', '!', '#', '@'
  ];
  Size _lastSize = Size.zero;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 16),
    )..addListener(_updateParticles);
    
    _controller.repeat();
  }

  void _initParticles(Size size) {
    if (_particles.isEmpty) {
      _lastSize = size;
      final random = math.Random();
      for (int i = 0; i < widget.particleCount; i++) {
        _particles.add(Particle(
          x: random.nextDouble() * size.width,
          y: random.nextDouble() * size.height,
          vx: (random.nextDouble() - 0.5) * widget.particleSpeed,
          vy: (random.nextDouble() - 0.5) * widget.particleSpeed,
          size: random.nextDouble() * 3 + 1,
          opacity: random.nextDouble() * 0.5 + 0.2,
          color: widget.particleColor ?? 
                 Color.lerp(Colors.blue, Colors.purple, random.nextDouble())!,
          rotationSpeed: (random.nextDouble() - 0.5) * 0.02,
          rotation: random.nextDouble() * math.pi * 2,
          symbol: widget.showCodeSymbols 
              ? _codeSymbols[random.nextInt(_codeSymbols.length)]
              : null,
        ));
      }
    }
  }

  void _updateParticles() {
    for (var particle in _particles) {
      particle.x += particle.vx;
      particle.y += particle.vy;
      particle.rotation += particle.rotationSpeed;

      if (particle.x < 0) particle.x = _lastSize.width;
      if (particle.x > _lastSize.width) particle.x = 0;
      if (particle.y < 0) particle.y = _lastSize.height;
      if (particle.y > _lastSize.height) particle.y = 0;
    }
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
        final size = Size(constraints.maxWidth, constraints.maxHeight);
        _initParticles(size);
        _lastSize = size;

        return RepaintBoundary(
          child: AnimatedBuilder(
            animation: _controller,
            builder: (context, child) {
              return CustomPaint(
                size: size,
                painter: _ParticlePainter(_particles),
              );
            },
          ),
        );
      },
    );
  }
}

class _ParticlePainter extends CustomPainter {
  final List<Particle> particles;

  _ParticlePainter(this.particles);

  @override
  void paint(Canvas canvas, Size size) {
    for (var particle in particles) {
      final paint = Paint()
        ..color = particle.color.withOpacity(particle.opacity)
        ..style = PaintingStyle.fill;

      if (particle.symbol != null) {
        // Draw code symbol
        final textPainter = TextPainter(
          text: TextSpan(
            text: particle.symbol,
            style: TextStyle(
              color: particle.color.withOpacity(particle.opacity),
              fontSize: particle.size * 4,
              fontWeight: FontWeight.bold,
            ),
          ),
          textDirection: TextDirection.ltr,
        );
        textPainter.layout();
        
        canvas.save();
        canvas.translate(particle.x, particle.y);
        canvas.rotate(particle.rotation);
        textPainter.paint(
          canvas,
          Offset(-textPainter.width / 2, -textPainter.height / 2),
        );
        canvas.restore();
      } else {
        // Draw circle
        canvas.drawCircle(
          Offset(particle.x, particle.y),
          particle.size,
          paint,
        );
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
