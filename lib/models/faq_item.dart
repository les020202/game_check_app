class FaqItem {
  final String id;
  final String question;
  final String answer;
  final String tag;
  final int order;
  final DateTime createdAt;

  FaqItem({
    required this.id,
    required this.question,
    required this.answer,
    required this.tag,
    required this.order,
    required this.createdAt,
  });
}