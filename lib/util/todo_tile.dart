import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:to_do_app/util/color_utils.dart';

class ToDoTile extends StatelessWidget {
  final String taskName;
  final bool taskCompleted;
  final Function(bool?)? onChanged;
  final Function(BuildContext)? deleteFunction;
  final Function(String)? onColorChanged;
  final String taskColor;

  const ToDoTile({
    super.key,
    required this.taskName,
    required this.taskCompleted,
    required this.onChanged,
    required this.deleteFunction,
    this.onColorChanged,
    this.taskColor = "yellow",
  });

  @override
  Widget build(BuildContext context) {
    // Helper function to build a color option
    Widget buildColorOption(BuildContext dialogContext, String colorName, Color color) {
      return GestureDetector(
        onTap: () {
          if (onColorChanged != null) {
            onColorChanged!(colorName);
          }
          Navigator.of(dialogContext).pop();
        },
        child: Container(
          width: 50,
          height: 50,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
            border: Border.all(
              color: taskColor == colorName ? Colors.black : Colors.grey,
              width: taskColor == colorName ? 3 : 1,
            ),
          ),
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.only(left: 25.0, top: 25, right: 25),
      child: Slidable(
        endActionPane: ActionPane(
          motion: const StretchMotion(),
          children: [
            SlidableAction(
              onPressed: (context) {
                // Show color picker dialog
                showDialog(
                  context: context,
                  builder: (BuildContext dialogContext) {
                    return AlertDialog(
                      title: const Text('Choose Color'),
                      content: Wrap(
                        spacing: 10,
                        runSpacing: 10,
                        children: availableColors
                            .map((colorData) => buildColorOption(
                                  dialogContext,
                                  colorData['name'] as String,
                                  colorData['color'] as Color,
                                ))
                            .toList(),
                      ),
                    );
                  },
                );
              },
              icon: Icons.color_lens,
              backgroundColor: Colors.blue.shade300,
            ),
            SlidableAction(
              onPressed: deleteFunction,
              icon: Icons.delete,
              backgroundColor: Colors.red.shade300,
            )
          ],
        ),
        child: Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: getColorFromString(taskColor),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            children: [
              Checkbox(
                value: taskCompleted,
                onChanged: onChanged,
                activeColor: Colors.black,
              ),
              Text(
                taskName,
                style: TextStyle(
                  decoration: taskCompleted
                      ? TextDecoration.lineThrough
                      : TextDecoration.none,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
