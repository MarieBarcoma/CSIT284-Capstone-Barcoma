# Clinic Visit Log

A mobile app for a school clinic. Students log a clinic visit (symptom + time), and the clinic nurse sees a live queue and marks each visit as **attended**.

> **Demo video:** _add link here_

## Features

**Student**
- Log a visit with student ID, name, symptom (from a fixed list) and an optional note. The time is recorded automatically.
- View their own visit history and the status of each visit (Waiting / Attended).
- Cancel a visit while it is still waiting.

**Nurse (hidden screen)**
- Long-press the **Clinic Visit Log** title and enter the PIN (`1234`) to open the nurse screen.
- **Waiting** tab: live queue, oldest first, with a queue number and how long each student has waited.
- **Attend** button marks a visit as attended and moves it to the **Attended today** tab.

## Scope decisions

To keep the project finishable in 3 weeks, these were deliberately left out:

| Cut | Reason |
|---|---|
| Login / authentication | Students type their ID. The nurse screen uses a simple hardcoded PIN. |
| Medical records | The app only logs visits. It does not store diagnoses or treatment history. |
| Medicine inventory | Outside the core visit-logging flow. |
| Separate nurse app | The nurse side is a single hidden screen in the same app. |

## Tech stack

- **Flutter** (Dart) with Material 3 default components
- **Firebase Cloud Firestore** for real-time data _(Week 2)_
- Built in **VS Code** with the Flutter and Dart extensions; tested on an Android emulator

## Data structure (Firestore)

Collection: `visits`. Each document has:

| Field | Type | Example |
|---|---|---|
| `studentId` | string | `21-1234-567` |
| `studentName` | string | `Ana Reyes` |
| `symptom` | string | `Headache` |
| `note` | string | `Since 2nd period` |
| `timestamp` | timestamp | when the visit was logged |
| `status` | string | `waiting` or `attended` |
| `attendedAt` | timestamp / null | set when the nurse marks it attended |

## CRUD mapping

| Operation | Where |
|---|---|
| Create | Student submits the Log Visit form |
| Read | Nurse queue, Attended today, My Visits |
| Update | Nurse taps **Attend** (`status` → `attended`) |
| Delete | Student cancels a waiting visit |

## Project structure

```
lib/
  main.dart                  App entry + Material 3 theme
  app_state.dart             Shared repository, current student ID, nurse PIN
  models/visit.dart          Visit data class
  data/
    visit_repository.dart    Data interface + in-memory version (Week 1)
    seed_data.dart           Symptom list + dummy visits
  screens/
    home_shell.dart          Bottom navigation + hidden nurse entry
    log_visit_screen.dart    Student: log a visit
    my_visits_screen.dart    Student: visit history
    nurse_queue_screen.dart  Nurse: queue + attended today
  widgets/empty_state.dart
  utils/time_format.dart
```

## How to run

1. Install the [Flutter SDK](https://docs.flutter.dev/get-started/install) (3.35 or newer) and Android Studio (for the Android SDK and emulator).
2. In VS Code, install the **Flutter** extension (it also installs Dart).
3. Open the `capstone_barcoma` folder in VS Code and get packages:
   ```
   flutter pub get
   ```
4. Start an Android emulator, then press `Ctrl+Shift+P` → **Flutter: Select Device** and choose it.
5. Press **F5** (or run `flutter run`).

### Firebase setup _(Week 2)_

_Fill in the steps after connecting Firebase: create the Firebase project, run `flutterfire configure`, add `firebase_core` and `cloud_firestore`._

## Screenshots

_Add screenshots: Log Visit, My Visits, Nurse Queue, Attended today._

## Team

_Add member names and roles._