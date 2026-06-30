import 'dart:convert';
import 'package:http/http.dart';
import 'package:get_storage/get_storage.dart';
import '../../shared/models/interface.dart';

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
      return await get(
        Uri.parse(url),
        headers: {'authorization': 'token $token'},
      );
    }
    return await get(Uri.parse(url));
  }

  dynamic postHttp(String url, Map<String, dynamic> formData) async {
    if (auth) {
      return await post(
        Uri.parse(url),
        body: formData,
        headers: {'authorization': 'token $token'},
      );
    }
    return await post(Uri.parse(url), body: formData);
  }

  dynamic patchHttp(String url, Map<String, dynamic> formData) async {
    if (auth) {
      return await patch(
        Uri.parse(url),
        body: formData,
        headers: {'authorization': 'token $token'},
      );
    }
    var req = await patch(Uri.parse(url), body: formData);

    return req;
  }

  dynamic deleteHttp(String url) async {
    if (auth) {
      return await delete(
        Uri.parse(url),
        headers: {'authorization': 'token $token'},
      );
    }
    return await delete(Uri.parse(url));
  }

  Future<List<ModelInterface>> list(
      String url,
      ModelInterface model, {
        String? searchField,
        String? searchTerm
      }) async {
    final uri = Uri.parse(url);
    final finalUri = (searchTerm != null && searchTerm.isNotEmpty && searchField != null)
        ? uri.replace(queryParameters: {searchField: searchTerm})
        : uri;

    final req = await getHttp(finalUri.toString());
    final res = await jsonDecode(utf8.decode(req.bodyBytes));

    return [for (var object in res) model.fromJson(object)];
  }

  Future<ModelInterface> retrieve(
    String url,
    int id,
    ModelInterface model,
  ) async {
    var req = await getHttp("$url/$id");
    var res = jsonDecode(utf8.decode(req.bodyBytes));
    return model.fromJson(res);
  }

  Future<ModelInterface> retrieveUser(
    String url,
    int id,
    ModelInterface model,
  ) async {
    var req = await getHttp("$url$id/");
    var res = jsonDecode(utf8.decode(req.bodyBytes));
    return model.fromJson(res);
  }

  Future<int> create(String url, Map<String, dynamic> formData) async {
    var req = await postHttp(url, formData);
    print(req.body);
    return req.statusCode;
  }

  Future<dynamic> createRet(String url, Map<String, dynamic> formData) async {
    var req = await postHttp(url, formData);
    return req;
  }

  Future<int> deleteReq(String url, int id) async {
    var req = await deleteHttp('$url/$id');
    return req.statusCode;
  }

  Future<int> login(String url, Map<String, dynamic> formData) async {
    try {
      var req = await postHttp(url, formData);
      if (req.statusCode == 200) {
        var res = jsonDecode(utf8.decode(req.bodyBytes));
        GetStorage().write('token', res['token']['key']);
        GetStorage().write('userId', res['user']['id'] as int);
        GetStorage().write('phone', res['user']['phone'].toString());
        GetStorage().write('name', res['user']['name'].toString());
        GetStorage().write('image', res['user']['image'].toString());
      }
      return req.statusCode;
    } catch (e) {
      return 404;
    }
  }

  Future<bool> logout() async {
    try {
      GetStorage().remove("token");
      GetStorage().remove("userId");
      GetStorage().remove("type");
      return true;
    } catch (e) {
      return false;
    }
  }
}
