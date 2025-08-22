# Local Express - On-Demand Delivery App for Vehari City

## 🚀 Quick Start

### Prerequisites

- Flutter SDK (>=3.0.0)
- Android Studio / VS Code
- Firebase account
- Google Cloud Console account (for Maps API)

### Installation Steps

1. **Install Flutter SDK**

   ```bash
   # Download from https://flutter.dev/docs/get-started/install
   # Add to PATH environment variable
   flutter doctor
   ```

2. **Clone and Setup Project**

   ```bash
   cd "c:\Users\Ahsan\Desktop\delivery"
   flutter pub get
   flutter doctor
   ```

3. **Firebase Configuration**

   - Create a new Firebase project at https://console.firebase.google.com
   - Enable Authentication (Email/Password)
   - Enable Firestore Database
   - Enable Cloud Messaging
   - Download `google-services.json` and place in `android/app/`
   - Update `lib/services/firebase_service.dart` with your configuration

4. **Google Maps Setup**

   - Get API key from Google Cloud Console
   - Enable Maps SDK for Android
   - Update `android/app/src/main/AndroidManifest.xml` with your API key
   - Replace `YOUR_API_KEY_HERE` with actual key

5. **Run the App**
   ```bash
   flutter analyze
   flutter run
   ```

## 📱 App Features

### Customer App

- **User Authentication**: Secure login/signup with email verification
- **Shop Discovery**: Browse local shops with categories and search
- **Real-time Ordering**: Place orders with live tracking
- **Multiple Payment**: Cash on delivery, digital wallets
- **Order History**: View past orders and reorder favorites
- **Ratings & Reviews**: Rate shops and delivery experience
- **Multilingual**: English and Urdu language support

### Rider App

- **Rider Dashboard**: View available and assigned orders
- **GPS Navigation**: Integrated maps for efficient delivery routes
- **Real-time Updates**: Update order status and communicate with customers
- **Earnings Tracking**: View daily, weekly, and monthly earnings
- **Profile Management**: Update availability and personal information

### Admin Dashboard

- **Shop Management**: Add, edit, and manage local shops
- **Order Monitoring**: Real-time order tracking and management
- **Rider Management**: Onboard and manage delivery riders
- **Analytics**: Business insights and performance metrics
- **User Support**: Handle customer queries and issues

## 🛠 Technical Architecture

### Frontend (Flutter)

- **State Management**: Riverpod for reactive programming
- **Navigation**: GoRouter for type-safe routing
- **UI Framework**: Material Design 3 with custom animations
- **Localization**: Complete English/Urdu support
- **Maps Integration**: Google Maps for location services

### Backend (Firebase)

- **Authentication**: Firebase Auth with email/password
- **Database**: Firestore for real-time data synchronization
- **Storage**: Firebase Storage for images and files
- **Messaging**: Firebase Cloud Messaging for push notifications
- **Analytics**: Firebase Analytics for user behavior tracking

### Key Dependencies

```yaml
dependencies:
  flutter: sdk
  firebase_core: ^2.24.2
  firebase_auth: ^4.15.3
  cloud_firestore: ^4.13.6
  firebase_storage: ^11.5.6
  firebase_messaging: ^14.7.10
  flutter_riverpod: ^2.4.9
  go_router: ^12.1.3
  google_maps_flutter: ^2.5.0
  flutter_animate: ^4.2.0+1
  lottie: ^2.7.0
  intl: ^0.18.1
```

## 📁 Project Structure

```
lib/
├── main.dart                 # App entry point
├── models/                   # Data models
│   ├── user_model.dart
│   ├── shop_model.dart
│   └── order_model.dart
├── services/                 # Business logic services
│   ├── auth_service.dart
│   ├── firebase_service.dart
│   ├── notification_service.dart
│   └── order_service.dart
├── providers/                # State management
│   ├── auth_provider.dart
│   ├── locale_provider.dart
│   └── order_provider.dart
├── screens/                  # UI screens
│   ├── auth/
│   ├── customer/
│   ├── rider/
│   └── admin/
├── widgets/                  # Reusable UI components
├── utils/                    # Utilities and helpers
│   ├── app_theme.dart
│   ├── app_router.dart
│   └── localization.dart
└── assets/                   # Images, fonts, animations
```

## 🌐 Localization

The app supports both English and Urdu languages with persistent language selection:

- **English**: Default language for wider accessibility
- **Urdu**: Local language for Vehari city users
- **RTL Support**: Proper right-to-left text layout for Urdu
- **Dynamic Switching**: Users can change language anytime in settings

## 🎨 Design System

### Material Design 3

