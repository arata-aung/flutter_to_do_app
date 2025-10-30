import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:to_do_app/util/color_utils.dart';

class GroupTile extends StatelessWidget {
  final String groupName;
  final String icon;
  final String color;
  final bool expanded;
  final VoidCallback? onTap;
  final Function(BuildContext)? onDelete;
  final Function(BuildContext)? onEdit;

  const GroupTile({
    super.key,
    required this.groupName,
    required this.icon,
    required this.color,
    required this.expanded,
    this.onTap,
    this.onDelete,
    this.onEdit,
  });

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

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 20.0, top: 16, right: 20),
      child: Slidable(
        endActionPane: ActionPane(
          motion: const StretchMotion(),
          children: [
            SlidableAction(
              onPressed: onEdit,
              icon: Icons.edit,
              backgroundColor: Colors.blue.shade400,
              borderRadius: BorderRadius.circular(12),
            ),
            SlidableAction(
              onPressed: onDelete,
              icon: Icons.delete,
              backgroundColor: Colors.red.shade400,
              borderRadius: BorderRadius.circular(12),
            ),
          ],
        ),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(16),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  getColorFromString(color).withOpacity(0.7),
                  getColorFromString(color).withOpacity(0.5),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.3),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(
                    _getIconData(icon),
                    color: Colors.white,
                    size: 24,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Text(
                    groupName,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
                Icon(
                  expanded ? Icons.expand_less : Icons.expand_more,
                  color: Colors.white,
                  size: 28,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
