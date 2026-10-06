
# 🏦 Oloni Bank

### A Full-Stack Digital Banking Application Built with Flutter, FastAPI & PostgreSQL

Oloni Bank is a fictional digital banking application I built as a practical software engineering project.

The project allowed me to work through the complete flow of a banking application — from building the mobile interface with Flutter, to developing the backend API with Python and FastAPI, connecting the application to PostgreSQL, implementing authentication, and deploying the backend to production.

## 📌 Project Overview

Oloni Bank is designed to demonstrate how the different parts of a modern banking application work together.

Users can create an account, log in, view their account information, deposit funds, withdraw funds, transfer money between Oloni Bank accounts, and view their transaction history.

One of the main goals of the project was not just to build the interface, but to understand what happens behind the interface — how the Flutter application communicates with the backend, how the backend processes requests, and how information is stored and retrieved from the database.

The backend is deployed on Render and uses PostgreSQL as the production database.

## ⚠️ Disclaimer

**Fictional Banking Application**

Oloni Bank is a fictional banking application created strictly for educational, demonstration, and portfolio purposes. It is not a real financial institution and is not affiliated with any bank or financial institution.

The application is designed to demonstrate software engineering concepts including mobile application development, backend API development, database integration, authentication, and deployment.

## ✨ Key Features

- 🔐 **User Authentication**
  - Account registration and login
  - JWT-based authentication
  - Password hashing with Argon2

- 💰 **Account Management**
  - Customer account creation
  - Account information and balance
  - Customer and account data stored in PostgreSQL

- 💵 **Deposits**
  - Deposit funds into an Oloni Bank account
  - Balance updates through the backend API

- 💸 **Withdrawals**
  - Withdraw funds from an account
  - Backend validation of available balance

- 🔄 **Account Transfers**
  - Transfer funds between Oloni Bank accounts
  - Transaction records created by the backend

- 📜 **Transaction History**
  - View previous transactions
  - View transaction details within the mobile application

- 🌐 **Production Backend**
  - FastAPI backend deployed on Render
  - PostgreSQL production database

- 📱 **Mobile Application**
  - Built with Flutter and Dart
  - Dark-themed modern interface
  - Designed for a simple and user-friendly banking experience

## 🛠️ Technology Stack

### Frontend

- Flutter
- Dart

### Backend

- Python
- FastAPI
- SQLAlchemy
- JWT Authentication
- Argon2 Password Hashing

### Database

- PostgreSQL

### Deployment

- Render

### Development Tools

- Git
- GitHub
- Visual Studio Code

## 🏗️ System Architecture

Oloni Bank uses a full-stack architecture built with Flutter, FastAPI, SQLAlchemy, and PostgreSQL.

The Flutter mobile application communicates with the FastAPI backend through REST APIs. The backend handles authentication and banking operations, while SQLAlchemy is used to communicate with the PostgreSQL database.

```
Flutter App
     ↓
FastAPI Backend
     ↓
SQLAlchemy
     ↓
PostgreSQL

This structure helped me understand how a mobile application, backend API, and database work together as one system.
```
## 🔄 How the Application Works

The main flow of Oloni Bank is:

1. A user creates an account through the Flutter mobile application.
2. The Flutter application sends the account information to the FastAPI backend.
3. The backend validates the information and stores the customer and account data in PostgreSQL.
4. The user logs in through the mobile application.
5. Authenticated users can perform banking operations such as deposits, withdrawals, and transfers.
6. Each transaction is processed by the backend and recorded in the database.
7. The Flutter application retrieves the updated information from the API and displays it to the user.

Building this flow helped me understand the relationship between a mobile frontend, backend services, APIs, authentication, and persistent database storage.

## 📱 Application Screenshots

### Splash Screen

![Oloni Bank Splash Screen](screenshots/Splash_screen.jpeg)

### Login Screen

![Oloni Bank Login Screen](screenshots/Login_screen.jpeg)

### Dashboard

![Oloni Bank Dashboard](screenshots/Dashboard.jpeg)

### Deposit

