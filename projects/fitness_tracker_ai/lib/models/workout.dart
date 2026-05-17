class Exercise {
  final String id;
  final String name;
  final String category;
  final String muscleGroup;
  final int sets;
  final int reps;
  final double weight;
  final int durationSeconds;
  final double caloriesPerMinute;

  const Exercise({
    required this.id,
    required this.name,
    required this.category,
    required this.muscleGroup,
    this.sets = 3,
    this.reps = 12,
    this.weight = 0,
    this.durationSeconds = 0,
    this.caloriesPerMinute = 5.0,
  });

  Map<String, dynamic> toMap() => {
        'id': id,
        'name': name,
        'category': category,
        'muscleGroup': muscleGroup,
        'sets': sets,
        'reps': reps,
        'weight': weight,
        'durationSeconds': durationSeconds,
        'caloriesPerMinute': caloriesPerMinute,
      };

  factory Exercise.fromMap(Map<String, dynamic> map) => Exercise(
        id: map['id'] ?? '',
        name: map['name'] ?? '',
        category: map['category'] ?? '',
        muscleGroup: map['muscleGroup'] ?? '',
        sets: map['sets'] ?? 3,
        reps: map['reps'] ?? 12,
        weight: (map['weight'] ?? 0).toDouble(),
        durationSeconds: map['durationSeconds'] ?? 0,
        caloriesPerMinute: (map['caloriesPerMinute'] ?? 5.0).toDouble(),
      );
}

class WorkoutSession {
  final String id;
  final String userId;
  final String name;
  final DateTime startTime;
  final DateTime? endTime;
  final List<Exercise> exercises;
  final double totalCalories;
  final String? aiRecommendation;

  const WorkoutSession({
    required this.id,
    required this.userId,
    required this.name,
    required this.startTime,
    this.endTime,
    required this.exercises,
    required this.totalCalories,
    this.aiRecommendation,
  });

  Duration get duration => (endTime ?? DateTime.now()).difference(startTime);

  Map<String, dynamic> toMap() => {
        'id': id,
        'userId': userId,
        'name': name,
        'startTime': startTime.toIso8601String(),
        'endTime': endTime?.toIso8601String(),
        'exercises': exercises.map((e) => e.toMap()).toList(),
        'totalCalories': totalCalories,
        'aiRecommendation': aiRecommendation,
      };

  factory WorkoutSession.fromMap(Map<String, dynamic> map) => WorkoutSession(
        id: map['id'] ?? '',
        userId: map['userId'] ?? '',
        name: map['name'] ?? '',
        startTime: DateTime.parse(map['startTime']),
        endTime: map['endTime'] != null ? DateTime.parse(map['endTime']) : null,
        exercises: (map['exercises'] as List?)
                ?.map((e) => Exercise.fromMap(e as Map<String, dynamic>))
                .toList() ??
            [],
        totalCalories: (map['totalCalories'] ?? 0).toDouble(),
        aiRecommendation: map['aiRecommendation'],
      );
}

class UserProfile {
  final String id;
  final String name;
  final String email;
  final double weight;
  final double height;
  final int age;
  final String fitnessGoal;
  final String fitnessLevel;
  final int weeklyGoalDays;
  final int dailyCalorieGoal;
  final int streakDays;
  final int totalWorkouts;

  const UserProfile({
    required this.id,
    required this.name,
    required this.email,
    this.weight = 70,
    this.height = 175,
    this.age = 25,
    this.fitnessGoal = 'Build Muscle',
    this.fitnessLevel = 'Intermediate',
    this.weeklyGoalDays = 5,
    this.dailyCalorieGoal = 500,
    this.streakDays = 0,
    this.totalWorkouts = 0,
  });

  Map<String, dynamic> toMap() => {
        'id': id,
        'name': name,
        'email': email,
        'weight': weight,
        'height': height,
        'age': age,
        'fitnessGoal': fitnessGoal,
        'fitnessLevel': fitnessLevel,
        'weeklyGoalDays': weeklyGoalDays,
        'dailyCalorieGoal': dailyCalorieGoal,
        'streakDays': streakDays,
        'totalWorkouts': totalWorkouts,
      };
}

class AIRecommendation {
  final String id;
  final String type;
  final String title;
  final String description;
  final List<Exercise> suggestedExercises;
  final double confidence;
  final DateTime generatedAt;

  const AIRecommendation({
    required this.id,
    required this.type,
    required this.title,
    required this.description,
    required this.suggestedExercises,
    required this.confidence,
    required this.generatedAt,
  });
}

class WeeklyStats {
  final int workoutsCompleted;
  final double totalCalories;
  final int totalMinutes;
  final Map<String, int> muscleGroupFrequency;
  final List<double> dailyCalories;

  const WeeklyStats({
    required this.workoutsCompleted,
    required this.totalCalories,
    required this.totalMinutes,
    required this.muscleGroupFrequency,
    required this.dailyCalories,
  });
}
