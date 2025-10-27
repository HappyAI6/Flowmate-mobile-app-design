# FlowMate App - Visual Preview 📱

This document provides a comprehensive visual preview of the FlowMate Flutter app, showing you exactly how each screen looks and functions.

## 🎨 Design Overview

FlowMate features a **modern, clean design** with:
- **Purple to Blue Gradients** throughout the app
- **Material Design 3** components
- **Inter Font Family** for beautiful typography
- **Rounded corners** and **soft shadows**
- **Dark/Light mode** support
- **Smooth animations** and transitions

---

## 📱 Screen-by-Screen Preview

### 1. 🌟 **Splash Screen**
```
┌─────────────────────────────────────┐
│                                     │
│        [Purple-Blue Gradient]       │
│                                     │
│              ⏰ (Icon)              │
│                                     │
│            FlowMate                 │
│      Your all-in-one productivity   │
│             companion               │
│                                     │
│              ○ ○ ○                  │ ← Loading indicator
│                                     │
└─────────────────────────────────────┘
```
- **Background**: Beautiful purple-to-blue gradient
- **App Icon**: Large white timer icon with shadow
- **Typography**: Large "FlowMate" title with subtitle
- **Animation**: Smooth fade-in and scale animations

---

### 2. 🎉 **Welcome Screen**
```
┌─────────────────────────────────────┐
│     [Light gradient background]     │
│                                     │
│              ⏰                     │ ← App icon with gradient
│                                     │
│            FlowMate                 │
│    Your all-in-one productivity     │
│           companion                 │
│                                     │
│    ┌─────────────────────────────┐  │
│    │      Get Started            │  │ ← Primary button
│    └─────────────────────────────┘  │
│                                     │
│         Create Account              │ ← Text button
│                                     │
└─────────────────────────────────────┘
```
- **Clean, welcoming interface**
- **Gradient app icon** with shadow
- **Call-to-action buttons** with proper hierarchy

---

### 3. 🔐 **Login Screen**
```
┌─────────────────────────────────────┐
│ ←  [Back button]                    │
│                                     │
│    ┌─────────────────────────────┐  │
│    │                             │  │
│    │      Welcome Back           │  │
│    │    Sign in to continue      │  │
│    │                             │  │
│    │ 📧 Email                    │  │
│    │ [________________]           │  │
│    │                             │  │
│    │ 🔒 Password                 │  │
│    │ [________________] 👁        │  │
│    │                             │  │
│    │ ┌─────────────────────────┐ │  │
│    │ │      Sign In            │ │  │
│    │ └─────────────────────────┘ │  │
│    │                             │  │
│    └─────────────────────────────┘  │
│                                     │
└─────────────────────────────────────┘
```
- **Card-based form design**
- **Input fields** with icons and validation
- **Password visibility toggle**
- **Gradient button** styling

---

### 4. 📝 **Signup Screen**
```
┌─────────────────────────────────────┐
│ ←  [Back button]                    │
│                                     │
│    ┌─────────────────────────────┐  │
│    │                             │  │
│    │     Create Account          │  │
│    │    Join FlowMate today      │  │
│    │                             │  │
│    │ 👤 Full Name                │  │
│    │ [________________]           │  │
│    │                             │  │
│    │ 📧 Email                    │  │
│    │ [________________]           │  │
│    │                             │  │
│    │ 🔒 Password                 │  │
│    │ [________________] 👁        │  │
│    │                             │  │
│    │ ┌─────────────────────────┐ │  │
│    │ │   Create Account        │ │  │
│    │ └─────────────────────────┘ │  │
│    │                             │  │
│    └─────────────────────────────┘  │
│                                     │
└─────────────────────────────────────┘
```
- **Three-field registration form**
- **Form validation** for all inputs
- **Consistent design** with login screen

---

