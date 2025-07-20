import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../domain/models/user_model.dart';

class UserRepository {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<UserModel?> getCurrentUser() async {
    final user = _auth.currentUser;
    if (user == null) return null;
    final doc = await _firestore.collection('users').doc(user.uid).get();
    return UserModel.fromDocument(doc);
  }

  Stream<UserModel?> streamCurrentUser() {
    final user = _auth.currentUser;
    if (user == null) return const Stream.empty();
    return _firestore.collection('users').doc(user.uid).snapshots().map((doc) => UserModel.fromDocument(doc));
  }

  Future<void> updateUserField(String uid, String fieldKey, dynamic value) async {
    await _firestore.collection('users').doc(uid).update({fieldKey: value});
  }

  Future<void> signOut() async {
    await _auth.signOut();
  }

  Future<UserModel?> registerUser({
    required String name,
    required String surname,
    required String birth,
    required String gender,
    required String info,
    required String type,
    required String email,
    required String password,
  }) async {
    final userCredential = await _auth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
    final user = userCredential.user;
    if (user == null) return null;
    final userModel = UserModel(
      uid: user.uid,
      name: name,
      surname: surname,
      birth: birth,
      gender: gender,
      info: info,
      type: type,
      email: email,
      postIds: [],
    );
    await _firestore.collection('users').doc(user.uid).set(userModel.toMap());
    return userModel;
  }

  Future<UserModel?> loginUser({
    required String email,
    required String password,
  }) async {
    final userCredential = await _auth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
    final user = userCredential.user;
    if (user == null) return null;
    final doc = await _firestore.collection('users').doc(user.uid).get();
    return UserModel.fromDocument(doc);
  }
} 