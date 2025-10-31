import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:to_do_app/data/auth_service.dart';
import 'package:to_do_app/data/database.dart';
import 'package:to_do_app/pages/login_page.dart';
import 'package:to_do_app/util/dialog_box.dart';
import 'package:to_do_app/util/todo_tile.dart';
import 'package:to_do_app/util/group_tile.dart';
import 'package:to_do_app/util/group_dialog.dart';
import 'package:to_do_app/util/color_utils.dart';

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
  
  // Filter and sort state
  String _filterStatus = 'all'; // 'all', 'completed', 'incomplete'
  String? _filterColor; // null = all colors
  String _sortBy = 'none'; // 'none', 'name', 'completed'

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

  void saveNewTask(String color, DateTime? dueDate, TimeOfDay? dueTime) {
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
        'dueDate': dueDate?.toIso8601String(),
        'dueTime': dueTime != null ? _formatTimeOfDay(dueTime) : null,
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
        'color': 'yellow',  // Default color for new sub-notes
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

  void changeSubNoteColor(int taskIndex, int subNoteIndex, String newColor) {
    setState(() {
      if (db.toDoList[taskIndex]['subNotes'][subNoteIndex] is Map) {
        db.toDoList[taskIndex]['subNotes'][subNoteIndex]['color'] = newColor;
      }
    });
    db.updateDatabase();
  }

  TimeOfDay? _parseTimeOfDay(String? timeString) {
    if (timeString == null) return null;
    try {
      final parts = timeString.split(':');
      if (parts.length != 2) return null;
      final hour = int.parse(parts[0]);
      final minute = int.parse(parts[1]);
      if (hour < 0 || hour > 23 || minute < 0 || minute > 59) return null;
      return TimeOfDay(hour: hour, minute: minute);
    } catch (e) {
      return null;
    }
  }

  String _formatTimeOfDay(TimeOfDay time) {
    return '${time.hour}:${time.minute.toString().padLeft(2, '0')}';
  }

  void editTaskDateTime(int taskIndex) {
    final task = db.toDoList[taskIndex];
    DateTime? currentDate;
    TimeOfDay? currentTime;
    
    if (task['dueDate'] != null) {
      try {
        currentDate = DateTime.parse(task['dueDate']);
      } catch (e) {
        currentDate = null;
      }
    }
    
    if (task['dueTime'] != null) {
      currentTime = _parseTimeOfDay(task['dueTime']);
    }
    
    showDialog(
      context: context,
      builder: (context) {
        DateTime? selectedDate = currentDate;
        TimeOfDay? selectedTime = currentTime;
        
        return StatefulBuilder(
          builder: (context, setDialogState) {
            Future<void> selectDate() async {
              final DateTime? picked = await showDatePicker(
                context: context,
                initialDate: selectedDate ?? DateTime.now(),
                firstDate: DateTime(2000),
                lastDate: DateTime(2100),
              );
              if (picked != null) {
                setDialogState(() {
                  selectedDate = picked;
                });
              }
            }

            Future<void> selectTime() async {
              final TimeOfDay? picked = await showTimePicker(
                context: context,
                initialTime: selectedTime ?? TimeOfDay.now(),
              );
              if (picked != null) {
                setDialogState(() {
                  selectedTime = picked;
                });
              }
            }
            
            return AlertDialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              title: const Text('Edit Due Date & Time'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: selectDate,
                          icon: const Icon(Icons.calendar_today),
                          label: Text(
                            selectedDate != null
                                ? '${selectedDate!.month}/${selectedDate!.day}/${selectedDate!.year}'
                                : 'Select Date',
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      if (selectedDate != null)
                        IconButton(
                          icon: const Icon(Icons.close),
                          onPressed: () {
                            setDialogState(() {
                              selectedDate = null;
                              selectedTime = null;
                            });
                          },
                          tooltip: 'Clear date',
                        ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  if (selectedDate != null)
                    Row(
                      children: [
                        Expanded(
                          child: OutlinedButton.icon(
                            onPressed: selectTime,
                            icon: const Icon(Icons.access_time),
                            label: Text(
                              selectedTime != null
                                  ? selectedTime!.format(context)
                                  : 'Select Time (optional)',
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        if (selectedTime != null)
                          IconButton(
                            icon: const Icon(Icons.close),
                            onPressed: () {
                              setDialogState(() {
                                selectedTime = null;
                              });
                            },
                            tooltip: 'Clear time',
                          ),
                      ],
                    ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text('Cancel'),
                ),
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      db.toDoList[taskIndex]['dueDate'] = selectedDate?.toIso8601String();
                      db.toDoList[taskIndex]['dueTime'] = selectedTime != null 
                          ? _formatTimeOfDay(selectedTime!) 
                          : null;
                    });
                    db.updateDatabase();
                    Navigator.of(context).pop();
                  },
                  child: const Text('Save'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  void moveTaskToGroup(int taskIndex, int targetGroupIndex) {
    setState(() {
      db.toDoList[taskIndex]['groupIndex'] = targetGroupIndex;
    });
    db.updateDatabase();
  }

  void moveSubNoteToTask(int sourceTaskIndex, int subNoteIndex, int targetTaskIndex) {
    setState(() {
      var subNote = db.toDoList[sourceTaskIndex]['subNotes'][subNoteIndex];
      db.toDoList[sourceTaskIndex]['subNotes'].removeAt(subNoteIndex);
      db.toDoList[targetTaskIndex]['subNotes'].add(subNote);
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

  void showMoveTaskDialog(int taskIndex) {
    if (db.groups.length <= 1) {
      // Need at least 2 groups to move
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Create more groups to move tasks between them'),
          duration: Duration(seconds: 2),
        ),
      );
      return;
    }

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: const Text('Move Task to Group'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ...db.groups.asMap().entries.map((entry) {
                final idx = entry.key;
                final group = entry.value;
                final currentGroupIndex = db.toDoList[taskIndex]['groupIndex'];
                
                if (idx == currentGroupIndex) {
                  return const SizedBox.shrink();
                }
                
                return ListTile(
                  title: Text(group['name']),
                  leading: const Icon(Icons.folder),
                  onTap: () {
                    moveTaskToGroup(taskIndex, idx);
                    Navigator.of(context).pop();
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Task moved to ${group['name']}'),
                        duration: const Duration(seconds: 2),
                      ),
                    );
                  },
                );
              }).toList(),
            ],
          ),
        );
      },
    );
  }

  void showMoveSubNoteDialog(int sourceTaskIndex, int subNoteIndex) {
    final eligibleTasks = db.toDoList.asMap().entries.where(
      (entry) => entry.key != sourceTaskIndex,
    ).toList();

    if (eligibleTasks.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Create more tasks to move sub-notes between them'),
          duration: Duration(seconds: 2),
        ),
      );
      return;
    }

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: const Text('Move Sub-note to Task'),
          content: SizedBox(
            width: double.maxFinite,
            child: ListView(
              shrinkWrap: true,
              children: eligibleTasks.map((entry) {
                final idx = entry.key;
                final task = entry.value;
                
                return ListTile(
                  title: Text(task['name']),
                  leading: const Icon(Icons.task),
                  onTap: () {
                    moveSubNoteToTask(sourceTaskIndex, subNoteIndex, idx);
                    Navigator.of(context).pop();
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Sub-note moved to ${task['name']}'),
                        duration: const Duration(seconds: 2),
                      ),
                    );
                  },
                );
              }).toList(),
            ),
          ),
        );
      },
    );
  }

  List<MapEntry<int, dynamic>> _getFilteredAndSortedTasks(int? groupIndex) {
    // Get tasks for the specified group (or all if null)
    var tasks = db.toDoList.asMap().entries.where((entry) {
      if (groupIndex != null && entry.value['groupIndex'] != groupIndex) {
        return false;
      }
      return true;
    }).toList();

    // Apply status filter
    if (_filterStatus == 'completed') {
      tasks = tasks.where((entry) => entry.value['completed'] == true).toList();
    } else if (_filterStatus == 'incomplete') {
      tasks = tasks.where((entry) => entry.value['completed'] == false).toList();
    }

    // Apply color filter
    if (_filterColor != null) {
      tasks = tasks.where((entry) => entry.value['color'] == _filterColor).toList();
    }

    // Apply sorting
    if (_sortBy == 'name') {
      tasks.sort((a, b) {
        String nameA = a.value['name'] ?? '';
        String nameB = b.value['name'] ?? '';
        return nameA.toLowerCase().compareTo(nameB.toLowerCase());
      });
    } else if (_sortBy == 'completed') {
      tasks.sort((a, b) {
        bool completedA = a.value['completed'] ?? false;
        bool completedB = b.value['completed'] ?? false;
        // Show incomplete tasks first
        return completedA == completedB ? 0 : (completedA ? 1 : -1);
      });
    }

    return tasks;
  }

  void _showFilterSortDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            // Helper to update both dialog and parent state
            void updateBothStates(Function() updates) {
              setDialogState(updates);
              setState(updates);
            }
            
            return AlertDialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              title: const Text('Filter & Sort'),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Status',
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 8,
                      children: [
                        ChoiceChip(
                          label: const Text('All'),
                          selected: _filterStatus == 'all',
                          onSelected: (selected) {
                            updateBothStates(() => _filterStatus = 'all');
                          },
                        ),
                        ChoiceChip(
                          label: const Text('Completed'),
                          selected: _filterStatus == 'completed',
                          onSelected: (selected) {
                            updateBothStates(() => _filterStatus = 'completed');
                          },
                        ),
                        ChoiceChip(
                          label: const Text('Incomplete'),
                          selected: _filterStatus == 'incomplete',
                          onSelected: (selected) {
                            updateBothStates(() => _filterStatus = 'incomplete');
                          },
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'Color',
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: [
                        ChoiceChip(
                          label: const Text('All'),
                          selected: _filterColor == null,
                          onSelected: (selected) {
                            updateBothStates(() => _filterColor = null);
                          },
                        ),
                        ...getAvailableColorNames().map((color) => ChoiceChip(
                              label: Text(color[0].toUpperCase() + color.substring(1)),
                              selected: _filterColor == color,
                              onSelected: (selected) {
                                updateBothStates(() => _filterColor = color);
                              },
                            )),
                      ],
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'Sort By',
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 8,
                      children: [
                        ChoiceChip(
                          label: const Text('None'),
                          selected: _sortBy == 'none',
                          onSelected: (selected) {
                            updateBothStates(() => _sortBy = 'none');
                          },
                        ),
                        ChoiceChip(
                          label: const Text('Name'),
                          selected: _sortBy == 'name',
                          onSelected: (selected) {
                            updateBothStates(() => _sortBy = 'name');
                          },
                        ),
                        ChoiceChip(
                          label: const Text('Status'),
                          selected: _sortBy == 'completed',
                          onSelected: (selected) {
                            updateBothStates(() => _sortBy = 'completed');
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    // Reset filters
                    updateBothStates(() {
                      _filterStatus = 'all';
                      _filterColor = null;
                      _sortBy = 'none';
                    });
                  },
                  child: const Text('Reset'),
                ),
                ElevatedButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text('Done'),
                ),
              ],
            );
          },
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
        // No groups - show all tasks with filtering and sorting
        final filteredTasks = _getFilteredAndSortedTasks(null);
        for (var entry in filteredTasks) {
          final i = entry.key;
          final task = entry.value;
          widgets.add(
            ToDoTile(
              taskName: task['name'] ?? '',
              taskCompleted: task['completed'] ?? false,
              taskColor: task['color'] ?? 'yellow',
              subNotes: task['subNotes'] ?? [],
              dueDate: task['dueDate'] != null ? DateTime.parse(task['dueDate']) : null,
              dueTime: task['dueTime'] != null ? _parseTimeOfDay(task['dueTime']) : null,
              onChanged: (value) => checkBoxChanged(value, i),
              deleteFunction: (context) => deleteTask(i),
              onColorChanged: (color) => changeTaskColor(i, color),
              onAddSubNote: (subNote) => addSubNote(i, subNote),
              onSubNoteChanged: (subIdx, completed) => toggleSubNote(i, subIdx, completed),
              onDeleteSubNote: (subIdx) => deleteSubNote(i, subIdx),
              onSubNoteColorChanged: (subIdx, color) => changeSubNoteColor(i, subIdx, color),
              onMoveTask: null,  // No groups, can't move
              onMoveSubNote: (subIdx) => showMoveSubNoteDialog(i, subIdx),
              onEditDateTime: () => editTaskDateTime(i),
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
            // Show tasks in this group with filtering and sorting
            final filteredTasks = _getFilteredAndSortedTasks(groupIdx);
            for (var entry in filteredTasks) {
              final i = entry.key;
              final task = entry.value;
              widgets.add(
                ToDoTile(
                  taskName: task['name'] ?? '',
                  taskCompleted: task['completed'] ?? false,
                  taskColor: task['color'] ?? 'yellow',
                  subNotes: task['subNotes'] ?? [],
                  dueDate: task['dueDate'] != null ? DateTime.parse(task['dueDate']) : null,
                  dueTime: task['dueTime'] != null ? _parseTimeOfDay(task['dueTime']) : null,
                  onChanged: (value) => checkBoxChanged(value, i),
                  deleteFunction: (context) => deleteTask(i),
                  onColorChanged: (color) => changeTaskColor(i, color),
                  onAddSubNote: (subNote) => addSubNote(i, subNote),
                  onSubNoteChanged: (subIdx, completed) => toggleSubNote(i, subIdx, completed),
                  onDeleteSubNote: (subIdx) => deleteSubNote(i, subIdx),
                  onSubNoteColorChanged: (subIdx, color) => changeSubNoteColor(i, subIdx, color),
                  onMoveTask: () => showMoveTaskDialog(i),
                  onMoveSubNote: (subIdx) => showMoveSubNoteDialog(i, subIdx),
                  onEditDateTime: () => editTaskDateTime(i),
                ),
              );
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
          IconButton(
            icon: Stack(
              children: [
                const Icon(Icons.filter_list),
                if (_filterStatus != 'all' || _filterColor != null || _sortBy != 'none')
                  Positioned(
                    right: 0,
                    top: 0,
                    child: Container(
                      width: 8,
                      height: 8,
                      decoration: const BoxDecoration(
                        color: Colors.red,
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
              ],
            ),
            onPressed: _showFilterSortDialog,
            tooltip: 'Filter & Sort',
          ),
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
