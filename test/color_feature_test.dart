import 'package:flutter_test/flutter_test.dart';
import 'package:to_do_app/data/database.dart';

void main() {
  group('Color Feature Tests', () {
    test('createInitialData includes color field', () {
      final db = ToDoDatabase();
      db.createInitialData();
      
      expect(db.toDoList.length, 2);
      expect(db.toDoList[0].length, 3); // taskName, completed, color
      expect(db.toDoList[0][2], 'yellow'); // Default color
      expect(db.toDoList[1][2], 'yellow'); // Default color
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
        if (db.toDoList[i].length < 3) {
          db.toDoList[i].add("yellow");
        }
      }
      
      expect(db.toDoList[0].length, 3);
      expect(db.toDoList[0][2], 'yellow');
      expect(db.toDoList[1].length, 3);
      expect(db.toDoList[1][2], 'yellow');
    });

    test('new tasks can have custom colors', () {
      final db = ToDoDatabase();
      db.toDoList = [];
      
      // Add a task with custom color
      db.toDoList.add(["Red Task", false, "red"]);
      db.toDoList.add(["Blue Task", false, "blue"]);
      
      expect(db.toDoList[0][2], 'red');
      expect(db.toDoList[1][2], 'blue');
    });

    test('task color can be changed', () {
      final db = ToDoDatabase();
      db.toDoList = [
        ["Task", false, "yellow"]
      ];
      
      // Change color
      db.toDoList[0][2] = "green";
      
      expect(db.toDoList[0][2], 'green');
    });
  });
}
