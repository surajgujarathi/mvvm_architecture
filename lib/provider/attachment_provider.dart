import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart';

import '../model/attachment_model.dart';

import '../services/app_exceptions.dart';
import '../services/network_services.dart';

class FetchAttachmentDataProvider extends ChangeNotifier {
  void update() {
    notifyListeners();
  }

  ///// fetch data /////////
  Future<dynamic> getAttachmentList(id) async {
    try {
      final NetworkService apiService = NetworkService();
      String url = 'your url';
      Response response = await apiService.getResponse(url);

      if (response.statusCode == 200) {
        List? body = jsonDecode(response.body);

        List<AttachmentsModel> attachmentList = body
                ?.map((dynamic item) => AttachmentsModel.fromJson(item))
                .toList() ??
            [];

        return attachmentList;
      }
    } catch (error) {
      debugPrint("Error While fetching the attachment  data === $error");
    }
  }

/////// delete data /////////////////
  deleteFile(String id) async {
    try {
      final NetworkService apiService = NetworkService();

      String url = "your url";
      debugPrint('delete_url==$url');
      Response response = await apiService.deleteResponse(
        url,
      );
      debugPrint('delete_response == ${response.body}');

      if (response.statusCode == 200) {
        notifyListeners();
        // showToast("Attachment deleted Sucessfully");
      } else {
        notifyListeners();
        ErrorResponseModel errorResponse =
            ErrorResponseModel.fromJson(jsonDecode(response.body));
        debugPrint(
            "Error While Deleting the attachment  data === ${errorResponse.message}");
      }
    } on AppException catch (error) {
      notifyListeners();
      debugPrint("Error While Deleting the attachment  data === $error");
    }
  }

  void editAttachment(
    AttachmentsModel data,
    String comment,
    String id,
  ) async {
    var reqBody = {
      "attachment_filename": data.attachmentFilename,
      "comments": comment,
      "csa_id": id,
      'id': data.id,
    };
    try {
      debugPrint('Edit Attachment');
      final NetworkService apiService = NetworkService();

      Response response = await apiService.putResponse('your url', reqBody);

      debugPrint('Edit_task_respo==${response.body.toString()}');
      if (response.statusCode == 200 || response.statusCode == 201) {
        // showToast("Task Updated");

        debugPrint("Sucess");
      } else {
        debugPrint("failure");
        ErrorResponseModel errorResponse =
            ErrorResponseModel.fromJson(jsonDecode(response.body));
        debugPrint(
            "Error Whilse Edit Attachment in Action Item data === ${errorResponse.message}");

        // showErrorToast("Something Went Wrong");
      }
    } catch (error) {
      debugPrint(error.toString());

      debugPrint(
          "Error Whilse Edit Attachment  in Action Item data === $error");

      //  showErrorToast("Something Went Wrong");
    }
  }
}
