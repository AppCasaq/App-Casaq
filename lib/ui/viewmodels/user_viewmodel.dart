import '../../data/repositories/user_repository.dart';
import '../../domain/models/user_model.dart';

class UserViewModel {
  final UserRepository _userRepository = UserRepository();

  Stream<UserModel?> get currentUserStream => _userRepository.streamCurrentUser();

  Future<UserModel?> getCurrentUser() => _userRepository.getCurrentUser();

  Future<void> updateUserField(String uid, String fieldKey, dynamic value) =>
      _userRepository.updateUserField(uid, fieldKey, value);

  Future<void> signOut() => _userRepository.signOut();

  Future<UserModel?> registerUser({
    required String name,
    required String surname,
    required String birth,
    required String gender,
    required String info,
    required String type,
    required String email,
    required String password,
  }) => _userRepository.registerUser(
        name: name,
        surname: surname,
        birth: birth,
        gender: gender,
        info: info,
        type: type,
        email: email,
        password: password,
      );

  Future<UserModel?> loginUser({
    required String email,
    required String password,
  }) => _userRepository.loginUser(email: email, password: password);
} 