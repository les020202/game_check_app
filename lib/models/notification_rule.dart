import 'package:uuid/uuid.dart';

class NotificationRule {
  final String id;
  final String? userId;
  final List<String> gameIds;
  final int notifyHour;
  final int notifyMinute;
  final bool isEnabled;

  NotificationRule({
    String? id,
    this.userId,
    required this.gameIds,
    required this.notifyHour,
    required this.notifyMinute,
    required this.isEnabled,
  }) : id = id ?? const Uuid().v4();
}