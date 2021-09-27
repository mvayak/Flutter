import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart';

class APIConstant {
  //URL
  static final String apiVersion = "api/v1/";
  static String loginUser = apiVersion + "admins/login";
}

class APIManager {
  static const _baseURL = "maistro.dev.api.unoapp.io";
  final Client _client = Client();

  static var shared = APIManager();

  Future<Response> request(
      {required RequestType requestType,
      required String path,
      Map<String, String>? headers,
      Map<String, dynamic>? params}) async {
    var finaHeaders = {"Content-Type": "application/json"};

    String? token; //here get token from user default
    if (token != null) {
      finaHeaders.addAll({"auth-token": token});
    }

    if (headers != null) {
      finaHeaders.addAll(headers);
    }
    switch (requestType) {
      case RequestType.GET:

        // if (params != null){
        //   final newURI = Uri.http(_baseURL, '/$path', params);
        //   return _client.get(newURI, headers: headers);
        // }else{
        //
        //   return _client.get("$_baseURL/$path");
        return _client.get(Uri.https(_baseURL, '/$path', params));
      // }
      case RequestType.POST:
        return _client.post(Uri.https(_baseURL, '/$path'),
            headers: finaHeaders, body: json.encode(params));

      case RequestType.PUT:
        return _client.put(Uri.https(_baseURL, '/$path'),
            headers: finaHeaders, body: json.encode(params));

      case RequestType.DELETE:
        return _client.delete(Uri.https(_baseURL, '/$path'),
            headers: finaHeaders);
      default:
        return throw RequestTypeNotFoundException(
            "The HTTP request method is not found");
    }
  }

  //common request
  void makeRequest(
      {required String endPoint,
      required RequestType method,
      Map<String, String>? headers,
      Map<String, dynamic>? params,
      required ValueChanged<Result> callback}) async {
    try {
      final response = await request(
          requestType: method,
          path: endPoint,
          headers: headers,
          params: params);

      if (response.statusCode == 200 || response.statusCode == 201) {
        Map<String, dynamic> resp = jsonDecode(response.body);
        callback(Result.success(resp));
      } else {
        Map<String, dynamic> resp = jsonDecode(response.body);
        String msg = resp['msg'];

        if (msg.length > 0 && msg != "Please check required fields") {
          callback(Result.error(msg));
        } else {
          Map<String, dynamic> payload = resp['payload'];
          List<dynamic> arrDetails = payload['details'];
          String message = arrDetails[0]['message'];
          callback(Result.error(message));
        }
      }
    } catch (error) {
      callback(Result.error('Something went wrong'));
    }
  }
}

enum RequestType { GET, POST, DELETE, PUT }

class RequestTypeNotFoundException implements Exception {
  String cause;
  RequestTypeNotFoundException(this.cause);
}

class Result<T> {
  Result._();

  // factory Result.loading(T msg) = LoadingState<T>;

  factory Result.success(T value) = SuccessState<T>;

  factory Result.error(T msg) = ErrorState<T>;
}

class LoadingState<T> extends Result<T> {
  LoadingState(this.msg) : super._();
  final T msg;
}

class ErrorState<T> extends Result<T> {
  ErrorState(this.msg) : super._();
  final T msg;
}

class SuccessState<T> extends Result<T> {
  SuccessState(this.value) : super._();
  final T value;
}
