import 'package:bhakti_bhoomi/constants/Constants.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SecureStorage {
  final FlutterSecureStorage storage = FlutterSecureStorage(aOptions: AndroidOptions(encryptedSharedPreferences: true, sharedPreferencesName: Constants.sharedPreferencesName));
  static final _instance = SecureStorage._();

  SecureStorage._() {}

  factory SecureStorage() {
    return _instance;
  }
}
