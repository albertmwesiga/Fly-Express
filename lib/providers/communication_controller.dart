import 'package:flutter/foundation.dart';
import '../models/conversation_message.dart';
import '../services/messaging_service.dart';

/// Manages in-app communication between users and pilots
class CommunicationController with ChangeNotifier {
  final MessagingService _communicationService = MessagingService();
  
  Map<String, List<ConversationMessage>> _allChats = {};
  List<ConversationMessage> _currentChat = [];
  String? _currentChatPartner;
  int _unreadMessageCount = 0;
  bool _loadingChat = false;
  
  Map<String, List<ConversationMessage>> get allChats => _allChats;
  List<ConversationMessage> get currentChat => _currentChat;
  String? get currentChatPartner => _currentChatPartner;
  int get unreadMessageCount => _unreadMessageCount;
  bool get loadingChat => _loadingChat;
  
  Future<void> dispatchMessage({
    required String senderId,
    required String recipientId,
    required String messageText,
    String? linkedBookingId,
  }) async {
    try {
      final dispatchedMessage = await _communicationService.sendMessage(
        fromAccountId: senderId,
        toAccountId: recipientId,
        textContent: messageText,
        relatedReservationId: linkedBookingId,
      );
      
      if (_currentChatPartner == recipientId || _currentChatPartner == senderId) {
        _currentChat.add(dispatchedMessage);
        notifyListeners();
      }
      
      await retrieveAllChats(senderId);
    } catch (error) {
      debugPrint('Message dispatch failed: $error');
    }
  }
  
  Future<void> openChat({
    required String activeUserId,
    required String partnerId,
    String? bookingId,
  }) async {
    _loadingChat = true;
    _currentChatPartner = partnerId;
    notifyListeners();
    
    try {
      _currentChat = await _communicationService.fetchConversation(
        account1Id: activeUserId,
        account2Id: partnerId,
        reservationId: bookingId,
      );
      
      final unreadIds = _currentChat
        .where((msg) => msg.toAccountId == activeUserId && !msg.wasRead)
        .map((msg) => msg.messageId)
        .toList();
      
      if (unreadIds.isNotEmpty) {
        await _communicationService.markMessagesAsRead(unreadIds);
        await refreshUnreadCount(activeUserId);
      }
      
      _loadingChat = false;
      notifyListeners();
    } catch (error) {
      _loadingChat = false;
      notifyListeners();
      debugPrint('Chat loading failed: $error');
    }
  }
  
  Future<void> retrieveAllChats(String userId) async {
    try {
      _allChats = await _communicationService.fetchAllConversations(userId);
      notifyListeners();
    } catch (error) {
      debugPrint('Chats retrieval failed: $error');
    }
  }
  
  Future<void> refreshUnreadCount(String userId) async {
    try {
      _unreadMessageCount = await _communicationService.getUnreadCount(userId);
      notifyListeners();
    } catch (error) {
      debugPrint('Unread count update failed: $error');
    }
  }
  
  void closeCurrentChat() {
    _currentChat = [];
    _currentChatPartner = null;
    notifyListeners();
  }
}
