\# Real-time Child Monitoring System for Baby Espol Child Development Center



This is a prototype mobile and backend system developed to support real-time child monitoring at the Baby Espol Child Development Center. The project integrates a Flutter-based mobile application, a Flask backend service, and a MySQL database to manage children, users, bracelets, activities, announcements, photos, messages, and alert notifications.



This repository contains the implementation artifacts associated with the research paper:



\*\*“Real-time Child Monitoring System for Baby Espol Child Development Center”\*\*



\## Project Overview



The system was designed to improve child supervision through a digital platform that connects three main components:



1\. \*\*Mobile Application\*\*



&#x20;  \* Developed using Flutter.

&#x20;  \* Provides a cross-platform interface for representatives, tutors, and coordinators.

&#x20;  \* Allows users to consult child information, view activities, receive announcements, and access monitoring data.



2\. \*\*Backend Service\*\*



&#x20;  \* Implemented in Python using the Flask framework.

&#x20;  \* Exposes API endpoints for communication between the mobile application, the database, and the wearable bracelet.

&#x20;  \* Handles user authentication, child management, bracelet updates, activity records, photo uploads, announcements, messages, and alert notifications.



3\. \*\*Database\*\*



&#x20;  \* Implemented in MySQL.

&#x20;  \* Stores users, children, bracelets, classes, user-child assignments, activities, photos, announcements, and messages.

&#x20;  \* Defines the relationships required to manage role-based access and child monitoring records.



\## Additional Documentation



For a more detailed technical explanation, see:



\* \[Backend Description](Backend%20Description.md)

\* \[Database Description](Database%20Description.md)



\## Main Features



\* User login and registration.

\* Role-based user management for:



&#x20; \* Representatives

&#x20; \* Tutors

&#x20; \* Coordinators

\* Child profile registration, editing, and deletion.

\* Bracelet data management, including:



&#x20; \* Latitude

&#x20; \* Longitude

&#x20; \* Heart rate

&#x20; \* Battery level

&#x20; \* Danger status

\* Alert generation when a child is detected outside the allowed range.

\* Email notification to representatives in case of danger alerts.

\* Activity publication by class.

\* Photo upload and association with activities.

\* Announcement publication.

\* Message registration associated with announcements.

\* Class-based information filtering.



\## Repository Structure



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

├── analysis\_options.yaml

├── .gitignore

└── assets/

```



\## System Architecture



The prototype follows a three-layer software architecture connected to a wearable monitoring device:



```text

Wearable Bracelet

&#x20;       |

&#x20;       v

Flask Backend API

&#x20;       |

&#x20;       v

MySQL Database

&#x20;       |

&#x20;       v

Flutter Mobile Application

```



The wearable bracelet provides monitoring data such as location, pulse, battery level, and danger status. The backend receives and stores this information in the database. The mobile application consumes the backend endpoints to display child information, activities, announcements, and alerts to authorized users.



\## Technologies Used



\* Flutter

\* Dart

\* Android

\* Kotlin

\* Python

\* Flask

\* MySQL

\* PyMySQL

\* Yagmail



\## Installation and Execution



\### 1. Clone the Repository



```bash

git clone https://github.com/your-user/your-repository.git

cd your-repository

```



\### 2. Create the MySQL Database



Open MySQL and execute the script contained in:



```text

mysql.txt

```



This script creates the `baby\_espol` database, defines the required tables, and inserts sample data.



\### 3. Install Backend Dependencies



Create a Python virtual environment:



```bash

python -m venv venv

```



Activate it:



```bash

\# Windows

venv\\Scripts\\activate



\# Linux / macOS

source venv/bin/activate

```



Install the required dependencies:



```bash

pip install flask pymysql yagmail

```



\### 4. Configure the Backend



Edit the database connection parameters in `app.py`:



```python

db = pymysql.connect(

&#x20;   host='localhost',

&#x20;   user='root',

&#x20;   password='your\_password',

&#x20;   database='baby\_espol'

)

```



Also configure the email sender credentials used for alerts.



> Important: Do not upload real credentials, passwords, or email app passwords to a public repository.



\### 5. Run the Backend



```bash

python app.py

```



By default, Flask will run the backend locally.



\### 6. Run the Flutter Application



Inside the Flutter project directory, run:



```bash

flutter pub get

flutter run

```



Make sure the mobile application is configured to point to the correct backend URL.



\## Security Notice



This repository corresponds to a research prototype. Before using it in a production environment, the following improvements are recommended:



\* Replace plain-text passwords with hashed passwords.

\* Move database and email credentials to environment variables.

\* Replace GET requests that modify data with POST, PUT, or DELETE methods.

\* Use parameterized SQL queries to prevent SQL injection.

\* Add authentication tokens for protected endpoints.

\* Enable HTTPS for backend communication.

\* Improve error handling and logging.

\* Avoid storing sensitive information directly in source code.



\## Research Context



This project was developed as part of a research work focused on the design and implementation of a real-time child monitoring system for the Baby Espol Child Development Center. The prototype demonstrates how wearable devices, mobile applications, backend services, and relational databases can be integrated to support child safety, institutional communication, and monitoring record management.



\## License



This project is intended for academic and research purposes. The final license should be defined according to the repository owner’s publication and distribution requirements.



\## Authors



Developed as part of the research project:



\*\*Real-time Child Monitoring System for Baby Espol Child Development Center\*\*



