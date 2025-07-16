# BarberGo - Barber Shop Management App

This document describes the BarberGo project, a mobile application for scheduling and managing barber shops, salons, and similar businesses.

## Project Overview

The project consists of a Flutter mobile application and a Go backend API.

### Flutter App (`app` directory)

The Flutter application provides the user interface for both customers and business owners.

**Features implemented:**

*   Basic authentication UI (Login, Signup, Forgot Password screens)
*   Integration with `AuthService` for API calls, including JWT token storage.

**Features to be implemented:**

*   Implement appointment scheduling UI and integrate with `AppointmentService`.
*   Implement service management UI and integrate with `ServiceService`.
*   Customer management
*   Reporting and analytics

### Go API (`api` directory)

The Go backend provides the API for the Flutter application to interact with the database.

**Features implemented:**

*   Authentication endpoints (`/api/login`, `/api/signup`, `/api/forgot-password`)
*   User, Appointment, and Service models with SQLite database integration using GORM.
*   Password hashing using bcrypt.
*   JWT token generation and validation middleware.
*   Appointment management endpoints (`/api/appointments`)
*   Service management endpoints (`/api/services`)

**Features to be implemented:**

*   Customer management endpoints

## Development Status

Authentication, appointment, and service management logic are now implemented in the Go API. The Flutter app has basic authentication UI and JWT token handling. The next major step is to build out the Flutter UI for appointment and service management and integrate it with the Go API.

**Next Steps:**

1.  Modify Flutter `AppointmentService` and `ServiceService` to include JWT token in requests.
2.  Create screens for appointment management (list, create, edit, delete) in the Flutter app.
3.  Create screens for service management (list, create, edit, delete) in the Flutter app.
4.  Integrate the services with the new screens.
5.  Implement customer management in both Flutter and Go.