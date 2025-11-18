import 'package:flutter/material.dart';
import '../models/user_model.dart';
import '../services/auth_service.dart';

class UserProvider with ChangeNotifier {
  UserModel? _user;
  bool _isLoading = false;
  String? _error;

  UserModel? get user => _user;
  bool get isLoading => _isLoading;
  String? get error => _error;
  bool get isLoggedIn => _user != null;

  Future<void> loadUser() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _user = await AuthService.getCurrentUser();
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> login(String email, String password) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _user = await AuthService.login(email, password);
    } catch (e) {
      _error = e.toString();
      rethrow;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> register(String name, String email, String password) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _user = await AuthService.register(name, email, password);
    } catch (e) {
      _error = e.toString();
      rethrow;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> logout() async {
    await AuthService.logout();
    _user = null;
    _error = null;
    notifyListeners();
  }

  Future<void> updateProfile(UserModel updatedUser) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      await AuthService.updateUser(updatedUser);
      _user = updatedUser;
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void addPoints(int points) {
    if (_user != null) {
      _user = UserModel(
        id: _user!.id,
        name: _user!.name,
        email: _user!.email,
        currentRole: _user!.currentRole,
        skills: _user!.skills,
        interests: _user!.interests,
        experienceYears: _user!.experienceYears,
        educationLevel: _user!.educationLevel,
        profileCompleteness: _user!.profileCompleteness,
        points: _user!.points + points,
        achievements: _user!.achievements,
      );
      AuthService.updateUser(_user!);
      notifyListeners();
    }
  }

  void updateProfileCompleteness() {
    if (_user == null) return;
    
    double completeness = 20.0;
    
    if (_user!.currentRole.isNotEmpty) completeness += 15;
    if (_user!.skills.isNotEmpty) completeness += 20;
    if (_user!.interests.isNotEmpty) completeness += 15;
    if (_user!.experienceYears > 0) completeness += 15;
    if (_user!.educationLevel.isNotEmpty) completeness += 15;
    
    _user = UserModel(
      id: _user!.id,
      name: _user!.name,
      email: _user!.email,
      currentRole: _user!.currentRole,
      skills: _user!.skills,
      interests: _user!.interests,
      experienceYears: _user!.experienceYears,
      educationLevel: _user!.educationLevel,
      profileCompleteness: completeness,
      points: _user!.points,
      achievements: _user!.achievements,
    );
    
    AuthService.updateUser(_user!);
    notifyListeners();
  }

  Future<void> changePassword(String currentPassword, String newPassword) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      await AuthService.changePassword(currentPassword, newPassword);
    } catch (e) {
      _error = e.toString();
      rethrow;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> deleteAccount() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      await AuthService.deleteAccount();
      _user = null;
    } catch (e) {
      _error = e.toString();
      rethrow;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void clearError() {
    _error = null;
    notifyListeners();
  }
}