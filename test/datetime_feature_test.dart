import 'package:flutter_test/flutter_test.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:to_do_app/data/database.dart';

void main() {
  group('Date and Time Feature Tests', () {
    late ToDoDatabase db;
    late Box myBox;

    setUp(() async {
      // Initialize Hive for testing
      await Hive.initFlutter();
      
      // Open a box for testing
      myBox = await Hive.openBox('test_datetime_box');
      db = ToDoDatabase();
    });

    tearDown(() async {
      // Clean up after each test
      await myBox.clear();
      await myBox.close();
      await Hive.deleteBoxFromDisk('test_datetime_box');
    });

    test('New task should support dueDate and dueTime fields', () {
      db.createInitialData();
      
      // Add a task with date and time
      final dueDate = DateTime(2025, 12, 25);
      db.toDoList.add({
        'name': 'Christmas Task',
        'completed': false,
        'color': 'red',
        'groupIndex': 0,
        'subNotes': [],
        'dueDate': dueDate.toIso8601String(),
        'dueTime': '14:30',
      });
      
      expect(db.toDoList.length, 3);
      expect(db.toDoList[2]['dueDate'], isNotNull);
      expect(db.toDoList[2]['dueTime'], '14:30');
    });

    test('Task without date should have null dueDate and dueTime', () {
      db.createInitialData();
      
      expect(db.toDoList[0]['dueDate'], isNull);
      expect(db.toDoList[0]['dueTime'], isNull);
    });

    test('Data migration should add dueDate and dueTime fields to existing tasks', () {
      // Simulate old data without date/time fields
      myBox.put('GROUPS', [
        {
          'name': 'Test Group',
          'icon': 'person',
          'color': 'blue',
          'expanded': true,
        }
      ]);
      
      myBox.put('TODOLIST', [
        {
          'name': 'Old Task',
          'completed': false,
          'color': 'yellow',
          'groupIndex': 0,
          'subNotes': [],
        }
      ]);
      
      // Load data with migration
      final testDb = ToDoDatabase();
      testDb.loadData();
      
      // Verify migration added date/time fields
      expect(testDb.toDoList.length, 1);
      expect(testDb.toDoList[0].containsKey('dueDate'), isTrue);
      expect(testDb.toDoList[0].containsKey('dueTime'), isTrue);
      expect(testDb.toDoList[0]['dueDate'], isNull);
      expect(testDb.toDoList[0]['dueTime'], isNull);
    });

    test('Can update task date and time', () {
      db.createInitialData();
      
      // Update task with date/time
      final dueDate = DateTime(2025, 10, 31);
      db.toDoList[0]['dueDate'] = dueDate.toIso8601String();
      db.toDoList[0]['dueTime'] = '09:00';
      
      expect(db.toDoList[0]['dueDate'], dueDate.toIso8601String());
      expect(db.toDoList[0]['dueTime'], '09:00');
    });

    test('Can clear task date and time', () {
      db.createInitialData();
      
      // Add date/time
      final dueDate = DateTime(2025, 10, 31);
      db.toDoList[0]['dueDate'] = dueDate.toIso8601String();
      db.toDoList[0]['dueTime'] = '09:00';
      
      // Clear date/time
      db.toDoList[0]['dueDate'] = null;
      db.toDoList[0]['dueTime'] = null;
      
      expect(db.toDoList[0]['dueDate'], isNull);
      expect(db.toDoList[0]['dueTime'], isNull);
    });

    test('Task can have date without time', () {
      db.createInitialData();
      
      final dueDate = DateTime(2025, 10, 31);
      db.toDoList[0]['dueDate'] = dueDate.toIso8601String();
      db.toDoList[0]['dueTime'] = null;
      
      expect(db.toDoList[0]['dueDate'], isNotNull);
      expect(db.toDoList[0]['dueTime'], isNull);
    });

    test('DateTime ISO string parsing works correctly', () {
      final testDate = DateTime(2025, 12, 25, 14, 30);
      final isoString = testDate.toIso8601String();
      final parsedDate = DateTime.parse(isoString);
      
      expect(parsedDate.year, testDate.year);
      expect(parsedDate.month, testDate.month);
      expect(parsedDate.day, testDate.day);
    });

    test('Time string format is correct', () {
      const timeString = '14:30';
      final parts = timeString.split(':');
      
      expect(parts.length, 2);
      expect(int.parse(parts[0]), 14);
      expect(int.parse(parts[1]), 30);
    });

    test('Multiple tasks can have different dates', () {
      db.createInitialData();
      
      final date1 = DateTime(2025, 10, 31);
      final date2 = DateTime(2025, 11, 1);
      
      db.toDoList[0]['dueDate'] = date1.toIso8601String();
      db.toDoList[1]['dueDate'] = date2.toIso8601String();
      
      expect(db.toDoList[0]['dueDate'], isNot(equals(db.toDoList[1]['dueDate'])));
    });

    test('Completed tasks can have dates', () {
      db.createInitialData();
      
      final dueDate = DateTime(2025, 10, 31);
      db.toDoList[0]['completed'] = true;
      db.toDoList[0]['dueDate'] = dueDate.toIso8601String();
      
      expect(db.toDoList[0]['completed'], isTrue);
      expect(db.toDoList[0]['dueDate'], isNotNull);
    });
  });
}
