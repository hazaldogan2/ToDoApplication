import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

class AuthService extends GetxController {
  FirebaseAuth _auth = FirebaseAuth.instance;
  var user = Rxn<User>();

  @override
  void onInit() {
    user.bindStream(_auth.authStateChanges());
    super.onInit();
  }

  Future<void> signUp(String email, String password) async {
    try {
      await _auth.createUserWithEmailAndPassword(email: email, password: password);
    } catch (e) {
      Get.snackbar("Error", e.toString());
    }
  }

  Future<bool> signIn(String email, String password) async {
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(email: email, password: password);

      if (userCredential.user != null) {
        return true;
      } else {
        Get.snackbar("Error", "Failed to sign in. Please try again.");
        return false;
      }
    } catch (e) {
      Get.snackbar("Error", "This email has not been registered yet. Please sign up.");
      return false;
    }
  }

  Future<void> signOut() async {
    await _auth.signOut();
  }

  Future<List<String>> fetchSignInMethodsForEmail(String email) async {
    try {
      List<String> signInMethods = await _auth.fetchSignInMethodsForEmail(email);
      return signInMethods;
    } catch (e) {
      Get.snackbar("Error", e.toString());
      return [];
    }
  }
}


