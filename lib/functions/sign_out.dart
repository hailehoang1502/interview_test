import 'package:firebase_auth/firebase_auth.dart';

void signUserOut() {
  FirebaseAuth.instance.signOut();
}