import 'package:flutter/material.dart';
import 'package:flutter_auth/pages/auth_page.dart';
import 'package:flutter_auth/providers/auth_provider.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

void main() {
  initFirebase();
}

Future initFirebase() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const ApplicationStart());
}

class ApplicationStart extends StatelessWidget {
  const ApplicationStart({super.key});
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => AuthProvider(),
        )
      ],
      child: const MaterialApp(
        home: AuthPage(),
      ),
    );
  }
}
