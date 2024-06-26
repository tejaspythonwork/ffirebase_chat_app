import 'package:chat_app/controllers/helper_controllers.dart';
import 'package:chat_app/screens/group_info.dart';
import 'package:chat_app/screens/message_tile.dart';
import 'package:chat_app/services/databas_services.dart';
import 'package:chat_app/utils/utils.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ChatScreen extends StatefulWidget {
  final String groupName;
  final String groupId;
  final String userName;
  const ChatScreen({
    super.key,
    required this.groupName,
    required this.groupId,
    required this.userName,
  });

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  Stream<QuerySnapshot>? chats;
  User? user;
  String admin = '';
  final msgController = TextEditingController();
  final hController = Get.put(HelperController());
  String userName = '';
  getUserName() {
    hController.loadUserName().then((val) {
      setState(() {
        userName = val;
      });
    });
  }

  getChatsAndAdmin() async {
    DatabaseServices().getChats(widget.groupId).then((val) {
      setState(() {
        chats = val;
      });
    });

    DatabaseServices().getGroupAdmin(widget.groupId).then((val) {
      setState(() {
        admin = val;
      });
    });
  }

  @override
  void initState() {
    getChatsAndAdmin();
    getUserName();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.groupName),
        actions: [
          IconButton(
              onPressed: () {
                nextScreen(
                  GroupInfoScreen(
                    groupName: widget.groupName,
                    groupId: widget.groupId,
                    adminName: admin,
                  ),
                );
              },
              icon: const Icon(Icons.info)),
          IconButton(
              onPressed: () async {
                // await DatabaseServices().toggleGroupJoin(
                //   groupId: 'npXJuPZUHc12VQxT5Xyu',
                //   groupName: 'gr 1',
                //   userName: 'Ta3FSj3Z6KZBy19NdSTleEbc7kl2_Tejas Bhatt',
                // );
                // showSnackbar(context, Colors.green, 'Success');
              },
              icon: const Icon(Icons.exit_to_app))
        ],
      ),
      body: Stack(
        children: <Widget>[
          chatMessages(),
          Container(
            alignment: Alignment.bottomCenter,
            width: MediaQuery.of(context).size.width,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
              width: MediaQuery.of(context).size.width,
              color: Colors.grey[700],
              child: Row(children: [
                Expanded(
                    child: TextFormField(
                  controller: msgController,
                  style: const TextStyle(color: Colors.white),
                  decoration: const InputDecoration(
                    hintText: "Send a message...",
                    hintStyle: TextStyle(color: Colors.white, fontSize: 16),
                    border: InputBorder.none,
                  ),
                )),
                const SizedBox(
                  width: 12,
                ),
                GestureDetector(
                  onTap: () {
                    sendMessage();
                  },
                  child: Container(
                    height: 50,
                    width: 50,
                    decoration: BoxDecoration(
                      color: Theme.of(context).primaryColor,
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: const Center(
                        child: Icon(
                      Icons.send,
                      color: Colors.white,
                    )),
                  ),
                )
              ]),
            ),
          )
        ],
      ),
    );
  }

  Widget chatMessages() {
    return StreamBuilder(
      stream: chats,
      builder: (context, AsyncSnapshot snap) {
        return snap.hasData
            ? ListView.builder(
                itemCount: snap.data.docs.length,
                itemBuilder: (c, i) {
                  return MessageTile(message: 'a', sender: 'v', sentByMe: true);
                },
              )
            : const SizedBox(
                child: Text('No data'),
              );
      },
    );
  }

  sendMessage() {
    if (msgController.text.isNotEmpty) {
      Map<String, dynamic> chatMsgMap = {
        'message': msgController.text.trim(),
        'sender': widget.userName,
        'time': DateTime.now().millisecondsSinceEpoch
      };
      DatabaseServices().sendMessages(
        groupId: widget.groupId,
        chatMessageData: chatMsgMap,
      );
    }
  }
}
