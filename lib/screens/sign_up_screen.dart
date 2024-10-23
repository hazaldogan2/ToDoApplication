import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:todo_app_project/screens/sign_in_screen.dart';
import '../aut_service.dart';
import 'todo_list_screen.dart';

class SignUpScreen extends StatelessWidget {
  final AuthService authService = AuthService();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  SignUpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        automaticallyImplyLeading: false,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Get.back();
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 20),
            const Text(
              'Sign up with email',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            SizedBox(height: 8),
            const Text(
              'Enter your email and password',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey,
              ),
            ),
            SizedBox(height: 40),
            TextField(
              controller: emailController,
              decoration: const InputDecoration(
                labelText: 'E-mail',
                labelStyle: TextStyle(color: Colors.grey),
                border: UnderlineInputBorder(),
              ),
              keyboardType: TextInputType.emailAddress,
            ),
            SizedBox(height: 16),
            TextField(
              controller: passwordController,
              decoration: const InputDecoration(
                labelText: 'Password',
                labelStyle: TextStyle(color: Colors.grey),
                border: UnderlineInputBorder(),
              ),
              obscureText: true,
            ),
            SizedBox(height: 40),
            Center(
              child: ElevatedButton(
                onPressed: () async {
                  await authService.signUp(emailController.text, passwordController.text);
                  Get.offAll(TodoListScreen());
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.grey.shade300,
                  minimumSize: Size(double.infinity, 50),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: const Text(
                  'Create Account',
                  style: TextStyle(color: Colors.white, fontSize: 16),
                ),
              ),
            ),
            SizedBox(height: 16),
            Center(
              child: Column(
                children: [
                  const Text(
                    'By continuing, you agree to our',
                    style: TextStyle(color: Colors.grey, fontSize: 12),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      TextButton(
                        onPressed: () {
                        },
                        child: const Text(
                          'Privacy Policy',
                          style: TextStyle(color: Colors.black),
                        ),
                      ),
                      const Text(
                        'and',
                        style: TextStyle(color: Colors.grey, fontSize: 12),
                      ),
                      TextButton(
                        onPressed: () {
                        },
                        child: const Text(
                          'Terms of Use',
                          style: TextStyle(color: Colors.black),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 20),
                  TextButton(
                    onPressed: () {
                      Get.to(SignInScreen());
                    },
                    child: const Text(
                      'If you have an account, Log In!',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.blue,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}


