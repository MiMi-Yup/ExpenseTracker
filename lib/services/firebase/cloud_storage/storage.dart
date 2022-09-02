import 'dart:io';
import 'dart:typed_data';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:path/path.dart';

class ActionFirebaseStorage {
  static UploadTask uploadFile(File file, String pathStorage) {
    return FirebaseStorage.instance.ref().child(pathStorage).putFile(file);
  }

  static Future<Uint8List?> downloadFile(String pathStorage) {
    return FirebaseStorage.instance.ref().child(pathStorage).getData();
  }
}
