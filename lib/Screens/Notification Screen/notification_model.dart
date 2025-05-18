class NotificationModel {
  final String notification_id;
  final String message;
  final bool isRead;
  final String createdAt;

  NotificationModel({
    required this.notification_id,
    required this.message,
    required this.isRead,
    required this.createdAt,
  });

  factory NotificationModel.fromJson(Map<String, dynamic> json) {
    return NotificationModel(
      notification_id: json['notification_id'],
      message: json['message'],
      isRead: json['is_read'] == '1',
      createdAt: json['created_at'],
    );
  }
}
