# Color Setting Feature - Architecture Diagram

```
┌─────────────────────────────────────────────────────────────────┐
│                         User Interface                          │
└─────────────────────────────────────────────────────────────────┘
                                │
                                ▼
┌─────────────────────────────────────────────────────────────────┐
│                          HomePage                               │
│  - Displays list of to-dos                                      │
│  - Handles color changes via changeTaskColor()                  │
│  - Passes color to ToDoTile widgets                            │
└─────────────────────────────────────────────────────────────────┘
                    │                           │
        ┌───────────┘                           └───────────┐
        ▼                                                   ▼
┌──────────────────────┐                    ┌──────────────────────┐
│     DialogBox        │                    │      ToDoTile        │
│  (Create New Task)   │                    │  (Display Task)      │
├──────────────────────┤                    ├──────────────────────┤
│ - Text input         │                    │ - Shows task name    │
│ - Color picker       │                    │ - Shows checkbox     │
│ - 10 color options   │                    │ - Displays color     │
│ - Returns selected   │                    │ - Swipe actions:     │
│   color to HomePage  │                    │   * Color picker     │
└──────────────────────┘                    │   * Delete           │
        │                                   └──────────────────────┘
        │                                             │
        └─────────────┐                   ┌───────────┘
                      ▼                   ▼
            ┌───────────────────────────────────┐
            │       color_utils.dart            │
            │  (Shared Color Management)        │
            ├───────────────────────────────────┤
            │ - availableColors list            │
            │ - getColorFromString()            │
            │ - Single source of truth          │
            └───────────────────────────────────┘
                              │
                              ▼
            ┌───────────────────────────────────┐
            │        ToDoDatabase               │
            │    (Data Persistence)             │
            ├───────────────────────────────────┤
            │ - Stores [name, done, color]      │
            │ - Migrates old data               │
            │ - Uses Hive for storage           │
            └───────────────────────────────────┘
                              │
                              ▼
            ┌───────────────────────────────────┐
            │          Hive Storage             │
            │      (Local Database)             │
            └───────────────────────────────────┘
```

## Data Flow

### Creating a New Task
```
User Input → DialogBox (with color picker) 
    → User selects color
    → onSave(color) called
    → HomePage.saveNewTask(color)
    → Add [name, false, color] to list
    → ToDoDatabase.updateDatabase()
    → Hive stores data
    → UI refreshes
```

### Changing Task Color
```
User swipes task → ToDoTile shows actions
    → User taps color lens icon
    → Color picker dialog appears
    → User selects new color
    → onColorChanged(color) called
    → HomePage.changeTaskColor(index, color)
    → Update list[index][2] = color
    → ToDoDatabase.updateDatabase()
    → Hive stores data
    → UI refreshes
```

### Loading Existing Data
```
App starts → Hive.initFlutter()
    → Hive.openBox('mybox')
    → HomePage.initState()
    → ToDoDatabase.loadData()
    → Check if data exists
    → Migrate old data (add "yellow" if missing)
    → Display tasks with colors
```

## Component Responsibilities

### HomePage
- Manages state of to-do list
- Coordinates between UI and data layer
- Handles user actions (add, delete, toggle, change color)

### ToDoTile
- Displays individual task
- Shows task color using color_utils
- Provides color change UI via swipe gesture

### DialogBox
- New task creation interface
- Color selection for new tasks
- Returns selected color to parent

### color_utils
- Central color management
- Consistent color definitions
- String to Color conversion

### ToDoDatabase
- Data persistence layer
- Migration logic for old data
- Interaction with Hive storage

## Color Data Structure

```dart
// Each task in toDoList
[
  "Task name",      // String: The task description
  false,            // bool: Completion status
  "yellow"          // String: Color name
]

// Example
["Buy groceries", false, "blue"]
["Write code", true, "green"]
```

## Migration Strategy

```dart
// Old format (before feature)
["Task", false]

// After migration
["Task", false, "yellow"]  // Default color added

// New tasks
["Task", false, "red"]     // User-selected color
```

## Color Constants

```dart
availableColors = [
  {'name': 'yellow', 'color': Colors.yellow},
  {'name': 'red', 'color': Colors.red},
  // ... 8 more colors
]
```
