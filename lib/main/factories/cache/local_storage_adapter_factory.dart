import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:survey_flutter/infra/cache/cache.dart';

LocalStorageAdapter makeLocalStorageAdapter() {
  const secureStorage = FlutterSecureStorage();
  return LocalStorageAdapter(secureStorage: secureStorage);
}
