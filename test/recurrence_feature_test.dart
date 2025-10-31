import 'package:flutter_test/flutter_test.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:to_do_app/data/database.dart';

void main() {
  group('Recurrence Feature Tests', () {
    late Box testBox;
    late ToDoDatabase db;

    setUp(() async {
      // Initialize Hive for testing
      await Hive.initFlutter();
      testBox = await Hive.openBox('test_recurrence_box');
      db = ToDoDatabase();
    });

    tearDown(() async {
      await testBox.clear();
      await testBox.close();
    });

    test('Task should have recurrence field', () {
      db.createInitialData();
      
      // Check that initial tasks have recurrence field
      expect(db.toDoList[0].containsKey('recurrence'), true);
      expect(db.toDoList[0]['recurrence'], null);
    });

    test('Task can be created with daily recurrence', () {
      db.toDoList = [];
      db.toDoList.add({
        'name': 'Daily Task',
        'completed': false,
        'color': 'yellow',
        'groupIndex': 0,
        'subNotes': [],
        'dueDate': DateTime.now().toIso8601String(),
        'dueTime': '09:00',
        'recurrence': 'daily',
      });

      expect(db.toDoList[0]['recurrence'], 'daily');
    });

    test('Task can be created with weekly recurrence', () {
      db.toDoList = [];
      db.toDoList.add({
        'name': 'Weekly Task',
        'completed': false,
        'color': 'yellow',
        'groupIndex': 0,
        'subNotes': [],
        'dueDate': DateTime.now().toIso8601String(),
        'dueTime': '10:00',
        'recurrence': 'weekly',
      });

      expect(db.toDoList[0]['recurrence'], 'weekly');
    });

    test('Task can be created with monthly recurrence', () {
      db.toDoList = [];
      db.toDoList.add({
        'name': 'Monthly Task',
        'completed': false,
        'color': 'yellow',
        'groupIndex': 0,
        'subNotes': [],
        'dueDate': DateTime.now().toIso8601String(),
        'dueTime': '11:00',
        'recurrence': 'monthly',
      });

      expect(db.toDoList[0]['recurrence'], 'monthly');
    });

    test('Task can have no recurrence', () {
      db.toDoList = [];
      db.toDoList.add({
        'name': 'One-time Task',
        'completed': false,
        'color': 'yellow',
        'groupIndex': 0,
        'subNotes': [],
        'dueDate': DateTime.now().toIso8601String(),
        'dueTime': '12:00',
        'recurrence': null,
      });

      expect(db.toDoList[0]['recurrence'], null);
    });

    test('Migration should add recurrence field to old tasks', () {
      // Simulate old task format without recurrence
      db.toDoList = [
        {
          'name': 'Old Task',
          'completed': false,
          'color': 'yellow',
          'groupIndex': 0,
          'subNotes': [],
          'dueDate': null,
          'dueTime': null,
          // No recurrence field
        }
      ];

      // Simulate loading data (which performs migration)
      testBox.put('TODOLIST', db.toDoList);
      db.loadData();

      // Check that recurrence field was added
      expect(db.toDoList[0].containsKey('recurrence'), true);
      expect(db.toDoList[0]['recurrence'], null);
    });
  });
}
