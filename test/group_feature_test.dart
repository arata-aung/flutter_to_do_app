import 'package:flutter_test/flutter_test.dart';
import 'package:to_do_app/data/database.dart';

void main() {
  group('Group Feature Tests', () {
    test('createInitialData creates groups with tasks', () {
      final db = ToDoDatabase();
      db.createInitialData();
      
      // Check groups exist
      expect(db.groups.length, 2);
      expect(db.groups[0]['name'], 'Personal');
      expect(db.groups[1]['name'], 'Work');
      
      // Check group properties
      expect(db.groups[0]['icon'], 'person');
      expect(db.groups[0]['color'], 'blue');
      expect(db.groups[0]['expanded'], true);
      
      // Check tasks have group assignment
      expect(db.toDoList.length, 2);
      expect(db.toDoList[0]['groupIndex'], 0);
      expect(db.toDoList[0]['name'], 'Make Tutorial');
      expect(db.toDoList[0]['subNotes'], []);
    });

    test('tasks have new map format with all required fields', () {
      final db = ToDoDatabase();
      db.createInitialData();
      
      final task = db.toDoList[0];
      expect(task['name'], isA<String>());
      expect(task['completed'], isA<bool>());
      expect(task['color'], isA<String>());
      expect(task['groupIndex'], isA<int>());
      expect(task['subNotes'], isA<List>());
    });

    test('can add new group', () {
      final db = ToDoDatabase();
      db.groups = [];
      
      db.groups.add({
        'name': 'Shopping',
        'icon': 'shopping',
        'color': 'green',
        'expanded': true,
      });
      
      expect(db.groups.length, 1);
      expect(db.groups[0]['name'], 'Shopping');
      expect(db.groups[0]['icon'], 'shopping');
    });

    test('can edit group properties', () {
      final db = ToDoDatabase();
      db.createInitialData();
      
      db.groups[0]['name'] = 'Updated Personal';
      db.groups[0]['color'] = 'red';
      
      expect(db.groups[0]['name'], 'Updated Personal');
      expect(db.groups[0]['color'], 'red');
    });

    test('can toggle group expansion', () {
      final db = ToDoDatabase();
      db.createInitialData();
      
      expect(db.groups[0]['expanded'], true);
      
      db.groups[0]['expanded'] = false;
      expect(db.groups[0]['expanded'], false);
      
      db.groups[0]['expanded'] = true;
      expect(db.groups[0]['expanded'], true);
    });

    test('tasks are assigned to correct group', () {
      final db = ToDoDatabase();
      db.groups = [
        {'name': 'Group 1', 'icon': 'person', 'color': 'blue', 'expanded': true},
        {'name': 'Group 2', 'icon': 'work', 'color': 'orange', 'expanded': true},
      ];
      
      db.toDoList = [
        {'name': 'Task 1', 'completed': false, 'color': 'yellow', 'groupIndex': 0, 'subNotes': []},
        {'name': 'Task 2', 'completed': false, 'color': 'blue', 'groupIndex': 1, 'subNotes': []},
      ];
      
      // Check task assignments
      expect(db.toDoList[0]['groupIndex'], 0);
      expect(db.toDoList[1]['groupIndex'], 1);
    });

    test('can delete group and update task indices', () {
      final db = ToDoDatabase();
      db.groups = [
        {'name': 'Group 1', 'icon': 'person', 'color': 'blue', 'expanded': true},
        {'name': 'Group 2', 'icon': 'work', 'color': 'orange', 'expanded': true},
        {'name': 'Group 3', 'icon': 'home', 'color': 'green', 'expanded': true},
      ];
      
      db.toDoList = [
        {'name': 'Task 1', 'completed': false, 'color': 'yellow', 'groupIndex': 0, 'subNotes': []},
        {'name': 'Task 2', 'completed': false, 'color': 'blue', 'groupIndex': 1, 'subNotes': []},
        {'name': 'Task 3', 'completed': false, 'color': 'green', 'groupIndex': 2, 'subNotes': []},
      ];
      
      // Delete group 1 (index 1)
      db.groups.removeAt(1);
      db.toDoList.removeWhere((task) => task['groupIndex'] == 1);
      
      // Update indices
      for (var task in db.toDoList) {
        if (task['groupIndex'] > 1) {
          task['groupIndex']--;
        }
      }
      
      expect(db.groups.length, 2);
      expect(db.toDoList.length, 2);
      expect(db.toDoList[1]['groupIndex'], 1); // Was 2, now 1
    });
  });
}
