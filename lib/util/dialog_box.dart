import 'package:flutter/material.dart';
import 'package:to_do_app/util/my_button.dart';

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

  Color getColorFromString(String colorName) {
    switch (colorName.toLowerCase()) {
      case 'red':
        return Colors.red;
      case 'blue':
        return Colors.blue;
      case 'green':
        return Colors.green;
      case 'orange':
        return Colors.orange;
      case 'purple':
        return Colors.purple;
      case 'pink':
        return Colors.pink;
      case 'teal':
        return Colors.teal;
      case 'cyan':
        return Colors.cyan;
      case 'amber':
        return Colors.amber;
      case 'yellow':
      default:
        return Colors.yellow;
    }
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
      backgroundColor: Colors.yellow[300],
      content: SizedBox(
        height: 220,
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
              children: [
                _buildColorOption('yellow', Colors.yellow),
                _buildColorOption('red', Colors.red),
                _buildColorOption('blue', Colors.blue),
                _buildColorOption('green', Colors.green),
                _buildColorOption('orange', Colors.orange),
                _buildColorOption('purple', Colors.purple),
                _buildColorOption('pink', Colors.pink),
                _buildColorOption('teal', Colors.teal),
              ],
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
