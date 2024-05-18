import 'package:flutter/material.dart';
import 'package:flutter_auth/providers/auth_provider.dart';
import 'package:provider/provider.dart';

class AuthPage extends StatefulWidget {
  const AuthPage({super.key});

  @override
  State<AuthPage> createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  bool _isRegistering = true;

  void _toggleRegisterMode() {
    setState(() {
      _isRegistering = !_isRegistering;
    });
  }

  void _handleRegister(BuildContext context) async {
    var authProvider = context.read<AuthProvider>();
    var state = authProvider.authState;

    authProvider.processRegister(context);

    // bodyMessage();

    if (state == StateAuth.success) {
      setState(() {
        _isRegistering = !_isRegistering;
      });
    }
  }

  void _handleLogin(BuildContext context) async {
    var authProvider = context.read<AuthProvider>();
    var state = authProvider.authState;

    authProvider.processLogin(context);

    // bodyMessage();

    if (state == StateAuth.success) {
      setState(() {
        _isRegistering = !_isRegistering;
      });
    }
  }

  void _handleLogout(BuildContext context) async {
    var authProvider = context.read<AuthProvider>();
    var state = authProvider.authState;

    authProvider.processLogout(context);

    // bodyMessage();

    if (state == StateAuth.success) {
      setState(() {
        _isRegistering = !_isRegistering;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    var authProvider = context.watch<AuthProvider>();

    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text(_isRegistering ? 'Register' : 'Login',
              style: const TextStyle(fontWeight: FontWeight.bold)),
          actions: [
            IconButton(
              onPressed: () {},
              icon: const Icon(Icons.logout),
            )
          ],
        ),
        body: Center(
          child: Padding(
              padding: const EdgeInsets.all(30.0),
              child: Form(
                key: _isRegistering
                    ? authProvider.formKeyRegister
                    : authProvider.formKeyLogin,
                child: ListView(
                  children: [
                    Text(
                      _isRegistering
                          ? "Register With Firebase"
                          : "Login With Firebase",
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                          fontSize: 24, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(
                      height: 30.0,
                    ),
                    TextFormField(
                      controller: authProvider.emailController,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return "Email harus diisi!";
                        }
                        return null;
                      },
                      decoration: const InputDecoration(labelText: 'Email'),
                    ),
                    const SizedBox(height: 16.0),
                    TextFormField(
                      controller: authProvider.passwordController,
                      obscureText: authProvider.obscurePassword,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return "Password harus diisi!";
                        }
                        return null;
                      },
                      decoration: const InputDecoration(labelText: 'Password'),
                    ),
                    const SizedBox(height: 32.0),
                    ElevatedButton(
                        onPressed: () => _isRegistering
                            ? _handleRegister(context)
                            : _handleLogin(context),
                        child: Text(_isRegistering ? "Register" : "Login")),
                    const SizedBox(height: 16.0),
                    TextButton(
                      onPressed: () => _toggleRegisterMode(),
                      child: Text(_isRegistering
                          ? 'Already have an account? Login here'
                          : 'Don\'t have an account? Register here'),
                    ),
                    bodyMessage(),
                  ],
                ),
              )),
        ));
  }

  Widget bodyMessage() {
    var authProvider = context.watch<AuthProvider>();
    var state = authProvider.authState;
    var email = authProvider.email;
    var uid = authProvider.uid;
    var error = authProvider.messageError;
    switch (state) {
      case StateAuth.initial:
        return const SizedBox();
      case StateAuth.success:
        WidgetsBinding.instance.addPostFrameCallback((_) {
          showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: const Text('Success'),
              content: Text('Hello, $email dengan $uid '),
              actions: [
                TextButton(
                  child: const Text('OK'),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ],
            ),
          );
        });
        state = StateAuth.initial;
        return const SizedBox();
      case StateAuth.error:
        WidgetsBinding.instance.addPostFrameCallback((_) {
          showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: const Text('Error'),
              content: Text(error),
              actions: [
                TextButton(
                  child: const Text('OK'),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ],
            ),
          );
        });
        state = StateAuth.initial;
        return const SizedBox();
      default:
        return const SizedBox();
    }
  }
}
