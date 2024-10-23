import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:get/get.dart';
import 'package:todo_app_project/screens/sign_up_screen.dart';
import 'package:todo_app_project/screens/sign_in_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  runApp( GetMaterialApp(
      debugShowCheckedModeBanner: false,
      home: SignUpScreen()));
}
