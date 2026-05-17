import 'package:flutter/material.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../../data/portfolio_data.dart';
import 'package:url_launcher/url_launcher.dart';
import 'dart:math' as math;

class HeroSection extends StatefulWidget {
  const HeroSection({super.key});

  @override
  State<HeroSection> createState() => _HeroSectionState();
}

class _HeroSectionState extends State<HeroSection> {
  bool _isHovered = false;

  Future<void> _launchUrl(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final size = MediaQuery.of(context).size;
    final isMobile = size.width < 768;

    return Container(
      constraints: BoxConstraints(minHeight: size.height - 80),
      padding: EdgeInsets.symmetric(
        horizontal: isMobile ? 24 : 80,
        vertical: isMobile ? 60 : 100,
      ),
      child: isMobile 
        ? Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Profile Picture with Tech Badges (Mobile)
              Center(child: _buildProfileSection(context, theme)),
              const SizedBox(height: 40),
              _buildContentSection(context, theme, isMobile),
            ],
          )
        : Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Content Section (Desktop)
              Expanded(
                flex: 3,
                child: _buildContentSection(context, theme, isMobile),
              ),
              const SizedBox(width: 60),
              // Profile Picture with Tech Badges (Desktop)
              Expanded(
                flex: 2,
                child: _buildProfileSection(context, theme),
              ),
            ],
          ),
    );
  }

  Widget _buildProfileSection(BuildContext context, ThemeData theme) {
    return Stack(
      alignment: Alignment.center,
      children: [
        // Decorative circles
        Container(
          width: 350,
          height: 350,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(
              color: theme.colorScheme.primary.withOpacity(0.2),
              width: 2,
            ),
          ),
        ).animate(
          onPlay: (controller) => controller.repeat(reverse: true),
        ).scale(
          duration: 3000.ms,
          begin: const Offset(1, 1),
          end: const Offset(1.1, 1.1),
        ),
        
        // Profile picture
        Container(
          width: 250,
          height: 250,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: LinearGradient(
              colors: [
                theme.colorScheme.primary,
                theme.colorScheme.secondary,
              ],
            ),
            boxShadow: [
              BoxShadow(
                color: theme.colorScheme.primary.withOpacity(0.4),
                blurRadius: 30,
                spreadRadius: 5,
              ),
            ],
          ),
          padding: const EdgeInsets.all(8),
          child: Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: theme.scaffoldBackgroundColor,
            ),
            padding: const EdgeInsets.all(8),
            child: ClipOval(
              child: Image.asset(
                'assets/images/profile.jpg',
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    color: theme.colorScheme.surface,
                    child: Icon(
                      Icons.person,
                      size: 100,
                      color: theme.colorScheme.primary,
                    ),
                  );
                },
              ),
            ),
          ),
        ).animate()
         .fadeIn(duration: 800.ms, delay: 200.ms)
         .scale(begin: const Offset(0.8, 0.8), end: const Offset(1, 1)),
        
        // Floating Tech Badges
        _FloatingBadge(
          label: 'Flutter',
          color: const Color(0xFF02569B),
          angle: -30,
          distance: 180,
          delay: 400,
        ),
        _FloatingBadge(
          label: 'Kotlin',
          color: const Color(0xFF7F52FF),
          angle: 30,
          distance: 180,
          delay: 500,
        ),
        _FloatingBadge(
          label: 'Python',
          color: const Color(0xFF3776AB),
          angle: 90,
          distance: 180,
          delay: 600,
        ),
        _FloatingBadge(
          label: 'AI/ML',
          color: const Color(0xFF8E24AA),
          angle: 150,
          distance: 180,
          delay: 700,
        ),
        _FloatingBadge(
          label: 'AWS',
          color: const Color(0xFFFF9900),
          angle: 210,
          distance: 180,
          delay: 800,
        ),
        _FloatingBadge(
          label: 'Docker',
          color: const Color(0xFF2496ED),
          angle: 270,
          distance: 180,
          delay: 900,
        ),
      ],
    );
  }

  Widget _buildContentSection(BuildContext context, ThemeData theme, bool isMobile) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
          // Greeting
          Text(
            "Hi, I'm",
            style: theme.textTheme.titleLarge?.copyWith(
              color: theme.colorScheme.primary,
              fontWeight: FontWeight.w500,
            ),
          ).animate().fadeIn(duration: 600.ms).slideX(begin: -0.2, end: 0),
          
          const SizedBox(height: 16),
          
          // Name
          Text(
            PortfolioData.name,
            style: isMobile 
              ? theme.textTheme.displayMedium 
              : theme.textTheme.displayLarge,
          ).animate()
           .fadeIn(duration: 600.ms, delay: 200.ms)
           .slideX(begin: -0.2, end: 0),
          
          const SizedBox(height: 24),
          
          // Animated Title
          SizedBox(
            height: isMobile ? 80 : 100,
            child: DefaultTextStyle(
              style: (isMobile 
                ? theme.textTheme.headlineMedium 
                : theme.textTheme.displaySmall)!.copyWith(
                color: theme.textTheme.bodyLarge!.color,
                fontWeight: FontWeight.w600,
              ),
              child: AnimatedTextKit(
                repeatForever: true,
                pause: const Duration(milliseconds: 2000),
                animatedTexts: [
                  TyperAnimatedText('Mobile App Developer'),
                  TyperAnimatedText('Android Expert'),
                  TyperAnimatedText('Flutter Developer'),
                  TyperAnimatedText('Backend Engineer'),
                  TyperAnimatedText('ML Enthusiast'),
                ],
              ),
            ),
          ).animate()
           .fadeIn(duration: 600.ms, delay: 400.ms),
          
          const SizedBox(height: 32),
          
          // Tagline
          Container(
            constraints: const BoxConstraints(maxWidth: 700),
            child: Text(
              PortfolioData.tagline,
              style: theme.textTheme.bodyLarge,
            ),
          ).animate()
           .fadeIn(duration: 600.ms, delay: 600.ms)
           .slideY(begin: 0.2, end: 0),
          
          const SizedBox(height: 48),
          
          // CTA Buttons
          Wrap(
            spacing: 16,
            runSpacing: 16,
            children: [
              MouseRegion(
                onEnter: (_) => setState(() => _isHovered = true),
                onExit: (_) => setState(() => _isHovered = false),
                child: ElevatedButton.icon(
                  onPressed: () {
                    // Scroll to projects section
                  },
                  icon: const Icon(Icons.rocket_launch),
                  label: const Text('View My Work'),
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(
                      horizontal: isMobile ? 24 : 32,
                      vertical: isMobile ? 16 : 20,
                    ),
                  ),
                ).animate(
                  target: _isHovered ? 1 : 0,
                ).scale(
                  end: const Offset(1.05, 1.05),
                  duration: 200.ms,
                ),
              ),
              OutlinedButton.icon(
                onPressed: () {
                  // Download resume or contact
                },
                icon: const Icon(Icons.download),
                label: const Text('Download Resume'),
                style: OutlinedButton.styleFrom(
                  padding: EdgeInsets.symmetric(
                    horizontal: isMobile ? 24 : 32,
                    vertical: isMobile ? 16 : 20,
                  ),
                  side: BorderSide(color: theme.colorScheme.primary, width: 2),
                ),
              ),
            ],
          ).animate()
           .fadeIn(duration: 600.ms, delay: 800.ms)
           .slideY(begin: 0.2, end: 0),
          
          const SizedBox(height: 48),
          
          // Social Links
          Row(
            children: [
              _SocialButton(
                icon: FontAwesomeIcons.github,
                url: PortfolioData.github,
                onTap: _launchUrl,
              ),
              const SizedBox(width: 16),
              _SocialButton(
                icon: FontAwesomeIcons.linkedin,
                url: PortfolioData.linkedin,
                onTap: _launchUrl,
              ),
              const SizedBox(width: 16),
              _SocialButton(
                icon: FontAwesomeIcons.envelope,
                url: 'mailto:${PortfolioData.email}',
                onTap: _launchUrl,
              ),
            ],
          ).animate()
           .fadeIn(duration: 600.ms, delay: 1000.ms)
           .slideY(begin: 0.2, end: 0),
        ],
      ),
    );
  }
}

