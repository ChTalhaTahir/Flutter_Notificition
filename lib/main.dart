import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'package:http/http.dart' as http;

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Local Notifications Example',
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final NotificationService notificationService = NotificationService();

  @override
  void initState() {
    super.initState();
    notificationService.initNotification(_onDidReceiveNotificationResponse);
  }

  Future<void> _onDidReceiveNotificationResponse(
      NotificationResponse response) async {
    // Handle notification tap here
  }

  void _showNotifications() async {
    await notificationService.showNotification(
      title: 'Hello, Talha',
      body: 'This is a notification with an image.',
      imageUrl: 'https://via.placeholder.com/300.png',
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('My Notifications'),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: _showNotifications,
          child: Text('Show Notification'),
        ),
      ),
    );
  }
}

class NotificationService {
  final FlutterLocalNotificationsPlugin _notificationsPlugin =
  FlutterLocalNotificationsPlugin();
  void Function(NotificationResponse)? onDidReceiveNotificationResponse;

  FlutterLocalNotificationsPlugin get notificationsPlugin =>
      _notificationsPlugin;

  Future<void> initNotification(
      void Function(NotificationResponse)
      onDidReceiveNotificationResponseCallback) async {
    onDidReceiveNotificationResponse = onDidReceiveNotificationResponseCallback;

    AndroidInitializationSettings initializationSettingsAndroid =
    const AndroidInitializationSettings('logo');

    DarwinInitializationSettings initializationSettingsIOS =
    DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );

    DarwinInitializationSettings initializationSettingsDarwin =
    DarwinInitializationSettings(
      onDidReceiveLocalNotification: (id, title, body, payload) async {},
    );

    var initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsDarwin,
      macOS: initializationSettingsDarwin,
    );

    await _notificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: onDidReceiveNotificationResponse,
    );
  }

  Future<void> showNotification(
      {int id = 0,
        String? title,
        String? body,
        required String imageUrl}) async {
    NotificationDetails notificationDetails =
    await _notificationDetails(imageUrl);
    await _notificationsPlugin.show(
      id,
      title,
      body,
      notificationDetails,
      payload: 'notification_payload',
    );
  }

  Future<NotificationDetails> _notificationDetails(String imageUrl) async {
    File imageFile = await _downloadImage(imageUrl);

    AndroidNotificationDetails androidNotificationDetails =
    AndroidNotificationDetails(
      'com.musicdirector.app',
      'Music_Director',
      importance: Importance.max,
      largeIcon: FilePathAndroidBitmap(imageFile.path),
    );

    DarwinNotificationDetails iosNotificationDetails =
    DarwinNotificationDetails(
        presentAlert: true,
        presentBadge: true,
        presentSound: true,
        presentBanner: true,
        presentList: true,
        attachments: [DarwinNotificationAttachment(imageFile.path)]);

    return NotificationDetails(
      android: androidNotificationDetails,
      iOS: iosNotificationDetails,
    );
  }

  Future<File> _downloadImage(String imageUrl) async {
    final response = await http.get(Uri.parse(imageUrl));
    final Directory tempDir = await getTemporaryDirectory();
    final File file = File('${tempDir.path}/tempImage.png');
    await file.writeAsBytes(response.bodyBytes);
    return file;
  }
}























