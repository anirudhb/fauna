import 'package:firebase_auth/firebase_auth.dart';
import 'package:rxdart/rxdart.dart';

class FaunaFirebaseUser {
  FaunaFirebaseUser(this.user);
  final User user;
  bool get loggedIn => user != null;
}

FaunaFirebaseUser? currentUser;
bool get loggedIn => currentUser?.loggedIn ?? false;
Stream<FaunaFirebaseUser> guideyFirebaseUserStream() => FirebaseAuth.instance
    .authStateChanges()
    .debounce((user) => user == null && !loggedIn
        ? TimerStream(true, const Duration(seconds: 1))
        : Stream.value(user))
    .map<FaunaFirebaseUser>((user) => currentUser = FaunaFirebaseUser(user));
