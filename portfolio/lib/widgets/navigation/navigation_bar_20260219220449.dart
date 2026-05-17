import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:provider/provider.dart';
import '../../providers/theme_provider.dart';

class NavigationBar extends StatefulWidget {
  final Function(int) onNavigate;

  const NavigationBar({super.key, required this.onNavigate});

  @override
  State<NavigationBar> createState() => _NavigationBarState();
}

class _NavigationBarState extends State<NavigationBar> {
  int _selectedIndex = 0;
  bool _isScrolled = false;

  final List<String> _navItems = [
    'Home',
    'About',
    'Skills',
    'Projects',
    'Contact',
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final themeProvider = Provider.of<ThemeProvider>(context);
    final size = MediaQuery.of(context).size;
    final isMobile = size.width < 768;

    return Container(
      height: 80,
      padding: EdgeInsets.symmetric(horizontal: isMobile ? 24 : 80),
      decoration: BoxDecoration(
        color: _isScrolled
            ? theme.scaffoldBackgroundColor.withOpacity(0.95)
            : Colors.transparent,
        border: _isScrolled
            ? Border(
                bottom: BorderSide(
                  color: theme.colorScheme.primary.withOpacity(0.1),
                ),
              )
            : null,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Logo
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  theme.colorScheme.primary,
                  theme.colorScheme.secondary,
                ],
              ),
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Icon(
              Icons.code,
              color: Colors.white,
              size: 24,
            ),
          ).animate()
           .fadeIn(duration: 600.ms)
           .slideX(begin: -0.2, end: 0),

          // Navigation Items (Desktop)
          if (!isMobile) ...[
            Row(
              children: _navItems.asMap().entries.map((entry) {
                return Padding(
                  padding: const EdgeInsets.only(left: 32),
                  child: _NavItem(
                    title: entry.value,
                    isSelected: _selectedIndex == entry.key,
                    onTap: () {
                      setState(() => _selectedIndex = entry.key);
                      widget.onNavigate(entry.key);
                    },
                    delay: entry.key * 100,
                  ),
                );
              }).toList(),
            ),
          ],

          // Theme Toggle
          Row(
            children: [
              IconButton(
                onPressed: () => themeProvider.toggleTheme(),
                icon: Icon(
                  themeProvider.isDarkMode ? Icons.light_mode : Icons.dark_mode,
                ),
                tooltip: 'Toggle Theme',
              ).animate()
               .fadeIn(duration: 600.ms, delay: 800.ms)
               .scale(begin: const Offset(0, 0), end: const Offset(1, 1)),

              // Mobile Menu Button
              if (isMobile) ...[
                const SizedBox(width: 8),
                IconButton(
                  onPressed: () {
                    _showMobileMenu(context);
                  },
                  icon: const Icon(Icons.menu),
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }

  void _showMobileMenu(BuildContext context) {
    final theme = Theme.of(context);
    
    showModalBottomSheet(
      context: context,
      backgroundColor: theme.scaffoldBackgroundColor,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: _navItems.asMap().entries.map((entry) {
              return ListTile(
                title: Text(
                  entry.value,
                  style: theme.textTheme.bodyLarge?.copyWith(
                    color: _selectedIndex == entry.key
                        ? theme.colorScheme.primary
                        : null,
                    fontWeight: _selectedIndex == entry.key
                        ? FontWeight.bold
                        : null,
                  ),
                ),
                onTap: () {
                  setState(() => _selectedIndex = entry.key);
                  widget.onNavigate(entry.key);
                  Navigator.pop(context);
                },
              );
            }).toList(),
          ),
        );
      },
    );
  }
}

class _NavItem extends StatefulWidget {
  final String title;
  final bool isSelected;
  final VoidCallback onTap;
  final int delay;

  const _NavItem({
    required this.title,
    required this.isSelected,
    required this.onTap,
    required this.delay,
  });

  @override
  State<_NavItem> createState() => _NavItemState();
}

class _NavItemState extends State<_NavItem> {
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
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              widget.title,
              style: theme.textTheme.bodyLarge?.copyWith(
                color: widget.isSelected || _isHovered
                    ? theme.colorScheme.primary
                    : theme.textTheme.bodyLarge!.color,
                fontWeight:
                    widget.isSelected ? FontWeight.bold : FontWeight.w500,
              ),
            ),
            const SizedBox(height: 4),
            Container(
              height: 2,
              width: 40,
              decoration: BoxDecoration(
                color: widget.isSelected
                    ? theme.colorScheme.primary
                    : Colors.transparent,
                borderRadius: BorderRadius.circular(2),
              ),
            ).animate(
              target: widget.isSelected || _isHovered ? 1 : 0,
            ).scaleX(
              begin: 0,
              end: 1,
              duration: 200.ms,
              alignment: Alignment.center,
            ),
          ],
        ),
      ).animate()
       .fadeIn(duration: 600.ms, delay: widget.delay.ms)
       .slideY(begin: -0.2, end: 0),
    );
  }
}
