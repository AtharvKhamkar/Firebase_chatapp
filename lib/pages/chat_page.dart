// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dash_chat_2/dash_chat_2.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:sample_chat_app/models/chat.dart';
import 'package:sample_chat_app/models/message.dart';
import 'package:sample_chat_app/models/user_profile.dart';
import 'package:sample_chat_app/services/auth_services.dart';
import 'package:sample_chat_app/services/database_service.dart';
import 'package:sample_chat_app/services/media_service.dart';
import 'package:sample_chat_app/services/storage_service.dart';
import 'package:sample_chat_app/utils.dart';

class ChatPage extends StatefulWidget {
  final UserProfile chatUser;
  const ChatPage({
    Key? key,
    required this.chatUser,
  }) : super(key: key);

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final GetIt _getIt = GetIt.instance;
  late AuthService _authService;
  late DatabaseService _databaseService;
  late MediaService _mediaService;
  late StorageService _storageService;

  ChatUser? currentUser, otherUser;

  @override
  void initState() {
    super.initState();
    _authService = _getIt.get<AuthService>();
    _databaseService = _getIt.get<DatabaseService>();
    _mediaService = _getIt.get<MediaService>();
    _storageService = _getIt.get<StorageService>();
    currentUser = ChatUser(
        id: _authService.user!.uid, firstName: _authService.user!.displayName);

    otherUser = ChatUser(
        id: widget.chatUser.uid!,
        firstName: widget.chatUser.name,
        profileImage: widget.chatUser.pfpURL);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.chatUser.name!),
      ),
      body: _buildUI(),
    );
  }

  Widget _buildUI() {
    return StreamBuilder(
      stream: _databaseService.getChatData(currentUser!.id, otherUser!.id),
      builder: (context, snapshot) {
        Chat? chat = snapshot.data?.data();
        List<ChatMessage> message = [];
        if (chat != null && chat.messages != null) {
          message = _generateChatMessageList(chat.messages!);
        }
        return DashChat(
            messageOptions: const MessageOptions(
              showOtherUsersAvatar: true,
              showTime: true,
            ),
            inputOptions: InputOptions(alwaysShowSend: true, leading: [
              _mediaMessageButton(),
            ]),
            currentUser: currentUser!,
            onSend: (message) {
              _sendMessgae(message);
            },
            messages: message);
      },
    );
  }

  Future<void> _sendMessgae(ChatMessage chatMessage) async {
    if (chatMessage.medias?.isNotEmpty ?? false) {
      if (chatMessage.medias!.first.type == MediaType.image) {
        Message message = Message(
          senderID: currentUser!.id,
          content: chatMessage.medias!.first.url,
          messageType: MessageType.Image,
          sentAt: Timestamp.fromDate(chatMessage.createdAt),
        );
        await _databaseService.sendChatMessage(
            currentUser!.id, otherUser!.id, message);
      }
    } else {
      Message message = Message(
        senderID: currentUser!.id,
        content: chatMessage.text,
        messageType: MessageType.Text,
        sentAt: Timestamp.fromDate(chatMessage.createdAt),
      );

      await _databaseService.sendChatMessage(
          currentUser!.id, otherUser!.id, message);
    }
  }

  List<ChatMessage> _generateChatMessageList(List<Message> messages) {
    List<ChatMessage> chatMessages = messages.map(
      (m) {
        if (m.messageType == MessageType.Image) {
          return ChatMessage(
            user: m.senderID == currentUser!.id ? currentUser! : otherUser!,
            medias: [
              ChatMedia(url: m.content!, fileName: '', type: MediaType.image)
            ],
            createdAt: m.sentAt!.toDate(),
          );
        } else {
          return ChatMessage(
            user: m.senderID == currentUser!.id ? currentUser! : otherUser!,
            text: m.content!,
            createdAt: m.sentAt!.toDate(),
          );
        }
      },
    ).toList();
    chatMessages.sort(
      (a, b) {
        return b.createdAt.compareTo(a.createdAt);
      },
    );
    return chatMessages;
  }

  Widget _mediaMessageButton() {
    return IconButton(
      onPressed: () async {
        File? file = await _mediaService.getImageFromGallery();
        if (file != null) {
          String chatID =
              generateChatID(uid1: currentUser!.id, uid2: otherUser!.id);
          String? downloadURL = await _storageService.uploadImageToChat(
            file: file,
            chatID: chatID,
          );
          if (downloadURL != null) {
            ChatMessage chatMessage = ChatMessage(
              user: currentUser!,
              createdAt: DateTime.now(),
              medias: [
                ChatMedia(url: downloadURL, fileName: '', type: MediaType.image)
              ],
            );
            _sendMessgae(chatMessage);
          }
        }
      },
      icon: const Icon(Icons.attach_file_rounded),
      color: Theme.of(context).colorScheme.primary,
    );
  }
}
