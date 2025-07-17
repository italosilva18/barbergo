
# BarberGo - Barber Shop Management App

BarberGo is a comprehensive mobile application for managing barber shops, salons, and similar businesses. It features a Flutter-based mobile app for both customers and business owners, and a Go-powered backend API for managing data.

## Features

*   **Authentication:** Secure user login, signup, and password recovery.
*   **Appointment Management:** Schedule, view, edit, and cancel appointments.
*   **Service Management:** Create, update, and delete services offered by the business.
*   **Customer Management:** Keep track of customer information and history.

## Project Structure

*   `/app`: Contains the Flutter mobile application.
*   `/api`: Contains the Go backend API.

## Getting Started

### Prerequisites

*   [Flutter](https://flutter.dev/docs/get-started/install)
*   [Go](https://golang.org/doc/install)

### Backend (API)

1.  **Navigate to the API directory:**
    ```bash
    cd api
    ```

2.  **Install dependencies:**
    ```bash
    go mod tidy
    ```

3.  **Run the API server:**
    ```bash
    go run main.go
    ```
    The API will be running at `http://localhost:8080`.

### Frontend (Flutter App)

1.  **Navigate to the app directory:**
    ```bash
    cd app
    ```

2.  **Install dependencies:**
    ```bash
    flutter pub get
    ```

3.  **Run the app:**
    ```bash
    flutter run
    ```

## API Endpoints

See the [API README](./api/README.md) for detailed information about the available endpoints.

## Contributing

Contributions are welcome! Please feel free to submit a pull request or open an issue.