### 5. 🏠 **Home Dashboard**
```
┌─────────────────────────────────────┐
│   [Purple-Blue Gradient Header]     │
│                                     │
│  Good morning, John! 😊         ⋮   │ ← Greeting + Menu
│  Ready to be productive?            │
│                                     │
└─────────────────────────────────────┘
│                                     │
│  ┌─────────────┐ ┌─────────────┐   │ ← Stats Grid
│  │ ✅    5     │ │ 📅    3     │   │
│  │Tasks Today  │ │Events Today │   │
│  └─────────────┘ └─────────────┘   │
│                                     │
│  ┌─────────────┐ ┌─────────────┐   │
│  │ 📝    12    │ │ ⏱    4     │   │
│  │   Notes     │ │Focus Sessions│   │
│  └─────────────┘ └─────────────┘   │
│                                     │
│  ┌─────────────────────────────┐   │ ← Progress Card
│  │       Today's Progress       │   │
│  │                             │   │
│  │ Tasks Completed    3/5      │   │
│  │ ████████░░                  │   │ ← Progress bar
│  │                             │   │
│  │ Focus Sessions     4 completed │
│  │ ████████░░                  │   │
│  └─────────────────────────────┘   │
│                                     │
│ [🏠] [✅] [📅] [📝] [⏱]          │ ← Bottom nav
└─────────────────────────────────────┘
```

**Key Features:**
- **Personalized greeting** with time-based messages
- **Beautiful gradient header**
- **Statistics cards** with color-coded backgrounds
- **Progress tracking** with visual indicators
- **Bottom navigation** with 5 tabs

---

### 6. ✅ **Tasks Screen**
```
┌─────────────────────────────────────┐
│      [Purple-Blue Gradient]         │
│                                     │
│            Tasks               +    │ ← Header with add button
│                                     │
└─────────────────────────────────────┘
│                                     │
│ [All (8)] [Pending (5)] [Done (3)] │ ← Tab navigation
│                                     │
│ ┌─────────────────────────────────┐ │
│ │ ○ Buy groceries             ⋮  │ │ ← Task card
│ │   Get milk, bread, and eggs    │ │
│ │   [HIGH] [Due: Dec 25]          │ │
│ └─────────────────────────────────┘ │
│                                     │
│ ┌─────────────────────────────────┐ │
│ │ ✓ Complete project          ⋮  │ │ ← Completed task
│ │   Finish the mobile app         │ │
│ │   [MEDIUM] [Due: Dec 20]        │ │
│ └─────────────────────────────────┘ │
│                                     │
│                              [+]    │ ← Floating action button
│                                     │
│ [🏠] [✅] [📅] [📝] [⏱]          │
└─────────────────────────────────────┘
```

**Key Features:**
- **Tab-based filtering** (All, Pending, Done)
- **Task cards** with checkboxes for completion
- **Priority indicators** with color coding
- **Due date badges** with overdue highlighting
- **Action menus** for edit/delete options
- **Floating action button** for quick task creation

---

### 7. 📋 **Task Creation Dialog**
```
┌─────────────────────────────────────┐
│                                     │
│    ┌─────────────────────────────┐  │
│    │                             │  │
│    │       Add New Task          │  │
│    │                             │  │
│    │ Task Title                  │  │
│    │ [________________]           │  │
│    │                             │  │
│    │ Description (Optional)      │  │
│    │ [________________]           │  │
│    │ [________________]           │  │
│    │                             │  │
│    │ Priority         [MEDIUM ▼] │  │
│    │                             │  │
│    │ Due Date (Optional)         │  │
│    │ [Select due date     ▼]     │  │
│    │                             │  │
│    │ [Cancel]    [Add Task]      │  │
│    │                             │  │
│    └─────────────────────────────┘  │
│                                     │
└─────────────────────────────────────┘
```

**Features:**
- **Clean modal dialog** design
- **Form validation** for required fields
- **Priority dropdown** with color indicators
- **Date picker** integration
- **Action buttons** with proper hierarchy

---

### 8. 📅 **Calendar Screen** (Placeholder)
```
┌─────────────────────────────────────┐
│      [Purple-Blue Gradient]         │
│                                     │
│          Calendar              +    │
│                                     │
└─────────────────────────────────────┘
│                                     │
│                                     │
│              📅                     │
│                                     │
│        Calendar Screen              │
│                                     │
│         Coming soon...              │
│                                     │
│                                     │
│                                     │
│ [🏠] [✅] [📅] [📝] [⏱]          │
└─────────────────────────────────────┘
```

