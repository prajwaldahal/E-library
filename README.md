# E-Library

An e-library application built using Flutter, designed to provide an intuitive platform for renting books online. This app allows users to browse, rent, and manage books while integrating secure payment options.

## Features

- **User Authentication**: Secure login and registration using Firebase Authentication.
- **Book Rentals**: Easy and quick rental process with detailed book information.
- **Payment Gateway Integration**: Integrated with Khalti for seamless online payments.
- **Rental History**: View and manage previously rented books.
- **PDF Management**: Download and view book files securely.
- **Server Connectivity Check**: Ensures the app only functions when the backend server is reachable.

## Technologies Used

- **Frontend**: Flutter (Dart)
- **State Management**: Provider
- **Backend**: API integration for data retrieval and management
- **Payment Integration**: Khalti Payment Gateway
- **Authentication**: Firebase Authentication

## Admin Panel

The admin panel for managing the e-library is available at [elibrary-admin](https://github.com/prajwaldahal/elibrary-admin). It is built using the following technologies:

- **Frontend**: HTML, CSS, jQuery
- **Backend**: PHP

The admin panel allows administrators to manage users, books, rentals, and view income reports in the e-library.

## Getting Started

### Prerequisites

- Install Flutter SDK.
- Install a code editor like Android Studio or VS Code.

### Setup Instructions

1. Clone the repository:

    ```bash
    git clone https://github.com/prajwaldahal/E-library.git
    cd E-library
    ```

2. Install dependencies:

    ```bash
    flutter pub get
    ```

3. Create a file `lib/common/constants/payment_gateway_constant.dart` with your Khalti public key and secret key:

    ```dart
    class PaymentGatewayConstants {
      static const String khaltiPublicKey = "your_khalti_public_key";
      static const String khaltiSecretKey = "your_khalti_secret_key";
    }
    ```

4. Run the app:

    ```bash
    flutter run
    ```
