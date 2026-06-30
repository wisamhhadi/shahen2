import 'dart:convert';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

/// بيانات البطاقة
class BiometricCardData {
  final String fullName;
  final String fatherName;
  final String motherName;
  final String grandFatherName;
  final String gender;
  final String cardNumber;
  final File frontImageFile; // 🔸 صورة الوجه
  final File backImageFile; // 🔸 صورة الظهر
  final String nationality;
  final String fullText;
  final String carNumber;

  BiometricCardData({
    required this.carNumber,
    required this.fullName,
    required this.fatherName,
    required this.motherName,
    required this.gender,
    required this.cardNumber,
    required this.frontImageFile,
    required this.backImageFile,
    required this.nationality,
    required this.fullText,
    required this.grandFatherName,
  });
}

/// ماسح البطاقة
class BiometricCardScanner {
  final ImagePicker _picker = ImagePicker();
  final String apiKey;

  BiometricCardScanner({required this.apiKey});

  Future<BiometricCardData?> scanCard() async {
    try {
      // 🟢 التقاط صورة الوجه الأمامي
      final frontFileX = await _picker.pickImage(source: ImageSource.camera);
      if (frontFileX == null) return null;
      final frontImageFile = await _saveImageLocally(frontFileX);

      // 🟢 التقاط صورة الظهر
      final backFileX = await _picker.pickImage(source: ImageSource.camera);
      if (backFileX == null) return null;
      final backImageFile = await _saveImageLocally(backFileX);

      // 🔍 تحليل صورة الوجه الأمامي
      final imageBytes = await frontImageFile.readAsBytes();
      final base64Image = base64Encode(imageBytes);

      final url = 'https://vision.googleapis.com/v1/images:annotate?key=$apiKey';

      final body = jsonEncode({
        "requests": [
          {
            "image": {
              "content": base64Image
            },
            "features": [
              {
                "type": "TEXT_DETECTION"
              }
            ],
            "imageContext": {
              "languageHints": [
                "ar"
              ]
            }
          }
        ]
      });

      final response = await http.post(Uri.parse(url),
          headers: {
            "Content-Type": "application/json"
          },
          body: body);

      if (response.statusCode != 200) {
        throw Exception("Google API Error: ${response.body}");
      }

      final data = json.decode(response.body);
      final text = _extractTextFromResponse(data);

      return BiometricCardData(
        fullName: _extractField(text, [
          "الاسم الثلاثي",
          "الاسم / ناو",
          "الاسم"
        ]),
        fatherName: _extractField(text, [
          "باوك : "
        ]),
        motherName: _extractField(text, [
          "اسم الأم",
          "الام",
          "الأم"
        ]),
        grandFatherName: _extractField(text, [
          "الجد / بابير",
          "بابير : "
        ]),
        carNumber: _extractField(text, [
          "بغداد خصوصي"
        ]),
        gender: _extractField(text, [
          "الجنس",
          "الجنس / ردكمز"
        ]),
        nationality: _extractField(text, [
          "جمهورية"
        ]),
        cardNumber: _extractNationalCardNumber(text) ?? "",
        fullText: text,
        frontImageFile: frontImageFile,
        backImageFile: backImageFile,
      );
    } catch (e) {
      print("❌ خطأ أثناء المسح: $e");
      return null;
    }
  }

  String? _extractNationalCardNumber(String text) {
    final keywords = [
      "رقم البطاقة الوطنية",
      "رقم البطاقة",
      "الرقم الوطني",
      "National ID",
      "Unified Card No",
      "كارتى نيشتماني",
      "كارتى نيشتمانى",
      "رقم الهوية",
    ];

    for (final keyword in keywords) {
      final index = text.indexOf(keyword);
      if (index != -1) {
        // نأخذ النص بعد الكلمة المفتاحية
        final subText = text.substring(index + keyword.length);
        final match = RegExp(r'\d{8,20}').firstMatch(subText);
        if (match != null) {
          return match.group(0);
        }
      }
    }

    // إذا فشل البحث بجانب الكلمات المفتاحية، جرب استخراج أول رقم طويل في البطاقة
    final fallback = RegExp(r'\d{10,20}').firstMatch(text);
    return fallback?.group(0);
  }

  Future<File> _saveImageLocally(XFile imageFile) async {
    final directory = await getApplicationDocumentsDirectory();
    final fileName = "biometric_${DateTime.now().millisecondsSinceEpoch}.jpg";
    final savedPath = p.join(directory.path, fileName);
    return await File(imageFile.path).copy(savedPath);
  }

  String _extractTextFromResponse(dynamic data) {
    try {
      final responses = data["responses"];
      if (responses != null && responses is List && responses.isNotEmpty && responses[0]["fullTextAnnotation"] != null) {
        return responses[0]["fullTextAnnotation"]["text"];
      }
    } catch (e) {
      print("⚠️ فشل استخراج النص من الرد: $e");
    }
    return "";
  }

  static String _extractField(String text, List<String> keywords) {
    final lines = text.split('\n');
    for (var line in lines) {
      for (var keyword in keywords) {
        if (line.contains(keyword)) {
          final match = RegExp('$keyword[:\\s]*([\\u0600-\\u06FF\\w\\s]+)').firstMatch(line);
          if (match != null && match.groupCount >= 1) {
            final value = match.group(1)?.trim();
            if (value != null && value.isNotEmpty) return value;
          }
          final cleaned = line.replaceAll(keyword, '').replaceAll(':', '').trim();
          if (cleaned.isNotEmpty) return cleaned;
        }
      }
    }
    return "";
  }

  static String _extractPhone(String text) {
    final phoneRegex = RegExp(r'(\+?964\d{10}|\d{11})');
    final match = phoneRegex.firstMatch(text);
    return match?.group(0) ?? "";
  }
}

/// هذه دالة عامة لاستخدام البطاقة الشخصية وجلب البيانات منها
Future<BiometricCardData?> scanBiometricCardWithApiKey(String apiKey) async {
  final scanner = BiometricCardScanner(apiKey: apiKey);
  return await scanner.scanCard();
}

// BiometricCardData? scannedData
/// طريقة استعمال الدالة اعلاه
// نكتبها في اي دالة
// Future<void> scan() async {
//   scannedData = await scanBiometricCardWithApiKey('YOUR_API_KEY');
//   setState(() {}); // تحدث الواجهة عشان تظهر البيانات الجديدة
// }

//apikey YOUR_GOOGLE_API_KEY

///دالة رفع صورة
Future<File?> anypick({bool fromCamera = true}) async {
  final picker = ImagePicker();

  try {
    final pickedFile = await picker.pickImage(
      source: fromCamera ? ImageSource.camera : ImageSource.gallery,
    );
    if (pickedFile == null) return null;

    final appDir = await getApplicationDocumentsDirectory();
    final fileName = "image_${DateTime.now().millisecondsSinceEpoch}.jpg";
    final savedImage = await File(pickedFile.path).copy(p.join(appDir.path, fileName));

    return savedImage; // ✅ File بدلًا من المسار
  } catch (e) {
    print("❌ خطأ أثناء اختيار/حفظ الصورة: $e");
    return null;
  }
}

//طريقة الاستعمال
// String? imagePath;

// Future<void> handlePickImage() async {
//   imagePath = await anypick(fromCamera: true); // أو false للمعرض

//   if (imagePath != null) {
//     print("📷 تم حفظ الصورة في: $imagePath");
//     // يمكنك استخدام imagePath لعرض الصورة، رفعها، إلخ
//   }
// }
