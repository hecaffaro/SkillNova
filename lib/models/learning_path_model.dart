class LearningPathModel {
  final String id;
  final String title;
  final String description;
  final String category;
  final int estimatedHours;
  final String difficulty;
  final List<String> skills;
  final List<ModuleModel> modules;
  final double progress;
  final bool isRecommended;

  LearningPathModel({
    required this.id,
    required this.title,
    required this.description,
    required this.category,
    required this.estimatedHours,
    required this.difficulty,
    required this.skills,
    required this.modules,
    this.progress = 0.0,
    this.isRecommended = false,
  });

  factory LearningPathModel.fromJson(Map<String, dynamic> json) {
    return LearningPathModel(
      id: json['id'] ?? '',
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      category: json['category'] ?? '',
      estimatedHours: json['estimatedHours'] ?? 0,
      difficulty: json['difficulty'] ?? '',
      skills: List<String>.from(json['skills'] ?? []),
      modules: (json['modules'] as List?)
          ?.map((m) => ModuleModel.fromJson(m))
          .toList() ?? [],
      progress: json['progress']?.toDouble() ?? 0.0,
      isRecommended: json['isRecommended'] ?? false,
    );
  }
}

class ModuleModel {
  final String id;
  final String title;
  final String type;
  final int duration;
  final bool isCompleted;

  ModuleModel({
    required this.id,
    required this.title,
    required this.type,
    required this.duration,
    this.isCompleted = false,
  });

  factory ModuleModel.fromJson(Map<String, dynamic> json) {
    return ModuleModel(
      id: json['id'] ?? '',
      title: json['title'] ?? '',
      type: json['type'] ?? '',
      duration: json['duration'] ?? 0,
      isCompleted: json['isCompleted'] ?? false,
    );
  }
}