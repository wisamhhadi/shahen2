import 'dart:convert';
import 'dart:io';
import 'package:almandobUAE/Services/interface.dart';
import 'package:http/http.dart' as http;
import 'package:get_storage/get_storage.dart';

class Network {
  bool auth;
  String? token;
  int? userId;

  Network({required this.auth}) {
    if (auth) {
      getShared();
    }
  }

  Future<String?> getShared() async {
    token = GetStorage().read('token');
    userId = GetStorage().read('userId');
    return token;
  }

  dynamic getHttp(String url) async {
    if (auth) {
      return await http.get(Uri.parse(url), headers: {
        'authorization': 'token $token'
      });
    }
    return await http.get(Uri.parse(url));
  }


  // دالة postHttp تدعم multipart (رفع ملفات)
  Future<http.StreamedResponse> postHttp(String url, Map<String, dynamic> formData) async {
    var uri = Uri.parse(url);
    var request = http.MultipartRequest('POST', uri);

    // أضف التوكن إذا موجود
    if (auth && token != null && token!.isNotEmpty) {
      request.headers['authorization'] = 'token $token';
    }

    // أضف الحقول والملفات
    for (var entry in formData.entries) {
      var key = entry.key;
      var value = entry.value;

      if (value is File) {
        var multipartFile = await http.MultipartFile.fromPath(key, value.path);
        request.files.add(multipartFile);
      } else if (value is String) {
        request.fields[key] = value;
      } else if (value != null) {
        request.fields[key] = value.toString();
      }
    }

    return await request.send();
  }

  dynamic patchHttp(String url, Map<String, dynamic> formData) async {
    if (auth) {
      return await http.patch(Uri.parse(url), body: formData, headers: {
        'authorization': 'token $token'
      });
    }
    return await http.patch(Uri.parse(url), body: formData);
  }

  dynamic deleteHttp(String url) async {
    if (auth) {
      return await http.delete(Uri.parse(url), headers: {
        'authorization': 'token $token'
      });
    }
    return await http.delete(Uri.parse(url));
  }

  Future<List<ModelInterface>> list(String url, ModelInterface model) async {
    try {
      var req = await getHttp(url);

      if (req.statusCode == 200) {
        var decoded = jsonDecode(utf8.decode(req.bodyBytes));

        List<ModelInterface> data = [];

        // لو كان الناتج قائمة
        if (decoded is List) {
          for (var object in decoded) {
            // تحويل كل عنصر لخريطة من النوع الصحيح
            data.add(model.fromJson(Map<String, dynamic>.from(object)));
          }
        }
        // لو كان الناتج خريطة واحدة (مثلاً object مفرد)
        else if (decoded is Map) {
          data.add(model.fromJson(Map<String, dynamic>.from(decoded)));
        } else {
          print("نوع البيانات غير متوقع: ${decoded.runtimeType}");
        }

        return data;
      } else {
        print("استجابة غير متوقعة: ${req.body}");
        return [];
      }
    } catch (e) {
      print("خطأ أثناء تحميل البيانات: $e");
      return [];
    }
  }

  Future<ModelInterface> retrieve(String url, int id, ModelInterface model) async {
    var req = await getHttp("$url/$id");
    var res = jsonDecode(utf8.decode(req.bodyBytes));
    return model.fromJson(res);
  }

  Future<ModelInterface> retrieveUser(String url, int id, ModelInterface model) async {
    var req = await getHttp("$url/$id");
    var res = jsonDecode(utf8.decode(req.bodyBytes));
    return model.fromJson(res);
  }

  // create أصبحت تعيد int (status code) بعد قراءة الرد كاملاً
  Future<int> create(String url, Map<String, dynamic> formData) async {
    var streamedResponse = await postHttp(url, formData);

    // قراءة الرد كاملاً كنص
    var responseString = await streamedResponse.stream.bytesToString();

    print("Response body: $responseString");

    return streamedResponse.statusCode;
  }

  Future<Map<String, dynamic>> createRet(String url, Map<String, dynamic> formData) async {
    var streamedResponse = await postHttp(url, formData);
    var responseString = await streamedResponse.stream.bytesToString();

    try {
      return {
        'status': streamedResponse.statusCode, // ✅ نضيفها يدويًا
        'data': jsonDecode(responseString),
      };
    } catch (_) {
      return {
        'status': streamedResponse.statusCode,
        'data': responseString,
      };
    }
  }

  Future<int> deleteReq(String url, int id) async {
    var req = await deleteHttp('$url/$id');
    return req.statusCode;
  }

  Future<int> login(String url, Map<String, dynamic> formData) async {
    try {
      var req = await postHttp(url, formData);

      var responseString = await req.stream.bytesToString();
      print(responseString);

      var res = jsonDecode(responseString);

      print(req.statusCode);

      if (req.statusCode == 200) {
        // تحقق هل المستخدم مفعل والحالة مقبولة
        bool isActive = res['user']['is_active'] ?? false;
        String status = (res['user']['status'] ?? '').toString().toLowerCase();

        // if (!isActive) {
        //   print("المستخدم غير مفعل.");
        //   return 403; // رمز مخصص لعدم التفعيل
        // }

        // if (status != 'accepted') {
        //   print("حالة المستخدم غير مقبولة: $status");

        //   return 403; // رمز مخصص لرفض الحالة
        // }

        // إذا كل شيء تمام، خزّن البيانات
        await GetStorage().write('token', res['token']['key']);
        await GetStorage().write('id', res['user']['id'] as int);
        await GetStorage().write('phone', res['user']['phone'].toString());
        await GetStorage().write('image', res['user']['image'].toString());
        await GetStorage().write('country', res['user']['country'].toString());
        await GetStorage().write('province', res['user']['province'].toString());
        await GetStorage().write('status', res['user']['status'].toString());
        await GetStorage().write('name', res['user']['name'].toString());
        await GetStorage().write('is_active', res['user']['is_active'].toString());
        await GetStorage().write('balance', res['user']['balance'].toString());

        return req.statusCode;
      } else {
        return req.statusCode;
      }
    } catch (e) {
      print("خطأ في login: $e");
      return 404;
    }
  }

  Future<bool> logout() async {
    try {
      GetStorage().remove("token");
      GetStorage().remove("id");
      GetStorage().remove("status");
      GetStorage().remove("name");
      GetStorage().remove("country");
      GetStorage().remove("province");
      GetStorage().remove("balance");
      GetStorage().remove("image");
      GetStorage().remove("phone");
      GetStorage().remove("is_active");
      return true;
    } catch (e) {
      return false;
    }
  }
}
