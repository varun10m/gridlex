import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

Widget getTextFormField(
    TextEditingController controller, String labelText, String hintText,
    {bool? enable,
    TextInputType? textInputType,
    required int validationType,
    int? length,
    TextAlign? alignment,
    bool? obscureText,
    bool? autoFocus,
    bool? readOnly,
    void Function()? onEditingCompleted,
    void Function()? onChange,
    String? prefixText}) {
  return Padding(
    padding: const EdgeInsets.all(8.0),
    child: TextFormField(
        controller: controller,
        obscureText: obscureText ?? false,
        maxLength: length,
        onEditingComplete: onEditingCompleted,
        onChanged: (s) => onChange != null ? onChange() : {},
        validator: (s) => getValidation(validationType, s!, labelText),
        enabled: enable ?? true,
        autofocus: autoFocus ?? false,
        keyboardType: getKeyBoardType(validationType),
        textAlign: alignment ?? TextAlign.left,
        inputFormatters: getInputFormatters(validationType),
        readOnly: readOnly ?? false,
        decoration: InputDecoration(
            labelText: labelText,
            hintText: hintText,
            prefixText: prefixText ?? "")),
  );
}

List<TextInputFormatter>? getInputFormatters(int validationType) {
  switch (validationType) {
    case 2:
    case 4:
      // ignore: deprecated_member_use
      return <TextInputFormatter>[WhitelistingTextInputFormatter.digitsOnly];
    default:
      return null;
  }
}

TextInputType getKeyBoardType(int validationType) {
  switch (validationType) {
    case 2:
    case 4:
    case 5:
    case 7:
      return TextInputType.numberWithOptions();
    case 3:
    case 8:
      return TextInputType.emailAddress;
    default:
      return TextInputType.text;
  }
}

String? getValidation(int validationType, String s, String labelText) {
  switch (validationType) {
    case 1:
      return nameValidation(s, labelText);

    case 3:
      return emailValidation(s);

    case 4:
      return phoneNumberValidation(s);
    case 5:
      return pinCodeValidation(s);
    case 6:
    case 7:
    case 8:
      return null;
    default:
      return nameValidation(s, labelText);
  }
}

String? pinCodeValidation(String value) {
  if (value.isNotEmpty && value.length == 6)
    return null;
  else
    return "Enter Valid Details";
}

String? phoneNumberValidation(String value) {
  String pattern = r'(^(?:[+0]9)?[0-9]{10,12}$)';
  RegExp regExp = new RegExp(pattern);
  if (value.length == 0) {
    return 'Please enter mobile number';
  } else if (!regExp.hasMatch(value)) {
    return 'Please enter valid mobile number';
  }
  return null;
}

nameValidation(String s, String labelText) {
  return s.isNotEmpty ? null : 'Enter Valid $labelText';
}

emailValidation(String? s) {
  return s!.isNotEmpty ? null : 'Enter Valid Details';
}

void getSnackBar(BuildContext context, String message) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(message),
      duration: const Duration(seconds: 3),
      width: 280.0,
      padding: const EdgeInsets.symmetric(
        horizontal: 8.0,
      ),
    ),
  );
}

ThemeData buildThemeData() {
  return ThemeData(
      inputDecorationTheme: buildInputDecorationTheme(),
      backgroundColor: Colors.black,
      brightness: Brightness.light,
      primaryColor: Colors.blueAccent,
      buttonColor: Colors.blueAccent,
      accentColor: Colors.blueAccent,
      elevatedButtonTheme: defaultThemeForElevatedButton(),
      visualDensity: VisualDensity.adaptivePlatformDensity,
      appBarTheme: AppBarTheme(
          color: Colors.white,
          titleTextStyle: TextStyle(color: Colors.blueAccent),
          iconTheme: IconThemeData(color: Colors.blueAccent),
          foregroundColor: Colors.blueAccent,
          actionsIconTheme: IconThemeData(color: Colors.black)));
}

