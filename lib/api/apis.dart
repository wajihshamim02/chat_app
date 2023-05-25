import 'dart:io';

import 'package:chat_app_firebase/model/chat_user_data.dart';
import 'package:chat_app_firebase/model/messagess.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';

class Apis {
  //for authentication
  static FirebaseAuth auth = FirebaseAuth.instance;

  //for accessing cloud firestore database
  static FirebaseFirestore firestore = FirebaseFirestore.instance;

  //for accessing firebase storage
  static FirebaseStorage storage = FirebaseStorage.instance;

  //for checking if user exists or not?
  static Future<bool> userExists() async {
    return (await firestore.collection('users').doc(user.uid).get()).exists;
  }

  static User get user => auth.currentUser!;

  //Store data in a cuttent user info in a variable
  static late chat_user_data me;

//for getting current user info
  static Future<void> getSelfinfo() async {
    await firestore.collection('users').doc(user.uid).get().then((user) {
      if (user.exists) {
        me = chat_user_data.fromJson(user.data()!);
      } else {
        CreateUser().then((value) => getSelfinfo());
      }
    });
  }

//for creating a new user

  static Future<void> CreateUser() async {
    //time for 'createdAt' and 'lastActive'
    final time = DateTime.now().millisecondsSinceEpoch.toString();

    final chatuser = chat_user_data(
      id: user.uid,
      name: user.displayName.toString(),
      email: user.email.toString(),
      about: 'hey i am using Whatsapp',
      image: user.photoURL.toString(),
      createdAt: time,
      isOnline: false,
      lastActive: time,
      pushToken: '',
    );

    //Create Users
    return await firestore
        .collection('users')
        .doc(user.uid)
        .set(chatuser.toJson());
  }

  //for getting all users for firebase database and our user are not added in app other users are added
  static Stream<QuerySnapshot<Map<String, dynamic>>> getAllusers() {
    return firestore
        .collection('users')
        .where('id', isNotEqualTo: user.uid)
        .snapshots();
  }

  // Update the user information in firebase
  static Future<void> UpdateUserInfo() async {
    await firestore
        .collection('users')
        .doc(user.uid)
        .update({'name': me.name, 'about': me.about});
  }

  // Update and Store image in Firebase
  static Future<void> storeimage(File file) async {
    // getting image file extension
    final ext = file.path.split('.').last;
    print('Extension: $ext');

    // it automatically creates a folder in firebase storage 'profilepicture' is a folder
    //storage file ref with path
    final ref = storage.ref().child('profilepicture/${user.uid}.$ext');

    //uploading image
    await ref
        .putFile(file, SettableMetadata(contentType: 'images/$ext'))
        .then((p0) {
      print('Data Transfered: ${p0.bytesTransferred / 1000} kb');
    });

    //update image in Firebase database
    me.image = await ref.getDownloadURL();
    await firestore.collection('users').doc(user.uid).update({
      'image': me.image,
    });
  }

  //888888888 Chat Screen Related API  888888888888 //

  // chats(collection) --> converation_id (doc) -->  messages (collection) --> messages (doc)

  //userfull for getting conversation id
  static String getConversationID(String id) => user.uid.hashCode <= id.hashCode
      ? '${user.uid}_$id'
      : '${id}_${user.uid}';

  //for getting all messages of a specific conversation from firestore database
  static Stream<QuerySnapshot<Map<String, dynamic>>> getAllMessages(
      chat_user_data user) {
    return firestore
        .collection('chats/${getConversationID(user.id)}/messages/')
        .snapshots();
  }

  //for sending message
  static Future<void> sendMessage(chat_user_data chatuser, String msg) async {
    //message sending time also used as id
    final time = DateTime.now().millisecondsSinceEpoch.toString();

    //message to send
    final Messages message = Messages(
        msg: msg,
        read: '',
        told: chatuser.id,
        type: Typess.text,
        fromid: user.uid,
        sent: time);

    final ref = firestore
        .collection('chats/${getConversationID(chatuser.id)}/messages/');

    await ref.doc(time).set(message.toJson());
  }

  //update read status time
  static Future<void> updateMessageReadStatus(Messages message) async {
    firestore
        .collection('chats/${getConversationID(message.fromid!)}/messages/')
        .doc(message.sent)
        .update({'read': DateTime.now().millisecondsSinceEpoch.toString()});
  }

  //get only last message of a specific chat
  static Stream<QuerySnapshot<Map<String, dynamic>>> getLastMessage(
      chat_user_data user) {
    return firestore
        .collection('chats/${getConversationID(user.id)}/messages/')
        .orderBy('sent',descending: true) // show last message
        .limit(1) // show only 1 message
        .snapshots();
  }

}

