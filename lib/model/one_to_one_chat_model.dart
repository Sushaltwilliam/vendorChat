class OneToOneChatModel {
  final String id;
  final DateTime createdDate;
  final String senderId;
  final String reciverId;
  final String type;
  final String message;
  final String messageType;
  final String duration;
  final String messageStatus;
  final String room;
  final String replyId;
  final String replyMessage;
  final String replyMessageType;
  final String replyMessageSender;
  final String replyDuration;
  final String replyFile;
  final String forwardId;
  final String forwardCount;
  final String optionalText;
  final String thumNail;
  final String fileSize;

  OneToOneChatModel(
      {required this.id,
      required this.createdDate,
      required this.senderId,
      required this.reciverId,
      required this.type,
      required this.message,
      required this.messageType,
      required this.duration,
      required this.messageStatus,
      required this.room,
      required this.replyId,
      required this.replyMessage,
      required this.replyMessageType,
      required this.replyMessageSender,
      required this.replyDuration,
      required this.replyFile,
      required this.forwardId,
      required this.forwardCount,
      required this.optionalText,
      required this.thumNail,
      required this.fileSize});
}
// final String id;
//   final String userName;
//   final String imageUrl;
//   final String userBlockStatus;
//   final String uniqeId;