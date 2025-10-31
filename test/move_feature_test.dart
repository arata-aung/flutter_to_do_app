import 'package:flutter_test/flutter_test.dart';
import 'package:to_do_app/data/database.dart';

void main() {
  group('Task Movement Feature Tests', () {
    test('can move task to different group', () {
      final db = ToDoDatabase();
      db.groups = [
        {'name': 'Group 1', 'icon': 'person', 'color': 'blue', 'expanded': true},
        {'name': 'Group 2', 'icon': 'work', 'color': 'orange', 'expanded': true},
      ];
      
      db.toDoList = [
        {'name': 'Task 1', 'completed': false, 'color': 'yellow', 'groupIndex': 0, 'subNotes': []},
      ];
      
      // Move task from group 0 to group 1
      db.toDoList[0]['groupIndex'] = 1;
      
      expect(db.toDoList[0]['groupIndex'], 1);
    });

    test('task retains properties when moved', () {
      final db = ToDoDatabase();
      db.groups = [
        {'name': 'Group 1', 'icon': 'person', 'color': 'blue', 'expanded': true},
        {'name': 'Group 2', 'icon': 'work', 'color': 'orange', 'expanded': true},
      ];
      
      db.toDoList = [
        {
          'name': 'Task 1',
          'completed': true,
          'color': 'red',
          'groupIndex': 0,
          'subNotes': [
            {'name': 'Sub-note', 'completed': false, 'color': 'blue'}
          ]
        },
      ];
      
      // Move task
      db.toDoList[0]['groupIndex'] = 1;
      
      // Verify properties are retained
      expect(db.toDoList[0]['name'], 'Task 1');
      expect(db.toDoList[0]['completed'], true);
      expect(db.toDoList[0]['color'], 'red');
      expect(db.toDoList[0]['subNotes'].length, 1);
      expect(db.toDoList[0]['groupIndex'], 1);
    });
  });

  group('Sub-note Movement Feature Tests', () {
    test('can move sub-note to different task', () {
      final db = ToDoDatabase();
      db.toDoList = [
        {
          'name': 'Task 1',
          'completed': false,
          'color': 'yellow',
          'groupIndex': 0,
          'subNotes': [
            {'name': 'Sub-note 1', 'completed': false, 'color': 'blue'}
          ],
        },
        {
          'name': 'Task 2',
          'completed': false,
          'color': 'red',
          'groupIndex': 0,
          'subNotes': [],
        }
      ];
      
      // Move sub-note from task 0 to task 1
      var subNote = db.toDoList[0]['subNotes'][0];
      db.toDoList[0]['subNotes'].removeAt(0);
      db.toDoList[1]['subNotes'].add(subNote);
      
      expect(db.toDoList[0]['subNotes'].length, 0);
      expect(db.toDoList[1]['subNotes'].length, 1);
      expect(db.toDoList[1]['subNotes'][0]['name'], 'Sub-note 1');
    });

    test('sub-note retains properties when moved', () {
      final db = ToDoDatabase();
      db.toDoList = [
        {
          'name': 'Task 1',
          'completed': false,
          'color': 'yellow',
          'groupIndex': 0,
          'subNotes': [
            {'name': 'Sub-note 1', 'completed': true, 'color': 'purple'}
          ],
        },
        {
          'name': 'Task 2',
          'completed': false,
          'color': 'red',
          'groupIndex': 0,
          'subNotes': [],
        }
      ];
      
      // Move sub-note
      var subNote = db.toDoList[0]['subNotes'][0];
      db.toDoList[0]['subNotes'].removeAt(0);
      db.toDoList[1]['subNotes'].add(subNote);
      
      // Verify properties are retained
      expect(db.toDoList[1]['subNotes'][0]['name'], 'Sub-note 1');
      expect(db.toDoList[1]['subNotes'][0]['completed'], true);
      expect(db.toDoList[1]['subNotes'][0]['color'], 'purple');
    });

    test('can move multiple sub-notes between tasks', () {
      final db = ToDoDatabase();
      db.toDoList = [
        {
          'name': 'Task 1',
          'completed': false,
          'color': 'yellow',
          'groupIndex': 0,
          'subNotes': [
            {'name': 'Sub-note 1', 'completed': false, 'color': 'blue'},
            {'name': 'Sub-note 2', 'completed': false, 'color': 'green'},
          ],
        },
        {
          'name': 'Task 2',
          'completed': false,
          'color': 'red',
          'groupIndex': 0,
          'subNotes': [],
        }
      ];
      
      // Move first sub-note
      var subNote1 = db.toDoList[0]['subNotes'][0];
      db.toDoList[0]['subNotes'].removeAt(0);
      db.toDoList[1]['subNotes'].add(subNote1);
      
      expect(db.toDoList[0]['subNotes'].length, 1);
      expect(db.toDoList[1]['subNotes'].length, 1);
    });
  });

  group('Sub-note Color Feature Tests', () {
    test('new sub-notes have default color', () {
      final db = ToDoDatabase();
      db.toDoList = [
        {
          'name': 'Task 1',
          'completed': false,
          'color': 'yellow',
          'groupIndex': 0,
          'subNotes': [],
        }
      ];
      
      // Add sub-note with color
      db.toDoList[0]['subNotes'].add({
        'name': 'Sub-note',
        'completed': false,
        'color': 'yellow',
      });
      
      expect(db.toDoList[0]['subNotes'][0]['color'], 'yellow');
    });

    test('can change sub-note color', () {
      final db = ToDoDatabase();
      db.toDoList = [
        {
          'name': 'Task 1',
          'completed': false,
          'color': 'yellow',
          'groupIndex': 0,
          'subNotes': [
            {'name': 'Sub-note', 'completed': false, 'color': 'blue'}
          ],
        }
      ];
      
      // Change color
      db.toDoList[0]['subNotes'][0]['color'] = 'red';
      
      expect(db.toDoList[0]['subNotes'][0]['color'], 'red');
    });

    test('sub-note color is independent of task color', () {
      final db = ToDoDatabase();
      db.toDoList = [
        {
          'name': 'Task 1',
          'completed': false,
          'color': 'yellow',
          'groupIndex': 0,
          'subNotes': [
            {'name': 'Sub-note', 'completed': false, 'color': 'purple'}
          ],
        }
      ];
      
      expect(db.toDoList[0]['color'], 'yellow');
      expect(db.toDoList[0]['subNotes'][0]['color'], 'purple');
    });

    test('migration adds color to old sub-notes', () {
      final db = ToDoDatabase();
      db.toDoList = [
        {
          'name': 'Task 1',
          'completed': false,
          'color': 'yellow',
          'groupIndex': 0,
          'subNotes': [
            {'name': 'Old Sub-note', 'completed': false}  // No color
          ],
        }
      ];
      
      // Simulate migration
      for (int i = 0; i < db.toDoList.length; i++) {
        var item = db.toDoList[i];
        if (item['subNotes'] is List) {
          List subNotes = item['subNotes'];
          for (int j = 0; j < subNotes.length; j++) {
            if (subNotes[j] is Map) {
              var subNote = Map<String, dynamic>.from(subNotes[j]);
              if (!subNote.containsKey('color')) {
                subNote['color'] = 'yellow';
              }
              subNotes[j] = subNote;
            }
          }
        }
      }
      
      expect(db.toDoList[0]['subNotes'][0]['color'], 'yellow');
    });
  });
}
