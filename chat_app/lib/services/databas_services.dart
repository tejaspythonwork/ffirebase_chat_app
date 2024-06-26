import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseServices {
  final String? uid;
  DatabaseServices({this.uid});

  final userCollection = FirebaseFirestore.instance.collection('users');
  final groupCollection = FirebaseFirestore.instance.collection('groups');

  Future saveUserData(
    String email,
    String fullName,
  ) async {
    return await userCollection.doc(uid).set({
      'fullName': fullName,
      'email': email,
      'groups': [],
      'profile_pic': "",
      'uid': uid,
    });
  }

  searchByName(String groupName) {
    return groupCollection.where('groupName', isEqualTo: groupName).get();
  }

  Future getUserData(String email) async {
    QuerySnapshot snapshot =
        await userCollection.where('email', isEqualTo: email).get();
    return snapshot;
  }

  Future createGroup({String? userName, String? id, String? groupName}) async {
    DocumentReference groupDocumentReference = await groupCollection.add(
      {
        "groupName": groupName,
        "admin": '${id}_$userName',
        "members": [],
        "recentMsg": "",
        "recentMsgSender": "",
        "groupId": "",
        "groupIcon": ""
      },
    );

    await groupDocumentReference.update(
      {
        "groupId": groupDocumentReference.id,
        "members": FieldValue.arrayUnion(['${uid}_$userName'])
      },
    );

    DocumentReference userDocumentReference = userCollection.doc(uid);
    return await userDocumentReference.update(
      {
        "groups": FieldValue.arrayUnion(
          ['${groupDocumentReference.id}_$groupName'],
        ),
      },
    );
  }

  getUserGroups() async {
    return userCollection.doc(uid).snapshots();
  }

  getGroupAdmin(String groupId) async {
    DocumentReference d = groupCollection.doc(groupId);
    DocumentSnapshot snapshot = await d.get();
    return snapshot['admin'];
  }

  getGroupMembers(String groupId) async {
    return groupCollection.doc(groupId).snapshots();
  }

  getChats(String groupId) async {
    return groupCollection
        .doc(groupId)
        .collection('messaages')
        .orderBy('time')
        .snapshots();
  }

  Future toggleGroupJoin({
    String? groupName,
    String? groupId,
    String? userName,
  }) async {
    DocumentReference userDocumentReference = userCollection.doc(uid);
    DocumentReference groupDocumentReference = groupCollection.doc(groupId);

    DocumentSnapshot documentSnapshot = await userDocumentReference.get();
    List<dynamic> groups = await documentSnapshot['groups'];

    if (groups.contains('${groupId}_$groupName}')) {
      await userDocumentReference.update(({
        'groups': FieldValue.arrayRemove(['${groupId}_$groupName'])
      }));
      log('Group will remove');
      await groupDocumentReference.update(({
        'members': FieldValue.arrayRemove(['${uid}_$userName'])
      }));
      log('Group will remove');
    } else {
      await userDocumentReference.update(
        ({
          'groups': FieldValue.arrayUnion(['${groupId}_$groupName']),
        }),
      );
      log('Group will create');
      await groupDocumentReference.update(
        ({
          'members': FieldValue.arrayUnion(['${uid}_$userName']),
        }),
      );
      log('Group will create');
    }
  }

  Future<bool> isUserJoined({
    required String groupName,
    required String userName,
    required String groupId,
  }) async {
    DocumentReference userDocReference = userCollection.doc(uid);
    DocumentSnapshot snapshot = await userDocReference.get();

    List<dynamic> groups = await snapshot['groups'];

    if (groups.contains('${groupId}_$groupName')) {
      return true;
    } else {
      return false;
    }
  }

  sendMessages({
    String? groupId,
    Map<String, dynamic>? chatMessageData,
  }) async {
    groupCollection.doc(groupId).collection('messages').add(chatMessageData!);
    groupCollection.doc(groupId).update({
      'recentMessage': chatMessageData['message'],
      'recentMessageSender': chatMessageData['sender'],
      'recentMessageTime': chatMessageData['time'].toString(),
    });
  }
}
