import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:to_do_app/util/color_utils.dart';

class ToDoTile extends StatefulWidget {
  final String taskName;
  final bool taskCompleted;
  final Function(bool?)? onChanged;
  final Function(BuildContext)? deleteFunction;
  final Function(String)? onColorChanged;
  final String taskColor;
  final List<dynamic>? subNotes;
  final Function(String)? onAddSubNote;
  final Function(int, bool)? onSubNoteChanged;
  final Function(int)? onDeleteSubNote;
  final Function(int, String)? onSubNoteColorChanged;
  final Function()? onMoveTask;
  final Function(int)? onMoveSubNote;

  const ToDoTile({
    super.key,
    required this.taskName,
    required this.taskCompleted,
    required this.onChanged,
    required this.deleteFunction,
    this.onColorChanged,
    this.taskColor = "yellow",
    this.subNotes,
    this.onAddSubNote,
    this.onSubNoteChanged,
    this.onDeleteSubNote,
    this.onSubNoteColorChanged,
    this.onMoveTask,
    this.onMoveSubNote,
  });

  @override
  State<ToDoTile> createState() => _ToDoTileState();
}

class _ToDoTileState extends State<ToDoTile> {
  bool _showSubNotes = false;

  void _showAddSubNoteDialog() {
    final controller = TextEditingController();
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: const Text('Add Sub-note'),
          content: TextField(
            controller: controller,
            decoration: InputDecoration(
              hintText: 'Enter sub-note',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            autofocus: true,
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                if (controller.text.trim().isNotEmpty && widget.onAddSubNote != null) {
                  widget.onAddSubNote!(controller.text.trim());
                  Navigator.of(context).pop();
                }
              },
              child: const Text('Add'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    // Helper function to build a color option
    Widget buildColorOption(BuildContext dialogContext, String colorName, Color color) {
      return GestureDetector(
        onTap: () {
          if (widget.onColorChanged != null) {
            widget.onColorChanged!(colorName);
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
              color: widget.taskColor == colorName ? Colors.black : Colors.grey,
              width: widget.taskColor == colorName ? 3 : 1,
            ),
          ),
        ),
      );
    }

    final hasSubNotes = widget.subNotes != null && widget.subNotes!.isNotEmpty;

    return Padding(
      padding: const EdgeInsets.only(left: 25.0, top: 12, right: 25),
      child: Column(
        children: [
          Slidable(
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
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
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
                  borderRadius: BorderRadius.circular(12),
                ),
                if (widget.onMoveTask != null)
                  SlidableAction(
                    onPressed: (context) => widget.onMoveTask!(),
                    icon: Icons.drive_file_move,
                    backgroundColor: Colors.orange.shade300,
                    borderRadius: BorderRadius.circular(12),
                  ),
                SlidableAction(
                  onPressed: widget.deleteFunction,
                  icon: Icons.delete,
                  backgroundColor: Colors.red.shade300,
                  borderRadius: BorderRadius.circular(12),
                )
              ],
            ),
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    getColorFromString(widget.taskColor),
                    getColorFromString(widget.taskColor).withOpacity(0.8),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 6,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.3),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Checkbox(
                            value: widget.taskCompleted,
                            onChanged: widget.onChanged,
                            activeColor: Colors.green.shade700,
                            checkColor: Colors.white,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            widget.taskName,
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                              decoration: widget.taskCompleted
                                  ? TextDecoration.lineThrough
                                  : TextDecoration.none,
                              color: Colors.black87,
                            ),
                          ),
                        ),
                        if (hasSubNotes)
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.3),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              '${widget.subNotes!.length}',
                              style: const TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                                color: Colors.black87,
                              ),
                            ),
                          ),
                        const SizedBox(width: 8),
                        IconButton(
                          icon: const Icon(Icons.add_circle_outline),
                          onPressed: _showAddSubNoteDialog,
                          tooltip: 'Add sub-note',
                          iconSize: 24,
                          color: Colors.black87,
                        ),
                        if (hasSubNotes)
                          IconButton(
                            icon: Icon(
                              _showSubNotes ? Icons.expand_less : Icons.expand_more,
                            ),
                            onPressed: () {
                              setState(() {
                                _showSubNotes = !_showSubNotes;
                              });
                            },
                            tooltip: _showSubNotes ? 'Hide sub-notes' : 'Show sub-notes',
                            iconSize: 24,
                            color: Colors.black87,
                          ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          if (hasSubNotes && _showSubNotes)
            ...widget.subNotes!.asMap().entries.map((entry) {
              final index = entry.key;
              final subNote = entry.value;
              final name = subNote['name'] ?? '';
              final completed = subNote['completed'] ?? false;
              final subNoteColor = subNote['color'] ?? 'yellow';
              
              return Padding(
                padding: const EdgeInsets.only(left: 40, top: 8),
                child: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        getColorFromString(subNoteColor).withOpacity(0.5),
                        getColorFromString(subNoteColor).withOpacity(0.3),
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: getColorFromString(subNoteColor).withOpacity(0.5),
                      width: 2,
                    ),
                  ),
                  child: Row(
                    children: [
                      SizedBox(
                        width: 20,
                        height: 20,
                        child: Checkbox(
                          value: completed,
                          onChanged: (value) {
                            if (widget.onSubNoteChanged != null) {
                              widget.onSubNoteChanged!(index, value ?? false);
                            }
                          },
                          activeColor: Colors.green.shade600,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          name,
                          style: TextStyle(
                            fontSize: 14,
                            decoration: completed
                                ? TextDecoration.lineThrough
                                : TextDecoration.none,
                            color: Colors.black87,
                          ),
                        ),
                      ),
                      if (widget.onSubNoteColorChanged != null)
                        IconButton(
                          icon: const Icon(Icons.palette, size: 18),
                          onPressed: () {
                            // Show color picker for sub-note
                            showDialog(
                              context: context,
                              builder: (BuildContext dialogContext) {
                                return AlertDialog(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                  title: const Text('Choose Sub-note Color'),
                                  content: Wrap(
                                    spacing: 10,
                                    runSpacing: 10,
                                    children: availableColors
                                        .map((colorData) => GestureDetector(
                                              onTap: () {
                                                widget.onSubNoteColorChanged!(
                                                  index,
                                                  colorData['name'] as String,
                                                );
                                                Navigator.of(dialogContext).pop();
                                              },
                                              child: Container(
                                                width: 50,
                                                height: 50,
                                                decoration: BoxDecoration(
                                                  color: colorData['color'] as Color,
                                                  shape: BoxShape.circle,
                                                  border: Border.all(
                                                    color: subNoteColor == colorData['name']
                                                        ? Colors.black
                                                        : Colors.grey,
                                                    width: subNoteColor == colorData['name'] ? 3 : 1,
                                                  ),
                                                ),
                                              ),
                                            ))
                                        .toList(),
                                  ),
                                );
                              },
                            );
                          },
                          padding: EdgeInsets.zero,
                          constraints: const BoxConstraints(),
                          color: Colors.blue.shade600,
                        ),
                      if (widget.onMoveSubNote != null)
                        IconButton(
                          icon: const Icon(Icons.move_up, size: 18),
                          onPressed: () => widget.onMoveSubNote!(index),
                          padding: EdgeInsets.zero,
                          constraints: const BoxConstraints(),
                          color: Colors.orange.shade600,
                        ),
                      IconButton(
                        icon: const Icon(Icons.close, size: 18),
                        onPressed: () {
                          if (widget.onDeleteSubNote != null) {
                            widget.onDeleteSubNote!(index);
                          }
                        },
                        padding: EdgeInsets.zero,
                        constraints: const BoxConstraints(),
                        color: Colors.red.shade400,
                      ),
                    ],
                  ),
                ),
              );
            }).toList(),
        ],
      ),
    );
  }
}
