import 'workout.dart';

class ExerciseLibrary {
  static const List<Exercise> exercises = [
    // Chest
    Exercise(id: 'e1', name: 'Bench Press', category: 'Strength', muscleGroup: 'Chest', sets: 4, reps: 10, weight: 60, caloriesPerMinute: 7.0),
    Exercise(id: 'e2', name: 'Incline Dumbbell Press', category: 'Strength', muscleGroup: 'Chest', sets: 3, reps: 12, weight: 20, caloriesPerMinute: 6.5),
    Exercise(id: 'e3', name: 'Push-ups', category: 'Bodyweight', muscleGroup: 'Chest', sets: 3, reps: 20, caloriesPerMinute: 5.0),
    Exercise(id: 'e4', name: 'Cable Flyes', category: 'Strength', muscleGroup: 'Chest', sets: 3, reps: 15, weight: 15, caloriesPerMinute: 5.5),
    // Back
    Exercise(id: 'e5', name: 'Deadlift', category: 'Strength', muscleGroup: 'Back', sets: 4, reps: 8, weight: 80, caloriesPerMinute: 8.0),
    Exercise(id: 'e6', name: 'Pull-ups', category: 'Bodyweight', muscleGroup: 'Back', sets: 3, reps: 10, caloriesPerMinute: 6.0),
    Exercise(id: 'e7', name: 'Barbell Row', category: 'Strength', muscleGroup: 'Back', sets: 3, reps: 12, weight: 50, caloriesPerMinute: 6.5),
    Exercise(id: 'e8', name: 'Lat Pulldown', category: 'Strength', muscleGroup: 'Back', sets: 3, reps: 12, weight: 40, caloriesPerMinute: 5.5),
    // Legs
    Exercise(id: 'e9', name: 'Squats', category: 'Strength', muscleGroup: 'Legs', sets: 4, reps: 10, weight: 70, caloriesPerMinute: 8.0),
    Exercise(id: 'e10', name: 'Leg Press', category: 'Strength', muscleGroup: 'Legs', sets: 3, reps: 12, weight: 100, caloriesPerMinute: 7.0),
    Exercise(id: 'e11', name: 'Lunges', category: 'Strength', muscleGroup: 'Legs', sets: 3, reps: 12, weight: 20, caloriesPerMinute: 6.5),
    Exercise(id: 'e12', name: 'Leg Curl', category: 'Strength', muscleGroup: 'Legs', sets: 3, reps: 15, weight: 30, caloriesPerMinute: 5.0),
    // Shoulders
    Exercise(id: 'e13', name: 'Overhead Press', category: 'Strength', muscleGroup: 'Shoulders', sets: 4, reps: 10, weight: 30, caloriesPerMinute: 6.0),
    Exercise(id: 'e14', name: 'Lateral Raises', category: 'Strength', muscleGroup: 'Shoulders', sets: 3, reps: 15, weight: 10, caloriesPerMinute: 4.5),
    Exercise(id: 'e15', name: 'Face Pulls', category: 'Strength', muscleGroup: 'Shoulders', sets: 3, reps: 15, weight: 15, caloriesPerMinute: 4.0),
    // Arms
    Exercise(id: 'e16', name: 'Bicep Curls', category: 'Strength', muscleGroup: 'Arms', sets: 3, reps: 12, weight: 15, caloriesPerMinute: 4.5),
    Exercise(id: 'e17', name: 'Tricep Dips', category: 'Bodyweight', muscleGroup: 'Arms', sets: 3, reps: 15, caloriesPerMinute: 5.0),
    Exercise(id: 'e18', name: 'Hammer Curls', category: 'Strength', muscleGroup: 'Arms', sets: 3, reps: 12, weight: 12, caloriesPerMinute: 4.5),
    // Cardio
    Exercise(id: 'e19', name: 'Running', category: 'Cardio', muscleGroup: 'Full Body', durationSeconds: 1800, caloriesPerMinute: 10.0),
    Exercise(id: 'e20', name: 'Cycling', category: 'Cardio', muscleGroup: 'Legs', durationSeconds: 1800, caloriesPerMinute: 8.0),
    Exercise(id: 'e21', name: 'Jump Rope', category: 'Cardio', muscleGroup: 'Full Body', durationSeconds: 900, caloriesPerMinute: 12.0),
    Exercise(id: 'e22', name: 'Burpees', category: 'HIIT', muscleGroup: 'Full Body', sets: 5, reps: 10, caloriesPerMinute: 10.0),
    // Core
    Exercise(id: 'e23', name: 'Plank', category: 'Core', muscleGroup: 'Core', durationSeconds: 60, caloriesPerMinute: 4.0),
    Exercise(id: 'e24', name: 'Crunches', category: 'Core', muscleGroup: 'Core', sets: 3, reps: 20, caloriesPerMinute: 4.0),
    Exercise(id: 'e25', name: 'Russian Twists', category: 'Core', muscleGroup: 'Core', sets: 3, reps: 20, weight: 5, caloriesPerMinute: 4.5),
  ];

  static List<Exercise> getByCategory(String category) =>
      exercises.where((e) => e.category == category).toList();

  static List<Exercise> getByMuscleGroup(String muscleGroup) =>
      exercises.where((e) => e.muscleGroup == muscleGroup).toList();

  static List<String> get categories =>
      exercises.map((e) => e.category).toSet().toList();

  static List<String> get muscleGroups =>
      exercises.map((e) => e.muscleGroup).toSet().toList();
}
