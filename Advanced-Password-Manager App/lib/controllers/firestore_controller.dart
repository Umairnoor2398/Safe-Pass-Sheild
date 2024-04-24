import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:safe_pass_sheild/utilities/encryption_utility.dart';
import 'package:safe_pass_sheild/utilities/toast.dart';
import 'package:tuple/tuple.dart';

class FireStoreController {
  static FirebaseFirestore ref = FirebaseFirestore.instance;

  static Future<bool> addUser(
      User? user, String username, String password, String pinCode,
      {bool NeedsToast = false}) async {
    bool userCreated = false;
    CollectionReference refUsers =
        FirebaseFirestore.instance.collection('Users');

    String salt = EncryptionUtility.generateSalt();
    await refUsers.doc(user?.email).set({
      'username': username,
      'email': user?.email,
      'loginType': 'Email',
      'profileImage': 'user.png',
      'salt': salt,
      'pinCode': pinCode,
      'passwordProfiles': [],
      'password': EncryptionUtility.encryptData(password, salt),
    }).then((value) {
      if (NeedsToast == true) {
        MyToast().showSuccess('User Created');
      }
      userCreated = true;
    }).onError((error, stackTrace) {
      if (NeedsToast == true) {
        MyToast().showSuccess("Cannot Create User, Try again later");
      }
      userCreated = false;
    });
    return userCreated;
  }

  static Future<bool> addUserBySocialLinkage(User? user, String pinCode,
      {bool NeedsToast = false}) async {
    bool userCreated = false;
    CollectionReference refUsers =
        FirebaseFirestore.instance.collection('Users');

    String salt = EncryptionUtility.generateSalt();
    await refUsers.doc(user?.email).set({
      'username': user?.displayName ?? '',
      'email': user?.email,
      'loginType': 'Google',
      'profileImage': 'user.png',
      'salt': salt,
      'pinCode': pinCode,
      'passwordProfiles': [],
      'password': EncryptionUtility.encryptData('Google', salt),
    }).then((value) {
      if (NeedsToast == true) {
        MyToast().showSuccess('User Created');
      }
      userCreated = true;
    }).onError((error, stackTrace) {
      if (NeedsToast == true) {
        MyToast().showSuccess("Cannot Create User, Try again later");
      }
      userCreated = false;
    });
    return userCreated;
  }

  static Future<bool> addSingleRecord(
      String collName, String docId, Map<String, dynamic> data,
      {bool NeedsToast = false}) async {
    bool result = false;
    await ref.collection(collName).doc(docId).set(data).then((value) {
      result = true;
      if (NeedsToast == true) {
        MyToast().showSuccess('Record Added');
      }
    }).onError((error, stackTrace) {
      if (NeedsToast == true) {
        MyToast().showError('Cannot Add Record');
      }
    });

    return result;
  }

  static Future<bool> addSingleRecordWithUniqueId(
      String collName, Map<String, dynamic> data,
      {bool NeedsToast = false}) async {
    bool result = false;
    await ref.collection(collName).add(data).then((value) {
      result = true;
      if (NeedsToast == true) {
        MyToast().showSuccess('Record Added');
      }
    }).onError((error, stackTrace) {
      if (NeedsToast == true) {
        MyToast().showError('Cannot Add Record');
      }
    });

    return result;
  }

  static Future<Map<String, dynamic>> getSingleRecord(
      String collName, String docId) async {
    Map<String, dynamic> _value = {};

    await ref.collection(collName).doc(docId).get().then((value) {
      _value = value.data() as Map<String, dynamic>;
    });
    return _value;
  }

  static Future<List<Tuple2<String, Map<String, dynamic>>>> getListofRecords(
      String collName, String username) async {
    List<Tuple2<String, Map<String, dynamic>>> records = [];
    QuerySnapshot querySnapshot = await ref
        .collection(collName)
        .where('user', isEqualTo: username)
        .where('isActive', isEqualTo: true)
        .get();

    records = querySnapshot.docs
        .map((doc) => Tuple2(doc.id, doc.data() as Map<String, dynamic>))
        .toList();

    return records;
  }

  static Future<bool> deleteSingleRecord(String collName, String docId,
      {bool NeedsToast = false}) async {
    bool result = false;
    await ref.collection(collName).doc(docId).delete().then((value) {
      result = true;
      if (NeedsToast == true) {
        MyToast().showSuccess('Record Deleted');
      }
    }).onError((error, stackTrace) {
      if (NeedsToast == true) {
        MyToast().showError('Cannot Delete Record');
      }
    });
    return result;
  }

  static Future<bool> updateSingleRecord(
      String collName, String docId, Map<String, dynamic> data,
      {bool NeedsToast = false}) async {
    bool result = false;
    await ref.collection(collName).doc(docId).update(data).then((value) {
      result = true;
      if (NeedsToast == true) {
        MyToast().showSuccess('Record Updated');
      }
    }).onError((error, stackTrace) {
      if (NeedsToast == true) {
        MyToast().showError('Cannot Update Record');
      }
    });
    return result;
  }

  static Future<void> deleteProfile(String id) async {
    try {
      var user = await FirebaseAuth.instance.currentUser;

      DocumentReference userRef =
          FirebaseFirestore.instance.collection('users').doc(user!.email);
      DocumentReference friendRefToDelete =
          FirebaseFirestore.instance.collection('PasswordProfiles').doc(id);

      await userRef.update({
        'friends': FieldValue.arrayRemove([friendRefToDelete])
      });
    } catch (e) {
      print('Error deleting Profile: $e');
    }
  }

  static Future<void> addPasswordProfile(String name,
      {String description = ''}) async {
    try {
      var user = await FirebaseAuth.instance.currentUser;

      DocumentReference userRef =
          FirebaseFirestore.instance.collection('Users').doc(user!.email);

      // Automatically generate a new unique ID for the friend
      String newProfileId =
          FirebaseFirestore.instance.collection('PasswordProfiles').doc().id;
      DocumentReference newProfileRef = FirebaseFirestore.instance
          .collection('PasswordProfiles')
          .doc(newProfileId);

      await newProfileRef.set({
        'name': name,
        'description': description,
        'passwords': [],
      });

      await userRef.update({
        'passwordProfiles': FieldValue.arrayUnion([newProfileRef])
      });
    } catch (e) {
      print('Error adding friend: $e');
    }
  }

  static Future<void> addPasswordInProfile(
      String profileId, Map<String, dynamic> data) async {
    try {
      DocumentReference userRef = FirebaseFirestore.instance
          .collection('PasswordProfiles')
          .doc(profileId);

      // Automatically generate a new unique ID for the friend
      String newProfileId =
          FirebaseFirestore.instance.collection('Passwords').doc().id;
      DocumentReference newProfileRef =
          FirebaseFirestore.instance.collection('Passwords').doc(newProfileId);

      await newProfileRef.set(data);

      await userRef.update({
        'passwords': FieldValue.arrayUnion([newProfileRef])
      });
    } catch (e) {
      print('Error adding password: $e');
    }
  }
}
