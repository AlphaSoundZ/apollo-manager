# Apollo Manager

The dashboard for the Apollo's Api and Booking system

![image](https://github.com/AlphaSoundZ/apollo-manager/assets/85343235/d0ccd048-ece4-4f89-a8e3-11b84b144dcb)

First run ```flutter pub get ``` to install the dependencies.
Run the program by calling ```flutter run``` and then select windows or web as the platform or run ```flutter run -d web-server --web-hostname 0.0.0.0 --web-port 3000``` in Github Codespace

## Setup

## Run

  - Run the Web-Server (for development)
    ```sh
    flutter run -d web-server
    ```
  - Build the app for different platforms using the following and then choose the platform
    ```sh
    flutter build
    ```

## Problems and Solutions

### Web: ```Failed to load resource: unpkg.com/canvaskit-_/bi/canvaskit.js```

If you are connected to internet and the resource isn't blocked by your firewall, It will work and no error will occur. This error occurs in flutter web in Offline mode because CanvasKit is not automatically bundled for offline development.

To make it work offline there are two ways:

### The easy way
```sh
flutter run -d chrome --web-renderer html
```
### The second way (instructions are mentioned by flutter team)

Download (or build) CanvasKit anywhere under the web/ directory of your project.
Follow these instructions and specify FLUTTER_WEB_CANVASKIT_URL to point to /path/to/bundled/canvaskit/ (if it's in the root of web/ then I think it's just /).
Include all the necessary fonts in your pubspec.yaml (instructions)
Notes for working offline in release mode:

In release mode, in order to make app work offline, after releasing app with command flutter build web, go to index.html file in build/web then add this code to the script tag:
```html
<script>
    window.flutterConfiguration = {
        canvasKitBaseUrl: "/canvaskit/"
    };

    // ...
```

## Project Structure

```
├───lib
│   ├───enums
│   ├───models
│   ├───pages
│   ├───services
│   ├───views
│   ├───widgets
│   ├───animations.dart
│   ├───destinations.dart
│   ├───main.dart
├───.env                  (needs to be created, see .env.example for reference)
```

The project has a Layer-First structure.

## Getting Started

### Prerequisites

- Flutter (including Dart)

### Installation and Running

- Install packages (in the root directory)
  ```sh
  flutter pub get
  ```
## Platforms

Currently Windows, Web and Android are the only supported platforms. The App is partly optimized for a smartphone. Other platforms have not been tested yet.

## Code Structure
