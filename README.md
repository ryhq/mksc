
# MKSC Flutter Project

This Flutter project named **MKSC** is a mobile, web, and desktop application created using the Flutter framework. It leverages several packages and libraries to provide a robust feature set including icons, persistent storage, secure storage, charting, and more.

## Table of Contents
- [Getting Started](#getting-started)
- [Requirements](#requirements)
- [Installation](#installation)
- [Dependencies](#dependencies)
- [Development](#development)
- [Building](#building)
- [Features](#features)
- [Assets](#assets)
- [Icons](#icons)
- [Versioning](#versioning)
- [License](#license)

## Getting Started

To get started with the MKSC project, you need to ensure that Flutter SDK is installed and your development environment is set up. This project supports Android, iOS, Web, and desktop platforms like Windows and macOS.

### Requirements

- Flutter SDK version **3.5.0** or higher
- Dart SDK that comes bundled with Flutter
- For Android:
  - Android SDK API level 21 or higher
- For iOS:
  - iOS 9.0 or higher

For detailed platform-specific requirements, refer to the official [Flutter installation guide](https://docs.flutter.dev/get-started/install).

### Installation

1. Clone the repository:
   ```git clone https://github.com/ryhq/mksc.git
cd mksc```

2. Install Flutter dependencies:
   \```bash
   flutter pub get
   \```

3. For Android, iOS, and Web launcher icons, generate them by running:
   \```bash
   flutter pub run flutter_launcher_icons:main
   \```

4. For splash screens, generate the native splash screen with:
   \```bash
   flutter pub run flutter_native_splash:create
   \```

### Running the App

To run the app, use Flutterâs `run` command:
\```bash
flutter run
\```

## Dependencies

This project uses various third-party dependencies, each adding specific functionality to the app. Below is a breakdown of the key packages used in this project:

- **flutter_launcher_icons**: For custom launcher icons.
- **flutter_native_splash**: For creating platform-specific splash screens.
- **provider**: A state management package for handling app-wide state.
- **sqflite**: SQLite database for local storage.
- **path**: Utility for manipulating paths.
- **flutter_svg**: Support for rendering SVG images.
- **bcrypt**: A package for hashing and checking passwords securely.
- **intl**: Provides internationalization support.
- **flutter_slidable**: Implements a sliding action menu.
- **device_info_plus**: Fetches device-specific information.
- **shared_preferences**: Persistent storage across app launches.
- **path_provider**: Finds commonly used locations on the deviceâs file system.
- **animated_text_kit**: Provides animated text widgets.
- **http**: A client for making HTTP requests.
- **connectivity_plus**: Network connectivity information.
- **flutter_secure_storage**: Secure data storage on the device.
- **pdf**: Generates and renders PDF documents.
- **pie_chart**: Simple pie chart widget.
- **fl_chart**: A more advanced charting library.
- **permission_handler**: Handles runtime permissions.

For dev dependencies, we are using:

- **flutter_test**: A framework for writing unit and widget tests.
- **flutter_lints**: Recommended lint rules for better coding practices.

To update the dependencies to the latest versions, run:
\```bash
flutter pub upgrade --major-versions
\```

## Development

This project uses **provider** for state management, **sqflite** for database storage, and **flutter_secure_storage** for secure data handling. Development practices include unit and widget testing, following Flutter's best practices.

### Code Linting

Ensure that your code follows the recommended linting practices by running:
\```bash
flutter analyze
\```

To run unit tests:
\```bash
flutter test
\```

## Building

You can build the app for various platforms by using Flutterâs build commands:

- For Android:
  \```bash
  flutter build apk
  \```

- For iOS:
  \```bash
  flutter build ios
  \```

- For Web:
  \```bash
  flutter build web
  \```

- For Windows:
  \```bash
  flutter build windows
  \```

## Features

- **State Management**: Managed by `provider`.
- **Persistent Data Storage**: Local data is stored securely using `sqflite` and `shared_preferences`.
- **Charts & Graphs**: Visualizations are provided by `fl_chart` and `pie_chart`.
- **Authentication**: Passwords are hashed using `bcrypt`.
- **Network Requests**: Use the `http` package to make API requests.
- **Secure Data Storage**: Sensitive information is stored using `flutter_secure_storage`.
- **Device Information**: The app gathers device data using `device_info_plus`.
- **PDF Generation**: PDF documents can be generated using the `pdf` package.

## Assets

This project includes the following assets:

- **Logo**: `assets/logo/MKSC_Logo.jpg`
- **Fonts**: Custom fonts located in `assets/fonts/roboto/`.

You can add more assets by modifying the `pubspec.yaml` under the `assets` section.

## Icons

This project uses various icon packs:

- **Cupertino Icons**: iOS-style icons.
- **Ternav Icons**: Custom icon pack used in this project.
- **Font Awesome**: Popular icons from Font Awesome.
- **Material Design Icons**: Google's Material Design icon pack.
- **Line Awesome Icons**: A modern icon set.

## Versioning

This project follows the **Semantic Versioning** model:
- **Version**: `1.0.0+1`
  - `1.0.0` represents the version.
  - `+1` represents the build number.

To update the version, modify the `pubspec.yaml` file:
\```yaml
version: 1.0.0+1
\```

## License

This project is not published to pub.dev and includes the following line in `pubspec.yaml` to prevent accidental publication:
\```yaml
publish_to: 'none'
\```

If you want to publish this package, simply remove that line.