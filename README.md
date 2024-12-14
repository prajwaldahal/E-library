# E-Library

An e-library application built using Flutter, designed to provide an intuitive platform for renting books online. This app allows users to browse, rent, and manage books while integrating secure payment options.

## Features

- **User Authentication**: Secure login and registration using Firebase Authentication.
- **Book Rentals**: Easy and quick rental process with detailed book information.
- **Payment Gateway Integration**: Integrated with Khalti for seamless online payments.
- **Rental History**: View and manage previously rented books.
- **PDF Management**: Download and view book files securely.

## Technologies Used

- **Frontend**: Flutter (Dart)
- **State Management**: Provider
- **Backend**: PHP
- **Payment Integration**: Khalti Payment Gateway
- **Authentication**: Firebase Authentication

## Admin Panel and API

The admin panel for managing the e-library is available at [elibrary-admin](https://github.com/prajwaldahal/elibrary-admin). It is built using the following technologies:

- **Frontend**: HTML, CSS, jQuery
- **Backend**: PHP

The admin panel allows administrators to manage users, books, rentals, and view income reports in the e-library.

## Getting Started

### Prerequisites

- Install Flutter SDK.
- Install a code editor like Android Studio or VS Code.

### Setup Firebase Authentication

Make sure to set up Firebase Authentication for your app using **FlutterFire**.


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

3. **Change IP Address for Local Development**:  
   When running the e-library app on your local machine, you need to change the IP address in the `baseServer` to point to your laptop's local IP.

    - Locate the `api_constant.dart` file at this path:  
      `lib/common/constants/api_constant.dart`

    - Replace the default IP address (`192.168.254.3`) with your laptop's local IP address.

   To find your local IP address:

    - **Windows**: Run `ipconfig` in Command Prompt and look for the IPv4 address.
    - **Mac/Linux**: Run `ifconfig` in the terminal and look for the `inet` address under your active network interface.

   After updating the IP, the app will connect to your local development server.

4. Create a file `lib/common/constants/payment_gateway_constant.dart` with your Khalti public key and secret key:

    ```dart
    class PaymentGatewayConstants {
      static const String khaltiPublicKey = "your_khalti_public_key";
      static const String khaltiSecretKey = "your_khalti_secret_key";
    }
    ```

5. Run the app:

    ```bash
    flutter run
    ```


