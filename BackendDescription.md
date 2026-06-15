# Backend Description

## Overview

The backend of Geo Baby was implemented using Python and the Flask framework. Its main purpose is to serve as the communication layer between the Flutter mobile application, the MySQL database, and the wearable bracelet used for child monitoring.

The backend exposes several API endpoints that allow the system to manage users, children, bracelets, activities, photos, announcements, messages, and alert notifications. It also handles the update of bracelet monitoring data, including location, pulse, battery level, and danger status.

## Backend Responsibilities

The backend is responsible for:

* Receiving data from the wearable bracelet.
* Updating bracelet monitoring records.
* Serving child information to the mobile application.
* Managing users according to their role.
* Registering and editing child records.
* Linking children with representatives, tutors, and coordinators.
* Managing activities and related photos.
* Managing announcements and user messages.
* Sending email alerts when a child is detected outside the allowed range.

## Main Technologies

The backend uses the following technologies:

| Technology | Purpose                                                 |
| ---------- | ------------------------------------------------------- |
| Python     | Main programming language.                              |
| Flask      | Web framework used to expose API endpoints.             |
| PyMySQL    | Library used to connect Python with the MySQL database. |
| Yagmail    | Library used to send email notifications.               |
| MySQL      | Relational database used to store system records.       |

## Backend Architecture

The backend follows a simple REST-style architecture. The mobile application sends HTTP requests to the Flask server, and the backend interacts with the MySQL database to retrieve, insert, update, or delete information.

```text
Flutter Mobile App
        |
        v
Flask Backend API
        |
        v
MySQL Database
```

The wearable bracelet also communicates with the backend to update monitoring data.

```text
Wearable Bracelet
        |
        v
/edit_bracelet Endpoint
        |
        v
bracelet Table
```

## Main API Endpoints

### User Management

| Endpoint      | Method | Description                                       |
| ------------- | ------ | ------------------------------------------------- |
| `/login`      | GET    | Authenticates a user using username and password. |
| `/register`   | GET    | Registers a new user in the system.               |
| `/user`       | GET    | Retrieves users according to their role.          |
| `/edit_user`  | GET    | Updates user phone number and password.           |
| `/recuperate` | GET    | Retrieves user information for account recovery.  |

### Child Management

| Endpoint        | Method | Description                                             |
| --------------- | ------ | ------------------------------------------------------- |
| `/child`        | GET    | Retrieves children associated with a specific user.     |
| `/new_child`    | GET    | Registers a new child and links the child to a user.    |
| `/edit_child`   | GET    | Updates child information and assigned class.           |
| `/delete_child` | GET    | Deletes a child record and its user-child associations. |
| `/add_child`    | GET    | Associates an existing child with a user.               |
| `/remove_child` | GET    | Removes the association between a user and a child.     |

### Bracelet Monitoring

| Endpoint         | Method | Description                                                         |
| ---------------- | ------ | ------------------------------------------------------------------- |
| `/bracelet`      | GET    | Retrieves all bracelet monitoring records.                          |
| `/edit_bracelet` | GET    | Updates bracelet location, pulse, battery level, and danger status. |

The `/edit_bracelet` endpoint is one of the most important endpoints in the system because it receives monitoring updates from the wearable bracelet. When the `peligro` field indicates a danger condition, the backend identifies the representative associated with the child and sends an email alert.

## Alert Notification Process

The alert process works as follows:

1. The bracelet sends updated data to the backend.
2. The backend updates the bracelet record in the database.
3. If the `peligro` value is active, the backend searches for the child linked to that bracelet.
4. The backend identifies the representative associated with the child.
5. An email alert is sent to the representative.
6. The alert message indicates that the child is outside the allowed range.

```text
Bracelet detects danger
        |
        v
Backend receives update
        |
        v
Database is updated
        |
        v
Representative is identified
        |
        v
Email alert is sent
```

## Activity and Photo Management

| Endpoint           | Method | Description                                      |
| ------------------ | ------ | ------------------------------------------------ |
| `/activity`        | GET    | Retrieves activities by class.                   |
| `/new_activity`    | GET    | Creates a new activity.                          |
| `/delete_activity` | GET    | Deletes an activity and its associated photos.   |
| `/photo`           | GET    | Retrieves photos associated with an activity.    |
| `/new_photo`       | POST   | Uploads a new photo and links it to an activity. |

The backend allows activities to be created by class. Photos can then be uploaded and associated with a specific activity.

## Announcement and Message Management

| Endpoint                | Method | Description                                         |
| ----------------------- | ------ | --------------------------------------------------- |
| `/advertisement`        | GET    | Retrieves announcements by class.                   |
| `/new_advertisement`    | GET    | Creates a new announcement.                         |
| `/delete_advertisement` | GET    | Deletes an announcement and its messages.           |
| `/message`              | GET    | Retrieves messages associated with an announcement. |
| `/new_message`          | GET    | Creates a new message linked to an announcement.    |

This functionality supports institutional communication between coordinators, tutors, and representatives.

## Class-Based Filtering

The backend includes class-based filtering through the `/class`, `/activity`, and `/advertisement` endpoints. This allows the mobile application to display information only for the classes associated with the user.

For example, a representative linked to a child in class `A` can access announcements and activities related to that class.

## Prototype Considerations

This backend was developed as a functional prototype for academic and research purposes. Therefore, it prioritizes system integration and proof of concept over production-level security.

## Recommended Improvements

Before deploying this backend in a production environment, the following improvements are recommended:

* Use environment variables for database and email credentials.
* Hash user passwords instead of storing them in plain text.
* Replace unsafe SQL string formatting with parameterized queries.
* Use POST, PUT, and DELETE methods for operations that modify data.
* Add token-based authentication.
* Validate all input parameters.
* Improve exception handling and logging.
* Use HTTPS for secure communication.
* Separate configuration files from application logic.
* Implement role-based access control at the API level.

## Summary

The backend service acts as the central communication component of Geo Baby. It receives monitoring data from the wearable bracelet, stores and retrieves information from the database, supports the mobile application, and triggers notifications when a child is detected in a possible risk situation.
