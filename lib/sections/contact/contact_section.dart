import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:visibility_detector/visibility_detector.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../../data/portfolio_data.dart';
import 'package:url_launcher/url_launcher.dart';

class ContactSection extends StatefulWidget {
  const ContactSection({super.key});

  @override
  State<ContactSection> createState() => _ContactSectionState();
}

class _ContactSectionState extends State<ContactSection> {
  bool _isVisible = false;
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _messageController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _messageController.dispose();
    super.dispose();
  }

  Future<void> _launchUrl(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    }
  }

  void _sendMessage() {
    if (_formKey.currentState!.validate()) {
      // Here you would typically send the form data to a backend
      // For now, we'll just show a success message
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Message sent successfully!'),
          backgroundColor: Colors.green,
        ),
      );
      
      _nameController.clear();
      _emailController.clear();
      _messageController.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final size = MediaQuery.of(context).size;
    final isMobile = size.width < 768;

    return VisibilityDetector(
      key: const Key('contact-section'),
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
                  "Get In Touch",
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
            
            // Contact Content
            if (isMobile) ...[
              _buildContactInfo(context, isMobile),
              const SizedBox(height: 40),
              _buildContactForm(context, isMobile),
            ] else ...[
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    flex: 2,
                    child: _buildContactInfo(context, isMobile),
                  ),
                  const SizedBox(width: 60),
                  Expanded(
                    flex: 3,
                    child: _buildContactForm(context, isMobile),
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildContactInfo(BuildContext context, bool isMobile) {
    final theme = Theme.of(context);
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Let's work together!",
          style: theme.textTheme.headlineMedium,
        ).animate(target: _isVisible ? 1 : 0)
         .fadeIn(duration: 600.ms, delay: 200.ms)
         .slideY(begin: 0.2, end: 0),
        
        const SizedBox(height: 16),
        
        Text(
          "I'm always interested in hearing about new projects and opportunities.",
          style: theme.textTheme.bodyLarge,
        ).animate(target: _isVisible ? 1 : 0)
         .fadeIn(duration: 600.ms, delay: 300.ms)
         .slideY(begin: 0.2, end: 0),
        
        const SizedBox(height: 32),
        
        // Contact Methods
        _ContactMethod(
          icon: Icons.email,
          label: 'Email',
          value: PortfolioData.email,
          onTap: () => _launchUrl('mailto:${PortfolioData.email}'),
          delay: 400,
          isVisible: _isVisible,
        ),
        
        const SizedBox(height: 16),
        
        _ContactMethod(
          icon: FontAwesomeIcons.github,
          label: 'GitHub',
          value: 'github.com/VishnuViez',
          onTap: () => _launchUrl(PortfolioData.github),
          delay: 500,
          isVisible: _isVisible,
        ),
        
        const SizedBox(height: 16),
        
        _ContactMethod(
          icon: FontAwesomeIcons.linkedin,
          label: 'LinkedIn',
          value: 'linkedin.com/in/vishnuviez',
          onTap: () => _launchUrl(PortfolioData.linkedin),
          delay: 600,
          isVisible: _isVisible,
        ),
      ],
    );
  }

  Widget _buildContactForm(BuildContext context, bool isMobile) {
    final theme = Theme.of(context);
    
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextFormField(
                controller: _nameController,
                decoration: InputDecoration(
                  labelText: 'Name',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  prefixIcon: const Icon(Icons.person),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your name';
                  }
                  return null;
                },
              ).animate(target: _isVisible ? 1 : 0)
               .fadeIn(duration: 600.ms, delay: 400.ms)
               .slideY(begin: 0.2, end: 0),
              
              const SizedBox(height: 24),
              
              TextFormField(
                controller: _emailController,
                decoration: InputDecoration(
                  labelText: 'Email',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  prefixIcon: const Icon(Icons.email),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your email';
                  }
                  if (!value.contains('@')) {
                    return 'Please enter a valid email';
                  }
                  return null;
                },
              ).animate(target: _isVisible ? 1 : 0)
               .fadeIn(duration: 600.ms, delay: 500.ms)
               .slideY(begin: 0.2, end: 0),
              
              const SizedBox(height: 24),
              
              TextFormField(
                controller: _messageController,
                maxLines: 6,
                decoration: InputDecoration(
                  labelText: 'Message',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  alignLabelWithHint: true,
                  prefixIcon: const Padding(
                    padding: EdgeInsets.only(bottom: 100),
                    child: Icon(Icons.message),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a message';
                  }
                  return null;
                },
              ).animate(target: _isVisible ? 1 : 0)
               .fadeIn(duration: 600.ms, delay: 600.ms)
               .slideY(begin: 0.2, end: 0),
              
              const SizedBox(height: 32),
              
              ElevatedButton.icon(
                onPressed: _sendMessage,
                icon: const Icon(Icons.send),
                label: const Text('Send Message'),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 20),
                ),
              ).animate(target: _isVisible ? 1 : 0)
               .fadeIn(duration: 600.ms, delay: 700.ms)
               .slideY(begin: 0.2, end: 0),
            ],
          ),
        ),
      ),
    );
  }
}

class _ContactMethod extends StatefulWidget {
  final IconData icon;
  final String label;
  final String value;
  final VoidCallback onTap;
  final int delay;
  final bool isVisible;

  const _ContactMethod({
    required this.icon,
    required this.label,
    required this.value,
    required this.onTap,
    required this.delay,
    required this.isVisible,
  });

  @override
  State<_ContactMethod> createState() => _ContactMethodState();
}

class _ContactMethodState extends State<_ContactMethod> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: widget.onTap,
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: _isHovered 
              ? theme.colorScheme.primary.withOpacity(0.1) 
              : theme.colorScheme.surface,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: theme.colorScheme.primary.withOpacity(0.3),
            ),
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: theme.colorScheme.primary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(
                  widget.icon,
                  color: theme.colorScheme.primary,
                  size: 20,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.label,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.textTheme.bodySmall!.color!.withOpacity(0.7),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      widget.value,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
              Icon(
                Icons.arrow_forward,
                color: theme.colorScheme.primary,
                size: 20,
              ),
            ],
          ),
        ).animate(target: widget.isVisible ? 1 : 0)
         .fadeIn(duration: 600.ms, delay: widget.delay.ms)
         .slideX(begin: -0.2, end: 0),
      ),
    );
  }
}
