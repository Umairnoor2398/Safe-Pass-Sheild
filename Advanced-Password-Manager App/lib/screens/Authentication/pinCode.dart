// ignore_for_file: must_be_immutable, unused_element

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:pinput/pinput.dart';
import 'package:safe_pass_sheild/Constants/my_router.dart';
import 'package:safe_pass_sheild/components/buttons.dart';
import 'package:safe_pass_sheild/controllers/account_controller.dart';
import 'package:safe_pass_sheild/controllers/firestore_controller.dart';
import 'package:safe_pass_sheild/models/user.model.dart';
import 'package:safe_pass_sheild/utilities/toast.dart';

enum PinCodeScreenType {
  CreatePin,
  AuthenticatePin,
  ResetPin,
  CreatePinConfirmation,
  ResetPinConfirmation,
}

class PinCodeScreen extends StatefulWidget {
  late PinCodeScreenType type;

  late String title;

  PinCodeScreen({super.key, required String type}) {
    switch (type) {
      case 'CreatePin':
        title = 'Create a Pin Code';
        this.type = PinCodeScreenType.CreatePin;
        break;
      case 'CreatePinConfirmation':
        title = 'Verify your Pin Code';
        this.type = PinCodeScreenType.CreatePinConfirmation;
        break;
      case 'AuthenticatePin':
        title = 'Verify your Identity';
        this.type = PinCodeScreenType.AuthenticatePin;
        break;
      case 'ResetPin':
        title = 'Reset your Pin Code';
        this.type = PinCodeScreenType.ResetPin;
        break;
      case 'ResetPinConfirmation':
        title = 'Verify your Pin Code';
        this.type = PinCodeScreenType.ResetPinConfirmation;
        break;
      default:
        this.type = PinCodeScreenType.CreatePin;
    }
  }

  @override
  State<PinCodeScreen> createState() => _PinCodeScreenState();
}

class _PinCodeScreenState extends State<PinCodeScreen> {
  final formKey = GlobalKey<FormState>();

  var pinCode = '';

  final TextEditingController pin1 = TextEditingController();
  final TextEditingController pin2 = TextEditingController();
  final TextEditingController pin3 = TextEditingController();
  final TextEditingController pin4 = TextEditingController();

  UserModel user = UserModel(email: '', password: '');

  @override
  void initState() {
    super.initState();
    if (widget.type != PinCodeScreenType.AuthenticatePin) {
      getUser();
    }
  }

  void getUser() async {
    user = (await UserModel.GetUserFromSharedPrefs())!;
  }

  Future<String> getUserPin() async {
    var user = await AccountController.GetCurrentUser();
    var _userData =
        await FireStoreController.getSingleRecord('Users', user.email!);

    return _userData['pinCode'];
  }

  bool loading = false;
  googleLogin() async {
    var result = await AccountController.signInWithGoogle();

    if (result == null) {
      return;
    }

    User user = result['user'];
    bool isNewUser = result['isNewUser'];

    if (isNewUser) {
      user.displayName;
      bool isUserCreated =
          await FireStoreController.addUserBySocialLinkage(user, pinCode);

      if (isUserCreated == false) {
        AccountController.deleteUser();
      } else {
        // user.StoreUserToSharedPrefs();
        UserModel _user = UserModel(
            email: user.email!,
            password: 'google',
            loginType: LoginType.google,
            username: user.displayName);

        _user.StoreUserToSharedPrefs();
      }
    } else {
      // login happened
    }
  }

