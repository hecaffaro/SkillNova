import 'package:flutter/material.dart';
import '../models/learning_path_model.dart';
import '../services/api_service.dart';

class LearningProvider with ChangeNotifier {
  List<LearningPathModel> _learningPaths = [];
  List<LearningPathModel> _recommendedPaths = [];
  bool _isLoading = false;
  String? _error;

  List<LearningPathModel> get learningPaths => _learningPaths;
  List<LearningPathModel> get recommendedPaths => _recommendedPaths;
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> loadLearningPaths() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _learningPaths = await ApiService.getLearningPaths();
      _recommendedPaths = _learningPaths.where((path) => path.isRecommended).toList();
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> startLearningPath(String pathId) async {
    try {
      await ApiService.startLearningPath(pathId);
      await loadLearningPaths();
    } catch (e) {
      _error = e.toString();
      notifyListeners();
    }
  }

  Future<void> completeModule(String pathId, String moduleId) async {
    try {
      await ApiService.completeModule(pathId, moduleId);
      await loadLearningPaths();
    } catch (e) {
      _error = e.toString();
      notifyListeners();
    }
  }

  Future<void> loadRecommendedPaths() async {
    await loadLearningPaths();
  }
}