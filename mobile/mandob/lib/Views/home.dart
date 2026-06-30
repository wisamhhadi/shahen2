import 'dart:async';
import 'dart:ffi';
import 'dart:io';
import 'dart:math';
import 'dart:ui' as ui;

import 'package:almandobUAE/Models/CustomReport.dart';
import 'package:almandobUAE/Models/History.dart';
import 'package:almandobUAE/Models/Mandob.dart';
import 'package:almandobUAE/Services/links.dart';
import 'package:almandobUAE/Services/network.dart';
import 'package:almandobUAE/Views/Carrier/add_carrier.dart';
import 'package:almandobUAE/Views/Carrier/carrier.dart';
import 'package:almandobUAE/Views/Driver/add_driver.dart';
import 'package:almandobUAE/Views/Driver/driver.dart';
import 'package:almandobUAE/Views/Goals/addtion_salary.dart';
import 'package:almandobUAE/Views/Goals/month_goals.dart';
import 'package:almandobUAE/Views/Pocket/pocket.dart';
import 'package:almandobUAE/Views/Reports/custom_report.dart';
import 'package:almandobUAE/Views/Reports/daily_report.dart';
import 'package:almandobUAE/Views/Reports/month_report.dart';
import 'package:almandobUAE/Views/Reports/poll.dart';
import 'package:almandobUAE/Views/Reports/sales_report.dart';
import 'package:almandobUAE/Views/Reports/survey_report.dart';
import 'package:almandobUAE/Views/Reports/week_report.dart';
import 'package:almandobUAE/Views/Reports/yearly_report.dart';
import 'package:almandobUAE/Views/Seller/add_seller.dart';
import 'package:almandobUAE/Views/Seller/seller.dart';
import 'package:almandobUAE/Views/Settings/settings.dart';
import 'package:almandobUAE/Views/Settings/support.dart';
import 'package:almandobUAE/Views/User/add_user.dart';
import 'package:almandobUAE/Views/User/user.dart';
import 'package:almandobUAE/Views/account.dart';
import 'package:almandobUAE/Views/barcode.dart';
import 'package:almandobUAE/Views/chat.dart';

import 'package:almandobUAE/Widgets/dialgoCustom.dart';
import 'package:almandobUAE/Widgets/drawer.dart';
import 'package:almandobUAE/Widgets/home_widgets.dart';
import 'package:almandobUAE/main.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';

