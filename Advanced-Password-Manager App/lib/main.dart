import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:safe_pass_sheild/Constants/my_router.dart';
import 'package:safe_pass_sheild/controllers/account_controller.dart';
import 'package:safe_pass_sheild/firebase_options.dart';

import 'Constants/my_constants.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  var pinCode = await AccountController.checkUserPinCode();

  if (pinCode == '') {
    await AccountController.deleteUser();
  }

  // await UserModel.GetUserFromSharedPrefs().then((value) async {
  //   await AccountController.login(value, NeedsToast: false).then((value) {
  //     if (value != null) {
  //       //print('User Logged In Successfully');
  //     } else {
  //       AccountController.signOut();
  //     }
  //   });
  // });

  runApp(const AuthenticationListener());
}

class AuthenticationListener extends StatelessWidget {
  const AuthenticationListener({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator(); // or any loading widget
        }
        if (snapshot.hasData) {
          // Navigator.push(
          //   context,
          //   MaterialPageRoute(
          //     builder: (context) => PinCodeScreen(
          //         type: PinCodeScreenType.AuthenticatePin.toShortString()),
          //   ),
          // ).then((value) {
          //   return MainApp();
          // });
          return MainApp();
          // Future.microtask(() {
          //   Navigator.pushReplacement(
          //     context,
          //     MaterialPageRoute(
          //       builder: (context) => PinCodeScreen(
          //           type: PinCodeScreenType.AuthenticatePin.toShortString()),
          //     ),
          //   ).then((value) {
          //     // After pin code verification, show MainApp
          //     runApp(MainApp());
          //   });
          // });
          // return Scaffold(body: Center(child: CircularProgressIndicator()));
        } else {
          return LoginApp();
        }
      },
    );
  }
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      title: MyConstants.appName,
      theme: ThemeData.light().copyWith(
        scaffoldBackgroundColor: MyConstants.kPrimaryColor,
        primaryColor: MyConstants.kPrimaryColor,
      ),
      routerConfig: MyRouter.MainRouter,
    );
  }
}

class LoginApp extends StatelessWidget {
  const LoginApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      title: MyConstants.appName,
      theme: ThemeData.light().copyWith(
        scaffoldBackgroundColor: MyConstants.kPrimaryColor,
        primaryColor: MyConstants.kPrimaryColor,
      ),
      routerConfig: MyRouter.LoginRouter,
    );
  }
}
