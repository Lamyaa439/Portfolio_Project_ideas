# MVP

## Project Structure
```

MVP/
├── Frontend/              # Frontend (Flutter)
│
├── instance/                # database
│
├──
├── app/
│   ├── api/                 # REST API (v1)
│   │
│   ├── models/              # ORM Models
│   │
│   ├── services/            # Business logic layer
│   │   ├── facade.py
│   │
│   ├── persistence/         # Data access layer
│   │   ├── repositories/
│   │   ├── repository.py
│   │
│   ├── sql/                 # Database schema & seed
│   │   ├── schema.sql
│   │   ├── seed.sql
│   │   ├── generate_admin_hash.py
│   │
│   ├── tests/
│   │   ├── test_models.py
│
├── run.py
├── config.py
├── requirements.txt
└── README.md
```
