import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/user_provider.dart';
import '../providers/learning_provider.dart';
import '../widgets/dashboard_card.dart';
import '../widgets/learning_path_card.dart';
import '../widgets/progress_chart.dart';
import 'profile_screen.dart';
import 'learning_paths_screen.dart';
import 'chat_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;

  final List<Widget> _screens = [
    const DashboardTab(),
    const LearningPathsScreen(),
    const ChatScreen(),
    const ProfileScreen(),
  ];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<UserProvider>(context, listen: false).loadUser();
      Provider.of<LearningProvider>(context, listen: false).loadRecommendedPaths();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: _currentIndex,
        onTap: (index) => setState(() => _currentIndex = index),
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.dashboard),
            label: 'Dashboard',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.school),
            label: 'Trilhas',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.chat),
            label: 'Assistente',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Perfil',
          ),
        ],
      ),
    );
  }
}

class DashboardTab extends StatelessWidget {
  const DashboardTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer2<UserProvider, LearningProvider>(
      builder: (context, userProvider, learningProvider, child) {
        final user = userProvider.user;
        final recommendedPaths = learningProvider.recommendedPaths;

        if (user == null) {
          return const Center(child: CircularProgressIndicator());
        }

        return SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Olá, ${user.name.split(' ').first}!',
                          style: Theme.of(context).textTheme.headlineSmall,
                        ),
                        Text(
                          'Continue sua jornada de aprendizado',
                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.primary,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.star, color: Colors.white, size: 16),
                          const SizedBox(width: 4),
                          Text(
                            '${user.points}',
                            style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                Row(
                  children: [
                    Expanded(
                      child: DashboardCard(
                        title: 'Perfil Completo',
                        value: '${user.profileCompleteness.toInt()}%',
                        icon: Icons.person,
                        color: Colors.green,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: DashboardCard(
                        title: 'Habilidades',
                        value: '${user.skills.length}',
                        icon: Icons.build,
                        color: Colors.blue,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                const ProgressChart(),
                const SizedBox(height: 24),
                Text(
                  'Trilhas Recomendadas',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: 16),
                ...recommendedPaths.map((path) => Padding(
                  padding: const EdgeInsets.only(bottom: 16),
                  child: LearningPathCard(path: path),
                )),
              ],
            ),
          ),
        );
      },
    );
  }
}