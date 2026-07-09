# 👶 Real-Time Child Monitoring System — Baby Espol Child Development Center

[![Python](https://img.shields.io/badge/Python-3.x-blue.svg)](https://www.python.org/)
[![Flask](https://img.shields.io/badge/Flask-Backend-black.svg)](https://flask.palletsprojects.com/)
[![Flutter](https://img.shields.io/badge/Flutter-Mobile-02569B.svg)](https://flutter.dev/)
[![MySQL](https://img.shields.io/badge/MySQL-Database-4479A1.svg)](https://www.mysql.com/)
[![Status](https://img.shields.io/badge/status-research%20prototype-yellow.svg)]()

A prototype mobile and backend system built to support real-time child monitoring at the Baby Espol Child Development Center. The project integrates a **Flutter**-based mobile application, a **Flask** backend service, and a **MySQL** database to manage children, users, bracelets, activities, announcements, photos, messages, and alert notifications.

This repository contains the implementation artifacts associated with the research paper:

> **"Real-time Child Monitoring System for Baby Espol Child Development Center"**

---

## 📑 Table of Contents

- [Project Overview](#-project-overview)
- [System Architecture](#-system-architecture)
- [Main Features](#-main-features)
- [Technologies Used](#-technologies-used)
- [Repository Structure](#-repository-structure)
- [Installation and Execution](#-installation-and-execution)
- [Additional Documentation](#-additional-documentation)
- [Security Notice](#-security-notice)
- [Research Context](#-research-context)
- [License](#-license)
- [Authors](#-authors)

---

## 📋 Project Overview

The system was designed to improve child supervision through a digital platform that connects three main components:

### 1. Mobile Application
- Developed using **Flutter**.
- Provides a cross-platform interface for representatives, tutors, and coordinators.
- Allows users to consult child information, view activities, receive announcements, and access monitoring data.

### 2. Backend Service
- Implemented in **Python** using the **Flask** framework.
- Exposes API endpoints for communication between the mobile application, the database, and the wearable bracelet.
- Handles user authentication, child management, bracelet updates, activity records, photo uploads, announcements, messages, and alert notifications.

### 3. Database
- Implemented in **MySQL**.
- Stores users, children, bracelets, classes, user-child assignments, activities, photos, announcements, and messages.
- Defines the relationships required to manage role-based access and child monitoring records.

---

## 🏗️ System Architecture

The prototype follows a three-layer software architecture connected to a wearable monitoring device:

```text
Wearable Bracelet
        │
        ▼
Flask Backend API
        │
        ▼
MySQL Database
        │
        ▼
Flutter Mobile Application
```

The wearable bracelet provides monitoring data such as location, pulse, battery level, and danger status. The backend receives and stores this information in the database. The mobile application consumes the backend endpoints to display child information, activities, announcements, and alerts to authorized users.

---

## ✨ Main Features

- 🔐 User login and registration.
- 👥 Role-based user management for:
  - Representatives
  - Tutors
  - Coordinators
- 🧒 Child profile registration, editing, and deletion.
- 📡 Bracelet data management, including:
  - Latitude
  - Longitude
  - Heart rate
  - Battery level
  - Danger status
- 🚨 Alert generation when a child is detected outside the allowed range.
- 📧 Email notification to representatives in case of danger alerts.
- 📅 Activity publication by class.
- 📷 Photo upload and association with activities.
- 📢 Announcement publication.
- 💬 Message registration associated with announcements.
- 🏫 Class-based information filtering.

---

## 🛠️ Technologies Used

| Category | Technologies |
|---|---|
| Mobile | Flutter, Dart, Android, Kotlin |
| Backend | Python, Flask, PyMySQL, Yagmail |
| Database | MySQL |

---

## 📂 Repository Structure

```text
.
├── README.md
├── Backend Description.md
├── Database Description.md
├── app.py
├── mysql.txt
├── AndroidManifest.xml
├── MainActivity.kt
├── build.gradle
├── analysis_options.yaml
├── .gitignore
└── assets/
```

---

## 🚀 Installation and Execution

### 1. Clone the Repository

```bash
git clone https://github.com/istevensp/Real-TimeChildMonitoringSystem.git
cd Real-TimeChildMonitoringSystem
```

### 2. Create the MySQL Database

Open MySQL and execute the script contained in:

```text
mysql.txt
```

This script creates the `baby_espol` database, defines the required tables, and inserts sample data.

### 3. Install Backend Dependencies

Create a Python virtual environment:

```bash
python -m venv venv
```

Activate it:

```bash
# Windows
venv\Scripts\activate

# Linux / macOS
source venv/bin/activate
```

Install the required dependencies:

```bash
pip install flask pymysql yagmail
```

### 4. Configure the Backend

Edit the database connection parameters in `app.py`:

```python
db = pymysql.connect(
    host='localhost',
    user='root',
    password='your_password',
    database='baby_espol'
)
```

Also configure the email sender credentials used for alerts.

> ⚠️ **Important:** Do not upload real credentials, passwords, or email app passwords to a public repository. Use environment variables instead (e.g., a `.env` file excluded via `.gitignore`).

### 5. Run the Backend

```bash
python app.py
```

By default, Flask will run the backend locally.

### 6. Run the Flutter Application

Inside the Flutter project directory, run:

```bash
flutter pub get
flutter run
```

Make sure the mobile application is configured to point to the correct backend URL.

---

## 📚 Additional Documentation

For a more detailed technical explanation, see:

- [Backend Description](Backend%20Description.md)
- [Database Description](Database%20Description.md)

---

## 🔒 Security Notice

This repository corresponds to a **research prototype**. Before using it in a production environment, the following improvements are recommended:

- [ ] Replace plain-text passwords with hashed passwords (bcrypt/argon2).
- [ ] Move database and email credentials to environment variables.
- [ ] Replace GET requests that modify data with POST, PUT, or DELETE methods.
- [ ] Use parameterized SQL queries to prevent SQL injection.
- [ ] Add authentication tokens for protected endpoints.
- [ ] Enable HTTPS for backend communication.
- [ ] Improve error handling and logging.
- [ ] Avoid storing sensitive information directly in source code.

---

## 🔬 Research Context

This project was developed as part of a research work focused on the design and implementation of a real-time child monitoring system for the Baby Espol Child Development Center. The prototype demonstrates how wearable devices, mobile applications, backend services, and relational databases can be integrated to support child safety, institutional communication, and monitoring record management.

---

## 📄 License

This project is intended for academic and research purposes. The final license should be defined according to the repository owner's publication and distribution requirements.

---

## 👤 Authors

Developed as part of the research project:

**Real-time Child Monitoring System for Baby Espol Child Development Center**
