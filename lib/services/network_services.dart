import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:mvvm_architecture/constant/app_constant.dart';
import 'package:mvvm_architecture/services/app_exceptions.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class NetworkService {
  final String domainUrl = "your Api main url";
  final String websocketForChat = "wss://your Api main url";
  final String chatsListWebSocket = "wss://your Api main url";

  getImageFileFromLocalPath(String path) async {
    final file = File(path);
    return file;
  }

  Future<String?> get authorizationToken async {
    final prefs = await SharedPreferences.getInstance();
    String authToken = prefs.getString(AppConstants.authKey) ?? '';
    if (authToken.length > 4) {
      return 'Bearer $authToken';
    }
    return null;
  }

  Future<Map<String, String>> get headers async {
    final prefs = await SharedPreferences.getInstance();
    String authToken = prefs.getString(AppConstants.authKey) ?? '';
    debugPrint('*** \n authToken ===> $authToken \n');
    Map<String, String> headers = {};

    if (authToken.length > 4) {
      headers = {
        'Authorization': 'Bearer $authToken',
        'Accept': 'application/json',
        'Content-Type': 'application/json'
      };
    } else {
      headers = {
        'Accept': 'application/json',
        'Content-Type': 'application/json'
      };
    }
    return headers;
  }

  Uri getFullUrl(String url) {
    String fullPath = domainUrl + url;
    debugPrint('*** Complete Url Path ***** \n $fullPath \n');

    return Uri.parse(fullPath);
  }

  Future getResponse(String url) async {
    dynamic responseJson;
    try {
      debugPrint('***GET Url ==> $url \n');

      final response = await http.get(
        getFullUrl(url),
        headers: await headers,
      );

      debugPrint('API Service GET response');
      debugPrint(response.body);
      responseJson = _returnResponse(response);
    } on SocketException catch (e) {
      debugPrint('We got the exception in Get api call $e');
      throw FetchDataException(e.message);
    }
    return responseJson;
  }

  Future deleteResponse(String url) async {
    dynamic responseJson;
    try {
      debugPrint('*** DELETE Url ==> $url \n');
      final response = await http.delete(
        getFullUrl(url),
        headers: await headers,
      );
      debugPrint('API Service DELETE response');
      debugPrint(response.body);
      responseJson = _returnResponse(response);
    } on SocketException catch (e) {
      debugPrint('We got the exception in Delete api call $e');
      throw FetchDataException(e.message);
    }
    return responseJson;
  }

  Future postResponse(String url, Map<String, dynamic> jsonBody) async {
    dynamic responseJson;
    debugPrint('API Service POST ');
    debugPrint('post_request= ${jsonEncode(jsonBody)}');
    try {
      debugPrint('*** POST Url ==> $url \n jsonBody $jsonBody');
      final response = await http.post(
        getFullUrl(url),
        body: jsonEncode(jsonBody),
        headers: await headers,
      );
      debugPrint('API Service POST response ');
      debugPrint(response.body);
      responseJson = _returnResponse(response);
    } on SocketException catch (e) {
      debugPrint('We got the exception in Post api call $e');
      throw FetchDataException(e.message);
    }
    return responseJson;
  }

  Future putResponse(String url, Map<String, dynamic> jsonBody) async {
    dynamic responseJson;
    debugPrint('API Service PUT Resuest $url');
    debugPrint(jsonBody.toString());
    try {
      final response = await http.put(
        getFullUrl(url),
        body: jsonEncode(jsonBody),
        headers: await headers,
      );
      debugPrint('API Service PUT response');
      debugPrint(response.body);
      responseJson = _returnResponse(response);
    } on SocketException catch (e) {
      debugPrint('We got the exception in Put api call $e');
      throw FetchDataException(e.message);
    }
    return responseJson;
  }

  Future patchResponse(String url, Map<String, dynamic> jsonBody) async {
    dynamic responseJson;
    debugPrint('API Service PATCH ');
    debugPrint(jsonBody.toString());
    debugPrint(url);
    try {
      final response = await http.patch(
        getFullUrl(url),
        body: jsonEncode(jsonBody),
        headers: await headers,
      );
      debugPrint('API Service PATCH response');
      debugPrint(response.body);
      responseJson = _returnResponse(response);
    } on SocketException catch (e) {
      debugPrint('We got the exception in Patch api call $e');
      throw FetchDataException(e.message);
    }
    return responseJson;
  }

  Future postMultipartFileResponse(
    String url,
    List<KeyValueRequestData> jsonBody,
    List<String> files,
    List<String> fields,
  ) async {
    debugPrint('*** API Service POST Multipart File Starts Here $url \n');
    debugPrint(jsonBody.toString());
    debugPrint(fields.toString());
    dynamic responseJson;
    try {
      debugPrint('API Service POST Multipart File Response Start Here \n ');
      var multiPartRequest =
          http.MultipartRequest('POST', Uri.parse(domainUrl + url));

      for (var i = 0; i < files.length; i++) {
        debugPrint('MultiPart Request file path \n ');
        debugPrint(fields[i]);
        debugPrint(files[i]);
        multiPartRequest.files.add(
          await http.MultipartFile.fromPath(
            fields[i],
            files[i],
          ),
        );
      }
      if (jsonBody.isNotEmpty) {
        for (var element in jsonBody) {
          multiPartRequest.fields[element.key] = element.value;
        }
      }
      if ((await authorizationToken) != null) {
        multiPartRequest.headers['authorization'] = (await authorizationToken)!;
      }
      debugPrint('${multiPartRequest.url}');
      debugPrint('${multiPartRequest.fields}');
      debugPrint('${multiPartRequest.files.length}');
      debugPrint('Files Length ${multiPartRequest.files}');
      debugPrint('API Service POST multiPartRequest End Here \n ');

      final http.StreamedResponse response = await multiPartRequest.send();
      debugPrint('API Service POST response ** \n');
      // responseJson = jsonDecode(response.body);
      var httpResponse = await http.Response.fromStream(response);
      debugPrint(httpResponse.body);

      responseJson = _returnResponse(httpResponse);
    } on SocketException {
      throw FetchDataException('No Internet connection');
    }
    return responseJson;
  }

  Future postMultipartXFileResponse(
    String url,
    List<KeyValueRequestData> jsonBody,
    List<File> files,
    List<String> fields,
  ) async {
    debugPrint('*** API Service POST Multipart XFile Starts Here $url \n');
    debugPrint(jsonBody.toString());
    debugPrint(fields.toString());
    dynamic responseJson;
    try {
      debugPrint('API Service POST Multipart XFile Response Start Here \n ');
      var multiPartRequest =
          http.MultipartRequest('POST', Uri.parse(domainUrl + url));

      for (var i = 0; i < files.length; i++) {
        debugPrint('MultiPart Request file path \n ');
        debugPrint(fields[i]);
        debugPrint(files[i].path);
        multiPartRequest.files.add(await http.MultipartFile.fromPath(
          fields[i],
          files[i].path,
        ));
      }
      if (jsonBody.isNotEmpty) {
        for (var element in jsonBody) {
          multiPartRequest.fields[element.key] = element.value;
        }
      }
      if ((await authorizationToken) != null) {
        multiPartRequest.headers['authorization'] = (await authorizationToken)!;
      }

      debugPrint('API Service POST multiPartRequest Start Here \n ');
      debugPrint('${multiPartRequest.url}');
      debugPrint('${multiPartRequest.fields}');
      debugPrint('Files Count ${multiPartRequest.files.length}');
      debugPrint('${multiPartRequest.files}');
      debugPrint('API Service POST multiPartRequest End Here \n ');

      final http.StreamedResponse response = await multiPartRequest.send();
      debugPrint('API Service POST response ** \n');
      // responseJson = jsonDecode(response.body);
      var httpResponse = await http.Response.fromStream(response);
      debugPrint(httpResponse.body);
      responseJson = httpResponse;
    } on SocketException catch (error) {
      debugPrint('API POST Service SocketException $error');
      throw FetchDataException('No Internet Connection');
    } catch (e) {
      debugPrint('API POST Service Error $e');
    }
    return responseJson;
  }
}

