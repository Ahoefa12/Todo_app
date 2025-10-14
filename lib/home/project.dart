import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_app/home/task.dart';
import 'package:todo_app/models/project.dart';
import 'package:todo_app/providers/project.dart';

class ProjectScreen extends StatefulWidget {
  const ProjectScreen({super.key});

  @override
  State<ProjectScreen> createState() => _ProjectScreenState();
}

class _ProjectScreenState extends State<ProjectScreen> {
  @override
  void initState() {
    super.initState();
    // Appel de la récupération des catégories
    final projectProvider = Provider.of<ProjectProvider>(
      context,
      listen: false,
    );
    projectProvider.fetchProjects();
  }

  void _showCreateProjectDialog(BuildContext context) {
    final _formKey = GlobalKey<FormState>();
    final TextEditingController _projectNameController =
        TextEditingController();
    final TextEditingController _projectDescriptionController =
        TextEditingController();
    final TextEditingController _projectStatusController =
        TextEditingController();
    final projectProvider = Provider.of<ProjectProvider>(
      context,
      listen: false,
    );

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Créer un nouveau projet"),
        content: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: _projectNameController,
                decoration: const InputDecoration(
                  labelText: "Nom du projet",
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return "Veuillez entrer un nom";
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _projectDescriptionController,
                decoration: const InputDecoration(
                  labelText: "Nom du description",
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return "Veuillez entrer une description";
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _projectStatusController,
                decoration: const InputDecoration(
                  labelText: "Statut du projet",
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return "Veuillez entrer un statut";
                  }
                  return null;
                },
              ),
            ],
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
                final projectName = _projectNameController.text.trim();
                final projectDescription = _projectDescriptionController.text
                    .trim();
                final projectStatus = _projectStatusController.text.trim();
                final newproject = ProjectModel(
                  name: projectName,
                  description: projectDescription,
                  status: projectStatus,
                );

                await projectProvider.addProject(newproject);
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
      appBar: AppBar(),
      body: Column(
        children: [
          Expanded(
            child: Consumer<ProjectProvider>(
              builder: (context, provider, child) {
                if (provider.projects.isEmpty) {
                  return Center(child: Text('Aucun projet trouvé'));
                } else {
                  return ListView.builder(
                    itemCount: provider.projects.length,
                    itemBuilder: (context, index) {
                      final project = provider.projects[index];
                      return ListTile(
                        leading: Icon(Icons.person),
                        subtitle: Text(project.description),
                        trailing: Text(project.status),
                        title: Text(project.name),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  TaskScreen(projectId: project.id!),
                            ),
                          );
                        },
                        // onLongPress: () {
                        //   _showDialog(context, project);
                        // },
                      );
                    },
                  );
                }
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: ()=>_showCreateProjectDialog(context),
      ),
    );
  }
}
