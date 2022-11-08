import 'package:survey_flutter/main/factories/cache/cache.dart';
import 'package:survey_flutter/main/factories/http/http.dart';

import '../../../data/http/http.dart';
import '../../decorators/decorators.dart';

HttpClient makeAuthorizeHttpClientDecorator() =>
    AuthorizeHttpClientDecorator(fetchSecureCacheStorage: makeSecureStorageAdapter(), decoratee: makeHttpAdapter());
