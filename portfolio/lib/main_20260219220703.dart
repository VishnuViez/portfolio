import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/theme_provider.dart';
import 'theme/app_theme.dart';
import 'sections/hero/hero_section.dart';
import 'sections/about/about_section.dart';
import 'sections/skills/skills_section.dart';
import 'sections/projects/projects_section.dart';
import 'sections/experience/experience_section.dart';
import 'sections/contact/contact_section.dart';
import 'widgets/navigation/navigation_bar.dart' as custom_nav;
import 'widgets/footer/footer_section.dart';
import 'widgets/chatbot/chatbot_widget.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (_) => ThemeProvider(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeProvider>(
      builder: (context, themeProvider, child) {
        return MaterialApp(
          title: 'Vishnu - Mobile App Developer',
          debugShowCheckedModeBanner: false,
          theme: AppTheme.lightTheme,
          darkTheme: AppTheme.darkTheme,
          themeMode: themeProvider.isDarkMode ? ThemeMode.dark : ThemeMode.light,
          home: const HomePage(),
        );
      },
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final ScrollController _scrollController = ScrollController();
  final List<GlobalKey> _sectionKeys = List.generate(5, (_) => GlobalKey());

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollToSection(int index) {
    final context = _sectionKeys[index].currentContext;
    if (context != null) {
      Scrollable.ensureVisible(
        context,
        duration: const Duration(milliseconds: 800),
        curve: Curves.easeInOut,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Main Content
          CustomScrollView(
            controller: _scrollController,
            slivers: [
              // Navigation Bar
              SliverAppBar(
                pinned: true,
                elevation: 0,
                backgroundColor: Colors.transparent,
                toolbarHeight: 80,
                flexibleSpace: custom_nav.NavigationBar(
                  onNavigate: _scrollToSection,
                ),
              ),

              // Sections
              SliverList(
                delegate: SliverChildListDelegate([
                  // Hero Section
                  Container(
                    key: _sectionKeys[0],
                    child: const HeroSection(),
                  ),

                  // About Section
                  Container(
                    key: _sectionKeys[1],
                    child: const AboutSection(),
                  ),

                  // Skills Section
                  Container(
                    key: _sectionKeys[2],
                    child: const SkillsSection(),
                  ),

                  // Projects Section
                  Container(
                    key: _sectionKeys[3],
                    child: const ProjectsSection(),
                  ),

                  // Experience Section
                  // Container(
                  //   key: _sectionKeys[4],
                  //   child: const ExperienceSection(),
                  // ),

                  // Contact Section
                  Container(
                    key: _sectionKeys[4],
                    child: const ContactSection(),
                  ),

                  // Footer
                  const FooterSection(),
                ]),
              ),
            ],
          ),

          // Chatbot Widget
          const ChatbotWidget(),
        ],
      ),
    );
  }
}
