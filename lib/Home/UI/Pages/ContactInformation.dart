import 'package:flutter/material.dart';
import 'package:gridlex_assessment/Home/BLOC/HomeBloc.dart';
import 'package:gridlex_assessment/Home/Model/HealthCareInformation.dart';
import 'package:gridlex_assessment/Home/UI/Pages/UnsolicitedInformationRequest.dart';
import 'package:gridlex_assessment/Utils/Utils.dart';

class HealthCareContactInformationPage extends StatefulWidget {
  const HealthCareContactInformationPage({Key? key}) : super(key: key);

  @override
  _HealthCareContactInformationPageState createState() =>
      _HealthCareContactInformationPageState();
}

class _HealthCareContactInformationPageState
    extends State<HealthCareContactInformationPage> {
  final _formKey = GlobalKey<FormState>();
  HomeBloc? _bloc = HomeBloc.getInstance();

  TextEditingController requestorFirstNameController =
      new TextEditingController();
  TextEditingController requestorLastNameController =
      new TextEditingController();
  TextEditingController institutionNameController = new TextEditingController();
  TextEditingController departmentController = new TextEditingController();
  TextEditingController addressLine1Controller = new TextEditingController();
  TextEditingController addressLine2Controller = new TextEditingController();

  TextEditingController cityController = new TextEditingController();
  TextEditingController zipController = new TextEditingController();
  TextEditingController phoneNumberController = new TextEditingController();
  TextEditingController faxNumberController = new TextEditingController();
  TextEditingController emailController = new TextEditingController();
  List<DropdownMenuItem<String>>? statesMenuList;
  String? selectedState;
  String designation = "MD";

  void initState() {
    super.initState();
    statesMenuList = buildDropDownMenuItems(statesListForDropDown);
    selectedState = statesMenuList![0].value;
  }

  @override
  void dispose() {
    super.dispose();
    disposeControllers();
    designation = "MD";
    selectedState = statesMenuList![0].value;

    _bloc!.disposeASectionRelatedStreamsInBloc();
  }

  void disposeControllers() {
    requestorFirstNameController.dispose();
    requestorLastNameController.dispose();
    institutionNameController.dispose();
    departmentController.dispose();
    addressLine1Controller.dispose();
    addressLine2Controller.dispose();
    cityController.dispose();
    zipController.dispose();
    phoneNumberController.dispose();
    faxNumberController.dispose();
    emailController.dispose();
  }

  List<DropdownMenuItem<String>> buildDropDownMenuItems(
      List<String> listItems) {
    List<DropdownMenuItem<String>> items = [];
    for (String listItem in listItems) {
      addItemsToDropDown(items, listItem);
    }
    return items;
  }

  void addItemsToDropDown(
      List<DropdownMenuItem<String>> items, String listItem) {
    items.add(
      DropdownMenuItem(
        child: Text(listItem),
        value: listItem,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: getBody(),
      appBar: buildAppBar(""),
    );
  }

  Widget getBody() {
    return GestureDetector(
      onTap: () => closeKeyBoard(),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            getMainHeadingText(
                "Health Care Professional Contact Information :"),
            Expanded(
              child: SingleChildScrollView(
                child: Form(
                    key: _formKey,
                    child: Column(
                      children: buildChildren(),
                    )),
              ),
            ),
            getSubmitButton(navigateToUnsolicitedInfoScreen)
          ],
        ),
      ),
    );
  }

  List<Widget> buildChildren() {
    return [
      getPersonalDetails(),
      getInstitutionDetails(),
      getAddressDetails(),
    ];
  }

  Column getPersonalDetails() {
    return Column(
      children: [
        getTextFormField(requestorFirstNameController, "Requestor First Name*",
            "Requestor First Name",
            validationType: 1),
        getTextFormField(requestorLastNameController, "Requestor Last Name*",
            "Requestor Last Name",
            validationType: 1),
        getDesignationWidget(),
      ],
    );
  }

  Column getInstitutionDetails() {
    return Column(
      children: [
        getTextFormField(
            institutionNameController, "Institute/Office*", "Institute/Office",
            validationType: 1),
        getTextFormField(departmentController, "Department*", "Department",
            validationType: 1),
        getTextFormField(
            addressLine1Controller,
            "Institution/Office Address Line*",
            "Institution/Office Address Line 1",
            validationType: 1),
        getTextFormField(
            addressLine2Controller,
            "Institution/Office Address Line 2",
            "Institution/Office Address Line 2",
            validationType: 6),
      ],
    );
  }

  Column getAddressDetails() {
    return Column(
      children: [
        getStateSelectionDropDown(),
        getTextFormField(cityController, "City*", "City", validationType: 1),
        getTextFormField(zipController, "Zip*", "Zip", validationType: 5),
        getTextFormField(phoneNumberController, "Phone Number", "Phone Number",
            validationType: 7, length: 10),
        getTextFormField(faxNumberController, "Fax Number", "Fax Number",
            validationType: 7),
        getTextFormField(emailController, "Email", "Email", validationType: 8),
      ],
    );
  }

  Widget getDesignationWidget() {
    return Column(
      children: [
        getHeadingText("Designation*"),
        radioButtonForDesignation("MD"),
        radioButtonForDesignation("DO"),
        radioButtonForDesignation("NP"),
        radioButtonForDesignation("PA"),
      ],
    );
  }

  Widget radioButtonForDesignation(String value) {
    return StreamBuilder<String>(
        stream: _bloc!.designationStream,
        initialData: "MD",
        builder: (context, snapshot) {
          return getRadioButton(value, snapshot.data!);
        });
  }

  Widget getRadioButton(String value, String groupValue) {
    return Row(
      children: [
        Radio<String>(
          onChanged: (value) {
            _bloc!.updateDesignation(value!);
            designation = value;
          },
          groupValue: groupValue,
          value: value,
        ),
        Text(value)
      ],
    );
  }

  void navigateToUnsolicitedInfoScreen() {
    if (selectedState != "State") {
      if (_formKey.currentState!.validate()) {
        saveDataAndNavigate();
      }
    } else
      getSnackBar(context, "Please select State to Continue");
  }

  void saveDataAndNavigate() {
    HealthCareInformation healthCareInformationModel =
        getHealthCareInformation();
    _bloc!.updateHealthCareInformationModelInBloc(healthCareInformationModel);
    navigateTo(this.context,
        UnsolicitedInformationRequestPage(healthCareInformationModel));
  }

  HealthCareInformation getHealthCareInformation() {
    return HealthCareInformation(
        firstName: requestorFirstNameController.text,
        lastName: requestorLastNameController.text,
        designation: designation,
        institutionName: institutionNameController.text,
        department: departmentController.text,
        addressLine1: addressLine1Controller.text,
        addressLine2: addressLine2Controller.text,
        stateName: selectedState!,
        cityName: cityController.text,
        pinCode: zipController.text,
        phoneNumber: phoneNumberController.text,
        faxNumber: faxNumberController.text,
        emailId: emailController.text);
  }

  Widget getStateSelectionDropDown() {
    return StreamBuilder<String?>(
        stream: _bloc!.selectedStateStream,
        builder: (context, snapshot) {
          return Column(
            children: [
              getHeadingText("State*"),
              buildDroopDownWidget(context, snapshot),
            ],
          );
        });
  }

  Padding buildDroopDownWidget(
      BuildContext context, AsyncSnapshot<String?> snapshot) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        height: 60,
        alignment: Alignment.center,
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8.0),
          border: Border.all(color: Colors.black12, width: 1.0),
        ),
        child: Padding(
          padding: const EdgeInsets.only(left: 8.0, right: 8.0),
          child: buildDropdownButton(snapshot),
        ),
      ),
    );
  }

  DropdownButton<String> buildDropdownButton(AsyncSnapshot<String?> snapshot) {
    return DropdownButton<String>(
        isExpanded: true,
        hint:
            Text("Select State", style: TextStyle(fontWeight: FontWeight.bold)),
        value: snapshot.data,
        items: statesMenuList,
        icon: Icon(Icons.arrow_drop_down),
        underline: Container(
          color: Colors.white,
        ),
        iconSize: 24,
        elevation: 16,
        onChanged: (value) {
          _bloc!.setSelectedState(value!);
          selectedState = value;
        });
  }

  void closeKeyBoard() {
    FocusScopeNode currentFocus = FocusScope.of(context);
    if (!currentFocus.hasPrimaryFocus) {
      currentFocus.unfocus();
    }
  }
}
