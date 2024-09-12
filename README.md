# DigiDastavej

# Digidastavej

**Digidastavej** is a comprehensive document management and tracking solution designed to simplify the way you handle and organize your important documents. Our innovative platform offers a user-friendly interface and powerful features to ensure that your documents are always accessible, up-to-date, and securely managed.

## Key Features

- **Efficient Document Storage:** Store all your documents in one place with easy access and retrieval.
- **Smart Expiration Tracking:** Keep track of upcoming expirations with notifications to ensure you never miss a critical deadline.
- **Search and Filter:** Easily locate documents using our robust search and filter functionality.
- **Themed Interface:** Enjoy a visually appealing and customizable interface with support for light and dark modes.

## Getting Started

1. **Clone the Repository:**

   ```bash
   git clone https://github.com/yourusername/digidastavej.git


| (assets/screenshots/1.jpeg) | (assets/screenshots/1.jpeg) |
|------------------------------------------|------------------------------------------------------------|
| (assets/screenshots/1.jpeg) | (assets/screenshots/1.jpeg) |
|------------------------------------------|------------------------------------------------------------|
| (assets/screenshots/1.jpeg) | | (assets/screenshots/1.jpeg) |
|------------------------------------------|------------------------------------------------------------|
| (assets/screenshots/1.jpeg) | | 
|------------------------------------------|------------------------------------------------------------|

## Prerequisites

- Flutter SDK
- Android Studio or Xcode

## Project Structure

The project follows a clean and organized structure to enhance maintainability and scalability:

### Directory Breakdown:

- `app/`: Contains core application components and business logic.
  - `bindings/`:  Handles dependency injection and initial setup.
    - `bindings.dart`:  Configures and initializes dependencies for the app.

  - `controllers/`: Manages the application's business logic and state.
    - `add_controller.dart`: Manages the logic for adding new documents.
    - `details_controller.dart`:Handles the logic for viewing and editing document details.
    - `documents_controller.dart`: Oversees the overall management of document data and interactions.

  - `data/`: Contains data-related components, including models and repositories.
    - `models/`: Defines data models used in the app.
      - `document_model.dart`: Represents the document entity.
      - `document_model.g.dart`:  Auto-generated code for document model serialization.

    - `repositories/`: Manages data operations and integration with external sources.
      - `document_repository.dart`: Handles CRUD operations for documents.

  - `services/`: Implements external service integrations and utilities.
    - `permission_service.dart`: Manages permission requests and handling for accessing documents.

  - `utils/`:   Provides utility functions and constants.
    - `dark_theme.dart`: Defines the dark theme configuration for the app.
    - `light_theme.dart`: Defines the light theme configuration for the app.
    - `date_format.dart`: Provides date formatting utilities.

  - `views/`: Contains the UI components of the application.
    - `add/`: Views related to adding new documents.
      - `add_view.dart`: UI for adding a new document.

    - `home/`: Views related to the home screen.
      - `home_view.dart`: Displays the main dashboard and document listings.

    - `detail/`: Views related to document details.
      - `detail_view.dart`: Shows detailed information about a document and provides options for editing.

- `routes/`:   Manages the navigation and routing within the app.
  - `app_pages.dart`: Defines the application's route structure and navigation logic.

- `main.dart`:The entry point of the application, responsible for initializing and running the app.



This structure follows the MVC(Model-View-Controller) architecture, separating concerns and improving code organization.



## Additional Resources

If you're new to Flutter development, here are some resources to get you started:

- [Lab: Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://docs.flutter.dev/cookbook)

For comprehensive guidance on Flutter development, check out the [online documentation](https://docs.flutter.dev/). It provides tutorials, samples, guidance on mobile development, and a full API reference.

## Contributing

We welcome contributions to improve DigiDastavej! If you'd like to contribute, please follow these steps:

1. Fork the repository
2. Create a new branch for your feature or bug fix
3. Make your changes and commit them with clear, descriptive messages
4. Push your changes to your fork
5. Submit a pull request to the main repository

For major changes or new features, please open an issue first to discuss what you would like to change.

Please make sure to update tests as appropriate and adhere to the project's coding standards.

#### Made with ❤ by [@nittinsharma37](https://github.com/nittinsharma37)

## License

This project is licensed under the MIT License. See the [LICENSE](LICENSE) file for full details.

The MIT License is a permissive license that allows for reuse of the software with minimal restrictions. It permits use, modification, and distribution of the code for both private and commercial purposes, as long as the original copyright and license notice are included.