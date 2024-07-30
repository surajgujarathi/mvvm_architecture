import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart';

import '../services/network_services.dart';

enum LoadingState { initial, loading, success, error }

class AddSubActivityProvider extends ChangeNotifier {
  var _requestState = LoadingState.initial;

  get requestState => _requestState;

  Future addSubTaskApicall(var reqBody, bool isEdit) async {
    _requestState = LoadingState.loading;
    notifyListeners();
    try {
      debugPrint('Edit_task=$reqBody');
      final NetworkService apiService = NetworkService();
      String url = "your url";
      String ss = jsonEncode(reqBody);
      debugPrint(ss);

      Response response = await apiService.postResponse(url, reqBody);

      debugPrint('Add Task ==${response.body.toString()}');
      if (response.statusCode == 200 || response.statusCode == 201) {
        //showToast(isEdit ? "Task Updated" : "Task Added");
        _requestState = LoadingState.success;
        notifyListeners();
        debugPrint("Sucess");
      } else {
        debugPrint("failure");
        ErrorResponseModel errorResponse =
            ErrorResponseModel.fromJson(jsonDecode(response.body));
        debugPrint(
            "Error While Add Sub Activites Task in Action Item data === ${errorResponse.message}");
        _requestState = LoadingState.error;
        notifyListeners();
        //showErrorToast("Something Went Wrong");
      }
    } catch (error) {
      debugPrint(error.toString());

      debugPrint(
          "Error While Add  sub Activites Task in Action Item data === $error");
      _requestState = LoadingState.error;
      notifyListeners();
      // showErrorToast("Something Went Wrong");
    }
  }
}
