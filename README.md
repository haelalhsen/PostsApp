# JSONPlaceholder Flutter App

This application allows users to view and manage posts, comments, and user profiles from the [JSONPlaceholder API](https://jsonplaceholder.typicode.com/). It supports offline mode with local storage, and the architecture follows Clean Architecture principles, using BLoC for state management and Dependency Injection with GetIt.

## Features
- View a list of posts from the API.
- View post details, including associated comments.
- View user profiles linked to posts.
- Offline mode: Data is cached locally to allow viewing posts and comments when offline.

## Design Patterns and Architecture
- **Clean Architecture**: The project is structured to separate concerns, making it scalable and maintainable.
- **State Management with BLoC**: The BLoC (Business Logic Component) pattern is used to manage the state across the app, ensuring that all loading, error, and success states are handled properly.
- **Dependency Injection**: GetIt is used for Dependency Injection to decouple the creation of objects.
- **Offline Support**: Posts and comments are cached locally for offline usage.
- **API Integration**: The app integrates with the JSONPlaceholder API to fetch posts, comments, and user profiles.

## Setup Instructions

### Prerequisites
- Flutter SDK: [Install Flutter](https://flutter.dev/docs/get-started/install)
- Dart: Ensure you have the correct version installed with Flutter.
- A device or emulator to run the application.

### Steps to Run the Project
1. Clone the repository:
   ```bash
   git clone https://github.com/haelalhsen/PostsApp.git
   cd PostsApp
   ```

2. Install the dependencies:
   ```bash
   flutter pub get
   ```

3. Run the application on your device or emulator:
   ```bash
   flutter run
   ```

4. If you want to run tests:
   ```bash
   flutter test
   ```

### Running Unit Tests

This project uses **Mockito** for mocking dependencies in tests and **build_runner** for generating code (e.g., mock classes). To run the unit tests:

1. First, ensure that all dependencies are fetched and mock classes are generated:
   ```bash
   flutter pub run build_runner build
   ```

2. Now you can run the tests:
   ```bash
   flutter test
   ```

### Assumptions
- The app doesn't require user authentication, as the JSONPlaceholder API is open for public usage.
- There is no rate-limiting applied on the API; hence, requests are assumed to succeed unless network or server errors occur.
- Offline mode stores only posts and comments; user profiles are not cached.
- The app assumes the data from JSONPlaceholder is already sanitized and doesn't perform heavy validation on the received data.
