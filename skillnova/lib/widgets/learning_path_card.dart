import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/learning_path_model.dart';
import '../providers/learning_provider.dart';

class LearningPathCard extends StatelessWidget {
  final LearningPathModel path;

  const LearningPathCard({super.key, required this.path});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      child: InkWell(
        onTap: () => _showPathDetails(context),
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      path.title,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  if (path.isRecommended)
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.orange,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Text(
                        'Recomendado',
                        style: TextStyle(color: Colors.white, fontSize: 12),
                      ),
                    ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                path.description,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Colors.grey[600],
                ),
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Icon(Icons.access_time, size: 16, color: Colors.grey[600]),
                  const SizedBox(width: 4),
                  Text('${path.estimatedHours}h'),
                  const SizedBox(width: 16),
                  Icon(Icons.signal_cellular_alt, size: 16, color: Colors.grey[600]),
                  const SizedBox(width: 4),
                  Text(path.difficulty),
                ],
              ),
              const SizedBox(height: 12),
              LinearProgressIndicator(
                value: path.progress,
                backgroundColor: Colors.grey[300],
                valueColor: AlwaysStoppedAnimation<Color>(
                  Theme.of(context).colorScheme.primary,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                '${(path.progress * 100).toInt()}% concluído',
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showPathDetails(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.7,
        maxChildSize: 0.9,
        minChildSize: 0.5,
        builder: (context, scrollController) => Container(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                path.title,
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              const SizedBox(height: 16),
              Text(path.description),
              const SizedBox(height: 16),
              Text(
                'Módulos:',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 8),
              Expanded(
                child: ListView.builder(
                  controller: scrollController,
                  itemCount: path.modules.length,
                  itemBuilder: (context, index) {
                    final module = path.modules[index];
                    return ListTile(
                      leading: Icon(
                        module.isCompleted ? Icons.check_circle : Icons.play_circle_outline,
                        color: module.isCompleted ? Colors.green : Colors.grey,
                      ),
                      title: Text(module.title),
                      subtitle: Text('${module.duration} min • ${module.type}'),
                      onTap: () => _startModule(context, module),
                    );
                  },
                ),
              ),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => _startPath(context),
                  child: Text(path.progress > 0 ? 'Continuar' : 'Iniciar Trilha'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _startPath(BuildContext context) {
    Provider.of<LearningProvider>(context, listen: false)
        .startLearningPath(path.id);
    Navigator.pop(context);
  }

  void _startModule(BuildContext context, ModuleModel module) {
    if (!module.isCompleted) {
      Provider.of<LearningProvider>(context, listen: false)
          .completeModule(path.id, module.id);
    }
  }
}