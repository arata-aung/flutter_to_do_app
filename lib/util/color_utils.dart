import 'package:flutter/material.dart';

// Available colors for tasks
const List<Map<String, dynamic>> availableColors = [
  {'name': 'yellow', 'color': Colors.yellow},
  {'name': 'red', 'color': Colors.red},
  {'name': 'blue', 'color': Colors.blue},
  {'name': 'green', 'color': Colors.green},
  {'name': 'orange', 'color': Colors.orange},
  {'name': 'purple', 'color': Colors.purple},
  {'name': 'pink', 'color': Colors.pink},
  {'name': 'teal', 'color': Colors.teal},
  {'name': 'cyan', 'color': Colors.cyan},
  {'name': 'amber', 'color': Colors.amber},
];

// Convert color name string to Color object
Color getColorFromString(String colorName) {
  final colorMap = {
    for (var item in availableColors) item['name']: item['color']
  };
  return colorMap[colorName.toLowerCase()] ?? Colors.yellow;
}

// Get list of color names
List<String> getAvailableColorNames() {
  return availableColors.map((item) => item['name'] as String).toList();
}
