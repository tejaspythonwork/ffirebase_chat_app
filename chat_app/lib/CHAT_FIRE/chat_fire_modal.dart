import 'package:cloud_firestore/cloud_firestore.dart';

class UserData {
  String name;
  String email;
  String gender;
  int age;
  String userId;
  Timestamp createdOn;

  UserData({
    required this.name,
    required this.email,
    required this.gender,
    required this.age,
    required this.createdOn,
    required this.userId,
  });

  UserData.fromJson(Map<String, dynamic> json)
      : this(
          name: json['name'],
          email: json['email'],
          gender: json['gender'],
          age: json['age'],
          createdOn: json['createdOn'],
          userId: json['userId'],
        );

  UserData copyWith({
    String? name,
    String? email,
    String? gender,
    int? age,
    String? userId,
    Timestamp? createdOn,
  }) {
    return UserData(
      name: name!,
      email: email!,
      gender: gender!,
      age: age!,
      createdOn: createdOn!,
      userId: userId!,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'email': email,
      'gender': gender,
      'age': age,
      'userId': userId,
      'createdOn': createdOn,
    };
  }
}

class Messages {
  String fromUserId;
  String toUserId;
  String message;
  Timestamp messageSendingTime;

  Messages({
    required this.fromUserId,
    required this.messageSendingTime,
    required this.message,
    required this.toUserId,
  });

 factory Messages.fromJson(Map<String, dynamic> json) {
    return Messages(
      fromUserId: json['fromUserId'],
      messageSendingTime: json['messageSendingTime'],
      message: json['message'],
      toUserId: json['toUserId'],
    );
  }

   toJson(){
    return {
      'fromUserId' : fromUserId,
      'toUserId' : toUserId,
      'message' : message,
      'messageSendingTime' : messageSendingTime,
    };
  }
}
