// ignore_for_file: use_build_context_synchronously

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:newassn/application/pages/chat/bloc/chat_bloc.dart';
import 'package:newassn/application/pages/chat/widgets/chatmessages.dart';
import 'package:newassn/application/pages/chat/widgets/newmessage.dart';
import 'package:newassn/application/pages/login/login_screen.dart';

class ChatScreen extends StatelessWidget {
  final String name;
  const ChatScreen({super.key, required this.name});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ChatBloc(),
      child: Scaffold(
        appBar: AppBar(
          actions: [
            IconButton(
              onPressed: () async {
                await FirebaseFirestore.instance
                    .collection('users')
                    .doc(FirebaseAuth.instance.currentUser!.uid)
                    .update({
                  'status': false,
                });
                FirebaseAuth.instance.signOut();
                Navigator.of(context).push(
                  MaterialPageRoute(
                      builder: (context) => const LoginPageWrapperProvider()),
                );
              },
              icon: const Icon(Icons.logout),
            ),
          ],
          title: Text(name),
          backgroundColor: const Color(0xFF1DB954),
        ),
        body: const Column(
          children: [Expanded(child: ChatMessages()), NewMessage()],
        ),
      ),
    );
  }
}