dynamic _returnResponse(http.Response response) {
  debugPrint('API Service _returnResponse');
  debugPrint(response.body);

  if (response.body.toString().isEmpty) {
    signOutUser();
    return response;
  } else {
    switch (response.statusCode) {
      case 200:
        // 200	OK	The requested action was successful.
        // var responseJson = json.decode(response.body.toString());
        // debugPrint('********* API Response START ********** \n');
        // debugPrint(responseJson.toString());
        // debugPrint('********* API Response END ********** \n');
        return response;

      case 201:
        //201	Created	A new resource was created.
        // var responseJson = json.decode(response.body.toString());
        // debugPrint('********* API Response START ********** \n');
        // debugPrint(responseJson.toString());
        // debugPrint('********* API Response END ********** \n');
        return response;
      case 202:
        //202	Accepted	The request was received, but no modification has been made yet.
        // var responseJson = json.decode(response.body.toString());
        // debugPrint('********* API Response START ********** \n');
        // debugPrint(responseJson.toString());
        // debugPrint('********* API Response END ********** \n');
        return response;
      case 204:
        //204	No Content	The request was successful, but the response has no content.
        ErrorResponseModel errorResponse =
            ErrorResponseModel.fromJson(jsonDecode(response.body));
        throw NoDataException(errorResponse.message.toString());

      case 400:
        //400	Bad Request	The request was malformed.
        ErrorResponseModel errorResponse =
            ErrorResponseModel.fromJson(jsonDecode(response.body));
        throw BadRequestException(errorResponse.message.toString());
      case 401:
        //401	Unauthorized	The client is not authorized to perform the requested action.
        ErrorResponseModel errorResponse =
            ErrorResponseModel.fromJson(jsonDecode(response.body));
        throw UnauthorisedException(errorResponse.message.toString());
      case 403:
        ErrorResponseModel errorResponse =
            ErrorResponseModel.fromJson(jsonDecode(response.body));
        throw UnauthorisedException(errorResponse.message.toString());
      case 404:
        //404	Not Found	The requested resource was not found.
        ErrorResponseModel errorResponse =
            ErrorResponseModel.fromJson(jsonDecode(response.body));
        throw ResoruceNotFoundException(errorResponse.message.toString());
      case 415:
        //415	Unsupported Media Type	The request data format is not supported by the server.
        ErrorResponseModel errorResponse =
            ErrorResponseModel.fromJson(jsonDecode(response.body));
        throw UnsupportedMediaTypeException(errorResponse.message.toString());
      case 422:
        //422	Unprocessable Entity	The request data was properly formatted but contained invalid or missing data.
        ErrorResponseModel errorResponse =
            ErrorResponseModel.fromJson(jsonDecode(response.body));
        throw UnprocessableEntityException(errorResponse.message.toString());

      case 500:
        //500	Internal Server Error	The server threw an error when processing the request.
        ErrorResponseModel errorResponse =
            ErrorResponseModel.fromJson(jsonDecode(response.body));
        throw InternalServerErrorException(errorResponse.message.toString());

      default:
        ErrorResponseModel errorResponse =
            ErrorResponseModel.fromJson(jsonDecode(response.body));
        throw FetchDataException(
          'Error occured while Communication with Server with StatusCode : ${response.statusCode} ${errorResponse.message}',
        );
    }
  }
}

void signOutUser() async {
  debugPrint('signOutUser');
  SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
  await sharedPreferences.setString(AppConstants.authKey, '');

  gotoSignInPage();
}

void gotoSignInPage() {
  // navigatorKey.currentState
  //     ?.pushNamedAndRemoveUntil(AppRoutes().signIn, (route) => false);
}

class KeyValueRequestData {
  final String key;
  final String value;

  KeyValueRequestData({
    required this.key,
    required this.value,
  });
}

class ErrorResponseModel {
  dynamic message;

  ErrorResponseModel({
    required this.message,
  });

  ErrorResponseModel.fromJson(Map<String, dynamic> json) {
    if (json.containsKey('message')) {
      message = json['message'];
    }
    if (json.containsKey('non_field_errors')) {
      message = json['non_field_errors'].toString();
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['message'] = message;
    return data;
  }
}
