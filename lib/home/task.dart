import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_app/providers/task.dart';

class TaskScreen extends StatefulWidget {
  final projectId;
  const TaskScreen({super.key, required this.projectId });

  @override
  State<TaskScreen> createState() => _TaskScreenState();
}

class _TaskScreenState extends State<TaskScreen> {
  @override
  void initState() {
    super.initState();
    // Appel de la récupération des catégories
    final taskProvider = Provider.of<TaskProvider>(
      context,
      listen: false,
    );
    taskProvider.fetchTasks(widget.projectId);
  }
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: Consumer<TaskProvider>(builder: (context, provider, child) {
            if (provider.tasks.isEmpty) {
              return Center(
                child: 
                  Text('Aucune tâche trouvée')
              );
            } else {
              return ListView.builder(
                itemCount: provider.tasks.length,
                itemBuilder: (context, index){
                  final project = provider.tasks[index];
                  return ListTile(
                    leading: Icon(Icons.person),
                    subtitle: Text(project.description),
                    trailing: Text(project.status),
                    title: Text(project.name),
                    onTap: () {
                      // Navigator.push(
                      //   context,
                      //   MaterialPageRoute(builder: (context)=>),
                      // );
                    },
                    // onLongPress: () {
                    //   _showDialog(context, project);
                    // },
                  );
                },
              );
            }
          },)
        )
      ],
    );
  }
}