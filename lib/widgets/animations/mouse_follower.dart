import 'package:flutter/material.dart';
import 'dart:math' as math;

class MouseFollower extends StatefulWidget {
  final Widget child;
  final bool enabled;

  const MouseFollower({
    super.key,
    required this.child,
    this.enabled = true,
  });

  @override
  State<MouseFollower> createState() => _MouseFollowerState();
}

class _MouseFollowerState extends State<MouseFollower>
    with SingleTickerProviderStateMixin {
  Offset _mousePosition = Offset.zero;
  final List<TrailPoint> _trail = [];
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 16),
    )..addListener(_updateTrail);
    
    if (widget.enabled) {
      _controller.repeat();
    }
  }

  void _updateTrail() {
    setState(() {
      // Fade out existing trail points
      for (var point in _trail) {
        point.opacity *= 0.95;
        point.size *= 0.98;
      }
      
      // Remove fully faded points
      _trail.removeWhere((point) => point.opacity < 0.01);
    });
  }

  void _onMouseMove(PointerEvent details) {
    if (!widget.enabled) return;
    
    setState(() {
      _mousePosition = details.localPosition;
      
      // Add new trail point
      _trail.add(TrailPoint(
        position: _mousePosition,
        opacity: 0.8,
        size: 20.0,
        color: HSLColor.fromAHSL(
          1.0,
          (DateTime.now().millisecondsSinceEpoch % 6000) / 6000 * 360,
          0.8,
          0.6,
        ).toColor(),
      ));
      
      // Limit trail length
      if (_trail.length > 20) {
        _trail.removeAt(0);
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onHover: _onMouseMove,
      child: Stack(
        children: [
          widget.child,
          if (widget.enabled)
            Positioned.fill(
              child: IgnorePointer(
                child: CustomPaint(
                  painter: _TrailPainter(_trail),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class TrailPoint {
  final Offset position;
  double opacity;
  double size;
  final Color color;

  TrailPoint({
    required this.position,
    required this.opacity,
    required this.size,
    required this.color,
  });
}

class _TrailPainter extends CustomPainter {
  final List<TrailPoint> trail;

  _TrailPainter(this.trail);

  @override
  void paint(Canvas canvas, Size size) {
    for (var point in trail) {
      // Draw glow effect
      final glowPaint = Paint()
        ..color = point.color.withOpacity(point.opacity * 0.3)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 10);
      
      canvas.drawCircle(point.position, point.size, glowPaint);
      
      // Draw core
      final corePaint = Paint()
        ..color = point.color.withOpacity(point.opacity)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 3);
      
      canvas.drawCircle(point.position, point.size * 0.5, corePaint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
