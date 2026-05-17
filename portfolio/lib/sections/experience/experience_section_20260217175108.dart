import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:visibility_detector/visibility_detector.dart';
import '../../data/portfolio_data.dart';

class ExperienceSection extends StatefulWidget {
  const ExperienceSection({super.key});

  @override
  State<ExperienceSection> createState() => _ExperienceSectionState();
}

class _ExperienceSectionState extends State<ExperienceSection> {
  bool _isVisible = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final size = MediaQuery.of(context).size;
    final isMobile = size.width < 768;

    return VisibilityDetector(
      key: const Key('experience-section'),
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
                  "Experience",
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
            
            // Experience Timeline
            ...PortfolioData.experience.asMap().entries.map((entry) {
              return _ExperienceCard(
                experience: entry.value,
                delay: entry.key * 200,
                isVisible: _isVisible,
                isLast: entry.key == PortfolioData.experience.length - 1,
              );
            }),
          ],
        ),
      ),
    );
  }
}

class _ExperienceCard extends StatelessWidget {
  final Map<String, dynamic> experience;
  final int delay;
  final bool isVisible;
  final bool isLast;

  const _ExperienceCard({
    required this.experience,
    required this.delay,
    required this.isVisible,
    required this.isLast,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Timeline Indicator
        Column(
          children: [
            Container(
              width: 16,
              height: 16,
              decoration: BoxDecoration(
                color: theme.colorScheme.primary,
                shape: BoxShape.circle,
                border: Border.all(
                  color: theme.colorScheme.surface,
                  width: 3,
                ),
              ),
            ),
            if (!isLast)
              Container(
                width: 2,
                height: 200,
                margin: const EdgeInsets.symmetric(vertical: 4),
                color: theme.colorScheme.primary.withOpacity(0.3),
              ),
          ],
        ).animate(target: isVisible ? 1 : 0)
         .fadeIn(duration: 600.ms, delay: delay.ms)
         .scale(begin: const Offset(0, 0), end: const Offset(1, 1)),
        
        const SizedBox(width: 24),
        
        // Content
        Expanded(
          child: Card(
            margin: EdgeInsets.only(bottom: isLast ? 0 : 32),
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Position & Duration
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          experience["position"],
                          style: theme.textTheme.titleLarge,
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: theme.colorScheme.primary.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          experience["duration"],
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: theme.colorScheme.primary,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                  
                  const SizedBox(height: 8),
                  
                  // Company
                  Text(
                    experience["company"],
                    style: theme.textTheme.bodyLarge?.copyWith(
                      color: theme.colorScheme.primary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  
                  const SizedBox(height: 16),
                  
                  // Description
                  Text(
                    experience["description"],
                    style: theme.textTheme.bodyMedium,
                  ),
                  
                  const SizedBox(height: 16),
                  
                  // Achievements
                  ...experience["achievements"].map<Widget>((achievement) {
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Icon(
                            Icons.star,
                            size: 16,
                            color: theme.colorScheme.secondary,
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              achievement,
                              style: theme.textTheme.bodySmall,
                            ),
                          ),
                        ],
                      ),
                    );
                  }).toList(),
                ],
              ),
            ),
          ).animate(target: isVisible ? 1 : 0)
           .fadeIn(duration: 600.ms, delay: (delay + 200).ms)
           .slideX(begin: 0.2, end: 0),
        ),
      ],
    );
  }
}
