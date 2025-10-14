import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_app/providers/task.dart';

class TaskScreen extends StatefulWidget {
  final int projectId;

  const TaskScreen({super.key, required this.projectId});

  @override
  State<TaskScreen> createState() => _TaskScreenState();
}

class _TaskScreenState extends State<TaskScreen> {
  @override
  void initState() {
    super.initState();
    final taskProvider = Provider.of<TaskProvider>(context, listen: false);
    taskProvider.fetchTasks(widget.projectId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tâches du projet'),
        backgroundColor: Colors.green,
      ),
      body: Consumer<TaskProvider>(
        builder: (context, provider, child) {
          if (provider.tasks.isEmpty) {
            return const Center(child: Text('Aucune tâche trouvée'));
          } else {
            return ListView.builder(
              itemCount: provider.tasks.length,
              itemBuilder: (context, index) {
                final task = provider.tasks[index];
                return ListTile(
                  title: Text(task.name),
                  subtitle: Text(task.description),
                  trailing: Text(task.status),
                );
              },
            );
          }
        },
      ),
    );
  }
}
