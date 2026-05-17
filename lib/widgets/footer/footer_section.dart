import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:visibility_detector/visibility_detector.dart';
import 'dart:math' as math;

class FooterSection extends StatefulWidget {
  const FooterSection({super.key});

  @override
  State<FooterSection> createState() => _FooterSectionState();
}

class _FooterSectionState extends State<FooterSection>
    with TickerProviderStateMixin {
  bool _isVisible = false;
  late AnimationController _waveController;
  late AnimationController _floatController;
  late AnimationController _pulseController;

  @override
  void initState() {
    super.initState();
    
    _waveController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 4),
    )..repeat();
    
    _floatController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    )..repeat(reverse: true);
    
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2000),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _waveController.dispose();
    _floatController.dispose();
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final size = MediaQuery.of(context).size;
    final isMobile = size.width < 768;

    return VisibilityDetector(
      key: const Key('footer-section'),
      onVisibilityChanged: (info) {
        if (info.visibleFraction > 0.3 && !_isVisible) {
          setState(() => _isVisible = true);
        }
      },
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: isMobile ? 24 : 80,
          vertical: 60,
        ),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              theme.colorScheme.surface,
              theme.colorScheme.surface.withOpacity(0.8),
            ],
          ),
          border: Border(
            top: BorderSide(
              color: theme.colorScheme.primary.withOpacity(0.3),
              width: 2,
            ),
          ),
          boxShadow: [
            BoxShadow(
              color: theme.colorScheme.primary.withOpacity(0.1),
              blurRadius: 30,
              spreadRadius: 10,
            ),
          ],
        ),
        child: Stack(
          children: [
            // Animated wave background
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: AnimatedBuilder(
                animation: _waveController,
                builder: (context, child) {
                  return CustomPaint(
                    size: Size(size.width, 80),
                    painter: _WavePainter(
                      color: theme.colorScheme.primary.withOpacity(0.1),
                      animation: _waveController.value,
                    ),
                  );
                },
              ),
            ),
            
            // Main content
            Column(
              children: [
                // Logo & Description with floating animation
                AnimatedBuilder(
                  animation: _floatController,
                  builder: (context, child) {
                    return Transform.translate(
                      offset: Offset(0, math.sin(_floatController.value * math.pi) * 10),
                      child: Column(
                        children: [
                          // Animated Logo
                          AnimatedBuilder(
                            animation: _pulseController,
                            builder: (context, child) {
                              return Transform.scale(
                                scale: 1.0 + (_pulseController.value * 0.1),
                                child: Container(
                                  padding: const EdgeInsets.all(20),
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    gradient: RadialGradient(
                                      colors: [
                                        theme.colorScheme.primary.withOpacity(0.2),
                                        theme.colorScheme.primary.withOpacity(0.0),
                                      ],
                                    ),
                                    boxShadow: [
                                      BoxShadow(
                                        color: theme.colorScheme.primary.withOpacity(0.3),
                                        blurRadius: 30,
                                        spreadRadius: 10,
                                      ),
                                    ],
                                  ),
                                  child: Text(
                                    'Vishnu',
                                    style: theme.textTheme.headlineMedium?.copyWith(
                                      color: theme.colorScheme.primary,
                                      fontWeight: FontWeight.bold,
                                      fontFamily: 'monospace',
                                      shadows: [
                                        Shadow(
                                          color: theme.colorScheme.primary.withOpacity(0.5),
                                          blurRadius: 20,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            },
                          ).animate(target: _isVisible ? 1 : 0)
                           .fadeIn(duration: 800.ms)
                           .scale(begin: const Offset(0.5, 0.5)),
                          
                          const SizedBox(height: 24),
                          
                          Text(
                            'Mobile Application Developer',
                            style: theme.textTheme.titleMedium?.copyWith(
                              color: theme.colorScheme.primary,
                              letterSpacing: 2,
                            ),
                            textAlign: TextAlign.center,
                          ).animate(target: _isVisible ? 1 : 0)
                           .fadeIn(duration: 800.ms, delay: 200.ms)
                           .slideY(begin: 0.5, end: 0),
                        ],
                      ),
                    );
                  },
                ),
                
                const SizedBox(height: 40),
                
                // Animated divider
                AnimatedBuilder(
                  animation: _waveController,
                  builder: (context, child) {
                    return Container(
                      height: 3,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            theme.colorScheme.primary.withOpacity(0.0),
                            theme.colorScheme.primary.withOpacity(
                              0.5 + math.sin(_waveController.value * math.pi * 2) * 0.3,
                            ),
                            theme.colorScheme.primary.withOpacity(0.0),
                          ],
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: theme.colorScheme.primary.withOpacity(0.5),
                            blurRadius: 10,
                            spreadRadius: 2,
                          ),
                        ],
                      ),
                    );
                  },
                ).animate(target: _isVisible ? 1 : 0)
                 .fadeIn(duration: 600.ms, delay: 400.ms)
                 .scaleX(begin: 0, end: 1),
                
                const SizedBox(height: 32),
                
                // Floating tech stack icons
                Wrap(
                  spacing: 20,
                  runSpacing: 20,
                  alignment: WrapAlignment.center,
                  children: [
                    _buildTechIcon(context, '💙', 'Flutter'),
                    _buildTechIcon(context, '🎯', 'Dart'),
                    _buildTechIcon(context, '📱', 'Mobile'),
                    _buildTechIcon(context, '🚀', 'Innovation'),
                    _buildTechIcon(context, '⚡', 'Performance'),
                  ],
                ),
                
                const SizedBox(height: 40),
                
                // Copyright with glitch effect
                AnimatedBuilder(
                  animation: _pulseController,
                  builder: (context, child) {
                    final showGlitch = _pulseController.value > 0.95;
                    return Stack(
                      alignment: Alignment.center,
                      children: [
                        if (showGlitch) ...[
                          Positioned(
                            left: -1,
                            child: Text(
                              '© ${DateTime.now().year} Vishnu. All rights reserved.',
                              style: theme.textTheme.bodyMedium?.copyWith(
                                color: Colors.red.withOpacity(0.7),
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                          Positioned(
                            left: 1,
                            child: Text(
                              '© ${DateTime.now().year} Vishnu. All rights reserved.',
                              style: theme.textTheme.bodyMedium?.copyWith(
                                color: Colors.blue.withOpacity(0.7),
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ],
                        Text(
                          '© ${DateTime.now().year} Vishnu. All rights reserved.',
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: theme.textTheme.bodyMedium!.color!.withOpacity(0.8),
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    );
                  },
                ).animate(target: _isVisible ? 1 : 0)
                 .fadeIn(duration: 600.ms, delay: 600.ms),
                
                const SizedBox(height: 12),
                
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Built with ',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.textTheme.bodySmall!.color!.withOpacity(0.7),
                      ),
                    ),
                    AnimatedBuilder(
                      animation: _pulseController,
                      builder: (context, child) {
                        return Transform.scale(
                          scale: 1.0 + (_pulseController.value * 0.3),
                          child: const Text('💙'),
                        );
                      },
                    ),
                    Text(
                      ' Flutter',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.textTheme.bodySmall!.color!.withOpacity(0.7),
                      ),
                    ),
                  ],
                ).animate(target: _isVisible ? 1 : 0)
                 .fadeIn(duration: 600.ms, delay: 700.ms),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTechIcon(BuildContext context, String emoji, String label) {
    final theme = Theme.of(context);
    
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: AnimatedBuilder(
        animation: _floatController,
        builder: (context, child) {
          return Transform.translate(
            offset: Offset(
              0,
              math.sin(_floatController.value * math.pi * 2 + emoji.hashCode) * 5,
            ),
            child: Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: theme.colorScheme.primary.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: theme.colorScheme.primary.withOpacity(0.3),
                  width: 1,
                ),
                boxShadow: [
                  BoxShadow(
                    color: theme.colorScheme.primary.withOpacity(0.2),
                    blurRadius: 10,
                    spreadRadius: 2,
                  ),
                ],
              ),
              child: Column(
                children: [
                  Text(
                    emoji,
                    style: const TextStyle(fontSize: 24),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    label,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.primary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ).animate(
        onPlay: (controller) => controller.repeat(reverse: true),
      ).shimmer(
        duration: 2000.ms,
        color: theme.colorScheme.primary.withOpacity(0.3),
      ),
    ).animate(target: _isVisible ? 1 : 0)
     .fadeIn(duration: 600.ms, delay: Duration(milliseconds: 500 + emoji.hashCode % 300))
     .scale(begin: const Offset(0, 0));
  }
}

class _WavePainter extends CustomPainter {
  final Color color;
  final double animation;

  _WavePainter({
    required this.color,
    required this.animation,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    final path = Path();
    path.moveTo(0, size.height / 2);

    for (double i = 0; i < size.width; i++) {
      path.lineTo(
        i,
        size.height / 2 +
            math.sin((i / size.width * 4 * math.pi) + (animation * math.pi * 2)) * 20,
      );
    }

    path.lineTo(size.width, size.height);
    path.lineTo(0, size.height);
    path.close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
