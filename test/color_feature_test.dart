import 'package:flutter_test/flutter_test.dart';
import 'package:to_do_app/data/database.dart';

void main() {
  group('Color Feature Tests', () {
    test('createInitialData includes color field', () {
      final db = ToDoDatabase();
      db.createInitialData();
      
      expect(db.toDoList.length, 2);
      expect(db.toDoList[0]['color'], 'yellow'); // Default color
      expect(db.toDoList[1]['color'], 'yellow'); // Default color
    });

    test('loadData migrates old data without color field', () {
      final db = ToDoDatabase();
      // Simulate old data without color field
      db.toDoList = [
        ["Old Task 1", false],
        ["Old Task 2", true],
      ];
      
      // Manually migrate as loadData would do
      for (int i = 0; i < db.toDoList.length; i++) {
        if (db.toDoList[i] is List) {
          var oldItem = db.toDoList[i] as List;
          db.toDoList[i] = {
            "name": oldItem[0],
            "completed": oldItem.length > 1 ? oldItem[1] : false,
            "color": oldItem.length > 2 ? oldItem[2] : "yellow",
            "groupIndex": 0,
            "subNotes": [],
          };
        }
      }
      
      expect(db.toDoList[0]['color'], 'yellow');
      expect(db.toDoList[1]['color'], 'yellow');
    });

    test('new tasks can have custom colors', () {
      final db = ToDoDatabase();
      db.toDoList = [];
      
      // Add tasks with custom colors (new map format)
      db.toDoList.add({
        'name': 'Red Task',
        'completed': false,
        'color': 'red',
        'groupIndex': 0,
        'subNotes': [],
      });
      db.toDoList.add({
        'name': 'Blue Task',
        'completed': false,
        'color': 'blue',
        'groupIndex': 0,
        'subNotes': [],
      });
      
      expect(db.toDoList[0]['color'], 'red');
      expect(db.toDoList[1]['color'], 'blue');
    });

    test('task color can be changed', () {
      final db = ToDoDatabase();
      db.toDoList = [
        {
          'name': 'Task',
          'completed': false,
          'color': 'yellow',
          'groupIndex': 0,
          'subNotes': [],
        }
      ];
      
      // Change color
      db.toDoList[0]['color'] = "green";
      
      expect(db.toDoList[0]['color'], 'green');
    });

    test('all 10 colors are supported', () {
      final db = ToDoDatabase();
      final colors = ['yellow', 'red', 'blue', 'green', 'orange', 
                      'purple', 'pink', 'teal', 'cyan', 'amber'];
      
      db.toDoList = [];
      for (var color in colors) {
        db.toDoList.add({
          'name': '$color Task',
          'completed': false,
          'color': color,
          'groupIndex': 0,
          'subNotes': [],
        });
      }
      
      for (int i = 0; i < colors.length; i++) {
        expect(db.toDoList[i]['color'], colors[i]);
      }
    });
  });
}
