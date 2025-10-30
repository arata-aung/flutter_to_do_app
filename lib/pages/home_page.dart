import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:to_do_app/data/auth_service.dart';
import 'package:to_do_app/data/database.dart';
import 'package:to_do_app/pages/login_page.dart';
import 'package:to_do_app/util/dialog_box.dart';
import 'package:to_do_app/util/todo_tile.dart';
import 'package:to_do_app/util/group_tile.dart';
import 'package:to_do_app/util/group_dialog.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _myBox = Hive.box('mybox');
  ToDoDatabase db = ToDoDatabase();
  final _authService = AuthService();
  int? selectedGroupIndex;

  @override
  void initState() {
    super.initState();
    if (_myBox.get("TODOLIST") == null && _myBox.get("GROUPS") == null) {
      db.createInitialData();
    } else {
      db.loadData();
    }
    db.updateDatabase();
  }

  final _controller = TextEditingController();
  final _groupController = TextEditingController();

  void checkBoxChanged(bool? value, int index) {
    setState(() {
      db.toDoList[index]['completed'] = !db.toDoList[index]['completed'];
    });
    db.updateDatabase();
  }

  void saveNewTask(String color) {
    if (_controller.text.trim().isEmpty) {
      return;
    }
    setState(() {
      db.toDoList.add({
        'name': _controller.text,
        'completed': false,
        'color': color,
        'groupIndex': selectedGroupIndex ?? (db.groups.isNotEmpty ? 0 : -1),
        'subNotes': [],
      });
      _controller.clear();
    });
    Navigator.of(context).pop();
    db.updateDatabase();
  }

  void createNewTask() {
    // Show group selection dialog if there are groups
    if (db.groups.isNotEmpty) {
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            title: const Text('Select Group'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ...db.groups.asMap().entries.map((entry) {
                  final idx = entry.key;
                  final group = entry.value;
                  return ListTile(
                    title: Text(group['name']),
                    leading: Radio<int>(
                      value: idx,
                      groupValue: selectedGroupIndex,
                      onChanged: (value) {
                        setState(() {
                          selectedGroupIndex = value;
                        });
                        Navigator.of(context).pop();
                        _showTaskDialog();
                      },
                    ),
                  );
                }).toList(),
              ],
            ),
          );
        },
      );
    } else {
      _showTaskDialog();
    }
  }

  void _showTaskDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return DialogBox(
          controller: _controller,
          onSave: saveNewTask,
          onCancel: () => Navigator.of(context).pop(),
        );
      },
    );
  }

  void deleteTask(int index) {
    setState(() {
      db.toDoList.removeAt(index);
    });
    db.updateDatabase();
  }

  void changeTaskColor(int index, String newColor) {
    setState(() {
      db.toDoList[index]['color'] = newColor;
    });
    db.updateDatabase();
  }

  void addSubNote(int taskIndex, String subNoteName) {
    setState(() {
      if (db.toDoList[taskIndex]['subNotes'] == null) {
        db.toDoList[taskIndex]['subNotes'] = [];
      }
      db.toDoList[taskIndex]['subNotes'].add({
        'name': subNoteName,
        'completed': false,
      });
    });
    db.updateDatabase();
  }

  void toggleSubNote(int taskIndex, int subNoteIndex, bool completed) {
    setState(() {
      db.toDoList[taskIndex]['subNotes'][subNoteIndex]['completed'] = completed;
    });
    db.updateDatabase();
  }

  void deleteSubNote(int taskIndex, int subNoteIndex) {
    setState(() {
      db.toDoList[taskIndex]['subNotes'].removeAt(subNoteIndex);
    });
    db.updateDatabase();
  }

  void toggleGroupExpansion(int groupIndex) {
    setState(() {
      db.groups[groupIndex]['expanded'] = !db.groups[groupIndex]['expanded'];
    });
    db.updateDatabase();
  }

  void createNewGroup() {
    _groupController.clear();
    
    showDialog(
      context: context,
      builder: (context) {
        return GroupDialog(
          controller: _groupController,
          onSave: (icon, color) {
            if (_groupController.text.trim().isEmpty) {
              return;
            }
            setState(() {
              db.groups.add({
                'name': _groupController.text,
                'icon': icon,
                'color': color,
                'expanded': true,
              });
            });
            Navigator.of(context).pop();
            db.updateDatabase();
          },
          onCancel: () => Navigator.of(context).pop(),
        );
      },
    );
  }

  void editGroup(int index) {
    _groupController.text = db.groups[index]['name'];
    
    showDialog(
      context: context,
      builder: (context) {
        return GroupDialog(
          controller: _groupController,
          initialIcon: db.groups[index]['icon'],
          initialColor: db.groups[index]['color'],
          onSave: (icon, color) {
            if (_groupController.text.trim().isEmpty) {
              return;
            }
            setState(() {
              db.groups[index]['name'] = _groupController.text;
              db.groups[index]['icon'] = icon;
              db.groups[index]['color'] = color;
            });
            Navigator.of(context).pop();
            db.updateDatabase();
          },
          onCancel: () => Navigator.of(context).pop(),
        );
      },
    );
  }

  void deleteGroup(int index) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: const Text('Delete Group?'),
          content: Text('This will delete all tasks in "${db.groups[index]['name']}" group.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  // Remove all tasks in this group
                  db.toDoList.removeWhere((task) => task['groupIndex'] == index);
                  // Update groupIndex for tasks after this group
                  for (var task in db.toDoList) {
                    if (task['groupIndex'] > index) {
                      task['groupIndex']--;
                    }
                  }
                  db.groups.removeAt(index);
                });
                Navigator.of(context).pop();
                db.updateDatabase();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
              ),
              child: const Text('Delete'),
            ),
          ],
        );
      },
    );
  }

  void _logout() async {
    await _authService.logout();
    if (mounted) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => const LoginPage()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final currentUser = _authService.getCurrentUser();
    
    // Build list of widgets based on groups
    List<Widget> buildTaskList() {
      List<Widget> widgets = [];
      
      if (db.groups.isEmpty) {
        // No groups - show all tasks
        for (int i = 0; i < db.toDoList.length; i++) {
          final task = db.toDoList[i];
          widgets.add(
            ToDoTile(
              taskName: task['name'] ?? '',
              taskCompleted: task['completed'] ?? false,
              taskColor: task['color'] ?? 'yellow',
              subNotes: task['subNotes'] ?? [],
              onChanged: (value) => checkBoxChanged(value, i),
              deleteFunction: (context) => deleteTask(i),
              onColorChanged: (color) => changeTaskColor(i, color),
              onAddSubNote: (subNote) => addSubNote(i, subNote),
              onSubNoteChanged: (subIdx, completed) => toggleSubNote(i, subIdx, completed),
              onDeleteSubNote: (subIdx) => deleteSubNote(i, subIdx),
            ),
          );
        }
      } else {
        // Show groups with tasks
        for (int groupIdx = 0; groupIdx < db.groups.length; groupIdx++) {
          final group = db.groups[groupIdx];
          final isExpanded = group['expanded'] ?? true;
          
          widgets.add(
            GroupTile(
              groupName: group['name'] ?? 'Group',
              icon: group['icon'] ?? 'person',
              color: group['color'] ?? 'blue',
              expanded: isExpanded,
              onTap: () => toggleGroupExpansion(groupIdx),
              onDelete: (context) => deleteGroup(groupIdx),
              onEdit: (context) => editGroup(groupIdx),
            ),
          );
          
          if (isExpanded) {
            // Show tasks in this group
            for (int i = 0; i < db.toDoList.length; i++) {
              final task = db.toDoList[i];
              if (task['groupIndex'] == groupIdx) {
                widgets.add(
                  ToDoTile(
                    taskName: task['name'] ?? '',
                    taskCompleted: task['completed'] ?? false,
                    taskColor: task['color'] ?? 'yellow',
                    subNotes: task['subNotes'] ?? [],
                    onChanged: (value) => checkBoxChanged(value, i),
                    deleteFunction: (context) => deleteTask(i),
                    onColorChanged: (color) => changeTaskColor(i, color),
                    onAddSubNote: (subNote) => addSubNote(i, subNote),
                    onSubNoteChanged: (subIdx, completed) => toggleSubNote(i, subIdx, completed),
                    onDeleteSubNote: (subIdx) => deleteSubNote(i, subIdx),
                  ),
                );
              }
            }
          }
        }
      }
      
      return widgets;
    }
    
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: Text("My Tasks${currentUser != null ? ' - $currentUser' : ''}"),
        elevation: 0,
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.blue.shade400, Colors.blue.shade600],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
        actions: [
          if (db.groups.isNotEmpty)
            IconButton(
              icon: const Icon(Icons.create_new_folder),
              onPressed: createNewGroup,
              tooltip: 'Add Group',
            ),
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: _logout,
            tooltip: 'Logout',
          ),
        ],
      ),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          if (db.groups.isEmpty)
            FloatingActionButton(
              heroTag: 'addGroup',
              onPressed: createNewGroup,
              backgroundColor: Colors.orange,
              child: const Icon(Icons.create_new_folder),
            ),
          if (db.groups.isEmpty) const SizedBox(height: 16),
          FloatingActionButton(
            heroTag: 'addTask',
            onPressed: createNewTask,
            backgroundColor: Colors.blue,
            child: const Icon(Icons.add),
          ),
        ],
      ),
      body: db.toDoList.isEmpty && db.groups.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.task_alt,
                    size: 80,
                    color: Colors.grey[400],
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'No tasks yet!',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey[600],
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Create a group or add a task to get started',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey[500],
                    ),
                  ),
                ],
              ),
            )
          : ListView(
              padding: const EdgeInsets.only(bottom: 100, top: 20),
              children: buildTaskList(),
            ),
    );
  }
}
