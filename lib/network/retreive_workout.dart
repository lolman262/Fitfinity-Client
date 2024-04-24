import 'dart:convert';

import 'package:cookie_jar/cookie_jar.dart';
import 'package:dio/dio.dart';

import 'package:dio_cookie_manager/dio_cookie_manager.dart';
import 'package:flutter/foundation.dart';
import 'package:http_parser/http_parser.dart';
import 'package:image_picker/image_picker.dart';

import 'dio_adapter_stub.dart'
    if (dart.library.io) 'dio_adapter_mobile.dart'
    if (dart.library.js) 'dio_adapter_web.dart';

//Future<int> registerLogic(hostname, username, password, gender, age, weight, Uint8List objImage) async {
Future<List<dynamic>> retreiveWorkoutPlanLogic(hostname) async {
 // print("button pressed");
  var url = '${hostname}/workout/retrieve';

  //print(objImage);

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
      //print("kIsWeb");
      objD.httpClientAdapter = getAdapter();
    } else {
      //print("kIsNotWeb");
      objD.httpClientAdapter = getAdapter();
      final cookieJar = CookieJar();
      objD.interceptors.add(CookieManager(cookieJar));
    }

    //adapter.withCredentials = true;
    // objD.httpClientAdapter = adapter;
    // print(formData.fields);
    //print("before get ${url}");
    var response = await objD.request(
      url,
    );
    //print("after get");
    if (response.statusCode == 200) {
     // print(response.data);
     List<dynamic> responseBody = response.data;
  //print(responseBody);


   // List<dynamic> data = responseBody as List;
      return responseBody;
    } else {
     // print(response.data);
      //print(response.statusCode);
      return [response.statusCode];
    }
  } catch (e) {
   // print(e);

    print("error 500");
    return [500];
    // Handle error
  }
}
