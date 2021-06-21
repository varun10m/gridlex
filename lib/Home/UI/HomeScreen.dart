import 'dart:async';

import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gridlex_assessment/Home/BLOC/HomeBloc.dart';
import 'package:gridlex_assessment/Utils/Utils.dart';

import 'Pages/ContactInformation.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final Connectivity _connectivity = Connectivity();
  HomeBloc? _bloc = HomeBloc.getInstance();

  late StreamSubscription<ConnectivityResult> _connectivitySubscription;
  @override
  Widget build(BuildContext context) {
    return HealthCareContactInformationPage();
  }

  @override
  void initState() {
    super.initState();
    initConnectivity();

    _connectivitySubscription =
        _connectivity.onConnectivityChanged.listen(_updateConnectionStatus);
  }

  Future<void> initConnectivity() async {
    ConnectivityResult result = ConnectivityResult.none;

    result = await checkConnectivity(result);
    if (!mounted) {
      return Future.value(null);
    }

    return _updateConnectionStatus(result);
  }

  Future<ConnectivityResult> checkConnectivity(
      ConnectivityResult result) async {
    try {
      result = await _connectivity.checkConnectivity();
    } on PlatformException catch (e) {
      print(e.toString());
    }
    return result;
  }

  void _updateConnectionStatus(ConnectivityResult event) {
    switch (event) {
      case ConnectivityResult.wifi:
      case ConnectivityResult.mobile:
        checkDataInLocalServer();
        break;

      default:
        print("No connection");
        break;
    }
  }

  @override
  void dispose() {
    super.dispose();
    _connectivitySubscription.cancel();
  }

  void checkDataInLocalServer() {
    try {
      // getSnackBar(this.context, "Detected Network change");
      getSnackBar(this.context, "Checking for Data in local Storage");
      checkStatus();
    } catch (e) {}
  }

  Future<void> checkStatus() async {
    Map<String, dynamic> mapFromServer =
        await _bloc!.checkForDataInLocalServer();
    getSnackBar(context, mapFromServer['message']);
  }
}
