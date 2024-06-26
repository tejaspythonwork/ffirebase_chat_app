import 'dart:developer';

import 'package:chat_app/controllers/helper_controllers.dart';
import 'package:chat_app/screens/chat_screen.dart';
import 'package:chat_app/screens/group_tile.dart';
import 'package:chat_app/services/databas_services.dart';
import 'package:chat_app/utils/utils.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final hController = Get.find<HelperController>();
  String userName = '';
  TextEditingController searchController = TextEditingController();
  bool isLoading = false;
  QuerySnapshot? searchSnapshot;
  bool hasUserSearched = false;
  User? user;
  bool isJoined = false;
  @override
  void initState() {
    super.initState();
    getUserIdAndName();
  }

  Future<String> getUserIdAndName() async {
    userName = await hController.loadUserName();
    user = FirebaseAuth.instance.currentUser;
    return userName;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Theme.of(context).primaryColor,
        title: const Text(
          "Search",
          style: TextStyle(
              fontSize: 27, fontWeight: FontWeight.bold, color: Colors.white),
        ),
      ),
      body: Column(
        children: [
          Container(
            color: Theme.of(context).primaryColor,
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: searchController,
                    style: const TextStyle(color: Colors.white),
                    decoration: const InputDecoration(
                        border: InputBorder.none,
                        hintText: "Search groups....",
                        hintStyle:
                            TextStyle(color: Colors.white, fontSize: 16)),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    initiateSearchMethod();
                  },
                  child: Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(40)),
                    child: const Icon(
                      Icons.search,
                      color: Colors.white,
                    ),
                  ),
                )
              ],
            ),
          ),
          isLoading
              ? const Center(
                  child: CircularProgressIndicator(
                  color: Colors.green,
                ))
              : groupList()
        ],
      ),
    );
  }

  initiateSearchMethod() async {
    if (searchController.text.isNotEmpty) {
      setState(() {
        isLoading = true;
      });

      await DatabaseServices()
          .searchByName(searchController.text.trim())
          .then((snap) {
        setState(() {
          searchSnapshot = snap;
          isLoading = false;
          hasUserSearched = true;
        });
        log('=====Group Found=====');
      });
    }
  }

  groupList() {
    return hasUserSearched
        ? ListView.builder(
            shrinkWrap: true,
            itemCount: searchSnapshot?.docs.length,
            itemBuilder: (c, i) {
              return groupTile(
                userName: userName,
                groupId: searchSnapshot?.docs[i]['groupId'],
                groupName: searchSnapshot?.docs[i]['groupName'],
                admin: searchSnapshot?.docs[i]['admin'],
              );
            },
          )
        : Container();
  }

  Widget groupTile({
    required String userName,
    required String groupId,
    required String groupName,
    required String admin,
  }) {
    joinedOrNot(userName, groupId, groupName, admin);
    return ListTile(
      tileColor: Colors.blue.shade100,
      contentPadding: const EdgeInsets.all(10),
      title: Text(
        groupName,
        style: TextStyle(
            color: Colors.greenAccent.shade200, fontWeight: FontWeight.w500),
      ),
      subtitle: Text(admin),
      leading: CircleAvatar(
        child: Text(
          groupName.toUpperCase(),
          style: const TextStyle(fontSize: 5),
        ),
      ),
      trailing: InkWell(
        onTap: () async {
          await DatabaseServices(uid: user?.uid).toggleGroupJoin(
            groupId: groupId,
            groupName: groupName,
            userName: userName,
          );
          if (isJoined) {
            setState(() {
              isJoined = true;
            });
            showSnackbar(context, Colors.green, 'Joined Group Success');
            Future.delayed(
                const Duration(
                  seconds: 1,
                ), () {
              Get.to(ChatScreen(
                groupName: groupName,
                groupId: groupId,
                userName: userName,
              ));
            });
          } else {
            setState(() {
              isJoined = false;
            });
            showSnackbar(context, Colors.red, 'Left The Group $groupName');
          }
          
        },
        child: isJoined
            ? Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.black,
                  border: Border.all(color: Colors.white, width: 1),
                ),
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                child: const Text(
                  "Joined",
                  style: TextStyle(color: Colors.white),
                ),
              )
            : Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Theme.of(context).primaryColor,
                ),
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                child: const Text("Join Now",
                    style: TextStyle(color: Colors.white)),
              ),
      ),
    );
  }

  joinedOrNot(
    String userName,
    String groupId,
    String groupName,
    String admin,
  ) async {
    await DatabaseServices(uid: user?.uid)
        .isUserJoined(
            groupName: groupName, userName: userName, groupId: groupId)
        .then(
      (val) {
        setState(() {
          isJoined = val;
        });
      },
    );
  }
}
