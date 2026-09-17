# ReviseGrid
 
A GitHub style contribution graph for your revision - log sessions from a home screen widget and track your streak.
 
## Why
 
Contribution graphs are motivating. The visual streak of GitHubs own graph is a good habit hook. ReviseGrid applies that same idea to studying - every subject you revise adds to a single daily square, and the more time you put in on a given day, the greener it gets.
 
## Features
 
- **Home screen widget** showing a compact GitHub style contribution graph of your recent revision activity, plus your current streak.
- **Tap-to-log panel** - tapping the widget opens the app straight into a panel that drops down from the top of the screen, offering a choice between starting a timer or logging manually.
- **Live timer** - start it when you sit down to revise, stop it when you're done, and the duration is logged automatically.
- **Manual logging** - pick a subject, a duration, and a date, for sessions you forgot to log.
- **Automatic streak tracking** - your streak counts any day you logged revision time at all, regardless of subject, and doesn't reset just because today hasn't happened yet.
- **Instant widget refresh** - the widget updates within seconds of logging a session, not just once a day.
- Subjects are created on the fly the first time you type a new one, and reused after that.
## Planned
 
- A dedicated screen showing total time revised per subject.
- Per subject contribution graphs.
- A Live Activity / Dynamic Island view for the running timer.
## Tech Stack
 
- **SwiftUI** for the entire interface, including a custom top down animated panel (custom overlay + transition).
- **SwiftData** for persistence, backed by a shared `ModelContainer` pointed at an App Group container so the app and widget read the same data.
- **WidgetKit** for the home screen widget and its timeline-based refresh.
- **Swift's Observation framework** (`@Observable`) for sharing panel state between views.
## Requirements
 
- Xcode 16 or later
- iOS 17+
## Trying the app
 
1. Clone the repo and open `ReviseGrid.xcodeproj` in Xcode.
2. Select the `ReviseGrid` target, then the `RevisionWidgetExtension` target, and under **Signing & Capabilities** -> **App Groups**, replace the existing group identifier with one registered under your own Apple Developer account (it needs to start with `group.`). Update the matching identifier in `SharedModelContainer.swift` to match.
3. Build and run the `ReviseGrid` scheme on a simulator or device running iOS 17+.
4. Add the widget from the home screen (long-press -> **+** -> search "ReviseGrid").
## Project Structure
 
```
ReviseGrid/
├── Shared/              # Code used by both the app and the widget extension
│   ├── Models/          # SwiftData models: Subject, RevisionSession
│   ├── Logic/           # Pure calculation: contribution graph data, streaks
│   └── Views/           # Views reused across app and widget contexts
├── ReviseGrid/           # Main app target
│   ├── Views/           # Screens and the log panel flow
│   └── ViewModels/       # Shared UI state (e.g. the log panel's mode)
└── RevisionWidget/       # Widget extension target
```