![Oloni Bank Deposit](screenshots/Deposit_screen.jpeg)

### Transfer

![Oloni Bank Transfer](screenshots/Transfer.jpeg)

### Transaction Details

![Oloni Bank Transaction Details](screenshots/Transaction%20Details.jpeg)

## 🚀 Production Deployment

The FastAPI backend for Oloni Bank is deployed on Render.

**Production API:**

https://oloni-bank-api.onrender.com

The production setup uses:

- FastAPI for the backend API
- PostgreSQL for persistent data storage
- SQLAlchemy for database interaction
- Environment variables for database and application configuration
- Render for backend deployment

The Flutter application is configured to communicate with the deployed production API.

## 📂 Project Structure

The Flutter application is organised into different sections for the user interface, configuration, services, assets, and platform-specific files.

```text
oloni_bank/
│
├── android/
├── ios/
├── lib/
│   ├── config/
│   ├── screens/
│   ├── services/
│   └── ...
│
├── assets/
│   └── Images/
│
├── screenshots/
│   ├── Dashboard.jpeg
│   ├── Deposit_screen.jpeg
│   ├── Login_screen.jpeg
│   ├── Splash_screen.jpeg
│   ├── Transaction Details.jpeg
│   └── Transfer.jpeg
│
├── test/
├── pubspec.yaml
└── README.md
```

## 💻 Running the Project Locally

### 1. Clone the Flutter repository

```bash
git clone https://github.com/Olonisakin-Emmanuel/oloni-bank-flutter.git
cd oloni_bank
```

### 2. Install Flutter dependencies

```bash
flutter pub get
```

### 3. Configure the API

The Flutter application uses a central API configuration to communicate with the backend.

For local development, configure the application to point to your local FastAPI server.

For production, the application uses:

```text
https://oloni-bank-api.onrender.com
```

### 4. Run the application

```bash
flutter run
```

## 🔧 Backend Repository

The FastAPI backend is maintained in a separate repository:

https://github.com/Olonisakin-Emmanuel/oloni-bank-api

The backend contains the API endpoints, authentication logic, banking operations, database models, and PostgreSQL integration.

## 📚 What I Learned

Building Oloni Bank gave me practical experience working across different parts of a software system.

Some of the main areas I worked with include:

- Building mobile interfaces with Flutter and Dart
- Developing REST APIs with Python and FastAPI
- Working with PostgreSQL databases
- Using SQLAlchemy as an ORM
- Implementing JWT authentication
- Hashing passwords securely with Argon2
- Connecting a mobile frontend to a backend API
- Managing application configuration
- Using Git and GitHub for version control
- Deploying a backend application to Render
- Debugging frontend, backend, database, and deployment issues

The project also helped me understand that building a working application involves more than writing code. Testing, debugging, deployment, configuration, and understanding how the different components communicate are equally important.

## 🔮 Future Development — Oloni Bank 2.0

Oloni Bank 2.0 is planned to introduce more intelligent and personalised banking features, with **AI playing a major role** in the next stage of the project.

Planned areas include:

- 🎙️ **Voice Banking** — allowing users to interact with the application using voice.
- 🤖 **Oloni AI** — an AI-powered financial assistant that can help users understand their spending and financial activity.
- 📊 **Oloni Insight** — personalised financial insights and analytics.
- 🔐 **Enhanced Security** — stronger authentication and transaction security.
- 🎯 **Financial Goals** — tools to help users set and track personal financial goals.
- 🧾 **Enhanced Transaction Experience** — improved receipts and transaction features.

The goal is to evolve Oloni Bank from a basic digital banking application into a more intelligent and personalised financial platform.

## 👨‍💻 Author

**Engr. Dr. Kolade Julius Olonisakin, FNSE**

AI & Smart Mobility Specialist | Software Engineering & AI Enthusiast

GitHub:  
https://github.com/Olonisakin-Emmanuel

## 📌 Project Purpose

Oloni Bank was built as a learning and portfolio project to gain practical experience in full-stack application development and to better understand how modern digital banking systems are structured.

It is not intended for real financial transactions or use as a real banking service.
```
