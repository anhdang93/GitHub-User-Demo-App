# GitHub User Demo App

A modern iOS application built with **SwiftUI**, **Combine**, and **SwiftData** that demonstrates best practices in iOS development using Clean Architecture principles.

## 🚀 Features

- **GitHub User Discovery**: Browse GitHub users with infinite scrolling pagination
- **User Details**: View detailed information about each GitHub user
- **Offline Support**: Intelligent caching with SwiftData for offline access
- **Modern UI**: Beautiful, responsive interface built with SwiftUI
- **Real-time Updates**: Reactive UI updates using Combine framework

## 🏗️ Architecture

This project follows **Clean Architecture** principles with a clear separation of concerns:

```
┌─────────────────────────────────────────────────────────────┐
│                    Presentation Layer                       │
│  ┌─────────────┐  ┌─────────────┐  ┌─────────────────────┐ │
│  │   Views     │  │ ViewModels  │  │    Components       │ │
│  │ (SwiftUI)   │  │ (Observable)│  │   (Reusable)        │ │
│  └─────────────┘  └─────────────┘  └─────────────────────┘ │
└─────────────────────────────────────────────────────────────┘
┌─────────────────────────────────────────────────────────────┐
│                     Domain Layer                            │
│  ┌─────────────┐  ┌─────────────┐  ┌─────────────────────┐ │
│  │  Entities   │  │  Use Cases  │  │   Repositories      │ │
│  │ (Business)  │  │ (Logic)     │  │   (Interfaces)      │ │
│  └─────────────┘  └─────────────┘  └─────────────────────┘ │
└─────────────────────────────────────────────────────────────┘
┌─────────────────────────────────────────────────────────────┐
│                      Data Layer                             │
│  ┌─────────────┐  ┌─────────────┐  ┌─────────────────────┐ │
│  │   Remote    │  │    Local    │  │   Repositories      │ │
│  │ DataSource  │  │ DataSource  │  │  (Implementation)   │ │
│  └─────────────┘  └─────────────┘  └─────────────────────┘ │
└─────────────────────────────────────────────────────────────┘
```

### Key Architectural Patterns

- **Clean Architecture**: Separation of concerns, testability, maintainability
- **Repository Pattern**: Abstraction layer for data access
- **MVVM**: Model-View-ViewModel pattern with SwiftUI
- **Dependency Injection**: Service Locator pattern for loose coupling
- **Protocol-Oriented Programming**: Extensive use of protocols for flexibility

## 🛠️ Technologies & Frameworks

- **iOS 17.0+**
- **Swift 5.9+**
- **SwiftUI**: Modern declarative UI framework
- **Combine**: Reactive programming framework
- **SwiftData**: Modern persistence framework (replaces Core Data)
- **Xcode 15.0+**

## 📱 Screenshots

*[Screenshots will be added here]*

## 🚀 Getting Started

### Prerequisites

- Xcode 15.0 or later
- iOS 17.0+ deployment target
- macOS 14.0+ (for development)

### Installation

1. Clone the repository:
```bash
git clone https://github.com/yourusername/UserGithubDemoApp.git
cd UserGithubDemoApp
```

2. Open the project in Xcode:
```bash
open UserGithubDemoApp.xcodeproj
```

3. Build and run the project on your device or simulator

### Configuration

The app uses GitHub's public API. No API keys are required for basic functionality.

## 🏛️ Project Structure

```
UserGithubDemoApp/
├── App/
│   ├── MainApp.swift              # App entry point & DI setup
│   └── Resources/                 # Assets & resources
├── Common/
│   ├── Config/
│   │   └── Configuration.swift    # App configuration constants
│   └── DI/
│       └── ServiceLocator.swift   # Dependency injection container
├── Domain/
│   ├── Entities/                  # Business models
│   ├── Mappers/                   # Data transformation
│   ├── Repositories/              # Repository interfaces
│   └── UseCases/                  # Business logic
├── Data/
│   ├── DataSources/               # Data access layer
│   ├── Models/                    # DTOs & data models
│   ├── NetworkService/            # HTTP networking
│   └── Repositories/              # Repository implementations
└── Presentation/
    ├── Components/                # Reusable UI components
    ├── ViewModels/                # MVVM view models
    └── Views/                     # SwiftUI views
```

## 🔧 Core Components

### 1. Service Locator (Dependency Injection)

```swift
final class ServiceLocator {
    static let shared = ServiceLocator()
    
    func register<T>(_ service: T)
    func resolve<T>() -> T
}
```

### 2. Repository Pattern

```swift
protocol UserRepository {
    func fetchUsers(page: Int, itemPerPage: Int) -> AnyPublisher<[User], Error>
    func fetchUserDetail(_ name: String) -> AnyPublisher<UserDetail, Error>
    func removeAllCachedUser() -> AnyPublisher<Void, Error>
}
```

### 3. Network Service

```swift
protocol NetworkService {
    func fetch<T: Decodable>(_ endPoint: EndPoint) -> AnyPublisher<T, Error>
}
```

### 4. Data Models

- **User**: Basic user information (name, avatar, GitHub URL)
- **UserDetail**: Extended user information (blog, location, followers, following)
- **DTOs**: Data Transfer Objects for API responses

## 📊 Data Flow

1. **User Interaction** → ViewModel
2. **ViewModel** → Use Case
3. **Use Case** → Repository
4. **Repository** → Data Sources (Local/Remote)
5. **Data Sources** → Return data via Combine publishers
6. **UI Updates** → Reactive updates through @Published properties

## 🧪 Testing

The project includes comprehensive test coverage:

- **Unit Tests**: Core business logic and data layer
- **Mock Objects**: Pre-configured mocks for testing
- **Test Targets**: Separate test bundles for different layers

### Running Tests

1. In Xcode: `Cmd + U`
2. Or via command line:
```bash
xcodebuild test -scheme UserGithubDemoApp -destination 'platform=iOS Simulator,name=iPhone 15'
```


## 📡 API Integration

- **Base URL**: `https://api.github.com`
- **Endpoints**:
  - `GET /users` - List GitHub users with pagination
  - `GET /users/{username}` - Get user details
- **Rate Limiting**: Respects GitHub API rate limits
- **Error Handling**: Graceful error handling with user feedback




## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 👨‍💻 Author

**Đặng Ngọc Tuấn Anh**
- Created: August 16, 2025

## 🙏 Acknowledgments

- **GitHub API**: For providing the public API
- **Apple**: For SwiftUI, Combine, and SwiftData frameworks
- **iOS Community**: For best practices and architectural patterns

## 📞 Support

If you have any questions or need help:

1. Check the [Issues](../../issues) page
2. Create a new issue with detailed description
3. Contact the maintainer

---

**Note**: This project is designed for educational purposes and demonstrates modern iOS development best practices. It's perfect for learning Clean Architecture, SwiftUI, Combine, and SwiftData.
