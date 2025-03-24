// // // import 'package:firebase_messaging/firebase_messaging.dart';

// // class Firebase {
// //   // ignore: constant_identifier_names
// //   static const FirebaseMessaging = FirebaseMessaging.instance;

// //   Future<void> initNotifications() async {
// //     await FirebaseMessaging.requestPermission();
// //     final FCMtoken = await FirebaseMessaging.getToken();
// //     print('FCMtoken: $FCMtoken');
// //   }
// // }

// import 'package:firebase_messaging/firebase_messaging.dart';

// Future<void> handleBackgroundMessage(RemoteMessage message) async {
//   print('Title: ${message.notification?.title}');
//   print('Title: ${message.notification?.body}');
//   print('Payload: ${message.data}');
//   print('Handling a background message: ${message.messageId}');
// }

// class FirebaseApi {
//   final _firebaseMessaging = FirebaseMessaging.instance;

//   Future<void> initNotifications() async {
//     try {
//       // Request permission
//       await _firebaseMessaging.requestPermission(
//         alert: true,
//         badge: true,
//         sound: true,
//       );

//       // Get FCM token
//       final fCMToken = await _firebaseMessaging.getToken();
//       if (fCMToken != null) {
//         print('FCM Token: $fCMToken');
//         FirebaseMessaging.onBackgroundMessage(handleBackgroundMessage);
//       }
//     } catch (e) {
//       print('Error initializing notifications: $e');
//     }
//   }
// }

import 'package:firebase_messaging/firebase_messaging.dart';

Future<void> handleBackgroundMessage(RemoteMessage message) async {
  print('Title: ${message.notification?.title}');
  print('Body: ${message.notification?.body}');
  print('Payload: ${message.data}');
  print('Handling a background message: ${message.messageId}');
}

class FirebaseApi {
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;

  Future<void> initNotifications() async {
    try {
      // Request permission
      NotificationSettings settings =
          await _firebaseMessaging.requestPermission(
        alert: true,
        badge: true,
        sound: true,
      );

      if (settings.authorizationStatus == AuthorizationStatus.authorized) {
        final fCMToken = await _firebaseMessaging.getToken();
        print('FCM Token: $fCMToken');
        FirebaseMessaging.onBackgroundMessage(handleBackgroundMessage);
        print('User granted permission');
      } else {
        print('User denied notification permission');
        return; // Stop execution if permissions are denied
      }

      // Fetch FCM token
      await getToken();
    } catch (e) {
      print('Error initializing notifications: $e');
    }
  }

  Future<void> getToken() async {
    try {
      String? token = await _firebaseMessaging.getToken();
      if (token == null) {
        print('Failed to get FCM Token. Retrying...');
        await Future.delayed(const Duration(seconds: 2));
        token = await _firebaseMessaging.getToken();
      }
      print('FCM Token: $token');
    } catch (e) {
      print('Error fetching token: $e');
    }
  }

  Future<void> refreshToken() async {
    await _firebaseMessaging.deleteToken(); // Delete old token
    String? newToken = await _firebaseMessaging.getToken(); // Get new token
    print("New FCM Token: $newToken");
  }
}
