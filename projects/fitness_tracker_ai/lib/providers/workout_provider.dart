import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import '../models/workout.dart';
import '../models/exercise_library.dart';

class WorkoutProvider extends ChangeNotifier {
  final List<WorkoutSession> _sessions = [];
  WorkoutSession? _activeSession;
  final List<Exercise> _activeExercises = [];
  DateTime? _sessionStartTime;

  List<WorkoutSession> get sessions => List.unmodifiable(_sessions);
  WorkoutSession? get activeSession => _activeSession;
  List<Exercise> get activeExercises => List.unmodifiable(_activeExercises);
  bool get isWorkoutActive => _activeSession != null;

  WorkoutProvider() {
    _generateSampleData();
  }

  void _generateSampleData() {
    final now = DateTime.now();
    final exercises = ExerciseLibrary.exercises;

    for (int i = 6; i >= 0; i--) {
      if (i == 3 || i == 6) continue; // Rest days
      final date = now.subtract(Duration(days: i));
      final dayExercises = <Exercise>[];
      final group = ['Chest', 'Back', 'Legs', 'Shoulders', 'Arms'][i % 5];
      dayExercises.addAll(ExerciseLibrary.getByMuscleGroup(group).take(3));
      dayExercises.add(exercises.firstWhere((e) => e.category == 'Cardio'));

      _sessions.add(WorkoutSession(
        id: const Uuid().v4(),
        userId: 'user_001',
        name: '$group Day',
        startTime: date.copyWith(hour: 7, minute: 0),
        endTime: date.copyWith(hour: 8, minute: 15),
        exercises: dayExercises,
        totalCalories: 350 + (i * 30).toDouble(),
        aiRecommendation: 'Great $group workout! Consider increasing weight next session.',
      ));
    }
  }

  void startWorkout(String name) {
    _sessionStartTime = DateTime.now();
    _activeExercises.clear();
    _activeSession = WorkoutSession(
      id: const Uuid().v4(),
      userId: 'user_001',
      name: name,
      startTime: _sessionStartTime!,
      exercises: [],
      totalCalories: 0,
    );
    notifyListeners();
  }

  void addExercise(Exercise exercise) {
    _activeExercises.add(exercise);
    notifyListeners();
  }

  void removeExercise(int index) {
    _activeExercises.removeAt(index);
    notifyListeners();
  }

  void finishWorkout() {
    if (_activeSession == null) return;
    final now = DateTime.now();
    final durationMinutes = now.difference(_sessionStartTime!).inMinutes;
    final totalCals = _activeExercises.fold<double>(
        0, (sum, e) => sum + (e.caloriesPerMinute * (durationMinutes / _activeExercises.length)));

    _sessions.insert(
      0,
      WorkoutSession(
        id: _activeSession!.id,
        userId: _activeSession!.userId,
        name: _activeSession!.name,
        startTime: _sessionStartTime!,
        endTime: now,
        exercises: List.from(_activeExercises),
        totalCalories: totalCals,
      ),
    );
    _activeSession = null;
    _activeExercises.clear();
    _sessionStartTime = null;
    notifyListeners();
  }

  void cancelWorkout() {
    _activeSession = null;
    _activeExercises.clear();
    _sessionStartTime = null;
    notifyListeners();
  }

  WeeklyStats getWeeklyStats() {
    final now = DateTime.now();
    final weekStart = now.subtract(Duration(days: now.weekday - 1));
    final weekSessions = _sessions.where((s) =>
        s.startTime.isAfter(weekStart.copyWith(hour: 0, minute: 0)) &&
        s.startTime.isBefore(now));

    final muscleFreq = <String, int>{};
    for (final session in weekSessions) {
      for (final exercise in session.exercises) {
        muscleFreq[exercise.muscleGroup] = (muscleFreq[exercise.muscleGroup] ?? 0) + 1;
      }
    }

    final dailyCals = List<double>.filled(7, 0);
    for (final session in weekSessions) {
      final dayIndex = session.startTime.weekday - 1;
      if (dayIndex >= 0 && dayIndex < 7) {
        dailyCals[dayIndex] += session.totalCalories;
      }
    }

    return WeeklyStats(
      workoutsCompleted: weekSessions.length,
      totalCalories: weekSessions.fold(0, (sum, s) => sum + s.totalCalories),
      totalMinutes: weekSessions.fold(0, (sum, s) => sum + s.duration.inMinutes),
      muscleGroupFrequency: muscleFreq,
      dailyCalories: dailyCals,
    );
  }

  double get todayCalories {
    final today = DateTime.now();
    return _sessions
        .where((s) =>
            s.startTime.year == today.year &&
            s.startTime.month == today.month &&
            s.startTime.day == today.day)
        .fold(0, (sum, s) => sum + s.totalCalories);
  }
}
