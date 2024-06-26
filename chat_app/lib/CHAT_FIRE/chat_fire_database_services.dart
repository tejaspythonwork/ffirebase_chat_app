import 'dart:async';
import 'dart:developer';

import 'package:chat_app/CHAT_FIRE/chat_fire_modal.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

const String personOfChats = "person";
const String personMessages = 'messages';
const String subCollection = 'messages';

class ChatFireServices {
  final fireStore = FirebaseFirestore.instance;
  late final CollectionReference myCharRef;

  ChatFireServices() {
    myCharRef = fireStore.collection(personOfChats).withConverter<UserData>(
          fromFirestore: (snapshot, _) => UserData.fromJson(snapshot.data()!),
          toFirestore: (userData, _) => userData.toJson(),
        );
  }

  Stream<QuerySnapshot> retriveData() {
    return myCharRef.snapshots();
  }

  addData(UserData userData) {
    return myCharRef.add(userData);
  }

  Future<List<String>> retrieveUserId() async {
    QuerySnapshot snapShot = await fireStore.collection(personOfChats).get();
    List<String> userIds =
        snapShot.docs.map((e) => e['userId'] as String).toList();
    return userIds;
  }

  sendMessages(Messages msg, String personId) {
    // return fireStore
    //     .collection(personOfChats)
    //     .doc('DC5bESfmm2UazH4bnQKF')
    //     .set(msg.toJson());
    CollectionReference messageSubCollection =
        myCharRef.doc(personId).collection(subCollection);
    messageSubCollection.add(msg.toJson());
  }

  fetchDocumentIds() async {
    QuerySnapshot snapshot = await fireStore.collection(personOfChats).get();
    List<String> docIds = [];

    for (DocumentSnapshot document in snapshot.docs) {
      docIds.add(document.id);
    }

    for (String id in docIds) {
      print(id);
    }
    return docIds;
  }

  fetchUserIdWithDocumentId() async {
    List<Map<String, dynamic>> tempList = [];
    QuerySnapshot mySnapshot = await fireStore.collection(personOfChats).get();

    for (DocumentSnapshot docSnapShot in mySnapshot.docs) {
      Map<String, dynamic> myData = docSnapShot.data() as Map<String, dynamic>;
      String userId = myData['userId'];
      String docid = docSnapShot.id;
      tempList.add({'userId': userId, 'docId': docid});
    }
    return tempList;
  }

  fetchMessages() async {
    List<Map<String, dynamic>> msgList = [];

    QuerySnapshot msgSnapShot = await fireStore
        .collection(personOfChats)
        .doc('BPoHqxWhAOg75EZuYcIw')
        .collection('messages')
        .get();
    for (DocumentSnapshot myMsgSnapShot in msgSnapShot.docs) {
      Map<String, dynamic> myMsgData =
          myMsgSnapShot.data() as Map<String, dynamic>;

      String msgContent = myMsgData['message'];
      String msgSender = myMsgData['fromUserId'];
      String msgReceiver = myMsgData['toUserId'];

      msgList.add({
        'msgContent': msgContent,
        'sender': msgSender,
        'receiver': msgReceiver
      });
    }
    return msgList;
  }

  Stream<List<Map<String, dynamic>>> getMessagesData() {
    StreamController<List<Map<String, dynamic>>> controller =
        StreamController<List<Map<String, dynamic>>>();

    final firestore = FirebaseFirestore.instance;
    List<Map<String, dynamic>> allMessages = [];

    firestore.collection('person').snapshots().listen(
      (personData) {
        for (DocumentSnapshot p in personData.docs) {
          p.reference.collection('messages').snapshots().listen(
            (msgData) {
              for (DocumentSnapshot md in msgData.docs) {
                allMessages.add(md.data() as Map<String, dynamic>);
              }
              controller.add(List<Map<String, dynamic>>.from(allMessages));
            },
          );
        }
      },
    );
    return controller.stream;
  }
}
