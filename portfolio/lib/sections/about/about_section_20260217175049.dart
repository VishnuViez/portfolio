import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:visibility_detector/visibility_detector.dart';
import '../../data/portfolio_data.dart';

class AboutSection extends StatefulWidget {
  const AboutSection({super.key});

  @override
  State<AboutSection> createState() => _AboutSectionState();
}

class _AboutSectionState extends State<AboutSection> {
  bool _isVisible = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final size = MediaQuery.of(context).size;
    final isMobile = size.width < 768;

    return VisibilityDetector(
      key: const Key('about-section'),
      onVisibilityChanged: (info) {
        if (info.visibleFraction > 0.3 && !_isVisible) {
          setState(() => _isVisible = true);
        }
      },
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: isMobile ? 24 : 80,
          vertical: isMobile ? 60 : 100,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Section Title
            Row(
              children: [
                Text(
                  "About Me",
                  style: isMobile 
                    ? theme.textTheme.displaySmall 
                    : theme.textTheme.displayMedium,
                ),
                const SizedBox(width: 24),
                Expanded(
                  child: Container(
                    height: 2,
                    color: theme.colorScheme.primary.withOpacity(0.3),
                  ),
                ),
              ],
            ).animate(target: _isVisible ? 1 : 0)
             .fadeIn(duration: 600.ms)
             .slideX(begin: -0.2, end: 0),
            
            SizedBox(height: isMobile ? 40 : 60),
            
            // Content
            if (isMobile) ...[
              _buildContent(context, isMobile),
            ] else ...[
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    flex: 3,
                    child: _buildContent(context, isMobile),
                  ),
                  const SizedBox(width: 60),
                  Expanded(
                    flex: 2,
                    child: _buildStats(context),
                  ),
                ],
              ),
            ],
            
            if (isMobile) ...[
              const SizedBox(height: 40),
              _buildStats(context),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildContent(BuildContext context, bool isMobile) {
    final theme = Theme.of(context);
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          PortfolioData.bio,
          style: theme.textTheme.bodyLarge,
        ).animate(target: _isVisible ? 1 : 0)
         .fadeIn(duration: 600.ms, delay: 200.ms)
         .slideY(begin: 0.2, end: 0),
        
        const SizedBox(height: 32),
        
        Text(
          "What I Bring to the Table:",
          style: theme.textTheme.titleLarge,
        ).animate(target: _isVisible ? 1 : 0)
         .fadeIn(duration: 600.ms, delay: 400.ms),
        
        const SizedBox(height: 24),
        
        ..._buildHighlights(context).asMap().entries.map((entry) {
          return Padding(
            padding: const EdgeInsets.only(bottom: 16),
            child: entry.value,
          ).animate(target: _isVisible ? 1 : 0)
           .fadeIn(duration: 600.ms, delay: (600 + entry.key * 100).ms)
           .slideX(begin: -0.1, end: 0);
        }),
      ],
    );
  }

  List<Widget> _buildHighlights(BuildContext context) {
    final theme = Theme.of(context);
    
    final highlights = [
      "🚀 5+ years of mobile development experience",
      "💡 Expert in native Android and cross-platform development",
      "🏗️ Strong understanding of architecture patterns and best practices",
      "🔧 Proficient in integrating REST APIs, third-party SDKs, and services",
      "🤖 Experience with Machine Learning and AI integration",
      "📱 Published multiple apps on Google Play Store",
    ];

    return highlights.map((highlight) {
      return Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: const EdgeInsets.only(top: 4),
            width: 6,
            height: 6,
            decoration: BoxDecoration(
              color: theme.colorScheme.primary,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Text(
              highlight,
              style: theme.textTheme.bodyMedium,
            ),
          ),
        ],
      );
    }).toList();
  }

  Widget _buildStats(BuildContext context) {
    final theme = Theme.of(context);
    
    final stats = [
      {"number": "50+", "label": "Projects Completed"},
      {"number": "5+", "label": "Years Experience"},
      {"number": "15+", "label": "Technologies"},
      {"number": "100%", "label": "Client Satisfaction"},
    ];

    return Wrap(
      spacing: 24,
      runSpacing: 24,
      children: stats.asMap().entries.map((entry) {
        return Container(
          width: 140,
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: theme.colorScheme.surface,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: theme.colorScheme.primary.withOpacity(0.2),
            ),
          ),
          child: Column(
            children: [
              Text(
                entry.value["number"]!,
                style: theme.textTheme.displaySmall?.copyWith(
                  color: theme.colorScheme.primary,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                entry.value["label"]!,
                style: theme.textTheme.bodyMedium,
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ).animate(target: _isVisible ? 1 : 0)
         .fadeIn(duration: 600.ms, delay: (400 + entry.key * 100).ms)
         .scale(begin: const Offset(0.8, 0.8), end: const Offset(1, 1));
      }).toList(),
    );
  }
}
