import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class UserRepository {
  final firebase = FirebaseAuth.instance;

  Future<dynamic> getUserInfo() async {
    final userInfo = await FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .get();

    return userInfo.data();
  }

  Future<dynamic> getAllUsers() async {
    final allUsers = await FirebaseFirestore.instance.collection('users').get();
    return allUsers.docs.map((e) => e.data()).toList();
  }

  Stream<dynamic> getOtherUser() {
    Stream<dynamic> allUsersStream =
        FirebaseFirestore.instance.collection('users').snapshots();

    // final otherUser = allUsers.docs
    //     .where((element) =>
    //         element.data()['email'] != FirebaseAuth.instance.currentUser!.email)
    //     .map((e) => e.data())
    //     .toList();

    return allUsersStream;
  }
}
