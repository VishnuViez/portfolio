import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:provider/provider.dart';
import '../../providers/auth_provider.dart';
import '../../providers/workout_provider.dart';
import '../../theme/app_theme.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();
    final workout = context.watch<WorkoutProvider>();
    final user = auth.user;
    final stats = workout.getWeeklyStats();

    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            // Avatar & Name
            CircleAvatar(
              radius: 50,
              backgroundColor: AppTheme.primary,
              child: Text(
                (user?.name ?? 'A')[0].toUpperCase(),
                style: const TextStyle(fontSize: 36, fontWeight: FontWeight.bold, color: Colors.white),
              ),
            ).animate().scale(duration: 500.ms, curve: Curves.elasticOut),
            const SizedBox(height: 16),
            Text(user?.name ?? 'Athlete', style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold))
                .animate().fadeIn(delay: 200.ms),
            Text(user?.email ?? '', style: TextStyle(color: Colors.white.withValues(alpha: 0.6)))
                .animate().fadeIn(delay: 300.ms),
            const SizedBox(height: 32),

            // Stats Grid
            Row(
              children: [
                _ProfileStat(label: 'Workouts', value: '${user?.totalWorkouts ?? workout.sessions.length}'),
                _ProfileStat(label: 'Streak', value: '${user?.streakDays ?? 0} days'),
                _ProfileStat(label: 'This Week', value: '${stats.workoutsCompleted}'),
              ].animate(interval: 100.ms).fadeIn(duration: 400.ms).slideY(begin: 0.2),
            ),
            const SizedBox(height: 32),

            // Info Cards
            _InfoCard(title: 'Fitness Goal', value: user?.fitnessGoal ?? 'Not set', icon: Icons.flag),
            _InfoCard(title: 'Level', value: user?.fitnessLevel ?? 'Beginner', icon: Icons.trending_up),
            _InfoCard(
                title: 'Body Stats',
                value: '${user?.weight ?? 70} kg · ${user?.height ?? 175} cm · Age ${user?.age ?? 25}',
                icon: Icons.monitor_weight),
            _InfoCard(
                title: 'Daily Goal',
                value: '${user?.dailyCalorieGoal ?? 500} cal/day',
                icon: Icons.local_fire_department),
            _InfoCard(
                title: 'Weekly Target',
                value: '${user?.weeklyGoalDays ?? 5} days/week',
                icon: Icons.calendar_today),
            const SizedBox(height: 24),

            // Logout
            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed: () {
                  auth.logout();
                  Navigator.pushReplacementNamed(context, '/login');
                },
                icon: const Icon(Icons.logout),
                label: const Text('Logout'),
                style: OutlinedButton.styleFrom(
                  foregroundColor: AppTheme.secondary,
                  side: const BorderSide(color: AppTheme.secondary),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ProfileStat extends StatelessWidget {
  final String label;
  final String value;

  const _ProfileStat({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 4),
        padding: const EdgeInsets.symmetric(vertical: 20),
        decoration: BoxDecoration(
          color: AppTheme.surface,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          children: [
            Text(value, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: AppTheme.primary)),
            const SizedBox(height: 4),
            Text(label, style: TextStyle(fontSize: 12, color: Colors.white.withValues(alpha: 0.6))),
          ],
        ),
      ),
    );
  }
}

class _InfoCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;

  const _InfoCard({required this.title, required this.value, required this.icon});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.surface,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        children: [
          Icon(icon, color: AppTheme.primary),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: TextStyle(fontSize: 12, color: Colors.white.withValues(alpha: 0.5))),
                Text(value, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w500)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
