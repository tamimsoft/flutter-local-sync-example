# Flutter Local Sync Example

A Flutter example project demonstrating **offline-first local data synchronization** between multiple app instances on the same device using **Hive** for storage and **Cubit** for state management.

✅ Works on **Android**, **Linux**, **macOS**, and **Windows**.  
🚫 **iOS does not support local shared data sync due to platform restrictions.**  
🚫 No backend or internet connection required for local sync a single instances,  
🌐 **But internet is required to simulate real live data sync across multiple instances.**

---


## 🧭 Overview

This project demonstrates:

- Local data syncing between multiple instances **on the same device**.
- Offline-first architecture using Hive and Cubit.
- Clean architecture with repository, service, and cubit layers.

> **Important:**
> - The local sync solution uses TCP sockets or shared files **only for multiple instances on the same device**.
> - TCP socket sync **cannot support multiple physical devices on a LAN or over the internet**.
> - To sync data **across multiple devices**, an internet connection and backend/cloud service are required, which this project does **not** implement.

---

## 🚀 Features

- ✅ Multiple isolated app instances with separate Hive boxes.
- 🔄 Background sync between instances via shared file system or socket.
- 📦 Clean architecture: `Repository → Service → Cubit → UI`.
- 🧠 Lightweight Cubit state management.
- 📱 Responsive UI to show live sync changes.

---

## 🧱 Project Structure

```
lib/
├── app/
│   ├── common/widget/         # Reusable UI components
│   ├── config/
│   │   ├── injectable/        # Dependency injection setup
│   │   └── routes/            # App routing config
│   ├── core/
│   │   ├── constants/         # App-wide constants
│   │   ├── exception/         # Custom exceptions
│   │   ├── services/
│   │   │   ├── database/      # Hive DB setup and helpers
│   │   │   ├── logger/        # Logging utility
│   │   │   └── sync/          # Local sync service and socket client/server
│   │   ├── theme/             # Theme and styling
│   │   └── utils/             # Utility functions
│
├── features/medicine/
│   ├── adapter/               # Hive model adapters
│   ├── data/
│   │   ├── model/             # Medicine model
│   │   ├── repository/        # Data access logic
│   │   └── service/           # Business logic
│   └── ui/
│       ├── cubit/             # State management (Cubit)
│       ├── widget/            # Feature-specific widgets
│       └── medicine_page.dart
│
├── app.dart                  # App-wide setup and routes
└── main.dart                 # Application entry point
```

---

## ⚙️ Getting Started

### ✅ Prerequisites

- Flutter SDK (3.x or above)
- Dart SDK (comes with Flutter)
- Android device/emulator, or desktop environment

### 🔧 Installation

1. Clone the repository:
   ```bash
   git clone https://github.com/tamimsoft/flutter-local-sync-example.git
   cd flutter-local-sync-example
   ```

2. Install dependencies:
   ```bash
   flutter pub get
   ```

3. Run the app:
   ```bash
   flutter run
   ```

---

## 📱 Usage (Run Multiple Instances)

To simulate multiple instances and test syncing:

### 🔁 Step 1: Duplicate the Project Folder

```bash
cp -r flutter-local-sync-example instance_b
cd instance_b
```

---

### 🆔 Step 2: Change the Package Name

Use the [`change_app_package_name`](https://pub.dev/packages/change_app_package_name) package:

```bash
flutter pub run change_app_package_name:main com.example.instance_b
```

This automatically updates the package name across Android, iOS, and more.

---

### 🗃️ Step 3: Change App Name (Required)

from : lib/app/core/constants/app_strings.dart
```dart
class AppStrings {
  AppStrings._();
  static const String appName = 'Instance A'; // to  change Instance B 
}
```

---

### ▶️ Step 4: Run Each Instance Separately

Open separate terminals for each instance:

```bash
flutter run
```

Repeat for the second instance (in `instance_b` folder).

✅ Now, when you update data in one app, you’ll see the synced change in the other.
---

## 🧠 State Management

- Powered by `flutter_bloc` → **Cubit** for simple and effective reactive state management.
- Keeps UI in sync with local database updates.
---

## 📡 Local Sync Engine

- Uses local TCP socket and shared JSON files to sync multiple app instances **on the same device**.
- Works fully **offline** for single-device multi-instance sync.
- **TCP socket sync does NOT support syncing across multiple physical devices or over LAN/WAN.**
- For **real-time multi-device sync**, internet access and a backend server or cloud database are necessary.

---

## 🧪 Platform Compatibility

| Platform | Supported | Notes                                                            |
|----------|-----------|------------------------------------------------------------------|
| Android  | ✅         | Supports multiple APKs on the same device                        |
| Linux    | ✅         | Supports multiple instances on same machine                      |
| macOS    | ✅         | Supports multiple instances on same machine                      |
| Windows  | ✅         | Supports multiple instances on same machine                      |
| iOS      | 🚫        | Local shared data sync NOT supported due to sandbox restrictions |

---

## 📡 Local Sync Engine

- Sync is handled **locally** via:
    - JSON-based shared file writing/reading.
    - Local socket server (TCP) for real-time notifications.
- Works **completely offline** on supported platforms.
- **Internet is NOT required for local sync on a single instances** but **IS required to simulate real live syncing across multiple instances **.


---

## 👨‍💻 Author

Tamim Hasan  
🔗 [GitHub](https://github.com/tamimsoft)

---