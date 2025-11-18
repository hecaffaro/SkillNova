import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import '../providers/user_provider.dart';
import '../models/user_model.dart';
import 'account_settings_screen.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Perfil'),
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () => _showEditProfile(context),
          ),
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const AccountSettingsScreen()),
              );
            },
          ),
        ],
      ),
      body: Consumer<UserProvider>(
        builder: (context, userProvider, child) {
          final user = userProvider.user;
          
          if (user == null) {
            return const Center(child: CircularProgressIndicator());
          }

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                CircleAvatar(
                  radius: 50,
                  backgroundColor: Theme.of(context).colorScheme.primary,
                  child: Text(
                    user.name.substring(0, 2).toUpperCase(),
                    style: const TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  user.name,
                  style: GoogleFonts.poppins(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  user.email,
                  style: GoogleFonts.poppins(
                    color: Colors.grey[600],
                    fontSize: 16,
                  ),
                ),
                if (user.currentRole.isNotEmpty)
                  Text(
                    user.currentRole,
                    style: GoogleFonts.poppins(
                      color: Colors.blue[600],
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                const SizedBox(height: 24),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withValues(alpha: 0.1),
                        spreadRadius: 1,
                        blurRadius: 6,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Completude do Perfil',
                        style: GoogleFonts.poppins(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 8),
                      LinearProgressIndicator(
                        value: user.profileCompleteness / 100,
                        backgroundColor: Colors.grey[300],
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.blue[600]!),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            '${user.profileCompleteness.toInt()}% completo',
                            style: GoogleFonts.poppins(fontSize: 14),
                          ),
                          Text(
                            '${user.points} pontos',
                            style: GoogleFonts.poppins(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: Colors.orange[600],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                _buildInfoCard(
                  context,
                  'Habilidades',
                  user.skills.isNotEmpty ? user.skills.join(', ') : 'Adicione suas habilidades',
                  Icons.build,
                ),
                const SizedBox(height: 16),
                _buildInfoCard(
                  context,
                  'Interesses',
                  user.interests.isNotEmpty ? user.interests.join(', ') : 'Adicione seus interesses',
                  Icons.favorite,
                ),
                const SizedBox(height: 16),
                _buildInfoCard(
                  context,
                  'Experiência',
                  user.experienceYears > 0 ? '${user.experienceYears} anos' : 'Adicione sua experiência',
                  Icons.work,
                ),
                const SizedBox(height: 16),
                _buildInfoCard(
                  context,
                  'Nível de Educação',
                  user.educationLevel.isNotEmpty ? user.educationLevel : 'Adicione seu nível de educação',
                  Icons.school,
                ),
                const SizedBox(height: 16),
                _buildInfoCard(
                  context,
                  'Conquistas',
                  user.achievements.isNotEmpty 
                      ? user.achievements.join(', ')
                      : 'Nenhuma conquista ainda',
                  Icons.emoji_events,
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildInfoCard(BuildContext context, String title, String content, IconData icon) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withValues(alpha: 0.1),
            spreadRadius: 1,
            blurRadius: 6,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: Theme.of(context).colorScheme.primary),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: GoogleFonts.poppins(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  content,
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _showEditProfile(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    final user = userProvider.user!;
    
    final nameController = TextEditingController(text: user.name);
    final roleController = TextEditingController(text: user.currentRole);
    final skillsController = TextEditingController(text: user.skills.join(', '));
    final interestsController = TextEditingController(text: user.interests.join(', '));
    final experienceController = TextEditingController(text: user.experienceYears.toString());
    final educationController = TextEditingController(text: user.educationLevel);

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.8,
        maxChildSize: 0.9,
        minChildSize: 0.5,
        builder: (context, scrollController) => Container(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Editar Perfil',
                style: GoogleFonts.poppins(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              Expanded(
                child: SingleChildScrollView(
                  controller: scrollController,
                  child: Column(
                    children: [
                      TextField(
                        controller: nameController,
                        decoration: const InputDecoration(
                          labelText: 'Nome',
                          border: OutlineInputBorder(),
                        ),
                      ),
                      const SizedBox(height: 16),
                      TextField(
                        controller: roleController,
                        decoration: const InputDecoration(
                          labelText: 'Cargo Atual',
                          border: OutlineInputBorder(),
                        ),
                      ),
                      const SizedBox(height: 16),
                      TextField(
                        controller: skillsController,
                        decoration: const InputDecoration(
                          labelText: 'Habilidades (separadas por vírgula)',
                          border: OutlineInputBorder(),
                        ),
                        maxLines: 2,
                      ),
                      const SizedBox(height: 16),
                      TextField(
                        controller: interestsController,
                        decoration: const InputDecoration(
                          labelText: 'Interesses (separados por vírgula)',
                          border: OutlineInputBorder(),
                        ),
                        maxLines: 2,
                      ),
                      const SizedBox(height: 16),
                      TextField(
                        controller: experienceController,
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(
                          labelText: 'Anos de Experiência',
                          border: OutlineInputBorder(),
                        ),
                      ),
                      const SizedBox(height: 16),
                      TextField(
                        controller: educationController,
                        decoration: const InputDecoration(
                          labelText: 'Nível de Educação',
                          border: OutlineInputBorder(),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    final updatedUser = UserModel(
                      id: user.id,
                      name: nameController.text,
                      email: user.email,
                      currentRole: roleController.text,
                      skills: skillsController.text.split(',').map((s) => s.trim()).where((s) => s.isNotEmpty).toList(),
                      interests: interestsController.text.split(',').map((s) => s.trim()).where((s) => s.isNotEmpty).toList(),
                      experienceYears: int.tryParse(experienceController.text) ?? 0,
                      educationLevel: educationController.text,
                      profileCompleteness: user.profileCompleteness,
                      points: user.points,
                      achievements: user.achievements,
                    );
                    
                    userProvider.updateProfile(updatedUser);
                    userProvider.updateProfileCompleteness();
                    Navigator.pop(context);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue[600],
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                  child: Text(
                    'Salvar',
                    style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }


}