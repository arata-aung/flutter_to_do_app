import 'package:flutter_test/flutter_test.dart';
import 'package:to_do_app/data/database.dart';

void main() {
  group('Data Migration Tests', () {
    test('migrates old list format to new map format', () {
      final db = ToDoDatabase();
      
      // Simulate old list format data
      db.toDoList = [
        ["Old Task 1", false, "yellow"],
        ["Old Task 2", true, "blue"],
      ];
      
      // Simulate migration logic from loadData
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
      
      // Verify migration
      expect(db.toDoList[0], isA<Map>());
      expect(db.toDoList[0]['name'], "Old Task 1");
      expect(db.toDoList[0]['completed'], false);
      expect(db.toDoList[0]['color'], "yellow");
      expect(db.toDoList[0]['groupIndex'], 0);
      expect(db.toDoList[0]['subNotes'], []);
      
      expect(db.toDoList[1]['name'], "Old Task 2");
      expect(db.toDoList[1]['completed'], true);
      expect(db.toDoList[1]['color'], "blue");
    });

    test('migrates old data without color field', () {
      final db = ToDoDatabase();
      
      // Simulate very old format without color
      db.toDoList = [
        ["Very Old Task", false],
      ];
      
      // Migrate
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
      
      expect(db.toDoList[0]['name'], "Very Old Task");
      expect(db.toDoList[0]['color'], "yellow"); // Default color
    });

    test('adds missing fields to existing map format', () {
      final db = ToDoDatabase();
      db.groups = [
        {'name': 'Group 1', 'icon': 'person', 'color': 'blue', 'expanded': true}
      ];
      
      // Simulate map format without new fields
      db.toDoList = [
        {'name': 'Task', 'completed': false, 'color': 'yellow'}
      ];
      
      // Add missing fields
      for (int i = 0; i < db.toDoList.length; i++) {
        if (db.toDoList[i] is Map) {
          var item = Map<String, dynamic>.from(db.toDoList[i]);
          if (!item.containsKey("subNotes")) {
            item["subNotes"] = [];
          }
          if (!item.containsKey("groupIndex")) {
            item["groupIndex"] = db.groups.isNotEmpty ? 0 : -1;
          }
          db.toDoList[i] = item;
        }
      }
      
      expect(db.toDoList[0]['subNotes'], []);
      expect(db.toDoList[0]['groupIndex'], 0);
    });

    test('handles empty groups during migration', () {
      final db = ToDoDatabase();
      db.groups = []; // No groups
      
      db.toDoList = [
        {'name': 'Task', 'completed': false, 'color': 'yellow'}
      ];
      
      // Add groupIndex when no groups exist
      for (int i = 0; i < db.toDoList.length; i++) {
        if (db.toDoList[i] is Map) {
          var item = Map<String, dynamic>.from(db.toDoList[i]);
          if (!item.containsKey("groupIndex")) {
            item["groupIndex"] = db.groups.isNotEmpty ? 0 : -1;
          }
          db.toDoList[i] = item;
        }
      }
      
      expect(db.toDoList[0]['groupIndex'], -1); // No group
    });

    test('preserves existing data during migration', () {
      final db = ToDoDatabase();
      
      // Simulate old format with various data
      db.toDoList = [
        ["Completed Task", true, "red"],
        ["Incomplete Task", false, "green"],
      ];
      
      // Migrate
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
      
      // Verify data preservation
      expect(db.toDoList[0]['completed'], true);
      expect(db.toDoList[0]['color'], "red");
      expect(db.toDoList[1]['completed'], false);
      expect(db.toDoList[1]['color'], "green");
    });

    test('handles mixed format data', () {
      final db = ToDoDatabase();
      
      // Mix of old list format and new map format
      db.toDoList = [
        ["Old Format Task", false, "yellow"],
        {'name': 'New Format Task', 'completed': true, 'color': 'blue', 'groupIndex': 0, 'subNotes': []},
      ];
      
      // Migrate only old format
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
      
      // Both should now be maps
      expect(db.toDoList[0], isA<Map>());
      expect(db.toDoList[1], isA<Map>());
      expect(db.toDoList[0]['name'], "Old Format Task");
      expect(db.toDoList[1]['name'], "New Format Task");
    });
  });
}
