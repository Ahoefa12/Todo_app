import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_app/models/task.dart';
import 'package:todo_app/providers/task.dart';

class TaskScreen extends StatefulWidget {
  final int projectId;

  const TaskScreen({super.key, required this.projectId});

  @override
  State<TaskScreen> createState() => _TaskScreenState();
}

class _TaskScreenState extends State<TaskScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  String _selectedStatus = 'Tous';

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final taskProvider = Provider.of<TaskProvider>(context, listen: false);
      taskProvider.fetchTasks(widget.projectId);
    });
  }

  void _showCreateTaskDialog(BuildContext context) {
    final _formKey = GlobalKey<FormState>();
    final TextEditingController _nameController = TextEditingController();
    final TextEditingController _descController = TextEditingController();
    final TextEditingController _statusController = TextEditingController();
    final TextEditingController _deadlineController = TextEditingController();
    final taskProvider = Provider.of<TaskProvider>(context, listen: false);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Créer une nouvelle tâche"),
        content: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  "Projet ID : ${widget.projectId}",
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _nameController,
                  decoration: const InputDecoration(
                    labelText: "Nom",
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) => value == null || value.trim().isEmpty
                      ? "Champ requis"
                      : null,
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _descController,
                  decoration: const InputDecoration(
                    labelText: "Description",
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) => value == null || value.trim().isEmpty
                      ? "Champ requis"
                      : null,
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _statusController,
                  decoration: const InputDecoration(
                    labelText: "Statut",
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) => value == null || value.trim().isEmpty
                      ? "Champ requis"
                      : null,
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _deadlineController,
                  readOnly: true,
                  decoration: const InputDecoration(
                    labelText: "Date limite",
                    border: OutlineInputBorder(),
                    suffixIcon: Icon(Icons.calendar_today),
                  ),
                  onTap: () async {
                    DateTime? picked = await showDatePicker(
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate: DateTime(2023),
                      lastDate: DateTime(2030),
                    );
                    if (picked != null) {
                      _deadlineController.text = picked
                          .toIso8601String()
                          .split('T')
                          .first;
                    }
                  },
                  validator: (value) => value == null || value.trim().isEmpty
                      ? "Champ requis"
                      : null,
                ),
              ],
            ),
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
                final newTask = TaskModel(
                  project_id: widget.projectId,
                  name: _nameController.text.trim(),
                  description: _descController.text.trim(),
                  status: _statusController.text.trim(),
                  deadline: _deadlineController.text.trim(),
                );
                await taskProvider.addTask(newTask);
                Navigator.of(context).pop();
              }
            },
          ),
        ],
      ),
    );
  }

  void _showEditTaskDialog(BuildContext context, TaskModel task) {
    final _formKey = GlobalKey<FormState>();
    final TextEditingController _nameController = TextEditingController(
      text: task.name,
    );
    final TextEditingController _descController = TextEditingController(
      text: task.description,
    );
    final TextEditingController _statusController = TextEditingController(
      text: task.status,
    );
    final TextEditingController _deadlineController = TextEditingController(
      text: task.deadline,
    );
    final taskProvider = Provider.of<TaskProvider>(context, listen: false);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Modifier la tâche"),
        content: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  controller: _nameController,
                  decoration: const InputDecoration(labelText: "Nom"),
                  validator: (value) => value == null || value.trim().isEmpty
                      ? "Champ requis"
                      : null,
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _descController,
                  decoration: const InputDecoration(labelText: "Description"),
                  validator: (value) => value == null || value.trim().isEmpty
                      ? "Champ requis"
                      : null,
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _statusController,
                  decoration: const InputDecoration(labelText: "Statut"),
                  validator: (value) => value == null || value.trim().isEmpty
                      ? "Champ requis"
                      : null,
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _deadlineController,
                  readOnly: true,
                  decoration: const InputDecoration(
                    labelText: "Date limite",
                    suffixIcon: Icon(Icons.calendar_today),
                  ),
                  onTap: () async {
                    DateTime? picked = await showDatePicker(
                      context: context,
                      initialDate:
                          DateTime.tryParse(task.deadline) ?? DateTime.now(),
                      firstDate: DateTime(2023),
                      lastDate: DateTime(2030),
                    );
                    if (picked != null) {
                      _deadlineController.text = picked
                          .toIso8601String()
                          .split('T')
                          .first;
                    }
                  },
                  validator: (value) => value == null || value.trim().isEmpty
                      ? "Champ requis"
                      : null,
                ),
              ],
            ),
          ),
        ),
        actions: [
          TextButton(
            child: const Text("Annuler"),
            onPressed: () => Navigator.of(context).pop(),
          ),
          ElevatedButton(
            child: const Text("Enregistrer"),
            onPressed: () async {
              if (_formKey.currentState!.validate()) {
                final updated = TaskModel(
                  id: task.id,
                  project_id: task.project_id,
                  name: _nameController.text.trim(),
                  description: _descController.text.trim(),
                  status: _statusController.text.trim(),
                  deadline: _deadlineController.text.trim(),
                );
                await taskProvider.updateTask(updated);
                Navigator.of(context).pop();
              }
            },
          ),
        ],
      ),
    );
  }

  void _showTaskDetailsDialog(TaskModel task) {
    final taskProvider = Provider.of<TaskProvider>(context, listen: false);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Détails de la tâche"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Nom : ${task.name}",
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text("Description : ${task.description}"),
            const SizedBox(height: 8),
            Text("Statut : ${task.status}"),
            const SizedBox(height: 8),
            Text("Date limite : ${task.deadline}"),
            const SizedBox(height: 8),
            Text("Projet ID : ${task.project_id}"),
          ],
        ),
        actions: [
          TextButton(
            child: const Text("Fermer"),
            onPressed: () => Navigator.of(context).pop(),
          ),
          TextButton(
            child: const Text("Modifier"),
            onPressed: () {
              Navigator.of(context).pop();
              _showEditTaskDialog(context, task);
            },
          ),
          TextButton(
            child: const Text("Supprimer", style: TextStyle(color: Colors.red)),
            onPressed: () async {
              final confirm = await showDialog<bool>(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text("Confirmer la suppression"),
                  content: const Text(
                    "Voulez-vous vraiment supprimer cette tâche ?",
                  ),
                  actions: [
                    TextButton(
                      child: const Text("Annuler"),
                      onPressed: () => Navigator.of(context).pop(false),
                    ),
                    TextButton(
                      child: const Text(
                        "Supprimer",
                        style: TextStyle(color: Colors.red),
                      ),
                      onPressed: () => Navigator.of(context).pop(true),
                    ),
                  ],
                ),
              );
              if (confirm == true) {
                await taskProvider.deleteTask(task);
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
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        title: const Text(
          'Tâches du projet',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: const Color.fromARGB(255, 12, 47, 75),
      ),
      body: Consumer<TaskProvider>(
        builder: (context, provider, child) {
          final allTasks = provider.tasks;

          // Filtrage des tâches
          final filteredTasks = allTasks.where((task) {
            final matchesSearch =
                task.name.toLowerCase().contains(_searchQuery.toLowerCase()) ||
                task.description.toLowerCase().contains(
                  _searchQuery.toLowerCase(),
                );
            final matchesStatus =
                _selectedStatus == 'Tous' || task.status == _selectedStatus;
            return matchesSearch && matchesStatus;
          }).toList();

          // Obtenir tous les statuts uniques
          final allStatuses = allTasks.map((t) => t.status).toSet().toList();
          allStatuses.sort();
          final statusOptions = ['Tous', ...allStatuses];

          return Column(
            children: [
              // Section de recherche et filtres
              Container(
                padding: EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 8,
                      offset: Offset(0, 2),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    // Barre de recherche
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.grey[50],
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.grey[300]!),
                      ),
                      child: TextField(
                        controller: _searchController,
                        decoration: InputDecoration(
                          hintText: "Rechercher une tâche...",
                          hintStyle: TextStyle(color: Colors.grey[500]),
                          prefixIcon: Icon(
                            Icons.search,
                            color: Colors.grey[500],
                          ),
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 12,
                          ),
                        ),
                        onChanged: (value) {
                          setState(() {
                            _searchQuery = value;
                          });
                        },
                      ),
                    ),
                    SizedBox(height: 12),
                    // Filtre par statut
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.grey[50],
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.grey[300]!),
                      ),
                      child: DropdownButtonFormField<String>(
                        value: _selectedStatus,
                        decoration: InputDecoration(
                          hintText: "Filtrer par statut",
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.symmetric(horizontal: 16),
                          prefixIcon: Icon(
                            Icons.filter_list,
                            color: Colors.grey[500],
                          ),
                        ),
                        dropdownColor: Colors.white,
                        items: statusOptions
                            .map(
                              (status) => DropdownMenuItem(
                                value: status,
                                child: Row(
                                  children: [
                                    Container(
                                      width: 8,
                                      height: 8,
                                      decoration: BoxDecoration(
                                        color: _getStatusColor(status),
                                        shape: BoxShape.circle,
                                      ),
                                    ),
                                    SizedBox(width: 12),
                                    Text(
                                      status,
                                      style: TextStyle(
                                        color: Colors.grey[700],
                                        fontWeight: status == _selectedStatus
                                            ? FontWeight.bold
                                            : FontWeight.normal,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            )
                            .toList(),
                        onChanged: (value) {
                          setState(() {
                            _selectedStatus = value!;
                          });
                        },
                      ),
                    ),
                  ],
                ),
              ),

              // Indicateur de résultats
              if (filteredTasks.isNotEmpty)
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  color: Colors.grey[100],
                  child: Row(
                    children: [
                      Text(
                        "${filteredTasks.length} tâche(s) trouvée(s)",
                        style: TextStyle(
                          color: Colors.grey[600],
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      Spacer(),
                      if (_searchQuery.isNotEmpty || _selectedStatus != 'Tous')
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              _searchController.clear();
                              _searchQuery = '';
                              _selectedStatus = 'Tous';
                            });
                          },
                          child: Text(
                            "Réinitialiser",
                            style: TextStyle(
                              color: Colors.blue,
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                    ],
                  ),
                ),

              // Liste des tâches
              Expanded(
                child: filteredTasks.isEmpty
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.assignment_outlined,
                              size: 80,
                              color: Colors.grey[300],
                            ),
                            SizedBox(height: 16),
                            Text(
                              'Aucune tâche trouvée',
                              style: TextStyle(
                                fontSize: 18,
                                color: Colors.grey[500],
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            SizedBox(height: 8),
                            Text(
                              _searchQuery.isEmpty && _selectedStatus == 'Tous'
                                  ? "Commencez par créer votre première tâche"
                                  : "Aucun résultat pour votre recherche",
                              style: TextStyle(
                                color: Colors.grey[400],
                                fontSize: 14,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      )
                    : ListView.builder(
                        itemCount: filteredTasks.length,
                        itemBuilder: (context, index) {
                          final task = filteredTasks[index];
                          return Container(
                            margin: EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(12),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black12,
                                  blurRadius: 4,
                                  offset: Offset(0, 2),
                                ),
                              ],
                            ),
                            child: ListTile(
                              contentPadding: EdgeInsets.all(16),
                              leading: Container(
                                padding: EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  color: _getTaskColor(
                                    task.name,
                                  ).withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Icon(
                                  Icons.assignment,
                                  color: _getTaskColor(task.name),
                                  size: 24,
                                ),
                              ),
                              title: Text(
                                task.name,
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                  color: Colors.grey[800],
                                ),
                              ),
                              subtitle: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  SizedBox(height: 4),
                                  Text(
                                    task.description,
                                    style: TextStyle(
                                      color: Colors.grey[600],
                                      fontSize: 14,
                                    ),
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  SizedBox(height: 6),
                                  Row(
                                    children: [
                                      Container(
                                        padding: EdgeInsets.symmetric(
                                          horizontal: 8,
                                          vertical: 4,
                                        ),
                                        decoration: BoxDecoration(
                                          color: _getStatusColor(
                                            task.status,
                                          ).withOpacity(0.1),
                                          borderRadius: BorderRadius.circular(
                                            6,
                                          ),
                                        ),
                                        child: Text(
                                          task.status,
                                          style: TextStyle(
                                            color: _getStatusColor(task.status),
                                            fontSize: 12,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ),
                                      SizedBox(width: 8),
                                      if (task.deadline.isNotEmpty)
                                        Container(
                                          padding: EdgeInsets.symmetric(
                                            horizontal: 8,
                                            vertical: 4,
                                          ),
                                          decoration: BoxDecoration(
                                            color: Colors.orange.withOpacity(
                                              0.1,
                                            ),
                                            borderRadius: BorderRadius.circular(
                                              6,
                                            ),
                                          ),
                                          child: Row(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              Icon(
                                                Icons.calendar_today,
                                                size: 12,
                                                color: Colors.orange,
                                              ),
                                              SizedBox(width: 4),
                                              Text(
                                                task.deadline,
                                                style: TextStyle(
                                                  color: Colors.orange,
                                                  fontSize: 12,
                                                  fontWeight: FontWeight.w500,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                    ],
                                  ),
                                ],
                              ),
                              trailing: Icon(
                                Icons.arrow_forward_ios,
                                color: Colors.grey[400],
                                size: 16,
                              ),
                              onTap: () => _showTaskDetailsDialog(task),
                            ),
                          );
                        },
                      ),
              ),
            ],
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color.fromARGB(255, 12, 47, 75),
        foregroundColor: Colors.white,
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: const Icon(Icons.add),
        onPressed: () => _showCreateTaskDialog(context),
      ),
    );
  }

  // Helper methods pour les couleurs
  Color _getStatusColor(String status) {
    if (status == 'Tous') return Colors.grey;
    switch (status.toLowerCase()) {
      case 'terminé':
        return Color(0xFF10B981);
      case 'en cours':
        return Color(0xFFF59E0B);
      case 'en attente':
        return Color(0xFF6B7280);
      default:
        return Color(0xFF6366F1);
    }
  }

  Color _getTaskColor(String taskName) {
    final colors = [
      Color(0xFF10B981),
      Color(0xFF6366F1),
      Color(0xFFF59E0B),
      Color(0xFFEF4444),
      Color(0xFF8B5CF6),
    ];
    final index = taskName.length % colors.length;
    return colors[index];
  }
}
