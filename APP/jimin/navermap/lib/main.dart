import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:navermap/app.dart';
import 'package:user_repository/user_repository.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp(FirebaseUserRepo()));
}
