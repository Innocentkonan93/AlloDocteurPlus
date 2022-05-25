import 'package:dio/dio.dart';

class HttpService {
  late Dio _dio;

  HttpService() {
    _dio = Dio(
      BaseOptions(baseUrl: 'https://allodocteurplus.com/api/'),
    );
    initilizeInterceptors();
  }

  // method to GET request
  Future<Response> getRequest(String endPoint) async {
    Response response;

    try {
      response = await _dio.get(endPoint);
    } on DioError catch (e) {
      print(e.message);
      throw Exception(e);
    }

    return response;
  }

  initilizeInterceptors() {
    _dio.interceptors.add(
      InterceptorsWrapper(onError: (error, errorHandler) {
        print(error.message);
      }, onRequest: (request, requestHandle) {
        print("${request.method} ${request.path}");
      }, onResponse: (response, responseHandler) {
        print(response.data);
      }),
    );
  }
}
