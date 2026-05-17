import 'dart:convert';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../models/workout.dart';
import '../models/exercise_library.dart';

class AIProvider extends ChangeNotifier {
  AIRecommendation? _currentRecommendation;
  bool _isLoading = false;
  String? _error;
  final List<AIRecommendation> _history = [];

  AIRecommendation? get currentRecommendation => _currentRecommendation;
  bool get isLoading => _isLoading;
  String? get error => _error;
  List<AIRecommendation> get history => List.unmodifiable(_history);

  /// Try calling the Flask backend for AI recommendations.
  /// Falls back to local recommendation engine if the server is unavailable.
  Future<void> getRecommendation({
    required UserProfile user,
    required List<WorkoutSession> recentSessions,
    String? focusArea,
  }) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final response = await http.post(
        Uri.parse('http://localhost:5000/api/recommend'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'user_profile': user.toMap(),
          'recent_sessions': recentSessions.map((s) => s.toMap()).toList(),
          'focus_area': focusArea,
        }),
      ).timeout(const Duration(seconds: 5));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        _currentRecommendation = AIRecommendation(
          id: data['id'] ?? DateTime.now().toIso8601String(),
          type: data['type'] ?? 'workout',
          title: data['title'] ?? 'AI Workout Plan',
          description: data['description'] ?? '',
          suggestedExercises: (data['exercises'] as List?)
                  ?.map((e) => Exercise.fromMap(e))
                  .toList() ??
              [],
          confidence: (data['confidence'] ?? 0.85).toDouble(),
          generatedAt: DateTime.now(),
        );
      } else {
        _generateLocalRecommendation(user, recentSessions, focusArea);
      }
    } catch (_) {
      // Backend unavailable — use local AI
      _generateLocalRecommendation(user, recentSessions, focusArea);
    }

    if (_currentRecommendation != null) {
      _history.insert(0, _currentRecommendation!);
    }
    _isLoading = false;
    notifyListeners();
  }

  void _generateLocalRecommendation(
      UserProfile user, List<WorkoutSession> sessions, String? focusArea) {
    final random = Random();
    // Analyze which muscle groups need attention
    final recentGroups = <String, int>{};
    for (final session in sessions.take(5)) {
      for (final ex in session.exercises) {
        recentGroups[ex.muscleGroup] = (recentGroups[ex.muscleGroup] ?? 0) + 1;
      }
    }

    // Find least trained groups
    final allGroups = ExerciseLibrary.muscleGroups;
    allGroups.sort((a, b) => (recentGroups[a] ?? 0).compareTo(recentGroups[b] ?? 0));
    final targetGroup = focusArea ?? allGroups.first;

    final exercises = ExerciseLibrary.getByMuscleGroup(targetGroup);
    final selected = (exercises.toList()..shuffle(random)).take(4).toList();

    // Add cardio if user goal is weight loss
    if (user.fitnessGoal.toLowerCase().contains('lose') ||
        user.fitnessGoal.toLowerCase().contains('weight')) {
      selected.add(ExerciseLibrary.exercises.firstWhere((e) => e.id == 'e19')); // Running
    }

    final descriptions = {
      'Chest': 'Focus on progressive overload with compound chest movements.',
      'Back': 'Target back thickness and width with pull and row variations.',
      'Legs': 'Build lower body strength with compound leg exercises.',
      'Shoulders': 'Develop rounded delts with press and isolation work.',
      'Arms': 'Superset biceps and triceps for maximum pump.',
      'Core': 'Strengthen your core with anti-rotation and flexion work.',
      'Full Body': 'Total body conditioning with compound movements and cardio.',
    };

    _currentRecommendation = AIRecommendation(
      id: DateTime.now().toIso8601String(),
      type: 'workout',
      title: '$targetGroup Focus Workout',
      description: '${descriptions[targetGroup] ?? "Custom workout based on your history."} '
          'Based on your ${user.fitnessLevel.toLowerCase()} level and '
          '${user.fitnessGoal.toLowerCase()} goal.',
      suggestedExercises: selected,
      confidence: 0.75 + random.nextDouble() * 0.2,
      generatedAt: DateTime.now(),
    );
  }

  Future<String> analyzeProgress(List<WorkoutSession> sessions) async {
    if (sessions.length < 2) return 'Need more workout data to analyze progress.';

    final recentCalories = sessions.take(5).map((s) => s.totalCalories).toList();
    final avgCalories = recentCalories.reduce((a, b) => a + b) / recentCalories.length;
    final trend = recentCalories.first > recentCalories.last ? 'increasing' : 'decreasing';

    final recentDurations = sessions.take(5).map((s) => s.duration.inMinutes).toList();
    final avgDuration = recentDurations.reduce((a, b) => a + b) / recentDurations.length;

    return 'Your workout intensity is $trend. '
        'Average session: ${avgDuration.round()} min burning ${avgCalories.round()} cal. '
        '${trend == "increasing" ? "Great progress! Keep pushing!" : "Consider increasing intensity gradually."}';
  }

  void clearRecommendation() {
    _currentRecommendation = null;
    notifyListeners();
  }
}
