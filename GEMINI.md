# BarberGo - Barber Shop Management App

This document describes the BarberGo project, a mobile application for scheduling and managing barber shops, salons, and similar businesses.

## Project Overview

The project consists of a Flutter mobile application and a Go backend API.

### Flutter App (`app` directory)

The Flutter application provides the user interface for both customers and business owners.

**Features Implemented:**

*   **Authentication:** Full UI for Login, Signup, and Forgot Password screens, integrated with the Go API via `AuthService`, including secure JWT token storage.
*   **Service Management:** Complete CRUD (Create, Read, Update, Delete) functionality for managing services. Users can list, create, edit, and delete services through a dedicated UI, integrated with `ServiceService`.
*   **Appointment Scheduling:** Complete CRUD functionality for managing appointments. Users can list, create, edit, and delete appointments. The UI allows selecting services and picking dates/times, and is integrated with `AppointmentService`.
*   **Customer Management:** Complete CRUD functionality for managing customers. Users can list, create, edit, and delete customer profiles through a dedicated UI, integrated with `CustomerService`.
*   **Analytics & Reporting:** A dedicated screen (`analytics_screen.dart`) displays key business metrics by fetching data from the API, including total appointments, total customers, and total revenue.

### Go API (`api` directory)

The Go backend provides a robust API for the Flutter application to interact with the database.

**Features Implemented:**

*   **Database:** Uses SQLite with GORM for object-relational mapping.
*   **Authentication:** Secure authentication endpoints (`/api/login`, `/api/signup`, `/api/forgot-password`) using bcrypt for password hashing and JWT for session management.
*   **Middleware:** JWT middleware protects all sensitive endpoints, ensuring only authenticated users can access them.
*   **Service Management:** Full set of CRUD endpoints (`/api/services`) for managing services.
*   **Appointment Management:** Full set of CRUD endpoints (`/api/appointments`) for managing appointments.
*   **Customer Management:** Full set of CRUD endpoints (`/api/customers`) for managing customers.
*   **Analytics Endpoint:** A dedicated endpoint (`/api/analytics`) calculates and returns key metrics like total appointments, customers, and revenue.

## Development Status

The project is functionally complete. All core features planned for the initial version have been implemented in both the Flutter application and the Go API. The application now supports full management of services, appointments, and customers, as well as a basic analytics dashboard.

**Next Steps:**

1.  **Testing:**
    *   Perform comprehensive end-to-end testing by running the Flutter app and Go API together to identify and fix any bugs.
    *   Write unit and integration tests for the Go API to ensure long-term stability and prevent regressions.
2.  **Refinement:**
    *   Refine the user interface and user experience based on feedback.
    *   Consider adding more advanced features to the analytics dashboard.
3.  **Deployment:**
    *   Prepare the application for deployment, including setting up production-ready configurations for the API and building release versions of the Flutter app.
