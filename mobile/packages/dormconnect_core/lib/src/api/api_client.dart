import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../utils/constants.dart';
import '../utils/storage.dart';

class ApiClient {
  late final Dio _dio;

  ApiClient({String? baseUrl}) {
    _dio = Dio(BaseOptions(
      baseUrl: baseUrl ?? AppConstants.baseUrl,
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 30),
      headers: {'Content-Type': 'application/json'},
    ));

    _dio.interceptors.add(_AuthInterceptor(_dio));
    _dio.interceptors.add(LogInterceptor(
      requestBody: false,
      responseBody: false,
    ));
  }

  Dio get dio => _dio;

  Future<Response> get(String path, {Map<String, dynamic>? params}) =>
      _dio.get(path, queryParameters: params);

  Future<Response> post(String path, {dynamic data}) =>
      _dio.post(path, data: data);

  Future<Response> put(String path, {dynamic data}) =>
      _dio.put(path, data: data);

  Future<Response> patch(String path, {dynamic data}) =>
      _dio.patch(path, data: data);

  Future<Response> delete(String path) => _dio.delete(path);

  Future<Response> postMultipart(String path, FormData formData) =>
      _dio.post(path, data: formData);
}

class _AuthInterceptor extends Interceptor {
  final Dio dio;
  _AuthInterceptor(this.dio);

  @override
  Future<void> onRequest(
      RequestOptions options, RequestInterceptorHandler handler) async {
    final token = await SecureStorage.read(AppConstants.tokenKey);
    final deviceId = await SecureStorage.read(AppConstants.deviceIdKey);
    if (token != null) {
      options.headers['Authorization'] = 'Bearer $token';
    }
    if (deviceId != null) {
      options.headers['X-Device-ID'] = deviceId;
    }
    handler.next(options);
  }

  @override
  Future<void> onError(
      DioException err, ErrorInterceptorHandler handler) async {
    if (err.response?.statusCode == 401) {
      final refreshed = await _tryRefresh();
      if (refreshed) {
        final token = await SecureStorage.read(AppConstants.tokenKey);
        final deviceId = await SecureStorage.read(AppConstants.deviceIdKey);
        final opts = err.requestOptions;
        if (token != null) opts.headers['Authorization'] = 'Bearer $token';
        if (deviceId != null) opts.headers['X-Device-ID'] = deviceId;
        try {
          final response = await dio.fetch(opts);
          handler.resolve(response);
          return;
        } catch (_) {}
      }
      await SecureStorage.deleteAll();
    }
    handler.next(err);
  }

  Future<bool> _tryRefresh() async {
    try {
      final refresh = await SecureStorage.read(AppConstants.refreshTokenKey);
      if (refresh == null) return false;
      final resp = await dio.post('/api/v1/auth/refresh',
          data: {'refresh_token': refresh});
      final data = resp.data as Map<String, dynamic>;
      await SecureStorage.write(
          AppConstants.tokenKey, data['access_token'] as String);
      if (data['refresh_token'] != null) {
        await SecureStorage.write(
            AppConstants.refreshTokenKey, data['refresh_token'] as String);
      }
      return true;
    } catch (_) {
      return false;
    }
  }
}

final apiClientProvider = Provider<ApiClient>((ref) => ApiClient());
