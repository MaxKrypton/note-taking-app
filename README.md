# 📝 Notes App - Flutter Firebase Application

A Flutter note-taking app with Firebase authentication and Firestore database, implementing clean architecture with BLoC state management.

## ✨ Features

- **🔐 Authentication**: Email/password signup and login with input validation
- **📝 CRUD Operations**: Create, read, update, and delete notes in real-time
- **🎨 Modern UI**: Material Design with cards, floating action button, and feedback dialogs
- **🏗️ Clean Architecture**: BLoC pattern for state management, repository pattern for data access
- **⚡ Real-time Sync**: Live updates with Firestore database

## 🏗️ Architecture & State Management

### Project Structure
```
lib/
├── data/
│   ├── models/note_model.dart        # Note data model with Firestore mapping
│   └── repositories/                 # Data access layer
│       ├── auth_repository.dart      # Firebase Auth operations
│       └── notes_repository.dart     # Firestore CRUD operations
├── presentation/
│   ├── bloc/                         # BLoC state management
│   │   ├── auth/auth_bloc.dart       # Authentication states & events
│   │   └── notes/notes_bloc.dart     # Notes CRUD states & events
│   ├── pages/                        # Main screens
│   │   ├── auth_screen.dart          # Login/signup interface
│   │   └── notes_screen.dart         # Notes list and management
│   └── widgets/                      # Reusable UI components
│       ├── note_card.dart            # Individual note display
│       ├── add_note_dialog.dart      # Create note dialog
│       └── edit_note_dialog.dart     # Edit note dialog
└── main.dart                         # App setup with BLoC providers
```

### BLoC Pattern Implementation

This app uses **BLoC (Business Logic Component)** for state management, providing:
- **Separation of concerns**: UI logic separated from business logic
- **Reactive programming**: Stream-based state updates
- **Testability**: Easy to unit test business logic
- **Predictable state management**: Clear event → state flow

**How it works:**
1. **Events**: User actions trigger events (e.g., `NotesAddRequested`)
2. **BLoC**: Processes events and calls repository methods
3. **States**: Emits new states (e.g., `NotesLoading`, `NotesLoaded`)
4. **UI**: Rebuilds based on state changes

## 🗄️ Database Structure

**Firestore Collections:**
```
users/{userId}/notes/{noteId}
├── text: string           # Note content
├── createdAt: timestamp   # Creation time
├── updatedAt: timestamp   # Last modification
└── userId: string         # Owner reference
```

**Security Rules:**
```javascript
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    match /users/{userId}/notes/{noteId} {
      allow read, write: if request.auth != null && request.auth.uid == userId;
    }
  }
}
```

## 🛠️ Setup Instructions

### Prerequisites
- Flutter SDK (3.0.0+)
- Firebase account
- iOS Simulator/Android Emulator or physical device

### Installation
```bash
# Clone repository
git clone https://github.com/YOUR_USERNAME/note-taking-app.git
cd note-taking-app

# Install dependencies
flutter pub get
```

### Firebase Setup
1. **Create Firebase project** at [Firebase Console](https://console.firebase.google.com/)
2. **Enable Authentication** → Email/Password provider
3. **Create Firestore Database** in test mode
4. **Add iOS app** with bundle ID: `com.example.noteTakingApp`
5. **Add Android app** with package: `com.example.note_taking_app`
6. **Download config files**:
   - `GoogleService-Info.plist` → `ios/Runner/`
   - `google-services.json` → `android/app/`
7. **Configure FlutterFire**:
   ```bash
   dart pub global activate flutterfire_cli
   flutterfire configure
   ```

### Run the App
```bash
flutter clean
flutter pub get
flutter run
```

## 🎯 Key Implementation Details

### CRUD Operations
- **Create**: Add notes with validated input dialog
- **Read**: Fetch and display notes ordered by update time
- **Update**: Edit notes with pre-filled dialog
- **Delete**: Remove notes with confirmation dialog

### Authentication Flow
- Email/password validation with regex patterns
- Firebase Auth integration with error handling
- Persistent login state management
- Specific error messages for different failure cases

### UI Features
- Empty state hint: "Nothing here yet—tap ➕ to add a note"
- Loading indicators during operations
- Success (green) and error (red) SnackBars
- Delete confirmation dialogs
- Responsive design for portrait/landscape

## 🧪 Code Quality

**Run Dart Analyzer:**
```bash
flutter analyze
```

**Current Status:** ✅ Zero warnings and errors

## 📋 Assignment Requirements

- ✅ **Authentication Flow**: Email/password with full validation
- ✅ **CRUD Operations**: All four operations with Firestore sync
- ✅ **State Management**: BLoC pattern exclusively (no setState)
- ✅ **Clean Architecture**: Proper layer separation
- ✅ **UI/Feedback**: Material Design with loading states and SnackBars
- ✅ **Code Quality**: Zero analyzer warnings
- ✅ **Documentation**: Complete setup and architecture guide

## 🔧 Troubleshooting

**Firebase connection issues:**
```bash
flutterfire configure
```

**Build issues:**
```bash
flutter clean && flutter pub get
```

**iOS build problems:**
```bash
cd ios && rm -rf Pods Podfile.lock && cd ..
flutter clean && flutter pub get
```

## 👨‍💻 Author

**Gentil Quentin**
- GitHub: https://github.com/MaxKrypton/note-taking-app.git
- Email: q.rurangirw@alustudent.com

## 🚀 Demo

The app demonstrates:
- User signup/login with validation
- Real-time note creation and editing
- Firestore data persistence
- Clean BLoC state management
- Material Design UI principles

**Built with Flutter & Firebase** 🔥