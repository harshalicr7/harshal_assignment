import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/chat_bloc.dart';

class MessageFormat extends StatelessWidget {
  const MessageFormat.first({
    super.key,
    required this.userImage,
    required this.username,
    required this.message,
    required this.isItMe,
  }) : isFirstInSequence = true;

  const MessageFormat.next({
    super.key,
    required this.message,
    required this.isItMe,
  })  : isFirstInSequence = false,
        userImage = null,
        username = null;

  final bool isFirstInSequence;

  final String? userImage;

  final String? username;
  final String message;

  final bool isItMe;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Stack(
      children: [
        if (userImage != null)
          Positioned(
            top: 15,
            right: isItMe ? 0 : null,
            child: CircleAvatar(
              backgroundImage: NetworkImage(
                userImage!,
              ),
              backgroundColor: const Color(0xFF1DB954),
              radius: 23,
            ),
          ),
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 46),
          child: Row(
            mainAxisAlignment:
                isItMe ? MainAxisAlignment.end : MainAxisAlignment.start,
            children: [
              Column(
                crossAxisAlignment:
                    isItMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
                children: [
                  if (isFirstInSequence) const SizedBox(height: 18),
                  if (username != null)
                    Padding(
                      padding: const EdgeInsets.only(
                        left: 13,
                        right: 13,
                      ),
                      child: Text(
                        username!,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                    ),
                  Container(
                    decoration: BoxDecoration(
                      color:
                          isItMe ? Colors.grey[300] : const Color(0xFF1DB954),
                      borderRadius: BorderRadius.only(
                        topLeft: !isItMe && isFirstInSequence
                            ? Radius.zero
                            : const Radius.circular(12),
                        topRight: isItMe && isFirstInSequence
                            ? Radius.zero
                            : const Radius.circular(12),
                        bottomLeft: const Radius.circular(12),
                        bottomRight: const Radius.circular(12),
                      ),
                    ),
                    constraints: const BoxConstraints(maxWidth: 200),
                    padding: const EdgeInsets.symmetric(
                      vertical: 10,
                      horizontal: 14,
                    ),
                    margin: const EdgeInsets.symmetric(
                      vertical: 4,
                      horizontal: 12,
                    ),
                    child: Text(
                      message,
                      style: TextStyle(
                        height: 1.3,
                        color: isItMe
                            ? Colors.black87
                            : theme.colorScheme.onSecondary,
                      ),
                      softWrap: true,
                    ),
                  ),
                ],
              ),
              if (isItMe && context.read<ChatBloc>().state is ChatSuccessState)
                const Padding(
                  padding: EdgeInsets.only(right: 7),
                  child: Icon(
                    Icons.check_outlined,
                    size: 12,
                    color: Color.fromARGB(255, 122, 166, 202),
                  ),
                )
              else if (isItMe)
                const Padding(
                  padding: EdgeInsets.only(right: 7),
                  child: Icon(
                    Icons.check_outlined,
                    size: 12,
                    color: Color.fromARGB(255, 122, 166, 202),
                  ),
                )
            ],
          ),
        ),
      ],
    );
  }
}
