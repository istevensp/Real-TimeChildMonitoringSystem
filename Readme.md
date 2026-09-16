# A Real-Time IoT-Based Child Safety and Wellbeing Monitoring System for Smart Childcare Centers

Implementation artifacts of a child monitoring prototype built for the Baby
ESPOL Child Development Center: a **Flask REST API of 25 endpoints**, a **MySQL
schema of 9 tables**, and a **Flutter mobile application** that gives parents,
tutors and coordinators a different view of the same records. The prototype was
evaluated with **48 participants at two child development centers** in
Guayaquil, Ecuador, and the responses and the analysis are published here.

Accepted as a poster at the 2026 IEEE International Smart Cities Conference
(ISC2).

## Survey results

The 48 participants — 33 parents, 11 tutors and 4 coordinators — explored the
application and answered a questionnaire written for their role. Across **369
ratings the mean was 4.58 out of 5** (SD 0.67), 90 % of the ratings were 4 or 5,
and none fell below the neutral midpoint. Everything behind those numbers is in
[`evaluation/`](evaluation/EvaluationDescription.md):

| | |
|---|---|
| [`EvaluationDescription.md`](evaluation/EvaluationDescription.md) | the method, every item and the limitations of the evaluation |
| [`results.md`](evaluation/results.md) | every item with its scale, the answers people chose, mean, median and SD |
| [`data/questions.md`](evaluation/data/questions.md) | every question and response scale, in English beside the Spanish original |
| [`analyze_surveys.py`](evaluation/analyze_surveys.py) | recomputes every figure above from the three response files |
| [`data/*.xlsx`](evaluation/data) | the raw responses, one file per role |