  @override
  Widget build(BuildContext context) {
    final defaultPinTheme = PinTheme(
      width: 64,
      height: 68,
      textStyle: TextStyle(fontSize: 22, color: Colors.black),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.deepPurple),
        borderRadius: BorderRadius.circular(8),
        color: Colors.transparent,
      ),
    );

    return SafeArea(
        child: Scaffold(
            appBar: AppBar(
              backgroundColor: Colors.white,
              shadowColor: Colors.white,
              // leading: const BackButton(color: Colors.black),
            ),
            body: Container(
              margin: const EdgeInsets.only(top: 40, left: 20, right: 10),
              child: Column(
                children: [
                  Row(
                    children: [
                      SizedBox(
                        width: 280,
                        child: Text(
                          widget.title,
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 30),
                  SizedBox(
                      width: double.infinity,
                      child: Text(
                        "Don't forget your pin code, you will need it to access your account.",
                        textAlign: TextAlign.start,
                        style: const TextStyle(
                            fontSize: 13, color: Colors.black87),
                      )),
                  const SizedBox(
                    height: 20,
                  ),
                  Container(
                      margin: const EdgeInsets.only(right: 20),
                      width: 400,
                      child: Form(
                        key: formKey,
                        child: Column(
                          children: [
                            Pinput(
                              length: 4,
                              controller: pin1,
                              onChanged: (value) {
                                // print(value);
                              },
                              defaultPinTheme: defaultPinTheme,
                              focusedPinTheme: defaultPinTheme.copyWith(
                                decoration:
                                    defaultPinTheme.decoration!.copyWith(
                                  border: Border.all(
                                      color: Colors.deepPurple, width: 2),
                                ),
                              ),
                            ),
                          ],
                        ),
                      )),
                  const SizedBox(
                    height: 20,
                  ),
                  Expanded(
                      child: Align(
                          alignment: Alignment.bottomCenter,
                          child: Padding(
                            padding: const EdgeInsets.all(8),
                            child: SizedBox(
                              width: double.infinity,
                              height: 40,
                              child: loading
                                  ? const Center(
                                      child: CircularProgressIndicator())
                                  : MyButton(
                                      text: "Continue",
                                      borderColor: Colors.deepPurple,
                                      callback: () async {
                                        if (formKey.currentState!.validate()) {
                                          setState(() {
                                            loading = true;
                                          });
                                          // create user

                                          pinCode = pin1.text;

                                          if (widget.type ==
                                              PinCodeScreenType.CreatePin) {
                                            if (user.loginType ==
                                                LoginType.google) {
                                              googleLogin();
                                            } else {
                                              var userCred =
                                                  await AccountController
                                                      .register(user);

                                              if (userCred != null) {
                                                bool isUserCreated =
                                                    await FireStoreController
                                                        .addUser(
                                                            userCred,
                                                            user.username!,
                                                            user.password,
                                                            pinCode);

                                                if (isUserCreated == false) {
                                                  AccountController
                                                      .deleteUser();
                                                } else {
                                                  user.StoreUserToSharedPrefs();
                                                }
                                              }
                                            }
                                          } else if (widget.type ==
                                              PinCodeScreenType
                                                  .AuthenticatePin) {
                                            var userPin = await getUserPin();

                                            if (userPin == pinCode) {
                                              context.goNamed(MyScreens.home
                                                  .toShortString());
                                            } else {
                                              MyToast().showError(
                                                  'In-valid Pin Code');
                                            }
                                          }

                                          setState(() {
                                            loading = false;
                                          });
                                        }
                                      },
                                    ),
                            ),
                          )))
                ],
              ),
            )));
  }

  Widget _buildPinCodeTextField(TextEditingController controller) {
    return SizedBox(
      height: 68,
      width: 64,
      child: TextFormField(
        controller: controller,
        onChanged: (value) {
          if (value.length == 1) {
            FocusScope.of(context).nextFocus();
          } else if (value.isEmpty) {
            FocusScope.of(context).previousFocus();
          }
        },
        onSaved: (pin) {
          // Save the pin code
        },
        style: Theme.of(context).textTheme.titleLarge,
        keyboardType: TextInputType.number,
        textAlign: TextAlign.center,
        obscureText: true,
        inputFormatters: [
          LengthLimitingTextInputFormatter(1),
          FilteringTextInputFormatter.digitsOnly,
        ],
        decoration: InputDecoration(
          border: OutlineInputBorder(),
          hintText: '0',
        ),
        validator: (value) {
          if (value!.isEmpty) {
            return 'Required';
          }
          return null;
        },
      ),
    );
  }
}
