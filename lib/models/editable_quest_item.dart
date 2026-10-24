import 'package:uuid/uuid.dart';

class EditableQuestItem {
  String? id; // null이면 신규 생성 항목
  final String uiKey = const Uuid().v4(); // 화면 위젯 식별용
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