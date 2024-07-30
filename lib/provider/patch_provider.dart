import 'package:flutter/cupertino.dart';
import 'package:http/http.dart';

import '../services/network_services.dart';

class AddSubActivityProvider extends ChangeNotifier {
  Future addSubTaskApicall(var reqBody, bool isEdit) async {
    void saveTokenInServer(String deviceToken) async {
      debugPrint('device token is ==> $deviceToken');
      //API Call to save token
      try {
        final NetworkService apiService = NetworkService();
        Response response = await apiService
            .patchResponse("updatedevicetoken/", {"device_token": deviceToken});
        if ((response.statusCode == 200) && (response.statusCode == 201)) {
          debugPrint("Token Is Send");
        } else {
          debugPrint("Token not send");
        }
      } catch (error) {
        debugPrint(error.toString());
      }
    }
  }
}
