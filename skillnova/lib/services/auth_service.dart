import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/user_model.dart';

class AuthService {
  static const String _usersKey = 'registered_users';
  static const String _currentUserKey = 'current_user';

  static Future<UserModel> register(String name, String email, String password) async {
    final prefs = await SharedPreferences.getInstance();
    
    // Verificar se usuário já existe
    final users = await _getUsers();
    if (users.any((user) => user['email'] == email)) {
      throw Exception('Email já cadastrado');
    }

    // Criar novo usuário completo
    final newUser = UserModel(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      name: name,
      email: email,
      currentRole: '',
      skills: [],
      interests: [],
      experienceYears: 0,
      educationLevel: '',
      profileCompleteness: 20.0, // 20% por ter nome e email
      points: 100, // Pontos iniciais de boas-vindas
      achievements: ['Bem-vindo ao SkillNova!'],
    );
    
    // Salvar usuário com senha
    final userWithPassword = newUser.toJson();
    userWithPassword['password'] = password;
    
    users.add(userWithPassword);
    await prefs.setString(_usersKey, jsonEncode(users));
    
    // Fazer login automático
    await _setCurrentUser(userWithPassword);
    return newUser;
  }

  static Future<UserModel> login(String email, String password) async {
    final users = await _getUsers();
    
    final user = users.firstWhere(
      (user) => user['email'] == email && user['password'] == password,
      orElse: () => {},
    );

    if (user.isEmpty) {
      throw Exception('Email ou senha incorretos');
    }

    await _setCurrentUser(user);
    return UserModel.fromJson(user);
  }

  static Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_currentUserKey);
  }

  static Future<UserModel?> getCurrentUser() async {
    final prefs = await SharedPreferences.getInstance();
    final userJson = prefs.getString(_currentUserKey);
    if (userJson != null) {
      return UserModel.fromJson(jsonDecode(userJson));
    }
    return null;
  }

  static Future<void> updateUser(UserModel user) async {
    final prefs = await SharedPreferences.getInstance();
    final users = await _getUsers();
    
    // Encontrar e atualizar usuário
    final userIndex = users.indexWhere((u) => u['id'] == user.id);
    if (userIndex != -1) {
      final currentPassword = users[userIndex]['password'];
      users[userIndex] = user.toJson();
      users[userIndex]['password'] = currentPassword; // Manter senha
      
      await prefs.setString(_usersKey, jsonEncode(users));
      await _setCurrentUser(users[userIndex]);
    }
  }

  static Future<bool> isLoggedIn() async {
    final user = await getCurrentUser();
    return user != null;
  }

  static Future<void> deleteAccount() async {
    final user = await getCurrentUser();
    if (user == null) return;
    
    final users = await _getUsers();
    users.removeWhere((u) => u['id'] == user.id);
    
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_usersKey, jsonEncode(users));
    await logout();
  }

  static Future<List<Map<String, dynamic>>> _getUsers() async {
    final prefs = await SharedPreferences.getInstance();
    final usersJson = prefs.getString(_usersKey);
    if (usersJson != null) {
      return List<Map<String, dynamic>>.from(jsonDecode(usersJson));
    }
    return [];
  }

  static Future<bool> resetPassword(String email) async {
    final users = await _getUsers();
    final userExists = users.any((user) => user['email'] == email);
    
    if (!userExists) {
      throw Exception('Email não encontrado');
    }
    
    // Simular envio de email de recuperação
    await Future.delayed(const Duration(seconds: 1));
    return true;
  }

  static Future<void> _setCurrentUser(Map<String, dynamic> user) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_currentUserKey, jsonEncode(user));
  }

  static Future<void> changePassword(String currentPassword, String newPassword) async {
    final user = await getCurrentUser();
    if (user == null) throw Exception('Usuário não encontrado');
    
    final users = await _getUsers();
    final userIndex = users.indexWhere((u) => u['id'] == user.id);
    
    if (userIndex == -1) throw Exception('Usuário não encontrado');
    if (users[userIndex]['password'] != currentPassword) {
      throw Exception('Senha atual incorreta');
    }
    
    users[userIndex]['password'] = newPassword;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_usersKey, jsonEncode(users));
  }
}