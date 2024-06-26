import 'package:chat_app/CHAT_FIRE/chat_fire_database_services.dart';
import 'package:chat_app/CHAT_FIRE/chat_fire_modal.dart';
import 'package:chat_app/CHAT_FIRE/chat_fire_screen.dart';
import 'package:chat_app/CHAT_FIRE/msg_content_screen.dart';
import 'package:chat_app/CHAT_FIRE/person_group_selected_screen.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class DataScreen extends StatefulWidget {
  const DataScreen({super.key});

  @override
  State<DataScreen> createState() => _DataScreenState();
}

class _DataScreenState extends State<DataScreen> {
  ChatFireServices chatFireServices = ChatFireServices();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Data Present In ChatFIre'),
      ),
      body: SingleChildScrollView(
        child: Container(
          width: double.maxFinite,
          height: 700,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Expanded(
                child: StreamBuilder(
                  stream: chatFireServices.retriveData(),
                  builder: (context, AsyncSnapshot snapshot) {
                    List persons = snapshot.data?.docs ?? [];
                    return ListView.builder(
                      itemCount: persons.length,
                      itemBuilder: (context, index) {
                        UserData uData = persons[index].data();
                        return Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: ListTile(
                            title: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  uData.userId,
                                ),
                                Text(
                                  uData.name,
                                ),
                                Text(
                                  uData.email,
                                ),
                              ],
                            ),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(uData.gender),
                                Text(
                                  DateFormat('dd MM yyyy hh : mm a').format(
                                    uData.createdOn.toDate(),
                                  ),
                                ),
                              ],
                            ),
                            tileColor: Colors.green.withOpacity(0.3),
                          ),
                        );
                      },
                    );
                  },
                ),
              ),
              ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const ChatFireScreen(),
                      ),
                    );
                  },
                  child: const Text('Add User')),
              const SizedBox(
                height: 35,
              ),
              ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const MessageContentScreen(),
                      ),
                    );
                  },
                  child: const Text('Message Content'))
            ],
          ),
        ),
      ),
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          FloatingActionButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const PersonSelectScreen(),
                ),
              );
            },
            child: const Icon(Icons.abc),
          ),
          // FloatingActionButton(
          //   onPressed: () {
          //     Navigator.push(
          //       context,
          //       MaterialPageRoute(
          //         builder: (context) => const ChatFireScreen(),
          //       ),
          //     );
          //   },
          //   child: const Icon(Icons.add),
          // ),
        ],
      ),
    );
  }
}
