import 'package:chat_app/screens/home_screen.dart';
import 'package:chat_app/services/databas_services.dart';
import 'package:chat_app/utils/utils.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class GroupInfoScreen extends StatefulWidget {
  final String groupName;
  final String groupId;
  final String adminName;

  const GroupInfoScreen({
    super.key,
    required this.groupName,
    required this.groupId,
    required this.adminName,
  });

  @override
  State<GroupInfoScreen> createState() => _GroupInfoScreenState();
}

class _GroupInfoScreenState extends State<GroupInfoScreen> {
  Stream? member;
  fetchGroupMembers() async {
    await DatabaseServices(uid: FirebaseAuth.instance.currentUser?.uid)
        .getGroupMembers(widget.groupId)
        .then(
      (val) {
        setState(() {
          member = val;
        });
      },
    );
  }

  String getName(String r) {
    return r.substring(r.indexOf('_') + 1);
  }

  String getId(String r) {
    return r.substring(0, r.indexOf('_'));
  }

  @override
  void initState() {
    fetchGroupMembers();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Group Info'),
        actions: [
          IconButton(
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) {
                  return AlertDialog(
                    title: const Text('Exit'),
                    content: const Text('Are You Sure Want To exit?'),
                    actions: [
                      IconButton(
                          onPressed: () {
                            Get.back();
                          },
                          icon: const Icon(Icons.arrow_back)),
                      IconButton(
                          onPressed: () {
                            DatabaseServices(
                                    uid: FirebaseAuth.instance.currentUser?.uid)
                                .toggleGroupJoin(
                                    groupId: widget.groupId,
                                    groupName: widget.groupName,
                                    userName: getName(widget.adminName))
                                .whenComplete(() {
                              Get.to(() => const HomeScreen());
                            });
                          },
                          icon: const Icon(Icons.done))
                    ],
                  );
                },
              );
            },
            icon: const Icon(Icons.exit_to_app),
          ),
          
        ],
      ),
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(30),
                  color: Theme.of(context).primaryColor.withOpacity(0.2)),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  CircleAvatar(
                    radius: 30,
                    backgroundColor: Theme.of(context).primaryColor,
                    child: Text(
                      widget.groupName.substring(0, 1).toUpperCase(),
                      style: const TextStyle(
                          fontWeight: FontWeight.w500, color: Colors.white),
                    ),
                  ),
                  const SizedBox(
                    width: 20,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Group: ${widget.groupName}",
                        style: const TextStyle(fontWeight: FontWeight.w500),
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      Text("Admin: ${getName(widget.adminName)}")
                    ],
                  )
                ],
              ),
            ),
            memberList()
          ],
        ),
      ),
    );
  }

  Widget memberList() {
    return StreamBuilder(
      stream: member,
      builder: (c, AsyncSnapshot snap) {
        if (snap.hasData) {
          if (snap.data['members'] != null) {
            if (snap.data['members'].length != 0) {
              return Expanded(
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: snap.data['members'].length,
                  itemBuilder: (c, i) {
                    return Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 5, vertical: 10),
                      child: ListTile(
                        leading: CircleAvatar(
                          radius: 30,
                          backgroundColor: Theme.of(context).primaryColor,
                          child: Text(
                            getName(snap.data['members'][i]).toUpperCase(),
                            style: const TextStyle(
                                color: Colors.white,
                                fontSize: 15,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                        title: Text(getName(snap.data['members'][i])),
                        subtitle: Text(getId(snap.data['members'][i])),
                      ),
                    );
                  },
                ),
              );
            }
          } else {
            return const Center(
              child: Text('No Members'),
            );
          }
        }
        return Container();
      },
    );
  }
}
