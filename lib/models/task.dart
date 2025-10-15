class TaskModel {
  int? id;
  int project_id;
  String name;
  String description;
  String status;
  String deadline;


  TaskModel({
    this.id,
    required this.project_id,
    required this.name,
    required this.description,
    required this.status,
    required this.deadline,
  });

  // Convert JSON to Task Model
  factory TaskModel. fromJson(Map<String, dynamic> json) {
    return TaskModel(
      id: json['id'],
      project_id: json['project_id'],
      name: json['name'],
      description: json['description'],
      status: json['status'],
      deadline: json['deadline']
    );
  }

  // Convert Task Model to Json
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {
      'project_id': project_id,
      'name': name,
      'description': description,
      'status': status,
      'deadline': deadline,
    };
    return data;
  }
}


