# Documentação Técnica - SkillNova

## CLASSES E MÉTODOS PRINCIPAIS

### UserModel
```dart
class UserModel {
  // Propriedades do usuário
  final String id, name, email, currentRole, educationLevel;
  final List<String> skills, interests, achievements;
  final int experienceYears, points;
  final double profileCompleteness;
  
  // Métodos
  factory UserModel.fromJson(Map<String, dynamic> json) 
  Map<String, dynamic> toJson()
}
```
**Função**: Representa dados do usuário com serialização JSON para persistência local.

### UserProvider
```dart
class UserProvider with ChangeNotifier {
  // Estado
  UserModel? _user;
  bool _isLoading;
  String? _error;
  
  // Métodos principais
  Future<void> loadUser()           // Carrega usuário do storage
  Future<void> login(email, pass)   // Autentica usuário
  Future<void> register(...)        // Registra novo usuário
  Future<void> logout()             // Remove sessão
  void addPoints(int points)        // Sistema de gamificação
  void updateProfileCompleteness()  // Calcula % do perfil
}
```
**Função**: Gerencia estado global do usuário, autenticação e gamificação.

### LearningPathModel
```dart
class LearningPathModel {
  // Propriedades da trilha
  final String id, title, description, category, difficulty;
  final int estimatedHours;
  final List<String> skills;
  final List<ModuleModel> modules;
  final double progress;
  final bool isRecommended;
}

class ModuleModel {
  final String id, title, type;
  final int duration;
  final bool isCompleted;
}
```
**Função**: Modela trilhas de aprendizado com módulos e progresso.

### LearningProvider
```dart
class LearningProvider with ChangeNotifier {
  // Estado
  List<LearningPathModel> _learningPaths;
  List<LearningPathModel> _recommendedPaths;
  
  // Métodos
  Future<void> loadLearningPaths()              // Carrega trilhas
  Future<void> startLearningPath(String id)    // Inicia trilha
  Future<void> completeModule(pathId, moduleId) // Completa módulo
}
```
**Função**: Gerencia estado das trilhas de aprendizado e progresso.

### AuthService
```dart
class AuthService {
  // Métodos estáticos para autenticação local
  static Future<UserModel> register(name, email, password)
  static Future<UserModel> login(email, password)
  static Future<void> logout()
  static Future<UserModel?> getCurrentUser()
  static Future<void> updateUser(UserModel user)
  static Future<void> changePassword(current, new)
  static Future<void> deleteAccount()
  static Future<bool> resetPassword(email)
}
```
**Função**: Simula backend de autenticação usando SharedPreferences.

### ApiService
```dart
class ApiService {
  // Mock de APIs para desenvolvimento
  static Future<UserModel> getUser()
  static Future<List<LearningPathModel>> getLearningPaths()
  static Future<void> startLearningPath(String pathId)
  static Future<void> completeModule(pathId, moduleId)
}
```
**Função**: Fornece dados mock para desenvolvimento, facilmente substituível por APIs reais.

## TELAS PRINCIPAIS

### AuthCheckScreen
```dart
class AuthCheckScreen extends StatefulWidget {
  Future<void> _checkAuth() // Verifica sessão ativa
}
```
**Função**: Ponto de entrada que direciona para login ou home baseado na autenticação.

### HomeScreen
```dart
class HomeScreen extends StatefulWidget {
  int _currentIndex; // Controla navegação bottom
  List<Widget> _screens; // Telas do bottom navigation
}

class DashboardTab extends StatelessWidget {
  // Dashboard principal com métricas e trilhas recomendadas
}
```
**Função**: Tela principal com navegação por abas e dashboard de métricas.

### ProfileScreen
```dart
class ProfileScreen extends StatelessWidget {
  Widget _buildInfoCard(...) // Constrói cards de informação
  void _showEditProfile(...)  // Modal de edição de perfil
}
```
**Função**: Exibe e permite edição do perfil do usuário.

### ChatScreen
```dart
class ChatScreen extends StatefulWidget {
  List<ChatMessage> _messages;
  void _sendMessage(String text)
  String _getBotResponse(String message) // IA simulada
}
```
**Função**: Interface de chat com assistente IA para orientação de carreira.

## WIDGETS REUTILIZÁVEIS

### DashboardCard
```dart
class DashboardCard extends StatelessWidget {
  final String title, value;
  final IconData icon;
  final Color color;
}
```
**Função**: Card padronizado para métricas do dashboard.

### LearningPathCard
```dart
class LearningPathCard extends StatelessWidget {
  final LearningPathModel path;
  void _showPathDetails(BuildContext context) // Modal com detalhes
  void _startPath(BuildContext context)       // Inicia trilha
}
```
**Função**: Card de trilha com progresso e ações.

### ProgressChart
```dart
class ProgressChart extends StatelessWidget {
  // Gráfico de linha com FL Chart mostrando progresso semanal
}
```
**Função**: Visualização gráfica do progresso do usuário.

## FLUXOS PRINCIPAIS

### Fluxo de Autenticação
1. `AuthCheckScreen` verifica sessão
2. Se não autenticado → `LoginScreen`
3. Login válido → `UserProvider.login()`
4. `AuthService.login()` valida credenciais
5. Sucesso → navega para `HomeScreen`

### Fluxo de Trilhas
1. `LearningProvider.loadLearningPaths()` carrega dados
2. `ApiService.getLearningPaths()` retorna mock data
3. Usuário seleciona trilha → `LearningPathCard._showPathDetails()`
4. Inicia trilha → `LearningProvider.startLearningPath()`
5. Progresso salvo e UI atualizada

### Fluxo de Gamificação
1. Ação do usuário (completar módulo, editar perfil)
2. `UserProvider.addPoints()` adiciona pontos
3. `UserProvider.updateProfileCompleteness()` recalcula %
4. `AuthService.updateUser()` persiste mudanças
5. UI reativa atualiza automaticamente

## PADRÕES DE DESIGN

### Provider Pattern
- **Vantagem**: Estado reativo sem complexidade
- **Uso**: `ChangeNotifier` para mudanças de estado
- **Consumer**: Rebuilds otimizados apenas onde necessário

### Repository Pattern (Simulado)
- **AuthService**: Repositório de autenticação
- **ApiService**: Repositório de dados de aprendizado
- **Benefício**: Fácil troca de implementação (local → cloud)

### Factory Pattern
- **UserModel.fromJson()**: Criação de objetos a partir de JSON
- **Benefício**: Validação e transformação centralizadas

## TRATAMENTO DE ERROS

### Async/Await com Try-Catch
```dart
try {
  await userProvider.login(email, password);
  // Sucesso - navegar
} catch (e) {
  // Erro - mostrar SnackBar
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(content: Text(e.toString()))
  );
}
```

### Validação de Formulários
- `TextFormField` com `validator`
- `GlobalKey<FormState>` para validação centralizada
- Feedback visual imediato

### Estados de Loading
- `_isLoading` em providers
- `CircularProgressIndicator` durante operações
- Desabilita botões durante carregamento

## PERFORMANCE

### Otimizações Implementadas
- `const` constructors onde possível
- `ListView.builder` para listas grandes
- `Consumer` específico para rebuilds mínimos
- Cache de dados em providers

### Memory Management
- `dispose()` de controllers
- Listeners removidos automaticamente pelo Provider
- Imagens otimizadas com cache

Esta documentação fornece visão completa da arquitetura e implementação do SkillNova.