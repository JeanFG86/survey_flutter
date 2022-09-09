import 'package:http/http.dart';
import 'package:survey_flutter/data/http/http.dart';
import 'package:survey_flutter/infra/http/http.dart';

HttpClient makeHttpAdapter() {
  final client = Client();
  return HttpAdapter(client);
}
