import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_app/models/task.dart';
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
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final taskProvider = Provider.of<TaskProvider>(context, listen: false);
      taskProvider.fetchTasks(widget.projectId);
    });
  }

  void _showCreateTaskDialog(BuildContext context) {
    final _formKey = GlobalKey<FormState>();
    final TextEditingController _nameController = TextEditingController();
    final TextEditingController _descController = TextEditingController();
    final TextEditingController _statusController = TextEditingController();
    final TextEditingController _deadlineController = TextEditingController();
    final taskProvider = Provider.of<TaskProvider>(context, listen: false);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Créer une nouvelle tâche"),
        content: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text("Projet ID : ${widget.projectId}", style: const TextStyle(fontWeight: FontWeight.bold)),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _nameController,
                  decoration: const InputDecoration(labelText: "Nom", border: OutlineInputBorder()),
                  validator: (value) => value == null || value.trim().isEmpty ? "Champ requis" : null,
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _descController,
                  decoration: const InputDecoration(labelText: "Description", border: OutlineInputBorder()),
                  validator: (value) => value == null || value.trim().isEmpty ? "Champ requis" : null,
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _statusController,
                  decoration: const InputDecoration(labelText: "Statut", border: OutlineInputBorder()),
                  validator: (value) => value == null || value.trim().isEmpty ? "Champ requis" : null,
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _deadlineController,
                  readOnly: true,
                  decoration: const InputDecoration(
                    labelText: "Date limite",
                    border: OutlineInputBorder(),
                    suffixIcon: Icon(Icons.calendar_today),
                  ),
                  onTap: () async {
                    DateTime? picked = await showDatePicker(
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate: DateTime(2023),
                      lastDate: DateTime(2030),
                    );
                    if (picked != null) {
                      _deadlineController.text = picked.toIso8601String().split('T').first;
                    }
                  },
                  validator: (value) => value == null || value.trim().isEmpty ? "Champ requis" : null,
                ),
              ],
            ),
          ),
        ),
        actions: [
          TextButton(
            child: const Text("Annuler"),
            onPressed: () => Navigator.of(context).pop(),
          ),
          ElevatedButton(
            child: const Text("Créer"),
            onPressed: () async {
              if (_formKey.currentState!.validate()) {
                final newTask = TaskModel(
                  project_id: widget.projectId,
                  name: _nameController.text.trim(),
                  description: _descController.text.trim(),
                  status: _statusController.text.trim(),
                  deadline: _deadlineController.text.trim(),
                );
                await taskProvider.addTask(newTask);
                Navigator.of(context).pop();
              }
            },
          ),
        ],
      ),
    );
  }

  void _showEditTaskDialog(BuildContext context, TaskModel task) {
    final _formKey = GlobalKey<FormState>();
    final TextEditingController _nameController = TextEditingController(text: task.name);
    final TextEditingController _descController = TextEditingController(text: task.description);
    final TextEditingController _statusController = TextEditingController(text: task.status);
    final TextEditingController _deadlineController = TextEditingController(text: task.deadline);
    final taskProvider = Provider.of<TaskProvider>(context, listen: false);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Modifier la tâche"),
        content: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  controller: _nameController,
                  decoration: const InputDecoration(labelText: "Nom"),
                  validator: (value) => value == null || value.trim().isEmpty ? "Champ requis" : null,
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _descController,
                  decoration: const InputDecoration(labelText: "Description"),
                  validator: (value) => value == null || value.trim().isEmpty ? "Champ requis" : null,
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _statusController,
                  decoration: const InputDecoration(labelText: "Statut"),
                  validator: (value) => value == null || value.trim().isEmpty ? "Champ requis" : null,
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _deadlineController,
                  readOnly: true,
                  decoration: const InputDecoration(
                    labelText: "Date limite",
                    suffixIcon: Icon(Icons.calendar_today),
                  ),
                  onTap: () async {
                    DateTime? picked = await showDatePicker(
                      context: context,
                      initialDate: DateTime.tryParse(task.deadline) ?? DateTime.now(),
                      firstDate: DateTime(2023),
                      lastDate: DateTime(2030),
                    );
                    if (picked != null) {
                      _deadlineController.text = picked.toIso8601String().split('T').first;
                    }
                  },
                  validator: (value) => value == null || value.trim().isEmpty ? "Champ requis" : null,
                ),
              ],
            ),
          ),
        ),
        actions: [
          TextButton(
            child: const Text("Annuler"),
            onPressed: () => Navigator.of(context).pop(),
          ),
          ElevatedButton(
            child: const Text("Enregistrer"),
            onPressed: () async {
              if (_formKey.currentState!.validate()) {
                final updated = TaskModel(
                  id: task.id,
                  project_id: task.project_id,
                  name: _nameController.text.trim(),
                  description: _descController.text.trim(),
                  status: _statusController.text.trim(),
                  deadline: _deadlineController.text.trim(),
                );
                await taskProvider.updateTask(updated);
                Navigator.of(context).pop();
              }
            },
          ),
        ],
      ),
    );
  }

  void _showTaskDetailsDialog(TaskModel task) {
    final taskProvider = Provider.of<TaskProvider>(context, listen: false);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Détails de la tâche"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Nom : ${task.name}", style: const TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Text("Description : ${task.description}"),
            const SizedBox(height: 8),
            Text("Statut : ${task.status}"),
            const SizedBox(height: 8),
            Text("Date limite : ${task.deadline}"),
            const SizedBox(height: 8),
            Text("Projet ID : ${task.project_id}"),
          ],
        ),
        actions: [
          TextButton(
            child: const Text("Fermer"),
            onPressed: () => Navigator.of(context).pop(),
          ),
          TextButton(
            child: const Text("Modifier"),
            onPressed: () {
              Navigator.of(context).pop();
              _showEditTaskDialog(context, task);
            },
          ),
          TextButton(
            child: const Text("Supprimer", style: TextStyle(color: Colors.red)),
            onPressed: () async {
              final confirm = await showDialog<bool>(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text("Confirmer la suppression"),
                  content: const Text("Voulez-vous vraiment supprimer cette tâche ?"),
                  actions: [
                    TextButton(
                      child: const Text("Annuler"),
                      onPressed: () => Navigator.of(context).pop(false),
                    ),
                    TextButton(
                      child: const Text("Supprimer", style: TextStyle(color: Colors.red)),
                      onPressed: () => Navigator.of(context).pop(true),
                    ),
                  ],
                ),
              );
              if (confirm == true) {
                await taskProvider.deleteTask(task);
                Navigator.of(context).pop();
              }
            },
          ),
        ],
      ),
    );
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

                  // trailing: Text(task.status),
                  title: Text(task.name),
                  subtitle: Text(task.description),
                  trailing: Text(task.status),
                  onTap: () => _showTaskDetailsDialog(task),
                );
              },
            );
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () => _showCreateTaskDialog(context),
      ),
    );
  }
}

                
