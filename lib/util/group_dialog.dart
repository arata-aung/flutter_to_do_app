import 'package:flutter/material.dart';
import 'package:to_do_app/util/my_button.dart';
import 'package:to_do_app/util/color_utils.dart';

class GroupDialog extends StatefulWidget {
  final TextEditingController controller;
  final Function(String icon, String color) onSave;
  final VoidCallback onCancel;
  final String? initialIcon;
  final String? initialColor;

  const GroupDialog({
    super.key,
    required this.controller,
    required this.onSave,
    required this.onCancel,
    this.initialIcon,
    this.initialColor,
  });

  @override
  State<GroupDialog> createState() => _GroupDialogState();
}

class _GroupDialogState extends State<GroupDialog> {
  late String selectedIcon;
  late String selectedColor;

  final List<Map<String, String>> availableIcons = [
    {'name': 'person', 'display': 'Person'},
    {'name': 'work', 'display': 'Work'},
    {'name': 'home', 'display': 'Home'},
    {'name': 'shopping', 'display': 'Shopping'},
    {'name': 'fitness', 'display': 'Fitness'},
    {'name': 'book', 'display': 'Book'},
    {'name': 'star', 'display': 'Star'},
    {'name': 'favorite', 'display': 'Favorite'},
  ];

  @override
  void initState() {
    super.initState();
    selectedIcon = widget.initialIcon ?? 'person';
    selectedColor = widget.initialColor ?? 'blue';
  }

  IconData _getIconData(String iconName) {
    switch (iconName) {
      case 'person':
        return Icons.person;
      case 'work':
        return Icons.work;
      case 'home':
        return Icons.home;
      case 'shopping':
        return Icons.shopping_cart;
      case 'fitness':
        return Icons.fitness_center;
      case 'book':
        return Icons.book;
      case 'star':
        return Icons.star;
      case 'favorite':
        return Icons.favorite;
      default:
        return Icons.folder;
    }
  }

  Widget _buildIconOption(String iconName, String displayName) {
    final isSelected = selectedIcon == iconName;
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedIcon = iconName;
        });
      },
      child: Column(
        children: [
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              color: isSelected ? Colors.blue.shade100 : Colors.grey.shade200,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: isSelected ? Colors.blue : Colors.grey,
                width: isSelected ? 2 : 1,
              ),
            ),
            child: Icon(
              _getIconData(iconName),
              size: 28,
              color: isSelected ? Colors.blue : Colors.grey.shade700,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            displayName,
            style: TextStyle(
              fontSize: 10,
              color: isSelected ? Colors.blue : Colors.grey.shade700,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildColorOption(String colorName, Color color) {
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedColor = colorName;
        });
      },
      child: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: color,
          shape: BoxShape.circle,
          border: Border.all(
            color: selectedColor == colorName ? Colors.black : Colors.grey,
            width: selectedColor == colorName ? 3 : 1,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Colors.blue.shade50,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      title: const Text(
        "Group Settings",
        style: TextStyle(fontWeight: FontWeight.bold),
      ),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: widget.controller,
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                hintText: "Group name",
                filled: true,
                fillColor: Colors.white,
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              "Choose Icon:",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 12,
              runSpacing: 12,
              children: availableIcons
                  .map((icon) => _buildIconOption(
                        icon['name']!,
                        icon['display']!,
                      ))
                  .toList(),
            ),
            const SizedBox(height: 16),
            const Text(
              "Choose Color:",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: availableColors
                  .map((colorData) => _buildColorOption(
                        colorData['name'] as String,
                        colorData['color'] as Color,
                      ))
                  .toList(),
            ),
          ],
        ),
      ),
      actions: [
        MyButton(
          text: "Save",
          onPressed: () {
            widget.onSave(selectedIcon, selectedColor);
          },
        ),
        MyButton(
          text: "Cancel",
          onPressed: widget.onCancel,
        ),
      ],
    );
  }
}
