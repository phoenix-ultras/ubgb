import 'package:firebase_auth/firebase_auth.dart';
import 'package:riverpod/riverpod.dart';

final isAdminProvider = FutureProvider<bool>(
  (ref) async {
    //authenticate user
    User? user = await FirebaseAuth.instance.currentUser;

    if (user != null) {
      if (user.email == 'admin@123.ubgb') {
        return true;
      } else {
        return false;
      }
    } else {
      return false;
    }
  },
);
