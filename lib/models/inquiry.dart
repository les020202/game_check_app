import 'inquiry_status.dart';

class Inquiry {
  final String id;
  final String userId;
  final String contactEmail;
  final String title;
  final String content;
  final String tag;
  final InquiryStatus status;
  final DateTime createdAt;

  Inquiry({
    required this.id,
    required this.userId,
    required this.contactEmail,
    required this.title,
    required this.content,
    required this.tag,
    required this.status,
    required this.createdAt,
  });
}