import 'package:almandobUAE/Widgets/appbar.dart';
import 'package:almandobUAE/Widgets/colors.dart';
import 'package:almandobUAE/Widgets/heading_text.dart';
import 'package:almandobUAE/Widgets/loading.dart';
import 'package:almandobUAE/Views/notification.dart';
import 'package:url_launcher/url_launcher.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  // Add these variables to your state class
  Duration _totalWorkedTime = Duration.zero;
  DateTime? _lastEntryTime;
  DateTime? exitTime;

  bool _isTimerRunning = false;
  Timer? _workTimer;
  String? mandobBalance;
  Color _statusColor = Colors.red;

  String? mandobName;
  String? mandobImage;
  String? mandobShiftstart;
  String? mandobShiftstop;
  String? fcm;
  double? mandobLat;
  double? mandobLang;
  int? mandobRadius;
  int? mandobCargoal;
  int? mandobCompanygoal;
  int? mandobSellerGoal;
  int? mandobDeilverygoal;
  bool _trackingUser = true;
  bool? _isFreeMandob = false;
  bool? isActive = true;
  DateTime? _actualEntryTime; // الوقت الفعلي لدخول المندوب
  Duration _lateDuration = Duration.zero; // المدة المتأخرة
  bool _isLate = false; // هل دخل متأخراً؟
  Timer? _isFreeCheckTimer;

  Completer<GoogleMapController> _controller = Completer();
  LocationData? _currentLocation;
  final Location _location = Location();
  StreamSubscription<LocationData>? _locationSubscription;

  BitmapDescriptor? _truckIcon;
  Set<Circle> _circles = {};
  Set<Marker> _markers = {};

  Timer? _shiftTimer;
  Duration _remainingShiftTime = Duration.zero;
  bool _isShiftActive = false;
  bool _shiftFinishedDialogShown = false;
  bool _isInsideZone = false;
  bool _timerStartedToday = false;
  DateTime? _lastTimerDate;
  Timer? _connectionCheckTimer;
  Timer? _locationCheckTimer;
  Timer? _shiftStatusTimer;
  double? _lastLat, _lastLng;
  final _timeFormat = MaterialLocalizations.of(Get.context!);

  final GetStorage _storage = GetStorage();

  Timer? _lateCheckTimer;
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_){
      _generateTruckIcon();
      _initLocation();

      _locationCheckTimer = Timer.periodic(Duration(seconds: 5), (timer) {
        _checkZoneLocationUpdate();
      });

      _shiftStatusTimer = Timer.periodic(Duration(minutes: 1), (timer) {
        _calculateShiftTime();
      });

      _isFreeCheckTimer = Timer.periodic(Duration(seconds: 5), (timer) {
        _checkIsFreeStatus();
      });

      _connectionCheckTimer = Timer.periodic(Duration(seconds: 5), (timer) {
        _startConnectionChecker();
      });
      Timer.periodic(Duration(seconds: 5), (timer) {
        if (mounted) {
          _checkLateStatus();
        }
      });

      loadBalanceOnly();
      _loadTimerState(); // يتم تحميل الحالة المحفوظة

      // debugShiftData();
    });
  }

  @override
  void _startConnectionChecker() {
    _connectionCheckTimer =
        Timer.periodic(Duration(seconds: 10), (timer) async {
      try {
        var result = await net.list(
            Links.patchMandob(GetStorage().read('id')), Mandob());
        if (result.isNotEmpty) {
          Mandob mandob = result.first as Mandob;
          if (!mounted) return;

          setState(() {
            isActive = mandob.isActive;
          });

          // عرض إشعار إذا تغيرت الحالة
          if (isActive != mandob.isActive) {
            Get.snackbar(
              "تغيير حالة الاتصال",
              isActive == true ? "تم الاتصال بنجاح" : "فقدت الاتصال",
              backgroundColor: isActive == true ? Colors.green : Colors.red,
            );
          }
        }
      } catch (e) {
        print("خطأ في التحقق من حالة الاتصال: $e");
      }
    });
  }

  @override
  void dispose() {
    _locationSubscription?.cancel();
    _shiftTimer?.cancel();
    _locationCheckTimer?.cancel();
    _shiftStatusTimer?.cancel();
    _isFreeCheckTimer?.cancel();
    super.dispose();
  }

  Future<void> _generateTruckIcon() async {
    final icon = await getCustomIconFromWidget(
        Icons.person_pin_circle, const ui.Color.fromARGB(255, 0, 82, 150));
    if (!mounted) return;
    setState(() {
      _truckIcon = icon;
    });
  }

  Future<void> _checkIsFreeStatus() async {
    try {
      var result =
          await net.list(Links.patchMandob(GetStorage().read('id')), Mandob());
      if (result.isNotEmpty) {
        Mandob mandob = result.first as Mandob;
        if (!mounted) return;

        setState(() {
          _isFreeMandob = mandob.isfree;
        });

        // إذا تغيرت الحالة، نعرض إشعاراً للمستخدم
        if (_isFreeMandob != mandob.isfree) {
          Get.snackbar(
            "تغيير الحالة",
            _isFreeMandob == true
                ? "تم تفعيل الوضع الحر"
                : "تم إيقاف الوضع الحر",
            backgroundColor:
                _isFreeMandob == true ? Colors.blue : Colors.orange,
          );
        }
      }
    } catch (e) {
      print("خطأ في التحقق من حالة isFree: $e");
    }
  }

  var net = Network(auth: true);
  Future<void> loadBalanceOnly() async {
    try {
      print(GetStorage().read('id'));
      var result =
          await net.list(Links.patchMandob(GetStorage().read('id')), Mandob());

      if (result.isNotEmpty) {
        Mandob mandob = result.first as Mandob;
        if (!mounted) return;

        setState(() {
          mandobBalance = mandob.balance.toString() ?? '0';
          mandobName = mandob.name?.toString() ?? "0";
          mandobImage = mandob.image.toString();
          mandobLat = double.parse(mandob.latitude!);
          mandobLang = double.parse(mandob.longitude!);
          mandobRadius = mandob.radius;

          mandobCargoal = mandob.car_goal;
          mandobDeilverygoal = mandob.delivery_company_goal;
          mandobCompanygoal = mandob.company_goal;
          mandobSellerGoal = mandob.user_goal;
          mandobShiftstart = mandob.shiftStart ?? '08:00'; // قيمة افتراضية
          mandobShiftstop = mandob.shiftStop ?? 'متوقف'; // قيمة افتراضية
          _isFreeMandob = mandob.isfree;
          isActive = mandob.isActive;

          print("وقت البداية بعد المعالجة: $mandobShiftstart");
          print("وقت النهاية بعد المعالجة: $mandobShiftstop");

          _calculateShiftTime();
        });
      }
      print("${mandobBalance}");
      print("time:::::::::$mandobShiftstart");
    } catch (e) {
      print("${mandobRadius}");
      print("${mandobBalance}");
      print("خطأ في تحميل الرصيد: $e");
    }
  }

  void _calculateShiftTime() {
    if (mandobShiftstart == null || mandobShiftstop == null) return;

    final now = DateTime.now();
    DateTime start = _parseTimeToDateTime(mandobShiftstart!);
    DateTime end = _parseTimeToDateTime(mandobShiftstop!);

    // تعديل خاص للشفت الليلي
    if (end.isBefore(start)) {
      end = end.add(Duration(days: 1));
    }

    Duration remaining;
    if (now.isBefore(end)) {
      remaining = end.difference(now);
    } else {
      remaining = Duration.zero;
    }

    setState(() {
      _remainingShiftTime = remaining;
      _isShiftActive = remaining.inSeconds > 0;
    });

    if (!_isShiftActive && !_shiftFinishedDialogShown) {
      _onShiftFinished();
      _showShiftFinishedDialog();
      _shiftFinishedDialogShown = true;
    }
  }

  DateTime _parseTimeToDateTime(String time) {
    List<String> parts = time.split(':');
    DateTime now = DateTime.now();
    return DateTime(
      now.year,
      now.month,
      now.day,
      int.parse(parts[0]),
      int.parse(parts[1]),
      parts.length > 2 ? int.parse(parts[2]) : 0,
    );
  }

  String _formatTimeOfDay(TimeOfDay time) {
    final now = DateTime.now();
    final dt = DateTime(now.year, now.month, now.day, time.hour, time.minute);
    return _timeFormat.formatTimeOfDay(time, alwaysUse24HourFormat: false);
  }

  DateTime parseTimeToDateTime(String timeString) {
    try {
      final parts = timeString.split(':');
      final now = DateTime.now();

      // إذا كان الوقت يحتوي على ساعات ودقائق وثواني
      if (parts.length >= 3) {
        return DateTime(
          now.year,
          now.month,
          now.day,
          int.parse(parts[0]), // hour
          int.parse(parts[1]), // minute
          int.parse(parts[2]), // second
        );
      }
      // إذا كان الوقت يحتوي على ساعات ودقائق فقط
      else if (parts.length >= 2) {
        return DateTime(
          now.year,
          now.month,
          now.day,
          int.parse(parts[0]), // hour
          int.parse(parts[1]), // minute
        );
      }
      // إذا كان التنسيق غير معروف، نستخدم الوقت الحالي
      return now;
    } catch (e) {
      print("خطأ في تحويل الوقت: $e");
      return DateTime.now();
    }
  }

  TimeOfDay _parseTimeString(String timeString) {
    try {
      // إزالة أي مسافات وحروف غير ضرورية
      String cleanedTime = timeString.trim().toLowerCase();

      // فصل الساعات والدقائق
      List<String> parts = cleanedTime.split(':');
      if (parts.length < 2) return TimeOfDay.now();

      int hour = int.parse(parts[0]);
      int minute = int.parse(parts[1]);

      // معالجة تنسيق 12 ساعة (am/pm)
      if (cleanedTime.contains('pm') && hour < 12) {
        hour += 12;
      } else if (cleanedTime.contains('am') && hour == 12) {
        hour = 0;
      }

      return TimeOfDay(hour: hour, minute: minute);
    } catch (e) {
      print("خطأ في تحويل الوقت: $e");
      return TimeOfDay.now();
    }
  }

  Future<void> _checkZoneLocationUpdate() async {
    try {
      var result =
          await net.list(Links.patchMandob(GetStorage().read('id')), Mandob());

      if (result.isNotEmpty) {
        Mandob mandob = result.first as Mandob;
        double? newLat = double.tryParse(mandob.latitude ?? "");
        double? newLng = double.tryParse(mandob.longitude ?? "");
        int? newRadius = mandob.radius ?? 0;
        String? newShiftStart = mandob.shiftStart;
        String? newShiftStop = mandob.shiftStop;

        bool needsUpdate = false;

        // التحقق من تحديث الموقع أو نصف القطر
        if (_lastLat != newLat ||
            _lastLng != newLng ||
            mandobRadius != newRadius) {
          needsUpdate = true;
        }

        // التحقق من تحديث وقت الشفت
        if (newShiftStart != mandobShiftstart ||
            newShiftStop != mandobShiftstop) {
          setState(() {
            mandobShiftstart = newShiftStart;
            mandobShiftstop = newShiftStop;
          });
          _calculateShiftTime(); // إعادة حساب وقت الشفت
          needsUpdate = true;

          Get.snackbar(
            "تم التحديث",
            "تم تحديث وقت الشفت الجديد: $newShiftStart - $newShiftStop",
            backgroundColor: Colors.green,
          );
        }

        if (needsUpdate) {
          setState(() {
            mandobLat = newLat;
            mandobLang = newLng;
            mandobRadius = newRadius;
            _lastLat = newLat;
            _lastLng = newLng;
          });

          if (_currentLocation != null) {
            _updateLocation(_currentLocation!);
          }
        }
      }
    } catch (e) {
      print("❌ خطأ في التحقق من التحديثات: $e");
    }
  }

  Future<int> fetchTodayCompanyCount(String type) async {
    try {
      var rawList = await net.list(Links.history, History());
      print("Raw list length: ${rawList.length}");

      DateTime today = DateTime.now();
      int count = 0;

      for (var e in rawList) {
        History user;
        if (e is History) {
          user = e;
        } else if (e is Map<String, dynamic>) {
          user = History().fromJson(e as Map<String, dynamic>);
        } else {
          print("Skipped element of unknown type: ${e.runtimeType}");
          continue;
        }

        print(
            "User type: ${user.type}, Mandob: ${user.mandob}, Stored id: ${GetStorage().read('id')}");
        print("Created raw: ${user.created}");

        if (user.created != null) {
          DateTime createdDate;
          try {
            createdDate = DateTime.parse(user.created!).toLocal();
          } catch (ex) {
            print("Failed to parse date: ${user.created} , error: $ex");
            continue;
          }
          print("Parsed createdDate: $createdDate, Today: $today");

          if (user.type == "${type}" &&
              user.mandob.toString() == GetStorage().read('id').toString() &&
              createdDate.year == today.year &&
              createdDate.month == today.month &&
              createdDate.day == today.day) {
            count++;
            print("Match found. Current count: $count");
          }
        }
      }

      print("Total count: $count");
      return count;
    } catch (e) {
      print("Error in fetchTodayCompanyCount: $e");
      return 0;
    }
  }

  Future<BitmapDescriptor> getCustomIconFromWidget(
      IconData iconData, Color color) async {
    final ui.PictureRecorder pictureRecorder = ui.PictureRecorder();
    final Canvas canvas = Canvas(pictureRecorder);
    const double size = 150.0;

    final textPainter = TextPainter(textDirection: TextDirection.ltr);
    textPainter.text = TextSpan(
      text: String.fromCharCode(iconData.codePoint),
      style: TextStyle(
          fontSize: size, fontFamily: iconData.fontFamily, color: color),
    );

    textPainter.layout();
    textPainter.paint(canvas, Offset.zero);

    final img = await pictureRecorder
        .endRecording()
        .toImage(size.toInt(), size.toInt());
    final data = await img.toByteData(format: ui.ImageByteFormat.png);
    return BitmapDescriptor.fromBytes(data!.buffer.asUint8List());
  }

  Future<void> _initLocation() async {
    try {
      // iOS specific: Configure settings BEFORE checking permissions
      if (Platform.isIOS) {
        await _location.changeSettings(
          accuracy: LocationAccuracy.low, // Start with low accuracy
          interval: 5000,
          distanceFilter: 0,
        );
      }

      bool serviceEnabled = await _location.serviceEnabled();
      print("serviceEnabled: $serviceEnabled");

      if (!serviceEnabled) {
        serviceEnabled = await _location.requestService();
        if (!serviceEnabled) return;
      }

      PermissionStatus permissionGranted = await _location.hasPermission();
      print("Permission status: $permissionGranted");

      // iOS specific: Handle deniedForever separately
      if (permissionGranted == PermissionStatus.denied) {
        permissionGranted = await _location.requestPermission();
        if (permissionGranted != PermissionStatus.granted) {
          print("Permission denied: $permissionGranted");
          return;
        }
      }

      if (permissionGranted == PermissionStatus.deniedForever) {
        print("Permission denied forever - open settings");
        // Show dialog to open settings
        return;
      }

      print("before current location");

      // iOS specific: Add delay and timeout
      if (Platform.isIOS) {
        await Future.delayed(Duration(milliseconds: 500));
      }

      _currentLocation = await _location.getLocation().timeout(
        Duration(seconds: 15), // Longer timeout for iOS
        onTimeout: () {
          throw Exception('Location timeout');
        },
      );

      print("currentLocation: $_currentLocation");
      _updateLocation(_currentLocation!);

      _locationSubscription = _location.onLocationChanged.listen((locationData) {
        if (mounted) {
          _updateLocation(locationData);
        }
      });

    } catch (e) {
      print("Location error: $e");

      // iOS fallback: Try with different settings
      if (Platform.isIOS) {
        try {
          print("Trying iOS fallback...");
          await _location.changeSettings(
            accuracy: LocationAccuracy.balanced,
            interval: 10000,
          );

          _currentLocation = await _location.getLocation();
          print("Fallback location: $_currentLocation");
          _updateLocation(_currentLocation!);
        } catch (fallbackError) {
          print("Fallback also failed: $fallbackError");
        }
      }
    }
  }

  bool _isInsideCircle(LatLng point, LatLng circleCenter, double radius) {
    const double metersPerDegree = 111320.0;
    double latDistance =
        (point.latitude - circleCenter.latitude).abs() * metersPerDegree;
    double lngDistance = (point.longitude - circleCenter.longitude).abs() *
        (metersPerDegree * cos(circleCenter.latitude * (pi / 180)));

    double distance = sqrt(pow(latDistance, 2) + pow(lngDistance, 2));
    return distance <= radius;
  }

  void _handleZoneExit() {
    // إذا كان في وضع حر، لا نوقف المؤقت ولكن نسجل الخروج
    if (_isFreeMandob == true) {
      print("الوضع الحر مفعل - سيستمر العد حتى خارج المنطقة");
      return;
    }

    // إذا كان المؤقت يعمل، نوقفه ونحسب الوقت الفعلي
    if (_isTimerRunning) {
      exitTime = DateTime.now();

      // حساب الوقت الفعلي من آخر دخول حتى الخروج
      if (_lastEntryTime != null) {
        final timeInZone = exitTime!.difference(_lastEntryTime!);
        if (timeInZone.inSeconds > 10) {
          _totalWorkedTime += timeInZone;
          print("""
      🕒 وقت الدخول: ${_lastEntryTime}
      🚪 وقت الخروج: $exitTime
      ⏳ الوقت داخل المنطقة: ${timeInZone.inMinutes} دقيقة و ${timeInZone.inSeconds.remainder(60)} ثانية
      """);
        }
      }

      // إيقاف المؤقت
      _workTimer?.cancel();
      _isTimerRunning = false;
      _lastEntryTime = null;

      // حفظ الحالة
      _saveTimerState();

      Get.snackbar(
        "انتباه",
        "تم إيقاف حساب وقت الدوام بسبب الخروج من المنطقة",
        backgroundColor: Colors.orange,
        duration: Duration(seconds: 5),
      );
    }
  }

  double calculateDistanceInMeters(
      double lat1, double lon1, double lat2, double lon2) {
    const double R = 6371000; // نصف قطر الأرض بالمتر
    double dLat = (lat2 - lat1) * (3.141592653589793 / 180);
    double dLon = (lon2 - lon1) * (3.141592653589793 / 180);

    double a = (sin(dLat / 2) * sin(dLat / 2)) +
        cos(lat1 * (3.141592653589793 / 180)) *
            cos(lat2 * (3.141592653589793 / 180)) *
            (sin(dLon / 2) * sin(dLon / 2));

    double c = 2 * atan2(sqrt(a), sqrt(1 - a));

    return R * c;
  }

  void _updateLocation(LocationData newLocation) async {
    if (_truckIcon == null || !mounted) return;
    sendLocation();
    LatLng truckPosition =
        LatLng(newLocation.latitude!, newLocation.longitude!);
    late LatLng companyCenter;

    if (_controller.isCompleted && _trackingUser) {
      final GoogleMapController controller = await _controller.future;
      controller.animateCamera(CameraUpdate.newLatLng(truckPosition));
    }

    if (mandobLat != null && mandobLang != null) {
      companyCenter = LatLng(mandobLat!, mandobLang!);
    } else {
      companyCenter = LatLng(0.0, 0.0);
    }

    bool isInsideMain = _isInsideCircle(
        truckPosition, companyCenter, mandobRadius?.toDouble() ?? 100);

    // إذا كان خارج المنطقة ثم عاد إليها وكان isFree = true
    if (!_isInsideZone && isInsideMain && _isFreeMandob == true) {
      try {
        // تحويل القيمة المنطقية إلى سترينج إذا كان الخادم يتطلب ذلك
        var response =
            await net.patchHttp(Links.patchMandob(GetStorage().read('id')), {
          "is_free": "false", // أرسلها كسلسلة نصية
          // أو استخدم حسب ما يتوقعه الخادم:
          // "isfree": false.toString(),
        });

        if (response != null &&
            (response.statusCode == 200 ||
                response.statusCode == 204 ||
                response.statusCode == 201)) {
          setState(() {
            _isFreeMandob = false;
          });
          print("send attendences : ${response.statusCode}");
          Get.snackbar(
            "تم التحديث",
            "تم تعطيل الوضع الحر تلقائياً عند العودة إلى المنطقة",
            backgroundColor: Colors.green,
          );
        }
      } catch (e) {
        print("خطأ في تحديث حالة isFree: $e");
        // يمكنك إضافة محاولة بديلة إذا فشلت الأولى
        try {
          var response =
              await net.patchHttp(Links.patchMandob(GetStorage().read('id')), {
            "is_free": false, // جرب كقيمة منطقية
          });
          // ... معالجة الاستجابة ...
        } catch (e2) {
          print("المحاولة الثانية فشلت: $e2");
        }
      }
    }

    if (isInsideMain != _isInsideZone) {
      setState(() {
        _isInsideZone = isInsideMain;
      });

      if (isInsideMain && _isDuringWorkHours()) {
        _handleZoneEntry();
      } else if (_isFreeMandob != true) {
        _handleZoneExit();
      }
    }

    // باقي الكود كما هو...
    Set<Circle> newCircles = {};
    if (mandobRadius != null) {
      newCircles = {
        Circle(
          circleId: CircleId('company'),
          center: companyCenter,
          radius: mandobRadius!.toDouble(),
          fillColor: isInsideMain
              ? Colors.green.withOpacity(0.5)
              : Colors.red.withOpacity(0.5),
          strokeColor: isInsideMain ? Colors.green : Colors.red,
          strokeWidth: 2,
        ),
      };
    }

    Set<Marker> newMarkers = {
      Marker(
        markerId: MarkerId('company'),
        position: companyCenter,
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueAzure),
        infoWindow: InfoWindow(title: 'مقر العمل'),
      ),
      Marker(
        markerId: MarkerId('truck'),
        position: truckPosition,
        icon: _truckIcon!,
        rotation: newLocation.heading ?? 0,
        anchor: Offset(0.5, 0.5),
        flat: true,
      ),
    };

    if (!mounted) return;
    double distance = calculateDistanceInMeters(
      truckPosition.latitude,
      truckPosition.longitude,
      companyCenter.latitude,
      companyCenter.longitude,
    );

    if (distance <= (mandobRadius ?? 100)) {
      _statusColor = Colors.green;
    } else if (distance <= (mandobRadius ?? 100) + 50) {
      _statusColor = Colors.yellow;
    } else {
      _statusColor = Colors.red;
    }
    setState(() {
      _currentLocation = newLocation;
      _circles = newCircles;
      _markers = newMarkers;
      _isInsideZone = isInsideMain;
    });

    if (_controller.isCompleted) {
      final GoogleMapController controller = await _controller.future;
      if (_trackingUser) {
        controller.animateCamera(CameraUpdate.newLatLng(truckPosition));
      }
    }
  }
