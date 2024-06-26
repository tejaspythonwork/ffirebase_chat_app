import 'package:cloud_firestore/cloud_firestore.dart';

class Todo {
  String taskName;
  bool isDone;
  Timestamp createdOn;
  Timestamp updatedOn;

  Todo({
    required this.createdOn,
    required this.isDone,
    required this.taskName,
    required this.updatedOn,
  });

  Todo.fromJson(Map<String, Object?> json)
      : this(
          taskName: json['taskName'] as String,
          createdOn: json['createdOn'] as Timestamp,
          updatedOn: json['updatedOn'] as Timestamp,
          isDone: json['isDone'] as bool,
        );

  Todo copyWith({
    String? taskName,
    bool? isDone,
    Timestamp? createdOn,
    Timestamp? updatedOn,
  }) {
    return Todo(
      createdOn: createdOn ?? this.createdOn,
      isDone: isDone ?? this.isDone,
      taskName: taskName ?? this.taskName,
      updatedOn: updatedOn ?? this.updatedOn,
    );
  }

  Map<String, Object?> toJson() {
    return {
      'taskName': taskName,
      'isDone': isDone,
      'createdOn': createdOn,
      'updatedOn': updatedOn,
    };
  }
}
