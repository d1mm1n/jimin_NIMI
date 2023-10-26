import 'package:firebase_auth/firebase_auth.dart';
import 'package:user_repository/src/models/user.dart';

abstract class UserRepository {
  Stream<User?> get user;

  Future<MyUser> signup(MyUser myUser, String password);
  Future<void> setUserDate(MyUser user);
  Future<void> signIn(String email, String password);
}
