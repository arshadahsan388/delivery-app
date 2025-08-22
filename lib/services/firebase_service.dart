import 'package:firebase_core/firebase_core.dart';

class FirebaseService {
  static Future<void> initialize() async {
    await Firebase.initializeApp(
      options: const FirebaseOptions(
        // You'll need to replace these with your actual Firebase config
        apiKey: "your-api-key",
        authDomain: "your-project.firebaseapp.com",
        projectId: "your-project-id",
        storageBucket: "your-project.appspot.com",
        messagingSenderId: "your-sender-id",
        appId: "your-app-id",
      ),
    );
  }
}

class FirebaseCollections {
  static const String users = 'users';
  static const String shops = 'shops';
  static const String orders = 'orders';
  static const String riders = 'riders';
  static const String notifications = 'notifications';
}
