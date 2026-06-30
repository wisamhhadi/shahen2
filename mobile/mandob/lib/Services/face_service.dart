import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;

/// كلاس مقارنة الوجهين باستخدام Face++ API
class FaceComparer {
  final String apiKey;
  final String apiSecret;
  final String apiUrl;

  FaceComparer({
    required this.apiKey,
    required this.apiSecret,
    this.apiUrl = 'https://api-us.faceplusplus.com/facepp/v3/compare',
  });

  /// دالة مقارنة صورتين وإرجاع نسبة التطابق (0-100)
  Future<double?> compare({
    required File image1,
    required File image2,
  }) async {
    try {
      final request = http.MultipartRequest('POST', Uri.parse(apiUrl))
        ..fields['api_key'] = apiKey
        ..fields['api_secret'] = apiSecret
        ..files.add(await http.MultipartFile.fromPath('image_file1', image1.path))
        ..files.add(await http.MultipartFile.fromPath('image_file2', image2.path));

      final response = await request.send();
      final responseBody = await response.stream.bytesToString();

      if (response.statusCode == 200) {
        final result = jsonDecode(responseBody);
        final confidence = result['confidence'];
        if (confidence is num) {
          return confidence.toDouble(); // ✅ نسبة التطابق
        }
      } else {
        print('❌ Face++ API Error: $responseBody');
      }
    } catch (e) {
      print('❌ خطأ أثناء مقارنة الصور: $e');
    }

    return null;
  }
}







//طريقة الاستعمال باي كلاس @@@@@@@@@@@@@@@@@@@@@@@@@@@@@
// final faceComparer = FaceComparer(
//   apiKey: 'OuRTfV73o6BvnPR7ljTYAzLEqZrQjgi0',
//   apiSecret: '-3xvT27_JOb07RpgrWyMkfq_hBvCOdPr',
// );

// final confidence = await faceComparer.compare(
//   image1: scannedData!.frontImageFile,
//   image2: profileImage!,
// );

// if (confidence != null) {
//   if (confidence > 80) {
//     Get.snackbar("نجاح", "✅ تطابق جيد: ${confidence.toStringAsFixed(2)}%");
//   } else {
//     Get.snackbar("فشل", "❌ تطابق ضعيف: ${confidence.toStringAsFixed(2)}%");
//   }
// } else {
//   Get.snackbar("خطأ", "حدث خطأ أثناء المقارنة");
// }
//طريقة الاستعمال باي كلاس @@@@@@@@@@@@@@@@@@@@@@@@@@@@