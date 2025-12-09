# Blind Chess

A minimalist blind chess trainer for iOS (Flutter) that helps improve chess visualization skills through actual gameplay.

## Features

- **Empty Board Interface**: Play chess on a board showing only coordinates, no pieces
- **Tap-to-Move**: Simple tap/drag interface like standard chess apps
- **Streak Tracking**: Track consecutive legal moves to measure improvement
- **Piece Visibility Toggle**: Show/hide pieces at any time for learning or verification
- **Move History**: View complete game notation
- **Personal Best**: Track and save your best streak locally
- **AI Opponent**: Play against a simple AI (currently random moves, can be upgraded to Stockfish)

## Getting Started

### Prerequisites

- Flutter SDK (3.35.6 or later)
- iOS development environment (Xcode, CocoaPods)

### Installation

```bash
cd app
flutter pub get
```

### Running the App

```bash
cd app
flutter run
```

## Project Structure

```
blind-chess/
├── app/                    # Flutter application
│   ├── lib/
│   │   ├── models/        # Game state and data models
│   │   ├── widgets/       # Reusable UI components
│   │   ├── screens/       # Main screens
│   │   ├── services/      # Storage and external services
│   │   └── main.dart      # App entry point
│   └── pubspec.yaml       # Dependencies
└── README.md
```

## How to Play

1. **Start a new game** - Board is in standard starting position, but pieces are invisible
2. **Make moves** - Tap source square, then tap destination square
3. **Track your streak** - Each legal move increments your streak
4. **Toggle visibility** - Show/hide pieces anytime to verify or learn
5. **Beat your record** - Try to make as many consecutive legal moves as possible

## Tech Stack

- **Flutter** - Cross-platform UI framework
- **chess** (v0.8.1) - Chess logic and move validation
- **provider** - State management
- **shared_preferences** - Local data persistence

## Future Enhancements

- Color selection (play as White or Black)
- Adjustable AI difficulty (Stockfish integration)
- Voice input for moves
- Progressive training modes (fade pieces, memory mode)
- Achievements and challenges
- Cloud sync for cross-device progress
- Move validation hints
- Game replay with pieces visible

## License

MIT
