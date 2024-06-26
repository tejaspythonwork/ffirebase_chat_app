import 'package:chat_app/CHAT_FIRE/chat_fire_database_services.dart';
import 'package:chat_app/CHAT_FIRE/chat_fire_modal.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ChatFireScreen extends StatefulWidget {
  const ChatFireScreen({super.key});

  @override
  State<ChatFireScreen> createState() => _ChatFireScreenState();
}

class _ChatFireScreenState extends State<ChatFireScreen> {
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final ageController = TextEditingController();
  final genderController = TextEditingController();
  final userIdController = TextEditingController();
  final chatFireServices = ChatFireServices();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Data'),
      ),
      body: SafeArea(
          child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(
            left: 20.0,
            right: 20.0,
            top: 10,
            bottom: 10,
          ),
          child: Column(
            children: [
              TextFormField(
                decoration: InputDecoration(hintText: 'name'),
                controller: nameController,
              ),
              const SizedBox(
                height: 10,
              ),
              TextFormField(
                decoration: InputDecoration(hintText: 'email'),
                controller: emailController,
              ),
              const SizedBox(
                height: 10,
              ),
              TextFormField(
                decoration: InputDecoration(hintText: 'age'),
                controller: ageController,
              ),
              const SizedBox(
                height: 10,
              ),
              TextFormField(
                decoration: InputDecoration(hintText: 'gender'),
                controller: genderController,
              ),
              const SizedBox(
                height: 10,
              ),
              TextFormField(
                decoration: InputDecoration(hintText: 'user id'),
                controller: userIdController,
              ),
              const SizedBox(
                height: 50,
              ),
              ElevatedButton(
                onPressed: () {
                  UserData userData = UserData(
                    name: nameController.text.trim(),
                    email: emailController.text.trim(),
                    gender: genderController.text.trim(),
                    age: int.parse(ageController.text.trim()),
                    createdOn: Timestamp.now(),
                    userId: userIdController.text.trim(),
                  );
                  chatFireServices.addData(userData);
                },
                child: const Text('Add Data'),
              ),
            ],
          ),
        ),
      )),
    );
  }
}
