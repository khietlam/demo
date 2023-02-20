import 'package:demo/services/account_info.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthenticationService {
  // For registering a new user
  static Future<AccountInfo?> signUpUsingEmailPassword({
    required String email,
    required String password,
  }) async {
    FirebaseAuth auth = FirebaseAuth.instance;
    AccountInfo? account = AccountInfo();

    try {
      UserCredential userCredential = await auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      account.user = userCredential.user;
      await account.user!.reload();
      account.user = auth.currentUser;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        account.message = e.code;
        print(account.message);
        // print('The password provided is too weak.');
      } else if (e.code == 'email-already-in-use') {
        account.message = e.code;
        print(account.message);
        // print('The account already exists for that email.');
      }
    } on Error catch (e) {
      print(e);
      account.message = e.toString();
    }

    return account;
  }

  // For signing in an user (have already registered)
  static Future<AccountInfo?> signInUsingEmailPassword({
    required String email,
    required String password,
  }) async {
    FirebaseAuth auth = FirebaseAuth.instance;
    AccountInfo? account = AccountInfo();

    try {
      UserCredential userCredential = await auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      account.user = userCredential.user;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        print('No user found for that email.');
        account.message = e.code;
      } else if (e.code == 'wrong-password') {
        print('Wrong password provided.');
        account.message = e.code;
      }
    } on Error catch (e) {
      print(e);
      account.message = e.toString();
    }

    return account;
  }

  static Future<AccountInfo?> refreshUser(User user) async {
    FirebaseAuth auth = FirebaseAuth.instance;
    AccountInfo? account = AccountInfo();

    await user.reload();
    account.user = auth.currentUser;

    return account;
  }

}
