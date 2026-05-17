import 'package:flutter/material.dart';
import 'dart:math' as math;

class Card3D extends StatefulWidget {
  final Widget child;
  final double maxRotation;
  final bool enableParallax;
  final VoidCallback? onTap;

  const Card3D({
    super.key,
    required this.child,
    this.maxRotation = 0.1,
    this.enableParallax = true,
    this.onTap,
  });

  @override
  State<Card3D> createState() => _Card3DState();
}

class _Card3DState extends State<Card3D>
    with SingleTickerProviderStateMixin {
  bool _isHovered = false;
  Offset _mousePosition = Offset.zero;
  late AnimationController _animController;
  
  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
    );
  }

  @override
  void dispose() {
    _animController.dispose();
    super.dispose();
  }

  void _onPointerMove(PointerEvent details, Size size) {
    setState(() {
      _mousePosition = Offset(
        (details.localPosition.dx / size.width) - 0.5,
        (details.localPosition.dy / size.height) - 0.5,
      );
    });
  }

  void _onPointerEnter(PointerEvent event) {
    setState(() => _isHovered = true);
    _animController.forward();
  }

  void _onPointerExit(PointerEvent event) {
    setState(() {
      _isHovered = false;
      _mousePosition = Offset.zero;
    });
    _animController.reverse();
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: _onPointerEnter,
      onExit: _onPointerExit,
      onHover: (event) {
        if (widget.enableParallax) {
          final renderBox = context.findRenderObject() as RenderBox?;
          if (renderBox != null) {
            _onPointerMove(event, renderBox.size);
          }
        }
      },
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedBuilder(
          animation: _animController,
          builder: (context, child) {
            final rotationX = widget.enableParallax
                ? -_mousePosition.dy * widget.maxRotation
                : 0.0;
            final rotationY = widget.enableParallax
                ? _mousePosition.dx * widget.maxRotation
                : 0.0;
            
            return Transform(
              alignment: Alignment.center,
              transform: Matrix4.identity()
                ..setEntry(3, 2, 0.001) // perspective
                ..rotateX(rotationX)
                ..rotateY(rotationY)
                ..scale(1.0 + (_animController.value * 0.05)),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Theme.of(context).colorScheme.primary.withOpacity(
                        0.2 + (_animController.value * 0.3),
                      ),
                      blurRadius: 20 + (_animController.value * 20),
                      spreadRadius: 2 + (_animController.value * 8),
                      offset: Offset(
                        _mousePosition.dx * 10,
                        _mousePosition.dy * 10 + 5,
                      ),
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: Stack(
                    children: [
                      widget.child,
                      
                      // Shine effect
                      if (_isHovered && widget.enableParallax)
                        Positioned.fill(
                          child: CustomPaint(
                            painter: _ShinePainter(
                              mousePosition: _mousePosition,
                              animation: _animController.value,
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

class _ShinePainter extends CustomPainter {
  final Offset mousePosition;
  final double animation;

  _ShinePainter({
    required this.mousePosition,
    required this.animation,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..shader = RadialGradient(
        colors: [
          Colors.white.withOpacity(0.3 * animation),
          Colors.white.withOpacity(0.0),
        ],
        stops: const [0.0, 1.0],
      ).createShader(Rect.fromCircle(
        center: Offset(
          (mousePosition.dx + 0.5) * size.width,
          (mousePosition.dy + 0.5) * size.height,
        ),
        radius: size.width * 0.5,
      ));

    canvas.drawRect(
      Rect.fromLTWH(0, 0, size.width, size.height),
      paint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

// Glitch text effect
class GlitchText extends StatefulWidget {
  final String text;
  final TextStyle? style;
  final Duration duration;

  const GlitchText({
    super.key,
    required this.text,
    this.style,
    this.duration = const Duration(milliseconds: 2000),
  });

  @override
  State<GlitchText> createState() => _GlitchTextState();
}

class _GlitchTextState extends State<GlitchText>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  bool _showGlitch = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: widget.duration,
    )..addListener(() {
        if (_controller.value > 0.8 && _controller.value < 0.85) {
          setState(() => _showGlitch = true);
        } else {
          setState(() => _showGlitch = false);
        }
      });
    
    _controller.repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Original text
        Text(widget.text, style: widget.style),
        
        // Glitch layers
        if (_showGlitch) ...[
          Positioned(
            left: -2,
            child: Text(
              widget.text,
              style: widget.style?.copyWith(
                color: Colors.red.withOpacity(0.7),
              ),
            ),
          ),
          Positioned(
            left: 2,
            child: Text(
              widget.text,
              style: widget.style?.copyWith(
                color: Colors.blue.withOpacity(0.7),
              ),
            ),
          ),
        ],
      ],
    );
  }
}

// Holographic effect
class HolographicCard extends StatefulWidget {
  final Widget child;
  final double width;
  final double height;

  const HolographicCard({
    super.key,
    required this.child,
    required this.width,
    required this.height,
  });

  @override
  State<HolographicCard> createState() => _HolographicCardState();
}

class _HolographicCardState extends State<HolographicCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  Offset _mousePosition = const Offset(0.5, 0.5);

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onHover: (event) {
        final renderBox = context.findRenderObject() as RenderBox?;
        if (renderBox != null) {
          setState(() {
            _mousePosition = Offset(
              event.localPosition.dx / renderBox.size.width,
              event.localPosition.dy / renderBox.size.height,
            );
          });
        }
      },
      child: SizedBox(
        width: widget.width,
        height: widget.height,
        child: Stack(
          children: [
            // Holographic background
            Positioned.fill(
              child: AnimatedBuilder(
                animation: _controller,
                builder: (context, child) {
                  return CustomPaint(
                    painter: _HolographicPainter(
                      animation: _controller.value,
                      mousePosition: _mousePosition,
                    ),
                  );
                },
              ),
            ),
            
            // Content
            widget.child,
          ],
        ),
      ),
    );
  }
}

class _HolographicPainter extends CustomPainter {
  final double animation;
  final Offset mousePosition;

  _HolographicPainter({
    required this.animation,
    required this.mousePosition,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..shader = SweepGradient(
        center: Alignment(
          mousePosition.dx * 2 - 1,
          mousePosition.dy * 2 - 1,
        ),
        colors: [
          Colors.purple.withOpacity(0.3),
          Colors.blue.withOpacity(0.3),
          Colors.cyan.withOpacity(0.3),
          Colors.green.withOpacity(0.3),
          Colors.yellow.withOpacity(0.3),
          Colors.red.withOpacity(0.3),
          Colors.purple.withOpacity(0.3),
        ],
        transform: GradientRotation(animation * math.pi * 2),
      ).createShader(Rect.fromLTWH(0, 0, size.width, size.height));

    canvas.drawRect(
      Rect.fromLTWH(0, 0, size.width, size.height),
      paint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
