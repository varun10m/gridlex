import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:gridlex_assessment/Home/Model/HealthCareInformation.dart';
import 'package:path_provider/path_provider.dart';

class StorageSource {
  static StorageSource? _instance;
  FirebaseStorage _storage = FirebaseStorage.instance;

  static StorageSource? getInstance() {
    if (_instance == null) _instance = new StorageSource();
    return _instance;
  }

  Future<String> saveImageToStorage(
      HealthCareInformation medicalFormModel) async {
    Uint8List bytes = base64.decode(medicalFormModel.url!);
    String dir = (await getApplicationDocumentsDirectory()).path;
    File file = File(
        "$dir/" + DateTime.now().millisecondsSinceEpoch.toString() + ".png");
    await file.writeAsBytes(bytes);
    Reference storageReference = _storage.ref().child("images/");
    UploadTask uploadTask = storageReference
        .child(
            medicalFormModel.designation! + " " + medicalFormModel.firstName!)
        .putFile(file);
    await uploadTask;
    if (uploadTask.snapshot.state == TaskState.success) {
      print("State == success");
      return uploadTask.snapshot.ref.getDownloadURL();
    } else {
      print("State != success");
      return "NA";
    }
  }
}
