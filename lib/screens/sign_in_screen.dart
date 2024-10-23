import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../aut_service.dart';
import 'sign_up_screen.dart';
import 'todo_list_screen.dart';

class SignInScreen extends StatelessWidget {
  final AuthService authController = Get.put(AuthService());
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final RxBool isPasswordVisible = false.obs;

  SignInScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        automaticallyImplyLeading: true,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Sign in with email",
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8),
            const Text(
              "Enter your email and password",
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey,
              ),
            ),
            SizedBox(height: 20),
            // E-mail input
            TextField(
              controller: emailController,
              decoration: const InputDecoration(
                hintStyle: TextStyle(color: Color(0xffa2a3a3), fontSize: 15, fontFamily: 'Barlow'),
                hintText: "Email",
                contentPadding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                isDense: true,
                errorMaxLines: 3,
                border: UnderlineInputBorder(borderSide: BorderSide(color: Colors.grey)),
                errorBorder:  UnderlineInputBorder(borderSide: BorderSide(color: Colors.red)),
              ),
            ),
            SizedBox(height: 15),
            Obx(() => TextField(
              controller: passwordController,
              decoration: InputDecoration(
                hintStyle: TextStyle(color: Color(0xffa2a3a3), fontSize: 15, fontFamily: 'Barlow'),
                hintText: "Password",
                contentPadding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                isDense: true,
                errorMaxLines: 3,
                border: UnderlineInputBorder(borderSide: BorderSide(color: Colors.grey)),
                errorBorder:  UnderlineInputBorder(borderSide: BorderSide(color: Colors.red)),
                suffixIcon: IconButton(
                  icon: Icon(
                    isPasswordVisible.value
                        ? Icons.visibility
                        : Icons.visibility_off,
                  ),
                  onPressed: () {
                    isPasswordVisible.value = !isPasswordVisible.value;
                  },
                ),
              ),
              obscureText: !isPasswordVisible.value,
            )),
            SizedBox(height: 10),
            Align(
              alignment: Alignment.centerRight,
              child: TextButton(
                onPressed: () {
                },
                child: const Text(
                  'Forgot password?',
                  style: TextStyle(color: Colors.blue),
                ),
              ),
            ),
            SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () async {
                  bool isSignedIn = await authController.signIn(emailController.text.trim(), passwordController.text.trim());
                  if (isSignedIn) {
                    Get.offAll(() => TodoListScreen());
                  } else {
                    print("Giriş başarısız!");
                  }
                },
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(vertical: 16), backgroundColor: Colors.white30,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: const Text(
                  'Sign In',
                  style: TextStyle(fontSize: 16, color: Colors.white),
                ),
              ),
            ),
            SizedBox(height: 20),
            // Terms and Privacy Policy
            Center(
              child: Column(
                children: [
                  const Text(
                    'By continuing, you agree to our',
                    style: TextStyle(fontSize: 14, color: Colors.grey),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      TextButton(
                        onPressed: () {
                        },
                        child: const Text(
                          'Privacy Policy',
                          style: TextStyle(fontSize: 14, color: Colors.black),
                        ),
                      ),
                      const Text(
                        'and',
                        style: TextStyle(fontSize: 14, color: Colors.grey),
                      ),
                      TextButton(
                        onPressed: () {
                        },
                        child: const Text(
                          'Terms of Use',
                          style: TextStyle(fontSize: 14, color: Colors.black),
                        ),
                      ),
                    ],
                  ),
                  TextButton(
                    onPressed: () {
                      Get.to(SignUpScreen());
                    },
                    child: const Text(
                      '\n If you do not have an account, Sign Up!',
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