---

### 9. 📝 **Notes Screen** (Placeholder)
```
┌─────────────────────────────────────┐
│      [Purple-Blue Gradient]         │
│                                     │
│           Notes                +    │
│                                     │
└─────────────────────────────────────┘
│                                     │
│                                     │
│              📝                     │
│                                     │
│         Notes Screen                │
│                                     │
│         Coming soon...              │
│                                     │
│                                     │
│                                     │
│ [🏠] [✅] [📅] [📝] [⏱]          │
└─────────────────────────────────────┘
```

---

### 10. ⏱️ **Focus Timer Screen** (Placeholder)
```
┌─────────────────────────────────────┐
│      [Purple-Blue Gradient]         │
│                                     │
│        Focus Timer             +    │
│                                     │
└─────────────────────────────────────┘
│                                     │
│                                     │
│              ⏱️                     │
│                                     │
│      Focus Timer Screen             │
│                                     │
│         Coming soon...              │
│                                     │
│                                     │
│                                     │
│ [🏠] [✅] [📅] [📝] [⏱]          │
└─────────────────────────────────────┘
```

---

## 🎨 **Design System**

### **Color Palette**
- **Primary Purple**: `#8B5CF6`
- **Primary Blue**: `#3B82F6`
- **High Priority**: `#EF4444` (Red)
- **Medium Priority**: `#F59E0B` (Orange)
- **Low Priority**: `#10B981` (Green)
- **Background Light**: `#FFFBFF`
- **Background Dark**: `#111827`

### **Typography**
- **Font Family**: Inter (Google Fonts)
- **Headings**: Bold weights (600-700)
- **Body**: Regular and Medium weights (400-500)
- **Labels**: Medium weight (500)

### **Spacing**
- **Card Padding**: 16-20px
- **Section Spacing**: 24px
- **Element Spacing**: 8-16px
- **Screen Padding**: 16-24px

### **Shadows & Borders**
- **Card Elevation**: Soft shadows with opacity
- **Border Radius**: 12-16px for cards, 8px for buttons
- **Button Elevation**: Subtle depth for interactive elements

---

## 📱 **Interactive Features**

### **Animations**
- **Screen Transitions**: Smooth fade and slide animations
- **Button Presses**: Ripple effects and scale feedback
- **Loading States**: Spinner indicators and skeleton screens
- **Splash Screen**: Scale and fade-in animations

### **Gestures**
- **Tap**: Navigation and action triggers
- **Long Press**: Context menus (future feature)
- **Swipe**: Tab navigation and dismiss actions
- **Pull to Refresh**: Data refresh (future feature)

### **Feedback**
- **Visual**: Color changes, shadows, and highlights
- **Haptic**: Button presses and confirmations (mobile)
- **Audio**: System sounds for actions (optional)

---

## 🌓 **Dark Mode Preview**

When dark mode is enabled:
- **Backgrounds**: Deep grays and blacks
- **Cards**: Dark gray with subtle borders
- **Text**: Light gray and white
- **Gradients**: Darker purple/blue variants
- **Shadows**: Reduced opacity for better contrast

---

## 📝 **Key User Flows**

### **New User Journey**
1. **Splash Screen** → **Welcome** → **Signup** → **Home**
2. First-time setup with empty state guidance

### **Daily Usage**
1. **Home Dashboard** → Quick overview of today's productivity
2. **Tasks Tab** → Add, complete, and manage tasks
3. **Settings Menu** → Toggle dark mode, logout

### **Task Management**
1. **Tasks Screen** → View all tasks with filtering
2. **Add Task** → Fill form with validation
3. **Complete Task** → Tap checkbox with visual feedback
4. **Edit Task** → Tap card to open edit dialog

---

This Flutter app delivers a **beautiful, intuitive, and fully functional** productivity experience that perfectly matches modern mobile app design standards! 🚀