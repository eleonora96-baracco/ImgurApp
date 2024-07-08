# ImgurApp

## Overview
The ImgurApp is a SwiftUI-based application that allows users to manage and interact with their photos stored on Imgur. It provides features for authenticating users, uploading images from the camera or photo library, viewing uploaded photos in a grid layout, and deleting photos.

## Features
- **Authentication:** Users can log in using their Imgur account via OAuth2.
- **Photo Management:**
  - View a grid of uploaded photos.
  - Upload new photos from the camera or photo library.
  - Delete uploaded photos.
- **UI Customization:** Includes custom UI elements such as buttons and alerts.
- **Error Handling:** Displays appropriate error messages using alerts for network and application errors.

## Architecture
The app is structured using the MVVM (Model-View-ViewModel) architecture pattern:
- **Model:** Includes data models such as `ImgurImage` and response models.
- **View:** SwiftUI views for various screens and components.
- **ViewModel:** Bridges between the views and models, handles business logic and state management.

## Components
### Views
- **ContentView:** Main view managing navigation flow and displaying either the photo gallery or login view based on authentication status.
- **PhotoGalleryView:** Displays a grid of uploaded photos with options to delete photos.
- **LoginView:** Allows users to authenticate with Imgur using OAuth2.

### View Models
- **AuthViewModel:** Manages authentication state and interactions with the Imgur authentication service.
- **PhotoGalleryViewModel:** Handles fetching, adding, and deleting photos using the Imgur image fetching service.
- **ImagePickerViewModel:** Facilitates image selection from the camera or photo library and handles image upload.

### Services and Interactors
- **ImgurAuthenticationServiceInteractor:** Implements the `AuthenticationServiceProtocol` for Imgur authentication via OAuth2.
- **ImgurImageFetchingServiceInteractor:** Implements the `ImageFetchingServiceProtocol` for fetching, uploading, and deleting photos on Imgur.

### Helpers
- **KeychainHelper:** Provides secure storage using iOS Keychain for managing access tokens.
- **NetworkSessionWrapper:** Wraps `URLSession` for network requests.
- **NetworkDataTaskWrapper:** Wraps `URLSessionDataTask` for managing data tasks.

## Testing
### Unit Testing
- Includes comprehensive unit tests to ensure the reliability and robustness of components.
- Mocks for various protocols, such as network sessions and authentication services, were manually created due to the limitations of not having access to Sourcery for automated mock generation.

### UI Testing
- Simple UI tests ensure that the login view is displayed correctly when there is no access token, validating the app's behavior under different authentication states.

## Notes
- The project leverages SwiftUI for declarative UI development and integrates with Imgur's API for photo management functionalities.
- Error handling is implemented to provide informative alerts for both expected and unexpected errors.
- The architecture and design aim to provide a scalable and maintainable codebase for future enhancements and features.


