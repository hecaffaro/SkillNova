import '../models/user_model.dart';
import '../models/learning_path_model.dart';

class ApiService {
  static const String baseUrl = 'https://api.skillnova.com';

  // Mock data para demonstração
  static Future<UserModel> getUser() async {
    await Future.delayed(const Duration(seconds: 1));
    return UserModel(
      id: '1',
      name: 'Heloísa Caffaro',
      email: 'heloisa@email.com',
      currentRole: 'Desenvolvedor Frontend',
      skills: ['JavaScript', 'React', 'CSS'],
      interests: ['Flutter', 'Mobile Development', 'UI/UX'],
      experienceYears: 3,
      educationLevel: 'Superior Completo',
      profileCompleteness: 0.75,
      points: 1250,
      achievements: ['Primeira trilha concluída', 'Streak de 7 dias'],
    );
  }

  static Future<List<LearningPathModel>> getLearningPaths() async {
    await Future.delayed(const Duration(seconds: 1));
    return [
      LearningPathModel(
        id: '1',
        title: 'Flutter para Iniciantes',
        description: 'Aprenda desenvolvimento mobile com Flutter',
        category: 'Mobile Development',
        estimatedHours: 40,
        difficulty: 'Iniciante',
        skills: ['Flutter', 'Dart', 'Mobile UI'],
        modules: [
          ModuleModel(id: '1', title: 'Introdução ao Flutter', type: 'video', duration: 30),
          ModuleModel(id: '2', title: 'Widgets Básicos', type: 'interactive', duration: 45),
          ModuleModel(id: '3', title: 'Navegação', type: 'project', duration: 60),
        ],
        progress: 0.3,
        isRecommended: true,
      ),
      LearningPathModel(
        id: '2',
        title: 'UX/UI Design Fundamentals',
        description: 'Princípios essenciais de design de interface',
        category: 'Design',
        estimatedHours: 25,
        difficulty: 'Intermediário',
        skills: ['Design Thinking', 'Figma', 'Prototipagem'],
        modules: [
          ModuleModel(id: '1', title: 'Design Thinking', type: 'video', duration: 40),
          ModuleModel(id: '2', title: 'Ferramentas de Design', type: 'hands-on', duration: 50),
        ],
        progress: 0.0,
        isRecommended: true,
      ),
    ];
  }

  static Future<UserModel> updateUser(Map<String, dynamic> data) async {
    await Future.delayed(const Duration(milliseconds: 500));
    return getUser();
  }

  static Future<void> startLearningPath(String pathId) async {
    await Future.delayed(const Duration(milliseconds: 500));
  }

  static Future<void> completeModule(String pathId, String moduleId) async {
    await Future.delayed(const Duration(milliseconds: 500));
  }
}