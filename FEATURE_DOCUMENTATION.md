# Color Setting Feature - Implementation Details

## Overview
This feature allows users to customize the color of each to-do item in the app, providing visual organization and personalization.

## User Workflows

### 1. Creating a New Task with Color
1. User taps the floating action button (+) in the bottom right
2. A dialog appears with:
   - Text field for task name
   - Color picker showing 10 circular color options
3. User selects a color (yellow is selected by default)
4. User taps "Save"
5. The new task appears with the selected color

### 2. Changing Color of Existing Task
1. User swipes left on any task
2. Two action buttons appear:
   - Color lens icon (blue) - for changing color
   - Delete icon (red) - for removing task
3. User taps the color lens icon
4. A dialog appears with 10 color options
5. Current color is highlighted with a thicker border
6. User selects a new color
7. The task color updates immediately

## Technical Implementation

### Data Structure
Each to-do item is stored as a list with 3 elements:
```dart
[taskName, isCompleted, color]
// Example: ["Buy groceries", false, "blue"]
```

### Available Colors
1. Yellow (default)
2. Red
3. Blue
4. Green
5. Orange
6. Purple
7. Pink
8. Teal
9. Cyan
10. Amber

### Migration Strategy
Old data without color field is automatically migrated:
- When loading existing data, any task with only 2 elements gets "yellow" added
- This ensures backward compatibility
- No data loss occurs

### Code Organization
- `color_utils.dart` - Centralized color constants and utilities
- `dialog_box.dart` - Color picker for new tasks
- `todo_tile.dart` - Color display and color change dialog
- `database.dart` - Data persistence with migration
- `home_page.dart` - Coordinates color changes and updates

## Design Decisions

### Why Swipe Gesture?
- Keeps the main interface clean
- Follows Material Design patterns (used by Gmail, etc.)
- Same gesture already used for delete action

### Why Color Circles?
- Visual preview of actual color
- Easy to select
- Common pattern in color pickers
- Works well in limited space

### Why These 10 Colors?
- Based on Material Design color palette
- Good contrast against various backgrounds
- Distinct enough to tell apart
- Covers common user preferences

### Default Color (Yellow)
- Matches the app's existing yellow theme
- Provides continuity with original design
- Bright and neutral choice

## Testing
Unit tests cover:
- Initial data creation with color field
- Data migration from old format
- Adding tasks with custom colors
- Changing task colors
- Default color assignment

## Future Enhancements (Not Implemented)
- Custom color picker with full spectrum
- Color-based filtering/sorting
- Color themes/presets
- Accessibility considerations (patterns in addition to colors)
