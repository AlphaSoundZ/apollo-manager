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
## Project Structure
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
## Getting Started
### Prerequisites
- Flutter (including Dart)
### Installation and Running
- Install packages (in the root directory)
  ```sh
  flutter pub get
  ```
## Platforms
Currently Windows and Web are the only supported platform. The App is partly optimized for a smartphone.
## Code Structure
