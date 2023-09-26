import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ChatRepository {
  Future<void> addNewMessage(
    String message,
  ) async {
    final user = FirebaseAuth.instance
        .currentUser!; //will give the current loggedin user, only works after login mode is complete

    final userData = await FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .get();

    FirebaseFirestore.instance.collection('chat').add(
      {
        'text': message,
        'createdAt': Timestamp.now(),
        'userId': user.uid,
        'userName': userData.data()!['username'],
        'userImage': userData.data()!['image_url'],
      },
    );
  }
}
