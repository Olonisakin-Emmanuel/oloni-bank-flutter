# 🏦 Oloni Bank

### A Full-Stack Digital Banking Application Built with Flutter, FastAPI & PostgreSQL

Oloni Bank is a full-stack digital banking application developed as a practical engineering project to demonstrate how a modern banking application can be designed, developed, connected to a backend API and deployed to production.

The project combines a Flutter mobile application with a Python FastAPI backend and PostgreSQL database, providing a complete end-to-end application architecture.

## 📌 Project Overview

Oloni Bank is a fictional banking application created to demonstrate the development of a complete digital banking system from the mobile frontend to the backend and database layer.

The application allows users to create accounts, log in securely, view account information, deposit funds, withdraw funds, transfer funds between Oloni Bank accounts and view transaction history.

The project was built with a strong focus on understanding how different components of a modern financial application work together — from the Flutter mobile interface, through RESTful API communication, to database operations and authentication.

The backend is deployed on Render, while PostgreSQL serves as the application's production database.

## ⚠️ Disclaimer

**Fictional Banking Application**

Oloni Bank is a fictional banking application created strictly for educational, demonstration, and portfolio purposes. It is not a real financial institution and is not affiliated with any bank or financial institution.

The application is designed to demonstrate software engineering concepts including mobile application development, backend API development, database integration, authentication and deployment.

## ✨ Key Features

- 🔐 **User Authentication**
  - Secure account registration and login
  - JWT-based authentication
  - Password hashing using Argon2

- 💰 **Account Management**
  - Create and manage customer accounts
  - View account details and available balance

- 💵 **Deposits**
  - Deposit funds into an Oloni Bank account
  - Real-time balance updates through the backend API

- 💸 **Withdrawals**
  - Withdraw funds from an account
  - Backend validation of available balance

- 🔄 **Account-to-Account Transfers**
  - Transfer funds between Oloni Bank accounts
  - Transaction records generated through the backend

- 📜 **Transaction History**
  - View previous banking transactions
  - Display transaction details within the mobile application

- 🌐 **Production API**
  - FastAPI backend deployed to Render
  - PostgreSQL production database

- 📱 **Modern Mobile Experience**
  - Built with Flutter and Dart
  - Premium dark-themed interface
  - Responsive and user-friendly banking experience
 
## 🛠️ Technology Stack

### Frontend
- **Flutter**
- **Dart**

### Backend
- **Python**
- **FastAPI**
- **SQLAlchemy**
- **JWT Authentication**
- **Argon2 Password Hashing**

### Database
- **PostgreSQL**

### Deployment
- **Render**

### Development Tools
- **Git**
- **GitHub**
- **Visual Studio Code**

## 🏗️ System Architecture

Oloni Bank uses a full-stack architecture built with Flutter, FastAPI and PostgreSQL.

The Flutter mobile application communicates with the FastAPI backend through REST APIs. The backend handles authentication and banking operations, while SQLAlchemy is used to communicate with the PostgreSQL database.

```text
Flutter App
     ↓
FastAPI Backend
     ↓
SQLAlchemy
     ↓
PostgreSQL

## 🔄 How the Application Works

The main flow of Oloni Bank is:

1. A user creates an account through the Flutter mobile application.
2. The Flutter app sends the account information to the FastAPI backend.
3. The backend validates the information and stores the customer and account data in PostgreSQL.
4. The user logs in and receives an authenticated session.
5. The user can perform banking operations such as deposits, withdrawals and transfers.
6. Each transaction is processed by the backend and recorded in the database.
7. The Flutter application retrieves the updated information from the API and displays it to the user.

This project helped me understand how frontend applications communicate with backend services and how backend operations are connected to persistent database storage.

## 📱 Application Screenshots
