class ProjectModel {
  int? id;
  String name;
  String description;
  String status;


  ProjectModel({
    this.id,
    required this.name,
    required this.description,
    required this.status,
  });

  // Convert JSON to Task Model
  factory ProjectModel. fromJson(Map<String, dynamic> json) {
    return ProjectModel(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      status: json['status']
    );
  }

  // Convert Task Model to Json
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {
      'name': name,
      'description': description,
      'status': status,
    };
    return data;
  }
}