void _checkLateStatus() {
  if (mandobShiftstart == null) return;
  
  final scheduledTime = _parseTimeToDateTime(mandobShiftstart!);
  final now = DateTime.now();
  
  // إذا كان الوقت الحالي بعد وقت الدوام المقرر
  if (now.isAfter(scheduledTime)) {
    // إذا لم يسجل دخول بعد
    if (_actualEntryTime == null) {
      setState(() {
        _lateDuration = now.difference(scheduledTime);
        _isLate = true;
      });
      _saveTimerState();
    } 
    // إذا سجل دخول متأخراً
    else if (_actualEntryTime!.isAfter(scheduledTime)) {
      setState(() {
        _lateDuration = _actualEntryTime!.difference(scheduledTime);
        _isLate = true;
      });
      _saveTimerState();
    }
    // إذا سجل دخول في الوقت المحدد أو قبله
    else {
      setState(() {
        _lateDuration = Duration.zero;
        _isLate = false;
      });
      _saveTimerState();
    }
  } 
  // إذا كان الوقت الحالي قبل وقت الدوام المقرر
  else {
    setState(() {
      _lateDuration = Duration.zero;
      _isLate = false;
    });
    _saveTimerState();
  }
  
  // Debug معلومات
  debugPrint("""
  ====================================
  🕒 فحص التأخير:
  ⏰ وقت الدوام المقرر: ${scheduledTime.hour}:${scheduledTime.minute.toString().padLeft(2, '0')}
  🕒 الوقت الحالي: ${now.hour}:${now.minute.toString().padLeft(2, '0')}
  📅 تاريخ الدخول الفعلي: ${_actualEntryTime?.toString() ?? 'لم يسجل بعد'}
  ⏳ مدة التأخير: ${_lateDuration.inHours} ساعة و ${_lateDuration.inMinutes.remainder(60)} دقيقة
  🚩 حالة التأخير: ${_isLate ? 'متأخر' : 'غير متأخر'}
  ====================================
  """);
}
  void _onShiftFinished() async {
    try {
      if (_shiftFinishedDialogShown) return;

      final now = DateTime.now();
      Duration actualWorkDuration = _totalWorkedTime;

      if (_isLate) {
        actualWorkDuration = _totalWorkedTime - _lateDuration;
        if (actualWorkDuration.isNegative) actualWorkDuration = Duration.zero;
      }
 String formatTime(DateTime? time) {
      if (time == null) return "00:00:00";
      return "${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}:${time.second.toString().padLeft(2, '0')}";
    }
      var status = await net.postHttp(Links.attendence, {
       "attend_time": formatTime(_actualEntryTime), // ← مثل "12:56:00"
       "leave_time": formatTime(_lastEntryTime),
        "work_hour":
            actualWorkDuration.inHours, // أرسل رقمًا بدلاً من نص
        "is_active": "true", // أضف هذا الحقل
        "mandob": GetStorage().read('id'), // استخدم الاسم الصحيح للحقل
        "late_hour": _lateDuration.inHours,
        "day": "${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}"
      });
    print(_lateDuration.inHours + _lateDuration.inMinutes) ; 
      if (status != null &&
          (status.statusCode == 200 || status.statusCode == 201)) {
        _showShiftSummary(actualWorkDuration);
        print("✅ تم إرسال بيانات الحضور بنجاح");
      } else {
        print("❌ فشل في إرسال بيانات الحضور: ${status?.statusCode}");
      }

      _shiftFinishedDialogShown = true;
      _saveTimerState();
    } catch (e) {
      print("⚠️ خطأ في _onShiftFinished: $e");
      Get.snackbar(
        "خطأ",
        "فشل في إرسال بيانات انتهاء الدوام",
        backgroundColor: Colors.red,
      );
    }
  }

  void _checkLateEntry() {
    if (mandobShiftstart == null || _actualEntryTime == null) return;

    try {
      final scheduledTime = _parseTimeToDateTime(mandobShiftstart!);
      if (_actualEntryTime!.isAfter(scheduledTime)) {
        _lateDuration = _actualEntryTime!.difference(scheduledTime);
        _isLate = true;

        print("""
      🚨 تأخير في الحضور
      ⏰ المقرر: $scheduledTime
      🕒 الفعلي: $_actualEntryTime
      ⏳ المدة المتأخرة: ${_lateDuration.inMinutes} دقيقة
      """);
      }
    } catch (e) {
      print("خطأ في حساب التأخير: $e");
    }
  }

  bool _isDuringWorkHours() {
    if (mandobShiftstart == null || mandobShiftstop == null) return false;

    final now = DateTime.now();
    TimeOfDay startTime = _parseTimeString(mandobShiftstart!);
    TimeOfDay endTime = _parseTimeString(mandobShiftstop!);

    final startDateTime = DateTime(
        now.year, now.month, now.day, startTime.hour, startTime.minute);
    final endDateTime =
        DateTime(now.year, now.month, now.day, endTime.hour, endTime.minute);

    // Handle overnight shifts
    if (endDateTime.isBefore(startDateTime)) {
      return now.isAfter(startDateTime) || now.isBefore(endDateTime);
    }

    return now.isAfter(startDateTime) && now.isBefore(endDateTime);
  }

  bool _isSameDay(DateTime a, DateTime b) {
    return a.year == b.year && a.month == b.month && a.day == b.day;
  }

  void _handleZoneEntry() {
    final today = DateTime.now();
    final todayDate = DateTime(today.year, today.month, today.day);
    final now = DateTime.now();
    // التحقق من أن الوقت الحالي ضمن ساعات العمل
    if (!_isDuringWorkHours()) {
      print("خارج وقت العمل - لن يبدأ المؤقت");
      return;
    }
    if (_lastEntryTime == null || !_isSameDay(_lastEntryTime!, now)) {
      _actualEntryTime = now;
      _checkLateEntry(); // حساب التأخير فقط عند الدخول الأول
    }

    // إذا كان المؤقت غير نشط وغير داخل المنطقة
    if (!_isTimerRunning && !_isInsideZone) {
      _actualEntryTime = DateTime.now();
      _checkLateEntry();
      _isInsideZone = true;
      _lastEntryTime = DateTime.now();
      _startWorkTimer();

      Get.snackbar("بدء الدوام", "تم بدء حساب وقت الدوام",
          backgroundColor: Colors.green);
    }
    // إذا كان المؤقت متوقفًا ولكنه لا يزال داخل المنطقة
    else if (!_isTimerRunning && _isInsideZone) {
      _lastEntryTime = DateTime.now();
      _startWorkTimer();

      Get.snackbar("استئناف الدوام", "تم استئناف حساب وقت الدوام",
          backgroundColor: Colors.green);
    }
  }

  void _startWorkTimer() {
    // لا نعيد تعيين _lastEntryTime إذا كان المؤقت يعمل بالفعل
    if (!_isTimerRunning) {
      _lastEntryTime = DateTime.now();
    }

    _isTimerRunning = true;

    _workTimer?.cancel();
    _workTimer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (!mounted) return;

      final currentTime = DateTime.now();
      final workedSinceLastEntry = currentTime.difference(_lastEntryTime!);
      final currentWorkedTime = _totalWorkedTime + workedSinceLastEntry;

      final remainingTime = _calculateTotalShiftDuration() - currentWorkedTime;

      setState(() {
        _remainingShiftTime =
            remainingTime.isNegative ? Duration.zero : remainingTime;
      });

      if (remainingTime <= Duration.zero) {
        timer.cancel();
        _onShiftFinished();
        _showShiftFinishedDialog();
      }

      _saveTimerState();
    });
  }

  Duration _calculateTotalShiftDuration() {
    if (mandobShiftstart == null || mandobShiftstop == null)
      return Duration.zero;

    TimeOfDay startTime = _parseTimeString(mandobShiftstart!);
    TimeOfDay endTime = _parseTimeString(mandobShiftstop!);

    final now = DateTime.now();
    final startDateTime = DateTime(
        now.year, now.month, now.day, startTime.hour, startTime.minute);
    final endDateTime =
        DateTime(now.year, now.month, now.day, endTime.hour, endTime.minute);

    // Handle overnight shifts
    if (endDateTime.isBefore(startDateTime)) {
      return endDateTime.add(Duration(days: 1)).difference(startDateTime);
    }

    return endDateTime.difference(startDateTime);
  }

  Future<void> _saveTimerState() async {
    final now = DateTime.now();
    await _storage.write('lastTimerState', {
      'totalWorkedSeconds': _totalWorkedTime.inSeconds,
      'lastEntryTime': _lastEntryTime?.toIso8601String(),
      'isTimerRunning': _isTimerRunning,
      'remainingSeconds': _remainingShiftTime.inSeconds,
      'savedTime': now.toIso8601String(),
      'isShiftActive': _isShiftActive,
      'isLate': _isLate,
      'lateMinutes': _lateDuration.inHours,
      'actualEntryTime': _actualEntryTime?.toIso8601String(),
      'isInsideZone': _isInsideZone,
    });
  }

  Future<void> _loadTimerState() async {
    final savedData = _storage.read('lastTimerState') as Map<String, dynamic>?;

    if (savedData != null) {
      final savedTime = DateTime.parse(savedData['savedTime'] as String);
      final now = DateTime.now();

      if (savedTime.year == now.year &&
          savedTime.month == now.month &&
          savedTime.day == now.day) {
        setState(() {
          _totalWorkedTime = Duration(
            seconds: savedData['totalWorkedSeconds'] as int? ?? 0,
          );

          _lastEntryTime = savedData['lastEntryTime'] != null
              ? DateTime.parse(savedData['lastEntryTime'] as String)
              : null;

          _isTimerRunning = savedData['isTimerRunning'] as bool? ?? false;
          _remainingShiftTime = Duration(
            seconds: savedData['remainingSeconds'] as int? ?? 0,
          );
          _isShiftActive = savedData['isShiftActive'] as bool? ?? false;
          _isLate = savedData['isLate'] as bool? ?? false;
          _lateDuration = Duration(
            minutes: savedData['lateMinutes'] as int? ?? 0,
          );
          _actualEntryTime = savedData['actualEntryTime'] != null
              ? DateTime.parse(savedData['actualEntryTime'] as String)
              : null;
          _isInsideZone = savedData['isInsideZone'] as bool? ?? false;
        });

        if (_isTimerRunning && _lastEntryTime != null) {
          final pausedDuration = now.difference(_lastEntryTime!);
          _totalWorkedTime += pausedDuration;
          _lastEntryTime = now;
          _startWorkTimer();
        }

        if (_isInsideZone && _isShiftActive && !_isTimerRunning) {
          _lastEntryTime = DateTime.now();
          _startWorkTimer();
        }
      } else {
        _resetTimerForNewDay();
      }
    }
  }

  void _resetTimerForNewDay() {
    setState(() {
      _totalWorkedTime = Duration.zero;
      _lastEntryTime = null;
      _isTimerRunning = false;
      _isLate = false;
      _lateDuration = Duration.zero;
      _actualEntryTime = null;
    });
    _calculateShiftTime();
  }

  void _startShiftTimer() {
    _shiftTimer?.cancel();
    _shiftTimer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (!mounted) return;

      setState(() {
        if (_remainingShiftTime.inSeconds > 0) {
          _remainingShiftTime = _remainingShiftTime - Duration(seconds: 1);
        } else {
          timer.cancel();
          _shiftTimer = null;
          _isShiftActive = false;
          if (!_shiftFinishedDialogShown) {
            _shiftFinishedDialogShown = true;
            _onShiftFinished();
            _showShiftFinishedDialog();
          }
        }
      });
      _saveTimerState();
    });
  }

  void _showShiftFinishedDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: Text('انتهاء الدوام',
            style: TextStyle(fontFamily: 'font', fontWeight: FontWeight.bold)),
        content:
            Text('تم انتهاء دوامك اليوم', style: TextStyle(fontFamily: 'font')),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Text('حسناً', style: TextStyle(fontFamily: 'font')),
          ),
        ],
      ),
    );
  }

  Future<void> sendLocation() async {
    final id = GetStorage().read('id');
    if (id == null ||
        _currentLocation!.latitude == null ||
        _currentLocation!.longitude == null) {
      print("⚠️ بيانات الموقع أو ID غير متوفرة.");

      return;
    }

    var response = await net.patchHttp(Links.patchMandob(id), {
      "latitude2": _currentLocation!.latitude.toString(),
      "longitude2": _currentLocation!.longitude.toString(),
    });

    if (response == null) {
      print("❌ فشل في إرسال الموقع، تحقق من الاتصال.");
    } else if (response.statusCode == 200 || response.statusCode == 204) {
      print("📍 تم تحديث الموقع بنجاح.");
    } else {
      print("❗ حدث خطأ: ${response.statusCode} - ${response.body}");
    }
  }

  Widget _buildGoogleMap() {
    return GoogleMap(
      initialCameraPosition: CameraPosition(
        target:
            LatLng(_currentLocation!.latitude!, _currentLocation!.longitude!),
        zoom: 15,
      ),
      markers: _markers,
      circles: _circles,
      onMapCreated: (GoogleMapController controller) {
        if (!_controller.isCompleted) {
          _controller.complete(controller);
        }
      },
      myLocationEnabled: false,
      myLocationButtonEnabled: false,
      mapType: MapType.normal,
    );
  }

  void _showShiftSummary(Duration actualWorkDuration) {
    String lateMessage = _isLate
        ? 'متأخر ${_lateDuration.inHours} ساعة و ${_lateDuration.inMinutes.remainder(60)} دقيقة'
        : 'لم تتأخر';

    String summary = """
  ملخص الدوام اليوم:
  - وقت العمل الكلي: ${_totalWorkedTime.inHours} ساعة و ${_totalWorkedTime.inMinutes.remainder(60)} دقيقة
  - وقت العمل الفعلي: ${actualWorkDuration.inHours} ساعة و ${actualWorkDuration.inMinutes.remainder(60)} دقيقة
  - حالة التأخير: $lateMessage
  """;

    Get.dialog(
      AlertDialog(
        title:
            Text("ملخص الدوام", style: TextStyle(fontWeight: FontWeight.bold)),
        content: Text(summary),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: Text("حسناً"),
          ),
        ],
      ),
    );
  }

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');

    String hours = twoDigits(duration.inHours);
    String minutes = twoDigits(duration.inMinutes.remainder(60));
    String seconds = twoDigits(duration.inSeconds.remainder(60));

    return "$hours:$minutes:$seconds";
  }

  Widget cartWithouBadge(String image, Color color, String text, bool isBold) {
    // تحقق إذا كان خارج ساعات العمل
    bool isOutsideWorkHours = !_isDuringWorkHours();

    return Card(
      color: _isLate
          ? Colors.orange.withOpacity(0.7)
          : Colors.green.withOpacity(0.7),
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(image, width: 30, height: 30),
            SizedBox(height: 5),
            // عرض رسالة "لم يبدأ وقت العمل" إذا كان خارج الساعات
            isOutsideWorkHours
                ? bodytext(
                    text: "خارج وقت العمل",
                    textColor: Colors.white,
                    fontSize: 13,
                  )
                : bodytext(text: text, textColor: Colors.white),
            if (_isLate)
              bodytext(
                text: "متأخر ${_lateDuration.inHours} ساعة",
                textColor: Colors.white,
                fontSize: 9,
              ),
          ],
        ),
      ),
    );
  }

  Widget cartWithouBadge3(String image, Color color, String text, bool isBold) {
    return Card(
      color: _isLate
          ? Colors.orange.withOpacity(0.7)
          : Colors.green.withOpacity(0.7),
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(image, width: 30, height: 30),
            SizedBox(height: 5),
            bodytext(text: text, textColor: Colors.white),
          ],
        ),
      ),
    );
  }

  Widget cartWithouBadge2(String image, Color color, String text, bool isBold) {
    return Container(
      width: 70,
      height: 70,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: color.withOpacity(0.2),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 4,
            offset: Offset(2, 2),
          ),
        ],
      ),
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.asset(image, width: 24, height: 24),
            SizedBox(height: 4),
            bodytext(
              text: text,
              textAlign: TextAlign.center,
              textColor: Colors.white,
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _openWazeApp() async {
    if (_currentLocation == null) {
      Get.snackbar("خطأ", "لا يمكن تحديد الموقع الحالي",
          backgroundColor: Colors.red);
      return;
    }

    // موقع الوجهة (مثلاً موقع الشركة)
    var destinationLat = mandobLang; // مثال: بغداد
    var destinationLng = mandobLat;
    print("############################");
    print(mandobLang);

    // رابط Waze لفتح التطبيق مباشرة مع الوجهة المحددة
    final url = 'waze://?ll=$mandobLat,$mandobLang&navigate=yes';

    try {
      final Uri uri = Uri.parse(url);

      if (await canLaunchUrl(uri)) {
        await launchUrl(uri, mode: LaunchMode.externalApplication);
      } else {
        // إذا التطبيق غير مثبت، افتح موقع Waze على المتصفح
        final fallbackUrl =
            'https://www.waze.com/ul?ll=$mandobLat,$mandobLang&navigate=yes';
        final fallbackUri = Uri.parse(fallbackUrl);
        await launchUrl(fallbackUri, mode: LaunchMode.externalApplication);
      }
    } catch (e) {
      Get.snackbar(
        "خطأ فادح",
        "تعذر فتح تطبيق Waze.\n${e.toString()}",
        backgroundColor: Colors.red,
        duration: Duration(seconds: 5),
      );
      print("Waze App Error: ${e.toString()}");
    }
  }

  void debugShiftData() {
    print("🚀 بيانات الشفت:");
    print("🟢 وقت البداية: $mandobShiftstart");
    print("🔴 وقت النهاية: $mandobShiftstop");
    print("⏱️ الوقت الحالي: ${DateTime.now()}");
    print("📌 وقت الدخول الفعلي: ${_actualEntryTime ?? 'غير محدد'}");
    print("⏳ المتبقي من الشفت: ${_formatDuration(_remainingShiftTime)}");
    print(
        "⚠️ تأخير: ${_isLate ? 'نعم (${_formatDuration(_lateDuration)})' : 'لا'}");
    print("📡 الشفت نشط: ${_isShiftActive ? 'نعم' : 'لا'}");
  }

  @override
  Widget build(BuildContext context) {
    if (_currentLocation == null) {
      return Scaffold(body: Center(child: ProfessionalLoadingWidget()));
    }

    return Scaffold(
      drawer: Drawer(
        backgroundColor: Colors.white,
        child: ListView(
          physics: BouncingScrollPhysics(),
          padding: EdgeInsets.zero,
          children: [
            UserAccountsDrawerHeader(
              decoration: BoxDecoration(
                color: Colors.white,
              ),
              currentAccountPicture: CircleAvatar(
                backgroundImage: NetworkImage("$mandobImage"),
              ),
              accountName: bodytext(
                text: "${mandobName}",
              ),
              accountEmail: null,
            ),
            InkWell(
                onTap: () {
                  Navigator.pop(context);
                },
                child: drawerItem(Icons.home, 'الصفحة الرئيسية')),
            InkWell(
                onTap: () {
                  Get.to(Account(), transition: Transition.zoom);
                },
                child: drawerItem(Icons.person, 'حسابي')),
            InkWell(
                onTap: () {
                  Get.to(Pocket(), transition: Transition.zoom);
                },
                child: drawerItem(Icons.account_balance_wallet, 'المحفظة')),
            InkWell(
                onTap: () {
                  Get.to(Notifications(), transition: Transition.zoom);
                },
                child: drawerItem(Icons.account_balance_wallet, 'الاشعارات')),
            expansionDrawerItem(Icons.directions_car, 'السائقين', [
              subMenuItem('السائقين', () {
                Get.to(Drivers(), transition: Transition.zoom);
              }),
              subMenuItem('اضافة سائق', () {
                Get.to(AddDriver(), transition: Transition.zoom);
              }),
            ]),
           
            expansionDrawerItem(Icons.insert_chart, 'التقارير', [
              expansionDrawerItem(Icons.insert_chart, ' التقارير الدورية', [
                subMenuItem("تقارير اليومية", () {
                  Get.to(DayReport(reportType: "day"),
                      transition: Transition.zoom);
                }),
                subMenuItem("تقارير الاسبوعية", () {
                  Get.to(WeekReport(reportType: "week"),
                      transition: Transition.zoom);
                }),
                subMenuItem("تقارير الشهرية", () {
                  Get.to(MonthReport(reportType: "month"),
                      transition: Transition.zoom);
                }),
                subMenuItem("تقارير السنوية", () {
                  Get.to(SurveyReportBase(reportType: "year"),
                      transition: Transition.zoom);
                }),
              ]),
              subMenuItem("تقارير الاستبيانية", () {
                Get.to(
                    CustomReports(
                        // reportType: 'custom',
                        ),
                    transition: Transition.zoom);
              }),
              subMenuItem("تقارير المبيعات", () {
                Get.to(SalesReport(), transition: Transition.zoom);
              }),
            ]),
          
            InkWell(
                onTap: () {
                  Get.to(Chat(mandobId: GetStorage().read('id')));
                },
                child: drawerItem(Icons.chat, 'دردشة')),
            InkWell(
                onTap: () {
                  Get.to(Settings(), transition: Transition.zoom);
                },
                child: drawerItem(Icons.settings, 'الإعدادات')),
            InkWell(
                onTap: () {
                  Get.to(Support(), transition: Transition.zoom);
                },
                child: drawerItem(Icons.headset_mic, 'الدعم الفني')),
            InkWell(
                onTap: () async {
                  showCustomAwesomeDialog(
                      context: context,
                      title: "ادارة التطبيق",
                      message: "هل تريد تسجيل الخروج ؟ ",
                      iconHeader: Icons.question_mark_outlined,
                      iconColor: Colors.green,
                      onOkPressed: () async {
                        var res = await net.patchHttp(
                            Links.patchMandob(GetStorage().read('id')),
                            {'is_logged': "false"});

                        await net.logout();

                        Get.off(CheckPage());
                      });
                },
                onTapCancel: () {
                  Get.close(1);
                },
                child: drawerItem(Icons.logout, 'تسجيل الخروج')),
          ],
        ),
      ),
      appBar: CustomAppBar(
        title: "icons/UAElogo.png",
        ishome: true,
        leading: Builder(
          builder: (context) => InkWell(
            onTap: () => Scaffold.of(context).openDrawer(),
            child: Image.asset("icons/drawer.png"),
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(left: 10),
            child: InkWell(
              onTap: () {
                Get.to(Chat(mandobId: GetStorage().read('id')),
                    transition: Transition.leftToRight);
              },
              child: Stack(
                children: [
                  Image.asset("icons/chat.png", width: 35, height: 35),
                  Positioned(
                    right: 0,
                    top: 0,
                    child: Container(
                      padding: const EdgeInsets.all(3),
                      decoration: BoxDecoration(
                        color: Colors.red,
                        shape: BoxShape.circle,
                      ),
                      constraints: const BoxConstraints(
                        minWidth: 18,
                        minHeight: 18,
                      ),
                      child: Center(
                        child: Text(
                          '1', // ← ضع هنا عدد الرسائل الفعلية
                          style: const TextStyle(
                            color: Colors.white,
                            fontFamily: 'font',
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 10),
            child: InkWell(
              onTap: () {
                Get.to(Notifications(), transition: Transition.leftToRight);
              },
              child: Image.asset("icons/bell.png", width: 35, height: 35),
            ),
          ),
        ],
      ),
      body: Stack(
        children: [
          SizedBox(
            height: Get.height,
            child: _buildGoogleMap(),
          ),
          Positioned(
            top: 20,
            left: 0,
            right: 0,
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: GridView.count(
                    physics: NeverScrollableScrollPhysics(),
                    crossAxisCount: 3,
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10,
                    shrinkWrap: true,
                    childAspectRatio: 1.2,
                    children: [
                      InkWell(
                        onTap: () {
                          print(_lateDuration.inHours);
                        },
                        child: cartWithouBadge(
                          "icons/time.png",
                          CustomColors.primary,
                          _isShiftActive
                              ? "${_formatDuration(_remainingShiftTime)}"
                              : "غير نشط",
                          true,
                        ),
                      ),
                      cartWithouBadge3("icons/bag.png", CustomColors.primary,
                          "$mandobBalance", true),
                      InkWell(
                          onTap: () async {
                            final barcodeResult = await Get.to(
                              AdvancedBarcodeScanner(),
                              transition: Transition.rightToLeft,
                              duration: Duration(milliseconds: 500),
                            );
                            if (barcodeResult != null) {
                              Get.snackbar(
                                'تم حفظ الباركود',
                                barcodeResult,
                                backgroundColor: CustomColors.primary,
                                colorText: Colors.white,
                              );
                            }
                          },
                          child: cartWithouBadge3("icons/barcode.png",
                              CustomColors.primary, "الباركود", false)),
                      // InkWell(
                      //     onTap: () async {
                      //       int count =
                      //           await fetchTodayCompanyCount("deliverycompany");
                      //       print(count);
                      //       showDialog(
                      //         context: context,
                      //         builder: (context) {
                      //           return AlertDialog(
                      //             titleTextStyle: TextStyle(
                      //                 fontFamily: "font",
                      //                 color: Colors.black,
                      //                 fontSize: 16),
                      //             shape: RoundedRectangleBorder(
                      //                 borderRadius: BorderRadius.circular(20)),
                      //             title: Center(
                      //                 child: Text("بيانات الناقل",
                      //                     style: TextStyle(
                      //                         fontWeight: FontWeight.bold))),
                      //             content: Column(
                      //               mainAxisSize: MainAxisSize.min,
                      //               children: [
                      //                 _infoRow("اليومي", count),
                      //                 _infoRow("المتبقي",
                      //                     mandobDeilverygoal! - count),
                      //                 SizedBox(height: 20),
                      //                 ElevatedButton(
                      //                   style: ElevatedButton.styleFrom(
                      //                     backgroundColor: CustomColors.primary,
                      //                     shape: RoundedRectangleBorder(
                      //                         borderRadius:
                      //                             BorderRadius.circular(10)),
                      //                   ),
                      //                   onPressed: () {
                      //                     Navigator.of(context).pop();
                      //                   },
                      //                   child: bodytext(
                      //                     text: "إغلاق",
                      //                     textColor: Colors.white,
                      //                   ),
                      //                 )
                      //               ],
                      //             ),
                      //           );
                      //         },
                      //       );
                      //     },
                      //     child: cartWithouBadge2("icons/man2.png",
                      //         CustomColors.primary, "الناقل", true)),
                      // InkWell(
                      //     onTap: () async {
                      //       int count = await fetchTodayCompanyCount("seller");
                      //       print(count);
                      //       showDialog(
                      //         context: context,
                      //         builder: (context) {
                      //           return AlertDialog(
                      //             titleTextStyle: TextStyle(
                      //                 fontFamily: "font",
                      //                 color: Colors.black,
                      //                 fontSize: 16),
                      //             shape: RoundedRectangleBorder(
                      //                 borderRadius: BorderRadius.circular(20)),
                      //             title: Center(
                      //                 child: Text("بيانات التجار",
                      //                     style: TextStyle(
                      //                         fontWeight: FontWeight.bold))),
                      //             content: Column(
                      //               mainAxisSize: MainAxisSize.min,
                      //               children: [
                      //                 _infoRow("اليومي", count),
                      //                 _infoRow(
                      //                     "المتبقي", mandobSellerGoal! - count),
                      //                 SizedBox(height: 20),
                      //                 ElevatedButton(
                      //                   style: ElevatedButton.styleFrom(
                      //                     backgroundColor: CustomColors.primary,
                      //                     shape: RoundedRectangleBorder(
                      //                         borderRadius:
                      //                             BorderRadius.circular(10)),
                      //                   ),
                      //                   onPressed: () {
                      //                     Navigator.of(context).pop();
                      //                   },
                      //                   child: bodytext(
                      //                     text: "إغلاق",
                      //                     textColor: Colors.white,
                      //                   ),
                      //                 )
                      //               ],
                      //             ),
                      //           );
                      //         },
                      //       );
                      //     },
                      //     child: cartWithouBadge2("icons/truck.png",
                      //         CustomColors.primary, "التاجر", true)),
                      // InkWell(
                      //     onTap: () async {
                      //       int count = await fetchTodayCompanyCount("car");
                      //       print(count);
                      //       showDialog(
                      //         context: context,
                      //         builder: (context) {
                      //           return AlertDialog(
                      //             titleTextStyle: TextStyle(
                      //                 fontFamily: "font",
                      //                 color: Colors.black,
                      //                 fontSize: 16),
                      //             shape: RoundedRectangleBorder(
                      //                 borderRadius: BorderRadius.circular(20)),
                      //             title: Center(
                      //                 child: Text("بيانات المركبات",
                      //                     style: TextStyle(
                      //                         fontWeight: FontWeight.bold))),
                      //             content: Column(
                      //               mainAxisSize: MainAxisSize.min,
                      //               children: [
                      //                 _infoRow("اليومي", count),
                      //                 _infoRow(
                      //                     "المتبقي", mandobCargoal! - count),
                      //                 SizedBox(height: 20),
                      //                 ElevatedButton(
                      //                   style: ElevatedButton.styleFrom(
                      //                     backgroundColor: CustomColors.primary,
                      //                     shape: RoundedRectangleBorder(
                      //                         borderRadius:
                      //                             BorderRadius.circular(10)),
                      //                   ),
                      //                   onPressed: () {
                      //                     Navigator.of(context).pop();
                      //                   },
                      //                   child: bodytext(
                      //                     text: "إغلاق",
                      //                     textColor: Colors.white,
                      //                   ),
                      //                 )
                      //               ],
                      //             ),
                      //           );
                      //         },
                      //       );
                      //     },
                      //     child: cartWithouBadge2("icons/truck.png",
                      //         CustomColors.primary, "المركبات", true)),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            top: 25,
            right: 10,
            child: CircleAvatar(
              maxRadius: 15,
              backgroundColor: _statusColor,
            ),
          ),
          Positioned(
            bottom: 20,
            left: 20,
            child: Column(
              children: [
                FloatingActionButton(
                  heroTag: "openWaze",
                  mini: true,
                  backgroundColor: Colors.white,
                  onPressed: _openWazeApp,
                  child: Image.asset("icons/waze.png",
                      width: 24,
                      height: 24), // تأكد من وجود أيقونة waze في مجلد assets
                ),
                FloatingActionButton(
                  heroTag: "goToCompany",
                  mini: true,
                  backgroundColor: Colors.white,
                  onPressed: () async {
                    if (!_controller.isCompleted) return;
                    final controller = await _controller.future;

                    if (mandobLat != null && mandobLang != null) {
                      _trackingUser = false;
                      setState(() {});
                      await controller.animateCamera(
                        CameraUpdate.newCameraPosition(
                          CameraPosition(
                            target: LatLng(mandobLat!, mandobLang!),
                            zoom: 17,
                          ),
                        ),
                      );
                      Get.snackbar("انتقال", "تم الانتقال إلى موقع العمل",
                          backgroundColor: Colors.green,
                          colorText: Colors.white);
                    } else {
                      Get.snackbar("خطأ", "موقع الشركة غير متاح حالياً",
                          backgroundColor: Colors.red, colorText: Colors.white);
                    }
                  },
                  child: Icon(Icons.business, color: CustomColors.primary),
                ),
                SizedBox(height: 10),
                FloatingActionButton(
                  heroTag: "backToUser",
                  mini: true,
                  backgroundColor: Colors.white,
                  onPressed: () async {
                    if (!_controller.isCompleted) return;
                    final controller = await _controller.future;

                    if (_currentLocation != null) {
                      _trackingUser = true;
                      setState(() {});
                      await controller.animateCamera(
                        CameraUpdate.newCameraPosition(
                          CameraPosition(
                            target: LatLng(_currentLocation!.latitude!,
                                _currentLocation!.longitude!),
                            zoom: 17,
                          ),
                        ),
                      );
                      Get.snackbar("تتبع", "تم الرجوع لتتبع موقعك الحالي",
                          backgroundColor: Colors.blue,
                          colorText: Colors.white);
                    } else {
                      Get.snackbar("خطأ", "الموقع الحالي غير متوفر",
                          backgroundColor: Colors.red, colorText: Colors.white);
                    }
                  },
                  child: Icon(Icons.person_pin, color: CustomColors.primary),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

Widget _infoRow(String label, int value) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 4.0),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        bodytext(
          text: label,
        ),
        bodytext(
          text: value.toString(),
          textColor: Colors.black,
        ),
      ],
    ),
  );
}

Future<void> _launchUrl(String urls) async {
  Uri url = Uri.parse(urls);
  if (!await launchUrl(url)) {
    throw Exception('Could not launch $url');
  }
}
