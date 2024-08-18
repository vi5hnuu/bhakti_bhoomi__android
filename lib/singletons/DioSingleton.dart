import 'dart:io';

import 'package:bhakti_bhoomi/constants/Constants.dart';
import 'package:bhakti_bhoomi/singletons/SecureStorage.dart';
import 'package:dio/dio.dart';
import 'package:go_router/go_router.dart';

class DioSingleton {
  final Dio _dio = Dio();
  final Map<String, Cookie> _cookies = {};
  static final DioSingleton _instance = DioSingleton._();
  final _secureStorage = SecureStorage();

  DioSingleton._() {
    _dio.interceptors
        .add(InterceptorsWrapper(onRequest: (options, handler) async {
      print('REQUEST [${options.method}] => PATH: ${options.path}');

      if (_cookies.isNotEmpty) {
        options.headers['Cookie'] = _cookies.values
            .map((cookie) => '${cookie.name}=${cookie.value}')
            .join('; ');
        // options.headers['Authorization'] = 'Bearer ${_cookies['jwt']?.value}'; //[extract token [not done]]not required as cookies are read first at backend
      }
      return handler.next(options);
    },
        onResponse: (response, handler) async {
      print(
          'RESPONSE [${response.statusCode}] => PATH: ${response.requestOptions.path}');
      List<String> rawCookies = response.headers['set-cookie'] ?? [];

      final cookies = rawCookies.where((cookie) => cookie.startsWith("jwt"));
      if (cookies.isEmpty) return handler.next(response);

      Cookie jwtCookie = Cookie.fromSetCookieValue(cookies.first);
      _cookies.addEntries([MapEntry(Constants.jwtKey, jwtCookie)]);

      //save token ->[at splash screen use this to authenticate if not expired]
      _secureStorage.storage
          .write(key: Constants.jwtKey, value: jwtCookie.toString());

      return handler.next(response);
    },
        onError: (DioException e, handler) {
      print(
          'ERROR [${e.response?.statusCode}] => PATH: ${e.requestOptions.path}');
      return handler.next(e);
    }));
  }

  get dio => _dio;
  void addCookie(String key, Cookie cookie) {
    this._cookies.putIfAbsent(Constants.jwtKey, () => cookie);
  }

  factory DioSingleton() {
    return _instance;
  }
}
