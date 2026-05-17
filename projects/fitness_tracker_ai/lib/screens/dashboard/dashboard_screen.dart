import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:provider/provider.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import '../../models/workout.dart';
import '../../providers/auth_provider.dart';
import '../../providers/workout_provider.dart';
import '../../providers/ai_provider.dart';
import '../../theme/app_theme.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

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
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Greeting
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Hey, ${user?.name ?? "Athlete"} 💪',
                          style: const TextStyle(fontSize: 26, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 4),
                      Text('${stats.workoutsCompleted} workouts this week',
                          style: TextStyle(color: Colors.white.withValues(alpha: 0.6), fontSize: 14)),
                    ],
                  ),
                ),
                CircularPercentIndicator(
                  radius: 32,
                  lineWidth: 5,
                  percent: (stats.workoutsCompleted / (user?.weeklyGoalDays ?? 5)).clamp(0.0, 1.0),
                  center: Text('${stats.workoutsCompleted}/${user?.weeklyGoalDays ?? 5}',
                      style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold)),
                  progressColor: AppTheme.primary,
                  backgroundColor: AppTheme.surface,
                ),
              ],
            ).animate().fadeIn(duration: 500.ms).slideX(begin: -0.1),
            const SizedBox(height: 24),

            // Quick Stats Row
            Row(
              children: [
                _StatCard(
                  icon: Icons.local_fire_department,
                  value: '${stats.totalCalories.round()}',
                  label: 'Calories',
                  color: AppTheme.secondary,
                ),
                const SizedBox(width: 12),
                _StatCard(
                  icon: Icons.timer,
                  value: '${stats.totalMinutes}',
                  label: 'Minutes',
                  color: AppTheme.accent,
                ),
                const SizedBox(width: 12),
                _StatCard(
                  icon: Icons.emoji_events,
                  value: '${user?.streakDays ?? 0}',
                  label: 'Day Streak',
                  color: const Color(0xFFF59E0B),
                ),
              ].animate(interval: 100.ms).fadeIn(duration: 400.ms).slideY(begin: 0.2),
            ),
            const SizedBox(height: 24),

            // AI Recommendation Card
            _AIRecommendationCard(
              sessions: workout.sessions,
              user: user,
            ).animate().fadeIn(delay: 300.ms, duration: 500.ms).slideY(begin: 0.1),
            const SizedBox(height: 24),

            // Weekly Chart
            const Text('Weekly Activity', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            Container(
              height: 200,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppTheme.surface,
                borderRadius: BorderRadius.circular(16),
              ),
              child: BarChart(
                BarChartData(
                  alignment: BarChartAlignment.spaceAround,
                  maxY: (stats.dailyCalories.reduce((a, b) => a > b ? a : b) * 1.3).clamp(100, 2000),
                  barGroups: List.generate(7, (i) {
                    return BarChartGroupData(x: i, barRods: [
                      BarChartRodData(
                        toY: stats.dailyCalories[i],
                        gradient: const LinearGradient(
                          colors: [AppTheme.primary, AppTheme.accent],
                          begin: Alignment.bottomCenter,
                          end: Alignment.topCenter,
                        ),
                        width: 20,
                        borderRadius: const BorderRadius.vertical(top: Radius.circular(6)),
                      ),
                    ]);
                  }),
                  titlesData: FlTitlesData(
                    leftTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                    rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                    topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        getTitlesWidget: (value, _) {
                          const days = ['M', 'T', 'W', 'T', 'F', 'S', 'S'];
                          return Padding(
                            padding: const EdgeInsets.only(top: 8),
                            child: Text(days[value.toInt()],
                                style: TextStyle(color: Colors.white.withValues(alpha: 0.5), fontSize: 12)),
                          );
                        },
                      ),
                    ),
                  ),
                  gridData: const FlGridData(show: false),
                  borderData: FlBorderData(show: false),
                ),
              ),
            ).animate().fadeIn(delay: 500.ms, duration: 500.ms),
            const SizedBox(height: 24),

            // Muscle Group Heatmap
            const Text('Muscle Group Focus', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: stats.muscleGroupFrequency.entries.map((entry) {
                final intensity = (entry.value / 5).clamp(0.2, 1.0);
                return Container(
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                  decoration: BoxDecoration(
                    color: AppTheme.primary.withValues(alpha: intensity),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text('${entry.key} (${entry.value}x)',
                      style: const TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.w500)),
                );
              }).toList(),
            ).animate().fadeIn(delay: 700.ms, duration: 400.ms),
            const SizedBox(height: 24),

            // Today's Goal
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [AppTheme.primary.withValues(alpha: 0.2), AppTheme.accent.withValues(alpha: 0.1)],
                ),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppTheme.primary.withValues(alpha: 0.3)),
              ),
              child: Row(
                children: [
                  CircularPercentIndicator(
                    radius: 40,
                    lineWidth: 8,
                    percent: (workout.todayCalories / (user?.dailyCalorieGoal ?? 500)).clamp(0.0, 1.0),
                    center: Text('${((workout.todayCalories / (user?.dailyCalorieGoal ?? 500)) * 100).round()}%',
                        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                    progressColor: AppTheme.primary,
                    backgroundColor: AppTheme.surface,
                    circularStrokeCap: CircularStrokeCap.round,
                  ),
                  const SizedBox(width: 20),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text("Today's Goal", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                        const SizedBox(height: 4),
                        Text(
                          '${workout.todayCalories.round()} / ${user?.dailyCalorieGoal ?? 500} cal burned',
                          style: TextStyle(color: Colors.white.withValues(alpha: 0.7)),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ).animate().fadeIn(delay: 900.ms, duration: 400.ms).slideY(begin: 0.1),
          ],
        ),
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  final IconData icon;
  final String value;
  final String label;
  final Color color;

  const _StatCard({required this.icon, required this.value, required this.label, required this.color});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppTheme.surface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: color.withValues(alpha: 0.3)),
        ),
        child: Column(
          children: [
            Icon(icon, color: color, size: 28),
            const SizedBox(height: 8),
            Text(value, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
            Text(label, style: TextStyle(fontSize: 12, color: Colors.white.withValues(alpha: 0.6))),
          ],
        ),
      ),
    );
  }
}

