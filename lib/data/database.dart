import 'package:hive_flutter/hive_flutter.dart';

class ToDoDatabase {
  List toDoList = [];

  final _myBox = Hive.box('mybox');

  void createInitialData() {
    toDoList = [
      ["Make Tutorial", false, "yellow"],
      ["Do Exercise", false, "yellow"],
    ];
  }

  void loadData() {
    toDoList = _myBox.get("TODOLIST");
    // Migrate old data that doesn't have color field
    for (int i = 0; i < toDoList.length; i++) {
      if (toDoList[i].length < 3) {
        toDoList[i].add("yellow"); // Default color for old items
      }
    }
  }

  void updateDatabase() {
    _myBox.put("TODOLIST", toDoList);
  }
}
