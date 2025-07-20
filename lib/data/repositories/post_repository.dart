import 'package:cloud_firestore/cloud_firestore.dart';
import '../../domain/models/post_model.dart';

class PostRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Stream<List<PostModel>> streamPosts() {
    return _firestore.collection('posts').snapshots().map((snapshot) =>
      snapshot.docs.map((doc) => PostModel.fromDocument(doc)!).toList()
    );
  }

  Future<String> addPost(PostModel post) async {
    final docRef = await _firestore.collection('posts').add(post.toMap());
    return docRef.id;
  }

  Future<void> updatePost(String id, Map<String, dynamic> data) async {
    await _firestore.collection('posts').doc(id).update(data);
  }

  Future<void> deletePost(String id) async {
    await _firestore.collection('posts').doc(id).delete();
  }

  Future<List<PostModel>> getPostsByIds(List<String> ids) async {
    if (ids.isEmpty) return [];
    final query = await _firestore.collection('posts').where(FieldPath.documentId, whereIn: ids).get();
    return query.docs.map((doc) => PostModel.fromDocument(doc)!).toList();
  }
} 