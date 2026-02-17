<p align="center">
  <img src="assets/images/app_icon.png" width="120" alt="Mango App Icon" />
</p>

<h1 align="center">🥭 Mango</h1>

<p align="center">
  <strong>Your Mind, Architected.</strong><br>
  A premium self-affirmation experience built to nurture your inner dialogue through the power of intention.
</p>

<p align="center">
  <img src="https://img.shields.io/badge/Flutter-3.7-02569B?logo=flutter" alt="Flutter" />
  <img src="https://img.shields.io/badge/Dart-3.7-0175C2?logo=dart" alt="Dart" />
  <img src="https://img.shields.io/badge/Platform-iOS%20%7C%20Android-lightgrey" alt="Platforms" />
  <img src="https://img.shields.io/badge/License-MIT-green" alt="License" />
</p>

---

## ✨ The Mango Philosophy

Mango isn't just an affirmation app; it's a tool for mental architecture. Inspired by the growth of a mango tree, the app serves as a fertile ground where consistent positive intentions grow into a resilient reality. Every interaction—from the tactile haptic feedback to the smooth parallax transitions—is designed to be a mindful interrupt in your busy day.

---

## 📱 Visual Experience

<p align="center">
  <img src="screenshots/home.png" width="200" alt="Home - Parallax Background" />
  &nbsp;&nbsp;
  <img src="screenshots/themes.png" width="200" alt="Focus Categories - Personalized Selection" />
  &nbsp;&nbsp;
  <img src="screenshots/theme_gallery.png" width="200" alt="Theme Gallery - Immersive Backgrounds" />
</p>

<p align="center">
  <img src="screenshots/settings.png" width="200" alt="Profile - Streak Tracking" />
  &nbsp;&nbsp;
  <img src="screenshots/favorites.png" width="200" alt="Favorites - Searchable Wisdom" />
  &nbsp;&nbsp;
  <img src="screenshots/widget.png" width="200" alt="Home Screen Widget - Minimalist Display" />
</p>

---

## 🚀 Key Features Deep Dive

### 🥭 Evolutionary Mascot
Your journey is represented by a growing mango mascot that evolves based on your daily consistency:
- **Seedling** (0-3 days): The beginning of your mindful journey.
- **Sprout** (4-10 days): Growth begins as you commit to your practice.
- **Ripe Mango** (11-25 days): Your mental habits are becoming established.
- **Golden Aura** (26+ days): Absolute mastery. Includes a special prismatic shimmer effect in the app.

### 🎯 Personalized Onboarding
A multi-dimensional 7-step flow ensures the app resonates with your specific life context:
1. **Welcome**: Introduction to the "Architect" philosophy.
2. **Identification**: Personalized address.
3. **Pursuit**: Aligning affirmations with your career or creative goals.
4. **Partnership**: Addressing your current relationship status for emotional relevance.
5. **Vibrational Match**: Selecting specific energy categories (Self-Love, Health, etc.).
6. **Mental Recalibration**: Setting custom notification frequencies and times.
7. **The Mango Pledge**: A symbolic commitment to your growth.

### 🎨 Immersive Theming Engine
- **Parallax Backgrounds**: Dynamic layers that move with your device's movement.
- **Mix Mode**: Can't decide on one focus? Use "Mix Mode" to combine multiple categories into a custom deck.
- **Stardust Overlays**: Subtle, animated textures that enhance readability and depth.
- **Custom Creation**: Build your own themes using hex colors or curated gradients.

---

## 🏗️ Technical Architecture

Mango follows a robust **Repository-Service-View** pattern, ensuring separation of concerns and scalability.

```
lib/
├── core/
│   ├── theme/           # Design System tokens (Typography, Colors, Spacing)
│   ├── di/              # Service Locator (GetIt) for global state
│   └── utils/           # Adaptive Haptics and native bridges
├── features/            # Feature-first module structure
│   ├── home/            # Affirmation engine with Stack-based transition
│   ├── focus/           # Multi-category "Mix Mode" selection
│   ├── themes/          # GPU-accelerated backdrop rendering
│   └── settings/        # Streak logic and Mascot evolution
├── models/              # Type-safe schemas (Hive-compatible)
├── repository/          # Persistent data layer with Hive & SharedPreferences
└── services/            # Domain-specific logic (Mascot, Notification, Widget)
```

### 🧬 Design System
- **Typography**: Uses the custom **AlanSans** font family across 12+ semantic styles.
- **Color Palette**: 
  - Primary: Deep Navy (`#030A1F`)
  - Accent: Mango Orange (`#FFA726`)
  - Semantic: `success`, `warning`, `error` tokens.
- **Motion**: Fine-tuned using `flutter_animate` with standardized "short", "medium", and "long" duration tokens.

---

## 🛠 Tech Stack

| Layer              | Technology                                | Purpose                                   |
|--------------------|-------------------------------------------|-------------------------------------------|
| **Core**           | Flutter 3.7 / Dart 3.7                    | Cross-platform framework                  |
| **State**          | GetX                                      | Reactive state and routing                |
| **Persistence**    | Hive                                      | High-performance NoSQL local storage      |
| **Hardware**       | Sensors Plus                              | Parallax motion via accelerometer         |
| **Native Integration**| HomeWidget                            | iOS/Android home screen widget bridge     |
| **Networking**     | CachedNetworkImage                        | Optimizing theme background delivery      |

---

## 🎨 Project Setup

```bash
# Force flutter to use specific version
fvm use 3.7.2

# Get dependencies
flutter pub get

# Setup iOS specific pods
cd ios && pod install && cd ..

# Run project
flutter run
```

---

<p align="center">
  Crafted with intention by <a href="https://github.com/ibhanu">ibhanu</a>
</p>
