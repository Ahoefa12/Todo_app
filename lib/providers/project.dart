import 'package:flutter/material.dart';
import 'package:todo_app/models/project.dart';
import 'package:todo_app/services/project.dart';

class ProjectProvider with ChangeNotifier {
  final ProjectService _projectService = ProjectService();
  List<ProjectModel> _projects = [];

  List<ProjectModel> get projects => _projects;

  Future<void> fetchProjects() async {
    _projects = await _projectService.getProjects();
    notifyListeners();
  }

  Future<void> addProject(ProjectModel project) async {
    await _projectService.addProjects(project);
    fetchProjects();
    notifyListeners();
  }
  Future<void> updateProject(ProjectModel project) async {
    await _projectService.updateProjects(project);
    fetchProjects();
    notifyListeners();
  }
  Future<void> deleteProject(ProjectModel project) async {
    await _projectService.deleteProjects(project);
    fetchProjects();
    
  }
}

