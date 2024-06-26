import 'dart:async';
//import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

Stream<List<Map<String, dynamic>>> getAllMessagesStream() {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  final StreamController<List<Map<String, dynamic>>> controller =
      StreamController<List<Map<String, dynamic>>>();

  final List<Map<String, dynamic>> allMessages = [];

  firestore.collection('person').snapshots().listen((personSnapshot) {
    for (var personDoc in personSnapshot.docs) {
      personDoc.reference
          .collection('messages')
          .snapshots()
          .listen((messageSnapshot) {
        for (var messageDoc in messageSnapshot.docs) {
          allMessages.add(messageDoc.data() as Map<String, dynamic>);
        }
        controller.add(List<Map<String, dynamic>>.from(allMessages));
      });
    }
  });

  return controller.stream;
}

class MessageContentScreen extends StatefulWidget {
  const MessageContentScreen({super.key});

  @override
  _MessageContentScreenState createState() => _MessageContentScreenState();
}

class _MessageContentScreenState extends State<MessageContentScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('All Messages'),
      ),
      body: StreamBuilder<List<Map<String, dynamic>>>(
        stream: getAllMessagesStream(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No messages found.'));
          } else {
            List<Map<String, dynamic>> allMessages = snapshot.data!;

            return ListView.builder(
              itemCount: allMessages.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(allMessages[index]['message'] ?? 'No content'),
                  // subtitle:
                  //     Text(allMessages[index]['sender'] ?? 'Unknown sender'),
                );
              },
            );
          }
        },
      ),
    );
  }
}
