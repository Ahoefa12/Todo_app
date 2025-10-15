import 'package:flutter/material.dart';
import 'package:todo_app/models/task.dart';
import 'package:todo_app/services/task.dart';

class TaskProvider with ChangeNotifier {
  final TaskService _taskService = TaskService();
  List<TaskModel> _tasks = [];

  List<TaskModel> get tasks => _tasks;

  // Future<void> fetchTasks() async {
  //   _tasks = await _taskService.getTasks();
  //   notifyListeners();
  // }
  Future<void> fetchTasks(int projectId) async {
    // _isLoading = true;
    notifyListeners();

    _tasks = await _taskService.fetchTasksByProject(projectId);

    // _isLoading = false;
    notifyListeners();
  }

  Future<void> addTask(TaskModel task) async {
    await _taskService.addTask(task);
    notifyListeners();
  }

  Future<void> updateTask(TaskModel task) async {
    await _taskService.updateTask(task);
    notifyListeners();
  }

 

  Future<void> deleteTask(TaskModel task) async {
    await _taskService.deleteTask(task);
    // fetchTasks(int projectId);
  }
}
