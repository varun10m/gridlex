import 'package:flutter/material.dart';
import 'package:gridlex_assessment/Home/BLOC/HomeBloc.dart';
import 'package:gridlex_assessment/Home/Model/HealthCareInformation.dart';
import 'package:gridlex_assessment/Home/UI/Screens/ActionsSuccessfullScreen.dart';
import 'package:gridlex_assessment/Utils/Progress_Dialog.dart';
import 'package:gridlex_assessment/Utils/Utils.dart';

class RepresentativeContactInformationPage extends StatefulWidget {
  final HealthCareInformation healthCareInformationModel;

  const RepresentativeContactInformationPage(this.healthCareInformationModel);

  @override
  _RepresentativeContactInformationPageState createState() =>
      _RepresentativeContactInformationPageState();
}

class _RepresentativeContactInformationPageState
    extends State<RepresentativeContactInformationPage> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController representativeNameController =
      new TextEditingController();
  TextEditingController representativeTypeController =
      new TextEditingController();
  TextEditingController representativeTerritoryController =
      new TextEditingController();
  TextEditingController countryCodeController = new TextEditingController();
  TextEditingController primaryNumberController = new TextEditingController();
  HomeBloc? _bloc = HomeBloc.getInstance();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: getBody(),
      appBar: buildAppBar(""),
    );
  }

  @override
  void dispose() {
    super.dispose();
    disposeControllers();
  }

  void disposeControllers() {
    representativeNameController.dispose();
    representativeTypeController.dispose();
    representativeTerritoryController.dispose();
    countryCodeController.dispose();
    primaryNumberController.dispose();
  }

  Widget getBody() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          getMainHeadingText("Representative Contact Information :"),
          Expanded(
            child: SingleChildScrollView(
              child: Form(
                  key: _formKey,
                  child: Column(
                    children: buildChildren(),
                  )),
            ),
          ),
          getSubmitButton(submitFormDetails),
        ],
      ),
    );
  }

  List<Widget> buildChildren() {
    return [
      getTextForDeclaration(),
      getTextFormField(representativeNameController, "Representative Name*",
          "Representative Name",
          validationType: 1),
      getTextFormField(representativeTypeController, "Representative Type*",
          "Representative Type",
          validationType: 1),
      getTextFormField(representativeTerritoryController,
          "Representative Territory Number*", "Representative Territory Number",
          validationType: 1),
      getTextFormField(countryCodeController, "Country Code", "Country Code",
          validationType: 7),
      getTextFormField(primaryNumberController, "Primary Telephone Number",
          "Telephone Number",
          validationType: 7, length: 10),
    ];
  }

  Widget getTextForDeclaration() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Text(
          "By Submitting this form, I certify that is request for Information was initiated by Health Care Professional stated above, and was not solicited by me in any manner.",
          style: TextStyle(fontSize: 18)),
    );
  }

  Future<void> submitFormDetails() async {
    if (_formKey.currentState!.validate()) {
      HealthCareInformation healthCareInformationModel =
          widget.healthCareInformationModel;
      healthCareInformationModel =
          getCompleteHealthCareInfoModel(healthCareInformationModel);
      _bloc!.updateHealthCareInformationModelInBloc(healthCareInformationModel);
      ProgressDialog dialog = new ProgressDialog(
        context,
        isDismissible: false,
      );
      dialog.style(message: 'Please wait...');
      await dialog.show();
      Map<String, dynamic> mapFromServer = await _bloc!
          .updateRepresentativeValueInBloc(healthCareInformationModel);
      await dialog.hide();
      if (mapFromServer['isSuccess']) {
        navigateToSuccess(mapFromServer);
      }
    }
  }

  void navigateToSuccess(Map<String, dynamic> mapFromServer) {
    if (mapFromServer['directory'] == "remote") {
      navigateToSuccessScreen("Data Successfully Saved to Remote Server");
    } else
      navigateToSuccessScreen(
          "Form Successfully Saved Locally. Will Upload to the server once the internet connection is back");
  }

  void navigateToSuccessScreen(String message) {
    Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
          builder: (context) => ActionSuccessful(message),
        ),
        (route) => false);
  }

  HealthCareInformation getCompleteHealthCareInfoModel(
      HealthCareInformation healthCareInformationModel) {
    healthCareInformationModel.representativeName =
        representativeNameController.text;
    healthCareInformationModel.representativeType =
        representativeTypeController.text;
    healthCareInformationModel.territoryNumber =
        representativeTerritoryController.text;
    healthCareInformationModel.countryCode = countryCodeController.text;
    healthCareInformationModel.telephoneNumber = primaryNumberController.text;
    return healthCareInformationModel;
  }
}
