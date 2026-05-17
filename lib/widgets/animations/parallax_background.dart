import 'package:flutter/material.dart';
import 'dart:math' as math;

class ParallaxBackground extends StatefulWidget {
  final Widget child;
  final ScrollController scrollController;

  const ParallaxBackground({
    super.key,
    required this.child,
    required this.scrollController,
  });

  @override
  State<ParallaxBackground> createState() => _ParallaxBackgroundState();
}

class _ParallaxBackgroundState extends State<ParallaxBackground>
    with SingleTickerProviderStateMixin {
  final ValueNotifier<double> _scrollOffset = ValueNotifier(0.0);
  late AnimationController _animController;

  @override
  void initState() {
    super.initState();
    widget.scrollController.addListener(_onScroll);
    
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 20),
    )..repeat();
  }

  void _onScroll() {
    _scrollOffset.value = widget.scrollController.offset;
  }

  @override
  void dispose() {
    widget.scrollController.removeListener(_onScroll);
    _animController.dispose();
    _scrollOffset.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Stack(
      children: [
        // Animated gradient background
        RepaintBoundary(
          child: AnimatedBuilder(
            animation: _animController,
            builder: (context, child) {
              return Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: isDark
                        ? [
                            Color.lerp(
                              const Color(0xFF0F0F1E),
                              const Color(0xFF1A1A2E),
                              math.sin(_animController.value * math.pi * 2) * 0.5 + 0.5,
                            )!,
                            Color.lerp(
                              const Color(0xFF16213E),
                              const Color(0xFF0F3460),
                              math.cos(_animController.value * math.pi * 2) * 0.5 + 0.5,
                            )!,
                          ]
                        : [
                            Color.lerp(
                              const Color(0xFFE8F4F8),
                              const Color(0xFFD4E7F0),
                              math.sin(_animController.value * math.pi * 2) * 0.5 + 0.5,
                            )!,
                            Color.lerp(
                              const Color(0xFFF0F4F8),
                              const Color(0xFFE0E8F0),
                              math.cos(_animController.value * math.pi * 2) * 0.5 + 0.5,
                            )!,
                          ],
                  ),
                ),
              );
            },
          ),
        ),
        
        // Parallax layers - only rebuild on scroll, not on every frame
        RepaintBoundary(
          child: ValueListenableBuilder<double>(
            valueListenable: _scrollOffset,
            builder: (context, scrollOffset, child) {
              return Stack(
                children: [
                  // Parallax layer 1 - Slowest (far background)
                  Positioned.fill(
                    child: Transform.translate(
                      offset: Offset(0, scrollOffset * 0.1),
                      child: CustomPaint(
                        painter: _GeometricPatternPainter(
                          color: theme.colorScheme.primary.withOpacity(0.03),
                          pattern: GeometricPattern.circles,
                          offset: scrollOffset * 0.05,
                        ),
                      ),
                    ),
                  ),
                  
                  // Parallax layer 2 - Medium speed
                  Positioned.fill(
                    child: Transform.translate(
                      offset: Offset(0, scrollOffset * 0.3),
                      child: CustomPaint(
                        painter: _GeometricPatternPainter(
                          color: theme.colorScheme.primary.withOpacity(0.05),
                          pattern: GeometricPattern.hexagons,
                          offset: scrollOffset * 0.1,
                        ),
                      ),
                    ),
                  ),
                  
                  // Parallax layer 3 - Grid lines
                  Positioned.fill(
                    child: Transform.translate(
                      offset: Offset(0, scrollOffset * 0.5),
                      child: CustomPaint(
                        painter: _GridPainter(
                          color: theme.colorScheme.primary.withOpacity(0.08),
                          scrollOffset: scrollOffset,
                        ),
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
        ),
        
        // Floating orbs - driven by animation controller + scroll
        ...List.generate(5, (index) {
          return ValueListenableBuilder<double>(
            valueListenable: _scrollOffset,
            builder: (context, scrollOffset, child) {
              return Positioned(
                left: (index * 200.0) % MediaQuery.of(context).size.width,
                top: (index * 150.0) % 800 - scrollOffset * (0.2 + index * 0.1) % 800,
                child: RepaintBoundary(
                  child: AnimatedBuilder(
                    animation: _animController,
                    builder: (context, child) {
                      return Transform.translate(
                        offset: Offset(
                          math.sin(_animController.value * math.pi * 2 + index) * 50,
                          math.cos(_animController.value * math.pi * 2 + index) * 30,
                        ),
                        child: Container(
                          width: 100 + index * 20.0,
                          height: 100 + index * 20.0,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            gradient: RadialGradient(
                              colors: [
                                theme.colorScheme.primary.withOpacity(0.1),
                                theme.colorScheme.primary.withOpacity(0.0),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              );
            },
          );
        }),
        
        // Content
        widget.child,
      ],
    );
  }
}

enum GeometricPattern { circles, hexagons, triangles }

class _GeometricPatternPainter extends CustomPainter {
  final Color color;
  final GeometricPattern pattern;
  final double offset;

  _GeometricPatternPainter({
    required this.color,
    required this.pattern,
    required this.offset,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5;

    const spacing = 100.0;

    switch (pattern) {
      case GeometricPattern.circles:
        for (double y = -spacing + (offset % spacing); y < size.height + spacing; y += spacing) {
          for (double x = 0; x < size.width + spacing; x += spacing) {
            canvas.drawCircle(Offset(x, y), 30, paint);
          }
        }
        break;
      
      case GeometricPattern.hexagons:
        final hexSize = 40.0;
        for (double y = -spacing + (offset % spacing); y < size.height + spacing; y += spacing * 0.866) {
          for (double x = 0; x < size.width + spacing; x += spacing) {
            _drawHexagon(canvas, Offset(x, y), hexSize, paint);
          }
        }
        break;
      
      case GeometricPattern.triangles:
        for (double y = -spacing + (offset % spacing); y < size.height + spacing; y += spacing) {
          for (double x = 0; x < size.width + spacing; x += spacing) {
            _drawTriangle(canvas, Offset(x, y), 40, paint);
          }
        }
        break;
    }
  }

  void _drawHexagon(Canvas canvas, Offset center, double size, Paint paint) {
    final path = Path();
    for (int i = 0; i < 6; i++) {
      final angle = (math.pi / 3) * i;
      final x = center.dx + size * math.cos(angle);
      final y = center.dy + size * math.sin(angle);
      if (i == 0) {
        path.moveTo(x, y);
      } else {
        path.lineTo(x, y);
      }
    }
    path.close();
    canvas.drawPath(path, paint);
  }

  void _drawTriangle(Canvas canvas, Offset center, double size, Paint paint) {
    final path = Path();
    path.moveTo(center.dx, center.dy - size);
    path.lineTo(center.dx - size, center.dy + size);
    path.lineTo(center.dx + size, center.dy + size);
    path.close();
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

class _GridPainter extends CustomPainter {
  final Color color;
  final double scrollOffset;

  _GridPainter({
    required this.color,
    required this.scrollOffset,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = 1;

    const spacing = 50.0;
    final yOffset = scrollOffset % spacing;

    // Vertical lines
    for (double x = 0; x < size.width; x += spacing) {
      canvas.drawLine(
        Offset(x, 0),
        Offset(x, size.height),
        paint,
      );
    }

    // Horizontal lines
    for (double y = -yOffset; y < size.height; y += spacing) {
      canvas.drawLine(
        Offset(0, y),
        Offset(size.width, y),
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
