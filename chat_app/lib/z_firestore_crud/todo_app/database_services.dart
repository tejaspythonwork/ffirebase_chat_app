import 'package:chat_app/z_firestore_crud/todo_app/todo_modal.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

const todoRef = 'todos';

class DatabaseServices {
  final firestore = FirebaseFirestore.instance;
  late final CollectionReference myTodoref;

  DatabaseServices() {
    myTodoref = firestore.collection(todoRef).withConverter<Todo>(
        fromFirestore: (snap, _) => Todo.fromJson(snap.data()!),
        toFirestore: (todo, _) => todo.toJson());
  }

  Stream<QuerySnapshot> getTodos() {
    return myTodoref.snapshots();
  }

  addTodo(Todo todo) async {
    myTodoref.add(todo);
  }

  deleteTodo(String todoId) async {
    await myTodoref.doc(todoId).delete();
  }

  updateTodo(String todoId, Todo todo) async {
    await myTodoref.doc(todoId).update(todo.toJson());
  }
}
