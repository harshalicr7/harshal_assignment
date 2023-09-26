import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';

class AuthRepository {
  final firebase = FirebaseAuth.instance;

  Future<void> signup(String email, String password, String userName,
      File selectedImage) async {
    try {
      var userCredentials = await firebase.createUserWithEmailAndPassword(
          email: email, password: password);
      final fbaseStoragePath = FirebaseStorage.instance
          .ref()
          .child('userimage')
          .child(
              '${userCredentials.user!.uid}.jpg'); //to determine the path where we want to upload the image

      await fbaseStoragePath.putFile(selectedImage); //to upload on firebase
      final imageUrl = await fbaseStoragePath
          .getDownloadURL(); //so that we can display the image in our app

      await FirebaseFirestore.instance
          .collection('users')
          .doc(userCredentials.user!.uid)
          .set({
        'username': userName,
        'email': email,
        'image_url': imageUrl,
        'status': false
      });
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak password') {
        throw Exception('This password is too weak');
      } else if (e.code == 'email-already-in-use') {
        throw Exception('The account already exists for that email');
      }
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  Future<void> login(String email, String password) async {
    try {
      final signedInUser = await firebase.signInWithEmailAndPassword(
          email: email, password: password);

      await FirebaseFirestore.instance
          .collection('users')
          .doc(signedInUser.user!.uid)
          .update({
        'status': true,
      });
    } on FirebaseAuthException catch (e) {
      if (e.code == 'wrong-password') {
        throw Exception('Will you check the password once?');
      } else if (e.code == 'user-not-found') {
        throw Exception('You ');
      }
    } catch (e) {
      throw Exception(e.toString());
    }
  }
}
