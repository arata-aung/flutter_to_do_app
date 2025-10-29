import 'package:flutter/material.dart';
import 'package:to_do_app/util/my_button.dart';
import 'package:to_do_app/util/color_utils.dart';

class DialogBox extends StatefulWidget {
  final TextEditingController controller;
  final Function(String) onSave;
  final VoidCallback onCancel;

  const DialogBox({
    super.key,
    required this.controller,
    required this.onSave,
    required this.onCancel,
  });

  @override
  State<DialogBox> createState() => _DialogBoxState();
}

class _DialogBoxState extends State<DialogBox> {
  String selectedColor = "yellow";

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
    const double dialogHeight = 260; // Height for dialog content
    
    return AlertDialog(
      backgroundColor: Colors.yellow[300],
      content: SizedBox(
        height: dialogHeight,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            TextField(
              controller: widget.controller,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                hintText: "Add a new task",
              ),
            ),
            const SizedBox(height: 10),
            const Text("Choose Color:"),
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
            const SizedBox(height: 10),
            Row(
              children: [
                MyButton(
                  text: "Save",
                  onPressed: () => widget.onSave(selectedColor),
                ),
                const SizedBox(
                  width: 8,
                ),
                MyButton(text: "Cancel", onPressed: widget.onCancel),
              ],
            )
          ],
        ),
      ),
    );
  }
}
