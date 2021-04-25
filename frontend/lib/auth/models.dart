import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';
import 'package:google_sign_in/google_sign_in.dart';

final _googleSignIn = GoogleSignIn();
User user;

Future<User> signInOrCreateAccount(
    BuildContext context, Future<UserCredential> Function() signInFunc) async {
  try {
    final userCredential = await signInFunc();
    user = userCredential.user;
    return userCredential.user;
  } on FirebaseAuthException catch (e) {
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Error: ${e.message}')),
    );
    return null;
  }
}

Future signOut() => FirebaseAuth.instance.signOut();

Future<User> signInWithGoogle(BuildContext context) async {
  final signInFunc = () async {
    await signOutWithGoogle().catchError((_) => null);
    final auth = await (await _googleSignIn.signIn())?.authentication;
    if (auth == null) {
      return null;
    }
    final credential = GoogleAuthProvider.credential(
        idToken: auth.idToken, accessToken: auth.accessToken);
    return FirebaseAuth.instance.signInWithCredential(credential);
  };
  return signInOrCreateAccount(context, signInFunc);
}

Future signOutWithGoogle() => _googleSignIn.signOut();

class FaunaFirebaseUser {
  FaunaFirebaseUser(this.user);
  final User user;
  bool get loggedIn => user != null;
}

FaunaFirebaseUser currentUser;
bool get loggedIn => currentUser?.loggedIn ?? false;
Stream<FaunaFirebaseUser> faunaFirebaseUserStream() => FirebaseAuth.instance
    .authStateChanges()
    .debounce((user) => user == null && !loggedIn
        ? TimerStream(true, const Duration(seconds: 1))
        : Stream.value(user))
    .map<FaunaFirebaseUser>((user) => currentUser = FaunaFirebaseUser(user));
