# Color Setting Feature - Visual Guide

## UI Screenshots (Conceptual)

### Before (Original App)
```
┌────────────────────────────────┐
│ To Do                          │
└────────────────────────────────┘
┌────────────────────────────────┐
│ ☐ Make Tutorial        🟡      │  All tasks
│                                │  were yellow
├────────────────────────────────┤
│ ☐ Do Exercise          🟡      │
│                                │
└────────────────────────────────┘
                                 (+)
```

### After (With Color Feature)
```
┌────────────────────────────────┐
│ To Do                          │
└────────────────────────────────┘
┌────────────────────────────────┐
│ ☐ Make Tutorial        🔴      │  Now tasks
│                                │  can have
├────────────────────────────────┤  different
│ ☐ Do Exercise          🔵      │  colors!
│                                │
├────────────────────────────────┤
│ ☐ Buy Groceries        🟢      │
│                                │
└────────────────────────────────┘
                                 (+)
```

## User Interactions

### 1. Creating a New Task with Color

**Step 1: Tap the + button**
```
┌────────────────────────────────┐
│ To Do                          │
└────────────────────────────────┘
│ ☐ Existing Task        🟡      │
│                                │
└────────────────────────────────┘
                              (🔘+) ← Tap here
```

**Step 2: Add Task Dialog Appears**
```
        ┌──────────────────────┐
        │ Add a new task       │
        │ ┌──────────────────┐ │
        │ │ Buy groceries_   │ │ ← Type task
        │ └──────────────────┘ │
        │                      │
        │ Choose Color:        │
        │                      │
        │ 🟡 🔴 🔵 🟢 🟠      │ ← Select color
        │ 🟣 💗 💚 🔷 🟨      │
        │                      │
        │ [Save]    [Cancel]   │
        └──────────────────────┘
```

**Step 3: Task Added with Selected Color**
```
┌────────────────────────────────┐
│ To Do                          │
└────────────────────────────────┘
│ ☐ Existing Task        🟡      │
├────────────────────────────────┤
│ ☐ Buy groceries        🟢      │ ← New task!
└────────────────────────────────┘
```

### 2. Changing Color of Existing Task

**Step 1: Swipe Left on Task**
```
┌────────────────────────────────┐
│ ☐ Buy groceries    🟢 │🎨│🗑️│ │
│                    ◀─────────   │ ← Swipe
└────────────────────────────────┘
```

**Step 2: Tap Color Lens Icon**
```
        ┌──────────────────────┐
        │ Choose Color         │
        │                      │
        │ 🟡 🔴 🔵 🟢 🟠      │
        │ 🟣 💗 💚 🔷 🟨      │ ← Select new
        │                      │   color
        │ Current: 🟢 (bold)   │
        └──────────────────────┘
```

**Step 3: Color Updated**
```
┌────────────────────────────────┐
│ ☐ Buy groceries        🔵      │ ← Changed!
└────────────────────────────────┘
```

## Color Palette

### Available Colors

```
🟡 Yellow   - Default, bright, neutral
🔴 Red      - Urgent, important
🔵 Blue     - Work, professional
🟢 Green    - Health, nature
🟠 Orange   - Creative, energetic
🟣 Purple   - Personal, unique
💗 Pink     - Social, fun
💚 Teal     - Calm, organized
🔷 Cyan     - Tech, modern
🟨 Amber    - Warning, attention
```

### Example Use Cases

```
Work Tasks:
│ ☐ Team meeting            🔵 Blue
│ ☐ Code review             🔵 Blue
│ ☐ Project deadline        🔴 Red (urgent)

Personal Tasks:
│ ☐ Gym                     🟢 Green
│ ☐ Grocery shopping        🟠 Orange
│ ☐ Call mom                💗 Pink

Organizing by Priority:
│ ☐ Critical bug fix        🔴 Red (highest)
│ ☐ Update docs             🟨 Amber (medium)
│ ☐ Nice to have feature    💚 Teal (lowest)
```

## Interactive Elements

### New Task Dialog
```
┌─────────────────────────────────┐
│  Add a new task                 │
│  ┏━━━━━━━━━━━━━━━━━━━━━━━━┓  │
│  ┃ Enter task here...     ┃  │ ← Text input
│  ┗━━━━━━━━━━━━━━━━━━━━━━━━┛  │
│                                 │
│  Choose Color:                  │
│                                 │
│  ● ● ● ● ●                     │ ← Color circles
│  ● ● ● ● ●                     │   Click to select
│                                 │
│  Selected: 🟡 Yellow            │ ← Shows current
│                                 │
│  ┌──────┐  ┌────────┐          │
│  │ Save │  │ Cancel │          │ ← Action buttons
│  └──────┘  └────────┘          │
└─────────────────────────────────┘
```

### Task Tile (Swipe Actions)
```
Normal State:
┌──────────────────────────────────┐
│ ☐ Task name            🟢        │
└──────────────────────────────────┘

Swiped Left:
┌──────────────────────────────────┐
│ ☐ Task name    🟢 │ 🎨 │ 🗑️  │  │
└──────────────────────────────────┘
                       │    └─ Delete
                       └─ Change Color
```

### Color Picker Dialog
```
┌─────────────────────────────────┐
│  Choose Color                   │
│                                 │
│     Current color               │
│        ▼                        │
│  ┏━━┓ ● ● ● ●                  │
│  ┃●┃ ● ● ● ● ●                 │ ← Color options
│  ┗━━┛                           │   Bold border
│                                 │    = selected
└─────────────────────────────────┘
    ▲
    Selected color highlighted
```

## Visual Feedback

### Color Selection States

**Unselected:**
```
  ●   ← Thin gray border
```

**Selected:**
```
 ┏━┓  ← Thick black border
 ┃●┃
 ┗━┛
```

**Hover (on web/desktop):**
```
  ●   ← Slight enlargement
 ╱ ╲  ← Shadow effect
```

## Accessibility Notes

- Colors have distinct hues for color-blind users
- Task text remains black for readability
- Swipe gesture has visual indicators
- Touch targets are 40x40 minimum (Material Design)

## Responsive Behavior

### Phone (Portrait)
```
┌──────────────────┐
│ To Do       [☰]  │
├──────────────────┤
│ ☐ Task 1    🟡   │
│ ☐ Task 2    🔴   │
│ ☐ Task 3    🔵   │
│ ☐ Task 4    🟢   │
│                  │
└──────────────────┘
              (+)
```

### Tablet (Landscape)
```
┌────────────────────────────────────┐
│ To Do                         [☰]  │
├────────────────────────────────────┤
│ ☐ Task 1    🟡  │ ☐ Task 3    🔵  │
│ ☐ Task 2    🔴  │ ☐ Task 4    🟢  │
│                 │                  │
└────────────────────────────────────┘
                            (+)
```

## Animation & Transitions

**Color Change:**
```
Old color → Cross-fade → New color
🟡        →    (0.3s)  →    🔵
```

**Dialog Appearance:**
```
Scale up from center + Fade in
(Material Design standard)
```

**Swipe Actions:**
```
Slide left reveals action buttons
Elastic snap animation
```
