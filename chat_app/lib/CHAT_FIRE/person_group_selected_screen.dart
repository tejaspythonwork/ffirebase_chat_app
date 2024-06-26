import 'dart:developer';

import 'package:chat_app/CHAT_FIRE/chat_fire_database_services.dart';
import 'package:chat_app/CHAT_FIRE/chat_fire_modal.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class PersonSelectScreen extends StatefulWidget {
  const PersonSelectScreen({super.key});

  @override
  State<PersonSelectScreen> createState() => _PersonSelectScreenState();
}

class _PersonSelectScreenState extends State<PersonSelectScreen> {
  ChatFireServices chatFireServices = ChatFireServices();
  List<String> userIdOfPerson = [];
  String? selectedFromUserId;
  String? selectedTouserId;
  TextEditingController msgController = TextEditingController();
  List<String> myUserDocIds = [];
  List<Map<String, dynamic>> userIdWithDocId = [];
  getUsersIList() async {
    List<String> userIds = await chatFireServices.retrieveUserId();
    setState(() {
      userIdOfPerson = userIds;
    });
  }

  getUserDocumentIds() async {
    List<String> docids = await chatFireServices.fetchDocumentIds();
    setState(() {
      myUserDocIds = docids;
    });
    log('======');
    log('my document ids are below');
    for (int i = 0; i < myUserDocIds.length; i++) {
      log(myUserDocIds[i]);
    }
    return docids;
  }

  fetchUserIdWithDocumentId() async {
    log('==========');
    userIdWithDocId = await chatFireServices.fetchUserIdWithDocumentId();
    for (int i = 0; i < userIdWithDocId.length; i++) {
      log('${userIdWithDocId[i]['docId']} and ${userIdWithDocId[i]['userId']}');
    }
    log('Data Has Been Fetched');
  }

  @override
  void initState() {
    getUsersIList();
    getUserDocumentIds();
    fetchUserIdWithDocumentId();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Select Person/Group'),
      ),
      body: SingleChildScrollView(
        child: Container(
          height: 500,
          width: double.maxFinite,
          child: Column(
            children: [
              const Text('Select User Who will Send Message'),
              DropdownButtonFormField(
                value: selectedFromUserId,
                items: userIdWithDocId.map((users) {
                  return DropdownMenuItem<String>(
                      value: users['docId'], child: Text(users['userId']));
                }).toList(),
                onChanged: (val) {
                  setState(() {
                    selectedFromUserId = val;
                  });
                  log(val.toString());
                },
              ),
              const SizedBox(
                height: 65,
              ),
              const Text('Select User Who will receive message'),
              DropdownButtonFormField(
                value: selectedTouserId,
                items: userIdWithDocId.map((userss) {
                  return DropdownMenuItem(
                      value: userss['docId'], child: Text(userss['userId']));
                }).toList(),
                onChanged: (val) {
                  setState(() {
                    selectedTouserId = val as String?;
                  });
                  log(val.toString());
                },
              ),
              const SizedBox(
                height: 50,
              ),
              TextFormField(
                controller: msgController,
                decoration: const InputDecoration(
                    hintText: 'Describe Your Message Here'),
              ),
              const SizedBox(
                height: 85,
              ),
              ElevatedButton(
                  onPressed: () {
                    Messages msg = Messages(
                      fromUserId: selectedFromUserId!,
                      messageSendingTime: Timestamp.now(),
                      message: msgController.text.trim(),
                      toUserId: selectedTouserId!,
                    );
                    log('--- Data ---');
                    log(msg.fromUserId);
                    log(msg.toUserId);
                    log(msg.message);
                    log(msg.messageSendingTime.toString());

                    chatFireServices.sendMessages(msg, msg.toUserId);
                    chatFireServices.sendMessages(msg, msg.fromUserId);
                  },
                  child: const Text('Send Message'))
            ],
          ),
        ),
      ),
    );
  }
}
