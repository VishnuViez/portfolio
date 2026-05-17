import 'package:flutter/material.dart';
import '../models/workout.dart';

class AuthProvider extends ChangeNotifier {
  UserProfile? _user;
  bool _isLoading = false;
  String? _error;

  UserProfile? get user => _user;
  bool get isLoading => _isLoading;
  bool get isLoggedIn => _user != null;
  String? get error => _error;

  Future<bool> login(String email, String password) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    await Future.delayed(const Duration(seconds: 1));

    // Demo login — in production, use Firebase Auth
    if (email.isNotEmpty && password.length >= 6) {
      _user = UserProfile(
        id: 'user_001',
        name: 'Vishnu',
        email: email,
        weight: 75,
        height: 178,
        age: 26,
        fitnessGoal: 'Build Muscle',
        fitnessLevel: 'Intermediate',
        weeklyGoalDays: 5,
        dailyCalorieGoal: 500,
        streakDays: 12,
        totalWorkouts: 47,
      );
      _isLoading = false;
      notifyListeners();
      return true;
    } else {
      _error = 'Invalid email or password (min 6 chars)';
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future<bool> register(String name, String email, String password) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    await Future.delayed(const Duration(seconds: 1));

    _user = UserProfile(
      id: 'user_${DateTime.now().millisecondsSinceEpoch}',
      name: name,
      email: email,
    );
    _isLoading = false;
    notifyListeners();
    return true;
  }

  void logout() {
    _user = null;
    notifyListeners();
  }

  void updateProfile({double? weight, double? height, int? age, String? goal, String? level}) {
    if (_user == null) return;
    _user = UserProfile(
      id: _user!.id,
      name: _user!.name,
      email: _user!.email,
      weight: weight ?? _user!.weight,
      height: height ?? _user!.height,
      age: age ?? _user!.age,
      fitnessGoal: goal ?? _user!.fitnessGoal,
      fitnessLevel: level ?? _user!.fitnessLevel,
      weeklyGoalDays: _user!.weeklyGoalDays,
      dailyCalorieGoal: _user!.dailyCalorieGoal,
      streakDays: _user!.streakDays,
      totalWorkouts: _user!.totalWorkouts,
    );
    notifyListeners();
  }
}
