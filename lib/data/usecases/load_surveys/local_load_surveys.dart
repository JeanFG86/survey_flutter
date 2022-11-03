import '../../../domain/entities/entities.dart';
import '../../../domain/helpers/helpers.dart';
import '../../cache/cache.dart';
import '../../models/models.dart';

class LocalLoadSurveys {
  final CacheStorage cacheStorage;

  LocalLoadSurveys({required this.cacheStorage});

  Future<List<SurveyEntity>> load() async {
    try {
      final data = await cacheStorage.fetch('surveys');
      if (data?.isEmpty != false) {
        throw Exception;
      }

      return _mapToEntity(data);
    } catch (error) {
      throw DomainError.unexpected;
    }
  }

  List<SurveyEntity> _mapToEntity(dynamic list) =>
      list.map<SurveyEntity>((json) => LocalSurveyModel.fromJson(json).toEntity()).toList();
}