class _AIRecommendationCard extends StatelessWidget {
  final List<dynamic> sessions;
  final dynamic user;

  const _AIRecommendationCard({required this.sessions, required this.user});

  @override
  Widget build(BuildContext context) {
    final ai = context.watch<AIProvider>();

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF2D1B69), Color(0xFF11998E)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(Icons.auto_awesome, color: Colors.white, size: 20),
              ),
              const SizedBox(width: 12),
              const Expanded(
                child: Text('AI Coach', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white)),
              ),
              if (ai.isLoading) const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2)),
            ],
          ),
          const SizedBox(height: 12),
          if (ai.currentRecommendation != null) ...[
            Text(ai.currentRecommendation!.title,
                style: const TextStyle(fontWeight: FontWeight.w600, color: Colors.white)),
            const SizedBox(height: 4),
            Text(ai.currentRecommendation!.description,
                style: TextStyle(color: Colors.white.withValues(alpha: 0.8), fontSize: 13)),
            const SizedBox(height: 8),
            Text('Confidence: ${(ai.currentRecommendation!.confidence * 100).round()}%',
                style: TextStyle(color: Colors.white.withValues(alpha: 0.6), fontSize: 12)),
          ] else
            Text('Tap to get a personalized workout recommendation',
                style: TextStyle(color: Colors.white.withValues(alpha: 0.8), fontSize: 13)),
          const SizedBox(height: 12),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: ai.isLoading
                  ? null
                  : () => ai.getRecommendation(
                        user: user ?? UserProfile(id: '', name: '', email: ''),
                        recentSessions: List<WorkoutSession>.from(sessions),
                      ),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white.withValues(alpha: 0.2),
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              ),
              child: Text(ai.currentRecommendation != null ? 'New Recommendation' : 'Get AI Recommendation'),
            ),
          ),
        ],
      ),
    );
  }
}
