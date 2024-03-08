class ChatUserModel {
  final String id;
  final String imageUrl;
  final String name;
  final String dateTime;
  final String userId;
  final String uniquId;
  final String room;
  final String lastMessage;

  final int unreadCount;
  final String messageType;

  ChatUserModel(
      {required this.id,
      required this.imageUrl,
      required this.name,
      required this.dateTime,
      required this.room,
      required this.uniquId,
      required this.userId,
      required this.lastMessage,
      required this.unreadCount,
      required this.messageType});

  factory ChatUserModel.fromJson(Map<String, dynamic> json) {
    return ChatUserModel(
      id: json['id'] ?? '',
      imageUrl: json['profile_pic'] ?? '',
      name: json['username'] ?? '',
      lastMessage: json['message'] ?? '',
      dateTime: json['datetime'] ?? '',
      room: json['room'] ?? '',
      uniquId: json['unique_id'] ?? '',
      userId: json['user_id'] ?? '',
      messageType: json['message_type'],
      unreadCount: int.parse(json['unread_message']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'imageUrl': imageUrl,
      'name': name,
      'lastMessage': lastMessage,
      'messageType': messageType,
      'unreadCount': unreadCount,
    };
  }
}
