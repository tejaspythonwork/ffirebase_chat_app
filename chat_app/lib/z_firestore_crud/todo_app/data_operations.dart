import 'package:chat_app/z_firestore_crud/todo_app/database_services.dart';
import 'package:chat_app/z_firestore_crud/todo_app/todo_modal.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get_connect/http/src/utils/utils.dart';
import 'package:intl/intl.dart';

class MyDataOperations extends StatefulWidget {
  const MyDataOperations({super.key});

  @override
  State<MyDataOperations> createState() => _MyDataOperationsState();
}

class _MyDataOperationsState extends State<MyDataOperations> {
  final textController = TextEditingController();
  final databaseService = DatabaseServices();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _appBar(),
      body: _buildUI(),
      floatingActionButton: FloatingActionButton(
        onPressed: _displayTextInputDialog,
        backgroundColor: Theme.of(context).colorScheme.primary,
        child: const Icon(
          Icons.add,
          color: Colors.white,
        ),
      ),
    );
  }

  PreferredSizeWidget _appBar() {
    return AppBar(
      backgroundColor: Theme.of(context).colorScheme.primary,
      title: const Text(
        "Todo",
        style: TextStyle(
          color: Colors.white,
        ),
      ),
    );
  }

  Widget _buildUI() {
    return SafeArea(
        child: Column(
      children: [
        _messagesListView(),
      ],
    ));
  }

  _displayTextInputDialog() {
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          content: TextFormField(
            controller: textController,
            decoration: InputDecoration(
              filled: true,
              fillColor: Colors.amber.shade500,
              hintText: 'Add Todo...',
            ),
          ),
          actions: [
            TextButton(
                onPressed: () {
                  Todo todo = Todo(
                    createdOn: Timestamp.now(),
                    isDone: false,
                    taskName: textController.text.trim(),
                    updatedOn: Timestamp.now(),
                  );
                  databaseService.addTodo(todo);
                },
                child: Text('Add'))
          ],
        );
      },
    );
  }

  _messagesListView() {
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.8,
      width: MediaQuery.of(context).size.width,
      child: StreamBuilder(
        stream: databaseService.getTodos(),
        builder: (context, snapshot) {
          List mTodos = snapshot.data?.docs ?? [];
          if (mTodos.isEmpty) {
            return const Center(
              child: Text("Add a todo!"),
            );
          }

          return ListView.builder(
            itemCount: mTodos.length,
            itemBuilder: (c, i) {
              Todo myList = mTodos[i].data();
              String todoId = mTodos[i].id;
              return Padding(
                padding: EdgeInsets.all(10),
                child: ListTile(
                  tileColor: Colors.green,
                  title: Text(myList.taskName),
                  subtitle: Column(
                    children: [
                      Text(todoId),
                      Text(
                        DateFormat('dd - MM - yyyy hh:mm a').format(
                          myList.createdOn.toDate(),
                        ),
                      ),
                      Text(
                        DateFormat('dd - MM - yyyy hh:mm a').format(
                          myList.updatedOn.toDate(),
                        ),
                      ),
                      Text('${myList.isDone}')
                    ],
                  ),
                  trailing: Checkbox(
                    value: myList.isDone,
                    onChanged: (val) {
                      Todo updatedTodo = myList.copyWith(
                          isDone: !myList.isDone, updatedOn: Timestamp.now());

                      databaseService.updateTodo(todoId, updatedTodo);
                    },
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
