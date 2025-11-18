class UserModel {
  final String id;
  final String name;
  final String email;
  final String currentRole;
  final List<String> skills;
  final List<String> interests;
  final int experienceYears;
  final String educationLevel;
  final double profileCompleteness;
  final int points;
  final List<String> achievements;

  UserModel({
    required this.id,
    required this.name,
    required this.email,
    required this.currentRole,
    required this.skills,
    required this.interests,
    required this.experienceYears,
    required this.educationLevel,
    this.profileCompleteness = 0.0,
    this.points = 0,
    this.achievements = const [],
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      currentRole: json['currentRole'] ?? '',
      skills: List<String>.from(json['skills'] ?? []),
      interests: List<String>.from(json['interests'] ?? []),
      experienceYears: json['experienceYears'] ?? 0,
      educationLevel: json['educationLevel'] ?? '',
      profileCompleteness: json['profileCompleteness']?.toDouble() ?? 0.0,
      points: json['points'] ?? 0,
      achievements: List<String>.from(json['achievements'] ?? []),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'currentRole': currentRole,
      'skills': skills,
      'interests': interests,
      'experienceYears': experienceYears,
      'educationLevel': educationLevel,
      'profileCompleteness': profileCompleteness,
      'points': points,
      'achievements': achievements,
    };
  }
}