class _SocialButton extends StatefulWidget {
  final IconData icon;
  final String url;
  final Function(String) onTap;

  const _SocialButton({
    required this.icon,
    required this.url,
    required this.onTap,
  });

  @override
  State<_SocialButton> createState() => _SocialButtonState();
}

class _SocialButtonState extends State<_SocialButton> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: GestureDetector(
        onTap: () => widget.onTap(widget.url),
        child: Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            color: _isHovered 
              ? theme.colorScheme.primary 
              : theme.colorScheme.surface,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: theme.colorScheme.primary,
              width: 2,
            ),
          ),
          child: Icon(
            widget.icon,
            size: 20,
            color: _isHovered 
              ? Colors.white 
              : theme.colorScheme.primary,
          ),
        ).animate(
          target: _isHovered ? 1 : 0,
        ).scale(
          end: const Offset(1.1, 1.1),
          duration: 200.ms,
        ),
      ),
    );
  }
}

class _FloatingBadge extends StatelessWidget {
  final String label;
  final Color color;
  final double angle;
  final double distance;
  final int delay;

  const _FloatingBadge({
    required this.label,
    required this.color,
    required this.angle,
    required this.distance,
    required this.delay,
  });

  @override
  Widget build(BuildContext context) {
    final radians = angle * 3.14159 / 180;
    final x = distance * cos(radians);
    final y = distance * sin(radians);

    return Transform.translate(
      offset: Offset(x, y),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: color.withOpacity(0.9),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: color, width: 2),
          boxShadow: [
            BoxShadow(
              color: color.withOpacity(0.4),
              blurRadius: 10,
              spreadRadius: 2,
            ),
          ],
        ),
        child: Text(
          label,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 14,
          ),
        ),
      ).animate(
        onPlay: (controller) => controller.repeat(reverse: true),
      ).moveY(
        duration: (2000 + delay).ms,
        begin: -5,
        end: 5,
        curve: Curves.easeInOut,
      ),
    ).animate()
     .fadeIn(duration: 600.ms, delay: delay.ms)
     .scale(begin: const Offset(0, 0), end: const Offset(1, 1));
  }
}

double cos(double radians) => radians.cos();
double sin(double radians) => radians.sin();