The section [*Usability evaluation*](#usability-evaluation) below breaks the
results down by group and says how to reproduce them.

## How the pieces fit

A wearable bracelet reports location, heart rate, battery level and a danger
status over the cellular network. The backend receives those readings, stores
them, and notifies the authorized representatives by e-mail when the bracelet
reports a distance-related risk condition. The mobile application never reaches
the database directly: every read and write goes through the API.

```text
Wearable bracelet ──▶ Flask REST API ──▶ MySQL
                            ▲
                            │
                   Flutter mobile application
```

Indoor location comes from Bluetooth beacons with fixed coordinates, placed in
each classroom and in the playground. The bracelet identifies the nearest beacon
and reports its coordinates through the cellular module, which is what fills the
`latitud` and `longitud` fields of the `bracelet` table and gives room-level
granularity where satellite positioning does not reach.

**The bracelet firmware is not part of this repository.** What is published here
is the backend, the mobile application, the database schema and the evaluation
data. The backend receives the danger status already computed by the device.

## Repository structure

```text
.
├── app.py                        Flask REST API, 25 endpoints
├── schema.sql                    database schema and seed data
├── LICENSE                       AGPL-3.0-only, for the code
├── BackendDescription.md         the API endpoint by endpoint
├── DatabaseDescription.md        tables, keys and relations
├── baby_espol/                   Flutter mobile application
│   ├── lib/
│   │   ├── main.dart
│   │   ├── datos/                models: child, user, bracelet, activity, message
│   │   ├── estilo/               shared widgets and styles
│   │   └── screen/               one folder per module
│   ├── assets/
│   ├── android/ ios/ linux/ macos/ web/ windows/
│   └── pubspec.yaml
└── evaluation/                   usability survey data and analysis
    ├── LICENSE                   CC BY 4.0, for the survey material
    ├── EvaluationDescription.md  method, results and limitations
    ├── analyze_surveys.py        computes the statistics from the raw responses
    ├── results.md                every item with its mean, median and SD
    └── data/
        ├── questions.md          every item and scale, in English and Spanish
        ├── parents_responses.xlsx
        ├── tutors_responses.xlsx
        └── coordinators_responses.xlsx
```

Four paths are deliberately **not** tracked: `.env` with the local
configuration, `photos/` where the backend writes activity images at run time,
`__pycache__/`, and the Flutter `build/` and `.dart_tool/` directories, which
`flutter pub get` and `flutter build` regenerate.

## Requirements

| | |
|---|---|
| Python | 3.8+ |
| Backend packages | `flask`, `pymysql`, `yagmail` |
| MySQL | 5.7+ |
| Flutter | Dart SDK `>=3.1.2 <4.0.0` |
| Survey script | `openpyxl`, and nothing else |

## Quick start

### 1. Clone

```bash
git clone https://github.com/istevensp/Real-TimeChildMonitoringSystem.git
cd Real-TimeChildMonitoringSystem
```

### 2. Create the database

Run `schema.sql` in MySQL. It drops and recreates `baby_espol`, defines the nine
tables and inserts sample data:

```bash
mysql -u root -p < schema.sql
```

### 3. Install the backend dependencies

```bash
python -m venv venv
source venv/bin/activate      # Windows: venv\Scripts\activate
pip install flask pymysql yagmail
```

### 4. Configure

The backend reads every deployment-specific value from the environment, so no
credential and no machine-specific path is stored in `app.py`:

| Variable | Meaning |
|---|---|
| `BABY_ESPOL_DB_HOST` | MySQL host (default `localhost`) |
| `BABY_ESPOL_DB_USER` | MySQL user (default `root`) |
| `BABY_ESPOL_DB_PASSWORD` | MySQL password |
| `BABY_ESPOL_DB_NAME` | database name (default `baby_espol`) |
| `BABY_ESPOL_MAIL_SENDER` | address used to send the alert e-mails |
| `BABY_ESPOL_MAIL_PASSWORD` | application password of that account |
| `BABY_ESPOL_PHOTO_PATH` | directory for activity photos (default `./photos`) |

`BABY_ESPOL_MAIL_PASSWORD` is a Google application password, not the account
password.

### 5. Run the backend

```bash
python app.py
```

Flask serves on `localhost:5000` in debug mode. `BABY_ESPOL_PHOTO_PATH` is
created on demand, one directory per activity.

### 6. Run the mobile application

```bash
cd baby_espol
flutter pub get
flutter run
```

Point the application at the backend URL of your environment before running it.

## The API

`app.py` exposes 25 endpoints covering users and authentication, children and
their representatives, bracelet readings, activities with photographic evidence,
announcements and messages. [`BackendDescription.md`](BackendDescription.md)
documents them one by one and
[`DatabaseDescription.md`](DatabaseDescription.md) describes the nine tables and
how they relate.

**Twenty-four of the twenty-five are `GET`**, including the ones that create,
edit and delete records; only photo upload is a `POST`. That is a property of
the prototype, not a recommendation — see *Security* below.

## Usability evaluation

Three questionnaires, one per role, all on five-point Likert scales.
Participants explored the application and its functions before answering; they
did not use it during a normal working day, so the survey measures perceived
usability and usefulness, not adoption.

| Group | n | Ratings | Mean | SD | 4 or 5 |
|---|---|---|---|---|---|
| Parents | 33 | 264 | 4.56 | 0.67 | 90 % |
| Tutors | 11 | 77 | 4.58 | 0.69 | 88 % |
| Coordinators | 4 | 28 | 4.71 | 0.53 | 96 % |
| **All** | **48** | **369** | **4.58** | **0.67** | **90 %** |

The highest-rated items were the willingness to recommend the application and
the location view. The lowest, at 4.25 over four coordinators, was whether the
application gave them the information they need to supervise activities. The
minimum of all 369 ratings is 3, which is consistent with courtesy bias in a
demonstration setting.

To recompute every figure above from the raw responses:

```bash
cd evaluation
pip install openpyxl
python analyze_surveys.py
```

The script reads only the three files in `evaluation/data/` and rewrites
`results.md`, so two runs produce identical output. The response files carry no
identifying information: no names, no e-mail addresses, no timestamps and no
free-text fields.

## Security

This is a **research prototype**, evaluated in demonstrations rather than
operated with real children's data. What that means concretely:

- No credential is tracked any more. The backend reads them from the
  environment, and `.env` is git-ignored.
- **Earlier values remain in the git history.** A database password and a Google
  application password were committed, and anything ever committed must be
  treated as disclosed and rotated, not merely removed.
- Passwords are stored in plain text in the `user` table.
- SQL statements are built by string interpolation, so the endpoints are open to
  injection.
- The endpoints that modify data answer to `GET`, which makes them reachable
  from any link or prefetch.
- There is no transport encryption and no authentication token; the mobile
  application authenticates users, so authorization lives in the client rather
  than in the backend.

Before any deployment: rotate the credentials and rewrite the history, hash the
stored passwords, parameterize every query, move the modifying endpoints to
`POST`, `PUT` and `DELETE`, enable HTTPS, and move authentication and
authorization into the backend.

## Citation

```bibtex
@inproceedings{Santillan2026ChildMonitoring,
  author    = {Steven Santillan and Maria Fernanda Panchana Ochoa and
               Sandra Coello Suarez and Christopher Vaccaro},
  title     = {A Real-Time IoT-Based Child Safety and Wellbeing Monitoring
               System for Smart Childcare Centers},
  booktitle = {2026 IEEE International Smart Cities Conference (ISC2)},
  year      = {2026}
}
```

Update the entry with the pages and DOI once they are assigned.

## Authors

Steven Santillan, Maria Fernanda Panchana Ochoa, Sandra Coello Suarez and
Christopher Vaccaro — Faculty of Electrical and Computer Engineering, Escuela
Superior Politécnica del Litoral (ESPOL), Guayaquil, Ecuador.

## License

GNU Affero General Public License v3.0 only (AGPL-3.0-only). You may use,
study, modify and redistribute this software under its terms; if you modify it
and make it available to users over a network, you must also give those users
access to the corresponding source of your modified version. This covers the
backend, the mobile application and the database schema. See
[LICENSE](LICENSE) for the full text.

The evaluation material in [`evaluation/`](evaluation) — the questionnaire
responses, the items and scales, and the reported results — is released under
**Creative Commons Attribution 4.0 International (CC BY 4.0)** instead, so it
can be reused and cited as research data; see
[`evaluation/LICENSE`](evaluation/LICENSE). The script that computes the
statistics is code and stays under the AGPL.

Third-party libraries keep their own licenses.
