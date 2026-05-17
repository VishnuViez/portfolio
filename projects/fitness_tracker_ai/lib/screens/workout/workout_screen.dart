import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:provider/provider.dart';
import '../../models/exercise_library.dart';
import '../../models/workout.dart';
import '../../providers/workout_provider.dart';
import '../../theme/app_theme.dart';

class WorkoutScreen extends StatelessWidget {
  const WorkoutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final workout = context.watch<WorkoutProvider>();

    return SafeArea(
      child: workout.isWorkoutActive ? _ActiveWorkout() : _WorkoutLauncher(),
    );
  }
}

class _WorkoutLauncher extends StatelessWidget {
  final workoutTypes = const [
    {'name': 'Push Day', 'icon': Icons.arrow_upward, 'groups': 'Chest, Shoulders, Triceps'},
    {'name': 'Pull Day', 'icon': Icons.arrow_downward, 'groups': 'Back, Biceps'},
    {'name': 'Leg Day', 'icon': Icons.directions_walk, 'groups': 'Quads, Hamstrings, Calves'},
    {'name': 'Upper Body', 'icon': Icons.accessibility_new, 'groups': 'Chest, Back, Shoulders, Arms'},
    {'name': 'Cardio Blast', 'icon': Icons.directions_run, 'groups': 'Full Body Conditioning'},
    {'name': 'Core & Abs', 'icon': Icons.sports_gymnastics, 'groups': 'Core, Obliques'},
    {'name': 'Custom Workout', 'icon': Icons.tune, 'groups': 'Build your own'},
  ];

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Start Workout', style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          Text('Choose a workout type', style: TextStyle(color: Colors.white.withValues(alpha: 0.6))),
          const SizedBox(height: 24),
          ...workoutTypes.asMap().entries.map((entry) {
            final i = entry.key;
            final type = entry.value;
            return Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: _WorkoutTypeCard(
                name: type['name'] as String,
                icon: type['icon'] as IconData,
                groups: type['groups'] as String,
                onTap: () => context.read<WorkoutProvider>().startWorkout(type['name'] as String),
              ).animate().fadeIn(delay: Duration(milliseconds: 100 * i), duration: 400.ms).slideX(begin: 0.1),
            );
          }),
        ],
      ),
    );
  }
}

class _WorkoutTypeCard extends StatelessWidget {
  final String name;
  final IconData icon;
  final String groups;
  final VoidCallback onTap;

  const _WorkoutTypeCard({required this.name, required this.icon, required this.groups, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppTheme.surface,
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(colors: [AppTheme.primary, AppTheme.accent]),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Icon(icon, color: Colors.white),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                    const SizedBox(height: 2),
                    Text(groups, style: TextStyle(color: Colors.white.withValues(alpha: 0.5), fontSize: 13)),
                  ],
                ),
              ),
              const Icon(Icons.chevron_right, color: Colors.white38),
            ],
          ),
        ),
      ),
    );
  }
}

class _ActiveWorkout extends StatefulWidget {
  @override
  State<_ActiveWorkout> createState() => _ActiveWorkoutState();
}

class _ActiveWorkoutState extends State<_ActiveWorkout> {
  String _selectedCategory = 'All';

  @override
  Widget build(BuildContext context) {
    final workout = context.watch<WorkoutProvider>();
    final categories = ['All', ...ExerciseLibrary.categories];
    final exercises = _selectedCategory == 'All'
        ? ExerciseLibrary.exercises
        : ExerciseLibrary.getByCategory(_selectedCategory);

    return Column(
      children: [
        // Timer bar
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          color: AppTheme.primary.withValues(alpha: 0.15),
          child: Row(
            children: [
              const Icon(Icons.timer, color: AppTheme.primary),
              const SizedBox(width: 8),
              StreamBuilder(
                stream: Stream.periodic(const Duration(seconds: 1)),
                builder: (context, _) {
                  final session = workout.activeSession;
                  if (session == null) return const SizedBox();
                  final elapsed = DateTime.now().difference(session.startTime);
                  return Text(
                    '${elapsed.inMinutes.toString().padLeft(2, "0")}:${(elapsed.inSeconds % 60).toString().padLeft(2, "0")}',
                    style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: AppTheme.primary),
                  );
                },
              ),
              const Spacer(),
              Text('${workout.activeExercises.length} exercises',
                  style: TextStyle(color: Colors.white.withValues(alpha: 0.7))),
            ],
          ),
        ),

        // Active exercises
        if (workout.activeExercises.isNotEmpty)
          Container(
            constraints: const BoxConstraints(maxHeight: 150),
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.all(12),
              itemCount: workout.activeExercises.length,
              itemBuilder: (context, i) {
                final ex = workout.activeExercises[i];
                return Container(
                  width: 140,
                  margin: const EdgeInsets.only(right: 8),
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: AppTheme.surface,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: AppTheme.primary.withValues(alpha: 0.3)),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(ex.name,
                          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13), maxLines: 2, overflow: TextOverflow.ellipsis),
                      const Spacer(),
                      Text(ex.category == 'Cardio' ? '${ex.durationSeconds ~/ 60} min' : '${ex.sets}x${ex.reps}',
                          style: TextStyle(color: Colors.white.withValues(alpha: 0.6), fontSize: 12)),
                      const SizedBox(height: 4),
                      GestureDetector(
                        onTap: () => workout.removeExercise(i),
                        child: const Text('Remove', style: TextStyle(color: AppTheme.secondary, fontSize: 12)),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),

        // Category filter
        SizedBox(
          height: 45,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: categories.length,
            itemBuilder: (context, i) => Padding(
              padding: const EdgeInsets.only(right: 8),
              child: ChoiceChip(
                label: Text(categories[i]),
                selected: _selectedCategory == categories[i],
                onSelected: (_) => setState(() => _selectedCategory = categories[i]),
                selectedColor: AppTheme.primary,
              ),
            ),
          ),
        ),
        const SizedBox(height: 8),

        // Exercise library
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: exercises.length,
            itemBuilder: (context, i) {
              final ex = exercises[i];
              return ListTile(
                leading: CircleAvatar(
                  backgroundColor: AppTheme.primary.withValues(alpha: 0.2),
                  child: Icon(_getExerciseIcon(ex.category), color: AppTheme.primary, size: 20),
                ),
                title: Text(ex.name),
                subtitle: Text('${ex.muscleGroup} · ${ex.category}'),
                trailing: IconButton(
                  icon: const Icon(Icons.add_circle, color: AppTheme.primary),
                  onPressed: () => workout.addExercise(ex),
                ),
              );
            },
          ),
        ),

        // Bottom actions
        Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () => workout.cancelWorkout(),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppTheme.secondary,
                    side: const BorderSide(color: AppTheme.secondary),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                  ),
                  child: const Text('Cancel'),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                flex: 2,
                child: ElevatedButton(
                  onPressed: workout.activeExercises.isEmpty ? null : () => workout.finishWorkout(),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.primary,
                    foregroundColor: Colors.black,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                  ),
                  child: const Text('Finish Workout', style: TextStyle(fontWeight: FontWeight.bold)),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  IconData _getExerciseIcon(String category) {
    return switch (category) {
      'Cardio' => Icons.directions_run,
      'Bodyweight' => Icons.self_improvement,
      'HIIT' => Icons.flash_on,
      'Core' => Icons.sports_gymnastics,
      _ => Icons.fitness_center,
    };
  }
}
