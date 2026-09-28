class FaqItem {
  //final String id;
  final String tag;
  final String question;
  final String answer;
  bool isExpanded;
  //final int order;
  //final DateTime createdAt;

  FaqItem({
    //required this.id,
    required this.tag,
    required this.question,
    required this.answer,
    this.isExpanded = false,
    //required this.order,
    //required this.createdAt,
  });
}