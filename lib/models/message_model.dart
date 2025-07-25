class MessageModel {
  final String id;
  final String content;
  final String messageType;
  final String? fileUrl;
  final String senderId;

  MessageModel({
    required this.id,
    required this.content,
    required this.messageType,
    this.fileUrl,
    required this.senderId,
  });

  factory MessageModel.fromJson(Map<String, dynamic> json) {
    return MessageModel(
      id: json['_id'],
      content: json['content'] ?? '',
      messageType: json['messageType'] ?? 'text',
      fileUrl: json['fileUrl'],
      senderId: json['senderId'],
    );
  }
}
