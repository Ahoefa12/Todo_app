import 'package:dio/dio.dart';
import 'package:todo_app/models/project.dart';

class ProjectService {
  // String token= "mytoken" ;
  final Dio _dio = Dio(BaseOptions(
    baseUrl: 'https://focuspro.dayal-enterprises.com/public/api',
    // baseUrl: 'http://127.0.0.1:8000/api',
    headers: {
      'Content-Type': 'application/json',
      // 'Authorization':'Bearer $token'
    }
  ));

  // get Tasks : READ
  Future<List<ProjectModel>> getProjects() async {
    try {
      final response = await _dio.get('/projects');
      print(response);
      return (response.data as List)
          .map((project) => ProjectModel.fromJson(project))
          .toList();
    } catch (e) {
      return [];
    }
  }

  // Add a new Task
  Future<void> addProjects(ProjectModel project) async {
    try {
      final response = await _dio.post('/projects', data: project.toJson());
      print("Projet créé : ${response.data}");

    } catch (e) {
      print("Erreur lors de la création : $e");
      
    }
  }
  Future<void> updateProjects(ProjectModel project) async {
    try {
      final response = await _dio.put('/projects/${project.id}', data: project.toJson());
      print("Projet modifié : ${response.data}");

    } catch (e) {
      print("Erreur lors de la modification : $e");
      
    }
  }
  Future<void> deleteProjects(ProjectModel project) async {
    try {
      final response = await _dio.delete('/projects/${project.id}', data: project.toJson());
      print("Projet supprimé : ${response.data}");

    } catch (e) {
      print("Erreur lors de la suppression : $e");
      
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

