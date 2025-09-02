import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:movie_mate_app/core/constants/api_constants.dart';
import 'package:movie_mate_app/core/constants/shared_pref_keys.dart';
import 'package:movie_mate_app/core/service/connectivity_service.dart';
import 'package:movie_mate_app/core/service/shared_pref_service.dart';
import 'package:movie_mate_app/features/main/profile/controller/settings_controller.dart';

class ApiService {

  final Dio _dio = Dio();

  final ConnectivityService _connectivityService;
  final Ref _ref;

  ApiService(this._connectivityService, this._ref);


  void initializeInterceptors() {
    _dio.options = BaseOptions(
      baseUrl: dotenv.env[ApiConstants.baseUrl] ?? '',
      headers: ApiConstants.headers,
      connectTimeout: Duration(seconds: ApiConstants.connectTimeoutSec),
      receiveTimeout: Duration(seconds: ApiConstants.receiveTimeoutSec),
      sendTimeout: Duration(seconds: ApiConstants.sendTimeoutSec),
    );

    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {

          final settings = _ref.read(settingsControllerProvider);

          options.queryParameters.addAll({
            'api_key': dotenv.env[ApiConstants.apiKey],
            'language': settings.language,
            'include_adult': settings.adult
          });

          final isNetworkEnabled = await _connectivityService.getIsNetworkEnabled();
          if (!isNetworkEnabled) {
            throw DioException(
              message: 'No Internet Connection!',
              type: DioExceptionType.connectionError,
              requestOptions: options
            );
          }

          debugPrint('Base Url: ${options.baseUrl}');
          debugPrint('Path: ${options.path}');

          handler.next(options);
        },
        onResponse: (response, handler) {
          debugPrint('Response Data: ${response.data}');
          handler.next(response);
        },
        onError: (error, handler) {
          debugPrint('Error Message: ${error.message}');
          debugPrint('Error Response Data: ${error.response?.data}');
          handler.next(error);
        },
      )
    );
  }



  Future<Response> get({
    required String path,
    Map<String, dynamic>? queryParameters,
    CancelToken? cancelToken
  }) async {
    try {
      return await _dio.get(
        path,
        queryParameters: queryParameters,
        cancelToken: cancelToken,
      );
    } catch (e) {
      throw _handleError(e);
    }
  }


  Exception _handleError(exception) {
    if (exception is DioException) {
      switch (exception.type) {
        case DioExceptionType.connectionTimeout:
          return Exception('Connect Timeout Error!');
        case DioExceptionType.sendTimeout:
          return Exception('Send Timeout Error!');
        case DioExceptionType.receiveTimeout:
          return Exception('Receive Timeout Error!');
        case DioExceptionType.badResponse:
          return Exception(_handleErrorStatusCodes(exception.response?.statusCode));
        case DioExceptionType.cancel:
          return Exception('Request Cancelled!');
        case DioExceptionType.unknown:
          return Exception('Unknown Error!');
        default:
          return Exception('Something Went Wrong!');
      }
    } else {
      return exception;
    }
  }

  String _handleErrorStatusCodes(int? statusCode) {
    switch (statusCode) {
      case 400:
        return 'Bad Request!';
      case 404:
        return 'Not Found!';
      case 410:
        return 'Request is no longer available!';
      case 500:
        return 'Internal Server Error!';
      case 503:
        return 'Server is Unavailable!';
      default:
        return 'Something Went Wrong!';
    }
  }

}


final apiServiceProvider = Provider<ApiService>((ref) {
  final connectivityService = ref.read(connectivityServiceProvider);
  final apiService = ApiService(connectivityService, ref);
  apiService.initializeInterceptors(); // Initializing Interceptors;
  return apiService;
});