# ShopVishnu - E-Commerce Mobile App

An Android e-commerce application built with modern Android architecture patterns.

## Tech Stack
- **Language**: Kotlin
- **Architecture**: MVVM (Model-View-ViewModel)
- **Networking**: Retrofit 2 + OkHttp
- **Local Database**: Room Persistence Library
- **Authentication & Backend**: Firebase Auth, Firestore, Storage
- **Dependency Injection**: Hilt (Dagger)
- **Image Loading**: Glide
- **Async**: Kotlin Coroutines + Flow

## Architecture
```
┌─────────────────────────────────────┐
│           UI Layer                   │
│  Activities / ViewModels / Adapters  │
├─────────────────────────────────────┤
│         Repository Layer             │
│  ProductRepo / CartRepo / AuthRepo   │
├────────────────┬────────────────────┤
│  Remote (API)  │   Local (Room DB)  │
│  Retrofit      │   DAOs / Entities  │
├────────────────┴────────────────────┤
│        Firebase Services             │
│  Auth / Firestore / Storage          │
└─────────────────────────────────────┘
```

## Features
- Product browsing with categories and search
- Product detail with ratings and reviews
- Shopping cart with quantity management
- Order placement and history
- Firebase authentication (login/register/guest)
- Offline-first with Room caching
- Material Design 3 UI
- Pull-to-refresh

## Setup
1. Add your `google-services.json` to `app/`
2. Open in Android Studio
3. Sync Gradle dependencies
4. Run on device/emulator (API 24+)

## API
Uses [FakeStore API](https://fakestoreapi.com/) for product data.
