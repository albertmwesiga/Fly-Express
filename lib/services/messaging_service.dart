import '../models/conversation_message.dart';
import 'package:uuid/uuid.dart';

/// Service for handling in-app chat between users and pilots
class MessagingService {
  static final MessagingService _singleton = MessagingService._internal();
  factory MessagingService() => _singleton;
  MessagingService._internal();
  
  final _uuid = const Uuid();
  final List<ConversationMessage> _messages = [];
  
  /// Send a message
  Future<ConversationMessage> sendMessage({
    required String fromAccountId,
    required String toAccountId,
    required String textContent,
    String? relatedReservationId,
    MessageType messageType = MessageType.text,
  }) async {
    await Future.delayed(const Duration(milliseconds: 400));
    
    final message = ConversationMessage(
      messageId: _uuid.v4(),
      fromAccountId: fromAccountId,
      toAccountId: toAccountId,
      textContent: textContent,
      sentAt: DateTime.now(),
      wasRead: false,
      relatedReservationId: relatedReservationId,
      messageType: messageType,
    );
    
    _messages.add(message);
    return message;
  }
  
  /// Get conversation between two accounts
  Future<List<ConversationMessage>> fetchConversation({
    required String account1Id,
    required String account2Id,
    String? reservationId,
  }) async {
    await Future.delayed(const Duration(milliseconds: 300));
    
    return _messages.where((msg) {
      final isInConversation = 
        (msg.fromAccountId == account1Id && msg.toAccountId == account2Id) ||
        (msg.fromAccountId == account2Id && msg.toAccountId == account1Id);
      
      if (reservationId != null) {
        return isInConversation && msg.relatedReservationId == reservationId;
      }
      return isInConversation;
    }).toList()..sort((a, b) => a.sentAt.compareTo(b.sentAt));
  }
  
  /// Mark messages as read
  Future<void> markMessagesAsRead(List<String> messageIds) async {
    await Future.delayed(const Duration(milliseconds: 200));
    
    for (var messageId in messageIds) {
      final index = _messages.indexWhere((m) => m.messageId == messageId);
      if (index != -1) {
        _messages[index] = _messages[index].markAsRead();
      }
    }
  }
  
  /// Get unread message count for an account
  Future<int> getUnreadCount(String accountId) async {
    await Future.delayed(const Duration(milliseconds: 150));
    
    return _messages.where((msg) => 
      msg.toAccountId == accountId && !msg.wasRead
    ).length;
  }
  
  /// Get all conversations for an account
  Future<Map<String, List<ConversationMessage>>> fetchAllConversations(String accountId) async {
    await Future.delayed(const Duration(milliseconds: 400));
    
    final Map<String, List<ConversationMessage>> conversations = {};
    
    for (var message in _messages) {
      if (message.fromAccountId == accountId || message.toAccountId == accountId) {
        final otherAccountId = message.fromAccountId == accountId 
          ? message.toAccountId 
          : message.fromAccountId;
        
        conversations.putIfAbsent(otherAccountId, () => []).add(message);
      }
    }
    
    return conversations;
  }
}
