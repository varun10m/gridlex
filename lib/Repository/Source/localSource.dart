import 'package:gridlex_assessment/Home/Model/HealthCareInformation.dart';
import 'package:hive/hive.dart';

class LocalSource {
  static LocalSource? instance;

  static LocalSource? getInstance() {
    if (instance == null) {
      instance = new LocalSource();
    }
    return instance;
  }

  LocalSource() {
    print("Constructor for Local Storage");
  }

  Future<List> getDataFromLocal() async {
    return getFormDataInLocal();
  }

  List getFormDataInLocal() {
    print("getFormDataInLocal");
    return Hive.box("tempFormData").values.toList();
  }

  Future<Map<String, dynamic>> addFormData(
      HealthCareInformation medicalFormModel) async {
    try {
      int result =
          await Hive.box("tempFormData").add(medicalFormModel.toJson());
      return result != -1
          ? {"isSuccess": true, "directory": "local"}
          : {"isSuccess": false};
    } catch (e) {
      print("Error in addFormData to local = $e");
      return {"isSuccess": false};
    }
  }

  void clearData() {
    print("Clearing Data From Local Server");
    Hive.box('tempFormData').clear();
  }
}
