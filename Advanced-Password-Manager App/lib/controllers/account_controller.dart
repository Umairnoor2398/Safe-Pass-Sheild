// ignore_for_file: body_might_complete_normally_catch_error, deprecated_member_use
import 'package:google_sign_in/google_sign_in.dart';
import 'package:safe_pass_sheild/controllers/firestore_controller.dart';
import 'package:safe_pass_sheild/models/user.model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:safe_pass_sheild/utilities/encryption_utility.dart';
import 'package:safe_pass_sheild/utilities/toast.dart';

class AccountController {
  static FirebaseAuth firebaseAuth = FirebaseAuth.instance;

  static Future<User?> register(UserModel _user) async {
    try {
      UserCredential userCredential =
          await firebaseAuth.createUserWithEmailAndPassword(
              email: _user.email, password: _user.password);
      return userCredential.user;
    } catch (e) {
      MyToast().showError("Cannot Create Account Try again later");
    }
    return null;
  }

  static Future<User> GetCurrentUser() async {
    return firebaseAuth.currentUser!;
  }

  static Future<void> deleteUser() async {
    var user = await FirebaseAuth.instance.currentUser;

    if (user == null) {
      return;
    }
    bool res =
        await FireStoreController.deleteSingleRecord('Users', user.email!);

    if (res == false) {
      return;
    }
    return firebaseAuth.currentUser!.delete();
  }

  static Future<String> checkUserPinCode() async {
    var user = await FirebaseAuth.instance.currentUser;

    if (user == null) {
      return '';
    }

    var userData =
        await FireStoreController.getSingleRecord('Users', user.email!);

    if (userData['pinCode'] == null) {
      return '';
    }
    if (userData['pinCode'] == 'undefined') {
      return '';
    }

    return userData['pinCode'];
  }

  static Future<void> signOut() async {
    // return firebaseAuth.signOut();
    await firebaseAuth.signOut();
    // await deleteUser();
  }

  static Future<bool> checkUserAccount(String email) async {
    try {
      // User? user = (await FirebaseAuth.instance.fetchSignInMethodsForEmail(email)).first;
      List<String> signInmethods =
          (await firebaseAuth.fetchSignInMethodsForEmail(email));

      for (var item in signInmethods) {
        if (item.toLowerCase().replaceAll(' ', '').contains('password')) {
          return true;
        }
      }
    } catch (e) {}

    return false;
  }

  static Future<void> resetPassword(String email, String Password) async {
    try {
      var userData = await FireStoreController.getSingleRecord('Users', email);

      String oldPassword = EncryptionUtility.decrypt(
          userData['password'], userData['salt'].toString());

      var user = await login(UserModel(email: email, password: oldPassword));

      if (user == null) {
        MyToast().showError("Cannot Reset Password Try again later");
        return;
      }
      // user.updatePassword(Password);

      user = await FirebaseAuth.instance.currentUser;
      final cred =
          EmailAuthProvider.credential(email: email, password: oldPassword);

      if (user == null) {
        MyToast().showError("Cannot Reset Password Try again later");
        return;
      }

      await user.reauthenticateWithCredential(cred).then((value) async {
        await user?.updatePassword(Password).then((_) async {
          userData['password'] =
              EncryptionUtility.encryptData(Password, userData['salt']);

          bool res = await FireStoreController.updateSingleRecord(
              'Users', email, userData);

          if (res == false) {
            await user?.updatePassword(oldPassword);
            throw "Cannot Reset Password Try again later";
          }
          MyToast().showSuccess("Password Reset Successfully");
          return;
        }).catchError((error) {
          throw error;
        });
      }).catchError((err) {
        throw err;
      });
    } catch (e) {
      signOut();
      MyToast().showError("Cannot Reset Password Try again later");
    }
  }

  static Future<User?> login(UserModel _user, {bool NeedsToast = false}) async {
    try {
      UserCredential userCredential =
          await firebaseAuth.signInWithEmailAndPassword(
              email: _user.email, password: _user.password);
      return userCredential.user;
    } catch (e) {
      if (NeedsToast == true) {
        MyToast().showError("In-valid user name or password");
      }
    }
    return null;
  }

  static Future<Map<String, dynamic>?> signInWithGoogle() async {
    //trigger the Authentication Dialog
    bool isNewUser = false;
    try {
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
      if (googleUser != null) {
        isNewUser = true;
        //Obtain Auth Detail from request
        final GoogleSignInAuthentication googleAuth =
            await googleUser.authentication;

        // Create a new Credential
        final credential = GoogleAuthProvider.credential(
          accessToken: googleAuth.accessToken,
          idToken: googleAuth.idToken,
        );
        // Once Signed In return the user data from firebase
        UserCredential userCredential =
            await firebaseAuth.signInWithCredential(credential);

        MyToast().showSuccess("Account Created Successfully");
        return new Map<String, dynamic>.from(
            {"isNewUser": isNewUser, "user": userCredential.user});
      }
    } catch (e) {
      MyToast().showError("Cannot Sign in using Google Try again later");
    }
    return null;
  }
}
