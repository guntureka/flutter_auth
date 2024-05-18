import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AuthProvider extends ChangeNotifier {
  final formKeyLogin = GlobalKey<FormState>();
  final formKeyRegister = GlobalKey<FormState>();

  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  var authState = StateAuth.initial;
  var email = '';
  var uid = "";
  var messageError = '';
  bool obscurePassword = true;

  void processRegister(BuildContext context) async {
    if (formKeyRegister.currentState!.validate()) {
      try {
        email = "";
        uid = "";
        UserCredential result = await FirebaseAuth.instance
            .createUserWithEmailAndPassword(
                email: emailController.text, password: passwordController.text);
        User user = result.user!;
        email = emailController.text;
        uid = user.uid;
        authState = StateAuth.success;
      } on FirebaseAuthException catch (e) {
        authState = StateAuth.error;
        messageError = e.toString();
      } catch (e) {
        authState = StateAuth.error;
        messageError = e.toString();
      }
    } else {
      showAlertError(context);
    }

    notifyListeners();
  }

  void processLogin(BuildContext context) async {
    if (formKeyLogin.currentState!.validate()) {
      try {
        UserCredential result = await FirebaseAuth.instance
            .signInWithEmailAndPassword(
                email: emailController.text, password: passwordController.text);
        User user = result.user!;
        email = emailController.text;
        uid = user.uid;
        authState = StateAuth.success;
      } on FirebaseAuthException catch (e) {
        authState = StateAuth.error;
        messageError = e.toString();
      } catch (e) {
        authState = StateAuth.error;
        messageError = e.toString();
      }
    } else {
      showAlertError(context);
    }

    notifyListeners();
  }

  void processLogout(BuildContext context) async {
    try {
      await FirebaseAuth.instance.signOut();
      email = emailController.text;
      authState = StateAuth.success;
    } on FirebaseAuthException catch (e) {
      authState = StateAuth.error;
      messageError = e.toString();
    } catch (e) {
      authState = StateAuth.error;
      messageError = e.toString();
    }

    notifyListeners();
  }

  void actionObscurePassword() {
    obscurePassword = !obscurePassword;
    notifyListeners();
  }
}

enum StateAuth { initial, success, error }

showAlertError(BuildContext context) {
  showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Check kembali data!"),
          actions: [
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Ok'),
            )
          ],
        );
      });
}
