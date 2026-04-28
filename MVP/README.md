# MVP

## Project Structure
```
MVP/
├── frontend/                     # Flutter mobile app
│
├── backend/
│   ├── app/
│   │   ├── api/                  # REST API routes (v1)
│   │   │   ├── v1/
│   │   │   │   ├── auth.py
│   │   │   │   ├── users.py
│   │   │   │   ├── artworks.py
│   │   │   │   ├── orders.py
│   │   │   │   └── ...
│   │   │
│   │   ├── models/               # ORM models
│   │   │   ├── user.py
│   │   │   ├── artwork.py
│   │   │   ├── order.py
│   │   │   └── ...
│   │   │
│   │   ├── services/             # Business logic layer
│   │   │   ├── auth_service.py
│   │   │   ├── order_service.py
│   │   │   ├── artwork_service.py
│   │   │   └── facade.py         # Entry point for services
│   │   │
│   │   ├── persistence/          # Data access layer
│   │   │   ├── repositories/
│   │   │   │   ├── user_repo.py
│   │   │   │   ├── order_repo.py
│   │   │   │   └── ...
│   │   │   └── base_repository.py
│   │   │
│   │   ├── integrations/         # External services
│   │   │   ├── moyasar_client.py
│   │   │   ├── fcm_client.py
│   │   │   └── storage_client.py
│   │   │
│   │   ├── core/                 # Core utilities
│   │   │   ├── config.py
│   │   │   ├── security.py       # JWT, hashing
│   │   │   ├── exceptions.py
│   │   │   └── utils.py
│   │   │
│   │   ├── sql/                  # DB schema & seeds
│   │   │   ├── schema.sql
│   │   │   ├── seed.sql
│   │   │   └── generate_admin_hash.py
│   │   │
│   │   ├── tests/
│   │   │   ├── test_models.py
│   │   │   ├── test_services.py
│   │   │   └── test_api.py
│   │
│   ├── instance/                # SQLite / local DB
│   │
│   ├── run.py
│   ├── config.py
│   ├── requirements.txt
│
├── docs/                        # Documentation
│   ├── architecture.md
│   ├── api.md
│   └── diagrams/
│
├── .env                         # Environment variables
├── .gitignore
└── README.md
```
