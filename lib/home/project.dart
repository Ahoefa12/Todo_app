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
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  String _selectedStatus = 'Tous';

  @override
  void initState() {
    super.initState();
    final projectProvider = Provider.of<ProjectProvider>(context, listen: false);
    projectProvider.fetchProjects();
  }

  @override
  Widget build(BuildContext context) {
    final projectProvider = Provider.of<ProjectProvider>(context);
    final allProjects = projectProvider.projects;

    final allStatuses = allProjects.map((p) => p.status).toSet().toList();
    allStatuses.sort();
    final statusOptions = ['Tous', ...allStatuses];

    final filteredProjects = allProjects.where((project) {
      final matchesSearch = project.name.toLowerCase().contains(_searchQuery.toLowerCase());
      final matchesStatus = _selectedStatus == 'Tous' || project.status == _selectedStatus;
      return matchesSearch && matchesStatus;
    }).toList();

    return Scaffold(
      appBar: AppBar(title: const Text("Projets")),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _searchController,
              decoration: const InputDecoration(
                labelText: "Rechercher par nom",
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(),
              ),
              onChanged: (value) {
                setState(() {
                  _searchQuery = value;
                });
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: DropdownButtonFormField<String>(
              value: _selectedStatus,
              decoration: const InputDecoration(
                labelText: "Filtrer par statut",
                border: OutlineInputBorder(),
              ),
              items: statusOptions
                  .map((status) => DropdownMenuItem(value: status, child: Text(status)))
                  .toList(),
              onChanged: (value) {
                setState(() {
                  _selectedStatus = value!;
                });
              },
            ),
          ),
          const SizedBox(height: 8),
          Expanded(
            child: filteredProjects.isEmpty
                ? const Center(child: Text('Aucun projet trouvé'))
                : ListView.builder(
                    itemCount: filteredProjects.length,
                    itemBuilder: (context, index) {
                      final project = filteredProjects[index];
                      return ListTile(
                        leading: const Icon(Icons.folder),
                        title: Text(project.name),
                        subtitle: Text(project.description),
                        trailing: IconButton(
                          icon: const Icon(Icons.info_outline),
                          onPressed: () => _showProjectDetailsDialog(project),
                        ),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => TaskScreen(projectId: project.id!),
                            ),
                          );
                        },
                      );
                    },
                  ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () => _showCreateProjectDialog(context),
      ),
    );
  }

  void _showCreateProjectDialog(BuildContext context) {
    final _formKey = GlobalKey<FormState>();
    final nameController = TextEditingController();
    final descController = TextEditingController();
    final statusController = TextEditingController();
    final projectProvider = Provider.of<ProjectProvider>(context, listen: false);

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
                controller: nameController,
                decoration: const InputDecoration(labelText: "Nom du projet", border: OutlineInputBorder()),
                validator: (value) => value == null || value.trim().isEmpty ? "Veuillez entrer un nom" : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: descController,
                decoration: const InputDecoration(labelText: "Description du projet", border: OutlineInputBorder()),
                validator: (value) => value == null || value.trim().isEmpty ? "Veuillez entrer une description" : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: statusController,
                decoration: const InputDecoration(labelText: "Statut du projet", border: OutlineInputBorder()),
                validator: (value) => value == null || value.trim().isEmpty ? "Veuillez entrer un statut" : null,
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
                final newProject = ProjectModel(
                  name: nameController.text.trim(),
                  description: descController.text.trim(),
                  status: statusController.text.trim(),
                );
                await projectProvider.addProject(newProject);
                Navigator.of(context).pop();
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("Projet créé avec succès")),
                );
              }
            },
          ),
        ],
      ),
    );
  }

  void _showProjectDetailsDialog(ProjectModel project) {
  final projectProvider = Provider.of<ProjectProvider>(context, listen: false);
  final nameController = TextEditingController(text: project.name);
  final descController = TextEditingController(text: project.description);
  final statusController = TextEditingController(text: project.status);
  final _formKey = GlobalKey<FormState>();

  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: const Text("Modifier le projet"),
      content: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextFormField(
              controller: nameController,
              decoration: const InputDecoration(labelText: "Nom"),
              validator: (value) => value == null || value.trim().isEmpty ? "Champ requis" : null,
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: descController,
              decoration: const InputDecoration(labelText: "Description"),
              validator: (value) => value == null || value.trim().isEmpty ? "Champ requis" : null,
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: statusController,
              decoration: const InputDecoration(labelText: "Statut"),
              validator: (value) => value == null || value.trim().isEmpty ? "Champ requis" : null,
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          child: const Text("Supprimer", style: TextStyle(color: Colors.red)),
          onPressed: () async {
            final confirm = await showDialog<bool>(
              context: context,
              builder: (context) => AlertDialog(
                title: const Text("Confirmer la suppression"),
                content: const Text("Voulez-vous vraiment supprimer ce projet ?"),
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
              await projectProvider.deleteProject(project);
              Navigator.of(context).pop();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("Projet supprimé")),
              );
            }
          },
        ),
        TextButton(
          child: const Text("Annuler"),
          onPressed: () => Navigator.of(context).pop(),
        ),
        ElevatedButton(
          child: const Text("Enregistrer"),
          onPressed: () async {
            if (_formKey.currentState!.validate()) {
              final updatedProject = ProjectModel(
                id: project.id,
                name: nameController.text.trim(),
                description: descController.text.trim(),
                status: statusController.text.trim(),
              );
              await projectProvider.updateProject(updatedProject);
              Navigator.of(context).pop();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("Projet modifié avec succès")),
              );
            }
          },
        ),
      ],
    ),
  );
}
}
      