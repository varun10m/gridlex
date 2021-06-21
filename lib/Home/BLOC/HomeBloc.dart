import 'dart:io';

import 'package:gridlex_assessment/Home/Model/HealthCareInformation.dart';
import 'package:gridlex_assessment/Repository/Repository.dart';
import 'package:rxdart/rxdart.dart';

class HomeBloc {
  Repository? _repo = Repository.getInstance();
  static HomeBloc? _instance;

  String? imageBase64Data;

  File? image;

  static HomeBloc? getInstance() {
    if (_instance == null) _instance = new HomeBloc();
    return _instance;
  }

  // ignore: unused_field
  HealthCareInformation? _healthCareInformationModel;

  // ignore: close_sinks
  BehaviorSubject<String> _designationController =
      new BehaviorSubject<String>();
  Stream<String> get designationStream => _designationController.stream;

  // ignore: close_sinks
  BehaviorSubject<String> _inquiryController = new BehaviorSubject<String>();
  Stream<String> get inquiryStream => _inquiryController.stream;

  // ignore: close_sinks
  BehaviorSubject<String> _genderController = new BehaviorSubject<String>();
  Stream<String> get genderStream => _genderController.stream;

  BehaviorSubject<List<String>?> _selectedProductListController =
      new BehaviorSubject<List<String>?>();

  Stream<List<String>?> get selectedProductsListStream =>
      _selectedProductListController.stream;

  // ignore: close_sinks
  BehaviorSubject<List<String>?> _selectedResponseMethodsListController =
      new BehaviorSubject<List<String>?>();

  Stream<List<String>?> get selectedResponseMethodsListStream =>
      _selectedResponseMethodsListController.stream;

  BehaviorSubject<String?> _selectedStateController =
      new BehaviorSubject<String?>();

  Stream<String?> get selectedStateStream => _selectedStateController.stream;

  void updateDesignation(String value) {
    _designationController.add(value);
  }

  void updateSelectedProductsStream(List<String>? selectedProducts) {
    _selectedProductListController.add(selectedProducts);
  }

  void updateSelectedResponseMethods(List<String>? selectedResponseMethods) {
    _selectedResponseMethodsListController.add(selectedResponseMethods);
  }

  void updateInquiry(String value) {
    _inquiryController.add(value);
  }

  void updateGender(String value) {
    _genderController.add(value);
  }

  void setSelectedState(String value) {
    _selectedStateController.add(value);
  }

  Future<Map<String, dynamic>> updateRepresentativeValueInBloc(
      HealthCareInformation healthCareInformation) async {
    this._healthCareInformationModel = healthCareInformation;
    return await sendDataToServer();
  }

  Future<Map<String, dynamic>> sendDataToServer() async {
    return await _repo!.sendDataToServer(_healthCareInformationModel!);
  }

  Future<Map<String, dynamic>> checkForDataInLocalServer() async {
    return await _repo!.getDataFromServer();
  }

  void disposeASectionRelatedStreamsInBloc() {
    _designationController.close();
    _selectedStateController.close();
  }

  void disposeBSectionRelatedStreamsInBloc() {
    _selectedProductListController.close();
    _inquiryController.close();
    _genderController.close();
    _selectedResponseMethodsListController.close();
  }

  void updateHealthCareInformationModelInBloc(
      HealthCareInformation healthCareContactInformationModel) {
    _healthCareInformationModel = healthCareContactInformationModel;
  }
}
