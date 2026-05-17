import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../../providers/workout_provider.dart';
import '../../theme/app_theme.dart';

class HistoryScreen extends StatelessWidget {
  const HistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final workout = context.watch<WorkoutProvider>();
    final sessions = workout.sessions;

    return SafeArea(
      child: sessions.isEmpty
          ? const Center(child: Text('No workouts yet. Start your first one!'))
          : ListView.builder(
              padding: const EdgeInsets.all(20),
              itemCount: sessions.length + 1,
              itemBuilder: (context, index) {
                if (index == 0) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 20),
                    child: const Text('Workout History',
                            style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold))
                        .animate()
                        .fadeIn(duration: 400.ms),
                  );
                }
                final session = sessions[index - 1];
                return _HistoryCard(session: session, index: index - 1)
                    .animate()
                    .fadeIn(delay: Duration(milliseconds: 80 * index), duration: 400.ms)
                    .slideX(begin: 0.05);
              },
            ),
    );
  }
}

class _HistoryCard extends StatelessWidget {
  final dynamic session;
  final int index;

  const _HistoryCard({required this.session, required this.index});

  @override
  Widget build(BuildContext context) {
    final dateFormat = DateFormat('MMM dd, yyyy');
    final timeFormat = DateFormat('h:mm a');

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppTheme.primary.withValues(alpha: 0.1)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(colors: [AppTheme.primary, AppTheme.accent]),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(Icons.fitness_center, color: Colors.white, size: 20),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(session.name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                    Text(dateFormat.format(session.startTime),
                        style: TextStyle(color: Colors.white.withValues(alpha: 0.5), fontSize: 13)),
                  ],
                ),
              ),
              Text('${session.duration.inMinutes} min',
                  style: const TextStyle(color: AppTheme.primary, fontWeight: FontWeight.w600)),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _MiniStat(icon: Icons.local_fire_department, value: '${session.totalCalories.round()} cal', color: AppTheme.secondary),
              _MiniStat(icon: Icons.sports_gymnastics, value: '${session.exercises.length} exercises', color: AppTheme.accent),
              _MiniStat(icon: Icons.schedule, value: timeFormat.format(session.startTime), color: const Color(0xFFF59E0B)),
            ],
          ),
          if (session.aiRecommendation != null) ...[
            const SizedBox(height: 10),
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: AppTheme.accent.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Row(
                children: [
                  const Icon(Icons.auto_awesome, size: 16, color: AppTheme.accent),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(session.aiRecommendation!,
                        style: TextStyle(fontSize: 12, color: Colors.white.withValues(alpha: 0.7))),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _MiniStat extends StatelessWidget {
  final IconData icon;
  final String value;
  final Color color;

  const _MiniStat({required this.icon, required this.value, required this.color});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 16, color: color),
        const SizedBox(width: 4),
        Text(value, style: TextStyle(fontSize: 12, color: Colors.white.withValues(alpha: 0.7))),
      ],
    );
  }
}
