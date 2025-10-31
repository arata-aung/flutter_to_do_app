# to_do_app

A modern Flutter to-do list application with groups, sub-notes, and beautiful UI.

## Features

### ✨ Organization
- **Group Tasks** - Organize tasks into customizable groups
- **8 Group Icons** - Choose from person, work, home, shopping, fitness, book, star, and favorite
- **10 Colors** - Beautiful color options for both groups and tasks
- **Expand/Collapse** - Show or hide groups and sub-notes

### 📝 Task Management
- Create and manage to-do tasks
- Mark tasks as complete/incomplete
- Delete tasks with swipe gesture
- **Date & Time** - Set due dates and times for tasks (similar to Google Tasks)
- **Overdue indicators** - Visual highlighting for overdue tasks
- **Recurrence** - Set tasks to repeat daily, weekly, or monthly (automatically creates new task when completed)
- **Sub-notes** - Add one level of sub-tasks to any task
- Assign tasks to groups
- **Customize task colors** - Choose from 10 different colors for each task
- **Move tasks between groups** - Easily reorganize tasks across different groups
- **Move sub-notes between tasks** - Transfer sub-notes from one task to another
- **Customize sub-note colors** - Each sub-note can have its own color
- **Drag and drop** - Reorder tasks when no groups exist
- **Filter & Sort** - Filter by status or color, sort by name or completion status

### 🎨 Modern UI
- Material Design 3 principles
- Gradient backgrounds with shadows
- Rounded corners and smooth animations
- Clean and intuitive interface
- Empty state guidance

### 💾 Data Persistence
- Local storage using Hive
- Automatic data migration
- User authentication

## How to Use

### Managing Groups
**Create a Group:**
1. Tap the orange folder button at the bottom right
2. Enter a group name
3. Select an icon that represents the group
4. Choose a color
5. Tap "Save"

**Edit a Group:**
1. Swipe left on the group
2. Tap the edit icon (✏️)
3. Modify name, icon, or color
4. Tap "Save"

**Delete a Group:**
1. Swipe left on the group
2. Tap the delete icon (🗑️)
3. Confirm deletion (all tasks in the group will be deleted)

**Expand/Collapse:**
- Tap on any group tile to show or hide its tasks

### Managing Tasks
**Create a Task:**
1. Tap the blue plus (+) button at the bottom right
2. Select which group to add the task to (if multiple groups exist)
3. Enter your task name
4. Select a color from the color picker
5. (Optional) Set a due date by tapping "Select Date"
6. (Optional) If date is set, you can also set a time by tapping "Select Time"
7. (Optional) Set a recurrence pattern: None, Daily, Weekly, or Monthly
8. Tap "Save"

**Add Sub-notes:**
1. Click the + button on any task
2. Enter the sub-note text
3. Tap "Add"
4. Sub-notes appear indented under the parent task

**Complete Sub-notes:**
- Click the checkbox on any sub-note to mark it complete
- Completed sub-notes show with strikethrough text

**Expand/Collapse Sub-notes:**
- If a task has sub-notes, a badge shows the count
- Tap the expand/collapse icon to show or hide sub-notes

**Edit Task Options:**
1. Swipe left on any task to reveal action buttons
2. Tap the "Options" button (⋮) to see:
   - Edit Date & Time
   - Change Color
   - Move to Group (if multiple groups exist)
3. Or tap the "Delete" button to remove the task

**Set or Edit Due Date, Time & Recurrence:**
1. Use the "Options" menu and select "Edit Date & Time", or
2. Tap directly on the displayed date/time indicator on the task
3. Select a due date from the calendar picker
4. (Optional) Select a time from the time picker
5. (Optional) Set recurrence: None, Daily, Weekly, or Monthly
6. Tap "Save"
7. To clear date/time, tap the X button next to the date or time field

**View Due Dates and Recurrence:**
- Tasks with due dates show a calendar icon and date below the task name
- Tasks due today are labeled "Today"
- **Overdue tasks** are highlighted with a red background and border
- Recurring tasks show a repeat icon (🔁) with the recurrence pattern
- When you complete a recurring task, a new instance is automatically created with the next due date

**Reorder Tasks:**
- When no groups exist, long-press and drag tasks to reorder them
- Sub-notes show a drag handle icon (☰) indicating they can be reordered

**Delete a Task:**
1. Swipe left on the task
2. Tap the delete icon (🗑️)

**Delete a Sub-note:**
1. Expand the task to show sub-notes
2. Click the X button on the sub-note you want to remove

**Move Task Between Groups:**
1. Swipe left on any task (when multiple groups exist)
2. Tap the move icon (📁)
3. Select the target group from the dialog
4. Task moves to the selected group

**Move Sub-note to Another Task:**
1. Expand the task to show sub-notes
2. Click the move up icon (↑) on the sub-note
3. Select the target task from the dialog
4. Sub-note moves to the selected task

**Change Sub-note Color:**
1. Expand the task to show sub-notes
2. Click the palette icon (🎨) on any sub-note
3. Select a new color from the color picker
4. The sub-note color updates immediately

**Filter & Sort Tasks:**
1. Tap the filter icon in the app bar (top right)
2. Select status filter: All, Completed, or Incomplete
3. Select color filter: All or specific color
4. Select sort option: None, Name (alphabetical), or Status (incomplete first)
5. Active filters show a red indicator on the filter icon
6. Tap "Reset" to clear all filters and sorting

### Available Colors
- Yellow
- Red
- Blue
- Green
- Orange
- Purple
- Pink
- Teal
- Cyan
- Amber

### Available Group Icons
- Person (👤) - Personal tasks
- Work (💼) - Professional tasks
- Home (🏠) - Household tasks
- Shopping (🛒) - Shopping lists
- Fitness (💪) - Exercise and health
- Book (📚) - Learning and reading
- Star (⭐) - Important items
- Favorite (❤️) - Priority tasks

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://docs.flutter.dev/cookbook)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.
