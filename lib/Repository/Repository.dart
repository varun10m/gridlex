import 'package:connectivity/connectivity.dart';
import 'package:flutter/services.dart';
import 'package:gridlex_assessment/Home/Model/HealthCareInformation.dart';
import 'package:gridlex_assessment/Repository/Source/httpSource.dart';
import 'package:gridlex_assessment/Repository/Source/localSource.dart';
import 'package:gridlex_assessment/Repository/Source/storageSource.dart';

class Repository {
  static Repository? _instance;
  final HttpSource? _httpSource = HttpSource.getInstance();
  final LocalSource? _localSource = LocalSource.getInstance();
  final StorageSource? _storageSource = StorageSource.getInstance();

  final Connectivity _connectivity = Connectivity();

  static Repository? getInstance() {
    if (_instance == null) _instance = new Repository();
    return _instance;
  }

  Future<Map<String, dynamic>> sendDataToServer(
      HealthCareInformation medicalFormModel) async {
    ConnectivityResult result = ConnectivityResult.none;
    Map<String, dynamic> mapFromServer = {};
    mapFromServer = await checkDataConnectionAndSendData(
        result, medicalFormModel, mapFromServer);
    return mapFromServer;
  }

  Future<Map<String, dynamic>> checkDataConnectionAndSendData(
      ConnectivityResult result,
      HealthCareInformation medicalFormModel,
      Map<String, dynamic> mapFromServer) async {
    try {
      result = await _connectivity.checkConnectivity();
      print("Connectivity Result is =$result");
      print("URl before parsing in repo = ${medicalFormModel.url}");
      if (result == ConnectivityResult.none) {
        mapFromServer =
            await addDataToLocalServer(mapFromServer, medicalFormModel);
      } else {
        mapFromServer =
            await sendDataToRemoteServer(medicalFormModel, mapFromServer);
      }
    } on PlatformException catch (e) {
      print(e.toString());
      mapFromServer =
          await addDataToLocalServer(mapFromServer, medicalFormModel);
    }
    return mapFromServer;
  }

  Future<Map<String, dynamic>> sendDataToRemoteServer(
      HealthCareInformation medicalFormModel,
      Map<String, dynamic> mapFromServer) async {
    String url = await _storageSource!.saveImageToStorage(medicalFormModel);
    medicalFormModel.url = url;
    mapFromServer = await _httpSource!.sendDataToServer(medicalFormModel);
    return mapFromServer;
  }

  Future<Map<String, dynamic>> addDataToLocalServer(
      Map<String, dynamic> mapFromServer,
      HealthCareInformation medicalFormModel) async {
    mapFromServer = await _localSource!.addFormData(medicalFormModel);
    return mapFromServer;
  }

  Future<Map<String, dynamic>> getDataFromServer() async {
    List listFromLocalStorage = await _localSource!.getDataFromLocal();
    print("listFromLocalStorage = ${listFromLocalStorage.length}");

    if (listFromLocalStorage.isNotEmpty)
      return sendTotalDataToServer(listFromLocalStorage);
    else
      return {"message": "No Data In Local Storage"};
  }

  Future<Map<String, dynamic>> sendTotalDataToServer(
      List<dynamic> listFromLocalStorage) async {
    print("sendTotalDataToServer with $sendTotalDataToServer");

    Map<String, dynamic> mapFromServer =
        await _httpSource!.sendTotalDataToServer(listFromLocalStorage);
    if (mapFromServer['isSuccess']) _localSource!.clearData();
    return mapFromServer;
  }
}
