import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  final String uid;
  final String name;
  final String surname;
  final String birth;
  final String gender;
  final String info;
  final String type;
  final String? email;
  final List<String> postIds;

  UserModel({
    required this.uid,
    required this.name,
    required this.surname,
    required this.birth,
    required this.gender,
    required this.info,
    required this.type,
    this.email,
    required this.postIds,
  });

  factory UserModel.fromMap(String uid, Map<String, dynamic> map) {
    return UserModel(
      uid: uid,
      name: map['name'] ?? '',
      surname: map['surname'] ?? '',
      birth: map['birth'] ?? '',
      gender: map['gender'] ?? '',
      info: map['info'] ?? '',
      type: map['type'] ?? '',
      email: map['email'],
      postIds: (map['postIds'] as List<dynamic>?)?.map((e) => e.toString()).toList() ?? [],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'surname': surname,
      'birth': birth,
      'gender': gender,
      'info': info,
      'type': type,
      if (email != null) 'email': email,
      'postIds': postIds,
    };
  }

  static UserModel? fromDocument(DocumentSnapshot doc) {
    if (!doc.exists) return null;
    final data = doc.data() as Map<String, dynamic>;
    return UserModel.fromMap(doc.id, data);
  }
} 