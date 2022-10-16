abstract class SurveysPresenter {
  Future<void> loadData();

  Stream<bool> get isLoadingStream;
}
