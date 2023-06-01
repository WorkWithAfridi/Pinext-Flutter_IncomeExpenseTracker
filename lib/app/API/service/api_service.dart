import 'dart:developer';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:pinext/app/API/service/base_service.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';

class ApiService extends BaseService {
  ApiService() {
    final options = BaseOptions(
      contentType: Headers.jsonContentType,
      headers: <String, String>{
        'Accept': 'application/json',
        'Content-Type': 'application/json',
      },
      receiveTimeout: const Duration(seconds: 6),
      connectTimeout: const Duration(seconds: 6),
    );

    _dio = Dio(options);
    _dio.interceptors.add(
      PrettyDioLogger(
        requestHeader: true,
        requestBody: true,
        responseHeader: true,
      ),
    );
  }

  late Dio _dio;

  @override
  Future getDeleteResponse(
    String url, {
    payloadData = '',
  }) async {
    dynamic responseJson;
    Response? response;

    try {
      response = await _dio.delete(
        url,
      );
      responseJson = returnResponse(response);
    } on DioError catch (error) {
      responseJson = returnResponse(error.response!);
    } on SocketException {
      return {
        'error': true,
        'message': 'No internet connection.',
        'data': [],
      };
    } catch (e) {
      if (e is DioError) {
        print("Response at Repo ${e.response?.data["message"]}");
        return {
          'error': true,
          'message': e.response?.data['message'],
          'data': [],
        };
      }
    }

    return responseJson;
  }

  @override
  Future getGetResponse(String url) async {
    dynamic responseJson;

    Response response;
    try {
      response = await _dio.get(url);
      responseJson = returnResponse(response);
    } on DioError catch (error) {
      responseJson = returnResponse(error.response!);
    } on SocketException {
      return {
        'error': true,
        'message': 'No internet connection.',
        'data': [],
      };
    } catch (e) {
      if (e is DioError) {
        print("Response at Repo ${e.response?.data["message"]}");

        return {
          'error': true,
          'message': e.response?.data['message'],
          'data': [],
        };
      }
    }
    return responseJson;
  }

  @override
  Future getGetResponseWithParameters(String url, Map<String, dynamic> parameters) async {
    dynamic responseJson;
    Response response;
    try {
      response = await _dio.get(url, queryParameters: parameters);
      responseJson = returnResponse(response);
    } on DioError catch (error) {
      responseJson = returnResponse(error.response!);
    } on SocketException {
      return {
        'error': true,
        'message': 'No internet connection.',
        'data': [],
      };
    } catch (e) {
      if (e is DioError) {
        print("Response at Repo ${e.response?.data["message"]}");

        return {
          'error': true,
          'message': e.response?.data['message'],
          'data': [],
        };
      }
    }
    return responseJson;
  }

  @override
  Future getPostResponse(String url, data) async {
    dynamic responseJson;
    Response response;
    try {
      response = await _dio.post(
        url,
        data: data,
      );
      responseJson = returnResponse(response);
    } on DioError catch (error) {
      responseJson = returnResponse(error.response!);
    } on SocketException {
      return {
        'error': true,
        'message': 'No internet connection.',
        'data': [],
      };
    } catch (e) {
      if (e is DioError) {
        print("Response at Repo ${e.response?.data["message"]}");
        return {
          'error': true,
          'message': e.response?.data['message'],
          'data': [],
        };
      }
    }
    return responseJson;
  }

  @override
  Future getPutResponse(String url, data) async {
    dynamic responseJson;
    Response response;
    try {
      response = await _dio.put(
        url,
        data: data,
      );
      responseJson = returnResponse(response);
    } on DioError catch (error) {
      responseJson = returnResponse(error.response!);
    } on SocketException {
      return {
        'error': true,
        'message': 'No internet connection.',
        'data': [],
      };
    } catch (e) {
      if (e is DioError) {
        return {
          'error': true,
          'message': e.response?.data['message'],
          'data': [],
        };
      }
    }
    return responseJson;
  }

  @override
  Future getPatchResponse(String url, data) async {
    dynamic responseJson;
    Response response;
    try {
      response = await _dio.patch(
        url,
        data: data,
      );
      responseJson = returnResponse(response);
    } on DioError catch (error) {
      responseJson = returnResponse(error.response!);
    } on SocketException {
      return {
        'error': true,
        'message': 'No internet connection.',
        'data': [],
      };
    } catch (e) {
      if (e is DioError) {
        return {
          'error': true,
          'message': e.response?.data['message'],
          'data': [],
        };
      }
    }
    return responseJson;
  }

  @visibleForTesting
  dynamic returnResponse(Response response) {
    switch (response.statusCode) {
      case 200:
        return response.data;
      case 201:
        return response.data;
      case 400:
        return response.data;
      case 422:
        return response.data;
      case 401:
        return response.data;
      case 403:
        return response.data;
      case 500:
        log('RESPONSE DATA : ${response.data.toString()}');
        return response.data;
      default:
        log('RESPONSE DATA : ${response.data.toString()}');
        return response.data;
    }
  }
}
