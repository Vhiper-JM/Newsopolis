import 'package:cloud_firestore/cloud_firestore.dart';

class UserStatus {
  String  name, email, message;
  String? dbRef;

  UserStatus({
    
    required this.name,
    required this.email,
    required this.message,
    this.dbRef,
  });

  factory UserStatus.fromJson(Map<String, dynamic> map) {
    final data = map["data"];
    return UserStatus(
        
        name: data['name'], 
        email: data['email'],
        message: data['message'],
        dbRef: map['ref']);
  }

  Map<String, dynamic> toJson() {
    return {
      "name": name,
      "email": email,
      "message": message,
      "timestamp": Timestamp.now(),
    };
  }
}
