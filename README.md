# University Quality Assurance & Lecture Follow-Up (LMW)

A modern and robust Flutter mobile application designed to ensure educational quality, streamline lecture follow-up, gather student feedback, and automate attendance tracking within university ecosystems.

---

## 📱 About the Application

The **University Quality Assurance & Lecture Follow-Up** application serves as a bridge between students, lecturers, and the administration to maintain and improve academic standards. By offering transparent communication channels and automated feedback workflows, it facilitates continuous educational improvement.

### Key Features

*   **🔒 Secure User Authentication**:
    *   Secure student login utilizing email and password credentials.
    *   "Remember Me" session persistence via `shared_preferences` for quick access.
    *   Self-service "Forgot Password" capability.
*   **📊 Dynamic Student Dashboard**:
    *   Personalized welcome message displaying student details.
    *   Real-time notifications fetched from the server.
    *   Smooth pull-to-refresh to fetch updated alerts.
*   **📷 QR-Based Attendance Tracking**:
    *   Instantly mark attendance in class by scanning the lecturer's QR code.
    *   Integrated device camera scanning powered by `qr_code_scanner`.
*   **📝 Lecture Evaluation & QA Surveys**:
    *   Submit detailed lecture-specific feedback with star ratings (`flutter_rating_bar`) and comments.
    *   Fill out academic quality assurance surveys to provide feedback on specific topics and learning materials.
*   **🎨 Personalized User Experience**:
    *   Theme customizer using a color picker powered by `ValueNotifier` / `ColorNotifier` to change the scaffold background color dynamically.
    *   Toggle layout preference between GridView and ListView for course and lecture screens.
*   **🌐 Localization & Internationalization**:
    *   Built-in support for multiple languages including **English (en)**, **Arabic (ar)**, **Persian (fa)**, and **French (fr)**.
*   **✨ Premium Visual Design**:
    *   Engaging user interface featuring smooth transitions and Lottie-based vector animations (`assets/animation/`).
    *   Responsive design scaling across all Android and iOS device sizes using `flutter_screenutil` (base design: 360x690).

---

## 🛠️ Technology Stack & Dependencies

The app is built on top of the following framework and library versions:

*   **SDK Platform**: Flutter (`>=3.2.2 <4.0.0`) & Dart.
*   **HTTP Clients**: `http` for RESTful API communications.
*   **Animation**: `lottie` for interactive UX animations.
*   **State Management & Notifiers**: `provider` and custom notifier listeners.
*   **Storage**: `shared_preferences` for local session caching (`studentId`).
*   **Notifications**: `flutter_local_notifications` for local trigger alerts.
*   **UI Components**: `flutter_rating_bar` for lecture feedback ratings, `flutter_screenutil` for screen adaptations, and `cupertino_icons` for system iconography.
*   **QR Scanner**: `qr_code_scanner` for hardware camera scanning support.
*   **Localization**: `intl` and `flutter_localizations`.

---

## 📂 Project Structure

```
university-quality-assurance/
├── android/                  # Android native project configuration
├── ios/                      # iOS native project configuration
├── assets/                   # Lottie animations and application images
│   ├── animation/            # login.json, forgetPassword.json
│   └── images/               # Logo.png, launcher icons, secure.jpg
├── lib/                      # Flutter Application Source Code
│   ├── API/                  # API constants and endpoint definitions (api_class.dart)
│   ├── l10n/                 # Translation maps and supported locale setups
│   ├── Screens/              # App screens grouped by feature folders:
│   │   ├── About Us Screen/
│   │   ├── Attendance Screen/
│   │   ├── Change Password Screen/
│   │   ├── Course Screen/
│   │   ├── Dashboard Screen/
│   │   ├── Help & Support Screen/
│   │   ├── Lectures Screens/
│   │   ├── Login Screen/
│   │   ├── Main Screen/
│   │   ├── Notification Screen/
│   │   ├── Privacy Policy Screen/
│   │   ├── Profile Screen/
│   │   ├── Scince Question Screen/ # Quality Assurance Survey Questions
│   │   ├── Settings Screen/
│   │   ├── Splash Screen/
│   │   ├── Submit Lectures-Feedback Screen/
│   │   └── Terms of Service Screen/
│   ├── Them/                 # Dynamic theme & color controllers
│   └── main.dart             # Application initialization & entry point
├── l10n.yml                  # Flutter localization settings
├── pubspec.yaml              # App metadata and dependencies list
└── analysis_options.yaml     # Linting and static analysis configuration
```

---

## 🚀 How to Clone and Start the Application

### 📋 Prerequisites

Before running the application, make sure your development machine has the following tools installed:

1.  **Flutter SDK**: [Install Flutter SDK](https://docs.flutter.dev/get-started/install) (Ensure your version satisfies the SDK constraints `sdk: '>=3.2.2 <4.0.0'`).
2.  **Git**: [Install Git](https://git-scm.com/downloads) if not already installed.
3.  **IDE**: VS Code (with Flutter extensions) or Android Studio.
4.  **Emulators/Devices**: An Android Emulator, iOS Simulator, or physical device connected in developer mode.

---

### 💻 Step-by-Step Setup Guide

#### 1. Clone the Repository
Open a terminal in your project directory and clone the repository:
```bash
git clone https://github.com/MohammedFu/University-Quality-Assurance.git
```
Navigate to the root directory of the cloned project:
```bash
cd university-quality-assurance
```

#### 2. Get Dependencies
Fetch all the required Dart packages:
```bash
flutter pub get
```

#### 3. Generate Localization Files
The application uses auto-generated localizations configured in `l10n.yml`. Run the localization generator:
```bash
flutter gen-l10n
```

#### 4. Configure the Backend URL
The application is pre-configured to communicate with a PHP backend. By default, the API points to the localhost loopback for the Android emulator:
*   File location: [lib/API/api_class.dart](file:///your-backend-path/university-quality-assurance/lib/API/api_class.dart)

```dart
class ApiClass {
  static const String localhostIP = 'http://10.0.2.2'; // Standard Android Emulator Loopback
  
  // Update this to your host IP (e.g. 'http://192.168.1.100') if testing on physical devices.
}
```

Ensure your PHP local development server (such as XAMPP, WampServer, or local PHP build) is running and accessible at the specified address under the `/newBackEnd/` path.

#### 5. Run the Application
Start the project on your connected device:
```bash
flutter run
```

*Note: If multiple devices are connected, list them using `flutter devices` and specify the device target using `flutter run -d <device-id>`.*

---

## 🛠️ Building the App for Production

To compile the application for release/production, use the following commands:

*   **Android App Bundle (AAB)** (Recommended for Google Play Console):
    ```bash
    flutter build appbundle
    ```
*   **Android APK**:
    ```bash
    flutter build apk --split-per-abi
    ```
*   **iOS App** (Requires macOS & Xcode):
    ```bash
    flutter build ipa
    ```