// import 'package:flutter/material.dart';
// import 'package:flutter_local_notifications/flutter_local_notifications.dart';
// import 'package:path_provider/path_provider.dart';
// import 'dart:io';
// import 'package:http/http.dart' as http;
//
// void main() => runApp(MyApp());
//
// class MyApp extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'Local Notifications Example',
//       home: HomePage(),
//     );
//   }
// }
//
// class HomePage extends StatefulWidget {
//   @override
//   _HomePageState createState() => _HomePageState();
// }
//
// class _HomePageState extends State<HomePage> {
//   final NotificationService notificationService = NotificationService();
//
//   @override
//   void initState() {
//     super.initState();
//     notificationService.initNotification(_onDidReceiveNotificationResponse);
//   }
//
//   Future<void> _onDidReceiveNotificationResponse(
//       NotificationResponse response) async {
//     // Handle notification tap here
//   }
//
//   void _showNotifications() async {
//     await notificationService.showNotification(
//       title: 'Hello, Elisee!',
//       body: 'This is a notification with an image.',
//       imageUrl: 'https://via.placeholder.com/300.png',
//     );
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('My Notifications'),
//       ),
//       body: Center(
//         child: ElevatedButton(
//           onPressed: _showNotifications,
//           child: Text('Show Notification'),
//         ),
//       ),
//     );
//   }
// }
//
// class NotificationService {
//   final FlutterLocalNotificationsPlugin _notificationsPlugin =
//   FlutterLocalNotificationsPlugin();
//   void Function(NotificationResponse)? onDidReceiveNotificationResponse;
//
//   FlutterLocalNotificationsPlugin get notificationsPlugin =>
//       _notificationsPlugin;
//
//   Future<void> initNotification(
//       void Function(NotificationResponse) onDidReceiveNotificationResponseCallback) async {
//     onDidReceiveNotificationResponse =
//         onDidReceiveNotificationResponseCallback;
//
//     AndroidInitializationSettings initializationSettingsAndroid =
//     const AndroidInitializationSettings('logo');
//
//     DarwinInitializationSettings initializationSettingsIOS =
//     DarwinInitializationSettings(
//       requestAlertPermission: true,
//       requestBadgePermission: true,
//       requestSoundPermission: true,
//       onDidReceiveLocalNotification: (id, title, body, payload) async {},
//     );
//
//     DarwinInitializationSettings initializationSettingsDarwin =
//     DarwinInitializationSettings(
//       onDidReceiveLocalNotification: (id, title, body, payload) async {},
//     );
//
//     var initializationSettings = InitializationSettings(
//       android: initializationSettingsAndroid,
//       iOS: initializationSettingsIOS,
//       macOS: initializationSettingsDarwin,
//     );
//
//     await _notificationsPlugin.initialize(
//       initializationSettings,
//
//       onDidReceiveNotificationResponse: onDidReceiveNotificationResponse,
//
//     );
//     await _requestIOSPermissions();
//   }
//
//   Future<void> _requestIOSPermissions() async {
//
//     await _notificationsPlugin
//         .resolvePlatformSpecificImplementation<IOSFlutterLocalNotificationsPlugin>()
//         ?.requestPermissions(
//       sound: true,
//       badge: true,
//       alert: true,
//       provisional: false,);
//   }
//
//   Future<void> showNotification(
//       {int id = 0,
//         String? title,
//         String? body,
//         required String imageUrl}) async {
//     NotificationDetails notificationDetails =
//     await _notificationDetails(imageUrl);
//     await _notificationsPlugin.show(
//       id,
//       title,
//       body,
//       notificationDetails,
//       payload: 'notification_payload',
//     );
//   }
//
//   Future<NotificationDetails> _notificationDetails(String imageUrl) async {
//     File imageFile = await _downloadImage(imageUrl);
//
//     AndroidNotificationDetails androidNotificationDetails =
//     AndroidNotificationDetails(
//       'com.musicdirector.app',
//       'Music_Director',
//       importance: Importance.max,
//       largeIcon: FilePathAndroidBitmap(imageFile.path),
//     );
//
//     DarwinNotificationDetails iosNotificationDetails = DarwinNotificationDetails(
//       presentAlert: true,
//       presentBadge: true,
//       presentSound: true,
//     );
//
//     return NotificationDetails(
//       android: androidNotificationDetails,
//       iOS: iosNotificationDetails,
//     );
//   }
//
//   Future<File> _downloadImage(String imageUrl) async {
//     final response = await http.get(Uri.parse(imageUrl));
//     final Directory tempDir = await getTemporaryDirectory();
//     final File file = File('${tempDir.path}/tempImage.png');
//     await file.writeAsBytes(response.bodyBytes);
//     return file;
//   }
// }














