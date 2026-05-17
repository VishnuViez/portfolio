import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:visibility_detector/visibility_detector.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../../data/portfolio_data.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../widgets/animations/card_3d.dart';

class ProjectsSection extends StatefulWidget {
  const ProjectsSection({super.key});

  @override
  State<ProjectsSection> createState() => _ProjectsSectionState();
}

class _ProjectsSectionState extends State<ProjectsSection> {
  bool _isVisible = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final size = MediaQuery.of(context).size;
    final isMobile = size.width < 768;

    return VisibilityDetector(
      key: const Key('projects-section'),
      onVisibilityChanged: (info) {
        if (info.visibleFraction > 0.05 && !_isVisible) {
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
                  "Featured Projects",
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
            
            // Projects Grid
            LayoutBuilder(
              builder: (context, constraints) {
                int crossAxisCount = 1;
                if (constraints.maxWidth > 1200) {
                  crossAxisCount = 2;
                } else if (constraints.maxWidth > 768) {
                  crossAxisCount = 2;
                }
                
                return GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: crossAxisCount,
                    crossAxisSpacing: 24,
                    mainAxisSpacing: 24,
                    childAspectRatio: isMobile ? 0.85 : 1.2,
                  ),
                  itemCount: PortfolioData.projects.length,
                  itemBuilder: (context, index) {
                    return _ProjectCard(
                      project: PortfolioData.projects[index],
                      delay: index * 200,
                      isVisible: _isVisible,
                    );
                  },
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

class _ProjectCard extends StatefulWidget {
  final dynamic project;
  final int delay;
  final bool isVisible;

  const _ProjectCard({
    required this.project,
    required this.delay,
    required this.isVisible,
  });

  @override
  State<_ProjectCard> createState() => _ProjectCardState();
}

class _ProjectCardState extends State<_ProjectCard> {
  Future<void> _launchUrl(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    // Different gradient combinations for each card
    final gradients = [
      [const Color(0xFF667eea), const Color(0xFF764ba2)], // Purple-Blue
      [const Color(0xFFf093fb), const Color(0xFFF5576c)], // Pink-Red
      [const Color(0xFF4facfe), const Color(0xFF00f2fe)], // Blue-Cyan
      [const Color(0xFF43e97b), const Color(0xFF38f9d7)], // Green-Teal
      [const Color(0xFFfa709a), const Color(0xFFfee140)], // Pink-Yellow
    ];
    
    final cardIndex = widget.delay ~/ 200;
    final gradientColors = gradients[cardIndex % gradients.length];
    
    return Card3D(
      maxRotation: 0.05,
      enableParallax: true,
      child: Card(
        elevation: 0,
        clipBehavior: Clip.antiAlias,
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                gradientColors[0].withOpacity(0.1),
                gradientColors[1].withOpacity(0.05),
              ],
            ),
          ),
          child: Stack(
            children: [
              // Decorative circle
              Positioned(
                top: -50,
                right: -50,
                child: Container(
                  width: 150,
                  height: 150,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: LinearGradient(
                      colors: [
                        gradientColors[0].withOpacity(0.2),
                        gradientColors[1].withOpacity(0.1),
                      ],
                    ),
                  ),
                ),
              ),
              // Content
              Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Project Icon & Title
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: gradientColors,
                            ),
                            borderRadius: BorderRadius.circular(12),
                            boxShadow: [
                              BoxShadow(
                                color: gradientColors[0].withOpacity(0.4),
                                blurRadius: 12,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: const Icon(
                            Icons.code,
                            color: Colors.white,
                            size: 24,
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: GlitchText(
                            text: widget.project.title,
                            style: theme.textTheme.titleLarge,
                          ),
                        ),
                      ],
                    ),
              
              const SizedBox(height: 16),
              
              // Description
              Text(
                widget.project.description,
                style: theme.textTheme.bodyMedium,
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
              ),
              
              const SizedBox(height: 16),
              
              // Highlights
              if (widget.project.highlights.isNotEmpty) ...[
                ...widget.project.highlights.take(2).map((highlight) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Icon(
                          Icons.check_circle,
                          size: 16,
                          color: theme.colorScheme.primary,
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            highlight,
                            style: theme.textTheme.bodySmall,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  );
                }),
                const SizedBox(height: 8),
              ],
              
              const Spacer(),
              
              // Technologies
              Flexible(
                child: Wrap(
                spacing: 8,
                runSpacing: 8,
                children: widget.project.technologies.map<Widget>((tech) {
                  return Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          gradientColors[0].withOpacity(0.15),
                          gradientColors[1].withOpacity(0.15),
                        ],
                      ),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: gradientColors[0].withOpacity(0.4),
                      ),
                    ),
                    child: Text(
                      tech,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: gradientColors[0],
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  );
                }).toList(),
                ),
              ),
              
              const SizedBox(height: 16),
              
              // Action Buttons
              Row(
                children: [
                  if (widget.project.githubUrl != null)
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: () => _launchUrl(widget.project.githubUrl!),
                        icon: const FaIcon(FontAwesomeIcons.github, size: 16),
                        label: const Text('Code'),
                        style: OutlinedButton.styleFrom(
                          side: BorderSide(color: gradientColors[0], width: 2),
                          foregroundColor: gradientColors[0],
                        ),
                      ),
                    ),
                  if (widget.project.githubUrl != null && 
                      widget.project.liveUrl != null)
                    const SizedBox(width: 12),
                  if (widget.project.liveUrl != null)
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: () => _launchUrl(widget.project.liveUrl!),
                        icon: const Icon(Icons.open_in_new, size: 16),
                        label: const Text('Live'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: gradientColors[0],
                          foregroundColor: Colors.white,
                        ),
                      ),
                    ),
                ],
              ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    ).animate(target: widget.isVisible ? 1 : 0)
     .fadeIn(duration: 600.ms, delay: widget.delay.ms)
     .slideY(begin: 0.2, end: 0)
     .then()
     .shimmer(
       duration: 1500.ms,
       delay: (widget.delay + 600).ms,
       color: gradientColors[0].withOpacity(0.3),
     );
  }
}
