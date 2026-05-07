# LOOPRA - Circular Economy & Waste Revolution

> **Hackathon MVP** - Integrated Digital Platform for Organic Waste Supply Optimization toward Bioethanol and Biogas Production

## Overview

LOOPRA is a Flutter mobile application that connects organic waste producers (farmers, market vendors) with bioenergy industries. The platform uses AI-powered waste classification, predictive logistics, and an e-wallet incentive system to create a sustainable circular economy.

## Features (MVP Scope)

### Core Features
- **AI Waste Classification** - Upload photos of organic waste; AI classifies condition (overripe, light rot, heavy rot) and recommends bioethanol or biogas processing
- **E-Wallet Dashboard** - Track earnings from waste deposits, transaction history, and balance
- **Collection Point Map** - Find nearby waste collection points with Google Maps integration
- **Marketplace** - Browse B2B pre-order listings from bioenergy industries

### Extended Features (Phase 2)
- **Pickup Schedule** - View optimized logistics schedules for waste collection
- **Carbon Tracker** - Visualize methane emissions prevented and carbon credits earned
- **B2B Partner Portal** - Industry partner access to browse and pre-order waste supplies

## Tech Stack

| Layer | Technology |
|-------|-----------|
| Frontend | Flutter 3.x |
| State Management | Provider |
| Backend | Firebase (Auth, Firestore, Storage) |
| Maps | Google Maps Flutter |
| Charts | FL Chart |

## Project Structure

```
lib/
├── main.dart                 # App entry point
├── app.dart                  # MaterialApp configuration
├── core/
│   ├── constants/            # App constants, colors, API endpoints
│   ├── theme/                # AppTheme, text styles
│   └── utils/                # Helpers, formatters
├── models/
│   ├── user.dart
│   ├── waste_item.dart
│   ├── transaction.dart
│   ├── collection_point.dart
│   ├── marketplace_listing.dart
│   └── carbon_data.dart
├── services/
│   ├── auth_service.dart
│   ├── firestore_service.dart
│   ├── storage_service.dart
│   ├── ai_classification_service.dart
│   └── wallet_service.dart
├── providers/
│   ├── auth_provider.dart
│   ├── waste_provider.dart
│   ├── wallet_provider.dart
│   └── marketplace_provider.dart
├── screens/
│   ├── auth/
│   │   └── login_screen.dart
│   ├── home/
│   │   └── home_screen.dart
│   ├── waste_upload/
│   │   └── waste_upload_screen.dart
│   ├── wallet/
│   │   └── wallet_screen.dart
│   ├── marketplace/
│   │   └── marketplace_screen.dart
│   ├── map/
│   │   └── collection_map_screen.dart
│   ├── carbon_tracker/
│   │   └── carbon_tracker_screen.dart
│   └── schedule/
│       └── schedule_screen.dart
└── widgets/
    ├── common/
    └── custom/
```

## Getting Started

### Prerequisites
- Flutter SDK 3.10+
- Dart SDK 3.10+
- Firebase project (see setup below)
- Android Studio / Xcode for emulators

### Firebase Setup

1. Go to [Firebase Console](https://console.firebase.google.com/)
2. Create a new project named "Loopra"
3. Add Android app with package name: `com.loopra.loopra`
4. Download `google-services.json` and place it in `android/app/`
5. Add iOS app with bundle ID: `com.loopra.loopra`
6. Download `GoogleService-Info.plist` and place it in `ios/Runner/`
7. Enable Authentication (Email/Password), Firestore Database, and Storage

### Run the App

```bash
cd loopra
flutter pub get
flutter run
```

## Hackathon Notes

### What's Implemented
- [x] Flutter project scaffold with clean architecture
- [x] Firebase integration (Auth, Firestore, Storage)
- [x] AI Waste Classification (mocked with realistic demo data)
- [x] E-Wallet with transaction history
- [x] Collection point maps
- [x] Marketplace listings
- [x] Carbon tracker dashboard
- [x] Pickup schedule view

### Demo Flow
1. Login as a farmer/vendor
2. Upload waste photo → AI classifies → shows estimated value
3. Check wallet balance and transaction history
4. View nearby collection points on map
5. Browse marketplace for B2B buyers
6. View carbon impact tracker

## Team

**Kampus Tinggi** - Circular Economy & Waste Revolution Hackathon

## License

This project is for hackathon demonstration purposes.