- **Dynamic Colors**: Adaptive color schemes
- **Custom Gradients**: Brand-specific visual identity
- **Smooth Animations**: Flutter Animate for micro-interactions
- **Lottie Animations**: Engaging loading and success states

### Responsive Design

- **Mobile First**: Optimized for smartphone usage
- **Tablet Support**: Adaptive layouts for larger screens
- **Dark Mode**: Optional dark theme for better UX

## 🔧 Development Workflow

### VS Code Tasks

- **Flutter: Analyze**: Run code analysis
- **Flutter: Build APK**: Build release APK
- **Flutter: Clean**: Clean build cache
- **Flutter: Run**: Run in debug mode

### Code Quality

- **Linting**: Strict analysis options with custom rules
- **Formatting**: Automatic Dart formatting on save
- **Error Lens**: Real-time error highlighting
- **Path Intellisense**: Smart import suggestions

## 🚀 Deployment

### Android Release

```bash
flutter build apk --release
# APK location: build/app/outputs/flutter-apk/app-release.apk
```

### Firebase Deployment

```bash
# Deploy Firestore rules and indexes
firebase deploy --only firestore

# Deploy cloud functions (if any)
firebase deploy --only functions
```

## 📊 Performance Optimization

- **Lazy Loading**: Efficient memory management
- **Image Caching**: Optimized image loading
- **State Management**: Minimal rebuilds with Riverpod
- **Firebase Optimization**: Efficient query patterns

## 🔒 Security Features

- **Authentication**: Secure Firebase Auth implementation
- **Data Validation**: Client and server-side validation
- **Privacy**: GDPR-compliant data handling
- **Secure Storage**: Encrypted local data storage

## 🐛 Troubleshooting

### Common Issues

1. **Flutter not found**

   ```bash
   # Add Flutter to PATH
   export PATH="$PATH:[PATH_TO_FLUTTER_GIT_DIRECTORY]/flutter/bin"
   ```

2. **Firebase connection issues**

   - Verify `google-services.json` is in correct location
   - Check Firebase project configuration
   - Ensure internet connectivity

3. **Maps not loading**
   - Verify Google Maps API key is valid
   - Check API key permissions and billing
   - Ensure Maps SDK is enabled

## 📞 Support

For technical support and feature requests:

- Email: support@localexpress.com
- GitHub Issues: [Project Repository]
- Documentation: [Wiki Pages]

## 📄 License

This project is licensed under the MIT License - see the LICENSE file for details.

---

**Local Express** - Connecting Vehari City through efficient on-demand delivery services.

## 📊 Performance Optimization

- **Lazy Loading**: Efficient memory management
- **Image Caching**: Optimized image loading
- **State Management**: Minimal rebuilds with Riverpod
- **Firebase Optimization**: Efficient query patterns

## 🔒 Security Features

- **Authentication**: Secure Firebase Auth implementation
- **Data Validation**: Client and server-side validation
- **Privacy**: GDPR-compliant data handling
- **Secure Storage**: Encrypted local data storage

## 🐛 Troubleshooting

### Common Issues

1. **Flutter not found**

   ```bash
   # Add Flutter to PATH
   export PATH="$PATH:[PATH_TO_FLUTTER_GIT_DIRECTORY]/flutter/bin"
   ```

2. **Firebase connection issues**

   - Verify `google-services.json` is in correct location
   - Check Firebase project configuration
   - Ensure internet connectivity

3. **Maps not loading**
   - Verify Google Maps API key is valid
   - Check API key permissions and billing
   - Ensure Maps SDK is enabled

## 📞 Support

For technical support and feature requests:

- Email: support@localexpress.com
- GitHub Issues: [Project Repository]
- Documentation: [Wiki Pages]

## 📄 License

This project is licensed under the MIT License - see the LICENSE file for details.

---

**Local Express** - Connecting Vehari City through efficient on-demand delivery services.

## 🚀 Features

### Customer App

- **Shop Discovery**: Browse nearby shops with beautiful card-based UI
- **Easy Ordering**: Simple order form with photo upload support
- **Real-time Tracking**: Live order status updates with push notifications
- **Order History**: Complete history of past orders
- **Multilingual Support**: Urdu and English language support
- **Modern UI**: Material Design with smooth animations and gradients

### Rider App

- **Order Management**: Accept/reject new order requests
- **Live Tracking**: GPS-based location sharing
- **Status Updates**: Mark orders as picked up, delivered, etc.
- **Order History**: Track delivery performance
- **Real-time Notifications**: Instant alerts for new orders

### Admin Dashboard

