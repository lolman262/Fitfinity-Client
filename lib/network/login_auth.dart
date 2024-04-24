import 'package:cookie_jar/cookie_jar.dart';
import 'package:dio/dio.dart';
//import 'package:dio/io.dart';
import 'package:dio_cookie_manager/dio_cookie_manager.dart';
import 'package:flutter/foundation.dart';


import 'dio_adapter_stub.dart'
    if (dart.library.io) 'dio_adapter_mobile.dart'
    if (dart.library.js) 'dio_adapter_web.dart';

Future<int> signUserInLogic(hostname, username, password) async {
  print("button pressed");
  var url = '${hostname}/auth/login';
  var headers = {'Content-Type': 'application/json'};
  var body = {
    'username': username,
    'password': password,
  };

  /// https://github.com/cfug/dio/issues/683 https://github.com/cfug/dio/issues/683 https://github.com/cfug/dio/issues/683 https://github.com/cfug/dio/issues/683 https://github.com/cfug/dio/issues/683
  /// ///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
  try {
    BaseOptions options = BaseOptions(
      headers: {
        "Accept": "application/json",
      },
    validateStatus: (int? status) {
      return status != null;
      // return status != null && status >= 200 && status < 300;
    },
    );
    Dio objD = Dio(options);
    //var adapter = BrowserHttpClientAdapter(withCredentials: true);

    if (kIsWeb) {
      print("kIsWeb");
      objD.httpClientAdapter = getAdapter();
    } else {
      print("kIsNotWeb");
      objD.httpClientAdapter = getAdapter();
      final cookieJar = CookieJar();
      objD.interceptors.add(CookieManager(cookieJar));
    }

    //adapter.withCredentials = true;
    // objD.httpClientAdapter = adapter;

    print("before post ${url}");
    var response = await objD.post(
      url,
      options: Options(headers: headers),
      data: body,
    );
    print("after post");
    if (response.statusCode == 200) {
      String rawCookie = response.headers['set-cookie'].toString();

      if (!kIsWeb) {
        var cookieJar = CookieJar();

        RegExp regex = RegExp(r"connect\.sid=([^;]+)");
        Match? match = regex.firstMatch(rawCookie);
        String connectSid = '';
        if (match != null) {
          connectSid = match.group(1)!;
          print("connect.sid value: $connectSid");
        } else {
          print("connect.sid not found in the input string.");
        }
        cookieJar.saveFromResponse(
            Uri.parse(hostname), [Cookie("connect.sid", connectSid)]);
        print(await cookieJar.loadForRequest(Uri.parse(hostname)));
      }
      print(rawCookie);
      return response.statusCode!;
    } else {
      print(response.statusCode);
      return response.statusCode!;
    }
  } catch (e) {
    print(e);
    return 500;
    // Handle error
  }
}
