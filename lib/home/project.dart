import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_app/home/task.dart';
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

  @override
  Widget build(BuildContext context) {
    return Column(
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
    );
  }
}
