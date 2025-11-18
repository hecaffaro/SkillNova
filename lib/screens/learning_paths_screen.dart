import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/learning_provider.dart';
import '../widgets/learning_path_card.dart';

class LearningPathsScreen extends StatefulWidget {
  const LearningPathsScreen({super.key});

  @override
  State<LearningPathsScreen> createState() => _LearningPathsScreenState();
}

class _LearningPathsScreenState extends State<LearningPathsScreen> {
  String _selectedCategory = 'Todos';
  final List<String> _categories = [
    'Todos',
    'Mobile Development',
    'Design',
    'Data Science',
    'Backend',
    'DevOps'
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Trilhas de Aprendizado'),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Consumer<LearningProvider>(
        builder: (context, learningProvider, child) {
          if (learningProvider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          final filteredPaths = _selectedCategory == 'Todos'
              ? learningProvider.learningPaths
              : learningProvider.learningPaths
                  .where((path) => path.category == _selectedCategory)
                  .toList();

          return Column(
            children: [
              Container(
                height: 50,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: _categories.length,
                  itemBuilder: (context, index) {
                    final category = _categories[index];
                    final isSelected = category == _selectedCategory;
                    
                    return Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: FilterChip(
                        label: Text(category),
                        selected: isSelected,
                        onSelected: (selected) {
                          setState(() {
                            _selectedCategory = category;
                          });
                        },
                        backgroundColor: Colors.grey[200],
                        selectedColor: Theme.of(context).colorScheme.primary,
                        labelStyle: TextStyle(
                          color: isSelected ? Colors.white : Colors.black87,
                        ),
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 16),
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemCount: filteredPaths.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 16),
                      child: LearningPathCard(path: filteredPaths[index]),
                    );
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}