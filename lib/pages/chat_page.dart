// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:sample_chat_app/models/user_profile.dart';

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
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.chatUser.name!),
      ),
    );
  }
}
