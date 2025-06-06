# application_mobile_educative_college

### Organisation des dossier

lib/
├── api/                      # Gestion des appels API
│   ├── endpoints.dart        # Définitions des endpoints
│   ├── api_client.dart       # Client HTTP avec intercepteurs
│   └── api_service.dart      # Services pour chaque type de données
│
├── db/                       # Gestion de la base de données locale
│   ├── database_helper.dart  # Initialisation et connexion SQLite
│   ├── repositories/         # Repositories pour chaque entité
│   └── dao/                  # Data Access Objects
│
├── models/                   # Modèles de données
│   ├── exam_model.dart       # (existant)
│   ├── lesson_model.dart
│   └── user_model.dart
│
├── services/                 # Services métier
│   ├── data_service.dart     # (existant)
│   ├── auth_service.dart     # Authentification
│   └── sync_service.dart     # Synchronisation online/offline
│
├── pages/                    # Écrans de l'application
│   ├── exam_page.dart        # (existant)
│   ├── lesson_page.dart
│   └── profile_page.dart
│
├── widgets/                  # Widgets réutilisables
│   ├── common/               # Widgets génériques
│   └── specific/             # Widgets spécifiques au domaine
│
├── utils/                    # Utilitaires
│   ├── connectivity.dart     # Gestion de la connectivité
│   ├── formatters.dart       # Formatage de données
│   └── validators.dart       # Validation de données
│
├── config/                   # Configuration
│   ├── app_config.dart       # Configuration globale
│   └── themes.dart           # Thèmes de l'application
│
├── constants/                # Constantes
│   ├── app_constants.dart
│   └── api_constants.dart
│
├── localization/             # Internationalisation
│
└── main.dart                 # Point d'entrée de l'application

### Explications clés pour la gestion online/offline

1. Couche API (`api/`):

- Gère toutes les communications avec les serveurs externes
- Implémente des intercepteurs pour gérer les échecs de requêtes

2. Couche Base de données (`db/`):

- Utilise SQLite pour stocker les données localement

3. Service de synchronisation (`services/sync_service.dart`):

- Coordonne les données entre l'API et la base de données locale
- Gère la stratégie de synchronisation (quand et quoi synchroniser)
- Implémente des files d'attente pour les opérations à réaliser une fois la connectivité rétablie

4. Utilitaire de connectivité (`utils/connectivity.dart`):

- Surveille l'état de la connexion Internet
- Déclenche les synchronisations quand nécessaire

