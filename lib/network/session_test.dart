import 'package:cookie_jar/cookie_jar.dart';
import 'package:dio/dio.dart';
import 'package:dio_cookie_manager/dio_cookie_manager.dart';
import 'package:flutter/foundation.dart';
import 'dio_adapter_stub.dart'
    if (dart.library.io) 'dio_adapter_mobile.dart'
    if (dart.library.js) 'dio_adapter_web.dart';

void testSessionAPI(String hostname) async {
  var url = '${hostname}/api/data';
  var headers = {'Content-Type': 'application/json'};

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

          final cookieJar = CookieJar();
      objD.interceptors.add(CookieManager(cookieJar));
    objD.httpClientAdapter = getAdapter();
     print(cookieJar.loadForRequest(Uri.parse(hostname)));
  }

  // adapter.withCredentials = true;
  // _d.httpClientAdapter = adapter;

  var response = await objD.get(
    url,
    options: Options(headers: headers),
  );

  if (response.statusCode == 200) {
    //showToast(response.data.toString());
    print(response.data);
  } else if (response.statusCode == 401) {
    print(response.statusCode);
   // showToast('Unauthorized');
  } else {
   // showToast(response.statusCode.toString());
    print(response.statusCode);
    //throw Exception('Failed to create session');
  }
}
