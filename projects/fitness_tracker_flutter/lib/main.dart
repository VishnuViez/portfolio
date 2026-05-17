import 'package:flutter/material.dart';
import 'theme/fit_theme.dart';
import 'screens/dashboard_screen.dart';
import 'screens/workout_screen.dart';
import 'screens/history_screen.dart';
import 'screens/profile_screen.dart';

void main() {
  runApp(const FitAIApp());
}

class FitAIApp extends StatelessWidget {
  const FitAIApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'FitAI - Fitness Tracker',
      debugShowCheckedModeBanner: false,
      theme: FitTheme.darkTheme,
      home: const MainShell(),
    );
  }
}

class MainShell extends StatefulWidget {
  const MainShell({super.key});

  @override
  State<MainShell> createState() => _MainShellState();
}

class _MainShellState extends State<MainShell> {
  int _index = 0;

  static const _screens = <Widget>[
    DashboardScreen(),
    WorkoutScreen(),
    HistoryScreen(),
    ProfileScreen(),
  ];

  static const _labels = ['Dashboard', 'Workout', 'History', 'Profile'];
  static const _icons = [
    Icons.dashboard_rounded,
    Icons.fitness_center_rounded,
    Icons.history_rounded,
    Icons.person_rounded,
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: ShaderMask(
          shaderCallback: (bounds) => FitTheme.gradient.createShader(bounds),
          child: const Text('🏋️ FitAI', style: TextStyle(fontWeight: FontWeight.w700, color: Colors.white)),
        ),
        actions: [
          Container(
            margin: const EdgeInsets.only(right: 8),
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: FitTheme.surface2,
              borderRadius: BorderRadius.circular(15),
            ),
            child: const Text('🔥 12 day streak', style: TextStyle(fontSize: 12, color: FitTheme.warning)),
          ),
          const Padding(
            padding: EdgeInsets.only(right: 12),
            child: CircleAvatar(
              radius: 16,
              backgroundColor: FitTheme.primary,
              child: Text('V', style: TextStyle(color: FitTheme.bg, fontWeight: FontWeight.w700, fontSize: 14)),
            ),
          ),
        ],
      ),
      body: _screens[_index],
      bottomNavigationBar: NavigatrionBar(
        selectedIndex: _index,
        onDestinationSelected: (i) => setState(() => _index = i),
        destinations: List.generate(4, (i) => NavigationDestination(
          icon: Icon(_icons[i]),
          label: _labels[i],
        )),
      ),
    );
  }
}
