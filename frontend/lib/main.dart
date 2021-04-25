import 'package:fauna_frontend/auth/models.dart';
import 'package:fauna_frontend/pages/main_screen.dart';
import 'package:fauna_frontend/pages/welcome.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(Fauna());
}

class Fauna extends StatefulWidget {
  @override
  _FaunaState createState() => _FaunaState();
}

class _FaunaState extends State<Fauna> {
  late Stream<FaunaFirebaseUser> userStream;
  FaunaFirebaseUser? initialUser;

  @override
  void initState() {
    super.initState();
    userStream = faunaFirebaseUserStream()
      ..listen((user) {
        if (initialUser != null) setState(() => initialUser = user);
      });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Fauna',
      theme: ThemeData(primarySwatch: Colors.orange),
      debugShowCheckedModeBanner: false,
      home: initialUser == null
          ? const Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Color(0xff4b39ef)),
              ),
            )
          : currentUser != null && currentUser!.loggedIn
          ? MainScreenWidget()
          : WelcomePageWidget(),
    );
  }
}
