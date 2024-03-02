class ChatUserModel {
  final String id;
  final String imageUrl;
  final String name;
  final String lastMessage;
  final bool unread;
  final bool unreadCount;

  ChatUserModel(
      {required this.id,
      required this.imageUrl,
      required this.name,
      required this.lastMessage,
      required this.unread,
      required this.unreadCount});
}
