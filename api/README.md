
# BarberGo API

This document provides detailed information about the BarberGo API endpoints.

## Base URL

`http://localhost:8080/api`

## Authentication

All protected endpoints require a JWT token to be included in the `Authorization` header as a Bearer token.

`Authorization: Bearer <your_jwt_token>`

### Authentication Endpoints

*   **POST /login:** Authenticates a user and returns a JWT token.
*   **POST /signup:** Creates a new user and returns a JWT token.
*   **POST /forgot-password:** Sends a password reset email to the user.

## Appointments

*   **GET /appointments:** Get a list of all appointments for the authenticated user.
*   **POST /appointments:** Create a new appointment.
*   **PUT /appointments/:id:** Update an existing appointment.
*   **DELETE /appointments/:id:** Delete an appointment.

## Services

*   **GET /services:** Get a list of all services.
*   **POST /services:** Create a new service.
*   **GET /services/:id:** Get a specific service by ID.
*   **PUT /services/:id:** Update an existing service.
*   **DELETE /services/:id:** Delete a service.

## Customers

*   **GET /customers:** Get a list of all customers.
*   **POST /customers:** Create a new customer.
*   **GET /customers/:id:** Get a specific customer by ID.
*   **PUT /customers/:id:** Update an existing customer.
*   **DELETE /customers/:id:** Delete a customer.
