import 'package:flutter_test/flutter_test.dart';
import 'package:to_do_app/data/database.dart';

void main() {
  group('Sub-note Feature Tests', () {
    test('new tasks have empty sub-notes list', () {
      final db = ToDoDatabase();
      db.createInitialData();
      
      expect(db.toDoList[0]['subNotes'], []);
      expect(db.toDoList[0]['subNotes'], isA<List>());
    });

    test('can add sub-note to task', () {
      final db = ToDoDatabase();
      db.toDoList = [
        {
          'name': 'Main Task',
          'completed': false,
          'color': 'yellow',
          'groupIndex': 0,
          'subNotes': [],
        }
      ];
      
      // Add sub-note
      db.toDoList[0]['subNotes'].add({
        'name': 'Sub-task 1',
        'completed': false,
      });
      
      expect(db.toDoList[0]['subNotes'].length, 1);
      expect(db.toDoList[0]['subNotes'][0]['name'], 'Sub-task 1');
      expect(db.toDoList[0]['subNotes'][0]['completed'], false);
    });

    test('can add multiple sub-notes to task', () {
      final db = ToDoDatabase();
      db.toDoList = [
        {
          'name': 'Main Task',
          'completed': false,
          'color': 'yellow',
          'groupIndex': 0,
          'subNotes': [],
        }
      ];
      
      // Add multiple sub-notes
      db.toDoList[0]['subNotes'].add({
        'name': 'Sub-task 1',
        'completed': false,
      });
      db.toDoList[0]['subNotes'].add({
        'name': 'Sub-task 2',
        'completed': false,
      });
      db.toDoList[0]['subNotes'].add({
        'name': 'Sub-task 3',
        'completed': false,
      });
      
      expect(db.toDoList[0]['subNotes'].length, 3);
    });

    test('can complete sub-note', () {
      final db = ToDoDatabase();
      db.toDoList = [
        {
          'name': 'Main Task',
          'completed': false,
          'color': 'yellow',
          'groupIndex': 0,
          'subNotes': [
            {'name': 'Sub-task 1', 'completed': false},
          ],
        }
      ];
      
      // Complete sub-note
      db.toDoList[0]['subNotes'][0]['completed'] = true;
      
      expect(db.toDoList[0]['subNotes'][0]['completed'], true);
    });

    test('can delete sub-note', () {
      final db = ToDoDatabase();
      db.toDoList = [
        {
          'name': 'Main Task',
          'completed': false,
          'color': 'yellow',
          'groupIndex': 0,
          'subNotes': [
            {'name': 'Sub-task 1', 'completed': false},
            {'name': 'Sub-task 2', 'completed': false},
          ],
        }
      ];
      
      // Delete first sub-note
      db.toDoList[0]['subNotes'].removeAt(0);
      
      expect(db.toDoList[0]['subNotes'].length, 1);
      expect(db.toDoList[0]['subNotes'][0]['name'], 'Sub-task 2');
    });

    test('sub-notes are independent per task', () {
      final db = ToDoDatabase();
      db.toDoList = [
        {
          'name': 'Task 1',
          'completed': false,
          'color': 'yellow',
          'groupIndex': 0,
          'subNotes': [
            {'name': 'Task 1 Sub-note', 'completed': false},
          ],
        },
        {
          'name': 'Task 2',
          'completed': false,
          'color': 'blue',
          'groupIndex': 0,
          'subNotes': [
            {'name': 'Task 2 Sub-note', 'completed': false},
          ],
        }
      ];
      
      expect(db.toDoList[0]['subNotes'][0]['name'], 'Task 1 Sub-note');
      expect(db.toDoList[1]['subNotes'][0]['name'], 'Task 2 Sub-note');
      expect(db.toDoList[0]['subNotes'].length, 1);
      expect(db.toDoList[1]['subNotes'].length, 1);
    });

    test('deleting task deletes all its sub-notes', () {
      final db = ToDoDatabase();
      db.toDoList = [
        {
          'name': 'Task with sub-notes',
          'completed': false,
          'color': 'yellow',
          'groupIndex': 0,
          'subNotes': [
            {'name': 'Sub-note 1', 'completed': false},
            {'name': 'Sub-note 2', 'completed': false},
          ],
        }
      ];
      
      // Delete task
      db.toDoList.removeAt(0);
      
      expect(db.toDoList.length, 0);
    });

    test('sub-note structure is correct', () {
      final db = ToDoDatabase();
      db.toDoList = [
        {
          'name': 'Main Task',
          'completed': false,
          'color': 'yellow',
          'groupIndex': 0,
          'subNotes': [
            {'name': 'Sub-task', 'completed': true},
          ],
        }
      ];
      
      final subNote = db.toDoList[0]['subNotes'][0];
      expect(subNote, isA<Map>());
      expect(subNote['name'], isA<String>());
      expect(subNote['completed'], isA<bool>());
    });
  });
}
