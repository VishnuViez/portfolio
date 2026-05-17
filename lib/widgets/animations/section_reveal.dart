import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:visibility_detector/visibility_detector.dart';
import 'dart:math' as math;

class SectionReveal extends StatefulWidget {
  final Widget child;
  final String uniqueKey;
  final Duration duration;
  final Curve curve;
  final RevealStyle style;

  const SectionReveal({
    super.key,
    required this.child,
    required this.uniqueKey,
    this.duration = const Duration(milliseconds: 800),
    this.curve = Curves.easeOut,
    this.style = RevealStyle.slideUp,
  });

  @override
  State<SectionReveal> createState() => _SectionRevealState();
}

class _SectionRevealState extends State<SectionReveal>
    with SingleTickerProviderStateMixin {
  bool _isVisible = false;
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: widget.duration,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return VisibilityDetector(
      key: Key(widget.uniqueKey),
      onVisibilityChanged: (info) {
        if (info.visibleFraction > 0.05 && !_isVisible) {
          setState(() => _isVisible = true);
          _controller.forward();
        }
      },
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          return _buildRevealAnimation(widget.style);
        },
      ),
    );
  }

  Widget _buildRevealAnimation(RevealStyle style) {
    switch (style) {
      case RevealStyle.slideUp:
        return Transform.translate(
          offset: Offset(0, 50 * (1 - _controller.value)),
          child: Opacity(
            opacity: _controller.value,
            child: widget.child,
          ),
        );
      
      case RevealStyle.slideLeft:
        return Transform.translate(
          offset: Offset(100 * (1 - _controller.value), 0),
          child: Opacity(
            opacity: _controller.value,
            child: widget.child,
          ),
        );
      
      case RevealStyle.slideRight:
        return Transform.translate(
          offset: Offset(-100 * (1 - _controller.value), 0),
          child: Opacity(
            opacity: _controller.value,
            child: widget.child,
          ),
        );
      
      case RevealStyle.scale:
        return Transform.scale(
          scale: 0.8 + (0.2 * _controller.value),
          child: Opacity(
            opacity: _controller.value,
            child: widget.child,
          ),
        );
      
      case RevealStyle.rotate:
        return Transform.rotate(
          angle: (1 - _controller.value) * 0.3,
          child: Opacity(
            opacity: _controller.value,
            child: widget.child,
          ),
        );
      
      case RevealStyle.flip:
        return Transform(
          alignment: Alignment.center,
          transform: Matrix4.identity()
            ..setEntry(3, 2, 0.001)
            ..rotateX((1 - _controller.value) * math.pi / 2),
          child: Opacity(
            opacity: _controller.value,
            child: widget.child,
          ),
        );
      
      case RevealStyle.expand:
        return ClipRect(
          child: Align(
            alignment: Alignment.topCenter,
            heightFactor: _controller.value,
            child: widget.child,
          ),
        );
      
      case RevealStyle.blur:
        return Opacity(
          opacity: _controller.value,
          child: widget.child,
        );
    }
  }
}

enum RevealStyle {
  slideUp,
  slideLeft,
  slideRight,
  scale,
  rotate,
  flip,
  expand,
  blur,
}

// Animated gradient text
class GradientText extends StatefulWidget {
  final String text;
  final TextStyle? style;
  final List<Color> colors;
  final Duration duration;

  const GradientText({
    super.key,
    required this.text,
    this.style,
    this.colors = const [
      Color(0xFF667eea),
      Color(0xFF764ba2),
      Color(0xFFf093fb),
    ],
    this.duration = const Duration(seconds: 3),
  });

  @override
  State<GradientText> createState() => _GradientTextState();
}

class _GradientTextState extends State<GradientText>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: widget.duration,
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return ShaderMask(
          shaderCallback: (bounds) {
            return LinearGradient(
              colors: widget.colors,
              stops: [
                _controller.value - 0.3,
                _controller.value,
                _controller.value + 0.3,
              ].map((v) => v.clamp(0.0, 1.0)).toList(),
              tileMode: TileMode.mirror,
            ).createShader(bounds);
          },
          child: Text(
            widget.text,
            style: widget.style?.copyWith(
              color: Colors.white,
            ),
          ),
        );
      },
    );
  }
}

// Pulsating border
class PulsatingBorder extends StatefulWidget {
  final Widget child;
  final Color color;
  final double borderWidth;
  final BorderRadius? borderRadius;

  const PulsatingBorder({
    super.key,
    required this.child,
    required this.color,
    this.borderWidth = 2.0,
    this.borderRadius,
  });

  @override
  State<PulsatingBorder> createState() => _PulsatingBorderState();
}

class _PulsatingBorderState extends State<PulsatingBorder>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Container(
          decoration: BoxDecoration(
            borderRadius: widget.borderRadius ?? BorderRadius.circular(12),
            border: Border.all(
              color: widget.color.withOpacity(0.3 + (_controller.value * 0.7)),
              width: widget.borderWidth + (_controller.value * 2),
            ),
            boxShadow: [
              BoxShadow(
                color: widget.color.withOpacity(_controller.value * 0.5),
                blurRadius: 10 + (_controller.value * 20),
                spreadRadius: _controller.value * 5,
              ),
            ],
          ),
          child: widget.child,
        );
      },
    );
  }
}

// Ripple effect
class RippleEffect extends StatefulWidget {
  final Widget child;
  final Color? color;

  const RippleEffect({
    super.key,
    required this.child,
    this.color,
  });

  @override
  State<RippleEffect> createState() => _RippleEffectState();
}

class _RippleEffectState extends State<RippleEffect>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2000),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final color = widget.color ?? Theme.of(context).colorScheme.primary;
    
    return Stack(
      alignment: Alignment.center,
      children: [
        // Multiple ripple circles
        ...List.generate(3, (index) {
          return AnimatedBuilder(
            animation: _controller,
            builder: (context, child) {
              final delay = index * 0.33;
              final value = (_controller.value + delay) % 1.0;
              
              return Container(
                width: 100 + (value * 150),
                height: 100 + (value * 150),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: color.withOpacity((1 - value) * 0.3),
                    width: 3,
                  ),
                ),
              );
            },
          );
        }),
        widget.child,
      ],
    );
  }
}
