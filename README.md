# MyGallery-iOS
iOS Gallery App with Google Login, MVVM, Offline Support

## Features
- **Secure Authentication**: Google Login integration.
- **Fast Gallery**: 300+ curated nature wallpapers loaded from a local JSON dataset.
- **Offline Support**: Robust image caching for viewing wallpapers without an internet connection.
- **Premium UI**: Modern design with custom fonts (Manrope), gradients, and smooth pagination animations.

## Third-Party Dependencies

The following libraries are used in this project:

1.  **GoogleSignIn SDK**:
    - **Purpose**: Handles secure OAuth2 authentication with Google accounts.
    - **Integration**: Typically added via Swift Package Manager (SPM).
    - **Usage**: Used in `LoginViewModel` to manage the sign-in flow and user session data.

## Requirements
- **iOS**: 15.0+
- **Xcode**: 13.0+
- **Language**: Swift 5.0+

## Setup
1.  Open `MyGalleryApp.xcodeproj` in Xcode.
2.  Ensure you have a valid `GoogleService-Info.plist` added to the project for Google Sign-In to function.
3.  Build and Run.