- **Shop Management**: Add, remove, and manage local shops
- **Order Monitoring**: Real-time order tracking and analytics
- **Rider Management**: Monitor rider performance and availability
- **Customer Management**: View customer order history and data
- **Analytics & Reports**: Comprehensive delivery metrics

## 🛠 Tech Stack

- **Frontend**: Flutter (Cross-platform iOS/Android)
- **Backend**: Firebase (Firestore, Authentication, Cloud Functions)
- **State Management**: Riverpod
- **Navigation**: GoRouter
- **Animations**: Flutter Animate, Lottie
- **Maps**: Google Maps API
- **Notifications**: Firebase Cloud Messaging
- **Storage**: Firebase Storage
- **UI**: Material Design 3 with custom theming

## 📱 Architecture

```
lib/
├── main.dart                 # App entry point
├── models/                   # Data models
│   ├── user_model.dart
│   ├── shop_model.dart
│   └── order_model.dart
├── services/                 # Business logic services
│   ├── firebase_service.dart
│   ├── auth_service.dart
│   ├── order_service.dart
│   └── notification_service.dart
├── providers/                # State management
│   ├── auth_provider.dart
│   ├── order_provider.dart
│   └── locale_provider.dart
├── screens/                  # UI screens
│   ├── auth/
│   ├── customer/
│   ├── rider/
│   └── admin/
├── widgets/                  # Reusable components
├── utils/                    # Utilities and helpers
│   ├── app_theme.dart
│   ├── app_router.dart
│   └── localization.dart
└── assets/                   # Images, animations, fonts
```

## 🔧 Setup Instructions

### Prerequisites

- Flutter SDK (3.5.0 or higher)
- Dart SDK
- Android Studio / VS Code
- Firebase account
- Google Maps API key

### Installation

1. **Clone the repository**

   ```bash
   git clone <repository-url>
   cd local_express
   ```

2. **Install dependencies**

   ```bash
   flutter pub get
   ```

3. **Firebase Setup**

   - Create a new Firebase project
   - Enable Authentication, Firestore, Storage, and Cloud Messaging
   - Download `google-services.json` (Android) and `GoogleService-Info.plist` (iOS)
   - Place them in appropriate directories
   - Update Firebase configuration in `lib/services/firebase_service.dart`

4. **Google Maps Setup**

   - Get Google Maps API key from Google Cloud Console
   - Enable Maps SDK for Android/iOS and Places API
   - Update API key in `android/app/src/main/AndroidManifest.xml`

5. **Run the app**
   ```bash
   flutter run
   ```

## 🎨 Design Features

- **Modern Material Design 3**: Clean, contemporary interface
- **Smooth Animations**: Hero transitions, Lottie animations, and custom effects
- **Responsive Design**: Optimized for various screen sizes
- **Dark/Light Theme**: Automatic theme switching
- **Accessibility**: Full accessibility support with semantic labels
- **Multilingual**: English and Urdu language support

## 🔐 Authentication

The app supports three user roles:

- **Customer**: Browse shops and place orders
- **Rider**: Accept and deliver orders
- **Admin**: Manage the entire system

### Demo Accounts

- Customer: `customer@demo.com` / `123456`
- Rider: `rider@demo.com` / `123456`
- Admin: `admin@demo.com` / `123456`

## 📊 Order Flow

1. **Customer** places order from a shop
2. **Firebase** saves order and sends notifications
3. **Riders** receive notification and can accept
4. **Real-time updates** keep customer informed
5. **Rider** picks up and delivers order
6. **Customer** confirms delivery completion

## 🚀 Future Enhancements

- [ ] Online payment integration (Easypaisa/JazzCash)
- [ ] In-app chat between rider and customer
- [ ] Loyalty points and discount system
- [ ] Shop subscription model
- [ ] Advanced analytics dashboard
- [ ] Voice ordering support
- [ ] AI-powered delivery optimization

## 🛡 Security Features

- Firebase Authentication with secure rules
- Data validation and sanitization
- Secure API communications
- Role-based access control
- Privacy-compliant data handling

## 📱 Supported Platforms

- ✅ Android (API 21+)
- ✅ iOS (iOS 12+)
- 🔄 Web (Admin Dashboard)

## 🤝 Contributing

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Add tests if applicable
5. Submit a pull request

## 📄 License

This project is licensed under the MIT License - see the LICENSE file for details.

## 📞 Support

For support and questions:

- Email: support@localexpress.com
- Phone: +92-xxx-xxxxxxx
- Address: Vehari, Punjab, Pakistan

---

**Local Express** - Delivering Vehari, One Order at a Time 🚚✨
