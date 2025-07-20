import 'package:cloud_firestore/cloud_firestore.dart';

class PostModel {
  final String id;
  final int rent;
  final String roomType;
  final String location;
  final String requiredStudent;
  final String requiredGender;
  final String description;
  final String userId;
  final DateTime? createdAt;
  final String? imageUrl;

  PostModel({
    required this.id,
    required this.rent,
    required this.roomType,
    required this.location,
    required this.requiredStudent,
    required this.requiredGender,
    required this.description,
    required this.userId,
    this.createdAt,
    this.imageUrl,
  });

  factory PostModel.fromMap(String id, Map<String, dynamic> map) {
    return PostModel(
      id: id,
      rent: map['rent'] ?? 0,
      roomType: map['roomType'] ?? '',
      location: map['location'] ?? '',
      requiredStudent: map['requiredStudent'] ?? '',
      requiredGender: map['requiredGender'] ?? '',
      description: map['description'] ?? '',
      userId: map['userId'] ?? '',
      createdAt: map['createdAt'] != null && map['createdAt'] is Timestamp
          ? (map['createdAt'] as Timestamp).toDate()
          : null,
      imageUrl: map['imageUrl'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'rent': rent,
      'roomType': roomType,
      'location': location,
      'requiredStudent': requiredStudent,
      'requiredGender': requiredGender,
      'description': description,
      'userId': userId,
      if (createdAt != null) 'createdAt': Timestamp.fromDate(createdAt!),
      if (imageUrl != null) 'imageUrl': imageUrl,
    };
  }

  static PostModel? fromDocument(DocumentSnapshot doc) {
    if (!doc.exists) return null;
    final data = doc.data() as Map<String, dynamic>;
    return PostModel.fromMap(doc.id, data);
  }
} 