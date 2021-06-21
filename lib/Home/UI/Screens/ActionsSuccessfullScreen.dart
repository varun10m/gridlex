import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:gridlex_assessment/Home/UI/HomeScreen.dart';

class ActionSuccessful extends StatefulWidget {
  final String message;

  ActionSuccessful(this.message);

  @override
  _ActionSuccessfulState createState() => _ActionSuccessfulState();
}

class _ActionSuccessfulState extends State<ActionSuccessful> {
  @override
  Widget build(BuildContext context) {
    return buildScaffold(context);
  }

  Scaffold buildScaffold(BuildContext context) {
    return Scaffold(
        body: Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: [
          Center(child: buildTopWidget(context)),
          buildSubmit(context)
        ],
      ),
    ));
  }

  Widget buildTopWidget(BuildContext context) {
    return Column(
      children: [
        buildSuccessLogo(),
        buildMessage(context),
      ],
    );
  }

  Padding buildSubmit(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: SizedBox(
        height: 50,
        child: ElevatedButton(
          child: Text(
            "Home",
          ),
          onPressed: () => navigateToHome(context),
        ),
      ),
    );
  }

  Padding buildMessage(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Text(
        widget.message,
        style: Theme.of(context).textTheme.headline6,
        textAlign: TextAlign.center,
      ),
    );
  }

  Widget buildSuccessLogo() {
    return Image.asset('assets/checkmark-transparent.gif');
  }

  void navigateToHome(BuildContext context) {
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => HomeScreen()));
  }
}