ElevatedButtonThemeData defaultThemeForElevatedButton() {
  return ElevatedButtonThemeData(
      style: ButtonStyle(foregroundColor:
          MaterialStateProperty.resolveWith<Color>((Set<MaterialState> states) {
    return Colors.white;
  }), backgroundColor:
          MaterialStateProperty.resolveWith<Color>((Set<MaterialState> states) {
    return Colors.blue;
  })));
}

InputDecorationTheme buildInputDecorationTheme() {
  return InputDecorationTheme(
    border: new OutlineInputBorder(
      borderRadius: BorderRadius.circular(10.0),
    ),
    labelStyle: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
    hintStyle: TextStyle(color: Colors.black, fontWeight: FontWeight.normal),
    enabledBorder: OutlineInputBorder(
      borderSide: BorderSide(color: Colors.black12, width: 1.0),
    ),
    focusedBorder: OutlineInputBorder(
      borderSide: BorderSide(color: Colors.black, width: 1.0),
    ),
  );
}

Widget getHeadingText(String s) {
  return Padding(
    padding: const EdgeInsets.all(8.0),
    child: Container(
      alignment: Alignment.centerLeft,
      child: Text(
        s,
        style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
      ),
    ),
  );
}

Widget getMainHeadingText(String s) {
  return Padding(
    padding: const EdgeInsets.all(8.0),
    child: Container(
      alignment: Alignment.centerLeft,
      child: Text(
        s,
        style: TextStyle(fontSize: 22.0, fontWeight: FontWeight.bold),
      ),
    ),
  );
}

Widget getSubmitButton(void Function() onSubmitted, {bool? isLast}) {
  return SizedBox(
    height: 50,
    child: ElevatedButton(
      child: Text((isLast ?? false) ? "Submit" : "Continue"),
      onPressed: onSubmitted,
    ),
  );
}

void navigateTo(BuildContext context, Widget widget) {
  Navigator.push(context, MaterialPageRoute(builder: (context) => widget));
}

List<String> statesListForDropDown = [
  "State",
  "Jammu & Kashmir",
  "Himachal Pradesh",
  "Punjab",
  "Chandigarh",
  "Uttarakhand",
  "Haryana",
  "Delhi",
  "Rajasthan",
  "Uttar Pradesh",
  "Bihar",
  "Sikkim",
  "Arunachal Pradesh",
  "Nagaland",
  "Manipur",
  "Mizoram",
  "Tripura",
  "Meghalaya",
  "Assam",
  "West Bengal",
  "Jharkhand",
  "Odisha",
  "Chhattisgarh",
  "Madhya Pradesh",
  "Gujarat",
  "Daman & Diu",
  "Dadra & Nagar Haveli",
  "Maharashtra",
  "Karnataka",
  'Goa',
  "Lakshadweep",
  "Kerala",
  "Tamil Nadu",
  "Pondicherry",
  "Andaman & Nicobar Islands",
  "Telangana",
  "Andhra Pradesh"
];
PreferredSizeWidget buildAppBar(String title) {
  return AppBar(
    title: const Text(
      "Medical Information Request Form",
      style: TextStyle(color: Colors.black),
    ),
    automaticallyImplyLeading: true,
  );
}

Widget getDateWidget(TextEditingController _controller, String labelText) {
  return Padding(
    padding: const EdgeInsets.all(8.0),
    child: DateTimeField(
      decoration: InputDecoration(
        labelText: labelText,
        border: new OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(width: 1.0),
        ),
      ),
      controller: _controller,
      format: DateFormat("dd-MM-yyyy"),
      validator: (DateTime? dateTime) {
        if (dateTime == null) {
          return "$labelText Required";
        } else
          return null;
      },
      onChanged: (date) {},
      onShowPicker: (context, currentValue) {
        return showDatePicker(
            context: context,
            firstDate: DateTime(1900),
            initialDate: DateTime.now(),
            lastDate: DateTime.now());
      },
    ),
  );
}

List<String> products = [
  '10 MG - Roszet',
  '20 MG - Roszet',
];

List<String> methodsOfResponse = [
  'Fax',
  'Mail',
  'Email',
  'Phone',
];
