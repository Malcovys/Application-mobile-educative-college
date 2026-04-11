# EduLearn — Application Mobile Éducative Collège

**EduLearn** est une application mobile éducative développée avec **Flutter**, destinée aux élèves de collège. Elle permet de consulter des matières, de parcourir des chapitres et des leçons, de s'exercer sur des exercices interactifs, et de passer des examens blancs — le tout avec un support **online et offline** grâce à une base de données locale SQLite.

---

## ✨ Fonctionnalités

- 🔐 **Authentification** — Connexion sécurisée avec persistance de session
- 🏠 **Tableau de bord** — Vue d'ensemble de la progression (leçons, exercices, examens)
- 📚 **Matières & Chapitres** — Navigation par matière et chapitre
- 📖 **Leçons** — Consultation des contenus pédagogiques
- ✏️ **Exercices** — Exercices interactifs avec résultats enregistrés
- 📝 **Examens** — Simulation d'examens avec correction
- 👤 **Profil** — Suivi de la progression personnelle
- 📶 **Mode offline** — Accès aux données sans connexion Internet grâce à SQLite
- 🔄 **Synchronisation** — Synchronisation automatique lors du retour en ligne

---

## 🛠️ Stack technique

| Technologie | Rôle |
|---|---|
| [Flutter](https://flutter.dev/) | Framework UI multiplateforme |
| [Dart](https://dart.dev/) | Langage de programmation |
| [Dio](https://pub.dev/packages/dio) | Client HTTP avec intercepteurs |
| [sqflite_common_ffi](https://pub.dev/packages/sqflite_common_ffi) | Base de données SQLite locale |
| [shared_preferences](https://pub.dev/packages/shared_preferences) | Stockage de préférences légères |
| [internet_connection_checker_plus](https://pub.dev/packages/internet_connection_checker_plus) | Détection de la connectivité réseau |
| [percent_indicator](https://pub.dev/packages/percent_indicator) | Indicateurs de progression |
| [flutter_staggered_animations](https://pub.dev/packages/flutter_staggered_animations) | Animations décalées |
| [path_provider](https://pub.dev/packages/path_provider) | Accès aux répertoires système |

---

## 📁 Structure du projet

```
lib/
├── api/                      # Couche API (communication avec le serveur)
│   ├── endpoints.dart        # Définitions des endpoints
│   ├── api_client.dart       # Client HTTP avec intercepteurs
│   ├── api_service.dart      # Service API générique
│   └── services/             # Services API par entité
│
├── db/                       # Base de données locale SQLite
│   ├── dao/                  # Data Access Objects
│   ├── helpers/              # Helpers d'initialisation
│   ├── repositories/         # Repositories par entité
│   └── services/             # Services de persistance locale
│
├── models/                   # Modèles de données
│   ├── utilisateur_model.dart
│   ├── matiere_model.dart
│   ├── chapitre_model.dart
│   ├── lecon_model.dart
│   ├── exercice_model.dart
│   ├── examen_model.dart
│   ├── progress_model.dart
│   └── ...
│
├── services/                 # Services métier
│   ├── auth_service.dart     # Authentification & session
│   ├── data_service.dart     # Agrégation des données
│   ├── matiere_service.dart
│   ├── chapitre_service.dart
│   ├── lecon_service.dart
│   ├── exercice_service.dart
│   ├── examen_service.dart
│   └── storage_service.dart  # Stockage local (SharedPreferences)
│
├── pages/                    # Écrans de l'application
│   ├── login_page.dart
│   ├── home_page.dart
│   ├── subjects_page.dart
│   ├── chapter_lessons_page.dart
│   ├── lesson_page.dart
│   ├── exercise_page.dart
│   ├── exam_page.dart
│   ├── task_page.dart
│   └── profile_page.dart
│
├── widgets/                  # Widgets réutilisables
│
├── utils/                    # Utilitaires (connectivité, formatage…)
│
└── main.dart                 # Point d'entrée de l'application
```

---

## 🚀 Démarrage rapide

### Prérequis

- [Flutter SDK](https://docs.flutter.dev/get-started/install) ≥ 3.7.2
- Dart SDK ≥ 3.7.2
- Android Studio ou VS Code avec les extensions Flutter/Dart

### Installation

```bash
# Cloner le dépôt
git clone https://github.com/Malcovys/Application-mobile-educative-college.git
cd Application-mobile-educative-college

# Installer les dépendances
flutter pub get

# Lancer l'application
flutter run
```

### Plateformes supportées

| Plateforme | Statut |
|---|---|
| Android | ✅ Supporté |
| iOS | ✅ Supporté |
| Web | ✅ Supporté |
| Linux | ✅ Supporté |
| macOS | ✅ Supporté |
| Windows | ✅ Supporté |

---

## 🔌 Architecture online/offline

L'application adopte une architecture **offline-first** :

1. **Couche API** (`api/`) — Gère toutes les communications avec le serveur distant via Dio. Les intercepteurs traitent les erreurs réseau de manière transparente.

2. **Couche base de données locale** (`db/`) — Toutes les données sont persistées localement avec SQLite, garantissant un accès même sans connexion.

3. **Services métier** (`services/`) — Orchestrent les données entre l'API et la base locale. Lors d'un appel, les données sont d'abord récupérées depuis le cache local, puis mises à jour depuis le serveur si la connexion est disponible.

4. **Détection de connectivité** (`utils/`) — Surveille l'état du réseau en temps réel et déclenche les synchronisations dès que la connexion est rétablie.

---

## 🧪 Tests

```bash
flutter test
```

---

## 📄 Licence

Ce projet est à usage éducatif.