// import 'package:flutter/material.dart';
// import 'package:flutter_local_notifications/flutter_local_notifications.dart';
// import 'package:path_provider/path_provider.dart';
// import 'dart:io';
// import 'package:http/http.dart' as http;
//
// void main() => runApp(MyApp());
//
// class MyApp extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'Local Notifications Example',
//       home: HomePage(),
//     );
//   }
// }
//
// class HomePage extends StatefulWidget {
//   @override
//   _HomePageState createState() => _HomePageState();
// }
//
// class _HomePageState extends State<HomePage> {
//   final NotificationService notificationService = NotificationService();
//
//   @override
//   void initState() {
//     super.initState();
//     notificationService.initNotification(_onDidReceiveNotificationResponse);
//   }
//
//   Future<void> _onDidReceiveNotificationResponse(NotificationResponse response) async {
//     // Handle notification tap here
//   }
//
//   void _showNotifications() async {
//     await notificationService.showNotification(
//       title: 'Hello, Elisee!',
//       body: 'This is a notification with an image.',
//       imageUrl:
//       'https://via.placeholder.com/300.png',
//     );
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('My Notifications'),
//       ),
//       body: Center(
//         child: ElevatedButton(
//           onPressed: _showNotifications,
//           child: Text('Show Notification'),
//         ),
//       ),
//     );
//   }
// }
//
// class NotificationService {
//   final FlutterLocalNotificationsPlugin _notificationsPlugin = FlutterLocalNotificationsPlugin();
//   void Function(NotificationResponse)? onDidReceiveNotificationResponse;
//
//   FlutterLocalNotificationsPlugin get notificationsPlugin => _notificationsPlugin;
//
//   Future<void> initNotification(void Function(NotificationResponse) onDidReceiveNotificationResponseCallback) async {
//     onDidReceiveNotificationResponse = onDidReceiveNotificationResponseCallback;
//
//     AndroidInitializationSettings initializationSettingsAndroid =
//     const AndroidInitializationSettings('logo');
//
//     DarwinInitializationSettings initializationSettingsDarwin = DarwinInitializationSettings(
//       onDidReceiveLocalNotification: (id, title, body, payload) async {},
//     );
//
//     var initializationSettings = InitializationSettings(android: initializationSettingsAndroid, iOS: initializationSettingsDarwin);
//
//     await _notificationsPlugin.initialize(initializationSettings, onDidReceiveNotificationResponse: onDidReceiveNotificationResponse);
//   }
//
//   Future<void> showNotification({int id = 0, String? title, String? body, required String imageUrl}) async {
//     NotificationDetails notificationDetails = await _notificationDetails(imageUrl);
//     await _notificationsPlugin.show(id, title, body, notificationDetails, payload: 'notification_payload',);
//   }
//
//   Future<NotificationDetails> _notificationDetails(String imageUrl) async {
//     File imageFile = await _downloadImage(imageUrl);
//
//     AndroidNotificationDetails androidNotificationDetails = AndroidNotificationDetails(
//       'com.musicdirector.app',
//       'Music_Director',
//       importance: Importance.max,
//       largeIcon: FilePathAndroidBitmap(imageFile.path),
//     );
//
//     return NotificationDetails(
//       android: androidNotificationDetails,
//     );
//   }
//
//   Future<File> _downloadImage(String imageUrl) async {
//     final response = await http.get(Uri.parse(imageUrl));
//     final Directory tempDir = await getTemporaryDirectory();
//     final File file = File('${tempDir.path}/tempImage.png');
//     await file.writeAsBytes(response.bodyBytes);
//     return file;
//   }
// }
//
//
//
//
//
//
//
//
//
//
//
