import 'dart:io';
import 'package:almandobUAE/Models/Mandob.dart';
import 'package:almandobUAE/Services/links.dart';
import 'package:almandobUAE/Views/Account.dart';
import 'package:almandobUAE/Views/Auth/language.dart';
import 'package:almandobUAE/Views/Auth/login.dart';
import 'package:almandobUAE/Views/Auth/otp.dart';
import 'package:almandobUAE/Views/Auth/signup.dart';
import 'package:almandobUAE/Views/Auth/submited.dart';
import 'package:almandobUAE/Views/Carrier/add_carrier.dart';
import 'package:almandobUAE/Views/Carrier/carrier.dart';
import 'package:almandobUAE/Views/Driver/add_driver.dart';
import 'package:almandobUAE/Views/Driver/add_driver_car.dart';
import 'package:almandobUAE/Views/Driver/driver.dart';
import 'package:almandobUAE/Views/Goals/addtion_salary.dart';
import 'package:almandobUAE/Views/Goals/month_goals.dart';
import 'package:almandobUAE/Views/Pocket/add_money.dart';
import 'package:almandobUAE/Views/Pocket/pay_visa.dart';
import 'package:almandobUAE/Views/Pocket/pocket.dart';
import 'package:almandobUAE/Views/Reports/custom_report.dart';
import 'package:almandobUAE/Views/Reports/daily_report.dart';
import 'package:almandobUAE/Views/Reports/sales_report.dart';
import 'package:almandobUAE/Views/Reports/survey_report.dart';
import 'package:almandobUAE/Views/Seller/add_seller.dart';
import 'package:almandobUAE/Views/Settings/about_us.dart';
import 'package:almandobUAE/Views/Settings/privcy.dart';
import 'package:almandobUAE/Views/Settings/settings.dart';
import 'package:almandobUAE/Views/User/add_user.dart';
import 'package:almandobUAE/Views/barcode.dart';
import 'package:almandobUAE/Views/home.dart';
import 'package:almandobUAE/Views/Seller/seller.dart';
import 'package:almandobUAE/Views/User/user.dart';
import 'package:almandobUAE/Views/notification.dart';
import 'package:almandobUAE/Views/splash.dart';
import 'package:almandobUAE/Views/Settings/support.dart';
import 'package:almandobUAE/Widgets/colors.dart';
import 'package:almandobUAE/Widgets/loading.dart';
import 'package:almandobUAE/test.dart';
import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:url_launcher/url_launcher.dart';
import 'firebase_options.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  AwesomeNotifications().createNotification(
    content: NotificationContent(
      id: 1,
      channelKey: 'basic_channel',
      title: message.notification?.title ?? 'No Title',
      body: message.notification?.body ?? 'No Body',
    ),
  );
}

class NotificationService {
  static final FirebaseMessaging _messaging = FirebaseMessaging.instance;

  static Future<void> initialize() async {
    // Request permission first
    NotificationSettings settings = await _messaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      // Wait for APNS token on iOS
      if (Platform.isIOS) {
        String? apnsToken = await _messaging.getAPNSToken();
        if (apnsToken != null) {
          print("APNS Token: $apnsToken");
          // Now safe to get FCM token
          await getFCMToken();
        } else {
          // Wait and retry
          await Future.delayed(Duration(seconds: 3));
          apnsToken = await _messaging.getAPNSToken();
          if (apnsToken != null) {
            await getFCMToken();
          }
        }
      } else {
        // Android - can get FCM token directly
        await getFCMToken();
      }
    }
  }

  static Future<void> getFCMToken() async {
    try {
      String? fcmToken = await _messaging.getToken();
      print("FCM Token: $fcmToken");
      // Send token to your server
    } catch (e) {
      print("Error getting FCM token: $e");
    }
  }
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await GetStorage.init();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await NotificationService.initialize();
  AwesomeNotifications().initialize(
    null,
    [
      NotificationChannel(
        channelKey: 'basic_channel',
        channelName: 'Basic Notifications',
        channelDescription: 'Notification channel for basic tests',
        defaultColor: Colors.teal,
        importance: NotificationImportance.High,
        channelShowBadge: true,
      )
    ],
    debug: true,
  );
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  runApp(
    MyApp(),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      locale: const Locale('ar'), //  اللغة العربية
      supportedLocales: const [
        Locale('ar'), //  تدعم العربية فقط
      ],
      theme: ThemeData(
        primaryColor: CustomColors.primary,
        scaffoldBackgroundColor: Colors.white,
        appBarTheme: AppBarTheme(
          backgroundColor: CustomColors.primary,
          foregroundColor: Colors.white,
          elevation: 0,
        ),
        floatingActionButtonTheme: FloatingActionButtonThemeData(
          backgroundColor: CustomColors.primary,
        ),
        textButtonTheme: TextButtonThemeData(
          style: TextButton.styleFrom(
            foregroundColor: CustomColors.primary,
          ),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: CustomColors.primary,
            foregroundColor: Colors.white,
          ),
        ),
        colorScheme: ColorScheme.fromSeed(
          seedColor: CustomColors.primary,
        ).copyWith(
          primary: CustomColors.primary,
          secondary: CustomColors.primary,
        ),
      ),
      localizationsDelegates: [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      title: 'almandob',
      debugShowCheckedModeBanner: false,
      home: Splash(),
    );
  }
}

class SimpleBarcodeScannerPage {}

class CheckPage extends StatefulWidget {
  const CheckPage({super.key});

  @override
  State<CheckPage> createState() => _CheckPageState();
}

class _CheckPageState extends State<CheckPage> {
  final box = GetStorage();

  @override
  void initState() {
    super.initState();
    checkUser();
  }

  Future<void> checkUser() async {
    await Future.delayed(Duration(seconds: 1)); // تأخير بسيط لشاشة سبلاش

    String? token = GetStorage().read('token');
    int? id = GetStorage().read('id');

    print("🔐 Token: $token");

    if (token != null && token.isNotEmpty && id != null) {
      try {
        // ✅ اجلب المستخدم من السيرفر
        Mandob mandob =
            await net.retrieveUser(Links.createMandob, id, Mandob()) as Mandob;

        String status = mandob.status?.toLowerCase() ?? '';
        print("📌 Status from API: $status");


        if (status == "accepted") {
          Get.offAll(() => Home()); // ✅ مقبول
        } else if (status == "pending") {
          Get.offAll(() => Submited()); // ⏳ قيد المراجعة
        } else {
          Get.offAll(() => Login()); // ❌ حالة غير صالحة
        }
      } catch (e) {
        print("❌ خطأ أثناء جلب المستخدم: $e");
        Get.offAll(() => Login()); // ❌ فشل في الجلب
      }
    } else {
      Get.offAll(() => Login()); // ❌ لا يوجد توكن
    }
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(child: ProfessionalLoadingWidget()),
    );
  }
}
