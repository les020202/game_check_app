class EditableQuestItem {
  String? id; // null이면 신규 생성 항목
  String name;
  String? memo;
  int? dueMonth;
  int? dueDay;

  EditableQuestItem({
    this.id,
    required this.name,
    this.memo,
    this.dueMonth,
    this.dueDay,
  });
}