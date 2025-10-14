import 'package:dio/dio.dart';
import 'package:todo_app/models/task.dart';

class TaskService {
  // String token= "mytoken" ;
  final Dio _dio = Dio(
    BaseOptions(
      baseUrl: 'http://127.0.0.1:8000/api',
      headers: {
        'Content-Type': 'application/json',
        // 'Authorization':'Bearer $token'
      },
    ),
  );

  // get Tasks : READ
  Future<List<TaskModel>> getTasks() async {
    try {
      final response = await _dio.get('/tasks');
      print(response);
      return (response.data as List)
          .map((task) => TaskModel.fromJson(task))
          .toList();
    } catch (e) {
      return [];
    }
  }

  // Add a new Task
  Future<void> addTask(TaskModel task) async {
    try {
      final response = await _dio.post('/tasks', data: task.toJson());
      print("Tâche créée : ${response.data}");
    } catch (e) {
      print("Erreur lors de la création : $e");
    }
  }

  Future<void> updateTask(TaskModel task) async {
    try {
      final response = await _dio.put('/tasks/${task.id}', data: task.toJson());
      print("Tâche modifiée : ${response.data}");
    } catch (e) {
      print("Erreur lors de la modification : $e");
    }
  }

  Future<void> deleteTask(TaskModel task) async {
    try {
      final response = await _dio.delete(
        '/tasks/${task.id}',
        data: task.toJson(),
      );
      print("Tâche supprimée : ${response.data}");
    } catch (e) {
      print("Erreur lors de la suppression : $e");
    }
  }

  Future<List<TaskModel>> fetchTasksByProject(int projectId) async {
    try {
      final response = await _dio.get('/projects/$projectId');
      final data = response.data;

      // Vérifie que "tasks" existe bien dans la réponse
      final List<dynamic> tasksJson = data['data']['tasks'];

      return tasksJson.map((task) => TaskModel.fromJson(task)).toList();
    } catch (e) {
      print('Erreur fetchTasksByProject: $e');
      return [];
    }
  }
  // Future<List<ProjectModel>> showProjects(ProjectModel project) async {
  //   try {
  //     final response = await _dio.get('/projects/${project.id}', data: project.toJson());
  //     print("Projet modifié : ${response.data}");
  //     return response;

  //   } catch (e) {
  //     print("Erreur lors de la modification : $e");

  //   }
  // }
}
