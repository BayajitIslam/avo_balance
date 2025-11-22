// models/notification_model.dart
class NotificationModel {
  final String id;
  final String title;
  final String message;
  final String time;
  final String icon;
  final bool isResponded;
  final String? responseType; // 'yes' or 'no'

  NotificationModel({
    required this.id,
    required this.title,
    required this.message,
    required this.time,
    required this.icon,
    this.isResponded = false,
    this.responseType,
  });
}
