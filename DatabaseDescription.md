# Database Description

## Overview

The Geo Baby database was implemented using MySQL. Its purpose is to store and organize the information required by the child monitoring system, including users, children, bracelets, classes, activities, photos, announcements, and messages.

The database is named:

```sql
baby_espol
```

It follows a relational structure, where children are linked to bracelets, users are linked to children, and class-based records are used to organize activities and announcements.

## Database Structure

The database contains the following main tables:

| Table           | Description                                               |
| --------------- | --------------------------------------------------------- |
| `user`          | Stores system users and their role information.           |
| `bracelet`      | Stores monitoring information from the wearable bracelet. |
| `class`         | Stores class identifiers.                                 |
| `child`         | Stores child records and links each child to a bracelet.  |
| `user_child`    | Links users, children, and classes.                       |
| `activity`      | Stores activities associated with a class.                |
| `photo`         | Stores photo references linked to activities.             |
| `advertisement` | Stores announcements associated with a class.             |
| `message`       | Stores messages linked to announcements.                  |

## Entity Relationship Summary

The database can be summarized as follows:

```text
user
  |
  | many-to-many through user_child
  v
child
  |
  | many-to-one
  v
bracelet

child
  |
  | associated through user_child
  v
class

class
  |
  | one-to-many
  v
activity

class
  |
  | one-to-many
  v
advertisement

activity
  |
  | one-to-many
  v
photo

advertisement
  |
  | one-to-many
  v
message
```

## Table Descriptions

### 1. `user`

The `user` table stores the personal and access information of each system user.

| Field        | Type    | Description                   |
| ------------ | ------- | ----------------------------- |
| `usuario`    | VARCHAR | Primary key. Unique username. |
| `contrasena` | VARCHAR | User password.                |
| `nombre`     | VARCHAR | User first name.              |
| `apellido`   | VARCHAR | User last name.               |
| `correo`     | VARCHAR | User email address.           |
| `telefono`   | VARCHAR | User phone number.            |
| `tipo`       | VARCHAR | User role.                    |

The `tipo` field identifies the role of the user. The prototype considers roles such as:

* `representante`
* `tutor`
* `coordinador`

### 2. `bracelet`

The `bracelet` table stores the monitoring data obtained from each wearable device.

| Field        | Type    | Description                               |
| ------------ | ------- | ----------------------------------------- |
| `id_pulsera` | INT     | Primary key. Bracelet identifier.         |
| `longitud`   | DOUBLE  | Longitude value reported by the bracelet. |
| `latitud`    | DOUBLE  | Latitude value reported by the bracelet.  |
| `pulso`      | DOUBLE  | Pulse or heart rate value.                |
| `bateria`    | INT     | Battery level.                            |
| `peligro`    | VARCHAR | Danger status reported by the bracelet.   |

This table is central to the monitoring function of the system because it stores the current state of each bracelet.

### 3. `class`

The `class` table stores the available class identifiers.

| Field   | Type    | Description                    |
| ------- | ------- | ------------------------------ |
| `clase` | VARCHAR | Primary key. Class identifier. |

Classes are used to organize children, activities, and announcements.

### 4. `child`

The `child` table stores the children registered in the system.

| Field        | Type    | Description                       |
| ------------ | ------- | --------------------------------- |
| `id_nino`    | INT     | Primary key. Child identifier.    |
| `nombre`     | VARCHAR | Child first name.                 |
| `apellido`   | VARCHAR | Child last name.                  |
| `id_pulsera` | INT     | Foreign key linked to `bracelet`. |

Each child can be associated with one bracelet.

### 5. `user_child`

The `user_child` table defines the relationship between users and children. It also stores the class associated with that relationship.

| Field     | Type    | Description                    |
| --------- | ------- | ------------------------------ |
| `usuario` | VARCHAR | Foreign key linked to `user`.  |
| `id_nino` | INT     | Foreign key linked to `child`. |
| `clase`   | VARCHAR | Foreign key linked to `class`. |

The primary key is composed of:

```sql
(usuario, id_nino)
```

This table allows the system to represent multiple relationships, for example:

* One representative can be linked to one or more children.
* One tutor can be linked to several children.
* One coordinator can access children from different classes.

### 6. `activity`

The `activity` table stores activities published for a specific class.

