import 'dart:io';

import 'package:chat/core/models/chat_message.dart';
import 'package:flutter/material.dart';

class MessageBubble extends StatelessWidget {
  final ChatMessage message;
  final _defaultImage = 'assets/images/avatar.png';
  final bool belongsCurrentUser;

  const MessageBubble({
    Key? key,
    required this.message,
    required this.belongsCurrentUser,
  }) : super(key: key);

  Widget _showUserImage(String imageUrl) {
    ImageProvider? provider;
    final uri = Uri.parse(imageUrl);
    if (uri.path.contains(_defaultImage)) {
      provider = AssetImage(uri.path.toString());
    } else if (uri.scheme.contains('http')) {
      provider = NetworkImage(uri.toString());
    } else {
      provider = FileImage(File(uri.toString()));
    }

    return CircleAvatar(
      backgroundColor: Colors.pink,
      backgroundImage: provider,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Row(
          mainAxisAlignment: belongsCurrentUser
              ? MainAxisAlignment.end
              : MainAxisAlignment.start,
          children: [
            Container(
              decoration: BoxDecoration(
                  color: belongsCurrentUser
                      ? Colors.grey.shade300
                      : Theme.of(context).colorScheme.primary,
                  borderRadius: BorderRadius.only(
                    topLeft: const Radius.circular(12),
                    topRight: const Radius.circular(12),
                    bottomLeft: belongsCurrentUser
                        ? const Radius.circular(12)
                        : const Radius.circular(0),
                    bottomRight: belongsCurrentUser
                        ? const Radius.circular(0)
                        : const Radius.circular(12),
                  )),
              width: 180,
              margin: const EdgeInsets.symmetric(vertical: 15, horizontal: 8),
              padding: const EdgeInsets.symmetric(
                vertical: 10,
                horizontal: 16,
              ),
              child: Column(
                crossAxisAlignment: belongsCurrentUser
                    ? CrossAxisAlignment.end
                    : CrossAxisAlignment.start,
                children: [
                  Text(
                    message.userName,
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color:
                            belongsCurrentUser ? Colors.black : Colors.white),
                  ),
                  Text(
                    message.text,
                    textAlign:
                        belongsCurrentUser ? TextAlign.right : TextAlign.left,
                    style: TextStyle(
                        color:
                            belongsCurrentUser ? Colors.black : Colors.white),
                  )
                ],
              ),
            ),
          ],
        ),
        Positioned(
          top: 0,
          left: belongsCurrentUser ? null : 165,
          right: belongsCurrentUser ? 165 : null,
          child: _showUserImage(message.userImageUrl),
        ),
      ],
    );
  }
}
