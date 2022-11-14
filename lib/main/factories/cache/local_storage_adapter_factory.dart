import 'package:localstorage/localstorage.dart';
import 'package:survey_flutter/infra/cache/cache.dart';

LocalStorageAdapter makeLocalStorageAdapter() => LocalStorageAdapter(localStorage: LocalStorage('surveys'));