| Field    | Type    | Description                       |
| -------- | ------- | --------------------------------- |
| `id_act` | INT     | Primary key. Activity identifier. |
| `dia`    | VARCHAR | Activity date.                    |
| `titulo` | VARCHAR | Activity title.                   |
| `clase`  | VARCHAR | Foreign key linked to `class`.    |

Activities are filtered by class, allowing users to view only the activities related to their assigned children or group.

### 7. `photo`

The `photo` table stores photo references associated with activities.

| Field    | Type    | Description                         |
| -------- | ------- | ----------------------------------- |
| `enlace` | VARCHAR | Photo reference or file identifier. |
| `id_act` | INT     | Foreign key linked to `activity`.   |

Each activity can have multiple associated photos.

### 8. `advertisement`

The `advertisement` table stores announcements published for a specific class.

| Field        | Type    | Description                           |
| ------------ | ------- | ------------------------------------- |
| `id_anuncio` | INT     | Primary key. Announcement identifier. |
| `dia`        | VARCHAR | Announcement date.                    |
| `titulo`     | VARCHAR | Announcement title.                   |
| `clase`      | VARCHAR | Foreign key linked to `class`.        |

Announcements are used to support institutional communication with representatives and tutors.

### 9. `message`

The `message` table stores messages associated with announcements.

| Field        | Type    | Description                            |
| ------------ | ------- | -------------------------------------- |
| `id_mensaje` | INT     | Primary key. Message identifier.       |
| `usuario`    | VARCHAR | User who created the message.          |
| `mensaje`    | VARCHAR | Message content.                       |
| `id_anuncio` | INT     | Foreign key linked to `advertisement`. |

This table allows users to add messages or comments related to a specific announcement.

## Main Relationships

The database uses foreign keys to maintain consistency between tables:

| Relationship                                      | Description                                     |
| ------------------------------------------------- | ----------------------------------------------- |
| `child.id_pulsera` → `bracelet.id_pulsera`        | Links each child to a bracelet.                 |
| `user_child.usuario` → `user.usuario`             | Links a user to a child.                        |
| `user_child.id_nino` → `child.id_nino`            | Links a child to a user.                        |
| `user_child.clase` → `class.clase`                | Assigns a class to the user-child relationship. |
| `activity.clase` → `class.clase`                  | Links activities to classes.                    |
| `photo.id_act` → `activity.id_act`                | Links photos to activities.                     |
| `advertisement.clase` → `class.clase`             | Links announcements to classes.                 |
| `message.id_anuncio` → `advertisement.id_anuncio` | Links messages to announcements.                |

## Database Role in the System

The database supports three main functions:

### 1. Monitoring Records

The `bracelet` table stores the monitoring data reported by the wearable device, including location, pulse, battery level, and danger status.

### 2. User and Child Management

The `user`, `child`, and `user_child` tables allow the system to manage relationships between children and authorized users.

### 3. Communication and Activity Records

The `activity`, `photo`, `advertisement`, and `message` tables support communication between the institution and users by storing activities, photos, announcements, and related messages.

## Example Workflow

A typical system workflow is:

```text
1. A child is registered in the system.
2. The child is assigned to a bracelet.
3. The child is linked to a representative, tutor, or coordinator.
4. The bracelet sends monitoring data to the backend.
5. The backend updates the bracelet table.
6. The mobile application retrieves the updated information.
7. If danger is detected, the backend sends an alert notification.
```

## Prototype Considerations

This database was designed for a research prototype. The structure supports the core functionality of the system, but some improvements are recommended before production deployment.

## Recommended Improvements

* Store passwords using secure hashing.
* Use stricter data types for dates instead of `VARCHAR`.
* Use a Boolean or numeric type for the `peligro` field.
* Add timestamp fields such as `created_at` and `updated_at`.
* Add indexes for frequent search fields.
* Normalize message ownership by linking `message.usuario` as a foreign key to `user.usuario`.
* Add cascade rules where appropriate.
* Separate sample data from the production schema.
* Avoid storing credentials inside SQL scripts.

## Summary

The Geo Baby database provides the relational foundation for the monitoring system. It stores child, user, bracelet, class, activity, photo, announcement, and message data. Through its relationships, the database enables role-based access, real-time bracelet monitoring, and communication between the institution and authorized users.
