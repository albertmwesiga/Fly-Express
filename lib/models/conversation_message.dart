/// Communication message between users and pilots
class ConversationMessage {
  final String messageId;
  final String fromAccountId;
  final String toAccountId;
  final String textContent;
  final DateTime sentAt;
  final bool wasRead;
  final String? relatedReservationId;
  final MessageType messageType;
  
  ConversationMessage({
    required this.messageId,
    required this.fromAccountId,
    required this.toAccountId,
    required this.textContent,
    required this.sentAt,
    this.wasRead = false,
    this.relatedReservationId,
    this.messageType = MessageType.text,
  });
  
  Map<String, dynamic> serialize() => {
    'messageId': messageId,
    'fromAccountId': fromAccountId,
    'toAccountId': toAccountId,
    'textContent': textContent,
    'sentAt': sentAt.millisecondsSinceEpoch,
    'wasRead': wasRead,
    'relatedReservationId': relatedReservationId,
    'messageType': messageType.name,
  };
  
  factory ConversationMessage.deserialize(Map<String, dynamic> data) {
    return ConversationMessage(
      messageId: data['messageId'],
      fromAccountId: data['fromAccountId'],
      toAccountId: data['toAccountId'],
      textContent: data['textContent'],
      sentAt: DateTime.fromMillisecondsSinceEpoch(data['sentAt']),
      wasRead: data['wasRead'] ?? false,
      relatedReservationId: data['relatedReservationId'],
      messageType: MessageType.values.byName(data['messageType'] ?? 'text'),
    );
  }
  
  ConversationMessage markAsRead() {
    return ConversationMessage(
      messageId: messageId,
      fromAccountId: fromAccountId,
      toAccountId: toAccountId,
      textContent: textContent,
      sentAt: sentAt,
      wasRead: true,
      relatedReservationId: relatedReservationId,
      messageType: messageType,
    );
  }
}

enum MessageType {
  text,
  systemNotification,
  locationShare,
}
