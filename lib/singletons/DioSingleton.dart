import 'dart:io';

import 'package:bhakti_bhoomi/constants/ApiConstants.dart';
import 'package:bhakti_bhoomi/constants/Constants.dart';
import 'package:bhakti_bhoomi/singletons/GlobalEventDispatcherSingleton.dart';
import 'package:bhakti_bhoomi/singletons/SecureStorage.dart';
import 'package:dio/dio.dart';

class DioSingleton {
  final Dio _dio = Dio();
  final Map<String, Cookie> _cookies = {};
  static final DioSingleton _instance = DioSingleton._();
  final _secureStorage = SecureStorage();
  bool _isRefreshing = false;

  DioSingleton._() {
    _dio.interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) async {
        if (_cookies.isNotEmpty) {
          options.headers['Cookie'] = _cookies.values
              .map((cookie) => '${cookie.name}=${cookie.value}')
              .join('; ');
        }
        return handler.next(options);
      },
      onResponse: (response, handler) async {
        _extractAndStoreCookies(response.headers['set-cookie'] ?? []);
        return handler.next(response);
      },
      onError: (DioException e, handler) async {
        if (e.response?.statusCode == 401 && !_isRefreshing) {
          final refreshed = await _tryRefresh();
          if (refreshed) {
            // Retry original request with updated cookies
            try {
              final opts = e.requestOptions;
              opts.headers['Cookie'] = _cookies.values
                  .map((c) => '${c.name}=${c.value}')
                  .join('; ');
              final retryResponse = await _dio.fetch(opts);
              return handler.resolve(retryResponse);
            } catch (_) {}
          }
          globalEventDispatcher.dispatch(event: LogOutInitEvent());
        }
        return handler.next(e);
      },
    ));
  }

  void _extractAndStoreCookies(List<String> rawCookies) {
    for (final raw in rawCookies) {
      if (raw.startsWith(Constants.jwtKey) || raw.startsWith(Constants.refreshJwtKey)) {
        final cookie = Cookie.fromSetCookieValue(raw);
        _cookies[cookie.name] = cookie;
        _secureStorage.storage.write(key: cookie.name, value: cookie.toString());
      }
    }
  }

  Future<bool> _tryRefresh() async {
    final refreshCookie = _cookies[Constants.refreshJwtKey];
    if (refreshCookie == null) return false;
    _isRefreshing = true;
    try {
      final refreshDio = Dio(); // separate instance — avoids interceptor recursion
      final res = await refreshDio.post(
        '${ApiConstants.baseUrl}/users/refresh',
        options: Options(headers: {
          'Cookie': '${refreshCookie.name}=${refreshCookie.value}',
        }),
      );
      if (res.statusCode == 200) {
        _extractAndStoreCookies(
            (res.headers['set-cookie'] ?? []).cast<String>());
        return true;
      }
    } catch (_) {}
    finally {
      _isRefreshing = false;
    }
    return false;
  }

  get dio => _dio;

  void addCookie(String key, Cookie cookie) {
    _cookies[key] = cookie;
  }

  factory DioSingleton() => _instance;
}
