class NotificationModel {
  String? id;
  String? title;
  String? message;
  String? date;
  bool? isRead;
  String? coverPictureUrl;

  NotificationModel(
      {this.id,
      this.title,
      this.message,
      this.date,
      this.isRead,
      this.coverPictureUrl});

  factory NotificationModel.fromJson(Map<String, dynamic> json) {
    return NotificationModel(
      id: json['id']?.toString(),
      title: json['title']?.toString(),
      message: json['notificationText']?.toString(),
      date: json['createdAt']?.toString(),
      isRead: json['isRead'] ?? false,
      coverPictureUrl: json['coverPictureUrl']?.toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'message': message,
      'date': date,
      'isRead': isRead,
      'coverPictureUrl': coverPictureUrl
    };
  }
}
