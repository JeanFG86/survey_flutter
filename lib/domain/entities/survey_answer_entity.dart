class SurveyAnswerEntity {
  final String? image;
  final String answer;
  final bool isCurrentAnwer;
  final int percent;

  const SurveyAnswerEntity({
    this.image,
    required this.answer,
    required this.isCurrentAnwer,
    required this.percent,
  });
}
